
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
  800045:	e8 4e 23 00 00       	call   802398 <sys_set_uheap_strategy>
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
  80009b:	68 c0 3c 80 00       	push   $0x803cc0
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 dc 3c 80 00       	push   $0x803cdc
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
  8000f5:	68 f4 3c 80 00       	push   $0x803cf4
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 dc 3c 80 00       	push   $0x803cdc
  800101:	e8 21 09 00 00       	call   800a27 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 78 1d 00 00       	call   801e83 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 10 1e 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  80013a:	68 38 3d 80 00       	push   $0x803d38
  80013f:	6a 31                	push   $0x31
  800141:	68 dc 3c 80 00       	push   $0x803cdc
  800146:	e8 dc 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80014b:	e8 d3 1d 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  800150:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800153:	3d 00 02 00 00       	cmp    $0x200,%eax
  800158:	74 14                	je     80016e <_main+0x136>
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	68 68 3d 80 00       	push   $0x803d68
  800162:	6a 33                	push   $0x33
  800164:	68 dc 3c 80 00       	push   $0x803cdc
  800169:	e8 b9 08 00 00       	call   800a27 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80016e:	e8 10 1d 00 00       	call   801e83 <sys_calculate_free_frames>
  800173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800176:	e8 a8 1d 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  8001ab:	68 38 3d 80 00       	push   $0x803d38
  8001b0:	6a 39                	push   $0x39
  8001b2:	68 dc 3c 80 00       	push   $0x803cdc
  8001b7:	e8 6b 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001bc:	e8 62 1d 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  8001c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 68 3d 80 00       	push   $0x803d68
  8001d3:	6a 3b                	push   $0x3b
  8001d5:	68 dc 3c 80 00       	push   $0x803cdc
  8001da:	e8 48 08 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 9f 1c 00 00       	call   801e83 <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 37 1d 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  80021a:	68 38 3d 80 00       	push   $0x803d38
  80021f:	6a 41                	push   $0x41
  800221:	68 dc 3c 80 00       	push   $0x803cdc
  800226:	e8 fc 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80022b:	e8 f3 1c 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  800230:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800233:	83 f8 01             	cmp    $0x1,%eax
  800236:	74 14                	je     80024c <_main+0x214>
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 68 3d 80 00       	push   $0x803d68
  800240:	6a 43                	push   $0x43
  800242:	68 dc 3c 80 00       	push   $0x803cdc
  800247:	e8 db 07 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80024c:	e8 32 1c 00 00       	call   801e83 <sys_calculate_free_frames>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800254:	e8 ca 1c 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  800291:	68 38 3d 80 00       	push   $0x803d38
  800296:	6a 49                	push   $0x49
  800298:	68 dc 3c 80 00       	push   $0x803cdc
  80029d:	e8 85 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002a2:	e8 7c 1c 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  8002a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002aa:	83 f8 01             	cmp    $0x1,%eax
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 68 3d 80 00       	push   $0x803d68
  8002b7:	6a 4b                	push   $0x4b
  8002b9:	68 dc 3c 80 00       	push   $0x803cdc
  8002be:	e8 64 07 00 00       	call   800a27 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002c3:	e8 bb 1b 00 00       	call   801e83 <sys_calculate_free_frames>
  8002c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cb:	e8 53 1c 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  8002d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 b2 19 00 00       	call   801c91 <free>
  8002df:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002e2:	e8 3c 1c 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  8002e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ea:	29 c2                	sub    %eax,%edx
  8002ec:	89 d0                	mov    %edx,%eax
  8002ee:	83 f8 01             	cmp    $0x1,%eax
  8002f1:	74 14                	je     800307 <_main+0x2cf>
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	68 85 3d 80 00       	push   $0x803d85
  8002fb:	6a 52                	push   $0x52
  8002fd:	68 dc 3c 80 00       	push   $0x803cdc
  800302:	e8 20 07 00 00       	call   800a27 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  800307:	e8 77 1b 00 00       	call   801e83 <sys_calculate_free_frames>
  80030c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80030f:	e8 0f 1c 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  800354:	68 38 3d 80 00       	push   $0x803d38
  800359:	6a 58                	push   $0x58
  80035b:	68 dc 3c 80 00       	push   $0x803cdc
  800360:	e8 c2 06 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800365:	e8 b9 1b 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  80036a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80036d:	83 f8 02             	cmp    $0x2,%eax
  800370:	74 14                	je     800386 <_main+0x34e>
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 68 3d 80 00       	push   $0x803d68
  80037a:	6a 5a                	push   $0x5a
  80037c:	68 dc 3c 80 00       	push   $0x803cdc
  800381:	e8 a1 06 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800386:	e8 f8 1a 00 00       	call   801e83 <sys_calculate_free_frames>
  80038b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80038e:	e8 90 1b 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  800393:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800396:	8b 45 90             	mov    -0x70(%ebp),%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	50                   	push   %eax
  80039d:	e8 ef 18 00 00       	call   801c91 <free>
  8003a2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003a5:	e8 79 1b 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	29 c2                	sub    %eax,%edx
  8003af:	89 d0                	mov    %edx,%eax
  8003b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003b6:	74 14                	je     8003cc <_main+0x394>
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	68 85 3d 80 00       	push   $0x803d85
  8003c0:	6a 61                	push   $0x61
  8003c2:	68 dc 3c 80 00       	push   $0x803cdc
  8003c7:	e8 5b 06 00 00       	call   800a27 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cc:	e8 b2 1a 00 00       	call   801e83 <sys_calculate_free_frames>
  8003d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d4:	e8 4a 1b 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  800418:	68 38 3d 80 00       	push   $0x803d38
  80041d:	6a 67                	push   $0x67
  80041f:	68 dc 3c 80 00       	push   $0x803cdc
  800424:	e8 fe 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800429:	e8 f5 1a 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  80044f:	68 68 3d 80 00       	push   $0x803d68
  800454:	6a 69                	push   $0x69
  800456:	68 dc 3c 80 00       	push   $0x803cdc
  80045b:	e8 c7 05 00 00       	call   800a27 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800460:	e8 1e 1a 00 00       	call   801e83 <sys_calculate_free_frames>
  800465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800468:	e8 b6 1a 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  8004b7:	68 38 3d 80 00       	push   $0x803d38
  8004bc:	6a 6f                	push   $0x6f
  8004be:	68 dc 3c 80 00       	push   $0x803cdc
  8004c3:	e8 5f 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004c8:	e8 56 1a 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  8004cd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004d0:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004d5:	74 14                	je     8004eb <_main+0x4b3>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 68 3d 80 00       	push   $0x803d68
  8004df:	6a 71                	push   $0x71
  8004e1:	68 dc 3c 80 00       	push   $0x803cdc
  8004e6:	e8 3c 05 00 00       	call   800a27 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004eb:	e8 93 19 00 00       	call   801e83 <sys_calculate_free_frames>
  8004f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f3:	e8 2b 1a 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  800542:	68 38 3d 80 00       	push   $0x803d38
  800547:	6a 77                	push   $0x77
  800549:	68 dc 3c 80 00       	push   $0x803cdc
  80054e:	e8 d4 04 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  800553:	e8 cb 19 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  80057a:	68 68 3d 80 00       	push   $0x803d68
  80057f:	6a 79                	push   $0x79
  800581:	68 dc 3c 80 00       	push   $0x803cdc
  800586:	e8 9c 04 00 00       	call   800a27 <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80058b:	e8 f3 18 00 00       	call   801e83 <sys_calculate_free_frames>
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800593:	e8 8b 19 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80059b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 ea 16 00 00       	call   801c91 <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  8005aa:	e8 74 19 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	29 c2                	sub    %eax,%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	3d 02 02 00 00       	cmp    $0x202,%eax
  8005bb:	74 17                	je     8005d4 <_main+0x59c>
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 85 3d 80 00       	push   $0x803d85
  8005c5:	68 80 00 00 00       	push   $0x80
  8005ca:	68 dc 3c 80 00       	push   $0x803cdc
  8005cf:	e8 53 04 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d4:	e8 aa 18 00 00       	call   801e83 <sys_calculate_free_frames>
  8005d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005dc:	e8 42 19 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005e4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	50                   	push   %eax
  8005eb:	e8 a1 16 00 00       	call   801c91 <free>
  8005f0:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8005f3:	e8 2b 19 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  8005f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fb:	29 c2                	sub    %eax,%edx
  8005fd:	89 d0                	mov    %edx,%eax
  8005ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  800604:	74 17                	je     80061d <_main+0x5e5>
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	68 85 3d 80 00       	push   $0x803d85
  80060e:	68 87 00 00 00       	push   $0x87
  800613:	68 dc 3c 80 00       	push   $0x803cdc
  800618:	e8 0a 04 00 00       	call   800a27 <_panic>

		//2 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  80061d:	e8 61 18 00 00       	call   801e83 <sys_calculate_free_frames>
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800625:	e8 f9 18 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  80066c:	68 38 3d 80 00       	push   $0x803d38
  800671:	68 8d 00 00 00       	push   $0x8d
  800676:	68 dc 3c 80 00       	push   $0x803cdc
  80067b:	e8 a7 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800680:	e8 9e 18 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  800685:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800688:	3d 00 02 00 00       	cmp    $0x200,%eax
  80068d:	74 17                	je     8006a6 <_main+0x66e>
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 68 3d 80 00       	push   $0x803d68
  800697:	68 8f 00 00 00       	push   $0x8f
  80069c:	68 dc 3c 80 00       	push   $0x803cdc
  8006a1:	e8 81 03 00 00       	call   800a27 <_panic>

		//6 KB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  8006a6:	e8 d8 17 00 00       	call   801e83 <sys_calculate_free_frames>
  8006ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ae:	e8 70 18 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  8006f5:	68 38 3d 80 00       	push   $0x803d38
  8006fa:	68 95 00 00 00       	push   $0x95
  8006ff:	68 dc 3c 80 00       	push   $0x803cdc
  800704:	e8 1e 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800709:	e8 15 18 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  80070e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800711:	83 f8 02             	cmp    $0x2,%eax
  800714:	74 17                	je     80072d <_main+0x6f5>
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	68 68 3d 80 00       	push   $0x803d68
  80071e:	68 97 00 00 00       	push   $0x97
  800723:	68 dc 3c 80 00       	push   $0x803cdc
  800728:	e8 fa 02 00 00       	call   800a27 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80072d:	e8 51 17 00 00       	call   801e83 <sys_calculate_free_frames>
  800732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800735:	e8 e9 17 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  80073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80073d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 48 15 00 00       	call   801c91 <free>
  800749:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  80074c:	e8 d2 17 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
  800751:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800754:	29 c2                	sub    %eax,%edx
  800756:	89 d0                	mov    %edx,%eax
  800758:	3d 00 03 00 00       	cmp    $0x300,%eax
  80075d:	74 17                	je     800776 <_main+0x73e>
  80075f:	83 ec 04             	sub    $0x4,%esp
  800762:	68 85 3d 80 00       	push   $0x803d85
  800767:	68 9e 00 00 00       	push   $0x9e
  80076c:	68 dc 3c 80 00       	push   $0x803cdc
  800771:	e8 b1 02 00 00       	call   800a27 <_panic>

		//3 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800776:	e8 08 17 00 00       	call   801e83 <sys_calculate_free_frames>
  80077b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80077e:	e8 a0 17 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  8007c2:	68 38 3d 80 00       	push   $0x803d38
  8007c7:	68 a4 00 00 00       	push   $0xa4
  8007cc:	68 dc 3c 80 00       	push   $0x803cdc
  8007d1:	e8 51 02 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8007d6:	e8 48 17 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  8007fc:	68 68 3d 80 00       	push   $0x803d68
  800801:	68 a6 00 00 00       	push   $0xa6
  800806:	68 dc 3c 80 00       	push   $0x803cdc
  80080b:	e8 17 02 00 00       	call   800a27 <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800810:	e8 6e 16 00 00       	call   801e83 <sys_calculate_free_frames>
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800818:	e8 06 17 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  800845:	68 38 3d 80 00       	push   $0x803d38
  80084a:	68 ac 00 00 00       	push   $0xac
  80084f:	68 dc 3c 80 00       	push   $0x803cdc
  800854:	e8 ce 01 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800859:	e8 c5 16 00 00       	call   801f23 <sys_pf_calculate_allocated_pages>
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
  80087c:	68 68 3d 80 00       	push   $0x803d68
  800881:	68 ae 00 00 00       	push   $0xae
  800886:	68 dc 3c 80 00       	push   $0x803cdc
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
  8008bf:	68 9c 3d 80 00       	push   $0x803d9c
  8008c4:	68 b7 00 00 00       	push   $0xb7
  8008c9:	68 dc 3c 80 00       	push   $0x803cdc
  8008ce:	e8 54 01 00 00       	call   800a27 <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 00 3e 80 00       	push   $0x803e00
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
  8008f1:	e8 6d 18 00 00       	call   802163 <sys_getenvindex>
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
  80095c:	e8 0f 16 00 00       	call   801f70 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 60 3e 80 00       	push   $0x803e60
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
  80098c:	68 88 3e 80 00       	push   $0x803e88
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
  8009bd:	68 b0 3e 80 00       	push   $0x803eb0
  8009c2:	e8 14 03 00 00       	call   800cdb <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8009cf:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	50                   	push   %eax
  8009d9:	68 08 3f 80 00       	push   $0x803f08
  8009de:	e8 f8 02 00 00       	call   800cdb <cprintf>
  8009e3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009e6:	83 ec 0c             	sub    $0xc,%esp
  8009e9:	68 60 3e 80 00       	push   $0x803e60
  8009ee:	e8 e8 02 00 00       	call   800cdb <cprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009f6:	e8 8f 15 00 00       	call   801f8a <sys_enable_interrupt>

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
  800a0e:	e8 1c 17 00 00       	call   80212f <sys_destroy_env>
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
  800a1f:	e8 71 17 00 00       	call   802195 <sys_exit_env>
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
  800a48:	68 1c 3f 80 00       	push   $0x803f1c
  800a4d:	e8 89 02 00 00       	call   800cdb <cprintf>
  800a52:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a55:	a1 00 50 80 00       	mov    0x805000,%eax
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 08             	pushl  0x8(%ebp)
  800a60:	50                   	push   %eax
  800a61:	68 21 3f 80 00       	push   $0x803f21
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
  800a85:	68 3d 3f 80 00       	push   $0x803f3d
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
  800ab1:	68 40 3f 80 00       	push   $0x803f40
  800ab6:	6a 26                	push   $0x26
  800ab8:	68 8c 3f 80 00       	push   $0x803f8c
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
  800b83:	68 98 3f 80 00       	push   $0x803f98
  800b88:	6a 3a                	push   $0x3a
  800b8a:	68 8c 3f 80 00       	push   $0x803f8c
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
  800bf3:	68 ec 3f 80 00       	push   $0x803fec
  800bf8:	6a 44                	push   $0x44
  800bfa:	68 8c 3f 80 00       	push   $0x803f8c
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
  800c4d:	e8 70 11 00 00       	call   801dc2 <sys_cputs>
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
  800cc4:	e8 f9 10 00 00       	call   801dc2 <sys_cputs>
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
  800d0e:	e8 5d 12 00 00       	call   801f70 <sys_disable_interrupt>
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
  800d2e:	e8 57 12 00 00       	call   801f8a <sys_enable_interrupt>
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
  800d78:	e8 cb 2c 00 00       	call   803a48 <__udivdi3>
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
  800dc8:	e8 8b 2d 00 00       	call   803b58 <__umoddi3>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	05 54 42 80 00       	add    $0x804254,%eax
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
  800f23:	8b 04 85 78 42 80 00 	mov    0x804278(,%eax,4),%eax
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
  801004:	8b 34 9d c0 40 80 00 	mov    0x8040c0(,%ebx,4),%esi
  80100b:	85 f6                	test   %esi,%esi
  80100d:	75 19                	jne    801028 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80100f:	53                   	push   %ebx
  801010:	68 65 42 80 00       	push   $0x804265
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
  801029:	68 6e 42 80 00       	push   $0x80426e
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
  801056:	be 71 42 80 00       	mov    $0x804271,%esi
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
  801a7c:	68 d0 43 80 00       	push   $0x8043d0
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  801b2f:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801b36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b3e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b43:	83 ec 04             	sub    $0x4,%esp
  801b46:	6a 03                	push   $0x3
  801b48:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4b:	50                   	push   %eax
  801b4c:	e8 b5 03 00 00       	call   801f06 <sys_allocate_chunk>
  801b51:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801b54:	a1 20 51 80 00       	mov    0x805120,%eax
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	50                   	push   %eax
  801b5d:	e8 2a 0a 00 00       	call   80258c <initialize_MemBlocksList>
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
  801b8a:	68 f5 43 80 00       	push   $0x8043f5
  801b8f:	6a 33                	push   $0x33
  801b91:	68 13 44 80 00       	push   $0x804413
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
  801c09:	68 20 44 80 00       	push   $0x804420
  801c0e:	6a 34                	push   $0x34
  801c10:	68 13 44 80 00       	push   $0x804413
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
  801c7e:	68 44 44 80 00       	push   $0x804444
  801c83:	6a 46                	push   $0x46
  801c85:	68 13 44 80 00       	push   $0x804413
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
  801c9a:	68 6c 44 80 00       	push   $0x80446c
  801c9f:	6a 61                	push   $0x61
  801ca1:	68 13 44 80 00       	push   $0x804413
  801ca6:	e8 7c ed ff ff       	call   800a27 <_panic>

00801cab <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 18             	sub    $0x18,%esp
  801cb1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb4:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cb7:	e8 a9 fd ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cc0:	75 07                	jne    801cc9 <smalloc+0x1e>
  801cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc7:	eb 14                	jmp    801cdd <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801cc9:	83 ec 04             	sub    $0x4,%esp
  801ccc:	68 90 44 80 00       	push   $0x804490
  801cd1:	6a 76                	push   $0x76
  801cd3:	68 13 44 80 00       	push   $0x804413
  801cd8:	e8 4a ed ff ff       	call   800a27 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ce5:	e8 7b fd ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801cea:	83 ec 04             	sub    $0x4,%esp
  801ced:	68 b8 44 80 00       	push   $0x8044b8
  801cf2:	68 93 00 00 00       	push   $0x93
  801cf7:	68 13 44 80 00       	push   $0x804413
  801cfc:	e8 26 ed ff ff       	call   800a27 <_panic>

00801d01 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d07:	e8 59 fd ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d0c:	83 ec 04             	sub    $0x4,%esp
  801d0f:	68 dc 44 80 00       	push   $0x8044dc
  801d14:	68 c5 00 00 00       	push   $0xc5
  801d19:	68 13 44 80 00       	push   $0x804413
  801d1e:	e8 04 ed ff ff       	call   800a27 <_panic>

00801d23 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	68 04 45 80 00       	push   $0x804504
  801d31:	68 d9 00 00 00       	push   $0xd9
  801d36:	68 13 44 80 00       	push   $0x804413
  801d3b:	e8 e7 ec ff ff       	call   800a27 <_panic>

00801d40 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d46:	83 ec 04             	sub    $0x4,%esp
  801d49:	68 28 45 80 00       	push   $0x804528
  801d4e:	68 e4 00 00 00       	push   $0xe4
  801d53:	68 13 44 80 00       	push   $0x804413
  801d58:	e8 ca ec ff ff       	call   800a27 <_panic>

00801d5d <shrink>:

}
void shrink(uint32 newSize)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
  801d60:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d63:	83 ec 04             	sub    $0x4,%esp
  801d66:	68 28 45 80 00       	push   $0x804528
  801d6b:	68 e9 00 00 00       	push   $0xe9
  801d70:	68 13 44 80 00       	push   $0x804413
  801d75:	e8 ad ec ff ff       	call   800a27 <_panic>

00801d7a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d80:	83 ec 04             	sub    $0x4,%esp
  801d83:	68 28 45 80 00       	push   $0x804528
  801d88:	68 ee 00 00 00       	push   $0xee
  801d8d:	68 13 44 80 00       	push   $0x804413
  801d92:	e8 90 ec ff ff       	call   800a27 <_panic>

00801d97 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	57                   	push   %edi
  801d9b:	56                   	push   %esi
  801d9c:	53                   	push   %ebx
  801d9d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801da9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dac:	8b 7d 18             	mov    0x18(%ebp),%edi
  801daf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801db2:	cd 30                	int    $0x30
  801db4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801dba:	83 c4 10             	add    $0x10,%esp
  801dbd:	5b                   	pop    %ebx
  801dbe:	5e                   	pop    %esi
  801dbf:	5f                   	pop    %edi
  801dc0:	5d                   	pop    %ebp
  801dc1:	c3                   	ret    

00801dc2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 04             	sub    $0x4,%esp
  801dc8:	8b 45 10             	mov    0x10(%ebp),%eax
  801dcb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801dce:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	52                   	push   %edx
  801dda:	ff 75 0c             	pushl  0xc(%ebp)
  801ddd:	50                   	push   %eax
  801dde:	6a 00                	push   $0x0
  801de0:	e8 b2 ff ff ff       	call   801d97 <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
}
  801de8:	90                   	nop
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_cgetc>:

int
sys_cgetc(void)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 01                	push   $0x1
  801dfa:	e8 98 ff ff ff       	call   801d97 <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	52                   	push   %edx
  801e14:	50                   	push   %eax
  801e15:	6a 05                	push   $0x5
  801e17:	e8 7b ff ff ff       	call   801d97 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	56                   	push   %esi
  801e25:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e26:	8b 75 18             	mov    0x18(%ebp),%esi
  801e29:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	56                   	push   %esi
  801e36:	53                   	push   %ebx
  801e37:	51                   	push   %ecx
  801e38:	52                   	push   %edx
  801e39:	50                   	push   %eax
  801e3a:	6a 06                	push   $0x6
  801e3c:	e8 56 ff ff ff       	call   801d97 <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
}
  801e44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e47:	5b                   	pop    %ebx
  801e48:	5e                   	pop    %esi
  801e49:	5d                   	pop    %ebp
  801e4a:	c3                   	ret    

00801e4b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e51:	8b 45 08             	mov    0x8(%ebp),%eax
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	52                   	push   %edx
  801e5b:	50                   	push   %eax
  801e5c:	6a 07                	push   $0x7
  801e5e:	e8 34 ff ff ff       	call   801d97 <syscall>
  801e63:	83 c4 18             	add    $0x18,%esp
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	ff 75 0c             	pushl  0xc(%ebp)
  801e74:	ff 75 08             	pushl  0x8(%ebp)
  801e77:	6a 08                	push   $0x8
  801e79:	e8 19 ff ff ff       	call   801d97 <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 09                	push   $0x9
  801e92:	e8 00 ff ff ff       	call   801d97 <syscall>
  801e97:	83 c4 18             	add    $0x18,%esp
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 0a                	push   $0xa
  801eab:	e8 e7 fe ff ff       	call   801d97 <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 0b                	push   $0xb
  801ec4:	e8 ce fe ff ff       	call   801d97 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	ff 75 0c             	pushl  0xc(%ebp)
  801eda:	ff 75 08             	pushl  0x8(%ebp)
  801edd:	6a 0f                	push   $0xf
  801edf:	e8 b3 fe ff ff       	call   801d97 <syscall>
  801ee4:	83 c4 18             	add    $0x18,%esp
	return;
  801ee7:	90                   	nop
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	ff 75 0c             	pushl  0xc(%ebp)
  801ef6:	ff 75 08             	pushl  0x8(%ebp)
  801ef9:	6a 10                	push   $0x10
  801efb:	e8 97 fe ff ff       	call   801d97 <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
	return ;
  801f03:	90                   	nop
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	ff 75 10             	pushl  0x10(%ebp)
  801f10:	ff 75 0c             	pushl  0xc(%ebp)
  801f13:	ff 75 08             	pushl  0x8(%ebp)
  801f16:	6a 11                	push   $0x11
  801f18:	e8 7a fe ff ff       	call   801d97 <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f20:	90                   	nop
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 0c                	push   $0xc
  801f32:	e8 60 fe ff ff       	call   801d97 <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	ff 75 08             	pushl  0x8(%ebp)
  801f4a:	6a 0d                	push   $0xd
  801f4c:	e8 46 fe ff ff       	call   801d97 <syscall>
  801f51:	83 c4 18             	add    $0x18,%esp
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 0e                	push   $0xe
  801f65:	e8 2d fe ff ff       	call   801d97 <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
}
  801f6d:	90                   	nop
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 13                	push   $0x13
  801f7f:	e8 13 fe ff ff       	call   801d97 <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
}
  801f87:	90                   	nop
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 14                	push   $0x14
  801f99:	e8 f9 fd ff ff       	call   801d97 <syscall>
  801f9e:	83 c4 18             	add    $0x18,%esp
}
  801fa1:	90                   	nop
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <sys_cputc>:


void
sys_cputc(const char c)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 04             	sub    $0x4,%esp
  801faa:	8b 45 08             	mov    0x8(%ebp),%eax
  801fad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801fb0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	50                   	push   %eax
  801fbd:	6a 15                	push   $0x15
  801fbf:	e8 d3 fd ff ff       	call   801d97 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
}
  801fc7:	90                   	nop
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 16                	push   $0x16
  801fd9:	e8 b9 fd ff ff       	call   801d97 <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
}
  801fe1:	90                   	nop
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	ff 75 0c             	pushl  0xc(%ebp)
  801ff3:	50                   	push   %eax
  801ff4:	6a 17                	push   $0x17
  801ff6:	e8 9c fd ff ff       	call   801d97 <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802003:	8b 55 0c             	mov    0xc(%ebp),%edx
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	52                   	push   %edx
  802010:	50                   	push   %eax
  802011:	6a 1a                	push   $0x1a
  802013:	e8 7f fd ff ff       	call   801d97 <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802020:	8b 55 0c             	mov    0xc(%ebp),%edx
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	52                   	push   %edx
  80202d:	50                   	push   %eax
  80202e:	6a 18                	push   $0x18
  802030:	e8 62 fd ff ff       	call   801d97 <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
}
  802038:	90                   	nop
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80203e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	52                   	push   %edx
  80204b:	50                   	push   %eax
  80204c:	6a 19                	push   $0x19
  80204e:	e8 44 fd ff ff       	call   801d97 <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
}
  802056:	90                   	nop
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	8b 45 10             	mov    0x10(%ebp),%eax
  802062:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802065:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802068:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	6a 00                	push   $0x0
  802071:	51                   	push   %ecx
  802072:	52                   	push   %edx
  802073:	ff 75 0c             	pushl  0xc(%ebp)
  802076:	50                   	push   %eax
  802077:	6a 1b                	push   $0x1b
  802079:	e8 19 fd ff ff       	call   801d97 <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802086:	8b 55 0c             	mov    0xc(%ebp),%edx
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	52                   	push   %edx
  802093:	50                   	push   %eax
  802094:	6a 1c                	push   $0x1c
  802096:	e8 fc fc ff ff       	call   801d97 <syscall>
  80209b:	83 c4 18             	add    $0x18,%esp
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	51                   	push   %ecx
  8020b1:	52                   	push   %edx
  8020b2:	50                   	push   %eax
  8020b3:	6a 1d                	push   $0x1d
  8020b5:	e8 dd fc ff ff       	call   801d97 <syscall>
  8020ba:	83 c4 18             	add    $0x18,%esp
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	52                   	push   %edx
  8020cf:	50                   	push   %eax
  8020d0:	6a 1e                	push   $0x1e
  8020d2:	e8 c0 fc ff ff       	call   801d97 <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 1f                	push   $0x1f
  8020eb:	e8 a7 fc ff ff       	call   801d97 <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	6a 00                	push   $0x0
  8020fd:	ff 75 14             	pushl  0x14(%ebp)
  802100:	ff 75 10             	pushl  0x10(%ebp)
  802103:	ff 75 0c             	pushl  0xc(%ebp)
  802106:	50                   	push   %eax
  802107:	6a 20                	push   $0x20
  802109:	e8 89 fc ff ff       	call   801d97 <syscall>
  80210e:	83 c4 18             	add    $0x18,%esp
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	50                   	push   %eax
  802122:	6a 21                	push   $0x21
  802124:	e8 6e fc ff ff       	call   801d97 <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
}
  80212c:	90                   	nop
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	50                   	push   %eax
  80213e:	6a 22                	push   $0x22
  802140:	e8 52 fc ff ff       	call   801d97 <syscall>
  802145:	83 c4 18             	add    $0x18,%esp
}
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 02                	push   $0x2
  802159:	e8 39 fc ff ff       	call   801d97 <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
}
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 03                	push   $0x3
  802172:	e8 20 fc ff ff       	call   801d97 <syscall>
  802177:	83 c4 18             	add    $0x18,%esp
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 04                	push   $0x4
  80218b:	e8 07 fc ff ff       	call   801d97 <syscall>
  802190:	83 c4 18             	add    $0x18,%esp
}
  802193:	c9                   	leave  
  802194:	c3                   	ret    

00802195 <sys_exit_env>:


void sys_exit_env(void)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 23                	push   $0x23
  8021a4:	e8 ee fb ff ff       	call   801d97 <syscall>
  8021a9:	83 c4 18             	add    $0x18,%esp
}
  8021ac:	90                   	nop
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021b5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021b8:	8d 50 04             	lea    0x4(%eax),%edx
  8021bb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	52                   	push   %edx
  8021c5:	50                   	push   %eax
  8021c6:	6a 24                	push   $0x24
  8021c8:	e8 ca fb ff ff       	call   801d97 <syscall>
  8021cd:	83 c4 18             	add    $0x18,%esp
	return result;
  8021d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021d9:	89 01                	mov    %eax,(%ecx)
  8021db:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	c9                   	leave  
  8021e2:	c2 04 00             	ret    $0x4

008021e5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	ff 75 10             	pushl  0x10(%ebp)
  8021ef:	ff 75 0c             	pushl  0xc(%ebp)
  8021f2:	ff 75 08             	pushl  0x8(%ebp)
  8021f5:	6a 12                	push   $0x12
  8021f7:	e8 9b fb ff ff       	call   801d97 <syscall>
  8021fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ff:	90                   	nop
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <sys_rcr2>:
uint32 sys_rcr2()
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 25                	push   $0x25
  802211:	e8 81 fb ff ff       	call   801d97 <syscall>
  802216:	83 c4 18             	add    $0x18,%esp
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 04             	sub    $0x4,%esp
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802227:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	50                   	push   %eax
  802234:	6a 26                	push   $0x26
  802236:	e8 5c fb ff ff       	call   801d97 <syscall>
  80223b:	83 c4 18             	add    $0x18,%esp
	return ;
  80223e:	90                   	nop
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <rsttst>:
void rsttst()
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 28                	push   $0x28
  802250:	e8 42 fb ff ff       	call   801d97 <syscall>
  802255:	83 c4 18             	add    $0x18,%esp
	return ;
  802258:	90                   	nop
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	83 ec 04             	sub    $0x4,%esp
  802261:	8b 45 14             	mov    0x14(%ebp),%eax
  802264:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802267:	8b 55 18             	mov    0x18(%ebp),%edx
  80226a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80226e:	52                   	push   %edx
  80226f:	50                   	push   %eax
  802270:	ff 75 10             	pushl  0x10(%ebp)
  802273:	ff 75 0c             	pushl  0xc(%ebp)
  802276:	ff 75 08             	pushl  0x8(%ebp)
  802279:	6a 27                	push   $0x27
  80227b:	e8 17 fb ff ff       	call   801d97 <syscall>
  802280:	83 c4 18             	add    $0x18,%esp
	return ;
  802283:	90                   	nop
}
  802284:	c9                   	leave  
  802285:	c3                   	ret    

00802286 <chktst>:
void chktst(uint32 n)
{
  802286:	55                   	push   %ebp
  802287:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	ff 75 08             	pushl  0x8(%ebp)
  802294:	6a 29                	push   $0x29
  802296:	e8 fc fa ff ff       	call   801d97 <syscall>
  80229b:	83 c4 18             	add    $0x18,%esp
	return ;
  80229e:	90                   	nop
}
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <inctst>:

void inctst()
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 2a                	push   $0x2a
  8022b0:	e8 e2 fa ff ff       	call   801d97 <syscall>
  8022b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b8:	90                   	nop
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <gettst>:
uint32 gettst()
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 2b                	push   $0x2b
  8022ca:	e8 c8 fa ff ff       	call   801d97 <syscall>
  8022cf:	83 c4 18             	add    $0x18,%esp
}
  8022d2:	c9                   	leave  
  8022d3:	c3                   	ret    

008022d4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
  8022d7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 2c                	push   $0x2c
  8022e6:	e8 ac fa ff ff       	call   801d97 <syscall>
  8022eb:	83 c4 18             	add    $0x18,%esp
  8022ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8022f1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8022f5:	75 07                	jne    8022fe <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8022f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8022fc:	eb 05                	jmp    802303 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 2c                	push   $0x2c
  802317:	e8 7b fa ff ff       	call   801d97 <syscall>
  80231c:	83 c4 18             	add    $0x18,%esp
  80231f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802322:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802326:	75 07                	jne    80232f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802328:	b8 01 00 00 00       	mov    $0x1,%eax
  80232d:	eb 05                	jmp    802334 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80232f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 2c                	push   $0x2c
  802348:	e8 4a fa ff ff       	call   801d97 <syscall>
  80234d:	83 c4 18             	add    $0x18,%esp
  802350:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802353:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802357:	75 07                	jne    802360 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802359:	b8 01 00 00 00       	mov    $0x1,%eax
  80235e:	eb 05                	jmp    802365 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802360:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
  80236a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 2c                	push   $0x2c
  802379:	e8 19 fa ff ff       	call   801d97 <syscall>
  80237e:	83 c4 18             	add    $0x18,%esp
  802381:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802384:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802388:	75 07                	jne    802391 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80238a:	b8 01 00 00 00       	mov    $0x1,%eax
  80238f:	eb 05                	jmp    802396 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802391:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802396:	c9                   	leave  
  802397:	c3                   	ret    

00802398 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802398:	55                   	push   %ebp
  802399:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	ff 75 08             	pushl  0x8(%ebp)
  8023a6:	6a 2d                	push   $0x2d
  8023a8:	e8 ea f9 ff ff       	call   801d97 <syscall>
  8023ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b0:	90                   	nop
}
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
  8023b6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	6a 00                	push   $0x0
  8023c5:	53                   	push   %ebx
  8023c6:	51                   	push   %ecx
  8023c7:	52                   	push   %edx
  8023c8:	50                   	push   %eax
  8023c9:	6a 2e                	push   $0x2e
  8023cb:	e8 c7 f9 ff ff       	call   801d97 <syscall>
  8023d0:	83 c4 18             	add    $0x18,%esp
}
  8023d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	52                   	push   %edx
  8023e8:	50                   	push   %eax
  8023e9:	6a 2f                	push   $0x2f
  8023eb:	e8 a7 f9 ff ff       	call   801d97 <syscall>
  8023f0:	83 c4 18             	add    $0x18,%esp
}
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
  8023f8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8023fb:	83 ec 0c             	sub    $0xc,%esp
  8023fe:	68 38 45 80 00       	push   $0x804538
  802403:	e8 d3 e8 ff ff       	call   800cdb <cprintf>
  802408:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80240b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802412:	83 ec 0c             	sub    $0xc,%esp
  802415:	68 64 45 80 00       	push   $0x804564
  80241a:	e8 bc e8 ff ff       	call   800cdb <cprintf>
  80241f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802422:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802426:	a1 38 51 80 00       	mov    0x805138,%eax
  80242b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242e:	eb 56                	jmp    802486 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802430:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802434:	74 1c                	je     802452 <print_mem_block_lists+0x5d>
  802436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802439:	8b 50 08             	mov    0x8(%eax),%edx
  80243c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243f:	8b 48 08             	mov    0x8(%eax),%ecx
  802442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802445:	8b 40 0c             	mov    0xc(%eax),%eax
  802448:	01 c8                	add    %ecx,%eax
  80244a:	39 c2                	cmp    %eax,%edx
  80244c:	73 04                	jae    802452 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80244e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 50 08             	mov    0x8(%eax),%edx
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	8b 40 0c             	mov    0xc(%eax),%eax
  80245e:	01 c2                	add    %eax,%edx
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	8b 40 08             	mov    0x8(%eax),%eax
  802466:	83 ec 04             	sub    $0x4,%esp
  802469:	52                   	push   %edx
  80246a:	50                   	push   %eax
  80246b:	68 79 45 80 00       	push   $0x804579
  802470:	e8 66 e8 ff ff       	call   800cdb <cprintf>
  802475:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80247e:	a1 40 51 80 00       	mov    0x805140,%eax
  802483:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802486:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248a:	74 07                	je     802493 <print_mem_block_lists+0x9e>
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 00                	mov    (%eax),%eax
  802491:	eb 05                	jmp    802498 <print_mem_block_lists+0xa3>
  802493:	b8 00 00 00 00       	mov    $0x0,%eax
  802498:	a3 40 51 80 00       	mov    %eax,0x805140
  80249d:	a1 40 51 80 00       	mov    0x805140,%eax
  8024a2:	85 c0                	test   %eax,%eax
  8024a4:	75 8a                	jne    802430 <print_mem_block_lists+0x3b>
  8024a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024aa:	75 84                	jne    802430 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8024ac:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024b0:	75 10                	jne    8024c2 <print_mem_block_lists+0xcd>
  8024b2:	83 ec 0c             	sub    $0xc,%esp
  8024b5:	68 88 45 80 00       	push   $0x804588
  8024ba:	e8 1c e8 ff ff       	call   800cdb <cprintf>
  8024bf:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8024c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8024c9:	83 ec 0c             	sub    $0xc,%esp
  8024cc:	68 ac 45 80 00       	push   $0x8045ac
  8024d1:	e8 05 e8 ff ff       	call   800cdb <cprintf>
  8024d6:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8024d9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024dd:	a1 40 50 80 00       	mov    0x805040,%eax
  8024e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e5:	eb 56                	jmp    80253d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024eb:	74 1c                	je     802509 <print_mem_block_lists+0x114>
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 50 08             	mov    0x8(%eax),%edx
  8024f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f6:	8b 48 08             	mov    0x8(%eax),%ecx
  8024f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ff:	01 c8                	add    %ecx,%eax
  802501:	39 c2                	cmp    %eax,%edx
  802503:	73 04                	jae    802509 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802505:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 50 08             	mov    0x8(%eax),%edx
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 40 0c             	mov    0xc(%eax),%eax
  802515:	01 c2                	add    %eax,%edx
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	8b 40 08             	mov    0x8(%eax),%eax
  80251d:	83 ec 04             	sub    $0x4,%esp
  802520:	52                   	push   %edx
  802521:	50                   	push   %eax
  802522:	68 79 45 80 00       	push   $0x804579
  802527:	e8 af e7 ff ff       	call   800cdb <cprintf>
  80252c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802535:	a1 48 50 80 00       	mov    0x805048,%eax
  80253a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802541:	74 07                	je     80254a <print_mem_block_lists+0x155>
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	8b 00                	mov    (%eax),%eax
  802548:	eb 05                	jmp    80254f <print_mem_block_lists+0x15a>
  80254a:	b8 00 00 00 00       	mov    $0x0,%eax
  80254f:	a3 48 50 80 00       	mov    %eax,0x805048
  802554:	a1 48 50 80 00       	mov    0x805048,%eax
  802559:	85 c0                	test   %eax,%eax
  80255b:	75 8a                	jne    8024e7 <print_mem_block_lists+0xf2>
  80255d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802561:	75 84                	jne    8024e7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802563:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802567:	75 10                	jne    802579 <print_mem_block_lists+0x184>
  802569:	83 ec 0c             	sub    $0xc,%esp
  80256c:	68 c4 45 80 00       	push   $0x8045c4
  802571:	e8 65 e7 ff ff       	call   800cdb <cprintf>
  802576:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802579:	83 ec 0c             	sub    $0xc,%esp
  80257c:	68 38 45 80 00       	push   $0x804538
  802581:	e8 55 e7 ff ff       	call   800cdb <cprintf>
  802586:	83 c4 10             	add    $0x10,%esp

}
  802589:	90                   	nop
  80258a:	c9                   	leave  
  80258b:	c3                   	ret    

0080258c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
  80258f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802592:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802599:	00 00 00 
  80259c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8025a3:	00 00 00 
  8025a6:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8025ad:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8025b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8025b7:	e9 9e 00 00 00       	jmp    80265a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8025bc:	a1 50 50 80 00       	mov    0x805050,%eax
  8025c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c4:	c1 e2 04             	shl    $0x4,%edx
  8025c7:	01 d0                	add    %edx,%eax
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	75 14                	jne    8025e1 <initialize_MemBlocksList+0x55>
  8025cd:	83 ec 04             	sub    $0x4,%esp
  8025d0:	68 ec 45 80 00       	push   $0x8045ec
  8025d5:	6a 46                	push   $0x46
  8025d7:	68 0f 46 80 00       	push   $0x80460f
  8025dc:	e8 46 e4 ff ff       	call   800a27 <_panic>
  8025e1:	a1 50 50 80 00       	mov    0x805050,%eax
  8025e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e9:	c1 e2 04             	shl    $0x4,%edx
  8025ec:	01 d0                	add    %edx,%eax
  8025ee:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8025f4:	89 10                	mov    %edx,(%eax)
  8025f6:	8b 00                	mov    (%eax),%eax
  8025f8:	85 c0                	test   %eax,%eax
  8025fa:	74 18                	je     802614 <initialize_MemBlocksList+0x88>
  8025fc:	a1 48 51 80 00       	mov    0x805148,%eax
  802601:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802607:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80260a:	c1 e1 04             	shl    $0x4,%ecx
  80260d:	01 ca                	add    %ecx,%edx
  80260f:	89 50 04             	mov    %edx,0x4(%eax)
  802612:	eb 12                	jmp    802626 <initialize_MemBlocksList+0x9a>
  802614:	a1 50 50 80 00       	mov    0x805050,%eax
  802619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261c:	c1 e2 04             	shl    $0x4,%edx
  80261f:	01 d0                	add    %edx,%eax
  802621:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802626:	a1 50 50 80 00       	mov    0x805050,%eax
  80262b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262e:	c1 e2 04             	shl    $0x4,%edx
  802631:	01 d0                	add    %edx,%eax
  802633:	a3 48 51 80 00       	mov    %eax,0x805148
  802638:	a1 50 50 80 00       	mov    0x805050,%eax
  80263d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802640:	c1 e2 04             	shl    $0x4,%edx
  802643:	01 d0                	add    %edx,%eax
  802645:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80264c:	a1 54 51 80 00       	mov    0x805154,%eax
  802651:	40                   	inc    %eax
  802652:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802657:	ff 45 f4             	incl   -0xc(%ebp)
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802660:	0f 82 56 ff ff ff    	jb     8025bc <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802666:	90                   	nop
  802667:	c9                   	leave  
  802668:	c3                   	ret    

00802669 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
  80266c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80266f:	8b 45 08             	mov    0x8(%ebp),%eax
  802672:	8b 00                	mov    (%eax),%eax
  802674:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802677:	eb 19                	jmp    802692 <find_block+0x29>
	{
		if(va==point->sva)
  802679:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80267c:	8b 40 08             	mov    0x8(%eax),%eax
  80267f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802682:	75 05                	jne    802689 <find_block+0x20>
		   return point;
  802684:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802687:	eb 36                	jmp    8026bf <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802689:	8b 45 08             	mov    0x8(%ebp),%eax
  80268c:	8b 40 08             	mov    0x8(%eax),%eax
  80268f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802692:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802696:	74 07                	je     80269f <find_block+0x36>
  802698:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80269b:	8b 00                	mov    (%eax),%eax
  80269d:	eb 05                	jmp    8026a4 <find_block+0x3b>
  80269f:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a7:	89 42 08             	mov    %eax,0x8(%edx)
  8026aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ad:	8b 40 08             	mov    0x8(%eax),%eax
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	75 c5                	jne    802679 <find_block+0x10>
  8026b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026b8:	75 bf                	jne    802679 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8026ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026bf:	c9                   	leave  
  8026c0:	c3                   	ret    

008026c1 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8026c1:	55                   	push   %ebp
  8026c2:	89 e5                	mov    %esp,%ebp
  8026c4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8026c7:	a1 40 50 80 00       	mov    0x805040,%eax
  8026cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8026cf:	a1 44 50 80 00       	mov    0x805044,%eax
  8026d4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8026d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026da:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026dd:	74 24                	je     802703 <insert_sorted_allocList+0x42>
  8026df:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e2:	8b 50 08             	mov    0x8(%eax),%edx
  8026e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e8:	8b 40 08             	mov    0x8(%eax),%eax
  8026eb:	39 c2                	cmp    %eax,%edx
  8026ed:	76 14                	jbe    802703 <insert_sorted_allocList+0x42>
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	8b 50 08             	mov    0x8(%eax),%edx
  8026f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f8:	8b 40 08             	mov    0x8(%eax),%eax
  8026fb:	39 c2                	cmp    %eax,%edx
  8026fd:	0f 82 60 01 00 00    	jb     802863 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802703:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802707:	75 65                	jne    80276e <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802709:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80270d:	75 14                	jne    802723 <insert_sorted_allocList+0x62>
  80270f:	83 ec 04             	sub    $0x4,%esp
  802712:	68 ec 45 80 00       	push   $0x8045ec
  802717:	6a 6b                	push   $0x6b
  802719:	68 0f 46 80 00       	push   $0x80460f
  80271e:	e8 04 e3 ff ff       	call   800a27 <_panic>
  802723:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802729:	8b 45 08             	mov    0x8(%ebp),%eax
  80272c:	89 10                	mov    %edx,(%eax)
  80272e:	8b 45 08             	mov    0x8(%ebp),%eax
  802731:	8b 00                	mov    (%eax),%eax
  802733:	85 c0                	test   %eax,%eax
  802735:	74 0d                	je     802744 <insert_sorted_allocList+0x83>
  802737:	a1 40 50 80 00       	mov    0x805040,%eax
  80273c:	8b 55 08             	mov    0x8(%ebp),%edx
  80273f:	89 50 04             	mov    %edx,0x4(%eax)
  802742:	eb 08                	jmp    80274c <insert_sorted_allocList+0x8b>
  802744:	8b 45 08             	mov    0x8(%ebp),%eax
  802747:	a3 44 50 80 00       	mov    %eax,0x805044
  80274c:	8b 45 08             	mov    0x8(%ebp),%eax
  80274f:	a3 40 50 80 00       	mov    %eax,0x805040
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802763:	40                   	inc    %eax
  802764:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802769:	e9 dc 01 00 00       	jmp    80294a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80276e:	8b 45 08             	mov    0x8(%ebp),%eax
  802771:	8b 50 08             	mov    0x8(%eax),%edx
  802774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802777:	8b 40 08             	mov    0x8(%eax),%eax
  80277a:	39 c2                	cmp    %eax,%edx
  80277c:	77 6c                	ja     8027ea <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80277e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802782:	74 06                	je     80278a <insert_sorted_allocList+0xc9>
  802784:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802788:	75 14                	jne    80279e <insert_sorted_allocList+0xdd>
  80278a:	83 ec 04             	sub    $0x4,%esp
  80278d:	68 28 46 80 00       	push   $0x804628
  802792:	6a 6f                	push   $0x6f
  802794:	68 0f 46 80 00       	push   $0x80460f
  802799:	e8 89 e2 ff ff       	call   800a27 <_panic>
  80279e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a1:	8b 50 04             	mov    0x4(%eax),%edx
  8027a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a7:	89 50 04             	mov    %edx,0x4(%eax)
  8027aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027b0:	89 10                	mov    %edx,(%eax)
  8027b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b5:	8b 40 04             	mov    0x4(%eax),%eax
  8027b8:	85 c0                	test   %eax,%eax
  8027ba:	74 0d                	je     8027c9 <insert_sorted_allocList+0x108>
  8027bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bf:	8b 40 04             	mov    0x4(%eax),%eax
  8027c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c5:	89 10                	mov    %edx,(%eax)
  8027c7:	eb 08                	jmp    8027d1 <insert_sorted_allocList+0x110>
  8027c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cc:	a3 40 50 80 00       	mov    %eax,0x805040
  8027d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d7:	89 50 04             	mov    %edx,0x4(%eax)
  8027da:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027df:	40                   	inc    %eax
  8027e0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027e5:	e9 60 01 00 00       	jmp    80294a <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8027ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ed:	8b 50 08             	mov    0x8(%eax),%edx
  8027f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f3:	8b 40 08             	mov    0x8(%eax),%eax
  8027f6:	39 c2                	cmp    %eax,%edx
  8027f8:	0f 82 4c 01 00 00    	jb     80294a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8027fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802802:	75 14                	jne    802818 <insert_sorted_allocList+0x157>
  802804:	83 ec 04             	sub    $0x4,%esp
  802807:	68 60 46 80 00       	push   $0x804660
  80280c:	6a 73                	push   $0x73
  80280e:	68 0f 46 80 00       	push   $0x80460f
  802813:	e8 0f e2 ff ff       	call   800a27 <_panic>
  802818:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80281e:	8b 45 08             	mov    0x8(%ebp),%eax
  802821:	89 50 04             	mov    %edx,0x4(%eax)
  802824:	8b 45 08             	mov    0x8(%ebp),%eax
  802827:	8b 40 04             	mov    0x4(%eax),%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	74 0c                	je     80283a <insert_sorted_allocList+0x179>
  80282e:	a1 44 50 80 00       	mov    0x805044,%eax
  802833:	8b 55 08             	mov    0x8(%ebp),%edx
  802836:	89 10                	mov    %edx,(%eax)
  802838:	eb 08                	jmp    802842 <insert_sorted_allocList+0x181>
  80283a:	8b 45 08             	mov    0x8(%ebp),%eax
  80283d:	a3 40 50 80 00       	mov    %eax,0x805040
  802842:	8b 45 08             	mov    0x8(%ebp),%eax
  802845:	a3 44 50 80 00       	mov    %eax,0x805044
  80284a:	8b 45 08             	mov    0x8(%ebp),%eax
  80284d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802853:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802858:	40                   	inc    %eax
  802859:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80285e:	e9 e7 00 00 00       	jmp    80294a <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802863:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802866:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802869:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802870:	a1 40 50 80 00       	mov    0x805040,%eax
  802875:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802878:	e9 9d 00 00 00       	jmp    80291a <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 00                	mov    (%eax),%eax
  802882:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802885:	8b 45 08             	mov    0x8(%ebp),%eax
  802888:	8b 50 08             	mov    0x8(%eax),%edx
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	8b 40 08             	mov    0x8(%eax),%eax
  802891:	39 c2                	cmp    %eax,%edx
  802893:	76 7d                	jbe    802912 <insert_sorted_allocList+0x251>
  802895:	8b 45 08             	mov    0x8(%ebp),%eax
  802898:	8b 50 08             	mov    0x8(%eax),%edx
  80289b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80289e:	8b 40 08             	mov    0x8(%eax),%eax
  8028a1:	39 c2                	cmp    %eax,%edx
  8028a3:	73 6d                	jae    802912 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8028a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a9:	74 06                	je     8028b1 <insert_sorted_allocList+0x1f0>
  8028ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028af:	75 14                	jne    8028c5 <insert_sorted_allocList+0x204>
  8028b1:	83 ec 04             	sub    $0x4,%esp
  8028b4:	68 84 46 80 00       	push   $0x804684
  8028b9:	6a 7f                	push   $0x7f
  8028bb:	68 0f 46 80 00       	push   $0x80460f
  8028c0:	e8 62 e1 ff ff       	call   800a27 <_panic>
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	8b 10                	mov    (%eax),%edx
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	89 10                	mov    %edx,(%eax)
  8028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	74 0b                	je     8028e3 <insert_sorted_allocList+0x222>
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 00                	mov    (%eax),%eax
  8028dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e0:	89 50 04             	mov    %edx,0x4(%eax)
  8028e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e9:	89 10                	mov    %edx,(%eax)
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f1:	89 50 04             	mov    %edx,0x4(%eax)
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	8b 00                	mov    (%eax),%eax
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	75 08                	jne    802905 <insert_sorted_allocList+0x244>
  8028fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802900:	a3 44 50 80 00       	mov    %eax,0x805044
  802905:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80290a:	40                   	inc    %eax
  80290b:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802910:	eb 39                	jmp    80294b <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802912:	a1 48 50 80 00       	mov    0x805048,%eax
  802917:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291e:	74 07                	je     802927 <insert_sorted_allocList+0x266>
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 00                	mov    (%eax),%eax
  802925:	eb 05                	jmp    80292c <insert_sorted_allocList+0x26b>
  802927:	b8 00 00 00 00       	mov    $0x0,%eax
  80292c:	a3 48 50 80 00       	mov    %eax,0x805048
  802931:	a1 48 50 80 00       	mov    0x805048,%eax
  802936:	85 c0                	test   %eax,%eax
  802938:	0f 85 3f ff ff ff    	jne    80287d <insert_sorted_allocList+0x1bc>
  80293e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802942:	0f 85 35 ff ff ff    	jne    80287d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802948:	eb 01                	jmp    80294b <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80294a:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80294b:	90                   	nop
  80294c:	c9                   	leave  
  80294d:	c3                   	ret    

0080294e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
  802951:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802954:	a1 38 51 80 00       	mov    0x805138,%eax
  802959:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295c:	e9 85 01 00 00       	jmp    802ae6 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	8b 40 0c             	mov    0xc(%eax),%eax
  802967:	3b 45 08             	cmp    0x8(%ebp),%eax
  80296a:	0f 82 6e 01 00 00    	jb     802ade <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 40 0c             	mov    0xc(%eax),%eax
  802976:	3b 45 08             	cmp    0x8(%ebp),%eax
  802979:	0f 85 8a 00 00 00    	jne    802a09 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80297f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802983:	75 17                	jne    80299c <alloc_block_FF+0x4e>
  802985:	83 ec 04             	sub    $0x4,%esp
  802988:	68 b8 46 80 00       	push   $0x8046b8
  80298d:	68 93 00 00 00       	push   $0x93
  802992:	68 0f 46 80 00       	push   $0x80460f
  802997:	e8 8b e0 ff ff       	call   800a27 <_panic>
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 00                	mov    (%eax),%eax
  8029a1:	85 c0                	test   %eax,%eax
  8029a3:	74 10                	je     8029b5 <alloc_block_FF+0x67>
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	8b 00                	mov    (%eax),%eax
  8029aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ad:	8b 52 04             	mov    0x4(%edx),%edx
  8029b0:	89 50 04             	mov    %edx,0x4(%eax)
  8029b3:	eb 0b                	jmp    8029c0 <alloc_block_FF+0x72>
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	8b 40 04             	mov    0x4(%eax),%eax
  8029bb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 40 04             	mov    0x4(%eax),%eax
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	74 0f                	je     8029d9 <alloc_block_FF+0x8b>
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 40 04             	mov    0x4(%eax),%eax
  8029d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d3:	8b 12                	mov    (%edx),%edx
  8029d5:	89 10                	mov    %edx,(%eax)
  8029d7:	eb 0a                	jmp    8029e3 <alloc_block_FF+0x95>
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	a3 38 51 80 00       	mov    %eax,0x805138
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8029fb:	48                   	dec    %eax
  8029fc:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	e9 10 01 00 00       	jmp    802b19 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a12:	0f 86 c6 00 00 00    	jbe    802ade <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a18:	a1 48 51 80 00       	mov    0x805148,%eax
  802a1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 50 08             	mov    0x8(%eax),%edx
  802a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a29:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a32:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a39:	75 17                	jne    802a52 <alloc_block_FF+0x104>
  802a3b:	83 ec 04             	sub    $0x4,%esp
  802a3e:	68 b8 46 80 00       	push   $0x8046b8
  802a43:	68 9b 00 00 00       	push   $0x9b
  802a48:	68 0f 46 80 00       	push   $0x80460f
  802a4d:	e8 d5 df ff ff       	call   800a27 <_panic>
  802a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a55:	8b 00                	mov    (%eax),%eax
  802a57:	85 c0                	test   %eax,%eax
  802a59:	74 10                	je     802a6b <alloc_block_FF+0x11d>
  802a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5e:	8b 00                	mov    (%eax),%eax
  802a60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a63:	8b 52 04             	mov    0x4(%edx),%edx
  802a66:	89 50 04             	mov    %edx,0x4(%eax)
  802a69:	eb 0b                	jmp    802a76 <alloc_block_FF+0x128>
  802a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6e:	8b 40 04             	mov    0x4(%eax),%eax
  802a71:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a79:	8b 40 04             	mov    0x4(%eax),%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	74 0f                	je     802a8f <alloc_block_FF+0x141>
  802a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a83:	8b 40 04             	mov    0x4(%eax),%eax
  802a86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a89:	8b 12                	mov    (%edx),%edx
  802a8b:	89 10                	mov    %edx,(%eax)
  802a8d:	eb 0a                	jmp    802a99 <alloc_block_FF+0x14b>
  802a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	a3 48 51 80 00       	mov    %eax,0x805148
  802a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aac:	a1 54 51 80 00       	mov    0x805154,%eax
  802ab1:	48                   	dec    %eax
  802ab2:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	8b 50 08             	mov    0x8(%eax),%edx
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	01 c2                	add    %eax,%edx
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ace:	2b 45 08             	sub    0x8(%ebp),%eax
  802ad1:	89 c2                	mov    %eax,%edx
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adc:	eb 3b                	jmp    802b19 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802ade:	a1 40 51 80 00       	mov    0x805140,%eax
  802ae3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aea:	74 07                	je     802af3 <alloc_block_FF+0x1a5>
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 00                	mov    (%eax),%eax
  802af1:	eb 05                	jmp    802af8 <alloc_block_FF+0x1aa>
  802af3:	b8 00 00 00 00       	mov    $0x0,%eax
  802af8:	a3 40 51 80 00       	mov    %eax,0x805140
  802afd:	a1 40 51 80 00       	mov    0x805140,%eax
  802b02:	85 c0                	test   %eax,%eax
  802b04:	0f 85 57 fe ff ff    	jne    802961 <alloc_block_FF+0x13>
  802b0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0e:	0f 85 4d fe ff ff    	jne    802961 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802b14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b19:	c9                   	leave  
  802b1a:	c3                   	ret    

00802b1b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b1b:	55                   	push   %ebp
  802b1c:	89 e5                	mov    %esp,%ebp
  802b1e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802b21:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b28:	a1 38 51 80 00       	mov    0x805138,%eax
  802b2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b30:	e9 df 00 00 00       	jmp    802c14 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3e:	0f 82 c8 00 00 00    	jb     802c0c <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b4d:	0f 85 8a 00 00 00    	jne    802bdd <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802b53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b57:	75 17                	jne    802b70 <alloc_block_BF+0x55>
  802b59:	83 ec 04             	sub    $0x4,%esp
  802b5c:	68 b8 46 80 00       	push   $0x8046b8
  802b61:	68 b7 00 00 00       	push   $0xb7
  802b66:	68 0f 46 80 00       	push   $0x80460f
  802b6b:	e8 b7 de ff ff       	call   800a27 <_panic>
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 00                	mov    (%eax),%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	74 10                	je     802b89 <alloc_block_BF+0x6e>
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b81:	8b 52 04             	mov    0x4(%edx),%edx
  802b84:	89 50 04             	mov    %edx,0x4(%eax)
  802b87:	eb 0b                	jmp    802b94 <alloc_block_BF+0x79>
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 40 04             	mov    0x4(%eax),%eax
  802b8f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 40 04             	mov    0x4(%eax),%eax
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	74 0f                	je     802bad <alloc_block_BF+0x92>
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 40 04             	mov    0x4(%eax),%eax
  802ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba7:	8b 12                	mov    (%edx),%edx
  802ba9:	89 10                	mov    %edx,(%eax)
  802bab:	eb 0a                	jmp    802bb7 <alloc_block_BF+0x9c>
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
			   return currentMemBlock;
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	e9 4d 01 00 00       	jmp    802d2a <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	8b 40 0c             	mov    0xc(%eax),%eax
  802be3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be6:	76 24                	jbe    802c0c <alloc_block_BF+0xf1>
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802bf1:	73 19                	jae    802c0c <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802bf3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802c00:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	8b 40 08             	mov    0x8(%eax),%eax
  802c09:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c0c:	a1 40 51 80 00       	mov    0x805140,%eax
  802c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c18:	74 07                	je     802c21 <alloc_block_BF+0x106>
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 00                	mov    (%eax),%eax
  802c1f:	eb 05                	jmp    802c26 <alloc_block_BF+0x10b>
  802c21:	b8 00 00 00 00       	mov    $0x0,%eax
  802c26:	a3 40 51 80 00       	mov    %eax,0x805140
  802c2b:	a1 40 51 80 00       	mov    0x805140,%eax
  802c30:	85 c0                	test   %eax,%eax
  802c32:	0f 85 fd fe ff ff    	jne    802b35 <alloc_block_BF+0x1a>
  802c38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3c:	0f 85 f3 fe ff ff    	jne    802b35 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802c42:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c46:	0f 84 d9 00 00 00    	je     802d25 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c4c:	a1 48 51 80 00       	mov    0x805148,%eax
  802c51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802c54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c57:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c5a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802c5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c60:	8b 55 08             	mov    0x8(%ebp),%edx
  802c63:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802c66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c6a:	75 17                	jne    802c83 <alloc_block_BF+0x168>
  802c6c:	83 ec 04             	sub    $0x4,%esp
  802c6f:	68 b8 46 80 00       	push   $0x8046b8
  802c74:	68 c7 00 00 00       	push   $0xc7
  802c79:	68 0f 46 80 00       	push   $0x80460f
  802c7e:	e8 a4 dd ff ff       	call   800a27 <_panic>
  802c83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c86:	8b 00                	mov    (%eax),%eax
  802c88:	85 c0                	test   %eax,%eax
  802c8a:	74 10                	je     802c9c <alloc_block_BF+0x181>
  802c8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c8f:	8b 00                	mov    (%eax),%eax
  802c91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c94:	8b 52 04             	mov    0x4(%edx),%edx
  802c97:	89 50 04             	mov    %edx,0x4(%eax)
  802c9a:	eb 0b                	jmp    802ca7 <alloc_block_BF+0x18c>
  802c9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ca2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ca7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802caa:	8b 40 04             	mov    0x4(%eax),%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	74 0f                	je     802cc0 <alloc_block_BF+0x1a5>
  802cb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb4:	8b 40 04             	mov    0x4(%eax),%eax
  802cb7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cba:	8b 12                	mov    (%edx),%edx
  802cbc:	89 10                	mov    %edx,(%eax)
  802cbe:	eb 0a                	jmp    802cca <alloc_block_BF+0x1af>
  802cc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc3:	8b 00                	mov    (%eax),%eax
  802cc5:	a3 48 51 80 00       	mov    %eax,0x805148
  802cca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ccd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cdd:	a1 54 51 80 00       	mov    0x805154,%eax
  802ce2:	48                   	dec    %eax
  802ce3:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802ce8:	83 ec 08             	sub    $0x8,%esp
  802ceb:	ff 75 ec             	pushl  -0x14(%ebp)
  802cee:	68 38 51 80 00       	push   $0x805138
  802cf3:	e8 71 f9 ff ff       	call   802669 <find_block>
  802cf8:	83 c4 10             	add    $0x10,%esp
  802cfb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802cfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d01:	8b 50 08             	mov    0x8(%eax),%edx
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	01 c2                	add    %eax,%edx
  802d09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d0c:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802d0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d12:	8b 40 0c             	mov    0xc(%eax),%eax
  802d15:	2b 45 08             	sub    0x8(%ebp),%eax
  802d18:	89 c2                	mov    %eax,%edx
  802d1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d1d:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802d20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d23:	eb 05                	jmp    802d2a <alloc_block_BF+0x20f>
	}
	return NULL;
  802d25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d2a:	c9                   	leave  
  802d2b:	c3                   	ret    

00802d2c <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802d2c:	55                   	push   %ebp
  802d2d:	89 e5                	mov    %esp,%ebp
  802d2f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802d32:	a1 28 50 80 00       	mov    0x805028,%eax
  802d37:	85 c0                	test   %eax,%eax
  802d39:	0f 85 de 01 00 00    	jne    802f1d <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d3f:	a1 38 51 80 00       	mov    0x805138,%eax
  802d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d47:	e9 9e 01 00 00       	jmp    802eea <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d52:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d55:	0f 82 87 01 00 00    	jb     802ee2 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d61:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d64:	0f 85 95 00 00 00    	jne    802dff <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802d6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6e:	75 17                	jne    802d87 <alloc_block_NF+0x5b>
  802d70:	83 ec 04             	sub    $0x4,%esp
  802d73:	68 b8 46 80 00       	push   $0x8046b8
  802d78:	68 e0 00 00 00       	push   $0xe0
  802d7d:	68 0f 46 80 00       	push   $0x80460f
  802d82:	e8 a0 dc ff ff       	call   800a27 <_panic>
  802d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8a:	8b 00                	mov    (%eax),%eax
  802d8c:	85 c0                	test   %eax,%eax
  802d8e:	74 10                	je     802da0 <alloc_block_NF+0x74>
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	8b 00                	mov    (%eax),%eax
  802d95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d98:	8b 52 04             	mov    0x4(%edx),%edx
  802d9b:	89 50 04             	mov    %edx,0x4(%eax)
  802d9e:	eb 0b                	jmp    802dab <alloc_block_NF+0x7f>
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 40 04             	mov    0x4(%eax),%eax
  802da6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	8b 40 04             	mov    0x4(%eax),%eax
  802db1:	85 c0                	test   %eax,%eax
  802db3:	74 0f                	je     802dc4 <alloc_block_NF+0x98>
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	8b 40 04             	mov    0x4(%eax),%eax
  802dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbe:	8b 12                	mov    (%edx),%edx
  802dc0:	89 10                	mov    %edx,(%eax)
  802dc2:	eb 0a                	jmp    802dce <alloc_block_NF+0xa2>
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	8b 00                	mov    (%eax),%eax
  802dc9:	a3 38 51 80 00       	mov    %eax,0x805138
  802dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de1:	a1 44 51 80 00       	mov    0x805144,%eax
  802de6:	48                   	dec    %eax
  802de7:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	8b 40 08             	mov    0x8(%eax),%eax
  802df2:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfa:	e9 f8 04 00 00       	jmp    8032f7 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 40 0c             	mov    0xc(%eax),%eax
  802e05:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e08:	0f 86 d4 00 00 00    	jbe    802ee2 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e0e:	a1 48 51 80 00       	mov    0x805148,%eax
  802e13:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e19:	8b 50 08             	mov    0x8(%eax),%edx
  802e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1f:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e25:	8b 55 08             	mov    0x8(%ebp),%edx
  802e28:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e2f:	75 17                	jne    802e48 <alloc_block_NF+0x11c>
  802e31:	83 ec 04             	sub    $0x4,%esp
  802e34:	68 b8 46 80 00       	push   $0x8046b8
  802e39:	68 e9 00 00 00       	push   $0xe9
  802e3e:	68 0f 46 80 00       	push   $0x80460f
  802e43:	e8 df db ff ff       	call   800a27 <_panic>
  802e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4b:	8b 00                	mov    (%eax),%eax
  802e4d:	85 c0                	test   %eax,%eax
  802e4f:	74 10                	je     802e61 <alloc_block_NF+0x135>
  802e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e54:	8b 00                	mov    (%eax),%eax
  802e56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e59:	8b 52 04             	mov    0x4(%edx),%edx
  802e5c:	89 50 04             	mov    %edx,0x4(%eax)
  802e5f:	eb 0b                	jmp    802e6c <alloc_block_NF+0x140>
  802e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e64:	8b 40 04             	mov    0x4(%eax),%eax
  802e67:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6f:	8b 40 04             	mov    0x4(%eax),%eax
  802e72:	85 c0                	test   %eax,%eax
  802e74:	74 0f                	je     802e85 <alloc_block_NF+0x159>
  802e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e79:	8b 40 04             	mov    0x4(%eax),%eax
  802e7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e7f:	8b 12                	mov    (%edx),%edx
  802e81:	89 10                	mov    %edx,(%eax)
  802e83:	eb 0a                	jmp    802e8f <alloc_block_NF+0x163>
  802e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e88:	8b 00                	mov    (%eax),%eax
  802e8a:	a3 48 51 80 00       	mov    %eax,0x805148
  802e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea2:	a1 54 51 80 00       	mov    0x805154,%eax
  802ea7:	48                   	dec    %eax
  802ea8:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb0:	8b 40 08             	mov    0x8(%eax),%eax
  802eb3:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	8b 50 08             	mov    0x8(%eax),%edx
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	01 c2                	add    %eax,%edx
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecf:	2b 45 08             	sub    0x8(%ebp),%eax
  802ed2:	89 c2                	mov    %eax,%edx
  802ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed7:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edd:	e9 15 04 00 00       	jmp    8032f7 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ee2:	a1 40 51 80 00       	mov    0x805140,%eax
  802ee7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eee:	74 07                	je     802ef7 <alloc_block_NF+0x1cb>
  802ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef3:	8b 00                	mov    (%eax),%eax
  802ef5:	eb 05                	jmp    802efc <alloc_block_NF+0x1d0>
  802ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  802efc:	a3 40 51 80 00       	mov    %eax,0x805140
  802f01:	a1 40 51 80 00       	mov    0x805140,%eax
  802f06:	85 c0                	test   %eax,%eax
  802f08:	0f 85 3e fe ff ff    	jne    802d4c <alloc_block_NF+0x20>
  802f0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f12:	0f 85 34 fe ff ff    	jne    802d4c <alloc_block_NF+0x20>
  802f18:	e9 d5 03 00 00       	jmp    8032f2 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f1d:	a1 38 51 80 00       	mov    0x805138,%eax
  802f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f25:	e9 b1 01 00 00       	jmp    8030db <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	8b 50 08             	mov    0x8(%eax),%edx
  802f30:	a1 28 50 80 00       	mov    0x805028,%eax
  802f35:	39 c2                	cmp    %eax,%edx
  802f37:	0f 82 96 01 00 00    	jb     8030d3 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	8b 40 0c             	mov    0xc(%eax),%eax
  802f43:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f46:	0f 82 87 01 00 00    	jb     8030d3 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f52:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f55:	0f 85 95 00 00 00    	jne    802ff0 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5f:	75 17                	jne    802f78 <alloc_block_NF+0x24c>
  802f61:	83 ec 04             	sub    $0x4,%esp
  802f64:	68 b8 46 80 00       	push   $0x8046b8
  802f69:	68 fc 00 00 00       	push   $0xfc
  802f6e:	68 0f 46 80 00       	push   $0x80460f
  802f73:	e8 af da ff ff       	call   800a27 <_panic>
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 00                	mov    (%eax),%eax
  802f7d:	85 c0                	test   %eax,%eax
  802f7f:	74 10                	je     802f91 <alloc_block_NF+0x265>
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	8b 00                	mov    (%eax),%eax
  802f86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f89:	8b 52 04             	mov    0x4(%edx),%edx
  802f8c:	89 50 04             	mov    %edx,0x4(%eax)
  802f8f:	eb 0b                	jmp    802f9c <alloc_block_NF+0x270>
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	8b 40 04             	mov    0x4(%eax),%eax
  802f97:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9f:	8b 40 04             	mov    0x4(%eax),%eax
  802fa2:	85 c0                	test   %eax,%eax
  802fa4:	74 0f                	je     802fb5 <alloc_block_NF+0x289>
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	8b 40 04             	mov    0x4(%eax),%eax
  802fac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802faf:	8b 12                	mov    (%edx),%edx
  802fb1:	89 10                	mov    %edx,(%eax)
  802fb3:	eb 0a                	jmp    802fbf <alloc_block_NF+0x293>
  802fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb8:	8b 00                	mov    (%eax),%eax
  802fba:	a3 38 51 80 00       	mov    %eax,0x805138
  802fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd2:	a1 44 51 80 00       	mov    0x805144,%eax
  802fd7:	48                   	dec    %eax
  802fd8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	8b 40 08             	mov    0x8(%eax),%eax
  802fe3:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802feb:	e9 07 03 00 00       	jmp    8032f7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ff9:	0f 86 d4 00 00 00    	jbe    8030d3 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fff:	a1 48 51 80 00       	mov    0x805148,%eax
  803004:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300a:	8b 50 08             	mov    0x8(%eax),%edx
  80300d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803010:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803013:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803016:	8b 55 08             	mov    0x8(%ebp),%edx
  803019:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80301c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803020:	75 17                	jne    803039 <alloc_block_NF+0x30d>
  803022:	83 ec 04             	sub    $0x4,%esp
  803025:	68 b8 46 80 00       	push   $0x8046b8
  80302a:	68 04 01 00 00       	push   $0x104
  80302f:	68 0f 46 80 00       	push   $0x80460f
  803034:	e8 ee d9 ff ff       	call   800a27 <_panic>
  803039:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303c:	8b 00                	mov    (%eax),%eax
  80303e:	85 c0                	test   %eax,%eax
  803040:	74 10                	je     803052 <alloc_block_NF+0x326>
  803042:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803045:	8b 00                	mov    (%eax),%eax
  803047:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80304a:	8b 52 04             	mov    0x4(%edx),%edx
  80304d:	89 50 04             	mov    %edx,0x4(%eax)
  803050:	eb 0b                	jmp    80305d <alloc_block_NF+0x331>
  803052:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803055:	8b 40 04             	mov    0x4(%eax),%eax
  803058:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80305d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803060:	8b 40 04             	mov    0x4(%eax),%eax
  803063:	85 c0                	test   %eax,%eax
  803065:	74 0f                	je     803076 <alloc_block_NF+0x34a>
  803067:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306a:	8b 40 04             	mov    0x4(%eax),%eax
  80306d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803070:	8b 12                	mov    (%edx),%edx
  803072:	89 10                	mov    %edx,(%eax)
  803074:	eb 0a                	jmp    803080 <alloc_block_NF+0x354>
  803076:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803079:	8b 00                	mov    (%eax),%eax
  80307b:	a3 48 51 80 00       	mov    %eax,0x805148
  803080:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803083:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803089:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803093:	a1 54 51 80 00       	mov    0x805154,%eax
  803098:	48                   	dec    %eax
  803099:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80309e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a1:	8b 40 08             	mov    0x8(%eax),%eax
  8030a4:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	8b 50 08             	mov    0x8(%eax),%edx
  8030af:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b2:	01 c2                	add    %eax,%edx
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8030ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c0:	2b 45 08             	sub    0x8(%ebp),%eax
  8030c3:	89 c2                	mov    %eax,%edx
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8030cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ce:	e9 24 02 00 00       	jmp    8032f7 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030d3:	a1 40 51 80 00       	mov    0x805140,%eax
  8030d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030df:	74 07                	je     8030e8 <alloc_block_NF+0x3bc>
  8030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e4:	8b 00                	mov    (%eax),%eax
  8030e6:	eb 05                	jmp    8030ed <alloc_block_NF+0x3c1>
  8030e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ed:	a3 40 51 80 00       	mov    %eax,0x805140
  8030f2:	a1 40 51 80 00       	mov    0x805140,%eax
  8030f7:	85 c0                	test   %eax,%eax
  8030f9:	0f 85 2b fe ff ff    	jne    802f2a <alloc_block_NF+0x1fe>
  8030ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803103:	0f 85 21 fe ff ff    	jne    802f2a <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803109:	a1 38 51 80 00       	mov    0x805138,%eax
  80310e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803111:	e9 ae 01 00 00       	jmp    8032c4 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803119:	8b 50 08             	mov    0x8(%eax),%edx
  80311c:	a1 28 50 80 00       	mov    0x805028,%eax
  803121:	39 c2                	cmp    %eax,%edx
  803123:	0f 83 93 01 00 00    	jae    8032bc <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312c:	8b 40 0c             	mov    0xc(%eax),%eax
  80312f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803132:	0f 82 84 01 00 00    	jb     8032bc <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313b:	8b 40 0c             	mov    0xc(%eax),%eax
  80313e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803141:	0f 85 95 00 00 00    	jne    8031dc <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803147:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80314b:	75 17                	jne    803164 <alloc_block_NF+0x438>
  80314d:	83 ec 04             	sub    $0x4,%esp
  803150:	68 b8 46 80 00       	push   $0x8046b8
  803155:	68 14 01 00 00       	push   $0x114
  80315a:	68 0f 46 80 00       	push   $0x80460f
  80315f:	e8 c3 d8 ff ff       	call   800a27 <_panic>
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	85 c0                	test   %eax,%eax
  80316b:	74 10                	je     80317d <alloc_block_NF+0x451>
  80316d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803170:	8b 00                	mov    (%eax),%eax
  803172:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803175:	8b 52 04             	mov    0x4(%edx),%edx
  803178:	89 50 04             	mov    %edx,0x4(%eax)
  80317b:	eb 0b                	jmp    803188 <alloc_block_NF+0x45c>
  80317d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803180:	8b 40 04             	mov    0x4(%eax),%eax
  803183:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318b:	8b 40 04             	mov    0x4(%eax),%eax
  80318e:	85 c0                	test   %eax,%eax
  803190:	74 0f                	je     8031a1 <alloc_block_NF+0x475>
  803192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803195:	8b 40 04             	mov    0x4(%eax),%eax
  803198:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80319b:	8b 12                	mov    (%edx),%edx
  80319d:	89 10                	mov    %edx,(%eax)
  80319f:	eb 0a                	jmp    8031ab <alloc_block_NF+0x47f>
  8031a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a4:	8b 00                	mov    (%eax),%eax
  8031a6:	a3 38 51 80 00       	mov    %eax,0x805138
  8031ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031be:	a1 44 51 80 00       	mov    0x805144,%eax
  8031c3:	48                   	dec    %eax
  8031c4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8031c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cc:	8b 40 08             	mov    0x8(%eax),%eax
  8031cf:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8031d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d7:	e9 1b 01 00 00       	jmp    8032f7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e5:	0f 86 d1 00 00 00    	jbe    8032bc <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8031eb:	a1 48 51 80 00       	mov    0x805148,%eax
  8031f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8031f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f6:	8b 50 08             	mov    0x8(%eax),%edx
  8031f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fc:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8031ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803202:	8b 55 08             	mov    0x8(%ebp),%edx
  803205:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803208:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80320c:	75 17                	jne    803225 <alloc_block_NF+0x4f9>
  80320e:	83 ec 04             	sub    $0x4,%esp
  803211:	68 b8 46 80 00       	push   $0x8046b8
  803216:	68 1c 01 00 00       	push   $0x11c
  80321b:	68 0f 46 80 00       	push   $0x80460f
  803220:	e8 02 d8 ff ff       	call   800a27 <_panic>
  803225:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803228:	8b 00                	mov    (%eax),%eax
  80322a:	85 c0                	test   %eax,%eax
  80322c:	74 10                	je     80323e <alloc_block_NF+0x512>
  80322e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803231:	8b 00                	mov    (%eax),%eax
  803233:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803236:	8b 52 04             	mov    0x4(%edx),%edx
  803239:	89 50 04             	mov    %edx,0x4(%eax)
  80323c:	eb 0b                	jmp    803249 <alloc_block_NF+0x51d>
  80323e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803241:	8b 40 04             	mov    0x4(%eax),%eax
  803244:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803249:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324c:	8b 40 04             	mov    0x4(%eax),%eax
  80324f:	85 c0                	test   %eax,%eax
  803251:	74 0f                	je     803262 <alloc_block_NF+0x536>
  803253:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803256:	8b 40 04             	mov    0x4(%eax),%eax
  803259:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80325c:	8b 12                	mov    (%edx),%edx
  80325e:	89 10                	mov    %edx,(%eax)
  803260:	eb 0a                	jmp    80326c <alloc_block_NF+0x540>
  803262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803265:	8b 00                	mov    (%eax),%eax
  803267:	a3 48 51 80 00       	mov    %eax,0x805148
  80326c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803278:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327f:	a1 54 51 80 00       	mov    0x805154,%eax
  803284:	48                   	dec    %eax
  803285:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80328a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328d:	8b 40 08             	mov    0x8(%eax),%eax
  803290:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803298:	8b 50 08             	mov    0x8(%eax),%edx
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	01 c2                	add    %eax,%edx
  8032a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ac:	2b 45 08             	sub    0x8(%ebp),%eax
  8032af:	89 c2                	mov    %eax,%edx
  8032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8032b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ba:	eb 3b                	jmp    8032f7 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8032bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8032c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c8:	74 07                	je     8032d1 <alloc_block_NF+0x5a5>
  8032ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cd:	8b 00                	mov    (%eax),%eax
  8032cf:	eb 05                	jmp    8032d6 <alloc_block_NF+0x5aa>
  8032d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d6:	a3 40 51 80 00       	mov    %eax,0x805140
  8032db:	a1 40 51 80 00       	mov    0x805140,%eax
  8032e0:	85 c0                	test   %eax,%eax
  8032e2:	0f 85 2e fe ff ff    	jne    803116 <alloc_block_NF+0x3ea>
  8032e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ec:	0f 85 24 fe ff ff    	jne    803116 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8032f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032f7:	c9                   	leave  
  8032f8:	c3                   	ret    

008032f9 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8032f9:	55                   	push   %ebp
  8032fa:	89 e5                	mov    %esp,%ebp
  8032fc:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8032ff:	a1 38 51 80 00       	mov    0x805138,%eax
  803304:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803307:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80330c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80330f:	a1 38 51 80 00       	mov    0x805138,%eax
  803314:	85 c0                	test   %eax,%eax
  803316:	74 14                	je     80332c <insert_sorted_with_merge_freeList+0x33>
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	8b 50 08             	mov    0x8(%eax),%edx
  80331e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803321:	8b 40 08             	mov    0x8(%eax),%eax
  803324:	39 c2                	cmp    %eax,%edx
  803326:	0f 87 9b 01 00 00    	ja     8034c7 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80332c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803330:	75 17                	jne    803349 <insert_sorted_with_merge_freeList+0x50>
  803332:	83 ec 04             	sub    $0x4,%esp
  803335:	68 ec 45 80 00       	push   $0x8045ec
  80333a:	68 38 01 00 00       	push   $0x138
  80333f:	68 0f 46 80 00       	push   $0x80460f
  803344:	e8 de d6 ff ff       	call   800a27 <_panic>
  803349:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80334f:	8b 45 08             	mov    0x8(%ebp),%eax
  803352:	89 10                	mov    %edx,(%eax)
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	8b 00                	mov    (%eax),%eax
  803359:	85 c0                	test   %eax,%eax
  80335b:	74 0d                	je     80336a <insert_sorted_with_merge_freeList+0x71>
  80335d:	a1 38 51 80 00       	mov    0x805138,%eax
  803362:	8b 55 08             	mov    0x8(%ebp),%edx
  803365:	89 50 04             	mov    %edx,0x4(%eax)
  803368:	eb 08                	jmp    803372 <insert_sorted_with_merge_freeList+0x79>
  80336a:	8b 45 08             	mov    0x8(%ebp),%eax
  80336d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	a3 38 51 80 00       	mov    %eax,0x805138
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803384:	a1 44 51 80 00       	mov    0x805144,%eax
  803389:	40                   	inc    %eax
  80338a:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80338f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803393:	0f 84 a8 06 00 00    	je     803a41 <insert_sorted_with_merge_freeList+0x748>
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	8b 50 08             	mov    0x8(%eax),%edx
  80339f:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a5:	01 c2                	add    %eax,%edx
  8033a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033aa:	8b 40 08             	mov    0x8(%eax),%eax
  8033ad:	39 c2                	cmp    %eax,%edx
  8033af:	0f 85 8c 06 00 00    	jne    803a41 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	8b 50 0c             	mov    0xc(%eax),%edx
  8033bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033be:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c1:	01 c2                	add    %eax,%edx
  8033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c6:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8033c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033cd:	75 17                	jne    8033e6 <insert_sorted_with_merge_freeList+0xed>
  8033cf:	83 ec 04             	sub    $0x4,%esp
  8033d2:	68 b8 46 80 00       	push   $0x8046b8
  8033d7:	68 3c 01 00 00       	push   $0x13c
  8033dc:	68 0f 46 80 00       	push   $0x80460f
  8033e1:	e8 41 d6 ff ff       	call   800a27 <_panic>
  8033e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e9:	8b 00                	mov    (%eax),%eax
  8033eb:	85 c0                	test   %eax,%eax
  8033ed:	74 10                	je     8033ff <insert_sorted_with_merge_freeList+0x106>
  8033ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f2:	8b 00                	mov    (%eax),%eax
  8033f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033f7:	8b 52 04             	mov    0x4(%edx),%edx
  8033fa:	89 50 04             	mov    %edx,0x4(%eax)
  8033fd:	eb 0b                	jmp    80340a <insert_sorted_with_merge_freeList+0x111>
  8033ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803402:	8b 40 04             	mov    0x4(%eax),%eax
  803405:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80340a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340d:	8b 40 04             	mov    0x4(%eax),%eax
  803410:	85 c0                	test   %eax,%eax
  803412:	74 0f                	je     803423 <insert_sorted_with_merge_freeList+0x12a>
  803414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803417:	8b 40 04             	mov    0x4(%eax),%eax
  80341a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80341d:	8b 12                	mov    (%edx),%edx
  80341f:	89 10                	mov    %edx,(%eax)
  803421:	eb 0a                	jmp    80342d <insert_sorted_with_merge_freeList+0x134>
  803423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803426:	8b 00                	mov    (%eax),%eax
  803428:	a3 38 51 80 00       	mov    %eax,0x805138
  80342d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803430:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803439:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803440:	a1 44 51 80 00       	mov    0x805144,%eax
  803445:	48                   	dec    %eax
  803446:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80344b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803458:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80345f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803463:	75 17                	jne    80347c <insert_sorted_with_merge_freeList+0x183>
  803465:	83 ec 04             	sub    $0x4,%esp
  803468:	68 ec 45 80 00       	push   $0x8045ec
  80346d:	68 3f 01 00 00       	push   $0x13f
  803472:	68 0f 46 80 00       	push   $0x80460f
  803477:	e8 ab d5 ff ff       	call   800a27 <_panic>
  80347c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803485:	89 10                	mov    %edx,(%eax)
  803487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348a:	8b 00                	mov    (%eax),%eax
  80348c:	85 c0                	test   %eax,%eax
  80348e:	74 0d                	je     80349d <insert_sorted_with_merge_freeList+0x1a4>
  803490:	a1 48 51 80 00       	mov    0x805148,%eax
  803495:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803498:	89 50 04             	mov    %edx,0x4(%eax)
  80349b:	eb 08                	jmp    8034a5 <insert_sorted_with_merge_freeList+0x1ac>
  80349d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a8:	a3 48 51 80 00       	mov    %eax,0x805148
  8034ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b7:	a1 54 51 80 00       	mov    0x805154,%eax
  8034bc:	40                   	inc    %eax
  8034bd:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034c2:	e9 7a 05 00 00       	jmp    803a41 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8034c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ca:	8b 50 08             	mov    0x8(%eax),%edx
  8034cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d0:	8b 40 08             	mov    0x8(%eax),%eax
  8034d3:	39 c2                	cmp    %eax,%edx
  8034d5:	0f 82 14 01 00 00    	jb     8035ef <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8034db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034de:	8b 50 08             	mov    0x8(%eax),%edx
  8034e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e7:	01 c2                	add    %eax,%edx
  8034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ec:	8b 40 08             	mov    0x8(%eax),%eax
  8034ef:	39 c2                	cmp    %eax,%edx
  8034f1:	0f 85 90 00 00 00    	jne    803587 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8034f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034fa:	8b 50 0c             	mov    0xc(%eax),%edx
  8034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803500:	8b 40 0c             	mov    0xc(%eax),%eax
  803503:	01 c2                	add    %eax,%edx
  803505:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803508:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80350b:	8b 45 08             	mov    0x8(%ebp),%eax
  80350e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803515:	8b 45 08             	mov    0x8(%ebp),%eax
  803518:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80351f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803523:	75 17                	jne    80353c <insert_sorted_with_merge_freeList+0x243>
  803525:	83 ec 04             	sub    $0x4,%esp
  803528:	68 ec 45 80 00       	push   $0x8045ec
  80352d:	68 49 01 00 00       	push   $0x149
  803532:	68 0f 46 80 00       	push   $0x80460f
  803537:	e8 eb d4 ff ff       	call   800a27 <_panic>
  80353c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	89 10                	mov    %edx,(%eax)
  803547:	8b 45 08             	mov    0x8(%ebp),%eax
  80354a:	8b 00                	mov    (%eax),%eax
  80354c:	85 c0                	test   %eax,%eax
  80354e:	74 0d                	je     80355d <insert_sorted_with_merge_freeList+0x264>
  803550:	a1 48 51 80 00       	mov    0x805148,%eax
  803555:	8b 55 08             	mov    0x8(%ebp),%edx
  803558:	89 50 04             	mov    %edx,0x4(%eax)
  80355b:	eb 08                	jmp    803565 <insert_sorted_with_merge_freeList+0x26c>
  80355d:	8b 45 08             	mov    0x8(%ebp),%eax
  803560:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803565:	8b 45 08             	mov    0x8(%ebp),%eax
  803568:	a3 48 51 80 00       	mov    %eax,0x805148
  80356d:	8b 45 08             	mov    0x8(%ebp),%eax
  803570:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803577:	a1 54 51 80 00       	mov    0x805154,%eax
  80357c:	40                   	inc    %eax
  80357d:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803582:	e9 bb 04 00 00       	jmp    803a42 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803587:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80358b:	75 17                	jne    8035a4 <insert_sorted_with_merge_freeList+0x2ab>
  80358d:	83 ec 04             	sub    $0x4,%esp
  803590:	68 60 46 80 00       	push   $0x804660
  803595:	68 4c 01 00 00       	push   $0x14c
  80359a:	68 0f 46 80 00       	push   $0x80460f
  80359f:	e8 83 d4 ff ff       	call   800a27 <_panic>
  8035a4:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8035aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ad:	89 50 04             	mov    %edx,0x4(%eax)
  8035b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b3:	8b 40 04             	mov    0x4(%eax),%eax
  8035b6:	85 c0                	test   %eax,%eax
  8035b8:	74 0c                	je     8035c6 <insert_sorted_with_merge_freeList+0x2cd>
  8035ba:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c2:	89 10                	mov    %edx,(%eax)
  8035c4:	eb 08                	jmp    8035ce <insert_sorted_with_merge_freeList+0x2d5>
  8035c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c9:	a3 38 51 80 00       	mov    %eax,0x805138
  8035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035df:	a1 44 51 80 00       	mov    0x805144,%eax
  8035e4:	40                   	inc    %eax
  8035e5:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035ea:	e9 53 04 00 00       	jmp    803a42 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8035f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035f7:	e9 15 04 00 00       	jmp    803a11 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8035fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ff:	8b 00                	mov    (%eax),%eax
  803601:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803604:	8b 45 08             	mov    0x8(%ebp),%eax
  803607:	8b 50 08             	mov    0x8(%eax),%edx
  80360a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360d:	8b 40 08             	mov    0x8(%eax),%eax
  803610:	39 c2                	cmp    %eax,%edx
  803612:	0f 86 f1 03 00 00    	jbe    803a09 <insert_sorted_with_merge_freeList+0x710>
  803618:	8b 45 08             	mov    0x8(%ebp),%eax
  80361b:	8b 50 08             	mov    0x8(%eax),%edx
  80361e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803621:	8b 40 08             	mov    0x8(%eax),%eax
  803624:	39 c2                	cmp    %eax,%edx
  803626:	0f 83 dd 03 00 00    	jae    803a09 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80362c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362f:	8b 50 08             	mov    0x8(%eax),%edx
  803632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803635:	8b 40 0c             	mov    0xc(%eax),%eax
  803638:	01 c2                	add    %eax,%edx
  80363a:	8b 45 08             	mov    0x8(%ebp),%eax
  80363d:	8b 40 08             	mov    0x8(%eax),%eax
  803640:	39 c2                	cmp    %eax,%edx
  803642:	0f 85 b9 01 00 00    	jne    803801 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803648:	8b 45 08             	mov    0x8(%ebp),%eax
  80364b:	8b 50 08             	mov    0x8(%eax),%edx
  80364e:	8b 45 08             	mov    0x8(%ebp),%eax
  803651:	8b 40 0c             	mov    0xc(%eax),%eax
  803654:	01 c2                	add    %eax,%edx
  803656:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803659:	8b 40 08             	mov    0x8(%eax),%eax
  80365c:	39 c2                	cmp    %eax,%edx
  80365e:	0f 85 0d 01 00 00    	jne    803771 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803667:	8b 50 0c             	mov    0xc(%eax),%edx
  80366a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366d:	8b 40 0c             	mov    0xc(%eax),%eax
  803670:	01 c2                	add    %eax,%edx
  803672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803675:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803678:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80367c:	75 17                	jne    803695 <insert_sorted_with_merge_freeList+0x39c>
  80367e:	83 ec 04             	sub    $0x4,%esp
  803681:	68 b8 46 80 00       	push   $0x8046b8
  803686:	68 5c 01 00 00       	push   $0x15c
  80368b:	68 0f 46 80 00       	push   $0x80460f
  803690:	e8 92 d3 ff ff       	call   800a27 <_panic>
  803695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803698:	8b 00                	mov    (%eax),%eax
  80369a:	85 c0                	test   %eax,%eax
  80369c:	74 10                	je     8036ae <insert_sorted_with_merge_freeList+0x3b5>
  80369e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a1:	8b 00                	mov    (%eax),%eax
  8036a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036a6:	8b 52 04             	mov    0x4(%edx),%edx
  8036a9:	89 50 04             	mov    %edx,0x4(%eax)
  8036ac:	eb 0b                	jmp    8036b9 <insert_sorted_with_merge_freeList+0x3c0>
  8036ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b1:	8b 40 04             	mov    0x4(%eax),%eax
  8036b4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036bc:	8b 40 04             	mov    0x4(%eax),%eax
  8036bf:	85 c0                	test   %eax,%eax
  8036c1:	74 0f                	je     8036d2 <insert_sorted_with_merge_freeList+0x3d9>
  8036c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c6:	8b 40 04             	mov    0x4(%eax),%eax
  8036c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036cc:	8b 12                	mov    (%edx),%edx
  8036ce:	89 10                	mov    %edx,(%eax)
  8036d0:	eb 0a                	jmp    8036dc <insert_sorted_with_merge_freeList+0x3e3>
  8036d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d5:	8b 00                	mov    (%eax),%eax
  8036d7:	a3 38 51 80 00       	mov    %eax,0x805138
  8036dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8036f4:	48                   	dec    %eax
  8036f5:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8036fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803704:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803707:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80370e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803712:	75 17                	jne    80372b <insert_sorted_with_merge_freeList+0x432>
  803714:	83 ec 04             	sub    $0x4,%esp
  803717:	68 ec 45 80 00       	push   $0x8045ec
  80371c:	68 5f 01 00 00       	push   $0x15f
  803721:	68 0f 46 80 00       	push   $0x80460f
  803726:	e8 fc d2 ff ff       	call   800a27 <_panic>
  80372b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803731:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803734:	89 10                	mov    %edx,(%eax)
  803736:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803739:	8b 00                	mov    (%eax),%eax
  80373b:	85 c0                	test   %eax,%eax
  80373d:	74 0d                	je     80374c <insert_sorted_with_merge_freeList+0x453>
  80373f:	a1 48 51 80 00       	mov    0x805148,%eax
  803744:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803747:	89 50 04             	mov    %edx,0x4(%eax)
  80374a:	eb 08                	jmp    803754 <insert_sorted_with_merge_freeList+0x45b>
  80374c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803754:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803757:	a3 48 51 80 00       	mov    %eax,0x805148
  80375c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80375f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803766:	a1 54 51 80 00       	mov    0x805154,%eax
  80376b:	40                   	inc    %eax
  80376c:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803774:	8b 50 0c             	mov    0xc(%eax),%edx
  803777:	8b 45 08             	mov    0x8(%ebp),%eax
  80377a:	8b 40 0c             	mov    0xc(%eax),%eax
  80377d:	01 c2                	add    %eax,%edx
  80377f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803782:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803785:	8b 45 08             	mov    0x8(%ebp),%eax
  803788:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80378f:	8b 45 08             	mov    0x8(%ebp),%eax
  803792:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803799:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80379d:	75 17                	jne    8037b6 <insert_sorted_with_merge_freeList+0x4bd>
  80379f:	83 ec 04             	sub    $0x4,%esp
  8037a2:	68 ec 45 80 00       	push   $0x8045ec
  8037a7:	68 64 01 00 00       	push   $0x164
  8037ac:	68 0f 46 80 00       	push   $0x80460f
  8037b1:	e8 71 d2 ff ff       	call   800a27 <_panic>
  8037b6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bf:	89 10                	mov    %edx,(%eax)
  8037c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c4:	8b 00                	mov    (%eax),%eax
  8037c6:	85 c0                	test   %eax,%eax
  8037c8:	74 0d                	je     8037d7 <insert_sorted_with_merge_freeList+0x4de>
  8037ca:	a1 48 51 80 00       	mov    0x805148,%eax
  8037cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8037d2:	89 50 04             	mov    %edx,0x4(%eax)
  8037d5:	eb 08                	jmp    8037df <insert_sorted_with_merge_freeList+0x4e6>
  8037d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037da:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037df:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e2:	a3 48 51 80 00       	mov    %eax,0x805148
  8037e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f1:	a1 54 51 80 00       	mov    0x805154,%eax
  8037f6:	40                   	inc    %eax
  8037f7:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8037fc:	e9 41 02 00 00       	jmp    803a42 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803801:	8b 45 08             	mov    0x8(%ebp),%eax
  803804:	8b 50 08             	mov    0x8(%eax),%edx
  803807:	8b 45 08             	mov    0x8(%ebp),%eax
  80380a:	8b 40 0c             	mov    0xc(%eax),%eax
  80380d:	01 c2                	add    %eax,%edx
  80380f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803812:	8b 40 08             	mov    0x8(%eax),%eax
  803815:	39 c2                	cmp    %eax,%edx
  803817:	0f 85 7c 01 00 00    	jne    803999 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80381d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803821:	74 06                	je     803829 <insert_sorted_with_merge_freeList+0x530>
  803823:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803827:	75 17                	jne    803840 <insert_sorted_with_merge_freeList+0x547>
  803829:	83 ec 04             	sub    $0x4,%esp
  80382c:	68 28 46 80 00       	push   $0x804628
  803831:	68 69 01 00 00       	push   $0x169
  803836:	68 0f 46 80 00       	push   $0x80460f
  80383b:	e8 e7 d1 ff ff       	call   800a27 <_panic>
  803840:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803843:	8b 50 04             	mov    0x4(%eax),%edx
  803846:	8b 45 08             	mov    0x8(%ebp),%eax
  803849:	89 50 04             	mov    %edx,0x4(%eax)
  80384c:	8b 45 08             	mov    0x8(%ebp),%eax
  80384f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803852:	89 10                	mov    %edx,(%eax)
  803854:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803857:	8b 40 04             	mov    0x4(%eax),%eax
  80385a:	85 c0                	test   %eax,%eax
  80385c:	74 0d                	je     80386b <insert_sorted_with_merge_freeList+0x572>
  80385e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803861:	8b 40 04             	mov    0x4(%eax),%eax
  803864:	8b 55 08             	mov    0x8(%ebp),%edx
  803867:	89 10                	mov    %edx,(%eax)
  803869:	eb 08                	jmp    803873 <insert_sorted_with_merge_freeList+0x57a>
  80386b:	8b 45 08             	mov    0x8(%ebp),%eax
  80386e:	a3 38 51 80 00       	mov    %eax,0x805138
  803873:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803876:	8b 55 08             	mov    0x8(%ebp),%edx
  803879:	89 50 04             	mov    %edx,0x4(%eax)
  80387c:	a1 44 51 80 00       	mov    0x805144,%eax
  803881:	40                   	inc    %eax
  803882:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803887:	8b 45 08             	mov    0x8(%ebp),%eax
  80388a:	8b 50 0c             	mov    0xc(%eax),%edx
  80388d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803890:	8b 40 0c             	mov    0xc(%eax),%eax
  803893:	01 c2                	add    %eax,%edx
  803895:	8b 45 08             	mov    0x8(%ebp),%eax
  803898:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80389b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80389f:	75 17                	jne    8038b8 <insert_sorted_with_merge_freeList+0x5bf>
  8038a1:	83 ec 04             	sub    $0x4,%esp
  8038a4:	68 b8 46 80 00       	push   $0x8046b8
  8038a9:	68 6b 01 00 00       	push   $0x16b
  8038ae:	68 0f 46 80 00       	push   $0x80460f
  8038b3:	e8 6f d1 ff ff       	call   800a27 <_panic>
  8038b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038bb:	8b 00                	mov    (%eax),%eax
  8038bd:	85 c0                	test   %eax,%eax
  8038bf:	74 10                	je     8038d1 <insert_sorted_with_merge_freeList+0x5d8>
  8038c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c4:	8b 00                	mov    (%eax),%eax
  8038c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038c9:	8b 52 04             	mov    0x4(%edx),%edx
  8038cc:	89 50 04             	mov    %edx,0x4(%eax)
  8038cf:	eb 0b                	jmp    8038dc <insert_sorted_with_merge_freeList+0x5e3>
  8038d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d4:	8b 40 04             	mov    0x4(%eax),%eax
  8038d7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038df:	8b 40 04             	mov    0x4(%eax),%eax
  8038e2:	85 c0                	test   %eax,%eax
  8038e4:	74 0f                	je     8038f5 <insert_sorted_with_merge_freeList+0x5fc>
  8038e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e9:	8b 40 04             	mov    0x4(%eax),%eax
  8038ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038ef:	8b 12                	mov    (%edx),%edx
  8038f1:	89 10                	mov    %edx,(%eax)
  8038f3:	eb 0a                	jmp    8038ff <insert_sorted_with_merge_freeList+0x606>
  8038f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f8:	8b 00                	mov    (%eax),%eax
  8038fa:	a3 38 51 80 00       	mov    %eax,0x805138
  8038ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803902:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803912:	a1 44 51 80 00       	mov    0x805144,%eax
  803917:	48                   	dec    %eax
  803918:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80391d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803920:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803927:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803931:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803935:	75 17                	jne    80394e <insert_sorted_with_merge_freeList+0x655>
  803937:	83 ec 04             	sub    $0x4,%esp
  80393a:	68 ec 45 80 00       	push   $0x8045ec
  80393f:	68 6e 01 00 00       	push   $0x16e
  803944:	68 0f 46 80 00       	push   $0x80460f
  803949:	e8 d9 d0 ff ff       	call   800a27 <_panic>
  80394e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803954:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803957:	89 10                	mov    %edx,(%eax)
  803959:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80395c:	8b 00                	mov    (%eax),%eax
  80395e:	85 c0                	test   %eax,%eax
  803960:	74 0d                	je     80396f <insert_sorted_with_merge_freeList+0x676>
  803962:	a1 48 51 80 00       	mov    0x805148,%eax
  803967:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80396a:	89 50 04             	mov    %edx,0x4(%eax)
  80396d:	eb 08                	jmp    803977 <insert_sorted_with_merge_freeList+0x67e>
  80396f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803972:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803977:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397a:	a3 48 51 80 00       	mov    %eax,0x805148
  80397f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803982:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803989:	a1 54 51 80 00       	mov    0x805154,%eax
  80398e:	40                   	inc    %eax
  80398f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803994:	e9 a9 00 00 00       	jmp    803a42 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803999:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80399d:	74 06                	je     8039a5 <insert_sorted_with_merge_freeList+0x6ac>
  80399f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039a3:	75 17                	jne    8039bc <insert_sorted_with_merge_freeList+0x6c3>
  8039a5:	83 ec 04             	sub    $0x4,%esp
  8039a8:	68 84 46 80 00       	push   $0x804684
  8039ad:	68 73 01 00 00       	push   $0x173
  8039b2:	68 0f 46 80 00       	push   $0x80460f
  8039b7:	e8 6b d0 ff ff       	call   800a27 <_panic>
  8039bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bf:	8b 10                	mov    (%eax),%edx
  8039c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c4:	89 10                	mov    %edx,(%eax)
  8039c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c9:	8b 00                	mov    (%eax),%eax
  8039cb:	85 c0                	test   %eax,%eax
  8039cd:	74 0b                	je     8039da <insert_sorted_with_merge_freeList+0x6e1>
  8039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d2:	8b 00                	mov    (%eax),%eax
  8039d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8039d7:	89 50 04             	mov    %edx,0x4(%eax)
  8039da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8039e0:	89 10                	mov    %edx,(%eax)
  8039e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039e8:	89 50 04             	mov    %edx,0x4(%eax)
  8039eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ee:	8b 00                	mov    (%eax),%eax
  8039f0:	85 c0                	test   %eax,%eax
  8039f2:	75 08                	jne    8039fc <insert_sorted_with_merge_freeList+0x703>
  8039f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039fc:	a1 44 51 80 00       	mov    0x805144,%eax
  803a01:	40                   	inc    %eax
  803a02:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803a07:	eb 39                	jmp    803a42 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803a09:	a1 40 51 80 00       	mov    0x805140,%eax
  803a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a15:	74 07                	je     803a1e <insert_sorted_with_merge_freeList+0x725>
  803a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1a:	8b 00                	mov    (%eax),%eax
  803a1c:	eb 05                	jmp    803a23 <insert_sorted_with_merge_freeList+0x72a>
  803a1e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a23:	a3 40 51 80 00       	mov    %eax,0x805140
  803a28:	a1 40 51 80 00       	mov    0x805140,%eax
  803a2d:	85 c0                	test   %eax,%eax
  803a2f:	0f 85 c7 fb ff ff    	jne    8035fc <insert_sorted_with_merge_freeList+0x303>
  803a35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a39:	0f 85 bd fb ff ff    	jne    8035fc <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a3f:	eb 01                	jmp    803a42 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803a41:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a42:	90                   	nop
  803a43:	c9                   	leave  
  803a44:	c3                   	ret    
  803a45:	66 90                	xchg   %ax,%ax
  803a47:	90                   	nop

00803a48 <__udivdi3>:
  803a48:	55                   	push   %ebp
  803a49:	57                   	push   %edi
  803a4a:	56                   	push   %esi
  803a4b:	53                   	push   %ebx
  803a4c:	83 ec 1c             	sub    $0x1c,%esp
  803a4f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a53:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a5f:	89 ca                	mov    %ecx,%edx
  803a61:	89 f8                	mov    %edi,%eax
  803a63:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a67:	85 f6                	test   %esi,%esi
  803a69:	75 2d                	jne    803a98 <__udivdi3+0x50>
  803a6b:	39 cf                	cmp    %ecx,%edi
  803a6d:	77 65                	ja     803ad4 <__udivdi3+0x8c>
  803a6f:	89 fd                	mov    %edi,%ebp
  803a71:	85 ff                	test   %edi,%edi
  803a73:	75 0b                	jne    803a80 <__udivdi3+0x38>
  803a75:	b8 01 00 00 00       	mov    $0x1,%eax
  803a7a:	31 d2                	xor    %edx,%edx
  803a7c:	f7 f7                	div    %edi
  803a7e:	89 c5                	mov    %eax,%ebp
  803a80:	31 d2                	xor    %edx,%edx
  803a82:	89 c8                	mov    %ecx,%eax
  803a84:	f7 f5                	div    %ebp
  803a86:	89 c1                	mov    %eax,%ecx
  803a88:	89 d8                	mov    %ebx,%eax
  803a8a:	f7 f5                	div    %ebp
  803a8c:	89 cf                	mov    %ecx,%edi
  803a8e:	89 fa                	mov    %edi,%edx
  803a90:	83 c4 1c             	add    $0x1c,%esp
  803a93:	5b                   	pop    %ebx
  803a94:	5e                   	pop    %esi
  803a95:	5f                   	pop    %edi
  803a96:	5d                   	pop    %ebp
  803a97:	c3                   	ret    
  803a98:	39 ce                	cmp    %ecx,%esi
  803a9a:	77 28                	ja     803ac4 <__udivdi3+0x7c>
  803a9c:	0f bd fe             	bsr    %esi,%edi
  803a9f:	83 f7 1f             	xor    $0x1f,%edi
  803aa2:	75 40                	jne    803ae4 <__udivdi3+0x9c>
  803aa4:	39 ce                	cmp    %ecx,%esi
  803aa6:	72 0a                	jb     803ab2 <__udivdi3+0x6a>
  803aa8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803aac:	0f 87 9e 00 00 00    	ja     803b50 <__udivdi3+0x108>
  803ab2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ab7:	89 fa                	mov    %edi,%edx
  803ab9:	83 c4 1c             	add    $0x1c,%esp
  803abc:	5b                   	pop    %ebx
  803abd:	5e                   	pop    %esi
  803abe:	5f                   	pop    %edi
  803abf:	5d                   	pop    %ebp
  803ac0:	c3                   	ret    
  803ac1:	8d 76 00             	lea    0x0(%esi),%esi
  803ac4:	31 ff                	xor    %edi,%edi
  803ac6:	31 c0                	xor    %eax,%eax
  803ac8:	89 fa                	mov    %edi,%edx
  803aca:	83 c4 1c             	add    $0x1c,%esp
  803acd:	5b                   	pop    %ebx
  803ace:	5e                   	pop    %esi
  803acf:	5f                   	pop    %edi
  803ad0:	5d                   	pop    %ebp
  803ad1:	c3                   	ret    
  803ad2:	66 90                	xchg   %ax,%ax
  803ad4:	89 d8                	mov    %ebx,%eax
  803ad6:	f7 f7                	div    %edi
  803ad8:	31 ff                	xor    %edi,%edi
  803ada:	89 fa                	mov    %edi,%edx
  803adc:	83 c4 1c             	add    $0x1c,%esp
  803adf:	5b                   	pop    %ebx
  803ae0:	5e                   	pop    %esi
  803ae1:	5f                   	pop    %edi
  803ae2:	5d                   	pop    %ebp
  803ae3:	c3                   	ret    
  803ae4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ae9:	89 eb                	mov    %ebp,%ebx
  803aeb:	29 fb                	sub    %edi,%ebx
  803aed:	89 f9                	mov    %edi,%ecx
  803aef:	d3 e6                	shl    %cl,%esi
  803af1:	89 c5                	mov    %eax,%ebp
  803af3:	88 d9                	mov    %bl,%cl
  803af5:	d3 ed                	shr    %cl,%ebp
  803af7:	89 e9                	mov    %ebp,%ecx
  803af9:	09 f1                	or     %esi,%ecx
  803afb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803aff:	89 f9                	mov    %edi,%ecx
  803b01:	d3 e0                	shl    %cl,%eax
  803b03:	89 c5                	mov    %eax,%ebp
  803b05:	89 d6                	mov    %edx,%esi
  803b07:	88 d9                	mov    %bl,%cl
  803b09:	d3 ee                	shr    %cl,%esi
  803b0b:	89 f9                	mov    %edi,%ecx
  803b0d:	d3 e2                	shl    %cl,%edx
  803b0f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b13:	88 d9                	mov    %bl,%cl
  803b15:	d3 e8                	shr    %cl,%eax
  803b17:	09 c2                	or     %eax,%edx
  803b19:	89 d0                	mov    %edx,%eax
  803b1b:	89 f2                	mov    %esi,%edx
  803b1d:	f7 74 24 0c          	divl   0xc(%esp)
  803b21:	89 d6                	mov    %edx,%esi
  803b23:	89 c3                	mov    %eax,%ebx
  803b25:	f7 e5                	mul    %ebp
  803b27:	39 d6                	cmp    %edx,%esi
  803b29:	72 19                	jb     803b44 <__udivdi3+0xfc>
  803b2b:	74 0b                	je     803b38 <__udivdi3+0xf0>
  803b2d:	89 d8                	mov    %ebx,%eax
  803b2f:	31 ff                	xor    %edi,%edi
  803b31:	e9 58 ff ff ff       	jmp    803a8e <__udivdi3+0x46>
  803b36:	66 90                	xchg   %ax,%ax
  803b38:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b3c:	89 f9                	mov    %edi,%ecx
  803b3e:	d3 e2                	shl    %cl,%edx
  803b40:	39 c2                	cmp    %eax,%edx
  803b42:	73 e9                	jae    803b2d <__udivdi3+0xe5>
  803b44:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b47:	31 ff                	xor    %edi,%edi
  803b49:	e9 40 ff ff ff       	jmp    803a8e <__udivdi3+0x46>
  803b4e:	66 90                	xchg   %ax,%ax
  803b50:	31 c0                	xor    %eax,%eax
  803b52:	e9 37 ff ff ff       	jmp    803a8e <__udivdi3+0x46>
  803b57:	90                   	nop

00803b58 <__umoddi3>:
  803b58:	55                   	push   %ebp
  803b59:	57                   	push   %edi
  803b5a:	56                   	push   %esi
  803b5b:	53                   	push   %ebx
  803b5c:	83 ec 1c             	sub    $0x1c,%esp
  803b5f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b63:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b77:	89 f3                	mov    %esi,%ebx
  803b79:	89 fa                	mov    %edi,%edx
  803b7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b7f:	89 34 24             	mov    %esi,(%esp)
  803b82:	85 c0                	test   %eax,%eax
  803b84:	75 1a                	jne    803ba0 <__umoddi3+0x48>
  803b86:	39 f7                	cmp    %esi,%edi
  803b88:	0f 86 a2 00 00 00    	jbe    803c30 <__umoddi3+0xd8>
  803b8e:	89 c8                	mov    %ecx,%eax
  803b90:	89 f2                	mov    %esi,%edx
  803b92:	f7 f7                	div    %edi
  803b94:	89 d0                	mov    %edx,%eax
  803b96:	31 d2                	xor    %edx,%edx
  803b98:	83 c4 1c             	add    $0x1c,%esp
  803b9b:	5b                   	pop    %ebx
  803b9c:	5e                   	pop    %esi
  803b9d:	5f                   	pop    %edi
  803b9e:	5d                   	pop    %ebp
  803b9f:	c3                   	ret    
  803ba0:	39 f0                	cmp    %esi,%eax
  803ba2:	0f 87 ac 00 00 00    	ja     803c54 <__umoddi3+0xfc>
  803ba8:	0f bd e8             	bsr    %eax,%ebp
  803bab:	83 f5 1f             	xor    $0x1f,%ebp
  803bae:	0f 84 ac 00 00 00    	je     803c60 <__umoddi3+0x108>
  803bb4:	bf 20 00 00 00       	mov    $0x20,%edi
  803bb9:	29 ef                	sub    %ebp,%edi
  803bbb:	89 fe                	mov    %edi,%esi
  803bbd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bc1:	89 e9                	mov    %ebp,%ecx
  803bc3:	d3 e0                	shl    %cl,%eax
  803bc5:	89 d7                	mov    %edx,%edi
  803bc7:	89 f1                	mov    %esi,%ecx
  803bc9:	d3 ef                	shr    %cl,%edi
  803bcb:	09 c7                	or     %eax,%edi
  803bcd:	89 e9                	mov    %ebp,%ecx
  803bcf:	d3 e2                	shl    %cl,%edx
  803bd1:	89 14 24             	mov    %edx,(%esp)
  803bd4:	89 d8                	mov    %ebx,%eax
  803bd6:	d3 e0                	shl    %cl,%eax
  803bd8:	89 c2                	mov    %eax,%edx
  803bda:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bde:	d3 e0                	shl    %cl,%eax
  803be0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803be4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803be8:	89 f1                	mov    %esi,%ecx
  803bea:	d3 e8                	shr    %cl,%eax
  803bec:	09 d0                	or     %edx,%eax
  803bee:	d3 eb                	shr    %cl,%ebx
  803bf0:	89 da                	mov    %ebx,%edx
  803bf2:	f7 f7                	div    %edi
  803bf4:	89 d3                	mov    %edx,%ebx
  803bf6:	f7 24 24             	mull   (%esp)
  803bf9:	89 c6                	mov    %eax,%esi
  803bfb:	89 d1                	mov    %edx,%ecx
  803bfd:	39 d3                	cmp    %edx,%ebx
  803bff:	0f 82 87 00 00 00    	jb     803c8c <__umoddi3+0x134>
  803c05:	0f 84 91 00 00 00    	je     803c9c <__umoddi3+0x144>
  803c0b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c0f:	29 f2                	sub    %esi,%edx
  803c11:	19 cb                	sbb    %ecx,%ebx
  803c13:	89 d8                	mov    %ebx,%eax
  803c15:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c19:	d3 e0                	shl    %cl,%eax
  803c1b:	89 e9                	mov    %ebp,%ecx
  803c1d:	d3 ea                	shr    %cl,%edx
  803c1f:	09 d0                	or     %edx,%eax
  803c21:	89 e9                	mov    %ebp,%ecx
  803c23:	d3 eb                	shr    %cl,%ebx
  803c25:	89 da                	mov    %ebx,%edx
  803c27:	83 c4 1c             	add    $0x1c,%esp
  803c2a:	5b                   	pop    %ebx
  803c2b:	5e                   	pop    %esi
  803c2c:	5f                   	pop    %edi
  803c2d:	5d                   	pop    %ebp
  803c2e:	c3                   	ret    
  803c2f:	90                   	nop
  803c30:	89 fd                	mov    %edi,%ebp
  803c32:	85 ff                	test   %edi,%edi
  803c34:	75 0b                	jne    803c41 <__umoddi3+0xe9>
  803c36:	b8 01 00 00 00       	mov    $0x1,%eax
  803c3b:	31 d2                	xor    %edx,%edx
  803c3d:	f7 f7                	div    %edi
  803c3f:	89 c5                	mov    %eax,%ebp
  803c41:	89 f0                	mov    %esi,%eax
  803c43:	31 d2                	xor    %edx,%edx
  803c45:	f7 f5                	div    %ebp
  803c47:	89 c8                	mov    %ecx,%eax
  803c49:	f7 f5                	div    %ebp
  803c4b:	89 d0                	mov    %edx,%eax
  803c4d:	e9 44 ff ff ff       	jmp    803b96 <__umoddi3+0x3e>
  803c52:	66 90                	xchg   %ax,%ax
  803c54:	89 c8                	mov    %ecx,%eax
  803c56:	89 f2                	mov    %esi,%edx
  803c58:	83 c4 1c             	add    $0x1c,%esp
  803c5b:	5b                   	pop    %ebx
  803c5c:	5e                   	pop    %esi
  803c5d:	5f                   	pop    %edi
  803c5e:	5d                   	pop    %ebp
  803c5f:	c3                   	ret    
  803c60:	3b 04 24             	cmp    (%esp),%eax
  803c63:	72 06                	jb     803c6b <__umoddi3+0x113>
  803c65:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c69:	77 0f                	ja     803c7a <__umoddi3+0x122>
  803c6b:	89 f2                	mov    %esi,%edx
  803c6d:	29 f9                	sub    %edi,%ecx
  803c6f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c73:	89 14 24             	mov    %edx,(%esp)
  803c76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c7a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c7e:	8b 14 24             	mov    (%esp),%edx
  803c81:	83 c4 1c             	add    $0x1c,%esp
  803c84:	5b                   	pop    %ebx
  803c85:	5e                   	pop    %esi
  803c86:	5f                   	pop    %edi
  803c87:	5d                   	pop    %ebp
  803c88:	c3                   	ret    
  803c89:	8d 76 00             	lea    0x0(%esi),%esi
  803c8c:	2b 04 24             	sub    (%esp),%eax
  803c8f:	19 fa                	sbb    %edi,%edx
  803c91:	89 d1                	mov    %edx,%ecx
  803c93:	89 c6                	mov    %eax,%esi
  803c95:	e9 71 ff ff ff       	jmp    803c0b <__umoddi3+0xb3>
  803c9a:	66 90                	xchg   %ax,%ax
  803c9c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ca0:	72 ea                	jb     803c8c <__umoddi3+0x134>
  803ca2:	89 d9                	mov    %ebx,%ecx
  803ca4:	e9 62 ff ff ff       	jmp    803c0b <__umoddi3+0xb3>
