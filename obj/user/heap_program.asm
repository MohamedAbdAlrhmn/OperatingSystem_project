
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
  800031:	e8 19 02 00 00       	call   80024f <libmain>
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
  800066:	e8 5c 15 00 00       	call   8015c7 <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 c8             	mov    %eax,-0x38(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 cc             	pushl  -0x34(%ebp)
  800077:	e8 4b 15 00 00       	call   8015c7 <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c4             	mov    %eax,-0x3c(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 fd 19 00 00       	call   801a84 <sys_pf_calculate_allocated_pages>
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
  8000ec:	e8 51 15 00 00       	call   801642 <free>
  8000f1:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	ff 75 c4             	pushl  -0x3c(%ebp)
  8000fa:	e8 43 15 00 00       	call   801642 <free>
  8000ff:	83 c4 10             	add    $0x10,%esp
		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800102:	e8 dd 18 00 00       	call   8019e4 <sys_calculate_free_frames>
  800107:	89 45 b8             	mov    %eax,-0x48(%ebp)
		x = malloc(sizeof(char)*size) ;
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	ff 75 cc             	pushl  -0x34(%ebp)
  800110:	e8 b2 14 00 00       	call   8015c7 <malloc>
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
  800152:	bb 1c 39 80 00       	mov    $0x80391c,%ebx
  800157:	ba 07 00 00 00       	mov    $0x7,%edx
  80015c:	89 c7                	mov    %eax,%edi
  80015e:	89 de                	mov    %ebx,%esi
  800160:	89 d1                	mov    %edx,%ecx
  800162:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		;
		int i = 0, j ;
  800164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

		int count = 1;
  80016b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		for (; i < 7; i++)
  800172:	e9 81 00 00 00       	jmp    8001f8 <_main+0x1c0>
		{
			int found = 0 ;
  800177:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
			count++;
  80017e:	ff 45 dc             	incl   -0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800181:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800188:	eb 3d                	jmp    8001c7 <_main+0x18f>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  80018a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80018d:	8b 4c 85 98          	mov    -0x68(%ebp,%eax,4),%ecx
  800191:	a1 20 50 80 00       	mov    0x805020,%eax
  800196:	8b 98 9c 05 00 00    	mov    0x59c(%eax),%ebx
  80019c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80019f:	89 d0                	mov    %edx,%eax
  8001a1:	01 c0                	add    %eax,%eax
  8001a3:	01 d0                	add    %edx,%eax
  8001a5:	c1 e0 03             	shl    $0x3,%eax
  8001a8:	01 d8                	add    %ebx,%eax
  8001aa:	8b 00                	mov    (%eax),%eax
  8001ac:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001af:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b7:	39 c1                	cmp    %eax,%ecx
  8001b9:	75 09                	jne    8001c4 <_main+0x18c>
				{
					found = 1 ;
  8001bb:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
					break;
  8001c2:	eb 12                	jmp    8001d6 <_main+0x19e>
		int count = 1;
		for (; i < 7; i++)
		{
			int found = 0 ;
			count++;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001c4:	ff 45 e0             	incl   -0x20(%ebp)
  8001c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8001cc:	8b 50 74             	mov    0x74(%eax),%edx
  8001cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d2:	39 c2                	cmp    %eax,%edx
  8001d4:	77 b4                	ja     80018a <_main+0x152>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001d6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8001da:	75 19                	jne    8001f5 <_main+0x1bd>
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
  8001dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001df:	8b 44 85 98          	mov    -0x68(%ebp,%eax,4),%eax
  8001e3:	50                   	push   %eax
  8001e4:	68 20 38 80 00       	push   $0x803820
  8001e9:	6a 45                	push   $0x45
  8001eb:	68 81 38 80 00       	push   $0x803881
  8001f0:	e8 96 01 00 00       	call   80038b <_panic>
		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};
		;
		int i = 0, j ;

		int count = 1;
		for (; i < 7; i++)
  8001f5:	ff 45 e4             	incl   -0x1c(%ebp)
  8001f8:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8001fc:	0f 8e 75 ff ff ff    	jle    800177 <_main+0x13f>
			}
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
		}

		if( (freePages - sys_calculate_free_frames() ) != 6 ) panic("Extra/Less memory are wrongly allocated. diff = %d, expected = %d", freePages - sys_calculate_free_frames(), 8);
  800202:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800205:	e8 da 17 00 00       	call   8019e4 <sys_calculate_free_frames>
  80020a:	29 c3                	sub    %eax,%ebx
  80020c:	89 d8                	mov    %ebx,%eax
  80020e:	83 f8 06             	cmp    $0x6,%eax
  800211:	74 23                	je     800236 <_main+0x1fe>
  800213:	8b 5d b8             	mov    -0x48(%ebp),%ebx
  800216:	e8 c9 17 00 00       	call   8019e4 <sys_calculate_free_frames>
  80021b:	29 c3                	sub    %eax,%ebx
  80021d:	89 d8                	mov    %ebx,%eax
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	6a 08                	push   $0x8
  800224:	50                   	push   %eax
  800225:	68 98 38 80 00       	push   $0x803898
  80022a:	6a 48                	push   $0x48
  80022c:	68 81 38 80 00       	push   $0x803881
  800231:	e8 55 01 00 00       	call   80038b <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 dc 38 80 00       	push   $0x8038dc
  80023e:	e8 fc 03 00 00       	call   80063f <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp


	return;
  800246:	90                   	nop
}
  800247:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024a:	5b                   	pop    %ebx
  80024b:	5e                   	pop    %esi
  80024c:	5f                   	pop    %edi
  80024d:	5d                   	pop    %ebp
  80024e:	c3                   	ret    

0080024f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800255:	e8 6a 1a 00 00       	call   801cc4 <sys_getenvindex>
  80025a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80025d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800260:	89 d0                	mov    %edx,%eax
  800262:	c1 e0 03             	shl    $0x3,%eax
  800265:	01 d0                	add    %edx,%eax
  800267:	01 c0                	add    %eax,%eax
  800269:	01 d0                	add    %edx,%eax
  80026b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800272:	01 d0                	add    %edx,%eax
  800274:	c1 e0 04             	shl    $0x4,%eax
  800277:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80027c:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800281:	a1 20 50 80 00       	mov    0x805020,%eax
  800286:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80028c:	84 c0                	test   %al,%al
  80028e:	74 0f                	je     80029f <libmain+0x50>
		binaryname = myEnv->prog_name;
  800290:	a1 20 50 80 00       	mov    0x805020,%eax
  800295:	05 5c 05 00 00       	add    $0x55c,%eax
  80029a:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80029f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a3:	7e 0a                	jle    8002af <libmain+0x60>
		binaryname = argv[0];
  8002a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a8:	8b 00                	mov    (%eax),%eax
  8002aa:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8002af:	83 ec 08             	sub    $0x8,%esp
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	e8 7b fd ff ff       	call   800038 <_main>
  8002bd:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002c0:	e8 0c 18 00 00       	call   801ad1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002c5:	83 ec 0c             	sub    $0xc,%esp
  8002c8:	68 50 39 80 00       	push   $0x803950
  8002cd:	e8 6d 03 00 00       	call   80063f <cprintf>
  8002d2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8002da:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	52                   	push   %edx
  8002ef:	50                   	push   %eax
  8002f0:	68 78 39 80 00       	push   $0x803978
  8002f5:	e8 45 03 00 00       	call   80063f <cprintf>
  8002fa:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002fd:	a1 20 50 80 00       	mov    0x805020,%eax
  800302:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800308:	a1 20 50 80 00       	mov    0x805020,%eax
  80030d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800313:	a1 20 50 80 00       	mov    0x805020,%eax
  800318:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80031e:	51                   	push   %ecx
  80031f:	52                   	push   %edx
  800320:	50                   	push   %eax
  800321:	68 a0 39 80 00       	push   $0x8039a0
  800326:	e8 14 03 00 00       	call   80063f <cprintf>
  80032b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80032e:	a1 20 50 80 00       	mov    0x805020,%eax
  800333:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800339:	83 ec 08             	sub    $0x8,%esp
  80033c:	50                   	push   %eax
  80033d:	68 f8 39 80 00       	push   $0x8039f8
  800342:	e8 f8 02 00 00       	call   80063f <cprintf>
  800347:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	68 50 39 80 00       	push   $0x803950
  800352:	e8 e8 02 00 00       	call   80063f <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035a:	e8 8c 17 00 00       	call   801aeb <sys_enable_interrupt>

	// exit gracefully
	exit();
  80035f:	e8 19 00 00 00       	call   80037d <exit>
}
  800364:	90                   	nop
  800365:	c9                   	leave  
  800366:	c3                   	ret    

00800367 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	6a 00                	push   $0x0
  800372:	e8 19 19 00 00       	call   801c90 <sys_destroy_env>
  800377:	83 c4 10             	add    $0x10,%esp
}
  80037a:	90                   	nop
  80037b:	c9                   	leave  
  80037c:	c3                   	ret    

0080037d <exit>:

void
exit(void)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800383:	e8 6e 19 00 00       	call   801cf6 <sys_exit_env>
}
  800388:	90                   	nop
  800389:	c9                   	leave  
  80038a:	c3                   	ret    

0080038b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
  80038e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800391:	8d 45 10             	lea    0x10(%ebp),%eax
  800394:	83 c0 04             	add    $0x4,%eax
  800397:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80039a:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80039f:	85 c0                	test   %eax,%eax
  8003a1:	74 16                	je     8003b9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003a3:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8003a8:	83 ec 08             	sub    $0x8,%esp
  8003ab:	50                   	push   %eax
  8003ac:	68 0c 3a 80 00       	push   $0x803a0c
  8003b1:	e8 89 02 00 00       	call   80063f <cprintf>
  8003b6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003b9:	a1 00 50 80 00       	mov    0x805000,%eax
  8003be:	ff 75 0c             	pushl  0xc(%ebp)
  8003c1:	ff 75 08             	pushl  0x8(%ebp)
  8003c4:	50                   	push   %eax
  8003c5:	68 11 3a 80 00       	push   $0x803a11
  8003ca:	e8 70 02 00 00       	call   80063f <cprintf>
  8003cf:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d5:	83 ec 08             	sub    $0x8,%esp
  8003d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8003db:	50                   	push   %eax
  8003dc:	e8 f3 01 00 00       	call   8005d4 <vcprintf>
  8003e1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e4:	83 ec 08             	sub    $0x8,%esp
  8003e7:	6a 00                	push   $0x0
  8003e9:	68 2d 3a 80 00       	push   $0x803a2d
  8003ee:	e8 e1 01 00 00       	call   8005d4 <vcprintf>
  8003f3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003f6:	e8 82 ff ff ff       	call   80037d <exit>

	// should not return here
	while (1) ;
  8003fb:	eb fe                	jmp    8003fb <_panic+0x70>

008003fd <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003fd:	55                   	push   %ebp
  8003fe:	89 e5                	mov    %esp,%ebp
  800400:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800403:	a1 20 50 80 00       	mov    0x805020,%eax
  800408:	8b 50 74             	mov    0x74(%eax),%edx
  80040b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040e:	39 c2                	cmp    %eax,%edx
  800410:	74 14                	je     800426 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800412:	83 ec 04             	sub    $0x4,%esp
  800415:	68 30 3a 80 00       	push   $0x803a30
  80041a:	6a 26                	push   $0x26
  80041c:	68 7c 3a 80 00       	push   $0x803a7c
  800421:	e8 65 ff ff ff       	call   80038b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800426:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80042d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800434:	e9 c2 00 00 00       	jmp    8004fb <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	01 d0                	add    %edx,%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	85 c0                	test   %eax,%eax
  80044c:	75 08                	jne    800456 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80044e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800451:	e9 a2 00 00 00       	jmp    8004f8 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800456:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80045d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800464:	eb 69                	jmp    8004cf <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800466:	a1 20 50 80 00       	mov    0x805020,%eax
  80046b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800471:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800474:	89 d0                	mov    %edx,%eax
  800476:	01 c0                	add    %eax,%eax
  800478:	01 d0                	add    %edx,%eax
  80047a:	c1 e0 03             	shl    $0x3,%eax
  80047d:	01 c8                	add    %ecx,%eax
  80047f:	8a 40 04             	mov    0x4(%eax),%al
  800482:	84 c0                	test   %al,%al
  800484:	75 46                	jne    8004cc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800486:	a1 20 50 80 00       	mov    0x805020,%eax
  80048b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800491:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800494:	89 d0                	mov    %edx,%eax
  800496:	01 c0                	add    %eax,%eax
  800498:	01 d0                	add    %edx,%eax
  80049a:	c1 e0 03             	shl    $0x3,%eax
  80049d:	01 c8                	add    %ecx,%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004ac:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bb:	01 c8                	add    %ecx,%eax
  8004bd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004bf:	39 c2                	cmp    %eax,%edx
  8004c1:	75 09                	jne    8004cc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004c3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004ca:	eb 12                	jmp    8004de <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004cc:	ff 45 e8             	incl   -0x18(%ebp)
  8004cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d4:	8b 50 74             	mov    0x74(%eax),%edx
  8004d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004da:	39 c2                	cmp    %eax,%edx
  8004dc:	77 88                	ja     800466 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004e2:	75 14                	jne    8004f8 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004e4:	83 ec 04             	sub    $0x4,%esp
  8004e7:	68 88 3a 80 00       	push   $0x803a88
  8004ec:	6a 3a                	push   $0x3a
  8004ee:	68 7c 3a 80 00       	push   $0x803a7c
  8004f3:	e8 93 fe ff ff       	call   80038b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004f8:	ff 45 f0             	incl   -0x10(%ebp)
  8004fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004fe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800501:	0f 8c 32 ff ff ff    	jl     800439 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800507:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80050e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800515:	eb 26                	jmp    80053d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800517:	a1 20 50 80 00       	mov    0x805020,%eax
  80051c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800522:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800525:	89 d0                	mov    %edx,%eax
  800527:	01 c0                	add    %eax,%eax
  800529:	01 d0                	add    %edx,%eax
  80052b:	c1 e0 03             	shl    $0x3,%eax
  80052e:	01 c8                	add    %ecx,%eax
  800530:	8a 40 04             	mov    0x4(%eax),%al
  800533:	3c 01                	cmp    $0x1,%al
  800535:	75 03                	jne    80053a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800537:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053a:	ff 45 e0             	incl   -0x20(%ebp)
  80053d:	a1 20 50 80 00       	mov    0x805020,%eax
  800542:	8b 50 74             	mov    0x74(%eax),%edx
  800545:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800548:	39 c2                	cmp    %eax,%edx
  80054a:	77 cb                	ja     800517 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80054c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80054f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800552:	74 14                	je     800568 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800554:	83 ec 04             	sub    $0x4,%esp
  800557:	68 dc 3a 80 00       	push   $0x803adc
  80055c:	6a 44                	push   $0x44
  80055e:	68 7c 3a 80 00       	push   $0x803a7c
  800563:	e8 23 fe ff ff       	call   80038b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800568:	90                   	nop
  800569:	c9                   	leave  
  80056a:	c3                   	ret    

0080056b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80056b:	55                   	push   %ebp
  80056c:	89 e5                	mov    %esp,%ebp
  80056e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800571:	8b 45 0c             	mov    0xc(%ebp),%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	8d 48 01             	lea    0x1(%eax),%ecx
  800579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80057c:	89 0a                	mov    %ecx,(%edx)
  80057e:	8b 55 08             	mov    0x8(%ebp),%edx
  800581:	88 d1                	mov    %dl,%cl
  800583:	8b 55 0c             	mov    0xc(%ebp),%edx
  800586:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80058a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800594:	75 2c                	jne    8005c2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800596:	a0 24 50 80 00       	mov    0x805024,%al
  80059b:	0f b6 c0             	movzbl %al,%eax
  80059e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a1:	8b 12                	mov    (%edx),%edx
  8005a3:	89 d1                	mov    %edx,%ecx
  8005a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a8:	83 c2 08             	add    $0x8,%edx
  8005ab:	83 ec 04             	sub    $0x4,%esp
  8005ae:	50                   	push   %eax
  8005af:	51                   	push   %ecx
  8005b0:	52                   	push   %edx
  8005b1:	e8 6d 13 00 00       	call   801923 <sys_cputs>
  8005b6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c5:	8b 40 04             	mov    0x4(%eax),%eax
  8005c8:	8d 50 01             	lea    0x1(%eax),%edx
  8005cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ce:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005e4:	00 00 00 
	b.cnt = 0;
  8005e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005ee:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005f1:	ff 75 0c             	pushl  0xc(%ebp)
  8005f4:	ff 75 08             	pushl  0x8(%ebp)
  8005f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005fd:	50                   	push   %eax
  8005fe:	68 6b 05 80 00       	push   $0x80056b
  800603:	e8 11 02 00 00       	call   800819 <vprintfmt>
  800608:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80060b:	a0 24 50 80 00       	mov    0x805024,%al
  800610:	0f b6 c0             	movzbl %al,%eax
  800613:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800619:	83 ec 04             	sub    $0x4,%esp
  80061c:	50                   	push   %eax
  80061d:	52                   	push   %edx
  80061e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800624:	83 c0 08             	add    $0x8,%eax
  800627:	50                   	push   %eax
  800628:	e8 f6 12 00 00       	call   801923 <sys_cputs>
  80062d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800630:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800637:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80063d:	c9                   	leave  
  80063e:	c3                   	ret    

0080063f <cprintf>:

int cprintf(const char *fmt, ...) {
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
  800642:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800645:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80064c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80064f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800652:	8b 45 08             	mov    0x8(%ebp),%eax
  800655:	83 ec 08             	sub    $0x8,%esp
  800658:	ff 75 f4             	pushl  -0xc(%ebp)
  80065b:	50                   	push   %eax
  80065c:	e8 73 ff ff ff       	call   8005d4 <vcprintf>
  800661:	83 c4 10             	add    $0x10,%esp
  800664:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800667:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80066a:	c9                   	leave  
  80066b:	c3                   	ret    

0080066c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80066c:	55                   	push   %ebp
  80066d:	89 e5                	mov    %esp,%ebp
  80066f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800672:	e8 5a 14 00 00       	call   801ad1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800677:	8d 45 0c             	lea    0xc(%ebp),%eax
  80067a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	ff 75 f4             	pushl  -0xc(%ebp)
  800686:	50                   	push   %eax
  800687:	e8 48 ff ff ff       	call   8005d4 <vcprintf>
  80068c:	83 c4 10             	add    $0x10,%esp
  80068f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800692:	e8 54 14 00 00       	call   801aeb <sys_enable_interrupt>
	return cnt;
  800697:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80069a:	c9                   	leave  
  80069b:	c3                   	ret    

0080069c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80069c:	55                   	push   %ebp
  80069d:	89 e5                	mov    %esp,%ebp
  80069f:	53                   	push   %ebx
  8006a0:	83 ec 14             	sub    $0x14,%esp
  8006a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006af:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ba:	77 55                	ja     800711 <printnum+0x75>
  8006bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006bf:	72 05                	jb     8006c6 <printnum+0x2a>
  8006c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006c4:	77 4b                	ja     800711 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006c6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006c9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006cc:	8b 45 18             	mov    0x18(%ebp),%eax
  8006cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d4:	52                   	push   %edx
  8006d5:	50                   	push   %eax
  8006d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8006dc:	e8 c7 2e 00 00       	call   8035a8 <__udivdi3>
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	83 ec 04             	sub    $0x4,%esp
  8006e7:	ff 75 20             	pushl  0x20(%ebp)
  8006ea:	53                   	push   %ebx
  8006eb:	ff 75 18             	pushl  0x18(%ebp)
  8006ee:	52                   	push   %edx
  8006ef:	50                   	push   %eax
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	ff 75 08             	pushl  0x8(%ebp)
  8006f6:	e8 a1 ff ff ff       	call   80069c <printnum>
  8006fb:	83 c4 20             	add    $0x20,%esp
  8006fe:	eb 1a                	jmp    80071a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	ff 75 0c             	pushl  0xc(%ebp)
  800706:	ff 75 20             	pushl  0x20(%ebp)
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	ff d0                	call   *%eax
  80070e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800711:	ff 4d 1c             	decl   0x1c(%ebp)
  800714:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800718:	7f e6                	jg     800700 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80071a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80071d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800725:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800728:	53                   	push   %ebx
  800729:	51                   	push   %ecx
  80072a:	52                   	push   %edx
  80072b:	50                   	push   %eax
  80072c:	e8 87 2f 00 00       	call   8036b8 <__umoddi3>
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	05 54 3d 80 00       	add    $0x803d54,%eax
  800739:	8a 00                	mov    (%eax),%al
  80073b:	0f be c0             	movsbl %al,%eax
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	ff 75 0c             	pushl  0xc(%ebp)
  800744:	50                   	push   %eax
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	ff d0                	call   *%eax
  80074a:	83 c4 10             	add    $0x10,%esp
}
  80074d:	90                   	nop
  80074e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800751:	c9                   	leave  
  800752:	c3                   	ret    

00800753 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800756:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075a:	7e 1c                	jle    800778 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	8d 50 08             	lea    0x8(%eax),%edx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	89 10                	mov    %edx,(%eax)
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	8b 00                	mov    (%eax),%eax
  80076e:	83 e8 08             	sub    $0x8,%eax
  800771:	8b 50 04             	mov    0x4(%eax),%edx
  800774:	8b 00                	mov    (%eax),%eax
  800776:	eb 40                	jmp    8007b8 <getuint+0x65>
	else if (lflag)
  800778:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80077c:	74 1e                	je     80079c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	8d 50 04             	lea    0x4(%eax),%edx
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	89 10                	mov    %edx,(%eax)
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	8b 00                	mov    (%eax),%eax
  800790:	83 e8 04             	sub    $0x4,%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	ba 00 00 00 00       	mov    $0x0,%edx
  80079a:	eb 1c                	jmp    8007b8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	8d 50 04             	lea    0x4(%eax),%edx
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	89 10                	mov    %edx,(%eax)
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	83 e8 04             	sub    $0x4,%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007b8:	5d                   	pop    %ebp
  8007b9:	c3                   	ret    

008007ba <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c1:	7e 1c                	jle    8007df <getint+0x25>
		return va_arg(*ap, long long);
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	8d 50 08             	lea    0x8(%eax),%edx
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	89 10                	mov    %edx,(%eax)
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	8b 00                	mov    (%eax),%eax
  8007d5:	83 e8 08             	sub    $0x8,%eax
  8007d8:	8b 50 04             	mov    0x4(%eax),%edx
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	eb 38                	jmp    800817 <getint+0x5d>
	else if (lflag)
  8007df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e3:	74 1a                	je     8007ff <getint+0x45>
		return va_arg(*ap, long);
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	8d 50 04             	lea    0x4(%eax),%edx
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	89 10                	mov    %edx,(%eax)
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	83 e8 04             	sub    $0x4,%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	99                   	cltd   
  8007fd:	eb 18                	jmp    800817 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	8d 50 04             	lea    0x4(%eax),%edx
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	89 10                	mov    %edx,(%eax)
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	83 e8 04             	sub    $0x4,%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	99                   	cltd   
}
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    

00800819 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
  80081c:	56                   	push   %esi
  80081d:	53                   	push   %ebx
  80081e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800821:	eb 17                	jmp    80083a <vprintfmt+0x21>
			if (ch == '\0')
  800823:	85 db                	test   %ebx,%ebx
  800825:	0f 84 af 03 00 00    	je     800bda <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	53                   	push   %ebx
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	ff d0                	call   *%eax
  800837:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083a:	8b 45 10             	mov    0x10(%ebp),%eax
  80083d:	8d 50 01             	lea    0x1(%eax),%edx
  800840:	89 55 10             	mov    %edx,0x10(%ebp)
  800843:	8a 00                	mov    (%eax),%al
  800845:	0f b6 d8             	movzbl %al,%ebx
  800848:	83 fb 25             	cmp    $0x25,%ebx
  80084b:	75 d6                	jne    800823 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80084d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800851:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800858:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80085f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800866:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80086d:	8b 45 10             	mov    0x10(%ebp),%eax
  800870:	8d 50 01             	lea    0x1(%eax),%edx
  800873:	89 55 10             	mov    %edx,0x10(%ebp)
  800876:	8a 00                	mov    (%eax),%al
  800878:	0f b6 d8             	movzbl %al,%ebx
  80087b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80087e:	83 f8 55             	cmp    $0x55,%eax
  800881:	0f 87 2b 03 00 00    	ja     800bb2 <vprintfmt+0x399>
  800887:	8b 04 85 78 3d 80 00 	mov    0x803d78(,%eax,4),%eax
  80088e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800890:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800894:	eb d7                	jmp    80086d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800896:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80089a:	eb d1                	jmp    80086d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80089c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a6:	89 d0                	mov    %edx,%eax
  8008a8:	c1 e0 02             	shl    $0x2,%eax
  8008ab:	01 d0                	add    %edx,%eax
  8008ad:	01 c0                	add    %eax,%eax
  8008af:	01 d8                	add    %ebx,%eax
  8008b1:	83 e8 30             	sub    $0x30,%eax
  8008b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ba:	8a 00                	mov    (%eax),%al
  8008bc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008bf:	83 fb 2f             	cmp    $0x2f,%ebx
  8008c2:	7e 3e                	jle    800902 <vprintfmt+0xe9>
  8008c4:	83 fb 39             	cmp    $0x39,%ebx
  8008c7:	7f 39                	jg     800902 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008c9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008cc:	eb d5                	jmp    8008a3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	83 c0 04             	add    $0x4,%eax
  8008d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 e8 04             	sub    $0x4,%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008e2:	eb 1f                	jmp    800903 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e8:	79 83                	jns    80086d <vprintfmt+0x54>
				width = 0;
  8008ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008f1:	e9 77 ff ff ff       	jmp    80086d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008f6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008fd:	e9 6b ff ff ff       	jmp    80086d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800902:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800903:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800907:	0f 89 60 ff ff ff    	jns    80086d <vprintfmt+0x54>
				width = precision, precision = -1;
  80090d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800910:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800913:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80091a:	e9 4e ff ff ff       	jmp    80086d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80091f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800922:	e9 46 ff ff ff       	jmp    80086d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800927:	8b 45 14             	mov    0x14(%ebp),%eax
  80092a:	83 c0 04             	add    $0x4,%eax
  80092d:	89 45 14             	mov    %eax,0x14(%ebp)
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	83 e8 04             	sub    $0x4,%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	ff 75 0c             	pushl  0xc(%ebp)
  80093e:	50                   	push   %eax
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
			break;
  800947:	e9 89 02 00 00       	jmp    800bd5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	83 c0 04             	add    $0x4,%eax
  800952:	89 45 14             	mov    %eax,0x14(%ebp)
  800955:	8b 45 14             	mov    0x14(%ebp),%eax
  800958:	83 e8 04             	sub    $0x4,%eax
  80095b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80095d:	85 db                	test   %ebx,%ebx
  80095f:	79 02                	jns    800963 <vprintfmt+0x14a>
				err = -err;
  800961:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800963:	83 fb 64             	cmp    $0x64,%ebx
  800966:	7f 0b                	jg     800973 <vprintfmt+0x15a>
  800968:	8b 34 9d c0 3b 80 00 	mov    0x803bc0(,%ebx,4),%esi
  80096f:	85 f6                	test   %esi,%esi
  800971:	75 19                	jne    80098c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800973:	53                   	push   %ebx
  800974:	68 65 3d 80 00       	push   $0x803d65
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	ff 75 08             	pushl  0x8(%ebp)
  80097f:	e8 5e 02 00 00       	call   800be2 <printfmt>
  800984:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800987:	e9 49 02 00 00       	jmp    800bd5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80098c:	56                   	push   %esi
  80098d:	68 6e 3d 80 00       	push   $0x803d6e
  800992:	ff 75 0c             	pushl  0xc(%ebp)
  800995:	ff 75 08             	pushl  0x8(%ebp)
  800998:	e8 45 02 00 00       	call   800be2 <printfmt>
  80099d:	83 c4 10             	add    $0x10,%esp
			break;
  8009a0:	e9 30 02 00 00       	jmp    800bd5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a8:	83 c0 04             	add    $0x4,%eax
  8009ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b1:	83 e8 04             	sub    $0x4,%eax
  8009b4:	8b 30                	mov    (%eax),%esi
  8009b6:	85 f6                	test   %esi,%esi
  8009b8:	75 05                	jne    8009bf <vprintfmt+0x1a6>
				p = "(null)";
  8009ba:	be 71 3d 80 00       	mov    $0x803d71,%esi
			if (width > 0 && padc != '-')
  8009bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c3:	7e 6d                	jle    800a32 <vprintfmt+0x219>
  8009c5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009c9:	74 67                	je     800a32 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ce:	83 ec 08             	sub    $0x8,%esp
  8009d1:	50                   	push   %eax
  8009d2:	56                   	push   %esi
  8009d3:	e8 0c 03 00 00       	call   800ce4 <strnlen>
  8009d8:	83 c4 10             	add    $0x10,%esp
  8009db:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009de:	eb 16                	jmp    8009f6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009e0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	50                   	push   %eax
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	ff d0                	call   *%eax
  8009f0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f3:	ff 4d e4             	decl   -0x1c(%ebp)
  8009f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009fa:	7f e4                	jg     8009e0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009fc:	eb 34                	jmp    800a32 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009fe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a02:	74 1c                	je     800a20 <vprintfmt+0x207>
  800a04:	83 fb 1f             	cmp    $0x1f,%ebx
  800a07:	7e 05                	jle    800a0e <vprintfmt+0x1f5>
  800a09:	83 fb 7e             	cmp    $0x7e,%ebx
  800a0c:	7e 12                	jle    800a20 <vprintfmt+0x207>
					putch('?', putdat);
  800a0e:	83 ec 08             	sub    $0x8,%esp
  800a11:	ff 75 0c             	pushl  0xc(%ebp)
  800a14:	6a 3f                	push   $0x3f
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	ff d0                	call   *%eax
  800a1b:	83 c4 10             	add    $0x10,%esp
  800a1e:	eb 0f                	jmp    800a2f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	53                   	push   %ebx
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800a32:	89 f0                	mov    %esi,%eax
  800a34:	8d 70 01             	lea    0x1(%eax),%esi
  800a37:	8a 00                	mov    (%eax),%al
  800a39:	0f be d8             	movsbl %al,%ebx
  800a3c:	85 db                	test   %ebx,%ebx
  800a3e:	74 24                	je     800a64 <vprintfmt+0x24b>
  800a40:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a44:	78 b8                	js     8009fe <vprintfmt+0x1e5>
  800a46:	ff 4d e0             	decl   -0x20(%ebp)
  800a49:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a4d:	79 af                	jns    8009fe <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a4f:	eb 13                	jmp    800a64 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 0c             	pushl  0xc(%ebp)
  800a57:	6a 20                	push   $0x20
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	ff d0                	call   *%eax
  800a5e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a61:	ff 4d e4             	decl   -0x1c(%ebp)
  800a64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a68:	7f e7                	jg     800a51 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a6a:	e9 66 01 00 00       	jmp    800bd5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	ff 75 e8             	pushl  -0x18(%ebp)
  800a75:	8d 45 14             	lea    0x14(%ebp),%eax
  800a78:	50                   	push   %eax
  800a79:	e8 3c fd ff ff       	call   8007ba <getint>
  800a7e:	83 c4 10             	add    $0x10,%esp
  800a81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8d:	85 d2                	test   %edx,%edx
  800a8f:	79 23                	jns    800ab4 <vprintfmt+0x29b>
				putch('-', putdat);
  800a91:	83 ec 08             	sub    $0x8,%esp
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	6a 2d                	push   $0x2d
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	ff d0                	call   *%eax
  800a9e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aa7:	f7 d8                	neg    %eax
  800aa9:	83 d2 00             	adc    $0x0,%edx
  800aac:	f7 da                	neg    %edx
  800aae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ab4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800abb:	e9 bc 00 00 00       	jmp    800b7c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac9:	50                   	push   %eax
  800aca:	e8 84 fc ff ff       	call   800753 <getuint>
  800acf:	83 c4 10             	add    $0x10,%esp
  800ad2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ad8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800adf:	e9 98 00 00 00       	jmp    800b7c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	6a 58                	push   $0x58
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	ff d0                	call   *%eax
  800af1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af4:	83 ec 08             	sub    $0x8,%esp
  800af7:	ff 75 0c             	pushl  0xc(%ebp)
  800afa:	6a 58                	push   $0x58
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	ff d0                	call   *%eax
  800b01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	ff 75 0c             	pushl  0xc(%ebp)
  800b0a:	6a 58                	push   $0x58
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	ff d0                	call   *%eax
  800b11:	83 c4 10             	add    $0x10,%esp
			break;
  800b14:	e9 bc 00 00 00       	jmp    800bd5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	ff 75 0c             	pushl  0xc(%ebp)
  800b1f:	6a 30                	push   $0x30
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	ff d0                	call   *%eax
  800b26:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	6a 78                	push   $0x78
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	ff d0                	call   *%eax
  800b36:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b39:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3c:	83 c0 04             	add    $0x4,%eax
  800b3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b42:	8b 45 14             	mov    0x14(%ebp),%eax
  800b45:	83 e8 04             	sub    $0x4,%eax
  800b48:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b5b:	eb 1f                	jmp    800b7c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 e8             	pushl  -0x18(%ebp)
  800b63:	8d 45 14             	lea    0x14(%ebp),%eax
  800b66:	50                   	push   %eax
  800b67:	e8 e7 fb ff ff       	call   800753 <getuint>
  800b6c:	83 c4 10             	add    $0x10,%esp
  800b6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b72:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b75:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b7c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b83:	83 ec 04             	sub    $0x4,%esp
  800b86:	52                   	push   %edx
  800b87:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b8a:	50                   	push   %eax
  800b8b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b8e:	ff 75 f0             	pushl  -0x10(%ebp)
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	ff 75 08             	pushl  0x8(%ebp)
  800b97:	e8 00 fb ff ff       	call   80069c <printnum>
  800b9c:	83 c4 20             	add    $0x20,%esp
			break;
  800b9f:	eb 34                	jmp    800bd5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 0c             	pushl  0xc(%ebp)
  800ba7:	53                   	push   %ebx
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	ff d0                	call   *%eax
  800bad:	83 c4 10             	add    $0x10,%esp
			break;
  800bb0:	eb 23                	jmp    800bd5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb2:	83 ec 08             	sub    $0x8,%esp
  800bb5:	ff 75 0c             	pushl  0xc(%ebp)
  800bb8:	6a 25                	push   $0x25
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	ff d0                	call   *%eax
  800bbf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc2:	ff 4d 10             	decl   0x10(%ebp)
  800bc5:	eb 03                	jmp    800bca <vprintfmt+0x3b1>
  800bc7:	ff 4d 10             	decl   0x10(%ebp)
  800bca:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcd:	48                   	dec    %eax
  800bce:	8a 00                	mov    (%eax),%al
  800bd0:	3c 25                	cmp    $0x25,%al
  800bd2:	75 f3                	jne    800bc7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bd4:	90                   	nop
		}
	}
  800bd5:	e9 47 fc ff ff       	jmp    800821 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bda:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bdb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bde:	5b                   	pop    %ebx
  800bdf:	5e                   	pop    %esi
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    

00800be2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800be8:	8d 45 10             	lea    0x10(%ebp),%eax
  800beb:	83 c0 04             	add    $0x4,%eax
  800bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf7:	50                   	push   %eax
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	ff 75 08             	pushl  0x8(%ebp)
  800bfe:	e8 16 fc ff ff       	call   800819 <vprintfmt>
  800c03:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c06:	90                   	nop
  800c07:	c9                   	leave  
  800c08:	c3                   	ret    

00800c09 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0f:	8b 40 08             	mov    0x8(%eax),%eax
  800c12:	8d 50 01             	lea    0x1(%eax),%edx
  800c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c18:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1e:	8b 10                	mov    (%eax),%edx
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 40 04             	mov    0x4(%eax),%eax
  800c26:	39 c2                	cmp    %eax,%edx
  800c28:	73 12                	jae    800c3c <sprintputch+0x33>
		*b->buf++ = ch;
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	8b 00                	mov    (%eax),%eax
  800c2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800c32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c35:	89 0a                	mov    %ecx,(%edx)
  800c37:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3a:	88 10                	mov    %dl,(%eax)
}
  800c3c:	90                   	nop
  800c3d:	5d                   	pop    %ebp
  800c3e:	c3                   	ret    

00800c3f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	01 d0                	add    %edx,%eax
  800c56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c64:	74 06                	je     800c6c <vsnprintf+0x2d>
  800c66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6a:	7f 07                	jg     800c73 <vsnprintf+0x34>
		return -E_INVAL;
  800c6c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c71:	eb 20                	jmp    800c93 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c73:	ff 75 14             	pushl  0x14(%ebp)
  800c76:	ff 75 10             	pushl  0x10(%ebp)
  800c79:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c7c:	50                   	push   %eax
  800c7d:	68 09 0c 80 00       	push   $0x800c09
  800c82:	e8 92 fb ff ff       	call   800819 <vprintfmt>
  800c87:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c8d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c9b:	8d 45 10             	lea    0x10(%ebp),%eax
  800c9e:	83 c0 04             	add    $0x4,%eax
  800ca1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ca4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca7:	ff 75 f4             	pushl  -0xc(%ebp)
  800caa:	50                   	push   %eax
  800cab:	ff 75 0c             	pushl  0xc(%ebp)
  800cae:	ff 75 08             	pushl  0x8(%ebp)
  800cb1:	e8 89 ff ff ff       	call   800c3f <vsnprintf>
  800cb6:	83 c4 10             	add    $0x10,%esp
  800cb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cce:	eb 06                	jmp    800cd6 <strlen+0x15>
		n++;
  800cd0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd3:	ff 45 08             	incl   0x8(%ebp)
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	84 c0                	test   %al,%al
  800cdd:	75 f1                	jne    800cd0 <strlen+0xf>
		n++;
	return n;
  800cdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce2:	c9                   	leave  
  800ce3:	c3                   	ret    

00800ce4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf1:	eb 09                	jmp    800cfc <strnlen+0x18>
		n++;
  800cf3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cf6:	ff 45 08             	incl   0x8(%ebp)
  800cf9:	ff 4d 0c             	decl   0xc(%ebp)
  800cfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d00:	74 09                	je     800d0b <strnlen+0x27>
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	8a 00                	mov    (%eax),%al
  800d07:	84 c0                	test   %al,%al
  800d09:	75 e8                	jne    800cf3 <strnlen+0xf>
		n++;
	return n;
  800d0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d1c:	90                   	nop
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8d 50 01             	lea    0x1(%eax),%edx
  800d23:	89 55 08             	mov    %edx,0x8(%ebp)
  800d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d2f:	8a 12                	mov    (%edx),%dl
  800d31:	88 10                	mov    %dl,(%eax)
  800d33:	8a 00                	mov    (%eax),%al
  800d35:	84 c0                	test   %al,%al
  800d37:	75 e4                	jne    800d1d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d39:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d3c:	c9                   	leave  
  800d3d:	c3                   	ret    

00800d3e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d51:	eb 1f                	jmp    800d72 <strncpy+0x34>
		*dst++ = *src;
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	8d 50 01             	lea    0x1(%eax),%edx
  800d59:	89 55 08             	mov    %edx,0x8(%ebp)
  800d5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5f:	8a 12                	mov    (%edx),%dl
  800d61:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	84 c0                	test   %al,%al
  800d6a:	74 03                	je     800d6f <strncpy+0x31>
			src++;
  800d6c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d6f:	ff 45 fc             	incl   -0x4(%ebp)
  800d72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d75:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d78:	72 d9                	jb     800d53 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d7d:	c9                   	leave  
  800d7e:	c3                   	ret    

00800d7f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8f:	74 30                	je     800dc1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d91:	eb 16                	jmp    800da9 <strlcpy+0x2a>
			*dst++ = *src++;
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8d 50 01             	lea    0x1(%eax),%edx
  800d99:	89 55 08             	mov    %edx,0x8(%ebp)
  800d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da5:	8a 12                	mov    (%edx),%dl
  800da7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800da9:	ff 4d 10             	decl   0x10(%ebp)
  800dac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db0:	74 09                	je     800dbb <strlcpy+0x3c>
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	8a 00                	mov    (%eax),%al
  800db7:	84 c0                	test   %al,%al
  800db9:	75 d8                	jne    800d93 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc7:	29 c2                	sub    %eax,%edx
  800dc9:	89 d0                	mov    %edx,%eax
}
  800dcb:	c9                   	leave  
  800dcc:	c3                   	ret    

00800dcd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dd0:	eb 06                	jmp    800dd8 <strcmp+0xb>
		p++, q++;
  800dd2:	ff 45 08             	incl   0x8(%ebp)
  800dd5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	84 c0                	test   %al,%al
  800ddf:	74 0e                	je     800def <strcmp+0x22>
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8a 10                	mov    (%eax),%dl
  800de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	38 c2                	cmp    %al,%dl
  800ded:	74 e3                	je     800dd2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 d0             	movzbl %al,%edx
  800df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	0f b6 c0             	movzbl %al,%eax
  800dff:	29 c2                	sub    %eax,%edx
  800e01:	89 d0                	mov    %edx,%eax
}
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e08:	eb 09                	jmp    800e13 <strncmp+0xe>
		n--, p++, q++;
  800e0a:	ff 4d 10             	decl   0x10(%ebp)
  800e0d:	ff 45 08             	incl   0x8(%ebp)
  800e10:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e17:	74 17                	je     800e30 <strncmp+0x2b>
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	8a 00                	mov    (%eax),%al
  800e1e:	84 c0                	test   %al,%al
  800e20:	74 0e                	je     800e30 <strncmp+0x2b>
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	8a 10                	mov    (%eax),%dl
  800e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2a:	8a 00                	mov    (%eax),%al
  800e2c:	38 c2                	cmp    %al,%dl
  800e2e:	74 da                	je     800e0a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e34:	75 07                	jne    800e3d <strncmp+0x38>
		return 0;
  800e36:	b8 00 00 00 00       	mov    $0x0,%eax
  800e3b:	eb 14                	jmp    800e51 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	0f b6 d0             	movzbl %al,%edx
  800e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e48:	8a 00                	mov    (%eax),%al
  800e4a:	0f b6 c0             	movzbl %al,%eax
  800e4d:	29 c2                	sub    %eax,%edx
  800e4f:	89 d0                	mov    %edx,%eax
}
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    

00800e53 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	83 ec 04             	sub    $0x4,%esp
  800e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e5f:	eb 12                	jmp    800e73 <strchr+0x20>
		if (*s == c)
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e69:	75 05                	jne    800e70 <strchr+0x1d>
			return (char *) s;
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	eb 11                	jmp    800e81 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e70:	ff 45 08             	incl   0x8(%ebp)
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	84 c0                	test   %al,%al
  800e7a:	75 e5                	jne    800e61 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e81:	c9                   	leave  
  800e82:	c3                   	ret    

00800e83 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 04             	sub    $0x4,%esp
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e8f:	eb 0d                	jmp    800e9e <strfind+0x1b>
		if (*s == c)
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e99:	74 0e                	je     800ea9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e9b:	ff 45 08             	incl   0x8(%ebp)
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	84 c0                	test   %al,%al
  800ea5:	75 ea                	jne    800e91 <strfind+0xe>
  800ea7:	eb 01                	jmp    800eaa <strfind+0x27>
		if (*s == c)
			break;
  800ea9:	90                   	nop
	return (char *) s;
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ec1:	eb 0e                	jmp    800ed1 <memset+0x22>
		*p++ = c;
  800ec3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec6:	8d 50 01             	lea    0x1(%eax),%edx
  800ec9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecf:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ed1:	ff 4d f8             	decl   -0x8(%ebp)
  800ed4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ed8:	79 e9                	jns    800ec3 <memset+0x14>
		*p++ = c;

	return v;
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800edd:	c9                   	leave  
  800ede:	c3                   	ret    

00800edf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ef1:	eb 16                	jmp    800f09 <memcpy+0x2a>
		*d++ = *s++;
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8d 50 01             	lea    0x1(%eax),%edx
  800ef9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800efc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f02:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f05:	8a 12                	mov    (%edx),%dl
  800f07:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f12:	85 c0                	test   %eax,%eax
  800f14:	75 dd                	jne    800ef3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f33:	73 50                	jae    800f85 <memmove+0x6a>
  800f35:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3b:	01 d0                	add    %edx,%eax
  800f3d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f40:	76 43                	jbe    800f85 <memmove+0x6a>
		s += n;
  800f42:	8b 45 10             	mov    0x10(%ebp),%eax
  800f45:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f48:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f4e:	eb 10                	jmp    800f60 <memmove+0x45>
			*--d = *--s;
  800f50:	ff 4d f8             	decl   -0x8(%ebp)
  800f53:	ff 4d fc             	decl   -0x4(%ebp)
  800f56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f59:	8a 10                	mov    (%eax),%dl
  800f5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f60:	8b 45 10             	mov    0x10(%ebp),%eax
  800f63:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f66:	89 55 10             	mov    %edx,0x10(%ebp)
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	75 e3                	jne    800f50 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f6d:	eb 23                	jmp    800f92 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f72:	8d 50 01             	lea    0x1(%eax),%edx
  800f75:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f7e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f81:	8a 12                	mov    (%edx),%dl
  800f83:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f85:	8b 45 10             	mov    0x10(%ebp),%eax
  800f88:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	75 dd                	jne    800f6f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f95:	c9                   	leave  
  800f96:	c3                   	ret    

00800f97 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fa9:	eb 2a                	jmp    800fd5 <memcmp+0x3e>
		if (*s1 != *s2)
  800fab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fae:	8a 10                	mov    (%eax),%dl
  800fb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	38 c2                	cmp    %al,%dl
  800fb7:	74 16                	je     800fcf <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	0f b6 d0             	movzbl %al,%edx
  800fc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	0f b6 c0             	movzbl %al,%eax
  800fc9:	29 c2                	sub    %eax,%edx
  800fcb:	89 d0                	mov    %edx,%eax
  800fcd:	eb 18                	jmp    800fe7 <memcmp+0x50>
		s1++, s2++;
  800fcf:	ff 45 fc             	incl   -0x4(%ebp)
  800fd2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800fde:	85 c0                	test   %eax,%eax
  800fe0:	75 c9                	jne    800fab <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fe2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe7:	c9                   	leave  
  800fe8:	c3                   	ret    

00800fe9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff5:	01 d0                	add    %edx,%eax
  800ff7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ffa:	eb 15                	jmp    801011 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	0f b6 d0             	movzbl %al,%edx
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	0f b6 c0             	movzbl %al,%eax
  80100a:	39 c2                	cmp    %eax,%edx
  80100c:	74 0d                	je     80101b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80100e:	ff 45 08             	incl   0x8(%ebp)
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801017:	72 e3                	jb     800ffc <memfind+0x13>
  801019:	eb 01                	jmp    80101c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80101b:	90                   	nop
	return (void *) s;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101f:	c9                   	leave  
  801020:	c3                   	ret    

00801021 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801027:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80102e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801035:	eb 03                	jmp    80103a <strtol+0x19>
		s++;
  801037:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 20                	cmp    $0x20,%al
  801041:	74 f4                	je     801037 <strtol+0x16>
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	8a 00                	mov    (%eax),%al
  801048:	3c 09                	cmp    $0x9,%al
  80104a:	74 eb                	je     801037 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	3c 2b                	cmp    $0x2b,%al
  801053:	75 05                	jne    80105a <strtol+0x39>
		s++;
  801055:	ff 45 08             	incl   0x8(%ebp)
  801058:	eb 13                	jmp    80106d <strtol+0x4c>
	else if (*s == '-')
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	3c 2d                	cmp    $0x2d,%al
  801061:	75 0a                	jne    80106d <strtol+0x4c>
		s++, neg = 1;
  801063:	ff 45 08             	incl   0x8(%ebp)
  801066:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80106d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801071:	74 06                	je     801079 <strtol+0x58>
  801073:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801077:	75 20                	jne    801099 <strtol+0x78>
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	3c 30                	cmp    $0x30,%al
  801080:	75 17                	jne    801099 <strtol+0x78>
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	40                   	inc    %eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	3c 78                	cmp    $0x78,%al
  80108a:	75 0d                	jne    801099 <strtol+0x78>
		s += 2, base = 16;
  80108c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801090:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801097:	eb 28                	jmp    8010c1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801099:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109d:	75 15                	jne    8010b4 <strtol+0x93>
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	3c 30                	cmp    $0x30,%al
  8010a6:	75 0c                	jne    8010b4 <strtol+0x93>
		s++, base = 8;
  8010a8:	ff 45 08             	incl   0x8(%ebp)
  8010ab:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010b2:	eb 0d                	jmp    8010c1 <strtol+0xa0>
	else if (base == 0)
  8010b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b8:	75 07                	jne    8010c1 <strtol+0xa0>
		base = 10;
  8010ba:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	3c 2f                	cmp    $0x2f,%al
  8010c8:	7e 19                	jle    8010e3 <strtol+0xc2>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	3c 39                	cmp    $0x39,%al
  8010d1:	7f 10                	jg     8010e3 <strtol+0xc2>
			dig = *s - '0';
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	0f be c0             	movsbl %al,%eax
  8010db:	83 e8 30             	sub    $0x30,%eax
  8010de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e1:	eb 42                	jmp    801125 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	3c 60                	cmp    $0x60,%al
  8010ea:	7e 19                	jle    801105 <strtol+0xe4>
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 7a                	cmp    $0x7a,%al
  8010f3:	7f 10                	jg     801105 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	0f be c0             	movsbl %al,%eax
  8010fd:	83 e8 57             	sub    $0x57,%eax
  801100:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801103:	eb 20                	jmp    801125 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 40                	cmp    $0x40,%al
  80110c:	7e 39                	jle    801147 <strtol+0x126>
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 5a                	cmp    $0x5a,%al
  801115:	7f 30                	jg     801147 <strtol+0x126>
			dig = *s - 'A' + 10;
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f be c0             	movsbl %al,%eax
  80111f:	83 e8 37             	sub    $0x37,%eax
  801122:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801128:	3b 45 10             	cmp    0x10(%ebp),%eax
  80112b:	7d 19                	jge    801146 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80112d:	ff 45 08             	incl   0x8(%ebp)
  801130:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801133:	0f af 45 10          	imul   0x10(%ebp),%eax
  801137:	89 c2                	mov    %eax,%edx
  801139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113c:	01 d0                	add    %edx,%eax
  80113e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801141:	e9 7b ff ff ff       	jmp    8010c1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801146:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801147:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80114b:	74 08                	je     801155 <strtol+0x134>
		*endptr = (char *) s;
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	8b 55 08             	mov    0x8(%ebp),%edx
  801153:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801155:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801159:	74 07                	je     801162 <strtol+0x141>
  80115b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115e:	f7 d8                	neg    %eax
  801160:	eb 03                	jmp    801165 <strtol+0x144>
  801162:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801165:	c9                   	leave  
  801166:	c3                   	ret    

00801167 <ltostr>:

void
ltostr(long value, char *str)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801174:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80117b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80117f:	79 13                	jns    801194 <ltostr+0x2d>
	{
		neg = 1;
  801181:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80118e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801191:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80119c:	99                   	cltd   
  80119d:	f7 f9                	idiv   %ecx
  80119f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a5:	8d 50 01             	lea    0x1(%eax),%edx
  8011a8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ab:	89 c2                	mov    %eax,%edx
  8011ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b0:	01 d0                	add    %edx,%eax
  8011b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011b5:	83 c2 30             	add    $0x30,%edx
  8011b8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011bd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011c2:	f7 e9                	imul   %ecx
  8011c4:	c1 fa 02             	sar    $0x2,%edx
  8011c7:	89 c8                	mov    %ecx,%eax
  8011c9:	c1 f8 1f             	sar    $0x1f,%eax
  8011cc:	29 c2                	sub    %eax,%edx
  8011ce:	89 d0                	mov    %edx,%eax
  8011d0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011d6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011db:	f7 e9                	imul   %ecx
  8011dd:	c1 fa 02             	sar    $0x2,%edx
  8011e0:	89 c8                	mov    %ecx,%eax
  8011e2:	c1 f8 1f             	sar    $0x1f,%eax
  8011e5:	29 c2                	sub    %eax,%edx
  8011e7:	89 d0                	mov    %edx,%eax
  8011e9:	c1 e0 02             	shl    $0x2,%eax
  8011ec:	01 d0                	add    %edx,%eax
  8011ee:	01 c0                	add    %eax,%eax
  8011f0:	29 c1                	sub    %eax,%ecx
  8011f2:	89 ca                	mov    %ecx,%edx
  8011f4:	85 d2                	test   %edx,%edx
  8011f6:	75 9c                	jne    801194 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801202:	48                   	dec    %eax
  801203:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801206:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120a:	74 3d                	je     801249 <ltostr+0xe2>
		start = 1 ;
  80120c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801213:	eb 34                	jmp    801249 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 d0                	add    %edx,%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801222:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801225:	8b 45 0c             	mov    0xc(%ebp),%eax
  801228:	01 c2                	add    %eax,%edx
  80122a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80122d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801230:	01 c8                	add    %ecx,%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801236:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123c:	01 c2                	add    %eax,%edx
  80123e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801241:	88 02                	mov    %al,(%edx)
		start++ ;
  801243:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801246:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80124f:	7c c4                	jl     801215 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801251:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801254:	8b 45 0c             	mov    0xc(%ebp),%eax
  801257:	01 d0                	add    %edx,%eax
  801259:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80125c:	90                   	nop
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801265:	ff 75 08             	pushl  0x8(%ebp)
  801268:	e8 54 fa ff ff       	call   800cc1 <strlen>
  80126d:	83 c4 04             	add    $0x4,%esp
  801270:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801273:	ff 75 0c             	pushl  0xc(%ebp)
  801276:	e8 46 fa ff ff       	call   800cc1 <strlen>
  80127b:	83 c4 04             	add    $0x4,%esp
  80127e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801281:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801288:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80128f:	eb 17                	jmp    8012a8 <strcconcat+0x49>
		final[s] = str1[s] ;
  801291:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	01 c2                	add    %eax,%edx
  801299:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	01 c8                	add    %ecx,%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012a5:	ff 45 fc             	incl   -0x4(%ebp)
  8012a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012ae:	7c e1                	jl     801291 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012be:	eb 1f                	jmp    8012df <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c3:	8d 50 01             	lea    0x1(%eax),%edx
  8012c6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012c9:	89 c2                	mov    %eax,%edx
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	01 c2                	add    %eax,%edx
  8012d0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	01 c8                	add    %ecx,%eax
  8012d8:	8a 00                	mov    (%eax),%al
  8012da:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012dc:	ff 45 f8             	incl   -0x8(%ebp)
  8012df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012e5:	7c d9                	jl     8012c0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ed:	01 d0                	add    %edx,%eax
  8012ef:	c6 00 00             	movb   $0x0,(%eax)
}
  8012f2:	90                   	nop
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801301:	8b 45 14             	mov    0x14(%ebp),%eax
  801304:	8b 00                	mov    (%eax),%eax
  801306:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80130d:	8b 45 10             	mov    0x10(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801318:	eb 0c                	jmp    801326 <strsplit+0x31>
			*string++ = 0;
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	8d 50 01             	lea    0x1(%eax),%edx
  801320:	89 55 08             	mov    %edx,0x8(%ebp)
  801323:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	84 c0                	test   %al,%al
  80132d:	74 18                	je     801347 <strsplit+0x52>
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	8a 00                	mov    (%eax),%al
  801334:	0f be c0             	movsbl %al,%eax
  801337:	50                   	push   %eax
  801338:	ff 75 0c             	pushl  0xc(%ebp)
  80133b:	e8 13 fb ff ff       	call   800e53 <strchr>
  801340:	83 c4 08             	add    $0x8,%esp
  801343:	85 c0                	test   %eax,%eax
  801345:	75 d3                	jne    80131a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
  80134a:	8a 00                	mov    (%eax),%al
  80134c:	84 c0                	test   %al,%al
  80134e:	74 5a                	je     8013aa <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801350:	8b 45 14             	mov    0x14(%ebp),%eax
  801353:	8b 00                	mov    (%eax),%eax
  801355:	83 f8 0f             	cmp    $0xf,%eax
  801358:	75 07                	jne    801361 <strsplit+0x6c>
		{
			return 0;
  80135a:	b8 00 00 00 00       	mov    $0x0,%eax
  80135f:	eb 66                	jmp    8013c7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801361:	8b 45 14             	mov    0x14(%ebp),%eax
  801364:	8b 00                	mov    (%eax),%eax
  801366:	8d 48 01             	lea    0x1(%eax),%ecx
  801369:	8b 55 14             	mov    0x14(%ebp),%edx
  80136c:	89 0a                	mov    %ecx,(%edx)
  80136e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801375:	8b 45 10             	mov    0x10(%ebp),%eax
  801378:	01 c2                	add    %eax,%edx
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80137f:	eb 03                	jmp    801384 <strsplit+0x8f>
			string++;
  801381:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	8a 00                	mov    (%eax),%al
  801389:	84 c0                	test   %al,%al
  80138b:	74 8b                	je     801318 <strsplit+0x23>
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	0f be c0             	movsbl %al,%eax
  801395:	50                   	push   %eax
  801396:	ff 75 0c             	pushl  0xc(%ebp)
  801399:	e8 b5 fa ff ff       	call   800e53 <strchr>
  80139e:	83 c4 08             	add    $0x8,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	74 dc                	je     801381 <strsplit+0x8c>
			string++;
	}
  8013a5:	e9 6e ff ff ff       	jmp    801318 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013aa:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ae:	8b 00                	mov    (%eax),%eax
  8013b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ba:	01 d0                	add    %edx,%eax
  8013bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013c2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013c7:	c9                   	leave  
  8013c8:	c3                   	ret    

008013c9 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
  8013cc:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013cf:	a1 04 50 80 00       	mov    0x805004,%eax
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	74 1f                	je     8013f7 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013d8:	e8 1d 00 00 00       	call   8013fa <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013dd:	83 ec 0c             	sub    $0xc,%esp
  8013e0:	68 d0 3e 80 00       	push   $0x803ed0
  8013e5:	e8 55 f2 ff ff       	call   80063f <cprintf>
  8013ea:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013ed:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8013f4:	00 00 00 
	}
}
  8013f7:	90                   	nop
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    

008013fa <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801400:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801407:	00 00 00 
  80140a:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801411:	00 00 00 
  801414:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80141b:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80141e:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801425:	00 00 00 
  801428:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80142f:	00 00 00 
  801432:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801439:	00 00 00 
	uint32 arr_size = 0;
  80143c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801443:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80144a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801452:	2d 00 10 00 00       	sub    $0x1000,%eax
  801457:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80145c:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801463:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801466:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80146d:	a1 20 51 80 00       	mov    0x805120,%eax
  801472:	c1 e0 04             	shl    $0x4,%eax
  801475:	89 c2                	mov    %eax,%edx
  801477:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80147a:	01 d0                	add    %edx,%eax
  80147c:	48                   	dec    %eax
  80147d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801480:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801483:	ba 00 00 00 00       	mov    $0x0,%edx
  801488:	f7 75 ec             	divl   -0x14(%ebp)
  80148b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80148e:	29 d0                	sub    %edx,%eax
  801490:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801493:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80149a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80149d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014a2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014a7:	83 ec 04             	sub    $0x4,%esp
  8014aa:	6a 06                	push   $0x6
  8014ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8014af:	50                   	push   %eax
  8014b0:	e8 b2 05 00 00       	call   801a67 <sys_allocate_chunk>
  8014b5:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014b8:	a1 20 51 80 00       	mov    0x805120,%eax
  8014bd:	83 ec 0c             	sub    $0xc,%esp
  8014c0:	50                   	push   %eax
  8014c1:	e8 27 0c 00 00       	call   8020ed <initialize_MemBlocksList>
  8014c6:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8014c9:	a1 48 51 80 00       	mov    0x805148,%eax
  8014ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8014d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d4:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8014db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014de:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8014e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014e9:	75 14                	jne    8014ff <initialize_dyn_block_system+0x105>
  8014eb:	83 ec 04             	sub    $0x4,%esp
  8014ee:	68 f5 3e 80 00       	push   $0x803ef5
  8014f3:	6a 33                	push   $0x33
  8014f5:	68 13 3f 80 00       	push   $0x803f13
  8014fa:	e8 8c ee ff ff       	call   80038b <_panic>
  8014ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801502:	8b 00                	mov    (%eax),%eax
  801504:	85 c0                	test   %eax,%eax
  801506:	74 10                	je     801518 <initialize_dyn_block_system+0x11e>
  801508:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80150b:	8b 00                	mov    (%eax),%eax
  80150d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801510:	8b 52 04             	mov    0x4(%edx),%edx
  801513:	89 50 04             	mov    %edx,0x4(%eax)
  801516:	eb 0b                	jmp    801523 <initialize_dyn_block_system+0x129>
  801518:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151b:	8b 40 04             	mov    0x4(%eax),%eax
  80151e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801523:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801526:	8b 40 04             	mov    0x4(%eax),%eax
  801529:	85 c0                	test   %eax,%eax
  80152b:	74 0f                	je     80153c <initialize_dyn_block_system+0x142>
  80152d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801530:	8b 40 04             	mov    0x4(%eax),%eax
  801533:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801536:	8b 12                	mov    (%edx),%edx
  801538:	89 10                	mov    %edx,(%eax)
  80153a:	eb 0a                	jmp    801546 <initialize_dyn_block_system+0x14c>
  80153c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80153f:	8b 00                	mov    (%eax),%eax
  801541:	a3 48 51 80 00       	mov    %eax,0x805148
  801546:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801549:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80154f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801552:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801559:	a1 54 51 80 00       	mov    0x805154,%eax
  80155e:	48                   	dec    %eax
  80155f:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801564:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801568:	75 14                	jne    80157e <initialize_dyn_block_system+0x184>
  80156a:	83 ec 04             	sub    $0x4,%esp
  80156d:	68 20 3f 80 00       	push   $0x803f20
  801572:	6a 34                	push   $0x34
  801574:	68 13 3f 80 00       	push   $0x803f13
  801579:	e8 0d ee ff ff       	call   80038b <_panic>
  80157e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801584:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801587:	89 10                	mov    %edx,(%eax)
  801589:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80158c:	8b 00                	mov    (%eax),%eax
  80158e:	85 c0                	test   %eax,%eax
  801590:	74 0d                	je     80159f <initialize_dyn_block_system+0x1a5>
  801592:	a1 38 51 80 00       	mov    0x805138,%eax
  801597:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80159a:	89 50 04             	mov    %edx,0x4(%eax)
  80159d:	eb 08                	jmp    8015a7 <initialize_dyn_block_system+0x1ad>
  80159f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8015a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015aa:	a3 38 51 80 00       	mov    %eax,0x805138
  8015af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8015be:	40                   	inc    %eax
  8015bf:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8015c4:	90                   	nop
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015cd:	e8 f7 fd ff ff       	call   8013c9 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015d6:	75 07                	jne    8015df <malloc+0x18>
  8015d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015dd:	eb 61                	jmp    801640 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8015df:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ec:	01 d0                	add    %edx,%eax
  8015ee:	48                   	dec    %eax
  8015ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fa:	f7 75 f0             	divl   -0x10(%ebp)
  8015fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801600:	29 d0                	sub    %edx,%eax
  801602:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801605:	e8 2b 08 00 00       	call   801e35 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80160a:	85 c0                	test   %eax,%eax
  80160c:	74 11                	je     80161f <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80160e:	83 ec 0c             	sub    $0xc,%esp
  801611:	ff 75 e8             	pushl  -0x18(%ebp)
  801614:	e8 96 0e 00 00       	call   8024af <alloc_block_FF>
  801619:	83 c4 10             	add    $0x10,%esp
  80161c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  80161f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801623:	74 16                	je     80163b <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801625:	83 ec 0c             	sub    $0xc,%esp
  801628:	ff 75 f4             	pushl  -0xc(%ebp)
  80162b:	e8 f2 0b 00 00       	call   802222 <insert_sorted_allocList>
  801630:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801636:	8b 40 08             	mov    0x8(%eax),%eax
  801639:	eb 05                	jmp    801640 <malloc+0x79>
	}

    return NULL;
  80163b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	83 ec 08             	sub    $0x8,%esp
  80164e:	50                   	push   %eax
  80164f:	68 40 50 80 00       	push   $0x805040
  801654:	e8 71 0b 00 00       	call   8021ca <find_block>
  801659:	83 c4 10             	add    $0x10,%esp
  80165c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  80165f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801663:	0f 84 a6 00 00 00    	je     80170f <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166c:	8b 50 0c             	mov    0xc(%eax),%edx
  80166f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801672:	8b 40 08             	mov    0x8(%eax),%eax
  801675:	83 ec 08             	sub    $0x8,%esp
  801678:	52                   	push   %edx
  801679:	50                   	push   %eax
  80167a:	e8 b0 03 00 00       	call   801a2f <sys_free_user_mem>
  80167f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801682:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801686:	75 14                	jne    80169c <free+0x5a>
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	68 f5 3e 80 00       	push   $0x803ef5
  801690:	6a 74                	push   $0x74
  801692:	68 13 3f 80 00       	push   $0x803f13
  801697:	e8 ef ec ff ff       	call   80038b <_panic>
  80169c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169f:	8b 00                	mov    (%eax),%eax
  8016a1:	85 c0                	test   %eax,%eax
  8016a3:	74 10                	je     8016b5 <free+0x73>
  8016a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a8:	8b 00                	mov    (%eax),%eax
  8016aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ad:	8b 52 04             	mov    0x4(%edx),%edx
  8016b0:	89 50 04             	mov    %edx,0x4(%eax)
  8016b3:	eb 0b                	jmp    8016c0 <free+0x7e>
  8016b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b8:	8b 40 04             	mov    0x4(%eax),%eax
  8016bb:	a3 44 50 80 00       	mov    %eax,0x805044
  8016c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c3:	8b 40 04             	mov    0x4(%eax),%eax
  8016c6:	85 c0                	test   %eax,%eax
  8016c8:	74 0f                	je     8016d9 <free+0x97>
  8016ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016cd:	8b 40 04             	mov    0x4(%eax),%eax
  8016d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d3:	8b 12                	mov    (%edx),%edx
  8016d5:	89 10                	mov    %edx,(%eax)
  8016d7:	eb 0a                	jmp    8016e3 <free+0xa1>
  8016d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dc:	8b 00                	mov    (%eax),%eax
  8016de:	a3 40 50 80 00       	mov    %eax,0x805040
  8016e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016f6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8016fb:	48                   	dec    %eax
  8016fc:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801701:	83 ec 0c             	sub    $0xc,%esp
  801704:	ff 75 f4             	pushl  -0xc(%ebp)
  801707:	e8 4e 17 00 00       	call   802e5a <insert_sorted_with_merge_freeList>
  80170c:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80170f:	90                   	nop
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	83 ec 38             	sub    $0x38,%esp
  801718:	8b 45 10             	mov    0x10(%ebp),%eax
  80171b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80171e:	e8 a6 fc ff ff       	call   8013c9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801723:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801727:	75 0a                	jne    801733 <smalloc+0x21>
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
  80172e:	e9 8b 00 00 00       	jmp    8017be <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801733:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80173a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801740:	01 d0                	add    %edx,%eax
  801742:	48                   	dec    %eax
  801743:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801746:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801749:	ba 00 00 00 00       	mov    $0x0,%edx
  80174e:	f7 75 f0             	divl   -0x10(%ebp)
  801751:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801754:	29 d0                	sub    %edx,%eax
  801756:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801759:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801760:	e8 d0 06 00 00       	call   801e35 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801765:	85 c0                	test   %eax,%eax
  801767:	74 11                	je     80177a <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801769:	83 ec 0c             	sub    $0xc,%esp
  80176c:	ff 75 e8             	pushl  -0x18(%ebp)
  80176f:	e8 3b 0d 00 00       	call   8024af <alloc_block_FF>
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  80177a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80177e:	74 39                	je     8017b9 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801783:	8b 40 08             	mov    0x8(%eax),%eax
  801786:	89 c2                	mov    %eax,%edx
  801788:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80178c:	52                   	push   %edx
  80178d:	50                   	push   %eax
  80178e:	ff 75 0c             	pushl  0xc(%ebp)
  801791:	ff 75 08             	pushl  0x8(%ebp)
  801794:	e8 21 04 00 00       	call   801bba <sys_createSharedObject>
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80179f:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8017a3:	74 14                	je     8017b9 <smalloc+0xa7>
  8017a5:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8017a9:	74 0e                	je     8017b9 <smalloc+0xa7>
  8017ab:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8017af:	74 08                	je     8017b9 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b4:	8b 40 08             	mov    0x8(%eax),%eax
  8017b7:	eb 05                	jmp    8017be <smalloc+0xac>
	}
	return NULL;
  8017b9:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017c6:	e8 fe fb ff ff       	call   8013c9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017cb:	83 ec 08             	sub    $0x8,%esp
  8017ce:	ff 75 0c             	pushl  0xc(%ebp)
  8017d1:	ff 75 08             	pushl  0x8(%ebp)
  8017d4:	e8 0b 04 00 00       	call   801be4 <sys_getSizeOfSharedObject>
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8017df:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8017e3:	74 76                	je     80185b <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8017e5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f2:	01 d0                	add    %edx,%eax
  8017f4:	48                   	dec    %eax
  8017f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801800:	f7 75 ec             	divl   -0x14(%ebp)
  801803:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801806:	29 d0                	sub    %edx,%eax
  801808:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80180b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801812:	e8 1e 06 00 00       	call   801e35 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801817:	85 c0                	test   %eax,%eax
  801819:	74 11                	je     80182c <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80181b:	83 ec 0c             	sub    $0xc,%esp
  80181e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801821:	e8 89 0c 00 00       	call   8024af <alloc_block_FF>
  801826:	83 c4 10             	add    $0x10,%esp
  801829:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80182c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801830:	74 29                	je     80185b <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801835:	8b 40 08             	mov    0x8(%eax),%eax
  801838:	83 ec 04             	sub    $0x4,%esp
  80183b:	50                   	push   %eax
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	ff 75 08             	pushl  0x8(%ebp)
  801842:	e8 ba 03 00 00       	call   801c01 <sys_getSharedObject>
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80184d:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801851:	74 08                	je     80185b <sget+0x9b>
				return (void *)mem_block->sva;
  801853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801856:	8b 40 08             	mov    0x8(%eax),%eax
  801859:	eb 05                	jmp    801860 <sget+0xa0>
		}
	}
	return NULL;
  80185b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801868:	e8 5c fb ff ff       	call   8013c9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80186d:	83 ec 04             	sub    $0x4,%esp
  801870:	68 44 3f 80 00       	push   $0x803f44
  801875:	68 f7 00 00 00       	push   $0xf7
  80187a:	68 13 3f 80 00       	push   $0x803f13
  80187f:	e8 07 eb ff ff       	call   80038b <_panic>

00801884 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80188a:	83 ec 04             	sub    $0x4,%esp
  80188d:	68 6c 3f 80 00       	push   $0x803f6c
  801892:	68 0c 01 00 00       	push   $0x10c
  801897:	68 13 3f 80 00       	push   $0x803f13
  80189c:	e8 ea ea ff ff       	call   80038b <_panic>

008018a1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a7:	83 ec 04             	sub    $0x4,%esp
  8018aa:	68 90 3f 80 00       	push   $0x803f90
  8018af:	68 44 01 00 00       	push   $0x144
  8018b4:	68 13 3f 80 00       	push   $0x803f13
  8018b9:	e8 cd ea ff ff       	call   80038b <_panic>

008018be <shrink>:

}
void shrink(uint32 newSize)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c4:	83 ec 04             	sub    $0x4,%esp
  8018c7:	68 90 3f 80 00       	push   $0x803f90
  8018cc:	68 49 01 00 00       	push   $0x149
  8018d1:	68 13 3f 80 00       	push   $0x803f13
  8018d6:	e8 b0 ea ff ff       	call   80038b <_panic>

008018db <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e1:	83 ec 04             	sub    $0x4,%esp
  8018e4:	68 90 3f 80 00       	push   $0x803f90
  8018e9:	68 4e 01 00 00       	push   $0x14e
  8018ee:	68 13 3f 80 00       	push   $0x803f13
  8018f3:	e8 93 ea ff ff       	call   80038b <_panic>

008018f8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	57                   	push   %edi
  8018fc:	56                   	push   %esi
  8018fd:	53                   	push   %ebx
  8018fe:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	8b 55 0c             	mov    0xc(%ebp),%edx
  801907:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80190d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801910:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801913:	cd 30                	int    $0x30
  801915:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801918:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80191b:	83 c4 10             	add    $0x10,%esp
  80191e:	5b                   	pop    %ebx
  80191f:	5e                   	pop    %esi
  801920:	5f                   	pop    %edi
  801921:	5d                   	pop    %ebp
  801922:	c3                   	ret    

00801923 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	8b 45 10             	mov    0x10(%ebp),%eax
  80192c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80192f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	52                   	push   %edx
  80193b:	ff 75 0c             	pushl  0xc(%ebp)
  80193e:	50                   	push   %eax
  80193f:	6a 00                	push   $0x0
  801941:	e8 b2 ff ff ff       	call   8018f8 <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
}
  801949:	90                   	nop
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_cgetc>:

int
sys_cgetc(void)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 01                	push   $0x1
  80195b:	e8 98 ff ff ff       	call   8018f8 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801968:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	52                   	push   %edx
  801975:	50                   	push   %eax
  801976:	6a 05                	push   $0x5
  801978:	e8 7b ff ff ff       	call   8018f8 <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	56                   	push   %esi
  801986:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801987:	8b 75 18             	mov    0x18(%ebp),%esi
  80198a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80198d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801990:	8b 55 0c             	mov    0xc(%ebp),%edx
  801993:	8b 45 08             	mov    0x8(%ebp),%eax
  801996:	56                   	push   %esi
  801997:	53                   	push   %ebx
  801998:	51                   	push   %ecx
  801999:	52                   	push   %edx
  80199a:	50                   	push   %eax
  80199b:	6a 06                	push   $0x6
  80199d:	e8 56 ff ff ff       	call   8018f8 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a8:	5b                   	pop    %ebx
  8019a9:	5e                   	pop    %esi
  8019aa:	5d                   	pop    %ebp
  8019ab:	c3                   	ret    

008019ac <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	52                   	push   %edx
  8019bc:	50                   	push   %eax
  8019bd:	6a 07                	push   $0x7
  8019bf:	e8 34 ff ff ff       	call   8018f8 <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	ff 75 0c             	pushl  0xc(%ebp)
  8019d5:	ff 75 08             	pushl  0x8(%ebp)
  8019d8:	6a 08                	push   $0x8
  8019da:	e8 19 ff ff ff       	call   8018f8 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 09                	push   $0x9
  8019f3:	e8 00 ff ff ff       	call   8018f8 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 0a                	push   $0xa
  801a0c:	e8 e7 fe ff ff       	call   8018f8 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 0b                	push   $0xb
  801a25:	e8 ce fe ff ff       	call   8018f8 <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	ff 75 0c             	pushl  0xc(%ebp)
  801a3b:	ff 75 08             	pushl  0x8(%ebp)
  801a3e:	6a 0f                	push   $0xf
  801a40:	e8 b3 fe ff ff       	call   8018f8 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
	return;
  801a48:	90                   	nop
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	ff 75 08             	pushl  0x8(%ebp)
  801a5a:	6a 10                	push   $0x10
  801a5c:	e8 97 fe ff ff       	call   8018f8 <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
	return ;
  801a64:	90                   	nop
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	ff 75 10             	pushl  0x10(%ebp)
  801a71:	ff 75 0c             	pushl  0xc(%ebp)
  801a74:	ff 75 08             	pushl  0x8(%ebp)
  801a77:	6a 11                	push   $0x11
  801a79:	e8 7a fe ff ff       	call   8018f8 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a81:	90                   	nop
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 0c                	push   $0xc
  801a93:	e8 60 fe ff ff       	call   8018f8 <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	ff 75 08             	pushl  0x8(%ebp)
  801aab:	6a 0d                	push   $0xd
  801aad:	e8 46 fe ff ff       	call   8018f8 <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 0e                	push   $0xe
  801ac6:	e8 2d fe ff ff       	call   8018f8 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	90                   	nop
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 13                	push   $0x13
  801ae0:	e8 13 fe ff ff       	call   8018f8 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	90                   	nop
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 14                	push   $0x14
  801afa:	e8 f9 fd ff ff       	call   8018f8 <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	90                   	nop
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	83 ec 04             	sub    $0x4,%esp
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b11:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	50                   	push   %eax
  801b1e:	6a 15                	push   $0x15
  801b20:	e8 d3 fd ff ff       	call   8018f8 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	90                   	nop
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 16                	push   $0x16
  801b3a:	e8 b9 fd ff ff       	call   8018f8 <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	90                   	nop
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	ff 75 0c             	pushl  0xc(%ebp)
  801b54:	50                   	push   %eax
  801b55:	6a 17                	push   $0x17
  801b57:	e8 9c fd ff ff       	call   8018f8 <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	52                   	push   %edx
  801b71:	50                   	push   %eax
  801b72:	6a 1a                	push   $0x1a
  801b74:	e8 7f fd ff ff       	call   8018f8 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	52                   	push   %edx
  801b8e:	50                   	push   %eax
  801b8f:	6a 18                	push   $0x18
  801b91:	e8 62 fd ff ff       	call   8018f8 <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
}
  801b99:	90                   	nop
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	52                   	push   %edx
  801bac:	50                   	push   %eax
  801bad:	6a 19                	push   $0x19
  801baf:	e8 44 fd ff ff       	call   8018f8 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	90                   	nop
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 04             	sub    $0x4,%esp
  801bc0:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bc6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bc9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	6a 00                	push   $0x0
  801bd2:	51                   	push   %ecx
  801bd3:	52                   	push   %edx
  801bd4:	ff 75 0c             	pushl  0xc(%ebp)
  801bd7:	50                   	push   %eax
  801bd8:	6a 1b                	push   $0x1b
  801bda:	e8 19 fd ff ff       	call   8018f8 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801be7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bea:	8b 45 08             	mov    0x8(%ebp),%eax
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	52                   	push   %edx
  801bf4:	50                   	push   %eax
  801bf5:	6a 1c                	push   $0x1c
  801bf7:	e8 fc fc ff ff       	call   8018f8 <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c04:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	51                   	push   %ecx
  801c12:	52                   	push   %edx
  801c13:	50                   	push   %eax
  801c14:	6a 1d                	push   $0x1d
  801c16:	e8 dd fc ff ff       	call   8018f8 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	52                   	push   %edx
  801c30:	50                   	push   %eax
  801c31:	6a 1e                	push   $0x1e
  801c33:	e8 c0 fc ff ff       	call   8018f8 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 1f                	push   $0x1f
  801c4c:	e8 a7 fc ff ff       	call   8018f8 <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	6a 00                	push   $0x0
  801c5e:	ff 75 14             	pushl  0x14(%ebp)
  801c61:	ff 75 10             	pushl  0x10(%ebp)
  801c64:	ff 75 0c             	pushl  0xc(%ebp)
  801c67:	50                   	push   %eax
  801c68:	6a 20                	push   $0x20
  801c6a:	e8 89 fc ff ff       	call   8018f8 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	50                   	push   %eax
  801c83:	6a 21                	push   $0x21
  801c85:	e8 6e fc ff ff       	call   8018f8 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	90                   	nop
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	50                   	push   %eax
  801c9f:	6a 22                	push   $0x22
  801ca1:	e8 52 fc ff ff       	call   8018f8 <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 02                	push   $0x2
  801cba:	e8 39 fc ff ff       	call   8018f8 <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 03                	push   $0x3
  801cd3:	e8 20 fc ff ff       	call   8018f8 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 04                	push   $0x4
  801cec:	e8 07 fc ff ff       	call   8018f8 <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_exit_env>:


void sys_exit_env(void)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 23                	push   $0x23
  801d05:	e8 ee fb ff ff       	call   8018f8 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
}
  801d0d:	90                   	nop
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d16:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d19:	8d 50 04             	lea    0x4(%eax),%edx
  801d1c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	52                   	push   %edx
  801d26:	50                   	push   %eax
  801d27:	6a 24                	push   $0x24
  801d29:	e8 ca fb ff ff       	call   8018f8 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
	return result;
  801d31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d37:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d3a:	89 01                	mov    %eax,(%ecx)
  801d3c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	c9                   	leave  
  801d43:	c2 04 00             	ret    $0x4

00801d46 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	ff 75 10             	pushl  0x10(%ebp)
  801d50:	ff 75 0c             	pushl  0xc(%ebp)
  801d53:	ff 75 08             	pushl  0x8(%ebp)
  801d56:	6a 12                	push   $0x12
  801d58:	e8 9b fb ff ff       	call   8018f8 <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d60:	90                   	nop
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 25                	push   $0x25
  801d72:	e8 81 fb ff ff       	call   8018f8 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 04             	sub    $0x4,%esp
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d88:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	50                   	push   %eax
  801d95:	6a 26                	push   $0x26
  801d97:	e8 5c fb ff ff       	call   8018f8 <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9f:	90                   	nop
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <rsttst>:
void rsttst()
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 28                	push   $0x28
  801db1:	e8 42 fb ff ff       	call   8018f8 <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
	return ;
  801db9:	90                   	nop
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	83 ec 04             	sub    $0x4,%esp
  801dc2:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dc8:	8b 55 18             	mov    0x18(%ebp),%edx
  801dcb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dcf:	52                   	push   %edx
  801dd0:	50                   	push   %eax
  801dd1:	ff 75 10             	pushl  0x10(%ebp)
  801dd4:	ff 75 0c             	pushl  0xc(%ebp)
  801dd7:	ff 75 08             	pushl  0x8(%ebp)
  801dda:	6a 27                	push   $0x27
  801ddc:	e8 17 fb ff ff       	call   8018f8 <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
	return ;
  801de4:	90                   	nop
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <chktst>:
void chktst(uint32 n)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	ff 75 08             	pushl  0x8(%ebp)
  801df5:	6a 29                	push   $0x29
  801df7:	e8 fc fa ff ff       	call   8018f8 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
	return ;
  801dff:	90                   	nop
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <inctst>:

void inctst()
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 2a                	push   $0x2a
  801e11:	e8 e2 fa ff ff       	call   8018f8 <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
	return ;
  801e19:	90                   	nop
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <gettst>:
uint32 gettst()
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 2b                	push   $0x2b
  801e2b:	e8 c8 fa ff ff       	call   8018f8 <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 2c                	push   $0x2c
  801e47:	e8 ac fa ff ff       	call   8018f8 <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
  801e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e52:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e56:	75 07                	jne    801e5f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e58:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5d:	eb 05                	jmp    801e64 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 2c                	push   $0x2c
  801e78:	e8 7b fa ff ff       	call   8018f8 <syscall>
  801e7d:	83 c4 18             	add    $0x18,%esp
  801e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e83:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e87:	75 07                	jne    801e90 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e89:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8e:	eb 05                	jmp    801e95 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 2c                	push   $0x2c
  801ea9:	e8 4a fa ff ff       	call   8018f8 <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
  801eb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eb4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eb8:	75 07                	jne    801ec1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801eba:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebf:	eb 05                	jmp    801ec6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ec1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 2c                	push   $0x2c
  801eda:	e8 19 fa ff ff       	call   8018f8 <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
  801ee2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ee5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ee9:	75 07                	jne    801ef2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eeb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef0:	eb 05                	jmp    801ef7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	ff 75 08             	pushl  0x8(%ebp)
  801f07:	6a 2d                	push   $0x2d
  801f09:	e8 ea f9 ff ff       	call   8018f8 <syscall>
  801f0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f11:	90                   	nop
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f18:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	6a 00                	push   $0x0
  801f26:	53                   	push   %ebx
  801f27:	51                   	push   %ecx
  801f28:	52                   	push   %edx
  801f29:	50                   	push   %eax
  801f2a:	6a 2e                	push   $0x2e
  801f2c:	e8 c7 f9 ff ff       	call   8018f8 <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
}
  801f34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	52                   	push   %edx
  801f49:	50                   	push   %eax
  801f4a:	6a 2f                	push   $0x2f
  801f4c:	e8 a7 f9 ff ff       	call   8018f8 <syscall>
  801f51:	83 c4 18             	add    $0x18,%esp
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f5c:	83 ec 0c             	sub    $0xc,%esp
  801f5f:	68 a0 3f 80 00       	push   $0x803fa0
  801f64:	e8 d6 e6 ff ff       	call   80063f <cprintf>
  801f69:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f6c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f73:	83 ec 0c             	sub    $0xc,%esp
  801f76:	68 cc 3f 80 00       	push   $0x803fcc
  801f7b:	e8 bf e6 ff ff       	call   80063f <cprintf>
  801f80:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f83:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f87:	a1 38 51 80 00       	mov    0x805138,%eax
  801f8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8f:	eb 56                	jmp    801fe7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f95:	74 1c                	je     801fb3 <print_mem_block_lists+0x5d>
  801f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9a:	8b 50 08             	mov    0x8(%eax),%edx
  801f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa0:	8b 48 08             	mov    0x8(%eax),%ecx
  801fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa6:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa9:	01 c8                	add    %ecx,%eax
  801fab:	39 c2                	cmp    %eax,%edx
  801fad:	73 04                	jae    801fb3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801faf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	8b 50 08             	mov    0x8(%eax),%edx
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	8b 40 0c             	mov    0xc(%eax),%eax
  801fbf:	01 c2                	add    %eax,%edx
  801fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc4:	8b 40 08             	mov    0x8(%eax),%eax
  801fc7:	83 ec 04             	sub    $0x4,%esp
  801fca:	52                   	push   %edx
  801fcb:	50                   	push   %eax
  801fcc:	68 e1 3f 80 00       	push   $0x803fe1
  801fd1:	e8 69 e6 ff ff       	call   80063f <cprintf>
  801fd6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fdf:	a1 40 51 80 00       	mov    0x805140,%eax
  801fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801feb:	74 07                	je     801ff4 <print_mem_block_lists+0x9e>
  801fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff0:	8b 00                	mov    (%eax),%eax
  801ff2:	eb 05                	jmp    801ff9 <print_mem_block_lists+0xa3>
  801ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff9:	a3 40 51 80 00       	mov    %eax,0x805140
  801ffe:	a1 40 51 80 00       	mov    0x805140,%eax
  802003:	85 c0                	test   %eax,%eax
  802005:	75 8a                	jne    801f91 <print_mem_block_lists+0x3b>
  802007:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80200b:	75 84                	jne    801f91 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80200d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802011:	75 10                	jne    802023 <print_mem_block_lists+0xcd>
  802013:	83 ec 0c             	sub    $0xc,%esp
  802016:	68 f0 3f 80 00       	push   $0x803ff0
  80201b:	e8 1f e6 ff ff       	call   80063f <cprintf>
  802020:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802023:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80202a:	83 ec 0c             	sub    $0xc,%esp
  80202d:	68 14 40 80 00       	push   $0x804014
  802032:	e8 08 e6 ff ff       	call   80063f <cprintf>
  802037:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80203a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80203e:	a1 40 50 80 00       	mov    0x805040,%eax
  802043:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802046:	eb 56                	jmp    80209e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802048:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80204c:	74 1c                	je     80206a <print_mem_block_lists+0x114>
  80204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802051:	8b 50 08             	mov    0x8(%eax),%edx
  802054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802057:	8b 48 08             	mov    0x8(%eax),%ecx
  80205a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205d:	8b 40 0c             	mov    0xc(%eax),%eax
  802060:	01 c8                	add    %ecx,%eax
  802062:	39 c2                	cmp    %eax,%edx
  802064:	73 04                	jae    80206a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802066:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206d:	8b 50 08             	mov    0x8(%eax),%edx
  802070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802073:	8b 40 0c             	mov    0xc(%eax),%eax
  802076:	01 c2                	add    %eax,%edx
  802078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207b:	8b 40 08             	mov    0x8(%eax),%eax
  80207e:	83 ec 04             	sub    $0x4,%esp
  802081:	52                   	push   %edx
  802082:	50                   	push   %eax
  802083:	68 e1 3f 80 00       	push   $0x803fe1
  802088:	e8 b2 e5 ff ff       	call   80063f <cprintf>
  80208d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802093:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802096:	a1 48 50 80 00       	mov    0x805048,%eax
  80209b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80209e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a2:	74 07                	je     8020ab <print_mem_block_lists+0x155>
  8020a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a7:	8b 00                	mov    (%eax),%eax
  8020a9:	eb 05                	jmp    8020b0 <print_mem_block_lists+0x15a>
  8020ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b0:	a3 48 50 80 00       	mov    %eax,0x805048
  8020b5:	a1 48 50 80 00       	mov    0x805048,%eax
  8020ba:	85 c0                	test   %eax,%eax
  8020bc:	75 8a                	jne    802048 <print_mem_block_lists+0xf2>
  8020be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c2:	75 84                	jne    802048 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020c4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020c8:	75 10                	jne    8020da <print_mem_block_lists+0x184>
  8020ca:	83 ec 0c             	sub    $0xc,%esp
  8020cd:	68 2c 40 80 00       	push   $0x80402c
  8020d2:	e8 68 e5 ff ff       	call   80063f <cprintf>
  8020d7:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020da:	83 ec 0c             	sub    $0xc,%esp
  8020dd:	68 a0 3f 80 00       	push   $0x803fa0
  8020e2:	e8 58 e5 ff ff       	call   80063f <cprintf>
  8020e7:	83 c4 10             	add    $0x10,%esp

}
  8020ea:	90                   	nop
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020f3:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020fa:	00 00 00 
  8020fd:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802104:	00 00 00 
  802107:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80210e:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802111:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802118:	e9 9e 00 00 00       	jmp    8021bb <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80211d:	a1 50 50 80 00       	mov    0x805050,%eax
  802122:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802125:	c1 e2 04             	shl    $0x4,%edx
  802128:	01 d0                	add    %edx,%eax
  80212a:	85 c0                	test   %eax,%eax
  80212c:	75 14                	jne    802142 <initialize_MemBlocksList+0x55>
  80212e:	83 ec 04             	sub    $0x4,%esp
  802131:	68 54 40 80 00       	push   $0x804054
  802136:	6a 46                	push   $0x46
  802138:	68 77 40 80 00       	push   $0x804077
  80213d:	e8 49 e2 ff ff       	call   80038b <_panic>
  802142:	a1 50 50 80 00       	mov    0x805050,%eax
  802147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214a:	c1 e2 04             	shl    $0x4,%edx
  80214d:	01 d0                	add    %edx,%eax
  80214f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802155:	89 10                	mov    %edx,(%eax)
  802157:	8b 00                	mov    (%eax),%eax
  802159:	85 c0                	test   %eax,%eax
  80215b:	74 18                	je     802175 <initialize_MemBlocksList+0x88>
  80215d:	a1 48 51 80 00       	mov    0x805148,%eax
  802162:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802168:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80216b:	c1 e1 04             	shl    $0x4,%ecx
  80216e:	01 ca                	add    %ecx,%edx
  802170:	89 50 04             	mov    %edx,0x4(%eax)
  802173:	eb 12                	jmp    802187 <initialize_MemBlocksList+0x9a>
  802175:	a1 50 50 80 00       	mov    0x805050,%eax
  80217a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217d:	c1 e2 04             	shl    $0x4,%edx
  802180:	01 d0                	add    %edx,%eax
  802182:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802187:	a1 50 50 80 00       	mov    0x805050,%eax
  80218c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218f:	c1 e2 04             	shl    $0x4,%edx
  802192:	01 d0                	add    %edx,%eax
  802194:	a3 48 51 80 00       	mov    %eax,0x805148
  802199:	a1 50 50 80 00       	mov    0x805050,%eax
  80219e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a1:	c1 e2 04             	shl    $0x4,%edx
  8021a4:	01 d0                	add    %edx,%eax
  8021a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ad:	a1 54 51 80 00       	mov    0x805154,%eax
  8021b2:	40                   	inc    %eax
  8021b3:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8021b8:	ff 45 f4             	incl   -0xc(%ebp)
  8021bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021c1:	0f 82 56 ff ff ff    	jb     80211d <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8021c7:	90                   	nop
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	8b 00                	mov    (%eax),%eax
  8021d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021d8:	eb 19                	jmp    8021f3 <find_block+0x29>
	{
		if(va==point->sva)
  8021da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021dd:	8b 40 08             	mov    0x8(%eax),%eax
  8021e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021e3:	75 05                	jne    8021ea <find_block+0x20>
		   return point;
  8021e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e8:	eb 36                	jmp    802220 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	8b 40 08             	mov    0x8(%eax),%eax
  8021f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f7:	74 07                	je     802200 <find_block+0x36>
  8021f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021fc:	8b 00                	mov    (%eax),%eax
  8021fe:	eb 05                	jmp    802205 <find_block+0x3b>
  802200:	b8 00 00 00 00       	mov    $0x0,%eax
  802205:	8b 55 08             	mov    0x8(%ebp),%edx
  802208:	89 42 08             	mov    %eax,0x8(%edx)
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	8b 40 08             	mov    0x8(%eax),%eax
  802211:	85 c0                	test   %eax,%eax
  802213:	75 c5                	jne    8021da <find_block+0x10>
  802215:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802219:	75 bf                	jne    8021da <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80221b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802228:	a1 40 50 80 00       	mov    0x805040,%eax
  80222d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802230:	a1 44 50 80 00       	mov    0x805044,%eax
  802235:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802238:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80223e:	74 24                	je     802264 <insert_sorted_allocList+0x42>
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	8b 50 08             	mov    0x8(%eax),%edx
  802246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802249:	8b 40 08             	mov    0x8(%eax),%eax
  80224c:	39 c2                	cmp    %eax,%edx
  80224e:	76 14                	jbe    802264 <insert_sorted_allocList+0x42>
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	8b 50 08             	mov    0x8(%eax),%edx
  802256:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802259:	8b 40 08             	mov    0x8(%eax),%eax
  80225c:	39 c2                	cmp    %eax,%edx
  80225e:	0f 82 60 01 00 00    	jb     8023c4 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802264:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802268:	75 65                	jne    8022cf <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80226a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80226e:	75 14                	jne    802284 <insert_sorted_allocList+0x62>
  802270:	83 ec 04             	sub    $0x4,%esp
  802273:	68 54 40 80 00       	push   $0x804054
  802278:	6a 6b                	push   $0x6b
  80227a:	68 77 40 80 00       	push   $0x804077
  80227f:	e8 07 e1 ff ff       	call   80038b <_panic>
  802284:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	89 10                	mov    %edx,(%eax)
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	8b 00                	mov    (%eax),%eax
  802294:	85 c0                	test   %eax,%eax
  802296:	74 0d                	je     8022a5 <insert_sorted_allocList+0x83>
  802298:	a1 40 50 80 00       	mov    0x805040,%eax
  80229d:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a0:	89 50 04             	mov    %edx,0x4(%eax)
  8022a3:	eb 08                	jmp    8022ad <insert_sorted_allocList+0x8b>
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	a3 44 50 80 00       	mov    %eax,0x805044
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	a3 40 50 80 00       	mov    %eax,0x805040
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022bf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022c4:	40                   	inc    %eax
  8022c5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022ca:	e9 dc 01 00 00       	jmp    8024ab <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	8b 50 08             	mov    0x8(%eax),%edx
  8022d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d8:	8b 40 08             	mov    0x8(%eax),%eax
  8022db:	39 c2                	cmp    %eax,%edx
  8022dd:	77 6c                	ja     80234b <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8022df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022e3:	74 06                	je     8022eb <insert_sorted_allocList+0xc9>
  8022e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022e9:	75 14                	jne    8022ff <insert_sorted_allocList+0xdd>
  8022eb:	83 ec 04             	sub    $0x4,%esp
  8022ee:	68 90 40 80 00       	push   $0x804090
  8022f3:	6a 6f                	push   $0x6f
  8022f5:	68 77 40 80 00       	push   $0x804077
  8022fa:	e8 8c e0 ff ff       	call   80038b <_panic>
  8022ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802302:	8b 50 04             	mov    0x4(%eax),%edx
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	89 50 04             	mov    %edx,0x4(%eax)
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802311:	89 10                	mov    %edx,(%eax)
  802313:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802316:	8b 40 04             	mov    0x4(%eax),%eax
  802319:	85 c0                	test   %eax,%eax
  80231b:	74 0d                	je     80232a <insert_sorted_allocList+0x108>
  80231d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802320:	8b 40 04             	mov    0x4(%eax),%eax
  802323:	8b 55 08             	mov    0x8(%ebp),%edx
  802326:	89 10                	mov    %edx,(%eax)
  802328:	eb 08                	jmp    802332 <insert_sorted_allocList+0x110>
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	a3 40 50 80 00       	mov    %eax,0x805040
  802332:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802335:	8b 55 08             	mov    0x8(%ebp),%edx
  802338:	89 50 04             	mov    %edx,0x4(%eax)
  80233b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802340:	40                   	inc    %eax
  802341:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802346:	e9 60 01 00 00       	jmp    8024ab <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	8b 50 08             	mov    0x8(%eax),%edx
  802351:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802354:	8b 40 08             	mov    0x8(%eax),%eax
  802357:	39 c2                	cmp    %eax,%edx
  802359:	0f 82 4c 01 00 00    	jb     8024ab <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80235f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802363:	75 14                	jne    802379 <insert_sorted_allocList+0x157>
  802365:	83 ec 04             	sub    $0x4,%esp
  802368:	68 c8 40 80 00       	push   $0x8040c8
  80236d:	6a 73                	push   $0x73
  80236f:	68 77 40 80 00       	push   $0x804077
  802374:	e8 12 e0 ff ff       	call   80038b <_panic>
  802379:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	89 50 04             	mov    %edx,0x4(%eax)
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	8b 40 04             	mov    0x4(%eax),%eax
  80238b:	85 c0                	test   %eax,%eax
  80238d:	74 0c                	je     80239b <insert_sorted_allocList+0x179>
  80238f:	a1 44 50 80 00       	mov    0x805044,%eax
  802394:	8b 55 08             	mov    0x8(%ebp),%edx
  802397:	89 10                	mov    %edx,(%eax)
  802399:	eb 08                	jmp    8023a3 <insert_sorted_allocList+0x181>
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	a3 40 50 80 00       	mov    %eax,0x805040
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	a3 44 50 80 00       	mov    %eax,0x805044
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023b4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023b9:	40                   	inc    %eax
  8023ba:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023bf:	e9 e7 00 00 00       	jmp    8024ab <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8023c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8023ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023d1:	a1 40 50 80 00       	mov    0x805040,%eax
  8023d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d9:	e9 9d 00 00 00       	jmp    80247b <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	8b 00                	mov    (%eax),%eax
  8023e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	8b 50 08             	mov    0x8(%eax),%edx
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	8b 40 08             	mov    0x8(%eax),%eax
  8023f2:	39 c2                	cmp    %eax,%edx
  8023f4:	76 7d                	jbe    802473 <insert_sorted_allocList+0x251>
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	8b 50 08             	mov    0x8(%eax),%edx
  8023fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023ff:	8b 40 08             	mov    0x8(%eax),%eax
  802402:	39 c2                	cmp    %eax,%edx
  802404:	73 6d                	jae    802473 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240a:	74 06                	je     802412 <insert_sorted_allocList+0x1f0>
  80240c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802410:	75 14                	jne    802426 <insert_sorted_allocList+0x204>
  802412:	83 ec 04             	sub    $0x4,%esp
  802415:	68 ec 40 80 00       	push   $0x8040ec
  80241a:	6a 7f                	push   $0x7f
  80241c:	68 77 40 80 00       	push   $0x804077
  802421:	e8 65 df ff ff       	call   80038b <_panic>
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 10                	mov    (%eax),%edx
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	89 10                	mov    %edx,(%eax)
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	74 0b                	je     802444 <insert_sorted_allocList+0x222>
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	8b 00                	mov    (%eax),%eax
  80243e:	8b 55 08             	mov    0x8(%ebp),%edx
  802441:	89 50 04             	mov    %edx,0x4(%eax)
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	8b 55 08             	mov    0x8(%ebp),%edx
  80244a:	89 10                	mov    %edx,(%eax)
  80244c:	8b 45 08             	mov    0x8(%ebp),%eax
  80244f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802452:	89 50 04             	mov    %edx,0x4(%eax)
  802455:	8b 45 08             	mov    0x8(%ebp),%eax
  802458:	8b 00                	mov    (%eax),%eax
  80245a:	85 c0                	test   %eax,%eax
  80245c:	75 08                	jne    802466 <insert_sorted_allocList+0x244>
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	a3 44 50 80 00       	mov    %eax,0x805044
  802466:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80246b:	40                   	inc    %eax
  80246c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802471:	eb 39                	jmp    8024ac <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802473:	a1 48 50 80 00       	mov    0x805048,%eax
  802478:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247f:	74 07                	je     802488 <insert_sorted_allocList+0x266>
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 00                	mov    (%eax),%eax
  802486:	eb 05                	jmp    80248d <insert_sorted_allocList+0x26b>
  802488:	b8 00 00 00 00       	mov    $0x0,%eax
  80248d:	a3 48 50 80 00       	mov    %eax,0x805048
  802492:	a1 48 50 80 00       	mov    0x805048,%eax
  802497:	85 c0                	test   %eax,%eax
  802499:	0f 85 3f ff ff ff    	jne    8023de <insert_sorted_allocList+0x1bc>
  80249f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a3:	0f 85 35 ff ff ff    	jne    8023de <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024a9:	eb 01                	jmp    8024ac <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024ab:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024ac:	90                   	nop
  8024ad:	c9                   	leave  
  8024ae:	c3                   	ret    

008024af <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
  8024b2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024b5:	a1 38 51 80 00       	mov    0x805138,%eax
  8024ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bd:	e9 85 01 00 00       	jmp    802647 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8024c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024cb:	0f 82 6e 01 00 00    	jb     80263f <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024da:	0f 85 8a 00 00 00    	jne    80256a <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8024e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e4:	75 17                	jne    8024fd <alloc_block_FF+0x4e>
  8024e6:	83 ec 04             	sub    $0x4,%esp
  8024e9:	68 20 41 80 00       	push   $0x804120
  8024ee:	68 93 00 00 00       	push   $0x93
  8024f3:	68 77 40 80 00       	push   $0x804077
  8024f8:	e8 8e de ff ff       	call   80038b <_panic>
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 00                	mov    (%eax),%eax
  802502:	85 c0                	test   %eax,%eax
  802504:	74 10                	je     802516 <alloc_block_FF+0x67>
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	8b 00                	mov    (%eax),%eax
  80250b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250e:	8b 52 04             	mov    0x4(%edx),%edx
  802511:	89 50 04             	mov    %edx,0x4(%eax)
  802514:	eb 0b                	jmp    802521 <alloc_block_FF+0x72>
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	8b 40 04             	mov    0x4(%eax),%eax
  80251c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 40 04             	mov    0x4(%eax),%eax
  802527:	85 c0                	test   %eax,%eax
  802529:	74 0f                	je     80253a <alloc_block_FF+0x8b>
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 40 04             	mov    0x4(%eax),%eax
  802531:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802534:	8b 12                	mov    (%edx),%edx
  802536:	89 10                	mov    %edx,(%eax)
  802538:	eb 0a                	jmp    802544 <alloc_block_FF+0x95>
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 00                	mov    (%eax),%eax
  80253f:	a3 38 51 80 00       	mov    %eax,0x805138
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802557:	a1 44 51 80 00       	mov    0x805144,%eax
  80255c:	48                   	dec    %eax
  80255d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	e9 10 01 00 00       	jmp    80267a <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 40 0c             	mov    0xc(%eax),%eax
  802570:	3b 45 08             	cmp    0x8(%ebp),%eax
  802573:	0f 86 c6 00 00 00    	jbe    80263f <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802579:	a1 48 51 80 00       	mov    0x805148,%eax
  80257e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 50 08             	mov    0x8(%eax),%edx
  802587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258a:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80258d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802590:	8b 55 08             	mov    0x8(%ebp),%edx
  802593:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802596:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80259a:	75 17                	jne    8025b3 <alloc_block_FF+0x104>
  80259c:	83 ec 04             	sub    $0x4,%esp
  80259f:	68 20 41 80 00       	push   $0x804120
  8025a4:	68 9b 00 00 00       	push   $0x9b
  8025a9:	68 77 40 80 00       	push   $0x804077
  8025ae:	e8 d8 dd ff ff       	call   80038b <_panic>
  8025b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b6:	8b 00                	mov    (%eax),%eax
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	74 10                	je     8025cc <alloc_block_FF+0x11d>
  8025bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bf:	8b 00                	mov    (%eax),%eax
  8025c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025c4:	8b 52 04             	mov    0x4(%edx),%edx
  8025c7:	89 50 04             	mov    %edx,0x4(%eax)
  8025ca:	eb 0b                	jmp    8025d7 <alloc_block_FF+0x128>
  8025cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cf:	8b 40 04             	mov    0x4(%eax),%eax
  8025d2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025da:	8b 40 04             	mov    0x4(%eax),%eax
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	74 0f                	je     8025f0 <alloc_block_FF+0x141>
  8025e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e4:	8b 40 04             	mov    0x4(%eax),%eax
  8025e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ea:	8b 12                	mov    (%edx),%edx
  8025ec:	89 10                	mov    %edx,(%eax)
  8025ee:	eb 0a                	jmp    8025fa <alloc_block_FF+0x14b>
  8025f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f3:	8b 00                	mov    (%eax),%eax
  8025f5:	a3 48 51 80 00       	mov    %eax,0x805148
  8025fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802606:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80260d:	a1 54 51 80 00       	mov    0x805154,%eax
  802612:	48                   	dec    %eax
  802613:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	8b 50 08             	mov    0x8(%eax),%edx
  80261e:	8b 45 08             	mov    0x8(%ebp),%eax
  802621:	01 c2                	add    %eax,%edx
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 40 0c             	mov    0xc(%eax),%eax
  80262f:	2b 45 08             	sub    0x8(%ebp),%eax
  802632:	89 c2                	mov    %eax,%edx
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80263a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263d:	eb 3b                	jmp    80267a <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80263f:	a1 40 51 80 00       	mov    0x805140,%eax
  802644:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802647:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264b:	74 07                	je     802654 <alloc_block_FF+0x1a5>
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	8b 00                	mov    (%eax),%eax
  802652:	eb 05                	jmp    802659 <alloc_block_FF+0x1aa>
  802654:	b8 00 00 00 00       	mov    $0x0,%eax
  802659:	a3 40 51 80 00       	mov    %eax,0x805140
  80265e:	a1 40 51 80 00       	mov    0x805140,%eax
  802663:	85 c0                	test   %eax,%eax
  802665:	0f 85 57 fe ff ff    	jne    8024c2 <alloc_block_FF+0x13>
  80266b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266f:	0f 85 4d fe ff ff    	jne    8024c2 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802675:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80267a:	c9                   	leave  
  80267b:	c3                   	ret    

0080267c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802682:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802689:	a1 38 51 80 00       	mov    0x805138,%eax
  80268e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802691:	e9 df 00 00 00       	jmp    802775 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 40 0c             	mov    0xc(%eax),%eax
  80269c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80269f:	0f 82 c8 00 00 00    	jb     80276d <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ae:	0f 85 8a 00 00 00    	jne    80273e <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8026b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b8:	75 17                	jne    8026d1 <alloc_block_BF+0x55>
  8026ba:	83 ec 04             	sub    $0x4,%esp
  8026bd:	68 20 41 80 00       	push   $0x804120
  8026c2:	68 b7 00 00 00       	push   $0xb7
  8026c7:	68 77 40 80 00       	push   $0x804077
  8026cc:	e8 ba dc ff ff       	call   80038b <_panic>
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 00                	mov    (%eax),%eax
  8026d6:	85 c0                	test   %eax,%eax
  8026d8:	74 10                	je     8026ea <alloc_block_BF+0x6e>
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 00                	mov    (%eax),%eax
  8026df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e2:	8b 52 04             	mov    0x4(%edx),%edx
  8026e5:	89 50 04             	mov    %edx,0x4(%eax)
  8026e8:	eb 0b                	jmp    8026f5 <alloc_block_BF+0x79>
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 40 04             	mov    0x4(%eax),%eax
  8026f0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 40 04             	mov    0x4(%eax),%eax
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	74 0f                	je     80270e <alloc_block_BF+0x92>
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 40 04             	mov    0x4(%eax),%eax
  802705:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802708:	8b 12                	mov    (%edx),%edx
  80270a:	89 10                	mov    %edx,(%eax)
  80270c:	eb 0a                	jmp    802718 <alloc_block_BF+0x9c>
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	8b 00                	mov    (%eax),%eax
  802713:	a3 38 51 80 00       	mov    %eax,0x805138
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272b:	a1 44 51 80 00       	mov    0x805144,%eax
  802730:	48                   	dec    %eax
  802731:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	e9 4d 01 00 00       	jmp    80288b <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	8b 40 0c             	mov    0xc(%eax),%eax
  802744:	3b 45 08             	cmp    0x8(%ebp),%eax
  802747:	76 24                	jbe    80276d <alloc_block_BF+0xf1>
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	8b 40 0c             	mov    0xc(%eax),%eax
  80274f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802752:	73 19                	jae    80276d <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802754:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 40 0c             	mov    0xc(%eax),%eax
  802761:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 40 08             	mov    0x8(%eax),%eax
  80276a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80276d:	a1 40 51 80 00       	mov    0x805140,%eax
  802772:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802775:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802779:	74 07                	je     802782 <alloc_block_BF+0x106>
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	8b 00                	mov    (%eax),%eax
  802780:	eb 05                	jmp    802787 <alloc_block_BF+0x10b>
  802782:	b8 00 00 00 00       	mov    $0x0,%eax
  802787:	a3 40 51 80 00       	mov    %eax,0x805140
  80278c:	a1 40 51 80 00       	mov    0x805140,%eax
  802791:	85 c0                	test   %eax,%eax
  802793:	0f 85 fd fe ff ff    	jne    802696 <alloc_block_BF+0x1a>
  802799:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279d:	0f 85 f3 fe ff ff    	jne    802696 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8027a3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027a7:	0f 84 d9 00 00 00    	je     802886 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027ad:	a1 48 51 80 00       	mov    0x805148,%eax
  8027b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8027b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027bb:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8027be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c4:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8027c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027cb:	75 17                	jne    8027e4 <alloc_block_BF+0x168>
  8027cd:	83 ec 04             	sub    $0x4,%esp
  8027d0:	68 20 41 80 00       	push   $0x804120
  8027d5:	68 c7 00 00 00       	push   $0xc7
  8027da:	68 77 40 80 00       	push   $0x804077
  8027df:	e8 a7 db ff ff       	call   80038b <_panic>
  8027e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e7:	8b 00                	mov    (%eax),%eax
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	74 10                	je     8027fd <alloc_block_BF+0x181>
  8027ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f0:	8b 00                	mov    (%eax),%eax
  8027f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027f5:	8b 52 04             	mov    0x4(%edx),%edx
  8027f8:	89 50 04             	mov    %edx,0x4(%eax)
  8027fb:	eb 0b                	jmp    802808 <alloc_block_BF+0x18c>
  8027fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802800:	8b 40 04             	mov    0x4(%eax),%eax
  802803:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280b:	8b 40 04             	mov    0x4(%eax),%eax
  80280e:	85 c0                	test   %eax,%eax
  802810:	74 0f                	je     802821 <alloc_block_BF+0x1a5>
  802812:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802815:	8b 40 04             	mov    0x4(%eax),%eax
  802818:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80281b:	8b 12                	mov    (%edx),%edx
  80281d:	89 10                	mov    %edx,(%eax)
  80281f:	eb 0a                	jmp    80282b <alloc_block_BF+0x1af>
  802821:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802824:	8b 00                	mov    (%eax),%eax
  802826:	a3 48 51 80 00       	mov    %eax,0x805148
  80282b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802837:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283e:	a1 54 51 80 00       	mov    0x805154,%eax
  802843:	48                   	dec    %eax
  802844:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802849:	83 ec 08             	sub    $0x8,%esp
  80284c:	ff 75 ec             	pushl  -0x14(%ebp)
  80284f:	68 38 51 80 00       	push   $0x805138
  802854:	e8 71 f9 ff ff       	call   8021ca <find_block>
  802859:	83 c4 10             	add    $0x10,%esp
  80285c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80285f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802862:	8b 50 08             	mov    0x8(%eax),%edx
  802865:	8b 45 08             	mov    0x8(%ebp),%eax
  802868:	01 c2                	add    %eax,%edx
  80286a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80286d:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802870:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802873:	8b 40 0c             	mov    0xc(%eax),%eax
  802876:	2b 45 08             	sub    0x8(%ebp),%eax
  802879:	89 c2                	mov    %eax,%edx
  80287b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80287e:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802884:	eb 05                	jmp    80288b <alloc_block_BF+0x20f>
	}
	return NULL;
  802886:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80288b:	c9                   	leave  
  80288c:	c3                   	ret    

0080288d <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80288d:	55                   	push   %ebp
  80288e:	89 e5                	mov    %esp,%ebp
  802890:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802893:	a1 28 50 80 00       	mov    0x805028,%eax
  802898:	85 c0                	test   %eax,%eax
  80289a:	0f 85 de 01 00 00    	jne    802a7e <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028a0:	a1 38 51 80 00       	mov    0x805138,%eax
  8028a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a8:	e9 9e 01 00 00       	jmp    802a4b <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b6:	0f 82 87 01 00 00    	jb     802a43 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c5:	0f 85 95 00 00 00    	jne    802960 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8028cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cf:	75 17                	jne    8028e8 <alloc_block_NF+0x5b>
  8028d1:	83 ec 04             	sub    $0x4,%esp
  8028d4:	68 20 41 80 00       	push   $0x804120
  8028d9:	68 e0 00 00 00       	push   $0xe0
  8028de:	68 77 40 80 00       	push   $0x804077
  8028e3:	e8 a3 da ff ff       	call   80038b <_panic>
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 00                	mov    (%eax),%eax
  8028ed:	85 c0                	test   %eax,%eax
  8028ef:	74 10                	je     802901 <alloc_block_NF+0x74>
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	8b 00                	mov    (%eax),%eax
  8028f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f9:	8b 52 04             	mov    0x4(%edx),%edx
  8028fc:	89 50 04             	mov    %edx,0x4(%eax)
  8028ff:	eb 0b                	jmp    80290c <alloc_block_NF+0x7f>
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	8b 40 04             	mov    0x4(%eax),%eax
  802907:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	8b 40 04             	mov    0x4(%eax),%eax
  802912:	85 c0                	test   %eax,%eax
  802914:	74 0f                	je     802925 <alloc_block_NF+0x98>
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 40 04             	mov    0x4(%eax),%eax
  80291c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291f:	8b 12                	mov    (%edx),%edx
  802921:	89 10                	mov    %edx,(%eax)
  802923:	eb 0a                	jmp    80292f <alloc_block_NF+0xa2>
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 00                	mov    (%eax),%eax
  80292a:	a3 38 51 80 00       	mov    %eax,0x805138
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802942:	a1 44 51 80 00       	mov    0x805144,%eax
  802947:	48                   	dec    %eax
  802948:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	8b 40 08             	mov    0x8(%eax),%eax
  802953:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	e9 f8 04 00 00       	jmp    802e58 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	8b 40 0c             	mov    0xc(%eax),%eax
  802966:	3b 45 08             	cmp    0x8(%ebp),%eax
  802969:	0f 86 d4 00 00 00    	jbe    802a43 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80296f:	a1 48 51 80 00       	mov    0x805148,%eax
  802974:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 50 08             	mov    0x8(%eax),%edx
  80297d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802980:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802986:	8b 55 08             	mov    0x8(%ebp),%edx
  802989:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80298c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802990:	75 17                	jne    8029a9 <alloc_block_NF+0x11c>
  802992:	83 ec 04             	sub    $0x4,%esp
  802995:	68 20 41 80 00       	push   $0x804120
  80299a:	68 e9 00 00 00       	push   $0xe9
  80299f:	68 77 40 80 00       	push   $0x804077
  8029a4:	e8 e2 d9 ff ff       	call   80038b <_panic>
  8029a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ac:	8b 00                	mov    (%eax),%eax
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	74 10                	je     8029c2 <alloc_block_NF+0x135>
  8029b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b5:	8b 00                	mov    (%eax),%eax
  8029b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ba:	8b 52 04             	mov    0x4(%edx),%edx
  8029bd:	89 50 04             	mov    %edx,0x4(%eax)
  8029c0:	eb 0b                	jmp    8029cd <alloc_block_NF+0x140>
  8029c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c5:	8b 40 04             	mov    0x4(%eax),%eax
  8029c8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d0:	8b 40 04             	mov    0x4(%eax),%eax
  8029d3:	85 c0                	test   %eax,%eax
  8029d5:	74 0f                	je     8029e6 <alloc_block_NF+0x159>
  8029d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029da:	8b 40 04             	mov    0x4(%eax),%eax
  8029dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029e0:	8b 12                	mov    (%edx),%edx
  8029e2:	89 10                	mov    %edx,(%eax)
  8029e4:	eb 0a                	jmp    8029f0 <alloc_block_NF+0x163>
  8029e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e9:	8b 00                	mov    (%eax),%eax
  8029eb:	a3 48 51 80 00       	mov    %eax,0x805148
  8029f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a03:	a1 54 51 80 00       	mov    0x805154,%eax
  802a08:	48                   	dec    %eax
  802a09:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a11:	8b 40 08             	mov    0x8(%eax),%eax
  802a14:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	8b 50 08             	mov    0x8(%eax),%edx
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	01 c2                	add    %eax,%edx
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a30:	2b 45 08             	sub    0x8(%ebp),%eax
  802a33:	89 c2                	mov    %eax,%edx
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3e:	e9 15 04 00 00       	jmp    802e58 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a43:	a1 40 51 80 00       	mov    0x805140,%eax
  802a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4f:	74 07                	je     802a58 <alloc_block_NF+0x1cb>
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	8b 00                	mov    (%eax),%eax
  802a56:	eb 05                	jmp    802a5d <alloc_block_NF+0x1d0>
  802a58:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5d:	a3 40 51 80 00       	mov    %eax,0x805140
  802a62:	a1 40 51 80 00       	mov    0x805140,%eax
  802a67:	85 c0                	test   %eax,%eax
  802a69:	0f 85 3e fe ff ff    	jne    8028ad <alloc_block_NF+0x20>
  802a6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a73:	0f 85 34 fe ff ff    	jne    8028ad <alloc_block_NF+0x20>
  802a79:	e9 d5 03 00 00       	jmp    802e53 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a7e:	a1 38 51 80 00       	mov    0x805138,%eax
  802a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a86:	e9 b1 01 00 00       	jmp    802c3c <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 50 08             	mov    0x8(%eax),%edx
  802a91:	a1 28 50 80 00       	mov    0x805028,%eax
  802a96:	39 c2                	cmp    %eax,%edx
  802a98:	0f 82 96 01 00 00    	jb     802c34 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa7:	0f 82 87 01 00 00    	jb     802c34 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab6:	0f 85 95 00 00 00    	jne    802b51 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802abc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac0:	75 17                	jne    802ad9 <alloc_block_NF+0x24c>
  802ac2:	83 ec 04             	sub    $0x4,%esp
  802ac5:	68 20 41 80 00       	push   $0x804120
  802aca:	68 fc 00 00 00       	push   $0xfc
  802acf:	68 77 40 80 00       	push   $0x804077
  802ad4:	e8 b2 d8 ff ff       	call   80038b <_panic>
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 00                	mov    (%eax),%eax
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	74 10                	je     802af2 <alloc_block_NF+0x265>
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	8b 00                	mov    (%eax),%eax
  802ae7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aea:	8b 52 04             	mov    0x4(%edx),%edx
  802aed:	89 50 04             	mov    %edx,0x4(%eax)
  802af0:	eb 0b                	jmp    802afd <alloc_block_NF+0x270>
  802af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af5:	8b 40 04             	mov    0x4(%eax),%eax
  802af8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 40 04             	mov    0x4(%eax),%eax
  802b03:	85 c0                	test   %eax,%eax
  802b05:	74 0f                	je     802b16 <alloc_block_NF+0x289>
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 40 04             	mov    0x4(%eax),%eax
  802b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b10:	8b 12                	mov    (%edx),%edx
  802b12:	89 10                	mov    %edx,(%eax)
  802b14:	eb 0a                	jmp    802b20 <alloc_block_NF+0x293>
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	8b 00                	mov    (%eax),%eax
  802b1b:	a3 38 51 80 00       	mov    %eax,0x805138
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b33:	a1 44 51 80 00       	mov    0x805144,%eax
  802b38:	48                   	dec    %eax
  802b39:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 40 08             	mov    0x8(%eax),%eax
  802b44:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	e9 07 03 00 00       	jmp    802e58 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	8b 40 0c             	mov    0xc(%eax),%eax
  802b57:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b5a:	0f 86 d4 00 00 00    	jbe    802c34 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b60:	a1 48 51 80 00       	mov    0x805148,%eax
  802b65:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 50 08             	mov    0x8(%eax),%edx
  802b6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b71:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b77:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b7d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b81:	75 17                	jne    802b9a <alloc_block_NF+0x30d>
  802b83:	83 ec 04             	sub    $0x4,%esp
  802b86:	68 20 41 80 00       	push   $0x804120
  802b8b:	68 04 01 00 00       	push   $0x104
  802b90:	68 77 40 80 00       	push   $0x804077
  802b95:	e8 f1 d7 ff ff       	call   80038b <_panic>
  802b9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9d:	8b 00                	mov    (%eax),%eax
  802b9f:	85 c0                	test   %eax,%eax
  802ba1:	74 10                	je     802bb3 <alloc_block_NF+0x326>
  802ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba6:	8b 00                	mov    (%eax),%eax
  802ba8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bab:	8b 52 04             	mov    0x4(%edx),%edx
  802bae:	89 50 04             	mov    %edx,0x4(%eax)
  802bb1:	eb 0b                	jmp    802bbe <alloc_block_NF+0x331>
  802bb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb6:	8b 40 04             	mov    0x4(%eax),%eax
  802bb9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc1:	8b 40 04             	mov    0x4(%eax),%eax
  802bc4:	85 c0                	test   %eax,%eax
  802bc6:	74 0f                	je     802bd7 <alloc_block_NF+0x34a>
  802bc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bcb:	8b 40 04             	mov    0x4(%eax),%eax
  802bce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bd1:	8b 12                	mov    (%edx),%edx
  802bd3:	89 10                	mov    %edx,(%eax)
  802bd5:	eb 0a                	jmp    802be1 <alloc_block_NF+0x354>
  802bd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bda:	8b 00                	mov    (%eax),%eax
  802bdc:	a3 48 51 80 00       	mov    %eax,0x805148
  802be1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf4:	a1 54 51 80 00       	mov    0x805154,%eax
  802bf9:	48                   	dec    %eax
  802bfa:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c02:	8b 40 08             	mov    0x8(%eax),%eax
  802c05:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 50 08             	mov    0x8(%eax),%edx
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	01 c2                	add    %eax,%edx
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c21:	2b 45 08             	sub    0x8(%ebp),%eax
  802c24:	89 c2                	mov    %eax,%edx
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c2f:	e9 24 02 00 00       	jmp    802e58 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c34:	a1 40 51 80 00       	mov    0x805140,%eax
  802c39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c40:	74 07                	je     802c49 <alloc_block_NF+0x3bc>
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	8b 00                	mov    (%eax),%eax
  802c47:	eb 05                	jmp    802c4e <alloc_block_NF+0x3c1>
  802c49:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4e:	a3 40 51 80 00       	mov    %eax,0x805140
  802c53:	a1 40 51 80 00       	mov    0x805140,%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	0f 85 2b fe ff ff    	jne    802a8b <alloc_block_NF+0x1fe>
  802c60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c64:	0f 85 21 fe ff ff    	jne    802a8b <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c6a:	a1 38 51 80 00       	mov    0x805138,%eax
  802c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c72:	e9 ae 01 00 00       	jmp    802e25 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 50 08             	mov    0x8(%eax),%edx
  802c7d:	a1 28 50 80 00       	mov    0x805028,%eax
  802c82:	39 c2                	cmp    %eax,%edx
  802c84:	0f 83 93 01 00 00    	jae    802e1d <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c90:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c93:	0f 82 84 01 00 00    	jb     802e1d <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ca2:	0f 85 95 00 00 00    	jne    802d3d <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ca8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cac:	75 17                	jne    802cc5 <alloc_block_NF+0x438>
  802cae:	83 ec 04             	sub    $0x4,%esp
  802cb1:	68 20 41 80 00       	push   $0x804120
  802cb6:	68 14 01 00 00       	push   $0x114
  802cbb:	68 77 40 80 00       	push   $0x804077
  802cc0:	e8 c6 d6 ff ff       	call   80038b <_panic>
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 00                	mov    (%eax),%eax
  802cca:	85 c0                	test   %eax,%eax
  802ccc:	74 10                	je     802cde <alloc_block_NF+0x451>
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	8b 00                	mov    (%eax),%eax
  802cd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd6:	8b 52 04             	mov    0x4(%edx),%edx
  802cd9:	89 50 04             	mov    %edx,0x4(%eax)
  802cdc:	eb 0b                	jmp    802ce9 <alloc_block_NF+0x45c>
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	8b 40 04             	mov    0x4(%eax),%eax
  802ce4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 40 04             	mov    0x4(%eax),%eax
  802cef:	85 c0                	test   %eax,%eax
  802cf1:	74 0f                	je     802d02 <alloc_block_NF+0x475>
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 40 04             	mov    0x4(%eax),%eax
  802cf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cfc:	8b 12                	mov    (%edx),%edx
  802cfe:	89 10                	mov    %edx,(%eax)
  802d00:	eb 0a                	jmp    802d0c <alloc_block_NF+0x47f>
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	8b 00                	mov    (%eax),%eax
  802d07:	a3 38 51 80 00       	mov    %eax,0x805138
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1f:	a1 44 51 80 00       	mov    0x805144,%eax
  802d24:	48                   	dec    %eax
  802d25:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 40 08             	mov    0x8(%eax),%eax
  802d30:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d38:	e9 1b 01 00 00       	jmp    802e58 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	8b 40 0c             	mov    0xc(%eax),%eax
  802d43:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d46:	0f 86 d1 00 00 00    	jbe    802e1d <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d4c:	a1 48 51 80 00       	mov    0x805148,%eax
  802d51:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 50 08             	mov    0x8(%eax),%edx
  802d5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d63:	8b 55 08             	mov    0x8(%ebp),%edx
  802d66:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d69:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d6d:	75 17                	jne    802d86 <alloc_block_NF+0x4f9>
  802d6f:	83 ec 04             	sub    $0x4,%esp
  802d72:	68 20 41 80 00       	push   $0x804120
  802d77:	68 1c 01 00 00       	push   $0x11c
  802d7c:	68 77 40 80 00       	push   $0x804077
  802d81:	e8 05 d6 ff ff       	call   80038b <_panic>
  802d86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d89:	8b 00                	mov    (%eax),%eax
  802d8b:	85 c0                	test   %eax,%eax
  802d8d:	74 10                	je     802d9f <alloc_block_NF+0x512>
  802d8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d92:	8b 00                	mov    (%eax),%eax
  802d94:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d97:	8b 52 04             	mov    0x4(%edx),%edx
  802d9a:	89 50 04             	mov    %edx,0x4(%eax)
  802d9d:	eb 0b                	jmp    802daa <alloc_block_NF+0x51d>
  802d9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da2:	8b 40 04             	mov    0x4(%eax),%eax
  802da5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802daa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dad:	8b 40 04             	mov    0x4(%eax),%eax
  802db0:	85 c0                	test   %eax,%eax
  802db2:	74 0f                	je     802dc3 <alloc_block_NF+0x536>
  802db4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db7:	8b 40 04             	mov    0x4(%eax),%eax
  802dba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dbd:	8b 12                	mov    (%edx),%edx
  802dbf:	89 10                	mov    %edx,(%eax)
  802dc1:	eb 0a                	jmp    802dcd <alloc_block_NF+0x540>
  802dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc6:	8b 00                	mov    (%eax),%eax
  802dc8:	a3 48 51 80 00       	mov    %eax,0x805148
  802dcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de0:	a1 54 51 80 00       	mov    0x805154,%eax
  802de5:	48                   	dec    %eax
  802de6:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802deb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dee:	8b 40 08             	mov    0x8(%eax),%eax
  802df1:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	8b 50 08             	mov    0x8(%eax),%edx
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	01 c2                	add    %eax,%edx
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0d:	2b 45 08             	sub    0x8(%ebp),%eax
  802e10:	89 c2                	mov    %eax,%edx
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1b:	eb 3b                	jmp    802e58 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e1d:	a1 40 51 80 00       	mov    0x805140,%eax
  802e22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e29:	74 07                	je     802e32 <alloc_block_NF+0x5a5>
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	8b 00                	mov    (%eax),%eax
  802e30:	eb 05                	jmp    802e37 <alloc_block_NF+0x5aa>
  802e32:	b8 00 00 00 00       	mov    $0x0,%eax
  802e37:	a3 40 51 80 00       	mov    %eax,0x805140
  802e3c:	a1 40 51 80 00       	mov    0x805140,%eax
  802e41:	85 c0                	test   %eax,%eax
  802e43:	0f 85 2e fe ff ff    	jne    802c77 <alloc_block_NF+0x3ea>
  802e49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4d:	0f 85 24 fe ff ff    	jne    802c77 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e58:	c9                   	leave  
  802e59:	c3                   	ret    

00802e5a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e5a:	55                   	push   %ebp
  802e5b:	89 e5                	mov    %esp,%ebp
  802e5d:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e60:	a1 38 51 80 00       	mov    0x805138,%eax
  802e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e68:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e6d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e70:	a1 38 51 80 00       	mov    0x805138,%eax
  802e75:	85 c0                	test   %eax,%eax
  802e77:	74 14                	je     802e8d <insert_sorted_with_merge_freeList+0x33>
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	8b 50 08             	mov    0x8(%eax),%edx
  802e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e82:	8b 40 08             	mov    0x8(%eax),%eax
  802e85:	39 c2                	cmp    %eax,%edx
  802e87:	0f 87 9b 01 00 00    	ja     803028 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e91:	75 17                	jne    802eaa <insert_sorted_with_merge_freeList+0x50>
  802e93:	83 ec 04             	sub    $0x4,%esp
  802e96:	68 54 40 80 00       	push   $0x804054
  802e9b:	68 38 01 00 00       	push   $0x138
  802ea0:	68 77 40 80 00       	push   $0x804077
  802ea5:	e8 e1 d4 ff ff       	call   80038b <_panic>
  802eaa:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	89 10                	mov    %edx,(%eax)
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	8b 00                	mov    (%eax),%eax
  802eba:	85 c0                	test   %eax,%eax
  802ebc:	74 0d                	je     802ecb <insert_sorted_with_merge_freeList+0x71>
  802ebe:	a1 38 51 80 00       	mov    0x805138,%eax
  802ec3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec6:	89 50 04             	mov    %edx,0x4(%eax)
  802ec9:	eb 08                	jmp    802ed3 <insert_sorted_with_merge_freeList+0x79>
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	a3 38 51 80 00       	mov    %eax,0x805138
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee5:	a1 44 51 80 00       	mov    0x805144,%eax
  802eea:	40                   	inc    %eax
  802eeb:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ef0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ef4:	0f 84 a8 06 00 00    	je     8035a2 <insert_sorted_with_merge_freeList+0x748>
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	8b 50 08             	mov    0x8(%eax),%edx
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	8b 40 0c             	mov    0xc(%eax),%eax
  802f06:	01 c2                	add    %eax,%edx
  802f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0b:	8b 40 08             	mov    0x8(%eax),%eax
  802f0e:	39 c2                	cmp    %eax,%edx
  802f10:	0f 85 8c 06 00 00    	jne    8035a2 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	8b 50 0c             	mov    0xc(%eax),%edx
  802f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f22:	01 c2                	add    %eax,%edx
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f2e:	75 17                	jne    802f47 <insert_sorted_with_merge_freeList+0xed>
  802f30:	83 ec 04             	sub    $0x4,%esp
  802f33:	68 20 41 80 00       	push   $0x804120
  802f38:	68 3c 01 00 00       	push   $0x13c
  802f3d:	68 77 40 80 00       	push   $0x804077
  802f42:	e8 44 d4 ff ff       	call   80038b <_panic>
  802f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	85 c0                	test   %eax,%eax
  802f4e:	74 10                	je     802f60 <insert_sorted_with_merge_freeList+0x106>
  802f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f53:	8b 00                	mov    (%eax),%eax
  802f55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f58:	8b 52 04             	mov    0x4(%edx),%edx
  802f5b:	89 50 04             	mov    %edx,0x4(%eax)
  802f5e:	eb 0b                	jmp    802f6b <insert_sorted_with_merge_freeList+0x111>
  802f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f63:	8b 40 04             	mov    0x4(%eax),%eax
  802f66:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6e:	8b 40 04             	mov    0x4(%eax),%eax
  802f71:	85 c0                	test   %eax,%eax
  802f73:	74 0f                	je     802f84 <insert_sorted_with_merge_freeList+0x12a>
  802f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f78:	8b 40 04             	mov    0x4(%eax),%eax
  802f7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f7e:	8b 12                	mov    (%edx),%edx
  802f80:	89 10                	mov    %edx,(%eax)
  802f82:	eb 0a                	jmp    802f8e <insert_sorted_with_merge_freeList+0x134>
  802f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f87:	8b 00                	mov    (%eax),%eax
  802f89:	a3 38 51 80 00       	mov    %eax,0x805138
  802f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa1:	a1 44 51 80 00       	mov    0x805144,%eax
  802fa6:	48                   	dec    %eax
  802fa7:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802faf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802fc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fc4:	75 17                	jne    802fdd <insert_sorted_with_merge_freeList+0x183>
  802fc6:	83 ec 04             	sub    $0x4,%esp
  802fc9:	68 54 40 80 00       	push   $0x804054
  802fce:	68 3f 01 00 00       	push   $0x13f
  802fd3:	68 77 40 80 00       	push   $0x804077
  802fd8:	e8 ae d3 ff ff       	call   80038b <_panic>
  802fdd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe6:	89 10                	mov    %edx,(%eax)
  802fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802feb:	8b 00                	mov    (%eax),%eax
  802fed:	85 c0                	test   %eax,%eax
  802fef:	74 0d                	je     802ffe <insert_sorted_with_merge_freeList+0x1a4>
  802ff1:	a1 48 51 80 00       	mov    0x805148,%eax
  802ff6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ff9:	89 50 04             	mov    %edx,0x4(%eax)
  802ffc:	eb 08                	jmp    803006 <insert_sorted_with_merge_freeList+0x1ac>
  802ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803001:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803006:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803009:	a3 48 51 80 00       	mov    %eax,0x805148
  80300e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803011:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803018:	a1 54 51 80 00       	mov    0x805154,%eax
  80301d:	40                   	inc    %eax
  80301e:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803023:	e9 7a 05 00 00       	jmp    8035a2 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	8b 50 08             	mov    0x8(%eax),%edx
  80302e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803031:	8b 40 08             	mov    0x8(%eax),%eax
  803034:	39 c2                	cmp    %eax,%edx
  803036:	0f 82 14 01 00 00    	jb     803150 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80303c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303f:	8b 50 08             	mov    0x8(%eax),%edx
  803042:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803045:	8b 40 0c             	mov    0xc(%eax),%eax
  803048:	01 c2                	add    %eax,%edx
  80304a:	8b 45 08             	mov    0x8(%ebp),%eax
  80304d:	8b 40 08             	mov    0x8(%eax),%eax
  803050:	39 c2                	cmp    %eax,%edx
  803052:	0f 85 90 00 00 00    	jne    8030e8 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305b:	8b 50 0c             	mov    0xc(%eax),%edx
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	8b 40 0c             	mov    0xc(%eax),%eax
  803064:	01 c2                	add    %eax,%edx
  803066:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803069:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80306c:	8b 45 08             	mov    0x8(%ebp),%eax
  80306f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803080:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803084:	75 17                	jne    80309d <insert_sorted_with_merge_freeList+0x243>
  803086:	83 ec 04             	sub    $0x4,%esp
  803089:	68 54 40 80 00       	push   $0x804054
  80308e:	68 49 01 00 00       	push   $0x149
  803093:	68 77 40 80 00       	push   $0x804077
  803098:	e8 ee d2 ff ff       	call   80038b <_panic>
  80309d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	89 10                	mov    %edx,(%eax)
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	8b 00                	mov    (%eax),%eax
  8030ad:	85 c0                	test   %eax,%eax
  8030af:	74 0d                	je     8030be <insert_sorted_with_merge_freeList+0x264>
  8030b1:	a1 48 51 80 00       	mov    0x805148,%eax
  8030b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b9:	89 50 04             	mov    %edx,0x4(%eax)
  8030bc:	eb 08                	jmp    8030c6 <insert_sorted_with_merge_freeList+0x26c>
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c9:	a3 48 51 80 00       	mov    %eax,0x805148
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d8:	a1 54 51 80 00       	mov    0x805154,%eax
  8030dd:	40                   	inc    %eax
  8030de:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030e3:	e9 bb 04 00 00       	jmp    8035a3 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ec:	75 17                	jne    803105 <insert_sorted_with_merge_freeList+0x2ab>
  8030ee:	83 ec 04             	sub    $0x4,%esp
  8030f1:	68 c8 40 80 00       	push   $0x8040c8
  8030f6:	68 4c 01 00 00       	push   $0x14c
  8030fb:	68 77 40 80 00       	push   $0x804077
  803100:	e8 86 d2 ff ff       	call   80038b <_panic>
  803105:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	89 50 04             	mov    %edx,0x4(%eax)
  803111:	8b 45 08             	mov    0x8(%ebp),%eax
  803114:	8b 40 04             	mov    0x4(%eax),%eax
  803117:	85 c0                	test   %eax,%eax
  803119:	74 0c                	je     803127 <insert_sorted_with_merge_freeList+0x2cd>
  80311b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803120:	8b 55 08             	mov    0x8(%ebp),%edx
  803123:	89 10                	mov    %edx,(%eax)
  803125:	eb 08                	jmp    80312f <insert_sorted_with_merge_freeList+0x2d5>
  803127:	8b 45 08             	mov    0x8(%ebp),%eax
  80312a:	a3 38 51 80 00       	mov    %eax,0x805138
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803140:	a1 44 51 80 00       	mov    0x805144,%eax
  803145:	40                   	inc    %eax
  803146:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80314b:	e9 53 04 00 00       	jmp    8035a3 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803150:	a1 38 51 80 00       	mov    0x805138,%eax
  803155:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803158:	e9 15 04 00 00       	jmp    803572 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80315d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803160:	8b 00                	mov    (%eax),%eax
  803162:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	8b 50 08             	mov    0x8(%eax),%edx
  80316b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316e:	8b 40 08             	mov    0x8(%eax),%eax
  803171:	39 c2                	cmp    %eax,%edx
  803173:	0f 86 f1 03 00 00    	jbe    80356a <insert_sorted_with_merge_freeList+0x710>
  803179:	8b 45 08             	mov    0x8(%ebp),%eax
  80317c:	8b 50 08             	mov    0x8(%eax),%edx
  80317f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803182:	8b 40 08             	mov    0x8(%eax),%eax
  803185:	39 c2                	cmp    %eax,%edx
  803187:	0f 83 dd 03 00 00    	jae    80356a <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80318d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803190:	8b 50 08             	mov    0x8(%eax),%edx
  803193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803196:	8b 40 0c             	mov    0xc(%eax),%eax
  803199:	01 c2                	add    %eax,%edx
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	8b 40 08             	mov    0x8(%eax),%eax
  8031a1:	39 c2                	cmp    %eax,%edx
  8031a3:	0f 85 b9 01 00 00    	jne    803362 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	8b 50 08             	mov    0x8(%eax),%edx
  8031af:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b5:	01 c2                	add    %eax,%edx
  8031b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ba:	8b 40 08             	mov    0x8(%eax),%eax
  8031bd:	39 c2                	cmp    %eax,%edx
  8031bf:	0f 85 0d 01 00 00    	jne    8032d2 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8031c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c8:	8b 50 0c             	mov    0xc(%eax),%edx
  8031cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d1:	01 c2                	add    %eax,%edx
  8031d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d6:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031d9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031dd:	75 17                	jne    8031f6 <insert_sorted_with_merge_freeList+0x39c>
  8031df:	83 ec 04             	sub    $0x4,%esp
  8031e2:	68 20 41 80 00       	push   $0x804120
  8031e7:	68 5c 01 00 00       	push   $0x15c
  8031ec:	68 77 40 80 00       	push   $0x804077
  8031f1:	e8 95 d1 ff ff       	call   80038b <_panic>
  8031f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f9:	8b 00                	mov    (%eax),%eax
  8031fb:	85 c0                	test   %eax,%eax
  8031fd:	74 10                	je     80320f <insert_sorted_with_merge_freeList+0x3b5>
  8031ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803202:	8b 00                	mov    (%eax),%eax
  803204:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803207:	8b 52 04             	mov    0x4(%edx),%edx
  80320a:	89 50 04             	mov    %edx,0x4(%eax)
  80320d:	eb 0b                	jmp    80321a <insert_sorted_with_merge_freeList+0x3c0>
  80320f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803212:	8b 40 04             	mov    0x4(%eax),%eax
  803215:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80321a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321d:	8b 40 04             	mov    0x4(%eax),%eax
  803220:	85 c0                	test   %eax,%eax
  803222:	74 0f                	je     803233 <insert_sorted_with_merge_freeList+0x3d9>
  803224:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803227:	8b 40 04             	mov    0x4(%eax),%eax
  80322a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80322d:	8b 12                	mov    (%edx),%edx
  80322f:	89 10                	mov    %edx,(%eax)
  803231:	eb 0a                	jmp    80323d <insert_sorted_with_merge_freeList+0x3e3>
  803233:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803236:	8b 00                	mov    (%eax),%eax
  803238:	a3 38 51 80 00       	mov    %eax,0x805138
  80323d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803240:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803246:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803249:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803250:	a1 44 51 80 00       	mov    0x805144,%eax
  803255:	48                   	dec    %eax
  803256:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80325b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803265:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803268:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80326f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803273:	75 17                	jne    80328c <insert_sorted_with_merge_freeList+0x432>
  803275:	83 ec 04             	sub    $0x4,%esp
  803278:	68 54 40 80 00       	push   $0x804054
  80327d:	68 5f 01 00 00       	push   $0x15f
  803282:	68 77 40 80 00       	push   $0x804077
  803287:	e8 ff d0 ff ff       	call   80038b <_panic>
  80328c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803292:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803295:	89 10                	mov    %edx,(%eax)
  803297:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329a:	8b 00                	mov    (%eax),%eax
  80329c:	85 c0                	test   %eax,%eax
  80329e:	74 0d                	je     8032ad <insert_sorted_with_merge_freeList+0x453>
  8032a0:	a1 48 51 80 00       	mov    0x805148,%eax
  8032a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a8:	89 50 04             	mov    %edx,0x4(%eax)
  8032ab:	eb 08                	jmp    8032b5 <insert_sorted_with_merge_freeList+0x45b>
  8032ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b8:	a3 48 51 80 00       	mov    %eax,0x805148
  8032bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c7:	a1 54 51 80 00       	mov    0x805154,%eax
  8032cc:	40                   	inc    %eax
  8032cd:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d5:	8b 50 0c             	mov    0xc(%eax),%edx
  8032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032db:	8b 40 0c             	mov    0xc(%eax),%eax
  8032de:	01 c2                	add    %eax,%edx
  8032e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e3:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032fe:	75 17                	jne    803317 <insert_sorted_with_merge_freeList+0x4bd>
  803300:	83 ec 04             	sub    $0x4,%esp
  803303:	68 54 40 80 00       	push   $0x804054
  803308:	68 64 01 00 00       	push   $0x164
  80330d:	68 77 40 80 00       	push   $0x804077
  803312:	e8 74 d0 ff ff       	call   80038b <_panic>
  803317:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	89 10                	mov    %edx,(%eax)
  803322:	8b 45 08             	mov    0x8(%ebp),%eax
  803325:	8b 00                	mov    (%eax),%eax
  803327:	85 c0                	test   %eax,%eax
  803329:	74 0d                	je     803338 <insert_sorted_with_merge_freeList+0x4de>
  80332b:	a1 48 51 80 00       	mov    0x805148,%eax
  803330:	8b 55 08             	mov    0x8(%ebp),%edx
  803333:	89 50 04             	mov    %edx,0x4(%eax)
  803336:	eb 08                	jmp    803340 <insert_sorted_with_merge_freeList+0x4e6>
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	a3 48 51 80 00       	mov    %eax,0x805148
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803352:	a1 54 51 80 00       	mov    0x805154,%eax
  803357:	40                   	inc    %eax
  803358:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80335d:	e9 41 02 00 00       	jmp    8035a3 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803362:	8b 45 08             	mov    0x8(%ebp),%eax
  803365:	8b 50 08             	mov    0x8(%eax),%edx
  803368:	8b 45 08             	mov    0x8(%ebp),%eax
  80336b:	8b 40 0c             	mov    0xc(%eax),%eax
  80336e:	01 c2                	add    %eax,%edx
  803370:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803373:	8b 40 08             	mov    0x8(%eax),%eax
  803376:	39 c2                	cmp    %eax,%edx
  803378:	0f 85 7c 01 00 00    	jne    8034fa <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80337e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803382:	74 06                	je     80338a <insert_sorted_with_merge_freeList+0x530>
  803384:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803388:	75 17                	jne    8033a1 <insert_sorted_with_merge_freeList+0x547>
  80338a:	83 ec 04             	sub    $0x4,%esp
  80338d:	68 90 40 80 00       	push   $0x804090
  803392:	68 69 01 00 00       	push   $0x169
  803397:	68 77 40 80 00       	push   $0x804077
  80339c:	e8 ea cf ff ff       	call   80038b <_panic>
  8033a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a4:	8b 50 04             	mov    0x4(%eax),%edx
  8033a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033aa:	89 50 04             	mov    %edx,0x4(%eax)
  8033ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b3:	89 10                	mov    %edx,(%eax)
  8033b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b8:	8b 40 04             	mov    0x4(%eax),%eax
  8033bb:	85 c0                	test   %eax,%eax
  8033bd:	74 0d                	je     8033cc <insert_sorted_with_merge_freeList+0x572>
  8033bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c2:	8b 40 04             	mov    0x4(%eax),%eax
  8033c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c8:	89 10                	mov    %edx,(%eax)
  8033ca:	eb 08                	jmp    8033d4 <insert_sorted_with_merge_freeList+0x57a>
  8033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cf:	a3 38 51 80 00       	mov    %eax,0x805138
  8033d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033da:	89 50 04             	mov    %edx,0x4(%eax)
  8033dd:	a1 44 51 80 00       	mov    0x805144,%eax
  8033e2:	40                   	inc    %eax
  8033e3:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	8b 50 0c             	mov    0xc(%eax),%edx
  8033ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f4:	01 c2                	add    %eax,%edx
  8033f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f9:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803400:	75 17                	jne    803419 <insert_sorted_with_merge_freeList+0x5bf>
  803402:	83 ec 04             	sub    $0x4,%esp
  803405:	68 20 41 80 00       	push   $0x804120
  80340a:	68 6b 01 00 00       	push   $0x16b
  80340f:	68 77 40 80 00       	push   $0x804077
  803414:	e8 72 cf ff ff       	call   80038b <_panic>
  803419:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341c:	8b 00                	mov    (%eax),%eax
  80341e:	85 c0                	test   %eax,%eax
  803420:	74 10                	je     803432 <insert_sorted_with_merge_freeList+0x5d8>
  803422:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803425:	8b 00                	mov    (%eax),%eax
  803427:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80342a:	8b 52 04             	mov    0x4(%edx),%edx
  80342d:	89 50 04             	mov    %edx,0x4(%eax)
  803430:	eb 0b                	jmp    80343d <insert_sorted_with_merge_freeList+0x5e3>
  803432:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803435:	8b 40 04             	mov    0x4(%eax),%eax
  803438:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80343d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803440:	8b 40 04             	mov    0x4(%eax),%eax
  803443:	85 c0                	test   %eax,%eax
  803445:	74 0f                	je     803456 <insert_sorted_with_merge_freeList+0x5fc>
  803447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344a:	8b 40 04             	mov    0x4(%eax),%eax
  80344d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803450:	8b 12                	mov    (%edx),%edx
  803452:	89 10                	mov    %edx,(%eax)
  803454:	eb 0a                	jmp    803460 <insert_sorted_with_merge_freeList+0x606>
  803456:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803459:	8b 00                	mov    (%eax),%eax
  80345b:	a3 38 51 80 00       	mov    %eax,0x805138
  803460:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803463:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803469:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803473:	a1 44 51 80 00       	mov    0x805144,%eax
  803478:	48                   	dec    %eax
  803479:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80347e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803481:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803488:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803492:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803496:	75 17                	jne    8034af <insert_sorted_with_merge_freeList+0x655>
  803498:	83 ec 04             	sub    $0x4,%esp
  80349b:	68 54 40 80 00       	push   $0x804054
  8034a0:	68 6e 01 00 00       	push   $0x16e
  8034a5:	68 77 40 80 00       	push   $0x804077
  8034aa:	e8 dc ce ff ff       	call   80038b <_panic>
  8034af:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b8:	89 10                	mov    %edx,(%eax)
  8034ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bd:	8b 00                	mov    (%eax),%eax
  8034bf:	85 c0                	test   %eax,%eax
  8034c1:	74 0d                	je     8034d0 <insert_sorted_with_merge_freeList+0x676>
  8034c3:	a1 48 51 80 00       	mov    0x805148,%eax
  8034c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034cb:	89 50 04             	mov    %edx,0x4(%eax)
  8034ce:	eb 08                	jmp    8034d8 <insert_sorted_with_merge_freeList+0x67e>
  8034d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034db:	a3 48 51 80 00       	mov    %eax,0x805148
  8034e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ea:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ef:	40                   	inc    %eax
  8034f0:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034f5:	e9 a9 00 00 00       	jmp    8035a3 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034fe:	74 06                	je     803506 <insert_sorted_with_merge_freeList+0x6ac>
  803500:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803504:	75 17                	jne    80351d <insert_sorted_with_merge_freeList+0x6c3>
  803506:	83 ec 04             	sub    $0x4,%esp
  803509:	68 ec 40 80 00       	push   $0x8040ec
  80350e:	68 73 01 00 00       	push   $0x173
  803513:	68 77 40 80 00       	push   $0x804077
  803518:	e8 6e ce ff ff       	call   80038b <_panic>
  80351d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803520:	8b 10                	mov    (%eax),%edx
  803522:	8b 45 08             	mov    0x8(%ebp),%eax
  803525:	89 10                	mov    %edx,(%eax)
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	8b 00                	mov    (%eax),%eax
  80352c:	85 c0                	test   %eax,%eax
  80352e:	74 0b                	je     80353b <insert_sorted_with_merge_freeList+0x6e1>
  803530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803533:	8b 00                	mov    (%eax),%eax
  803535:	8b 55 08             	mov    0x8(%ebp),%edx
  803538:	89 50 04             	mov    %edx,0x4(%eax)
  80353b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353e:	8b 55 08             	mov    0x8(%ebp),%edx
  803541:	89 10                	mov    %edx,(%eax)
  803543:	8b 45 08             	mov    0x8(%ebp),%eax
  803546:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803549:	89 50 04             	mov    %edx,0x4(%eax)
  80354c:	8b 45 08             	mov    0x8(%ebp),%eax
  80354f:	8b 00                	mov    (%eax),%eax
  803551:	85 c0                	test   %eax,%eax
  803553:	75 08                	jne    80355d <insert_sorted_with_merge_freeList+0x703>
  803555:	8b 45 08             	mov    0x8(%ebp),%eax
  803558:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80355d:	a1 44 51 80 00       	mov    0x805144,%eax
  803562:	40                   	inc    %eax
  803563:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803568:	eb 39                	jmp    8035a3 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80356a:	a1 40 51 80 00       	mov    0x805140,%eax
  80356f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803572:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803576:	74 07                	je     80357f <insert_sorted_with_merge_freeList+0x725>
  803578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357b:	8b 00                	mov    (%eax),%eax
  80357d:	eb 05                	jmp    803584 <insert_sorted_with_merge_freeList+0x72a>
  80357f:	b8 00 00 00 00       	mov    $0x0,%eax
  803584:	a3 40 51 80 00       	mov    %eax,0x805140
  803589:	a1 40 51 80 00       	mov    0x805140,%eax
  80358e:	85 c0                	test   %eax,%eax
  803590:	0f 85 c7 fb ff ff    	jne    80315d <insert_sorted_with_merge_freeList+0x303>
  803596:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80359a:	0f 85 bd fb ff ff    	jne    80315d <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035a0:	eb 01                	jmp    8035a3 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035a2:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035a3:	90                   	nop
  8035a4:	c9                   	leave  
  8035a5:	c3                   	ret    
  8035a6:	66 90                	xchg   %ax,%ax

008035a8 <__udivdi3>:
  8035a8:	55                   	push   %ebp
  8035a9:	57                   	push   %edi
  8035aa:	56                   	push   %esi
  8035ab:	53                   	push   %ebx
  8035ac:	83 ec 1c             	sub    $0x1c,%esp
  8035af:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035b3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035bf:	89 ca                	mov    %ecx,%edx
  8035c1:	89 f8                	mov    %edi,%eax
  8035c3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035c7:	85 f6                	test   %esi,%esi
  8035c9:	75 2d                	jne    8035f8 <__udivdi3+0x50>
  8035cb:	39 cf                	cmp    %ecx,%edi
  8035cd:	77 65                	ja     803634 <__udivdi3+0x8c>
  8035cf:	89 fd                	mov    %edi,%ebp
  8035d1:	85 ff                	test   %edi,%edi
  8035d3:	75 0b                	jne    8035e0 <__udivdi3+0x38>
  8035d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8035da:	31 d2                	xor    %edx,%edx
  8035dc:	f7 f7                	div    %edi
  8035de:	89 c5                	mov    %eax,%ebp
  8035e0:	31 d2                	xor    %edx,%edx
  8035e2:	89 c8                	mov    %ecx,%eax
  8035e4:	f7 f5                	div    %ebp
  8035e6:	89 c1                	mov    %eax,%ecx
  8035e8:	89 d8                	mov    %ebx,%eax
  8035ea:	f7 f5                	div    %ebp
  8035ec:	89 cf                	mov    %ecx,%edi
  8035ee:	89 fa                	mov    %edi,%edx
  8035f0:	83 c4 1c             	add    $0x1c,%esp
  8035f3:	5b                   	pop    %ebx
  8035f4:	5e                   	pop    %esi
  8035f5:	5f                   	pop    %edi
  8035f6:	5d                   	pop    %ebp
  8035f7:	c3                   	ret    
  8035f8:	39 ce                	cmp    %ecx,%esi
  8035fa:	77 28                	ja     803624 <__udivdi3+0x7c>
  8035fc:	0f bd fe             	bsr    %esi,%edi
  8035ff:	83 f7 1f             	xor    $0x1f,%edi
  803602:	75 40                	jne    803644 <__udivdi3+0x9c>
  803604:	39 ce                	cmp    %ecx,%esi
  803606:	72 0a                	jb     803612 <__udivdi3+0x6a>
  803608:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80360c:	0f 87 9e 00 00 00    	ja     8036b0 <__udivdi3+0x108>
  803612:	b8 01 00 00 00       	mov    $0x1,%eax
  803617:	89 fa                	mov    %edi,%edx
  803619:	83 c4 1c             	add    $0x1c,%esp
  80361c:	5b                   	pop    %ebx
  80361d:	5e                   	pop    %esi
  80361e:	5f                   	pop    %edi
  80361f:	5d                   	pop    %ebp
  803620:	c3                   	ret    
  803621:	8d 76 00             	lea    0x0(%esi),%esi
  803624:	31 ff                	xor    %edi,%edi
  803626:	31 c0                	xor    %eax,%eax
  803628:	89 fa                	mov    %edi,%edx
  80362a:	83 c4 1c             	add    $0x1c,%esp
  80362d:	5b                   	pop    %ebx
  80362e:	5e                   	pop    %esi
  80362f:	5f                   	pop    %edi
  803630:	5d                   	pop    %ebp
  803631:	c3                   	ret    
  803632:	66 90                	xchg   %ax,%ax
  803634:	89 d8                	mov    %ebx,%eax
  803636:	f7 f7                	div    %edi
  803638:	31 ff                	xor    %edi,%edi
  80363a:	89 fa                	mov    %edi,%edx
  80363c:	83 c4 1c             	add    $0x1c,%esp
  80363f:	5b                   	pop    %ebx
  803640:	5e                   	pop    %esi
  803641:	5f                   	pop    %edi
  803642:	5d                   	pop    %ebp
  803643:	c3                   	ret    
  803644:	bd 20 00 00 00       	mov    $0x20,%ebp
  803649:	89 eb                	mov    %ebp,%ebx
  80364b:	29 fb                	sub    %edi,%ebx
  80364d:	89 f9                	mov    %edi,%ecx
  80364f:	d3 e6                	shl    %cl,%esi
  803651:	89 c5                	mov    %eax,%ebp
  803653:	88 d9                	mov    %bl,%cl
  803655:	d3 ed                	shr    %cl,%ebp
  803657:	89 e9                	mov    %ebp,%ecx
  803659:	09 f1                	or     %esi,%ecx
  80365b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80365f:	89 f9                	mov    %edi,%ecx
  803661:	d3 e0                	shl    %cl,%eax
  803663:	89 c5                	mov    %eax,%ebp
  803665:	89 d6                	mov    %edx,%esi
  803667:	88 d9                	mov    %bl,%cl
  803669:	d3 ee                	shr    %cl,%esi
  80366b:	89 f9                	mov    %edi,%ecx
  80366d:	d3 e2                	shl    %cl,%edx
  80366f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803673:	88 d9                	mov    %bl,%cl
  803675:	d3 e8                	shr    %cl,%eax
  803677:	09 c2                	or     %eax,%edx
  803679:	89 d0                	mov    %edx,%eax
  80367b:	89 f2                	mov    %esi,%edx
  80367d:	f7 74 24 0c          	divl   0xc(%esp)
  803681:	89 d6                	mov    %edx,%esi
  803683:	89 c3                	mov    %eax,%ebx
  803685:	f7 e5                	mul    %ebp
  803687:	39 d6                	cmp    %edx,%esi
  803689:	72 19                	jb     8036a4 <__udivdi3+0xfc>
  80368b:	74 0b                	je     803698 <__udivdi3+0xf0>
  80368d:	89 d8                	mov    %ebx,%eax
  80368f:	31 ff                	xor    %edi,%edi
  803691:	e9 58 ff ff ff       	jmp    8035ee <__udivdi3+0x46>
  803696:	66 90                	xchg   %ax,%ax
  803698:	8b 54 24 08          	mov    0x8(%esp),%edx
  80369c:	89 f9                	mov    %edi,%ecx
  80369e:	d3 e2                	shl    %cl,%edx
  8036a0:	39 c2                	cmp    %eax,%edx
  8036a2:	73 e9                	jae    80368d <__udivdi3+0xe5>
  8036a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036a7:	31 ff                	xor    %edi,%edi
  8036a9:	e9 40 ff ff ff       	jmp    8035ee <__udivdi3+0x46>
  8036ae:	66 90                	xchg   %ax,%ax
  8036b0:	31 c0                	xor    %eax,%eax
  8036b2:	e9 37 ff ff ff       	jmp    8035ee <__udivdi3+0x46>
  8036b7:	90                   	nop

008036b8 <__umoddi3>:
  8036b8:	55                   	push   %ebp
  8036b9:	57                   	push   %edi
  8036ba:	56                   	push   %esi
  8036bb:	53                   	push   %ebx
  8036bc:	83 ec 1c             	sub    $0x1c,%esp
  8036bf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036d7:	89 f3                	mov    %esi,%ebx
  8036d9:	89 fa                	mov    %edi,%edx
  8036db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036df:	89 34 24             	mov    %esi,(%esp)
  8036e2:	85 c0                	test   %eax,%eax
  8036e4:	75 1a                	jne    803700 <__umoddi3+0x48>
  8036e6:	39 f7                	cmp    %esi,%edi
  8036e8:	0f 86 a2 00 00 00    	jbe    803790 <__umoddi3+0xd8>
  8036ee:	89 c8                	mov    %ecx,%eax
  8036f0:	89 f2                	mov    %esi,%edx
  8036f2:	f7 f7                	div    %edi
  8036f4:	89 d0                	mov    %edx,%eax
  8036f6:	31 d2                	xor    %edx,%edx
  8036f8:	83 c4 1c             	add    $0x1c,%esp
  8036fb:	5b                   	pop    %ebx
  8036fc:	5e                   	pop    %esi
  8036fd:	5f                   	pop    %edi
  8036fe:	5d                   	pop    %ebp
  8036ff:	c3                   	ret    
  803700:	39 f0                	cmp    %esi,%eax
  803702:	0f 87 ac 00 00 00    	ja     8037b4 <__umoddi3+0xfc>
  803708:	0f bd e8             	bsr    %eax,%ebp
  80370b:	83 f5 1f             	xor    $0x1f,%ebp
  80370e:	0f 84 ac 00 00 00    	je     8037c0 <__umoddi3+0x108>
  803714:	bf 20 00 00 00       	mov    $0x20,%edi
  803719:	29 ef                	sub    %ebp,%edi
  80371b:	89 fe                	mov    %edi,%esi
  80371d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803721:	89 e9                	mov    %ebp,%ecx
  803723:	d3 e0                	shl    %cl,%eax
  803725:	89 d7                	mov    %edx,%edi
  803727:	89 f1                	mov    %esi,%ecx
  803729:	d3 ef                	shr    %cl,%edi
  80372b:	09 c7                	or     %eax,%edi
  80372d:	89 e9                	mov    %ebp,%ecx
  80372f:	d3 e2                	shl    %cl,%edx
  803731:	89 14 24             	mov    %edx,(%esp)
  803734:	89 d8                	mov    %ebx,%eax
  803736:	d3 e0                	shl    %cl,%eax
  803738:	89 c2                	mov    %eax,%edx
  80373a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80373e:	d3 e0                	shl    %cl,%eax
  803740:	89 44 24 04          	mov    %eax,0x4(%esp)
  803744:	8b 44 24 08          	mov    0x8(%esp),%eax
  803748:	89 f1                	mov    %esi,%ecx
  80374a:	d3 e8                	shr    %cl,%eax
  80374c:	09 d0                	or     %edx,%eax
  80374e:	d3 eb                	shr    %cl,%ebx
  803750:	89 da                	mov    %ebx,%edx
  803752:	f7 f7                	div    %edi
  803754:	89 d3                	mov    %edx,%ebx
  803756:	f7 24 24             	mull   (%esp)
  803759:	89 c6                	mov    %eax,%esi
  80375b:	89 d1                	mov    %edx,%ecx
  80375d:	39 d3                	cmp    %edx,%ebx
  80375f:	0f 82 87 00 00 00    	jb     8037ec <__umoddi3+0x134>
  803765:	0f 84 91 00 00 00    	je     8037fc <__umoddi3+0x144>
  80376b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80376f:	29 f2                	sub    %esi,%edx
  803771:	19 cb                	sbb    %ecx,%ebx
  803773:	89 d8                	mov    %ebx,%eax
  803775:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803779:	d3 e0                	shl    %cl,%eax
  80377b:	89 e9                	mov    %ebp,%ecx
  80377d:	d3 ea                	shr    %cl,%edx
  80377f:	09 d0                	or     %edx,%eax
  803781:	89 e9                	mov    %ebp,%ecx
  803783:	d3 eb                	shr    %cl,%ebx
  803785:	89 da                	mov    %ebx,%edx
  803787:	83 c4 1c             	add    $0x1c,%esp
  80378a:	5b                   	pop    %ebx
  80378b:	5e                   	pop    %esi
  80378c:	5f                   	pop    %edi
  80378d:	5d                   	pop    %ebp
  80378e:	c3                   	ret    
  80378f:	90                   	nop
  803790:	89 fd                	mov    %edi,%ebp
  803792:	85 ff                	test   %edi,%edi
  803794:	75 0b                	jne    8037a1 <__umoddi3+0xe9>
  803796:	b8 01 00 00 00       	mov    $0x1,%eax
  80379b:	31 d2                	xor    %edx,%edx
  80379d:	f7 f7                	div    %edi
  80379f:	89 c5                	mov    %eax,%ebp
  8037a1:	89 f0                	mov    %esi,%eax
  8037a3:	31 d2                	xor    %edx,%edx
  8037a5:	f7 f5                	div    %ebp
  8037a7:	89 c8                	mov    %ecx,%eax
  8037a9:	f7 f5                	div    %ebp
  8037ab:	89 d0                	mov    %edx,%eax
  8037ad:	e9 44 ff ff ff       	jmp    8036f6 <__umoddi3+0x3e>
  8037b2:	66 90                	xchg   %ax,%ax
  8037b4:	89 c8                	mov    %ecx,%eax
  8037b6:	89 f2                	mov    %esi,%edx
  8037b8:	83 c4 1c             	add    $0x1c,%esp
  8037bb:	5b                   	pop    %ebx
  8037bc:	5e                   	pop    %esi
  8037bd:	5f                   	pop    %edi
  8037be:	5d                   	pop    %ebp
  8037bf:	c3                   	ret    
  8037c0:	3b 04 24             	cmp    (%esp),%eax
  8037c3:	72 06                	jb     8037cb <__umoddi3+0x113>
  8037c5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037c9:	77 0f                	ja     8037da <__umoddi3+0x122>
  8037cb:	89 f2                	mov    %esi,%edx
  8037cd:	29 f9                	sub    %edi,%ecx
  8037cf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037d3:	89 14 24             	mov    %edx,(%esp)
  8037d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037da:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037de:	8b 14 24             	mov    (%esp),%edx
  8037e1:	83 c4 1c             	add    $0x1c,%esp
  8037e4:	5b                   	pop    %ebx
  8037e5:	5e                   	pop    %esi
  8037e6:	5f                   	pop    %edi
  8037e7:	5d                   	pop    %ebp
  8037e8:	c3                   	ret    
  8037e9:	8d 76 00             	lea    0x0(%esi),%esi
  8037ec:	2b 04 24             	sub    (%esp),%eax
  8037ef:	19 fa                	sbb    %edi,%edx
  8037f1:	89 d1                	mov    %edx,%ecx
  8037f3:	89 c6                	mov    %eax,%esi
  8037f5:	e9 71 ff ff ff       	jmp    80376b <__umoddi3+0xb3>
  8037fa:	66 90                	xchg   %ax,%ax
  8037fc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803800:	72 ea                	jb     8037ec <__umoddi3+0x134>
  803802:	89 d9                	mov    %ebx,%ecx
  803804:	e9 62 ff ff ff       	jmp    80376b <__umoddi3+0xb3>
