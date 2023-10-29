
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
  800045:	e8 e0 22 00 00       	call   80232a <sys_set_uheap_strategy>
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
  80009b:	68 40 3c 80 00       	push   $0x803c40
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 5c 3c 80 00       	push   $0x803c5c
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
  8000f5:	68 74 3c 80 00       	push   $0x803c74
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 5c 3c 80 00       	push   $0x803c5c
  800101:	e8 b6 06 00 00       	call   8007bc <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 0a 1d 00 00       	call   801e15 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 a2 1d 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
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
  80013a:	68 b8 3c 80 00       	push   $0x803cb8
  80013f:	6a 31                	push   $0x31
  800141:	68 5c 3c 80 00       	push   $0x803c5c
  800146:	e8 71 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014b:	e8 65 1d 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  800150:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 e8 3c 80 00       	push   $0x803ce8
  80015d:	6a 33                	push   $0x33
  80015f:	68 5c 3c 80 00       	push   $0x803c5c
  800164:	e8 53 06 00 00       	call   8007bc <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 a7 1c 00 00       	call   801e15 <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 3f 1d 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
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
  8001a6:	68 b8 3c 80 00       	push   $0x803cb8
  8001ab:	6a 39                	push   $0x39
  8001ad:	68 5c 3c 80 00       	push   $0x803c5c
  8001b2:	e8 05 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b7:	e8 f9 1c 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  8001bc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 e8 3c 80 00       	push   $0x803ce8
  8001c9:	6a 3b                	push   $0x3b
  8001cb:	68 5c 3c 80 00       	push   $0x803c5c
  8001d0:	e8 e7 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001d5:	e8 3b 1c 00 00       	call   801e15 <sys_calculate_free_frames>
  8001da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001dd:	e8 d3 1c 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
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
  800214:	68 b8 3c 80 00       	push   $0x803cb8
  800219:	6a 41                	push   $0x41
  80021b:	68 5c 3c 80 00       	push   $0x803c5c
  800220:	e8 97 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800225:	e8 8b 1c 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  80022a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 e8 3c 80 00       	push   $0x803ce8
  800237:	6a 43                	push   $0x43
  800239:	68 5c 3c 80 00       	push   $0x803c5c
  80023e:	e8 79 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  800243:	e8 cd 1b 00 00       	call   801e15 <sys_calculate_free_frames>
  800248:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80024b:	e8 65 1c 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
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
  80028c:	68 b8 3c 80 00       	push   $0x803cb8
  800291:	6a 49                	push   $0x49
  800293:	68 5c 3c 80 00       	push   $0x803c5c
  800298:	e8 1f 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80029d:	e8 13 1c 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  8002a2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a5:	74 14                	je     8002bb <_main+0x283>
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	68 e8 3c 80 00       	push   $0x803ce8
  8002af:	6a 4b                	push   $0x4b
  8002b1:	68 5c 3c 80 00       	push   $0x803c5c
  8002b6:	e8 01 05 00 00       	call   8007bc <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002bb:	e8 55 1b 00 00       	call   801e15 <sys_calculate_free_frames>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c3:	e8 ed 1b 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  8002c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002cb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	50                   	push   %eax
  8002d2:	e8 9c 17 00 00       	call   801a73 <free>
  8002d7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8002da:	e8 d6 1b 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  8002df:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002e2:	74 14                	je     8002f8 <_main+0x2c0>
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	68 05 3d 80 00       	push   $0x803d05
  8002ec:	6a 52                	push   $0x52
  8002ee:	68 5c 3c 80 00       	push   $0x803c5c
  8002f3:	e8 c4 04 00 00       	call   8007bc <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002f8:	e8 18 1b 00 00       	call   801e15 <sys_calculate_free_frames>
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800300:	e8 b0 1b 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
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
  800345:	68 b8 3c 80 00       	push   $0x803cb8
  80034a:	6a 58                	push   $0x58
  80034c:	68 5c 3c 80 00       	push   $0x803c5c
  800351:	e8 66 04 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800356:	e8 5a 1b 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  80035b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80035e:	74 14                	je     800374 <_main+0x33c>
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	68 e8 3c 80 00       	push   $0x803ce8
  800368:	6a 5a                	push   $0x5a
  80036a:	68 5c 3c 80 00       	push   $0x803c5c
  80036f:	e8 48 04 00 00       	call   8007bc <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800374:	e8 9c 1a 00 00       	call   801e15 <sys_calculate_free_frames>
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037c:	e8 34 1b 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800384:	8b 45 90             	mov    -0x70(%ebp),%eax
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	50                   	push   %eax
  80038b:	e8 e3 16 00 00       	call   801a73 <free>
  800390:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  800393:	e8 1d 1b 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  800398:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80039b:	74 14                	je     8003b1 <_main+0x379>
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 05 3d 80 00       	push   $0x803d05
  8003a5:	6a 61                	push   $0x61
  8003a7:	68 5c 3c 80 00       	push   $0x803c5c
  8003ac:	e8 0b 04 00 00       	call   8007bc <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003b1:	e8 5f 1a 00 00       	call   801e15 <sys_calculate_free_frames>
  8003b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003b9:	e8 f7 1a 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
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
  8003fd:	68 b8 3c 80 00       	push   $0x803cb8
  800402:	6a 67                	push   $0x67
  800404:	68 5c 3c 80 00       	push   $0x803c5c
  800409:	e8 ae 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80040e:	e8 a2 1a 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  800413:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800416:	74 14                	je     80042c <_main+0x3f4>
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	68 e8 3c 80 00       	push   $0x803ce8
  800420:	6a 69                	push   $0x69
  800422:	68 5c 3c 80 00       	push   $0x803c5c
  800427:	e8 90 03 00 00       	call   8007bc <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  80042c:	e8 e4 19 00 00       	call   801e15 <sys_calculate_free_frames>
  800431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800434:	e8 7c 1a 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
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
  800483:	68 b8 3c 80 00       	push   $0x803cb8
  800488:	6a 6f                	push   $0x6f
  80048a:	68 5c 3c 80 00       	push   $0x803c5c
  80048f:	e8 28 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800494:	e8 1c 1a 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  800499:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80049c:	74 14                	je     8004b2 <_main+0x47a>
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	68 e8 3c 80 00       	push   $0x803ce8
  8004a6:	6a 71                	push   $0x71
  8004a8:	68 5c 3c 80 00       	push   $0x803c5c
  8004ad:	e8 0a 03 00 00       	call   8007bc <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004b2:	e8 5e 19 00 00       	call   801e15 <sys_calculate_free_frames>
  8004b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004ba:	e8 f6 19 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  8004bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  8004c2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	50                   	push   %eax
  8004c9:	e8 a5 15 00 00       	call   801a73 <free>
  8004ce:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8004d1:	e8 df 19 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  8004d6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d9:	74 14                	je     8004ef <_main+0x4b7>
  8004db:	83 ec 04             	sub    $0x4,%esp
  8004de:	68 05 3d 80 00       	push   $0x803d05
  8004e3:	6a 78                	push   $0x78
  8004e5:	68 5c 3c 80 00       	push   $0x803c5c
  8004ea:	e8 cd 02 00 00       	call   8007bc <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 21 19 00 00       	call   801e15 <sys_calculate_free_frames>
  8004f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 b9 19 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8004ff:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	50                   	push   %eax
  800506:	e8 68 15 00 00       	call   801a73 <free>
  80050b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  80050e:	e8 a2 19 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  800513:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 05 3d 80 00       	push   $0x803d05
  800520:	6a 7f                	push   $0x7f
  800522:	68 5c 3c 80 00       	push   $0x803c5c
  800527:	e8 90 02 00 00       	call   8007bc <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 e4 18 00 00       	call   801e15 <sys_calculate_free_frames>
  800531:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800534:	e8 7c 19 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
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
  800583:	68 b8 3c 80 00       	push   $0x803cb8
  800588:	68 85 00 00 00       	push   $0x85
  80058d:	68 5c 3c 80 00       	push   $0x803c5c
  800592:	e8 25 02 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800597:	e8 19 19 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  80059c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059f:	74 17                	je     8005b8 <_main+0x580>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 e8 3c 80 00       	push   $0x803ce8
  8005a9:	68 87 00 00 00       	push   $0x87
  8005ae:	68 5c 3c 80 00       	push   $0x803c5c
  8005b3:	e8 04 02 00 00       	call   8007bc <_panic>
		//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8005b8:	e8 58 18 00 00       	call   801e15 <sys_calculate_free_frames>
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005c0:	e8 f0 18 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
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
  8005f0:	68 b8 3c 80 00       	push   $0x803cb8
  8005f5:	68 95 00 00 00       	push   $0x95
  8005fa:	68 5c 3c 80 00       	push   $0x803c5c
  8005ff:	e8 b8 01 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800604:	e8 ac 18 00 00       	call   801eb5 <sys_pf_calculate_allocated_pages>
  800609:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80060c:	74 17                	je     800625 <_main+0x5ed>
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	68 e8 3c 80 00       	push   $0x803ce8
  800616:	68 97 00 00 00       	push   $0x97
  80061b:	68 5c 3c 80 00       	push   $0x803c5c
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
  800654:	68 1c 3d 80 00       	push   $0x803d1c
  800659:	68 a0 00 00 00       	push   $0xa0
  80065e:	68 5c 3c 80 00       	push   $0x803c5c
  800663:	e8 54 01 00 00       	call   8007bc <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	68 80 3d 80 00       	push   $0x803d80
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
  800686:	e8 6a 1a 00 00       	call   8020f5 <sys_getenvindex>
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
  8006f1:	e8 0c 18 00 00       	call   801f02 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	68 e4 3d 80 00       	push   $0x803de4
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
  800721:	68 0c 3e 80 00       	push   $0x803e0c
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
  800752:	68 34 3e 80 00       	push   $0x803e34
  800757:	e8 14 03 00 00       	call   800a70 <cprintf>
  80075c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80075f:	a1 20 50 80 00       	mov    0x805020,%eax
  800764:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	50                   	push   %eax
  80076e:	68 8c 3e 80 00       	push   $0x803e8c
  800773:	e8 f8 02 00 00       	call   800a70 <cprintf>
  800778:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	68 e4 3d 80 00       	push   $0x803de4
  800783:	e8 e8 02 00 00       	call   800a70 <cprintf>
  800788:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80078b:	e8 8c 17 00 00       	call   801f1c <sys_enable_interrupt>

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
  8007a3:	e8 19 19 00 00       	call   8020c1 <sys_destroy_env>
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
  8007b4:	e8 6e 19 00 00       	call   802127 <sys_exit_env>
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
  8007dd:	68 a0 3e 80 00       	push   $0x803ea0
  8007e2:	e8 89 02 00 00       	call   800a70 <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ea:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	50                   	push   %eax
  8007f6:	68 a5 3e 80 00       	push   $0x803ea5
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
  80081a:	68 c1 3e 80 00       	push   $0x803ec1
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
  800846:	68 c4 3e 80 00       	push   $0x803ec4
  80084b:	6a 26                	push   $0x26
  80084d:	68 10 3f 80 00       	push   $0x803f10
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
  800918:	68 1c 3f 80 00       	push   $0x803f1c
  80091d:	6a 3a                	push   $0x3a
  80091f:	68 10 3f 80 00       	push   $0x803f10
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
  800988:	68 70 3f 80 00       	push   $0x803f70
  80098d:	6a 44                	push   $0x44
  80098f:	68 10 3f 80 00       	push   $0x803f10
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
  8009e2:	e8 6d 13 00 00       	call   801d54 <sys_cputs>
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
  800a59:	e8 f6 12 00 00       	call   801d54 <sys_cputs>
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
  800aa3:	e8 5a 14 00 00       	call   801f02 <sys_disable_interrupt>
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
  800ac3:	e8 54 14 00 00       	call   801f1c <sys_enable_interrupt>
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
  800b0d:	e8 c6 2e 00 00       	call   8039d8 <__udivdi3>
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
  800b5d:	e8 86 2f 00 00       	call   803ae8 <__umoddi3>
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	05 d4 41 80 00       	add    $0x8041d4,%eax
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
  800cb8:	8b 04 85 f8 41 80 00 	mov    0x8041f8(,%eax,4),%eax
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
  800d99:	8b 34 9d 40 40 80 00 	mov    0x804040(,%ebx,4),%esi
  800da0:	85 f6                	test   %esi,%esi
  800da2:	75 19                	jne    800dbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da4:	53                   	push   %ebx
  800da5:	68 e5 41 80 00       	push   $0x8041e5
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
  800dbe:	68 ee 41 80 00       	push   $0x8041ee
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
  800deb:	be f1 41 80 00       	mov    $0x8041f1,%esi
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
  801811:	68 50 43 80 00       	push   $0x804350
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
  8018e1:	e8 b2 05 00 00       	call   801e98 <sys_allocate_chunk>
  8018e6:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018e9:	a1 20 51 80 00       	mov    0x805120,%eax
  8018ee:	83 ec 0c             	sub    $0xc,%esp
  8018f1:	50                   	push   %eax
  8018f2:	e8 27 0c 00 00       	call   80251e <initialize_MemBlocksList>
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
  80191f:	68 75 43 80 00       	push   $0x804375
  801924:	6a 33                	push   $0x33
  801926:	68 93 43 80 00       	push   $0x804393
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
  80199e:	68 a0 43 80 00       	push   $0x8043a0
  8019a3:	6a 34                	push   $0x34
  8019a5:	68 93 43 80 00       	push   $0x804393
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
  801a36:	e8 2b 08 00 00       	call   802266 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	74 11                	je     801a50 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801a3f:	83 ec 0c             	sub    $0xc,%esp
  801a42:	ff 75 e8             	pushl  -0x18(%ebp)
  801a45:	e8 96 0e 00 00       	call   8028e0 <alloc_block_FF>
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
  801a5c:	e8 f2 0b 00 00       	call   802653 <insert_sorted_allocList>
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
  801a76:	83 ec 18             	sub    $0x18,%esp
<<<<<<< HEAD
=======
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	83 ec 08             	sub    $0x8,%esp
  801a7f:	50                   	push   %eax
  801a80:	68 40 50 80 00       	push   $0x805040
  801a85:	e8 71 0b 00 00       	call   8025fb <find_block>
  801a8a:	83 c4 10             	add    $0x10,%esp
  801a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801a90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a94:	0f 84 a6 00 00 00    	je     801b40 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9d:	8b 50 0c             	mov    0xc(%eax),%edx
  801aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa3:	8b 40 08             	mov    0x8(%eax),%eax
  801aa6:	83 ec 08             	sub    $0x8,%esp
  801aa9:	52                   	push   %edx
  801aaa:	50                   	push   %eax
  801aab:	e8 b0 03 00 00       	call   801e60 <sys_free_user_mem>
  801ab0:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801ab3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ab7:	75 14                	jne    801acd <free+0x5a>
  801ab9:	83 ec 04             	sub    $0x4,%esp
  801abc:	68 75 43 80 00       	push   $0x804375
  801ac1:	6a 74                	push   $0x74
  801ac3:	68 93 43 80 00       	push   $0x804393
  801ac8:	e8 ef ec ff ff       	call   8007bc <_panic>
  801acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad0:	8b 00                	mov    (%eax),%eax
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	74 10                	je     801ae6 <free+0x73>
  801ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad9:	8b 00                	mov    (%eax),%eax
  801adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ade:	8b 52 04             	mov    0x4(%edx),%edx
  801ae1:	89 50 04             	mov    %edx,0x4(%eax)
  801ae4:	eb 0b                	jmp    801af1 <free+0x7e>
  801ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae9:	8b 40 04             	mov    0x4(%eax),%eax
  801aec:	a3 44 50 80 00       	mov    %eax,0x805044
  801af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af4:	8b 40 04             	mov    0x4(%eax),%eax
  801af7:	85 c0                	test   %eax,%eax
  801af9:	74 0f                	je     801b0a <free+0x97>
  801afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afe:	8b 40 04             	mov    0x4(%eax),%eax
  801b01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b04:	8b 12                	mov    (%edx),%edx
  801b06:	89 10                	mov    %edx,(%eax)
  801b08:	eb 0a                	jmp    801b14 <free+0xa1>
  801b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0d:	8b 00                	mov    (%eax),%eax
  801b0f:	a3 40 50 80 00       	mov    %eax,0x805040
  801b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b27:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801b2c:	48                   	dec    %eax
  801b2d:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801b32:	83 ec 0c             	sub    $0xc,%esp
  801b35:	ff 75 f4             	pushl  -0xc(%ebp)
  801b38:	e8 4e 17 00 00       	call   80328b <insert_sorted_with_merge_freeList>
  801b3d:	83 c4 10             	add    $0x10,%esp
	}
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
<<<<<<< HEAD

	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	83 ec 08             	sub    $0x8,%esp
  801a7f:	50                   	push   %eax
  801a80:	68 40 50 80 00       	push   $0x805040
  801a85:	e8 71 0b 00 00       	call   8025fb <find_block>
  801a8a:	83 c4 10             	add    $0x10,%esp
  801a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if(free_block!=NULL)
  801a90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a94:	0f 84 a6 00 00 00    	je     801b40 <free+0xcd>
	    {
	    	sys_free_user_mem(free_block->sva,free_block->size);
  801a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9d:	8b 50 0c             	mov    0xc(%eax),%edx
  801aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa3:	8b 40 08             	mov    0x8(%eax),%eax
  801aa6:	83 ec 08             	sub    $0x8,%esp
  801aa9:	52                   	push   %edx
  801aaa:	50                   	push   %eax
  801aab:	e8 b0 03 00 00       	call   801e60 <sys_free_user_mem>
  801ab0:	83 c4 10             	add    $0x10,%esp
	    	LIST_REMOVE(&AllocMemBlocksList,free_block);
  801ab3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ab7:	75 14                	jne    801acd <free+0x5a>
  801ab9:	83 ec 04             	sub    $0x4,%esp
  801abc:	68 75 43 80 00       	push   $0x804375
  801ac1:	6a 7a                	push   $0x7a
  801ac3:	68 93 43 80 00       	push   $0x804393
  801ac8:	e8 ef ec ff ff       	call   8007bc <_panic>
  801acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad0:	8b 00                	mov    (%eax),%eax
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	74 10                	je     801ae6 <free+0x73>
  801ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad9:	8b 00                	mov    (%eax),%eax
  801adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ade:	8b 52 04             	mov    0x4(%edx),%edx
  801ae1:	89 50 04             	mov    %edx,0x4(%eax)
  801ae4:	eb 0b                	jmp    801af1 <free+0x7e>
  801ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae9:	8b 40 04             	mov    0x4(%eax),%eax
  801aec:	a3 44 50 80 00       	mov    %eax,0x805044
  801af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af4:	8b 40 04             	mov    0x4(%eax),%eax
  801af7:	85 c0                	test   %eax,%eax
  801af9:	74 0f                	je     801b0a <free+0x97>
  801afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afe:	8b 40 04             	mov    0x4(%eax),%eax
  801b01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b04:	8b 12                	mov    (%edx),%edx
  801b06:	89 10                	mov    %edx,(%eax)
  801b08:	eb 0a                	jmp    801b14 <free+0xa1>
  801b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0d:	8b 00                	mov    (%eax),%eax
  801b0f:	a3 40 50 80 00       	mov    %eax,0x805040
  801b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b27:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801b2c:	48                   	dec    %eax
  801b2d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	        insert_sorted_with_merge_freeList(free_block);
  801b32:	83 ec 0c             	sub    $0xc,%esp
  801b35:	ff 75 f4             	pushl  -0xc(%ebp)
  801b38:	e8 4e 17 00 00       	call   80328b <insert_sorted_with_merge_freeList>
  801b3d:	83 c4 10             	add    $0x10,%esp



	    }
=======
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
}
  801b40:	90                   	nop
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	83 ec 38             	sub    $0x38,%esp
  801b49:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b4f:	e8 a6 fc ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  801b54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b58:	75 0a                	jne    801b64 <smalloc+0x21>
  801b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5f:	e9 8b 00 00 00       	jmp    801bef <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801b64:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b71:	01 d0                	add    %edx,%eax
  801b73:	48                   	dec    %eax
  801b74:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b7f:	f7 75 f0             	divl   -0x10(%ebp)
  801b82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b85:	29 d0                	sub    %edx,%eax
  801b87:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801b8a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801b91:	e8 d0 06 00 00       	call   802266 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b96:	85 c0                	test   %eax,%eax
  801b98:	74 11                	je     801bab <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801b9a:	83 ec 0c             	sub    $0xc,%esp
  801b9d:	ff 75 e8             	pushl  -0x18(%ebp)
  801ba0:	e8 3b 0d 00 00       	call   8028e0 <alloc_block_FF>
  801ba5:	83 c4 10             	add    $0x10,%esp
  801ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801bab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801baf:	74 39                	je     801bea <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb4:	8b 40 08             	mov    0x8(%eax),%eax
  801bb7:	89 c2                	mov    %eax,%edx
  801bb9:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801bbd:	52                   	push   %edx
  801bbe:	50                   	push   %eax
  801bbf:	ff 75 0c             	pushl  0xc(%ebp)
  801bc2:	ff 75 08             	pushl  0x8(%ebp)
  801bc5:	e8 21 04 00 00       	call   801feb <sys_createSharedObject>
  801bca:	83 c4 10             	add    $0x10,%esp
  801bcd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801bd0:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801bd4:	74 14                	je     801bea <smalloc+0xa7>
  801bd6:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801bda:	74 0e                	je     801bea <smalloc+0xa7>
  801bdc:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801be0:	74 08                	je     801bea <smalloc+0xa7>
			return (void*) mem_block->sva;
  801be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be5:	8b 40 08             	mov    0x8(%eax),%eax
  801be8:	eb 05                	jmp    801bef <smalloc+0xac>
	}
	return NULL;
  801bea:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bf7:	e8 fe fb ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801bfc:	83 ec 08             	sub    $0x8,%esp
  801bff:	ff 75 0c             	pushl  0xc(%ebp)
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	e8 0b 04 00 00       	call   802015 <sys_getSizeOfSharedObject>
  801c0a:	83 c4 10             	add    $0x10,%esp
  801c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801c10:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801c14:	74 76                	je     801c8c <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801c16:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c23:	01 d0                	add    %edx,%eax
  801c25:	48                   	dec    %eax
  801c26:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c2c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c31:	f7 75 ec             	divl   -0x14(%ebp)
  801c34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c37:	29 d0                	sub    %edx,%eax
  801c39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801c3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801c43:	e8 1e 06 00 00       	call   802266 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c48:	85 c0                	test   %eax,%eax
  801c4a:	74 11                	je     801c5d <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801c4c:	83 ec 0c             	sub    $0xc,%esp
  801c4f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c52:	e8 89 0c 00 00       	call   8028e0 <alloc_block_FF>
  801c57:	83 c4 10             	add    $0x10,%esp
  801c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801c5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c61:	74 29                	je     801c8c <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c66:	8b 40 08             	mov    0x8(%eax),%eax
  801c69:	83 ec 04             	sub    $0x4,%esp
  801c6c:	50                   	push   %eax
  801c6d:	ff 75 0c             	pushl  0xc(%ebp)
  801c70:	ff 75 08             	pushl  0x8(%ebp)
  801c73:	e8 ba 03 00 00       	call   802032 <sys_getSharedObject>
  801c78:	83 c4 10             	add    $0x10,%esp
  801c7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801c7e:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801c82:	74 08                	je     801c8c <sget+0x9b>
				return (void *)mem_block->sva;
  801c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c87:	8b 40 08             	mov    0x8(%eax),%eax
  801c8a:	eb 05                	jmp    801c91 <sget+0xa0>
		}
	}
	return NULL;
  801c8c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c99:	e8 5c fb ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	68 c4 43 80 00       	push   $0x8043c4
<<<<<<< HEAD
  801ca6:	68 fc 00 00 00       	push   $0xfc
=======
  801ca6:	68 f7 00 00 00       	push   $0xf7
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801cab:	68 93 43 80 00       	push   $0x804393
  801cb0:	e8 07 eb ff ff       	call   8007bc <_panic>

00801cb5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	68 ec 43 80 00       	push   $0x8043ec
<<<<<<< HEAD
  801cc3:	68 10 01 00 00       	push   $0x110
=======
  801cc3:	68 0c 01 00 00       	push   $0x10c
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801cc8:	68 93 43 80 00       	push   $0x804393
  801ccd:	e8 ea ea ff ff       	call   8007bc <_panic>

00801cd2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cd8:	83 ec 04             	sub    $0x4,%esp
  801cdb:	68 10 44 80 00       	push   $0x804410
<<<<<<< HEAD
  801ce0:	68 1b 01 00 00       	push   $0x11b
=======
  801ce0:	68 44 01 00 00       	push   $0x144
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801ce5:	68 93 43 80 00       	push   $0x804393
  801cea:	e8 cd ea ff ff       	call   8007bc <_panic>

00801cef <shrink>:

}
void shrink(uint32 newSize)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cf5:	83 ec 04             	sub    $0x4,%esp
  801cf8:	68 10 44 80 00       	push   $0x804410
<<<<<<< HEAD
  801cfd:	68 20 01 00 00       	push   $0x120
=======
  801cfd:	68 49 01 00 00       	push   $0x149
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801d02:	68 93 43 80 00       	push   $0x804393
  801d07:	e8 b0 ea ff ff       	call   8007bc <_panic>

00801d0c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d12:	83 ec 04             	sub    $0x4,%esp
  801d15:	68 10 44 80 00       	push   $0x804410
<<<<<<< HEAD
  801d1a:	68 25 01 00 00       	push   $0x125
=======
  801d1a:	68 4e 01 00 00       	push   $0x14e
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801d1f:	68 93 43 80 00       	push   $0x804393
  801d24:	e8 93 ea ff ff       	call   8007bc <_panic>

00801d29 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	57                   	push   %edi
  801d2d:	56                   	push   %esi
  801d2e:	53                   	push   %ebx
  801d2f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d32:	8b 45 08             	mov    0x8(%ebp),%eax
  801d35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d3b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d3e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d41:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d44:	cd 30                	int    $0x30
  801d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d4c:	83 c4 10             	add    $0x10,%esp
  801d4f:	5b                   	pop    %ebx
  801d50:	5e                   	pop    %esi
  801d51:	5f                   	pop    %edi
  801d52:	5d                   	pop    %ebp
  801d53:	c3                   	ret    

00801d54 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 04             	sub    $0x4,%esp
  801d5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d60:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	52                   	push   %edx
  801d6c:	ff 75 0c             	pushl  0xc(%ebp)
  801d6f:	50                   	push   %eax
  801d70:	6a 00                	push   $0x0
  801d72:	e8 b2 ff ff ff       	call   801d29 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
}
  801d7a:	90                   	nop
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <sys_cgetc>:

int
sys_cgetc(void)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 01                	push   $0x1
  801d8c:	e8 98 ff ff ff       	call   801d29 <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	52                   	push   %edx
  801da6:	50                   	push   %eax
  801da7:	6a 05                	push   $0x5
  801da9:	e8 7b ff ff ff       	call   801d29 <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801db8:	8b 75 18             	mov    0x18(%ebp),%esi
  801dbb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dbe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	56                   	push   %esi
  801dc8:	53                   	push   %ebx
  801dc9:	51                   	push   %ecx
  801dca:	52                   	push   %edx
  801dcb:	50                   	push   %eax
  801dcc:	6a 06                	push   $0x6
  801dce:	e8 56 ff ff ff       	call   801d29 <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
}
  801dd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd9:	5b                   	pop    %ebx
  801dda:	5e                   	pop    %esi
  801ddb:	5d                   	pop    %ebp
  801ddc:	c3                   	ret    

00801ddd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de3:	8b 45 08             	mov    0x8(%ebp),%eax
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	52                   	push   %edx
  801ded:	50                   	push   %eax
  801dee:	6a 07                	push   $0x7
  801df0:	e8 34 ff ff ff       	call   801d29 <syscall>
  801df5:	83 c4 18             	add    $0x18,%esp
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	ff 75 0c             	pushl  0xc(%ebp)
  801e06:	ff 75 08             	pushl  0x8(%ebp)
  801e09:	6a 08                	push   $0x8
  801e0b:	e8 19 ff ff ff       	call   801d29 <syscall>
  801e10:	83 c4 18             	add    $0x18,%esp
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 09                	push   $0x9
  801e24:	e8 00 ff ff ff       	call   801d29 <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 0a                	push   $0xa
  801e3d:	e8 e7 fe ff ff       	call   801d29 <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 0b                	push   $0xb
  801e56:	e8 ce fe ff ff       	call   801d29 <syscall>
  801e5b:	83 c4 18             	add    $0x18,%esp
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	ff 75 0c             	pushl  0xc(%ebp)
  801e6c:	ff 75 08             	pushl  0x8(%ebp)
  801e6f:	6a 0f                	push   $0xf
  801e71:	e8 b3 fe ff ff       	call   801d29 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
	return;
  801e79:	90                   	nop
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	ff 75 0c             	pushl  0xc(%ebp)
  801e88:	ff 75 08             	pushl  0x8(%ebp)
  801e8b:	6a 10                	push   $0x10
  801e8d:	e8 97 fe ff ff       	call   801d29 <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
	return ;
  801e95:	90                   	nop
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	ff 75 10             	pushl  0x10(%ebp)
  801ea2:	ff 75 0c             	pushl  0xc(%ebp)
  801ea5:	ff 75 08             	pushl  0x8(%ebp)
  801ea8:	6a 11                	push   $0x11
  801eaa:	e8 7a fe ff ff       	call   801d29 <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb2:	90                   	nop
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 0c                	push   $0xc
  801ec4:	e8 60 fe ff ff       	call   801d29 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	ff 75 08             	pushl  0x8(%ebp)
  801edc:	6a 0d                	push   $0xd
  801ede:	e8 46 fe ff ff       	call   801d29 <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 0e                	push   $0xe
  801ef7:	e8 2d fe ff ff       	call   801d29 <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
}
  801eff:	90                   	nop
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 13                	push   $0x13
  801f11:	e8 13 fe ff ff       	call   801d29 <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
}
  801f19:	90                   	nop
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 14                	push   $0x14
  801f2b:	e8 f9 fd ff ff       	call   801d29 <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
}
  801f33:	90                   	nop
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	83 ec 04             	sub    $0x4,%esp
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f42:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	50                   	push   %eax
  801f4f:	6a 15                	push   $0x15
  801f51:	e8 d3 fd ff ff       	call   801d29 <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
}
  801f59:	90                   	nop
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 16                	push   $0x16
  801f6b:	e8 b9 fd ff ff       	call   801d29 <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
}
  801f73:	90                   	nop
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	ff 75 0c             	pushl  0xc(%ebp)
  801f85:	50                   	push   %eax
  801f86:	6a 17                	push   $0x17
  801f88:	e8 9c fd ff ff       	call   801d29 <syscall>
  801f8d:	83 c4 18             	add    $0x18,%esp
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	52                   	push   %edx
  801fa2:	50                   	push   %eax
  801fa3:	6a 1a                	push   $0x1a
  801fa5:	e8 7f fd ff ff       	call   801d29 <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	52                   	push   %edx
  801fbf:	50                   	push   %eax
  801fc0:	6a 18                	push   $0x18
  801fc2:	e8 62 fd ff ff       	call   801d29 <syscall>
  801fc7:	83 c4 18             	add    $0x18,%esp
}
  801fca:	90                   	nop
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	52                   	push   %edx
  801fdd:	50                   	push   %eax
  801fde:	6a 19                	push   $0x19
  801fe0:	e8 44 fd ff ff       	call   801d29 <syscall>
  801fe5:	83 c4 18             	add    $0x18,%esp
}
  801fe8:	90                   	nop
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 04             	sub    $0x4,%esp
  801ff1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ff7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ffa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	6a 00                	push   $0x0
  802003:	51                   	push   %ecx
  802004:	52                   	push   %edx
  802005:	ff 75 0c             	pushl  0xc(%ebp)
  802008:	50                   	push   %eax
  802009:	6a 1b                	push   $0x1b
  80200b:	e8 19 fd ff ff       	call   801d29 <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802018:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	52                   	push   %edx
  802025:	50                   	push   %eax
  802026:	6a 1c                	push   $0x1c
  802028:	e8 fc fc ff ff       	call   801d29 <syscall>
  80202d:	83 c4 18             	add    $0x18,%esp
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802035:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802038:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	51                   	push   %ecx
  802043:	52                   	push   %edx
  802044:	50                   	push   %eax
  802045:	6a 1d                	push   $0x1d
  802047:	e8 dd fc ff ff       	call   801d29 <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802054:	8b 55 0c             	mov    0xc(%ebp),%edx
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	52                   	push   %edx
  802061:	50                   	push   %eax
  802062:	6a 1e                	push   $0x1e
  802064:	e8 c0 fc ff ff       	call   801d29 <syscall>
  802069:	83 c4 18             	add    $0x18,%esp
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 1f                	push   $0x1f
  80207d:	e8 a7 fc ff ff       	call   801d29 <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	6a 00                	push   $0x0
  80208f:	ff 75 14             	pushl  0x14(%ebp)
  802092:	ff 75 10             	pushl  0x10(%ebp)
  802095:	ff 75 0c             	pushl  0xc(%ebp)
  802098:	50                   	push   %eax
  802099:	6a 20                	push   $0x20
  80209b:	e8 89 fc ff ff       	call   801d29 <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	50                   	push   %eax
  8020b4:	6a 21                	push   $0x21
  8020b6:	e8 6e fc ff ff       	call   801d29 <syscall>
  8020bb:	83 c4 18             	add    $0x18,%esp
}
  8020be:	90                   	nop
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	50                   	push   %eax
  8020d0:	6a 22                	push   $0x22
  8020d2:	e8 52 fc ff ff       	call   801d29 <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 02                	push   $0x2
  8020eb:	e8 39 fc ff ff       	call   801d29 <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 03                	push   $0x3
  802104:	e8 20 fc ff ff       	call   801d29 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 04                	push   $0x4
  80211d:	e8 07 fc ff ff       	call   801d29 <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_exit_env>:


void sys_exit_env(void)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 23                	push   $0x23
  802136:	e8 ee fb ff ff       	call   801d29 <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
}
  80213e:	90                   	nop
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802147:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80214a:	8d 50 04             	lea    0x4(%eax),%edx
  80214d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	52                   	push   %edx
  802157:	50                   	push   %eax
  802158:	6a 24                	push   $0x24
  80215a:	e8 ca fb ff ff       	call   801d29 <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
	return result;
  802162:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802165:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802168:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80216b:	89 01                	mov    %eax,(%ecx)
  80216d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	c9                   	leave  
  802174:	c2 04 00             	ret    $0x4

00802177 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	ff 75 10             	pushl  0x10(%ebp)
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	6a 12                	push   $0x12
  802189:	e8 9b fb ff ff       	call   801d29 <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
	return ;
  802191:	90                   	nop
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <sys_rcr2>:
uint32 sys_rcr2()
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 25                	push   $0x25
  8021a3:	e8 81 fb ff ff       	call   801d29 <syscall>
  8021a8:	83 c4 18             	add    $0x18,%esp
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	83 ec 04             	sub    $0x4,%esp
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021b9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	50                   	push   %eax
  8021c6:	6a 26                	push   $0x26
  8021c8:	e8 5c fb ff ff       	call   801d29 <syscall>
  8021cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d0:	90                   	nop
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <rsttst>:
void rsttst()
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 28                	push   $0x28
  8021e2:	e8 42 fb ff ff       	call   801d29 <syscall>
  8021e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ea:	90                   	nop
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 04             	sub    $0x4,%esp
  8021f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021f9:	8b 55 18             	mov    0x18(%ebp),%edx
  8021fc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802200:	52                   	push   %edx
  802201:	50                   	push   %eax
  802202:	ff 75 10             	pushl  0x10(%ebp)
  802205:	ff 75 0c             	pushl  0xc(%ebp)
  802208:	ff 75 08             	pushl  0x8(%ebp)
  80220b:	6a 27                	push   $0x27
  80220d:	e8 17 fb ff ff       	call   801d29 <syscall>
  802212:	83 c4 18             	add    $0x18,%esp
	return ;
  802215:	90                   	nop
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <chktst>:
void chktst(uint32 n)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	ff 75 08             	pushl  0x8(%ebp)
  802226:	6a 29                	push   $0x29
  802228:	e8 fc fa ff ff       	call   801d29 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
	return ;
  802230:	90                   	nop
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <inctst>:

void inctst()
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 2a                	push   $0x2a
  802242:	e8 e2 fa ff ff       	call   801d29 <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
	return ;
  80224a:	90                   	nop
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <gettst>:
uint32 gettst()
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 2b                	push   $0x2b
  80225c:	e8 c8 fa ff ff       	call   801d29 <syscall>
  802261:	83 c4 18             	add    $0x18,%esp
}
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 2c                	push   $0x2c
  802278:	e8 ac fa ff ff       	call   801d29 <syscall>
  80227d:	83 c4 18             	add    $0x18,%esp
  802280:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802283:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802287:	75 07                	jne    802290 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802289:	b8 01 00 00 00       	mov    $0x1,%eax
  80228e:	eb 05                	jmp    802295 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802290:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 2c                	push   $0x2c
  8022a9:	e8 7b fa ff ff       	call   801d29 <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
  8022b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022b4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022b8:	75 07                	jne    8022c1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8022bf:	eb 05                	jmp    8022c6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 2c                	push   $0x2c
  8022da:	e8 4a fa ff ff       	call   801d29 <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
  8022e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022e5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022e9:	75 07                	jne    8022f2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f0:	eb 05                	jmp    8022f7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
  8022fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 2c                	push   $0x2c
  80230b:	e8 19 fa ff ff       	call   801d29 <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
  802313:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802316:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80231a:	75 07                	jne    802323 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80231c:	b8 01 00 00 00       	mov    $0x1,%eax
  802321:	eb 05                	jmp    802328 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802323:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	ff 75 08             	pushl  0x8(%ebp)
  802338:	6a 2d                	push   $0x2d
  80233a:	e8 ea f9 ff ff       	call   801d29 <syscall>
  80233f:	83 c4 18             	add    $0x18,%esp
	return ;
  802342:	90                   	nop
}
  802343:	c9                   	leave  
  802344:	c3                   	ret    

00802345 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802349:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80234c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80234f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	6a 00                	push   $0x0
  802357:	53                   	push   %ebx
  802358:	51                   	push   %ecx
  802359:	52                   	push   %edx
  80235a:	50                   	push   %eax
  80235b:	6a 2e                	push   $0x2e
  80235d:	e8 c7 f9 ff ff       	call   801d29 <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
}
  802365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802368:	c9                   	leave  
  802369:	c3                   	ret    

0080236a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80236d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	52                   	push   %edx
  80237a:	50                   	push   %eax
  80237b:	6a 2f                	push   $0x2f
  80237d:	e8 a7 f9 ff ff       	call   801d29 <syscall>
  802382:	83 c4 18             	add    $0x18,%esp
}
  802385:	c9                   	leave  
  802386:	c3                   	ret    

00802387 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
  80238a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80238d:	83 ec 0c             	sub    $0xc,%esp
  802390:	68 20 44 80 00       	push   $0x804420
  802395:	e8 d6 e6 ff ff       	call   800a70 <cprintf>
  80239a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80239d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8023a4:	83 ec 0c             	sub    $0xc,%esp
  8023a7:	68 4c 44 80 00       	push   $0x80444c
  8023ac:	e8 bf e6 ff ff       	call   800a70 <cprintf>
  8023b1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8023b4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023b8:	a1 38 51 80 00       	mov    0x805138,%eax
  8023bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c0:	eb 56                	jmp    802418 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023c6:	74 1c                	je     8023e4 <print_mem_block_lists+0x5d>
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 50 08             	mov    0x8(%eax),%edx
  8023ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d1:	8b 48 08             	mov    0x8(%eax),%ecx
  8023d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023da:	01 c8                	add    %ecx,%eax
  8023dc:	39 c2                	cmp    %eax,%edx
  8023de:	73 04                	jae    8023e4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023e0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 50 08             	mov    0x8(%eax),%edx
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f0:	01 c2                	add    %eax,%edx
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 40 08             	mov    0x8(%eax),%eax
  8023f8:	83 ec 04             	sub    $0x4,%esp
  8023fb:	52                   	push   %edx
  8023fc:	50                   	push   %eax
  8023fd:	68 61 44 80 00       	push   $0x804461
  802402:	e8 69 e6 ff ff       	call   800a70 <cprintf>
  802407:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802410:	a1 40 51 80 00       	mov    0x805140,%eax
  802415:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802418:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241c:	74 07                	je     802425 <print_mem_block_lists+0x9e>
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 00                	mov    (%eax),%eax
  802423:	eb 05                	jmp    80242a <print_mem_block_lists+0xa3>
  802425:	b8 00 00 00 00       	mov    $0x0,%eax
  80242a:	a3 40 51 80 00       	mov    %eax,0x805140
  80242f:	a1 40 51 80 00       	mov    0x805140,%eax
  802434:	85 c0                	test   %eax,%eax
  802436:	75 8a                	jne    8023c2 <print_mem_block_lists+0x3b>
  802438:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243c:	75 84                	jne    8023c2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80243e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802442:	75 10                	jne    802454 <print_mem_block_lists+0xcd>
  802444:	83 ec 0c             	sub    $0xc,%esp
  802447:	68 70 44 80 00       	push   $0x804470
  80244c:	e8 1f e6 ff ff       	call   800a70 <cprintf>
  802451:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802454:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80245b:	83 ec 0c             	sub    $0xc,%esp
  80245e:	68 94 44 80 00       	push   $0x804494
  802463:	e8 08 e6 ff ff       	call   800a70 <cprintf>
  802468:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80246b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80246f:	a1 40 50 80 00       	mov    0x805040,%eax
  802474:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802477:	eb 56                	jmp    8024cf <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802479:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80247d:	74 1c                	je     80249b <print_mem_block_lists+0x114>
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	8b 50 08             	mov    0x8(%eax),%edx
  802485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802488:	8b 48 08             	mov    0x8(%eax),%ecx
  80248b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248e:	8b 40 0c             	mov    0xc(%eax),%eax
  802491:	01 c8                	add    %ecx,%eax
  802493:	39 c2                	cmp    %eax,%edx
  802495:	73 04                	jae    80249b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802497:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249e:	8b 50 08             	mov    0x8(%eax),%edx
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a7:	01 c2                	add    %eax,%edx
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 40 08             	mov    0x8(%eax),%eax
  8024af:	83 ec 04             	sub    $0x4,%esp
  8024b2:	52                   	push   %edx
  8024b3:	50                   	push   %eax
  8024b4:	68 61 44 80 00       	push   $0x804461
  8024b9:	e8 b2 e5 ff ff       	call   800a70 <cprintf>
  8024be:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024c7:	a1 48 50 80 00       	mov    0x805048,%eax
  8024cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d3:	74 07                	je     8024dc <print_mem_block_lists+0x155>
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	eb 05                	jmp    8024e1 <print_mem_block_lists+0x15a>
  8024dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e1:	a3 48 50 80 00       	mov    %eax,0x805048
  8024e6:	a1 48 50 80 00       	mov    0x805048,%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	75 8a                	jne    802479 <print_mem_block_lists+0xf2>
  8024ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f3:	75 84                	jne    802479 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024f5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024f9:	75 10                	jne    80250b <print_mem_block_lists+0x184>
  8024fb:	83 ec 0c             	sub    $0xc,%esp
  8024fe:	68 ac 44 80 00       	push   $0x8044ac
  802503:	e8 68 e5 ff ff       	call   800a70 <cprintf>
  802508:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80250b:	83 ec 0c             	sub    $0xc,%esp
  80250e:	68 20 44 80 00       	push   $0x804420
  802513:	e8 58 e5 ff ff       	call   800a70 <cprintf>
  802518:	83 c4 10             	add    $0x10,%esp

}
  80251b:	90                   	nop
  80251c:	c9                   	leave  
  80251d:	c3                   	ret    

0080251e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
  802521:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802524:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80252b:	00 00 00 
  80252e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802535:	00 00 00 
  802538:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80253f:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802549:	e9 9e 00 00 00       	jmp    8025ec <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80254e:	a1 50 50 80 00       	mov    0x805050,%eax
  802553:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802556:	c1 e2 04             	shl    $0x4,%edx
  802559:	01 d0                	add    %edx,%eax
  80255b:	85 c0                	test   %eax,%eax
  80255d:	75 14                	jne    802573 <initialize_MemBlocksList+0x55>
  80255f:	83 ec 04             	sub    $0x4,%esp
  802562:	68 d4 44 80 00       	push   $0x8044d4
  802567:	6a 46                	push   $0x46
  802569:	68 f7 44 80 00       	push   $0x8044f7
  80256e:	e8 49 e2 ff ff       	call   8007bc <_panic>
  802573:	a1 50 50 80 00       	mov    0x805050,%eax
  802578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257b:	c1 e2 04             	shl    $0x4,%edx
  80257e:	01 d0                	add    %edx,%eax
  802580:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802586:	89 10                	mov    %edx,(%eax)
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	85 c0                	test   %eax,%eax
  80258c:	74 18                	je     8025a6 <initialize_MemBlocksList+0x88>
  80258e:	a1 48 51 80 00       	mov    0x805148,%eax
  802593:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802599:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80259c:	c1 e1 04             	shl    $0x4,%ecx
  80259f:	01 ca                	add    %ecx,%edx
  8025a1:	89 50 04             	mov    %edx,0x4(%eax)
  8025a4:	eb 12                	jmp    8025b8 <initialize_MemBlocksList+0x9a>
  8025a6:	a1 50 50 80 00       	mov    0x805050,%eax
  8025ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ae:	c1 e2 04             	shl    $0x4,%edx
  8025b1:	01 d0                	add    %edx,%eax
  8025b3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025b8:	a1 50 50 80 00       	mov    0x805050,%eax
  8025bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c0:	c1 e2 04             	shl    $0x4,%edx
  8025c3:	01 d0                	add    %edx,%eax
  8025c5:	a3 48 51 80 00       	mov    %eax,0x805148
  8025ca:	a1 50 50 80 00       	mov    0x805050,%eax
  8025cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d2:	c1 e2 04             	shl    $0x4,%edx
  8025d5:	01 d0                	add    %edx,%eax
  8025d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025de:	a1 54 51 80 00       	mov    0x805154,%eax
  8025e3:	40                   	inc    %eax
  8025e4:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8025e9:	ff 45 f4             	incl   -0xc(%ebp)
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f2:	0f 82 56 ff ff ff    	jb     80254e <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8025f8:	90                   	nop
  8025f9:	c9                   	leave  
  8025fa:	c3                   	ret    

008025fb <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025fb:	55                   	push   %ebp
  8025fc:	89 e5                	mov    %esp,%ebp
  8025fe:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	8b 00                	mov    (%eax),%eax
  802606:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802609:	eb 19                	jmp    802624 <find_block+0x29>
	{
		if(va==point->sva)
  80260b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80260e:	8b 40 08             	mov    0x8(%eax),%eax
  802611:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802614:	75 05                	jne    80261b <find_block+0x20>
		   return point;
  802616:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802619:	eb 36                	jmp    802651 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80261b:	8b 45 08             	mov    0x8(%ebp),%eax
  80261e:	8b 40 08             	mov    0x8(%eax),%eax
  802621:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802624:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802628:	74 07                	je     802631 <find_block+0x36>
  80262a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80262d:	8b 00                	mov    (%eax),%eax
  80262f:	eb 05                	jmp    802636 <find_block+0x3b>
  802631:	b8 00 00 00 00       	mov    $0x0,%eax
  802636:	8b 55 08             	mov    0x8(%ebp),%edx
  802639:	89 42 08             	mov    %eax,0x8(%edx)
  80263c:	8b 45 08             	mov    0x8(%ebp),%eax
  80263f:	8b 40 08             	mov    0x8(%eax),%eax
  802642:	85 c0                	test   %eax,%eax
  802644:	75 c5                	jne    80260b <find_block+0x10>
  802646:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80264a:	75 bf                	jne    80260b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80264c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802651:	c9                   	leave  
  802652:	c3                   	ret    

00802653 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
  802656:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802659:	a1 40 50 80 00       	mov    0x805040,%eax
  80265e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802661:	a1 44 50 80 00       	mov    0x805044,%eax
  802666:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802669:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80266f:	74 24                	je     802695 <insert_sorted_allocList+0x42>
  802671:	8b 45 08             	mov    0x8(%ebp),%eax
  802674:	8b 50 08             	mov    0x8(%eax),%edx
  802677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267a:	8b 40 08             	mov    0x8(%eax),%eax
  80267d:	39 c2                	cmp    %eax,%edx
  80267f:	76 14                	jbe    802695 <insert_sorted_allocList+0x42>
  802681:	8b 45 08             	mov    0x8(%ebp),%eax
  802684:	8b 50 08             	mov    0x8(%eax),%edx
  802687:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268a:	8b 40 08             	mov    0x8(%eax),%eax
  80268d:	39 c2                	cmp    %eax,%edx
  80268f:	0f 82 60 01 00 00    	jb     8027f5 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802695:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802699:	75 65                	jne    802700 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80269b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80269f:	75 14                	jne    8026b5 <insert_sorted_allocList+0x62>
  8026a1:	83 ec 04             	sub    $0x4,%esp
  8026a4:	68 d4 44 80 00       	push   $0x8044d4
  8026a9:	6a 6b                	push   $0x6b
  8026ab:	68 f7 44 80 00       	push   $0x8044f7
  8026b0:	e8 07 e1 ff ff       	call   8007bc <_panic>
  8026b5:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8026bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026be:	89 10                	mov    %edx,(%eax)
  8026c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c3:	8b 00                	mov    (%eax),%eax
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	74 0d                	je     8026d6 <insert_sorted_allocList+0x83>
  8026c9:	a1 40 50 80 00       	mov    0x805040,%eax
  8026ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d1:	89 50 04             	mov    %edx,0x4(%eax)
  8026d4:	eb 08                	jmp    8026de <insert_sorted_allocList+0x8b>
  8026d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d9:	a3 44 50 80 00       	mov    %eax,0x805044
  8026de:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e1:	a3 40 50 80 00       	mov    %eax,0x805040
  8026e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026f5:	40                   	inc    %eax
  8026f6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026fb:	e9 dc 01 00 00       	jmp    8028dc <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802700:	8b 45 08             	mov    0x8(%ebp),%eax
  802703:	8b 50 08             	mov    0x8(%eax),%edx
  802706:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802709:	8b 40 08             	mov    0x8(%eax),%eax
  80270c:	39 c2                	cmp    %eax,%edx
  80270e:	77 6c                	ja     80277c <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802710:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802714:	74 06                	je     80271c <insert_sorted_allocList+0xc9>
  802716:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80271a:	75 14                	jne    802730 <insert_sorted_allocList+0xdd>
  80271c:	83 ec 04             	sub    $0x4,%esp
  80271f:	68 10 45 80 00       	push   $0x804510
  802724:	6a 6f                	push   $0x6f
  802726:	68 f7 44 80 00       	push   $0x8044f7
  80272b:	e8 8c e0 ff ff       	call   8007bc <_panic>
  802730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802733:	8b 50 04             	mov    0x4(%eax),%edx
  802736:	8b 45 08             	mov    0x8(%ebp),%eax
  802739:	89 50 04             	mov    %edx,0x4(%eax)
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802742:	89 10                	mov    %edx,(%eax)
  802744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802747:	8b 40 04             	mov    0x4(%eax),%eax
  80274a:	85 c0                	test   %eax,%eax
  80274c:	74 0d                	je     80275b <insert_sorted_allocList+0x108>
  80274e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802751:	8b 40 04             	mov    0x4(%eax),%eax
  802754:	8b 55 08             	mov    0x8(%ebp),%edx
  802757:	89 10                	mov    %edx,(%eax)
  802759:	eb 08                	jmp    802763 <insert_sorted_allocList+0x110>
  80275b:	8b 45 08             	mov    0x8(%ebp),%eax
  80275e:	a3 40 50 80 00       	mov    %eax,0x805040
  802763:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802766:	8b 55 08             	mov    0x8(%ebp),%edx
  802769:	89 50 04             	mov    %edx,0x4(%eax)
  80276c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802771:	40                   	inc    %eax
  802772:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802777:	e9 60 01 00 00       	jmp    8028dc <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80277c:	8b 45 08             	mov    0x8(%ebp),%eax
  80277f:	8b 50 08             	mov    0x8(%eax),%edx
  802782:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802785:	8b 40 08             	mov    0x8(%eax),%eax
  802788:	39 c2                	cmp    %eax,%edx
  80278a:	0f 82 4c 01 00 00    	jb     8028dc <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802790:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802794:	75 14                	jne    8027aa <insert_sorted_allocList+0x157>
  802796:	83 ec 04             	sub    $0x4,%esp
  802799:	68 48 45 80 00       	push   $0x804548
  80279e:	6a 73                	push   $0x73
  8027a0:	68 f7 44 80 00       	push   $0x8044f7
  8027a5:	e8 12 e0 ff ff       	call   8007bc <_panic>
  8027aa:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8027b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b3:	89 50 04             	mov    %edx,0x4(%eax)
  8027b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b9:	8b 40 04             	mov    0x4(%eax),%eax
  8027bc:	85 c0                	test   %eax,%eax
  8027be:	74 0c                	je     8027cc <insert_sorted_allocList+0x179>
  8027c0:	a1 44 50 80 00       	mov    0x805044,%eax
  8027c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c8:	89 10                	mov    %edx,(%eax)
  8027ca:	eb 08                	jmp    8027d4 <insert_sorted_allocList+0x181>
  8027cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cf:	a3 40 50 80 00       	mov    %eax,0x805040
  8027d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d7:	a3 44 50 80 00       	mov    %eax,0x805044
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027ea:	40                   	inc    %eax
  8027eb:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027f0:	e9 e7 00 00 00       	jmp    8028dc <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8027f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8027fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802802:	a1 40 50 80 00       	mov    0x805040,%eax
  802807:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280a:	e9 9d 00 00 00       	jmp    8028ac <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
  80281a:	8b 50 08             	mov    0x8(%eax),%edx
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 40 08             	mov    0x8(%eax),%eax
  802823:	39 c2                	cmp    %eax,%edx
  802825:	76 7d                	jbe    8028a4 <insert_sorted_allocList+0x251>
  802827:	8b 45 08             	mov    0x8(%ebp),%eax
  80282a:	8b 50 08             	mov    0x8(%eax),%edx
  80282d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802830:	8b 40 08             	mov    0x8(%eax),%eax
  802833:	39 c2                	cmp    %eax,%edx
  802835:	73 6d                	jae    8028a4 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802837:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283b:	74 06                	je     802843 <insert_sorted_allocList+0x1f0>
  80283d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802841:	75 14                	jne    802857 <insert_sorted_allocList+0x204>
  802843:	83 ec 04             	sub    $0x4,%esp
  802846:	68 6c 45 80 00       	push   $0x80456c
  80284b:	6a 7f                	push   $0x7f
  80284d:	68 f7 44 80 00       	push   $0x8044f7
  802852:	e8 65 df ff ff       	call   8007bc <_panic>
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 10                	mov    (%eax),%edx
  80285c:	8b 45 08             	mov    0x8(%ebp),%eax
  80285f:	89 10                	mov    %edx,(%eax)
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	8b 00                	mov    (%eax),%eax
  802866:	85 c0                	test   %eax,%eax
  802868:	74 0b                	je     802875 <insert_sorted_allocList+0x222>
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	8b 55 08             	mov    0x8(%ebp),%edx
  802872:	89 50 04             	mov    %edx,0x4(%eax)
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 55 08             	mov    0x8(%ebp),%edx
  80287b:	89 10                	mov    %edx,(%eax)
  80287d:	8b 45 08             	mov    0x8(%ebp),%eax
  802880:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802883:	89 50 04             	mov    %edx,0x4(%eax)
  802886:	8b 45 08             	mov    0x8(%ebp),%eax
  802889:	8b 00                	mov    (%eax),%eax
  80288b:	85 c0                	test   %eax,%eax
  80288d:	75 08                	jne    802897 <insert_sorted_allocList+0x244>
  80288f:	8b 45 08             	mov    0x8(%ebp),%eax
  802892:	a3 44 50 80 00       	mov    %eax,0x805044
  802897:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80289c:	40                   	inc    %eax
  80289d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8028a2:	eb 39                	jmp    8028dd <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8028a4:	a1 48 50 80 00       	mov    0x805048,%eax
  8028a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b0:	74 07                	je     8028b9 <insert_sorted_allocList+0x266>
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	8b 00                	mov    (%eax),%eax
  8028b7:	eb 05                	jmp    8028be <insert_sorted_allocList+0x26b>
  8028b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028be:	a3 48 50 80 00       	mov    %eax,0x805048
  8028c3:	a1 48 50 80 00       	mov    0x805048,%eax
  8028c8:	85 c0                	test   %eax,%eax
  8028ca:	0f 85 3f ff ff ff    	jne    80280f <insert_sorted_allocList+0x1bc>
  8028d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d4:	0f 85 35 ff ff ff    	jne    80280f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028da:	eb 01                	jmp    8028dd <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028dc:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8028dd:	90                   	nop
  8028de:	c9                   	leave  
  8028df:	c3                   	ret    

008028e0 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
  8028e3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8028e6:	a1 38 51 80 00       	mov    0x805138,%eax
  8028eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ee:	e9 85 01 00 00       	jmp    802a78 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028fc:	0f 82 6e 01 00 00    	jb     802a70 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802905:	8b 40 0c             	mov    0xc(%eax),%eax
  802908:	3b 45 08             	cmp    0x8(%ebp),%eax
  80290b:	0f 85 8a 00 00 00    	jne    80299b <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802911:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802915:	75 17                	jne    80292e <alloc_block_FF+0x4e>
  802917:	83 ec 04             	sub    $0x4,%esp
  80291a:	68 a0 45 80 00       	push   $0x8045a0
  80291f:	68 93 00 00 00       	push   $0x93
  802924:	68 f7 44 80 00       	push   $0x8044f7
  802929:	e8 8e de ff ff       	call   8007bc <_panic>
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	8b 00                	mov    (%eax),%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	74 10                	je     802947 <alloc_block_FF+0x67>
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293f:	8b 52 04             	mov    0x4(%edx),%edx
  802942:	89 50 04             	mov    %edx,0x4(%eax)
  802945:	eb 0b                	jmp    802952 <alloc_block_FF+0x72>
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 40 04             	mov    0x4(%eax),%eax
  80294d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 40 04             	mov    0x4(%eax),%eax
  802958:	85 c0                	test   %eax,%eax
  80295a:	74 0f                	je     80296b <alloc_block_FF+0x8b>
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	8b 40 04             	mov    0x4(%eax),%eax
  802962:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802965:	8b 12                	mov    (%edx),%edx
  802967:	89 10                	mov    %edx,(%eax)
  802969:	eb 0a                	jmp    802975 <alloc_block_FF+0x95>
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 00                	mov    (%eax),%eax
  802970:	a3 38 51 80 00       	mov    %eax,0x805138
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802988:	a1 44 51 80 00       	mov    0x805144,%eax
  80298d:	48                   	dec    %eax
  80298e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	e9 10 01 00 00       	jmp    802aab <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029a4:	0f 86 c6 00 00 00    	jbe    802a70 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029aa:	a1 48 51 80 00       	mov    0x805148,%eax
  8029af:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 50 08             	mov    0x8(%eax),%edx
  8029b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bb:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8029be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c4:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029cb:	75 17                	jne    8029e4 <alloc_block_FF+0x104>
  8029cd:	83 ec 04             	sub    $0x4,%esp
  8029d0:	68 a0 45 80 00       	push   $0x8045a0
  8029d5:	68 9b 00 00 00       	push   $0x9b
  8029da:	68 f7 44 80 00       	push   $0x8044f7
  8029df:	e8 d8 dd ff ff       	call   8007bc <_panic>
  8029e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	74 10                	je     8029fd <alloc_block_FF+0x11d>
  8029ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029f5:	8b 52 04             	mov    0x4(%edx),%edx
  8029f8:	89 50 04             	mov    %edx,0x4(%eax)
  8029fb:	eb 0b                	jmp    802a08 <alloc_block_FF+0x128>
  8029fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a00:	8b 40 04             	mov    0x4(%eax),%eax
  802a03:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0b:	8b 40 04             	mov    0x4(%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 0f                	je     802a21 <alloc_block_FF+0x141>
  802a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a15:	8b 40 04             	mov    0x4(%eax),%eax
  802a18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a1b:	8b 12                	mov    (%edx),%edx
  802a1d:	89 10                	mov    %edx,(%eax)
  802a1f:	eb 0a                	jmp    802a2b <alloc_block_FF+0x14b>
  802a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a24:	8b 00                	mov    (%eax),%eax
  802a26:	a3 48 51 80 00       	mov    %eax,0x805148
  802a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3e:	a1 54 51 80 00       	mov    0x805154,%eax
  802a43:	48                   	dec    %eax
  802a44:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	8b 50 08             	mov    0x8(%eax),%edx
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	01 c2                	add    %eax,%edx
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a60:	2b 45 08             	sub    0x8(%ebp),%eax
  802a63:	89 c2                	mov    %eax,%edx
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6e:	eb 3b                	jmp    802aab <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a70:	a1 40 51 80 00       	mov    0x805140,%eax
  802a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7c:	74 07                	je     802a85 <alloc_block_FF+0x1a5>
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	eb 05                	jmp    802a8a <alloc_block_FF+0x1aa>
  802a85:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8a:	a3 40 51 80 00       	mov    %eax,0x805140
  802a8f:	a1 40 51 80 00       	mov    0x805140,%eax
  802a94:	85 c0                	test   %eax,%eax
  802a96:	0f 85 57 fe ff ff    	jne    8028f3 <alloc_block_FF+0x13>
  802a9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa0:	0f 85 4d fe ff ff    	jne    8028f3 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802aa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aab:	c9                   	leave  
  802aac:	c3                   	ret    

00802aad <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802aad:	55                   	push   %ebp
  802aae:	89 e5                	mov    %esp,%ebp
  802ab0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802ab3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802aba:	a1 38 51 80 00       	mov    0x805138,%eax
  802abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac2:	e9 df 00 00 00       	jmp    802ba6 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	8b 40 0c             	mov    0xc(%eax),%eax
  802acd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad0:	0f 82 c8 00 00 00    	jb     802b9e <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	8b 40 0c             	mov    0xc(%eax),%eax
  802adc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802adf:	0f 85 8a 00 00 00    	jne    802b6f <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802ae5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae9:	75 17                	jne    802b02 <alloc_block_BF+0x55>
  802aeb:	83 ec 04             	sub    $0x4,%esp
  802aee:	68 a0 45 80 00       	push   $0x8045a0
  802af3:	68 b7 00 00 00       	push   $0xb7
  802af8:	68 f7 44 80 00       	push   $0x8044f7
  802afd:	e8 ba dc ff ff       	call   8007bc <_panic>
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	74 10                	je     802b1b <alloc_block_BF+0x6e>
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b13:	8b 52 04             	mov    0x4(%edx),%edx
  802b16:	89 50 04             	mov    %edx,0x4(%eax)
  802b19:	eb 0b                	jmp    802b26 <alloc_block_BF+0x79>
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	8b 40 04             	mov    0x4(%eax),%eax
  802b21:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 40 04             	mov    0x4(%eax),%eax
  802b2c:	85 c0                	test   %eax,%eax
  802b2e:	74 0f                	je     802b3f <alloc_block_BF+0x92>
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b39:	8b 12                	mov    (%edx),%edx
  802b3b:	89 10                	mov    %edx,(%eax)
  802b3d:	eb 0a                	jmp    802b49 <alloc_block_BF+0x9c>
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	8b 00                	mov    (%eax),%eax
  802b44:	a3 38 51 80 00       	mov    %eax,0x805138
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5c:	a1 44 51 80 00       	mov    0x805144,%eax
  802b61:	48                   	dec    %eax
  802b62:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	e9 4d 01 00 00       	jmp    802cbc <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 40 0c             	mov    0xc(%eax),%eax
  802b75:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b78:	76 24                	jbe    802b9e <alloc_block_BF+0xf1>
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b80:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b83:	73 19                	jae    802b9e <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802b85:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 40 08             	mov    0x8(%eax),%eax
  802b9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802b9e:	a1 40 51 80 00       	mov    0x805140,%eax
  802ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802baa:	74 07                	je     802bb3 <alloc_block_BF+0x106>
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	eb 05                	jmp    802bb8 <alloc_block_BF+0x10b>
  802bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb8:	a3 40 51 80 00       	mov    %eax,0x805140
  802bbd:	a1 40 51 80 00       	mov    0x805140,%eax
  802bc2:	85 c0                	test   %eax,%eax
  802bc4:	0f 85 fd fe ff ff    	jne    802ac7 <alloc_block_BF+0x1a>
  802bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bce:	0f 85 f3 fe ff ff    	jne    802ac7 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802bd4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bd8:	0f 84 d9 00 00 00    	je     802cb7 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bde:	a1 48 51 80 00       	mov    0x805148,%eax
  802be3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802be6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bec:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802bef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bf2:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf5:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802bf8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bfc:	75 17                	jne    802c15 <alloc_block_BF+0x168>
  802bfe:	83 ec 04             	sub    $0x4,%esp
  802c01:	68 a0 45 80 00       	push   $0x8045a0
  802c06:	68 c7 00 00 00       	push   $0xc7
  802c0b:	68 f7 44 80 00       	push   $0x8044f7
  802c10:	e8 a7 db ff ff       	call   8007bc <_panic>
  802c15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c18:	8b 00                	mov    (%eax),%eax
  802c1a:	85 c0                	test   %eax,%eax
  802c1c:	74 10                	je     802c2e <alloc_block_BF+0x181>
  802c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c21:	8b 00                	mov    (%eax),%eax
  802c23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c26:	8b 52 04             	mov    0x4(%edx),%edx
  802c29:	89 50 04             	mov    %edx,0x4(%eax)
  802c2c:	eb 0b                	jmp    802c39 <alloc_block_BF+0x18c>
  802c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c31:	8b 40 04             	mov    0x4(%eax),%eax
  802c34:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3c:	8b 40 04             	mov    0x4(%eax),%eax
  802c3f:	85 c0                	test   %eax,%eax
  802c41:	74 0f                	je     802c52 <alloc_block_BF+0x1a5>
  802c43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c46:	8b 40 04             	mov    0x4(%eax),%eax
  802c49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c4c:	8b 12                	mov    (%edx),%edx
  802c4e:	89 10                	mov    %edx,(%eax)
  802c50:	eb 0a                	jmp    802c5c <alloc_block_BF+0x1af>
  802c52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c55:	8b 00                	mov    (%eax),%eax
  802c57:	a3 48 51 80 00       	mov    %eax,0x805148
  802c5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6f:	a1 54 51 80 00       	mov    0x805154,%eax
  802c74:	48                   	dec    %eax
  802c75:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802c7a:	83 ec 08             	sub    $0x8,%esp
  802c7d:	ff 75 ec             	pushl  -0x14(%ebp)
  802c80:	68 38 51 80 00       	push   $0x805138
  802c85:	e8 71 f9 ff ff       	call   8025fb <find_block>
  802c8a:	83 c4 10             	add    $0x10,%esp
  802c8d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802c90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c93:	8b 50 08             	mov    0x8(%eax),%edx
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	01 c2                	add    %eax,%edx
  802c9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9e:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802ca1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca7:	2b 45 08             	sub    0x8(%ebp),%eax
  802caa:	89 c2                	mov    %eax,%edx
  802cac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802caf:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802cb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb5:	eb 05                	jmp    802cbc <alloc_block_BF+0x20f>
	}
	return NULL;
  802cb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cbc:	c9                   	leave  
  802cbd:	c3                   	ret    

00802cbe <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802cbe:	55                   	push   %ebp
  802cbf:	89 e5                	mov    %esp,%ebp
  802cc1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802cc4:	a1 28 50 80 00       	mov    0x805028,%eax
  802cc9:	85 c0                	test   %eax,%eax
  802ccb:	0f 85 de 01 00 00    	jne    802eaf <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802cd1:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd9:	e9 9e 01 00 00       	jmp    802e7c <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce7:	0f 82 87 01 00 00    	jb     802e74 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cf6:	0f 85 95 00 00 00    	jne    802d91 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802cfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d00:	75 17                	jne    802d19 <alloc_block_NF+0x5b>
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	68 a0 45 80 00       	push   $0x8045a0
  802d0a:	68 e0 00 00 00       	push   $0xe0
  802d0f:	68 f7 44 80 00       	push   $0x8044f7
  802d14:	e8 a3 da ff ff       	call   8007bc <_panic>
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	85 c0                	test   %eax,%eax
  802d20:	74 10                	je     802d32 <alloc_block_NF+0x74>
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2a:	8b 52 04             	mov    0x4(%edx),%edx
  802d2d:	89 50 04             	mov    %edx,0x4(%eax)
  802d30:	eb 0b                	jmp    802d3d <alloc_block_NF+0x7f>
  802d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d35:	8b 40 04             	mov    0x4(%eax),%eax
  802d38:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	8b 40 04             	mov    0x4(%eax),%eax
  802d43:	85 c0                	test   %eax,%eax
  802d45:	74 0f                	je     802d56 <alloc_block_NF+0x98>
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 40 04             	mov    0x4(%eax),%eax
  802d4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d50:	8b 12                	mov    (%edx),%edx
  802d52:	89 10                	mov    %edx,(%eax)
  802d54:	eb 0a                	jmp    802d60 <alloc_block_NF+0xa2>
  802d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d59:	8b 00                	mov    (%eax),%eax
  802d5b:	a3 38 51 80 00       	mov    %eax,0x805138
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d73:	a1 44 51 80 00       	mov    0x805144,%eax
  802d78:	48                   	dec    %eax
  802d79:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 40 08             	mov    0x8(%eax),%eax
  802d84:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	e9 f8 04 00 00       	jmp    803289 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 40 0c             	mov    0xc(%eax),%eax
  802d97:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d9a:	0f 86 d4 00 00 00    	jbe    802e74 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802da0:	a1 48 51 80 00       	mov    0x805148,%eax
  802da5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dab:	8b 50 08             	mov    0x8(%eax),%edx
  802dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db1:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db7:	8b 55 08             	mov    0x8(%ebp),%edx
  802dba:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802dbd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc1:	75 17                	jne    802dda <alloc_block_NF+0x11c>
  802dc3:	83 ec 04             	sub    $0x4,%esp
  802dc6:	68 a0 45 80 00       	push   $0x8045a0
  802dcb:	68 e9 00 00 00       	push   $0xe9
  802dd0:	68 f7 44 80 00       	push   $0x8044f7
  802dd5:	e8 e2 d9 ff ff       	call   8007bc <_panic>
  802dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddd:	8b 00                	mov    (%eax),%eax
  802ddf:	85 c0                	test   %eax,%eax
  802de1:	74 10                	je     802df3 <alloc_block_NF+0x135>
  802de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de6:	8b 00                	mov    (%eax),%eax
  802de8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802deb:	8b 52 04             	mov    0x4(%edx),%edx
  802dee:	89 50 04             	mov    %edx,0x4(%eax)
  802df1:	eb 0b                	jmp    802dfe <alloc_block_NF+0x140>
  802df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df6:	8b 40 04             	mov    0x4(%eax),%eax
  802df9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e01:	8b 40 04             	mov    0x4(%eax),%eax
  802e04:	85 c0                	test   %eax,%eax
  802e06:	74 0f                	je     802e17 <alloc_block_NF+0x159>
  802e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0b:	8b 40 04             	mov    0x4(%eax),%eax
  802e0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e11:	8b 12                	mov    (%edx),%edx
  802e13:	89 10                	mov    %edx,(%eax)
  802e15:	eb 0a                	jmp    802e21 <alloc_block_NF+0x163>
  802e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1a:	8b 00                	mov    (%eax),%eax
  802e1c:	a3 48 51 80 00       	mov    %eax,0x805148
  802e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e34:	a1 54 51 80 00       	mov    0x805154,%eax
  802e39:	48                   	dec    %eax
  802e3a:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e42:	8b 40 08             	mov    0x8(%eax),%eax
  802e45:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	8b 50 08             	mov    0x8(%eax),%edx
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	01 c2                	add    %eax,%edx
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e61:	2b 45 08             	sub    0x8(%ebp),%eax
  802e64:	89 c2                	mov    %eax,%edx
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6f:	e9 15 04 00 00       	jmp    803289 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e74:	a1 40 51 80 00       	mov    0x805140,%eax
  802e79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e80:	74 07                	je     802e89 <alloc_block_NF+0x1cb>
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 00                	mov    (%eax),%eax
  802e87:	eb 05                	jmp    802e8e <alloc_block_NF+0x1d0>
  802e89:	b8 00 00 00 00       	mov    $0x0,%eax
  802e8e:	a3 40 51 80 00       	mov    %eax,0x805140
  802e93:	a1 40 51 80 00       	mov    0x805140,%eax
  802e98:	85 c0                	test   %eax,%eax
  802e9a:	0f 85 3e fe ff ff    	jne    802cde <alloc_block_NF+0x20>
  802ea0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea4:	0f 85 34 fe ff ff    	jne    802cde <alloc_block_NF+0x20>
  802eaa:	e9 d5 03 00 00       	jmp    803284 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802eaf:	a1 38 51 80 00       	mov    0x805138,%eax
  802eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb7:	e9 b1 01 00 00       	jmp    80306d <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	8b 50 08             	mov    0x8(%eax),%edx
  802ec2:	a1 28 50 80 00       	mov    0x805028,%eax
  802ec7:	39 c2                	cmp    %eax,%edx
  802ec9:	0f 82 96 01 00 00    	jb     803065 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed8:	0f 82 87 01 00 00    	jb     803065 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ee7:	0f 85 95 00 00 00    	jne    802f82 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802eed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef1:	75 17                	jne    802f0a <alloc_block_NF+0x24c>
  802ef3:	83 ec 04             	sub    $0x4,%esp
  802ef6:	68 a0 45 80 00       	push   $0x8045a0
  802efb:	68 fc 00 00 00       	push   $0xfc
  802f00:	68 f7 44 80 00       	push   $0x8044f7
  802f05:	e8 b2 d8 ff ff       	call   8007bc <_panic>
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 00                	mov    (%eax),%eax
  802f0f:	85 c0                	test   %eax,%eax
  802f11:	74 10                	je     802f23 <alloc_block_NF+0x265>
  802f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f16:	8b 00                	mov    (%eax),%eax
  802f18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1b:	8b 52 04             	mov    0x4(%edx),%edx
  802f1e:	89 50 04             	mov    %edx,0x4(%eax)
  802f21:	eb 0b                	jmp    802f2e <alloc_block_NF+0x270>
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	8b 40 04             	mov    0x4(%eax),%eax
  802f29:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	8b 40 04             	mov    0x4(%eax),%eax
  802f34:	85 c0                	test   %eax,%eax
  802f36:	74 0f                	je     802f47 <alloc_block_NF+0x289>
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	8b 40 04             	mov    0x4(%eax),%eax
  802f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f41:	8b 12                	mov    (%edx),%edx
  802f43:	89 10                	mov    %edx,(%eax)
  802f45:	eb 0a                	jmp    802f51 <alloc_block_NF+0x293>
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f64:	a1 44 51 80 00       	mov    0x805144,%eax
  802f69:	48                   	dec    %eax
  802f6a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	8b 40 08             	mov    0x8(%eax),%eax
  802f75:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7d:	e9 07 03 00 00       	jmp    803289 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	8b 40 0c             	mov    0xc(%eax),%eax
  802f88:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f8b:	0f 86 d4 00 00 00    	jbe    803065 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f91:	a1 48 51 80 00       	mov    0x805148,%eax
  802f96:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9c:	8b 50 08             	mov    0x8(%eax),%edx
  802f9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa8:	8b 55 08             	mov    0x8(%ebp),%edx
  802fab:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802fae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fb2:	75 17                	jne    802fcb <alloc_block_NF+0x30d>
  802fb4:	83 ec 04             	sub    $0x4,%esp
  802fb7:	68 a0 45 80 00       	push   $0x8045a0
  802fbc:	68 04 01 00 00       	push   $0x104
  802fc1:	68 f7 44 80 00       	push   $0x8044f7
  802fc6:	e8 f1 d7 ff ff       	call   8007bc <_panic>
  802fcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fce:	8b 00                	mov    (%eax),%eax
  802fd0:	85 c0                	test   %eax,%eax
  802fd2:	74 10                	je     802fe4 <alloc_block_NF+0x326>
  802fd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd7:	8b 00                	mov    (%eax),%eax
  802fd9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fdc:	8b 52 04             	mov    0x4(%edx),%edx
  802fdf:	89 50 04             	mov    %edx,0x4(%eax)
  802fe2:	eb 0b                	jmp    802fef <alloc_block_NF+0x331>
  802fe4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe7:	8b 40 04             	mov    0x4(%eax),%eax
  802fea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff2:	8b 40 04             	mov    0x4(%eax),%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	74 0f                	je     803008 <alloc_block_NF+0x34a>
  802ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffc:	8b 40 04             	mov    0x4(%eax),%eax
  802fff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803002:	8b 12                	mov    (%edx),%edx
  803004:	89 10                	mov    %edx,(%eax)
  803006:	eb 0a                	jmp    803012 <alloc_block_NF+0x354>
  803008:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300b:	8b 00                	mov    (%eax),%eax
  80300d:	a3 48 51 80 00       	mov    %eax,0x805148
  803012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803015:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803025:	a1 54 51 80 00       	mov    0x805154,%eax
  80302a:	48                   	dec    %eax
  80302b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803030:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803033:	8b 40 08             	mov    0x8(%eax),%eax
  803036:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80303b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303e:	8b 50 08             	mov    0x8(%eax),%edx
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	01 c2                	add    %eax,%edx
  803046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803049:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80304c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304f:	8b 40 0c             	mov    0xc(%eax),%eax
  803052:	2b 45 08             	sub    0x8(%ebp),%eax
  803055:	89 c2                	mov    %eax,%edx
  803057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80305d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803060:	e9 24 02 00 00       	jmp    803289 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803065:	a1 40 51 80 00       	mov    0x805140,%eax
  80306a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80306d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803071:	74 07                	je     80307a <alloc_block_NF+0x3bc>
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	8b 00                	mov    (%eax),%eax
  803078:	eb 05                	jmp    80307f <alloc_block_NF+0x3c1>
  80307a:	b8 00 00 00 00       	mov    $0x0,%eax
  80307f:	a3 40 51 80 00       	mov    %eax,0x805140
  803084:	a1 40 51 80 00       	mov    0x805140,%eax
  803089:	85 c0                	test   %eax,%eax
  80308b:	0f 85 2b fe ff ff    	jne    802ebc <alloc_block_NF+0x1fe>
  803091:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803095:	0f 85 21 fe ff ff    	jne    802ebc <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80309b:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a3:	e9 ae 01 00 00       	jmp    803256 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ab:	8b 50 08             	mov    0x8(%eax),%edx
  8030ae:	a1 28 50 80 00       	mov    0x805028,%eax
  8030b3:	39 c2                	cmp    %eax,%edx
  8030b5:	0f 83 93 01 00 00    	jae    80324e <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8030bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030be:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030c4:	0f 82 84 01 00 00    	jb     80324e <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030d3:	0f 85 95 00 00 00    	jne    80316e <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8030d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030dd:	75 17                	jne    8030f6 <alloc_block_NF+0x438>
  8030df:	83 ec 04             	sub    $0x4,%esp
  8030e2:	68 a0 45 80 00       	push   $0x8045a0
  8030e7:	68 14 01 00 00       	push   $0x114
  8030ec:	68 f7 44 80 00       	push   $0x8044f7
  8030f1:	e8 c6 d6 ff ff       	call   8007bc <_panic>
  8030f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f9:	8b 00                	mov    (%eax),%eax
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	74 10                	je     80310f <alloc_block_NF+0x451>
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	8b 00                	mov    (%eax),%eax
  803104:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803107:	8b 52 04             	mov    0x4(%edx),%edx
  80310a:	89 50 04             	mov    %edx,0x4(%eax)
  80310d:	eb 0b                	jmp    80311a <alloc_block_NF+0x45c>
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	8b 40 04             	mov    0x4(%eax),%eax
  803115:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80311a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311d:	8b 40 04             	mov    0x4(%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 0f                	je     803133 <alloc_block_NF+0x475>
  803124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803127:	8b 40 04             	mov    0x4(%eax),%eax
  80312a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80312d:	8b 12                	mov    (%edx),%edx
  80312f:	89 10                	mov    %edx,(%eax)
  803131:	eb 0a                	jmp    80313d <alloc_block_NF+0x47f>
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	8b 00                	mov    (%eax),%eax
  803138:	a3 38 51 80 00       	mov    %eax,0x805138
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803149:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803150:	a1 44 51 80 00       	mov    0x805144,%eax
  803155:	48                   	dec    %eax
  803156:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80315b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315e:	8b 40 08             	mov    0x8(%eax),%eax
  803161:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803169:	e9 1b 01 00 00       	jmp    803289 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	8b 40 0c             	mov    0xc(%eax),%eax
  803174:	3b 45 08             	cmp    0x8(%ebp),%eax
  803177:	0f 86 d1 00 00 00    	jbe    80324e <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80317d:	a1 48 51 80 00       	mov    0x805148,%eax
  803182:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	8b 50 08             	mov    0x8(%eax),%edx
  80318b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803194:	8b 55 08             	mov    0x8(%ebp),%edx
  803197:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80319a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80319e:	75 17                	jne    8031b7 <alloc_block_NF+0x4f9>
  8031a0:	83 ec 04             	sub    $0x4,%esp
  8031a3:	68 a0 45 80 00       	push   $0x8045a0
  8031a8:	68 1c 01 00 00       	push   $0x11c
  8031ad:	68 f7 44 80 00       	push   $0x8044f7
  8031b2:	e8 05 d6 ff ff       	call   8007bc <_panic>
  8031b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ba:	8b 00                	mov    (%eax),%eax
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	74 10                	je     8031d0 <alloc_block_NF+0x512>
  8031c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c3:	8b 00                	mov    (%eax),%eax
  8031c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031c8:	8b 52 04             	mov    0x4(%edx),%edx
  8031cb:	89 50 04             	mov    %edx,0x4(%eax)
  8031ce:	eb 0b                	jmp    8031db <alloc_block_NF+0x51d>
  8031d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d3:	8b 40 04             	mov    0x4(%eax),%eax
  8031d6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031de:	8b 40 04             	mov    0x4(%eax),%eax
  8031e1:	85 c0                	test   %eax,%eax
  8031e3:	74 0f                	je     8031f4 <alloc_block_NF+0x536>
  8031e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e8:	8b 40 04             	mov    0x4(%eax),%eax
  8031eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031ee:	8b 12                	mov    (%edx),%edx
  8031f0:	89 10                	mov    %edx,(%eax)
  8031f2:	eb 0a                	jmp    8031fe <alloc_block_NF+0x540>
  8031f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f7:	8b 00                	mov    (%eax),%eax
  8031f9:	a3 48 51 80 00       	mov    %eax,0x805148
  8031fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803201:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803207:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803211:	a1 54 51 80 00       	mov    0x805154,%eax
  803216:	48                   	dec    %eax
  803217:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80321c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321f:	8b 40 08             	mov    0x8(%eax),%eax
  803222:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322a:	8b 50 08             	mov    0x8(%eax),%edx
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	01 c2                	add    %eax,%edx
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323b:	8b 40 0c             	mov    0xc(%eax),%eax
  80323e:	2b 45 08             	sub    0x8(%ebp),%eax
  803241:	89 c2                	mov    %eax,%edx
  803243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803246:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803249:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324c:	eb 3b                	jmp    803289 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80324e:	a1 40 51 80 00       	mov    0x805140,%eax
  803253:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803256:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325a:	74 07                	je     803263 <alloc_block_NF+0x5a5>
  80325c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325f:	8b 00                	mov    (%eax),%eax
  803261:	eb 05                	jmp    803268 <alloc_block_NF+0x5aa>
  803263:	b8 00 00 00 00       	mov    $0x0,%eax
  803268:	a3 40 51 80 00       	mov    %eax,0x805140
  80326d:	a1 40 51 80 00       	mov    0x805140,%eax
  803272:	85 c0                	test   %eax,%eax
  803274:	0f 85 2e fe ff ff    	jne    8030a8 <alloc_block_NF+0x3ea>
  80327a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327e:	0f 85 24 fe ff ff    	jne    8030a8 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803284:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803289:	c9                   	leave  
  80328a:	c3                   	ret    

0080328b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80328b:	55                   	push   %ebp
  80328c:	89 e5                	mov    %esp,%ebp
  80328e:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803291:	a1 38 51 80 00       	mov    0x805138,%eax
  803296:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803299:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80329e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8032a1:	a1 38 51 80 00       	mov    0x805138,%eax
  8032a6:	85 c0                	test   %eax,%eax
  8032a8:	74 14                	je     8032be <insert_sorted_with_merge_freeList+0x33>
  8032aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ad:	8b 50 08             	mov    0x8(%eax),%edx
  8032b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b3:	8b 40 08             	mov    0x8(%eax),%eax
  8032b6:	39 c2                	cmp    %eax,%edx
  8032b8:	0f 87 9b 01 00 00    	ja     803459 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8032be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c2:	75 17                	jne    8032db <insert_sorted_with_merge_freeList+0x50>
  8032c4:	83 ec 04             	sub    $0x4,%esp
  8032c7:	68 d4 44 80 00       	push   $0x8044d4
  8032cc:	68 38 01 00 00       	push   $0x138
  8032d1:	68 f7 44 80 00       	push   $0x8044f7
  8032d6:	e8 e1 d4 ff ff       	call   8007bc <_panic>
  8032db:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e4:	89 10                	mov    %edx,(%eax)
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	8b 00                	mov    (%eax),%eax
  8032eb:	85 c0                	test   %eax,%eax
  8032ed:	74 0d                	je     8032fc <insert_sorted_with_merge_freeList+0x71>
  8032ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8032f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f7:	89 50 04             	mov    %edx,0x4(%eax)
  8032fa:	eb 08                	jmp    803304 <insert_sorted_with_merge_freeList+0x79>
  8032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803304:	8b 45 08             	mov    0x8(%ebp),%eax
  803307:	a3 38 51 80 00       	mov    %eax,0x805138
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803316:	a1 44 51 80 00       	mov    0x805144,%eax
  80331b:	40                   	inc    %eax
  80331c:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803321:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803325:	0f 84 a8 06 00 00    	je     8039d3 <insert_sorted_with_merge_freeList+0x748>
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	8b 50 08             	mov    0x8(%eax),%edx
  803331:	8b 45 08             	mov    0x8(%ebp),%eax
  803334:	8b 40 0c             	mov    0xc(%eax),%eax
  803337:	01 c2                	add    %eax,%edx
  803339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333c:	8b 40 08             	mov    0x8(%eax),%eax
  80333f:	39 c2                	cmp    %eax,%edx
  803341:	0f 85 8c 06 00 00    	jne    8039d3 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803347:	8b 45 08             	mov    0x8(%ebp),%eax
  80334a:	8b 50 0c             	mov    0xc(%eax),%edx
  80334d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803350:	8b 40 0c             	mov    0xc(%eax),%eax
  803353:	01 c2                	add    %eax,%edx
  803355:	8b 45 08             	mov    0x8(%ebp),%eax
  803358:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80335b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80335f:	75 17                	jne    803378 <insert_sorted_with_merge_freeList+0xed>
  803361:	83 ec 04             	sub    $0x4,%esp
  803364:	68 a0 45 80 00       	push   $0x8045a0
  803369:	68 3c 01 00 00       	push   $0x13c
  80336e:	68 f7 44 80 00       	push   $0x8044f7
  803373:	e8 44 d4 ff ff       	call   8007bc <_panic>
  803378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337b:	8b 00                	mov    (%eax),%eax
  80337d:	85 c0                	test   %eax,%eax
  80337f:	74 10                	je     803391 <insert_sorted_with_merge_freeList+0x106>
  803381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803384:	8b 00                	mov    (%eax),%eax
  803386:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803389:	8b 52 04             	mov    0x4(%edx),%edx
  80338c:	89 50 04             	mov    %edx,0x4(%eax)
  80338f:	eb 0b                	jmp    80339c <insert_sorted_with_merge_freeList+0x111>
  803391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803394:	8b 40 04             	mov    0x4(%eax),%eax
  803397:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80339c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339f:	8b 40 04             	mov    0x4(%eax),%eax
  8033a2:	85 c0                	test   %eax,%eax
  8033a4:	74 0f                	je     8033b5 <insert_sorted_with_merge_freeList+0x12a>
  8033a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a9:	8b 40 04             	mov    0x4(%eax),%eax
  8033ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033af:	8b 12                	mov    (%edx),%edx
  8033b1:	89 10                	mov    %edx,(%eax)
  8033b3:	eb 0a                	jmp    8033bf <insert_sorted_with_merge_freeList+0x134>
  8033b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b8:	8b 00                	mov    (%eax),%eax
  8033ba:	a3 38 51 80 00       	mov    %eax,0x805138
  8033bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d2:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d7:	48                   	dec    %eax
  8033d8:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8033dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8033e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8033f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033f5:	75 17                	jne    80340e <insert_sorted_with_merge_freeList+0x183>
  8033f7:	83 ec 04             	sub    $0x4,%esp
  8033fa:	68 d4 44 80 00       	push   $0x8044d4
  8033ff:	68 3f 01 00 00       	push   $0x13f
  803404:	68 f7 44 80 00       	push   $0x8044f7
  803409:	e8 ae d3 ff ff       	call   8007bc <_panic>
  80340e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803417:	89 10                	mov    %edx,(%eax)
  803419:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341c:	8b 00                	mov    (%eax),%eax
  80341e:	85 c0                	test   %eax,%eax
  803420:	74 0d                	je     80342f <insert_sorted_with_merge_freeList+0x1a4>
  803422:	a1 48 51 80 00       	mov    0x805148,%eax
  803427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80342a:	89 50 04             	mov    %edx,0x4(%eax)
  80342d:	eb 08                	jmp    803437 <insert_sorted_with_merge_freeList+0x1ac>
  80342f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803432:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343a:	a3 48 51 80 00       	mov    %eax,0x805148
  80343f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803442:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803449:	a1 54 51 80 00       	mov    0x805154,%eax
  80344e:	40                   	inc    %eax
  80344f:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803454:	e9 7a 05 00 00       	jmp    8039d3 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	8b 50 08             	mov    0x8(%eax),%edx
  80345f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803462:	8b 40 08             	mov    0x8(%eax),%eax
  803465:	39 c2                	cmp    %eax,%edx
  803467:	0f 82 14 01 00 00    	jb     803581 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80346d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803470:	8b 50 08             	mov    0x8(%eax),%edx
  803473:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803476:	8b 40 0c             	mov    0xc(%eax),%eax
  803479:	01 c2                	add    %eax,%edx
  80347b:	8b 45 08             	mov    0x8(%ebp),%eax
  80347e:	8b 40 08             	mov    0x8(%eax),%eax
  803481:	39 c2                	cmp    %eax,%edx
  803483:	0f 85 90 00 00 00    	jne    803519 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80348c:	8b 50 0c             	mov    0xc(%eax),%edx
  80348f:	8b 45 08             	mov    0x8(%ebp),%eax
  803492:	8b 40 0c             	mov    0xc(%eax),%eax
  803495:	01 c2                	add    %eax,%edx
  803497:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80349a:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80349d:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8034a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b5:	75 17                	jne    8034ce <insert_sorted_with_merge_freeList+0x243>
  8034b7:	83 ec 04             	sub    $0x4,%esp
  8034ba:	68 d4 44 80 00       	push   $0x8044d4
  8034bf:	68 49 01 00 00       	push   $0x149
  8034c4:	68 f7 44 80 00       	push   $0x8044f7
  8034c9:	e8 ee d2 ff ff       	call   8007bc <_panic>
  8034ce:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d7:	89 10                	mov    %edx,(%eax)
  8034d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dc:	8b 00                	mov    (%eax),%eax
  8034de:	85 c0                	test   %eax,%eax
  8034e0:	74 0d                	je     8034ef <insert_sorted_with_merge_freeList+0x264>
  8034e2:	a1 48 51 80 00       	mov    0x805148,%eax
  8034e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ea:	89 50 04             	mov    %edx,0x4(%eax)
  8034ed:	eb 08                	jmp    8034f7 <insert_sorted_with_merge_freeList+0x26c>
  8034ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fa:	a3 48 51 80 00       	mov    %eax,0x805148
  8034ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803502:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803509:	a1 54 51 80 00       	mov    0x805154,%eax
  80350e:	40                   	inc    %eax
  80350f:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803514:	e9 bb 04 00 00       	jmp    8039d4 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803519:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80351d:	75 17                	jne    803536 <insert_sorted_with_merge_freeList+0x2ab>
  80351f:	83 ec 04             	sub    $0x4,%esp
  803522:	68 48 45 80 00       	push   $0x804548
  803527:	68 4c 01 00 00       	push   $0x14c
  80352c:	68 f7 44 80 00       	push   $0x8044f7
  803531:	e8 86 d2 ff ff       	call   8007bc <_panic>
  803536:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80353c:	8b 45 08             	mov    0x8(%ebp),%eax
  80353f:	89 50 04             	mov    %edx,0x4(%eax)
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	8b 40 04             	mov    0x4(%eax),%eax
  803548:	85 c0                	test   %eax,%eax
  80354a:	74 0c                	je     803558 <insert_sorted_with_merge_freeList+0x2cd>
  80354c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803551:	8b 55 08             	mov    0x8(%ebp),%edx
  803554:	89 10                	mov    %edx,(%eax)
  803556:	eb 08                	jmp    803560 <insert_sorted_with_merge_freeList+0x2d5>
  803558:	8b 45 08             	mov    0x8(%ebp),%eax
  80355b:	a3 38 51 80 00       	mov    %eax,0x805138
  803560:	8b 45 08             	mov    0x8(%ebp),%eax
  803563:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803568:	8b 45 08             	mov    0x8(%ebp),%eax
  80356b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803571:	a1 44 51 80 00       	mov    0x805144,%eax
  803576:	40                   	inc    %eax
  803577:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80357c:	e9 53 04 00 00       	jmp    8039d4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803581:	a1 38 51 80 00       	mov    0x805138,%eax
  803586:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803589:	e9 15 04 00 00       	jmp    8039a3 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803591:	8b 00                	mov    (%eax),%eax
  803593:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803596:	8b 45 08             	mov    0x8(%ebp),%eax
  803599:	8b 50 08             	mov    0x8(%eax),%edx
  80359c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359f:	8b 40 08             	mov    0x8(%eax),%eax
  8035a2:	39 c2                	cmp    %eax,%edx
  8035a4:	0f 86 f1 03 00 00    	jbe    80399b <insert_sorted_with_merge_freeList+0x710>
  8035aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ad:	8b 50 08             	mov    0x8(%eax),%edx
  8035b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b3:	8b 40 08             	mov    0x8(%eax),%eax
  8035b6:	39 c2                	cmp    %eax,%edx
  8035b8:	0f 83 dd 03 00 00    	jae    80399b <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c1:	8b 50 08             	mov    0x8(%eax),%edx
  8035c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ca:	01 c2                	add    %eax,%edx
  8035cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cf:	8b 40 08             	mov    0x8(%eax),%eax
  8035d2:	39 c2                	cmp    %eax,%edx
  8035d4:	0f 85 b9 01 00 00    	jne    803793 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8035da:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dd:	8b 50 08             	mov    0x8(%eax),%edx
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e6:	01 c2                	add    %eax,%edx
  8035e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035eb:	8b 40 08             	mov    0x8(%eax),%eax
  8035ee:	39 c2                	cmp    %eax,%edx
  8035f0:	0f 85 0d 01 00 00    	jne    803703 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8035f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8035fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803602:	01 c2                	add    %eax,%edx
  803604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803607:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80360a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80360e:	75 17                	jne    803627 <insert_sorted_with_merge_freeList+0x39c>
  803610:	83 ec 04             	sub    $0x4,%esp
  803613:	68 a0 45 80 00       	push   $0x8045a0
  803618:	68 5c 01 00 00       	push   $0x15c
  80361d:	68 f7 44 80 00       	push   $0x8044f7
  803622:	e8 95 d1 ff ff       	call   8007bc <_panic>
  803627:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362a:	8b 00                	mov    (%eax),%eax
  80362c:	85 c0                	test   %eax,%eax
  80362e:	74 10                	je     803640 <insert_sorted_with_merge_freeList+0x3b5>
  803630:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803633:	8b 00                	mov    (%eax),%eax
  803635:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803638:	8b 52 04             	mov    0x4(%edx),%edx
  80363b:	89 50 04             	mov    %edx,0x4(%eax)
  80363e:	eb 0b                	jmp    80364b <insert_sorted_with_merge_freeList+0x3c0>
  803640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803643:	8b 40 04             	mov    0x4(%eax),%eax
  803646:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80364b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364e:	8b 40 04             	mov    0x4(%eax),%eax
  803651:	85 c0                	test   %eax,%eax
  803653:	74 0f                	je     803664 <insert_sorted_with_merge_freeList+0x3d9>
  803655:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803658:	8b 40 04             	mov    0x4(%eax),%eax
  80365b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80365e:	8b 12                	mov    (%edx),%edx
  803660:	89 10                	mov    %edx,(%eax)
  803662:	eb 0a                	jmp    80366e <insert_sorted_with_merge_freeList+0x3e3>
  803664:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803667:	8b 00                	mov    (%eax),%eax
  803669:	a3 38 51 80 00       	mov    %eax,0x805138
  80366e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803671:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803677:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803681:	a1 44 51 80 00       	mov    0x805144,%eax
  803686:	48                   	dec    %eax
  803687:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80368c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803699:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8036a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036a4:	75 17                	jne    8036bd <insert_sorted_with_merge_freeList+0x432>
  8036a6:	83 ec 04             	sub    $0x4,%esp
  8036a9:	68 d4 44 80 00       	push   $0x8044d4
  8036ae:	68 5f 01 00 00       	push   $0x15f
  8036b3:	68 f7 44 80 00       	push   $0x8044f7
  8036b8:	e8 ff d0 ff ff       	call   8007bc <_panic>
  8036bd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c6:	89 10                	mov    %edx,(%eax)
  8036c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cb:	8b 00                	mov    (%eax),%eax
  8036cd:	85 c0                	test   %eax,%eax
  8036cf:	74 0d                	je     8036de <insert_sorted_with_merge_freeList+0x453>
  8036d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8036d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036d9:	89 50 04             	mov    %edx,0x4(%eax)
  8036dc:	eb 08                	jmp    8036e6 <insert_sorted_with_merge_freeList+0x45b>
  8036de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e9:	a3 48 51 80 00       	mov    %eax,0x805148
  8036ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8036fd:	40                   	inc    %eax
  8036fe:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803706:	8b 50 0c             	mov    0xc(%eax),%edx
  803709:	8b 45 08             	mov    0x8(%ebp),%eax
  80370c:	8b 40 0c             	mov    0xc(%eax),%eax
  80370f:	01 c2                	add    %eax,%edx
  803711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803714:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803717:	8b 45 08             	mov    0x8(%ebp),%eax
  80371a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803721:	8b 45 08             	mov    0x8(%ebp),%eax
  803724:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80372b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80372f:	75 17                	jne    803748 <insert_sorted_with_merge_freeList+0x4bd>
  803731:	83 ec 04             	sub    $0x4,%esp
  803734:	68 d4 44 80 00       	push   $0x8044d4
  803739:	68 64 01 00 00       	push   $0x164
  80373e:	68 f7 44 80 00       	push   $0x8044f7
  803743:	e8 74 d0 ff ff       	call   8007bc <_panic>
  803748:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80374e:	8b 45 08             	mov    0x8(%ebp),%eax
  803751:	89 10                	mov    %edx,(%eax)
  803753:	8b 45 08             	mov    0x8(%ebp),%eax
  803756:	8b 00                	mov    (%eax),%eax
  803758:	85 c0                	test   %eax,%eax
  80375a:	74 0d                	je     803769 <insert_sorted_with_merge_freeList+0x4de>
  80375c:	a1 48 51 80 00       	mov    0x805148,%eax
  803761:	8b 55 08             	mov    0x8(%ebp),%edx
  803764:	89 50 04             	mov    %edx,0x4(%eax)
  803767:	eb 08                	jmp    803771 <insert_sorted_with_merge_freeList+0x4e6>
  803769:	8b 45 08             	mov    0x8(%ebp),%eax
  80376c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803771:	8b 45 08             	mov    0x8(%ebp),%eax
  803774:	a3 48 51 80 00       	mov    %eax,0x805148
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803783:	a1 54 51 80 00       	mov    0x805154,%eax
  803788:	40                   	inc    %eax
  803789:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80378e:	e9 41 02 00 00       	jmp    8039d4 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803793:	8b 45 08             	mov    0x8(%ebp),%eax
  803796:	8b 50 08             	mov    0x8(%eax),%edx
  803799:	8b 45 08             	mov    0x8(%ebp),%eax
  80379c:	8b 40 0c             	mov    0xc(%eax),%eax
  80379f:	01 c2                	add    %eax,%edx
  8037a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a4:	8b 40 08             	mov    0x8(%eax),%eax
  8037a7:	39 c2                	cmp    %eax,%edx
  8037a9:	0f 85 7c 01 00 00    	jne    80392b <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8037af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037b3:	74 06                	je     8037bb <insert_sorted_with_merge_freeList+0x530>
  8037b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037b9:	75 17                	jne    8037d2 <insert_sorted_with_merge_freeList+0x547>
  8037bb:	83 ec 04             	sub    $0x4,%esp
  8037be:	68 10 45 80 00       	push   $0x804510
  8037c3:	68 69 01 00 00       	push   $0x169
  8037c8:	68 f7 44 80 00       	push   $0x8044f7
  8037cd:	e8 ea cf ff ff       	call   8007bc <_panic>
  8037d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d5:	8b 50 04             	mov    0x4(%eax),%edx
  8037d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037db:	89 50 04             	mov    %edx,0x4(%eax)
  8037de:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037e4:	89 10                	mov    %edx,(%eax)
  8037e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e9:	8b 40 04             	mov    0x4(%eax),%eax
  8037ec:	85 c0                	test   %eax,%eax
  8037ee:	74 0d                	je     8037fd <insert_sorted_with_merge_freeList+0x572>
  8037f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f3:	8b 40 04             	mov    0x4(%eax),%eax
  8037f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8037f9:	89 10                	mov    %edx,(%eax)
  8037fb:	eb 08                	jmp    803805 <insert_sorted_with_merge_freeList+0x57a>
  8037fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803800:	a3 38 51 80 00       	mov    %eax,0x805138
  803805:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803808:	8b 55 08             	mov    0x8(%ebp),%edx
  80380b:	89 50 04             	mov    %edx,0x4(%eax)
  80380e:	a1 44 51 80 00       	mov    0x805144,%eax
  803813:	40                   	inc    %eax
  803814:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803819:	8b 45 08             	mov    0x8(%ebp),%eax
  80381c:	8b 50 0c             	mov    0xc(%eax),%edx
  80381f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803822:	8b 40 0c             	mov    0xc(%eax),%eax
  803825:	01 c2                	add    %eax,%edx
  803827:	8b 45 08             	mov    0x8(%ebp),%eax
  80382a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80382d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803831:	75 17                	jne    80384a <insert_sorted_with_merge_freeList+0x5bf>
  803833:	83 ec 04             	sub    $0x4,%esp
  803836:	68 a0 45 80 00       	push   $0x8045a0
  80383b:	68 6b 01 00 00       	push   $0x16b
  803840:	68 f7 44 80 00       	push   $0x8044f7
  803845:	e8 72 cf ff ff       	call   8007bc <_panic>
  80384a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384d:	8b 00                	mov    (%eax),%eax
  80384f:	85 c0                	test   %eax,%eax
  803851:	74 10                	je     803863 <insert_sorted_with_merge_freeList+0x5d8>
  803853:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803856:	8b 00                	mov    (%eax),%eax
  803858:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80385b:	8b 52 04             	mov    0x4(%edx),%edx
  80385e:	89 50 04             	mov    %edx,0x4(%eax)
  803861:	eb 0b                	jmp    80386e <insert_sorted_with_merge_freeList+0x5e3>
  803863:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803866:	8b 40 04             	mov    0x4(%eax),%eax
  803869:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80386e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803871:	8b 40 04             	mov    0x4(%eax),%eax
  803874:	85 c0                	test   %eax,%eax
  803876:	74 0f                	je     803887 <insert_sorted_with_merge_freeList+0x5fc>
  803878:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387b:	8b 40 04             	mov    0x4(%eax),%eax
  80387e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803881:	8b 12                	mov    (%edx),%edx
  803883:	89 10                	mov    %edx,(%eax)
  803885:	eb 0a                	jmp    803891 <insert_sorted_with_merge_freeList+0x606>
  803887:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80388a:	8b 00                	mov    (%eax),%eax
  80388c:	a3 38 51 80 00       	mov    %eax,0x805138
  803891:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803894:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80389a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a4:	a1 44 51 80 00       	mov    0x805144,%eax
  8038a9:	48                   	dec    %eax
  8038aa:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8038af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8038b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038bc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8038c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038c7:	75 17                	jne    8038e0 <insert_sorted_with_merge_freeList+0x655>
  8038c9:	83 ec 04             	sub    $0x4,%esp
  8038cc:	68 d4 44 80 00       	push   $0x8044d4
  8038d1:	68 6e 01 00 00       	push   $0x16e
  8038d6:	68 f7 44 80 00       	push   $0x8044f7
  8038db:	e8 dc ce ff ff       	call   8007bc <_panic>
  8038e0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e9:	89 10                	mov    %edx,(%eax)
  8038eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ee:	8b 00                	mov    (%eax),%eax
  8038f0:	85 c0                	test   %eax,%eax
  8038f2:	74 0d                	je     803901 <insert_sorted_with_merge_freeList+0x676>
  8038f4:	a1 48 51 80 00       	mov    0x805148,%eax
  8038f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038fc:	89 50 04             	mov    %edx,0x4(%eax)
  8038ff:	eb 08                	jmp    803909 <insert_sorted_with_merge_freeList+0x67e>
  803901:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803904:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803909:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390c:	a3 48 51 80 00       	mov    %eax,0x805148
  803911:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803914:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80391b:	a1 54 51 80 00       	mov    0x805154,%eax
  803920:	40                   	inc    %eax
  803921:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803926:	e9 a9 00 00 00       	jmp    8039d4 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80392b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80392f:	74 06                	je     803937 <insert_sorted_with_merge_freeList+0x6ac>
  803931:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803935:	75 17                	jne    80394e <insert_sorted_with_merge_freeList+0x6c3>
  803937:	83 ec 04             	sub    $0x4,%esp
  80393a:	68 6c 45 80 00       	push   $0x80456c
  80393f:	68 73 01 00 00       	push   $0x173
  803944:	68 f7 44 80 00       	push   $0x8044f7
  803949:	e8 6e ce ff ff       	call   8007bc <_panic>
  80394e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803951:	8b 10                	mov    (%eax),%edx
  803953:	8b 45 08             	mov    0x8(%ebp),%eax
  803956:	89 10                	mov    %edx,(%eax)
  803958:	8b 45 08             	mov    0x8(%ebp),%eax
  80395b:	8b 00                	mov    (%eax),%eax
  80395d:	85 c0                	test   %eax,%eax
  80395f:	74 0b                	je     80396c <insert_sorted_with_merge_freeList+0x6e1>
  803961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803964:	8b 00                	mov    (%eax),%eax
  803966:	8b 55 08             	mov    0x8(%ebp),%edx
  803969:	89 50 04             	mov    %edx,0x4(%eax)
  80396c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396f:	8b 55 08             	mov    0x8(%ebp),%edx
  803972:	89 10                	mov    %edx,(%eax)
  803974:	8b 45 08             	mov    0x8(%ebp),%eax
  803977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80397a:	89 50 04             	mov    %edx,0x4(%eax)
  80397d:	8b 45 08             	mov    0x8(%ebp),%eax
  803980:	8b 00                	mov    (%eax),%eax
  803982:	85 c0                	test   %eax,%eax
  803984:	75 08                	jne    80398e <insert_sorted_with_merge_freeList+0x703>
  803986:	8b 45 08             	mov    0x8(%ebp),%eax
  803989:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80398e:	a1 44 51 80 00       	mov    0x805144,%eax
  803993:	40                   	inc    %eax
  803994:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803999:	eb 39                	jmp    8039d4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80399b:	a1 40 51 80 00       	mov    0x805140,%eax
  8039a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039a7:	74 07                	je     8039b0 <insert_sorted_with_merge_freeList+0x725>
  8039a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ac:	8b 00                	mov    (%eax),%eax
  8039ae:	eb 05                	jmp    8039b5 <insert_sorted_with_merge_freeList+0x72a>
  8039b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8039b5:	a3 40 51 80 00       	mov    %eax,0x805140
  8039ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8039bf:	85 c0                	test   %eax,%eax
  8039c1:	0f 85 c7 fb ff ff    	jne    80358e <insert_sorted_with_merge_freeList+0x303>
  8039c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039cb:	0f 85 bd fb ff ff    	jne    80358e <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039d1:	eb 01                	jmp    8039d4 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8039d3:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039d4:	90                   	nop
  8039d5:	c9                   	leave  
  8039d6:	c3                   	ret    
  8039d7:	90                   	nop

008039d8 <__udivdi3>:
  8039d8:	55                   	push   %ebp
  8039d9:	57                   	push   %edi
  8039da:	56                   	push   %esi
  8039db:	53                   	push   %ebx
  8039dc:	83 ec 1c             	sub    $0x1c,%esp
  8039df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039ef:	89 ca                	mov    %ecx,%edx
  8039f1:	89 f8                	mov    %edi,%eax
  8039f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039f7:	85 f6                	test   %esi,%esi
  8039f9:	75 2d                	jne    803a28 <__udivdi3+0x50>
  8039fb:	39 cf                	cmp    %ecx,%edi
  8039fd:	77 65                	ja     803a64 <__udivdi3+0x8c>
  8039ff:	89 fd                	mov    %edi,%ebp
  803a01:	85 ff                	test   %edi,%edi
  803a03:	75 0b                	jne    803a10 <__udivdi3+0x38>
  803a05:	b8 01 00 00 00       	mov    $0x1,%eax
  803a0a:	31 d2                	xor    %edx,%edx
  803a0c:	f7 f7                	div    %edi
  803a0e:	89 c5                	mov    %eax,%ebp
  803a10:	31 d2                	xor    %edx,%edx
  803a12:	89 c8                	mov    %ecx,%eax
  803a14:	f7 f5                	div    %ebp
  803a16:	89 c1                	mov    %eax,%ecx
  803a18:	89 d8                	mov    %ebx,%eax
  803a1a:	f7 f5                	div    %ebp
  803a1c:	89 cf                	mov    %ecx,%edi
  803a1e:	89 fa                	mov    %edi,%edx
  803a20:	83 c4 1c             	add    $0x1c,%esp
  803a23:	5b                   	pop    %ebx
  803a24:	5e                   	pop    %esi
  803a25:	5f                   	pop    %edi
  803a26:	5d                   	pop    %ebp
  803a27:	c3                   	ret    
  803a28:	39 ce                	cmp    %ecx,%esi
  803a2a:	77 28                	ja     803a54 <__udivdi3+0x7c>
  803a2c:	0f bd fe             	bsr    %esi,%edi
  803a2f:	83 f7 1f             	xor    $0x1f,%edi
  803a32:	75 40                	jne    803a74 <__udivdi3+0x9c>
  803a34:	39 ce                	cmp    %ecx,%esi
  803a36:	72 0a                	jb     803a42 <__udivdi3+0x6a>
  803a38:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a3c:	0f 87 9e 00 00 00    	ja     803ae0 <__udivdi3+0x108>
  803a42:	b8 01 00 00 00       	mov    $0x1,%eax
  803a47:	89 fa                	mov    %edi,%edx
  803a49:	83 c4 1c             	add    $0x1c,%esp
  803a4c:	5b                   	pop    %ebx
  803a4d:	5e                   	pop    %esi
  803a4e:	5f                   	pop    %edi
  803a4f:	5d                   	pop    %ebp
  803a50:	c3                   	ret    
  803a51:	8d 76 00             	lea    0x0(%esi),%esi
  803a54:	31 ff                	xor    %edi,%edi
  803a56:	31 c0                	xor    %eax,%eax
  803a58:	89 fa                	mov    %edi,%edx
  803a5a:	83 c4 1c             	add    $0x1c,%esp
  803a5d:	5b                   	pop    %ebx
  803a5e:	5e                   	pop    %esi
  803a5f:	5f                   	pop    %edi
  803a60:	5d                   	pop    %ebp
  803a61:	c3                   	ret    
  803a62:	66 90                	xchg   %ax,%ax
  803a64:	89 d8                	mov    %ebx,%eax
  803a66:	f7 f7                	div    %edi
  803a68:	31 ff                	xor    %edi,%edi
  803a6a:	89 fa                	mov    %edi,%edx
  803a6c:	83 c4 1c             	add    $0x1c,%esp
  803a6f:	5b                   	pop    %ebx
  803a70:	5e                   	pop    %esi
  803a71:	5f                   	pop    %edi
  803a72:	5d                   	pop    %ebp
  803a73:	c3                   	ret    
  803a74:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a79:	89 eb                	mov    %ebp,%ebx
  803a7b:	29 fb                	sub    %edi,%ebx
  803a7d:	89 f9                	mov    %edi,%ecx
  803a7f:	d3 e6                	shl    %cl,%esi
  803a81:	89 c5                	mov    %eax,%ebp
  803a83:	88 d9                	mov    %bl,%cl
  803a85:	d3 ed                	shr    %cl,%ebp
  803a87:	89 e9                	mov    %ebp,%ecx
  803a89:	09 f1                	or     %esi,%ecx
  803a8b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a8f:	89 f9                	mov    %edi,%ecx
  803a91:	d3 e0                	shl    %cl,%eax
  803a93:	89 c5                	mov    %eax,%ebp
  803a95:	89 d6                	mov    %edx,%esi
  803a97:	88 d9                	mov    %bl,%cl
  803a99:	d3 ee                	shr    %cl,%esi
  803a9b:	89 f9                	mov    %edi,%ecx
  803a9d:	d3 e2                	shl    %cl,%edx
  803a9f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aa3:	88 d9                	mov    %bl,%cl
  803aa5:	d3 e8                	shr    %cl,%eax
  803aa7:	09 c2                	or     %eax,%edx
  803aa9:	89 d0                	mov    %edx,%eax
  803aab:	89 f2                	mov    %esi,%edx
  803aad:	f7 74 24 0c          	divl   0xc(%esp)
  803ab1:	89 d6                	mov    %edx,%esi
  803ab3:	89 c3                	mov    %eax,%ebx
  803ab5:	f7 e5                	mul    %ebp
  803ab7:	39 d6                	cmp    %edx,%esi
  803ab9:	72 19                	jb     803ad4 <__udivdi3+0xfc>
  803abb:	74 0b                	je     803ac8 <__udivdi3+0xf0>
  803abd:	89 d8                	mov    %ebx,%eax
  803abf:	31 ff                	xor    %edi,%edi
  803ac1:	e9 58 ff ff ff       	jmp    803a1e <__udivdi3+0x46>
  803ac6:	66 90                	xchg   %ax,%ax
  803ac8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803acc:	89 f9                	mov    %edi,%ecx
  803ace:	d3 e2                	shl    %cl,%edx
  803ad0:	39 c2                	cmp    %eax,%edx
  803ad2:	73 e9                	jae    803abd <__udivdi3+0xe5>
  803ad4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ad7:	31 ff                	xor    %edi,%edi
  803ad9:	e9 40 ff ff ff       	jmp    803a1e <__udivdi3+0x46>
  803ade:	66 90                	xchg   %ax,%ax
  803ae0:	31 c0                	xor    %eax,%eax
  803ae2:	e9 37 ff ff ff       	jmp    803a1e <__udivdi3+0x46>
  803ae7:	90                   	nop

00803ae8 <__umoddi3>:
  803ae8:	55                   	push   %ebp
  803ae9:	57                   	push   %edi
  803aea:	56                   	push   %esi
  803aeb:	53                   	push   %ebx
  803aec:	83 ec 1c             	sub    $0x1c,%esp
  803aef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803af3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803af7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803afb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803aff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b07:	89 f3                	mov    %esi,%ebx
  803b09:	89 fa                	mov    %edi,%edx
  803b0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b0f:	89 34 24             	mov    %esi,(%esp)
  803b12:	85 c0                	test   %eax,%eax
  803b14:	75 1a                	jne    803b30 <__umoddi3+0x48>
  803b16:	39 f7                	cmp    %esi,%edi
  803b18:	0f 86 a2 00 00 00    	jbe    803bc0 <__umoddi3+0xd8>
  803b1e:	89 c8                	mov    %ecx,%eax
  803b20:	89 f2                	mov    %esi,%edx
  803b22:	f7 f7                	div    %edi
  803b24:	89 d0                	mov    %edx,%eax
  803b26:	31 d2                	xor    %edx,%edx
  803b28:	83 c4 1c             	add    $0x1c,%esp
  803b2b:	5b                   	pop    %ebx
  803b2c:	5e                   	pop    %esi
  803b2d:	5f                   	pop    %edi
  803b2e:	5d                   	pop    %ebp
  803b2f:	c3                   	ret    
  803b30:	39 f0                	cmp    %esi,%eax
  803b32:	0f 87 ac 00 00 00    	ja     803be4 <__umoddi3+0xfc>
  803b38:	0f bd e8             	bsr    %eax,%ebp
  803b3b:	83 f5 1f             	xor    $0x1f,%ebp
  803b3e:	0f 84 ac 00 00 00    	je     803bf0 <__umoddi3+0x108>
  803b44:	bf 20 00 00 00       	mov    $0x20,%edi
  803b49:	29 ef                	sub    %ebp,%edi
  803b4b:	89 fe                	mov    %edi,%esi
  803b4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b51:	89 e9                	mov    %ebp,%ecx
  803b53:	d3 e0                	shl    %cl,%eax
  803b55:	89 d7                	mov    %edx,%edi
  803b57:	89 f1                	mov    %esi,%ecx
  803b59:	d3 ef                	shr    %cl,%edi
  803b5b:	09 c7                	or     %eax,%edi
  803b5d:	89 e9                	mov    %ebp,%ecx
  803b5f:	d3 e2                	shl    %cl,%edx
  803b61:	89 14 24             	mov    %edx,(%esp)
  803b64:	89 d8                	mov    %ebx,%eax
  803b66:	d3 e0                	shl    %cl,%eax
  803b68:	89 c2                	mov    %eax,%edx
  803b6a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b6e:	d3 e0                	shl    %cl,%eax
  803b70:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b74:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b78:	89 f1                	mov    %esi,%ecx
  803b7a:	d3 e8                	shr    %cl,%eax
  803b7c:	09 d0                	or     %edx,%eax
  803b7e:	d3 eb                	shr    %cl,%ebx
  803b80:	89 da                	mov    %ebx,%edx
  803b82:	f7 f7                	div    %edi
  803b84:	89 d3                	mov    %edx,%ebx
  803b86:	f7 24 24             	mull   (%esp)
  803b89:	89 c6                	mov    %eax,%esi
  803b8b:	89 d1                	mov    %edx,%ecx
  803b8d:	39 d3                	cmp    %edx,%ebx
  803b8f:	0f 82 87 00 00 00    	jb     803c1c <__umoddi3+0x134>
  803b95:	0f 84 91 00 00 00    	je     803c2c <__umoddi3+0x144>
  803b9b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b9f:	29 f2                	sub    %esi,%edx
  803ba1:	19 cb                	sbb    %ecx,%ebx
  803ba3:	89 d8                	mov    %ebx,%eax
  803ba5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ba9:	d3 e0                	shl    %cl,%eax
  803bab:	89 e9                	mov    %ebp,%ecx
  803bad:	d3 ea                	shr    %cl,%edx
  803baf:	09 d0                	or     %edx,%eax
  803bb1:	89 e9                	mov    %ebp,%ecx
  803bb3:	d3 eb                	shr    %cl,%ebx
  803bb5:	89 da                	mov    %ebx,%edx
  803bb7:	83 c4 1c             	add    $0x1c,%esp
  803bba:	5b                   	pop    %ebx
  803bbb:	5e                   	pop    %esi
  803bbc:	5f                   	pop    %edi
  803bbd:	5d                   	pop    %ebp
  803bbe:	c3                   	ret    
  803bbf:	90                   	nop
  803bc0:	89 fd                	mov    %edi,%ebp
  803bc2:	85 ff                	test   %edi,%edi
  803bc4:	75 0b                	jne    803bd1 <__umoddi3+0xe9>
  803bc6:	b8 01 00 00 00       	mov    $0x1,%eax
  803bcb:	31 d2                	xor    %edx,%edx
  803bcd:	f7 f7                	div    %edi
  803bcf:	89 c5                	mov    %eax,%ebp
  803bd1:	89 f0                	mov    %esi,%eax
  803bd3:	31 d2                	xor    %edx,%edx
  803bd5:	f7 f5                	div    %ebp
  803bd7:	89 c8                	mov    %ecx,%eax
  803bd9:	f7 f5                	div    %ebp
  803bdb:	89 d0                	mov    %edx,%eax
  803bdd:	e9 44 ff ff ff       	jmp    803b26 <__umoddi3+0x3e>
  803be2:	66 90                	xchg   %ax,%ax
  803be4:	89 c8                	mov    %ecx,%eax
  803be6:	89 f2                	mov    %esi,%edx
  803be8:	83 c4 1c             	add    $0x1c,%esp
  803beb:	5b                   	pop    %ebx
  803bec:	5e                   	pop    %esi
  803bed:	5f                   	pop    %edi
  803bee:	5d                   	pop    %ebp
  803bef:	c3                   	ret    
  803bf0:	3b 04 24             	cmp    (%esp),%eax
  803bf3:	72 06                	jb     803bfb <__umoddi3+0x113>
  803bf5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bf9:	77 0f                	ja     803c0a <__umoddi3+0x122>
  803bfb:	89 f2                	mov    %esi,%edx
  803bfd:	29 f9                	sub    %edi,%ecx
  803bff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c03:	89 14 24             	mov    %edx,(%esp)
  803c06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c0e:	8b 14 24             	mov    (%esp),%edx
  803c11:	83 c4 1c             	add    $0x1c,%esp
  803c14:	5b                   	pop    %ebx
  803c15:	5e                   	pop    %esi
  803c16:	5f                   	pop    %edi
  803c17:	5d                   	pop    %ebp
  803c18:	c3                   	ret    
  803c19:	8d 76 00             	lea    0x0(%esi),%esi
  803c1c:	2b 04 24             	sub    (%esp),%eax
  803c1f:	19 fa                	sbb    %edi,%edx
  803c21:	89 d1                	mov    %edx,%ecx
  803c23:	89 c6                	mov    %eax,%esi
  803c25:	e9 71 ff ff ff       	jmp    803b9b <__umoddi3+0xb3>
  803c2a:	66 90                	xchg   %ax,%ax
  803c2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c30:	72 ea                	jb     803c1c <__umoddi3+0x134>
  803c32:	89 d9                	mov    %ebx,%ecx
  803c34:	e9 62 ff ff ff       	jmp    803b9b <__umoddi3+0xb3>
