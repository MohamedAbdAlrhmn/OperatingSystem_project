
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
  800045:	e8 2a 22 00 00       	call   802274 <sys_set_uheap_strategy>
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
  80009b:	68 a0 3b 80 00       	push   $0x803ba0
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 bc 3b 80 00       	push   $0x803bbc
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
  8000f5:	68 d4 3b 80 00       	push   $0x803bd4
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 bc 3b 80 00       	push   $0x803bbc
  800101:	e8 b6 06 00 00       	call   8007bc <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 54 1c 00 00       	call   801d5f <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 ec 1c 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
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
  80013a:	68 18 3c 80 00       	push   $0x803c18
  80013f:	6a 31                	push   $0x31
  800141:	68 bc 3b 80 00       	push   $0x803bbc
  800146:	e8 71 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014b:	e8 af 1c 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  800150:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 48 3c 80 00       	push   $0x803c48
  80015d:	6a 33                	push   $0x33
  80015f:	68 bc 3b 80 00       	push   $0x803bbc
  800164:	e8 53 06 00 00       	call   8007bc <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 f1 1b 00 00       	call   801d5f <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 89 1c 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
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
  8001a6:	68 18 3c 80 00       	push   $0x803c18
  8001ab:	6a 39                	push   $0x39
  8001ad:	68 bc 3b 80 00       	push   $0x803bbc
  8001b2:	e8 05 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b7:	e8 43 1c 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  8001bc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 48 3c 80 00       	push   $0x803c48
  8001c9:	6a 3b                	push   $0x3b
  8001cb:	68 bc 3b 80 00       	push   $0x803bbc
  8001d0:	e8 e7 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001d5:	e8 85 1b 00 00       	call   801d5f <sys_calculate_free_frames>
  8001da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001dd:	e8 1d 1c 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
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
  800214:	68 18 3c 80 00       	push   $0x803c18
  800219:	6a 41                	push   $0x41
  80021b:	68 bc 3b 80 00       	push   $0x803bbc
  800220:	e8 97 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800225:	e8 d5 1b 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  80022a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 48 3c 80 00       	push   $0x803c48
  800237:	6a 43                	push   $0x43
  800239:	68 bc 3b 80 00       	push   $0x803bbc
  80023e:	e8 79 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  800243:	e8 17 1b 00 00       	call   801d5f <sys_calculate_free_frames>
  800248:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80024b:	e8 af 1b 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
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
  80028c:	68 18 3c 80 00       	push   $0x803c18
  800291:	6a 49                	push   $0x49
  800293:	68 bc 3b 80 00       	push   $0x803bbc
  800298:	e8 1f 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80029d:	e8 5d 1b 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  8002a2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a5:	74 14                	je     8002bb <_main+0x283>
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	68 48 3c 80 00       	push   $0x803c48
  8002af:	6a 4b                	push   $0x4b
  8002b1:	68 bc 3b 80 00       	push   $0x803bbc
  8002b6:	e8 01 05 00 00       	call   8007bc <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002bb:	e8 9f 1a 00 00       	call   801d5f <sys_calculate_free_frames>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c3:	e8 37 1b 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  8002c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002cb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	50                   	push   %eax
  8002d2:	e8 9c 17 00 00       	call   801a73 <free>
  8002d7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8002da:	e8 20 1b 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  8002df:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002e2:	74 14                	je     8002f8 <_main+0x2c0>
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	68 65 3c 80 00       	push   $0x803c65
  8002ec:	6a 52                	push   $0x52
  8002ee:	68 bc 3b 80 00       	push   $0x803bbc
  8002f3:	e8 c4 04 00 00       	call   8007bc <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002f8:	e8 62 1a 00 00       	call   801d5f <sys_calculate_free_frames>
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800300:	e8 fa 1a 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
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
  800345:	68 18 3c 80 00       	push   $0x803c18
  80034a:	6a 58                	push   $0x58
  80034c:	68 bc 3b 80 00       	push   $0x803bbc
  800351:	e8 66 04 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800356:	e8 a4 1a 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  80035b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80035e:	74 14                	je     800374 <_main+0x33c>
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	68 48 3c 80 00       	push   $0x803c48
  800368:	6a 5a                	push   $0x5a
  80036a:	68 bc 3b 80 00       	push   $0x803bbc
  80036f:	e8 48 04 00 00       	call   8007bc <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800374:	e8 e6 19 00 00       	call   801d5f <sys_calculate_free_frames>
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037c:	e8 7e 1a 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800384:	8b 45 90             	mov    -0x70(%ebp),%eax
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	50                   	push   %eax
  80038b:	e8 e3 16 00 00       	call   801a73 <free>
  800390:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  800393:	e8 67 1a 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  800398:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80039b:	74 14                	je     8003b1 <_main+0x379>
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 65 3c 80 00       	push   $0x803c65
  8003a5:	6a 61                	push   $0x61
  8003a7:	68 bc 3b 80 00       	push   $0x803bbc
  8003ac:	e8 0b 04 00 00       	call   8007bc <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003b1:	e8 a9 19 00 00       	call   801d5f <sys_calculate_free_frames>
  8003b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003b9:	e8 41 1a 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
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
  8003fd:	68 18 3c 80 00       	push   $0x803c18
  800402:	6a 67                	push   $0x67
  800404:	68 bc 3b 80 00       	push   $0x803bbc
  800409:	e8 ae 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80040e:	e8 ec 19 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  800413:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800416:	74 14                	je     80042c <_main+0x3f4>
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	68 48 3c 80 00       	push   $0x803c48
  800420:	6a 69                	push   $0x69
  800422:	68 bc 3b 80 00       	push   $0x803bbc
  800427:	e8 90 03 00 00       	call   8007bc <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  80042c:	e8 2e 19 00 00       	call   801d5f <sys_calculate_free_frames>
  800431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800434:	e8 c6 19 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
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
  800483:	68 18 3c 80 00       	push   $0x803c18
  800488:	6a 6f                	push   $0x6f
  80048a:	68 bc 3b 80 00       	push   $0x803bbc
  80048f:	e8 28 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800494:	e8 66 19 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  800499:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80049c:	74 14                	je     8004b2 <_main+0x47a>
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	68 48 3c 80 00       	push   $0x803c48
  8004a6:	6a 71                	push   $0x71
  8004a8:	68 bc 3b 80 00       	push   $0x803bbc
  8004ad:	e8 0a 03 00 00       	call   8007bc <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004b2:	e8 a8 18 00 00       	call   801d5f <sys_calculate_free_frames>
  8004b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004ba:	e8 40 19 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  8004bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  8004c2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	50                   	push   %eax
  8004c9:	e8 a5 15 00 00       	call   801a73 <free>
  8004ce:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8004d1:	e8 29 19 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  8004d6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d9:	74 14                	je     8004ef <_main+0x4b7>
  8004db:	83 ec 04             	sub    $0x4,%esp
  8004de:	68 65 3c 80 00       	push   $0x803c65
  8004e3:	6a 78                	push   $0x78
  8004e5:	68 bc 3b 80 00       	push   $0x803bbc
  8004ea:	e8 cd 02 00 00       	call   8007bc <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 6b 18 00 00       	call   801d5f <sys_calculate_free_frames>
  8004f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 03 19 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8004ff:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	50                   	push   %eax
  800506:	e8 68 15 00 00       	call   801a73 <free>
  80050b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  80050e:	e8 ec 18 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  800513:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 65 3c 80 00       	push   $0x803c65
  800520:	6a 7f                	push   $0x7f
  800522:	68 bc 3b 80 00       	push   $0x803bbc
  800527:	e8 90 02 00 00       	call   8007bc <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 2e 18 00 00       	call   801d5f <sys_calculate_free_frames>
  800531:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800534:	e8 c6 18 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
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
  800583:	68 18 3c 80 00       	push   $0x803c18
  800588:	68 85 00 00 00       	push   $0x85
  80058d:	68 bc 3b 80 00       	push   $0x803bbc
  800592:	e8 25 02 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800597:	e8 63 18 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  80059c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059f:	74 17                	je     8005b8 <_main+0x580>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 48 3c 80 00       	push   $0x803c48
  8005a9:	68 87 00 00 00       	push   $0x87
  8005ae:	68 bc 3b 80 00       	push   $0x803bbc
  8005b3:	e8 04 02 00 00       	call   8007bc <_panic>
		//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8005b8:	e8 a2 17 00 00       	call   801d5f <sys_calculate_free_frames>
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005c0:	e8 3a 18 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
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
  8005f0:	68 18 3c 80 00       	push   $0x803c18
  8005f5:	68 95 00 00 00       	push   $0x95
  8005fa:	68 bc 3b 80 00       	push   $0x803bbc
  8005ff:	e8 b8 01 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800604:	e8 f6 17 00 00       	call   801dff <sys_pf_calculate_allocated_pages>
  800609:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80060c:	74 17                	je     800625 <_main+0x5ed>
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	68 48 3c 80 00       	push   $0x803c48
  800616:	68 97 00 00 00       	push   $0x97
  80061b:	68 bc 3b 80 00       	push   $0x803bbc
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
  800654:	68 7c 3c 80 00       	push   $0x803c7c
  800659:	68 a0 00 00 00       	push   $0xa0
  80065e:	68 bc 3b 80 00       	push   $0x803bbc
  800663:	e8 54 01 00 00       	call   8007bc <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	68 e0 3c 80 00       	push   $0x803ce0
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
  800686:	e8 b4 19 00 00       	call   80203f <sys_getenvindex>
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
  8006f1:	e8 56 17 00 00       	call   801e4c <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	68 44 3d 80 00       	push   $0x803d44
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
  800721:	68 6c 3d 80 00       	push   $0x803d6c
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
  800752:	68 94 3d 80 00       	push   $0x803d94
  800757:	e8 14 03 00 00       	call   800a70 <cprintf>
  80075c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80075f:	a1 20 50 80 00       	mov    0x805020,%eax
  800764:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	50                   	push   %eax
  80076e:	68 ec 3d 80 00       	push   $0x803dec
  800773:	e8 f8 02 00 00       	call   800a70 <cprintf>
  800778:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	68 44 3d 80 00       	push   $0x803d44
  800783:	e8 e8 02 00 00       	call   800a70 <cprintf>
  800788:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80078b:	e8 d6 16 00 00       	call   801e66 <sys_enable_interrupt>

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
  8007a3:	e8 63 18 00 00       	call   80200b <sys_destroy_env>
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
  8007b4:	e8 b8 18 00 00       	call   802071 <sys_exit_env>
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
  8007dd:	68 00 3e 80 00       	push   $0x803e00
  8007e2:	e8 89 02 00 00       	call   800a70 <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ea:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	50                   	push   %eax
  8007f6:	68 05 3e 80 00       	push   $0x803e05
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
  80081a:	68 21 3e 80 00       	push   $0x803e21
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
  800846:	68 24 3e 80 00       	push   $0x803e24
  80084b:	6a 26                	push   $0x26
  80084d:	68 70 3e 80 00       	push   $0x803e70
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
  800918:	68 7c 3e 80 00       	push   $0x803e7c
  80091d:	6a 3a                	push   $0x3a
  80091f:	68 70 3e 80 00       	push   $0x803e70
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
  800988:	68 d0 3e 80 00       	push   $0x803ed0
  80098d:	6a 44                	push   $0x44
  80098f:	68 70 3e 80 00       	push   $0x803e70
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
  8009e2:	e8 b7 12 00 00       	call   801c9e <sys_cputs>
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
  800a59:	e8 40 12 00 00       	call   801c9e <sys_cputs>
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
  800aa3:	e8 a4 13 00 00       	call   801e4c <sys_disable_interrupt>
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
  800ac3:	e8 9e 13 00 00       	call   801e66 <sys_enable_interrupt>
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
  800b0d:	e8 12 2e 00 00       	call   803924 <__udivdi3>
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
  800b5d:	e8 d2 2e 00 00       	call   803a34 <__umoddi3>
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	05 34 41 80 00       	add    $0x804134,%eax
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
  800cb8:	8b 04 85 58 41 80 00 	mov    0x804158(,%eax,4),%eax
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
  800d99:	8b 34 9d a0 3f 80 00 	mov    0x803fa0(,%ebx,4),%esi
  800da0:	85 f6                	test   %esi,%esi
  800da2:	75 19                	jne    800dbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da4:	53                   	push   %ebx
  800da5:	68 45 41 80 00       	push   $0x804145
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
  800dbe:	68 4e 41 80 00       	push   $0x80414e
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
  800deb:	be 51 41 80 00       	mov    $0x804151,%esi
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
  801811:	68 b0 42 80 00       	push   $0x8042b0
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
  8018e1:	e8 fc 04 00 00       	call   801de2 <sys_allocate_chunk>
  8018e6:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018e9:	a1 20 51 80 00       	mov    0x805120,%eax
  8018ee:	83 ec 0c             	sub    $0xc,%esp
  8018f1:	50                   	push   %eax
  8018f2:	e8 71 0b 00 00       	call   802468 <initialize_MemBlocksList>
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
  80191f:	68 d5 42 80 00       	push   $0x8042d5
  801924:	6a 33                	push   $0x33
  801926:	68 f3 42 80 00       	push   $0x8042f3
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
  80199e:	68 00 43 80 00       	push   $0x804300
  8019a3:	6a 34                	push   $0x34
  8019a5:	68 f3 42 80 00       	push   $0x8042f3
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
  801a36:	e8 75 07 00 00       	call   8021b0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	74 11                	je     801a50 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801a3f:	83 ec 0c             	sub    $0xc,%esp
  801a42:	ff 75 e8             	pushl  -0x18(%ebp)
  801a45:	e8 e0 0d 00 00       	call   80282a <alloc_block_FF>
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
  801a5c:	e8 3c 0b 00 00       	call   80259d <insert_sorted_allocList>
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
  801a7c:	68 24 43 80 00       	push   $0x804324
  801a81:	6a 6f                	push   $0x6f
  801a83:	68 f3 42 80 00       	push   $0x8042f3
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
  801aa2:	75 0a                	jne    801aae <smalloc+0x21>
  801aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa9:	e9 8b 00 00 00       	jmp    801b39 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801aae:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abb:	01 d0                	add    %edx,%eax
  801abd:	48                   	dec    %eax
  801abe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ac1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac9:	f7 75 f0             	divl   -0x10(%ebp)
  801acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801acf:	29 d0                	sub    %edx,%eax
  801ad1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801ad4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801adb:	e8 d0 06 00 00       	call   8021b0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	74 11                	je     801af5 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801ae4:	83 ec 0c             	sub    $0xc,%esp
  801ae7:	ff 75 e8             	pushl  -0x18(%ebp)
  801aea:	e8 3b 0d 00 00       	call   80282a <alloc_block_FF>
  801aef:	83 c4 10             	add    $0x10,%esp
  801af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801af5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801af9:	74 39                	je     801b34 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afe:	8b 40 08             	mov    0x8(%eax),%eax
  801b01:	89 c2                	mov    %eax,%edx
  801b03:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801b07:	52                   	push   %edx
  801b08:	50                   	push   %eax
  801b09:	ff 75 0c             	pushl  0xc(%ebp)
  801b0c:	ff 75 08             	pushl  0x8(%ebp)
  801b0f:	e8 21 04 00 00       	call   801f35 <sys_createSharedObject>
  801b14:	83 c4 10             	add    $0x10,%esp
  801b17:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801b1a:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801b1e:	74 14                	je     801b34 <smalloc+0xa7>
  801b20:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801b24:	74 0e                	je     801b34 <smalloc+0xa7>
  801b26:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801b2a:	74 08                	je     801b34 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2f:	8b 40 08             	mov    0x8(%eax),%eax
  801b32:	eb 05                	jmp    801b39 <smalloc+0xac>
	}
	return NULL;
  801b34:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b41:	e8 b4 fc ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b46:	83 ec 08             	sub    $0x8,%esp
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	ff 75 08             	pushl  0x8(%ebp)
  801b4f:	e8 0b 04 00 00       	call   801f5f <sys_getSizeOfSharedObject>
  801b54:	83 c4 10             	add    $0x10,%esp
  801b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801b5a:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801b5e:	74 76                	je     801bd6 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801b60:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b6d:	01 d0                	add    %edx,%eax
  801b6f:	48                   	dec    %eax
  801b70:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b76:	ba 00 00 00 00       	mov    $0x0,%edx
  801b7b:	f7 75 ec             	divl   -0x14(%ebp)
  801b7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b81:	29 d0                	sub    %edx,%eax
  801b83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801b86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801b8d:	e8 1e 06 00 00       	call   8021b0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b92:	85 c0                	test   %eax,%eax
  801b94:	74 11                	je     801ba7 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801b96:	83 ec 0c             	sub    $0xc,%esp
  801b99:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b9c:	e8 89 0c 00 00       	call   80282a <alloc_block_FF>
  801ba1:	83 c4 10             	add    $0x10,%esp
  801ba4:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801ba7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bab:	74 29                	je     801bd6 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb0:	8b 40 08             	mov    0x8(%eax),%eax
  801bb3:	83 ec 04             	sub    $0x4,%esp
  801bb6:	50                   	push   %eax
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	ff 75 08             	pushl  0x8(%ebp)
  801bbd:	e8 ba 03 00 00       	call   801f7c <sys_getSharedObject>
  801bc2:	83 c4 10             	add    $0x10,%esp
  801bc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801bc8:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801bcc:	74 08                	je     801bd6 <sget+0x9b>
				return (void *)mem_block->sva;
  801bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd1:	8b 40 08             	mov    0x8(%eax),%eax
  801bd4:	eb 05                	jmp    801bdb <sget+0xa0>
		}
	}
	return (void *)NULL;
  801bd6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801be3:	e8 12 fc ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801be8:	83 ec 04             	sub    $0x4,%esp
  801beb:	68 48 43 80 00       	push   $0x804348
  801bf0:	68 f1 00 00 00       	push   $0xf1
  801bf5:	68 f3 42 80 00       	push   $0x8042f3
  801bfa:	e8 bd eb ff ff       	call   8007bc <_panic>

00801bff <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c05:	83 ec 04             	sub    $0x4,%esp
  801c08:	68 70 43 80 00       	push   $0x804370
  801c0d:	68 05 01 00 00       	push   $0x105
  801c12:	68 f3 42 80 00       	push   $0x8042f3
  801c17:	e8 a0 eb ff ff       	call   8007bc <_panic>

00801c1c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c22:	83 ec 04             	sub    $0x4,%esp
  801c25:	68 94 43 80 00       	push   $0x804394
  801c2a:	68 10 01 00 00       	push   $0x110
  801c2f:	68 f3 42 80 00       	push   $0x8042f3
  801c34:	e8 83 eb ff ff       	call   8007bc <_panic>

00801c39 <shrink>:

}
void shrink(uint32 newSize)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c3f:	83 ec 04             	sub    $0x4,%esp
  801c42:	68 94 43 80 00       	push   $0x804394
  801c47:	68 15 01 00 00       	push   $0x115
  801c4c:	68 f3 42 80 00       	push   $0x8042f3
  801c51:	e8 66 eb ff ff       	call   8007bc <_panic>

00801c56 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	68 94 43 80 00       	push   $0x804394
  801c64:	68 1a 01 00 00       	push   $0x11a
  801c69:	68 f3 42 80 00       	push   $0x8042f3
  801c6e:	e8 49 eb ff ff       	call   8007bc <_panic>

00801c73 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	57                   	push   %edi
  801c77:	56                   	push   %esi
  801c78:	53                   	push   %ebx
  801c79:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c82:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c85:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c88:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c8b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c8e:	cd 30                	int    $0x30
  801c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	5b                   	pop    %ebx
  801c9a:	5e                   	pop    %esi
  801c9b:	5f                   	pop    %edi
  801c9c:	5d                   	pop    %ebp
  801c9d:	c3                   	ret    

00801c9e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 04             	sub    $0x4,%esp
  801ca4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801caa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	52                   	push   %edx
  801cb6:	ff 75 0c             	pushl  0xc(%ebp)
  801cb9:	50                   	push   %eax
  801cba:	6a 00                	push   $0x0
  801cbc:	e8 b2 ff ff ff       	call   801c73 <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	90                   	nop
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_cgetc>:

int
sys_cgetc(void)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 01                	push   $0x1
  801cd6:	e8 98 ff ff ff       	call   801c73 <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	52                   	push   %edx
  801cf0:	50                   	push   %eax
  801cf1:	6a 05                	push   $0x5
  801cf3:	e8 7b ff ff ff       	call   801c73 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	56                   	push   %esi
  801d01:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d02:	8b 75 18             	mov    0x18(%ebp),%esi
  801d05:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	56                   	push   %esi
  801d12:	53                   	push   %ebx
  801d13:	51                   	push   %ecx
  801d14:	52                   	push   %edx
  801d15:	50                   	push   %eax
  801d16:	6a 06                	push   $0x6
  801d18:	e8 56 ff ff ff       	call   801c73 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
}
  801d20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d23:	5b                   	pop    %ebx
  801d24:	5e                   	pop    %esi
  801d25:	5d                   	pop    %ebp
  801d26:	c3                   	ret    

00801d27 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	52                   	push   %edx
  801d37:	50                   	push   %eax
  801d38:	6a 07                	push   $0x7
  801d3a:	e8 34 ff ff ff       	call   801c73 <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	ff 75 0c             	pushl  0xc(%ebp)
  801d50:	ff 75 08             	pushl  0x8(%ebp)
  801d53:	6a 08                	push   $0x8
  801d55:	e8 19 ff ff ff       	call   801c73 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 09                	push   $0x9
  801d6e:	e8 00 ff ff ff       	call   801c73 <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 0a                	push   $0xa
  801d87:	e8 e7 fe ff ff       	call   801c73 <syscall>
  801d8c:	83 c4 18             	add    $0x18,%esp
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 0b                	push   $0xb
  801da0:	e8 ce fe ff ff       	call   801c73 <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	ff 75 0c             	pushl  0xc(%ebp)
  801db6:	ff 75 08             	pushl  0x8(%ebp)
  801db9:	6a 0f                	push   $0xf
  801dbb:	e8 b3 fe ff ff       	call   801c73 <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
	return;
  801dc3:	90                   	nop
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	ff 75 0c             	pushl  0xc(%ebp)
  801dd2:	ff 75 08             	pushl  0x8(%ebp)
  801dd5:	6a 10                	push   $0x10
  801dd7:	e8 97 fe ff ff       	call   801c73 <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddf:	90                   	nop
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	ff 75 10             	pushl  0x10(%ebp)
  801dec:	ff 75 0c             	pushl  0xc(%ebp)
  801def:	ff 75 08             	pushl  0x8(%ebp)
  801df2:	6a 11                	push   $0x11
  801df4:	e8 7a fe ff ff       	call   801c73 <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfc:	90                   	nop
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 0c                	push   $0xc
  801e0e:	e8 60 fe ff ff       	call   801c73 <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	ff 75 08             	pushl  0x8(%ebp)
  801e26:	6a 0d                	push   $0xd
  801e28:	e8 46 fe ff ff       	call   801c73 <syscall>
  801e2d:	83 c4 18             	add    $0x18,%esp
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 0e                	push   $0xe
  801e41:	e8 2d fe ff ff       	call   801c73 <syscall>
  801e46:	83 c4 18             	add    $0x18,%esp
}
  801e49:	90                   	nop
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 13                	push   $0x13
  801e5b:	e8 13 fe ff ff       	call   801c73 <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
}
  801e63:	90                   	nop
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 14                	push   $0x14
  801e75:	e8 f9 fd ff ff       	call   801c73 <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	90                   	nop
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	83 ec 04             	sub    $0x4,%esp
  801e86:	8b 45 08             	mov    0x8(%ebp),%eax
  801e89:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e8c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	50                   	push   %eax
  801e99:	6a 15                	push   $0x15
  801e9b:	e8 d3 fd ff ff       	call   801c73 <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	90                   	nop
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 16                	push   $0x16
  801eb5:	e8 b9 fd ff ff       	call   801c73 <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
}
  801ebd:	90                   	nop
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	ff 75 0c             	pushl  0xc(%ebp)
  801ecf:	50                   	push   %eax
  801ed0:	6a 17                	push   $0x17
  801ed2:	e8 9c fd ff ff       	call   801c73 <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801edf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	52                   	push   %edx
  801eec:	50                   	push   %eax
  801eed:	6a 1a                	push   $0x1a
  801eef:	e8 7f fd ff ff       	call   801c73 <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801efc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	52                   	push   %edx
  801f09:	50                   	push   %eax
  801f0a:	6a 18                	push   $0x18
  801f0c:	e8 62 fd ff ff       	call   801c73 <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
}
  801f14:	90                   	nop
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	52                   	push   %edx
  801f27:	50                   	push   %eax
  801f28:	6a 19                	push   $0x19
  801f2a:	e8 44 fd ff ff       	call   801c73 <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
}
  801f32:	90                   	nop
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 04             	sub    $0x4,%esp
  801f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f41:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f44:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	6a 00                	push   $0x0
  801f4d:	51                   	push   %ecx
  801f4e:	52                   	push   %edx
  801f4f:	ff 75 0c             	pushl  0xc(%ebp)
  801f52:	50                   	push   %eax
  801f53:	6a 1b                	push   $0x1b
  801f55:	e8 19 fd ff ff       	call   801c73 <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	52                   	push   %edx
  801f6f:	50                   	push   %eax
  801f70:	6a 1c                	push   $0x1c
  801f72:	e8 fc fc ff ff       	call   801c73 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	51                   	push   %ecx
  801f8d:	52                   	push   %edx
  801f8e:	50                   	push   %eax
  801f8f:	6a 1d                	push   $0x1d
  801f91:	e8 dd fc ff ff       	call   801c73 <syscall>
  801f96:	83 c4 18             	add    $0x18,%esp
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	52                   	push   %edx
  801fab:	50                   	push   %eax
  801fac:	6a 1e                	push   $0x1e
  801fae:	e8 c0 fc ff ff       	call   801c73 <syscall>
  801fb3:	83 c4 18             	add    $0x18,%esp
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 1f                	push   $0x1f
  801fc7:	e8 a7 fc ff ff       	call   801c73 <syscall>
  801fcc:	83 c4 18             	add    $0x18,%esp
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	6a 00                	push   $0x0
  801fd9:	ff 75 14             	pushl  0x14(%ebp)
  801fdc:	ff 75 10             	pushl  0x10(%ebp)
  801fdf:	ff 75 0c             	pushl  0xc(%ebp)
  801fe2:	50                   	push   %eax
  801fe3:	6a 20                	push   $0x20
  801fe5:	e8 89 fc ff ff       	call   801c73 <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	50                   	push   %eax
  801ffe:	6a 21                	push   $0x21
  802000:	e8 6e fc ff ff       	call   801c73 <syscall>
  802005:	83 c4 18             	add    $0x18,%esp
}
  802008:	90                   	nop
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	50                   	push   %eax
  80201a:	6a 22                	push   $0x22
  80201c:	e8 52 fc ff ff       	call   801c73 <syscall>
  802021:	83 c4 18             	add    $0x18,%esp
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 02                	push   $0x2
  802035:	e8 39 fc ff ff       	call   801c73 <syscall>
  80203a:	83 c4 18             	add    $0x18,%esp
}
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 03                	push   $0x3
  80204e:	e8 20 fc ff ff       	call   801c73 <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 04                	push   $0x4
  802067:	e8 07 fc ff ff       	call   801c73 <syscall>
  80206c:	83 c4 18             	add    $0x18,%esp
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <sys_exit_env>:


void sys_exit_env(void)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 23                	push   $0x23
  802080:	e8 ee fb ff ff       	call   801c73 <syscall>
  802085:	83 c4 18             	add    $0x18,%esp
}
  802088:	90                   	nop
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802091:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802094:	8d 50 04             	lea    0x4(%eax),%edx
  802097:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	52                   	push   %edx
  8020a1:	50                   	push   %eax
  8020a2:	6a 24                	push   $0x24
  8020a4:	e8 ca fb ff ff       	call   801c73 <syscall>
  8020a9:	83 c4 18             	add    $0x18,%esp
	return result;
  8020ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020b5:	89 01                	mov    %eax,(%ecx)
  8020b7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	c9                   	leave  
  8020be:	c2 04 00             	ret    $0x4

008020c1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	ff 75 10             	pushl  0x10(%ebp)
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	ff 75 08             	pushl  0x8(%ebp)
  8020d1:	6a 12                	push   $0x12
  8020d3:	e8 9b fb ff ff       	call   801c73 <syscall>
  8020d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8020db:	90                   	nop
}
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <sys_rcr2>:
uint32 sys_rcr2()
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 25                	push   $0x25
  8020ed:	e8 81 fb ff ff       	call   801c73 <syscall>
  8020f2:	83 c4 18             	add    $0x18,%esp
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	83 ec 04             	sub    $0x4,%esp
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802103:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	50                   	push   %eax
  802110:	6a 26                	push   $0x26
  802112:	e8 5c fb ff ff       	call   801c73 <syscall>
  802117:	83 c4 18             	add    $0x18,%esp
	return ;
  80211a:	90                   	nop
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <rsttst>:
void rsttst()
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 28                	push   $0x28
  80212c:	e8 42 fb ff ff       	call   801c73 <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
	return ;
  802134:	90                   	nop
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	83 ec 04             	sub    $0x4,%esp
  80213d:	8b 45 14             	mov    0x14(%ebp),%eax
  802140:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802143:	8b 55 18             	mov    0x18(%ebp),%edx
  802146:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80214a:	52                   	push   %edx
  80214b:	50                   	push   %eax
  80214c:	ff 75 10             	pushl  0x10(%ebp)
  80214f:	ff 75 0c             	pushl  0xc(%ebp)
  802152:	ff 75 08             	pushl  0x8(%ebp)
  802155:	6a 27                	push   $0x27
  802157:	e8 17 fb ff ff       	call   801c73 <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
	return ;
  80215f:	90                   	nop
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <chktst>:
void chktst(uint32 n)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	ff 75 08             	pushl  0x8(%ebp)
  802170:	6a 29                	push   $0x29
  802172:	e8 fc fa ff ff       	call   801c73 <syscall>
  802177:	83 c4 18             	add    $0x18,%esp
	return ;
  80217a:	90                   	nop
}
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <inctst>:

void inctst()
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 2a                	push   $0x2a
  80218c:	e8 e2 fa ff ff       	call   801c73 <syscall>
  802191:	83 c4 18             	add    $0x18,%esp
	return ;
  802194:	90                   	nop
}
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <gettst>:
uint32 gettst()
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 2b                	push   $0x2b
  8021a6:	e8 c8 fa ff ff       	call   801c73 <syscall>
  8021ab:	83 c4 18             	add    $0x18,%esp
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 2c                	push   $0x2c
  8021c2:	e8 ac fa ff ff       	call   801c73 <syscall>
  8021c7:	83 c4 18             	add    $0x18,%esp
  8021ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021cd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021d1:	75 07                	jne    8021da <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d8:	eb 05                	jmp    8021df <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
  8021e4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 2c                	push   $0x2c
  8021f3:	e8 7b fa ff ff       	call   801c73 <syscall>
  8021f8:	83 c4 18             	add    $0x18,%esp
  8021fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021fe:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802202:	75 07                	jne    80220b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802204:	b8 01 00 00 00       	mov    $0x1,%eax
  802209:	eb 05                	jmp    802210 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80220b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 2c                	push   $0x2c
  802224:	e8 4a fa ff ff       	call   801c73 <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
  80222c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80222f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802233:	75 07                	jne    80223c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802235:	b8 01 00 00 00       	mov    $0x1,%eax
  80223a:	eb 05                	jmp    802241 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80223c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 2c                	push   $0x2c
  802255:	e8 19 fa ff ff       	call   801c73 <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
  80225d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802260:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802264:	75 07                	jne    80226d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802266:	b8 01 00 00 00       	mov    $0x1,%eax
  80226b:	eb 05                	jmp    802272 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80226d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	ff 75 08             	pushl  0x8(%ebp)
  802282:	6a 2d                	push   $0x2d
  802284:	e8 ea f9 ff ff       	call   801c73 <syscall>
  802289:	83 c4 18             	add    $0x18,%esp
	return ;
  80228c:	90                   	nop
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802293:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802296:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802299:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	6a 00                	push   $0x0
  8022a1:	53                   	push   %ebx
  8022a2:	51                   	push   %ecx
  8022a3:	52                   	push   %edx
  8022a4:	50                   	push   %eax
  8022a5:	6a 2e                	push   $0x2e
  8022a7:	e8 c7 f9 ff ff       	call   801c73 <syscall>
  8022ac:	83 c4 18             	add    $0x18,%esp
}
  8022af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	52                   	push   %edx
  8022c4:	50                   	push   %eax
  8022c5:	6a 2f                	push   $0x2f
  8022c7:	e8 a7 f9 ff ff       	call   801c73 <syscall>
  8022cc:	83 c4 18             	add    $0x18,%esp
}
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    

008022d1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
  8022d4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022d7:	83 ec 0c             	sub    $0xc,%esp
  8022da:	68 a4 43 80 00       	push   $0x8043a4
  8022df:	e8 8c e7 ff ff       	call   800a70 <cprintf>
  8022e4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022ee:	83 ec 0c             	sub    $0xc,%esp
  8022f1:	68 d0 43 80 00       	push   $0x8043d0
  8022f6:	e8 75 e7 ff ff       	call   800a70 <cprintf>
  8022fb:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022fe:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802302:	a1 38 51 80 00       	mov    0x805138,%eax
  802307:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230a:	eb 56                	jmp    802362 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80230c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802310:	74 1c                	je     80232e <print_mem_block_lists+0x5d>
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	8b 50 08             	mov    0x8(%eax),%edx
  802318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231b:	8b 48 08             	mov    0x8(%eax),%ecx
  80231e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802321:	8b 40 0c             	mov    0xc(%eax),%eax
  802324:	01 c8                	add    %ecx,%eax
  802326:	39 c2                	cmp    %eax,%edx
  802328:	73 04                	jae    80232e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80232a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	8b 50 08             	mov    0x8(%eax),%edx
  802334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802337:	8b 40 0c             	mov    0xc(%eax),%eax
  80233a:	01 c2                	add    %eax,%edx
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 40 08             	mov    0x8(%eax),%eax
  802342:	83 ec 04             	sub    $0x4,%esp
  802345:	52                   	push   %edx
  802346:	50                   	push   %eax
  802347:	68 e5 43 80 00       	push   $0x8043e5
  80234c:	e8 1f e7 ff ff       	call   800a70 <cprintf>
  802351:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80235a:	a1 40 51 80 00       	mov    0x805140,%eax
  80235f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802366:	74 07                	je     80236f <print_mem_block_lists+0x9e>
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	8b 00                	mov    (%eax),%eax
  80236d:	eb 05                	jmp    802374 <print_mem_block_lists+0xa3>
  80236f:	b8 00 00 00 00       	mov    $0x0,%eax
  802374:	a3 40 51 80 00       	mov    %eax,0x805140
  802379:	a1 40 51 80 00       	mov    0x805140,%eax
  80237e:	85 c0                	test   %eax,%eax
  802380:	75 8a                	jne    80230c <print_mem_block_lists+0x3b>
  802382:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802386:	75 84                	jne    80230c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802388:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80238c:	75 10                	jne    80239e <print_mem_block_lists+0xcd>
  80238e:	83 ec 0c             	sub    $0xc,%esp
  802391:	68 f4 43 80 00       	push   $0x8043f4
  802396:	e8 d5 e6 ff ff       	call   800a70 <cprintf>
  80239b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80239e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8023a5:	83 ec 0c             	sub    $0xc,%esp
  8023a8:	68 18 44 80 00       	push   $0x804418
  8023ad:	e8 be e6 ff ff       	call   800a70 <cprintf>
  8023b2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8023b5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023b9:	a1 40 50 80 00       	mov    0x805040,%eax
  8023be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c1:	eb 56                	jmp    802419 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023c7:	74 1c                	je     8023e5 <print_mem_block_lists+0x114>
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	8b 50 08             	mov    0x8(%eax),%edx
  8023cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d2:	8b 48 08             	mov    0x8(%eax),%ecx
  8023d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023db:	01 c8                	add    %ecx,%eax
  8023dd:	39 c2                	cmp    %eax,%edx
  8023df:	73 04                	jae    8023e5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023e1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e8:	8b 50 08             	mov    0x8(%eax),%edx
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f1:	01 c2                	add    %eax,%edx
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	8b 40 08             	mov    0x8(%eax),%eax
  8023f9:	83 ec 04             	sub    $0x4,%esp
  8023fc:	52                   	push   %edx
  8023fd:	50                   	push   %eax
  8023fe:	68 e5 43 80 00       	push   $0x8043e5
  802403:	e8 68 e6 ff ff       	call   800a70 <cprintf>
  802408:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802411:	a1 48 50 80 00       	mov    0x805048,%eax
  802416:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241d:	74 07                	je     802426 <print_mem_block_lists+0x155>
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 00                	mov    (%eax),%eax
  802424:	eb 05                	jmp    80242b <print_mem_block_lists+0x15a>
  802426:	b8 00 00 00 00       	mov    $0x0,%eax
  80242b:	a3 48 50 80 00       	mov    %eax,0x805048
  802430:	a1 48 50 80 00       	mov    0x805048,%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	75 8a                	jne    8023c3 <print_mem_block_lists+0xf2>
  802439:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243d:	75 84                	jne    8023c3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80243f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802443:	75 10                	jne    802455 <print_mem_block_lists+0x184>
  802445:	83 ec 0c             	sub    $0xc,%esp
  802448:	68 30 44 80 00       	push   $0x804430
  80244d:	e8 1e e6 ff ff       	call   800a70 <cprintf>
  802452:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802455:	83 ec 0c             	sub    $0xc,%esp
  802458:	68 a4 43 80 00       	push   $0x8043a4
  80245d:	e8 0e e6 ff ff       	call   800a70 <cprintf>
  802462:	83 c4 10             	add    $0x10,%esp

}
  802465:	90                   	nop
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
  80246b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80246e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802475:	00 00 00 
  802478:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80247f:	00 00 00 
  802482:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802489:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80248c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802493:	e9 9e 00 00 00       	jmp    802536 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802498:	a1 50 50 80 00       	mov    0x805050,%eax
  80249d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a0:	c1 e2 04             	shl    $0x4,%edx
  8024a3:	01 d0                	add    %edx,%eax
  8024a5:	85 c0                	test   %eax,%eax
  8024a7:	75 14                	jne    8024bd <initialize_MemBlocksList+0x55>
  8024a9:	83 ec 04             	sub    $0x4,%esp
  8024ac:	68 58 44 80 00       	push   $0x804458
  8024b1:	6a 46                	push   $0x46
  8024b3:	68 7b 44 80 00       	push   $0x80447b
  8024b8:	e8 ff e2 ff ff       	call   8007bc <_panic>
  8024bd:	a1 50 50 80 00       	mov    0x805050,%eax
  8024c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c5:	c1 e2 04             	shl    $0x4,%edx
  8024c8:	01 d0                	add    %edx,%eax
  8024ca:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8024d0:	89 10                	mov    %edx,(%eax)
  8024d2:	8b 00                	mov    (%eax),%eax
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	74 18                	je     8024f0 <initialize_MemBlocksList+0x88>
  8024d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8024dd:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024e3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024e6:	c1 e1 04             	shl    $0x4,%ecx
  8024e9:	01 ca                	add    %ecx,%edx
  8024eb:	89 50 04             	mov    %edx,0x4(%eax)
  8024ee:	eb 12                	jmp    802502 <initialize_MemBlocksList+0x9a>
  8024f0:	a1 50 50 80 00       	mov    0x805050,%eax
  8024f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f8:	c1 e2 04             	shl    $0x4,%edx
  8024fb:	01 d0                	add    %edx,%eax
  8024fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802502:	a1 50 50 80 00       	mov    0x805050,%eax
  802507:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250a:	c1 e2 04             	shl    $0x4,%edx
  80250d:	01 d0                	add    %edx,%eax
  80250f:	a3 48 51 80 00       	mov    %eax,0x805148
  802514:	a1 50 50 80 00       	mov    0x805050,%eax
  802519:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251c:	c1 e2 04             	shl    $0x4,%edx
  80251f:	01 d0                	add    %edx,%eax
  802521:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802528:	a1 54 51 80 00       	mov    0x805154,%eax
  80252d:	40                   	inc    %eax
  80252e:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802533:	ff 45 f4             	incl   -0xc(%ebp)
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	3b 45 08             	cmp    0x8(%ebp),%eax
  80253c:	0f 82 56 ff ff ff    	jb     802498 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802542:	90                   	nop
  802543:	c9                   	leave  
  802544:	c3                   	ret    

00802545 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802545:	55                   	push   %ebp
  802546:	89 e5                	mov    %esp,%ebp
  802548:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	8b 00                	mov    (%eax),%eax
  802550:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802553:	eb 19                	jmp    80256e <find_block+0x29>
	{
		if(va==point->sva)
  802555:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802558:	8b 40 08             	mov    0x8(%eax),%eax
  80255b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80255e:	75 05                	jne    802565 <find_block+0x20>
		   return point;
  802560:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802563:	eb 36                	jmp    80259b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802565:	8b 45 08             	mov    0x8(%ebp),%eax
  802568:	8b 40 08             	mov    0x8(%eax),%eax
  80256b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80256e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802572:	74 07                	je     80257b <find_block+0x36>
  802574:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802577:	8b 00                	mov    (%eax),%eax
  802579:	eb 05                	jmp    802580 <find_block+0x3b>
  80257b:	b8 00 00 00 00       	mov    $0x0,%eax
  802580:	8b 55 08             	mov    0x8(%ebp),%edx
  802583:	89 42 08             	mov    %eax,0x8(%edx)
  802586:	8b 45 08             	mov    0x8(%ebp),%eax
  802589:	8b 40 08             	mov    0x8(%eax),%eax
  80258c:	85 c0                	test   %eax,%eax
  80258e:	75 c5                	jne    802555 <find_block+0x10>
  802590:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802594:	75 bf                	jne    802555 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802596:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80259b:	c9                   	leave  
  80259c:	c3                   	ret    

0080259d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
  8025a0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8025a3:	a1 40 50 80 00       	mov    0x805040,%eax
  8025a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8025ab:	a1 44 50 80 00       	mov    0x805044,%eax
  8025b0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8025b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025b9:	74 24                	je     8025df <insert_sorted_allocList+0x42>
  8025bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025be:	8b 50 08             	mov    0x8(%eax),%edx
  8025c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c4:	8b 40 08             	mov    0x8(%eax),%eax
  8025c7:	39 c2                	cmp    %eax,%edx
  8025c9:	76 14                	jbe    8025df <insert_sorted_allocList+0x42>
  8025cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ce:	8b 50 08             	mov    0x8(%eax),%edx
  8025d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d4:	8b 40 08             	mov    0x8(%eax),%eax
  8025d7:	39 c2                	cmp    %eax,%edx
  8025d9:	0f 82 60 01 00 00    	jb     80273f <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8025df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025e3:	75 65                	jne    80264a <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8025e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025e9:	75 14                	jne    8025ff <insert_sorted_allocList+0x62>
  8025eb:	83 ec 04             	sub    $0x4,%esp
  8025ee:	68 58 44 80 00       	push   $0x804458
  8025f3:	6a 6b                	push   $0x6b
  8025f5:	68 7b 44 80 00       	push   $0x80447b
  8025fa:	e8 bd e1 ff ff       	call   8007bc <_panic>
  8025ff:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802605:	8b 45 08             	mov    0x8(%ebp),%eax
  802608:	89 10                	mov    %edx,(%eax)
  80260a:	8b 45 08             	mov    0x8(%ebp),%eax
  80260d:	8b 00                	mov    (%eax),%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	74 0d                	je     802620 <insert_sorted_allocList+0x83>
  802613:	a1 40 50 80 00       	mov    0x805040,%eax
  802618:	8b 55 08             	mov    0x8(%ebp),%edx
  80261b:	89 50 04             	mov    %edx,0x4(%eax)
  80261e:	eb 08                	jmp    802628 <insert_sorted_allocList+0x8b>
  802620:	8b 45 08             	mov    0x8(%ebp),%eax
  802623:	a3 44 50 80 00       	mov    %eax,0x805044
  802628:	8b 45 08             	mov    0x8(%ebp),%eax
  80262b:	a3 40 50 80 00       	mov    %eax,0x805040
  802630:	8b 45 08             	mov    0x8(%ebp),%eax
  802633:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80263f:	40                   	inc    %eax
  802640:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802645:	e9 dc 01 00 00       	jmp    802826 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80264a:	8b 45 08             	mov    0x8(%ebp),%eax
  80264d:	8b 50 08             	mov    0x8(%eax),%edx
  802650:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802653:	8b 40 08             	mov    0x8(%eax),%eax
  802656:	39 c2                	cmp    %eax,%edx
  802658:	77 6c                	ja     8026c6 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80265a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80265e:	74 06                	je     802666 <insert_sorted_allocList+0xc9>
  802660:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802664:	75 14                	jne    80267a <insert_sorted_allocList+0xdd>
  802666:	83 ec 04             	sub    $0x4,%esp
  802669:	68 94 44 80 00       	push   $0x804494
  80266e:	6a 6f                	push   $0x6f
  802670:	68 7b 44 80 00       	push   $0x80447b
  802675:	e8 42 e1 ff ff       	call   8007bc <_panic>
  80267a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267d:	8b 50 04             	mov    0x4(%eax),%edx
  802680:	8b 45 08             	mov    0x8(%ebp),%eax
  802683:	89 50 04             	mov    %edx,0x4(%eax)
  802686:	8b 45 08             	mov    0x8(%ebp),%eax
  802689:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80268c:	89 10                	mov    %edx,(%eax)
  80268e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802691:	8b 40 04             	mov    0x4(%eax),%eax
  802694:	85 c0                	test   %eax,%eax
  802696:	74 0d                	je     8026a5 <insert_sorted_allocList+0x108>
  802698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269b:	8b 40 04             	mov    0x4(%eax),%eax
  80269e:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a1:	89 10                	mov    %edx,(%eax)
  8026a3:	eb 08                	jmp    8026ad <insert_sorted_allocList+0x110>
  8026a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a8:	a3 40 50 80 00       	mov    %eax,0x805040
  8026ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b3:	89 50 04             	mov    %edx,0x4(%eax)
  8026b6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026bb:	40                   	inc    %eax
  8026bc:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026c1:	e9 60 01 00 00       	jmp    802826 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	8b 50 08             	mov    0x8(%eax),%edx
  8026cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cf:	8b 40 08             	mov    0x8(%eax),%eax
  8026d2:	39 c2                	cmp    %eax,%edx
  8026d4:	0f 82 4c 01 00 00    	jb     802826 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8026da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026de:	75 14                	jne    8026f4 <insert_sorted_allocList+0x157>
  8026e0:	83 ec 04             	sub    $0x4,%esp
  8026e3:	68 cc 44 80 00       	push   $0x8044cc
  8026e8:	6a 73                	push   $0x73
  8026ea:	68 7b 44 80 00       	push   $0x80447b
  8026ef:	e8 c8 e0 ff ff       	call   8007bc <_panic>
  8026f4:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fd:	89 50 04             	mov    %edx,0x4(%eax)
  802700:	8b 45 08             	mov    0x8(%ebp),%eax
  802703:	8b 40 04             	mov    0x4(%eax),%eax
  802706:	85 c0                	test   %eax,%eax
  802708:	74 0c                	je     802716 <insert_sorted_allocList+0x179>
  80270a:	a1 44 50 80 00       	mov    0x805044,%eax
  80270f:	8b 55 08             	mov    0x8(%ebp),%edx
  802712:	89 10                	mov    %edx,(%eax)
  802714:	eb 08                	jmp    80271e <insert_sorted_allocList+0x181>
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	a3 40 50 80 00       	mov    %eax,0x805040
  80271e:	8b 45 08             	mov    0x8(%ebp),%eax
  802721:	a3 44 50 80 00       	mov    %eax,0x805044
  802726:	8b 45 08             	mov    0x8(%ebp),%eax
  802729:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802734:	40                   	inc    %eax
  802735:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80273a:	e9 e7 00 00 00       	jmp    802826 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80273f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802742:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802745:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80274c:	a1 40 50 80 00       	mov    0x805040,%eax
  802751:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802754:	e9 9d 00 00 00       	jmp    8027f6 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 00                	mov    (%eax),%eax
  80275e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802761:	8b 45 08             	mov    0x8(%ebp),%eax
  802764:	8b 50 08             	mov    0x8(%eax),%edx
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 08             	mov    0x8(%eax),%eax
  80276d:	39 c2                	cmp    %eax,%edx
  80276f:	76 7d                	jbe    8027ee <insert_sorted_allocList+0x251>
  802771:	8b 45 08             	mov    0x8(%ebp),%eax
  802774:	8b 50 08             	mov    0x8(%eax),%edx
  802777:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277a:	8b 40 08             	mov    0x8(%eax),%eax
  80277d:	39 c2                	cmp    %eax,%edx
  80277f:	73 6d                	jae    8027ee <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802785:	74 06                	je     80278d <insert_sorted_allocList+0x1f0>
  802787:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80278b:	75 14                	jne    8027a1 <insert_sorted_allocList+0x204>
  80278d:	83 ec 04             	sub    $0x4,%esp
  802790:	68 f0 44 80 00       	push   $0x8044f0
  802795:	6a 7f                	push   $0x7f
  802797:	68 7b 44 80 00       	push   $0x80447b
  80279c:	e8 1b e0 ff ff       	call   8007bc <_panic>
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 10                	mov    (%eax),%edx
  8027a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a9:	89 10                	mov    %edx,(%eax)
  8027ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ae:	8b 00                	mov    (%eax),%eax
  8027b0:	85 c0                	test   %eax,%eax
  8027b2:	74 0b                	je     8027bf <insert_sorted_allocList+0x222>
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	8b 00                	mov    (%eax),%eax
  8027b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027bc:	89 50 04             	mov    %edx,0x4(%eax)
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c5:	89 10                	mov    %edx,(%eax)
  8027c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027cd:	89 50 04             	mov    %edx,0x4(%eax)
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	8b 00                	mov    (%eax),%eax
  8027d5:	85 c0                	test   %eax,%eax
  8027d7:	75 08                	jne    8027e1 <insert_sorted_allocList+0x244>
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	a3 44 50 80 00       	mov    %eax,0x805044
  8027e1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027e6:	40                   	inc    %eax
  8027e7:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8027ec:	eb 39                	jmp    802827 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8027ee:	a1 48 50 80 00       	mov    0x805048,%eax
  8027f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fa:	74 07                	je     802803 <insert_sorted_allocList+0x266>
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	eb 05                	jmp    802808 <insert_sorted_allocList+0x26b>
  802803:	b8 00 00 00 00       	mov    $0x0,%eax
  802808:	a3 48 50 80 00       	mov    %eax,0x805048
  80280d:	a1 48 50 80 00       	mov    0x805048,%eax
  802812:	85 c0                	test   %eax,%eax
  802814:	0f 85 3f ff ff ff    	jne    802759 <insert_sorted_allocList+0x1bc>
  80281a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281e:	0f 85 35 ff ff ff    	jne    802759 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802824:	eb 01                	jmp    802827 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802826:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802827:	90                   	nop
  802828:	c9                   	leave  
  802829:	c3                   	ret    

0080282a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
  80282d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802830:	a1 38 51 80 00       	mov    0x805138,%eax
  802835:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802838:	e9 85 01 00 00       	jmp    8029c2 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	8b 40 0c             	mov    0xc(%eax),%eax
  802843:	3b 45 08             	cmp    0x8(%ebp),%eax
  802846:	0f 82 6e 01 00 00    	jb     8029ba <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 40 0c             	mov    0xc(%eax),%eax
  802852:	3b 45 08             	cmp    0x8(%ebp),%eax
  802855:	0f 85 8a 00 00 00    	jne    8028e5 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80285b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285f:	75 17                	jne    802878 <alloc_block_FF+0x4e>
  802861:	83 ec 04             	sub    $0x4,%esp
  802864:	68 24 45 80 00       	push   $0x804524
  802869:	68 93 00 00 00       	push   $0x93
  80286e:	68 7b 44 80 00       	push   $0x80447b
  802873:	e8 44 df ff ff       	call   8007bc <_panic>
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 00                	mov    (%eax),%eax
  80287d:	85 c0                	test   %eax,%eax
  80287f:	74 10                	je     802891 <alloc_block_FF+0x67>
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 00                	mov    (%eax),%eax
  802886:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802889:	8b 52 04             	mov    0x4(%edx),%edx
  80288c:	89 50 04             	mov    %edx,0x4(%eax)
  80288f:	eb 0b                	jmp    80289c <alloc_block_FF+0x72>
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	8b 40 04             	mov    0x4(%eax),%eax
  802897:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 40 04             	mov    0x4(%eax),%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	74 0f                	je     8028b5 <alloc_block_FF+0x8b>
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 40 04             	mov    0x4(%eax),%eax
  8028ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028af:	8b 12                	mov    (%edx),%edx
  8028b1:	89 10                	mov    %edx,(%eax)
  8028b3:	eb 0a                	jmp    8028bf <alloc_block_FF+0x95>
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	8b 00                	mov    (%eax),%eax
  8028ba:	a3 38 51 80 00       	mov    %eax,0x805138
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d2:	a1 44 51 80 00       	mov    0x805144,%eax
  8028d7:	48                   	dec    %eax
  8028d8:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	e9 10 01 00 00       	jmp    8029f5 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ee:	0f 86 c6 00 00 00    	jbe    8029ba <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028f4:	a1 48 51 80 00       	mov    0x805148,%eax
  8028f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 50 08             	mov    0x8(%eax),%edx
  802902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802905:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802908:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290b:	8b 55 08             	mov    0x8(%ebp),%edx
  80290e:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802911:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802915:	75 17                	jne    80292e <alloc_block_FF+0x104>
  802917:	83 ec 04             	sub    $0x4,%esp
  80291a:	68 24 45 80 00       	push   $0x804524
  80291f:	68 9b 00 00 00       	push   $0x9b
  802924:	68 7b 44 80 00       	push   $0x80447b
  802929:	e8 8e de ff ff       	call   8007bc <_panic>
  80292e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802931:	8b 00                	mov    (%eax),%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	74 10                	je     802947 <alloc_block_FF+0x11d>
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80293f:	8b 52 04             	mov    0x4(%edx),%edx
  802942:	89 50 04             	mov    %edx,0x4(%eax)
  802945:	eb 0b                	jmp    802952 <alloc_block_FF+0x128>
  802947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294a:	8b 40 04             	mov    0x4(%eax),%eax
  80294d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802955:	8b 40 04             	mov    0x4(%eax),%eax
  802958:	85 c0                	test   %eax,%eax
  80295a:	74 0f                	je     80296b <alloc_block_FF+0x141>
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	8b 40 04             	mov    0x4(%eax),%eax
  802962:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802965:	8b 12                	mov    (%edx),%edx
  802967:	89 10                	mov    %edx,(%eax)
  802969:	eb 0a                	jmp    802975 <alloc_block_FF+0x14b>
  80296b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296e:	8b 00                	mov    (%eax),%eax
  802970:	a3 48 51 80 00       	mov    %eax,0x805148
  802975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802978:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802981:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802988:	a1 54 51 80 00       	mov    0x805154,%eax
  80298d:	48                   	dec    %eax
  80298e:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	8b 50 08             	mov    0x8(%eax),%edx
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	01 c2                	add    %eax,%edx
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8029a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029aa:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ad:	89 c2                	mov    %eax,%edx
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8029b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b8:	eb 3b                	jmp    8029f5 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8029ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8029bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c6:	74 07                	je     8029cf <alloc_block_FF+0x1a5>
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	8b 00                	mov    (%eax),%eax
  8029cd:	eb 05                	jmp    8029d4 <alloc_block_FF+0x1aa>
  8029cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d4:	a3 40 51 80 00       	mov    %eax,0x805140
  8029d9:	a1 40 51 80 00       	mov    0x805140,%eax
  8029de:	85 c0                	test   %eax,%eax
  8029e0:	0f 85 57 fe ff ff    	jne    80283d <alloc_block_FF+0x13>
  8029e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ea:	0f 85 4d fe ff ff    	jne    80283d <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8029f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029f5:	c9                   	leave  
  8029f6:	c3                   	ret    

008029f7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8029f7:	55                   	push   %ebp
  8029f8:	89 e5                	mov    %esp,%ebp
  8029fa:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8029fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a04:	a1 38 51 80 00       	mov    0x805138,%eax
  802a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0c:	e9 df 00 00 00       	jmp    802af0 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a14:	8b 40 0c             	mov    0xc(%eax),%eax
  802a17:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a1a:	0f 82 c8 00 00 00    	jb     802ae8 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 40 0c             	mov    0xc(%eax),%eax
  802a26:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a29:	0f 85 8a 00 00 00    	jne    802ab9 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802a2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a33:	75 17                	jne    802a4c <alloc_block_BF+0x55>
  802a35:	83 ec 04             	sub    $0x4,%esp
  802a38:	68 24 45 80 00       	push   $0x804524
  802a3d:	68 b7 00 00 00       	push   $0xb7
  802a42:	68 7b 44 80 00       	push   $0x80447b
  802a47:	e8 70 dd ff ff       	call   8007bc <_panic>
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	8b 00                	mov    (%eax),%eax
  802a51:	85 c0                	test   %eax,%eax
  802a53:	74 10                	je     802a65 <alloc_block_BF+0x6e>
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 00                	mov    (%eax),%eax
  802a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5d:	8b 52 04             	mov    0x4(%edx),%edx
  802a60:	89 50 04             	mov    %edx,0x4(%eax)
  802a63:	eb 0b                	jmp    802a70 <alloc_block_BF+0x79>
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 40 04             	mov    0x4(%eax),%eax
  802a6b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	8b 40 04             	mov    0x4(%eax),%eax
  802a76:	85 c0                	test   %eax,%eax
  802a78:	74 0f                	je     802a89 <alloc_block_BF+0x92>
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 40 04             	mov    0x4(%eax),%eax
  802a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a83:	8b 12                	mov    (%edx),%edx
  802a85:	89 10                	mov    %edx,(%eax)
  802a87:	eb 0a                	jmp    802a93 <alloc_block_BF+0x9c>
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 00                	mov    (%eax),%eax
  802a8e:	a3 38 51 80 00       	mov    %eax,0x805138
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa6:	a1 44 51 80 00       	mov    0x805144,%eax
  802aab:	48                   	dec    %eax
  802aac:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	e9 4d 01 00 00       	jmp    802c06 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 40 0c             	mov    0xc(%eax),%eax
  802abf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac2:	76 24                	jbe    802ae8 <alloc_block_BF+0xf1>
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802acd:	73 19                	jae    802ae8 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802acf:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	8b 40 0c             	mov    0xc(%eax),%eax
  802adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 40 08             	mov    0x8(%eax),%eax
  802ae5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ae8:	a1 40 51 80 00       	mov    0x805140,%eax
  802aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af4:	74 07                	je     802afd <alloc_block_BF+0x106>
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 00                	mov    (%eax),%eax
  802afb:	eb 05                	jmp    802b02 <alloc_block_BF+0x10b>
  802afd:	b8 00 00 00 00       	mov    $0x0,%eax
  802b02:	a3 40 51 80 00       	mov    %eax,0x805140
  802b07:	a1 40 51 80 00       	mov    0x805140,%eax
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	0f 85 fd fe ff ff    	jne    802a11 <alloc_block_BF+0x1a>
  802b14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b18:	0f 85 f3 fe ff ff    	jne    802a11 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802b1e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b22:	0f 84 d9 00 00 00    	je     802c01 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b28:	a1 48 51 80 00       	mov    0x805148,%eax
  802b2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b33:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b36:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802b39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3f:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802b42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b46:	75 17                	jne    802b5f <alloc_block_BF+0x168>
  802b48:	83 ec 04             	sub    $0x4,%esp
  802b4b:	68 24 45 80 00       	push   $0x804524
  802b50:	68 c7 00 00 00       	push   $0xc7
  802b55:	68 7b 44 80 00       	push   $0x80447b
  802b5a:	e8 5d dc ff ff       	call   8007bc <_panic>
  802b5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b62:	8b 00                	mov    (%eax),%eax
  802b64:	85 c0                	test   %eax,%eax
  802b66:	74 10                	je     802b78 <alloc_block_BF+0x181>
  802b68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b6b:	8b 00                	mov    (%eax),%eax
  802b6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b70:	8b 52 04             	mov    0x4(%edx),%edx
  802b73:	89 50 04             	mov    %edx,0x4(%eax)
  802b76:	eb 0b                	jmp    802b83 <alloc_block_BF+0x18c>
  802b78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b7b:	8b 40 04             	mov    0x4(%eax),%eax
  802b7e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b86:	8b 40 04             	mov    0x4(%eax),%eax
  802b89:	85 c0                	test   %eax,%eax
  802b8b:	74 0f                	je     802b9c <alloc_block_BF+0x1a5>
  802b8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b90:	8b 40 04             	mov    0x4(%eax),%eax
  802b93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b96:	8b 12                	mov    (%edx),%edx
  802b98:	89 10                	mov    %edx,(%eax)
  802b9a:	eb 0a                	jmp    802ba6 <alloc_block_BF+0x1af>
  802b9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b9f:	8b 00                	mov    (%eax),%eax
  802ba1:	a3 48 51 80 00       	mov    %eax,0x805148
  802ba6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802baf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb9:	a1 54 51 80 00       	mov    0x805154,%eax
  802bbe:	48                   	dec    %eax
  802bbf:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802bc4:	83 ec 08             	sub    $0x8,%esp
  802bc7:	ff 75 ec             	pushl  -0x14(%ebp)
  802bca:	68 38 51 80 00       	push   $0x805138
  802bcf:	e8 71 f9 ff ff       	call   802545 <find_block>
  802bd4:	83 c4 10             	add    $0x10,%esp
  802bd7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802bda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bdd:	8b 50 08             	mov    0x8(%eax),%edx
  802be0:	8b 45 08             	mov    0x8(%ebp),%eax
  802be3:	01 c2                	add    %eax,%edx
  802be5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be8:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802beb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bee:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf1:	2b 45 08             	sub    0x8(%ebp),%eax
  802bf4:	89 c2                	mov    %eax,%edx
  802bf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf9:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802bfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bff:	eb 05                	jmp    802c06 <alloc_block_BF+0x20f>
	}
	return NULL;
  802c01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c06:	c9                   	leave  
  802c07:	c3                   	ret    

00802c08 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c08:	55                   	push   %ebp
  802c09:	89 e5                	mov    %esp,%ebp
  802c0b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802c0e:	a1 28 50 80 00       	mov    0x805028,%eax
  802c13:	85 c0                	test   %eax,%eax
  802c15:	0f 85 de 01 00 00    	jne    802df9 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c1b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c23:	e9 9e 01 00 00       	jmp    802dc6 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c31:	0f 82 87 01 00 00    	jb     802dbe <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c40:	0f 85 95 00 00 00    	jne    802cdb <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802c46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4a:	75 17                	jne    802c63 <alloc_block_NF+0x5b>
  802c4c:	83 ec 04             	sub    $0x4,%esp
  802c4f:	68 24 45 80 00       	push   $0x804524
  802c54:	68 e0 00 00 00       	push   $0xe0
  802c59:	68 7b 44 80 00       	push   $0x80447b
  802c5e:	e8 59 db ff ff       	call   8007bc <_panic>
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	8b 00                	mov    (%eax),%eax
  802c68:	85 c0                	test   %eax,%eax
  802c6a:	74 10                	je     802c7c <alloc_block_NF+0x74>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 00                	mov    (%eax),%eax
  802c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c74:	8b 52 04             	mov    0x4(%edx),%edx
  802c77:	89 50 04             	mov    %edx,0x4(%eax)
  802c7a:	eb 0b                	jmp    802c87 <alloc_block_NF+0x7f>
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	8b 40 04             	mov    0x4(%eax),%eax
  802c82:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8a:	8b 40 04             	mov    0x4(%eax),%eax
  802c8d:	85 c0                	test   %eax,%eax
  802c8f:	74 0f                	je     802ca0 <alloc_block_NF+0x98>
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 40 04             	mov    0x4(%eax),%eax
  802c97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c9a:	8b 12                	mov    (%edx),%edx
  802c9c:	89 10                	mov    %edx,(%eax)
  802c9e:	eb 0a                	jmp    802caa <alloc_block_NF+0xa2>
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 00                	mov    (%eax),%eax
  802ca5:	a3 38 51 80 00       	mov    %eax,0x805138
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cbd:	a1 44 51 80 00       	mov    0x805144,%eax
  802cc2:	48                   	dec    %eax
  802cc3:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 40 08             	mov    0x8(%eax),%eax
  802cce:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	e9 f8 04 00 00       	jmp    8031d3 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce4:	0f 86 d4 00 00 00    	jbe    802dbe <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cea:	a1 48 51 80 00       	mov    0x805148,%eax
  802cef:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf5:	8b 50 08             	mov    0x8(%eax),%edx
  802cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfb:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	8b 55 08             	mov    0x8(%ebp),%edx
  802d04:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0b:	75 17                	jne    802d24 <alloc_block_NF+0x11c>
  802d0d:	83 ec 04             	sub    $0x4,%esp
  802d10:	68 24 45 80 00       	push   $0x804524
  802d15:	68 e9 00 00 00       	push   $0xe9
  802d1a:	68 7b 44 80 00       	push   $0x80447b
  802d1f:	e8 98 da ff ff       	call   8007bc <_panic>
  802d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d27:	8b 00                	mov    (%eax),%eax
  802d29:	85 c0                	test   %eax,%eax
  802d2b:	74 10                	je     802d3d <alloc_block_NF+0x135>
  802d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d30:	8b 00                	mov    (%eax),%eax
  802d32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d35:	8b 52 04             	mov    0x4(%edx),%edx
  802d38:	89 50 04             	mov    %edx,0x4(%eax)
  802d3b:	eb 0b                	jmp    802d48 <alloc_block_NF+0x140>
  802d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d40:	8b 40 04             	mov    0x4(%eax),%eax
  802d43:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4b:	8b 40 04             	mov    0x4(%eax),%eax
  802d4e:	85 c0                	test   %eax,%eax
  802d50:	74 0f                	je     802d61 <alloc_block_NF+0x159>
  802d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d55:	8b 40 04             	mov    0x4(%eax),%eax
  802d58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5b:	8b 12                	mov    (%edx),%edx
  802d5d:	89 10                	mov    %edx,(%eax)
  802d5f:	eb 0a                	jmp    802d6b <alloc_block_NF+0x163>
  802d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d64:	8b 00                	mov    (%eax),%eax
  802d66:	a3 48 51 80 00       	mov    %eax,0x805148
  802d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7e:	a1 54 51 80 00       	mov    0x805154,%eax
  802d83:	48                   	dec    %eax
  802d84:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8c:	8b 40 08             	mov    0x8(%eax),%eax
  802d8f:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	8b 50 08             	mov    0x8(%eax),%edx
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	01 c2                	add    %eax,%edx
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 40 0c             	mov    0xc(%eax),%eax
  802dab:	2b 45 08             	sub    0x8(%ebp),%eax
  802dae:	89 c2                	mov    %eax,%edx
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db9:	e9 15 04 00 00       	jmp    8031d3 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802dbe:	a1 40 51 80 00       	mov    0x805140,%eax
  802dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dca:	74 07                	je     802dd3 <alloc_block_NF+0x1cb>
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 00                	mov    (%eax),%eax
  802dd1:	eb 05                	jmp    802dd8 <alloc_block_NF+0x1d0>
  802dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd8:	a3 40 51 80 00       	mov    %eax,0x805140
  802ddd:	a1 40 51 80 00       	mov    0x805140,%eax
  802de2:	85 c0                	test   %eax,%eax
  802de4:	0f 85 3e fe ff ff    	jne    802c28 <alloc_block_NF+0x20>
  802dea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dee:	0f 85 34 fe ff ff    	jne    802c28 <alloc_block_NF+0x20>
  802df4:	e9 d5 03 00 00       	jmp    8031ce <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802df9:	a1 38 51 80 00       	mov    0x805138,%eax
  802dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e01:	e9 b1 01 00 00       	jmp    802fb7 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	8b 50 08             	mov    0x8(%eax),%edx
  802e0c:	a1 28 50 80 00       	mov    0x805028,%eax
  802e11:	39 c2                	cmp    %eax,%edx
  802e13:	0f 82 96 01 00 00    	jb     802faf <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e22:	0f 82 87 01 00 00    	jb     802faf <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e31:	0f 85 95 00 00 00    	jne    802ecc <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e3b:	75 17                	jne    802e54 <alloc_block_NF+0x24c>
  802e3d:	83 ec 04             	sub    $0x4,%esp
  802e40:	68 24 45 80 00       	push   $0x804524
  802e45:	68 fc 00 00 00       	push   $0xfc
  802e4a:	68 7b 44 80 00       	push   $0x80447b
  802e4f:	e8 68 d9 ff ff       	call   8007bc <_panic>
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 00                	mov    (%eax),%eax
  802e59:	85 c0                	test   %eax,%eax
  802e5b:	74 10                	je     802e6d <alloc_block_NF+0x265>
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 00                	mov    (%eax),%eax
  802e62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e65:	8b 52 04             	mov    0x4(%edx),%edx
  802e68:	89 50 04             	mov    %edx,0x4(%eax)
  802e6b:	eb 0b                	jmp    802e78 <alloc_block_NF+0x270>
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	8b 40 04             	mov    0x4(%eax),%eax
  802e73:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7b:	8b 40 04             	mov    0x4(%eax),%eax
  802e7e:	85 c0                	test   %eax,%eax
  802e80:	74 0f                	je     802e91 <alloc_block_NF+0x289>
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 40 04             	mov    0x4(%eax),%eax
  802e88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e8b:	8b 12                	mov    (%edx),%edx
  802e8d:	89 10                	mov    %edx,(%eax)
  802e8f:	eb 0a                	jmp    802e9b <alloc_block_NF+0x293>
  802e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e94:	8b 00                	mov    (%eax),%eax
  802e96:	a3 38 51 80 00       	mov    %eax,0x805138
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eae:	a1 44 51 80 00       	mov    0x805144,%eax
  802eb3:	48                   	dec    %eax
  802eb4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	8b 40 08             	mov    0x8(%eax),%eax
  802ebf:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	e9 07 03 00 00       	jmp    8031d3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed5:	0f 86 d4 00 00 00    	jbe    802faf <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802edb:	a1 48 51 80 00       	mov    0x805148,%eax
  802ee0:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	8b 50 08             	mov    0x8(%eax),%edx
  802ee9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eec:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802eef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ef8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802efc:	75 17                	jne    802f15 <alloc_block_NF+0x30d>
  802efe:	83 ec 04             	sub    $0x4,%esp
  802f01:	68 24 45 80 00       	push   $0x804524
  802f06:	68 04 01 00 00       	push   $0x104
  802f0b:	68 7b 44 80 00       	push   $0x80447b
  802f10:	e8 a7 d8 ff ff       	call   8007bc <_panic>
  802f15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f18:	8b 00                	mov    (%eax),%eax
  802f1a:	85 c0                	test   %eax,%eax
  802f1c:	74 10                	je     802f2e <alloc_block_NF+0x326>
  802f1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f21:	8b 00                	mov    (%eax),%eax
  802f23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f26:	8b 52 04             	mov    0x4(%edx),%edx
  802f29:	89 50 04             	mov    %edx,0x4(%eax)
  802f2c:	eb 0b                	jmp    802f39 <alloc_block_NF+0x331>
  802f2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f31:	8b 40 04             	mov    0x4(%eax),%eax
  802f34:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3c:	8b 40 04             	mov    0x4(%eax),%eax
  802f3f:	85 c0                	test   %eax,%eax
  802f41:	74 0f                	je     802f52 <alloc_block_NF+0x34a>
  802f43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f46:	8b 40 04             	mov    0x4(%eax),%eax
  802f49:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f4c:	8b 12                	mov    (%edx),%edx
  802f4e:	89 10                	mov    %edx,(%eax)
  802f50:	eb 0a                	jmp    802f5c <alloc_block_NF+0x354>
  802f52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f55:	8b 00                	mov    (%eax),%eax
  802f57:	a3 48 51 80 00       	mov    %eax,0x805148
  802f5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6f:	a1 54 51 80 00       	mov    0x805154,%eax
  802f74:	48                   	dec    %eax
  802f75:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7d:	8b 40 08             	mov    0x8(%eax),%eax
  802f80:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	8b 50 08             	mov    0x8(%eax),%edx
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	01 c2                	add    %eax,%edx
  802f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f93:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9c:	2b 45 08             	sub    0x8(%ebp),%eax
  802f9f:	89 c2                	mov    %eax,%edx
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802fa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faa:	e9 24 02 00 00       	jmp    8031d3 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802faf:	a1 40 51 80 00       	mov    0x805140,%eax
  802fb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fbb:	74 07                	je     802fc4 <alloc_block_NF+0x3bc>
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	8b 00                	mov    (%eax),%eax
  802fc2:	eb 05                	jmp    802fc9 <alloc_block_NF+0x3c1>
  802fc4:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc9:	a3 40 51 80 00       	mov    %eax,0x805140
  802fce:	a1 40 51 80 00       	mov    0x805140,%eax
  802fd3:	85 c0                	test   %eax,%eax
  802fd5:	0f 85 2b fe ff ff    	jne    802e06 <alloc_block_NF+0x1fe>
  802fdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fdf:	0f 85 21 fe ff ff    	jne    802e06 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fe5:	a1 38 51 80 00       	mov    0x805138,%eax
  802fea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fed:	e9 ae 01 00 00       	jmp    8031a0 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	8b 50 08             	mov    0x8(%eax),%edx
  802ff8:	a1 28 50 80 00       	mov    0x805028,%eax
  802ffd:	39 c2                	cmp    %eax,%edx
  802fff:	0f 83 93 01 00 00    	jae    803198 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 40 0c             	mov    0xc(%eax),%eax
  80300b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80300e:	0f 82 84 01 00 00    	jb     803198 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	8b 40 0c             	mov    0xc(%eax),%eax
  80301a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80301d:	0f 85 95 00 00 00    	jne    8030b8 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803023:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803027:	75 17                	jne    803040 <alloc_block_NF+0x438>
  803029:	83 ec 04             	sub    $0x4,%esp
  80302c:	68 24 45 80 00       	push   $0x804524
  803031:	68 14 01 00 00       	push   $0x114
  803036:	68 7b 44 80 00       	push   $0x80447b
  80303b:	e8 7c d7 ff ff       	call   8007bc <_panic>
  803040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	85 c0                	test   %eax,%eax
  803047:	74 10                	je     803059 <alloc_block_NF+0x451>
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803051:	8b 52 04             	mov    0x4(%edx),%edx
  803054:	89 50 04             	mov    %edx,0x4(%eax)
  803057:	eb 0b                	jmp    803064 <alloc_block_NF+0x45c>
  803059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305c:	8b 40 04             	mov    0x4(%eax),%eax
  80305f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803067:	8b 40 04             	mov    0x4(%eax),%eax
  80306a:	85 c0                	test   %eax,%eax
  80306c:	74 0f                	je     80307d <alloc_block_NF+0x475>
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	8b 40 04             	mov    0x4(%eax),%eax
  803074:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803077:	8b 12                	mov    (%edx),%edx
  803079:	89 10                	mov    %edx,(%eax)
  80307b:	eb 0a                	jmp    803087 <alloc_block_NF+0x47f>
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	8b 00                	mov    (%eax),%eax
  803082:	a3 38 51 80 00       	mov    %eax,0x805138
  803087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803093:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309a:	a1 44 51 80 00       	mov    0x805144,%eax
  80309f:	48                   	dec    %eax
  8030a0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	8b 40 08             	mov    0x8(%eax),%eax
  8030ab:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8030b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b3:	e9 1b 01 00 00       	jmp    8031d3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8030b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8030be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030c1:	0f 86 d1 00 00 00    	jbe    803198 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030c7:	a1 48 51 80 00       	mov    0x805148,%eax
  8030cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8030cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d2:	8b 50 08             	mov    0x8(%eax),%edx
  8030d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030de:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030e8:	75 17                	jne    803101 <alloc_block_NF+0x4f9>
  8030ea:	83 ec 04             	sub    $0x4,%esp
  8030ed:	68 24 45 80 00       	push   $0x804524
  8030f2:	68 1c 01 00 00       	push   $0x11c
  8030f7:	68 7b 44 80 00       	push   $0x80447b
  8030fc:	e8 bb d6 ff ff       	call   8007bc <_panic>
  803101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803104:	8b 00                	mov    (%eax),%eax
  803106:	85 c0                	test   %eax,%eax
  803108:	74 10                	je     80311a <alloc_block_NF+0x512>
  80310a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310d:	8b 00                	mov    (%eax),%eax
  80310f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803112:	8b 52 04             	mov    0x4(%edx),%edx
  803115:	89 50 04             	mov    %edx,0x4(%eax)
  803118:	eb 0b                	jmp    803125 <alloc_block_NF+0x51d>
  80311a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311d:	8b 40 04             	mov    0x4(%eax),%eax
  803120:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803125:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803128:	8b 40 04             	mov    0x4(%eax),%eax
  80312b:	85 c0                	test   %eax,%eax
  80312d:	74 0f                	je     80313e <alloc_block_NF+0x536>
  80312f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803132:	8b 40 04             	mov    0x4(%eax),%eax
  803135:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803138:	8b 12                	mov    (%edx),%edx
  80313a:	89 10                	mov    %edx,(%eax)
  80313c:	eb 0a                	jmp    803148 <alloc_block_NF+0x540>
  80313e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803141:	8b 00                	mov    (%eax),%eax
  803143:	a3 48 51 80 00       	mov    %eax,0x805148
  803148:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80314b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803151:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803154:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315b:	a1 54 51 80 00       	mov    0x805154,%eax
  803160:	48                   	dec    %eax
  803161:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803169:	8b 40 08             	mov    0x8(%eax),%eax
  80316c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	8b 50 08             	mov    0x8(%eax),%edx
  803177:	8b 45 08             	mov    0x8(%ebp),%eax
  80317a:	01 c2                	add    %eax,%edx
  80317c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803185:	8b 40 0c             	mov    0xc(%eax),%eax
  803188:	2b 45 08             	sub    0x8(%ebp),%eax
  80318b:	89 c2                	mov    %eax,%edx
  80318d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803190:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803193:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803196:	eb 3b                	jmp    8031d3 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803198:	a1 40 51 80 00       	mov    0x805140,%eax
  80319d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a4:	74 07                	je     8031ad <alloc_block_NF+0x5a5>
  8031a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a9:	8b 00                	mov    (%eax),%eax
  8031ab:	eb 05                	jmp    8031b2 <alloc_block_NF+0x5aa>
  8031ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b2:	a3 40 51 80 00       	mov    %eax,0x805140
  8031b7:	a1 40 51 80 00       	mov    0x805140,%eax
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	0f 85 2e fe ff ff    	jne    802ff2 <alloc_block_NF+0x3ea>
  8031c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c8:	0f 85 24 fe ff ff    	jne    802ff2 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8031ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031d3:	c9                   	leave  
  8031d4:	c3                   	ret    

008031d5 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8031d5:	55                   	push   %ebp
  8031d6:	89 e5                	mov    %esp,%ebp
  8031d8:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8031db:	a1 38 51 80 00       	mov    0x805138,%eax
  8031e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8031e3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031e8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8031eb:	a1 38 51 80 00       	mov    0x805138,%eax
  8031f0:	85 c0                	test   %eax,%eax
  8031f2:	74 14                	je     803208 <insert_sorted_with_merge_freeList+0x33>
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	8b 50 08             	mov    0x8(%eax),%edx
  8031fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fd:	8b 40 08             	mov    0x8(%eax),%eax
  803200:	39 c2                	cmp    %eax,%edx
  803202:	0f 87 9b 01 00 00    	ja     8033a3 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803208:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80320c:	75 17                	jne    803225 <insert_sorted_with_merge_freeList+0x50>
  80320e:	83 ec 04             	sub    $0x4,%esp
  803211:	68 58 44 80 00       	push   $0x804458
  803216:	68 38 01 00 00       	push   $0x138
  80321b:	68 7b 44 80 00       	push   $0x80447b
  803220:	e8 97 d5 ff ff       	call   8007bc <_panic>
  803225:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80322b:	8b 45 08             	mov    0x8(%ebp),%eax
  80322e:	89 10                	mov    %edx,(%eax)
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	8b 00                	mov    (%eax),%eax
  803235:	85 c0                	test   %eax,%eax
  803237:	74 0d                	je     803246 <insert_sorted_with_merge_freeList+0x71>
  803239:	a1 38 51 80 00       	mov    0x805138,%eax
  80323e:	8b 55 08             	mov    0x8(%ebp),%edx
  803241:	89 50 04             	mov    %edx,0x4(%eax)
  803244:	eb 08                	jmp    80324e <insert_sorted_with_merge_freeList+0x79>
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80324e:	8b 45 08             	mov    0x8(%ebp),%eax
  803251:	a3 38 51 80 00       	mov    %eax,0x805138
  803256:	8b 45 08             	mov    0x8(%ebp),%eax
  803259:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803260:	a1 44 51 80 00       	mov    0x805144,%eax
  803265:	40                   	inc    %eax
  803266:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80326b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80326f:	0f 84 a8 06 00 00    	je     80391d <insert_sorted_with_merge_freeList+0x748>
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	8b 50 08             	mov    0x8(%eax),%edx
  80327b:	8b 45 08             	mov    0x8(%ebp),%eax
  80327e:	8b 40 0c             	mov    0xc(%eax),%eax
  803281:	01 c2                	add    %eax,%edx
  803283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803286:	8b 40 08             	mov    0x8(%eax),%eax
  803289:	39 c2                	cmp    %eax,%edx
  80328b:	0f 85 8c 06 00 00    	jne    80391d <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803291:	8b 45 08             	mov    0x8(%ebp),%eax
  803294:	8b 50 0c             	mov    0xc(%eax),%edx
  803297:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329a:	8b 40 0c             	mov    0xc(%eax),%eax
  80329d:	01 c2                	add    %eax,%edx
  80329f:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a2:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8032a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032a9:	75 17                	jne    8032c2 <insert_sorted_with_merge_freeList+0xed>
  8032ab:	83 ec 04             	sub    $0x4,%esp
  8032ae:	68 24 45 80 00       	push   $0x804524
  8032b3:	68 3c 01 00 00       	push   $0x13c
  8032b8:	68 7b 44 80 00       	push   $0x80447b
  8032bd:	e8 fa d4 ff ff       	call   8007bc <_panic>
  8032c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c5:	8b 00                	mov    (%eax),%eax
  8032c7:	85 c0                	test   %eax,%eax
  8032c9:	74 10                	je     8032db <insert_sorted_with_merge_freeList+0x106>
  8032cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ce:	8b 00                	mov    (%eax),%eax
  8032d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032d3:	8b 52 04             	mov    0x4(%edx),%edx
  8032d6:	89 50 04             	mov    %edx,0x4(%eax)
  8032d9:	eb 0b                	jmp    8032e6 <insert_sorted_with_merge_freeList+0x111>
  8032db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032de:	8b 40 04             	mov    0x4(%eax),%eax
  8032e1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e9:	8b 40 04             	mov    0x4(%eax),%eax
  8032ec:	85 c0                	test   %eax,%eax
  8032ee:	74 0f                	je     8032ff <insert_sorted_with_merge_freeList+0x12a>
  8032f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f3:	8b 40 04             	mov    0x4(%eax),%eax
  8032f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032f9:	8b 12                	mov    (%edx),%edx
  8032fb:	89 10                	mov    %edx,(%eax)
  8032fd:	eb 0a                	jmp    803309 <insert_sorted_with_merge_freeList+0x134>
  8032ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803302:	8b 00                	mov    (%eax),%eax
  803304:	a3 38 51 80 00       	mov    %eax,0x805138
  803309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803312:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803315:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80331c:	a1 44 51 80 00       	mov    0x805144,%eax
  803321:	48                   	dec    %eax
  803322:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803334:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80333b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80333f:	75 17                	jne    803358 <insert_sorted_with_merge_freeList+0x183>
  803341:	83 ec 04             	sub    $0x4,%esp
  803344:	68 58 44 80 00       	push   $0x804458
  803349:	68 3f 01 00 00       	push   $0x13f
  80334e:	68 7b 44 80 00       	push   $0x80447b
  803353:	e8 64 d4 ff ff       	call   8007bc <_panic>
  803358:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80335e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803361:	89 10                	mov    %edx,(%eax)
  803363:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803366:	8b 00                	mov    (%eax),%eax
  803368:	85 c0                	test   %eax,%eax
  80336a:	74 0d                	je     803379 <insert_sorted_with_merge_freeList+0x1a4>
  80336c:	a1 48 51 80 00       	mov    0x805148,%eax
  803371:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803374:	89 50 04             	mov    %edx,0x4(%eax)
  803377:	eb 08                	jmp    803381 <insert_sorted_with_merge_freeList+0x1ac>
  803379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803384:	a3 48 51 80 00       	mov    %eax,0x805148
  803389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803393:	a1 54 51 80 00       	mov    0x805154,%eax
  803398:	40                   	inc    %eax
  803399:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80339e:	e9 7a 05 00 00       	jmp    80391d <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8033a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a6:	8b 50 08             	mov    0x8(%eax),%edx
  8033a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ac:	8b 40 08             	mov    0x8(%eax),%eax
  8033af:	39 c2                	cmp    %eax,%edx
  8033b1:	0f 82 14 01 00 00    	jb     8034cb <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8033b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ba:	8b 50 08             	mov    0x8(%eax),%edx
  8033bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c3:	01 c2                	add    %eax,%edx
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	8b 40 08             	mov    0x8(%eax),%eax
  8033cb:	39 c2                	cmp    %eax,%edx
  8033cd:	0f 85 90 00 00 00    	jne    803463 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8033d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033df:	01 c2                	add    %eax,%edx
  8033e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e4:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8033e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8033fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ff:	75 17                	jne    803418 <insert_sorted_with_merge_freeList+0x243>
  803401:	83 ec 04             	sub    $0x4,%esp
  803404:	68 58 44 80 00       	push   $0x804458
  803409:	68 49 01 00 00       	push   $0x149
  80340e:	68 7b 44 80 00       	push   $0x80447b
  803413:	e8 a4 d3 ff ff       	call   8007bc <_panic>
  803418:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	89 10                	mov    %edx,(%eax)
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	8b 00                	mov    (%eax),%eax
  803428:	85 c0                	test   %eax,%eax
  80342a:	74 0d                	je     803439 <insert_sorted_with_merge_freeList+0x264>
  80342c:	a1 48 51 80 00       	mov    0x805148,%eax
  803431:	8b 55 08             	mov    0x8(%ebp),%edx
  803434:	89 50 04             	mov    %edx,0x4(%eax)
  803437:	eb 08                	jmp    803441 <insert_sorted_with_merge_freeList+0x26c>
  803439:	8b 45 08             	mov    0x8(%ebp),%eax
  80343c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	a3 48 51 80 00       	mov    %eax,0x805148
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803453:	a1 54 51 80 00       	mov    0x805154,%eax
  803458:	40                   	inc    %eax
  803459:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80345e:	e9 bb 04 00 00       	jmp    80391e <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803463:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803467:	75 17                	jne    803480 <insert_sorted_with_merge_freeList+0x2ab>
  803469:	83 ec 04             	sub    $0x4,%esp
  80346c:	68 cc 44 80 00       	push   $0x8044cc
  803471:	68 4c 01 00 00       	push   $0x14c
  803476:	68 7b 44 80 00       	push   $0x80447b
  80347b:	e8 3c d3 ff ff       	call   8007bc <_panic>
  803480:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	89 50 04             	mov    %edx,0x4(%eax)
  80348c:	8b 45 08             	mov    0x8(%ebp),%eax
  80348f:	8b 40 04             	mov    0x4(%eax),%eax
  803492:	85 c0                	test   %eax,%eax
  803494:	74 0c                	je     8034a2 <insert_sorted_with_merge_freeList+0x2cd>
  803496:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80349b:	8b 55 08             	mov    0x8(%ebp),%edx
  80349e:	89 10                	mov    %edx,(%eax)
  8034a0:	eb 08                	jmp    8034aa <insert_sorted_with_merge_freeList+0x2d5>
  8034a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a5:	a3 38 51 80 00       	mov    %eax,0x805138
  8034aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ad:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8034c0:	40                   	inc    %eax
  8034c1:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034c6:	e9 53 04 00 00       	jmp    80391e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034cb:	a1 38 51 80 00       	mov    0x805138,%eax
  8034d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034d3:	e9 15 04 00 00       	jmp    8038ed <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8034d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034db:	8b 00                	mov    (%eax),%eax
  8034dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8034e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e3:	8b 50 08             	mov    0x8(%eax),%edx
  8034e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e9:	8b 40 08             	mov    0x8(%eax),%eax
  8034ec:	39 c2                	cmp    %eax,%edx
  8034ee:	0f 86 f1 03 00 00    	jbe    8038e5 <insert_sorted_with_merge_freeList+0x710>
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	8b 50 08             	mov    0x8(%eax),%edx
  8034fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fd:	8b 40 08             	mov    0x8(%eax),%eax
  803500:	39 c2                	cmp    %eax,%edx
  803502:	0f 83 dd 03 00 00    	jae    8038e5 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350b:	8b 50 08             	mov    0x8(%eax),%edx
  80350e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803511:	8b 40 0c             	mov    0xc(%eax),%eax
  803514:	01 c2                	add    %eax,%edx
  803516:	8b 45 08             	mov    0x8(%ebp),%eax
  803519:	8b 40 08             	mov    0x8(%eax),%eax
  80351c:	39 c2                	cmp    %eax,%edx
  80351e:	0f 85 b9 01 00 00    	jne    8036dd <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803524:	8b 45 08             	mov    0x8(%ebp),%eax
  803527:	8b 50 08             	mov    0x8(%eax),%edx
  80352a:	8b 45 08             	mov    0x8(%ebp),%eax
  80352d:	8b 40 0c             	mov    0xc(%eax),%eax
  803530:	01 c2                	add    %eax,%edx
  803532:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803535:	8b 40 08             	mov    0x8(%eax),%eax
  803538:	39 c2                	cmp    %eax,%edx
  80353a:	0f 85 0d 01 00 00    	jne    80364d <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803543:	8b 50 0c             	mov    0xc(%eax),%edx
  803546:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803549:	8b 40 0c             	mov    0xc(%eax),%eax
  80354c:	01 c2                	add    %eax,%edx
  80354e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803551:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803554:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803558:	75 17                	jne    803571 <insert_sorted_with_merge_freeList+0x39c>
  80355a:	83 ec 04             	sub    $0x4,%esp
  80355d:	68 24 45 80 00       	push   $0x804524
  803562:	68 5c 01 00 00       	push   $0x15c
  803567:	68 7b 44 80 00       	push   $0x80447b
  80356c:	e8 4b d2 ff ff       	call   8007bc <_panic>
  803571:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803574:	8b 00                	mov    (%eax),%eax
  803576:	85 c0                	test   %eax,%eax
  803578:	74 10                	je     80358a <insert_sorted_with_merge_freeList+0x3b5>
  80357a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357d:	8b 00                	mov    (%eax),%eax
  80357f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803582:	8b 52 04             	mov    0x4(%edx),%edx
  803585:	89 50 04             	mov    %edx,0x4(%eax)
  803588:	eb 0b                	jmp    803595 <insert_sorted_with_merge_freeList+0x3c0>
  80358a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358d:	8b 40 04             	mov    0x4(%eax),%eax
  803590:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803595:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803598:	8b 40 04             	mov    0x4(%eax),%eax
  80359b:	85 c0                	test   %eax,%eax
  80359d:	74 0f                	je     8035ae <insert_sorted_with_merge_freeList+0x3d9>
  80359f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a2:	8b 40 04             	mov    0x4(%eax),%eax
  8035a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035a8:	8b 12                	mov    (%edx),%edx
  8035aa:	89 10                	mov    %edx,(%eax)
  8035ac:	eb 0a                	jmp    8035b8 <insert_sorted_with_merge_freeList+0x3e3>
  8035ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b1:	8b 00                	mov    (%eax),%eax
  8035b3:	a3 38 51 80 00       	mov    %eax,0x805138
  8035b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035cb:	a1 44 51 80 00       	mov    0x805144,%eax
  8035d0:	48                   	dec    %eax
  8035d1:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8035d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8035e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8035ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035ee:	75 17                	jne    803607 <insert_sorted_with_merge_freeList+0x432>
  8035f0:	83 ec 04             	sub    $0x4,%esp
  8035f3:	68 58 44 80 00       	push   $0x804458
  8035f8:	68 5f 01 00 00       	push   $0x15f
  8035fd:	68 7b 44 80 00       	push   $0x80447b
  803602:	e8 b5 d1 ff ff       	call   8007bc <_panic>
  803607:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80360d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803610:	89 10                	mov    %edx,(%eax)
  803612:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803615:	8b 00                	mov    (%eax),%eax
  803617:	85 c0                	test   %eax,%eax
  803619:	74 0d                	je     803628 <insert_sorted_with_merge_freeList+0x453>
  80361b:	a1 48 51 80 00       	mov    0x805148,%eax
  803620:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803623:	89 50 04             	mov    %edx,0x4(%eax)
  803626:	eb 08                	jmp    803630 <insert_sorted_with_merge_freeList+0x45b>
  803628:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803630:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803633:	a3 48 51 80 00       	mov    %eax,0x805148
  803638:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803642:	a1 54 51 80 00       	mov    0x805154,%eax
  803647:	40                   	inc    %eax
  803648:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80364d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803650:	8b 50 0c             	mov    0xc(%eax),%edx
  803653:	8b 45 08             	mov    0x8(%ebp),%eax
  803656:	8b 40 0c             	mov    0xc(%eax),%eax
  803659:	01 c2                	add    %eax,%edx
  80365b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803661:	8b 45 08             	mov    0x8(%ebp),%eax
  803664:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80366b:	8b 45 08             	mov    0x8(%ebp),%eax
  80366e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803675:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803679:	75 17                	jne    803692 <insert_sorted_with_merge_freeList+0x4bd>
  80367b:	83 ec 04             	sub    $0x4,%esp
  80367e:	68 58 44 80 00       	push   $0x804458
  803683:	68 64 01 00 00       	push   $0x164
  803688:	68 7b 44 80 00       	push   $0x80447b
  80368d:	e8 2a d1 ff ff       	call   8007bc <_panic>
  803692:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803698:	8b 45 08             	mov    0x8(%ebp),%eax
  80369b:	89 10                	mov    %edx,(%eax)
  80369d:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a0:	8b 00                	mov    (%eax),%eax
  8036a2:	85 c0                	test   %eax,%eax
  8036a4:	74 0d                	je     8036b3 <insert_sorted_with_merge_freeList+0x4de>
  8036a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8036ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ae:	89 50 04             	mov    %edx,0x4(%eax)
  8036b1:	eb 08                	jmp    8036bb <insert_sorted_with_merge_freeList+0x4e6>
  8036b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036be:	a3 48 51 80 00       	mov    %eax,0x805148
  8036c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036cd:	a1 54 51 80 00       	mov    0x805154,%eax
  8036d2:	40                   	inc    %eax
  8036d3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036d8:	e9 41 02 00 00       	jmp    80391e <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8036dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e0:	8b 50 08             	mov    0x8(%eax),%edx
  8036e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8036e9:	01 c2                	add    %eax,%edx
  8036eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ee:	8b 40 08             	mov    0x8(%eax),%eax
  8036f1:	39 c2                	cmp    %eax,%edx
  8036f3:	0f 85 7c 01 00 00    	jne    803875 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8036f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036fd:	74 06                	je     803705 <insert_sorted_with_merge_freeList+0x530>
  8036ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803703:	75 17                	jne    80371c <insert_sorted_with_merge_freeList+0x547>
  803705:	83 ec 04             	sub    $0x4,%esp
  803708:	68 94 44 80 00       	push   $0x804494
  80370d:	68 69 01 00 00       	push   $0x169
  803712:	68 7b 44 80 00       	push   $0x80447b
  803717:	e8 a0 d0 ff ff       	call   8007bc <_panic>
  80371c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80371f:	8b 50 04             	mov    0x4(%eax),%edx
  803722:	8b 45 08             	mov    0x8(%ebp),%eax
  803725:	89 50 04             	mov    %edx,0x4(%eax)
  803728:	8b 45 08             	mov    0x8(%ebp),%eax
  80372b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80372e:	89 10                	mov    %edx,(%eax)
  803730:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803733:	8b 40 04             	mov    0x4(%eax),%eax
  803736:	85 c0                	test   %eax,%eax
  803738:	74 0d                	je     803747 <insert_sorted_with_merge_freeList+0x572>
  80373a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373d:	8b 40 04             	mov    0x4(%eax),%eax
  803740:	8b 55 08             	mov    0x8(%ebp),%edx
  803743:	89 10                	mov    %edx,(%eax)
  803745:	eb 08                	jmp    80374f <insert_sorted_with_merge_freeList+0x57a>
  803747:	8b 45 08             	mov    0x8(%ebp),%eax
  80374a:	a3 38 51 80 00       	mov    %eax,0x805138
  80374f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803752:	8b 55 08             	mov    0x8(%ebp),%edx
  803755:	89 50 04             	mov    %edx,0x4(%eax)
  803758:	a1 44 51 80 00       	mov    0x805144,%eax
  80375d:	40                   	inc    %eax
  80375e:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803763:	8b 45 08             	mov    0x8(%ebp),%eax
  803766:	8b 50 0c             	mov    0xc(%eax),%edx
  803769:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376c:	8b 40 0c             	mov    0xc(%eax),%eax
  80376f:	01 c2                	add    %eax,%edx
  803771:	8b 45 08             	mov    0x8(%ebp),%eax
  803774:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803777:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80377b:	75 17                	jne    803794 <insert_sorted_with_merge_freeList+0x5bf>
  80377d:	83 ec 04             	sub    $0x4,%esp
  803780:	68 24 45 80 00       	push   $0x804524
  803785:	68 6b 01 00 00       	push   $0x16b
  80378a:	68 7b 44 80 00       	push   $0x80447b
  80378f:	e8 28 d0 ff ff       	call   8007bc <_panic>
  803794:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803797:	8b 00                	mov    (%eax),%eax
  803799:	85 c0                	test   %eax,%eax
  80379b:	74 10                	je     8037ad <insert_sorted_with_merge_freeList+0x5d8>
  80379d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a0:	8b 00                	mov    (%eax),%eax
  8037a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037a5:	8b 52 04             	mov    0x4(%edx),%edx
  8037a8:	89 50 04             	mov    %edx,0x4(%eax)
  8037ab:	eb 0b                	jmp    8037b8 <insert_sorted_with_merge_freeList+0x5e3>
  8037ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b0:	8b 40 04             	mov    0x4(%eax),%eax
  8037b3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037bb:	8b 40 04             	mov    0x4(%eax),%eax
  8037be:	85 c0                	test   %eax,%eax
  8037c0:	74 0f                	je     8037d1 <insert_sorted_with_merge_freeList+0x5fc>
  8037c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c5:	8b 40 04             	mov    0x4(%eax),%eax
  8037c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037cb:	8b 12                	mov    (%edx),%edx
  8037cd:	89 10                	mov    %edx,(%eax)
  8037cf:	eb 0a                	jmp    8037db <insert_sorted_with_merge_freeList+0x606>
  8037d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d4:	8b 00                	mov    (%eax),%eax
  8037d6:	a3 38 51 80 00       	mov    %eax,0x805138
  8037db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ee:	a1 44 51 80 00       	mov    0x805144,%eax
  8037f3:	48                   	dec    %eax
  8037f4:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8037f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037fc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803803:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803806:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80380d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803811:	75 17                	jne    80382a <insert_sorted_with_merge_freeList+0x655>
  803813:	83 ec 04             	sub    $0x4,%esp
  803816:	68 58 44 80 00       	push   $0x804458
  80381b:	68 6e 01 00 00       	push   $0x16e
  803820:	68 7b 44 80 00       	push   $0x80447b
  803825:	e8 92 cf ff ff       	call   8007bc <_panic>
  80382a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803830:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803833:	89 10                	mov    %edx,(%eax)
  803835:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803838:	8b 00                	mov    (%eax),%eax
  80383a:	85 c0                	test   %eax,%eax
  80383c:	74 0d                	je     80384b <insert_sorted_with_merge_freeList+0x676>
  80383e:	a1 48 51 80 00       	mov    0x805148,%eax
  803843:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803846:	89 50 04             	mov    %edx,0x4(%eax)
  803849:	eb 08                	jmp    803853 <insert_sorted_with_merge_freeList+0x67e>
  80384b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803853:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803856:	a3 48 51 80 00       	mov    %eax,0x805148
  80385b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803865:	a1 54 51 80 00       	mov    0x805154,%eax
  80386a:	40                   	inc    %eax
  80386b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803870:	e9 a9 00 00 00       	jmp    80391e <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803879:	74 06                	je     803881 <insert_sorted_with_merge_freeList+0x6ac>
  80387b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80387f:	75 17                	jne    803898 <insert_sorted_with_merge_freeList+0x6c3>
  803881:	83 ec 04             	sub    $0x4,%esp
  803884:	68 f0 44 80 00       	push   $0x8044f0
  803889:	68 73 01 00 00       	push   $0x173
  80388e:	68 7b 44 80 00       	push   $0x80447b
  803893:	e8 24 cf ff ff       	call   8007bc <_panic>
  803898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389b:	8b 10                	mov    (%eax),%edx
  80389d:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a0:	89 10                	mov    %edx,(%eax)
  8038a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a5:	8b 00                	mov    (%eax),%eax
  8038a7:	85 c0                	test   %eax,%eax
  8038a9:	74 0b                	je     8038b6 <insert_sorted_with_merge_freeList+0x6e1>
  8038ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ae:	8b 00                	mov    (%eax),%eax
  8038b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8038b3:	89 50 04             	mov    %edx,0x4(%eax)
  8038b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8038bc:	89 10                	mov    %edx,(%eax)
  8038be:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038c4:	89 50 04             	mov    %edx,0x4(%eax)
  8038c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ca:	8b 00                	mov    (%eax),%eax
  8038cc:	85 c0                	test   %eax,%eax
  8038ce:	75 08                	jne    8038d8 <insert_sorted_with_merge_freeList+0x703>
  8038d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038d8:	a1 44 51 80 00       	mov    0x805144,%eax
  8038dd:	40                   	inc    %eax
  8038de:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8038e3:	eb 39                	jmp    80391e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8038ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f1:	74 07                	je     8038fa <insert_sorted_with_merge_freeList+0x725>
  8038f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f6:	8b 00                	mov    (%eax),%eax
  8038f8:	eb 05                	jmp    8038ff <insert_sorted_with_merge_freeList+0x72a>
  8038fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ff:	a3 40 51 80 00       	mov    %eax,0x805140
  803904:	a1 40 51 80 00       	mov    0x805140,%eax
  803909:	85 c0                	test   %eax,%eax
  80390b:	0f 85 c7 fb ff ff    	jne    8034d8 <insert_sorted_with_merge_freeList+0x303>
  803911:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803915:	0f 85 bd fb ff ff    	jne    8034d8 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80391b:	eb 01                	jmp    80391e <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80391d:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80391e:	90                   	nop
  80391f:	c9                   	leave  
  803920:	c3                   	ret    
  803921:	66 90                	xchg   %ax,%ax
  803923:	90                   	nop

00803924 <__udivdi3>:
  803924:	55                   	push   %ebp
  803925:	57                   	push   %edi
  803926:	56                   	push   %esi
  803927:	53                   	push   %ebx
  803928:	83 ec 1c             	sub    $0x1c,%esp
  80392b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80392f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803933:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803937:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80393b:	89 ca                	mov    %ecx,%edx
  80393d:	89 f8                	mov    %edi,%eax
  80393f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803943:	85 f6                	test   %esi,%esi
  803945:	75 2d                	jne    803974 <__udivdi3+0x50>
  803947:	39 cf                	cmp    %ecx,%edi
  803949:	77 65                	ja     8039b0 <__udivdi3+0x8c>
  80394b:	89 fd                	mov    %edi,%ebp
  80394d:	85 ff                	test   %edi,%edi
  80394f:	75 0b                	jne    80395c <__udivdi3+0x38>
  803951:	b8 01 00 00 00       	mov    $0x1,%eax
  803956:	31 d2                	xor    %edx,%edx
  803958:	f7 f7                	div    %edi
  80395a:	89 c5                	mov    %eax,%ebp
  80395c:	31 d2                	xor    %edx,%edx
  80395e:	89 c8                	mov    %ecx,%eax
  803960:	f7 f5                	div    %ebp
  803962:	89 c1                	mov    %eax,%ecx
  803964:	89 d8                	mov    %ebx,%eax
  803966:	f7 f5                	div    %ebp
  803968:	89 cf                	mov    %ecx,%edi
  80396a:	89 fa                	mov    %edi,%edx
  80396c:	83 c4 1c             	add    $0x1c,%esp
  80396f:	5b                   	pop    %ebx
  803970:	5e                   	pop    %esi
  803971:	5f                   	pop    %edi
  803972:	5d                   	pop    %ebp
  803973:	c3                   	ret    
  803974:	39 ce                	cmp    %ecx,%esi
  803976:	77 28                	ja     8039a0 <__udivdi3+0x7c>
  803978:	0f bd fe             	bsr    %esi,%edi
  80397b:	83 f7 1f             	xor    $0x1f,%edi
  80397e:	75 40                	jne    8039c0 <__udivdi3+0x9c>
  803980:	39 ce                	cmp    %ecx,%esi
  803982:	72 0a                	jb     80398e <__udivdi3+0x6a>
  803984:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803988:	0f 87 9e 00 00 00    	ja     803a2c <__udivdi3+0x108>
  80398e:	b8 01 00 00 00       	mov    $0x1,%eax
  803993:	89 fa                	mov    %edi,%edx
  803995:	83 c4 1c             	add    $0x1c,%esp
  803998:	5b                   	pop    %ebx
  803999:	5e                   	pop    %esi
  80399a:	5f                   	pop    %edi
  80399b:	5d                   	pop    %ebp
  80399c:	c3                   	ret    
  80399d:	8d 76 00             	lea    0x0(%esi),%esi
  8039a0:	31 ff                	xor    %edi,%edi
  8039a2:	31 c0                	xor    %eax,%eax
  8039a4:	89 fa                	mov    %edi,%edx
  8039a6:	83 c4 1c             	add    $0x1c,%esp
  8039a9:	5b                   	pop    %ebx
  8039aa:	5e                   	pop    %esi
  8039ab:	5f                   	pop    %edi
  8039ac:	5d                   	pop    %ebp
  8039ad:	c3                   	ret    
  8039ae:	66 90                	xchg   %ax,%ax
  8039b0:	89 d8                	mov    %ebx,%eax
  8039b2:	f7 f7                	div    %edi
  8039b4:	31 ff                	xor    %edi,%edi
  8039b6:	89 fa                	mov    %edi,%edx
  8039b8:	83 c4 1c             	add    $0x1c,%esp
  8039bb:	5b                   	pop    %ebx
  8039bc:	5e                   	pop    %esi
  8039bd:	5f                   	pop    %edi
  8039be:	5d                   	pop    %ebp
  8039bf:	c3                   	ret    
  8039c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039c5:	89 eb                	mov    %ebp,%ebx
  8039c7:	29 fb                	sub    %edi,%ebx
  8039c9:	89 f9                	mov    %edi,%ecx
  8039cb:	d3 e6                	shl    %cl,%esi
  8039cd:	89 c5                	mov    %eax,%ebp
  8039cf:	88 d9                	mov    %bl,%cl
  8039d1:	d3 ed                	shr    %cl,%ebp
  8039d3:	89 e9                	mov    %ebp,%ecx
  8039d5:	09 f1                	or     %esi,%ecx
  8039d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039db:	89 f9                	mov    %edi,%ecx
  8039dd:	d3 e0                	shl    %cl,%eax
  8039df:	89 c5                	mov    %eax,%ebp
  8039e1:	89 d6                	mov    %edx,%esi
  8039e3:	88 d9                	mov    %bl,%cl
  8039e5:	d3 ee                	shr    %cl,%esi
  8039e7:	89 f9                	mov    %edi,%ecx
  8039e9:	d3 e2                	shl    %cl,%edx
  8039eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039ef:	88 d9                	mov    %bl,%cl
  8039f1:	d3 e8                	shr    %cl,%eax
  8039f3:	09 c2                	or     %eax,%edx
  8039f5:	89 d0                	mov    %edx,%eax
  8039f7:	89 f2                	mov    %esi,%edx
  8039f9:	f7 74 24 0c          	divl   0xc(%esp)
  8039fd:	89 d6                	mov    %edx,%esi
  8039ff:	89 c3                	mov    %eax,%ebx
  803a01:	f7 e5                	mul    %ebp
  803a03:	39 d6                	cmp    %edx,%esi
  803a05:	72 19                	jb     803a20 <__udivdi3+0xfc>
  803a07:	74 0b                	je     803a14 <__udivdi3+0xf0>
  803a09:	89 d8                	mov    %ebx,%eax
  803a0b:	31 ff                	xor    %edi,%edi
  803a0d:	e9 58 ff ff ff       	jmp    80396a <__udivdi3+0x46>
  803a12:	66 90                	xchg   %ax,%ax
  803a14:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a18:	89 f9                	mov    %edi,%ecx
  803a1a:	d3 e2                	shl    %cl,%edx
  803a1c:	39 c2                	cmp    %eax,%edx
  803a1e:	73 e9                	jae    803a09 <__udivdi3+0xe5>
  803a20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a23:	31 ff                	xor    %edi,%edi
  803a25:	e9 40 ff ff ff       	jmp    80396a <__udivdi3+0x46>
  803a2a:	66 90                	xchg   %ax,%ax
  803a2c:	31 c0                	xor    %eax,%eax
  803a2e:	e9 37 ff ff ff       	jmp    80396a <__udivdi3+0x46>
  803a33:	90                   	nop

00803a34 <__umoddi3>:
  803a34:	55                   	push   %ebp
  803a35:	57                   	push   %edi
  803a36:	56                   	push   %esi
  803a37:	53                   	push   %ebx
  803a38:	83 ec 1c             	sub    $0x1c,%esp
  803a3b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a3f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a47:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a4f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a53:	89 f3                	mov    %esi,%ebx
  803a55:	89 fa                	mov    %edi,%edx
  803a57:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a5b:	89 34 24             	mov    %esi,(%esp)
  803a5e:	85 c0                	test   %eax,%eax
  803a60:	75 1a                	jne    803a7c <__umoddi3+0x48>
  803a62:	39 f7                	cmp    %esi,%edi
  803a64:	0f 86 a2 00 00 00    	jbe    803b0c <__umoddi3+0xd8>
  803a6a:	89 c8                	mov    %ecx,%eax
  803a6c:	89 f2                	mov    %esi,%edx
  803a6e:	f7 f7                	div    %edi
  803a70:	89 d0                	mov    %edx,%eax
  803a72:	31 d2                	xor    %edx,%edx
  803a74:	83 c4 1c             	add    $0x1c,%esp
  803a77:	5b                   	pop    %ebx
  803a78:	5e                   	pop    %esi
  803a79:	5f                   	pop    %edi
  803a7a:	5d                   	pop    %ebp
  803a7b:	c3                   	ret    
  803a7c:	39 f0                	cmp    %esi,%eax
  803a7e:	0f 87 ac 00 00 00    	ja     803b30 <__umoddi3+0xfc>
  803a84:	0f bd e8             	bsr    %eax,%ebp
  803a87:	83 f5 1f             	xor    $0x1f,%ebp
  803a8a:	0f 84 ac 00 00 00    	je     803b3c <__umoddi3+0x108>
  803a90:	bf 20 00 00 00       	mov    $0x20,%edi
  803a95:	29 ef                	sub    %ebp,%edi
  803a97:	89 fe                	mov    %edi,%esi
  803a99:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a9d:	89 e9                	mov    %ebp,%ecx
  803a9f:	d3 e0                	shl    %cl,%eax
  803aa1:	89 d7                	mov    %edx,%edi
  803aa3:	89 f1                	mov    %esi,%ecx
  803aa5:	d3 ef                	shr    %cl,%edi
  803aa7:	09 c7                	or     %eax,%edi
  803aa9:	89 e9                	mov    %ebp,%ecx
  803aab:	d3 e2                	shl    %cl,%edx
  803aad:	89 14 24             	mov    %edx,(%esp)
  803ab0:	89 d8                	mov    %ebx,%eax
  803ab2:	d3 e0                	shl    %cl,%eax
  803ab4:	89 c2                	mov    %eax,%edx
  803ab6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aba:	d3 e0                	shl    %cl,%eax
  803abc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ac0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ac4:	89 f1                	mov    %esi,%ecx
  803ac6:	d3 e8                	shr    %cl,%eax
  803ac8:	09 d0                	or     %edx,%eax
  803aca:	d3 eb                	shr    %cl,%ebx
  803acc:	89 da                	mov    %ebx,%edx
  803ace:	f7 f7                	div    %edi
  803ad0:	89 d3                	mov    %edx,%ebx
  803ad2:	f7 24 24             	mull   (%esp)
  803ad5:	89 c6                	mov    %eax,%esi
  803ad7:	89 d1                	mov    %edx,%ecx
  803ad9:	39 d3                	cmp    %edx,%ebx
  803adb:	0f 82 87 00 00 00    	jb     803b68 <__umoddi3+0x134>
  803ae1:	0f 84 91 00 00 00    	je     803b78 <__umoddi3+0x144>
  803ae7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803aeb:	29 f2                	sub    %esi,%edx
  803aed:	19 cb                	sbb    %ecx,%ebx
  803aef:	89 d8                	mov    %ebx,%eax
  803af1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803af5:	d3 e0                	shl    %cl,%eax
  803af7:	89 e9                	mov    %ebp,%ecx
  803af9:	d3 ea                	shr    %cl,%edx
  803afb:	09 d0                	or     %edx,%eax
  803afd:	89 e9                	mov    %ebp,%ecx
  803aff:	d3 eb                	shr    %cl,%ebx
  803b01:	89 da                	mov    %ebx,%edx
  803b03:	83 c4 1c             	add    $0x1c,%esp
  803b06:	5b                   	pop    %ebx
  803b07:	5e                   	pop    %esi
  803b08:	5f                   	pop    %edi
  803b09:	5d                   	pop    %ebp
  803b0a:	c3                   	ret    
  803b0b:	90                   	nop
  803b0c:	89 fd                	mov    %edi,%ebp
  803b0e:	85 ff                	test   %edi,%edi
  803b10:	75 0b                	jne    803b1d <__umoddi3+0xe9>
  803b12:	b8 01 00 00 00       	mov    $0x1,%eax
  803b17:	31 d2                	xor    %edx,%edx
  803b19:	f7 f7                	div    %edi
  803b1b:	89 c5                	mov    %eax,%ebp
  803b1d:	89 f0                	mov    %esi,%eax
  803b1f:	31 d2                	xor    %edx,%edx
  803b21:	f7 f5                	div    %ebp
  803b23:	89 c8                	mov    %ecx,%eax
  803b25:	f7 f5                	div    %ebp
  803b27:	89 d0                	mov    %edx,%eax
  803b29:	e9 44 ff ff ff       	jmp    803a72 <__umoddi3+0x3e>
  803b2e:	66 90                	xchg   %ax,%ax
  803b30:	89 c8                	mov    %ecx,%eax
  803b32:	89 f2                	mov    %esi,%edx
  803b34:	83 c4 1c             	add    $0x1c,%esp
  803b37:	5b                   	pop    %ebx
  803b38:	5e                   	pop    %esi
  803b39:	5f                   	pop    %edi
  803b3a:	5d                   	pop    %ebp
  803b3b:	c3                   	ret    
  803b3c:	3b 04 24             	cmp    (%esp),%eax
  803b3f:	72 06                	jb     803b47 <__umoddi3+0x113>
  803b41:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b45:	77 0f                	ja     803b56 <__umoddi3+0x122>
  803b47:	89 f2                	mov    %esi,%edx
  803b49:	29 f9                	sub    %edi,%ecx
  803b4b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b4f:	89 14 24             	mov    %edx,(%esp)
  803b52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b56:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b5a:	8b 14 24             	mov    (%esp),%edx
  803b5d:	83 c4 1c             	add    $0x1c,%esp
  803b60:	5b                   	pop    %ebx
  803b61:	5e                   	pop    %esi
  803b62:	5f                   	pop    %edi
  803b63:	5d                   	pop    %ebp
  803b64:	c3                   	ret    
  803b65:	8d 76 00             	lea    0x0(%esi),%esi
  803b68:	2b 04 24             	sub    (%esp),%eax
  803b6b:	19 fa                	sbb    %edi,%edx
  803b6d:	89 d1                	mov    %edx,%ecx
  803b6f:	89 c6                	mov    %eax,%esi
  803b71:	e9 71 ff ff ff       	jmp    803ae7 <__umoddi3+0xb3>
  803b76:	66 90                	xchg   %ax,%ax
  803b78:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b7c:	72 ea                	jb     803b68 <__umoddi3+0x134>
  803b7e:	89 d9                	mov    %ebx,%ecx
  803b80:	e9 62 ff ff ff       	jmp    803ae7 <__umoddi3+0xb3>
