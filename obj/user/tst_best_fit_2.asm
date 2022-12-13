
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
  800045:	e8 95 24 00 00       	call   8024df <sys_set_uheap_strategy>
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
  80009b:	68 00 3e 80 00       	push   $0x803e00
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 1c 3e 80 00       	push   $0x803e1c
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
  8000f5:	68 34 3e 80 00       	push   $0x803e34
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 1c 3e 80 00       	push   $0x803e1c
  800101:	e8 21 09 00 00       	call   800a27 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 bf 1e 00 00       	call   801fca <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 57 1f 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  80013a:	68 78 3e 80 00       	push   $0x803e78
  80013f:	6a 31                	push   $0x31
  800141:	68 1c 3e 80 00       	push   $0x803e1c
  800146:	e8 dc 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80014b:	e8 1a 1f 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  800150:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800153:	3d 00 02 00 00       	cmp    $0x200,%eax
  800158:	74 14                	je     80016e <_main+0x136>
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	68 a8 3e 80 00       	push   $0x803ea8
  800162:	6a 33                	push   $0x33
  800164:	68 1c 3e 80 00       	push   $0x803e1c
  800169:	e8 b9 08 00 00       	call   800a27 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80016e:	e8 57 1e 00 00       	call   801fca <sys_calculate_free_frames>
  800173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800176:	e8 ef 1e 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  8001ab:	68 78 3e 80 00       	push   $0x803e78
  8001b0:	6a 39                	push   $0x39
  8001b2:	68 1c 3e 80 00       	push   $0x803e1c
  8001b7:	e8 6b 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001bc:	e8 a9 1e 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  8001c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 a8 3e 80 00       	push   $0x803ea8
  8001d3:	6a 3b                	push   $0x3b
  8001d5:	68 1c 3e 80 00       	push   $0x803e1c
  8001da:	e8 48 08 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 e6 1d 00 00       	call   801fca <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 7e 1e 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  80021a:	68 78 3e 80 00       	push   $0x803e78
  80021f:	6a 41                	push   $0x41
  800221:	68 1c 3e 80 00       	push   $0x803e1c
  800226:	e8 fc 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80022b:	e8 3a 1e 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  800230:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800233:	83 f8 01             	cmp    $0x1,%eax
  800236:	74 14                	je     80024c <_main+0x214>
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 a8 3e 80 00       	push   $0x803ea8
  800240:	6a 43                	push   $0x43
  800242:	68 1c 3e 80 00       	push   $0x803e1c
  800247:	e8 db 07 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80024c:	e8 79 1d 00 00       	call   801fca <sys_calculate_free_frames>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800254:	e8 11 1e 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  800291:	68 78 3e 80 00       	push   $0x803e78
  800296:	6a 49                	push   $0x49
  800298:	68 1c 3e 80 00       	push   $0x803e1c
  80029d:	e8 85 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002a2:	e8 c3 1d 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  8002a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002aa:	83 f8 01             	cmp    $0x1,%eax
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 a8 3e 80 00       	push   $0x803ea8
  8002b7:	6a 4b                	push   $0x4b
  8002b9:	68 1c 3e 80 00       	push   $0x803e1c
  8002be:	e8 64 07 00 00       	call   800a27 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002c3:	e8 02 1d 00 00       	call   801fca <sys_calculate_free_frames>
  8002c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cb:	e8 9a 1d 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  8002d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 ff 19 00 00       	call   801cde <free>
  8002df:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002e2:	e8 83 1d 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  8002e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ea:	29 c2                	sub    %eax,%edx
  8002ec:	89 d0                	mov    %edx,%eax
  8002ee:	83 f8 01             	cmp    $0x1,%eax
  8002f1:	74 14                	je     800307 <_main+0x2cf>
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	68 c5 3e 80 00       	push   $0x803ec5
  8002fb:	6a 52                	push   $0x52
  8002fd:	68 1c 3e 80 00       	push   $0x803e1c
  800302:	e8 20 07 00 00       	call   800a27 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  800307:	e8 be 1c 00 00       	call   801fca <sys_calculate_free_frames>
  80030c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80030f:	e8 56 1d 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  800354:	68 78 3e 80 00       	push   $0x803e78
  800359:	6a 58                	push   $0x58
  80035b:	68 1c 3e 80 00       	push   $0x803e1c
  800360:	e8 c2 06 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800365:	e8 00 1d 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  80036a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80036d:	83 f8 02             	cmp    $0x2,%eax
  800370:	74 14                	je     800386 <_main+0x34e>
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 a8 3e 80 00       	push   $0x803ea8
  80037a:	6a 5a                	push   $0x5a
  80037c:	68 1c 3e 80 00       	push   $0x803e1c
  800381:	e8 a1 06 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800386:	e8 3f 1c 00 00       	call   801fca <sys_calculate_free_frames>
  80038b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80038e:	e8 d7 1c 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  800393:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800396:	8b 45 90             	mov    -0x70(%ebp),%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	50                   	push   %eax
  80039d:	e8 3c 19 00 00       	call   801cde <free>
  8003a2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003a5:	e8 c0 1c 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	29 c2                	sub    %eax,%edx
  8003af:	89 d0                	mov    %edx,%eax
  8003b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003b6:	74 14                	je     8003cc <_main+0x394>
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	68 c5 3e 80 00       	push   $0x803ec5
  8003c0:	6a 61                	push   $0x61
  8003c2:	68 1c 3e 80 00       	push   $0x803e1c
  8003c7:	e8 5b 06 00 00       	call   800a27 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cc:	e8 f9 1b 00 00       	call   801fca <sys_calculate_free_frames>
  8003d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d4:	e8 91 1c 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  800418:	68 78 3e 80 00       	push   $0x803e78
  80041d:	6a 67                	push   $0x67
  80041f:	68 1c 3e 80 00       	push   $0x803e1c
  800424:	e8 fe 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800429:	e8 3c 1c 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  80044f:	68 a8 3e 80 00       	push   $0x803ea8
  800454:	6a 69                	push   $0x69
  800456:	68 1c 3e 80 00       	push   $0x803e1c
  80045b:	e8 c7 05 00 00       	call   800a27 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800460:	e8 65 1b 00 00       	call   801fca <sys_calculate_free_frames>
  800465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800468:	e8 fd 1b 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  8004b7:	68 78 3e 80 00       	push   $0x803e78
  8004bc:	6a 6f                	push   $0x6f
  8004be:	68 1c 3e 80 00       	push   $0x803e1c
  8004c3:	e8 5f 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004c8:	e8 9d 1b 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  8004cd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004d0:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004d5:	74 14                	je     8004eb <_main+0x4b3>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 a8 3e 80 00       	push   $0x803ea8
  8004df:	6a 71                	push   $0x71
  8004e1:	68 1c 3e 80 00       	push   $0x803e1c
  8004e6:	e8 3c 05 00 00       	call   800a27 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004eb:	e8 da 1a 00 00       	call   801fca <sys_calculate_free_frames>
  8004f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f3:	e8 72 1b 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  800542:	68 78 3e 80 00       	push   $0x803e78
  800547:	6a 77                	push   $0x77
  800549:	68 1c 3e 80 00       	push   $0x803e1c
  80054e:	e8 d4 04 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  800553:	e8 12 1b 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  80057a:	68 a8 3e 80 00       	push   $0x803ea8
  80057f:	6a 79                	push   $0x79
  800581:	68 1c 3e 80 00       	push   $0x803e1c
  800586:	e8 9c 04 00 00       	call   800a27 <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80058b:	e8 3a 1a 00 00       	call   801fca <sys_calculate_free_frames>
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800593:	e8 d2 1a 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80059b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 37 17 00 00       	call   801cde <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  8005aa:	e8 bb 1a 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	29 c2                	sub    %eax,%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	3d 02 02 00 00       	cmp    $0x202,%eax
  8005bb:	74 17                	je     8005d4 <_main+0x59c>
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 c5 3e 80 00       	push   $0x803ec5
  8005c5:	68 80 00 00 00       	push   $0x80
  8005ca:	68 1c 3e 80 00       	push   $0x803e1c
  8005cf:	e8 53 04 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d4:	e8 f1 19 00 00       	call   801fca <sys_calculate_free_frames>
  8005d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005dc:	e8 89 1a 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005e4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	50                   	push   %eax
  8005eb:	e8 ee 16 00 00       	call   801cde <free>
  8005f0:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8005f3:	e8 72 1a 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  8005f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fb:	29 c2                	sub    %eax,%edx
  8005fd:	89 d0                	mov    %edx,%eax
  8005ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  800604:	74 17                	je     80061d <_main+0x5e5>
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	68 c5 3e 80 00       	push   $0x803ec5
  80060e:	68 87 00 00 00       	push   $0x87
  800613:	68 1c 3e 80 00       	push   $0x803e1c
  800618:	e8 0a 04 00 00       	call   800a27 <_panic>

		//2 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  80061d:	e8 a8 19 00 00       	call   801fca <sys_calculate_free_frames>
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800625:	e8 40 1a 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  80066c:	68 78 3e 80 00       	push   $0x803e78
  800671:	68 8d 00 00 00       	push   $0x8d
  800676:	68 1c 3e 80 00       	push   $0x803e1c
  80067b:	e8 a7 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800680:	e8 e5 19 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  800685:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800688:	3d 00 02 00 00       	cmp    $0x200,%eax
  80068d:	74 17                	je     8006a6 <_main+0x66e>
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 a8 3e 80 00       	push   $0x803ea8
  800697:	68 8f 00 00 00       	push   $0x8f
  80069c:	68 1c 3e 80 00       	push   $0x803e1c
  8006a1:	e8 81 03 00 00       	call   800a27 <_panic>

		//6 KB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  8006a6:	e8 1f 19 00 00       	call   801fca <sys_calculate_free_frames>
  8006ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ae:	e8 b7 19 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  8006f5:	68 78 3e 80 00       	push   $0x803e78
  8006fa:	68 95 00 00 00       	push   $0x95
  8006ff:	68 1c 3e 80 00       	push   $0x803e1c
  800704:	e8 1e 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800709:	e8 5c 19 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  80070e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800711:	83 f8 02             	cmp    $0x2,%eax
  800714:	74 17                	je     80072d <_main+0x6f5>
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	68 a8 3e 80 00       	push   $0x803ea8
  80071e:	68 97 00 00 00       	push   $0x97
  800723:	68 1c 3e 80 00       	push   $0x803e1c
  800728:	e8 fa 02 00 00       	call   800a27 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80072d:	e8 98 18 00 00       	call   801fca <sys_calculate_free_frames>
  800732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800735:	e8 30 19 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  80073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80073d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 95 15 00 00       	call   801cde <free>
  800749:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  80074c:	e8 19 19 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
  800751:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800754:	29 c2                	sub    %eax,%edx
  800756:	89 d0                	mov    %edx,%eax
  800758:	3d 00 03 00 00       	cmp    $0x300,%eax
  80075d:	74 17                	je     800776 <_main+0x73e>
  80075f:	83 ec 04             	sub    $0x4,%esp
  800762:	68 c5 3e 80 00       	push   $0x803ec5
  800767:	68 9e 00 00 00       	push   $0x9e
  80076c:	68 1c 3e 80 00       	push   $0x803e1c
  800771:	e8 b1 02 00 00       	call   800a27 <_panic>

		//3 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800776:	e8 4f 18 00 00       	call   801fca <sys_calculate_free_frames>
  80077b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80077e:	e8 e7 18 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  8007c2:	68 78 3e 80 00       	push   $0x803e78
  8007c7:	68 a4 00 00 00       	push   $0xa4
  8007cc:	68 1c 3e 80 00       	push   $0x803e1c
  8007d1:	e8 51 02 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8007d6:	e8 8f 18 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  8007fc:	68 a8 3e 80 00       	push   $0x803ea8
  800801:	68 a6 00 00 00       	push   $0xa6
  800806:	68 1c 3e 80 00       	push   $0x803e1c
  80080b:	e8 17 02 00 00       	call   800a27 <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800810:	e8 b5 17 00 00       	call   801fca <sys_calculate_free_frames>
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800818:	e8 4d 18 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  800845:	68 78 3e 80 00       	push   $0x803e78
  80084a:	68 ac 00 00 00       	push   $0xac
  80084f:	68 1c 3e 80 00       	push   $0x803e1c
  800854:	e8 ce 01 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800859:	e8 0c 18 00 00       	call   80206a <sys_pf_calculate_allocated_pages>
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
  80087c:	68 a8 3e 80 00       	push   $0x803ea8
  800881:	68 ae 00 00 00       	push   $0xae
  800886:	68 1c 3e 80 00       	push   $0x803e1c
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
  8008bf:	68 dc 3e 80 00       	push   $0x803edc
  8008c4:	68 b7 00 00 00       	push   $0xb7
  8008c9:	68 1c 3e 80 00       	push   $0x803e1c
  8008ce:	e8 54 01 00 00       	call   800a27 <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 40 3f 80 00       	push   $0x803f40
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
  8008f1:	e8 b4 19 00 00       	call   8022aa <sys_getenvindex>
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
  80095c:	e8 56 17 00 00       	call   8020b7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 a0 3f 80 00       	push   $0x803fa0
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
  80098c:	68 c8 3f 80 00       	push   $0x803fc8
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
  8009bd:	68 f0 3f 80 00       	push   $0x803ff0
  8009c2:	e8 14 03 00 00       	call   800cdb <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8009cf:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	50                   	push   %eax
  8009d9:	68 48 40 80 00       	push   $0x804048
  8009de:	e8 f8 02 00 00       	call   800cdb <cprintf>
  8009e3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009e6:	83 ec 0c             	sub    $0xc,%esp
  8009e9:	68 a0 3f 80 00       	push   $0x803fa0
  8009ee:	e8 e8 02 00 00       	call   800cdb <cprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009f6:	e8 d6 16 00 00       	call   8020d1 <sys_enable_interrupt>

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
  800a0e:	e8 63 18 00 00       	call   802276 <sys_destroy_env>
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
  800a1f:	e8 b8 18 00 00       	call   8022dc <sys_exit_env>
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
  800a48:	68 5c 40 80 00       	push   $0x80405c
  800a4d:	e8 89 02 00 00       	call   800cdb <cprintf>
  800a52:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a55:	a1 00 50 80 00       	mov    0x805000,%eax
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 08             	pushl  0x8(%ebp)
  800a60:	50                   	push   %eax
  800a61:	68 61 40 80 00       	push   $0x804061
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
  800a85:	68 7d 40 80 00       	push   $0x80407d
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
  800ab1:	68 80 40 80 00       	push   $0x804080
  800ab6:	6a 26                	push   $0x26
  800ab8:	68 cc 40 80 00       	push   $0x8040cc
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
  800b83:	68 d8 40 80 00       	push   $0x8040d8
  800b88:	6a 3a                	push   $0x3a
  800b8a:	68 cc 40 80 00       	push   $0x8040cc
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
  800bf3:	68 2c 41 80 00       	push   $0x80412c
  800bf8:	6a 44                	push   $0x44
  800bfa:	68 cc 40 80 00       	push   $0x8040cc
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
  800c4d:	e8 b7 12 00 00       	call   801f09 <sys_cputs>
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
  800cc4:	e8 40 12 00 00       	call   801f09 <sys_cputs>
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
  800d0e:	e8 a4 13 00 00       	call   8020b7 <sys_disable_interrupt>
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
  800d2e:	e8 9e 13 00 00       	call   8020d1 <sys_enable_interrupt>
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
  800d78:	e8 0f 2e 00 00       	call   803b8c <__udivdi3>
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
  800dc8:	e8 cf 2e 00 00       	call   803c9c <__umoddi3>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	05 94 43 80 00       	add    $0x804394,%eax
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
  800f23:	8b 04 85 b8 43 80 00 	mov    0x8043b8(,%eax,4),%eax
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
  801004:	8b 34 9d 00 42 80 00 	mov    0x804200(,%ebx,4),%esi
  80100b:	85 f6                	test   %esi,%esi
  80100d:	75 19                	jne    801028 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80100f:	53                   	push   %ebx
  801010:	68 a5 43 80 00       	push   $0x8043a5
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
  801029:	68 ae 43 80 00       	push   $0x8043ae
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
  801056:	be b1 43 80 00       	mov    $0x8043b1,%esi
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
  801a7c:	68 10 45 80 00       	push   $0x804510
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
  801b4c:	e8 fc 04 00 00       	call   80204d <sys_allocate_chunk>
  801b51:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801b54:	a1 20 51 80 00       	mov    0x805120,%eax
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	50                   	push   %eax
  801b5d:	e8 71 0b 00 00       	call   8026d3 <initialize_MemBlocksList>
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
  801b8a:	68 35 45 80 00       	push   $0x804535
  801b8f:	6a 33                	push   $0x33
  801b91:	68 53 45 80 00       	push   $0x804553
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
  801c09:	68 60 45 80 00       	push   $0x804560
  801c0e:	6a 34                	push   $0x34
  801c10:	68 53 45 80 00       	push   $0x804553
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
  801ca1:	e8 75 07 00 00       	call   80241b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	74 11                	je     801cbb <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801caa:	83 ec 0c             	sub    $0xc,%esp
  801cad:	ff 75 e8             	pushl  -0x18(%ebp)
  801cb0:	e8 e0 0d 00 00       	call   802a95 <alloc_block_FF>
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
  801cc7:	e8 3c 0b 00 00       	call   802808 <insert_sorted_allocList>
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
  801ce1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801ce4:	83 ec 04             	sub    $0x4,%esp
  801ce7:	68 84 45 80 00       	push   $0x804584
  801cec:	6a 6f                	push   $0x6f
  801cee:	68 53 45 80 00       	push   $0x804553
  801cf3:	e8 2f ed ff ff       	call   800a27 <_panic>

00801cf8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
  801cfb:	83 ec 38             	sub    $0x38,%esp
  801cfe:	8b 45 10             	mov    0x10(%ebp),%eax
  801d01:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d04:	e8 5c fd ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d0d:	75 0a                	jne    801d19 <smalloc+0x21>
  801d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d14:	e9 8b 00 00 00       	jmp    801da4 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801d19:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d26:	01 d0                	add    %edx,%eax
  801d28:	48                   	dec    %eax
  801d29:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d34:	f7 75 f0             	divl   -0x10(%ebp)
  801d37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d3a:	29 d0                	sub    %edx,%eax
  801d3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801d3f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801d46:	e8 d0 06 00 00       	call   80241b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d4b:	85 c0                	test   %eax,%eax
  801d4d:	74 11                	je     801d60 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801d4f:	83 ec 0c             	sub    $0xc,%esp
  801d52:	ff 75 e8             	pushl  -0x18(%ebp)
  801d55:	e8 3b 0d 00 00       	call   802a95 <alloc_block_FF>
  801d5a:	83 c4 10             	add    $0x10,%esp
  801d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801d60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d64:	74 39                	je     801d9f <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d69:	8b 40 08             	mov    0x8(%eax),%eax
  801d6c:	89 c2                	mov    %eax,%edx
  801d6e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d72:	52                   	push   %edx
  801d73:	50                   	push   %eax
  801d74:	ff 75 0c             	pushl  0xc(%ebp)
  801d77:	ff 75 08             	pushl  0x8(%ebp)
  801d7a:	e8 21 04 00 00       	call   8021a0 <sys_createSharedObject>
  801d7f:	83 c4 10             	add    $0x10,%esp
  801d82:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801d85:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801d89:	74 14                	je     801d9f <smalloc+0xa7>
  801d8b:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801d8f:	74 0e                	je     801d9f <smalloc+0xa7>
  801d91:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801d95:	74 08                	je     801d9f <smalloc+0xa7>
			return (void*) mem_block->sva;
  801d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9a:	8b 40 08             	mov    0x8(%eax),%eax
  801d9d:	eb 05                	jmp    801da4 <smalloc+0xac>
	}
	return NULL;
  801d9f:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dac:	e8 b4 fc ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801db1:	83 ec 08             	sub    $0x8,%esp
  801db4:	ff 75 0c             	pushl  0xc(%ebp)
  801db7:	ff 75 08             	pushl  0x8(%ebp)
  801dba:	e8 0b 04 00 00       	call   8021ca <sys_getSizeOfSharedObject>
  801dbf:	83 c4 10             	add    $0x10,%esp
  801dc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801dc5:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801dc9:	74 76                	je     801e41 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801dcb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801dd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dd8:	01 d0                	add    %edx,%eax
  801dda:	48                   	dec    %eax
  801ddb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801dde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801de1:	ba 00 00 00 00       	mov    $0x0,%edx
  801de6:	f7 75 ec             	divl   -0x14(%ebp)
  801de9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dec:	29 d0                	sub    %edx,%eax
  801dee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801df1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801df8:	e8 1e 06 00 00       	call   80241b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dfd:	85 c0                	test   %eax,%eax
  801dff:	74 11                	je     801e12 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801e01:	83 ec 0c             	sub    $0xc,%esp
  801e04:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e07:	e8 89 0c 00 00       	call   802a95 <alloc_block_FF>
  801e0c:	83 c4 10             	add    $0x10,%esp
  801e0f:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801e12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e16:	74 29                	je     801e41 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1b:	8b 40 08             	mov    0x8(%eax),%eax
  801e1e:	83 ec 04             	sub    $0x4,%esp
  801e21:	50                   	push   %eax
  801e22:	ff 75 0c             	pushl  0xc(%ebp)
  801e25:	ff 75 08             	pushl  0x8(%ebp)
  801e28:	e8 ba 03 00 00       	call   8021e7 <sys_getSharedObject>
  801e2d:	83 c4 10             	add    $0x10,%esp
  801e30:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801e33:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801e37:	74 08                	je     801e41 <sget+0x9b>
				return (void *)mem_block->sva;
  801e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3c:	8b 40 08             	mov    0x8(%eax),%eax
  801e3f:	eb 05                	jmp    801e46 <sget+0xa0>
		}
	}
	return (void *)NULL;
  801e41:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e4e:	e8 12 fc ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e53:	83 ec 04             	sub    $0x4,%esp
  801e56:	68 a8 45 80 00       	push   $0x8045a8
  801e5b:	68 f1 00 00 00       	push   $0xf1
  801e60:	68 53 45 80 00       	push   $0x804553
  801e65:	e8 bd eb ff ff       	call   800a27 <_panic>

00801e6a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e70:	83 ec 04             	sub    $0x4,%esp
  801e73:	68 d0 45 80 00       	push   $0x8045d0
  801e78:	68 05 01 00 00       	push   $0x105
  801e7d:	68 53 45 80 00       	push   $0x804553
  801e82:	e8 a0 eb ff ff       	call   800a27 <_panic>

00801e87 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e8d:	83 ec 04             	sub    $0x4,%esp
  801e90:	68 f4 45 80 00       	push   $0x8045f4
  801e95:	68 10 01 00 00       	push   $0x110
  801e9a:	68 53 45 80 00       	push   $0x804553
  801e9f:	e8 83 eb ff ff       	call   800a27 <_panic>

00801ea4 <shrink>:

}
void shrink(uint32 newSize)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eaa:	83 ec 04             	sub    $0x4,%esp
  801ead:	68 f4 45 80 00       	push   $0x8045f4
  801eb2:	68 15 01 00 00       	push   $0x115
  801eb7:	68 53 45 80 00       	push   $0x804553
  801ebc:	e8 66 eb ff ff       	call   800a27 <_panic>

00801ec1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec7:	83 ec 04             	sub    $0x4,%esp
  801eca:	68 f4 45 80 00       	push   $0x8045f4
  801ecf:	68 1a 01 00 00       	push   $0x11a
  801ed4:	68 53 45 80 00       	push   $0x804553
  801ed9:	e8 49 eb ff ff       	call   800a27 <_panic>

00801ede <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	57                   	push   %edi
  801ee2:	56                   	push   %esi
  801ee3:	53                   	push   %ebx
  801ee4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef3:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ef6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ef9:	cd 30                	int    $0x30
  801efb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f01:	83 c4 10             	add    $0x10,%esp
  801f04:	5b                   	pop    %ebx
  801f05:	5e                   	pop    %esi
  801f06:	5f                   	pop    %edi
  801f07:	5d                   	pop    %ebp
  801f08:	c3                   	ret    

00801f09 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	83 ec 04             	sub    $0x4,%esp
  801f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f12:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f15:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	52                   	push   %edx
  801f21:	ff 75 0c             	pushl  0xc(%ebp)
  801f24:	50                   	push   %eax
  801f25:	6a 00                	push   $0x0
  801f27:	e8 b2 ff ff ff       	call   801ede <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
}
  801f2f:	90                   	nop
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 01                	push   $0x1
  801f41:	e8 98 ff ff ff       	call   801ede <syscall>
  801f46:	83 c4 18             	add    $0x18,%esp
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	52                   	push   %edx
  801f5b:	50                   	push   %eax
  801f5c:	6a 05                	push   $0x5
  801f5e:	e8 7b ff ff ff       	call   801ede <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	56                   	push   %esi
  801f6c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f6d:	8b 75 18             	mov    0x18(%ebp),%esi
  801f70:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f73:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	56                   	push   %esi
  801f7d:	53                   	push   %ebx
  801f7e:	51                   	push   %ecx
  801f7f:	52                   	push   %edx
  801f80:	50                   	push   %eax
  801f81:	6a 06                	push   $0x6
  801f83:	e8 56 ff ff ff       	call   801ede <syscall>
  801f88:	83 c4 18             	add    $0x18,%esp
}
  801f8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f8e:	5b                   	pop    %ebx
  801f8f:	5e                   	pop    %esi
  801f90:	5d                   	pop    %ebp
  801f91:	c3                   	ret    

00801f92 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	52                   	push   %edx
  801fa2:	50                   	push   %eax
  801fa3:	6a 07                	push   $0x7
  801fa5:	e8 34 ff ff ff       	call   801ede <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	ff 75 0c             	pushl  0xc(%ebp)
  801fbb:	ff 75 08             	pushl  0x8(%ebp)
  801fbe:	6a 08                	push   $0x8
  801fc0:	e8 19 ff ff ff       	call   801ede <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 09                	push   $0x9
  801fd9:	e8 00 ff ff ff       	call   801ede <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 0a                	push   $0xa
  801ff2:	e8 e7 fe ff ff       	call   801ede <syscall>
  801ff7:	83 c4 18             	add    $0x18,%esp
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 0b                	push   $0xb
  80200b:	e8 ce fe ff ff       	call   801ede <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	ff 75 0c             	pushl  0xc(%ebp)
  802021:	ff 75 08             	pushl  0x8(%ebp)
  802024:	6a 0f                	push   $0xf
  802026:	e8 b3 fe ff ff       	call   801ede <syscall>
  80202b:	83 c4 18             	add    $0x18,%esp
	return;
  80202e:	90                   	nop
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	ff 75 0c             	pushl  0xc(%ebp)
  80203d:	ff 75 08             	pushl  0x8(%ebp)
  802040:	6a 10                	push   $0x10
  802042:	e8 97 fe ff ff       	call   801ede <syscall>
  802047:	83 c4 18             	add    $0x18,%esp
	return ;
  80204a:	90                   	nop
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	ff 75 10             	pushl  0x10(%ebp)
  802057:	ff 75 0c             	pushl  0xc(%ebp)
  80205a:	ff 75 08             	pushl  0x8(%ebp)
  80205d:	6a 11                	push   $0x11
  80205f:	e8 7a fe ff ff       	call   801ede <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
	return ;
  802067:	90                   	nop
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 0c                	push   $0xc
  802079:	e8 60 fe ff ff       	call   801ede <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	ff 75 08             	pushl  0x8(%ebp)
  802091:	6a 0d                	push   $0xd
  802093:	e8 46 fe ff ff       	call   801ede <syscall>
  802098:	83 c4 18             	add    $0x18,%esp
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 0e                	push   $0xe
  8020ac:	e8 2d fe ff ff       	call   801ede <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
}
  8020b4:	90                   	nop
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 13                	push   $0x13
  8020c6:	e8 13 fe ff ff       	call   801ede <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
}
  8020ce:	90                   	nop
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 14                	push   $0x14
  8020e0:	e8 f9 fd ff ff       	call   801ede <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
}
  8020e8:	90                   	nop
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <sys_cputc>:


void
sys_cputc(const char c)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 04             	sub    $0x4,%esp
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	50                   	push   %eax
  802104:	6a 15                	push   $0x15
  802106:	e8 d3 fd ff ff       	call   801ede <syscall>
  80210b:	83 c4 18             	add    $0x18,%esp
}
  80210e:	90                   	nop
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 16                	push   $0x16
  802120:	e8 b9 fd ff ff       	call   801ede <syscall>
  802125:	83 c4 18             	add    $0x18,%esp
}
  802128:	90                   	nop
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	ff 75 0c             	pushl  0xc(%ebp)
  80213a:	50                   	push   %eax
  80213b:	6a 17                	push   $0x17
  80213d:	e8 9c fd ff ff       	call   801ede <syscall>
  802142:	83 c4 18             	add    $0x18,%esp
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80214a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	52                   	push   %edx
  802157:	50                   	push   %eax
  802158:	6a 1a                	push   $0x1a
  80215a:	e8 7f fd ff ff       	call   801ede <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
}
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802167:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	52                   	push   %edx
  802174:	50                   	push   %eax
  802175:	6a 18                	push   $0x18
  802177:	e8 62 fd ff ff       	call   801ede <syscall>
  80217c:	83 c4 18             	add    $0x18,%esp
}
  80217f:	90                   	nop
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802185:	8b 55 0c             	mov    0xc(%ebp),%edx
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	52                   	push   %edx
  802192:	50                   	push   %eax
  802193:	6a 19                	push   $0x19
  802195:	e8 44 fd ff ff       	call   801ede <syscall>
  80219a:	83 c4 18             	add    $0x18,%esp
}
  80219d:	90                   	nop
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	83 ec 04             	sub    $0x4,%esp
  8021a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021ac:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021af:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	6a 00                	push   $0x0
  8021b8:	51                   	push   %ecx
  8021b9:	52                   	push   %edx
  8021ba:	ff 75 0c             	pushl  0xc(%ebp)
  8021bd:	50                   	push   %eax
  8021be:	6a 1b                	push   $0x1b
  8021c0:	e8 19 fd ff ff       	call   801ede <syscall>
  8021c5:	83 c4 18             	add    $0x18,%esp
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	52                   	push   %edx
  8021da:	50                   	push   %eax
  8021db:	6a 1c                	push   $0x1c
  8021dd:	e8 fc fc ff ff       	call   801ede <syscall>
  8021e2:	83 c4 18             	add    $0x18,%esp
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	51                   	push   %ecx
  8021f8:	52                   	push   %edx
  8021f9:	50                   	push   %eax
  8021fa:	6a 1d                	push   $0x1d
  8021fc:	e8 dd fc ff ff       	call   801ede <syscall>
  802201:	83 c4 18             	add    $0x18,%esp
}
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802209:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	52                   	push   %edx
  802216:	50                   	push   %eax
  802217:	6a 1e                	push   $0x1e
  802219:	e8 c0 fc ff ff       	call   801ede <syscall>
  80221e:	83 c4 18             	add    $0x18,%esp
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 1f                	push   $0x1f
  802232:	e8 a7 fc ff ff       	call   801ede <syscall>
  802237:	83 c4 18             	add    $0x18,%esp
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	6a 00                	push   $0x0
  802244:	ff 75 14             	pushl  0x14(%ebp)
  802247:	ff 75 10             	pushl  0x10(%ebp)
  80224a:	ff 75 0c             	pushl  0xc(%ebp)
  80224d:	50                   	push   %eax
  80224e:	6a 20                	push   $0x20
  802250:	e8 89 fc ff ff       	call   801ede <syscall>
  802255:	83 c4 18             	add    $0x18,%esp
}
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	50                   	push   %eax
  802269:	6a 21                	push   $0x21
  80226b:	e8 6e fc ff ff       	call   801ede <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	90                   	nop
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	50                   	push   %eax
  802285:	6a 22                	push   $0x22
  802287:	e8 52 fc ff ff       	call   801ede <syscall>
  80228c:	83 c4 18             	add    $0x18,%esp
}
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 02                	push   $0x2
  8022a0:	e8 39 fc ff ff       	call   801ede <syscall>
  8022a5:	83 c4 18             	add    $0x18,%esp
}
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 03                	push   $0x3
  8022b9:	e8 20 fc ff ff       	call   801ede <syscall>
  8022be:	83 c4 18             	add    $0x18,%esp
}
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 04                	push   $0x4
  8022d2:	e8 07 fc ff ff       	call   801ede <syscall>
  8022d7:	83 c4 18             	add    $0x18,%esp
}
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <sys_exit_env>:


void sys_exit_env(void)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 23                	push   $0x23
  8022eb:	e8 ee fb ff ff       	call   801ede <syscall>
  8022f0:	83 c4 18             	add    $0x18,%esp
}
  8022f3:	90                   	nop
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022fc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022ff:	8d 50 04             	lea    0x4(%eax),%edx
  802302:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	52                   	push   %edx
  80230c:	50                   	push   %eax
  80230d:	6a 24                	push   $0x24
  80230f:	e8 ca fb ff ff       	call   801ede <syscall>
  802314:	83 c4 18             	add    $0x18,%esp
	return result;
  802317:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80231a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80231d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802320:	89 01                	mov    %eax,(%ecx)
  802322:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	c9                   	leave  
  802329:	c2 04 00             	ret    $0x4

0080232c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	ff 75 10             	pushl  0x10(%ebp)
  802336:	ff 75 0c             	pushl  0xc(%ebp)
  802339:	ff 75 08             	pushl  0x8(%ebp)
  80233c:	6a 12                	push   $0x12
  80233e:	e8 9b fb ff ff       	call   801ede <syscall>
  802343:	83 c4 18             	add    $0x18,%esp
	return ;
  802346:	90                   	nop
}
  802347:	c9                   	leave  
  802348:	c3                   	ret    

00802349 <sys_rcr2>:
uint32 sys_rcr2()
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 25                	push   $0x25
  802358:	e8 81 fb ff ff       	call   801ede <syscall>
  80235d:	83 c4 18             	add    $0x18,%esp
}
  802360:	c9                   	leave  
  802361:	c3                   	ret    

00802362 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	83 ec 04             	sub    $0x4,%esp
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80236e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	50                   	push   %eax
  80237b:	6a 26                	push   $0x26
  80237d:	e8 5c fb ff ff       	call   801ede <syscall>
  802382:	83 c4 18             	add    $0x18,%esp
	return ;
  802385:	90                   	nop
}
  802386:	c9                   	leave  
  802387:	c3                   	ret    

00802388 <rsttst>:
void rsttst()
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 28                	push   $0x28
  802397:	e8 42 fb ff ff       	call   801ede <syscall>
  80239c:	83 c4 18             	add    $0x18,%esp
	return ;
  80239f:	90                   	nop
}
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	83 ec 04             	sub    $0x4,%esp
  8023a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023ae:	8b 55 18             	mov    0x18(%ebp),%edx
  8023b1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023b5:	52                   	push   %edx
  8023b6:	50                   	push   %eax
  8023b7:	ff 75 10             	pushl  0x10(%ebp)
  8023ba:	ff 75 0c             	pushl  0xc(%ebp)
  8023bd:	ff 75 08             	pushl  0x8(%ebp)
  8023c0:	6a 27                	push   $0x27
  8023c2:	e8 17 fb ff ff       	call   801ede <syscall>
  8023c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ca:	90                   	nop
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <chktst>:
void chktst(uint32 n)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	ff 75 08             	pushl  0x8(%ebp)
  8023db:	6a 29                	push   $0x29
  8023dd:	e8 fc fa ff ff       	call   801ede <syscall>
  8023e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e5:	90                   	nop
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <inctst>:

void inctst()
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 2a                	push   $0x2a
  8023f7:	e8 e2 fa ff ff       	call   801ede <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ff:	90                   	nop
}
  802400:	c9                   	leave  
  802401:	c3                   	ret    

00802402 <gettst>:
uint32 gettst()
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 2b                	push   $0x2b
  802411:	e8 c8 fa ff ff       	call   801ede <syscall>
  802416:	83 c4 18             	add    $0x18,%esp
}
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
  80241e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 2c                	push   $0x2c
  80242d:	e8 ac fa ff ff       	call   801ede <syscall>
  802432:	83 c4 18             	add    $0x18,%esp
  802435:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802438:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80243c:	75 07                	jne    802445 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80243e:	b8 01 00 00 00       	mov    $0x1,%eax
  802443:	eb 05                	jmp    80244a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802445:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244a:	c9                   	leave  
  80244b:	c3                   	ret    

0080244c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
  80244f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 2c                	push   $0x2c
  80245e:	e8 7b fa ff ff       	call   801ede <syscall>
  802463:	83 c4 18             	add    $0x18,%esp
  802466:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802469:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80246d:	75 07                	jne    802476 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80246f:	b8 01 00 00 00       	mov    $0x1,%eax
  802474:	eb 05                	jmp    80247b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802476:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
  802480:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 2c                	push   $0x2c
  80248f:	e8 4a fa ff ff       	call   801ede <syscall>
  802494:	83 c4 18             	add    $0x18,%esp
  802497:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80249a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80249e:	75 07                	jne    8024a7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a5:	eb 05                	jmp    8024ac <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ac:	c9                   	leave  
  8024ad:	c3                   	ret    

008024ae <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 2c                	push   $0x2c
  8024c0:	e8 19 fa ff ff       	call   801ede <syscall>
  8024c5:	83 c4 18             	add    $0x18,%esp
  8024c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024cb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024cf:	75 07                	jne    8024d8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d6:	eb 05                	jmp    8024dd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    

008024df <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	ff 75 08             	pushl  0x8(%ebp)
  8024ed:	6a 2d                	push   $0x2d
  8024ef:	e8 ea f9 ff ff       	call   801ede <syscall>
  8024f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f7:	90                   	nop
}
  8024f8:	c9                   	leave  
  8024f9:	c3                   	ret    

008024fa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
  8024fd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024fe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802501:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802504:	8b 55 0c             	mov    0xc(%ebp),%edx
  802507:	8b 45 08             	mov    0x8(%ebp),%eax
  80250a:	6a 00                	push   $0x0
  80250c:	53                   	push   %ebx
  80250d:	51                   	push   %ecx
  80250e:	52                   	push   %edx
  80250f:	50                   	push   %eax
  802510:	6a 2e                	push   $0x2e
  802512:	e8 c7 f9 ff ff       	call   801ede <syscall>
  802517:	83 c4 18             	add    $0x18,%esp
}
  80251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80251d:	c9                   	leave  
  80251e:	c3                   	ret    

0080251f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80251f:	55                   	push   %ebp
  802520:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802522:	8b 55 0c             	mov    0xc(%ebp),%edx
  802525:	8b 45 08             	mov    0x8(%ebp),%eax
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	52                   	push   %edx
  80252f:	50                   	push   %eax
  802530:	6a 2f                	push   $0x2f
  802532:	e8 a7 f9 ff ff       	call   801ede <syscall>
  802537:	83 c4 18             	add    $0x18,%esp
}
  80253a:	c9                   	leave  
  80253b:	c3                   	ret    

0080253c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
  80253f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802542:	83 ec 0c             	sub    $0xc,%esp
  802545:	68 04 46 80 00       	push   $0x804604
  80254a:	e8 8c e7 ff ff       	call   800cdb <cprintf>
  80254f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802552:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802559:	83 ec 0c             	sub    $0xc,%esp
  80255c:	68 30 46 80 00       	push   $0x804630
  802561:	e8 75 e7 ff ff       	call   800cdb <cprintf>
  802566:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802569:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80256d:	a1 38 51 80 00       	mov    0x805138,%eax
  802572:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802575:	eb 56                	jmp    8025cd <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802577:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80257b:	74 1c                	je     802599 <print_mem_block_lists+0x5d>
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 50 08             	mov    0x8(%eax),%edx
  802583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802586:	8b 48 08             	mov    0x8(%eax),%ecx
  802589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258c:	8b 40 0c             	mov    0xc(%eax),%eax
  80258f:	01 c8                	add    %ecx,%eax
  802591:	39 c2                	cmp    %eax,%edx
  802593:	73 04                	jae    802599 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802595:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	8b 50 08             	mov    0x8(%eax),%edx
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a5:	01 c2                	add    %eax,%edx
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 40 08             	mov    0x8(%eax),%eax
  8025ad:	83 ec 04             	sub    $0x4,%esp
  8025b0:	52                   	push   %edx
  8025b1:	50                   	push   %eax
  8025b2:	68 45 46 80 00       	push   $0x804645
  8025b7:	e8 1f e7 ff ff       	call   800cdb <cprintf>
  8025bc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025c5:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d1:	74 07                	je     8025da <print_mem_block_lists+0x9e>
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 00                	mov    (%eax),%eax
  8025d8:	eb 05                	jmp    8025df <print_mem_block_lists+0xa3>
  8025da:	b8 00 00 00 00       	mov    $0x0,%eax
  8025df:	a3 40 51 80 00       	mov    %eax,0x805140
  8025e4:	a1 40 51 80 00       	mov    0x805140,%eax
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	75 8a                	jne    802577 <print_mem_block_lists+0x3b>
  8025ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f1:	75 84                	jne    802577 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025f3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025f7:	75 10                	jne    802609 <print_mem_block_lists+0xcd>
  8025f9:	83 ec 0c             	sub    $0xc,%esp
  8025fc:	68 54 46 80 00       	push   $0x804654
  802601:	e8 d5 e6 ff ff       	call   800cdb <cprintf>
  802606:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802609:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802610:	83 ec 0c             	sub    $0xc,%esp
  802613:	68 78 46 80 00       	push   $0x804678
  802618:	e8 be e6 ff ff       	call   800cdb <cprintf>
  80261d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802620:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802624:	a1 40 50 80 00       	mov    0x805040,%eax
  802629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262c:	eb 56                	jmp    802684 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80262e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802632:	74 1c                	je     802650 <print_mem_block_lists+0x114>
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 50 08             	mov    0x8(%eax),%edx
  80263a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263d:	8b 48 08             	mov    0x8(%eax),%ecx
  802640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802643:	8b 40 0c             	mov    0xc(%eax),%eax
  802646:	01 c8                	add    %ecx,%eax
  802648:	39 c2                	cmp    %eax,%edx
  80264a:	73 04                	jae    802650 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80264c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 50 08             	mov    0x8(%eax),%edx
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 40 0c             	mov    0xc(%eax),%eax
  80265c:	01 c2                	add    %eax,%edx
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 40 08             	mov    0x8(%eax),%eax
  802664:	83 ec 04             	sub    $0x4,%esp
  802667:	52                   	push   %edx
  802668:	50                   	push   %eax
  802669:	68 45 46 80 00       	push   $0x804645
  80266e:	e8 68 e6 ff ff       	call   800cdb <cprintf>
  802673:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80267c:	a1 48 50 80 00       	mov    0x805048,%eax
  802681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802684:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802688:	74 07                	je     802691 <print_mem_block_lists+0x155>
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 00                	mov    (%eax),%eax
  80268f:	eb 05                	jmp    802696 <print_mem_block_lists+0x15a>
  802691:	b8 00 00 00 00       	mov    $0x0,%eax
  802696:	a3 48 50 80 00       	mov    %eax,0x805048
  80269b:	a1 48 50 80 00       	mov    0x805048,%eax
  8026a0:	85 c0                	test   %eax,%eax
  8026a2:	75 8a                	jne    80262e <print_mem_block_lists+0xf2>
  8026a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a8:	75 84                	jne    80262e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026aa:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026ae:	75 10                	jne    8026c0 <print_mem_block_lists+0x184>
  8026b0:	83 ec 0c             	sub    $0xc,%esp
  8026b3:	68 90 46 80 00       	push   $0x804690
  8026b8:	e8 1e e6 ff ff       	call   800cdb <cprintf>
  8026bd:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026c0:	83 ec 0c             	sub    $0xc,%esp
  8026c3:	68 04 46 80 00       	push   $0x804604
  8026c8:	e8 0e e6 ff ff       	call   800cdb <cprintf>
  8026cd:	83 c4 10             	add    $0x10,%esp

}
  8026d0:	90                   	nop
  8026d1:	c9                   	leave  
  8026d2:	c3                   	ret    

008026d3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026d3:	55                   	push   %ebp
  8026d4:	89 e5                	mov    %esp,%ebp
  8026d6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8026d9:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026e0:	00 00 00 
  8026e3:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026ea:	00 00 00 
  8026ed:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026f4:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8026f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026fe:	e9 9e 00 00 00       	jmp    8027a1 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802703:	a1 50 50 80 00       	mov    0x805050,%eax
  802708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270b:	c1 e2 04             	shl    $0x4,%edx
  80270e:	01 d0                	add    %edx,%eax
  802710:	85 c0                	test   %eax,%eax
  802712:	75 14                	jne    802728 <initialize_MemBlocksList+0x55>
  802714:	83 ec 04             	sub    $0x4,%esp
  802717:	68 b8 46 80 00       	push   $0x8046b8
  80271c:	6a 46                	push   $0x46
  80271e:	68 db 46 80 00       	push   $0x8046db
  802723:	e8 ff e2 ff ff       	call   800a27 <_panic>
  802728:	a1 50 50 80 00       	mov    0x805050,%eax
  80272d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802730:	c1 e2 04             	shl    $0x4,%edx
  802733:	01 d0                	add    %edx,%eax
  802735:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80273b:	89 10                	mov    %edx,(%eax)
  80273d:	8b 00                	mov    (%eax),%eax
  80273f:	85 c0                	test   %eax,%eax
  802741:	74 18                	je     80275b <initialize_MemBlocksList+0x88>
  802743:	a1 48 51 80 00       	mov    0x805148,%eax
  802748:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80274e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802751:	c1 e1 04             	shl    $0x4,%ecx
  802754:	01 ca                	add    %ecx,%edx
  802756:	89 50 04             	mov    %edx,0x4(%eax)
  802759:	eb 12                	jmp    80276d <initialize_MemBlocksList+0x9a>
  80275b:	a1 50 50 80 00       	mov    0x805050,%eax
  802760:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802763:	c1 e2 04             	shl    $0x4,%edx
  802766:	01 d0                	add    %edx,%eax
  802768:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80276d:	a1 50 50 80 00       	mov    0x805050,%eax
  802772:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802775:	c1 e2 04             	shl    $0x4,%edx
  802778:	01 d0                	add    %edx,%eax
  80277a:	a3 48 51 80 00       	mov    %eax,0x805148
  80277f:	a1 50 50 80 00       	mov    0x805050,%eax
  802784:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802787:	c1 e2 04             	shl    $0x4,%edx
  80278a:	01 d0                	add    %edx,%eax
  80278c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802793:	a1 54 51 80 00       	mov    0x805154,%eax
  802798:	40                   	inc    %eax
  802799:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80279e:	ff 45 f4             	incl   -0xc(%ebp)
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a7:	0f 82 56 ff ff ff    	jb     802703 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8027ad:	90                   	nop
  8027ae:	c9                   	leave  
  8027af:	c3                   	ret    

008027b0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
  8027b3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b9:	8b 00                	mov    (%eax),%eax
  8027bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027be:	eb 19                	jmp    8027d9 <find_block+0x29>
	{
		if(va==point->sva)
  8027c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027c3:	8b 40 08             	mov    0x8(%eax),%eax
  8027c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027c9:	75 05                	jne    8027d0 <find_block+0x20>
		   return point;
  8027cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027ce:	eb 36                	jmp    802806 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	8b 40 08             	mov    0x8(%eax),%eax
  8027d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027dd:	74 07                	je     8027e6 <find_block+0x36>
  8027df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	eb 05                	jmp    8027eb <find_block+0x3b>
  8027e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ee:	89 42 08             	mov    %eax,0x8(%edx)
  8027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f4:	8b 40 08             	mov    0x8(%eax),%eax
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	75 c5                	jne    8027c0 <find_block+0x10>
  8027fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027ff:	75 bf                	jne    8027c0 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802801:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802806:	c9                   	leave  
  802807:	c3                   	ret    

00802808 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802808:	55                   	push   %ebp
  802809:	89 e5                	mov    %esp,%ebp
  80280b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80280e:	a1 40 50 80 00       	mov    0x805040,%eax
  802813:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802816:	a1 44 50 80 00       	mov    0x805044,%eax
  80281b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80281e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802821:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802824:	74 24                	je     80284a <insert_sorted_allocList+0x42>
  802826:	8b 45 08             	mov    0x8(%ebp),%eax
  802829:	8b 50 08             	mov    0x8(%eax),%edx
  80282c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282f:	8b 40 08             	mov    0x8(%eax),%eax
  802832:	39 c2                	cmp    %eax,%edx
  802834:	76 14                	jbe    80284a <insert_sorted_allocList+0x42>
  802836:	8b 45 08             	mov    0x8(%ebp),%eax
  802839:	8b 50 08             	mov    0x8(%eax),%edx
  80283c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283f:	8b 40 08             	mov    0x8(%eax),%eax
  802842:	39 c2                	cmp    %eax,%edx
  802844:	0f 82 60 01 00 00    	jb     8029aa <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80284a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80284e:	75 65                	jne    8028b5 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802850:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802854:	75 14                	jne    80286a <insert_sorted_allocList+0x62>
  802856:	83 ec 04             	sub    $0x4,%esp
  802859:	68 b8 46 80 00       	push   $0x8046b8
  80285e:	6a 6b                	push   $0x6b
  802860:	68 db 46 80 00       	push   $0x8046db
  802865:	e8 bd e1 ff ff       	call   800a27 <_panic>
  80286a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	89 10                	mov    %edx,(%eax)
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	85 c0                	test   %eax,%eax
  80287c:	74 0d                	je     80288b <insert_sorted_allocList+0x83>
  80287e:	a1 40 50 80 00       	mov    0x805040,%eax
  802883:	8b 55 08             	mov    0x8(%ebp),%edx
  802886:	89 50 04             	mov    %edx,0x4(%eax)
  802889:	eb 08                	jmp    802893 <insert_sorted_allocList+0x8b>
  80288b:	8b 45 08             	mov    0x8(%ebp),%eax
  80288e:	a3 44 50 80 00       	mov    %eax,0x805044
  802893:	8b 45 08             	mov    0x8(%ebp),%eax
  802896:	a3 40 50 80 00       	mov    %eax,0x805040
  80289b:	8b 45 08             	mov    0x8(%ebp),%eax
  80289e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028aa:	40                   	inc    %eax
  8028ab:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028b0:	e9 dc 01 00 00       	jmp    802a91 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8028b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b8:	8b 50 08             	mov    0x8(%eax),%edx
  8028bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028be:	8b 40 08             	mov    0x8(%eax),%eax
  8028c1:	39 c2                	cmp    %eax,%edx
  8028c3:	77 6c                	ja     802931 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8028c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028c9:	74 06                	je     8028d1 <insert_sorted_allocList+0xc9>
  8028cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028cf:	75 14                	jne    8028e5 <insert_sorted_allocList+0xdd>
  8028d1:	83 ec 04             	sub    $0x4,%esp
  8028d4:	68 f4 46 80 00       	push   $0x8046f4
  8028d9:	6a 6f                	push   $0x6f
  8028db:	68 db 46 80 00       	push   $0x8046db
  8028e0:	e8 42 e1 ff ff       	call   800a27 <_panic>
  8028e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e8:	8b 50 04             	mov    0x4(%eax),%edx
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	89 50 04             	mov    %edx,0x4(%eax)
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f7:	89 10                	mov    %edx,(%eax)
  8028f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fc:	8b 40 04             	mov    0x4(%eax),%eax
  8028ff:	85 c0                	test   %eax,%eax
  802901:	74 0d                	je     802910 <insert_sorted_allocList+0x108>
  802903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802906:	8b 40 04             	mov    0x4(%eax),%eax
  802909:	8b 55 08             	mov    0x8(%ebp),%edx
  80290c:	89 10                	mov    %edx,(%eax)
  80290e:	eb 08                	jmp    802918 <insert_sorted_allocList+0x110>
  802910:	8b 45 08             	mov    0x8(%ebp),%eax
  802913:	a3 40 50 80 00       	mov    %eax,0x805040
  802918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291b:	8b 55 08             	mov    0x8(%ebp),%edx
  80291e:	89 50 04             	mov    %edx,0x4(%eax)
  802921:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802926:	40                   	inc    %eax
  802927:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80292c:	e9 60 01 00 00       	jmp    802a91 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802931:	8b 45 08             	mov    0x8(%ebp),%eax
  802934:	8b 50 08             	mov    0x8(%eax),%edx
  802937:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293a:	8b 40 08             	mov    0x8(%eax),%eax
  80293d:	39 c2                	cmp    %eax,%edx
  80293f:	0f 82 4c 01 00 00    	jb     802a91 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802945:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802949:	75 14                	jne    80295f <insert_sorted_allocList+0x157>
  80294b:	83 ec 04             	sub    $0x4,%esp
  80294e:	68 2c 47 80 00       	push   $0x80472c
  802953:	6a 73                	push   $0x73
  802955:	68 db 46 80 00       	push   $0x8046db
  80295a:	e8 c8 e0 ff ff       	call   800a27 <_panic>
  80295f:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	89 50 04             	mov    %edx,0x4(%eax)
  80296b:	8b 45 08             	mov    0x8(%ebp),%eax
  80296e:	8b 40 04             	mov    0x4(%eax),%eax
  802971:	85 c0                	test   %eax,%eax
  802973:	74 0c                	je     802981 <insert_sorted_allocList+0x179>
  802975:	a1 44 50 80 00       	mov    0x805044,%eax
  80297a:	8b 55 08             	mov    0x8(%ebp),%edx
  80297d:	89 10                	mov    %edx,(%eax)
  80297f:	eb 08                	jmp    802989 <insert_sorted_allocList+0x181>
  802981:	8b 45 08             	mov    0x8(%ebp),%eax
  802984:	a3 40 50 80 00       	mov    %eax,0x805040
  802989:	8b 45 08             	mov    0x8(%ebp),%eax
  80298c:	a3 44 50 80 00       	mov    %eax,0x805044
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
  802994:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80299f:	40                   	inc    %eax
  8029a0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029a5:	e9 e7 00 00 00       	jmp    802a91 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8029aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8029b0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029b7:	a1 40 50 80 00       	mov    0x805040,%eax
  8029bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029bf:	e9 9d 00 00 00       	jmp    802a61 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 00                	mov    (%eax),%eax
  8029c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	8b 50 08             	mov    0x8(%eax),%edx
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	8b 40 08             	mov    0x8(%eax),%eax
  8029d8:	39 c2                	cmp    %eax,%edx
  8029da:	76 7d                	jbe    802a59 <insert_sorted_allocList+0x251>
  8029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029df:	8b 50 08             	mov    0x8(%eax),%edx
  8029e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e5:	8b 40 08             	mov    0x8(%eax),%eax
  8029e8:	39 c2                	cmp    %eax,%edx
  8029ea:	73 6d                	jae    802a59 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8029ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f0:	74 06                	je     8029f8 <insert_sorted_allocList+0x1f0>
  8029f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f6:	75 14                	jne    802a0c <insert_sorted_allocList+0x204>
  8029f8:	83 ec 04             	sub    $0x4,%esp
  8029fb:	68 50 47 80 00       	push   $0x804750
  802a00:	6a 7f                	push   $0x7f
  802a02:	68 db 46 80 00       	push   $0x8046db
  802a07:	e8 1b e0 ff ff       	call   800a27 <_panic>
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	8b 10                	mov    (%eax),%edx
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	89 10                	mov    %edx,(%eax)
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	85 c0                	test   %eax,%eax
  802a1d:	74 0b                	je     802a2a <insert_sorted_allocList+0x222>
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	8b 55 08             	mov    0x8(%ebp),%edx
  802a27:	89 50 04             	mov    %edx,0x4(%eax)
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a30:	89 10                	mov    %edx,(%eax)
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a38:	89 50 04             	mov    %edx,0x4(%eax)
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	8b 00                	mov    (%eax),%eax
  802a40:	85 c0                	test   %eax,%eax
  802a42:	75 08                	jne    802a4c <insert_sorted_allocList+0x244>
  802a44:	8b 45 08             	mov    0x8(%ebp),%eax
  802a47:	a3 44 50 80 00       	mov    %eax,0x805044
  802a4c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a51:	40                   	inc    %eax
  802a52:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a57:	eb 39                	jmp    802a92 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a59:	a1 48 50 80 00       	mov    0x805048,%eax
  802a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a65:	74 07                	je     802a6e <insert_sorted_allocList+0x266>
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	eb 05                	jmp    802a73 <insert_sorted_allocList+0x26b>
  802a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a73:	a3 48 50 80 00       	mov    %eax,0x805048
  802a78:	a1 48 50 80 00       	mov    0x805048,%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	0f 85 3f ff ff ff    	jne    8029c4 <insert_sorted_allocList+0x1bc>
  802a85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a89:	0f 85 35 ff ff ff    	jne    8029c4 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a8f:	eb 01                	jmp    802a92 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a91:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a92:	90                   	nop
  802a93:	c9                   	leave  
  802a94:	c3                   	ret    

00802a95 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a95:	55                   	push   %ebp
  802a96:	89 e5                	mov    %esp,%ebp
  802a98:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a9b:	a1 38 51 80 00       	mov    0x805138,%eax
  802aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa3:	e9 85 01 00 00       	jmp    802c2d <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 40 0c             	mov    0xc(%eax),%eax
  802aae:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab1:	0f 82 6e 01 00 00    	jb     802c25 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	8b 40 0c             	mov    0xc(%eax),%eax
  802abd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac0:	0f 85 8a 00 00 00    	jne    802b50 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802ac6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aca:	75 17                	jne    802ae3 <alloc_block_FF+0x4e>
  802acc:	83 ec 04             	sub    $0x4,%esp
  802acf:	68 84 47 80 00       	push   $0x804784
  802ad4:	68 93 00 00 00       	push   $0x93
  802ad9:	68 db 46 80 00       	push   $0x8046db
  802ade:	e8 44 df ff ff       	call   800a27 <_panic>
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 00                	mov    (%eax),%eax
  802ae8:	85 c0                	test   %eax,%eax
  802aea:	74 10                	je     802afc <alloc_block_FF+0x67>
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 00                	mov    (%eax),%eax
  802af1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af4:	8b 52 04             	mov    0x4(%edx),%edx
  802af7:	89 50 04             	mov    %edx,0x4(%eax)
  802afa:	eb 0b                	jmp    802b07 <alloc_block_FF+0x72>
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	8b 40 04             	mov    0x4(%eax),%eax
  802b02:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 40 04             	mov    0x4(%eax),%eax
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	74 0f                	je     802b20 <alloc_block_FF+0x8b>
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	8b 40 04             	mov    0x4(%eax),%eax
  802b17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1a:	8b 12                	mov    (%edx),%edx
  802b1c:	89 10                	mov    %edx,(%eax)
  802b1e:	eb 0a                	jmp    802b2a <alloc_block_FF+0x95>
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 00                	mov    (%eax),%eax
  802b25:	a3 38 51 80 00       	mov    %eax,0x805138
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3d:	a1 44 51 80 00       	mov    0x805144,%eax
  802b42:	48                   	dec    %eax
  802b43:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	e9 10 01 00 00       	jmp    802c60 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	8b 40 0c             	mov    0xc(%eax),%eax
  802b56:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b59:	0f 86 c6 00 00 00    	jbe    802c25 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b5f:	a1 48 51 80 00       	mov    0x805148,%eax
  802b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	8b 50 08             	mov    0x8(%eax),%edx
  802b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b70:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b76:	8b 55 08             	mov    0x8(%ebp),%edx
  802b79:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b80:	75 17                	jne    802b99 <alloc_block_FF+0x104>
  802b82:	83 ec 04             	sub    $0x4,%esp
  802b85:	68 84 47 80 00       	push   $0x804784
  802b8a:	68 9b 00 00 00       	push   $0x9b
  802b8f:	68 db 46 80 00       	push   $0x8046db
  802b94:	e8 8e de ff ff       	call   800a27 <_panic>
  802b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9c:	8b 00                	mov    (%eax),%eax
  802b9e:	85 c0                	test   %eax,%eax
  802ba0:	74 10                	je     802bb2 <alloc_block_FF+0x11d>
  802ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802baa:	8b 52 04             	mov    0x4(%edx),%edx
  802bad:	89 50 04             	mov    %edx,0x4(%eax)
  802bb0:	eb 0b                	jmp    802bbd <alloc_block_FF+0x128>
  802bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb5:	8b 40 04             	mov    0x4(%eax),%eax
  802bb8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc0:	8b 40 04             	mov    0x4(%eax),%eax
  802bc3:	85 c0                	test   %eax,%eax
  802bc5:	74 0f                	je     802bd6 <alloc_block_FF+0x141>
  802bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bca:	8b 40 04             	mov    0x4(%eax),%eax
  802bcd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd0:	8b 12                	mov    (%edx),%edx
  802bd2:	89 10                	mov    %edx,(%eax)
  802bd4:	eb 0a                	jmp    802be0 <alloc_block_FF+0x14b>
  802bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	a3 48 51 80 00       	mov    %eax,0x805148
  802be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf3:	a1 54 51 80 00       	mov    0x805154,%eax
  802bf8:	48                   	dec    %eax
  802bf9:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 50 08             	mov    0x8(%eax),%edx
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	01 c2                	add    %eax,%edx
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	8b 40 0c             	mov    0xc(%eax),%eax
  802c15:	2b 45 08             	sub    0x8(%ebp),%eax
  802c18:	89 c2                	mov    %eax,%edx
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c23:	eb 3b                	jmp    802c60 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c25:	a1 40 51 80 00       	mov    0x805140,%eax
  802c2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c31:	74 07                	je     802c3a <alloc_block_FF+0x1a5>
  802c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c36:	8b 00                	mov    (%eax),%eax
  802c38:	eb 05                	jmp    802c3f <alloc_block_FF+0x1aa>
  802c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3f:	a3 40 51 80 00       	mov    %eax,0x805140
  802c44:	a1 40 51 80 00       	mov    0x805140,%eax
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	0f 85 57 fe ff ff    	jne    802aa8 <alloc_block_FF+0x13>
  802c51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c55:	0f 85 4d fe ff ff    	jne    802aa8 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802c5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c60:	c9                   	leave  
  802c61:	c3                   	ret    

00802c62 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c62:	55                   	push   %ebp
  802c63:	89 e5                	mov    %esp,%ebp
  802c65:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802c68:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c6f:	a1 38 51 80 00       	mov    0x805138,%eax
  802c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c77:	e9 df 00 00 00       	jmp    802d5b <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c82:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c85:	0f 82 c8 00 00 00    	jb     802d53 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c91:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c94:	0f 85 8a 00 00 00    	jne    802d24 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9e:	75 17                	jne    802cb7 <alloc_block_BF+0x55>
  802ca0:	83 ec 04             	sub    $0x4,%esp
  802ca3:	68 84 47 80 00       	push   $0x804784
  802ca8:	68 b7 00 00 00       	push   $0xb7
  802cad:	68 db 46 80 00       	push   $0x8046db
  802cb2:	e8 70 dd ff ff       	call   800a27 <_panic>
  802cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cba:	8b 00                	mov    (%eax),%eax
  802cbc:	85 c0                	test   %eax,%eax
  802cbe:	74 10                	je     802cd0 <alloc_block_BF+0x6e>
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 00                	mov    (%eax),%eax
  802cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc8:	8b 52 04             	mov    0x4(%edx),%edx
  802ccb:	89 50 04             	mov    %edx,0x4(%eax)
  802cce:	eb 0b                	jmp    802cdb <alloc_block_BF+0x79>
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	8b 40 04             	mov    0x4(%eax),%eax
  802cd6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 40 04             	mov    0x4(%eax),%eax
  802ce1:	85 c0                	test   %eax,%eax
  802ce3:	74 0f                	je     802cf4 <alloc_block_BF+0x92>
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 40 04             	mov    0x4(%eax),%eax
  802ceb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cee:	8b 12                	mov    (%edx),%edx
  802cf0:	89 10                	mov    %edx,(%eax)
  802cf2:	eb 0a                	jmp    802cfe <alloc_block_BF+0x9c>
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf7:	8b 00                	mov    (%eax),%eax
  802cf9:	a3 38 51 80 00       	mov    %eax,0x805138
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d11:	a1 44 51 80 00       	mov    0x805144,%eax
  802d16:	48                   	dec    %eax
  802d17:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1f:	e9 4d 01 00 00       	jmp    802e71 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d2d:	76 24                	jbe    802d53 <alloc_block_BF+0xf1>
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	8b 40 0c             	mov    0xc(%eax),%eax
  802d35:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d38:	73 19                	jae    802d53 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802d3a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d44:	8b 40 0c             	mov    0xc(%eax),%eax
  802d47:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4d:	8b 40 08             	mov    0x8(%eax),%eax
  802d50:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802d53:	a1 40 51 80 00       	mov    0x805140,%eax
  802d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5f:	74 07                	je     802d68 <alloc_block_BF+0x106>
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 00                	mov    (%eax),%eax
  802d66:	eb 05                	jmp    802d6d <alloc_block_BF+0x10b>
  802d68:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6d:	a3 40 51 80 00       	mov    %eax,0x805140
  802d72:	a1 40 51 80 00       	mov    0x805140,%eax
  802d77:	85 c0                	test   %eax,%eax
  802d79:	0f 85 fd fe ff ff    	jne    802c7c <alloc_block_BF+0x1a>
  802d7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d83:	0f 85 f3 fe ff ff    	jne    802c7c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802d89:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d8d:	0f 84 d9 00 00 00    	je     802e6c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d93:	a1 48 51 80 00       	mov    0x805148,%eax
  802d98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802da1:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da7:	8b 55 08             	mov    0x8(%ebp),%edx
  802daa:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802dad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802db1:	75 17                	jne    802dca <alloc_block_BF+0x168>
  802db3:	83 ec 04             	sub    $0x4,%esp
  802db6:	68 84 47 80 00       	push   $0x804784
  802dbb:	68 c7 00 00 00       	push   $0xc7
  802dc0:	68 db 46 80 00       	push   $0x8046db
  802dc5:	e8 5d dc ff ff       	call   800a27 <_panic>
  802dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dcd:	8b 00                	mov    (%eax),%eax
  802dcf:	85 c0                	test   %eax,%eax
  802dd1:	74 10                	je     802de3 <alloc_block_BF+0x181>
  802dd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd6:	8b 00                	mov    (%eax),%eax
  802dd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ddb:	8b 52 04             	mov    0x4(%edx),%edx
  802dde:	89 50 04             	mov    %edx,0x4(%eax)
  802de1:	eb 0b                	jmp    802dee <alloc_block_BF+0x18c>
  802de3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de6:	8b 40 04             	mov    0x4(%eax),%eax
  802de9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df1:	8b 40 04             	mov    0x4(%eax),%eax
  802df4:	85 c0                	test   %eax,%eax
  802df6:	74 0f                	je     802e07 <alloc_block_BF+0x1a5>
  802df8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfb:	8b 40 04             	mov    0x4(%eax),%eax
  802dfe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e01:	8b 12                	mov    (%edx),%edx
  802e03:	89 10                	mov    %edx,(%eax)
  802e05:	eb 0a                	jmp    802e11 <alloc_block_BF+0x1af>
  802e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	a3 48 51 80 00       	mov    %eax,0x805148
  802e11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e24:	a1 54 51 80 00       	mov    0x805154,%eax
  802e29:	48                   	dec    %eax
  802e2a:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802e2f:	83 ec 08             	sub    $0x8,%esp
  802e32:	ff 75 ec             	pushl  -0x14(%ebp)
  802e35:	68 38 51 80 00       	push   $0x805138
  802e3a:	e8 71 f9 ff ff       	call   8027b0 <find_block>
  802e3f:	83 c4 10             	add    $0x10,%esp
  802e42:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802e45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e48:	8b 50 08             	mov    0x8(%eax),%edx
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	01 c2                	add    %eax,%edx
  802e50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e53:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802e56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e59:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5c:	2b 45 08             	sub    0x8(%ebp),%eax
  802e5f:	89 c2                	mov    %eax,%edx
  802e61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e64:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802e67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6a:	eb 05                	jmp    802e71 <alloc_block_BF+0x20f>
	}
	return NULL;
  802e6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e71:	c9                   	leave  
  802e72:	c3                   	ret    

00802e73 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e73:	55                   	push   %ebp
  802e74:	89 e5                	mov    %esp,%ebp
  802e76:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802e79:	a1 28 50 80 00       	mov    0x805028,%eax
  802e7e:	85 c0                	test   %eax,%eax
  802e80:	0f 85 de 01 00 00    	jne    803064 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e86:	a1 38 51 80 00       	mov    0x805138,%eax
  802e8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8e:	e9 9e 01 00 00       	jmp    803031 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	8b 40 0c             	mov    0xc(%eax),%eax
  802e99:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e9c:	0f 82 87 01 00 00    	jb     803029 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eab:	0f 85 95 00 00 00    	jne    802f46 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802eb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb5:	75 17                	jne    802ece <alloc_block_NF+0x5b>
  802eb7:	83 ec 04             	sub    $0x4,%esp
  802eba:	68 84 47 80 00       	push   $0x804784
  802ebf:	68 e0 00 00 00       	push   $0xe0
  802ec4:	68 db 46 80 00       	push   $0x8046db
  802ec9:	e8 59 db ff ff       	call   800a27 <_panic>
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	8b 00                	mov    (%eax),%eax
  802ed3:	85 c0                	test   %eax,%eax
  802ed5:	74 10                	je     802ee7 <alloc_block_NF+0x74>
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	8b 00                	mov    (%eax),%eax
  802edc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802edf:	8b 52 04             	mov    0x4(%edx),%edx
  802ee2:	89 50 04             	mov    %edx,0x4(%eax)
  802ee5:	eb 0b                	jmp    802ef2 <alloc_block_NF+0x7f>
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	8b 40 04             	mov    0x4(%eax),%eax
  802eed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 40 04             	mov    0x4(%eax),%eax
  802ef8:	85 c0                	test   %eax,%eax
  802efa:	74 0f                	je     802f0b <alloc_block_NF+0x98>
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	8b 40 04             	mov    0x4(%eax),%eax
  802f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f05:	8b 12                	mov    (%edx),%edx
  802f07:	89 10                	mov    %edx,(%eax)
  802f09:	eb 0a                	jmp    802f15 <alloc_block_NF+0xa2>
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 00                	mov    (%eax),%eax
  802f10:	a3 38 51 80 00       	mov    %eax,0x805138
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f28:	a1 44 51 80 00       	mov    0x805144,%eax
  802f2d:	48                   	dec    %eax
  802f2e:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 40 08             	mov    0x8(%eax),%eax
  802f39:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	e9 f8 04 00 00       	jmp    80343e <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f49:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f4f:	0f 86 d4 00 00 00    	jbe    803029 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f55:	a1 48 51 80 00       	mov    0x805148,%eax
  802f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	8b 50 08             	mov    0x8(%eax),%edx
  802f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f66:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f76:	75 17                	jne    802f8f <alloc_block_NF+0x11c>
  802f78:	83 ec 04             	sub    $0x4,%esp
  802f7b:	68 84 47 80 00       	push   $0x804784
  802f80:	68 e9 00 00 00       	push   $0xe9
  802f85:	68 db 46 80 00       	push   $0x8046db
  802f8a:	e8 98 da ff ff       	call   800a27 <_panic>
  802f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f92:	8b 00                	mov    (%eax),%eax
  802f94:	85 c0                	test   %eax,%eax
  802f96:	74 10                	je     802fa8 <alloc_block_NF+0x135>
  802f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9b:	8b 00                	mov    (%eax),%eax
  802f9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa0:	8b 52 04             	mov    0x4(%edx),%edx
  802fa3:	89 50 04             	mov    %edx,0x4(%eax)
  802fa6:	eb 0b                	jmp    802fb3 <alloc_block_NF+0x140>
  802fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fab:	8b 40 04             	mov    0x4(%eax),%eax
  802fae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb6:	8b 40 04             	mov    0x4(%eax),%eax
  802fb9:	85 c0                	test   %eax,%eax
  802fbb:	74 0f                	je     802fcc <alloc_block_NF+0x159>
  802fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc0:	8b 40 04             	mov    0x4(%eax),%eax
  802fc3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fc6:	8b 12                	mov    (%edx),%edx
  802fc8:	89 10                	mov    %edx,(%eax)
  802fca:	eb 0a                	jmp    802fd6 <alloc_block_NF+0x163>
  802fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcf:	8b 00                	mov    (%eax),%eax
  802fd1:	a3 48 51 80 00       	mov    %eax,0x805148
  802fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe9:	a1 54 51 80 00       	mov    0x805154,%eax
  802fee:	48                   	dec    %eax
  802fef:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff7:	8b 40 08             	mov    0x8(%eax),%eax
  802ffa:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	8b 50 08             	mov    0x8(%eax),%edx
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	01 c2                	add    %eax,%edx
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803013:	8b 40 0c             	mov    0xc(%eax),%eax
  803016:	2b 45 08             	sub    0x8(%ebp),%eax
  803019:	89 c2                	mov    %eax,%edx
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803024:	e9 15 04 00 00       	jmp    80343e <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803029:	a1 40 51 80 00       	mov    0x805140,%eax
  80302e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803031:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803035:	74 07                	je     80303e <alloc_block_NF+0x1cb>
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	8b 00                	mov    (%eax),%eax
  80303c:	eb 05                	jmp    803043 <alloc_block_NF+0x1d0>
  80303e:	b8 00 00 00 00       	mov    $0x0,%eax
  803043:	a3 40 51 80 00       	mov    %eax,0x805140
  803048:	a1 40 51 80 00       	mov    0x805140,%eax
  80304d:	85 c0                	test   %eax,%eax
  80304f:	0f 85 3e fe ff ff    	jne    802e93 <alloc_block_NF+0x20>
  803055:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803059:	0f 85 34 fe ff ff    	jne    802e93 <alloc_block_NF+0x20>
  80305f:	e9 d5 03 00 00       	jmp    803439 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803064:	a1 38 51 80 00       	mov    0x805138,%eax
  803069:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80306c:	e9 b1 01 00 00       	jmp    803222 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	8b 50 08             	mov    0x8(%eax),%edx
  803077:	a1 28 50 80 00       	mov    0x805028,%eax
  80307c:	39 c2                	cmp    %eax,%edx
  80307e:	0f 82 96 01 00 00    	jb     80321a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	8b 40 0c             	mov    0xc(%eax),%eax
  80308a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80308d:	0f 82 87 01 00 00    	jb     80321a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803096:	8b 40 0c             	mov    0xc(%eax),%eax
  803099:	3b 45 08             	cmp    0x8(%ebp),%eax
  80309c:	0f 85 95 00 00 00    	jne    803137 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8030a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a6:	75 17                	jne    8030bf <alloc_block_NF+0x24c>
  8030a8:	83 ec 04             	sub    $0x4,%esp
  8030ab:	68 84 47 80 00       	push   $0x804784
  8030b0:	68 fc 00 00 00       	push   $0xfc
  8030b5:	68 db 46 80 00       	push   $0x8046db
  8030ba:	e8 68 d9 ff ff       	call   800a27 <_panic>
  8030bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c2:	8b 00                	mov    (%eax),%eax
  8030c4:	85 c0                	test   %eax,%eax
  8030c6:	74 10                	je     8030d8 <alloc_block_NF+0x265>
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	8b 00                	mov    (%eax),%eax
  8030cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030d0:	8b 52 04             	mov    0x4(%edx),%edx
  8030d3:	89 50 04             	mov    %edx,0x4(%eax)
  8030d6:	eb 0b                	jmp    8030e3 <alloc_block_NF+0x270>
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	8b 40 04             	mov    0x4(%eax),%eax
  8030de:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	8b 40 04             	mov    0x4(%eax),%eax
  8030e9:	85 c0                	test   %eax,%eax
  8030eb:	74 0f                	je     8030fc <alloc_block_NF+0x289>
  8030ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f0:	8b 40 04             	mov    0x4(%eax),%eax
  8030f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f6:	8b 12                	mov    (%edx),%edx
  8030f8:	89 10                	mov    %edx,(%eax)
  8030fa:	eb 0a                	jmp    803106 <alloc_block_NF+0x293>
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	8b 00                	mov    (%eax),%eax
  803101:	a3 38 51 80 00       	mov    %eax,0x805138
  803106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803109:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803119:	a1 44 51 80 00       	mov    0x805144,%eax
  80311e:	48                   	dec    %eax
  80311f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803127:	8b 40 08             	mov    0x8(%eax),%eax
  80312a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80312f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803132:	e9 07 03 00 00       	jmp    80343e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313a:	8b 40 0c             	mov    0xc(%eax),%eax
  80313d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803140:	0f 86 d4 00 00 00    	jbe    80321a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803146:	a1 48 51 80 00       	mov    0x805148,%eax
  80314b:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80314e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803151:	8b 50 08             	mov    0x8(%eax),%edx
  803154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803157:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80315a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315d:	8b 55 08             	mov    0x8(%ebp),%edx
  803160:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803163:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803167:	75 17                	jne    803180 <alloc_block_NF+0x30d>
  803169:	83 ec 04             	sub    $0x4,%esp
  80316c:	68 84 47 80 00       	push   $0x804784
  803171:	68 04 01 00 00       	push   $0x104
  803176:	68 db 46 80 00       	push   $0x8046db
  80317b:	e8 a7 d8 ff ff       	call   800a27 <_panic>
  803180:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803183:	8b 00                	mov    (%eax),%eax
  803185:	85 c0                	test   %eax,%eax
  803187:	74 10                	je     803199 <alloc_block_NF+0x326>
  803189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318c:	8b 00                	mov    (%eax),%eax
  80318e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803191:	8b 52 04             	mov    0x4(%edx),%edx
  803194:	89 50 04             	mov    %edx,0x4(%eax)
  803197:	eb 0b                	jmp    8031a4 <alloc_block_NF+0x331>
  803199:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319c:	8b 40 04             	mov    0x4(%eax),%eax
  80319f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a7:	8b 40 04             	mov    0x4(%eax),%eax
  8031aa:	85 c0                	test   %eax,%eax
  8031ac:	74 0f                	je     8031bd <alloc_block_NF+0x34a>
  8031ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b1:	8b 40 04             	mov    0x4(%eax),%eax
  8031b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b7:	8b 12                	mov    (%edx),%edx
  8031b9:	89 10                	mov    %edx,(%eax)
  8031bb:	eb 0a                	jmp    8031c7 <alloc_block_NF+0x354>
  8031bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c0:	8b 00                	mov    (%eax),%eax
  8031c2:	a3 48 51 80 00       	mov    %eax,0x805148
  8031c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031da:	a1 54 51 80 00       	mov    0x805154,%eax
  8031df:	48                   	dec    %eax
  8031e0:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e8:	8b 40 08             	mov    0x8(%eax),%eax
  8031eb:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8031f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f3:	8b 50 08             	mov    0x8(%eax),%edx
  8031f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f9:	01 c2                	add    %eax,%edx
  8031fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fe:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803204:	8b 40 0c             	mov    0xc(%eax),%eax
  803207:	2b 45 08             	sub    0x8(%ebp),%eax
  80320a:	89 c2                	mov    %eax,%edx
  80320c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803212:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803215:	e9 24 02 00 00       	jmp    80343e <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80321a:	a1 40 51 80 00       	mov    0x805140,%eax
  80321f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803222:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803226:	74 07                	je     80322f <alloc_block_NF+0x3bc>
  803228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322b:	8b 00                	mov    (%eax),%eax
  80322d:	eb 05                	jmp    803234 <alloc_block_NF+0x3c1>
  80322f:	b8 00 00 00 00       	mov    $0x0,%eax
  803234:	a3 40 51 80 00       	mov    %eax,0x805140
  803239:	a1 40 51 80 00       	mov    0x805140,%eax
  80323e:	85 c0                	test   %eax,%eax
  803240:	0f 85 2b fe ff ff    	jne    803071 <alloc_block_NF+0x1fe>
  803246:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324a:	0f 85 21 fe ff ff    	jne    803071 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803250:	a1 38 51 80 00       	mov    0x805138,%eax
  803255:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803258:	e9 ae 01 00 00       	jmp    80340b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80325d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803260:	8b 50 08             	mov    0x8(%eax),%edx
  803263:	a1 28 50 80 00       	mov    0x805028,%eax
  803268:	39 c2                	cmp    %eax,%edx
  80326a:	0f 83 93 01 00 00    	jae    803403 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803273:	8b 40 0c             	mov    0xc(%eax),%eax
  803276:	3b 45 08             	cmp    0x8(%ebp),%eax
  803279:	0f 82 84 01 00 00    	jb     803403 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80327f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803282:	8b 40 0c             	mov    0xc(%eax),%eax
  803285:	3b 45 08             	cmp    0x8(%ebp),%eax
  803288:	0f 85 95 00 00 00    	jne    803323 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80328e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803292:	75 17                	jne    8032ab <alloc_block_NF+0x438>
  803294:	83 ec 04             	sub    $0x4,%esp
  803297:	68 84 47 80 00       	push   $0x804784
  80329c:	68 14 01 00 00       	push   $0x114
  8032a1:	68 db 46 80 00       	push   $0x8046db
  8032a6:	e8 7c d7 ff ff       	call   800a27 <_panic>
  8032ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ae:	8b 00                	mov    (%eax),%eax
  8032b0:	85 c0                	test   %eax,%eax
  8032b2:	74 10                	je     8032c4 <alloc_block_NF+0x451>
  8032b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032bc:	8b 52 04             	mov    0x4(%edx),%edx
  8032bf:	89 50 04             	mov    %edx,0x4(%eax)
  8032c2:	eb 0b                	jmp    8032cf <alloc_block_NF+0x45c>
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	8b 40 04             	mov    0x4(%eax),%eax
  8032ca:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d2:	8b 40 04             	mov    0x4(%eax),%eax
  8032d5:	85 c0                	test   %eax,%eax
  8032d7:	74 0f                	je     8032e8 <alloc_block_NF+0x475>
  8032d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dc:	8b 40 04             	mov    0x4(%eax),%eax
  8032df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032e2:	8b 12                	mov    (%edx),%edx
  8032e4:	89 10                	mov    %edx,(%eax)
  8032e6:	eb 0a                	jmp    8032f2 <alloc_block_NF+0x47f>
  8032e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032eb:	8b 00                	mov    (%eax),%eax
  8032ed:	a3 38 51 80 00       	mov    %eax,0x805138
  8032f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803305:	a1 44 51 80 00       	mov    0x805144,%eax
  80330a:	48                   	dec    %eax
  80330b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803313:	8b 40 08             	mov    0x8(%eax),%eax
  803316:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80331b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331e:	e9 1b 01 00 00       	jmp    80343e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803326:	8b 40 0c             	mov    0xc(%eax),%eax
  803329:	3b 45 08             	cmp    0x8(%ebp),%eax
  80332c:	0f 86 d1 00 00 00    	jbe    803403 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803332:	a1 48 51 80 00       	mov    0x805148,%eax
  803337:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333d:	8b 50 08             	mov    0x8(%eax),%edx
  803340:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803343:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803346:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803349:	8b 55 08             	mov    0x8(%ebp),%edx
  80334c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80334f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803353:	75 17                	jne    80336c <alloc_block_NF+0x4f9>
  803355:	83 ec 04             	sub    $0x4,%esp
  803358:	68 84 47 80 00       	push   $0x804784
  80335d:	68 1c 01 00 00       	push   $0x11c
  803362:	68 db 46 80 00       	push   $0x8046db
  803367:	e8 bb d6 ff ff       	call   800a27 <_panic>
  80336c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336f:	8b 00                	mov    (%eax),%eax
  803371:	85 c0                	test   %eax,%eax
  803373:	74 10                	je     803385 <alloc_block_NF+0x512>
  803375:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803378:	8b 00                	mov    (%eax),%eax
  80337a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80337d:	8b 52 04             	mov    0x4(%edx),%edx
  803380:	89 50 04             	mov    %edx,0x4(%eax)
  803383:	eb 0b                	jmp    803390 <alloc_block_NF+0x51d>
  803385:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803388:	8b 40 04             	mov    0x4(%eax),%eax
  80338b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803390:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803393:	8b 40 04             	mov    0x4(%eax),%eax
  803396:	85 c0                	test   %eax,%eax
  803398:	74 0f                	je     8033a9 <alloc_block_NF+0x536>
  80339a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339d:	8b 40 04             	mov    0x4(%eax),%eax
  8033a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033a3:	8b 12                	mov    (%edx),%edx
  8033a5:	89 10                	mov    %edx,(%eax)
  8033a7:	eb 0a                	jmp    8033b3 <alloc_block_NF+0x540>
  8033a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ac:	8b 00                	mov    (%eax),%eax
  8033ae:	a3 48 51 80 00       	mov    %eax,0x805148
  8033b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c6:	a1 54 51 80 00       	mov    0x805154,%eax
  8033cb:	48                   	dec    %eax
  8033cc:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8033d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d4:	8b 40 08             	mov    0x8(%eax),%eax
  8033d7:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8033dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033df:	8b 50 08             	mov    0x8(%eax),%edx
  8033e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e5:	01 c2                	add    %eax,%edx
  8033e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ea:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8033ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f3:	2b 45 08             	sub    0x8(%ebp),%eax
  8033f6:	89 c2                	mov    %eax,%edx
  8033f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fb:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803401:	eb 3b                	jmp    80343e <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803403:	a1 40 51 80 00       	mov    0x805140,%eax
  803408:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80340b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340f:	74 07                	je     803418 <alloc_block_NF+0x5a5>
  803411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803414:	8b 00                	mov    (%eax),%eax
  803416:	eb 05                	jmp    80341d <alloc_block_NF+0x5aa>
  803418:	b8 00 00 00 00       	mov    $0x0,%eax
  80341d:	a3 40 51 80 00       	mov    %eax,0x805140
  803422:	a1 40 51 80 00       	mov    0x805140,%eax
  803427:	85 c0                	test   %eax,%eax
  803429:	0f 85 2e fe ff ff    	jne    80325d <alloc_block_NF+0x3ea>
  80342f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803433:	0f 85 24 fe ff ff    	jne    80325d <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803439:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80343e:	c9                   	leave  
  80343f:	c3                   	ret    

00803440 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803440:	55                   	push   %ebp
  803441:	89 e5                	mov    %esp,%ebp
  803443:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803446:	a1 38 51 80 00       	mov    0x805138,%eax
  80344b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80344e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803453:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803456:	a1 38 51 80 00       	mov    0x805138,%eax
  80345b:	85 c0                	test   %eax,%eax
  80345d:	74 14                	je     803473 <insert_sorted_with_merge_freeList+0x33>
  80345f:	8b 45 08             	mov    0x8(%ebp),%eax
  803462:	8b 50 08             	mov    0x8(%eax),%edx
  803465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803468:	8b 40 08             	mov    0x8(%eax),%eax
  80346b:	39 c2                	cmp    %eax,%edx
  80346d:	0f 87 9b 01 00 00    	ja     80360e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803473:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803477:	75 17                	jne    803490 <insert_sorted_with_merge_freeList+0x50>
  803479:	83 ec 04             	sub    $0x4,%esp
  80347c:	68 b8 46 80 00       	push   $0x8046b8
  803481:	68 38 01 00 00       	push   $0x138
  803486:	68 db 46 80 00       	push   $0x8046db
  80348b:	e8 97 d5 ff ff       	call   800a27 <_panic>
  803490:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803496:	8b 45 08             	mov    0x8(%ebp),%eax
  803499:	89 10                	mov    %edx,(%eax)
  80349b:	8b 45 08             	mov    0x8(%ebp),%eax
  80349e:	8b 00                	mov    (%eax),%eax
  8034a0:	85 c0                	test   %eax,%eax
  8034a2:	74 0d                	je     8034b1 <insert_sorted_with_merge_freeList+0x71>
  8034a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8034a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ac:	89 50 04             	mov    %edx,0x4(%eax)
  8034af:	eb 08                	jmp    8034b9 <insert_sorted_with_merge_freeList+0x79>
  8034b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bc:	a3 38 51 80 00       	mov    %eax,0x805138
  8034c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034cb:	a1 44 51 80 00       	mov    0x805144,%eax
  8034d0:	40                   	inc    %eax
  8034d1:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034da:	0f 84 a8 06 00 00    	je     803b88 <insert_sorted_with_merge_freeList+0x748>
  8034e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e3:	8b 50 08             	mov    0x8(%eax),%edx
  8034e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ec:	01 c2                	add    %eax,%edx
  8034ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f1:	8b 40 08             	mov    0x8(%eax),%eax
  8034f4:	39 c2                	cmp    %eax,%edx
  8034f6:	0f 85 8c 06 00 00    	jne    803b88 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8034fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ff:	8b 50 0c             	mov    0xc(%eax),%edx
  803502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803505:	8b 40 0c             	mov    0xc(%eax),%eax
  803508:	01 c2                	add    %eax,%edx
  80350a:	8b 45 08             	mov    0x8(%ebp),%eax
  80350d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803510:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803514:	75 17                	jne    80352d <insert_sorted_with_merge_freeList+0xed>
  803516:	83 ec 04             	sub    $0x4,%esp
  803519:	68 84 47 80 00       	push   $0x804784
  80351e:	68 3c 01 00 00       	push   $0x13c
  803523:	68 db 46 80 00       	push   $0x8046db
  803528:	e8 fa d4 ff ff       	call   800a27 <_panic>
  80352d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803530:	8b 00                	mov    (%eax),%eax
  803532:	85 c0                	test   %eax,%eax
  803534:	74 10                	je     803546 <insert_sorted_with_merge_freeList+0x106>
  803536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803539:	8b 00                	mov    (%eax),%eax
  80353b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80353e:	8b 52 04             	mov    0x4(%edx),%edx
  803541:	89 50 04             	mov    %edx,0x4(%eax)
  803544:	eb 0b                	jmp    803551 <insert_sorted_with_merge_freeList+0x111>
  803546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803549:	8b 40 04             	mov    0x4(%eax),%eax
  80354c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803554:	8b 40 04             	mov    0x4(%eax),%eax
  803557:	85 c0                	test   %eax,%eax
  803559:	74 0f                	je     80356a <insert_sorted_with_merge_freeList+0x12a>
  80355b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355e:	8b 40 04             	mov    0x4(%eax),%eax
  803561:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803564:	8b 12                	mov    (%edx),%edx
  803566:	89 10                	mov    %edx,(%eax)
  803568:	eb 0a                	jmp    803574 <insert_sorted_with_merge_freeList+0x134>
  80356a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356d:	8b 00                	mov    (%eax),%eax
  80356f:	a3 38 51 80 00       	mov    %eax,0x805138
  803574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803577:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80357d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803580:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803587:	a1 44 51 80 00       	mov    0x805144,%eax
  80358c:	48                   	dec    %eax
  80358d:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803595:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80359c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8035a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035aa:	75 17                	jne    8035c3 <insert_sorted_with_merge_freeList+0x183>
  8035ac:	83 ec 04             	sub    $0x4,%esp
  8035af:	68 b8 46 80 00       	push   $0x8046b8
  8035b4:	68 3f 01 00 00       	push   $0x13f
  8035b9:	68 db 46 80 00       	push   $0x8046db
  8035be:	e8 64 d4 ff ff       	call   800a27 <_panic>
  8035c3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035cc:	89 10                	mov    %edx,(%eax)
  8035ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d1:	8b 00                	mov    (%eax),%eax
  8035d3:	85 c0                	test   %eax,%eax
  8035d5:	74 0d                	je     8035e4 <insert_sorted_with_merge_freeList+0x1a4>
  8035d7:	a1 48 51 80 00       	mov    0x805148,%eax
  8035dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035df:	89 50 04             	mov    %edx,0x4(%eax)
  8035e2:	eb 08                	jmp    8035ec <insert_sorted_with_merge_freeList+0x1ac>
  8035e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ef:	a3 48 51 80 00       	mov    %eax,0x805148
  8035f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035fe:	a1 54 51 80 00       	mov    0x805154,%eax
  803603:	40                   	inc    %eax
  803604:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803609:	e9 7a 05 00 00       	jmp    803b88 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80360e:	8b 45 08             	mov    0x8(%ebp),%eax
  803611:	8b 50 08             	mov    0x8(%eax),%edx
  803614:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803617:	8b 40 08             	mov    0x8(%eax),%eax
  80361a:	39 c2                	cmp    %eax,%edx
  80361c:	0f 82 14 01 00 00    	jb     803736 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803622:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803625:	8b 50 08             	mov    0x8(%eax),%edx
  803628:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80362b:	8b 40 0c             	mov    0xc(%eax),%eax
  80362e:	01 c2                	add    %eax,%edx
  803630:	8b 45 08             	mov    0x8(%ebp),%eax
  803633:	8b 40 08             	mov    0x8(%eax),%eax
  803636:	39 c2                	cmp    %eax,%edx
  803638:	0f 85 90 00 00 00    	jne    8036ce <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80363e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803641:	8b 50 0c             	mov    0xc(%eax),%edx
  803644:	8b 45 08             	mov    0x8(%ebp),%eax
  803647:	8b 40 0c             	mov    0xc(%eax),%eax
  80364a:	01 c2                	add    %eax,%edx
  80364c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80364f:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803652:	8b 45 08             	mov    0x8(%ebp),%eax
  803655:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80365c:	8b 45 08             	mov    0x8(%ebp),%eax
  80365f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803666:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80366a:	75 17                	jne    803683 <insert_sorted_with_merge_freeList+0x243>
  80366c:	83 ec 04             	sub    $0x4,%esp
  80366f:	68 b8 46 80 00       	push   $0x8046b8
  803674:	68 49 01 00 00       	push   $0x149
  803679:	68 db 46 80 00       	push   $0x8046db
  80367e:	e8 a4 d3 ff ff       	call   800a27 <_panic>
  803683:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803689:	8b 45 08             	mov    0x8(%ebp),%eax
  80368c:	89 10                	mov    %edx,(%eax)
  80368e:	8b 45 08             	mov    0x8(%ebp),%eax
  803691:	8b 00                	mov    (%eax),%eax
  803693:	85 c0                	test   %eax,%eax
  803695:	74 0d                	je     8036a4 <insert_sorted_with_merge_freeList+0x264>
  803697:	a1 48 51 80 00       	mov    0x805148,%eax
  80369c:	8b 55 08             	mov    0x8(%ebp),%edx
  80369f:	89 50 04             	mov    %edx,0x4(%eax)
  8036a2:	eb 08                	jmp    8036ac <insert_sorted_with_merge_freeList+0x26c>
  8036a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8036af:	a3 48 51 80 00       	mov    %eax,0x805148
  8036b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036be:	a1 54 51 80 00       	mov    0x805154,%eax
  8036c3:	40                   	inc    %eax
  8036c4:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036c9:	e9 bb 04 00 00       	jmp    803b89 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8036ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036d2:	75 17                	jne    8036eb <insert_sorted_with_merge_freeList+0x2ab>
  8036d4:	83 ec 04             	sub    $0x4,%esp
  8036d7:	68 2c 47 80 00       	push   $0x80472c
  8036dc:	68 4c 01 00 00       	push   $0x14c
  8036e1:	68 db 46 80 00       	push   $0x8046db
  8036e6:	e8 3c d3 ff ff       	call   800a27 <_panic>
  8036eb:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8036f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f4:	89 50 04             	mov    %edx,0x4(%eax)
  8036f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fa:	8b 40 04             	mov    0x4(%eax),%eax
  8036fd:	85 c0                	test   %eax,%eax
  8036ff:	74 0c                	je     80370d <insert_sorted_with_merge_freeList+0x2cd>
  803701:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803706:	8b 55 08             	mov    0x8(%ebp),%edx
  803709:	89 10                	mov    %edx,(%eax)
  80370b:	eb 08                	jmp    803715 <insert_sorted_with_merge_freeList+0x2d5>
  80370d:	8b 45 08             	mov    0x8(%ebp),%eax
  803710:	a3 38 51 80 00       	mov    %eax,0x805138
  803715:	8b 45 08             	mov    0x8(%ebp),%eax
  803718:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80371d:	8b 45 08             	mov    0x8(%ebp),%eax
  803720:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803726:	a1 44 51 80 00       	mov    0x805144,%eax
  80372b:	40                   	inc    %eax
  80372c:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803731:	e9 53 04 00 00       	jmp    803b89 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803736:	a1 38 51 80 00       	mov    0x805138,%eax
  80373b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80373e:	e9 15 04 00 00       	jmp    803b58 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803746:	8b 00                	mov    (%eax),%eax
  803748:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80374b:	8b 45 08             	mov    0x8(%ebp),%eax
  80374e:	8b 50 08             	mov    0x8(%eax),%edx
  803751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803754:	8b 40 08             	mov    0x8(%eax),%eax
  803757:	39 c2                	cmp    %eax,%edx
  803759:	0f 86 f1 03 00 00    	jbe    803b50 <insert_sorted_with_merge_freeList+0x710>
  80375f:	8b 45 08             	mov    0x8(%ebp),%eax
  803762:	8b 50 08             	mov    0x8(%eax),%edx
  803765:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803768:	8b 40 08             	mov    0x8(%eax),%eax
  80376b:	39 c2                	cmp    %eax,%edx
  80376d:	0f 83 dd 03 00 00    	jae    803b50 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803776:	8b 50 08             	mov    0x8(%eax),%edx
  803779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377c:	8b 40 0c             	mov    0xc(%eax),%eax
  80377f:	01 c2                	add    %eax,%edx
  803781:	8b 45 08             	mov    0x8(%ebp),%eax
  803784:	8b 40 08             	mov    0x8(%eax),%eax
  803787:	39 c2                	cmp    %eax,%edx
  803789:	0f 85 b9 01 00 00    	jne    803948 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80378f:	8b 45 08             	mov    0x8(%ebp),%eax
  803792:	8b 50 08             	mov    0x8(%eax),%edx
  803795:	8b 45 08             	mov    0x8(%ebp),%eax
  803798:	8b 40 0c             	mov    0xc(%eax),%eax
  80379b:	01 c2                	add    %eax,%edx
  80379d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a0:	8b 40 08             	mov    0x8(%eax),%eax
  8037a3:	39 c2                	cmp    %eax,%edx
  8037a5:	0f 85 0d 01 00 00    	jne    8038b8 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8037ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ae:	8b 50 0c             	mov    0xc(%eax),%edx
  8037b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8037b7:	01 c2                	add    %eax,%edx
  8037b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bc:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8037bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037c3:	75 17                	jne    8037dc <insert_sorted_with_merge_freeList+0x39c>
  8037c5:	83 ec 04             	sub    $0x4,%esp
  8037c8:	68 84 47 80 00       	push   $0x804784
  8037cd:	68 5c 01 00 00       	push   $0x15c
  8037d2:	68 db 46 80 00       	push   $0x8046db
  8037d7:	e8 4b d2 ff ff       	call   800a27 <_panic>
  8037dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037df:	8b 00                	mov    (%eax),%eax
  8037e1:	85 c0                	test   %eax,%eax
  8037e3:	74 10                	je     8037f5 <insert_sorted_with_merge_freeList+0x3b5>
  8037e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e8:	8b 00                	mov    (%eax),%eax
  8037ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037ed:	8b 52 04             	mov    0x4(%edx),%edx
  8037f0:	89 50 04             	mov    %edx,0x4(%eax)
  8037f3:	eb 0b                	jmp    803800 <insert_sorted_with_merge_freeList+0x3c0>
  8037f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f8:	8b 40 04             	mov    0x4(%eax),%eax
  8037fb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803803:	8b 40 04             	mov    0x4(%eax),%eax
  803806:	85 c0                	test   %eax,%eax
  803808:	74 0f                	je     803819 <insert_sorted_with_merge_freeList+0x3d9>
  80380a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80380d:	8b 40 04             	mov    0x4(%eax),%eax
  803810:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803813:	8b 12                	mov    (%edx),%edx
  803815:	89 10                	mov    %edx,(%eax)
  803817:	eb 0a                	jmp    803823 <insert_sorted_with_merge_freeList+0x3e3>
  803819:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381c:	8b 00                	mov    (%eax),%eax
  80381e:	a3 38 51 80 00       	mov    %eax,0x805138
  803823:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803826:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80382c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803836:	a1 44 51 80 00       	mov    0x805144,%eax
  80383b:	48                   	dec    %eax
  80383c:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803841:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803844:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80384b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803855:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803859:	75 17                	jne    803872 <insert_sorted_with_merge_freeList+0x432>
  80385b:	83 ec 04             	sub    $0x4,%esp
  80385e:	68 b8 46 80 00       	push   $0x8046b8
  803863:	68 5f 01 00 00       	push   $0x15f
  803868:	68 db 46 80 00       	push   $0x8046db
  80386d:	e8 b5 d1 ff ff       	call   800a27 <_panic>
  803872:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803878:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387b:	89 10                	mov    %edx,(%eax)
  80387d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803880:	8b 00                	mov    (%eax),%eax
  803882:	85 c0                	test   %eax,%eax
  803884:	74 0d                	je     803893 <insert_sorted_with_merge_freeList+0x453>
  803886:	a1 48 51 80 00       	mov    0x805148,%eax
  80388b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80388e:	89 50 04             	mov    %edx,0x4(%eax)
  803891:	eb 08                	jmp    80389b <insert_sorted_with_merge_freeList+0x45b>
  803893:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803896:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80389b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389e:	a3 48 51 80 00       	mov    %eax,0x805148
  8038a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ad:	a1 54 51 80 00       	mov    0x805154,%eax
  8038b2:	40                   	inc    %eax
  8038b3:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8038b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bb:	8b 50 0c             	mov    0xc(%eax),%edx
  8038be:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8038c4:	01 c2                	add    %eax,%edx
  8038c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c9:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8038cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8038d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8038e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038e4:	75 17                	jne    8038fd <insert_sorted_with_merge_freeList+0x4bd>
  8038e6:	83 ec 04             	sub    $0x4,%esp
  8038e9:	68 b8 46 80 00       	push   $0x8046b8
  8038ee:	68 64 01 00 00       	push   $0x164
  8038f3:	68 db 46 80 00       	push   $0x8046db
  8038f8:	e8 2a d1 ff ff       	call   800a27 <_panic>
  8038fd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803903:	8b 45 08             	mov    0x8(%ebp),%eax
  803906:	89 10                	mov    %edx,(%eax)
  803908:	8b 45 08             	mov    0x8(%ebp),%eax
  80390b:	8b 00                	mov    (%eax),%eax
  80390d:	85 c0                	test   %eax,%eax
  80390f:	74 0d                	je     80391e <insert_sorted_with_merge_freeList+0x4de>
  803911:	a1 48 51 80 00       	mov    0x805148,%eax
  803916:	8b 55 08             	mov    0x8(%ebp),%edx
  803919:	89 50 04             	mov    %edx,0x4(%eax)
  80391c:	eb 08                	jmp    803926 <insert_sorted_with_merge_freeList+0x4e6>
  80391e:	8b 45 08             	mov    0x8(%ebp),%eax
  803921:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803926:	8b 45 08             	mov    0x8(%ebp),%eax
  803929:	a3 48 51 80 00       	mov    %eax,0x805148
  80392e:	8b 45 08             	mov    0x8(%ebp),%eax
  803931:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803938:	a1 54 51 80 00       	mov    0x805154,%eax
  80393d:	40                   	inc    %eax
  80393e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803943:	e9 41 02 00 00       	jmp    803b89 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803948:	8b 45 08             	mov    0x8(%ebp),%eax
  80394b:	8b 50 08             	mov    0x8(%eax),%edx
  80394e:	8b 45 08             	mov    0x8(%ebp),%eax
  803951:	8b 40 0c             	mov    0xc(%eax),%eax
  803954:	01 c2                	add    %eax,%edx
  803956:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803959:	8b 40 08             	mov    0x8(%eax),%eax
  80395c:	39 c2                	cmp    %eax,%edx
  80395e:	0f 85 7c 01 00 00    	jne    803ae0 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803964:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803968:	74 06                	je     803970 <insert_sorted_with_merge_freeList+0x530>
  80396a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80396e:	75 17                	jne    803987 <insert_sorted_with_merge_freeList+0x547>
  803970:	83 ec 04             	sub    $0x4,%esp
  803973:	68 f4 46 80 00       	push   $0x8046f4
  803978:	68 69 01 00 00       	push   $0x169
  80397d:	68 db 46 80 00       	push   $0x8046db
  803982:	e8 a0 d0 ff ff       	call   800a27 <_panic>
  803987:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398a:	8b 50 04             	mov    0x4(%eax),%edx
  80398d:	8b 45 08             	mov    0x8(%ebp),%eax
  803990:	89 50 04             	mov    %edx,0x4(%eax)
  803993:	8b 45 08             	mov    0x8(%ebp),%eax
  803996:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803999:	89 10                	mov    %edx,(%eax)
  80399b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399e:	8b 40 04             	mov    0x4(%eax),%eax
  8039a1:	85 c0                	test   %eax,%eax
  8039a3:	74 0d                	je     8039b2 <insert_sorted_with_merge_freeList+0x572>
  8039a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a8:	8b 40 04             	mov    0x4(%eax),%eax
  8039ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8039ae:	89 10                	mov    %edx,(%eax)
  8039b0:	eb 08                	jmp    8039ba <insert_sorted_with_merge_freeList+0x57a>
  8039b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b5:	a3 38 51 80 00       	mov    %eax,0x805138
  8039ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8039c0:	89 50 04             	mov    %edx,0x4(%eax)
  8039c3:	a1 44 51 80 00       	mov    0x805144,%eax
  8039c8:	40                   	inc    %eax
  8039c9:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8039ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d1:	8b 50 0c             	mov    0xc(%eax),%edx
  8039d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8039da:	01 c2                	add    %eax,%edx
  8039dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039df:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8039e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039e6:	75 17                	jne    8039ff <insert_sorted_with_merge_freeList+0x5bf>
  8039e8:	83 ec 04             	sub    $0x4,%esp
  8039eb:	68 84 47 80 00       	push   $0x804784
  8039f0:	68 6b 01 00 00       	push   $0x16b
  8039f5:	68 db 46 80 00       	push   $0x8046db
  8039fa:	e8 28 d0 ff ff       	call   800a27 <_panic>
  8039ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a02:	8b 00                	mov    (%eax),%eax
  803a04:	85 c0                	test   %eax,%eax
  803a06:	74 10                	je     803a18 <insert_sorted_with_merge_freeList+0x5d8>
  803a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0b:	8b 00                	mov    (%eax),%eax
  803a0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a10:	8b 52 04             	mov    0x4(%edx),%edx
  803a13:	89 50 04             	mov    %edx,0x4(%eax)
  803a16:	eb 0b                	jmp    803a23 <insert_sorted_with_merge_freeList+0x5e3>
  803a18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a1b:	8b 40 04             	mov    0x4(%eax),%eax
  803a1e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a26:	8b 40 04             	mov    0x4(%eax),%eax
  803a29:	85 c0                	test   %eax,%eax
  803a2b:	74 0f                	je     803a3c <insert_sorted_with_merge_freeList+0x5fc>
  803a2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a30:	8b 40 04             	mov    0x4(%eax),%eax
  803a33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a36:	8b 12                	mov    (%edx),%edx
  803a38:	89 10                	mov    %edx,(%eax)
  803a3a:	eb 0a                	jmp    803a46 <insert_sorted_with_merge_freeList+0x606>
  803a3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3f:	8b 00                	mov    (%eax),%eax
  803a41:	a3 38 51 80 00       	mov    %eax,0x805138
  803a46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a59:	a1 44 51 80 00       	mov    0x805144,%eax
  803a5e:	48                   	dec    %eax
  803a5f:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803a64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a67:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a71:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a78:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a7c:	75 17                	jne    803a95 <insert_sorted_with_merge_freeList+0x655>
  803a7e:	83 ec 04             	sub    $0x4,%esp
  803a81:	68 b8 46 80 00       	push   $0x8046b8
  803a86:	68 6e 01 00 00       	push   $0x16e
  803a8b:	68 db 46 80 00       	push   $0x8046db
  803a90:	e8 92 cf ff ff       	call   800a27 <_panic>
  803a95:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a9e:	89 10                	mov    %edx,(%eax)
  803aa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa3:	8b 00                	mov    (%eax),%eax
  803aa5:	85 c0                	test   %eax,%eax
  803aa7:	74 0d                	je     803ab6 <insert_sorted_with_merge_freeList+0x676>
  803aa9:	a1 48 51 80 00       	mov    0x805148,%eax
  803aae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ab1:	89 50 04             	mov    %edx,0x4(%eax)
  803ab4:	eb 08                	jmp    803abe <insert_sorted_with_merge_freeList+0x67e>
  803ab6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac1:	a3 48 51 80 00       	mov    %eax,0x805148
  803ac6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ad0:	a1 54 51 80 00       	mov    0x805154,%eax
  803ad5:	40                   	inc    %eax
  803ad6:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803adb:	e9 a9 00 00 00       	jmp    803b89 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803ae0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ae4:	74 06                	je     803aec <insert_sorted_with_merge_freeList+0x6ac>
  803ae6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803aea:	75 17                	jne    803b03 <insert_sorted_with_merge_freeList+0x6c3>
  803aec:	83 ec 04             	sub    $0x4,%esp
  803aef:	68 50 47 80 00       	push   $0x804750
  803af4:	68 73 01 00 00       	push   $0x173
  803af9:	68 db 46 80 00       	push   $0x8046db
  803afe:	e8 24 cf ff ff       	call   800a27 <_panic>
  803b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b06:	8b 10                	mov    (%eax),%edx
  803b08:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0b:	89 10                	mov    %edx,(%eax)
  803b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b10:	8b 00                	mov    (%eax),%eax
  803b12:	85 c0                	test   %eax,%eax
  803b14:	74 0b                	je     803b21 <insert_sorted_with_merge_freeList+0x6e1>
  803b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b19:	8b 00                	mov    (%eax),%eax
  803b1b:	8b 55 08             	mov    0x8(%ebp),%edx
  803b1e:	89 50 04             	mov    %edx,0x4(%eax)
  803b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b24:	8b 55 08             	mov    0x8(%ebp),%edx
  803b27:	89 10                	mov    %edx,(%eax)
  803b29:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b2f:	89 50 04             	mov    %edx,0x4(%eax)
  803b32:	8b 45 08             	mov    0x8(%ebp),%eax
  803b35:	8b 00                	mov    (%eax),%eax
  803b37:	85 c0                	test   %eax,%eax
  803b39:	75 08                	jne    803b43 <insert_sorted_with_merge_freeList+0x703>
  803b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b43:	a1 44 51 80 00       	mov    0x805144,%eax
  803b48:	40                   	inc    %eax
  803b49:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803b4e:	eb 39                	jmp    803b89 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803b50:	a1 40 51 80 00       	mov    0x805140,%eax
  803b55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b5c:	74 07                	je     803b65 <insert_sorted_with_merge_freeList+0x725>
  803b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b61:	8b 00                	mov    (%eax),%eax
  803b63:	eb 05                	jmp    803b6a <insert_sorted_with_merge_freeList+0x72a>
  803b65:	b8 00 00 00 00       	mov    $0x0,%eax
  803b6a:	a3 40 51 80 00       	mov    %eax,0x805140
  803b6f:	a1 40 51 80 00       	mov    0x805140,%eax
  803b74:	85 c0                	test   %eax,%eax
  803b76:	0f 85 c7 fb ff ff    	jne    803743 <insert_sorted_with_merge_freeList+0x303>
  803b7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b80:	0f 85 bd fb ff ff    	jne    803743 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b86:	eb 01                	jmp    803b89 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803b88:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b89:	90                   	nop
  803b8a:	c9                   	leave  
  803b8b:	c3                   	ret    

00803b8c <__udivdi3>:
  803b8c:	55                   	push   %ebp
  803b8d:	57                   	push   %edi
  803b8e:	56                   	push   %esi
  803b8f:	53                   	push   %ebx
  803b90:	83 ec 1c             	sub    $0x1c,%esp
  803b93:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b97:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b9f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ba3:	89 ca                	mov    %ecx,%edx
  803ba5:	89 f8                	mov    %edi,%eax
  803ba7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bab:	85 f6                	test   %esi,%esi
  803bad:	75 2d                	jne    803bdc <__udivdi3+0x50>
  803baf:	39 cf                	cmp    %ecx,%edi
  803bb1:	77 65                	ja     803c18 <__udivdi3+0x8c>
  803bb3:	89 fd                	mov    %edi,%ebp
  803bb5:	85 ff                	test   %edi,%edi
  803bb7:	75 0b                	jne    803bc4 <__udivdi3+0x38>
  803bb9:	b8 01 00 00 00       	mov    $0x1,%eax
  803bbe:	31 d2                	xor    %edx,%edx
  803bc0:	f7 f7                	div    %edi
  803bc2:	89 c5                	mov    %eax,%ebp
  803bc4:	31 d2                	xor    %edx,%edx
  803bc6:	89 c8                	mov    %ecx,%eax
  803bc8:	f7 f5                	div    %ebp
  803bca:	89 c1                	mov    %eax,%ecx
  803bcc:	89 d8                	mov    %ebx,%eax
  803bce:	f7 f5                	div    %ebp
  803bd0:	89 cf                	mov    %ecx,%edi
  803bd2:	89 fa                	mov    %edi,%edx
  803bd4:	83 c4 1c             	add    $0x1c,%esp
  803bd7:	5b                   	pop    %ebx
  803bd8:	5e                   	pop    %esi
  803bd9:	5f                   	pop    %edi
  803bda:	5d                   	pop    %ebp
  803bdb:	c3                   	ret    
  803bdc:	39 ce                	cmp    %ecx,%esi
  803bde:	77 28                	ja     803c08 <__udivdi3+0x7c>
  803be0:	0f bd fe             	bsr    %esi,%edi
  803be3:	83 f7 1f             	xor    $0x1f,%edi
  803be6:	75 40                	jne    803c28 <__udivdi3+0x9c>
  803be8:	39 ce                	cmp    %ecx,%esi
  803bea:	72 0a                	jb     803bf6 <__udivdi3+0x6a>
  803bec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bf0:	0f 87 9e 00 00 00    	ja     803c94 <__udivdi3+0x108>
  803bf6:	b8 01 00 00 00       	mov    $0x1,%eax
  803bfb:	89 fa                	mov    %edi,%edx
  803bfd:	83 c4 1c             	add    $0x1c,%esp
  803c00:	5b                   	pop    %ebx
  803c01:	5e                   	pop    %esi
  803c02:	5f                   	pop    %edi
  803c03:	5d                   	pop    %ebp
  803c04:	c3                   	ret    
  803c05:	8d 76 00             	lea    0x0(%esi),%esi
  803c08:	31 ff                	xor    %edi,%edi
  803c0a:	31 c0                	xor    %eax,%eax
  803c0c:	89 fa                	mov    %edi,%edx
  803c0e:	83 c4 1c             	add    $0x1c,%esp
  803c11:	5b                   	pop    %ebx
  803c12:	5e                   	pop    %esi
  803c13:	5f                   	pop    %edi
  803c14:	5d                   	pop    %ebp
  803c15:	c3                   	ret    
  803c16:	66 90                	xchg   %ax,%ax
  803c18:	89 d8                	mov    %ebx,%eax
  803c1a:	f7 f7                	div    %edi
  803c1c:	31 ff                	xor    %edi,%edi
  803c1e:	89 fa                	mov    %edi,%edx
  803c20:	83 c4 1c             	add    $0x1c,%esp
  803c23:	5b                   	pop    %ebx
  803c24:	5e                   	pop    %esi
  803c25:	5f                   	pop    %edi
  803c26:	5d                   	pop    %ebp
  803c27:	c3                   	ret    
  803c28:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c2d:	89 eb                	mov    %ebp,%ebx
  803c2f:	29 fb                	sub    %edi,%ebx
  803c31:	89 f9                	mov    %edi,%ecx
  803c33:	d3 e6                	shl    %cl,%esi
  803c35:	89 c5                	mov    %eax,%ebp
  803c37:	88 d9                	mov    %bl,%cl
  803c39:	d3 ed                	shr    %cl,%ebp
  803c3b:	89 e9                	mov    %ebp,%ecx
  803c3d:	09 f1                	or     %esi,%ecx
  803c3f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c43:	89 f9                	mov    %edi,%ecx
  803c45:	d3 e0                	shl    %cl,%eax
  803c47:	89 c5                	mov    %eax,%ebp
  803c49:	89 d6                	mov    %edx,%esi
  803c4b:	88 d9                	mov    %bl,%cl
  803c4d:	d3 ee                	shr    %cl,%esi
  803c4f:	89 f9                	mov    %edi,%ecx
  803c51:	d3 e2                	shl    %cl,%edx
  803c53:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c57:	88 d9                	mov    %bl,%cl
  803c59:	d3 e8                	shr    %cl,%eax
  803c5b:	09 c2                	or     %eax,%edx
  803c5d:	89 d0                	mov    %edx,%eax
  803c5f:	89 f2                	mov    %esi,%edx
  803c61:	f7 74 24 0c          	divl   0xc(%esp)
  803c65:	89 d6                	mov    %edx,%esi
  803c67:	89 c3                	mov    %eax,%ebx
  803c69:	f7 e5                	mul    %ebp
  803c6b:	39 d6                	cmp    %edx,%esi
  803c6d:	72 19                	jb     803c88 <__udivdi3+0xfc>
  803c6f:	74 0b                	je     803c7c <__udivdi3+0xf0>
  803c71:	89 d8                	mov    %ebx,%eax
  803c73:	31 ff                	xor    %edi,%edi
  803c75:	e9 58 ff ff ff       	jmp    803bd2 <__udivdi3+0x46>
  803c7a:	66 90                	xchg   %ax,%ax
  803c7c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c80:	89 f9                	mov    %edi,%ecx
  803c82:	d3 e2                	shl    %cl,%edx
  803c84:	39 c2                	cmp    %eax,%edx
  803c86:	73 e9                	jae    803c71 <__udivdi3+0xe5>
  803c88:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c8b:	31 ff                	xor    %edi,%edi
  803c8d:	e9 40 ff ff ff       	jmp    803bd2 <__udivdi3+0x46>
  803c92:	66 90                	xchg   %ax,%ax
  803c94:	31 c0                	xor    %eax,%eax
  803c96:	e9 37 ff ff ff       	jmp    803bd2 <__udivdi3+0x46>
  803c9b:	90                   	nop

00803c9c <__umoddi3>:
  803c9c:	55                   	push   %ebp
  803c9d:	57                   	push   %edi
  803c9e:	56                   	push   %esi
  803c9f:	53                   	push   %ebx
  803ca0:	83 ec 1c             	sub    $0x1c,%esp
  803ca3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ca7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803cab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803caf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cb7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cbb:	89 f3                	mov    %esi,%ebx
  803cbd:	89 fa                	mov    %edi,%edx
  803cbf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cc3:	89 34 24             	mov    %esi,(%esp)
  803cc6:	85 c0                	test   %eax,%eax
  803cc8:	75 1a                	jne    803ce4 <__umoddi3+0x48>
  803cca:	39 f7                	cmp    %esi,%edi
  803ccc:	0f 86 a2 00 00 00    	jbe    803d74 <__umoddi3+0xd8>
  803cd2:	89 c8                	mov    %ecx,%eax
  803cd4:	89 f2                	mov    %esi,%edx
  803cd6:	f7 f7                	div    %edi
  803cd8:	89 d0                	mov    %edx,%eax
  803cda:	31 d2                	xor    %edx,%edx
  803cdc:	83 c4 1c             	add    $0x1c,%esp
  803cdf:	5b                   	pop    %ebx
  803ce0:	5e                   	pop    %esi
  803ce1:	5f                   	pop    %edi
  803ce2:	5d                   	pop    %ebp
  803ce3:	c3                   	ret    
  803ce4:	39 f0                	cmp    %esi,%eax
  803ce6:	0f 87 ac 00 00 00    	ja     803d98 <__umoddi3+0xfc>
  803cec:	0f bd e8             	bsr    %eax,%ebp
  803cef:	83 f5 1f             	xor    $0x1f,%ebp
  803cf2:	0f 84 ac 00 00 00    	je     803da4 <__umoddi3+0x108>
  803cf8:	bf 20 00 00 00       	mov    $0x20,%edi
  803cfd:	29 ef                	sub    %ebp,%edi
  803cff:	89 fe                	mov    %edi,%esi
  803d01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d05:	89 e9                	mov    %ebp,%ecx
  803d07:	d3 e0                	shl    %cl,%eax
  803d09:	89 d7                	mov    %edx,%edi
  803d0b:	89 f1                	mov    %esi,%ecx
  803d0d:	d3 ef                	shr    %cl,%edi
  803d0f:	09 c7                	or     %eax,%edi
  803d11:	89 e9                	mov    %ebp,%ecx
  803d13:	d3 e2                	shl    %cl,%edx
  803d15:	89 14 24             	mov    %edx,(%esp)
  803d18:	89 d8                	mov    %ebx,%eax
  803d1a:	d3 e0                	shl    %cl,%eax
  803d1c:	89 c2                	mov    %eax,%edx
  803d1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d22:	d3 e0                	shl    %cl,%eax
  803d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d28:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d2c:	89 f1                	mov    %esi,%ecx
  803d2e:	d3 e8                	shr    %cl,%eax
  803d30:	09 d0                	or     %edx,%eax
  803d32:	d3 eb                	shr    %cl,%ebx
  803d34:	89 da                	mov    %ebx,%edx
  803d36:	f7 f7                	div    %edi
  803d38:	89 d3                	mov    %edx,%ebx
  803d3a:	f7 24 24             	mull   (%esp)
  803d3d:	89 c6                	mov    %eax,%esi
  803d3f:	89 d1                	mov    %edx,%ecx
  803d41:	39 d3                	cmp    %edx,%ebx
  803d43:	0f 82 87 00 00 00    	jb     803dd0 <__umoddi3+0x134>
  803d49:	0f 84 91 00 00 00    	je     803de0 <__umoddi3+0x144>
  803d4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d53:	29 f2                	sub    %esi,%edx
  803d55:	19 cb                	sbb    %ecx,%ebx
  803d57:	89 d8                	mov    %ebx,%eax
  803d59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d5d:	d3 e0                	shl    %cl,%eax
  803d5f:	89 e9                	mov    %ebp,%ecx
  803d61:	d3 ea                	shr    %cl,%edx
  803d63:	09 d0                	or     %edx,%eax
  803d65:	89 e9                	mov    %ebp,%ecx
  803d67:	d3 eb                	shr    %cl,%ebx
  803d69:	89 da                	mov    %ebx,%edx
  803d6b:	83 c4 1c             	add    $0x1c,%esp
  803d6e:	5b                   	pop    %ebx
  803d6f:	5e                   	pop    %esi
  803d70:	5f                   	pop    %edi
  803d71:	5d                   	pop    %ebp
  803d72:	c3                   	ret    
  803d73:	90                   	nop
  803d74:	89 fd                	mov    %edi,%ebp
  803d76:	85 ff                	test   %edi,%edi
  803d78:	75 0b                	jne    803d85 <__umoddi3+0xe9>
  803d7a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d7f:	31 d2                	xor    %edx,%edx
  803d81:	f7 f7                	div    %edi
  803d83:	89 c5                	mov    %eax,%ebp
  803d85:	89 f0                	mov    %esi,%eax
  803d87:	31 d2                	xor    %edx,%edx
  803d89:	f7 f5                	div    %ebp
  803d8b:	89 c8                	mov    %ecx,%eax
  803d8d:	f7 f5                	div    %ebp
  803d8f:	89 d0                	mov    %edx,%eax
  803d91:	e9 44 ff ff ff       	jmp    803cda <__umoddi3+0x3e>
  803d96:	66 90                	xchg   %ax,%ax
  803d98:	89 c8                	mov    %ecx,%eax
  803d9a:	89 f2                	mov    %esi,%edx
  803d9c:	83 c4 1c             	add    $0x1c,%esp
  803d9f:	5b                   	pop    %ebx
  803da0:	5e                   	pop    %esi
  803da1:	5f                   	pop    %edi
  803da2:	5d                   	pop    %ebp
  803da3:	c3                   	ret    
  803da4:	3b 04 24             	cmp    (%esp),%eax
  803da7:	72 06                	jb     803daf <__umoddi3+0x113>
  803da9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803dad:	77 0f                	ja     803dbe <__umoddi3+0x122>
  803daf:	89 f2                	mov    %esi,%edx
  803db1:	29 f9                	sub    %edi,%ecx
  803db3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803db7:	89 14 24             	mov    %edx,(%esp)
  803dba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dbe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dc2:	8b 14 24             	mov    (%esp),%edx
  803dc5:	83 c4 1c             	add    $0x1c,%esp
  803dc8:	5b                   	pop    %ebx
  803dc9:	5e                   	pop    %esi
  803dca:	5f                   	pop    %edi
  803dcb:	5d                   	pop    %ebp
  803dcc:	c3                   	ret    
  803dcd:	8d 76 00             	lea    0x0(%esi),%esi
  803dd0:	2b 04 24             	sub    (%esp),%eax
  803dd3:	19 fa                	sbb    %edi,%edx
  803dd5:	89 d1                	mov    %edx,%ecx
  803dd7:	89 c6                	mov    %eax,%esi
  803dd9:	e9 71 ff ff ff       	jmp    803d4f <__umoddi3+0xb3>
  803dde:	66 90                	xchg   %ax,%ax
  803de0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803de4:	72 ea                	jb     803dd0 <__umoddi3+0x134>
  803de6:	89 d9                	mov    %ebx,%ecx
  803de8:	e9 62 ff ff ff       	jmp    803d4f <__umoddi3+0xb3>
