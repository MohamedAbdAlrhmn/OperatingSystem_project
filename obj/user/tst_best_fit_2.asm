
obj/user/tst_best_fit_2:     file format elf32-i386


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
  800031:	e8 b5 08 00 00       	call   8008eb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 b6 23 00 00       	call   802400 <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 29                	jmp    800083 <_main+0x4b>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 50 80 00       	mov    0x805020,%eax
  80005f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	01 c0                	add    %eax,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	c1 e0 03             	shl    $0x3,%eax
  800071:	01 c8                	add    %ecx,%eax
  800073:	8a 40 04             	mov    0x4(%eax),%al
  800076:	84 c0                	test   %al,%al
  800078:	74 06                	je     800080 <_main+0x48>
			{
				fullWS = 0;
  80007a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007e:	eb 12                	jmp    800092 <_main+0x5a>
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800080:	ff 45 f0             	incl   -0x10(%ebp)
  800083:	a1 20 50 80 00       	mov    0x805020,%eax
  800088:	8b 50 74             	mov    0x74(%eax),%edx
  80008b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008e:	39 c2                	cmp    %eax,%edx
  800090:	77 c8                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800092:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800096:	74 14                	je     8000ac <_main+0x74>
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 20 3d 80 00       	push   $0x803d20
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 3c 3d 80 00       	push   $0x803d3c
  8000a7:	e8 7b 09 00 00       	call   800a27 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 ad 1b 00 00       	call   801c63 <malloc>
  8000b6:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000b9:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000c7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000ca:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	f3 ab                	rep stos %eax,%es:(%edi)

	//[1] Attempt to allocate more than heap size
	{
		ptr_allocations[0] = malloc(USER_HEAP_MAX - USER_HEAP_START + 1);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 01 00 00 20       	push   $0x20000001
  8000e0:	e8 7e 1b 00 00       	call   801c63 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 54 3d 80 00       	push   $0x803d54
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 3c 3d 80 00       	push   $0x803d3c
  800101:	e8 21 09 00 00       	call   800a27 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 e0 1d 00 00       	call   801eeb <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 78 1e 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 3c 1b 00 00       	call   801c63 <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START) ) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 98 3d 80 00       	push   $0x803d98
  80013f:	6a 31                	push   $0x31
  800141:	68 3c 3d 80 00       	push   $0x803d3c
  800146:	e8 dc 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80014b:	e8 3b 1e 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  800150:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800153:	3d 00 02 00 00       	cmp    $0x200,%eax
  800158:	74 14                	je     80016e <_main+0x136>
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	68 c8 3d 80 00       	push   $0x803dc8
  800162:	6a 33                	push   $0x33
  800164:	68 3c 3d 80 00       	push   $0x803d3c
  800169:	e8 b9 08 00 00       	call   800a27 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80016e:	e8 78 1d 00 00       	call   801eeb <sys_calculate_free_frames>
  800173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800176:	e8 10 1e 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  80017b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80017e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800181:	01 c0                	add    %eax,%eax
  800183:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	50                   	push   %eax
  80018a:	e8 d4 1a 00 00       	call   801c63 <malloc>
  80018f:	83 c4 10             	add    $0x10,%esp
  800192:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800195:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800198:	89 c2                	mov    %eax,%edx
  80019a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019d:	01 c0                	add    %eax,%eax
  80019f:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a4:	39 c2                	cmp    %eax,%edx
  8001a6:	74 14                	je     8001bc <_main+0x184>
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	68 98 3d 80 00       	push   $0x803d98
  8001b0:	6a 39                	push   $0x39
  8001b2:	68 3c 3d 80 00       	push   $0x803d3c
  8001b7:	e8 6b 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001bc:	e8 ca 1d 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  8001c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 c8 3d 80 00       	push   $0x803dc8
  8001d3:	6a 3b                	push   $0x3b
  8001d5:	68 3c 3d 80 00       	push   $0x803d3c
  8001da:	e8 48 08 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 07 1d 00 00       	call   801eeb <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 9f 1d 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  8001ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f2:	01 c0                	add    %eax,%eax
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	50                   	push   %eax
  8001f8:	e8 66 1a 00 00       	call   801c63 <malloc>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800203:	8b 45 98             	mov    -0x68(%ebp),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020b:	c1 e0 02             	shl    $0x2,%eax
  80020e:	05 00 00 00 80       	add    $0x80000000,%eax
  800213:	39 c2                	cmp    %eax,%edx
  800215:	74 14                	je     80022b <_main+0x1f3>
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	68 98 3d 80 00       	push   $0x803d98
  80021f:	6a 41                	push   $0x41
  800221:	68 3c 3d 80 00       	push   $0x803d3c
  800226:	e8 fc 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80022b:	e8 5b 1d 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  800230:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800233:	83 f8 01             	cmp    $0x1,%eax
  800236:	74 14                	je     80024c <_main+0x214>
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 c8 3d 80 00       	push   $0x803dc8
  800240:	6a 43                	push   $0x43
  800242:	68 3c 3d 80 00       	push   $0x803d3c
  800247:	e8 db 07 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80024c:	e8 9a 1c 00 00       	call   801eeb <sys_calculate_free_frames>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800254:	e8 32 1d 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  800259:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  80025c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80025f:	01 c0                	add    %eax,%eax
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	50                   	push   %eax
  800265:	e8 f9 19 00 00       	call   801c63 <malloc>
  80026a:	83 c4 10             	add    $0x10,%esp
  80026d:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  800270:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800273:	89 c2                	mov    %eax,%edx
  800275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800278:	c1 e0 02             	shl    $0x2,%eax
  80027b:	89 c1                	mov    %eax,%ecx
  80027d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800280:	c1 e0 02             	shl    $0x2,%eax
  800283:	01 c8                	add    %ecx,%eax
  800285:	05 00 00 00 80       	add    $0x80000000,%eax
  80028a:	39 c2                	cmp    %eax,%edx
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 98 3d 80 00       	push   $0x803d98
  800296:	6a 49                	push   $0x49
  800298:	68 3c 3d 80 00       	push   $0x803d3c
  80029d:	e8 85 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002a2:	e8 e4 1c 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  8002a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002aa:	83 f8 01             	cmp    $0x1,%eax
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 c8 3d 80 00       	push   $0x803dc8
  8002b7:	6a 4b                	push   $0x4b
  8002b9:	68 3c 3d 80 00       	push   $0x803d3c
  8002be:	e8 64 07 00 00       	call   800a27 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002c3:	e8 23 1c 00 00       	call   801eeb <sys_calculate_free_frames>
  8002c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cb:	e8 bb 1c 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  8002d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 b2 19 00 00       	call   801c91 <free>
  8002df:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002e2:	e8 a4 1c 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  8002e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ea:	29 c2                	sub    %eax,%edx
  8002ec:	89 d0                	mov    %edx,%eax
  8002ee:	83 f8 01             	cmp    $0x1,%eax
  8002f1:	74 14                	je     800307 <_main+0x2cf>
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	68 e5 3d 80 00       	push   $0x803de5
  8002fb:	6a 52                	push   $0x52
  8002fd:	68 3c 3d 80 00       	push   $0x803d3c
  800302:	e8 20 07 00 00       	call   800a27 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  800307:	e8 df 1b 00 00       	call   801eeb <sys_calculate_free_frames>
  80030c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80030f:	e8 77 1c 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  800314:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800317:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80031a:	89 d0                	mov    %edx,%eax
  80031c:	01 c0                	add    %eax,%eax
  80031e:	01 d0                	add    %edx,%eax
  800320:	01 c0                	add    %eax,%eax
  800322:	01 d0                	add    %edx,%eax
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	50                   	push   %eax
  800328:	e8 36 19 00 00       	call   801c63 <malloc>
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800333:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800336:	89 c2                	mov    %eax,%edx
  800338:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80033b:	c1 e0 02             	shl    $0x2,%eax
  80033e:	89 c1                	mov    %eax,%ecx
  800340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800343:	c1 e0 03             	shl    $0x3,%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	05 00 00 00 80       	add    $0x80000000,%eax
  80034d:	39 c2                	cmp    %eax,%edx
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 98 3d 80 00       	push   $0x803d98
  800359:	6a 58                	push   $0x58
  80035b:	68 3c 3d 80 00       	push   $0x803d3c
  800360:	e8 c2 06 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800365:	e8 21 1c 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  80036a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80036d:	83 f8 02             	cmp    $0x2,%eax
  800370:	74 14                	je     800386 <_main+0x34e>
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 c8 3d 80 00       	push   $0x803dc8
  80037a:	6a 5a                	push   $0x5a
  80037c:	68 3c 3d 80 00       	push   $0x803d3c
  800381:	e8 a1 06 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800386:	e8 60 1b 00 00       	call   801eeb <sys_calculate_free_frames>
  80038b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80038e:	e8 f8 1b 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  800393:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800396:	8b 45 90             	mov    -0x70(%ebp),%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	50                   	push   %eax
  80039d:	e8 ef 18 00 00       	call   801c91 <free>
  8003a2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003a5:	e8 e1 1b 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	29 c2                	sub    %eax,%edx
  8003af:	89 d0                	mov    %edx,%eax
  8003b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003b6:	74 14                	je     8003cc <_main+0x394>
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	68 e5 3d 80 00       	push   $0x803de5
  8003c0:	6a 61                	push   $0x61
  8003c2:	68 3c 3d 80 00       	push   $0x803d3c
  8003c7:	e8 5b 06 00 00       	call   800a27 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cc:	e8 1a 1b 00 00       	call   801eeb <sys_calculate_free_frames>
  8003d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d4:	e8 b2 1b 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  8003d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	01 d2                	add    %edx,%edx
  8003e3:	01 d0                	add    %edx,%eax
  8003e5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e8:	83 ec 0c             	sub    $0xc,%esp
  8003eb:	50                   	push   %eax
  8003ec:	e8 72 18 00 00       	call   801c63 <malloc>
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003f7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fa:	89 c2                	mov    %eax,%edx
  8003fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ff:	c1 e0 02             	shl    $0x2,%eax
  800402:	89 c1                	mov    %eax,%ecx
  800404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800407:	c1 e0 04             	shl    $0x4,%eax
  80040a:	01 c8                	add    %ecx,%eax
  80040c:	05 00 00 00 80       	add    $0x80000000,%eax
  800411:	39 c2                	cmp    %eax,%edx
  800413:	74 14                	je     800429 <_main+0x3f1>
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	68 98 3d 80 00       	push   $0x803d98
  80041d:	6a 67                	push   $0x67
  80041f:	68 3c 3d 80 00       	push   $0x803d3c
  800424:	e8 fe 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800429:	e8 5d 1b 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  80042e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800431:	89 c2                	mov    %eax,%edx
  800433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800436:	89 c1                	mov    %eax,%ecx
  800438:	01 c9                	add    %ecx,%ecx
  80043a:	01 c8                	add    %ecx,%eax
  80043c:	85 c0                	test   %eax,%eax
  80043e:	79 05                	jns    800445 <_main+0x40d>
  800440:	05 ff 0f 00 00       	add    $0xfff,%eax
  800445:	c1 f8 0c             	sar    $0xc,%eax
  800448:	39 c2                	cmp    %eax,%edx
  80044a:	74 14                	je     800460 <_main+0x428>
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 c8 3d 80 00       	push   $0x803dc8
  800454:	6a 69                	push   $0x69
  800456:	68 3c 3d 80 00       	push   $0x803d3c
  80045b:	e8 c7 05 00 00       	call   800a27 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800460:	e8 86 1a 00 00       	call   801eeb <sys_calculate_free_frames>
  800465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800468:	e8 1e 1b 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  80046d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  800470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800473:	89 c2                	mov    %eax,%edx
  800475:	01 d2                	add    %edx,%edx
  800477:	01 c2                	add    %eax,%edx
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	01 c0                	add    %eax,%eax
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	50                   	push   %eax
  800484:	e8 da 17 00 00       	call   801c63 <malloc>
  800489:	83 c4 10             	add    $0x10,%esp
  80048c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80048f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800492:	89 c1                	mov    %eax,%ecx
  800494:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800497:	89 d0                	mov    %edx,%eax
  800499:	01 c0                	add    %eax,%eax
  80049b:	01 d0                	add    %edx,%eax
  80049d:	01 c0                	add    %eax,%eax
  80049f:	01 d0                	add    %edx,%eax
  8004a1:	89 c2                	mov    %eax,%edx
  8004a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004a6:	c1 e0 04             	shl    $0x4,%eax
  8004a9:	01 d0                	add    %edx,%eax
  8004ab:	05 00 00 00 80       	add    $0x80000000,%eax
  8004b0:	39 c1                	cmp    %eax,%ecx
  8004b2:	74 14                	je     8004c8 <_main+0x490>
  8004b4:	83 ec 04             	sub    $0x4,%esp
  8004b7:	68 98 3d 80 00       	push   $0x803d98
  8004bc:	6a 6f                	push   $0x6f
  8004be:	68 3c 3d 80 00       	push   $0x803d3c
  8004c3:	e8 5f 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004c8:	e8 be 1a 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  8004cd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004d0:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004d5:	74 14                	je     8004eb <_main+0x4b3>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 c8 3d 80 00       	push   $0x803dc8
  8004df:	6a 71                	push   $0x71
  8004e1:	68 3c 3d 80 00       	push   $0x803d3c
  8004e6:	e8 3c 05 00 00       	call   800a27 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004eb:	e8 fb 19 00 00       	call   801eeb <sys_calculate_free_frames>
  8004f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f3:	e8 93 1a 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  8004f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  8004fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004fe:	89 d0                	mov    %edx,%eax
  800500:	c1 e0 02             	shl    $0x2,%eax
  800503:	01 d0                	add    %edx,%eax
  800505:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	50                   	push   %eax
  80050c:	e8 52 17 00 00       	call   801c63 <malloc>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800517:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80051a:	89 c1                	mov    %eax,%ecx
  80051c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051f:	89 d0                	mov    %edx,%eax
  800521:	c1 e0 03             	shl    $0x3,%eax
  800524:	01 d0                	add    %edx,%eax
  800526:	89 c3                	mov    %eax,%ebx
  800528:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80052b:	89 d0                	mov    %edx,%eax
  80052d:	01 c0                	add    %eax,%eax
  80052f:	01 d0                	add    %edx,%eax
  800531:	c1 e0 03             	shl    $0x3,%eax
  800534:	01 d8                	add    %ebx,%eax
  800536:	05 00 00 00 80       	add    $0x80000000,%eax
  80053b:	39 c1                	cmp    %eax,%ecx
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 98 3d 80 00       	push   $0x803d98
  800547:	6a 77                	push   $0x77
  800549:	68 3c 3d 80 00       	push   $0x803d3c
  80054e:	e8 d4 04 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  800553:	e8 33 1a 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  800558:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 02             	shl    $0x2,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	85 c0                	test   %eax,%eax
  800569:	79 05                	jns    800570 <_main+0x538>
  80056b:	05 ff 0f 00 00       	add    $0xfff,%eax
  800570:	c1 f8 0c             	sar    $0xc,%eax
  800573:	39 c1                	cmp    %eax,%ecx
  800575:	74 14                	je     80058b <_main+0x553>
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	68 c8 3d 80 00       	push   $0x803dc8
  80057f:	6a 79                	push   $0x79
  800581:	68 3c 3d 80 00       	push   $0x803d3c
  800586:	e8 9c 04 00 00       	call   800a27 <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80058b:	e8 5b 19 00 00       	call   801eeb <sys_calculate_free_frames>
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800593:	e8 f3 19 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80059b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 ea 16 00 00       	call   801c91 <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  8005aa:	e8 dc 19 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	29 c2                	sub    %eax,%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	3d 02 02 00 00       	cmp    $0x202,%eax
  8005bb:	74 17                	je     8005d4 <_main+0x59c>
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 e5 3d 80 00       	push   $0x803de5
  8005c5:	68 80 00 00 00       	push   $0x80
  8005ca:	68 3c 3d 80 00       	push   $0x803d3c
  8005cf:	e8 53 04 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d4:	e8 12 19 00 00       	call   801eeb <sys_calculate_free_frames>
  8005d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005dc:	e8 aa 19 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005e4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	50                   	push   %eax
  8005eb:	e8 a1 16 00 00       	call   801c91 <free>
  8005f0:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8005f3:	e8 93 19 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  8005f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fb:	29 c2                	sub    %eax,%edx
  8005fd:	89 d0                	mov    %edx,%eax
  8005ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  800604:	74 17                	je     80061d <_main+0x5e5>
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	68 e5 3d 80 00       	push   $0x803de5
  80060e:	68 87 00 00 00       	push   $0x87
  800613:	68 3c 3d 80 00       	push   $0x803d3c
  800618:	e8 0a 04 00 00       	call   800a27 <_panic>

		//2 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  80061d:	e8 c9 18 00 00       	call   801eeb <sys_calculate_free_frames>
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800625:	e8 61 19 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  80062a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(2*Mega-kilo);
  80062d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800630:	01 c0                	add    %eax,%eax
  800632:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800635:	83 ec 0c             	sub    $0xc,%esp
  800638:	50                   	push   %eax
  800639:	e8 25 16 00 00       	call   801c63 <malloc>
  80063e:	83 c4 10             	add    $0x10,%esp
  800641:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800644:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800647:	89 c1                	mov    %eax,%ecx
  800649:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80064c:	89 d0                	mov    %edx,%eax
  80064e:	01 c0                	add    %eax,%eax
  800650:	01 d0                	add    %edx,%eax
  800652:	01 c0                	add    %eax,%eax
  800654:	01 d0                	add    %edx,%eax
  800656:	89 c2                	mov    %eax,%edx
  800658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80065b:	c1 e0 04             	shl    $0x4,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	05 00 00 00 80       	add    $0x80000000,%eax
  800665:	39 c1                	cmp    %eax,%ecx
  800667:	74 17                	je     800680 <_main+0x648>
  800669:	83 ec 04             	sub    $0x4,%esp
  80066c:	68 98 3d 80 00       	push   $0x803d98
  800671:	68 8d 00 00 00       	push   $0x8d
  800676:	68 3c 3d 80 00       	push   $0x803d3c
  80067b:	e8 a7 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800680:	e8 06 19 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  800685:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800688:	3d 00 02 00 00       	cmp    $0x200,%eax
  80068d:	74 17                	je     8006a6 <_main+0x66e>
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 c8 3d 80 00       	push   $0x803dc8
  800697:	68 8f 00 00 00       	push   $0x8f
  80069c:	68 3c 3d 80 00       	push   $0x803d3c
  8006a1:	e8 81 03 00 00       	call   800a27 <_panic>

		//6 KB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  8006a6:	e8 40 18 00 00       	call   801eeb <sys_calculate_free_frames>
  8006ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ae:	e8 d8 18 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(6*kilo);
  8006b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b9:	89 d0                	mov    %edx,%eax
  8006bb:	01 c0                	add    %eax,%eax
  8006bd:	01 d0                	add    %edx,%eax
  8006bf:	01 c0                	add    %eax,%eax
  8006c1:	83 ec 0c             	sub    $0xc,%esp
  8006c4:	50                   	push   %eax
  8006c5:	e8 99 15 00 00       	call   801c63 <malloc>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 9*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8006d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006d3:	89 c1                	mov    %eax,%ecx
  8006d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006d8:	89 d0                	mov    %edx,%eax
  8006da:	c1 e0 03             	shl    $0x3,%eax
  8006dd:	01 d0                	add    %edx,%eax
  8006df:	89 c2                	mov    %eax,%edx
  8006e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006e4:	c1 e0 04             	shl    $0x4,%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	05 00 00 00 80       	add    $0x80000000,%eax
  8006ee:	39 c1                	cmp    %eax,%ecx
  8006f0:	74 17                	je     800709 <_main+0x6d1>
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	68 98 3d 80 00       	push   $0x803d98
  8006fa:	68 95 00 00 00       	push   $0x95
  8006ff:	68 3c 3d 80 00       	push   $0x803d3c
  800704:	e8 1e 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800709:	e8 7d 18 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  80070e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800711:	83 f8 02             	cmp    $0x2,%eax
  800714:	74 17                	je     80072d <_main+0x6f5>
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	68 c8 3d 80 00       	push   $0x803dc8
  80071e:	68 97 00 00 00       	push   $0x97
  800723:	68 3c 3d 80 00       	push   $0x803d3c
  800728:	e8 fa 02 00 00       	call   800a27 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80072d:	e8 b9 17 00 00       	call   801eeb <sys_calculate_free_frames>
  800732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800735:	e8 51 18 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  80073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80073d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 48 15 00 00       	call   801c91 <free>
  800749:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  80074c:	e8 3a 18 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  800751:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800754:	29 c2                	sub    %eax,%edx
  800756:	89 d0                	mov    %edx,%eax
  800758:	3d 00 03 00 00       	cmp    $0x300,%eax
  80075d:	74 17                	je     800776 <_main+0x73e>
  80075f:	83 ec 04             	sub    $0x4,%esp
  800762:	68 e5 3d 80 00       	push   $0x803de5
  800767:	68 9e 00 00 00       	push   $0x9e
  80076c:	68 3c 3d 80 00       	push   $0x803d3c
  800771:	e8 b1 02 00 00       	call   800a27 <_panic>

		//3 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800776:	e8 70 17 00 00       	call   801eeb <sys_calculate_free_frames>
  80077b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80077e:	e8 08 18 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  800783:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(3*Mega-kilo);
  800786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800789:	89 c2                	mov    %eax,%edx
  80078b:	01 d2                	add    %edx,%edx
  80078d:	01 d0                	add    %edx,%eax
  80078f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800792:	83 ec 0c             	sub    $0xc,%esp
  800795:	50                   	push   %eax
  800796:	e8 c8 14 00 00       	call   801c63 <malloc>
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8007a1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007a4:	89 c2                	mov    %eax,%edx
  8007a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a9:	c1 e0 02             	shl    $0x2,%eax
  8007ac:	89 c1                	mov    %eax,%ecx
  8007ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007b1:	c1 e0 04             	shl    $0x4,%eax
  8007b4:	01 c8                	add    %ecx,%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 98 3d 80 00       	push   $0x803d98
  8007c7:	68 a4 00 00 00       	push   $0xa4
  8007cc:	68 3c 3d 80 00       	push   $0x803d3c
  8007d1:	e8 51 02 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8007d6:	e8 b0 17 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  8007db:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007de:	89 c2                	mov    %eax,%edx
  8007e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e3:	89 c1                	mov    %eax,%ecx
  8007e5:	01 c9                	add    %ecx,%ecx
  8007e7:	01 c8                	add    %ecx,%eax
  8007e9:	85 c0                	test   %eax,%eax
  8007eb:	79 05                	jns    8007f2 <_main+0x7ba>
  8007ed:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f2:	c1 f8 0c             	sar    $0xc,%eax
  8007f5:	39 c2                	cmp    %eax,%edx
  8007f7:	74 17                	je     800810 <_main+0x7d8>
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 c8 3d 80 00       	push   $0x803dc8
  800801:	68 a6 00 00 00       	push   $0xa6
  800806:	68 3c 3d 80 00       	push   $0x803d3c
  80080b:	e8 17 02 00 00       	call   800a27 <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800810:	e8 d6 16 00 00       	call   801eeb <sys_calculate_free_frames>
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800818:	e8 6e 17 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  80081d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega-kilo);
  800820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800823:	c1 e0 02             	shl    $0x2,%eax
  800826:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800829:	83 ec 0c             	sub    $0xc,%esp
  80082c:	50                   	push   %eax
  80082d:	e8 31 14 00 00       	call   801c63 <malloc>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800838:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80083b:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	83 ec 04             	sub    $0x4,%esp
  800845:	68 98 3d 80 00       	push   $0x803d98
  80084a:	68 ac 00 00 00       	push   $0xac
  80084f:	68 3c 3d 80 00       	push   $0x803d3c
  800854:	e8 ce 01 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800859:	e8 2d 17 00 00       	call   801f8b <sys_pf_calculate_allocated_pages>
  80085e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800861:	89 c2                	mov    %eax,%edx
  800863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800866:	c1 e0 02             	shl    $0x2,%eax
  800869:	85 c0                	test   %eax,%eax
  80086b:	79 05                	jns    800872 <_main+0x83a>
  80086d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800872:	c1 f8 0c             	sar    $0xc,%eax
  800875:	39 c2                	cmp    %eax,%edx
  800877:	74 17                	je     800890 <_main+0x858>
  800879:	83 ec 04             	sub    $0x4,%esp
  80087c:	68 c8 3d 80 00       	push   $0x803dc8
  800881:	68 ae 00 00 00       	push   $0xae
  800886:	68 3c 3d 80 00       	push   $0x803d3c
  80088b:	e8 97 01 00 00       	call   800a27 <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[12] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800890:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800893:	89 d0                	mov    %edx,%eax
  800895:	01 c0                	add    %eax,%eax
  800897:	01 d0                	add    %edx,%eax
  800899:	01 c0                	add    %eax,%eax
  80089b:	01 d0                	add    %edx,%eax
  80089d:	01 c0                	add    %eax,%eax
  80089f:	f7 d8                	neg    %eax
  8008a1:	05 00 00 00 20       	add    $0x20000000,%eax
  8008a6:	83 ec 0c             	sub    $0xc,%esp
  8008a9:	50                   	push   %eax
  8008aa:	e8 b4 13 00 00       	call   801c63 <malloc>
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (ptr_allocations[12] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  8008b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	74 17                	je     8008d3 <_main+0x89b>
  8008bc:	83 ec 04             	sub    $0x4,%esp
  8008bf:	68 fc 3d 80 00       	push   $0x803dfc
  8008c4:	68 b7 00 00 00       	push   $0xb7
  8008c9:	68 3c 3d 80 00       	push   $0x803d3c
  8008ce:	e8 54 01 00 00       	call   800a27 <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 60 3e 80 00       	push   $0x803e60
  8008db:	e8 fb 03 00 00       	call   800cdb <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp

		return;
  8008e3:	90                   	nop
	}
}
  8008e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5f                   	pop    %edi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8008f1:	e8 d5 18 00 00       	call   8021cb <sys_getenvindex>
  8008f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8008f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008fc:	89 d0                	mov    %edx,%eax
  8008fe:	c1 e0 03             	shl    $0x3,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	01 d0                	add    %edx,%eax
  800907:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80090e:	01 d0                	add    %edx,%eax
  800910:	c1 e0 04             	shl    $0x4,%eax
  800913:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800918:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80091d:	a1 20 50 80 00       	mov    0x805020,%eax
  800922:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800928:	84 c0                	test   %al,%al
  80092a:	74 0f                	je     80093b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80092c:	a1 20 50 80 00       	mov    0x805020,%eax
  800931:	05 5c 05 00 00       	add    $0x55c,%eax
  800936:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80093b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80093f:	7e 0a                	jle    80094b <libmain+0x60>
		binaryname = argv[0];
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	ff 75 08             	pushl  0x8(%ebp)
  800954:	e8 df f6 ff ff       	call   800038 <_main>
  800959:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80095c:	e8 77 16 00 00       	call   801fd8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 c0 3e 80 00       	push   $0x803ec0
  800969:	e8 6d 03 00 00       	call   800cdb <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800971:	a1 20 50 80 00       	mov    0x805020,%eax
  800976:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80097c:	a1 20 50 80 00       	mov    0x805020,%eax
  800981:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800987:	83 ec 04             	sub    $0x4,%esp
  80098a:	52                   	push   %edx
  80098b:	50                   	push   %eax
  80098c:	68 e8 3e 80 00       	push   $0x803ee8
  800991:	e8 45 03 00 00       	call   800cdb <cprintf>
  800996:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800999:	a1 20 50 80 00       	mov    0x805020,%eax
  80099e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8009a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8009a9:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8009af:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b4:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8009ba:	51                   	push   %ecx
  8009bb:	52                   	push   %edx
  8009bc:	50                   	push   %eax
  8009bd:	68 10 3f 80 00       	push   $0x803f10
  8009c2:	e8 14 03 00 00       	call   800cdb <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8009cf:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	50                   	push   %eax
  8009d9:	68 68 3f 80 00       	push   $0x803f68
  8009de:	e8 f8 02 00 00       	call   800cdb <cprintf>
  8009e3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009e6:	83 ec 0c             	sub    $0xc,%esp
  8009e9:	68 c0 3e 80 00       	push   $0x803ec0
  8009ee:	e8 e8 02 00 00       	call   800cdb <cprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009f6:	e8 f7 15 00 00       	call   801ff2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8009fb:	e8 19 00 00 00       	call   800a19 <exit>
}
  800a00:	90                   	nop
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    

00800a03 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a09:	83 ec 0c             	sub    $0xc,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	e8 84 17 00 00       	call   802197 <sys_destroy_env>
  800a13:	83 c4 10             	add    $0x10,%esp
}
  800a16:	90                   	nop
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <exit>:

void
exit(void)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800a1f:	e8 d9 17 00 00       	call   8021fd <sys_exit_env>
}
  800a24:	90                   	nop
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a2d:	8d 45 10             	lea    0x10(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a36:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800a3b:	85 c0                	test   %eax,%eax
  800a3d:	74 16                	je     800a55 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a3f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	50                   	push   %eax
  800a48:	68 7c 3f 80 00       	push   $0x803f7c
  800a4d:	e8 89 02 00 00       	call   800cdb <cprintf>
  800a52:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a55:	a1 00 50 80 00       	mov    0x805000,%eax
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 08             	pushl  0x8(%ebp)
  800a60:	50                   	push   %eax
  800a61:	68 81 3f 80 00       	push   $0x803f81
  800a66:	e8 70 02 00 00       	call   800cdb <cprintf>
  800a6b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 f4             	pushl  -0xc(%ebp)
  800a77:	50                   	push   %eax
  800a78:	e8 f3 01 00 00       	call   800c70 <vcprintf>
  800a7d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a80:	83 ec 08             	sub    $0x8,%esp
  800a83:	6a 00                	push   $0x0
  800a85:	68 9d 3f 80 00       	push   $0x803f9d
  800a8a:	e8 e1 01 00 00       	call   800c70 <vcprintf>
  800a8f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a92:	e8 82 ff ff ff       	call   800a19 <exit>

	// should not return here
	while (1) ;
  800a97:	eb fe                	jmp    800a97 <_panic+0x70>

00800a99 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a9f:	a1 20 50 80 00       	mov    0x805020,%eax
  800aa4:	8b 50 74             	mov    0x74(%eax),%edx
  800aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaa:	39 c2                	cmp    %eax,%edx
  800aac:	74 14                	je     800ac2 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	68 a0 3f 80 00       	push   $0x803fa0
  800ab6:	6a 26                	push   $0x26
  800ab8:	68 ec 3f 80 00       	push   $0x803fec
  800abd:	e8 65 ff ff ff       	call   800a27 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800ac2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ac9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ad0:	e9 c2 00 00 00       	jmp    800b97 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	01 d0                	add    %edx,%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	85 c0                	test   %eax,%eax
  800ae8:	75 08                	jne    800af2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800aea:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800aed:	e9 a2 00 00 00       	jmp    800b94 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800af2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800af9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b00:	eb 69                	jmp    800b6b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b02:	a1 20 50 80 00       	mov    0x805020,%eax
  800b07:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b10:	89 d0                	mov    %edx,%eax
  800b12:	01 c0                	add    %eax,%eax
  800b14:	01 d0                	add    %edx,%eax
  800b16:	c1 e0 03             	shl    $0x3,%eax
  800b19:	01 c8                	add    %ecx,%eax
  800b1b:	8a 40 04             	mov    0x4(%eax),%al
  800b1e:	84 c0                	test   %al,%al
  800b20:	75 46                	jne    800b68 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b22:	a1 20 50 80 00       	mov    0x805020,%eax
  800b27:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b30:	89 d0                	mov    %edx,%eax
  800b32:	01 c0                	add    %eax,%eax
  800b34:	01 d0                	add    %edx,%eax
  800b36:	c1 e0 03             	shl    $0x3,%eax
  800b39:	01 c8                	add    %ecx,%eax
  800b3b:	8b 00                	mov    (%eax),%eax
  800b3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b48:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b4d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	01 c8                	add    %ecx,%eax
  800b59:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b5b:	39 c2                	cmp    %eax,%edx
  800b5d:	75 09                	jne    800b68 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800b5f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800b66:	eb 12                	jmp    800b7a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b68:	ff 45 e8             	incl   -0x18(%ebp)
  800b6b:	a1 20 50 80 00       	mov    0x805020,%eax
  800b70:	8b 50 74             	mov    0x74(%eax),%edx
  800b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b76:	39 c2                	cmp    %eax,%edx
  800b78:	77 88                	ja     800b02 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b7e:	75 14                	jne    800b94 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800b80:	83 ec 04             	sub    $0x4,%esp
  800b83:	68 f8 3f 80 00       	push   $0x803ff8
  800b88:	6a 3a                	push   $0x3a
  800b8a:	68 ec 3f 80 00       	push   $0x803fec
  800b8f:	e8 93 fe ff ff       	call   800a27 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b94:	ff 45 f0             	incl   -0x10(%ebp)
  800b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b9d:	0f 8c 32 ff ff ff    	jl     800ad5 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ba3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800baa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800bb1:	eb 26                	jmp    800bd9 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800bb3:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bbe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bc1:	89 d0                	mov    %edx,%eax
  800bc3:	01 c0                	add    %eax,%eax
  800bc5:	01 d0                	add    %edx,%eax
  800bc7:	c1 e0 03             	shl    $0x3,%eax
  800bca:	01 c8                	add    %ecx,%eax
  800bcc:	8a 40 04             	mov    0x4(%eax),%al
  800bcf:	3c 01                	cmp    $0x1,%al
  800bd1:	75 03                	jne    800bd6 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800bd3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bd6:	ff 45 e0             	incl   -0x20(%ebp)
  800bd9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bde:	8b 50 74             	mov    0x74(%eax),%edx
  800be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800be4:	39 c2                	cmp    %eax,%edx
  800be6:	77 cb                	ja     800bb3 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800beb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800bee:	74 14                	je     800c04 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800bf0:	83 ec 04             	sub    $0x4,%esp
  800bf3:	68 4c 40 80 00       	push   $0x80404c
  800bf8:	6a 44                	push   $0x44
  800bfa:	68 ec 3f 80 00       	push   $0x803fec
  800bff:	e8 23 fe ff ff       	call   800a27 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c04:	90                   	nop
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 d1                	mov    %dl,%cl
  800c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c22:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c30:	75 2c                	jne    800c5e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c32:	a0 24 50 80 00       	mov    0x805024,%al
  800c37:	0f b6 c0             	movzbl %al,%eax
  800c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3d:	8b 12                	mov    (%edx),%edx
  800c3f:	89 d1                	mov    %edx,%ecx
  800c41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c44:	83 c2 08             	add    $0x8,%edx
  800c47:	83 ec 04             	sub    $0x4,%esp
  800c4a:	50                   	push   %eax
  800c4b:	51                   	push   %ecx
  800c4c:	52                   	push   %edx
  800c4d:	e8 d8 11 00 00       	call   801e2a <sys_cputs>
  800c52:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	8b 40 04             	mov    0x4(%eax),%eax
  800c64:	8d 50 01             	lea    0x1(%eax),%edx
  800c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c6d:	90                   	nop
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c79:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c80:	00 00 00 
	b.cnt = 0;
  800c83:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c8a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	ff 75 08             	pushl  0x8(%ebp)
  800c93:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c99:	50                   	push   %eax
  800c9a:	68 07 0c 80 00       	push   $0x800c07
  800c9f:	e8 11 02 00 00       	call   800eb5 <vprintfmt>
  800ca4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ca7:	a0 24 50 80 00       	mov    0x805024,%al
  800cac:	0f b6 c0             	movzbl %al,%eax
  800caf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800cb5:	83 ec 04             	sub    $0x4,%esp
  800cb8:	50                   	push   %eax
  800cb9:	52                   	push   %edx
  800cba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cc0:	83 c0 08             	add    $0x8,%eax
  800cc3:	50                   	push   %eax
  800cc4:	e8 61 11 00 00       	call   801e2a <sys_cputs>
  800cc9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ccc:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800cd3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <cprintf>:

int cprintf(const char *fmt, ...) {
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ce1:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800ce8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	83 ec 08             	sub    $0x8,%esp
  800cf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf7:	50                   	push   %eax
  800cf8:	e8 73 ff ff ff       	call   800c70 <vcprintf>
  800cfd:	83 c4 10             	add    $0x10,%esp
  800d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d0e:	e8 c5 12 00 00       	call   801fd8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d13:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d22:	50                   	push   %eax
  800d23:	e8 48 ff ff ff       	call   800c70 <vcprintf>
  800d28:	83 c4 10             	add    $0x10,%esp
  800d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800d2e:	e8 bf 12 00 00       	call   801ff2 <sys_enable_interrupt>
	return cnt;
  800d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d36:	c9                   	leave  
  800d37:	c3                   	ret    

00800d38 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	53                   	push   %ebx
  800d3c:	83 ec 14             	sub    $0x14,%esp
  800d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d45:	8b 45 14             	mov    0x14(%ebp),%eax
  800d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d4b:	8b 45 18             	mov    0x18(%ebp),%eax
  800d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d53:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d56:	77 55                	ja     800dad <printnum+0x75>
  800d58:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d5b:	72 05                	jb     800d62 <printnum+0x2a>
  800d5d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d60:	77 4b                	ja     800dad <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d62:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d65:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d68:	8b 45 18             	mov    0x18(%ebp),%eax
  800d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d70:	52                   	push   %edx
  800d71:	50                   	push   %eax
  800d72:	ff 75 f4             	pushl  -0xc(%ebp)
  800d75:	ff 75 f0             	pushl  -0x10(%ebp)
  800d78:	e8 33 2d 00 00       	call   803ab0 <__udivdi3>
  800d7d:	83 c4 10             	add    $0x10,%esp
  800d80:	83 ec 04             	sub    $0x4,%esp
  800d83:	ff 75 20             	pushl  0x20(%ebp)
  800d86:	53                   	push   %ebx
  800d87:	ff 75 18             	pushl  0x18(%ebp)
  800d8a:	52                   	push   %edx
  800d8b:	50                   	push   %eax
  800d8c:	ff 75 0c             	pushl  0xc(%ebp)
  800d8f:	ff 75 08             	pushl  0x8(%ebp)
  800d92:	e8 a1 ff ff ff       	call   800d38 <printnum>
  800d97:	83 c4 20             	add    $0x20,%esp
  800d9a:	eb 1a                	jmp    800db6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	ff 75 0c             	pushl  0xc(%ebp)
  800da2:	ff 75 20             	pushl  0x20(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	ff d0                	call   *%eax
  800daa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dad:	ff 4d 1c             	decl   0x1c(%ebp)
  800db0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800db4:	7f e6                	jg     800d9c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800db6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800db9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc4:	53                   	push   %ebx
  800dc5:	51                   	push   %ecx
  800dc6:	52                   	push   %edx
  800dc7:	50                   	push   %eax
  800dc8:	e8 f3 2d 00 00       	call   803bc0 <__umoddi3>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	05 b4 42 80 00       	add    $0x8042b4,%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f be c0             	movsbl %al,%eax
  800dda:	83 ec 08             	sub    $0x8,%esp
  800ddd:	ff 75 0c             	pushl  0xc(%ebp)
  800de0:	50                   	push   %eax
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	ff d0                	call   *%eax
  800de6:	83 c4 10             	add    $0x10,%esp
}
  800de9:	90                   	nop
  800dea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ded:	c9                   	leave  
  800dee:	c3                   	ret    

00800def <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800df2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800df6:	7e 1c                	jle    800e14 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8b 00                	mov    (%eax),%eax
  800dfd:	8d 50 08             	lea    0x8(%eax),%edx
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	89 10                	mov    %edx,(%eax)
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8b 00                	mov    (%eax),%eax
  800e0a:	83 e8 08             	sub    $0x8,%eax
  800e0d:	8b 50 04             	mov    0x4(%eax),%edx
  800e10:	8b 00                	mov    (%eax),%eax
  800e12:	eb 40                	jmp    800e54 <getuint+0x65>
	else if (lflag)
  800e14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e18:	74 1e                	je     800e38 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8b 00                	mov    (%eax),%eax
  800e1f:	8d 50 04             	lea    0x4(%eax),%edx
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	89 10                	mov    %edx,(%eax)
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8b 00                	mov    (%eax),%eax
  800e2c:	83 e8 04             	sub    $0x4,%eax
  800e2f:	8b 00                	mov    (%eax),%eax
  800e31:	ba 00 00 00 00       	mov    $0x0,%edx
  800e36:	eb 1c                	jmp    800e54 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	8b 00                	mov    (%eax),%eax
  800e3d:	8d 50 04             	lea    0x4(%eax),%edx
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	89 10                	mov    %edx,(%eax)
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8b 00                	mov    (%eax),%eax
  800e4a:	83 e8 04             	sub    $0x4,%eax
  800e4d:	8b 00                	mov    (%eax),%eax
  800e4f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    

00800e56 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e59:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e5d:	7e 1c                	jle    800e7b <getint+0x25>
		return va_arg(*ap, long long);
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8b 00                	mov    (%eax),%eax
  800e64:	8d 50 08             	lea    0x8(%eax),%edx
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	89 10                	mov    %edx,(%eax)
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8b 00                	mov    (%eax),%eax
  800e71:	83 e8 08             	sub    $0x8,%eax
  800e74:	8b 50 04             	mov    0x4(%eax),%edx
  800e77:	8b 00                	mov    (%eax),%eax
  800e79:	eb 38                	jmp    800eb3 <getint+0x5d>
	else if (lflag)
  800e7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7f:	74 1a                	je     800e9b <getint+0x45>
		return va_arg(*ap, long);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8b 00                	mov    (%eax),%eax
  800e86:	8d 50 04             	lea    0x4(%eax),%edx
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	89 10                	mov    %edx,(%eax)
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8b 00                	mov    (%eax),%eax
  800e93:	83 e8 04             	sub    $0x4,%eax
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	99                   	cltd   
  800e99:	eb 18                	jmp    800eb3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	8d 50 04             	lea    0x4(%eax),%edx
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	89 10                	mov    %edx,(%eax)
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	83 e8 04             	sub    $0x4,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	99                   	cltd   
}
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    

00800eb5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
  800eba:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ebd:	eb 17                	jmp    800ed6 <vprintfmt+0x21>
			if (ch == '\0')
  800ebf:	85 db                	test   %ebx,%ebx
  800ec1:	0f 84 af 03 00 00    	je     801276 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	ff 75 0c             	pushl  0xc(%ebp)
  800ecd:	53                   	push   %ebx
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	ff d0                	call   *%eax
  800ed3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 10             	mov    %edx,0x10(%ebp)
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	0f b6 d8             	movzbl %al,%ebx
  800ee4:	83 fb 25             	cmp    $0x25,%ebx
  800ee7:	75 d6                	jne    800ebf <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ee9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800eed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ef4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800efb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f02:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	8d 50 01             	lea    0x1(%eax),%edx
  800f0f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	0f b6 d8             	movzbl %al,%ebx
  800f17:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f1a:	83 f8 55             	cmp    $0x55,%eax
  800f1d:	0f 87 2b 03 00 00    	ja     80124e <vprintfmt+0x399>
  800f23:	8b 04 85 d8 42 80 00 	mov    0x8042d8(,%eax,4),%eax
  800f2a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f2c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f30:	eb d7                	jmp    800f09 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f32:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f36:	eb d1                	jmp    800f09 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f42:	89 d0                	mov    %edx,%eax
  800f44:	c1 e0 02             	shl    $0x2,%eax
  800f47:	01 d0                	add    %edx,%eax
  800f49:	01 c0                	add    %eax,%eax
  800f4b:	01 d8                	add    %ebx,%eax
  800f4d:	83 e8 30             	sub    $0x30,%eax
  800f50:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f5b:	83 fb 2f             	cmp    $0x2f,%ebx
  800f5e:	7e 3e                	jle    800f9e <vprintfmt+0xe9>
  800f60:	83 fb 39             	cmp    $0x39,%ebx
  800f63:	7f 39                	jg     800f9e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f65:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f68:	eb d5                	jmp    800f3f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 c0 04             	add    $0x4,%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax
  800f7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f7e:	eb 1f                	jmp    800f9f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f84:	79 83                	jns    800f09 <vprintfmt+0x54>
				width = 0;
  800f86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f8d:	e9 77 ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f92:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f99:	e9 6b ff ff ff       	jmp    800f09 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f9e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa3:	0f 89 60 ff ff ff    	jns    800f09 <vprintfmt+0x54>
				width = precision, precision = -1;
  800fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800faf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fb6:	e9 4e ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fbb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fbe:	e9 46 ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800fcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcf:	83 e8 04             	sub    $0x4,%eax
  800fd2:	8b 00                	mov    (%eax),%eax
  800fd4:	83 ec 08             	sub    $0x8,%esp
  800fd7:	ff 75 0c             	pushl  0xc(%ebp)
  800fda:	50                   	push   %eax
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	ff d0                	call   *%eax
  800fe0:	83 c4 10             	add    $0x10,%esp
			break;
  800fe3:	e9 89 02 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800fe8:	8b 45 14             	mov    0x14(%ebp),%eax
  800feb:	83 c0 04             	add    $0x4,%eax
  800fee:	89 45 14             	mov    %eax,0x14(%ebp)
  800ff1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff4:	83 e8 04             	sub    $0x4,%eax
  800ff7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ff9:	85 db                	test   %ebx,%ebx
  800ffb:	79 02                	jns    800fff <vprintfmt+0x14a>
				err = -err;
  800ffd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800fff:	83 fb 64             	cmp    $0x64,%ebx
  801002:	7f 0b                	jg     80100f <vprintfmt+0x15a>
  801004:	8b 34 9d 20 41 80 00 	mov    0x804120(,%ebx,4),%esi
  80100b:	85 f6                	test   %esi,%esi
  80100d:	75 19                	jne    801028 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80100f:	53                   	push   %ebx
  801010:	68 c5 42 80 00       	push   $0x8042c5
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	ff 75 08             	pushl  0x8(%ebp)
  80101b:	e8 5e 02 00 00       	call   80127e <printfmt>
  801020:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801023:	e9 49 02 00 00       	jmp    801271 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801028:	56                   	push   %esi
  801029:	68 ce 42 80 00       	push   $0x8042ce
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	ff 75 08             	pushl  0x8(%ebp)
  801034:	e8 45 02 00 00       	call   80127e <printfmt>
  801039:	83 c4 10             	add    $0x10,%esp
			break;
  80103c:	e9 30 02 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801041:	8b 45 14             	mov    0x14(%ebp),%eax
  801044:	83 c0 04             	add    $0x4,%eax
  801047:	89 45 14             	mov    %eax,0x14(%ebp)
  80104a:	8b 45 14             	mov    0x14(%ebp),%eax
  80104d:	83 e8 04             	sub    $0x4,%eax
  801050:	8b 30                	mov    (%eax),%esi
  801052:	85 f6                	test   %esi,%esi
  801054:	75 05                	jne    80105b <vprintfmt+0x1a6>
				p = "(null)";
  801056:	be d1 42 80 00       	mov    $0x8042d1,%esi
			if (width > 0 && padc != '-')
  80105b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80105f:	7e 6d                	jle    8010ce <vprintfmt+0x219>
  801061:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801065:	74 67                	je     8010ce <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801067:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	50                   	push   %eax
  80106e:	56                   	push   %esi
  80106f:	e8 0c 03 00 00       	call   801380 <strnlen>
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80107a:	eb 16                	jmp    801092 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80107c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801080:	83 ec 08             	sub    $0x8,%esp
  801083:	ff 75 0c             	pushl  0xc(%ebp)
  801086:	50                   	push   %eax
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	ff d0                	call   *%eax
  80108c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80108f:	ff 4d e4             	decl   -0x1c(%ebp)
  801092:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801096:	7f e4                	jg     80107c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801098:	eb 34                	jmp    8010ce <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80109a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80109e:	74 1c                	je     8010bc <vprintfmt+0x207>
  8010a0:	83 fb 1f             	cmp    $0x1f,%ebx
  8010a3:	7e 05                	jle    8010aa <vprintfmt+0x1f5>
  8010a5:	83 fb 7e             	cmp    $0x7e,%ebx
  8010a8:	7e 12                	jle    8010bc <vprintfmt+0x207>
					putch('?', putdat);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	6a 3f                	push   $0x3f
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	eb 0f                	jmp    8010cb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010bc:	83 ec 08             	sub    $0x8,%esp
  8010bf:	ff 75 0c             	pushl  0xc(%ebp)
  8010c2:	53                   	push   %ebx
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	ff d0                	call   *%eax
  8010c8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010cb:	ff 4d e4             	decl   -0x1c(%ebp)
  8010ce:	89 f0                	mov    %esi,%eax
  8010d0:	8d 70 01             	lea    0x1(%eax),%esi
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	0f be d8             	movsbl %al,%ebx
  8010d8:	85 db                	test   %ebx,%ebx
  8010da:	74 24                	je     801100 <vprintfmt+0x24b>
  8010dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010e0:	78 b8                	js     80109a <vprintfmt+0x1e5>
  8010e2:	ff 4d e0             	decl   -0x20(%ebp)
  8010e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010e9:	79 af                	jns    80109a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010eb:	eb 13                	jmp    801100 <vprintfmt+0x24b>
				putch(' ', putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	6a 20                	push   $0x20
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	ff d0                	call   *%eax
  8010fa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010fd:	ff 4d e4             	decl   -0x1c(%ebp)
  801100:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801104:	7f e7                	jg     8010ed <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801106:	e9 66 01 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 e8             	pushl  -0x18(%ebp)
  801111:	8d 45 14             	lea    0x14(%ebp),%eax
  801114:	50                   	push   %eax
  801115:	e8 3c fd ff ff       	call   800e56 <getint>
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801120:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801129:	85 d2                	test   %edx,%edx
  80112b:	79 23                	jns    801150 <vprintfmt+0x29b>
				putch('-', putdat);
  80112d:	83 ec 08             	sub    $0x8,%esp
  801130:	ff 75 0c             	pushl  0xc(%ebp)
  801133:	6a 2d                	push   $0x2d
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	ff d0                	call   *%eax
  80113a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80113d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	f7 d8                	neg    %eax
  801145:	83 d2 00             	adc    $0x0,%edx
  801148:	f7 da                	neg    %edx
  80114a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80114d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801150:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801157:	e9 bc 00 00 00       	jmp    801218 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	ff 75 e8             	pushl  -0x18(%ebp)
  801162:	8d 45 14             	lea    0x14(%ebp),%eax
  801165:	50                   	push   %eax
  801166:	e8 84 fc ff ff       	call   800def <getuint>
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801171:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801174:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80117b:	e9 98 00 00 00       	jmp    801218 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801180:	83 ec 08             	sub    $0x8,%esp
  801183:	ff 75 0c             	pushl  0xc(%ebp)
  801186:	6a 58                	push   $0x58
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	ff d0                	call   *%eax
  80118d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801190:	83 ec 08             	sub    $0x8,%esp
  801193:	ff 75 0c             	pushl  0xc(%ebp)
  801196:	6a 58                	push   $0x58
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	ff d0                	call   *%eax
  80119d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011a0:	83 ec 08             	sub    $0x8,%esp
  8011a3:	ff 75 0c             	pushl  0xc(%ebp)
  8011a6:	6a 58                	push   $0x58
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	ff d0                	call   *%eax
  8011ad:	83 c4 10             	add    $0x10,%esp
			break;
  8011b0:	e9 bc 00 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8011b5:	83 ec 08             	sub    $0x8,%esp
  8011b8:	ff 75 0c             	pushl  0xc(%ebp)
  8011bb:	6a 30                	push   $0x30
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	ff d0                	call   *%eax
  8011c2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 0c             	pushl  0xc(%ebp)
  8011cb:	6a 78                	push   $0x78
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	ff d0                	call   *%eax
  8011d2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d8:	83 c0 04             	add    $0x4,%eax
  8011db:	89 45 14             	mov    %eax,0x14(%ebp)
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	83 e8 04             	sub    $0x4,%eax
  8011e4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011f0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8011f7:	eb 1f                	jmp    801218 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8011f9:	83 ec 08             	sub    $0x8,%esp
  8011fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8011ff:	8d 45 14             	lea    0x14(%ebp),%eax
  801202:	50                   	push   %eax
  801203:	e8 e7 fb ff ff       	call   800def <getuint>
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80120e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801211:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801218:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80121c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	52                   	push   %edx
  801223:	ff 75 e4             	pushl  -0x1c(%ebp)
  801226:	50                   	push   %eax
  801227:	ff 75 f4             	pushl  -0xc(%ebp)
  80122a:	ff 75 f0             	pushl  -0x10(%ebp)
  80122d:	ff 75 0c             	pushl  0xc(%ebp)
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 00 fb ff ff       	call   800d38 <printnum>
  801238:	83 c4 20             	add    $0x20,%esp
			break;
  80123b:	eb 34                	jmp    801271 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80123d:	83 ec 08             	sub    $0x8,%esp
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	53                   	push   %ebx
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	ff d0                	call   *%eax
  801249:	83 c4 10             	add    $0x10,%esp
			break;
  80124c:	eb 23                	jmp    801271 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80124e:	83 ec 08             	sub    $0x8,%esp
  801251:	ff 75 0c             	pushl  0xc(%ebp)
  801254:	6a 25                	push   $0x25
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	ff d0                	call   *%eax
  80125b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80125e:	ff 4d 10             	decl   0x10(%ebp)
  801261:	eb 03                	jmp    801266 <vprintfmt+0x3b1>
  801263:	ff 4d 10             	decl   0x10(%ebp)
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	48                   	dec    %eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 25                	cmp    $0x25,%al
  80126e:	75 f3                	jne    801263 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801270:	90                   	nop
		}
	}
  801271:	e9 47 fc ff ff       	jmp    800ebd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801276:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801277:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80127a:	5b                   	pop    %ebx
  80127b:	5e                   	pop    %esi
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    

0080127e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801284:	8d 45 10             	lea    0x10(%ebp),%eax
  801287:	83 c0 04             	add    $0x4,%eax
  80128a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80128d:	8b 45 10             	mov    0x10(%ebp),%eax
  801290:	ff 75 f4             	pushl  -0xc(%ebp)
  801293:	50                   	push   %eax
  801294:	ff 75 0c             	pushl  0xc(%ebp)
  801297:	ff 75 08             	pushl  0x8(%ebp)
  80129a:	e8 16 fc ff ff       	call   800eb5 <vprintfmt>
  80129f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012a2:	90                   	nop
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ab:	8b 40 08             	mov    0x8(%eax),%eax
  8012ae:	8d 50 01             	lea    0x1(%eax),%edx
  8012b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	8b 10                	mov    (%eax),%edx
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	8b 40 04             	mov    0x4(%eax),%eax
  8012c2:	39 c2                	cmp    %eax,%edx
  8012c4:	73 12                	jae    8012d8 <sprintputch+0x33>
		*b->buf++ = ch;
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	8b 00                	mov    (%eax),%eax
  8012cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d1:	89 0a                	mov    %ecx,(%edx)
  8012d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d6:	88 10                	mov    %dl,(%eax)
}
  8012d8:	90                   	nop
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    

008012db <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	01 d0                	add    %edx,%eax
  8012f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801300:	74 06                	je     801308 <vsnprintf+0x2d>
  801302:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801306:	7f 07                	jg     80130f <vsnprintf+0x34>
		return -E_INVAL;
  801308:	b8 03 00 00 00       	mov    $0x3,%eax
  80130d:	eb 20                	jmp    80132f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80130f:	ff 75 14             	pushl  0x14(%ebp)
  801312:	ff 75 10             	pushl  0x10(%ebp)
  801315:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801318:	50                   	push   %eax
  801319:	68 a5 12 80 00       	push   $0x8012a5
  80131e:	e8 92 fb ff ff       	call   800eb5 <vprintfmt>
  801323:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801326:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801329:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80132c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801337:	8d 45 10             	lea    0x10(%ebp),%eax
  80133a:	83 c0 04             	add    $0x4,%eax
  80133d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	ff 75 f4             	pushl  -0xc(%ebp)
  801346:	50                   	push   %eax
  801347:	ff 75 0c             	pushl  0xc(%ebp)
  80134a:	ff 75 08             	pushl  0x8(%ebp)
  80134d:	e8 89 ff ff ff       	call   8012db <vsnprintf>
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801358:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801363:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136a:	eb 06                	jmp    801372 <strlen+0x15>
		n++;
  80136c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80136f:	ff 45 08             	incl   0x8(%ebp)
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	84 c0                	test   %al,%al
  801379:	75 f1                	jne    80136c <strlen+0xf>
		n++;
	return n;
  80137b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 09                	jmp    801398 <strnlen+0x18>
		n++;
  80138f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801392:	ff 45 08             	incl   0x8(%ebp)
  801395:	ff 4d 0c             	decl   0xc(%ebp)
  801398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80139c:	74 09                	je     8013a7 <strnlen+0x27>
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	84 c0                	test   %al,%al
  8013a5:	75 e8                	jne    80138f <strnlen+0xf>
		n++;
	return n;
  8013a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013b8:	90                   	nop
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8d 50 01             	lea    0x1(%eax),%edx
  8013bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013cb:	8a 12                	mov    (%edx),%dl
  8013cd:	88 10                	mov    %dl,(%eax)
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	84 c0                	test   %al,%al
  8013d3:	75 e4                	jne    8013b9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ed:	eb 1f                	jmp    80140e <strncpy+0x34>
		*dst++ = *src;
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8d 50 01             	lea    0x1(%eax),%edx
  8013f5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fb:	8a 12                	mov    (%edx),%dl
  8013fd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	84 c0                	test   %al,%al
  801406:	74 03                	je     80140b <strncpy+0x31>
			src++;
  801408:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
  80140e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801411:	3b 45 10             	cmp    0x10(%ebp),%eax
  801414:	72 d9                	jb     8013ef <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801416:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142b:	74 30                	je     80145d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80142d:	eb 16                	jmp    801445 <strlcpy+0x2a>
			*dst++ = *src++;
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8d 50 01             	lea    0x1(%eax),%edx
  801435:	89 55 08             	mov    %edx,0x8(%ebp)
  801438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80143e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801441:	8a 12                	mov    (%edx),%dl
  801443:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801445:	ff 4d 10             	decl   0x10(%ebp)
  801448:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144c:	74 09                	je     801457 <strlcpy+0x3c>
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	75 d8                	jne    80142f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80145d:	8b 55 08             	mov    0x8(%ebp),%edx
  801460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801463:	29 c2                	sub    %eax,%edx
  801465:	89 d0                	mov    %edx,%eax
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80146c:	eb 06                	jmp    801474 <strcmp+0xb>
		p++, q++;
  80146e:	ff 45 08             	incl   0x8(%ebp)
  801471:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	84 c0                	test   %al,%al
  80147b:	74 0e                	je     80148b <strcmp+0x22>
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 10                	mov    (%eax),%dl
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	38 c2                	cmp    %al,%dl
  801489:	74 e3                	je     80146e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f b6 d0             	movzbl %al,%edx
  801493:	8b 45 0c             	mov    0xc(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	0f b6 c0             	movzbl %al,%eax
  80149b:	29 c2                	sub    %eax,%edx
  80149d:	89 d0                	mov    %edx,%eax
}
  80149f:	5d                   	pop    %ebp
  8014a0:	c3                   	ret    

008014a1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014a4:	eb 09                	jmp    8014af <strncmp+0xe>
		n--, p++, q++;
  8014a6:	ff 4d 10             	decl   0x10(%ebp)
  8014a9:	ff 45 08             	incl   0x8(%ebp)
  8014ac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b3:	74 17                	je     8014cc <strncmp+0x2b>
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 0e                	je     8014cc <strncmp+0x2b>
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	38 c2                	cmp    %al,%dl
  8014ca:	74 da                	je     8014a6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d0:	75 07                	jne    8014d9 <strncmp+0x38>
		return 0;
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	eb 14                	jmp    8014ed <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8a 00                	mov    (%eax),%al
  8014de:	0f b6 d0             	movzbl %al,%edx
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	0f b6 c0             	movzbl %al,%eax
  8014e9:	29 c2                	sub    %eax,%edx
  8014eb:	89 d0                	mov    %edx,%eax
}
  8014ed:	5d                   	pop    %ebp
  8014ee:	c3                   	ret    

008014ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014fb:	eb 12                	jmp    80150f <strchr+0x20>
		if (*s == c)
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801505:	75 05                	jne    80150c <strchr+0x1d>
			return (char *) s;
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	eb 11                	jmp    80151d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80150c:	ff 45 08             	incl   0x8(%ebp)
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	84 c0                	test   %al,%al
  801516:	75 e5                	jne    8014fd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80152b:	eb 0d                	jmp    80153a <strfind+0x1b>
		if (*s == c)
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801535:	74 0e                	je     801545 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	84 c0                	test   %al,%al
  801541:	75 ea                	jne    80152d <strfind+0xe>
  801543:	eb 01                	jmp    801546 <strfind+0x27>
		if (*s == c)
			break;
  801545:	90                   	nop
	return (char *) s;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801557:	8b 45 10             	mov    0x10(%ebp),%eax
  80155a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80155d:	eb 0e                	jmp    80156d <memset+0x22>
		*p++ = c;
  80155f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801562:	8d 50 01             	lea    0x1(%eax),%edx
  801565:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80156d:	ff 4d f8             	decl   -0x8(%ebp)
  801570:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801574:	79 e9                	jns    80155f <memset+0x14>
		*p++ = c;

	return v;
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80158d:	eb 16                	jmp    8015a5 <memcpy+0x2a>
		*d++ = *s++;
  80158f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801592:	8d 50 01             	lea    0x1(%eax),%edx
  801595:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801598:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80159e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015a1:	8a 12                	mov    (%edx),%dl
  8015a3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8015a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	75 dd                	jne    80158f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015cf:	73 50                	jae    801621 <memmove+0x6a>
  8015d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d7:	01 d0                	add    %edx,%eax
  8015d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015dc:	76 43                	jbe    801621 <memmove+0x6a>
		s += n;
  8015de:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015ea:	eb 10                	jmp    8015fc <memmove+0x45>
			*--d = *--s;
  8015ec:	ff 4d f8             	decl   -0x8(%ebp)
  8015ef:	ff 4d fc             	decl   -0x4(%ebp)
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f5:	8a 10                	mov    (%eax),%dl
  8015f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fa:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801602:	89 55 10             	mov    %edx,0x10(%ebp)
  801605:	85 c0                	test   %eax,%eax
  801607:	75 e3                	jne    8015ec <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801609:	eb 23                	jmp    80162e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	8d 50 ff             	lea    -0x1(%eax),%edx
  801627:	89 55 10             	mov    %edx,0x10(%ebp)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	75 dd                	jne    80160b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80163f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801642:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801645:	eb 2a                	jmp    801671 <memcmp+0x3e>
		if (*s1 != *s2)
  801647:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164a:	8a 10                	mov    (%eax),%dl
  80164c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	38 c2                	cmp    %al,%dl
  801653:	74 16                	je     80166b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801655:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	0f b6 d0             	movzbl %al,%edx
  80165d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f b6 c0             	movzbl %al,%eax
  801665:	29 c2                	sub    %eax,%edx
  801667:	89 d0                	mov    %edx,%eax
  801669:	eb 18                	jmp    801683 <memcmp+0x50>
		s1++, s2++;
  80166b:	ff 45 fc             	incl   -0x4(%ebp)
  80166e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801671:	8b 45 10             	mov    0x10(%ebp),%eax
  801674:	8d 50 ff             	lea    -0x1(%eax),%edx
  801677:	89 55 10             	mov    %edx,0x10(%ebp)
  80167a:	85 c0                	test   %eax,%eax
  80167c:	75 c9                	jne    801647 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80167e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80168b:	8b 55 08             	mov    0x8(%ebp),%edx
  80168e:	8b 45 10             	mov    0x10(%ebp),%eax
  801691:	01 d0                	add    %edx,%eax
  801693:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801696:	eb 15                	jmp    8016ad <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f b6 d0             	movzbl %al,%edx
  8016a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a3:	0f b6 c0             	movzbl %al,%eax
  8016a6:	39 c2                	cmp    %eax,%edx
  8016a8:	74 0d                	je     8016b7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016aa:	ff 45 08             	incl   0x8(%ebp)
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016b3:	72 e3                	jb     801698 <memfind+0x13>
  8016b5:	eb 01                	jmp    8016b8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016b7:	90                   	nop
	return (void *) s;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d1:	eb 03                	jmp    8016d6 <strtol+0x19>
		s++;
  8016d3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	3c 20                	cmp    $0x20,%al
  8016dd:	74 f4                	je     8016d3 <strtol+0x16>
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	3c 09                	cmp    $0x9,%al
  8016e6:	74 eb                	je     8016d3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	3c 2b                	cmp    $0x2b,%al
  8016ef:	75 05                	jne    8016f6 <strtol+0x39>
		s++;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	eb 13                	jmp    801709 <strtol+0x4c>
	else if (*s == '-')
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	3c 2d                	cmp    $0x2d,%al
  8016fd:	75 0a                	jne    801709 <strtol+0x4c>
		s++, neg = 1;
  8016ff:	ff 45 08             	incl   0x8(%ebp)
  801702:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801709:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80170d:	74 06                	je     801715 <strtol+0x58>
  80170f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801713:	75 20                	jne    801735 <strtol+0x78>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	3c 30                	cmp    $0x30,%al
  80171c:	75 17                	jne    801735 <strtol+0x78>
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	40                   	inc    %eax
  801722:	8a 00                	mov    (%eax),%al
  801724:	3c 78                	cmp    $0x78,%al
  801726:	75 0d                	jne    801735 <strtol+0x78>
		s += 2, base = 16;
  801728:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80172c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801733:	eb 28                	jmp    80175d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801735:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801739:	75 15                	jne    801750 <strtol+0x93>
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8a 00                	mov    (%eax),%al
  801740:	3c 30                	cmp    $0x30,%al
  801742:	75 0c                	jne    801750 <strtol+0x93>
		s++, base = 8;
  801744:	ff 45 08             	incl   0x8(%ebp)
  801747:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80174e:	eb 0d                	jmp    80175d <strtol+0xa0>
	else if (base == 0)
  801750:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801754:	75 07                	jne    80175d <strtol+0xa0>
		base = 10;
  801756:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	3c 2f                	cmp    $0x2f,%al
  801764:	7e 19                	jle    80177f <strtol+0xc2>
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	8a 00                	mov    (%eax),%al
  80176b:	3c 39                	cmp    $0x39,%al
  80176d:	7f 10                	jg     80177f <strtol+0xc2>
			dig = *s - '0';
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	0f be c0             	movsbl %al,%eax
  801777:	83 e8 30             	sub    $0x30,%eax
  80177a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80177d:	eb 42                	jmp    8017c1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8a 00                	mov    (%eax),%al
  801784:	3c 60                	cmp    $0x60,%al
  801786:	7e 19                	jle    8017a1 <strtol+0xe4>
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	8a 00                	mov    (%eax),%al
  80178d:	3c 7a                	cmp    $0x7a,%al
  80178f:	7f 10                	jg     8017a1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	0f be c0             	movsbl %al,%eax
  801799:	83 e8 57             	sub    $0x57,%eax
  80179c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80179f:	eb 20                	jmp    8017c1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	8a 00                	mov    (%eax),%al
  8017a6:	3c 40                	cmp    $0x40,%al
  8017a8:	7e 39                	jle    8017e3 <strtol+0x126>
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	8a 00                	mov    (%eax),%al
  8017af:	3c 5a                	cmp    $0x5a,%al
  8017b1:	7f 30                	jg     8017e3 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8a 00                	mov    (%eax),%al
  8017b8:	0f be c0             	movsbl %al,%eax
  8017bb:	83 e8 37             	sub    $0x37,%eax
  8017be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017c7:	7d 19                	jge    8017e2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017c9:	ff 45 08             	incl   0x8(%ebp)
  8017cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017cf:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017d3:	89 c2                	mov    %eax,%edx
  8017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017dd:	e9 7b ff ff ff       	jmp    80175d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017e2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017e7:	74 08                	je     8017f1 <strtol+0x134>
		*endptr = (char *) s;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ef:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017f5:	74 07                	je     8017fe <strtol+0x141>
  8017f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fa:	f7 d8                	neg    %eax
  8017fc:	eb 03                	jmp    801801 <strtol+0x144>
  8017fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <ltostr>:

void
ltostr(long value, char *str)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801809:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801810:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801817:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80181b:	79 13                	jns    801830 <ltostr+0x2d>
	{
		neg = 1;
  80181d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80182a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80182d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801838:	99                   	cltd   
  801839:	f7 f9                	idiv   %ecx
  80183b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80183e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801841:	8d 50 01             	lea    0x1(%eax),%edx
  801844:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801847:	89 c2                	mov    %eax,%edx
  801849:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184c:	01 d0                	add    %edx,%eax
  80184e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801851:	83 c2 30             	add    $0x30,%edx
  801854:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801856:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801859:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80185e:	f7 e9                	imul   %ecx
  801860:	c1 fa 02             	sar    $0x2,%edx
  801863:	89 c8                	mov    %ecx,%eax
  801865:	c1 f8 1f             	sar    $0x1f,%eax
  801868:	29 c2                	sub    %eax,%edx
  80186a:	89 d0                	mov    %edx,%eax
  80186c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80186f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801872:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801877:	f7 e9                	imul   %ecx
  801879:	c1 fa 02             	sar    $0x2,%edx
  80187c:	89 c8                	mov    %ecx,%eax
  80187e:	c1 f8 1f             	sar    $0x1f,%eax
  801881:	29 c2                	sub    %eax,%edx
  801883:	89 d0                	mov    %edx,%eax
  801885:	c1 e0 02             	shl    $0x2,%eax
  801888:	01 d0                	add    %edx,%eax
  80188a:	01 c0                	add    %eax,%eax
  80188c:	29 c1                	sub    %eax,%ecx
  80188e:	89 ca                	mov    %ecx,%edx
  801890:	85 d2                	test   %edx,%edx
  801892:	75 9c                	jne    801830 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801894:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80189b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189e:	48                   	dec    %eax
  80189f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018a6:	74 3d                	je     8018e5 <ltostr+0xe2>
		start = 1 ;
  8018a8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018af:	eb 34                	jmp    8018e5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8018b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b7:	01 d0                	add    %edx,%eax
  8018b9:	8a 00                	mov    (%eax),%al
  8018bb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	01 c2                	add    %eax,%edx
  8018c6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	01 c8                	add    %ecx,%eax
  8018ce:	8a 00                	mov    (%eax),%al
  8018d0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d8:	01 c2                	add    %eax,%edx
  8018da:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018dd:	88 02                	mov    %al,(%edx)
		start++ ;
  8018df:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018e2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018eb:	7c c4                	jl     8018b1 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018ed:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f3:	01 d0                	add    %edx,%eax
  8018f5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018f8:	90                   	nop
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	e8 54 fa ff ff       	call   80135d <strlen>
  801909:	83 c4 04             	add    $0x4,%esp
  80190c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	e8 46 fa ff ff       	call   80135d <strlen>
  801917:	83 c4 04             	add    $0x4,%esp
  80191a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80191d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801924:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192b:	eb 17                	jmp    801944 <strcconcat+0x49>
		final[s] = str1[s] ;
  80192d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801930:	8b 45 10             	mov    0x10(%ebp),%eax
  801933:	01 c2                	add    %eax,%edx
  801935:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	01 c8                	add    %ecx,%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801941:	ff 45 fc             	incl   -0x4(%ebp)
  801944:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801947:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80194a:	7c e1                	jl     80192d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80194c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801953:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80195a:	eb 1f                	jmp    80197b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80195f:	8d 50 01             	lea    0x1(%eax),%edx
  801962:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801965:	89 c2                	mov    %eax,%edx
  801967:	8b 45 10             	mov    0x10(%ebp),%eax
  80196a:	01 c2                	add    %eax,%edx
  80196c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80196f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801972:	01 c8                	add    %ecx,%eax
  801974:	8a 00                	mov    (%eax),%al
  801976:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801978:	ff 45 f8             	incl   -0x8(%ebp)
  80197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801981:	7c d9                	jl     80195c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801983:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801986:	8b 45 10             	mov    0x10(%ebp),%eax
  801989:	01 d0                	add    %edx,%eax
  80198b:	c6 00 00             	movb   $0x0,(%eax)
}
  80198e:	90                   	nop
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801994:	8b 45 14             	mov    0x14(%ebp),%eax
  801997:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80199d:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a0:	8b 00                	mov    (%eax),%eax
  8019a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ac:	01 d0                	add    %edx,%eax
  8019ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019b4:	eb 0c                	jmp    8019c2 <strsplit+0x31>
			*string++ = 0;
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8d 50 01             	lea    0x1(%eax),%edx
  8019bc:	89 55 08             	mov    %edx,0x8(%ebp)
  8019bf:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	8a 00                	mov    (%eax),%al
  8019c7:	84 c0                	test   %al,%al
  8019c9:	74 18                	je     8019e3 <strsplit+0x52>
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	8a 00                	mov    (%eax),%al
  8019d0:	0f be c0             	movsbl %al,%eax
  8019d3:	50                   	push   %eax
  8019d4:	ff 75 0c             	pushl  0xc(%ebp)
  8019d7:	e8 13 fb ff ff       	call   8014ef <strchr>
  8019dc:	83 c4 08             	add    $0x8,%esp
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	75 d3                	jne    8019b6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	8a 00                	mov    (%eax),%al
  8019e8:	84 c0                	test   %al,%al
  8019ea:	74 5a                	je     801a46 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ef:	8b 00                	mov    (%eax),%eax
  8019f1:	83 f8 0f             	cmp    $0xf,%eax
  8019f4:	75 07                	jne    8019fd <strsplit+0x6c>
		{
			return 0;
  8019f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fb:	eb 66                	jmp    801a63 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8019fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801a00:	8b 00                	mov    (%eax),%eax
  801a02:	8d 48 01             	lea    0x1(%eax),%ecx
  801a05:	8b 55 14             	mov    0x14(%ebp),%edx
  801a08:	89 0a                	mov    %ecx,(%edx)
  801a0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a11:	8b 45 10             	mov    0x10(%ebp),%eax
  801a14:	01 c2                	add    %eax,%edx
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a1b:	eb 03                	jmp    801a20 <strsplit+0x8f>
			string++;
  801a1d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	84 c0                	test   %al,%al
  801a27:	74 8b                	je     8019b4 <strsplit+0x23>
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	0f be c0             	movsbl %al,%eax
  801a31:	50                   	push   %eax
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	e8 b5 fa ff ff       	call   8014ef <strchr>
  801a3a:	83 c4 08             	add    $0x8,%esp
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	74 dc                	je     801a1d <strsplit+0x8c>
			string++;
	}
  801a41:	e9 6e ff ff ff       	jmp    8019b4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a46:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a47:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4a:	8b 00                	mov    (%eax),%eax
  801a4c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a53:	8b 45 10             	mov    0x10(%ebp),%eax
  801a56:	01 d0                	add    %edx,%eax
  801a58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a5e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801a6b:	a1 04 50 80 00       	mov    0x805004,%eax
  801a70:	85 c0                	test   %eax,%eax
  801a72:	74 1f                	je     801a93 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801a74:	e8 1d 00 00 00       	call   801a96 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801a79:	83 ec 0c             	sub    $0xc,%esp
  801a7c:	68 30 44 80 00       	push   $0x804430
  801a81:	e8 55 f2 ff ff       	call   800cdb <cprintf>
  801a86:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801a89:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801a90:	00 00 00 
	}
}
  801a93:	90                   	nop
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801a9c:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801aa3:	00 00 00 
  801aa6:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801aad:	00 00 00 
  801ab0:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801ab7:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801aba:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801ac1:	00 00 00 
  801ac4:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801acb:	00 00 00 
  801ace:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801ad5:	00 00 00 
	uint32 arr_size = 0;
  801ad8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801adf:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801aee:	2d 00 10 00 00       	sub    $0x1000,%eax
  801af3:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801af8:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801aff:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801b02:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b09:	a1 20 51 80 00       	mov    0x805120,%eax
  801b0e:	c1 e0 04             	shl    $0x4,%eax
  801b11:	89 c2                	mov    %eax,%edx
  801b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b16:	01 d0                	add    %edx,%eax
  801b18:	48                   	dec    %eax
  801b19:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b24:	f7 75 ec             	divl   -0x14(%ebp)
  801b27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b2a:	29 d0                	sub    %edx,%eax
  801b2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801b2f:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801b36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b3e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b43:	83 ec 04             	sub    $0x4,%esp
  801b46:	6a 06                	push   $0x6
  801b48:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4b:	50                   	push   %eax
  801b4c:	e8 1d 04 00 00       	call   801f6e <sys_allocate_chunk>
  801b51:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801b54:	a1 20 51 80 00       	mov    0x805120,%eax
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	50                   	push   %eax
  801b5d:	e8 92 0a 00 00       	call   8025f4 <initialize_MemBlocksList>
  801b62:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801b65:	a1 48 51 80 00       	mov    0x805148,%eax
  801b6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801b6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b70:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b7a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801b81:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b85:	75 14                	jne    801b9b <initialize_dyn_block_system+0x105>
  801b87:	83 ec 04             	sub    $0x4,%esp
  801b8a:	68 55 44 80 00       	push   $0x804455
  801b8f:	6a 33                	push   $0x33
  801b91:	68 73 44 80 00       	push   $0x804473
  801b96:	e8 8c ee ff ff       	call   800a27 <_panic>
  801b9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b9e:	8b 00                	mov    (%eax),%eax
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	74 10                	je     801bb4 <initialize_dyn_block_system+0x11e>
  801ba4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ba7:	8b 00                	mov    (%eax),%eax
  801ba9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bac:	8b 52 04             	mov    0x4(%edx),%edx
  801baf:	89 50 04             	mov    %edx,0x4(%eax)
  801bb2:	eb 0b                	jmp    801bbf <initialize_dyn_block_system+0x129>
  801bb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bb7:	8b 40 04             	mov    0x4(%eax),%eax
  801bba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801bbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bc2:	8b 40 04             	mov    0x4(%eax),%eax
  801bc5:	85 c0                	test   %eax,%eax
  801bc7:	74 0f                	je     801bd8 <initialize_dyn_block_system+0x142>
  801bc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bcc:	8b 40 04             	mov    0x4(%eax),%eax
  801bcf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bd2:	8b 12                	mov    (%edx),%edx
  801bd4:	89 10                	mov    %edx,(%eax)
  801bd6:	eb 0a                	jmp    801be2 <initialize_dyn_block_system+0x14c>
  801bd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bdb:	8b 00                	mov    (%eax),%eax
  801bdd:	a3 48 51 80 00       	mov    %eax,0x805148
  801be2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801be5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801beb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801bf5:	a1 54 51 80 00       	mov    0x805154,%eax
  801bfa:	48                   	dec    %eax
  801bfb:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801c00:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c04:	75 14                	jne    801c1a <initialize_dyn_block_system+0x184>
  801c06:	83 ec 04             	sub    $0x4,%esp
  801c09:	68 80 44 80 00       	push   $0x804480
  801c0e:	6a 34                	push   $0x34
  801c10:	68 73 44 80 00       	push   $0x804473
  801c15:	e8 0d ee ff ff       	call   800a27 <_panic>
  801c1a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801c20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c23:	89 10                	mov    %edx,(%eax)
  801c25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c28:	8b 00                	mov    (%eax),%eax
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	74 0d                	je     801c3b <initialize_dyn_block_system+0x1a5>
  801c2e:	a1 38 51 80 00       	mov    0x805138,%eax
  801c33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c36:	89 50 04             	mov    %edx,0x4(%eax)
  801c39:	eb 08                	jmp    801c43 <initialize_dyn_block_system+0x1ad>
  801c3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c3e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801c43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c46:	a3 38 51 80 00       	mov    %eax,0x805138
  801c4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c55:	a1 44 51 80 00       	mov    0x805144,%eax
  801c5a:	40                   	inc    %eax
  801c5b:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801c60:	90                   	nop
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c69:	e8 f7 fd ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c72:	75 07                	jne    801c7b <malloc+0x18>
  801c74:	b8 00 00 00 00       	mov    $0x0,%eax
  801c79:	eb 14                	jmp    801c8f <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801c7b:	83 ec 04             	sub    $0x4,%esp
  801c7e:	68 a4 44 80 00       	push   $0x8044a4
  801c83:	6a 46                	push   $0x46
  801c85:	68 73 44 80 00       	push   $0x804473
  801c8a:	e8 98 ed ff ff       	call   800a27 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801c97:	83 ec 04             	sub    $0x4,%esp
  801c9a:	68 cc 44 80 00       	push   $0x8044cc
  801c9f:	6a 61                	push   $0x61
  801ca1:	68 73 44 80 00       	push   $0x804473
  801ca6:	e8 7c ed ff ff       	call   800a27 <_panic>

00801cab <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 38             	sub    $0x38,%esp
  801cb1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb4:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cb7:	e8 a9 fd ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cc0:	75 07                	jne    801cc9 <smalloc+0x1e>
  801cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc7:	eb 7c                	jmp    801d45 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801cc9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd6:	01 d0                	add    %edx,%eax
  801cd8:	48                   	dec    %eax
  801cd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801cdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cdf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce4:	f7 75 f0             	divl   -0x10(%ebp)
  801ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cea:	29 d0                	sub    %edx,%eax
  801cec:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801cef:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801cf6:	e8 41 06 00 00       	call   80233c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cfb:	85 c0                	test   %eax,%eax
  801cfd:	74 11                	je     801d10 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801cff:	83 ec 0c             	sub    $0xc,%esp
  801d02:	ff 75 e8             	pushl  -0x18(%ebp)
  801d05:	e8 ac 0c 00 00       	call   8029b6 <alloc_block_FF>
  801d0a:	83 c4 10             	add    $0x10,%esp
  801d0d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801d10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d14:	74 2a                	je     801d40 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d19:	8b 40 08             	mov    0x8(%eax),%eax
  801d1c:	89 c2                	mov    %eax,%edx
  801d1e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d22:	52                   	push   %edx
  801d23:	50                   	push   %eax
  801d24:	ff 75 0c             	pushl  0xc(%ebp)
  801d27:	ff 75 08             	pushl  0x8(%ebp)
  801d2a:	e8 92 03 00 00       	call   8020c1 <sys_createSharedObject>
  801d2f:	83 c4 10             	add    $0x10,%esp
  801d32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801d35:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801d39:	74 05                	je     801d40 <smalloc+0x95>
			return (void*)virtual_address;
  801d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d3e:	eb 05                	jmp    801d45 <smalloc+0x9a>
	}
	return NULL;
  801d40:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d4d:	e8 13 fd ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801d52:	83 ec 04             	sub    $0x4,%esp
  801d55:	68 f0 44 80 00       	push   $0x8044f0
  801d5a:	68 a2 00 00 00       	push   $0xa2
  801d5f:	68 73 44 80 00       	push   $0x804473
  801d64:	e8 be ec ff ff       	call   800a27 <_panic>

00801d69 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d6f:	e8 f1 fc ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d74:	83 ec 04             	sub    $0x4,%esp
  801d77:	68 14 45 80 00       	push   $0x804514
  801d7c:	68 e6 00 00 00       	push   $0xe6
  801d81:	68 73 44 80 00       	push   $0x804473
  801d86:	e8 9c ec ff ff       	call   800a27 <_panic>

00801d8b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d91:	83 ec 04             	sub    $0x4,%esp
  801d94:	68 3c 45 80 00       	push   $0x80453c
  801d99:	68 fa 00 00 00       	push   $0xfa
  801d9e:	68 73 44 80 00       	push   $0x804473
  801da3:	e8 7f ec ff ff       	call   800a27 <_panic>

00801da8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dae:	83 ec 04             	sub    $0x4,%esp
  801db1:	68 60 45 80 00       	push   $0x804560
  801db6:	68 05 01 00 00       	push   $0x105
  801dbb:	68 73 44 80 00       	push   $0x804473
  801dc0:	e8 62 ec ff ff       	call   800a27 <_panic>

00801dc5 <shrink>:

}
void shrink(uint32 newSize)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dcb:	83 ec 04             	sub    $0x4,%esp
  801dce:	68 60 45 80 00       	push   $0x804560
  801dd3:	68 0a 01 00 00       	push   $0x10a
  801dd8:	68 73 44 80 00       	push   $0x804473
  801ddd:	e8 45 ec ff ff       	call   800a27 <_panic>

00801de2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801de8:	83 ec 04             	sub    $0x4,%esp
  801deb:	68 60 45 80 00       	push   $0x804560
  801df0:	68 0f 01 00 00       	push   $0x10f
  801df5:	68 73 44 80 00       	push   $0x804473
  801dfa:	e8 28 ec ff ff       	call   800a27 <_panic>

00801dff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	57                   	push   %edi
  801e03:	56                   	push   %esi
  801e04:	53                   	push   %ebx
  801e05:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e11:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e14:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e17:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e1a:	cd 30                	int    $0x30
  801e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e22:	83 c4 10             	add    $0x10,%esp
  801e25:	5b                   	pop    %ebx
  801e26:	5e                   	pop    %esi
  801e27:	5f                   	pop    %edi
  801e28:	5d                   	pop    %ebp
  801e29:	c3                   	ret    

00801e2a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 04             	sub    $0x4,%esp
  801e30:	8b 45 10             	mov    0x10(%ebp),%eax
  801e33:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e36:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	52                   	push   %edx
  801e42:	ff 75 0c             	pushl  0xc(%ebp)
  801e45:	50                   	push   %eax
  801e46:	6a 00                	push   $0x0
  801e48:	e8 b2 ff ff ff       	call   801dff <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
}
  801e50:	90                   	nop
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <sys_cgetc>:

int
sys_cgetc(void)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 01                	push   $0x1
  801e62:	e8 98 ff ff ff       	call   801dff <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	52                   	push   %edx
  801e7c:	50                   	push   %eax
  801e7d:	6a 05                	push   $0x5
  801e7f:	e8 7b ff ff ff       	call   801dff <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	56                   	push   %esi
  801e8d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e8e:	8b 75 18             	mov    0x18(%ebp),%esi
  801e91:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e94:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9d:	56                   	push   %esi
  801e9e:	53                   	push   %ebx
  801e9f:	51                   	push   %ecx
  801ea0:	52                   	push   %edx
  801ea1:	50                   	push   %eax
  801ea2:	6a 06                	push   $0x6
  801ea4:	e8 56 ff ff ff       	call   801dff <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
}
  801eac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eaf:	5b                   	pop    %ebx
  801eb0:	5e                   	pop    %esi
  801eb1:	5d                   	pop    %ebp
  801eb2:	c3                   	ret    

00801eb3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801eb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	52                   	push   %edx
  801ec3:	50                   	push   %eax
  801ec4:	6a 07                	push   $0x7
  801ec6:	e8 34 ff ff ff       	call   801dff <syscall>
  801ecb:	83 c4 18             	add    $0x18,%esp
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	ff 75 0c             	pushl  0xc(%ebp)
  801edc:	ff 75 08             	pushl  0x8(%ebp)
  801edf:	6a 08                	push   $0x8
  801ee1:	e8 19 ff ff ff       	call   801dff <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 09                	push   $0x9
  801efa:	e8 00 ff ff ff       	call   801dff <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
}
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    

00801f04 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 0a                	push   $0xa
  801f13:	e8 e7 fe ff ff       	call   801dff <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 0b                	push   $0xb
  801f2c:	e8 ce fe ff ff       	call   801dff <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	ff 75 0c             	pushl  0xc(%ebp)
  801f42:	ff 75 08             	pushl  0x8(%ebp)
  801f45:	6a 0f                	push   $0xf
  801f47:	e8 b3 fe ff ff       	call   801dff <syscall>
  801f4c:	83 c4 18             	add    $0x18,%esp
	return;
  801f4f:	90                   	nop
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	ff 75 0c             	pushl  0xc(%ebp)
  801f5e:	ff 75 08             	pushl  0x8(%ebp)
  801f61:	6a 10                	push   $0x10
  801f63:	e8 97 fe ff ff       	call   801dff <syscall>
  801f68:	83 c4 18             	add    $0x18,%esp
	return ;
  801f6b:	90                   	nop
}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	ff 75 10             	pushl  0x10(%ebp)
  801f78:	ff 75 0c             	pushl  0xc(%ebp)
  801f7b:	ff 75 08             	pushl  0x8(%ebp)
  801f7e:	6a 11                	push   $0x11
  801f80:	e8 7a fe ff ff       	call   801dff <syscall>
  801f85:	83 c4 18             	add    $0x18,%esp
	return ;
  801f88:	90                   	nop
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 0c                	push   $0xc
  801f9a:	e8 60 fe ff ff       	call   801dff <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	ff 75 08             	pushl  0x8(%ebp)
  801fb2:	6a 0d                	push   $0xd
  801fb4:	e8 46 fe ff ff       	call   801dff <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_scarce_memory>:

void sys_scarce_memory()
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 0e                	push   $0xe
  801fcd:	e8 2d fe ff ff       	call   801dff <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
}
  801fd5:	90                   	nop
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 13                	push   $0x13
  801fe7:	e8 13 fe ff ff       	call   801dff <syscall>
  801fec:	83 c4 18             	add    $0x18,%esp
}
  801fef:	90                   	nop
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 14                	push   $0x14
  802001:	e8 f9 fd ff ff       	call   801dff <syscall>
  802006:	83 c4 18             	add    $0x18,%esp
}
  802009:	90                   	nop
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <sys_cputc>:


void
sys_cputc(const char c)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	83 ec 04             	sub    $0x4,%esp
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802018:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	50                   	push   %eax
  802025:	6a 15                	push   $0x15
  802027:	e8 d3 fd ff ff       	call   801dff <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	90                   	nop
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 16                	push   $0x16
  802041:	e8 b9 fd ff ff       	call   801dff <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
}
  802049:	90                   	nop
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80204f:	8b 45 08             	mov    0x8(%ebp),%eax
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	ff 75 0c             	pushl  0xc(%ebp)
  80205b:	50                   	push   %eax
  80205c:	6a 17                	push   $0x17
  80205e:	e8 9c fd ff ff       	call   801dff <syscall>
  802063:	83 c4 18             	add    $0x18,%esp
}
  802066:	c9                   	leave  
  802067:	c3                   	ret    

00802068 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80206b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	52                   	push   %edx
  802078:	50                   	push   %eax
  802079:	6a 1a                	push   $0x1a
  80207b:	e8 7f fd ff ff       	call   801dff <syscall>
  802080:	83 c4 18             	add    $0x18,%esp
}
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802088:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	52                   	push   %edx
  802095:	50                   	push   %eax
  802096:	6a 18                	push   $0x18
  802098:	e8 62 fd ff ff       	call   801dff <syscall>
  80209d:	83 c4 18             	add    $0x18,%esp
}
  8020a0:	90                   	nop
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	52                   	push   %edx
  8020b3:	50                   	push   %eax
  8020b4:	6a 19                	push   $0x19
  8020b6:	e8 44 fd ff ff       	call   801dff <syscall>
  8020bb:	83 c4 18             	add    $0x18,%esp
}
  8020be:	90                   	nop
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	83 ec 04             	sub    $0x4,%esp
  8020c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020cd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020d0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	6a 00                	push   $0x0
  8020d9:	51                   	push   %ecx
  8020da:	52                   	push   %edx
  8020db:	ff 75 0c             	pushl  0xc(%ebp)
  8020de:	50                   	push   %eax
  8020df:	6a 1b                	push   $0x1b
  8020e1:	e8 19 fd ff ff       	call   801dff <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8020ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	52                   	push   %edx
  8020fb:	50                   	push   %eax
  8020fc:	6a 1c                	push   $0x1c
  8020fe:	e8 fc fc ff ff       	call   801dff <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80210b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80210e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	51                   	push   %ecx
  802119:	52                   	push   %edx
  80211a:	50                   	push   %eax
  80211b:	6a 1d                	push   $0x1d
  80211d:	e8 dd fc ff ff       	call   801dff <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80212a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	52                   	push   %edx
  802137:	50                   	push   %eax
  802138:	6a 1e                	push   $0x1e
  80213a:	e8 c0 fc ff ff       	call   801dff <syscall>
  80213f:	83 c4 18             	add    $0x18,%esp
}
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 1f                	push   $0x1f
  802153:	e8 a7 fc ff ff       	call   801dff <syscall>
  802158:	83 c4 18             	add    $0x18,%esp
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	6a 00                	push   $0x0
  802165:	ff 75 14             	pushl  0x14(%ebp)
  802168:	ff 75 10             	pushl  0x10(%ebp)
  80216b:	ff 75 0c             	pushl  0xc(%ebp)
  80216e:	50                   	push   %eax
  80216f:	6a 20                	push   $0x20
  802171:	e8 89 fc ff ff       	call   801dff <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
}
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	50                   	push   %eax
  80218a:	6a 21                	push   $0x21
  80218c:	e8 6e fc ff ff       	call   801dff <syscall>
  802191:	83 c4 18             	add    $0x18,%esp
}
  802194:	90                   	nop
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	50                   	push   %eax
  8021a6:	6a 22                	push   $0x22
  8021a8:	e8 52 fc ff ff       	call   801dff <syscall>
  8021ad:	83 c4 18             	add    $0x18,%esp
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 02                	push   $0x2
  8021c1:	e8 39 fc ff ff       	call   801dff <syscall>
  8021c6:	83 c4 18             	add    $0x18,%esp
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 03                	push   $0x3
  8021da:	e8 20 fc ff ff       	call   801dff <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
}
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 04                	push   $0x4
  8021f3:	e8 07 fc ff ff       	call   801dff <syscall>
  8021f8:	83 c4 18             	add    $0x18,%esp
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <sys_exit_env>:


void sys_exit_env(void)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 23                	push   $0x23
  80220c:	e8 ee fb ff ff       	call   801dff <syscall>
  802211:	83 c4 18             	add    $0x18,%esp
}
  802214:	90                   	nop
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80221d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802220:	8d 50 04             	lea    0x4(%eax),%edx
  802223:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	52                   	push   %edx
  80222d:	50                   	push   %eax
  80222e:	6a 24                	push   $0x24
  802230:	e8 ca fb ff ff       	call   801dff <syscall>
  802235:	83 c4 18             	add    $0x18,%esp
	return result;
  802238:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80223b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80223e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802241:	89 01                	mov    %eax,(%ecx)
  802243:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	c9                   	leave  
  80224a:	c2 04 00             	ret    $0x4

0080224d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	ff 75 10             	pushl  0x10(%ebp)
  802257:	ff 75 0c             	pushl  0xc(%ebp)
  80225a:	ff 75 08             	pushl  0x8(%ebp)
  80225d:	6a 12                	push   $0x12
  80225f:	e8 9b fb ff ff       	call   801dff <syscall>
  802264:	83 c4 18             	add    $0x18,%esp
	return ;
  802267:	90                   	nop
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <sys_rcr2>:
uint32 sys_rcr2()
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 25                	push   $0x25
  802279:	e8 81 fb ff ff       	call   801dff <syscall>
  80227e:	83 c4 18             	add    $0x18,%esp
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
  802286:	83 ec 04             	sub    $0x4,%esp
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80228f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	50                   	push   %eax
  80229c:	6a 26                	push   $0x26
  80229e:	e8 5c fb ff ff       	call   801dff <syscall>
  8022a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8022a6:	90                   	nop
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <rsttst>:
void rsttst()
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 28                	push   $0x28
  8022b8:	e8 42 fb ff ff       	call   801dff <syscall>
  8022bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c0:	90                   	nop
}
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
  8022c6:	83 ec 04             	sub    $0x4,%esp
  8022c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8022cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022cf:	8b 55 18             	mov    0x18(%ebp),%edx
  8022d2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022d6:	52                   	push   %edx
  8022d7:	50                   	push   %eax
  8022d8:	ff 75 10             	pushl  0x10(%ebp)
  8022db:	ff 75 0c             	pushl  0xc(%ebp)
  8022de:	ff 75 08             	pushl  0x8(%ebp)
  8022e1:	6a 27                	push   $0x27
  8022e3:	e8 17 fb ff ff       	call   801dff <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8022eb:	90                   	nop
}
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <chktst>:
void chktst(uint32 n)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	ff 75 08             	pushl  0x8(%ebp)
  8022fc:	6a 29                	push   $0x29
  8022fe:	e8 fc fa ff ff       	call   801dff <syscall>
  802303:	83 c4 18             	add    $0x18,%esp
	return ;
  802306:	90                   	nop
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <inctst>:

void inctst()
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 2a                	push   $0x2a
  802318:	e8 e2 fa ff ff       	call   801dff <syscall>
  80231d:	83 c4 18             	add    $0x18,%esp
	return ;
  802320:	90                   	nop
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <gettst>:
uint32 gettst()
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 2b                	push   $0x2b
  802332:	e8 c8 fa ff ff       	call   801dff <syscall>
  802337:	83 c4 18             	add    $0x18,%esp
}
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 2c                	push   $0x2c
  80234e:	e8 ac fa ff ff       	call   801dff <syscall>
  802353:	83 c4 18             	add    $0x18,%esp
  802356:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802359:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80235d:	75 07                	jne    802366 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80235f:	b8 01 00 00 00       	mov    $0x1,%eax
  802364:	eb 05                	jmp    80236b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802366:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80236b:	c9                   	leave  
  80236c:	c3                   	ret    

0080236d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80236d:	55                   	push   %ebp
  80236e:	89 e5                	mov    %esp,%ebp
  802370:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 2c                	push   $0x2c
  80237f:	e8 7b fa ff ff       	call   801dff <syscall>
  802384:	83 c4 18             	add    $0x18,%esp
  802387:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80238a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80238e:	75 07                	jne    802397 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802390:	b8 01 00 00 00       	mov    $0x1,%eax
  802395:	eb 05                	jmp    80239c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802397:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239c:	c9                   	leave  
  80239d:	c3                   	ret    

0080239e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 2c                	push   $0x2c
  8023b0:	e8 4a fa ff ff       	call   801dff <syscall>
  8023b5:	83 c4 18             	add    $0x18,%esp
  8023b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023bb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023bf:	75 07                	jne    8023c8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c6:	eb 05                	jmp    8023cd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
  8023d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 2c                	push   $0x2c
  8023e1:	e8 19 fa ff ff       	call   801dff <syscall>
  8023e6:	83 c4 18             	add    $0x18,%esp
  8023e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8023ec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8023f0:	75 07                	jne    8023f9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8023f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f7:	eb 05                	jmp    8023fe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8023f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	ff 75 08             	pushl  0x8(%ebp)
  80240e:	6a 2d                	push   $0x2d
  802410:	e8 ea f9 ff ff       	call   801dff <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
	return ;
  802418:	90                   	nop
}
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80241f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802422:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802425:	8b 55 0c             	mov    0xc(%ebp),%edx
  802428:	8b 45 08             	mov    0x8(%ebp),%eax
  80242b:	6a 00                	push   $0x0
  80242d:	53                   	push   %ebx
  80242e:	51                   	push   %ecx
  80242f:	52                   	push   %edx
  802430:	50                   	push   %eax
  802431:	6a 2e                	push   $0x2e
  802433:	e8 c7 f9 ff ff       	call   801dff <syscall>
  802438:	83 c4 18             	add    $0x18,%esp
}
  80243b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802443:	8b 55 0c             	mov    0xc(%ebp),%edx
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	52                   	push   %edx
  802450:	50                   	push   %eax
  802451:	6a 2f                	push   $0x2f
  802453:	e8 a7 f9 ff ff       	call   801dff <syscall>
  802458:	83 c4 18             	add    $0x18,%esp
}
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    

0080245d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80245d:	55                   	push   %ebp
  80245e:	89 e5                	mov    %esp,%ebp
  802460:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802463:	83 ec 0c             	sub    $0xc,%esp
  802466:	68 70 45 80 00       	push   $0x804570
  80246b:	e8 6b e8 ff ff       	call   800cdb <cprintf>
  802470:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802473:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80247a:	83 ec 0c             	sub    $0xc,%esp
  80247d:	68 9c 45 80 00       	push   $0x80459c
  802482:	e8 54 e8 ff ff       	call   800cdb <cprintf>
  802487:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80248a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80248e:	a1 38 51 80 00       	mov    0x805138,%eax
  802493:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802496:	eb 56                	jmp    8024ee <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802498:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80249c:	74 1c                	je     8024ba <print_mem_block_lists+0x5d>
  80249e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a1:	8b 50 08             	mov    0x8(%eax),%edx
  8024a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a7:	8b 48 08             	mov    0x8(%eax),%ecx
  8024aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b0:	01 c8                	add    %ecx,%eax
  8024b2:	39 c2                	cmp    %eax,%edx
  8024b4:	73 04                	jae    8024ba <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8024b6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	8b 50 08             	mov    0x8(%eax),%edx
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c6:	01 c2                	add    %eax,%edx
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 40 08             	mov    0x8(%eax),%eax
  8024ce:	83 ec 04             	sub    $0x4,%esp
  8024d1:	52                   	push   %edx
  8024d2:	50                   	push   %eax
  8024d3:	68 b1 45 80 00       	push   $0x8045b1
  8024d8:	e8 fe e7 ff ff       	call   800cdb <cprintf>
  8024dd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8024eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f2:	74 07                	je     8024fb <print_mem_block_lists+0x9e>
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 00                	mov    (%eax),%eax
  8024f9:	eb 05                	jmp    802500 <print_mem_block_lists+0xa3>
  8024fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802500:	a3 40 51 80 00       	mov    %eax,0x805140
  802505:	a1 40 51 80 00       	mov    0x805140,%eax
  80250a:	85 c0                	test   %eax,%eax
  80250c:	75 8a                	jne    802498 <print_mem_block_lists+0x3b>
  80250e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802512:	75 84                	jne    802498 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802514:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802518:	75 10                	jne    80252a <print_mem_block_lists+0xcd>
  80251a:	83 ec 0c             	sub    $0xc,%esp
  80251d:	68 c0 45 80 00       	push   $0x8045c0
  802522:	e8 b4 e7 ff ff       	call   800cdb <cprintf>
  802527:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80252a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802531:	83 ec 0c             	sub    $0xc,%esp
  802534:	68 e4 45 80 00       	push   $0x8045e4
  802539:	e8 9d e7 ff ff       	call   800cdb <cprintf>
  80253e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802541:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802545:	a1 40 50 80 00       	mov    0x805040,%eax
  80254a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254d:	eb 56                	jmp    8025a5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80254f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802553:	74 1c                	je     802571 <print_mem_block_lists+0x114>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 50 08             	mov    0x8(%eax),%edx
  80255b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255e:	8b 48 08             	mov    0x8(%eax),%ecx
  802561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802564:	8b 40 0c             	mov    0xc(%eax),%eax
  802567:	01 c8                	add    %ecx,%eax
  802569:	39 c2                	cmp    %eax,%edx
  80256b:	73 04                	jae    802571 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80256d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 50 08             	mov    0x8(%eax),%edx
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 40 0c             	mov    0xc(%eax),%eax
  80257d:	01 c2                	add    %eax,%edx
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	8b 40 08             	mov    0x8(%eax),%eax
  802585:	83 ec 04             	sub    $0x4,%esp
  802588:	52                   	push   %edx
  802589:	50                   	push   %eax
  80258a:	68 b1 45 80 00       	push   $0x8045b1
  80258f:	e8 47 e7 ff ff       	call   800cdb <cprintf>
  802594:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80259d:	a1 48 50 80 00       	mov    0x805048,%eax
  8025a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a9:	74 07                	je     8025b2 <print_mem_block_lists+0x155>
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 00                	mov    (%eax),%eax
  8025b0:	eb 05                	jmp    8025b7 <print_mem_block_lists+0x15a>
  8025b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b7:	a3 48 50 80 00       	mov    %eax,0x805048
  8025bc:	a1 48 50 80 00       	mov    0x805048,%eax
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	75 8a                	jne    80254f <print_mem_block_lists+0xf2>
  8025c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c9:	75 84                	jne    80254f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8025cb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025cf:	75 10                	jne    8025e1 <print_mem_block_lists+0x184>
  8025d1:	83 ec 0c             	sub    $0xc,%esp
  8025d4:	68 fc 45 80 00       	push   $0x8045fc
  8025d9:	e8 fd e6 ff ff       	call   800cdb <cprintf>
  8025de:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8025e1:	83 ec 0c             	sub    $0xc,%esp
  8025e4:	68 70 45 80 00       	push   $0x804570
  8025e9:	e8 ed e6 ff ff       	call   800cdb <cprintf>
  8025ee:	83 c4 10             	add    $0x10,%esp

}
  8025f1:	90                   	nop
  8025f2:	c9                   	leave  
  8025f3:	c3                   	ret    

008025f4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
  8025f7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8025fa:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802601:	00 00 00 
  802604:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80260b:	00 00 00 
  80260e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802615:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802618:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80261f:	e9 9e 00 00 00       	jmp    8026c2 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802624:	a1 50 50 80 00       	mov    0x805050,%eax
  802629:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262c:	c1 e2 04             	shl    $0x4,%edx
  80262f:	01 d0                	add    %edx,%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	75 14                	jne    802649 <initialize_MemBlocksList+0x55>
  802635:	83 ec 04             	sub    $0x4,%esp
  802638:	68 24 46 80 00       	push   $0x804624
  80263d:	6a 46                	push   $0x46
  80263f:	68 47 46 80 00       	push   $0x804647
  802644:	e8 de e3 ff ff       	call   800a27 <_panic>
  802649:	a1 50 50 80 00       	mov    0x805050,%eax
  80264e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802651:	c1 e2 04             	shl    $0x4,%edx
  802654:	01 d0                	add    %edx,%eax
  802656:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80265c:	89 10                	mov    %edx,(%eax)
  80265e:	8b 00                	mov    (%eax),%eax
  802660:	85 c0                	test   %eax,%eax
  802662:	74 18                	je     80267c <initialize_MemBlocksList+0x88>
  802664:	a1 48 51 80 00       	mov    0x805148,%eax
  802669:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80266f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802672:	c1 e1 04             	shl    $0x4,%ecx
  802675:	01 ca                	add    %ecx,%edx
  802677:	89 50 04             	mov    %edx,0x4(%eax)
  80267a:	eb 12                	jmp    80268e <initialize_MemBlocksList+0x9a>
  80267c:	a1 50 50 80 00       	mov    0x805050,%eax
  802681:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802684:	c1 e2 04             	shl    $0x4,%edx
  802687:	01 d0                	add    %edx,%eax
  802689:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80268e:	a1 50 50 80 00       	mov    0x805050,%eax
  802693:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802696:	c1 e2 04             	shl    $0x4,%edx
  802699:	01 d0                	add    %edx,%eax
  80269b:	a3 48 51 80 00       	mov    %eax,0x805148
  8026a0:	a1 50 50 80 00       	mov    0x805050,%eax
  8026a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a8:	c1 e2 04             	shl    $0x4,%edx
  8026ab:	01 d0                	add    %edx,%eax
  8026ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b4:	a1 54 51 80 00       	mov    0x805154,%eax
  8026b9:	40                   	inc    %eax
  8026ba:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8026bf:	ff 45 f4             	incl   -0xc(%ebp)
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c8:	0f 82 56 ff ff ff    	jb     802624 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8026ce:	90                   	nop
  8026cf:	c9                   	leave  
  8026d0:	c3                   	ret    

008026d1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8026d1:	55                   	push   %ebp
  8026d2:	89 e5                	mov    %esp,%ebp
  8026d4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8026d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026da:	8b 00                	mov    (%eax),%eax
  8026dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8026df:	eb 19                	jmp    8026fa <find_block+0x29>
	{
		if(va==point->sva)
  8026e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026e4:	8b 40 08             	mov    0x8(%eax),%eax
  8026e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8026ea:	75 05                	jne    8026f1 <find_block+0x20>
		   return point;
  8026ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026ef:	eb 36                	jmp    802727 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8026f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f4:	8b 40 08             	mov    0x8(%eax),%eax
  8026f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8026fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026fe:	74 07                	je     802707 <find_block+0x36>
  802700:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802703:	8b 00                	mov    (%eax),%eax
  802705:	eb 05                	jmp    80270c <find_block+0x3b>
  802707:	b8 00 00 00 00       	mov    $0x0,%eax
  80270c:	8b 55 08             	mov    0x8(%ebp),%edx
  80270f:	89 42 08             	mov    %eax,0x8(%edx)
  802712:	8b 45 08             	mov    0x8(%ebp),%eax
  802715:	8b 40 08             	mov    0x8(%eax),%eax
  802718:	85 c0                	test   %eax,%eax
  80271a:	75 c5                	jne    8026e1 <find_block+0x10>
  80271c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802720:	75 bf                	jne    8026e1 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802722:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802727:	c9                   	leave  
  802728:	c3                   	ret    

00802729 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802729:	55                   	push   %ebp
  80272a:	89 e5                	mov    %esp,%ebp
  80272c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80272f:	a1 40 50 80 00       	mov    0x805040,%eax
  802734:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802737:	a1 44 50 80 00       	mov    0x805044,%eax
  80273c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80273f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802742:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802745:	74 24                	je     80276b <insert_sorted_allocList+0x42>
  802747:	8b 45 08             	mov    0x8(%ebp),%eax
  80274a:	8b 50 08             	mov    0x8(%eax),%edx
  80274d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802750:	8b 40 08             	mov    0x8(%eax),%eax
  802753:	39 c2                	cmp    %eax,%edx
  802755:	76 14                	jbe    80276b <insert_sorted_allocList+0x42>
  802757:	8b 45 08             	mov    0x8(%ebp),%eax
  80275a:	8b 50 08             	mov    0x8(%eax),%edx
  80275d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802760:	8b 40 08             	mov    0x8(%eax),%eax
  802763:	39 c2                	cmp    %eax,%edx
  802765:	0f 82 60 01 00 00    	jb     8028cb <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80276b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80276f:	75 65                	jne    8027d6 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802771:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802775:	75 14                	jne    80278b <insert_sorted_allocList+0x62>
  802777:	83 ec 04             	sub    $0x4,%esp
  80277a:	68 24 46 80 00       	push   $0x804624
  80277f:	6a 6b                	push   $0x6b
  802781:	68 47 46 80 00       	push   $0x804647
  802786:	e8 9c e2 ff ff       	call   800a27 <_panic>
  80278b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802791:	8b 45 08             	mov    0x8(%ebp),%eax
  802794:	89 10                	mov    %edx,(%eax)
  802796:	8b 45 08             	mov    0x8(%ebp),%eax
  802799:	8b 00                	mov    (%eax),%eax
  80279b:	85 c0                	test   %eax,%eax
  80279d:	74 0d                	je     8027ac <insert_sorted_allocList+0x83>
  80279f:	a1 40 50 80 00       	mov    0x805040,%eax
  8027a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a7:	89 50 04             	mov    %edx,0x4(%eax)
  8027aa:	eb 08                	jmp    8027b4 <insert_sorted_allocList+0x8b>
  8027ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8027af:	a3 44 50 80 00       	mov    %eax,0x805044
  8027b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b7:	a3 40 50 80 00       	mov    %eax,0x805040
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027cb:	40                   	inc    %eax
  8027cc:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027d1:	e9 dc 01 00 00       	jmp    8029b2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8027d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d9:	8b 50 08             	mov    0x8(%eax),%edx
  8027dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027df:	8b 40 08             	mov    0x8(%eax),%eax
  8027e2:	39 c2                	cmp    %eax,%edx
  8027e4:	77 6c                	ja     802852 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8027e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ea:	74 06                	je     8027f2 <insert_sorted_allocList+0xc9>
  8027ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027f0:	75 14                	jne    802806 <insert_sorted_allocList+0xdd>
  8027f2:	83 ec 04             	sub    $0x4,%esp
  8027f5:	68 60 46 80 00       	push   $0x804660
  8027fa:	6a 6f                	push   $0x6f
  8027fc:	68 47 46 80 00       	push   $0x804647
  802801:	e8 21 e2 ff ff       	call   800a27 <_panic>
  802806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802809:	8b 50 04             	mov    0x4(%eax),%edx
  80280c:	8b 45 08             	mov    0x8(%ebp),%eax
  80280f:	89 50 04             	mov    %edx,0x4(%eax)
  802812:	8b 45 08             	mov    0x8(%ebp),%eax
  802815:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802818:	89 10                	mov    %edx,(%eax)
  80281a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281d:	8b 40 04             	mov    0x4(%eax),%eax
  802820:	85 c0                	test   %eax,%eax
  802822:	74 0d                	je     802831 <insert_sorted_allocList+0x108>
  802824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802827:	8b 40 04             	mov    0x4(%eax),%eax
  80282a:	8b 55 08             	mov    0x8(%ebp),%edx
  80282d:	89 10                	mov    %edx,(%eax)
  80282f:	eb 08                	jmp    802839 <insert_sorted_allocList+0x110>
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	a3 40 50 80 00       	mov    %eax,0x805040
  802839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283c:	8b 55 08             	mov    0x8(%ebp),%edx
  80283f:	89 50 04             	mov    %edx,0x4(%eax)
  802842:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802847:	40                   	inc    %eax
  802848:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80284d:	e9 60 01 00 00       	jmp    8029b2 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	8b 50 08             	mov    0x8(%eax),%edx
  802858:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285b:	8b 40 08             	mov    0x8(%eax),%eax
  80285e:	39 c2                	cmp    %eax,%edx
  802860:	0f 82 4c 01 00 00    	jb     8029b2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802866:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80286a:	75 14                	jne    802880 <insert_sorted_allocList+0x157>
  80286c:	83 ec 04             	sub    $0x4,%esp
  80286f:	68 98 46 80 00       	push   $0x804698
  802874:	6a 73                	push   $0x73
  802876:	68 47 46 80 00       	push   $0x804647
  80287b:	e8 a7 e1 ff ff       	call   800a27 <_panic>
  802880:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802886:	8b 45 08             	mov    0x8(%ebp),%eax
  802889:	89 50 04             	mov    %edx,0x4(%eax)
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	8b 40 04             	mov    0x4(%eax),%eax
  802892:	85 c0                	test   %eax,%eax
  802894:	74 0c                	je     8028a2 <insert_sorted_allocList+0x179>
  802896:	a1 44 50 80 00       	mov    0x805044,%eax
  80289b:	8b 55 08             	mov    0x8(%ebp),%edx
  80289e:	89 10                	mov    %edx,(%eax)
  8028a0:	eb 08                	jmp    8028aa <insert_sorted_allocList+0x181>
  8028a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a5:	a3 40 50 80 00       	mov    %eax,0x805040
  8028aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ad:	a3 44 50 80 00       	mov    %eax,0x805044
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028bb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028c0:	40                   	inc    %eax
  8028c1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028c6:	e9 e7 00 00 00       	jmp    8029b2 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8028cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8028d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8028d8:	a1 40 50 80 00       	mov    0x805040,%eax
  8028dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e0:	e9 9d 00 00 00       	jmp    802982 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 00                	mov    (%eax),%eax
  8028ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f0:	8b 50 08             	mov    0x8(%eax),%edx
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	8b 40 08             	mov    0x8(%eax),%eax
  8028f9:	39 c2                	cmp    %eax,%edx
  8028fb:	76 7d                	jbe    80297a <insert_sorted_allocList+0x251>
  8028fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802900:	8b 50 08             	mov    0x8(%eax),%edx
  802903:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802906:	8b 40 08             	mov    0x8(%eax),%eax
  802909:	39 c2                	cmp    %eax,%edx
  80290b:	73 6d                	jae    80297a <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80290d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802911:	74 06                	je     802919 <insert_sorted_allocList+0x1f0>
  802913:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802917:	75 14                	jne    80292d <insert_sorted_allocList+0x204>
  802919:	83 ec 04             	sub    $0x4,%esp
  80291c:	68 bc 46 80 00       	push   $0x8046bc
  802921:	6a 7f                	push   $0x7f
  802923:	68 47 46 80 00       	push   $0x804647
  802928:	e8 fa e0 ff ff       	call   800a27 <_panic>
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 10                	mov    (%eax),%edx
  802932:	8b 45 08             	mov    0x8(%ebp),%eax
  802935:	89 10                	mov    %edx,(%eax)
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	74 0b                	je     80294b <insert_sorted_allocList+0x222>
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 00                	mov    (%eax),%eax
  802945:	8b 55 08             	mov    0x8(%ebp),%edx
  802948:	89 50 04             	mov    %edx,0x4(%eax)
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	8b 55 08             	mov    0x8(%ebp),%edx
  802951:	89 10                	mov    %edx,(%eax)
  802953:	8b 45 08             	mov    0x8(%ebp),%eax
  802956:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802959:	89 50 04             	mov    %edx,0x4(%eax)
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	75 08                	jne    80296d <insert_sorted_allocList+0x244>
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	a3 44 50 80 00       	mov    %eax,0x805044
  80296d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802972:	40                   	inc    %eax
  802973:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802978:	eb 39                	jmp    8029b3 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80297a:	a1 48 50 80 00       	mov    0x805048,%eax
  80297f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802982:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802986:	74 07                	je     80298f <insert_sorted_allocList+0x266>
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	eb 05                	jmp    802994 <insert_sorted_allocList+0x26b>
  80298f:	b8 00 00 00 00       	mov    $0x0,%eax
  802994:	a3 48 50 80 00       	mov    %eax,0x805048
  802999:	a1 48 50 80 00       	mov    0x805048,%eax
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	0f 85 3f ff ff ff    	jne    8028e5 <insert_sorted_allocList+0x1bc>
  8029a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029aa:	0f 85 35 ff ff ff    	jne    8028e5 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8029b0:	eb 01                	jmp    8029b3 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029b2:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8029b3:	90                   	nop
  8029b4:	c9                   	leave  
  8029b5:	c3                   	ret    

008029b6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8029b6:	55                   	push   %ebp
  8029b7:	89 e5                	mov    %esp,%ebp
  8029b9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8029bc:	a1 38 51 80 00       	mov    0x805138,%eax
  8029c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c4:	e9 85 01 00 00       	jmp    802b4e <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d2:	0f 82 6e 01 00 00    	jb     802b46 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	8b 40 0c             	mov    0xc(%eax),%eax
  8029de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e1:	0f 85 8a 00 00 00    	jne    802a71 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8029e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029eb:	75 17                	jne    802a04 <alloc_block_FF+0x4e>
  8029ed:	83 ec 04             	sub    $0x4,%esp
  8029f0:	68 f0 46 80 00       	push   $0x8046f0
  8029f5:	68 93 00 00 00       	push   $0x93
  8029fa:	68 47 46 80 00       	push   $0x804647
  8029ff:	e8 23 e0 ff ff       	call   800a27 <_panic>
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	74 10                	je     802a1d <alloc_block_FF+0x67>
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a15:	8b 52 04             	mov    0x4(%edx),%edx
  802a18:	89 50 04             	mov    %edx,0x4(%eax)
  802a1b:	eb 0b                	jmp    802a28 <alloc_block_FF+0x72>
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	8b 40 04             	mov    0x4(%eax),%eax
  802a23:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 40 04             	mov    0x4(%eax),%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	74 0f                	je     802a41 <alloc_block_FF+0x8b>
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 40 04             	mov    0x4(%eax),%eax
  802a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a3b:	8b 12                	mov    (%edx),%edx
  802a3d:	89 10                	mov    %edx,(%eax)
  802a3f:	eb 0a                	jmp    802a4b <alloc_block_FF+0x95>
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 00                	mov    (%eax),%eax
  802a46:	a3 38 51 80 00       	mov    %eax,0x805138
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5e:	a1 44 51 80 00       	mov    0x805144,%eax
  802a63:	48                   	dec    %eax
  802a64:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	e9 10 01 00 00       	jmp    802b81 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 40 0c             	mov    0xc(%eax),%eax
  802a77:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a7a:	0f 86 c6 00 00 00    	jbe    802b46 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a80:	a1 48 51 80 00       	mov    0x805148,%eax
  802a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 50 08             	mov    0x8(%eax),%edx
  802a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a91:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a97:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aa1:	75 17                	jne    802aba <alloc_block_FF+0x104>
  802aa3:	83 ec 04             	sub    $0x4,%esp
  802aa6:	68 f0 46 80 00       	push   $0x8046f0
  802aab:	68 9b 00 00 00       	push   $0x9b
  802ab0:	68 47 46 80 00       	push   $0x804647
  802ab5:	e8 6d df ff ff       	call   800a27 <_panic>
  802aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abd:	8b 00                	mov    (%eax),%eax
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	74 10                	je     802ad3 <alloc_block_FF+0x11d>
  802ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802acb:	8b 52 04             	mov    0x4(%edx),%edx
  802ace:	89 50 04             	mov    %edx,0x4(%eax)
  802ad1:	eb 0b                	jmp    802ade <alloc_block_FF+0x128>
  802ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad6:	8b 40 04             	mov    0x4(%eax),%eax
  802ad9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae1:	8b 40 04             	mov    0x4(%eax),%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	74 0f                	je     802af7 <alloc_block_FF+0x141>
  802ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aeb:	8b 40 04             	mov    0x4(%eax),%eax
  802aee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af1:	8b 12                	mov    (%edx),%edx
  802af3:	89 10                	mov    %edx,(%eax)
  802af5:	eb 0a                	jmp    802b01 <alloc_block_FF+0x14b>
  802af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afa:	8b 00                	mov    (%eax),%eax
  802afc:	a3 48 51 80 00       	mov    %eax,0x805148
  802b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b14:	a1 54 51 80 00       	mov    0x805154,%eax
  802b19:	48                   	dec    %eax
  802b1a:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 50 08             	mov    0x8(%eax),%edx
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	01 c2                	add    %eax,%edx
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 40 0c             	mov    0xc(%eax),%eax
  802b36:	2b 45 08             	sub    0x8(%ebp),%eax
  802b39:	89 c2                	mov    %eax,%edx
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b44:	eb 3b                	jmp    802b81 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802b46:	a1 40 51 80 00       	mov    0x805140,%eax
  802b4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b52:	74 07                	je     802b5b <alloc_block_FF+0x1a5>
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	8b 00                	mov    (%eax),%eax
  802b59:	eb 05                	jmp    802b60 <alloc_block_FF+0x1aa>
  802b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b60:	a3 40 51 80 00       	mov    %eax,0x805140
  802b65:	a1 40 51 80 00       	mov    0x805140,%eax
  802b6a:	85 c0                	test   %eax,%eax
  802b6c:	0f 85 57 fe ff ff    	jne    8029c9 <alloc_block_FF+0x13>
  802b72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b76:	0f 85 4d fe ff ff    	jne    8029c9 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802b7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b81:	c9                   	leave  
  802b82:	c3                   	ret    

00802b83 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b83:	55                   	push   %ebp
  802b84:	89 e5                	mov    %esp,%ebp
  802b86:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802b89:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b90:	a1 38 51 80 00       	mov    0x805138,%eax
  802b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b98:	e9 df 00 00 00       	jmp    802c7c <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba6:	0f 82 c8 00 00 00    	jb     802c74 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb5:	0f 85 8a 00 00 00    	jne    802c45 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802bbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbf:	75 17                	jne    802bd8 <alloc_block_BF+0x55>
  802bc1:	83 ec 04             	sub    $0x4,%esp
  802bc4:	68 f0 46 80 00       	push   $0x8046f0
  802bc9:	68 b7 00 00 00       	push   $0xb7
  802bce:	68 47 46 80 00       	push   $0x804647
  802bd3:	e8 4f de ff ff       	call   800a27 <_panic>
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	8b 00                	mov    (%eax),%eax
  802bdd:	85 c0                	test   %eax,%eax
  802bdf:	74 10                	je     802bf1 <alloc_block_BF+0x6e>
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	8b 00                	mov    (%eax),%eax
  802be6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be9:	8b 52 04             	mov    0x4(%edx),%edx
  802bec:	89 50 04             	mov    %edx,0x4(%eax)
  802bef:	eb 0b                	jmp    802bfc <alloc_block_BF+0x79>
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	8b 40 04             	mov    0x4(%eax),%eax
  802bf7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 40 04             	mov    0x4(%eax),%eax
  802c02:	85 c0                	test   %eax,%eax
  802c04:	74 0f                	je     802c15 <alloc_block_BF+0x92>
  802c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c09:	8b 40 04             	mov    0x4(%eax),%eax
  802c0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0f:	8b 12                	mov    (%edx),%edx
  802c11:	89 10                	mov    %edx,(%eax)
  802c13:	eb 0a                	jmp    802c1f <alloc_block_BF+0x9c>
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	8b 00                	mov    (%eax),%eax
  802c1a:	a3 38 51 80 00       	mov    %eax,0x805138
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c32:	a1 44 51 80 00       	mov    0x805144,%eax
  802c37:	48                   	dec    %eax
  802c38:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	e9 4d 01 00 00       	jmp    802d92 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c4e:	76 24                	jbe    802c74 <alloc_block_BF+0xf1>
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 40 0c             	mov    0xc(%eax),%eax
  802c56:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c59:	73 19                	jae    802c74 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802c5b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	8b 40 0c             	mov    0xc(%eax),%eax
  802c68:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 40 08             	mov    0x8(%eax),%eax
  802c71:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c74:	a1 40 51 80 00       	mov    0x805140,%eax
  802c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c80:	74 07                	je     802c89 <alloc_block_BF+0x106>
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	8b 00                	mov    (%eax),%eax
  802c87:	eb 05                	jmp    802c8e <alloc_block_BF+0x10b>
  802c89:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8e:	a3 40 51 80 00       	mov    %eax,0x805140
  802c93:	a1 40 51 80 00       	mov    0x805140,%eax
  802c98:	85 c0                	test   %eax,%eax
  802c9a:	0f 85 fd fe ff ff    	jne    802b9d <alloc_block_BF+0x1a>
  802ca0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca4:	0f 85 f3 fe ff ff    	jne    802b9d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802caa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cae:	0f 84 d9 00 00 00    	je     802d8d <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cb4:	a1 48 51 80 00       	mov    0x805148,%eax
  802cb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802cbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cc2:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ccb:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802cce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cd2:	75 17                	jne    802ceb <alloc_block_BF+0x168>
  802cd4:	83 ec 04             	sub    $0x4,%esp
  802cd7:	68 f0 46 80 00       	push   $0x8046f0
  802cdc:	68 c7 00 00 00       	push   $0xc7
  802ce1:	68 47 46 80 00       	push   $0x804647
  802ce6:	e8 3c dd ff ff       	call   800a27 <_panic>
  802ceb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cee:	8b 00                	mov    (%eax),%eax
  802cf0:	85 c0                	test   %eax,%eax
  802cf2:	74 10                	je     802d04 <alloc_block_BF+0x181>
  802cf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf7:	8b 00                	mov    (%eax),%eax
  802cf9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cfc:	8b 52 04             	mov    0x4(%edx),%edx
  802cff:	89 50 04             	mov    %edx,0x4(%eax)
  802d02:	eb 0b                	jmp    802d0f <alloc_block_BF+0x18c>
  802d04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d07:	8b 40 04             	mov    0x4(%eax),%eax
  802d0a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d12:	8b 40 04             	mov    0x4(%eax),%eax
  802d15:	85 c0                	test   %eax,%eax
  802d17:	74 0f                	je     802d28 <alloc_block_BF+0x1a5>
  802d19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d1c:	8b 40 04             	mov    0x4(%eax),%eax
  802d1f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d22:	8b 12                	mov    (%edx),%edx
  802d24:	89 10                	mov    %edx,(%eax)
  802d26:	eb 0a                	jmp    802d32 <alloc_block_BF+0x1af>
  802d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d2b:	8b 00                	mov    (%eax),%eax
  802d2d:	a3 48 51 80 00       	mov    %eax,0x805148
  802d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d45:	a1 54 51 80 00       	mov    0x805154,%eax
  802d4a:	48                   	dec    %eax
  802d4b:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802d50:	83 ec 08             	sub    $0x8,%esp
  802d53:	ff 75 ec             	pushl  -0x14(%ebp)
  802d56:	68 38 51 80 00       	push   $0x805138
  802d5b:	e8 71 f9 ff ff       	call   8026d1 <find_block>
  802d60:	83 c4 10             	add    $0x10,%esp
  802d63:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d69:	8b 50 08             	mov    0x8(%eax),%edx
  802d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6f:	01 c2                	add    %eax,%edx
  802d71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d74:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802d77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7d:	2b 45 08             	sub    0x8(%ebp),%eax
  802d80:	89 c2                	mov    %eax,%edx
  802d82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d85:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802d88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d8b:	eb 05                	jmp    802d92 <alloc_block_BF+0x20f>
	}
	return NULL;
  802d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d92:	c9                   	leave  
  802d93:	c3                   	ret    

00802d94 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802d94:	55                   	push   %ebp
  802d95:	89 e5                	mov    %esp,%ebp
  802d97:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802d9a:	a1 28 50 80 00       	mov    0x805028,%eax
  802d9f:	85 c0                	test   %eax,%eax
  802da1:	0f 85 de 01 00 00    	jne    802f85 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802da7:	a1 38 51 80 00       	mov    0x805138,%eax
  802dac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802daf:	e9 9e 01 00 00       	jmp    802f52 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dba:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dbd:	0f 82 87 01 00 00    	jb     802f4a <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dcc:	0f 85 95 00 00 00    	jne    802e67 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802dd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd6:	75 17                	jne    802def <alloc_block_NF+0x5b>
  802dd8:	83 ec 04             	sub    $0x4,%esp
  802ddb:	68 f0 46 80 00       	push   $0x8046f0
  802de0:	68 e0 00 00 00       	push   $0xe0
  802de5:	68 47 46 80 00       	push   $0x804647
  802dea:	e8 38 dc ff ff       	call   800a27 <_panic>
  802def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df2:	8b 00                	mov    (%eax),%eax
  802df4:	85 c0                	test   %eax,%eax
  802df6:	74 10                	je     802e08 <alloc_block_NF+0x74>
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	8b 00                	mov    (%eax),%eax
  802dfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e00:	8b 52 04             	mov    0x4(%edx),%edx
  802e03:	89 50 04             	mov    %edx,0x4(%eax)
  802e06:	eb 0b                	jmp    802e13 <alloc_block_NF+0x7f>
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	8b 40 04             	mov    0x4(%eax),%eax
  802e0e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 40 04             	mov    0x4(%eax),%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	74 0f                	je     802e2c <alloc_block_NF+0x98>
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	8b 40 04             	mov    0x4(%eax),%eax
  802e23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e26:	8b 12                	mov    (%edx),%edx
  802e28:	89 10                	mov    %edx,(%eax)
  802e2a:	eb 0a                	jmp    802e36 <alloc_block_NF+0xa2>
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	a3 38 51 80 00       	mov    %eax,0x805138
  802e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e49:	a1 44 51 80 00       	mov    0x805144,%eax
  802e4e:	48                   	dec    %eax
  802e4f:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 40 08             	mov    0x8(%eax),%eax
  802e5a:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e62:	e9 f8 04 00 00       	jmp    80335f <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e70:	0f 86 d4 00 00 00    	jbe    802f4a <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e76:	a1 48 51 80 00       	mov    0x805148,%eax
  802e7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	8b 50 08             	mov    0x8(%eax),%edx
  802e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e87:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e90:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e97:	75 17                	jne    802eb0 <alloc_block_NF+0x11c>
  802e99:	83 ec 04             	sub    $0x4,%esp
  802e9c:	68 f0 46 80 00       	push   $0x8046f0
  802ea1:	68 e9 00 00 00       	push   $0xe9
  802ea6:	68 47 46 80 00       	push   $0x804647
  802eab:	e8 77 db ff ff       	call   800a27 <_panic>
  802eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb3:	8b 00                	mov    (%eax),%eax
  802eb5:	85 c0                	test   %eax,%eax
  802eb7:	74 10                	je     802ec9 <alloc_block_NF+0x135>
  802eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebc:	8b 00                	mov    (%eax),%eax
  802ebe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec1:	8b 52 04             	mov    0x4(%edx),%edx
  802ec4:	89 50 04             	mov    %edx,0x4(%eax)
  802ec7:	eb 0b                	jmp    802ed4 <alloc_block_NF+0x140>
  802ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecc:	8b 40 04             	mov    0x4(%eax),%eax
  802ecf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed7:	8b 40 04             	mov    0x4(%eax),%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	74 0f                	je     802eed <alloc_block_NF+0x159>
  802ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee1:	8b 40 04             	mov    0x4(%eax),%eax
  802ee4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee7:	8b 12                	mov    (%edx),%edx
  802ee9:	89 10                	mov    %edx,(%eax)
  802eeb:	eb 0a                	jmp    802ef7 <alloc_block_NF+0x163>
  802eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	a3 48 51 80 00       	mov    %eax,0x805148
  802ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0a:	a1 54 51 80 00       	mov    0x805154,%eax
  802f0f:	48                   	dec    %eax
  802f10:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f18:	8b 40 08             	mov    0x8(%eax),%eax
  802f1b:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	8b 50 08             	mov    0x8(%eax),%edx
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	01 c2                	add    %eax,%edx
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 40 0c             	mov    0xc(%eax),%eax
  802f37:	2b 45 08             	sub    0x8(%ebp),%eax
  802f3a:	89 c2                	mov    %eax,%edx
  802f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f45:	e9 15 04 00 00       	jmp    80335f <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802f4a:	a1 40 51 80 00       	mov    0x805140,%eax
  802f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f56:	74 07                	je     802f5f <alloc_block_NF+0x1cb>
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	8b 00                	mov    (%eax),%eax
  802f5d:	eb 05                	jmp    802f64 <alloc_block_NF+0x1d0>
  802f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f64:	a3 40 51 80 00       	mov    %eax,0x805140
  802f69:	a1 40 51 80 00       	mov    0x805140,%eax
  802f6e:	85 c0                	test   %eax,%eax
  802f70:	0f 85 3e fe ff ff    	jne    802db4 <alloc_block_NF+0x20>
  802f76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f7a:	0f 85 34 fe ff ff    	jne    802db4 <alloc_block_NF+0x20>
  802f80:	e9 d5 03 00 00       	jmp    80335a <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f85:	a1 38 51 80 00       	mov    0x805138,%eax
  802f8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f8d:	e9 b1 01 00 00       	jmp    803143 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f95:	8b 50 08             	mov    0x8(%eax),%edx
  802f98:	a1 28 50 80 00       	mov    0x805028,%eax
  802f9d:	39 c2                	cmp    %eax,%edx
  802f9f:	0f 82 96 01 00 00    	jb     80313b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fab:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fae:	0f 82 87 01 00 00    	jb     80313b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fba:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fbd:	0f 85 95 00 00 00    	jne    803058 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802fc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc7:	75 17                	jne    802fe0 <alloc_block_NF+0x24c>
  802fc9:	83 ec 04             	sub    $0x4,%esp
  802fcc:	68 f0 46 80 00       	push   $0x8046f0
  802fd1:	68 fc 00 00 00       	push   $0xfc
  802fd6:	68 47 46 80 00       	push   $0x804647
  802fdb:	e8 47 da ff ff       	call   800a27 <_panic>
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 00                	mov    (%eax),%eax
  802fe5:	85 c0                	test   %eax,%eax
  802fe7:	74 10                	je     802ff9 <alloc_block_NF+0x265>
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	8b 00                	mov    (%eax),%eax
  802fee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff1:	8b 52 04             	mov    0x4(%edx),%edx
  802ff4:	89 50 04             	mov    %edx,0x4(%eax)
  802ff7:	eb 0b                	jmp    803004 <alloc_block_NF+0x270>
  802ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffc:	8b 40 04             	mov    0x4(%eax),%eax
  802fff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803007:	8b 40 04             	mov    0x4(%eax),%eax
  80300a:	85 c0                	test   %eax,%eax
  80300c:	74 0f                	je     80301d <alloc_block_NF+0x289>
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	8b 40 04             	mov    0x4(%eax),%eax
  803014:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803017:	8b 12                	mov    (%edx),%edx
  803019:	89 10                	mov    %edx,(%eax)
  80301b:	eb 0a                	jmp    803027 <alloc_block_NF+0x293>
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	8b 00                	mov    (%eax),%eax
  803022:	a3 38 51 80 00       	mov    %eax,0x805138
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803033:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303a:	a1 44 51 80 00       	mov    0x805144,%eax
  80303f:	48                   	dec    %eax
  803040:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803048:	8b 40 08             	mov    0x8(%eax),%eax
  80304b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803053:	e9 07 03 00 00       	jmp    80335f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	8b 40 0c             	mov    0xc(%eax),%eax
  80305e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803061:	0f 86 d4 00 00 00    	jbe    80313b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803067:	a1 48 51 80 00       	mov    0x805148,%eax
  80306c:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	8b 50 08             	mov    0x8(%eax),%edx
  803075:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803078:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80307b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307e:	8b 55 08             	mov    0x8(%ebp),%edx
  803081:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803084:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803088:	75 17                	jne    8030a1 <alloc_block_NF+0x30d>
  80308a:	83 ec 04             	sub    $0x4,%esp
  80308d:	68 f0 46 80 00       	push   $0x8046f0
  803092:	68 04 01 00 00       	push   $0x104
  803097:	68 47 46 80 00       	push   $0x804647
  80309c:	e8 86 d9 ff ff       	call   800a27 <_panic>
  8030a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a4:	8b 00                	mov    (%eax),%eax
  8030a6:	85 c0                	test   %eax,%eax
  8030a8:	74 10                	je     8030ba <alloc_block_NF+0x326>
  8030aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ad:	8b 00                	mov    (%eax),%eax
  8030af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030b2:	8b 52 04             	mov    0x4(%edx),%edx
  8030b5:	89 50 04             	mov    %edx,0x4(%eax)
  8030b8:	eb 0b                	jmp    8030c5 <alloc_block_NF+0x331>
  8030ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bd:	8b 40 04             	mov    0x4(%eax),%eax
  8030c0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c8:	8b 40 04             	mov    0x4(%eax),%eax
  8030cb:	85 c0                	test   %eax,%eax
  8030cd:	74 0f                	je     8030de <alloc_block_NF+0x34a>
  8030cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d2:	8b 40 04             	mov    0x4(%eax),%eax
  8030d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030d8:	8b 12                	mov    (%edx),%edx
  8030da:	89 10                	mov    %edx,(%eax)
  8030dc:	eb 0a                	jmp    8030e8 <alloc_block_NF+0x354>
  8030de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e1:	8b 00                	mov    (%eax),%eax
  8030e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8030e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030fb:	a1 54 51 80 00       	mov    0x805154,%eax
  803100:	48                   	dec    %eax
  803101:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803106:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803109:	8b 40 08             	mov    0x8(%eax),%eax
  80310c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803114:	8b 50 08             	mov    0x8(%eax),%edx
  803117:	8b 45 08             	mov    0x8(%ebp),%eax
  80311a:	01 c2                	add    %eax,%edx
  80311c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	8b 40 0c             	mov    0xc(%eax),%eax
  803128:	2b 45 08             	sub    0x8(%ebp),%eax
  80312b:	89 c2                	mov    %eax,%edx
  80312d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803130:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803136:	e9 24 02 00 00       	jmp    80335f <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80313b:	a1 40 51 80 00       	mov    0x805140,%eax
  803140:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803143:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803147:	74 07                	je     803150 <alloc_block_NF+0x3bc>
  803149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314c:	8b 00                	mov    (%eax),%eax
  80314e:	eb 05                	jmp    803155 <alloc_block_NF+0x3c1>
  803150:	b8 00 00 00 00       	mov    $0x0,%eax
  803155:	a3 40 51 80 00       	mov    %eax,0x805140
  80315a:	a1 40 51 80 00       	mov    0x805140,%eax
  80315f:	85 c0                	test   %eax,%eax
  803161:	0f 85 2b fe ff ff    	jne    802f92 <alloc_block_NF+0x1fe>
  803167:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80316b:	0f 85 21 fe ff ff    	jne    802f92 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803171:	a1 38 51 80 00       	mov    0x805138,%eax
  803176:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803179:	e9 ae 01 00 00       	jmp    80332c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	8b 50 08             	mov    0x8(%eax),%edx
  803184:	a1 28 50 80 00       	mov    0x805028,%eax
  803189:	39 c2                	cmp    %eax,%edx
  80318b:	0f 83 93 01 00 00    	jae    803324 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803194:	8b 40 0c             	mov    0xc(%eax),%eax
  803197:	3b 45 08             	cmp    0x8(%ebp),%eax
  80319a:	0f 82 84 01 00 00    	jb     803324 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8031a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031a9:	0f 85 95 00 00 00    	jne    803244 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8031af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b3:	75 17                	jne    8031cc <alloc_block_NF+0x438>
  8031b5:	83 ec 04             	sub    $0x4,%esp
  8031b8:	68 f0 46 80 00       	push   $0x8046f0
  8031bd:	68 14 01 00 00       	push   $0x114
  8031c2:	68 47 46 80 00       	push   $0x804647
  8031c7:	e8 5b d8 ff ff       	call   800a27 <_panic>
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cf:	8b 00                	mov    (%eax),%eax
  8031d1:	85 c0                	test   %eax,%eax
  8031d3:	74 10                	je     8031e5 <alloc_block_NF+0x451>
  8031d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d8:	8b 00                	mov    (%eax),%eax
  8031da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031dd:	8b 52 04             	mov    0x4(%edx),%edx
  8031e0:	89 50 04             	mov    %edx,0x4(%eax)
  8031e3:	eb 0b                	jmp    8031f0 <alloc_block_NF+0x45c>
  8031e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e8:	8b 40 04             	mov    0x4(%eax),%eax
  8031eb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f3:	8b 40 04             	mov    0x4(%eax),%eax
  8031f6:	85 c0                	test   %eax,%eax
  8031f8:	74 0f                	je     803209 <alloc_block_NF+0x475>
  8031fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fd:	8b 40 04             	mov    0x4(%eax),%eax
  803200:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803203:	8b 12                	mov    (%edx),%edx
  803205:	89 10                	mov    %edx,(%eax)
  803207:	eb 0a                	jmp    803213 <alloc_block_NF+0x47f>
  803209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320c:	8b 00                	mov    (%eax),%eax
  80320e:	a3 38 51 80 00       	mov    %eax,0x805138
  803213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803216:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80321c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803226:	a1 44 51 80 00       	mov    0x805144,%eax
  80322b:	48                   	dec    %eax
  80322c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803234:	8b 40 08             	mov    0x8(%eax),%eax
  803237:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80323c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323f:	e9 1b 01 00 00       	jmp    80335f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803247:	8b 40 0c             	mov    0xc(%eax),%eax
  80324a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80324d:	0f 86 d1 00 00 00    	jbe    803324 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803253:	a1 48 51 80 00       	mov    0x805148,%eax
  803258:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80325b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325e:	8b 50 08             	mov    0x8(%eax),%edx
  803261:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803264:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326a:	8b 55 08             	mov    0x8(%ebp),%edx
  80326d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803270:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803274:	75 17                	jne    80328d <alloc_block_NF+0x4f9>
  803276:	83 ec 04             	sub    $0x4,%esp
  803279:	68 f0 46 80 00       	push   $0x8046f0
  80327e:	68 1c 01 00 00       	push   $0x11c
  803283:	68 47 46 80 00       	push   $0x804647
  803288:	e8 9a d7 ff ff       	call   800a27 <_panic>
  80328d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803290:	8b 00                	mov    (%eax),%eax
  803292:	85 c0                	test   %eax,%eax
  803294:	74 10                	je     8032a6 <alloc_block_NF+0x512>
  803296:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803299:	8b 00                	mov    (%eax),%eax
  80329b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80329e:	8b 52 04             	mov    0x4(%edx),%edx
  8032a1:	89 50 04             	mov    %edx,0x4(%eax)
  8032a4:	eb 0b                	jmp    8032b1 <alloc_block_NF+0x51d>
  8032a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a9:	8b 40 04             	mov    0x4(%eax),%eax
  8032ac:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b4:	8b 40 04             	mov    0x4(%eax),%eax
  8032b7:	85 c0                	test   %eax,%eax
  8032b9:	74 0f                	je     8032ca <alloc_block_NF+0x536>
  8032bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032be:	8b 40 04             	mov    0x4(%eax),%eax
  8032c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032c4:	8b 12                	mov    (%edx),%edx
  8032c6:	89 10                	mov    %edx,(%eax)
  8032c8:	eb 0a                	jmp    8032d4 <alloc_block_NF+0x540>
  8032ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032cd:	8b 00                	mov    (%eax),%eax
  8032cf:	a3 48 51 80 00       	mov    %eax,0x805148
  8032d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e7:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ec:	48                   	dec    %eax
  8032ed:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8032f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f5:	8b 40 08             	mov    0x8(%eax),%eax
  8032f8:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803300:	8b 50 08             	mov    0x8(%eax),%edx
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	01 c2                	add    %eax,%edx
  803308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80330e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803311:	8b 40 0c             	mov    0xc(%eax),%eax
  803314:	2b 45 08             	sub    0x8(%ebp),%eax
  803317:	89 c2                	mov    %eax,%edx
  803319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80331f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803322:	eb 3b                	jmp    80335f <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803324:	a1 40 51 80 00       	mov    0x805140,%eax
  803329:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80332c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803330:	74 07                	je     803339 <alloc_block_NF+0x5a5>
  803332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803335:	8b 00                	mov    (%eax),%eax
  803337:	eb 05                	jmp    80333e <alloc_block_NF+0x5aa>
  803339:	b8 00 00 00 00       	mov    $0x0,%eax
  80333e:	a3 40 51 80 00       	mov    %eax,0x805140
  803343:	a1 40 51 80 00       	mov    0x805140,%eax
  803348:	85 c0                	test   %eax,%eax
  80334a:	0f 85 2e fe ff ff    	jne    80317e <alloc_block_NF+0x3ea>
  803350:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803354:	0f 85 24 fe ff ff    	jne    80317e <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80335a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80335f:	c9                   	leave  
  803360:	c3                   	ret    

00803361 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803361:	55                   	push   %ebp
  803362:	89 e5                	mov    %esp,%ebp
  803364:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803367:	a1 38 51 80 00       	mov    0x805138,%eax
  80336c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80336f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803374:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803377:	a1 38 51 80 00       	mov    0x805138,%eax
  80337c:	85 c0                	test   %eax,%eax
  80337e:	74 14                	je     803394 <insert_sorted_with_merge_freeList+0x33>
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	8b 50 08             	mov    0x8(%eax),%edx
  803386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803389:	8b 40 08             	mov    0x8(%eax),%eax
  80338c:	39 c2                	cmp    %eax,%edx
  80338e:	0f 87 9b 01 00 00    	ja     80352f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803394:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803398:	75 17                	jne    8033b1 <insert_sorted_with_merge_freeList+0x50>
  80339a:	83 ec 04             	sub    $0x4,%esp
  80339d:	68 24 46 80 00       	push   $0x804624
  8033a2:	68 38 01 00 00       	push   $0x138
  8033a7:	68 47 46 80 00       	push   $0x804647
  8033ac:	e8 76 d6 ff ff       	call   800a27 <_panic>
  8033b1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	89 10                	mov    %edx,(%eax)
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	8b 00                	mov    (%eax),%eax
  8033c1:	85 c0                	test   %eax,%eax
  8033c3:	74 0d                	je     8033d2 <insert_sorted_with_merge_freeList+0x71>
  8033c5:	a1 38 51 80 00       	mov    0x805138,%eax
  8033ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8033cd:	89 50 04             	mov    %edx,0x4(%eax)
  8033d0:	eb 08                	jmp    8033da <insert_sorted_with_merge_freeList+0x79>
  8033d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033da:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dd:	a3 38 51 80 00       	mov    %eax,0x805138
  8033e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8033f1:	40                   	inc    %eax
  8033f2:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033fb:	0f 84 a8 06 00 00    	je     803aa9 <insert_sorted_with_merge_freeList+0x748>
  803401:	8b 45 08             	mov    0x8(%ebp),%eax
  803404:	8b 50 08             	mov    0x8(%eax),%edx
  803407:	8b 45 08             	mov    0x8(%ebp),%eax
  80340a:	8b 40 0c             	mov    0xc(%eax),%eax
  80340d:	01 c2                	add    %eax,%edx
  80340f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803412:	8b 40 08             	mov    0x8(%eax),%eax
  803415:	39 c2                	cmp    %eax,%edx
  803417:	0f 85 8c 06 00 00    	jne    803aa9 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80341d:	8b 45 08             	mov    0x8(%ebp),%eax
  803420:	8b 50 0c             	mov    0xc(%eax),%edx
  803423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803426:	8b 40 0c             	mov    0xc(%eax),%eax
  803429:	01 c2                	add    %eax,%edx
  80342b:	8b 45 08             	mov    0x8(%ebp),%eax
  80342e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803431:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803435:	75 17                	jne    80344e <insert_sorted_with_merge_freeList+0xed>
  803437:	83 ec 04             	sub    $0x4,%esp
  80343a:	68 f0 46 80 00       	push   $0x8046f0
  80343f:	68 3c 01 00 00       	push   $0x13c
  803444:	68 47 46 80 00       	push   $0x804647
  803449:	e8 d9 d5 ff ff       	call   800a27 <_panic>
  80344e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803451:	8b 00                	mov    (%eax),%eax
  803453:	85 c0                	test   %eax,%eax
  803455:	74 10                	je     803467 <insert_sorted_with_merge_freeList+0x106>
  803457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345a:	8b 00                	mov    (%eax),%eax
  80345c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80345f:	8b 52 04             	mov    0x4(%edx),%edx
  803462:	89 50 04             	mov    %edx,0x4(%eax)
  803465:	eb 0b                	jmp    803472 <insert_sorted_with_merge_freeList+0x111>
  803467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80346a:	8b 40 04             	mov    0x4(%eax),%eax
  80346d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803472:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803475:	8b 40 04             	mov    0x4(%eax),%eax
  803478:	85 c0                	test   %eax,%eax
  80347a:	74 0f                	je     80348b <insert_sorted_with_merge_freeList+0x12a>
  80347c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347f:	8b 40 04             	mov    0x4(%eax),%eax
  803482:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803485:	8b 12                	mov    (%edx),%edx
  803487:	89 10                	mov    %edx,(%eax)
  803489:	eb 0a                	jmp    803495 <insert_sorted_with_merge_freeList+0x134>
  80348b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348e:	8b 00                	mov    (%eax),%eax
  803490:	a3 38 51 80 00       	mov    %eax,0x805138
  803495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803498:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80349e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a8:	a1 44 51 80 00       	mov    0x805144,%eax
  8034ad:	48                   	dec    %eax
  8034ae:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8034b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8034bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8034c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034cb:	75 17                	jne    8034e4 <insert_sorted_with_merge_freeList+0x183>
  8034cd:	83 ec 04             	sub    $0x4,%esp
  8034d0:	68 24 46 80 00       	push   $0x804624
  8034d5:	68 3f 01 00 00       	push   $0x13f
  8034da:	68 47 46 80 00       	push   $0x804647
  8034df:	e8 43 d5 ff ff       	call   800a27 <_panic>
  8034e4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ed:	89 10                	mov    %edx,(%eax)
  8034ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f2:	8b 00                	mov    (%eax),%eax
  8034f4:	85 c0                	test   %eax,%eax
  8034f6:	74 0d                	je     803505 <insert_sorted_with_merge_freeList+0x1a4>
  8034f8:	a1 48 51 80 00       	mov    0x805148,%eax
  8034fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803500:	89 50 04             	mov    %edx,0x4(%eax)
  803503:	eb 08                	jmp    80350d <insert_sorted_with_merge_freeList+0x1ac>
  803505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803508:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80350d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803510:	a3 48 51 80 00       	mov    %eax,0x805148
  803515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803518:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80351f:	a1 54 51 80 00       	mov    0x805154,%eax
  803524:	40                   	inc    %eax
  803525:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80352a:	e9 7a 05 00 00       	jmp    803aa9 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80352f:	8b 45 08             	mov    0x8(%ebp),%eax
  803532:	8b 50 08             	mov    0x8(%eax),%edx
  803535:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803538:	8b 40 08             	mov    0x8(%eax),%eax
  80353b:	39 c2                	cmp    %eax,%edx
  80353d:	0f 82 14 01 00 00    	jb     803657 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803546:	8b 50 08             	mov    0x8(%eax),%edx
  803549:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80354c:	8b 40 0c             	mov    0xc(%eax),%eax
  80354f:	01 c2                	add    %eax,%edx
  803551:	8b 45 08             	mov    0x8(%ebp),%eax
  803554:	8b 40 08             	mov    0x8(%eax),%eax
  803557:	39 c2                	cmp    %eax,%edx
  803559:	0f 85 90 00 00 00    	jne    8035ef <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80355f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803562:	8b 50 0c             	mov    0xc(%eax),%edx
  803565:	8b 45 08             	mov    0x8(%ebp),%eax
  803568:	8b 40 0c             	mov    0xc(%eax),%eax
  80356b:	01 c2                	add    %eax,%edx
  80356d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803570:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803573:	8b 45 08             	mov    0x8(%ebp),%eax
  803576:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80357d:	8b 45 08             	mov    0x8(%ebp),%eax
  803580:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803587:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80358b:	75 17                	jne    8035a4 <insert_sorted_with_merge_freeList+0x243>
  80358d:	83 ec 04             	sub    $0x4,%esp
  803590:	68 24 46 80 00       	push   $0x804624
  803595:	68 49 01 00 00       	push   $0x149
  80359a:	68 47 46 80 00       	push   $0x804647
  80359f:	e8 83 d4 ff ff       	call   800a27 <_panic>
  8035a4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ad:	89 10                	mov    %edx,(%eax)
  8035af:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b2:	8b 00                	mov    (%eax),%eax
  8035b4:	85 c0                	test   %eax,%eax
  8035b6:	74 0d                	je     8035c5 <insert_sorted_with_merge_freeList+0x264>
  8035b8:	a1 48 51 80 00       	mov    0x805148,%eax
  8035bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c0:	89 50 04             	mov    %edx,0x4(%eax)
  8035c3:	eb 08                	jmp    8035cd <insert_sorted_with_merge_freeList+0x26c>
  8035c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8035d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035df:	a1 54 51 80 00       	mov    0x805154,%eax
  8035e4:	40                   	inc    %eax
  8035e5:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035ea:	e9 bb 04 00 00       	jmp    803aaa <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8035ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f3:	75 17                	jne    80360c <insert_sorted_with_merge_freeList+0x2ab>
  8035f5:	83 ec 04             	sub    $0x4,%esp
  8035f8:	68 98 46 80 00       	push   $0x804698
  8035fd:	68 4c 01 00 00       	push   $0x14c
  803602:	68 47 46 80 00       	push   $0x804647
  803607:	e8 1b d4 ff ff       	call   800a27 <_panic>
  80360c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803612:	8b 45 08             	mov    0x8(%ebp),%eax
  803615:	89 50 04             	mov    %edx,0x4(%eax)
  803618:	8b 45 08             	mov    0x8(%ebp),%eax
  80361b:	8b 40 04             	mov    0x4(%eax),%eax
  80361e:	85 c0                	test   %eax,%eax
  803620:	74 0c                	je     80362e <insert_sorted_with_merge_freeList+0x2cd>
  803622:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803627:	8b 55 08             	mov    0x8(%ebp),%edx
  80362a:	89 10                	mov    %edx,(%eax)
  80362c:	eb 08                	jmp    803636 <insert_sorted_with_merge_freeList+0x2d5>
  80362e:	8b 45 08             	mov    0x8(%ebp),%eax
  803631:	a3 38 51 80 00       	mov    %eax,0x805138
  803636:	8b 45 08             	mov    0x8(%ebp),%eax
  803639:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80363e:	8b 45 08             	mov    0x8(%ebp),%eax
  803641:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803647:	a1 44 51 80 00       	mov    0x805144,%eax
  80364c:	40                   	inc    %eax
  80364d:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803652:	e9 53 04 00 00       	jmp    803aaa <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803657:	a1 38 51 80 00       	mov    0x805138,%eax
  80365c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80365f:	e9 15 04 00 00       	jmp    803a79 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803667:	8b 00                	mov    (%eax),%eax
  803669:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80366c:	8b 45 08             	mov    0x8(%ebp),%eax
  80366f:	8b 50 08             	mov    0x8(%eax),%edx
  803672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803675:	8b 40 08             	mov    0x8(%eax),%eax
  803678:	39 c2                	cmp    %eax,%edx
  80367a:	0f 86 f1 03 00 00    	jbe    803a71 <insert_sorted_with_merge_freeList+0x710>
  803680:	8b 45 08             	mov    0x8(%ebp),%eax
  803683:	8b 50 08             	mov    0x8(%eax),%edx
  803686:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803689:	8b 40 08             	mov    0x8(%eax),%eax
  80368c:	39 c2                	cmp    %eax,%edx
  80368e:	0f 83 dd 03 00 00    	jae    803a71 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803697:	8b 50 08             	mov    0x8(%eax),%edx
  80369a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369d:	8b 40 0c             	mov    0xc(%eax),%eax
  8036a0:	01 c2                	add    %eax,%edx
  8036a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a5:	8b 40 08             	mov    0x8(%eax),%eax
  8036a8:	39 c2                	cmp    %eax,%edx
  8036aa:	0f 85 b9 01 00 00    	jne    803869 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8036b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b3:	8b 50 08             	mov    0x8(%eax),%edx
  8036b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8036bc:	01 c2                	add    %eax,%edx
  8036be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c1:	8b 40 08             	mov    0x8(%eax),%eax
  8036c4:	39 c2                	cmp    %eax,%edx
  8036c6:	0f 85 0d 01 00 00    	jne    8037d9 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8036cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cf:	8b 50 0c             	mov    0xc(%eax),%edx
  8036d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d8:	01 c2                	add    %eax,%edx
  8036da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036dd:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8036e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036e4:	75 17                	jne    8036fd <insert_sorted_with_merge_freeList+0x39c>
  8036e6:	83 ec 04             	sub    $0x4,%esp
  8036e9:	68 f0 46 80 00       	push   $0x8046f0
  8036ee:	68 5c 01 00 00       	push   $0x15c
  8036f3:	68 47 46 80 00       	push   $0x804647
  8036f8:	e8 2a d3 ff ff       	call   800a27 <_panic>
  8036fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803700:	8b 00                	mov    (%eax),%eax
  803702:	85 c0                	test   %eax,%eax
  803704:	74 10                	je     803716 <insert_sorted_with_merge_freeList+0x3b5>
  803706:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803709:	8b 00                	mov    (%eax),%eax
  80370b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80370e:	8b 52 04             	mov    0x4(%edx),%edx
  803711:	89 50 04             	mov    %edx,0x4(%eax)
  803714:	eb 0b                	jmp    803721 <insert_sorted_with_merge_freeList+0x3c0>
  803716:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803719:	8b 40 04             	mov    0x4(%eax),%eax
  80371c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803721:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803724:	8b 40 04             	mov    0x4(%eax),%eax
  803727:	85 c0                	test   %eax,%eax
  803729:	74 0f                	je     80373a <insert_sorted_with_merge_freeList+0x3d9>
  80372b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372e:	8b 40 04             	mov    0x4(%eax),%eax
  803731:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803734:	8b 12                	mov    (%edx),%edx
  803736:	89 10                	mov    %edx,(%eax)
  803738:	eb 0a                	jmp    803744 <insert_sorted_with_merge_freeList+0x3e3>
  80373a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373d:	8b 00                	mov    (%eax),%eax
  80373f:	a3 38 51 80 00       	mov    %eax,0x805138
  803744:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803747:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80374d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803750:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803757:	a1 44 51 80 00       	mov    0x805144,%eax
  80375c:	48                   	dec    %eax
  80375d:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803762:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803765:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80376c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803776:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80377a:	75 17                	jne    803793 <insert_sorted_with_merge_freeList+0x432>
  80377c:	83 ec 04             	sub    $0x4,%esp
  80377f:	68 24 46 80 00       	push   $0x804624
  803784:	68 5f 01 00 00       	push   $0x15f
  803789:	68 47 46 80 00       	push   $0x804647
  80378e:	e8 94 d2 ff ff       	call   800a27 <_panic>
  803793:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803799:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379c:	89 10                	mov    %edx,(%eax)
  80379e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a1:	8b 00                	mov    (%eax),%eax
  8037a3:	85 c0                	test   %eax,%eax
  8037a5:	74 0d                	je     8037b4 <insert_sorted_with_merge_freeList+0x453>
  8037a7:	a1 48 51 80 00       	mov    0x805148,%eax
  8037ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037af:	89 50 04             	mov    %edx,0x4(%eax)
  8037b2:	eb 08                	jmp    8037bc <insert_sorted_with_merge_freeList+0x45b>
  8037b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037bf:	a3 48 51 80 00       	mov    %eax,0x805148
  8037c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ce:	a1 54 51 80 00       	mov    0x805154,%eax
  8037d3:	40                   	inc    %eax
  8037d4:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8037d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037dc:	8b 50 0c             	mov    0xc(%eax),%edx
  8037df:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8037e5:	01 c2                	add    %eax,%edx
  8037e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ea:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8037ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8037f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803801:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803805:	75 17                	jne    80381e <insert_sorted_with_merge_freeList+0x4bd>
  803807:	83 ec 04             	sub    $0x4,%esp
  80380a:	68 24 46 80 00       	push   $0x804624
  80380f:	68 64 01 00 00       	push   $0x164
  803814:	68 47 46 80 00       	push   $0x804647
  803819:	e8 09 d2 ff ff       	call   800a27 <_panic>
  80381e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803824:	8b 45 08             	mov    0x8(%ebp),%eax
  803827:	89 10                	mov    %edx,(%eax)
  803829:	8b 45 08             	mov    0x8(%ebp),%eax
  80382c:	8b 00                	mov    (%eax),%eax
  80382e:	85 c0                	test   %eax,%eax
  803830:	74 0d                	je     80383f <insert_sorted_with_merge_freeList+0x4de>
  803832:	a1 48 51 80 00       	mov    0x805148,%eax
  803837:	8b 55 08             	mov    0x8(%ebp),%edx
  80383a:	89 50 04             	mov    %edx,0x4(%eax)
  80383d:	eb 08                	jmp    803847 <insert_sorted_with_merge_freeList+0x4e6>
  80383f:	8b 45 08             	mov    0x8(%ebp),%eax
  803842:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803847:	8b 45 08             	mov    0x8(%ebp),%eax
  80384a:	a3 48 51 80 00       	mov    %eax,0x805148
  80384f:	8b 45 08             	mov    0x8(%ebp),%eax
  803852:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803859:	a1 54 51 80 00       	mov    0x805154,%eax
  80385e:	40                   	inc    %eax
  80385f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803864:	e9 41 02 00 00       	jmp    803aaa <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803869:	8b 45 08             	mov    0x8(%ebp),%eax
  80386c:	8b 50 08             	mov    0x8(%eax),%edx
  80386f:	8b 45 08             	mov    0x8(%ebp),%eax
  803872:	8b 40 0c             	mov    0xc(%eax),%eax
  803875:	01 c2                	add    %eax,%edx
  803877:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387a:	8b 40 08             	mov    0x8(%eax),%eax
  80387d:	39 c2                	cmp    %eax,%edx
  80387f:	0f 85 7c 01 00 00    	jne    803a01 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803885:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803889:	74 06                	je     803891 <insert_sorted_with_merge_freeList+0x530>
  80388b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80388f:	75 17                	jne    8038a8 <insert_sorted_with_merge_freeList+0x547>
  803891:	83 ec 04             	sub    $0x4,%esp
  803894:	68 60 46 80 00       	push   $0x804660
  803899:	68 69 01 00 00       	push   $0x169
  80389e:	68 47 46 80 00       	push   $0x804647
  8038a3:	e8 7f d1 ff ff       	call   800a27 <_panic>
  8038a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ab:	8b 50 04             	mov    0x4(%eax),%edx
  8038ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b1:	89 50 04             	mov    %edx,0x4(%eax)
  8038b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038ba:	89 10                	mov    %edx,(%eax)
  8038bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038bf:	8b 40 04             	mov    0x4(%eax),%eax
  8038c2:	85 c0                	test   %eax,%eax
  8038c4:	74 0d                	je     8038d3 <insert_sorted_with_merge_freeList+0x572>
  8038c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c9:	8b 40 04             	mov    0x4(%eax),%eax
  8038cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8038cf:	89 10                	mov    %edx,(%eax)
  8038d1:	eb 08                	jmp    8038db <insert_sorted_with_merge_freeList+0x57a>
  8038d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d6:	a3 38 51 80 00       	mov    %eax,0x805138
  8038db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038de:	8b 55 08             	mov    0x8(%ebp),%edx
  8038e1:	89 50 04             	mov    %edx,0x4(%eax)
  8038e4:	a1 44 51 80 00       	mov    0x805144,%eax
  8038e9:	40                   	inc    %eax
  8038ea:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8038ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f2:	8b 50 0c             	mov    0xc(%eax),%edx
  8038f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8038fb:	01 c2                	add    %eax,%edx
  8038fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803900:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803903:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803907:	75 17                	jne    803920 <insert_sorted_with_merge_freeList+0x5bf>
  803909:	83 ec 04             	sub    $0x4,%esp
  80390c:	68 f0 46 80 00       	push   $0x8046f0
  803911:	68 6b 01 00 00       	push   $0x16b
  803916:	68 47 46 80 00       	push   $0x804647
  80391b:	e8 07 d1 ff ff       	call   800a27 <_panic>
  803920:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803923:	8b 00                	mov    (%eax),%eax
  803925:	85 c0                	test   %eax,%eax
  803927:	74 10                	je     803939 <insert_sorted_with_merge_freeList+0x5d8>
  803929:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392c:	8b 00                	mov    (%eax),%eax
  80392e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803931:	8b 52 04             	mov    0x4(%edx),%edx
  803934:	89 50 04             	mov    %edx,0x4(%eax)
  803937:	eb 0b                	jmp    803944 <insert_sorted_with_merge_freeList+0x5e3>
  803939:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80393c:	8b 40 04             	mov    0x4(%eax),%eax
  80393f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803944:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803947:	8b 40 04             	mov    0x4(%eax),%eax
  80394a:	85 c0                	test   %eax,%eax
  80394c:	74 0f                	je     80395d <insert_sorted_with_merge_freeList+0x5fc>
  80394e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803951:	8b 40 04             	mov    0x4(%eax),%eax
  803954:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803957:	8b 12                	mov    (%edx),%edx
  803959:	89 10                	mov    %edx,(%eax)
  80395b:	eb 0a                	jmp    803967 <insert_sorted_with_merge_freeList+0x606>
  80395d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803960:	8b 00                	mov    (%eax),%eax
  803962:	a3 38 51 80 00       	mov    %eax,0x805138
  803967:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803970:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803973:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80397a:	a1 44 51 80 00       	mov    0x805144,%eax
  80397f:	48                   	dec    %eax
  803980:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803985:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803988:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80398f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803992:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803999:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80399d:	75 17                	jne    8039b6 <insert_sorted_with_merge_freeList+0x655>
  80399f:	83 ec 04             	sub    $0x4,%esp
  8039a2:	68 24 46 80 00       	push   $0x804624
  8039a7:	68 6e 01 00 00       	push   $0x16e
  8039ac:	68 47 46 80 00       	push   $0x804647
  8039b1:	e8 71 d0 ff ff       	call   800a27 <_panic>
  8039b6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039bf:	89 10                	mov    %edx,(%eax)
  8039c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c4:	8b 00                	mov    (%eax),%eax
  8039c6:	85 c0                	test   %eax,%eax
  8039c8:	74 0d                	je     8039d7 <insert_sorted_with_merge_freeList+0x676>
  8039ca:	a1 48 51 80 00       	mov    0x805148,%eax
  8039cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039d2:	89 50 04             	mov    %edx,0x4(%eax)
  8039d5:	eb 08                	jmp    8039df <insert_sorted_with_merge_freeList+0x67e>
  8039d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039da:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e2:	a3 48 51 80 00       	mov    %eax,0x805148
  8039e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039f1:	a1 54 51 80 00       	mov    0x805154,%eax
  8039f6:	40                   	inc    %eax
  8039f7:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8039fc:	e9 a9 00 00 00       	jmp    803aaa <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803a01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a05:	74 06                	je     803a0d <insert_sorted_with_merge_freeList+0x6ac>
  803a07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a0b:	75 17                	jne    803a24 <insert_sorted_with_merge_freeList+0x6c3>
  803a0d:	83 ec 04             	sub    $0x4,%esp
  803a10:	68 bc 46 80 00       	push   $0x8046bc
  803a15:	68 73 01 00 00       	push   $0x173
  803a1a:	68 47 46 80 00       	push   $0x804647
  803a1f:	e8 03 d0 ff ff       	call   800a27 <_panic>
  803a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a27:	8b 10                	mov    (%eax),%edx
  803a29:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2c:	89 10                	mov    %edx,(%eax)
  803a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a31:	8b 00                	mov    (%eax),%eax
  803a33:	85 c0                	test   %eax,%eax
  803a35:	74 0b                	je     803a42 <insert_sorted_with_merge_freeList+0x6e1>
  803a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3a:	8b 00                	mov    (%eax),%eax
  803a3c:	8b 55 08             	mov    0x8(%ebp),%edx
  803a3f:	89 50 04             	mov    %edx,0x4(%eax)
  803a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a45:	8b 55 08             	mov    0x8(%ebp),%edx
  803a48:	89 10                	mov    %edx,(%eax)
  803a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a50:	89 50 04             	mov    %edx,0x4(%eax)
  803a53:	8b 45 08             	mov    0x8(%ebp),%eax
  803a56:	8b 00                	mov    (%eax),%eax
  803a58:	85 c0                	test   %eax,%eax
  803a5a:	75 08                	jne    803a64 <insert_sorted_with_merge_freeList+0x703>
  803a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a64:	a1 44 51 80 00       	mov    0x805144,%eax
  803a69:	40                   	inc    %eax
  803a6a:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803a6f:	eb 39                	jmp    803aaa <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803a71:	a1 40 51 80 00       	mov    0x805140,%eax
  803a76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a7d:	74 07                	je     803a86 <insert_sorted_with_merge_freeList+0x725>
  803a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a82:	8b 00                	mov    (%eax),%eax
  803a84:	eb 05                	jmp    803a8b <insert_sorted_with_merge_freeList+0x72a>
  803a86:	b8 00 00 00 00       	mov    $0x0,%eax
  803a8b:	a3 40 51 80 00       	mov    %eax,0x805140
  803a90:	a1 40 51 80 00       	mov    0x805140,%eax
  803a95:	85 c0                	test   %eax,%eax
  803a97:	0f 85 c7 fb ff ff    	jne    803664 <insert_sorted_with_merge_freeList+0x303>
  803a9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aa1:	0f 85 bd fb ff ff    	jne    803664 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803aa7:	eb 01                	jmp    803aaa <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803aa9:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803aaa:	90                   	nop
  803aab:	c9                   	leave  
  803aac:	c3                   	ret    
  803aad:	66 90                	xchg   %ax,%ax
  803aaf:	90                   	nop

00803ab0 <__udivdi3>:
  803ab0:	55                   	push   %ebp
  803ab1:	57                   	push   %edi
  803ab2:	56                   	push   %esi
  803ab3:	53                   	push   %ebx
  803ab4:	83 ec 1c             	sub    $0x1c,%esp
  803ab7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803abb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803abf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ac3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ac7:	89 ca                	mov    %ecx,%edx
  803ac9:	89 f8                	mov    %edi,%eax
  803acb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803acf:	85 f6                	test   %esi,%esi
  803ad1:	75 2d                	jne    803b00 <__udivdi3+0x50>
  803ad3:	39 cf                	cmp    %ecx,%edi
  803ad5:	77 65                	ja     803b3c <__udivdi3+0x8c>
  803ad7:	89 fd                	mov    %edi,%ebp
  803ad9:	85 ff                	test   %edi,%edi
  803adb:	75 0b                	jne    803ae8 <__udivdi3+0x38>
  803add:	b8 01 00 00 00       	mov    $0x1,%eax
  803ae2:	31 d2                	xor    %edx,%edx
  803ae4:	f7 f7                	div    %edi
  803ae6:	89 c5                	mov    %eax,%ebp
  803ae8:	31 d2                	xor    %edx,%edx
  803aea:	89 c8                	mov    %ecx,%eax
  803aec:	f7 f5                	div    %ebp
  803aee:	89 c1                	mov    %eax,%ecx
  803af0:	89 d8                	mov    %ebx,%eax
  803af2:	f7 f5                	div    %ebp
  803af4:	89 cf                	mov    %ecx,%edi
  803af6:	89 fa                	mov    %edi,%edx
  803af8:	83 c4 1c             	add    $0x1c,%esp
  803afb:	5b                   	pop    %ebx
  803afc:	5e                   	pop    %esi
  803afd:	5f                   	pop    %edi
  803afe:	5d                   	pop    %ebp
  803aff:	c3                   	ret    
  803b00:	39 ce                	cmp    %ecx,%esi
  803b02:	77 28                	ja     803b2c <__udivdi3+0x7c>
  803b04:	0f bd fe             	bsr    %esi,%edi
  803b07:	83 f7 1f             	xor    $0x1f,%edi
  803b0a:	75 40                	jne    803b4c <__udivdi3+0x9c>
  803b0c:	39 ce                	cmp    %ecx,%esi
  803b0e:	72 0a                	jb     803b1a <__udivdi3+0x6a>
  803b10:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b14:	0f 87 9e 00 00 00    	ja     803bb8 <__udivdi3+0x108>
  803b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b1f:	89 fa                	mov    %edi,%edx
  803b21:	83 c4 1c             	add    $0x1c,%esp
  803b24:	5b                   	pop    %ebx
  803b25:	5e                   	pop    %esi
  803b26:	5f                   	pop    %edi
  803b27:	5d                   	pop    %ebp
  803b28:	c3                   	ret    
  803b29:	8d 76 00             	lea    0x0(%esi),%esi
  803b2c:	31 ff                	xor    %edi,%edi
  803b2e:	31 c0                	xor    %eax,%eax
  803b30:	89 fa                	mov    %edi,%edx
  803b32:	83 c4 1c             	add    $0x1c,%esp
  803b35:	5b                   	pop    %ebx
  803b36:	5e                   	pop    %esi
  803b37:	5f                   	pop    %edi
  803b38:	5d                   	pop    %ebp
  803b39:	c3                   	ret    
  803b3a:	66 90                	xchg   %ax,%ax
  803b3c:	89 d8                	mov    %ebx,%eax
  803b3e:	f7 f7                	div    %edi
  803b40:	31 ff                	xor    %edi,%edi
  803b42:	89 fa                	mov    %edi,%edx
  803b44:	83 c4 1c             	add    $0x1c,%esp
  803b47:	5b                   	pop    %ebx
  803b48:	5e                   	pop    %esi
  803b49:	5f                   	pop    %edi
  803b4a:	5d                   	pop    %ebp
  803b4b:	c3                   	ret    
  803b4c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b51:	89 eb                	mov    %ebp,%ebx
  803b53:	29 fb                	sub    %edi,%ebx
  803b55:	89 f9                	mov    %edi,%ecx
  803b57:	d3 e6                	shl    %cl,%esi
  803b59:	89 c5                	mov    %eax,%ebp
  803b5b:	88 d9                	mov    %bl,%cl
  803b5d:	d3 ed                	shr    %cl,%ebp
  803b5f:	89 e9                	mov    %ebp,%ecx
  803b61:	09 f1                	or     %esi,%ecx
  803b63:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b67:	89 f9                	mov    %edi,%ecx
  803b69:	d3 e0                	shl    %cl,%eax
  803b6b:	89 c5                	mov    %eax,%ebp
  803b6d:	89 d6                	mov    %edx,%esi
  803b6f:	88 d9                	mov    %bl,%cl
  803b71:	d3 ee                	shr    %cl,%esi
  803b73:	89 f9                	mov    %edi,%ecx
  803b75:	d3 e2                	shl    %cl,%edx
  803b77:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b7b:	88 d9                	mov    %bl,%cl
  803b7d:	d3 e8                	shr    %cl,%eax
  803b7f:	09 c2                	or     %eax,%edx
  803b81:	89 d0                	mov    %edx,%eax
  803b83:	89 f2                	mov    %esi,%edx
  803b85:	f7 74 24 0c          	divl   0xc(%esp)
  803b89:	89 d6                	mov    %edx,%esi
  803b8b:	89 c3                	mov    %eax,%ebx
  803b8d:	f7 e5                	mul    %ebp
  803b8f:	39 d6                	cmp    %edx,%esi
  803b91:	72 19                	jb     803bac <__udivdi3+0xfc>
  803b93:	74 0b                	je     803ba0 <__udivdi3+0xf0>
  803b95:	89 d8                	mov    %ebx,%eax
  803b97:	31 ff                	xor    %edi,%edi
  803b99:	e9 58 ff ff ff       	jmp    803af6 <__udivdi3+0x46>
  803b9e:	66 90                	xchg   %ax,%ax
  803ba0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ba4:	89 f9                	mov    %edi,%ecx
  803ba6:	d3 e2                	shl    %cl,%edx
  803ba8:	39 c2                	cmp    %eax,%edx
  803baa:	73 e9                	jae    803b95 <__udivdi3+0xe5>
  803bac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803baf:	31 ff                	xor    %edi,%edi
  803bb1:	e9 40 ff ff ff       	jmp    803af6 <__udivdi3+0x46>
  803bb6:	66 90                	xchg   %ax,%ax
  803bb8:	31 c0                	xor    %eax,%eax
  803bba:	e9 37 ff ff ff       	jmp    803af6 <__udivdi3+0x46>
  803bbf:	90                   	nop

00803bc0 <__umoddi3>:
  803bc0:	55                   	push   %ebp
  803bc1:	57                   	push   %edi
  803bc2:	56                   	push   %esi
  803bc3:	53                   	push   %ebx
  803bc4:	83 ec 1c             	sub    $0x1c,%esp
  803bc7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bcb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bcf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bd3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803bd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bdb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803bdf:	89 f3                	mov    %esi,%ebx
  803be1:	89 fa                	mov    %edi,%edx
  803be3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803be7:	89 34 24             	mov    %esi,(%esp)
  803bea:	85 c0                	test   %eax,%eax
  803bec:	75 1a                	jne    803c08 <__umoddi3+0x48>
  803bee:	39 f7                	cmp    %esi,%edi
  803bf0:	0f 86 a2 00 00 00    	jbe    803c98 <__umoddi3+0xd8>
  803bf6:	89 c8                	mov    %ecx,%eax
  803bf8:	89 f2                	mov    %esi,%edx
  803bfa:	f7 f7                	div    %edi
  803bfc:	89 d0                	mov    %edx,%eax
  803bfe:	31 d2                	xor    %edx,%edx
  803c00:	83 c4 1c             	add    $0x1c,%esp
  803c03:	5b                   	pop    %ebx
  803c04:	5e                   	pop    %esi
  803c05:	5f                   	pop    %edi
  803c06:	5d                   	pop    %ebp
  803c07:	c3                   	ret    
  803c08:	39 f0                	cmp    %esi,%eax
  803c0a:	0f 87 ac 00 00 00    	ja     803cbc <__umoddi3+0xfc>
  803c10:	0f bd e8             	bsr    %eax,%ebp
  803c13:	83 f5 1f             	xor    $0x1f,%ebp
  803c16:	0f 84 ac 00 00 00    	je     803cc8 <__umoddi3+0x108>
  803c1c:	bf 20 00 00 00       	mov    $0x20,%edi
  803c21:	29 ef                	sub    %ebp,%edi
  803c23:	89 fe                	mov    %edi,%esi
  803c25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c29:	89 e9                	mov    %ebp,%ecx
  803c2b:	d3 e0                	shl    %cl,%eax
  803c2d:	89 d7                	mov    %edx,%edi
  803c2f:	89 f1                	mov    %esi,%ecx
  803c31:	d3 ef                	shr    %cl,%edi
  803c33:	09 c7                	or     %eax,%edi
  803c35:	89 e9                	mov    %ebp,%ecx
  803c37:	d3 e2                	shl    %cl,%edx
  803c39:	89 14 24             	mov    %edx,(%esp)
  803c3c:	89 d8                	mov    %ebx,%eax
  803c3e:	d3 e0                	shl    %cl,%eax
  803c40:	89 c2                	mov    %eax,%edx
  803c42:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c46:	d3 e0                	shl    %cl,%eax
  803c48:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c4c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c50:	89 f1                	mov    %esi,%ecx
  803c52:	d3 e8                	shr    %cl,%eax
  803c54:	09 d0                	or     %edx,%eax
  803c56:	d3 eb                	shr    %cl,%ebx
  803c58:	89 da                	mov    %ebx,%edx
  803c5a:	f7 f7                	div    %edi
  803c5c:	89 d3                	mov    %edx,%ebx
  803c5e:	f7 24 24             	mull   (%esp)
  803c61:	89 c6                	mov    %eax,%esi
  803c63:	89 d1                	mov    %edx,%ecx
  803c65:	39 d3                	cmp    %edx,%ebx
  803c67:	0f 82 87 00 00 00    	jb     803cf4 <__umoddi3+0x134>
  803c6d:	0f 84 91 00 00 00    	je     803d04 <__umoddi3+0x144>
  803c73:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c77:	29 f2                	sub    %esi,%edx
  803c79:	19 cb                	sbb    %ecx,%ebx
  803c7b:	89 d8                	mov    %ebx,%eax
  803c7d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c81:	d3 e0                	shl    %cl,%eax
  803c83:	89 e9                	mov    %ebp,%ecx
  803c85:	d3 ea                	shr    %cl,%edx
  803c87:	09 d0                	or     %edx,%eax
  803c89:	89 e9                	mov    %ebp,%ecx
  803c8b:	d3 eb                	shr    %cl,%ebx
  803c8d:	89 da                	mov    %ebx,%edx
  803c8f:	83 c4 1c             	add    $0x1c,%esp
  803c92:	5b                   	pop    %ebx
  803c93:	5e                   	pop    %esi
  803c94:	5f                   	pop    %edi
  803c95:	5d                   	pop    %ebp
  803c96:	c3                   	ret    
  803c97:	90                   	nop
  803c98:	89 fd                	mov    %edi,%ebp
  803c9a:	85 ff                	test   %edi,%edi
  803c9c:	75 0b                	jne    803ca9 <__umoddi3+0xe9>
  803c9e:	b8 01 00 00 00       	mov    $0x1,%eax
  803ca3:	31 d2                	xor    %edx,%edx
  803ca5:	f7 f7                	div    %edi
  803ca7:	89 c5                	mov    %eax,%ebp
  803ca9:	89 f0                	mov    %esi,%eax
  803cab:	31 d2                	xor    %edx,%edx
  803cad:	f7 f5                	div    %ebp
  803caf:	89 c8                	mov    %ecx,%eax
  803cb1:	f7 f5                	div    %ebp
  803cb3:	89 d0                	mov    %edx,%eax
  803cb5:	e9 44 ff ff ff       	jmp    803bfe <__umoddi3+0x3e>
  803cba:	66 90                	xchg   %ax,%ax
  803cbc:	89 c8                	mov    %ecx,%eax
  803cbe:	89 f2                	mov    %esi,%edx
  803cc0:	83 c4 1c             	add    $0x1c,%esp
  803cc3:	5b                   	pop    %ebx
  803cc4:	5e                   	pop    %esi
  803cc5:	5f                   	pop    %edi
  803cc6:	5d                   	pop    %ebp
  803cc7:	c3                   	ret    
  803cc8:	3b 04 24             	cmp    (%esp),%eax
  803ccb:	72 06                	jb     803cd3 <__umoddi3+0x113>
  803ccd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cd1:	77 0f                	ja     803ce2 <__umoddi3+0x122>
  803cd3:	89 f2                	mov    %esi,%edx
  803cd5:	29 f9                	sub    %edi,%ecx
  803cd7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803cdb:	89 14 24             	mov    %edx,(%esp)
  803cde:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ce2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ce6:	8b 14 24             	mov    (%esp),%edx
  803ce9:	83 c4 1c             	add    $0x1c,%esp
  803cec:	5b                   	pop    %ebx
  803ced:	5e                   	pop    %esi
  803cee:	5f                   	pop    %edi
  803cef:	5d                   	pop    %ebp
  803cf0:	c3                   	ret    
  803cf1:	8d 76 00             	lea    0x0(%esi),%esi
  803cf4:	2b 04 24             	sub    (%esp),%eax
  803cf7:	19 fa                	sbb    %edi,%edx
  803cf9:	89 d1                	mov    %edx,%ecx
  803cfb:	89 c6                	mov    %eax,%esi
  803cfd:	e9 71 ff ff ff       	jmp    803c73 <__umoddi3+0xb3>
  803d02:	66 90                	xchg   %ax,%ax
  803d04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d08:	72 ea                	jb     803cf4 <__umoddi3+0x134>
  803d0a:	89 d9                	mov    %ebx,%ecx
  803d0c:	e9 62 ff ff ff       	jmp    803c73 <__umoddi3+0xb3>
