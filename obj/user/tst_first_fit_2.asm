
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
  800031:	e8 d0 06 00 00       	call   800706 <libmain>
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
  800045:	e8 74 1f 00 00       	call   801fbe <sys_set_uheap_strategy>
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
  80005a:	a1 20 30 80 00       	mov    0x803020,%eax
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
  800083:	a1 20 30 80 00       	mov    0x803020,%eax
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
  80009b:	68 80 22 80 00       	push   $0x802280
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 9c 22 80 00       	push   $0x80229c
  8000a7:	e8 96 07 00 00       	call   800842 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 e4 17 00 00       	call   80189a <malloc>
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
  8000e0:	e8 b5 17 00 00       	call   80189a <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 b4 22 80 00       	push   $0x8022b4
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 9c 22 80 00       	push   $0x80229c
  800101:	e8 3c 07 00 00       	call   800842 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 9e 19 00 00       	call   801aa9 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 36 1a 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 73 17 00 00       	call   80189a <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 f8 22 80 00       	push   $0x8022f8
  80013f:	6a 31                	push   $0x31
  800141:	68 9c 22 80 00       	push   $0x80229c
  800146:	e8 f7 06 00 00       	call   800842 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80014b:	e8 f9 19 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  800150:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800153:	3d 00 02 00 00       	cmp    $0x200,%eax
  800158:	74 14                	je     80016e <_main+0x136>
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	68 28 23 80 00       	push   $0x802328
  800162:	6a 33                	push   $0x33
  800164:	68 9c 22 80 00       	push   $0x80229c
  800169:	e8 d4 06 00 00       	call   800842 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80016e:	e8 36 19 00 00       	call   801aa9 <sys_calculate_free_frames>
  800173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800176:	e8 ce 19 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  80017b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80017e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800181:	01 c0                	add    %eax,%eax
  800183:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	50                   	push   %eax
  80018a:	e8 0b 17 00 00       	call   80189a <malloc>
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
  8001ab:	68 f8 22 80 00       	push   $0x8022f8
  8001b0:	6a 39                	push   $0x39
  8001b2:	68 9c 22 80 00       	push   $0x80229c
  8001b7:	e8 86 06 00 00       	call   800842 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001bc:	e8 88 19 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  8001c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 28 23 80 00       	push   $0x802328
  8001d3:	6a 3b                	push   $0x3b
  8001d5:	68 9c 22 80 00       	push   $0x80229c
  8001da:	e8 63 06 00 00       	call   800842 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 c5 18 00 00       	call   801aa9 <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 5d 19 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  8001ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  8001ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f2:	89 c2                	mov    %eax,%edx
  8001f4:	01 d2                	add    %edx,%edx
  8001f6:	01 d0                	add    %edx,%eax
  8001f8:	83 ec 0c             	sub    $0xc,%esp
  8001fb:	50                   	push   %eax
  8001fc:	e8 99 16 00 00       	call   80189a <malloc>
  800201:	83 c4 10             	add    $0x10,%esp
  800204:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800207:	8b 45 98             	mov    -0x68(%ebp),%eax
  80020a:	89 c2                	mov    %eax,%edx
  80020c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020f:	c1 e0 02             	shl    $0x2,%eax
  800212:	05 00 00 00 80       	add    $0x80000000,%eax
  800217:	39 c2                	cmp    %eax,%edx
  800219:	74 14                	je     80022f <_main+0x1f7>
  80021b:	83 ec 04             	sub    $0x4,%esp
  80021e:	68 f8 22 80 00       	push   $0x8022f8
  800223:	6a 41                	push   $0x41
  800225:	68 9c 22 80 00       	push   $0x80229c
  80022a:	e8 13 06 00 00       	call   800842 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80022f:	e8 15 19 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  800234:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800237:	83 f8 01             	cmp    $0x1,%eax
  80023a:	74 14                	je     800250 <_main+0x218>
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	68 28 23 80 00       	push   $0x802328
  800244:	6a 43                	push   $0x43
  800246:	68 9c 22 80 00       	push   $0x80229c
  80024b:	e8 f2 05 00 00       	call   800842 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  800250:	e8 54 18 00 00       	call   801aa9 <sys_calculate_free_frames>
  800255:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800258:	e8 ec 18 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  80025d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  800260:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800263:	89 c2                	mov    %eax,%edx
  800265:	01 d2                	add    %edx,%edx
  800267:	01 d0                	add    %edx,%eax
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	50                   	push   %eax
  80026d:	e8 28 16 00 00       	call   80189a <malloc>
  800272:	83 c4 10             	add    $0x10,%esp
  800275:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  800278:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80027b:	89 c2                	mov    %eax,%edx
  80027d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800280:	c1 e0 02             	shl    $0x2,%eax
  800283:	89 c1                	mov    %eax,%ecx
  800285:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800288:	c1 e0 02             	shl    $0x2,%eax
  80028b:	01 c8                	add    %ecx,%eax
  80028d:	05 00 00 00 80       	add    $0x80000000,%eax
  800292:	39 c2                	cmp    %eax,%edx
  800294:	74 14                	je     8002aa <_main+0x272>
  800296:	83 ec 04             	sub    $0x4,%esp
  800299:	68 f8 22 80 00       	push   $0x8022f8
  80029e:	6a 49                	push   $0x49
  8002a0:	68 9c 22 80 00       	push   $0x80229c
  8002a5:	e8 98 05 00 00       	call   800842 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002aa:	e8 9a 18 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  8002af:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002b2:	83 f8 01             	cmp    $0x1,%eax
  8002b5:	74 14                	je     8002cb <_main+0x293>
  8002b7:	83 ec 04             	sub    $0x4,%esp
  8002ba:	68 28 23 80 00       	push   $0x802328
  8002bf:	6a 4b                	push   $0x4b
  8002c1:	68 9c 22 80 00       	push   $0x80229c
  8002c6:	e8 77 05 00 00       	call   800842 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 d9 17 00 00       	call   801aa9 <sys_calculate_free_frames>
  8002d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002d3:	e8 71 18 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  8002d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002db:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	50                   	push   %eax
  8002e2:	e8 f4 15 00 00       	call   8018db <free>
  8002e7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002ea:	e8 5a 18 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  8002ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002f2:	29 c2                	sub    %eax,%edx
  8002f4:	89 d0                	mov    %edx,%eax
  8002f6:	83 f8 01             	cmp    $0x1,%eax
  8002f9:	74 14                	je     80030f <_main+0x2d7>
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	68 45 23 80 00       	push   $0x802345
  800303:	6a 52                	push   $0x52
  800305:	68 9c 22 80 00       	push   $0x80229c
  80030a:	e8 33 05 00 00       	call   800842 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  80030f:	e8 95 17 00 00       	call   801aa9 <sys_calculate_free_frames>
  800314:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800317:	e8 2d 18 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  80031c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80031f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800322:	89 d0                	mov    %edx,%eax
  800324:	01 c0                	add    %eax,%eax
  800326:	01 d0                	add    %edx,%eax
  800328:	01 c0                	add    %eax,%eax
  80032a:	01 d0                	add    %edx,%eax
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	50                   	push   %eax
  800330:	e8 65 15 00 00       	call   80189a <malloc>
  800335:	83 c4 10             	add    $0x10,%esp
  800338:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  80033b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80033e:	89 c2                	mov    %eax,%edx
  800340:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800343:	c1 e0 02             	shl    $0x2,%eax
  800346:	89 c1                	mov    %eax,%ecx
  800348:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80034b:	c1 e0 03             	shl    $0x3,%eax
  80034e:	01 c8                	add    %ecx,%eax
  800350:	05 00 00 00 80       	add    $0x80000000,%eax
  800355:	39 c2                	cmp    %eax,%edx
  800357:	74 14                	je     80036d <_main+0x335>
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	68 f8 22 80 00       	push   $0x8022f8
  800361:	6a 58                	push   $0x58
  800363:	68 9c 22 80 00       	push   $0x80229c
  800368:	e8 d5 04 00 00       	call   800842 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  80036d:	e8 d7 17 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  800372:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800375:	83 f8 02             	cmp    $0x2,%eax
  800378:	74 14                	je     80038e <_main+0x356>
  80037a:	83 ec 04             	sub    $0x4,%esp
  80037d:	68 28 23 80 00       	push   $0x802328
  800382:	6a 5a                	push   $0x5a
  800384:	68 9c 22 80 00       	push   $0x80229c
  800389:	e8 b4 04 00 00       	call   800842 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80038e:	e8 16 17 00 00       	call   801aa9 <sys_calculate_free_frames>
  800393:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800396:	e8 ae 17 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  80039b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  80039e:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003a1:	83 ec 0c             	sub    $0xc,%esp
  8003a4:	50                   	push   %eax
  8003a5:	e8 31 15 00 00       	call   8018db <free>
  8003aa:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003ad:	e8 97 17 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  8003b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003b5:	29 c2                	sub    %eax,%edx
  8003b7:	89 d0                	mov    %edx,%eax
  8003b9:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003be:	74 14                	je     8003d4 <_main+0x39c>
  8003c0:	83 ec 04             	sub    $0x4,%esp
  8003c3:	68 45 23 80 00       	push   $0x802345
  8003c8:	6a 61                	push   $0x61
  8003ca:	68 9c 22 80 00       	push   $0x80229c
  8003cf:	e8 6e 04 00 00       	call   800842 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003d4:	e8 d0 16 00 00       	call   801aa9 <sys_calculate_free_frames>
  8003d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003dc:	e8 68 17 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  8003e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e7:	89 c2                	mov    %eax,%edx
  8003e9:	01 d2                	add    %edx,%edx
  8003eb:	01 d0                	add    %edx,%eax
  8003ed:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003f0:	83 ec 0c             	sub    $0xc,%esp
  8003f3:	50                   	push   %eax
  8003f4:	e8 a1 14 00 00       	call   80189a <malloc>
  8003f9:	83 c4 10             	add    $0x10,%esp
  8003fc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003ff:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800402:	89 c2                	mov    %eax,%edx
  800404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800407:	c1 e0 02             	shl    $0x2,%eax
  80040a:	89 c1                	mov    %eax,%ecx
  80040c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80040f:	c1 e0 04             	shl    $0x4,%eax
  800412:	01 c8                	add    %ecx,%eax
  800414:	05 00 00 00 80       	add    $0x80000000,%eax
  800419:	39 c2                	cmp    %eax,%edx
  80041b:	74 14                	je     800431 <_main+0x3f9>
  80041d:	83 ec 04             	sub    $0x4,%esp
  800420:	68 f8 22 80 00       	push   $0x8022f8
  800425:	6a 67                	push   $0x67
  800427:	68 9c 22 80 00       	push   $0x80229c
  80042c:	e8 11 04 00 00       	call   800842 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800431:	e8 13 17 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  800436:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800439:	89 c2                	mov    %eax,%edx
  80043b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80043e:	89 c1                	mov    %eax,%ecx
  800440:	01 c9                	add    %ecx,%ecx
  800442:	01 c8                	add    %ecx,%eax
  800444:	85 c0                	test   %eax,%eax
  800446:	79 05                	jns    80044d <_main+0x415>
  800448:	05 ff 0f 00 00       	add    $0xfff,%eax
  80044d:	c1 f8 0c             	sar    $0xc,%eax
  800450:	39 c2                	cmp    %eax,%edx
  800452:	74 14                	je     800468 <_main+0x430>
  800454:	83 ec 04             	sub    $0x4,%esp
  800457:	68 28 23 80 00       	push   $0x802328
  80045c:	6a 69                	push   $0x69
  80045e:	68 9c 22 80 00       	push   $0x80229c
  800463:	e8 da 03 00 00       	call   800842 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800468:	e8 3c 16 00 00       	call   801aa9 <sys_calculate_free_frames>
  80046d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800470:	e8 d4 16 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  800475:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  800478:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80047b:	89 c2                	mov    %eax,%edx
  80047d:	01 d2                	add    %edx,%edx
  80047f:	01 c2                	add    %eax,%edx
  800481:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800484:	01 d0                	add    %edx,%eax
  800486:	01 c0                	add    %eax,%eax
  800488:	83 ec 0c             	sub    $0xc,%esp
  80048b:	50                   	push   %eax
  80048c:	e8 09 14 00 00       	call   80189a <malloc>
  800491:	83 c4 10             	add    $0x10,%esp
  800494:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800497:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80049a:	89 c1                	mov    %eax,%ecx
  80049c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80049f:	89 d0                	mov    %edx,%eax
  8004a1:	01 c0                	add    %eax,%eax
  8004a3:	01 d0                	add    %edx,%eax
  8004a5:	01 c0                	add    %eax,%eax
  8004a7:	01 d0                	add    %edx,%eax
  8004a9:	89 c2                	mov    %eax,%edx
  8004ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004ae:	c1 e0 04             	shl    $0x4,%eax
  8004b1:	01 d0                	add    %edx,%eax
  8004b3:	05 00 00 00 80       	add    $0x80000000,%eax
  8004b8:	39 c1                	cmp    %eax,%ecx
  8004ba:	74 14                	je     8004d0 <_main+0x498>
  8004bc:	83 ec 04             	sub    $0x4,%esp
  8004bf:	68 f8 22 80 00       	push   $0x8022f8
  8004c4:	6a 6f                	push   $0x6f
  8004c6:	68 9c 22 80 00       	push   $0x80229c
  8004cb:	e8 72 03 00 00       	call   800842 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004d0:	e8 74 16 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  8004d5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004d8:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004dd:	74 14                	je     8004f3 <_main+0x4bb>
  8004df:	83 ec 04             	sub    $0x4,%esp
  8004e2:	68 28 23 80 00       	push   $0x802328
  8004e7:	6a 71                	push   $0x71
  8004e9:	68 9c 22 80 00       	push   $0x80229c
  8004ee:	e8 4f 03 00 00       	call   800842 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004f3:	e8 b1 15 00 00       	call   801aa9 <sys_calculate_free_frames>
  8004f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004fb:	e8 49 16 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  800500:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  800503:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800506:	83 ec 0c             	sub    $0xc,%esp
  800509:	50                   	push   %eax
  80050a:	e8 cc 13 00 00       	call   8018db <free>
  80050f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  800512:	e8 32 16 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  800517:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80051a:	29 c2                	sub    %eax,%edx
  80051c:	89 d0                	mov    %edx,%eax
  80051e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800523:	74 14                	je     800539 <_main+0x501>
  800525:	83 ec 04             	sub    $0x4,%esp
  800528:	68 45 23 80 00       	push   $0x802345
  80052d:	6a 78                	push   $0x78
  80052f:	68 9c 22 80 00       	push   $0x80229c
  800534:	e8 09 03 00 00       	call   800842 <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  800539:	e8 6b 15 00 00       	call   801aa9 <sys_calculate_free_frames>
  80053e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800541:	e8 03 16 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  800546:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800549:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80054c:	83 ec 0c             	sub    $0xc,%esp
  80054f:	50                   	push   %eax
  800550:	e8 86 13 00 00       	call   8018db <free>
  800555:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  800558:	e8 ec 15 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  80055d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800560:	29 c2                	sub    %eax,%edx
  800562:	89 d0                	mov    %edx,%eax
  800564:	3d 00 02 00 00       	cmp    $0x200,%eax
  800569:	74 14                	je     80057f <_main+0x547>
  80056b:	83 ec 04             	sub    $0x4,%esp
  80056e:	68 45 23 80 00       	push   $0x802345
  800573:	6a 7f                	push   $0x7f
  800575:	68 9c 22 80 00       	push   $0x80229c
  80057a:	e8 c3 02 00 00       	call   800842 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80057f:	e8 25 15 00 00       	call   801aa9 <sys_calculate_free_frames>
  800584:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800587:	e8 bd 15 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  80058c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  80058f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800592:	89 d0                	mov    %edx,%eax
  800594:	c1 e0 02             	shl    $0x2,%eax
  800597:	01 d0                	add    %edx,%eax
  800599:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80059c:	83 ec 0c             	sub    $0xc,%esp
  80059f:	50                   	push   %eax
  8005a0:	e8 f5 12 00 00       	call   80189a <malloc>
  8005a5:	83 c4 10             	add    $0x10,%esp
  8005a8:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  8005ab:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005ae:	89 c1                	mov    %eax,%ecx
  8005b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005b3:	89 d0                	mov    %edx,%eax
  8005b5:	c1 e0 03             	shl    $0x3,%eax
  8005b8:	01 d0                	add    %edx,%eax
  8005ba:	89 c3                	mov    %eax,%ebx
  8005bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005bf:	89 d0                	mov    %edx,%eax
  8005c1:	01 c0                	add    %eax,%eax
  8005c3:	01 d0                	add    %edx,%eax
  8005c5:	c1 e0 03             	shl    $0x3,%eax
  8005c8:	01 d8                	add    %ebx,%eax
  8005ca:	05 00 00 00 80       	add    $0x80000000,%eax
  8005cf:	39 c1                	cmp    %eax,%ecx
  8005d1:	74 17                	je     8005ea <_main+0x5b2>
  8005d3:	83 ec 04             	sub    $0x4,%esp
  8005d6:	68 f8 22 80 00       	push   $0x8022f8
  8005db:	68 85 00 00 00       	push   $0x85
  8005e0:	68 9c 22 80 00       	push   $0x80229c
  8005e5:	e8 58 02 00 00       	call   800842 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  8005ea:	e8 5a 15 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  8005ef:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8005f2:	89 c1                	mov    %eax,%ecx
  8005f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005f7:	89 d0                	mov    %edx,%eax
  8005f9:	c1 e0 02             	shl    $0x2,%eax
  8005fc:	01 d0                	add    %edx,%eax
  8005fe:	85 c0                	test   %eax,%eax
  800600:	79 05                	jns    800607 <_main+0x5cf>
  800602:	05 ff 0f 00 00       	add    $0xfff,%eax
  800607:	c1 f8 0c             	sar    $0xc,%eax
  80060a:	39 c1                	cmp    %eax,%ecx
  80060c:	74 17                	je     800625 <_main+0x5ed>
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	68 28 23 80 00       	push   $0x802328
  800616:	68 87 00 00 00       	push   $0x87
  80061b:	68 9c 22 80 00       	push   $0x80229c
  800620:	e8 1d 02 00 00       	call   800842 <_panic>
		//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800625:	e8 7f 14 00 00       	call   801aa9 <sys_calculate_free_frames>
  80062a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80062d:	e8 17 15 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  800632:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(3*Mega-kilo);
  800635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800638:	89 c2                	mov    %eax,%edx
  80063a:	01 d2                	add    %edx,%edx
  80063c:	01 d0                	add    %edx,%eax
  80063e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800641:	83 ec 0c             	sub    $0xc,%esp
  800644:	50                   	push   %eax
  800645:	e8 50 12 00 00       	call   80189a <malloc>
  80064a:	83 c4 10             	add    $0x10,%esp
  80064d:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800650:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800653:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800658:	74 17                	je     800671 <_main+0x639>
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	68 f8 22 80 00       	push   $0x8022f8
  800662:	68 95 00 00 00       	push   $0x95
  800667:	68 9c 22 80 00       	push   $0x80229c
  80066c:	e8 d1 01 00 00       	call   800842 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800671:	e8 d3 14 00 00       	call   801b49 <sys_pf_calculate_allocated_pages>
  800676:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800679:	89 c2                	mov    %eax,%edx
  80067b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80067e:	89 c1                	mov    %eax,%ecx
  800680:	01 c9                	add    %ecx,%ecx
  800682:	01 c8                	add    %ecx,%eax
  800684:	85 c0                	test   %eax,%eax
  800686:	79 05                	jns    80068d <_main+0x655>
  800688:	05 ff 0f 00 00       	add    $0xfff,%eax
  80068d:	c1 f8 0c             	sar    $0xc,%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	74 17                	je     8006ab <_main+0x673>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 28 23 80 00       	push   $0x802328
  80069c:	68 97 00 00 00       	push   $0x97
  8006a1:	68 9c 22 80 00       	push   $0x80229c
  8006a6:	e8 97 01 00 00       	call   800842 <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  8006ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006ae:	89 d0                	mov    %edx,%eax
  8006b0:	01 c0                	add    %eax,%eax
  8006b2:	01 d0                	add    %edx,%eax
  8006b4:	01 c0                	add    %eax,%eax
  8006b6:	01 d0                	add    %edx,%eax
  8006b8:	01 c0                	add    %eax,%eax
  8006ba:	f7 d8                	neg    %eax
  8006bc:	05 00 00 00 20       	add    $0x20000000,%eax
  8006c1:	83 ec 0c             	sub    $0xc,%esp
  8006c4:	50                   	push   %eax
  8006c5:	e8 d0 11 00 00       	call   80189a <malloc>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  8006d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006d3:	85 c0                	test   %eax,%eax
  8006d5:	74 17                	je     8006ee <_main+0x6b6>
  8006d7:	83 ec 04             	sub    $0x4,%esp
  8006da:	68 5c 23 80 00       	push   $0x80235c
  8006df:	68 a0 00 00 00       	push   $0xa0
  8006e4:	68 9c 22 80 00       	push   $0x80229c
  8006e9:	e8 54 01 00 00       	call   800842 <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  8006ee:	83 ec 0c             	sub    $0xc,%esp
  8006f1:	68 c0 23 80 00       	push   $0x8023c0
  8006f6:	e8 fb 03 00 00       	call   800af6 <cprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp

		return;
  8006fe:	90                   	nop
	}
}
  8006ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800702:	5b                   	pop    %ebx
  800703:	5f                   	pop    %edi
  800704:	5d                   	pop    %ebp
  800705:	c3                   	ret    

00800706 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80070c:	e8 78 16 00 00       	call   801d89 <sys_getenvindex>
  800711:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800717:	89 d0                	mov    %edx,%eax
  800719:	c1 e0 03             	shl    $0x3,%eax
  80071c:	01 d0                	add    %edx,%eax
  80071e:	01 c0                	add    %eax,%eax
  800720:	01 d0                	add    %edx,%eax
  800722:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800729:	01 d0                	add    %edx,%eax
  80072b:	c1 e0 04             	shl    $0x4,%eax
  80072e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800733:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800738:	a1 20 30 80 00       	mov    0x803020,%eax
  80073d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800743:	84 c0                	test   %al,%al
  800745:	74 0f                	je     800756 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800747:	a1 20 30 80 00       	mov    0x803020,%eax
  80074c:	05 5c 05 00 00       	add    $0x55c,%eax
  800751:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800756:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80075a:	7e 0a                	jle    800766 <libmain+0x60>
		binaryname = argv[0];
  80075c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	ff 75 0c             	pushl  0xc(%ebp)
  80076c:	ff 75 08             	pushl  0x8(%ebp)
  80076f:	e8 c4 f8 ff ff       	call   800038 <_main>
  800774:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800777:	e8 1a 14 00 00       	call   801b96 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80077c:	83 ec 0c             	sub    $0xc,%esp
  80077f:	68 24 24 80 00       	push   $0x802424
  800784:	e8 6d 03 00 00       	call   800af6 <cprintf>
  800789:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80078c:	a1 20 30 80 00       	mov    0x803020,%eax
  800791:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800797:	a1 20 30 80 00       	mov    0x803020,%eax
  80079c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8007a2:	83 ec 04             	sub    $0x4,%esp
  8007a5:	52                   	push   %edx
  8007a6:	50                   	push   %eax
  8007a7:	68 4c 24 80 00       	push   $0x80244c
  8007ac:	e8 45 03 00 00       	call   800af6 <cprintf>
  8007b1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8007b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8007b9:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8007bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8007c4:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8007ca:	a1 20 30 80 00       	mov    0x803020,%eax
  8007cf:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8007d5:	51                   	push   %ecx
  8007d6:	52                   	push   %edx
  8007d7:	50                   	push   %eax
  8007d8:	68 74 24 80 00       	push   $0x802474
  8007dd:	e8 14 03 00 00       	call   800af6 <cprintf>
  8007e2:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8007ea:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	50                   	push   %eax
  8007f4:	68 cc 24 80 00       	push   $0x8024cc
  8007f9:	e8 f8 02 00 00       	call   800af6 <cprintf>
  8007fe:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800801:	83 ec 0c             	sub    $0xc,%esp
  800804:	68 24 24 80 00       	push   $0x802424
  800809:	e8 e8 02 00 00       	call   800af6 <cprintf>
  80080e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800811:	e8 9a 13 00 00       	call   801bb0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800816:	e8 19 00 00 00       	call   800834 <exit>
}
  80081b:	90                   	nop
  80081c:	c9                   	leave  
  80081d:	c3                   	ret    

0080081e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800824:	83 ec 0c             	sub    $0xc,%esp
  800827:	6a 00                	push   $0x0
  800829:	e8 27 15 00 00       	call   801d55 <sys_destroy_env>
  80082e:	83 c4 10             	add    $0x10,%esp
}
  800831:	90                   	nop
  800832:	c9                   	leave  
  800833:	c3                   	ret    

00800834 <exit>:

void
exit(void)
{
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80083a:	e8 7c 15 00 00       	call   801dbb <sys_exit_env>
}
  80083f:	90                   	nop
  800840:	c9                   	leave  
  800841:	c3                   	ret    

00800842 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
  800845:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800848:	8d 45 10             	lea    0x10(%ebp),%eax
  80084b:	83 c0 04             	add    $0x4,%eax
  80084e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800851:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800856:	85 c0                	test   %eax,%eax
  800858:	74 16                	je     800870 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80085a:	a1 5c 31 80 00       	mov    0x80315c,%eax
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	50                   	push   %eax
  800863:	68 e0 24 80 00       	push   $0x8024e0
  800868:	e8 89 02 00 00       	call   800af6 <cprintf>
  80086d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800870:	a1 00 30 80 00       	mov    0x803000,%eax
  800875:	ff 75 0c             	pushl  0xc(%ebp)
  800878:	ff 75 08             	pushl  0x8(%ebp)
  80087b:	50                   	push   %eax
  80087c:	68 e5 24 80 00       	push   $0x8024e5
  800881:	e8 70 02 00 00       	call   800af6 <cprintf>
  800886:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800889:	8b 45 10             	mov    0x10(%ebp),%eax
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	ff 75 f4             	pushl  -0xc(%ebp)
  800892:	50                   	push   %eax
  800893:	e8 f3 01 00 00       	call   800a8b <vcprintf>
  800898:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	6a 00                	push   $0x0
  8008a0:	68 01 25 80 00       	push   $0x802501
  8008a5:	e8 e1 01 00 00       	call   800a8b <vcprintf>
  8008aa:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008ad:	e8 82 ff ff ff       	call   800834 <exit>

	// should not return here
	while (1) ;
  8008b2:	eb fe                	jmp    8008b2 <_panic+0x70>

008008b4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8008bf:	8b 50 74             	mov    0x74(%eax),%edx
  8008c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	74 14                	je     8008dd <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008c9:	83 ec 04             	sub    $0x4,%esp
  8008cc:	68 04 25 80 00       	push   $0x802504
  8008d1:	6a 26                	push   $0x26
  8008d3:	68 50 25 80 00       	push   $0x802550
  8008d8:	e8 65 ff ff ff       	call   800842 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008eb:	e9 c2 00 00 00       	jmp    8009b2 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8008f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	85 c0                	test   %eax,%eax
  800903:	75 08                	jne    80090d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800905:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800908:	e9 a2 00 00 00       	jmp    8009af <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80090d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800914:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80091b:	eb 69                	jmp    800986 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80091d:	a1 20 30 80 00       	mov    0x803020,%eax
  800922:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800928:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80092b:	89 d0                	mov    %edx,%eax
  80092d:	01 c0                	add    %eax,%eax
  80092f:	01 d0                	add    %edx,%eax
  800931:	c1 e0 03             	shl    $0x3,%eax
  800934:	01 c8                	add    %ecx,%eax
  800936:	8a 40 04             	mov    0x4(%eax),%al
  800939:	84 c0                	test   %al,%al
  80093b:	75 46                	jne    800983 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80093d:	a1 20 30 80 00       	mov    0x803020,%eax
  800942:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800948:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80094b:	89 d0                	mov    %edx,%eax
  80094d:	01 c0                	add    %eax,%eax
  80094f:	01 d0                	add    %edx,%eax
  800951:	c1 e0 03             	shl    $0x3,%eax
  800954:	01 c8                	add    %ecx,%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80095b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80095e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800963:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800968:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	01 c8                	add    %ecx,%eax
  800974:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800976:	39 c2                	cmp    %eax,%edx
  800978:	75 09                	jne    800983 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80097a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800981:	eb 12                	jmp    800995 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800983:	ff 45 e8             	incl   -0x18(%ebp)
  800986:	a1 20 30 80 00       	mov    0x803020,%eax
  80098b:	8b 50 74             	mov    0x74(%eax),%edx
  80098e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800991:	39 c2                	cmp    %eax,%edx
  800993:	77 88                	ja     80091d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800995:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800999:	75 14                	jne    8009af <CheckWSWithoutLastIndex+0xfb>
			panic(
  80099b:	83 ec 04             	sub    $0x4,%esp
  80099e:	68 5c 25 80 00       	push   $0x80255c
  8009a3:	6a 3a                	push   $0x3a
  8009a5:	68 50 25 80 00       	push   $0x802550
  8009aa:	e8 93 fe ff ff       	call   800842 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8009af:	ff 45 f0             	incl   -0x10(%ebp)
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009b8:	0f 8c 32 ff ff ff    	jl     8008f0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009cc:	eb 26                	jmp    8009f4 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8009d3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	01 c0                	add    %eax,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	c1 e0 03             	shl    $0x3,%eax
  8009e5:	01 c8                	add    %ecx,%eax
  8009e7:	8a 40 04             	mov    0x4(%eax),%al
  8009ea:	3c 01                	cmp    $0x1,%al
  8009ec:	75 03                	jne    8009f1 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8009ee:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009f1:	ff 45 e0             	incl   -0x20(%ebp)
  8009f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8009f9:	8b 50 74             	mov    0x74(%eax),%edx
  8009fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ff:	39 c2                	cmp    %eax,%edx
  800a01:	77 cb                	ja     8009ce <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a06:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a09:	74 14                	je     800a1f <CheckWSWithoutLastIndex+0x16b>
		panic(
  800a0b:	83 ec 04             	sub    $0x4,%esp
  800a0e:	68 b0 25 80 00       	push   $0x8025b0
  800a13:	6a 44                	push   $0x44
  800a15:	68 50 25 80 00       	push   $0x802550
  800a1a:	e8 23 fe ff ff       	call   800842 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a1f:	90                   	nop
  800a20:	c9                   	leave  
  800a21:	c3                   	ret    

00800a22 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2b:	8b 00                	mov    (%eax),%eax
  800a2d:	8d 48 01             	lea    0x1(%eax),%ecx
  800a30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a33:	89 0a                	mov    %ecx,(%edx)
  800a35:	8b 55 08             	mov    0x8(%ebp),%edx
  800a38:	88 d1                	mov    %dl,%cl
  800a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a4b:	75 2c                	jne    800a79 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a4d:	a0 24 30 80 00       	mov    0x803024,%al
  800a52:	0f b6 c0             	movzbl %al,%eax
  800a55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a58:	8b 12                	mov    (%edx),%edx
  800a5a:	89 d1                	mov    %edx,%ecx
  800a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5f:	83 c2 08             	add    $0x8,%edx
  800a62:	83 ec 04             	sub    $0x4,%esp
  800a65:	50                   	push   %eax
  800a66:	51                   	push   %ecx
  800a67:	52                   	push   %edx
  800a68:	e8 7b 0f 00 00       	call   8019e8 <sys_cputs>
  800a6d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	8b 40 04             	mov    0x4(%eax),%eax
  800a7f:	8d 50 01             	lea    0x1(%eax),%edx
  800a82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a85:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a88:	90                   	nop
  800a89:	c9                   	leave  
  800a8a:	c3                   	ret    

00800a8b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a94:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a9b:	00 00 00 
	b.cnt = 0;
  800a9e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800aa5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800aa8:	ff 75 0c             	pushl  0xc(%ebp)
  800aab:	ff 75 08             	pushl  0x8(%ebp)
  800aae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ab4:	50                   	push   %eax
  800ab5:	68 22 0a 80 00       	push   $0x800a22
  800aba:	e8 11 02 00 00       	call   800cd0 <vprintfmt>
  800abf:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ac2:	a0 24 30 80 00       	mov    0x803024,%al
  800ac7:	0f b6 c0             	movzbl %al,%eax
  800aca:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ad0:	83 ec 04             	sub    $0x4,%esp
  800ad3:	50                   	push   %eax
  800ad4:	52                   	push   %edx
  800ad5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800adb:	83 c0 08             	add    $0x8,%eax
  800ade:	50                   	push   %eax
  800adf:	e8 04 0f 00 00       	call   8019e8 <sys_cputs>
  800ae4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ae7:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800aee:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800af4:	c9                   	leave  
  800af5:	c3                   	ret    

00800af6 <cprintf>:

int cprintf(const char *fmt, ...) {
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800afc:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800b03:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b12:	50                   	push   %eax
  800b13:	e8 73 ff ff ff       	call   800a8b <vcprintf>
  800b18:	83 c4 10             	add    $0x10,%esp
  800b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b21:	c9                   	leave  
  800b22:	c3                   	ret    

00800b23 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b29:	e8 68 10 00 00       	call   801b96 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b2e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3d:	50                   	push   %eax
  800b3e:	e8 48 ff ff ff       	call   800a8b <vcprintf>
  800b43:	83 c4 10             	add    $0x10,%esp
  800b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800b49:	e8 62 10 00 00       	call   801bb0 <sys_enable_interrupt>
	return cnt;
  800b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	53                   	push   %ebx
  800b57:	83 ec 14             	sub    $0x14,%esp
  800b5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b60:	8b 45 14             	mov    0x14(%ebp),%eax
  800b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b66:	8b 45 18             	mov    0x18(%ebp),%eax
  800b69:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b71:	77 55                	ja     800bc8 <printnum+0x75>
  800b73:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b76:	72 05                	jb     800b7d <printnum+0x2a>
  800b78:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b7b:	77 4b                	ja     800bc8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b7d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b80:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b83:	8b 45 18             	mov    0x18(%ebp),%eax
  800b86:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8b:	52                   	push   %edx
  800b8c:	50                   	push   %eax
  800b8d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b90:	ff 75 f0             	pushl  -0x10(%ebp)
  800b93:	e8 84 14 00 00       	call   80201c <__udivdi3>
  800b98:	83 c4 10             	add    $0x10,%esp
  800b9b:	83 ec 04             	sub    $0x4,%esp
  800b9e:	ff 75 20             	pushl  0x20(%ebp)
  800ba1:	53                   	push   %ebx
  800ba2:	ff 75 18             	pushl  0x18(%ebp)
  800ba5:	52                   	push   %edx
  800ba6:	50                   	push   %eax
  800ba7:	ff 75 0c             	pushl  0xc(%ebp)
  800baa:	ff 75 08             	pushl  0x8(%ebp)
  800bad:	e8 a1 ff ff ff       	call   800b53 <printnum>
  800bb2:	83 c4 20             	add    $0x20,%esp
  800bb5:	eb 1a                	jmp    800bd1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	ff 75 20             	pushl  0x20(%ebp)
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bc8:	ff 4d 1c             	decl   0x1c(%ebp)
  800bcb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bcf:	7f e6                	jg     800bb7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bd1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bd4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bdf:	53                   	push   %ebx
  800be0:	51                   	push   %ecx
  800be1:	52                   	push   %edx
  800be2:	50                   	push   %eax
  800be3:	e8 44 15 00 00       	call   80212c <__umoddi3>
  800be8:	83 c4 10             	add    $0x10,%esp
  800beb:	05 14 28 80 00       	add    $0x802814,%eax
  800bf0:	8a 00                	mov    (%eax),%al
  800bf2:	0f be c0             	movsbl %al,%eax
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	50                   	push   %eax
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	ff d0                	call   *%eax
  800c01:	83 c4 10             	add    $0x10,%esp
}
  800c04:	90                   	nop
  800c05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c08:	c9                   	leave  
  800c09:	c3                   	ret    

00800c0a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c0d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c11:	7e 1c                	jle    800c2f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8b 00                	mov    (%eax),%eax
  800c18:	8d 50 08             	lea    0x8(%eax),%edx
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	89 10                	mov    %edx,(%eax)
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	8b 00                	mov    (%eax),%eax
  800c25:	83 e8 08             	sub    $0x8,%eax
  800c28:	8b 50 04             	mov    0x4(%eax),%edx
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	eb 40                	jmp    800c6f <getuint+0x65>
	else if (lflag)
  800c2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c33:	74 1e                	je     800c53 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	8b 00                	mov    (%eax),%eax
  800c3a:	8d 50 04             	lea    0x4(%eax),%edx
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	89 10                	mov    %edx,(%eax)
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	83 e8 04             	sub    $0x4,%eax
  800c4a:	8b 00                	mov    (%eax),%eax
  800c4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c51:	eb 1c                	jmp    800c6f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	8b 00                	mov    (%eax),%eax
  800c58:	8d 50 04             	lea    0x4(%eax),%edx
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	89 10                	mov    %edx,(%eax)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8b 00                	mov    (%eax),%eax
  800c65:	83 e8 04             	sub    $0x4,%eax
  800c68:	8b 00                	mov    (%eax),%eax
  800c6a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    

00800c71 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c74:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c78:	7e 1c                	jle    800c96 <getint+0x25>
		return va_arg(*ap, long long);
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8b 00                	mov    (%eax),%eax
  800c7f:	8d 50 08             	lea    0x8(%eax),%edx
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	89 10                	mov    %edx,(%eax)
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8b 00                	mov    (%eax),%eax
  800c8c:	83 e8 08             	sub    $0x8,%eax
  800c8f:	8b 50 04             	mov    0x4(%eax),%edx
  800c92:	8b 00                	mov    (%eax),%eax
  800c94:	eb 38                	jmp    800cce <getint+0x5d>
	else if (lflag)
  800c96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9a:	74 1a                	je     800cb6 <getint+0x45>
		return va_arg(*ap, long);
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	8b 00                	mov    (%eax),%eax
  800ca1:	8d 50 04             	lea    0x4(%eax),%edx
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	89 10                	mov    %edx,(%eax)
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 00                	mov    (%eax),%eax
  800cae:	83 e8 04             	sub    $0x4,%eax
  800cb1:	8b 00                	mov    (%eax),%eax
  800cb3:	99                   	cltd   
  800cb4:	eb 18                	jmp    800cce <getint+0x5d>
	else
		return va_arg(*ap, int);
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8b 00                	mov    (%eax),%eax
  800cbb:	8d 50 04             	lea    0x4(%eax),%edx
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	89 10                	mov    %edx,(%eax)
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8b 00                	mov    (%eax),%eax
  800cc8:	83 e8 04             	sub    $0x4,%eax
  800ccb:	8b 00                	mov    (%eax),%eax
  800ccd:	99                   	cltd   
}
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	56                   	push   %esi
  800cd4:	53                   	push   %ebx
  800cd5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cd8:	eb 17                	jmp    800cf1 <vprintfmt+0x21>
			if (ch == '\0')
  800cda:	85 db                	test   %ebx,%ebx
  800cdc:	0f 84 af 03 00 00    	je     801091 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	ff 75 0c             	pushl  0xc(%ebp)
  800ce8:	53                   	push   %ebx
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	ff d0                	call   *%eax
  800cee:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	8d 50 01             	lea    0x1(%eax),%edx
  800cf7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	0f b6 d8             	movzbl %al,%ebx
  800cff:	83 fb 25             	cmp    $0x25,%ebx
  800d02:	75 d6                	jne    800cda <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d04:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d08:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d0f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d16:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d1d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d24:	8b 45 10             	mov    0x10(%ebp),%eax
  800d27:	8d 50 01             	lea    0x1(%eax),%edx
  800d2a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2d:	8a 00                	mov    (%eax),%al
  800d2f:	0f b6 d8             	movzbl %al,%ebx
  800d32:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d35:	83 f8 55             	cmp    $0x55,%eax
  800d38:	0f 87 2b 03 00 00    	ja     801069 <vprintfmt+0x399>
  800d3e:	8b 04 85 38 28 80 00 	mov    0x802838(,%eax,4),%eax
  800d45:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d47:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d4b:	eb d7                	jmp    800d24 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d4d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d51:	eb d1                	jmp    800d24 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d53:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d5d:	89 d0                	mov    %edx,%eax
  800d5f:	c1 e0 02             	shl    $0x2,%eax
  800d62:	01 d0                	add    %edx,%eax
  800d64:	01 c0                	add    %eax,%eax
  800d66:	01 d8                	add    %ebx,%eax
  800d68:	83 e8 30             	sub    $0x30,%eax
  800d6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d76:	83 fb 2f             	cmp    $0x2f,%ebx
  800d79:	7e 3e                	jle    800db9 <vprintfmt+0xe9>
  800d7b:	83 fb 39             	cmp    $0x39,%ebx
  800d7e:	7f 39                	jg     800db9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d80:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d83:	eb d5                	jmp    800d5a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d85:	8b 45 14             	mov    0x14(%ebp),%eax
  800d88:	83 c0 04             	add    $0x4,%eax
  800d8b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d91:	83 e8 04             	sub    $0x4,%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d99:	eb 1f                	jmp    800dba <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d9b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d9f:	79 83                	jns    800d24 <vprintfmt+0x54>
				width = 0;
  800da1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800da8:	e9 77 ff ff ff       	jmp    800d24 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800dad:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800db4:	e9 6b ff ff ff       	jmp    800d24 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800db9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800dba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbe:	0f 89 60 ff ff ff    	jns    800d24 <vprintfmt+0x54>
				width = precision, precision = -1;
  800dc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dca:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800dd1:	e9 4e ff ff ff       	jmp    800d24 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dd6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800dd9:	e9 46 ff ff ff       	jmp    800d24 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800dde:	8b 45 14             	mov    0x14(%ebp),%eax
  800de1:	83 c0 04             	add    $0x4,%eax
  800de4:	89 45 14             	mov    %eax,0x14(%ebp)
  800de7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dea:	83 e8 04             	sub    $0x4,%eax
  800ded:	8b 00                	mov    (%eax),%eax
  800def:	83 ec 08             	sub    $0x8,%esp
  800df2:	ff 75 0c             	pushl  0xc(%ebp)
  800df5:	50                   	push   %eax
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	ff d0                	call   *%eax
  800dfb:	83 c4 10             	add    $0x10,%esp
			break;
  800dfe:	e9 89 02 00 00       	jmp    80108c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e03:	8b 45 14             	mov    0x14(%ebp),%eax
  800e06:	83 c0 04             	add    $0x4,%eax
  800e09:	89 45 14             	mov    %eax,0x14(%ebp)
  800e0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0f:	83 e8 04             	sub    $0x4,%eax
  800e12:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e14:	85 db                	test   %ebx,%ebx
  800e16:	79 02                	jns    800e1a <vprintfmt+0x14a>
				err = -err;
  800e18:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e1a:	83 fb 64             	cmp    $0x64,%ebx
  800e1d:	7f 0b                	jg     800e2a <vprintfmt+0x15a>
  800e1f:	8b 34 9d 80 26 80 00 	mov    0x802680(,%ebx,4),%esi
  800e26:	85 f6                	test   %esi,%esi
  800e28:	75 19                	jne    800e43 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e2a:	53                   	push   %ebx
  800e2b:	68 25 28 80 00       	push   $0x802825
  800e30:	ff 75 0c             	pushl  0xc(%ebp)
  800e33:	ff 75 08             	pushl  0x8(%ebp)
  800e36:	e8 5e 02 00 00       	call   801099 <printfmt>
  800e3b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e3e:	e9 49 02 00 00       	jmp    80108c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e43:	56                   	push   %esi
  800e44:	68 2e 28 80 00       	push   $0x80282e
  800e49:	ff 75 0c             	pushl  0xc(%ebp)
  800e4c:	ff 75 08             	pushl  0x8(%ebp)
  800e4f:	e8 45 02 00 00       	call   801099 <printfmt>
  800e54:	83 c4 10             	add    $0x10,%esp
			break;
  800e57:	e9 30 02 00 00       	jmp    80108c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5f:	83 c0 04             	add    $0x4,%eax
  800e62:	89 45 14             	mov    %eax,0x14(%ebp)
  800e65:	8b 45 14             	mov    0x14(%ebp),%eax
  800e68:	83 e8 04             	sub    $0x4,%eax
  800e6b:	8b 30                	mov    (%eax),%esi
  800e6d:	85 f6                	test   %esi,%esi
  800e6f:	75 05                	jne    800e76 <vprintfmt+0x1a6>
				p = "(null)";
  800e71:	be 31 28 80 00       	mov    $0x802831,%esi
			if (width > 0 && padc != '-')
  800e76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7a:	7e 6d                	jle    800ee9 <vprintfmt+0x219>
  800e7c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e80:	74 67                	je     800ee9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e85:	83 ec 08             	sub    $0x8,%esp
  800e88:	50                   	push   %eax
  800e89:	56                   	push   %esi
  800e8a:	e8 0c 03 00 00       	call   80119b <strnlen>
  800e8f:	83 c4 10             	add    $0x10,%esp
  800e92:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e95:	eb 16                	jmp    800ead <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e97:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e9b:	83 ec 08             	sub    $0x8,%esp
  800e9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ea1:	50                   	push   %eax
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	ff d0                	call   *%eax
  800ea7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eaa:	ff 4d e4             	decl   -0x1c(%ebp)
  800ead:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eb1:	7f e4                	jg     800e97 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eb3:	eb 34                	jmp    800ee9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800eb5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800eb9:	74 1c                	je     800ed7 <vprintfmt+0x207>
  800ebb:	83 fb 1f             	cmp    $0x1f,%ebx
  800ebe:	7e 05                	jle    800ec5 <vprintfmt+0x1f5>
  800ec0:	83 fb 7e             	cmp    $0x7e,%ebx
  800ec3:	7e 12                	jle    800ed7 <vprintfmt+0x207>
					putch('?', putdat);
  800ec5:	83 ec 08             	sub    $0x8,%esp
  800ec8:	ff 75 0c             	pushl  0xc(%ebp)
  800ecb:	6a 3f                	push   $0x3f
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	ff d0                	call   *%eax
  800ed2:	83 c4 10             	add    $0x10,%esp
  800ed5:	eb 0f                	jmp    800ee6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ed7:	83 ec 08             	sub    $0x8,%esp
  800eda:	ff 75 0c             	pushl  0xc(%ebp)
  800edd:	53                   	push   %ebx
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	ff d0                	call   *%eax
  800ee3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ee6:	ff 4d e4             	decl   -0x1c(%ebp)
  800ee9:	89 f0                	mov    %esi,%eax
  800eeb:	8d 70 01             	lea    0x1(%eax),%esi
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	0f be d8             	movsbl %al,%ebx
  800ef3:	85 db                	test   %ebx,%ebx
  800ef5:	74 24                	je     800f1b <vprintfmt+0x24b>
  800ef7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800efb:	78 b8                	js     800eb5 <vprintfmt+0x1e5>
  800efd:	ff 4d e0             	decl   -0x20(%ebp)
  800f00:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f04:	79 af                	jns    800eb5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f06:	eb 13                	jmp    800f1b <vprintfmt+0x24b>
				putch(' ', putdat);
  800f08:	83 ec 08             	sub    $0x8,%esp
  800f0b:	ff 75 0c             	pushl  0xc(%ebp)
  800f0e:	6a 20                	push   $0x20
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	ff d0                	call   *%eax
  800f15:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f18:	ff 4d e4             	decl   -0x1c(%ebp)
  800f1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1f:	7f e7                	jg     800f08 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f21:	e9 66 01 00 00       	jmp    80108c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f26:	83 ec 08             	sub    $0x8,%esp
  800f29:	ff 75 e8             	pushl  -0x18(%ebp)
  800f2c:	8d 45 14             	lea    0x14(%ebp),%eax
  800f2f:	50                   	push   %eax
  800f30:	e8 3c fd ff ff       	call   800c71 <getint>
  800f35:	83 c4 10             	add    $0x10,%esp
  800f38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f44:	85 d2                	test   %edx,%edx
  800f46:	79 23                	jns    800f6b <vprintfmt+0x29b>
				putch('-', putdat);
  800f48:	83 ec 08             	sub    $0x8,%esp
  800f4b:	ff 75 0c             	pushl  0xc(%ebp)
  800f4e:	6a 2d                	push   $0x2d
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	ff d0                	call   *%eax
  800f55:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f5e:	f7 d8                	neg    %eax
  800f60:	83 d2 00             	adc    $0x0,%edx
  800f63:	f7 da                	neg    %edx
  800f65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f6b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f72:	e9 bc 00 00 00       	jmp    801033 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f77:	83 ec 08             	sub    $0x8,%esp
  800f7a:	ff 75 e8             	pushl  -0x18(%ebp)
  800f7d:	8d 45 14             	lea    0x14(%ebp),%eax
  800f80:	50                   	push   %eax
  800f81:	e8 84 fc ff ff       	call   800c0a <getuint>
  800f86:	83 c4 10             	add    $0x10,%esp
  800f89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f8c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f8f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f96:	e9 98 00 00 00       	jmp    801033 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f9b:	83 ec 08             	sub    $0x8,%esp
  800f9e:	ff 75 0c             	pushl  0xc(%ebp)
  800fa1:	6a 58                	push   $0x58
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	ff d0                	call   *%eax
  800fa8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fab:	83 ec 08             	sub    $0x8,%esp
  800fae:	ff 75 0c             	pushl  0xc(%ebp)
  800fb1:	6a 58                	push   $0x58
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	ff d0                	call   *%eax
  800fb8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800fbb:	83 ec 08             	sub    $0x8,%esp
  800fbe:	ff 75 0c             	pushl  0xc(%ebp)
  800fc1:	6a 58                	push   $0x58
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	ff d0                	call   *%eax
  800fc8:	83 c4 10             	add    $0x10,%esp
			break;
  800fcb:	e9 bc 00 00 00       	jmp    80108c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800fd0:	83 ec 08             	sub    $0x8,%esp
  800fd3:	ff 75 0c             	pushl  0xc(%ebp)
  800fd6:	6a 30                	push   $0x30
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	ff d0                	call   *%eax
  800fdd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fe0:	83 ec 08             	sub    $0x8,%esp
  800fe3:	ff 75 0c             	pushl  0xc(%ebp)
  800fe6:	6a 78                	push   $0x78
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	ff d0                	call   *%eax
  800fed:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ff0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff3:	83 c0 04             	add    $0x4,%eax
  800ff6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ff9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffc:	83 e8 04             	sub    $0x4,%eax
  800fff:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801001:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801004:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80100b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801012:	eb 1f                	jmp    801033 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801014:	83 ec 08             	sub    $0x8,%esp
  801017:	ff 75 e8             	pushl  -0x18(%ebp)
  80101a:	8d 45 14             	lea    0x14(%ebp),%eax
  80101d:	50                   	push   %eax
  80101e:	e8 e7 fb ff ff       	call   800c0a <getuint>
  801023:	83 c4 10             	add    $0x10,%esp
  801026:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801029:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80102c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801033:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801037:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80103a:	83 ec 04             	sub    $0x4,%esp
  80103d:	52                   	push   %edx
  80103e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801041:	50                   	push   %eax
  801042:	ff 75 f4             	pushl  -0xc(%ebp)
  801045:	ff 75 f0             	pushl  -0x10(%ebp)
  801048:	ff 75 0c             	pushl  0xc(%ebp)
  80104b:	ff 75 08             	pushl  0x8(%ebp)
  80104e:	e8 00 fb ff ff       	call   800b53 <printnum>
  801053:	83 c4 20             	add    $0x20,%esp
			break;
  801056:	eb 34                	jmp    80108c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801058:	83 ec 08             	sub    $0x8,%esp
  80105b:	ff 75 0c             	pushl  0xc(%ebp)
  80105e:	53                   	push   %ebx
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	ff d0                	call   *%eax
  801064:	83 c4 10             	add    $0x10,%esp
			break;
  801067:	eb 23                	jmp    80108c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801069:	83 ec 08             	sub    $0x8,%esp
  80106c:	ff 75 0c             	pushl  0xc(%ebp)
  80106f:	6a 25                	push   $0x25
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	ff d0                	call   *%eax
  801076:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801079:	ff 4d 10             	decl   0x10(%ebp)
  80107c:	eb 03                	jmp    801081 <vprintfmt+0x3b1>
  80107e:	ff 4d 10             	decl   0x10(%ebp)
  801081:	8b 45 10             	mov    0x10(%ebp),%eax
  801084:	48                   	dec    %eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 25                	cmp    $0x25,%al
  801089:	75 f3                	jne    80107e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80108b:	90                   	nop
		}
	}
  80108c:	e9 47 fc ff ff       	jmp    800cd8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801091:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801092:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801095:	5b                   	pop    %ebx
  801096:	5e                   	pop    %esi
  801097:	5d                   	pop    %ebp
  801098:	c3                   	ret    

00801099 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80109f:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a2:	83 c0 04             	add    $0x4,%eax
  8010a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8010a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ae:	50                   	push   %eax
  8010af:	ff 75 0c             	pushl  0xc(%ebp)
  8010b2:	ff 75 08             	pushl  0x8(%ebp)
  8010b5:	e8 16 fc ff ff       	call   800cd0 <vprintfmt>
  8010ba:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010bd:	90                   	nop
  8010be:	c9                   	leave  
  8010bf:	c3                   	ret    

008010c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c6:	8b 40 08             	mov    0x8(%eax),%eax
  8010c9:	8d 50 01             	lea    0x1(%eax),%edx
  8010cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d5:	8b 10                	mov    (%eax),%edx
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	8b 40 04             	mov    0x4(%eax),%eax
  8010dd:	39 c2                	cmp    %eax,%edx
  8010df:	73 12                	jae    8010f3 <sprintputch+0x33>
		*b->buf++ = ch;
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	8b 00                	mov    (%eax),%eax
  8010e6:	8d 48 01             	lea    0x1(%eax),%ecx
  8010e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ec:	89 0a                	mov    %ecx,(%edx)
  8010ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f1:	88 10                	mov    %dl,(%eax)
}
  8010f3:	90                   	nop
  8010f4:	5d                   	pop    %ebp
  8010f5:	c3                   	ret    

008010f6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	8d 50 ff             	lea    -0x1(%eax),%edx
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	01 d0                	add    %edx,%eax
  80110d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801110:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801117:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111b:	74 06                	je     801123 <vsnprintf+0x2d>
  80111d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801121:	7f 07                	jg     80112a <vsnprintf+0x34>
		return -E_INVAL;
  801123:	b8 03 00 00 00       	mov    $0x3,%eax
  801128:	eb 20                	jmp    80114a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80112a:	ff 75 14             	pushl  0x14(%ebp)
  80112d:	ff 75 10             	pushl  0x10(%ebp)
  801130:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801133:	50                   	push   %eax
  801134:	68 c0 10 80 00       	push   $0x8010c0
  801139:	e8 92 fb ff ff       	call   800cd0 <vprintfmt>
  80113e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801141:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801144:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801147:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80114a:	c9                   	leave  
  80114b:	c3                   	ret    

0080114c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801152:	8d 45 10             	lea    0x10(%ebp),%eax
  801155:	83 c0 04             	add    $0x4,%eax
  801158:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80115b:	8b 45 10             	mov    0x10(%ebp),%eax
  80115e:	ff 75 f4             	pushl  -0xc(%ebp)
  801161:	50                   	push   %eax
  801162:	ff 75 0c             	pushl  0xc(%ebp)
  801165:	ff 75 08             	pushl  0x8(%ebp)
  801168:	e8 89 ff ff ff       	call   8010f6 <vsnprintf>
  80116d:	83 c4 10             	add    $0x10,%esp
  801170:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801173:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80117e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801185:	eb 06                	jmp    80118d <strlen+0x15>
		n++;
  801187:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80118a:	ff 45 08             	incl   0x8(%ebp)
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	84 c0                	test   %al,%al
  801194:	75 f1                	jne    801187 <strlen+0xf>
		n++;
	return n;
  801196:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011a8:	eb 09                	jmp    8011b3 <strnlen+0x18>
		n++;
  8011aa:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8011ad:	ff 45 08             	incl   0x8(%ebp)
  8011b0:	ff 4d 0c             	decl   0xc(%ebp)
  8011b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b7:	74 09                	je     8011c2 <strnlen+0x27>
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	84 c0                	test   %al,%al
  8011c0:	75 e8                	jne    8011aa <strnlen+0xf>
		n++;
	return n;
  8011c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011d3:	90                   	nop
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	8d 50 01             	lea    0x1(%eax),%edx
  8011da:	89 55 08             	mov    %edx,0x8(%ebp)
  8011dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011e3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011e6:	8a 12                	mov    (%edx),%dl
  8011e8:	88 10                	mov    %dl,(%eax)
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	84 c0                	test   %al,%al
  8011ee:	75 e4                	jne    8011d4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011f3:	c9                   	leave  
  8011f4:	c3                   	ret    

008011f5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801201:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801208:	eb 1f                	jmp    801229 <strncpy+0x34>
		*dst++ = *src;
  80120a:	8b 45 08             	mov    0x8(%ebp),%eax
  80120d:	8d 50 01             	lea    0x1(%eax),%edx
  801210:	89 55 08             	mov    %edx,0x8(%ebp)
  801213:	8b 55 0c             	mov    0xc(%ebp),%edx
  801216:	8a 12                	mov    (%edx),%dl
  801218:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	84 c0                	test   %al,%al
  801221:	74 03                	je     801226 <strncpy+0x31>
			src++;
  801223:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801226:	ff 45 fc             	incl   -0x4(%ebp)
  801229:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80122f:	72 d9                	jb     80120a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801231:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801242:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801246:	74 30                	je     801278 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801248:	eb 16                	jmp    801260 <strlcpy+0x2a>
			*dst++ = *src++;
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8d 50 01             	lea    0x1(%eax),%edx
  801250:	89 55 08             	mov    %edx,0x8(%ebp)
  801253:	8b 55 0c             	mov    0xc(%ebp),%edx
  801256:	8d 4a 01             	lea    0x1(%edx),%ecx
  801259:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80125c:	8a 12                	mov    (%edx),%dl
  80125e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801260:	ff 4d 10             	decl   0x10(%ebp)
  801263:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801267:	74 09                	je     801272 <strlcpy+0x3c>
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	84 c0                	test   %al,%al
  801270:	75 d8                	jne    80124a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801278:	8b 55 08             	mov    0x8(%ebp),%edx
  80127b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80127e:	29 c2                	sub    %eax,%edx
  801280:	89 d0                	mov    %edx,%eax
}
  801282:	c9                   	leave  
  801283:	c3                   	ret    

00801284 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801287:	eb 06                	jmp    80128f <strcmp+0xb>
		p++, q++;
  801289:	ff 45 08             	incl   0x8(%ebp)
  80128c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	8a 00                	mov    (%eax),%al
  801294:	84 c0                	test   %al,%al
  801296:	74 0e                	je     8012a6 <strcmp+0x22>
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	8a 10                	mov    (%eax),%dl
  80129d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	38 c2                	cmp    %al,%dl
  8012a4:	74 e3                	je     801289 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	8a 00                	mov    (%eax),%al
  8012ab:	0f b6 d0             	movzbl %al,%edx
  8012ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	0f b6 c0             	movzbl %al,%eax
  8012b6:	29 c2                	sub    %eax,%edx
  8012b8:	89 d0                	mov    %edx,%eax
}
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    

008012bc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8012bf:	eb 09                	jmp    8012ca <strncmp+0xe>
		n--, p++, q++;
  8012c1:	ff 4d 10             	decl   0x10(%ebp)
  8012c4:	ff 45 08             	incl   0x8(%ebp)
  8012c7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ce:	74 17                	je     8012e7 <strncmp+0x2b>
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	84 c0                	test   %al,%al
  8012d7:	74 0e                	je     8012e7 <strncmp+0x2b>
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 10                	mov    (%eax),%dl
  8012de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	38 c2                	cmp    %al,%dl
  8012e5:	74 da                	je     8012c1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012eb:	75 07                	jne    8012f4 <strncmp+0x38>
		return 0;
  8012ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f2:	eb 14                	jmp    801308 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	0f b6 d0             	movzbl %al,%edx
  8012fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	0f b6 c0             	movzbl %al,%eax
  801304:	29 c2                	sub    %eax,%edx
  801306:	89 d0                	mov    %edx,%eax
}
  801308:	5d                   	pop    %ebp
  801309:	c3                   	ret    

0080130a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
  80130d:	83 ec 04             	sub    $0x4,%esp
  801310:	8b 45 0c             	mov    0xc(%ebp),%eax
  801313:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801316:	eb 12                	jmp    80132a <strchr+0x20>
		if (*s == c)
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801320:	75 05                	jne    801327 <strchr+0x1d>
			return (char *) s;
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	eb 11                	jmp    801338 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801327:	ff 45 08             	incl   0x8(%ebp)
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	84 c0                	test   %al,%al
  801331:	75 e5                	jne    801318 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801333:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	83 ec 04             	sub    $0x4,%esp
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801346:	eb 0d                	jmp    801355 <strfind+0x1b>
		if (*s == c)
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801350:	74 0e                	je     801360 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801352:	ff 45 08             	incl   0x8(%ebp)
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	8a 00                	mov    (%eax),%al
  80135a:	84 c0                	test   %al,%al
  80135c:	75 ea                	jne    801348 <strfind+0xe>
  80135e:	eb 01                	jmp    801361 <strfind+0x27>
		if (*s == c)
			break;
  801360:	90                   	nop
	return (char *) s;
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801372:	8b 45 10             	mov    0x10(%ebp),%eax
  801375:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801378:	eb 0e                	jmp    801388 <memset+0x22>
		*p++ = c;
  80137a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137d:	8d 50 01             	lea    0x1(%eax),%edx
  801380:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801383:	8b 55 0c             	mov    0xc(%ebp),%edx
  801386:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801388:	ff 4d f8             	decl   -0x8(%ebp)
  80138b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80138f:	79 e9                	jns    80137a <memset+0x14>
		*p++ = c;

	return v;
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801394:	c9                   	leave  
  801395:	c3                   	ret    

00801396 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80139c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8013a8:	eb 16                	jmp    8013c0 <memcpy+0x2a>
		*d++ = *s++;
  8013aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ad:	8d 50 01             	lea    0x1(%eax),%edx
  8013b0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013b9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013bc:	8a 12                	mov    (%edx),%dl
  8013be:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8013c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	75 dd                	jne    8013aa <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    

008013d2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8013d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8013e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013ea:	73 50                	jae    80143c <memmove+0x6a>
  8013ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f2:	01 d0                	add    %edx,%eax
  8013f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013f7:	76 43                	jbe    80143c <memmove+0x6a>
		s += n;
  8013f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801402:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801405:	eb 10                	jmp    801417 <memmove+0x45>
			*--d = *--s;
  801407:	ff 4d f8             	decl   -0x8(%ebp)
  80140a:	ff 4d fc             	decl   -0x4(%ebp)
  80140d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801410:	8a 10                	mov    (%eax),%dl
  801412:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801415:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801417:	8b 45 10             	mov    0x10(%ebp),%eax
  80141a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80141d:	89 55 10             	mov    %edx,0x10(%ebp)
  801420:	85 c0                	test   %eax,%eax
  801422:	75 e3                	jne    801407 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801424:	eb 23                	jmp    801449 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801426:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801429:	8d 50 01             	lea    0x1(%eax),%edx
  80142c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80142f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801432:	8d 4a 01             	lea    0x1(%edx),%ecx
  801435:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801438:	8a 12                	mov    (%edx),%dl
  80143a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80143c:	8b 45 10             	mov    0x10(%ebp),%eax
  80143f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801442:	89 55 10             	mov    %edx,0x10(%ebp)
  801445:	85 c0                	test   %eax,%eax
  801447:	75 dd                	jne    801426 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    

0080144e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80145a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801460:	eb 2a                	jmp    80148c <memcmp+0x3e>
		if (*s1 != *s2)
  801462:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801465:	8a 10                	mov    (%eax),%dl
  801467:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	38 c2                	cmp    %al,%dl
  80146e:	74 16                	je     801486 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801470:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801473:	8a 00                	mov    (%eax),%al
  801475:	0f b6 d0             	movzbl %al,%edx
  801478:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80147b:	8a 00                	mov    (%eax),%al
  80147d:	0f b6 c0             	movzbl %al,%eax
  801480:	29 c2                	sub    %eax,%edx
  801482:	89 d0                	mov    %edx,%eax
  801484:	eb 18                	jmp    80149e <memcmp+0x50>
		s1++, s2++;
  801486:	ff 45 fc             	incl   -0x4(%ebp)
  801489:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80148c:	8b 45 10             	mov    0x10(%ebp),%eax
  80148f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801492:	89 55 10             	mov    %edx,0x10(%ebp)
  801495:	85 c0                	test   %eax,%eax
  801497:	75 c9                	jne    801462 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801499:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8014a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ac:	01 d0                	add    %edx,%eax
  8014ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8014b1:	eb 15                	jmp    8014c8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	0f b6 d0             	movzbl %al,%edx
  8014bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014be:	0f b6 c0             	movzbl %al,%eax
  8014c1:	39 c2                	cmp    %eax,%edx
  8014c3:	74 0d                	je     8014d2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014c5:	ff 45 08             	incl   0x8(%ebp)
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014ce:	72 e3                	jb     8014b3 <memfind+0x13>
  8014d0:	eb 01                	jmp    8014d3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014d2:	90                   	nop
	return (void *) s;
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8014de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8014e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ec:	eb 03                	jmp    8014f1 <strtol+0x19>
		s++;
  8014ee:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	8a 00                	mov    (%eax),%al
  8014f6:	3c 20                	cmp    $0x20,%al
  8014f8:	74 f4                	je     8014ee <strtol+0x16>
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	8a 00                	mov    (%eax),%al
  8014ff:	3c 09                	cmp    $0x9,%al
  801501:	74 eb                	je     8014ee <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	8a 00                	mov    (%eax),%al
  801508:	3c 2b                	cmp    $0x2b,%al
  80150a:	75 05                	jne    801511 <strtol+0x39>
		s++;
  80150c:	ff 45 08             	incl   0x8(%ebp)
  80150f:	eb 13                	jmp    801524 <strtol+0x4c>
	else if (*s == '-')
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	8a 00                	mov    (%eax),%al
  801516:	3c 2d                	cmp    $0x2d,%al
  801518:	75 0a                	jne    801524 <strtol+0x4c>
		s++, neg = 1;
  80151a:	ff 45 08             	incl   0x8(%ebp)
  80151d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801524:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801528:	74 06                	je     801530 <strtol+0x58>
  80152a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80152e:	75 20                	jne    801550 <strtol+0x78>
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	8a 00                	mov    (%eax),%al
  801535:	3c 30                	cmp    $0x30,%al
  801537:	75 17                	jne    801550 <strtol+0x78>
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	40                   	inc    %eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	3c 78                	cmp    $0x78,%al
  801541:	75 0d                	jne    801550 <strtol+0x78>
		s += 2, base = 16;
  801543:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801547:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80154e:	eb 28                	jmp    801578 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801550:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801554:	75 15                	jne    80156b <strtol+0x93>
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	8a 00                	mov    (%eax),%al
  80155b:	3c 30                	cmp    $0x30,%al
  80155d:	75 0c                	jne    80156b <strtol+0x93>
		s++, base = 8;
  80155f:	ff 45 08             	incl   0x8(%ebp)
  801562:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801569:	eb 0d                	jmp    801578 <strtol+0xa0>
	else if (base == 0)
  80156b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80156f:	75 07                	jne    801578 <strtol+0xa0>
		base = 10;
  801571:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	8a 00                	mov    (%eax),%al
  80157d:	3c 2f                	cmp    $0x2f,%al
  80157f:	7e 19                	jle    80159a <strtol+0xc2>
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	8a 00                	mov    (%eax),%al
  801586:	3c 39                	cmp    $0x39,%al
  801588:	7f 10                	jg     80159a <strtol+0xc2>
			dig = *s - '0';
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	8a 00                	mov    (%eax),%al
  80158f:	0f be c0             	movsbl %al,%eax
  801592:	83 e8 30             	sub    $0x30,%eax
  801595:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801598:	eb 42                	jmp    8015dc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	8a 00                	mov    (%eax),%al
  80159f:	3c 60                	cmp    $0x60,%al
  8015a1:	7e 19                	jle    8015bc <strtol+0xe4>
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	8a 00                	mov    (%eax),%al
  8015a8:	3c 7a                	cmp    $0x7a,%al
  8015aa:	7f 10                	jg     8015bc <strtol+0xe4>
			dig = *s - 'a' + 10;
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	8a 00                	mov    (%eax),%al
  8015b1:	0f be c0             	movsbl %al,%eax
  8015b4:	83 e8 57             	sub    $0x57,%eax
  8015b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8015ba:	eb 20                	jmp    8015dc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	3c 40                	cmp    $0x40,%al
  8015c3:	7e 39                	jle    8015fe <strtol+0x126>
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	3c 5a                	cmp    $0x5a,%al
  8015cc:	7f 30                	jg     8015fe <strtol+0x126>
			dig = *s - 'A' + 10;
  8015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d1:	8a 00                	mov    (%eax),%al
  8015d3:	0f be c0             	movsbl %al,%eax
  8015d6:	83 e8 37             	sub    $0x37,%eax
  8015d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8015dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015df:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015e2:	7d 19                	jge    8015fd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8015e4:	ff 45 08             	incl   0x8(%ebp)
  8015e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ea:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015ee:	89 c2                	mov    %eax,%edx
  8015f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f3:	01 d0                	add    %edx,%eax
  8015f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015f8:	e9 7b ff ff ff       	jmp    801578 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015fd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801602:	74 08                	je     80160c <strtol+0x134>
		*endptr = (char *) s;
  801604:	8b 45 0c             	mov    0xc(%ebp),%eax
  801607:	8b 55 08             	mov    0x8(%ebp),%edx
  80160a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80160c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801610:	74 07                	je     801619 <strtol+0x141>
  801612:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801615:	f7 d8                	neg    %eax
  801617:	eb 03                	jmp    80161c <strtol+0x144>
  801619:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <ltostr>:

void
ltostr(long value, char *str)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801624:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80162b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801632:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801636:	79 13                	jns    80164b <ltostr+0x2d>
	{
		neg = 1;
  801638:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80163f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801642:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801645:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801648:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801653:	99                   	cltd   
  801654:	f7 f9                	idiv   %ecx
  801656:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801659:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165c:	8d 50 01             	lea    0x1(%eax),%edx
  80165f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801662:	89 c2                	mov    %eax,%edx
  801664:	8b 45 0c             	mov    0xc(%ebp),%eax
  801667:	01 d0                	add    %edx,%eax
  801669:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80166c:	83 c2 30             	add    $0x30,%edx
  80166f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801671:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801674:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801679:	f7 e9                	imul   %ecx
  80167b:	c1 fa 02             	sar    $0x2,%edx
  80167e:	89 c8                	mov    %ecx,%eax
  801680:	c1 f8 1f             	sar    $0x1f,%eax
  801683:	29 c2                	sub    %eax,%edx
  801685:	89 d0                	mov    %edx,%eax
  801687:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80168a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80168d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801692:	f7 e9                	imul   %ecx
  801694:	c1 fa 02             	sar    $0x2,%edx
  801697:	89 c8                	mov    %ecx,%eax
  801699:	c1 f8 1f             	sar    $0x1f,%eax
  80169c:	29 c2                	sub    %eax,%edx
  80169e:	89 d0                	mov    %edx,%eax
  8016a0:	c1 e0 02             	shl    $0x2,%eax
  8016a3:	01 d0                	add    %edx,%eax
  8016a5:	01 c0                	add    %eax,%eax
  8016a7:	29 c1                	sub    %eax,%ecx
  8016a9:	89 ca                	mov    %ecx,%edx
  8016ab:	85 d2                	test   %edx,%edx
  8016ad:	75 9c                	jne    80164b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8016af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8016b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b9:	48                   	dec    %eax
  8016ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8016bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016c1:	74 3d                	je     801700 <ltostr+0xe2>
		start = 1 ;
  8016c3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8016ca:	eb 34                	jmp    801700 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8016cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d2:	01 d0                	add    %edx,%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8016d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016df:	01 c2                	add    %eax,%edx
  8016e1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8016e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e7:	01 c8                	add    %ecx,%eax
  8016e9:	8a 00                	mov    (%eax),%al
  8016eb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8016ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f3:	01 c2                	add    %eax,%edx
  8016f5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8016f8:	88 02                	mov    %al,(%edx)
		start++ ;
  8016fa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8016fd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801703:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801706:	7c c4                	jl     8016cc <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801708:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80170b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170e:	01 d0                	add    %edx,%eax
  801710:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801713:	90                   	nop
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80171c:	ff 75 08             	pushl  0x8(%ebp)
  80171f:	e8 54 fa ff ff       	call   801178 <strlen>
  801724:	83 c4 04             	add    $0x4,%esp
  801727:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80172a:	ff 75 0c             	pushl  0xc(%ebp)
  80172d:	e8 46 fa ff ff       	call   801178 <strlen>
  801732:	83 c4 04             	add    $0x4,%esp
  801735:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801738:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80173f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801746:	eb 17                	jmp    80175f <strcconcat+0x49>
		final[s] = str1[s] ;
  801748:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80174b:	8b 45 10             	mov    0x10(%ebp),%eax
  80174e:	01 c2                	add    %eax,%edx
  801750:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	01 c8                	add    %ecx,%eax
  801758:	8a 00                	mov    (%eax),%al
  80175a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80175c:	ff 45 fc             	incl   -0x4(%ebp)
  80175f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801762:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801765:	7c e1                	jl     801748 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801767:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80176e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801775:	eb 1f                	jmp    801796 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801777:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177a:	8d 50 01             	lea    0x1(%eax),%edx
  80177d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801780:	89 c2                	mov    %eax,%edx
  801782:	8b 45 10             	mov    0x10(%ebp),%eax
  801785:	01 c2                	add    %eax,%edx
  801787:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80178a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178d:	01 c8                	add    %ecx,%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801793:	ff 45 f8             	incl   -0x8(%ebp)
  801796:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801799:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80179c:	7c d9                	jl     801777 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80179e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a4:	01 d0                	add    %edx,%eax
  8017a6:	c6 00 00             	movb   $0x0,(%eax)
}
  8017a9:	90                   	nop
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8017af:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8017b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8017bb:	8b 00                	mov    (%eax),%eax
  8017bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c7:	01 d0                	add    %edx,%eax
  8017c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017cf:	eb 0c                	jmp    8017dd <strsplit+0x31>
			*string++ = 0;
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	8d 50 01             	lea    0x1(%eax),%edx
  8017d7:	89 55 08             	mov    %edx,0x8(%ebp)
  8017da:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	8a 00                	mov    (%eax),%al
  8017e2:	84 c0                	test   %al,%al
  8017e4:	74 18                	je     8017fe <strsplit+0x52>
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	8a 00                	mov    (%eax),%al
  8017eb:	0f be c0             	movsbl %al,%eax
  8017ee:	50                   	push   %eax
  8017ef:	ff 75 0c             	pushl  0xc(%ebp)
  8017f2:	e8 13 fb ff ff       	call   80130a <strchr>
  8017f7:	83 c4 08             	add    $0x8,%esp
  8017fa:	85 c0                	test   %eax,%eax
  8017fc:	75 d3                	jne    8017d1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	84 c0                	test   %al,%al
  801805:	74 5a                	je     801861 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801807:	8b 45 14             	mov    0x14(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	83 f8 0f             	cmp    $0xf,%eax
  80180f:	75 07                	jne    801818 <strsplit+0x6c>
		{
			return 0;
  801811:	b8 00 00 00 00       	mov    $0x0,%eax
  801816:	eb 66                	jmp    80187e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801818:	8b 45 14             	mov    0x14(%ebp),%eax
  80181b:	8b 00                	mov    (%eax),%eax
  80181d:	8d 48 01             	lea    0x1(%eax),%ecx
  801820:	8b 55 14             	mov    0x14(%ebp),%edx
  801823:	89 0a                	mov    %ecx,(%edx)
  801825:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80182c:	8b 45 10             	mov    0x10(%ebp),%eax
  80182f:	01 c2                	add    %eax,%edx
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801836:	eb 03                	jmp    80183b <strsplit+0x8f>
			string++;
  801838:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	84 c0                	test   %al,%al
  801842:	74 8b                	je     8017cf <strsplit+0x23>
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	8a 00                	mov    (%eax),%al
  801849:	0f be c0             	movsbl %al,%eax
  80184c:	50                   	push   %eax
  80184d:	ff 75 0c             	pushl  0xc(%ebp)
  801850:	e8 b5 fa ff ff       	call   80130a <strchr>
  801855:	83 c4 08             	add    $0x8,%esp
  801858:	85 c0                	test   %eax,%eax
  80185a:	74 dc                	je     801838 <strsplit+0x8c>
			string++;
	}
  80185c:	e9 6e ff ff ff       	jmp    8017cf <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801861:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801862:	8b 45 14             	mov    0x14(%ebp),%eax
  801865:	8b 00                	mov    (%eax),%eax
  801867:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80186e:	8b 45 10             	mov    0x10(%ebp),%eax
  801871:	01 d0                	add    %edx,%eax
  801873:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801879:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801886:	83 ec 04             	sub    $0x4,%esp
  801889:	68 90 29 80 00       	push   $0x802990
  80188e:	6a 0e                	push   $0xe
  801890:	68 ca 29 80 00       	push   $0x8029ca
  801895:	e8 a8 ef ff ff       	call   800842 <_panic>

0080189a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  8018a0:	a1 04 30 80 00       	mov    0x803004,%eax
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	74 0f                	je     8018b8 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  8018a9:	e8 d2 ff ff ff       	call   801880 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8018ae:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  8018b5:	00 00 00 
	}
	if (size == 0) return NULL ;
  8018b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018bc:	75 07                	jne    8018c5 <malloc+0x2b>
  8018be:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c3:	eb 14                	jmp    8018d9 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8018c5:	83 ec 04             	sub    $0x4,%esp
  8018c8:	68 d8 29 80 00       	push   $0x8029d8
  8018cd:	6a 2e                	push   $0x2e
  8018cf:	68 ca 29 80 00       	push   $0x8029ca
  8018d4:	e8 69 ef ff ff       	call   800842 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8018e1:	83 ec 04             	sub    $0x4,%esp
  8018e4:	68 00 2a 80 00       	push   $0x802a00
  8018e9:	6a 49                	push   $0x49
  8018eb:	68 ca 29 80 00       	push   $0x8029ca
  8018f0:	e8 4d ef ff ff       	call   800842 <_panic>

008018f5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	83 ec 18             	sub    $0x18,%esp
  8018fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fe:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801901:	83 ec 04             	sub    $0x4,%esp
  801904:	68 24 2a 80 00       	push   $0x802a24
  801909:	6a 57                	push   $0x57
  80190b:	68 ca 29 80 00       	push   $0x8029ca
  801910:	e8 2d ef ff ff       	call   800842 <_panic>

00801915 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80191b:	83 ec 04             	sub    $0x4,%esp
  80191e:	68 4c 2a 80 00       	push   $0x802a4c
  801923:	6a 60                	push   $0x60
  801925:	68 ca 29 80 00       	push   $0x8029ca
  80192a:	e8 13 ef ff ff       	call   800842 <_panic>

0080192f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801935:	83 ec 04             	sub    $0x4,%esp
  801938:	68 70 2a 80 00       	push   $0x802a70
  80193d:	6a 7c                	push   $0x7c
  80193f:	68 ca 29 80 00       	push   $0x8029ca
  801944:	e8 f9 ee ff ff       	call   800842 <_panic>

00801949 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80194f:	83 ec 04             	sub    $0x4,%esp
  801952:	68 98 2a 80 00       	push   $0x802a98
  801957:	68 86 00 00 00       	push   $0x86
  80195c:	68 ca 29 80 00       	push   $0x8029ca
  801961:	e8 dc ee ff ff       	call   800842 <_panic>

00801966 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80196c:	83 ec 04             	sub    $0x4,%esp
  80196f:	68 bc 2a 80 00       	push   $0x802abc
  801974:	68 91 00 00 00       	push   $0x91
  801979:	68 ca 29 80 00       	push   $0x8029ca
  80197e:	e8 bf ee ff ff       	call   800842 <_panic>

00801983 <shrink>:

}
void shrink(uint32 newSize)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801989:	83 ec 04             	sub    $0x4,%esp
  80198c:	68 bc 2a 80 00       	push   $0x802abc
  801991:	68 96 00 00 00       	push   $0x96
  801996:	68 ca 29 80 00       	push   $0x8029ca
  80199b:	e8 a2 ee ff ff       	call   800842 <_panic>

008019a0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	68 bc 2a 80 00       	push   $0x802abc
  8019ae:	68 9b 00 00 00       	push   $0x9b
  8019b3:	68 ca 29 80 00       	push   $0x8029ca
  8019b8:	e8 85 ee ff ff       	call   800842 <_panic>

008019bd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	57                   	push   %edi
  8019c1:	56                   	push   %esi
  8019c2:	53                   	push   %ebx
  8019c3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019d2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019d5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019d8:	cd 30                	int    $0x30
  8019da:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019e0:	83 c4 10             	add    $0x10,%esp
  8019e3:	5b                   	pop    %ebx
  8019e4:	5e                   	pop    %esi
  8019e5:	5f                   	pop    %edi
  8019e6:	5d                   	pop    %ebp
  8019e7:	c3                   	ret    

008019e8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019f4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	52                   	push   %edx
  801a00:	ff 75 0c             	pushl  0xc(%ebp)
  801a03:	50                   	push   %eax
  801a04:	6a 00                	push   $0x0
  801a06:	e8 b2 ff ff ff       	call   8019bd <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	90                   	nop
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 01                	push   $0x1
  801a20:	e8 98 ff ff ff       	call   8019bd <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	52                   	push   %edx
  801a3a:	50                   	push   %eax
  801a3b:	6a 05                	push   $0x5
  801a3d:	e8 7b ff ff ff       	call   8019bd <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	56                   	push   %esi
  801a4b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a4c:	8b 75 18             	mov    0x18(%ebp),%esi
  801a4f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a52:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	56                   	push   %esi
  801a5c:	53                   	push   %ebx
  801a5d:	51                   	push   %ecx
  801a5e:	52                   	push   %edx
  801a5f:	50                   	push   %eax
  801a60:	6a 06                	push   $0x6
  801a62:	e8 56 ff ff ff       	call   8019bd <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a6d:	5b                   	pop    %ebx
  801a6e:	5e                   	pop    %esi
  801a6f:	5d                   	pop    %ebp
  801a70:	c3                   	ret    

00801a71 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	52                   	push   %edx
  801a81:	50                   	push   %eax
  801a82:	6a 07                	push   $0x7
  801a84:	e8 34 ff ff ff       	call   8019bd <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	ff 75 0c             	pushl  0xc(%ebp)
  801a9a:	ff 75 08             	pushl  0x8(%ebp)
  801a9d:	6a 08                	push   $0x8
  801a9f:	e8 19 ff ff ff       	call   8019bd <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 09                	push   $0x9
  801ab8:	e8 00 ff ff ff       	call   8019bd <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 0a                	push   $0xa
  801ad1:	e8 e7 fe ff ff       	call   8019bd <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 0b                	push   $0xb
  801aea:	e8 ce fe ff ff       	call   8019bd <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	ff 75 08             	pushl  0x8(%ebp)
  801b03:	6a 0f                	push   $0xf
  801b05:	e8 b3 fe ff ff       	call   8019bd <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
	return;
  801b0d:	90                   	nop
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	ff 75 0c             	pushl  0xc(%ebp)
  801b1c:	ff 75 08             	pushl  0x8(%ebp)
  801b1f:	6a 10                	push   $0x10
  801b21:	e8 97 fe ff ff       	call   8019bd <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
	return ;
  801b29:	90                   	nop
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	ff 75 10             	pushl  0x10(%ebp)
  801b36:	ff 75 0c             	pushl  0xc(%ebp)
  801b39:	ff 75 08             	pushl  0x8(%ebp)
  801b3c:	6a 11                	push   $0x11
  801b3e:	e8 7a fe ff ff       	call   8019bd <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
	return ;
  801b46:	90                   	nop
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 0c                	push   $0xc
  801b58:	e8 60 fe ff ff       	call   8019bd <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	ff 75 08             	pushl  0x8(%ebp)
  801b70:	6a 0d                	push   $0xd
  801b72:	e8 46 fe ff ff       	call   8019bd <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 0e                	push   $0xe
  801b8b:	e8 2d fe ff ff       	call   8019bd <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
}
  801b93:	90                   	nop
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 13                	push   $0x13
  801ba5:	e8 13 fe ff ff       	call   8019bd <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	90                   	nop
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 14                	push   $0x14
  801bbf:	e8 f9 fd ff ff       	call   8019bd <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	90                   	nop
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_cputc>:


void
sys_cputc(const char c)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
  801bcd:	83 ec 04             	sub    $0x4,%esp
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bd6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	50                   	push   %eax
  801be3:	6a 15                	push   $0x15
  801be5:	e8 d3 fd ff ff       	call   8019bd <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	90                   	nop
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 16                	push   $0x16
  801bff:	e8 b9 fd ff ff       	call   8019bd <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	90                   	nop
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	ff 75 0c             	pushl  0xc(%ebp)
  801c19:	50                   	push   %eax
  801c1a:	6a 17                	push   $0x17
  801c1c:	e8 9c fd ff ff       	call   8019bd <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	52                   	push   %edx
  801c36:	50                   	push   %eax
  801c37:	6a 1a                	push   $0x1a
  801c39:	e8 7f fd ff ff       	call   8019bd <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	52                   	push   %edx
  801c53:	50                   	push   %eax
  801c54:	6a 18                	push   $0x18
  801c56:	e8 62 fd ff ff       	call   8019bd <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	90                   	nop
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	52                   	push   %edx
  801c71:	50                   	push   %eax
  801c72:	6a 19                	push   $0x19
  801c74:	e8 44 fd ff ff       	call   8019bd <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
}
  801c7c:	90                   	nop
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 04             	sub    $0x4,%esp
  801c85:	8b 45 10             	mov    0x10(%ebp),%eax
  801c88:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c8b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c8e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	6a 00                	push   $0x0
  801c97:	51                   	push   %ecx
  801c98:	52                   	push   %edx
  801c99:	ff 75 0c             	pushl  0xc(%ebp)
  801c9c:	50                   	push   %eax
  801c9d:	6a 1b                	push   $0x1b
  801c9f:	e8 19 fd ff ff       	call   8019bd <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	52                   	push   %edx
  801cb9:	50                   	push   %eax
  801cba:	6a 1c                	push   $0x1c
  801cbc:	e8 fc fc ff ff       	call   8019bd <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cc9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	51                   	push   %ecx
  801cd7:	52                   	push   %edx
  801cd8:	50                   	push   %eax
  801cd9:	6a 1d                	push   $0x1d
  801cdb:	e8 dd fc ff ff       	call   8019bd <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	52                   	push   %edx
  801cf5:	50                   	push   %eax
  801cf6:	6a 1e                	push   $0x1e
  801cf8:	e8 c0 fc ff ff       	call   8019bd <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 1f                	push   $0x1f
  801d11:	e8 a7 fc ff ff       	call   8019bd <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	6a 00                	push   $0x0
  801d23:	ff 75 14             	pushl  0x14(%ebp)
  801d26:	ff 75 10             	pushl  0x10(%ebp)
  801d29:	ff 75 0c             	pushl  0xc(%ebp)
  801d2c:	50                   	push   %eax
  801d2d:	6a 20                	push   $0x20
  801d2f:	e8 89 fc ff ff       	call   8019bd <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	50                   	push   %eax
  801d48:	6a 21                	push   $0x21
  801d4a:	e8 6e fc ff ff       	call   8019bd <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
}
  801d52:	90                   	nop
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	50                   	push   %eax
  801d64:	6a 22                	push   $0x22
  801d66:	e8 52 fc ff ff       	call   8019bd <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 02                	push   $0x2
  801d7f:	e8 39 fc ff ff       	call   8019bd <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 03                	push   $0x3
  801d98:	e8 20 fc ff ff       	call   8019bd <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 04                	push   $0x4
  801db1:	e8 07 fc ff ff       	call   8019bd <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <sys_exit_env>:


void sys_exit_env(void)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 23                	push   $0x23
  801dca:	e8 ee fb ff ff       	call   8019bd <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
}
  801dd2:	90                   	nop
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ddb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dde:	8d 50 04             	lea    0x4(%eax),%edx
  801de1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	52                   	push   %edx
  801deb:	50                   	push   %eax
  801dec:	6a 24                	push   $0x24
  801dee:	e8 ca fb ff ff       	call   8019bd <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
	return result;
  801df6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dfc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dff:	89 01                	mov    %eax,(%ecx)
  801e01:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	c9                   	leave  
  801e08:	c2 04 00             	ret    $0x4

00801e0b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	ff 75 10             	pushl  0x10(%ebp)
  801e15:	ff 75 0c             	pushl  0xc(%ebp)
  801e18:	ff 75 08             	pushl  0x8(%ebp)
  801e1b:	6a 12                	push   $0x12
  801e1d:	e8 9b fb ff ff       	call   8019bd <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
	return ;
  801e25:	90                   	nop
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 25                	push   $0x25
  801e37:	e8 81 fb ff ff       	call   8019bd <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 04             	sub    $0x4,%esp
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e4d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	50                   	push   %eax
  801e5a:	6a 26                	push   $0x26
  801e5c:	e8 5c fb ff ff       	call   8019bd <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
	return ;
  801e64:	90                   	nop
}
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <rsttst>:
void rsttst()
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 28                	push   $0x28
  801e76:	e8 42 fb ff ff       	call   8019bd <syscall>
  801e7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7e:	90                   	nop
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 04             	sub    $0x4,%esp
  801e87:	8b 45 14             	mov    0x14(%ebp),%eax
  801e8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e8d:	8b 55 18             	mov    0x18(%ebp),%edx
  801e90:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e94:	52                   	push   %edx
  801e95:	50                   	push   %eax
  801e96:	ff 75 10             	pushl  0x10(%ebp)
  801e99:	ff 75 0c             	pushl  0xc(%ebp)
  801e9c:	ff 75 08             	pushl  0x8(%ebp)
  801e9f:	6a 27                	push   $0x27
  801ea1:	e8 17 fb ff ff       	call   8019bd <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea9:	90                   	nop
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <chktst>:
void chktst(uint32 n)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	ff 75 08             	pushl  0x8(%ebp)
  801eba:	6a 29                	push   $0x29
  801ebc:	e8 fc fa ff ff       	call   8019bd <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec4:	90                   	nop
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <inctst>:

void inctst()
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 2a                	push   $0x2a
  801ed6:	e8 e2 fa ff ff       	call   8019bd <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ede:	90                   	nop
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <gettst>:
uint32 gettst()
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 2b                	push   $0x2b
  801ef0:	e8 c8 fa ff ff       	call   8019bd <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 2c                	push   $0x2c
  801f0c:	e8 ac fa ff ff       	call   8019bd <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
  801f14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f17:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f1b:	75 07                	jne    801f24 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f1d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f22:	eb 05                	jmp    801f29 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 2c                	push   $0x2c
  801f3d:	e8 7b fa ff ff       	call   8019bd <syscall>
  801f42:	83 c4 18             	add    $0x18,%esp
  801f45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f48:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f4c:	75 07                	jne    801f55 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f53:	eb 05                	jmp    801f5a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 2c                	push   $0x2c
  801f6e:	e8 4a fa ff ff       	call   8019bd <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
  801f76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f79:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f7d:	75 07                	jne    801f86 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f7f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f84:	eb 05                	jmp    801f8b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 2c                	push   $0x2c
  801f9f:	e8 19 fa ff ff       	call   8019bd <syscall>
  801fa4:	83 c4 18             	add    $0x18,%esp
  801fa7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801faa:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fae:	75 07                	jne    801fb7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fb0:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb5:	eb 05                	jmp    801fbc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	ff 75 08             	pushl  0x8(%ebp)
  801fcc:	6a 2d                	push   $0x2d
  801fce:	e8 ea f9 ff ff       	call   8019bd <syscall>
  801fd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd6:	90                   	nop
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fdd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fe0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	6a 00                	push   $0x0
  801feb:	53                   	push   %ebx
  801fec:	51                   	push   %ecx
  801fed:	52                   	push   %edx
  801fee:	50                   	push   %eax
  801fef:	6a 2e                	push   $0x2e
  801ff1:	e8 c7 f9 ff ff       	call   8019bd <syscall>
  801ff6:	83 c4 18             	add    $0x18,%esp
}
  801ff9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802001:	8b 55 0c             	mov    0xc(%ebp),%edx
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	52                   	push   %edx
  80200e:	50                   	push   %eax
  80200f:	6a 2f                	push   $0x2f
  802011:	e8 a7 f9 ff ff       	call   8019bd <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    
  80201b:	90                   	nop

0080201c <__udivdi3>:
  80201c:	55                   	push   %ebp
  80201d:	57                   	push   %edi
  80201e:	56                   	push   %esi
  80201f:	53                   	push   %ebx
  802020:	83 ec 1c             	sub    $0x1c,%esp
  802023:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802027:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80202b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80202f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802033:	89 ca                	mov    %ecx,%edx
  802035:	89 f8                	mov    %edi,%eax
  802037:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80203b:	85 f6                	test   %esi,%esi
  80203d:	75 2d                	jne    80206c <__udivdi3+0x50>
  80203f:	39 cf                	cmp    %ecx,%edi
  802041:	77 65                	ja     8020a8 <__udivdi3+0x8c>
  802043:	89 fd                	mov    %edi,%ebp
  802045:	85 ff                	test   %edi,%edi
  802047:	75 0b                	jne    802054 <__udivdi3+0x38>
  802049:	b8 01 00 00 00       	mov    $0x1,%eax
  80204e:	31 d2                	xor    %edx,%edx
  802050:	f7 f7                	div    %edi
  802052:	89 c5                	mov    %eax,%ebp
  802054:	31 d2                	xor    %edx,%edx
  802056:	89 c8                	mov    %ecx,%eax
  802058:	f7 f5                	div    %ebp
  80205a:	89 c1                	mov    %eax,%ecx
  80205c:	89 d8                	mov    %ebx,%eax
  80205e:	f7 f5                	div    %ebp
  802060:	89 cf                	mov    %ecx,%edi
  802062:	89 fa                	mov    %edi,%edx
  802064:	83 c4 1c             	add    $0x1c,%esp
  802067:	5b                   	pop    %ebx
  802068:	5e                   	pop    %esi
  802069:	5f                   	pop    %edi
  80206a:	5d                   	pop    %ebp
  80206b:	c3                   	ret    
  80206c:	39 ce                	cmp    %ecx,%esi
  80206e:	77 28                	ja     802098 <__udivdi3+0x7c>
  802070:	0f bd fe             	bsr    %esi,%edi
  802073:	83 f7 1f             	xor    $0x1f,%edi
  802076:	75 40                	jne    8020b8 <__udivdi3+0x9c>
  802078:	39 ce                	cmp    %ecx,%esi
  80207a:	72 0a                	jb     802086 <__udivdi3+0x6a>
  80207c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802080:	0f 87 9e 00 00 00    	ja     802124 <__udivdi3+0x108>
  802086:	b8 01 00 00 00       	mov    $0x1,%eax
  80208b:	89 fa                	mov    %edi,%edx
  80208d:	83 c4 1c             	add    $0x1c,%esp
  802090:	5b                   	pop    %ebx
  802091:	5e                   	pop    %esi
  802092:	5f                   	pop    %edi
  802093:	5d                   	pop    %ebp
  802094:	c3                   	ret    
  802095:	8d 76 00             	lea    0x0(%esi),%esi
  802098:	31 ff                	xor    %edi,%edi
  80209a:	31 c0                	xor    %eax,%eax
  80209c:	89 fa                	mov    %edi,%edx
  80209e:	83 c4 1c             	add    $0x1c,%esp
  8020a1:	5b                   	pop    %ebx
  8020a2:	5e                   	pop    %esi
  8020a3:	5f                   	pop    %edi
  8020a4:	5d                   	pop    %ebp
  8020a5:	c3                   	ret    
  8020a6:	66 90                	xchg   %ax,%ax
  8020a8:	89 d8                	mov    %ebx,%eax
  8020aa:	f7 f7                	div    %edi
  8020ac:	31 ff                	xor    %edi,%edi
  8020ae:	89 fa                	mov    %edi,%edx
  8020b0:	83 c4 1c             	add    $0x1c,%esp
  8020b3:	5b                   	pop    %ebx
  8020b4:	5e                   	pop    %esi
  8020b5:	5f                   	pop    %edi
  8020b6:	5d                   	pop    %ebp
  8020b7:	c3                   	ret    
  8020b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020bd:	89 eb                	mov    %ebp,%ebx
  8020bf:	29 fb                	sub    %edi,%ebx
  8020c1:	89 f9                	mov    %edi,%ecx
  8020c3:	d3 e6                	shl    %cl,%esi
  8020c5:	89 c5                	mov    %eax,%ebp
  8020c7:	88 d9                	mov    %bl,%cl
  8020c9:	d3 ed                	shr    %cl,%ebp
  8020cb:	89 e9                	mov    %ebp,%ecx
  8020cd:	09 f1                	or     %esi,%ecx
  8020cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8020d3:	89 f9                	mov    %edi,%ecx
  8020d5:	d3 e0                	shl    %cl,%eax
  8020d7:	89 c5                	mov    %eax,%ebp
  8020d9:	89 d6                	mov    %edx,%esi
  8020db:	88 d9                	mov    %bl,%cl
  8020dd:	d3 ee                	shr    %cl,%esi
  8020df:	89 f9                	mov    %edi,%ecx
  8020e1:	d3 e2                	shl    %cl,%edx
  8020e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020e7:	88 d9                	mov    %bl,%cl
  8020e9:	d3 e8                	shr    %cl,%eax
  8020eb:	09 c2                	or     %eax,%edx
  8020ed:	89 d0                	mov    %edx,%eax
  8020ef:	89 f2                	mov    %esi,%edx
  8020f1:	f7 74 24 0c          	divl   0xc(%esp)
  8020f5:	89 d6                	mov    %edx,%esi
  8020f7:	89 c3                	mov    %eax,%ebx
  8020f9:	f7 e5                	mul    %ebp
  8020fb:	39 d6                	cmp    %edx,%esi
  8020fd:	72 19                	jb     802118 <__udivdi3+0xfc>
  8020ff:	74 0b                	je     80210c <__udivdi3+0xf0>
  802101:	89 d8                	mov    %ebx,%eax
  802103:	31 ff                	xor    %edi,%edi
  802105:	e9 58 ff ff ff       	jmp    802062 <__udivdi3+0x46>
  80210a:	66 90                	xchg   %ax,%ax
  80210c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802110:	89 f9                	mov    %edi,%ecx
  802112:	d3 e2                	shl    %cl,%edx
  802114:	39 c2                	cmp    %eax,%edx
  802116:	73 e9                	jae    802101 <__udivdi3+0xe5>
  802118:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80211b:	31 ff                	xor    %edi,%edi
  80211d:	e9 40 ff ff ff       	jmp    802062 <__udivdi3+0x46>
  802122:	66 90                	xchg   %ax,%ax
  802124:	31 c0                	xor    %eax,%eax
  802126:	e9 37 ff ff ff       	jmp    802062 <__udivdi3+0x46>
  80212b:	90                   	nop

0080212c <__umoddi3>:
  80212c:	55                   	push   %ebp
  80212d:	57                   	push   %edi
  80212e:	56                   	push   %esi
  80212f:	53                   	push   %ebx
  802130:	83 ec 1c             	sub    $0x1c,%esp
  802133:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802137:	8b 74 24 34          	mov    0x34(%esp),%esi
  80213b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80213f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802143:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802147:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80214b:	89 f3                	mov    %esi,%ebx
  80214d:	89 fa                	mov    %edi,%edx
  80214f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802153:	89 34 24             	mov    %esi,(%esp)
  802156:	85 c0                	test   %eax,%eax
  802158:	75 1a                	jne    802174 <__umoddi3+0x48>
  80215a:	39 f7                	cmp    %esi,%edi
  80215c:	0f 86 a2 00 00 00    	jbe    802204 <__umoddi3+0xd8>
  802162:	89 c8                	mov    %ecx,%eax
  802164:	89 f2                	mov    %esi,%edx
  802166:	f7 f7                	div    %edi
  802168:	89 d0                	mov    %edx,%eax
  80216a:	31 d2                	xor    %edx,%edx
  80216c:	83 c4 1c             	add    $0x1c,%esp
  80216f:	5b                   	pop    %ebx
  802170:	5e                   	pop    %esi
  802171:	5f                   	pop    %edi
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    
  802174:	39 f0                	cmp    %esi,%eax
  802176:	0f 87 ac 00 00 00    	ja     802228 <__umoddi3+0xfc>
  80217c:	0f bd e8             	bsr    %eax,%ebp
  80217f:	83 f5 1f             	xor    $0x1f,%ebp
  802182:	0f 84 ac 00 00 00    	je     802234 <__umoddi3+0x108>
  802188:	bf 20 00 00 00       	mov    $0x20,%edi
  80218d:	29 ef                	sub    %ebp,%edi
  80218f:	89 fe                	mov    %edi,%esi
  802191:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802195:	89 e9                	mov    %ebp,%ecx
  802197:	d3 e0                	shl    %cl,%eax
  802199:	89 d7                	mov    %edx,%edi
  80219b:	89 f1                	mov    %esi,%ecx
  80219d:	d3 ef                	shr    %cl,%edi
  80219f:	09 c7                	or     %eax,%edi
  8021a1:	89 e9                	mov    %ebp,%ecx
  8021a3:	d3 e2                	shl    %cl,%edx
  8021a5:	89 14 24             	mov    %edx,(%esp)
  8021a8:	89 d8                	mov    %ebx,%eax
  8021aa:	d3 e0                	shl    %cl,%eax
  8021ac:	89 c2                	mov    %eax,%edx
  8021ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021b2:	d3 e0                	shl    %cl,%eax
  8021b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021bc:	89 f1                	mov    %esi,%ecx
  8021be:	d3 e8                	shr    %cl,%eax
  8021c0:	09 d0                	or     %edx,%eax
  8021c2:	d3 eb                	shr    %cl,%ebx
  8021c4:	89 da                	mov    %ebx,%edx
  8021c6:	f7 f7                	div    %edi
  8021c8:	89 d3                	mov    %edx,%ebx
  8021ca:	f7 24 24             	mull   (%esp)
  8021cd:	89 c6                	mov    %eax,%esi
  8021cf:	89 d1                	mov    %edx,%ecx
  8021d1:	39 d3                	cmp    %edx,%ebx
  8021d3:	0f 82 87 00 00 00    	jb     802260 <__umoddi3+0x134>
  8021d9:	0f 84 91 00 00 00    	je     802270 <__umoddi3+0x144>
  8021df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021e3:	29 f2                	sub    %esi,%edx
  8021e5:	19 cb                	sbb    %ecx,%ebx
  8021e7:	89 d8                	mov    %ebx,%eax
  8021e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8021ed:	d3 e0                	shl    %cl,%eax
  8021ef:	89 e9                	mov    %ebp,%ecx
  8021f1:	d3 ea                	shr    %cl,%edx
  8021f3:	09 d0                	or     %edx,%eax
  8021f5:	89 e9                	mov    %ebp,%ecx
  8021f7:	d3 eb                	shr    %cl,%ebx
  8021f9:	89 da                	mov    %ebx,%edx
  8021fb:	83 c4 1c             	add    $0x1c,%esp
  8021fe:	5b                   	pop    %ebx
  8021ff:	5e                   	pop    %esi
  802200:	5f                   	pop    %edi
  802201:	5d                   	pop    %ebp
  802202:	c3                   	ret    
  802203:	90                   	nop
  802204:	89 fd                	mov    %edi,%ebp
  802206:	85 ff                	test   %edi,%edi
  802208:	75 0b                	jne    802215 <__umoddi3+0xe9>
  80220a:	b8 01 00 00 00       	mov    $0x1,%eax
  80220f:	31 d2                	xor    %edx,%edx
  802211:	f7 f7                	div    %edi
  802213:	89 c5                	mov    %eax,%ebp
  802215:	89 f0                	mov    %esi,%eax
  802217:	31 d2                	xor    %edx,%edx
  802219:	f7 f5                	div    %ebp
  80221b:	89 c8                	mov    %ecx,%eax
  80221d:	f7 f5                	div    %ebp
  80221f:	89 d0                	mov    %edx,%eax
  802221:	e9 44 ff ff ff       	jmp    80216a <__umoddi3+0x3e>
  802226:	66 90                	xchg   %ax,%ax
  802228:	89 c8                	mov    %ecx,%eax
  80222a:	89 f2                	mov    %esi,%edx
  80222c:	83 c4 1c             	add    $0x1c,%esp
  80222f:	5b                   	pop    %ebx
  802230:	5e                   	pop    %esi
  802231:	5f                   	pop    %edi
  802232:	5d                   	pop    %ebp
  802233:	c3                   	ret    
  802234:	3b 04 24             	cmp    (%esp),%eax
  802237:	72 06                	jb     80223f <__umoddi3+0x113>
  802239:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80223d:	77 0f                	ja     80224e <__umoddi3+0x122>
  80223f:	89 f2                	mov    %esi,%edx
  802241:	29 f9                	sub    %edi,%ecx
  802243:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802247:	89 14 24             	mov    %edx,(%esp)
  80224a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80224e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802252:	8b 14 24             	mov    (%esp),%edx
  802255:	83 c4 1c             	add    $0x1c,%esp
  802258:	5b                   	pop    %ebx
  802259:	5e                   	pop    %esi
  80225a:	5f                   	pop    %edi
  80225b:	5d                   	pop    %ebp
  80225c:	c3                   	ret    
  80225d:	8d 76 00             	lea    0x0(%esi),%esi
  802260:	2b 04 24             	sub    (%esp),%eax
  802263:	19 fa                	sbb    %edi,%edx
  802265:	89 d1                	mov    %edx,%ecx
  802267:	89 c6                	mov    %eax,%esi
  802269:	e9 71 ff ff ff       	jmp    8021df <__umoddi3+0xb3>
  80226e:	66 90                	xchg   %ax,%ax
  802270:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802274:	72 ea                	jb     802260 <__umoddi3+0x134>
  802276:	89 d9                	mov    %ebx,%ecx
  802278:	e9 62 ff ff ff       	jmp    8021df <__umoddi3+0xb3>
