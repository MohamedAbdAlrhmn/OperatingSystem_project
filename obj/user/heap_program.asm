
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
  800031:	e8 3c 02 00 00       	call   800272 <libmain>
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
  800041:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)
	int Mega = 1024*1024;
  800048:	c7 45 d0 00 00 10 00 	movl   $0x100000,-0x30(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  80004f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	c1 e0 02             	shl    $0x2,%eax
  80005b:	01 d0                	add    %edx,%eax
  80005d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	ff 75 cc             	pushl  -0x34(%ebp)
  800066:	e8 7f 15 00 00       	call   8015ea <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 c8             	mov    %eax,-0x38(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 cc             	pushl  -0x34(%ebp)
  800077:	e8 6e 15 00 00       	call   8015ea <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c4             	mov    %eax,-0x3c(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 20 1a 00 00       	call   801aa7 <sys_pf_calculate_allocated_pages>
  800087:	89 45 c0             	mov    %eax,-0x40(%ebp)

		x[1]=-1;
  80008a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80008d:	40                   	inc    %eax
  80008e:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  800091:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800094:	89 d0                	mov    %edx,%eax
  800096:	c1 e0 02             	shl    $0x2,%eax
  800099:	01 d0                	add    %edx,%eax
  80009b:	89 c2                	mov    %eax,%edx
  80009d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000a0:	01 d0                	add    %edx,%eax
  8000a2:	c6 00 ff             	movb   $0xff,(%eax)

		//Access VA 0x200000
		int *p1 = (int *)0x200000 ;
  8000a5:	c7 45 bc 00 00 20 00 	movl   $0x200000,-0x44(%ebp)
		*p1 = -1 ;
  8000ac:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8000af:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

		y[1*Mega]=-1;
  8000b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8000b8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8000bb:	01 d0                	add    %edx,%eax
  8000bd:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000c3:	c1 e0 03             	shl    $0x3,%eax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000d0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8000d3:	89 d0                	mov    %edx,%eax
  8000d5:	01 c0                	add    %eax,%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	89 c2                	mov    %eax,%edx
  8000de:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	c6 00 ff             	movb   $0xff,(%eax)


		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;


		free(x);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 c8             	pushl  -0x38(%ebp)
  8000ec:	e8 74 15 00 00       	call   801665 <free>
  8000f1:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	ff 75 c4             	pushl  -0x3c(%ebp)
  8000fa:	e8 66 15 00 00       	call   801665 <free>
  8000ff:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800102:	e8 00 19 00 00       	call   801a07 <sys_calculate_free_frames>
  800107:	89 45 b8             	mov    %eax,-0x48(%ebp)
		x = malloc(sizeof(char)*size) ;
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	ff 75 cc             	pushl  -0x34(%ebp)
  800110:	e8 d5 14 00 00       	call   8015ea <malloc>
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	89 45 c8             	mov    %eax,-0x38(%ebp)

		//Access VA 0x200000
		*p1 = -1 ;
  80011b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80011e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


		x[1]=-2;
  800124:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800127:	40                   	inc    %eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  80012b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	c1 e0 02             	shl    $0x2,%eax
  800133:	01 d0                	add    %edx,%eax
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80013a:	01 d0                	add    %edx,%eax
  80013c:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80013f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	c6 00 fe             	movb   $0xfe,(%eax)

//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};
  80014f:	8d 45 98             	lea    -0x68(%ebp),%eax
  800152:	bb 44 39 80 00       	mov    $0x803944,%ebx
  800157:	ba 07 00 00 00       	mov    $0x7,%edx
  80015c:	89 c7                	mov    %eax,%edi
  80015e:	89 de                	mov    %ebx,%esi
  800160:	89 d1                	mov    %edx,%ecx
  800162:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

		int count = 1;
  80016b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		for (; i < 7; i++)
  800172:	e9 a4 00 00 00       	jmp    80021b <_main+0x1e3>
		{
			int found = 0 ;
  800177:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			cprintf("%d\n",count);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	ff 75 dc             	pushl  -0x24(%ebp)
  800184:	68 40 38 80 00       	push   $0x803840
  800189:	e8 d4 04 00 00       	call   800662 <cprintf>
  80018e:	83 c4 10             	add    $0x10,%esp
			count++;
  800191:	ff 45 dc             	incl   -0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800194:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80019b:	eb 3d                	jmp    8001da <_main+0x1a2>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  80019d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a0:	8b 4c 85 98          	mov    -0x68(%ebp,%eax,4),%ecx
  8001a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8001a9:	8b 98 9c 05 00 00    	mov    0x59c(%eax),%ebx
  8001af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001b2:	89 d0                	mov    %edx,%eax
  8001b4:	01 c0                	add    %eax,%eax
  8001b6:	01 d0                	add    %edx,%eax
  8001b8:	c1 e0 03             	shl    $0x3,%eax
  8001bb:	01 d8                	add    %ebx,%eax
  8001bd:	8b 00                	mov    (%eax),%eax
  8001bf:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001c2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ca:	39 c1                	cmp    %eax,%ecx
  8001cc:	75 09                	jne    8001d7 <_main+0x19f>
				{
					found = 1 ;
  8001ce:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
					break;
  8001d5:	eb 12                	jmp    8001e9 <_main+0x1b1>
		for (; i < 7; i++)
		{
			int found = 0 ;
			cprintf("%d\n",count);
			count++;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001d7:	ff 45 e0             	incl   -0x20(%ebp)
  8001da:	a1 20 50 80 00       	mov    0x805020,%eax
  8001df:	8b 50 74             	mov    0x74(%eax),%edx
  8001e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e5:	39 c2                	cmp    %eax,%edx
  8001e7:	77 b4                	ja     80019d <_main+0x165>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001e9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8001ed:	75 19                	jne    800208 <_main+0x1d0>
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
  8001ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001f2:	8b 44 85 98          	mov    -0x68(%ebp,%eax,4),%eax
  8001f6:	50                   	push   %eax
  8001f7:	68 44 38 80 00       	push   $0x803844
  8001fc:	6a 50                	push   $0x50
  8001fe:	68 a5 38 80 00       	push   $0x8038a5
  800203:	e8 a6 01 00 00       	call   8003ae <_panic>
			cprintf("done\n");
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	68 b9 38 80 00       	push   $0x8038b9
  800210:	e8 4d 04 00 00       	call   800662 <cprintf>
  800215:	83 c4 10             	add    $0x10,%esp
		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};

		int i = 0, j ;

		int count = 1;
		for (; i < 7; i++)
  800218:	ff 45 e4             	incl   -0x1c(%ebp)
  80021b:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  80021f:	0f 8e 52 ff ff ff    	jle    800177 <_main+0x13f>
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
			cprintf("done\n");
		}

		if( (freePages - sys_calculate_free_frames() ) != 6 ) panic("Extra/Less memory are wrongly allocated. diff = %d, expected = %d", freePages - sys_calculate_free_frames(), 8);
  800225:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800228:	e8 da 17 00 00       	call   801a07 <sys_calculate_free_frames>
  80022d:	29 c3                	sub    %eax,%ebx
  80022f:	89 d8                	mov    %ebx,%eax
  800231:	83 f8 06             	cmp    $0x6,%eax
  800234:	74 23                	je     800259 <_main+0x221>
  800236:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800239:	e8 c9 17 00 00       	call   801a07 <sys_calculate_free_frames>
  80023e:	29 c3                	sub    %eax,%ebx
  800240:	89 d8                	mov    %ebx,%eax
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	6a 08                	push   $0x8
  800247:	50                   	push   %eax
  800248:	68 c0 38 80 00       	push   $0x8038c0
  80024d:	6a 54                	push   $0x54
  80024f:	68 a5 38 80 00       	push   $0x8038a5
  800254:	e8 55 01 00 00       	call   8003ae <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	68 04 39 80 00       	push   $0x803904
  800261:	e8 fc 03 00 00       	call   800662 <cprintf>
  800266:	83 c4 10             	add    $0x10,%esp


	return;
  800269:	90                   	nop
}
  80026a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026d:	5b                   	pop    %ebx
  80026e:	5e                   	pop    %esi
  80026f:	5f                   	pop    %edi
  800270:	5d                   	pop    %ebp
  800271:	c3                   	ret    

00800272 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800278:	e8 6a 1a 00 00       	call   801ce7 <sys_getenvindex>
  80027d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800280:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800283:	89 d0                	mov    %edx,%eax
  800285:	c1 e0 03             	shl    $0x3,%eax
  800288:	01 d0                	add    %edx,%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	01 d0                	add    %edx,%eax
  80028e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800295:	01 d0                	add    %edx,%eax
  800297:	c1 e0 04             	shl    $0x4,%eax
  80029a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80029f:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a9:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002af:	84 c0                	test   %al,%al
  8002b1:	74 0f                	je     8002c2 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002b3:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b8:	05 5c 05 00 00       	add    $0x55c,%eax
  8002bd:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002c6:	7e 0a                	jle    8002d2 <libmain+0x60>
		binaryname = argv[0];
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	8b 00                	mov    (%eax),%eax
  8002cd:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	ff 75 0c             	pushl  0xc(%ebp)
  8002d8:	ff 75 08             	pushl  0x8(%ebp)
  8002db:	e8 58 fd ff ff       	call   800038 <_main>
  8002e0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002e3:	e8 0c 18 00 00       	call   801af4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002e8:	83 ec 0c             	sub    $0xc,%esp
  8002eb:	68 78 39 80 00       	push   $0x803978
  8002f0:	e8 6d 03 00 00       	call   800662 <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002fd:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800303:	a1 20 50 80 00       	mov    0x805020,%eax
  800308:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80030e:	83 ec 04             	sub    $0x4,%esp
  800311:	52                   	push   %edx
  800312:	50                   	push   %eax
  800313:	68 a0 39 80 00       	push   $0x8039a0
  800318:	e8 45 03 00 00       	call   800662 <cprintf>
  80031d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800320:	a1 20 50 80 00       	mov    0x805020,%eax
  800325:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80032b:	a1 20 50 80 00       	mov    0x805020,%eax
  800330:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800336:	a1 20 50 80 00       	mov    0x805020,%eax
  80033b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800341:	51                   	push   %ecx
  800342:	52                   	push   %edx
  800343:	50                   	push   %eax
  800344:	68 c8 39 80 00       	push   $0x8039c8
  800349:	e8 14 03 00 00       	call   800662 <cprintf>
  80034e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800351:	a1 20 50 80 00       	mov    0x805020,%eax
  800356:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80035c:	83 ec 08             	sub    $0x8,%esp
  80035f:	50                   	push   %eax
  800360:	68 20 3a 80 00       	push   $0x803a20
  800365:	e8 f8 02 00 00       	call   800662 <cprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 78 39 80 00       	push   $0x803978
  800375:	e8 e8 02 00 00       	call   800662 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80037d:	e8 8c 17 00 00       	call   801b0e <sys_enable_interrupt>

	// exit gracefully
	exit();
  800382:	e8 19 00 00 00       	call   8003a0 <exit>
}
  800387:	90                   	nop
  800388:	c9                   	leave  
  800389:	c3                   	ret    

0080038a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80038a:	55                   	push   %ebp
  80038b:	89 e5                	mov    %esp,%ebp
  80038d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800390:	83 ec 0c             	sub    $0xc,%esp
  800393:	6a 00                	push   $0x0
  800395:	e8 19 19 00 00       	call   801cb3 <sys_destroy_env>
  80039a:	83 c4 10             	add    $0x10,%esp
}
  80039d:	90                   	nop
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <exit>:

void
exit(void)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003a6:	e8 6e 19 00 00       	call   801d19 <sys_exit_env>
}
  8003ab:	90                   	nop
  8003ac:	c9                   	leave  
  8003ad:	c3                   	ret    

008003ae <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003b4:	8d 45 10             	lea    0x10(%ebp),%eax
  8003b7:	83 c0 04             	add    $0x4,%eax
  8003ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003bd:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8003c2:	85 c0                	test   %eax,%eax
  8003c4:	74 16                	je     8003dc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003c6:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8003cb:	83 ec 08             	sub    $0x8,%esp
  8003ce:	50                   	push   %eax
  8003cf:	68 34 3a 80 00       	push   $0x803a34
  8003d4:	e8 89 02 00 00       	call   800662 <cprintf>
  8003d9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003dc:	a1 00 50 80 00       	mov    0x805000,%eax
  8003e1:	ff 75 0c             	pushl  0xc(%ebp)
  8003e4:	ff 75 08             	pushl  0x8(%ebp)
  8003e7:	50                   	push   %eax
  8003e8:	68 39 3a 80 00       	push   $0x803a39
  8003ed:	e8 70 02 00 00       	call   800662 <cprintf>
  8003f2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f8:	83 ec 08             	sub    $0x8,%esp
  8003fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003fe:	50                   	push   %eax
  8003ff:	e8 f3 01 00 00       	call   8005f7 <vcprintf>
  800404:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800407:	83 ec 08             	sub    $0x8,%esp
  80040a:	6a 00                	push   $0x0
  80040c:	68 55 3a 80 00       	push   $0x803a55
  800411:	e8 e1 01 00 00       	call   8005f7 <vcprintf>
  800416:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800419:	e8 82 ff ff ff       	call   8003a0 <exit>

	// should not return here
	while (1) ;
  80041e:	eb fe                	jmp    80041e <_panic+0x70>

00800420 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800426:	a1 20 50 80 00       	mov    0x805020,%eax
  80042b:	8b 50 74             	mov    0x74(%eax),%edx
  80042e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800431:	39 c2                	cmp    %eax,%edx
  800433:	74 14                	je     800449 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	68 58 3a 80 00       	push   $0x803a58
  80043d:	6a 26                	push   $0x26
  80043f:	68 a4 3a 80 00       	push   $0x803aa4
  800444:	e8 65 ff ff ff       	call   8003ae <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800449:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800450:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800457:	e9 c2 00 00 00       	jmp    80051e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80045c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	01 d0                	add    %edx,%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	85 c0                	test   %eax,%eax
  80046f:	75 08                	jne    800479 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800471:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800474:	e9 a2 00 00 00       	jmp    80051b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800479:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800480:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800487:	eb 69                	jmp    8004f2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800489:	a1 20 50 80 00       	mov    0x805020,%eax
  80048e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800494:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800497:	89 d0                	mov    %edx,%eax
  800499:	01 c0                	add    %eax,%eax
  80049b:	01 d0                	add    %edx,%eax
  80049d:	c1 e0 03             	shl    $0x3,%eax
  8004a0:	01 c8                	add    %ecx,%eax
  8004a2:	8a 40 04             	mov    0x4(%eax),%al
  8004a5:	84 c0                	test   %al,%al
  8004a7:	75 46                	jne    8004ef <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ae:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004b7:	89 d0                	mov    %edx,%eax
  8004b9:	01 c0                	add    %eax,%eax
  8004bb:	01 d0                	add    %edx,%eax
  8004bd:	c1 e0 03             	shl    $0x3,%eax
  8004c0:	01 c8                	add    %ecx,%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004cf:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004d4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004db:	8b 45 08             	mov    0x8(%ebp),%eax
  8004de:	01 c8                	add    %ecx,%eax
  8004e0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004e2:	39 c2                	cmp    %eax,%edx
  8004e4:	75 09                	jne    8004ef <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004e6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004ed:	eb 12                	jmp    800501 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ef:	ff 45 e8             	incl   -0x18(%ebp)
  8004f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f7:	8b 50 74             	mov    0x74(%eax),%edx
  8004fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004fd:	39 c2                	cmp    %eax,%edx
  8004ff:	77 88                	ja     800489 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800501:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800505:	75 14                	jne    80051b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800507:	83 ec 04             	sub    $0x4,%esp
  80050a:	68 b0 3a 80 00       	push   $0x803ab0
  80050f:	6a 3a                	push   $0x3a
  800511:	68 a4 3a 80 00       	push   $0x803aa4
  800516:	e8 93 fe ff ff       	call   8003ae <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80051b:	ff 45 f0             	incl   -0x10(%ebp)
  80051e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800521:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800524:	0f 8c 32 ff ff ff    	jl     80045c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80052a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800531:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800538:	eb 26                	jmp    800560 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80053a:	a1 20 50 80 00       	mov    0x805020,%eax
  80053f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800545:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800548:	89 d0                	mov    %edx,%eax
  80054a:	01 c0                	add    %eax,%eax
  80054c:	01 d0                	add    %edx,%eax
  80054e:	c1 e0 03             	shl    $0x3,%eax
  800551:	01 c8                	add    %ecx,%eax
  800553:	8a 40 04             	mov    0x4(%eax),%al
  800556:	3c 01                	cmp    $0x1,%al
  800558:	75 03                	jne    80055d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80055a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80055d:	ff 45 e0             	incl   -0x20(%ebp)
  800560:	a1 20 50 80 00       	mov    0x805020,%eax
  800565:	8b 50 74             	mov    0x74(%eax),%edx
  800568:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056b:	39 c2                	cmp    %eax,%edx
  80056d:	77 cb                	ja     80053a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80056f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800572:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800575:	74 14                	je     80058b <CheckWSWithoutLastIndex+0x16b>
		panic(
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	68 04 3b 80 00       	push   $0x803b04
  80057f:	6a 44                	push   $0x44
  800581:	68 a4 3a 80 00       	push   $0x803aa4
  800586:	e8 23 fe ff ff       	call   8003ae <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80058b:	90                   	nop
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800594:	8b 45 0c             	mov    0xc(%ebp),%eax
  800597:	8b 00                	mov    (%eax),%eax
  800599:	8d 48 01             	lea    0x1(%eax),%ecx
  80059c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059f:	89 0a                	mov    %ecx,(%edx)
  8005a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8005a4:	88 d1                	mov    %dl,%cl
  8005a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005b7:	75 2c                	jne    8005e5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005b9:	a0 24 50 80 00       	mov    0x805024,%al
  8005be:	0f b6 c0             	movzbl %al,%eax
  8005c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c4:	8b 12                	mov    (%edx),%edx
  8005c6:	89 d1                	mov    %edx,%ecx
  8005c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005cb:	83 c2 08             	add    $0x8,%edx
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	50                   	push   %eax
  8005d2:	51                   	push   %ecx
  8005d3:	52                   	push   %edx
  8005d4:	e8 6d 13 00 00       	call   801946 <sys_cputs>
  8005d9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	8b 40 04             	mov    0x4(%eax),%eax
  8005eb:	8d 50 01             	lea    0x1(%eax),%edx
  8005ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005f4:	90                   	nop
  8005f5:	c9                   	leave  
  8005f6:	c3                   	ret    

008005f7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005f7:	55                   	push   %ebp
  8005f8:	89 e5                	mov    %esp,%ebp
  8005fa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800600:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800607:	00 00 00 
	b.cnt = 0;
  80060a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800611:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800614:	ff 75 0c             	pushl  0xc(%ebp)
  800617:	ff 75 08             	pushl  0x8(%ebp)
  80061a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800620:	50                   	push   %eax
  800621:	68 8e 05 80 00       	push   $0x80058e
  800626:	e8 11 02 00 00       	call   80083c <vprintfmt>
  80062b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80062e:	a0 24 50 80 00       	mov    0x805024,%al
  800633:	0f b6 c0             	movzbl %al,%eax
  800636:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80063c:	83 ec 04             	sub    $0x4,%esp
  80063f:	50                   	push   %eax
  800640:	52                   	push   %edx
  800641:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800647:	83 c0 08             	add    $0x8,%eax
  80064a:	50                   	push   %eax
  80064b:	e8 f6 12 00 00       	call   801946 <sys_cputs>
  800650:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800653:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80065a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800660:	c9                   	leave  
  800661:	c3                   	ret    

00800662 <cprintf>:

int cprintf(const char *fmt, ...) {
  800662:	55                   	push   %ebp
  800663:	89 e5                	mov    %esp,%ebp
  800665:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800668:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80066f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800672:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800675:	8b 45 08             	mov    0x8(%ebp),%eax
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	ff 75 f4             	pushl  -0xc(%ebp)
  80067e:	50                   	push   %eax
  80067f:	e8 73 ff ff ff       	call   8005f7 <vcprintf>
  800684:	83 c4 10             	add    $0x10,%esp
  800687:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80068a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80068d:	c9                   	leave  
  80068e:	c3                   	ret    

0080068f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800695:	e8 5a 14 00 00       	call   801af4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80069a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80069d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8006a9:	50                   	push   %eax
  8006aa:	e8 48 ff ff ff       	call   8005f7 <vcprintf>
  8006af:	83 c4 10             	add    $0x10,%esp
  8006b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006b5:	e8 54 14 00 00       	call   801b0e <sys_enable_interrupt>
	return cnt;
  8006ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006bd:	c9                   	leave  
  8006be:	c3                   	ret    

008006bf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	53                   	push   %ebx
  8006c3:	83 ec 14             	sub    $0x14,%esp
  8006c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8006c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006d2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006da:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006dd:	77 55                	ja     800734 <printnum+0x75>
  8006df:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006e2:	72 05                	jb     8006e9 <printnum+0x2a>
  8006e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006e7:	77 4b                	ja     800734 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006e9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ec:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006ef:	8b 45 18             	mov    0x18(%ebp),%eax
  8006f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f7:	52                   	push   %edx
  8006f8:	50                   	push   %eax
  8006f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006ff:	e8 c8 2e 00 00       	call   8035cc <__udivdi3>
  800704:	83 c4 10             	add    $0x10,%esp
  800707:	83 ec 04             	sub    $0x4,%esp
  80070a:	ff 75 20             	pushl  0x20(%ebp)
  80070d:	53                   	push   %ebx
  80070e:	ff 75 18             	pushl  0x18(%ebp)
  800711:	52                   	push   %edx
  800712:	50                   	push   %eax
  800713:	ff 75 0c             	pushl  0xc(%ebp)
  800716:	ff 75 08             	pushl  0x8(%ebp)
  800719:	e8 a1 ff ff ff       	call   8006bf <printnum>
  80071e:	83 c4 20             	add    $0x20,%esp
  800721:	eb 1a                	jmp    80073d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	ff 75 0c             	pushl  0xc(%ebp)
  800729:	ff 75 20             	pushl  0x20(%ebp)
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	ff d0                	call   *%eax
  800731:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800734:	ff 4d 1c             	decl   0x1c(%ebp)
  800737:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80073b:	7f e6                	jg     800723 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80073d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800740:	bb 00 00 00 00       	mov    $0x0,%ebx
  800745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800748:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80074b:	53                   	push   %ebx
  80074c:	51                   	push   %ecx
  80074d:	52                   	push   %edx
  80074e:	50                   	push   %eax
  80074f:	e8 88 2f 00 00       	call   8036dc <__umoddi3>
  800754:	83 c4 10             	add    $0x10,%esp
  800757:	05 74 3d 80 00       	add    $0x803d74,%eax
  80075c:	8a 00                	mov    (%eax),%al
  80075e:	0f be c0             	movsbl %al,%eax
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	50                   	push   %eax
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	ff d0                	call   *%eax
  80076d:	83 c4 10             	add    $0x10,%esp
}
  800770:	90                   	nop
  800771:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800774:	c9                   	leave  
  800775:	c3                   	ret    

00800776 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800779:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80077d:	7e 1c                	jle    80079b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	8d 50 08             	lea    0x8(%eax),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	89 10                	mov    %edx,(%eax)
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	83 e8 08             	sub    $0x8,%eax
  800794:	8b 50 04             	mov    0x4(%eax),%edx
  800797:	8b 00                	mov    (%eax),%eax
  800799:	eb 40                	jmp    8007db <getuint+0x65>
	else if (lflag)
  80079b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80079f:	74 1e                	je     8007bf <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	8d 50 04             	lea    0x4(%eax),%edx
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	89 10                	mov    %edx,(%eax)
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bd:	eb 1c                	jmp    8007db <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	8d 50 04             	lea    0x4(%eax),%edx
  8007c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ca:	89 10                	mov    %edx,(%eax)
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	83 e8 04             	sub    $0x4,%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007db:	5d                   	pop    %ebp
  8007dc:	c3                   	ret    

008007dd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007dd:	55                   	push   %ebp
  8007de:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007e0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007e4:	7e 1c                	jle    800802 <getint+0x25>
		return va_arg(*ap, long long);
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	8d 50 08             	lea    0x8(%eax),%edx
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	89 10                	mov    %edx,(%eax)
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	83 e8 08             	sub    $0x8,%eax
  8007fb:	8b 50 04             	mov    0x4(%eax),%edx
  8007fe:	8b 00                	mov    (%eax),%eax
  800800:	eb 38                	jmp    80083a <getint+0x5d>
	else if (lflag)
  800802:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800806:	74 1a                	je     800822 <getint+0x45>
		return va_arg(*ap, long);
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	8d 50 04             	lea    0x4(%eax),%edx
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	89 10                	mov    %edx,(%eax)
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	8b 00                	mov    (%eax),%eax
  80081a:	83 e8 04             	sub    $0x4,%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	99                   	cltd   
  800820:	eb 18                	jmp    80083a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	8b 00                	mov    (%eax),%eax
  800827:	8d 50 04             	lea    0x4(%eax),%edx
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	89 10                	mov    %edx,(%eax)
  80082f:	8b 45 08             	mov    0x8(%ebp),%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	83 e8 04             	sub    $0x4,%eax
  800837:	8b 00                	mov    (%eax),%eax
  800839:	99                   	cltd   
}
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    

0080083c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	56                   	push   %esi
  800840:	53                   	push   %ebx
  800841:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800844:	eb 17                	jmp    80085d <vprintfmt+0x21>
			if (ch == '\0')
  800846:	85 db                	test   %ebx,%ebx
  800848:	0f 84 af 03 00 00    	je     800bfd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	ff 75 0c             	pushl  0xc(%ebp)
  800854:	53                   	push   %ebx
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	ff d0                	call   *%eax
  80085a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80085d:	8b 45 10             	mov    0x10(%ebp),%eax
  800860:	8d 50 01             	lea    0x1(%eax),%edx
  800863:	89 55 10             	mov    %edx,0x10(%ebp)
  800866:	8a 00                	mov    (%eax),%al
  800868:	0f b6 d8             	movzbl %al,%ebx
  80086b:	83 fb 25             	cmp    $0x25,%ebx
  80086e:	75 d6                	jne    800846 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800870:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800874:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80087b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800882:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800889:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800890:	8b 45 10             	mov    0x10(%ebp),%eax
  800893:	8d 50 01             	lea    0x1(%eax),%edx
  800896:	89 55 10             	mov    %edx,0x10(%ebp)
  800899:	8a 00                	mov    (%eax),%al
  80089b:	0f b6 d8             	movzbl %al,%ebx
  80089e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008a1:	83 f8 55             	cmp    $0x55,%eax
  8008a4:	0f 87 2b 03 00 00    	ja     800bd5 <vprintfmt+0x399>
  8008aa:	8b 04 85 98 3d 80 00 	mov    0x803d98(,%eax,4),%eax
  8008b1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008b3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008b7:	eb d7                	jmp    800890 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008b9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008bd:	eb d1                	jmp    800890 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c9:	89 d0                	mov    %edx,%eax
  8008cb:	c1 e0 02             	shl    $0x2,%eax
  8008ce:	01 d0                	add    %edx,%eax
  8008d0:	01 c0                	add    %eax,%eax
  8008d2:	01 d8                	add    %ebx,%eax
  8008d4:	83 e8 30             	sub    $0x30,%eax
  8008d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008da:	8b 45 10             	mov    0x10(%ebp),%eax
  8008dd:	8a 00                	mov    (%eax),%al
  8008df:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008e2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008e5:	7e 3e                	jle    800925 <vprintfmt+0xe9>
  8008e7:	83 fb 39             	cmp    $0x39,%ebx
  8008ea:	7f 39                	jg     800925 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ec:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008ef:	eb d5                	jmp    8008c6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f4:	83 c0 04             	add    $0x4,%eax
  8008f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fd:	83 e8 04             	sub    $0x4,%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800905:	eb 1f                	jmp    800926 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800907:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80090b:	79 83                	jns    800890 <vprintfmt+0x54>
				width = 0;
  80090d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800914:	e9 77 ff ff ff       	jmp    800890 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800919:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800920:	e9 6b ff ff ff       	jmp    800890 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800925:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800926:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092a:	0f 89 60 ff ff ff    	jns    800890 <vprintfmt+0x54>
				width = precision, precision = -1;
  800930:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800933:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800936:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80093d:	e9 4e ff ff ff       	jmp    800890 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800942:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800945:	e9 46 ff ff ff       	jmp    800890 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80094a:	8b 45 14             	mov    0x14(%ebp),%eax
  80094d:	83 c0 04             	add    $0x4,%eax
  800950:	89 45 14             	mov    %eax,0x14(%ebp)
  800953:	8b 45 14             	mov    0x14(%ebp),%eax
  800956:	83 e8 04             	sub    $0x4,%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	50                   	push   %eax
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	ff d0                	call   *%eax
  800967:	83 c4 10             	add    $0x10,%esp
			break;
  80096a:	e9 89 02 00 00       	jmp    800bf8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80096f:	8b 45 14             	mov    0x14(%ebp),%eax
  800972:	83 c0 04             	add    $0x4,%eax
  800975:	89 45 14             	mov    %eax,0x14(%ebp)
  800978:	8b 45 14             	mov    0x14(%ebp),%eax
  80097b:	83 e8 04             	sub    $0x4,%eax
  80097e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800980:	85 db                	test   %ebx,%ebx
  800982:	79 02                	jns    800986 <vprintfmt+0x14a>
				err = -err;
  800984:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800986:	83 fb 64             	cmp    $0x64,%ebx
  800989:	7f 0b                	jg     800996 <vprintfmt+0x15a>
  80098b:	8b 34 9d e0 3b 80 00 	mov    0x803be0(,%ebx,4),%esi
  800992:	85 f6                	test   %esi,%esi
  800994:	75 19                	jne    8009af <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800996:	53                   	push   %ebx
  800997:	68 85 3d 80 00       	push   $0x803d85
  80099c:	ff 75 0c             	pushl  0xc(%ebp)
  80099f:	ff 75 08             	pushl  0x8(%ebp)
  8009a2:	e8 5e 02 00 00       	call   800c05 <printfmt>
  8009a7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009aa:	e9 49 02 00 00       	jmp    800bf8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009af:	56                   	push   %esi
  8009b0:	68 8e 3d 80 00       	push   $0x803d8e
  8009b5:	ff 75 0c             	pushl  0xc(%ebp)
  8009b8:	ff 75 08             	pushl  0x8(%ebp)
  8009bb:	e8 45 02 00 00       	call   800c05 <printfmt>
  8009c0:	83 c4 10             	add    $0x10,%esp
			break;
  8009c3:	e9 30 02 00 00       	jmp    800bf8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cb:	83 c0 04             	add    $0x4,%eax
  8009ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d4:	83 e8 04             	sub    $0x4,%eax
  8009d7:	8b 30                	mov    (%eax),%esi
  8009d9:	85 f6                	test   %esi,%esi
  8009db:	75 05                	jne    8009e2 <vprintfmt+0x1a6>
				p = "(null)";
  8009dd:	be 91 3d 80 00       	mov    $0x803d91,%esi
			if (width > 0 && padc != '-')
  8009e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e6:	7e 6d                	jle    800a55 <vprintfmt+0x219>
  8009e8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ec:	74 67                	je     800a55 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	50                   	push   %eax
  8009f5:	56                   	push   %esi
  8009f6:	e8 0c 03 00 00       	call   800d07 <strnlen>
  8009fb:	83 c4 10             	add    $0x10,%esp
  8009fe:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a01:	eb 16                	jmp    800a19 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a03:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a07:	83 ec 08             	sub    $0x8,%esp
  800a0a:	ff 75 0c             	pushl  0xc(%ebp)
  800a0d:	50                   	push   %eax
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	ff d0                	call   *%eax
  800a13:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a16:	ff 4d e4             	decl   -0x1c(%ebp)
  800a19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1d:	7f e4                	jg     800a03 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a1f:	eb 34                	jmp    800a55 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a21:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a25:	74 1c                	je     800a43 <vprintfmt+0x207>
  800a27:	83 fb 1f             	cmp    $0x1f,%ebx
  800a2a:	7e 05                	jle    800a31 <vprintfmt+0x1f5>
  800a2c:	83 fb 7e             	cmp    $0x7e,%ebx
  800a2f:	7e 12                	jle    800a43 <vprintfmt+0x207>
					putch('?', putdat);
  800a31:	83 ec 08             	sub    $0x8,%esp
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	6a 3f                	push   $0x3f
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	ff d0                	call   *%eax
  800a3e:	83 c4 10             	add    $0x10,%esp
  800a41:	eb 0f                	jmp    800a52 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	53                   	push   %ebx
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a52:	ff 4d e4             	decl   -0x1c(%ebp)
  800a55:	89 f0                	mov    %esi,%eax
  800a57:	8d 70 01             	lea    0x1(%eax),%esi
  800a5a:	8a 00                	mov    (%eax),%al
  800a5c:	0f be d8             	movsbl %al,%ebx
  800a5f:	85 db                	test   %ebx,%ebx
  800a61:	74 24                	je     800a87 <vprintfmt+0x24b>
  800a63:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a67:	78 b8                	js     800a21 <vprintfmt+0x1e5>
  800a69:	ff 4d e0             	decl   -0x20(%ebp)
  800a6c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a70:	79 af                	jns    800a21 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a72:	eb 13                	jmp    800a87 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	6a 20                	push   $0x20
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	ff d0                	call   *%eax
  800a81:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a84:	ff 4d e4             	decl   -0x1c(%ebp)
  800a87:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a8b:	7f e7                	jg     800a74 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a8d:	e9 66 01 00 00       	jmp    800bf8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a92:	83 ec 08             	sub    $0x8,%esp
  800a95:	ff 75 e8             	pushl  -0x18(%ebp)
  800a98:	8d 45 14             	lea    0x14(%ebp),%eax
  800a9b:	50                   	push   %eax
  800a9c:	e8 3c fd ff ff       	call   8007dd <getint>
  800aa1:	83 c4 10             	add    $0x10,%esp
  800aa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab0:	85 d2                	test   %edx,%edx
  800ab2:	79 23                	jns    800ad7 <vprintfmt+0x29b>
				putch('-', putdat);
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	6a 2d                	push   $0x2d
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aca:	f7 d8                	neg    %eax
  800acc:	83 d2 00             	adc    $0x0,%edx
  800acf:	f7 da                	neg    %edx
  800ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ad7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ade:	e9 bc 00 00 00       	jmp    800b9f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aec:	50                   	push   %eax
  800aed:	e8 84 fc ff ff       	call   800776 <getuint>
  800af2:	83 c4 10             	add    $0x10,%esp
  800af5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800afb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b02:	e9 98 00 00 00       	jmp    800b9f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	ff 75 0c             	pushl  0xc(%ebp)
  800b0d:	6a 58                	push   $0x58
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	ff d0                	call   *%eax
  800b14:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b17:	83 ec 08             	sub    $0x8,%esp
  800b1a:	ff 75 0c             	pushl  0xc(%ebp)
  800b1d:	6a 58                	push   $0x58
  800b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b22:	ff d0                	call   *%eax
  800b24:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	6a 58                	push   $0x58
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	ff d0                	call   *%eax
  800b34:	83 c4 10             	add    $0x10,%esp
			break;
  800b37:	e9 bc 00 00 00       	jmp    800bf8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	6a 30                	push   $0x30
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	ff d0                	call   *%eax
  800b49:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b4c:	83 ec 08             	sub    $0x8,%esp
  800b4f:	ff 75 0c             	pushl  0xc(%ebp)
  800b52:	6a 78                	push   $0x78
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	ff d0                	call   *%eax
  800b59:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5f:	83 c0 04             	add    $0x4,%eax
  800b62:	89 45 14             	mov    %eax,0x14(%ebp)
  800b65:	8b 45 14             	mov    0x14(%ebp),%eax
  800b68:	83 e8 04             	sub    $0x4,%eax
  800b6b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b77:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b7e:	eb 1f                	jmp    800b9f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 e8             	pushl  -0x18(%ebp)
  800b86:	8d 45 14             	lea    0x14(%ebp),%eax
  800b89:	50                   	push   %eax
  800b8a:	e8 e7 fb ff ff       	call   800776 <getuint>
  800b8f:	83 c4 10             	add    $0x10,%esp
  800b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b95:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b9f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ba3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ba6:	83 ec 04             	sub    $0x4,%esp
  800ba9:	52                   	push   %edx
  800baa:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bad:	50                   	push   %eax
  800bae:	ff 75 f4             	pushl  -0xc(%ebp)
  800bb1:	ff 75 f0             	pushl  -0x10(%ebp)
  800bb4:	ff 75 0c             	pushl  0xc(%ebp)
  800bb7:	ff 75 08             	pushl  0x8(%ebp)
  800bba:	e8 00 fb ff ff       	call   8006bf <printnum>
  800bbf:	83 c4 20             	add    $0x20,%esp
			break;
  800bc2:	eb 34                	jmp    800bf8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 0c             	pushl  0xc(%ebp)
  800bca:	53                   	push   %ebx
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	ff d0                	call   *%eax
  800bd0:	83 c4 10             	add    $0x10,%esp
			break;
  800bd3:	eb 23                	jmp    800bf8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bd5:	83 ec 08             	sub    $0x8,%esp
  800bd8:	ff 75 0c             	pushl  0xc(%ebp)
  800bdb:	6a 25                	push   $0x25
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	ff d0                	call   *%eax
  800be2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800be5:	ff 4d 10             	decl   0x10(%ebp)
  800be8:	eb 03                	jmp    800bed <vprintfmt+0x3b1>
  800bea:	ff 4d 10             	decl   0x10(%ebp)
  800bed:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf0:	48                   	dec    %eax
  800bf1:	8a 00                	mov    (%eax),%al
  800bf3:	3c 25                	cmp    $0x25,%al
  800bf5:	75 f3                	jne    800bea <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bf7:	90                   	nop
		}
	}
  800bf8:	e9 47 fc ff ff       	jmp    800844 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bfd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c01:	5b                   	pop    %ebx
  800c02:	5e                   	pop    %esi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c0b:	8d 45 10             	lea    0x10(%ebp),%eax
  800c0e:	83 c0 04             	add    $0x4,%eax
  800c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c14:	8b 45 10             	mov    0x10(%ebp),%eax
  800c17:	ff 75 f4             	pushl  -0xc(%ebp)
  800c1a:	50                   	push   %eax
  800c1b:	ff 75 0c             	pushl  0xc(%ebp)
  800c1e:	ff 75 08             	pushl  0x8(%ebp)
  800c21:	e8 16 fc ff ff       	call   80083c <vprintfmt>
  800c26:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c29:	90                   	nop
  800c2a:	c9                   	leave  
  800c2b:	c3                   	ret    

00800c2c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c32:	8b 40 08             	mov    0x8(%eax),%eax
  800c35:	8d 50 01             	lea    0x1(%eax),%edx
  800c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	8b 10                	mov    (%eax),%edx
  800c43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c46:	8b 40 04             	mov    0x4(%eax),%eax
  800c49:	39 c2                	cmp    %eax,%edx
  800c4b:	73 12                	jae    800c5f <sprintputch+0x33>
		*b->buf++ = ch;
  800c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c50:	8b 00                	mov    (%eax),%eax
  800c52:	8d 48 01             	lea    0x1(%eax),%ecx
  800c55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c58:	89 0a                	mov    %ecx,(%edx)
  800c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5d:	88 10                	mov    %dl,(%eax)
}
  800c5f:	90                   	nop
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	01 d0                	add    %edx,%eax
  800c79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c87:	74 06                	je     800c8f <vsnprintf+0x2d>
  800c89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8d:	7f 07                	jg     800c96 <vsnprintf+0x34>
		return -E_INVAL;
  800c8f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c94:	eb 20                	jmp    800cb6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c96:	ff 75 14             	pushl  0x14(%ebp)
  800c99:	ff 75 10             	pushl  0x10(%ebp)
  800c9c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c9f:	50                   	push   %eax
  800ca0:	68 2c 0c 80 00       	push   $0x800c2c
  800ca5:	e8 92 fb ff ff       	call   80083c <vprintfmt>
  800caa:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cb6:	c9                   	leave  
  800cb7:	c3                   	ret    

00800cb8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cbe:	8d 45 10             	lea    0x10(%ebp),%eax
  800cc1:	83 c0 04             	add    $0x4,%eax
  800cc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cca:	ff 75 f4             	pushl  -0xc(%ebp)
  800ccd:	50                   	push   %eax
  800cce:	ff 75 0c             	pushl  0xc(%ebp)
  800cd1:	ff 75 08             	pushl  0x8(%ebp)
  800cd4:	e8 89 ff ff ff       	call   800c62 <vsnprintf>
  800cd9:	83 c4 10             	add    $0x10,%esp
  800cdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ce2:	c9                   	leave  
  800ce3:	c3                   	ret    

00800ce4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf1:	eb 06                	jmp    800cf9 <strlen+0x15>
		n++;
  800cf3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf6:	ff 45 08             	incl   0x8(%ebp)
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8a 00                	mov    (%eax),%al
  800cfe:	84 c0                	test   %al,%al
  800d00:	75 f1                	jne    800cf3 <strlen+0xf>
		n++;
	return n;
  800d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d05:	c9                   	leave  
  800d06:	c3                   	ret    

00800d07 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d14:	eb 09                	jmp    800d1f <strnlen+0x18>
		n++;
  800d16:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d19:	ff 45 08             	incl   0x8(%ebp)
  800d1c:	ff 4d 0c             	decl   0xc(%ebp)
  800d1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d23:	74 09                	je     800d2e <strnlen+0x27>
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	84 c0                	test   %al,%al
  800d2c:	75 e8                	jne    800d16 <strnlen+0xf>
		n++;
	return n;
  800d2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d31:	c9                   	leave  
  800d32:	c3                   	ret    

00800d33 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d3f:	90                   	nop
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8d 50 01             	lea    0x1(%eax),%edx
  800d46:	89 55 08             	mov    %edx,0x8(%ebp)
  800d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d52:	8a 12                	mov    (%edx),%dl
  800d54:	88 10                	mov    %dl,(%eax)
  800d56:	8a 00                	mov    (%eax),%al
  800d58:	84 c0                	test   %al,%al
  800d5a:	75 e4                	jne    800d40 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d5f:	c9                   	leave  
  800d60:	c3                   	ret    

00800d61 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d74:	eb 1f                	jmp    800d95 <strncpy+0x34>
		*dst++ = *src;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d82:	8a 12                	mov    (%edx),%dl
  800d84:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d89:	8a 00                	mov    (%eax),%al
  800d8b:	84 c0                	test   %al,%al
  800d8d:	74 03                	je     800d92 <strncpy+0x31>
			src++;
  800d8f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d92:	ff 45 fc             	incl   -0x4(%ebp)
  800d95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d98:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d9b:	72 d9                	jb     800d76 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800da0:	c9                   	leave  
  800da1:	c3                   	ret    

00800da2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db2:	74 30                	je     800de4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800db4:	eb 16                	jmp    800dcc <strlcpy+0x2a>
			*dst++ = *src++;
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8d 50 01             	lea    0x1(%eax),%edx
  800dbc:	89 55 08             	mov    %edx,0x8(%ebp)
  800dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dc5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800dc8:	8a 12                	mov    (%edx),%dl
  800dca:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dcc:	ff 4d 10             	decl   0x10(%ebp)
  800dcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd3:	74 09                	je     800dde <strlcpy+0x3c>
  800dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd8:	8a 00                	mov    (%eax),%al
  800dda:	84 c0                	test   %al,%al
  800ddc:	75 d8                	jne    800db6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800de4:	8b 55 08             	mov    0x8(%ebp),%edx
  800de7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dea:	29 c2                	sub    %eax,%edx
  800dec:	89 d0                	mov    %edx,%eax
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800df3:	eb 06                	jmp    800dfb <strcmp+0xb>
		p++, q++;
  800df5:	ff 45 08             	incl   0x8(%ebp)
  800df8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8a 00                	mov    (%eax),%al
  800e00:	84 c0                	test   %al,%al
  800e02:	74 0e                	je     800e12 <strcmp+0x22>
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8a 10                	mov    (%eax),%dl
  800e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	38 c2                	cmp    %al,%dl
  800e10:	74 e3                	je     800df5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	8a 00                	mov    (%eax),%al
  800e17:	0f b6 d0             	movzbl %al,%edx
  800e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	0f b6 c0             	movzbl %al,%eax
  800e22:	29 c2                	sub    %eax,%edx
  800e24:	89 d0                	mov    %edx,%eax
}
  800e26:	5d                   	pop    %ebp
  800e27:	c3                   	ret    

00800e28 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e2b:	eb 09                	jmp    800e36 <strncmp+0xe>
		n--, p++, q++;
  800e2d:	ff 4d 10             	decl   0x10(%ebp)
  800e30:	ff 45 08             	incl   0x8(%ebp)
  800e33:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3a:	74 17                	je     800e53 <strncmp+0x2b>
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	8a 00                	mov    (%eax),%al
  800e41:	84 c0                	test   %al,%al
  800e43:	74 0e                	je     800e53 <strncmp+0x2b>
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8a 10                	mov    (%eax),%dl
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	38 c2                	cmp    %al,%dl
  800e51:	74 da                	je     800e2d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e57:	75 07                	jne    800e60 <strncmp+0x38>
		return 0;
  800e59:	b8 00 00 00 00       	mov    $0x0,%eax
  800e5e:	eb 14                	jmp    800e74 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f b6 d0             	movzbl %al,%edx
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	0f b6 c0             	movzbl %al,%eax
  800e70:	29 c2                	sub    %eax,%edx
  800e72:	89 d0                	mov    %edx,%eax
}
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 04             	sub    $0x4,%esp
  800e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e82:	eb 12                	jmp    800e96 <strchr+0x20>
		if (*s == c)
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e8c:	75 05                	jne    800e93 <strchr+0x1d>
			return (char *) s;
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	eb 11                	jmp    800ea4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e93:	ff 45 08             	incl   0x8(%ebp)
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	84 c0                	test   %al,%al
  800e9d:	75 e5                	jne    800e84 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea4:	c9                   	leave  
  800ea5:	c3                   	ret    

00800ea6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	83 ec 04             	sub    $0x4,%esp
  800eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eb2:	eb 0d                	jmp    800ec1 <strfind+0x1b>
		if (*s == c)
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	8a 00                	mov    (%eax),%al
  800eb9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ebc:	74 0e                	je     800ecc <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ebe:	ff 45 08             	incl   0x8(%ebp)
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	84 c0                	test   %al,%al
  800ec8:	75 ea                	jne    800eb4 <strfind+0xe>
  800eca:	eb 01                	jmp    800ecd <strfind+0x27>
		if (*s == c)
			break;
  800ecc:	90                   	nop
	return (char *) s;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed0:	c9                   	leave  
  800ed1:	c3                   	ret    

00800ed2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ede:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ee4:	eb 0e                	jmp    800ef4 <memset+0x22>
		*p++ = c;
  800ee6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee9:	8d 50 01             	lea    0x1(%eax),%edx
  800eec:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ef4:	ff 4d f8             	decl   -0x8(%ebp)
  800ef7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800efb:	79 e9                	jns    800ee6 <memset+0x14>
		*p++ = c;

	return v;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f00:	c9                   	leave  
  800f01:	c3                   	ret    

00800f02 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f14:	eb 16                	jmp    800f2c <memcpy+0x2a>
		*d++ = *s++;
  800f16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f19:	8d 50 01             	lea    0x1(%eax),%edx
  800f1c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f22:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f25:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f28:	8a 12                	mov    (%edx),%dl
  800f2a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f32:	89 55 10             	mov    %edx,0x10(%ebp)
  800f35:	85 c0                	test   %eax,%eax
  800f37:	75 dd                	jne    800f16 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f53:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f56:	73 50                	jae    800fa8 <memmove+0x6a>
  800f58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5e:	01 d0                	add    %edx,%eax
  800f60:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f63:	76 43                	jbe    800fa8 <memmove+0x6a>
		s += n;
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f71:	eb 10                	jmp    800f83 <memmove+0x45>
			*--d = *--s;
  800f73:	ff 4d f8             	decl   -0x8(%ebp)
  800f76:	ff 4d fc             	decl   -0x4(%ebp)
  800f79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7c:	8a 10                	mov    (%eax),%dl
  800f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f81:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f83:	8b 45 10             	mov    0x10(%ebp),%eax
  800f86:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f89:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8c:	85 c0                	test   %eax,%eax
  800f8e:	75 e3                	jne    800f73 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f90:	eb 23                	jmp    800fb5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f95:	8d 50 01             	lea    0x1(%eax),%edx
  800f98:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f9b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fa1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fa4:	8a 12                	mov    (%edx),%dl
  800fa6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fa8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fab:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fae:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb1:	85 c0                	test   %eax,%eax
  800fb3:	75 dd                	jne    800f92 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fb8:	c9                   	leave  
  800fb9:	c3                   	ret    

00800fba <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fcc:	eb 2a                	jmp    800ff8 <memcmp+0x3e>
		if (*s1 != *s2)
  800fce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd1:	8a 10                	mov    (%eax),%dl
  800fd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	38 c2                	cmp    %al,%dl
  800fda:	74 16                	je     800ff2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	0f b6 d0             	movzbl %al,%edx
  800fe4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	0f b6 c0             	movzbl %al,%eax
  800fec:	29 c2                	sub    %eax,%edx
  800fee:	89 d0                	mov    %edx,%eax
  800ff0:	eb 18                	jmp    80100a <memcmp+0x50>
		s1++, s2++;
  800ff2:	ff 45 fc             	incl   -0x4(%ebp)
  800ff5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ff8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffe:	89 55 10             	mov    %edx,0x10(%ebp)
  801001:	85 c0                	test   %eax,%eax
  801003:	75 c9                	jne    800fce <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801005:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801012:	8b 55 08             	mov    0x8(%ebp),%edx
  801015:	8b 45 10             	mov    0x10(%ebp),%eax
  801018:	01 d0                	add    %edx,%eax
  80101a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80101d:	eb 15                	jmp    801034 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	0f b6 d0             	movzbl %al,%edx
  801027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102a:	0f b6 c0             	movzbl %al,%eax
  80102d:	39 c2                	cmp    %eax,%edx
  80102f:	74 0d                	je     80103e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801031:	ff 45 08             	incl   0x8(%ebp)
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80103a:	72 e3                	jb     80101f <memfind+0x13>
  80103c:	eb 01                	jmp    80103f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80103e:	90                   	nop
	return (void *) s;
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801042:	c9                   	leave  
  801043:	c3                   	ret    

00801044 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80104a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801051:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801058:	eb 03                	jmp    80105d <strtol+0x19>
		s++;
  80105a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	3c 20                	cmp    $0x20,%al
  801064:	74 f4                	je     80105a <strtol+0x16>
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 09                	cmp    $0x9,%al
  80106d:	74 eb                	je     80105a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	8a 00                	mov    (%eax),%al
  801074:	3c 2b                	cmp    $0x2b,%al
  801076:	75 05                	jne    80107d <strtol+0x39>
		s++;
  801078:	ff 45 08             	incl   0x8(%ebp)
  80107b:	eb 13                	jmp    801090 <strtol+0x4c>
	else if (*s == '-')
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	3c 2d                	cmp    $0x2d,%al
  801084:	75 0a                	jne    801090 <strtol+0x4c>
		s++, neg = 1;
  801086:	ff 45 08             	incl   0x8(%ebp)
  801089:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801090:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801094:	74 06                	je     80109c <strtol+0x58>
  801096:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80109a:	75 20                	jne    8010bc <strtol+0x78>
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	3c 30                	cmp    $0x30,%al
  8010a3:	75 17                	jne    8010bc <strtol+0x78>
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	40                   	inc    %eax
  8010a9:	8a 00                	mov    (%eax),%al
  8010ab:	3c 78                	cmp    $0x78,%al
  8010ad:	75 0d                	jne    8010bc <strtol+0x78>
		s += 2, base = 16;
  8010af:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010b3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010ba:	eb 28                	jmp    8010e4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c0:	75 15                	jne    8010d7 <strtol+0x93>
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	3c 30                	cmp    $0x30,%al
  8010c9:	75 0c                	jne    8010d7 <strtol+0x93>
		s++, base = 8;
  8010cb:	ff 45 08             	incl   0x8(%ebp)
  8010ce:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010d5:	eb 0d                	jmp    8010e4 <strtol+0xa0>
	else if (base == 0)
  8010d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010db:	75 07                	jne    8010e4 <strtol+0xa0>
		base = 10;
  8010dd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	3c 2f                	cmp    $0x2f,%al
  8010eb:	7e 19                	jle    801106 <strtol+0xc2>
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	3c 39                	cmp    $0x39,%al
  8010f4:	7f 10                	jg     801106 <strtol+0xc2>
			dig = *s - '0';
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	0f be c0             	movsbl %al,%eax
  8010fe:	83 e8 30             	sub    $0x30,%eax
  801101:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801104:	eb 42                	jmp    801148 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	3c 60                	cmp    $0x60,%al
  80110d:	7e 19                	jle    801128 <strtol+0xe4>
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	8a 00                	mov    (%eax),%al
  801114:	3c 7a                	cmp    $0x7a,%al
  801116:	7f 10                	jg     801128 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	0f be c0             	movsbl %al,%eax
  801120:	83 e8 57             	sub    $0x57,%eax
  801123:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801126:	eb 20                	jmp    801148 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	3c 40                	cmp    $0x40,%al
  80112f:	7e 39                	jle    80116a <strtol+0x126>
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	3c 5a                	cmp    $0x5a,%al
  801138:	7f 30                	jg     80116a <strtol+0x126>
			dig = *s - 'A' + 10;
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	8a 00                	mov    (%eax),%al
  80113f:	0f be c0             	movsbl %al,%eax
  801142:	83 e8 37             	sub    $0x37,%eax
  801145:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80114e:	7d 19                	jge    801169 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801150:	ff 45 08             	incl   0x8(%ebp)
  801153:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801156:	0f af 45 10          	imul   0x10(%ebp),%eax
  80115a:	89 c2                	mov    %eax,%edx
  80115c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115f:	01 d0                	add    %edx,%eax
  801161:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801164:	e9 7b ff ff ff       	jmp    8010e4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801169:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80116a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80116e:	74 08                	je     801178 <strtol+0x134>
		*endptr = (char *) s;
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	8b 55 08             	mov    0x8(%ebp),%edx
  801176:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801178:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80117c:	74 07                	je     801185 <strtol+0x141>
  80117e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801181:	f7 d8                	neg    %eax
  801183:	eb 03                	jmp    801188 <strtol+0x144>
  801185:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <ltostr>:

void
ltostr(long value, char *str)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801190:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801197:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80119e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011a2:	79 13                	jns    8011b7 <ltostr+0x2d>
	{
		neg = 1;
  8011a4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011b1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011b4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011bf:	99                   	cltd   
  8011c0:	f7 f9                	idiv   %ecx
  8011c2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c8:	8d 50 01             	lea    0x1(%eax),%edx
  8011cb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	01 d0                	add    %edx,%eax
  8011d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011d8:	83 c2 30             	add    $0x30,%edx
  8011db:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e5:	f7 e9                	imul   %ecx
  8011e7:	c1 fa 02             	sar    $0x2,%edx
  8011ea:	89 c8                	mov    %ecx,%eax
  8011ec:	c1 f8 1f             	sar    $0x1f,%eax
  8011ef:	29 c2                	sub    %eax,%edx
  8011f1:	89 d0                	mov    %edx,%eax
  8011f3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011f9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011fe:	f7 e9                	imul   %ecx
  801200:	c1 fa 02             	sar    $0x2,%edx
  801203:	89 c8                	mov    %ecx,%eax
  801205:	c1 f8 1f             	sar    $0x1f,%eax
  801208:	29 c2                	sub    %eax,%edx
  80120a:	89 d0                	mov    %edx,%eax
  80120c:	c1 e0 02             	shl    $0x2,%eax
  80120f:	01 d0                	add    %edx,%eax
  801211:	01 c0                	add    %eax,%eax
  801213:	29 c1                	sub    %eax,%ecx
  801215:	89 ca                	mov    %ecx,%edx
  801217:	85 d2                	test   %edx,%edx
  801219:	75 9c                	jne    8011b7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80121b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801222:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801225:	48                   	dec    %eax
  801226:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801229:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80122d:	74 3d                	je     80126c <ltostr+0xe2>
		start = 1 ;
  80122f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801236:	eb 34                	jmp    80126c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801238:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	01 d0                	add    %edx,%eax
  801240:	8a 00                	mov    (%eax),%al
  801242:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801245:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124b:	01 c2                	add    %eax,%edx
  80124d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801250:	8b 45 0c             	mov    0xc(%ebp),%eax
  801253:	01 c8                	add    %ecx,%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801259:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	01 c2                	add    %eax,%edx
  801261:	8a 45 eb             	mov    -0x15(%ebp),%al
  801264:	88 02                	mov    %al,(%edx)
		start++ ;
  801266:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801269:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80126c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801272:	7c c4                	jl     801238 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801274:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	01 d0                	add    %edx,%eax
  80127c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80127f:	90                   	nop
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801288:	ff 75 08             	pushl  0x8(%ebp)
  80128b:	e8 54 fa ff ff       	call   800ce4 <strlen>
  801290:	83 c4 04             	add    $0x4,%esp
  801293:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	e8 46 fa ff ff       	call   800ce4 <strlen>
  80129e:	83 c4 04             	add    $0x4,%esp
  8012a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b2:	eb 17                	jmp    8012cb <strcconcat+0x49>
		final[s] = str1[s] ;
  8012b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ba:	01 c2                	add    %eax,%edx
  8012bc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	01 c8                	add    %ecx,%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012c8:	ff 45 fc             	incl   -0x4(%ebp)
  8012cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ce:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012d1:	7c e1                	jl     8012b4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012e1:	eb 1f                	jmp    801302 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e6:	8d 50 01             	lea    0x1(%eax),%edx
  8012e9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ec:	89 c2                	mov    %eax,%edx
  8012ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f1:	01 c2                	add    %eax,%edx
  8012f3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f9:	01 c8                	add    %ecx,%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012ff:	ff 45 f8             	incl   -0x8(%ebp)
  801302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801305:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801308:	7c d9                	jl     8012e3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80130a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130d:	8b 45 10             	mov    0x10(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	c6 00 00             	movb   $0x0,(%eax)
}
  801315:	90                   	nop
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80131b:	8b 45 14             	mov    0x14(%ebp),%eax
  80131e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801324:	8b 45 14             	mov    0x14(%ebp),%eax
  801327:	8b 00                	mov    (%eax),%eax
  801329:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801330:	8b 45 10             	mov    0x10(%ebp),%eax
  801333:	01 d0                	add    %edx,%eax
  801335:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80133b:	eb 0c                	jmp    801349 <strsplit+0x31>
			*string++ = 0;
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	8d 50 01             	lea    0x1(%eax),%edx
  801343:	89 55 08             	mov    %edx,0x8(%ebp)
  801346:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	84 c0                	test   %al,%al
  801350:	74 18                	je     80136a <strsplit+0x52>
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	0f be c0             	movsbl %al,%eax
  80135a:	50                   	push   %eax
  80135b:	ff 75 0c             	pushl  0xc(%ebp)
  80135e:	e8 13 fb ff ff       	call   800e76 <strchr>
  801363:	83 c4 08             	add    $0x8,%esp
  801366:	85 c0                	test   %eax,%eax
  801368:	75 d3                	jne    80133d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	84 c0                	test   %al,%al
  801371:	74 5a                	je     8013cd <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801373:	8b 45 14             	mov    0x14(%ebp),%eax
  801376:	8b 00                	mov    (%eax),%eax
  801378:	83 f8 0f             	cmp    $0xf,%eax
  80137b:	75 07                	jne    801384 <strsplit+0x6c>
		{
			return 0;
  80137d:	b8 00 00 00 00       	mov    $0x0,%eax
  801382:	eb 66                	jmp    8013ea <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801384:	8b 45 14             	mov    0x14(%ebp),%eax
  801387:	8b 00                	mov    (%eax),%eax
  801389:	8d 48 01             	lea    0x1(%eax),%ecx
  80138c:	8b 55 14             	mov    0x14(%ebp),%edx
  80138f:	89 0a                	mov    %ecx,(%edx)
  801391:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801398:	8b 45 10             	mov    0x10(%ebp),%eax
  80139b:	01 c2                	add    %eax,%edx
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a2:	eb 03                	jmp    8013a7 <strsplit+0x8f>
			string++;
  8013a4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	8a 00                	mov    (%eax),%al
  8013ac:	84 c0                	test   %al,%al
  8013ae:	74 8b                	je     80133b <strsplit+0x23>
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	0f be c0             	movsbl %al,%eax
  8013b8:	50                   	push   %eax
  8013b9:	ff 75 0c             	pushl  0xc(%ebp)
  8013bc:	e8 b5 fa ff ff       	call   800e76 <strchr>
  8013c1:	83 c4 08             	add    $0x8,%esp
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	74 dc                	je     8013a4 <strsplit+0x8c>
			string++;
	}
  8013c8:	e9 6e ff ff ff       	jmp    80133b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013cd:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d1:	8b 00                	mov    (%eax),%eax
  8013d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013da:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dd:	01 d0                	add    %edx,%eax
  8013df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013e5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013f2:	a1 04 50 80 00       	mov    0x805004,%eax
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	74 1f                	je     80141a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013fb:	e8 1d 00 00 00       	call   80141d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801400:	83 ec 0c             	sub    $0xc,%esp
  801403:	68 f0 3e 80 00       	push   $0x803ef0
  801408:	e8 55 f2 ff ff       	call   800662 <cprintf>
  80140d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801410:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801417:	00 00 00 
	}
}
  80141a:	90                   	nop
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801423:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80142a:	00 00 00 
  80142d:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801434:	00 00 00 
  801437:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80143e:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801441:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801448:	00 00 00 
  80144b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801452:	00 00 00 
  801455:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80145c:	00 00 00 
	uint32 arr_size = 0;
  80145f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801466:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80146d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801470:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801475:	2d 00 10 00 00       	sub    $0x1000,%eax
  80147a:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80147f:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801486:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801489:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801490:	a1 20 51 80 00       	mov    0x805120,%eax
  801495:	c1 e0 04             	shl    $0x4,%eax
  801498:	89 c2                	mov    %eax,%edx
  80149a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80149d:	01 d0                	add    %edx,%eax
  80149f:	48                   	dec    %eax
  8014a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8014a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ab:	f7 75 ec             	divl   -0x14(%ebp)
  8014ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014b1:	29 d0                	sub    %edx,%eax
  8014b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8014b6:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8014bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014c5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	6a 06                	push   $0x6
  8014cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8014d2:	50                   	push   %eax
  8014d3:	e8 b2 05 00 00       	call   801a8a <sys_allocate_chunk>
  8014d8:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014db:	a1 20 51 80 00       	mov    0x805120,%eax
  8014e0:	83 ec 0c             	sub    $0xc,%esp
  8014e3:	50                   	push   %eax
  8014e4:	e8 27 0c 00 00       	call   802110 <initialize_MemBlocksList>
  8014e9:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8014ec:	a1 48 51 80 00       	mov    0x805148,%eax
  8014f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8014f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f7:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8014fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801501:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801508:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80150c:	75 14                	jne    801522 <initialize_dyn_block_system+0x105>
  80150e:	83 ec 04             	sub    $0x4,%esp
  801511:	68 15 3f 80 00       	push   $0x803f15
  801516:	6a 33                	push   $0x33
  801518:	68 33 3f 80 00       	push   $0x803f33
  80151d:	e8 8c ee ff ff       	call   8003ae <_panic>
  801522:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801525:	8b 00                	mov    (%eax),%eax
  801527:	85 c0                	test   %eax,%eax
  801529:	74 10                	je     80153b <initialize_dyn_block_system+0x11e>
  80152b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152e:	8b 00                	mov    (%eax),%eax
  801530:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801533:	8b 52 04             	mov    0x4(%edx),%edx
  801536:	89 50 04             	mov    %edx,0x4(%eax)
  801539:	eb 0b                	jmp    801546 <initialize_dyn_block_system+0x129>
  80153b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80153e:	8b 40 04             	mov    0x4(%eax),%eax
  801541:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801546:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801549:	8b 40 04             	mov    0x4(%eax),%eax
  80154c:	85 c0                	test   %eax,%eax
  80154e:	74 0f                	je     80155f <initialize_dyn_block_system+0x142>
  801550:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801553:	8b 40 04             	mov    0x4(%eax),%eax
  801556:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801559:	8b 12                	mov    (%edx),%edx
  80155b:	89 10                	mov    %edx,(%eax)
  80155d:	eb 0a                	jmp    801569 <initialize_dyn_block_system+0x14c>
  80155f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801562:	8b 00                	mov    (%eax),%eax
  801564:	a3 48 51 80 00       	mov    %eax,0x805148
  801569:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801572:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801575:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80157c:	a1 54 51 80 00       	mov    0x805154,%eax
  801581:	48                   	dec    %eax
  801582:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801587:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80158b:	75 14                	jne    8015a1 <initialize_dyn_block_system+0x184>
  80158d:	83 ec 04             	sub    $0x4,%esp
  801590:	68 40 3f 80 00       	push   $0x803f40
  801595:	6a 34                	push   $0x34
  801597:	68 33 3f 80 00       	push   $0x803f33
  80159c:	e8 0d ee ff ff       	call   8003ae <_panic>
  8015a1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8015a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015aa:	89 10                	mov    %edx,(%eax)
  8015ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015af:	8b 00                	mov    (%eax),%eax
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	74 0d                	je     8015c2 <initialize_dyn_block_system+0x1a5>
  8015b5:	a1 38 51 80 00       	mov    0x805138,%eax
  8015ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015bd:	89 50 04             	mov    %edx,0x4(%eax)
  8015c0:	eb 08                	jmp    8015ca <initialize_dyn_block_system+0x1ad>
  8015c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8015ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015cd:	a3 38 51 80 00       	mov    %eax,0x805138
  8015d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015dc:	a1 44 51 80 00       	mov    0x805144,%eax
  8015e1:	40                   	inc    %eax
  8015e2:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8015e7:	90                   	nop
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f0:	e8 f7 fd ff ff       	call   8013ec <InitializeUHeap>
	if (size == 0) return NULL ;
  8015f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015f9:	75 07                	jne    801602 <malloc+0x18>
  8015fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801600:	eb 61                	jmp    801663 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801602:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801609:	8b 55 08             	mov    0x8(%ebp),%edx
  80160c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160f:	01 d0                	add    %edx,%eax
  801611:	48                   	dec    %eax
  801612:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801618:	ba 00 00 00 00       	mov    $0x0,%edx
  80161d:	f7 75 f0             	divl   -0x10(%ebp)
  801620:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801623:	29 d0                	sub    %edx,%eax
  801625:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801628:	e8 2b 08 00 00       	call   801e58 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162d:	85 c0                	test   %eax,%eax
  80162f:	74 11                	je     801642 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801631:	83 ec 0c             	sub    $0xc,%esp
  801634:	ff 75 e8             	pushl  -0x18(%ebp)
  801637:	e8 96 0e 00 00       	call   8024d2 <alloc_block_FF>
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801642:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801646:	74 16                	je     80165e <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801648:	83 ec 0c             	sub    $0xc,%esp
  80164b:	ff 75 f4             	pushl  -0xc(%ebp)
  80164e:	e8 f2 0b 00 00       	call   802245 <insert_sorted_allocList>
  801653:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801659:	8b 40 08             	mov    0x8(%eax),%eax
  80165c:	eb 05                	jmp    801663 <malloc+0x79>
	}

    return NULL;
  80165e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	83 ec 08             	sub    $0x8,%esp
  801671:	50                   	push   %eax
  801672:	68 40 50 80 00       	push   $0x805040
  801677:	e8 71 0b 00 00       	call   8021ed <find_block>
  80167c:	83 c4 10             	add    $0x10,%esp
  80167f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801682:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801686:	0f 84 a6 00 00 00    	je     801732 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  80168c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168f:	8b 50 0c             	mov    0xc(%eax),%edx
  801692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801695:	8b 40 08             	mov    0x8(%eax),%eax
  801698:	83 ec 08             	sub    $0x8,%esp
  80169b:	52                   	push   %edx
  80169c:	50                   	push   %eax
  80169d:	e8 b0 03 00 00       	call   801a52 <sys_free_user_mem>
  8016a2:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8016a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016a9:	75 14                	jne    8016bf <free+0x5a>
  8016ab:	83 ec 04             	sub    $0x4,%esp
  8016ae:	68 15 3f 80 00       	push   $0x803f15
  8016b3:	6a 74                	push   $0x74
  8016b5:	68 33 3f 80 00       	push   $0x803f33
  8016ba:	e8 ef ec ff ff       	call   8003ae <_panic>
  8016bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c2:	8b 00                	mov    (%eax),%eax
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	74 10                	je     8016d8 <free+0x73>
  8016c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016cb:	8b 00                	mov    (%eax),%eax
  8016cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d0:	8b 52 04             	mov    0x4(%edx),%edx
  8016d3:	89 50 04             	mov    %edx,0x4(%eax)
  8016d6:	eb 0b                	jmp    8016e3 <free+0x7e>
  8016d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016db:	8b 40 04             	mov    0x4(%eax),%eax
  8016de:	a3 44 50 80 00       	mov    %eax,0x805044
  8016e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e6:	8b 40 04             	mov    0x4(%eax),%eax
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	74 0f                	je     8016fc <free+0x97>
  8016ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f0:	8b 40 04             	mov    0x4(%eax),%eax
  8016f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f6:	8b 12                	mov    (%edx),%edx
  8016f8:	89 10                	mov    %edx,(%eax)
  8016fa:	eb 0a                	jmp    801706 <free+0xa1>
  8016fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ff:	8b 00                	mov    (%eax),%eax
  801701:	a3 40 50 80 00       	mov    %eax,0x805040
  801706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801709:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80170f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801712:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801719:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80171e:	48                   	dec    %eax
  80171f:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801724:	83 ec 0c             	sub    $0xc,%esp
  801727:	ff 75 f4             	pushl  -0xc(%ebp)
  80172a:	e8 4e 17 00 00       	call   802e7d <insert_sorted_with_merge_freeList>
  80172f:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801732:	90                   	nop
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	83 ec 38             	sub    $0x38,%esp
  80173b:	8b 45 10             	mov    0x10(%ebp),%eax
  80173e:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801741:	e8 a6 fc ff ff       	call   8013ec <InitializeUHeap>
	if (size == 0) return NULL ;
  801746:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80174a:	75 0a                	jne    801756 <smalloc+0x21>
  80174c:	b8 00 00 00 00       	mov    $0x0,%eax
  801751:	e9 8b 00 00 00       	jmp    8017e1 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801756:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80175d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801763:	01 d0                	add    %edx,%eax
  801765:	48                   	dec    %eax
  801766:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801769:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176c:	ba 00 00 00 00       	mov    $0x0,%edx
  801771:	f7 75 f0             	divl   -0x10(%ebp)
  801774:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801777:	29 d0                	sub    %edx,%eax
  801779:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80177c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801783:	e8 d0 06 00 00       	call   801e58 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801788:	85 c0                	test   %eax,%eax
  80178a:	74 11                	je     80179d <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80178c:	83 ec 0c             	sub    $0xc,%esp
  80178f:	ff 75 e8             	pushl  -0x18(%ebp)
  801792:	e8 3b 0d 00 00       	call   8024d2 <alloc_block_FF>
  801797:	83 c4 10             	add    $0x10,%esp
  80179a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  80179d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017a1:	74 39                	je     8017dc <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a6:	8b 40 08             	mov    0x8(%eax),%eax
  8017a9:	89 c2                	mov    %eax,%edx
  8017ab:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017af:	52                   	push   %edx
  8017b0:	50                   	push   %eax
  8017b1:	ff 75 0c             	pushl  0xc(%ebp)
  8017b4:	ff 75 08             	pushl  0x8(%ebp)
  8017b7:	e8 21 04 00 00       	call   801bdd <sys_createSharedObject>
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8017c2:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8017c6:	74 14                	je     8017dc <smalloc+0xa7>
  8017c8:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8017cc:	74 0e                	je     8017dc <smalloc+0xa7>
  8017ce:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8017d2:	74 08                	je     8017dc <smalloc+0xa7>
			return (void*) mem_block->sva;
  8017d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d7:	8b 40 08             	mov    0x8(%eax),%eax
  8017da:	eb 05                	jmp    8017e1 <smalloc+0xac>
	}
	return NULL;
  8017dc:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017e9:	e8 fe fb ff ff       	call   8013ec <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017ee:	83 ec 08             	sub    $0x8,%esp
  8017f1:	ff 75 0c             	pushl  0xc(%ebp)
  8017f4:	ff 75 08             	pushl  0x8(%ebp)
  8017f7:	e8 0b 04 00 00       	call   801c07 <sys_getSizeOfSharedObject>
  8017fc:	83 c4 10             	add    $0x10,%esp
  8017ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801802:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801806:	74 76                	je     80187e <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801808:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80180f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801812:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801815:	01 d0                	add    %edx,%eax
  801817:	48                   	dec    %eax
  801818:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80181b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80181e:	ba 00 00 00 00       	mov    $0x0,%edx
  801823:	f7 75 ec             	divl   -0x14(%ebp)
  801826:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801829:	29 d0                	sub    %edx,%eax
  80182b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80182e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801835:	e8 1e 06 00 00       	call   801e58 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80183a:	85 c0                	test   %eax,%eax
  80183c:	74 11                	je     80184f <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80183e:	83 ec 0c             	sub    $0xc,%esp
  801841:	ff 75 e4             	pushl  -0x1c(%ebp)
  801844:	e8 89 0c 00 00       	call   8024d2 <alloc_block_FF>
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80184f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801853:	74 29                	je     80187e <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801858:	8b 40 08             	mov    0x8(%eax),%eax
  80185b:	83 ec 04             	sub    $0x4,%esp
  80185e:	50                   	push   %eax
  80185f:	ff 75 0c             	pushl  0xc(%ebp)
  801862:	ff 75 08             	pushl  0x8(%ebp)
  801865:	e8 ba 03 00 00       	call   801c24 <sys_getSharedObject>
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801870:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801874:	74 08                	je     80187e <sget+0x9b>
				return (void *)mem_block->sva;
  801876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801879:	8b 40 08             	mov    0x8(%eax),%eax
  80187c:	eb 05                	jmp    801883 <sget+0xa0>
		}
	}
	return NULL;
  80187e:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80188b:	e8 5c fb ff ff       	call   8013ec <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801890:	83 ec 04             	sub    $0x4,%esp
  801893:	68 64 3f 80 00       	push   $0x803f64
  801898:	68 f7 00 00 00       	push   $0xf7
  80189d:	68 33 3f 80 00       	push   $0x803f33
  8018a2:	e8 07 eb ff ff       	call   8003ae <_panic>

008018a7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018ad:	83 ec 04             	sub    $0x4,%esp
  8018b0:	68 8c 3f 80 00       	push   $0x803f8c
  8018b5:	68 0b 01 00 00       	push   $0x10b
  8018ba:	68 33 3f 80 00       	push   $0x803f33
  8018bf:	e8 ea ea ff ff       	call   8003ae <_panic>

008018c4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ca:	83 ec 04             	sub    $0x4,%esp
  8018cd:	68 b0 3f 80 00       	push   $0x803fb0
  8018d2:	68 16 01 00 00       	push   $0x116
  8018d7:	68 33 3f 80 00       	push   $0x803f33
  8018dc:	e8 cd ea ff ff       	call   8003ae <_panic>

008018e1 <shrink>:

}
void shrink(uint32 newSize)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e7:	83 ec 04             	sub    $0x4,%esp
  8018ea:	68 b0 3f 80 00       	push   $0x803fb0
  8018ef:	68 1b 01 00 00       	push   $0x11b
  8018f4:	68 33 3f 80 00       	push   $0x803f33
  8018f9:	e8 b0 ea ff ff       	call   8003ae <_panic>

008018fe <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801904:	83 ec 04             	sub    $0x4,%esp
  801907:	68 b0 3f 80 00       	push   $0x803fb0
  80190c:	68 20 01 00 00       	push   $0x120
  801911:	68 33 3f 80 00       	push   $0x803f33
  801916:	e8 93 ea ff ff       	call   8003ae <_panic>

0080191b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	57                   	push   %edi
  80191f:	56                   	push   %esi
  801920:	53                   	push   %ebx
  801921:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801924:	8b 45 08             	mov    0x8(%ebp),%eax
  801927:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801930:	8b 7d 18             	mov    0x18(%ebp),%edi
  801933:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801936:	cd 30                	int    $0x30
  801938:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80193b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80193e:	83 c4 10             	add    $0x10,%esp
  801941:	5b                   	pop    %ebx
  801942:	5e                   	pop    %esi
  801943:	5f                   	pop    %edi
  801944:	5d                   	pop    %ebp
  801945:	c3                   	ret    

00801946 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	8b 45 10             	mov    0x10(%ebp),%eax
  80194f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801952:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	52                   	push   %edx
  80195e:	ff 75 0c             	pushl  0xc(%ebp)
  801961:	50                   	push   %eax
  801962:	6a 00                	push   $0x0
  801964:	e8 b2 ff ff ff       	call   80191b <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	90                   	nop
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_cgetc>:

int
sys_cgetc(void)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 01                	push   $0x1
  80197e:	e8 98 ff ff ff       	call   80191b <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80198b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	52                   	push   %edx
  801998:	50                   	push   %eax
  801999:	6a 05                	push   $0x5
  80199b:	e8 7b ff ff ff       	call   80191b <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	56                   	push   %esi
  8019a9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019aa:	8b 75 18             	mov    0x18(%ebp),%esi
  8019ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	56                   	push   %esi
  8019ba:	53                   	push   %ebx
  8019bb:	51                   	push   %ecx
  8019bc:	52                   	push   %edx
  8019bd:	50                   	push   %eax
  8019be:	6a 06                	push   $0x6
  8019c0:	e8 56 ff ff ff       	call   80191b <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019cb:	5b                   	pop    %ebx
  8019cc:	5e                   	pop    %esi
  8019cd:	5d                   	pop    %ebp
  8019ce:	c3                   	ret    

008019cf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	52                   	push   %edx
  8019df:	50                   	push   %eax
  8019e0:	6a 07                	push   $0x7
  8019e2:	e8 34 ff ff ff       	call   80191b <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	ff 75 0c             	pushl  0xc(%ebp)
  8019f8:	ff 75 08             	pushl  0x8(%ebp)
  8019fb:	6a 08                	push   $0x8
  8019fd:	e8 19 ff ff ff       	call   80191b <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 09                	push   $0x9
  801a16:	e8 00 ff ff ff       	call   80191b <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 0a                	push   $0xa
  801a2f:	e8 e7 fe ff ff       	call   80191b <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 0b                	push   $0xb
  801a48:	e8 ce fe ff ff       	call   80191b <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	ff 75 0c             	pushl  0xc(%ebp)
  801a5e:	ff 75 08             	pushl  0x8(%ebp)
  801a61:	6a 0f                	push   $0xf
  801a63:	e8 b3 fe ff ff       	call   80191b <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
	return;
  801a6b:	90                   	nop
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	ff 75 0c             	pushl  0xc(%ebp)
  801a7a:	ff 75 08             	pushl  0x8(%ebp)
  801a7d:	6a 10                	push   $0x10
  801a7f:	e8 97 fe ff ff       	call   80191b <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
	return ;
  801a87:	90                   	nop
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	ff 75 10             	pushl  0x10(%ebp)
  801a94:	ff 75 0c             	pushl  0xc(%ebp)
  801a97:	ff 75 08             	pushl  0x8(%ebp)
  801a9a:	6a 11                	push   $0x11
  801a9c:	e8 7a fe ff ff       	call   80191b <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa4:	90                   	nop
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 0c                	push   $0xc
  801ab6:	e8 60 fe ff ff       	call   80191b <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	ff 75 08             	pushl  0x8(%ebp)
  801ace:	6a 0d                	push   $0xd
  801ad0:	e8 46 fe ff ff       	call   80191b <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 0e                	push   $0xe
  801ae9:	e8 2d fe ff ff       	call   80191b <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
}
  801af1:	90                   	nop
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 13                	push   $0x13
  801b03:	e8 13 fe ff ff       	call   80191b <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	90                   	nop
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 14                	push   $0x14
  801b1d:	e8 f9 fd ff ff       	call   80191b <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	90                   	nop
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	83 ec 04             	sub    $0x4,%esp
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b34:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	50                   	push   %eax
  801b41:	6a 15                	push   $0x15
  801b43:	e8 d3 fd ff ff       	call   80191b <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	90                   	nop
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 16                	push   $0x16
  801b5d:	e8 b9 fd ff ff       	call   80191b <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
}
  801b65:	90                   	nop
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	ff 75 0c             	pushl  0xc(%ebp)
  801b77:	50                   	push   %eax
  801b78:	6a 17                	push   $0x17
  801b7a:	e8 9c fd ff ff       	call   80191b <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	52                   	push   %edx
  801b94:	50                   	push   %eax
  801b95:	6a 1a                	push   $0x1a
  801b97:	e8 7f fd ff ff       	call   80191b <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ba4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	52                   	push   %edx
  801bb1:	50                   	push   %eax
  801bb2:	6a 18                	push   $0x18
  801bb4:	e8 62 fd ff ff       	call   80191b <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	90                   	nop
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	52                   	push   %edx
  801bcf:	50                   	push   %eax
  801bd0:	6a 19                	push   $0x19
  801bd2:	e8 44 fd ff ff       	call   80191b <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	90                   	nop
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 04             	sub    $0x4,%esp
  801be3:	8b 45 10             	mov    0x10(%ebp),%eax
  801be6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801be9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bec:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	6a 00                	push   $0x0
  801bf5:	51                   	push   %ecx
  801bf6:	52                   	push   %edx
  801bf7:	ff 75 0c             	pushl  0xc(%ebp)
  801bfa:	50                   	push   %eax
  801bfb:	6a 1b                	push   $0x1b
  801bfd:	e8 19 fd ff ff       	call   80191b <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	52                   	push   %edx
  801c17:	50                   	push   %eax
  801c18:	6a 1c                	push   $0x1c
  801c1a:	e8 fc fc ff ff       	call   80191b <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c27:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	51                   	push   %ecx
  801c35:	52                   	push   %edx
  801c36:	50                   	push   %eax
  801c37:	6a 1d                	push   $0x1d
  801c39:	e8 dd fc ff ff       	call   80191b <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	52                   	push   %edx
  801c53:	50                   	push   %eax
  801c54:	6a 1e                	push   $0x1e
  801c56:	e8 c0 fc ff ff       	call   80191b <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 1f                	push   $0x1f
  801c6f:	e8 a7 fc ff ff       	call   80191b <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	6a 00                	push   $0x0
  801c81:	ff 75 14             	pushl  0x14(%ebp)
  801c84:	ff 75 10             	pushl  0x10(%ebp)
  801c87:	ff 75 0c             	pushl  0xc(%ebp)
  801c8a:	50                   	push   %eax
  801c8b:	6a 20                	push   $0x20
  801c8d:	e8 89 fc ff ff       	call   80191b <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	50                   	push   %eax
  801ca6:	6a 21                	push   $0x21
  801ca8:	e8 6e fc ff ff       	call   80191b <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	90                   	nop
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	50                   	push   %eax
  801cc2:	6a 22                	push   $0x22
  801cc4:	e8 52 fc ff ff       	call   80191b <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 02                	push   $0x2
  801cdd:	e8 39 fc ff ff       	call   80191b <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 03                	push   $0x3
  801cf6:	e8 20 fc ff ff       	call   80191b <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 04                	push   $0x4
  801d0f:	e8 07 fc ff ff       	call   80191b <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_exit_env>:


void sys_exit_env(void)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 23                	push   $0x23
  801d28:	e8 ee fb ff ff       	call   80191b <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	90                   	nop
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d39:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d3c:	8d 50 04             	lea    0x4(%eax),%edx
  801d3f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	52                   	push   %edx
  801d49:	50                   	push   %eax
  801d4a:	6a 24                	push   $0x24
  801d4c:	e8 ca fb ff ff       	call   80191b <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
	return result;
  801d54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d5d:	89 01                	mov    %eax,(%ecx)
  801d5f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	c9                   	leave  
  801d66:	c2 04 00             	ret    $0x4

00801d69 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	ff 75 10             	pushl  0x10(%ebp)
  801d73:	ff 75 0c             	pushl  0xc(%ebp)
  801d76:	ff 75 08             	pushl  0x8(%ebp)
  801d79:	6a 12                	push   $0x12
  801d7b:	e8 9b fb ff ff       	call   80191b <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
	return ;
  801d83:	90                   	nop
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 25                	push   $0x25
  801d95:	e8 81 fb ff ff       	call   80191b <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	83 ec 04             	sub    $0x4,%esp
  801da5:	8b 45 08             	mov    0x8(%ebp),%eax
  801da8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dab:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	50                   	push   %eax
  801db8:	6a 26                	push   $0x26
  801dba:	e8 5c fb ff ff       	call   80191b <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc2:	90                   	nop
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <rsttst>:
void rsttst()
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 28                	push   $0x28
  801dd4:	e8 42 fb ff ff       	call   80191b <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddc:	90                   	nop
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	83 ec 04             	sub    $0x4,%esp
  801de5:	8b 45 14             	mov    0x14(%ebp),%eax
  801de8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801deb:	8b 55 18             	mov    0x18(%ebp),%edx
  801dee:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801df2:	52                   	push   %edx
  801df3:	50                   	push   %eax
  801df4:	ff 75 10             	pushl  0x10(%ebp)
  801df7:	ff 75 0c             	pushl  0xc(%ebp)
  801dfa:	ff 75 08             	pushl  0x8(%ebp)
  801dfd:	6a 27                	push   $0x27
  801dff:	e8 17 fb ff ff       	call   80191b <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
	return ;
  801e07:	90                   	nop
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <chktst>:
void chktst(uint32 n)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	ff 75 08             	pushl  0x8(%ebp)
  801e18:	6a 29                	push   $0x29
  801e1a:	e8 fc fa ff ff       	call   80191b <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e22:	90                   	nop
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <inctst>:

void inctst()
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 2a                	push   $0x2a
  801e34:	e8 e2 fa ff ff       	call   80191b <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3c:	90                   	nop
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <gettst>:
uint32 gettst()
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 2b                	push   $0x2b
  801e4e:	e8 c8 fa ff ff       	call   80191b <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 2c                	push   $0x2c
  801e6a:	e8 ac fa ff ff       	call   80191b <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
  801e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e75:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e79:	75 07                	jne    801e82 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e7b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e80:	eb 05                	jmp    801e87 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 2c                	push   $0x2c
  801e9b:	e8 7b fa ff ff       	call   80191b <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
  801ea3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ea6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801eaa:	75 07                	jne    801eb3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eac:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb1:	eb 05                	jmp    801eb8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801eb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 2c                	push   $0x2c
  801ecc:	e8 4a fa ff ff       	call   80191b <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
  801ed4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ed7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801edb:	75 07                	jne    801ee4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801edd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee2:	eb 05                	jmp    801ee9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 2c                	push   $0x2c
  801efd:	e8 19 fa ff ff       	call   80191b <syscall>
  801f02:	83 c4 18             	add    $0x18,%esp
  801f05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f08:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f0c:	75 07                	jne    801f15 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f13:	eb 05                	jmp    801f1a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	ff 75 08             	pushl  0x8(%ebp)
  801f2a:	6a 2d                	push   $0x2d
  801f2c:	e8 ea f9 ff ff       	call   80191b <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
	return ;
  801f34:	90                   	nop
}
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
  801f3a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f3b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	6a 00                	push   $0x0
  801f49:	53                   	push   %ebx
  801f4a:	51                   	push   %ecx
  801f4b:	52                   	push   %edx
  801f4c:	50                   	push   %eax
  801f4d:	6a 2e                	push   $0x2e
  801f4f:	e8 c7 f9 ff ff       	call   80191b <syscall>
  801f54:	83 c4 18             	add    $0x18,%esp
}
  801f57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	52                   	push   %edx
  801f6c:	50                   	push   %eax
  801f6d:	6a 2f                	push   $0x2f
  801f6f:	e8 a7 f9 ff ff       	call   80191b <syscall>
  801f74:	83 c4 18             	add    $0x18,%esp
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f7f:	83 ec 0c             	sub    $0xc,%esp
  801f82:	68 c0 3f 80 00       	push   $0x803fc0
  801f87:	e8 d6 e6 ff ff       	call   800662 <cprintf>
  801f8c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f8f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f96:	83 ec 0c             	sub    $0xc,%esp
  801f99:	68 ec 3f 80 00       	push   $0x803fec
  801f9e:	e8 bf e6 ff ff       	call   800662 <cprintf>
  801fa3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fa6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801faa:	a1 38 51 80 00       	mov    0x805138,%eax
  801faf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb2:	eb 56                	jmp    80200a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb8:	74 1c                	je     801fd6 <print_mem_block_lists+0x5d>
  801fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbd:	8b 50 08             	mov    0x8(%eax),%edx
  801fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc3:	8b 48 08             	mov    0x8(%eax),%ecx
  801fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc9:	8b 40 0c             	mov    0xc(%eax),%eax
  801fcc:	01 c8                	add    %ecx,%eax
  801fce:	39 c2                	cmp    %eax,%edx
  801fd0:	73 04                	jae    801fd6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fd2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd9:	8b 50 08             	mov    0x8(%eax),%edx
  801fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdf:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe2:	01 c2                	add    %eax,%edx
  801fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe7:	8b 40 08             	mov    0x8(%eax),%eax
  801fea:	83 ec 04             	sub    $0x4,%esp
  801fed:	52                   	push   %edx
  801fee:	50                   	push   %eax
  801fef:	68 01 40 80 00       	push   $0x804001
  801ff4:	e8 69 e6 ff ff       	call   800662 <cprintf>
  801ff9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802002:	a1 40 51 80 00       	mov    0x805140,%eax
  802007:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80200e:	74 07                	je     802017 <print_mem_block_lists+0x9e>
  802010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802013:	8b 00                	mov    (%eax),%eax
  802015:	eb 05                	jmp    80201c <print_mem_block_lists+0xa3>
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
  80201c:	a3 40 51 80 00       	mov    %eax,0x805140
  802021:	a1 40 51 80 00       	mov    0x805140,%eax
  802026:	85 c0                	test   %eax,%eax
  802028:	75 8a                	jne    801fb4 <print_mem_block_lists+0x3b>
  80202a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202e:	75 84                	jne    801fb4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802030:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802034:	75 10                	jne    802046 <print_mem_block_lists+0xcd>
  802036:	83 ec 0c             	sub    $0xc,%esp
  802039:	68 10 40 80 00       	push   $0x804010
  80203e:	e8 1f e6 ff ff       	call   800662 <cprintf>
  802043:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80204d:	83 ec 0c             	sub    $0xc,%esp
  802050:	68 34 40 80 00       	push   $0x804034
  802055:	e8 08 e6 ff ff       	call   800662 <cprintf>
  80205a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80205d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802061:	a1 40 50 80 00       	mov    0x805040,%eax
  802066:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802069:	eb 56                	jmp    8020c1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80206b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80206f:	74 1c                	je     80208d <print_mem_block_lists+0x114>
  802071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802074:	8b 50 08             	mov    0x8(%eax),%edx
  802077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207a:	8b 48 08             	mov    0x8(%eax),%ecx
  80207d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802080:	8b 40 0c             	mov    0xc(%eax),%eax
  802083:	01 c8                	add    %ecx,%eax
  802085:	39 c2                	cmp    %eax,%edx
  802087:	73 04                	jae    80208d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802089:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80208d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802090:	8b 50 08             	mov    0x8(%eax),%edx
  802093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802096:	8b 40 0c             	mov    0xc(%eax),%eax
  802099:	01 c2                	add    %eax,%edx
  80209b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209e:	8b 40 08             	mov    0x8(%eax),%eax
  8020a1:	83 ec 04             	sub    $0x4,%esp
  8020a4:	52                   	push   %edx
  8020a5:	50                   	push   %eax
  8020a6:	68 01 40 80 00       	push   $0x804001
  8020ab:	e8 b2 e5 ff ff       	call   800662 <cprintf>
  8020b0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020b9:	a1 48 50 80 00       	mov    0x805048,%eax
  8020be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c5:	74 07                	je     8020ce <print_mem_block_lists+0x155>
  8020c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ca:	8b 00                	mov    (%eax),%eax
  8020cc:	eb 05                	jmp    8020d3 <print_mem_block_lists+0x15a>
  8020ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d3:	a3 48 50 80 00       	mov    %eax,0x805048
  8020d8:	a1 48 50 80 00       	mov    0x805048,%eax
  8020dd:	85 c0                	test   %eax,%eax
  8020df:	75 8a                	jne    80206b <print_mem_block_lists+0xf2>
  8020e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e5:	75 84                	jne    80206b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020e7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020eb:	75 10                	jne    8020fd <print_mem_block_lists+0x184>
  8020ed:	83 ec 0c             	sub    $0xc,%esp
  8020f0:	68 4c 40 80 00       	push   $0x80404c
  8020f5:	e8 68 e5 ff ff       	call   800662 <cprintf>
  8020fa:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020fd:	83 ec 0c             	sub    $0xc,%esp
  802100:	68 c0 3f 80 00       	push   $0x803fc0
  802105:	e8 58 e5 ff ff       	call   800662 <cprintf>
  80210a:	83 c4 10             	add    $0x10,%esp

}
  80210d:	90                   	nop
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802116:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80211d:	00 00 00 
  802120:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802127:	00 00 00 
  80212a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802131:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802134:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80213b:	e9 9e 00 00 00       	jmp    8021de <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802140:	a1 50 50 80 00       	mov    0x805050,%eax
  802145:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802148:	c1 e2 04             	shl    $0x4,%edx
  80214b:	01 d0                	add    %edx,%eax
  80214d:	85 c0                	test   %eax,%eax
  80214f:	75 14                	jne    802165 <initialize_MemBlocksList+0x55>
  802151:	83 ec 04             	sub    $0x4,%esp
  802154:	68 74 40 80 00       	push   $0x804074
  802159:	6a 46                	push   $0x46
  80215b:	68 97 40 80 00       	push   $0x804097
  802160:	e8 49 e2 ff ff       	call   8003ae <_panic>
  802165:	a1 50 50 80 00       	mov    0x805050,%eax
  80216a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216d:	c1 e2 04             	shl    $0x4,%edx
  802170:	01 d0                	add    %edx,%eax
  802172:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802178:	89 10                	mov    %edx,(%eax)
  80217a:	8b 00                	mov    (%eax),%eax
  80217c:	85 c0                	test   %eax,%eax
  80217e:	74 18                	je     802198 <initialize_MemBlocksList+0x88>
  802180:	a1 48 51 80 00       	mov    0x805148,%eax
  802185:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80218b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80218e:	c1 e1 04             	shl    $0x4,%ecx
  802191:	01 ca                	add    %ecx,%edx
  802193:	89 50 04             	mov    %edx,0x4(%eax)
  802196:	eb 12                	jmp    8021aa <initialize_MemBlocksList+0x9a>
  802198:	a1 50 50 80 00       	mov    0x805050,%eax
  80219d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a0:	c1 e2 04             	shl    $0x4,%edx
  8021a3:	01 d0                	add    %edx,%eax
  8021a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8021aa:	a1 50 50 80 00       	mov    0x805050,%eax
  8021af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b2:	c1 e2 04             	shl    $0x4,%edx
  8021b5:	01 d0                	add    %edx,%eax
  8021b7:	a3 48 51 80 00       	mov    %eax,0x805148
  8021bc:	a1 50 50 80 00       	mov    0x805050,%eax
  8021c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c4:	c1 e2 04             	shl    $0x4,%edx
  8021c7:	01 d0                	add    %edx,%eax
  8021c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8021d5:	40                   	inc    %eax
  8021d6:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8021db:	ff 45 f4             	incl   -0xc(%ebp)
  8021de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021e4:	0f 82 56 ff ff ff    	jb     802140 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8021ea:	90                   	nop
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	8b 00                	mov    (%eax),%eax
  8021f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021fb:	eb 19                	jmp    802216 <find_block+0x29>
	{
		if(va==point->sva)
  8021fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802200:	8b 40 08             	mov    0x8(%eax),%eax
  802203:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802206:	75 05                	jne    80220d <find_block+0x20>
		   return point;
  802208:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80220b:	eb 36                	jmp    802243 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	8b 40 08             	mov    0x8(%eax),%eax
  802213:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802216:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80221a:	74 07                	je     802223 <find_block+0x36>
  80221c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80221f:	8b 00                	mov    (%eax),%eax
  802221:	eb 05                	jmp    802228 <find_block+0x3b>
  802223:	b8 00 00 00 00       	mov    $0x0,%eax
  802228:	8b 55 08             	mov    0x8(%ebp),%edx
  80222b:	89 42 08             	mov    %eax,0x8(%edx)
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	8b 40 08             	mov    0x8(%eax),%eax
  802234:	85 c0                	test   %eax,%eax
  802236:	75 c5                	jne    8021fd <find_block+0x10>
  802238:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80223c:	75 bf                	jne    8021fd <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80223e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80224b:	a1 40 50 80 00       	mov    0x805040,%eax
  802250:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802253:	a1 44 50 80 00       	mov    0x805044,%eax
  802258:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80225b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802261:	74 24                	je     802287 <insert_sorted_allocList+0x42>
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	8b 50 08             	mov    0x8(%eax),%edx
  802269:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226c:	8b 40 08             	mov    0x8(%eax),%eax
  80226f:	39 c2                	cmp    %eax,%edx
  802271:	76 14                	jbe    802287 <insert_sorted_allocList+0x42>
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	8b 50 08             	mov    0x8(%eax),%edx
  802279:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227c:	8b 40 08             	mov    0x8(%eax),%eax
  80227f:	39 c2                	cmp    %eax,%edx
  802281:	0f 82 60 01 00 00    	jb     8023e7 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802287:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80228b:	75 65                	jne    8022f2 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80228d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802291:	75 14                	jne    8022a7 <insert_sorted_allocList+0x62>
  802293:	83 ec 04             	sub    $0x4,%esp
  802296:	68 74 40 80 00       	push   $0x804074
  80229b:	6a 6b                	push   $0x6b
  80229d:	68 97 40 80 00       	push   $0x804097
  8022a2:	e8 07 e1 ff ff       	call   8003ae <_panic>
  8022a7:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	89 10                	mov    %edx,(%eax)
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	8b 00                	mov    (%eax),%eax
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	74 0d                	je     8022c8 <insert_sorted_allocList+0x83>
  8022bb:	a1 40 50 80 00       	mov    0x805040,%eax
  8022c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c3:	89 50 04             	mov    %edx,0x4(%eax)
  8022c6:	eb 08                	jmp    8022d0 <insert_sorted_allocList+0x8b>
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	a3 44 50 80 00       	mov    %eax,0x805044
  8022d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d3:	a3 40 50 80 00       	mov    %eax,0x805040
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022e7:	40                   	inc    %eax
  8022e8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022ed:	e9 dc 01 00 00       	jmp    8024ce <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	8b 50 08             	mov    0x8(%eax),%edx
  8022f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fb:	8b 40 08             	mov    0x8(%eax),%eax
  8022fe:	39 c2                	cmp    %eax,%edx
  802300:	77 6c                	ja     80236e <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802302:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802306:	74 06                	je     80230e <insert_sorted_allocList+0xc9>
  802308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80230c:	75 14                	jne    802322 <insert_sorted_allocList+0xdd>
  80230e:	83 ec 04             	sub    $0x4,%esp
  802311:	68 b0 40 80 00       	push   $0x8040b0
  802316:	6a 6f                	push   $0x6f
  802318:	68 97 40 80 00       	push   $0x804097
  80231d:	e8 8c e0 ff ff       	call   8003ae <_panic>
  802322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802325:	8b 50 04             	mov    0x4(%eax),%edx
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	89 50 04             	mov    %edx,0x4(%eax)
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802334:	89 10                	mov    %edx,(%eax)
  802336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802339:	8b 40 04             	mov    0x4(%eax),%eax
  80233c:	85 c0                	test   %eax,%eax
  80233e:	74 0d                	je     80234d <insert_sorted_allocList+0x108>
  802340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802343:	8b 40 04             	mov    0x4(%eax),%eax
  802346:	8b 55 08             	mov    0x8(%ebp),%edx
  802349:	89 10                	mov    %edx,(%eax)
  80234b:	eb 08                	jmp    802355 <insert_sorted_allocList+0x110>
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	a3 40 50 80 00       	mov    %eax,0x805040
  802355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802358:	8b 55 08             	mov    0x8(%ebp),%edx
  80235b:	89 50 04             	mov    %edx,0x4(%eax)
  80235e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802363:	40                   	inc    %eax
  802364:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802369:	e9 60 01 00 00       	jmp    8024ce <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	8b 50 08             	mov    0x8(%eax),%edx
  802374:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802377:	8b 40 08             	mov    0x8(%eax),%eax
  80237a:	39 c2                	cmp    %eax,%edx
  80237c:	0f 82 4c 01 00 00    	jb     8024ce <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802382:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802386:	75 14                	jne    80239c <insert_sorted_allocList+0x157>
  802388:	83 ec 04             	sub    $0x4,%esp
  80238b:	68 e8 40 80 00       	push   $0x8040e8
  802390:	6a 73                	push   $0x73
  802392:	68 97 40 80 00       	push   $0x804097
  802397:	e8 12 e0 ff ff       	call   8003ae <_panic>
  80239c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	89 50 04             	mov    %edx,0x4(%eax)
  8023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ab:	8b 40 04             	mov    0x4(%eax),%eax
  8023ae:	85 c0                	test   %eax,%eax
  8023b0:	74 0c                	je     8023be <insert_sorted_allocList+0x179>
  8023b2:	a1 44 50 80 00       	mov    0x805044,%eax
  8023b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ba:	89 10                	mov    %edx,(%eax)
  8023bc:	eb 08                	jmp    8023c6 <insert_sorted_allocList+0x181>
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	a3 40 50 80 00       	mov    %eax,0x805040
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	a3 44 50 80 00       	mov    %eax,0x805044
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023dc:	40                   	inc    %eax
  8023dd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023e2:	e9 e7 00 00 00       	jmp    8024ce <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8023e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8023ed:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023f4:	a1 40 50 80 00       	mov    0x805040,%eax
  8023f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023fc:	e9 9d 00 00 00       	jmp    80249e <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	8b 00                	mov    (%eax),%eax
  802406:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	8b 50 08             	mov    0x8(%eax),%edx
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 40 08             	mov    0x8(%eax),%eax
  802415:	39 c2                	cmp    %eax,%edx
  802417:	76 7d                	jbe    802496 <insert_sorted_allocList+0x251>
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	8b 50 08             	mov    0x8(%eax),%edx
  80241f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802422:	8b 40 08             	mov    0x8(%eax),%eax
  802425:	39 c2                	cmp    %eax,%edx
  802427:	73 6d                	jae    802496 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802429:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242d:	74 06                	je     802435 <insert_sorted_allocList+0x1f0>
  80242f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802433:	75 14                	jne    802449 <insert_sorted_allocList+0x204>
  802435:	83 ec 04             	sub    $0x4,%esp
  802438:	68 0c 41 80 00       	push   $0x80410c
  80243d:	6a 7f                	push   $0x7f
  80243f:	68 97 40 80 00       	push   $0x804097
  802444:	e8 65 df ff ff       	call   8003ae <_panic>
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 10                	mov    (%eax),%edx
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	89 10                	mov    %edx,(%eax)
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	8b 00                	mov    (%eax),%eax
  802458:	85 c0                	test   %eax,%eax
  80245a:	74 0b                	je     802467 <insert_sorted_allocList+0x222>
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	8b 00                	mov    (%eax),%eax
  802461:	8b 55 08             	mov    0x8(%ebp),%edx
  802464:	89 50 04             	mov    %edx,0x4(%eax)
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 55 08             	mov    0x8(%ebp),%edx
  80246d:	89 10                	mov    %edx,(%eax)
  80246f:	8b 45 08             	mov    0x8(%ebp),%eax
  802472:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802475:	89 50 04             	mov    %edx,0x4(%eax)
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	8b 00                	mov    (%eax),%eax
  80247d:	85 c0                	test   %eax,%eax
  80247f:	75 08                	jne    802489 <insert_sorted_allocList+0x244>
  802481:	8b 45 08             	mov    0x8(%ebp),%eax
  802484:	a3 44 50 80 00       	mov    %eax,0x805044
  802489:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80248e:	40                   	inc    %eax
  80248f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802494:	eb 39                	jmp    8024cf <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802496:	a1 48 50 80 00       	mov    0x805048,%eax
  80249b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80249e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a2:	74 07                	je     8024ab <insert_sorted_allocList+0x266>
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	8b 00                	mov    (%eax),%eax
  8024a9:	eb 05                	jmp    8024b0 <insert_sorted_allocList+0x26b>
  8024ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b0:	a3 48 50 80 00       	mov    %eax,0x805048
  8024b5:	a1 48 50 80 00       	mov    0x805048,%eax
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	0f 85 3f ff ff ff    	jne    802401 <insert_sorted_allocList+0x1bc>
  8024c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c6:	0f 85 35 ff ff ff    	jne    802401 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024cc:	eb 01                	jmp    8024cf <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024ce:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024cf:	90                   	nop
  8024d0:	c9                   	leave  
  8024d1:	c3                   	ret    

008024d2 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024d8:	a1 38 51 80 00       	mov    0x805138,%eax
  8024dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e0:	e9 85 01 00 00       	jmp    80266a <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ee:	0f 82 6e 01 00 00    	jb     802662 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024fd:	0f 85 8a 00 00 00    	jne    80258d <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802503:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802507:	75 17                	jne    802520 <alloc_block_FF+0x4e>
  802509:	83 ec 04             	sub    $0x4,%esp
  80250c:	68 40 41 80 00       	push   $0x804140
  802511:	68 93 00 00 00       	push   $0x93
  802516:	68 97 40 80 00       	push   $0x804097
  80251b:	e8 8e de ff ff       	call   8003ae <_panic>
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 00                	mov    (%eax),%eax
  802525:	85 c0                	test   %eax,%eax
  802527:	74 10                	je     802539 <alloc_block_FF+0x67>
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802531:	8b 52 04             	mov    0x4(%edx),%edx
  802534:	89 50 04             	mov    %edx,0x4(%eax)
  802537:	eb 0b                	jmp    802544 <alloc_block_FF+0x72>
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 40 04             	mov    0x4(%eax),%eax
  80253f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 40 04             	mov    0x4(%eax),%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 0f                	je     80255d <alloc_block_FF+0x8b>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 40 04             	mov    0x4(%eax),%eax
  802554:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802557:	8b 12                	mov    (%edx),%edx
  802559:	89 10                	mov    %edx,(%eax)
  80255b:	eb 0a                	jmp    802567 <alloc_block_FF+0x95>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	a3 38 51 80 00       	mov    %eax,0x805138
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257a:	a1 44 51 80 00       	mov    0x805144,%eax
  80257f:	48                   	dec    %eax
  802580:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	e9 10 01 00 00       	jmp    80269d <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 40 0c             	mov    0xc(%eax),%eax
  802593:	3b 45 08             	cmp    0x8(%ebp),%eax
  802596:	0f 86 c6 00 00 00    	jbe    802662 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80259c:	a1 48 51 80 00       	mov    0x805148,%eax
  8025a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 50 08             	mov    0x8(%eax),%edx
  8025aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ad:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8025b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b6:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8025b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025bd:	75 17                	jne    8025d6 <alloc_block_FF+0x104>
  8025bf:	83 ec 04             	sub    $0x4,%esp
  8025c2:	68 40 41 80 00       	push   $0x804140
  8025c7:	68 9b 00 00 00       	push   $0x9b
  8025cc:	68 97 40 80 00       	push   $0x804097
  8025d1:	e8 d8 dd ff ff       	call   8003ae <_panic>
  8025d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d9:	8b 00                	mov    (%eax),%eax
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	74 10                	je     8025ef <alloc_block_FF+0x11d>
  8025df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e2:	8b 00                	mov    (%eax),%eax
  8025e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025e7:	8b 52 04             	mov    0x4(%edx),%edx
  8025ea:	89 50 04             	mov    %edx,0x4(%eax)
  8025ed:	eb 0b                	jmp    8025fa <alloc_block_FF+0x128>
  8025ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f2:	8b 40 04             	mov    0x4(%eax),%eax
  8025f5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fd:	8b 40 04             	mov    0x4(%eax),%eax
  802600:	85 c0                	test   %eax,%eax
  802602:	74 0f                	je     802613 <alloc_block_FF+0x141>
  802604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802607:	8b 40 04             	mov    0x4(%eax),%eax
  80260a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80260d:	8b 12                	mov    (%edx),%edx
  80260f:	89 10                	mov    %edx,(%eax)
  802611:	eb 0a                	jmp    80261d <alloc_block_FF+0x14b>
  802613:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802616:	8b 00                	mov    (%eax),%eax
  802618:	a3 48 51 80 00       	mov    %eax,0x805148
  80261d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802626:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802629:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802630:	a1 54 51 80 00       	mov    0x805154,%eax
  802635:	48                   	dec    %eax
  802636:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 50 08             	mov    0x8(%eax),%edx
  802641:	8b 45 08             	mov    0x8(%ebp),%eax
  802644:	01 c2                	add    %eax,%edx
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 40 0c             	mov    0xc(%eax),%eax
  802652:	2b 45 08             	sub    0x8(%ebp),%eax
  802655:	89 c2                	mov    %eax,%edx
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80265d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802660:	eb 3b                	jmp    80269d <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802662:	a1 40 51 80 00       	mov    0x805140,%eax
  802667:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266e:	74 07                	je     802677 <alloc_block_FF+0x1a5>
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	eb 05                	jmp    80267c <alloc_block_FF+0x1aa>
  802677:	b8 00 00 00 00       	mov    $0x0,%eax
  80267c:	a3 40 51 80 00       	mov    %eax,0x805140
  802681:	a1 40 51 80 00       	mov    0x805140,%eax
  802686:	85 c0                	test   %eax,%eax
  802688:	0f 85 57 fe ff ff    	jne    8024e5 <alloc_block_FF+0x13>
  80268e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802692:	0f 85 4d fe ff ff    	jne    8024e5 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802698:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80269d:	c9                   	leave  
  80269e:	c3                   	ret    

0080269f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80269f:	55                   	push   %ebp
  8026a0:	89 e5                	mov    %esp,%ebp
  8026a2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8026a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026ac:	a1 38 51 80 00       	mov    0x805138,%eax
  8026b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b4:	e9 df 00 00 00       	jmp    802798 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c2:	0f 82 c8 00 00 00    	jb     802790 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d1:	0f 85 8a 00 00 00    	jne    802761 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8026d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026db:	75 17                	jne    8026f4 <alloc_block_BF+0x55>
  8026dd:	83 ec 04             	sub    $0x4,%esp
  8026e0:	68 40 41 80 00       	push   $0x804140
  8026e5:	68 b7 00 00 00       	push   $0xb7
  8026ea:	68 97 40 80 00       	push   $0x804097
  8026ef:	e8 ba dc ff ff       	call   8003ae <_panic>
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	8b 00                	mov    (%eax),%eax
  8026f9:	85 c0                	test   %eax,%eax
  8026fb:	74 10                	je     80270d <alloc_block_BF+0x6e>
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	8b 00                	mov    (%eax),%eax
  802702:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802705:	8b 52 04             	mov    0x4(%edx),%edx
  802708:	89 50 04             	mov    %edx,0x4(%eax)
  80270b:	eb 0b                	jmp    802718 <alloc_block_BF+0x79>
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 40 04             	mov    0x4(%eax),%eax
  802713:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 40 04             	mov    0x4(%eax),%eax
  80271e:	85 c0                	test   %eax,%eax
  802720:	74 0f                	je     802731 <alloc_block_BF+0x92>
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 40 04             	mov    0x4(%eax),%eax
  802728:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272b:	8b 12                	mov    (%edx),%edx
  80272d:	89 10                	mov    %edx,(%eax)
  80272f:	eb 0a                	jmp    80273b <alloc_block_BF+0x9c>
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	8b 00                	mov    (%eax),%eax
  802736:	a3 38 51 80 00       	mov    %eax,0x805138
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802747:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80274e:	a1 44 51 80 00       	mov    0x805144,%eax
  802753:	48                   	dec    %eax
  802754:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	e9 4d 01 00 00       	jmp    8028ae <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 40 0c             	mov    0xc(%eax),%eax
  802767:	3b 45 08             	cmp    0x8(%ebp),%eax
  80276a:	76 24                	jbe    802790 <alloc_block_BF+0xf1>
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	8b 40 0c             	mov    0xc(%eax),%eax
  802772:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802775:	73 19                	jae    802790 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802777:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	8b 40 0c             	mov    0xc(%eax),%eax
  802784:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	8b 40 08             	mov    0x8(%eax),%eax
  80278d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802790:	a1 40 51 80 00       	mov    0x805140,%eax
  802795:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802798:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279c:	74 07                	je     8027a5 <alloc_block_BF+0x106>
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	8b 00                	mov    (%eax),%eax
  8027a3:	eb 05                	jmp    8027aa <alloc_block_BF+0x10b>
  8027a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027aa:	a3 40 51 80 00       	mov    %eax,0x805140
  8027af:	a1 40 51 80 00       	mov    0x805140,%eax
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	0f 85 fd fe ff ff    	jne    8026b9 <alloc_block_BF+0x1a>
  8027bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c0:	0f 85 f3 fe ff ff    	jne    8026b9 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8027c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027ca:	0f 84 d9 00 00 00    	je     8028a9 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027d0:	a1 48 51 80 00       	mov    0x805148,%eax
  8027d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8027d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027de:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8027e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e7:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8027ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027ee:	75 17                	jne    802807 <alloc_block_BF+0x168>
  8027f0:	83 ec 04             	sub    $0x4,%esp
  8027f3:	68 40 41 80 00       	push   $0x804140
  8027f8:	68 c7 00 00 00       	push   $0xc7
  8027fd:	68 97 40 80 00       	push   $0x804097
  802802:	e8 a7 db ff ff       	call   8003ae <_panic>
  802807:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	74 10                	je     802820 <alloc_block_BF+0x181>
  802810:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802813:	8b 00                	mov    (%eax),%eax
  802815:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802818:	8b 52 04             	mov    0x4(%edx),%edx
  80281b:	89 50 04             	mov    %edx,0x4(%eax)
  80281e:	eb 0b                	jmp    80282b <alloc_block_BF+0x18c>
  802820:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802823:	8b 40 04             	mov    0x4(%eax),%eax
  802826:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80282b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282e:	8b 40 04             	mov    0x4(%eax),%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	74 0f                	je     802844 <alloc_block_BF+0x1a5>
  802835:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802838:	8b 40 04             	mov    0x4(%eax),%eax
  80283b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80283e:	8b 12                	mov    (%edx),%edx
  802840:	89 10                	mov    %edx,(%eax)
  802842:	eb 0a                	jmp    80284e <alloc_block_BF+0x1af>
  802844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	a3 48 51 80 00       	mov    %eax,0x805148
  80284e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802851:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80285a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802861:	a1 54 51 80 00       	mov    0x805154,%eax
  802866:	48                   	dec    %eax
  802867:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80286c:	83 ec 08             	sub    $0x8,%esp
  80286f:	ff 75 ec             	pushl  -0x14(%ebp)
  802872:	68 38 51 80 00       	push   $0x805138
  802877:	e8 71 f9 ff ff       	call   8021ed <find_block>
  80287c:	83 c4 10             	add    $0x10,%esp
  80287f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802882:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802885:	8b 50 08             	mov    0x8(%eax),%edx
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	01 c2                	add    %eax,%edx
  80288d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802890:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802893:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802896:	8b 40 0c             	mov    0xc(%eax),%eax
  802899:	2b 45 08             	sub    0x8(%ebp),%eax
  80289c:	89 c2                	mov    %eax,%edx
  80289e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a1:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8028a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a7:	eb 05                	jmp    8028ae <alloc_block_BF+0x20f>
	}
	return NULL;
  8028a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ae:	c9                   	leave  
  8028af:	c3                   	ret    

008028b0 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
  8028b3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8028b6:	a1 28 50 80 00       	mov    0x805028,%eax
  8028bb:	85 c0                	test   %eax,%eax
  8028bd:	0f 85 de 01 00 00    	jne    802aa1 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028c3:	a1 38 51 80 00       	mov    0x805138,%eax
  8028c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028cb:	e9 9e 01 00 00       	jmp    802a6e <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d9:	0f 82 87 01 00 00    	jb     802a66 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e8:	0f 85 95 00 00 00    	jne    802983 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8028ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f2:	75 17                	jne    80290b <alloc_block_NF+0x5b>
  8028f4:	83 ec 04             	sub    $0x4,%esp
  8028f7:	68 40 41 80 00       	push   $0x804140
  8028fc:	68 e0 00 00 00       	push   $0xe0
  802901:	68 97 40 80 00       	push   $0x804097
  802906:	e8 a3 da ff ff       	call   8003ae <_panic>
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	8b 00                	mov    (%eax),%eax
  802910:	85 c0                	test   %eax,%eax
  802912:	74 10                	je     802924 <alloc_block_NF+0x74>
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 00                	mov    (%eax),%eax
  802919:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291c:	8b 52 04             	mov    0x4(%edx),%edx
  80291f:	89 50 04             	mov    %edx,0x4(%eax)
  802922:	eb 0b                	jmp    80292f <alloc_block_NF+0x7f>
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	8b 40 04             	mov    0x4(%eax),%eax
  80292a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	8b 40 04             	mov    0x4(%eax),%eax
  802935:	85 c0                	test   %eax,%eax
  802937:	74 0f                	je     802948 <alloc_block_NF+0x98>
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 40 04             	mov    0x4(%eax),%eax
  80293f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802942:	8b 12                	mov    (%edx),%edx
  802944:	89 10                	mov    %edx,(%eax)
  802946:	eb 0a                	jmp    802952 <alloc_block_NF+0xa2>
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	8b 00                	mov    (%eax),%eax
  80294d:	a3 38 51 80 00       	mov    %eax,0x805138
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802965:	a1 44 51 80 00       	mov    0x805144,%eax
  80296a:	48                   	dec    %eax
  80296b:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 40 08             	mov    0x8(%eax),%eax
  802976:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	e9 f8 04 00 00       	jmp    802e7b <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 40 0c             	mov    0xc(%eax),%eax
  802989:	3b 45 08             	cmp    0x8(%ebp),%eax
  80298c:	0f 86 d4 00 00 00    	jbe    802a66 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802992:	a1 48 51 80 00       	mov    0x805148,%eax
  802997:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	8b 50 08             	mov    0x8(%eax),%edx
  8029a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a3:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8029a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ac:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029b3:	75 17                	jne    8029cc <alloc_block_NF+0x11c>
  8029b5:	83 ec 04             	sub    $0x4,%esp
  8029b8:	68 40 41 80 00       	push   $0x804140
  8029bd:	68 e9 00 00 00       	push   $0xe9
  8029c2:	68 97 40 80 00       	push   $0x804097
  8029c7:	e8 e2 d9 ff ff       	call   8003ae <_panic>
  8029cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cf:	8b 00                	mov    (%eax),%eax
  8029d1:	85 c0                	test   %eax,%eax
  8029d3:	74 10                	je     8029e5 <alloc_block_NF+0x135>
  8029d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d8:	8b 00                	mov    (%eax),%eax
  8029da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029dd:	8b 52 04             	mov    0x4(%edx),%edx
  8029e0:	89 50 04             	mov    %edx,0x4(%eax)
  8029e3:	eb 0b                	jmp    8029f0 <alloc_block_NF+0x140>
  8029e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e8:	8b 40 04             	mov    0x4(%eax),%eax
  8029eb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f3:	8b 40 04             	mov    0x4(%eax),%eax
  8029f6:	85 c0                	test   %eax,%eax
  8029f8:	74 0f                	je     802a09 <alloc_block_NF+0x159>
  8029fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fd:	8b 40 04             	mov    0x4(%eax),%eax
  802a00:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a03:	8b 12                	mov    (%edx),%edx
  802a05:	89 10                	mov    %edx,(%eax)
  802a07:	eb 0a                	jmp    802a13 <alloc_block_NF+0x163>
  802a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	a3 48 51 80 00       	mov    %eax,0x805148
  802a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a26:	a1 54 51 80 00       	mov    0x805154,%eax
  802a2b:	48                   	dec    %eax
  802a2c:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a34:	8b 40 08             	mov    0x8(%eax),%eax
  802a37:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 50 08             	mov    0x8(%eax),%edx
  802a42:	8b 45 08             	mov    0x8(%ebp),%eax
  802a45:	01 c2                	add    %eax,%edx
  802a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4a:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 40 0c             	mov    0xc(%eax),%eax
  802a53:	2b 45 08             	sub    0x8(%ebp),%eax
  802a56:	89 c2                	mov    %eax,%edx
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a61:	e9 15 04 00 00       	jmp    802e7b <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a66:	a1 40 51 80 00       	mov    0x805140,%eax
  802a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a72:	74 07                	je     802a7b <alloc_block_NF+0x1cb>
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	8b 00                	mov    (%eax),%eax
  802a79:	eb 05                	jmp    802a80 <alloc_block_NF+0x1d0>
  802a7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a80:	a3 40 51 80 00       	mov    %eax,0x805140
  802a85:	a1 40 51 80 00       	mov    0x805140,%eax
  802a8a:	85 c0                	test   %eax,%eax
  802a8c:	0f 85 3e fe ff ff    	jne    8028d0 <alloc_block_NF+0x20>
  802a92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a96:	0f 85 34 fe ff ff    	jne    8028d0 <alloc_block_NF+0x20>
  802a9c:	e9 d5 03 00 00       	jmp    802e76 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa1:	a1 38 51 80 00       	mov    0x805138,%eax
  802aa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa9:	e9 b1 01 00 00       	jmp    802c5f <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	8b 50 08             	mov    0x8(%eax),%edx
  802ab4:	a1 28 50 80 00       	mov    0x805028,%eax
  802ab9:	39 c2                	cmp    %eax,%edx
  802abb:	0f 82 96 01 00 00    	jb     802c57 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aca:	0f 82 87 01 00 00    	jb     802c57 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad9:	0f 85 95 00 00 00    	jne    802b74 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802adf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae3:	75 17                	jne    802afc <alloc_block_NF+0x24c>
  802ae5:	83 ec 04             	sub    $0x4,%esp
  802ae8:	68 40 41 80 00       	push   $0x804140
  802aed:	68 fc 00 00 00       	push   $0xfc
  802af2:	68 97 40 80 00       	push   $0x804097
  802af7:	e8 b2 d8 ff ff       	call   8003ae <_panic>
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	8b 00                	mov    (%eax),%eax
  802b01:	85 c0                	test   %eax,%eax
  802b03:	74 10                	je     802b15 <alloc_block_NF+0x265>
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 00                	mov    (%eax),%eax
  802b0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b0d:	8b 52 04             	mov    0x4(%edx),%edx
  802b10:	89 50 04             	mov    %edx,0x4(%eax)
  802b13:	eb 0b                	jmp    802b20 <alloc_block_NF+0x270>
  802b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b18:	8b 40 04             	mov    0x4(%eax),%eax
  802b1b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 40 04             	mov    0x4(%eax),%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	74 0f                	je     802b39 <alloc_block_NF+0x289>
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	8b 40 04             	mov    0x4(%eax),%eax
  802b30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b33:	8b 12                	mov    (%edx),%edx
  802b35:	89 10                	mov    %edx,(%eax)
  802b37:	eb 0a                	jmp    802b43 <alloc_block_NF+0x293>
  802b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3c:	8b 00                	mov    (%eax),%eax
  802b3e:	a3 38 51 80 00       	mov    %eax,0x805138
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b56:	a1 44 51 80 00       	mov    0x805144,%eax
  802b5b:	48                   	dec    %eax
  802b5c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	8b 40 08             	mov    0x8(%eax),%eax
  802b67:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	e9 07 03 00 00       	jmp    802e7b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b7d:	0f 86 d4 00 00 00    	jbe    802c57 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b83:	a1 48 51 80 00       	mov    0x805148,%eax
  802b88:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 50 08             	mov    0x8(%eax),%edx
  802b91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b94:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ba0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ba4:	75 17                	jne    802bbd <alloc_block_NF+0x30d>
  802ba6:	83 ec 04             	sub    $0x4,%esp
  802ba9:	68 40 41 80 00       	push   $0x804140
  802bae:	68 04 01 00 00       	push   $0x104
  802bb3:	68 97 40 80 00       	push   $0x804097
  802bb8:	e8 f1 d7 ff ff       	call   8003ae <_panic>
  802bbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc0:	8b 00                	mov    (%eax),%eax
  802bc2:	85 c0                	test   %eax,%eax
  802bc4:	74 10                	je     802bd6 <alloc_block_NF+0x326>
  802bc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc9:	8b 00                	mov    (%eax),%eax
  802bcb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bce:	8b 52 04             	mov    0x4(%edx),%edx
  802bd1:	89 50 04             	mov    %edx,0x4(%eax)
  802bd4:	eb 0b                	jmp    802be1 <alloc_block_NF+0x331>
  802bd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd9:	8b 40 04             	mov    0x4(%eax),%eax
  802bdc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802be1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be4:	8b 40 04             	mov    0x4(%eax),%eax
  802be7:	85 c0                	test   %eax,%eax
  802be9:	74 0f                	je     802bfa <alloc_block_NF+0x34a>
  802beb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bee:	8b 40 04             	mov    0x4(%eax),%eax
  802bf1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bf4:	8b 12                	mov    (%edx),%edx
  802bf6:	89 10                	mov    %edx,(%eax)
  802bf8:	eb 0a                	jmp    802c04 <alloc_block_NF+0x354>
  802bfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bfd:	8b 00                	mov    (%eax),%eax
  802bff:	a3 48 51 80 00       	mov    %eax,0x805148
  802c04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c17:	a1 54 51 80 00       	mov    0x805154,%eax
  802c1c:	48                   	dec    %eax
  802c1d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c25:	8b 40 08             	mov    0x8(%eax),%eax
  802c28:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	8b 50 08             	mov    0x8(%eax),%edx
  802c33:	8b 45 08             	mov    0x8(%ebp),%eax
  802c36:	01 c2                	add    %eax,%edx
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 40 0c             	mov    0xc(%eax),%eax
  802c44:	2b 45 08             	sub    0x8(%ebp),%eax
  802c47:	89 c2                	mov    %eax,%edx
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c52:	e9 24 02 00 00       	jmp    802e7b <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c57:	a1 40 51 80 00       	mov    0x805140,%eax
  802c5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c63:	74 07                	je     802c6c <alloc_block_NF+0x3bc>
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 00                	mov    (%eax),%eax
  802c6a:	eb 05                	jmp    802c71 <alloc_block_NF+0x3c1>
  802c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c71:	a3 40 51 80 00       	mov    %eax,0x805140
  802c76:	a1 40 51 80 00       	mov    0x805140,%eax
  802c7b:	85 c0                	test   %eax,%eax
  802c7d:	0f 85 2b fe ff ff    	jne    802aae <alloc_block_NF+0x1fe>
  802c83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c87:	0f 85 21 fe ff ff    	jne    802aae <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c8d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c95:	e9 ae 01 00 00       	jmp    802e48 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 50 08             	mov    0x8(%eax),%edx
  802ca0:	a1 28 50 80 00       	mov    0x805028,%eax
  802ca5:	39 c2                	cmp    %eax,%edx
  802ca7:	0f 83 93 01 00 00    	jae    802e40 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cb6:	0f 82 84 01 00 00    	jb     802e40 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc5:	0f 85 95 00 00 00    	jne    802d60 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ccb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccf:	75 17                	jne    802ce8 <alloc_block_NF+0x438>
  802cd1:	83 ec 04             	sub    $0x4,%esp
  802cd4:	68 40 41 80 00       	push   $0x804140
  802cd9:	68 14 01 00 00       	push   $0x114
  802cde:	68 97 40 80 00       	push   $0x804097
  802ce3:	e8 c6 d6 ff ff       	call   8003ae <_panic>
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	8b 00                	mov    (%eax),%eax
  802ced:	85 c0                	test   %eax,%eax
  802cef:	74 10                	je     802d01 <alloc_block_NF+0x451>
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	8b 00                	mov    (%eax),%eax
  802cf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf9:	8b 52 04             	mov    0x4(%edx),%edx
  802cfc:	89 50 04             	mov    %edx,0x4(%eax)
  802cff:	eb 0b                	jmp    802d0c <alloc_block_NF+0x45c>
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	8b 40 04             	mov    0x4(%eax),%eax
  802d07:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 40 04             	mov    0x4(%eax),%eax
  802d12:	85 c0                	test   %eax,%eax
  802d14:	74 0f                	je     802d25 <alloc_block_NF+0x475>
  802d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d19:	8b 40 04             	mov    0x4(%eax),%eax
  802d1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1f:	8b 12                	mov    (%edx),%edx
  802d21:	89 10                	mov    %edx,(%eax)
  802d23:	eb 0a                	jmp    802d2f <alloc_block_NF+0x47f>
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	8b 00                	mov    (%eax),%eax
  802d2a:	a3 38 51 80 00       	mov    %eax,0x805138
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d42:	a1 44 51 80 00       	mov    0x805144,%eax
  802d47:	48                   	dec    %eax
  802d48:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	8b 40 08             	mov    0x8(%eax),%eax
  802d53:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	e9 1b 01 00 00       	jmp    802e7b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	8b 40 0c             	mov    0xc(%eax),%eax
  802d66:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d69:	0f 86 d1 00 00 00    	jbe    802e40 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d6f:	a1 48 51 80 00       	mov    0x805148,%eax
  802d74:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	8b 50 08             	mov    0x8(%eax),%edx
  802d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d80:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d86:	8b 55 08             	mov    0x8(%ebp),%edx
  802d89:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d8c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d90:	75 17                	jne    802da9 <alloc_block_NF+0x4f9>
  802d92:	83 ec 04             	sub    $0x4,%esp
  802d95:	68 40 41 80 00       	push   $0x804140
  802d9a:	68 1c 01 00 00       	push   $0x11c
  802d9f:	68 97 40 80 00       	push   $0x804097
  802da4:	e8 05 d6 ff ff       	call   8003ae <_panic>
  802da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dac:	8b 00                	mov    (%eax),%eax
  802dae:	85 c0                	test   %eax,%eax
  802db0:	74 10                	je     802dc2 <alloc_block_NF+0x512>
  802db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db5:	8b 00                	mov    (%eax),%eax
  802db7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dba:	8b 52 04             	mov    0x4(%edx),%edx
  802dbd:	89 50 04             	mov    %edx,0x4(%eax)
  802dc0:	eb 0b                	jmp    802dcd <alloc_block_NF+0x51d>
  802dc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc5:	8b 40 04             	mov    0x4(%eax),%eax
  802dc8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd0:	8b 40 04             	mov    0x4(%eax),%eax
  802dd3:	85 c0                	test   %eax,%eax
  802dd5:	74 0f                	je     802de6 <alloc_block_NF+0x536>
  802dd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dda:	8b 40 04             	mov    0x4(%eax),%eax
  802ddd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802de0:	8b 12                	mov    (%edx),%edx
  802de2:	89 10                	mov    %edx,(%eax)
  802de4:	eb 0a                	jmp    802df0 <alloc_block_NF+0x540>
  802de6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	a3 48 51 80 00       	mov    %eax,0x805148
  802df0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e03:	a1 54 51 80 00       	mov    0x805154,%eax
  802e08:	48                   	dec    %eax
  802e09:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e11:	8b 40 08             	mov    0x8(%eax),%eax
  802e14:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 50 08             	mov    0x8(%eax),%edx
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	01 c2                	add    %eax,%edx
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e30:	2b 45 08             	sub    0x8(%ebp),%eax
  802e33:	89 c2                	mov    %eax,%edx
  802e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e38:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3e:	eb 3b                	jmp    802e7b <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e40:	a1 40 51 80 00       	mov    0x805140,%eax
  802e45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4c:	74 07                	je     802e55 <alloc_block_NF+0x5a5>
  802e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e51:	8b 00                	mov    (%eax),%eax
  802e53:	eb 05                	jmp    802e5a <alloc_block_NF+0x5aa>
  802e55:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5a:	a3 40 51 80 00       	mov    %eax,0x805140
  802e5f:	a1 40 51 80 00       	mov    0x805140,%eax
  802e64:	85 c0                	test   %eax,%eax
  802e66:	0f 85 2e fe ff ff    	jne    802c9a <alloc_block_NF+0x3ea>
  802e6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e70:	0f 85 24 fe ff ff    	jne    802c9a <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e7b:	c9                   	leave  
  802e7c:	c3                   	ret    

00802e7d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e7d:	55                   	push   %ebp
  802e7e:	89 e5                	mov    %esp,%ebp
  802e80:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e83:	a1 38 51 80 00       	mov    0x805138,%eax
  802e88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e8b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e90:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e93:	a1 38 51 80 00       	mov    0x805138,%eax
  802e98:	85 c0                	test   %eax,%eax
  802e9a:	74 14                	je     802eb0 <insert_sorted_with_merge_freeList+0x33>
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	8b 50 08             	mov    0x8(%eax),%edx
  802ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea5:	8b 40 08             	mov    0x8(%eax),%eax
  802ea8:	39 c2                	cmp    %eax,%edx
  802eaa:	0f 87 9b 01 00 00    	ja     80304b <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802eb0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb4:	75 17                	jne    802ecd <insert_sorted_with_merge_freeList+0x50>
  802eb6:	83 ec 04             	sub    $0x4,%esp
  802eb9:	68 74 40 80 00       	push   $0x804074
  802ebe:	68 38 01 00 00       	push   $0x138
  802ec3:	68 97 40 80 00       	push   $0x804097
  802ec8:	e8 e1 d4 ff ff       	call   8003ae <_panic>
  802ecd:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	89 10                	mov    %edx,(%eax)
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	8b 00                	mov    (%eax),%eax
  802edd:	85 c0                	test   %eax,%eax
  802edf:	74 0d                	je     802eee <insert_sorted_with_merge_freeList+0x71>
  802ee1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee9:	89 50 04             	mov    %edx,0x4(%eax)
  802eec:	eb 08                	jmp    802ef6 <insert_sorted_with_merge_freeList+0x79>
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	a3 38 51 80 00       	mov    %eax,0x805138
  802efe:	8b 45 08             	mov    0x8(%ebp),%eax
  802f01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f08:	a1 44 51 80 00       	mov    0x805144,%eax
  802f0d:	40                   	inc    %eax
  802f0e:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f17:	0f 84 a8 06 00 00    	je     8035c5 <insert_sorted_with_merge_freeList+0x748>
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	8b 50 08             	mov    0x8(%eax),%edx
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	8b 40 0c             	mov    0xc(%eax),%eax
  802f29:	01 c2                	add    %eax,%edx
  802f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2e:	8b 40 08             	mov    0x8(%eax),%eax
  802f31:	39 c2                	cmp    %eax,%edx
  802f33:	0f 85 8c 06 00 00    	jne    8035c5 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f39:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f42:	8b 40 0c             	mov    0xc(%eax),%eax
  802f45:	01 c2                	add    %eax,%edx
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f51:	75 17                	jne    802f6a <insert_sorted_with_merge_freeList+0xed>
  802f53:	83 ec 04             	sub    $0x4,%esp
  802f56:	68 40 41 80 00       	push   $0x804140
  802f5b:	68 3c 01 00 00       	push   $0x13c
  802f60:	68 97 40 80 00       	push   $0x804097
  802f65:	e8 44 d4 ff ff       	call   8003ae <_panic>
  802f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6d:	8b 00                	mov    (%eax),%eax
  802f6f:	85 c0                	test   %eax,%eax
  802f71:	74 10                	je     802f83 <insert_sorted_with_merge_freeList+0x106>
  802f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f76:	8b 00                	mov    (%eax),%eax
  802f78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f7b:	8b 52 04             	mov    0x4(%edx),%edx
  802f7e:	89 50 04             	mov    %edx,0x4(%eax)
  802f81:	eb 0b                	jmp    802f8e <insert_sorted_with_merge_freeList+0x111>
  802f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f86:	8b 40 04             	mov    0x4(%eax),%eax
  802f89:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f91:	8b 40 04             	mov    0x4(%eax),%eax
  802f94:	85 c0                	test   %eax,%eax
  802f96:	74 0f                	je     802fa7 <insert_sorted_with_merge_freeList+0x12a>
  802f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9b:	8b 40 04             	mov    0x4(%eax),%eax
  802f9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa1:	8b 12                	mov    (%edx),%edx
  802fa3:	89 10                	mov    %edx,(%eax)
  802fa5:	eb 0a                	jmp    802fb1 <insert_sorted_with_merge_freeList+0x134>
  802fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802faa:	8b 00                	mov    (%eax),%eax
  802fac:	a3 38 51 80 00       	mov    %eax,0x805138
  802fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc4:	a1 44 51 80 00       	mov    0x805144,%eax
  802fc9:	48                   	dec    %eax
  802fca:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802fe3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fe7:	75 17                	jne    803000 <insert_sorted_with_merge_freeList+0x183>
  802fe9:	83 ec 04             	sub    $0x4,%esp
  802fec:	68 74 40 80 00       	push   $0x804074
  802ff1:	68 3f 01 00 00       	push   $0x13f
  802ff6:	68 97 40 80 00       	push   $0x804097
  802ffb:	e8 ae d3 ff ff       	call   8003ae <_panic>
  803000:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803006:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803009:	89 10                	mov    %edx,(%eax)
  80300b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300e:	8b 00                	mov    (%eax),%eax
  803010:	85 c0                	test   %eax,%eax
  803012:	74 0d                	je     803021 <insert_sorted_with_merge_freeList+0x1a4>
  803014:	a1 48 51 80 00       	mov    0x805148,%eax
  803019:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80301c:	89 50 04             	mov    %edx,0x4(%eax)
  80301f:	eb 08                	jmp    803029 <insert_sorted_with_merge_freeList+0x1ac>
  803021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803024:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302c:	a3 48 51 80 00       	mov    %eax,0x805148
  803031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803034:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303b:	a1 54 51 80 00       	mov    0x805154,%eax
  803040:	40                   	inc    %eax
  803041:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803046:	e9 7a 05 00 00       	jmp    8035c5 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	8b 50 08             	mov    0x8(%eax),%edx
  803051:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803054:	8b 40 08             	mov    0x8(%eax),%eax
  803057:	39 c2                	cmp    %eax,%edx
  803059:	0f 82 14 01 00 00    	jb     803173 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80305f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803062:	8b 50 08             	mov    0x8(%eax),%edx
  803065:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803068:	8b 40 0c             	mov    0xc(%eax),%eax
  80306b:	01 c2                	add    %eax,%edx
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	8b 40 08             	mov    0x8(%eax),%eax
  803073:	39 c2                	cmp    %eax,%edx
  803075:	0f 85 90 00 00 00    	jne    80310b <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80307b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307e:	8b 50 0c             	mov    0xc(%eax),%edx
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	8b 40 0c             	mov    0xc(%eax),%eax
  803087:	01 c2                	add    %eax,%edx
  803089:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308c:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80308f:	8b 45 08             	mov    0x8(%ebp),%eax
  803092:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a7:	75 17                	jne    8030c0 <insert_sorted_with_merge_freeList+0x243>
  8030a9:	83 ec 04             	sub    $0x4,%esp
  8030ac:	68 74 40 80 00       	push   $0x804074
  8030b1:	68 49 01 00 00       	push   $0x149
  8030b6:	68 97 40 80 00       	push   $0x804097
  8030bb:	e8 ee d2 ff ff       	call   8003ae <_panic>
  8030c0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c9:	89 10                	mov    %edx,(%eax)
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	8b 00                	mov    (%eax),%eax
  8030d0:	85 c0                	test   %eax,%eax
  8030d2:	74 0d                	je     8030e1 <insert_sorted_with_merge_freeList+0x264>
  8030d4:	a1 48 51 80 00       	mov    0x805148,%eax
  8030d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8030dc:	89 50 04             	mov    %edx,0x4(%eax)
  8030df:	eb 08                	jmp    8030e9 <insert_sorted_with_merge_freeList+0x26c>
  8030e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8030f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030fb:	a1 54 51 80 00       	mov    0x805154,%eax
  803100:	40                   	inc    %eax
  803101:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803106:	e9 bb 04 00 00       	jmp    8035c6 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80310b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310f:	75 17                	jne    803128 <insert_sorted_with_merge_freeList+0x2ab>
  803111:	83 ec 04             	sub    $0x4,%esp
  803114:	68 e8 40 80 00       	push   $0x8040e8
  803119:	68 4c 01 00 00       	push   $0x14c
  80311e:	68 97 40 80 00       	push   $0x804097
  803123:	e8 86 d2 ff ff       	call   8003ae <_panic>
  803128:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	89 50 04             	mov    %edx,0x4(%eax)
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	8b 40 04             	mov    0x4(%eax),%eax
  80313a:	85 c0                	test   %eax,%eax
  80313c:	74 0c                	je     80314a <insert_sorted_with_merge_freeList+0x2cd>
  80313e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803143:	8b 55 08             	mov    0x8(%ebp),%edx
  803146:	89 10                	mov    %edx,(%eax)
  803148:	eb 08                	jmp    803152 <insert_sorted_with_merge_freeList+0x2d5>
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	a3 38 51 80 00       	mov    %eax,0x805138
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803163:	a1 44 51 80 00       	mov    0x805144,%eax
  803168:	40                   	inc    %eax
  803169:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80316e:	e9 53 04 00 00       	jmp    8035c6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803173:	a1 38 51 80 00       	mov    0x805138,%eax
  803178:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80317b:	e9 15 04 00 00       	jmp    803595 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803183:	8b 00                	mov    (%eax),%eax
  803185:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	8b 50 08             	mov    0x8(%eax),%edx
  80318e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803191:	8b 40 08             	mov    0x8(%eax),%eax
  803194:	39 c2                	cmp    %eax,%edx
  803196:	0f 86 f1 03 00 00    	jbe    80358d <insert_sorted_with_merge_freeList+0x710>
  80319c:	8b 45 08             	mov    0x8(%ebp),%eax
  80319f:	8b 50 08             	mov    0x8(%eax),%edx
  8031a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a5:	8b 40 08             	mov    0x8(%eax),%eax
  8031a8:	39 c2                	cmp    %eax,%edx
  8031aa:	0f 83 dd 03 00 00    	jae    80358d <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8031b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b3:	8b 50 08             	mov    0x8(%eax),%edx
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bc:	01 c2                	add    %eax,%edx
  8031be:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c1:	8b 40 08             	mov    0x8(%eax),%eax
  8031c4:	39 c2                	cmp    %eax,%edx
  8031c6:	0f 85 b9 01 00 00    	jne    803385 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	8b 50 08             	mov    0x8(%eax),%edx
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d8:	01 c2                	add    %eax,%edx
  8031da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dd:	8b 40 08             	mov    0x8(%eax),%eax
  8031e0:	39 c2                	cmp    %eax,%edx
  8031e2:	0f 85 0d 01 00 00    	jne    8032f5 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f4:	01 c2                	add    %eax,%edx
  8031f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f9:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803200:	75 17                	jne    803219 <insert_sorted_with_merge_freeList+0x39c>
  803202:	83 ec 04             	sub    $0x4,%esp
  803205:	68 40 41 80 00       	push   $0x804140
  80320a:	68 5c 01 00 00       	push   $0x15c
  80320f:	68 97 40 80 00       	push   $0x804097
  803214:	e8 95 d1 ff ff       	call   8003ae <_panic>
  803219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321c:	8b 00                	mov    (%eax),%eax
  80321e:	85 c0                	test   %eax,%eax
  803220:	74 10                	je     803232 <insert_sorted_with_merge_freeList+0x3b5>
  803222:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803225:	8b 00                	mov    (%eax),%eax
  803227:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80322a:	8b 52 04             	mov    0x4(%edx),%edx
  80322d:	89 50 04             	mov    %edx,0x4(%eax)
  803230:	eb 0b                	jmp    80323d <insert_sorted_with_merge_freeList+0x3c0>
  803232:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803235:	8b 40 04             	mov    0x4(%eax),%eax
  803238:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80323d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803240:	8b 40 04             	mov    0x4(%eax),%eax
  803243:	85 c0                	test   %eax,%eax
  803245:	74 0f                	je     803256 <insert_sorted_with_merge_freeList+0x3d9>
  803247:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324a:	8b 40 04             	mov    0x4(%eax),%eax
  80324d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803250:	8b 12                	mov    (%edx),%edx
  803252:	89 10                	mov    %edx,(%eax)
  803254:	eb 0a                	jmp    803260 <insert_sorted_with_merge_freeList+0x3e3>
  803256:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803259:	8b 00                	mov    (%eax),%eax
  80325b:	a3 38 51 80 00       	mov    %eax,0x805138
  803260:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803263:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803269:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803273:	a1 44 51 80 00       	mov    0x805144,%eax
  803278:	48                   	dec    %eax
  803279:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80327e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803281:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803288:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803292:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803296:	75 17                	jne    8032af <insert_sorted_with_merge_freeList+0x432>
  803298:	83 ec 04             	sub    $0x4,%esp
  80329b:	68 74 40 80 00       	push   $0x804074
  8032a0:	68 5f 01 00 00       	push   $0x15f
  8032a5:	68 97 40 80 00       	push   $0x804097
  8032aa:	e8 ff d0 ff ff       	call   8003ae <_panic>
  8032af:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b8:	89 10                	mov    %edx,(%eax)
  8032ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bd:	8b 00                	mov    (%eax),%eax
  8032bf:	85 c0                	test   %eax,%eax
  8032c1:	74 0d                	je     8032d0 <insert_sorted_with_merge_freeList+0x453>
  8032c3:	a1 48 51 80 00       	mov    0x805148,%eax
  8032c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032cb:	89 50 04             	mov    %edx,0x4(%eax)
  8032ce:	eb 08                	jmp    8032d8 <insert_sorted_with_merge_freeList+0x45b>
  8032d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032db:	a3 48 51 80 00       	mov    %eax,0x805148
  8032e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ea:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ef:	40                   	inc    %eax
  8032f0:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8032f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f8:	8b 50 0c             	mov    0xc(%eax),%edx
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803301:	01 c2                	add    %eax,%edx
  803303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803306:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803313:	8b 45 08             	mov    0x8(%ebp),%eax
  803316:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80331d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803321:	75 17                	jne    80333a <insert_sorted_with_merge_freeList+0x4bd>
  803323:	83 ec 04             	sub    $0x4,%esp
  803326:	68 74 40 80 00       	push   $0x804074
  80332b:	68 64 01 00 00       	push   $0x164
  803330:	68 97 40 80 00       	push   $0x804097
  803335:	e8 74 d0 ff ff       	call   8003ae <_panic>
  80333a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	89 10                	mov    %edx,(%eax)
  803345:	8b 45 08             	mov    0x8(%ebp),%eax
  803348:	8b 00                	mov    (%eax),%eax
  80334a:	85 c0                	test   %eax,%eax
  80334c:	74 0d                	je     80335b <insert_sorted_with_merge_freeList+0x4de>
  80334e:	a1 48 51 80 00       	mov    0x805148,%eax
  803353:	8b 55 08             	mov    0x8(%ebp),%edx
  803356:	89 50 04             	mov    %edx,0x4(%eax)
  803359:	eb 08                	jmp    803363 <insert_sorted_with_merge_freeList+0x4e6>
  80335b:	8b 45 08             	mov    0x8(%ebp),%eax
  80335e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	a3 48 51 80 00       	mov    %eax,0x805148
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803375:	a1 54 51 80 00       	mov    0x805154,%eax
  80337a:	40                   	inc    %eax
  80337b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803380:	e9 41 02 00 00       	jmp    8035c6 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	8b 50 08             	mov    0x8(%eax),%edx
  80338b:	8b 45 08             	mov    0x8(%ebp),%eax
  80338e:	8b 40 0c             	mov    0xc(%eax),%eax
  803391:	01 c2                	add    %eax,%edx
  803393:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803396:	8b 40 08             	mov    0x8(%eax),%eax
  803399:	39 c2                	cmp    %eax,%edx
  80339b:	0f 85 7c 01 00 00    	jne    80351d <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8033a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033a5:	74 06                	je     8033ad <insert_sorted_with_merge_freeList+0x530>
  8033a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ab:	75 17                	jne    8033c4 <insert_sorted_with_merge_freeList+0x547>
  8033ad:	83 ec 04             	sub    $0x4,%esp
  8033b0:	68 b0 40 80 00       	push   $0x8040b0
  8033b5:	68 69 01 00 00       	push   $0x169
  8033ba:	68 97 40 80 00       	push   $0x804097
  8033bf:	e8 ea cf ff ff       	call   8003ae <_panic>
  8033c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c7:	8b 50 04             	mov    0x4(%eax),%edx
  8033ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cd:	89 50 04             	mov    %edx,0x4(%eax)
  8033d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033d6:	89 10                	mov    %edx,(%eax)
  8033d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033db:	8b 40 04             	mov    0x4(%eax),%eax
  8033de:	85 c0                	test   %eax,%eax
  8033e0:	74 0d                	je     8033ef <insert_sorted_with_merge_freeList+0x572>
  8033e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e5:	8b 40 04             	mov    0x4(%eax),%eax
  8033e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8033eb:	89 10                	mov    %edx,(%eax)
  8033ed:	eb 08                	jmp    8033f7 <insert_sorted_with_merge_freeList+0x57a>
  8033ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f2:	a3 38 51 80 00       	mov    %eax,0x805138
  8033f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8033fd:	89 50 04             	mov    %edx,0x4(%eax)
  803400:	a1 44 51 80 00       	mov    0x805144,%eax
  803405:	40                   	inc    %eax
  803406:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80340b:	8b 45 08             	mov    0x8(%ebp),%eax
  80340e:	8b 50 0c             	mov    0xc(%eax),%edx
  803411:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803414:	8b 40 0c             	mov    0xc(%eax),%eax
  803417:	01 c2                	add    %eax,%edx
  803419:	8b 45 08             	mov    0x8(%ebp),%eax
  80341c:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80341f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803423:	75 17                	jne    80343c <insert_sorted_with_merge_freeList+0x5bf>
  803425:	83 ec 04             	sub    $0x4,%esp
  803428:	68 40 41 80 00       	push   $0x804140
  80342d:	68 6b 01 00 00       	push   $0x16b
  803432:	68 97 40 80 00       	push   $0x804097
  803437:	e8 72 cf ff ff       	call   8003ae <_panic>
  80343c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343f:	8b 00                	mov    (%eax),%eax
  803441:	85 c0                	test   %eax,%eax
  803443:	74 10                	je     803455 <insert_sorted_with_merge_freeList+0x5d8>
  803445:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803448:	8b 00                	mov    (%eax),%eax
  80344a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80344d:	8b 52 04             	mov    0x4(%edx),%edx
  803450:	89 50 04             	mov    %edx,0x4(%eax)
  803453:	eb 0b                	jmp    803460 <insert_sorted_with_merge_freeList+0x5e3>
  803455:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803458:	8b 40 04             	mov    0x4(%eax),%eax
  80345b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803460:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803463:	8b 40 04             	mov    0x4(%eax),%eax
  803466:	85 c0                	test   %eax,%eax
  803468:	74 0f                	je     803479 <insert_sorted_with_merge_freeList+0x5fc>
  80346a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346d:	8b 40 04             	mov    0x4(%eax),%eax
  803470:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803473:	8b 12                	mov    (%edx),%edx
  803475:	89 10                	mov    %edx,(%eax)
  803477:	eb 0a                	jmp    803483 <insert_sorted_with_merge_freeList+0x606>
  803479:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347c:	8b 00                	mov    (%eax),%eax
  80347e:	a3 38 51 80 00       	mov    %eax,0x805138
  803483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803486:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80348c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803496:	a1 44 51 80 00       	mov    0x805144,%eax
  80349b:	48                   	dec    %eax
  80349c:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8034a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8034ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034b9:	75 17                	jne    8034d2 <insert_sorted_with_merge_freeList+0x655>
  8034bb:	83 ec 04             	sub    $0x4,%esp
  8034be:	68 74 40 80 00       	push   $0x804074
  8034c3:	68 6e 01 00 00       	push   $0x16e
  8034c8:	68 97 40 80 00       	push   $0x804097
  8034cd:	e8 dc ce ff ff       	call   8003ae <_panic>
  8034d2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034db:	89 10                	mov    %edx,(%eax)
  8034dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e0:	8b 00                	mov    (%eax),%eax
  8034e2:	85 c0                	test   %eax,%eax
  8034e4:	74 0d                	je     8034f3 <insert_sorted_with_merge_freeList+0x676>
  8034e6:	a1 48 51 80 00       	mov    0x805148,%eax
  8034eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034ee:	89 50 04             	mov    %edx,0x4(%eax)
  8034f1:	eb 08                	jmp    8034fb <insert_sorted_with_merge_freeList+0x67e>
  8034f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fe:	a3 48 51 80 00       	mov    %eax,0x805148
  803503:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803506:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80350d:	a1 54 51 80 00       	mov    0x805154,%eax
  803512:	40                   	inc    %eax
  803513:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803518:	e9 a9 00 00 00       	jmp    8035c6 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80351d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803521:	74 06                	je     803529 <insert_sorted_with_merge_freeList+0x6ac>
  803523:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803527:	75 17                	jne    803540 <insert_sorted_with_merge_freeList+0x6c3>
  803529:	83 ec 04             	sub    $0x4,%esp
  80352c:	68 0c 41 80 00       	push   $0x80410c
  803531:	68 73 01 00 00       	push   $0x173
  803536:	68 97 40 80 00       	push   $0x804097
  80353b:	e8 6e ce ff ff       	call   8003ae <_panic>
  803540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803543:	8b 10                	mov    (%eax),%edx
  803545:	8b 45 08             	mov    0x8(%ebp),%eax
  803548:	89 10                	mov    %edx,(%eax)
  80354a:	8b 45 08             	mov    0x8(%ebp),%eax
  80354d:	8b 00                	mov    (%eax),%eax
  80354f:	85 c0                	test   %eax,%eax
  803551:	74 0b                	je     80355e <insert_sorted_with_merge_freeList+0x6e1>
  803553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803556:	8b 00                	mov    (%eax),%eax
  803558:	8b 55 08             	mov    0x8(%ebp),%edx
  80355b:	89 50 04             	mov    %edx,0x4(%eax)
  80355e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803561:	8b 55 08             	mov    0x8(%ebp),%edx
  803564:	89 10                	mov    %edx,(%eax)
  803566:	8b 45 08             	mov    0x8(%ebp),%eax
  803569:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80356c:	89 50 04             	mov    %edx,0x4(%eax)
  80356f:	8b 45 08             	mov    0x8(%ebp),%eax
  803572:	8b 00                	mov    (%eax),%eax
  803574:	85 c0                	test   %eax,%eax
  803576:	75 08                	jne    803580 <insert_sorted_with_merge_freeList+0x703>
  803578:	8b 45 08             	mov    0x8(%ebp),%eax
  80357b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803580:	a1 44 51 80 00       	mov    0x805144,%eax
  803585:	40                   	inc    %eax
  803586:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80358b:	eb 39                	jmp    8035c6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80358d:	a1 40 51 80 00       	mov    0x805140,%eax
  803592:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803595:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803599:	74 07                	je     8035a2 <insert_sorted_with_merge_freeList+0x725>
  80359b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359e:	8b 00                	mov    (%eax),%eax
  8035a0:	eb 05                	jmp    8035a7 <insert_sorted_with_merge_freeList+0x72a>
  8035a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a7:	a3 40 51 80 00       	mov    %eax,0x805140
  8035ac:	a1 40 51 80 00       	mov    0x805140,%eax
  8035b1:	85 c0                	test   %eax,%eax
  8035b3:	0f 85 c7 fb ff ff    	jne    803180 <insert_sorted_with_merge_freeList+0x303>
  8035b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035bd:	0f 85 bd fb ff ff    	jne    803180 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035c3:	eb 01                	jmp    8035c6 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035c5:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035c6:	90                   	nop
  8035c7:	c9                   	leave  
  8035c8:	c3                   	ret    
  8035c9:	66 90                	xchg   %ax,%ax
  8035cb:	90                   	nop

008035cc <__udivdi3>:
  8035cc:	55                   	push   %ebp
  8035cd:	57                   	push   %edi
  8035ce:	56                   	push   %esi
  8035cf:	53                   	push   %ebx
  8035d0:	83 ec 1c             	sub    $0x1c,%esp
  8035d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035e3:	89 ca                	mov    %ecx,%edx
  8035e5:	89 f8                	mov    %edi,%eax
  8035e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035eb:	85 f6                	test   %esi,%esi
  8035ed:	75 2d                	jne    80361c <__udivdi3+0x50>
  8035ef:	39 cf                	cmp    %ecx,%edi
  8035f1:	77 65                	ja     803658 <__udivdi3+0x8c>
  8035f3:	89 fd                	mov    %edi,%ebp
  8035f5:	85 ff                	test   %edi,%edi
  8035f7:	75 0b                	jne    803604 <__udivdi3+0x38>
  8035f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8035fe:	31 d2                	xor    %edx,%edx
  803600:	f7 f7                	div    %edi
  803602:	89 c5                	mov    %eax,%ebp
  803604:	31 d2                	xor    %edx,%edx
  803606:	89 c8                	mov    %ecx,%eax
  803608:	f7 f5                	div    %ebp
  80360a:	89 c1                	mov    %eax,%ecx
  80360c:	89 d8                	mov    %ebx,%eax
  80360e:	f7 f5                	div    %ebp
  803610:	89 cf                	mov    %ecx,%edi
  803612:	89 fa                	mov    %edi,%edx
  803614:	83 c4 1c             	add    $0x1c,%esp
  803617:	5b                   	pop    %ebx
  803618:	5e                   	pop    %esi
  803619:	5f                   	pop    %edi
  80361a:	5d                   	pop    %ebp
  80361b:	c3                   	ret    
  80361c:	39 ce                	cmp    %ecx,%esi
  80361e:	77 28                	ja     803648 <__udivdi3+0x7c>
  803620:	0f bd fe             	bsr    %esi,%edi
  803623:	83 f7 1f             	xor    $0x1f,%edi
  803626:	75 40                	jne    803668 <__udivdi3+0x9c>
  803628:	39 ce                	cmp    %ecx,%esi
  80362a:	72 0a                	jb     803636 <__udivdi3+0x6a>
  80362c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803630:	0f 87 9e 00 00 00    	ja     8036d4 <__udivdi3+0x108>
  803636:	b8 01 00 00 00       	mov    $0x1,%eax
  80363b:	89 fa                	mov    %edi,%edx
  80363d:	83 c4 1c             	add    $0x1c,%esp
  803640:	5b                   	pop    %ebx
  803641:	5e                   	pop    %esi
  803642:	5f                   	pop    %edi
  803643:	5d                   	pop    %ebp
  803644:	c3                   	ret    
  803645:	8d 76 00             	lea    0x0(%esi),%esi
  803648:	31 ff                	xor    %edi,%edi
  80364a:	31 c0                	xor    %eax,%eax
  80364c:	89 fa                	mov    %edi,%edx
  80364e:	83 c4 1c             	add    $0x1c,%esp
  803651:	5b                   	pop    %ebx
  803652:	5e                   	pop    %esi
  803653:	5f                   	pop    %edi
  803654:	5d                   	pop    %ebp
  803655:	c3                   	ret    
  803656:	66 90                	xchg   %ax,%ax
  803658:	89 d8                	mov    %ebx,%eax
  80365a:	f7 f7                	div    %edi
  80365c:	31 ff                	xor    %edi,%edi
  80365e:	89 fa                	mov    %edi,%edx
  803660:	83 c4 1c             	add    $0x1c,%esp
  803663:	5b                   	pop    %ebx
  803664:	5e                   	pop    %esi
  803665:	5f                   	pop    %edi
  803666:	5d                   	pop    %ebp
  803667:	c3                   	ret    
  803668:	bd 20 00 00 00       	mov    $0x20,%ebp
  80366d:	89 eb                	mov    %ebp,%ebx
  80366f:	29 fb                	sub    %edi,%ebx
  803671:	89 f9                	mov    %edi,%ecx
  803673:	d3 e6                	shl    %cl,%esi
  803675:	89 c5                	mov    %eax,%ebp
  803677:	88 d9                	mov    %bl,%cl
  803679:	d3 ed                	shr    %cl,%ebp
  80367b:	89 e9                	mov    %ebp,%ecx
  80367d:	09 f1                	or     %esi,%ecx
  80367f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803683:	89 f9                	mov    %edi,%ecx
  803685:	d3 e0                	shl    %cl,%eax
  803687:	89 c5                	mov    %eax,%ebp
  803689:	89 d6                	mov    %edx,%esi
  80368b:	88 d9                	mov    %bl,%cl
  80368d:	d3 ee                	shr    %cl,%esi
  80368f:	89 f9                	mov    %edi,%ecx
  803691:	d3 e2                	shl    %cl,%edx
  803693:	8b 44 24 08          	mov    0x8(%esp),%eax
  803697:	88 d9                	mov    %bl,%cl
  803699:	d3 e8                	shr    %cl,%eax
  80369b:	09 c2                	or     %eax,%edx
  80369d:	89 d0                	mov    %edx,%eax
  80369f:	89 f2                	mov    %esi,%edx
  8036a1:	f7 74 24 0c          	divl   0xc(%esp)
  8036a5:	89 d6                	mov    %edx,%esi
  8036a7:	89 c3                	mov    %eax,%ebx
  8036a9:	f7 e5                	mul    %ebp
  8036ab:	39 d6                	cmp    %edx,%esi
  8036ad:	72 19                	jb     8036c8 <__udivdi3+0xfc>
  8036af:	74 0b                	je     8036bc <__udivdi3+0xf0>
  8036b1:	89 d8                	mov    %ebx,%eax
  8036b3:	31 ff                	xor    %edi,%edi
  8036b5:	e9 58 ff ff ff       	jmp    803612 <__udivdi3+0x46>
  8036ba:	66 90                	xchg   %ax,%ax
  8036bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036c0:	89 f9                	mov    %edi,%ecx
  8036c2:	d3 e2                	shl    %cl,%edx
  8036c4:	39 c2                	cmp    %eax,%edx
  8036c6:	73 e9                	jae    8036b1 <__udivdi3+0xe5>
  8036c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036cb:	31 ff                	xor    %edi,%edi
  8036cd:	e9 40 ff ff ff       	jmp    803612 <__udivdi3+0x46>
  8036d2:	66 90                	xchg   %ax,%ax
  8036d4:	31 c0                	xor    %eax,%eax
  8036d6:	e9 37 ff ff ff       	jmp    803612 <__udivdi3+0x46>
  8036db:	90                   	nop

008036dc <__umoddi3>:
  8036dc:	55                   	push   %ebp
  8036dd:	57                   	push   %edi
  8036de:	56                   	push   %esi
  8036df:	53                   	push   %ebx
  8036e0:	83 ec 1c             	sub    $0x1c,%esp
  8036e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036fb:	89 f3                	mov    %esi,%ebx
  8036fd:	89 fa                	mov    %edi,%edx
  8036ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803703:	89 34 24             	mov    %esi,(%esp)
  803706:	85 c0                	test   %eax,%eax
  803708:	75 1a                	jne    803724 <__umoddi3+0x48>
  80370a:	39 f7                	cmp    %esi,%edi
  80370c:	0f 86 a2 00 00 00    	jbe    8037b4 <__umoddi3+0xd8>
  803712:	89 c8                	mov    %ecx,%eax
  803714:	89 f2                	mov    %esi,%edx
  803716:	f7 f7                	div    %edi
  803718:	89 d0                	mov    %edx,%eax
  80371a:	31 d2                	xor    %edx,%edx
  80371c:	83 c4 1c             	add    $0x1c,%esp
  80371f:	5b                   	pop    %ebx
  803720:	5e                   	pop    %esi
  803721:	5f                   	pop    %edi
  803722:	5d                   	pop    %ebp
  803723:	c3                   	ret    
  803724:	39 f0                	cmp    %esi,%eax
  803726:	0f 87 ac 00 00 00    	ja     8037d8 <__umoddi3+0xfc>
  80372c:	0f bd e8             	bsr    %eax,%ebp
  80372f:	83 f5 1f             	xor    $0x1f,%ebp
  803732:	0f 84 ac 00 00 00    	je     8037e4 <__umoddi3+0x108>
  803738:	bf 20 00 00 00       	mov    $0x20,%edi
  80373d:	29 ef                	sub    %ebp,%edi
  80373f:	89 fe                	mov    %edi,%esi
  803741:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803745:	89 e9                	mov    %ebp,%ecx
  803747:	d3 e0                	shl    %cl,%eax
  803749:	89 d7                	mov    %edx,%edi
  80374b:	89 f1                	mov    %esi,%ecx
  80374d:	d3 ef                	shr    %cl,%edi
  80374f:	09 c7                	or     %eax,%edi
  803751:	89 e9                	mov    %ebp,%ecx
  803753:	d3 e2                	shl    %cl,%edx
  803755:	89 14 24             	mov    %edx,(%esp)
  803758:	89 d8                	mov    %ebx,%eax
  80375a:	d3 e0                	shl    %cl,%eax
  80375c:	89 c2                	mov    %eax,%edx
  80375e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803762:	d3 e0                	shl    %cl,%eax
  803764:	89 44 24 04          	mov    %eax,0x4(%esp)
  803768:	8b 44 24 08          	mov    0x8(%esp),%eax
  80376c:	89 f1                	mov    %esi,%ecx
  80376e:	d3 e8                	shr    %cl,%eax
  803770:	09 d0                	or     %edx,%eax
  803772:	d3 eb                	shr    %cl,%ebx
  803774:	89 da                	mov    %ebx,%edx
  803776:	f7 f7                	div    %edi
  803778:	89 d3                	mov    %edx,%ebx
  80377a:	f7 24 24             	mull   (%esp)
  80377d:	89 c6                	mov    %eax,%esi
  80377f:	89 d1                	mov    %edx,%ecx
  803781:	39 d3                	cmp    %edx,%ebx
  803783:	0f 82 87 00 00 00    	jb     803810 <__umoddi3+0x134>
  803789:	0f 84 91 00 00 00    	je     803820 <__umoddi3+0x144>
  80378f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803793:	29 f2                	sub    %esi,%edx
  803795:	19 cb                	sbb    %ecx,%ebx
  803797:	89 d8                	mov    %ebx,%eax
  803799:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80379d:	d3 e0                	shl    %cl,%eax
  80379f:	89 e9                	mov    %ebp,%ecx
  8037a1:	d3 ea                	shr    %cl,%edx
  8037a3:	09 d0                	or     %edx,%eax
  8037a5:	89 e9                	mov    %ebp,%ecx
  8037a7:	d3 eb                	shr    %cl,%ebx
  8037a9:	89 da                	mov    %ebx,%edx
  8037ab:	83 c4 1c             	add    $0x1c,%esp
  8037ae:	5b                   	pop    %ebx
  8037af:	5e                   	pop    %esi
  8037b0:	5f                   	pop    %edi
  8037b1:	5d                   	pop    %ebp
  8037b2:	c3                   	ret    
  8037b3:	90                   	nop
  8037b4:	89 fd                	mov    %edi,%ebp
  8037b6:	85 ff                	test   %edi,%edi
  8037b8:	75 0b                	jne    8037c5 <__umoddi3+0xe9>
  8037ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8037bf:	31 d2                	xor    %edx,%edx
  8037c1:	f7 f7                	div    %edi
  8037c3:	89 c5                	mov    %eax,%ebp
  8037c5:	89 f0                	mov    %esi,%eax
  8037c7:	31 d2                	xor    %edx,%edx
  8037c9:	f7 f5                	div    %ebp
  8037cb:	89 c8                	mov    %ecx,%eax
  8037cd:	f7 f5                	div    %ebp
  8037cf:	89 d0                	mov    %edx,%eax
  8037d1:	e9 44 ff ff ff       	jmp    80371a <__umoddi3+0x3e>
  8037d6:	66 90                	xchg   %ax,%ax
  8037d8:	89 c8                	mov    %ecx,%eax
  8037da:	89 f2                	mov    %esi,%edx
  8037dc:	83 c4 1c             	add    $0x1c,%esp
  8037df:	5b                   	pop    %ebx
  8037e0:	5e                   	pop    %esi
  8037e1:	5f                   	pop    %edi
  8037e2:	5d                   	pop    %ebp
  8037e3:	c3                   	ret    
  8037e4:	3b 04 24             	cmp    (%esp),%eax
  8037e7:	72 06                	jb     8037ef <__umoddi3+0x113>
  8037e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037ed:	77 0f                	ja     8037fe <__umoddi3+0x122>
  8037ef:	89 f2                	mov    %esi,%edx
  8037f1:	29 f9                	sub    %edi,%ecx
  8037f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037f7:	89 14 24             	mov    %edx,(%esp)
  8037fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803802:	8b 14 24             	mov    (%esp),%edx
  803805:	83 c4 1c             	add    $0x1c,%esp
  803808:	5b                   	pop    %ebx
  803809:	5e                   	pop    %esi
  80380a:	5f                   	pop    %edi
  80380b:	5d                   	pop    %ebp
  80380c:	c3                   	ret    
  80380d:	8d 76 00             	lea    0x0(%esi),%esi
  803810:	2b 04 24             	sub    (%esp),%eax
  803813:	19 fa                	sbb    %edi,%edx
  803815:	89 d1                	mov    %edx,%ecx
  803817:	89 c6                	mov    %eax,%esi
  803819:	e9 71 ff ff ff       	jmp    80378f <__umoddi3+0xb3>
  80381e:	66 90                	xchg   %ax,%ax
  803820:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803824:	72 ea                	jb     803810 <__umoddi3+0x134>
  803826:	89 d9                	mov    %ebx,%ecx
  803828:	e9 62 ff ff ff       	jmp    80378f <__umoddi3+0xb3>
