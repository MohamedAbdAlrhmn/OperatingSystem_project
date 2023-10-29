
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
  800045:	e8 4b 25 00 00       	call   802595 <sys_set_uheap_strategy>
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
  80009b:	68 c0 3e 80 00       	push   $0x803ec0
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 dc 3e 80 00       	push   $0x803edc
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
  8000f5:	68 f4 3e 80 00       	push   $0x803ef4
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 dc 3e 80 00       	push   $0x803edc
  800101:	e8 21 09 00 00       	call   800a27 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 75 1f 00 00       	call   802080 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 0d 20 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  80013a:	68 38 3f 80 00       	push   $0x803f38
  80013f:	6a 31                	push   $0x31
  800141:	68 dc 3e 80 00       	push   $0x803edc
  800146:	e8 dc 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80014b:	e8 d0 1f 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  800150:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800153:	3d 00 02 00 00       	cmp    $0x200,%eax
  800158:	74 14                	je     80016e <_main+0x136>
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	68 68 3f 80 00       	push   $0x803f68
  800162:	6a 33                	push   $0x33
  800164:	68 dc 3e 80 00       	push   $0x803edc
  800169:	e8 b9 08 00 00       	call   800a27 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80016e:	e8 0d 1f 00 00       	call   802080 <sys_calculate_free_frames>
  800173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800176:	e8 a5 1f 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  8001ab:	68 38 3f 80 00       	push   $0x803f38
  8001b0:	6a 39                	push   $0x39
  8001b2:	68 dc 3e 80 00       	push   $0x803edc
  8001b7:	e8 6b 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001bc:	e8 5f 1f 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  8001c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 68 3f 80 00       	push   $0x803f68
  8001d3:	6a 3b                	push   $0x3b
  8001d5:	68 dc 3e 80 00       	push   $0x803edc
  8001da:	e8 48 08 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 9c 1e 00 00       	call   802080 <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 34 1f 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  80021a:	68 38 3f 80 00       	push   $0x803f38
  80021f:	6a 41                	push   $0x41
  800221:	68 dc 3e 80 00       	push   $0x803edc
  800226:	e8 fc 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80022b:	e8 f0 1e 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  800230:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800233:	83 f8 01             	cmp    $0x1,%eax
  800236:	74 14                	je     80024c <_main+0x214>
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 68 3f 80 00       	push   $0x803f68
  800240:	6a 43                	push   $0x43
  800242:	68 dc 3e 80 00       	push   $0x803edc
  800247:	e8 db 07 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80024c:	e8 2f 1e 00 00       	call   802080 <sys_calculate_free_frames>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800254:	e8 c7 1e 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  800291:	68 38 3f 80 00       	push   $0x803f38
  800296:	6a 49                	push   $0x49
  800298:	68 dc 3e 80 00       	push   $0x803edc
  80029d:	e8 85 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002a2:	e8 79 1e 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  8002a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002aa:	83 f8 01             	cmp    $0x1,%eax
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 68 3f 80 00       	push   $0x803f68
  8002b7:	6a 4b                	push   $0x4b
  8002b9:	68 dc 3e 80 00       	push   $0x803edc
  8002be:	e8 64 07 00 00       	call   800a27 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002c3:	e8 b8 1d 00 00       	call   802080 <sys_calculate_free_frames>
  8002c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cb:	e8 50 1e 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  8002d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 ff 19 00 00       	call   801cde <free>
  8002df:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002e2:	e8 39 1e 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  8002e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ea:	29 c2                	sub    %eax,%edx
  8002ec:	89 d0                	mov    %edx,%eax
  8002ee:	83 f8 01             	cmp    $0x1,%eax
  8002f1:	74 14                	je     800307 <_main+0x2cf>
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	68 85 3f 80 00       	push   $0x803f85
  8002fb:	6a 52                	push   $0x52
  8002fd:	68 dc 3e 80 00       	push   $0x803edc
  800302:	e8 20 07 00 00       	call   800a27 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  800307:	e8 74 1d 00 00       	call   802080 <sys_calculate_free_frames>
  80030c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80030f:	e8 0c 1e 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  800354:	68 38 3f 80 00       	push   $0x803f38
  800359:	6a 58                	push   $0x58
  80035b:	68 dc 3e 80 00       	push   $0x803edc
  800360:	e8 c2 06 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800365:	e8 b6 1d 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  80036a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80036d:	83 f8 02             	cmp    $0x2,%eax
  800370:	74 14                	je     800386 <_main+0x34e>
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 68 3f 80 00       	push   $0x803f68
  80037a:	6a 5a                	push   $0x5a
  80037c:	68 dc 3e 80 00       	push   $0x803edc
  800381:	e8 a1 06 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800386:	e8 f5 1c 00 00       	call   802080 <sys_calculate_free_frames>
  80038b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80038e:	e8 8d 1d 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  800393:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800396:	8b 45 90             	mov    -0x70(%ebp),%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	50                   	push   %eax
  80039d:	e8 3c 19 00 00       	call   801cde <free>
  8003a2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003a5:	e8 76 1d 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	29 c2                	sub    %eax,%edx
  8003af:	89 d0                	mov    %edx,%eax
  8003b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003b6:	74 14                	je     8003cc <_main+0x394>
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	68 85 3f 80 00       	push   $0x803f85
  8003c0:	6a 61                	push   $0x61
  8003c2:	68 dc 3e 80 00       	push   $0x803edc
  8003c7:	e8 5b 06 00 00       	call   800a27 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cc:	e8 af 1c 00 00       	call   802080 <sys_calculate_free_frames>
  8003d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d4:	e8 47 1d 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  800418:	68 38 3f 80 00       	push   $0x803f38
  80041d:	6a 67                	push   $0x67
  80041f:	68 dc 3e 80 00       	push   $0x803edc
  800424:	e8 fe 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800429:	e8 f2 1c 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  80044f:	68 68 3f 80 00       	push   $0x803f68
  800454:	6a 69                	push   $0x69
  800456:	68 dc 3e 80 00       	push   $0x803edc
  80045b:	e8 c7 05 00 00       	call   800a27 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800460:	e8 1b 1c 00 00       	call   802080 <sys_calculate_free_frames>
  800465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800468:	e8 b3 1c 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  8004b7:	68 38 3f 80 00       	push   $0x803f38
  8004bc:	6a 6f                	push   $0x6f
  8004be:	68 dc 3e 80 00       	push   $0x803edc
  8004c3:	e8 5f 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004c8:	e8 53 1c 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  8004cd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004d0:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004d5:	74 14                	je     8004eb <_main+0x4b3>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 68 3f 80 00       	push   $0x803f68
  8004df:	6a 71                	push   $0x71
  8004e1:	68 dc 3e 80 00       	push   $0x803edc
  8004e6:	e8 3c 05 00 00       	call   800a27 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004eb:	e8 90 1b 00 00       	call   802080 <sys_calculate_free_frames>
  8004f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f3:	e8 28 1c 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  800542:	68 38 3f 80 00       	push   $0x803f38
  800547:	6a 77                	push   $0x77
  800549:	68 dc 3e 80 00       	push   $0x803edc
  80054e:	e8 d4 04 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  800553:	e8 c8 1b 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  80057a:	68 68 3f 80 00       	push   $0x803f68
  80057f:	6a 79                	push   $0x79
  800581:	68 dc 3e 80 00       	push   $0x803edc
  800586:	e8 9c 04 00 00       	call   800a27 <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80058b:	e8 f0 1a 00 00       	call   802080 <sys_calculate_free_frames>
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800593:	e8 88 1b 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80059b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 37 17 00 00       	call   801cde <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  8005aa:	e8 71 1b 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	29 c2                	sub    %eax,%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	3d 02 02 00 00       	cmp    $0x202,%eax
  8005bb:	74 17                	je     8005d4 <_main+0x59c>
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 85 3f 80 00       	push   $0x803f85
  8005c5:	68 80 00 00 00       	push   $0x80
  8005ca:	68 dc 3e 80 00       	push   $0x803edc
  8005cf:	e8 53 04 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d4:	e8 a7 1a 00 00       	call   802080 <sys_calculate_free_frames>
  8005d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005dc:	e8 3f 1b 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005e4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	50                   	push   %eax
  8005eb:	e8 ee 16 00 00       	call   801cde <free>
  8005f0:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8005f3:	e8 28 1b 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  8005f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fb:	29 c2                	sub    %eax,%edx
  8005fd:	89 d0                	mov    %edx,%eax
  8005ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  800604:	74 17                	je     80061d <_main+0x5e5>
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	68 85 3f 80 00       	push   $0x803f85
  80060e:	68 87 00 00 00       	push   $0x87
  800613:	68 dc 3e 80 00       	push   $0x803edc
  800618:	e8 0a 04 00 00       	call   800a27 <_panic>

		//2 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  80061d:	e8 5e 1a 00 00       	call   802080 <sys_calculate_free_frames>
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800625:	e8 f6 1a 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  80066c:	68 38 3f 80 00       	push   $0x803f38
  800671:	68 8d 00 00 00       	push   $0x8d
  800676:	68 dc 3e 80 00       	push   $0x803edc
  80067b:	e8 a7 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800680:	e8 9b 1a 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  800685:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800688:	3d 00 02 00 00       	cmp    $0x200,%eax
  80068d:	74 17                	je     8006a6 <_main+0x66e>
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 68 3f 80 00       	push   $0x803f68
  800697:	68 8f 00 00 00       	push   $0x8f
  80069c:	68 dc 3e 80 00       	push   $0x803edc
  8006a1:	e8 81 03 00 00       	call   800a27 <_panic>

		//6 KB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  8006a6:	e8 d5 19 00 00       	call   802080 <sys_calculate_free_frames>
  8006ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ae:	e8 6d 1a 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  8006f5:	68 38 3f 80 00       	push   $0x803f38
  8006fa:	68 95 00 00 00       	push   $0x95
  8006ff:	68 dc 3e 80 00       	push   $0x803edc
  800704:	e8 1e 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800709:	e8 12 1a 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  80070e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800711:	83 f8 02             	cmp    $0x2,%eax
  800714:	74 17                	je     80072d <_main+0x6f5>
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	68 68 3f 80 00       	push   $0x803f68
  80071e:	68 97 00 00 00       	push   $0x97
  800723:	68 dc 3e 80 00       	push   $0x803edc
  800728:	e8 fa 02 00 00       	call   800a27 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80072d:	e8 4e 19 00 00       	call   802080 <sys_calculate_free_frames>
  800732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800735:	e8 e6 19 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  80073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80073d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 95 15 00 00       	call   801cde <free>
  800749:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  80074c:	e8 cf 19 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
  800751:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800754:	29 c2                	sub    %eax,%edx
  800756:	89 d0                	mov    %edx,%eax
  800758:	3d 00 03 00 00       	cmp    $0x300,%eax
  80075d:	74 17                	je     800776 <_main+0x73e>
  80075f:	83 ec 04             	sub    $0x4,%esp
  800762:	68 85 3f 80 00       	push   $0x803f85
  800767:	68 9e 00 00 00       	push   $0x9e
  80076c:	68 dc 3e 80 00       	push   $0x803edc
  800771:	e8 b1 02 00 00       	call   800a27 <_panic>

		//3 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800776:	e8 05 19 00 00       	call   802080 <sys_calculate_free_frames>
  80077b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80077e:	e8 9d 19 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  8007c2:	68 38 3f 80 00       	push   $0x803f38
  8007c7:	68 a4 00 00 00       	push   $0xa4
  8007cc:	68 dc 3e 80 00       	push   $0x803edc
  8007d1:	e8 51 02 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8007d6:	e8 45 19 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  8007fc:	68 68 3f 80 00       	push   $0x803f68
  800801:	68 a6 00 00 00       	push   $0xa6
  800806:	68 dc 3e 80 00       	push   $0x803edc
  80080b:	e8 17 02 00 00       	call   800a27 <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800810:	e8 6b 18 00 00       	call   802080 <sys_calculate_free_frames>
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800818:	e8 03 19 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  800845:	68 38 3f 80 00       	push   $0x803f38
  80084a:	68 ac 00 00 00       	push   $0xac
  80084f:	68 dc 3e 80 00       	push   $0x803edc
  800854:	e8 ce 01 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800859:	e8 c2 18 00 00       	call   802120 <sys_pf_calculate_allocated_pages>
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
  80087c:	68 68 3f 80 00       	push   $0x803f68
  800881:	68 ae 00 00 00       	push   $0xae
  800886:	68 dc 3e 80 00       	push   $0x803edc
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
  8008bf:	68 9c 3f 80 00       	push   $0x803f9c
  8008c4:	68 b7 00 00 00       	push   $0xb7
  8008c9:	68 dc 3e 80 00       	push   $0x803edc
  8008ce:	e8 54 01 00 00       	call   800a27 <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 00 40 80 00       	push   $0x804000
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
  8008f1:	e8 6a 1a 00 00       	call   802360 <sys_getenvindex>
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
  80095c:	e8 0c 18 00 00       	call   80216d <sys_disable_interrupt>
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 60 40 80 00       	push   $0x804060
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
  80098c:	68 88 40 80 00       	push   $0x804088
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
  8009bd:	68 b0 40 80 00       	push   $0x8040b0
  8009c2:	e8 14 03 00 00       	call   800cdb <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8009cf:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	50                   	push   %eax
  8009d9:	68 08 41 80 00       	push   $0x804108
  8009de:	e8 f8 02 00 00       	call   800cdb <cprintf>
  8009e3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009e6:	83 ec 0c             	sub    $0xc,%esp
  8009e9:	68 60 40 80 00       	push   $0x804060
  8009ee:	e8 e8 02 00 00       	call   800cdb <cprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009f6:	e8 8c 17 00 00       	call   802187 <sys_enable_interrupt>

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
  800a0e:	e8 19 19 00 00       	call   80232c <sys_destroy_env>
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
  800a1f:	e8 6e 19 00 00       	call   802392 <sys_exit_env>
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
  800a48:	68 1c 41 80 00       	push   $0x80411c
  800a4d:	e8 89 02 00 00       	call   800cdb <cprintf>
  800a52:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a55:	a1 00 50 80 00       	mov    0x805000,%eax
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 08             	pushl  0x8(%ebp)
  800a60:	50                   	push   %eax
  800a61:	68 21 41 80 00       	push   $0x804121
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
  800a85:	68 3d 41 80 00       	push   $0x80413d
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
  800ab1:	68 40 41 80 00       	push   $0x804140
  800ab6:	6a 26                	push   $0x26
  800ab8:	68 8c 41 80 00       	push   $0x80418c
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
  800b83:	68 98 41 80 00       	push   $0x804198
  800b88:	6a 3a                	push   $0x3a
  800b8a:	68 8c 41 80 00       	push   $0x80418c
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
  800bf3:	68 ec 41 80 00       	push   $0x8041ec
  800bf8:	6a 44                	push   $0x44
  800bfa:	68 8c 41 80 00       	push   $0x80418c
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
  800c4d:	e8 6d 13 00 00       	call   801fbf <sys_cputs>
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
  800cc4:	e8 f6 12 00 00       	call   801fbf <sys_cputs>
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
  800d0e:	e8 5a 14 00 00       	call   80216d <sys_disable_interrupt>
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
  800d2e:	e8 54 14 00 00       	call   802187 <sys_enable_interrupt>
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
  800d78:	e8 c7 2e 00 00       	call   803c44 <__udivdi3>
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
  800dc8:	e8 87 2f 00 00       	call   803d54 <__umoddi3>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	05 54 44 80 00       	add    $0x804454,%eax
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
  800f23:	8b 04 85 78 44 80 00 	mov    0x804478(,%eax,4),%eax
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
  801004:	8b 34 9d c0 42 80 00 	mov    0x8042c0(,%ebx,4),%esi
  80100b:	85 f6                	test   %esi,%esi
  80100d:	75 19                	jne    801028 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80100f:	53                   	push   %ebx
  801010:	68 65 44 80 00       	push   $0x804465
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
  801029:	68 6e 44 80 00       	push   $0x80446e
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
  801056:	be 71 44 80 00       	mov    $0x804471,%esi
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
  801a7c:	68 d0 45 80 00       	push   $0x8045d0
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
  801b4c:	e8 b2 05 00 00       	call   802103 <sys_allocate_chunk>
  801b51:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801b54:	a1 20 51 80 00       	mov    0x805120,%eax
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	50                   	push   %eax
  801b5d:	e8 27 0c 00 00       	call   802789 <initialize_MemBlocksList>
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
  801b8a:	68 f5 45 80 00       	push   $0x8045f5
  801b8f:	6a 33                	push   $0x33
  801b91:	68 13 46 80 00       	push   $0x804613
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
  801c09:	68 20 46 80 00       	push   $0x804620
  801c0e:	6a 34                	push   $0x34
  801c10:	68 13 46 80 00       	push   $0x804613
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
  801c66:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c69:	e8 f7 fd ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c72:	75 07                	jne    801c7b <malloc+0x18>
  801c74:	b8 00 00 00 00       	mov    $0x0,%eax
  801c79:	eb 61                	jmp    801cdc <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801c7b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c82:	8b 55 08             	mov    0x8(%ebp),%edx
  801c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c88:	01 d0                	add    %edx,%eax
  801c8a:	48                   	dec    %eax
  801c8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c91:	ba 00 00 00 00       	mov    $0x0,%edx
  801c96:	f7 75 f0             	divl   -0x10(%ebp)
  801c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c9c:	29 d0                	sub    %edx,%eax
  801c9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ca1:	e8 2b 08 00 00       	call   8024d1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	74 11                	je     801cbb <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801caa:	83 ec 0c             	sub    $0xc,%esp
  801cad:	ff 75 e8             	pushl  -0x18(%ebp)
  801cb0:	e8 96 0e 00 00       	call   802b4b <alloc_block_FF>
  801cb5:	83 c4 10             	add    $0x10,%esp
  801cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801cbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cbf:	74 16                	je     801cd7 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801cc1:	83 ec 0c             	sub    $0xc,%esp
  801cc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc7:	e8 f2 0b 00 00       	call   8028be <insert_sorted_allocList>
  801ccc:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd2:	8b 40 08             	mov    0x8(%eax),%eax
  801cd5:	eb 05                	jmp    801cdc <malloc+0x79>
	}

    return NULL;
  801cd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 18             	sub    $0x18,%esp
<<<<<<< HEAD
=======
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	83 ec 08             	sub    $0x8,%esp
  801cea:	50                   	push   %eax
  801ceb:	68 40 50 80 00       	push   $0x805040
  801cf0:	e8 71 0b 00 00       	call   802866 <find_block>
  801cf5:	83 c4 10             	add    $0x10,%esp
  801cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801cfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cff:	0f 84 a6 00 00 00    	je     801dab <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d08:	8b 50 0c             	mov    0xc(%eax),%edx
  801d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0e:	8b 40 08             	mov    0x8(%eax),%eax
  801d11:	83 ec 08             	sub    $0x8,%esp
  801d14:	52                   	push   %edx
  801d15:	50                   	push   %eax
  801d16:	e8 b0 03 00 00       	call   8020cb <sys_free_user_mem>
  801d1b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801d1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d22:	75 14                	jne    801d38 <free+0x5a>
  801d24:	83 ec 04             	sub    $0x4,%esp
  801d27:	68 f5 45 80 00       	push   $0x8045f5
  801d2c:	6a 74                	push   $0x74
  801d2e:	68 13 46 80 00       	push   $0x804613
  801d33:	e8 ef ec ff ff       	call   800a27 <_panic>
  801d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3b:	8b 00                	mov    (%eax),%eax
  801d3d:	85 c0                	test   %eax,%eax
  801d3f:	74 10                	je     801d51 <free+0x73>
  801d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d44:	8b 00                	mov    (%eax),%eax
  801d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d49:	8b 52 04             	mov    0x4(%edx),%edx
  801d4c:	89 50 04             	mov    %edx,0x4(%eax)
  801d4f:	eb 0b                	jmp    801d5c <free+0x7e>
  801d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d54:	8b 40 04             	mov    0x4(%eax),%eax
  801d57:	a3 44 50 80 00       	mov    %eax,0x805044
  801d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5f:	8b 40 04             	mov    0x4(%eax),%eax
  801d62:	85 c0                	test   %eax,%eax
  801d64:	74 0f                	je     801d75 <free+0x97>
  801d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d69:	8b 40 04             	mov    0x4(%eax),%eax
  801d6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d6f:	8b 12                	mov    (%edx),%edx
  801d71:	89 10                	mov    %edx,(%eax)
  801d73:	eb 0a                	jmp    801d7f <free+0xa1>
  801d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d78:	8b 00                	mov    (%eax),%eax
  801d7a:	a3 40 50 80 00       	mov    %eax,0x805040
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d92:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801d97:	48                   	dec    %eax
  801d98:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801d9d:	83 ec 0c             	sub    $0xc,%esp
  801da0:	ff 75 f4             	pushl  -0xc(%ebp)
  801da3:	e8 4e 17 00 00       	call   8034f6 <insert_sorted_with_merge_freeList>
  801da8:	83 c4 10             	add    $0x10,%esp
	}
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
<<<<<<< HEAD

	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	83 ec 08             	sub    $0x8,%esp
  801cea:	50                   	push   %eax
  801ceb:	68 40 50 80 00       	push   $0x805040
  801cf0:	e8 71 0b 00 00       	call   802866 <find_block>
  801cf5:	83 c4 10             	add    $0x10,%esp
  801cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if(free_block!=NULL)
  801cfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cff:	0f 84 a6 00 00 00    	je     801dab <free+0xcd>
	    {
	    	sys_free_user_mem(free_block->sva,free_block->size);
  801d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d08:	8b 50 0c             	mov    0xc(%eax),%edx
  801d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0e:	8b 40 08             	mov    0x8(%eax),%eax
  801d11:	83 ec 08             	sub    $0x8,%esp
  801d14:	52                   	push   %edx
  801d15:	50                   	push   %eax
  801d16:	e8 b0 03 00 00       	call   8020cb <sys_free_user_mem>
  801d1b:	83 c4 10             	add    $0x10,%esp
	    	LIST_REMOVE(&AllocMemBlocksList,free_block);
  801d1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d22:	75 14                	jne    801d38 <free+0x5a>
  801d24:	83 ec 04             	sub    $0x4,%esp
  801d27:	68 f5 45 80 00       	push   $0x8045f5
  801d2c:	6a 7a                	push   $0x7a
  801d2e:	68 13 46 80 00       	push   $0x804613
  801d33:	e8 ef ec ff ff       	call   800a27 <_panic>
  801d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3b:	8b 00                	mov    (%eax),%eax
  801d3d:	85 c0                	test   %eax,%eax
  801d3f:	74 10                	je     801d51 <free+0x73>
  801d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d44:	8b 00                	mov    (%eax),%eax
  801d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d49:	8b 52 04             	mov    0x4(%edx),%edx
  801d4c:	89 50 04             	mov    %edx,0x4(%eax)
  801d4f:	eb 0b                	jmp    801d5c <free+0x7e>
  801d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d54:	8b 40 04             	mov    0x4(%eax),%eax
  801d57:	a3 44 50 80 00       	mov    %eax,0x805044
  801d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5f:	8b 40 04             	mov    0x4(%eax),%eax
  801d62:	85 c0                	test   %eax,%eax
  801d64:	74 0f                	je     801d75 <free+0x97>
  801d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d69:	8b 40 04             	mov    0x4(%eax),%eax
  801d6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d6f:	8b 12                	mov    (%edx),%edx
  801d71:	89 10                	mov    %edx,(%eax)
  801d73:	eb 0a                	jmp    801d7f <free+0xa1>
  801d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d78:	8b 00                	mov    (%eax),%eax
  801d7a:	a3 40 50 80 00       	mov    %eax,0x805040
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d92:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801d97:	48                   	dec    %eax
  801d98:	a3 4c 50 80 00       	mov    %eax,0x80504c
	        insert_sorted_with_merge_freeList(free_block);
  801d9d:	83 ec 0c             	sub    $0xc,%esp
  801da0:	ff 75 f4             	pushl  -0xc(%ebp)
  801da3:	e8 4e 17 00 00       	call   8034f6 <insert_sorted_with_merge_freeList>
  801da8:	83 c4 10             	add    $0x10,%esp



	    }
=======
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
}
  801dab:	90                   	nop
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 38             	sub    $0x38,%esp
  801db4:	8b 45 10             	mov    0x10(%ebp),%eax
  801db7:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dba:	e8 a6 fc ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801dbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801dc3:	75 0a                	jne    801dcf <smalloc+0x21>
  801dc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dca:	e9 8b 00 00 00       	jmp    801e5a <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801dcf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801dd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ddc:	01 d0                	add    %edx,%eax
  801dde:	48                   	dec    %eax
  801ddf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801de2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de5:	ba 00 00 00 00       	mov    $0x0,%edx
  801dea:	f7 75 f0             	divl   -0x10(%ebp)
  801ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df0:	29 d0                	sub    %edx,%eax
  801df2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801df5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801dfc:	e8 d0 06 00 00       	call   8024d1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e01:	85 c0                	test   %eax,%eax
  801e03:	74 11                	je     801e16 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801e05:	83 ec 0c             	sub    $0xc,%esp
  801e08:	ff 75 e8             	pushl  -0x18(%ebp)
  801e0b:	e8 3b 0d 00 00       	call   802b4b <alloc_block_FF>
  801e10:	83 c4 10             	add    $0x10,%esp
  801e13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801e16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e1a:	74 39                	je     801e55 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1f:	8b 40 08             	mov    0x8(%eax),%eax
  801e22:	89 c2                	mov    %eax,%edx
  801e24:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801e28:	52                   	push   %edx
  801e29:	50                   	push   %eax
  801e2a:	ff 75 0c             	pushl  0xc(%ebp)
  801e2d:	ff 75 08             	pushl  0x8(%ebp)
  801e30:	e8 21 04 00 00       	call   802256 <sys_createSharedObject>
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801e3b:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801e3f:	74 14                	je     801e55 <smalloc+0xa7>
  801e41:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801e45:	74 0e                	je     801e55 <smalloc+0xa7>
  801e47:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801e4b:	74 08                	je     801e55 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e50:	8b 40 08             	mov    0x8(%eax),%eax
  801e53:	eb 05                	jmp    801e5a <smalloc+0xac>
	}
	return NULL;
  801e55:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e62:	e8 fe fb ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e67:	83 ec 08             	sub    $0x8,%esp
  801e6a:	ff 75 0c             	pushl  0xc(%ebp)
  801e6d:	ff 75 08             	pushl  0x8(%ebp)
  801e70:	e8 0b 04 00 00       	call   802280 <sys_getSizeOfSharedObject>
  801e75:	83 c4 10             	add    $0x10,%esp
  801e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801e7b:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801e7f:	74 76                	je     801ef7 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801e81:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801e88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e8e:	01 d0                	add    %edx,%eax
  801e90:	48                   	dec    %eax
  801e91:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e97:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9c:	f7 75 ec             	divl   -0x14(%ebp)
  801e9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ea2:	29 d0                	sub    %edx,%eax
  801ea4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801ea7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801eae:	e8 1e 06 00 00       	call   8024d1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	74 11                	je     801ec8 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801eb7:	83 ec 0c             	sub    $0xc,%esp
  801eba:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ebd:	e8 89 0c 00 00       	call   802b4b <alloc_block_FF>
  801ec2:	83 c4 10             	add    $0x10,%esp
  801ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801ec8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ecc:	74 29                	je     801ef7 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed1:	8b 40 08             	mov    0x8(%eax),%eax
  801ed4:	83 ec 04             	sub    $0x4,%esp
  801ed7:	50                   	push   %eax
  801ed8:	ff 75 0c             	pushl  0xc(%ebp)
  801edb:	ff 75 08             	pushl  0x8(%ebp)
  801ede:	e8 ba 03 00 00       	call   80229d <sys_getSharedObject>
  801ee3:	83 c4 10             	add    $0x10,%esp
  801ee6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801ee9:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801eed:	74 08                	je     801ef7 <sget+0x9b>
				return (void *)mem_block->sva;
  801eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef2:	8b 40 08             	mov    0x8(%eax),%eax
  801ef5:	eb 05                	jmp    801efc <sget+0xa0>
		}
	}
	return NULL;
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f04:	e8 5c fb ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f09:	83 ec 04             	sub    $0x4,%esp
  801f0c:	68 44 46 80 00       	push   $0x804644
<<<<<<< HEAD
  801f11:	68 fc 00 00 00       	push   $0xfc
=======
  801f11:	68 f7 00 00 00       	push   $0xf7
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801f16:	68 13 46 80 00       	push   $0x804613
  801f1b:	e8 07 eb ff ff       	call   800a27 <_panic>

00801f20 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f26:	83 ec 04             	sub    $0x4,%esp
  801f29:	68 6c 46 80 00       	push   $0x80466c
<<<<<<< HEAD
  801f2e:	68 10 01 00 00       	push   $0x110
=======
  801f2e:	68 0c 01 00 00       	push   $0x10c
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801f33:	68 13 46 80 00       	push   $0x804613
  801f38:	e8 ea ea ff ff       	call   800a27 <_panic>

00801f3d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f43:	83 ec 04             	sub    $0x4,%esp
  801f46:	68 90 46 80 00       	push   $0x804690
<<<<<<< HEAD
  801f4b:	68 1b 01 00 00       	push   $0x11b
=======
  801f4b:	68 44 01 00 00       	push   $0x144
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801f50:	68 13 46 80 00       	push   $0x804613
  801f55:	e8 cd ea ff ff       	call   800a27 <_panic>

00801f5a <shrink>:

}
void shrink(uint32 newSize)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f60:	83 ec 04             	sub    $0x4,%esp
  801f63:	68 90 46 80 00       	push   $0x804690
<<<<<<< HEAD
  801f68:	68 20 01 00 00       	push   $0x120
=======
  801f68:	68 49 01 00 00       	push   $0x149
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801f6d:	68 13 46 80 00       	push   $0x804613
  801f72:	e8 b0 ea ff ff       	call   800a27 <_panic>

00801f77 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f7d:	83 ec 04             	sub    $0x4,%esp
  801f80:	68 90 46 80 00       	push   $0x804690
<<<<<<< HEAD
  801f85:	68 25 01 00 00       	push   $0x125
=======
  801f85:	68 4e 01 00 00       	push   $0x14e
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801f8a:	68 13 46 80 00       	push   $0x804613
  801f8f:	e8 93 ea ff ff       	call   800a27 <_panic>

00801f94 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	57                   	push   %edi
  801f98:	56                   	push   %esi
  801f99:	53                   	push   %ebx
  801f9a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fa6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa9:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fac:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801faf:	cd 30                	int    $0x30
  801fb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fb7:	83 c4 10             	add    $0x10,%esp
  801fba:	5b                   	pop    %ebx
  801fbb:	5e                   	pop    %esi
  801fbc:	5f                   	pop    %edi
  801fbd:	5d                   	pop    %ebp
  801fbe:	c3                   	ret    

00801fbf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 04             	sub    $0x4,%esp
  801fc5:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801fcb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	52                   	push   %edx
  801fd7:	ff 75 0c             	pushl  0xc(%ebp)
  801fda:	50                   	push   %eax
  801fdb:	6a 00                	push   $0x0
  801fdd:	e8 b2 ff ff ff       	call   801f94 <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
}
  801fe5:	90                   	nop
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <sys_cgetc>:

int
sys_cgetc(void)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 01                	push   $0x1
  801ff7:	e8 98 ff ff ff       	call   801f94 <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802004:	8b 55 0c             	mov    0xc(%ebp),%edx
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	52                   	push   %edx
  802011:	50                   	push   %eax
  802012:	6a 05                	push   $0x5
  802014:	e8 7b ff ff ff       	call   801f94 <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	56                   	push   %esi
  802022:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802023:	8b 75 18             	mov    0x18(%ebp),%esi
  802026:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802029:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	56                   	push   %esi
  802033:	53                   	push   %ebx
  802034:	51                   	push   %ecx
  802035:	52                   	push   %edx
  802036:	50                   	push   %eax
  802037:	6a 06                	push   $0x6
  802039:	e8 56 ff ff ff       	call   801f94 <syscall>
  80203e:	83 c4 18             	add    $0x18,%esp
}
  802041:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802044:	5b                   	pop    %ebx
  802045:	5e                   	pop    %esi
  802046:	5d                   	pop    %ebp
  802047:	c3                   	ret    

00802048 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80204b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	52                   	push   %edx
  802058:	50                   	push   %eax
  802059:	6a 07                	push   $0x7
  80205b:	e8 34 ff ff ff       	call   801f94 <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	ff 75 0c             	pushl  0xc(%ebp)
  802071:	ff 75 08             	pushl  0x8(%ebp)
  802074:	6a 08                	push   $0x8
  802076:	e8 19 ff ff ff       	call   801f94 <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 09                	push   $0x9
  80208f:	e8 00 ff ff ff       	call   801f94 <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 0a                	push   $0xa
  8020a8:	e8 e7 fe ff ff       	call   801f94 <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 0b                	push   $0xb
  8020c1:	e8 ce fe ff ff       	call   801f94 <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	ff 75 0c             	pushl  0xc(%ebp)
  8020d7:	ff 75 08             	pushl  0x8(%ebp)
  8020da:	6a 0f                	push   $0xf
  8020dc:	e8 b3 fe ff ff       	call   801f94 <syscall>
  8020e1:	83 c4 18             	add    $0x18,%esp
	return;
  8020e4:	90                   	nop
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	ff 75 0c             	pushl  0xc(%ebp)
  8020f3:	ff 75 08             	pushl  0x8(%ebp)
  8020f6:	6a 10                	push   $0x10
  8020f8:	e8 97 fe ff ff       	call   801f94 <syscall>
  8020fd:	83 c4 18             	add    $0x18,%esp
	return ;
  802100:	90                   	nop
}
  802101:	c9                   	leave  
  802102:	c3                   	ret    

00802103 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	ff 75 10             	pushl  0x10(%ebp)
  80210d:	ff 75 0c             	pushl  0xc(%ebp)
  802110:	ff 75 08             	pushl  0x8(%ebp)
  802113:	6a 11                	push   $0x11
  802115:	e8 7a fe ff ff       	call   801f94 <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
	return ;
  80211d:	90                   	nop
}
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 0c                	push   $0xc
  80212f:	e8 60 fe ff ff       	call   801f94 <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	ff 75 08             	pushl  0x8(%ebp)
  802147:	6a 0d                	push   $0xd
  802149:	e8 46 fe ff ff       	call   801f94 <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 0e                	push   $0xe
  802162:	e8 2d fe ff ff       	call   801f94 <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
}
  80216a:	90                   	nop
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 13                	push   $0x13
  80217c:	e8 13 fe ff ff       	call   801f94 <syscall>
  802181:	83 c4 18             	add    $0x18,%esp
}
  802184:	90                   	nop
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 14                	push   $0x14
  802196:	e8 f9 fd ff ff       	call   801f94 <syscall>
  80219b:	83 c4 18             	add    $0x18,%esp
}
  80219e:	90                   	nop
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	83 ec 04             	sub    $0x4,%esp
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021ad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	50                   	push   %eax
  8021ba:	6a 15                	push   $0x15
  8021bc:	e8 d3 fd ff ff       	call   801f94 <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
}
  8021c4:	90                   	nop
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    

008021c7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 16                	push   $0x16
  8021d6:	e8 b9 fd ff ff       	call   801f94 <syscall>
  8021db:	83 c4 18             	add    $0x18,%esp
}
  8021de:	90                   	nop
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	ff 75 0c             	pushl  0xc(%ebp)
  8021f0:	50                   	push   %eax
  8021f1:	6a 17                	push   $0x17
  8021f3:	e8 9c fd ff ff       	call   801f94 <syscall>
  8021f8:	83 c4 18             	add    $0x18,%esp
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802200:	8b 55 0c             	mov    0xc(%ebp),%edx
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	52                   	push   %edx
  80220d:	50                   	push   %eax
  80220e:	6a 1a                	push   $0x1a
  802210:	e8 7f fd ff ff       	call   801f94 <syscall>
  802215:	83 c4 18             	add    $0x18,%esp
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80221d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	52                   	push   %edx
  80222a:	50                   	push   %eax
  80222b:	6a 18                	push   $0x18
  80222d:	e8 62 fd ff ff       	call   801f94 <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
}
  802235:	90                   	nop
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80223b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	52                   	push   %edx
  802248:	50                   	push   %eax
  802249:	6a 19                	push   $0x19
  80224b:	e8 44 fd ff ff       	call   801f94 <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
}
  802253:	90                   	nop
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	83 ec 04             	sub    $0x4,%esp
  80225c:	8b 45 10             	mov    0x10(%ebp),%eax
  80225f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802262:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802265:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	6a 00                	push   $0x0
  80226e:	51                   	push   %ecx
  80226f:	52                   	push   %edx
  802270:	ff 75 0c             	pushl  0xc(%ebp)
  802273:	50                   	push   %eax
  802274:	6a 1b                	push   $0x1b
  802276:	e8 19 fd ff ff       	call   801f94 <syscall>
  80227b:	83 c4 18             	add    $0x18,%esp
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802283:	8b 55 0c             	mov    0xc(%ebp),%edx
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	52                   	push   %edx
  802290:	50                   	push   %eax
  802291:	6a 1c                	push   $0x1c
  802293:	e8 fc fc ff ff       	call   801f94 <syscall>
  802298:	83 c4 18             	add    $0x18,%esp
}
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8022a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	51                   	push   %ecx
  8022ae:	52                   	push   %edx
  8022af:	50                   	push   %eax
  8022b0:	6a 1d                	push   $0x1d
  8022b2:	e8 dd fc ff ff       	call   801f94 <syscall>
  8022b7:	83 c4 18             	add    $0x18,%esp
}
  8022ba:	c9                   	leave  
  8022bb:	c3                   	ret    

008022bc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8022bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	52                   	push   %edx
  8022cc:	50                   	push   %eax
  8022cd:	6a 1e                	push   $0x1e
  8022cf:	e8 c0 fc ff ff       	call   801f94 <syscall>
  8022d4:	83 c4 18             	add    $0x18,%esp
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 1f                	push   $0x1f
  8022e8:	e8 a7 fc ff ff       	call   801f94 <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
}
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    

008022f2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	6a 00                	push   $0x0
  8022fa:	ff 75 14             	pushl  0x14(%ebp)
  8022fd:	ff 75 10             	pushl  0x10(%ebp)
  802300:	ff 75 0c             	pushl  0xc(%ebp)
  802303:	50                   	push   %eax
  802304:	6a 20                	push   $0x20
  802306:	e8 89 fc ff ff       	call   801f94 <syscall>
  80230b:	83 c4 18             	add    $0x18,%esp
}
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	50                   	push   %eax
  80231f:	6a 21                	push   $0x21
  802321:	e8 6e fc ff ff       	call   801f94 <syscall>
  802326:	83 c4 18             	add    $0x18,%esp
}
  802329:	90                   	nop
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	50                   	push   %eax
  80233b:	6a 22                	push   $0x22
  80233d:	e8 52 fc ff ff       	call   801f94 <syscall>
  802342:	83 c4 18             	add    $0x18,%esp
}
  802345:	c9                   	leave  
  802346:	c3                   	ret    

00802347 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 02                	push   $0x2
  802356:	e8 39 fc ff ff       	call   801f94 <syscall>
  80235b:	83 c4 18             	add    $0x18,%esp
}
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 03                	push   $0x3
  80236f:	e8 20 fc ff ff       	call   801f94 <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 04                	push   $0x4
  802388:	e8 07 fc ff ff       	call   801f94 <syscall>
  80238d:	83 c4 18             	add    $0x18,%esp
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <sys_exit_env>:


void sys_exit_env(void)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 23                	push   $0x23
  8023a1:	e8 ee fb ff ff       	call   801f94 <syscall>
  8023a6:	83 c4 18             	add    $0x18,%esp
}
  8023a9:	90                   	nop
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
  8023af:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8023b2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023b5:	8d 50 04             	lea    0x4(%eax),%edx
  8023b8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	52                   	push   %edx
  8023c2:	50                   	push   %eax
  8023c3:	6a 24                	push   $0x24
  8023c5:	e8 ca fb ff ff       	call   801f94 <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
	return result;
  8023cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023d6:	89 01                	mov    %eax,(%ecx)
  8023d8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	c9                   	leave  
  8023df:	c2 04 00             	ret    $0x4

008023e2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	ff 75 10             	pushl  0x10(%ebp)
  8023ec:	ff 75 0c             	pushl  0xc(%ebp)
  8023ef:	ff 75 08             	pushl  0x8(%ebp)
  8023f2:	6a 12                	push   $0x12
  8023f4:	e8 9b fb ff ff       	call   801f94 <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8023fc:	90                   	nop
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <sys_rcr2>:
uint32 sys_rcr2()
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 25                	push   $0x25
  80240e:	e8 81 fb ff ff       	call   801f94 <syscall>
  802413:	83 c4 18             	add    $0x18,%esp
}
  802416:	c9                   	leave  
  802417:	c3                   	ret    

00802418 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
  80241b:	83 ec 04             	sub    $0x4,%esp
  80241e:	8b 45 08             	mov    0x8(%ebp),%eax
  802421:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802424:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	50                   	push   %eax
  802431:	6a 26                	push   $0x26
  802433:	e8 5c fb ff ff       	call   801f94 <syscall>
  802438:	83 c4 18             	add    $0x18,%esp
	return ;
  80243b:	90                   	nop
}
  80243c:	c9                   	leave  
  80243d:	c3                   	ret    

0080243e <rsttst>:
void rsttst()
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 28                	push   $0x28
  80244d:	e8 42 fb ff ff       	call   801f94 <syscall>
  802452:	83 c4 18             	add    $0x18,%esp
	return ;
  802455:	90                   	nop
}
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	83 ec 04             	sub    $0x4,%esp
  80245e:	8b 45 14             	mov    0x14(%ebp),%eax
  802461:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802464:	8b 55 18             	mov    0x18(%ebp),%edx
  802467:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80246b:	52                   	push   %edx
  80246c:	50                   	push   %eax
  80246d:	ff 75 10             	pushl  0x10(%ebp)
  802470:	ff 75 0c             	pushl  0xc(%ebp)
  802473:	ff 75 08             	pushl  0x8(%ebp)
  802476:	6a 27                	push   $0x27
  802478:	e8 17 fb ff ff       	call   801f94 <syscall>
  80247d:	83 c4 18             	add    $0x18,%esp
	return ;
  802480:	90                   	nop
}
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <chktst>:
void chktst(uint32 n)
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	ff 75 08             	pushl  0x8(%ebp)
  802491:	6a 29                	push   $0x29
  802493:	e8 fc fa ff ff       	call   801f94 <syscall>
  802498:	83 c4 18             	add    $0x18,%esp
	return ;
  80249b:	90                   	nop
}
  80249c:	c9                   	leave  
  80249d:	c3                   	ret    

0080249e <inctst>:

void inctst()
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 2a                	push   $0x2a
  8024ad:	e8 e2 fa ff ff       	call   801f94 <syscall>
  8024b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8024b5:	90                   	nop
}
  8024b6:	c9                   	leave  
  8024b7:	c3                   	ret    

008024b8 <gettst>:
uint32 gettst()
{
  8024b8:	55                   	push   %ebp
  8024b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 2b                	push   $0x2b
  8024c7:	e8 c8 fa ff ff       	call   801f94 <syscall>
  8024cc:	83 c4 18             	add    $0x18,%esp
}
  8024cf:	c9                   	leave  
  8024d0:	c3                   	ret    

008024d1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
  8024d4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 2c                	push   $0x2c
  8024e3:	e8 ac fa ff ff       	call   801f94 <syscall>
  8024e8:	83 c4 18             	add    $0x18,%esp
  8024eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024ee:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024f2:	75 07                	jne    8024fb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f9:	eb 05                	jmp    802500 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802500:	c9                   	leave  
  802501:	c3                   	ret    

00802502 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802502:	55                   	push   %ebp
  802503:	89 e5                	mov    %esp,%ebp
  802505:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 2c                	push   $0x2c
  802514:	e8 7b fa ff ff       	call   801f94 <syscall>
  802519:	83 c4 18             	add    $0x18,%esp
  80251c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80251f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802523:	75 07                	jne    80252c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802525:	b8 01 00 00 00       	mov    $0x1,%eax
  80252a:	eb 05                	jmp    802531 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80252c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802531:	c9                   	leave  
  802532:	c3                   	ret    

00802533 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp
  802536:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 2c                	push   $0x2c
  802545:	e8 4a fa ff ff       	call   801f94 <syscall>
  80254a:	83 c4 18             	add    $0x18,%esp
  80254d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802550:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802554:	75 07                	jne    80255d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802556:	b8 01 00 00 00       	mov    $0x1,%eax
  80255b:	eb 05                	jmp    802562 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80255d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 2c                	push   $0x2c
  802576:	e8 19 fa ff ff       	call   801f94 <syscall>
  80257b:	83 c4 18             	add    $0x18,%esp
  80257e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802581:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802585:	75 07                	jne    80258e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802587:	b8 01 00 00 00       	mov    $0x1,%eax
  80258c:	eb 05                	jmp    802593 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80258e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802593:	c9                   	leave  
  802594:	c3                   	ret    

00802595 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	ff 75 08             	pushl  0x8(%ebp)
  8025a3:	6a 2d                	push   $0x2d
  8025a5:	e8 ea f9 ff ff       	call   801f94 <syscall>
  8025aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ad:	90                   	nop
}
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c0:	6a 00                	push   $0x0
  8025c2:	53                   	push   %ebx
  8025c3:	51                   	push   %ecx
  8025c4:	52                   	push   %edx
  8025c5:	50                   	push   %eax
  8025c6:	6a 2e                	push   $0x2e
  8025c8:	e8 c7 f9 ff ff       	call   801f94 <syscall>
  8025cd:	83 c4 18             	add    $0x18,%esp
}
  8025d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025d3:	c9                   	leave  
  8025d4:	c3                   	ret    

008025d5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8025d5:	55                   	push   %ebp
  8025d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8025d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025db:	8b 45 08             	mov    0x8(%ebp),%eax
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	52                   	push   %edx
  8025e5:	50                   	push   %eax
  8025e6:	6a 2f                	push   $0x2f
  8025e8:	e8 a7 f9 ff ff       	call   801f94 <syscall>
  8025ed:	83 c4 18             	add    $0x18,%esp
}
  8025f0:	c9                   	leave  
  8025f1:	c3                   	ret    

008025f2 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8025f2:	55                   	push   %ebp
  8025f3:	89 e5                	mov    %esp,%ebp
  8025f5:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8025f8:	83 ec 0c             	sub    $0xc,%esp
  8025fb:	68 a0 46 80 00       	push   $0x8046a0
  802600:	e8 d6 e6 ff ff       	call   800cdb <cprintf>
  802605:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802608:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80260f:	83 ec 0c             	sub    $0xc,%esp
  802612:	68 cc 46 80 00       	push   $0x8046cc
  802617:	e8 bf e6 ff ff       	call   800cdb <cprintf>
  80261c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80261f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802623:	a1 38 51 80 00       	mov    0x805138,%eax
  802628:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262b:	eb 56                	jmp    802683 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80262d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802631:	74 1c                	je     80264f <print_mem_block_lists+0x5d>
  802633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802636:	8b 50 08             	mov    0x8(%eax),%edx
  802639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263c:	8b 48 08             	mov    0x8(%eax),%ecx
  80263f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802642:	8b 40 0c             	mov    0xc(%eax),%eax
  802645:	01 c8                	add    %ecx,%eax
  802647:	39 c2                	cmp    %eax,%edx
  802649:	73 04                	jae    80264f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80264b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 50 08             	mov    0x8(%eax),%edx
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	8b 40 0c             	mov    0xc(%eax),%eax
  80265b:	01 c2                	add    %eax,%edx
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 40 08             	mov    0x8(%eax),%eax
  802663:	83 ec 04             	sub    $0x4,%esp
  802666:	52                   	push   %edx
  802667:	50                   	push   %eax
  802668:	68 e1 46 80 00       	push   $0x8046e1
  80266d:	e8 69 e6 ff ff       	call   800cdb <cprintf>
  802672:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80267b:	a1 40 51 80 00       	mov    0x805140,%eax
  802680:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802683:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802687:	74 07                	je     802690 <print_mem_block_lists+0x9e>
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 00                	mov    (%eax),%eax
  80268e:	eb 05                	jmp    802695 <print_mem_block_lists+0xa3>
  802690:	b8 00 00 00 00       	mov    $0x0,%eax
  802695:	a3 40 51 80 00       	mov    %eax,0x805140
  80269a:	a1 40 51 80 00       	mov    0x805140,%eax
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	75 8a                	jne    80262d <print_mem_block_lists+0x3b>
  8026a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a7:	75 84                	jne    80262d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8026a9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026ad:	75 10                	jne    8026bf <print_mem_block_lists+0xcd>
  8026af:	83 ec 0c             	sub    $0xc,%esp
  8026b2:	68 f0 46 80 00       	push   $0x8046f0
  8026b7:	e8 1f e6 ff ff       	call   800cdb <cprintf>
  8026bc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8026bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8026c6:	83 ec 0c             	sub    $0xc,%esp
  8026c9:	68 14 47 80 00       	push   $0x804714
  8026ce:	e8 08 e6 ff ff       	call   800cdb <cprintf>
  8026d3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8026d6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026da:	a1 40 50 80 00       	mov    0x805040,%eax
  8026df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e2:	eb 56                	jmp    80273a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e8:	74 1c                	je     802706 <print_mem_block_lists+0x114>
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 50 08             	mov    0x8(%eax),%edx
  8026f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f3:	8b 48 08             	mov    0x8(%eax),%ecx
  8026f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fc:	01 c8                	add    %ecx,%eax
  8026fe:	39 c2                	cmp    %eax,%edx
  802700:	73 04                	jae    802706 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802702:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 50 08             	mov    0x8(%eax),%edx
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	8b 40 0c             	mov    0xc(%eax),%eax
  802712:	01 c2                	add    %eax,%edx
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 40 08             	mov    0x8(%eax),%eax
  80271a:	83 ec 04             	sub    $0x4,%esp
  80271d:	52                   	push   %edx
  80271e:	50                   	push   %eax
  80271f:	68 e1 46 80 00       	push   $0x8046e1
  802724:	e8 b2 e5 ff ff       	call   800cdb <cprintf>
  802729:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802732:	a1 48 50 80 00       	mov    0x805048,%eax
  802737:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273e:	74 07                	je     802747 <print_mem_block_lists+0x155>
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	eb 05                	jmp    80274c <print_mem_block_lists+0x15a>
  802747:	b8 00 00 00 00       	mov    $0x0,%eax
  80274c:	a3 48 50 80 00       	mov    %eax,0x805048
  802751:	a1 48 50 80 00       	mov    0x805048,%eax
  802756:	85 c0                	test   %eax,%eax
  802758:	75 8a                	jne    8026e4 <print_mem_block_lists+0xf2>
  80275a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275e:	75 84                	jne    8026e4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802760:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802764:	75 10                	jne    802776 <print_mem_block_lists+0x184>
  802766:	83 ec 0c             	sub    $0xc,%esp
  802769:	68 2c 47 80 00       	push   $0x80472c
  80276e:	e8 68 e5 ff ff       	call   800cdb <cprintf>
  802773:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802776:	83 ec 0c             	sub    $0xc,%esp
  802779:	68 a0 46 80 00       	push   $0x8046a0
  80277e:	e8 58 e5 ff ff       	call   800cdb <cprintf>
  802783:	83 c4 10             	add    $0x10,%esp

}
  802786:	90                   	nop
  802787:	c9                   	leave  
  802788:	c3                   	ret    

00802789 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802789:	55                   	push   %ebp
  80278a:	89 e5                	mov    %esp,%ebp
  80278c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80278f:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802796:	00 00 00 
  802799:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8027a0:	00 00 00 
  8027a3:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8027aa:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8027ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8027b4:	e9 9e 00 00 00       	jmp    802857 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8027b9:	a1 50 50 80 00       	mov    0x805050,%eax
  8027be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c1:	c1 e2 04             	shl    $0x4,%edx
  8027c4:	01 d0                	add    %edx,%eax
  8027c6:	85 c0                	test   %eax,%eax
  8027c8:	75 14                	jne    8027de <initialize_MemBlocksList+0x55>
  8027ca:	83 ec 04             	sub    $0x4,%esp
  8027cd:	68 54 47 80 00       	push   $0x804754
  8027d2:	6a 46                	push   $0x46
  8027d4:	68 77 47 80 00       	push   $0x804777
  8027d9:	e8 49 e2 ff ff       	call   800a27 <_panic>
  8027de:	a1 50 50 80 00       	mov    0x805050,%eax
  8027e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e6:	c1 e2 04             	shl    $0x4,%edx
  8027e9:	01 d0                	add    %edx,%eax
  8027eb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8027f1:	89 10                	mov    %edx,(%eax)
  8027f3:	8b 00                	mov    (%eax),%eax
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	74 18                	je     802811 <initialize_MemBlocksList+0x88>
  8027f9:	a1 48 51 80 00       	mov    0x805148,%eax
  8027fe:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802804:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802807:	c1 e1 04             	shl    $0x4,%ecx
  80280a:	01 ca                	add    %ecx,%edx
  80280c:	89 50 04             	mov    %edx,0x4(%eax)
  80280f:	eb 12                	jmp    802823 <initialize_MemBlocksList+0x9a>
  802811:	a1 50 50 80 00       	mov    0x805050,%eax
  802816:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802819:	c1 e2 04             	shl    $0x4,%edx
  80281c:	01 d0                	add    %edx,%eax
  80281e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802823:	a1 50 50 80 00       	mov    0x805050,%eax
  802828:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282b:	c1 e2 04             	shl    $0x4,%edx
  80282e:	01 d0                	add    %edx,%eax
  802830:	a3 48 51 80 00       	mov    %eax,0x805148
  802835:	a1 50 50 80 00       	mov    0x805050,%eax
  80283a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283d:	c1 e2 04             	shl    $0x4,%edx
  802840:	01 d0                	add    %edx,%eax
  802842:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802849:	a1 54 51 80 00       	mov    0x805154,%eax
  80284e:	40                   	inc    %eax
  80284f:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802854:	ff 45 f4             	incl   -0xc(%ebp)
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80285d:	0f 82 56 ff ff ff    	jb     8027b9 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802863:	90                   	nop
  802864:	c9                   	leave  
  802865:	c3                   	ret    

00802866 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
  802869:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80286c:	8b 45 08             	mov    0x8(%ebp),%eax
  80286f:	8b 00                	mov    (%eax),%eax
  802871:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802874:	eb 19                	jmp    80288f <find_block+0x29>
	{
		if(va==point->sva)
  802876:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802879:	8b 40 08             	mov    0x8(%eax),%eax
  80287c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80287f:	75 05                	jne    802886 <find_block+0x20>
		   return point;
  802881:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802884:	eb 36                	jmp    8028bc <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802886:	8b 45 08             	mov    0x8(%ebp),%eax
  802889:	8b 40 08             	mov    0x8(%eax),%eax
  80288c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80288f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802893:	74 07                	je     80289c <find_block+0x36>
  802895:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	eb 05                	jmp    8028a1 <find_block+0x3b>
  80289c:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a4:	89 42 08             	mov    %eax,0x8(%edx)
  8028a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028aa:	8b 40 08             	mov    0x8(%eax),%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	75 c5                	jne    802876 <find_block+0x10>
  8028b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8028b5:	75 bf                	jne    802876 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8028b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028bc:	c9                   	leave  
  8028bd:	c3                   	ret    

008028be <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8028be:	55                   	push   %ebp
  8028bf:	89 e5                	mov    %esp,%ebp
  8028c1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8028c4:	a1 40 50 80 00       	mov    0x805040,%eax
  8028c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8028cc:	a1 44 50 80 00       	mov    0x805044,%eax
  8028d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8028d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8028da:	74 24                	je     802900 <insert_sorted_allocList+0x42>
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	8b 50 08             	mov    0x8(%eax),%edx
  8028e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e5:	8b 40 08             	mov    0x8(%eax),%eax
  8028e8:	39 c2                	cmp    %eax,%edx
  8028ea:	76 14                	jbe    802900 <insert_sorted_allocList+0x42>
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	8b 50 08             	mov    0x8(%eax),%edx
  8028f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f5:	8b 40 08             	mov    0x8(%eax),%eax
  8028f8:	39 c2                	cmp    %eax,%edx
  8028fa:	0f 82 60 01 00 00    	jb     802a60 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802900:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802904:	75 65                	jne    80296b <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802906:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80290a:	75 14                	jne    802920 <insert_sorted_allocList+0x62>
  80290c:	83 ec 04             	sub    $0x4,%esp
  80290f:	68 54 47 80 00       	push   $0x804754
  802914:	6a 6b                	push   $0x6b
  802916:	68 77 47 80 00       	push   $0x804777
  80291b:	e8 07 e1 ff ff       	call   800a27 <_panic>
  802920:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802926:	8b 45 08             	mov    0x8(%ebp),%eax
  802929:	89 10                	mov    %edx,(%eax)
  80292b:	8b 45 08             	mov    0x8(%ebp),%eax
  80292e:	8b 00                	mov    (%eax),%eax
  802930:	85 c0                	test   %eax,%eax
  802932:	74 0d                	je     802941 <insert_sorted_allocList+0x83>
  802934:	a1 40 50 80 00       	mov    0x805040,%eax
  802939:	8b 55 08             	mov    0x8(%ebp),%edx
  80293c:	89 50 04             	mov    %edx,0x4(%eax)
  80293f:	eb 08                	jmp    802949 <insert_sorted_allocList+0x8b>
  802941:	8b 45 08             	mov    0x8(%ebp),%eax
  802944:	a3 44 50 80 00       	mov    %eax,0x805044
  802949:	8b 45 08             	mov    0x8(%ebp),%eax
  80294c:	a3 40 50 80 00       	mov    %eax,0x805040
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802960:	40                   	inc    %eax
  802961:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802966:	e9 dc 01 00 00       	jmp    802b47 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80296b:	8b 45 08             	mov    0x8(%ebp),%eax
  80296e:	8b 50 08             	mov    0x8(%eax),%edx
  802971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802974:	8b 40 08             	mov    0x8(%eax),%eax
  802977:	39 c2                	cmp    %eax,%edx
  802979:	77 6c                	ja     8029e7 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80297b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80297f:	74 06                	je     802987 <insert_sorted_allocList+0xc9>
  802981:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802985:	75 14                	jne    80299b <insert_sorted_allocList+0xdd>
  802987:	83 ec 04             	sub    $0x4,%esp
  80298a:	68 90 47 80 00       	push   $0x804790
  80298f:	6a 6f                	push   $0x6f
  802991:	68 77 47 80 00       	push   $0x804777
  802996:	e8 8c e0 ff ff       	call   800a27 <_panic>
  80299b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299e:	8b 50 04             	mov    0x4(%eax),%edx
  8029a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a4:	89 50 04             	mov    %edx,0x4(%eax)
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ad:	89 10                	mov    %edx,(%eax)
  8029af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b2:	8b 40 04             	mov    0x4(%eax),%eax
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	74 0d                	je     8029c6 <insert_sorted_allocList+0x108>
  8029b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bc:	8b 40 04             	mov    0x4(%eax),%eax
  8029bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c2:	89 10                	mov    %edx,(%eax)
  8029c4:	eb 08                	jmp    8029ce <insert_sorted_allocList+0x110>
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	a3 40 50 80 00       	mov    %eax,0x805040
  8029ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d4:	89 50 04             	mov    %edx,0x4(%eax)
  8029d7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029dc:	40                   	inc    %eax
  8029dd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029e2:	e9 60 01 00 00       	jmp    802b47 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	8b 50 08             	mov    0x8(%eax),%edx
  8029ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f0:	8b 40 08             	mov    0x8(%eax),%eax
  8029f3:	39 c2                	cmp    %eax,%edx
  8029f5:	0f 82 4c 01 00 00    	jb     802b47 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8029fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ff:	75 14                	jne    802a15 <insert_sorted_allocList+0x157>
  802a01:	83 ec 04             	sub    $0x4,%esp
  802a04:	68 c8 47 80 00       	push   $0x8047c8
  802a09:	6a 73                	push   $0x73
  802a0b:	68 77 47 80 00       	push   $0x804777
  802a10:	e8 12 e0 ff ff       	call   800a27 <_panic>
  802a15:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	89 50 04             	mov    %edx,0x4(%eax)
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	8b 40 04             	mov    0x4(%eax),%eax
  802a27:	85 c0                	test   %eax,%eax
  802a29:	74 0c                	je     802a37 <insert_sorted_allocList+0x179>
  802a2b:	a1 44 50 80 00       	mov    0x805044,%eax
  802a30:	8b 55 08             	mov    0x8(%ebp),%edx
  802a33:	89 10                	mov    %edx,(%eax)
  802a35:	eb 08                	jmp    802a3f <insert_sorted_allocList+0x181>
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	a3 40 50 80 00       	mov    %eax,0x805040
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	a3 44 50 80 00       	mov    %eax,0x805044
  802a47:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a50:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a55:	40                   	inc    %eax
  802a56:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a5b:	e9 e7 00 00 00       	jmp    802b47 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a63:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802a66:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a6d:	a1 40 50 80 00       	mov    0x805040,%eax
  802a72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a75:	e9 9d 00 00 00       	jmp    802b17 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 00                	mov    (%eax),%eax
  802a7f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	8b 50 08             	mov    0x8(%eax),%edx
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 40 08             	mov    0x8(%eax),%eax
  802a8e:	39 c2                	cmp    %eax,%edx
  802a90:	76 7d                	jbe    802b0f <insert_sorted_allocList+0x251>
  802a92:	8b 45 08             	mov    0x8(%ebp),%eax
  802a95:	8b 50 08             	mov    0x8(%eax),%edx
  802a98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9b:	8b 40 08             	mov    0x8(%eax),%eax
  802a9e:	39 c2                	cmp    %eax,%edx
  802aa0:	73 6d                	jae    802b0f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802aa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa6:	74 06                	je     802aae <insert_sorted_allocList+0x1f0>
  802aa8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aac:	75 14                	jne    802ac2 <insert_sorted_allocList+0x204>
  802aae:	83 ec 04             	sub    $0x4,%esp
  802ab1:	68 ec 47 80 00       	push   $0x8047ec
  802ab6:	6a 7f                	push   $0x7f
  802ab8:	68 77 47 80 00       	push   $0x804777
  802abd:	e8 65 df ff ff       	call   800a27 <_panic>
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 10                	mov    (%eax),%edx
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	89 10                	mov    %edx,(%eax)
  802acc:	8b 45 08             	mov    0x8(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	85 c0                	test   %eax,%eax
  802ad3:	74 0b                	je     802ae0 <insert_sorted_allocList+0x222>
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	8b 00                	mov    (%eax),%eax
  802ada:	8b 55 08             	mov    0x8(%ebp),%edx
  802add:	89 50 04             	mov    %edx,0x4(%eax)
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae6:	89 10                	mov    %edx,(%eax)
  802ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aee:	89 50 04             	mov    %edx,0x4(%eax)
  802af1:	8b 45 08             	mov    0x8(%ebp),%eax
  802af4:	8b 00                	mov    (%eax),%eax
  802af6:	85 c0                	test   %eax,%eax
  802af8:	75 08                	jne    802b02 <insert_sorted_allocList+0x244>
  802afa:	8b 45 08             	mov    0x8(%ebp),%eax
  802afd:	a3 44 50 80 00       	mov    %eax,0x805044
  802b02:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b07:	40                   	inc    %eax
  802b08:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802b0d:	eb 39                	jmp    802b48 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b0f:	a1 48 50 80 00       	mov    0x805048,%eax
  802b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1b:	74 07                	je     802b24 <insert_sorted_allocList+0x266>
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	eb 05                	jmp    802b29 <insert_sorted_allocList+0x26b>
  802b24:	b8 00 00 00 00       	mov    $0x0,%eax
  802b29:	a3 48 50 80 00       	mov    %eax,0x805048
  802b2e:	a1 48 50 80 00       	mov    0x805048,%eax
  802b33:	85 c0                	test   %eax,%eax
  802b35:	0f 85 3f ff ff ff    	jne    802a7a <insert_sorted_allocList+0x1bc>
  802b3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3f:	0f 85 35 ff ff ff    	jne    802a7a <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802b45:	eb 01                	jmp    802b48 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b47:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802b48:	90                   	nop
  802b49:	c9                   	leave  
  802b4a:	c3                   	ret    

00802b4b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b4b:	55                   	push   %ebp
  802b4c:	89 e5                	mov    %esp,%ebp
  802b4e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802b51:	a1 38 51 80 00       	mov    0x805138,%eax
  802b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b59:	e9 85 01 00 00       	jmp    802ce3 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 40 0c             	mov    0xc(%eax),%eax
  802b64:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b67:	0f 82 6e 01 00 00    	jb     802cdb <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	8b 40 0c             	mov    0xc(%eax),%eax
  802b73:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b76:	0f 85 8a 00 00 00    	jne    802c06 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802b7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b80:	75 17                	jne    802b99 <alloc_block_FF+0x4e>
  802b82:	83 ec 04             	sub    $0x4,%esp
  802b85:	68 20 48 80 00       	push   $0x804820
  802b8a:	68 93 00 00 00       	push   $0x93
  802b8f:	68 77 47 80 00       	push   $0x804777
  802b94:	e8 8e de ff ff       	call   800a27 <_panic>
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 00                	mov    (%eax),%eax
  802b9e:	85 c0                	test   %eax,%eax
  802ba0:	74 10                	je     802bb2 <alloc_block_FF+0x67>
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802baa:	8b 52 04             	mov    0x4(%edx),%edx
  802bad:	89 50 04             	mov    %edx,0x4(%eax)
  802bb0:	eb 0b                	jmp    802bbd <alloc_block_FF+0x72>
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	8b 40 04             	mov    0x4(%eax),%eax
  802bb8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	8b 40 04             	mov    0x4(%eax),%eax
  802bc3:	85 c0                	test   %eax,%eax
  802bc5:	74 0f                	je     802bd6 <alloc_block_FF+0x8b>
  802bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bca:	8b 40 04             	mov    0x4(%eax),%eax
  802bcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd0:	8b 12                	mov    (%edx),%edx
  802bd2:	89 10                	mov    %edx,(%eax)
  802bd4:	eb 0a                	jmp    802be0 <alloc_block_FF+0x95>
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	a3 38 51 80 00       	mov    %eax,0x805138
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf3:	a1 44 51 80 00       	mov    0x805144,%eax
  802bf8:	48                   	dec    %eax
  802bf9:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	e9 10 01 00 00       	jmp    802d16 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c09:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c0f:	0f 86 c6 00 00 00    	jbe    802cdb <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c15:	a1 48 51 80 00       	mov    0x805148,%eax
  802c1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 50 08             	mov    0x8(%eax),%edx
  802c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c26:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c36:	75 17                	jne    802c4f <alloc_block_FF+0x104>
  802c38:	83 ec 04             	sub    $0x4,%esp
  802c3b:	68 20 48 80 00       	push   $0x804820
  802c40:	68 9b 00 00 00       	push   $0x9b
  802c45:	68 77 47 80 00       	push   $0x804777
  802c4a:	e8 d8 dd ff ff       	call   800a27 <_panic>
  802c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c52:	8b 00                	mov    (%eax),%eax
  802c54:	85 c0                	test   %eax,%eax
  802c56:	74 10                	je     802c68 <alloc_block_FF+0x11d>
  802c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5b:	8b 00                	mov    (%eax),%eax
  802c5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c60:	8b 52 04             	mov    0x4(%edx),%edx
  802c63:	89 50 04             	mov    %edx,0x4(%eax)
  802c66:	eb 0b                	jmp    802c73 <alloc_block_FF+0x128>
  802c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6b:	8b 40 04             	mov    0x4(%eax),%eax
  802c6e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c76:	8b 40 04             	mov    0x4(%eax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	74 0f                	je     802c8c <alloc_block_FF+0x141>
  802c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c80:	8b 40 04             	mov    0x4(%eax),%eax
  802c83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c86:	8b 12                	mov    (%edx),%edx
  802c88:	89 10                	mov    %edx,(%eax)
  802c8a:	eb 0a                	jmp    802c96 <alloc_block_FF+0x14b>
  802c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8f:	8b 00                	mov    (%eax),%eax
  802c91:	a3 48 51 80 00       	mov    %eax,0x805148
  802c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca9:	a1 54 51 80 00       	mov    0x805154,%eax
  802cae:	48                   	dec    %eax
  802caf:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	8b 50 08             	mov    0x8(%eax),%edx
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	01 c2                	add    %eax,%edx
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccb:	2b 45 08             	sub    0x8(%ebp),%eax
  802cce:	89 c2                	mov    %eax,%edx
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd9:	eb 3b                	jmp    802d16 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802cdb:	a1 40 51 80 00       	mov    0x805140,%eax
  802ce0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce7:	74 07                	je     802cf0 <alloc_block_FF+0x1a5>
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 00                	mov    (%eax),%eax
  802cee:	eb 05                	jmp    802cf5 <alloc_block_FF+0x1aa>
  802cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf5:	a3 40 51 80 00       	mov    %eax,0x805140
  802cfa:	a1 40 51 80 00       	mov    0x805140,%eax
  802cff:	85 c0                	test   %eax,%eax
  802d01:	0f 85 57 fe ff ff    	jne    802b5e <alloc_block_FF+0x13>
  802d07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0b:	0f 85 4d fe ff ff    	jne    802b5e <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802d11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d16:	c9                   	leave  
  802d17:	c3                   	ret    

00802d18 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802d18:	55                   	push   %ebp
  802d19:	89 e5                	mov    %esp,%ebp
  802d1b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802d1e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802d25:	a1 38 51 80 00       	mov    0x805138,%eax
  802d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d2d:	e9 df 00 00 00       	jmp    802e11 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d35:	8b 40 0c             	mov    0xc(%eax),%eax
  802d38:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d3b:	0f 82 c8 00 00 00    	jb     802e09 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d44:	8b 40 0c             	mov    0xc(%eax),%eax
  802d47:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d4a:	0f 85 8a 00 00 00    	jne    802dda <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802d50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d54:	75 17                	jne    802d6d <alloc_block_BF+0x55>
  802d56:	83 ec 04             	sub    $0x4,%esp
  802d59:	68 20 48 80 00       	push   $0x804820
  802d5e:	68 b7 00 00 00       	push   $0xb7
  802d63:	68 77 47 80 00       	push   $0x804777
  802d68:	e8 ba dc ff ff       	call   800a27 <_panic>
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 00                	mov    (%eax),%eax
  802d72:	85 c0                	test   %eax,%eax
  802d74:	74 10                	je     802d86 <alloc_block_BF+0x6e>
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	8b 00                	mov    (%eax),%eax
  802d7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7e:	8b 52 04             	mov    0x4(%edx),%edx
  802d81:	89 50 04             	mov    %edx,0x4(%eax)
  802d84:	eb 0b                	jmp    802d91 <alloc_block_BF+0x79>
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	8b 40 04             	mov    0x4(%eax),%eax
  802d8c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 40 04             	mov    0x4(%eax),%eax
  802d97:	85 c0                	test   %eax,%eax
  802d99:	74 0f                	je     802daa <alloc_block_BF+0x92>
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	8b 40 04             	mov    0x4(%eax),%eax
  802da1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802da4:	8b 12                	mov    (%edx),%edx
  802da6:	89 10                	mov    %edx,(%eax)
  802da8:	eb 0a                	jmp    802db4 <alloc_block_BF+0x9c>
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	a3 38 51 80 00       	mov    %eax,0x805138
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc7:	a1 44 51 80 00       	mov    0x805144,%eax
  802dcc:	48                   	dec    %eax
  802dcd:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	e9 4d 01 00 00       	jmp    802f27 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddd:	8b 40 0c             	mov    0xc(%eax),%eax
  802de0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802de3:	76 24                	jbe    802e09 <alloc_block_BF+0xf1>
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	8b 40 0c             	mov    0xc(%eax),%eax
  802deb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802dee:	73 19                	jae    802e09 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802df0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802dfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	8b 40 08             	mov    0x8(%eax),%eax
  802e06:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802e09:	a1 40 51 80 00       	mov    0x805140,%eax
  802e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e15:	74 07                	je     802e1e <alloc_block_BF+0x106>
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	8b 00                	mov    (%eax),%eax
  802e1c:	eb 05                	jmp    802e23 <alloc_block_BF+0x10b>
  802e1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e23:	a3 40 51 80 00       	mov    %eax,0x805140
  802e28:	a1 40 51 80 00       	mov    0x805140,%eax
  802e2d:	85 c0                	test   %eax,%eax
  802e2f:	0f 85 fd fe ff ff    	jne    802d32 <alloc_block_BF+0x1a>
  802e35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e39:	0f 85 f3 fe ff ff    	jne    802d32 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802e3f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e43:	0f 84 d9 00 00 00    	je     802f22 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e49:	a1 48 51 80 00       	mov    0x805148,%eax
  802e4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802e51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e54:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e57:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802e5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e60:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802e63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e67:	75 17                	jne    802e80 <alloc_block_BF+0x168>
  802e69:	83 ec 04             	sub    $0x4,%esp
  802e6c:	68 20 48 80 00       	push   $0x804820
  802e71:	68 c7 00 00 00       	push   $0xc7
  802e76:	68 77 47 80 00       	push   $0x804777
  802e7b:	e8 a7 db ff ff       	call   800a27 <_panic>
  802e80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e83:	8b 00                	mov    (%eax),%eax
  802e85:	85 c0                	test   %eax,%eax
  802e87:	74 10                	je     802e99 <alloc_block_BF+0x181>
  802e89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8c:	8b 00                	mov    (%eax),%eax
  802e8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e91:	8b 52 04             	mov    0x4(%edx),%edx
  802e94:	89 50 04             	mov    %edx,0x4(%eax)
  802e97:	eb 0b                	jmp    802ea4 <alloc_block_BF+0x18c>
  802e99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e9c:	8b 40 04             	mov    0x4(%eax),%eax
  802e9f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ea4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea7:	8b 40 04             	mov    0x4(%eax),%eax
  802eaa:	85 c0                	test   %eax,%eax
  802eac:	74 0f                	je     802ebd <alloc_block_BF+0x1a5>
  802eae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb1:	8b 40 04             	mov    0x4(%eax),%eax
  802eb4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802eb7:	8b 12                	mov    (%edx),%edx
  802eb9:	89 10                	mov    %edx,(%eax)
  802ebb:	eb 0a                	jmp    802ec7 <alloc_block_BF+0x1af>
  802ebd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec0:	8b 00                	mov    (%eax),%eax
  802ec2:	a3 48 51 80 00       	mov    %eax,0x805148
  802ec7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eda:	a1 54 51 80 00       	mov    0x805154,%eax
  802edf:	48                   	dec    %eax
  802ee0:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802ee5:	83 ec 08             	sub    $0x8,%esp
  802ee8:	ff 75 ec             	pushl  -0x14(%ebp)
  802eeb:	68 38 51 80 00       	push   $0x805138
  802ef0:	e8 71 f9 ff ff       	call   802866 <find_block>
  802ef5:	83 c4 10             	add    $0x10,%esp
  802ef8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802efb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802efe:	8b 50 08             	mov    0x8(%eax),%edx
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	01 c2                	add    %eax,%edx
  802f06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f09:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802f0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f12:	2b 45 08             	sub    0x8(%ebp),%eax
  802f15:	89 c2                	mov    %eax,%edx
  802f17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802f1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f20:	eb 05                	jmp    802f27 <alloc_block_BF+0x20f>
	}
	return NULL;
  802f22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f27:	c9                   	leave  
  802f28:	c3                   	ret    

00802f29 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802f29:	55                   	push   %ebp
  802f2a:	89 e5                	mov    %esp,%ebp
  802f2c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802f2f:	a1 28 50 80 00       	mov    0x805028,%eax
  802f34:	85 c0                	test   %eax,%eax
  802f36:	0f 85 de 01 00 00    	jne    80311a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802f3c:	a1 38 51 80 00       	mov    0x805138,%eax
  802f41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f44:	e9 9e 01 00 00       	jmp    8030e7 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f52:	0f 82 87 01 00 00    	jb     8030df <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f61:	0f 85 95 00 00 00    	jne    802ffc <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802f67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6b:	75 17                	jne    802f84 <alloc_block_NF+0x5b>
  802f6d:	83 ec 04             	sub    $0x4,%esp
  802f70:	68 20 48 80 00       	push   $0x804820
  802f75:	68 e0 00 00 00       	push   $0xe0
  802f7a:	68 77 47 80 00       	push   $0x804777
  802f7f:	e8 a3 da ff ff       	call   800a27 <_panic>
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	8b 00                	mov    (%eax),%eax
  802f89:	85 c0                	test   %eax,%eax
  802f8b:	74 10                	je     802f9d <alloc_block_NF+0x74>
  802f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f90:	8b 00                	mov    (%eax),%eax
  802f92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f95:	8b 52 04             	mov    0x4(%edx),%edx
  802f98:	89 50 04             	mov    %edx,0x4(%eax)
  802f9b:	eb 0b                	jmp    802fa8 <alloc_block_NF+0x7f>
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	8b 40 04             	mov    0x4(%eax),%eax
  802fa3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 40 04             	mov    0x4(%eax),%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	74 0f                	je     802fc1 <alloc_block_NF+0x98>
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	8b 40 04             	mov    0x4(%eax),%eax
  802fb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fbb:	8b 12                	mov    (%edx),%edx
  802fbd:	89 10                	mov    %edx,(%eax)
  802fbf:	eb 0a                	jmp    802fcb <alloc_block_NF+0xa2>
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 00                	mov    (%eax),%eax
  802fc6:	a3 38 51 80 00       	mov    %eax,0x805138
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fde:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe3:	48                   	dec    %eax
  802fe4:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	8b 40 08             	mov    0x8(%eax),%eax
  802fef:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	e9 f8 04 00 00       	jmp    8034f4 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fff:	8b 40 0c             	mov    0xc(%eax),%eax
  803002:	3b 45 08             	cmp    0x8(%ebp),%eax
  803005:	0f 86 d4 00 00 00    	jbe    8030df <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80300b:	a1 48 51 80 00       	mov    0x805148,%eax
  803010:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	8b 50 08             	mov    0x8(%eax),%edx
  803019:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80301f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803022:	8b 55 08             	mov    0x8(%ebp),%edx
  803025:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803028:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80302c:	75 17                	jne    803045 <alloc_block_NF+0x11c>
  80302e:	83 ec 04             	sub    $0x4,%esp
  803031:	68 20 48 80 00       	push   $0x804820
  803036:	68 e9 00 00 00       	push   $0xe9
  80303b:	68 77 47 80 00       	push   $0x804777
  803040:	e8 e2 d9 ff ff       	call   800a27 <_panic>
  803045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803048:	8b 00                	mov    (%eax),%eax
  80304a:	85 c0                	test   %eax,%eax
  80304c:	74 10                	je     80305e <alloc_block_NF+0x135>
  80304e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803056:	8b 52 04             	mov    0x4(%edx),%edx
  803059:	89 50 04             	mov    %edx,0x4(%eax)
  80305c:	eb 0b                	jmp    803069 <alloc_block_NF+0x140>
  80305e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803061:	8b 40 04             	mov    0x4(%eax),%eax
  803064:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306c:	8b 40 04             	mov    0x4(%eax),%eax
  80306f:	85 c0                	test   %eax,%eax
  803071:	74 0f                	je     803082 <alloc_block_NF+0x159>
  803073:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803076:	8b 40 04             	mov    0x4(%eax),%eax
  803079:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80307c:	8b 12                	mov    (%edx),%edx
  80307e:	89 10                	mov    %edx,(%eax)
  803080:	eb 0a                	jmp    80308c <alloc_block_NF+0x163>
  803082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803085:	8b 00                	mov    (%eax),%eax
  803087:	a3 48 51 80 00       	mov    %eax,0x805148
  80308c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803095:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803098:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309f:	a1 54 51 80 00       	mov    0x805154,%eax
  8030a4:	48                   	dec    %eax
  8030a5:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8030aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ad:	8b 40 08             	mov    0x8(%eax),%eax
  8030b0:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	8b 50 08             	mov    0x8(%eax),%edx
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	01 c2                	add    %eax,%edx
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cc:	2b 45 08             	sub    0x8(%ebp),%eax
  8030cf:	89 c2                	mov    %eax,%edx
  8030d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d4:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8030d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030da:	e9 15 04 00 00       	jmp    8034f4 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8030df:	a1 40 51 80 00       	mov    0x805140,%eax
  8030e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030eb:	74 07                	je     8030f4 <alloc_block_NF+0x1cb>
  8030ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f0:	8b 00                	mov    (%eax),%eax
  8030f2:	eb 05                	jmp    8030f9 <alloc_block_NF+0x1d0>
  8030f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f9:	a3 40 51 80 00       	mov    %eax,0x805140
  8030fe:	a1 40 51 80 00       	mov    0x805140,%eax
  803103:	85 c0                	test   %eax,%eax
  803105:	0f 85 3e fe ff ff    	jne    802f49 <alloc_block_NF+0x20>
  80310b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310f:	0f 85 34 fe ff ff    	jne    802f49 <alloc_block_NF+0x20>
  803115:	e9 d5 03 00 00       	jmp    8034ef <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80311a:	a1 38 51 80 00       	mov    0x805138,%eax
  80311f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803122:	e9 b1 01 00 00       	jmp    8032d8 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312a:	8b 50 08             	mov    0x8(%eax),%edx
  80312d:	a1 28 50 80 00       	mov    0x805028,%eax
  803132:	39 c2                	cmp    %eax,%edx
  803134:	0f 82 96 01 00 00    	jb     8032d0 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313d:	8b 40 0c             	mov    0xc(%eax),%eax
  803140:	3b 45 08             	cmp    0x8(%ebp),%eax
  803143:	0f 82 87 01 00 00    	jb     8032d0 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314c:	8b 40 0c             	mov    0xc(%eax),%eax
  80314f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803152:	0f 85 95 00 00 00    	jne    8031ed <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803158:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80315c:	75 17                	jne    803175 <alloc_block_NF+0x24c>
  80315e:	83 ec 04             	sub    $0x4,%esp
  803161:	68 20 48 80 00       	push   $0x804820
  803166:	68 fc 00 00 00       	push   $0xfc
  80316b:	68 77 47 80 00       	push   $0x804777
  803170:	e8 b2 d8 ff ff       	call   800a27 <_panic>
  803175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803178:	8b 00                	mov    (%eax),%eax
  80317a:	85 c0                	test   %eax,%eax
  80317c:	74 10                	je     80318e <alloc_block_NF+0x265>
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	8b 00                	mov    (%eax),%eax
  803183:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803186:	8b 52 04             	mov    0x4(%edx),%edx
  803189:	89 50 04             	mov    %edx,0x4(%eax)
  80318c:	eb 0b                	jmp    803199 <alloc_block_NF+0x270>
  80318e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803191:	8b 40 04             	mov    0x4(%eax),%eax
  803194:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319c:	8b 40 04             	mov    0x4(%eax),%eax
  80319f:	85 c0                	test   %eax,%eax
  8031a1:	74 0f                	je     8031b2 <alloc_block_NF+0x289>
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	8b 40 04             	mov    0x4(%eax),%eax
  8031a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031ac:	8b 12                	mov    (%edx),%edx
  8031ae:	89 10                	mov    %edx,(%eax)
  8031b0:	eb 0a                	jmp    8031bc <alloc_block_NF+0x293>
  8031b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b5:	8b 00                	mov    (%eax),%eax
  8031b7:	a3 38 51 80 00       	mov    %eax,0x805138
  8031bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031cf:	a1 44 51 80 00       	mov    0x805144,%eax
  8031d4:	48                   	dec    %eax
  8031d5:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8031da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031dd:	8b 40 08             	mov    0x8(%eax),%eax
  8031e0:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8031e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e8:	e9 07 03 00 00       	jmp    8034f4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8031ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f6:	0f 86 d4 00 00 00    	jbe    8032d0 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8031fc:	a1 48 51 80 00       	mov    0x805148,%eax
  803201:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803204:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803207:	8b 50 08             	mov    0x8(%eax),%edx
  80320a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803210:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803213:	8b 55 08             	mov    0x8(%ebp),%edx
  803216:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803219:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80321d:	75 17                	jne    803236 <alloc_block_NF+0x30d>
  80321f:	83 ec 04             	sub    $0x4,%esp
  803222:	68 20 48 80 00       	push   $0x804820
  803227:	68 04 01 00 00       	push   $0x104
  80322c:	68 77 47 80 00       	push   $0x804777
  803231:	e8 f1 d7 ff ff       	call   800a27 <_panic>
  803236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803239:	8b 00                	mov    (%eax),%eax
  80323b:	85 c0                	test   %eax,%eax
  80323d:	74 10                	je     80324f <alloc_block_NF+0x326>
  80323f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803242:	8b 00                	mov    (%eax),%eax
  803244:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803247:	8b 52 04             	mov    0x4(%edx),%edx
  80324a:	89 50 04             	mov    %edx,0x4(%eax)
  80324d:	eb 0b                	jmp    80325a <alloc_block_NF+0x331>
  80324f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803252:	8b 40 04             	mov    0x4(%eax),%eax
  803255:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80325a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325d:	8b 40 04             	mov    0x4(%eax),%eax
  803260:	85 c0                	test   %eax,%eax
  803262:	74 0f                	je     803273 <alloc_block_NF+0x34a>
  803264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803267:	8b 40 04             	mov    0x4(%eax),%eax
  80326a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80326d:	8b 12                	mov    (%edx),%edx
  80326f:	89 10                	mov    %edx,(%eax)
  803271:	eb 0a                	jmp    80327d <alloc_block_NF+0x354>
  803273:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803276:	8b 00                	mov    (%eax),%eax
  803278:	a3 48 51 80 00       	mov    %eax,0x805148
  80327d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803280:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803286:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803289:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803290:	a1 54 51 80 00       	mov    0x805154,%eax
  803295:	48                   	dec    %eax
  803296:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80329b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329e:	8b 40 08             	mov    0x8(%eax),%eax
  8032a1:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	8b 50 08             	mov    0x8(%eax),%edx
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	01 c2                	add    %eax,%edx
  8032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b4:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8032b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8032bd:	2b 45 08             	sub    0x8(%ebp),%eax
  8032c0:	89 c2                	mov    %eax,%edx
  8032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8032c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cb:	e9 24 02 00 00       	jmp    8034f4 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8032d0:	a1 40 51 80 00       	mov    0x805140,%eax
  8032d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032dc:	74 07                	je     8032e5 <alloc_block_NF+0x3bc>
  8032de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e1:	8b 00                	mov    (%eax),%eax
  8032e3:	eb 05                	jmp    8032ea <alloc_block_NF+0x3c1>
  8032e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ea:	a3 40 51 80 00       	mov    %eax,0x805140
  8032ef:	a1 40 51 80 00       	mov    0x805140,%eax
  8032f4:	85 c0                	test   %eax,%eax
  8032f6:	0f 85 2b fe ff ff    	jne    803127 <alloc_block_NF+0x1fe>
  8032fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803300:	0f 85 21 fe ff ff    	jne    803127 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803306:	a1 38 51 80 00       	mov    0x805138,%eax
  80330b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80330e:	e9 ae 01 00 00       	jmp    8034c1 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803316:	8b 50 08             	mov    0x8(%eax),%edx
  803319:	a1 28 50 80 00       	mov    0x805028,%eax
  80331e:	39 c2                	cmp    %eax,%edx
  803320:	0f 83 93 01 00 00    	jae    8034b9 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803329:	8b 40 0c             	mov    0xc(%eax),%eax
  80332c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80332f:	0f 82 84 01 00 00    	jb     8034b9 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803338:	8b 40 0c             	mov    0xc(%eax),%eax
  80333b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80333e:	0f 85 95 00 00 00    	jne    8033d9 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803344:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803348:	75 17                	jne    803361 <alloc_block_NF+0x438>
  80334a:	83 ec 04             	sub    $0x4,%esp
  80334d:	68 20 48 80 00       	push   $0x804820
  803352:	68 14 01 00 00       	push   $0x114
  803357:	68 77 47 80 00       	push   $0x804777
  80335c:	e8 c6 d6 ff ff       	call   800a27 <_panic>
  803361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803364:	8b 00                	mov    (%eax),%eax
  803366:	85 c0                	test   %eax,%eax
  803368:	74 10                	je     80337a <alloc_block_NF+0x451>
  80336a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336d:	8b 00                	mov    (%eax),%eax
  80336f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803372:	8b 52 04             	mov    0x4(%edx),%edx
  803375:	89 50 04             	mov    %edx,0x4(%eax)
  803378:	eb 0b                	jmp    803385 <alloc_block_NF+0x45c>
  80337a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337d:	8b 40 04             	mov    0x4(%eax),%eax
  803380:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803388:	8b 40 04             	mov    0x4(%eax),%eax
  80338b:	85 c0                	test   %eax,%eax
  80338d:	74 0f                	je     80339e <alloc_block_NF+0x475>
  80338f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803392:	8b 40 04             	mov    0x4(%eax),%eax
  803395:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803398:	8b 12                	mov    (%edx),%edx
  80339a:	89 10                	mov    %edx,(%eax)
  80339c:	eb 0a                	jmp    8033a8 <alloc_block_NF+0x47f>
  80339e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a1:	8b 00                	mov    (%eax),%eax
  8033a3:	a3 38 51 80 00       	mov    %eax,0x805138
  8033a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8033c0:	48                   	dec    %eax
  8033c1:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8033c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c9:	8b 40 08             	mov    0x8(%eax),%eax
  8033cc:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8033d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d4:	e9 1b 01 00 00       	jmp    8034f4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8033d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033e2:	0f 86 d1 00 00 00    	jbe    8034b9 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8033e8:	a1 48 51 80 00       	mov    0x805148,%eax
  8033ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8033f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f3:	8b 50 08             	mov    0x8(%eax),%edx
  8033f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f9:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8033fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803402:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803405:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803409:	75 17                	jne    803422 <alloc_block_NF+0x4f9>
  80340b:	83 ec 04             	sub    $0x4,%esp
  80340e:	68 20 48 80 00       	push   $0x804820
  803413:	68 1c 01 00 00       	push   $0x11c
  803418:	68 77 47 80 00       	push   $0x804777
  80341d:	e8 05 d6 ff ff       	call   800a27 <_panic>
  803422:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803425:	8b 00                	mov    (%eax),%eax
  803427:	85 c0                	test   %eax,%eax
  803429:	74 10                	je     80343b <alloc_block_NF+0x512>
  80342b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342e:	8b 00                	mov    (%eax),%eax
  803430:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803433:	8b 52 04             	mov    0x4(%edx),%edx
  803436:	89 50 04             	mov    %edx,0x4(%eax)
  803439:	eb 0b                	jmp    803446 <alloc_block_NF+0x51d>
  80343b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343e:	8b 40 04             	mov    0x4(%eax),%eax
  803441:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803449:	8b 40 04             	mov    0x4(%eax),%eax
  80344c:	85 c0                	test   %eax,%eax
  80344e:	74 0f                	je     80345f <alloc_block_NF+0x536>
  803450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803453:	8b 40 04             	mov    0x4(%eax),%eax
  803456:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803459:	8b 12                	mov    (%edx),%edx
  80345b:	89 10                	mov    %edx,(%eax)
  80345d:	eb 0a                	jmp    803469 <alloc_block_NF+0x540>
  80345f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803462:	8b 00                	mov    (%eax),%eax
  803464:	a3 48 51 80 00       	mov    %eax,0x805148
  803469:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80346c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803472:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803475:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80347c:	a1 54 51 80 00       	mov    0x805154,%eax
  803481:	48                   	dec    %eax
  803482:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803487:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80348a:	8b 40 08             	mov    0x8(%eax),%eax
  80348d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803495:	8b 50 08             	mov    0x8(%eax),%edx
  803498:	8b 45 08             	mov    0x8(%ebp),%eax
  80349b:	01 c2                	add    %eax,%edx
  80349d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a0:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8034a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a9:	2b 45 08             	sub    0x8(%ebp),%eax
  8034ac:	89 c2                	mov    %eax,%edx
  8034ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b1:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8034b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b7:	eb 3b                	jmp    8034f4 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8034b9:	a1 40 51 80 00       	mov    0x805140,%eax
  8034be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c5:	74 07                	je     8034ce <alloc_block_NF+0x5a5>
  8034c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ca:	8b 00                	mov    (%eax),%eax
  8034cc:	eb 05                	jmp    8034d3 <alloc_block_NF+0x5aa>
  8034ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d3:	a3 40 51 80 00       	mov    %eax,0x805140
  8034d8:	a1 40 51 80 00       	mov    0x805140,%eax
  8034dd:	85 c0                	test   %eax,%eax
  8034df:	0f 85 2e fe ff ff    	jne    803313 <alloc_block_NF+0x3ea>
  8034e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e9:	0f 85 24 fe ff ff    	jne    803313 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8034ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034f4:	c9                   	leave  
  8034f5:	c3                   	ret    

008034f6 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8034f6:	55                   	push   %ebp
  8034f7:	89 e5                	mov    %esp,%ebp
  8034f9:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8034fc:	a1 38 51 80 00       	mov    0x805138,%eax
  803501:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803504:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803509:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80350c:	a1 38 51 80 00       	mov    0x805138,%eax
  803511:	85 c0                	test   %eax,%eax
  803513:	74 14                	je     803529 <insert_sorted_with_merge_freeList+0x33>
  803515:	8b 45 08             	mov    0x8(%ebp),%eax
  803518:	8b 50 08             	mov    0x8(%eax),%edx
  80351b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80351e:	8b 40 08             	mov    0x8(%eax),%eax
  803521:	39 c2                	cmp    %eax,%edx
  803523:	0f 87 9b 01 00 00    	ja     8036c4 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803529:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80352d:	75 17                	jne    803546 <insert_sorted_with_merge_freeList+0x50>
  80352f:	83 ec 04             	sub    $0x4,%esp
  803532:	68 54 47 80 00       	push   $0x804754
  803537:	68 38 01 00 00       	push   $0x138
  80353c:	68 77 47 80 00       	push   $0x804777
  803541:	e8 e1 d4 ff ff       	call   800a27 <_panic>
  803546:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80354c:	8b 45 08             	mov    0x8(%ebp),%eax
  80354f:	89 10                	mov    %edx,(%eax)
  803551:	8b 45 08             	mov    0x8(%ebp),%eax
  803554:	8b 00                	mov    (%eax),%eax
  803556:	85 c0                	test   %eax,%eax
  803558:	74 0d                	je     803567 <insert_sorted_with_merge_freeList+0x71>
  80355a:	a1 38 51 80 00       	mov    0x805138,%eax
  80355f:	8b 55 08             	mov    0x8(%ebp),%edx
  803562:	89 50 04             	mov    %edx,0x4(%eax)
  803565:	eb 08                	jmp    80356f <insert_sorted_with_merge_freeList+0x79>
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80356f:	8b 45 08             	mov    0x8(%ebp),%eax
  803572:	a3 38 51 80 00       	mov    %eax,0x805138
  803577:	8b 45 08             	mov    0x8(%ebp),%eax
  80357a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803581:	a1 44 51 80 00       	mov    0x805144,%eax
  803586:	40                   	inc    %eax
  803587:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80358c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803590:	0f 84 a8 06 00 00    	je     803c3e <insert_sorted_with_merge_freeList+0x748>
  803596:	8b 45 08             	mov    0x8(%ebp),%eax
  803599:	8b 50 08             	mov    0x8(%eax),%edx
  80359c:	8b 45 08             	mov    0x8(%ebp),%eax
  80359f:	8b 40 0c             	mov    0xc(%eax),%eax
  8035a2:	01 c2                	add    %eax,%edx
  8035a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a7:	8b 40 08             	mov    0x8(%eax),%eax
  8035aa:	39 c2                	cmp    %eax,%edx
  8035ac:	0f 85 8c 06 00 00    	jne    803c3e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8035b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b5:	8b 50 0c             	mov    0xc(%eax),%edx
  8035b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8035be:	01 c2                	add    %eax,%edx
  8035c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c3:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8035c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035ca:	75 17                	jne    8035e3 <insert_sorted_with_merge_freeList+0xed>
  8035cc:	83 ec 04             	sub    $0x4,%esp
  8035cf:	68 20 48 80 00       	push   $0x804820
  8035d4:	68 3c 01 00 00       	push   $0x13c
  8035d9:	68 77 47 80 00       	push   $0x804777
  8035de:	e8 44 d4 ff ff       	call   800a27 <_panic>
  8035e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e6:	8b 00                	mov    (%eax),%eax
  8035e8:	85 c0                	test   %eax,%eax
  8035ea:	74 10                	je     8035fc <insert_sorted_with_merge_freeList+0x106>
  8035ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ef:	8b 00                	mov    (%eax),%eax
  8035f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035f4:	8b 52 04             	mov    0x4(%edx),%edx
  8035f7:	89 50 04             	mov    %edx,0x4(%eax)
  8035fa:	eb 0b                	jmp    803607 <insert_sorted_with_merge_freeList+0x111>
  8035fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ff:	8b 40 04             	mov    0x4(%eax),%eax
  803602:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360a:	8b 40 04             	mov    0x4(%eax),%eax
  80360d:	85 c0                	test   %eax,%eax
  80360f:	74 0f                	je     803620 <insert_sorted_with_merge_freeList+0x12a>
  803611:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803614:	8b 40 04             	mov    0x4(%eax),%eax
  803617:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80361a:	8b 12                	mov    (%edx),%edx
  80361c:	89 10                	mov    %edx,(%eax)
  80361e:	eb 0a                	jmp    80362a <insert_sorted_with_merge_freeList+0x134>
  803620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803623:	8b 00                	mov    (%eax),%eax
  803625:	a3 38 51 80 00       	mov    %eax,0x805138
  80362a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80362d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803636:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363d:	a1 44 51 80 00       	mov    0x805144,%eax
  803642:	48                   	dec    %eax
  803643:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80364b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803655:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80365c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803660:	75 17                	jne    803679 <insert_sorted_with_merge_freeList+0x183>
  803662:	83 ec 04             	sub    $0x4,%esp
  803665:	68 54 47 80 00       	push   $0x804754
  80366a:	68 3f 01 00 00       	push   $0x13f
  80366f:	68 77 47 80 00       	push   $0x804777
  803674:	e8 ae d3 ff ff       	call   800a27 <_panic>
  803679:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80367f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803682:	89 10                	mov    %edx,(%eax)
  803684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803687:	8b 00                	mov    (%eax),%eax
  803689:	85 c0                	test   %eax,%eax
  80368b:	74 0d                	je     80369a <insert_sorted_with_merge_freeList+0x1a4>
  80368d:	a1 48 51 80 00       	mov    0x805148,%eax
  803692:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803695:	89 50 04             	mov    %edx,0x4(%eax)
  803698:	eb 08                	jmp    8036a2 <insert_sorted_with_merge_freeList+0x1ac>
  80369a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a5:	a3 48 51 80 00       	mov    %eax,0x805148
  8036aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036b4:	a1 54 51 80 00       	mov    0x805154,%eax
  8036b9:	40                   	inc    %eax
  8036ba:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8036bf:	e9 7a 05 00 00       	jmp    803c3e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8036c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c7:	8b 50 08             	mov    0x8(%eax),%edx
  8036ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036cd:	8b 40 08             	mov    0x8(%eax),%eax
  8036d0:	39 c2                	cmp    %eax,%edx
  8036d2:	0f 82 14 01 00 00    	jb     8037ec <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8036d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036db:	8b 50 08             	mov    0x8(%eax),%edx
  8036de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8036e4:	01 c2                	add    %eax,%edx
  8036e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e9:	8b 40 08             	mov    0x8(%eax),%eax
  8036ec:	39 c2                	cmp    %eax,%edx
  8036ee:	0f 85 90 00 00 00    	jne    803784 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8036f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f7:	8b 50 0c             	mov    0xc(%eax),%edx
  8036fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803700:	01 c2                	add    %eax,%edx
  803702:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803705:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803708:	8b 45 08             	mov    0x8(%ebp),%eax
  80370b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803712:	8b 45 08             	mov    0x8(%ebp),%eax
  803715:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80371c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803720:	75 17                	jne    803739 <insert_sorted_with_merge_freeList+0x243>
  803722:	83 ec 04             	sub    $0x4,%esp
  803725:	68 54 47 80 00       	push   $0x804754
  80372a:	68 49 01 00 00       	push   $0x149
  80372f:	68 77 47 80 00       	push   $0x804777
  803734:	e8 ee d2 ff ff       	call   800a27 <_panic>
  803739:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80373f:	8b 45 08             	mov    0x8(%ebp),%eax
  803742:	89 10                	mov    %edx,(%eax)
  803744:	8b 45 08             	mov    0x8(%ebp),%eax
  803747:	8b 00                	mov    (%eax),%eax
  803749:	85 c0                	test   %eax,%eax
  80374b:	74 0d                	je     80375a <insert_sorted_with_merge_freeList+0x264>
  80374d:	a1 48 51 80 00       	mov    0x805148,%eax
  803752:	8b 55 08             	mov    0x8(%ebp),%edx
  803755:	89 50 04             	mov    %edx,0x4(%eax)
  803758:	eb 08                	jmp    803762 <insert_sorted_with_merge_freeList+0x26c>
  80375a:	8b 45 08             	mov    0x8(%ebp),%eax
  80375d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803762:	8b 45 08             	mov    0x8(%ebp),%eax
  803765:	a3 48 51 80 00       	mov    %eax,0x805148
  80376a:	8b 45 08             	mov    0x8(%ebp),%eax
  80376d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803774:	a1 54 51 80 00       	mov    0x805154,%eax
  803779:	40                   	inc    %eax
  80377a:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80377f:	e9 bb 04 00 00       	jmp    803c3f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803784:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803788:	75 17                	jne    8037a1 <insert_sorted_with_merge_freeList+0x2ab>
  80378a:	83 ec 04             	sub    $0x4,%esp
  80378d:	68 c8 47 80 00       	push   $0x8047c8
  803792:	68 4c 01 00 00       	push   $0x14c
  803797:	68 77 47 80 00       	push   $0x804777
  80379c:	e8 86 d2 ff ff       	call   800a27 <_panic>
  8037a1:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037aa:	89 50 04             	mov    %edx,0x4(%eax)
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	8b 40 04             	mov    0x4(%eax),%eax
  8037b3:	85 c0                	test   %eax,%eax
  8037b5:	74 0c                	je     8037c3 <insert_sorted_with_merge_freeList+0x2cd>
  8037b7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8037bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8037bf:	89 10                	mov    %edx,(%eax)
  8037c1:	eb 08                	jmp    8037cb <insert_sorted_with_merge_freeList+0x2d5>
  8037c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c6:	a3 38 51 80 00       	mov    %eax,0x805138
  8037cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ce:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037dc:	a1 44 51 80 00       	mov    0x805144,%eax
  8037e1:	40                   	inc    %eax
  8037e2:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037e7:	e9 53 04 00 00       	jmp    803c3f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8037ec:	a1 38 51 80 00       	mov    0x805138,%eax
  8037f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037f4:	e9 15 04 00 00       	jmp    803c0e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8037f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fc:	8b 00                	mov    (%eax),%eax
  8037fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803801:	8b 45 08             	mov    0x8(%ebp),%eax
  803804:	8b 50 08             	mov    0x8(%eax),%edx
  803807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380a:	8b 40 08             	mov    0x8(%eax),%eax
  80380d:	39 c2                	cmp    %eax,%edx
  80380f:	0f 86 f1 03 00 00    	jbe    803c06 <insert_sorted_with_merge_freeList+0x710>
  803815:	8b 45 08             	mov    0x8(%ebp),%eax
  803818:	8b 50 08             	mov    0x8(%eax),%edx
  80381b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381e:	8b 40 08             	mov    0x8(%eax),%eax
  803821:	39 c2                	cmp    %eax,%edx
  803823:	0f 83 dd 03 00 00    	jae    803c06 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382c:	8b 50 08             	mov    0x8(%eax),%edx
  80382f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803832:	8b 40 0c             	mov    0xc(%eax),%eax
  803835:	01 c2                	add    %eax,%edx
  803837:	8b 45 08             	mov    0x8(%ebp),%eax
  80383a:	8b 40 08             	mov    0x8(%eax),%eax
  80383d:	39 c2                	cmp    %eax,%edx
  80383f:	0f 85 b9 01 00 00    	jne    8039fe <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803845:	8b 45 08             	mov    0x8(%ebp),%eax
  803848:	8b 50 08             	mov    0x8(%eax),%edx
  80384b:	8b 45 08             	mov    0x8(%ebp),%eax
  80384e:	8b 40 0c             	mov    0xc(%eax),%eax
  803851:	01 c2                	add    %eax,%edx
  803853:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803856:	8b 40 08             	mov    0x8(%eax),%eax
  803859:	39 c2                	cmp    %eax,%edx
  80385b:	0f 85 0d 01 00 00    	jne    80396e <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803864:	8b 50 0c             	mov    0xc(%eax),%edx
  803867:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386a:	8b 40 0c             	mov    0xc(%eax),%eax
  80386d:	01 c2                	add    %eax,%edx
  80386f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803872:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803875:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803879:	75 17                	jne    803892 <insert_sorted_with_merge_freeList+0x39c>
  80387b:	83 ec 04             	sub    $0x4,%esp
  80387e:	68 20 48 80 00       	push   $0x804820
  803883:	68 5c 01 00 00       	push   $0x15c
  803888:	68 77 47 80 00       	push   $0x804777
  80388d:	e8 95 d1 ff ff       	call   800a27 <_panic>
  803892:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803895:	8b 00                	mov    (%eax),%eax
  803897:	85 c0                	test   %eax,%eax
  803899:	74 10                	je     8038ab <insert_sorted_with_merge_freeList+0x3b5>
  80389b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389e:	8b 00                	mov    (%eax),%eax
  8038a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038a3:	8b 52 04             	mov    0x4(%edx),%edx
  8038a6:	89 50 04             	mov    %edx,0x4(%eax)
  8038a9:	eb 0b                	jmp    8038b6 <insert_sorted_with_merge_freeList+0x3c0>
  8038ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ae:	8b 40 04             	mov    0x4(%eax),%eax
  8038b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b9:	8b 40 04             	mov    0x4(%eax),%eax
  8038bc:	85 c0                	test   %eax,%eax
  8038be:	74 0f                	je     8038cf <insert_sorted_with_merge_freeList+0x3d9>
  8038c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c3:	8b 40 04             	mov    0x4(%eax),%eax
  8038c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038c9:	8b 12                	mov    (%edx),%edx
  8038cb:	89 10                	mov    %edx,(%eax)
  8038cd:	eb 0a                	jmp    8038d9 <insert_sorted_with_merge_freeList+0x3e3>
  8038cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d2:	8b 00                	mov    (%eax),%eax
  8038d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8038d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8038f1:	48                   	dec    %eax
  8038f2:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8038f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038fa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803901:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803904:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80390b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80390f:	75 17                	jne    803928 <insert_sorted_with_merge_freeList+0x432>
  803911:	83 ec 04             	sub    $0x4,%esp
  803914:	68 54 47 80 00       	push   $0x804754
  803919:	68 5f 01 00 00       	push   $0x15f
  80391e:	68 77 47 80 00       	push   $0x804777
  803923:	e8 ff d0 ff ff       	call   800a27 <_panic>
  803928:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80392e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803931:	89 10                	mov    %edx,(%eax)
  803933:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803936:	8b 00                	mov    (%eax),%eax
  803938:	85 c0                	test   %eax,%eax
  80393a:	74 0d                	je     803949 <insert_sorted_with_merge_freeList+0x453>
  80393c:	a1 48 51 80 00       	mov    0x805148,%eax
  803941:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803944:	89 50 04             	mov    %edx,0x4(%eax)
  803947:	eb 08                	jmp    803951 <insert_sorted_with_merge_freeList+0x45b>
  803949:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80394c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803951:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803954:	a3 48 51 80 00       	mov    %eax,0x805148
  803959:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80395c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803963:	a1 54 51 80 00       	mov    0x805154,%eax
  803968:	40                   	inc    %eax
  803969:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80396e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803971:	8b 50 0c             	mov    0xc(%eax),%edx
  803974:	8b 45 08             	mov    0x8(%ebp),%eax
  803977:	8b 40 0c             	mov    0xc(%eax),%eax
  80397a:	01 c2                	add    %eax,%edx
  80397c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397f:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803982:	8b 45 08             	mov    0x8(%ebp),%eax
  803985:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80398c:	8b 45 08             	mov    0x8(%ebp),%eax
  80398f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803996:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80399a:	75 17                	jne    8039b3 <insert_sorted_with_merge_freeList+0x4bd>
  80399c:	83 ec 04             	sub    $0x4,%esp
  80399f:	68 54 47 80 00       	push   $0x804754
  8039a4:	68 64 01 00 00       	push   $0x164
  8039a9:	68 77 47 80 00       	push   $0x804777
  8039ae:	e8 74 d0 ff ff       	call   800a27 <_panic>
  8039b3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bc:	89 10                	mov    %edx,(%eax)
  8039be:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c1:	8b 00                	mov    (%eax),%eax
  8039c3:	85 c0                	test   %eax,%eax
  8039c5:	74 0d                	je     8039d4 <insert_sorted_with_merge_freeList+0x4de>
  8039c7:	a1 48 51 80 00       	mov    0x805148,%eax
  8039cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8039cf:	89 50 04             	mov    %edx,0x4(%eax)
  8039d2:	eb 08                	jmp    8039dc <insert_sorted_with_merge_freeList+0x4e6>
  8039d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039df:	a3 48 51 80 00       	mov    %eax,0x805148
  8039e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ee:	a1 54 51 80 00       	mov    0x805154,%eax
  8039f3:	40                   	inc    %eax
  8039f4:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8039f9:	e9 41 02 00 00       	jmp    803c3f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8039fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803a01:	8b 50 08             	mov    0x8(%eax),%edx
  803a04:	8b 45 08             	mov    0x8(%ebp),%eax
  803a07:	8b 40 0c             	mov    0xc(%eax),%eax
  803a0a:	01 c2                	add    %eax,%edx
  803a0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0f:	8b 40 08             	mov    0x8(%eax),%eax
  803a12:	39 c2                	cmp    %eax,%edx
  803a14:	0f 85 7c 01 00 00    	jne    803b96 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803a1a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a1e:	74 06                	je     803a26 <insert_sorted_with_merge_freeList+0x530>
  803a20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a24:	75 17                	jne    803a3d <insert_sorted_with_merge_freeList+0x547>
  803a26:	83 ec 04             	sub    $0x4,%esp
  803a29:	68 90 47 80 00       	push   $0x804790
  803a2e:	68 69 01 00 00       	push   $0x169
  803a33:	68 77 47 80 00       	push   $0x804777
  803a38:	e8 ea cf ff ff       	call   800a27 <_panic>
  803a3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a40:	8b 50 04             	mov    0x4(%eax),%edx
  803a43:	8b 45 08             	mov    0x8(%ebp),%eax
  803a46:	89 50 04             	mov    %edx,0x4(%eax)
  803a49:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a4f:	89 10                	mov    %edx,(%eax)
  803a51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a54:	8b 40 04             	mov    0x4(%eax),%eax
  803a57:	85 c0                	test   %eax,%eax
  803a59:	74 0d                	je     803a68 <insert_sorted_with_merge_freeList+0x572>
  803a5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a5e:	8b 40 04             	mov    0x4(%eax),%eax
  803a61:	8b 55 08             	mov    0x8(%ebp),%edx
  803a64:	89 10                	mov    %edx,(%eax)
  803a66:	eb 08                	jmp    803a70 <insert_sorted_with_merge_freeList+0x57a>
  803a68:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6b:	a3 38 51 80 00       	mov    %eax,0x805138
  803a70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a73:	8b 55 08             	mov    0x8(%ebp),%edx
  803a76:	89 50 04             	mov    %edx,0x4(%eax)
  803a79:	a1 44 51 80 00       	mov    0x805144,%eax
  803a7e:	40                   	inc    %eax
  803a7f:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803a84:	8b 45 08             	mov    0x8(%ebp),%eax
  803a87:	8b 50 0c             	mov    0xc(%eax),%edx
  803a8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a8d:	8b 40 0c             	mov    0xc(%eax),%eax
  803a90:	01 c2                	add    %eax,%edx
  803a92:	8b 45 08             	mov    0x8(%ebp),%eax
  803a95:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803a98:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a9c:	75 17                	jne    803ab5 <insert_sorted_with_merge_freeList+0x5bf>
  803a9e:	83 ec 04             	sub    $0x4,%esp
  803aa1:	68 20 48 80 00       	push   $0x804820
  803aa6:	68 6b 01 00 00       	push   $0x16b
  803aab:	68 77 47 80 00       	push   $0x804777
  803ab0:	e8 72 cf ff ff       	call   800a27 <_panic>
  803ab5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab8:	8b 00                	mov    (%eax),%eax
  803aba:	85 c0                	test   %eax,%eax
  803abc:	74 10                	je     803ace <insert_sorted_with_merge_freeList+0x5d8>
  803abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac1:	8b 00                	mov    (%eax),%eax
  803ac3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ac6:	8b 52 04             	mov    0x4(%edx),%edx
  803ac9:	89 50 04             	mov    %edx,0x4(%eax)
  803acc:	eb 0b                	jmp    803ad9 <insert_sorted_with_merge_freeList+0x5e3>
  803ace:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ad1:	8b 40 04             	mov    0x4(%eax),%eax
  803ad4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ad9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803adc:	8b 40 04             	mov    0x4(%eax),%eax
  803adf:	85 c0                	test   %eax,%eax
  803ae1:	74 0f                	je     803af2 <insert_sorted_with_merge_freeList+0x5fc>
  803ae3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae6:	8b 40 04             	mov    0x4(%eax),%eax
  803ae9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803aec:	8b 12                	mov    (%edx),%edx
  803aee:	89 10                	mov    %edx,(%eax)
  803af0:	eb 0a                	jmp    803afc <insert_sorted_with_merge_freeList+0x606>
  803af2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803af5:	8b 00                	mov    (%eax),%eax
  803af7:	a3 38 51 80 00       	mov    %eax,0x805138
  803afc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b0f:	a1 44 51 80 00       	mov    0x805144,%eax
  803b14:	48                   	dec    %eax
  803b15:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803b1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b1d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b27:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803b2e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b32:	75 17                	jne    803b4b <insert_sorted_with_merge_freeList+0x655>
  803b34:	83 ec 04             	sub    $0x4,%esp
  803b37:	68 54 47 80 00       	push   $0x804754
  803b3c:	68 6e 01 00 00       	push   $0x16e
  803b41:	68 77 47 80 00       	push   $0x804777
  803b46:	e8 dc ce ff ff       	call   800a27 <_panic>
  803b4b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b54:	89 10                	mov    %edx,(%eax)
  803b56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b59:	8b 00                	mov    (%eax),%eax
  803b5b:	85 c0                	test   %eax,%eax
  803b5d:	74 0d                	je     803b6c <insert_sorted_with_merge_freeList+0x676>
  803b5f:	a1 48 51 80 00       	mov    0x805148,%eax
  803b64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b67:	89 50 04             	mov    %edx,0x4(%eax)
  803b6a:	eb 08                	jmp    803b74 <insert_sorted_with_merge_freeList+0x67e>
  803b6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b6f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b77:	a3 48 51 80 00       	mov    %eax,0x805148
  803b7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b86:	a1 54 51 80 00       	mov    0x805154,%eax
  803b8b:	40                   	inc    %eax
  803b8c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803b91:	e9 a9 00 00 00       	jmp    803c3f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803b96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b9a:	74 06                	je     803ba2 <insert_sorted_with_merge_freeList+0x6ac>
  803b9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ba0:	75 17                	jne    803bb9 <insert_sorted_with_merge_freeList+0x6c3>
  803ba2:	83 ec 04             	sub    $0x4,%esp
  803ba5:	68 ec 47 80 00       	push   $0x8047ec
  803baa:	68 73 01 00 00       	push   $0x173
  803baf:	68 77 47 80 00       	push   $0x804777
  803bb4:	e8 6e ce ff ff       	call   800a27 <_panic>
  803bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bbc:	8b 10                	mov    (%eax),%edx
  803bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc1:	89 10                	mov    %edx,(%eax)
  803bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc6:	8b 00                	mov    (%eax),%eax
  803bc8:	85 c0                	test   %eax,%eax
  803bca:	74 0b                	je     803bd7 <insert_sorted_with_merge_freeList+0x6e1>
  803bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bcf:	8b 00                	mov    (%eax),%eax
  803bd1:	8b 55 08             	mov    0x8(%ebp),%edx
  803bd4:	89 50 04             	mov    %edx,0x4(%eax)
  803bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bda:	8b 55 08             	mov    0x8(%ebp),%edx
  803bdd:	89 10                	mov    %edx,(%eax)
  803bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  803be2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803be5:	89 50 04             	mov    %edx,0x4(%eax)
  803be8:	8b 45 08             	mov    0x8(%ebp),%eax
  803beb:	8b 00                	mov    (%eax),%eax
  803bed:	85 c0                	test   %eax,%eax
  803bef:	75 08                	jne    803bf9 <insert_sorted_with_merge_freeList+0x703>
  803bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bf9:	a1 44 51 80 00       	mov    0x805144,%eax
  803bfe:	40                   	inc    %eax
  803bff:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803c04:	eb 39                	jmp    803c3f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803c06:	a1 40 51 80 00       	mov    0x805140,%eax
  803c0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c12:	74 07                	je     803c1b <insert_sorted_with_merge_freeList+0x725>
  803c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c17:	8b 00                	mov    (%eax),%eax
  803c19:	eb 05                	jmp    803c20 <insert_sorted_with_merge_freeList+0x72a>
  803c1b:	b8 00 00 00 00       	mov    $0x0,%eax
  803c20:	a3 40 51 80 00       	mov    %eax,0x805140
  803c25:	a1 40 51 80 00       	mov    0x805140,%eax
  803c2a:	85 c0                	test   %eax,%eax
  803c2c:	0f 85 c7 fb ff ff    	jne    8037f9 <insert_sorted_with_merge_freeList+0x303>
  803c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c36:	0f 85 bd fb ff ff    	jne    8037f9 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803c3c:	eb 01                	jmp    803c3f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803c3e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803c3f:	90                   	nop
  803c40:	c9                   	leave  
  803c41:	c3                   	ret    
  803c42:	66 90                	xchg   %ax,%ax

00803c44 <__udivdi3>:
  803c44:	55                   	push   %ebp
  803c45:	57                   	push   %edi
  803c46:	56                   	push   %esi
  803c47:	53                   	push   %ebx
  803c48:	83 ec 1c             	sub    $0x1c,%esp
  803c4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c5b:	89 ca                	mov    %ecx,%edx
  803c5d:	89 f8                	mov    %edi,%eax
  803c5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c63:	85 f6                	test   %esi,%esi
  803c65:	75 2d                	jne    803c94 <__udivdi3+0x50>
  803c67:	39 cf                	cmp    %ecx,%edi
  803c69:	77 65                	ja     803cd0 <__udivdi3+0x8c>
  803c6b:	89 fd                	mov    %edi,%ebp
  803c6d:	85 ff                	test   %edi,%edi
  803c6f:	75 0b                	jne    803c7c <__udivdi3+0x38>
  803c71:	b8 01 00 00 00       	mov    $0x1,%eax
  803c76:	31 d2                	xor    %edx,%edx
  803c78:	f7 f7                	div    %edi
  803c7a:	89 c5                	mov    %eax,%ebp
  803c7c:	31 d2                	xor    %edx,%edx
  803c7e:	89 c8                	mov    %ecx,%eax
  803c80:	f7 f5                	div    %ebp
  803c82:	89 c1                	mov    %eax,%ecx
  803c84:	89 d8                	mov    %ebx,%eax
  803c86:	f7 f5                	div    %ebp
  803c88:	89 cf                	mov    %ecx,%edi
  803c8a:	89 fa                	mov    %edi,%edx
  803c8c:	83 c4 1c             	add    $0x1c,%esp
  803c8f:	5b                   	pop    %ebx
  803c90:	5e                   	pop    %esi
  803c91:	5f                   	pop    %edi
  803c92:	5d                   	pop    %ebp
  803c93:	c3                   	ret    
  803c94:	39 ce                	cmp    %ecx,%esi
  803c96:	77 28                	ja     803cc0 <__udivdi3+0x7c>
  803c98:	0f bd fe             	bsr    %esi,%edi
  803c9b:	83 f7 1f             	xor    $0x1f,%edi
  803c9e:	75 40                	jne    803ce0 <__udivdi3+0x9c>
  803ca0:	39 ce                	cmp    %ecx,%esi
  803ca2:	72 0a                	jb     803cae <__udivdi3+0x6a>
  803ca4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ca8:	0f 87 9e 00 00 00    	ja     803d4c <__udivdi3+0x108>
  803cae:	b8 01 00 00 00       	mov    $0x1,%eax
  803cb3:	89 fa                	mov    %edi,%edx
  803cb5:	83 c4 1c             	add    $0x1c,%esp
  803cb8:	5b                   	pop    %ebx
  803cb9:	5e                   	pop    %esi
  803cba:	5f                   	pop    %edi
  803cbb:	5d                   	pop    %ebp
  803cbc:	c3                   	ret    
  803cbd:	8d 76 00             	lea    0x0(%esi),%esi
  803cc0:	31 ff                	xor    %edi,%edi
  803cc2:	31 c0                	xor    %eax,%eax
  803cc4:	89 fa                	mov    %edi,%edx
  803cc6:	83 c4 1c             	add    $0x1c,%esp
  803cc9:	5b                   	pop    %ebx
  803cca:	5e                   	pop    %esi
  803ccb:	5f                   	pop    %edi
  803ccc:	5d                   	pop    %ebp
  803ccd:	c3                   	ret    
  803cce:	66 90                	xchg   %ax,%ax
  803cd0:	89 d8                	mov    %ebx,%eax
  803cd2:	f7 f7                	div    %edi
  803cd4:	31 ff                	xor    %edi,%edi
  803cd6:	89 fa                	mov    %edi,%edx
  803cd8:	83 c4 1c             	add    $0x1c,%esp
  803cdb:	5b                   	pop    %ebx
  803cdc:	5e                   	pop    %esi
  803cdd:	5f                   	pop    %edi
  803cde:	5d                   	pop    %ebp
  803cdf:	c3                   	ret    
  803ce0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ce5:	89 eb                	mov    %ebp,%ebx
  803ce7:	29 fb                	sub    %edi,%ebx
  803ce9:	89 f9                	mov    %edi,%ecx
  803ceb:	d3 e6                	shl    %cl,%esi
  803ced:	89 c5                	mov    %eax,%ebp
  803cef:	88 d9                	mov    %bl,%cl
  803cf1:	d3 ed                	shr    %cl,%ebp
  803cf3:	89 e9                	mov    %ebp,%ecx
  803cf5:	09 f1                	or     %esi,%ecx
  803cf7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803cfb:	89 f9                	mov    %edi,%ecx
  803cfd:	d3 e0                	shl    %cl,%eax
  803cff:	89 c5                	mov    %eax,%ebp
  803d01:	89 d6                	mov    %edx,%esi
  803d03:	88 d9                	mov    %bl,%cl
  803d05:	d3 ee                	shr    %cl,%esi
  803d07:	89 f9                	mov    %edi,%ecx
  803d09:	d3 e2                	shl    %cl,%edx
  803d0b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d0f:	88 d9                	mov    %bl,%cl
  803d11:	d3 e8                	shr    %cl,%eax
  803d13:	09 c2                	or     %eax,%edx
  803d15:	89 d0                	mov    %edx,%eax
  803d17:	89 f2                	mov    %esi,%edx
  803d19:	f7 74 24 0c          	divl   0xc(%esp)
  803d1d:	89 d6                	mov    %edx,%esi
  803d1f:	89 c3                	mov    %eax,%ebx
  803d21:	f7 e5                	mul    %ebp
  803d23:	39 d6                	cmp    %edx,%esi
  803d25:	72 19                	jb     803d40 <__udivdi3+0xfc>
  803d27:	74 0b                	je     803d34 <__udivdi3+0xf0>
  803d29:	89 d8                	mov    %ebx,%eax
  803d2b:	31 ff                	xor    %edi,%edi
  803d2d:	e9 58 ff ff ff       	jmp    803c8a <__udivdi3+0x46>
  803d32:	66 90                	xchg   %ax,%ax
  803d34:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d38:	89 f9                	mov    %edi,%ecx
  803d3a:	d3 e2                	shl    %cl,%edx
  803d3c:	39 c2                	cmp    %eax,%edx
  803d3e:	73 e9                	jae    803d29 <__udivdi3+0xe5>
  803d40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d43:	31 ff                	xor    %edi,%edi
  803d45:	e9 40 ff ff ff       	jmp    803c8a <__udivdi3+0x46>
  803d4a:	66 90                	xchg   %ax,%ax
  803d4c:	31 c0                	xor    %eax,%eax
  803d4e:	e9 37 ff ff ff       	jmp    803c8a <__udivdi3+0x46>
  803d53:	90                   	nop

00803d54 <__umoddi3>:
  803d54:	55                   	push   %ebp
  803d55:	57                   	push   %edi
  803d56:	56                   	push   %esi
  803d57:	53                   	push   %ebx
  803d58:	83 ec 1c             	sub    $0x1c,%esp
  803d5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d73:	89 f3                	mov    %esi,%ebx
  803d75:	89 fa                	mov    %edi,%edx
  803d77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d7b:	89 34 24             	mov    %esi,(%esp)
  803d7e:	85 c0                	test   %eax,%eax
  803d80:	75 1a                	jne    803d9c <__umoddi3+0x48>
  803d82:	39 f7                	cmp    %esi,%edi
  803d84:	0f 86 a2 00 00 00    	jbe    803e2c <__umoddi3+0xd8>
  803d8a:	89 c8                	mov    %ecx,%eax
  803d8c:	89 f2                	mov    %esi,%edx
  803d8e:	f7 f7                	div    %edi
  803d90:	89 d0                	mov    %edx,%eax
  803d92:	31 d2                	xor    %edx,%edx
  803d94:	83 c4 1c             	add    $0x1c,%esp
  803d97:	5b                   	pop    %ebx
  803d98:	5e                   	pop    %esi
  803d99:	5f                   	pop    %edi
  803d9a:	5d                   	pop    %ebp
  803d9b:	c3                   	ret    
  803d9c:	39 f0                	cmp    %esi,%eax
  803d9e:	0f 87 ac 00 00 00    	ja     803e50 <__umoddi3+0xfc>
  803da4:	0f bd e8             	bsr    %eax,%ebp
  803da7:	83 f5 1f             	xor    $0x1f,%ebp
  803daa:	0f 84 ac 00 00 00    	je     803e5c <__umoddi3+0x108>
  803db0:	bf 20 00 00 00       	mov    $0x20,%edi
  803db5:	29 ef                	sub    %ebp,%edi
  803db7:	89 fe                	mov    %edi,%esi
  803db9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803dbd:	89 e9                	mov    %ebp,%ecx
  803dbf:	d3 e0                	shl    %cl,%eax
  803dc1:	89 d7                	mov    %edx,%edi
  803dc3:	89 f1                	mov    %esi,%ecx
  803dc5:	d3 ef                	shr    %cl,%edi
  803dc7:	09 c7                	or     %eax,%edi
  803dc9:	89 e9                	mov    %ebp,%ecx
  803dcb:	d3 e2                	shl    %cl,%edx
  803dcd:	89 14 24             	mov    %edx,(%esp)
  803dd0:	89 d8                	mov    %ebx,%eax
  803dd2:	d3 e0                	shl    %cl,%eax
  803dd4:	89 c2                	mov    %eax,%edx
  803dd6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dda:	d3 e0                	shl    %cl,%eax
  803ddc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803de0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803de4:	89 f1                	mov    %esi,%ecx
  803de6:	d3 e8                	shr    %cl,%eax
  803de8:	09 d0                	or     %edx,%eax
  803dea:	d3 eb                	shr    %cl,%ebx
  803dec:	89 da                	mov    %ebx,%edx
  803dee:	f7 f7                	div    %edi
  803df0:	89 d3                	mov    %edx,%ebx
  803df2:	f7 24 24             	mull   (%esp)
  803df5:	89 c6                	mov    %eax,%esi
  803df7:	89 d1                	mov    %edx,%ecx
  803df9:	39 d3                	cmp    %edx,%ebx
  803dfb:	0f 82 87 00 00 00    	jb     803e88 <__umoddi3+0x134>
  803e01:	0f 84 91 00 00 00    	je     803e98 <__umoddi3+0x144>
  803e07:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e0b:	29 f2                	sub    %esi,%edx
  803e0d:	19 cb                	sbb    %ecx,%ebx
  803e0f:	89 d8                	mov    %ebx,%eax
  803e11:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e15:	d3 e0                	shl    %cl,%eax
  803e17:	89 e9                	mov    %ebp,%ecx
  803e19:	d3 ea                	shr    %cl,%edx
  803e1b:	09 d0                	or     %edx,%eax
  803e1d:	89 e9                	mov    %ebp,%ecx
  803e1f:	d3 eb                	shr    %cl,%ebx
  803e21:	89 da                	mov    %ebx,%edx
  803e23:	83 c4 1c             	add    $0x1c,%esp
  803e26:	5b                   	pop    %ebx
  803e27:	5e                   	pop    %esi
  803e28:	5f                   	pop    %edi
  803e29:	5d                   	pop    %ebp
  803e2a:	c3                   	ret    
  803e2b:	90                   	nop
  803e2c:	89 fd                	mov    %edi,%ebp
  803e2e:	85 ff                	test   %edi,%edi
  803e30:	75 0b                	jne    803e3d <__umoddi3+0xe9>
  803e32:	b8 01 00 00 00       	mov    $0x1,%eax
  803e37:	31 d2                	xor    %edx,%edx
  803e39:	f7 f7                	div    %edi
  803e3b:	89 c5                	mov    %eax,%ebp
  803e3d:	89 f0                	mov    %esi,%eax
  803e3f:	31 d2                	xor    %edx,%edx
  803e41:	f7 f5                	div    %ebp
  803e43:	89 c8                	mov    %ecx,%eax
  803e45:	f7 f5                	div    %ebp
  803e47:	89 d0                	mov    %edx,%eax
  803e49:	e9 44 ff ff ff       	jmp    803d92 <__umoddi3+0x3e>
  803e4e:	66 90                	xchg   %ax,%ax
  803e50:	89 c8                	mov    %ecx,%eax
  803e52:	89 f2                	mov    %esi,%edx
  803e54:	83 c4 1c             	add    $0x1c,%esp
  803e57:	5b                   	pop    %ebx
  803e58:	5e                   	pop    %esi
  803e59:	5f                   	pop    %edi
  803e5a:	5d                   	pop    %ebp
  803e5b:	c3                   	ret    
  803e5c:	3b 04 24             	cmp    (%esp),%eax
  803e5f:	72 06                	jb     803e67 <__umoddi3+0x113>
  803e61:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e65:	77 0f                	ja     803e76 <__umoddi3+0x122>
  803e67:	89 f2                	mov    %esi,%edx
  803e69:	29 f9                	sub    %edi,%ecx
  803e6b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e6f:	89 14 24             	mov    %edx,(%esp)
  803e72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e76:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e7a:	8b 14 24             	mov    (%esp),%edx
  803e7d:	83 c4 1c             	add    $0x1c,%esp
  803e80:	5b                   	pop    %ebx
  803e81:	5e                   	pop    %esi
  803e82:	5f                   	pop    %edi
  803e83:	5d                   	pop    %ebp
  803e84:	c3                   	ret    
  803e85:	8d 76 00             	lea    0x0(%esi),%esi
  803e88:	2b 04 24             	sub    (%esp),%eax
  803e8b:	19 fa                	sbb    %edi,%edx
  803e8d:	89 d1                	mov    %edx,%ecx
  803e8f:	89 c6                	mov    %eax,%esi
  803e91:	e9 71 ff ff ff       	jmp    803e07 <__umoddi3+0xb3>
  803e96:	66 90                	xchg   %ax,%ax
  803e98:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e9c:	72 ea                	jb     803e88 <__umoddi3+0x134>
  803e9e:	89 d9                	mov    %ebx,%ecx
  803ea0:	e9 62 ff ff ff       	jmp    803e07 <__umoddi3+0xb3>
