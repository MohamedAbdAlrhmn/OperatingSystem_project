
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
  800045:	e8 db 23 00 00       	call   802425 <sys_set_uheap_strategy>
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
  80009b:	68 40 3d 80 00       	push   $0x803d40
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 5c 3d 80 00       	push   $0x803d5c
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
  8000f5:	68 74 3d 80 00       	push   $0x803d74
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 5c 3d 80 00       	push   $0x803d5c
  800101:	e8 21 09 00 00       	call   800a27 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 05 1e 00 00       	call   801f10 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 9d 1e 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  80013a:	68 b8 3d 80 00       	push   $0x803db8
  80013f:	6a 31                	push   $0x31
  800141:	68 5c 3d 80 00       	push   $0x803d5c
  800146:	e8 dc 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80014b:	e8 60 1e 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  800150:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800153:	3d 00 02 00 00       	cmp    $0x200,%eax
  800158:	74 14                	je     80016e <_main+0x136>
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	68 e8 3d 80 00       	push   $0x803de8
  800162:	6a 33                	push   $0x33
  800164:	68 5c 3d 80 00       	push   $0x803d5c
  800169:	e8 b9 08 00 00       	call   800a27 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80016e:	e8 9d 1d 00 00       	call   801f10 <sys_calculate_free_frames>
  800173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800176:	e8 35 1e 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  8001ab:	68 b8 3d 80 00       	push   $0x803db8
  8001b0:	6a 39                	push   $0x39
  8001b2:	68 5c 3d 80 00       	push   $0x803d5c
  8001b7:	e8 6b 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001bc:	e8 ef 1d 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  8001c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 e8 3d 80 00       	push   $0x803de8
  8001d3:	6a 3b                	push   $0x3b
  8001d5:	68 5c 3d 80 00       	push   $0x803d5c
  8001da:	e8 48 08 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 2c 1d 00 00       	call   801f10 <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 c4 1d 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  80021a:	68 b8 3d 80 00       	push   $0x803db8
  80021f:	6a 41                	push   $0x41
  800221:	68 5c 3d 80 00       	push   $0x803d5c
  800226:	e8 fc 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80022b:	e8 80 1d 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  800230:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800233:	83 f8 01             	cmp    $0x1,%eax
  800236:	74 14                	je     80024c <_main+0x214>
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 e8 3d 80 00       	push   $0x803de8
  800240:	6a 43                	push   $0x43
  800242:	68 5c 3d 80 00       	push   $0x803d5c
  800247:	e8 db 07 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80024c:	e8 bf 1c 00 00       	call   801f10 <sys_calculate_free_frames>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800254:	e8 57 1d 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  800291:	68 b8 3d 80 00       	push   $0x803db8
  800296:	6a 49                	push   $0x49
  800298:	68 5c 3d 80 00       	push   $0x803d5c
  80029d:	e8 85 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002a2:	e8 09 1d 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  8002a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002aa:	83 f8 01             	cmp    $0x1,%eax
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 e8 3d 80 00       	push   $0x803de8
  8002b7:	6a 4b                	push   $0x4b
  8002b9:	68 5c 3d 80 00       	push   $0x803d5c
  8002be:	e8 64 07 00 00       	call   800a27 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002c3:	e8 48 1c 00 00       	call   801f10 <sys_calculate_free_frames>
  8002c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cb:	e8 e0 1c 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  8002d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 b2 19 00 00       	call   801c91 <free>
  8002df:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002e2:	e8 c9 1c 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  8002e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ea:	29 c2                	sub    %eax,%edx
  8002ec:	89 d0                	mov    %edx,%eax
  8002ee:	83 f8 01             	cmp    $0x1,%eax
  8002f1:	74 14                	je     800307 <_main+0x2cf>
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	68 05 3e 80 00       	push   $0x803e05
  8002fb:	6a 52                	push   $0x52
  8002fd:	68 5c 3d 80 00       	push   $0x803d5c
  800302:	e8 20 07 00 00       	call   800a27 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  800307:	e8 04 1c 00 00       	call   801f10 <sys_calculate_free_frames>
  80030c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80030f:	e8 9c 1c 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  800354:	68 b8 3d 80 00       	push   $0x803db8
  800359:	6a 58                	push   $0x58
  80035b:	68 5c 3d 80 00       	push   $0x803d5c
  800360:	e8 c2 06 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800365:	e8 46 1c 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  80036a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80036d:	83 f8 02             	cmp    $0x2,%eax
  800370:	74 14                	je     800386 <_main+0x34e>
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 e8 3d 80 00       	push   $0x803de8
  80037a:	6a 5a                	push   $0x5a
  80037c:	68 5c 3d 80 00       	push   $0x803d5c
  800381:	e8 a1 06 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800386:	e8 85 1b 00 00       	call   801f10 <sys_calculate_free_frames>
  80038b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80038e:	e8 1d 1c 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  800393:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800396:	8b 45 90             	mov    -0x70(%ebp),%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	50                   	push   %eax
  80039d:	e8 ef 18 00 00       	call   801c91 <free>
  8003a2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003a5:	e8 06 1c 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	29 c2                	sub    %eax,%edx
  8003af:	89 d0                	mov    %edx,%eax
  8003b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003b6:	74 14                	je     8003cc <_main+0x394>
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	68 05 3e 80 00       	push   $0x803e05
  8003c0:	6a 61                	push   $0x61
  8003c2:	68 5c 3d 80 00       	push   $0x803d5c
  8003c7:	e8 5b 06 00 00       	call   800a27 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cc:	e8 3f 1b 00 00       	call   801f10 <sys_calculate_free_frames>
  8003d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d4:	e8 d7 1b 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  800418:	68 b8 3d 80 00       	push   $0x803db8
  80041d:	6a 67                	push   $0x67
  80041f:	68 5c 3d 80 00       	push   $0x803d5c
  800424:	e8 fe 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800429:	e8 82 1b 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  80044f:	68 e8 3d 80 00       	push   $0x803de8
  800454:	6a 69                	push   $0x69
  800456:	68 5c 3d 80 00       	push   $0x803d5c
  80045b:	e8 c7 05 00 00       	call   800a27 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800460:	e8 ab 1a 00 00       	call   801f10 <sys_calculate_free_frames>
  800465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800468:	e8 43 1b 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  8004b7:	68 b8 3d 80 00       	push   $0x803db8
  8004bc:	6a 6f                	push   $0x6f
  8004be:	68 5c 3d 80 00       	push   $0x803d5c
  8004c3:	e8 5f 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004c8:	e8 e3 1a 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  8004cd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004d0:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004d5:	74 14                	je     8004eb <_main+0x4b3>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 e8 3d 80 00       	push   $0x803de8
  8004df:	6a 71                	push   $0x71
  8004e1:	68 5c 3d 80 00       	push   $0x803d5c
  8004e6:	e8 3c 05 00 00       	call   800a27 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004eb:	e8 20 1a 00 00       	call   801f10 <sys_calculate_free_frames>
  8004f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f3:	e8 b8 1a 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  800542:	68 b8 3d 80 00       	push   $0x803db8
  800547:	6a 77                	push   $0x77
  800549:	68 5c 3d 80 00       	push   $0x803d5c
  80054e:	e8 d4 04 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  800553:	e8 58 1a 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  80057a:	68 e8 3d 80 00       	push   $0x803de8
  80057f:	6a 79                	push   $0x79
  800581:	68 5c 3d 80 00       	push   $0x803d5c
  800586:	e8 9c 04 00 00       	call   800a27 <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80058b:	e8 80 19 00 00       	call   801f10 <sys_calculate_free_frames>
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800593:	e8 18 1a 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80059b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 ea 16 00 00       	call   801c91 <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  8005aa:	e8 01 1a 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	29 c2                	sub    %eax,%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	3d 02 02 00 00       	cmp    $0x202,%eax
  8005bb:	74 17                	je     8005d4 <_main+0x59c>
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 05 3e 80 00       	push   $0x803e05
  8005c5:	68 80 00 00 00       	push   $0x80
  8005ca:	68 5c 3d 80 00       	push   $0x803d5c
  8005cf:	e8 53 04 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d4:	e8 37 19 00 00       	call   801f10 <sys_calculate_free_frames>
  8005d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005dc:	e8 cf 19 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005e4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	50                   	push   %eax
  8005eb:	e8 a1 16 00 00       	call   801c91 <free>
  8005f0:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8005f3:	e8 b8 19 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  8005f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fb:	29 c2                	sub    %eax,%edx
  8005fd:	89 d0                	mov    %edx,%eax
  8005ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  800604:	74 17                	je     80061d <_main+0x5e5>
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	68 05 3e 80 00       	push   $0x803e05
  80060e:	68 87 00 00 00       	push   $0x87
  800613:	68 5c 3d 80 00       	push   $0x803d5c
  800618:	e8 0a 04 00 00       	call   800a27 <_panic>

		//2 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  80061d:	e8 ee 18 00 00       	call   801f10 <sys_calculate_free_frames>
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800625:	e8 86 19 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  80066c:	68 b8 3d 80 00       	push   $0x803db8
  800671:	68 8d 00 00 00       	push   $0x8d
  800676:	68 5c 3d 80 00       	push   $0x803d5c
  80067b:	e8 a7 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800680:	e8 2b 19 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  800685:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800688:	3d 00 02 00 00       	cmp    $0x200,%eax
  80068d:	74 17                	je     8006a6 <_main+0x66e>
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 e8 3d 80 00       	push   $0x803de8
  800697:	68 8f 00 00 00       	push   $0x8f
  80069c:	68 5c 3d 80 00       	push   $0x803d5c
  8006a1:	e8 81 03 00 00       	call   800a27 <_panic>

		//6 KB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  8006a6:	e8 65 18 00 00       	call   801f10 <sys_calculate_free_frames>
  8006ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ae:	e8 fd 18 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  8006f5:	68 b8 3d 80 00       	push   $0x803db8
  8006fa:	68 95 00 00 00       	push   $0x95
  8006ff:	68 5c 3d 80 00       	push   $0x803d5c
  800704:	e8 1e 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800709:	e8 a2 18 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  80070e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800711:	83 f8 02             	cmp    $0x2,%eax
  800714:	74 17                	je     80072d <_main+0x6f5>
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	68 e8 3d 80 00       	push   $0x803de8
  80071e:	68 97 00 00 00       	push   $0x97
  800723:	68 5c 3d 80 00       	push   $0x803d5c
  800728:	e8 fa 02 00 00       	call   800a27 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80072d:	e8 de 17 00 00       	call   801f10 <sys_calculate_free_frames>
  800732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800735:	e8 76 18 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  80073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80073d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 48 15 00 00       	call   801c91 <free>
  800749:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  80074c:	e8 5f 18 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
  800751:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800754:	29 c2                	sub    %eax,%edx
  800756:	89 d0                	mov    %edx,%eax
  800758:	3d 00 03 00 00       	cmp    $0x300,%eax
  80075d:	74 17                	je     800776 <_main+0x73e>
  80075f:	83 ec 04             	sub    $0x4,%esp
  800762:	68 05 3e 80 00       	push   $0x803e05
  800767:	68 9e 00 00 00       	push   $0x9e
  80076c:	68 5c 3d 80 00       	push   $0x803d5c
  800771:	e8 b1 02 00 00       	call   800a27 <_panic>

		//3 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800776:	e8 95 17 00 00       	call   801f10 <sys_calculate_free_frames>
  80077b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80077e:	e8 2d 18 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  8007c2:	68 b8 3d 80 00       	push   $0x803db8
  8007c7:	68 a4 00 00 00       	push   $0xa4
  8007cc:	68 5c 3d 80 00       	push   $0x803d5c
  8007d1:	e8 51 02 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8007d6:	e8 d5 17 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  8007fc:	68 e8 3d 80 00       	push   $0x803de8
  800801:	68 a6 00 00 00       	push   $0xa6
  800806:	68 5c 3d 80 00       	push   $0x803d5c
  80080b:	e8 17 02 00 00       	call   800a27 <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800810:	e8 fb 16 00 00       	call   801f10 <sys_calculate_free_frames>
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800818:	e8 93 17 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  800845:	68 b8 3d 80 00       	push   $0x803db8
  80084a:	68 ac 00 00 00       	push   $0xac
  80084f:	68 5c 3d 80 00       	push   $0x803d5c
  800854:	e8 ce 01 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800859:	e8 52 17 00 00       	call   801fb0 <sys_pf_calculate_allocated_pages>
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
  80087c:	68 e8 3d 80 00       	push   $0x803de8
  800881:	68 ae 00 00 00       	push   $0xae
  800886:	68 5c 3d 80 00       	push   $0x803d5c
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
  8008bf:	68 1c 3e 80 00       	push   $0x803e1c
  8008c4:	68 b7 00 00 00       	push   $0xb7
  8008c9:	68 5c 3d 80 00       	push   $0x803d5c
  8008ce:	e8 54 01 00 00       	call   800a27 <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 80 3e 80 00       	push   $0x803e80
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
  8008f1:	e8 fa 18 00 00       	call   8021f0 <sys_getenvindex>
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
  80095c:	e8 9c 16 00 00       	call   801ffd <sys_disable_interrupt>
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 e0 3e 80 00       	push   $0x803ee0
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
  80098c:	68 08 3f 80 00       	push   $0x803f08
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
  8009bd:	68 30 3f 80 00       	push   $0x803f30
  8009c2:	e8 14 03 00 00       	call   800cdb <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8009cf:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	50                   	push   %eax
  8009d9:	68 88 3f 80 00       	push   $0x803f88
  8009de:	e8 f8 02 00 00       	call   800cdb <cprintf>
  8009e3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009e6:	83 ec 0c             	sub    $0xc,%esp
  8009e9:	68 e0 3e 80 00       	push   $0x803ee0
  8009ee:	e8 e8 02 00 00       	call   800cdb <cprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009f6:	e8 1c 16 00 00       	call   802017 <sys_enable_interrupt>

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
  800a0e:	e8 a9 17 00 00       	call   8021bc <sys_destroy_env>
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
  800a1f:	e8 fe 17 00 00       	call   802222 <sys_exit_env>
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
  800a48:	68 9c 3f 80 00       	push   $0x803f9c
  800a4d:	e8 89 02 00 00       	call   800cdb <cprintf>
  800a52:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a55:	a1 00 50 80 00       	mov    0x805000,%eax
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 08             	pushl  0x8(%ebp)
  800a60:	50                   	push   %eax
  800a61:	68 a1 3f 80 00       	push   $0x803fa1
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
  800a85:	68 bd 3f 80 00       	push   $0x803fbd
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
  800ab1:	68 c0 3f 80 00       	push   $0x803fc0
  800ab6:	6a 26                	push   $0x26
  800ab8:	68 0c 40 80 00       	push   $0x80400c
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
  800b83:	68 18 40 80 00       	push   $0x804018
  800b88:	6a 3a                	push   $0x3a
  800b8a:	68 0c 40 80 00       	push   $0x80400c
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
  800bf3:	68 6c 40 80 00       	push   $0x80406c
  800bf8:	6a 44                	push   $0x44
  800bfa:	68 0c 40 80 00       	push   $0x80400c
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
  800c4d:	e8 fd 11 00 00       	call   801e4f <sys_cputs>
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
  800cc4:	e8 86 11 00 00       	call   801e4f <sys_cputs>
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
  800d0e:	e8 ea 12 00 00       	call   801ffd <sys_disable_interrupt>
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
  800d2e:	e8 e4 12 00 00       	call   802017 <sys_enable_interrupt>
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
  800d78:	e8 57 2d 00 00       	call   803ad4 <__udivdi3>
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
  800dc8:	e8 17 2e 00 00       	call   803be4 <__umoddi3>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	05 d4 42 80 00       	add    $0x8042d4,%eax
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
  800f23:	8b 04 85 f8 42 80 00 	mov    0x8042f8(,%eax,4),%eax
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
  801004:	8b 34 9d 40 41 80 00 	mov    0x804140(,%ebx,4),%esi
  80100b:	85 f6                	test   %esi,%esi
  80100d:	75 19                	jne    801028 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80100f:	53                   	push   %ebx
  801010:	68 e5 42 80 00       	push   $0x8042e5
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
  801029:	68 ee 42 80 00       	push   $0x8042ee
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
  801056:	be f1 42 80 00       	mov    $0x8042f1,%esi
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
  801a7c:	68 50 44 80 00       	push   $0x804450
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
  801b4c:	e8 42 04 00 00       	call   801f93 <sys_allocate_chunk>
  801b51:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801b54:	a1 20 51 80 00       	mov    0x805120,%eax
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	50                   	push   %eax
  801b5d:	e8 b7 0a 00 00       	call   802619 <initialize_MemBlocksList>
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
  801b8a:	68 75 44 80 00       	push   $0x804475
  801b8f:	6a 33                	push   $0x33
  801b91:	68 93 44 80 00       	push   $0x804493
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
  801c09:	68 a0 44 80 00       	push   $0x8044a0
  801c0e:	6a 34                	push   $0x34
  801c10:	68 93 44 80 00       	push   $0x804493
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
  801c7e:	68 c4 44 80 00       	push   $0x8044c4
  801c83:	6a 46                	push   $0x46
  801c85:	68 93 44 80 00       	push   $0x804493
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
  801c9a:	68 ec 44 80 00       	push   $0x8044ec
  801c9f:	6a 61                	push   $0x61
  801ca1:	68 93 44 80 00       	push   $0x804493
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
  801cc0:	75 0a                	jne    801ccc <smalloc+0x21>
  801cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc7:	e9 9e 00 00 00       	jmp    801d6a <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801ccc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801cd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd9:	01 d0                	add    %edx,%eax
  801cdb:	48                   	dec    %eax
  801cdc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801cdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ce2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce7:	f7 75 f0             	divl   -0x10(%ebp)
  801cea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ced:	29 d0                	sub    %edx,%eax
  801cef:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801cf2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801cf9:	e8 63 06 00 00       	call   802361 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	74 11                	je     801d13 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801d02:	83 ec 0c             	sub    $0xc,%esp
  801d05:	ff 75 e8             	pushl  -0x18(%ebp)
  801d08:	e8 ce 0c 00 00       	call   8029db <alloc_block_FF>
  801d0d:	83 c4 10             	add    $0x10,%esp
  801d10:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801d13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d17:	74 4c                	je     801d65 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1c:	8b 40 08             	mov    0x8(%eax),%eax
  801d1f:	89 c2                	mov    %eax,%edx
  801d21:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d25:	52                   	push   %edx
  801d26:	50                   	push   %eax
  801d27:	ff 75 0c             	pushl  0xc(%ebp)
  801d2a:	ff 75 08             	pushl  0x8(%ebp)
  801d2d:	e8 b4 03 00 00       	call   8020e6 <sys_createSharedObject>
  801d32:	83 c4 10             	add    $0x10,%esp
  801d35:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801d38:	83 ec 08             	sub    $0x8,%esp
  801d3b:	ff 75 e0             	pushl  -0x20(%ebp)
  801d3e:	68 0f 45 80 00       	push   $0x80450f
  801d43:	e8 93 ef ff ff       	call   800cdb <cprintf>
  801d48:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801d4b:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801d4f:	74 14                	je     801d65 <smalloc+0xba>
  801d51:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801d55:	74 0e                	je     801d65 <smalloc+0xba>
  801d57:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801d5b:	74 08                	je     801d65 <smalloc+0xba>
			return (void*) mem_block->sva;
  801d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d60:	8b 40 08             	mov    0x8(%eax),%eax
  801d63:	eb 05                	jmp    801d6a <smalloc+0xbf>
	}
	return NULL;
  801d65:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d72:	e8 ee fc ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801d77:	83 ec 04             	sub    $0x4,%esp
  801d7a:	68 24 45 80 00       	push   $0x804524
  801d7f:	68 ab 00 00 00       	push   $0xab
  801d84:	68 93 44 80 00       	push   $0x804493
  801d89:	e8 99 ec ff ff       	call   800a27 <_panic>

00801d8e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d94:	e8 cc fc ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d99:	83 ec 04             	sub    $0x4,%esp
  801d9c:	68 48 45 80 00       	push   $0x804548
  801da1:	68 ef 00 00 00       	push   $0xef
  801da6:	68 93 44 80 00       	push   $0x804493
  801dab:	e8 77 ec ff ff       	call   800a27 <_panic>

00801db0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801db6:	83 ec 04             	sub    $0x4,%esp
  801db9:	68 70 45 80 00       	push   $0x804570
  801dbe:	68 03 01 00 00       	push   $0x103
  801dc3:	68 93 44 80 00       	push   $0x804493
  801dc8:	e8 5a ec ff ff       	call   800a27 <_panic>

00801dcd <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dd3:	83 ec 04             	sub    $0x4,%esp
  801dd6:	68 94 45 80 00       	push   $0x804594
  801ddb:	68 0e 01 00 00       	push   $0x10e
  801de0:	68 93 44 80 00       	push   $0x804493
  801de5:	e8 3d ec ff ff       	call   800a27 <_panic>

00801dea <shrink>:

}
void shrink(uint32 newSize)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801df0:	83 ec 04             	sub    $0x4,%esp
  801df3:	68 94 45 80 00       	push   $0x804594
  801df8:	68 13 01 00 00       	push   $0x113
  801dfd:	68 93 44 80 00       	push   $0x804493
  801e02:	e8 20 ec ff ff       	call   800a27 <_panic>

00801e07 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e0d:	83 ec 04             	sub    $0x4,%esp
  801e10:	68 94 45 80 00       	push   $0x804594
  801e15:	68 18 01 00 00       	push   $0x118
  801e1a:	68 93 44 80 00       	push   $0x804493
  801e1f:	e8 03 ec ff ff       	call   800a27 <_panic>

00801e24 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	57                   	push   %edi
  801e28:	56                   	push   %esi
  801e29:	53                   	push   %ebx
  801e2a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e33:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e36:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e39:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e3c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e3f:	cd 30                	int    $0x30
  801e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	5b                   	pop    %ebx
  801e4b:	5e                   	pop    %esi
  801e4c:	5f                   	pop    %edi
  801e4d:	5d                   	pop    %ebp
  801e4e:	c3                   	ret    

00801e4f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 04             	sub    $0x4,%esp
  801e55:	8b 45 10             	mov    0x10(%ebp),%eax
  801e58:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e5b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	52                   	push   %edx
  801e67:	ff 75 0c             	pushl  0xc(%ebp)
  801e6a:	50                   	push   %eax
  801e6b:	6a 00                	push   $0x0
  801e6d:	e8 b2 ff ff ff       	call   801e24 <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
}
  801e75:	90                   	nop
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sys_cgetc>:

int
sys_cgetc(void)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 01                	push   $0x1
  801e87:	e8 98 ff ff ff       	call   801e24 <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	52                   	push   %edx
  801ea1:	50                   	push   %eax
  801ea2:	6a 05                	push   $0x5
  801ea4:	e8 7b ff ff ff       	call   801e24 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	56                   	push   %esi
  801eb2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801eb3:	8b 75 18             	mov    0x18(%ebp),%esi
  801eb6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	56                   	push   %esi
  801ec3:	53                   	push   %ebx
  801ec4:	51                   	push   %ecx
  801ec5:	52                   	push   %edx
  801ec6:	50                   	push   %eax
  801ec7:	6a 06                	push   $0x6
  801ec9:	e8 56 ff ff ff       	call   801e24 <syscall>
  801ece:	83 c4 18             	add    $0x18,%esp
}
  801ed1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed4:	5b                   	pop    %ebx
  801ed5:	5e                   	pop    %esi
  801ed6:	5d                   	pop    %ebp
  801ed7:	c3                   	ret    

00801ed8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	52                   	push   %edx
  801ee8:	50                   	push   %eax
  801ee9:	6a 07                	push   $0x7
  801eeb:	e8 34 ff ff ff       	call   801e24 <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	ff 75 0c             	pushl  0xc(%ebp)
  801f01:	ff 75 08             	pushl  0x8(%ebp)
  801f04:	6a 08                	push   $0x8
  801f06:	e8 19 ff ff ff       	call   801e24 <syscall>
  801f0b:	83 c4 18             	add    $0x18,%esp
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 09                	push   $0x9
  801f1f:	e8 00 ff ff ff       	call   801e24 <syscall>
  801f24:	83 c4 18             	add    $0x18,%esp
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 0a                	push   $0xa
  801f38:	e8 e7 fe ff ff       	call   801e24 <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 0b                	push   $0xb
  801f51:	e8 ce fe ff ff       	call   801e24 <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	ff 75 0c             	pushl  0xc(%ebp)
  801f67:	ff 75 08             	pushl  0x8(%ebp)
  801f6a:	6a 0f                	push   $0xf
  801f6c:	e8 b3 fe ff ff       	call   801e24 <syscall>
  801f71:	83 c4 18             	add    $0x18,%esp
	return;
  801f74:	90                   	nop
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	ff 75 0c             	pushl  0xc(%ebp)
  801f83:	ff 75 08             	pushl  0x8(%ebp)
  801f86:	6a 10                	push   $0x10
  801f88:	e8 97 fe ff ff       	call   801e24 <syscall>
  801f8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f90:	90                   	nop
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	ff 75 10             	pushl  0x10(%ebp)
  801f9d:	ff 75 0c             	pushl  0xc(%ebp)
  801fa0:	ff 75 08             	pushl  0x8(%ebp)
  801fa3:	6a 11                	push   $0x11
  801fa5:	e8 7a fe ff ff       	call   801e24 <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
	return ;
  801fad:	90                   	nop
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 0c                	push   $0xc
  801fbf:	e8 60 fe ff ff       	call   801e24 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	ff 75 08             	pushl  0x8(%ebp)
  801fd7:	6a 0d                	push   $0xd
  801fd9:	e8 46 fe ff ff       	call   801e24 <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 0e                	push   $0xe
  801ff2:	e8 2d fe ff ff       	call   801e24 <syscall>
  801ff7:	83 c4 18             	add    $0x18,%esp
}
  801ffa:	90                   	nop
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 13                	push   $0x13
  80200c:	e8 13 fe ff ff       	call   801e24 <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	90                   	nop
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 14                	push   $0x14
  802026:	e8 f9 fd ff ff       	call   801e24 <syscall>
  80202b:	83 c4 18             	add    $0x18,%esp
}
  80202e:	90                   	nop
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_cputc>:


void
sys_cputc(const char c)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 04             	sub    $0x4,%esp
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80203d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	50                   	push   %eax
  80204a:	6a 15                	push   $0x15
  80204c:	e8 d3 fd ff ff       	call   801e24 <syscall>
  802051:	83 c4 18             	add    $0x18,%esp
}
  802054:	90                   	nop
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 16                	push   $0x16
  802066:	e8 b9 fd ff ff       	call   801e24 <syscall>
  80206b:	83 c4 18             	add    $0x18,%esp
}
  80206e:	90                   	nop
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	ff 75 0c             	pushl  0xc(%ebp)
  802080:	50                   	push   %eax
  802081:	6a 17                	push   $0x17
  802083:	e8 9c fd ff ff       	call   801e24 <syscall>
  802088:	83 c4 18             	add    $0x18,%esp
}
  80208b:	c9                   	leave  
  80208c:	c3                   	ret    

0080208d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802090:	8b 55 0c             	mov    0xc(%ebp),%edx
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	52                   	push   %edx
  80209d:	50                   	push   %eax
  80209e:	6a 1a                	push   $0x1a
  8020a0:	e8 7f fd ff ff       	call   801e24 <syscall>
  8020a5:	83 c4 18             	add    $0x18,%esp
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	52                   	push   %edx
  8020ba:	50                   	push   %eax
  8020bb:	6a 18                	push   $0x18
  8020bd:	e8 62 fd ff ff       	call   801e24 <syscall>
  8020c2:	83 c4 18             	add    $0x18,%esp
}
  8020c5:	90                   	nop
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	52                   	push   %edx
  8020d8:	50                   	push   %eax
  8020d9:	6a 19                	push   $0x19
  8020db:	e8 44 fd ff ff       	call   801e24 <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
}
  8020e3:	90                   	nop
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	83 ec 04             	sub    $0x4,%esp
  8020ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020f2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020f5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	6a 00                	push   $0x0
  8020fe:	51                   	push   %ecx
  8020ff:	52                   	push   %edx
  802100:	ff 75 0c             	pushl  0xc(%ebp)
  802103:	50                   	push   %eax
  802104:	6a 1b                	push   $0x1b
  802106:	e8 19 fd ff ff       	call   801e24 <syscall>
  80210b:	83 c4 18             	add    $0x18,%esp
}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802113:	8b 55 0c             	mov    0xc(%ebp),%edx
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	52                   	push   %edx
  802120:	50                   	push   %eax
  802121:	6a 1c                	push   $0x1c
  802123:	e8 fc fc ff ff       	call   801e24 <syscall>
  802128:	83 c4 18             	add    $0x18,%esp
}
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802130:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802133:	8b 55 0c             	mov    0xc(%ebp),%edx
  802136:	8b 45 08             	mov    0x8(%ebp),%eax
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	51                   	push   %ecx
  80213e:	52                   	push   %edx
  80213f:	50                   	push   %eax
  802140:	6a 1d                	push   $0x1d
  802142:	e8 dd fc ff ff       	call   801e24 <syscall>
  802147:	83 c4 18             	add    $0x18,%esp
}
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    

0080214c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80214f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	52                   	push   %edx
  80215c:	50                   	push   %eax
  80215d:	6a 1e                	push   $0x1e
  80215f:	e8 c0 fc ff ff       	call   801e24 <syscall>
  802164:	83 c4 18             	add    $0x18,%esp
}
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 1f                	push   $0x1f
  802178:	e8 a7 fc ff ff       	call   801e24 <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	6a 00                	push   $0x0
  80218a:	ff 75 14             	pushl  0x14(%ebp)
  80218d:	ff 75 10             	pushl  0x10(%ebp)
  802190:	ff 75 0c             	pushl  0xc(%ebp)
  802193:	50                   	push   %eax
  802194:	6a 20                	push   $0x20
  802196:	e8 89 fc ff ff       	call   801e24 <syscall>
  80219b:	83 c4 18             	add    $0x18,%esp
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	50                   	push   %eax
  8021af:	6a 21                	push   $0x21
  8021b1:	e8 6e fc ff ff       	call   801e24 <syscall>
  8021b6:	83 c4 18             	add    $0x18,%esp
}
  8021b9:	90                   	nop
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	50                   	push   %eax
  8021cb:	6a 22                	push   $0x22
  8021cd:	e8 52 fc ff ff       	call   801e24 <syscall>
  8021d2:	83 c4 18             	add    $0x18,%esp
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 02                	push   $0x2
  8021e6:	e8 39 fc ff ff       	call   801e24 <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 03                	push   $0x3
  8021ff:	e8 20 fc ff ff       	call   801e24 <syscall>
  802204:	83 c4 18             	add    $0x18,%esp
}
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 04                	push   $0x4
  802218:	e8 07 fc ff ff       	call   801e24 <syscall>
  80221d:	83 c4 18             	add    $0x18,%esp
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <sys_exit_env>:


void sys_exit_env(void)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 23                	push   $0x23
  802231:	e8 ee fb ff ff       	call   801e24 <syscall>
  802236:	83 c4 18             	add    $0x18,%esp
}
  802239:	90                   	nop
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802242:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802245:	8d 50 04             	lea    0x4(%eax),%edx
  802248:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	52                   	push   %edx
  802252:	50                   	push   %eax
  802253:	6a 24                	push   $0x24
  802255:	e8 ca fb ff ff       	call   801e24 <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
	return result;
  80225d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802260:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802263:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802266:	89 01                	mov    %eax,(%ecx)
  802268:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	c9                   	leave  
  80226f:	c2 04 00             	ret    $0x4

00802272 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	ff 75 10             	pushl  0x10(%ebp)
  80227c:	ff 75 0c             	pushl  0xc(%ebp)
  80227f:	ff 75 08             	pushl  0x8(%ebp)
  802282:	6a 12                	push   $0x12
  802284:	e8 9b fb ff ff       	call   801e24 <syscall>
  802289:	83 c4 18             	add    $0x18,%esp
	return ;
  80228c:	90                   	nop
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <sys_rcr2>:
uint32 sys_rcr2()
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 25                	push   $0x25
  80229e:	e8 81 fb ff ff       	call   801e24 <syscall>
  8022a3:	83 c4 18             	add    $0x18,%esp
}
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
  8022ab:	83 ec 04             	sub    $0x4,%esp
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022b4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	50                   	push   %eax
  8022c1:	6a 26                	push   $0x26
  8022c3:	e8 5c fb ff ff       	call   801e24 <syscall>
  8022c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8022cb:	90                   	nop
}
  8022cc:	c9                   	leave  
  8022cd:	c3                   	ret    

008022ce <rsttst>:
void rsttst()
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 28                	push   $0x28
  8022dd:	e8 42 fb ff ff       	call   801e24 <syscall>
  8022e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e5:	90                   	nop
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 04             	sub    $0x4,%esp
  8022ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8022f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022f4:	8b 55 18             	mov    0x18(%ebp),%edx
  8022f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022fb:	52                   	push   %edx
  8022fc:	50                   	push   %eax
  8022fd:	ff 75 10             	pushl  0x10(%ebp)
  802300:	ff 75 0c             	pushl  0xc(%ebp)
  802303:	ff 75 08             	pushl  0x8(%ebp)
  802306:	6a 27                	push   $0x27
  802308:	e8 17 fb ff ff       	call   801e24 <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
	return ;
  802310:	90                   	nop
}
  802311:	c9                   	leave  
  802312:	c3                   	ret    

00802313 <chktst>:
void chktst(uint32 n)
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	ff 75 08             	pushl  0x8(%ebp)
  802321:	6a 29                	push   $0x29
  802323:	e8 fc fa ff ff       	call   801e24 <syscall>
  802328:	83 c4 18             	add    $0x18,%esp
	return ;
  80232b:	90                   	nop
}
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    

0080232e <inctst>:

void inctst()
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 2a                	push   $0x2a
  80233d:	e8 e2 fa ff ff       	call   801e24 <syscall>
  802342:	83 c4 18             	add    $0x18,%esp
	return ;
  802345:	90                   	nop
}
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <gettst>:
uint32 gettst()
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 2b                	push   $0x2b
  802357:	e8 c8 fa ff ff       	call   801e24 <syscall>
  80235c:	83 c4 18             	add    $0x18,%esp
}
  80235f:	c9                   	leave  
  802360:	c3                   	ret    

00802361 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
  802364:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 2c                	push   $0x2c
  802373:	e8 ac fa ff ff       	call   801e24 <syscall>
  802378:	83 c4 18             	add    $0x18,%esp
  80237b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80237e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802382:	75 07                	jne    80238b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802384:	b8 01 00 00 00       	mov    $0x1,%eax
  802389:	eb 05                	jmp    802390 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80238b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
  802395:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 2c                	push   $0x2c
  8023a4:	e8 7b fa ff ff       	call   801e24 <syscall>
  8023a9:	83 c4 18             	add    $0x18,%esp
  8023ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023af:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023b3:	75 07                	jne    8023bc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ba:	eb 05                	jmp    8023c1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
  8023c6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 2c                	push   $0x2c
  8023d5:	e8 4a fa ff ff       	call   801e24 <syscall>
  8023da:	83 c4 18             	add    $0x18,%esp
  8023dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023e0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023e4:	75 07                	jne    8023ed <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023eb:	eb 05                	jmp    8023f2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
  8023f7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 2c                	push   $0x2c
  802406:	e8 19 fa ff ff       	call   801e24 <syscall>
  80240b:	83 c4 18             	add    $0x18,%esp
  80240e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802411:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802415:	75 07                	jne    80241e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802417:	b8 01 00 00 00       	mov    $0x1,%eax
  80241c:	eb 05                	jmp    802423 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80241e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802423:	c9                   	leave  
  802424:	c3                   	ret    

00802425 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802425:	55                   	push   %ebp
  802426:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	ff 75 08             	pushl  0x8(%ebp)
  802433:	6a 2d                	push   $0x2d
  802435:	e8 ea f9 ff ff       	call   801e24 <syscall>
  80243a:	83 c4 18             	add    $0x18,%esp
	return ;
  80243d:	90                   	nop
}
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
  802443:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802444:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802447:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80244a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80244d:	8b 45 08             	mov    0x8(%ebp),%eax
  802450:	6a 00                	push   $0x0
  802452:	53                   	push   %ebx
  802453:	51                   	push   %ecx
  802454:	52                   	push   %edx
  802455:	50                   	push   %eax
  802456:	6a 2e                	push   $0x2e
  802458:	e8 c7 f9 ff ff       	call   801e24 <syscall>
  80245d:	83 c4 18             	add    $0x18,%esp
}
  802460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802468:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	52                   	push   %edx
  802475:	50                   	push   %eax
  802476:	6a 2f                	push   $0x2f
  802478:	e8 a7 f9 ff ff       	call   801e24 <syscall>
  80247d:	83 c4 18             	add    $0x18,%esp
}
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802488:	83 ec 0c             	sub    $0xc,%esp
  80248b:	68 a4 45 80 00       	push   $0x8045a4
  802490:	e8 46 e8 ff ff       	call   800cdb <cprintf>
  802495:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802498:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80249f:	83 ec 0c             	sub    $0xc,%esp
  8024a2:	68 d0 45 80 00       	push   $0x8045d0
  8024a7:	e8 2f e8 ff ff       	call   800cdb <cprintf>
  8024ac:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024af:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8024b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bb:	eb 56                	jmp    802513 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024c1:	74 1c                	je     8024df <print_mem_block_lists+0x5d>
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	8b 50 08             	mov    0x8(%eax),%edx
  8024c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cc:	8b 48 08             	mov    0x8(%eax),%ecx
  8024cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d5:	01 c8                	add    %ecx,%eax
  8024d7:	39 c2                	cmp    %eax,%edx
  8024d9:	73 04                	jae    8024df <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8024db:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 50 08             	mov    0x8(%eax),%edx
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024eb:	01 c2                	add    %eax,%edx
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 40 08             	mov    0x8(%eax),%eax
  8024f3:	83 ec 04             	sub    $0x4,%esp
  8024f6:	52                   	push   %edx
  8024f7:	50                   	push   %eax
  8024f8:	68 e5 45 80 00       	push   $0x8045e5
  8024fd:	e8 d9 e7 ff ff       	call   800cdb <cprintf>
  802502:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80250b:	a1 40 51 80 00       	mov    0x805140,%eax
  802510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802513:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802517:	74 07                	je     802520 <print_mem_block_lists+0x9e>
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	eb 05                	jmp    802525 <print_mem_block_lists+0xa3>
  802520:	b8 00 00 00 00       	mov    $0x0,%eax
  802525:	a3 40 51 80 00       	mov    %eax,0x805140
  80252a:	a1 40 51 80 00       	mov    0x805140,%eax
  80252f:	85 c0                	test   %eax,%eax
  802531:	75 8a                	jne    8024bd <print_mem_block_lists+0x3b>
  802533:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802537:	75 84                	jne    8024bd <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802539:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80253d:	75 10                	jne    80254f <print_mem_block_lists+0xcd>
  80253f:	83 ec 0c             	sub    $0xc,%esp
  802542:	68 f4 45 80 00       	push   $0x8045f4
  802547:	e8 8f e7 ff ff       	call   800cdb <cprintf>
  80254c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80254f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802556:	83 ec 0c             	sub    $0xc,%esp
  802559:	68 18 46 80 00       	push   $0x804618
  80255e:	e8 78 e7 ff ff       	call   800cdb <cprintf>
  802563:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802566:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80256a:	a1 40 50 80 00       	mov    0x805040,%eax
  80256f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802572:	eb 56                	jmp    8025ca <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802574:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802578:	74 1c                	je     802596 <print_mem_block_lists+0x114>
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 50 08             	mov    0x8(%eax),%edx
  802580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802583:	8b 48 08             	mov    0x8(%eax),%ecx
  802586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802589:	8b 40 0c             	mov    0xc(%eax),%eax
  80258c:	01 c8                	add    %ecx,%eax
  80258e:	39 c2                	cmp    %eax,%edx
  802590:	73 04                	jae    802596 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802592:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	8b 50 08             	mov    0x8(%eax),%edx
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a2:	01 c2                	add    %eax,%edx
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 40 08             	mov    0x8(%eax),%eax
  8025aa:	83 ec 04             	sub    $0x4,%esp
  8025ad:	52                   	push   %edx
  8025ae:	50                   	push   %eax
  8025af:	68 e5 45 80 00       	push   $0x8045e5
  8025b4:	e8 22 e7 ff ff       	call   800cdb <cprintf>
  8025b9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025c2:	a1 48 50 80 00       	mov    0x805048,%eax
  8025c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ce:	74 07                	je     8025d7 <print_mem_block_lists+0x155>
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 00                	mov    (%eax),%eax
  8025d5:	eb 05                	jmp    8025dc <print_mem_block_lists+0x15a>
  8025d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025dc:	a3 48 50 80 00       	mov    %eax,0x805048
  8025e1:	a1 48 50 80 00       	mov    0x805048,%eax
  8025e6:	85 c0                	test   %eax,%eax
  8025e8:	75 8a                	jne    802574 <print_mem_block_lists+0xf2>
  8025ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ee:	75 84                	jne    802574 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8025f0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025f4:	75 10                	jne    802606 <print_mem_block_lists+0x184>
  8025f6:	83 ec 0c             	sub    $0xc,%esp
  8025f9:	68 30 46 80 00       	push   $0x804630
  8025fe:	e8 d8 e6 ff ff       	call   800cdb <cprintf>
  802603:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802606:	83 ec 0c             	sub    $0xc,%esp
  802609:	68 a4 45 80 00       	push   $0x8045a4
  80260e:	e8 c8 e6 ff ff       	call   800cdb <cprintf>
  802613:	83 c4 10             	add    $0x10,%esp

}
  802616:	90                   	nop
  802617:	c9                   	leave  
  802618:	c3                   	ret    

00802619 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
  80261c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80261f:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802626:	00 00 00 
  802629:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802630:	00 00 00 
  802633:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80263a:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80263d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802644:	e9 9e 00 00 00       	jmp    8026e7 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802649:	a1 50 50 80 00       	mov    0x805050,%eax
  80264e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802651:	c1 e2 04             	shl    $0x4,%edx
  802654:	01 d0                	add    %edx,%eax
  802656:	85 c0                	test   %eax,%eax
  802658:	75 14                	jne    80266e <initialize_MemBlocksList+0x55>
  80265a:	83 ec 04             	sub    $0x4,%esp
  80265d:	68 58 46 80 00       	push   $0x804658
  802662:	6a 46                	push   $0x46
  802664:	68 7b 46 80 00       	push   $0x80467b
  802669:	e8 b9 e3 ff ff       	call   800a27 <_panic>
  80266e:	a1 50 50 80 00       	mov    0x805050,%eax
  802673:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802676:	c1 e2 04             	shl    $0x4,%edx
  802679:	01 d0                	add    %edx,%eax
  80267b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802681:	89 10                	mov    %edx,(%eax)
  802683:	8b 00                	mov    (%eax),%eax
  802685:	85 c0                	test   %eax,%eax
  802687:	74 18                	je     8026a1 <initialize_MemBlocksList+0x88>
  802689:	a1 48 51 80 00       	mov    0x805148,%eax
  80268e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802694:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802697:	c1 e1 04             	shl    $0x4,%ecx
  80269a:	01 ca                	add    %ecx,%edx
  80269c:	89 50 04             	mov    %edx,0x4(%eax)
  80269f:	eb 12                	jmp    8026b3 <initialize_MemBlocksList+0x9a>
  8026a1:	a1 50 50 80 00       	mov    0x805050,%eax
  8026a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a9:	c1 e2 04             	shl    $0x4,%edx
  8026ac:	01 d0                	add    %edx,%eax
  8026ae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026b3:	a1 50 50 80 00       	mov    0x805050,%eax
  8026b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bb:	c1 e2 04             	shl    $0x4,%edx
  8026be:	01 d0                	add    %edx,%eax
  8026c0:	a3 48 51 80 00       	mov    %eax,0x805148
  8026c5:	a1 50 50 80 00       	mov    0x805050,%eax
  8026ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cd:	c1 e2 04             	shl    $0x4,%edx
  8026d0:	01 d0                	add    %edx,%eax
  8026d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d9:	a1 54 51 80 00       	mov    0x805154,%eax
  8026de:	40                   	inc    %eax
  8026df:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8026e4:	ff 45 f4             	incl   -0xc(%ebp)
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ed:	0f 82 56 ff ff ff    	jb     802649 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8026f3:	90                   	nop
  8026f4:	c9                   	leave  
  8026f5:	c3                   	ret    

008026f6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8026f6:	55                   	push   %ebp
  8026f7:	89 e5                	mov    %esp,%ebp
  8026f9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8026fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ff:	8b 00                	mov    (%eax),%eax
  802701:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802704:	eb 19                	jmp    80271f <find_block+0x29>
	{
		if(va==point->sva)
  802706:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802709:	8b 40 08             	mov    0x8(%eax),%eax
  80270c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80270f:	75 05                	jne    802716 <find_block+0x20>
		   return point;
  802711:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802714:	eb 36                	jmp    80274c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	8b 40 08             	mov    0x8(%eax),%eax
  80271c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80271f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802723:	74 07                	je     80272c <find_block+0x36>
  802725:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802728:	8b 00                	mov    (%eax),%eax
  80272a:	eb 05                	jmp    802731 <find_block+0x3b>
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
  802731:	8b 55 08             	mov    0x8(%ebp),%edx
  802734:	89 42 08             	mov    %eax,0x8(%edx)
  802737:	8b 45 08             	mov    0x8(%ebp),%eax
  80273a:	8b 40 08             	mov    0x8(%eax),%eax
  80273d:	85 c0                	test   %eax,%eax
  80273f:	75 c5                	jne    802706 <find_block+0x10>
  802741:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802745:	75 bf                	jne    802706 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802747:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80274c:	c9                   	leave  
  80274d:	c3                   	ret    

0080274e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
  802751:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802754:	a1 40 50 80 00       	mov    0x805040,%eax
  802759:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80275c:	a1 44 50 80 00       	mov    0x805044,%eax
  802761:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802767:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80276a:	74 24                	je     802790 <insert_sorted_allocList+0x42>
  80276c:	8b 45 08             	mov    0x8(%ebp),%eax
  80276f:	8b 50 08             	mov    0x8(%eax),%edx
  802772:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802775:	8b 40 08             	mov    0x8(%eax),%eax
  802778:	39 c2                	cmp    %eax,%edx
  80277a:	76 14                	jbe    802790 <insert_sorted_allocList+0x42>
  80277c:	8b 45 08             	mov    0x8(%ebp),%eax
  80277f:	8b 50 08             	mov    0x8(%eax),%edx
  802782:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802785:	8b 40 08             	mov    0x8(%eax),%eax
  802788:	39 c2                	cmp    %eax,%edx
  80278a:	0f 82 60 01 00 00    	jb     8028f0 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802790:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802794:	75 65                	jne    8027fb <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802796:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80279a:	75 14                	jne    8027b0 <insert_sorted_allocList+0x62>
  80279c:	83 ec 04             	sub    $0x4,%esp
  80279f:	68 58 46 80 00       	push   $0x804658
  8027a4:	6a 6b                	push   $0x6b
  8027a6:	68 7b 46 80 00       	push   $0x80467b
  8027ab:	e8 77 e2 ff ff       	call   800a27 <_panic>
  8027b0:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b9:	89 10                	mov    %edx,(%eax)
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	8b 00                	mov    (%eax),%eax
  8027c0:	85 c0                	test   %eax,%eax
  8027c2:	74 0d                	je     8027d1 <insert_sorted_allocList+0x83>
  8027c4:	a1 40 50 80 00       	mov    0x805040,%eax
  8027c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027cc:	89 50 04             	mov    %edx,0x4(%eax)
  8027cf:	eb 08                	jmp    8027d9 <insert_sorted_allocList+0x8b>
  8027d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d4:	a3 44 50 80 00       	mov    %eax,0x805044
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	a3 40 50 80 00       	mov    %eax,0x805040
  8027e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027eb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027f0:	40                   	inc    %eax
  8027f1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027f6:	e9 dc 01 00 00       	jmp    8029d7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8027fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fe:	8b 50 08             	mov    0x8(%eax),%edx
  802801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802804:	8b 40 08             	mov    0x8(%eax),%eax
  802807:	39 c2                	cmp    %eax,%edx
  802809:	77 6c                	ja     802877 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80280b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80280f:	74 06                	je     802817 <insert_sorted_allocList+0xc9>
  802811:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802815:	75 14                	jne    80282b <insert_sorted_allocList+0xdd>
  802817:	83 ec 04             	sub    $0x4,%esp
  80281a:	68 94 46 80 00       	push   $0x804694
  80281f:	6a 6f                	push   $0x6f
  802821:	68 7b 46 80 00       	push   $0x80467b
  802826:	e8 fc e1 ff ff       	call   800a27 <_panic>
  80282b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282e:	8b 50 04             	mov    0x4(%eax),%edx
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	89 50 04             	mov    %edx,0x4(%eax)
  802837:	8b 45 08             	mov    0x8(%ebp),%eax
  80283a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80283d:	89 10                	mov    %edx,(%eax)
  80283f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802842:	8b 40 04             	mov    0x4(%eax),%eax
  802845:	85 c0                	test   %eax,%eax
  802847:	74 0d                	je     802856 <insert_sorted_allocList+0x108>
  802849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284c:	8b 40 04             	mov    0x4(%eax),%eax
  80284f:	8b 55 08             	mov    0x8(%ebp),%edx
  802852:	89 10                	mov    %edx,(%eax)
  802854:	eb 08                	jmp    80285e <insert_sorted_allocList+0x110>
  802856:	8b 45 08             	mov    0x8(%ebp),%eax
  802859:	a3 40 50 80 00       	mov    %eax,0x805040
  80285e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802861:	8b 55 08             	mov    0x8(%ebp),%edx
  802864:	89 50 04             	mov    %edx,0x4(%eax)
  802867:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80286c:	40                   	inc    %eax
  80286d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802872:	e9 60 01 00 00       	jmp    8029d7 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802877:	8b 45 08             	mov    0x8(%ebp),%eax
  80287a:	8b 50 08             	mov    0x8(%eax),%edx
  80287d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802880:	8b 40 08             	mov    0x8(%eax),%eax
  802883:	39 c2                	cmp    %eax,%edx
  802885:	0f 82 4c 01 00 00    	jb     8029d7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80288b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80288f:	75 14                	jne    8028a5 <insert_sorted_allocList+0x157>
  802891:	83 ec 04             	sub    $0x4,%esp
  802894:	68 cc 46 80 00       	push   $0x8046cc
  802899:	6a 73                	push   $0x73
  80289b:	68 7b 46 80 00       	push   $0x80467b
  8028a0:	e8 82 e1 ff ff       	call   800a27 <_panic>
  8028a5:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	89 50 04             	mov    %edx,0x4(%eax)
  8028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b4:	8b 40 04             	mov    0x4(%eax),%eax
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	74 0c                	je     8028c7 <insert_sorted_allocList+0x179>
  8028bb:	a1 44 50 80 00       	mov    0x805044,%eax
  8028c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c3:	89 10                	mov    %edx,(%eax)
  8028c5:	eb 08                	jmp    8028cf <insert_sorted_allocList+0x181>
  8028c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ca:	a3 40 50 80 00       	mov    %eax,0x805040
  8028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d2:	a3 44 50 80 00       	mov    %eax,0x805044
  8028d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028e5:	40                   	inc    %eax
  8028e6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028eb:	e9 e7 00 00 00       	jmp    8029d7 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8028f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8028f6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8028fd:	a1 40 50 80 00       	mov    0x805040,%eax
  802902:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802905:	e9 9d 00 00 00       	jmp    8029a7 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 00                	mov    (%eax),%eax
  80290f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802912:	8b 45 08             	mov    0x8(%ebp),%eax
  802915:	8b 50 08             	mov    0x8(%eax),%edx
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 40 08             	mov    0x8(%eax),%eax
  80291e:	39 c2                	cmp    %eax,%edx
  802920:	76 7d                	jbe    80299f <insert_sorted_allocList+0x251>
  802922:	8b 45 08             	mov    0x8(%ebp),%eax
  802925:	8b 50 08             	mov    0x8(%eax),%edx
  802928:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292b:	8b 40 08             	mov    0x8(%eax),%eax
  80292e:	39 c2                	cmp    %eax,%edx
  802930:	73 6d                	jae    80299f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802932:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802936:	74 06                	je     80293e <insert_sorted_allocList+0x1f0>
  802938:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80293c:	75 14                	jne    802952 <insert_sorted_allocList+0x204>
  80293e:	83 ec 04             	sub    $0x4,%esp
  802941:	68 f0 46 80 00       	push   $0x8046f0
  802946:	6a 7f                	push   $0x7f
  802948:	68 7b 46 80 00       	push   $0x80467b
  80294d:	e8 d5 e0 ff ff       	call   800a27 <_panic>
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 10                	mov    (%eax),%edx
  802957:	8b 45 08             	mov    0x8(%ebp),%eax
  80295a:	89 10                	mov    %edx,(%eax)
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	74 0b                	je     802970 <insert_sorted_allocList+0x222>
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 00                	mov    (%eax),%eax
  80296a:	8b 55 08             	mov    0x8(%ebp),%edx
  80296d:	89 50 04             	mov    %edx,0x4(%eax)
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 55 08             	mov    0x8(%ebp),%edx
  802976:	89 10                	mov    %edx,(%eax)
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80297e:	89 50 04             	mov    %edx,0x4(%eax)
  802981:	8b 45 08             	mov    0x8(%ebp),%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	75 08                	jne    802992 <insert_sorted_allocList+0x244>
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	a3 44 50 80 00       	mov    %eax,0x805044
  802992:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802997:	40                   	inc    %eax
  802998:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80299d:	eb 39                	jmp    8029d8 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80299f:	a1 48 50 80 00       	mov    0x805048,%eax
  8029a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ab:	74 07                	je     8029b4 <insert_sorted_allocList+0x266>
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	8b 00                	mov    (%eax),%eax
  8029b2:	eb 05                	jmp    8029b9 <insert_sorted_allocList+0x26b>
  8029b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b9:	a3 48 50 80 00       	mov    %eax,0x805048
  8029be:	a1 48 50 80 00       	mov    0x805048,%eax
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	0f 85 3f ff ff ff    	jne    80290a <insert_sorted_allocList+0x1bc>
  8029cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cf:	0f 85 35 ff ff ff    	jne    80290a <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8029d5:	eb 01                	jmp    8029d8 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029d7:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8029d8:	90                   	nop
  8029d9:	c9                   	leave  
  8029da:	c3                   	ret    

008029db <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8029db:	55                   	push   %ebp
  8029dc:	89 e5                	mov    %esp,%ebp
  8029de:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8029e1:	a1 38 51 80 00       	mov    0x805138,%eax
  8029e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e9:	e9 85 01 00 00       	jmp    802b73 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f7:	0f 82 6e 01 00 00    	jb     802b6b <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 40 0c             	mov    0xc(%eax),%eax
  802a03:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a06:	0f 85 8a 00 00 00    	jne    802a96 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802a0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a10:	75 17                	jne    802a29 <alloc_block_FF+0x4e>
  802a12:	83 ec 04             	sub    $0x4,%esp
  802a15:	68 24 47 80 00       	push   $0x804724
  802a1a:	68 93 00 00 00       	push   $0x93
  802a1f:	68 7b 46 80 00       	push   $0x80467b
  802a24:	e8 fe df ff ff       	call   800a27 <_panic>
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 00                	mov    (%eax),%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	74 10                	je     802a42 <alloc_block_FF+0x67>
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 00                	mov    (%eax),%eax
  802a37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a3a:	8b 52 04             	mov    0x4(%edx),%edx
  802a3d:	89 50 04             	mov    %edx,0x4(%eax)
  802a40:	eb 0b                	jmp    802a4d <alloc_block_FF+0x72>
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	8b 40 04             	mov    0x4(%eax),%eax
  802a48:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 40 04             	mov    0x4(%eax),%eax
  802a53:	85 c0                	test   %eax,%eax
  802a55:	74 0f                	je     802a66 <alloc_block_FF+0x8b>
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	8b 40 04             	mov    0x4(%eax),%eax
  802a5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a60:	8b 12                	mov    (%edx),%edx
  802a62:	89 10                	mov    %edx,(%eax)
  802a64:	eb 0a                	jmp    802a70 <alloc_block_FF+0x95>
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	a3 38 51 80 00       	mov    %eax,0x805138
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a83:	a1 44 51 80 00       	mov    0x805144,%eax
  802a88:	48                   	dec    %eax
  802a89:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	e9 10 01 00 00       	jmp    802ba6 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a9f:	0f 86 c6 00 00 00    	jbe    802b6b <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aa5:	a1 48 51 80 00       	mov    0x805148,%eax
  802aaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	8b 50 08             	mov    0x8(%eax),%edx
  802ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab6:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abc:	8b 55 08             	mov    0x8(%ebp),%edx
  802abf:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ac2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac6:	75 17                	jne    802adf <alloc_block_FF+0x104>
  802ac8:	83 ec 04             	sub    $0x4,%esp
  802acb:	68 24 47 80 00       	push   $0x804724
  802ad0:	68 9b 00 00 00       	push   $0x9b
  802ad5:	68 7b 46 80 00       	push   $0x80467b
  802ada:	e8 48 df ff ff       	call   800a27 <_panic>
  802adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae2:	8b 00                	mov    (%eax),%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	74 10                	je     802af8 <alloc_block_FF+0x11d>
  802ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af0:	8b 52 04             	mov    0x4(%edx),%edx
  802af3:	89 50 04             	mov    %edx,0x4(%eax)
  802af6:	eb 0b                	jmp    802b03 <alloc_block_FF+0x128>
  802af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afb:	8b 40 04             	mov    0x4(%eax),%eax
  802afe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b06:	8b 40 04             	mov    0x4(%eax),%eax
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	74 0f                	je     802b1c <alloc_block_FF+0x141>
  802b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b10:	8b 40 04             	mov    0x4(%eax),%eax
  802b13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b16:	8b 12                	mov    (%edx),%edx
  802b18:	89 10                	mov    %edx,(%eax)
  802b1a:	eb 0a                	jmp    802b26 <alloc_block_FF+0x14b>
  802b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1f:	8b 00                	mov    (%eax),%eax
  802b21:	a3 48 51 80 00       	mov    %eax,0x805148
  802b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b39:	a1 54 51 80 00       	mov    0x805154,%eax
  802b3e:	48                   	dec    %eax
  802b3f:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 50 08             	mov    0x8(%eax),%edx
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	01 c2                	add    %eax,%edx
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5b:	2b 45 08             	sub    0x8(%ebp),%eax
  802b5e:	89 c2                	mov    %eax,%edx
  802b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b63:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b69:	eb 3b                	jmp    802ba6 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802b6b:	a1 40 51 80 00       	mov    0x805140,%eax
  802b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b77:	74 07                	je     802b80 <alloc_block_FF+0x1a5>
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	eb 05                	jmp    802b85 <alloc_block_FF+0x1aa>
  802b80:	b8 00 00 00 00       	mov    $0x0,%eax
  802b85:	a3 40 51 80 00       	mov    %eax,0x805140
  802b8a:	a1 40 51 80 00       	mov    0x805140,%eax
  802b8f:	85 c0                	test   %eax,%eax
  802b91:	0f 85 57 fe ff ff    	jne    8029ee <alloc_block_FF+0x13>
  802b97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9b:	0f 85 4d fe ff ff    	jne    8029ee <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802ba1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ba6:	c9                   	leave  
  802ba7:	c3                   	ret    

00802ba8 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ba8:	55                   	push   %ebp
  802ba9:	89 e5                	mov    %esp,%ebp
  802bab:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802bae:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802bb5:	a1 38 51 80 00       	mov    0x805138,%eax
  802bba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bbd:	e9 df 00 00 00       	jmp    802ca1 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bcb:	0f 82 c8 00 00 00    	jb     802c99 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bda:	0f 85 8a 00 00 00    	jne    802c6a <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802be0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be4:	75 17                	jne    802bfd <alloc_block_BF+0x55>
  802be6:	83 ec 04             	sub    $0x4,%esp
  802be9:	68 24 47 80 00       	push   $0x804724
  802bee:	68 b7 00 00 00       	push   $0xb7
  802bf3:	68 7b 46 80 00       	push   $0x80467b
  802bf8:	e8 2a de ff ff       	call   800a27 <_panic>
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
  802c02:	85 c0                	test   %eax,%eax
  802c04:	74 10                	je     802c16 <alloc_block_BF+0x6e>
  802c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c09:	8b 00                	mov    (%eax),%eax
  802c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0e:	8b 52 04             	mov    0x4(%edx),%edx
  802c11:	89 50 04             	mov    %edx,0x4(%eax)
  802c14:	eb 0b                	jmp    802c21 <alloc_block_BF+0x79>
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	8b 40 04             	mov    0x4(%eax),%eax
  802c1c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 40 04             	mov    0x4(%eax),%eax
  802c27:	85 c0                	test   %eax,%eax
  802c29:	74 0f                	je     802c3a <alloc_block_BF+0x92>
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	8b 40 04             	mov    0x4(%eax),%eax
  802c31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c34:	8b 12                	mov    (%edx),%edx
  802c36:	89 10                	mov    %edx,(%eax)
  802c38:	eb 0a                	jmp    802c44 <alloc_block_BF+0x9c>
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	8b 00                	mov    (%eax),%eax
  802c3f:	a3 38 51 80 00       	mov    %eax,0x805138
  802c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c57:	a1 44 51 80 00       	mov    0x805144,%eax
  802c5c:	48                   	dec    %eax
  802c5d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	e9 4d 01 00 00       	jmp    802db7 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c70:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c73:	76 24                	jbe    802c99 <alloc_block_BF+0xf1>
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c7e:	73 19                	jae    802c99 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802c80:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 40 08             	mov    0x8(%eax),%eax
  802c96:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c99:	a1 40 51 80 00       	mov    0x805140,%eax
  802c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca5:	74 07                	je     802cae <alloc_block_BF+0x106>
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	8b 00                	mov    (%eax),%eax
  802cac:	eb 05                	jmp    802cb3 <alloc_block_BF+0x10b>
  802cae:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb3:	a3 40 51 80 00       	mov    %eax,0x805140
  802cb8:	a1 40 51 80 00       	mov    0x805140,%eax
  802cbd:	85 c0                	test   %eax,%eax
  802cbf:	0f 85 fd fe ff ff    	jne    802bc2 <alloc_block_BF+0x1a>
  802cc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc9:	0f 85 f3 fe ff ff    	jne    802bc2 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802ccf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cd3:	0f 84 d9 00 00 00    	je     802db2 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cd9:	a1 48 51 80 00       	mov    0x805148,%eax
  802cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802ce1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce7:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802cea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ced:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf0:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802cf3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cf7:	75 17                	jne    802d10 <alloc_block_BF+0x168>
  802cf9:	83 ec 04             	sub    $0x4,%esp
  802cfc:	68 24 47 80 00       	push   $0x804724
  802d01:	68 c7 00 00 00       	push   $0xc7
  802d06:	68 7b 46 80 00       	push   $0x80467b
  802d0b:	e8 17 dd ff ff       	call   800a27 <_panic>
  802d10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d13:	8b 00                	mov    (%eax),%eax
  802d15:	85 c0                	test   %eax,%eax
  802d17:	74 10                	je     802d29 <alloc_block_BF+0x181>
  802d19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d21:	8b 52 04             	mov    0x4(%edx),%edx
  802d24:	89 50 04             	mov    %edx,0x4(%eax)
  802d27:	eb 0b                	jmp    802d34 <alloc_block_BF+0x18c>
  802d29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d2c:	8b 40 04             	mov    0x4(%eax),%eax
  802d2f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d37:	8b 40 04             	mov    0x4(%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	74 0f                	je     802d4d <alloc_block_BF+0x1a5>
  802d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d41:	8b 40 04             	mov    0x4(%eax),%eax
  802d44:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d47:	8b 12                	mov    (%edx),%edx
  802d49:	89 10                	mov    %edx,(%eax)
  802d4b:	eb 0a                	jmp    802d57 <alloc_block_BF+0x1af>
  802d4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d50:	8b 00                	mov    (%eax),%eax
  802d52:	a3 48 51 80 00       	mov    %eax,0x805148
  802d57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6a:	a1 54 51 80 00       	mov    0x805154,%eax
  802d6f:	48                   	dec    %eax
  802d70:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802d75:	83 ec 08             	sub    $0x8,%esp
  802d78:	ff 75 ec             	pushl  -0x14(%ebp)
  802d7b:	68 38 51 80 00       	push   $0x805138
  802d80:	e8 71 f9 ff ff       	call   8026f6 <find_block>
  802d85:	83 c4 10             	add    $0x10,%esp
  802d88:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802d8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d8e:	8b 50 08             	mov    0x8(%eax),%edx
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	01 c2                	add    %eax,%edx
  802d96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d99:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802d9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802da2:	2b 45 08             	sub    0x8(%ebp),%eax
  802da5:	89 c2                	mov    %eax,%edx
  802da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802daa:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802dad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db0:	eb 05                	jmp    802db7 <alloc_block_BF+0x20f>
	}
	return NULL;
  802db2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802db7:	c9                   	leave  
  802db8:	c3                   	ret    

00802db9 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802db9:	55                   	push   %ebp
  802dba:	89 e5                	mov    %esp,%ebp
  802dbc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802dbf:	a1 28 50 80 00       	mov    0x805028,%eax
  802dc4:	85 c0                	test   %eax,%eax
  802dc6:	0f 85 de 01 00 00    	jne    802faa <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802dcc:	a1 38 51 80 00       	mov    0x805138,%eax
  802dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dd4:	e9 9e 01 00 00       	jmp    802f77 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802de2:	0f 82 87 01 00 00    	jb     802f6f <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dee:	3b 45 08             	cmp    0x8(%ebp),%eax
  802df1:	0f 85 95 00 00 00    	jne    802e8c <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802df7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfb:	75 17                	jne    802e14 <alloc_block_NF+0x5b>
  802dfd:	83 ec 04             	sub    $0x4,%esp
  802e00:	68 24 47 80 00       	push   $0x804724
  802e05:	68 e0 00 00 00       	push   $0xe0
  802e0a:	68 7b 46 80 00       	push   $0x80467b
  802e0f:	e8 13 dc ff ff       	call   800a27 <_panic>
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	8b 00                	mov    (%eax),%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	74 10                	je     802e2d <alloc_block_NF+0x74>
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	8b 00                	mov    (%eax),%eax
  802e22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e25:	8b 52 04             	mov    0x4(%edx),%edx
  802e28:	89 50 04             	mov    %edx,0x4(%eax)
  802e2b:	eb 0b                	jmp    802e38 <alloc_block_NF+0x7f>
  802e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e30:	8b 40 04             	mov    0x4(%eax),%eax
  802e33:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 40 04             	mov    0x4(%eax),%eax
  802e3e:	85 c0                	test   %eax,%eax
  802e40:	74 0f                	je     802e51 <alloc_block_NF+0x98>
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 40 04             	mov    0x4(%eax),%eax
  802e48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4b:	8b 12                	mov    (%edx),%edx
  802e4d:	89 10                	mov    %edx,(%eax)
  802e4f:	eb 0a                	jmp    802e5b <alloc_block_NF+0xa2>
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 00                	mov    (%eax),%eax
  802e56:	a3 38 51 80 00       	mov    %eax,0x805138
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6e:	a1 44 51 80 00       	mov    0x805144,%eax
  802e73:	48                   	dec    %eax
  802e74:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 40 08             	mov    0x8(%eax),%eax
  802e7f:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	e9 f8 04 00 00       	jmp    803384 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e92:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e95:	0f 86 d4 00 00 00    	jbe    802f6f <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e9b:	a1 48 51 80 00       	mov    0x805148,%eax
  802ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	8b 50 08             	mov    0x8(%eax),%edx
  802ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eac:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb5:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802eb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ebc:	75 17                	jne    802ed5 <alloc_block_NF+0x11c>
  802ebe:	83 ec 04             	sub    $0x4,%esp
  802ec1:	68 24 47 80 00       	push   $0x804724
  802ec6:	68 e9 00 00 00       	push   $0xe9
  802ecb:	68 7b 46 80 00       	push   $0x80467b
  802ed0:	e8 52 db ff ff       	call   800a27 <_panic>
  802ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed8:	8b 00                	mov    (%eax),%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	74 10                	je     802eee <alloc_block_NF+0x135>
  802ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee1:	8b 00                	mov    (%eax),%eax
  802ee3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee6:	8b 52 04             	mov    0x4(%edx),%edx
  802ee9:	89 50 04             	mov    %edx,0x4(%eax)
  802eec:	eb 0b                	jmp    802ef9 <alloc_block_NF+0x140>
  802eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef1:	8b 40 04             	mov    0x4(%eax),%eax
  802ef4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efc:	8b 40 04             	mov    0x4(%eax),%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	74 0f                	je     802f12 <alloc_block_NF+0x159>
  802f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f06:	8b 40 04             	mov    0x4(%eax),%eax
  802f09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0c:	8b 12                	mov    (%edx),%edx
  802f0e:	89 10                	mov    %edx,(%eax)
  802f10:	eb 0a                	jmp    802f1c <alloc_block_NF+0x163>
  802f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	a3 48 51 80 00       	mov    %eax,0x805148
  802f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2f:	a1 54 51 80 00       	mov    0x805154,%eax
  802f34:	48                   	dec    %eax
  802f35:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3d:	8b 40 08             	mov    0x8(%eax),%eax
  802f40:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	8b 50 08             	mov    0x8(%eax),%edx
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	01 c2                	add    %eax,%edx
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5c:	2b 45 08             	sub    0x8(%ebp),%eax
  802f5f:	89 c2                	mov    %eax,%edx
  802f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f64:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6a:	e9 15 04 00 00       	jmp    803384 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802f6f:	a1 40 51 80 00       	mov    0x805140,%eax
  802f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f7b:	74 07                	je     802f84 <alloc_block_NF+0x1cb>
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	8b 00                	mov    (%eax),%eax
  802f82:	eb 05                	jmp    802f89 <alloc_block_NF+0x1d0>
  802f84:	b8 00 00 00 00       	mov    $0x0,%eax
  802f89:	a3 40 51 80 00       	mov    %eax,0x805140
  802f8e:	a1 40 51 80 00       	mov    0x805140,%eax
  802f93:	85 c0                	test   %eax,%eax
  802f95:	0f 85 3e fe ff ff    	jne    802dd9 <alloc_block_NF+0x20>
  802f9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f9f:	0f 85 34 fe ff ff    	jne    802dd9 <alloc_block_NF+0x20>
  802fa5:	e9 d5 03 00 00       	jmp    80337f <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802faa:	a1 38 51 80 00       	mov    0x805138,%eax
  802faf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb2:	e9 b1 01 00 00       	jmp    803168 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fba:	8b 50 08             	mov    0x8(%eax),%edx
  802fbd:	a1 28 50 80 00       	mov    0x805028,%eax
  802fc2:	39 c2                	cmp    %eax,%edx
  802fc4:	0f 82 96 01 00 00    	jb     803160 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcd:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fd3:	0f 82 87 01 00 00    	jb     803160 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fdf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fe2:	0f 85 95 00 00 00    	jne    80307d <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802fe8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fec:	75 17                	jne    803005 <alloc_block_NF+0x24c>
  802fee:	83 ec 04             	sub    $0x4,%esp
  802ff1:	68 24 47 80 00       	push   $0x804724
  802ff6:	68 fc 00 00 00       	push   $0xfc
  802ffb:	68 7b 46 80 00       	push   $0x80467b
  803000:	e8 22 da ff ff       	call   800a27 <_panic>
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 00                	mov    (%eax),%eax
  80300a:	85 c0                	test   %eax,%eax
  80300c:	74 10                	je     80301e <alloc_block_NF+0x265>
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	8b 00                	mov    (%eax),%eax
  803013:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803016:	8b 52 04             	mov    0x4(%edx),%edx
  803019:	89 50 04             	mov    %edx,0x4(%eax)
  80301c:	eb 0b                	jmp    803029 <alloc_block_NF+0x270>
  80301e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803021:	8b 40 04             	mov    0x4(%eax),%eax
  803024:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302c:	8b 40 04             	mov    0x4(%eax),%eax
  80302f:	85 c0                	test   %eax,%eax
  803031:	74 0f                	je     803042 <alloc_block_NF+0x289>
  803033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803036:	8b 40 04             	mov    0x4(%eax),%eax
  803039:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80303c:	8b 12                	mov    (%edx),%edx
  80303e:	89 10                	mov    %edx,(%eax)
  803040:	eb 0a                	jmp    80304c <alloc_block_NF+0x293>
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	8b 00                	mov    (%eax),%eax
  803047:	a3 38 51 80 00       	mov    %eax,0x805138
  80304c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803058:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305f:	a1 44 51 80 00       	mov    0x805144,%eax
  803064:	48                   	dec    %eax
  803065:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 40 08             	mov    0x8(%eax),%eax
  803070:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803078:	e9 07 03 00 00       	jmp    803384 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	8b 40 0c             	mov    0xc(%eax),%eax
  803083:	3b 45 08             	cmp    0x8(%ebp),%eax
  803086:	0f 86 d4 00 00 00    	jbe    803160 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80308c:	a1 48 51 80 00       	mov    0x805148,%eax
  803091:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 50 08             	mov    0x8(%eax),%edx
  80309a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a6:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030ad:	75 17                	jne    8030c6 <alloc_block_NF+0x30d>
  8030af:	83 ec 04             	sub    $0x4,%esp
  8030b2:	68 24 47 80 00       	push   $0x804724
  8030b7:	68 04 01 00 00       	push   $0x104
  8030bc:	68 7b 46 80 00       	push   $0x80467b
  8030c1:	e8 61 d9 ff ff       	call   800a27 <_panic>
  8030c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c9:	8b 00                	mov    (%eax),%eax
  8030cb:	85 c0                	test   %eax,%eax
  8030cd:	74 10                	je     8030df <alloc_block_NF+0x326>
  8030cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d2:	8b 00                	mov    (%eax),%eax
  8030d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030d7:	8b 52 04             	mov    0x4(%edx),%edx
  8030da:	89 50 04             	mov    %edx,0x4(%eax)
  8030dd:	eb 0b                	jmp    8030ea <alloc_block_NF+0x331>
  8030df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e2:	8b 40 04             	mov    0x4(%eax),%eax
  8030e5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ed:	8b 40 04             	mov    0x4(%eax),%eax
  8030f0:	85 c0                	test   %eax,%eax
  8030f2:	74 0f                	je     803103 <alloc_block_NF+0x34a>
  8030f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f7:	8b 40 04             	mov    0x4(%eax),%eax
  8030fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030fd:	8b 12                	mov    (%edx),%edx
  8030ff:	89 10                	mov    %edx,(%eax)
  803101:	eb 0a                	jmp    80310d <alloc_block_NF+0x354>
  803103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803106:	8b 00                	mov    (%eax),%eax
  803108:	a3 48 51 80 00       	mov    %eax,0x805148
  80310d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803110:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803116:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803119:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803120:	a1 54 51 80 00       	mov    0x805154,%eax
  803125:	48                   	dec    %eax
  803126:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80312b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312e:	8b 40 08             	mov    0x8(%eax),%eax
  803131:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803139:	8b 50 08             	mov    0x8(%eax),%edx
  80313c:	8b 45 08             	mov    0x8(%ebp),%eax
  80313f:	01 c2                	add    %eax,%edx
  803141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803144:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314a:	8b 40 0c             	mov    0xc(%eax),%eax
  80314d:	2b 45 08             	sub    0x8(%ebp),%eax
  803150:	89 c2                	mov    %eax,%edx
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315b:	e9 24 02 00 00       	jmp    803384 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803160:	a1 40 51 80 00       	mov    0x805140,%eax
  803165:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803168:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80316c:	74 07                	je     803175 <alloc_block_NF+0x3bc>
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	8b 00                	mov    (%eax),%eax
  803173:	eb 05                	jmp    80317a <alloc_block_NF+0x3c1>
  803175:	b8 00 00 00 00       	mov    $0x0,%eax
  80317a:	a3 40 51 80 00       	mov    %eax,0x805140
  80317f:	a1 40 51 80 00       	mov    0x805140,%eax
  803184:	85 c0                	test   %eax,%eax
  803186:	0f 85 2b fe ff ff    	jne    802fb7 <alloc_block_NF+0x1fe>
  80318c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803190:	0f 85 21 fe ff ff    	jne    802fb7 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803196:	a1 38 51 80 00       	mov    0x805138,%eax
  80319b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80319e:	e9 ae 01 00 00       	jmp    803351 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	8b 50 08             	mov    0x8(%eax),%edx
  8031a9:	a1 28 50 80 00       	mov    0x805028,%eax
  8031ae:	39 c2                	cmp    %eax,%edx
  8031b0:	0f 83 93 01 00 00    	jae    803349 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031bf:	0f 82 84 01 00 00    	jb     803349 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8031c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ce:	0f 85 95 00 00 00    	jne    803269 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8031d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d8:	75 17                	jne    8031f1 <alloc_block_NF+0x438>
  8031da:	83 ec 04             	sub    $0x4,%esp
  8031dd:	68 24 47 80 00       	push   $0x804724
  8031e2:	68 14 01 00 00       	push   $0x114
  8031e7:	68 7b 46 80 00       	push   $0x80467b
  8031ec:	e8 36 d8 ff ff       	call   800a27 <_panic>
  8031f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f4:	8b 00                	mov    (%eax),%eax
  8031f6:	85 c0                	test   %eax,%eax
  8031f8:	74 10                	je     80320a <alloc_block_NF+0x451>
  8031fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fd:	8b 00                	mov    (%eax),%eax
  8031ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803202:	8b 52 04             	mov    0x4(%edx),%edx
  803205:	89 50 04             	mov    %edx,0x4(%eax)
  803208:	eb 0b                	jmp    803215 <alloc_block_NF+0x45c>
  80320a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320d:	8b 40 04             	mov    0x4(%eax),%eax
  803210:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803218:	8b 40 04             	mov    0x4(%eax),%eax
  80321b:	85 c0                	test   %eax,%eax
  80321d:	74 0f                	je     80322e <alloc_block_NF+0x475>
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	8b 40 04             	mov    0x4(%eax),%eax
  803225:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803228:	8b 12                	mov    (%edx),%edx
  80322a:	89 10                	mov    %edx,(%eax)
  80322c:	eb 0a                	jmp    803238 <alloc_block_NF+0x47f>
  80322e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803231:	8b 00                	mov    (%eax),%eax
  803233:	a3 38 51 80 00       	mov    %eax,0x805138
  803238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803244:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324b:	a1 44 51 80 00       	mov    0x805144,%eax
  803250:	48                   	dec    %eax
  803251:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803259:	8b 40 08             	mov    0x8(%eax),%eax
  80325c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803264:	e9 1b 01 00 00       	jmp    803384 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326c:	8b 40 0c             	mov    0xc(%eax),%eax
  80326f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803272:	0f 86 d1 00 00 00    	jbe    803349 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803278:	a1 48 51 80 00       	mov    0x805148,%eax
  80327d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803283:	8b 50 08             	mov    0x8(%eax),%edx
  803286:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803289:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80328c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328f:	8b 55 08             	mov    0x8(%ebp),%edx
  803292:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803295:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803299:	75 17                	jne    8032b2 <alloc_block_NF+0x4f9>
  80329b:	83 ec 04             	sub    $0x4,%esp
  80329e:	68 24 47 80 00       	push   $0x804724
  8032a3:	68 1c 01 00 00       	push   $0x11c
  8032a8:	68 7b 46 80 00       	push   $0x80467b
  8032ad:	e8 75 d7 ff ff       	call   800a27 <_panic>
  8032b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b5:	8b 00                	mov    (%eax),%eax
  8032b7:	85 c0                	test   %eax,%eax
  8032b9:	74 10                	je     8032cb <alloc_block_NF+0x512>
  8032bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032be:	8b 00                	mov    (%eax),%eax
  8032c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032c3:	8b 52 04             	mov    0x4(%edx),%edx
  8032c6:	89 50 04             	mov    %edx,0x4(%eax)
  8032c9:	eb 0b                	jmp    8032d6 <alloc_block_NF+0x51d>
  8032cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ce:	8b 40 04             	mov    0x4(%eax),%eax
  8032d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d9:	8b 40 04             	mov    0x4(%eax),%eax
  8032dc:	85 c0                	test   %eax,%eax
  8032de:	74 0f                	je     8032ef <alloc_block_NF+0x536>
  8032e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e3:	8b 40 04             	mov    0x4(%eax),%eax
  8032e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032e9:	8b 12                	mov    (%edx),%edx
  8032eb:	89 10                	mov    %edx,(%eax)
  8032ed:	eb 0a                	jmp    8032f9 <alloc_block_NF+0x540>
  8032ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f2:	8b 00                	mov    (%eax),%eax
  8032f4:	a3 48 51 80 00       	mov    %eax,0x805148
  8032f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803302:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803305:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80330c:	a1 54 51 80 00       	mov    0x805154,%eax
  803311:	48                   	dec    %eax
  803312:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803317:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331a:	8b 40 08             	mov    0x8(%eax),%eax
  80331d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803325:	8b 50 08             	mov    0x8(%eax),%edx
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	01 c2                	add    %eax,%edx
  80332d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803330:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803336:	8b 40 0c             	mov    0xc(%eax),%eax
  803339:	2b 45 08             	sub    0x8(%ebp),%eax
  80333c:	89 c2                	mov    %eax,%edx
  80333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803341:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803344:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803347:	eb 3b                	jmp    803384 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803349:	a1 40 51 80 00       	mov    0x805140,%eax
  80334e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803351:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803355:	74 07                	je     80335e <alloc_block_NF+0x5a5>
  803357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335a:	8b 00                	mov    (%eax),%eax
  80335c:	eb 05                	jmp    803363 <alloc_block_NF+0x5aa>
  80335e:	b8 00 00 00 00       	mov    $0x0,%eax
  803363:	a3 40 51 80 00       	mov    %eax,0x805140
  803368:	a1 40 51 80 00       	mov    0x805140,%eax
  80336d:	85 c0                	test   %eax,%eax
  80336f:	0f 85 2e fe ff ff    	jne    8031a3 <alloc_block_NF+0x3ea>
  803375:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803379:	0f 85 24 fe ff ff    	jne    8031a3 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80337f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803384:	c9                   	leave  
  803385:	c3                   	ret    

00803386 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803386:	55                   	push   %ebp
  803387:	89 e5                	mov    %esp,%ebp
  803389:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80338c:	a1 38 51 80 00       	mov    0x805138,%eax
  803391:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803394:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803399:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80339c:	a1 38 51 80 00       	mov    0x805138,%eax
  8033a1:	85 c0                	test   %eax,%eax
  8033a3:	74 14                	je     8033b9 <insert_sorted_with_merge_freeList+0x33>
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	8b 50 08             	mov    0x8(%eax),%edx
  8033ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ae:	8b 40 08             	mov    0x8(%eax),%eax
  8033b1:	39 c2                	cmp    %eax,%edx
  8033b3:	0f 87 9b 01 00 00    	ja     803554 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8033b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033bd:	75 17                	jne    8033d6 <insert_sorted_with_merge_freeList+0x50>
  8033bf:	83 ec 04             	sub    $0x4,%esp
  8033c2:	68 58 46 80 00       	push   $0x804658
  8033c7:	68 38 01 00 00       	push   $0x138
  8033cc:	68 7b 46 80 00       	push   $0x80467b
  8033d1:	e8 51 d6 ff ff       	call   800a27 <_panic>
  8033d6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	89 10                	mov    %edx,(%eax)
  8033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e4:	8b 00                	mov    (%eax),%eax
  8033e6:	85 c0                	test   %eax,%eax
  8033e8:	74 0d                	je     8033f7 <insert_sorted_with_merge_freeList+0x71>
  8033ea:	a1 38 51 80 00       	mov    0x805138,%eax
  8033ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f2:	89 50 04             	mov    %edx,0x4(%eax)
  8033f5:	eb 08                	jmp    8033ff <insert_sorted_with_merge_freeList+0x79>
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803402:	a3 38 51 80 00       	mov    %eax,0x805138
  803407:	8b 45 08             	mov    0x8(%ebp),%eax
  80340a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803411:	a1 44 51 80 00       	mov    0x805144,%eax
  803416:	40                   	inc    %eax
  803417:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80341c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803420:	0f 84 a8 06 00 00    	je     803ace <insert_sorted_with_merge_freeList+0x748>
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	8b 50 08             	mov    0x8(%eax),%edx
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	8b 40 0c             	mov    0xc(%eax),%eax
  803432:	01 c2                	add    %eax,%edx
  803434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803437:	8b 40 08             	mov    0x8(%eax),%eax
  80343a:	39 c2                	cmp    %eax,%edx
  80343c:	0f 85 8c 06 00 00    	jne    803ace <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803442:	8b 45 08             	mov    0x8(%ebp),%eax
  803445:	8b 50 0c             	mov    0xc(%eax),%edx
  803448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344b:	8b 40 0c             	mov    0xc(%eax),%eax
  80344e:	01 c2                	add    %eax,%edx
  803450:	8b 45 08             	mov    0x8(%ebp),%eax
  803453:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803456:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80345a:	75 17                	jne    803473 <insert_sorted_with_merge_freeList+0xed>
  80345c:	83 ec 04             	sub    $0x4,%esp
  80345f:	68 24 47 80 00       	push   $0x804724
  803464:	68 3c 01 00 00       	push   $0x13c
  803469:	68 7b 46 80 00       	push   $0x80467b
  80346e:	e8 b4 d5 ff ff       	call   800a27 <_panic>
  803473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803476:	8b 00                	mov    (%eax),%eax
  803478:	85 c0                	test   %eax,%eax
  80347a:	74 10                	je     80348c <insert_sorted_with_merge_freeList+0x106>
  80347c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347f:	8b 00                	mov    (%eax),%eax
  803481:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803484:	8b 52 04             	mov    0x4(%edx),%edx
  803487:	89 50 04             	mov    %edx,0x4(%eax)
  80348a:	eb 0b                	jmp    803497 <insert_sorted_with_merge_freeList+0x111>
  80348c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348f:	8b 40 04             	mov    0x4(%eax),%eax
  803492:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349a:	8b 40 04             	mov    0x4(%eax),%eax
  80349d:	85 c0                	test   %eax,%eax
  80349f:	74 0f                	je     8034b0 <insert_sorted_with_merge_freeList+0x12a>
  8034a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a4:	8b 40 04             	mov    0x4(%eax),%eax
  8034a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034aa:	8b 12                	mov    (%edx),%edx
  8034ac:	89 10                	mov    %edx,(%eax)
  8034ae:	eb 0a                	jmp    8034ba <insert_sorted_with_merge_freeList+0x134>
  8034b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b3:	8b 00                	mov    (%eax),%eax
  8034b5:	a3 38 51 80 00       	mov    %eax,0x805138
  8034ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034cd:	a1 44 51 80 00       	mov    0x805144,%eax
  8034d2:	48                   	dec    %eax
  8034d3:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8034d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034db:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8034e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8034ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034f0:	75 17                	jne    803509 <insert_sorted_with_merge_freeList+0x183>
  8034f2:	83 ec 04             	sub    $0x4,%esp
  8034f5:	68 58 46 80 00       	push   $0x804658
  8034fa:	68 3f 01 00 00       	push   $0x13f
  8034ff:	68 7b 46 80 00       	push   $0x80467b
  803504:	e8 1e d5 ff ff       	call   800a27 <_panic>
  803509:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80350f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803512:	89 10                	mov    %edx,(%eax)
  803514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803517:	8b 00                	mov    (%eax),%eax
  803519:	85 c0                	test   %eax,%eax
  80351b:	74 0d                	je     80352a <insert_sorted_with_merge_freeList+0x1a4>
  80351d:	a1 48 51 80 00       	mov    0x805148,%eax
  803522:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803525:	89 50 04             	mov    %edx,0x4(%eax)
  803528:	eb 08                	jmp    803532 <insert_sorted_with_merge_freeList+0x1ac>
  80352a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803535:	a3 48 51 80 00       	mov    %eax,0x805148
  80353a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803544:	a1 54 51 80 00       	mov    0x805154,%eax
  803549:	40                   	inc    %eax
  80354a:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80354f:	e9 7a 05 00 00       	jmp    803ace <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803554:	8b 45 08             	mov    0x8(%ebp),%eax
  803557:	8b 50 08             	mov    0x8(%eax),%edx
  80355a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355d:	8b 40 08             	mov    0x8(%eax),%eax
  803560:	39 c2                	cmp    %eax,%edx
  803562:	0f 82 14 01 00 00    	jb     80367c <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803568:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356b:	8b 50 08             	mov    0x8(%eax),%edx
  80356e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803571:	8b 40 0c             	mov    0xc(%eax),%eax
  803574:	01 c2                	add    %eax,%edx
  803576:	8b 45 08             	mov    0x8(%ebp),%eax
  803579:	8b 40 08             	mov    0x8(%eax),%eax
  80357c:	39 c2                	cmp    %eax,%edx
  80357e:	0f 85 90 00 00 00    	jne    803614 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803584:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803587:	8b 50 0c             	mov    0xc(%eax),%edx
  80358a:	8b 45 08             	mov    0x8(%ebp),%eax
  80358d:	8b 40 0c             	mov    0xc(%eax),%eax
  803590:	01 c2                	add    %eax,%edx
  803592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803595:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803598:	8b 45 08             	mov    0x8(%ebp),%eax
  80359b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8035a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8035ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035b0:	75 17                	jne    8035c9 <insert_sorted_with_merge_freeList+0x243>
  8035b2:	83 ec 04             	sub    $0x4,%esp
  8035b5:	68 58 46 80 00       	push   $0x804658
  8035ba:	68 49 01 00 00       	push   $0x149
  8035bf:	68 7b 46 80 00       	push   $0x80467b
  8035c4:	e8 5e d4 ff ff       	call   800a27 <_panic>
  8035c9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d2:	89 10                	mov    %edx,(%eax)
  8035d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d7:	8b 00                	mov    (%eax),%eax
  8035d9:	85 c0                	test   %eax,%eax
  8035db:	74 0d                	je     8035ea <insert_sorted_with_merge_freeList+0x264>
  8035dd:	a1 48 51 80 00       	mov    0x805148,%eax
  8035e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e5:	89 50 04             	mov    %edx,0x4(%eax)
  8035e8:	eb 08                	jmp    8035f2 <insert_sorted_with_merge_freeList+0x26c>
  8035ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f5:	a3 48 51 80 00       	mov    %eax,0x805148
  8035fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803604:	a1 54 51 80 00       	mov    0x805154,%eax
  803609:	40                   	inc    %eax
  80360a:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80360f:	e9 bb 04 00 00       	jmp    803acf <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803614:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803618:	75 17                	jne    803631 <insert_sorted_with_merge_freeList+0x2ab>
  80361a:	83 ec 04             	sub    $0x4,%esp
  80361d:	68 cc 46 80 00       	push   $0x8046cc
  803622:	68 4c 01 00 00       	push   $0x14c
  803627:	68 7b 46 80 00       	push   $0x80467b
  80362c:	e8 f6 d3 ff ff       	call   800a27 <_panic>
  803631:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803637:	8b 45 08             	mov    0x8(%ebp),%eax
  80363a:	89 50 04             	mov    %edx,0x4(%eax)
  80363d:	8b 45 08             	mov    0x8(%ebp),%eax
  803640:	8b 40 04             	mov    0x4(%eax),%eax
  803643:	85 c0                	test   %eax,%eax
  803645:	74 0c                	je     803653 <insert_sorted_with_merge_freeList+0x2cd>
  803647:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80364c:	8b 55 08             	mov    0x8(%ebp),%edx
  80364f:	89 10                	mov    %edx,(%eax)
  803651:	eb 08                	jmp    80365b <insert_sorted_with_merge_freeList+0x2d5>
  803653:	8b 45 08             	mov    0x8(%ebp),%eax
  803656:	a3 38 51 80 00       	mov    %eax,0x805138
  80365b:	8b 45 08             	mov    0x8(%ebp),%eax
  80365e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803663:	8b 45 08             	mov    0x8(%ebp),%eax
  803666:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80366c:	a1 44 51 80 00       	mov    0x805144,%eax
  803671:	40                   	inc    %eax
  803672:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803677:	e9 53 04 00 00       	jmp    803acf <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80367c:	a1 38 51 80 00       	mov    0x805138,%eax
  803681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803684:	e9 15 04 00 00       	jmp    803a9e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368c:	8b 00                	mov    (%eax),%eax
  80368e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803691:	8b 45 08             	mov    0x8(%ebp),%eax
  803694:	8b 50 08             	mov    0x8(%eax),%edx
  803697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369a:	8b 40 08             	mov    0x8(%eax),%eax
  80369d:	39 c2                	cmp    %eax,%edx
  80369f:	0f 86 f1 03 00 00    	jbe    803a96 <insert_sorted_with_merge_freeList+0x710>
  8036a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a8:	8b 50 08             	mov    0x8(%eax),%edx
  8036ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ae:	8b 40 08             	mov    0x8(%eax),%eax
  8036b1:	39 c2                	cmp    %eax,%edx
  8036b3:	0f 83 dd 03 00 00    	jae    803a96 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8036b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bc:	8b 50 08             	mov    0x8(%eax),%edx
  8036bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c5:	01 c2                	add    %eax,%edx
  8036c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ca:	8b 40 08             	mov    0x8(%eax),%eax
  8036cd:	39 c2                	cmp    %eax,%edx
  8036cf:	0f 85 b9 01 00 00    	jne    80388e <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8036d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d8:	8b 50 08             	mov    0x8(%eax),%edx
  8036db:	8b 45 08             	mov    0x8(%ebp),%eax
  8036de:	8b 40 0c             	mov    0xc(%eax),%eax
  8036e1:	01 c2                	add    %eax,%edx
  8036e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e6:	8b 40 08             	mov    0x8(%eax),%eax
  8036e9:	39 c2                	cmp    %eax,%edx
  8036eb:	0f 85 0d 01 00 00    	jne    8037fe <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8036f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f4:	8b 50 0c             	mov    0xc(%eax),%edx
  8036f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8036fd:	01 c2                	add    %eax,%edx
  8036ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803702:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803705:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803709:	75 17                	jne    803722 <insert_sorted_with_merge_freeList+0x39c>
  80370b:	83 ec 04             	sub    $0x4,%esp
  80370e:	68 24 47 80 00       	push   $0x804724
  803713:	68 5c 01 00 00       	push   $0x15c
  803718:	68 7b 46 80 00       	push   $0x80467b
  80371d:	e8 05 d3 ff ff       	call   800a27 <_panic>
  803722:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803725:	8b 00                	mov    (%eax),%eax
  803727:	85 c0                	test   %eax,%eax
  803729:	74 10                	je     80373b <insert_sorted_with_merge_freeList+0x3b5>
  80372b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372e:	8b 00                	mov    (%eax),%eax
  803730:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803733:	8b 52 04             	mov    0x4(%edx),%edx
  803736:	89 50 04             	mov    %edx,0x4(%eax)
  803739:	eb 0b                	jmp    803746 <insert_sorted_with_merge_freeList+0x3c0>
  80373b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373e:	8b 40 04             	mov    0x4(%eax),%eax
  803741:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803746:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803749:	8b 40 04             	mov    0x4(%eax),%eax
  80374c:	85 c0                	test   %eax,%eax
  80374e:	74 0f                	je     80375f <insert_sorted_with_merge_freeList+0x3d9>
  803750:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803753:	8b 40 04             	mov    0x4(%eax),%eax
  803756:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803759:	8b 12                	mov    (%edx),%edx
  80375b:	89 10                	mov    %edx,(%eax)
  80375d:	eb 0a                	jmp    803769 <insert_sorted_with_merge_freeList+0x3e3>
  80375f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803762:	8b 00                	mov    (%eax),%eax
  803764:	a3 38 51 80 00       	mov    %eax,0x805138
  803769:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803772:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803775:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80377c:	a1 44 51 80 00       	mov    0x805144,%eax
  803781:	48                   	dec    %eax
  803782:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803787:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803791:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803794:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80379b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80379f:	75 17                	jne    8037b8 <insert_sorted_with_merge_freeList+0x432>
  8037a1:	83 ec 04             	sub    $0x4,%esp
  8037a4:	68 58 46 80 00       	push   $0x804658
  8037a9:	68 5f 01 00 00       	push   $0x15f
  8037ae:	68 7b 46 80 00       	push   $0x80467b
  8037b3:	e8 6f d2 ff ff       	call   800a27 <_panic>
  8037b8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c1:	89 10                	mov    %edx,(%eax)
  8037c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c6:	8b 00                	mov    (%eax),%eax
  8037c8:	85 c0                	test   %eax,%eax
  8037ca:	74 0d                	je     8037d9 <insert_sorted_with_merge_freeList+0x453>
  8037cc:	a1 48 51 80 00       	mov    0x805148,%eax
  8037d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037d4:	89 50 04             	mov    %edx,0x4(%eax)
  8037d7:	eb 08                	jmp    8037e1 <insert_sorted_with_merge_freeList+0x45b>
  8037d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037dc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e4:	a3 48 51 80 00       	mov    %eax,0x805148
  8037e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f3:	a1 54 51 80 00       	mov    0x805154,%eax
  8037f8:	40                   	inc    %eax
  8037f9:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8037fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803801:	8b 50 0c             	mov    0xc(%eax),%edx
  803804:	8b 45 08             	mov    0x8(%ebp),%eax
  803807:	8b 40 0c             	mov    0xc(%eax),%eax
  80380a:	01 c2                	add    %eax,%edx
  80380c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380f:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803812:	8b 45 08             	mov    0x8(%ebp),%eax
  803815:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80381c:	8b 45 08             	mov    0x8(%ebp),%eax
  80381f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803826:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80382a:	75 17                	jne    803843 <insert_sorted_with_merge_freeList+0x4bd>
  80382c:	83 ec 04             	sub    $0x4,%esp
  80382f:	68 58 46 80 00       	push   $0x804658
  803834:	68 64 01 00 00       	push   $0x164
  803839:	68 7b 46 80 00       	push   $0x80467b
  80383e:	e8 e4 d1 ff ff       	call   800a27 <_panic>
  803843:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803849:	8b 45 08             	mov    0x8(%ebp),%eax
  80384c:	89 10                	mov    %edx,(%eax)
  80384e:	8b 45 08             	mov    0x8(%ebp),%eax
  803851:	8b 00                	mov    (%eax),%eax
  803853:	85 c0                	test   %eax,%eax
  803855:	74 0d                	je     803864 <insert_sorted_with_merge_freeList+0x4de>
  803857:	a1 48 51 80 00       	mov    0x805148,%eax
  80385c:	8b 55 08             	mov    0x8(%ebp),%edx
  80385f:	89 50 04             	mov    %edx,0x4(%eax)
  803862:	eb 08                	jmp    80386c <insert_sorted_with_merge_freeList+0x4e6>
  803864:	8b 45 08             	mov    0x8(%ebp),%eax
  803867:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80386c:	8b 45 08             	mov    0x8(%ebp),%eax
  80386f:	a3 48 51 80 00       	mov    %eax,0x805148
  803874:	8b 45 08             	mov    0x8(%ebp),%eax
  803877:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80387e:	a1 54 51 80 00       	mov    0x805154,%eax
  803883:	40                   	inc    %eax
  803884:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803889:	e9 41 02 00 00       	jmp    803acf <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80388e:	8b 45 08             	mov    0x8(%ebp),%eax
  803891:	8b 50 08             	mov    0x8(%eax),%edx
  803894:	8b 45 08             	mov    0x8(%ebp),%eax
  803897:	8b 40 0c             	mov    0xc(%eax),%eax
  80389a:	01 c2                	add    %eax,%edx
  80389c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389f:	8b 40 08             	mov    0x8(%eax),%eax
  8038a2:	39 c2                	cmp    %eax,%edx
  8038a4:	0f 85 7c 01 00 00    	jne    803a26 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8038aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038ae:	74 06                	je     8038b6 <insert_sorted_with_merge_freeList+0x530>
  8038b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038b4:	75 17                	jne    8038cd <insert_sorted_with_merge_freeList+0x547>
  8038b6:	83 ec 04             	sub    $0x4,%esp
  8038b9:	68 94 46 80 00       	push   $0x804694
  8038be:	68 69 01 00 00       	push   $0x169
  8038c3:	68 7b 46 80 00       	push   $0x80467b
  8038c8:	e8 5a d1 ff ff       	call   800a27 <_panic>
  8038cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d0:	8b 50 04             	mov    0x4(%eax),%edx
  8038d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d6:	89 50 04             	mov    %edx,0x4(%eax)
  8038d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038df:	89 10                	mov    %edx,(%eax)
  8038e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e4:	8b 40 04             	mov    0x4(%eax),%eax
  8038e7:	85 c0                	test   %eax,%eax
  8038e9:	74 0d                	je     8038f8 <insert_sorted_with_merge_freeList+0x572>
  8038eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ee:	8b 40 04             	mov    0x4(%eax),%eax
  8038f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8038f4:	89 10                	mov    %edx,(%eax)
  8038f6:	eb 08                	jmp    803900 <insert_sorted_with_merge_freeList+0x57a>
  8038f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fb:	a3 38 51 80 00       	mov    %eax,0x805138
  803900:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803903:	8b 55 08             	mov    0x8(%ebp),%edx
  803906:	89 50 04             	mov    %edx,0x4(%eax)
  803909:	a1 44 51 80 00       	mov    0x805144,%eax
  80390e:	40                   	inc    %eax
  80390f:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803914:	8b 45 08             	mov    0x8(%ebp),%eax
  803917:	8b 50 0c             	mov    0xc(%eax),%edx
  80391a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391d:	8b 40 0c             	mov    0xc(%eax),%eax
  803920:	01 c2                	add    %eax,%edx
  803922:	8b 45 08             	mov    0x8(%ebp),%eax
  803925:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803928:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80392c:	75 17                	jne    803945 <insert_sorted_with_merge_freeList+0x5bf>
  80392e:	83 ec 04             	sub    $0x4,%esp
  803931:	68 24 47 80 00       	push   $0x804724
  803936:	68 6b 01 00 00       	push   $0x16b
  80393b:	68 7b 46 80 00       	push   $0x80467b
  803940:	e8 e2 d0 ff ff       	call   800a27 <_panic>
  803945:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803948:	8b 00                	mov    (%eax),%eax
  80394a:	85 c0                	test   %eax,%eax
  80394c:	74 10                	je     80395e <insert_sorted_with_merge_freeList+0x5d8>
  80394e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803951:	8b 00                	mov    (%eax),%eax
  803953:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803956:	8b 52 04             	mov    0x4(%edx),%edx
  803959:	89 50 04             	mov    %edx,0x4(%eax)
  80395c:	eb 0b                	jmp    803969 <insert_sorted_with_merge_freeList+0x5e3>
  80395e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803961:	8b 40 04             	mov    0x4(%eax),%eax
  803964:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803969:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396c:	8b 40 04             	mov    0x4(%eax),%eax
  80396f:	85 c0                	test   %eax,%eax
  803971:	74 0f                	je     803982 <insert_sorted_with_merge_freeList+0x5fc>
  803973:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803976:	8b 40 04             	mov    0x4(%eax),%eax
  803979:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80397c:	8b 12                	mov    (%edx),%edx
  80397e:	89 10                	mov    %edx,(%eax)
  803980:	eb 0a                	jmp    80398c <insert_sorted_with_merge_freeList+0x606>
  803982:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803985:	8b 00                	mov    (%eax),%eax
  803987:	a3 38 51 80 00       	mov    %eax,0x805138
  80398c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803995:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803998:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80399f:	a1 44 51 80 00       	mov    0x805144,%eax
  8039a4:	48                   	dec    %eax
  8039a5:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8039aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8039b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8039be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039c2:	75 17                	jne    8039db <insert_sorted_with_merge_freeList+0x655>
  8039c4:	83 ec 04             	sub    $0x4,%esp
  8039c7:	68 58 46 80 00       	push   $0x804658
  8039cc:	68 6e 01 00 00       	push   $0x16e
  8039d1:	68 7b 46 80 00       	push   $0x80467b
  8039d6:	e8 4c d0 ff ff       	call   800a27 <_panic>
  8039db:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e4:	89 10                	mov    %edx,(%eax)
  8039e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e9:	8b 00                	mov    (%eax),%eax
  8039eb:	85 c0                	test   %eax,%eax
  8039ed:	74 0d                	je     8039fc <insert_sorted_with_merge_freeList+0x676>
  8039ef:	a1 48 51 80 00       	mov    0x805148,%eax
  8039f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039f7:	89 50 04             	mov    %edx,0x4(%eax)
  8039fa:	eb 08                	jmp    803a04 <insert_sorted_with_merge_freeList+0x67e>
  8039fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a07:	a3 48 51 80 00       	mov    %eax,0x805148
  803a0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a16:	a1 54 51 80 00       	mov    0x805154,%eax
  803a1b:	40                   	inc    %eax
  803a1c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a21:	e9 a9 00 00 00       	jmp    803acf <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803a26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a2a:	74 06                	je     803a32 <insert_sorted_with_merge_freeList+0x6ac>
  803a2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a30:	75 17                	jne    803a49 <insert_sorted_with_merge_freeList+0x6c3>
  803a32:	83 ec 04             	sub    $0x4,%esp
  803a35:	68 f0 46 80 00       	push   $0x8046f0
  803a3a:	68 73 01 00 00       	push   $0x173
  803a3f:	68 7b 46 80 00       	push   $0x80467b
  803a44:	e8 de cf ff ff       	call   800a27 <_panic>
  803a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4c:	8b 10                	mov    (%eax),%edx
  803a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a51:	89 10                	mov    %edx,(%eax)
  803a53:	8b 45 08             	mov    0x8(%ebp),%eax
  803a56:	8b 00                	mov    (%eax),%eax
  803a58:	85 c0                	test   %eax,%eax
  803a5a:	74 0b                	je     803a67 <insert_sorted_with_merge_freeList+0x6e1>
  803a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5f:	8b 00                	mov    (%eax),%eax
  803a61:	8b 55 08             	mov    0x8(%ebp),%edx
  803a64:	89 50 04             	mov    %edx,0x4(%eax)
  803a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a6a:	8b 55 08             	mov    0x8(%ebp),%edx
  803a6d:	89 10                	mov    %edx,(%eax)
  803a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a75:	89 50 04             	mov    %edx,0x4(%eax)
  803a78:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7b:	8b 00                	mov    (%eax),%eax
  803a7d:	85 c0                	test   %eax,%eax
  803a7f:	75 08                	jne    803a89 <insert_sorted_with_merge_freeList+0x703>
  803a81:	8b 45 08             	mov    0x8(%ebp),%eax
  803a84:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a89:	a1 44 51 80 00       	mov    0x805144,%eax
  803a8e:	40                   	inc    %eax
  803a8f:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803a94:	eb 39                	jmp    803acf <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803a96:	a1 40 51 80 00       	mov    0x805140,%eax
  803a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aa2:	74 07                	je     803aab <insert_sorted_with_merge_freeList+0x725>
  803aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa7:	8b 00                	mov    (%eax),%eax
  803aa9:	eb 05                	jmp    803ab0 <insert_sorted_with_merge_freeList+0x72a>
  803aab:	b8 00 00 00 00       	mov    $0x0,%eax
  803ab0:	a3 40 51 80 00       	mov    %eax,0x805140
  803ab5:	a1 40 51 80 00       	mov    0x805140,%eax
  803aba:	85 c0                	test   %eax,%eax
  803abc:	0f 85 c7 fb ff ff    	jne    803689 <insert_sorted_with_merge_freeList+0x303>
  803ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ac6:	0f 85 bd fb ff ff    	jne    803689 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803acc:	eb 01                	jmp    803acf <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803ace:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803acf:	90                   	nop
  803ad0:	c9                   	leave  
  803ad1:	c3                   	ret    
  803ad2:	66 90                	xchg   %ax,%ax

00803ad4 <__udivdi3>:
  803ad4:	55                   	push   %ebp
  803ad5:	57                   	push   %edi
  803ad6:	56                   	push   %esi
  803ad7:	53                   	push   %ebx
  803ad8:	83 ec 1c             	sub    $0x1c,%esp
  803adb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803adf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ae3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ae7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803aeb:	89 ca                	mov    %ecx,%edx
  803aed:	89 f8                	mov    %edi,%eax
  803aef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803af3:	85 f6                	test   %esi,%esi
  803af5:	75 2d                	jne    803b24 <__udivdi3+0x50>
  803af7:	39 cf                	cmp    %ecx,%edi
  803af9:	77 65                	ja     803b60 <__udivdi3+0x8c>
  803afb:	89 fd                	mov    %edi,%ebp
  803afd:	85 ff                	test   %edi,%edi
  803aff:	75 0b                	jne    803b0c <__udivdi3+0x38>
  803b01:	b8 01 00 00 00       	mov    $0x1,%eax
  803b06:	31 d2                	xor    %edx,%edx
  803b08:	f7 f7                	div    %edi
  803b0a:	89 c5                	mov    %eax,%ebp
  803b0c:	31 d2                	xor    %edx,%edx
  803b0e:	89 c8                	mov    %ecx,%eax
  803b10:	f7 f5                	div    %ebp
  803b12:	89 c1                	mov    %eax,%ecx
  803b14:	89 d8                	mov    %ebx,%eax
  803b16:	f7 f5                	div    %ebp
  803b18:	89 cf                	mov    %ecx,%edi
  803b1a:	89 fa                	mov    %edi,%edx
  803b1c:	83 c4 1c             	add    $0x1c,%esp
  803b1f:	5b                   	pop    %ebx
  803b20:	5e                   	pop    %esi
  803b21:	5f                   	pop    %edi
  803b22:	5d                   	pop    %ebp
  803b23:	c3                   	ret    
  803b24:	39 ce                	cmp    %ecx,%esi
  803b26:	77 28                	ja     803b50 <__udivdi3+0x7c>
  803b28:	0f bd fe             	bsr    %esi,%edi
  803b2b:	83 f7 1f             	xor    $0x1f,%edi
  803b2e:	75 40                	jne    803b70 <__udivdi3+0x9c>
  803b30:	39 ce                	cmp    %ecx,%esi
  803b32:	72 0a                	jb     803b3e <__udivdi3+0x6a>
  803b34:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b38:	0f 87 9e 00 00 00    	ja     803bdc <__udivdi3+0x108>
  803b3e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b43:	89 fa                	mov    %edi,%edx
  803b45:	83 c4 1c             	add    $0x1c,%esp
  803b48:	5b                   	pop    %ebx
  803b49:	5e                   	pop    %esi
  803b4a:	5f                   	pop    %edi
  803b4b:	5d                   	pop    %ebp
  803b4c:	c3                   	ret    
  803b4d:	8d 76 00             	lea    0x0(%esi),%esi
  803b50:	31 ff                	xor    %edi,%edi
  803b52:	31 c0                	xor    %eax,%eax
  803b54:	89 fa                	mov    %edi,%edx
  803b56:	83 c4 1c             	add    $0x1c,%esp
  803b59:	5b                   	pop    %ebx
  803b5a:	5e                   	pop    %esi
  803b5b:	5f                   	pop    %edi
  803b5c:	5d                   	pop    %ebp
  803b5d:	c3                   	ret    
  803b5e:	66 90                	xchg   %ax,%ax
  803b60:	89 d8                	mov    %ebx,%eax
  803b62:	f7 f7                	div    %edi
  803b64:	31 ff                	xor    %edi,%edi
  803b66:	89 fa                	mov    %edi,%edx
  803b68:	83 c4 1c             	add    $0x1c,%esp
  803b6b:	5b                   	pop    %ebx
  803b6c:	5e                   	pop    %esi
  803b6d:	5f                   	pop    %edi
  803b6e:	5d                   	pop    %ebp
  803b6f:	c3                   	ret    
  803b70:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b75:	89 eb                	mov    %ebp,%ebx
  803b77:	29 fb                	sub    %edi,%ebx
  803b79:	89 f9                	mov    %edi,%ecx
  803b7b:	d3 e6                	shl    %cl,%esi
  803b7d:	89 c5                	mov    %eax,%ebp
  803b7f:	88 d9                	mov    %bl,%cl
  803b81:	d3 ed                	shr    %cl,%ebp
  803b83:	89 e9                	mov    %ebp,%ecx
  803b85:	09 f1                	or     %esi,%ecx
  803b87:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b8b:	89 f9                	mov    %edi,%ecx
  803b8d:	d3 e0                	shl    %cl,%eax
  803b8f:	89 c5                	mov    %eax,%ebp
  803b91:	89 d6                	mov    %edx,%esi
  803b93:	88 d9                	mov    %bl,%cl
  803b95:	d3 ee                	shr    %cl,%esi
  803b97:	89 f9                	mov    %edi,%ecx
  803b99:	d3 e2                	shl    %cl,%edx
  803b9b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b9f:	88 d9                	mov    %bl,%cl
  803ba1:	d3 e8                	shr    %cl,%eax
  803ba3:	09 c2                	or     %eax,%edx
  803ba5:	89 d0                	mov    %edx,%eax
  803ba7:	89 f2                	mov    %esi,%edx
  803ba9:	f7 74 24 0c          	divl   0xc(%esp)
  803bad:	89 d6                	mov    %edx,%esi
  803baf:	89 c3                	mov    %eax,%ebx
  803bb1:	f7 e5                	mul    %ebp
  803bb3:	39 d6                	cmp    %edx,%esi
  803bb5:	72 19                	jb     803bd0 <__udivdi3+0xfc>
  803bb7:	74 0b                	je     803bc4 <__udivdi3+0xf0>
  803bb9:	89 d8                	mov    %ebx,%eax
  803bbb:	31 ff                	xor    %edi,%edi
  803bbd:	e9 58 ff ff ff       	jmp    803b1a <__udivdi3+0x46>
  803bc2:	66 90                	xchg   %ax,%ax
  803bc4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bc8:	89 f9                	mov    %edi,%ecx
  803bca:	d3 e2                	shl    %cl,%edx
  803bcc:	39 c2                	cmp    %eax,%edx
  803bce:	73 e9                	jae    803bb9 <__udivdi3+0xe5>
  803bd0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bd3:	31 ff                	xor    %edi,%edi
  803bd5:	e9 40 ff ff ff       	jmp    803b1a <__udivdi3+0x46>
  803bda:	66 90                	xchg   %ax,%ax
  803bdc:	31 c0                	xor    %eax,%eax
  803bde:	e9 37 ff ff ff       	jmp    803b1a <__udivdi3+0x46>
  803be3:	90                   	nop

00803be4 <__umoddi3>:
  803be4:	55                   	push   %ebp
  803be5:	57                   	push   %edi
  803be6:	56                   	push   %esi
  803be7:	53                   	push   %ebx
  803be8:	83 ec 1c             	sub    $0x1c,%esp
  803beb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bef:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bf3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bf7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803bfb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c03:	89 f3                	mov    %esi,%ebx
  803c05:	89 fa                	mov    %edi,%edx
  803c07:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c0b:	89 34 24             	mov    %esi,(%esp)
  803c0e:	85 c0                	test   %eax,%eax
  803c10:	75 1a                	jne    803c2c <__umoddi3+0x48>
  803c12:	39 f7                	cmp    %esi,%edi
  803c14:	0f 86 a2 00 00 00    	jbe    803cbc <__umoddi3+0xd8>
  803c1a:	89 c8                	mov    %ecx,%eax
  803c1c:	89 f2                	mov    %esi,%edx
  803c1e:	f7 f7                	div    %edi
  803c20:	89 d0                	mov    %edx,%eax
  803c22:	31 d2                	xor    %edx,%edx
  803c24:	83 c4 1c             	add    $0x1c,%esp
  803c27:	5b                   	pop    %ebx
  803c28:	5e                   	pop    %esi
  803c29:	5f                   	pop    %edi
  803c2a:	5d                   	pop    %ebp
  803c2b:	c3                   	ret    
  803c2c:	39 f0                	cmp    %esi,%eax
  803c2e:	0f 87 ac 00 00 00    	ja     803ce0 <__umoddi3+0xfc>
  803c34:	0f bd e8             	bsr    %eax,%ebp
  803c37:	83 f5 1f             	xor    $0x1f,%ebp
  803c3a:	0f 84 ac 00 00 00    	je     803cec <__umoddi3+0x108>
  803c40:	bf 20 00 00 00       	mov    $0x20,%edi
  803c45:	29 ef                	sub    %ebp,%edi
  803c47:	89 fe                	mov    %edi,%esi
  803c49:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c4d:	89 e9                	mov    %ebp,%ecx
  803c4f:	d3 e0                	shl    %cl,%eax
  803c51:	89 d7                	mov    %edx,%edi
  803c53:	89 f1                	mov    %esi,%ecx
  803c55:	d3 ef                	shr    %cl,%edi
  803c57:	09 c7                	or     %eax,%edi
  803c59:	89 e9                	mov    %ebp,%ecx
  803c5b:	d3 e2                	shl    %cl,%edx
  803c5d:	89 14 24             	mov    %edx,(%esp)
  803c60:	89 d8                	mov    %ebx,%eax
  803c62:	d3 e0                	shl    %cl,%eax
  803c64:	89 c2                	mov    %eax,%edx
  803c66:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c6a:	d3 e0                	shl    %cl,%eax
  803c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c70:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c74:	89 f1                	mov    %esi,%ecx
  803c76:	d3 e8                	shr    %cl,%eax
  803c78:	09 d0                	or     %edx,%eax
  803c7a:	d3 eb                	shr    %cl,%ebx
  803c7c:	89 da                	mov    %ebx,%edx
  803c7e:	f7 f7                	div    %edi
  803c80:	89 d3                	mov    %edx,%ebx
  803c82:	f7 24 24             	mull   (%esp)
  803c85:	89 c6                	mov    %eax,%esi
  803c87:	89 d1                	mov    %edx,%ecx
  803c89:	39 d3                	cmp    %edx,%ebx
  803c8b:	0f 82 87 00 00 00    	jb     803d18 <__umoddi3+0x134>
  803c91:	0f 84 91 00 00 00    	je     803d28 <__umoddi3+0x144>
  803c97:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c9b:	29 f2                	sub    %esi,%edx
  803c9d:	19 cb                	sbb    %ecx,%ebx
  803c9f:	89 d8                	mov    %ebx,%eax
  803ca1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ca5:	d3 e0                	shl    %cl,%eax
  803ca7:	89 e9                	mov    %ebp,%ecx
  803ca9:	d3 ea                	shr    %cl,%edx
  803cab:	09 d0                	or     %edx,%eax
  803cad:	89 e9                	mov    %ebp,%ecx
  803caf:	d3 eb                	shr    %cl,%ebx
  803cb1:	89 da                	mov    %ebx,%edx
  803cb3:	83 c4 1c             	add    $0x1c,%esp
  803cb6:	5b                   	pop    %ebx
  803cb7:	5e                   	pop    %esi
  803cb8:	5f                   	pop    %edi
  803cb9:	5d                   	pop    %ebp
  803cba:	c3                   	ret    
  803cbb:	90                   	nop
  803cbc:	89 fd                	mov    %edi,%ebp
  803cbe:	85 ff                	test   %edi,%edi
  803cc0:	75 0b                	jne    803ccd <__umoddi3+0xe9>
  803cc2:	b8 01 00 00 00       	mov    $0x1,%eax
  803cc7:	31 d2                	xor    %edx,%edx
  803cc9:	f7 f7                	div    %edi
  803ccb:	89 c5                	mov    %eax,%ebp
  803ccd:	89 f0                	mov    %esi,%eax
  803ccf:	31 d2                	xor    %edx,%edx
  803cd1:	f7 f5                	div    %ebp
  803cd3:	89 c8                	mov    %ecx,%eax
  803cd5:	f7 f5                	div    %ebp
  803cd7:	89 d0                	mov    %edx,%eax
  803cd9:	e9 44 ff ff ff       	jmp    803c22 <__umoddi3+0x3e>
  803cde:	66 90                	xchg   %ax,%ax
  803ce0:	89 c8                	mov    %ecx,%eax
  803ce2:	89 f2                	mov    %esi,%edx
  803ce4:	83 c4 1c             	add    $0x1c,%esp
  803ce7:	5b                   	pop    %ebx
  803ce8:	5e                   	pop    %esi
  803ce9:	5f                   	pop    %edi
  803cea:	5d                   	pop    %ebp
  803ceb:	c3                   	ret    
  803cec:	3b 04 24             	cmp    (%esp),%eax
  803cef:	72 06                	jb     803cf7 <__umoddi3+0x113>
  803cf1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cf5:	77 0f                	ja     803d06 <__umoddi3+0x122>
  803cf7:	89 f2                	mov    %esi,%edx
  803cf9:	29 f9                	sub    %edi,%ecx
  803cfb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803cff:	89 14 24             	mov    %edx,(%esp)
  803d02:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d06:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d0a:	8b 14 24             	mov    (%esp),%edx
  803d0d:	83 c4 1c             	add    $0x1c,%esp
  803d10:	5b                   	pop    %ebx
  803d11:	5e                   	pop    %esi
  803d12:	5f                   	pop    %edi
  803d13:	5d                   	pop    %ebp
  803d14:	c3                   	ret    
  803d15:	8d 76 00             	lea    0x0(%esi),%esi
  803d18:	2b 04 24             	sub    (%esp),%eax
  803d1b:	19 fa                	sbb    %edi,%edx
  803d1d:	89 d1                	mov    %edx,%ecx
  803d1f:	89 c6                	mov    %eax,%esi
  803d21:	e9 71 ff ff ff       	jmp    803c97 <__umoddi3+0xb3>
  803d26:	66 90                	xchg   %ax,%ax
  803d28:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d2c:	72 ea                	jb     803d18 <__umoddi3+0x134>
  803d2e:	89 d9                	mov    %ebx,%ecx
  803d30:	e9 62 ff ff ff       	jmp    803c97 <__umoddi3+0xb3>
