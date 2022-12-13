
obj/user/tst_first_fit_2:     file format elf32-i386


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
  800031:	e8 4a 06 00 00       	call   800680 <libmain>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 98 21 00 00       	call   8021e2 <sys_set_uheap_strategy>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

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
  80009b:	68 00 3b 80 00       	push   $0x803b00
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 1c 3b 80 00       	push   $0x803b1c
  8000a7:	e8 10 07 00 00       	call   8007bc <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 42 19 00 00       	call   8019f8 <malloc>
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
  8000e0:	e8 13 19 00 00       	call   8019f8 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 34 3b 80 00       	push   $0x803b34
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 1c 3b 80 00       	push   $0x803b1c
  800101:	e8 b6 06 00 00       	call   8007bc <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 c2 1b 00 00       	call   801ccd <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 5a 1c 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 d1 18 00 00       	call   8019f8 <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 78 3b 80 00       	push   $0x803b78
  80013f:	6a 31                	push   $0x31
  800141:	68 1c 3b 80 00       	push   $0x803b1c
  800146:	e8 71 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014b:	e8 1d 1c 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  800150:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 a8 3b 80 00       	push   $0x803ba8
  80015d:	6a 33                	push   $0x33
  80015f:	68 1c 3b 80 00       	push   $0x803b1c
  800164:	e8 53 06 00 00       	call   8007bc <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 5f 1b 00 00       	call   801ccd <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 f7 1b 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	01 c0                	add    %eax,%eax
  80017e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	50                   	push   %eax
  800185:	e8 6e 18 00 00       	call   8019f8 <malloc>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800190:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800193:	89 c2                	mov    %eax,%edx
  800195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	05 00 00 00 80       	add    $0x80000000,%eax
  80019f:	39 c2                	cmp    %eax,%edx
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 78 3b 80 00       	push   $0x803b78
  8001ab:	6a 39                	push   $0x39
  8001ad:	68 1c 3b 80 00       	push   $0x803b1c
  8001b2:	e8 05 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b7:	e8 b1 1b 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  8001bc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 a8 3b 80 00       	push   $0x803ba8
  8001c9:	6a 3b                	push   $0x3b
  8001cb:	68 1c 3b 80 00       	push   $0x803b1c
  8001d0:	e8 e7 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001d5:	e8 f3 1a 00 00       	call   801ccd <sys_calculate_free_frames>
  8001da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001dd:	e8 8b 1b 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  8001e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  8001e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001e8:	89 c2                	mov    %eax,%edx
  8001ea:	01 d2                	add    %edx,%edx
  8001ec:	01 d0                	add    %edx,%eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	e8 01 18 00 00       	call   8019f8 <malloc>
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8001fd:	8b 45 98             	mov    -0x68(%ebp),%eax
  800200:	89 c2                	mov    %eax,%edx
  800202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800205:	c1 e0 02             	shl    $0x2,%eax
  800208:	05 00 00 00 80       	add    $0x80000000,%eax
  80020d:	39 c2                	cmp    %eax,%edx
  80020f:	74 14                	je     800225 <_main+0x1ed>
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	68 78 3b 80 00       	push   $0x803b78
  800219:	6a 41                	push   $0x41
  80021b:	68 1c 3b 80 00       	push   $0x803b1c
  800220:	e8 97 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800225:	e8 43 1b 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  80022a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 a8 3b 80 00       	push   $0x803ba8
  800237:	6a 43                	push   $0x43
  800239:	68 1c 3b 80 00       	push   $0x803b1c
  80023e:	e8 79 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  800243:	e8 85 1a 00 00       	call   801ccd <sys_calculate_free_frames>
  800248:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80024b:	e8 1d 1b 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  800250:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	50                   	push   %eax
  800260:	e8 93 17 00 00       	call   8019f8 <malloc>
  800265:	83 c4 10             	add    $0x10,%esp
  800268:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  80026b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80026e:	89 c2                	mov    %eax,%edx
  800270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800273:	c1 e0 02             	shl    $0x2,%eax
  800276:	89 c1                	mov    %eax,%ecx
  800278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027b:	c1 e0 02             	shl    $0x2,%eax
  80027e:	01 c8                	add    %ecx,%eax
  800280:	05 00 00 00 80       	add    $0x80000000,%eax
  800285:	39 c2                	cmp    %eax,%edx
  800287:	74 14                	je     80029d <_main+0x265>
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	68 78 3b 80 00       	push   $0x803b78
  800291:	6a 49                	push   $0x49
  800293:	68 1c 3b 80 00       	push   $0x803b1c
  800298:	e8 1f 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80029d:	e8 cb 1a 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  8002a2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a5:	74 14                	je     8002bb <_main+0x283>
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	68 a8 3b 80 00       	push   $0x803ba8
  8002af:	6a 4b                	push   $0x4b
  8002b1:	68 1c 3b 80 00       	push   $0x803b1c
  8002b6:	e8 01 05 00 00       	call   8007bc <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002bb:	e8 0d 1a 00 00       	call   801ccd <sys_calculate_free_frames>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c3:	e8 a5 1a 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  8002c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002cb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	50                   	push   %eax
  8002d2:	e8 9c 17 00 00       	call   801a73 <free>
  8002d7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8002da:	e8 8e 1a 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  8002df:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002e2:	74 14                	je     8002f8 <_main+0x2c0>
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	68 c5 3b 80 00       	push   $0x803bc5
  8002ec:	6a 52                	push   $0x52
  8002ee:	68 1c 3b 80 00       	push   $0x803b1c
  8002f3:	e8 c4 04 00 00       	call   8007bc <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002f8:	e8 d0 19 00 00       	call   801ccd <sys_calculate_free_frames>
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800300:	e8 68 1a 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  800305:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800308:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80030b:	89 d0                	mov    %edx,%eax
  80030d:	01 c0                	add    %eax,%eax
  80030f:	01 d0                	add    %edx,%eax
  800311:	01 c0                	add    %eax,%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	50                   	push   %eax
  800319:	e8 da 16 00 00       	call   8019f8 <malloc>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800324:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800327:	89 c2                	mov    %eax,%edx
  800329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032c:	c1 e0 02             	shl    $0x2,%eax
  80032f:	89 c1                	mov    %eax,%ecx
  800331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800334:	c1 e0 03             	shl    $0x3,%eax
  800337:	01 c8                	add    %ecx,%eax
  800339:	05 00 00 00 80       	add    $0x80000000,%eax
  80033e:	39 c2                	cmp    %eax,%edx
  800340:	74 14                	je     800356 <_main+0x31e>
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	68 78 3b 80 00       	push   $0x803b78
  80034a:	6a 58                	push   $0x58
  80034c:	68 1c 3b 80 00       	push   $0x803b1c
  800351:	e8 66 04 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800356:	e8 12 1a 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  80035b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80035e:	74 14                	je     800374 <_main+0x33c>
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	68 a8 3b 80 00       	push   $0x803ba8
  800368:	6a 5a                	push   $0x5a
  80036a:	68 1c 3b 80 00       	push   $0x803b1c
  80036f:	e8 48 04 00 00       	call   8007bc <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800374:	e8 54 19 00 00       	call   801ccd <sys_calculate_free_frames>
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037c:	e8 ec 19 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800384:	8b 45 90             	mov    -0x70(%ebp),%eax
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	50                   	push   %eax
  80038b:	e8 e3 16 00 00       	call   801a73 <free>
  800390:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  800393:	e8 d5 19 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  800398:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80039b:	74 14                	je     8003b1 <_main+0x379>
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 c5 3b 80 00       	push   $0x803bc5
  8003a5:	6a 61                	push   $0x61
  8003a7:	68 1c 3b 80 00       	push   $0x803b1c
  8003ac:	e8 0b 04 00 00       	call   8007bc <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003b1:	e8 17 19 00 00       	call   801ccd <sys_calculate_free_frames>
  8003b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003b9:	e8 af 19 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  8003be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003c4:	89 c2                	mov    %eax,%edx
  8003c6:	01 d2                	add    %edx,%edx
  8003c8:	01 d0                	add    %edx,%eax
  8003ca:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003cd:	83 ec 0c             	sub    $0xc,%esp
  8003d0:	50                   	push   %eax
  8003d1:	e8 22 16 00 00       	call   8019f8 <malloc>
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003dc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e4:	c1 e0 02             	shl    $0x2,%eax
  8003e7:	89 c1                	mov    %eax,%ecx
  8003e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ec:	c1 e0 04             	shl    $0x4,%eax
  8003ef:	01 c8                	add    %ecx,%eax
  8003f1:	05 00 00 00 80       	add    $0x80000000,%eax
  8003f6:	39 c2                	cmp    %eax,%edx
  8003f8:	74 14                	je     80040e <_main+0x3d6>
  8003fa:	83 ec 04             	sub    $0x4,%esp
  8003fd:	68 78 3b 80 00       	push   $0x803b78
  800402:	6a 67                	push   $0x67
  800404:	68 1c 3b 80 00       	push   $0x803b1c
  800409:	e8 ae 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80040e:	e8 5a 19 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  800413:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800416:	74 14                	je     80042c <_main+0x3f4>
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	68 a8 3b 80 00       	push   $0x803ba8
  800420:	6a 69                	push   $0x69
  800422:	68 1c 3b 80 00       	push   $0x803b1c
  800427:	e8 90 03 00 00       	call   8007bc <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  80042c:	e8 9c 18 00 00       	call   801ccd <sys_calculate_free_frames>
  800431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800434:	e8 34 19 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  800439:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  80043c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043f:	89 c2                	mov    %eax,%edx
  800441:	01 d2                	add    %edx,%edx
  800443:	01 c2                	add    %eax,%edx
  800445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800448:	01 d0                	add    %edx,%eax
  80044a:	01 c0                	add    %eax,%eax
  80044c:	83 ec 0c             	sub    $0xc,%esp
  80044f:	50                   	push   %eax
  800450:	e8 a3 15 00 00       	call   8019f8 <malloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80045b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	89 c2                	mov    %eax,%edx
  80046f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800472:	c1 e0 04             	shl    $0x4,%eax
  800475:	01 d0                	add    %edx,%eax
  800477:	05 00 00 00 80       	add    $0x80000000,%eax
  80047c:	39 c1                	cmp    %eax,%ecx
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 78 3b 80 00       	push   $0x803b78
  800488:	6a 6f                	push   $0x6f
  80048a:	68 1c 3b 80 00       	push   $0x803b1c
  80048f:	e8 28 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800494:	e8 d4 18 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  800499:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80049c:	74 14                	je     8004b2 <_main+0x47a>
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	68 a8 3b 80 00       	push   $0x803ba8
  8004a6:	6a 71                	push   $0x71
  8004a8:	68 1c 3b 80 00       	push   $0x803b1c
  8004ad:	e8 0a 03 00 00       	call   8007bc <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004b2:	e8 16 18 00 00       	call   801ccd <sys_calculate_free_frames>
  8004b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004ba:	e8 ae 18 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  8004bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  8004c2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	50                   	push   %eax
  8004c9:	e8 a5 15 00 00       	call   801a73 <free>
  8004ce:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8004d1:	e8 97 18 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  8004d6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d9:	74 14                	je     8004ef <_main+0x4b7>
  8004db:	83 ec 04             	sub    $0x4,%esp
  8004de:	68 c5 3b 80 00       	push   $0x803bc5
  8004e3:	6a 78                	push   $0x78
  8004e5:	68 1c 3b 80 00       	push   $0x803b1c
  8004ea:	e8 cd 02 00 00       	call   8007bc <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 d9 17 00 00       	call   801ccd <sys_calculate_free_frames>
  8004f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 71 18 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8004ff:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	50                   	push   %eax
  800506:	e8 68 15 00 00       	call   801a73 <free>
  80050b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  80050e:	e8 5a 18 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  800513:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 c5 3b 80 00       	push   $0x803bc5
  800520:	6a 7f                	push   $0x7f
  800522:	68 1c 3b 80 00       	push   $0x803b1c
  800527:	e8 90 02 00 00       	call   8007bc <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 9c 17 00 00       	call   801ccd <sys_calculate_free_frames>
  800531:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800534:	e8 34 18 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  800539:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  80053c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	c1 e0 02             	shl    $0x2,%eax
  800544:	01 d0                	add    %edx,%eax
  800546:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800549:	83 ec 0c             	sub    $0xc,%esp
  80054c:	50                   	push   %eax
  80054d:	e8 a6 14 00 00       	call   8019f8 <malloc>
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800558:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 03             	shl    $0x3,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	89 c3                	mov    %eax,%ebx
  800569:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80056c:	89 d0                	mov    %edx,%eax
  80056e:	01 c0                	add    %eax,%eax
  800570:	01 d0                	add    %edx,%eax
  800572:	c1 e0 03             	shl    $0x3,%eax
  800575:	01 d8                	add    %ebx,%eax
  800577:	05 00 00 00 80       	add    $0x80000000,%eax
  80057c:	39 c1                	cmp    %eax,%ecx
  80057e:	74 17                	je     800597 <_main+0x55f>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 78 3b 80 00       	push   $0x803b78
  800588:	68 85 00 00 00       	push   $0x85
  80058d:	68 1c 3b 80 00       	push   $0x803b1c
  800592:	e8 25 02 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800597:	e8 d1 17 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  80059c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059f:	74 17                	je     8005b8 <_main+0x580>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 a8 3b 80 00       	push   $0x803ba8
  8005a9:	68 87 00 00 00       	push   $0x87
  8005ae:	68 1c 3b 80 00       	push   $0x803b1c
  8005b3:	e8 04 02 00 00       	call   8007bc <_panic>
		//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8005b8:	e8 10 17 00 00       	call   801ccd <sys_calculate_free_frames>
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005c0:	e8 a8 17 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  8005c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(3*Mega-kilo);
  8005c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cb:	89 c2                	mov    %eax,%edx
  8005cd:	01 d2                	add    %edx,%edx
  8005cf:	01 d0                	add    %edx,%eax
  8005d1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8005d4:	83 ec 0c             	sub    $0xc,%esp
  8005d7:	50                   	push   %eax
  8005d8:	e8 1b 14 00 00       	call   8019f8 <malloc>
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8005e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005e6:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8005eb:	74 17                	je     800604 <_main+0x5cc>
  8005ed:	83 ec 04             	sub    $0x4,%esp
  8005f0:	68 78 3b 80 00       	push   $0x803b78
  8005f5:	68 95 00 00 00       	push   $0x95
  8005fa:	68 1c 3b 80 00       	push   $0x803b1c
  8005ff:	e8 b8 01 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800604:	e8 64 17 00 00       	call   801d6d <sys_pf_calculate_allocated_pages>
  800609:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80060c:	74 17                	je     800625 <_main+0x5ed>
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	68 a8 3b 80 00       	push   $0x803ba8
  800616:	68 97 00 00 00       	push   $0x97
  80061b:	68 1c 3b 80 00       	push   $0x803b1c
  800620:	e8 97 01 00 00       	call   8007bc <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800625:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800628:	89 d0                	mov    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	01 d0                	add    %edx,%eax
  800632:	01 c0                	add    %eax,%eax
  800634:	f7 d8                	neg    %eax
  800636:	05 00 00 00 20       	add    $0x20000000,%eax
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	50                   	push   %eax
  80063f:	e8 b4 13 00 00       	call   8019f8 <malloc>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  80064a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80064d:	85 c0                	test   %eax,%eax
  80064f:	74 17                	je     800668 <_main+0x630>
  800651:	83 ec 04             	sub    $0x4,%esp
  800654:	68 dc 3b 80 00       	push   $0x803bdc
  800659:	68 a0 00 00 00       	push   $0xa0
  80065e:	68 1c 3b 80 00       	push   $0x803b1c
  800663:	e8 54 01 00 00       	call   8007bc <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	68 40 3c 80 00       	push   $0x803c40
  800670:	e8 fb 03 00 00       	call   800a70 <cprintf>
  800675:	83 c4 10             	add    $0x10,%esp

		return;
  800678:	90                   	nop
	}
}
  800679:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80067c:	5b                   	pop    %ebx
  80067d:	5f                   	pop    %edi
  80067e:	5d                   	pop    %ebp
  80067f:	c3                   	ret    

00800680 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800680:	55                   	push   %ebp
  800681:	89 e5                	mov    %esp,%ebp
  800683:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800686:	e8 22 19 00 00       	call   801fad <sys_getenvindex>
  80068b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80068e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800691:	89 d0                	mov    %edx,%eax
  800693:	c1 e0 03             	shl    $0x3,%eax
  800696:	01 d0                	add    %edx,%eax
  800698:	01 c0                	add    %eax,%eax
  80069a:	01 d0                	add    %edx,%eax
  80069c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a3:	01 d0                	add    %edx,%eax
  8006a5:	c1 e0 04             	shl    $0x4,%eax
  8006a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006ad:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b7:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8006bd:	84 c0                	test   %al,%al
  8006bf:	74 0f                	je     8006d0 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	05 5c 05 00 00       	add    $0x55c,%eax
  8006cb:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006d4:	7e 0a                	jle    8006e0 <libmain+0x60>
		binaryname = argv[0];
  8006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 4a f9 ff ff       	call   800038 <_main>
  8006ee:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006f1:	e8 c4 16 00 00       	call   801dba <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	68 a4 3c 80 00       	push   $0x803ca4
  8006fe:	e8 6d 03 00 00       	call   800a70 <cprintf>
  800703:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800706:	a1 20 50 80 00       	mov    0x805020,%eax
  80070b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800711:	a1 20 50 80 00       	mov    0x805020,%eax
  800716:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80071c:	83 ec 04             	sub    $0x4,%esp
  80071f:	52                   	push   %edx
  800720:	50                   	push   %eax
  800721:	68 cc 3c 80 00       	push   $0x803ccc
  800726:	e8 45 03 00 00       	call   800a70 <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80072e:	a1 20 50 80 00       	mov    0x805020,%eax
  800733:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800739:	a1 20 50 80 00       	mov    0x805020,%eax
  80073e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800744:	a1 20 50 80 00       	mov    0x805020,%eax
  800749:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80074f:	51                   	push   %ecx
  800750:	52                   	push   %edx
  800751:	50                   	push   %eax
  800752:	68 f4 3c 80 00       	push   $0x803cf4
  800757:	e8 14 03 00 00       	call   800a70 <cprintf>
  80075c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80075f:	a1 20 50 80 00       	mov    0x805020,%eax
  800764:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	50                   	push   %eax
  80076e:	68 4c 3d 80 00       	push   $0x803d4c
  800773:	e8 f8 02 00 00       	call   800a70 <cprintf>
  800778:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	68 a4 3c 80 00       	push   $0x803ca4
  800783:	e8 e8 02 00 00       	call   800a70 <cprintf>
  800788:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80078b:	e8 44 16 00 00       	call   801dd4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800790:	e8 19 00 00 00       	call   8007ae <exit>
}
  800795:	90                   	nop
  800796:	c9                   	leave  
  800797:	c3                   	ret    

00800798 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80079e:	83 ec 0c             	sub    $0xc,%esp
  8007a1:	6a 00                	push   $0x0
  8007a3:	e8 d1 17 00 00       	call   801f79 <sys_destroy_env>
  8007a8:	83 c4 10             	add    $0x10,%esp
}
  8007ab:	90                   	nop
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <exit>:

void
exit(void)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007b4:	e8 26 18 00 00       	call   801fdf <sys_exit_env>
}
  8007b9:	90                   	nop
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007cb:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	74 16                	je     8007ea <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007d4:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	50                   	push   %eax
  8007dd:	68 60 3d 80 00       	push   $0x803d60
  8007e2:	e8 89 02 00 00       	call   800a70 <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ea:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	50                   	push   %eax
  8007f6:	68 65 3d 80 00       	push   $0x803d65
  8007fb:	e8 70 02 00 00       	call   800a70 <cprintf>
  800800:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800803:	8b 45 10             	mov    0x10(%ebp),%eax
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 f4             	pushl  -0xc(%ebp)
  80080c:	50                   	push   %eax
  80080d:	e8 f3 01 00 00       	call   800a05 <vcprintf>
  800812:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	6a 00                	push   $0x0
  80081a:	68 81 3d 80 00       	push   $0x803d81
  80081f:	e8 e1 01 00 00       	call   800a05 <vcprintf>
  800824:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800827:	e8 82 ff ff ff       	call   8007ae <exit>

	// should not return here
	while (1) ;
  80082c:	eb fe                	jmp    80082c <_panic+0x70>

0080082e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800834:	a1 20 50 80 00       	mov    0x805020,%eax
  800839:	8b 50 74             	mov    0x74(%eax),%edx
  80083c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083f:	39 c2                	cmp    %eax,%edx
  800841:	74 14                	je     800857 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800843:	83 ec 04             	sub    $0x4,%esp
  800846:	68 84 3d 80 00       	push   $0x803d84
  80084b:	6a 26                	push   $0x26
  80084d:	68 d0 3d 80 00       	push   $0x803dd0
  800852:	e8 65 ff ff ff       	call   8007bc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800857:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80085e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800865:	e9 c2 00 00 00       	jmp    80092c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80086a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	01 d0                	add    %edx,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	85 c0                	test   %eax,%eax
  80087d:	75 08                	jne    800887 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80087f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800882:	e9 a2 00 00 00       	jmp    800929 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800887:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80088e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800895:	eb 69                	jmp    800900 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800897:	a1 20 50 80 00       	mov    0x805020,%eax
  80089c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a5:	89 d0                	mov    %edx,%eax
  8008a7:	01 c0                	add    %eax,%eax
  8008a9:	01 d0                	add    %edx,%eax
  8008ab:	c1 e0 03             	shl    $0x3,%eax
  8008ae:	01 c8                	add    %ecx,%eax
  8008b0:	8a 40 04             	mov    0x4(%eax),%al
  8008b3:	84 c0                	test   %al,%al
  8008b5:	75 46                	jne    8008fd <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b7:	a1 20 50 80 00       	mov    0x805020,%eax
  8008bc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c5:	89 d0                	mov    %edx,%eax
  8008c7:	01 c0                	add    %eax,%eax
  8008c9:	01 d0                	add    %edx,%eax
  8008cb:	c1 e0 03             	shl    $0x3,%eax
  8008ce:	01 c8                	add    %ecx,%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008dd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	01 c8                	add    %ecx,%eax
  8008ee:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	75 09                	jne    8008fd <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008f4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008fb:	eb 12                	jmp    80090f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008fd:	ff 45 e8             	incl   -0x18(%ebp)
  800900:	a1 20 50 80 00       	mov    0x805020,%eax
  800905:	8b 50 74             	mov    0x74(%eax),%edx
  800908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80090b:	39 c2                	cmp    %eax,%edx
  80090d:	77 88                	ja     800897 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80090f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800913:	75 14                	jne    800929 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	68 dc 3d 80 00       	push   $0x803ddc
  80091d:	6a 3a                	push   $0x3a
  80091f:	68 d0 3d 80 00       	push   $0x803dd0
  800924:	e8 93 fe ff ff       	call   8007bc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800929:	ff 45 f0             	incl   -0x10(%ebp)
  80092c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800932:	0f 8c 32 ff ff ff    	jl     80086a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800938:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80093f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800946:	eb 26                	jmp    80096e <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800948:	a1 20 50 80 00       	mov    0x805020,%eax
  80094d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800953:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800956:	89 d0                	mov    %edx,%eax
  800958:	01 c0                	add    %eax,%eax
  80095a:	01 d0                	add    %edx,%eax
  80095c:	c1 e0 03             	shl    $0x3,%eax
  80095f:	01 c8                	add    %ecx,%eax
  800961:	8a 40 04             	mov    0x4(%eax),%al
  800964:	3c 01                	cmp    $0x1,%al
  800966:	75 03                	jne    80096b <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800968:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096b:	ff 45 e0             	incl   -0x20(%ebp)
  80096e:	a1 20 50 80 00       	mov    0x805020,%eax
  800973:	8b 50 74             	mov    0x74(%eax),%edx
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	39 c2                	cmp    %eax,%edx
  80097b:	77 cb                	ja     800948 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80097d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800980:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800983:	74 14                	je     800999 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800985:	83 ec 04             	sub    $0x4,%esp
  800988:	68 30 3e 80 00       	push   $0x803e30
  80098d:	6a 44                	push   $0x44
  80098f:	68 d0 3d 80 00       	push   $0x803dd0
  800994:	e8 23 fe ff ff       	call   8007bc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800999:	90                   	nop
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 48 01             	lea    0x1(%eax),%ecx
  8009aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ad:	89 0a                	mov    %ecx,(%edx)
  8009af:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b2:	88 d1                	mov    %dl,%cl
  8009b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009c5:	75 2c                	jne    8009f3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009c7:	a0 24 50 80 00       	mov    0x805024,%al
  8009cc:	0f b6 c0             	movzbl %al,%eax
  8009cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d2:	8b 12                	mov    (%edx),%edx
  8009d4:	89 d1                	mov    %edx,%ecx
  8009d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d9:	83 c2 08             	add    $0x8,%edx
  8009dc:	83 ec 04             	sub    $0x4,%esp
  8009df:	50                   	push   %eax
  8009e0:	51                   	push   %ecx
  8009e1:	52                   	push   %edx
  8009e2:	e8 25 12 00 00       	call   801c0c <sys_cputs>
  8009e7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f6:	8b 40 04             	mov    0x4(%eax),%eax
  8009f9:	8d 50 01             	lea    0x1(%eax),%edx
  8009fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ff:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a02:	90                   	nop
  800a03:	c9                   	leave  
  800a04:	c3                   	ret    

00800a05 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a0e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a15:	00 00 00 
	b.cnt = 0;
  800a18:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a1f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	ff 75 08             	pushl  0x8(%ebp)
  800a28:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2e:	50                   	push   %eax
  800a2f:	68 9c 09 80 00       	push   $0x80099c
  800a34:	e8 11 02 00 00       	call   800c4a <vprintfmt>
  800a39:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a3c:	a0 24 50 80 00       	mov    0x805024,%al
  800a41:	0f b6 c0             	movzbl %al,%eax
  800a44:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a4a:	83 ec 04             	sub    $0x4,%esp
  800a4d:	50                   	push   %eax
  800a4e:	52                   	push   %edx
  800a4f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a55:	83 c0 08             	add    $0x8,%eax
  800a58:	50                   	push   %eax
  800a59:	e8 ae 11 00 00       	call   801c0c <sys_cputs>
  800a5e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a61:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a68:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a6e:	c9                   	leave  
  800a6f:	c3                   	ret    

00800a70 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a76:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a7d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	e8 73 ff ff ff       	call   800a05 <vcprintf>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800aa3:	e8 12 13 00 00       	call   801dba <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800aa8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab7:	50                   	push   %eax
  800ab8:	e8 48 ff ff ff       	call   800a05 <vcprintf>
  800abd:	83 c4 10             	add    $0x10,%esp
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ac3:	e8 0c 13 00 00       	call   801dd4 <sys_enable_interrupt>
	return cnt;
  800ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800acb:	c9                   	leave  
  800acc:	c3                   	ret    

00800acd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	53                   	push   %ebx
  800ad1:	83 ec 14             	sub    $0x14,%esp
  800ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ada:	8b 45 14             	mov    0x14(%ebp),%eax
  800add:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ae0:	8b 45 18             	mov    0x18(%ebp),%eax
  800ae3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aeb:	77 55                	ja     800b42 <printnum+0x75>
  800aed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800af0:	72 05                	jb     800af7 <printnum+0x2a>
  800af2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800af5:	77 4b                	ja     800b42 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800af7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800afa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800afd:	8b 45 18             	mov    0x18(%ebp),%eax
  800b00:	ba 00 00 00 00       	mov    $0x0,%edx
  800b05:	52                   	push   %edx
  800b06:	50                   	push   %eax
  800b07:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0a:	ff 75 f0             	pushl  -0x10(%ebp)
  800b0d:	e8 7e 2d 00 00       	call   803890 <__udivdi3>
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	83 ec 04             	sub    $0x4,%esp
  800b18:	ff 75 20             	pushl  0x20(%ebp)
  800b1b:	53                   	push   %ebx
  800b1c:	ff 75 18             	pushl  0x18(%ebp)
  800b1f:	52                   	push   %edx
  800b20:	50                   	push   %eax
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	ff 75 08             	pushl  0x8(%ebp)
  800b27:	e8 a1 ff ff ff       	call   800acd <printnum>
  800b2c:	83 c4 20             	add    $0x20,%esp
  800b2f:	eb 1a                	jmp    800b4b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	ff 75 20             	pushl  0x20(%ebp)
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b42:	ff 4d 1c             	decl   0x1c(%ebp)
  800b45:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b49:	7f e6                	jg     800b31 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b4b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b59:	53                   	push   %ebx
  800b5a:	51                   	push   %ecx
  800b5b:	52                   	push   %edx
  800b5c:	50                   	push   %eax
  800b5d:	e8 3e 2e 00 00       	call   8039a0 <__umoddi3>
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	05 94 40 80 00       	add    $0x804094,%eax
  800b6a:	8a 00                	mov    (%eax),%al
  800b6c:	0f be c0             	movsbl %al,%eax
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	50                   	push   %eax
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
}
  800b7e:	90                   	nop
  800b7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b87:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8b:	7e 1c                	jle    800ba9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	8d 50 08             	lea    0x8(%eax),%edx
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	89 10                	mov    %edx,(%eax)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	83 e8 08             	sub    $0x8,%eax
  800ba2:	8b 50 04             	mov    0x4(%eax),%edx
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	eb 40                	jmp    800be9 <getuint+0x65>
	else if (lflag)
  800ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bad:	74 1e                	je     800bcd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	8d 50 04             	lea    0x4(%eax),%edx
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	89 10                	mov    %edx,(%eax)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	83 e8 04             	sub    $0x4,%eax
  800bc4:	8b 00                	mov    (%eax),%eax
  800bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcb:	eb 1c                	jmp    800be9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	8d 50 04             	lea    0x4(%eax),%edx
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 10                	mov    %edx,(%eax)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	83 e8 04             	sub    $0x4,%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bee:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bf2:	7e 1c                	jle    800c10 <getint+0x25>
		return va_arg(*ap, long long);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	8d 50 08             	lea    0x8(%eax),%edx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 10                	mov    %edx,(%eax)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	83 e8 08             	sub    $0x8,%eax
  800c09:	8b 50 04             	mov    0x4(%eax),%edx
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	eb 38                	jmp    800c48 <getint+0x5d>
	else if (lflag)
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	74 1a                	je     800c30 <getint+0x45>
		return va_arg(*ap, long);
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8b 00                	mov    (%eax),%eax
  800c1b:	8d 50 04             	lea    0x4(%eax),%edx
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	89 10                	mov    %edx,(%eax)
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8b 00                	mov    (%eax),%eax
  800c28:	83 e8 04             	sub    $0x4,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	99                   	cltd   
  800c2e:	eb 18                	jmp    800c48 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	8d 50 04             	lea    0x4(%eax),%edx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 10                	mov    %edx,(%eax)
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8b 00                	mov    (%eax),%eax
  800c42:	83 e8 04             	sub    $0x4,%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	99                   	cltd   
}
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c52:	eb 17                	jmp    800c6b <vprintfmt+0x21>
			if (ch == '\0')
  800c54:	85 db                	test   %ebx,%ebx
  800c56:	0f 84 af 03 00 00    	je     80100b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c5c:	83 ec 08             	sub    $0x8,%esp
  800c5f:	ff 75 0c             	pushl  0xc(%ebp)
  800c62:	53                   	push   %ebx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6e:	8d 50 01             	lea    0x1(%eax),%edx
  800c71:	89 55 10             	mov    %edx,0x10(%ebp)
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	0f b6 d8             	movzbl %al,%ebx
  800c79:	83 fb 25             	cmp    $0x25,%ebx
  800c7c:	75 d6                	jne    800c54 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c7e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c82:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c90:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c97:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca1:	8d 50 01             	lea    0x1(%eax),%edx
  800ca4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	0f b6 d8             	movzbl %al,%ebx
  800cac:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800caf:	83 f8 55             	cmp    $0x55,%eax
  800cb2:	0f 87 2b 03 00 00    	ja     800fe3 <vprintfmt+0x399>
  800cb8:	8b 04 85 b8 40 80 00 	mov    0x8040b8(,%eax,4),%eax
  800cbf:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cc1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cc5:	eb d7                	jmp    800c9e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cc7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ccb:	eb d1                	jmp    800c9e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cd4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cd7:	89 d0                	mov    %edx,%eax
  800cd9:	c1 e0 02             	shl    $0x2,%eax
  800cdc:	01 d0                	add    %edx,%eax
  800cde:	01 c0                	add    %eax,%eax
  800ce0:	01 d8                	add    %ebx,%eax
  800ce2:	83 e8 30             	sub    $0x30,%eax
  800ce5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cf0:	83 fb 2f             	cmp    $0x2f,%ebx
  800cf3:	7e 3e                	jle    800d33 <vprintfmt+0xe9>
  800cf5:	83 fb 39             	cmp    $0x39,%ebx
  800cf8:	7f 39                	jg     800d33 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cfa:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cfd:	eb d5                	jmp    800cd4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cff:	8b 45 14             	mov    0x14(%ebp),%eax
  800d02:	83 c0 04             	add    $0x4,%eax
  800d05:	89 45 14             	mov    %eax,0x14(%ebp)
  800d08:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0b:	83 e8 04             	sub    $0x4,%eax
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d13:	eb 1f                	jmp    800d34 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d19:	79 83                	jns    800c9e <vprintfmt+0x54>
				width = 0;
  800d1b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d22:	e9 77 ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d27:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d2e:	e9 6b ff ff ff       	jmp    800c9e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d33:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d38:	0f 89 60 ff ff ff    	jns    800c9e <vprintfmt+0x54>
				width = precision, precision = -1;
  800d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d44:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d4b:	e9 4e ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d50:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d53:	e9 46 ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d58:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5b:	83 c0 04             	add    $0x4,%eax
  800d5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d61:	8b 45 14             	mov    0x14(%ebp),%eax
  800d64:	83 e8 04             	sub    $0x4,%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	83 ec 08             	sub    $0x8,%esp
  800d6c:	ff 75 0c             	pushl  0xc(%ebp)
  800d6f:	50                   	push   %eax
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	ff d0                	call   *%eax
  800d75:	83 c4 10             	add    $0x10,%esp
			break;
  800d78:	e9 89 02 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d80:	83 c0 04             	add    $0x4,%eax
  800d83:	89 45 14             	mov    %eax,0x14(%ebp)
  800d86:	8b 45 14             	mov    0x14(%ebp),%eax
  800d89:	83 e8 04             	sub    $0x4,%eax
  800d8c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d8e:	85 db                	test   %ebx,%ebx
  800d90:	79 02                	jns    800d94 <vprintfmt+0x14a>
				err = -err;
  800d92:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d94:	83 fb 64             	cmp    $0x64,%ebx
  800d97:	7f 0b                	jg     800da4 <vprintfmt+0x15a>
  800d99:	8b 34 9d 00 3f 80 00 	mov    0x803f00(,%ebx,4),%esi
  800da0:	85 f6                	test   %esi,%esi
  800da2:	75 19                	jne    800dbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da4:	53                   	push   %ebx
  800da5:	68 a5 40 80 00       	push   $0x8040a5
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	ff 75 08             	pushl  0x8(%ebp)
  800db0:	e8 5e 02 00 00       	call   801013 <printfmt>
  800db5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800db8:	e9 49 02 00 00       	jmp    801006 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dbd:	56                   	push   %esi
  800dbe:	68 ae 40 80 00       	push   $0x8040ae
  800dc3:	ff 75 0c             	pushl  0xc(%ebp)
  800dc6:	ff 75 08             	pushl  0x8(%ebp)
  800dc9:	e8 45 02 00 00       	call   801013 <printfmt>
  800dce:	83 c4 10             	add    $0x10,%esp
			break;
  800dd1:	e9 30 02 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd9:	83 c0 04             	add    $0x4,%eax
  800ddc:	89 45 14             	mov    %eax,0x14(%ebp)
  800ddf:	8b 45 14             	mov    0x14(%ebp),%eax
  800de2:	83 e8 04             	sub    $0x4,%eax
  800de5:	8b 30                	mov    (%eax),%esi
  800de7:	85 f6                	test   %esi,%esi
  800de9:	75 05                	jne    800df0 <vprintfmt+0x1a6>
				p = "(null)";
  800deb:	be b1 40 80 00       	mov    $0x8040b1,%esi
			if (width > 0 && padc != '-')
  800df0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df4:	7e 6d                	jle    800e63 <vprintfmt+0x219>
  800df6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dfa:	74 67                	je     800e63 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	50                   	push   %eax
  800e03:	56                   	push   %esi
  800e04:	e8 0c 03 00 00       	call   801115 <strnlen>
  800e09:	83 c4 10             	add    $0x10,%esp
  800e0c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e0f:	eb 16                	jmp    800e27 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e11:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e24:	ff 4d e4             	decl   -0x1c(%ebp)
  800e27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e2b:	7f e4                	jg     800e11 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e2d:	eb 34                	jmp    800e63 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e33:	74 1c                	je     800e51 <vprintfmt+0x207>
  800e35:	83 fb 1f             	cmp    $0x1f,%ebx
  800e38:	7e 05                	jle    800e3f <vprintfmt+0x1f5>
  800e3a:	83 fb 7e             	cmp    $0x7e,%ebx
  800e3d:	7e 12                	jle    800e51 <vprintfmt+0x207>
					putch('?', putdat);
  800e3f:	83 ec 08             	sub    $0x8,%esp
  800e42:	ff 75 0c             	pushl  0xc(%ebp)
  800e45:	6a 3f                	push   $0x3f
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	ff d0                	call   *%eax
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	eb 0f                	jmp    800e60 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	53                   	push   %ebx
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	ff d0                	call   *%eax
  800e5d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e60:	ff 4d e4             	decl   -0x1c(%ebp)
  800e63:	89 f0                	mov    %esi,%eax
  800e65:	8d 70 01             	lea    0x1(%eax),%esi
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	0f be d8             	movsbl %al,%ebx
  800e6d:	85 db                	test   %ebx,%ebx
  800e6f:	74 24                	je     800e95 <vprintfmt+0x24b>
  800e71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e75:	78 b8                	js     800e2f <vprintfmt+0x1e5>
  800e77:	ff 4d e0             	decl   -0x20(%ebp)
  800e7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e7e:	79 af                	jns    800e2f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e80:	eb 13                	jmp    800e95 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e82:	83 ec 08             	sub    $0x8,%esp
  800e85:	ff 75 0c             	pushl  0xc(%ebp)
  800e88:	6a 20                	push   $0x20
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	ff d0                	call   *%eax
  800e8f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e92:	ff 4d e4             	decl   -0x1c(%ebp)
  800e95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e99:	7f e7                	jg     800e82 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e9b:	e9 66 01 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ea9:	50                   	push   %eax
  800eaa:	e8 3c fd ff ff       	call   800beb <getint>
  800eaf:	83 c4 10             	add    $0x10,%esp
  800eb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebe:	85 d2                	test   %edx,%edx
  800ec0:	79 23                	jns    800ee5 <vprintfmt+0x29b>
				putch('-', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 2d                	push   $0x2d
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed8:	f7 d8                	neg    %eax
  800eda:	83 d2 00             	adc    $0x0,%edx
  800edd:	f7 da                	neg    %edx
  800edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ee5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eec:	e9 bc 00 00 00       	jmp    800fad <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef7:	8d 45 14             	lea    0x14(%ebp),%eax
  800efa:	50                   	push   %eax
  800efb:	e8 84 fc ff ff       	call   800b84 <getuint>
  800f00:	83 c4 10             	add    $0x10,%esp
  800f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f09:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f10:	e9 98 00 00 00       	jmp    800fad <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	ff 75 0c             	pushl  0xc(%ebp)
  800f1b:	6a 58                	push   $0x58
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	ff d0                	call   *%eax
  800f22:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	ff 75 0c             	pushl  0xc(%ebp)
  800f2b:	6a 58                	push   $0x58
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	ff d0                	call   *%eax
  800f32:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f35:	83 ec 08             	sub    $0x8,%esp
  800f38:	ff 75 0c             	pushl  0xc(%ebp)
  800f3b:	6a 58                	push   $0x58
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	ff d0                	call   *%eax
  800f42:	83 c4 10             	add    $0x10,%esp
			break;
  800f45:	e9 bc 00 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f4a:	83 ec 08             	sub    $0x8,%esp
  800f4d:	ff 75 0c             	pushl  0xc(%ebp)
  800f50:	6a 30                	push   $0x30
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	ff d0                	call   *%eax
  800f57:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	6a 78                	push   $0x78
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff d0                	call   *%eax
  800f67:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 c0 04             	add    $0x4,%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f8c:	eb 1f                	jmp    800fad <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f8e:	83 ec 08             	sub    $0x8,%esp
  800f91:	ff 75 e8             	pushl  -0x18(%ebp)
  800f94:	8d 45 14             	lea    0x14(%ebp),%eax
  800f97:	50                   	push   %eax
  800f98:	e8 e7 fb ff ff       	call   800b84 <getuint>
  800f9d:	83 c4 10             	add    $0x10,%esp
  800fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fa6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fad:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb4:	83 ec 04             	sub    $0x4,%esp
  800fb7:	52                   	push   %edx
  800fb8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fbb:	50                   	push   %eax
  800fbc:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbf:	ff 75 f0             	pushl  -0x10(%ebp)
  800fc2:	ff 75 0c             	pushl  0xc(%ebp)
  800fc5:	ff 75 08             	pushl  0x8(%ebp)
  800fc8:	e8 00 fb ff ff       	call   800acd <printnum>
  800fcd:	83 c4 20             	add    $0x20,%esp
			break;
  800fd0:	eb 34                	jmp    801006 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	53                   	push   %ebx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	ff d0                	call   *%eax
  800fde:	83 c4 10             	add    $0x10,%esp
			break;
  800fe1:	eb 23                	jmp    801006 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fe3:	83 ec 08             	sub    $0x8,%esp
  800fe6:	ff 75 0c             	pushl  0xc(%ebp)
  800fe9:	6a 25                	push   $0x25
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	ff d0                	call   *%eax
  800ff0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ff3:	ff 4d 10             	decl   0x10(%ebp)
  800ff6:	eb 03                	jmp    800ffb <vprintfmt+0x3b1>
  800ff8:	ff 4d 10             	decl   0x10(%ebp)
  800ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffe:	48                   	dec    %eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 25                	cmp    $0x25,%al
  801003:	75 f3                	jne    800ff8 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801005:	90                   	nop
		}
	}
  801006:	e9 47 fc ff ff       	jmp    800c52 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80100b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80100c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80100f:	5b                   	pop    %ebx
  801010:	5e                   	pop    %esi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801019:	8d 45 10             	lea    0x10(%ebp),%eax
  80101c:	83 c0 04             	add    $0x4,%eax
  80101f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	ff 75 f4             	pushl  -0xc(%ebp)
  801028:	50                   	push   %eax
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	ff 75 08             	pushl  0x8(%ebp)
  80102f:	e8 16 fc ff ff       	call   800c4a <vprintfmt>
  801034:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801037:	90                   	nop
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	8b 40 08             	mov    0x8(%eax),%eax
  801043:	8d 50 01             	lea    0x1(%eax),%edx
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	8b 10                	mov    (%eax),%edx
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8b 40 04             	mov    0x4(%eax),%eax
  801057:	39 c2                	cmp    %eax,%edx
  801059:	73 12                	jae    80106d <sprintputch+0x33>
		*b->buf++ = ch;
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	8b 00                	mov    (%eax),%eax
  801060:	8d 48 01             	lea    0x1(%eax),%ecx
  801063:	8b 55 0c             	mov    0xc(%ebp),%edx
  801066:	89 0a                	mov    %ecx,(%edx)
  801068:	8b 55 08             	mov    0x8(%ebp),%edx
  80106b:	88 10                	mov    %dl,(%eax)
}
  80106d:	90                   	nop
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	01 d0                	add    %edx,%eax
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801095:	74 06                	je     80109d <vsnprintf+0x2d>
  801097:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109b:	7f 07                	jg     8010a4 <vsnprintf+0x34>
		return -E_INVAL;
  80109d:	b8 03 00 00 00       	mov    $0x3,%eax
  8010a2:	eb 20                	jmp    8010c4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010a4:	ff 75 14             	pushl  0x14(%ebp)
  8010a7:	ff 75 10             	pushl  0x10(%ebp)
  8010aa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010ad:	50                   	push   %eax
  8010ae:	68 3a 10 80 00       	push   $0x80103a
  8010b3:	e8 92 fb ff ff       	call   800c4a <vprintfmt>
  8010b8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010be:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    

008010c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010cc:	8d 45 10             	lea    0x10(%ebp),%eax
  8010cf:	83 c0 04             	add    $0x4,%eax
  8010d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010db:	50                   	push   %eax
  8010dc:	ff 75 0c             	pushl  0xc(%ebp)
  8010df:	ff 75 08             	pushl  0x8(%ebp)
  8010e2:	e8 89 ff ff ff       	call   801070 <vsnprintf>
  8010e7:	83 c4 10             	add    $0x10,%esp
  8010ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010f0:	c9                   	leave  
  8010f1:	c3                   	ret    

008010f2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ff:	eb 06                	jmp    801107 <strlen+0x15>
		n++;
  801101:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801104:	ff 45 08             	incl   0x8(%ebp)
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	84 c0                	test   %al,%al
  80110e:	75 f1                	jne    801101 <strlen+0xf>
		n++;
	return n;
  801110:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801113:	c9                   	leave  
  801114:	c3                   	ret    

00801115 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80111b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801122:	eb 09                	jmp    80112d <strnlen+0x18>
		n++;
  801124:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801127:	ff 45 08             	incl   0x8(%ebp)
  80112a:	ff 4d 0c             	decl   0xc(%ebp)
  80112d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801131:	74 09                	je     80113c <strnlen+0x27>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	84 c0                	test   %al,%al
  80113a:	75 e8                	jne    801124 <strnlen+0xf>
		n++;
	return n;
  80113c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80114d:	90                   	nop
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8d 50 01             	lea    0x1(%eax),%edx
  801154:	89 55 08             	mov    %edx,0x8(%ebp)
  801157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80115d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801160:	8a 12                	mov    (%edx),%dl
  801162:	88 10                	mov    %dl,(%eax)
  801164:	8a 00                	mov    (%eax),%al
  801166:	84 c0                	test   %al,%al
  801168:	75 e4                	jne    80114e <strcpy+0xd>
		/* do nothing */;
	return ret;
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80117b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801182:	eb 1f                	jmp    8011a3 <strncpy+0x34>
		*dst++ = *src;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8d 50 01             	lea    0x1(%eax),%edx
  80118a:	89 55 08             	mov    %edx,0x8(%ebp)
  80118d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801190:	8a 12                	mov    (%edx),%dl
  801192:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	84 c0                	test   %al,%al
  80119b:	74 03                	je     8011a0 <strncpy+0x31>
			src++;
  80119d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011a0:	ff 45 fc             	incl   -0x4(%ebp)
  8011a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a9:	72 d9                	jb     801184 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    

008011b0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c0:	74 30                	je     8011f2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011c2:	eb 16                	jmp    8011da <strlcpy+0x2a>
			*dst++ = *src++;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8011cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011d3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011d6:	8a 12                	mov    (%edx),%dl
  8011d8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011da:	ff 4d 10             	decl   0x10(%ebp)
  8011dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e1:	74 09                	je     8011ec <strlcpy+0x3c>
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	84 c0                	test   %al,%al
  8011ea:	75 d8                	jne    8011c4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f8:	29 c2                	sub    %eax,%edx
  8011fa:	89 d0                	mov    %edx,%eax
}
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    

008011fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801201:	eb 06                	jmp    801209 <strcmp+0xb>
		p++, q++;
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	84 c0                	test   %al,%al
  801210:	74 0e                	je     801220 <strcmp+0x22>
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 10                	mov    (%eax),%dl
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	38 c2                	cmp    %al,%dl
  80121e:	74 e3                	je     801203 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	0f b6 d0             	movzbl %al,%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	0f b6 c0             	movzbl %al,%eax
  801230:	29 c2                	sub    %eax,%edx
  801232:	89 d0                	mov    %edx,%eax
}
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    

00801236 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801239:	eb 09                	jmp    801244 <strncmp+0xe>
		n--, p++, q++;
  80123b:	ff 4d 10             	decl   0x10(%ebp)
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801244:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801248:	74 17                	je     801261 <strncmp+0x2b>
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	84 c0                	test   %al,%al
  801251:	74 0e                	je     801261 <strncmp+0x2b>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 10                	mov    (%eax),%dl
  801258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	38 c2                	cmp    %al,%dl
  80125f:	74 da                	je     80123b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801261:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801265:	75 07                	jne    80126e <strncmp+0x38>
		return 0;
  801267:	b8 00 00 00 00       	mov    $0x0,%eax
  80126c:	eb 14                	jmp    801282 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	0f b6 d0             	movzbl %al,%edx
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	0f b6 c0             	movzbl %al,%eax
  80127e:	29 c2                	sub    %eax,%edx
  801280:	89 d0                	mov    %edx,%eax
}
  801282:	5d                   	pop    %ebp
  801283:	c3                   	ret    

00801284 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	83 ec 04             	sub    $0x4,%esp
  80128a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801290:	eb 12                	jmp    8012a4 <strchr+0x20>
		if (*s == c)
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80129a:	75 05                	jne    8012a1 <strchr+0x1d>
			return (char *) s;
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	eb 11                	jmp    8012b2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012a1:	ff 45 08             	incl   0x8(%ebp)
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	84 c0                	test   %al,%al
  8012ab:	75 e5                	jne    801292 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	83 ec 04             	sub    $0x4,%esp
  8012ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012c0:	eb 0d                	jmp    8012cf <strfind+0x1b>
		if (*s == c)
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012ca:	74 0e                	je     8012da <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012cc:	ff 45 08             	incl   0x8(%ebp)
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	84 c0                	test   %al,%al
  8012d6:	75 ea                	jne    8012c2 <strfind+0xe>
  8012d8:	eb 01                	jmp    8012db <strfind+0x27>
		if (*s == c)
			break;
  8012da:	90                   	nop
	return (char *) s;
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012f2:	eb 0e                	jmp    801302 <memset+0x22>
		*p++ = c;
  8012f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801302:	ff 4d f8             	decl   -0x8(%ebp)
  801305:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801309:	79 e9                	jns    8012f4 <memset+0x14>
		*p++ = c;

	return v;
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801322:	eb 16                	jmp    80133a <memcpy+0x2a>
		*d++ = *s++;
  801324:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801327:	8d 50 01             	lea    0x1(%eax),%edx
  80132a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80132d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801330:	8d 4a 01             	lea    0x1(%edx),%ecx
  801333:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801336:	8a 12                	mov    (%edx),%dl
  801338:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80133a:	8b 45 10             	mov    0x10(%ebp),%eax
  80133d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801340:	89 55 10             	mov    %edx,0x10(%ebp)
  801343:	85 c0                	test   %eax,%eax
  801345:	75 dd                	jne    801324 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80135e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801361:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801364:	73 50                	jae    8013b6 <memmove+0x6a>
  801366:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801369:	8b 45 10             	mov    0x10(%ebp),%eax
  80136c:	01 d0                	add    %edx,%eax
  80136e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801371:	76 43                	jbe    8013b6 <memmove+0x6a>
		s += n;
  801373:	8b 45 10             	mov    0x10(%ebp),%eax
  801376:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801379:	8b 45 10             	mov    0x10(%ebp),%eax
  80137c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80137f:	eb 10                	jmp    801391 <memmove+0x45>
			*--d = *--s;
  801381:	ff 4d f8             	decl   -0x8(%ebp)
  801384:	ff 4d fc             	decl   -0x4(%ebp)
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	8a 10                	mov    (%eax),%dl
  80138c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801391:	8b 45 10             	mov    0x10(%ebp),%eax
  801394:	8d 50 ff             	lea    -0x1(%eax),%edx
  801397:	89 55 10             	mov    %edx,0x10(%ebp)
  80139a:	85 c0                	test   %eax,%eax
  80139c:	75 e3                	jne    801381 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80139e:	eb 23                	jmp    8013c3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a3:	8d 50 01             	lea    0x1(%eax),%edx
  8013a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013af:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013b2:	8a 12                	mov    (%edx),%dl
  8013b4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	75 dd                	jne    8013a0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013da:	eb 2a                	jmp    801406 <memcmp+0x3e>
		if (*s1 != *s2)
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 16                	je     801400 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
  8013fe:	eb 18                	jmp    801418 <memcmp+0x50>
		s1++, s2++;
  801400:	ff 45 fc             	incl   -0x4(%ebp)
  801403:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	8d 50 ff             	lea    -0x1(%eax),%edx
  80140c:	89 55 10             	mov    %edx,0x10(%ebp)
  80140f:	85 c0                	test   %eax,%eax
  801411:	75 c9                	jne    8013dc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801420:	8b 55 08             	mov    0x8(%ebp),%edx
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	01 d0                	add    %edx,%eax
  801428:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80142b:	eb 15                	jmp    801442 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	0f b6 d0             	movzbl %al,%edx
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	0f b6 c0             	movzbl %al,%eax
  80143b:	39 c2                	cmp    %eax,%edx
  80143d:	74 0d                	je     80144c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80143f:	ff 45 08             	incl   0x8(%ebp)
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801448:	72 e3                	jb     80142d <memfind+0x13>
  80144a:	eb 01                	jmp    80144d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80144c:	90                   	nop
	return (void *) s;
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80145f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801466:	eb 03                	jmp    80146b <strtol+0x19>
		s++;
  801468:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	3c 20                	cmp    $0x20,%al
  801472:	74 f4                	je     801468 <strtol+0x16>
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	3c 09                	cmp    $0x9,%al
  80147b:	74 eb                	je     801468 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	3c 2b                	cmp    $0x2b,%al
  801484:	75 05                	jne    80148b <strtol+0x39>
		s++;
  801486:	ff 45 08             	incl   0x8(%ebp)
  801489:	eb 13                	jmp    80149e <strtol+0x4c>
	else if (*s == '-')
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	3c 2d                	cmp    $0x2d,%al
  801492:	75 0a                	jne    80149e <strtol+0x4c>
		s++, neg = 1;
  801494:	ff 45 08             	incl   0x8(%ebp)
  801497:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80149e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a2:	74 06                	je     8014aa <strtol+0x58>
  8014a4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014a8:	75 20                	jne    8014ca <strtol+0x78>
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	3c 30                	cmp    $0x30,%al
  8014b1:	75 17                	jne    8014ca <strtol+0x78>
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	40                   	inc    %eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	3c 78                	cmp    $0x78,%al
  8014bb:	75 0d                	jne    8014ca <strtol+0x78>
		s += 2, base = 16;
  8014bd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014c1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014c8:	eb 28                	jmp    8014f2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ce:	75 15                	jne    8014e5 <strtol+0x93>
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	8a 00                	mov    (%eax),%al
  8014d5:	3c 30                	cmp    $0x30,%al
  8014d7:	75 0c                	jne    8014e5 <strtol+0x93>
		s++, base = 8;
  8014d9:	ff 45 08             	incl   0x8(%ebp)
  8014dc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014e3:	eb 0d                	jmp    8014f2 <strtol+0xa0>
	else if (base == 0)
  8014e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e9:	75 07                	jne    8014f2 <strtol+0xa0>
		base = 10;
  8014eb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	3c 2f                	cmp    $0x2f,%al
  8014f9:	7e 19                	jle    801514 <strtol+0xc2>
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	3c 39                	cmp    $0x39,%al
  801502:	7f 10                	jg     801514 <strtol+0xc2>
			dig = *s - '0';
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	0f be c0             	movsbl %al,%eax
  80150c:	83 e8 30             	sub    $0x30,%eax
  80150f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801512:	eb 42                	jmp    801556 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	8a 00                	mov    (%eax),%al
  801519:	3c 60                	cmp    $0x60,%al
  80151b:	7e 19                	jle    801536 <strtol+0xe4>
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	3c 7a                	cmp    $0x7a,%al
  801524:	7f 10                	jg     801536 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	0f be c0             	movsbl %al,%eax
  80152e:	83 e8 57             	sub    $0x57,%eax
  801531:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801534:	eb 20                	jmp    801556 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	3c 40                	cmp    $0x40,%al
  80153d:	7e 39                	jle    801578 <strtol+0x126>
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	3c 5a                	cmp    $0x5a,%al
  801546:	7f 30                	jg     801578 <strtol+0x126>
			dig = *s - 'A' + 10;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	0f be c0             	movsbl %al,%eax
  801550:	83 e8 37             	sub    $0x37,%eax
  801553:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801559:	3b 45 10             	cmp    0x10(%ebp),%eax
  80155c:	7d 19                	jge    801577 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80155e:	ff 45 08             	incl   0x8(%ebp)
  801561:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801564:	0f af 45 10          	imul   0x10(%ebp),%eax
  801568:	89 c2                	mov    %eax,%edx
  80156a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156d:	01 d0                	add    %edx,%eax
  80156f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801572:	e9 7b ff ff ff       	jmp    8014f2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801577:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801578:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80157c:	74 08                	je     801586 <strtol+0x134>
		*endptr = (char *) s;
  80157e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801581:	8b 55 08             	mov    0x8(%ebp),%edx
  801584:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801586:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80158a:	74 07                	je     801593 <strtol+0x141>
  80158c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158f:	f7 d8                	neg    %eax
  801591:	eb 03                	jmp    801596 <strtol+0x144>
  801593:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <ltostr>:

void
ltostr(long value, char *str)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80159e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b0:	79 13                	jns    8015c5 <ltostr+0x2d>
	{
		neg = 1;
  8015b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015bf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015c2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015cd:	99                   	cltd   
  8015ce:	f7 f9                	idiv   %ecx
  8015d0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d6:	8d 50 01             	lea    0x1(%eax),%edx
  8015d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015dc:	89 c2                	mov    %eax,%edx
  8015de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e1:	01 d0                	add    %edx,%eax
  8015e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e6:	83 c2 30             	add    $0x30,%edx
  8015e9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015f3:	f7 e9                	imul   %ecx
  8015f5:	c1 fa 02             	sar    $0x2,%edx
  8015f8:	89 c8                	mov    %ecx,%eax
  8015fa:	c1 f8 1f             	sar    $0x1f,%eax
  8015fd:	29 c2                	sub    %eax,%edx
  8015ff:	89 d0                	mov    %edx,%eax
  801601:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801604:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801607:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80160c:	f7 e9                	imul   %ecx
  80160e:	c1 fa 02             	sar    $0x2,%edx
  801611:	89 c8                	mov    %ecx,%eax
  801613:	c1 f8 1f             	sar    $0x1f,%eax
  801616:	29 c2                	sub    %eax,%edx
  801618:	89 d0                	mov    %edx,%eax
  80161a:	c1 e0 02             	shl    $0x2,%eax
  80161d:	01 d0                	add    %edx,%eax
  80161f:	01 c0                	add    %eax,%eax
  801621:	29 c1                	sub    %eax,%ecx
  801623:	89 ca                	mov    %ecx,%edx
  801625:	85 d2                	test   %edx,%edx
  801627:	75 9c                	jne    8015c5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801629:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801630:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801633:	48                   	dec    %eax
  801634:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801637:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80163b:	74 3d                	je     80167a <ltostr+0xe2>
		start = 1 ;
  80163d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801644:	eb 34                	jmp    80167a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 d0                	add    %edx,%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801653:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801656:	8b 45 0c             	mov    0xc(%ebp),%eax
  801659:	01 c2                	add    %eax,%edx
  80165b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80165e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801661:	01 c8                	add    %ecx,%eax
  801663:	8a 00                	mov    (%eax),%al
  801665:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801667:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166d:	01 c2                	add    %eax,%edx
  80166f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801672:	88 02                	mov    %al,(%edx)
		start++ ;
  801674:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801677:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801680:	7c c4                	jl     801646 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801682:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801685:	8b 45 0c             	mov    0xc(%ebp),%eax
  801688:	01 d0                	add    %edx,%eax
  80168a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80168d:	90                   	nop
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801696:	ff 75 08             	pushl  0x8(%ebp)
  801699:	e8 54 fa ff ff       	call   8010f2 <strlen>
  80169e:	83 c4 04             	add    $0x4,%esp
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	e8 46 fa ff ff       	call   8010f2 <strlen>
  8016ac:	83 c4 04             	add    $0x4,%esp
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016c0:	eb 17                	jmp    8016d9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c8:	01 c2                	add    %eax,%edx
  8016ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	01 c8                	add    %ecx,%eax
  8016d2:	8a 00                	mov    (%eax),%al
  8016d4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016d6:	ff 45 fc             	incl   -0x4(%ebp)
  8016d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016df:	7c e1                	jl     8016c2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ef:	eb 1f                	jmp    801710 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f4:	8d 50 01             	lea    0x1(%eax),%edx
  8016f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016fa:	89 c2                	mov    %eax,%edx
  8016fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ff:	01 c2                	add    %eax,%edx
  801701:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801704:	8b 45 0c             	mov    0xc(%ebp),%eax
  801707:	01 c8                	add    %ecx,%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80170d:	ff 45 f8             	incl   -0x8(%ebp)
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801716:	7c d9                	jl     8016f1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801718:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171b:	8b 45 10             	mov    0x10(%ebp),%eax
  80171e:	01 d0                	add    %edx,%eax
  801720:	c6 00 00             	movb   $0x0,(%eax)
}
  801723:	90                   	nop
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801729:	8b 45 14             	mov    0x14(%ebp),%eax
  80172c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801732:	8b 45 14             	mov    0x14(%ebp),%eax
  801735:	8b 00                	mov    (%eax),%eax
  801737:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80173e:	8b 45 10             	mov    0x10(%ebp),%eax
  801741:	01 d0                	add    %edx,%eax
  801743:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801749:	eb 0c                	jmp    801757 <strsplit+0x31>
			*string++ = 0;
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	8d 50 01             	lea    0x1(%eax),%edx
  801751:	89 55 08             	mov    %edx,0x8(%ebp)
  801754:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	74 18                	je     801778 <strsplit+0x52>
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	8a 00                	mov    (%eax),%al
  801765:	0f be c0             	movsbl %al,%eax
  801768:	50                   	push   %eax
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	e8 13 fb ff ff       	call   801284 <strchr>
  801771:	83 c4 08             	add    $0x8,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	75 d3                	jne    80174b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	84 c0                	test   %al,%al
  80177f:	74 5a                	je     8017db <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801781:	8b 45 14             	mov    0x14(%ebp),%eax
  801784:	8b 00                	mov    (%eax),%eax
  801786:	83 f8 0f             	cmp    $0xf,%eax
  801789:	75 07                	jne    801792 <strsplit+0x6c>
		{
			return 0;
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
  801790:	eb 66                	jmp    8017f8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801792:	8b 45 14             	mov    0x14(%ebp),%eax
  801795:	8b 00                	mov    (%eax),%eax
  801797:	8d 48 01             	lea    0x1(%eax),%ecx
  80179a:	8b 55 14             	mov    0x14(%ebp),%edx
  80179d:	89 0a                	mov    %ecx,(%edx)
  80179f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a9:	01 c2                	add    %eax,%edx
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b0:	eb 03                	jmp    8017b5 <strsplit+0x8f>
			string++;
  8017b2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	84 c0                	test   %al,%al
  8017bc:	74 8b                	je     801749 <strsplit+0x23>
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	8a 00                	mov    (%eax),%al
  8017c3:	0f be c0             	movsbl %al,%eax
  8017c6:	50                   	push   %eax
  8017c7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ca:	e8 b5 fa ff ff       	call   801284 <strchr>
  8017cf:	83 c4 08             	add    $0x8,%esp
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	74 dc                	je     8017b2 <strsplit+0x8c>
			string++;
	}
  8017d6:	e9 6e ff ff ff       	jmp    801749 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017db:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017df:	8b 00                	mov    (%eax),%eax
  8017e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017eb:	01 d0                	add    %edx,%eax
  8017ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801800:	a1 04 50 80 00       	mov    0x805004,%eax
  801805:	85 c0                	test   %eax,%eax
  801807:	74 1f                	je     801828 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801809:	e8 1d 00 00 00       	call   80182b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80180e:	83 ec 0c             	sub    $0xc,%esp
  801811:	68 10 42 80 00       	push   $0x804210
  801816:	e8 55 f2 ff ff       	call   800a70 <cprintf>
  80181b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80181e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801825:	00 00 00 
	}
}
  801828:	90                   	nop
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801831:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801838:	00 00 00 
  80183b:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801842:	00 00 00 
  801845:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80184c:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80184f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801856:	00 00 00 
  801859:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801860:	00 00 00 
  801863:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80186a:	00 00 00 
	uint32 arr_size = 0;
  80186d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801874:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80187b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801883:	2d 00 10 00 00       	sub    $0x1000,%eax
  801888:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80188d:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801894:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801897:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80189e:	a1 20 51 80 00       	mov    0x805120,%eax
  8018a3:	c1 e0 04             	shl    $0x4,%eax
  8018a6:	89 c2                	mov    %eax,%edx
  8018a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ab:	01 d0                	add    %edx,%eax
  8018ad:	48                   	dec    %eax
  8018ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b9:	f7 75 ec             	divl   -0x14(%ebp)
  8018bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018bf:	29 d0                	sub    %edx,%eax
  8018c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8018c4:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8018cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018d3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	6a 06                	push   $0x6
  8018dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e0:	50                   	push   %eax
  8018e1:	e8 6a 04 00 00       	call   801d50 <sys_allocate_chunk>
  8018e6:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018e9:	a1 20 51 80 00       	mov    0x805120,%eax
  8018ee:	83 ec 0c             	sub    $0xc,%esp
  8018f1:	50                   	push   %eax
  8018f2:	e8 df 0a 00 00       	call   8023d6 <initialize_MemBlocksList>
  8018f7:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8018fa:	a1 48 51 80 00       	mov    0x805148,%eax
  8018ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801902:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801905:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  80190c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80190f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801916:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80191a:	75 14                	jne    801930 <initialize_dyn_block_system+0x105>
  80191c:	83 ec 04             	sub    $0x4,%esp
  80191f:	68 35 42 80 00       	push   $0x804235
  801924:	6a 33                	push   $0x33
  801926:	68 53 42 80 00       	push   $0x804253
  80192b:	e8 8c ee ff ff       	call   8007bc <_panic>
  801930:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801933:	8b 00                	mov    (%eax),%eax
  801935:	85 c0                	test   %eax,%eax
  801937:	74 10                	je     801949 <initialize_dyn_block_system+0x11e>
  801939:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80193c:	8b 00                	mov    (%eax),%eax
  80193e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801941:	8b 52 04             	mov    0x4(%edx),%edx
  801944:	89 50 04             	mov    %edx,0x4(%eax)
  801947:	eb 0b                	jmp    801954 <initialize_dyn_block_system+0x129>
  801949:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80194c:	8b 40 04             	mov    0x4(%eax),%eax
  80194f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801954:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801957:	8b 40 04             	mov    0x4(%eax),%eax
  80195a:	85 c0                	test   %eax,%eax
  80195c:	74 0f                	je     80196d <initialize_dyn_block_system+0x142>
  80195e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801961:	8b 40 04             	mov    0x4(%eax),%eax
  801964:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801967:	8b 12                	mov    (%edx),%edx
  801969:	89 10                	mov    %edx,(%eax)
  80196b:	eb 0a                	jmp    801977 <initialize_dyn_block_system+0x14c>
  80196d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	a3 48 51 80 00       	mov    %eax,0x805148
  801977:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80197a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801980:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801983:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80198a:	a1 54 51 80 00       	mov    0x805154,%eax
  80198f:	48                   	dec    %eax
  801990:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801995:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801999:	75 14                	jne    8019af <initialize_dyn_block_system+0x184>
  80199b:	83 ec 04             	sub    $0x4,%esp
  80199e:	68 60 42 80 00       	push   $0x804260
  8019a3:	6a 34                	push   $0x34
  8019a5:	68 53 42 80 00       	push   $0x804253
  8019aa:	e8 0d ee ff ff       	call   8007bc <_panic>
  8019af:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8019b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b8:	89 10                	mov    %edx,(%eax)
  8019ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019bd:	8b 00                	mov    (%eax),%eax
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	74 0d                	je     8019d0 <initialize_dyn_block_system+0x1a5>
  8019c3:	a1 38 51 80 00       	mov    0x805138,%eax
  8019c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019cb:	89 50 04             	mov    %edx,0x4(%eax)
  8019ce:	eb 08                	jmp    8019d8 <initialize_dyn_block_system+0x1ad>
  8019d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019d3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8019d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019db:	a3 38 51 80 00       	mov    %eax,0x805138
  8019e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8019ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8019ef:	40                   	inc    %eax
  8019f0:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8019f5:	90                   	nop
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019fe:	e8 f7 fd ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  801a03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a07:	75 07                	jne    801a10 <malloc+0x18>
  801a09:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0e:	eb 61                	jmp    801a71 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801a10:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a17:	8b 55 08             	mov    0x8(%ebp),%edx
  801a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1d:	01 d0                	add    %edx,%eax
  801a1f:	48                   	dec    %eax
  801a20:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a26:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2b:	f7 75 f0             	divl   -0x10(%ebp)
  801a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a31:	29 d0                	sub    %edx,%eax
  801a33:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801a36:	e8 e3 06 00 00       	call   80211e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	74 11                	je     801a50 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801a3f:	83 ec 0c             	sub    $0xc,%esp
  801a42:	ff 75 e8             	pushl  -0x18(%ebp)
  801a45:	e8 4e 0d 00 00       	call   802798 <alloc_block_FF>
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801a50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a54:	74 16                	je     801a6c <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801a56:	83 ec 0c             	sub    $0xc,%esp
  801a59:	ff 75 f4             	pushl  -0xc(%ebp)
  801a5c:	e8 aa 0a 00 00       	call   80250b <insert_sorted_allocList>
  801a61:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a67:	8b 40 08             	mov    0x8(%eax),%eax
  801a6a:	eb 05                	jmp    801a71 <malloc+0x79>
	}

    return NULL;
  801a6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801a79:	83 ec 04             	sub    $0x4,%esp
  801a7c:	68 84 42 80 00       	push   $0x804284
  801a81:	6a 6f                	push   $0x6f
  801a83:	68 53 42 80 00       	push   $0x804253
  801a88:	e8 2f ed ff ff       	call   8007bc <_panic>

00801a8d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	83 ec 38             	sub    $0x38,%esp
  801a93:	8b 45 10             	mov    0x10(%ebp),%eax
  801a96:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a99:	e8 5c fd ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  801a9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801aa2:	75 07                	jne    801aab <smalloc+0x1e>
  801aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa9:	eb 7c                	jmp    801b27 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801aab:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ab2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab8:	01 d0                	add    %edx,%eax
  801aba:	48                   	dec    %eax
  801abb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ac1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac6:	f7 75 f0             	divl   -0x10(%ebp)
  801ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801acc:	29 d0                	sub    %edx,%eax
  801ace:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801ad1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801ad8:	e8 41 06 00 00       	call   80211e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801add:	85 c0                	test   %eax,%eax
  801adf:	74 11                	je     801af2 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801ae1:	83 ec 0c             	sub    $0xc,%esp
  801ae4:	ff 75 e8             	pushl  -0x18(%ebp)
  801ae7:	e8 ac 0c 00 00       	call   802798 <alloc_block_FF>
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801af2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801af6:	74 2a                	je     801b22 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afb:	8b 40 08             	mov    0x8(%eax),%eax
  801afe:	89 c2                	mov    %eax,%edx
  801b00:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801b04:	52                   	push   %edx
  801b05:	50                   	push   %eax
  801b06:	ff 75 0c             	pushl  0xc(%ebp)
  801b09:	ff 75 08             	pushl  0x8(%ebp)
  801b0c:	e8 92 03 00 00       	call   801ea3 <sys_createSharedObject>
  801b11:	83 c4 10             	add    $0x10,%esp
  801b14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801b17:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801b1b:	74 05                	je     801b22 <smalloc+0x95>
			return (void*)virtual_address;
  801b1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b20:	eb 05                	jmp    801b27 <smalloc+0x9a>
	}
	return NULL;
  801b22:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b2f:	e8 c6 fc ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801b34:	83 ec 04             	sub    $0x4,%esp
  801b37:	68 a8 42 80 00       	push   $0x8042a8
  801b3c:	68 b0 00 00 00       	push   $0xb0
  801b41:	68 53 42 80 00       	push   $0x804253
  801b46:	e8 71 ec ff ff       	call   8007bc <_panic>

00801b4b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b51:	e8 a4 fc ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	68 cc 42 80 00       	push   $0x8042cc
  801b5e:	68 f4 00 00 00       	push   $0xf4
  801b63:	68 53 42 80 00       	push   $0x804253
  801b68:	e8 4f ec ff ff       	call   8007bc <_panic>

00801b6d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b73:	83 ec 04             	sub    $0x4,%esp
  801b76:	68 f4 42 80 00       	push   $0x8042f4
  801b7b:	68 08 01 00 00       	push   $0x108
  801b80:	68 53 42 80 00       	push   $0x804253
  801b85:	e8 32 ec ff ff       	call   8007bc <_panic>

00801b8a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b90:	83 ec 04             	sub    $0x4,%esp
  801b93:	68 18 43 80 00       	push   $0x804318
  801b98:	68 13 01 00 00       	push   $0x113
  801b9d:	68 53 42 80 00       	push   $0x804253
  801ba2:	e8 15 ec ff ff       	call   8007bc <_panic>

00801ba7 <shrink>:

}
void shrink(uint32 newSize)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bad:	83 ec 04             	sub    $0x4,%esp
  801bb0:	68 18 43 80 00       	push   $0x804318
  801bb5:	68 18 01 00 00       	push   $0x118
  801bba:	68 53 42 80 00       	push   $0x804253
  801bbf:	e8 f8 eb ff ff       	call   8007bc <_panic>

00801bc4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bca:	83 ec 04             	sub    $0x4,%esp
  801bcd:	68 18 43 80 00       	push   $0x804318
  801bd2:	68 1d 01 00 00       	push   $0x11d
  801bd7:	68 53 42 80 00       	push   $0x804253
  801bdc:	e8 db eb ff ff       	call   8007bc <_panic>

00801be1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	57                   	push   %edi
  801be5:	56                   	push   %esi
  801be6:	53                   	push   %ebx
  801be7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bea:	8b 45 08             	mov    0x8(%ebp),%eax
  801bed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bf6:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bf9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bfc:	cd 30                	int    $0x30
  801bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5f                   	pop    %edi
  801c0a:	5d                   	pop    %ebp
  801c0b:	c3                   	ret    

00801c0c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	83 ec 04             	sub    $0x4,%esp
  801c12:	8b 45 10             	mov    0x10(%ebp),%eax
  801c15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c18:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	52                   	push   %edx
  801c24:	ff 75 0c             	pushl  0xc(%ebp)
  801c27:	50                   	push   %eax
  801c28:	6a 00                	push   $0x0
  801c2a:	e8 b2 ff ff ff       	call   801be1 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	90                   	nop
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 01                	push   $0x1
  801c44:	e8 98 ff ff ff       	call   801be1 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	52                   	push   %edx
  801c5e:	50                   	push   %eax
  801c5f:	6a 05                	push   $0x5
  801c61:	e8 7b ff ff ff       	call   801be1 <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	56                   	push   %esi
  801c6f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c70:	8b 75 18             	mov    0x18(%ebp),%esi
  801c73:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c76:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	56                   	push   %esi
  801c80:	53                   	push   %ebx
  801c81:	51                   	push   %ecx
  801c82:	52                   	push   %edx
  801c83:	50                   	push   %eax
  801c84:	6a 06                	push   $0x6
  801c86:	e8 56 ff ff ff       	call   801be1 <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
}
  801c8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c91:	5b                   	pop    %ebx
  801c92:	5e                   	pop    %esi
  801c93:	5d                   	pop    %ebp
  801c94:	c3                   	ret    

00801c95 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	52                   	push   %edx
  801ca5:	50                   	push   %eax
  801ca6:	6a 07                	push   $0x7
  801ca8:	e8 34 ff ff ff       	call   801be1 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	ff 75 0c             	pushl  0xc(%ebp)
  801cbe:	ff 75 08             	pushl  0x8(%ebp)
  801cc1:	6a 08                	push   $0x8
  801cc3:	e8 19 ff ff ff       	call   801be1 <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 09                	push   $0x9
  801cdc:	e8 00 ff ff ff       	call   801be1 <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 0a                	push   $0xa
  801cf5:	e8 e7 fe ff ff       	call   801be1 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 0b                	push   $0xb
  801d0e:	e8 ce fe ff ff       	call   801be1 <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	ff 75 0c             	pushl  0xc(%ebp)
  801d24:	ff 75 08             	pushl  0x8(%ebp)
  801d27:	6a 0f                	push   $0xf
  801d29:	e8 b3 fe ff ff       	call   801be1 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
	return;
  801d31:	90                   	nop
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	ff 75 0c             	pushl  0xc(%ebp)
  801d40:	ff 75 08             	pushl  0x8(%ebp)
  801d43:	6a 10                	push   $0x10
  801d45:	e8 97 fe ff ff       	call   801be1 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4d:	90                   	nop
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	ff 75 10             	pushl  0x10(%ebp)
  801d5a:	ff 75 0c             	pushl  0xc(%ebp)
  801d5d:	ff 75 08             	pushl  0x8(%ebp)
  801d60:	6a 11                	push   $0x11
  801d62:	e8 7a fe ff ff       	call   801be1 <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6a:	90                   	nop
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 0c                	push   $0xc
  801d7c:	e8 60 fe ff ff       	call   801be1 <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	ff 75 08             	pushl  0x8(%ebp)
  801d94:	6a 0d                	push   $0xd
  801d96:	e8 46 fe ff ff       	call   801be1 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 0e                	push   $0xe
  801daf:	e8 2d fe ff ff       	call   801be1 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	90                   	nop
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 13                	push   $0x13
  801dc9:	e8 13 fe ff ff       	call   801be1 <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
}
  801dd1:	90                   	nop
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 14                	push   $0x14
  801de3:	e8 f9 fd ff ff       	call   801be1 <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
}
  801deb:	90                   	nop
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_cputc>:


void
sys_cputc(const char c)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 04             	sub    $0x4,%esp
  801df4:	8b 45 08             	mov    0x8(%ebp),%eax
  801df7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801dfa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	50                   	push   %eax
  801e07:	6a 15                	push   $0x15
  801e09:	e8 d3 fd ff ff       	call   801be1 <syscall>
  801e0e:	83 c4 18             	add    $0x18,%esp
}
  801e11:	90                   	nop
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 16                	push   $0x16
  801e23:	e8 b9 fd ff ff       	call   801be1 <syscall>
  801e28:	83 c4 18             	add    $0x18,%esp
}
  801e2b:	90                   	nop
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	ff 75 0c             	pushl  0xc(%ebp)
  801e3d:	50                   	push   %eax
  801e3e:	6a 17                	push   $0x17
  801e40:	e8 9c fd ff ff       	call   801be1 <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	52                   	push   %edx
  801e5a:	50                   	push   %eax
  801e5b:	6a 1a                	push   $0x1a
  801e5d:	e8 7f fd ff ff       	call   801be1 <syscall>
  801e62:	83 c4 18             	add    $0x18,%esp
}
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	52                   	push   %edx
  801e77:	50                   	push   %eax
  801e78:	6a 18                	push   $0x18
  801e7a:	e8 62 fd ff ff       	call   801be1 <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
}
  801e82:	90                   	nop
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	52                   	push   %edx
  801e95:	50                   	push   %eax
  801e96:	6a 19                	push   $0x19
  801e98:	e8 44 fd ff ff       	call   801be1 <syscall>
  801e9d:	83 c4 18             	add    $0x18,%esp
}
  801ea0:	90                   	nop
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	83 ec 04             	sub    $0x4,%esp
  801ea9:	8b 45 10             	mov    0x10(%ebp),%eax
  801eac:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801eaf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801eb2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	6a 00                	push   $0x0
  801ebb:	51                   	push   %ecx
  801ebc:	52                   	push   %edx
  801ebd:	ff 75 0c             	pushl  0xc(%ebp)
  801ec0:	50                   	push   %eax
  801ec1:	6a 1b                	push   $0x1b
  801ec3:	e8 19 fd ff ff       	call   801be1 <syscall>
  801ec8:	83 c4 18             	add    $0x18,%esp
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	52                   	push   %edx
  801edd:	50                   	push   %eax
  801ede:	6a 1c                	push   $0x1c
  801ee0:	e8 fc fc ff ff       	call   801be1 <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801eed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	51                   	push   %ecx
  801efb:	52                   	push   %edx
  801efc:	50                   	push   %eax
  801efd:	6a 1d                	push   $0x1d
  801eff:	e8 dd fc ff ff       	call   801be1 <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	52                   	push   %edx
  801f19:	50                   	push   %eax
  801f1a:	6a 1e                	push   $0x1e
  801f1c:	e8 c0 fc ff ff       	call   801be1 <syscall>
  801f21:	83 c4 18             	add    $0x18,%esp
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 1f                	push   $0x1f
  801f35:	e8 a7 fc ff ff       	call   801be1 <syscall>
  801f3a:	83 c4 18             	add    $0x18,%esp
}
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	6a 00                	push   $0x0
  801f47:	ff 75 14             	pushl  0x14(%ebp)
  801f4a:	ff 75 10             	pushl  0x10(%ebp)
  801f4d:	ff 75 0c             	pushl  0xc(%ebp)
  801f50:	50                   	push   %eax
  801f51:	6a 20                	push   $0x20
  801f53:	e8 89 fc ff ff       	call   801be1 <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	50                   	push   %eax
  801f6c:	6a 21                	push   $0x21
  801f6e:	e8 6e fc ff ff       	call   801be1 <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
}
  801f76:	90                   	nop
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	50                   	push   %eax
  801f88:	6a 22                	push   $0x22
  801f8a:	e8 52 fc ff ff       	call   801be1 <syscall>
  801f8f:	83 c4 18             	add    $0x18,%esp
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 02                	push   $0x2
  801fa3:	e8 39 fc ff ff       	call   801be1 <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 03                	push   $0x3
  801fbc:	e8 20 fc ff ff       	call   801be1 <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 04                	push   $0x4
  801fd5:	e8 07 fc ff ff       	call   801be1 <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_exit_env>:


void sys_exit_env(void)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 23                	push   $0x23
  801fee:	e8 ee fb ff ff       	call   801be1 <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
}
  801ff6:	90                   	nop
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802002:	8d 50 04             	lea    0x4(%eax),%edx
  802005:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	52                   	push   %edx
  80200f:	50                   	push   %eax
  802010:	6a 24                	push   $0x24
  802012:	e8 ca fb ff ff       	call   801be1 <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
	return result;
  80201a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80201d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802020:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802023:	89 01                	mov    %eax,(%ecx)
  802025:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	c9                   	leave  
  80202c:	c2 04 00             	ret    $0x4

0080202f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	ff 75 10             	pushl  0x10(%ebp)
  802039:	ff 75 0c             	pushl  0xc(%ebp)
  80203c:	ff 75 08             	pushl  0x8(%ebp)
  80203f:	6a 12                	push   $0x12
  802041:	e8 9b fb ff ff       	call   801be1 <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
	return ;
  802049:	90                   	nop
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <sys_rcr2>:
uint32 sys_rcr2()
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 25                	push   $0x25
  80205b:	e8 81 fb ff ff       	call   801be1 <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 04             	sub    $0x4,%esp
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802071:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	50                   	push   %eax
  80207e:	6a 26                	push   $0x26
  802080:	e8 5c fb ff ff       	call   801be1 <syscall>
  802085:	83 c4 18             	add    $0x18,%esp
	return ;
  802088:	90                   	nop
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <rsttst>:
void rsttst()
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 28                	push   $0x28
  80209a:	e8 42 fb ff ff       	call   801be1 <syscall>
  80209f:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a2:	90                   	nop
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 04             	sub    $0x4,%esp
  8020ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8020ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020b1:	8b 55 18             	mov    0x18(%ebp),%edx
  8020b4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020b8:	52                   	push   %edx
  8020b9:	50                   	push   %eax
  8020ba:	ff 75 10             	pushl  0x10(%ebp)
  8020bd:	ff 75 0c             	pushl  0xc(%ebp)
  8020c0:	ff 75 08             	pushl  0x8(%ebp)
  8020c3:	6a 27                	push   $0x27
  8020c5:	e8 17 fb ff ff       	call   801be1 <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8020cd:	90                   	nop
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <chktst>:
void chktst(uint32 n)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	ff 75 08             	pushl  0x8(%ebp)
  8020de:	6a 29                	push   $0x29
  8020e0:	e8 fc fa ff ff       	call   801be1 <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e8:	90                   	nop
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <inctst>:

void inctst()
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 2a                	push   $0x2a
  8020fa:	e8 e2 fa ff ff       	call   801be1 <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802102:	90                   	nop
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <gettst>:
uint32 gettst()
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 2b                	push   $0x2b
  802114:	e8 c8 fa ff ff       	call   801be1 <syscall>
  802119:	83 c4 18             	add    $0x18,%esp
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 2c                	push   $0x2c
  802130:	e8 ac fa ff ff       	call   801be1 <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
  802138:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80213b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80213f:	75 07                	jne    802148 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802141:	b8 01 00 00 00       	mov    $0x1,%eax
  802146:	eb 05                	jmp    80214d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802148:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 2c                	push   $0x2c
  802161:	e8 7b fa ff ff       	call   801be1 <syscall>
  802166:	83 c4 18             	add    $0x18,%esp
  802169:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80216c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802170:	75 07                	jne    802179 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802172:	b8 01 00 00 00       	mov    $0x1,%eax
  802177:	eb 05                	jmp    80217e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802179:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 2c                	push   $0x2c
  802192:	e8 4a fa ff ff       	call   801be1 <syscall>
  802197:	83 c4 18             	add    $0x18,%esp
  80219a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80219d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021a1:	75 07                	jne    8021aa <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a8:	eb 05                	jmp    8021af <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 2c                	push   $0x2c
  8021c3:	e8 19 fa ff ff       	call   801be1 <syscall>
  8021c8:	83 c4 18             	add    $0x18,%esp
  8021cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021ce:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021d2:	75 07                	jne    8021db <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d9:	eb 05                	jmp    8021e0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	ff 75 08             	pushl  0x8(%ebp)
  8021f0:	6a 2d                	push   $0x2d
  8021f2:	e8 ea f9 ff ff       	call   801be1 <syscall>
  8021f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021fa:	90                   	nop
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802201:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802204:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802207:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	6a 00                	push   $0x0
  80220f:	53                   	push   %ebx
  802210:	51                   	push   %ecx
  802211:	52                   	push   %edx
  802212:	50                   	push   %eax
  802213:	6a 2e                	push   $0x2e
  802215:	e8 c7 f9 ff ff       	call   801be1 <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
}
  80221d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802225:	8b 55 0c             	mov    0xc(%ebp),%edx
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	52                   	push   %edx
  802232:	50                   	push   %eax
  802233:	6a 2f                	push   $0x2f
  802235:	e8 a7 f9 ff ff       	call   801be1 <syscall>
  80223a:	83 c4 18             	add    $0x18,%esp
}
  80223d:	c9                   	leave  
  80223e:	c3                   	ret    

0080223f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
  802242:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802245:	83 ec 0c             	sub    $0xc,%esp
  802248:	68 28 43 80 00       	push   $0x804328
  80224d:	e8 1e e8 ff ff       	call   800a70 <cprintf>
  802252:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802255:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80225c:	83 ec 0c             	sub    $0xc,%esp
  80225f:	68 54 43 80 00       	push   $0x804354
  802264:	e8 07 e8 ff ff       	call   800a70 <cprintf>
  802269:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80226c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802270:	a1 38 51 80 00       	mov    0x805138,%eax
  802275:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802278:	eb 56                	jmp    8022d0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80227a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80227e:	74 1c                	je     80229c <print_mem_block_lists+0x5d>
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	8b 50 08             	mov    0x8(%eax),%edx
  802286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802289:	8b 48 08             	mov    0x8(%eax),%ecx
  80228c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228f:	8b 40 0c             	mov    0xc(%eax),%eax
  802292:	01 c8                	add    %ecx,%eax
  802294:	39 c2                	cmp    %eax,%edx
  802296:	73 04                	jae    80229c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802298:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80229c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229f:	8b 50 08             	mov    0x8(%eax),%edx
  8022a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8022a8:	01 c2                	add    %eax,%edx
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 40 08             	mov    0x8(%eax),%eax
  8022b0:	83 ec 04             	sub    $0x4,%esp
  8022b3:	52                   	push   %edx
  8022b4:	50                   	push   %eax
  8022b5:	68 69 43 80 00       	push   $0x804369
  8022ba:	e8 b1 e7 ff ff       	call   800a70 <cprintf>
  8022bf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022c8:	a1 40 51 80 00       	mov    0x805140,%eax
  8022cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d4:	74 07                	je     8022dd <print_mem_block_lists+0x9e>
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	8b 00                	mov    (%eax),%eax
  8022db:	eb 05                	jmp    8022e2 <print_mem_block_lists+0xa3>
  8022dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e2:	a3 40 51 80 00       	mov    %eax,0x805140
  8022e7:	a1 40 51 80 00       	mov    0x805140,%eax
  8022ec:	85 c0                	test   %eax,%eax
  8022ee:	75 8a                	jne    80227a <print_mem_block_lists+0x3b>
  8022f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f4:	75 84                	jne    80227a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8022f6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022fa:	75 10                	jne    80230c <print_mem_block_lists+0xcd>
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	68 78 43 80 00       	push   $0x804378
  802304:	e8 67 e7 ff ff       	call   800a70 <cprintf>
  802309:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80230c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802313:	83 ec 0c             	sub    $0xc,%esp
  802316:	68 9c 43 80 00       	push   $0x80439c
  80231b:	e8 50 e7 ff ff       	call   800a70 <cprintf>
  802320:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802323:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802327:	a1 40 50 80 00       	mov    0x805040,%eax
  80232c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232f:	eb 56                	jmp    802387 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802331:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802335:	74 1c                	je     802353 <print_mem_block_lists+0x114>
  802337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233a:	8b 50 08             	mov    0x8(%eax),%edx
  80233d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802340:	8b 48 08             	mov    0x8(%eax),%ecx
  802343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802346:	8b 40 0c             	mov    0xc(%eax),%eax
  802349:	01 c8                	add    %ecx,%eax
  80234b:	39 c2                	cmp    %eax,%edx
  80234d:	73 04                	jae    802353 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80234f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802356:	8b 50 08             	mov    0x8(%eax),%edx
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 40 0c             	mov    0xc(%eax),%eax
  80235f:	01 c2                	add    %eax,%edx
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	8b 40 08             	mov    0x8(%eax),%eax
  802367:	83 ec 04             	sub    $0x4,%esp
  80236a:	52                   	push   %edx
  80236b:	50                   	push   %eax
  80236c:	68 69 43 80 00       	push   $0x804369
  802371:	e8 fa e6 ff ff       	call   800a70 <cprintf>
  802376:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80237f:	a1 48 50 80 00       	mov    0x805048,%eax
  802384:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802387:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238b:	74 07                	je     802394 <print_mem_block_lists+0x155>
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	8b 00                	mov    (%eax),%eax
  802392:	eb 05                	jmp    802399 <print_mem_block_lists+0x15a>
  802394:	b8 00 00 00 00       	mov    $0x0,%eax
  802399:	a3 48 50 80 00       	mov    %eax,0x805048
  80239e:	a1 48 50 80 00       	mov    0x805048,%eax
  8023a3:	85 c0                	test   %eax,%eax
  8023a5:	75 8a                	jne    802331 <print_mem_block_lists+0xf2>
  8023a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ab:	75 84                	jne    802331 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8023ad:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023b1:	75 10                	jne    8023c3 <print_mem_block_lists+0x184>
  8023b3:	83 ec 0c             	sub    $0xc,%esp
  8023b6:	68 b4 43 80 00       	push   $0x8043b4
  8023bb:	e8 b0 e6 ff ff       	call   800a70 <cprintf>
  8023c0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8023c3:	83 ec 0c             	sub    $0xc,%esp
  8023c6:	68 28 43 80 00       	push   $0x804328
  8023cb:	e8 a0 e6 ff ff       	call   800a70 <cprintf>
  8023d0:	83 c4 10             	add    $0x10,%esp

}
  8023d3:	90                   	nop
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8023dc:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8023e3:	00 00 00 
  8023e6:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8023ed:	00 00 00 
  8023f0:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8023f7:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8023fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802401:	e9 9e 00 00 00       	jmp    8024a4 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802406:	a1 50 50 80 00       	mov    0x805050,%eax
  80240b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240e:	c1 e2 04             	shl    $0x4,%edx
  802411:	01 d0                	add    %edx,%eax
  802413:	85 c0                	test   %eax,%eax
  802415:	75 14                	jne    80242b <initialize_MemBlocksList+0x55>
  802417:	83 ec 04             	sub    $0x4,%esp
  80241a:	68 dc 43 80 00       	push   $0x8043dc
  80241f:	6a 46                	push   $0x46
  802421:	68 ff 43 80 00       	push   $0x8043ff
  802426:	e8 91 e3 ff ff       	call   8007bc <_panic>
  80242b:	a1 50 50 80 00       	mov    0x805050,%eax
  802430:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802433:	c1 e2 04             	shl    $0x4,%edx
  802436:	01 d0                	add    %edx,%eax
  802438:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80243e:	89 10                	mov    %edx,(%eax)
  802440:	8b 00                	mov    (%eax),%eax
  802442:	85 c0                	test   %eax,%eax
  802444:	74 18                	je     80245e <initialize_MemBlocksList+0x88>
  802446:	a1 48 51 80 00       	mov    0x805148,%eax
  80244b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802451:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802454:	c1 e1 04             	shl    $0x4,%ecx
  802457:	01 ca                	add    %ecx,%edx
  802459:	89 50 04             	mov    %edx,0x4(%eax)
  80245c:	eb 12                	jmp    802470 <initialize_MemBlocksList+0x9a>
  80245e:	a1 50 50 80 00       	mov    0x805050,%eax
  802463:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802466:	c1 e2 04             	shl    $0x4,%edx
  802469:	01 d0                	add    %edx,%eax
  80246b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802470:	a1 50 50 80 00       	mov    0x805050,%eax
  802475:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802478:	c1 e2 04             	shl    $0x4,%edx
  80247b:	01 d0                	add    %edx,%eax
  80247d:	a3 48 51 80 00       	mov    %eax,0x805148
  802482:	a1 50 50 80 00       	mov    0x805050,%eax
  802487:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248a:	c1 e2 04             	shl    $0x4,%edx
  80248d:	01 d0                	add    %edx,%eax
  80248f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802496:	a1 54 51 80 00       	mov    0x805154,%eax
  80249b:	40                   	inc    %eax
  80249c:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8024a1:	ff 45 f4             	incl   -0xc(%ebp)
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024aa:	0f 82 56 ff ff ff    	jb     802406 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8024b0:	90                   	nop
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
  8024b6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024c1:	eb 19                	jmp    8024dc <find_block+0x29>
	{
		if(va==point->sva)
  8024c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c6:	8b 40 08             	mov    0x8(%eax),%eax
  8024c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8024cc:	75 05                	jne    8024d3 <find_block+0x20>
		   return point;
  8024ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024d1:	eb 36                	jmp    802509 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8024d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d6:	8b 40 08             	mov    0x8(%eax),%eax
  8024d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024e0:	74 07                	je     8024e9 <find_block+0x36>
  8024e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024e5:	8b 00                	mov    (%eax),%eax
  8024e7:	eb 05                	jmp    8024ee <find_block+0x3b>
  8024e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f1:	89 42 08             	mov    %eax,0x8(%edx)
  8024f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f7:	8b 40 08             	mov    0x8(%eax),%eax
  8024fa:	85 c0                	test   %eax,%eax
  8024fc:	75 c5                	jne    8024c3 <find_block+0x10>
  8024fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802502:	75 bf                	jne    8024c3 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802504:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802509:	c9                   	leave  
  80250a:	c3                   	ret    

0080250b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
  80250e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802511:	a1 40 50 80 00       	mov    0x805040,%eax
  802516:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802519:	a1 44 50 80 00       	mov    0x805044,%eax
  80251e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802521:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802524:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802527:	74 24                	je     80254d <insert_sorted_allocList+0x42>
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	8b 50 08             	mov    0x8(%eax),%edx
  80252f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802532:	8b 40 08             	mov    0x8(%eax),%eax
  802535:	39 c2                	cmp    %eax,%edx
  802537:	76 14                	jbe    80254d <insert_sorted_allocList+0x42>
  802539:	8b 45 08             	mov    0x8(%ebp),%eax
  80253c:	8b 50 08             	mov    0x8(%eax),%edx
  80253f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802542:	8b 40 08             	mov    0x8(%eax),%eax
  802545:	39 c2                	cmp    %eax,%edx
  802547:	0f 82 60 01 00 00    	jb     8026ad <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80254d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802551:	75 65                	jne    8025b8 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802553:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802557:	75 14                	jne    80256d <insert_sorted_allocList+0x62>
  802559:	83 ec 04             	sub    $0x4,%esp
  80255c:	68 dc 43 80 00       	push   $0x8043dc
  802561:	6a 6b                	push   $0x6b
  802563:	68 ff 43 80 00       	push   $0x8043ff
  802568:	e8 4f e2 ff ff       	call   8007bc <_panic>
  80256d:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802573:	8b 45 08             	mov    0x8(%ebp),%eax
  802576:	89 10                	mov    %edx,(%eax)
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	8b 00                	mov    (%eax),%eax
  80257d:	85 c0                	test   %eax,%eax
  80257f:	74 0d                	je     80258e <insert_sorted_allocList+0x83>
  802581:	a1 40 50 80 00       	mov    0x805040,%eax
  802586:	8b 55 08             	mov    0x8(%ebp),%edx
  802589:	89 50 04             	mov    %edx,0x4(%eax)
  80258c:	eb 08                	jmp    802596 <insert_sorted_allocList+0x8b>
  80258e:	8b 45 08             	mov    0x8(%ebp),%eax
  802591:	a3 44 50 80 00       	mov    %eax,0x805044
  802596:	8b 45 08             	mov    0x8(%ebp),%eax
  802599:	a3 40 50 80 00       	mov    %eax,0x805040
  80259e:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025ad:	40                   	inc    %eax
  8025ae:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025b3:	e9 dc 01 00 00       	jmp    802794 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8025b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bb:	8b 50 08             	mov    0x8(%eax),%edx
  8025be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c1:	8b 40 08             	mov    0x8(%eax),%eax
  8025c4:	39 c2                	cmp    %eax,%edx
  8025c6:	77 6c                	ja     802634 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8025c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025cc:	74 06                	je     8025d4 <insert_sorted_allocList+0xc9>
  8025ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025d2:	75 14                	jne    8025e8 <insert_sorted_allocList+0xdd>
  8025d4:	83 ec 04             	sub    $0x4,%esp
  8025d7:	68 18 44 80 00       	push   $0x804418
  8025dc:	6a 6f                	push   $0x6f
  8025de:	68 ff 43 80 00       	push   $0x8043ff
  8025e3:	e8 d4 e1 ff ff       	call   8007bc <_panic>
  8025e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025eb:	8b 50 04             	mov    0x4(%eax),%edx
  8025ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f1:	89 50 04             	mov    %edx,0x4(%eax)
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025fa:	89 10                	mov    %edx,(%eax)
  8025fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ff:	8b 40 04             	mov    0x4(%eax),%eax
  802602:	85 c0                	test   %eax,%eax
  802604:	74 0d                	je     802613 <insert_sorted_allocList+0x108>
  802606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802609:	8b 40 04             	mov    0x4(%eax),%eax
  80260c:	8b 55 08             	mov    0x8(%ebp),%edx
  80260f:	89 10                	mov    %edx,(%eax)
  802611:	eb 08                	jmp    80261b <insert_sorted_allocList+0x110>
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	a3 40 50 80 00       	mov    %eax,0x805040
  80261b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261e:	8b 55 08             	mov    0x8(%ebp),%edx
  802621:	89 50 04             	mov    %edx,0x4(%eax)
  802624:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802629:	40                   	inc    %eax
  80262a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80262f:	e9 60 01 00 00       	jmp    802794 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802634:	8b 45 08             	mov    0x8(%ebp),%eax
  802637:	8b 50 08             	mov    0x8(%eax),%edx
  80263a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263d:	8b 40 08             	mov    0x8(%eax),%eax
  802640:	39 c2                	cmp    %eax,%edx
  802642:	0f 82 4c 01 00 00    	jb     802794 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802648:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80264c:	75 14                	jne    802662 <insert_sorted_allocList+0x157>
  80264e:	83 ec 04             	sub    $0x4,%esp
  802651:	68 50 44 80 00       	push   $0x804450
  802656:	6a 73                	push   $0x73
  802658:	68 ff 43 80 00       	push   $0x8043ff
  80265d:	e8 5a e1 ff ff       	call   8007bc <_panic>
  802662:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802668:	8b 45 08             	mov    0x8(%ebp),%eax
  80266b:	89 50 04             	mov    %edx,0x4(%eax)
  80266e:	8b 45 08             	mov    0x8(%ebp),%eax
  802671:	8b 40 04             	mov    0x4(%eax),%eax
  802674:	85 c0                	test   %eax,%eax
  802676:	74 0c                	je     802684 <insert_sorted_allocList+0x179>
  802678:	a1 44 50 80 00       	mov    0x805044,%eax
  80267d:	8b 55 08             	mov    0x8(%ebp),%edx
  802680:	89 10                	mov    %edx,(%eax)
  802682:	eb 08                	jmp    80268c <insert_sorted_allocList+0x181>
  802684:	8b 45 08             	mov    0x8(%ebp),%eax
  802687:	a3 40 50 80 00       	mov    %eax,0x805040
  80268c:	8b 45 08             	mov    0x8(%ebp),%eax
  80268f:	a3 44 50 80 00       	mov    %eax,0x805044
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80269d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026a2:	40                   	inc    %eax
  8026a3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026a8:	e9 e7 00 00 00       	jmp    802794 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8026ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8026b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8026ba:	a1 40 50 80 00       	mov    0x805040,%eax
  8026bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c2:	e9 9d 00 00 00       	jmp    802764 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8026cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d2:	8b 50 08             	mov    0x8(%eax),%edx
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 40 08             	mov    0x8(%eax),%eax
  8026db:	39 c2                	cmp    %eax,%edx
  8026dd:	76 7d                	jbe    80275c <insert_sorted_allocList+0x251>
  8026df:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e2:	8b 50 08             	mov    0x8(%eax),%edx
  8026e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e8:	8b 40 08             	mov    0x8(%eax),%eax
  8026eb:	39 c2                	cmp    %eax,%edx
  8026ed:	73 6d                	jae    80275c <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8026ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f3:	74 06                	je     8026fb <insert_sorted_allocList+0x1f0>
  8026f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026f9:	75 14                	jne    80270f <insert_sorted_allocList+0x204>
  8026fb:	83 ec 04             	sub    $0x4,%esp
  8026fe:	68 74 44 80 00       	push   $0x804474
  802703:	6a 7f                	push   $0x7f
  802705:	68 ff 43 80 00       	push   $0x8043ff
  80270a:	e8 ad e0 ff ff       	call   8007bc <_panic>
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 10                	mov    (%eax),%edx
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	89 10                	mov    %edx,(%eax)
  802719:	8b 45 08             	mov    0x8(%ebp),%eax
  80271c:	8b 00                	mov    (%eax),%eax
  80271e:	85 c0                	test   %eax,%eax
  802720:	74 0b                	je     80272d <insert_sorted_allocList+0x222>
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 00                	mov    (%eax),%eax
  802727:	8b 55 08             	mov    0x8(%ebp),%edx
  80272a:	89 50 04             	mov    %edx,0x4(%eax)
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	8b 55 08             	mov    0x8(%ebp),%edx
  802733:	89 10                	mov    %edx,(%eax)
  802735:	8b 45 08             	mov    0x8(%ebp),%eax
  802738:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273b:	89 50 04             	mov    %edx,0x4(%eax)
  80273e:	8b 45 08             	mov    0x8(%ebp),%eax
  802741:	8b 00                	mov    (%eax),%eax
  802743:	85 c0                	test   %eax,%eax
  802745:	75 08                	jne    80274f <insert_sorted_allocList+0x244>
  802747:	8b 45 08             	mov    0x8(%ebp),%eax
  80274a:	a3 44 50 80 00       	mov    %eax,0x805044
  80274f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802754:	40                   	inc    %eax
  802755:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80275a:	eb 39                	jmp    802795 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80275c:	a1 48 50 80 00       	mov    0x805048,%eax
  802761:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802764:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802768:	74 07                	je     802771 <insert_sorted_allocList+0x266>
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	8b 00                	mov    (%eax),%eax
  80276f:	eb 05                	jmp    802776 <insert_sorted_allocList+0x26b>
  802771:	b8 00 00 00 00       	mov    $0x0,%eax
  802776:	a3 48 50 80 00       	mov    %eax,0x805048
  80277b:	a1 48 50 80 00       	mov    0x805048,%eax
  802780:	85 c0                	test   %eax,%eax
  802782:	0f 85 3f ff ff ff    	jne    8026c7 <insert_sorted_allocList+0x1bc>
  802788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278c:	0f 85 35 ff ff ff    	jne    8026c7 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802792:	eb 01                	jmp    802795 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802794:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802795:	90                   	nop
  802796:	c9                   	leave  
  802797:	c3                   	ret    

00802798 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
  80279b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80279e:	a1 38 51 80 00       	mov    0x805138,%eax
  8027a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a6:	e9 85 01 00 00       	jmp    802930 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b4:	0f 82 6e 01 00 00    	jb     802928 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027c3:	0f 85 8a 00 00 00    	jne    802853 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8027c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027cd:	75 17                	jne    8027e6 <alloc_block_FF+0x4e>
  8027cf:	83 ec 04             	sub    $0x4,%esp
  8027d2:	68 a8 44 80 00       	push   $0x8044a8
  8027d7:	68 93 00 00 00       	push   $0x93
  8027dc:	68 ff 43 80 00       	push   $0x8043ff
  8027e1:	e8 d6 df ff ff       	call   8007bc <_panic>
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 00                	mov    (%eax),%eax
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	74 10                	je     8027ff <alloc_block_FF+0x67>
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 00                	mov    (%eax),%eax
  8027f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f7:	8b 52 04             	mov    0x4(%edx),%edx
  8027fa:	89 50 04             	mov    %edx,0x4(%eax)
  8027fd:	eb 0b                	jmp    80280a <alloc_block_FF+0x72>
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 40 04             	mov    0x4(%eax),%eax
  802805:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 40 04             	mov    0x4(%eax),%eax
  802810:	85 c0                	test   %eax,%eax
  802812:	74 0f                	je     802823 <alloc_block_FF+0x8b>
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 40 04             	mov    0x4(%eax),%eax
  80281a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80281d:	8b 12                	mov    (%edx),%edx
  80281f:	89 10                	mov    %edx,(%eax)
  802821:	eb 0a                	jmp    80282d <alloc_block_FF+0x95>
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	a3 38 51 80 00       	mov    %eax,0x805138
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802839:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802840:	a1 44 51 80 00       	mov    0x805144,%eax
  802845:	48                   	dec    %eax
  802846:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	e9 10 01 00 00       	jmp    802963 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 40 0c             	mov    0xc(%eax),%eax
  802859:	3b 45 08             	cmp    0x8(%ebp),%eax
  80285c:	0f 86 c6 00 00 00    	jbe    802928 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802862:	a1 48 51 80 00       	mov    0x805148,%eax
  802867:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 50 08             	mov    0x8(%eax),%edx
  802870:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802873:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802879:	8b 55 08             	mov    0x8(%ebp),%edx
  80287c:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80287f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802883:	75 17                	jne    80289c <alloc_block_FF+0x104>
  802885:	83 ec 04             	sub    $0x4,%esp
  802888:	68 a8 44 80 00       	push   $0x8044a8
  80288d:	68 9b 00 00 00       	push   $0x9b
  802892:	68 ff 43 80 00       	push   $0x8043ff
  802897:	e8 20 df ff ff       	call   8007bc <_panic>
  80289c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289f:	8b 00                	mov    (%eax),%eax
  8028a1:	85 c0                	test   %eax,%eax
  8028a3:	74 10                	je     8028b5 <alloc_block_FF+0x11d>
  8028a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ad:	8b 52 04             	mov    0x4(%edx),%edx
  8028b0:	89 50 04             	mov    %edx,0x4(%eax)
  8028b3:	eb 0b                	jmp    8028c0 <alloc_block_FF+0x128>
  8028b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b8:	8b 40 04             	mov    0x4(%eax),%eax
  8028bb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c3:	8b 40 04             	mov    0x4(%eax),%eax
  8028c6:	85 c0                	test   %eax,%eax
  8028c8:	74 0f                	je     8028d9 <alloc_block_FF+0x141>
  8028ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cd:	8b 40 04             	mov    0x4(%eax),%eax
  8028d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028d3:	8b 12                	mov    (%edx),%edx
  8028d5:	89 10                	mov    %edx,(%eax)
  8028d7:	eb 0a                	jmp    8028e3 <alloc_block_FF+0x14b>
  8028d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dc:	8b 00                	mov    (%eax),%eax
  8028de:	a3 48 51 80 00       	mov    %eax,0x805148
  8028e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f6:	a1 54 51 80 00       	mov    0x805154,%eax
  8028fb:	48                   	dec    %eax
  8028fc:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	8b 50 08             	mov    0x8(%eax),%edx
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	01 c2                	add    %eax,%edx
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 40 0c             	mov    0xc(%eax),%eax
  802918:	2b 45 08             	sub    0x8(%ebp),%eax
  80291b:	89 c2                	mov    %eax,%edx
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802926:	eb 3b                	jmp    802963 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802928:	a1 40 51 80 00       	mov    0x805140,%eax
  80292d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802930:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802934:	74 07                	je     80293d <alloc_block_FF+0x1a5>
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 00                	mov    (%eax),%eax
  80293b:	eb 05                	jmp    802942 <alloc_block_FF+0x1aa>
  80293d:	b8 00 00 00 00       	mov    $0x0,%eax
  802942:	a3 40 51 80 00       	mov    %eax,0x805140
  802947:	a1 40 51 80 00       	mov    0x805140,%eax
  80294c:	85 c0                	test   %eax,%eax
  80294e:	0f 85 57 fe ff ff    	jne    8027ab <alloc_block_FF+0x13>
  802954:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802958:	0f 85 4d fe ff ff    	jne    8027ab <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80295e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802963:	c9                   	leave  
  802964:	c3                   	ret    

00802965 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802965:	55                   	push   %ebp
  802966:	89 e5                	mov    %esp,%ebp
  802968:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80296b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802972:	a1 38 51 80 00       	mov    0x805138,%eax
  802977:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297a:	e9 df 00 00 00       	jmp    802a5e <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 40 0c             	mov    0xc(%eax),%eax
  802985:	3b 45 08             	cmp    0x8(%ebp),%eax
  802988:	0f 82 c8 00 00 00    	jb     802a56 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 40 0c             	mov    0xc(%eax),%eax
  802994:	3b 45 08             	cmp    0x8(%ebp),%eax
  802997:	0f 85 8a 00 00 00    	jne    802a27 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80299d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a1:	75 17                	jne    8029ba <alloc_block_BF+0x55>
  8029a3:	83 ec 04             	sub    $0x4,%esp
  8029a6:	68 a8 44 80 00       	push   $0x8044a8
  8029ab:	68 b7 00 00 00       	push   $0xb7
  8029b0:	68 ff 43 80 00       	push   $0x8043ff
  8029b5:	e8 02 de ff ff       	call   8007bc <_panic>
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	85 c0                	test   %eax,%eax
  8029c1:	74 10                	je     8029d3 <alloc_block_BF+0x6e>
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	8b 00                	mov    (%eax),%eax
  8029c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029cb:	8b 52 04             	mov    0x4(%edx),%edx
  8029ce:	89 50 04             	mov    %edx,0x4(%eax)
  8029d1:	eb 0b                	jmp    8029de <alloc_block_BF+0x79>
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	8b 40 04             	mov    0x4(%eax),%eax
  8029d9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	8b 40 04             	mov    0x4(%eax),%eax
  8029e4:	85 c0                	test   %eax,%eax
  8029e6:	74 0f                	je     8029f7 <alloc_block_BF+0x92>
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	8b 40 04             	mov    0x4(%eax),%eax
  8029ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f1:	8b 12                	mov    (%edx),%edx
  8029f3:	89 10                	mov    %edx,(%eax)
  8029f5:	eb 0a                	jmp    802a01 <alloc_block_BF+0x9c>
  8029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fa:	8b 00                	mov    (%eax),%eax
  8029fc:	a3 38 51 80 00       	mov    %eax,0x805138
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a14:	a1 44 51 80 00       	mov    0x805144,%eax
  802a19:	48                   	dec    %eax
  802a1a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	e9 4d 01 00 00       	jmp    802b74 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a30:	76 24                	jbe    802a56 <alloc_block_BF+0xf1>
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 40 0c             	mov    0xc(%eax),%eax
  802a38:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a3b:	73 19                	jae    802a56 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802a3d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 40 08             	mov    0x8(%eax),%eax
  802a53:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a56:	a1 40 51 80 00       	mov    0x805140,%eax
  802a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a62:	74 07                	je     802a6b <alloc_block_BF+0x106>
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	eb 05                	jmp    802a70 <alloc_block_BF+0x10b>
  802a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a70:	a3 40 51 80 00       	mov    %eax,0x805140
  802a75:	a1 40 51 80 00       	mov    0x805140,%eax
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	0f 85 fd fe ff ff    	jne    80297f <alloc_block_BF+0x1a>
  802a82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a86:	0f 85 f3 fe ff ff    	jne    80297f <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802a8c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a90:	0f 84 d9 00 00 00    	je     802b6f <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a96:	a1 48 51 80 00       	mov    0x805148,%eax
  802a9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802a9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aa4:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802aa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aaa:	8b 55 08             	mov    0x8(%ebp),%edx
  802aad:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802ab0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ab4:	75 17                	jne    802acd <alloc_block_BF+0x168>
  802ab6:	83 ec 04             	sub    $0x4,%esp
  802ab9:	68 a8 44 80 00       	push   $0x8044a8
  802abe:	68 c7 00 00 00       	push   $0xc7
  802ac3:	68 ff 43 80 00       	push   $0x8043ff
  802ac8:	e8 ef dc ff ff       	call   8007bc <_panic>
  802acd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad0:	8b 00                	mov    (%eax),%eax
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	74 10                	je     802ae6 <alloc_block_BF+0x181>
  802ad6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad9:	8b 00                	mov    (%eax),%eax
  802adb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ade:	8b 52 04             	mov    0x4(%edx),%edx
  802ae1:	89 50 04             	mov    %edx,0x4(%eax)
  802ae4:	eb 0b                	jmp    802af1 <alloc_block_BF+0x18c>
  802ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae9:	8b 40 04             	mov    0x4(%eax),%eax
  802aec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802af1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af4:	8b 40 04             	mov    0x4(%eax),%eax
  802af7:	85 c0                	test   %eax,%eax
  802af9:	74 0f                	je     802b0a <alloc_block_BF+0x1a5>
  802afb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802afe:	8b 40 04             	mov    0x4(%eax),%eax
  802b01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b04:	8b 12                	mov    (%edx),%edx
  802b06:	89 10                	mov    %edx,(%eax)
  802b08:	eb 0a                	jmp    802b14 <alloc_block_BF+0x1af>
  802b0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b0d:	8b 00                	mov    (%eax),%eax
  802b0f:	a3 48 51 80 00       	mov    %eax,0x805148
  802b14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b27:	a1 54 51 80 00       	mov    0x805154,%eax
  802b2c:	48                   	dec    %eax
  802b2d:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802b32:	83 ec 08             	sub    $0x8,%esp
  802b35:	ff 75 ec             	pushl  -0x14(%ebp)
  802b38:	68 38 51 80 00       	push   $0x805138
  802b3d:	e8 71 f9 ff ff       	call   8024b3 <find_block>
  802b42:	83 c4 10             	add    $0x10,%esp
  802b45:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802b48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b4b:	8b 50 08             	mov    0x8(%eax),%edx
  802b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b51:	01 c2                	add    %eax,%edx
  802b53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b56:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802b59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5f:	2b 45 08             	sub    0x8(%ebp),%eax
  802b62:	89 c2                	mov    %eax,%edx
  802b64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b67:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802b6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b6d:	eb 05                	jmp    802b74 <alloc_block_BF+0x20f>
	}
	return NULL;
  802b6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b74:	c9                   	leave  
  802b75:	c3                   	ret    

00802b76 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802b76:	55                   	push   %ebp
  802b77:	89 e5                	mov    %esp,%ebp
  802b79:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802b7c:	a1 28 50 80 00       	mov    0x805028,%eax
  802b81:	85 c0                	test   %eax,%eax
  802b83:	0f 85 de 01 00 00    	jne    802d67 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b89:	a1 38 51 80 00       	mov    0x805138,%eax
  802b8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b91:	e9 9e 01 00 00       	jmp    802d34 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b9f:	0f 82 87 01 00 00    	jb     802d2c <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bab:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bae:	0f 85 95 00 00 00    	jne    802c49 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802bb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb8:	75 17                	jne    802bd1 <alloc_block_NF+0x5b>
  802bba:	83 ec 04             	sub    $0x4,%esp
  802bbd:	68 a8 44 80 00       	push   $0x8044a8
  802bc2:	68 e0 00 00 00       	push   $0xe0
  802bc7:	68 ff 43 80 00       	push   $0x8043ff
  802bcc:	e8 eb db ff ff       	call   8007bc <_panic>
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	8b 00                	mov    (%eax),%eax
  802bd6:	85 c0                	test   %eax,%eax
  802bd8:	74 10                	je     802bea <alloc_block_NF+0x74>
  802bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdd:	8b 00                	mov    (%eax),%eax
  802bdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be2:	8b 52 04             	mov    0x4(%edx),%edx
  802be5:	89 50 04             	mov    %edx,0x4(%eax)
  802be8:	eb 0b                	jmp    802bf5 <alloc_block_NF+0x7f>
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	8b 40 04             	mov    0x4(%eax),%eax
  802bf0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 40 04             	mov    0x4(%eax),%eax
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	74 0f                	je     802c0e <alloc_block_NF+0x98>
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	8b 40 04             	mov    0x4(%eax),%eax
  802c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c08:	8b 12                	mov    (%edx),%edx
  802c0a:	89 10                	mov    %edx,(%eax)
  802c0c:	eb 0a                	jmp    802c18 <alloc_block_NF+0xa2>
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 00                	mov    (%eax),%eax
  802c13:	a3 38 51 80 00       	mov    %eax,0x805138
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2b:	a1 44 51 80 00       	mov    0x805144,%eax
  802c30:	48                   	dec    %eax
  802c31:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	8b 40 08             	mov    0x8(%eax),%eax
  802c3c:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	e9 f8 04 00 00       	jmp    803141 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c52:	0f 86 d4 00 00 00    	jbe    802d2c <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c58:	a1 48 51 80 00       	mov    0x805148,%eax
  802c5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	8b 50 08             	mov    0x8(%eax),%edx
  802c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c69:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c72:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c79:	75 17                	jne    802c92 <alloc_block_NF+0x11c>
  802c7b:	83 ec 04             	sub    $0x4,%esp
  802c7e:	68 a8 44 80 00       	push   $0x8044a8
  802c83:	68 e9 00 00 00       	push   $0xe9
  802c88:	68 ff 43 80 00       	push   $0x8043ff
  802c8d:	e8 2a db ff ff       	call   8007bc <_panic>
  802c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c95:	8b 00                	mov    (%eax),%eax
  802c97:	85 c0                	test   %eax,%eax
  802c99:	74 10                	je     802cab <alloc_block_NF+0x135>
  802c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9e:	8b 00                	mov    (%eax),%eax
  802ca0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca3:	8b 52 04             	mov    0x4(%edx),%edx
  802ca6:	89 50 04             	mov    %edx,0x4(%eax)
  802ca9:	eb 0b                	jmp    802cb6 <alloc_block_NF+0x140>
  802cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cae:	8b 40 04             	mov    0x4(%eax),%eax
  802cb1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb9:	8b 40 04             	mov    0x4(%eax),%eax
  802cbc:	85 c0                	test   %eax,%eax
  802cbe:	74 0f                	je     802ccf <alloc_block_NF+0x159>
  802cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc3:	8b 40 04             	mov    0x4(%eax),%eax
  802cc6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cc9:	8b 12                	mov    (%edx),%edx
  802ccb:	89 10                	mov    %edx,(%eax)
  802ccd:	eb 0a                	jmp    802cd9 <alloc_block_NF+0x163>
  802ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	a3 48 51 80 00       	mov    %eax,0x805148
  802cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cec:	a1 54 51 80 00       	mov    0x805154,%eax
  802cf1:	48                   	dec    %eax
  802cf2:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfa:	8b 40 08             	mov    0x8(%eax),%eax
  802cfd:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	8b 50 08             	mov    0x8(%eax),%edx
  802d08:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0b:	01 c2                	add    %eax,%edx
  802d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d10:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	8b 40 0c             	mov    0xc(%eax),%eax
  802d19:	2b 45 08             	sub    0x8(%ebp),%eax
  802d1c:	89 c2                	mov    %eax,%edx
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d27:	e9 15 04 00 00       	jmp    803141 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d2c:	a1 40 51 80 00       	mov    0x805140,%eax
  802d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d38:	74 07                	je     802d41 <alloc_block_NF+0x1cb>
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 00                	mov    (%eax),%eax
  802d3f:	eb 05                	jmp    802d46 <alloc_block_NF+0x1d0>
  802d41:	b8 00 00 00 00       	mov    $0x0,%eax
  802d46:	a3 40 51 80 00       	mov    %eax,0x805140
  802d4b:	a1 40 51 80 00       	mov    0x805140,%eax
  802d50:	85 c0                	test   %eax,%eax
  802d52:	0f 85 3e fe ff ff    	jne    802b96 <alloc_block_NF+0x20>
  802d58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5c:	0f 85 34 fe ff ff    	jne    802b96 <alloc_block_NF+0x20>
  802d62:	e9 d5 03 00 00       	jmp    80313c <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d67:	a1 38 51 80 00       	mov    0x805138,%eax
  802d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d6f:	e9 b1 01 00 00       	jmp    802f25 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d77:	8b 50 08             	mov    0x8(%eax),%edx
  802d7a:	a1 28 50 80 00       	mov    0x805028,%eax
  802d7f:	39 c2                	cmp    %eax,%edx
  802d81:	0f 82 96 01 00 00    	jb     802f1d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d90:	0f 82 87 01 00 00    	jb     802f1d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d9f:	0f 85 95 00 00 00    	jne    802e3a <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802da5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da9:	75 17                	jne    802dc2 <alloc_block_NF+0x24c>
  802dab:	83 ec 04             	sub    $0x4,%esp
  802dae:	68 a8 44 80 00       	push   $0x8044a8
  802db3:	68 fc 00 00 00       	push   $0xfc
  802db8:	68 ff 43 80 00       	push   $0x8043ff
  802dbd:	e8 fa d9 ff ff       	call   8007bc <_panic>
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	8b 00                	mov    (%eax),%eax
  802dc7:	85 c0                	test   %eax,%eax
  802dc9:	74 10                	je     802ddb <alloc_block_NF+0x265>
  802dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dce:	8b 00                	mov    (%eax),%eax
  802dd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd3:	8b 52 04             	mov    0x4(%edx),%edx
  802dd6:	89 50 04             	mov    %edx,0x4(%eax)
  802dd9:	eb 0b                	jmp    802de6 <alloc_block_NF+0x270>
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 40 04             	mov    0x4(%eax),%eax
  802de1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	8b 40 04             	mov    0x4(%eax),%eax
  802dec:	85 c0                	test   %eax,%eax
  802dee:	74 0f                	je     802dff <alloc_block_NF+0x289>
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	8b 40 04             	mov    0x4(%eax),%eax
  802df6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df9:	8b 12                	mov    (%edx),%edx
  802dfb:	89 10                	mov    %edx,(%eax)
  802dfd:	eb 0a                	jmp    802e09 <alloc_block_NF+0x293>
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 00                	mov    (%eax),%eax
  802e04:	a3 38 51 80 00       	mov    %eax,0x805138
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1c:	a1 44 51 80 00       	mov    0x805144,%eax
  802e21:	48                   	dec    %eax
  802e22:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	8b 40 08             	mov    0x8(%eax),%eax
  802e2d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	e9 07 03 00 00       	jmp    803141 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e40:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e43:	0f 86 d4 00 00 00    	jbe    802f1d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e49:	a1 48 51 80 00       	mov    0x805148,%eax
  802e4e:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 50 08             	mov    0x8(%eax),%edx
  802e57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e60:	8b 55 08             	mov    0x8(%ebp),%edx
  802e63:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e66:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e6a:	75 17                	jne    802e83 <alloc_block_NF+0x30d>
  802e6c:	83 ec 04             	sub    $0x4,%esp
  802e6f:	68 a8 44 80 00       	push   $0x8044a8
  802e74:	68 04 01 00 00       	push   $0x104
  802e79:	68 ff 43 80 00       	push   $0x8043ff
  802e7e:	e8 39 d9 ff ff       	call   8007bc <_panic>
  802e83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e86:	8b 00                	mov    (%eax),%eax
  802e88:	85 c0                	test   %eax,%eax
  802e8a:	74 10                	je     802e9c <alloc_block_NF+0x326>
  802e8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8f:	8b 00                	mov    (%eax),%eax
  802e91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e94:	8b 52 04             	mov    0x4(%edx),%edx
  802e97:	89 50 04             	mov    %edx,0x4(%eax)
  802e9a:	eb 0b                	jmp    802ea7 <alloc_block_NF+0x331>
  802e9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ea2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ea7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eaa:	8b 40 04             	mov    0x4(%eax),%eax
  802ead:	85 c0                	test   %eax,%eax
  802eaf:	74 0f                	je     802ec0 <alloc_block_NF+0x34a>
  802eb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb4:	8b 40 04             	mov    0x4(%eax),%eax
  802eb7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802eba:	8b 12                	mov    (%edx),%edx
  802ebc:	89 10                	mov    %edx,(%eax)
  802ebe:	eb 0a                	jmp    802eca <alloc_block_NF+0x354>
  802ec0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec3:	8b 00                	mov    (%eax),%eax
  802ec5:	a3 48 51 80 00       	mov    %eax,0x805148
  802eca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ecd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802edd:	a1 54 51 80 00       	mov    0x805154,%eax
  802ee2:	48                   	dec    %eax
  802ee3:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ee8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eeb:	8b 40 08             	mov    0x8(%eax),%eax
  802eee:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8b 50 08             	mov    0x8(%eax),%edx
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	01 c2                	add    %eax,%edx
  802efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f01:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0a:	2b 45 08             	sub    0x8(%ebp),%eax
  802f0d:	89 c2                	mov    %eax,%edx
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f18:	e9 24 02 00 00       	jmp    803141 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f1d:	a1 40 51 80 00       	mov    0x805140,%eax
  802f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f29:	74 07                	je     802f32 <alloc_block_NF+0x3bc>
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	eb 05                	jmp    802f37 <alloc_block_NF+0x3c1>
  802f32:	b8 00 00 00 00       	mov    $0x0,%eax
  802f37:	a3 40 51 80 00       	mov    %eax,0x805140
  802f3c:	a1 40 51 80 00       	mov    0x805140,%eax
  802f41:	85 c0                	test   %eax,%eax
  802f43:	0f 85 2b fe ff ff    	jne    802d74 <alloc_block_NF+0x1fe>
  802f49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4d:	0f 85 21 fe ff ff    	jne    802d74 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f53:	a1 38 51 80 00       	mov    0x805138,%eax
  802f58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f5b:	e9 ae 01 00 00       	jmp    80310e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 50 08             	mov    0x8(%eax),%edx
  802f66:	a1 28 50 80 00       	mov    0x805028,%eax
  802f6b:	39 c2                	cmp    %eax,%edx
  802f6d:	0f 83 93 01 00 00    	jae    803106 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	8b 40 0c             	mov    0xc(%eax),%eax
  802f79:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f7c:	0f 82 84 01 00 00    	jb     803106 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	8b 40 0c             	mov    0xc(%eax),%eax
  802f88:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f8b:	0f 85 95 00 00 00    	jne    803026 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f95:	75 17                	jne    802fae <alloc_block_NF+0x438>
  802f97:	83 ec 04             	sub    $0x4,%esp
  802f9a:	68 a8 44 80 00       	push   $0x8044a8
  802f9f:	68 14 01 00 00       	push   $0x114
  802fa4:	68 ff 43 80 00       	push   $0x8043ff
  802fa9:	e8 0e d8 ff ff       	call   8007bc <_panic>
  802fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb1:	8b 00                	mov    (%eax),%eax
  802fb3:	85 c0                	test   %eax,%eax
  802fb5:	74 10                	je     802fc7 <alloc_block_NF+0x451>
  802fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fba:	8b 00                	mov    (%eax),%eax
  802fbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fbf:	8b 52 04             	mov    0x4(%edx),%edx
  802fc2:	89 50 04             	mov    %edx,0x4(%eax)
  802fc5:	eb 0b                	jmp    802fd2 <alloc_block_NF+0x45c>
  802fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fca:	8b 40 04             	mov    0x4(%eax),%eax
  802fcd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	8b 40 04             	mov    0x4(%eax),%eax
  802fd8:	85 c0                	test   %eax,%eax
  802fda:	74 0f                	je     802feb <alloc_block_NF+0x475>
  802fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdf:	8b 40 04             	mov    0x4(%eax),%eax
  802fe2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fe5:	8b 12                	mov    (%edx),%edx
  802fe7:	89 10                	mov    %edx,(%eax)
  802fe9:	eb 0a                	jmp    802ff5 <alloc_block_NF+0x47f>
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	a3 38 51 80 00       	mov    %eax,0x805138
  802ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803001:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803008:	a1 44 51 80 00       	mov    0x805144,%eax
  80300d:	48                   	dec    %eax
  80300e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	8b 40 08             	mov    0x8(%eax),%eax
  803019:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80301e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803021:	e9 1b 01 00 00       	jmp    803141 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803029:	8b 40 0c             	mov    0xc(%eax),%eax
  80302c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80302f:	0f 86 d1 00 00 00    	jbe    803106 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803035:	a1 48 51 80 00       	mov    0x805148,%eax
  80303a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	8b 50 08             	mov    0x8(%eax),%edx
  803043:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803046:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803049:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304c:	8b 55 08             	mov    0x8(%ebp),%edx
  80304f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803052:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803056:	75 17                	jne    80306f <alloc_block_NF+0x4f9>
  803058:	83 ec 04             	sub    $0x4,%esp
  80305b:	68 a8 44 80 00       	push   $0x8044a8
  803060:	68 1c 01 00 00       	push   $0x11c
  803065:	68 ff 43 80 00       	push   $0x8043ff
  80306a:	e8 4d d7 ff ff       	call   8007bc <_panic>
  80306f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803072:	8b 00                	mov    (%eax),%eax
  803074:	85 c0                	test   %eax,%eax
  803076:	74 10                	je     803088 <alloc_block_NF+0x512>
  803078:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307b:	8b 00                	mov    (%eax),%eax
  80307d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803080:	8b 52 04             	mov    0x4(%edx),%edx
  803083:	89 50 04             	mov    %edx,0x4(%eax)
  803086:	eb 0b                	jmp    803093 <alloc_block_NF+0x51d>
  803088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308b:	8b 40 04             	mov    0x4(%eax),%eax
  80308e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803093:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803096:	8b 40 04             	mov    0x4(%eax),%eax
  803099:	85 c0                	test   %eax,%eax
  80309b:	74 0f                	je     8030ac <alloc_block_NF+0x536>
  80309d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a0:	8b 40 04             	mov    0x4(%eax),%eax
  8030a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030a6:	8b 12                	mov    (%edx),%edx
  8030a8:	89 10                	mov    %edx,(%eax)
  8030aa:	eb 0a                	jmp    8030b6 <alloc_block_NF+0x540>
  8030ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030af:	8b 00                	mov    (%eax),%eax
  8030b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8030b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c9:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ce:	48                   	dec    %eax
  8030cf:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8030d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d7:	8b 40 08             	mov    0x8(%eax),%eax
  8030da:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	8b 50 08             	mov    0x8(%eax),%edx
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	01 c2                	add    %eax,%edx
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8030f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f6:	2b 45 08             	sub    0x8(%ebp),%eax
  8030f9:	89 c2                	mov    %eax,%edx
  8030fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fe:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803104:	eb 3b                	jmp    803141 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803106:	a1 40 51 80 00       	mov    0x805140,%eax
  80310b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80310e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803112:	74 07                	je     80311b <alloc_block_NF+0x5a5>
  803114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803117:	8b 00                	mov    (%eax),%eax
  803119:	eb 05                	jmp    803120 <alloc_block_NF+0x5aa>
  80311b:	b8 00 00 00 00       	mov    $0x0,%eax
  803120:	a3 40 51 80 00       	mov    %eax,0x805140
  803125:	a1 40 51 80 00       	mov    0x805140,%eax
  80312a:	85 c0                	test   %eax,%eax
  80312c:	0f 85 2e fe ff ff    	jne    802f60 <alloc_block_NF+0x3ea>
  803132:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803136:	0f 85 24 fe ff ff    	jne    802f60 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80313c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803141:	c9                   	leave  
  803142:	c3                   	ret    

00803143 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803143:	55                   	push   %ebp
  803144:	89 e5                	mov    %esp,%ebp
  803146:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803149:	a1 38 51 80 00       	mov    0x805138,%eax
  80314e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803151:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803156:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803159:	a1 38 51 80 00       	mov    0x805138,%eax
  80315e:	85 c0                	test   %eax,%eax
  803160:	74 14                	je     803176 <insert_sorted_with_merge_freeList+0x33>
  803162:	8b 45 08             	mov    0x8(%ebp),%eax
  803165:	8b 50 08             	mov    0x8(%eax),%edx
  803168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316b:	8b 40 08             	mov    0x8(%eax),%eax
  80316e:	39 c2                	cmp    %eax,%edx
  803170:	0f 87 9b 01 00 00    	ja     803311 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803176:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317a:	75 17                	jne    803193 <insert_sorted_with_merge_freeList+0x50>
  80317c:	83 ec 04             	sub    $0x4,%esp
  80317f:	68 dc 43 80 00       	push   $0x8043dc
  803184:	68 38 01 00 00       	push   $0x138
  803189:	68 ff 43 80 00       	push   $0x8043ff
  80318e:	e8 29 d6 ff ff       	call   8007bc <_panic>
  803193:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	89 10                	mov    %edx,(%eax)
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	85 c0                	test   %eax,%eax
  8031a5:	74 0d                	je     8031b4 <insert_sorted_with_merge_freeList+0x71>
  8031a7:	a1 38 51 80 00       	mov    0x805138,%eax
  8031ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8031af:	89 50 04             	mov    %edx,0x4(%eax)
  8031b2:	eb 08                	jmp    8031bc <insert_sorted_with_merge_freeList+0x79>
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	a3 38 51 80 00       	mov    %eax,0x805138
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ce:	a1 44 51 80 00       	mov    0x805144,%eax
  8031d3:	40                   	inc    %eax
  8031d4:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8031d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031dd:	0f 84 a8 06 00 00    	je     80388b <insert_sorted_with_merge_freeList+0x748>
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	8b 50 08             	mov    0x8(%eax),%edx
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ef:	01 c2                	add    %eax,%edx
  8031f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f4:	8b 40 08             	mov    0x8(%eax),%eax
  8031f7:	39 c2                	cmp    %eax,%edx
  8031f9:	0f 85 8c 06 00 00    	jne    80388b <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8031ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803202:	8b 50 0c             	mov    0xc(%eax),%edx
  803205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803208:	8b 40 0c             	mov    0xc(%eax),%eax
  80320b:	01 c2                	add    %eax,%edx
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803213:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803217:	75 17                	jne    803230 <insert_sorted_with_merge_freeList+0xed>
  803219:	83 ec 04             	sub    $0x4,%esp
  80321c:	68 a8 44 80 00       	push   $0x8044a8
  803221:	68 3c 01 00 00       	push   $0x13c
  803226:	68 ff 43 80 00       	push   $0x8043ff
  80322b:	e8 8c d5 ff ff       	call   8007bc <_panic>
  803230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803233:	8b 00                	mov    (%eax),%eax
  803235:	85 c0                	test   %eax,%eax
  803237:	74 10                	je     803249 <insert_sorted_with_merge_freeList+0x106>
  803239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323c:	8b 00                	mov    (%eax),%eax
  80323e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803241:	8b 52 04             	mov    0x4(%edx),%edx
  803244:	89 50 04             	mov    %edx,0x4(%eax)
  803247:	eb 0b                	jmp    803254 <insert_sorted_with_merge_freeList+0x111>
  803249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324c:	8b 40 04             	mov    0x4(%eax),%eax
  80324f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803257:	8b 40 04             	mov    0x4(%eax),%eax
  80325a:	85 c0                	test   %eax,%eax
  80325c:	74 0f                	je     80326d <insert_sorted_with_merge_freeList+0x12a>
  80325e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803261:	8b 40 04             	mov    0x4(%eax),%eax
  803264:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803267:	8b 12                	mov    (%edx),%edx
  803269:	89 10                	mov    %edx,(%eax)
  80326b:	eb 0a                	jmp    803277 <insert_sorted_with_merge_freeList+0x134>
  80326d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803270:	8b 00                	mov    (%eax),%eax
  803272:	a3 38 51 80 00       	mov    %eax,0x805138
  803277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803283:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328a:	a1 44 51 80 00       	mov    0x805144,%eax
  80328f:	48                   	dec    %eax
  803290:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803295:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803298:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80329f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8032a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032ad:	75 17                	jne    8032c6 <insert_sorted_with_merge_freeList+0x183>
  8032af:	83 ec 04             	sub    $0x4,%esp
  8032b2:	68 dc 43 80 00       	push   $0x8043dc
  8032b7:	68 3f 01 00 00       	push   $0x13f
  8032bc:	68 ff 43 80 00       	push   $0x8043ff
  8032c1:	e8 f6 d4 ff ff       	call   8007bc <_panic>
  8032c6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cf:	89 10                	mov    %edx,(%eax)
  8032d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d4:	8b 00                	mov    (%eax),%eax
  8032d6:	85 c0                	test   %eax,%eax
  8032d8:	74 0d                	je     8032e7 <insert_sorted_with_merge_freeList+0x1a4>
  8032da:	a1 48 51 80 00       	mov    0x805148,%eax
  8032df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032e2:	89 50 04             	mov    %edx,0x4(%eax)
  8032e5:	eb 08                	jmp    8032ef <insert_sorted_with_merge_freeList+0x1ac>
  8032e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f2:	a3 48 51 80 00       	mov    %eax,0x805148
  8032f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803301:	a1 54 51 80 00       	mov    0x805154,%eax
  803306:	40                   	inc    %eax
  803307:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80330c:	e9 7a 05 00 00       	jmp    80388b <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	8b 50 08             	mov    0x8(%eax),%edx
  803317:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331a:	8b 40 08             	mov    0x8(%eax),%eax
  80331d:	39 c2                	cmp    %eax,%edx
  80331f:	0f 82 14 01 00 00    	jb     803439 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803325:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803328:	8b 50 08             	mov    0x8(%eax),%edx
  80332b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332e:	8b 40 0c             	mov    0xc(%eax),%eax
  803331:	01 c2                	add    %eax,%edx
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	8b 40 08             	mov    0x8(%eax),%eax
  803339:	39 c2                	cmp    %eax,%edx
  80333b:	0f 85 90 00 00 00    	jne    8033d1 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803341:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803344:	8b 50 0c             	mov    0xc(%eax),%edx
  803347:	8b 45 08             	mov    0x8(%ebp),%eax
  80334a:	8b 40 0c             	mov    0xc(%eax),%eax
  80334d:	01 c2                	add    %eax,%edx
  80334f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803352:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803355:	8b 45 08             	mov    0x8(%ebp),%eax
  803358:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80335f:	8b 45 08             	mov    0x8(%ebp),%eax
  803362:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803369:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80336d:	75 17                	jne    803386 <insert_sorted_with_merge_freeList+0x243>
  80336f:	83 ec 04             	sub    $0x4,%esp
  803372:	68 dc 43 80 00       	push   $0x8043dc
  803377:	68 49 01 00 00       	push   $0x149
  80337c:	68 ff 43 80 00       	push   $0x8043ff
  803381:	e8 36 d4 ff ff       	call   8007bc <_panic>
  803386:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	89 10                	mov    %edx,(%eax)
  803391:	8b 45 08             	mov    0x8(%ebp),%eax
  803394:	8b 00                	mov    (%eax),%eax
  803396:	85 c0                	test   %eax,%eax
  803398:	74 0d                	je     8033a7 <insert_sorted_with_merge_freeList+0x264>
  80339a:	a1 48 51 80 00       	mov    0x805148,%eax
  80339f:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a2:	89 50 04             	mov    %edx,0x4(%eax)
  8033a5:	eb 08                	jmp    8033af <insert_sorted_with_merge_freeList+0x26c>
  8033a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033aa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033af:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b2:	a3 48 51 80 00       	mov    %eax,0x805148
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c1:	a1 54 51 80 00       	mov    0x805154,%eax
  8033c6:	40                   	inc    %eax
  8033c7:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033cc:	e9 bb 04 00 00       	jmp    80388c <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8033d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d5:	75 17                	jne    8033ee <insert_sorted_with_merge_freeList+0x2ab>
  8033d7:	83 ec 04             	sub    $0x4,%esp
  8033da:	68 50 44 80 00       	push   $0x804450
  8033df:	68 4c 01 00 00       	push   $0x14c
  8033e4:	68 ff 43 80 00       	push   $0x8043ff
  8033e9:	e8 ce d3 ff ff       	call   8007bc <_panic>
  8033ee:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	89 50 04             	mov    %edx,0x4(%eax)
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	8b 40 04             	mov    0x4(%eax),%eax
  803400:	85 c0                	test   %eax,%eax
  803402:	74 0c                	je     803410 <insert_sorted_with_merge_freeList+0x2cd>
  803404:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803409:	8b 55 08             	mov    0x8(%ebp),%edx
  80340c:	89 10                	mov    %edx,(%eax)
  80340e:	eb 08                	jmp    803418 <insert_sorted_with_merge_freeList+0x2d5>
  803410:	8b 45 08             	mov    0x8(%ebp),%eax
  803413:	a3 38 51 80 00       	mov    %eax,0x805138
  803418:	8b 45 08             	mov    0x8(%ebp),%eax
  80341b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803429:	a1 44 51 80 00       	mov    0x805144,%eax
  80342e:	40                   	inc    %eax
  80342f:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803434:	e9 53 04 00 00       	jmp    80388c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803439:	a1 38 51 80 00       	mov    0x805138,%eax
  80343e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803441:	e9 15 04 00 00       	jmp    80385b <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803449:	8b 00                	mov    (%eax),%eax
  80344b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	8b 50 08             	mov    0x8(%eax),%edx
  803454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803457:	8b 40 08             	mov    0x8(%eax),%eax
  80345a:	39 c2                	cmp    %eax,%edx
  80345c:	0f 86 f1 03 00 00    	jbe    803853 <insert_sorted_with_merge_freeList+0x710>
  803462:	8b 45 08             	mov    0x8(%ebp),%eax
  803465:	8b 50 08             	mov    0x8(%eax),%edx
  803468:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346b:	8b 40 08             	mov    0x8(%eax),%eax
  80346e:	39 c2                	cmp    %eax,%edx
  803470:	0f 83 dd 03 00 00    	jae    803853 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803479:	8b 50 08             	mov    0x8(%eax),%edx
  80347c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347f:	8b 40 0c             	mov    0xc(%eax),%eax
  803482:	01 c2                	add    %eax,%edx
  803484:	8b 45 08             	mov    0x8(%ebp),%eax
  803487:	8b 40 08             	mov    0x8(%eax),%eax
  80348a:	39 c2                	cmp    %eax,%edx
  80348c:	0f 85 b9 01 00 00    	jne    80364b <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	8b 50 08             	mov    0x8(%eax),%edx
  803498:	8b 45 08             	mov    0x8(%ebp),%eax
  80349b:	8b 40 0c             	mov    0xc(%eax),%eax
  80349e:	01 c2                	add    %eax,%edx
  8034a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a3:	8b 40 08             	mov    0x8(%eax),%eax
  8034a6:	39 c2                	cmp    %eax,%edx
  8034a8:	0f 85 0d 01 00 00    	jne    8035bb <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8034ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b1:	8b 50 0c             	mov    0xc(%eax),%edx
  8034b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ba:	01 c2                	add    %eax,%edx
  8034bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bf:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8034c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034c6:	75 17                	jne    8034df <insert_sorted_with_merge_freeList+0x39c>
  8034c8:	83 ec 04             	sub    $0x4,%esp
  8034cb:	68 a8 44 80 00       	push   $0x8044a8
  8034d0:	68 5c 01 00 00       	push   $0x15c
  8034d5:	68 ff 43 80 00       	push   $0x8043ff
  8034da:	e8 dd d2 ff ff       	call   8007bc <_panic>
  8034df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e2:	8b 00                	mov    (%eax),%eax
  8034e4:	85 c0                	test   %eax,%eax
  8034e6:	74 10                	je     8034f8 <insert_sorted_with_merge_freeList+0x3b5>
  8034e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034eb:	8b 00                	mov    (%eax),%eax
  8034ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034f0:	8b 52 04             	mov    0x4(%edx),%edx
  8034f3:	89 50 04             	mov    %edx,0x4(%eax)
  8034f6:	eb 0b                	jmp    803503 <insert_sorted_with_merge_freeList+0x3c0>
  8034f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fb:	8b 40 04             	mov    0x4(%eax),%eax
  8034fe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803503:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803506:	8b 40 04             	mov    0x4(%eax),%eax
  803509:	85 c0                	test   %eax,%eax
  80350b:	74 0f                	je     80351c <insert_sorted_with_merge_freeList+0x3d9>
  80350d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803510:	8b 40 04             	mov    0x4(%eax),%eax
  803513:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803516:	8b 12                	mov    (%edx),%edx
  803518:	89 10                	mov    %edx,(%eax)
  80351a:	eb 0a                	jmp    803526 <insert_sorted_with_merge_freeList+0x3e3>
  80351c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351f:	8b 00                	mov    (%eax),%eax
  803521:	a3 38 51 80 00       	mov    %eax,0x805138
  803526:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803529:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80352f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803532:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803539:	a1 44 51 80 00       	mov    0x805144,%eax
  80353e:	48                   	dec    %eax
  80353f:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803544:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803547:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80354e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803551:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803558:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80355c:	75 17                	jne    803575 <insert_sorted_with_merge_freeList+0x432>
  80355e:	83 ec 04             	sub    $0x4,%esp
  803561:	68 dc 43 80 00       	push   $0x8043dc
  803566:	68 5f 01 00 00       	push   $0x15f
  80356b:	68 ff 43 80 00       	push   $0x8043ff
  803570:	e8 47 d2 ff ff       	call   8007bc <_panic>
  803575:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80357b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357e:	89 10                	mov    %edx,(%eax)
  803580:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803583:	8b 00                	mov    (%eax),%eax
  803585:	85 c0                	test   %eax,%eax
  803587:	74 0d                	je     803596 <insert_sorted_with_merge_freeList+0x453>
  803589:	a1 48 51 80 00       	mov    0x805148,%eax
  80358e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803591:	89 50 04             	mov    %edx,0x4(%eax)
  803594:	eb 08                	jmp    80359e <insert_sorted_with_merge_freeList+0x45b>
  803596:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803599:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80359e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a1:	a3 48 51 80 00       	mov    %eax,0x805148
  8035a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b0:	a1 54 51 80 00       	mov    0x805154,%eax
  8035b5:	40                   	inc    %eax
  8035b6:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8035bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035be:	8b 50 0c             	mov    0xc(%eax),%edx
  8035c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c7:	01 c2                	add    %eax,%edx
  8035c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cc:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8035cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8035d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8035e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e7:	75 17                	jne    803600 <insert_sorted_with_merge_freeList+0x4bd>
  8035e9:	83 ec 04             	sub    $0x4,%esp
  8035ec:	68 dc 43 80 00       	push   $0x8043dc
  8035f1:	68 64 01 00 00       	push   $0x164
  8035f6:	68 ff 43 80 00       	push   $0x8043ff
  8035fb:	e8 bc d1 ff ff       	call   8007bc <_panic>
  803600:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803606:	8b 45 08             	mov    0x8(%ebp),%eax
  803609:	89 10                	mov    %edx,(%eax)
  80360b:	8b 45 08             	mov    0x8(%ebp),%eax
  80360e:	8b 00                	mov    (%eax),%eax
  803610:	85 c0                	test   %eax,%eax
  803612:	74 0d                	je     803621 <insert_sorted_with_merge_freeList+0x4de>
  803614:	a1 48 51 80 00       	mov    0x805148,%eax
  803619:	8b 55 08             	mov    0x8(%ebp),%edx
  80361c:	89 50 04             	mov    %edx,0x4(%eax)
  80361f:	eb 08                	jmp    803629 <insert_sorted_with_merge_freeList+0x4e6>
  803621:	8b 45 08             	mov    0x8(%ebp),%eax
  803624:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803629:	8b 45 08             	mov    0x8(%ebp),%eax
  80362c:	a3 48 51 80 00       	mov    %eax,0x805148
  803631:	8b 45 08             	mov    0x8(%ebp),%eax
  803634:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363b:	a1 54 51 80 00       	mov    0x805154,%eax
  803640:	40                   	inc    %eax
  803641:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803646:	e9 41 02 00 00       	jmp    80388c <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80364b:	8b 45 08             	mov    0x8(%ebp),%eax
  80364e:	8b 50 08             	mov    0x8(%eax),%edx
  803651:	8b 45 08             	mov    0x8(%ebp),%eax
  803654:	8b 40 0c             	mov    0xc(%eax),%eax
  803657:	01 c2                	add    %eax,%edx
  803659:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80365c:	8b 40 08             	mov    0x8(%eax),%eax
  80365f:	39 c2                	cmp    %eax,%edx
  803661:	0f 85 7c 01 00 00    	jne    8037e3 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803667:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80366b:	74 06                	je     803673 <insert_sorted_with_merge_freeList+0x530>
  80366d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803671:	75 17                	jne    80368a <insert_sorted_with_merge_freeList+0x547>
  803673:	83 ec 04             	sub    $0x4,%esp
  803676:	68 18 44 80 00       	push   $0x804418
  80367b:	68 69 01 00 00       	push   $0x169
  803680:	68 ff 43 80 00       	push   $0x8043ff
  803685:	e8 32 d1 ff ff       	call   8007bc <_panic>
  80368a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368d:	8b 50 04             	mov    0x4(%eax),%edx
  803690:	8b 45 08             	mov    0x8(%ebp),%eax
  803693:	89 50 04             	mov    %edx,0x4(%eax)
  803696:	8b 45 08             	mov    0x8(%ebp),%eax
  803699:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80369c:	89 10                	mov    %edx,(%eax)
  80369e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a1:	8b 40 04             	mov    0x4(%eax),%eax
  8036a4:	85 c0                	test   %eax,%eax
  8036a6:	74 0d                	je     8036b5 <insert_sorted_with_merge_freeList+0x572>
  8036a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ab:	8b 40 04             	mov    0x4(%eax),%eax
  8036ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8036b1:	89 10                	mov    %edx,(%eax)
  8036b3:	eb 08                	jmp    8036bd <insert_sorted_with_merge_freeList+0x57a>
  8036b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b8:	a3 38 51 80 00       	mov    %eax,0x805138
  8036bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8036c3:	89 50 04             	mov    %edx,0x4(%eax)
  8036c6:	a1 44 51 80 00       	mov    0x805144,%eax
  8036cb:	40                   	inc    %eax
  8036cc:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8036d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d4:	8b 50 0c             	mov    0xc(%eax),%edx
  8036d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036da:	8b 40 0c             	mov    0xc(%eax),%eax
  8036dd:	01 c2                	add    %eax,%edx
  8036df:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e2:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8036e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036e9:	75 17                	jne    803702 <insert_sorted_with_merge_freeList+0x5bf>
  8036eb:	83 ec 04             	sub    $0x4,%esp
  8036ee:	68 a8 44 80 00       	push   $0x8044a8
  8036f3:	68 6b 01 00 00       	push   $0x16b
  8036f8:	68 ff 43 80 00       	push   $0x8043ff
  8036fd:	e8 ba d0 ff ff       	call   8007bc <_panic>
  803702:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803705:	8b 00                	mov    (%eax),%eax
  803707:	85 c0                	test   %eax,%eax
  803709:	74 10                	je     80371b <insert_sorted_with_merge_freeList+0x5d8>
  80370b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370e:	8b 00                	mov    (%eax),%eax
  803710:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803713:	8b 52 04             	mov    0x4(%edx),%edx
  803716:	89 50 04             	mov    %edx,0x4(%eax)
  803719:	eb 0b                	jmp    803726 <insert_sorted_with_merge_freeList+0x5e3>
  80371b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80371e:	8b 40 04             	mov    0x4(%eax),%eax
  803721:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803726:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803729:	8b 40 04             	mov    0x4(%eax),%eax
  80372c:	85 c0                	test   %eax,%eax
  80372e:	74 0f                	je     80373f <insert_sorted_with_merge_freeList+0x5fc>
  803730:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803733:	8b 40 04             	mov    0x4(%eax),%eax
  803736:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803739:	8b 12                	mov    (%edx),%edx
  80373b:	89 10                	mov    %edx,(%eax)
  80373d:	eb 0a                	jmp    803749 <insert_sorted_with_merge_freeList+0x606>
  80373f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803742:	8b 00                	mov    (%eax),%eax
  803744:	a3 38 51 80 00       	mov    %eax,0x805138
  803749:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803755:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375c:	a1 44 51 80 00       	mov    0x805144,%eax
  803761:	48                   	dec    %eax
  803762:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803767:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803771:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803774:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80377b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80377f:	75 17                	jne    803798 <insert_sorted_with_merge_freeList+0x655>
  803781:	83 ec 04             	sub    $0x4,%esp
  803784:	68 dc 43 80 00       	push   $0x8043dc
  803789:	68 6e 01 00 00       	push   $0x16e
  80378e:	68 ff 43 80 00       	push   $0x8043ff
  803793:	e8 24 d0 ff ff       	call   8007bc <_panic>
  803798:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80379e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a1:	89 10                	mov    %edx,(%eax)
  8037a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a6:	8b 00                	mov    (%eax),%eax
  8037a8:	85 c0                	test   %eax,%eax
  8037aa:	74 0d                	je     8037b9 <insert_sorted_with_merge_freeList+0x676>
  8037ac:	a1 48 51 80 00       	mov    0x805148,%eax
  8037b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037b4:	89 50 04             	mov    %edx,0x4(%eax)
  8037b7:	eb 08                	jmp    8037c1 <insert_sorted_with_merge_freeList+0x67e>
  8037b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037bc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c4:	a3 48 51 80 00       	mov    %eax,0x805148
  8037c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037d3:	a1 54 51 80 00       	mov    0x805154,%eax
  8037d8:	40                   	inc    %eax
  8037d9:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8037de:	e9 a9 00 00 00       	jmp    80388c <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8037e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e7:	74 06                	je     8037ef <insert_sorted_with_merge_freeList+0x6ac>
  8037e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037ed:	75 17                	jne    803806 <insert_sorted_with_merge_freeList+0x6c3>
  8037ef:	83 ec 04             	sub    $0x4,%esp
  8037f2:	68 74 44 80 00       	push   $0x804474
  8037f7:	68 73 01 00 00       	push   $0x173
  8037fc:	68 ff 43 80 00       	push   $0x8043ff
  803801:	e8 b6 cf ff ff       	call   8007bc <_panic>
  803806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803809:	8b 10                	mov    (%eax),%edx
  80380b:	8b 45 08             	mov    0x8(%ebp),%eax
  80380e:	89 10                	mov    %edx,(%eax)
  803810:	8b 45 08             	mov    0x8(%ebp),%eax
  803813:	8b 00                	mov    (%eax),%eax
  803815:	85 c0                	test   %eax,%eax
  803817:	74 0b                	je     803824 <insert_sorted_with_merge_freeList+0x6e1>
  803819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381c:	8b 00                	mov    (%eax),%eax
  80381e:	8b 55 08             	mov    0x8(%ebp),%edx
  803821:	89 50 04             	mov    %edx,0x4(%eax)
  803824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803827:	8b 55 08             	mov    0x8(%ebp),%edx
  80382a:	89 10                	mov    %edx,(%eax)
  80382c:	8b 45 08             	mov    0x8(%ebp),%eax
  80382f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803832:	89 50 04             	mov    %edx,0x4(%eax)
  803835:	8b 45 08             	mov    0x8(%ebp),%eax
  803838:	8b 00                	mov    (%eax),%eax
  80383a:	85 c0                	test   %eax,%eax
  80383c:	75 08                	jne    803846 <insert_sorted_with_merge_freeList+0x703>
  80383e:	8b 45 08             	mov    0x8(%ebp),%eax
  803841:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803846:	a1 44 51 80 00       	mov    0x805144,%eax
  80384b:	40                   	inc    %eax
  80384c:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803851:	eb 39                	jmp    80388c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803853:	a1 40 51 80 00       	mov    0x805140,%eax
  803858:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80385b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80385f:	74 07                	je     803868 <insert_sorted_with_merge_freeList+0x725>
  803861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803864:	8b 00                	mov    (%eax),%eax
  803866:	eb 05                	jmp    80386d <insert_sorted_with_merge_freeList+0x72a>
  803868:	b8 00 00 00 00       	mov    $0x0,%eax
  80386d:	a3 40 51 80 00       	mov    %eax,0x805140
  803872:	a1 40 51 80 00       	mov    0x805140,%eax
  803877:	85 c0                	test   %eax,%eax
  803879:	0f 85 c7 fb ff ff    	jne    803446 <insert_sorted_with_merge_freeList+0x303>
  80387f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803883:	0f 85 bd fb ff ff    	jne    803446 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803889:	eb 01                	jmp    80388c <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80388b:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80388c:	90                   	nop
  80388d:	c9                   	leave  
  80388e:	c3                   	ret    
  80388f:	90                   	nop

00803890 <__udivdi3>:
  803890:	55                   	push   %ebp
  803891:	57                   	push   %edi
  803892:	56                   	push   %esi
  803893:	53                   	push   %ebx
  803894:	83 ec 1c             	sub    $0x1c,%esp
  803897:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80389b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80389f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038a7:	89 ca                	mov    %ecx,%edx
  8038a9:	89 f8                	mov    %edi,%eax
  8038ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038af:	85 f6                	test   %esi,%esi
  8038b1:	75 2d                	jne    8038e0 <__udivdi3+0x50>
  8038b3:	39 cf                	cmp    %ecx,%edi
  8038b5:	77 65                	ja     80391c <__udivdi3+0x8c>
  8038b7:	89 fd                	mov    %edi,%ebp
  8038b9:	85 ff                	test   %edi,%edi
  8038bb:	75 0b                	jne    8038c8 <__udivdi3+0x38>
  8038bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8038c2:	31 d2                	xor    %edx,%edx
  8038c4:	f7 f7                	div    %edi
  8038c6:	89 c5                	mov    %eax,%ebp
  8038c8:	31 d2                	xor    %edx,%edx
  8038ca:	89 c8                	mov    %ecx,%eax
  8038cc:	f7 f5                	div    %ebp
  8038ce:	89 c1                	mov    %eax,%ecx
  8038d0:	89 d8                	mov    %ebx,%eax
  8038d2:	f7 f5                	div    %ebp
  8038d4:	89 cf                	mov    %ecx,%edi
  8038d6:	89 fa                	mov    %edi,%edx
  8038d8:	83 c4 1c             	add    $0x1c,%esp
  8038db:	5b                   	pop    %ebx
  8038dc:	5e                   	pop    %esi
  8038dd:	5f                   	pop    %edi
  8038de:	5d                   	pop    %ebp
  8038df:	c3                   	ret    
  8038e0:	39 ce                	cmp    %ecx,%esi
  8038e2:	77 28                	ja     80390c <__udivdi3+0x7c>
  8038e4:	0f bd fe             	bsr    %esi,%edi
  8038e7:	83 f7 1f             	xor    $0x1f,%edi
  8038ea:	75 40                	jne    80392c <__udivdi3+0x9c>
  8038ec:	39 ce                	cmp    %ecx,%esi
  8038ee:	72 0a                	jb     8038fa <__udivdi3+0x6a>
  8038f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038f4:	0f 87 9e 00 00 00    	ja     803998 <__udivdi3+0x108>
  8038fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8038ff:	89 fa                	mov    %edi,%edx
  803901:	83 c4 1c             	add    $0x1c,%esp
  803904:	5b                   	pop    %ebx
  803905:	5e                   	pop    %esi
  803906:	5f                   	pop    %edi
  803907:	5d                   	pop    %ebp
  803908:	c3                   	ret    
  803909:	8d 76 00             	lea    0x0(%esi),%esi
  80390c:	31 ff                	xor    %edi,%edi
  80390e:	31 c0                	xor    %eax,%eax
  803910:	89 fa                	mov    %edi,%edx
  803912:	83 c4 1c             	add    $0x1c,%esp
  803915:	5b                   	pop    %ebx
  803916:	5e                   	pop    %esi
  803917:	5f                   	pop    %edi
  803918:	5d                   	pop    %ebp
  803919:	c3                   	ret    
  80391a:	66 90                	xchg   %ax,%ax
  80391c:	89 d8                	mov    %ebx,%eax
  80391e:	f7 f7                	div    %edi
  803920:	31 ff                	xor    %edi,%edi
  803922:	89 fa                	mov    %edi,%edx
  803924:	83 c4 1c             	add    $0x1c,%esp
  803927:	5b                   	pop    %ebx
  803928:	5e                   	pop    %esi
  803929:	5f                   	pop    %edi
  80392a:	5d                   	pop    %ebp
  80392b:	c3                   	ret    
  80392c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803931:	89 eb                	mov    %ebp,%ebx
  803933:	29 fb                	sub    %edi,%ebx
  803935:	89 f9                	mov    %edi,%ecx
  803937:	d3 e6                	shl    %cl,%esi
  803939:	89 c5                	mov    %eax,%ebp
  80393b:	88 d9                	mov    %bl,%cl
  80393d:	d3 ed                	shr    %cl,%ebp
  80393f:	89 e9                	mov    %ebp,%ecx
  803941:	09 f1                	or     %esi,%ecx
  803943:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803947:	89 f9                	mov    %edi,%ecx
  803949:	d3 e0                	shl    %cl,%eax
  80394b:	89 c5                	mov    %eax,%ebp
  80394d:	89 d6                	mov    %edx,%esi
  80394f:	88 d9                	mov    %bl,%cl
  803951:	d3 ee                	shr    %cl,%esi
  803953:	89 f9                	mov    %edi,%ecx
  803955:	d3 e2                	shl    %cl,%edx
  803957:	8b 44 24 08          	mov    0x8(%esp),%eax
  80395b:	88 d9                	mov    %bl,%cl
  80395d:	d3 e8                	shr    %cl,%eax
  80395f:	09 c2                	or     %eax,%edx
  803961:	89 d0                	mov    %edx,%eax
  803963:	89 f2                	mov    %esi,%edx
  803965:	f7 74 24 0c          	divl   0xc(%esp)
  803969:	89 d6                	mov    %edx,%esi
  80396b:	89 c3                	mov    %eax,%ebx
  80396d:	f7 e5                	mul    %ebp
  80396f:	39 d6                	cmp    %edx,%esi
  803971:	72 19                	jb     80398c <__udivdi3+0xfc>
  803973:	74 0b                	je     803980 <__udivdi3+0xf0>
  803975:	89 d8                	mov    %ebx,%eax
  803977:	31 ff                	xor    %edi,%edi
  803979:	e9 58 ff ff ff       	jmp    8038d6 <__udivdi3+0x46>
  80397e:	66 90                	xchg   %ax,%ax
  803980:	8b 54 24 08          	mov    0x8(%esp),%edx
  803984:	89 f9                	mov    %edi,%ecx
  803986:	d3 e2                	shl    %cl,%edx
  803988:	39 c2                	cmp    %eax,%edx
  80398a:	73 e9                	jae    803975 <__udivdi3+0xe5>
  80398c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80398f:	31 ff                	xor    %edi,%edi
  803991:	e9 40 ff ff ff       	jmp    8038d6 <__udivdi3+0x46>
  803996:	66 90                	xchg   %ax,%ax
  803998:	31 c0                	xor    %eax,%eax
  80399a:	e9 37 ff ff ff       	jmp    8038d6 <__udivdi3+0x46>
  80399f:	90                   	nop

008039a0 <__umoddi3>:
  8039a0:	55                   	push   %ebp
  8039a1:	57                   	push   %edi
  8039a2:	56                   	push   %esi
  8039a3:	53                   	push   %ebx
  8039a4:	83 ec 1c             	sub    $0x1c,%esp
  8039a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039bf:	89 f3                	mov    %esi,%ebx
  8039c1:	89 fa                	mov    %edi,%edx
  8039c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039c7:	89 34 24             	mov    %esi,(%esp)
  8039ca:	85 c0                	test   %eax,%eax
  8039cc:	75 1a                	jne    8039e8 <__umoddi3+0x48>
  8039ce:	39 f7                	cmp    %esi,%edi
  8039d0:	0f 86 a2 00 00 00    	jbe    803a78 <__umoddi3+0xd8>
  8039d6:	89 c8                	mov    %ecx,%eax
  8039d8:	89 f2                	mov    %esi,%edx
  8039da:	f7 f7                	div    %edi
  8039dc:	89 d0                	mov    %edx,%eax
  8039de:	31 d2                	xor    %edx,%edx
  8039e0:	83 c4 1c             	add    $0x1c,%esp
  8039e3:	5b                   	pop    %ebx
  8039e4:	5e                   	pop    %esi
  8039e5:	5f                   	pop    %edi
  8039e6:	5d                   	pop    %ebp
  8039e7:	c3                   	ret    
  8039e8:	39 f0                	cmp    %esi,%eax
  8039ea:	0f 87 ac 00 00 00    	ja     803a9c <__umoddi3+0xfc>
  8039f0:	0f bd e8             	bsr    %eax,%ebp
  8039f3:	83 f5 1f             	xor    $0x1f,%ebp
  8039f6:	0f 84 ac 00 00 00    	je     803aa8 <__umoddi3+0x108>
  8039fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803a01:	29 ef                	sub    %ebp,%edi
  803a03:	89 fe                	mov    %edi,%esi
  803a05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a09:	89 e9                	mov    %ebp,%ecx
  803a0b:	d3 e0                	shl    %cl,%eax
  803a0d:	89 d7                	mov    %edx,%edi
  803a0f:	89 f1                	mov    %esi,%ecx
  803a11:	d3 ef                	shr    %cl,%edi
  803a13:	09 c7                	or     %eax,%edi
  803a15:	89 e9                	mov    %ebp,%ecx
  803a17:	d3 e2                	shl    %cl,%edx
  803a19:	89 14 24             	mov    %edx,(%esp)
  803a1c:	89 d8                	mov    %ebx,%eax
  803a1e:	d3 e0                	shl    %cl,%eax
  803a20:	89 c2                	mov    %eax,%edx
  803a22:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a26:	d3 e0                	shl    %cl,%eax
  803a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a2c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a30:	89 f1                	mov    %esi,%ecx
  803a32:	d3 e8                	shr    %cl,%eax
  803a34:	09 d0                	or     %edx,%eax
  803a36:	d3 eb                	shr    %cl,%ebx
  803a38:	89 da                	mov    %ebx,%edx
  803a3a:	f7 f7                	div    %edi
  803a3c:	89 d3                	mov    %edx,%ebx
  803a3e:	f7 24 24             	mull   (%esp)
  803a41:	89 c6                	mov    %eax,%esi
  803a43:	89 d1                	mov    %edx,%ecx
  803a45:	39 d3                	cmp    %edx,%ebx
  803a47:	0f 82 87 00 00 00    	jb     803ad4 <__umoddi3+0x134>
  803a4d:	0f 84 91 00 00 00    	je     803ae4 <__umoddi3+0x144>
  803a53:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a57:	29 f2                	sub    %esi,%edx
  803a59:	19 cb                	sbb    %ecx,%ebx
  803a5b:	89 d8                	mov    %ebx,%eax
  803a5d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a61:	d3 e0                	shl    %cl,%eax
  803a63:	89 e9                	mov    %ebp,%ecx
  803a65:	d3 ea                	shr    %cl,%edx
  803a67:	09 d0                	or     %edx,%eax
  803a69:	89 e9                	mov    %ebp,%ecx
  803a6b:	d3 eb                	shr    %cl,%ebx
  803a6d:	89 da                	mov    %ebx,%edx
  803a6f:	83 c4 1c             	add    $0x1c,%esp
  803a72:	5b                   	pop    %ebx
  803a73:	5e                   	pop    %esi
  803a74:	5f                   	pop    %edi
  803a75:	5d                   	pop    %ebp
  803a76:	c3                   	ret    
  803a77:	90                   	nop
  803a78:	89 fd                	mov    %edi,%ebp
  803a7a:	85 ff                	test   %edi,%edi
  803a7c:	75 0b                	jne    803a89 <__umoddi3+0xe9>
  803a7e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a83:	31 d2                	xor    %edx,%edx
  803a85:	f7 f7                	div    %edi
  803a87:	89 c5                	mov    %eax,%ebp
  803a89:	89 f0                	mov    %esi,%eax
  803a8b:	31 d2                	xor    %edx,%edx
  803a8d:	f7 f5                	div    %ebp
  803a8f:	89 c8                	mov    %ecx,%eax
  803a91:	f7 f5                	div    %ebp
  803a93:	89 d0                	mov    %edx,%eax
  803a95:	e9 44 ff ff ff       	jmp    8039de <__umoddi3+0x3e>
  803a9a:	66 90                	xchg   %ax,%ax
  803a9c:	89 c8                	mov    %ecx,%eax
  803a9e:	89 f2                	mov    %esi,%edx
  803aa0:	83 c4 1c             	add    $0x1c,%esp
  803aa3:	5b                   	pop    %ebx
  803aa4:	5e                   	pop    %esi
  803aa5:	5f                   	pop    %edi
  803aa6:	5d                   	pop    %ebp
  803aa7:	c3                   	ret    
  803aa8:	3b 04 24             	cmp    (%esp),%eax
  803aab:	72 06                	jb     803ab3 <__umoddi3+0x113>
  803aad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ab1:	77 0f                	ja     803ac2 <__umoddi3+0x122>
  803ab3:	89 f2                	mov    %esi,%edx
  803ab5:	29 f9                	sub    %edi,%ecx
  803ab7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803abb:	89 14 24             	mov    %edx,(%esp)
  803abe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ac2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ac6:	8b 14 24             	mov    (%esp),%edx
  803ac9:	83 c4 1c             	add    $0x1c,%esp
  803acc:	5b                   	pop    %ebx
  803acd:	5e                   	pop    %esi
  803ace:	5f                   	pop    %edi
  803acf:	5d                   	pop    %ebp
  803ad0:	c3                   	ret    
  803ad1:	8d 76 00             	lea    0x0(%esi),%esi
  803ad4:	2b 04 24             	sub    (%esp),%eax
  803ad7:	19 fa                	sbb    %edi,%edx
  803ad9:	89 d1                	mov    %edx,%ecx
  803adb:	89 c6                	mov    %eax,%esi
  803add:	e9 71 ff ff ff       	jmp    803a53 <__umoddi3+0xb3>
  803ae2:	66 90                	xchg   %ax,%ax
  803ae4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ae8:	72 ea                	jb     803ad4 <__umoddi3+0x134>
  803aea:	89 d9                	mov    %ebx,%ecx
  803aec:	e9 62 ff ff ff       	jmp    803a53 <__umoddi3+0xb3>
