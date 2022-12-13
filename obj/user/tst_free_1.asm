
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 b8 17 00 00       	call   8017ee <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 90 01 00 00    	sub    $0x190,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 29                	jmp    800079 <_main+0x41>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 60 80 00       	mov    0x806020,%eax
  800055:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	01 c0                	add    %eax,%eax
  800062:	01 d0                	add    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	01 c8                	add    %ecx,%eax
  800069:	8a 40 04             	mov    0x4(%eax),%al
  80006c:	84 c0                	test   %al,%al
  80006e:	74 06                	je     800076 <_main+0x3e>
			{
				fullWS = 0;
  800070:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800074:	eb 12                	jmp    800088 <_main+0x50>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800076:	ff 45 f0             	incl   -0x10(%ebp)
  800079:	a1 20 60 80 00       	mov    0x806020,%eax
  80007e:	8b 50 74             	mov    0x74(%eax),%edx
  800081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800084:	39 c2                	cmp    %eax,%edx
  800086:	77 c8                	ja     800050 <_main+0x18>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800088:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008c:	74 14                	je     8000a2 <_main+0x6a>
  80008e:	83 ec 04             	sub    $0x4,%esp
  800091:	68 80 4c 80 00       	push   $0x804c80
  800096:	6a 1a                	push   $0x1a
  800098:	68 9c 4c 80 00       	push   $0x804c9c
  80009d:	e8 88 18 00 00       	call   80192a <_panic>





	int Mega = 1024*1024;
  8000a2:	c7 45 e0 00 00 10 00 	movl   $0x100000,-0x20(%ebp)
	int kilo = 1024;
  8000a9:	c7 45 dc 00 04 00 00 	movl   $0x400,-0x24(%ebp)
	char minByte = 1<<7;
  8000b0:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
	char maxByte = 0x7F;
  8000b4:	c6 45 da 7f          	movb   $0x7f,-0x26(%ebp)
	short minShort = 1<<15 ;
  8000b8:	66 c7 45 d8 00 80    	movw   $0x8000,-0x28(%ebp)
	short maxShort = 0x7FFF;
  8000be:	66 c7 45 d6 ff 7f    	movw   $0x7fff,-0x2a(%ebp)
	int minInt = 1<<31 ;
  8000c4:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000cb:	c7 45 cc ff ff ff 7f 	movl   $0x7fffffff,-0x34(%ebp)
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	e8 8a 2a 00 00       	call   802b66 <malloc>
  8000dc:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 57 2d 00 00       	call   802e3b <sys_calculate_free_frames>
  8000e4:	89 45 c8             	mov    %eax,-0x38(%ebp)

	void* ptr_allocations[20] = {0};
  8000e7:	8d 95 68 fe ff ff    	lea    -0x198(%ebp),%edx
  8000ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fb:	e8 db 2d 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  800100:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 52 2a 00 00       	call   802b66 <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 85 68 fe ff ff    	mov    %eax,-0x198(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0d                	jns    800134 <_main+0xfc>
  800127:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  80012d:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800132:	76 14                	jbe    800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 b0 4c 80 00       	push   $0x804cb0
  80013c:	6a 3a                	push   $0x3a
  80013e:	68 9c 4c 80 00       	push   $0x804c9c
  800143:	e8 e2 17 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 8e 2d 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 18 4d 80 00       	push   $0x804d18
  80015a:	6a 3b                	push   $0x3b
  80015c:	68 9c 4c 80 00       	push   $0x804c9c
  800161:	e8 c4 17 00 00       	call   80192a <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 d0 2c 00 00       	call   802e3b <sys_calculate_free_frames>
  80016b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80016e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800171:	01 c0                	add    %eax,%eax
  800173:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017a:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800180:	89 45 b8             	mov    %eax,-0x48(%ebp)
		byteArr[0] = minByte ;
  800183:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800186:	8a 55 db             	mov    -0x25(%ebp),%dl
  800189:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80018b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800191:	01 c2                	add    %eax,%edx
  800193:	8a 45 da             	mov    -0x26(%ebp),%al
  800196:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800198:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80019b:	e8 9b 2c 00 00       	call   802e3b <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 48 4d 80 00       	push   $0x804d48
  8001b1:	6a 42                	push   $0x42
  8001b3:	68 9c 4c 80 00       	push   $0x804c9c
  8001b8:	e8 6d 17 00 00       	call   80192a <_panic>
		int var;
		int found = 0;
  8001bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cb:	e9 82 00 00 00       	jmp    800252 <_main+0x21a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d0:	a1 20 60 80 00       	mov    0x806020,%eax
  8001d5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001de:	89 d0                	mov    %edx,%eax
  8001e0:	01 c0                	add    %eax,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	c1 e0 03             	shl    $0x3,%eax
  8001e7:	01 c8                	add    %ecx,%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001fb:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8001fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800201:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800206:	39 c2                	cmp    %eax,%edx
  800208:	75 03                	jne    80020d <_main+0x1d5>
				found++;
  80020a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  80020d:	a1 20 60 80 00       	mov    0x806020,%eax
  800212:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800218:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80021b:	89 d0                	mov    %edx,%eax
  80021d:	01 c0                	add    %eax,%eax
  80021f:	01 d0                	add    %edx,%eax
  800221:	c1 e0 03             	shl    $0x3,%eax
  800224:	01 c8                	add    %ecx,%eax
  800226:	8b 00                	mov    (%eax),%eax
  800228:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80022b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80022e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800233:	89 c1                	mov    %eax,%ecx
  800235:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800238:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023b:	01 d0                	add    %edx,%eax
  80023d:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800240:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800243:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800248:	39 c1                	cmp    %eax,%ecx
  80024a:	75 03                	jne    80024f <_main+0x217>
				found++;
  80024c:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr[0] = minByte ;
		byteArr[lastIndexOfByte] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int var;
		int found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80024f:	ff 45 ec             	incl   -0x14(%ebp)
  800252:	a1 20 60 80 00       	mov    0x806020,%eax
  800257:	8b 50 74             	mov    0x74(%eax),%edx
  80025a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025d:	39 c2                	cmp    %eax,%edx
  80025f:	0f 87 6b ff ff ff    	ja     8001d0 <_main+0x198>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800265:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800269:	74 14                	je     80027f <_main+0x247>
  80026b:	83 ec 04             	sub    $0x4,%esp
  80026e:	68 8c 4d 80 00       	push   $0x804d8c
  800273:	6a 4c                	push   $0x4c
  800275:	68 9c 4c 80 00       	push   $0x804c9c
  80027a:	e8 ab 16 00 00       	call   80192a <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 57 2c 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  800284:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800287:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 ce 28 00 00       	call   802b66 <malloc>
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	89 85 6c fe ff ff    	mov    %eax,-0x194(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a1:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  8002a7:	89 c2                	mov    %eax,%edx
  8002a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ac:	01 c0                	add    %eax,%eax
  8002ae:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	72 16                	jb     8002cd <_main+0x295>
  8002b7:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  8002bd:	89 c2                	mov    %eax,%edx
  8002bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002c9:	39 c2                	cmp    %eax,%edx
  8002cb:	76 14                	jbe    8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 b0 4c 80 00       	push   $0x804cb0
  8002d5:	6a 51                	push   $0x51
  8002d7:	68 9c 4c 80 00       	push   $0x804c9c
  8002dc:	e8 49 16 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 f5 2b 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 18 4d 80 00       	push   $0x804d18
  8002f3:	6a 52                	push   $0x52
  8002f5:	68 9c 4c 80 00       	push   $0x804c9c
  8002fa:	e8 2b 16 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 37 2b 00 00       	call   802e3b <sys_calculate_free_frames>
  800304:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800307:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  80030d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800310:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800318:	d1 e8                	shr    %eax
  80031a:	48                   	dec    %eax
  80031b:	89 45 a0             	mov    %eax,-0x60(%ebp)
		shortArr[0] = minShort;
  80031e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800321:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800324:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800327:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032a:	01 c0                	add    %eax,%eax
  80032c:	89 c2                	mov    %eax,%edx
  80032e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800331:	01 c2                	add    %eax,%edx
  800333:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800337:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80033a:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80033d:	e8 f9 2a 00 00       	call   802e3b <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 48 4d 80 00       	push   $0x804d48
  800353:	6a 59                	push   $0x59
  800355:	68 9c 4c 80 00       	push   $0x804c9c
  80035a:	e8 cb 15 00 00       	call   80192a <_panic>
		found = 0;
  80035f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800366:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80036d:	e9 86 00 00 00       	jmp    8003f8 <_main+0x3c0>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800372:	a1 20 60 80 00       	mov    0x806020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800390:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
  80039a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80039d:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003a0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a8:	39 c2                	cmp    %eax,%edx
  8003aa:	75 03                	jne    8003af <_main+0x377>
				found++;
  8003ac:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003af:	a1 20 60 80 00       	mov    0x806020,%eax
  8003b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	01 c0                	add    %eax,%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 03             	shl    $0x3,%eax
  8003c6:	01 c8                	add    %ecx,%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003cd:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d5:	89 c2                	mov    %eax,%edx
  8003d7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003da:	01 c0                	add    %eax,%eax
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003e1:	01 c8                	add    %ecx,%eax
  8003e3:	89 45 90             	mov    %eax,-0x70(%ebp)
  8003e6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ee:	39 c2                	cmp    %eax,%edx
  8003f0:	75 03                	jne    8003f5 <_main+0x3bd>
				found++;
  8003f2:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8003f5:	ff 45 ec             	incl   -0x14(%ebp)
  8003f8:	a1 20 60 80 00       	mov    0x806020,%eax
  8003fd:	8b 50 74             	mov    0x74(%eax),%edx
  800400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800403:	39 c2                	cmp    %eax,%edx
  800405:	0f 87 67 ff ff ff    	ja     800372 <_main+0x33a>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80040b:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  80040f:	74 14                	je     800425 <_main+0x3ed>
  800411:	83 ec 04             	sub    $0x4,%esp
  800414:	68 8c 4d 80 00       	push   $0x804d8c
  800419:	6a 62                	push   $0x62
  80041b:	68 9c 4c 80 00       	push   $0x804c9c
  800420:	e8 05 15 00 00       	call   80192a <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 b1 2a 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  80042a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  80042d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800430:	01 c0                	add    %eax,%eax
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	50                   	push   %eax
  800436:	e8 2b 27 00 00       	call   802b66 <malloc>
  80043b:	83 c4 10             	add    $0x10,%esp
  80043e:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800444:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80044a:	89 c2                	mov    %eax,%edx
  80044c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044f:	c1 e0 02             	shl    $0x2,%eax
  800452:	05 00 00 00 80       	add    $0x80000000,%eax
  800457:	39 c2                	cmp    %eax,%edx
  800459:	72 17                	jb     800472 <_main+0x43a>
  80045b:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  800461:	89 c2                	mov    %eax,%edx
  800463:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800466:	c1 e0 02             	shl    $0x2,%eax
  800469:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80046e:	39 c2                	cmp    %eax,%edx
  800470:	76 14                	jbe    800486 <_main+0x44e>
  800472:	83 ec 04             	sub    $0x4,%esp
  800475:	68 b0 4c 80 00       	push   $0x804cb0
  80047a:	6a 67                	push   $0x67
  80047c:	68 9c 4c 80 00       	push   $0x804c9c
  800481:	e8 a4 14 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800486:	e8 50 2a 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  80048b:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80048e:	74 14                	je     8004a4 <_main+0x46c>
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 18 4d 80 00       	push   $0x804d18
  800498:	6a 68                	push   $0x68
  80049a:	68 9c 4c 80 00       	push   $0x804c9c
  80049f:	e8 86 14 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a4:	e8 92 29 00 00       	call   802e3b <sys_calculate_free_frames>
  8004a9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004ac:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  8004b2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b8:	01 c0                	add    %eax,%eax
  8004ba:	c1 e8 02             	shr    $0x2,%eax
  8004bd:	48                   	dec    %eax
  8004be:	89 45 88             	mov    %eax,-0x78(%ebp)
		intArr[0] = minInt;
  8004c1:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004c4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004c7:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004c9:	8b 45 88             	mov    -0x78(%ebp),%eax
  8004cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d6:	01 c2                	add    %eax,%edx
  8004d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004db:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004dd:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004e0:	e8 56 29 00 00       	call   802e3b <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	83 f8 02             	cmp    $0x2,%eax
  8004ec:	74 14                	je     800502 <_main+0x4ca>
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	68 48 4d 80 00       	push   $0x804d48
  8004f6:	6a 6f                	push   $0x6f
  8004f8:	68 9c 4c 80 00       	push   $0x804c9c
  8004fd:	e8 28 14 00 00       	call   80192a <_panic>
		found = 0;
  800502:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800509:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800510:	e9 95 00 00 00       	jmp    8005aa <_main+0x572>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800515:	a1 20 60 80 00       	mov    0x806020,%eax
  80051a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800520:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800523:	89 d0                	mov    %edx,%eax
  800525:	01 c0                	add    %eax,%eax
  800527:	01 d0                	add    %edx,%eax
  800529:	c1 e0 03             	shl    $0x3,%eax
  80052c:	01 c8                	add    %ecx,%eax
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800533:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800536:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80053b:	89 c2                	mov    %eax,%edx
  80053d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800540:	89 45 80             	mov    %eax,-0x80(%ebp)
  800543:	8b 45 80             	mov    -0x80(%ebp),%eax
  800546:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054b:	39 c2                	cmp    %eax,%edx
  80054d:	75 03                	jne    800552 <_main+0x51a>
				found++;
  80054f:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800552:	a1 20 60 80 00       	mov    0x806020,%eax
  800557:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	01 c0                	add    %eax,%eax
  800564:	01 d0                	add    %edx,%eax
  800566:	c1 e0 03             	shl    $0x3,%eax
  800569:	01 c8                	add    %ecx,%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800573:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800579:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057e:	89 c2                	mov    %eax,%edx
  800580:	8b 45 88             	mov    -0x78(%ebp),%eax
  800583:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80058a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80058d:	01 c8                	add    %ecx,%eax
  80058f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800595:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80059b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005a0:	39 c2                	cmp    %eax,%edx
  8005a2:	75 03                	jne    8005a7 <_main+0x56f>
				found++;
  8005a4:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005a7:	ff 45 ec             	incl   -0x14(%ebp)
  8005aa:	a1 20 60 80 00       	mov    0x806020,%eax
  8005af:	8b 50 74             	mov    0x74(%eax),%edx
  8005b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005b5:	39 c2                	cmp    %eax,%edx
  8005b7:	0f 87 58 ff ff ff    	ja     800515 <_main+0x4dd>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005bd:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005c1:	74 14                	je     8005d7 <_main+0x59f>
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	68 8c 4d 80 00       	push   $0x804d8c
  8005cb:	6a 78                	push   $0x78
  8005cd:	68 9c 4c 80 00       	push   $0x804c9c
  8005d2:	e8 53 13 00 00       	call   80192a <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d7:	e8 5f 28 00 00       	call   802e3b <sys_calculate_free_frames>
  8005dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005df:	e8 f7 28 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  8005e4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8005e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ea:	01 c0                	add    %eax,%eax
  8005ec:	83 ec 0c             	sub    $0xc,%esp
  8005ef:	50                   	push   %eax
  8005f0:	e8 71 25 00 00       	call   802b66 <malloc>
  8005f5:	83 c4 10             	add    $0x10,%esp
  8005f8:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8005fe:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  800604:	89 c2                	mov    %eax,%edx
  800606:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800609:	c1 e0 02             	shl    $0x2,%eax
  80060c:	89 c1                	mov    %eax,%ecx
  80060e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800611:	c1 e0 02             	shl    $0x2,%eax
  800614:	01 c8                	add    %ecx,%eax
  800616:	05 00 00 00 80       	add    $0x80000000,%eax
  80061b:	39 c2                	cmp    %eax,%edx
  80061d:	72 21                	jb     800640 <_main+0x608>
  80061f:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  800625:	89 c2                	mov    %eax,%edx
  800627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80062a:	c1 e0 02             	shl    $0x2,%eax
  80062d:	89 c1                	mov    %eax,%ecx
  80062f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800632:	c1 e0 02             	shl    $0x2,%eax
  800635:	01 c8                	add    %ecx,%eax
  800637:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80063c:	39 c2                	cmp    %eax,%edx
  80063e:	76 14                	jbe    800654 <_main+0x61c>
  800640:	83 ec 04             	sub    $0x4,%esp
  800643:	68 b0 4c 80 00       	push   $0x804cb0
  800648:	6a 7e                	push   $0x7e
  80064a:	68 9c 4c 80 00       	push   $0x804c9c
  80064f:	e8 d6 12 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800654:	e8 82 28 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  800659:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80065c:	74 14                	je     800672 <_main+0x63a>
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	68 18 4d 80 00       	push   $0x804d18
  800666:	6a 7f                	push   $0x7f
  800668:	68 9c 4c 80 00       	push   $0x804c9c
  80066d:	e8 b8 12 00 00       	call   80192a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800672:	e8 64 28 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  800677:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80067a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80067d:	89 d0                	mov    %edx,%eax
  80067f:	01 c0                	add    %eax,%eax
  800681:	01 d0                	add    %edx,%eax
  800683:	01 c0                	add    %eax,%eax
  800685:	01 d0                	add    %edx,%eax
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	50                   	push   %eax
  80068b:	e8 d6 24 00 00       	call   802b66 <malloc>
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800699:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  80069f:	89 c2                	mov    %eax,%edx
  8006a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a4:	c1 e0 02             	shl    $0x2,%eax
  8006a7:	89 c1                	mov    %eax,%ecx
  8006a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006ac:	c1 e0 03             	shl    $0x3,%eax
  8006af:	01 c8                	add    %ecx,%eax
  8006b1:	05 00 00 00 80       	add    $0x80000000,%eax
  8006b6:	39 c2                	cmp    %eax,%edx
  8006b8:	72 21                	jb     8006db <_main+0x6a3>
  8006ba:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8006c0:	89 c2                	mov    %eax,%edx
  8006c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c5:	c1 e0 02             	shl    $0x2,%eax
  8006c8:	89 c1                	mov    %eax,%ecx
  8006ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006cd:	c1 e0 03             	shl    $0x3,%eax
  8006d0:	01 c8                	add    %ecx,%eax
  8006d2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006d7:	39 c2                	cmp    %eax,%edx
  8006d9:	76 17                	jbe    8006f2 <_main+0x6ba>
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	68 b0 4c 80 00       	push   $0x804cb0
  8006e3:	68 85 00 00 00       	push   $0x85
  8006e8:	68 9c 4c 80 00       	push   $0x804c9c
  8006ed:	e8 38 12 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f2:	e8 e4 27 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  8006f7:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8006fa:	74 17                	je     800713 <_main+0x6db>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 18 4d 80 00       	push   $0x804d18
  800704:	68 86 00 00 00       	push   $0x86
  800709:	68 9c 4c 80 00       	push   $0x804c9c
  80070e:	e8 17 12 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800713:	e8 23 27 00 00       	call   802e3b <sys_calculate_free_frames>
  800718:	89 45 c0             	mov    %eax,-0x40(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  80071b:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  800721:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800727:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80072a:	89 d0                	mov    %edx,%eax
  80072c:	01 c0                	add    %eax,%eax
  80072e:	01 d0                	add    %edx,%eax
  800730:	01 c0                	add    %eax,%eax
  800732:	01 d0                	add    %edx,%eax
  800734:	c1 e8 03             	shr    $0x3,%eax
  800737:	48                   	dec    %eax
  800738:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80073e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800744:	8a 55 db             	mov    -0x25(%ebp),%dl
  800747:	88 10                	mov    %dl,(%eax)
  800749:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  80074f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800752:	66 89 42 02          	mov    %ax,0x2(%edx)
  800756:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80075c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80075f:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800762:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800768:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80076f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800775:	01 c2                	add    %eax,%edx
  800777:	8a 45 da             	mov    -0x26(%ebp),%al
  80077a:	88 02                	mov    %al,(%edx)
  80077c:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800782:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800789:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80078f:	01 c2                	add    %eax,%edx
  800791:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800795:	66 89 42 02          	mov    %ax,0x2(%edx)
  800799:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80079f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007a6:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007ac:	01 c2                	add    %eax,%edx
  8007ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007b1:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007b4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8007b7:	e8 7f 26 00 00       	call   802e3b <sys_calculate_free_frames>
  8007bc:	29 c3                	sub    %eax,%ebx
  8007be:	89 d8                	mov    %ebx,%eax
  8007c0:	83 f8 02             	cmp    $0x2,%eax
  8007c3:	74 17                	je     8007dc <_main+0x7a4>
  8007c5:	83 ec 04             	sub    $0x4,%esp
  8007c8:	68 48 4d 80 00       	push   $0x804d48
  8007cd:	68 8d 00 00 00       	push   $0x8d
  8007d2:	68 9c 4c 80 00       	push   $0x804c9c
  8007d7:	e8 4e 11 00 00       	call   80192a <_panic>
		found = 0;
  8007dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007ea:	e9 aa 00 00 00       	jmp    800899 <_main+0x861>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007ef:	a1 20 60 80 00       	mov    0x806020,%eax
  8007f4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007fd:	89 d0                	mov    %edx,%eax
  8007ff:	01 c0                	add    %eax,%eax
  800801:	01 d0                	add    %edx,%eax
  800803:	c1 e0 03             	shl    $0x3,%eax
  800806:	01 c8                	add    %ecx,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800810:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800816:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80081b:	89 c2                	mov    %eax,%edx
  80081d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800823:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800829:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80082f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800834:	39 c2                	cmp    %eax,%edx
  800836:	75 03                	jne    80083b <_main+0x803>
				found++;
  800838:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80083b:	a1 20 60 80 00       	mov    0x806020,%eax
  800840:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800846:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800849:	89 d0                	mov    %edx,%eax
  80084b:	01 c0                	add    %eax,%eax
  80084d:	01 d0                	add    %edx,%eax
  80084f:	c1 e0 03             	shl    $0x3,%eax
  800852:	01 c8                	add    %ecx,%eax
  800854:	8b 00                	mov    (%eax),%eax
  800856:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80085c:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800862:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800867:	89 c2                	mov    %eax,%edx
  800869:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80086f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800876:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80087c:	01 c8                	add    %ecx,%eax
  80087e:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800884:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80088a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80088f:	39 c2                	cmp    %eax,%edx
  800891:	75 03                	jne    800896 <_main+0x85e>
				found++;
  800893:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800896:	ff 45 ec             	incl   -0x14(%ebp)
  800899:	a1 20 60 80 00       	mov    0x806020,%eax
  80089e:	8b 50 74             	mov    0x74(%eax),%edx
  8008a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	0f 87 43 ff ff ff    	ja     8007ef <_main+0x7b7>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008ac:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 8c 4d 80 00       	push   $0x804d8c
  8008ba:	68 96 00 00 00       	push   $0x96
  8008bf:	68 9c 4c 80 00       	push   $0x804c9c
  8008c4:	e8 61 10 00 00       	call   80192a <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 6d 25 00 00       	call   802e3b <sys_calculate_free_frames>
  8008ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d1:	e8 05 26 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  8008d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008dc:	89 c2                	mov    %eax,%edx
  8008de:	01 d2                	add    %edx,%edx
  8008e0:	01 d0                	add    %edx,%eax
  8008e2:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008e5:	83 ec 0c             	sub    $0xc,%esp
  8008e8:	50                   	push   %eax
  8008e9:	e8 78 22 00 00       	call   802b66 <malloc>
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8008f7:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  8008fd:	89 c2                	mov    %eax,%edx
  8008ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800902:	c1 e0 02             	shl    $0x2,%eax
  800905:	89 c1                	mov    %eax,%ecx
  800907:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80090a:	c1 e0 04             	shl    $0x4,%eax
  80090d:	01 c8                	add    %ecx,%eax
  80090f:	05 00 00 00 80       	add    $0x80000000,%eax
  800914:	39 c2                	cmp    %eax,%edx
  800916:	72 21                	jb     800939 <_main+0x901>
  800918:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  80091e:	89 c2                	mov    %eax,%edx
  800920:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800923:	c1 e0 02             	shl    $0x2,%eax
  800926:	89 c1                	mov    %eax,%ecx
  800928:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80092b:	c1 e0 04             	shl    $0x4,%eax
  80092e:	01 c8                	add    %ecx,%eax
  800930:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800935:	39 c2                	cmp    %eax,%edx
  800937:	76 17                	jbe    800950 <_main+0x918>
  800939:	83 ec 04             	sub    $0x4,%esp
  80093c:	68 b0 4c 80 00       	push   $0x804cb0
  800941:	68 9c 00 00 00       	push   $0x9c
  800946:	68 9c 4c 80 00       	push   $0x804c9c
  80094b:	e8 da 0f 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800950:	e8 86 25 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  800955:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800958:	74 17                	je     800971 <_main+0x939>
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 18 4d 80 00       	push   $0x804d18
  800962:	68 9d 00 00 00       	push   $0x9d
  800967:	68 9c 4c 80 00       	push   $0x804c9c
  80096c:	e8 b9 0f 00 00       	call   80192a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800971:	e8 65 25 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  800976:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  800979:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80097c:	89 d0                	mov    %edx,%eax
  80097e:	01 c0                	add    %eax,%eax
  800980:	01 d0                	add    %edx,%eax
  800982:	01 c0                	add    %eax,%eax
  800984:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800987:	83 ec 0c             	sub    $0xc,%esp
  80098a:	50                   	push   %eax
  80098b:	e8 d6 21 00 00       	call   802b66 <malloc>
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800999:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  80099f:	89 c1                	mov    %eax,%ecx
  8009a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	01 c0                	add    %eax,%eax
  8009a8:	01 d0                	add    %edx,%eax
  8009aa:	01 c0                	add    %eax,%eax
  8009ac:	01 d0                	add    %edx,%eax
  8009ae:	89 c2                	mov    %eax,%edx
  8009b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b3:	c1 e0 04             	shl    $0x4,%eax
  8009b6:	01 d0                	add    %edx,%eax
  8009b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8009bd:	39 c1                	cmp    %eax,%ecx
  8009bf:	72 28                	jb     8009e9 <_main+0x9b1>
  8009c1:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8009c7:	89 c1                	mov    %eax,%ecx
  8009c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009cc:	89 d0                	mov    %edx,%eax
  8009ce:	01 c0                	add    %eax,%eax
  8009d0:	01 d0                	add    %edx,%eax
  8009d2:	01 c0                	add    %eax,%eax
  8009d4:	01 d0                	add    %edx,%eax
  8009d6:	89 c2                	mov    %eax,%edx
  8009d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009db:	c1 e0 04             	shl    $0x4,%eax
  8009de:	01 d0                	add    %edx,%eax
  8009e0:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009e5:	39 c1                	cmp    %eax,%ecx
  8009e7:	76 17                	jbe    800a00 <_main+0x9c8>
  8009e9:	83 ec 04             	sub    $0x4,%esp
  8009ec:	68 b0 4c 80 00       	push   $0x804cb0
  8009f1:	68 a3 00 00 00       	push   $0xa3
  8009f6:	68 9c 4c 80 00       	push   $0x804c9c
  8009fb:	e8 2a 0f 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a00:	e8 d6 24 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  800a05:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800a08:	74 17                	je     800a21 <_main+0x9e9>
  800a0a:	83 ec 04             	sub    $0x4,%esp
  800a0d:	68 18 4d 80 00       	push   $0x804d18
  800a12:	68 a4 00 00 00       	push   $0xa4
  800a17:	68 9c 4c 80 00       	push   $0x804c9c
  800a1c:	e8 09 0f 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a21:	e8 15 24 00 00       	call   802e3b <sys_calculate_free_frames>
  800a26:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a2c:	89 d0                	mov    %edx,%eax
  800a2e:	01 c0                	add    %eax,%eax
  800a30:	01 d0                	add    %edx,%eax
  800a32:	01 c0                	add    %eax,%eax
  800a34:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800a37:	48                   	dec    %eax
  800a38:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a3e:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800a44:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		byteArr2[0] = minByte ;
  800a4a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a50:	8a 55 db             	mov    -0x25(%ebp),%dl
  800a53:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a55:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a5b:	89 c2                	mov    %eax,%edx
  800a5d:	c1 ea 1f             	shr    $0x1f,%edx
  800a60:	01 d0                	add    %edx,%eax
  800a62:	d1 f8                	sar    %eax
  800a64:	89 c2                	mov    %eax,%edx
  800a66:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a6c:	01 c2                	add    %eax,%edx
  800a6e:	8a 45 da             	mov    -0x26(%ebp),%al
  800a71:	88 c1                	mov    %al,%cl
  800a73:	c0 e9 07             	shr    $0x7,%cl
  800a76:	01 c8                	add    %ecx,%eax
  800a78:	d0 f8                	sar    %al
  800a7a:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a7c:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800a82:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a88:	01 c2                	add    %eax,%edx
  800a8a:	8a 45 da             	mov    -0x26(%ebp),%al
  800a8d:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a8f:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800a92:	e8 a4 23 00 00       	call   802e3b <sys_calculate_free_frames>
  800a97:	29 c3                	sub    %eax,%ebx
  800a99:	89 d8                	mov    %ebx,%eax
  800a9b:	83 f8 05             	cmp    $0x5,%eax
  800a9e:	74 17                	je     800ab7 <_main+0xa7f>
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 48 4d 80 00       	push   $0x804d48
  800aa8:	68 ac 00 00 00       	push   $0xac
  800aad:	68 9c 4c 80 00       	push   $0x804c9c
  800ab2:	e8 73 0e 00 00       	call   80192a <_panic>
		found = 0;
  800ab7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800abe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ac5:	e9 02 01 00 00       	jmp    800bcc <_main+0xb94>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800aca:	a1 20 60 80 00       	mov    0x806020,%eax
  800acf:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ad8:	89 d0                	mov    %edx,%eax
  800ada:	01 c0                	add    %eax,%eax
  800adc:	01 d0                	add    %edx,%eax
  800ade:	c1 e0 03             	shl    $0x3,%eax
  800ae1:	01 c8                	add    %ecx,%eax
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800aeb:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800af1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af6:	89 c2                	mov    %eax,%edx
  800af8:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800afe:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b04:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b0a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b0f:	39 c2                	cmp    %eax,%edx
  800b11:	75 03                	jne    800b16 <_main+0xade>
				found++;
  800b13:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b16:	a1 20 60 80 00       	mov    0x806020,%eax
  800b1b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b21:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b24:	89 d0                	mov    %edx,%eax
  800b26:	01 c0                	add    %eax,%eax
  800b28:	01 d0                	add    %edx,%eax
  800b2a:	c1 e0 03             	shl    $0x3,%eax
  800b2d:	01 c8                	add    %ecx,%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b37:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b42:	89 c2                	mov    %eax,%edx
  800b44:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b4a:	89 c1                	mov    %eax,%ecx
  800b4c:	c1 e9 1f             	shr    $0x1f,%ecx
  800b4f:	01 c8                	add    %ecx,%eax
  800b51:	d1 f8                	sar    %eax
  800b53:	89 c1                	mov    %eax,%ecx
  800b55:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b5b:	01 c8                	add    %ecx,%eax
  800b5d:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b63:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b69:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b6e:	39 c2                	cmp    %eax,%edx
  800b70:	75 03                	jne    800b75 <_main+0xb3d>
				found++;
  800b72:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b75:	a1 20 60 80 00       	mov    0x806020,%eax
  800b7a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b80:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b83:	89 d0                	mov    %edx,%eax
  800b85:	01 c0                	add    %eax,%eax
  800b87:	01 d0                	add    %edx,%eax
  800b89:	c1 e0 03             	shl    $0x3,%eax
  800b8c:	01 c8                	add    %ecx,%eax
  800b8e:	8b 00                	mov    (%eax),%eax
  800b90:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800b96:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800b9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba1:	89 c1                	mov    %eax,%ecx
  800ba3:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800ba9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800baf:	01 d0                	add    %edx,%eax
  800bb1:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800bb7:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800bbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc2:	39 c1                	cmp    %eax,%ecx
  800bc4:	75 03                	jne    800bc9 <_main+0xb91>
				found++;
  800bc6:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bc9:	ff 45 ec             	incl   -0x14(%ebp)
  800bcc:	a1 20 60 80 00       	mov    0x806020,%eax
  800bd1:	8b 50 74             	mov    0x74(%eax),%edx
  800bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd7:	39 c2                	cmp    %eax,%edx
  800bd9:	0f 87 eb fe ff ff    	ja     800aca <_main+0xa92>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800bdf:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800be3:	74 17                	je     800bfc <_main+0xbc4>
  800be5:	83 ec 04             	sub    $0x4,%esp
  800be8:	68 8c 4d 80 00       	push   $0x804d8c
  800bed:	68 b7 00 00 00       	push   $0xb7
  800bf2:	68 9c 4c 80 00       	push   $0x804c9c
  800bf7:	e8 2e 0d 00 00       	call   80192a <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfc:	e8 da 22 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  800c01:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c04:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c07:	89 d0                	mov    %edx,%eax
  800c09:	01 c0                	add    %eax,%eax
  800c0b:	01 d0                	add    %edx,%eax
  800c0d:	01 c0                	add    %eax,%eax
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	01 c0                	add    %eax,%eax
  800c13:	83 ec 0c             	sub    $0xc,%esp
  800c16:	50                   	push   %eax
  800c17:	e8 4a 1f 00 00       	call   802b66 <malloc>
  800c1c:	83 c4 10             	add    $0x10,%esp
  800c1f:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c25:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c2b:	89 c1                	mov    %eax,%ecx
  800c2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c30:	89 d0                	mov    %edx,%eax
  800c32:	01 c0                	add    %eax,%eax
  800c34:	01 d0                	add    %edx,%eax
  800c36:	c1 e0 02             	shl    $0x2,%eax
  800c39:	01 d0                	add    %edx,%eax
  800c3b:	89 c2                	mov    %eax,%edx
  800c3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c40:	c1 e0 04             	shl    $0x4,%eax
  800c43:	01 d0                	add    %edx,%eax
  800c45:	05 00 00 00 80       	add    $0x80000000,%eax
  800c4a:	39 c1                	cmp    %eax,%ecx
  800c4c:	72 29                	jb     800c77 <_main+0xc3f>
  800c4e:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c54:	89 c1                	mov    %eax,%ecx
  800c56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c59:	89 d0                	mov    %edx,%eax
  800c5b:	01 c0                	add    %eax,%eax
  800c5d:	01 d0                	add    %edx,%eax
  800c5f:	c1 e0 02             	shl    $0x2,%eax
  800c62:	01 d0                	add    %edx,%eax
  800c64:	89 c2                	mov    %eax,%edx
  800c66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c69:	c1 e0 04             	shl    $0x4,%eax
  800c6c:	01 d0                	add    %edx,%eax
  800c6e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c73:	39 c1                	cmp    %eax,%ecx
  800c75:	76 17                	jbe    800c8e <_main+0xc56>
  800c77:	83 ec 04             	sub    $0x4,%esp
  800c7a:	68 b0 4c 80 00       	push   $0x804cb0
  800c7f:	68 bc 00 00 00       	push   $0xbc
  800c84:	68 9c 4c 80 00       	push   $0x804c9c
  800c89:	e8 9c 0c 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c8e:	e8 48 22 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  800c93:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800c96:	74 17                	je     800caf <_main+0xc77>
  800c98:	83 ec 04             	sub    $0x4,%esp
  800c9b:	68 18 4d 80 00       	push   $0x804d18
  800ca0:	68 bd 00 00 00       	push   $0xbd
  800ca5:	68 9c 4c 80 00       	push   $0x804c9c
  800caa:	e8 7b 0c 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800caf:	e8 87 21 00 00       	call   802e3b <sys_calculate_free_frames>
  800cb4:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800cb7:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800cbd:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cc3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800cc6:	89 d0                	mov    %edx,%eax
  800cc8:	01 c0                	add    %eax,%eax
  800cca:	01 d0                	add    %edx,%eax
  800ccc:	01 c0                	add    %eax,%eax
  800cce:	01 d0                	add    %edx,%eax
  800cd0:	01 c0                	add    %eax,%eax
  800cd2:	d1 e8                	shr    %eax
  800cd4:	48                   	dec    %eax
  800cd5:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
		shortArr2[0] = minShort;
  800cdb:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800ce1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ce4:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800ce7:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800ced:	01 c0                	add    %eax,%eax
  800cef:	89 c2                	mov    %eax,%edx
  800cf1:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cf7:	01 c2                	add    %eax,%edx
  800cf9:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800cfd:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d00:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800d03:	e8 33 21 00 00       	call   802e3b <sys_calculate_free_frames>
  800d08:	29 c3                	sub    %eax,%ebx
  800d0a:	89 d8                	mov    %ebx,%eax
  800d0c:	83 f8 02             	cmp    $0x2,%eax
  800d0f:	74 17                	je     800d28 <_main+0xcf0>
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	68 48 4d 80 00       	push   $0x804d48
  800d19:	68 c4 00 00 00       	push   $0xc4
  800d1e:	68 9c 4c 80 00       	push   $0x804c9c
  800d23:	e8 02 0c 00 00       	call   80192a <_panic>
		found = 0;
  800d28:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d2f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d36:	e9 a7 00 00 00       	jmp    800de2 <_main+0xdaa>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d3b:	a1 20 60 80 00       	mov    0x806020,%eax
  800d40:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d49:	89 d0                	mov    %edx,%eax
  800d4b:	01 c0                	add    %eax,%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	c1 e0 03             	shl    $0x3,%eax
  800d52:	01 c8                	add    %ecx,%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d5c:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d67:	89 c2                	mov    %eax,%edx
  800d69:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d6f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800d75:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800d7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d80:	39 c2                	cmp    %eax,%edx
  800d82:	75 03                	jne    800d87 <_main+0xd4f>
				found++;
  800d84:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d87:	a1 20 60 80 00       	mov    0x806020,%eax
  800d8c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d95:	89 d0                	mov    %edx,%eax
  800d97:	01 c0                	add    %eax,%eax
  800d99:	01 d0                	add    %edx,%eax
  800d9b:	c1 e0 03             	shl    $0x3,%eax
  800d9e:	01 c8                	add    %ecx,%eax
  800da0:	8b 00                	mov    (%eax),%eax
  800da2:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800da8:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800dae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db3:	89 c2                	mov    %eax,%edx
  800db5:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800dbb:	01 c0                	add    %eax,%eax
  800dbd:	89 c1                	mov    %eax,%ecx
  800dbf:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dc5:	01 c8                	add    %ecx,%eax
  800dc7:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  800dcd:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800dd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dd8:	39 c2                	cmp    %eax,%edx
  800dda:	75 03                	jne    800ddf <_main+0xda7>
				found++;
  800ddc:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ddf:	ff 45 ec             	incl   -0x14(%ebp)
  800de2:	a1 20 60 80 00       	mov    0x806020,%eax
  800de7:	8b 50 74             	mov    0x74(%eax),%edx
  800dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ded:	39 c2                	cmp    %eax,%edx
  800def:	0f 87 46 ff ff ff    	ja     800d3b <_main+0xd03>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800df5:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800df9:	74 17                	je     800e12 <_main+0xdda>
  800dfb:	83 ec 04             	sub    $0x4,%esp
  800dfe:	68 8c 4d 80 00       	push   $0x804d8c
  800e03:	68 cd 00 00 00       	push   $0xcd
  800e08:	68 9c 4c 80 00       	push   $0x804c9c
  800e0d:	e8 18 0b 00 00       	call   80192a <_panic>
	}

	{
		//Free 1st 2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800e12:	e8 24 20 00 00       	call   802e3b <sys_calculate_free_frames>
  800e17:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e1d:	e8 b9 20 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  800e22:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[0]);
  800e28:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	e8 aa 1d 00 00       	call   802be1 <free>
  800e37:	83 c4 10             	add    $0x10,%esp

		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e3a:	e8 9c 20 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  800e3f:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800e45:	74 17                	je     800e5e <_main+0xe26>
  800e47:	83 ec 04             	sub    $0x4,%esp
  800e4a:	68 ac 4d 80 00       	push   $0x804dac
  800e4f:	68 d6 00 00 00       	push   $0xd6
  800e54:	68 9c 4c 80 00       	push   $0x804c9c
  800e59:	e8 cc 0a 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800e5e:	e8 d8 1f 00 00       	call   802e3b <sys_calculate_free_frames>
  800e63:	89 c2                	mov    %eax,%edx
  800e65:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800e6b:	29 c2                	sub    %eax,%edx
  800e6d:	89 d0                	mov    %edx,%eax
  800e6f:	83 f8 02             	cmp    $0x2,%eax
  800e72:	74 17                	je     800e8b <_main+0xe53>
  800e74:	83 ec 04             	sub    $0x4,%esp
  800e77:	68 e8 4d 80 00       	push   $0x804de8
  800e7c:	68 d7 00 00 00       	push   $0xd7
  800e81:	68 9c 4c 80 00       	push   $0x804c9c
  800e86:	e8 9f 0a 00 00       	call   80192a <_panic>
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800e8b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800e92:	e9 c2 00 00 00       	jmp    800f59 <_main+0xf21>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  800e97:	a1 20 60 80 00       	mov    0x806020,%eax
  800e9c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ea2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ea5:	89 d0                	mov    %edx,%eax
  800ea7:	01 c0                	add    %eax,%eax
  800ea9:	01 d0                	add    %edx,%eax
  800eab:	c1 e0 03             	shl    $0x3,%eax
  800eae:	01 c8                	add    %ecx,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  800eb8:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800ebe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ec3:	89 c2                	mov    %eax,%edx
  800ec5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ec8:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  800ece:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800ed4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ed9:	39 c2                	cmp    %eax,%edx
  800edb:	75 17                	jne    800ef4 <_main+0xebc>
				panic("free: page is not removed from WS");
  800edd:	83 ec 04             	sub    $0x4,%esp
  800ee0:	68 34 4e 80 00       	push   $0x804e34
  800ee5:	68 dc 00 00 00       	push   $0xdc
  800eea:	68 9c 4c 80 00       	push   $0x804c9c
  800eef:	e8 36 0a 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  800ef4:	a1 20 60 80 00       	mov    0x806020,%eax
  800ef9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800eff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f02:	89 d0                	mov    %edx,%eax
  800f04:	01 c0                	add    %eax,%eax
  800f06:	01 d0                	add    %edx,%eax
  800f08:	c1 e0 03             	shl    $0x3,%eax
  800f0b:	01 c8                	add    %ecx,%eax
  800f0d:	8b 00                	mov    (%eax),%eax
  800f0f:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  800f15:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800f1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f20:	89 c1                	mov    %eax,%ecx
  800f22:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800f25:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
  800f30:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800f36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f3b:	39 c1                	cmp    %eax,%ecx
  800f3d:	75 17                	jne    800f56 <_main+0xf1e>
				panic("free: page is not removed from WS");
  800f3f:	83 ec 04             	sub    $0x4,%esp
  800f42:	68 34 4e 80 00       	push   $0x804e34
  800f47:	68 de 00 00 00       	push   $0xde
  800f4c:	68 9c 4c 80 00       	push   $0x804c9c
  800f51:	e8 d4 09 00 00       	call   80192a <_panic>
		free(ptr_allocations[0]);

		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800f56:	ff 45 e4             	incl   -0x1c(%ebp)
  800f59:	a1 20 60 80 00       	mov    0x806020,%eax
  800f5e:	8b 50 74             	mov    0x74(%eax),%edx
  800f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f64:	39 c2                	cmp    %eax,%edx
  800f66:	0f 87 2b ff ff ff    	ja     800e97 <_main+0xe5f>
				panic("free: page is not removed from WS");
		}


		//Free 2nd 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800f6c:	e8 ca 1e 00 00       	call   802e3b <sys_calculate_free_frames>
  800f71:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f77:	e8 5f 1f 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  800f7c:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[1]);
  800f82:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800f88:	83 ec 0c             	sub    $0xc,%esp
  800f8b:	50                   	push   %eax
  800f8c:	e8 50 1c 00 00       	call   802be1 <free>
  800f91:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f94:	e8 42 1f 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  800f99:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800f9f:	74 17                	je     800fb8 <_main+0xf80>
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	68 ac 4d 80 00       	push   $0x804dac
  800fa9:	68 e6 00 00 00       	push   $0xe6
  800fae:	68 9c 4c 80 00       	push   $0x804c9c
  800fb3:	e8 72 09 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fb8:	e8 7e 1e 00 00       	call   802e3b <sys_calculate_free_frames>
  800fbd:	89 c2                	mov    %eax,%edx
  800fbf:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800fc5:	29 c2                	sub    %eax,%edx
  800fc7:	89 d0                	mov    %edx,%eax
  800fc9:	83 f8 03             	cmp    $0x3,%eax
  800fcc:	74 17                	je     800fe5 <_main+0xfad>
  800fce:	83 ec 04             	sub    $0x4,%esp
  800fd1:	68 e8 4d 80 00       	push   $0x804de8
  800fd6:	68 e7 00 00 00       	push   $0xe7
  800fdb:	68 9c 4c 80 00       	push   $0x804c9c
  800fe0:	e8 45 09 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800fe5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800fec:	e9 c6 00 00 00       	jmp    8010b7 <_main+0x107f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800ff1:	a1 20 60 80 00       	mov    0x806020,%eax
  800ff6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ffc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fff:	89 d0                	mov    %edx,%eax
  801001:	01 c0                	add    %eax,%eax
  801003:	01 d0                	add    %edx,%eax
  801005:	c1 e0 03             	shl    $0x3,%eax
  801008:	01 c8                	add    %ecx,%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
  801012:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801018:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80101d:	89 c2                	mov    %eax,%edx
  80101f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801022:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  801028:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80102e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801033:	39 c2                	cmp    %eax,%edx
  801035:	75 17                	jne    80104e <_main+0x1016>
				panic("free: page is not removed from WS");
  801037:	83 ec 04             	sub    $0x4,%esp
  80103a:	68 34 4e 80 00       	push   $0x804e34
  80103f:	68 eb 00 00 00       	push   $0xeb
  801044:	68 9c 4c 80 00       	push   $0x804c9c
  801049:	e8 dc 08 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  80104e:	a1 20 60 80 00       	mov    0x806020,%eax
  801053:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801059:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80105c:	89 d0                	mov    %edx,%eax
  80105e:	01 c0                	add    %eax,%eax
  801060:	01 d0                	add    %edx,%eax
  801062:	c1 e0 03             	shl    $0x3,%eax
  801065:	01 c8                	add    %ecx,%eax
  801067:	8b 00                	mov    (%eax),%eax
  801069:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  80106f:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  801075:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80107f:	01 c0                	add    %eax,%eax
  801081:	89 c1                	mov    %eax,%ecx
  801083:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801086:	01 c8                	add    %ecx,%eax
  801088:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  80108e:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  801094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801099:	39 c2                	cmp    %eax,%edx
  80109b:	75 17                	jne    8010b4 <_main+0x107c>
				panic("free: page is not removed from WS");
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	68 34 4e 80 00       	push   $0x804e34
  8010a5:	68 ed 00 00 00       	push   $0xed
  8010aa:	68 9c 4c 80 00       	push   $0x804c9c
  8010af:	e8 76 08 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[1]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8010b4:	ff 45 e4             	incl   -0x1c(%ebp)
  8010b7:	a1 20 60 80 00       	mov    0x806020,%eax
  8010bc:	8b 50 74             	mov    0x74(%eax),%edx
  8010bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010c2:	39 c2                	cmp    %eax,%edx
  8010c4:	0f 87 27 ff ff ff    	ja     800ff1 <_main+0xfb9>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 6 MB
		freeFrames = sys_calculate_free_frames() ;
  8010ca:	e8 6c 1d 00 00       	call   802e3b <sys_calculate_free_frames>
  8010cf:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8010d5:	e8 01 1e 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  8010da:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[6]);
  8010e0:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	50                   	push   %eax
  8010ea:	e8 f2 1a 00 00       	call   802be1 <free>
  8010ef:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8010f2:	e8 e4 1d 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  8010f7:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8010fd:	74 17                	je     801116 <_main+0x10de>
  8010ff:	83 ec 04             	sub    $0x4,%esp
  801102:	68 ac 4d 80 00       	push   $0x804dac
  801107:	68 f4 00 00 00       	push   $0xf4
  80110c:	68 9c 4c 80 00       	push   $0x804c9c
  801111:	e8 14 08 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801116:	e8 20 1d 00 00       	call   802e3b <sys_calculate_free_frames>
  80111b:	89 c2                	mov    %eax,%edx
  80111d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801123:	29 c2                	sub    %eax,%edx
  801125:	89 d0                	mov    %edx,%eax
  801127:	83 f8 04             	cmp    $0x4,%eax
  80112a:	74 17                	je     801143 <_main+0x110b>
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	68 e8 4d 80 00       	push   $0x804de8
  801134:	68 f5 00 00 00       	push   $0xf5
  801139:	68 9c 4c 80 00       	push   $0x804c9c
  80113e:	e8 e7 07 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801143:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80114a:	e9 3e 01 00 00       	jmp    80128d <_main+0x1255>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  80114f:	a1 20 60 80 00       	mov    0x806020,%eax
  801154:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80115a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80115d:	89 d0                	mov    %edx,%eax
  80115f:	01 c0                	add    %eax,%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	c1 e0 03             	shl    $0x3,%eax
  801166:	01 c8                	add    %ecx,%eax
  801168:	8b 00                	mov    (%eax),%eax
  80116a:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  801170:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  801176:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801183:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
  801189:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  80118f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801194:	39 c2                	cmp    %eax,%edx
  801196:	75 17                	jne    8011af <_main+0x1177>
				panic("free: page is not removed from WS");
  801198:	83 ec 04             	sub    $0x4,%esp
  80119b:	68 34 4e 80 00       	push   $0x804e34
  8011a0:	68 f9 00 00 00       	push   $0xf9
  8011a5:	68 9c 4c 80 00       	push   $0x804c9c
  8011aa:	e8 7b 07 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  8011af:	a1 20 60 80 00       	mov    0x806020,%eax
  8011b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8011ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011bd:	89 d0                	mov    %edx,%eax
  8011bf:	01 c0                	add    %eax,%eax
  8011c1:	01 d0                	add    %edx,%eax
  8011c3:	c1 e0 03             	shl    $0x3,%eax
  8011c6:	01 c8                	add    %ecx,%eax
  8011c8:	8b 00                	mov    (%eax),%eax
  8011ca:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  8011d0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011db:	89 c2                	mov    %eax,%edx
  8011dd:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8011e3:	89 c1                	mov    %eax,%ecx
  8011e5:	c1 e9 1f             	shr    $0x1f,%ecx
  8011e8:	01 c8                	add    %ecx,%eax
  8011ea:	d1 f8                	sar    %eax
  8011ec:	89 c1                	mov    %eax,%ecx
  8011ee:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8011f4:	01 c8                	add    %ecx,%eax
  8011f6:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  8011fc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801202:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801207:	39 c2                	cmp    %eax,%edx
  801209:	75 17                	jne    801222 <_main+0x11ea>
				panic("free: page is not removed from WS");
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	68 34 4e 80 00       	push   $0x804e34
  801213:	68 fb 00 00 00       	push   $0xfb
  801218:	68 9c 4c 80 00       	push   $0x804c9c
  80121d:	e8 08 07 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  801222:	a1 20 60 80 00       	mov    0x806020,%eax
  801227:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80122d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801230:	89 d0                	mov    %edx,%eax
  801232:	01 c0                	add    %eax,%eax
  801234:	01 d0                	add    %edx,%eax
  801236:	c1 e0 03             	shl    $0x3,%eax
  801239:	01 c8                	add    %ecx,%eax
  80123b:	8b 00                	mov    (%eax),%eax
  80123d:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  801243:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  801249:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80124e:	89 c1                	mov    %eax,%ecx
  801250:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  801256:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80125c:	01 d0                	add    %edx,%eax
  80125e:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
  801264:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  80126a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80126f:	39 c1                	cmp    %eax,%ecx
  801271:	75 17                	jne    80128a <_main+0x1252>
				panic("free: page is not removed from WS");
  801273:	83 ec 04             	sub    $0x4,%esp
  801276:	68 34 4e 80 00       	push   $0x804e34
  80127b:	68 fd 00 00 00       	push   $0xfd
  801280:	68 9c 4c 80 00       	push   $0x804c9c
  801285:	e8 a0 06 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[6]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80128a:	ff 45 e4             	incl   -0x1c(%ebp)
  80128d:	a1 20 60 80 00       	mov    0x806020,%eax
  801292:	8b 50 74             	mov    0x74(%eax),%edx
  801295:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801298:	39 c2                	cmp    %eax,%edx
  80129a:	0f 87 af fe ff ff    	ja     80114f <_main+0x1117>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 7 KB
		freeFrames = sys_calculate_free_frames() ;
  8012a0:	e8 96 1b 00 00       	call   802e3b <sys_calculate_free_frames>
  8012a5:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012ab:	e8 2b 1c 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  8012b0:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[4]);
  8012b6:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8012bc:	83 ec 0c             	sub    $0xc,%esp
  8012bf:	50                   	push   %eax
  8012c0:	e8 1c 19 00 00       	call   802be1 <free>
  8012c5:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8012c8:	e8 0e 1c 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  8012cd:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8012d3:	74 17                	je     8012ec <_main+0x12b4>
  8012d5:	83 ec 04             	sub    $0x4,%esp
  8012d8:	68 ac 4d 80 00       	push   $0x804dac
  8012dd:	68 04 01 00 00       	push   $0x104
  8012e2:	68 9c 4c 80 00       	push   $0x804c9c
  8012e7:	e8 3e 06 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8012ec:	e8 4a 1b 00 00       	call   802e3b <sys_calculate_free_frames>
  8012f1:	89 c2                	mov    %eax,%edx
  8012f3:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8012f9:	29 c2                	sub    %eax,%edx
  8012fb:	89 d0                	mov    %edx,%eax
  8012fd:	83 f8 02             	cmp    $0x2,%eax
  801300:	74 17                	je     801319 <_main+0x12e1>
  801302:	83 ec 04             	sub    $0x4,%esp
  801305:	68 e8 4d 80 00       	push   $0x804de8
  80130a:	68 05 01 00 00       	push   $0x105
  80130f:	68 9c 4c 80 00       	push   $0x804c9c
  801314:	e8 11 06 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801319:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801320:	e9 d2 00 00 00       	jmp    8013f7 <_main+0x13bf>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  801325:	a1 20 60 80 00       	mov    0x806020,%eax
  80132a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801330:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801333:	89 d0                	mov    %edx,%eax
  801335:	01 c0                	add    %eax,%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	c1 e0 03             	shl    $0x3,%eax
  80133c:	01 c8                	add    %ecx,%eax
  80133e:	8b 00                	mov    (%eax),%eax
  801340:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  801346:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80134c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801351:	89 c2                	mov    %eax,%edx
  801353:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801359:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
  80135f:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  801365:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80136a:	39 c2                	cmp    %eax,%edx
  80136c:	75 17                	jne    801385 <_main+0x134d>
				panic("free: page is not removed from WS");
  80136e:	83 ec 04             	sub    $0x4,%esp
  801371:	68 34 4e 80 00       	push   $0x804e34
  801376:	68 09 01 00 00       	push   $0x109
  80137b:	68 9c 4c 80 00       	push   $0x804c9c
  801380:	e8 a5 05 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  801385:	a1 20 60 80 00       	mov    0x806020,%eax
  80138a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801390:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801393:	89 d0                	mov    %edx,%eax
  801395:	01 c0                	add    %eax,%eax
  801397:	01 d0                	add    %edx,%eax
  801399:	c1 e0 03             	shl    $0x3,%eax
  80139c:	01 c8                	add    %ecx,%eax
  80139e:	8b 00                	mov    (%eax),%eax
  8013a0:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
  8013a6:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  8013ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b1:	89 c2                	mov    %eax,%edx
  8013b3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8013b9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8013c0:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8013c6:	01 c8                	add    %ecx,%eax
  8013c8:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  8013ce:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  8013d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d9:	39 c2                	cmp    %eax,%edx
  8013db:	75 17                	jne    8013f4 <_main+0x13bc>
				panic("free: page is not removed from WS");
  8013dd:	83 ec 04             	sub    $0x4,%esp
  8013e0:	68 34 4e 80 00       	push   $0x804e34
  8013e5:	68 0b 01 00 00       	push   $0x10b
  8013ea:	68 9c 4c 80 00       	push   $0x804c9c
  8013ef:	e8 36 05 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[4]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8013f4:	ff 45 e4             	incl   -0x1c(%ebp)
  8013f7:	a1 20 60 80 00       	mov    0x806020,%eax
  8013fc:	8b 50 74             	mov    0x74(%eax),%edx
  8013ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801402:	39 c2                	cmp    %eax,%edx
  801404:	0f 87 1b ff ff ff    	ja     801325 <_main+0x12ed>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80140a:	e8 2c 1a 00 00       	call   802e3b <sys_calculate_free_frames>
  80140f:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801415:	e8 c1 1a 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  80141a:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[5]);
  801420:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  801426:	83 ec 0c             	sub    $0xc,%esp
  801429:	50                   	push   %eax
  80142a:	e8 b2 17 00 00       	call   802be1 <free>
  80142f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801432:	e8 a4 1a 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  801437:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  80143d:	74 17                	je     801456 <_main+0x141e>
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	68 ac 4d 80 00       	push   $0x804dac
  801447:	68 12 01 00 00       	push   $0x112
  80144c:	68 9c 4c 80 00       	push   $0x804c9c
  801451:	e8 d4 04 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801456:	e8 e0 19 00 00       	call   802e3b <sys_calculate_free_frames>
  80145b:	89 c2                	mov    %eax,%edx
  80145d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801463:	39 c2                	cmp    %eax,%edx
  801465:	74 17                	je     80147e <_main+0x1446>
  801467:	83 ec 04             	sub    $0x4,%esp
  80146a:	68 e8 4d 80 00       	push   $0x804de8
  80146f:	68 13 01 00 00       	push   $0x113
  801474:	68 9c 4c 80 00       	push   $0x804c9c
  801479:	e8 ac 04 00 00       	call   80192a <_panic>

		//Free 1st 2 KB
		freeFrames = sys_calculate_free_frames() ;
  80147e:	e8 b8 19 00 00       	call   802e3b <sys_calculate_free_frames>
  801483:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801489:	e8 4d 1a 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  80148e:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[2]);
  801494:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80149a:	83 ec 0c             	sub    $0xc,%esp
  80149d:	50                   	push   %eax
  80149e:	e8 3e 17 00 00       	call   802be1 <free>
  8014a3:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8014a6:	e8 30 1a 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  8014ab:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8014b1:	74 17                	je     8014ca <_main+0x1492>
  8014b3:	83 ec 04             	sub    $0x4,%esp
  8014b6:	68 ac 4d 80 00       	push   $0x804dac
  8014bb:	68 19 01 00 00       	push   $0x119
  8014c0:	68 9c 4c 80 00       	push   $0x804c9c
  8014c5:	e8 60 04 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8014ca:	e8 6c 19 00 00       	call   802e3b <sys_calculate_free_frames>
  8014cf:	89 c2                	mov    %eax,%edx
  8014d1:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8014d7:	29 c2                	sub    %eax,%edx
  8014d9:	89 d0                	mov    %edx,%eax
  8014db:	83 f8 02             	cmp    $0x2,%eax
  8014de:	74 17                	je     8014f7 <_main+0x14bf>
  8014e0:	83 ec 04             	sub    $0x4,%esp
  8014e3:	68 e8 4d 80 00       	push   $0x804de8
  8014e8:	68 1a 01 00 00       	push   $0x11a
  8014ed:	68 9c 4c 80 00       	push   $0x804c9c
  8014f2:	e8 33 04 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8014f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8014fe:	e9 c9 00 00 00       	jmp    8015cc <_main+0x1594>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  801503:	a1 20 60 80 00       	mov    0x806020,%eax
  801508:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80150e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801511:	89 d0                	mov    %edx,%eax
  801513:	01 c0                	add    %eax,%eax
  801515:	01 d0                	add    %edx,%eax
  801517:	c1 e0 03             	shl    $0x3,%eax
  80151a:	01 c8                	add    %ecx,%eax
  80151c:	8b 00                	mov    (%eax),%eax
  80151e:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
  801524:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  80152a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80152f:	89 c2                	mov    %eax,%edx
  801531:	8b 45 8c             	mov    -0x74(%ebp),%eax
  801534:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
  80153a:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  801540:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801545:	39 c2                	cmp    %eax,%edx
  801547:	75 17                	jne    801560 <_main+0x1528>
				panic("free: page is not removed from WS");
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	68 34 4e 80 00       	push   $0x804e34
  801551:	68 1e 01 00 00       	push   $0x11e
  801556:	68 9c 4c 80 00       	push   $0x804c9c
  80155b:	e8 ca 03 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  801560:	a1 20 60 80 00       	mov    0x806020,%eax
  801565:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80156b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80156e:	89 d0                	mov    %edx,%eax
  801570:	01 c0                	add    %eax,%eax
  801572:	01 d0                	add    %edx,%eax
  801574:	c1 e0 03             	shl    $0x3,%eax
  801577:	01 c8                	add    %ecx,%eax
  801579:	8b 00                	mov    (%eax),%eax
  80157b:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
  801581:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801587:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80158c:	89 c2                	mov    %eax,%edx
  80158e:	8b 45 88             	mov    -0x78(%ebp),%eax
  801591:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801598:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80159b:	01 c8                	add    %ecx,%eax
  80159d:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
  8015a3:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8015a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015ae:	39 c2                	cmp    %eax,%edx
  8015b0:	75 17                	jne    8015c9 <_main+0x1591>
				panic("free: page is not removed from WS");
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	68 34 4e 80 00       	push   $0x804e34
  8015ba:	68 20 01 00 00       	push   $0x120
  8015bf:	68 9c 4c 80 00       	push   $0x804c9c
  8015c4:	e8 61 03 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[2]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8015c9:	ff 45 e4             	incl   -0x1c(%ebp)
  8015cc:	a1 20 60 80 00       	mov    0x806020,%eax
  8015d1:	8b 50 74             	mov    0x74(%eax),%edx
  8015d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d7:	39 c2                	cmp    %eax,%edx
  8015d9:	0f 87 24 ff ff ff    	ja     801503 <_main+0x14cb>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 2nd 2 KB
		freeFrames = sys_calculate_free_frames() ;
  8015df:	e8 57 18 00 00       	call   802e3b <sys_calculate_free_frames>
  8015e4:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8015ea:	e8 ec 18 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  8015ef:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[3]);
  8015f5:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  8015fb:	83 ec 0c             	sub    $0xc,%esp
  8015fe:	50                   	push   %eax
  8015ff:	e8 dd 15 00 00       	call   802be1 <free>
  801604:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801607:	e8 cf 18 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  80160c:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801612:	74 17                	je     80162b <_main+0x15f3>
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	68 ac 4d 80 00       	push   $0x804dac
  80161c:	68 27 01 00 00       	push   $0x127
  801621:	68 9c 4c 80 00       	push   $0x804c9c
  801626:	e8 ff 02 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80162b:	e8 0b 18 00 00       	call   802e3b <sys_calculate_free_frames>
  801630:	89 c2                	mov    %eax,%edx
  801632:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801638:	39 c2                	cmp    %eax,%edx
  80163a:	74 17                	je     801653 <_main+0x161b>
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 e8 4d 80 00       	push   $0x804de8
  801644:	68 28 01 00 00       	push   $0x128
  801649:	68 9c 4c 80 00       	push   $0x804c9c
  80164e:	e8 d7 02 00 00       	call   80192a <_panic>


		//Free last 14 KB
		freeFrames = sys_calculate_free_frames() ;
  801653:	e8 e3 17 00 00       	call   802e3b <sys_calculate_free_frames>
  801658:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80165e:	e8 78 18 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  801663:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[7]);
  801669:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80166f:	83 ec 0c             	sub    $0xc,%esp
  801672:	50                   	push   %eax
  801673:	e8 69 15 00 00       	call   802be1 <free>
  801678:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80167b:	e8 5b 18 00 00       	call   802edb <sys_pf_calculate_allocated_pages>
  801680:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801686:	74 17                	je     80169f <_main+0x1667>
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	68 ac 4d 80 00       	push   $0x804dac
  801690:	68 2f 01 00 00       	push   $0x12f
  801695:	68 9c 4c 80 00       	push   $0x804c9c
  80169a:	e8 8b 02 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80169f:	e8 97 17 00 00       	call   802e3b <sys_calculate_free_frames>
  8016a4:	89 c2                	mov    %eax,%edx
  8016a6:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8016ac:	29 c2                	sub    %eax,%edx
  8016ae:	89 d0                	mov    %edx,%eax
  8016b0:	83 f8 03             	cmp    $0x3,%eax
  8016b3:	74 17                	je     8016cc <_main+0x1694>
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 e8 4d 80 00       	push   $0x804de8
  8016bd:	68 30 01 00 00       	push   $0x130
  8016c2:	68 9c 4c 80 00       	push   $0x804c9c
  8016c7:	e8 5e 02 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8016cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8016d3:	e9 c6 00 00 00       	jmp    80179e <_main+0x1766>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  8016d8:	a1 20 60 80 00       	mov    0x806020,%eax
  8016dd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8016e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016e6:	89 d0                	mov    %edx,%eax
  8016e8:	01 c0                	add    %eax,%eax
  8016ea:	01 d0                	add    %edx,%eax
  8016ec:	c1 e0 03             	shl    $0x3,%eax
  8016ef:	01 c8                	add    %ecx,%eax
  8016f1:	8b 00                	mov    (%eax),%eax
  8016f3:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
  8016f9:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  8016ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801704:	89 c2                	mov    %eax,%edx
  801706:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801709:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
  80170f:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  801715:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80171a:	39 c2                	cmp    %eax,%edx
  80171c:	75 17                	jne    801735 <_main+0x16fd>
				panic("free: page is not removed from WS");
  80171e:	83 ec 04             	sub    $0x4,%esp
  801721:	68 34 4e 80 00       	push   $0x804e34
  801726:	68 34 01 00 00       	push   $0x134
  80172b:	68 9c 4c 80 00       	push   $0x804c9c
  801730:	e8 f5 01 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  801735:	a1 20 60 80 00       	mov    0x806020,%eax
  80173a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801740:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801743:	89 d0                	mov    %edx,%eax
  801745:	01 c0                	add    %eax,%eax
  801747:	01 d0                	add    %edx,%eax
  801749:	c1 e0 03             	shl    $0x3,%eax
  80174c:	01 c8                	add    %ecx,%eax
  80174e:	8b 00                	mov    (%eax),%eax
  801750:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
  801756:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  80175c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801761:	89 c2                	mov    %eax,%edx
  801763:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801766:	01 c0                	add    %eax,%eax
  801768:	89 c1                	mov    %eax,%ecx
  80176a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80176d:	01 c8                	add    %ecx,%eax
  80176f:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
  801775:	8b 85 b8 fe ff ff    	mov    -0x148(%ebp),%eax
  80177b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801780:	39 c2                	cmp    %eax,%edx
  801782:	75 17                	jne    80179b <_main+0x1763>
				panic("free: page is not removed from WS");
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	68 34 4e 80 00       	push   $0x804e34
  80178c:	68 36 01 00 00       	push   $0x136
  801791:	68 9c 4c 80 00       	push   $0x804c9c
  801796:	e8 8f 01 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[7]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80179b:	ff 45 e4             	incl   -0x1c(%ebp)
  80179e:	a1 20 60 80 00       	mov    0x806020,%eax
  8017a3:	8b 50 74             	mov    0x74(%eax),%edx
  8017a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a9:	39 c2                	cmp    %eax,%edx
  8017ab:	0f 87 27 ff ff ff    	ja     8016d8 <_main+0x16a0>
				panic("free: page is not removed from WS");
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		if(start_freeFrames != (sys_calculate_free_frames())) {panic("Wrong free: not all pages removed correctly at end");}
  8017b1:	e8 85 16 00 00       	call   802e3b <sys_calculate_free_frames>
  8017b6:	89 c2                	mov    %eax,%edx
  8017b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017bb:	39 c2                	cmp    %eax,%edx
  8017bd:	74 17                	je     8017d6 <_main+0x179e>
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 58 4e 80 00       	push   $0x804e58
  8017c7:	68 39 01 00 00       	push   $0x139
  8017cc:	68 9c 4c 80 00       	push   $0x804c9c
  8017d1:	e8 54 01 00 00       	call   80192a <_panic>
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	68 8c 4e 80 00       	push   $0x804e8c
  8017de:	e8 fb 03 00 00       	call   801bde <cprintf>
  8017e3:	83 c4 10             	add    $0x10,%esp

	return;
  8017e6:	90                   	nop
}
  8017e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ea:	5b                   	pop    %ebx
  8017eb:	5f                   	pop    %edi
  8017ec:	5d                   	pop    %ebp
  8017ed:	c3                   	ret    

008017ee <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8017f4:	e8 22 19 00 00       	call   80311b <sys_getenvindex>
  8017f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8017fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ff:	89 d0                	mov    %edx,%eax
  801801:	c1 e0 03             	shl    $0x3,%eax
  801804:	01 d0                	add    %edx,%eax
  801806:	01 c0                	add    %eax,%eax
  801808:	01 d0                	add    %edx,%eax
  80180a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801811:	01 d0                	add    %edx,%eax
  801813:	c1 e0 04             	shl    $0x4,%eax
  801816:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80181b:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801820:	a1 20 60 80 00       	mov    0x806020,%eax
  801825:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80182b:	84 c0                	test   %al,%al
  80182d:	74 0f                	je     80183e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80182f:	a1 20 60 80 00       	mov    0x806020,%eax
  801834:	05 5c 05 00 00       	add    $0x55c,%eax
  801839:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80183e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801842:	7e 0a                	jle    80184e <libmain+0x60>
		binaryname = argv[0];
  801844:	8b 45 0c             	mov    0xc(%ebp),%eax
  801847:	8b 00                	mov    (%eax),%eax
  801849:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  80184e:	83 ec 08             	sub    $0x8,%esp
  801851:	ff 75 0c             	pushl  0xc(%ebp)
  801854:	ff 75 08             	pushl  0x8(%ebp)
  801857:	e8 dc e7 ff ff       	call   800038 <_main>
  80185c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80185f:	e8 c4 16 00 00       	call   802f28 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801864:	83 ec 0c             	sub    $0xc,%esp
  801867:	68 e0 4e 80 00       	push   $0x804ee0
  80186c:	e8 6d 03 00 00       	call   801bde <cprintf>
  801871:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801874:	a1 20 60 80 00       	mov    0x806020,%eax
  801879:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80187f:	a1 20 60 80 00       	mov    0x806020,%eax
  801884:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80188a:	83 ec 04             	sub    $0x4,%esp
  80188d:	52                   	push   %edx
  80188e:	50                   	push   %eax
  80188f:	68 08 4f 80 00       	push   $0x804f08
  801894:	e8 45 03 00 00       	call   801bde <cprintf>
  801899:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80189c:	a1 20 60 80 00       	mov    0x806020,%eax
  8018a1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8018a7:	a1 20 60 80 00       	mov    0x806020,%eax
  8018ac:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8018b2:	a1 20 60 80 00       	mov    0x806020,%eax
  8018b7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8018bd:	51                   	push   %ecx
  8018be:	52                   	push   %edx
  8018bf:	50                   	push   %eax
  8018c0:	68 30 4f 80 00       	push   $0x804f30
  8018c5:	e8 14 03 00 00       	call   801bde <cprintf>
  8018ca:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8018cd:	a1 20 60 80 00       	mov    0x806020,%eax
  8018d2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8018d8:	83 ec 08             	sub    $0x8,%esp
  8018db:	50                   	push   %eax
  8018dc:	68 88 4f 80 00       	push   $0x804f88
  8018e1:	e8 f8 02 00 00       	call   801bde <cprintf>
  8018e6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8018e9:	83 ec 0c             	sub    $0xc,%esp
  8018ec:	68 e0 4e 80 00       	push   $0x804ee0
  8018f1:	e8 e8 02 00 00       	call   801bde <cprintf>
  8018f6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8018f9:	e8 44 16 00 00       	call   802f42 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8018fe:	e8 19 00 00 00       	call   80191c <exit>
}
  801903:	90                   	nop
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80190c:	83 ec 0c             	sub    $0xc,%esp
  80190f:	6a 00                	push   $0x0
  801911:	e8 d1 17 00 00       	call   8030e7 <sys_destroy_env>
  801916:	83 c4 10             	add    $0x10,%esp
}
  801919:	90                   	nop
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <exit>:

void
exit(void)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801922:	e8 26 18 00 00       	call   80314d <sys_exit_env>
}
  801927:	90                   	nop
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801930:	8d 45 10             	lea    0x10(%ebp),%eax
  801933:	83 c0 04             	add    $0x4,%eax
  801936:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801939:	a1 5c 61 80 00       	mov    0x80615c,%eax
  80193e:	85 c0                	test   %eax,%eax
  801940:	74 16                	je     801958 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801942:	a1 5c 61 80 00       	mov    0x80615c,%eax
  801947:	83 ec 08             	sub    $0x8,%esp
  80194a:	50                   	push   %eax
  80194b:	68 9c 4f 80 00       	push   $0x804f9c
  801950:	e8 89 02 00 00       	call   801bde <cprintf>
  801955:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801958:	a1 00 60 80 00       	mov    0x806000,%eax
  80195d:	ff 75 0c             	pushl  0xc(%ebp)
  801960:	ff 75 08             	pushl  0x8(%ebp)
  801963:	50                   	push   %eax
  801964:	68 a1 4f 80 00       	push   $0x804fa1
  801969:	e8 70 02 00 00       	call   801bde <cprintf>
  80196e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	ff 75 f4             	pushl  -0xc(%ebp)
  80197a:	50                   	push   %eax
  80197b:	e8 f3 01 00 00       	call   801b73 <vcprintf>
  801980:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801983:	83 ec 08             	sub    $0x8,%esp
  801986:	6a 00                	push   $0x0
  801988:	68 bd 4f 80 00       	push   $0x804fbd
  80198d:	e8 e1 01 00 00       	call   801b73 <vcprintf>
  801992:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801995:	e8 82 ff ff ff       	call   80191c <exit>

	// should not return here
	while (1) ;
  80199a:	eb fe                	jmp    80199a <_panic+0x70>

0080199c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8019a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8019a7:	8b 50 74             	mov    0x74(%eax),%edx
  8019aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ad:	39 c2                	cmp    %eax,%edx
  8019af:	74 14                	je     8019c5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	68 c0 4f 80 00       	push   $0x804fc0
  8019b9:	6a 26                	push   $0x26
  8019bb:	68 0c 50 80 00       	push   $0x80500c
  8019c0:	e8 65 ff ff ff       	call   80192a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019d3:	e9 c2 00 00 00       	jmp    801a9a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8019d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	01 d0                	add    %edx,%eax
  8019e7:	8b 00                	mov    (%eax),%eax
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	75 08                	jne    8019f5 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8019ed:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8019f0:	e9 a2 00 00 00       	jmp    801a97 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8019f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a03:	eb 69                	jmp    801a6e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a05:	a1 20 60 80 00       	mov    0x806020,%eax
  801a0a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801a10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a13:	89 d0                	mov    %edx,%eax
  801a15:	01 c0                	add    %eax,%eax
  801a17:	01 d0                	add    %edx,%eax
  801a19:	c1 e0 03             	shl    $0x3,%eax
  801a1c:	01 c8                	add    %ecx,%eax
  801a1e:	8a 40 04             	mov    0x4(%eax),%al
  801a21:	84 c0                	test   %al,%al
  801a23:	75 46                	jne    801a6b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a25:	a1 20 60 80 00       	mov    0x806020,%eax
  801a2a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801a30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a33:	89 d0                	mov    %edx,%eax
  801a35:	01 c0                	add    %eax,%eax
  801a37:	01 d0                	add    %edx,%eax
  801a39:	c1 e0 03             	shl    $0x3,%eax
  801a3c:	01 c8                	add    %ecx,%eax
  801a3e:	8b 00                	mov    (%eax),%eax
  801a40:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a43:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a4b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a50:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	01 c8                	add    %ecx,%eax
  801a5c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a5e:	39 c2                	cmp    %eax,%edx
  801a60:	75 09                	jne    801a6b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801a62:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a69:	eb 12                	jmp    801a7d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a6b:	ff 45 e8             	incl   -0x18(%ebp)
  801a6e:	a1 20 60 80 00       	mov    0x806020,%eax
  801a73:	8b 50 74             	mov    0x74(%eax),%edx
  801a76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a79:	39 c2                	cmp    %eax,%edx
  801a7b:	77 88                	ja     801a05 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a81:	75 14                	jne    801a97 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801a83:	83 ec 04             	sub    $0x4,%esp
  801a86:	68 18 50 80 00       	push   $0x805018
  801a8b:	6a 3a                	push   $0x3a
  801a8d:	68 0c 50 80 00       	push   $0x80500c
  801a92:	e8 93 fe ff ff       	call   80192a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a97:	ff 45 f0             	incl   -0x10(%ebp)
  801a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801aa0:	0f 8c 32 ff ff ff    	jl     8019d8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801aa6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ab4:	eb 26                	jmp    801adc <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801ab6:	a1 20 60 80 00       	mov    0x806020,%eax
  801abb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801ac1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ac4:	89 d0                	mov    %edx,%eax
  801ac6:	01 c0                	add    %eax,%eax
  801ac8:	01 d0                	add    %edx,%eax
  801aca:	c1 e0 03             	shl    $0x3,%eax
  801acd:	01 c8                	add    %ecx,%eax
  801acf:	8a 40 04             	mov    0x4(%eax),%al
  801ad2:	3c 01                	cmp    $0x1,%al
  801ad4:	75 03                	jne    801ad9 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801ad6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ad9:	ff 45 e0             	incl   -0x20(%ebp)
  801adc:	a1 20 60 80 00       	mov    0x806020,%eax
  801ae1:	8b 50 74             	mov    0x74(%eax),%edx
  801ae4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ae7:	39 c2                	cmp    %eax,%edx
  801ae9:	77 cb                	ja     801ab6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aee:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801af1:	74 14                	je     801b07 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	68 6c 50 80 00       	push   $0x80506c
  801afb:	6a 44                	push   $0x44
  801afd:	68 0c 50 80 00       	push   $0x80500c
  801b02:	e8 23 fe ff ff       	call   80192a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b07:	90                   	nop
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b13:	8b 00                	mov    (%eax),%eax
  801b15:	8d 48 01             	lea    0x1(%eax),%ecx
  801b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1b:	89 0a                	mov    %ecx,(%edx)
  801b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  801b20:	88 d1                	mov    %dl,%cl
  801b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b25:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2c:	8b 00                	mov    (%eax),%eax
  801b2e:	3d ff 00 00 00       	cmp    $0xff,%eax
  801b33:	75 2c                	jne    801b61 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801b35:	a0 24 60 80 00       	mov    0x806024,%al
  801b3a:	0f b6 c0             	movzbl %al,%eax
  801b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b40:	8b 12                	mov    (%edx),%edx
  801b42:	89 d1                	mov    %edx,%ecx
  801b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b47:	83 c2 08             	add    $0x8,%edx
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	50                   	push   %eax
  801b4e:	51                   	push   %ecx
  801b4f:	52                   	push   %edx
  801b50:	e8 25 12 00 00       	call   802d7a <sys_cputs>
  801b55:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b64:	8b 40 04             	mov    0x4(%eax),%eax
  801b67:	8d 50 01             	lea    0x1(%eax),%edx
  801b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6d:	89 50 04             	mov    %edx,0x4(%eax)
}
  801b70:	90                   	nop
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801b7c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b83:	00 00 00 
	b.cnt = 0;
  801b86:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801b8d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801b90:	ff 75 0c             	pushl  0xc(%ebp)
  801b93:	ff 75 08             	pushl  0x8(%ebp)
  801b96:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801b9c:	50                   	push   %eax
  801b9d:	68 0a 1b 80 00       	push   $0x801b0a
  801ba2:	e8 11 02 00 00       	call   801db8 <vprintfmt>
  801ba7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801baa:	a0 24 60 80 00       	mov    0x806024,%al
  801baf:	0f b6 c0             	movzbl %al,%eax
  801bb2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801bb8:	83 ec 04             	sub    $0x4,%esp
  801bbb:	50                   	push   %eax
  801bbc:	52                   	push   %edx
  801bbd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801bc3:	83 c0 08             	add    $0x8,%eax
  801bc6:	50                   	push   %eax
  801bc7:	e8 ae 11 00 00       	call   802d7a <sys_cputs>
  801bcc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801bcf:	c6 05 24 60 80 00 00 	movb   $0x0,0x806024
	return b.cnt;
  801bd6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <cprintf>:

int cprintf(const char *fmt, ...) {
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801be4:	c6 05 24 60 80 00 01 	movb   $0x1,0x806024
	va_start(ap, fmt);
  801beb:	8d 45 0c             	lea    0xc(%ebp),%eax
  801bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	83 ec 08             	sub    $0x8,%esp
  801bf7:	ff 75 f4             	pushl  -0xc(%ebp)
  801bfa:	50                   	push   %eax
  801bfb:	e8 73 ff ff ff       	call   801b73 <vcprintf>
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801c11:	e8 12 13 00 00       	call   802f28 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c16:	8d 45 0c             	lea    0xc(%ebp),%eax
  801c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	83 ec 08             	sub    $0x8,%esp
  801c22:	ff 75 f4             	pushl  -0xc(%ebp)
  801c25:	50                   	push   %eax
  801c26:	e8 48 ff ff ff       	call   801b73 <vcprintf>
  801c2b:	83 c4 10             	add    $0x10,%esp
  801c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801c31:	e8 0c 13 00 00       	call   802f42 <sys_enable_interrupt>
	return cnt;
  801c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	53                   	push   %ebx
  801c3f:	83 ec 14             	sub    $0x14,%esp
  801c42:	8b 45 10             	mov    0x10(%ebp),%eax
  801c45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c48:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801c4e:	8b 45 18             	mov    0x18(%ebp),%eax
  801c51:	ba 00 00 00 00       	mov    $0x0,%edx
  801c56:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801c59:	77 55                	ja     801cb0 <printnum+0x75>
  801c5b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801c5e:	72 05                	jb     801c65 <printnum+0x2a>
  801c60:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c63:	77 4b                	ja     801cb0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801c65:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801c68:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801c6b:	8b 45 18             	mov    0x18(%ebp),%eax
  801c6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c73:	52                   	push   %edx
  801c74:	50                   	push   %eax
  801c75:	ff 75 f4             	pushl  -0xc(%ebp)
  801c78:	ff 75 f0             	pushl  -0x10(%ebp)
  801c7b:	e8 80 2d 00 00       	call   804a00 <__udivdi3>
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	83 ec 04             	sub    $0x4,%esp
  801c86:	ff 75 20             	pushl  0x20(%ebp)
  801c89:	53                   	push   %ebx
  801c8a:	ff 75 18             	pushl  0x18(%ebp)
  801c8d:	52                   	push   %edx
  801c8e:	50                   	push   %eax
  801c8f:	ff 75 0c             	pushl  0xc(%ebp)
  801c92:	ff 75 08             	pushl  0x8(%ebp)
  801c95:	e8 a1 ff ff ff       	call   801c3b <printnum>
  801c9a:	83 c4 20             	add    $0x20,%esp
  801c9d:	eb 1a                	jmp    801cb9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801c9f:	83 ec 08             	sub    $0x8,%esp
  801ca2:	ff 75 0c             	pushl  0xc(%ebp)
  801ca5:	ff 75 20             	pushl  0x20(%ebp)
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	ff d0                	call   *%eax
  801cad:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801cb0:	ff 4d 1c             	decl   0x1c(%ebp)
  801cb3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801cb7:	7f e6                	jg     801c9f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801cb9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801cbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cc7:	53                   	push   %ebx
  801cc8:	51                   	push   %ecx
  801cc9:	52                   	push   %edx
  801cca:	50                   	push   %eax
  801ccb:	e8 40 2e 00 00       	call   804b10 <__umoddi3>
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	05 d4 52 80 00       	add    $0x8052d4,%eax
  801cd8:	8a 00                	mov    (%eax),%al
  801cda:	0f be c0             	movsbl %al,%eax
  801cdd:	83 ec 08             	sub    $0x8,%esp
  801ce0:	ff 75 0c             	pushl  0xc(%ebp)
  801ce3:	50                   	push   %eax
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	ff d0                	call   *%eax
  801ce9:	83 c4 10             	add    $0x10,%esp
}
  801cec:	90                   	nop
  801ced:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801cf5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801cf9:	7e 1c                	jle    801d17 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	8b 00                	mov    (%eax),%eax
  801d00:	8d 50 08             	lea    0x8(%eax),%edx
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	89 10                	mov    %edx,(%eax)
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	8b 00                	mov    (%eax),%eax
  801d0d:	83 e8 08             	sub    $0x8,%eax
  801d10:	8b 50 04             	mov    0x4(%eax),%edx
  801d13:	8b 00                	mov    (%eax),%eax
  801d15:	eb 40                	jmp    801d57 <getuint+0x65>
	else if (lflag)
  801d17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d1b:	74 1e                	je     801d3b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8b 00                	mov    (%eax),%eax
  801d22:	8d 50 04             	lea    0x4(%eax),%edx
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	89 10                	mov    %edx,(%eax)
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8b 00                	mov    (%eax),%eax
  801d2f:	83 e8 04             	sub    $0x4,%eax
  801d32:	8b 00                	mov    (%eax),%eax
  801d34:	ba 00 00 00 00       	mov    $0x0,%edx
  801d39:	eb 1c                	jmp    801d57 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	8b 00                	mov    (%eax),%eax
  801d40:	8d 50 04             	lea    0x4(%eax),%edx
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	89 10                	mov    %edx,(%eax)
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	8b 00                	mov    (%eax),%eax
  801d4d:	83 e8 04             	sub    $0x4,%eax
  801d50:	8b 00                	mov    (%eax),%eax
  801d52:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801d57:	5d                   	pop    %ebp
  801d58:	c3                   	ret    

00801d59 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801d5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801d60:	7e 1c                	jle    801d7e <getint+0x25>
		return va_arg(*ap, long long);
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	8b 00                	mov    (%eax),%eax
  801d67:	8d 50 08             	lea    0x8(%eax),%edx
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	89 10                	mov    %edx,(%eax)
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	8b 00                	mov    (%eax),%eax
  801d74:	83 e8 08             	sub    $0x8,%eax
  801d77:	8b 50 04             	mov    0x4(%eax),%edx
  801d7a:	8b 00                	mov    (%eax),%eax
  801d7c:	eb 38                	jmp    801db6 <getint+0x5d>
	else if (lflag)
  801d7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d82:	74 1a                	je     801d9e <getint+0x45>
		return va_arg(*ap, long);
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	8b 00                	mov    (%eax),%eax
  801d89:	8d 50 04             	lea    0x4(%eax),%edx
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	89 10                	mov    %edx,(%eax)
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	8b 00                	mov    (%eax),%eax
  801d96:	83 e8 04             	sub    $0x4,%eax
  801d99:	8b 00                	mov    (%eax),%eax
  801d9b:	99                   	cltd   
  801d9c:	eb 18                	jmp    801db6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	8b 00                	mov    (%eax),%eax
  801da3:	8d 50 04             	lea    0x4(%eax),%edx
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	89 10                	mov    %edx,(%eax)
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	8b 00                	mov    (%eax),%eax
  801db0:	83 e8 04             	sub    $0x4,%eax
  801db3:	8b 00                	mov    (%eax),%eax
  801db5:	99                   	cltd   
}
  801db6:	5d                   	pop    %ebp
  801db7:	c3                   	ret    

00801db8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	56                   	push   %esi
  801dbc:	53                   	push   %ebx
  801dbd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801dc0:	eb 17                	jmp    801dd9 <vprintfmt+0x21>
			if (ch == '\0')
  801dc2:	85 db                	test   %ebx,%ebx
  801dc4:	0f 84 af 03 00 00    	je     802179 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801dca:	83 ec 08             	sub    $0x8,%esp
  801dcd:	ff 75 0c             	pushl  0xc(%ebp)
  801dd0:	53                   	push   %ebx
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	ff d0                	call   *%eax
  801dd6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddc:	8d 50 01             	lea    0x1(%eax),%edx
  801ddf:	89 55 10             	mov    %edx,0x10(%ebp)
  801de2:	8a 00                	mov    (%eax),%al
  801de4:	0f b6 d8             	movzbl %al,%ebx
  801de7:	83 fb 25             	cmp    $0x25,%ebx
  801dea:	75 d6                	jne    801dc2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801dec:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801df0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801df7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801dfe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801e05:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801e0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0f:	8d 50 01             	lea    0x1(%eax),%edx
  801e12:	89 55 10             	mov    %edx,0x10(%ebp)
  801e15:	8a 00                	mov    (%eax),%al
  801e17:	0f b6 d8             	movzbl %al,%ebx
  801e1a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801e1d:	83 f8 55             	cmp    $0x55,%eax
  801e20:	0f 87 2b 03 00 00    	ja     802151 <vprintfmt+0x399>
  801e26:	8b 04 85 f8 52 80 00 	mov    0x8052f8(,%eax,4),%eax
  801e2d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801e2f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801e33:	eb d7                	jmp    801e0c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801e35:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801e39:	eb d1                	jmp    801e0c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801e3b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801e42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e45:	89 d0                	mov    %edx,%eax
  801e47:	c1 e0 02             	shl    $0x2,%eax
  801e4a:	01 d0                	add    %edx,%eax
  801e4c:	01 c0                	add    %eax,%eax
  801e4e:	01 d8                	add    %ebx,%eax
  801e50:	83 e8 30             	sub    $0x30,%eax
  801e53:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801e56:	8b 45 10             	mov    0x10(%ebp),%eax
  801e59:	8a 00                	mov    (%eax),%al
  801e5b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801e5e:	83 fb 2f             	cmp    $0x2f,%ebx
  801e61:	7e 3e                	jle    801ea1 <vprintfmt+0xe9>
  801e63:	83 fb 39             	cmp    $0x39,%ebx
  801e66:	7f 39                	jg     801ea1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801e68:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801e6b:	eb d5                	jmp    801e42 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801e6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e70:	83 c0 04             	add    $0x4,%eax
  801e73:	89 45 14             	mov    %eax,0x14(%ebp)
  801e76:	8b 45 14             	mov    0x14(%ebp),%eax
  801e79:	83 e8 04             	sub    $0x4,%eax
  801e7c:	8b 00                	mov    (%eax),%eax
  801e7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801e81:	eb 1f                	jmp    801ea2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801e83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e87:	79 83                	jns    801e0c <vprintfmt+0x54>
				width = 0;
  801e89:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801e90:	e9 77 ff ff ff       	jmp    801e0c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801e95:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801e9c:	e9 6b ff ff ff       	jmp    801e0c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801ea1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801ea2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ea6:	0f 89 60 ff ff ff    	jns    801e0c <vprintfmt+0x54>
				width = precision, precision = -1;
  801eac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eaf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801eb2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801eb9:	e9 4e ff ff ff       	jmp    801e0c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801ebe:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801ec1:	e9 46 ff ff ff       	jmp    801e0c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801ec6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec9:	83 c0 04             	add    $0x4,%eax
  801ecc:	89 45 14             	mov    %eax,0x14(%ebp)
  801ecf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed2:	83 e8 04             	sub    $0x4,%eax
  801ed5:	8b 00                	mov    (%eax),%eax
  801ed7:	83 ec 08             	sub    $0x8,%esp
  801eda:	ff 75 0c             	pushl  0xc(%ebp)
  801edd:	50                   	push   %eax
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	ff d0                	call   *%eax
  801ee3:	83 c4 10             	add    $0x10,%esp
			break;
  801ee6:	e9 89 02 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801eeb:	8b 45 14             	mov    0x14(%ebp),%eax
  801eee:	83 c0 04             	add    $0x4,%eax
  801ef1:	89 45 14             	mov    %eax,0x14(%ebp)
  801ef4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef7:	83 e8 04             	sub    $0x4,%eax
  801efa:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801efc:	85 db                	test   %ebx,%ebx
  801efe:	79 02                	jns    801f02 <vprintfmt+0x14a>
				err = -err;
  801f00:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801f02:	83 fb 64             	cmp    $0x64,%ebx
  801f05:	7f 0b                	jg     801f12 <vprintfmt+0x15a>
  801f07:	8b 34 9d 40 51 80 00 	mov    0x805140(,%ebx,4),%esi
  801f0e:	85 f6                	test   %esi,%esi
  801f10:	75 19                	jne    801f2b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801f12:	53                   	push   %ebx
  801f13:	68 e5 52 80 00       	push   $0x8052e5
  801f18:	ff 75 0c             	pushl  0xc(%ebp)
  801f1b:	ff 75 08             	pushl  0x8(%ebp)
  801f1e:	e8 5e 02 00 00       	call   802181 <printfmt>
  801f23:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801f26:	e9 49 02 00 00       	jmp    802174 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801f2b:	56                   	push   %esi
  801f2c:	68 ee 52 80 00       	push   $0x8052ee
  801f31:	ff 75 0c             	pushl  0xc(%ebp)
  801f34:	ff 75 08             	pushl  0x8(%ebp)
  801f37:	e8 45 02 00 00       	call   802181 <printfmt>
  801f3c:	83 c4 10             	add    $0x10,%esp
			break;
  801f3f:	e9 30 02 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801f44:	8b 45 14             	mov    0x14(%ebp),%eax
  801f47:	83 c0 04             	add    $0x4,%eax
  801f4a:	89 45 14             	mov    %eax,0x14(%ebp)
  801f4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f50:	83 e8 04             	sub    $0x4,%eax
  801f53:	8b 30                	mov    (%eax),%esi
  801f55:	85 f6                	test   %esi,%esi
  801f57:	75 05                	jne    801f5e <vprintfmt+0x1a6>
				p = "(null)";
  801f59:	be f1 52 80 00       	mov    $0x8052f1,%esi
			if (width > 0 && padc != '-')
  801f5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f62:	7e 6d                	jle    801fd1 <vprintfmt+0x219>
  801f64:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801f68:	74 67                	je     801fd1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801f6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f6d:	83 ec 08             	sub    $0x8,%esp
  801f70:	50                   	push   %eax
  801f71:	56                   	push   %esi
  801f72:	e8 0c 03 00 00       	call   802283 <strnlen>
  801f77:	83 c4 10             	add    $0x10,%esp
  801f7a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801f7d:	eb 16                	jmp    801f95 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801f7f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801f83:	83 ec 08             	sub    $0x8,%esp
  801f86:	ff 75 0c             	pushl  0xc(%ebp)
  801f89:	50                   	push   %eax
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	ff d0                	call   *%eax
  801f8f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801f92:	ff 4d e4             	decl   -0x1c(%ebp)
  801f95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f99:	7f e4                	jg     801f7f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801f9b:	eb 34                	jmp    801fd1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801f9d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801fa1:	74 1c                	je     801fbf <vprintfmt+0x207>
  801fa3:	83 fb 1f             	cmp    $0x1f,%ebx
  801fa6:	7e 05                	jle    801fad <vprintfmt+0x1f5>
  801fa8:	83 fb 7e             	cmp    $0x7e,%ebx
  801fab:	7e 12                	jle    801fbf <vprintfmt+0x207>
					putch('?', putdat);
  801fad:	83 ec 08             	sub    $0x8,%esp
  801fb0:	ff 75 0c             	pushl  0xc(%ebp)
  801fb3:	6a 3f                	push   $0x3f
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	ff d0                	call   *%eax
  801fba:	83 c4 10             	add    $0x10,%esp
  801fbd:	eb 0f                	jmp    801fce <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801fbf:	83 ec 08             	sub    $0x8,%esp
  801fc2:	ff 75 0c             	pushl  0xc(%ebp)
  801fc5:	53                   	push   %ebx
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	ff d0                	call   *%eax
  801fcb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801fce:	ff 4d e4             	decl   -0x1c(%ebp)
  801fd1:	89 f0                	mov    %esi,%eax
  801fd3:	8d 70 01             	lea    0x1(%eax),%esi
  801fd6:	8a 00                	mov    (%eax),%al
  801fd8:	0f be d8             	movsbl %al,%ebx
  801fdb:	85 db                	test   %ebx,%ebx
  801fdd:	74 24                	je     802003 <vprintfmt+0x24b>
  801fdf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fe3:	78 b8                	js     801f9d <vprintfmt+0x1e5>
  801fe5:	ff 4d e0             	decl   -0x20(%ebp)
  801fe8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fec:	79 af                	jns    801f9d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801fee:	eb 13                	jmp    802003 <vprintfmt+0x24b>
				putch(' ', putdat);
  801ff0:	83 ec 08             	sub    $0x8,%esp
  801ff3:	ff 75 0c             	pushl  0xc(%ebp)
  801ff6:	6a 20                	push   $0x20
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	ff d0                	call   *%eax
  801ffd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802000:	ff 4d e4             	decl   -0x1c(%ebp)
  802003:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802007:	7f e7                	jg     801ff0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  802009:	e9 66 01 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80200e:	83 ec 08             	sub    $0x8,%esp
  802011:	ff 75 e8             	pushl  -0x18(%ebp)
  802014:	8d 45 14             	lea    0x14(%ebp),%eax
  802017:	50                   	push   %eax
  802018:	e8 3c fd ff ff       	call   801d59 <getint>
  80201d:	83 c4 10             	add    $0x10,%esp
  802020:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802023:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  802026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802029:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202c:	85 d2                	test   %edx,%edx
  80202e:	79 23                	jns    802053 <vprintfmt+0x29b>
				putch('-', putdat);
  802030:	83 ec 08             	sub    $0x8,%esp
  802033:	ff 75 0c             	pushl  0xc(%ebp)
  802036:	6a 2d                	push   $0x2d
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	ff d0                	call   *%eax
  80203d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  802040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802043:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802046:	f7 d8                	neg    %eax
  802048:	83 d2 00             	adc    $0x0,%edx
  80204b:	f7 da                	neg    %edx
  80204d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802050:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  802053:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80205a:	e9 bc 00 00 00       	jmp    80211b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80205f:	83 ec 08             	sub    $0x8,%esp
  802062:	ff 75 e8             	pushl  -0x18(%ebp)
  802065:	8d 45 14             	lea    0x14(%ebp),%eax
  802068:	50                   	push   %eax
  802069:	e8 84 fc ff ff       	call   801cf2 <getuint>
  80206e:	83 c4 10             	add    $0x10,%esp
  802071:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802074:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  802077:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80207e:	e9 98 00 00 00       	jmp    80211b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802083:	83 ec 08             	sub    $0x8,%esp
  802086:	ff 75 0c             	pushl  0xc(%ebp)
  802089:	6a 58                	push   $0x58
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	ff d0                	call   *%eax
  802090:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  802093:	83 ec 08             	sub    $0x8,%esp
  802096:	ff 75 0c             	pushl  0xc(%ebp)
  802099:	6a 58                	push   $0x58
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	ff d0                	call   *%eax
  8020a0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8020a3:	83 ec 08             	sub    $0x8,%esp
  8020a6:	ff 75 0c             	pushl  0xc(%ebp)
  8020a9:	6a 58                	push   $0x58
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	ff d0                	call   *%eax
  8020b0:	83 c4 10             	add    $0x10,%esp
			break;
  8020b3:	e9 bc 00 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8020b8:	83 ec 08             	sub    $0x8,%esp
  8020bb:	ff 75 0c             	pushl  0xc(%ebp)
  8020be:	6a 30                	push   $0x30
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	ff d0                	call   *%eax
  8020c5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8020c8:	83 ec 08             	sub    $0x8,%esp
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	6a 78                	push   $0x78
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	ff d0                	call   *%eax
  8020d5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8020d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8020db:	83 c0 04             	add    $0x4,%eax
  8020de:	89 45 14             	mov    %eax,0x14(%ebp)
  8020e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e4:	83 e8 04             	sub    $0x4,%eax
  8020e7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8020e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8020f3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8020fa:	eb 1f                	jmp    80211b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8020fc:	83 ec 08             	sub    $0x8,%esp
  8020ff:	ff 75 e8             	pushl  -0x18(%ebp)
  802102:	8d 45 14             	lea    0x14(%ebp),%eax
  802105:	50                   	push   %eax
  802106:	e8 e7 fb ff ff       	call   801cf2 <getuint>
  80210b:	83 c4 10             	add    $0x10,%esp
  80210e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802111:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  802114:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80211b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80211f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802122:	83 ec 04             	sub    $0x4,%esp
  802125:	52                   	push   %edx
  802126:	ff 75 e4             	pushl  -0x1c(%ebp)
  802129:	50                   	push   %eax
  80212a:	ff 75 f4             	pushl  -0xc(%ebp)
  80212d:	ff 75 f0             	pushl  -0x10(%ebp)
  802130:	ff 75 0c             	pushl  0xc(%ebp)
  802133:	ff 75 08             	pushl  0x8(%ebp)
  802136:	e8 00 fb ff ff       	call   801c3b <printnum>
  80213b:	83 c4 20             	add    $0x20,%esp
			break;
  80213e:	eb 34                	jmp    802174 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802140:	83 ec 08             	sub    $0x8,%esp
  802143:	ff 75 0c             	pushl  0xc(%ebp)
  802146:	53                   	push   %ebx
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	ff d0                	call   *%eax
  80214c:	83 c4 10             	add    $0x10,%esp
			break;
  80214f:	eb 23                	jmp    802174 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802151:	83 ec 08             	sub    $0x8,%esp
  802154:	ff 75 0c             	pushl  0xc(%ebp)
  802157:	6a 25                	push   $0x25
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	ff d0                	call   *%eax
  80215e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  802161:	ff 4d 10             	decl   0x10(%ebp)
  802164:	eb 03                	jmp    802169 <vprintfmt+0x3b1>
  802166:	ff 4d 10             	decl   0x10(%ebp)
  802169:	8b 45 10             	mov    0x10(%ebp),%eax
  80216c:	48                   	dec    %eax
  80216d:	8a 00                	mov    (%eax),%al
  80216f:	3c 25                	cmp    $0x25,%al
  802171:	75 f3                	jne    802166 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  802173:	90                   	nop
		}
	}
  802174:	e9 47 fc ff ff       	jmp    801dc0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  802179:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80217a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80217d:	5b                   	pop    %ebx
  80217e:	5e                   	pop    %esi
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    

00802181 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802187:	8d 45 10             	lea    0x10(%ebp),%eax
  80218a:	83 c0 04             	add    $0x4,%eax
  80218d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  802190:	8b 45 10             	mov    0x10(%ebp),%eax
  802193:	ff 75 f4             	pushl  -0xc(%ebp)
  802196:	50                   	push   %eax
  802197:	ff 75 0c             	pushl  0xc(%ebp)
  80219a:	ff 75 08             	pushl  0x8(%ebp)
  80219d:	e8 16 fc ff ff       	call   801db8 <vprintfmt>
  8021a2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8021a5:	90                   	nop
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8021ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ae:	8b 40 08             	mov    0x8(%eax),%eax
  8021b1:	8d 50 01             	lea    0x1(%eax),%edx
  8021b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8021ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bd:	8b 10                	mov    (%eax),%edx
  8021bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c2:	8b 40 04             	mov    0x4(%eax),%eax
  8021c5:	39 c2                	cmp    %eax,%edx
  8021c7:	73 12                	jae    8021db <sprintputch+0x33>
		*b->buf++ = ch;
  8021c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cc:	8b 00                	mov    (%eax),%eax
  8021ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8021d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d4:	89 0a                	mov    %ecx,(%edx)
  8021d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d9:	88 10                	mov    %dl,(%eax)
}
  8021db:	90                   	nop
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    

008021de <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	01 d0                	add    %edx,%eax
  8021f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8021ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802203:	74 06                	je     80220b <vsnprintf+0x2d>
  802205:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802209:	7f 07                	jg     802212 <vsnprintf+0x34>
		return -E_INVAL;
  80220b:	b8 03 00 00 00       	mov    $0x3,%eax
  802210:	eb 20                	jmp    802232 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802212:	ff 75 14             	pushl  0x14(%ebp)
  802215:	ff 75 10             	pushl  0x10(%ebp)
  802218:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80221b:	50                   	push   %eax
  80221c:	68 a8 21 80 00       	push   $0x8021a8
  802221:	e8 92 fb ff ff       	call   801db8 <vprintfmt>
  802226:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  802229:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80223a:	8d 45 10             	lea    0x10(%ebp),%eax
  80223d:	83 c0 04             	add    $0x4,%eax
  802240:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  802243:	8b 45 10             	mov    0x10(%ebp),%eax
  802246:	ff 75 f4             	pushl  -0xc(%ebp)
  802249:	50                   	push   %eax
  80224a:	ff 75 0c             	pushl  0xc(%ebp)
  80224d:	ff 75 08             	pushl  0x8(%ebp)
  802250:	e8 89 ff ff ff       	call   8021de <vsnprintf>
  802255:	83 c4 10             	add    $0x10,%esp
  802258:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80225b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802266:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80226d:	eb 06                	jmp    802275 <strlen+0x15>
		n++;
  80226f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802272:	ff 45 08             	incl   0x8(%ebp)
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	8a 00                	mov    (%eax),%al
  80227a:	84 c0                	test   %al,%al
  80227c:	75 f1                	jne    80226f <strlen+0xf>
		n++;
	return n;
  80227e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
  802286:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802290:	eb 09                	jmp    80229b <strnlen+0x18>
		n++;
  802292:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802295:	ff 45 08             	incl   0x8(%ebp)
  802298:	ff 4d 0c             	decl   0xc(%ebp)
  80229b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80229f:	74 09                	je     8022aa <strnlen+0x27>
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	8a 00                	mov    (%eax),%al
  8022a6:	84 c0                	test   %al,%al
  8022a8:	75 e8                	jne    802292 <strnlen+0xf>
		n++;
	return n;
  8022aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8022bb:	90                   	nop
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	8d 50 01             	lea    0x1(%eax),%edx
  8022c2:	89 55 08             	mov    %edx,0x8(%ebp)
  8022c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022cb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8022ce:	8a 12                	mov    (%edx),%dl
  8022d0:	88 10                	mov    %dl,(%eax)
  8022d2:	8a 00                	mov    (%eax),%al
  8022d4:	84 c0                	test   %al,%al
  8022d6:	75 e4                	jne    8022bc <strcpy+0xd>
		/* do nothing */;
	return ret;
  8022d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8022e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8022f0:	eb 1f                	jmp    802311 <strncpy+0x34>
		*dst++ = *src;
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	8d 50 01             	lea    0x1(%eax),%edx
  8022f8:	89 55 08             	mov    %edx,0x8(%ebp)
  8022fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022fe:	8a 12                	mov    (%edx),%dl
  802300:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802302:	8b 45 0c             	mov    0xc(%ebp),%eax
  802305:	8a 00                	mov    (%eax),%al
  802307:	84 c0                	test   %al,%al
  802309:	74 03                	je     80230e <strncpy+0x31>
			src++;
  80230b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80230e:	ff 45 fc             	incl   -0x4(%ebp)
  802311:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802314:	3b 45 10             	cmp    0x10(%ebp),%eax
  802317:	72 d9                	jb     8022f2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802319:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80232a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80232e:	74 30                	je     802360 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802330:	eb 16                	jmp    802348 <strlcpy+0x2a>
			*dst++ = *src++;
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	8d 50 01             	lea    0x1(%eax),%edx
  802338:	89 55 08             	mov    %edx,0x8(%ebp)
  80233b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233e:	8d 4a 01             	lea    0x1(%edx),%ecx
  802341:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802344:	8a 12                	mov    (%edx),%dl
  802346:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802348:	ff 4d 10             	decl   0x10(%ebp)
  80234b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80234f:	74 09                	je     80235a <strlcpy+0x3c>
  802351:	8b 45 0c             	mov    0xc(%ebp),%eax
  802354:	8a 00                	mov    (%eax),%al
  802356:	84 c0                	test   %al,%al
  802358:	75 d8                	jne    802332 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802360:	8b 55 08             	mov    0x8(%ebp),%edx
  802363:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802366:	29 c2                	sub    %eax,%edx
  802368:	89 d0                	mov    %edx,%eax
}
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    

0080236c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80236f:	eb 06                	jmp    802377 <strcmp+0xb>
		p++, q++;
  802371:	ff 45 08             	incl   0x8(%ebp)
  802374:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	8a 00                	mov    (%eax),%al
  80237c:	84 c0                	test   %al,%al
  80237e:	74 0e                	je     80238e <strcmp+0x22>
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	8a 10                	mov    (%eax),%dl
  802385:	8b 45 0c             	mov    0xc(%ebp),%eax
  802388:	8a 00                	mov    (%eax),%al
  80238a:	38 c2                	cmp    %al,%dl
  80238c:	74 e3                	je     802371 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	8a 00                	mov    (%eax),%al
  802393:	0f b6 d0             	movzbl %al,%edx
  802396:	8b 45 0c             	mov    0xc(%ebp),%eax
  802399:	8a 00                	mov    (%eax),%al
  80239b:	0f b6 c0             	movzbl %al,%eax
  80239e:	29 c2                	sub    %eax,%edx
  8023a0:	89 d0                	mov    %edx,%eax
}
  8023a2:	5d                   	pop    %ebp
  8023a3:	c3                   	ret    

008023a4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8023a7:	eb 09                	jmp    8023b2 <strncmp+0xe>
		n--, p++, q++;
  8023a9:	ff 4d 10             	decl   0x10(%ebp)
  8023ac:	ff 45 08             	incl   0x8(%ebp)
  8023af:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8023b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023b6:	74 17                	je     8023cf <strncmp+0x2b>
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8a 00                	mov    (%eax),%al
  8023bd:	84 c0                	test   %al,%al
  8023bf:	74 0e                	je     8023cf <strncmp+0x2b>
  8023c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c4:	8a 10                	mov    (%eax),%dl
  8023c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c9:	8a 00                	mov    (%eax),%al
  8023cb:	38 c2                	cmp    %al,%dl
  8023cd:	74 da                	je     8023a9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8023cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023d3:	75 07                	jne    8023dc <strncmp+0x38>
		return 0;
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023da:	eb 14                	jmp    8023f0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	8a 00                	mov    (%eax),%al
  8023e1:	0f b6 d0             	movzbl %al,%edx
  8023e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e7:	8a 00                	mov    (%eax),%al
  8023e9:	0f b6 c0             	movzbl %al,%eax
  8023ec:	29 c2                	sub    %eax,%edx
  8023ee:	89 d0                	mov    %edx,%eax
}
  8023f0:	5d                   	pop    %ebp
  8023f1:	c3                   	ret    

008023f2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 04             	sub    $0x4,%esp
  8023f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8023fe:	eb 12                	jmp    802412 <strchr+0x20>
		if (*s == c)
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	8a 00                	mov    (%eax),%al
  802405:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802408:	75 05                	jne    80240f <strchr+0x1d>
			return (char *) s;
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	eb 11                	jmp    802420 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80240f:	ff 45 08             	incl   0x8(%ebp)
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	8a 00                	mov    (%eax),%al
  802417:	84 c0                	test   %al,%al
  802419:	75 e5                	jne    802400 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80241b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	83 ec 04             	sub    $0x4,%esp
  802428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80242e:	eb 0d                	jmp    80243d <strfind+0x1b>
		if (*s == c)
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	8a 00                	mov    (%eax),%al
  802435:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802438:	74 0e                	je     802448 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80243a:	ff 45 08             	incl   0x8(%ebp)
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	8a 00                	mov    (%eax),%al
  802442:	84 c0                	test   %al,%al
  802444:	75 ea                	jne    802430 <strfind+0xe>
  802446:	eb 01                	jmp    802449 <strfind+0x27>
		if (*s == c)
			break;
  802448:	90                   	nop
	return (char *) s;
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80245a:	8b 45 10             	mov    0x10(%ebp),%eax
  80245d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  802460:	eb 0e                	jmp    802470 <memset+0x22>
		*p++ = c;
  802462:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802465:	8d 50 01             	lea    0x1(%eax),%edx
  802468:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80246b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  802470:	ff 4d f8             	decl   -0x8(%ebp)
  802473:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802477:	79 e9                	jns    802462 <memset+0x14>
		*p++ = c;

	return v;
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
  802481:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802484:	8b 45 0c             	mov    0xc(%ebp),%eax
  802487:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  802490:	eb 16                	jmp    8024a8 <memcpy+0x2a>
		*d++ = *s++;
  802492:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802495:	8d 50 01             	lea    0x1(%eax),%edx
  802498:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80249b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80249e:	8d 4a 01             	lea    0x1(%edx),%ecx
  8024a1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8024a4:	8a 12                	mov    (%edx),%dl
  8024a6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8024a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	75 dd                	jne    802492 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8024c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8024cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8024d2:	73 50                	jae    802524 <memmove+0x6a>
  8024d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8024da:	01 d0                	add    %edx,%eax
  8024dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8024df:	76 43                	jbe    802524 <memmove+0x6a>
		s += n;
  8024e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8024e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ea:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8024ed:	eb 10                	jmp    8024ff <memmove+0x45>
			*--d = *--s;
  8024ef:	ff 4d f8             	decl   -0x8(%ebp)
  8024f2:	ff 4d fc             	decl   -0x4(%ebp)
  8024f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024f8:	8a 10                	mov    (%eax),%dl
  8024fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024fd:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8024ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802502:	8d 50 ff             	lea    -0x1(%eax),%edx
  802505:	89 55 10             	mov    %edx,0x10(%ebp)
  802508:	85 c0                	test   %eax,%eax
  80250a:	75 e3                	jne    8024ef <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80250c:	eb 23                	jmp    802531 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80250e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802511:	8d 50 01             	lea    0x1(%eax),%edx
  802514:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802517:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80251a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80251d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802520:	8a 12                	mov    (%edx),%dl
  802522:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802524:	8b 45 10             	mov    0x10(%ebp),%eax
  802527:	8d 50 ff             	lea    -0x1(%eax),%edx
  80252a:	89 55 10             	mov    %edx,0x10(%ebp)
  80252d:	85 c0                	test   %eax,%eax
  80252f:	75 dd                	jne    80250e <memmove+0x54>
			*d++ = *s++;

	return dst;
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
  802539:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80253c:	8b 45 08             	mov    0x8(%ebp),%eax
  80253f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802542:	8b 45 0c             	mov    0xc(%ebp),%eax
  802545:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802548:	eb 2a                	jmp    802574 <memcmp+0x3e>
		if (*s1 != *s2)
  80254a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80254d:	8a 10                	mov    (%eax),%dl
  80254f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802552:	8a 00                	mov    (%eax),%al
  802554:	38 c2                	cmp    %al,%dl
  802556:	74 16                	je     80256e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802558:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80255b:	8a 00                	mov    (%eax),%al
  80255d:	0f b6 d0             	movzbl %al,%edx
  802560:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802563:	8a 00                	mov    (%eax),%al
  802565:	0f b6 c0             	movzbl %al,%eax
  802568:	29 c2                	sub    %eax,%edx
  80256a:	89 d0                	mov    %edx,%eax
  80256c:	eb 18                	jmp    802586 <memcmp+0x50>
		s1++, s2++;
  80256e:	ff 45 fc             	incl   -0x4(%ebp)
  802571:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802574:	8b 45 10             	mov    0x10(%ebp),%eax
  802577:	8d 50 ff             	lea    -0x1(%eax),%edx
  80257a:	89 55 10             	mov    %edx,0x10(%ebp)
  80257d:	85 c0                	test   %eax,%eax
  80257f:	75 c9                	jne    80254a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802586:	c9                   	leave  
  802587:	c3                   	ret    

00802588 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802588:	55                   	push   %ebp
  802589:	89 e5                	mov    %esp,%ebp
  80258b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80258e:	8b 55 08             	mov    0x8(%ebp),%edx
  802591:	8b 45 10             	mov    0x10(%ebp),%eax
  802594:	01 d0                	add    %edx,%eax
  802596:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802599:	eb 15                	jmp    8025b0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80259b:	8b 45 08             	mov    0x8(%ebp),%eax
  80259e:	8a 00                	mov    (%eax),%al
  8025a0:	0f b6 d0             	movzbl %al,%edx
  8025a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a6:	0f b6 c0             	movzbl %al,%eax
  8025a9:	39 c2                	cmp    %eax,%edx
  8025ab:	74 0d                	je     8025ba <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8025ad:	ff 45 08             	incl   0x8(%ebp)
  8025b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8025b6:	72 e3                	jb     80259b <memfind+0x13>
  8025b8:	eb 01                	jmp    8025bb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8025ba:	90                   	nop
	return (void *) s;
  8025bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8025be:	c9                   	leave  
  8025bf:	c3                   	ret    

008025c0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8025c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8025cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025d4:	eb 03                	jmp    8025d9 <strtol+0x19>
		s++;
  8025d6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	8a 00                	mov    (%eax),%al
  8025de:	3c 20                	cmp    $0x20,%al
  8025e0:	74 f4                	je     8025d6 <strtol+0x16>
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	8a 00                	mov    (%eax),%al
  8025e7:	3c 09                	cmp    $0x9,%al
  8025e9:	74 eb                	je     8025d6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	8a 00                	mov    (%eax),%al
  8025f0:	3c 2b                	cmp    $0x2b,%al
  8025f2:	75 05                	jne    8025f9 <strtol+0x39>
		s++;
  8025f4:	ff 45 08             	incl   0x8(%ebp)
  8025f7:	eb 13                	jmp    80260c <strtol+0x4c>
	else if (*s == '-')
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	8a 00                	mov    (%eax),%al
  8025fe:	3c 2d                	cmp    $0x2d,%al
  802600:	75 0a                	jne    80260c <strtol+0x4c>
		s++, neg = 1;
  802602:	ff 45 08             	incl   0x8(%ebp)
  802605:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80260c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802610:	74 06                	je     802618 <strtol+0x58>
  802612:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802616:	75 20                	jne    802638 <strtol+0x78>
  802618:	8b 45 08             	mov    0x8(%ebp),%eax
  80261b:	8a 00                	mov    (%eax),%al
  80261d:	3c 30                	cmp    $0x30,%al
  80261f:	75 17                	jne    802638 <strtol+0x78>
  802621:	8b 45 08             	mov    0x8(%ebp),%eax
  802624:	40                   	inc    %eax
  802625:	8a 00                	mov    (%eax),%al
  802627:	3c 78                	cmp    $0x78,%al
  802629:	75 0d                	jne    802638 <strtol+0x78>
		s += 2, base = 16;
  80262b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80262f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802636:	eb 28                	jmp    802660 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802638:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80263c:	75 15                	jne    802653 <strtol+0x93>
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	8a 00                	mov    (%eax),%al
  802643:	3c 30                	cmp    $0x30,%al
  802645:	75 0c                	jne    802653 <strtol+0x93>
		s++, base = 8;
  802647:	ff 45 08             	incl   0x8(%ebp)
  80264a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802651:	eb 0d                	jmp    802660 <strtol+0xa0>
	else if (base == 0)
  802653:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802657:	75 07                	jne    802660 <strtol+0xa0>
		base = 10;
  802659:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	8a 00                	mov    (%eax),%al
  802665:	3c 2f                	cmp    $0x2f,%al
  802667:	7e 19                	jle    802682 <strtol+0xc2>
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	8a 00                	mov    (%eax),%al
  80266e:	3c 39                	cmp    $0x39,%al
  802670:	7f 10                	jg     802682 <strtol+0xc2>
			dig = *s - '0';
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	8a 00                	mov    (%eax),%al
  802677:	0f be c0             	movsbl %al,%eax
  80267a:	83 e8 30             	sub    $0x30,%eax
  80267d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802680:	eb 42                	jmp    8026c4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	8a 00                	mov    (%eax),%al
  802687:	3c 60                	cmp    $0x60,%al
  802689:	7e 19                	jle    8026a4 <strtol+0xe4>
  80268b:	8b 45 08             	mov    0x8(%ebp),%eax
  80268e:	8a 00                	mov    (%eax),%al
  802690:	3c 7a                	cmp    $0x7a,%al
  802692:	7f 10                	jg     8026a4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	8a 00                	mov    (%eax),%al
  802699:	0f be c0             	movsbl %al,%eax
  80269c:	83 e8 57             	sub    $0x57,%eax
  80269f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a2:	eb 20                	jmp    8026c4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	8a 00                	mov    (%eax),%al
  8026a9:	3c 40                	cmp    $0x40,%al
  8026ab:	7e 39                	jle    8026e6 <strtol+0x126>
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	8a 00                	mov    (%eax),%al
  8026b2:	3c 5a                	cmp    $0x5a,%al
  8026b4:	7f 30                	jg     8026e6 <strtol+0x126>
			dig = *s - 'A' + 10;
  8026b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b9:	8a 00                	mov    (%eax),%al
  8026bb:	0f be c0             	movsbl %al,%eax
  8026be:	83 e8 37             	sub    $0x37,%eax
  8026c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8026ca:	7d 19                	jge    8026e5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8026cc:	ff 45 08             	incl   0x8(%ebp)
  8026cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026d2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8026d6:	89 c2                	mov    %eax,%edx
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	01 d0                	add    %edx,%eax
  8026dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8026e0:	e9 7b ff ff ff       	jmp    802660 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8026e5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8026e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026ea:	74 08                	je     8026f4 <strtol+0x134>
		*endptr = (char *) s;
  8026ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8026f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026f8:	74 07                	je     802701 <strtol+0x141>
  8026fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026fd:	f7 d8                	neg    %eax
  8026ff:	eb 03                	jmp    802704 <strtol+0x144>
  802701:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <ltostr>:

void
ltostr(long value, char *str)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80270c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802713:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80271a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80271e:	79 13                	jns    802733 <ltostr+0x2d>
	{
		neg = 1;
  802720:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802727:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80272d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802730:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802733:	8b 45 08             	mov    0x8(%ebp),%eax
  802736:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80273b:	99                   	cltd   
  80273c:	f7 f9                	idiv   %ecx
  80273e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802741:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802744:	8d 50 01             	lea    0x1(%eax),%edx
  802747:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80274a:	89 c2                	mov    %eax,%edx
  80274c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80274f:	01 d0                	add    %edx,%eax
  802751:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802754:	83 c2 30             	add    $0x30,%edx
  802757:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802759:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80275c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802761:	f7 e9                	imul   %ecx
  802763:	c1 fa 02             	sar    $0x2,%edx
  802766:	89 c8                	mov    %ecx,%eax
  802768:	c1 f8 1f             	sar    $0x1f,%eax
  80276b:	29 c2                	sub    %eax,%edx
  80276d:	89 d0                	mov    %edx,%eax
  80276f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802772:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802775:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80277a:	f7 e9                	imul   %ecx
  80277c:	c1 fa 02             	sar    $0x2,%edx
  80277f:	89 c8                	mov    %ecx,%eax
  802781:	c1 f8 1f             	sar    $0x1f,%eax
  802784:	29 c2                	sub    %eax,%edx
  802786:	89 d0                	mov    %edx,%eax
  802788:	c1 e0 02             	shl    $0x2,%eax
  80278b:	01 d0                	add    %edx,%eax
  80278d:	01 c0                	add    %eax,%eax
  80278f:	29 c1                	sub    %eax,%ecx
  802791:	89 ca                	mov    %ecx,%edx
  802793:	85 d2                	test   %edx,%edx
  802795:	75 9c                	jne    802733 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802797:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80279e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027a1:	48                   	dec    %eax
  8027a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8027a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027a9:	74 3d                	je     8027e8 <ltostr+0xe2>
		start = 1 ;
  8027ab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8027b2:	eb 34                	jmp    8027e8 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8027b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ba:	01 d0                	add    %edx,%eax
  8027bc:	8a 00                	mov    (%eax),%al
  8027be:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8027c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c7:	01 c2                	add    %eax,%edx
  8027c9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8027cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027cf:	01 c8                	add    %ecx,%eax
  8027d1:	8a 00                	mov    (%eax),%al
  8027d3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8027d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027db:	01 c2                	add    %eax,%edx
  8027dd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8027e0:	88 02                	mov    %al,(%edx)
		start++ ;
  8027e2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8027e5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027ee:	7c c4                	jl     8027b4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8027f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8027f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f6:	01 d0                	add    %edx,%eax
  8027f8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8027fb:	90                   	nop
  8027fc:	c9                   	leave  
  8027fd:	c3                   	ret    

008027fe <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
  802801:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802804:	ff 75 08             	pushl  0x8(%ebp)
  802807:	e8 54 fa ff ff       	call   802260 <strlen>
  80280c:	83 c4 04             	add    $0x4,%esp
  80280f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802812:	ff 75 0c             	pushl  0xc(%ebp)
  802815:	e8 46 fa ff ff       	call   802260 <strlen>
  80281a:	83 c4 04             	add    $0x4,%esp
  80281d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802820:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802827:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80282e:	eb 17                	jmp    802847 <strcconcat+0x49>
		final[s] = str1[s] ;
  802830:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802833:	8b 45 10             	mov    0x10(%ebp),%eax
  802836:	01 c2                	add    %eax,%edx
  802838:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	01 c8                	add    %ecx,%eax
  802840:	8a 00                	mov    (%eax),%al
  802842:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802844:	ff 45 fc             	incl   -0x4(%ebp)
  802847:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80284a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80284d:	7c e1                	jl     802830 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80284f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802856:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80285d:	eb 1f                	jmp    80287e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80285f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802862:	8d 50 01             	lea    0x1(%eax),%edx
  802865:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802868:	89 c2                	mov    %eax,%edx
  80286a:	8b 45 10             	mov    0x10(%ebp),%eax
  80286d:	01 c2                	add    %eax,%edx
  80286f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802872:	8b 45 0c             	mov    0xc(%ebp),%eax
  802875:	01 c8                	add    %ecx,%eax
  802877:	8a 00                	mov    (%eax),%al
  802879:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80287b:	ff 45 f8             	incl   -0x8(%ebp)
  80287e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802881:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802884:	7c d9                	jl     80285f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802886:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802889:	8b 45 10             	mov    0x10(%ebp),%eax
  80288c:	01 d0                	add    %edx,%eax
  80288e:	c6 00 00             	movb   $0x0,(%eax)
}
  802891:	90                   	nop
  802892:	c9                   	leave  
  802893:	c3                   	ret    

00802894 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802894:	55                   	push   %ebp
  802895:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802897:	8b 45 14             	mov    0x14(%ebp),%eax
  80289a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8028a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8028af:	01 d0                	add    %edx,%eax
  8028b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8028b7:	eb 0c                	jmp    8028c5 <strsplit+0x31>
			*string++ = 0;
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	8d 50 01             	lea    0x1(%eax),%edx
  8028bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8028c2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8028c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c8:	8a 00                	mov    (%eax),%al
  8028ca:	84 c0                	test   %al,%al
  8028cc:	74 18                	je     8028e6 <strsplit+0x52>
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	8a 00                	mov    (%eax),%al
  8028d3:	0f be c0             	movsbl %al,%eax
  8028d6:	50                   	push   %eax
  8028d7:	ff 75 0c             	pushl  0xc(%ebp)
  8028da:	e8 13 fb ff ff       	call   8023f2 <strchr>
  8028df:	83 c4 08             	add    $0x8,%esp
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	75 d3                	jne    8028b9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8028e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e9:	8a 00                	mov    (%eax),%al
  8028eb:	84 c0                	test   %al,%al
  8028ed:	74 5a                	je     802949 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8028ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8028f2:	8b 00                	mov    (%eax),%eax
  8028f4:	83 f8 0f             	cmp    $0xf,%eax
  8028f7:	75 07                	jne    802900 <strsplit+0x6c>
		{
			return 0;
  8028f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fe:	eb 66                	jmp    802966 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802900:	8b 45 14             	mov    0x14(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	8d 48 01             	lea    0x1(%eax),%ecx
  802908:	8b 55 14             	mov    0x14(%ebp),%edx
  80290b:	89 0a                	mov    %ecx,(%edx)
  80290d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802914:	8b 45 10             	mov    0x10(%ebp),%eax
  802917:	01 c2                	add    %eax,%edx
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80291e:	eb 03                	jmp    802923 <strsplit+0x8f>
			string++;
  802920:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	8a 00                	mov    (%eax),%al
  802928:	84 c0                	test   %al,%al
  80292a:	74 8b                	je     8028b7 <strsplit+0x23>
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	8a 00                	mov    (%eax),%al
  802931:	0f be c0             	movsbl %al,%eax
  802934:	50                   	push   %eax
  802935:	ff 75 0c             	pushl  0xc(%ebp)
  802938:	e8 b5 fa ff ff       	call   8023f2 <strchr>
  80293d:	83 c4 08             	add    $0x8,%esp
  802940:	85 c0                	test   %eax,%eax
  802942:	74 dc                	je     802920 <strsplit+0x8c>
			string++;
	}
  802944:	e9 6e ff ff ff       	jmp    8028b7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802949:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80294a:	8b 45 14             	mov    0x14(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802956:	8b 45 10             	mov    0x10(%ebp),%eax
  802959:	01 d0                	add    %edx,%eax
  80295b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802961:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802966:	c9                   	leave  
  802967:	c3                   	ret    

00802968 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802968:	55                   	push   %ebp
  802969:	89 e5                	mov    %esp,%ebp
  80296b:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80296e:	a1 04 60 80 00       	mov    0x806004,%eax
  802973:	85 c0                	test   %eax,%eax
  802975:	74 1f                	je     802996 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  802977:	e8 1d 00 00 00       	call   802999 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80297c:	83 ec 0c             	sub    $0xc,%esp
  80297f:	68 50 54 80 00       	push   $0x805450
  802984:	e8 55 f2 ff ff       	call   801bde <cprintf>
  802989:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80298c:	c7 05 04 60 80 00 00 	movl   $0x0,0x806004
  802993:	00 00 00 
	}
}
  802996:	90                   	nop
  802997:	c9                   	leave  
  802998:	c3                   	ret    

00802999 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802999:	55                   	push   %ebp
  80299a:	89 e5                	mov    %esp,%ebp
  80299c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  80299f:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  8029a6:	00 00 00 
  8029a9:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  8029b0:	00 00 00 
  8029b3:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8029ba:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8029bd:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  8029c4:	00 00 00 
  8029c7:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  8029ce:	00 00 00 
  8029d1:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  8029d8:	00 00 00 
	uint32 arr_size = 0;
  8029db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  8029e2:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8029e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8029f1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8029f6:	a3 50 60 80 00       	mov    %eax,0x806050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8029fb:	c7 05 20 61 80 00 00 	movl   $0x20000,0x806120
  802a02:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  802a05:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a0c:	a1 20 61 80 00       	mov    0x806120,%eax
  802a11:	c1 e0 04             	shl    $0x4,%eax
  802a14:	89 c2                	mov    %eax,%edx
  802a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a19:	01 d0                	add    %edx,%eax
  802a1b:	48                   	dec    %eax
  802a1c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a22:	ba 00 00 00 00       	mov    $0x0,%edx
  802a27:	f7 75 ec             	divl   -0x14(%ebp)
  802a2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2d:	29 d0                	sub    %edx,%eax
  802a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  802a32:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  802a39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a3c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802a41:	2d 00 10 00 00       	sub    $0x1000,%eax
  802a46:	83 ec 04             	sub    $0x4,%esp
  802a49:	6a 06                	push   $0x6
  802a4b:	ff 75 f4             	pushl  -0xc(%ebp)
  802a4e:	50                   	push   %eax
  802a4f:	e8 6a 04 00 00       	call   802ebe <sys_allocate_chunk>
  802a54:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802a57:	a1 20 61 80 00       	mov    0x806120,%eax
  802a5c:	83 ec 0c             	sub    $0xc,%esp
  802a5f:	50                   	push   %eax
  802a60:	e8 df 0a 00 00       	call   803544 <initialize_MemBlocksList>
  802a65:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a68:	a1 48 61 80 00       	mov    0x806148,%eax
  802a6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  802a70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a73:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  802a7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a7d:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  802a84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a88:	75 14                	jne    802a9e <initialize_dyn_block_system+0x105>
  802a8a:	83 ec 04             	sub    $0x4,%esp
  802a8d:	68 75 54 80 00       	push   $0x805475
  802a92:	6a 33                	push   $0x33
  802a94:	68 93 54 80 00       	push   $0x805493
  802a99:	e8 8c ee ff ff       	call   80192a <_panic>
  802a9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa1:	8b 00                	mov    (%eax),%eax
  802aa3:	85 c0                	test   %eax,%eax
  802aa5:	74 10                	je     802ab7 <initialize_dyn_block_system+0x11e>
  802aa7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802aaf:	8b 52 04             	mov    0x4(%edx),%edx
  802ab2:	89 50 04             	mov    %edx,0x4(%eax)
  802ab5:	eb 0b                	jmp    802ac2 <initialize_dyn_block_system+0x129>
  802ab7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aba:	8b 40 04             	mov    0x4(%eax),%eax
  802abd:	a3 4c 61 80 00       	mov    %eax,0x80614c
  802ac2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac5:	8b 40 04             	mov    0x4(%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 0f                	je     802adb <initialize_dyn_block_system+0x142>
  802acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802acf:	8b 40 04             	mov    0x4(%eax),%eax
  802ad2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ad5:	8b 12                	mov    (%edx),%edx
  802ad7:	89 10                	mov    %edx,(%eax)
  802ad9:	eb 0a                	jmp    802ae5 <initialize_dyn_block_system+0x14c>
  802adb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ade:	8b 00                	mov    (%eax),%eax
  802ae0:	a3 48 61 80 00       	mov    %eax,0x806148
  802ae5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af8:	a1 54 61 80 00       	mov    0x806154,%eax
  802afd:	48                   	dec    %eax
  802afe:	a3 54 61 80 00       	mov    %eax,0x806154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  802b03:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b07:	75 14                	jne    802b1d <initialize_dyn_block_system+0x184>
  802b09:	83 ec 04             	sub    $0x4,%esp
  802b0c:	68 a0 54 80 00       	push   $0x8054a0
  802b11:	6a 34                	push   $0x34
  802b13:	68 93 54 80 00       	push   $0x805493
  802b18:	e8 0d ee ff ff       	call   80192a <_panic>
  802b1d:	8b 15 38 61 80 00    	mov    0x806138,%edx
  802b23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b26:	89 10                	mov    %edx,(%eax)
  802b28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	74 0d                	je     802b3e <initialize_dyn_block_system+0x1a5>
  802b31:	a1 38 61 80 00       	mov    0x806138,%eax
  802b36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b39:	89 50 04             	mov    %edx,0x4(%eax)
  802b3c:	eb 08                	jmp    802b46 <initialize_dyn_block_system+0x1ad>
  802b3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b41:	a3 3c 61 80 00       	mov    %eax,0x80613c
  802b46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b49:	a3 38 61 80 00       	mov    %eax,0x806138
  802b4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b58:	a1 44 61 80 00       	mov    0x806144,%eax
  802b5d:	40                   	inc    %eax
  802b5e:	a3 44 61 80 00       	mov    %eax,0x806144
}
  802b63:	90                   	nop
  802b64:	c9                   	leave  
  802b65:	c3                   	ret    

00802b66 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802b66:	55                   	push   %ebp
  802b67:	89 e5                	mov    %esp,%ebp
  802b69:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802b6c:	e8 f7 fd ff ff       	call   802968 <InitializeUHeap>
	if (size == 0) return NULL ;
  802b71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b75:	75 07                	jne    802b7e <malloc+0x18>
  802b77:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7c:	eb 61                	jmp    802bdf <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  802b7e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802b85:	8b 55 08             	mov    0x8(%ebp),%edx
  802b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8b:	01 d0                	add    %edx,%eax
  802b8d:	48                   	dec    %eax
  802b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b94:	ba 00 00 00 00       	mov    $0x0,%edx
  802b99:	f7 75 f0             	divl   -0x10(%ebp)
  802b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9f:	29 d0                	sub    %edx,%eax
  802ba1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802ba4:	e8 e3 06 00 00       	call   80328c <sys_isUHeapPlacementStrategyFIRSTFIT>
  802ba9:	85 c0                	test   %eax,%eax
  802bab:	74 11                	je     802bbe <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  802bad:	83 ec 0c             	sub    $0xc,%esp
  802bb0:	ff 75 e8             	pushl  -0x18(%ebp)
  802bb3:	e8 4e 0d 00 00       	call   803906 <alloc_block_FF>
  802bb8:	83 c4 10             	add    $0x10,%esp
  802bbb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  802bbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc2:	74 16                	je     802bda <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  802bc4:	83 ec 0c             	sub    $0xc,%esp
  802bc7:	ff 75 f4             	pushl  -0xc(%ebp)
  802bca:	e8 aa 0a 00 00       	call   803679 <insert_sorted_allocList>
  802bcf:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 40 08             	mov    0x8(%eax),%eax
  802bd8:	eb 05                	jmp    802bdf <malloc+0x79>
	}

    return NULL;
  802bda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bdf:	c9                   	leave  
  802be0:	c3                   	ret    

00802be1 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802be1:	55                   	push   %ebp
  802be2:	89 e5                	mov    %esp,%ebp
  802be4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  802be7:	83 ec 04             	sub    $0x4,%esp
  802bea:	68 c4 54 80 00       	push   $0x8054c4
  802bef:	6a 6f                	push   $0x6f
  802bf1:	68 93 54 80 00       	push   $0x805493
  802bf6:	e8 2f ed ff ff       	call   80192a <_panic>

00802bfb <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802bfb:	55                   	push   %ebp
  802bfc:	89 e5                	mov    %esp,%ebp
  802bfe:	83 ec 38             	sub    $0x38,%esp
  802c01:	8b 45 10             	mov    0x10(%ebp),%eax
  802c04:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802c07:	e8 5c fd ff ff       	call   802968 <InitializeUHeap>
	if (size == 0) return NULL ;
  802c0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c10:	75 07                	jne    802c19 <smalloc+0x1e>
  802c12:	b8 00 00 00 00       	mov    $0x0,%eax
  802c17:	eb 7c                	jmp    802c95 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802c19:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c26:	01 d0                	add    %edx,%eax
  802c28:	48                   	dec    %eax
  802c29:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  802c34:	f7 75 f0             	divl   -0x10(%ebp)
  802c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3a:	29 d0                	sub    %edx,%eax
  802c3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  802c3f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802c46:	e8 41 06 00 00       	call   80328c <sys_isUHeapPlacementStrategyFIRSTFIT>
  802c4b:	85 c0                	test   %eax,%eax
  802c4d:	74 11                	je     802c60 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  802c4f:	83 ec 0c             	sub    $0xc,%esp
  802c52:	ff 75 e8             	pushl  -0x18(%ebp)
  802c55:	e8 ac 0c 00 00       	call   803906 <alloc_block_FF>
  802c5a:	83 c4 10             	add    $0x10,%esp
  802c5d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  802c60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c64:	74 2a                	je     802c90 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 40 08             	mov    0x8(%eax),%eax
  802c6c:	89 c2                	mov    %eax,%edx
  802c6e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802c72:	52                   	push   %edx
  802c73:	50                   	push   %eax
  802c74:	ff 75 0c             	pushl  0xc(%ebp)
  802c77:	ff 75 08             	pushl  0x8(%ebp)
  802c7a:	e8 92 03 00 00       	call   803011 <sys_createSharedObject>
  802c7f:	83 c4 10             	add    $0x10,%esp
  802c82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  802c85:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802c89:	74 05                	je     802c90 <smalloc+0x95>
			return (void*)virtual_address;
  802c8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c8e:	eb 05                	jmp    802c95 <smalloc+0x9a>
	}
	return NULL;
  802c90:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802c95:	c9                   	leave  
  802c96:	c3                   	ret    

00802c97 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802c97:	55                   	push   %ebp
  802c98:	89 e5                	mov    %esp,%ebp
  802c9a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802c9d:	e8 c6 fc ff ff       	call   802968 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802ca2:	83 ec 04             	sub    $0x4,%esp
  802ca5:	68 e8 54 80 00       	push   $0x8054e8
  802caa:	68 b0 00 00 00       	push   $0xb0
  802caf:	68 93 54 80 00       	push   $0x805493
  802cb4:	e8 71 ec ff ff       	call   80192a <_panic>

00802cb9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802cb9:	55                   	push   %ebp
  802cba:	89 e5                	mov    %esp,%ebp
  802cbc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802cbf:	e8 a4 fc ff ff       	call   802968 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802cc4:	83 ec 04             	sub    $0x4,%esp
  802cc7:	68 0c 55 80 00       	push   $0x80550c
  802ccc:	68 f4 00 00 00       	push   $0xf4
  802cd1:	68 93 54 80 00       	push   $0x805493
  802cd6:	e8 4f ec ff ff       	call   80192a <_panic>

00802cdb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802cdb:	55                   	push   %ebp
  802cdc:	89 e5                	mov    %esp,%ebp
  802cde:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802ce1:	83 ec 04             	sub    $0x4,%esp
  802ce4:	68 34 55 80 00       	push   $0x805534
  802ce9:	68 08 01 00 00       	push   $0x108
  802cee:	68 93 54 80 00       	push   $0x805493
  802cf3:	e8 32 ec ff ff       	call   80192a <_panic>

00802cf8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802cf8:	55                   	push   %ebp
  802cf9:	89 e5                	mov    %esp,%ebp
  802cfb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802cfe:	83 ec 04             	sub    $0x4,%esp
  802d01:	68 58 55 80 00       	push   $0x805558
  802d06:	68 13 01 00 00       	push   $0x113
  802d0b:	68 93 54 80 00       	push   $0x805493
  802d10:	e8 15 ec ff ff       	call   80192a <_panic>

00802d15 <shrink>:

}
void shrink(uint32 newSize)
{
  802d15:	55                   	push   %ebp
  802d16:	89 e5                	mov    %esp,%ebp
  802d18:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802d1b:	83 ec 04             	sub    $0x4,%esp
  802d1e:	68 58 55 80 00       	push   $0x805558
  802d23:	68 18 01 00 00       	push   $0x118
  802d28:	68 93 54 80 00       	push   $0x805493
  802d2d:	e8 f8 eb ff ff       	call   80192a <_panic>

00802d32 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802d32:	55                   	push   %ebp
  802d33:	89 e5                	mov    %esp,%ebp
  802d35:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802d38:	83 ec 04             	sub    $0x4,%esp
  802d3b:	68 58 55 80 00       	push   $0x805558
  802d40:	68 1d 01 00 00       	push   $0x11d
  802d45:	68 93 54 80 00       	push   $0x805493
  802d4a:	e8 db eb ff ff       	call   80192a <_panic>

00802d4f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802d4f:	55                   	push   %ebp
  802d50:	89 e5                	mov    %esp,%ebp
  802d52:	57                   	push   %edi
  802d53:	56                   	push   %esi
  802d54:	53                   	push   %ebx
  802d55:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d61:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d64:	8b 7d 18             	mov    0x18(%ebp),%edi
  802d67:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802d6a:	cd 30                	int    $0x30
  802d6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802d72:	83 c4 10             	add    $0x10,%esp
  802d75:	5b                   	pop    %ebx
  802d76:	5e                   	pop    %esi
  802d77:	5f                   	pop    %edi
  802d78:	5d                   	pop    %ebp
  802d79:	c3                   	ret    

00802d7a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802d7a:	55                   	push   %ebp
  802d7b:	89 e5                	mov    %esp,%ebp
  802d7d:	83 ec 04             	sub    $0x4,%esp
  802d80:	8b 45 10             	mov    0x10(%ebp),%eax
  802d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802d86:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	6a 00                	push   $0x0
  802d8f:	6a 00                	push   $0x0
  802d91:	52                   	push   %edx
  802d92:	ff 75 0c             	pushl  0xc(%ebp)
  802d95:	50                   	push   %eax
  802d96:	6a 00                	push   $0x0
  802d98:	e8 b2 ff ff ff       	call   802d4f <syscall>
  802d9d:	83 c4 18             	add    $0x18,%esp
}
  802da0:	90                   	nop
  802da1:	c9                   	leave  
  802da2:	c3                   	ret    

00802da3 <sys_cgetc>:

int
sys_cgetc(void)
{
  802da3:	55                   	push   %ebp
  802da4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802da6:	6a 00                	push   $0x0
  802da8:	6a 00                	push   $0x0
  802daa:	6a 00                	push   $0x0
  802dac:	6a 00                	push   $0x0
  802dae:	6a 00                	push   $0x0
  802db0:	6a 01                	push   $0x1
  802db2:	e8 98 ff ff ff       	call   802d4f <syscall>
  802db7:	83 c4 18             	add    $0x18,%esp
}
  802dba:	c9                   	leave  
  802dbb:	c3                   	ret    

00802dbc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802dbc:	55                   	push   %ebp
  802dbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	6a 00                	push   $0x0
  802dc7:	6a 00                	push   $0x0
  802dc9:	6a 00                	push   $0x0
  802dcb:	52                   	push   %edx
  802dcc:	50                   	push   %eax
  802dcd:	6a 05                	push   $0x5
  802dcf:	e8 7b ff ff ff       	call   802d4f <syscall>
  802dd4:	83 c4 18             	add    $0x18,%esp
}
  802dd7:	c9                   	leave  
  802dd8:	c3                   	ret    

00802dd9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802dd9:	55                   	push   %ebp
  802dda:	89 e5                	mov    %esp,%ebp
  802ddc:	56                   	push   %esi
  802ddd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802dde:	8b 75 18             	mov    0x18(%ebp),%esi
  802de1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802de4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802de7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ded:	56                   	push   %esi
  802dee:	53                   	push   %ebx
  802def:	51                   	push   %ecx
  802df0:	52                   	push   %edx
  802df1:	50                   	push   %eax
  802df2:	6a 06                	push   $0x6
  802df4:	e8 56 ff ff ff       	call   802d4f <syscall>
  802df9:	83 c4 18             	add    $0x18,%esp
}
  802dfc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802dff:	5b                   	pop    %ebx
  802e00:	5e                   	pop    %esi
  802e01:	5d                   	pop    %ebp
  802e02:	c3                   	ret    

00802e03 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802e03:	55                   	push   %ebp
  802e04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802e06:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	6a 00                	push   $0x0
  802e0e:	6a 00                	push   $0x0
  802e10:	6a 00                	push   $0x0
  802e12:	52                   	push   %edx
  802e13:	50                   	push   %eax
  802e14:	6a 07                	push   $0x7
  802e16:	e8 34 ff ff ff       	call   802d4f <syscall>
  802e1b:	83 c4 18             	add    $0x18,%esp
}
  802e1e:	c9                   	leave  
  802e1f:	c3                   	ret    

00802e20 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802e20:	55                   	push   %ebp
  802e21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802e23:	6a 00                	push   $0x0
  802e25:	6a 00                	push   $0x0
  802e27:	6a 00                	push   $0x0
  802e29:	ff 75 0c             	pushl  0xc(%ebp)
  802e2c:	ff 75 08             	pushl  0x8(%ebp)
  802e2f:	6a 08                	push   $0x8
  802e31:	e8 19 ff ff ff       	call   802d4f <syscall>
  802e36:	83 c4 18             	add    $0x18,%esp
}
  802e39:	c9                   	leave  
  802e3a:	c3                   	ret    

00802e3b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802e3b:	55                   	push   %ebp
  802e3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802e3e:	6a 00                	push   $0x0
  802e40:	6a 00                	push   $0x0
  802e42:	6a 00                	push   $0x0
  802e44:	6a 00                	push   $0x0
  802e46:	6a 00                	push   $0x0
  802e48:	6a 09                	push   $0x9
  802e4a:	e8 00 ff ff ff       	call   802d4f <syscall>
  802e4f:	83 c4 18             	add    $0x18,%esp
}
  802e52:	c9                   	leave  
  802e53:	c3                   	ret    

00802e54 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802e54:	55                   	push   %ebp
  802e55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802e57:	6a 00                	push   $0x0
  802e59:	6a 00                	push   $0x0
  802e5b:	6a 00                	push   $0x0
  802e5d:	6a 00                	push   $0x0
  802e5f:	6a 00                	push   $0x0
  802e61:	6a 0a                	push   $0xa
  802e63:	e8 e7 fe ff ff       	call   802d4f <syscall>
  802e68:	83 c4 18             	add    $0x18,%esp
}
  802e6b:	c9                   	leave  
  802e6c:	c3                   	ret    

00802e6d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802e6d:	55                   	push   %ebp
  802e6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802e70:	6a 00                	push   $0x0
  802e72:	6a 00                	push   $0x0
  802e74:	6a 00                	push   $0x0
  802e76:	6a 00                	push   $0x0
  802e78:	6a 00                	push   $0x0
  802e7a:	6a 0b                	push   $0xb
  802e7c:	e8 ce fe ff ff       	call   802d4f <syscall>
  802e81:	83 c4 18             	add    $0x18,%esp
}
  802e84:	c9                   	leave  
  802e85:	c3                   	ret    

00802e86 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802e86:	55                   	push   %ebp
  802e87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802e89:	6a 00                	push   $0x0
  802e8b:	6a 00                	push   $0x0
  802e8d:	6a 00                	push   $0x0
  802e8f:	ff 75 0c             	pushl  0xc(%ebp)
  802e92:	ff 75 08             	pushl  0x8(%ebp)
  802e95:	6a 0f                	push   $0xf
  802e97:	e8 b3 fe ff ff       	call   802d4f <syscall>
  802e9c:	83 c4 18             	add    $0x18,%esp
	return;
  802e9f:	90                   	nop
}
  802ea0:	c9                   	leave  
  802ea1:	c3                   	ret    

00802ea2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802ea2:	55                   	push   %ebp
  802ea3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802ea5:	6a 00                	push   $0x0
  802ea7:	6a 00                	push   $0x0
  802ea9:	6a 00                	push   $0x0
  802eab:	ff 75 0c             	pushl  0xc(%ebp)
  802eae:	ff 75 08             	pushl  0x8(%ebp)
  802eb1:	6a 10                	push   $0x10
  802eb3:	e8 97 fe ff ff       	call   802d4f <syscall>
  802eb8:	83 c4 18             	add    $0x18,%esp
	return ;
  802ebb:	90                   	nop
}
  802ebc:	c9                   	leave  
  802ebd:	c3                   	ret    

00802ebe <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802ebe:	55                   	push   %ebp
  802ebf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802ec1:	6a 00                	push   $0x0
  802ec3:	6a 00                	push   $0x0
  802ec5:	ff 75 10             	pushl  0x10(%ebp)
  802ec8:	ff 75 0c             	pushl  0xc(%ebp)
  802ecb:	ff 75 08             	pushl  0x8(%ebp)
  802ece:	6a 11                	push   $0x11
  802ed0:	e8 7a fe ff ff       	call   802d4f <syscall>
  802ed5:	83 c4 18             	add    $0x18,%esp
	return ;
  802ed8:	90                   	nop
}
  802ed9:	c9                   	leave  
  802eda:	c3                   	ret    

00802edb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802edb:	55                   	push   %ebp
  802edc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802ede:	6a 00                	push   $0x0
  802ee0:	6a 00                	push   $0x0
  802ee2:	6a 00                	push   $0x0
  802ee4:	6a 00                	push   $0x0
  802ee6:	6a 00                	push   $0x0
  802ee8:	6a 0c                	push   $0xc
  802eea:	e8 60 fe ff ff       	call   802d4f <syscall>
  802eef:	83 c4 18             	add    $0x18,%esp
}
  802ef2:	c9                   	leave  
  802ef3:	c3                   	ret    

00802ef4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802ef4:	55                   	push   %ebp
  802ef5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802ef7:	6a 00                	push   $0x0
  802ef9:	6a 00                	push   $0x0
  802efb:	6a 00                	push   $0x0
  802efd:	6a 00                	push   $0x0
  802eff:	ff 75 08             	pushl  0x8(%ebp)
  802f02:	6a 0d                	push   $0xd
  802f04:	e8 46 fe ff ff       	call   802d4f <syscall>
  802f09:	83 c4 18             	add    $0x18,%esp
}
  802f0c:	c9                   	leave  
  802f0d:	c3                   	ret    

00802f0e <sys_scarce_memory>:

void sys_scarce_memory()
{
  802f0e:	55                   	push   %ebp
  802f0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802f11:	6a 00                	push   $0x0
  802f13:	6a 00                	push   $0x0
  802f15:	6a 00                	push   $0x0
  802f17:	6a 00                	push   $0x0
  802f19:	6a 00                	push   $0x0
  802f1b:	6a 0e                	push   $0xe
  802f1d:	e8 2d fe ff ff       	call   802d4f <syscall>
  802f22:	83 c4 18             	add    $0x18,%esp
}
  802f25:	90                   	nop
  802f26:	c9                   	leave  
  802f27:	c3                   	ret    

00802f28 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802f28:	55                   	push   %ebp
  802f29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802f2b:	6a 00                	push   $0x0
  802f2d:	6a 00                	push   $0x0
  802f2f:	6a 00                	push   $0x0
  802f31:	6a 00                	push   $0x0
  802f33:	6a 00                	push   $0x0
  802f35:	6a 13                	push   $0x13
  802f37:	e8 13 fe ff ff       	call   802d4f <syscall>
  802f3c:	83 c4 18             	add    $0x18,%esp
}
  802f3f:	90                   	nop
  802f40:	c9                   	leave  
  802f41:	c3                   	ret    

00802f42 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802f42:	55                   	push   %ebp
  802f43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802f45:	6a 00                	push   $0x0
  802f47:	6a 00                	push   $0x0
  802f49:	6a 00                	push   $0x0
  802f4b:	6a 00                	push   $0x0
  802f4d:	6a 00                	push   $0x0
  802f4f:	6a 14                	push   $0x14
  802f51:	e8 f9 fd ff ff       	call   802d4f <syscall>
  802f56:	83 c4 18             	add    $0x18,%esp
}
  802f59:	90                   	nop
  802f5a:	c9                   	leave  
  802f5b:	c3                   	ret    

00802f5c <sys_cputc>:


void
sys_cputc(const char c)
{
  802f5c:	55                   	push   %ebp
  802f5d:	89 e5                	mov    %esp,%ebp
  802f5f:	83 ec 04             	sub    $0x4,%esp
  802f62:	8b 45 08             	mov    0x8(%ebp),%eax
  802f65:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802f68:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f6c:	6a 00                	push   $0x0
  802f6e:	6a 00                	push   $0x0
  802f70:	6a 00                	push   $0x0
  802f72:	6a 00                	push   $0x0
  802f74:	50                   	push   %eax
  802f75:	6a 15                	push   $0x15
  802f77:	e8 d3 fd ff ff       	call   802d4f <syscall>
  802f7c:	83 c4 18             	add    $0x18,%esp
}
  802f7f:	90                   	nop
  802f80:	c9                   	leave  
  802f81:	c3                   	ret    

00802f82 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802f82:	55                   	push   %ebp
  802f83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802f85:	6a 00                	push   $0x0
  802f87:	6a 00                	push   $0x0
  802f89:	6a 00                	push   $0x0
  802f8b:	6a 00                	push   $0x0
  802f8d:	6a 00                	push   $0x0
  802f8f:	6a 16                	push   $0x16
  802f91:	e8 b9 fd ff ff       	call   802d4f <syscall>
  802f96:	83 c4 18             	add    $0x18,%esp
}
  802f99:	90                   	nop
  802f9a:	c9                   	leave  
  802f9b:	c3                   	ret    

00802f9c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802f9c:	55                   	push   %ebp
  802f9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	6a 00                	push   $0x0
  802fa4:	6a 00                	push   $0x0
  802fa6:	6a 00                	push   $0x0
  802fa8:	ff 75 0c             	pushl  0xc(%ebp)
  802fab:	50                   	push   %eax
  802fac:	6a 17                	push   $0x17
  802fae:	e8 9c fd ff ff       	call   802d4f <syscall>
  802fb3:	83 c4 18             	add    $0x18,%esp
}
  802fb6:	c9                   	leave  
  802fb7:	c3                   	ret    

00802fb8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802fb8:	55                   	push   %ebp
  802fb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802fbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	6a 00                	push   $0x0
  802fc3:	6a 00                	push   $0x0
  802fc5:	6a 00                	push   $0x0
  802fc7:	52                   	push   %edx
  802fc8:	50                   	push   %eax
  802fc9:	6a 1a                	push   $0x1a
  802fcb:	e8 7f fd ff ff       	call   802d4f <syscall>
  802fd0:	83 c4 18             	add    $0x18,%esp
}
  802fd3:	c9                   	leave  
  802fd4:	c3                   	ret    

00802fd5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802fd5:	55                   	push   %ebp
  802fd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802fd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	6a 00                	push   $0x0
  802fe0:	6a 00                	push   $0x0
  802fe2:	6a 00                	push   $0x0
  802fe4:	52                   	push   %edx
  802fe5:	50                   	push   %eax
  802fe6:	6a 18                	push   $0x18
  802fe8:	e8 62 fd ff ff       	call   802d4f <syscall>
  802fed:	83 c4 18             	add    $0x18,%esp
}
  802ff0:	90                   	nop
  802ff1:	c9                   	leave  
  802ff2:	c3                   	ret    

00802ff3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802ff3:	55                   	push   %ebp
  802ff4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	6a 00                	push   $0x0
  802ffe:	6a 00                	push   $0x0
  803000:	6a 00                	push   $0x0
  803002:	52                   	push   %edx
  803003:	50                   	push   %eax
  803004:	6a 19                	push   $0x19
  803006:	e8 44 fd ff ff       	call   802d4f <syscall>
  80300b:	83 c4 18             	add    $0x18,%esp
}
  80300e:	90                   	nop
  80300f:	c9                   	leave  
  803010:	c3                   	ret    

00803011 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803011:	55                   	push   %ebp
  803012:	89 e5                	mov    %esp,%ebp
  803014:	83 ec 04             	sub    $0x4,%esp
  803017:	8b 45 10             	mov    0x10(%ebp),%eax
  80301a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80301d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803020:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803024:	8b 45 08             	mov    0x8(%ebp),%eax
  803027:	6a 00                	push   $0x0
  803029:	51                   	push   %ecx
  80302a:	52                   	push   %edx
  80302b:	ff 75 0c             	pushl  0xc(%ebp)
  80302e:	50                   	push   %eax
  80302f:	6a 1b                	push   $0x1b
  803031:	e8 19 fd ff ff       	call   802d4f <syscall>
  803036:	83 c4 18             	add    $0x18,%esp
}
  803039:	c9                   	leave  
  80303a:	c3                   	ret    

0080303b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80303b:	55                   	push   %ebp
  80303c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80303e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	6a 00                	push   $0x0
  803046:	6a 00                	push   $0x0
  803048:	6a 00                	push   $0x0
  80304a:	52                   	push   %edx
  80304b:	50                   	push   %eax
  80304c:	6a 1c                	push   $0x1c
  80304e:	e8 fc fc ff ff       	call   802d4f <syscall>
  803053:	83 c4 18             	add    $0x18,%esp
}
  803056:	c9                   	leave  
  803057:	c3                   	ret    

00803058 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  803058:	55                   	push   %ebp
  803059:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80305b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80305e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	6a 00                	push   $0x0
  803066:	6a 00                	push   $0x0
  803068:	51                   	push   %ecx
  803069:	52                   	push   %edx
  80306a:	50                   	push   %eax
  80306b:	6a 1d                	push   $0x1d
  80306d:	e8 dd fc ff ff       	call   802d4f <syscall>
  803072:	83 c4 18             	add    $0x18,%esp
}
  803075:	c9                   	leave  
  803076:	c3                   	ret    

00803077 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  803077:	55                   	push   %ebp
  803078:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80307a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	6a 00                	push   $0x0
  803082:	6a 00                	push   $0x0
  803084:	6a 00                	push   $0x0
  803086:	52                   	push   %edx
  803087:	50                   	push   %eax
  803088:	6a 1e                	push   $0x1e
  80308a:	e8 c0 fc ff ff       	call   802d4f <syscall>
  80308f:	83 c4 18             	add    $0x18,%esp
}
  803092:	c9                   	leave  
  803093:	c3                   	ret    

00803094 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  803094:	55                   	push   %ebp
  803095:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  803097:	6a 00                	push   $0x0
  803099:	6a 00                	push   $0x0
  80309b:	6a 00                	push   $0x0
  80309d:	6a 00                	push   $0x0
  80309f:	6a 00                	push   $0x0
  8030a1:	6a 1f                	push   $0x1f
  8030a3:	e8 a7 fc ff ff       	call   802d4f <syscall>
  8030a8:	83 c4 18             	add    $0x18,%esp
}
  8030ab:	c9                   	leave  
  8030ac:	c3                   	ret    

008030ad <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8030ad:	55                   	push   %ebp
  8030ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	6a 00                	push   $0x0
  8030b5:	ff 75 14             	pushl  0x14(%ebp)
  8030b8:	ff 75 10             	pushl  0x10(%ebp)
  8030bb:	ff 75 0c             	pushl  0xc(%ebp)
  8030be:	50                   	push   %eax
  8030bf:	6a 20                	push   $0x20
  8030c1:	e8 89 fc ff ff       	call   802d4f <syscall>
  8030c6:	83 c4 18             	add    $0x18,%esp
}
  8030c9:	c9                   	leave  
  8030ca:	c3                   	ret    

008030cb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8030cb:	55                   	push   %ebp
  8030cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	6a 00                	push   $0x0
  8030d3:	6a 00                	push   $0x0
  8030d5:	6a 00                	push   $0x0
  8030d7:	6a 00                	push   $0x0
  8030d9:	50                   	push   %eax
  8030da:	6a 21                	push   $0x21
  8030dc:	e8 6e fc ff ff       	call   802d4f <syscall>
  8030e1:	83 c4 18             	add    $0x18,%esp
}
  8030e4:	90                   	nop
  8030e5:	c9                   	leave  
  8030e6:	c3                   	ret    

008030e7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8030e7:	55                   	push   %ebp
  8030e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	6a 00                	push   $0x0
  8030ef:	6a 00                	push   $0x0
  8030f1:	6a 00                	push   $0x0
  8030f3:	6a 00                	push   $0x0
  8030f5:	50                   	push   %eax
  8030f6:	6a 22                	push   $0x22
  8030f8:	e8 52 fc ff ff       	call   802d4f <syscall>
  8030fd:	83 c4 18             	add    $0x18,%esp
}
  803100:	c9                   	leave  
  803101:	c3                   	ret    

00803102 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803102:	55                   	push   %ebp
  803103:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803105:	6a 00                	push   $0x0
  803107:	6a 00                	push   $0x0
  803109:	6a 00                	push   $0x0
  80310b:	6a 00                	push   $0x0
  80310d:	6a 00                	push   $0x0
  80310f:	6a 02                	push   $0x2
  803111:	e8 39 fc ff ff       	call   802d4f <syscall>
  803116:	83 c4 18             	add    $0x18,%esp
}
  803119:	c9                   	leave  
  80311a:	c3                   	ret    

0080311b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80311b:	55                   	push   %ebp
  80311c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80311e:	6a 00                	push   $0x0
  803120:	6a 00                	push   $0x0
  803122:	6a 00                	push   $0x0
  803124:	6a 00                	push   $0x0
  803126:	6a 00                	push   $0x0
  803128:	6a 03                	push   $0x3
  80312a:	e8 20 fc ff ff       	call   802d4f <syscall>
  80312f:	83 c4 18             	add    $0x18,%esp
}
  803132:	c9                   	leave  
  803133:	c3                   	ret    

00803134 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803134:	55                   	push   %ebp
  803135:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803137:	6a 00                	push   $0x0
  803139:	6a 00                	push   $0x0
  80313b:	6a 00                	push   $0x0
  80313d:	6a 00                	push   $0x0
  80313f:	6a 00                	push   $0x0
  803141:	6a 04                	push   $0x4
  803143:	e8 07 fc ff ff       	call   802d4f <syscall>
  803148:	83 c4 18             	add    $0x18,%esp
}
  80314b:	c9                   	leave  
  80314c:	c3                   	ret    

0080314d <sys_exit_env>:


void sys_exit_env(void)
{
  80314d:	55                   	push   %ebp
  80314e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803150:	6a 00                	push   $0x0
  803152:	6a 00                	push   $0x0
  803154:	6a 00                	push   $0x0
  803156:	6a 00                	push   $0x0
  803158:	6a 00                	push   $0x0
  80315a:	6a 23                	push   $0x23
  80315c:	e8 ee fb ff ff       	call   802d4f <syscall>
  803161:	83 c4 18             	add    $0x18,%esp
}
  803164:	90                   	nop
  803165:	c9                   	leave  
  803166:	c3                   	ret    

00803167 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  803167:	55                   	push   %ebp
  803168:	89 e5                	mov    %esp,%ebp
  80316a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80316d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803170:	8d 50 04             	lea    0x4(%eax),%edx
  803173:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803176:	6a 00                	push   $0x0
  803178:	6a 00                	push   $0x0
  80317a:	6a 00                	push   $0x0
  80317c:	52                   	push   %edx
  80317d:	50                   	push   %eax
  80317e:	6a 24                	push   $0x24
  803180:	e8 ca fb ff ff       	call   802d4f <syscall>
  803185:	83 c4 18             	add    $0x18,%esp
	return result;
  803188:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80318b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80318e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803191:	89 01                	mov    %eax,(%ecx)
  803193:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	c9                   	leave  
  80319a:	c2 04 00             	ret    $0x4

0080319d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80319d:	55                   	push   %ebp
  80319e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8031a0:	6a 00                	push   $0x0
  8031a2:	6a 00                	push   $0x0
  8031a4:	ff 75 10             	pushl  0x10(%ebp)
  8031a7:	ff 75 0c             	pushl  0xc(%ebp)
  8031aa:	ff 75 08             	pushl  0x8(%ebp)
  8031ad:	6a 12                	push   $0x12
  8031af:	e8 9b fb ff ff       	call   802d4f <syscall>
  8031b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8031b7:	90                   	nop
}
  8031b8:	c9                   	leave  
  8031b9:	c3                   	ret    

008031ba <sys_rcr2>:
uint32 sys_rcr2()
{
  8031ba:	55                   	push   %ebp
  8031bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8031bd:	6a 00                	push   $0x0
  8031bf:	6a 00                	push   $0x0
  8031c1:	6a 00                	push   $0x0
  8031c3:	6a 00                	push   $0x0
  8031c5:	6a 00                	push   $0x0
  8031c7:	6a 25                	push   $0x25
  8031c9:	e8 81 fb ff ff       	call   802d4f <syscall>
  8031ce:	83 c4 18             	add    $0x18,%esp
}
  8031d1:	c9                   	leave  
  8031d2:	c3                   	ret    

008031d3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8031d3:	55                   	push   %ebp
  8031d4:	89 e5                	mov    %esp,%ebp
  8031d6:	83 ec 04             	sub    $0x4,%esp
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8031df:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8031e3:	6a 00                	push   $0x0
  8031e5:	6a 00                	push   $0x0
  8031e7:	6a 00                	push   $0x0
  8031e9:	6a 00                	push   $0x0
  8031eb:	50                   	push   %eax
  8031ec:	6a 26                	push   $0x26
  8031ee:	e8 5c fb ff ff       	call   802d4f <syscall>
  8031f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8031f6:	90                   	nop
}
  8031f7:	c9                   	leave  
  8031f8:	c3                   	ret    

008031f9 <rsttst>:
void rsttst()
{
  8031f9:	55                   	push   %ebp
  8031fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8031fc:	6a 00                	push   $0x0
  8031fe:	6a 00                	push   $0x0
  803200:	6a 00                	push   $0x0
  803202:	6a 00                	push   $0x0
  803204:	6a 00                	push   $0x0
  803206:	6a 28                	push   $0x28
  803208:	e8 42 fb ff ff       	call   802d4f <syscall>
  80320d:	83 c4 18             	add    $0x18,%esp
	return ;
  803210:	90                   	nop
}
  803211:	c9                   	leave  
  803212:	c3                   	ret    

00803213 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803213:	55                   	push   %ebp
  803214:	89 e5                	mov    %esp,%ebp
  803216:	83 ec 04             	sub    $0x4,%esp
  803219:	8b 45 14             	mov    0x14(%ebp),%eax
  80321c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80321f:	8b 55 18             	mov    0x18(%ebp),%edx
  803222:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803226:	52                   	push   %edx
  803227:	50                   	push   %eax
  803228:	ff 75 10             	pushl  0x10(%ebp)
  80322b:	ff 75 0c             	pushl  0xc(%ebp)
  80322e:	ff 75 08             	pushl  0x8(%ebp)
  803231:	6a 27                	push   $0x27
  803233:	e8 17 fb ff ff       	call   802d4f <syscall>
  803238:	83 c4 18             	add    $0x18,%esp
	return ;
  80323b:	90                   	nop
}
  80323c:	c9                   	leave  
  80323d:	c3                   	ret    

0080323e <chktst>:
void chktst(uint32 n)
{
  80323e:	55                   	push   %ebp
  80323f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803241:	6a 00                	push   $0x0
  803243:	6a 00                	push   $0x0
  803245:	6a 00                	push   $0x0
  803247:	6a 00                	push   $0x0
  803249:	ff 75 08             	pushl  0x8(%ebp)
  80324c:	6a 29                	push   $0x29
  80324e:	e8 fc fa ff ff       	call   802d4f <syscall>
  803253:	83 c4 18             	add    $0x18,%esp
	return ;
  803256:	90                   	nop
}
  803257:	c9                   	leave  
  803258:	c3                   	ret    

00803259 <inctst>:

void inctst()
{
  803259:	55                   	push   %ebp
  80325a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80325c:	6a 00                	push   $0x0
  80325e:	6a 00                	push   $0x0
  803260:	6a 00                	push   $0x0
  803262:	6a 00                	push   $0x0
  803264:	6a 00                	push   $0x0
  803266:	6a 2a                	push   $0x2a
  803268:	e8 e2 fa ff ff       	call   802d4f <syscall>
  80326d:	83 c4 18             	add    $0x18,%esp
	return ;
  803270:	90                   	nop
}
  803271:	c9                   	leave  
  803272:	c3                   	ret    

00803273 <gettst>:
uint32 gettst()
{
  803273:	55                   	push   %ebp
  803274:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803276:	6a 00                	push   $0x0
  803278:	6a 00                	push   $0x0
  80327a:	6a 00                	push   $0x0
  80327c:	6a 00                	push   $0x0
  80327e:	6a 00                	push   $0x0
  803280:	6a 2b                	push   $0x2b
  803282:	e8 c8 fa ff ff       	call   802d4f <syscall>
  803287:	83 c4 18             	add    $0x18,%esp
}
  80328a:	c9                   	leave  
  80328b:	c3                   	ret    

0080328c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80328c:	55                   	push   %ebp
  80328d:	89 e5                	mov    %esp,%ebp
  80328f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803292:	6a 00                	push   $0x0
  803294:	6a 00                	push   $0x0
  803296:	6a 00                	push   $0x0
  803298:	6a 00                	push   $0x0
  80329a:	6a 00                	push   $0x0
  80329c:	6a 2c                	push   $0x2c
  80329e:	e8 ac fa ff ff       	call   802d4f <syscall>
  8032a3:	83 c4 18             	add    $0x18,%esp
  8032a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8032a9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8032ad:	75 07                	jne    8032b6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8032af:	b8 01 00 00 00       	mov    $0x1,%eax
  8032b4:	eb 05                	jmp    8032bb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8032b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032bb:	c9                   	leave  
  8032bc:	c3                   	ret    

008032bd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8032bd:	55                   	push   %ebp
  8032be:	89 e5                	mov    %esp,%ebp
  8032c0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032c3:	6a 00                	push   $0x0
  8032c5:	6a 00                	push   $0x0
  8032c7:	6a 00                	push   $0x0
  8032c9:	6a 00                	push   $0x0
  8032cb:	6a 00                	push   $0x0
  8032cd:	6a 2c                	push   $0x2c
  8032cf:	e8 7b fa ff ff       	call   802d4f <syscall>
  8032d4:	83 c4 18             	add    $0x18,%esp
  8032d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8032da:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8032de:	75 07                	jne    8032e7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8032e0:	b8 01 00 00 00       	mov    $0x1,%eax
  8032e5:	eb 05                	jmp    8032ec <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8032e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032ec:	c9                   	leave  
  8032ed:	c3                   	ret    

008032ee <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8032ee:	55                   	push   %ebp
  8032ef:	89 e5                	mov    %esp,%ebp
  8032f1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032f4:	6a 00                	push   $0x0
  8032f6:	6a 00                	push   $0x0
  8032f8:	6a 00                	push   $0x0
  8032fa:	6a 00                	push   $0x0
  8032fc:	6a 00                	push   $0x0
  8032fe:	6a 2c                	push   $0x2c
  803300:	e8 4a fa ff ff       	call   802d4f <syscall>
  803305:	83 c4 18             	add    $0x18,%esp
  803308:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80330b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80330f:	75 07                	jne    803318 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  803311:	b8 01 00 00 00       	mov    $0x1,%eax
  803316:	eb 05                	jmp    80331d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803318:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80331d:	c9                   	leave  
  80331e:	c3                   	ret    

0080331f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80331f:	55                   	push   %ebp
  803320:	89 e5                	mov    %esp,%ebp
  803322:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803325:	6a 00                	push   $0x0
  803327:	6a 00                	push   $0x0
  803329:	6a 00                	push   $0x0
  80332b:	6a 00                	push   $0x0
  80332d:	6a 00                	push   $0x0
  80332f:	6a 2c                	push   $0x2c
  803331:	e8 19 fa ff ff       	call   802d4f <syscall>
  803336:	83 c4 18             	add    $0x18,%esp
  803339:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80333c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  803340:	75 07                	jne    803349 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  803342:	b8 01 00 00 00       	mov    $0x1,%eax
  803347:	eb 05                	jmp    80334e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803349:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80334e:	c9                   	leave  
  80334f:	c3                   	ret    

00803350 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803350:	55                   	push   %ebp
  803351:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803353:	6a 00                	push   $0x0
  803355:	6a 00                	push   $0x0
  803357:	6a 00                	push   $0x0
  803359:	6a 00                	push   $0x0
  80335b:	ff 75 08             	pushl  0x8(%ebp)
  80335e:	6a 2d                	push   $0x2d
  803360:	e8 ea f9 ff ff       	call   802d4f <syscall>
  803365:	83 c4 18             	add    $0x18,%esp
	return ;
  803368:	90                   	nop
}
  803369:	c9                   	leave  
  80336a:	c3                   	ret    

0080336b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80336b:	55                   	push   %ebp
  80336c:	89 e5                	mov    %esp,%ebp
  80336e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80336f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803372:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803375:	8b 55 0c             	mov    0xc(%ebp),%edx
  803378:	8b 45 08             	mov    0x8(%ebp),%eax
  80337b:	6a 00                	push   $0x0
  80337d:	53                   	push   %ebx
  80337e:	51                   	push   %ecx
  80337f:	52                   	push   %edx
  803380:	50                   	push   %eax
  803381:	6a 2e                	push   $0x2e
  803383:	e8 c7 f9 ff ff       	call   802d4f <syscall>
  803388:	83 c4 18             	add    $0x18,%esp
}
  80338b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80338e:	c9                   	leave  
  80338f:	c3                   	ret    

00803390 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803390:	55                   	push   %ebp
  803391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803393:	8b 55 0c             	mov    0xc(%ebp),%edx
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	6a 00                	push   $0x0
  80339b:	6a 00                	push   $0x0
  80339d:	6a 00                	push   $0x0
  80339f:	52                   	push   %edx
  8033a0:	50                   	push   %eax
  8033a1:	6a 2f                	push   $0x2f
  8033a3:	e8 a7 f9 ff ff       	call   802d4f <syscall>
  8033a8:	83 c4 18             	add    $0x18,%esp
}
  8033ab:	c9                   	leave  
  8033ac:	c3                   	ret    

008033ad <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8033ad:	55                   	push   %ebp
  8033ae:	89 e5                	mov    %esp,%ebp
  8033b0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8033b3:	83 ec 0c             	sub    $0xc,%esp
  8033b6:	68 68 55 80 00       	push   $0x805568
  8033bb:	e8 1e e8 ff ff       	call   801bde <cprintf>
  8033c0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8033c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8033ca:	83 ec 0c             	sub    $0xc,%esp
  8033cd:	68 94 55 80 00       	push   $0x805594
  8033d2:	e8 07 e8 ff ff       	call   801bde <cprintf>
  8033d7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8033da:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8033de:	a1 38 61 80 00       	mov    0x806138,%eax
  8033e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e6:	eb 56                	jmp    80343e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8033e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033ec:	74 1c                	je     80340a <print_mem_block_lists+0x5d>
  8033ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f1:	8b 50 08             	mov    0x8(%eax),%edx
  8033f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f7:	8b 48 08             	mov    0x8(%eax),%ecx
  8033fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803400:	01 c8                	add    %ecx,%eax
  803402:	39 c2                	cmp    %eax,%edx
  803404:	73 04                	jae    80340a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  803406:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80340a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340d:	8b 50 08             	mov    0x8(%eax),%edx
  803410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803413:	8b 40 0c             	mov    0xc(%eax),%eax
  803416:	01 c2                	add    %eax,%edx
  803418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341b:	8b 40 08             	mov    0x8(%eax),%eax
  80341e:	83 ec 04             	sub    $0x4,%esp
  803421:	52                   	push   %edx
  803422:	50                   	push   %eax
  803423:	68 a9 55 80 00       	push   $0x8055a9
  803428:	e8 b1 e7 ff ff       	call   801bde <cprintf>
  80342d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803433:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803436:	a1 40 61 80 00       	mov    0x806140,%eax
  80343b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80343e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803442:	74 07                	je     80344b <print_mem_block_lists+0x9e>
  803444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803447:	8b 00                	mov    (%eax),%eax
  803449:	eb 05                	jmp    803450 <print_mem_block_lists+0xa3>
  80344b:	b8 00 00 00 00       	mov    $0x0,%eax
  803450:	a3 40 61 80 00       	mov    %eax,0x806140
  803455:	a1 40 61 80 00       	mov    0x806140,%eax
  80345a:	85 c0                	test   %eax,%eax
  80345c:	75 8a                	jne    8033e8 <print_mem_block_lists+0x3b>
  80345e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803462:	75 84                	jne    8033e8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  803464:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803468:	75 10                	jne    80347a <print_mem_block_lists+0xcd>
  80346a:	83 ec 0c             	sub    $0xc,%esp
  80346d:	68 b8 55 80 00       	push   $0x8055b8
  803472:	e8 67 e7 ff ff       	call   801bde <cprintf>
  803477:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80347a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  803481:	83 ec 0c             	sub    $0xc,%esp
  803484:	68 dc 55 80 00       	push   $0x8055dc
  803489:	e8 50 e7 ff ff       	call   801bde <cprintf>
  80348e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  803491:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803495:	a1 40 60 80 00       	mov    0x806040,%eax
  80349a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80349d:	eb 56                	jmp    8034f5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80349f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034a3:	74 1c                	je     8034c1 <print_mem_block_lists+0x114>
  8034a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a8:	8b 50 08             	mov    0x8(%eax),%edx
  8034ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ae:	8b 48 08             	mov    0x8(%eax),%ecx
  8034b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b7:	01 c8                	add    %ecx,%eax
  8034b9:	39 c2                	cmp    %eax,%edx
  8034bb:	73 04                	jae    8034c1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8034bd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8034c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c4:	8b 50 08             	mov    0x8(%eax),%edx
  8034c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8034cd:	01 c2                	add    %eax,%edx
  8034cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d2:	8b 40 08             	mov    0x8(%eax),%eax
  8034d5:	83 ec 04             	sub    $0x4,%esp
  8034d8:	52                   	push   %edx
  8034d9:	50                   	push   %eax
  8034da:	68 a9 55 80 00       	push   $0x8055a9
  8034df:	e8 fa e6 ff ff       	call   801bde <cprintf>
  8034e4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8034e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8034ed:	a1 48 60 80 00       	mov    0x806048,%eax
  8034f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034f9:	74 07                	je     803502 <print_mem_block_lists+0x155>
  8034fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fe:	8b 00                	mov    (%eax),%eax
  803500:	eb 05                	jmp    803507 <print_mem_block_lists+0x15a>
  803502:	b8 00 00 00 00       	mov    $0x0,%eax
  803507:	a3 48 60 80 00       	mov    %eax,0x806048
  80350c:	a1 48 60 80 00       	mov    0x806048,%eax
  803511:	85 c0                	test   %eax,%eax
  803513:	75 8a                	jne    80349f <print_mem_block_lists+0xf2>
  803515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803519:	75 84                	jne    80349f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80351b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80351f:	75 10                	jne    803531 <print_mem_block_lists+0x184>
  803521:	83 ec 0c             	sub    $0xc,%esp
  803524:	68 f4 55 80 00       	push   $0x8055f4
  803529:	e8 b0 e6 ff ff       	call   801bde <cprintf>
  80352e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803531:	83 ec 0c             	sub    $0xc,%esp
  803534:	68 68 55 80 00       	push   $0x805568
  803539:	e8 a0 e6 ff ff       	call   801bde <cprintf>
  80353e:	83 c4 10             	add    $0x10,%esp

}
  803541:	90                   	nop
  803542:	c9                   	leave  
  803543:	c3                   	ret    

00803544 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  803544:	55                   	push   %ebp
  803545:	89 e5                	mov    %esp,%ebp
  803547:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80354a:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  803551:	00 00 00 
  803554:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  80355b:	00 00 00 
  80355e:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  803565:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  803568:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80356f:	e9 9e 00 00 00       	jmp    803612 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  803574:	a1 50 60 80 00       	mov    0x806050,%eax
  803579:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80357c:	c1 e2 04             	shl    $0x4,%edx
  80357f:	01 d0                	add    %edx,%eax
  803581:	85 c0                	test   %eax,%eax
  803583:	75 14                	jne    803599 <initialize_MemBlocksList+0x55>
  803585:	83 ec 04             	sub    $0x4,%esp
  803588:	68 1c 56 80 00       	push   $0x80561c
  80358d:	6a 46                	push   $0x46
  80358f:	68 3f 56 80 00       	push   $0x80563f
  803594:	e8 91 e3 ff ff       	call   80192a <_panic>
  803599:	a1 50 60 80 00       	mov    0x806050,%eax
  80359e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a1:	c1 e2 04             	shl    $0x4,%edx
  8035a4:	01 d0                	add    %edx,%eax
  8035a6:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8035ac:	89 10                	mov    %edx,(%eax)
  8035ae:	8b 00                	mov    (%eax),%eax
  8035b0:	85 c0                	test   %eax,%eax
  8035b2:	74 18                	je     8035cc <initialize_MemBlocksList+0x88>
  8035b4:	a1 48 61 80 00       	mov    0x806148,%eax
  8035b9:	8b 15 50 60 80 00    	mov    0x806050,%edx
  8035bf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8035c2:	c1 e1 04             	shl    $0x4,%ecx
  8035c5:	01 ca                	add    %ecx,%edx
  8035c7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ca:	eb 12                	jmp    8035de <initialize_MemBlocksList+0x9a>
  8035cc:	a1 50 60 80 00       	mov    0x806050,%eax
  8035d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035d4:	c1 e2 04             	shl    $0x4,%edx
  8035d7:	01 d0                	add    %edx,%eax
  8035d9:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8035de:	a1 50 60 80 00       	mov    0x806050,%eax
  8035e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035e6:	c1 e2 04             	shl    $0x4,%edx
  8035e9:	01 d0                	add    %edx,%eax
  8035eb:	a3 48 61 80 00       	mov    %eax,0x806148
  8035f0:	a1 50 60 80 00       	mov    0x806050,%eax
  8035f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035f8:	c1 e2 04             	shl    $0x4,%edx
  8035fb:	01 d0                	add    %edx,%eax
  8035fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803604:	a1 54 61 80 00       	mov    0x806154,%eax
  803609:	40                   	inc    %eax
  80360a:	a3 54 61 80 00       	mov    %eax,0x806154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80360f:	ff 45 f4             	incl   -0xc(%ebp)
  803612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803615:	3b 45 08             	cmp    0x8(%ebp),%eax
  803618:	0f 82 56 ff ff ff    	jb     803574 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80361e:	90                   	nop
  80361f:	c9                   	leave  
  803620:	c3                   	ret    

00803621 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  803621:	55                   	push   %ebp
  803622:	89 e5                	mov    %esp,%ebp
  803624:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  803627:	8b 45 08             	mov    0x8(%ebp),%eax
  80362a:	8b 00                	mov    (%eax),%eax
  80362c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80362f:	eb 19                	jmp    80364a <find_block+0x29>
	{
		if(va==point->sva)
  803631:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803634:	8b 40 08             	mov    0x8(%eax),%eax
  803637:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80363a:	75 05                	jne    803641 <find_block+0x20>
		   return point;
  80363c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80363f:	eb 36                	jmp    803677 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  803641:	8b 45 08             	mov    0x8(%ebp),%eax
  803644:	8b 40 08             	mov    0x8(%eax),%eax
  803647:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80364a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80364e:	74 07                	je     803657 <find_block+0x36>
  803650:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803653:	8b 00                	mov    (%eax),%eax
  803655:	eb 05                	jmp    80365c <find_block+0x3b>
  803657:	b8 00 00 00 00       	mov    $0x0,%eax
  80365c:	8b 55 08             	mov    0x8(%ebp),%edx
  80365f:	89 42 08             	mov    %eax,0x8(%edx)
  803662:	8b 45 08             	mov    0x8(%ebp),%eax
  803665:	8b 40 08             	mov    0x8(%eax),%eax
  803668:	85 c0                	test   %eax,%eax
  80366a:	75 c5                	jne    803631 <find_block+0x10>
  80366c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803670:	75 bf                	jne    803631 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  803672:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803677:	c9                   	leave  
  803678:	c3                   	ret    

00803679 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  803679:	55                   	push   %ebp
  80367a:	89 e5                	mov    %esp,%ebp
  80367c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80367f:	a1 40 60 80 00       	mov    0x806040,%eax
  803684:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  803687:	a1 44 60 80 00       	mov    0x806044,%eax
  80368c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80368f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803692:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803695:	74 24                	je     8036bb <insert_sorted_allocList+0x42>
  803697:	8b 45 08             	mov    0x8(%ebp),%eax
  80369a:	8b 50 08             	mov    0x8(%eax),%edx
  80369d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a0:	8b 40 08             	mov    0x8(%eax),%eax
  8036a3:	39 c2                	cmp    %eax,%edx
  8036a5:	76 14                	jbe    8036bb <insert_sorted_allocList+0x42>
  8036a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036aa:	8b 50 08             	mov    0x8(%eax),%edx
  8036ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b0:	8b 40 08             	mov    0x8(%eax),%eax
  8036b3:	39 c2                	cmp    %eax,%edx
  8036b5:	0f 82 60 01 00 00    	jb     80381b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8036bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036bf:	75 65                	jne    803726 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8036c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036c5:	75 14                	jne    8036db <insert_sorted_allocList+0x62>
  8036c7:	83 ec 04             	sub    $0x4,%esp
  8036ca:	68 1c 56 80 00       	push   $0x80561c
  8036cf:	6a 6b                	push   $0x6b
  8036d1:	68 3f 56 80 00       	push   $0x80563f
  8036d6:	e8 4f e2 ff ff       	call   80192a <_panic>
  8036db:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8036e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e4:	89 10                	mov    %edx,(%eax)
  8036e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e9:	8b 00                	mov    (%eax),%eax
  8036eb:	85 c0                	test   %eax,%eax
  8036ed:	74 0d                	je     8036fc <insert_sorted_allocList+0x83>
  8036ef:	a1 40 60 80 00       	mov    0x806040,%eax
  8036f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f7:	89 50 04             	mov    %edx,0x4(%eax)
  8036fa:	eb 08                	jmp    803704 <insert_sorted_allocList+0x8b>
  8036fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ff:	a3 44 60 80 00       	mov    %eax,0x806044
  803704:	8b 45 08             	mov    0x8(%ebp),%eax
  803707:	a3 40 60 80 00       	mov    %eax,0x806040
  80370c:	8b 45 08             	mov    0x8(%ebp),%eax
  80370f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803716:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80371b:	40                   	inc    %eax
  80371c:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803721:	e9 dc 01 00 00       	jmp    803902 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  803726:	8b 45 08             	mov    0x8(%ebp),%eax
  803729:	8b 50 08             	mov    0x8(%eax),%edx
  80372c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372f:	8b 40 08             	mov    0x8(%eax),%eax
  803732:	39 c2                	cmp    %eax,%edx
  803734:	77 6c                	ja     8037a2 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  803736:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80373a:	74 06                	je     803742 <insert_sorted_allocList+0xc9>
  80373c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803740:	75 14                	jne    803756 <insert_sorted_allocList+0xdd>
  803742:	83 ec 04             	sub    $0x4,%esp
  803745:	68 58 56 80 00       	push   $0x805658
  80374a:	6a 6f                	push   $0x6f
  80374c:	68 3f 56 80 00       	push   $0x80563f
  803751:	e8 d4 e1 ff ff       	call   80192a <_panic>
  803756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803759:	8b 50 04             	mov    0x4(%eax),%edx
  80375c:	8b 45 08             	mov    0x8(%ebp),%eax
  80375f:	89 50 04             	mov    %edx,0x4(%eax)
  803762:	8b 45 08             	mov    0x8(%ebp),%eax
  803765:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803768:	89 10                	mov    %edx,(%eax)
  80376a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80376d:	8b 40 04             	mov    0x4(%eax),%eax
  803770:	85 c0                	test   %eax,%eax
  803772:	74 0d                	je     803781 <insert_sorted_allocList+0x108>
  803774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803777:	8b 40 04             	mov    0x4(%eax),%eax
  80377a:	8b 55 08             	mov    0x8(%ebp),%edx
  80377d:	89 10                	mov    %edx,(%eax)
  80377f:	eb 08                	jmp    803789 <insert_sorted_allocList+0x110>
  803781:	8b 45 08             	mov    0x8(%ebp),%eax
  803784:	a3 40 60 80 00       	mov    %eax,0x806040
  803789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378c:	8b 55 08             	mov    0x8(%ebp),%edx
  80378f:	89 50 04             	mov    %edx,0x4(%eax)
  803792:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803797:	40                   	inc    %eax
  803798:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80379d:	e9 60 01 00 00       	jmp    803902 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8037a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a5:	8b 50 08             	mov    0x8(%eax),%edx
  8037a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ab:	8b 40 08             	mov    0x8(%eax),%eax
  8037ae:	39 c2                	cmp    %eax,%edx
  8037b0:	0f 82 4c 01 00 00    	jb     803902 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8037b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037ba:	75 14                	jne    8037d0 <insert_sorted_allocList+0x157>
  8037bc:	83 ec 04             	sub    $0x4,%esp
  8037bf:	68 90 56 80 00       	push   $0x805690
  8037c4:	6a 73                	push   $0x73
  8037c6:	68 3f 56 80 00       	push   $0x80563f
  8037cb:	e8 5a e1 ff ff       	call   80192a <_panic>
  8037d0:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8037d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d9:	89 50 04             	mov    %edx,0x4(%eax)
  8037dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037df:	8b 40 04             	mov    0x4(%eax),%eax
  8037e2:	85 c0                	test   %eax,%eax
  8037e4:	74 0c                	je     8037f2 <insert_sorted_allocList+0x179>
  8037e6:	a1 44 60 80 00       	mov    0x806044,%eax
  8037eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8037ee:	89 10                	mov    %edx,(%eax)
  8037f0:	eb 08                	jmp    8037fa <insert_sorted_allocList+0x181>
  8037f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f5:	a3 40 60 80 00       	mov    %eax,0x806040
  8037fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fd:	a3 44 60 80 00       	mov    %eax,0x806044
  803802:	8b 45 08             	mov    0x8(%ebp),%eax
  803805:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80380b:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803810:	40                   	inc    %eax
  803811:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803816:	e9 e7 00 00 00       	jmp    803902 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80381b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80381e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  803821:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  803828:	a1 40 60 80 00       	mov    0x806040,%eax
  80382d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803830:	e9 9d 00 00 00       	jmp    8038d2 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  803835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803838:	8b 00                	mov    (%eax),%eax
  80383a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80383d:	8b 45 08             	mov    0x8(%ebp),%eax
  803840:	8b 50 08             	mov    0x8(%eax),%edx
  803843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803846:	8b 40 08             	mov    0x8(%eax),%eax
  803849:	39 c2                	cmp    %eax,%edx
  80384b:	76 7d                	jbe    8038ca <insert_sorted_allocList+0x251>
  80384d:	8b 45 08             	mov    0x8(%ebp),%eax
  803850:	8b 50 08             	mov    0x8(%eax),%edx
  803853:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803856:	8b 40 08             	mov    0x8(%eax),%eax
  803859:	39 c2                	cmp    %eax,%edx
  80385b:	73 6d                	jae    8038ca <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80385d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803861:	74 06                	je     803869 <insert_sorted_allocList+0x1f0>
  803863:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803867:	75 14                	jne    80387d <insert_sorted_allocList+0x204>
  803869:	83 ec 04             	sub    $0x4,%esp
  80386c:	68 b4 56 80 00       	push   $0x8056b4
  803871:	6a 7f                	push   $0x7f
  803873:	68 3f 56 80 00       	push   $0x80563f
  803878:	e8 ad e0 ff ff       	call   80192a <_panic>
  80387d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803880:	8b 10                	mov    (%eax),%edx
  803882:	8b 45 08             	mov    0x8(%ebp),%eax
  803885:	89 10                	mov    %edx,(%eax)
  803887:	8b 45 08             	mov    0x8(%ebp),%eax
  80388a:	8b 00                	mov    (%eax),%eax
  80388c:	85 c0                	test   %eax,%eax
  80388e:	74 0b                	je     80389b <insert_sorted_allocList+0x222>
  803890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803893:	8b 00                	mov    (%eax),%eax
  803895:	8b 55 08             	mov    0x8(%ebp),%edx
  803898:	89 50 04             	mov    %edx,0x4(%eax)
  80389b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389e:	8b 55 08             	mov    0x8(%ebp),%edx
  8038a1:	89 10                	mov    %edx,(%eax)
  8038a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038a9:	89 50 04             	mov    %edx,0x4(%eax)
  8038ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8038af:	8b 00                	mov    (%eax),%eax
  8038b1:	85 c0                	test   %eax,%eax
  8038b3:	75 08                	jne    8038bd <insert_sorted_allocList+0x244>
  8038b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b8:	a3 44 60 80 00       	mov    %eax,0x806044
  8038bd:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8038c2:	40                   	inc    %eax
  8038c3:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  8038c8:	eb 39                	jmp    803903 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8038ca:	a1 48 60 80 00       	mov    0x806048,%eax
  8038cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038d6:	74 07                	je     8038df <insert_sorted_allocList+0x266>
  8038d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038db:	8b 00                	mov    (%eax),%eax
  8038dd:	eb 05                	jmp    8038e4 <insert_sorted_allocList+0x26b>
  8038df:	b8 00 00 00 00       	mov    $0x0,%eax
  8038e4:	a3 48 60 80 00       	mov    %eax,0x806048
  8038e9:	a1 48 60 80 00       	mov    0x806048,%eax
  8038ee:	85 c0                	test   %eax,%eax
  8038f0:	0f 85 3f ff ff ff    	jne    803835 <insert_sorted_allocList+0x1bc>
  8038f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038fa:	0f 85 35 ff ff ff    	jne    803835 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  803900:	eb 01                	jmp    803903 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803902:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  803903:	90                   	nop
  803904:	c9                   	leave  
  803905:	c3                   	ret    

00803906 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  803906:	55                   	push   %ebp
  803907:	89 e5                	mov    %esp,%ebp
  803909:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80390c:	a1 38 61 80 00       	mov    0x806138,%eax
  803911:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803914:	e9 85 01 00 00       	jmp    803a9e <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  803919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391c:	8b 40 0c             	mov    0xc(%eax),%eax
  80391f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803922:	0f 82 6e 01 00 00    	jb     803a96 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  803928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392b:	8b 40 0c             	mov    0xc(%eax),%eax
  80392e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803931:	0f 85 8a 00 00 00    	jne    8039c1 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  803937:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80393b:	75 17                	jne    803954 <alloc_block_FF+0x4e>
  80393d:	83 ec 04             	sub    $0x4,%esp
  803940:	68 e8 56 80 00       	push   $0x8056e8
  803945:	68 93 00 00 00       	push   $0x93
  80394a:	68 3f 56 80 00       	push   $0x80563f
  80394f:	e8 d6 df ff ff       	call   80192a <_panic>
  803954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803957:	8b 00                	mov    (%eax),%eax
  803959:	85 c0                	test   %eax,%eax
  80395b:	74 10                	je     80396d <alloc_block_FF+0x67>
  80395d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803960:	8b 00                	mov    (%eax),%eax
  803962:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803965:	8b 52 04             	mov    0x4(%edx),%edx
  803968:	89 50 04             	mov    %edx,0x4(%eax)
  80396b:	eb 0b                	jmp    803978 <alloc_block_FF+0x72>
  80396d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803970:	8b 40 04             	mov    0x4(%eax),%eax
  803973:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397b:	8b 40 04             	mov    0x4(%eax),%eax
  80397e:	85 c0                	test   %eax,%eax
  803980:	74 0f                	je     803991 <alloc_block_FF+0x8b>
  803982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803985:	8b 40 04             	mov    0x4(%eax),%eax
  803988:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80398b:	8b 12                	mov    (%edx),%edx
  80398d:	89 10                	mov    %edx,(%eax)
  80398f:	eb 0a                	jmp    80399b <alloc_block_FF+0x95>
  803991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803994:	8b 00                	mov    (%eax),%eax
  803996:	a3 38 61 80 00       	mov    %eax,0x806138
  80399b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ae:	a1 44 61 80 00       	mov    0x806144,%eax
  8039b3:	48                   	dec    %eax
  8039b4:	a3 44 61 80 00       	mov    %eax,0x806144
			   return  point;
  8039b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bc:	e9 10 01 00 00       	jmp    803ad1 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8039c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8039c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039ca:	0f 86 c6 00 00 00    	jbe    803a96 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8039d0:	a1 48 61 80 00       	mov    0x806148,%eax
  8039d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8039d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039db:	8b 50 08             	mov    0x8(%eax),%edx
  8039de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e1:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8039e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8039ea:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8039ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039f1:	75 17                	jne    803a0a <alloc_block_FF+0x104>
  8039f3:	83 ec 04             	sub    $0x4,%esp
  8039f6:	68 e8 56 80 00       	push   $0x8056e8
  8039fb:	68 9b 00 00 00       	push   $0x9b
  803a00:	68 3f 56 80 00       	push   $0x80563f
  803a05:	e8 20 df ff ff       	call   80192a <_panic>
  803a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a0d:	8b 00                	mov    (%eax),%eax
  803a0f:	85 c0                	test   %eax,%eax
  803a11:	74 10                	je     803a23 <alloc_block_FF+0x11d>
  803a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a16:	8b 00                	mov    (%eax),%eax
  803a18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a1b:	8b 52 04             	mov    0x4(%edx),%edx
  803a1e:	89 50 04             	mov    %edx,0x4(%eax)
  803a21:	eb 0b                	jmp    803a2e <alloc_block_FF+0x128>
  803a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a26:	8b 40 04             	mov    0x4(%eax),%eax
  803a29:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a31:	8b 40 04             	mov    0x4(%eax),%eax
  803a34:	85 c0                	test   %eax,%eax
  803a36:	74 0f                	je     803a47 <alloc_block_FF+0x141>
  803a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a3b:	8b 40 04             	mov    0x4(%eax),%eax
  803a3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a41:	8b 12                	mov    (%edx),%edx
  803a43:	89 10                	mov    %edx,(%eax)
  803a45:	eb 0a                	jmp    803a51 <alloc_block_FF+0x14b>
  803a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a4a:	8b 00                	mov    (%eax),%eax
  803a4c:	a3 48 61 80 00       	mov    %eax,0x806148
  803a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a64:	a1 54 61 80 00       	mov    0x806154,%eax
  803a69:	48                   	dec    %eax
  803a6a:	a3 54 61 80 00       	mov    %eax,0x806154
			   point->sva += size;
  803a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a72:	8b 50 08             	mov    0x8(%eax),%edx
  803a75:	8b 45 08             	mov    0x8(%ebp),%eax
  803a78:	01 c2                	add    %eax,%edx
  803a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  803a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a83:	8b 40 0c             	mov    0xc(%eax),%eax
  803a86:	2b 45 08             	sub    0x8(%ebp),%eax
  803a89:	89 c2                	mov    %eax,%edx
  803a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  803a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a94:	eb 3b                	jmp    803ad1 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803a96:	a1 40 61 80 00       	mov    0x806140,%eax
  803a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aa2:	74 07                	je     803aab <alloc_block_FF+0x1a5>
  803aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa7:	8b 00                	mov    (%eax),%eax
  803aa9:	eb 05                	jmp    803ab0 <alloc_block_FF+0x1aa>
  803aab:	b8 00 00 00 00       	mov    $0x0,%eax
  803ab0:	a3 40 61 80 00       	mov    %eax,0x806140
  803ab5:	a1 40 61 80 00       	mov    0x806140,%eax
  803aba:	85 c0                	test   %eax,%eax
  803abc:	0f 85 57 fe ff ff    	jne    803919 <alloc_block_FF+0x13>
  803ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ac6:	0f 85 4d fe ff ff    	jne    803919 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  803acc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ad1:	c9                   	leave  
  803ad2:	c3                   	ret    

00803ad3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803ad3:	55                   	push   %ebp
  803ad4:	89 e5                	mov    %esp,%ebp
  803ad6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  803ad9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803ae0:	a1 38 61 80 00       	mov    0x806138,%eax
  803ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ae8:	e9 df 00 00 00       	jmp    803bcc <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  803aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af0:	8b 40 0c             	mov    0xc(%eax),%eax
  803af3:	3b 45 08             	cmp    0x8(%ebp),%eax
  803af6:	0f 82 c8 00 00 00    	jb     803bc4 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  803afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aff:	8b 40 0c             	mov    0xc(%eax),%eax
  803b02:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b05:	0f 85 8a 00 00 00    	jne    803b95 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  803b0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b0f:	75 17                	jne    803b28 <alloc_block_BF+0x55>
  803b11:	83 ec 04             	sub    $0x4,%esp
  803b14:	68 e8 56 80 00       	push   $0x8056e8
  803b19:	68 b7 00 00 00       	push   $0xb7
  803b1e:	68 3f 56 80 00       	push   $0x80563f
  803b23:	e8 02 de ff ff       	call   80192a <_panic>
  803b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2b:	8b 00                	mov    (%eax),%eax
  803b2d:	85 c0                	test   %eax,%eax
  803b2f:	74 10                	je     803b41 <alloc_block_BF+0x6e>
  803b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b34:	8b 00                	mov    (%eax),%eax
  803b36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b39:	8b 52 04             	mov    0x4(%edx),%edx
  803b3c:	89 50 04             	mov    %edx,0x4(%eax)
  803b3f:	eb 0b                	jmp    803b4c <alloc_block_BF+0x79>
  803b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b44:	8b 40 04             	mov    0x4(%eax),%eax
  803b47:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4f:	8b 40 04             	mov    0x4(%eax),%eax
  803b52:	85 c0                	test   %eax,%eax
  803b54:	74 0f                	je     803b65 <alloc_block_BF+0x92>
  803b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b59:	8b 40 04             	mov    0x4(%eax),%eax
  803b5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b5f:	8b 12                	mov    (%edx),%edx
  803b61:	89 10                	mov    %edx,(%eax)
  803b63:	eb 0a                	jmp    803b6f <alloc_block_BF+0x9c>
  803b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b68:	8b 00                	mov    (%eax),%eax
  803b6a:	a3 38 61 80 00       	mov    %eax,0x806138
  803b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b82:	a1 44 61 80 00       	mov    0x806144,%eax
  803b87:	48                   	dec    %eax
  803b88:	a3 44 61 80 00       	mov    %eax,0x806144
			   return currentMemBlock;
  803b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b90:	e9 4d 01 00 00       	jmp    803ce2 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  803b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b98:	8b 40 0c             	mov    0xc(%eax),%eax
  803b9b:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b9e:	76 24                	jbe    803bc4 <alloc_block_BF+0xf1>
  803ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba3:	8b 40 0c             	mov    0xc(%eax),%eax
  803ba6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803ba9:	73 19                	jae    803bc4 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  803bab:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  803bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb5:	8b 40 0c             	mov    0xc(%eax),%eax
  803bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  803bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bbe:	8b 40 08             	mov    0x8(%eax),%eax
  803bc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803bc4:	a1 40 61 80 00       	mov    0x806140,%eax
  803bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bd0:	74 07                	je     803bd9 <alloc_block_BF+0x106>
  803bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd5:	8b 00                	mov    (%eax),%eax
  803bd7:	eb 05                	jmp    803bde <alloc_block_BF+0x10b>
  803bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bde:	a3 40 61 80 00       	mov    %eax,0x806140
  803be3:	a1 40 61 80 00       	mov    0x806140,%eax
  803be8:	85 c0                	test   %eax,%eax
  803bea:	0f 85 fd fe ff ff    	jne    803aed <alloc_block_BF+0x1a>
  803bf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bf4:	0f 85 f3 fe ff ff    	jne    803aed <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  803bfa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bfe:	0f 84 d9 00 00 00    	je     803cdd <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  803c04:	a1 48 61 80 00       	mov    0x806148,%eax
  803c09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803c0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803c12:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803c15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c18:	8b 55 08             	mov    0x8(%ebp),%edx
  803c1b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803c1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c22:	75 17                	jne    803c3b <alloc_block_BF+0x168>
  803c24:	83 ec 04             	sub    $0x4,%esp
  803c27:	68 e8 56 80 00       	push   $0x8056e8
  803c2c:	68 c7 00 00 00       	push   $0xc7
  803c31:	68 3f 56 80 00       	push   $0x80563f
  803c36:	e8 ef dc ff ff       	call   80192a <_panic>
  803c3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3e:	8b 00                	mov    (%eax),%eax
  803c40:	85 c0                	test   %eax,%eax
  803c42:	74 10                	je     803c54 <alloc_block_BF+0x181>
  803c44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c47:	8b 00                	mov    (%eax),%eax
  803c49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c4c:	8b 52 04             	mov    0x4(%edx),%edx
  803c4f:	89 50 04             	mov    %edx,0x4(%eax)
  803c52:	eb 0b                	jmp    803c5f <alloc_block_BF+0x18c>
  803c54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c57:	8b 40 04             	mov    0x4(%eax),%eax
  803c5a:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803c5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c62:	8b 40 04             	mov    0x4(%eax),%eax
  803c65:	85 c0                	test   %eax,%eax
  803c67:	74 0f                	je     803c78 <alloc_block_BF+0x1a5>
  803c69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c6c:	8b 40 04             	mov    0x4(%eax),%eax
  803c6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c72:	8b 12                	mov    (%edx),%edx
  803c74:	89 10                	mov    %edx,(%eax)
  803c76:	eb 0a                	jmp    803c82 <alloc_block_BF+0x1af>
  803c78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c7b:	8b 00                	mov    (%eax),%eax
  803c7d:	a3 48 61 80 00       	mov    %eax,0x806148
  803c82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c95:	a1 54 61 80 00       	mov    0x806154,%eax
  803c9a:	48                   	dec    %eax
  803c9b:	a3 54 61 80 00       	mov    %eax,0x806154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803ca0:	83 ec 08             	sub    $0x8,%esp
  803ca3:	ff 75 ec             	pushl  -0x14(%ebp)
  803ca6:	68 38 61 80 00       	push   $0x806138
  803cab:	e8 71 f9 ff ff       	call   803621 <find_block>
  803cb0:	83 c4 10             	add    $0x10,%esp
  803cb3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803cb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cb9:	8b 50 08             	mov    0x8(%eax),%edx
  803cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  803cbf:	01 c2                	add    %eax,%edx
  803cc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cc4:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cca:	8b 40 0c             	mov    0xc(%eax),%eax
  803ccd:	2b 45 08             	sub    0x8(%ebp),%eax
  803cd0:	89 c2                	mov    %eax,%edx
  803cd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cd5:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803cd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cdb:	eb 05                	jmp    803ce2 <alloc_block_BF+0x20f>
	}
	return NULL;
  803cdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ce2:	c9                   	leave  
  803ce3:	c3                   	ret    

00803ce4 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803ce4:	55                   	push   %ebp
  803ce5:	89 e5                	mov    %esp,%ebp
  803ce7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803cea:	a1 28 60 80 00       	mov    0x806028,%eax
  803cef:	85 c0                	test   %eax,%eax
  803cf1:	0f 85 de 01 00 00    	jne    803ed5 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803cf7:	a1 38 61 80 00       	mov    0x806138,%eax
  803cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cff:	e9 9e 01 00 00       	jmp    803ea2 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d07:	8b 40 0c             	mov    0xc(%eax),%eax
  803d0a:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d0d:	0f 82 87 01 00 00    	jb     803e9a <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d16:	8b 40 0c             	mov    0xc(%eax),%eax
  803d19:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d1c:	0f 85 95 00 00 00    	jne    803db7 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803d22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d26:	75 17                	jne    803d3f <alloc_block_NF+0x5b>
  803d28:	83 ec 04             	sub    $0x4,%esp
  803d2b:	68 e8 56 80 00       	push   $0x8056e8
  803d30:	68 e0 00 00 00       	push   $0xe0
  803d35:	68 3f 56 80 00       	push   $0x80563f
  803d3a:	e8 eb db ff ff       	call   80192a <_panic>
  803d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d42:	8b 00                	mov    (%eax),%eax
  803d44:	85 c0                	test   %eax,%eax
  803d46:	74 10                	je     803d58 <alloc_block_NF+0x74>
  803d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d4b:	8b 00                	mov    (%eax),%eax
  803d4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d50:	8b 52 04             	mov    0x4(%edx),%edx
  803d53:	89 50 04             	mov    %edx,0x4(%eax)
  803d56:	eb 0b                	jmp    803d63 <alloc_block_NF+0x7f>
  803d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5b:	8b 40 04             	mov    0x4(%eax),%eax
  803d5e:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d66:	8b 40 04             	mov    0x4(%eax),%eax
  803d69:	85 c0                	test   %eax,%eax
  803d6b:	74 0f                	je     803d7c <alloc_block_NF+0x98>
  803d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d70:	8b 40 04             	mov    0x4(%eax),%eax
  803d73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d76:	8b 12                	mov    (%edx),%edx
  803d78:	89 10                	mov    %edx,(%eax)
  803d7a:	eb 0a                	jmp    803d86 <alloc_block_NF+0xa2>
  803d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d7f:	8b 00                	mov    (%eax),%eax
  803d81:	a3 38 61 80 00       	mov    %eax,0x806138
  803d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d99:	a1 44 61 80 00       	mov    0x806144,%eax
  803d9e:	48                   	dec    %eax
  803d9f:	a3 44 61 80 00       	mov    %eax,0x806144
				   svaOfNF = point->sva;
  803da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da7:	8b 40 08             	mov    0x8(%eax),%eax
  803daa:	a3 28 60 80 00       	mov    %eax,0x806028
				   return  point;
  803daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db2:	e9 f8 04 00 00       	jmp    8042af <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dba:	8b 40 0c             	mov    0xc(%eax),%eax
  803dbd:	3b 45 08             	cmp    0x8(%ebp),%eax
  803dc0:	0f 86 d4 00 00 00    	jbe    803e9a <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803dc6:	a1 48 61 80 00       	mov    0x806148,%eax
  803dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd1:	8b 50 08             	mov    0x8(%eax),%edx
  803dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd7:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ddd:	8b 55 08             	mov    0x8(%ebp),%edx
  803de0:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803de3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803de7:	75 17                	jne    803e00 <alloc_block_NF+0x11c>
  803de9:	83 ec 04             	sub    $0x4,%esp
  803dec:	68 e8 56 80 00       	push   $0x8056e8
  803df1:	68 e9 00 00 00       	push   $0xe9
  803df6:	68 3f 56 80 00       	push   $0x80563f
  803dfb:	e8 2a db ff ff       	call   80192a <_panic>
  803e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e03:	8b 00                	mov    (%eax),%eax
  803e05:	85 c0                	test   %eax,%eax
  803e07:	74 10                	je     803e19 <alloc_block_NF+0x135>
  803e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e0c:	8b 00                	mov    (%eax),%eax
  803e0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e11:	8b 52 04             	mov    0x4(%edx),%edx
  803e14:	89 50 04             	mov    %edx,0x4(%eax)
  803e17:	eb 0b                	jmp    803e24 <alloc_block_NF+0x140>
  803e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e1c:	8b 40 04             	mov    0x4(%eax),%eax
  803e1f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e27:	8b 40 04             	mov    0x4(%eax),%eax
  803e2a:	85 c0                	test   %eax,%eax
  803e2c:	74 0f                	je     803e3d <alloc_block_NF+0x159>
  803e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e31:	8b 40 04             	mov    0x4(%eax),%eax
  803e34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e37:	8b 12                	mov    (%edx),%edx
  803e39:	89 10                	mov    %edx,(%eax)
  803e3b:	eb 0a                	jmp    803e47 <alloc_block_NF+0x163>
  803e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e40:	8b 00                	mov    (%eax),%eax
  803e42:	a3 48 61 80 00       	mov    %eax,0x806148
  803e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e5a:	a1 54 61 80 00       	mov    0x806154,%eax
  803e5f:	48                   	dec    %eax
  803e60:	a3 54 61 80 00       	mov    %eax,0x806154
				   svaOfNF = ReturnedBlock->sva;
  803e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e68:	8b 40 08             	mov    0x8(%eax),%eax
  803e6b:	a3 28 60 80 00       	mov    %eax,0x806028
				   point->sva += size;
  803e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e73:	8b 50 08             	mov    0x8(%eax),%edx
  803e76:	8b 45 08             	mov    0x8(%ebp),%eax
  803e79:	01 c2                	add    %eax,%edx
  803e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e7e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e84:	8b 40 0c             	mov    0xc(%eax),%eax
  803e87:	2b 45 08             	sub    0x8(%ebp),%eax
  803e8a:	89 c2                	mov    %eax,%edx
  803e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e8f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e95:	e9 15 04 00 00       	jmp    8042af <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803e9a:	a1 40 61 80 00       	mov    0x806140,%eax
  803e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ea2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ea6:	74 07                	je     803eaf <alloc_block_NF+0x1cb>
  803ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eab:	8b 00                	mov    (%eax),%eax
  803ead:	eb 05                	jmp    803eb4 <alloc_block_NF+0x1d0>
  803eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  803eb4:	a3 40 61 80 00       	mov    %eax,0x806140
  803eb9:	a1 40 61 80 00       	mov    0x806140,%eax
  803ebe:	85 c0                	test   %eax,%eax
  803ec0:	0f 85 3e fe ff ff    	jne    803d04 <alloc_block_NF+0x20>
  803ec6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eca:	0f 85 34 fe ff ff    	jne    803d04 <alloc_block_NF+0x20>
  803ed0:	e9 d5 03 00 00       	jmp    8042aa <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803ed5:	a1 38 61 80 00       	mov    0x806138,%eax
  803eda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803edd:	e9 b1 01 00 00       	jmp    804093 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee5:	8b 50 08             	mov    0x8(%eax),%edx
  803ee8:	a1 28 60 80 00       	mov    0x806028,%eax
  803eed:	39 c2                	cmp    %eax,%edx
  803eef:	0f 82 96 01 00 00    	jb     80408b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  803efb:	3b 45 08             	cmp    0x8(%ebp),%eax
  803efe:	0f 82 87 01 00 00    	jb     80408b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f07:	8b 40 0c             	mov    0xc(%eax),%eax
  803f0a:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f0d:	0f 85 95 00 00 00    	jne    803fa8 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803f13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f17:	75 17                	jne    803f30 <alloc_block_NF+0x24c>
  803f19:	83 ec 04             	sub    $0x4,%esp
  803f1c:	68 e8 56 80 00       	push   $0x8056e8
  803f21:	68 fc 00 00 00       	push   $0xfc
  803f26:	68 3f 56 80 00       	push   $0x80563f
  803f2b:	e8 fa d9 ff ff       	call   80192a <_panic>
  803f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f33:	8b 00                	mov    (%eax),%eax
  803f35:	85 c0                	test   %eax,%eax
  803f37:	74 10                	je     803f49 <alloc_block_NF+0x265>
  803f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f3c:	8b 00                	mov    (%eax),%eax
  803f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f41:	8b 52 04             	mov    0x4(%edx),%edx
  803f44:	89 50 04             	mov    %edx,0x4(%eax)
  803f47:	eb 0b                	jmp    803f54 <alloc_block_NF+0x270>
  803f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f4c:	8b 40 04             	mov    0x4(%eax),%eax
  803f4f:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f57:	8b 40 04             	mov    0x4(%eax),%eax
  803f5a:	85 c0                	test   %eax,%eax
  803f5c:	74 0f                	je     803f6d <alloc_block_NF+0x289>
  803f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f61:	8b 40 04             	mov    0x4(%eax),%eax
  803f64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f67:	8b 12                	mov    (%edx),%edx
  803f69:	89 10                	mov    %edx,(%eax)
  803f6b:	eb 0a                	jmp    803f77 <alloc_block_NF+0x293>
  803f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f70:	8b 00                	mov    (%eax),%eax
  803f72:	a3 38 61 80 00       	mov    %eax,0x806138
  803f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f8a:	a1 44 61 80 00       	mov    0x806144,%eax
  803f8f:	48                   	dec    %eax
  803f90:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f98:	8b 40 08             	mov    0x8(%eax),%eax
  803f9b:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa3:	e9 07 03 00 00       	jmp    8042af <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fab:	8b 40 0c             	mov    0xc(%eax),%eax
  803fae:	3b 45 08             	cmp    0x8(%ebp),%eax
  803fb1:	0f 86 d4 00 00 00    	jbe    80408b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803fb7:	a1 48 61 80 00       	mov    0x806148,%eax
  803fbc:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc2:	8b 50 08             	mov    0x8(%eax),%edx
  803fc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fc8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803fcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fce:	8b 55 08             	mov    0x8(%ebp),%edx
  803fd1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803fd4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803fd8:	75 17                	jne    803ff1 <alloc_block_NF+0x30d>
  803fda:	83 ec 04             	sub    $0x4,%esp
  803fdd:	68 e8 56 80 00       	push   $0x8056e8
  803fe2:	68 04 01 00 00       	push   $0x104
  803fe7:	68 3f 56 80 00       	push   $0x80563f
  803fec:	e8 39 d9 ff ff       	call   80192a <_panic>
  803ff1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ff4:	8b 00                	mov    (%eax),%eax
  803ff6:	85 c0                	test   %eax,%eax
  803ff8:	74 10                	je     80400a <alloc_block_NF+0x326>
  803ffa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ffd:	8b 00                	mov    (%eax),%eax
  803fff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804002:	8b 52 04             	mov    0x4(%edx),%edx
  804005:	89 50 04             	mov    %edx,0x4(%eax)
  804008:	eb 0b                	jmp    804015 <alloc_block_NF+0x331>
  80400a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80400d:	8b 40 04             	mov    0x4(%eax),%eax
  804010:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804015:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804018:	8b 40 04             	mov    0x4(%eax),%eax
  80401b:	85 c0                	test   %eax,%eax
  80401d:	74 0f                	je     80402e <alloc_block_NF+0x34a>
  80401f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804022:	8b 40 04             	mov    0x4(%eax),%eax
  804025:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804028:	8b 12                	mov    (%edx),%edx
  80402a:	89 10                	mov    %edx,(%eax)
  80402c:	eb 0a                	jmp    804038 <alloc_block_NF+0x354>
  80402e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804031:	8b 00                	mov    (%eax),%eax
  804033:	a3 48 61 80 00       	mov    %eax,0x806148
  804038:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80403b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804041:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804044:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80404b:	a1 54 61 80 00       	mov    0x806154,%eax
  804050:	48                   	dec    %eax
  804051:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  804056:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804059:	8b 40 08             	mov    0x8(%eax),%eax
  80405c:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  804061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804064:	8b 50 08             	mov    0x8(%eax),%edx
  804067:	8b 45 08             	mov    0x8(%ebp),%eax
  80406a:	01 c2                	add    %eax,%edx
  80406c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80406f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  804072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804075:	8b 40 0c             	mov    0xc(%eax),%eax
  804078:	2b 45 08             	sub    0x8(%ebp),%eax
  80407b:	89 c2                	mov    %eax,%edx
  80407d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804080:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  804083:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804086:	e9 24 02 00 00       	jmp    8042af <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80408b:	a1 40 61 80 00       	mov    0x806140,%eax
  804090:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804093:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804097:	74 07                	je     8040a0 <alloc_block_NF+0x3bc>
  804099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80409c:	8b 00                	mov    (%eax),%eax
  80409e:	eb 05                	jmp    8040a5 <alloc_block_NF+0x3c1>
  8040a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8040a5:	a3 40 61 80 00       	mov    %eax,0x806140
  8040aa:	a1 40 61 80 00       	mov    0x806140,%eax
  8040af:	85 c0                	test   %eax,%eax
  8040b1:	0f 85 2b fe ff ff    	jne    803ee2 <alloc_block_NF+0x1fe>
  8040b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040bb:	0f 85 21 fe ff ff    	jne    803ee2 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8040c1:	a1 38 61 80 00       	mov    0x806138,%eax
  8040c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8040c9:	e9 ae 01 00 00       	jmp    80427c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8040ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040d1:	8b 50 08             	mov    0x8(%eax),%edx
  8040d4:	a1 28 60 80 00       	mov    0x806028,%eax
  8040d9:	39 c2                	cmp    %eax,%edx
  8040db:	0f 83 93 01 00 00    	jae    804274 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8040e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8040e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8040ea:	0f 82 84 01 00 00    	jb     804274 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8040f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8040f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8040f9:	0f 85 95 00 00 00    	jne    804194 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8040ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804103:	75 17                	jne    80411c <alloc_block_NF+0x438>
  804105:	83 ec 04             	sub    $0x4,%esp
  804108:	68 e8 56 80 00       	push   $0x8056e8
  80410d:	68 14 01 00 00       	push   $0x114
  804112:	68 3f 56 80 00       	push   $0x80563f
  804117:	e8 0e d8 ff ff       	call   80192a <_panic>
  80411c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80411f:	8b 00                	mov    (%eax),%eax
  804121:	85 c0                	test   %eax,%eax
  804123:	74 10                	je     804135 <alloc_block_NF+0x451>
  804125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804128:	8b 00                	mov    (%eax),%eax
  80412a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80412d:	8b 52 04             	mov    0x4(%edx),%edx
  804130:	89 50 04             	mov    %edx,0x4(%eax)
  804133:	eb 0b                	jmp    804140 <alloc_block_NF+0x45c>
  804135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804138:	8b 40 04             	mov    0x4(%eax),%eax
  80413b:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804143:	8b 40 04             	mov    0x4(%eax),%eax
  804146:	85 c0                	test   %eax,%eax
  804148:	74 0f                	je     804159 <alloc_block_NF+0x475>
  80414a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80414d:	8b 40 04             	mov    0x4(%eax),%eax
  804150:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804153:	8b 12                	mov    (%edx),%edx
  804155:	89 10                	mov    %edx,(%eax)
  804157:	eb 0a                	jmp    804163 <alloc_block_NF+0x47f>
  804159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80415c:	8b 00                	mov    (%eax),%eax
  80415e:	a3 38 61 80 00       	mov    %eax,0x806138
  804163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804166:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80416c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80416f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804176:	a1 44 61 80 00       	mov    0x806144,%eax
  80417b:	48                   	dec    %eax
  80417c:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  804181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804184:	8b 40 08             	mov    0x8(%eax),%eax
  804187:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  80418c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80418f:	e9 1b 01 00 00       	jmp    8042af <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  804194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804197:	8b 40 0c             	mov    0xc(%eax),%eax
  80419a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80419d:	0f 86 d1 00 00 00    	jbe    804274 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8041a3:	a1 48 61 80 00       	mov    0x806148,%eax
  8041a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8041ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041ae:	8b 50 08             	mov    0x8(%eax),%edx
  8041b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041b4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8041b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8041bd:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8041c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8041c4:	75 17                	jne    8041dd <alloc_block_NF+0x4f9>
  8041c6:	83 ec 04             	sub    $0x4,%esp
  8041c9:	68 e8 56 80 00       	push   $0x8056e8
  8041ce:	68 1c 01 00 00       	push   $0x11c
  8041d3:	68 3f 56 80 00       	push   $0x80563f
  8041d8:	e8 4d d7 ff ff       	call   80192a <_panic>
  8041dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041e0:	8b 00                	mov    (%eax),%eax
  8041e2:	85 c0                	test   %eax,%eax
  8041e4:	74 10                	je     8041f6 <alloc_block_NF+0x512>
  8041e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041e9:	8b 00                	mov    (%eax),%eax
  8041eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8041ee:	8b 52 04             	mov    0x4(%edx),%edx
  8041f1:	89 50 04             	mov    %edx,0x4(%eax)
  8041f4:	eb 0b                	jmp    804201 <alloc_block_NF+0x51d>
  8041f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041f9:	8b 40 04             	mov    0x4(%eax),%eax
  8041fc:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804201:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804204:	8b 40 04             	mov    0x4(%eax),%eax
  804207:	85 c0                	test   %eax,%eax
  804209:	74 0f                	je     80421a <alloc_block_NF+0x536>
  80420b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80420e:	8b 40 04             	mov    0x4(%eax),%eax
  804211:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804214:	8b 12                	mov    (%edx),%edx
  804216:	89 10                	mov    %edx,(%eax)
  804218:	eb 0a                	jmp    804224 <alloc_block_NF+0x540>
  80421a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80421d:	8b 00                	mov    (%eax),%eax
  80421f:	a3 48 61 80 00       	mov    %eax,0x806148
  804224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804227:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80422d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804230:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804237:	a1 54 61 80 00       	mov    0x806154,%eax
  80423c:	48                   	dec    %eax
  80423d:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  804242:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804245:	8b 40 08             	mov    0x8(%eax),%eax
  804248:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  80424d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804250:	8b 50 08             	mov    0x8(%eax),%edx
  804253:	8b 45 08             	mov    0x8(%ebp),%eax
  804256:	01 c2                	add    %eax,%edx
  804258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80425b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80425e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804261:	8b 40 0c             	mov    0xc(%eax),%eax
  804264:	2b 45 08             	sub    0x8(%ebp),%eax
  804267:	89 c2                	mov    %eax,%edx
  804269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80426c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80426f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804272:	eb 3b                	jmp    8042af <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  804274:	a1 40 61 80 00       	mov    0x806140,%eax
  804279:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80427c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804280:	74 07                	je     804289 <alloc_block_NF+0x5a5>
  804282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804285:	8b 00                	mov    (%eax),%eax
  804287:	eb 05                	jmp    80428e <alloc_block_NF+0x5aa>
  804289:	b8 00 00 00 00       	mov    $0x0,%eax
  80428e:	a3 40 61 80 00       	mov    %eax,0x806140
  804293:	a1 40 61 80 00       	mov    0x806140,%eax
  804298:	85 c0                	test   %eax,%eax
  80429a:	0f 85 2e fe ff ff    	jne    8040ce <alloc_block_NF+0x3ea>
  8042a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042a4:	0f 85 24 fe ff ff    	jne    8040ce <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8042aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042af:	c9                   	leave  
  8042b0:	c3                   	ret    

008042b1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8042b1:	55                   	push   %ebp
  8042b2:	89 e5                	mov    %esp,%ebp
  8042b4:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8042b7:	a1 38 61 80 00       	mov    0x806138,%eax
  8042bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8042bf:	a1 3c 61 80 00       	mov    0x80613c,%eax
  8042c4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8042c7:	a1 38 61 80 00       	mov    0x806138,%eax
  8042cc:	85 c0                	test   %eax,%eax
  8042ce:	74 14                	je     8042e4 <insert_sorted_with_merge_freeList+0x33>
  8042d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8042d3:	8b 50 08             	mov    0x8(%eax),%edx
  8042d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042d9:	8b 40 08             	mov    0x8(%eax),%eax
  8042dc:	39 c2                	cmp    %eax,%edx
  8042de:	0f 87 9b 01 00 00    	ja     80447f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8042e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042e8:	75 17                	jne    804301 <insert_sorted_with_merge_freeList+0x50>
  8042ea:	83 ec 04             	sub    $0x4,%esp
  8042ed:	68 1c 56 80 00       	push   $0x80561c
  8042f2:	68 38 01 00 00       	push   $0x138
  8042f7:	68 3f 56 80 00       	push   $0x80563f
  8042fc:	e8 29 d6 ff ff       	call   80192a <_panic>
  804301:	8b 15 38 61 80 00    	mov    0x806138,%edx
  804307:	8b 45 08             	mov    0x8(%ebp),%eax
  80430a:	89 10                	mov    %edx,(%eax)
  80430c:	8b 45 08             	mov    0x8(%ebp),%eax
  80430f:	8b 00                	mov    (%eax),%eax
  804311:	85 c0                	test   %eax,%eax
  804313:	74 0d                	je     804322 <insert_sorted_with_merge_freeList+0x71>
  804315:	a1 38 61 80 00       	mov    0x806138,%eax
  80431a:	8b 55 08             	mov    0x8(%ebp),%edx
  80431d:	89 50 04             	mov    %edx,0x4(%eax)
  804320:	eb 08                	jmp    80432a <insert_sorted_with_merge_freeList+0x79>
  804322:	8b 45 08             	mov    0x8(%ebp),%eax
  804325:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80432a:	8b 45 08             	mov    0x8(%ebp),%eax
  80432d:	a3 38 61 80 00       	mov    %eax,0x806138
  804332:	8b 45 08             	mov    0x8(%ebp),%eax
  804335:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80433c:	a1 44 61 80 00       	mov    0x806144,%eax
  804341:	40                   	inc    %eax
  804342:	a3 44 61 80 00       	mov    %eax,0x806144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  804347:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80434b:	0f 84 a8 06 00 00    	je     8049f9 <insert_sorted_with_merge_freeList+0x748>
  804351:	8b 45 08             	mov    0x8(%ebp),%eax
  804354:	8b 50 08             	mov    0x8(%eax),%edx
  804357:	8b 45 08             	mov    0x8(%ebp),%eax
  80435a:	8b 40 0c             	mov    0xc(%eax),%eax
  80435d:	01 c2                	add    %eax,%edx
  80435f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804362:	8b 40 08             	mov    0x8(%eax),%eax
  804365:	39 c2                	cmp    %eax,%edx
  804367:	0f 85 8c 06 00 00    	jne    8049f9 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80436d:	8b 45 08             	mov    0x8(%ebp),%eax
  804370:	8b 50 0c             	mov    0xc(%eax),%edx
  804373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804376:	8b 40 0c             	mov    0xc(%eax),%eax
  804379:	01 c2                	add    %eax,%edx
  80437b:	8b 45 08             	mov    0x8(%ebp),%eax
  80437e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  804381:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804385:	75 17                	jne    80439e <insert_sorted_with_merge_freeList+0xed>
  804387:	83 ec 04             	sub    $0x4,%esp
  80438a:	68 e8 56 80 00       	push   $0x8056e8
  80438f:	68 3c 01 00 00       	push   $0x13c
  804394:	68 3f 56 80 00       	push   $0x80563f
  804399:	e8 8c d5 ff ff       	call   80192a <_panic>
  80439e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043a1:	8b 00                	mov    (%eax),%eax
  8043a3:	85 c0                	test   %eax,%eax
  8043a5:	74 10                	je     8043b7 <insert_sorted_with_merge_freeList+0x106>
  8043a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043aa:	8b 00                	mov    (%eax),%eax
  8043ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043af:	8b 52 04             	mov    0x4(%edx),%edx
  8043b2:	89 50 04             	mov    %edx,0x4(%eax)
  8043b5:	eb 0b                	jmp    8043c2 <insert_sorted_with_merge_freeList+0x111>
  8043b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043ba:	8b 40 04             	mov    0x4(%eax),%eax
  8043bd:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8043c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043c5:	8b 40 04             	mov    0x4(%eax),%eax
  8043c8:	85 c0                	test   %eax,%eax
  8043ca:	74 0f                	je     8043db <insert_sorted_with_merge_freeList+0x12a>
  8043cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043cf:	8b 40 04             	mov    0x4(%eax),%eax
  8043d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043d5:	8b 12                	mov    (%edx),%edx
  8043d7:	89 10                	mov    %edx,(%eax)
  8043d9:	eb 0a                	jmp    8043e5 <insert_sorted_with_merge_freeList+0x134>
  8043db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043de:	8b 00                	mov    (%eax),%eax
  8043e0:	a3 38 61 80 00       	mov    %eax,0x806138
  8043e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043f8:	a1 44 61 80 00       	mov    0x806144,%eax
  8043fd:	48                   	dec    %eax
  8043fe:	a3 44 61 80 00       	mov    %eax,0x806144
			head->size = 0;
  804403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804406:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80440d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804410:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  804417:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80441b:	75 17                	jne    804434 <insert_sorted_with_merge_freeList+0x183>
  80441d:	83 ec 04             	sub    $0x4,%esp
  804420:	68 1c 56 80 00       	push   $0x80561c
  804425:	68 3f 01 00 00       	push   $0x13f
  80442a:	68 3f 56 80 00       	push   $0x80563f
  80442f:	e8 f6 d4 ff ff       	call   80192a <_panic>
  804434:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80443a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80443d:	89 10                	mov    %edx,(%eax)
  80443f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804442:	8b 00                	mov    (%eax),%eax
  804444:	85 c0                	test   %eax,%eax
  804446:	74 0d                	je     804455 <insert_sorted_with_merge_freeList+0x1a4>
  804448:	a1 48 61 80 00       	mov    0x806148,%eax
  80444d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804450:	89 50 04             	mov    %edx,0x4(%eax)
  804453:	eb 08                	jmp    80445d <insert_sorted_with_merge_freeList+0x1ac>
  804455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804458:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80445d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804460:	a3 48 61 80 00       	mov    %eax,0x806148
  804465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804468:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80446f:	a1 54 61 80 00       	mov    0x806154,%eax
  804474:	40                   	inc    %eax
  804475:	a3 54 61 80 00       	mov    %eax,0x806154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80447a:	e9 7a 05 00 00       	jmp    8049f9 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80447f:	8b 45 08             	mov    0x8(%ebp),%eax
  804482:	8b 50 08             	mov    0x8(%eax),%edx
  804485:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804488:	8b 40 08             	mov    0x8(%eax),%eax
  80448b:	39 c2                	cmp    %eax,%edx
  80448d:	0f 82 14 01 00 00    	jb     8045a7 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  804493:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804496:	8b 50 08             	mov    0x8(%eax),%edx
  804499:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80449c:	8b 40 0c             	mov    0xc(%eax),%eax
  80449f:	01 c2                	add    %eax,%edx
  8044a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8044a4:	8b 40 08             	mov    0x8(%eax),%eax
  8044a7:	39 c2                	cmp    %eax,%edx
  8044a9:	0f 85 90 00 00 00    	jne    80453f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8044af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044b2:	8b 50 0c             	mov    0xc(%eax),%edx
  8044b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8044b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8044bb:	01 c2                	add    %eax,%edx
  8044bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044c0:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8044c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8044c6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8044cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8044d0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8044d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8044db:	75 17                	jne    8044f4 <insert_sorted_with_merge_freeList+0x243>
  8044dd:	83 ec 04             	sub    $0x4,%esp
  8044e0:	68 1c 56 80 00       	push   $0x80561c
  8044e5:	68 49 01 00 00       	push   $0x149
  8044ea:	68 3f 56 80 00       	push   $0x80563f
  8044ef:	e8 36 d4 ff ff       	call   80192a <_panic>
  8044f4:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8044fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8044fd:	89 10                	mov    %edx,(%eax)
  8044ff:	8b 45 08             	mov    0x8(%ebp),%eax
  804502:	8b 00                	mov    (%eax),%eax
  804504:	85 c0                	test   %eax,%eax
  804506:	74 0d                	je     804515 <insert_sorted_with_merge_freeList+0x264>
  804508:	a1 48 61 80 00       	mov    0x806148,%eax
  80450d:	8b 55 08             	mov    0x8(%ebp),%edx
  804510:	89 50 04             	mov    %edx,0x4(%eax)
  804513:	eb 08                	jmp    80451d <insert_sorted_with_merge_freeList+0x26c>
  804515:	8b 45 08             	mov    0x8(%ebp),%eax
  804518:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80451d:	8b 45 08             	mov    0x8(%ebp),%eax
  804520:	a3 48 61 80 00       	mov    %eax,0x806148
  804525:	8b 45 08             	mov    0x8(%ebp),%eax
  804528:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80452f:	a1 54 61 80 00       	mov    0x806154,%eax
  804534:	40                   	inc    %eax
  804535:	a3 54 61 80 00       	mov    %eax,0x806154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80453a:	e9 bb 04 00 00       	jmp    8049fa <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80453f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804543:	75 17                	jne    80455c <insert_sorted_with_merge_freeList+0x2ab>
  804545:	83 ec 04             	sub    $0x4,%esp
  804548:	68 90 56 80 00       	push   $0x805690
  80454d:	68 4c 01 00 00       	push   $0x14c
  804552:	68 3f 56 80 00       	push   $0x80563f
  804557:	e8 ce d3 ff ff       	call   80192a <_panic>
  80455c:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  804562:	8b 45 08             	mov    0x8(%ebp),%eax
  804565:	89 50 04             	mov    %edx,0x4(%eax)
  804568:	8b 45 08             	mov    0x8(%ebp),%eax
  80456b:	8b 40 04             	mov    0x4(%eax),%eax
  80456e:	85 c0                	test   %eax,%eax
  804570:	74 0c                	je     80457e <insert_sorted_with_merge_freeList+0x2cd>
  804572:	a1 3c 61 80 00       	mov    0x80613c,%eax
  804577:	8b 55 08             	mov    0x8(%ebp),%edx
  80457a:	89 10                	mov    %edx,(%eax)
  80457c:	eb 08                	jmp    804586 <insert_sorted_with_merge_freeList+0x2d5>
  80457e:	8b 45 08             	mov    0x8(%ebp),%eax
  804581:	a3 38 61 80 00       	mov    %eax,0x806138
  804586:	8b 45 08             	mov    0x8(%ebp),%eax
  804589:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80458e:	8b 45 08             	mov    0x8(%ebp),%eax
  804591:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804597:	a1 44 61 80 00       	mov    0x806144,%eax
  80459c:	40                   	inc    %eax
  80459d:	a3 44 61 80 00       	mov    %eax,0x806144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8045a2:	e9 53 04 00 00       	jmp    8049fa <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8045a7:	a1 38 61 80 00       	mov    0x806138,%eax
  8045ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8045af:	e9 15 04 00 00       	jmp    8049c9 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8045b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045b7:	8b 00                	mov    (%eax),%eax
  8045b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8045bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8045bf:	8b 50 08             	mov    0x8(%eax),%edx
  8045c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045c5:	8b 40 08             	mov    0x8(%eax),%eax
  8045c8:	39 c2                	cmp    %eax,%edx
  8045ca:	0f 86 f1 03 00 00    	jbe    8049c1 <insert_sorted_with_merge_freeList+0x710>
  8045d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8045d3:	8b 50 08             	mov    0x8(%eax),%edx
  8045d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045d9:	8b 40 08             	mov    0x8(%eax),%eax
  8045dc:	39 c2                	cmp    %eax,%edx
  8045de:	0f 83 dd 03 00 00    	jae    8049c1 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8045e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045e7:	8b 50 08             	mov    0x8(%eax),%edx
  8045ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8045f0:	01 c2                	add    %eax,%edx
  8045f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8045f5:	8b 40 08             	mov    0x8(%eax),%eax
  8045f8:	39 c2                	cmp    %eax,%edx
  8045fa:	0f 85 b9 01 00 00    	jne    8047b9 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  804600:	8b 45 08             	mov    0x8(%ebp),%eax
  804603:	8b 50 08             	mov    0x8(%eax),%edx
  804606:	8b 45 08             	mov    0x8(%ebp),%eax
  804609:	8b 40 0c             	mov    0xc(%eax),%eax
  80460c:	01 c2                	add    %eax,%edx
  80460e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804611:	8b 40 08             	mov    0x8(%eax),%eax
  804614:	39 c2                	cmp    %eax,%edx
  804616:	0f 85 0d 01 00 00    	jne    804729 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80461c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80461f:	8b 50 0c             	mov    0xc(%eax),%edx
  804622:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804625:	8b 40 0c             	mov    0xc(%eax),%eax
  804628:	01 c2                	add    %eax,%edx
  80462a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80462d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  804630:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804634:	75 17                	jne    80464d <insert_sorted_with_merge_freeList+0x39c>
  804636:	83 ec 04             	sub    $0x4,%esp
  804639:	68 e8 56 80 00       	push   $0x8056e8
  80463e:	68 5c 01 00 00       	push   $0x15c
  804643:	68 3f 56 80 00       	push   $0x80563f
  804648:	e8 dd d2 ff ff       	call   80192a <_panic>
  80464d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804650:	8b 00                	mov    (%eax),%eax
  804652:	85 c0                	test   %eax,%eax
  804654:	74 10                	je     804666 <insert_sorted_with_merge_freeList+0x3b5>
  804656:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804659:	8b 00                	mov    (%eax),%eax
  80465b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80465e:	8b 52 04             	mov    0x4(%edx),%edx
  804661:	89 50 04             	mov    %edx,0x4(%eax)
  804664:	eb 0b                	jmp    804671 <insert_sorted_with_merge_freeList+0x3c0>
  804666:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804669:	8b 40 04             	mov    0x4(%eax),%eax
  80466c:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804671:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804674:	8b 40 04             	mov    0x4(%eax),%eax
  804677:	85 c0                	test   %eax,%eax
  804679:	74 0f                	je     80468a <insert_sorted_with_merge_freeList+0x3d9>
  80467b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80467e:	8b 40 04             	mov    0x4(%eax),%eax
  804681:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804684:	8b 12                	mov    (%edx),%edx
  804686:	89 10                	mov    %edx,(%eax)
  804688:	eb 0a                	jmp    804694 <insert_sorted_with_merge_freeList+0x3e3>
  80468a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80468d:	8b 00                	mov    (%eax),%eax
  80468f:	a3 38 61 80 00       	mov    %eax,0x806138
  804694:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804697:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80469d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8046a7:	a1 44 61 80 00       	mov    0x806144,%eax
  8046ac:	48                   	dec    %eax
  8046ad:	a3 44 61 80 00       	mov    %eax,0x806144
						nextBlock->sva = 0;
  8046b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046b5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8046bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046bf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8046c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8046ca:	75 17                	jne    8046e3 <insert_sorted_with_merge_freeList+0x432>
  8046cc:	83 ec 04             	sub    $0x4,%esp
  8046cf:	68 1c 56 80 00       	push   $0x80561c
  8046d4:	68 5f 01 00 00       	push   $0x15f
  8046d9:	68 3f 56 80 00       	push   $0x80563f
  8046de:	e8 47 d2 ff ff       	call   80192a <_panic>
  8046e3:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8046e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046ec:	89 10                	mov    %edx,(%eax)
  8046ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046f1:	8b 00                	mov    (%eax),%eax
  8046f3:	85 c0                	test   %eax,%eax
  8046f5:	74 0d                	je     804704 <insert_sorted_with_merge_freeList+0x453>
  8046f7:	a1 48 61 80 00       	mov    0x806148,%eax
  8046fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8046ff:	89 50 04             	mov    %edx,0x4(%eax)
  804702:	eb 08                	jmp    80470c <insert_sorted_with_merge_freeList+0x45b>
  804704:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804707:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80470c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80470f:	a3 48 61 80 00       	mov    %eax,0x806148
  804714:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804717:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80471e:	a1 54 61 80 00       	mov    0x806154,%eax
  804723:	40                   	inc    %eax
  804724:	a3 54 61 80 00       	mov    %eax,0x806154
					}
					currentBlock->size += blockToInsert->size;
  804729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80472c:	8b 50 0c             	mov    0xc(%eax),%edx
  80472f:	8b 45 08             	mov    0x8(%ebp),%eax
  804732:	8b 40 0c             	mov    0xc(%eax),%eax
  804735:	01 c2                	add    %eax,%edx
  804737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80473a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80473d:	8b 45 08             	mov    0x8(%ebp),%eax
  804740:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  804747:	8b 45 08             	mov    0x8(%ebp),%eax
  80474a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  804751:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804755:	75 17                	jne    80476e <insert_sorted_with_merge_freeList+0x4bd>
  804757:	83 ec 04             	sub    $0x4,%esp
  80475a:	68 1c 56 80 00       	push   $0x80561c
  80475f:	68 64 01 00 00       	push   $0x164
  804764:	68 3f 56 80 00       	push   $0x80563f
  804769:	e8 bc d1 ff ff       	call   80192a <_panic>
  80476e:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804774:	8b 45 08             	mov    0x8(%ebp),%eax
  804777:	89 10                	mov    %edx,(%eax)
  804779:	8b 45 08             	mov    0x8(%ebp),%eax
  80477c:	8b 00                	mov    (%eax),%eax
  80477e:	85 c0                	test   %eax,%eax
  804780:	74 0d                	je     80478f <insert_sorted_with_merge_freeList+0x4de>
  804782:	a1 48 61 80 00       	mov    0x806148,%eax
  804787:	8b 55 08             	mov    0x8(%ebp),%edx
  80478a:	89 50 04             	mov    %edx,0x4(%eax)
  80478d:	eb 08                	jmp    804797 <insert_sorted_with_merge_freeList+0x4e6>
  80478f:	8b 45 08             	mov    0x8(%ebp),%eax
  804792:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804797:	8b 45 08             	mov    0x8(%ebp),%eax
  80479a:	a3 48 61 80 00       	mov    %eax,0x806148
  80479f:	8b 45 08             	mov    0x8(%ebp),%eax
  8047a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8047a9:	a1 54 61 80 00       	mov    0x806154,%eax
  8047ae:	40                   	inc    %eax
  8047af:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  8047b4:	e9 41 02 00 00       	jmp    8049fa <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8047b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8047bc:	8b 50 08             	mov    0x8(%eax),%edx
  8047bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8047c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8047c5:	01 c2                	add    %eax,%edx
  8047c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047ca:	8b 40 08             	mov    0x8(%eax),%eax
  8047cd:	39 c2                	cmp    %eax,%edx
  8047cf:	0f 85 7c 01 00 00    	jne    804951 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8047d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8047d9:	74 06                	je     8047e1 <insert_sorted_with_merge_freeList+0x530>
  8047db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8047df:	75 17                	jne    8047f8 <insert_sorted_with_merge_freeList+0x547>
  8047e1:	83 ec 04             	sub    $0x4,%esp
  8047e4:	68 58 56 80 00       	push   $0x805658
  8047e9:	68 69 01 00 00       	push   $0x169
  8047ee:	68 3f 56 80 00       	push   $0x80563f
  8047f3:	e8 32 d1 ff ff       	call   80192a <_panic>
  8047f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047fb:	8b 50 04             	mov    0x4(%eax),%edx
  8047fe:	8b 45 08             	mov    0x8(%ebp),%eax
  804801:	89 50 04             	mov    %edx,0x4(%eax)
  804804:	8b 45 08             	mov    0x8(%ebp),%eax
  804807:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80480a:	89 10                	mov    %edx,(%eax)
  80480c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80480f:	8b 40 04             	mov    0x4(%eax),%eax
  804812:	85 c0                	test   %eax,%eax
  804814:	74 0d                	je     804823 <insert_sorted_with_merge_freeList+0x572>
  804816:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804819:	8b 40 04             	mov    0x4(%eax),%eax
  80481c:	8b 55 08             	mov    0x8(%ebp),%edx
  80481f:	89 10                	mov    %edx,(%eax)
  804821:	eb 08                	jmp    80482b <insert_sorted_with_merge_freeList+0x57a>
  804823:	8b 45 08             	mov    0x8(%ebp),%eax
  804826:	a3 38 61 80 00       	mov    %eax,0x806138
  80482b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80482e:	8b 55 08             	mov    0x8(%ebp),%edx
  804831:	89 50 04             	mov    %edx,0x4(%eax)
  804834:	a1 44 61 80 00       	mov    0x806144,%eax
  804839:	40                   	inc    %eax
  80483a:	a3 44 61 80 00       	mov    %eax,0x806144
					blockToInsert->size += nextBlock->size;
  80483f:	8b 45 08             	mov    0x8(%ebp),%eax
  804842:	8b 50 0c             	mov    0xc(%eax),%edx
  804845:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804848:	8b 40 0c             	mov    0xc(%eax),%eax
  80484b:	01 c2                	add    %eax,%edx
  80484d:	8b 45 08             	mov    0x8(%ebp),%eax
  804850:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  804853:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804857:	75 17                	jne    804870 <insert_sorted_with_merge_freeList+0x5bf>
  804859:	83 ec 04             	sub    $0x4,%esp
  80485c:	68 e8 56 80 00       	push   $0x8056e8
  804861:	68 6b 01 00 00       	push   $0x16b
  804866:	68 3f 56 80 00       	push   $0x80563f
  80486b:	e8 ba d0 ff ff       	call   80192a <_panic>
  804870:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804873:	8b 00                	mov    (%eax),%eax
  804875:	85 c0                	test   %eax,%eax
  804877:	74 10                	je     804889 <insert_sorted_with_merge_freeList+0x5d8>
  804879:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80487c:	8b 00                	mov    (%eax),%eax
  80487e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804881:	8b 52 04             	mov    0x4(%edx),%edx
  804884:	89 50 04             	mov    %edx,0x4(%eax)
  804887:	eb 0b                	jmp    804894 <insert_sorted_with_merge_freeList+0x5e3>
  804889:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80488c:	8b 40 04             	mov    0x4(%eax),%eax
  80488f:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804894:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804897:	8b 40 04             	mov    0x4(%eax),%eax
  80489a:	85 c0                	test   %eax,%eax
  80489c:	74 0f                	je     8048ad <insert_sorted_with_merge_freeList+0x5fc>
  80489e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048a1:	8b 40 04             	mov    0x4(%eax),%eax
  8048a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8048a7:	8b 12                	mov    (%edx),%edx
  8048a9:	89 10                	mov    %edx,(%eax)
  8048ab:	eb 0a                	jmp    8048b7 <insert_sorted_with_merge_freeList+0x606>
  8048ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048b0:	8b 00                	mov    (%eax),%eax
  8048b2:	a3 38 61 80 00       	mov    %eax,0x806138
  8048b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8048c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8048ca:	a1 44 61 80 00       	mov    0x806144,%eax
  8048cf:	48                   	dec    %eax
  8048d0:	a3 44 61 80 00       	mov    %eax,0x806144
					nextBlock->sva = 0;
  8048d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8048df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048e2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8048e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8048ed:	75 17                	jne    804906 <insert_sorted_with_merge_freeList+0x655>
  8048ef:	83 ec 04             	sub    $0x4,%esp
  8048f2:	68 1c 56 80 00       	push   $0x80561c
  8048f7:	68 6e 01 00 00       	push   $0x16e
  8048fc:	68 3f 56 80 00       	push   $0x80563f
  804901:	e8 24 d0 ff ff       	call   80192a <_panic>
  804906:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80490c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80490f:	89 10                	mov    %edx,(%eax)
  804911:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804914:	8b 00                	mov    (%eax),%eax
  804916:	85 c0                	test   %eax,%eax
  804918:	74 0d                	je     804927 <insert_sorted_with_merge_freeList+0x676>
  80491a:	a1 48 61 80 00       	mov    0x806148,%eax
  80491f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804922:	89 50 04             	mov    %edx,0x4(%eax)
  804925:	eb 08                	jmp    80492f <insert_sorted_with_merge_freeList+0x67e>
  804927:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80492a:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80492f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804932:	a3 48 61 80 00       	mov    %eax,0x806148
  804937:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80493a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804941:	a1 54 61 80 00       	mov    0x806154,%eax
  804946:	40                   	inc    %eax
  804947:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  80494c:	e9 a9 00 00 00       	jmp    8049fa <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  804951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804955:	74 06                	je     80495d <insert_sorted_with_merge_freeList+0x6ac>
  804957:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80495b:	75 17                	jne    804974 <insert_sorted_with_merge_freeList+0x6c3>
  80495d:	83 ec 04             	sub    $0x4,%esp
  804960:	68 b4 56 80 00       	push   $0x8056b4
  804965:	68 73 01 00 00       	push   $0x173
  80496a:	68 3f 56 80 00       	push   $0x80563f
  80496f:	e8 b6 cf ff ff       	call   80192a <_panic>
  804974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804977:	8b 10                	mov    (%eax),%edx
  804979:	8b 45 08             	mov    0x8(%ebp),%eax
  80497c:	89 10                	mov    %edx,(%eax)
  80497e:	8b 45 08             	mov    0x8(%ebp),%eax
  804981:	8b 00                	mov    (%eax),%eax
  804983:	85 c0                	test   %eax,%eax
  804985:	74 0b                	je     804992 <insert_sorted_with_merge_freeList+0x6e1>
  804987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80498a:	8b 00                	mov    (%eax),%eax
  80498c:	8b 55 08             	mov    0x8(%ebp),%edx
  80498f:	89 50 04             	mov    %edx,0x4(%eax)
  804992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804995:	8b 55 08             	mov    0x8(%ebp),%edx
  804998:	89 10                	mov    %edx,(%eax)
  80499a:	8b 45 08             	mov    0x8(%ebp),%eax
  80499d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8049a0:	89 50 04             	mov    %edx,0x4(%eax)
  8049a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8049a6:	8b 00                	mov    (%eax),%eax
  8049a8:	85 c0                	test   %eax,%eax
  8049aa:	75 08                	jne    8049b4 <insert_sorted_with_merge_freeList+0x703>
  8049ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8049af:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8049b4:	a1 44 61 80 00       	mov    0x806144,%eax
  8049b9:	40                   	inc    %eax
  8049ba:	a3 44 61 80 00       	mov    %eax,0x806144
					break;
  8049bf:	eb 39                	jmp    8049fa <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8049c1:	a1 40 61 80 00       	mov    0x806140,%eax
  8049c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8049c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8049cd:	74 07                	je     8049d6 <insert_sorted_with_merge_freeList+0x725>
  8049cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8049d2:	8b 00                	mov    (%eax),%eax
  8049d4:	eb 05                	jmp    8049db <insert_sorted_with_merge_freeList+0x72a>
  8049d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8049db:	a3 40 61 80 00       	mov    %eax,0x806140
  8049e0:	a1 40 61 80 00       	mov    0x806140,%eax
  8049e5:	85 c0                	test   %eax,%eax
  8049e7:	0f 85 c7 fb ff ff    	jne    8045b4 <insert_sorted_with_merge_freeList+0x303>
  8049ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8049f1:	0f 85 bd fb ff ff    	jne    8045b4 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8049f7:	eb 01                	jmp    8049fa <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8049f9:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8049fa:	90                   	nop
  8049fb:	c9                   	leave  
  8049fc:	c3                   	ret    
  8049fd:	66 90                	xchg   %ax,%ax
  8049ff:	90                   	nop

00804a00 <__udivdi3>:
  804a00:	55                   	push   %ebp
  804a01:	57                   	push   %edi
  804a02:	56                   	push   %esi
  804a03:	53                   	push   %ebx
  804a04:	83 ec 1c             	sub    $0x1c,%esp
  804a07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804a0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804a0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804a13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804a17:	89 ca                	mov    %ecx,%edx
  804a19:	89 f8                	mov    %edi,%eax
  804a1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804a1f:	85 f6                	test   %esi,%esi
  804a21:	75 2d                	jne    804a50 <__udivdi3+0x50>
  804a23:	39 cf                	cmp    %ecx,%edi
  804a25:	77 65                	ja     804a8c <__udivdi3+0x8c>
  804a27:	89 fd                	mov    %edi,%ebp
  804a29:	85 ff                	test   %edi,%edi
  804a2b:	75 0b                	jne    804a38 <__udivdi3+0x38>
  804a2d:	b8 01 00 00 00       	mov    $0x1,%eax
  804a32:	31 d2                	xor    %edx,%edx
  804a34:	f7 f7                	div    %edi
  804a36:	89 c5                	mov    %eax,%ebp
  804a38:	31 d2                	xor    %edx,%edx
  804a3a:	89 c8                	mov    %ecx,%eax
  804a3c:	f7 f5                	div    %ebp
  804a3e:	89 c1                	mov    %eax,%ecx
  804a40:	89 d8                	mov    %ebx,%eax
  804a42:	f7 f5                	div    %ebp
  804a44:	89 cf                	mov    %ecx,%edi
  804a46:	89 fa                	mov    %edi,%edx
  804a48:	83 c4 1c             	add    $0x1c,%esp
  804a4b:	5b                   	pop    %ebx
  804a4c:	5e                   	pop    %esi
  804a4d:	5f                   	pop    %edi
  804a4e:	5d                   	pop    %ebp
  804a4f:	c3                   	ret    
  804a50:	39 ce                	cmp    %ecx,%esi
  804a52:	77 28                	ja     804a7c <__udivdi3+0x7c>
  804a54:	0f bd fe             	bsr    %esi,%edi
  804a57:	83 f7 1f             	xor    $0x1f,%edi
  804a5a:	75 40                	jne    804a9c <__udivdi3+0x9c>
  804a5c:	39 ce                	cmp    %ecx,%esi
  804a5e:	72 0a                	jb     804a6a <__udivdi3+0x6a>
  804a60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804a64:	0f 87 9e 00 00 00    	ja     804b08 <__udivdi3+0x108>
  804a6a:	b8 01 00 00 00       	mov    $0x1,%eax
  804a6f:	89 fa                	mov    %edi,%edx
  804a71:	83 c4 1c             	add    $0x1c,%esp
  804a74:	5b                   	pop    %ebx
  804a75:	5e                   	pop    %esi
  804a76:	5f                   	pop    %edi
  804a77:	5d                   	pop    %ebp
  804a78:	c3                   	ret    
  804a79:	8d 76 00             	lea    0x0(%esi),%esi
  804a7c:	31 ff                	xor    %edi,%edi
  804a7e:	31 c0                	xor    %eax,%eax
  804a80:	89 fa                	mov    %edi,%edx
  804a82:	83 c4 1c             	add    $0x1c,%esp
  804a85:	5b                   	pop    %ebx
  804a86:	5e                   	pop    %esi
  804a87:	5f                   	pop    %edi
  804a88:	5d                   	pop    %ebp
  804a89:	c3                   	ret    
  804a8a:	66 90                	xchg   %ax,%ax
  804a8c:	89 d8                	mov    %ebx,%eax
  804a8e:	f7 f7                	div    %edi
  804a90:	31 ff                	xor    %edi,%edi
  804a92:	89 fa                	mov    %edi,%edx
  804a94:	83 c4 1c             	add    $0x1c,%esp
  804a97:	5b                   	pop    %ebx
  804a98:	5e                   	pop    %esi
  804a99:	5f                   	pop    %edi
  804a9a:	5d                   	pop    %ebp
  804a9b:	c3                   	ret    
  804a9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804aa1:	89 eb                	mov    %ebp,%ebx
  804aa3:	29 fb                	sub    %edi,%ebx
  804aa5:	89 f9                	mov    %edi,%ecx
  804aa7:	d3 e6                	shl    %cl,%esi
  804aa9:	89 c5                	mov    %eax,%ebp
  804aab:	88 d9                	mov    %bl,%cl
  804aad:	d3 ed                	shr    %cl,%ebp
  804aaf:	89 e9                	mov    %ebp,%ecx
  804ab1:	09 f1                	or     %esi,%ecx
  804ab3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804ab7:	89 f9                	mov    %edi,%ecx
  804ab9:	d3 e0                	shl    %cl,%eax
  804abb:	89 c5                	mov    %eax,%ebp
  804abd:	89 d6                	mov    %edx,%esi
  804abf:	88 d9                	mov    %bl,%cl
  804ac1:	d3 ee                	shr    %cl,%esi
  804ac3:	89 f9                	mov    %edi,%ecx
  804ac5:	d3 e2                	shl    %cl,%edx
  804ac7:	8b 44 24 08          	mov    0x8(%esp),%eax
  804acb:	88 d9                	mov    %bl,%cl
  804acd:	d3 e8                	shr    %cl,%eax
  804acf:	09 c2                	or     %eax,%edx
  804ad1:	89 d0                	mov    %edx,%eax
  804ad3:	89 f2                	mov    %esi,%edx
  804ad5:	f7 74 24 0c          	divl   0xc(%esp)
  804ad9:	89 d6                	mov    %edx,%esi
  804adb:	89 c3                	mov    %eax,%ebx
  804add:	f7 e5                	mul    %ebp
  804adf:	39 d6                	cmp    %edx,%esi
  804ae1:	72 19                	jb     804afc <__udivdi3+0xfc>
  804ae3:	74 0b                	je     804af0 <__udivdi3+0xf0>
  804ae5:	89 d8                	mov    %ebx,%eax
  804ae7:	31 ff                	xor    %edi,%edi
  804ae9:	e9 58 ff ff ff       	jmp    804a46 <__udivdi3+0x46>
  804aee:	66 90                	xchg   %ax,%ax
  804af0:	8b 54 24 08          	mov    0x8(%esp),%edx
  804af4:	89 f9                	mov    %edi,%ecx
  804af6:	d3 e2                	shl    %cl,%edx
  804af8:	39 c2                	cmp    %eax,%edx
  804afa:	73 e9                	jae    804ae5 <__udivdi3+0xe5>
  804afc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804aff:	31 ff                	xor    %edi,%edi
  804b01:	e9 40 ff ff ff       	jmp    804a46 <__udivdi3+0x46>
  804b06:	66 90                	xchg   %ax,%ax
  804b08:	31 c0                	xor    %eax,%eax
  804b0a:	e9 37 ff ff ff       	jmp    804a46 <__udivdi3+0x46>
  804b0f:	90                   	nop

00804b10 <__umoddi3>:
  804b10:	55                   	push   %ebp
  804b11:	57                   	push   %edi
  804b12:	56                   	push   %esi
  804b13:	53                   	push   %ebx
  804b14:	83 ec 1c             	sub    $0x1c,%esp
  804b17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804b1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  804b1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804b23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804b27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804b2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804b2f:	89 f3                	mov    %esi,%ebx
  804b31:	89 fa                	mov    %edi,%edx
  804b33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804b37:	89 34 24             	mov    %esi,(%esp)
  804b3a:	85 c0                	test   %eax,%eax
  804b3c:	75 1a                	jne    804b58 <__umoddi3+0x48>
  804b3e:	39 f7                	cmp    %esi,%edi
  804b40:	0f 86 a2 00 00 00    	jbe    804be8 <__umoddi3+0xd8>
  804b46:	89 c8                	mov    %ecx,%eax
  804b48:	89 f2                	mov    %esi,%edx
  804b4a:	f7 f7                	div    %edi
  804b4c:	89 d0                	mov    %edx,%eax
  804b4e:	31 d2                	xor    %edx,%edx
  804b50:	83 c4 1c             	add    $0x1c,%esp
  804b53:	5b                   	pop    %ebx
  804b54:	5e                   	pop    %esi
  804b55:	5f                   	pop    %edi
  804b56:	5d                   	pop    %ebp
  804b57:	c3                   	ret    
  804b58:	39 f0                	cmp    %esi,%eax
  804b5a:	0f 87 ac 00 00 00    	ja     804c0c <__umoddi3+0xfc>
  804b60:	0f bd e8             	bsr    %eax,%ebp
  804b63:	83 f5 1f             	xor    $0x1f,%ebp
  804b66:	0f 84 ac 00 00 00    	je     804c18 <__umoddi3+0x108>
  804b6c:	bf 20 00 00 00       	mov    $0x20,%edi
  804b71:	29 ef                	sub    %ebp,%edi
  804b73:	89 fe                	mov    %edi,%esi
  804b75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804b79:	89 e9                	mov    %ebp,%ecx
  804b7b:	d3 e0                	shl    %cl,%eax
  804b7d:	89 d7                	mov    %edx,%edi
  804b7f:	89 f1                	mov    %esi,%ecx
  804b81:	d3 ef                	shr    %cl,%edi
  804b83:	09 c7                	or     %eax,%edi
  804b85:	89 e9                	mov    %ebp,%ecx
  804b87:	d3 e2                	shl    %cl,%edx
  804b89:	89 14 24             	mov    %edx,(%esp)
  804b8c:	89 d8                	mov    %ebx,%eax
  804b8e:	d3 e0                	shl    %cl,%eax
  804b90:	89 c2                	mov    %eax,%edx
  804b92:	8b 44 24 08          	mov    0x8(%esp),%eax
  804b96:	d3 e0                	shl    %cl,%eax
  804b98:	89 44 24 04          	mov    %eax,0x4(%esp)
  804b9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804ba0:	89 f1                	mov    %esi,%ecx
  804ba2:	d3 e8                	shr    %cl,%eax
  804ba4:	09 d0                	or     %edx,%eax
  804ba6:	d3 eb                	shr    %cl,%ebx
  804ba8:	89 da                	mov    %ebx,%edx
  804baa:	f7 f7                	div    %edi
  804bac:	89 d3                	mov    %edx,%ebx
  804bae:	f7 24 24             	mull   (%esp)
  804bb1:	89 c6                	mov    %eax,%esi
  804bb3:	89 d1                	mov    %edx,%ecx
  804bb5:	39 d3                	cmp    %edx,%ebx
  804bb7:	0f 82 87 00 00 00    	jb     804c44 <__umoddi3+0x134>
  804bbd:	0f 84 91 00 00 00    	je     804c54 <__umoddi3+0x144>
  804bc3:	8b 54 24 04          	mov    0x4(%esp),%edx
  804bc7:	29 f2                	sub    %esi,%edx
  804bc9:	19 cb                	sbb    %ecx,%ebx
  804bcb:	89 d8                	mov    %ebx,%eax
  804bcd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804bd1:	d3 e0                	shl    %cl,%eax
  804bd3:	89 e9                	mov    %ebp,%ecx
  804bd5:	d3 ea                	shr    %cl,%edx
  804bd7:	09 d0                	or     %edx,%eax
  804bd9:	89 e9                	mov    %ebp,%ecx
  804bdb:	d3 eb                	shr    %cl,%ebx
  804bdd:	89 da                	mov    %ebx,%edx
  804bdf:	83 c4 1c             	add    $0x1c,%esp
  804be2:	5b                   	pop    %ebx
  804be3:	5e                   	pop    %esi
  804be4:	5f                   	pop    %edi
  804be5:	5d                   	pop    %ebp
  804be6:	c3                   	ret    
  804be7:	90                   	nop
  804be8:	89 fd                	mov    %edi,%ebp
  804bea:	85 ff                	test   %edi,%edi
  804bec:	75 0b                	jne    804bf9 <__umoddi3+0xe9>
  804bee:	b8 01 00 00 00       	mov    $0x1,%eax
  804bf3:	31 d2                	xor    %edx,%edx
  804bf5:	f7 f7                	div    %edi
  804bf7:	89 c5                	mov    %eax,%ebp
  804bf9:	89 f0                	mov    %esi,%eax
  804bfb:	31 d2                	xor    %edx,%edx
  804bfd:	f7 f5                	div    %ebp
  804bff:	89 c8                	mov    %ecx,%eax
  804c01:	f7 f5                	div    %ebp
  804c03:	89 d0                	mov    %edx,%eax
  804c05:	e9 44 ff ff ff       	jmp    804b4e <__umoddi3+0x3e>
  804c0a:	66 90                	xchg   %ax,%ax
  804c0c:	89 c8                	mov    %ecx,%eax
  804c0e:	89 f2                	mov    %esi,%edx
  804c10:	83 c4 1c             	add    $0x1c,%esp
  804c13:	5b                   	pop    %ebx
  804c14:	5e                   	pop    %esi
  804c15:	5f                   	pop    %edi
  804c16:	5d                   	pop    %ebp
  804c17:	c3                   	ret    
  804c18:	3b 04 24             	cmp    (%esp),%eax
  804c1b:	72 06                	jb     804c23 <__umoddi3+0x113>
  804c1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804c21:	77 0f                	ja     804c32 <__umoddi3+0x122>
  804c23:	89 f2                	mov    %esi,%edx
  804c25:	29 f9                	sub    %edi,%ecx
  804c27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804c2b:	89 14 24             	mov    %edx,(%esp)
  804c2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804c32:	8b 44 24 04          	mov    0x4(%esp),%eax
  804c36:	8b 14 24             	mov    (%esp),%edx
  804c39:	83 c4 1c             	add    $0x1c,%esp
  804c3c:	5b                   	pop    %ebx
  804c3d:	5e                   	pop    %esi
  804c3e:	5f                   	pop    %edi
  804c3f:	5d                   	pop    %ebp
  804c40:	c3                   	ret    
  804c41:	8d 76 00             	lea    0x0(%esi),%esi
  804c44:	2b 04 24             	sub    (%esp),%eax
  804c47:	19 fa                	sbb    %edi,%edx
  804c49:	89 d1                	mov    %edx,%ecx
  804c4b:	89 c6                	mov    %eax,%esi
  804c4d:	e9 71 ff ff ff       	jmp    804bc3 <__umoddi3+0xb3>
  804c52:	66 90                	xchg   %ax,%ax
  804c54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804c58:	72 ea                	jb     804c44 <__umoddi3+0x134>
  804c5a:	89 d9                	mov    %ebx,%ecx
  804c5c:	e9 62 ff ff ff       	jmp    804bc3 <__umoddi3+0xb3>
