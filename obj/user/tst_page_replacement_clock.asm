
obj/user/tst_page_replacement_clock:     file format elf32-i386


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
  800031:	e8 9d 04 00 00       	call   8004d3 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
char arr[PAGE_SIZE*12];
char* ptr = (char* )0x0801000 ;
char* ptr2 = (char* )0x0804000 ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 68             	sub    $0x68,%esp
	
	

	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80003e:	a1 20 30 80 00       	mov    0x803020,%eax
  800043:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800049:	8b 00                	mov    (%eax),%eax
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80004e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 20 1f 80 00       	push   $0x801f20
  800065:	6a 15                	push   $0x15
  800067:	68 64 1f 80 00       	push   $0x801f64
  80006c:	e8 9e 05 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800071:	a1 20 30 80 00       	mov    0x803020,%eax
  800076:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80007c:	83 c0 18             	add    $0x18,%eax
  80007f:	8b 00                	mov    (%eax),%eax
  800081:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800084:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800087:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008c:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800091:	74 14                	je     8000a7 <_main+0x6f>
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	68 20 1f 80 00       	push   $0x801f20
  80009b:	6a 16                	push   $0x16
  80009d:	68 64 1f 80 00       	push   $0x801f64
  8000a2:	e8 68 05 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ac:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000b2:	83 c0 30             	add    $0x30,%eax
  8000b5:	8b 00                	mov    (%eax),%eax
  8000b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8000ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c2:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000c7:	74 14                	je     8000dd <_main+0xa5>
  8000c9:	83 ec 04             	sub    $0x4,%esp
  8000cc:	68 20 1f 80 00       	push   $0x801f20
  8000d1:	6a 17                	push   $0x17
  8000d3:	68 64 1f 80 00       	push   $0x801f64
  8000d8:	e8 32 05 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000e8:	83 c0 48             	add    $0x48,%eax
  8000eb:	8b 00                	mov    (%eax),%eax
  8000ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000f8:	3d 00 30 20 00       	cmp    $0x203000,%eax
  8000fd:	74 14                	je     800113 <_main+0xdb>
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	68 20 1f 80 00       	push   $0x801f20
  800107:	6a 18                	push   $0x18
  800109:	68 64 1f 80 00       	push   $0x801f64
  80010e:	e8 fc 04 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80011e:	83 c0 60             	add    $0x60,%eax
  800121:	8b 00                	mov    (%eax),%eax
  800123:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800126:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800129:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80012e:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800133:	74 14                	je     800149 <_main+0x111>
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 20 1f 80 00       	push   $0x801f20
  80013d:	6a 19                	push   $0x19
  80013f:	68 64 1f 80 00       	push   $0x801f64
  800144:	e8 c6 04 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800149:	a1 20 30 80 00       	mov    0x803020,%eax
  80014e:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800154:	83 c0 78             	add    $0x78,%eax
  800157:	8b 00                	mov    (%eax),%eax
  800159:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80015c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80015f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800164:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 20 1f 80 00       	push   $0x801f20
  800173:	6a 1a                	push   $0x1a
  800175:	68 64 1f 80 00       	push   $0x801f64
  80017a:	e8 90 04 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80017f:	a1 20 30 80 00       	mov    0x803020,%eax
  800184:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80018a:	05 90 00 00 00       	add    $0x90,%eax
  80018f:	8b 00                	mov    (%eax),%eax
  800191:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800194:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800197:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019c:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 20 1f 80 00       	push   $0x801f20
  8001ab:	6a 1b                	push   $0x1b
  8001ad:	68 64 1f 80 00       	push   $0x801f64
  8001b2:	e8 58 04 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bc:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001c2:	05 a8 00 00 00       	add    $0xa8,%eax
  8001c7:	8b 00                	mov    (%eax),%eax
  8001c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d4:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001d9:	74 14                	je     8001ef <_main+0x1b7>
  8001db:	83 ec 04             	sub    $0x4,%esp
  8001de:	68 20 1f 80 00       	push   $0x801f20
  8001e3:	6a 1c                	push   $0x1c
  8001e5:	68 64 1f 80 00       	push   $0x801f64
  8001ea:	e8 20 04 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001ef:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f4:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001fa:	05 c0 00 00 00       	add    $0xc0,%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800204:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800207:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020c:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 20 1f 80 00       	push   $0x801f20
  80021b:	6a 1d                	push   $0x1d
  80021d:	68 64 1f 80 00       	push   $0x801f64
  800222:	e8 e8 03 00 00       	call   80060f <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  800227:	a1 20 30 80 00       	mov    0x803020,%eax
  80022c:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  800232:	85 c0                	test   %eax,%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 88 1f 80 00       	push   $0x801f88
  80023e:	6a 1e                	push   $0x1e
  800240:	68 64 1f 80 00       	push   $0x801f64
  800245:	e8 c5 03 00 00       	call   80060f <_panic>
	}

	int freePages = sys_calculate_free_frames();
  80024a:	e8 ea 14 00 00       	call   801739 <sys_calculate_free_frames>
  80024f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800252:	e8 82 15 00 00       	call   8017d9 <sys_pf_calculate_allocated_pages>
  800257:	89 45 c8             	mov    %eax,-0x38(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  80025a:	a0 5f e0 80 00       	mov    0x80e05f,%al
  80025f:	88 45 c7             	mov    %al,-0x39(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  800262:	a0 5f f0 80 00       	mov    0x80f05f,%al
  800267:	88 45 c6             	mov    %al,-0x3a(%ebp)

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  80026a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800271:	eb 37                	jmp    8002aa <_main+0x272>
	{
		arr[i] = -1 ;
  800273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800276:	05 60 30 80 00       	add    $0x803060,%eax
  80027b:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		*ptr2 = *ptr ;
  80027e:	a1 04 30 80 00       	mov    0x803004,%eax
  800283:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800289:	8a 12                	mov    (%edx),%dl
  80028b:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  80028d:	a1 00 30 80 00       	mov    0x803000,%eax
  800292:	40                   	inc    %eax
  800293:	a3 00 30 80 00       	mov    %eax,0x803000
  800298:	a1 04 30 80 00       	mov    0x803004,%eax
  80029d:	40                   	inc    %eax
  80029e:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1] ;
	char garbage2 = arr[PAGE_SIZE*12-1] ;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002a3:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  8002aa:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  8002b1:	7e c0                	jle    800273 <_main+0x23b>

	//===================

	//cprintf("Checking PAGE CLOCK algorithm... \n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=  0xeebfd000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  8002b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b8:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8002be:	8b 00                	mov    (%eax),%eax
  8002c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8002c3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002cb:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  8002d0:	74 14                	je     8002e6 <_main+0x2ae>
  8002d2:	83 ec 04             	sub    $0x4,%esp
  8002d5:	68 d0 1f 80 00       	push   $0x801fd0
  8002da:	6a 3a                	push   $0x3a
  8002dc:	68 64 1f 80 00       	push   $0x801f64
  8002e1:	e8 29 03 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0x80c000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  8002e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8002eb:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8002f1:	83 c0 18             	add    $0x18,%eax
  8002f4:	8b 00                	mov    (%eax),%eax
  8002f6:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8002f9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800301:	3d 00 c0 80 00       	cmp    $0x80c000,%eax
  800306:	74 14                	je     80031c <_main+0x2e4>
  800308:	83 ec 04             	sub    $0x4,%esp
  80030b:	68 d0 1f 80 00       	push   $0x801fd0
  800310:	6a 3b                	push   $0x3b
  800312:	68 64 1f 80 00       	push   $0x801f64
  800317:	e8 f3 02 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x803000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  80031c:	a1 20 30 80 00       	mov    0x803020,%eax
  800321:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800327:	83 c0 30             	add    $0x30,%eax
  80032a:	8b 00                	mov    (%eax),%eax
  80032c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80032f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800332:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800337:	3d 00 30 80 00       	cmp    $0x803000,%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 d0 1f 80 00       	push   $0x801fd0
  800346:	6a 3c                	push   $0x3c
  800348:	68 64 1f 80 00       	push   $0x801f64
  80034d:	e8 bd 02 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x804000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  800352:	a1 20 30 80 00       	mov    0x803020,%eax
  800357:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80035d:	83 c0 48             	add    $0x48,%eax
  800360:	8b 00                	mov    (%eax),%eax
  800362:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800365:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800368:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80036d:	3d 00 40 80 00       	cmp    $0x804000,%eax
  800372:	74 14                	je     800388 <_main+0x350>
  800374:	83 ec 04             	sub    $0x4,%esp
  800377:	68 d0 1f 80 00       	push   $0x801fd0
  80037c:	6a 3d                	push   $0x3d
  80037e:	68 64 1f 80 00       	push   $0x801f64
  800383:	e8 87 02 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x809000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  800388:	a1 20 30 80 00       	mov    0x803020,%eax
  80038d:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800393:	83 c0 60             	add    $0x60,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	89 45 b0             	mov    %eax,-0x50(%ebp)
  80039b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80039e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a3:	3d 00 90 80 00       	cmp    $0x809000,%eax
  8003a8:	74 14                	je     8003be <_main+0x386>
  8003aa:	83 ec 04             	sub    $0x4,%esp
  8003ad:	68 d0 1f 80 00       	push   $0x801fd0
  8003b2:	6a 3e                	push   $0x3e
  8003b4:	68 64 1f 80 00       	push   $0x801f64
  8003b9:	e8 51 02 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0x80a000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  8003be:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c3:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003c9:	83 c0 78             	add    $0x78,%eax
  8003cc:	8b 00                	mov    (%eax),%eax
  8003ce:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8003d1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8003d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d9:	3d 00 a0 80 00       	cmp    $0x80a000,%eax
  8003de:	74 14                	je     8003f4 <_main+0x3bc>
  8003e0:	83 ec 04             	sub    $0x4,%esp
  8003e3:	68 d0 1f 80 00       	push   $0x801fd0
  8003e8:	6a 3f                	push   $0x3f
  8003ea:	68 64 1f 80 00       	push   $0x801f64
  8003ef:	e8 1b 02 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x80b000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  8003f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f9:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003ff:	05 90 00 00 00       	add    $0x90,%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800409:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80040c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800411:	3d 00 b0 80 00       	cmp    $0x80b000,%eax
  800416:	74 14                	je     80042c <_main+0x3f4>
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	68 d0 1f 80 00       	push   $0x801fd0
  800420:	6a 40                	push   $0x40
  800422:	68 64 1f 80 00       	push   $0x801f64
  800427:	e8 e3 01 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x800000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  80042c:	a1 20 30 80 00       	mov    0x803020,%eax
  800431:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800437:	05 a8 00 00 00       	add    $0xa8,%eax
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  800441:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800444:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800449:	3d 00 00 80 00       	cmp    $0x800000,%eax
  80044e:	74 14                	je     800464 <_main+0x42c>
  800450:	83 ec 04             	sub    $0x4,%esp
  800453:	68 d0 1f 80 00       	push   $0x801fd0
  800458:	6a 41                	push   $0x41
  80045a:	68 64 1f 80 00       	push   $0x801f64
  80045f:	e8 ab 01 00 00       	call   80060f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0x801000)  panic("Page clock algo failed.. trace it by printing WS before and after page fault");
  800464:	a1 20 30 80 00       	mov    0x803020,%eax
  800469:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80046f:	05 c0 00 00 00       	add    $0xc0,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800479:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80047c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800481:	3d 00 10 80 00       	cmp    $0x801000,%eax
  800486:	74 14                	je     80049c <_main+0x464>
  800488:	83 ec 04             	sub    $0x4,%esp
  80048b:	68 d0 1f 80 00       	push   $0x801fd0
  800490:	6a 42                	push   $0x42
  800492:	68 64 1f 80 00       	push   $0x801f64
  800497:	e8 73 01 00 00       	call   80060f <_panic>

		if(myEnv->page_last_WS_index != 2) panic("wrong PAGE WS pointer location");
  80049c:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a1:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  8004a7:	83 f8 02             	cmp    $0x2,%eax
  8004aa:	74 14                	je     8004c0 <_main+0x488>
  8004ac:	83 ec 04             	sub    $0x4,%esp
  8004af:	68 20 20 80 00       	push   $0x802020
  8004b4:	6a 44                	push   $0x44
  8004b6:	68 64 1f 80 00       	push   $0x801f64
  8004bb:	e8 4f 01 00 00       	call   80060f <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [CLOCK Alg.] is completed successfully.\n");
  8004c0:	83 ec 0c             	sub    $0xc,%esp
  8004c3:	68 40 20 80 00       	push   $0x802040
  8004c8:	e8 f6 03 00 00       	call   8008c3 <cprintf>
  8004cd:	83 c4 10             	add    $0x10,%esp
	return;
  8004d0:	90                   	nop
}
  8004d1:	c9                   	leave  
  8004d2:	c3                   	ret    

008004d3 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8004d9:	e8 3b 15 00 00       	call   801a19 <sys_getenvindex>
  8004de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8004e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004e4:	89 d0                	mov    %edx,%eax
  8004e6:	c1 e0 03             	shl    $0x3,%eax
  8004e9:	01 d0                	add    %edx,%eax
  8004eb:	01 c0                	add    %eax,%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	c1 e0 04             	shl    $0x4,%eax
  8004fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800500:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800505:	a1 20 30 80 00       	mov    0x803020,%eax
  80050a:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800510:	84 c0                	test   %al,%al
  800512:	74 0f                	je     800523 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800514:	a1 20 30 80 00       	mov    0x803020,%eax
  800519:	05 5c 05 00 00       	add    $0x55c,%eax
  80051e:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800523:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800527:	7e 0a                	jle    800533 <libmain+0x60>
		binaryname = argv[0];
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  800533:	83 ec 08             	sub    $0x8,%esp
  800536:	ff 75 0c             	pushl  0xc(%ebp)
  800539:	ff 75 08             	pushl  0x8(%ebp)
  80053c:	e8 f7 fa ff ff       	call   800038 <_main>
  800541:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800544:	e8 dd 12 00 00       	call   801826 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800549:	83 ec 0c             	sub    $0xc,%esp
  80054c:	68 ac 20 80 00       	push   $0x8020ac
  800551:	e8 6d 03 00 00       	call   8008c3 <cprintf>
  800556:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800559:	a1 20 30 80 00       	mov    0x803020,%eax
  80055e:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800564:	a1 20 30 80 00       	mov    0x803020,%eax
  800569:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80056f:	83 ec 04             	sub    $0x4,%esp
  800572:	52                   	push   %edx
  800573:	50                   	push   %eax
  800574:	68 d4 20 80 00       	push   $0x8020d4
  800579:	e8 45 03 00 00       	call   8008c3 <cprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800581:	a1 20 30 80 00       	mov    0x803020,%eax
  800586:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80058c:	a1 20 30 80 00       	mov    0x803020,%eax
  800591:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800597:	a1 20 30 80 00       	mov    0x803020,%eax
  80059c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8005a2:	51                   	push   %ecx
  8005a3:	52                   	push   %edx
  8005a4:	50                   	push   %eax
  8005a5:	68 fc 20 80 00       	push   $0x8020fc
  8005aa:	e8 14 03 00 00       	call   8008c3 <cprintf>
  8005af:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8005b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b7:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8005bd:	83 ec 08             	sub    $0x8,%esp
  8005c0:	50                   	push   %eax
  8005c1:	68 54 21 80 00       	push   $0x802154
  8005c6:	e8 f8 02 00 00       	call   8008c3 <cprintf>
  8005cb:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8005ce:	83 ec 0c             	sub    $0xc,%esp
  8005d1:	68 ac 20 80 00       	push   $0x8020ac
  8005d6:	e8 e8 02 00 00       	call   8008c3 <cprintf>
  8005db:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005de:	e8 5d 12 00 00       	call   801840 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8005e3:	e8 19 00 00 00       	call   800601 <exit>
}
  8005e8:	90                   	nop
  8005e9:	c9                   	leave  
  8005ea:	c3                   	ret    

008005eb <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8005eb:	55                   	push   %ebp
  8005ec:	89 e5                	mov    %esp,%ebp
  8005ee:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8005f1:	83 ec 0c             	sub    $0xc,%esp
  8005f4:	6a 00                	push   $0x0
  8005f6:	e8 ea 13 00 00       	call   8019e5 <sys_destroy_env>
  8005fb:	83 c4 10             	add    $0x10,%esp
}
  8005fe:	90                   	nop
  8005ff:	c9                   	leave  
  800600:	c3                   	ret    

00800601 <exit>:

void
exit(void)
{
  800601:	55                   	push   %ebp
  800602:	89 e5                	mov    %esp,%ebp
  800604:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800607:	e8 3f 14 00 00       	call   801a4b <sys_exit_env>
}
  80060c:	90                   	nop
  80060d:	c9                   	leave  
  80060e:	c3                   	ret    

0080060f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80060f:	55                   	push   %ebp
  800610:	89 e5                	mov    %esp,%ebp
  800612:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800615:	8d 45 10             	lea    0x10(%ebp),%eax
  800618:	83 c0 04             	add    $0x4,%eax
  80061b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80061e:	a1 5c f1 80 00       	mov    0x80f15c,%eax
  800623:	85 c0                	test   %eax,%eax
  800625:	74 16                	je     80063d <_panic+0x2e>
		cprintf("%s: ", argv0);
  800627:	a1 5c f1 80 00       	mov    0x80f15c,%eax
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	50                   	push   %eax
  800630:	68 68 21 80 00       	push   $0x802168
  800635:	e8 89 02 00 00       	call   8008c3 <cprintf>
  80063a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80063d:	a1 08 30 80 00       	mov    0x803008,%eax
  800642:	ff 75 0c             	pushl  0xc(%ebp)
  800645:	ff 75 08             	pushl  0x8(%ebp)
  800648:	50                   	push   %eax
  800649:	68 6d 21 80 00       	push   $0x80216d
  80064e:	e8 70 02 00 00       	call   8008c3 <cprintf>
  800653:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800656:	8b 45 10             	mov    0x10(%ebp),%eax
  800659:	83 ec 08             	sub    $0x8,%esp
  80065c:	ff 75 f4             	pushl  -0xc(%ebp)
  80065f:	50                   	push   %eax
  800660:	e8 f3 01 00 00       	call   800858 <vcprintf>
  800665:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	6a 00                	push   $0x0
  80066d:	68 89 21 80 00       	push   $0x802189
  800672:	e8 e1 01 00 00       	call   800858 <vcprintf>
  800677:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80067a:	e8 82 ff ff ff       	call   800601 <exit>

	// should not return here
	while (1) ;
  80067f:	eb fe                	jmp    80067f <_panic+0x70>

00800681 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800681:	55                   	push   %ebp
  800682:	89 e5                	mov    %esp,%ebp
  800684:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800687:	a1 20 30 80 00       	mov    0x803020,%eax
  80068c:	8b 50 74             	mov    0x74(%eax),%edx
  80068f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800692:	39 c2                	cmp    %eax,%edx
  800694:	74 14                	je     8006aa <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800696:	83 ec 04             	sub    $0x4,%esp
  800699:	68 8c 21 80 00       	push   $0x80218c
  80069e:	6a 26                	push   $0x26
  8006a0:	68 d8 21 80 00       	push   $0x8021d8
  8006a5:	e8 65 ff ff ff       	call   80060f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8006aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8006b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006b8:	e9 c2 00 00 00       	jmp    80077f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8006bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	01 d0                	add    %edx,%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	85 c0                	test   %eax,%eax
  8006d0:	75 08                	jne    8006da <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8006d2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8006d5:	e9 a2 00 00 00       	jmp    80077c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8006da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006e1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8006e8:	eb 69                	jmp    800753 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8006ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8006ef:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006f8:	89 d0                	mov    %edx,%eax
  8006fa:	01 c0                	add    %eax,%eax
  8006fc:	01 d0                	add    %edx,%eax
  8006fe:	c1 e0 03             	shl    $0x3,%eax
  800701:	01 c8                	add    %ecx,%eax
  800703:	8a 40 04             	mov    0x4(%eax),%al
  800706:	84 c0                	test   %al,%al
  800708:	75 46                	jne    800750 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80070a:	a1 20 30 80 00       	mov    0x803020,%eax
  80070f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800715:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800718:	89 d0                	mov    %edx,%eax
  80071a:	01 c0                	add    %eax,%eax
  80071c:	01 d0                	add    %edx,%eax
  80071e:	c1 e0 03             	shl    $0x3,%eax
  800721:	01 c8                	add    %ecx,%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800728:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80072b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800730:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800735:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	01 c8                	add    %ecx,%eax
  800741:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800743:	39 c2                	cmp    %eax,%edx
  800745:	75 09                	jne    800750 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800747:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80074e:	eb 12                	jmp    800762 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800750:	ff 45 e8             	incl   -0x18(%ebp)
  800753:	a1 20 30 80 00       	mov    0x803020,%eax
  800758:	8b 50 74             	mov    0x74(%eax),%edx
  80075b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80075e:	39 c2                	cmp    %eax,%edx
  800760:	77 88                	ja     8006ea <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800762:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800766:	75 14                	jne    80077c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 e4 21 80 00       	push   $0x8021e4
  800770:	6a 3a                	push   $0x3a
  800772:	68 d8 21 80 00       	push   $0x8021d8
  800777:	e8 93 fe ff ff       	call   80060f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80077c:	ff 45 f0             	incl   -0x10(%ebp)
  80077f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800782:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800785:	0f 8c 32 ff ff ff    	jl     8006bd <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80078b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800792:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800799:	eb 26                	jmp    8007c1 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80079b:	a1 20 30 80 00       	mov    0x803020,%eax
  8007a0:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007a9:	89 d0                	mov    %edx,%eax
  8007ab:	01 c0                	add    %eax,%eax
  8007ad:	01 d0                	add    %edx,%eax
  8007af:	c1 e0 03             	shl    $0x3,%eax
  8007b2:	01 c8                	add    %ecx,%eax
  8007b4:	8a 40 04             	mov    0x4(%eax),%al
  8007b7:	3c 01                	cmp    $0x1,%al
  8007b9:	75 03                	jne    8007be <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8007bb:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007be:	ff 45 e0             	incl   -0x20(%ebp)
  8007c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8007c6:	8b 50 74             	mov    0x74(%eax),%edx
  8007c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007cc:	39 c2                	cmp    %eax,%edx
  8007ce:	77 cb                	ja     80079b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8007d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8007d6:	74 14                	je     8007ec <CheckWSWithoutLastIndex+0x16b>
		panic(
  8007d8:	83 ec 04             	sub    $0x4,%esp
  8007db:	68 38 22 80 00       	push   $0x802238
  8007e0:	6a 44                	push   $0x44
  8007e2:	68 d8 21 80 00       	push   $0x8021d8
  8007e7:	e8 23 fe ff ff       	call   80060f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8007ec:	90                   	nop
  8007ed:	c9                   	leave  
  8007ee:	c3                   	ret    

008007ef <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8007ef:	55                   	push   %ebp
  8007f0:	89 e5                	mov    %esp,%ebp
  8007f2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8007f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f8:	8b 00                	mov    (%eax),%eax
  8007fa:	8d 48 01             	lea    0x1(%eax),%ecx
  8007fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800800:	89 0a                	mov    %ecx,(%edx)
  800802:	8b 55 08             	mov    0x8(%ebp),%edx
  800805:	88 d1                	mov    %dl,%cl
  800807:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80080e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800811:	8b 00                	mov    (%eax),%eax
  800813:	3d ff 00 00 00       	cmp    $0xff,%eax
  800818:	75 2c                	jne    800846 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80081a:	a0 24 30 80 00       	mov    0x803024,%al
  80081f:	0f b6 c0             	movzbl %al,%eax
  800822:	8b 55 0c             	mov    0xc(%ebp),%edx
  800825:	8b 12                	mov    (%edx),%edx
  800827:	89 d1                	mov    %edx,%ecx
  800829:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082c:	83 c2 08             	add    $0x8,%edx
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	50                   	push   %eax
  800833:	51                   	push   %ecx
  800834:	52                   	push   %edx
  800835:	e8 3e 0e 00 00       	call   801678 <sys_cputs>
  80083a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80083d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800840:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800846:	8b 45 0c             	mov    0xc(%ebp),%eax
  800849:	8b 40 04             	mov    0x4(%eax),%eax
  80084c:	8d 50 01             	lea    0x1(%eax),%edx
  80084f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800852:	89 50 04             	mov    %edx,0x4(%eax)
}
  800855:	90                   	nop
  800856:	c9                   	leave  
  800857:	c3                   	ret    

00800858 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800861:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800868:	00 00 00 
	b.cnt = 0;
  80086b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800872:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800875:	ff 75 0c             	pushl  0xc(%ebp)
  800878:	ff 75 08             	pushl  0x8(%ebp)
  80087b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800881:	50                   	push   %eax
  800882:	68 ef 07 80 00       	push   $0x8007ef
  800887:	e8 11 02 00 00       	call   800a9d <vprintfmt>
  80088c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80088f:	a0 24 30 80 00       	mov    0x803024,%al
  800894:	0f b6 c0             	movzbl %al,%eax
  800897:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80089d:	83 ec 04             	sub    $0x4,%esp
  8008a0:	50                   	push   %eax
  8008a1:	52                   	push   %edx
  8008a2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008a8:	83 c0 08             	add    $0x8,%eax
  8008ab:	50                   	push   %eax
  8008ac:	e8 c7 0d 00 00       	call   801678 <sys_cputs>
  8008b1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8008b4:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8008bb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8008c1:	c9                   	leave  
  8008c2:	c3                   	ret    

008008c3 <cprintf>:

int cprintf(const char *fmt, ...) {
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008c9:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8008d0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	83 ec 08             	sub    $0x8,%esp
  8008dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8008df:	50                   	push   %eax
  8008e0:	e8 73 ff ff ff       	call   800858 <vcprintf>
  8008e5:	83 c4 10             	add    $0x10,%esp
  8008e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8008eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008ee:	c9                   	leave  
  8008ef:	c3                   	ret    

008008f0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8008f6:	e8 2b 0f 00 00       	call   801826 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8008fb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	ff 75 f4             	pushl  -0xc(%ebp)
  80090a:	50                   	push   %eax
  80090b:	e8 48 ff ff ff       	call   800858 <vcprintf>
  800910:	83 c4 10             	add    $0x10,%esp
  800913:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800916:	e8 25 0f 00 00       	call   801840 <sys_enable_interrupt>
	return cnt;
  80091b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80091e:	c9                   	leave  
  80091f:	c3                   	ret    

00800920 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	53                   	push   %ebx
  800924:	83 ec 14             	sub    $0x14,%esp
  800927:	8b 45 10             	mov    0x10(%ebp),%eax
  80092a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80092d:	8b 45 14             	mov    0x14(%ebp),%eax
  800930:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800933:	8b 45 18             	mov    0x18(%ebp),%eax
  800936:	ba 00 00 00 00       	mov    $0x0,%edx
  80093b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80093e:	77 55                	ja     800995 <printnum+0x75>
  800940:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800943:	72 05                	jb     80094a <printnum+0x2a>
  800945:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800948:	77 4b                	ja     800995 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80094a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80094d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800950:	8b 45 18             	mov    0x18(%ebp),%eax
  800953:	ba 00 00 00 00       	mov    $0x0,%edx
  800958:	52                   	push   %edx
  800959:	50                   	push   %eax
  80095a:	ff 75 f4             	pushl  -0xc(%ebp)
  80095d:	ff 75 f0             	pushl  -0x10(%ebp)
  800960:	e8 47 13 00 00       	call   801cac <__udivdi3>
  800965:	83 c4 10             	add    $0x10,%esp
  800968:	83 ec 04             	sub    $0x4,%esp
  80096b:	ff 75 20             	pushl  0x20(%ebp)
  80096e:	53                   	push   %ebx
  80096f:	ff 75 18             	pushl  0x18(%ebp)
  800972:	52                   	push   %edx
  800973:	50                   	push   %eax
  800974:	ff 75 0c             	pushl  0xc(%ebp)
  800977:	ff 75 08             	pushl  0x8(%ebp)
  80097a:	e8 a1 ff ff ff       	call   800920 <printnum>
  80097f:	83 c4 20             	add    $0x20,%esp
  800982:	eb 1a                	jmp    80099e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	ff 75 0c             	pushl  0xc(%ebp)
  80098a:	ff 75 20             	pushl  0x20(%ebp)
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	ff d0                	call   *%eax
  800992:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800995:	ff 4d 1c             	decl   0x1c(%ebp)
  800998:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80099c:	7f e6                	jg     800984 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80099e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8009a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ac:	53                   	push   %ebx
  8009ad:	51                   	push   %ecx
  8009ae:	52                   	push   %edx
  8009af:	50                   	push   %eax
  8009b0:	e8 07 14 00 00       	call   801dbc <__umoddi3>
  8009b5:	83 c4 10             	add    $0x10,%esp
  8009b8:	05 b4 24 80 00       	add    $0x8024b4,%eax
  8009bd:	8a 00                	mov    (%eax),%al
  8009bf:	0f be c0             	movsbl %al,%eax
  8009c2:	83 ec 08             	sub    $0x8,%esp
  8009c5:	ff 75 0c             	pushl  0xc(%ebp)
  8009c8:	50                   	push   %eax
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	ff d0                	call   *%eax
  8009ce:	83 c4 10             	add    $0x10,%esp
}
  8009d1:	90                   	nop
  8009d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009d5:	c9                   	leave  
  8009d6:	c3                   	ret    

008009d7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009da:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009de:	7e 1c                	jle    8009fc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	8b 00                	mov    (%eax),%eax
  8009e5:	8d 50 08             	lea    0x8(%eax),%edx
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	89 10                	mov    %edx,(%eax)
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	8b 00                	mov    (%eax),%eax
  8009f2:	83 e8 08             	sub    $0x8,%eax
  8009f5:	8b 50 04             	mov    0x4(%eax),%edx
  8009f8:	8b 00                	mov    (%eax),%eax
  8009fa:	eb 40                	jmp    800a3c <getuint+0x65>
	else if (lflag)
  8009fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a00:	74 1e                	je     800a20 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	8b 00                	mov    (%eax),%eax
  800a07:	8d 50 04             	lea    0x4(%eax),%edx
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	89 10                	mov    %edx,(%eax)
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	8b 00                	mov    (%eax),%eax
  800a14:	83 e8 04             	sub    $0x4,%eax
  800a17:	8b 00                	mov    (%eax),%eax
  800a19:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1e:	eb 1c                	jmp    800a3c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8b 00                	mov    (%eax),%eax
  800a25:	8d 50 04             	lea    0x4(%eax),%edx
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	89 10                	mov    %edx,(%eax)
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8b 00                	mov    (%eax),%eax
  800a32:	83 e8 04             	sub    $0x4,%eax
  800a35:	8b 00                	mov    (%eax),%eax
  800a37:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a3c:	5d                   	pop    %ebp
  800a3d:	c3                   	ret    

00800a3e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a41:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a45:	7e 1c                	jle    800a63 <getint+0x25>
		return va_arg(*ap, long long);
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	8b 00                	mov    (%eax),%eax
  800a4c:	8d 50 08             	lea    0x8(%eax),%edx
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	89 10                	mov    %edx,(%eax)
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	8b 00                	mov    (%eax),%eax
  800a59:	83 e8 08             	sub    $0x8,%eax
  800a5c:	8b 50 04             	mov    0x4(%eax),%edx
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	eb 38                	jmp    800a9b <getint+0x5d>
	else if (lflag)
  800a63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a67:	74 1a                	je     800a83 <getint+0x45>
		return va_arg(*ap, long);
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	8d 50 04             	lea    0x4(%eax),%edx
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	89 10                	mov    %edx,(%eax)
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	8b 00                	mov    (%eax),%eax
  800a7b:	83 e8 04             	sub    $0x4,%eax
  800a7e:	8b 00                	mov    (%eax),%eax
  800a80:	99                   	cltd   
  800a81:	eb 18                	jmp    800a9b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	8b 00                	mov    (%eax),%eax
  800a88:	8d 50 04             	lea    0x4(%eax),%edx
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	89 10                	mov    %edx,(%eax)
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8b 00                	mov    (%eax),%eax
  800a95:	83 e8 04             	sub    $0x4,%eax
  800a98:	8b 00                	mov    (%eax),%eax
  800a9a:	99                   	cltd   
}
  800a9b:	5d                   	pop    %ebp
  800a9c:	c3                   	ret    

00800a9d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	56                   	push   %esi
  800aa1:	53                   	push   %ebx
  800aa2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800aa5:	eb 17                	jmp    800abe <vprintfmt+0x21>
			if (ch == '\0')
  800aa7:	85 db                	test   %ebx,%ebx
  800aa9:	0f 84 af 03 00 00    	je     800e5e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800aaf:	83 ec 08             	sub    $0x8,%esp
  800ab2:	ff 75 0c             	pushl  0xc(%ebp)
  800ab5:	53                   	push   %ebx
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	ff d0                	call   *%eax
  800abb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800abe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac1:	8d 50 01             	lea    0x1(%eax),%edx
  800ac4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ac7:	8a 00                	mov    (%eax),%al
  800ac9:	0f b6 d8             	movzbl %al,%ebx
  800acc:	83 fb 25             	cmp    $0x25,%ebx
  800acf:	75 d6                	jne    800aa7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ad1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ad5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800adc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ae3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800aea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800af1:	8b 45 10             	mov    0x10(%ebp),%eax
  800af4:	8d 50 01             	lea    0x1(%eax),%edx
  800af7:	89 55 10             	mov    %edx,0x10(%ebp)
  800afa:	8a 00                	mov    (%eax),%al
  800afc:	0f b6 d8             	movzbl %al,%ebx
  800aff:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b02:	83 f8 55             	cmp    $0x55,%eax
  800b05:	0f 87 2b 03 00 00    	ja     800e36 <vprintfmt+0x399>
  800b0b:	8b 04 85 d8 24 80 00 	mov    0x8024d8(,%eax,4),%eax
  800b12:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b14:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b18:	eb d7                	jmp    800af1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b1a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b1e:	eb d1                	jmp    800af1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800b27:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b2a:	89 d0                	mov    %edx,%eax
  800b2c:	c1 e0 02             	shl    $0x2,%eax
  800b2f:	01 d0                	add    %edx,%eax
  800b31:	01 c0                	add    %eax,%eax
  800b33:	01 d8                	add    %ebx,%eax
  800b35:	83 e8 30             	sub    $0x30,%eax
  800b38:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800b3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3e:	8a 00                	mov    (%eax),%al
  800b40:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b43:	83 fb 2f             	cmp    $0x2f,%ebx
  800b46:	7e 3e                	jle    800b86 <vprintfmt+0xe9>
  800b48:	83 fb 39             	cmp    $0x39,%ebx
  800b4b:	7f 39                	jg     800b86 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b4d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b50:	eb d5                	jmp    800b27 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b52:	8b 45 14             	mov    0x14(%ebp),%eax
  800b55:	83 c0 04             	add    $0x4,%eax
  800b58:	89 45 14             	mov    %eax,0x14(%ebp)
  800b5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5e:	83 e8 04             	sub    $0x4,%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b66:	eb 1f                	jmp    800b87 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6c:	79 83                	jns    800af1 <vprintfmt+0x54>
				width = 0;
  800b6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b75:	e9 77 ff ff ff       	jmp    800af1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b7a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b81:	e9 6b ff ff ff       	jmp    800af1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b86:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b87:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b8b:	0f 89 60 ff ff ff    	jns    800af1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b97:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b9e:	e9 4e ff ff ff       	jmp    800af1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ba3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ba6:	e9 46 ff ff ff       	jmp    800af1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800bab:	8b 45 14             	mov    0x14(%ebp),%eax
  800bae:	83 c0 04             	add    $0x4,%eax
  800bb1:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb7:	83 e8 04             	sub    $0x4,%eax
  800bba:	8b 00                	mov    (%eax),%eax
  800bbc:	83 ec 08             	sub    $0x8,%esp
  800bbf:	ff 75 0c             	pushl  0xc(%ebp)
  800bc2:	50                   	push   %eax
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	ff d0                	call   *%eax
  800bc8:	83 c4 10             	add    $0x10,%esp
			break;
  800bcb:	e9 89 02 00 00       	jmp    800e59 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800bd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd3:	83 c0 04             	add    $0x4,%eax
  800bd6:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bdc:	83 e8 04             	sub    $0x4,%eax
  800bdf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800be1:	85 db                	test   %ebx,%ebx
  800be3:	79 02                	jns    800be7 <vprintfmt+0x14a>
				err = -err;
  800be5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800be7:	83 fb 64             	cmp    $0x64,%ebx
  800bea:	7f 0b                	jg     800bf7 <vprintfmt+0x15a>
  800bec:	8b 34 9d 20 23 80 00 	mov    0x802320(,%ebx,4),%esi
  800bf3:	85 f6                	test   %esi,%esi
  800bf5:	75 19                	jne    800c10 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800bf7:	53                   	push   %ebx
  800bf8:	68 c5 24 80 00       	push   $0x8024c5
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	ff 75 08             	pushl  0x8(%ebp)
  800c03:	e8 5e 02 00 00       	call   800e66 <printfmt>
  800c08:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c0b:	e9 49 02 00 00       	jmp    800e59 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c10:	56                   	push   %esi
  800c11:	68 ce 24 80 00       	push   $0x8024ce
  800c16:	ff 75 0c             	pushl  0xc(%ebp)
  800c19:	ff 75 08             	pushl  0x8(%ebp)
  800c1c:	e8 45 02 00 00       	call   800e66 <printfmt>
  800c21:	83 c4 10             	add    $0x10,%esp
			break;
  800c24:	e9 30 02 00 00       	jmp    800e59 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c29:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2c:	83 c0 04             	add    $0x4,%eax
  800c2f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c32:	8b 45 14             	mov    0x14(%ebp),%eax
  800c35:	83 e8 04             	sub    $0x4,%eax
  800c38:	8b 30                	mov    (%eax),%esi
  800c3a:	85 f6                	test   %esi,%esi
  800c3c:	75 05                	jne    800c43 <vprintfmt+0x1a6>
				p = "(null)";
  800c3e:	be d1 24 80 00       	mov    $0x8024d1,%esi
			if (width > 0 && padc != '-')
  800c43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c47:	7e 6d                	jle    800cb6 <vprintfmt+0x219>
  800c49:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c4d:	74 67                	je     800cb6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c52:	83 ec 08             	sub    $0x8,%esp
  800c55:	50                   	push   %eax
  800c56:	56                   	push   %esi
  800c57:	e8 0c 03 00 00       	call   800f68 <strnlen>
  800c5c:	83 c4 10             	add    $0x10,%esp
  800c5f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c62:	eb 16                	jmp    800c7a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c64:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c68:	83 ec 08             	sub    $0x8,%esp
  800c6b:	ff 75 0c             	pushl  0xc(%ebp)
  800c6e:	50                   	push   %eax
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	ff d0                	call   *%eax
  800c74:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c77:	ff 4d e4             	decl   -0x1c(%ebp)
  800c7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7e:	7f e4                	jg     800c64 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c80:	eb 34                	jmp    800cb6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c82:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c86:	74 1c                	je     800ca4 <vprintfmt+0x207>
  800c88:	83 fb 1f             	cmp    $0x1f,%ebx
  800c8b:	7e 05                	jle    800c92 <vprintfmt+0x1f5>
  800c8d:	83 fb 7e             	cmp    $0x7e,%ebx
  800c90:	7e 12                	jle    800ca4 <vprintfmt+0x207>
					putch('?', putdat);
  800c92:	83 ec 08             	sub    $0x8,%esp
  800c95:	ff 75 0c             	pushl  0xc(%ebp)
  800c98:	6a 3f                	push   $0x3f
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	ff d0                	call   *%eax
  800c9f:	83 c4 10             	add    $0x10,%esp
  800ca2:	eb 0f                	jmp    800cb3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ca4:	83 ec 08             	sub    $0x8,%esp
  800ca7:	ff 75 0c             	pushl  0xc(%ebp)
  800caa:	53                   	push   %ebx
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	ff d0                	call   *%eax
  800cb0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cb3:	ff 4d e4             	decl   -0x1c(%ebp)
  800cb6:	89 f0                	mov    %esi,%eax
  800cb8:	8d 70 01             	lea    0x1(%eax),%esi
  800cbb:	8a 00                	mov    (%eax),%al
  800cbd:	0f be d8             	movsbl %al,%ebx
  800cc0:	85 db                	test   %ebx,%ebx
  800cc2:	74 24                	je     800ce8 <vprintfmt+0x24b>
  800cc4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cc8:	78 b8                	js     800c82 <vprintfmt+0x1e5>
  800cca:	ff 4d e0             	decl   -0x20(%ebp)
  800ccd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cd1:	79 af                	jns    800c82 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cd3:	eb 13                	jmp    800ce8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800cd5:	83 ec 08             	sub    $0x8,%esp
  800cd8:	ff 75 0c             	pushl  0xc(%ebp)
  800cdb:	6a 20                	push   $0x20
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	ff d0                	call   *%eax
  800ce2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ce5:	ff 4d e4             	decl   -0x1c(%ebp)
  800ce8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cec:	7f e7                	jg     800cd5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800cee:	e9 66 01 00 00       	jmp    800e59 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800cf3:	83 ec 08             	sub    $0x8,%esp
  800cf6:	ff 75 e8             	pushl  -0x18(%ebp)
  800cf9:	8d 45 14             	lea    0x14(%ebp),%eax
  800cfc:	50                   	push   %eax
  800cfd:	e8 3c fd ff ff       	call   800a3e <getint>
  800d02:	83 c4 10             	add    $0x10,%esp
  800d05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d08:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d11:	85 d2                	test   %edx,%edx
  800d13:	79 23                	jns    800d38 <vprintfmt+0x29b>
				putch('-', putdat);
  800d15:	83 ec 08             	sub    $0x8,%esp
  800d18:	ff 75 0c             	pushl  0xc(%ebp)
  800d1b:	6a 2d                	push   $0x2d
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	ff d0                	call   *%eax
  800d22:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d2b:	f7 d8                	neg    %eax
  800d2d:	83 d2 00             	adc    $0x0,%edx
  800d30:	f7 da                	neg    %edx
  800d32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d35:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800d38:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d3f:	e9 bc 00 00 00       	jmp    800e00 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d44:	83 ec 08             	sub    $0x8,%esp
  800d47:	ff 75 e8             	pushl  -0x18(%ebp)
  800d4a:	8d 45 14             	lea    0x14(%ebp),%eax
  800d4d:	50                   	push   %eax
  800d4e:	e8 84 fc ff ff       	call   8009d7 <getuint>
  800d53:	83 c4 10             	add    $0x10,%esp
  800d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d59:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d5c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d63:	e9 98 00 00 00       	jmp    800e00 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d68:	83 ec 08             	sub    $0x8,%esp
  800d6b:	ff 75 0c             	pushl  0xc(%ebp)
  800d6e:	6a 58                	push   $0x58
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	ff d0                	call   *%eax
  800d75:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d78:	83 ec 08             	sub    $0x8,%esp
  800d7b:	ff 75 0c             	pushl  0xc(%ebp)
  800d7e:	6a 58                	push   $0x58
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	ff d0                	call   *%eax
  800d85:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d88:	83 ec 08             	sub    $0x8,%esp
  800d8b:	ff 75 0c             	pushl  0xc(%ebp)
  800d8e:	6a 58                	push   $0x58
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	ff d0                	call   *%eax
  800d95:	83 c4 10             	add    $0x10,%esp
			break;
  800d98:	e9 bc 00 00 00       	jmp    800e59 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d9d:	83 ec 08             	sub    $0x8,%esp
  800da0:	ff 75 0c             	pushl  0xc(%ebp)
  800da3:	6a 30                	push   $0x30
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	ff d0                	call   *%eax
  800daa:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800dad:	83 ec 08             	sub    $0x8,%esp
  800db0:	ff 75 0c             	pushl  0xc(%ebp)
  800db3:	6a 78                	push   $0x78
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	ff d0                	call   *%eax
  800dba:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800dbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc0:	83 c0 04             	add    $0x4,%eax
  800dc3:	89 45 14             	mov    %eax,0x14(%ebp)
  800dc6:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc9:	83 e8 04             	sub    $0x4,%eax
  800dcc:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800dd8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ddf:	eb 1f                	jmp    800e00 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800de1:	83 ec 08             	sub    $0x8,%esp
  800de4:	ff 75 e8             	pushl  -0x18(%ebp)
  800de7:	8d 45 14             	lea    0x14(%ebp),%eax
  800dea:	50                   	push   %eax
  800deb:	e8 e7 fb ff ff       	call   8009d7 <getuint>
  800df0:	83 c4 10             	add    $0x10,%esp
  800df3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800df9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e00:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e07:	83 ec 04             	sub    $0x4,%esp
  800e0a:	52                   	push   %edx
  800e0b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e0e:	50                   	push   %eax
  800e0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e12:	ff 75 f0             	pushl  -0x10(%ebp)
  800e15:	ff 75 0c             	pushl  0xc(%ebp)
  800e18:	ff 75 08             	pushl  0x8(%ebp)
  800e1b:	e8 00 fb ff ff       	call   800920 <printnum>
  800e20:	83 c4 20             	add    $0x20,%esp
			break;
  800e23:	eb 34                	jmp    800e59 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e25:	83 ec 08             	sub    $0x8,%esp
  800e28:	ff 75 0c             	pushl  0xc(%ebp)
  800e2b:	53                   	push   %ebx
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	ff d0                	call   *%eax
  800e31:	83 c4 10             	add    $0x10,%esp
			break;
  800e34:	eb 23                	jmp    800e59 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e36:	83 ec 08             	sub    $0x8,%esp
  800e39:	ff 75 0c             	pushl  0xc(%ebp)
  800e3c:	6a 25                	push   $0x25
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	ff d0                	call   *%eax
  800e43:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e46:	ff 4d 10             	decl   0x10(%ebp)
  800e49:	eb 03                	jmp    800e4e <vprintfmt+0x3b1>
  800e4b:	ff 4d 10             	decl   0x10(%ebp)
  800e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e51:	48                   	dec    %eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	3c 25                	cmp    $0x25,%al
  800e56:	75 f3                	jne    800e4b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800e58:	90                   	nop
		}
	}
  800e59:	e9 47 fc ff ff       	jmp    800aa5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e5e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e62:	5b                   	pop    %ebx
  800e63:	5e                   	pop    %esi
  800e64:	5d                   	pop    %ebp
  800e65:	c3                   	ret    

00800e66 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e6c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e6f:	83 c0 04             	add    $0x4,%eax
  800e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e75:	8b 45 10             	mov    0x10(%ebp),%eax
  800e78:	ff 75 f4             	pushl  -0xc(%ebp)
  800e7b:	50                   	push   %eax
  800e7c:	ff 75 0c             	pushl  0xc(%ebp)
  800e7f:	ff 75 08             	pushl  0x8(%ebp)
  800e82:	e8 16 fc ff ff       	call   800a9d <vprintfmt>
  800e87:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e8a:	90                   	nop
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8b 40 08             	mov    0x8(%eax),%eax
  800e96:	8d 50 01             	lea    0x1(%eax),%edx
  800e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea2:	8b 10                	mov    (%eax),%edx
  800ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea7:	8b 40 04             	mov    0x4(%eax),%eax
  800eaa:	39 c2                	cmp    %eax,%edx
  800eac:	73 12                	jae    800ec0 <sprintputch+0x33>
		*b->buf++ = ch;
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8b 00                	mov    (%eax),%eax
  800eb3:	8d 48 01             	lea    0x1(%eax),%ecx
  800eb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb9:	89 0a                	mov    %ecx,(%edx)
  800ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebe:	88 10                	mov    %dl,(%eax)
}
  800ec0:	90                   	nop
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	01 d0                	add    %edx,%eax
  800eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ee4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ee8:	74 06                	je     800ef0 <vsnprintf+0x2d>
  800eea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eee:	7f 07                	jg     800ef7 <vsnprintf+0x34>
		return -E_INVAL;
  800ef0:	b8 03 00 00 00       	mov    $0x3,%eax
  800ef5:	eb 20                	jmp    800f17 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ef7:	ff 75 14             	pushl  0x14(%ebp)
  800efa:	ff 75 10             	pushl  0x10(%ebp)
  800efd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f00:	50                   	push   %eax
  800f01:	68 8d 0e 80 00       	push   $0x800e8d
  800f06:	e8 92 fb ff ff       	call   800a9d <vprintfmt>
  800f0b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f11:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800f17:	c9                   	leave  
  800f18:	c3                   	ret    

00800f19 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f1f:	8d 45 10             	lea    0x10(%ebp),%eax
  800f22:	83 c0 04             	add    $0x4,%eax
  800f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800f28:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f2e:	50                   	push   %eax
  800f2f:	ff 75 0c             	pushl  0xc(%ebp)
  800f32:	ff 75 08             	pushl  0x8(%ebp)
  800f35:	e8 89 ff ff ff       	call   800ec3 <vsnprintf>
  800f3a:	83 c4 10             	add    $0x10,%esp
  800f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f43:	c9                   	leave  
  800f44:	c3                   	ret    

00800f45 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f4b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f52:	eb 06                	jmp    800f5a <strlen+0x15>
		n++;
  800f54:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f57:	ff 45 08             	incl   0x8(%ebp)
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	84 c0                	test   %al,%al
  800f61:	75 f1                	jne    800f54 <strlen+0xf>
		n++;
	return n;
  800f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f75:	eb 09                	jmp    800f80 <strnlen+0x18>
		n++;
  800f77:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f7a:	ff 45 08             	incl   0x8(%ebp)
  800f7d:	ff 4d 0c             	decl   0xc(%ebp)
  800f80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f84:	74 09                	je     800f8f <strnlen+0x27>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	84 c0                	test   %al,%al
  800f8d:	75 e8                	jne    800f77 <strnlen+0xf>
		n++;
	return n;
  800f8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f92:	c9                   	leave  
  800f93:	c3                   	ret    

00800f94 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800fa0:	90                   	nop
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8d 50 01             	lea    0x1(%eax),%edx
  800fa7:	89 55 08             	mov    %edx,0x8(%ebp)
  800faa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fad:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fb0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fb3:	8a 12                	mov    (%edx),%dl
  800fb5:	88 10                	mov    %dl,(%eax)
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	84 c0                	test   %al,%al
  800fbb:	75 e4                	jne    800fa1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fc0:	c9                   	leave  
  800fc1:	c3                   	ret    

00800fc2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800fce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fd5:	eb 1f                	jmp    800ff6 <strncpy+0x34>
		*dst++ = *src;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8d 50 01             	lea    0x1(%eax),%edx
  800fdd:	89 55 08             	mov    %edx,0x8(%ebp)
  800fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe3:	8a 12                	mov    (%edx),%dl
  800fe5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	84 c0                	test   %al,%al
  800fee:	74 03                	je     800ff3 <strncpy+0x31>
			src++;
  800ff0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ff3:	ff 45 fc             	incl   -0x4(%ebp)
  800ff6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ffc:	72 d9                	jb     800fd7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ffe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801001:	c9                   	leave  
  801002:	c3                   	ret    

00801003 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80100f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801013:	74 30                	je     801045 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801015:	eb 16                	jmp    80102d <strlcpy+0x2a>
			*dst++ = *src++;
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8d 50 01             	lea    0x1(%eax),%edx
  80101d:	89 55 08             	mov    %edx,0x8(%ebp)
  801020:	8b 55 0c             	mov    0xc(%ebp),%edx
  801023:	8d 4a 01             	lea    0x1(%edx),%ecx
  801026:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801029:	8a 12                	mov    (%edx),%dl
  80102b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80102d:	ff 4d 10             	decl   0x10(%ebp)
  801030:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801034:	74 09                	je     80103f <strlcpy+0x3c>
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	84 c0                	test   %al,%al
  80103d:	75 d8                	jne    801017 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801045:	8b 55 08             	mov    0x8(%ebp),%edx
  801048:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104b:	29 c2                	sub    %eax,%edx
  80104d:	89 d0                	mov    %edx,%eax
}
  80104f:	c9                   	leave  
  801050:	c3                   	ret    

00801051 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801054:	eb 06                	jmp    80105c <strcmp+0xb>
		p++, q++;
  801056:	ff 45 08             	incl   0x8(%ebp)
  801059:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	84 c0                	test   %al,%al
  801063:	74 0e                	je     801073 <strcmp+0x22>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 10                	mov    (%eax),%dl
  80106a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	38 c2                	cmp    %al,%dl
  801071:	74 e3                	je     801056 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	0f b6 d0             	movzbl %al,%edx
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	0f b6 c0             	movzbl %al,%eax
  801083:	29 c2                	sub    %eax,%edx
  801085:	89 d0                	mov    %edx,%eax
}
  801087:	5d                   	pop    %ebp
  801088:	c3                   	ret    

00801089 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80108c:	eb 09                	jmp    801097 <strncmp+0xe>
		n--, p++, q++;
  80108e:	ff 4d 10             	decl   0x10(%ebp)
  801091:	ff 45 08             	incl   0x8(%ebp)
  801094:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801097:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109b:	74 17                	je     8010b4 <strncmp+0x2b>
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8a 00                	mov    (%eax),%al
  8010a2:	84 c0                	test   %al,%al
  8010a4:	74 0e                	je     8010b4 <strncmp+0x2b>
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	8a 10                	mov    (%eax),%dl
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	38 c2                	cmp    %al,%dl
  8010b2:	74 da                	je     80108e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8010b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b8:	75 07                	jne    8010c1 <strncmp+0x38>
		return 0;
  8010ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8010bf:	eb 14                	jmp    8010d5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	0f b6 d0             	movzbl %al,%edx
  8010c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	0f b6 c0             	movzbl %al,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
}
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    

008010d7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	83 ec 04             	sub    $0x4,%esp
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010e3:	eb 12                	jmp    8010f7 <strchr+0x20>
		if (*s == c)
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010ed:	75 05                	jne    8010f4 <strchr+0x1d>
			return (char *) s;
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	eb 11                	jmp    801105 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010f4:	ff 45 08             	incl   0x8(%ebp)
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	84 c0                	test   %al,%al
  8010fe:	75 e5                	jne    8010e5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801100:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	83 ec 04             	sub    $0x4,%esp
  80110d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801110:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801113:	eb 0d                	jmp    801122 <strfind+0x1b>
		if (*s == c)
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80111d:	74 0e                	je     80112d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80111f:	ff 45 08             	incl   0x8(%ebp)
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	8a 00                	mov    (%eax),%al
  801127:	84 c0                	test   %al,%al
  801129:	75 ea                	jne    801115 <strfind+0xe>
  80112b:	eb 01                	jmp    80112e <strfind+0x27>
		if (*s == c)
			break;
  80112d:	90                   	nop
	return (char *) s;
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801131:	c9                   	leave  
  801132:	c3                   	ret    

00801133 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80113f:	8b 45 10             	mov    0x10(%ebp),%eax
  801142:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801145:	eb 0e                	jmp    801155 <memset+0x22>
		*p++ = c;
  801147:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114a:	8d 50 01             	lea    0x1(%eax),%edx
  80114d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801150:	8b 55 0c             	mov    0xc(%ebp),%edx
  801153:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801155:	ff 4d f8             	decl   -0x8(%ebp)
  801158:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80115c:	79 e9                	jns    801147 <memset+0x14>
		*p++ = c;

	return v;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801169:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801175:	eb 16                	jmp    80118d <memcpy+0x2a>
		*d++ = *s++;
  801177:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117a:	8d 50 01             	lea    0x1(%eax),%edx
  80117d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801180:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801183:	8d 4a 01             	lea    0x1(%edx),%ecx
  801186:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801189:	8a 12                	mov    (%edx),%dl
  80118b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80118d:	8b 45 10             	mov    0x10(%ebp),%eax
  801190:	8d 50 ff             	lea    -0x1(%eax),%edx
  801193:	89 55 10             	mov    %edx,0x10(%ebp)
  801196:	85 c0                	test   %eax,%eax
  801198:	75 dd                	jne    801177 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80119d:	c9                   	leave  
  80119e:	c3                   	ret    

0080119f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8011a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8011b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011b7:	73 50                	jae    801209 <memmove+0x6a>
  8011b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bf:	01 d0                	add    %edx,%eax
  8011c1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011c4:	76 43                	jbe    801209 <memmove+0x6a>
		s += n;
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8011cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cf:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011d2:	eb 10                	jmp    8011e4 <memmove+0x45>
			*--d = *--s;
  8011d4:	ff 4d f8             	decl   -0x8(%ebp)
  8011d7:	ff 4d fc             	decl   -0x4(%ebp)
  8011da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011dd:	8a 10                	mov    (%eax),%dl
  8011df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	75 e3                	jne    8011d4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011f1:	eb 23                	jmp    801216 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f6:	8d 50 01             	lea    0x1(%eax),%edx
  8011f9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  801202:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801205:	8a 12                	mov    (%edx),%dl
  801207:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801209:	8b 45 10             	mov    0x10(%ebp),%eax
  80120c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80120f:	89 55 10             	mov    %edx,0x10(%ebp)
  801212:	85 c0                	test   %eax,%eax
  801214:	75 dd                	jne    8011f3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80122d:	eb 2a                	jmp    801259 <memcmp+0x3e>
		if (*s1 != *s2)
  80122f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801232:	8a 10                	mov    (%eax),%dl
  801234:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	38 c2                	cmp    %al,%dl
  80123b:	74 16                	je     801253 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80123d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801240:	8a 00                	mov    (%eax),%al
  801242:	0f b6 d0             	movzbl %al,%edx
  801245:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	0f b6 c0             	movzbl %al,%eax
  80124d:	29 c2                	sub    %eax,%edx
  80124f:	89 d0                	mov    %edx,%eax
  801251:	eb 18                	jmp    80126b <memcmp+0x50>
		s1++, s2++;
  801253:	ff 45 fc             	incl   -0x4(%ebp)
  801256:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801259:	8b 45 10             	mov    0x10(%ebp),%eax
  80125c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80125f:	89 55 10             	mov    %edx,0x10(%ebp)
  801262:	85 c0                	test   %eax,%eax
  801264:	75 c9                	jne    80122f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801266:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    

0080126d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801273:	8b 55 08             	mov    0x8(%ebp),%edx
  801276:	8b 45 10             	mov    0x10(%ebp),%eax
  801279:	01 d0                	add    %edx,%eax
  80127b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80127e:	eb 15                	jmp    801295 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	0f b6 d0             	movzbl %al,%edx
  801288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128b:	0f b6 c0             	movzbl %al,%eax
  80128e:	39 c2                	cmp    %eax,%edx
  801290:	74 0d                	je     80129f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801292:	ff 45 08             	incl   0x8(%ebp)
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80129b:	72 e3                	jb     801280 <memfind+0x13>
  80129d:	eb 01                	jmp    8012a0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80129f:	90                   	nop
	return (void *) s;
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8012ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8012b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012b9:	eb 03                	jmp    8012be <strtol+0x19>
		s++;
  8012bb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	8a 00                	mov    (%eax),%al
  8012c3:	3c 20                	cmp    $0x20,%al
  8012c5:	74 f4                	je     8012bb <strtol+0x16>
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	3c 09                	cmp    $0x9,%al
  8012ce:	74 eb                	je     8012bb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	3c 2b                	cmp    $0x2b,%al
  8012d7:	75 05                	jne    8012de <strtol+0x39>
		s++;
  8012d9:	ff 45 08             	incl   0x8(%ebp)
  8012dc:	eb 13                	jmp    8012f1 <strtol+0x4c>
	else if (*s == '-')
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	3c 2d                	cmp    $0x2d,%al
  8012e5:	75 0a                	jne    8012f1 <strtol+0x4c>
		s++, neg = 1;
  8012e7:	ff 45 08             	incl   0x8(%ebp)
  8012ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f5:	74 06                	je     8012fd <strtol+0x58>
  8012f7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012fb:	75 20                	jne    80131d <strtol+0x78>
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	3c 30                	cmp    $0x30,%al
  801304:	75 17                	jne    80131d <strtol+0x78>
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	40                   	inc    %eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	3c 78                	cmp    $0x78,%al
  80130e:	75 0d                	jne    80131d <strtol+0x78>
		s += 2, base = 16;
  801310:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801314:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80131b:	eb 28                	jmp    801345 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80131d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801321:	75 15                	jne    801338 <strtol+0x93>
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	8a 00                	mov    (%eax),%al
  801328:	3c 30                	cmp    $0x30,%al
  80132a:	75 0c                	jne    801338 <strtol+0x93>
		s++, base = 8;
  80132c:	ff 45 08             	incl   0x8(%ebp)
  80132f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801336:	eb 0d                	jmp    801345 <strtol+0xa0>
	else if (base == 0)
  801338:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80133c:	75 07                	jne    801345 <strtol+0xa0>
		base = 10;
  80133e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
  801348:	8a 00                	mov    (%eax),%al
  80134a:	3c 2f                	cmp    $0x2f,%al
  80134c:	7e 19                	jle    801367 <strtol+0xc2>
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	3c 39                	cmp    $0x39,%al
  801355:	7f 10                	jg     801367 <strtol+0xc2>
			dig = *s - '0';
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	0f be c0             	movsbl %al,%eax
  80135f:	83 e8 30             	sub    $0x30,%eax
  801362:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801365:	eb 42                	jmp    8013a9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	3c 60                	cmp    $0x60,%al
  80136e:	7e 19                	jle    801389 <strtol+0xe4>
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	3c 7a                	cmp    $0x7a,%al
  801377:	7f 10                	jg     801389 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	0f be c0             	movsbl %al,%eax
  801381:	83 e8 57             	sub    $0x57,%eax
  801384:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801387:	eb 20                	jmp    8013a9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	3c 40                	cmp    $0x40,%al
  801390:	7e 39                	jle    8013cb <strtol+0x126>
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	3c 5a                	cmp    $0x5a,%al
  801399:	7f 30                	jg     8013cb <strtol+0x126>
			dig = *s - 'A' + 10;
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	8a 00                	mov    (%eax),%al
  8013a0:	0f be c0             	movsbl %al,%eax
  8013a3:	83 e8 37             	sub    $0x37,%eax
  8013a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8013a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ac:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013af:	7d 19                	jge    8013ca <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8013b1:	ff 45 08             	incl   0x8(%ebp)
  8013b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8013bb:	89 c2                	mov    %eax,%edx
  8013bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c0:	01 d0                	add    %edx,%eax
  8013c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8013c5:	e9 7b ff ff ff       	jmp    801345 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8013ca:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8013cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013cf:	74 08                	je     8013d9 <strtol+0x134>
		*endptr = (char *) s;
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013dd:	74 07                	je     8013e6 <strtol+0x141>
  8013df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e2:	f7 d8                	neg    %eax
  8013e4:	eb 03                	jmp    8013e9 <strtol+0x144>
  8013e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <ltostr>:

void
ltostr(long value, char *str)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013f8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801403:	79 13                	jns    801418 <ltostr+0x2d>
	{
		neg = 1;
  801405:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80140c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801412:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801415:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801420:	99                   	cltd   
  801421:	f7 f9                	idiv   %ecx
  801423:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801426:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801429:	8d 50 01             	lea    0x1(%eax),%edx
  80142c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80142f:	89 c2                	mov    %eax,%edx
  801431:	8b 45 0c             	mov    0xc(%ebp),%eax
  801434:	01 d0                	add    %edx,%eax
  801436:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801439:	83 c2 30             	add    $0x30,%edx
  80143c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80143e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801441:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801446:	f7 e9                	imul   %ecx
  801448:	c1 fa 02             	sar    $0x2,%edx
  80144b:	89 c8                	mov    %ecx,%eax
  80144d:	c1 f8 1f             	sar    $0x1f,%eax
  801450:	29 c2                	sub    %eax,%edx
  801452:	89 d0                	mov    %edx,%eax
  801454:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801457:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80145a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80145f:	f7 e9                	imul   %ecx
  801461:	c1 fa 02             	sar    $0x2,%edx
  801464:	89 c8                	mov    %ecx,%eax
  801466:	c1 f8 1f             	sar    $0x1f,%eax
  801469:	29 c2                	sub    %eax,%edx
  80146b:	89 d0                	mov    %edx,%eax
  80146d:	c1 e0 02             	shl    $0x2,%eax
  801470:	01 d0                	add    %edx,%eax
  801472:	01 c0                	add    %eax,%eax
  801474:	29 c1                	sub    %eax,%ecx
  801476:	89 ca                	mov    %ecx,%edx
  801478:	85 d2                	test   %edx,%edx
  80147a:	75 9c                	jne    801418 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80147c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801483:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801486:	48                   	dec    %eax
  801487:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80148a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80148e:	74 3d                	je     8014cd <ltostr+0xe2>
		start = 1 ;
  801490:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801497:	eb 34                	jmp    8014cd <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801499:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149f:	01 d0                	add    %edx,%eax
  8014a1:	8a 00                	mov    (%eax),%al
  8014a3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8014a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	01 c2                	add    %eax,%edx
  8014ae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8014b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b4:	01 c8                	add    %ecx,%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8014ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c0:	01 c2                	add    %eax,%edx
  8014c2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8014c5:	88 02                	mov    %al,(%edx)
		start++ ;
  8014c7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8014ca:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8014cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014d3:	7c c4                	jl     801499 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8014d5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	01 d0                	add    %edx,%eax
  8014dd:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8014e0:	90                   	nop
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8014e9:	ff 75 08             	pushl  0x8(%ebp)
  8014ec:	e8 54 fa ff ff       	call   800f45 <strlen>
  8014f1:	83 c4 04             	add    $0x4,%esp
  8014f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014f7:	ff 75 0c             	pushl  0xc(%ebp)
  8014fa:	e8 46 fa ff ff       	call   800f45 <strlen>
  8014ff:	83 c4 04             	add    $0x4,%esp
  801502:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801505:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80150c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801513:	eb 17                	jmp    80152c <strcconcat+0x49>
		final[s] = str1[s] ;
  801515:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801518:	8b 45 10             	mov    0x10(%ebp),%eax
  80151b:	01 c2                	add    %eax,%edx
  80151d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	01 c8                	add    %ecx,%eax
  801525:	8a 00                	mov    (%eax),%al
  801527:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801529:	ff 45 fc             	incl   -0x4(%ebp)
  80152c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801532:	7c e1                	jl     801515 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801534:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80153b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801542:	eb 1f                	jmp    801563 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801544:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801547:	8d 50 01             	lea    0x1(%eax),%edx
  80154a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80154d:	89 c2                	mov    %eax,%edx
  80154f:	8b 45 10             	mov    0x10(%ebp),%eax
  801552:	01 c2                	add    %eax,%edx
  801554:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801557:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155a:	01 c8                	add    %ecx,%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801560:	ff 45 f8             	incl   -0x8(%ebp)
  801563:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801566:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801569:	7c d9                	jl     801544 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80156b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80156e:	8b 45 10             	mov    0x10(%ebp),%eax
  801571:	01 d0                	add    %edx,%eax
  801573:	c6 00 00             	movb   $0x0,(%eax)
}
  801576:	90                   	nop
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80157c:	8b 45 14             	mov    0x14(%ebp),%eax
  80157f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801585:	8b 45 14             	mov    0x14(%ebp),%eax
  801588:	8b 00                	mov    (%eax),%eax
  80158a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801591:	8b 45 10             	mov    0x10(%ebp),%eax
  801594:	01 d0                	add    %edx,%eax
  801596:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80159c:	eb 0c                	jmp    8015aa <strsplit+0x31>
			*string++ = 0;
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	8d 50 01             	lea    0x1(%eax),%edx
  8015a4:	89 55 08             	mov    %edx,0x8(%ebp)
  8015a7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	8a 00                	mov    (%eax),%al
  8015af:	84 c0                	test   %al,%al
  8015b1:	74 18                	je     8015cb <strsplit+0x52>
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	8a 00                	mov    (%eax),%al
  8015b8:	0f be c0             	movsbl %al,%eax
  8015bb:	50                   	push   %eax
  8015bc:	ff 75 0c             	pushl  0xc(%ebp)
  8015bf:	e8 13 fb ff ff       	call   8010d7 <strchr>
  8015c4:	83 c4 08             	add    $0x8,%esp
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	75 d3                	jne    80159e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	8a 00                	mov    (%eax),%al
  8015d0:	84 c0                	test   %al,%al
  8015d2:	74 5a                	je     80162e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8015d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d7:	8b 00                	mov    (%eax),%eax
  8015d9:	83 f8 0f             	cmp    $0xf,%eax
  8015dc:	75 07                	jne    8015e5 <strsplit+0x6c>
		{
			return 0;
  8015de:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e3:	eb 66                	jmp    80164b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8015e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e8:	8b 00                	mov    (%eax),%eax
  8015ea:	8d 48 01             	lea    0x1(%eax),%ecx
  8015ed:	8b 55 14             	mov    0x14(%ebp),%edx
  8015f0:	89 0a                	mov    %ecx,(%edx)
  8015f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fc:	01 c2                	add    %eax,%edx
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801603:	eb 03                	jmp    801608 <strsplit+0x8f>
			string++;
  801605:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	84 c0                	test   %al,%al
  80160f:	74 8b                	je     80159c <strsplit+0x23>
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	8a 00                	mov    (%eax),%al
  801616:	0f be c0             	movsbl %al,%eax
  801619:	50                   	push   %eax
  80161a:	ff 75 0c             	pushl  0xc(%ebp)
  80161d:	e8 b5 fa ff ff       	call   8010d7 <strchr>
  801622:	83 c4 08             	add    $0x8,%esp
  801625:	85 c0                	test   %eax,%eax
  801627:	74 dc                	je     801605 <strsplit+0x8c>
			string++;
	}
  801629:	e9 6e ff ff ff       	jmp    80159c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80162e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80162f:	8b 45 14             	mov    0x14(%ebp),%eax
  801632:	8b 00                	mov    (%eax),%eax
  801634:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80163b:	8b 45 10             	mov    0x10(%ebp),%eax
  80163e:	01 d0                	add    %edx,%eax
  801640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801646:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	57                   	push   %edi
  801651:	56                   	push   %esi
  801652:	53                   	push   %ebx
  801653:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80165f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801662:	8b 7d 18             	mov    0x18(%ebp),%edi
  801665:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801668:	cd 30                	int    $0x30
  80166a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80166d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	5b                   	pop    %ebx
  801674:	5e                   	pop    %esi
  801675:	5f                   	pop    %edi
  801676:	5d                   	pop    %ebp
  801677:	c3                   	ret    

00801678 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	83 ec 04             	sub    $0x4,%esp
  80167e:	8b 45 10             	mov    0x10(%ebp),%eax
  801681:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801684:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	52                   	push   %edx
  801690:	ff 75 0c             	pushl  0xc(%ebp)
  801693:	50                   	push   %eax
  801694:	6a 00                	push   $0x0
  801696:	e8 b2 ff ff ff       	call   80164d <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	90                   	nop
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 01                	push   $0x1
  8016b0:	e8 98 ff ff ff       	call   80164d <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	52                   	push   %edx
  8016ca:	50                   	push   %eax
  8016cb:	6a 05                	push   $0x5
  8016cd:	e8 7b ff ff ff       	call   80164d <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	56                   	push   %esi
  8016db:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016dc:	8b 75 18             	mov    0x18(%ebp),%esi
  8016df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	56                   	push   %esi
  8016ec:	53                   	push   %ebx
  8016ed:	51                   	push   %ecx
  8016ee:	52                   	push   %edx
  8016ef:	50                   	push   %eax
  8016f0:	6a 06                	push   $0x6
  8016f2:	e8 56 ff ff ff       	call   80164d <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016fd:	5b                   	pop    %ebx
  8016fe:	5e                   	pop    %esi
  8016ff:	5d                   	pop    %ebp
  801700:	c3                   	ret    

00801701 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801704:	8b 55 0c             	mov    0xc(%ebp),%edx
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	52                   	push   %edx
  801711:	50                   	push   %eax
  801712:	6a 07                	push   $0x7
  801714:	e8 34 ff ff ff       	call   80164d <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	ff 75 0c             	pushl  0xc(%ebp)
  80172a:	ff 75 08             	pushl  0x8(%ebp)
  80172d:	6a 08                	push   $0x8
  80172f:	e8 19 ff ff ff       	call   80164d <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 09                	push   $0x9
  801748:	e8 00 ff ff ff       	call   80164d <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 0a                	push   $0xa
  801761:	e8 e7 fe ff ff       	call   80164d <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 0b                	push   $0xb
  80177a:	e8 ce fe ff ff       	call   80164d <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	ff 75 0c             	pushl  0xc(%ebp)
  801790:	ff 75 08             	pushl  0x8(%ebp)
  801793:	6a 0f                	push   $0xf
  801795:	e8 b3 fe ff ff       	call   80164d <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
	return;
  80179d:	90                   	nop
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ac:	ff 75 08             	pushl  0x8(%ebp)
  8017af:	6a 10                	push   $0x10
  8017b1:	e8 97 fe ff ff       	call   80164d <syscall>
  8017b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b9:	90                   	nop
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	ff 75 10             	pushl  0x10(%ebp)
  8017c6:	ff 75 0c             	pushl  0xc(%ebp)
  8017c9:	ff 75 08             	pushl  0x8(%ebp)
  8017cc:	6a 11                	push   $0x11
  8017ce:	e8 7a fe ff ff       	call   80164d <syscall>
  8017d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d6:	90                   	nop
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 0c                	push   $0xc
  8017e8:	e8 60 fe ff ff       	call   80164d <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	ff 75 08             	pushl  0x8(%ebp)
  801800:	6a 0d                	push   $0xd
  801802:	e8 46 fe ff ff       	call   80164d <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 0e                	push   $0xe
  80181b:	e8 2d fe ff ff       	call   80164d <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	90                   	nop
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 13                	push   $0x13
  801835:	e8 13 fe ff ff       	call   80164d <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	90                   	nop
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 14                	push   $0x14
  80184f:	e8 f9 fd ff ff       	call   80164d <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	90                   	nop
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_cputc>:


void
sys_cputc(const char c)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 04             	sub    $0x4,%esp
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801866:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	50                   	push   %eax
  801873:	6a 15                	push   $0x15
  801875:	e8 d3 fd ff ff       	call   80164d <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
}
  80187d:	90                   	nop
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 16                	push   $0x16
  80188f:	e8 b9 fd ff ff       	call   80164d <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	90                   	nop
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	ff 75 0c             	pushl  0xc(%ebp)
  8018a9:	50                   	push   %eax
  8018aa:	6a 17                	push   $0x17
  8018ac:	e8 9c fd ff ff       	call   80164d <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	52                   	push   %edx
  8018c6:	50                   	push   %eax
  8018c7:	6a 1a                	push   $0x1a
  8018c9:	e8 7f fd ff ff       	call   80164d <syscall>
  8018ce:	83 c4 18             	add    $0x18,%esp
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	52                   	push   %edx
  8018e3:	50                   	push   %eax
  8018e4:	6a 18                	push   $0x18
  8018e6:	e8 62 fd ff ff       	call   80164d <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	90                   	nop
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	52                   	push   %edx
  801901:	50                   	push   %eax
  801902:	6a 19                	push   $0x19
  801904:	e8 44 fd ff ff       	call   80164d <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	90                   	nop
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 04             	sub    $0x4,%esp
  801915:	8b 45 10             	mov    0x10(%ebp),%eax
  801918:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80191b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80191e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	6a 00                	push   $0x0
  801927:	51                   	push   %ecx
  801928:	52                   	push   %edx
  801929:	ff 75 0c             	pushl  0xc(%ebp)
  80192c:	50                   	push   %eax
  80192d:	6a 1b                	push   $0x1b
  80192f:	e8 19 fd ff ff       	call   80164d <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80193c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	52                   	push   %edx
  801949:	50                   	push   %eax
  80194a:	6a 1c                	push   $0x1c
  80194c:	e8 fc fc ff ff       	call   80164d <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801959:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80195c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	51                   	push   %ecx
  801967:	52                   	push   %edx
  801968:	50                   	push   %eax
  801969:	6a 1d                	push   $0x1d
  80196b:	e8 dd fc ff ff       	call   80164d <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	52                   	push   %edx
  801985:	50                   	push   %eax
  801986:	6a 1e                	push   $0x1e
  801988:	e8 c0 fc ff ff       	call   80164d <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 1f                	push   $0x1f
  8019a1:	e8 a7 fc ff ff       	call   80164d <syscall>
  8019a6:	83 c4 18             	add    $0x18,%esp
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	6a 00                	push   $0x0
  8019b3:	ff 75 14             	pushl  0x14(%ebp)
  8019b6:	ff 75 10             	pushl  0x10(%ebp)
  8019b9:	ff 75 0c             	pushl  0xc(%ebp)
  8019bc:	50                   	push   %eax
  8019bd:	6a 20                	push   $0x20
  8019bf:	e8 89 fc ff ff       	call   80164d <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	50                   	push   %eax
  8019d8:	6a 21                	push   $0x21
  8019da:	e8 6e fc ff ff       	call   80164d <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	90                   	nop
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	50                   	push   %eax
  8019f4:	6a 22                	push   $0x22
  8019f6:	e8 52 fc ff ff       	call   80164d <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 02                	push   $0x2
  801a0f:	e8 39 fc ff ff       	call   80164d <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 03                	push   $0x3
  801a28:	e8 20 fc ff ff       	call   80164d <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 04                	push   $0x4
  801a41:	e8 07 fc ff ff       	call   80164d <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_exit_env>:


void sys_exit_env(void)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 23                	push   $0x23
  801a5a:	e8 ee fb ff ff       	call   80164d <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	90                   	nop
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a6b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a6e:	8d 50 04             	lea    0x4(%eax),%edx
  801a71:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	52                   	push   %edx
  801a7b:	50                   	push   %eax
  801a7c:	6a 24                	push   $0x24
  801a7e:	e8 ca fb ff ff       	call   80164d <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
	return result;
  801a86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a8c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a8f:	89 01                	mov    %eax,(%ecx)
  801a91:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	c9                   	leave  
  801a98:	c2 04 00             	ret    $0x4

00801a9b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	ff 75 10             	pushl  0x10(%ebp)
  801aa5:	ff 75 0c             	pushl  0xc(%ebp)
  801aa8:	ff 75 08             	pushl  0x8(%ebp)
  801aab:	6a 12                	push   $0x12
  801aad:	e8 9b fb ff ff       	call   80164d <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab5:	90                   	nop
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 25                	push   $0x25
  801ac7:	e8 81 fb ff ff       	call   80164d <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 04             	sub    $0x4,%esp
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801add:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	50                   	push   %eax
  801aea:	6a 26                	push   $0x26
  801aec:	e8 5c fb ff ff       	call   80164d <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
	return ;
  801af4:	90                   	nop
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <rsttst>:
void rsttst()
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 28                	push   $0x28
  801b06:	e8 42 fb ff ff       	call   80164d <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0e:	90                   	nop
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 04             	sub    $0x4,%esp
  801b17:	8b 45 14             	mov    0x14(%ebp),%eax
  801b1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b1d:	8b 55 18             	mov    0x18(%ebp),%edx
  801b20:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b24:	52                   	push   %edx
  801b25:	50                   	push   %eax
  801b26:	ff 75 10             	pushl  0x10(%ebp)
  801b29:	ff 75 0c             	pushl  0xc(%ebp)
  801b2c:	ff 75 08             	pushl  0x8(%ebp)
  801b2f:	6a 27                	push   $0x27
  801b31:	e8 17 fb ff ff       	call   80164d <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
	return ;
  801b39:	90                   	nop
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <chktst>:
void chktst(uint32 n)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	ff 75 08             	pushl  0x8(%ebp)
  801b4a:	6a 29                	push   $0x29
  801b4c:	e8 fc fa ff ff       	call   80164d <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
	return ;
  801b54:	90                   	nop
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <inctst>:

void inctst()
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 2a                	push   $0x2a
  801b66:	e8 e2 fa ff ff       	call   80164d <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6e:	90                   	nop
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <gettst>:
uint32 gettst()
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 2b                	push   $0x2b
  801b80:	e8 c8 fa ff ff       	call   80164d <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 2c                	push   $0x2c
  801b9c:	e8 ac fa ff ff       	call   80164d <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
  801ba4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ba7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bab:	75 07                	jne    801bb4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bad:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb2:	eb 05                	jmp    801bb9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 2c                	push   $0x2c
  801bcd:	e8 7b fa ff ff       	call   80164d <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
  801bd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bd8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bdc:	75 07                	jne    801be5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bde:	b8 01 00 00 00       	mov    $0x1,%eax
  801be3:	eb 05                	jmp    801bea <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 2c                	push   $0x2c
  801bfe:	e8 4a fa ff ff       	call   80164d <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
  801c06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c09:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c0d:	75 07                	jne    801c16 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c0f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c14:	eb 05                	jmp    801c1b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 2c                	push   $0x2c
  801c2f:	e8 19 fa ff ff       	call   80164d <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
  801c37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c3a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c3e:	75 07                	jne    801c47 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c40:	b8 01 00 00 00       	mov    $0x1,%eax
  801c45:	eb 05                	jmp    801c4c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	ff 75 08             	pushl  0x8(%ebp)
  801c5c:	6a 2d                	push   $0x2d
  801c5e:	e8 ea f9 ff ff       	call   80164d <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
	return ;
  801c66:	90                   	nop
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c6d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c70:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	6a 00                	push   $0x0
  801c7b:	53                   	push   %ebx
  801c7c:	51                   	push   %ecx
  801c7d:	52                   	push   %edx
  801c7e:	50                   	push   %eax
  801c7f:	6a 2e                	push   $0x2e
  801c81:	e8 c7 f9 ff ff       	call   80164d <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
}
  801c89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	52                   	push   %edx
  801c9e:	50                   	push   %eax
  801c9f:	6a 2f                	push   $0x2f
  801ca1:	e8 a7 f9 ff ff       	call   80164d <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    
  801cab:	90                   	nop

00801cac <__udivdi3>:
  801cac:	55                   	push   %ebp
  801cad:	57                   	push   %edi
  801cae:	56                   	push   %esi
  801caf:	53                   	push   %ebx
  801cb0:	83 ec 1c             	sub    $0x1c,%esp
  801cb3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801cb7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cbf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cc3:	89 ca                	mov    %ecx,%edx
  801cc5:	89 f8                	mov    %edi,%eax
  801cc7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ccb:	85 f6                	test   %esi,%esi
  801ccd:	75 2d                	jne    801cfc <__udivdi3+0x50>
  801ccf:	39 cf                	cmp    %ecx,%edi
  801cd1:	77 65                	ja     801d38 <__udivdi3+0x8c>
  801cd3:	89 fd                	mov    %edi,%ebp
  801cd5:	85 ff                	test   %edi,%edi
  801cd7:	75 0b                	jne    801ce4 <__udivdi3+0x38>
  801cd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cde:	31 d2                	xor    %edx,%edx
  801ce0:	f7 f7                	div    %edi
  801ce2:	89 c5                	mov    %eax,%ebp
  801ce4:	31 d2                	xor    %edx,%edx
  801ce6:	89 c8                	mov    %ecx,%eax
  801ce8:	f7 f5                	div    %ebp
  801cea:	89 c1                	mov    %eax,%ecx
  801cec:	89 d8                	mov    %ebx,%eax
  801cee:	f7 f5                	div    %ebp
  801cf0:	89 cf                	mov    %ecx,%edi
  801cf2:	89 fa                	mov    %edi,%edx
  801cf4:	83 c4 1c             	add    $0x1c,%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5f                   	pop    %edi
  801cfa:	5d                   	pop    %ebp
  801cfb:	c3                   	ret    
  801cfc:	39 ce                	cmp    %ecx,%esi
  801cfe:	77 28                	ja     801d28 <__udivdi3+0x7c>
  801d00:	0f bd fe             	bsr    %esi,%edi
  801d03:	83 f7 1f             	xor    $0x1f,%edi
  801d06:	75 40                	jne    801d48 <__udivdi3+0x9c>
  801d08:	39 ce                	cmp    %ecx,%esi
  801d0a:	72 0a                	jb     801d16 <__udivdi3+0x6a>
  801d0c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d10:	0f 87 9e 00 00 00    	ja     801db4 <__udivdi3+0x108>
  801d16:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1b:	89 fa                	mov    %edi,%edx
  801d1d:	83 c4 1c             	add    $0x1c,%esp
  801d20:	5b                   	pop    %ebx
  801d21:	5e                   	pop    %esi
  801d22:	5f                   	pop    %edi
  801d23:	5d                   	pop    %ebp
  801d24:	c3                   	ret    
  801d25:	8d 76 00             	lea    0x0(%esi),%esi
  801d28:	31 ff                	xor    %edi,%edi
  801d2a:	31 c0                	xor    %eax,%eax
  801d2c:	89 fa                	mov    %edi,%edx
  801d2e:	83 c4 1c             	add    $0x1c,%esp
  801d31:	5b                   	pop    %ebx
  801d32:	5e                   	pop    %esi
  801d33:	5f                   	pop    %edi
  801d34:	5d                   	pop    %ebp
  801d35:	c3                   	ret    
  801d36:	66 90                	xchg   %ax,%ax
  801d38:	89 d8                	mov    %ebx,%eax
  801d3a:	f7 f7                	div    %edi
  801d3c:	31 ff                	xor    %edi,%edi
  801d3e:	89 fa                	mov    %edi,%edx
  801d40:	83 c4 1c             	add    $0x1c,%esp
  801d43:	5b                   	pop    %ebx
  801d44:	5e                   	pop    %esi
  801d45:	5f                   	pop    %edi
  801d46:	5d                   	pop    %ebp
  801d47:	c3                   	ret    
  801d48:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d4d:	89 eb                	mov    %ebp,%ebx
  801d4f:	29 fb                	sub    %edi,%ebx
  801d51:	89 f9                	mov    %edi,%ecx
  801d53:	d3 e6                	shl    %cl,%esi
  801d55:	89 c5                	mov    %eax,%ebp
  801d57:	88 d9                	mov    %bl,%cl
  801d59:	d3 ed                	shr    %cl,%ebp
  801d5b:	89 e9                	mov    %ebp,%ecx
  801d5d:	09 f1                	or     %esi,%ecx
  801d5f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d63:	89 f9                	mov    %edi,%ecx
  801d65:	d3 e0                	shl    %cl,%eax
  801d67:	89 c5                	mov    %eax,%ebp
  801d69:	89 d6                	mov    %edx,%esi
  801d6b:	88 d9                	mov    %bl,%cl
  801d6d:	d3 ee                	shr    %cl,%esi
  801d6f:	89 f9                	mov    %edi,%ecx
  801d71:	d3 e2                	shl    %cl,%edx
  801d73:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d77:	88 d9                	mov    %bl,%cl
  801d79:	d3 e8                	shr    %cl,%eax
  801d7b:	09 c2                	or     %eax,%edx
  801d7d:	89 d0                	mov    %edx,%eax
  801d7f:	89 f2                	mov    %esi,%edx
  801d81:	f7 74 24 0c          	divl   0xc(%esp)
  801d85:	89 d6                	mov    %edx,%esi
  801d87:	89 c3                	mov    %eax,%ebx
  801d89:	f7 e5                	mul    %ebp
  801d8b:	39 d6                	cmp    %edx,%esi
  801d8d:	72 19                	jb     801da8 <__udivdi3+0xfc>
  801d8f:	74 0b                	je     801d9c <__udivdi3+0xf0>
  801d91:	89 d8                	mov    %ebx,%eax
  801d93:	31 ff                	xor    %edi,%edi
  801d95:	e9 58 ff ff ff       	jmp    801cf2 <__udivdi3+0x46>
  801d9a:	66 90                	xchg   %ax,%ax
  801d9c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801da0:	89 f9                	mov    %edi,%ecx
  801da2:	d3 e2                	shl    %cl,%edx
  801da4:	39 c2                	cmp    %eax,%edx
  801da6:	73 e9                	jae    801d91 <__udivdi3+0xe5>
  801da8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801dab:	31 ff                	xor    %edi,%edi
  801dad:	e9 40 ff ff ff       	jmp    801cf2 <__udivdi3+0x46>
  801db2:	66 90                	xchg   %ax,%ax
  801db4:	31 c0                	xor    %eax,%eax
  801db6:	e9 37 ff ff ff       	jmp    801cf2 <__udivdi3+0x46>
  801dbb:	90                   	nop

00801dbc <__umoddi3>:
  801dbc:	55                   	push   %ebp
  801dbd:	57                   	push   %edi
  801dbe:	56                   	push   %esi
  801dbf:	53                   	push   %ebx
  801dc0:	83 ec 1c             	sub    $0x1c,%esp
  801dc3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801dc7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dcb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dcf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dd3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dd7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ddb:	89 f3                	mov    %esi,%ebx
  801ddd:	89 fa                	mov    %edi,%edx
  801ddf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801de3:	89 34 24             	mov    %esi,(%esp)
  801de6:	85 c0                	test   %eax,%eax
  801de8:	75 1a                	jne    801e04 <__umoddi3+0x48>
  801dea:	39 f7                	cmp    %esi,%edi
  801dec:	0f 86 a2 00 00 00    	jbe    801e94 <__umoddi3+0xd8>
  801df2:	89 c8                	mov    %ecx,%eax
  801df4:	89 f2                	mov    %esi,%edx
  801df6:	f7 f7                	div    %edi
  801df8:	89 d0                	mov    %edx,%eax
  801dfa:	31 d2                	xor    %edx,%edx
  801dfc:	83 c4 1c             	add    $0x1c,%esp
  801dff:	5b                   	pop    %ebx
  801e00:	5e                   	pop    %esi
  801e01:	5f                   	pop    %edi
  801e02:	5d                   	pop    %ebp
  801e03:	c3                   	ret    
  801e04:	39 f0                	cmp    %esi,%eax
  801e06:	0f 87 ac 00 00 00    	ja     801eb8 <__umoddi3+0xfc>
  801e0c:	0f bd e8             	bsr    %eax,%ebp
  801e0f:	83 f5 1f             	xor    $0x1f,%ebp
  801e12:	0f 84 ac 00 00 00    	je     801ec4 <__umoddi3+0x108>
  801e18:	bf 20 00 00 00       	mov    $0x20,%edi
  801e1d:	29 ef                	sub    %ebp,%edi
  801e1f:	89 fe                	mov    %edi,%esi
  801e21:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e25:	89 e9                	mov    %ebp,%ecx
  801e27:	d3 e0                	shl    %cl,%eax
  801e29:	89 d7                	mov    %edx,%edi
  801e2b:	89 f1                	mov    %esi,%ecx
  801e2d:	d3 ef                	shr    %cl,%edi
  801e2f:	09 c7                	or     %eax,%edi
  801e31:	89 e9                	mov    %ebp,%ecx
  801e33:	d3 e2                	shl    %cl,%edx
  801e35:	89 14 24             	mov    %edx,(%esp)
  801e38:	89 d8                	mov    %ebx,%eax
  801e3a:	d3 e0                	shl    %cl,%eax
  801e3c:	89 c2                	mov    %eax,%edx
  801e3e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e42:	d3 e0                	shl    %cl,%eax
  801e44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e48:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e4c:	89 f1                	mov    %esi,%ecx
  801e4e:	d3 e8                	shr    %cl,%eax
  801e50:	09 d0                	or     %edx,%eax
  801e52:	d3 eb                	shr    %cl,%ebx
  801e54:	89 da                	mov    %ebx,%edx
  801e56:	f7 f7                	div    %edi
  801e58:	89 d3                	mov    %edx,%ebx
  801e5a:	f7 24 24             	mull   (%esp)
  801e5d:	89 c6                	mov    %eax,%esi
  801e5f:	89 d1                	mov    %edx,%ecx
  801e61:	39 d3                	cmp    %edx,%ebx
  801e63:	0f 82 87 00 00 00    	jb     801ef0 <__umoddi3+0x134>
  801e69:	0f 84 91 00 00 00    	je     801f00 <__umoddi3+0x144>
  801e6f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e73:	29 f2                	sub    %esi,%edx
  801e75:	19 cb                	sbb    %ecx,%ebx
  801e77:	89 d8                	mov    %ebx,%eax
  801e79:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e7d:	d3 e0                	shl    %cl,%eax
  801e7f:	89 e9                	mov    %ebp,%ecx
  801e81:	d3 ea                	shr    %cl,%edx
  801e83:	09 d0                	or     %edx,%eax
  801e85:	89 e9                	mov    %ebp,%ecx
  801e87:	d3 eb                	shr    %cl,%ebx
  801e89:	89 da                	mov    %ebx,%edx
  801e8b:	83 c4 1c             	add    $0x1c,%esp
  801e8e:	5b                   	pop    %ebx
  801e8f:	5e                   	pop    %esi
  801e90:	5f                   	pop    %edi
  801e91:	5d                   	pop    %ebp
  801e92:	c3                   	ret    
  801e93:	90                   	nop
  801e94:	89 fd                	mov    %edi,%ebp
  801e96:	85 ff                	test   %edi,%edi
  801e98:	75 0b                	jne    801ea5 <__umoddi3+0xe9>
  801e9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9f:	31 d2                	xor    %edx,%edx
  801ea1:	f7 f7                	div    %edi
  801ea3:	89 c5                	mov    %eax,%ebp
  801ea5:	89 f0                	mov    %esi,%eax
  801ea7:	31 d2                	xor    %edx,%edx
  801ea9:	f7 f5                	div    %ebp
  801eab:	89 c8                	mov    %ecx,%eax
  801ead:	f7 f5                	div    %ebp
  801eaf:	89 d0                	mov    %edx,%eax
  801eb1:	e9 44 ff ff ff       	jmp    801dfa <__umoddi3+0x3e>
  801eb6:	66 90                	xchg   %ax,%ax
  801eb8:	89 c8                	mov    %ecx,%eax
  801eba:	89 f2                	mov    %esi,%edx
  801ebc:	83 c4 1c             	add    $0x1c,%esp
  801ebf:	5b                   	pop    %ebx
  801ec0:	5e                   	pop    %esi
  801ec1:	5f                   	pop    %edi
  801ec2:	5d                   	pop    %ebp
  801ec3:	c3                   	ret    
  801ec4:	3b 04 24             	cmp    (%esp),%eax
  801ec7:	72 06                	jb     801ecf <__umoddi3+0x113>
  801ec9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ecd:	77 0f                	ja     801ede <__umoddi3+0x122>
  801ecf:	89 f2                	mov    %esi,%edx
  801ed1:	29 f9                	sub    %edi,%ecx
  801ed3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ed7:	89 14 24             	mov    %edx,(%esp)
  801eda:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ede:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ee2:	8b 14 24             	mov    (%esp),%edx
  801ee5:	83 c4 1c             	add    $0x1c,%esp
  801ee8:	5b                   	pop    %ebx
  801ee9:	5e                   	pop    %esi
  801eea:	5f                   	pop    %edi
  801eeb:	5d                   	pop    %ebp
  801eec:	c3                   	ret    
  801eed:	8d 76 00             	lea    0x0(%esi),%esi
  801ef0:	2b 04 24             	sub    (%esp),%eax
  801ef3:	19 fa                	sbb    %edi,%edx
  801ef5:	89 d1                	mov    %edx,%ecx
  801ef7:	89 c6                	mov    %eax,%esi
  801ef9:	e9 71 ff ff ff       	jmp    801e6f <__umoddi3+0xb3>
  801efe:	66 90                	xchg   %ax,%ax
  801f00:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f04:	72 ea                	jb     801ef0 <__umoddi3+0x134>
  801f06:	89 d9                	mov    %ebx,%ecx
  801f08:	e9 62 ff ff ff       	jmp    801e6f <__umoddi3+0xb3>
