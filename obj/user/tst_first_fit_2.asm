
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
  800045:	e8 70 21 00 00       	call   8021ba <sys_set_uheap_strategy>
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
  80009b:	68 e0 3a 80 00       	push   $0x803ae0
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 fc 3a 80 00       	push   $0x803afc
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
  8000f5:	68 14 3b 80 00       	push   $0x803b14
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 fc 3a 80 00       	push   $0x803afc
  800101:	e8 b6 06 00 00       	call   8007bc <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 9a 1b 00 00       	call   801ca5 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 32 1c 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
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
  80013a:	68 58 3b 80 00       	push   $0x803b58
  80013f:	6a 31                	push   $0x31
  800141:	68 fc 3a 80 00       	push   $0x803afc
  800146:	e8 71 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014b:	e8 f5 1b 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  800150:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 88 3b 80 00       	push   $0x803b88
  80015d:	6a 33                	push   $0x33
  80015f:	68 fc 3a 80 00       	push   $0x803afc
  800164:	e8 53 06 00 00       	call   8007bc <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 37 1b 00 00       	call   801ca5 <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 cf 1b 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
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
  8001a6:	68 58 3b 80 00       	push   $0x803b58
  8001ab:	6a 39                	push   $0x39
  8001ad:	68 fc 3a 80 00       	push   $0x803afc
  8001b2:	e8 05 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b7:	e8 89 1b 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  8001bc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 88 3b 80 00       	push   $0x803b88
  8001c9:	6a 3b                	push   $0x3b
  8001cb:	68 fc 3a 80 00       	push   $0x803afc
  8001d0:	e8 e7 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001d5:	e8 cb 1a 00 00       	call   801ca5 <sys_calculate_free_frames>
  8001da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001dd:	e8 63 1b 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
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
  800214:	68 58 3b 80 00       	push   $0x803b58
  800219:	6a 41                	push   $0x41
  80021b:	68 fc 3a 80 00       	push   $0x803afc
  800220:	e8 97 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800225:	e8 1b 1b 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  80022a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 88 3b 80 00       	push   $0x803b88
  800237:	6a 43                	push   $0x43
  800239:	68 fc 3a 80 00       	push   $0x803afc
  80023e:	e8 79 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  800243:	e8 5d 1a 00 00       	call   801ca5 <sys_calculate_free_frames>
  800248:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80024b:	e8 f5 1a 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
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
  80028c:	68 58 3b 80 00       	push   $0x803b58
  800291:	6a 49                	push   $0x49
  800293:	68 fc 3a 80 00       	push   $0x803afc
  800298:	e8 1f 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80029d:	e8 a3 1a 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  8002a2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a5:	74 14                	je     8002bb <_main+0x283>
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	68 88 3b 80 00       	push   $0x803b88
  8002af:	6a 4b                	push   $0x4b
  8002b1:	68 fc 3a 80 00       	push   $0x803afc
  8002b6:	e8 01 05 00 00       	call   8007bc <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002bb:	e8 e5 19 00 00       	call   801ca5 <sys_calculate_free_frames>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c3:	e8 7d 1a 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  8002c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002cb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	50                   	push   %eax
  8002d2:	e8 4f 17 00 00       	call   801a26 <free>
  8002d7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8002da:	e8 66 1a 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  8002df:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002e2:	74 14                	je     8002f8 <_main+0x2c0>
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	68 a5 3b 80 00       	push   $0x803ba5
  8002ec:	6a 52                	push   $0x52
  8002ee:	68 fc 3a 80 00       	push   $0x803afc
  8002f3:	e8 c4 04 00 00       	call   8007bc <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002f8:	e8 a8 19 00 00       	call   801ca5 <sys_calculate_free_frames>
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800300:	e8 40 1a 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
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
  800345:	68 58 3b 80 00       	push   $0x803b58
  80034a:	6a 58                	push   $0x58
  80034c:	68 fc 3a 80 00       	push   $0x803afc
  800351:	e8 66 04 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800356:	e8 ea 19 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  80035b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80035e:	74 14                	je     800374 <_main+0x33c>
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	68 88 3b 80 00       	push   $0x803b88
  800368:	6a 5a                	push   $0x5a
  80036a:	68 fc 3a 80 00       	push   $0x803afc
  80036f:	e8 48 04 00 00       	call   8007bc <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800374:	e8 2c 19 00 00       	call   801ca5 <sys_calculate_free_frames>
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037c:	e8 c4 19 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800384:	8b 45 90             	mov    -0x70(%ebp),%eax
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	50                   	push   %eax
  80038b:	e8 96 16 00 00       	call   801a26 <free>
  800390:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  800393:	e8 ad 19 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  800398:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80039b:	74 14                	je     8003b1 <_main+0x379>
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 a5 3b 80 00       	push   $0x803ba5
  8003a5:	6a 61                	push   $0x61
  8003a7:	68 fc 3a 80 00       	push   $0x803afc
  8003ac:	e8 0b 04 00 00       	call   8007bc <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003b1:	e8 ef 18 00 00       	call   801ca5 <sys_calculate_free_frames>
  8003b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003b9:	e8 87 19 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
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
  8003fd:	68 58 3b 80 00       	push   $0x803b58
  800402:	6a 67                	push   $0x67
  800404:	68 fc 3a 80 00       	push   $0x803afc
  800409:	e8 ae 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80040e:	e8 32 19 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  800413:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800416:	74 14                	je     80042c <_main+0x3f4>
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	68 88 3b 80 00       	push   $0x803b88
  800420:	6a 69                	push   $0x69
  800422:	68 fc 3a 80 00       	push   $0x803afc
  800427:	e8 90 03 00 00       	call   8007bc <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  80042c:	e8 74 18 00 00       	call   801ca5 <sys_calculate_free_frames>
  800431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800434:	e8 0c 19 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
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
  800483:	68 58 3b 80 00       	push   $0x803b58
  800488:	6a 6f                	push   $0x6f
  80048a:	68 fc 3a 80 00       	push   $0x803afc
  80048f:	e8 28 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800494:	e8 ac 18 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  800499:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80049c:	74 14                	je     8004b2 <_main+0x47a>
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	68 88 3b 80 00       	push   $0x803b88
  8004a6:	6a 71                	push   $0x71
  8004a8:	68 fc 3a 80 00       	push   $0x803afc
  8004ad:	e8 0a 03 00 00       	call   8007bc <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004b2:	e8 ee 17 00 00       	call   801ca5 <sys_calculate_free_frames>
  8004b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004ba:	e8 86 18 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  8004bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  8004c2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	50                   	push   %eax
  8004c9:	e8 58 15 00 00       	call   801a26 <free>
  8004ce:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8004d1:	e8 6f 18 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  8004d6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d9:	74 14                	je     8004ef <_main+0x4b7>
  8004db:	83 ec 04             	sub    $0x4,%esp
  8004de:	68 a5 3b 80 00       	push   $0x803ba5
  8004e3:	6a 78                	push   $0x78
  8004e5:	68 fc 3a 80 00       	push   $0x803afc
  8004ea:	e8 cd 02 00 00       	call   8007bc <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 b1 17 00 00       	call   801ca5 <sys_calculate_free_frames>
  8004f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 49 18 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8004ff:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	50                   	push   %eax
  800506:	e8 1b 15 00 00       	call   801a26 <free>
  80050b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  80050e:	e8 32 18 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  800513:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 a5 3b 80 00       	push   $0x803ba5
  800520:	6a 7f                	push   $0x7f
  800522:	68 fc 3a 80 00       	push   $0x803afc
  800527:	e8 90 02 00 00       	call   8007bc <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 74 17 00 00       	call   801ca5 <sys_calculate_free_frames>
  800531:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800534:	e8 0c 18 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
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
  800583:	68 58 3b 80 00       	push   $0x803b58
  800588:	68 85 00 00 00       	push   $0x85
  80058d:	68 fc 3a 80 00       	push   $0x803afc
  800592:	e8 25 02 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800597:	e8 a9 17 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  80059c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059f:	74 17                	je     8005b8 <_main+0x580>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 88 3b 80 00       	push   $0x803b88
  8005a9:	68 87 00 00 00       	push   $0x87
  8005ae:	68 fc 3a 80 00       	push   $0x803afc
  8005b3:	e8 04 02 00 00       	call   8007bc <_panic>
		//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8005b8:	e8 e8 16 00 00       	call   801ca5 <sys_calculate_free_frames>
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005c0:	e8 80 17 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
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
  8005f0:	68 58 3b 80 00       	push   $0x803b58
  8005f5:	68 95 00 00 00       	push   $0x95
  8005fa:	68 fc 3a 80 00       	push   $0x803afc
  8005ff:	e8 b8 01 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800604:	e8 3c 17 00 00       	call   801d45 <sys_pf_calculate_allocated_pages>
  800609:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80060c:	74 17                	je     800625 <_main+0x5ed>
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	68 88 3b 80 00       	push   $0x803b88
  800616:	68 97 00 00 00       	push   $0x97
  80061b:	68 fc 3a 80 00       	push   $0x803afc
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
  800654:	68 bc 3b 80 00       	push   $0x803bbc
  800659:	68 a0 00 00 00       	push   $0xa0
  80065e:	68 fc 3a 80 00       	push   $0x803afc
  800663:	e8 54 01 00 00       	call   8007bc <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	68 20 3c 80 00       	push   $0x803c20
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
  800686:	e8 fa 18 00 00       	call   801f85 <sys_getenvindex>
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
  8006f1:	e8 9c 16 00 00       	call   801d92 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	68 84 3c 80 00       	push   $0x803c84
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
  800721:	68 ac 3c 80 00       	push   $0x803cac
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
  800752:	68 d4 3c 80 00       	push   $0x803cd4
  800757:	e8 14 03 00 00       	call   800a70 <cprintf>
  80075c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80075f:	a1 20 50 80 00       	mov    0x805020,%eax
  800764:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	50                   	push   %eax
  80076e:	68 2c 3d 80 00       	push   $0x803d2c
  800773:	e8 f8 02 00 00       	call   800a70 <cprintf>
  800778:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	68 84 3c 80 00       	push   $0x803c84
  800783:	e8 e8 02 00 00       	call   800a70 <cprintf>
  800788:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80078b:	e8 1c 16 00 00       	call   801dac <sys_enable_interrupt>

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
  8007a3:	e8 a9 17 00 00       	call   801f51 <sys_destroy_env>
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
  8007b4:	e8 fe 17 00 00       	call   801fb7 <sys_exit_env>
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
  8007dd:	68 40 3d 80 00       	push   $0x803d40
  8007e2:	e8 89 02 00 00       	call   800a70 <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ea:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	50                   	push   %eax
  8007f6:	68 45 3d 80 00       	push   $0x803d45
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
  80081a:	68 61 3d 80 00       	push   $0x803d61
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
  800846:	68 64 3d 80 00       	push   $0x803d64
  80084b:	6a 26                	push   $0x26
  80084d:	68 b0 3d 80 00       	push   $0x803db0
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
  800918:	68 bc 3d 80 00       	push   $0x803dbc
  80091d:	6a 3a                	push   $0x3a
  80091f:	68 b0 3d 80 00       	push   $0x803db0
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
  800988:	68 10 3e 80 00       	push   $0x803e10
  80098d:	6a 44                	push   $0x44
  80098f:	68 b0 3d 80 00       	push   $0x803db0
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
  8009e2:	e8 fd 11 00 00       	call   801be4 <sys_cputs>
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
  800a59:	e8 86 11 00 00       	call   801be4 <sys_cputs>
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
  800aa3:	e8 ea 12 00 00       	call   801d92 <sys_disable_interrupt>
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
  800ac3:	e8 e4 12 00 00       	call   801dac <sys_enable_interrupt>
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
  800b0d:	e8 56 2d 00 00       	call   803868 <__udivdi3>
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
  800b5d:	e8 16 2e 00 00       	call   803978 <__umoddi3>
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	05 74 40 80 00       	add    $0x804074,%eax
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
  800cb8:	8b 04 85 98 40 80 00 	mov    0x804098(,%eax,4),%eax
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
  800d99:	8b 34 9d e0 3e 80 00 	mov    0x803ee0(,%ebx,4),%esi
  800da0:	85 f6                	test   %esi,%esi
  800da2:	75 19                	jne    800dbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da4:	53                   	push   %ebx
  800da5:	68 85 40 80 00       	push   $0x804085
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
  800dbe:	68 8e 40 80 00       	push   $0x80408e
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
  800deb:	be 91 40 80 00       	mov    $0x804091,%esi
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
  801811:	68 f0 41 80 00       	push   $0x8041f0
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
  8018e1:	e8 42 04 00 00       	call   801d28 <sys_allocate_chunk>
  8018e6:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018e9:	a1 20 51 80 00       	mov    0x805120,%eax
  8018ee:	83 ec 0c             	sub    $0xc,%esp
  8018f1:	50                   	push   %eax
  8018f2:	e8 b7 0a 00 00       	call   8023ae <initialize_MemBlocksList>
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
  80191f:	68 15 42 80 00       	push   $0x804215
  801924:	6a 33                	push   $0x33
  801926:	68 33 42 80 00       	push   $0x804233
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
  80199e:	68 40 42 80 00       	push   $0x804240
  8019a3:	6a 34                	push   $0x34
  8019a5:	68 33 42 80 00       	push   $0x804233
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
  8019fb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019fe:	e8 f7 fd ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  801a03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a07:	75 07                	jne    801a10 <malloc+0x18>
  801a09:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0e:	eb 14                	jmp    801a24 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801a10:	83 ec 04             	sub    $0x4,%esp
  801a13:	68 64 42 80 00       	push   $0x804264
  801a18:	6a 46                	push   $0x46
  801a1a:	68 33 42 80 00       	push   $0x804233
  801a1f:	e8 98 ed ff ff       	call   8007bc <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	68 8c 42 80 00       	push   $0x80428c
  801a34:	6a 61                	push   $0x61
  801a36:	68 33 42 80 00       	push   $0x804233
  801a3b:	e8 7c ed ff ff       	call   8007bc <_panic>

00801a40 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 38             	sub    $0x38,%esp
  801a46:	8b 45 10             	mov    0x10(%ebp),%eax
  801a49:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a4c:	e8 a9 fd ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  801a51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a55:	75 0a                	jne    801a61 <smalloc+0x21>
  801a57:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5c:	e9 9e 00 00 00       	jmp    801aff <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a61:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6e:	01 d0                	add    %edx,%eax
  801a70:	48                   	dec    %eax
  801a71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a77:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7c:	f7 75 f0             	divl   -0x10(%ebp)
  801a7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a82:	29 d0                	sub    %edx,%eax
  801a84:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801a87:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a8e:	e8 63 06 00 00       	call   8020f6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a93:	85 c0                	test   %eax,%eax
  801a95:	74 11                	je     801aa8 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801a97:	83 ec 0c             	sub    $0xc,%esp
  801a9a:	ff 75 e8             	pushl  -0x18(%ebp)
  801a9d:	e8 ce 0c 00 00       	call   802770 <alloc_block_FF>
  801aa2:	83 c4 10             	add    $0x10,%esp
  801aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801aa8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aac:	74 4c                	je     801afa <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab1:	8b 40 08             	mov    0x8(%eax),%eax
  801ab4:	89 c2                	mov    %eax,%edx
  801ab6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801aba:	52                   	push   %edx
  801abb:	50                   	push   %eax
  801abc:	ff 75 0c             	pushl  0xc(%ebp)
  801abf:	ff 75 08             	pushl  0x8(%ebp)
  801ac2:	e8 b4 03 00 00       	call   801e7b <sys_createSharedObject>
  801ac7:	83 c4 10             	add    $0x10,%esp
  801aca:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801acd:	83 ec 08             	sub    $0x8,%esp
  801ad0:	ff 75 e0             	pushl  -0x20(%ebp)
  801ad3:	68 af 42 80 00       	push   $0x8042af
  801ad8:	e8 93 ef ff ff       	call   800a70 <cprintf>
  801add:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801ae0:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801ae4:	74 14                	je     801afa <smalloc+0xba>
  801ae6:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801aea:	74 0e                	je     801afa <smalloc+0xba>
  801aec:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801af0:	74 08                	je     801afa <smalloc+0xba>
			return (void*) mem_block->sva;
  801af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af5:	8b 40 08             	mov    0x8(%eax),%eax
  801af8:	eb 05                	jmp    801aff <smalloc+0xbf>
	}
	return NULL;
  801afa:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b07:	e8 ee fc ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801b0c:	83 ec 04             	sub    $0x4,%esp
  801b0f:	68 c4 42 80 00       	push   $0x8042c4
  801b14:	68 ab 00 00 00       	push   $0xab
  801b19:	68 33 42 80 00       	push   $0x804233
  801b1e:	e8 99 ec ff ff       	call   8007bc <_panic>

00801b23 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
  801b26:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b29:	e8 cc fc ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b2e:	83 ec 04             	sub    $0x4,%esp
  801b31:	68 e8 42 80 00       	push   $0x8042e8
  801b36:	68 ef 00 00 00       	push   $0xef
  801b3b:	68 33 42 80 00       	push   $0x804233
  801b40:	e8 77 ec ff ff       	call   8007bc <_panic>

00801b45 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b4b:	83 ec 04             	sub    $0x4,%esp
  801b4e:	68 10 43 80 00       	push   $0x804310
  801b53:	68 03 01 00 00       	push   $0x103
  801b58:	68 33 42 80 00       	push   $0x804233
  801b5d:	e8 5a ec ff ff       	call   8007bc <_panic>

00801b62 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b68:	83 ec 04             	sub    $0x4,%esp
  801b6b:	68 34 43 80 00       	push   $0x804334
  801b70:	68 0e 01 00 00       	push   $0x10e
  801b75:	68 33 42 80 00       	push   $0x804233
  801b7a:	e8 3d ec ff ff       	call   8007bc <_panic>

00801b7f <shrink>:

}
void shrink(uint32 newSize)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b85:	83 ec 04             	sub    $0x4,%esp
  801b88:	68 34 43 80 00       	push   $0x804334
  801b8d:	68 13 01 00 00       	push   $0x113
  801b92:	68 33 42 80 00       	push   $0x804233
  801b97:	e8 20 ec ff ff       	call   8007bc <_panic>

00801b9c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ba2:	83 ec 04             	sub    $0x4,%esp
  801ba5:	68 34 43 80 00       	push   $0x804334
  801baa:	68 18 01 00 00       	push   $0x118
  801baf:	68 33 42 80 00       	push   $0x804233
  801bb4:	e8 03 ec ff ff       	call   8007bc <_panic>

00801bb9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	57                   	push   %edi
  801bbd:	56                   	push   %esi
  801bbe:	53                   	push   %ebx
  801bbf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bcb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bce:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bd1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bd4:	cd 30                	int    $0x30
  801bd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bdc:	83 c4 10             	add    $0x10,%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5f                   	pop    %edi
  801be2:	5d                   	pop    %ebp
  801be3:	c3                   	ret    

00801be4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 04             	sub    $0x4,%esp
  801bea:	8b 45 10             	mov    0x10(%ebp),%eax
  801bed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801bf0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	52                   	push   %edx
  801bfc:	ff 75 0c             	pushl  0xc(%ebp)
  801bff:	50                   	push   %eax
  801c00:	6a 00                	push   $0x0
  801c02:	e8 b2 ff ff ff       	call   801bb9 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
}
  801c0a:	90                   	nop
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_cgetc>:

int
sys_cgetc(void)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 01                	push   $0x1
  801c1c:	e8 98 ff ff ff       	call   801bb9 <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	52                   	push   %edx
  801c36:	50                   	push   %eax
  801c37:	6a 05                	push   $0x5
  801c39:	e8 7b ff ff ff       	call   801bb9 <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	56                   	push   %esi
  801c47:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c48:	8b 75 18             	mov    0x18(%ebp),%esi
  801c4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	56                   	push   %esi
  801c58:	53                   	push   %ebx
  801c59:	51                   	push   %ecx
  801c5a:	52                   	push   %edx
  801c5b:	50                   	push   %eax
  801c5c:	6a 06                	push   $0x6
  801c5e:	e8 56 ff ff ff       	call   801bb9 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c69:	5b                   	pop    %ebx
  801c6a:	5e                   	pop    %esi
  801c6b:	5d                   	pop    %ebp
  801c6c:	c3                   	ret    

00801c6d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	52                   	push   %edx
  801c7d:	50                   	push   %eax
  801c7e:	6a 07                	push   $0x7
  801c80:	e8 34 ff ff ff       	call   801bb9 <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	ff 75 0c             	pushl  0xc(%ebp)
  801c96:	ff 75 08             	pushl  0x8(%ebp)
  801c99:	6a 08                	push   $0x8
  801c9b:	e8 19 ff ff ff       	call   801bb9 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 09                	push   $0x9
  801cb4:	e8 00 ff ff ff       	call   801bb9 <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 0a                	push   $0xa
  801ccd:	e8 e7 fe ff ff       	call   801bb9 <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 0b                	push   $0xb
  801ce6:	e8 ce fe ff ff       	call   801bb9 <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	ff 75 0c             	pushl  0xc(%ebp)
  801cfc:	ff 75 08             	pushl  0x8(%ebp)
  801cff:	6a 0f                	push   $0xf
  801d01:	e8 b3 fe ff ff       	call   801bb9 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
	return;
  801d09:	90                   	nop
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	ff 75 0c             	pushl  0xc(%ebp)
  801d18:	ff 75 08             	pushl  0x8(%ebp)
  801d1b:	6a 10                	push   $0x10
  801d1d:	e8 97 fe ff ff       	call   801bb9 <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
	return ;
  801d25:	90                   	nop
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	ff 75 10             	pushl  0x10(%ebp)
  801d32:	ff 75 0c             	pushl  0xc(%ebp)
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	6a 11                	push   $0x11
  801d3a:	e8 7a fe ff ff       	call   801bb9 <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d42:	90                   	nop
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 0c                	push   $0xc
  801d54:	e8 60 fe ff ff       	call   801bb9 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	ff 75 08             	pushl  0x8(%ebp)
  801d6c:	6a 0d                	push   $0xd
  801d6e:	e8 46 fe ff ff       	call   801bb9 <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 0e                	push   $0xe
  801d87:	e8 2d fe ff ff       	call   801bb9 <syscall>
  801d8c:	83 c4 18             	add    $0x18,%esp
}
  801d8f:	90                   	nop
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 13                	push   $0x13
  801da1:	e8 13 fe ff ff       	call   801bb9 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
}
  801da9:	90                   	nop
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 14                	push   $0x14
  801dbb:	e8 f9 fd ff ff       	call   801bb9 <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
}
  801dc3:	90                   	nop
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <sys_cputc>:


void
sys_cputc(const char c)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	83 ec 04             	sub    $0x4,%esp
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801dd2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	50                   	push   %eax
  801ddf:	6a 15                	push   $0x15
  801de1:	e8 d3 fd ff ff       	call   801bb9 <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	90                   	nop
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 16                	push   $0x16
  801dfb:	e8 b9 fd ff ff       	call   801bb9 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
}
  801e03:	90                   	nop
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	ff 75 0c             	pushl  0xc(%ebp)
  801e15:	50                   	push   %eax
  801e16:	6a 17                	push   $0x17
  801e18:	e8 9c fd ff ff       	call   801bb9 <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	52                   	push   %edx
  801e32:	50                   	push   %eax
  801e33:	6a 1a                	push   $0x1a
  801e35:	e8 7f fd ff ff       	call   801bb9 <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	52                   	push   %edx
  801e4f:	50                   	push   %eax
  801e50:	6a 18                	push   $0x18
  801e52:	e8 62 fd ff ff       	call   801bb9 <syscall>
  801e57:	83 c4 18             	add    $0x18,%esp
}
  801e5a:	90                   	nop
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e63:	8b 45 08             	mov    0x8(%ebp),%eax
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	52                   	push   %edx
  801e6d:	50                   	push   %eax
  801e6e:	6a 19                	push   $0x19
  801e70:	e8 44 fd ff ff       	call   801bb9 <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
}
  801e78:	90                   	nop
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 04             	sub    $0x4,%esp
  801e81:	8b 45 10             	mov    0x10(%ebp),%eax
  801e84:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e87:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e8a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	6a 00                	push   $0x0
  801e93:	51                   	push   %ecx
  801e94:	52                   	push   %edx
  801e95:	ff 75 0c             	pushl  0xc(%ebp)
  801e98:	50                   	push   %eax
  801e99:	6a 1b                	push   $0x1b
  801e9b:	e8 19 fd ff ff       	call   801bb9 <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ea8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	52                   	push   %edx
  801eb5:	50                   	push   %eax
  801eb6:	6a 1c                	push   $0x1c
  801eb8:	e8 fc fc ff ff       	call   801bb9 <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ec5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ec8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	51                   	push   %ecx
  801ed3:	52                   	push   %edx
  801ed4:	50                   	push   %eax
  801ed5:	6a 1d                	push   $0x1d
  801ed7:	e8 dd fc ff ff       	call   801bb9 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	52                   	push   %edx
  801ef1:	50                   	push   %eax
  801ef2:	6a 1e                	push   $0x1e
  801ef4:	e8 c0 fc ff ff       	call   801bb9 <syscall>
  801ef9:	83 c4 18             	add    $0x18,%esp
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 1f                	push   $0x1f
  801f0d:	e8 a7 fc ff ff       	call   801bb9 <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	ff 75 14             	pushl  0x14(%ebp)
  801f22:	ff 75 10             	pushl  0x10(%ebp)
  801f25:	ff 75 0c             	pushl  0xc(%ebp)
  801f28:	50                   	push   %eax
  801f29:	6a 20                	push   $0x20
  801f2b:	e8 89 fc ff ff       	call   801bb9 <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	50                   	push   %eax
  801f44:	6a 21                	push   $0x21
  801f46:	e8 6e fc ff ff       	call   801bb9 <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
}
  801f4e:	90                   	nop
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	50                   	push   %eax
  801f60:	6a 22                	push   $0x22
  801f62:	e8 52 fc ff ff       	call   801bb9 <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 02                	push   $0x2
  801f7b:	e8 39 fc ff ff       	call   801bb9 <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 03                	push   $0x3
  801f94:	e8 20 fc ff ff       	call   801bb9 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 04                	push   $0x4
  801fad:	e8 07 fc ff ff       	call   801bb9 <syscall>
  801fb2:	83 c4 18             	add    $0x18,%esp
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <sys_exit_env>:


void sys_exit_env(void)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 23                	push   $0x23
  801fc6:	e8 ee fb ff ff       	call   801bb9 <syscall>
  801fcb:	83 c4 18             	add    $0x18,%esp
}
  801fce:	90                   	nop
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fd7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fda:	8d 50 04             	lea    0x4(%eax),%edx
  801fdd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	52                   	push   %edx
  801fe7:	50                   	push   %eax
  801fe8:	6a 24                	push   $0x24
  801fea:	e8 ca fb ff ff       	call   801bb9 <syscall>
  801fef:	83 c4 18             	add    $0x18,%esp
	return result;
  801ff2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ff5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ff8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ffb:	89 01                	mov    %eax,(%ecx)
  801ffd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802000:	8b 45 08             	mov    0x8(%ebp),%eax
  802003:	c9                   	leave  
  802004:	c2 04 00             	ret    $0x4

00802007 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	ff 75 10             	pushl  0x10(%ebp)
  802011:	ff 75 0c             	pushl  0xc(%ebp)
  802014:	ff 75 08             	pushl  0x8(%ebp)
  802017:	6a 12                	push   $0x12
  802019:	e8 9b fb ff ff       	call   801bb9 <syscall>
  80201e:	83 c4 18             	add    $0x18,%esp
	return ;
  802021:	90                   	nop
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <sys_rcr2>:
uint32 sys_rcr2()
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 25                	push   $0x25
  802033:	e8 81 fb ff ff       	call   801bb9 <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 04             	sub    $0x4,%esp
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802049:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	50                   	push   %eax
  802056:	6a 26                	push   $0x26
  802058:	e8 5c fb ff ff       	call   801bb9 <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
	return ;
  802060:	90                   	nop
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <rsttst>:
void rsttst()
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 28                	push   $0x28
  802072:	e8 42 fb ff ff       	call   801bb9 <syscall>
  802077:	83 c4 18             	add    $0x18,%esp
	return ;
  80207a:	90                   	nop
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	83 ec 04             	sub    $0x4,%esp
  802083:	8b 45 14             	mov    0x14(%ebp),%eax
  802086:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802089:	8b 55 18             	mov    0x18(%ebp),%edx
  80208c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802090:	52                   	push   %edx
  802091:	50                   	push   %eax
  802092:	ff 75 10             	pushl  0x10(%ebp)
  802095:	ff 75 0c             	pushl  0xc(%ebp)
  802098:	ff 75 08             	pushl  0x8(%ebp)
  80209b:	6a 27                	push   $0x27
  80209d:	e8 17 fb ff ff       	call   801bb9 <syscall>
  8020a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a5:	90                   	nop
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <chktst>:
void chktst(uint32 n)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	ff 75 08             	pushl  0x8(%ebp)
  8020b6:	6a 29                	push   $0x29
  8020b8:	e8 fc fa ff ff       	call   801bb9 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c0:	90                   	nop
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <inctst>:

void inctst()
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 2a                	push   $0x2a
  8020d2:	e8 e2 fa ff ff       	call   801bb9 <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8020da:	90                   	nop
}
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <gettst>:
uint32 gettst()
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 2b                	push   $0x2b
  8020ec:	e8 c8 fa ff ff       	call   801bb9 <syscall>
  8020f1:	83 c4 18             	add    $0x18,%esp
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 2c                	push   $0x2c
  802108:	e8 ac fa ff ff       	call   801bb9 <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
  802110:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802113:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802117:	75 07                	jne    802120 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802119:	b8 01 00 00 00       	mov    $0x1,%eax
  80211e:	eb 05                	jmp    802125 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802120:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 2c                	push   $0x2c
  802139:	e8 7b fa ff ff       	call   801bb9 <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
  802141:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802144:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802148:	75 07                	jne    802151 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80214a:	b8 01 00 00 00       	mov    $0x1,%eax
  80214f:	eb 05                	jmp    802156 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802151:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 2c                	push   $0x2c
  80216a:	e8 4a fa ff ff       	call   801bb9 <syscall>
  80216f:	83 c4 18             	add    $0x18,%esp
  802172:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802175:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802179:	75 07                	jne    802182 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80217b:	b8 01 00 00 00       	mov    $0x1,%eax
  802180:	eb 05                	jmp    802187 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802182:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802187:	c9                   	leave  
  802188:	c3                   	ret    

00802189 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 2c                	push   $0x2c
  80219b:	e8 19 fa ff ff       	call   801bb9 <syscall>
  8021a0:	83 c4 18             	add    $0x18,%esp
  8021a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021a6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021aa:	75 07                	jne    8021b3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b1:	eb 05                	jmp    8021b8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	ff 75 08             	pushl  0x8(%ebp)
  8021c8:	6a 2d                	push   $0x2d
  8021ca:	e8 ea f9 ff ff       	call   801bb9 <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d2:	90                   	nop
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	6a 00                	push   $0x0
  8021e7:	53                   	push   %ebx
  8021e8:	51                   	push   %ecx
  8021e9:	52                   	push   %edx
  8021ea:	50                   	push   %eax
  8021eb:	6a 2e                	push   $0x2e
  8021ed:	e8 c7 f9 ff ff       	call   801bb9 <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
}
  8021f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	52                   	push   %edx
  80220a:	50                   	push   %eax
  80220b:	6a 2f                	push   $0x2f
  80220d:	e8 a7 f9 ff ff       	call   801bb9 <syscall>
  802212:	83 c4 18             	add    $0x18,%esp
}
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80221d:	83 ec 0c             	sub    $0xc,%esp
  802220:	68 44 43 80 00       	push   $0x804344
  802225:	e8 46 e8 ff ff       	call   800a70 <cprintf>
  80222a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80222d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802234:	83 ec 0c             	sub    $0xc,%esp
  802237:	68 70 43 80 00       	push   $0x804370
  80223c:	e8 2f e8 ff ff       	call   800a70 <cprintf>
  802241:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802244:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802248:	a1 38 51 80 00       	mov    0x805138,%eax
  80224d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802250:	eb 56                	jmp    8022a8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802252:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802256:	74 1c                	je     802274 <print_mem_block_lists+0x5d>
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	8b 50 08             	mov    0x8(%eax),%edx
  80225e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802261:	8b 48 08             	mov    0x8(%eax),%ecx
  802264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802267:	8b 40 0c             	mov    0xc(%eax),%eax
  80226a:	01 c8                	add    %ecx,%eax
  80226c:	39 c2                	cmp    %eax,%edx
  80226e:	73 04                	jae    802274 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802270:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802277:	8b 50 08             	mov    0x8(%eax),%edx
  80227a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227d:	8b 40 0c             	mov    0xc(%eax),%eax
  802280:	01 c2                	add    %eax,%edx
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	8b 40 08             	mov    0x8(%eax),%eax
  802288:	83 ec 04             	sub    $0x4,%esp
  80228b:	52                   	push   %edx
  80228c:	50                   	push   %eax
  80228d:	68 85 43 80 00       	push   $0x804385
  802292:	e8 d9 e7 ff ff       	call   800a70 <cprintf>
  802297:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022a0:	a1 40 51 80 00       	mov    0x805140,%eax
  8022a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ac:	74 07                	je     8022b5 <print_mem_block_lists+0x9e>
  8022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b1:	8b 00                	mov    (%eax),%eax
  8022b3:	eb 05                	jmp    8022ba <print_mem_block_lists+0xa3>
  8022b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ba:	a3 40 51 80 00       	mov    %eax,0x805140
  8022bf:	a1 40 51 80 00       	mov    0x805140,%eax
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	75 8a                	jne    802252 <print_mem_block_lists+0x3b>
  8022c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022cc:	75 84                	jne    802252 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8022ce:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022d2:	75 10                	jne    8022e4 <print_mem_block_lists+0xcd>
  8022d4:	83 ec 0c             	sub    $0xc,%esp
  8022d7:	68 94 43 80 00       	push   $0x804394
  8022dc:	e8 8f e7 ff ff       	call   800a70 <cprintf>
  8022e1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8022e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8022eb:	83 ec 0c             	sub    $0xc,%esp
  8022ee:	68 b8 43 80 00       	push   $0x8043b8
  8022f3:	e8 78 e7 ff ff       	call   800a70 <cprintf>
  8022f8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8022fb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022ff:	a1 40 50 80 00       	mov    0x805040,%eax
  802304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802307:	eb 56                	jmp    80235f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802309:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80230d:	74 1c                	je     80232b <print_mem_block_lists+0x114>
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	8b 50 08             	mov    0x8(%eax),%edx
  802315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802318:	8b 48 08             	mov    0x8(%eax),%ecx
  80231b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231e:	8b 40 0c             	mov    0xc(%eax),%eax
  802321:	01 c8                	add    %ecx,%eax
  802323:	39 c2                	cmp    %eax,%edx
  802325:	73 04                	jae    80232b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802327:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	8b 50 08             	mov    0x8(%eax),%edx
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	8b 40 0c             	mov    0xc(%eax),%eax
  802337:	01 c2                	add    %eax,%edx
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	8b 40 08             	mov    0x8(%eax),%eax
  80233f:	83 ec 04             	sub    $0x4,%esp
  802342:	52                   	push   %edx
  802343:	50                   	push   %eax
  802344:	68 85 43 80 00       	push   $0x804385
  802349:	e8 22 e7 ff ff       	call   800a70 <cprintf>
  80234e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802357:	a1 48 50 80 00       	mov    0x805048,%eax
  80235c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80235f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802363:	74 07                	je     80236c <print_mem_block_lists+0x155>
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 00                	mov    (%eax),%eax
  80236a:	eb 05                	jmp    802371 <print_mem_block_lists+0x15a>
  80236c:	b8 00 00 00 00       	mov    $0x0,%eax
  802371:	a3 48 50 80 00       	mov    %eax,0x805048
  802376:	a1 48 50 80 00       	mov    0x805048,%eax
  80237b:	85 c0                	test   %eax,%eax
  80237d:	75 8a                	jne    802309 <print_mem_block_lists+0xf2>
  80237f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802383:	75 84                	jne    802309 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802385:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802389:	75 10                	jne    80239b <print_mem_block_lists+0x184>
  80238b:	83 ec 0c             	sub    $0xc,%esp
  80238e:	68 d0 43 80 00       	push   $0x8043d0
  802393:	e8 d8 e6 ff ff       	call   800a70 <cprintf>
  802398:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80239b:	83 ec 0c             	sub    $0xc,%esp
  80239e:	68 44 43 80 00       	push   $0x804344
  8023a3:	e8 c8 e6 ff ff       	call   800a70 <cprintf>
  8023a8:	83 c4 10             	add    $0x10,%esp

}
  8023ab:	90                   	nop
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
  8023b1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8023b4:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8023bb:	00 00 00 
  8023be:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8023c5:	00 00 00 
  8023c8:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8023cf:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8023d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8023d9:	e9 9e 00 00 00       	jmp    80247c <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8023de:	a1 50 50 80 00       	mov    0x805050,%eax
  8023e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e6:	c1 e2 04             	shl    $0x4,%edx
  8023e9:	01 d0                	add    %edx,%eax
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	75 14                	jne    802403 <initialize_MemBlocksList+0x55>
  8023ef:	83 ec 04             	sub    $0x4,%esp
  8023f2:	68 f8 43 80 00       	push   $0x8043f8
  8023f7:	6a 46                	push   $0x46
  8023f9:	68 1b 44 80 00       	push   $0x80441b
  8023fe:	e8 b9 e3 ff ff       	call   8007bc <_panic>
  802403:	a1 50 50 80 00       	mov    0x805050,%eax
  802408:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240b:	c1 e2 04             	shl    $0x4,%edx
  80240e:	01 d0                	add    %edx,%eax
  802410:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802416:	89 10                	mov    %edx,(%eax)
  802418:	8b 00                	mov    (%eax),%eax
  80241a:	85 c0                	test   %eax,%eax
  80241c:	74 18                	je     802436 <initialize_MemBlocksList+0x88>
  80241e:	a1 48 51 80 00       	mov    0x805148,%eax
  802423:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802429:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80242c:	c1 e1 04             	shl    $0x4,%ecx
  80242f:	01 ca                	add    %ecx,%edx
  802431:	89 50 04             	mov    %edx,0x4(%eax)
  802434:	eb 12                	jmp    802448 <initialize_MemBlocksList+0x9a>
  802436:	a1 50 50 80 00       	mov    0x805050,%eax
  80243b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243e:	c1 e2 04             	shl    $0x4,%edx
  802441:	01 d0                	add    %edx,%eax
  802443:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802448:	a1 50 50 80 00       	mov    0x805050,%eax
  80244d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802450:	c1 e2 04             	shl    $0x4,%edx
  802453:	01 d0                	add    %edx,%eax
  802455:	a3 48 51 80 00       	mov    %eax,0x805148
  80245a:	a1 50 50 80 00       	mov    0x805050,%eax
  80245f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802462:	c1 e2 04             	shl    $0x4,%edx
  802465:	01 d0                	add    %edx,%eax
  802467:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246e:	a1 54 51 80 00       	mov    0x805154,%eax
  802473:	40                   	inc    %eax
  802474:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802479:	ff 45 f4             	incl   -0xc(%ebp)
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802482:	0f 82 56 ff ff ff    	jb     8023de <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802488:	90                   	nop
  802489:	c9                   	leave  
  80248a:	c3                   	ret    

0080248b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
  80248e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802491:	8b 45 08             	mov    0x8(%ebp),%eax
  802494:	8b 00                	mov    (%eax),%eax
  802496:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802499:	eb 19                	jmp    8024b4 <find_block+0x29>
	{
		if(va==point->sva)
  80249b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80249e:	8b 40 08             	mov    0x8(%eax),%eax
  8024a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8024a4:	75 05                	jne    8024ab <find_block+0x20>
		   return point;
  8024a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024a9:	eb 36                	jmp    8024e1 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	8b 40 08             	mov    0x8(%eax),%eax
  8024b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8024b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024b8:	74 07                	je     8024c1 <find_block+0x36>
  8024ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024bd:	8b 00                	mov    (%eax),%eax
  8024bf:	eb 05                	jmp    8024c6 <find_block+0x3b>
  8024c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c9:	89 42 08             	mov    %eax,0x8(%edx)
  8024cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cf:	8b 40 08             	mov    0x8(%eax),%eax
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	75 c5                	jne    80249b <find_block+0x10>
  8024d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024da:	75 bf                	jne    80249b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8024dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e1:	c9                   	leave  
  8024e2:	c3                   	ret    

008024e3 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8024e3:	55                   	push   %ebp
  8024e4:	89 e5                	mov    %esp,%ebp
  8024e6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8024e9:	a1 40 50 80 00       	mov    0x805040,%eax
  8024ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8024f1:	a1 44 50 80 00       	mov    0x805044,%eax
  8024f6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8024f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024ff:	74 24                	je     802525 <insert_sorted_allocList+0x42>
  802501:	8b 45 08             	mov    0x8(%ebp),%eax
  802504:	8b 50 08             	mov    0x8(%eax),%edx
  802507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250a:	8b 40 08             	mov    0x8(%eax),%eax
  80250d:	39 c2                	cmp    %eax,%edx
  80250f:	76 14                	jbe    802525 <insert_sorted_allocList+0x42>
  802511:	8b 45 08             	mov    0x8(%ebp),%eax
  802514:	8b 50 08             	mov    0x8(%eax),%edx
  802517:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251a:	8b 40 08             	mov    0x8(%eax),%eax
  80251d:	39 c2                	cmp    %eax,%edx
  80251f:	0f 82 60 01 00 00    	jb     802685 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802525:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802529:	75 65                	jne    802590 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80252b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80252f:	75 14                	jne    802545 <insert_sorted_allocList+0x62>
  802531:	83 ec 04             	sub    $0x4,%esp
  802534:	68 f8 43 80 00       	push   $0x8043f8
  802539:	6a 6b                	push   $0x6b
  80253b:	68 1b 44 80 00       	push   $0x80441b
  802540:	e8 77 e2 ff ff       	call   8007bc <_panic>
  802545:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	89 10                	mov    %edx,(%eax)
  802550:	8b 45 08             	mov    0x8(%ebp),%eax
  802553:	8b 00                	mov    (%eax),%eax
  802555:	85 c0                	test   %eax,%eax
  802557:	74 0d                	je     802566 <insert_sorted_allocList+0x83>
  802559:	a1 40 50 80 00       	mov    0x805040,%eax
  80255e:	8b 55 08             	mov    0x8(%ebp),%edx
  802561:	89 50 04             	mov    %edx,0x4(%eax)
  802564:	eb 08                	jmp    80256e <insert_sorted_allocList+0x8b>
  802566:	8b 45 08             	mov    0x8(%ebp),%eax
  802569:	a3 44 50 80 00       	mov    %eax,0x805044
  80256e:	8b 45 08             	mov    0x8(%ebp),%eax
  802571:	a3 40 50 80 00       	mov    %eax,0x805040
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802580:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802585:	40                   	inc    %eax
  802586:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80258b:	e9 dc 01 00 00       	jmp    80276c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802590:	8b 45 08             	mov    0x8(%ebp),%eax
  802593:	8b 50 08             	mov    0x8(%eax),%edx
  802596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802599:	8b 40 08             	mov    0x8(%eax),%eax
  80259c:	39 c2                	cmp    %eax,%edx
  80259e:	77 6c                	ja     80260c <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8025a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025a4:	74 06                	je     8025ac <insert_sorted_allocList+0xc9>
  8025a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025aa:	75 14                	jne    8025c0 <insert_sorted_allocList+0xdd>
  8025ac:	83 ec 04             	sub    $0x4,%esp
  8025af:	68 34 44 80 00       	push   $0x804434
  8025b4:	6a 6f                	push   $0x6f
  8025b6:	68 1b 44 80 00       	push   $0x80441b
  8025bb:	e8 fc e1 ff ff       	call   8007bc <_panic>
  8025c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c3:	8b 50 04             	mov    0x4(%eax),%edx
  8025c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c9:	89 50 04             	mov    %edx,0x4(%eax)
  8025cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025d2:	89 10                	mov    %edx,(%eax)
  8025d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d7:	8b 40 04             	mov    0x4(%eax),%eax
  8025da:	85 c0                	test   %eax,%eax
  8025dc:	74 0d                	je     8025eb <insert_sorted_allocList+0x108>
  8025de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e1:	8b 40 04             	mov    0x4(%eax),%eax
  8025e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e7:	89 10                	mov    %edx,(%eax)
  8025e9:	eb 08                	jmp    8025f3 <insert_sorted_allocList+0x110>
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	a3 40 50 80 00       	mov    %eax,0x805040
  8025f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f9:	89 50 04             	mov    %edx,0x4(%eax)
  8025fc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802601:	40                   	inc    %eax
  802602:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802607:	e9 60 01 00 00       	jmp    80276c <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80260c:	8b 45 08             	mov    0x8(%ebp),%eax
  80260f:	8b 50 08             	mov    0x8(%eax),%edx
  802612:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802615:	8b 40 08             	mov    0x8(%eax),%eax
  802618:	39 c2                	cmp    %eax,%edx
  80261a:	0f 82 4c 01 00 00    	jb     80276c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802620:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802624:	75 14                	jne    80263a <insert_sorted_allocList+0x157>
  802626:	83 ec 04             	sub    $0x4,%esp
  802629:	68 6c 44 80 00       	push   $0x80446c
  80262e:	6a 73                	push   $0x73
  802630:	68 1b 44 80 00       	push   $0x80441b
  802635:	e8 82 e1 ff ff       	call   8007bc <_panic>
  80263a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802640:	8b 45 08             	mov    0x8(%ebp),%eax
  802643:	89 50 04             	mov    %edx,0x4(%eax)
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
  802649:	8b 40 04             	mov    0x4(%eax),%eax
  80264c:	85 c0                	test   %eax,%eax
  80264e:	74 0c                	je     80265c <insert_sorted_allocList+0x179>
  802650:	a1 44 50 80 00       	mov    0x805044,%eax
  802655:	8b 55 08             	mov    0x8(%ebp),%edx
  802658:	89 10                	mov    %edx,(%eax)
  80265a:	eb 08                	jmp    802664 <insert_sorted_allocList+0x181>
  80265c:	8b 45 08             	mov    0x8(%ebp),%eax
  80265f:	a3 40 50 80 00       	mov    %eax,0x805040
  802664:	8b 45 08             	mov    0x8(%ebp),%eax
  802667:	a3 44 50 80 00       	mov    %eax,0x805044
  80266c:	8b 45 08             	mov    0x8(%ebp),%eax
  80266f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802675:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80267a:	40                   	inc    %eax
  80267b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802680:	e9 e7 00 00 00       	jmp    80276c <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802688:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80268b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802692:	a1 40 50 80 00       	mov    0x805040,%eax
  802697:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269a:	e9 9d 00 00 00       	jmp    80273c <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 00                	mov    (%eax),%eax
  8026a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8026a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026aa:	8b 50 08             	mov    0x8(%eax),%edx
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	8b 40 08             	mov    0x8(%eax),%eax
  8026b3:	39 c2                	cmp    %eax,%edx
  8026b5:	76 7d                	jbe    802734 <insert_sorted_allocList+0x251>
  8026b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ba:	8b 50 08             	mov    0x8(%eax),%edx
  8026bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c0:	8b 40 08             	mov    0x8(%eax),%eax
  8026c3:	39 c2                	cmp    %eax,%edx
  8026c5:	73 6d                	jae    802734 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8026c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cb:	74 06                	je     8026d3 <insert_sorted_allocList+0x1f0>
  8026cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026d1:	75 14                	jne    8026e7 <insert_sorted_allocList+0x204>
  8026d3:	83 ec 04             	sub    $0x4,%esp
  8026d6:	68 90 44 80 00       	push   $0x804490
  8026db:	6a 7f                	push   $0x7f
  8026dd:	68 1b 44 80 00       	push   $0x80441b
  8026e2:	e8 d5 e0 ff ff       	call   8007bc <_panic>
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 10                	mov    (%eax),%edx
  8026ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ef:	89 10                	mov    %edx,(%eax)
  8026f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f4:	8b 00                	mov    (%eax),%eax
  8026f6:	85 c0                	test   %eax,%eax
  8026f8:	74 0b                	je     802705 <insert_sorted_allocList+0x222>
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	8b 00                	mov    (%eax),%eax
  8026ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802702:	89 50 04             	mov    %edx,0x4(%eax)
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 55 08             	mov    0x8(%ebp),%edx
  80270b:	89 10                	mov    %edx,(%eax)
  80270d:	8b 45 08             	mov    0x8(%ebp),%eax
  802710:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802713:	89 50 04             	mov    %edx,0x4(%eax)
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	8b 00                	mov    (%eax),%eax
  80271b:	85 c0                	test   %eax,%eax
  80271d:	75 08                	jne    802727 <insert_sorted_allocList+0x244>
  80271f:	8b 45 08             	mov    0x8(%ebp),%eax
  802722:	a3 44 50 80 00       	mov    %eax,0x805044
  802727:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80272c:	40                   	inc    %eax
  80272d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802732:	eb 39                	jmp    80276d <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802734:	a1 48 50 80 00       	mov    0x805048,%eax
  802739:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802740:	74 07                	je     802749 <insert_sorted_allocList+0x266>
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	eb 05                	jmp    80274e <insert_sorted_allocList+0x26b>
  802749:	b8 00 00 00 00       	mov    $0x0,%eax
  80274e:	a3 48 50 80 00       	mov    %eax,0x805048
  802753:	a1 48 50 80 00       	mov    0x805048,%eax
  802758:	85 c0                	test   %eax,%eax
  80275a:	0f 85 3f ff ff ff    	jne    80269f <insert_sorted_allocList+0x1bc>
  802760:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802764:	0f 85 35 ff ff ff    	jne    80269f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80276a:	eb 01                	jmp    80276d <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80276c:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80276d:	90                   	nop
  80276e:	c9                   	leave  
  80276f:	c3                   	ret    

00802770 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
  802773:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802776:	a1 38 51 80 00       	mov    0x805138,%eax
  80277b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80277e:	e9 85 01 00 00       	jmp    802908 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 40 0c             	mov    0xc(%eax),%eax
  802789:	3b 45 08             	cmp    0x8(%ebp),%eax
  80278c:	0f 82 6e 01 00 00    	jb     802900 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 40 0c             	mov    0xc(%eax),%eax
  802798:	3b 45 08             	cmp    0x8(%ebp),%eax
  80279b:	0f 85 8a 00 00 00    	jne    80282b <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8027a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a5:	75 17                	jne    8027be <alloc_block_FF+0x4e>
  8027a7:	83 ec 04             	sub    $0x4,%esp
  8027aa:	68 c4 44 80 00       	push   $0x8044c4
  8027af:	68 93 00 00 00       	push   $0x93
  8027b4:	68 1b 44 80 00       	push   $0x80441b
  8027b9:	e8 fe df ff ff       	call   8007bc <_panic>
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	8b 00                	mov    (%eax),%eax
  8027c3:	85 c0                	test   %eax,%eax
  8027c5:	74 10                	je     8027d7 <alloc_block_FF+0x67>
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 00                	mov    (%eax),%eax
  8027cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027cf:	8b 52 04             	mov    0x4(%edx),%edx
  8027d2:	89 50 04             	mov    %edx,0x4(%eax)
  8027d5:	eb 0b                	jmp    8027e2 <alloc_block_FF+0x72>
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 40 04             	mov    0x4(%eax),%eax
  8027dd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	8b 40 04             	mov    0x4(%eax),%eax
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	74 0f                	je     8027fb <alloc_block_FF+0x8b>
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 40 04             	mov    0x4(%eax),%eax
  8027f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f5:	8b 12                	mov    (%edx),%edx
  8027f7:	89 10                	mov    %edx,(%eax)
  8027f9:	eb 0a                	jmp    802805 <alloc_block_FF+0x95>
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 00                	mov    (%eax),%eax
  802800:	a3 38 51 80 00       	mov    %eax,0x805138
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802818:	a1 44 51 80 00       	mov    0x805144,%eax
  80281d:	48                   	dec    %eax
  80281e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	e9 10 01 00 00       	jmp    80293b <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 40 0c             	mov    0xc(%eax),%eax
  802831:	3b 45 08             	cmp    0x8(%ebp),%eax
  802834:	0f 86 c6 00 00 00    	jbe    802900 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80283a:	a1 48 51 80 00       	mov    0x805148,%eax
  80283f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 50 08             	mov    0x8(%eax),%edx
  802848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284b:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80284e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802851:	8b 55 08             	mov    0x8(%ebp),%edx
  802854:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802857:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80285b:	75 17                	jne    802874 <alloc_block_FF+0x104>
  80285d:	83 ec 04             	sub    $0x4,%esp
  802860:	68 c4 44 80 00       	push   $0x8044c4
  802865:	68 9b 00 00 00       	push   $0x9b
  80286a:	68 1b 44 80 00       	push   $0x80441b
  80286f:	e8 48 df ff ff       	call   8007bc <_panic>
  802874:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802877:	8b 00                	mov    (%eax),%eax
  802879:	85 c0                	test   %eax,%eax
  80287b:	74 10                	je     80288d <alloc_block_FF+0x11d>
  80287d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802880:	8b 00                	mov    (%eax),%eax
  802882:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802885:	8b 52 04             	mov    0x4(%edx),%edx
  802888:	89 50 04             	mov    %edx,0x4(%eax)
  80288b:	eb 0b                	jmp    802898 <alloc_block_FF+0x128>
  80288d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802890:	8b 40 04             	mov    0x4(%eax),%eax
  802893:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289b:	8b 40 04             	mov    0x4(%eax),%eax
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	74 0f                	je     8028b1 <alloc_block_FF+0x141>
  8028a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a5:	8b 40 04             	mov    0x4(%eax),%eax
  8028a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ab:	8b 12                	mov    (%edx),%edx
  8028ad:	89 10                	mov    %edx,(%eax)
  8028af:	eb 0a                	jmp    8028bb <alloc_block_FF+0x14b>
  8028b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b4:	8b 00                	mov    (%eax),%eax
  8028b6:	a3 48 51 80 00       	mov    %eax,0x805148
  8028bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ce:	a1 54 51 80 00       	mov    0x805154,%eax
  8028d3:	48                   	dec    %eax
  8028d4:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 50 08             	mov    0x8(%eax),%edx
  8028df:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e2:	01 c2                	add    %eax,%edx
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f0:	2b 45 08             	sub    0x8(%ebp),%eax
  8028f3:	89 c2                	mov    %eax,%edx
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8028fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fe:	eb 3b                	jmp    80293b <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802900:	a1 40 51 80 00       	mov    0x805140,%eax
  802905:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802908:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290c:	74 07                	je     802915 <alloc_block_FF+0x1a5>
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 00                	mov    (%eax),%eax
  802913:	eb 05                	jmp    80291a <alloc_block_FF+0x1aa>
  802915:	b8 00 00 00 00       	mov    $0x0,%eax
  80291a:	a3 40 51 80 00       	mov    %eax,0x805140
  80291f:	a1 40 51 80 00       	mov    0x805140,%eax
  802924:	85 c0                	test   %eax,%eax
  802926:	0f 85 57 fe ff ff    	jne    802783 <alloc_block_FF+0x13>
  80292c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802930:	0f 85 4d fe ff ff    	jne    802783 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802936:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80293b:	c9                   	leave  
  80293c:	c3                   	ret    

0080293d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80293d:	55                   	push   %ebp
  80293e:	89 e5                	mov    %esp,%ebp
  802940:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802943:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80294a:	a1 38 51 80 00       	mov    0x805138,%eax
  80294f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802952:	e9 df 00 00 00       	jmp    802a36 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 40 0c             	mov    0xc(%eax),%eax
  80295d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802960:	0f 82 c8 00 00 00    	jb     802a2e <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	8b 40 0c             	mov    0xc(%eax),%eax
  80296c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80296f:	0f 85 8a 00 00 00    	jne    8029ff <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802975:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802979:	75 17                	jne    802992 <alloc_block_BF+0x55>
  80297b:	83 ec 04             	sub    $0x4,%esp
  80297e:	68 c4 44 80 00       	push   $0x8044c4
  802983:	68 b7 00 00 00       	push   $0xb7
  802988:	68 1b 44 80 00       	push   $0x80441b
  80298d:	e8 2a de ff ff       	call   8007bc <_panic>
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 00                	mov    (%eax),%eax
  802997:	85 c0                	test   %eax,%eax
  802999:	74 10                	je     8029ab <alloc_block_BF+0x6e>
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	8b 00                	mov    (%eax),%eax
  8029a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a3:	8b 52 04             	mov    0x4(%edx),%edx
  8029a6:	89 50 04             	mov    %edx,0x4(%eax)
  8029a9:	eb 0b                	jmp    8029b6 <alloc_block_BF+0x79>
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	8b 40 04             	mov    0x4(%eax),%eax
  8029b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	8b 40 04             	mov    0x4(%eax),%eax
  8029bc:	85 c0                	test   %eax,%eax
  8029be:	74 0f                	je     8029cf <alloc_block_BF+0x92>
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 40 04             	mov    0x4(%eax),%eax
  8029c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c9:	8b 12                	mov    (%edx),%edx
  8029cb:	89 10                	mov    %edx,(%eax)
  8029cd:	eb 0a                	jmp    8029d9 <alloc_block_BF+0x9c>
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	8b 00                	mov    (%eax),%eax
  8029d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8029f1:	48                   	dec    %eax
  8029f2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fa:	e9 4d 01 00 00       	jmp    802b4c <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 40 0c             	mov    0xc(%eax),%eax
  802a05:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a08:	76 24                	jbe    802a2e <alloc_block_BF+0xf1>
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a10:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a13:	73 19                	jae    802a2e <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802a15:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 40 08             	mov    0x8(%eax),%eax
  802a2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a2e:	a1 40 51 80 00       	mov    0x805140,%eax
  802a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3a:	74 07                	je     802a43 <alloc_block_BF+0x106>
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 00                	mov    (%eax),%eax
  802a41:	eb 05                	jmp    802a48 <alloc_block_BF+0x10b>
  802a43:	b8 00 00 00 00       	mov    $0x0,%eax
  802a48:	a3 40 51 80 00       	mov    %eax,0x805140
  802a4d:	a1 40 51 80 00       	mov    0x805140,%eax
  802a52:	85 c0                	test   %eax,%eax
  802a54:	0f 85 fd fe ff ff    	jne    802957 <alloc_block_BF+0x1a>
  802a5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5e:	0f 85 f3 fe ff ff    	jne    802957 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802a64:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a68:	0f 84 d9 00 00 00    	je     802b47 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a6e:	a1 48 51 80 00       	mov    0x805148,%eax
  802a73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802a76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a7c:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802a7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a82:	8b 55 08             	mov    0x8(%ebp),%edx
  802a85:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802a88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a8c:	75 17                	jne    802aa5 <alloc_block_BF+0x168>
  802a8e:	83 ec 04             	sub    $0x4,%esp
  802a91:	68 c4 44 80 00       	push   $0x8044c4
  802a96:	68 c7 00 00 00       	push   $0xc7
  802a9b:	68 1b 44 80 00       	push   $0x80441b
  802aa0:	e8 17 dd ff ff       	call   8007bc <_panic>
  802aa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa8:	8b 00                	mov    (%eax),%eax
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	74 10                	je     802abe <alloc_block_BF+0x181>
  802aae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ab1:	8b 00                	mov    (%eax),%eax
  802ab3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ab6:	8b 52 04             	mov    0x4(%edx),%edx
  802ab9:	89 50 04             	mov    %edx,0x4(%eax)
  802abc:	eb 0b                	jmp    802ac9 <alloc_block_BF+0x18c>
  802abe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac1:	8b 40 04             	mov    0x4(%eax),%eax
  802ac4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802acc:	8b 40 04             	mov    0x4(%eax),%eax
  802acf:	85 c0                	test   %eax,%eax
  802ad1:	74 0f                	je     802ae2 <alloc_block_BF+0x1a5>
  802ad3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad6:	8b 40 04             	mov    0x4(%eax),%eax
  802ad9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802adc:	8b 12                	mov    (%edx),%edx
  802ade:	89 10                	mov    %edx,(%eax)
  802ae0:	eb 0a                	jmp    802aec <alloc_block_BF+0x1af>
  802ae2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae5:	8b 00                	mov    (%eax),%eax
  802ae7:	a3 48 51 80 00       	mov    %eax,0x805148
  802aec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aff:	a1 54 51 80 00       	mov    0x805154,%eax
  802b04:	48                   	dec    %eax
  802b05:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802b0a:	83 ec 08             	sub    $0x8,%esp
  802b0d:	ff 75 ec             	pushl  -0x14(%ebp)
  802b10:	68 38 51 80 00       	push   $0x805138
  802b15:	e8 71 f9 ff ff       	call   80248b <find_block>
  802b1a:	83 c4 10             	add    $0x10,%esp
  802b1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802b20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b23:	8b 50 08             	mov    0x8(%eax),%edx
  802b26:	8b 45 08             	mov    0x8(%ebp),%eax
  802b29:	01 c2                	add    %eax,%edx
  802b2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2e:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b34:	8b 40 0c             	mov    0xc(%eax),%eax
  802b37:	2b 45 08             	sub    0x8(%ebp),%eax
  802b3a:	89 c2                	mov    %eax,%edx
  802b3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b3f:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802b42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b45:	eb 05                	jmp    802b4c <alloc_block_BF+0x20f>
	}
	return NULL;
  802b47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b4c:	c9                   	leave  
  802b4d:	c3                   	ret    

00802b4e <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802b4e:	55                   	push   %ebp
  802b4f:	89 e5                	mov    %esp,%ebp
  802b51:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802b54:	a1 28 50 80 00       	mov    0x805028,%eax
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	0f 85 de 01 00 00    	jne    802d3f <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b61:	a1 38 51 80 00       	mov    0x805138,%eax
  802b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b69:	e9 9e 01 00 00       	jmp    802d0c <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 40 0c             	mov    0xc(%eax),%eax
  802b74:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b77:	0f 82 87 01 00 00    	jb     802d04 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	8b 40 0c             	mov    0xc(%eax),%eax
  802b83:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b86:	0f 85 95 00 00 00    	jne    802c21 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802b8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b90:	75 17                	jne    802ba9 <alloc_block_NF+0x5b>
  802b92:	83 ec 04             	sub    $0x4,%esp
  802b95:	68 c4 44 80 00       	push   $0x8044c4
  802b9a:	68 e0 00 00 00       	push   $0xe0
  802b9f:	68 1b 44 80 00       	push   $0x80441b
  802ba4:	e8 13 dc ff ff       	call   8007bc <_panic>
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	8b 00                	mov    (%eax),%eax
  802bae:	85 c0                	test   %eax,%eax
  802bb0:	74 10                	je     802bc2 <alloc_block_NF+0x74>
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	8b 00                	mov    (%eax),%eax
  802bb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bba:	8b 52 04             	mov    0x4(%edx),%edx
  802bbd:	89 50 04             	mov    %edx,0x4(%eax)
  802bc0:	eb 0b                	jmp    802bcd <alloc_block_NF+0x7f>
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 40 04             	mov    0x4(%eax),%eax
  802bc8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd0:	8b 40 04             	mov    0x4(%eax),%eax
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	74 0f                	je     802be6 <alloc_block_NF+0x98>
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 40 04             	mov    0x4(%eax),%eax
  802bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be0:	8b 12                	mov    (%edx),%edx
  802be2:	89 10                	mov    %edx,(%eax)
  802be4:	eb 0a                	jmp    802bf0 <alloc_block_NF+0xa2>
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	a3 38 51 80 00       	mov    %eax,0x805138
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c03:	a1 44 51 80 00       	mov    0x805144,%eax
  802c08:	48                   	dec    %eax
  802c09:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 40 08             	mov    0x8(%eax),%eax
  802c14:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	e9 f8 04 00 00       	jmp    803119 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 40 0c             	mov    0xc(%eax),%eax
  802c27:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c2a:	0f 86 d4 00 00 00    	jbe    802d04 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c30:	a1 48 51 80 00       	mov    0x805148,%eax
  802c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	8b 50 08             	mov    0x8(%eax),%edx
  802c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c41:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c47:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4a:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c51:	75 17                	jne    802c6a <alloc_block_NF+0x11c>
  802c53:	83 ec 04             	sub    $0x4,%esp
  802c56:	68 c4 44 80 00       	push   $0x8044c4
  802c5b:	68 e9 00 00 00       	push   $0xe9
  802c60:	68 1b 44 80 00       	push   $0x80441b
  802c65:	e8 52 db ff ff       	call   8007bc <_panic>
  802c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6d:	8b 00                	mov    (%eax),%eax
  802c6f:	85 c0                	test   %eax,%eax
  802c71:	74 10                	je     802c83 <alloc_block_NF+0x135>
  802c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c76:	8b 00                	mov    (%eax),%eax
  802c78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7b:	8b 52 04             	mov    0x4(%edx),%edx
  802c7e:	89 50 04             	mov    %edx,0x4(%eax)
  802c81:	eb 0b                	jmp    802c8e <alloc_block_NF+0x140>
  802c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c86:	8b 40 04             	mov    0x4(%eax),%eax
  802c89:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c91:	8b 40 04             	mov    0x4(%eax),%eax
  802c94:	85 c0                	test   %eax,%eax
  802c96:	74 0f                	je     802ca7 <alloc_block_NF+0x159>
  802c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9b:	8b 40 04             	mov    0x4(%eax),%eax
  802c9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca1:	8b 12                	mov    (%edx),%edx
  802ca3:	89 10                	mov    %edx,(%eax)
  802ca5:	eb 0a                	jmp    802cb1 <alloc_block_NF+0x163>
  802ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802caa:	8b 00                	mov    (%eax),%eax
  802cac:	a3 48 51 80 00       	mov    %eax,0x805148
  802cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc4:	a1 54 51 80 00       	mov    0x805154,%eax
  802cc9:	48                   	dec    %eax
  802cca:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd2:	8b 40 08             	mov    0x8(%eax),%eax
  802cd5:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 50 08             	mov    0x8(%eax),%edx
  802ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce3:	01 c2                	add    %eax,%edx
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cee:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf1:	2b 45 08             	sub    0x8(%ebp),%eax
  802cf4:	89 c2                	mov    %eax,%edx
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cff:	e9 15 04 00 00       	jmp    803119 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d04:	a1 40 51 80 00       	mov    0x805140,%eax
  802d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d10:	74 07                	je     802d19 <alloc_block_NF+0x1cb>
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 00                	mov    (%eax),%eax
  802d17:	eb 05                	jmp    802d1e <alloc_block_NF+0x1d0>
  802d19:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1e:	a3 40 51 80 00       	mov    %eax,0x805140
  802d23:	a1 40 51 80 00       	mov    0x805140,%eax
  802d28:	85 c0                	test   %eax,%eax
  802d2a:	0f 85 3e fe ff ff    	jne    802b6e <alloc_block_NF+0x20>
  802d30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d34:	0f 85 34 fe ff ff    	jne    802b6e <alloc_block_NF+0x20>
  802d3a:	e9 d5 03 00 00       	jmp    803114 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d3f:	a1 38 51 80 00       	mov    0x805138,%eax
  802d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d47:	e9 b1 01 00 00       	jmp    802efd <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	8b 50 08             	mov    0x8(%eax),%edx
  802d52:	a1 28 50 80 00       	mov    0x805028,%eax
  802d57:	39 c2                	cmp    %eax,%edx
  802d59:	0f 82 96 01 00 00    	jb     802ef5 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 40 0c             	mov    0xc(%eax),%eax
  802d65:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d68:	0f 82 87 01 00 00    	jb     802ef5 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 40 0c             	mov    0xc(%eax),%eax
  802d74:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d77:	0f 85 95 00 00 00    	jne    802e12 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d81:	75 17                	jne    802d9a <alloc_block_NF+0x24c>
  802d83:	83 ec 04             	sub    $0x4,%esp
  802d86:	68 c4 44 80 00       	push   $0x8044c4
  802d8b:	68 fc 00 00 00       	push   $0xfc
  802d90:	68 1b 44 80 00       	push   $0x80441b
  802d95:	e8 22 da ff ff       	call   8007bc <_panic>
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 00                	mov    (%eax),%eax
  802d9f:	85 c0                	test   %eax,%eax
  802da1:	74 10                	je     802db3 <alloc_block_NF+0x265>
  802da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da6:	8b 00                	mov    (%eax),%eax
  802da8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dab:	8b 52 04             	mov    0x4(%edx),%edx
  802dae:	89 50 04             	mov    %edx,0x4(%eax)
  802db1:	eb 0b                	jmp    802dbe <alloc_block_NF+0x270>
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 40 04             	mov    0x4(%eax),%eax
  802db9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 40 04             	mov    0x4(%eax),%eax
  802dc4:	85 c0                	test   %eax,%eax
  802dc6:	74 0f                	je     802dd7 <alloc_block_NF+0x289>
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	8b 40 04             	mov    0x4(%eax),%eax
  802dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd1:	8b 12                	mov    (%edx),%edx
  802dd3:	89 10                	mov    %edx,(%eax)
  802dd5:	eb 0a                	jmp    802de1 <alloc_block_NF+0x293>
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 00                	mov    (%eax),%eax
  802ddc:	a3 38 51 80 00       	mov    %eax,0x805138
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df4:	a1 44 51 80 00       	mov    0x805144,%eax
  802df9:	48                   	dec    %eax
  802dfa:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 40 08             	mov    0x8(%eax),%eax
  802e05:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	e9 07 03 00 00       	jmp    803119 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	8b 40 0c             	mov    0xc(%eax),%eax
  802e18:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e1b:	0f 86 d4 00 00 00    	jbe    802ef5 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e21:	a1 48 51 80 00       	mov    0x805148,%eax
  802e26:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	8b 50 08             	mov    0x8(%eax),%edx
  802e2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e32:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e38:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e3e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e42:	75 17                	jne    802e5b <alloc_block_NF+0x30d>
  802e44:	83 ec 04             	sub    $0x4,%esp
  802e47:	68 c4 44 80 00       	push   $0x8044c4
  802e4c:	68 04 01 00 00       	push   $0x104
  802e51:	68 1b 44 80 00       	push   $0x80441b
  802e56:	e8 61 d9 ff ff       	call   8007bc <_panic>
  802e5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5e:	8b 00                	mov    (%eax),%eax
  802e60:	85 c0                	test   %eax,%eax
  802e62:	74 10                	je     802e74 <alloc_block_NF+0x326>
  802e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e67:	8b 00                	mov    (%eax),%eax
  802e69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e6c:	8b 52 04             	mov    0x4(%edx),%edx
  802e6f:	89 50 04             	mov    %edx,0x4(%eax)
  802e72:	eb 0b                	jmp    802e7f <alloc_block_NF+0x331>
  802e74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e77:	8b 40 04             	mov    0x4(%eax),%eax
  802e7a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e82:	8b 40 04             	mov    0x4(%eax),%eax
  802e85:	85 c0                	test   %eax,%eax
  802e87:	74 0f                	je     802e98 <alloc_block_NF+0x34a>
  802e89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8c:	8b 40 04             	mov    0x4(%eax),%eax
  802e8f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e92:	8b 12                	mov    (%edx),%edx
  802e94:	89 10                	mov    %edx,(%eax)
  802e96:	eb 0a                	jmp    802ea2 <alloc_block_NF+0x354>
  802e98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	a3 48 51 80 00       	mov    %eax,0x805148
  802ea2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb5:	a1 54 51 80 00       	mov    0x805154,%eax
  802eba:	48                   	dec    %eax
  802ebb:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ec0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec3:	8b 40 08             	mov    0x8(%eax),%eax
  802ec6:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	8b 50 08             	mov    0x8(%eax),%edx
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	01 c2                	add    %eax,%edx
  802ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed9:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee2:	2b 45 08             	sub    0x8(%ebp),%eax
  802ee5:	89 c2                	mov    %eax,%edx
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802eed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef0:	e9 24 02 00 00       	jmp    803119 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ef5:	a1 40 51 80 00       	mov    0x805140,%eax
  802efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802efd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f01:	74 07                	je     802f0a <alloc_block_NF+0x3bc>
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	8b 00                	mov    (%eax),%eax
  802f08:	eb 05                	jmp    802f0f <alloc_block_NF+0x3c1>
  802f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0f:	a3 40 51 80 00       	mov    %eax,0x805140
  802f14:	a1 40 51 80 00       	mov    0x805140,%eax
  802f19:	85 c0                	test   %eax,%eax
  802f1b:	0f 85 2b fe ff ff    	jne    802d4c <alloc_block_NF+0x1fe>
  802f21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f25:	0f 85 21 fe ff ff    	jne    802d4c <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f2b:	a1 38 51 80 00       	mov    0x805138,%eax
  802f30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f33:	e9 ae 01 00 00       	jmp    8030e6 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	8b 50 08             	mov    0x8(%eax),%edx
  802f3e:	a1 28 50 80 00       	mov    0x805028,%eax
  802f43:	39 c2                	cmp    %eax,%edx
  802f45:	0f 83 93 01 00 00    	jae    8030de <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f51:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f54:	0f 82 84 01 00 00    	jb     8030de <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f60:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f63:	0f 85 95 00 00 00    	jne    802ffe <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6d:	75 17                	jne    802f86 <alloc_block_NF+0x438>
  802f6f:	83 ec 04             	sub    $0x4,%esp
  802f72:	68 c4 44 80 00       	push   $0x8044c4
  802f77:	68 14 01 00 00       	push   $0x114
  802f7c:	68 1b 44 80 00       	push   $0x80441b
  802f81:	e8 36 d8 ff ff       	call   8007bc <_panic>
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 00                	mov    (%eax),%eax
  802f8b:	85 c0                	test   %eax,%eax
  802f8d:	74 10                	je     802f9f <alloc_block_NF+0x451>
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	8b 00                	mov    (%eax),%eax
  802f94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f97:	8b 52 04             	mov    0x4(%edx),%edx
  802f9a:	89 50 04             	mov    %edx,0x4(%eax)
  802f9d:	eb 0b                	jmp    802faa <alloc_block_NF+0x45c>
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	8b 40 04             	mov    0x4(%eax),%eax
  802fa5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fad:	8b 40 04             	mov    0x4(%eax),%eax
  802fb0:	85 c0                	test   %eax,%eax
  802fb2:	74 0f                	je     802fc3 <alloc_block_NF+0x475>
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	8b 40 04             	mov    0x4(%eax),%eax
  802fba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fbd:	8b 12                	mov    (%edx),%edx
  802fbf:	89 10                	mov    %edx,(%eax)
  802fc1:	eb 0a                	jmp    802fcd <alloc_block_NF+0x47f>
  802fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	a3 38 51 80 00       	mov    %eax,0x805138
  802fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe0:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe5:	48                   	dec    %eax
  802fe6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	8b 40 08             	mov    0x8(%eax),%eax
  802ff1:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	e9 1b 01 00 00       	jmp    803119 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803001:	8b 40 0c             	mov    0xc(%eax),%eax
  803004:	3b 45 08             	cmp    0x8(%ebp),%eax
  803007:	0f 86 d1 00 00 00    	jbe    8030de <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80300d:	a1 48 51 80 00       	mov    0x805148,%eax
  803012:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	8b 50 08             	mov    0x8(%eax),%edx
  80301b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803021:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803024:	8b 55 08             	mov    0x8(%ebp),%edx
  803027:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80302a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80302e:	75 17                	jne    803047 <alloc_block_NF+0x4f9>
  803030:	83 ec 04             	sub    $0x4,%esp
  803033:	68 c4 44 80 00       	push   $0x8044c4
  803038:	68 1c 01 00 00       	push   $0x11c
  80303d:	68 1b 44 80 00       	push   $0x80441b
  803042:	e8 75 d7 ff ff       	call   8007bc <_panic>
  803047:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304a:	8b 00                	mov    (%eax),%eax
  80304c:	85 c0                	test   %eax,%eax
  80304e:	74 10                	je     803060 <alloc_block_NF+0x512>
  803050:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803053:	8b 00                	mov    (%eax),%eax
  803055:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803058:	8b 52 04             	mov    0x4(%edx),%edx
  80305b:	89 50 04             	mov    %edx,0x4(%eax)
  80305e:	eb 0b                	jmp    80306b <alloc_block_NF+0x51d>
  803060:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803063:	8b 40 04             	mov    0x4(%eax),%eax
  803066:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80306b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306e:	8b 40 04             	mov    0x4(%eax),%eax
  803071:	85 c0                	test   %eax,%eax
  803073:	74 0f                	je     803084 <alloc_block_NF+0x536>
  803075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803078:	8b 40 04             	mov    0x4(%eax),%eax
  80307b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80307e:	8b 12                	mov    (%edx),%edx
  803080:	89 10                	mov    %edx,(%eax)
  803082:	eb 0a                	jmp    80308e <alloc_block_NF+0x540>
  803084:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803087:	8b 00                	mov    (%eax),%eax
  803089:	a3 48 51 80 00       	mov    %eax,0x805148
  80308e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803091:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a1:	a1 54 51 80 00       	mov    0x805154,%eax
  8030a6:	48                   	dec    %eax
  8030a7:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8030ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030af:	8b 40 08             	mov    0x8(%eax),%eax
  8030b2:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	8b 50 08             	mov    0x8(%eax),%edx
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	01 c2                	add    %eax,%edx
  8030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8030d1:	89 c2                	mov    %eax,%edx
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8030d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030dc:	eb 3b                	jmp    803119 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030de:	a1 40 51 80 00       	mov    0x805140,%eax
  8030e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ea:	74 07                	je     8030f3 <alloc_block_NF+0x5a5>
  8030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ef:	8b 00                	mov    (%eax),%eax
  8030f1:	eb 05                	jmp    8030f8 <alloc_block_NF+0x5aa>
  8030f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f8:	a3 40 51 80 00       	mov    %eax,0x805140
  8030fd:	a1 40 51 80 00       	mov    0x805140,%eax
  803102:	85 c0                	test   %eax,%eax
  803104:	0f 85 2e fe ff ff    	jne    802f38 <alloc_block_NF+0x3ea>
  80310a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310e:	0f 85 24 fe ff ff    	jne    802f38 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803114:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803119:	c9                   	leave  
  80311a:	c3                   	ret    

0080311b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80311b:	55                   	push   %ebp
  80311c:	89 e5                	mov    %esp,%ebp
  80311e:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803121:	a1 38 51 80 00       	mov    0x805138,%eax
  803126:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803129:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80312e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803131:	a1 38 51 80 00       	mov    0x805138,%eax
  803136:	85 c0                	test   %eax,%eax
  803138:	74 14                	je     80314e <insert_sorted_with_merge_freeList+0x33>
  80313a:	8b 45 08             	mov    0x8(%ebp),%eax
  80313d:	8b 50 08             	mov    0x8(%eax),%edx
  803140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803143:	8b 40 08             	mov    0x8(%eax),%eax
  803146:	39 c2                	cmp    %eax,%edx
  803148:	0f 87 9b 01 00 00    	ja     8032e9 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80314e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803152:	75 17                	jne    80316b <insert_sorted_with_merge_freeList+0x50>
  803154:	83 ec 04             	sub    $0x4,%esp
  803157:	68 f8 43 80 00       	push   $0x8043f8
  80315c:	68 38 01 00 00       	push   $0x138
  803161:	68 1b 44 80 00       	push   $0x80441b
  803166:	e8 51 d6 ff ff       	call   8007bc <_panic>
  80316b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803171:	8b 45 08             	mov    0x8(%ebp),%eax
  803174:	89 10                	mov    %edx,(%eax)
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	8b 00                	mov    (%eax),%eax
  80317b:	85 c0                	test   %eax,%eax
  80317d:	74 0d                	je     80318c <insert_sorted_with_merge_freeList+0x71>
  80317f:	a1 38 51 80 00       	mov    0x805138,%eax
  803184:	8b 55 08             	mov    0x8(%ebp),%edx
  803187:	89 50 04             	mov    %edx,0x4(%eax)
  80318a:	eb 08                	jmp    803194 <insert_sorted_with_merge_freeList+0x79>
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803194:	8b 45 08             	mov    0x8(%ebp),%eax
  803197:	a3 38 51 80 00       	mov    %eax,0x805138
  80319c:	8b 45 08             	mov    0x8(%ebp),%eax
  80319f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a6:	a1 44 51 80 00       	mov    0x805144,%eax
  8031ab:	40                   	inc    %eax
  8031ac:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8031b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031b5:	0f 84 a8 06 00 00    	je     803863 <insert_sorted_with_merge_freeList+0x748>
  8031bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031be:	8b 50 08             	mov    0x8(%eax),%edx
  8031c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c7:	01 c2                	add    %eax,%edx
  8031c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cc:	8b 40 08             	mov    0x8(%eax),%eax
  8031cf:	39 c2                	cmp    %eax,%edx
  8031d1:	0f 85 8c 06 00 00    	jne    803863 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031da:	8b 50 0c             	mov    0xc(%eax),%edx
  8031dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e3:	01 c2                	add    %eax,%edx
  8031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e8:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8031eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031ef:	75 17                	jne    803208 <insert_sorted_with_merge_freeList+0xed>
  8031f1:	83 ec 04             	sub    $0x4,%esp
  8031f4:	68 c4 44 80 00       	push   $0x8044c4
  8031f9:	68 3c 01 00 00       	push   $0x13c
  8031fe:	68 1b 44 80 00       	push   $0x80441b
  803203:	e8 b4 d5 ff ff       	call   8007bc <_panic>
  803208:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320b:	8b 00                	mov    (%eax),%eax
  80320d:	85 c0                	test   %eax,%eax
  80320f:	74 10                	je     803221 <insert_sorted_with_merge_freeList+0x106>
  803211:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803214:	8b 00                	mov    (%eax),%eax
  803216:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803219:	8b 52 04             	mov    0x4(%edx),%edx
  80321c:	89 50 04             	mov    %edx,0x4(%eax)
  80321f:	eb 0b                	jmp    80322c <insert_sorted_with_merge_freeList+0x111>
  803221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803224:	8b 40 04             	mov    0x4(%eax),%eax
  803227:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80322c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322f:	8b 40 04             	mov    0x4(%eax),%eax
  803232:	85 c0                	test   %eax,%eax
  803234:	74 0f                	je     803245 <insert_sorted_with_merge_freeList+0x12a>
  803236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803239:	8b 40 04             	mov    0x4(%eax),%eax
  80323c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80323f:	8b 12                	mov    (%edx),%edx
  803241:	89 10                	mov    %edx,(%eax)
  803243:	eb 0a                	jmp    80324f <insert_sorted_with_merge_freeList+0x134>
  803245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803248:	8b 00                	mov    (%eax),%eax
  80324a:	a3 38 51 80 00       	mov    %eax,0x805138
  80324f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803252:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803262:	a1 44 51 80 00       	mov    0x805144,%eax
  803267:	48                   	dec    %eax
  803268:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80326d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803270:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803281:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803285:	75 17                	jne    80329e <insert_sorted_with_merge_freeList+0x183>
  803287:	83 ec 04             	sub    $0x4,%esp
  80328a:	68 f8 43 80 00       	push   $0x8043f8
  80328f:	68 3f 01 00 00       	push   $0x13f
  803294:	68 1b 44 80 00       	push   $0x80441b
  803299:	e8 1e d5 ff ff       	call   8007bc <_panic>
  80329e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a7:	89 10                	mov    %edx,(%eax)
  8032a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ac:	8b 00                	mov    (%eax),%eax
  8032ae:	85 c0                	test   %eax,%eax
  8032b0:	74 0d                	je     8032bf <insert_sorted_with_merge_freeList+0x1a4>
  8032b2:	a1 48 51 80 00       	mov    0x805148,%eax
  8032b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032ba:	89 50 04             	mov    %edx,0x4(%eax)
  8032bd:	eb 08                	jmp    8032c7 <insert_sorted_with_merge_freeList+0x1ac>
  8032bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ca:	a3 48 51 80 00       	mov    %eax,0x805148
  8032cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d9:	a1 54 51 80 00       	mov    0x805154,%eax
  8032de:	40                   	inc    %eax
  8032df:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032e4:	e9 7a 05 00 00       	jmp    803863 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	8b 50 08             	mov    0x8(%eax),%edx
  8032ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f2:	8b 40 08             	mov    0x8(%eax),%eax
  8032f5:	39 c2                	cmp    %eax,%edx
  8032f7:	0f 82 14 01 00 00    	jb     803411 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8032fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803300:	8b 50 08             	mov    0x8(%eax),%edx
  803303:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803306:	8b 40 0c             	mov    0xc(%eax),%eax
  803309:	01 c2                	add    %eax,%edx
  80330b:	8b 45 08             	mov    0x8(%ebp),%eax
  80330e:	8b 40 08             	mov    0x8(%eax),%eax
  803311:	39 c2                	cmp    %eax,%edx
  803313:	0f 85 90 00 00 00    	jne    8033a9 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803319:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331c:	8b 50 0c             	mov    0xc(%eax),%edx
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	8b 40 0c             	mov    0xc(%eax),%eax
  803325:	01 c2                	add    %eax,%edx
  803327:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332a:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80332d:	8b 45 08             	mov    0x8(%ebp),%eax
  803330:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803341:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803345:	75 17                	jne    80335e <insert_sorted_with_merge_freeList+0x243>
  803347:	83 ec 04             	sub    $0x4,%esp
  80334a:	68 f8 43 80 00       	push   $0x8043f8
  80334f:	68 49 01 00 00       	push   $0x149
  803354:	68 1b 44 80 00       	push   $0x80441b
  803359:	e8 5e d4 ff ff       	call   8007bc <_panic>
  80335e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803364:	8b 45 08             	mov    0x8(%ebp),%eax
  803367:	89 10                	mov    %edx,(%eax)
  803369:	8b 45 08             	mov    0x8(%ebp),%eax
  80336c:	8b 00                	mov    (%eax),%eax
  80336e:	85 c0                	test   %eax,%eax
  803370:	74 0d                	je     80337f <insert_sorted_with_merge_freeList+0x264>
  803372:	a1 48 51 80 00       	mov    0x805148,%eax
  803377:	8b 55 08             	mov    0x8(%ebp),%edx
  80337a:	89 50 04             	mov    %edx,0x4(%eax)
  80337d:	eb 08                	jmp    803387 <insert_sorted_with_merge_freeList+0x26c>
  80337f:	8b 45 08             	mov    0x8(%ebp),%eax
  803382:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803387:	8b 45 08             	mov    0x8(%ebp),%eax
  80338a:	a3 48 51 80 00       	mov    %eax,0x805148
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803399:	a1 54 51 80 00       	mov    0x805154,%eax
  80339e:	40                   	inc    %eax
  80339f:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033a4:	e9 bb 04 00 00       	jmp    803864 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8033a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ad:	75 17                	jne    8033c6 <insert_sorted_with_merge_freeList+0x2ab>
  8033af:	83 ec 04             	sub    $0x4,%esp
  8033b2:	68 6c 44 80 00       	push   $0x80446c
  8033b7:	68 4c 01 00 00       	push   $0x14c
  8033bc:	68 1b 44 80 00       	push   $0x80441b
  8033c1:	e8 f6 d3 ff ff       	call   8007bc <_panic>
  8033c6:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cf:	89 50 04             	mov    %edx,0x4(%eax)
  8033d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d5:	8b 40 04             	mov    0x4(%eax),%eax
  8033d8:	85 c0                	test   %eax,%eax
  8033da:	74 0c                	je     8033e8 <insert_sorted_with_merge_freeList+0x2cd>
  8033dc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e4:	89 10                	mov    %edx,(%eax)
  8033e6:	eb 08                	jmp    8033f0 <insert_sorted_with_merge_freeList+0x2d5>
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	a3 38 51 80 00       	mov    %eax,0x805138
  8033f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803401:	a1 44 51 80 00       	mov    0x805144,%eax
  803406:	40                   	inc    %eax
  803407:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80340c:	e9 53 04 00 00       	jmp    803864 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803411:	a1 38 51 80 00       	mov    0x805138,%eax
  803416:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803419:	e9 15 04 00 00       	jmp    803833 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80341e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803421:	8b 00                	mov    (%eax),%eax
  803423:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	8b 50 08             	mov    0x8(%eax),%edx
  80342c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342f:	8b 40 08             	mov    0x8(%eax),%eax
  803432:	39 c2                	cmp    %eax,%edx
  803434:	0f 86 f1 03 00 00    	jbe    80382b <insert_sorted_with_merge_freeList+0x710>
  80343a:	8b 45 08             	mov    0x8(%ebp),%eax
  80343d:	8b 50 08             	mov    0x8(%eax),%edx
  803440:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803443:	8b 40 08             	mov    0x8(%eax),%eax
  803446:	39 c2                	cmp    %eax,%edx
  803448:	0f 83 dd 03 00 00    	jae    80382b <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803451:	8b 50 08             	mov    0x8(%eax),%edx
  803454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803457:	8b 40 0c             	mov    0xc(%eax),%eax
  80345a:	01 c2                	add    %eax,%edx
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	8b 40 08             	mov    0x8(%eax),%eax
  803462:	39 c2                	cmp    %eax,%edx
  803464:	0f 85 b9 01 00 00    	jne    803623 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80346a:	8b 45 08             	mov    0x8(%ebp),%eax
  80346d:	8b 50 08             	mov    0x8(%eax),%edx
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	8b 40 0c             	mov    0xc(%eax),%eax
  803476:	01 c2                	add    %eax,%edx
  803478:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347b:	8b 40 08             	mov    0x8(%eax),%eax
  80347e:	39 c2                	cmp    %eax,%edx
  803480:	0f 85 0d 01 00 00    	jne    803593 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	8b 50 0c             	mov    0xc(%eax),%edx
  80348c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348f:	8b 40 0c             	mov    0xc(%eax),%eax
  803492:	01 c2                	add    %eax,%edx
  803494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803497:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80349a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80349e:	75 17                	jne    8034b7 <insert_sorted_with_merge_freeList+0x39c>
  8034a0:	83 ec 04             	sub    $0x4,%esp
  8034a3:	68 c4 44 80 00       	push   $0x8044c4
  8034a8:	68 5c 01 00 00       	push   $0x15c
  8034ad:	68 1b 44 80 00       	push   $0x80441b
  8034b2:	e8 05 d3 ff ff       	call   8007bc <_panic>
  8034b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ba:	8b 00                	mov    (%eax),%eax
  8034bc:	85 c0                	test   %eax,%eax
  8034be:	74 10                	je     8034d0 <insert_sorted_with_merge_freeList+0x3b5>
  8034c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c3:	8b 00                	mov    (%eax),%eax
  8034c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034c8:	8b 52 04             	mov    0x4(%edx),%edx
  8034cb:	89 50 04             	mov    %edx,0x4(%eax)
  8034ce:	eb 0b                	jmp    8034db <insert_sorted_with_merge_freeList+0x3c0>
  8034d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d3:	8b 40 04             	mov    0x4(%eax),%eax
  8034d6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034de:	8b 40 04             	mov    0x4(%eax),%eax
  8034e1:	85 c0                	test   %eax,%eax
  8034e3:	74 0f                	je     8034f4 <insert_sorted_with_merge_freeList+0x3d9>
  8034e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e8:	8b 40 04             	mov    0x4(%eax),%eax
  8034eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034ee:	8b 12                	mov    (%edx),%edx
  8034f0:	89 10                	mov    %edx,(%eax)
  8034f2:	eb 0a                	jmp    8034fe <insert_sorted_with_merge_freeList+0x3e3>
  8034f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f7:	8b 00                	mov    (%eax),%eax
  8034f9:	a3 38 51 80 00       	mov    %eax,0x805138
  8034fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803501:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803507:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803511:	a1 44 51 80 00       	mov    0x805144,%eax
  803516:	48                   	dec    %eax
  803517:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80351c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803526:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803529:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803530:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803534:	75 17                	jne    80354d <insert_sorted_with_merge_freeList+0x432>
  803536:	83 ec 04             	sub    $0x4,%esp
  803539:	68 f8 43 80 00       	push   $0x8043f8
  80353e:	68 5f 01 00 00       	push   $0x15f
  803543:	68 1b 44 80 00       	push   $0x80441b
  803548:	e8 6f d2 ff ff       	call   8007bc <_panic>
  80354d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803553:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803556:	89 10                	mov    %edx,(%eax)
  803558:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80355b:	8b 00                	mov    (%eax),%eax
  80355d:	85 c0                	test   %eax,%eax
  80355f:	74 0d                	je     80356e <insert_sorted_with_merge_freeList+0x453>
  803561:	a1 48 51 80 00       	mov    0x805148,%eax
  803566:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803569:	89 50 04             	mov    %edx,0x4(%eax)
  80356c:	eb 08                	jmp    803576 <insert_sorted_with_merge_freeList+0x45b>
  80356e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803571:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803576:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803579:	a3 48 51 80 00       	mov    %eax,0x805148
  80357e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803581:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803588:	a1 54 51 80 00       	mov    0x805154,%eax
  80358d:	40                   	inc    %eax
  80358e:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803596:	8b 50 0c             	mov    0xc(%eax),%edx
  803599:	8b 45 08             	mov    0x8(%ebp),%eax
  80359c:	8b 40 0c             	mov    0xc(%eax),%eax
  80359f:	01 c2                	add    %eax,%edx
  8035a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a4:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8035a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8035bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035bf:	75 17                	jne    8035d8 <insert_sorted_with_merge_freeList+0x4bd>
  8035c1:	83 ec 04             	sub    $0x4,%esp
  8035c4:	68 f8 43 80 00       	push   $0x8043f8
  8035c9:	68 64 01 00 00       	push   $0x164
  8035ce:	68 1b 44 80 00       	push   $0x80441b
  8035d3:	e8 e4 d1 ff ff       	call   8007bc <_panic>
  8035d8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035de:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e1:	89 10                	mov    %edx,(%eax)
  8035e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e6:	8b 00                	mov    (%eax),%eax
  8035e8:	85 c0                	test   %eax,%eax
  8035ea:	74 0d                	je     8035f9 <insert_sorted_with_merge_freeList+0x4de>
  8035ec:	a1 48 51 80 00       	mov    0x805148,%eax
  8035f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8035f4:	89 50 04             	mov    %edx,0x4(%eax)
  8035f7:	eb 08                	jmp    803601 <insert_sorted_with_merge_freeList+0x4e6>
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803601:	8b 45 08             	mov    0x8(%ebp),%eax
  803604:	a3 48 51 80 00       	mov    %eax,0x805148
  803609:	8b 45 08             	mov    0x8(%ebp),%eax
  80360c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803613:	a1 54 51 80 00       	mov    0x805154,%eax
  803618:	40                   	inc    %eax
  803619:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80361e:	e9 41 02 00 00       	jmp    803864 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803623:	8b 45 08             	mov    0x8(%ebp),%eax
  803626:	8b 50 08             	mov    0x8(%eax),%edx
  803629:	8b 45 08             	mov    0x8(%ebp),%eax
  80362c:	8b 40 0c             	mov    0xc(%eax),%eax
  80362f:	01 c2                	add    %eax,%edx
  803631:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803634:	8b 40 08             	mov    0x8(%eax),%eax
  803637:	39 c2                	cmp    %eax,%edx
  803639:	0f 85 7c 01 00 00    	jne    8037bb <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80363f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803643:	74 06                	je     80364b <insert_sorted_with_merge_freeList+0x530>
  803645:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803649:	75 17                	jne    803662 <insert_sorted_with_merge_freeList+0x547>
  80364b:	83 ec 04             	sub    $0x4,%esp
  80364e:	68 34 44 80 00       	push   $0x804434
  803653:	68 69 01 00 00       	push   $0x169
  803658:	68 1b 44 80 00       	push   $0x80441b
  80365d:	e8 5a d1 ff ff       	call   8007bc <_panic>
  803662:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803665:	8b 50 04             	mov    0x4(%eax),%edx
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	89 50 04             	mov    %edx,0x4(%eax)
  80366e:	8b 45 08             	mov    0x8(%ebp),%eax
  803671:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803674:	89 10                	mov    %edx,(%eax)
  803676:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803679:	8b 40 04             	mov    0x4(%eax),%eax
  80367c:	85 c0                	test   %eax,%eax
  80367e:	74 0d                	je     80368d <insert_sorted_with_merge_freeList+0x572>
  803680:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803683:	8b 40 04             	mov    0x4(%eax),%eax
  803686:	8b 55 08             	mov    0x8(%ebp),%edx
  803689:	89 10                	mov    %edx,(%eax)
  80368b:	eb 08                	jmp    803695 <insert_sorted_with_merge_freeList+0x57a>
  80368d:	8b 45 08             	mov    0x8(%ebp),%eax
  803690:	a3 38 51 80 00       	mov    %eax,0x805138
  803695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803698:	8b 55 08             	mov    0x8(%ebp),%edx
  80369b:	89 50 04             	mov    %edx,0x4(%eax)
  80369e:	a1 44 51 80 00       	mov    0x805144,%eax
  8036a3:	40                   	inc    %eax
  8036a4:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8036a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ac:	8b 50 0c             	mov    0xc(%eax),%edx
  8036af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8036b5:	01 c2                	add    %eax,%edx
  8036b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ba:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8036bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036c1:	75 17                	jne    8036da <insert_sorted_with_merge_freeList+0x5bf>
  8036c3:	83 ec 04             	sub    $0x4,%esp
  8036c6:	68 c4 44 80 00       	push   $0x8044c4
  8036cb:	68 6b 01 00 00       	push   $0x16b
  8036d0:	68 1b 44 80 00       	push   $0x80441b
  8036d5:	e8 e2 d0 ff ff       	call   8007bc <_panic>
  8036da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036dd:	8b 00                	mov    (%eax),%eax
  8036df:	85 c0                	test   %eax,%eax
  8036e1:	74 10                	je     8036f3 <insert_sorted_with_merge_freeList+0x5d8>
  8036e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e6:	8b 00                	mov    (%eax),%eax
  8036e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036eb:	8b 52 04             	mov    0x4(%edx),%edx
  8036ee:	89 50 04             	mov    %edx,0x4(%eax)
  8036f1:	eb 0b                	jmp    8036fe <insert_sorted_with_merge_freeList+0x5e3>
  8036f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f6:	8b 40 04             	mov    0x4(%eax),%eax
  8036f9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803701:	8b 40 04             	mov    0x4(%eax),%eax
  803704:	85 c0                	test   %eax,%eax
  803706:	74 0f                	je     803717 <insert_sorted_with_merge_freeList+0x5fc>
  803708:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370b:	8b 40 04             	mov    0x4(%eax),%eax
  80370e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803711:	8b 12                	mov    (%edx),%edx
  803713:	89 10                	mov    %edx,(%eax)
  803715:	eb 0a                	jmp    803721 <insert_sorted_with_merge_freeList+0x606>
  803717:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80371a:	8b 00                	mov    (%eax),%eax
  80371c:	a3 38 51 80 00       	mov    %eax,0x805138
  803721:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803724:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80372a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803734:	a1 44 51 80 00       	mov    0x805144,%eax
  803739:	48                   	dec    %eax
  80373a:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80373f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803742:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803749:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803753:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803757:	75 17                	jne    803770 <insert_sorted_with_merge_freeList+0x655>
  803759:	83 ec 04             	sub    $0x4,%esp
  80375c:	68 f8 43 80 00       	push   $0x8043f8
  803761:	68 6e 01 00 00       	push   $0x16e
  803766:	68 1b 44 80 00       	push   $0x80441b
  80376b:	e8 4c d0 ff ff       	call   8007bc <_panic>
  803770:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803776:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803779:	89 10                	mov    %edx,(%eax)
  80377b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80377e:	8b 00                	mov    (%eax),%eax
  803780:	85 c0                	test   %eax,%eax
  803782:	74 0d                	je     803791 <insert_sorted_with_merge_freeList+0x676>
  803784:	a1 48 51 80 00       	mov    0x805148,%eax
  803789:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80378c:	89 50 04             	mov    %edx,0x4(%eax)
  80378f:	eb 08                	jmp    803799 <insert_sorted_with_merge_freeList+0x67e>
  803791:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803794:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803799:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379c:	a3 48 51 80 00       	mov    %eax,0x805148
  8037a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8037b0:	40                   	inc    %eax
  8037b1:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8037b6:	e9 a9 00 00 00       	jmp    803864 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8037bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037bf:	74 06                	je     8037c7 <insert_sorted_with_merge_freeList+0x6ac>
  8037c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037c5:	75 17                	jne    8037de <insert_sorted_with_merge_freeList+0x6c3>
  8037c7:	83 ec 04             	sub    $0x4,%esp
  8037ca:	68 90 44 80 00       	push   $0x804490
  8037cf:	68 73 01 00 00       	push   $0x173
  8037d4:	68 1b 44 80 00       	push   $0x80441b
  8037d9:	e8 de cf ff ff       	call   8007bc <_panic>
  8037de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e1:	8b 10                	mov    (%eax),%edx
  8037e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e6:	89 10                	mov    %edx,(%eax)
  8037e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037eb:	8b 00                	mov    (%eax),%eax
  8037ed:	85 c0                	test   %eax,%eax
  8037ef:	74 0b                	je     8037fc <insert_sorted_with_merge_freeList+0x6e1>
  8037f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f4:	8b 00                	mov    (%eax),%eax
  8037f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8037f9:	89 50 04             	mov    %edx,0x4(%eax)
  8037fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803802:	89 10                	mov    %edx,(%eax)
  803804:	8b 45 08             	mov    0x8(%ebp),%eax
  803807:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80380a:	89 50 04             	mov    %edx,0x4(%eax)
  80380d:	8b 45 08             	mov    0x8(%ebp),%eax
  803810:	8b 00                	mov    (%eax),%eax
  803812:	85 c0                	test   %eax,%eax
  803814:	75 08                	jne    80381e <insert_sorted_with_merge_freeList+0x703>
  803816:	8b 45 08             	mov    0x8(%ebp),%eax
  803819:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80381e:	a1 44 51 80 00       	mov    0x805144,%eax
  803823:	40                   	inc    %eax
  803824:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803829:	eb 39                	jmp    803864 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80382b:	a1 40 51 80 00       	mov    0x805140,%eax
  803830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803833:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803837:	74 07                	je     803840 <insert_sorted_with_merge_freeList+0x725>
  803839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383c:	8b 00                	mov    (%eax),%eax
  80383e:	eb 05                	jmp    803845 <insert_sorted_with_merge_freeList+0x72a>
  803840:	b8 00 00 00 00       	mov    $0x0,%eax
  803845:	a3 40 51 80 00       	mov    %eax,0x805140
  80384a:	a1 40 51 80 00       	mov    0x805140,%eax
  80384f:	85 c0                	test   %eax,%eax
  803851:	0f 85 c7 fb ff ff    	jne    80341e <insert_sorted_with_merge_freeList+0x303>
  803857:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80385b:	0f 85 bd fb ff ff    	jne    80341e <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803861:	eb 01                	jmp    803864 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803863:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803864:	90                   	nop
  803865:	c9                   	leave  
  803866:	c3                   	ret    
  803867:	90                   	nop

00803868 <__udivdi3>:
  803868:	55                   	push   %ebp
  803869:	57                   	push   %edi
  80386a:	56                   	push   %esi
  80386b:	53                   	push   %ebx
  80386c:	83 ec 1c             	sub    $0x1c,%esp
  80386f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803873:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803877:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80387b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80387f:	89 ca                	mov    %ecx,%edx
  803881:	89 f8                	mov    %edi,%eax
  803883:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803887:	85 f6                	test   %esi,%esi
  803889:	75 2d                	jne    8038b8 <__udivdi3+0x50>
  80388b:	39 cf                	cmp    %ecx,%edi
  80388d:	77 65                	ja     8038f4 <__udivdi3+0x8c>
  80388f:	89 fd                	mov    %edi,%ebp
  803891:	85 ff                	test   %edi,%edi
  803893:	75 0b                	jne    8038a0 <__udivdi3+0x38>
  803895:	b8 01 00 00 00       	mov    $0x1,%eax
  80389a:	31 d2                	xor    %edx,%edx
  80389c:	f7 f7                	div    %edi
  80389e:	89 c5                	mov    %eax,%ebp
  8038a0:	31 d2                	xor    %edx,%edx
  8038a2:	89 c8                	mov    %ecx,%eax
  8038a4:	f7 f5                	div    %ebp
  8038a6:	89 c1                	mov    %eax,%ecx
  8038a8:	89 d8                	mov    %ebx,%eax
  8038aa:	f7 f5                	div    %ebp
  8038ac:	89 cf                	mov    %ecx,%edi
  8038ae:	89 fa                	mov    %edi,%edx
  8038b0:	83 c4 1c             	add    $0x1c,%esp
  8038b3:	5b                   	pop    %ebx
  8038b4:	5e                   	pop    %esi
  8038b5:	5f                   	pop    %edi
  8038b6:	5d                   	pop    %ebp
  8038b7:	c3                   	ret    
  8038b8:	39 ce                	cmp    %ecx,%esi
  8038ba:	77 28                	ja     8038e4 <__udivdi3+0x7c>
  8038bc:	0f bd fe             	bsr    %esi,%edi
  8038bf:	83 f7 1f             	xor    $0x1f,%edi
  8038c2:	75 40                	jne    803904 <__udivdi3+0x9c>
  8038c4:	39 ce                	cmp    %ecx,%esi
  8038c6:	72 0a                	jb     8038d2 <__udivdi3+0x6a>
  8038c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038cc:	0f 87 9e 00 00 00    	ja     803970 <__udivdi3+0x108>
  8038d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038d7:	89 fa                	mov    %edi,%edx
  8038d9:	83 c4 1c             	add    $0x1c,%esp
  8038dc:	5b                   	pop    %ebx
  8038dd:	5e                   	pop    %esi
  8038de:	5f                   	pop    %edi
  8038df:	5d                   	pop    %ebp
  8038e0:	c3                   	ret    
  8038e1:	8d 76 00             	lea    0x0(%esi),%esi
  8038e4:	31 ff                	xor    %edi,%edi
  8038e6:	31 c0                	xor    %eax,%eax
  8038e8:	89 fa                	mov    %edi,%edx
  8038ea:	83 c4 1c             	add    $0x1c,%esp
  8038ed:	5b                   	pop    %ebx
  8038ee:	5e                   	pop    %esi
  8038ef:	5f                   	pop    %edi
  8038f0:	5d                   	pop    %ebp
  8038f1:	c3                   	ret    
  8038f2:	66 90                	xchg   %ax,%ax
  8038f4:	89 d8                	mov    %ebx,%eax
  8038f6:	f7 f7                	div    %edi
  8038f8:	31 ff                	xor    %edi,%edi
  8038fa:	89 fa                	mov    %edi,%edx
  8038fc:	83 c4 1c             	add    $0x1c,%esp
  8038ff:	5b                   	pop    %ebx
  803900:	5e                   	pop    %esi
  803901:	5f                   	pop    %edi
  803902:	5d                   	pop    %ebp
  803903:	c3                   	ret    
  803904:	bd 20 00 00 00       	mov    $0x20,%ebp
  803909:	89 eb                	mov    %ebp,%ebx
  80390b:	29 fb                	sub    %edi,%ebx
  80390d:	89 f9                	mov    %edi,%ecx
  80390f:	d3 e6                	shl    %cl,%esi
  803911:	89 c5                	mov    %eax,%ebp
  803913:	88 d9                	mov    %bl,%cl
  803915:	d3 ed                	shr    %cl,%ebp
  803917:	89 e9                	mov    %ebp,%ecx
  803919:	09 f1                	or     %esi,%ecx
  80391b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80391f:	89 f9                	mov    %edi,%ecx
  803921:	d3 e0                	shl    %cl,%eax
  803923:	89 c5                	mov    %eax,%ebp
  803925:	89 d6                	mov    %edx,%esi
  803927:	88 d9                	mov    %bl,%cl
  803929:	d3 ee                	shr    %cl,%esi
  80392b:	89 f9                	mov    %edi,%ecx
  80392d:	d3 e2                	shl    %cl,%edx
  80392f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803933:	88 d9                	mov    %bl,%cl
  803935:	d3 e8                	shr    %cl,%eax
  803937:	09 c2                	or     %eax,%edx
  803939:	89 d0                	mov    %edx,%eax
  80393b:	89 f2                	mov    %esi,%edx
  80393d:	f7 74 24 0c          	divl   0xc(%esp)
  803941:	89 d6                	mov    %edx,%esi
  803943:	89 c3                	mov    %eax,%ebx
  803945:	f7 e5                	mul    %ebp
  803947:	39 d6                	cmp    %edx,%esi
  803949:	72 19                	jb     803964 <__udivdi3+0xfc>
  80394b:	74 0b                	je     803958 <__udivdi3+0xf0>
  80394d:	89 d8                	mov    %ebx,%eax
  80394f:	31 ff                	xor    %edi,%edi
  803951:	e9 58 ff ff ff       	jmp    8038ae <__udivdi3+0x46>
  803956:	66 90                	xchg   %ax,%ax
  803958:	8b 54 24 08          	mov    0x8(%esp),%edx
  80395c:	89 f9                	mov    %edi,%ecx
  80395e:	d3 e2                	shl    %cl,%edx
  803960:	39 c2                	cmp    %eax,%edx
  803962:	73 e9                	jae    80394d <__udivdi3+0xe5>
  803964:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803967:	31 ff                	xor    %edi,%edi
  803969:	e9 40 ff ff ff       	jmp    8038ae <__udivdi3+0x46>
  80396e:	66 90                	xchg   %ax,%ax
  803970:	31 c0                	xor    %eax,%eax
  803972:	e9 37 ff ff ff       	jmp    8038ae <__udivdi3+0x46>
  803977:	90                   	nop

00803978 <__umoddi3>:
  803978:	55                   	push   %ebp
  803979:	57                   	push   %edi
  80397a:	56                   	push   %esi
  80397b:	53                   	push   %ebx
  80397c:	83 ec 1c             	sub    $0x1c,%esp
  80397f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803983:	8b 74 24 34          	mov    0x34(%esp),%esi
  803987:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80398b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80398f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803993:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803997:	89 f3                	mov    %esi,%ebx
  803999:	89 fa                	mov    %edi,%edx
  80399b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80399f:	89 34 24             	mov    %esi,(%esp)
  8039a2:	85 c0                	test   %eax,%eax
  8039a4:	75 1a                	jne    8039c0 <__umoddi3+0x48>
  8039a6:	39 f7                	cmp    %esi,%edi
  8039a8:	0f 86 a2 00 00 00    	jbe    803a50 <__umoddi3+0xd8>
  8039ae:	89 c8                	mov    %ecx,%eax
  8039b0:	89 f2                	mov    %esi,%edx
  8039b2:	f7 f7                	div    %edi
  8039b4:	89 d0                	mov    %edx,%eax
  8039b6:	31 d2                	xor    %edx,%edx
  8039b8:	83 c4 1c             	add    $0x1c,%esp
  8039bb:	5b                   	pop    %ebx
  8039bc:	5e                   	pop    %esi
  8039bd:	5f                   	pop    %edi
  8039be:	5d                   	pop    %ebp
  8039bf:	c3                   	ret    
  8039c0:	39 f0                	cmp    %esi,%eax
  8039c2:	0f 87 ac 00 00 00    	ja     803a74 <__umoddi3+0xfc>
  8039c8:	0f bd e8             	bsr    %eax,%ebp
  8039cb:	83 f5 1f             	xor    $0x1f,%ebp
  8039ce:	0f 84 ac 00 00 00    	je     803a80 <__umoddi3+0x108>
  8039d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8039d9:	29 ef                	sub    %ebp,%edi
  8039db:	89 fe                	mov    %edi,%esi
  8039dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039e1:	89 e9                	mov    %ebp,%ecx
  8039e3:	d3 e0                	shl    %cl,%eax
  8039e5:	89 d7                	mov    %edx,%edi
  8039e7:	89 f1                	mov    %esi,%ecx
  8039e9:	d3 ef                	shr    %cl,%edi
  8039eb:	09 c7                	or     %eax,%edi
  8039ed:	89 e9                	mov    %ebp,%ecx
  8039ef:	d3 e2                	shl    %cl,%edx
  8039f1:	89 14 24             	mov    %edx,(%esp)
  8039f4:	89 d8                	mov    %ebx,%eax
  8039f6:	d3 e0                	shl    %cl,%eax
  8039f8:	89 c2                	mov    %eax,%edx
  8039fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039fe:	d3 e0                	shl    %cl,%eax
  803a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a04:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a08:	89 f1                	mov    %esi,%ecx
  803a0a:	d3 e8                	shr    %cl,%eax
  803a0c:	09 d0                	or     %edx,%eax
  803a0e:	d3 eb                	shr    %cl,%ebx
  803a10:	89 da                	mov    %ebx,%edx
  803a12:	f7 f7                	div    %edi
  803a14:	89 d3                	mov    %edx,%ebx
  803a16:	f7 24 24             	mull   (%esp)
  803a19:	89 c6                	mov    %eax,%esi
  803a1b:	89 d1                	mov    %edx,%ecx
  803a1d:	39 d3                	cmp    %edx,%ebx
  803a1f:	0f 82 87 00 00 00    	jb     803aac <__umoddi3+0x134>
  803a25:	0f 84 91 00 00 00    	je     803abc <__umoddi3+0x144>
  803a2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a2f:	29 f2                	sub    %esi,%edx
  803a31:	19 cb                	sbb    %ecx,%ebx
  803a33:	89 d8                	mov    %ebx,%eax
  803a35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a39:	d3 e0                	shl    %cl,%eax
  803a3b:	89 e9                	mov    %ebp,%ecx
  803a3d:	d3 ea                	shr    %cl,%edx
  803a3f:	09 d0                	or     %edx,%eax
  803a41:	89 e9                	mov    %ebp,%ecx
  803a43:	d3 eb                	shr    %cl,%ebx
  803a45:	89 da                	mov    %ebx,%edx
  803a47:	83 c4 1c             	add    $0x1c,%esp
  803a4a:	5b                   	pop    %ebx
  803a4b:	5e                   	pop    %esi
  803a4c:	5f                   	pop    %edi
  803a4d:	5d                   	pop    %ebp
  803a4e:	c3                   	ret    
  803a4f:	90                   	nop
  803a50:	89 fd                	mov    %edi,%ebp
  803a52:	85 ff                	test   %edi,%edi
  803a54:	75 0b                	jne    803a61 <__umoddi3+0xe9>
  803a56:	b8 01 00 00 00       	mov    $0x1,%eax
  803a5b:	31 d2                	xor    %edx,%edx
  803a5d:	f7 f7                	div    %edi
  803a5f:	89 c5                	mov    %eax,%ebp
  803a61:	89 f0                	mov    %esi,%eax
  803a63:	31 d2                	xor    %edx,%edx
  803a65:	f7 f5                	div    %ebp
  803a67:	89 c8                	mov    %ecx,%eax
  803a69:	f7 f5                	div    %ebp
  803a6b:	89 d0                	mov    %edx,%eax
  803a6d:	e9 44 ff ff ff       	jmp    8039b6 <__umoddi3+0x3e>
  803a72:	66 90                	xchg   %ax,%ax
  803a74:	89 c8                	mov    %ecx,%eax
  803a76:	89 f2                	mov    %esi,%edx
  803a78:	83 c4 1c             	add    $0x1c,%esp
  803a7b:	5b                   	pop    %ebx
  803a7c:	5e                   	pop    %esi
  803a7d:	5f                   	pop    %edi
  803a7e:	5d                   	pop    %ebp
  803a7f:	c3                   	ret    
  803a80:	3b 04 24             	cmp    (%esp),%eax
  803a83:	72 06                	jb     803a8b <__umoddi3+0x113>
  803a85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a89:	77 0f                	ja     803a9a <__umoddi3+0x122>
  803a8b:	89 f2                	mov    %esi,%edx
  803a8d:	29 f9                	sub    %edi,%ecx
  803a8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a93:	89 14 24             	mov    %edx,(%esp)
  803a96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a9e:	8b 14 24             	mov    (%esp),%edx
  803aa1:	83 c4 1c             	add    $0x1c,%esp
  803aa4:	5b                   	pop    %ebx
  803aa5:	5e                   	pop    %esi
  803aa6:	5f                   	pop    %edi
  803aa7:	5d                   	pop    %ebp
  803aa8:	c3                   	ret    
  803aa9:	8d 76 00             	lea    0x0(%esi),%esi
  803aac:	2b 04 24             	sub    (%esp),%eax
  803aaf:	19 fa                	sbb    %edi,%edx
  803ab1:	89 d1                	mov    %edx,%ecx
  803ab3:	89 c6                	mov    %eax,%esi
  803ab5:	e9 71 ff ff ff       	jmp    803a2b <__umoddi3+0xb3>
  803aba:	66 90                	xchg   %ax,%ax
  803abc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ac0:	72 ea                	jb     803aac <__umoddi3+0x134>
  803ac2:	89 d9                	mov    %ebx,%ecx
  803ac4:	e9 62 ff ff ff       	jmp    803a2b <__umoddi3+0xb3>
