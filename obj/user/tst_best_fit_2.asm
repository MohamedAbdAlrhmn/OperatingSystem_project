
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
  800045:	e8 03 24 00 00       	call   80244d <sys_set_uheap_strategy>
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
  80009b:	68 60 3d 80 00       	push   $0x803d60
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 7c 3d 80 00       	push   $0x803d7c
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
  8000f5:	68 94 3d 80 00       	push   $0x803d94
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 7c 3d 80 00       	push   $0x803d7c
  800101:	e8 21 09 00 00       	call   800a27 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 2d 1e 00 00       	call   801f38 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 c5 1e 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  80013a:	68 d8 3d 80 00       	push   $0x803dd8
  80013f:	6a 31                	push   $0x31
  800141:	68 7c 3d 80 00       	push   $0x803d7c
  800146:	e8 dc 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80014b:	e8 88 1e 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  800150:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800153:	3d 00 02 00 00       	cmp    $0x200,%eax
  800158:	74 14                	je     80016e <_main+0x136>
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	68 08 3e 80 00       	push   $0x803e08
  800162:	6a 33                	push   $0x33
  800164:	68 7c 3d 80 00       	push   $0x803d7c
  800169:	e8 b9 08 00 00       	call   800a27 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80016e:	e8 c5 1d 00 00       	call   801f38 <sys_calculate_free_frames>
  800173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800176:	e8 5d 1e 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  8001ab:	68 d8 3d 80 00       	push   $0x803dd8
  8001b0:	6a 39                	push   $0x39
  8001b2:	68 7c 3d 80 00       	push   $0x803d7c
  8001b7:	e8 6b 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001bc:	e8 17 1e 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  8001c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 08 3e 80 00       	push   $0x803e08
  8001d3:	6a 3b                	push   $0x3b
  8001d5:	68 7c 3d 80 00       	push   $0x803d7c
  8001da:	e8 48 08 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 54 1d 00 00       	call   801f38 <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 ec 1d 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  80021a:	68 d8 3d 80 00       	push   $0x803dd8
  80021f:	6a 41                	push   $0x41
  800221:	68 7c 3d 80 00       	push   $0x803d7c
  800226:	e8 fc 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80022b:	e8 a8 1d 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  800230:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800233:	83 f8 01             	cmp    $0x1,%eax
  800236:	74 14                	je     80024c <_main+0x214>
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 08 3e 80 00       	push   $0x803e08
  800240:	6a 43                	push   $0x43
  800242:	68 7c 3d 80 00       	push   $0x803d7c
  800247:	e8 db 07 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80024c:	e8 e7 1c 00 00       	call   801f38 <sys_calculate_free_frames>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800254:	e8 7f 1d 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  800291:	68 d8 3d 80 00       	push   $0x803dd8
  800296:	6a 49                	push   $0x49
  800298:	68 7c 3d 80 00       	push   $0x803d7c
  80029d:	e8 85 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002a2:	e8 31 1d 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  8002a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002aa:	83 f8 01             	cmp    $0x1,%eax
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 08 3e 80 00       	push   $0x803e08
  8002b7:	6a 4b                	push   $0x4b
  8002b9:	68 7c 3d 80 00       	push   $0x803d7c
  8002be:	e8 64 07 00 00       	call   800a27 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002c3:	e8 70 1c 00 00       	call   801f38 <sys_calculate_free_frames>
  8002c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cb:	e8 08 1d 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  8002d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 ff 19 00 00       	call   801cde <free>
  8002df:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002e2:	e8 f1 1c 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  8002e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ea:	29 c2                	sub    %eax,%edx
  8002ec:	89 d0                	mov    %edx,%eax
  8002ee:	83 f8 01             	cmp    $0x1,%eax
  8002f1:	74 14                	je     800307 <_main+0x2cf>
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	68 25 3e 80 00       	push   $0x803e25
  8002fb:	6a 52                	push   $0x52
  8002fd:	68 7c 3d 80 00       	push   $0x803d7c
  800302:	e8 20 07 00 00       	call   800a27 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  800307:	e8 2c 1c 00 00       	call   801f38 <sys_calculate_free_frames>
  80030c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80030f:	e8 c4 1c 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  800354:	68 d8 3d 80 00       	push   $0x803dd8
  800359:	6a 58                	push   $0x58
  80035b:	68 7c 3d 80 00       	push   $0x803d7c
  800360:	e8 c2 06 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800365:	e8 6e 1c 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  80036a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80036d:	83 f8 02             	cmp    $0x2,%eax
  800370:	74 14                	je     800386 <_main+0x34e>
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 08 3e 80 00       	push   $0x803e08
  80037a:	6a 5a                	push   $0x5a
  80037c:	68 7c 3d 80 00       	push   $0x803d7c
  800381:	e8 a1 06 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800386:	e8 ad 1b 00 00       	call   801f38 <sys_calculate_free_frames>
  80038b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80038e:	e8 45 1c 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  800393:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800396:	8b 45 90             	mov    -0x70(%ebp),%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	50                   	push   %eax
  80039d:	e8 3c 19 00 00       	call   801cde <free>
  8003a2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003a5:	e8 2e 1c 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	29 c2                	sub    %eax,%edx
  8003af:	89 d0                	mov    %edx,%eax
  8003b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003b6:	74 14                	je     8003cc <_main+0x394>
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	68 25 3e 80 00       	push   $0x803e25
  8003c0:	6a 61                	push   $0x61
  8003c2:	68 7c 3d 80 00       	push   $0x803d7c
  8003c7:	e8 5b 06 00 00       	call   800a27 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cc:	e8 67 1b 00 00       	call   801f38 <sys_calculate_free_frames>
  8003d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d4:	e8 ff 1b 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  800418:	68 d8 3d 80 00       	push   $0x803dd8
  80041d:	6a 67                	push   $0x67
  80041f:	68 7c 3d 80 00       	push   $0x803d7c
  800424:	e8 fe 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800429:	e8 aa 1b 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  80044f:	68 08 3e 80 00       	push   $0x803e08
  800454:	6a 69                	push   $0x69
  800456:	68 7c 3d 80 00       	push   $0x803d7c
  80045b:	e8 c7 05 00 00       	call   800a27 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800460:	e8 d3 1a 00 00       	call   801f38 <sys_calculate_free_frames>
  800465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800468:	e8 6b 1b 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  8004b7:	68 d8 3d 80 00       	push   $0x803dd8
  8004bc:	6a 6f                	push   $0x6f
  8004be:	68 7c 3d 80 00       	push   $0x803d7c
  8004c3:	e8 5f 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004c8:	e8 0b 1b 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  8004cd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004d0:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004d5:	74 14                	je     8004eb <_main+0x4b3>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 08 3e 80 00       	push   $0x803e08
  8004df:	6a 71                	push   $0x71
  8004e1:	68 7c 3d 80 00       	push   $0x803d7c
  8004e6:	e8 3c 05 00 00       	call   800a27 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004eb:	e8 48 1a 00 00       	call   801f38 <sys_calculate_free_frames>
  8004f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f3:	e8 e0 1a 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  800542:	68 d8 3d 80 00       	push   $0x803dd8
  800547:	6a 77                	push   $0x77
  800549:	68 7c 3d 80 00       	push   $0x803d7c
  80054e:	e8 d4 04 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  800553:	e8 80 1a 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  80057a:	68 08 3e 80 00       	push   $0x803e08
  80057f:	6a 79                	push   $0x79
  800581:	68 7c 3d 80 00       	push   $0x803d7c
  800586:	e8 9c 04 00 00       	call   800a27 <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80058b:	e8 a8 19 00 00       	call   801f38 <sys_calculate_free_frames>
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800593:	e8 40 1a 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80059b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 37 17 00 00       	call   801cde <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  8005aa:	e8 29 1a 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	29 c2                	sub    %eax,%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	3d 02 02 00 00       	cmp    $0x202,%eax
  8005bb:	74 17                	je     8005d4 <_main+0x59c>
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 25 3e 80 00       	push   $0x803e25
  8005c5:	68 80 00 00 00       	push   $0x80
  8005ca:	68 7c 3d 80 00       	push   $0x803d7c
  8005cf:	e8 53 04 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d4:	e8 5f 19 00 00       	call   801f38 <sys_calculate_free_frames>
  8005d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005dc:	e8 f7 19 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005e4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	50                   	push   %eax
  8005eb:	e8 ee 16 00 00       	call   801cde <free>
  8005f0:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8005f3:	e8 e0 19 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  8005f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fb:	29 c2                	sub    %eax,%edx
  8005fd:	89 d0                	mov    %edx,%eax
  8005ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  800604:	74 17                	je     80061d <_main+0x5e5>
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	68 25 3e 80 00       	push   $0x803e25
  80060e:	68 87 00 00 00       	push   $0x87
  800613:	68 7c 3d 80 00       	push   $0x803d7c
  800618:	e8 0a 04 00 00       	call   800a27 <_panic>

		//2 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  80061d:	e8 16 19 00 00       	call   801f38 <sys_calculate_free_frames>
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800625:	e8 ae 19 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  80066c:	68 d8 3d 80 00       	push   $0x803dd8
  800671:	68 8d 00 00 00       	push   $0x8d
  800676:	68 7c 3d 80 00       	push   $0x803d7c
  80067b:	e8 a7 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800680:	e8 53 19 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  800685:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800688:	3d 00 02 00 00       	cmp    $0x200,%eax
  80068d:	74 17                	je     8006a6 <_main+0x66e>
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 08 3e 80 00       	push   $0x803e08
  800697:	68 8f 00 00 00       	push   $0x8f
  80069c:	68 7c 3d 80 00       	push   $0x803d7c
  8006a1:	e8 81 03 00 00       	call   800a27 <_panic>

		//6 KB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  8006a6:	e8 8d 18 00 00       	call   801f38 <sys_calculate_free_frames>
  8006ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ae:	e8 25 19 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  8006f5:	68 d8 3d 80 00       	push   $0x803dd8
  8006fa:	68 95 00 00 00       	push   $0x95
  8006ff:	68 7c 3d 80 00       	push   $0x803d7c
  800704:	e8 1e 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800709:	e8 ca 18 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  80070e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800711:	83 f8 02             	cmp    $0x2,%eax
  800714:	74 17                	je     80072d <_main+0x6f5>
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	68 08 3e 80 00       	push   $0x803e08
  80071e:	68 97 00 00 00       	push   $0x97
  800723:	68 7c 3d 80 00       	push   $0x803d7c
  800728:	e8 fa 02 00 00       	call   800a27 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80072d:	e8 06 18 00 00       	call   801f38 <sys_calculate_free_frames>
  800732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800735:	e8 9e 18 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  80073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80073d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 95 15 00 00       	call   801cde <free>
  800749:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  80074c:	e8 87 18 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
  800751:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800754:	29 c2                	sub    %eax,%edx
  800756:	89 d0                	mov    %edx,%eax
  800758:	3d 00 03 00 00       	cmp    $0x300,%eax
  80075d:	74 17                	je     800776 <_main+0x73e>
  80075f:	83 ec 04             	sub    $0x4,%esp
  800762:	68 25 3e 80 00       	push   $0x803e25
  800767:	68 9e 00 00 00       	push   $0x9e
  80076c:	68 7c 3d 80 00       	push   $0x803d7c
  800771:	e8 b1 02 00 00       	call   800a27 <_panic>

		//3 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800776:	e8 bd 17 00 00       	call   801f38 <sys_calculate_free_frames>
  80077b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80077e:	e8 55 18 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  8007c2:	68 d8 3d 80 00       	push   $0x803dd8
  8007c7:	68 a4 00 00 00       	push   $0xa4
  8007cc:	68 7c 3d 80 00       	push   $0x803d7c
  8007d1:	e8 51 02 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8007d6:	e8 fd 17 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  8007fc:	68 08 3e 80 00       	push   $0x803e08
  800801:	68 a6 00 00 00       	push   $0xa6
  800806:	68 7c 3d 80 00       	push   $0x803d7c
  80080b:	e8 17 02 00 00       	call   800a27 <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800810:	e8 23 17 00 00       	call   801f38 <sys_calculate_free_frames>
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800818:	e8 bb 17 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  800845:	68 d8 3d 80 00       	push   $0x803dd8
  80084a:	68 ac 00 00 00       	push   $0xac
  80084f:	68 7c 3d 80 00       	push   $0x803d7c
  800854:	e8 ce 01 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800859:	e8 7a 17 00 00       	call   801fd8 <sys_pf_calculate_allocated_pages>
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
  80087c:	68 08 3e 80 00       	push   $0x803e08
  800881:	68 ae 00 00 00       	push   $0xae
  800886:	68 7c 3d 80 00       	push   $0x803d7c
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
  8008bf:	68 3c 3e 80 00       	push   $0x803e3c
  8008c4:	68 b7 00 00 00       	push   $0xb7
  8008c9:	68 7c 3d 80 00       	push   $0x803d7c
  8008ce:	e8 54 01 00 00       	call   800a27 <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 a0 3e 80 00       	push   $0x803ea0
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
  8008f1:	e8 22 19 00 00       	call   802218 <sys_getenvindex>
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
  80095c:	e8 c4 16 00 00       	call   802025 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 00 3f 80 00       	push   $0x803f00
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
  80098c:	68 28 3f 80 00       	push   $0x803f28
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
  8009bd:	68 50 3f 80 00       	push   $0x803f50
  8009c2:	e8 14 03 00 00       	call   800cdb <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8009cf:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	50                   	push   %eax
  8009d9:	68 a8 3f 80 00       	push   $0x803fa8
  8009de:	e8 f8 02 00 00       	call   800cdb <cprintf>
  8009e3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009e6:	83 ec 0c             	sub    $0xc,%esp
  8009e9:	68 00 3f 80 00       	push   $0x803f00
  8009ee:	e8 e8 02 00 00       	call   800cdb <cprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009f6:	e8 44 16 00 00       	call   80203f <sys_enable_interrupt>

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
  800a0e:	e8 d1 17 00 00       	call   8021e4 <sys_destroy_env>
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
  800a1f:	e8 26 18 00 00       	call   80224a <sys_exit_env>
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
  800a48:	68 bc 3f 80 00       	push   $0x803fbc
  800a4d:	e8 89 02 00 00       	call   800cdb <cprintf>
  800a52:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a55:	a1 00 50 80 00       	mov    0x805000,%eax
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 08             	pushl  0x8(%ebp)
  800a60:	50                   	push   %eax
  800a61:	68 c1 3f 80 00       	push   $0x803fc1
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
  800a85:	68 dd 3f 80 00       	push   $0x803fdd
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
  800ab1:	68 e0 3f 80 00       	push   $0x803fe0
  800ab6:	6a 26                	push   $0x26
  800ab8:	68 2c 40 80 00       	push   $0x80402c
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
  800b83:	68 38 40 80 00       	push   $0x804038
  800b88:	6a 3a                	push   $0x3a
  800b8a:	68 2c 40 80 00       	push   $0x80402c
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
  800bf3:	68 8c 40 80 00       	push   $0x80408c
  800bf8:	6a 44                	push   $0x44
  800bfa:	68 2c 40 80 00       	push   $0x80402c
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
  800c4d:	e8 25 12 00 00       	call   801e77 <sys_cputs>
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
  800cc4:	e8 ae 11 00 00       	call   801e77 <sys_cputs>
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
  800d0e:	e8 12 13 00 00       	call   802025 <sys_disable_interrupt>
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
  800d2e:	e8 0c 13 00 00       	call   80203f <sys_enable_interrupt>
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
  800d78:	e8 7f 2d 00 00       	call   803afc <__udivdi3>
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
  800dc8:	e8 3f 2e 00 00       	call   803c0c <__umoddi3>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	05 f4 42 80 00       	add    $0x8042f4,%eax
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
  800f23:	8b 04 85 18 43 80 00 	mov    0x804318(,%eax,4),%eax
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
  801004:	8b 34 9d 60 41 80 00 	mov    0x804160(,%ebx,4),%esi
  80100b:	85 f6                	test   %esi,%esi
  80100d:	75 19                	jne    801028 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80100f:	53                   	push   %ebx
  801010:	68 05 43 80 00       	push   $0x804305
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
  801029:	68 0e 43 80 00       	push   $0x80430e
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
  801056:	be 11 43 80 00       	mov    $0x804311,%esi
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
  801a7c:	68 70 44 80 00       	push   $0x804470
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
  801b4c:	e8 6a 04 00 00       	call   801fbb <sys_allocate_chunk>
  801b51:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801b54:	a1 20 51 80 00       	mov    0x805120,%eax
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	50                   	push   %eax
  801b5d:	e8 df 0a 00 00       	call   802641 <initialize_MemBlocksList>
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
  801b8a:	68 95 44 80 00       	push   $0x804495
  801b8f:	6a 33                	push   $0x33
  801b91:	68 b3 44 80 00       	push   $0x8044b3
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
  801c09:	68 c0 44 80 00       	push   $0x8044c0
  801c0e:	6a 34                	push   $0x34
  801c10:	68 b3 44 80 00       	push   $0x8044b3
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
  801ca1:	e8 e3 06 00 00       	call   802389 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	74 11                	je     801cbb <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801caa:	83 ec 0c             	sub    $0xc,%esp
  801cad:	ff 75 e8             	pushl  -0x18(%ebp)
  801cb0:	e8 4e 0d 00 00       	call   802a03 <alloc_block_FF>
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
  801cc7:	e8 aa 0a 00 00       	call   802776 <insert_sorted_allocList>
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
  801ce7:	68 e4 44 80 00       	push   $0x8044e4
  801cec:	6a 6f                	push   $0x6f
  801cee:	68 b3 44 80 00       	push   $0x8044b3
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
  801d0d:	75 07                	jne    801d16 <smalloc+0x1e>
  801d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d14:	eb 7c                	jmp    801d92 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801d16:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d23:	01 d0                	add    %edx,%eax
  801d25:	48                   	dec    %eax
  801d26:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d31:	f7 75 f0             	divl   -0x10(%ebp)
  801d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d37:	29 d0                	sub    %edx,%eax
  801d39:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801d3c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801d43:	e8 41 06 00 00       	call   802389 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	74 11                	je     801d5d <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801d4c:	83 ec 0c             	sub    $0xc,%esp
  801d4f:	ff 75 e8             	pushl  -0x18(%ebp)
  801d52:	e8 ac 0c 00 00       	call   802a03 <alloc_block_FF>
  801d57:	83 c4 10             	add    $0x10,%esp
  801d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801d5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d61:	74 2a                	je     801d8d <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d66:	8b 40 08             	mov    0x8(%eax),%eax
  801d69:	89 c2                	mov    %eax,%edx
  801d6b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d6f:	52                   	push   %edx
  801d70:	50                   	push   %eax
  801d71:	ff 75 0c             	pushl  0xc(%ebp)
  801d74:	ff 75 08             	pushl  0x8(%ebp)
  801d77:	e8 92 03 00 00       	call   80210e <sys_createSharedObject>
  801d7c:	83 c4 10             	add    $0x10,%esp
  801d7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801d82:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801d86:	74 05                	je     801d8d <smalloc+0x95>
			return (void*)virtual_address;
  801d88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d8b:	eb 05                	jmp    801d92 <smalloc+0x9a>
	}
	return NULL;
  801d8d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d9a:	e8 c6 fc ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801d9f:	83 ec 04             	sub    $0x4,%esp
  801da2:	68 08 45 80 00       	push   $0x804508
  801da7:	68 b0 00 00 00       	push   $0xb0
  801dac:	68 b3 44 80 00       	push   $0x8044b3
  801db1:	e8 71 ec ff ff       	call   800a27 <_panic>

00801db6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dbc:	e8 a4 fc ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801dc1:	83 ec 04             	sub    $0x4,%esp
  801dc4:	68 2c 45 80 00       	push   $0x80452c
  801dc9:	68 f4 00 00 00       	push   $0xf4
  801dce:	68 b3 44 80 00       	push   $0x8044b3
  801dd3:	e8 4f ec ff ff       	call   800a27 <_panic>

00801dd8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801dde:	83 ec 04             	sub    $0x4,%esp
  801de1:	68 54 45 80 00       	push   $0x804554
  801de6:	68 08 01 00 00       	push   $0x108
  801deb:	68 b3 44 80 00       	push   $0x8044b3
  801df0:	e8 32 ec ff ff       	call   800a27 <_panic>

00801df5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dfb:	83 ec 04             	sub    $0x4,%esp
  801dfe:	68 78 45 80 00       	push   $0x804578
  801e03:	68 13 01 00 00       	push   $0x113
  801e08:	68 b3 44 80 00       	push   $0x8044b3
  801e0d:	e8 15 ec ff ff       	call   800a27 <_panic>

00801e12 <shrink>:

}
void shrink(uint32 newSize)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e18:	83 ec 04             	sub    $0x4,%esp
  801e1b:	68 78 45 80 00       	push   $0x804578
  801e20:	68 18 01 00 00       	push   $0x118
  801e25:	68 b3 44 80 00       	push   $0x8044b3
  801e2a:	e8 f8 eb ff ff       	call   800a27 <_panic>

00801e2f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e35:	83 ec 04             	sub    $0x4,%esp
  801e38:	68 78 45 80 00       	push   $0x804578
  801e3d:	68 1d 01 00 00       	push   $0x11d
  801e42:	68 b3 44 80 00       	push   $0x8044b3
  801e47:	e8 db eb ff ff       	call   800a27 <_panic>

00801e4c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	57                   	push   %edi
  801e50:	56                   	push   %esi
  801e51:	53                   	push   %ebx
  801e52:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e61:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e64:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e67:	cd 30                	int    $0x30
  801e69:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e6f:	83 c4 10             	add    $0x10,%esp
  801e72:	5b                   	pop    %ebx
  801e73:	5e                   	pop    %esi
  801e74:	5f                   	pop    %edi
  801e75:	5d                   	pop    %ebp
  801e76:	c3                   	ret    

00801e77 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	83 ec 04             	sub    $0x4,%esp
  801e7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e80:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e83:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	52                   	push   %edx
  801e8f:	ff 75 0c             	pushl  0xc(%ebp)
  801e92:	50                   	push   %eax
  801e93:	6a 00                	push   $0x0
  801e95:	e8 b2 ff ff ff       	call   801e4c <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
}
  801e9d:	90                   	nop
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 01                	push   $0x1
  801eaf:	e8 98 ff ff ff       	call   801e4c <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	52                   	push   %edx
  801ec9:	50                   	push   %eax
  801eca:	6a 05                	push   $0x5
  801ecc:	e8 7b ff ff ff       	call   801e4c <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	56                   	push   %esi
  801eda:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801edb:	8b 75 18             	mov    0x18(%ebp),%esi
  801ede:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	56                   	push   %esi
  801eeb:	53                   	push   %ebx
  801eec:	51                   	push   %ecx
  801eed:	52                   	push   %edx
  801eee:	50                   	push   %eax
  801eef:	6a 06                	push   $0x6
  801ef1:	e8 56 ff ff ff       	call   801e4c <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
}
  801ef9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efc:	5b                   	pop    %ebx
  801efd:	5e                   	pop    %esi
  801efe:	5d                   	pop    %ebp
  801eff:	c3                   	ret    

00801f00 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	52                   	push   %edx
  801f10:	50                   	push   %eax
  801f11:	6a 07                	push   $0x7
  801f13:	e8 34 ff ff ff       	call   801e4c <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	ff 75 0c             	pushl  0xc(%ebp)
  801f29:	ff 75 08             	pushl  0x8(%ebp)
  801f2c:	6a 08                	push   $0x8
  801f2e:	e8 19 ff ff ff       	call   801e4c <syscall>
  801f33:	83 c4 18             	add    $0x18,%esp
}
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 09                	push   $0x9
  801f47:	e8 00 ff ff ff       	call   801e4c <syscall>
  801f4c:	83 c4 18             	add    $0x18,%esp
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 0a                	push   $0xa
  801f60:	e8 e7 fe ff ff       	call   801e4c <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 0b                	push   $0xb
  801f79:	e8 ce fe ff ff       	call   801e4c <syscall>
  801f7e:	83 c4 18             	add    $0x18,%esp
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	ff 75 0c             	pushl  0xc(%ebp)
  801f8f:	ff 75 08             	pushl  0x8(%ebp)
  801f92:	6a 0f                	push   $0xf
  801f94:	e8 b3 fe ff ff       	call   801e4c <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
	return;
  801f9c:	90                   	nop
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	ff 75 0c             	pushl  0xc(%ebp)
  801fab:	ff 75 08             	pushl  0x8(%ebp)
  801fae:	6a 10                	push   $0x10
  801fb0:	e8 97 fe ff ff       	call   801e4c <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb8:	90                   	nop
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	ff 75 10             	pushl  0x10(%ebp)
  801fc5:	ff 75 0c             	pushl  0xc(%ebp)
  801fc8:	ff 75 08             	pushl  0x8(%ebp)
  801fcb:	6a 11                	push   $0x11
  801fcd:	e8 7a fe ff ff       	call   801e4c <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd5:	90                   	nop
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 0c                	push   $0xc
  801fe7:	e8 60 fe ff ff       	call   801e4c <syscall>
  801fec:	83 c4 18             	add    $0x18,%esp
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	ff 75 08             	pushl  0x8(%ebp)
  801fff:	6a 0d                	push   $0xd
  802001:	e8 46 fe ff ff       	call   801e4c <syscall>
  802006:	83 c4 18             	add    $0x18,%esp
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 0e                	push   $0xe
  80201a:	e8 2d fe ff ff       	call   801e4c <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
}
  802022:	90                   	nop
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 13                	push   $0x13
  802034:	e8 13 fe ff ff       	call   801e4c <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
}
  80203c:	90                   	nop
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 14                	push   $0x14
  80204e:	e8 f9 fd ff ff       	call   801e4c <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
}
  802056:	90                   	nop
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_cputc>:


void
sys_cputc(const char c)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802065:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	50                   	push   %eax
  802072:	6a 15                	push   $0x15
  802074:	e8 d3 fd ff ff       	call   801e4c <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
}
  80207c:	90                   	nop
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 16                	push   $0x16
  80208e:	e8 b9 fd ff ff       	call   801e4c <syscall>
  802093:	83 c4 18             	add    $0x18,%esp
}
  802096:	90                   	nop
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	ff 75 0c             	pushl  0xc(%ebp)
  8020a8:	50                   	push   %eax
  8020a9:	6a 17                	push   $0x17
  8020ab:	e8 9c fd ff ff       	call   801e4c <syscall>
  8020b0:	83 c4 18             	add    $0x18,%esp
}
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	52                   	push   %edx
  8020c5:	50                   	push   %eax
  8020c6:	6a 1a                	push   $0x1a
  8020c8:	e8 7f fd ff ff       	call   801e4c <syscall>
  8020cd:	83 c4 18             	add    $0x18,%esp
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	52                   	push   %edx
  8020e2:	50                   	push   %eax
  8020e3:	6a 18                	push   $0x18
  8020e5:	e8 62 fd ff ff       	call   801e4c <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
}
  8020ed:	90                   	nop
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	52                   	push   %edx
  802100:	50                   	push   %eax
  802101:	6a 19                	push   $0x19
  802103:	e8 44 fd ff ff       	call   801e4c <syscall>
  802108:	83 c4 18             	add    $0x18,%esp
}
  80210b:	90                   	nop
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 04             	sub    $0x4,%esp
  802114:	8b 45 10             	mov    0x10(%ebp),%eax
  802117:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80211a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80211d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	6a 00                	push   $0x0
  802126:	51                   	push   %ecx
  802127:	52                   	push   %edx
  802128:	ff 75 0c             	pushl  0xc(%ebp)
  80212b:	50                   	push   %eax
  80212c:	6a 1b                	push   $0x1b
  80212e:	e8 19 fd ff ff       	call   801e4c <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80213b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	52                   	push   %edx
  802148:	50                   	push   %eax
  802149:	6a 1c                	push   $0x1c
  80214b:	e8 fc fc ff ff       	call   801e4c <syscall>
  802150:	83 c4 18             	add    $0x18,%esp
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802158:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80215b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	51                   	push   %ecx
  802166:	52                   	push   %edx
  802167:	50                   	push   %eax
  802168:	6a 1d                	push   $0x1d
  80216a:	e8 dd fc ff ff       	call   801e4c <syscall>
  80216f:	83 c4 18             	add    $0x18,%esp
}
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802177:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	52                   	push   %edx
  802184:	50                   	push   %eax
  802185:	6a 1e                	push   $0x1e
  802187:	e8 c0 fc ff ff       	call   801e4c <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
}
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 1f                	push   $0x1f
  8021a0:	e8 a7 fc ff ff       	call   801e4c <syscall>
  8021a5:	83 c4 18             	add    $0x18,%esp
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	6a 00                	push   $0x0
  8021b2:	ff 75 14             	pushl  0x14(%ebp)
  8021b5:	ff 75 10             	pushl  0x10(%ebp)
  8021b8:	ff 75 0c             	pushl  0xc(%ebp)
  8021bb:	50                   	push   %eax
  8021bc:	6a 20                	push   $0x20
  8021be:	e8 89 fc ff ff       	call   801e4c <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	50                   	push   %eax
  8021d7:	6a 21                	push   $0x21
  8021d9:	e8 6e fc ff ff       	call   801e4c <syscall>
  8021de:	83 c4 18             	add    $0x18,%esp
}
  8021e1:	90                   	nop
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	50                   	push   %eax
  8021f3:	6a 22                	push   $0x22
  8021f5:	e8 52 fc ff ff       	call   801e4c <syscall>
  8021fa:	83 c4 18             	add    $0x18,%esp
}
  8021fd:	c9                   	leave  
  8021fe:	c3                   	ret    

008021ff <sys_getenvid>:

int32 sys_getenvid(void)
{
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 02                	push   $0x2
  80220e:	e8 39 fc ff ff       	call   801e4c <syscall>
  802213:	83 c4 18             	add    $0x18,%esp
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 03                	push   $0x3
  802227:	e8 20 fc ff ff       	call   801e4c <syscall>
  80222c:	83 c4 18             	add    $0x18,%esp
}
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 04                	push   $0x4
  802240:	e8 07 fc ff ff       	call   801e4c <syscall>
  802245:	83 c4 18             	add    $0x18,%esp
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <sys_exit_env>:


void sys_exit_env(void)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 23                	push   $0x23
  802259:	e8 ee fb ff ff       	call   801e4c <syscall>
  80225e:	83 c4 18             	add    $0x18,%esp
}
  802261:	90                   	nop
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
  802267:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80226a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80226d:	8d 50 04             	lea    0x4(%eax),%edx
  802270:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	52                   	push   %edx
  80227a:	50                   	push   %eax
  80227b:	6a 24                	push   $0x24
  80227d:	e8 ca fb ff ff       	call   801e4c <syscall>
  802282:	83 c4 18             	add    $0x18,%esp
	return result;
  802285:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802288:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80228b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80228e:	89 01                	mov    %eax,(%ecx)
  802290:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	c9                   	leave  
  802297:	c2 04 00             	ret    $0x4

0080229a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	ff 75 10             	pushl  0x10(%ebp)
  8022a4:	ff 75 0c             	pushl  0xc(%ebp)
  8022a7:	ff 75 08             	pushl  0x8(%ebp)
  8022aa:	6a 12                	push   $0x12
  8022ac:	e8 9b fb ff ff       	call   801e4c <syscall>
  8022b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b4:	90                   	nop
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 25                	push   $0x25
  8022c6:	e8 81 fb ff ff       	call   801e4c <syscall>
  8022cb:	83 c4 18             	add    $0x18,%esp
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	83 ec 04             	sub    $0x4,%esp
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022dc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	50                   	push   %eax
  8022e9:	6a 26                	push   $0x26
  8022eb:	e8 5c fb ff ff       	call   801e4c <syscall>
  8022f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f3:	90                   	nop
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <rsttst>:
void rsttst()
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 28                	push   $0x28
  802305:	e8 42 fb ff ff       	call   801e4c <syscall>
  80230a:	83 c4 18             	add    $0x18,%esp
	return ;
  80230d:	90                   	nop
}
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	83 ec 04             	sub    $0x4,%esp
  802316:	8b 45 14             	mov    0x14(%ebp),%eax
  802319:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80231c:	8b 55 18             	mov    0x18(%ebp),%edx
  80231f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802323:	52                   	push   %edx
  802324:	50                   	push   %eax
  802325:	ff 75 10             	pushl  0x10(%ebp)
  802328:	ff 75 0c             	pushl  0xc(%ebp)
  80232b:	ff 75 08             	pushl  0x8(%ebp)
  80232e:	6a 27                	push   $0x27
  802330:	e8 17 fb ff ff       	call   801e4c <syscall>
  802335:	83 c4 18             	add    $0x18,%esp
	return ;
  802338:	90                   	nop
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <chktst>:
void chktst(uint32 n)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	ff 75 08             	pushl  0x8(%ebp)
  802349:	6a 29                	push   $0x29
  80234b:	e8 fc fa ff ff       	call   801e4c <syscall>
  802350:	83 c4 18             	add    $0x18,%esp
	return ;
  802353:	90                   	nop
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <inctst>:

void inctst()
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 2a                	push   $0x2a
  802365:	e8 e2 fa ff ff       	call   801e4c <syscall>
  80236a:	83 c4 18             	add    $0x18,%esp
	return ;
  80236d:	90                   	nop
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <gettst>:
uint32 gettst()
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 2b                	push   $0x2b
  80237f:	e8 c8 fa ff ff       	call   801e4c <syscall>
  802384:	83 c4 18             	add    $0x18,%esp
}
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
  80238c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 2c                	push   $0x2c
  80239b:	e8 ac fa ff ff       	call   801e4c <syscall>
  8023a0:	83 c4 18             	add    $0x18,%esp
  8023a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023a6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023aa:	75 07                	jne    8023b3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b1:	eb 05                	jmp    8023b8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
  8023bd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 2c                	push   $0x2c
  8023cc:	e8 7b fa ff ff       	call   801e4c <syscall>
  8023d1:	83 c4 18             	add    $0x18,%esp
  8023d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023d7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023db:	75 07                	jne    8023e4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e2:	eb 05                	jmp    8023e9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023e9:	c9                   	leave  
  8023ea:	c3                   	ret    

008023eb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 2c                	push   $0x2c
  8023fd:	e8 4a fa ff ff       	call   801e4c <syscall>
  802402:	83 c4 18             	add    $0x18,%esp
  802405:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802408:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80240c:	75 07                	jne    802415 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80240e:	b8 01 00 00 00       	mov    $0x1,%eax
  802413:	eb 05                	jmp    80241a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802415:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    

0080241c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
  80241f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 2c                	push   $0x2c
  80242e:	e8 19 fa ff ff       	call   801e4c <syscall>
  802433:	83 c4 18             	add    $0x18,%esp
  802436:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802439:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80243d:	75 07                	jne    802446 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80243f:	b8 01 00 00 00       	mov    $0x1,%eax
  802444:	eb 05                	jmp    80244b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802446:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    

0080244d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	ff 75 08             	pushl  0x8(%ebp)
  80245b:	6a 2d                	push   $0x2d
  80245d:	e8 ea f9 ff ff       	call   801e4c <syscall>
  802462:	83 c4 18             	add    $0x18,%esp
	return ;
  802465:	90                   	nop
}
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
  80246b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80246c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80246f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802472:	8b 55 0c             	mov    0xc(%ebp),%edx
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	6a 00                	push   $0x0
  80247a:	53                   	push   %ebx
  80247b:	51                   	push   %ecx
  80247c:	52                   	push   %edx
  80247d:	50                   	push   %eax
  80247e:	6a 2e                	push   $0x2e
  802480:	e8 c7 f9 ff ff       	call   801e4c <syscall>
  802485:	83 c4 18             	add    $0x18,%esp
}
  802488:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802490:	8b 55 0c             	mov    0xc(%ebp),%edx
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	52                   	push   %edx
  80249d:	50                   	push   %eax
  80249e:	6a 2f                	push   $0x2f
  8024a0:	e8 a7 f9 ff ff       	call   801e4c <syscall>
  8024a5:	83 c4 18             	add    $0x18,%esp
}
  8024a8:	c9                   	leave  
  8024a9:	c3                   	ret    

008024aa <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024b0:	83 ec 0c             	sub    $0xc,%esp
  8024b3:	68 88 45 80 00       	push   $0x804588
  8024b8:	e8 1e e8 ff ff       	call   800cdb <cprintf>
  8024bd:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024c7:	83 ec 0c             	sub    $0xc,%esp
  8024ca:	68 b4 45 80 00       	push   $0x8045b4
  8024cf:	e8 07 e8 ff ff       	call   800cdb <cprintf>
  8024d4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024d7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024db:	a1 38 51 80 00       	mov    0x805138,%eax
  8024e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e3:	eb 56                	jmp    80253b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024e9:	74 1c                	je     802507 <print_mem_block_lists+0x5d>
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 50 08             	mov    0x8(%eax),%edx
  8024f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f4:	8b 48 08             	mov    0x8(%eax),%ecx
  8024f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fd:	01 c8                	add    %ecx,%eax
  8024ff:	39 c2                	cmp    %eax,%edx
  802501:	73 04                	jae    802507 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802503:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 50 08             	mov    0x8(%eax),%edx
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	8b 40 0c             	mov    0xc(%eax),%eax
  802513:	01 c2                	add    %eax,%edx
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 40 08             	mov    0x8(%eax),%eax
  80251b:	83 ec 04             	sub    $0x4,%esp
  80251e:	52                   	push   %edx
  80251f:	50                   	push   %eax
  802520:	68 c9 45 80 00       	push   $0x8045c9
  802525:	e8 b1 e7 ff ff       	call   800cdb <cprintf>
  80252a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802533:	a1 40 51 80 00       	mov    0x805140,%eax
  802538:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253f:	74 07                	je     802548 <print_mem_block_lists+0x9e>
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 00                	mov    (%eax),%eax
  802546:	eb 05                	jmp    80254d <print_mem_block_lists+0xa3>
  802548:	b8 00 00 00 00       	mov    $0x0,%eax
  80254d:	a3 40 51 80 00       	mov    %eax,0x805140
  802552:	a1 40 51 80 00       	mov    0x805140,%eax
  802557:	85 c0                	test   %eax,%eax
  802559:	75 8a                	jne    8024e5 <print_mem_block_lists+0x3b>
  80255b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255f:	75 84                	jne    8024e5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802561:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802565:	75 10                	jne    802577 <print_mem_block_lists+0xcd>
  802567:	83 ec 0c             	sub    $0xc,%esp
  80256a:	68 d8 45 80 00       	push   $0x8045d8
  80256f:	e8 67 e7 ff ff       	call   800cdb <cprintf>
  802574:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802577:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80257e:	83 ec 0c             	sub    $0xc,%esp
  802581:	68 fc 45 80 00       	push   $0x8045fc
  802586:	e8 50 e7 ff ff       	call   800cdb <cprintf>
  80258b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80258e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802592:	a1 40 50 80 00       	mov    0x805040,%eax
  802597:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259a:	eb 56                	jmp    8025f2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80259c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025a0:	74 1c                	je     8025be <print_mem_block_lists+0x114>
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	8b 50 08             	mov    0x8(%eax),%edx
  8025a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ab:	8b 48 08             	mov    0x8(%eax),%ecx
  8025ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b4:	01 c8                	add    %ecx,%eax
  8025b6:	39 c2                	cmp    %eax,%edx
  8025b8:	73 04                	jae    8025be <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025ba:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	8b 50 08             	mov    0x8(%eax),%edx
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ca:	01 c2                	add    %eax,%edx
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 40 08             	mov    0x8(%eax),%eax
  8025d2:	83 ec 04             	sub    $0x4,%esp
  8025d5:	52                   	push   %edx
  8025d6:	50                   	push   %eax
  8025d7:	68 c9 45 80 00       	push   $0x8045c9
  8025dc:	e8 fa e6 ff ff       	call   800cdb <cprintf>
  8025e1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025ea:	a1 48 50 80 00       	mov    0x805048,%eax
  8025ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f6:	74 07                	je     8025ff <print_mem_block_lists+0x155>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 00                	mov    (%eax),%eax
  8025fd:	eb 05                	jmp    802604 <print_mem_block_lists+0x15a>
  8025ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802604:	a3 48 50 80 00       	mov    %eax,0x805048
  802609:	a1 48 50 80 00       	mov    0x805048,%eax
  80260e:	85 c0                	test   %eax,%eax
  802610:	75 8a                	jne    80259c <print_mem_block_lists+0xf2>
  802612:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802616:	75 84                	jne    80259c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802618:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80261c:	75 10                	jne    80262e <print_mem_block_lists+0x184>
  80261e:	83 ec 0c             	sub    $0xc,%esp
  802621:	68 14 46 80 00       	push   $0x804614
  802626:	e8 b0 e6 ff ff       	call   800cdb <cprintf>
  80262b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80262e:	83 ec 0c             	sub    $0xc,%esp
  802631:	68 88 45 80 00       	push   $0x804588
  802636:	e8 a0 e6 ff ff       	call   800cdb <cprintf>
  80263b:	83 c4 10             	add    $0x10,%esp

}
  80263e:	90                   	nop
  80263f:	c9                   	leave  
  802640:	c3                   	ret    

00802641 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802641:	55                   	push   %ebp
  802642:	89 e5                	mov    %esp,%ebp
  802644:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802647:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80264e:	00 00 00 
  802651:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802658:	00 00 00 
  80265b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802662:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802665:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80266c:	e9 9e 00 00 00       	jmp    80270f <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802671:	a1 50 50 80 00       	mov    0x805050,%eax
  802676:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802679:	c1 e2 04             	shl    $0x4,%edx
  80267c:	01 d0                	add    %edx,%eax
  80267e:	85 c0                	test   %eax,%eax
  802680:	75 14                	jne    802696 <initialize_MemBlocksList+0x55>
  802682:	83 ec 04             	sub    $0x4,%esp
  802685:	68 3c 46 80 00       	push   $0x80463c
  80268a:	6a 46                	push   $0x46
  80268c:	68 5f 46 80 00       	push   $0x80465f
  802691:	e8 91 e3 ff ff       	call   800a27 <_panic>
  802696:	a1 50 50 80 00       	mov    0x805050,%eax
  80269b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269e:	c1 e2 04             	shl    $0x4,%edx
  8026a1:	01 d0                	add    %edx,%eax
  8026a3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026a9:	89 10                	mov    %edx,(%eax)
  8026ab:	8b 00                	mov    (%eax),%eax
  8026ad:	85 c0                	test   %eax,%eax
  8026af:	74 18                	je     8026c9 <initialize_MemBlocksList+0x88>
  8026b1:	a1 48 51 80 00       	mov    0x805148,%eax
  8026b6:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026bc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026bf:	c1 e1 04             	shl    $0x4,%ecx
  8026c2:	01 ca                	add    %ecx,%edx
  8026c4:	89 50 04             	mov    %edx,0x4(%eax)
  8026c7:	eb 12                	jmp    8026db <initialize_MemBlocksList+0x9a>
  8026c9:	a1 50 50 80 00       	mov    0x805050,%eax
  8026ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d1:	c1 e2 04             	shl    $0x4,%edx
  8026d4:	01 d0                	add    %edx,%eax
  8026d6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026db:	a1 50 50 80 00       	mov    0x805050,%eax
  8026e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e3:	c1 e2 04             	shl    $0x4,%edx
  8026e6:	01 d0                	add    %edx,%eax
  8026e8:	a3 48 51 80 00       	mov    %eax,0x805148
  8026ed:	a1 50 50 80 00       	mov    0x805050,%eax
  8026f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f5:	c1 e2 04             	shl    $0x4,%edx
  8026f8:	01 d0                	add    %edx,%eax
  8026fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802701:	a1 54 51 80 00       	mov    0x805154,%eax
  802706:	40                   	inc    %eax
  802707:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80270c:	ff 45 f4             	incl   -0xc(%ebp)
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	3b 45 08             	cmp    0x8(%ebp),%eax
  802715:	0f 82 56 ff ff ff    	jb     802671 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80271b:	90                   	nop
  80271c:	c9                   	leave  
  80271d:	c3                   	ret    

0080271e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80271e:	55                   	push   %ebp
  80271f:	89 e5                	mov    %esp,%ebp
  802721:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802724:	8b 45 08             	mov    0x8(%ebp),%eax
  802727:	8b 00                	mov    (%eax),%eax
  802729:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80272c:	eb 19                	jmp    802747 <find_block+0x29>
	{
		if(va==point->sva)
  80272e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802731:	8b 40 08             	mov    0x8(%eax),%eax
  802734:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802737:	75 05                	jne    80273e <find_block+0x20>
		   return point;
  802739:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80273c:	eb 36                	jmp    802774 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80273e:	8b 45 08             	mov    0x8(%ebp),%eax
  802741:	8b 40 08             	mov    0x8(%eax),%eax
  802744:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802747:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80274b:	74 07                	je     802754 <find_block+0x36>
  80274d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802750:	8b 00                	mov    (%eax),%eax
  802752:	eb 05                	jmp    802759 <find_block+0x3b>
  802754:	b8 00 00 00 00       	mov    $0x0,%eax
  802759:	8b 55 08             	mov    0x8(%ebp),%edx
  80275c:	89 42 08             	mov    %eax,0x8(%edx)
  80275f:	8b 45 08             	mov    0x8(%ebp),%eax
  802762:	8b 40 08             	mov    0x8(%eax),%eax
  802765:	85 c0                	test   %eax,%eax
  802767:	75 c5                	jne    80272e <find_block+0x10>
  802769:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80276d:	75 bf                	jne    80272e <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80276f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802774:	c9                   	leave  
  802775:	c3                   	ret    

00802776 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
  802779:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80277c:	a1 40 50 80 00       	mov    0x805040,%eax
  802781:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802784:	a1 44 50 80 00       	mov    0x805044,%eax
  802789:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80278c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802792:	74 24                	je     8027b8 <insert_sorted_allocList+0x42>
  802794:	8b 45 08             	mov    0x8(%ebp),%eax
  802797:	8b 50 08             	mov    0x8(%eax),%edx
  80279a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279d:	8b 40 08             	mov    0x8(%eax),%eax
  8027a0:	39 c2                	cmp    %eax,%edx
  8027a2:	76 14                	jbe    8027b8 <insert_sorted_allocList+0x42>
  8027a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a7:	8b 50 08             	mov    0x8(%eax),%edx
  8027aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ad:	8b 40 08             	mov    0x8(%eax),%eax
  8027b0:	39 c2                	cmp    %eax,%edx
  8027b2:	0f 82 60 01 00 00    	jb     802918 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8027b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027bc:	75 65                	jne    802823 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8027be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027c2:	75 14                	jne    8027d8 <insert_sorted_allocList+0x62>
  8027c4:	83 ec 04             	sub    $0x4,%esp
  8027c7:	68 3c 46 80 00       	push   $0x80463c
  8027cc:	6a 6b                	push   $0x6b
  8027ce:	68 5f 46 80 00       	push   $0x80465f
  8027d3:	e8 4f e2 ff ff       	call   800a27 <_panic>
  8027d8:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	89 10                	mov    %edx,(%eax)
  8027e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e6:	8b 00                	mov    (%eax),%eax
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	74 0d                	je     8027f9 <insert_sorted_allocList+0x83>
  8027ec:	a1 40 50 80 00       	mov    0x805040,%eax
  8027f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f4:	89 50 04             	mov    %edx,0x4(%eax)
  8027f7:	eb 08                	jmp    802801 <insert_sorted_allocList+0x8b>
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	a3 44 50 80 00       	mov    %eax,0x805044
  802801:	8b 45 08             	mov    0x8(%ebp),%eax
  802804:	a3 40 50 80 00       	mov    %eax,0x805040
  802809:	8b 45 08             	mov    0x8(%ebp),%eax
  80280c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802813:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802818:	40                   	inc    %eax
  802819:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80281e:	e9 dc 01 00 00       	jmp    8029ff <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802823:	8b 45 08             	mov    0x8(%ebp),%eax
  802826:	8b 50 08             	mov    0x8(%eax),%edx
  802829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282c:	8b 40 08             	mov    0x8(%eax),%eax
  80282f:	39 c2                	cmp    %eax,%edx
  802831:	77 6c                	ja     80289f <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802833:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802837:	74 06                	je     80283f <insert_sorted_allocList+0xc9>
  802839:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80283d:	75 14                	jne    802853 <insert_sorted_allocList+0xdd>
  80283f:	83 ec 04             	sub    $0x4,%esp
  802842:	68 78 46 80 00       	push   $0x804678
  802847:	6a 6f                	push   $0x6f
  802849:	68 5f 46 80 00       	push   $0x80465f
  80284e:	e8 d4 e1 ff ff       	call   800a27 <_panic>
  802853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802856:	8b 50 04             	mov    0x4(%eax),%edx
  802859:	8b 45 08             	mov    0x8(%ebp),%eax
  80285c:	89 50 04             	mov    %edx,0x4(%eax)
  80285f:	8b 45 08             	mov    0x8(%ebp),%eax
  802862:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802865:	89 10                	mov    %edx,(%eax)
  802867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286a:	8b 40 04             	mov    0x4(%eax),%eax
  80286d:	85 c0                	test   %eax,%eax
  80286f:	74 0d                	je     80287e <insert_sorted_allocList+0x108>
  802871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802874:	8b 40 04             	mov    0x4(%eax),%eax
  802877:	8b 55 08             	mov    0x8(%ebp),%edx
  80287a:	89 10                	mov    %edx,(%eax)
  80287c:	eb 08                	jmp    802886 <insert_sorted_allocList+0x110>
  80287e:	8b 45 08             	mov    0x8(%ebp),%eax
  802881:	a3 40 50 80 00       	mov    %eax,0x805040
  802886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802889:	8b 55 08             	mov    0x8(%ebp),%edx
  80288c:	89 50 04             	mov    %edx,0x4(%eax)
  80288f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802894:	40                   	inc    %eax
  802895:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80289a:	e9 60 01 00 00       	jmp    8029ff <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80289f:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a2:	8b 50 08             	mov    0x8(%eax),%edx
  8028a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a8:	8b 40 08             	mov    0x8(%eax),%eax
  8028ab:	39 c2                	cmp    %eax,%edx
  8028ad:	0f 82 4c 01 00 00    	jb     8029ff <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8028b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028b7:	75 14                	jne    8028cd <insert_sorted_allocList+0x157>
  8028b9:	83 ec 04             	sub    $0x4,%esp
  8028bc:	68 b0 46 80 00       	push   $0x8046b0
  8028c1:	6a 73                	push   $0x73
  8028c3:	68 5f 46 80 00       	push   $0x80465f
  8028c8:	e8 5a e1 ff ff       	call   800a27 <_panic>
  8028cd:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	89 50 04             	mov    %edx,0x4(%eax)
  8028d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dc:	8b 40 04             	mov    0x4(%eax),%eax
  8028df:	85 c0                	test   %eax,%eax
  8028e1:	74 0c                	je     8028ef <insert_sorted_allocList+0x179>
  8028e3:	a1 44 50 80 00       	mov    0x805044,%eax
  8028e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028eb:	89 10                	mov    %edx,(%eax)
  8028ed:	eb 08                	jmp    8028f7 <insert_sorted_allocList+0x181>
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	a3 40 50 80 00       	mov    %eax,0x805040
  8028f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fa:	a3 44 50 80 00       	mov    %eax,0x805044
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802908:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80290d:	40                   	inc    %eax
  80290e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802913:	e9 e7 00 00 00       	jmp    8029ff <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80291e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802925:	a1 40 50 80 00       	mov    0x805040,%eax
  80292a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80292d:	e9 9d 00 00 00       	jmp    8029cf <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	8b 00                	mov    (%eax),%eax
  802937:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80293a:	8b 45 08             	mov    0x8(%ebp),%eax
  80293d:	8b 50 08             	mov    0x8(%eax),%edx
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 40 08             	mov    0x8(%eax),%eax
  802946:	39 c2                	cmp    %eax,%edx
  802948:	76 7d                	jbe    8029c7 <insert_sorted_allocList+0x251>
  80294a:	8b 45 08             	mov    0x8(%ebp),%eax
  80294d:	8b 50 08             	mov    0x8(%eax),%edx
  802950:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802953:	8b 40 08             	mov    0x8(%eax),%eax
  802956:	39 c2                	cmp    %eax,%edx
  802958:	73 6d                	jae    8029c7 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80295a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295e:	74 06                	je     802966 <insert_sorted_allocList+0x1f0>
  802960:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802964:	75 14                	jne    80297a <insert_sorted_allocList+0x204>
  802966:	83 ec 04             	sub    $0x4,%esp
  802969:	68 d4 46 80 00       	push   $0x8046d4
  80296e:	6a 7f                	push   $0x7f
  802970:	68 5f 46 80 00       	push   $0x80465f
  802975:	e8 ad e0 ff ff       	call   800a27 <_panic>
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 10                	mov    (%eax),%edx
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	89 10                	mov    %edx,(%eax)
  802984:	8b 45 08             	mov    0x8(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	74 0b                	je     802998 <insert_sorted_allocList+0x222>
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 00                	mov    (%eax),%eax
  802992:	8b 55 08             	mov    0x8(%ebp),%edx
  802995:	89 50 04             	mov    %edx,0x4(%eax)
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 55 08             	mov    0x8(%ebp),%edx
  80299e:	89 10                	mov    %edx,(%eax)
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a6:	89 50 04             	mov    %edx,0x4(%eax)
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	8b 00                	mov    (%eax),%eax
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	75 08                	jne    8029ba <insert_sorted_allocList+0x244>
  8029b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b5:	a3 44 50 80 00       	mov    %eax,0x805044
  8029ba:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029bf:	40                   	inc    %eax
  8029c0:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8029c5:	eb 39                	jmp    802a00 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029c7:	a1 48 50 80 00       	mov    0x805048,%eax
  8029cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d3:	74 07                	je     8029dc <insert_sorted_allocList+0x266>
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	8b 00                	mov    (%eax),%eax
  8029da:	eb 05                	jmp    8029e1 <insert_sorted_allocList+0x26b>
  8029dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e1:	a3 48 50 80 00       	mov    %eax,0x805048
  8029e6:	a1 48 50 80 00       	mov    0x805048,%eax
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	0f 85 3f ff ff ff    	jne    802932 <insert_sorted_allocList+0x1bc>
  8029f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f7:	0f 85 35 ff ff ff    	jne    802932 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8029fd:	eb 01                	jmp    802a00 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029ff:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a00:	90                   	nop
  802a01:	c9                   	leave  
  802a02:	c3                   	ret    

00802a03 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a03:	55                   	push   %ebp
  802a04:	89 e5                	mov    %esp,%ebp
  802a06:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a09:	a1 38 51 80 00       	mov    0x805138,%eax
  802a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a11:	e9 85 01 00 00       	jmp    802b9b <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a1f:	0f 82 6e 01 00 00    	jb     802b93 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a2e:	0f 85 8a 00 00 00    	jne    802abe <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802a34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a38:	75 17                	jne    802a51 <alloc_block_FF+0x4e>
  802a3a:	83 ec 04             	sub    $0x4,%esp
  802a3d:	68 08 47 80 00       	push   $0x804708
  802a42:	68 93 00 00 00       	push   $0x93
  802a47:	68 5f 46 80 00       	push   $0x80465f
  802a4c:	e8 d6 df ff ff       	call   800a27 <_panic>
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	8b 00                	mov    (%eax),%eax
  802a56:	85 c0                	test   %eax,%eax
  802a58:	74 10                	je     802a6a <alloc_block_FF+0x67>
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 00                	mov    (%eax),%eax
  802a5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a62:	8b 52 04             	mov    0x4(%edx),%edx
  802a65:	89 50 04             	mov    %edx,0x4(%eax)
  802a68:	eb 0b                	jmp    802a75 <alloc_block_FF+0x72>
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	8b 40 04             	mov    0x4(%eax),%eax
  802a70:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a78:	8b 40 04             	mov    0x4(%eax),%eax
  802a7b:	85 c0                	test   %eax,%eax
  802a7d:	74 0f                	je     802a8e <alloc_block_FF+0x8b>
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	8b 40 04             	mov    0x4(%eax),%eax
  802a85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a88:	8b 12                	mov    (%edx),%edx
  802a8a:	89 10                	mov    %edx,(%eax)
  802a8c:	eb 0a                	jmp    802a98 <alloc_block_FF+0x95>
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 00                	mov    (%eax),%eax
  802a93:	a3 38 51 80 00       	mov    %eax,0x805138
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aab:	a1 44 51 80 00       	mov    0x805144,%eax
  802ab0:	48                   	dec    %eax
  802ab1:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	e9 10 01 00 00       	jmp    802bce <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac7:	0f 86 c6 00 00 00    	jbe    802b93 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802acd:	a1 48 51 80 00       	mov    0x805148,%eax
  802ad2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	8b 50 08             	mov    0x8(%eax),%edx
  802adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ade:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae7:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aee:	75 17                	jne    802b07 <alloc_block_FF+0x104>
  802af0:	83 ec 04             	sub    $0x4,%esp
  802af3:	68 08 47 80 00       	push   $0x804708
  802af8:	68 9b 00 00 00       	push   $0x9b
  802afd:	68 5f 46 80 00       	push   $0x80465f
  802b02:	e8 20 df ff ff       	call   800a27 <_panic>
  802b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0a:	8b 00                	mov    (%eax),%eax
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	74 10                	je     802b20 <alloc_block_FF+0x11d>
  802b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b13:	8b 00                	mov    (%eax),%eax
  802b15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b18:	8b 52 04             	mov    0x4(%edx),%edx
  802b1b:	89 50 04             	mov    %edx,0x4(%eax)
  802b1e:	eb 0b                	jmp    802b2b <alloc_block_FF+0x128>
  802b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b23:	8b 40 04             	mov    0x4(%eax),%eax
  802b26:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2e:	8b 40 04             	mov    0x4(%eax),%eax
  802b31:	85 c0                	test   %eax,%eax
  802b33:	74 0f                	je     802b44 <alloc_block_FF+0x141>
  802b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b38:	8b 40 04             	mov    0x4(%eax),%eax
  802b3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b3e:	8b 12                	mov    (%edx),%edx
  802b40:	89 10                	mov    %edx,(%eax)
  802b42:	eb 0a                	jmp    802b4e <alloc_block_FF+0x14b>
  802b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b47:	8b 00                	mov    (%eax),%eax
  802b49:	a3 48 51 80 00       	mov    %eax,0x805148
  802b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b61:	a1 54 51 80 00       	mov    0x805154,%eax
  802b66:	48                   	dec    %eax
  802b67:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	8b 50 08             	mov    0x8(%eax),%edx
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	01 c2                	add    %eax,%edx
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	8b 40 0c             	mov    0xc(%eax),%eax
  802b83:	2b 45 08             	sub    0x8(%ebp),%eax
  802b86:	89 c2                	mov    %eax,%edx
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b91:	eb 3b                	jmp    802bce <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802b93:	a1 40 51 80 00       	mov    0x805140,%eax
  802b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9f:	74 07                	je     802ba8 <alloc_block_FF+0x1a5>
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	8b 00                	mov    (%eax),%eax
  802ba6:	eb 05                	jmp    802bad <alloc_block_FF+0x1aa>
  802ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bad:	a3 40 51 80 00       	mov    %eax,0x805140
  802bb2:	a1 40 51 80 00       	mov    0x805140,%eax
  802bb7:	85 c0                	test   %eax,%eax
  802bb9:	0f 85 57 fe ff ff    	jne    802a16 <alloc_block_FF+0x13>
  802bbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc3:	0f 85 4d fe ff ff    	jne    802a16 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802bc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bce:	c9                   	leave  
  802bcf:	c3                   	ret    

00802bd0 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802bd0:	55                   	push   %ebp
  802bd1:	89 e5                	mov    %esp,%ebp
  802bd3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802bd6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802bdd:	a1 38 51 80 00       	mov    0x805138,%eax
  802be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be5:	e9 df 00 00 00       	jmp    802cc9 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf3:	0f 82 c8 00 00 00    	jb     802cc1 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c02:	0f 85 8a 00 00 00    	jne    802c92 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0c:	75 17                	jne    802c25 <alloc_block_BF+0x55>
  802c0e:	83 ec 04             	sub    $0x4,%esp
  802c11:	68 08 47 80 00       	push   $0x804708
  802c16:	68 b7 00 00 00       	push   $0xb7
  802c1b:	68 5f 46 80 00       	push   $0x80465f
  802c20:	e8 02 de ff ff       	call   800a27 <_panic>
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	8b 00                	mov    (%eax),%eax
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	74 10                	je     802c3e <alloc_block_BF+0x6e>
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	8b 00                	mov    (%eax),%eax
  802c33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c36:	8b 52 04             	mov    0x4(%edx),%edx
  802c39:	89 50 04             	mov    %edx,0x4(%eax)
  802c3c:	eb 0b                	jmp    802c49 <alloc_block_BF+0x79>
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 40 04             	mov    0x4(%eax),%eax
  802c44:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 40 04             	mov    0x4(%eax),%eax
  802c4f:	85 c0                	test   %eax,%eax
  802c51:	74 0f                	je     802c62 <alloc_block_BF+0x92>
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 40 04             	mov    0x4(%eax),%eax
  802c59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5c:	8b 12                	mov    (%edx),%edx
  802c5e:	89 10                	mov    %edx,(%eax)
  802c60:	eb 0a                	jmp    802c6c <alloc_block_BF+0x9c>
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	8b 00                	mov    (%eax),%eax
  802c67:	a3 38 51 80 00       	mov    %eax,0x805138
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7f:	a1 44 51 80 00       	mov    0x805144,%eax
  802c84:	48                   	dec    %eax
  802c85:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	e9 4d 01 00 00       	jmp    802ddf <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	8b 40 0c             	mov    0xc(%eax),%eax
  802c98:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c9b:	76 24                	jbe    802cc1 <alloc_block_BF+0xf1>
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ca6:	73 19                	jae    802cc1 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802ca8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 40 08             	mov    0x8(%eax),%eax
  802cbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802cc1:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccd:	74 07                	je     802cd6 <alloc_block_BF+0x106>
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	eb 05                	jmp    802cdb <alloc_block_BF+0x10b>
  802cd6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cdb:	a3 40 51 80 00       	mov    %eax,0x805140
  802ce0:	a1 40 51 80 00       	mov    0x805140,%eax
  802ce5:	85 c0                	test   %eax,%eax
  802ce7:	0f 85 fd fe ff ff    	jne    802bea <alloc_block_BF+0x1a>
  802ced:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf1:	0f 85 f3 fe ff ff    	jne    802bea <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802cf7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cfb:	0f 84 d9 00 00 00    	je     802dda <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d01:	a1 48 51 80 00       	mov    0x805148,%eax
  802d06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d0c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d0f:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802d12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d15:	8b 55 08             	mov    0x8(%ebp),%edx
  802d18:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802d1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d1f:	75 17                	jne    802d38 <alloc_block_BF+0x168>
  802d21:	83 ec 04             	sub    $0x4,%esp
  802d24:	68 08 47 80 00       	push   $0x804708
  802d29:	68 c7 00 00 00       	push   $0xc7
  802d2e:	68 5f 46 80 00       	push   $0x80465f
  802d33:	e8 ef dc ff ff       	call   800a27 <_panic>
  802d38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	85 c0                	test   %eax,%eax
  802d3f:	74 10                	je     802d51 <alloc_block_BF+0x181>
  802d41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d44:	8b 00                	mov    (%eax),%eax
  802d46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d49:	8b 52 04             	mov    0x4(%edx),%edx
  802d4c:	89 50 04             	mov    %edx,0x4(%eax)
  802d4f:	eb 0b                	jmp    802d5c <alloc_block_BF+0x18c>
  802d51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d54:	8b 40 04             	mov    0x4(%eax),%eax
  802d57:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d5f:	8b 40 04             	mov    0x4(%eax),%eax
  802d62:	85 c0                	test   %eax,%eax
  802d64:	74 0f                	je     802d75 <alloc_block_BF+0x1a5>
  802d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d69:	8b 40 04             	mov    0x4(%eax),%eax
  802d6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d6f:	8b 12                	mov    (%edx),%edx
  802d71:	89 10                	mov    %edx,(%eax)
  802d73:	eb 0a                	jmp    802d7f <alloc_block_BF+0x1af>
  802d75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d78:	8b 00                	mov    (%eax),%eax
  802d7a:	a3 48 51 80 00       	mov    %eax,0x805148
  802d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d92:	a1 54 51 80 00       	mov    0x805154,%eax
  802d97:	48                   	dec    %eax
  802d98:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802d9d:	83 ec 08             	sub    $0x8,%esp
  802da0:	ff 75 ec             	pushl  -0x14(%ebp)
  802da3:	68 38 51 80 00       	push   $0x805138
  802da8:	e8 71 f9 ff ff       	call   80271e <find_block>
  802dad:	83 c4 10             	add    $0x10,%esp
  802db0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802db3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db6:	8b 50 08             	mov    0x8(%eax),%edx
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	01 c2                	add    %eax,%edx
  802dbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc1:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802dc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dca:	2b 45 08             	sub    0x8(%ebp),%eax
  802dcd:	89 c2                	mov    %eax,%edx
  802dcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd2:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802dd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd8:	eb 05                	jmp    802ddf <alloc_block_BF+0x20f>
	}
	return NULL;
  802dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ddf:	c9                   	leave  
  802de0:	c3                   	ret    

00802de1 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802de1:	55                   	push   %ebp
  802de2:	89 e5                	mov    %esp,%ebp
  802de4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802de7:	a1 28 50 80 00       	mov    0x805028,%eax
  802dec:	85 c0                	test   %eax,%eax
  802dee:	0f 85 de 01 00 00    	jne    802fd2 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802df4:	a1 38 51 80 00       	mov    0x805138,%eax
  802df9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dfc:	e9 9e 01 00 00       	jmp    802f9f <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	8b 40 0c             	mov    0xc(%eax),%eax
  802e07:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e0a:	0f 82 87 01 00 00    	jb     802f97 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	8b 40 0c             	mov    0xc(%eax),%eax
  802e16:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e19:	0f 85 95 00 00 00    	jne    802eb4 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802e1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e23:	75 17                	jne    802e3c <alloc_block_NF+0x5b>
  802e25:	83 ec 04             	sub    $0x4,%esp
  802e28:	68 08 47 80 00       	push   $0x804708
  802e2d:	68 e0 00 00 00       	push   $0xe0
  802e32:	68 5f 46 80 00       	push   $0x80465f
  802e37:	e8 eb db ff ff       	call   800a27 <_panic>
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	8b 00                	mov    (%eax),%eax
  802e41:	85 c0                	test   %eax,%eax
  802e43:	74 10                	je     802e55 <alloc_block_NF+0x74>
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	8b 00                	mov    (%eax),%eax
  802e4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4d:	8b 52 04             	mov    0x4(%edx),%edx
  802e50:	89 50 04             	mov    %edx,0x4(%eax)
  802e53:	eb 0b                	jmp    802e60 <alloc_block_NF+0x7f>
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	8b 40 04             	mov    0x4(%eax),%eax
  802e5b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	8b 40 04             	mov    0x4(%eax),%eax
  802e66:	85 c0                	test   %eax,%eax
  802e68:	74 0f                	je     802e79 <alloc_block_NF+0x98>
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	8b 40 04             	mov    0x4(%eax),%eax
  802e70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e73:	8b 12                	mov    (%edx),%edx
  802e75:	89 10                	mov    %edx,(%eax)
  802e77:	eb 0a                	jmp    802e83 <alloc_block_NF+0xa2>
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 00                	mov    (%eax),%eax
  802e7e:	a3 38 51 80 00       	mov    %eax,0x805138
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e96:	a1 44 51 80 00       	mov    0x805144,%eax
  802e9b:	48                   	dec    %eax
  802e9c:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	8b 40 08             	mov    0x8(%eax),%eax
  802ea7:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaf:	e9 f8 04 00 00       	jmp    8033ac <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eba:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ebd:	0f 86 d4 00 00 00    	jbe    802f97 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ec3:	a1 48 51 80 00       	mov    0x805148,%eax
  802ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	8b 50 08             	mov    0x8(%eax),%edx
  802ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed4:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eda:	8b 55 08             	mov    0x8(%ebp),%edx
  802edd:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ee0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee4:	75 17                	jne    802efd <alloc_block_NF+0x11c>
  802ee6:	83 ec 04             	sub    $0x4,%esp
  802ee9:	68 08 47 80 00       	push   $0x804708
  802eee:	68 e9 00 00 00       	push   $0xe9
  802ef3:	68 5f 46 80 00       	push   $0x80465f
  802ef8:	e8 2a db ff ff       	call   800a27 <_panic>
  802efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f00:	8b 00                	mov    (%eax),%eax
  802f02:	85 c0                	test   %eax,%eax
  802f04:	74 10                	je     802f16 <alloc_block_NF+0x135>
  802f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0e:	8b 52 04             	mov    0x4(%edx),%edx
  802f11:	89 50 04             	mov    %edx,0x4(%eax)
  802f14:	eb 0b                	jmp    802f21 <alloc_block_NF+0x140>
  802f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f19:	8b 40 04             	mov    0x4(%eax),%eax
  802f1c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f24:	8b 40 04             	mov    0x4(%eax),%eax
  802f27:	85 c0                	test   %eax,%eax
  802f29:	74 0f                	je     802f3a <alloc_block_NF+0x159>
  802f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2e:	8b 40 04             	mov    0x4(%eax),%eax
  802f31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f34:	8b 12                	mov    (%edx),%edx
  802f36:	89 10                	mov    %edx,(%eax)
  802f38:	eb 0a                	jmp    802f44 <alloc_block_NF+0x163>
  802f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3d:	8b 00                	mov    (%eax),%eax
  802f3f:	a3 48 51 80 00       	mov    %eax,0x805148
  802f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f57:	a1 54 51 80 00       	mov    0x805154,%eax
  802f5c:	48                   	dec    %eax
  802f5d:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f65:	8b 40 08             	mov    0x8(%eax),%eax
  802f68:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	8b 50 08             	mov    0x8(%eax),%edx
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	01 c2                	add    %eax,%edx
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	8b 40 0c             	mov    0xc(%eax),%eax
  802f84:	2b 45 08             	sub    0x8(%ebp),%eax
  802f87:	89 c2                	mov    %eax,%edx
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f92:	e9 15 04 00 00       	jmp    8033ac <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802f97:	a1 40 51 80 00       	mov    0x805140,%eax
  802f9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa3:	74 07                	je     802fac <alloc_block_NF+0x1cb>
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	8b 00                	mov    (%eax),%eax
  802faa:	eb 05                	jmp    802fb1 <alloc_block_NF+0x1d0>
  802fac:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb1:	a3 40 51 80 00       	mov    %eax,0x805140
  802fb6:	a1 40 51 80 00       	mov    0x805140,%eax
  802fbb:	85 c0                	test   %eax,%eax
  802fbd:	0f 85 3e fe ff ff    	jne    802e01 <alloc_block_NF+0x20>
  802fc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc7:	0f 85 34 fe ff ff    	jne    802e01 <alloc_block_NF+0x20>
  802fcd:	e9 d5 03 00 00       	jmp    8033a7 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fd2:	a1 38 51 80 00       	mov    0x805138,%eax
  802fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fda:	e9 b1 01 00 00       	jmp    803190 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	8b 50 08             	mov    0x8(%eax),%edx
  802fe5:	a1 28 50 80 00       	mov    0x805028,%eax
  802fea:	39 c2                	cmp    %eax,%edx
  802fec:	0f 82 96 01 00 00    	jb     803188 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ffb:	0f 82 87 01 00 00    	jb     803188 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803004:	8b 40 0c             	mov    0xc(%eax),%eax
  803007:	3b 45 08             	cmp    0x8(%ebp),%eax
  80300a:	0f 85 95 00 00 00    	jne    8030a5 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803010:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803014:	75 17                	jne    80302d <alloc_block_NF+0x24c>
  803016:	83 ec 04             	sub    $0x4,%esp
  803019:	68 08 47 80 00       	push   $0x804708
  80301e:	68 fc 00 00 00       	push   $0xfc
  803023:	68 5f 46 80 00       	push   $0x80465f
  803028:	e8 fa d9 ff ff       	call   800a27 <_panic>
  80302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803030:	8b 00                	mov    (%eax),%eax
  803032:	85 c0                	test   %eax,%eax
  803034:	74 10                	je     803046 <alloc_block_NF+0x265>
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	8b 00                	mov    (%eax),%eax
  80303b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80303e:	8b 52 04             	mov    0x4(%edx),%edx
  803041:	89 50 04             	mov    %edx,0x4(%eax)
  803044:	eb 0b                	jmp    803051 <alloc_block_NF+0x270>
  803046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803049:	8b 40 04             	mov    0x4(%eax),%eax
  80304c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803054:	8b 40 04             	mov    0x4(%eax),%eax
  803057:	85 c0                	test   %eax,%eax
  803059:	74 0f                	je     80306a <alloc_block_NF+0x289>
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	8b 40 04             	mov    0x4(%eax),%eax
  803061:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803064:	8b 12                	mov    (%edx),%edx
  803066:	89 10                	mov    %edx,(%eax)
  803068:	eb 0a                	jmp    803074 <alloc_block_NF+0x293>
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	a3 38 51 80 00       	mov    %eax,0x805138
  803074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803077:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803087:	a1 44 51 80 00       	mov    0x805144,%eax
  80308c:	48                   	dec    %eax
  80308d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	8b 40 08             	mov    0x8(%eax),%eax
  803098:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80309d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a0:	e9 07 03 00 00       	jmp    8033ac <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030ae:	0f 86 d4 00 00 00    	jbe    803188 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030b4:	a1 48 51 80 00       	mov    0x805148,%eax
  8030b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8030bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bf:	8b 50 08             	mov    0x8(%eax),%edx
  8030c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ce:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d5:	75 17                	jne    8030ee <alloc_block_NF+0x30d>
  8030d7:	83 ec 04             	sub    $0x4,%esp
  8030da:	68 08 47 80 00       	push   $0x804708
  8030df:	68 04 01 00 00       	push   $0x104
  8030e4:	68 5f 46 80 00       	push   $0x80465f
  8030e9:	e8 39 d9 ff ff       	call   800a27 <_panic>
  8030ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f1:	8b 00                	mov    (%eax),%eax
  8030f3:	85 c0                	test   %eax,%eax
  8030f5:	74 10                	je     803107 <alloc_block_NF+0x326>
  8030f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fa:	8b 00                	mov    (%eax),%eax
  8030fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ff:	8b 52 04             	mov    0x4(%edx),%edx
  803102:	89 50 04             	mov    %edx,0x4(%eax)
  803105:	eb 0b                	jmp    803112 <alloc_block_NF+0x331>
  803107:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310a:	8b 40 04             	mov    0x4(%eax),%eax
  80310d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803112:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803115:	8b 40 04             	mov    0x4(%eax),%eax
  803118:	85 c0                	test   %eax,%eax
  80311a:	74 0f                	je     80312b <alloc_block_NF+0x34a>
  80311c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311f:	8b 40 04             	mov    0x4(%eax),%eax
  803122:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803125:	8b 12                	mov    (%edx),%edx
  803127:	89 10                	mov    %edx,(%eax)
  803129:	eb 0a                	jmp    803135 <alloc_block_NF+0x354>
  80312b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312e:	8b 00                	mov    (%eax),%eax
  803130:	a3 48 51 80 00       	mov    %eax,0x805148
  803135:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803138:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803141:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803148:	a1 54 51 80 00       	mov    0x805154,%eax
  80314d:	48                   	dec    %eax
  80314e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803153:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803156:	8b 40 08             	mov    0x8(%eax),%eax
  803159:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80315e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803161:	8b 50 08             	mov    0x8(%eax),%edx
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	01 c2                	add    %eax,%edx
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80316f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803172:	8b 40 0c             	mov    0xc(%eax),%eax
  803175:	2b 45 08             	sub    0x8(%ebp),%eax
  803178:	89 c2                	mov    %eax,%edx
  80317a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803180:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803183:	e9 24 02 00 00       	jmp    8033ac <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803188:	a1 40 51 80 00       	mov    0x805140,%eax
  80318d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803190:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803194:	74 07                	je     80319d <alloc_block_NF+0x3bc>
  803196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803199:	8b 00                	mov    (%eax),%eax
  80319b:	eb 05                	jmp    8031a2 <alloc_block_NF+0x3c1>
  80319d:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a2:	a3 40 51 80 00       	mov    %eax,0x805140
  8031a7:	a1 40 51 80 00       	mov    0x805140,%eax
  8031ac:	85 c0                	test   %eax,%eax
  8031ae:	0f 85 2b fe ff ff    	jne    802fdf <alloc_block_NF+0x1fe>
  8031b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b8:	0f 85 21 fe ff ff    	jne    802fdf <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031be:	a1 38 51 80 00       	mov    0x805138,%eax
  8031c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c6:	e9 ae 01 00 00       	jmp    803379 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8031cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ce:	8b 50 08             	mov    0x8(%eax),%edx
  8031d1:	a1 28 50 80 00       	mov    0x805028,%eax
  8031d6:	39 c2                	cmp    %eax,%edx
  8031d8:	0f 83 93 01 00 00    	jae    803371 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8031de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e7:	0f 82 84 01 00 00    	jb     803371 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8031ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f6:	0f 85 95 00 00 00    	jne    803291 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8031fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803200:	75 17                	jne    803219 <alloc_block_NF+0x438>
  803202:	83 ec 04             	sub    $0x4,%esp
  803205:	68 08 47 80 00       	push   $0x804708
  80320a:	68 14 01 00 00       	push   $0x114
  80320f:	68 5f 46 80 00       	push   $0x80465f
  803214:	e8 0e d8 ff ff       	call   800a27 <_panic>
  803219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321c:	8b 00                	mov    (%eax),%eax
  80321e:	85 c0                	test   %eax,%eax
  803220:	74 10                	je     803232 <alloc_block_NF+0x451>
  803222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803225:	8b 00                	mov    (%eax),%eax
  803227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80322a:	8b 52 04             	mov    0x4(%edx),%edx
  80322d:	89 50 04             	mov    %edx,0x4(%eax)
  803230:	eb 0b                	jmp    80323d <alloc_block_NF+0x45c>
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	8b 40 04             	mov    0x4(%eax),%eax
  803238:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80323d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803240:	8b 40 04             	mov    0x4(%eax),%eax
  803243:	85 c0                	test   %eax,%eax
  803245:	74 0f                	je     803256 <alloc_block_NF+0x475>
  803247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324a:	8b 40 04             	mov    0x4(%eax),%eax
  80324d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803250:	8b 12                	mov    (%edx),%edx
  803252:	89 10                	mov    %edx,(%eax)
  803254:	eb 0a                	jmp    803260 <alloc_block_NF+0x47f>
  803256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803259:	8b 00                	mov    (%eax),%eax
  80325b:	a3 38 51 80 00       	mov    %eax,0x805138
  803260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803263:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803273:	a1 44 51 80 00       	mov    0x805144,%eax
  803278:	48                   	dec    %eax
  803279:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	8b 40 08             	mov    0x8(%eax),%eax
  803284:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328c:	e9 1b 01 00 00       	jmp    8033ac <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	8b 40 0c             	mov    0xc(%eax),%eax
  803297:	3b 45 08             	cmp    0x8(%ebp),%eax
  80329a:	0f 86 d1 00 00 00    	jbe    803371 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032a0:	a1 48 51 80 00       	mov    0x805148,%eax
  8032a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ab:	8b 50 08             	mov    0x8(%eax),%edx
  8032ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b1:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ba:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032c1:	75 17                	jne    8032da <alloc_block_NF+0x4f9>
  8032c3:	83 ec 04             	sub    $0x4,%esp
  8032c6:	68 08 47 80 00       	push   $0x804708
  8032cb:	68 1c 01 00 00       	push   $0x11c
  8032d0:	68 5f 46 80 00       	push   $0x80465f
  8032d5:	e8 4d d7 ff ff       	call   800a27 <_panic>
  8032da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032dd:	8b 00                	mov    (%eax),%eax
  8032df:	85 c0                	test   %eax,%eax
  8032e1:	74 10                	je     8032f3 <alloc_block_NF+0x512>
  8032e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e6:	8b 00                	mov    (%eax),%eax
  8032e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032eb:	8b 52 04             	mov    0x4(%edx),%edx
  8032ee:	89 50 04             	mov    %edx,0x4(%eax)
  8032f1:	eb 0b                	jmp    8032fe <alloc_block_NF+0x51d>
  8032f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f6:	8b 40 04             	mov    0x4(%eax),%eax
  8032f9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803301:	8b 40 04             	mov    0x4(%eax),%eax
  803304:	85 c0                	test   %eax,%eax
  803306:	74 0f                	je     803317 <alloc_block_NF+0x536>
  803308:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330b:	8b 40 04             	mov    0x4(%eax),%eax
  80330e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803311:	8b 12                	mov    (%edx),%edx
  803313:	89 10                	mov    %edx,(%eax)
  803315:	eb 0a                	jmp    803321 <alloc_block_NF+0x540>
  803317:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331a:	8b 00                	mov    (%eax),%eax
  80331c:	a3 48 51 80 00       	mov    %eax,0x805148
  803321:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803324:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803334:	a1 54 51 80 00       	mov    0x805154,%eax
  803339:	48                   	dec    %eax
  80333a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80333f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803342:	8b 40 08             	mov    0x8(%eax),%eax
  803345:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80334a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334d:	8b 50 08             	mov    0x8(%eax),%edx
  803350:	8b 45 08             	mov    0x8(%ebp),%eax
  803353:	01 c2                	add    %eax,%edx
  803355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803358:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	8b 40 0c             	mov    0xc(%eax),%eax
  803361:	2b 45 08             	sub    0x8(%ebp),%eax
  803364:	89 c2                	mov    %eax,%edx
  803366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803369:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80336c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336f:	eb 3b                	jmp    8033ac <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803371:	a1 40 51 80 00       	mov    0x805140,%eax
  803376:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803379:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80337d:	74 07                	je     803386 <alloc_block_NF+0x5a5>
  80337f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803382:	8b 00                	mov    (%eax),%eax
  803384:	eb 05                	jmp    80338b <alloc_block_NF+0x5aa>
  803386:	b8 00 00 00 00       	mov    $0x0,%eax
  80338b:	a3 40 51 80 00       	mov    %eax,0x805140
  803390:	a1 40 51 80 00       	mov    0x805140,%eax
  803395:	85 c0                	test   %eax,%eax
  803397:	0f 85 2e fe ff ff    	jne    8031cb <alloc_block_NF+0x3ea>
  80339d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a1:	0f 85 24 fe ff ff    	jne    8031cb <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8033a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033ac:	c9                   	leave  
  8033ad:	c3                   	ret    

008033ae <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8033ae:	55                   	push   %ebp
  8033af:	89 e5                	mov    %esp,%ebp
  8033b1:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8033b4:	a1 38 51 80 00       	mov    0x805138,%eax
  8033b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8033bc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033c1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8033c4:	a1 38 51 80 00       	mov    0x805138,%eax
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	74 14                	je     8033e1 <insert_sorted_with_merge_freeList+0x33>
  8033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d0:	8b 50 08             	mov    0x8(%eax),%edx
  8033d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d6:	8b 40 08             	mov    0x8(%eax),%eax
  8033d9:	39 c2                	cmp    %eax,%edx
  8033db:	0f 87 9b 01 00 00    	ja     80357c <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8033e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033e5:	75 17                	jne    8033fe <insert_sorted_with_merge_freeList+0x50>
  8033e7:	83 ec 04             	sub    $0x4,%esp
  8033ea:	68 3c 46 80 00       	push   $0x80463c
  8033ef:	68 38 01 00 00       	push   $0x138
  8033f4:	68 5f 46 80 00       	push   $0x80465f
  8033f9:	e8 29 d6 ff ff       	call   800a27 <_panic>
  8033fe:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803404:	8b 45 08             	mov    0x8(%ebp),%eax
  803407:	89 10                	mov    %edx,(%eax)
  803409:	8b 45 08             	mov    0x8(%ebp),%eax
  80340c:	8b 00                	mov    (%eax),%eax
  80340e:	85 c0                	test   %eax,%eax
  803410:	74 0d                	je     80341f <insert_sorted_with_merge_freeList+0x71>
  803412:	a1 38 51 80 00       	mov    0x805138,%eax
  803417:	8b 55 08             	mov    0x8(%ebp),%edx
  80341a:	89 50 04             	mov    %edx,0x4(%eax)
  80341d:	eb 08                	jmp    803427 <insert_sorted_with_merge_freeList+0x79>
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803427:	8b 45 08             	mov    0x8(%ebp),%eax
  80342a:	a3 38 51 80 00       	mov    %eax,0x805138
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803439:	a1 44 51 80 00       	mov    0x805144,%eax
  80343e:	40                   	inc    %eax
  80343f:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803444:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803448:	0f 84 a8 06 00 00    	je     803af6 <insert_sorted_with_merge_freeList+0x748>
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	8b 50 08             	mov    0x8(%eax),%edx
  803454:	8b 45 08             	mov    0x8(%ebp),%eax
  803457:	8b 40 0c             	mov    0xc(%eax),%eax
  80345a:	01 c2                	add    %eax,%edx
  80345c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345f:	8b 40 08             	mov    0x8(%eax),%eax
  803462:	39 c2                	cmp    %eax,%edx
  803464:	0f 85 8c 06 00 00    	jne    803af6 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80346a:	8b 45 08             	mov    0x8(%ebp),%eax
  80346d:	8b 50 0c             	mov    0xc(%eax),%edx
  803470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803473:	8b 40 0c             	mov    0xc(%eax),%eax
  803476:	01 c2                	add    %eax,%edx
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80347e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803482:	75 17                	jne    80349b <insert_sorted_with_merge_freeList+0xed>
  803484:	83 ec 04             	sub    $0x4,%esp
  803487:	68 08 47 80 00       	push   $0x804708
  80348c:	68 3c 01 00 00       	push   $0x13c
  803491:	68 5f 46 80 00       	push   $0x80465f
  803496:	e8 8c d5 ff ff       	call   800a27 <_panic>
  80349b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349e:	8b 00                	mov    (%eax),%eax
  8034a0:	85 c0                	test   %eax,%eax
  8034a2:	74 10                	je     8034b4 <insert_sorted_with_merge_freeList+0x106>
  8034a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a7:	8b 00                	mov    (%eax),%eax
  8034a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ac:	8b 52 04             	mov    0x4(%edx),%edx
  8034af:	89 50 04             	mov    %edx,0x4(%eax)
  8034b2:	eb 0b                	jmp    8034bf <insert_sorted_with_merge_freeList+0x111>
  8034b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b7:	8b 40 04             	mov    0x4(%eax),%eax
  8034ba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c2:	8b 40 04             	mov    0x4(%eax),%eax
  8034c5:	85 c0                	test   %eax,%eax
  8034c7:	74 0f                	je     8034d8 <insert_sorted_with_merge_freeList+0x12a>
  8034c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034cc:	8b 40 04             	mov    0x4(%eax),%eax
  8034cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034d2:	8b 12                	mov    (%edx),%edx
  8034d4:	89 10                	mov    %edx,(%eax)
  8034d6:	eb 0a                	jmp    8034e2 <insert_sorted_with_merge_freeList+0x134>
  8034d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034db:	8b 00                	mov    (%eax),%eax
  8034dd:	a3 38 51 80 00       	mov    %eax,0x805138
  8034e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f5:	a1 44 51 80 00       	mov    0x805144,%eax
  8034fa:	48                   	dec    %eax
  8034fb:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803503:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80350a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803514:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803518:	75 17                	jne    803531 <insert_sorted_with_merge_freeList+0x183>
  80351a:	83 ec 04             	sub    $0x4,%esp
  80351d:	68 3c 46 80 00       	push   $0x80463c
  803522:	68 3f 01 00 00       	push   $0x13f
  803527:	68 5f 46 80 00       	push   $0x80465f
  80352c:	e8 f6 d4 ff ff       	call   800a27 <_panic>
  803531:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353a:	89 10                	mov    %edx,(%eax)
  80353c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353f:	8b 00                	mov    (%eax),%eax
  803541:	85 c0                	test   %eax,%eax
  803543:	74 0d                	je     803552 <insert_sorted_with_merge_freeList+0x1a4>
  803545:	a1 48 51 80 00       	mov    0x805148,%eax
  80354a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80354d:	89 50 04             	mov    %edx,0x4(%eax)
  803550:	eb 08                	jmp    80355a <insert_sorted_with_merge_freeList+0x1ac>
  803552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803555:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80355a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355d:	a3 48 51 80 00       	mov    %eax,0x805148
  803562:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803565:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80356c:	a1 54 51 80 00       	mov    0x805154,%eax
  803571:	40                   	inc    %eax
  803572:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803577:	e9 7a 05 00 00       	jmp    803af6 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80357c:	8b 45 08             	mov    0x8(%ebp),%eax
  80357f:	8b 50 08             	mov    0x8(%eax),%edx
  803582:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803585:	8b 40 08             	mov    0x8(%eax),%eax
  803588:	39 c2                	cmp    %eax,%edx
  80358a:	0f 82 14 01 00 00    	jb     8036a4 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803590:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803593:	8b 50 08             	mov    0x8(%eax),%edx
  803596:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803599:	8b 40 0c             	mov    0xc(%eax),%eax
  80359c:	01 c2                	add    %eax,%edx
  80359e:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a1:	8b 40 08             	mov    0x8(%eax),%eax
  8035a4:	39 c2                	cmp    %eax,%edx
  8035a6:	0f 85 90 00 00 00    	jne    80363c <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8035ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035af:	8b 50 0c             	mov    0xc(%eax),%edx
  8035b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b8:	01 c2                	add    %eax,%edx
  8035ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035bd:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8035c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8035ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8035d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035d8:	75 17                	jne    8035f1 <insert_sorted_with_merge_freeList+0x243>
  8035da:	83 ec 04             	sub    $0x4,%esp
  8035dd:	68 3c 46 80 00       	push   $0x80463c
  8035e2:	68 49 01 00 00       	push   $0x149
  8035e7:	68 5f 46 80 00       	push   $0x80465f
  8035ec:	e8 36 d4 ff ff       	call   800a27 <_panic>
  8035f1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fa:	89 10                	mov    %edx,(%eax)
  8035fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ff:	8b 00                	mov    (%eax),%eax
  803601:	85 c0                	test   %eax,%eax
  803603:	74 0d                	je     803612 <insert_sorted_with_merge_freeList+0x264>
  803605:	a1 48 51 80 00       	mov    0x805148,%eax
  80360a:	8b 55 08             	mov    0x8(%ebp),%edx
  80360d:	89 50 04             	mov    %edx,0x4(%eax)
  803610:	eb 08                	jmp    80361a <insert_sorted_with_merge_freeList+0x26c>
  803612:	8b 45 08             	mov    0x8(%ebp),%eax
  803615:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80361a:	8b 45 08             	mov    0x8(%ebp),%eax
  80361d:	a3 48 51 80 00       	mov    %eax,0x805148
  803622:	8b 45 08             	mov    0x8(%ebp),%eax
  803625:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362c:	a1 54 51 80 00       	mov    0x805154,%eax
  803631:	40                   	inc    %eax
  803632:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803637:	e9 bb 04 00 00       	jmp    803af7 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80363c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803640:	75 17                	jne    803659 <insert_sorted_with_merge_freeList+0x2ab>
  803642:	83 ec 04             	sub    $0x4,%esp
  803645:	68 b0 46 80 00       	push   $0x8046b0
  80364a:	68 4c 01 00 00       	push   $0x14c
  80364f:	68 5f 46 80 00       	push   $0x80465f
  803654:	e8 ce d3 ff ff       	call   800a27 <_panic>
  803659:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80365f:	8b 45 08             	mov    0x8(%ebp),%eax
  803662:	89 50 04             	mov    %edx,0x4(%eax)
  803665:	8b 45 08             	mov    0x8(%ebp),%eax
  803668:	8b 40 04             	mov    0x4(%eax),%eax
  80366b:	85 c0                	test   %eax,%eax
  80366d:	74 0c                	je     80367b <insert_sorted_with_merge_freeList+0x2cd>
  80366f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803674:	8b 55 08             	mov    0x8(%ebp),%edx
  803677:	89 10                	mov    %edx,(%eax)
  803679:	eb 08                	jmp    803683 <insert_sorted_with_merge_freeList+0x2d5>
  80367b:	8b 45 08             	mov    0x8(%ebp),%eax
  80367e:	a3 38 51 80 00       	mov    %eax,0x805138
  803683:	8b 45 08             	mov    0x8(%ebp),%eax
  803686:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80368b:	8b 45 08             	mov    0x8(%ebp),%eax
  80368e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803694:	a1 44 51 80 00       	mov    0x805144,%eax
  803699:	40                   	inc    %eax
  80369a:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80369f:	e9 53 04 00 00       	jmp    803af7 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8036a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036ac:	e9 15 04 00 00       	jmp    803ac6 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8036b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b4:	8b 00                	mov    (%eax),%eax
  8036b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8036b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bc:	8b 50 08             	mov    0x8(%eax),%edx
  8036bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c2:	8b 40 08             	mov    0x8(%eax),%eax
  8036c5:	39 c2                	cmp    %eax,%edx
  8036c7:	0f 86 f1 03 00 00    	jbe    803abe <insert_sorted_with_merge_freeList+0x710>
  8036cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d0:	8b 50 08             	mov    0x8(%eax),%edx
  8036d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d6:	8b 40 08             	mov    0x8(%eax),%eax
  8036d9:	39 c2                	cmp    %eax,%edx
  8036db:	0f 83 dd 03 00 00    	jae    803abe <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8036e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e4:	8b 50 08             	mov    0x8(%eax),%edx
  8036e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ed:	01 c2                	add    %eax,%edx
  8036ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f2:	8b 40 08             	mov    0x8(%eax),%eax
  8036f5:	39 c2                	cmp    %eax,%edx
  8036f7:	0f 85 b9 01 00 00    	jne    8038b6 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8036fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803700:	8b 50 08             	mov    0x8(%eax),%edx
  803703:	8b 45 08             	mov    0x8(%ebp),%eax
  803706:	8b 40 0c             	mov    0xc(%eax),%eax
  803709:	01 c2                	add    %eax,%edx
  80370b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370e:	8b 40 08             	mov    0x8(%eax),%eax
  803711:	39 c2                	cmp    %eax,%edx
  803713:	0f 85 0d 01 00 00    	jne    803826 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371c:	8b 50 0c             	mov    0xc(%eax),%edx
  80371f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803722:	8b 40 0c             	mov    0xc(%eax),%eax
  803725:	01 c2                	add    %eax,%edx
  803727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372a:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80372d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803731:	75 17                	jne    80374a <insert_sorted_with_merge_freeList+0x39c>
  803733:	83 ec 04             	sub    $0x4,%esp
  803736:	68 08 47 80 00       	push   $0x804708
  80373b:	68 5c 01 00 00       	push   $0x15c
  803740:	68 5f 46 80 00       	push   $0x80465f
  803745:	e8 dd d2 ff ff       	call   800a27 <_panic>
  80374a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374d:	8b 00                	mov    (%eax),%eax
  80374f:	85 c0                	test   %eax,%eax
  803751:	74 10                	je     803763 <insert_sorted_with_merge_freeList+0x3b5>
  803753:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803756:	8b 00                	mov    (%eax),%eax
  803758:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80375b:	8b 52 04             	mov    0x4(%edx),%edx
  80375e:	89 50 04             	mov    %edx,0x4(%eax)
  803761:	eb 0b                	jmp    80376e <insert_sorted_with_merge_freeList+0x3c0>
  803763:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803766:	8b 40 04             	mov    0x4(%eax),%eax
  803769:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80376e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803771:	8b 40 04             	mov    0x4(%eax),%eax
  803774:	85 c0                	test   %eax,%eax
  803776:	74 0f                	je     803787 <insert_sorted_with_merge_freeList+0x3d9>
  803778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80377b:	8b 40 04             	mov    0x4(%eax),%eax
  80377e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803781:	8b 12                	mov    (%edx),%edx
  803783:	89 10                	mov    %edx,(%eax)
  803785:	eb 0a                	jmp    803791 <insert_sorted_with_merge_freeList+0x3e3>
  803787:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378a:	8b 00                	mov    (%eax),%eax
  80378c:	a3 38 51 80 00       	mov    %eax,0x805138
  803791:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803794:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80379a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a4:	a1 44 51 80 00       	mov    0x805144,%eax
  8037a9:	48                   	dec    %eax
  8037aa:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8037af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8037b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037bc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8037c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037c7:	75 17                	jne    8037e0 <insert_sorted_with_merge_freeList+0x432>
  8037c9:	83 ec 04             	sub    $0x4,%esp
  8037cc:	68 3c 46 80 00       	push   $0x80463c
  8037d1:	68 5f 01 00 00       	push   $0x15f
  8037d6:	68 5f 46 80 00       	push   $0x80465f
  8037db:	e8 47 d2 ff ff       	call   800a27 <_panic>
  8037e0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e9:	89 10                	mov    %edx,(%eax)
  8037eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ee:	8b 00                	mov    (%eax),%eax
  8037f0:	85 c0                	test   %eax,%eax
  8037f2:	74 0d                	je     803801 <insert_sorted_with_merge_freeList+0x453>
  8037f4:	a1 48 51 80 00       	mov    0x805148,%eax
  8037f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037fc:	89 50 04             	mov    %edx,0x4(%eax)
  8037ff:	eb 08                	jmp    803809 <insert_sorted_with_merge_freeList+0x45b>
  803801:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803804:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803809:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80380c:	a3 48 51 80 00       	mov    %eax,0x805148
  803811:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803814:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80381b:	a1 54 51 80 00       	mov    0x805154,%eax
  803820:	40                   	inc    %eax
  803821:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803829:	8b 50 0c             	mov    0xc(%eax),%edx
  80382c:	8b 45 08             	mov    0x8(%ebp),%eax
  80382f:	8b 40 0c             	mov    0xc(%eax),%eax
  803832:	01 c2                	add    %eax,%edx
  803834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803837:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80383a:	8b 45 08             	mov    0x8(%ebp),%eax
  80383d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803844:	8b 45 08             	mov    0x8(%ebp),%eax
  803847:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80384e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803852:	75 17                	jne    80386b <insert_sorted_with_merge_freeList+0x4bd>
  803854:	83 ec 04             	sub    $0x4,%esp
  803857:	68 3c 46 80 00       	push   $0x80463c
  80385c:	68 64 01 00 00       	push   $0x164
  803861:	68 5f 46 80 00       	push   $0x80465f
  803866:	e8 bc d1 ff ff       	call   800a27 <_panic>
  80386b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803871:	8b 45 08             	mov    0x8(%ebp),%eax
  803874:	89 10                	mov    %edx,(%eax)
  803876:	8b 45 08             	mov    0x8(%ebp),%eax
  803879:	8b 00                	mov    (%eax),%eax
  80387b:	85 c0                	test   %eax,%eax
  80387d:	74 0d                	je     80388c <insert_sorted_with_merge_freeList+0x4de>
  80387f:	a1 48 51 80 00       	mov    0x805148,%eax
  803884:	8b 55 08             	mov    0x8(%ebp),%edx
  803887:	89 50 04             	mov    %edx,0x4(%eax)
  80388a:	eb 08                	jmp    803894 <insert_sorted_with_merge_freeList+0x4e6>
  80388c:	8b 45 08             	mov    0x8(%ebp),%eax
  80388f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803894:	8b 45 08             	mov    0x8(%ebp),%eax
  803897:	a3 48 51 80 00       	mov    %eax,0x805148
  80389c:	8b 45 08             	mov    0x8(%ebp),%eax
  80389f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8038ab:	40                   	inc    %eax
  8038ac:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8038b1:	e9 41 02 00 00       	jmp    803af7 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8038b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b9:	8b 50 08             	mov    0x8(%eax),%edx
  8038bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8038c2:	01 c2                	add    %eax,%edx
  8038c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c7:	8b 40 08             	mov    0x8(%eax),%eax
  8038ca:	39 c2                	cmp    %eax,%edx
  8038cc:	0f 85 7c 01 00 00    	jne    803a4e <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8038d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038d6:	74 06                	je     8038de <insert_sorted_with_merge_freeList+0x530>
  8038d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038dc:	75 17                	jne    8038f5 <insert_sorted_with_merge_freeList+0x547>
  8038de:	83 ec 04             	sub    $0x4,%esp
  8038e1:	68 78 46 80 00       	push   $0x804678
  8038e6:	68 69 01 00 00       	push   $0x169
  8038eb:	68 5f 46 80 00       	push   $0x80465f
  8038f0:	e8 32 d1 ff ff       	call   800a27 <_panic>
  8038f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f8:	8b 50 04             	mov    0x4(%eax),%edx
  8038fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fe:	89 50 04             	mov    %edx,0x4(%eax)
  803901:	8b 45 08             	mov    0x8(%ebp),%eax
  803904:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803907:	89 10                	mov    %edx,(%eax)
  803909:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390c:	8b 40 04             	mov    0x4(%eax),%eax
  80390f:	85 c0                	test   %eax,%eax
  803911:	74 0d                	je     803920 <insert_sorted_with_merge_freeList+0x572>
  803913:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803916:	8b 40 04             	mov    0x4(%eax),%eax
  803919:	8b 55 08             	mov    0x8(%ebp),%edx
  80391c:	89 10                	mov    %edx,(%eax)
  80391e:	eb 08                	jmp    803928 <insert_sorted_with_merge_freeList+0x57a>
  803920:	8b 45 08             	mov    0x8(%ebp),%eax
  803923:	a3 38 51 80 00       	mov    %eax,0x805138
  803928:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392b:	8b 55 08             	mov    0x8(%ebp),%edx
  80392e:	89 50 04             	mov    %edx,0x4(%eax)
  803931:	a1 44 51 80 00       	mov    0x805144,%eax
  803936:	40                   	inc    %eax
  803937:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80393c:	8b 45 08             	mov    0x8(%ebp),%eax
  80393f:	8b 50 0c             	mov    0xc(%eax),%edx
  803942:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803945:	8b 40 0c             	mov    0xc(%eax),%eax
  803948:	01 c2                	add    %eax,%edx
  80394a:	8b 45 08             	mov    0x8(%ebp),%eax
  80394d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803950:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803954:	75 17                	jne    80396d <insert_sorted_with_merge_freeList+0x5bf>
  803956:	83 ec 04             	sub    $0x4,%esp
  803959:	68 08 47 80 00       	push   $0x804708
  80395e:	68 6b 01 00 00       	push   $0x16b
  803963:	68 5f 46 80 00       	push   $0x80465f
  803968:	e8 ba d0 ff ff       	call   800a27 <_panic>
  80396d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803970:	8b 00                	mov    (%eax),%eax
  803972:	85 c0                	test   %eax,%eax
  803974:	74 10                	je     803986 <insert_sorted_with_merge_freeList+0x5d8>
  803976:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803979:	8b 00                	mov    (%eax),%eax
  80397b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80397e:	8b 52 04             	mov    0x4(%edx),%edx
  803981:	89 50 04             	mov    %edx,0x4(%eax)
  803984:	eb 0b                	jmp    803991 <insert_sorted_with_merge_freeList+0x5e3>
  803986:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803989:	8b 40 04             	mov    0x4(%eax),%eax
  80398c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803991:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803994:	8b 40 04             	mov    0x4(%eax),%eax
  803997:	85 c0                	test   %eax,%eax
  803999:	74 0f                	je     8039aa <insert_sorted_with_merge_freeList+0x5fc>
  80399b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399e:	8b 40 04             	mov    0x4(%eax),%eax
  8039a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039a4:	8b 12                	mov    (%edx),%edx
  8039a6:	89 10                	mov    %edx,(%eax)
  8039a8:	eb 0a                	jmp    8039b4 <insert_sorted_with_merge_freeList+0x606>
  8039aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ad:	8b 00                	mov    (%eax),%eax
  8039af:	a3 38 51 80 00       	mov    %eax,0x805138
  8039b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039c7:	a1 44 51 80 00       	mov    0x805144,%eax
  8039cc:	48                   	dec    %eax
  8039cd:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8039d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8039dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039df:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8039e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039ea:	75 17                	jne    803a03 <insert_sorted_with_merge_freeList+0x655>
  8039ec:	83 ec 04             	sub    $0x4,%esp
  8039ef:	68 3c 46 80 00       	push   $0x80463c
  8039f4:	68 6e 01 00 00       	push   $0x16e
  8039f9:	68 5f 46 80 00       	push   $0x80465f
  8039fe:	e8 24 d0 ff ff       	call   800a27 <_panic>
  803a03:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0c:	89 10                	mov    %edx,(%eax)
  803a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a11:	8b 00                	mov    (%eax),%eax
  803a13:	85 c0                	test   %eax,%eax
  803a15:	74 0d                	je     803a24 <insert_sorted_with_merge_freeList+0x676>
  803a17:	a1 48 51 80 00       	mov    0x805148,%eax
  803a1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a1f:	89 50 04             	mov    %edx,0x4(%eax)
  803a22:	eb 08                	jmp    803a2c <insert_sorted_with_merge_freeList+0x67e>
  803a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a27:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a2f:	a3 48 51 80 00       	mov    %eax,0x805148
  803a34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a3e:	a1 54 51 80 00       	mov    0x805154,%eax
  803a43:	40                   	inc    %eax
  803a44:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a49:	e9 a9 00 00 00       	jmp    803af7 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803a4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a52:	74 06                	je     803a5a <insert_sorted_with_merge_freeList+0x6ac>
  803a54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a58:	75 17                	jne    803a71 <insert_sorted_with_merge_freeList+0x6c3>
  803a5a:	83 ec 04             	sub    $0x4,%esp
  803a5d:	68 d4 46 80 00       	push   $0x8046d4
  803a62:	68 73 01 00 00       	push   $0x173
  803a67:	68 5f 46 80 00       	push   $0x80465f
  803a6c:	e8 b6 cf ff ff       	call   800a27 <_panic>
  803a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a74:	8b 10                	mov    (%eax),%edx
  803a76:	8b 45 08             	mov    0x8(%ebp),%eax
  803a79:	89 10                	mov    %edx,(%eax)
  803a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7e:	8b 00                	mov    (%eax),%eax
  803a80:	85 c0                	test   %eax,%eax
  803a82:	74 0b                	je     803a8f <insert_sorted_with_merge_freeList+0x6e1>
  803a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a87:	8b 00                	mov    (%eax),%eax
  803a89:	8b 55 08             	mov    0x8(%ebp),%edx
  803a8c:	89 50 04             	mov    %edx,0x4(%eax)
  803a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a92:	8b 55 08             	mov    0x8(%ebp),%edx
  803a95:	89 10                	mov    %edx,(%eax)
  803a97:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a9d:	89 50 04             	mov    %edx,0x4(%eax)
  803aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa3:	8b 00                	mov    (%eax),%eax
  803aa5:	85 c0                	test   %eax,%eax
  803aa7:	75 08                	jne    803ab1 <insert_sorted_with_merge_freeList+0x703>
  803aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  803aac:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ab1:	a1 44 51 80 00       	mov    0x805144,%eax
  803ab6:	40                   	inc    %eax
  803ab7:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803abc:	eb 39                	jmp    803af7 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803abe:	a1 40 51 80 00       	mov    0x805140,%eax
  803ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ac6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aca:	74 07                	je     803ad3 <insert_sorted_with_merge_freeList+0x725>
  803acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acf:	8b 00                	mov    (%eax),%eax
  803ad1:	eb 05                	jmp    803ad8 <insert_sorted_with_merge_freeList+0x72a>
  803ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ad8:	a3 40 51 80 00       	mov    %eax,0x805140
  803add:	a1 40 51 80 00       	mov    0x805140,%eax
  803ae2:	85 c0                	test   %eax,%eax
  803ae4:	0f 85 c7 fb ff ff    	jne    8036b1 <insert_sorted_with_merge_freeList+0x303>
  803aea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aee:	0f 85 bd fb ff ff    	jne    8036b1 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803af4:	eb 01                	jmp    803af7 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803af6:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803af7:	90                   	nop
  803af8:	c9                   	leave  
  803af9:	c3                   	ret    
  803afa:	66 90                	xchg   %ax,%ax

00803afc <__udivdi3>:
  803afc:	55                   	push   %ebp
  803afd:	57                   	push   %edi
  803afe:	56                   	push   %esi
  803aff:	53                   	push   %ebx
  803b00:	83 ec 1c             	sub    $0x1c,%esp
  803b03:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b07:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b0f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b13:	89 ca                	mov    %ecx,%edx
  803b15:	89 f8                	mov    %edi,%eax
  803b17:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b1b:	85 f6                	test   %esi,%esi
  803b1d:	75 2d                	jne    803b4c <__udivdi3+0x50>
  803b1f:	39 cf                	cmp    %ecx,%edi
  803b21:	77 65                	ja     803b88 <__udivdi3+0x8c>
  803b23:	89 fd                	mov    %edi,%ebp
  803b25:	85 ff                	test   %edi,%edi
  803b27:	75 0b                	jne    803b34 <__udivdi3+0x38>
  803b29:	b8 01 00 00 00       	mov    $0x1,%eax
  803b2e:	31 d2                	xor    %edx,%edx
  803b30:	f7 f7                	div    %edi
  803b32:	89 c5                	mov    %eax,%ebp
  803b34:	31 d2                	xor    %edx,%edx
  803b36:	89 c8                	mov    %ecx,%eax
  803b38:	f7 f5                	div    %ebp
  803b3a:	89 c1                	mov    %eax,%ecx
  803b3c:	89 d8                	mov    %ebx,%eax
  803b3e:	f7 f5                	div    %ebp
  803b40:	89 cf                	mov    %ecx,%edi
  803b42:	89 fa                	mov    %edi,%edx
  803b44:	83 c4 1c             	add    $0x1c,%esp
  803b47:	5b                   	pop    %ebx
  803b48:	5e                   	pop    %esi
  803b49:	5f                   	pop    %edi
  803b4a:	5d                   	pop    %ebp
  803b4b:	c3                   	ret    
  803b4c:	39 ce                	cmp    %ecx,%esi
  803b4e:	77 28                	ja     803b78 <__udivdi3+0x7c>
  803b50:	0f bd fe             	bsr    %esi,%edi
  803b53:	83 f7 1f             	xor    $0x1f,%edi
  803b56:	75 40                	jne    803b98 <__udivdi3+0x9c>
  803b58:	39 ce                	cmp    %ecx,%esi
  803b5a:	72 0a                	jb     803b66 <__udivdi3+0x6a>
  803b5c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b60:	0f 87 9e 00 00 00    	ja     803c04 <__udivdi3+0x108>
  803b66:	b8 01 00 00 00       	mov    $0x1,%eax
  803b6b:	89 fa                	mov    %edi,%edx
  803b6d:	83 c4 1c             	add    $0x1c,%esp
  803b70:	5b                   	pop    %ebx
  803b71:	5e                   	pop    %esi
  803b72:	5f                   	pop    %edi
  803b73:	5d                   	pop    %ebp
  803b74:	c3                   	ret    
  803b75:	8d 76 00             	lea    0x0(%esi),%esi
  803b78:	31 ff                	xor    %edi,%edi
  803b7a:	31 c0                	xor    %eax,%eax
  803b7c:	89 fa                	mov    %edi,%edx
  803b7e:	83 c4 1c             	add    $0x1c,%esp
  803b81:	5b                   	pop    %ebx
  803b82:	5e                   	pop    %esi
  803b83:	5f                   	pop    %edi
  803b84:	5d                   	pop    %ebp
  803b85:	c3                   	ret    
  803b86:	66 90                	xchg   %ax,%ax
  803b88:	89 d8                	mov    %ebx,%eax
  803b8a:	f7 f7                	div    %edi
  803b8c:	31 ff                	xor    %edi,%edi
  803b8e:	89 fa                	mov    %edi,%edx
  803b90:	83 c4 1c             	add    $0x1c,%esp
  803b93:	5b                   	pop    %ebx
  803b94:	5e                   	pop    %esi
  803b95:	5f                   	pop    %edi
  803b96:	5d                   	pop    %ebp
  803b97:	c3                   	ret    
  803b98:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b9d:	89 eb                	mov    %ebp,%ebx
  803b9f:	29 fb                	sub    %edi,%ebx
  803ba1:	89 f9                	mov    %edi,%ecx
  803ba3:	d3 e6                	shl    %cl,%esi
  803ba5:	89 c5                	mov    %eax,%ebp
  803ba7:	88 d9                	mov    %bl,%cl
  803ba9:	d3 ed                	shr    %cl,%ebp
  803bab:	89 e9                	mov    %ebp,%ecx
  803bad:	09 f1                	or     %esi,%ecx
  803baf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bb3:	89 f9                	mov    %edi,%ecx
  803bb5:	d3 e0                	shl    %cl,%eax
  803bb7:	89 c5                	mov    %eax,%ebp
  803bb9:	89 d6                	mov    %edx,%esi
  803bbb:	88 d9                	mov    %bl,%cl
  803bbd:	d3 ee                	shr    %cl,%esi
  803bbf:	89 f9                	mov    %edi,%ecx
  803bc1:	d3 e2                	shl    %cl,%edx
  803bc3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bc7:	88 d9                	mov    %bl,%cl
  803bc9:	d3 e8                	shr    %cl,%eax
  803bcb:	09 c2                	or     %eax,%edx
  803bcd:	89 d0                	mov    %edx,%eax
  803bcf:	89 f2                	mov    %esi,%edx
  803bd1:	f7 74 24 0c          	divl   0xc(%esp)
  803bd5:	89 d6                	mov    %edx,%esi
  803bd7:	89 c3                	mov    %eax,%ebx
  803bd9:	f7 e5                	mul    %ebp
  803bdb:	39 d6                	cmp    %edx,%esi
  803bdd:	72 19                	jb     803bf8 <__udivdi3+0xfc>
  803bdf:	74 0b                	je     803bec <__udivdi3+0xf0>
  803be1:	89 d8                	mov    %ebx,%eax
  803be3:	31 ff                	xor    %edi,%edi
  803be5:	e9 58 ff ff ff       	jmp    803b42 <__udivdi3+0x46>
  803bea:	66 90                	xchg   %ax,%ax
  803bec:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bf0:	89 f9                	mov    %edi,%ecx
  803bf2:	d3 e2                	shl    %cl,%edx
  803bf4:	39 c2                	cmp    %eax,%edx
  803bf6:	73 e9                	jae    803be1 <__udivdi3+0xe5>
  803bf8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bfb:	31 ff                	xor    %edi,%edi
  803bfd:	e9 40 ff ff ff       	jmp    803b42 <__udivdi3+0x46>
  803c02:	66 90                	xchg   %ax,%ax
  803c04:	31 c0                	xor    %eax,%eax
  803c06:	e9 37 ff ff ff       	jmp    803b42 <__udivdi3+0x46>
  803c0b:	90                   	nop

00803c0c <__umoddi3>:
  803c0c:	55                   	push   %ebp
  803c0d:	57                   	push   %edi
  803c0e:	56                   	push   %esi
  803c0f:	53                   	push   %ebx
  803c10:	83 ec 1c             	sub    $0x1c,%esp
  803c13:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c17:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c1f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c27:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c2b:	89 f3                	mov    %esi,%ebx
  803c2d:	89 fa                	mov    %edi,%edx
  803c2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c33:	89 34 24             	mov    %esi,(%esp)
  803c36:	85 c0                	test   %eax,%eax
  803c38:	75 1a                	jne    803c54 <__umoddi3+0x48>
  803c3a:	39 f7                	cmp    %esi,%edi
  803c3c:	0f 86 a2 00 00 00    	jbe    803ce4 <__umoddi3+0xd8>
  803c42:	89 c8                	mov    %ecx,%eax
  803c44:	89 f2                	mov    %esi,%edx
  803c46:	f7 f7                	div    %edi
  803c48:	89 d0                	mov    %edx,%eax
  803c4a:	31 d2                	xor    %edx,%edx
  803c4c:	83 c4 1c             	add    $0x1c,%esp
  803c4f:	5b                   	pop    %ebx
  803c50:	5e                   	pop    %esi
  803c51:	5f                   	pop    %edi
  803c52:	5d                   	pop    %ebp
  803c53:	c3                   	ret    
  803c54:	39 f0                	cmp    %esi,%eax
  803c56:	0f 87 ac 00 00 00    	ja     803d08 <__umoddi3+0xfc>
  803c5c:	0f bd e8             	bsr    %eax,%ebp
  803c5f:	83 f5 1f             	xor    $0x1f,%ebp
  803c62:	0f 84 ac 00 00 00    	je     803d14 <__umoddi3+0x108>
  803c68:	bf 20 00 00 00       	mov    $0x20,%edi
  803c6d:	29 ef                	sub    %ebp,%edi
  803c6f:	89 fe                	mov    %edi,%esi
  803c71:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c75:	89 e9                	mov    %ebp,%ecx
  803c77:	d3 e0                	shl    %cl,%eax
  803c79:	89 d7                	mov    %edx,%edi
  803c7b:	89 f1                	mov    %esi,%ecx
  803c7d:	d3 ef                	shr    %cl,%edi
  803c7f:	09 c7                	or     %eax,%edi
  803c81:	89 e9                	mov    %ebp,%ecx
  803c83:	d3 e2                	shl    %cl,%edx
  803c85:	89 14 24             	mov    %edx,(%esp)
  803c88:	89 d8                	mov    %ebx,%eax
  803c8a:	d3 e0                	shl    %cl,%eax
  803c8c:	89 c2                	mov    %eax,%edx
  803c8e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c92:	d3 e0                	shl    %cl,%eax
  803c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c98:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c9c:	89 f1                	mov    %esi,%ecx
  803c9e:	d3 e8                	shr    %cl,%eax
  803ca0:	09 d0                	or     %edx,%eax
  803ca2:	d3 eb                	shr    %cl,%ebx
  803ca4:	89 da                	mov    %ebx,%edx
  803ca6:	f7 f7                	div    %edi
  803ca8:	89 d3                	mov    %edx,%ebx
  803caa:	f7 24 24             	mull   (%esp)
  803cad:	89 c6                	mov    %eax,%esi
  803caf:	89 d1                	mov    %edx,%ecx
  803cb1:	39 d3                	cmp    %edx,%ebx
  803cb3:	0f 82 87 00 00 00    	jb     803d40 <__umoddi3+0x134>
  803cb9:	0f 84 91 00 00 00    	je     803d50 <__umoddi3+0x144>
  803cbf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cc3:	29 f2                	sub    %esi,%edx
  803cc5:	19 cb                	sbb    %ecx,%ebx
  803cc7:	89 d8                	mov    %ebx,%eax
  803cc9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ccd:	d3 e0                	shl    %cl,%eax
  803ccf:	89 e9                	mov    %ebp,%ecx
  803cd1:	d3 ea                	shr    %cl,%edx
  803cd3:	09 d0                	or     %edx,%eax
  803cd5:	89 e9                	mov    %ebp,%ecx
  803cd7:	d3 eb                	shr    %cl,%ebx
  803cd9:	89 da                	mov    %ebx,%edx
  803cdb:	83 c4 1c             	add    $0x1c,%esp
  803cde:	5b                   	pop    %ebx
  803cdf:	5e                   	pop    %esi
  803ce0:	5f                   	pop    %edi
  803ce1:	5d                   	pop    %ebp
  803ce2:	c3                   	ret    
  803ce3:	90                   	nop
  803ce4:	89 fd                	mov    %edi,%ebp
  803ce6:	85 ff                	test   %edi,%edi
  803ce8:	75 0b                	jne    803cf5 <__umoddi3+0xe9>
  803cea:	b8 01 00 00 00       	mov    $0x1,%eax
  803cef:	31 d2                	xor    %edx,%edx
  803cf1:	f7 f7                	div    %edi
  803cf3:	89 c5                	mov    %eax,%ebp
  803cf5:	89 f0                	mov    %esi,%eax
  803cf7:	31 d2                	xor    %edx,%edx
  803cf9:	f7 f5                	div    %ebp
  803cfb:	89 c8                	mov    %ecx,%eax
  803cfd:	f7 f5                	div    %ebp
  803cff:	89 d0                	mov    %edx,%eax
  803d01:	e9 44 ff ff ff       	jmp    803c4a <__umoddi3+0x3e>
  803d06:	66 90                	xchg   %ax,%ax
  803d08:	89 c8                	mov    %ecx,%eax
  803d0a:	89 f2                	mov    %esi,%edx
  803d0c:	83 c4 1c             	add    $0x1c,%esp
  803d0f:	5b                   	pop    %ebx
  803d10:	5e                   	pop    %esi
  803d11:	5f                   	pop    %edi
  803d12:	5d                   	pop    %ebp
  803d13:	c3                   	ret    
  803d14:	3b 04 24             	cmp    (%esp),%eax
  803d17:	72 06                	jb     803d1f <__umoddi3+0x113>
  803d19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d1d:	77 0f                	ja     803d2e <__umoddi3+0x122>
  803d1f:	89 f2                	mov    %esi,%edx
  803d21:	29 f9                	sub    %edi,%ecx
  803d23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d27:	89 14 24             	mov    %edx,(%esp)
  803d2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d32:	8b 14 24             	mov    (%esp),%edx
  803d35:	83 c4 1c             	add    $0x1c,%esp
  803d38:	5b                   	pop    %ebx
  803d39:	5e                   	pop    %esi
  803d3a:	5f                   	pop    %edi
  803d3b:	5d                   	pop    %ebp
  803d3c:	c3                   	ret    
  803d3d:	8d 76 00             	lea    0x0(%esi),%esi
  803d40:	2b 04 24             	sub    (%esp),%eax
  803d43:	19 fa                	sbb    %edi,%edx
  803d45:	89 d1                	mov    %edx,%ecx
  803d47:	89 c6                	mov    %eax,%esi
  803d49:	e9 71 ff ff ff       	jmp    803cbf <__umoddi3+0xb3>
  803d4e:	66 90                	xchg   %ax,%ax
  803d50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d54:	72 ea                	jb     803d40 <__umoddi3+0x134>
  803d56:	89 d9                	mov    %ebx,%ecx
  803d58:	e9 62 ff ff ff       	jmp    803cbf <__umoddi3+0xb3>
