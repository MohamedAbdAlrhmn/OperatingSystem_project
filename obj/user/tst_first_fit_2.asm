
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
  800045:	e8 e3 20 00 00       	call   80212d <sys_set_uheap_strategy>
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
  80009b:	68 40 3a 80 00       	push   $0x803a40
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 5c 3a 80 00       	push   $0x803a5c
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
  8000f5:	68 74 3a 80 00       	push   $0x803a74
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 5c 3a 80 00       	push   $0x803a5c
  800101:	e8 b6 06 00 00       	call   8007bc <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 0d 1b 00 00       	call   801c18 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 a5 1b 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
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
  80013a:	68 b8 3a 80 00       	push   $0x803ab8
  80013f:	6a 31                	push   $0x31
  800141:	68 5c 3a 80 00       	push   $0x803a5c
  800146:	e8 71 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014b:	e8 68 1b 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  800150:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 e8 3a 80 00       	push   $0x803ae8
  80015d:	6a 33                	push   $0x33
  80015f:	68 5c 3a 80 00       	push   $0x803a5c
  800164:	e8 53 06 00 00       	call   8007bc <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 aa 1a 00 00       	call   801c18 <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 42 1b 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
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
  8001a6:	68 b8 3a 80 00       	push   $0x803ab8
  8001ab:	6a 39                	push   $0x39
  8001ad:	68 5c 3a 80 00       	push   $0x803a5c
  8001b2:	e8 05 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b7:	e8 fc 1a 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  8001bc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 e8 3a 80 00       	push   $0x803ae8
  8001c9:	6a 3b                	push   $0x3b
  8001cb:	68 5c 3a 80 00       	push   $0x803a5c
  8001d0:	e8 e7 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001d5:	e8 3e 1a 00 00       	call   801c18 <sys_calculate_free_frames>
  8001da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001dd:	e8 d6 1a 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
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
  800214:	68 b8 3a 80 00       	push   $0x803ab8
  800219:	6a 41                	push   $0x41
  80021b:	68 5c 3a 80 00       	push   $0x803a5c
  800220:	e8 97 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800225:	e8 8e 1a 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  80022a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 e8 3a 80 00       	push   $0x803ae8
  800237:	6a 43                	push   $0x43
  800239:	68 5c 3a 80 00       	push   $0x803a5c
  80023e:	e8 79 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  800243:	e8 d0 19 00 00       	call   801c18 <sys_calculate_free_frames>
  800248:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80024b:	e8 68 1a 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
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
  80028c:	68 b8 3a 80 00       	push   $0x803ab8
  800291:	6a 49                	push   $0x49
  800293:	68 5c 3a 80 00       	push   $0x803a5c
  800298:	e8 1f 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80029d:	e8 16 1a 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  8002a2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a5:	74 14                	je     8002bb <_main+0x283>
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	68 e8 3a 80 00       	push   $0x803ae8
  8002af:	6a 4b                	push   $0x4b
  8002b1:	68 5c 3a 80 00       	push   $0x803a5c
  8002b6:	e8 01 05 00 00       	call   8007bc <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002bb:	e8 58 19 00 00       	call   801c18 <sys_calculate_free_frames>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c3:	e8 f0 19 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  8002c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002cb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	50                   	push   %eax
  8002d2:	e8 4f 17 00 00       	call   801a26 <free>
  8002d7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8002da:	e8 d9 19 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  8002df:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002e2:	74 14                	je     8002f8 <_main+0x2c0>
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	68 05 3b 80 00       	push   $0x803b05
  8002ec:	6a 52                	push   $0x52
  8002ee:	68 5c 3a 80 00       	push   $0x803a5c
  8002f3:	e8 c4 04 00 00       	call   8007bc <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002f8:	e8 1b 19 00 00       	call   801c18 <sys_calculate_free_frames>
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800300:	e8 b3 19 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
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
  800345:	68 b8 3a 80 00       	push   $0x803ab8
  80034a:	6a 58                	push   $0x58
  80034c:	68 5c 3a 80 00       	push   $0x803a5c
  800351:	e8 66 04 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800356:	e8 5d 19 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  80035b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80035e:	74 14                	je     800374 <_main+0x33c>
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	68 e8 3a 80 00       	push   $0x803ae8
  800368:	6a 5a                	push   $0x5a
  80036a:	68 5c 3a 80 00       	push   $0x803a5c
  80036f:	e8 48 04 00 00       	call   8007bc <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800374:	e8 9f 18 00 00       	call   801c18 <sys_calculate_free_frames>
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037c:	e8 37 19 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800384:	8b 45 90             	mov    -0x70(%ebp),%eax
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	50                   	push   %eax
  80038b:	e8 96 16 00 00       	call   801a26 <free>
  800390:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  800393:	e8 20 19 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  800398:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80039b:	74 14                	je     8003b1 <_main+0x379>
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 05 3b 80 00       	push   $0x803b05
  8003a5:	6a 61                	push   $0x61
  8003a7:	68 5c 3a 80 00       	push   $0x803a5c
  8003ac:	e8 0b 04 00 00       	call   8007bc <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003b1:	e8 62 18 00 00       	call   801c18 <sys_calculate_free_frames>
  8003b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003b9:	e8 fa 18 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
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
  8003fd:	68 b8 3a 80 00       	push   $0x803ab8
  800402:	6a 67                	push   $0x67
  800404:	68 5c 3a 80 00       	push   $0x803a5c
  800409:	e8 ae 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80040e:	e8 a5 18 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  800413:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800416:	74 14                	je     80042c <_main+0x3f4>
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	68 e8 3a 80 00       	push   $0x803ae8
  800420:	6a 69                	push   $0x69
  800422:	68 5c 3a 80 00       	push   $0x803a5c
  800427:	e8 90 03 00 00       	call   8007bc <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  80042c:	e8 e7 17 00 00       	call   801c18 <sys_calculate_free_frames>
  800431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800434:	e8 7f 18 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
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
  800483:	68 b8 3a 80 00       	push   $0x803ab8
  800488:	6a 6f                	push   $0x6f
  80048a:	68 5c 3a 80 00       	push   $0x803a5c
  80048f:	e8 28 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800494:	e8 1f 18 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  800499:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80049c:	74 14                	je     8004b2 <_main+0x47a>
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	68 e8 3a 80 00       	push   $0x803ae8
  8004a6:	6a 71                	push   $0x71
  8004a8:	68 5c 3a 80 00       	push   $0x803a5c
  8004ad:	e8 0a 03 00 00       	call   8007bc <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004b2:	e8 61 17 00 00       	call   801c18 <sys_calculate_free_frames>
  8004b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004ba:	e8 f9 17 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  8004bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  8004c2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	50                   	push   %eax
  8004c9:	e8 58 15 00 00       	call   801a26 <free>
  8004ce:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8004d1:	e8 e2 17 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  8004d6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d9:	74 14                	je     8004ef <_main+0x4b7>
  8004db:	83 ec 04             	sub    $0x4,%esp
  8004de:	68 05 3b 80 00       	push   $0x803b05
  8004e3:	6a 78                	push   $0x78
  8004e5:	68 5c 3a 80 00       	push   $0x803a5c
  8004ea:	e8 cd 02 00 00       	call   8007bc <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 24 17 00 00       	call   801c18 <sys_calculate_free_frames>
  8004f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 bc 17 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8004ff:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	50                   	push   %eax
  800506:	e8 1b 15 00 00       	call   801a26 <free>
  80050b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  80050e:	e8 a5 17 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  800513:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 05 3b 80 00       	push   $0x803b05
  800520:	6a 7f                	push   $0x7f
  800522:	68 5c 3a 80 00       	push   $0x803a5c
  800527:	e8 90 02 00 00       	call   8007bc <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 e7 16 00 00       	call   801c18 <sys_calculate_free_frames>
  800531:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800534:	e8 7f 17 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
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
  800583:	68 b8 3a 80 00       	push   $0x803ab8
  800588:	68 85 00 00 00       	push   $0x85
  80058d:	68 5c 3a 80 00       	push   $0x803a5c
  800592:	e8 25 02 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800597:	e8 1c 17 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  80059c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059f:	74 17                	je     8005b8 <_main+0x580>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 e8 3a 80 00       	push   $0x803ae8
  8005a9:	68 87 00 00 00       	push   $0x87
  8005ae:	68 5c 3a 80 00       	push   $0x803a5c
  8005b3:	e8 04 02 00 00       	call   8007bc <_panic>
		//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8005b8:	e8 5b 16 00 00       	call   801c18 <sys_calculate_free_frames>
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005c0:	e8 f3 16 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
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
  8005f0:	68 b8 3a 80 00       	push   $0x803ab8
  8005f5:	68 95 00 00 00       	push   $0x95
  8005fa:	68 5c 3a 80 00       	push   $0x803a5c
  8005ff:	e8 b8 01 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800604:	e8 af 16 00 00       	call   801cb8 <sys_pf_calculate_allocated_pages>
  800609:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80060c:	74 17                	je     800625 <_main+0x5ed>
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	68 e8 3a 80 00       	push   $0x803ae8
  800616:	68 97 00 00 00       	push   $0x97
  80061b:	68 5c 3a 80 00       	push   $0x803a5c
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
  800654:	68 1c 3b 80 00       	push   $0x803b1c
  800659:	68 a0 00 00 00       	push   $0xa0
  80065e:	68 5c 3a 80 00       	push   $0x803a5c
  800663:	e8 54 01 00 00       	call   8007bc <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	68 80 3b 80 00       	push   $0x803b80
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
  800686:	e8 6d 18 00 00       	call   801ef8 <sys_getenvindex>
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
  8006f1:	e8 0f 16 00 00       	call   801d05 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	68 e4 3b 80 00       	push   $0x803be4
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
  800721:	68 0c 3c 80 00       	push   $0x803c0c
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
  800752:	68 34 3c 80 00       	push   $0x803c34
  800757:	e8 14 03 00 00       	call   800a70 <cprintf>
  80075c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80075f:	a1 20 50 80 00       	mov    0x805020,%eax
  800764:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	50                   	push   %eax
  80076e:	68 8c 3c 80 00       	push   $0x803c8c
  800773:	e8 f8 02 00 00       	call   800a70 <cprintf>
  800778:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	68 e4 3b 80 00       	push   $0x803be4
  800783:	e8 e8 02 00 00       	call   800a70 <cprintf>
  800788:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80078b:	e8 8f 15 00 00       	call   801d1f <sys_enable_interrupt>

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
  8007a3:	e8 1c 17 00 00       	call   801ec4 <sys_destroy_env>
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
  8007b4:	e8 71 17 00 00       	call   801f2a <sys_exit_env>
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
  8007dd:	68 a0 3c 80 00       	push   $0x803ca0
  8007e2:	e8 89 02 00 00       	call   800a70 <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ea:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	50                   	push   %eax
  8007f6:	68 a5 3c 80 00       	push   $0x803ca5
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
  80081a:	68 c1 3c 80 00       	push   $0x803cc1
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
  800846:	68 c4 3c 80 00       	push   $0x803cc4
  80084b:	6a 26                	push   $0x26
  80084d:	68 10 3d 80 00       	push   $0x803d10
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
  800918:	68 1c 3d 80 00       	push   $0x803d1c
  80091d:	6a 3a                	push   $0x3a
  80091f:	68 10 3d 80 00       	push   $0x803d10
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
  800988:	68 70 3d 80 00       	push   $0x803d70
  80098d:	6a 44                	push   $0x44
  80098f:	68 10 3d 80 00       	push   $0x803d10
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
  8009e2:	e8 70 11 00 00       	call   801b57 <sys_cputs>
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
  800a59:	e8 f9 10 00 00       	call   801b57 <sys_cputs>
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
  800aa3:	e8 5d 12 00 00       	call   801d05 <sys_disable_interrupt>
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
  800ac3:	e8 57 12 00 00       	call   801d1f <sys_enable_interrupt>
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
  800b0d:	e8 ca 2c 00 00       	call   8037dc <__udivdi3>
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
  800b5d:	e8 8a 2d 00 00       	call   8038ec <__umoddi3>
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	05 d4 3f 80 00       	add    $0x803fd4,%eax
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
  800cb8:	8b 04 85 f8 3f 80 00 	mov    0x803ff8(,%eax,4),%eax
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
  800d99:	8b 34 9d 40 3e 80 00 	mov    0x803e40(,%ebx,4),%esi
  800da0:	85 f6                	test   %esi,%esi
  800da2:	75 19                	jne    800dbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da4:	53                   	push   %ebx
  800da5:	68 e5 3f 80 00       	push   $0x803fe5
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
  800dbe:	68 ee 3f 80 00       	push   $0x803fee
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
  800deb:	be f1 3f 80 00       	mov    $0x803ff1,%esi
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
  801811:	68 50 41 80 00       	push   $0x804150
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
  8018e1:	e8 b5 03 00 00       	call   801c9b <sys_allocate_chunk>
  8018e6:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018e9:	a1 20 51 80 00       	mov    0x805120,%eax
  8018ee:	83 ec 0c             	sub    $0xc,%esp
  8018f1:	50                   	push   %eax
  8018f2:	e8 2a 0a 00 00       	call   802321 <initialize_MemBlocksList>
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
  80191f:	68 75 41 80 00       	push   $0x804175
  801924:	6a 33                	push   $0x33
  801926:	68 93 41 80 00       	push   $0x804193
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
  80199e:	68 a0 41 80 00       	push   $0x8041a0
  8019a3:	6a 34                	push   $0x34
  8019a5:	68 93 41 80 00       	push   $0x804193
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
  801a13:	68 c4 41 80 00       	push   $0x8041c4
  801a18:	6a 46                	push   $0x46
  801a1a:	68 93 41 80 00       	push   $0x804193
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
  801a2f:	68 ec 41 80 00       	push   $0x8041ec
  801a34:	6a 61                	push   $0x61
  801a36:	68 93 41 80 00       	push   $0x804193
  801a3b:	e8 7c ed ff ff       	call   8007bc <_panic>

00801a40 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 18             	sub    $0x18,%esp
  801a46:	8b 45 10             	mov    0x10(%ebp),%eax
  801a49:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a4c:	e8 a9 fd ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  801a51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a55:	75 07                	jne    801a5e <smalloc+0x1e>
  801a57:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5c:	eb 14                	jmp    801a72 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801a5e:	83 ec 04             	sub    $0x4,%esp
  801a61:	68 10 42 80 00       	push   $0x804210
  801a66:	6a 76                	push   $0x76
  801a68:	68 93 41 80 00       	push   $0x804193
  801a6d:	e8 4a ed ff ff       	call   8007bc <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a7a:	e8 7b fd ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a7f:	83 ec 04             	sub    $0x4,%esp
  801a82:	68 38 42 80 00       	push   $0x804238
  801a87:	68 93 00 00 00       	push   $0x93
  801a8c:	68 93 41 80 00       	push   $0x804193
  801a91:	e8 26 ed ff ff       	call   8007bc <_panic>

00801a96 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a9c:	e8 59 fd ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801aa1:	83 ec 04             	sub    $0x4,%esp
  801aa4:	68 5c 42 80 00       	push   $0x80425c
  801aa9:	68 c5 00 00 00       	push   $0xc5
  801aae:	68 93 41 80 00       	push   $0x804193
  801ab3:	e8 04 ed ff ff       	call   8007bc <_panic>

00801ab8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801abe:	83 ec 04             	sub    $0x4,%esp
  801ac1:	68 84 42 80 00       	push   $0x804284
  801ac6:	68 d9 00 00 00       	push   $0xd9
  801acb:	68 93 41 80 00       	push   $0x804193
  801ad0:	e8 e7 ec ff ff       	call   8007bc <_panic>

00801ad5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801adb:	83 ec 04             	sub    $0x4,%esp
  801ade:	68 a8 42 80 00       	push   $0x8042a8
  801ae3:	68 e4 00 00 00       	push   $0xe4
  801ae8:	68 93 41 80 00       	push   $0x804193
  801aed:	e8 ca ec ff ff       	call   8007bc <_panic>

00801af2 <shrink>:

}
void shrink(uint32 newSize)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801af8:	83 ec 04             	sub    $0x4,%esp
  801afb:	68 a8 42 80 00       	push   $0x8042a8
  801b00:	68 e9 00 00 00       	push   $0xe9
  801b05:	68 93 41 80 00       	push   $0x804193
  801b0a:	e8 ad ec ff ff       	call   8007bc <_panic>

00801b0f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b15:	83 ec 04             	sub    $0x4,%esp
  801b18:	68 a8 42 80 00       	push   $0x8042a8
  801b1d:	68 ee 00 00 00       	push   $0xee
  801b22:	68 93 41 80 00       	push   $0x804193
  801b27:	e8 90 ec ff ff       	call   8007bc <_panic>

00801b2c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	57                   	push   %edi
  801b30:	56                   	push   %esi
  801b31:	53                   	push   %ebx
  801b32:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b3e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b41:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b44:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b47:	cd 30                	int    $0x30
  801b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b4f:	83 c4 10             	add    $0x10,%esp
  801b52:	5b                   	pop    %ebx
  801b53:	5e                   	pop    %esi
  801b54:	5f                   	pop    %edi
  801b55:	5d                   	pop    %ebp
  801b56:	c3                   	ret    

00801b57 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	83 ec 04             	sub    $0x4,%esp
  801b5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b63:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	52                   	push   %edx
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	50                   	push   %eax
  801b73:	6a 00                	push   $0x0
  801b75:	e8 b2 ff ff ff       	call   801b2c <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	90                   	nop
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 01                	push   $0x1
  801b8f:	e8 98 ff ff ff       	call   801b2c <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	52                   	push   %edx
  801ba9:	50                   	push   %eax
  801baa:	6a 05                	push   $0x5
  801bac:	e8 7b ff ff ff       	call   801b2c <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	56                   	push   %esi
  801bba:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bbb:	8b 75 18             	mov    0x18(%ebp),%esi
  801bbe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bc1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	56                   	push   %esi
  801bcb:	53                   	push   %ebx
  801bcc:	51                   	push   %ecx
  801bcd:	52                   	push   %edx
  801bce:	50                   	push   %eax
  801bcf:	6a 06                	push   $0x6
  801bd1:	e8 56 ff ff ff       	call   801b2c <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bdc:	5b                   	pop    %ebx
  801bdd:	5e                   	pop    %esi
  801bde:	5d                   	pop    %ebp
  801bdf:	c3                   	ret    

00801be0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	52                   	push   %edx
  801bf0:	50                   	push   %eax
  801bf1:	6a 07                	push   $0x7
  801bf3:	e8 34 ff ff ff       	call   801b2c <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	ff 75 0c             	pushl  0xc(%ebp)
  801c09:	ff 75 08             	pushl  0x8(%ebp)
  801c0c:	6a 08                	push   $0x8
  801c0e:	e8 19 ff ff ff       	call   801b2c <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 09                	push   $0x9
  801c27:	e8 00 ff ff ff       	call   801b2c <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 0a                	push   $0xa
  801c40:	e8 e7 fe ff ff       	call   801b2c <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 0b                	push   $0xb
  801c59:	e8 ce fe ff ff       	call   801b2c <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	ff 75 0c             	pushl  0xc(%ebp)
  801c6f:	ff 75 08             	pushl  0x8(%ebp)
  801c72:	6a 0f                	push   $0xf
  801c74:	e8 b3 fe ff ff       	call   801b2c <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
	return;
  801c7c:	90                   	nop
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	ff 75 0c             	pushl  0xc(%ebp)
  801c8b:	ff 75 08             	pushl  0x8(%ebp)
  801c8e:	6a 10                	push   $0x10
  801c90:	e8 97 fe ff ff       	call   801b2c <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
	return ;
  801c98:	90                   	nop
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	ff 75 10             	pushl  0x10(%ebp)
  801ca5:	ff 75 0c             	pushl  0xc(%ebp)
  801ca8:	ff 75 08             	pushl  0x8(%ebp)
  801cab:	6a 11                	push   $0x11
  801cad:	e8 7a fe ff ff       	call   801b2c <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb5:	90                   	nop
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 0c                	push   $0xc
  801cc7:	e8 60 fe ff ff       	call   801b2c <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	ff 75 08             	pushl  0x8(%ebp)
  801cdf:	6a 0d                	push   $0xd
  801ce1:	e8 46 fe ff ff       	call   801b2c <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 0e                	push   $0xe
  801cfa:	e8 2d fe ff ff       	call   801b2c <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
}
  801d02:	90                   	nop
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 13                	push   $0x13
  801d14:	e8 13 fe ff ff       	call   801b2c <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
}
  801d1c:	90                   	nop
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 14                	push   $0x14
  801d2e:	e8 f9 fd ff ff       	call   801b2c <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
}
  801d36:	90                   	nop
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 04             	sub    $0x4,%esp
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d45:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	50                   	push   %eax
  801d52:	6a 15                	push   $0x15
  801d54:	e8 d3 fd ff ff       	call   801b2c <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	90                   	nop
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 16                	push   $0x16
  801d6e:	e8 b9 fd ff ff       	call   801b2c <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	90                   	nop
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	ff 75 0c             	pushl  0xc(%ebp)
  801d88:	50                   	push   %eax
  801d89:	6a 17                	push   $0x17
  801d8b:	e8 9c fd ff ff       	call   801b2c <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	52                   	push   %edx
  801da5:	50                   	push   %eax
  801da6:	6a 1a                	push   $0x1a
  801da8:	e8 7f fd ff ff       	call   801b2c <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	52                   	push   %edx
  801dc2:	50                   	push   %eax
  801dc3:	6a 18                	push   $0x18
  801dc5:	e8 62 fd ff ff       	call   801b2c <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
}
  801dcd:	90                   	nop
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	52                   	push   %edx
  801de0:	50                   	push   %eax
  801de1:	6a 19                	push   $0x19
  801de3:	e8 44 fd ff ff       	call   801b2c <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
}
  801deb:	90                   	nop
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 04             	sub    $0x4,%esp
  801df4:	8b 45 10             	mov    0x10(%ebp),%eax
  801df7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dfa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dfd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e01:	8b 45 08             	mov    0x8(%ebp),%eax
  801e04:	6a 00                	push   $0x0
  801e06:	51                   	push   %ecx
  801e07:	52                   	push   %edx
  801e08:	ff 75 0c             	pushl  0xc(%ebp)
  801e0b:	50                   	push   %eax
  801e0c:	6a 1b                	push   $0x1b
  801e0e:	e8 19 fd ff ff       	call   801b2c <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	52                   	push   %edx
  801e28:	50                   	push   %eax
  801e29:	6a 1c                	push   $0x1c
  801e2b:	e8 fc fc ff ff       	call   801b2c <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	51                   	push   %ecx
  801e46:	52                   	push   %edx
  801e47:	50                   	push   %eax
  801e48:	6a 1d                	push   $0x1d
  801e4a:	e8 dd fc ff ff       	call   801b2c <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	52                   	push   %edx
  801e64:	50                   	push   %eax
  801e65:	6a 1e                	push   $0x1e
  801e67:	e8 c0 fc ff ff       	call   801b2c <syscall>
  801e6c:	83 c4 18             	add    $0x18,%esp
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 1f                	push   $0x1f
  801e80:	e8 a7 fc ff ff       	call   801b2c <syscall>
  801e85:	83 c4 18             	add    $0x18,%esp
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	6a 00                	push   $0x0
  801e92:	ff 75 14             	pushl  0x14(%ebp)
  801e95:	ff 75 10             	pushl  0x10(%ebp)
  801e98:	ff 75 0c             	pushl  0xc(%ebp)
  801e9b:	50                   	push   %eax
  801e9c:	6a 20                	push   $0x20
  801e9e:	e8 89 fc ff ff       	call   801b2c <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	50                   	push   %eax
  801eb7:	6a 21                	push   $0x21
  801eb9:	e8 6e fc ff ff       	call   801b2c <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
}
  801ec1:	90                   	nop
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	50                   	push   %eax
  801ed3:	6a 22                	push   $0x22
  801ed5:	e8 52 fc ff ff       	call   801b2c <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <sys_getenvid>:

int32 sys_getenvid(void)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 02                	push   $0x2
  801eee:	e8 39 fc ff ff       	call   801b2c <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 03                	push   $0x3
  801f07:	e8 20 fc ff ff       	call   801b2c <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 04                	push   $0x4
  801f20:	e8 07 fc ff ff       	call   801b2c <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <sys_exit_env>:


void sys_exit_env(void)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 23                	push   $0x23
  801f39:	e8 ee fb ff ff       	call   801b2c <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
}
  801f41:	90                   	nop
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f4a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f4d:	8d 50 04             	lea    0x4(%eax),%edx
  801f50:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	52                   	push   %edx
  801f5a:	50                   	push   %eax
  801f5b:	6a 24                	push   $0x24
  801f5d:	e8 ca fb ff ff       	call   801b2c <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
	return result;
  801f65:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f6e:	89 01                	mov    %eax,(%ecx)
  801f70:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	c9                   	leave  
  801f77:	c2 04 00             	ret    $0x4

00801f7a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	ff 75 10             	pushl  0x10(%ebp)
  801f84:	ff 75 0c             	pushl  0xc(%ebp)
  801f87:	ff 75 08             	pushl  0x8(%ebp)
  801f8a:	6a 12                	push   $0x12
  801f8c:	e8 9b fb ff ff       	call   801b2c <syscall>
  801f91:	83 c4 18             	add    $0x18,%esp
	return ;
  801f94:	90                   	nop
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 25                	push   $0x25
  801fa6:	e8 81 fb ff ff       	call   801b2c <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 04             	sub    $0x4,%esp
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fbc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	50                   	push   %eax
  801fc9:	6a 26                	push   $0x26
  801fcb:	e8 5c fb ff ff       	call   801b2c <syscall>
  801fd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd3:	90                   	nop
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <rsttst>:
void rsttst()
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 28                	push   $0x28
  801fe5:	e8 42 fb ff ff       	call   801b2c <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
	return ;
  801fed:	90                   	nop
}
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	83 ec 04             	sub    $0x4,%esp
  801ff6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ff9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ffc:	8b 55 18             	mov    0x18(%ebp),%edx
  801fff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802003:	52                   	push   %edx
  802004:	50                   	push   %eax
  802005:	ff 75 10             	pushl  0x10(%ebp)
  802008:	ff 75 0c             	pushl  0xc(%ebp)
  80200b:	ff 75 08             	pushl  0x8(%ebp)
  80200e:	6a 27                	push   $0x27
  802010:	e8 17 fb ff ff       	call   801b2c <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
	return ;
  802018:	90                   	nop
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <chktst>:
void chktst(uint32 n)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	ff 75 08             	pushl  0x8(%ebp)
  802029:	6a 29                	push   $0x29
  80202b:	e8 fc fa ff ff       	call   801b2c <syscall>
  802030:	83 c4 18             	add    $0x18,%esp
	return ;
  802033:	90                   	nop
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <inctst>:

void inctst()
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 2a                	push   $0x2a
  802045:	e8 e2 fa ff ff       	call   801b2c <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
	return ;
  80204d:	90                   	nop
}
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <gettst>:
uint32 gettst()
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 2b                	push   $0x2b
  80205f:	e8 c8 fa ff ff       	call   801b2c <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 2c                	push   $0x2c
  80207b:	e8 ac fa ff ff       	call   801b2c <syscall>
  802080:	83 c4 18             	add    $0x18,%esp
  802083:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802086:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80208a:	75 07                	jne    802093 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80208c:	b8 01 00 00 00       	mov    $0x1,%eax
  802091:	eb 05                	jmp    802098 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802093:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 2c                	push   $0x2c
  8020ac:	e8 7b fa ff ff       	call   801b2c <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
  8020b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020b7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020bb:	75 07                	jne    8020c4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c2:	eb 05                	jmp    8020c9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 2c                	push   $0x2c
  8020dd:	e8 4a fa ff ff       	call   801b2c <syscall>
  8020e2:	83 c4 18             	add    $0x18,%esp
  8020e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020e8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020ec:	75 07                	jne    8020f5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f3:	eb 05                	jmp    8020fa <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 2c                	push   $0x2c
  80210e:	e8 19 fa ff ff       	call   801b2c <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
  802116:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802119:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80211d:	75 07                	jne    802126 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80211f:	b8 01 00 00 00       	mov    $0x1,%eax
  802124:	eb 05                	jmp    80212b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802126:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	ff 75 08             	pushl  0x8(%ebp)
  80213b:	6a 2d                	push   $0x2d
  80213d:	e8 ea f9 ff ff       	call   801b2c <syscall>
  802142:	83 c4 18             	add    $0x18,%esp
	return ;
  802145:	90                   	nop
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80214c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80214f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802152:	8b 55 0c             	mov    0xc(%ebp),%edx
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	6a 00                	push   $0x0
  80215a:	53                   	push   %ebx
  80215b:	51                   	push   %ecx
  80215c:	52                   	push   %edx
  80215d:	50                   	push   %eax
  80215e:	6a 2e                	push   $0x2e
  802160:	e8 c7 f9 ff ff       	call   801b2c <syscall>
  802165:	83 c4 18             	add    $0x18,%esp
}
  802168:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802170:	8b 55 0c             	mov    0xc(%ebp),%edx
  802173:	8b 45 08             	mov    0x8(%ebp),%eax
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	52                   	push   %edx
  80217d:	50                   	push   %eax
  80217e:	6a 2f                	push   $0x2f
  802180:	e8 a7 f9 ff ff       	call   801b2c <syscall>
  802185:	83 c4 18             	add    $0x18,%esp
}
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802190:	83 ec 0c             	sub    $0xc,%esp
  802193:	68 b8 42 80 00       	push   $0x8042b8
  802198:	e8 d3 e8 ff ff       	call   800a70 <cprintf>
  80219d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8021a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8021a7:	83 ec 0c             	sub    $0xc,%esp
  8021aa:	68 e4 42 80 00       	push   $0x8042e4
  8021af:	e8 bc e8 ff ff       	call   800a70 <cprintf>
  8021b4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8021b7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021bb:	a1 38 51 80 00       	mov    0x805138,%eax
  8021c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c3:	eb 56                	jmp    80221b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021c9:	74 1c                	je     8021e7 <print_mem_block_lists+0x5d>
  8021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ce:	8b 50 08             	mov    0x8(%eax),%edx
  8021d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d4:	8b 48 08             	mov    0x8(%eax),%ecx
  8021d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021da:	8b 40 0c             	mov    0xc(%eax),%eax
  8021dd:	01 c8                	add    %ecx,%eax
  8021df:	39 c2                	cmp    %eax,%edx
  8021e1:	73 04                	jae    8021e7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8021e3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ea:	8b 50 08             	mov    0x8(%eax),%edx
  8021ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f3:	01 c2                	add    %eax,%edx
  8021f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f8:	8b 40 08             	mov    0x8(%eax),%eax
  8021fb:	83 ec 04             	sub    $0x4,%esp
  8021fe:	52                   	push   %edx
  8021ff:	50                   	push   %eax
  802200:	68 f9 42 80 00       	push   $0x8042f9
  802205:	e8 66 e8 ff ff       	call   800a70 <cprintf>
  80220a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80220d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802210:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802213:	a1 40 51 80 00       	mov    0x805140,%eax
  802218:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221f:	74 07                	je     802228 <print_mem_block_lists+0x9e>
  802221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802224:	8b 00                	mov    (%eax),%eax
  802226:	eb 05                	jmp    80222d <print_mem_block_lists+0xa3>
  802228:	b8 00 00 00 00       	mov    $0x0,%eax
  80222d:	a3 40 51 80 00       	mov    %eax,0x805140
  802232:	a1 40 51 80 00       	mov    0x805140,%eax
  802237:	85 c0                	test   %eax,%eax
  802239:	75 8a                	jne    8021c5 <print_mem_block_lists+0x3b>
  80223b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223f:	75 84                	jne    8021c5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802241:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802245:	75 10                	jne    802257 <print_mem_block_lists+0xcd>
  802247:	83 ec 0c             	sub    $0xc,%esp
  80224a:	68 08 43 80 00       	push   $0x804308
  80224f:	e8 1c e8 ff ff       	call   800a70 <cprintf>
  802254:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802257:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80225e:	83 ec 0c             	sub    $0xc,%esp
  802261:	68 2c 43 80 00       	push   $0x80432c
  802266:	e8 05 e8 ff ff       	call   800a70 <cprintf>
  80226b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80226e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802272:	a1 40 50 80 00       	mov    0x805040,%eax
  802277:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80227a:	eb 56                	jmp    8022d2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80227c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802280:	74 1c                	je     80229e <print_mem_block_lists+0x114>
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	8b 50 08             	mov    0x8(%eax),%edx
  802288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228b:	8b 48 08             	mov    0x8(%eax),%ecx
  80228e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802291:	8b 40 0c             	mov    0xc(%eax),%eax
  802294:	01 c8                	add    %ecx,%eax
  802296:	39 c2                	cmp    %eax,%edx
  802298:	73 04                	jae    80229e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80229a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	8b 50 08             	mov    0x8(%eax),%edx
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8022aa:	01 c2                	add    %eax,%edx
  8022ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022af:	8b 40 08             	mov    0x8(%eax),%eax
  8022b2:	83 ec 04             	sub    $0x4,%esp
  8022b5:	52                   	push   %edx
  8022b6:	50                   	push   %eax
  8022b7:	68 f9 42 80 00       	push   $0x8042f9
  8022bc:	e8 af e7 ff ff       	call   800a70 <cprintf>
  8022c1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022ca:	a1 48 50 80 00       	mov    0x805048,%eax
  8022cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d6:	74 07                	je     8022df <print_mem_block_lists+0x155>
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	8b 00                	mov    (%eax),%eax
  8022dd:	eb 05                	jmp    8022e4 <print_mem_block_lists+0x15a>
  8022df:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e4:	a3 48 50 80 00       	mov    %eax,0x805048
  8022e9:	a1 48 50 80 00       	mov    0x805048,%eax
  8022ee:	85 c0                	test   %eax,%eax
  8022f0:	75 8a                	jne    80227c <print_mem_block_lists+0xf2>
  8022f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f6:	75 84                	jne    80227c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022f8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022fc:	75 10                	jne    80230e <print_mem_block_lists+0x184>
  8022fe:	83 ec 0c             	sub    $0xc,%esp
  802301:	68 44 43 80 00       	push   $0x804344
  802306:	e8 65 e7 ff ff       	call   800a70 <cprintf>
  80230b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80230e:	83 ec 0c             	sub    $0xc,%esp
  802311:	68 b8 42 80 00       	push   $0x8042b8
  802316:	e8 55 e7 ff ff       	call   800a70 <cprintf>
  80231b:	83 c4 10             	add    $0x10,%esp

}
  80231e:	90                   	nop
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802327:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80232e:	00 00 00 
  802331:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802338:	00 00 00 
  80233b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802342:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80234c:	e9 9e 00 00 00       	jmp    8023ef <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802351:	a1 50 50 80 00       	mov    0x805050,%eax
  802356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802359:	c1 e2 04             	shl    $0x4,%edx
  80235c:	01 d0                	add    %edx,%eax
  80235e:	85 c0                	test   %eax,%eax
  802360:	75 14                	jne    802376 <initialize_MemBlocksList+0x55>
  802362:	83 ec 04             	sub    $0x4,%esp
  802365:	68 6c 43 80 00       	push   $0x80436c
  80236a:	6a 46                	push   $0x46
  80236c:	68 8f 43 80 00       	push   $0x80438f
  802371:	e8 46 e4 ff ff       	call   8007bc <_panic>
  802376:	a1 50 50 80 00       	mov    0x805050,%eax
  80237b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237e:	c1 e2 04             	shl    $0x4,%edx
  802381:	01 d0                	add    %edx,%eax
  802383:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802389:	89 10                	mov    %edx,(%eax)
  80238b:	8b 00                	mov    (%eax),%eax
  80238d:	85 c0                	test   %eax,%eax
  80238f:	74 18                	je     8023a9 <initialize_MemBlocksList+0x88>
  802391:	a1 48 51 80 00       	mov    0x805148,%eax
  802396:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80239c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80239f:	c1 e1 04             	shl    $0x4,%ecx
  8023a2:	01 ca                	add    %ecx,%edx
  8023a4:	89 50 04             	mov    %edx,0x4(%eax)
  8023a7:	eb 12                	jmp    8023bb <initialize_MemBlocksList+0x9a>
  8023a9:	a1 50 50 80 00       	mov    0x805050,%eax
  8023ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b1:	c1 e2 04             	shl    $0x4,%edx
  8023b4:	01 d0                	add    %edx,%eax
  8023b6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023bb:	a1 50 50 80 00       	mov    0x805050,%eax
  8023c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c3:	c1 e2 04             	shl    $0x4,%edx
  8023c6:	01 d0                	add    %edx,%eax
  8023c8:	a3 48 51 80 00       	mov    %eax,0x805148
  8023cd:	a1 50 50 80 00       	mov    0x805050,%eax
  8023d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d5:	c1 e2 04             	shl    $0x4,%edx
  8023d8:	01 d0                	add    %edx,%eax
  8023da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e1:	a1 54 51 80 00       	mov    0x805154,%eax
  8023e6:	40                   	inc    %eax
  8023e7:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8023ec:	ff 45 f4             	incl   -0xc(%ebp)
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f5:	0f 82 56 ff ff ff    	jb     802351 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8023fb:	90                   	nop
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
  802401:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	8b 00                	mov    (%eax),%eax
  802409:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80240c:	eb 19                	jmp    802427 <find_block+0x29>
	{
		if(va==point->sva)
  80240e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802411:	8b 40 08             	mov    0x8(%eax),%eax
  802414:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802417:	75 05                	jne    80241e <find_block+0x20>
		   return point;
  802419:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80241c:	eb 36                	jmp    802454 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80241e:	8b 45 08             	mov    0x8(%ebp),%eax
  802421:	8b 40 08             	mov    0x8(%eax),%eax
  802424:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802427:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80242b:	74 07                	je     802434 <find_block+0x36>
  80242d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802430:	8b 00                	mov    (%eax),%eax
  802432:	eb 05                	jmp    802439 <find_block+0x3b>
  802434:	b8 00 00 00 00       	mov    $0x0,%eax
  802439:	8b 55 08             	mov    0x8(%ebp),%edx
  80243c:	89 42 08             	mov    %eax,0x8(%edx)
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	8b 40 08             	mov    0x8(%eax),%eax
  802445:	85 c0                	test   %eax,%eax
  802447:	75 c5                	jne    80240e <find_block+0x10>
  802449:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80244d:	75 bf                	jne    80240e <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80244f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802454:	c9                   	leave  
  802455:	c3                   	ret    

00802456 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
  802459:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80245c:	a1 40 50 80 00       	mov    0x805040,%eax
  802461:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802464:	a1 44 50 80 00       	mov    0x805044,%eax
  802469:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80246c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802472:	74 24                	je     802498 <insert_sorted_allocList+0x42>
  802474:	8b 45 08             	mov    0x8(%ebp),%eax
  802477:	8b 50 08             	mov    0x8(%eax),%edx
  80247a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247d:	8b 40 08             	mov    0x8(%eax),%eax
  802480:	39 c2                	cmp    %eax,%edx
  802482:	76 14                	jbe    802498 <insert_sorted_allocList+0x42>
  802484:	8b 45 08             	mov    0x8(%ebp),%eax
  802487:	8b 50 08             	mov    0x8(%eax),%edx
  80248a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248d:	8b 40 08             	mov    0x8(%eax),%eax
  802490:	39 c2                	cmp    %eax,%edx
  802492:	0f 82 60 01 00 00    	jb     8025f8 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802498:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80249c:	75 65                	jne    802503 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80249e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024a2:	75 14                	jne    8024b8 <insert_sorted_allocList+0x62>
  8024a4:	83 ec 04             	sub    $0x4,%esp
  8024a7:	68 6c 43 80 00       	push   $0x80436c
  8024ac:	6a 6b                	push   $0x6b
  8024ae:	68 8f 43 80 00       	push   $0x80438f
  8024b3:	e8 04 e3 ff ff       	call   8007bc <_panic>
  8024b8:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8024be:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c1:	89 10                	mov    %edx,(%eax)
  8024c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c6:	8b 00                	mov    (%eax),%eax
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	74 0d                	je     8024d9 <insert_sorted_allocList+0x83>
  8024cc:	a1 40 50 80 00       	mov    0x805040,%eax
  8024d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d4:	89 50 04             	mov    %edx,0x4(%eax)
  8024d7:	eb 08                	jmp    8024e1 <insert_sorted_allocList+0x8b>
  8024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dc:	a3 44 50 80 00       	mov    %eax,0x805044
  8024e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e4:	a3 40 50 80 00       	mov    %eax,0x805040
  8024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024f8:	40                   	inc    %eax
  8024f9:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024fe:	e9 dc 01 00 00       	jmp    8026df <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802503:	8b 45 08             	mov    0x8(%ebp),%eax
  802506:	8b 50 08             	mov    0x8(%eax),%edx
  802509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250c:	8b 40 08             	mov    0x8(%eax),%eax
  80250f:	39 c2                	cmp    %eax,%edx
  802511:	77 6c                	ja     80257f <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802513:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802517:	74 06                	je     80251f <insert_sorted_allocList+0xc9>
  802519:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80251d:	75 14                	jne    802533 <insert_sorted_allocList+0xdd>
  80251f:	83 ec 04             	sub    $0x4,%esp
  802522:	68 a8 43 80 00       	push   $0x8043a8
  802527:	6a 6f                	push   $0x6f
  802529:	68 8f 43 80 00       	push   $0x80438f
  80252e:	e8 89 e2 ff ff       	call   8007bc <_panic>
  802533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802536:	8b 50 04             	mov    0x4(%eax),%edx
  802539:	8b 45 08             	mov    0x8(%ebp),%eax
  80253c:	89 50 04             	mov    %edx,0x4(%eax)
  80253f:	8b 45 08             	mov    0x8(%ebp),%eax
  802542:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802545:	89 10                	mov    %edx,(%eax)
  802547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254a:	8b 40 04             	mov    0x4(%eax),%eax
  80254d:	85 c0                	test   %eax,%eax
  80254f:	74 0d                	je     80255e <insert_sorted_allocList+0x108>
  802551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802554:	8b 40 04             	mov    0x4(%eax),%eax
  802557:	8b 55 08             	mov    0x8(%ebp),%edx
  80255a:	89 10                	mov    %edx,(%eax)
  80255c:	eb 08                	jmp    802566 <insert_sorted_allocList+0x110>
  80255e:	8b 45 08             	mov    0x8(%ebp),%eax
  802561:	a3 40 50 80 00       	mov    %eax,0x805040
  802566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802569:	8b 55 08             	mov    0x8(%ebp),%edx
  80256c:	89 50 04             	mov    %edx,0x4(%eax)
  80256f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802574:	40                   	inc    %eax
  802575:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80257a:	e9 60 01 00 00       	jmp    8026df <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80257f:	8b 45 08             	mov    0x8(%ebp),%eax
  802582:	8b 50 08             	mov    0x8(%eax),%edx
  802585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802588:	8b 40 08             	mov    0x8(%eax),%eax
  80258b:	39 c2                	cmp    %eax,%edx
  80258d:	0f 82 4c 01 00 00    	jb     8026df <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802593:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802597:	75 14                	jne    8025ad <insert_sorted_allocList+0x157>
  802599:	83 ec 04             	sub    $0x4,%esp
  80259c:	68 e0 43 80 00       	push   $0x8043e0
  8025a1:	6a 73                	push   $0x73
  8025a3:	68 8f 43 80 00       	push   $0x80438f
  8025a8:	e8 0f e2 ff ff       	call   8007bc <_panic>
  8025ad:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	89 50 04             	mov    %edx,0x4(%eax)
  8025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bc:	8b 40 04             	mov    0x4(%eax),%eax
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	74 0c                	je     8025cf <insert_sorted_allocList+0x179>
  8025c3:	a1 44 50 80 00       	mov    0x805044,%eax
  8025c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8025cb:	89 10                	mov    %edx,(%eax)
  8025cd:	eb 08                	jmp    8025d7 <insert_sorted_allocList+0x181>
  8025cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d2:	a3 40 50 80 00       	mov    %eax,0x805040
  8025d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025da:	a3 44 50 80 00       	mov    %eax,0x805044
  8025df:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025ed:	40                   	inc    %eax
  8025ee:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025f3:	e9 e7 00 00 00       	jmp    8026df <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8025f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8025fe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802605:	a1 40 50 80 00       	mov    0x805040,%eax
  80260a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260d:	e9 9d 00 00 00       	jmp    8026af <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 00                	mov    (%eax),%eax
  802617:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80261a:	8b 45 08             	mov    0x8(%ebp),%eax
  80261d:	8b 50 08             	mov    0x8(%eax),%edx
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 40 08             	mov    0x8(%eax),%eax
  802626:	39 c2                	cmp    %eax,%edx
  802628:	76 7d                	jbe    8026a7 <insert_sorted_allocList+0x251>
  80262a:	8b 45 08             	mov    0x8(%ebp),%eax
  80262d:	8b 50 08             	mov    0x8(%eax),%edx
  802630:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802633:	8b 40 08             	mov    0x8(%eax),%eax
  802636:	39 c2                	cmp    %eax,%edx
  802638:	73 6d                	jae    8026a7 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80263a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263e:	74 06                	je     802646 <insert_sorted_allocList+0x1f0>
  802640:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802644:	75 14                	jne    80265a <insert_sorted_allocList+0x204>
  802646:	83 ec 04             	sub    $0x4,%esp
  802649:	68 04 44 80 00       	push   $0x804404
  80264e:	6a 7f                	push   $0x7f
  802650:	68 8f 43 80 00       	push   $0x80438f
  802655:	e8 62 e1 ff ff       	call   8007bc <_panic>
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 10                	mov    (%eax),%edx
  80265f:	8b 45 08             	mov    0x8(%ebp),%eax
  802662:	89 10                	mov    %edx,(%eax)
  802664:	8b 45 08             	mov    0x8(%ebp),%eax
  802667:	8b 00                	mov    (%eax),%eax
  802669:	85 c0                	test   %eax,%eax
  80266b:	74 0b                	je     802678 <insert_sorted_allocList+0x222>
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	8b 00                	mov    (%eax),%eax
  802672:	8b 55 08             	mov    0x8(%ebp),%edx
  802675:	89 50 04             	mov    %edx,0x4(%eax)
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	8b 55 08             	mov    0x8(%ebp),%edx
  80267e:	89 10                	mov    %edx,(%eax)
  802680:	8b 45 08             	mov    0x8(%ebp),%eax
  802683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802686:	89 50 04             	mov    %edx,0x4(%eax)
  802689:	8b 45 08             	mov    0x8(%ebp),%eax
  80268c:	8b 00                	mov    (%eax),%eax
  80268e:	85 c0                	test   %eax,%eax
  802690:	75 08                	jne    80269a <insert_sorted_allocList+0x244>
  802692:	8b 45 08             	mov    0x8(%ebp),%eax
  802695:	a3 44 50 80 00       	mov    %eax,0x805044
  80269a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80269f:	40                   	inc    %eax
  8026a0:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8026a5:	eb 39                	jmp    8026e0 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8026a7:	a1 48 50 80 00       	mov    0x805048,%eax
  8026ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b3:	74 07                	je     8026bc <insert_sorted_allocList+0x266>
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 00                	mov    (%eax),%eax
  8026ba:	eb 05                	jmp    8026c1 <insert_sorted_allocList+0x26b>
  8026bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c1:	a3 48 50 80 00       	mov    %eax,0x805048
  8026c6:	a1 48 50 80 00       	mov    0x805048,%eax
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	0f 85 3f ff ff ff    	jne    802612 <insert_sorted_allocList+0x1bc>
  8026d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d7:	0f 85 35 ff ff ff    	jne    802612 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026dd:	eb 01                	jmp    8026e0 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026df:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026e0:	90                   	nop
  8026e1:	c9                   	leave  
  8026e2:	c3                   	ret    

008026e3 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8026e3:	55                   	push   %ebp
  8026e4:	89 e5                	mov    %esp,%ebp
  8026e6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026e9:	a1 38 51 80 00       	mov    0x805138,%eax
  8026ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f1:	e9 85 01 00 00       	jmp    80287b <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ff:	0f 82 6e 01 00 00    	jb     802873 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 40 0c             	mov    0xc(%eax),%eax
  80270b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80270e:	0f 85 8a 00 00 00    	jne    80279e <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802714:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802718:	75 17                	jne    802731 <alloc_block_FF+0x4e>
  80271a:	83 ec 04             	sub    $0x4,%esp
  80271d:	68 38 44 80 00       	push   $0x804438
  802722:	68 93 00 00 00       	push   $0x93
  802727:	68 8f 43 80 00       	push   $0x80438f
  80272c:	e8 8b e0 ff ff       	call   8007bc <_panic>
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	8b 00                	mov    (%eax),%eax
  802736:	85 c0                	test   %eax,%eax
  802738:	74 10                	je     80274a <alloc_block_FF+0x67>
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 00                	mov    (%eax),%eax
  80273f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802742:	8b 52 04             	mov    0x4(%edx),%edx
  802745:	89 50 04             	mov    %edx,0x4(%eax)
  802748:	eb 0b                	jmp    802755 <alloc_block_FF+0x72>
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 40 04             	mov    0x4(%eax),%eax
  802750:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 40 04             	mov    0x4(%eax),%eax
  80275b:	85 c0                	test   %eax,%eax
  80275d:	74 0f                	je     80276e <alloc_block_FF+0x8b>
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 40 04             	mov    0x4(%eax),%eax
  802765:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802768:	8b 12                	mov    (%edx),%edx
  80276a:	89 10                	mov    %edx,(%eax)
  80276c:	eb 0a                	jmp    802778 <alloc_block_FF+0x95>
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	8b 00                	mov    (%eax),%eax
  802773:	a3 38 51 80 00       	mov    %eax,0x805138
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278b:	a1 44 51 80 00       	mov    0x805144,%eax
  802790:	48                   	dec    %eax
  802791:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	e9 10 01 00 00       	jmp    8028ae <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a7:	0f 86 c6 00 00 00    	jbe    802873 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027ad:	a1 48 51 80 00       	mov    0x805148,%eax
  8027b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 50 08             	mov    0x8(%eax),%edx
  8027bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027be:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8027c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c7:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ce:	75 17                	jne    8027e7 <alloc_block_FF+0x104>
  8027d0:	83 ec 04             	sub    $0x4,%esp
  8027d3:	68 38 44 80 00       	push   $0x804438
  8027d8:	68 9b 00 00 00       	push   $0x9b
  8027dd:	68 8f 43 80 00       	push   $0x80438f
  8027e2:	e8 d5 df ff ff       	call   8007bc <_panic>
  8027e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ea:	8b 00                	mov    (%eax),%eax
  8027ec:	85 c0                	test   %eax,%eax
  8027ee:	74 10                	je     802800 <alloc_block_FF+0x11d>
  8027f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f3:	8b 00                	mov    (%eax),%eax
  8027f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f8:	8b 52 04             	mov    0x4(%edx),%edx
  8027fb:	89 50 04             	mov    %edx,0x4(%eax)
  8027fe:	eb 0b                	jmp    80280b <alloc_block_FF+0x128>
  802800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80280b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280e:	8b 40 04             	mov    0x4(%eax),%eax
  802811:	85 c0                	test   %eax,%eax
  802813:	74 0f                	je     802824 <alloc_block_FF+0x141>
  802815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802818:	8b 40 04             	mov    0x4(%eax),%eax
  80281b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80281e:	8b 12                	mov    (%edx),%edx
  802820:	89 10                	mov    %edx,(%eax)
  802822:	eb 0a                	jmp    80282e <alloc_block_FF+0x14b>
  802824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802827:	8b 00                	mov    (%eax),%eax
  802829:	a3 48 51 80 00       	mov    %eax,0x805148
  80282e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802831:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802841:	a1 54 51 80 00       	mov    0x805154,%eax
  802846:	48                   	dec    %eax
  802847:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 50 08             	mov    0x8(%eax),%edx
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	01 c2                	add    %eax,%edx
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 40 0c             	mov    0xc(%eax),%eax
  802863:	2b 45 08             	sub    0x8(%ebp),%eax
  802866:	89 c2                	mov    %eax,%edx
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80286e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802871:	eb 3b                	jmp    8028ae <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802873:	a1 40 51 80 00       	mov    0x805140,%eax
  802878:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80287b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287f:	74 07                	je     802888 <alloc_block_FF+0x1a5>
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 00                	mov    (%eax),%eax
  802886:	eb 05                	jmp    80288d <alloc_block_FF+0x1aa>
  802888:	b8 00 00 00 00       	mov    $0x0,%eax
  80288d:	a3 40 51 80 00       	mov    %eax,0x805140
  802892:	a1 40 51 80 00       	mov    0x805140,%eax
  802897:	85 c0                	test   %eax,%eax
  802899:	0f 85 57 fe ff ff    	jne    8026f6 <alloc_block_FF+0x13>
  80289f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a3:	0f 85 4d fe ff ff    	jne    8026f6 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8028a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ae:	c9                   	leave  
  8028af:	c3                   	ret    

008028b0 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
  8028b3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8028b6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8028bd:	a1 38 51 80 00       	mov    0x805138,%eax
  8028c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c5:	e9 df 00 00 00       	jmp    8029a9 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d3:	0f 82 c8 00 00 00    	jb     8029a1 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e2:	0f 85 8a 00 00 00    	jne    802972 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8028e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ec:	75 17                	jne    802905 <alloc_block_BF+0x55>
  8028ee:	83 ec 04             	sub    $0x4,%esp
  8028f1:	68 38 44 80 00       	push   $0x804438
  8028f6:	68 b7 00 00 00       	push   $0xb7
  8028fb:	68 8f 43 80 00       	push   $0x80438f
  802900:	e8 b7 de ff ff       	call   8007bc <_panic>
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 00                	mov    (%eax),%eax
  80290a:	85 c0                	test   %eax,%eax
  80290c:	74 10                	je     80291e <alloc_block_BF+0x6e>
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 00                	mov    (%eax),%eax
  802913:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802916:	8b 52 04             	mov    0x4(%edx),%edx
  802919:	89 50 04             	mov    %edx,0x4(%eax)
  80291c:	eb 0b                	jmp    802929 <alloc_block_BF+0x79>
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 40 04             	mov    0x4(%eax),%eax
  802924:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	8b 40 04             	mov    0x4(%eax),%eax
  80292f:	85 c0                	test   %eax,%eax
  802931:	74 0f                	je     802942 <alloc_block_BF+0x92>
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 40 04             	mov    0x4(%eax),%eax
  802939:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293c:	8b 12                	mov    (%edx),%edx
  80293e:	89 10                	mov    %edx,(%eax)
  802940:	eb 0a                	jmp    80294c <alloc_block_BF+0x9c>
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	8b 00                	mov    (%eax),%eax
  802947:	a3 38 51 80 00       	mov    %eax,0x805138
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295f:	a1 44 51 80 00       	mov    0x805144,%eax
  802964:	48                   	dec    %eax
  802965:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	e9 4d 01 00 00       	jmp    802abf <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 40 0c             	mov    0xc(%eax),%eax
  802978:	3b 45 08             	cmp    0x8(%ebp),%eax
  80297b:	76 24                	jbe    8029a1 <alloc_block_BF+0xf1>
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 40 0c             	mov    0xc(%eax),%eax
  802983:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802986:	73 19                	jae    8029a1 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802988:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	8b 40 0c             	mov    0xc(%eax),%eax
  802995:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 40 08             	mov    0x8(%eax),%eax
  80299e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8029a1:	a1 40 51 80 00       	mov    0x805140,%eax
  8029a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ad:	74 07                	je     8029b6 <alloc_block_BF+0x106>
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	eb 05                	jmp    8029bb <alloc_block_BF+0x10b>
  8029b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bb:	a3 40 51 80 00       	mov    %eax,0x805140
  8029c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8029c5:	85 c0                	test   %eax,%eax
  8029c7:	0f 85 fd fe ff ff    	jne    8028ca <alloc_block_BF+0x1a>
  8029cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d1:	0f 85 f3 fe ff ff    	jne    8028ca <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8029d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029db:	0f 84 d9 00 00 00    	je     802aba <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029e1:	a1 48 51 80 00       	mov    0x805148,%eax
  8029e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8029e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029ef:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8029f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f8:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8029fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029ff:	75 17                	jne    802a18 <alloc_block_BF+0x168>
  802a01:	83 ec 04             	sub    $0x4,%esp
  802a04:	68 38 44 80 00       	push   $0x804438
  802a09:	68 c7 00 00 00       	push   $0xc7
  802a0e:	68 8f 43 80 00       	push   $0x80438f
  802a13:	e8 a4 dd ff ff       	call   8007bc <_panic>
  802a18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	74 10                	je     802a31 <alloc_block_BF+0x181>
  802a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a24:	8b 00                	mov    (%eax),%eax
  802a26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a29:	8b 52 04             	mov    0x4(%edx),%edx
  802a2c:	89 50 04             	mov    %edx,0x4(%eax)
  802a2f:	eb 0b                	jmp    802a3c <alloc_block_BF+0x18c>
  802a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a34:	8b 40 04             	mov    0x4(%eax),%eax
  802a37:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a3f:	8b 40 04             	mov    0x4(%eax),%eax
  802a42:	85 c0                	test   %eax,%eax
  802a44:	74 0f                	je     802a55 <alloc_block_BF+0x1a5>
  802a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a49:	8b 40 04             	mov    0x4(%eax),%eax
  802a4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a4f:	8b 12                	mov    (%edx),%edx
  802a51:	89 10                	mov    %edx,(%eax)
  802a53:	eb 0a                	jmp    802a5f <alloc_block_BF+0x1af>
  802a55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a58:	8b 00                	mov    (%eax),%eax
  802a5a:	a3 48 51 80 00       	mov    %eax,0x805148
  802a5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a72:	a1 54 51 80 00       	mov    0x805154,%eax
  802a77:	48                   	dec    %eax
  802a78:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802a7d:	83 ec 08             	sub    $0x8,%esp
  802a80:	ff 75 ec             	pushl  -0x14(%ebp)
  802a83:	68 38 51 80 00       	push   $0x805138
  802a88:	e8 71 f9 ff ff       	call   8023fe <find_block>
  802a8d:	83 c4 10             	add    $0x10,%esp
  802a90:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802a93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a96:	8b 50 08             	mov    0x8(%eax),%edx
  802a99:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9c:	01 c2                	add    %eax,%edx
  802a9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa1:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802aa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aaa:	2b 45 08             	sub    0x8(%ebp),%eax
  802aad:	89 c2                	mov    %eax,%edx
  802aaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab2:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802ab5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ab8:	eb 05                	jmp    802abf <alloc_block_BF+0x20f>
	}
	return NULL;
  802aba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802abf:	c9                   	leave  
  802ac0:	c3                   	ret    

00802ac1 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ac1:	55                   	push   %ebp
  802ac2:	89 e5                	mov    %esp,%ebp
  802ac4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802ac7:	a1 28 50 80 00       	mov    0x805028,%eax
  802acc:	85 c0                	test   %eax,%eax
  802ace:	0f 85 de 01 00 00    	jne    802cb2 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ad4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802adc:	e9 9e 01 00 00       	jmp    802c7f <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aea:	0f 82 87 01 00 00    	jb     802c77 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	8b 40 0c             	mov    0xc(%eax),%eax
  802af6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af9:	0f 85 95 00 00 00    	jne    802b94 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802aff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b03:	75 17                	jne    802b1c <alloc_block_NF+0x5b>
  802b05:	83 ec 04             	sub    $0x4,%esp
  802b08:	68 38 44 80 00       	push   $0x804438
  802b0d:	68 e0 00 00 00       	push   $0xe0
  802b12:	68 8f 43 80 00       	push   $0x80438f
  802b17:	e8 a0 dc ff ff       	call   8007bc <_panic>
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 00                	mov    (%eax),%eax
  802b21:	85 c0                	test   %eax,%eax
  802b23:	74 10                	je     802b35 <alloc_block_NF+0x74>
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 00                	mov    (%eax),%eax
  802b2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2d:	8b 52 04             	mov    0x4(%edx),%edx
  802b30:	89 50 04             	mov    %edx,0x4(%eax)
  802b33:	eb 0b                	jmp    802b40 <alloc_block_NF+0x7f>
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 40 04             	mov    0x4(%eax),%eax
  802b3b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	8b 40 04             	mov    0x4(%eax),%eax
  802b46:	85 c0                	test   %eax,%eax
  802b48:	74 0f                	je     802b59 <alloc_block_NF+0x98>
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	8b 40 04             	mov    0x4(%eax),%eax
  802b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b53:	8b 12                	mov    (%edx),%edx
  802b55:	89 10                	mov    %edx,(%eax)
  802b57:	eb 0a                	jmp    802b63 <alloc_block_NF+0xa2>
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	a3 38 51 80 00       	mov    %eax,0x805138
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b76:	a1 44 51 80 00       	mov    0x805144,%eax
  802b7b:	48                   	dec    %eax
  802b7c:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	8b 40 08             	mov    0x8(%eax),%eax
  802b87:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	e9 f8 04 00 00       	jmp    80308c <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b9d:	0f 86 d4 00 00 00    	jbe    802c77 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ba3:	a1 48 51 80 00       	mov    0x805148,%eax
  802ba8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 50 08             	mov    0x8(%eax),%edx
  802bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb4:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bba:	8b 55 08             	mov    0x8(%ebp),%edx
  802bbd:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bc4:	75 17                	jne    802bdd <alloc_block_NF+0x11c>
  802bc6:	83 ec 04             	sub    $0x4,%esp
  802bc9:	68 38 44 80 00       	push   $0x804438
  802bce:	68 e9 00 00 00       	push   $0xe9
  802bd3:	68 8f 43 80 00       	push   $0x80438f
  802bd8:	e8 df db ff ff       	call   8007bc <_panic>
  802bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be0:	8b 00                	mov    (%eax),%eax
  802be2:	85 c0                	test   %eax,%eax
  802be4:	74 10                	je     802bf6 <alloc_block_NF+0x135>
  802be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bee:	8b 52 04             	mov    0x4(%edx),%edx
  802bf1:	89 50 04             	mov    %edx,0x4(%eax)
  802bf4:	eb 0b                	jmp    802c01 <alloc_block_NF+0x140>
  802bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf9:	8b 40 04             	mov    0x4(%eax),%eax
  802bfc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c04:	8b 40 04             	mov    0x4(%eax),%eax
  802c07:	85 c0                	test   %eax,%eax
  802c09:	74 0f                	je     802c1a <alloc_block_NF+0x159>
  802c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0e:	8b 40 04             	mov    0x4(%eax),%eax
  802c11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c14:	8b 12                	mov    (%edx),%edx
  802c16:	89 10                	mov    %edx,(%eax)
  802c18:	eb 0a                	jmp    802c24 <alloc_block_NF+0x163>
  802c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1d:	8b 00                	mov    (%eax),%eax
  802c1f:	a3 48 51 80 00       	mov    %eax,0x805148
  802c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c37:	a1 54 51 80 00       	mov    0x805154,%eax
  802c3c:	48                   	dec    %eax
  802c3d:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c45:	8b 40 08             	mov    0x8(%eax),%eax
  802c48:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 50 08             	mov    0x8(%eax),%edx
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	01 c2                	add    %eax,%edx
  802c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5b:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c61:	8b 40 0c             	mov    0xc(%eax),%eax
  802c64:	2b 45 08             	sub    0x8(%ebp),%eax
  802c67:	89 c2                	mov    %eax,%edx
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c72:	e9 15 04 00 00       	jmp    80308c <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c77:	a1 40 51 80 00       	mov    0x805140,%eax
  802c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c83:	74 07                	je     802c8c <alloc_block_NF+0x1cb>
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	8b 00                	mov    (%eax),%eax
  802c8a:	eb 05                	jmp    802c91 <alloc_block_NF+0x1d0>
  802c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c91:	a3 40 51 80 00       	mov    %eax,0x805140
  802c96:	a1 40 51 80 00       	mov    0x805140,%eax
  802c9b:	85 c0                	test   %eax,%eax
  802c9d:	0f 85 3e fe ff ff    	jne    802ae1 <alloc_block_NF+0x20>
  802ca3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca7:	0f 85 34 fe ff ff    	jne    802ae1 <alloc_block_NF+0x20>
  802cad:	e9 d5 03 00 00       	jmp    803087 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cb2:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cba:	e9 b1 01 00 00       	jmp    802e70 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 50 08             	mov    0x8(%eax),%edx
  802cc5:	a1 28 50 80 00       	mov    0x805028,%eax
  802cca:	39 c2                	cmp    %eax,%edx
  802ccc:	0f 82 96 01 00 00    	jb     802e68 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cdb:	0f 82 87 01 00 00    	jb     802e68 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cea:	0f 85 95 00 00 00    	jne    802d85 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802cf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf4:	75 17                	jne    802d0d <alloc_block_NF+0x24c>
  802cf6:	83 ec 04             	sub    $0x4,%esp
  802cf9:	68 38 44 80 00       	push   $0x804438
  802cfe:	68 fc 00 00 00       	push   $0xfc
  802d03:	68 8f 43 80 00       	push   $0x80438f
  802d08:	e8 af da ff ff       	call   8007bc <_panic>
  802d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d10:	8b 00                	mov    (%eax),%eax
  802d12:	85 c0                	test   %eax,%eax
  802d14:	74 10                	je     802d26 <alloc_block_NF+0x265>
  802d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1e:	8b 52 04             	mov    0x4(%edx),%edx
  802d21:	89 50 04             	mov    %edx,0x4(%eax)
  802d24:	eb 0b                	jmp    802d31 <alloc_block_NF+0x270>
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 40 04             	mov    0x4(%eax),%eax
  802d2c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d34:	8b 40 04             	mov    0x4(%eax),%eax
  802d37:	85 c0                	test   %eax,%eax
  802d39:	74 0f                	je     802d4a <alloc_block_NF+0x289>
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	8b 40 04             	mov    0x4(%eax),%eax
  802d41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d44:	8b 12                	mov    (%edx),%edx
  802d46:	89 10                	mov    %edx,(%eax)
  802d48:	eb 0a                	jmp    802d54 <alloc_block_NF+0x293>
  802d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	a3 38 51 80 00       	mov    %eax,0x805138
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d67:	a1 44 51 80 00       	mov    0x805144,%eax
  802d6c:	48                   	dec    %eax
  802d6d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	8b 40 08             	mov    0x8(%eax),%eax
  802d78:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	e9 07 03 00 00       	jmp    80308c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d88:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d8e:	0f 86 d4 00 00 00    	jbe    802e68 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d94:	a1 48 51 80 00       	mov    0x805148,%eax
  802d99:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 50 08             	mov    0x8(%eax),%edx
  802da2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802da8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dab:	8b 55 08             	mov    0x8(%ebp),%edx
  802dae:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802db1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802db5:	75 17                	jne    802dce <alloc_block_NF+0x30d>
  802db7:	83 ec 04             	sub    $0x4,%esp
  802dba:	68 38 44 80 00       	push   $0x804438
  802dbf:	68 04 01 00 00       	push   $0x104
  802dc4:	68 8f 43 80 00       	push   $0x80438f
  802dc9:	e8 ee d9 ff ff       	call   8007bc <_panic>
  802dce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd1:	8b 00                	mov    (%eax),%eax
  802dd3:	85 c0                	test   %eax,%eax
  802dd5:	74 10                	je     802de7 <alloc_block_NF+0x326>
  802dd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dda:	8b 00                	mov    (%eax),%eax
  802ddc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ddf:	8b 52 04             	mov    0x4(%edx),%edx
  802de2:	89 50 04             	mov    %edx,0x4(%eax)
  802de5:	eb 0b                	jmp    802df2 <alloc_block_NF+0x331>
  802de7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dea:	8b 40 04             	mov    0x4(%eax),%eax
  802ded:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802df2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df5:	8b 40 04             	mov    0x4(%eax),%eax
  802df8:	85 c0                	test   %eax,%eax
  802dfa:	74 0f                	je     802e0b <alloc_block_NF+0x34a>
  802dfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dff:	8b 40 04             	mov    0x4(%eax),%eax
  802e02:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e05:	8b 12                	mov    (%edx),%edx
  802e07:	89 10                	mov    %edx,(%eax)
  802e09:	eb 0a                	jmp    802e15 <alloc_block_NF+0x354>
  802e0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e0e:	8b 00                	mov    (%eax),%eax
  802e10:	a3 48 51 80 00       	mov    %eax,0x805148
  802e15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e28:	a1 54 51 80 00       	mov    0x805154,%eax
  802e2d:	48                   	dec    %eax
  802e2e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e36:	8b 40 08             	mov    0x8(%eax),%eax
  802e39:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 50 08             	mov    0x8(%eax),%edx
  802e44:	8b 45 08             	mov    0x8(%ebp),%eax
  802e47:	01 c2                	add    %eax,%edx
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	8b 40 0c             	mov    0xc(%eax),%eax
  802e55:	2b 45 08             	sub    0x8(%ebp),%eax
  802e58:	89 c2                	mov    %eax,%edx
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e63:	e9 24 02 00 00       	jmp    80308c <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e68:	a1 40 51 80 00       	mov    0x805140,%eax
  802e6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e74:	74 07                	je     802e7d <alloc_block_NF+0x3bc>
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 00                	mov    (%eax),%eax
  802e7b:	eb 05                	jmp    802e82 <alloc_block_NF+0x3c1>
  802e7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e82:	a3 40 51 80 00       	mov    %eax,0x805140
  802e87:	a1 40 51 80 00       	mov    0x805140,%eax
  802e8c:	85 c0                	test   %eax,%eax
  802e8e:	0f 85 2b fe ff ff    	jne    802cbf <alloc_block_NF+0x1fe>
  802e94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e98:	0f 85 21 fe ff ff    	jne    802cbf <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e9e:	a1 38 51 80 00       	mov    0x805138,%eax
  802ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea6:	e9 ae 01 00 00       	jmp    803059 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	8b 50 08             	mov    0x8(%eax),%edx
  802eb1:	a1 28 50 80 00       	mov    0x805028,%eax
  802eb6:	39 c2                	cmp    %eax,%edx
  802eb8:	0f 83 93 01 00 00    	jae    803051 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec7:	0f 82 84 01 00 00    	jb     803051 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed6:	0f 85 95 00 00 00    	jne    802f71 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee0:	75 17                	jne    802ef9 <alloc_block_NF+0x438>
  802ee2:	83 ec 04             	sub    $0x4,%esp
  802ee5:	68 38 44 80 00       	push   $0x804438
  802eea:	68 14 01 00 00       	push   $0x114
  802eef:	68 8f 43 80 00       	push   $0x80438f
  802ef4:	e8 c3 d8 ff ff       	call   8007bc <_panic>
  802ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efc:	8b 00                	mov    (%eax),%eax
  802efe:	85 c0                	test   %eax,%eax
  802f00:	74 10                	je     802f12 <alloc_block_NF+0x451>
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 00                	mov    (%eax),%eax
  802f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0a:	8b 52 04             	mov    0x4(%edx),%edx
  802f0d:	89 50 04             	mov    %edx,0x4(%eax)
  802f10:	eb 0b                	jmp    802f1d <alloc_block_NF+0x45c>
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 40 04             	mov    0x4(%eax),%eax
  802f18:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 40 04             	mov    0x4(%eax),%eax
  802f23:	85 c0                	test   %eax,%eax
  802f25:	74 0f                	je     802f36 <alloc_block_NF+0x475>
  802f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2a:	8b 40 04             	mov    0x4(%eax),%eax
  802f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f30:	8b 12                	mov    (%edx),%edx
  802f32:	89 10                	mov    %edx,(%eax)
  802f34:	eb 0a                	jmp    802f40 <alloc_block_NF+0x47f>
  802f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f39:	8b 00                	mov    (%eax),%eax
  802f3b:	a3 38 51 80 00       	mov    %eax,0x805138
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f53:	a1 44 51 80 00       	mov    0x805144,%eax
  802f58:	48                   	dec    %eax
  802f59:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f61:	8b 40 08             	mov    0x8(%eax),%eax
  802f64:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	e9 1b 01 00 00       	jmp    80308c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f74:	8b 40 0c             	mov    0xc(%eax),%eax
  802f77:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f7a:	0f 86 d1 00 00 00    	jbe    803051 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f80:	a1 48 51 80 00       	mov    0x805148,%eax
  802f85:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 50 08             	mov    0x8(%eax),%edx
  802f8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f91:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f97:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fa1:	75 17                	jne    802fba <alloc_block_NF+0x4f9>
  802fa3:	83 ec 04             	sub    $0x4,%esp
  802fa6:	68 38 44 80 00       	push   $0x804438
  802fab:	68 1c 01 00 00       	push   $0x11c
  802fb0:	68 8f 43 80 00       	push   $0x80438f
  802fb5:	e8 02 d8 ff ff       	call   8007bc <_panic>
  802fba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbd:	8b 00                	mov    (%eax),%eax
  802fbf:	85 c0                	test   %eax,%eax
  802fc1:	74 10                	je     802fd3 <alloc_block_NF+0x512>
  802fc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fcb:	8b 52 04             	mov    0x4(%edx),%edx
  802fce:	89 50 04             	mov    %edx,0x4(%eax)
  802fd1:	eb 0b                	jmp    802fde <alloc_block_NF+0x51d>
  802fd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd6:	8b 40 04             	mov    0x4(%eax),%eax
  802fd9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe1:	8b 40 04             	mov    0x4(%eax),%eax
  802fe4:	85 c0                	test   %eax,%eax
  802fe6:	74 0f                	je     802ff7 <alloc_block_NF+0x536>
  802fe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802feb:	8b 40 04             	mov    0x4(%eax),%eax
  802fee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ff1:	8b 12                	mov    (%edx),%edx
  802ff3:	89 10                	mov    %edx,(%eax)
  802ff5:	eb 0a                	jmp    803001 <alloc_block_NF+0x540>
  802ff7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffa:	8b 00                	mov    (%eax),%eax
  802ffc:	a3 48 51 80 00       	mov    %eax,0x805148
  803001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803014:	a1 54 51 80 00       	mov    0x805154,%eax
  803019:	48                   	dec    %eax
  80301a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80301f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803022:	8b 40 08             	mov    0x8(%eax),%eax
  803025:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80302a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302d:	8b 50 08             	mov    0x8(%eax),%edx
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	01 c2                	add    %eax,%edx
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80303b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303e:	8b 40 0c             	mov    0xc(%eax),%eax
  803041:	2b 45 08             	sub    0x8(%ebp),%eax
  803044:	89 c2                	mov    %eax,%edx
  803046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803049:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80304c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304f:	eb 3b                	jmp    80308c <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803051:	a1 40 51 80 00       	mov    0x805140,%eax
  803056:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803059:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305d:	74 07                	je     803066 <alloc_block_NF+0x5a5>
  80305f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803062:	8b 00                	mov    (%eax),%eax
  803064:	eb 05                	jmp    80306b <alloc_block_NF+0x5aa>
  803066:	b8 00 00 00 00       	mov    $0x0,%eax
  80306b:	a3 40 51 80 00       	mov    %eax,0x805140
  803070:	a1 40 51 80 00       	mov    0x805140,%eax
  803075:	85 c0                	test   %eax,%eax
  803077:	0f 85 2e fe ff ff    	jne    802eab <alloc_block_NF+0x3ea>
  80307d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803081:	0f 85 24 fe ff ff    	jne    802eab <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803087:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80308c:	c9                   	leave  
  80308d:	c3                   	ret    

0080308e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80308e:	55                   	push   %ebp
  80308f:	89 e5                	mov    %esp,%ebp
  803091:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803094:	a1 38 51 80 00       	mov    0x805138,%eax
  803099:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80309c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030a1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8030a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a9:	85 c0                	test   %eax,%eax
  8030ab:	74 14                	je     8030c1 <insert_sorted_with_merge_freeList+0x33>
  8030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b0:	8b 50 08             	mov    0x8(%eax),%edx
  8030b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b6:	8b 40 08             	mov    0x8(%eax),%eax
  8030b9:	39 c2                	cmp    %eax,%edx
  8030bb:	0f 87 9b 01 00 00    	ja     80325c <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8030c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c5:	75 17                	jne    8030de <insert_sorted_with_merge_freeList+0x50>
  8030c7:	83 ec 04             	sub    $0x4,%esp
  8030ca:	68 6c 43 80 00       	push   $0x80436c
  8030cf:	68 38 01 00 00       	push   $0x138
  8030d4:	68 8f 43 80 00       	push   $0x80438f
  8030d9:	e8 de d6 ff ff       	call   8007bc <_panic>
  8030de:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e7:	89 10                	mov    %edx,(%eax)
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	8b 00                	mov    (%eax),%eax
  8030ee:	85 c0                	test   %eax,%eax
  8030f0:	74 0d                	je     8030ff <insert_sorted_with_merge_freeList+0x71>
  8030f2:	a1 38 51 80 00       	mov    0x805138,%eax
  8030f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fa:	89 50 04             	mov    %edx,0x4(%eax)
  8030fd:	eb 08                	jmp    803107 <insert_sorted_with_merge_freeList+0x79>
  8030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803102:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	a3 38 51 80 00       	mov    %eax,0x805138
  80310f:	8b 45 08             	mov    0x8(%ebp),%eax
  803112:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803119:	a1 44 51 80 00       	mov    0x805144,%eax
  80311e:	40                   	inc    %eax
  80311f:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803124:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803128:	0f 84 a8 06 00 00    	je     8037d6 <insert_sorted_with_merge_freeList+0x748>
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	8b 50 08             	mov    0x8(%eax),%edx
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	8b 40 0c             	mov    0xc(%eax),%eax
  80313a:	01 c2                	add    %eax,%edx
  80313c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313f:	8b 40 08             	mov    0x8(%eax),%eax
  803142:	39 c2                	cmp    %eax,%edx
  803144:	0f 85 8c 06 00 00    	jne    8037d6 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	8b 50 0c             	mov    0xc(%eax),%edx
  803150:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803153:	8b 40 0c             	mov    0xc(%eax),%eax
  803156:	01 c2                	add    %eax,%edx
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80315e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803162:	75 17                	jne    80317b <insert_sorted_with_merge_freeList+0xed>
  803164:	83 ec 04             	sub    $0x4,%esp
  803167:	68 38 44 80 00       	push   $0x804438
  80316c:	68 3c 01 00 00       	push   $0x13c
  803171:	68 8f 43 80 00       	push   $0x80438f
  803176:	e8 41 d6 ff ff       	call   8007bc <_panic>
  80317b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317e:	8b 00                	mov    (%eax),%eax
  803180:	85 c0                	test   %eax,%eax
  803182:	74 10                	je     803194 <insert_sorted_with_merge_freeList+0x106>
  803184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803187:	8b 00                	mov    (%eax),%eax
  803189:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80318c:	8b 52 04             	mov    0x4(%edx),%edx
  80318f:	89 50 04             	mov    %edx,0x4(%eax)
  803192:	eb 0b                	jmp    80319f <insert_sorted_with_merge_freeList+0x111>
  803194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803197:	8b 40 04             	mov    0x4(%eax),%eax
  80319a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80319f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a2:	8b 40 04             	mov    0x4(%eax),%eax
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	74 0f                	je     8031b8 <insert_sorted_with_merge_freeList+0x12a>
  8031a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ac:	8b 40 04             	mov    0x4(%eax),%eax
  8031af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031b2:	8b 12                	mov    (%edx),%edx
  8031b4:	89 10                	mov    %edx,(%eax)
  8031b6:	eb 0a                	jmp    8031c2 <insert_sorted_with_merge_freeList+0x134>
  8031b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bb:	8b 00                	mov    (%eax),%eax
  8031bd:	a3 38 51 80 00       	mov    %eax,0x805138
  8031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d5:	a1 44 51 80 00       	mov    0x805144,%eax
  8031da:	48                   	dec    %eax
  8031db:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8031e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8031ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8031f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031f8:	75 17                	jne    803211 <insert_sorted_with_merge_freeList+0x183>
  8031fa:	83 ec 04             	sub    $0x4,%esp
  8031fd:	68 6c 43 80 00       	push   $0x80436c
  803202:	68 3f 01 00 00       	push   $0x13f
  803207:	68 8f 43 80 00       	push   $0x80438f
  80320c:	e8 ab d5 ff ff       	call   8007bc <_panic>
  803211:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803217:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321a:	89 10                	mov    %edx,(%eax)
  80321c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321f:	8b 00                	mov    (%eax),%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	74 0d                	je     803232 <insert_sorted_with_merge_freeList+0x1a4>
  803225:	a1 48 51 80 00       	mov    0x805148,%eax
  80322a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80322d:	89 50 04             	mov    %edx,0x4(%eax)
  803230:	eb 08                	jmp    80323a <insert_sorted_with_merge_freeList+0x1ac>
  803232:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803235:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80323a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323d:	a3 48 51 80 00       	mov    %eax,0x805148
  803242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803245:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324c:	a1 54 51 80 00       	mov    0x805154,%eax
  803251:	40                   	inc    %eax
  803252:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803257:	e9 7a 05 00 00       	jmp    8037d6 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	8b 50 08             	mov    0x8(%eax),%edx
  803262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803265:	8b 40 08             	mov    0x8(%eax),%eax
  803268:	39 c2                	cmp    %eax,%edx
  80326a:	0f 82 14 01 00 00    	jb     803384 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803273:	8b 50 08             	mov    0x8(%eax),%edx
  803276:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803279:	8b 40 0c             	mov    0xc(%eax),%eax
  80327c:	01 c2                	add    %eax,%edx
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	8b 40 08             	mov    0x8(%eax),%eax
  803284:	39 c2                	cmp    %eax,%edx
  803286:	0f 85 90 00 00 00    	jne    80331c <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80328c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328f:	8b 50 0c             	mov    0xc(%eax),%edx
  803292:	8b 45 08             	mov    0x8(%ebp),%eax
  803295:	8b 40 0c             	mov    0xc(%eax),%eax
  803298:	01 c2                	add    %eax,%edx
  80329a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80329d:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8032aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b8:	75 17                	jne    8032d1 <insert_sorted_with_merge_freeList+0x243>
  8032ba:	83 ec 04             	sub    $0x4,%esp
  8032bd:	68 6c 43 80 00       	push   $0x80436c
  8032c2:	68 49 01 00 00       	push   $0x149
  8032c7:	68 8f 43 80 00       	push   $0x80438f
  8032cc:	e8 eb d4 ff ff       	call   8007bc <_panic>
  8032d1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032da:	89 10                	mov    %edx,(%eax)
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	8b 00                	mov    (%eax),%eax
  8032e1:	85 c0                	test   %eax,%eax
  8032e3:	74 0d                	je     8032f2 <insert_sorted_with_merge_freeList+0x264>
  8032e5:	a1 48 51 80 00       	mov    0x805148,%eax
  8032ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ed:	89 50 04             	mov    %edx,0x4(%eax)
  8032f0:	eb 08                	jmp    8032fa <insert_sorted_with_merge_freeList+0x26c>
  8032f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fd:	a3 48 51 80 00       	mov    %eax,0x805148
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80330c:	a1 54 51 80 00       	mov    0x805154,%eax
  803311:	40                   	inc    %eax
  803312:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803317:	e9 bb 04 00 00       	jmp    8037d7 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80331c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803320:	75 17                	jne    803339 <insert_sorted_with_merge_freeList+0x2ab>
  803322:	83 ec 04             	sub    $0x4,%esp
  803325:	68 e0 43 80 00       	push   $0x8043e0
  80332a:	68 4c 01 00 00       	push   $0x14c
  80332f:	68 8f 43 80 00       	push   $0x80438f
  803334:	e8 83 d4 ff ff       	call   8007bc <_panic>
  803339:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	89 50 04             	mov    %edx,0x4(%eax)
  803345:	8b 45 08             	mov    0x8(%ebp),%eax
  803348:	8b 40 04             	mov    0x4(%eax),%eax
  80334b:	85 c0                	test   %eax,%eax
  80334d:	74 0c                	je     80335b <insert_sorted_with_merge_freeList+0x2cd>
  80334f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803354:	8b 55 08             	mov    0x8(%ebp),%edx
  803357:	89 10                	mov    %edx,(%eax)
  803359:	eb 08                	jmp    803363 <insert_sorted_with_merge_freeList+0x2d5>
  80335b:	8b 45 08             	mov    0x8(%ebp),%eax
  80335e:	a3 38 51 80 00       	mov    %eax,0x805138
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803374:	a1 44 51 80 00       	mov    0x805144,%eax
  803379:	40                   	inc    %eax
  80337a:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80337f:	e9 53 04 00 00       	jmp    8037d7 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803384:	a1 38 51 80 00       	mov    0x805138,%eax
  803389:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80338c:	e9 15 04 00 00       	jmp    8037a6 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803394:	8b 00                	mov    (%eax),%eax
  803396:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	8b 50 08             	mov    0x8(%eax),%edx
  80339f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a2:	8b 40 08             	mov    0x8(%eax),%eax
  8033a5:	39 c2                	cmp    %eax,%edx
  8033a7:	0f 86 f1 03 00 00    	jbe    80379e <insert_sorted_with_merge_freeList+0x710>
  8033ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b0:	8b 50 08             	mov    0x8(%eax),%edx
  8033b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b6:	8b 40 08             	mov    0x8(%eax),%eax
  8033b9:	39 c2                	cmp    %eax,%edx
  8033bb:	0f 83 dd 03 00 00    	jae    80379e <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8033c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c4:	8b 50 08             	mov    0x8(%eax),%edx
  8033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8033cd:	01 c2                	add    %eax,%edx
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	8b 40 08             	mov    0x8(%eax),%eax
  8033d5:	39 c2                	cmp    %eax,%edx
  8033d7:	0f 85 b9 01 00 00    	jne    803596 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e0:	8b 50 08             	mov    0x8(%eax),%edx
  8033e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e9:	01 c2                	add    %eax,%edx
  8033eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ee:	8b 40 08             	mov    0x8(%eax),%eax
  8033f1:	39 c2                	cmp    %eax,%edx
  8033f3:	0f 85 0d 01 00 00    	jne    803506 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fc:	8b 50 0c             	mov    0xc(%eax),%edx
  8033ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803402:	8b 40 0c             	mov    0xc(%eax),%eax
  803405:	01 c2                	add    %eax,%edx
  803407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340a:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80340d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803411:	75 17                	jne    80342a <insert_sorted_with_merge_freeList+0x39c>
  803413:	83 ec 04             	sub    $0x4,%esp
  803416:	68 38 44 80 00       	push   $0x804438
  80341b:	68 5c 01 00 00       	push   $0x15c
  803420:	68 8f 43 80 00       	push   $0x80438f
  803425:	e8 92 d3 ff ff       	call   8007bc <_panic>
  80342a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342d:	8b 00                	mov    (%eax),%eax
  80342f:	85 c0                	test   %eax,%eax
  803431:	74 10                	je     803443 <insert_sorted_with_merge_freeList+0x3b5>
  803433:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803436:	8b 00                	mov    (%eax),%eax
  803438:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80343b:	8b 52 04             	mov    0x4(%edx),%edx
  80343e:	89 50 04             	mov    %edx,0x4(%eax)
  803441:	eb 0b                	jmp    80344e <insert_sorted_with_merge_freeList+0x3c0>
  803443:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803446:	8b 40 04             	mov    0x4(%eax),%eax
  803449:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80344e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803451:	8b 40 04             	mov    0x4(%eax),%eax
  803454:	85 c0                	test   %eax,%eax
  803456:	74 0f                	je     803467 <insert_sorted_with_merge_freeList+0x3d9>
  803458:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345b:	8b 40 04             	mov    0x4(%eax),%eax
  80345e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803461:	8b 12                	mov    (%edx),%edx
  803463:	89 10                	mov    %edx,(%eax)
  803465:	eb 0a                	jmp    803471 <insert_sorted_with_merge_freeList+0x3e3>
  803467:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346a:	8b 00                	mov    (%eax),%eax
  80346c:	a3 38 51 80 00       	mov    %eax,0x805138
  803471:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803474:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80347a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803484:	a1 44 51 80 00       	mov    0x805144,%eax
  803489:	48                   	dec    %eax
  80348a:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80348f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803492:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803499:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034a3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034a7:	75 17                	jne    8034c0 <insert_sorted_with_merge_freeList+0x432>
  8034a9:	83 ec 04             	sub    $0x4,%esp
  8034ac:	68 6c 43 80 00       	push   $0x80436c
  8034b1:	68 5f 01 00 00       	push   $0x15f
  8034b6:	68 8f 43 80 00       	push   $0x80438f
  8034bb:	e8 fc d2 ff ff       	call   8007bc <_panic>
  8034c0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c9:	89 10                	mov    %edx,(%eax)
  8034cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ce:	8b 00                	mov    (%eax),%eax
  8034d0:	85 c0                	test   %eax,%eax
  8034d2:	74 0d                	je     8034e1 <insert_sorted_with_merge_freeList+0x453>
  8034d4:	a1 48 51 80 00       	mov    0x805148,%eax
  8034d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034dc:	89 50 04             	mov    %edx,0x4(%eax)
  8034df:	eb 08                	jmp    8034e9 <insert_sorted_with_merge_freeList+0x45b>
  8034e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8034f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034fb:	a1 54 51 80 00       	mov    0x805154,%eax
  803500:	40                   	inc    %eax
  803501:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803509:	8b 50 0c             	mov    0xc(%eax),%edx
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	8b 40 0c             	mov    0xc(%eax),%eax
  803512:	01 c2                	add    %eax,%edx
  803514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803517:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80351a:	8b 45 08             	mov    0x8(%ebp),%eax
  80351d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803524:	8b 45 08             	mov    0x8(%ebp),%eax
  803527:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80352e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803532:	75 17                	jne    80354b <insert_sorted_with_merge_freeList+0x4bd>
  803534:	83 ec 04             	sub    $0x4,%esp
  803537:	68 6c 43 80 00       	push   $0x80436c
  80353c:	68 64 01 00 00       	push   $0x164
  803541:	68 8f 43 80 00       	push   $0x80438f
  803546:	e8 71 d2 ff ff       	call   8007bc <_panic>
  80354b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803551:	8b 45 08             	mov    0x8(%ebp),%eax
  803554:	89 10                	mov    %edx,(%eax)
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	8b 00                	mov    (%eax),%eax
  80355b:	85 c0                	test   %eax,%eax
  80355d:	74 0d                	je     80356c <insert_sorted_with_merge_freeList+0x4de>
  80355f:	a1 48 51 80 00       	mov    0x805148,%eax
  803564:	8b 55 08             	mov    0x8(%ebp),%edx
  803567:	89 50 04             	mov    %edx,0x4(%eax)
  80356a:	eb 08                	jmp    803574 <insert_sorted_with_merge_freeList+0x4e6>
  80356c:	8b 45 08             	mov    0x8(%ebp),%eax
  80356f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803574:	8b 45 08             	mov    0x8(%ebp),%eax
  803577:	a3 48 51 80 00       	mov    %eax,0x805148
  80357c:	8b 45 08             	mov    0x8(%ebp),%eax
  80357f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803586:	a1 54 51 80 00       	mov    0x805154,%eax
  80358b:	40                   	inc    %eax
  80358c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803591:	e9 41 02 00 00       	jmp    8037d7 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803596:	8b 45 08             	mov    0x8(%ebp),%eax
  803599:	8b 50 08             	mov    0x8(%eax),%edx
  80359c:	8b 45 08             	mov    0x8(%ebp),%eax
  80359f:	8b 40 0c             	mov    0xc(%eax),%eax
  8035a2:	01 c2                	add    %eax,%edx
  8035a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a7:	8b 40 08             	mov    0x8(%eax),%eax
  8035aa:	39 c2                	cmp    %eax,%edx
  8035ac:	0f 85 7c 01 00 00    	jne    80372e <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8035b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035b6:	74 06                	je     8035be <insert_sorted_with_merge_freeList+0x530>
  8035b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035bc:	75 17                	jne    8035d5 <insert_sorted_with_merge_freeList+0x547>
  8035be:	83 ec 04             	sub    $0x4,%esp
  8035c1:	68 a8 43 80 00       	push   $0x8043a8
  8035c6:	68 69 01 00 00       	push   $0x169
  8035cb:	68 8f 43 80 00       	push   $0x80438f
  8035d0:	e8 e7 d1 ff ff       	call   8007bc <_panic>
  8035d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d8:	8b 50 04             	mov    0x4(%eax),%edx
  8035db:	8b 45 08             	mov    0x8(%ebp),%eax
  8035de:	89 50 04             	mov    %edx,0x4(%eax)
  8035e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035e7:	89 10                	mov    %edx,(%eax)
  8035e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ec:	8b 40 04             	mov    0x4(%eax),%eax
  8035ef:	85 c0                	test   %eax,%eax
  8035f1:	74 0d                	je     803600 <insert_sorted_with_merge_freeList+0x572>
  8035f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f6:	8b 40 04             	mov    0x4(%eax),%eax
  8035f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8035fc:	89 10                	mov    %edx,(%eax)
  8035fe:	eb 08                	jmp    803608 <insert_sorted_with_merge_freeList+0x57a>
  803600:	8b 45 08             	mov    0x8(%ebp),%eax
  803603:	a3 38 51 80 00       	mov    %eax,0x805138
  803608:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360b:	8b 55 08             	mov    0x8(%ebp),%edx
  80360e:	89 50 04             	mov    %edx,0x4(%eax)
  803611:	a1 44 51 80 00       	mov    0x805144,%eax
  803616:	40                   	inc    %eax
  803617:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80361c:	8b 45 08             	mov    0x8(%ebp),%eax
  80361f:	8b 50 0c             	mov    0xc(%eax),%edx
  803622:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803625:	8b 40 0c             	mov    0xc(%eax),%eax
  803628:	01 c2                	add    %eax,%edx
  80362a:	8b 45 08             	mov    0x8(%ebp),%eax
  80362d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803630:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803634:	75 17                	jne    80364d <insert_sorted_with_merge_freeList+0x5bf>
  803636:	83 ec 04             	sub    $0x4,%esp
  803639:	68 38 44 80 00       	push   $0x804438
  80363e:	68 6b 01 00 00       	push   $0x16b
  803643:	68 8f 43 80 00       	push   $0x80438f
  803648:	e8 6f d1 ff ff       	call   8007bc <_panic>
  80364d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803650:	8b 00                	mov    (%eax),%eax
  803652:	85 c0                	test   %eax,%eax
  803654:	74 10                	je     803666 <insert_sorted_with_merge_freeList+0x5d8>
  803656:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803659:	8b 00                	mov    (%eax),%eax
  80365b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80365e:	8b 52 04             	mov    0x4(%edx),%edx
  803661:	89 50 04             	mov    %edx,0x4(%eax)
  803664:	eb 0b                	jmp    803671 <insert_sorted_with_merge_freeList+0x5e3>
  803666:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803669:	8b 40 04             	mov    0x4(%eax),%eax
  80366c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803671:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803674:	8b 40 04             	mov    0x4(%eax),%eax
  803677:	85 c0                	test   %eax,%eax
  803679:	74 0f                	je     80368a <insert_sorted_with_merge_freeList+0x5fc>
  80367b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367e:	8b 40 04             	mov    0x4(%eax),%eax
  803681:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803684:	8b 12                	mov    (%edx),%edx
  803686:	89 10                	mov    %edx,(%eax)
  803688:	eb 0a                	jmp    803694 <insert_sorted_with_merge_freeList+0x606>
  80368a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368d:	8b 00                	mov    (%eax),%eax
  80368f:	a3 38 51 80 00       	mov    %eax,0x805138
  803694:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803697:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80369d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a7:	a1 44 51 80 00       	mov    0x805144,%eax
  8036ac:	48                   	dec    %eax
  8036ad:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8036b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8036bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036bf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8036c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036ca:	75 17                	jne    8036e3 <insert_sorted_with_merge_freeList+0x655>
  8036cc:	83 ec 04             	sub    $0x4,%esp
  8036cf:	68 6c 43 80 00       	push   $0x80436c
  8036d4:	68 6e 01 00 00       	push   $0x16e
  8036d9:	68 8f 43 80 00       	push   $0x80438f
  8036de:	e8 d9 d0 ff ff       	call   8007bc <_panic>
  8036e3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ec:	89 10                	mov    %edx,(%eax)
  8036ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f1:	8b 00                	mov    (%eax),%eax
  8036f3:	85 c0                	test   %eax,%eax
  8036f5:	74 0d                	je     803704 <insert_sorted_with_merge_freeList+0x676>
  8036f7:	a1 48 51 80 00       	mov    0x805148,%eax
  8036fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036ff:	89 50 04             	mov    %edx,0x4(%eax)
  803702:	eb 08                	jmp    80370c <insert_sorted_with_merge_freeList+0x67e>
  803704:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803707:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80370c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370f:	a3 48 51 80 00       	mov    %eax,0x805148
  803714:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803717:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80371e:	a1 54 51 80 00       	mov    0x805154,%eax
  803723:	40                   	inc    %eax
  803724:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803729:	e9 a9 00 00 00       	jmp    8037d7 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80372e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803732:	74 06                	je     80373a <insert_sorted_with_merge_freeList+0x6ac>
  803734:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803738:	75 17                	jne    803751 <insert_sorted_with_merge_freeList+0x6c3>
  80373a:	83 ec 04             	sub    $0x4,%esp
  80373d:	68 04 44 80 00       	push   $0x804404
  803742:	68 73 01 00 00       	push   $0x173
  803747:	68 8f 43 80 00       	push   $0x80438f
  80374c:	e8 6b d0 ff ff       	call   8007bc <_panic>
  803751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803754:	8b 10                	mov    (%eax),%edx
  803756:	8b 45 08             	mov    0x8(%ebp),%eax
  803759:	89 10                	mov    %edx,(%eax)
  80375b:	8b 45 08             	mov    0x8(%ebp),%eax
  80375e:	8b 00                	mov    (%eax),%eax
  803760:	85 c0                	test   %eax,%eax
  803762:	74 0b                	je     80376f <insert_sorted_with_merge_freeList+0x6e1>
  803764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803767:	8b 00                	mov    (%eax),%eax
  803769:	8b 55 08             	mov    0x8(%ebp),%edx
  80376c:	89 50 04             	mov    %edx,0x4(%eax)
  80376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803772:	8b 55 08             	mov    0x8(%ebp),%edx
  803775:	89 10                	mov    %edx,(%eax)
  803777:	8b 45 08             	mov    0x8(%ebp),%eax
  80377a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80377d:	89 50 04             	mov    %edx,0x4(%eax)
  803780:	8b 45 08             	mov    0x8(%ebp),%eax
  803783:	8b 00                	mov    (%eax),%eax
  803785:	85 c0                	test   %eax,%eax
  803787:	75 08                	jne    803791 <insert_sorted_with_merge_freeList+0x703>
  803789:	8b 45 08             	mov    0x8(%ebp),%eax
  80378c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803791:	a1 44 51 80 00       	mov    0x805144,%eax
  803796:	40                   	inc    %eax
  803797:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80379c:	eb 39                	jmp    8037d7 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80379e:	a1 40 51 80 00       	mov    0x805140,%eax
  8037a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037aa:	74 07                	je     8037b3 <insert_sorted_with_merge_freeList+0x725>
  8037ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037af:	8b 00                	mov    (%eax),%eax
  8037b1:	eb 05                	jmp    8037b8 <insert_sorted_with_merge_freeList+0x72a>
  8037b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8037b8:	a3 40 51 80 00       	mov    %eax,0x805140
  8037bd:	a1 40 51 80 00       	mov    0x805140,%eax
  8037c2:	85 c0                	test   %eax,%eax
  8037c4:	0f 85 c7 fb ff ff    	jne    803391 <insert_sorted_with_merge_freeList+0x303>
  8037ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ce:	0f 85 bd fb ff ff    	jne    803391 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037d4:	eb 01                	jmp    8037d7 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037d6:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037d7:	90                   	nop
  8037d8:	c9                   	leave  
  8037d9:	c3                   	ret    
  8037da:	66 90                	xchg   %ax,%ax

008037dc <__udivdi3>:
  8037dc:	55                   	push   %ebp
  8037dd:	57                   	push   %edi
  8037de:	56                   	push   %esi
  8037df:	53                   	push   %ebx
  8037e0:	83 ec 1c             	sub    $0x1c,%esp
  8037e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037f3:	89 ca                	mov    %ecx,%edx
  8037f5:	89 f8                	mov    %edi,%eax
  8037f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037fb:	85 f6                	test   %esi,%esi
  8037fd:	75 2d                	jne    80382c <__udivdi3+0x50>
  8037ff:	39 cf                	cmp    %ecx,%edi
  803801:	77 65                	ja     803868 <__udivdi3+0x8c>
  803803:	89 fd                	mov    %edi,%ebp
  803805:	85 ff                	test   %edi,%edi
  803807:	75 0b                	jne    803814 <__udivdi3+0x38>
  803809:	b8 01 00 00 00       	mov    $0x1,%eax
  80380e:	31 d2                	xor    %edx,%edx
  803810:	f7 f7                	div    %edi
  803812:	89 c5                	mov    %eax,%ebp
  803814:	31 d2                	xor    %edx,%edx
  803816:	89 c8                	mov    %ecx,%eax
  803818:	f7 f5                	div    %ebp
  80381a:	89 c1                	mov    %eax,%ecx
  80381c:	89 d8                	mov    %ebx,%eax
  80381e:	f7 f5                	div    %ebp
  803820:	89 cf                	mov    %ecx,%edi
  803822:	89 fa                	mov    %edi,%edx
  803824:	83 c4 1c             	add    $0x1c,%esp
  803827:	5b                   	pop    %ebx
  803828:	5e                   	pop    %esi
  803829:	5f                   	pop    %edi
  80382a:	5d                   	pop    %ebp
  80382b:	c3                   	ret    
  80382c:	39 ce                	cmp    %ecx,%esi
  80382e:	77 28                	ja     803858 <__udivdi3+0x7c>
  803830:	0f bd fe             	bsr    %esi,%edi
  803833:	83 f7 1f             	xor    $0x1f,%edi
  803836:	75 40                	jne    803878 <__udivdi3+0x9c>
  803838:	39 ce                	cmp    %ecx,%esi
  80383a:	72 0a                	jb     803846 <__udivdi3+0x6a>
  80383c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803840:	0f 87 9e 00 00 00    	ja     8038e4 <__udivdi3+0x108>
  803846:	b8 01 00 00 00       	mov    $0x1,%eax
  80384b:	89 fa                	mov    %edi,%edx
  80384d:	83 c4 1c             	add    $0x1c,%esp
  803850:	5b                   	pop    %ebx
  803851:	5e                   	pop    %esi
  803852:	5f                   	pop    %edi
  803853:	5d                   	pop    %ebp
  803854:	c3                   	ret    
  803855:	8d 76 00             	lea    0x0(%esi),%esi
  803858:	31 ff                	xor    %edi,%edi
  80385a:	31 c0                	xor    %eax,%eax
  80385c:	89 fa                	mov    %edi,%edx
  80385e:	83 c4 1c             	add    $0x1c,%esp
  803861:	5b                   	pop    %ebx
  803862:	5e                   	pop    %esi
  803863:	5f                   	pop    %edi
  803864:	5d                   	pop    %ebp
  803865:	c3                   	ret    
  803866:	66 90                	xchg   %ax,%ax
  803868:	89 d8                	mov    %ebx,%eax
  80386a:	f7 f7                	div    %edi
  80386c:	31 ff                	xor    %edi,%edi
  80386e:	89 fa                	mov    %edi,%edx
  803870:	83 c4 1c             	add    $0x1c,%esp
  803873:	5b                   	pop    %ebx
  803874:	5e                   	pop    %esi
  803875:	5f                   	pop    %edi
  803876:	5d                   	pop    %ebp
  803877:	c3                   	ret    
  803878:	bd 20 00 00 00       	mov    $0x20,%ebp
  80387d:	89 eb                	mov    %ebp,%ebx
  80387f:	29 fb                	sub    %edi,%ebx
  803881:	89 f9                	mov    %edi,%ecx
  803883:	d3 e6                	shl    %cl,%esi
  803885:	89 c5                	mov    %eax,%ebp
  803887:	88 d9                	mov    %bl,%cl
  803889:	d3 ed                	shr    %cl,%ebp
  80388b:	89 e9                	mov    %ebp,%ecx
  80388d:	09 f1                	or     %esi,%ecx
  80388f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803893:	89 f9                	mov    %edi,%ecx
  803895:	d3 e0                	shl    %cl,%eax
  803897:	89 c5                	mov    %eax,%ebp
  803899:	89 d6                	mov    %edx,%esi
  80389b:	88 d9                	mov    %bl,%cl
  80389d:	d3 ee                	shr    %cl,%esi
  80389f:	89 f9                	mov    %edi,%ecx
  8038a1:	d3 e2                	shl    %cl,%edx
  8038a3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038a7:	88 d9                	mov    %bl,%cl
  8038a9:	d3 e8                	shr    %cl,%eax
  8038ab:	09 c2                	or     %eax,%edx
  8038ad:	89 d0                	mov    %edx,%eax
  8038af:	89 f2                	mov    %esi,%edx
  8038b1:	f7 74 24 0c          	divl   0xc(%esp)
  8038b5:	89 d6                	mov    %edx,%esi
  8038b7:	89 c3                	mov    %eax,%ebx
  8038b9:	f7 e5                	mul    %ebp
  8038bb:	39 d6                	cmp    %edx,%esi
  8038bd:	72 19                	jb     8038d8 <__udivdi3+0xfc>
  8038bf:	74 0b                	je     8038cc <__udivdi3+0xf0>
  8038c1:	89 d8                	mov    %ebx,%eax
  8038c3:	31 ff                	xor    %edi,%edi
  8038c5:	e9 58 ff ff ff       	jmp    803822 <__udivdi3+0x46>
  8038ca:	66 90                	xchg   %ax,%ax
  8038cc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038d0:	89 f9                	mov    %edi,%ecx
  8038d2:	d3 e2                	shl    %cl,%edx
  8038d4:	39 c2                	cmp    %eax,%edx
  8038d6:	73 e9                	jae    8038c1 <__udivdi3+0xe5>
  8038d8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038db:	31 ff                	xor    %edi,%edi
  8038dd:	e9 40 ff ff ff       	jmp    803822 <__udivdi3+0x46>
  8038e2:	66 90                	xchg   %ax,%ax
  8038e4:	31 c0                	xor    %eax,%eax
  8038e6:	e9 37 ff ff ff       	jmp    803822 <__udivdi3+0x46>
  8038eb:	90                   	nop

008038ec <__umoddi3>:
  8038ec:	55                   	push   %ebp
  8038ed:	57                   	push   %edi
  8038ee:	56                   	push   %esi
  8038ef:	53                   	push   %ebx
  8038f0:	83 ec 1c             	sub    $0x1c,%esp
  8038f3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038f7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038ff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803903:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803907:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80390b:	89 f3                	mov    %esi,%ebx
  80390d:	89 fa                	mov    %edi,%edx
  80390f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803913:	89 34 24             	mov    %esi,(%esp)
  803916:	85 c0                	test   %eax,%eax
  803918:	75 1a                	jne    803934 <__umoddi3+0x48>
  80391a:	39 f7                	cmp    %esi,%edi
  80391c:	0f 86 a2 00 00 00    	jbe    8039c4 <__umoddi3+0xd8>
  803922:	89 c8                	mov    %ecx,%eax
  803924:	89 f2                	mov    %esi,%edx
  803926:	f7 f7                	div    %edi
  803928:	89 d0                	mov    %edx,%eax
  80392a:	31 d2                	xor    %edx,%edx
  80392c:	83 c4 1c             	add    $0x1c,%esp
  80392f:	5b                   	pop    %ebx
  803930:	5e                   	pop    %esi
  803931:	5f                   	pop    %edi
  803932:	5d                   	pop    %ebp
  803933:	c3                   	ret    
  803934:	39 f0                	cmp    %esi,%eax
  803936:	0f 87 ac 00 00 00    	ja     8039e8 <__umoddi3+0xfc>
  80393c:	0f bd e8             	bsr    %eax,%ebp
  80393f:	83 f5 1f             	xor    $0x1f,%ebp
  803942:	0f 84 ac 00 00 00    	je     8039f4 <__umoddi3+0x108>
  803948:	bf 20 00 00 00       	mov    $0x20,%edi
  80394d:	29 ef                	sub    %ebp,%edi
  80394f:	89 fe                	mov    %edi,%esi
  803951:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803955:	89 e9                	mov    %ebp,%ecx
  803957:	d3 e0                	shl    %cl,%eax
  803959:	89 d7                	mov    %edx,%edi
  80395b:	89 f1                	mov    %esi,%ecx
  80395d:	d3 ef                	shr    %cl,%edi
  80395f:	09 c7                	or     %eax,%edi
  803961:	89 e9                	mov    %ebp,%ecx
  803963:	d3 e2                	shl    %cl,%edx
  803965:	89 14 24             	mov    %edx,(%esp)
  803968:	89 d8                	mov    %ebx,%eax
  80396a:	d3 e0                	shl    %cl,%eax
  80396c:	89 c2                	mov    %eax,%edx
  80396e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803972:	d3 e0                	shl    %cl,%eax
  803974:	89 44 24 04          	mov    %eax,0x4(%esp)
  803978:	8b 44 24 08          	mov    0x8(%esp),%eax
  80397c:	89 f1                	mov    %esi,%ecx
  80397e:	d3 e8                	shr    %cl,%eax
  803980:	09 d0                	or     %edx,%eax
  803982:	d3 eb                	shr    %cl,%ebx
  803984:	89 da                	mov    %ebx,%edx
  803986:	f7 f7                	div    %edi
  803988:	89 d3                	mov    %edx,%ebx
  80398a:	f7 24 24             	mull   (%esp)
  80398d:	89 c6                	mov    %eax,%esi
  80398f:	89 d1                	mov    %edx,%ecx
  803991:	39 d3                	cmp    %edx,%ebx
  803993:	0f 82 87 00 00 00    	jb     803a20 <__umoddi3+0x134>
  803999:	0f 84 91 00 00 00    	je     803a30 <__umoddi3+0x144>
  80399f:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039a3:	29 f2                	sub    %esi,%edx
  8039a5:	19 cb                	sbb    %ecx,%ebx
  8039a7:	89 d8                	mov    %ebx,%eax
  8039a9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039ad:	d3 e0                	shl    %cl,%eax
  8039af:	89 e9                	mov    %ebp,%ecx
  8039b1:	d3 ea                	shr    %cl,%edx
  8039b3:	09 d0                	or     %edx,%eax
  8039b5:	89 e9                	mov    %ebp,%ecx
  8039b7:	d3 eb                	shr    %cl,%ebx
  8039b9:	89 da                	mov    %ebx,%edx
  8039bb:	83 c4 1c             	add    $0x1c,%esp
  8039be:	5b                   	pop    %ebx
  8039bf:	5e                   	pop    %esi
  8039c0:	5f                   	pop    %edi
  8039c1:	5d                   	pop    %ebp
  8039c2:	c3                   	ret    
  8039c3:	90                   	nop
  8039c4:	89 fd                	mov    %edi,%ebp
  8039c6:	85 ff                	test   %edi,%edi
  8039c8:	75 0b                	jne    8039d5 <__umoddi3+0xe9>
  8039ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8039cf:	31 d2                	xor    %edx,%edx
  8039d1:	f7 f7                	div    %edi
  8039d3:	89 c5                	mov    %eax,%ebp
  8039d5:	89 f0                	mov    %esi,%eax
  8039d7:	31 d2                	xor    %edx,%edx
  8039d9:	f7 f5                	div    %ebp
  8039db:	89 c8                	mov    %ecx,%eax
  8039dd:	f7 f5                	div    %ebp
  8039df:	89 d0                	mov    %edx,%eax
  8039e1:	e9 44 ff ff ff       	jmp    80392a <__umoddi3+0x3e>
  8039e6:	66 90                	xchg   %ax,%ax
  8039e8:	89 c8                	mov    %ecx,%eax
  8039ea:	89 f2                	mov    %esi,%edx
  8039ec:	83 c4 1c             	add    $0x1c,%esp
  8039ef:	5b                   	pop    %ebx
  8039f0:	5e                   	pop    %esi
  8039f1:	5f                   	pop    %edi
  8039f2:	5d                   	pop    %ebp
  8039f3:	c3                   	ret    
  8039f4:	3b 04 24             	cmp    (%esp),%eax
  8039f7:	72 06                	jb     8039ff <__umoddi3+0x113>
  8039f9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039fd:	77 0f                	ja     803a0e <__umoddi3+0x122>
  8039ff:	89 f2                	mov    %esi,%edx
  803a01:	29 f9                	sub    %edi,%ecx
  803a03:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a07:	89 14 24             	mov    %edx,(%esp)
  803a0a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a0e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a12:	8b 14 24             	mov    (%esp),%edx
  803a15:	83 c4 1c             	add    $0x1c,%esp
  803a18:	5b                   	pop    %ebx
  803a19:	5e                   	pop    %esi
  803a1a:	5f                   	pop    %edi
  803a1b:	5d                   	pop    %ebp
  803a1c:	c3                   	ret    
  803a1d:	8d 76 00             	lea    0x0(%esi),%esi
  803a20:	2b 04 24             	sub    (%esp),%eax
  803a23:	19 fa                	sbb    %edi,%edx
  803a25:	89 d1                	mov    %edx,%ecx
  803a27:	89 c6                	mov    %eax,%esi
  803a29:	e9 71 ff ff ff       	jmp    80399f <__umoddi3+0xb3>
  803a2e:	66 90                	xchg   %ax,%ax
  803a30:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a34:	72 ea                	jb     803a20 <__umoddi3+0x134>
  803a36:	89 d9                	mov    %ebx,%ecx
  803a38:	e9 62 ff ff ff       	jmp    80399f <__umoddi3+0xb3>
