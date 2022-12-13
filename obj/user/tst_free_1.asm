
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
  800091:	68 40 4c 80 00       	push   $0x804c40
  800096:	6a 1a                	push   $0x1a
  800098:	68 5c 4c 80 00       	push   $0x804c5c
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
  8000df:	e8 2f 2d 00 00       	call   802e13 <sys_calculate_free_frames>
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
  8000fb:	e8 b3 2d 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
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
  800137:	68 70 4c 80 00       	push   $0x804c70
  80013c:	6a 3a                	push   $0x3a
  80013e:	68 5c 4c 80 00       	push   $0x804c5c
  800143:	e8 e2 17 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 66 2d 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 d8 4c 80 00       	push   $0x804cd8
  80015a:	6a 3b                	push   $0x3b
  80015c:	68 5c 4c 80 00       	push   $0x804c5c
  800161:	e8 c4 17 00 00       	call   80192a <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 a8 2c 00 00       	call   802e13 <sys_calculate_free_frames>
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
  80019b:	e8 73 2c 00 00       	call   802e13 <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 08 4d 80 00       	push   $0x804d08
  8001b1:	6a 42                	push   $0x42
  8001b3:	68 5c 4c 80 00       	push   $0x804c5c
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
  80026e:	68 4c 4d 80 00       	push   $0x804d4c
  800273:	6a 4c                	push   $0x4c
  800275:	68 5c 4c 80 00       	push   $0x804c5c
  80027a:	e8 ab 16 00 00       	call   80192a <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 2f 2c 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
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
  8002d0:	68 70 4c 80 00       	push   $0x804c70
  8002d5:	6a 51                	push   $0x51
  8002d7:	68 5c 4c 80 00       	push   $0x804c5c
  8002dc:	e8 49 16 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 cd 2b 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 d8 4c 80 00       	push   $0x804cd8
  8002f3:	6a 52                	push   $0x52
  8002f5:	68 5c 4c 80 00       	push   $0x804c5c
  8002fa:	e8 2b 16 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 0f 2b 00 00       	call   802e13 <sys_calculate_free_frames>
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
  80033d:	e8 d1 2a 00 00       	call   802e13 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 08 4d 80 00       	push   $0x804d08
  800353:	6a 59                	push   $0x59
  800355:	68 5c 4c 80 00       	push   $0x804c5c
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
  800414:	68 4c 4d 80 00       	push   $0x804d4c
  800419:	6a 62                	push   $0x62
  80041b:	68 5c 4c 80 00       	push   $0x804c5c
  800420:	e8 05 15 00 00       	call   80192a <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 89 2a 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
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
  800475:	68 70 4c 80 00       	push   $0x804c70
  80047a:	6a 67                	push   $0x67
  80047c:	68 5c 4c 80 00       	push   $0x804c5c
  800481:	e8 a4 14 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800486:	e8 28 2a 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  80048b:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80048e:	74 14                	je     8004a4 <_main+0x46c>
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 d8 4c 80 00       	push   $0x804cd8
  800498:	6a 68                	push   $0x68
  80049a:	68 5c 4c 80 00       	push   $0x804c5c
  80049f:	e8 86 14 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a4:	e8 6a 29 00 00       	call   802e13 <sys_calculate_free_frames>
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
  8004e0:	e8 2e 29 00 00       	call   802e13 <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	83 f8 02             	cmp    $0x2,%eax
  8004ec:	74 14                	je     800502 <_main+0x4ca>
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	68 08 4d 80 00       	push   $0x804d08
  8004f6:	6a 6f                	push   $0x6f
  8004f8:	68 5c 4c 80 00       	push   $0x804c5c
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
  8005c6:	68 4c 4d 80 00       	push   $0x804d4c
  8005cb:	6a 78                	push   $0x78
  8005cd:	68 5c 4c 80 00       	push   $0x804c5c
  8005d2:	e8 53 13 00 00       	call   80192a <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d7:	e8 37 28 00 00       	call   802e13 <sys_calculate_free_frames>
  8005dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005df:	e8 cf 28 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
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
  800643:	68 70 4c 80 00       	push   $0x804c70
  800648:	6a 7e                	push   $0x7e
  80064a:	68 5c 4c 80 00       	push   $0x804c5c
  80064f:	e8 d6 12 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800654:	e8 5a 28 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  800659:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80065c:	74 14                	je     800672 <_main+0x63a>
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	68 d8 4c 80 00       	push   $0x804cd8
  800666:	6a 7f                	push   $0x7f
  800668:	68 5c 4c 80 00       	push   $0x804c5c
  80066d:	e8 b8 12 00 00       	call   80192a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800672:	e8 3c 28 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
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
  8006de:	68 70 4c 80 00       	push   $0x804c70
  8006e3:	68 85 00 00 00       	push   $0x85
  8006e8:	68 5c 4c 80 00       	push   $0x804c5c
  8006ed:	e8 38 12 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f2:	e8 bc 27 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  8006f7:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8006fa:	74 17                	je     800713 <_main+0x6db>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 d8 4c 80 00       	push   $0x804cd8
  800704:	68 86 00 00 00       	push   $0x86
  800709:	68 5c 4c 80 00       	push   $0x804c5c
  80070e:	e8 17 12 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800713:	e8 fb 26 00 00       	call   802e13 <sys_calculate_free_frames>
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
  8007b7:	e8 57 26 00 00       	call   802e13 <sys_calculate_free_frames>
  8007bc:	29 c3                	sub    %eax,%ebx
  8007be:	89 d8                	mov    %ebx,%eax
  8007c0:	83 f8 02             	cmp    $0x2,%eax
  8007c3:	74 17                	je     8007dc <_main+0x7a4>
  8007c5:	83 ec 04             	sub    $0x4,%esp
  8007c8:	68 08 4d 80 00       	push   $0x804d08
  8007cd:	68 8d 00 00 00       	push   $0x8d
  8007d2:	68 5c 4c 80 00       	push   $0x804c5c
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
  8008b5:	68 4c 4d 80 00       	push   $0x804d4c
  8008ba:	68 96 00 00 00       	push   $0x96
  8008bf:	68 5c 4c 80 00       	push   $0x804c5c
  8008c4:	e8 61 10 00 00       	call   80192a <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 45 25 00 00       	call   802e13 <sys_calculate_free_frames>
  8008ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d1:	e8 dd 25 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
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
  80093c:	68 70 4c 80 00       	push   $0x804c70
  800941:	68 9c 00 00 00       	push   $0x9c
  800946:	68 5c 4c 80 00       	push   $0x804c5c
  80094b:	e8 da 0f 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800950:	e8 5e 25 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  800955:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800958:	74 17                	je     800971 <_main+0x939>
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 d8 4c 80 00       	push   $0x804cd8
  800962:	68 9d 00 00 00       	push   $0x9d
  800967:	68 5c 4c 80 00       	push   $0x804c5c
  80096c:	e8 b9 0f 00 00       	call   80192a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800971:	e8 3d 25 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
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
  8009ec:	68 70 4c 80 00       	push   $0x804c70
  8009f1:	68 a3 00 00 00       	push   $0xa3
  8009f6:	68 5c 4c 80 00       	push   $0x804c5c
  8009fb:	e8 2a 0f 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a00:	e8 ae 24 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  800a05:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800a08:	74 17                	je     800a21 <_main+0x9e9>
  800a0a:	83 ec 04             	sub    $0x4,%esp
  800a0d:	68 d8 4c 80 00       	push   $0x804cd8
  800a12:	68 a4 00 00 00       	push   $0xa4
  800a17:	68 5c 4c 80 00       	push   $0x804c5c
  800a1c:	e8 09 0f 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a21:	e8 ed 23 00 00       	call   802e13 <sys_calculate_free_frames>
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
  800a92:	e8 7c 23 00 00       	call   802e13 <sys_calculate_free_frames>
  800a97:	29 c3                	sub    %eax,%ebx
  800a99:	89 d8                	mov    %ebx,%eax
  800a9b:	83 f8 05             	cmp    $0x5,%eax
  800a9e:	74 17                	je     800ab7 <_main+0xa7f>
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 08 4d 80 00       	push   $0x804d08
  800aa8:	68 ac 00 00 00       	push   $0xac
  800aad:	68 5c 4c 80 00       	push   $0x804c5c
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
  800be8:	68 4c 4d 80 00       	push   $0x804d4c
  800bed:	68 b7 00 00 00       	push   $0xb7
  800bf2:	68 5c 4c 80 00       	push   $0x804c5c
  800bf7:	e8 2e 0d 00 00       	call   80192a <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfc:	e8 b2 22 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
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
  800c7a:	68 70 4c 80 00       	push   $0x804c70
  800c7f:	68 bc 00 00 00       	push   $0xbc
  800c84:	68 5c 4c 80 00       	push   $0x804c5c
  800c89:	e8 9c 0c 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c8e:	e8 20 22 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  800c93:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800c96:	74 17                	je     800caf <_main+0xc77>
  800c98:	83 ec 04             	sub    $0x4,%esp
  800c9b:	68 d8 4c 80 00       	push   $0x804cd8
  800ca0:	68 bd 00 00 00       	push   $0xbd
  800ca5:	68 5c 4c 80 00       	push   $0x804c5c
  800caa:	e8 7b 0c 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800caf:	e8 5f 21 00 00       	call   802e13 <sys_calculate_free_frames>
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
  800d03:	e8 0b 21 00 00       	call   802e13 <sys_calculate_free_frames>
  800d08:	29 c3                	sub    %eax,%ebx
  800d0a:	89 d8                	mov    %ebx,%eax
  800d0c:	83 f8 02             	cmp    $0x2,%eax
  800d0f:	74 17                	je     800d28 <_main+0xcf0>
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	68 08 4d 80 00       	push   $0x804d08
  800d19:	68 c4 00 00 00       	push   $0xc4
  800d1e:	68 5c 4c 80 00       	push   $0x804c5c
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
  800dfe:	68 4c 4d 80 00       	push   $0x804d4c
  800e03:	68 cd 00 00 00       	push   $0xcd
  800e08:	68 5c 4c 80 00       	push   $0x804c5c
  800e0d:	e8 18 0b 00 00       	call   80192a <_panic>
	}

	{
		//Free 1st 2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800e12:	e8 fc 1f 00 00       	call   802e13 <sys_calculate_free_frames>
  800e17:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e1d:	e8 91 20 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  800e22:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[0]);
  800e28:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	e8 5d 1d 00 00       	call   802b94 <free>
  800e37:	83 c4 10             	add    $0x10,%esp

		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e3a:	e8 74 20 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  800e3f:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800e45:	74 17                	je     800e5e <_main+0xe26>
  800e47:	83 ec 04             	sub    $0x4,%esp
  800e4a:	68 6c 4d 80 00       	push   $0x804d6c
  800e4f:	68 d6 00 00 00       	push   $0xd6
  800e54:	68 5c 4c 80 00       	push   $0x804c5c
  800e59:	e8 cc 0a 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800e5e:	e8 b0 1f 00 00       	call   802e13 <sys_calculate_free_frames>
  800e63:	89 c2                	mov    %eax,%edx
  800e65:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800e6b:	29 c2                	sub    %eax,%edx
  800e6d:	89 d0                	mov    %edx,%eax
  800e6f:	83 f8 02             	cmp    $0x2,%eax
  800e72:	74 17                	je     800e8b <_main+0xe53>
  800e74:	83 ec 04             	sub    $0x4,%esp
  800e77:	68 a8 4d 80 00       	push   $0x804da8
  800e7c:	68 d7 00 00 00       	push   $0xd7
  800e81:	68 5c 4c 80 00       	push   $0x804c5c
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
  800ee0:	68 f4 4d 80 00       	push   $0x804df4
  800ee5:	68 dc 00 00 00       	push   $0xdc
  800eea:	68 5c 4c 80 00       	push   $0x804c5c
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
  800f42:	68 f4 4d 80 00       	push   $0x804df4
  800f47:	68 de 00 00 00       	push   $0xde
  800f4c:	68 5c 4c 80 00       	push   $0x804c5c
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
  800f6c:	e8 a2 1e 00 00       	call   802e13 <sys_calculate_free_frames>
  800f71:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f77:	e8 37 1f 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  800f7c:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[1]);
  800f82:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800f88:	83 ec 0c             	sub    $0xc,%esp
  800f8b:	50                   	push   %eax
  800f8c:	e8 03 1c 00 00       	call   802b94 <free>
  800f91:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f94:	e8 1a 1f 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  800f99:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800f9f:	74 17                	je     800fb8 <_main+0xf80>
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	68 6c 4d 80 00       	push   $0x804d6c
  800fa9:	68 e6 00 00 00       	push   $0xe6
  800fae:	68 5c 4c 80 00       	push   $0x804c5c
  800fb3:	e8 72 09 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fb8:	e8 56 1e 00 00       	call   802e13 <sys_calculate_free_frames>
  800fbd:	89 c2                	mov    %eax,%edx
  800fbf:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800fc5:	29 c2                	sub    %eax,%edx
  800fc7:	89 d0                	mov    %edx,%eax
  800fc9:	83 f8 03             	cmp    $0x3,%eax
  800fcc:	74 17                	je     800fe5 <_main+0xfad>
  800fce:	83 ec 04             	sub    $0x4,%esp
  800fd1:	68 a8 4d 80 00       	push   $0x804da8
  800fd6:	68 e7 00 00 00       	push   $0xe7
  800fdb:	68 5c 4c 80 00       	push   $0x804c5c
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
  80103a:	68 f4 4d 80 00       	push   $0x804df4
  80103f:	68 eb 00 00 00       	push   $0xeb
  801044:	68 5c 4c 80 00       	push   $0x804c5c
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
  8010a0:	68 f4 4d 80 00       	push   $0x804df4
  8010a5:	68 ed 00 00 00       	push   $0xed
  8010aa:	68 5c 4c 80 00       	push   $0x804c5c
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
  8010ca:	e8 44 1d 00 00       	call   802e13 <sys_calculate_free_frames>
  8010cf:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8010d5:	e8 d9 1d 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  8010da:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[6]);
  8010e0:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	50                   	push   %eax
  8010ea:	e8 a5 1a 00 00       	call   802b94 <free>
  8010ef:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8010f2:	e8 bc 1d 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  8010f7:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8010fd:	74 17                	je     801116 <_main+0x10de>
  8010ff:	83 ec 04             	sub    $0x4,%esp
  801102:	68 6c 4d 80 00       	push   $0x804d6c
  801107:	68 f4 00 00 00       	push   $0xf4
  80110c:	68 5c 4c 80 00       	push   $0x804c5c
  801111:	e8 14 08 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801116:	e8 f8 1c 00 00       	call   802e13 <sys_calculate_free_frames>
  80111b:	89 c2                	mov    %eax,%edx
  80111d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801123:	29 c2                	sub    %eax,%edx
  801125:	89 d0                	mov    %edx,%eax
  801127:	83 f8 04             	cmp    $0x4,%eax
  80112a:	74 17                	je     801143 <_main+0x110b>
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	68 a8 4d 80 00       	push   $0x804da8
  801134:	68 f5 00 00 00       	push   $0xf5
  801139:	68 5c 4c 80 00       	push   $0x804c5c
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
  80119b:	68 f4 4d 80 00       	push   $0x804df4
  8011a0:	68 f9 00 00 00       	push   $0xf9
  8011a5:	68 5c 4c 80 00       	push   $0x804c5c
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
  80120e:	68 f4 4d 80 00       	push   $0x804df4
  801213:	68 fb 00 00 00       	push   $0xfb
  801218:	68 5c 4c 80 00       	push   $0x804c5c
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
  801276:	68 f4 4d 80 00       	push   $0x804df4
  80127b:	68 fd 00 00 00       	push   $0xfd
  801280:	68 5c 4c 80 00       	push   $0x804c5c
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
  8012a0:	e8 6e 1b 00 00       	call   802e13 <sys_calculate_free_frames>
  8012a5:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012ab:	e8 03 1c 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  8012b0:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[4]);
  8012b6:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8012bc:	83 ec 0c             	sub    $0xc,%esp
  8012bf:	50                   	push   %eax
  8012c0:	e8 cf 18 00 00       	call   802b94 <free>
  8012c5:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8012c8:	e8 e6 1b 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  8012cd:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8012d3:	74 17                	je     8012ec <_main+0x12b4>
  8012d5:	83 ec 04             	sub    $0x4,%esp
  8012d8:	68 6c 4d 80 00       	push   $0x804d6c
  8012dd:	68 04 01 00 00       	push   $0x104
  8012e2:	68 5c 4c 80 00       	push   $0x804c5c
  8012e7:	e8 3e 06 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8012ec:	e8 22 1b 00 00       	call   802e13 <sys_calculate_free_frames>
  8012f1:	89 c2                	mov    %eax,%edx
  8012f3:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8012f9:	29 c2                	sub    %eax,%edx
  8012fb:	89 d0                	mov    %edx,%eax
  8012fd:	83 f8 02             	cmp    $0x2,%eax
  801300:	74 17                	je     801319 <_main+0x12e1>
  801302:	83 ec 04             	sub    $0x4,%esp
  801305:	68 a8 4d 80 00       	push   $0x804da8
  80130a:	68 05 01 00 00       	push   $0x105
  80130f:	68 5c 4c 80 00       	push   $0x804c5c
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
  801371:	68 f4 4d 80 00       	push   $0x804df4
  801376:	68 09 01 00 00       	push   $0x109
  80137b:	68 5c 4c 80 00       	push   $0x804c5c
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
  8013e0:	68 f4 4d 80 00       	push   $0x804df4
  8013e5:	68 0b 01 00 00       	push   $0x10b
  8013ea:	68 5c 4c 80 00       	push   $0x804c5c
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
  80140a:	e8 04 1a 00 00       	call   802e13 <sys_calculate_free_frames>
  80140f:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801415:	e8 99 1a 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  80141a:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[5]);
  801420:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  801426:	83 ec 0c             	sub    $0xc,%esp
  801429:	50                   	push   %eax
  80142a:	e8 65 17 00 00       	call   802b94 <free>
  80142f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801432:	e8 7c 1a 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  801437:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  80143d:	74 17                	je     801456 <_main+0x141e>
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	68 6c 4d 80 00       	push   $0x804d6c
  801447:	68 12 01 00 00       	push   $0x112
  80144c:	68 5c 4c 80 00       	push   $0x804c5c
  801451:	e8 d4 04 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801456:	e8 b8 19 00 00       	call   802e13 <sys_calculate_free_frames>
  80145b:	89 c2                	mov    %eax,%edx
  80145d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801463:	39 c2                	cmp    %eax,%edx
  801465:	74 17                	je     80147e <_main+0x1446>
  801467:	83 ec 04             	sub    $0x4,%esp
  80146a:	68 a8 4d 80 00       	push   $0x804da8
  80146f:	68 13 01 00 00       	push   $0x113
  801474:	68 5c 4c 80 00       	push   $0x804c5c
  801479:	e8 ac 04 00 00       	call   80192a <_panic>

		//Free 1st 2 KB
		freeFrames = sys_calculate_free_frames() ;
  80147e:	e8 90 19 00 00       	call   802e13 <sys_calculate_free_frames>
  801483:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801489:	e8 25 1a 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  80148e:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[2]);
  801494:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80149a:	83 ec 0c             	sub    $0xc,%esp
  80149d:	50                   	push   %eax
  80149e:	e8 f1 16 00 00       	call   802b94 <free>
  8014a3:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8014a6:	e8 08 1a 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  8014ab:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8014b1:	74 17                	je     8014ca <_main+0x1492>
  8014b3:	83 ec 04             	sub    $0x4,%esp
  8014b6:	68 6c 4d 80 00       	push   $0x804d6c
  8014bb:	68 19 01 00 00       	push   $0x119
  8014c0:	68 5c 4c 80 00       	push   $0x804c5c
  8014c5:	e8 60 04 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8014ca:	e8 44 19 00 00       	call   802e13 <sys_calculate_free_frames>
  8014cf:	89 c2                	mov    %eax,%edx
  8014d1:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8014d7:	29 c2                	sub    %eax,%edx
  8014d9:	89 d0                	mov    %edx,%eax
  8014db:	83 f8 02             	cmp    $0x2,%eax
  8014de:	74 17                	je     8014f7 <_main+0x14bf>
  8014e0:	83 ec 04             	sub    $0x4,%esp
  8014e3:	68 a8 4d 80 00       	push   $0x804da8
  8014e8:	68 1a 01 00 00       	push   $0x11a
  8014ed:	68 5c 4c 80 00       	push   $0x804c5c
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
  80154c:	68 f4 4d 80 00       	push   $0x804df4
  801551:	68 1e 01 00 00       	push   $0x11e
  801556:	68 5c 4c 80 00       	push   $0x804c5c
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
  8015b5:	68 f4 4d 80 00       	push   $0x804df4
  8015ba:	68 20 01 00 00       	push   $0x120
  8015bf:	68 5c 4c 80 00       	push   $0x804c5c
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
  8015df:	e8 2f 18 00 00       	call   802e13 <sys_calculate_free_frames>
  8015e4:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8015ea:	e8 c4 18 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  8015ef:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[3]);
  8015f5:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  8015fb:	83 ec 0c             	sub    $0xc,%esp
  8015fe:	50                   	push   %eax
  8015ff:	e8 90 15 00 00       	call   802b94 <free>
  801604:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801607:	e8 a7 18 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  80160c:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801612:	74 17                	je     80162b <_main+0x15f3>
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	68 6c 4d 80 00       	push   $0x804d6c
  80161c:	68 27 01 00 00       	push   $0x127
  801621:	68 5c 4c 80 00       	push   $0x804c5c
  801626:	e8 ff 02 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80162b:	e8 e3 17 00 00       	call   802e13 <sys_calculate_free_frames>
  801630:	89 c2                	mov    %eax,%edx
  801632:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801638:	39 c2                	cmp    %eax,%edx
  80163a:	74 17                	je     801653 <_main+0x161b>
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 a8 4d 80 00       	push   $0x804da8
  801644:	68 28 01 00 00       	push   $0x128
  801649:	68 5c 4c 80 00       	push   $0x804c5c
  80164e:	e8 d7 02 00 00       	call   80192a <_panic>


		//Free last 14 KB
		freeFrames = sys_calculate_free_frames() ;
  801653:	e8 bb 17 00 00       	call   802e13 <sys_calculate_free_frames>
  801658:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80165e:	e8 50 18 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  801663:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[7]);
  801669:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80166f:	83 ec 0c             	sub    $0xc,%esp
  801672:	50                   	push   %eax
  801673:	e8 1c 15 00 00       	call   802b94 <free>
  801678:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80167b:	e8 33 18 00 00       	call   802eb3 <sys_pf_calculate_allocated_pages>
  801680:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801686:	74 17                	je     80169f <_main+0x1667>
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	68 6c 4d 80 00       	push   $0x804d6c
  801690:	68 2f 01 00 00       	push   $0x12f
  801695:	68 5c 4c 80 00       	push   $0x804c5c
  80169a:	e8 8b 02 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80169f:	e8 6f 17 00 00       	call   802e13 <sys_calculate_free_frames>
  8016a4:	89 c2                	mov    %eax,%edx
  8016a6:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8016ac:	29 c2                	sub    %eax,%edx
  8016ae:	89 d0                	mov    %edx,%eax
  8016b0:	83 f8 03             	cmp    $0x3,%eax
  8016b3:	74 17                	je     8016cc <_main+0x1694>
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 a8 4d 80 00       	push   $0x804da8
  8016bd:	68 30 01 00 00       	push   $0x130
  8016c2:	68 5c 4c 80 00       	push   $0x804c5c
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
  801721:	68 f4 4d 80 00       	push   $0x804df4
  801726:	68 34 01 00 00       	push   $0x134
  80172b:	68 5c 4c 80 00       	push   $0x804c5c
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
  801787:	68 f4 4d 80 00       	push   $0x804df4
  80178c:	68 36 01 00 00       	push   $0x136
  801791:	68 5c 4c 80 00       	push   $0x804c5c
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
  8017b1:	e8 5d 16 00 00       	call   802e13 <sys_calculate_free_frames>
  8017b6:	89 c2                	mov    %eax,%edx
  8017b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017bb:	39 c2                	cmp    %eax,%edx
  8017bd:	74 17                	je     8017d6 <_main+0x179e>
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 18 4e 80 00       	push   $0x804e18
  8017c7:	68 39 01 00 00       	push   $0x139
  8017cc:	68 5c 4c 80 00       	push   $0x804c5c
  8017d1:	e8 54 01 00 00       	call   80192a <_panic>
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	68 4c 4e 80 00       	push   $0x804e4c
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
  8017f4:	e8 fa 18 00 00       	call   8030f3 <sys_getenvindex>
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
  80185f:	e8 9c 16 00 00       	call   802f00 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801864:	83 ec 0c             	sub    $0xc,%esp
  801867:	68 a0 4e 80 00       	push   $0x804ea0
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
  80188f:	68 c8 4e 80 00       	push   $0x804ec8
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
  8018c0:	68 f0 4e 80 00       	push   $0x804ef0
  8018c5:	e8 14 03 00 00       	call   801bde <cprintf>
  8018ca:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8018cd:	a1 20 60 80 00       	mov    0x806020,%eax
  8018d2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8018d8:	83 ec 08             	sub    $0x8,%esp
  8018db:	50                   	push   %eax
  8018dc:	68 48 4f 80 00       	push   $0x804f48
  8018e1:	e8 f8 02 00 00       	call   801bde <cprintf>
  8018e6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8018e9:	83 ec 0c             	sub    $0xc,%esp
  8018ec:	68 a0 4e 80 00       	push   $0x804ea0
  8018f1:	e8 e8 02 00 00       	call   801bde <cprintf>
  8018f6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8018f9:	e8 1c 16 00 00       	call   802f1a <sys_enable_interrupt>

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
  801911:	e8 a9 17 00 00       	call   8030bf <sys_destroy_env>
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
  801922:	e8 fe 17 00 00       	call   803125 <sys_exit_env>
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
  80194b:	68 5c 4f 80 00       	push   $0x804f5c
  801950:	e8 89 02 00 00       	call   801bde <cprintf>
  801955:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801958:	a1 00 60 80 00       	mov    0x806000,%eax
  80195d:	ff 75 0c             	pushl  0xc(%ebp)
  801960:	ff 75 08             	pushl  0x8(%ebp)
  801963:	50                   	push   %eax
  801964:	68 61 4f 80 00       	push   $0x804f61
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
  801988:	68 7d 4f 80 00       	push   $0x804f7d
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
  8019b4:	68 80 4f 80 00       	push   $0x804f80
  8019b9:	6a 26                	push   $0x26
  8019bb:	68 cc 4f 80 00       	push   $0x804fcc
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
  801a86:	68 d8 4f 80 00       	push   $0x804fd8
  801a8b:	6a 3a                	push   $0x3a
  801a8d:	68 cc 4f 80 00       	push   $0x804fcc
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
  801af6:	68 2c 50 80 00       	push   $0x80502c
  801afb:	6a 44                	push   $0x44
  801afd:	68 cc 4f 80 00       	push   $0x804fcc
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
  801b50:	e8 fd 11 00 00       	call   802d52 <sys_cputs>
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
  801bc7:	e8 86 11 00 00       	call   802d52 <sys_cputs>
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
  801c11:	e8 ea 12 00 00       	call   802f00 <sys_disable_interrupt>
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
  801c31:	e8 e4 12 00 00       	call   802f1a <sys_enable_interrupt>
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
  801c7b:	e8 58 2d 00 00       	call   8049d8 <__udivdi3>
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
  801ccb:	e8 18 2e 00 00       	call   804ae8 <__umoddi3>
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	05 94 52 80 00       	add    $0x805294,%eax
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
  801e26:	8b 04 85 b8 52 80 00 	mov    0x8052b8(,%eax,4),%eax
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
  801f07:	8b 34 9d 00 51 80 00 	mov    0x805100(,%ebx,4),%esi
  801f0e:	85 f6                	test   %esi,%esi
  801f10:	75 19                	jne    801f2b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801f12:	53                   	push   %ebx
  801f13:	68 a5 52 80 00       	push   $0x8052a5
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
  801f2c:	68 ae 52 80 00       	push   $0x8052ae
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
  801f59:	be b1 52 80 00       	mov    $0x8052b1,%esi
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
  80297f:	68 10 54 80 00       	push   $0x805410
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
  802a4f:	e8 42 04 00 00       	call   802e96 <sys_allocate_chunk>
  802a54:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802a57:	a1 20 61 80 00       	mov    0x806120,%eax
  802a5c:	83 ec 0c             	sub    $0xc,%esp
  802a5f:	50                   	push   %eax
  802a60:	e8 b7 0a 00 00       	call   80351c <initialize_MemBlocksList>
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
  802a8d:	68 35 54 80 00       	push   $0x805435
  802a92:	6a 33                	push   $0x33
  802a94:	68 53 54 80 00       	push   $0x805453
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
  802b0c:	68 60 54 80 00       	push   $0x805460
  802b11:	6a 34                	push   $0x34
  802b13:	68 53 54 80 00       	push   $0x805453
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
  802b69:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802b6c:	e8 f7 fd ff ff       	call   802968 <InitializeUHeap>
	if (size == 0) return NULL ;
  802b71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b75:	75 07                	jne    802b7e <malloc+0x18>
  802b77:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7c:	eb 14                	jmp    802b92 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  802b7e:	83 ec 04             	sub    $0x4,%esp
  802b81:	68 84 54 80 00       	push   $0x805484
  802b86:	6a 46                	push   $0x46
  802b88:	68 53 54 80 00       	push   $0x805453
  802b8d:	e8 98 ed ff ff       	call   80192a <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  802b92:	c9                   	leave  
  802b93:	c3                   	ret    

00802b94 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802b94:	55                   	push   %ebp
  802b95:	89 e5                	mov    %esp,%ebp
  802b97:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  802b9a:	83 ec 04             	sub    $0x4,%esp
  802b9d:	68 ac 54 80 00       	push   $0x8054ac
  802ba2:	6a 61                	push   $0x61
  802ba4:	68 53 54 80 00       	push   $0x805453
  802ba9:	e8 7c ed ff ff       	call   80192a <_panic>

00802bae <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802bae:	55                   	push   %ebp
  802baf:	89 e5                	mov    %esp,%ebp
  802bb1:	83 ec 38             	sub    $0x38,%esp
  802bb4:	8b 45 10             	mov    0x10(%ebp),%eax
  802bb7:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802bba:	e8 a9 fd ff ff       	call   802968 <InitializeUHeap>
	if (size == 0) return NULL ;
  802bbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bc3:	75 0a                	jne    802bcf <smalloc+0x21>
  802bc5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bca:	e9 9e 00 00 00       	jmp    802c6d <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802bcf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802bd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdc:	01 d0                	add    %edx,%eax
  802bde:	48                   	dec    %eax
  802bdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be5:	ba 00 00 00 00       	mov    $0x0,%edx
  802bea:	f7 75 f0             	divl   -0x10(%ebp)
  802bed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf0:	29 d0                	sub    %edx,%eax
  802bf2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  802bf5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802bfc:	e8 63 06 00 00       	call   803264 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802c01:	85 c0                	test   %eax,%eax
  802c03:	74 11                	je     802c16 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  802c05:	83 ec 0c             	sub    $0xc,%esp
  802c08:	ff 75 e8             	pushl  -0x18(%ebp)
  802c0b:	e8 ce 0c 00 00       	call   8038de <alloc_block_FF>
  802c10:	83 c4 10             	add    $0x10,%esp
  802c13:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  802c16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1a:	74 4c                	je     802c68 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 40 08             	mov    0x8(%eax),%eax
  802c22:	89 c2                	mov    %eax,%edx
  802c24:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802c28:	52                   	push   %edx
  802c29:	50                   	push   %eax
  802c2a:	ff 75 0c             	pushl  0xc(%ebp)
  802c2d:	ff 75 08             	pushl  0x8(%ebp)
  802c30:	e8 b4 03 00 00       	call   802fe9 <sys_createSharedObject>
  802c35:	83 c4 10             	add    $0x10,%esp
  802c38:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  802c3b:	83 ec 08             	sub    $0x8,%esp
  802c3e:	ff 75 e0             	pushl  -0x20(%ebp)
  802c41:	68 cf 54 80 00       	push   $0x8054cf
  802c46:	e8 93 ef ff ff       	call   801bde <cprintf>
  802c4b:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  802c4e:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802c52:	74 14                	je     802c68 <smalloc+0xba>
  802c54:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  802c58:	74 0e                	je     802c68 <smalloc+0xba>
  802c5a:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  802c5e:	74 08                	je     802c68 <smalloc+0xba>
			return (void*) mem_block->sva;
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	8b 40 08             	mov    0x8(%eax),%eax
  802c66:	eb 05                	jmp    802c6d <smalloc+0xbf>
	}
	return NULL;
  802c68:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802c6d:	c9                   	leave  
  802c6e:	c3                   	ret    

00802c6f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802c6f:	55                   	push   %ebp
  802c70:	89 e5                	mov    %esp,%ebp
  802c72:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802c75:	e8 ee fc ff ff       	call   802968 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802c7a:	83 ec 04             	sub    $0x4,%esp
  802c7d:	68 e4 54 80 00       	push   $0x8054e4
  802c82:	68 ab 00 00 00       	push   $0xab
  802c87:	68 53 54 80 00       	push   $0x805453
  802c8c:	e8 99 ec ff ff       	call   80192a <_panic>

00802c91 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802c91:	55                   	push   %ebp
  802c92:	89 e5                	mov    %esp,%ebp
  802c94:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802c97:	e8 cc fc ff ff       	call   802968 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802c9c:	83 ec 04             	sub    $0x4,%esp
  802c9f:	68 08 55 80 00       	push   $0x805508
  802ca4:	68 ef 00 00 00       	push   $0xef
  802ca9:	68 53 54 80 00       	push   $0x805453
  802cae:	e8 77 ec ff ff       	call   80192a <_panic>

00802cb3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802cb3:	55                   	push   %ebp
  802cb4:	89 e5                	mov    %esp,%ebp
  802cb6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802cb9:	83 ec 04             	sub    $0x4,%esp
  802cbc:	68 30 55 80 00       	push   $0x805530
  802cc1:	68 03 01 00 00       	push   $0x103
  802cc6:	68 53 54 80 00       	push   $0x805453
  802ccb:	e8 5a ec ff ff       	call   80192a <_panic>

00802cd0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802cd0:	55                   	push   %ebp
  802cd1:	89 e5                	mov    %esp,%ebp
  802cd3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802cd6:	83 ec 04             	sub    $0x4,%esp
  802cd9:	68 54 55 80 00       	push   $0x805554
  802cde:	68 0e 01 00 00       	push   $0x10e
  802ce3:	68 53 54 80 00       	push   $0x805453
  802ce8:	e8 3d ec ff ff       	call   80192a <_panic>

00802ced <shrink>:

}
void shrink(uint32 newSize)
{
  802ced:	55                   	push   %ebp
  802cee:	89 e5                	mov    %esp,%ebp
  802cf0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802cf3:	83 ec 04             	sub    $0x4,%esp
  802cf6:	68 54 55 80 00       	push   $0x805554
  802cfb:	68 13 01 00 00       	push   $0x113
  802d00:	68 53 54 80 00       	push   $0x805453
  802d05:	e8 20 ec ff ff       	call   80192a <_panic>

00802d0a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802d0a:	55                   	push   %ebp
  802d0b:	89 e5                	mov    %esp,%ebp
  802d0d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802d10:	83 ec 04             	sub    $0x4,%esp
  802d13:	68 54 55 80 00       	push   $0x805554
  802d18:	68 18 01 00 00       	push   $0x118
  802d1d:	68 53 54 80 00       	push   $0x805453
  802d22:	e8 03 ec ff ff       	call   80192a <_panic>

00802d27 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802d27:	55                   	push   %ebp
  802d28:	89 e5                	mov    %esp,%ebp
  802d2a:	57                   	push   %edi
  802d2b:	56                   	push   %esi
  802d2c:	53                   	push   %ebx
  802d2d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d36:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d39:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d3c:	8b 7d 18             	mov    0x18(%ebp),%edi
  802d3f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802d42:	cd 30                	int    $0x30
  802d44:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802d4a:	83 c4 10             	add    $0x10,%esp
  802d4d:	5b                   	pop    %ebx
  802d4e:	5e                   	pop    %esi
  802d4f:	5f                   	pop    %edi
  802d50:	5d                   	pop    %ebp
  802d51:	c3                   	ret    

00802d52 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802d52:	55                   	push   %ebp
  802d53:	89 e5                	mov    %esp,%ebp
  802d55:	83 ec 04             	sub    $0x4,%esp
  802d58:	8b 45 10             	mov    0x10(%ebp),%eax
  802d5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802d5e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	6a 00                	push   $0x0
  802d67:	6a 00                	push   $0x0
  802d69:	52                   	push   %edx
  802d6a:	ff 75 0c             	pushl  0xc(%ebp)
  802d6d:	50                   	push   %eax
  802d6e:	6a 00                	push   $0x0
  802d70:	e8 b2 ff ff ff       	call   802d27 <syscall>
  802d75:	83 c4 18             	add    $0x18,%esp
}
  802d78:	90                   	nop
  802d79:	c9                   	leave  
  802d7a:	c3                   	ret    

00802d7b <sys_cgetc>:

int
sys_cgetc(void)
{
  802d7b:	55                   	push   %ebp
  802d7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802d7e:	6a 00                	push   $0x0
  802d80:	6a 00                	push   $0x0
  802d82:	6a 00                	push   $0x0
  802d84:	6a 00                	push   $0x0
  802d86:	6a 00                	push   $0x0
  802d88:	6a 01                	push   $0x1
  802d8a:	e8 98 ff ff ff       	call   802d27 <syscall>
  802d8f:	83 c4 18             	add    $0x18,%esp
}
  802d92:	c9                   	leave  
  802d93:	c3                   	ret    

00802d94 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802d94:	55                   	push   %ebp
  802d95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	6a 00                	push   $0x0
  802d9f:	6a 00                	push   $0x0
  802da1:	6a 00                	push   $0x0
  802da3:	52                   	push   %edx
  802da4:	50                   	push   %eax
  802da5:	6a 05                	push   $0x5
  802da7:	e8 7b ff ff ff       	call   802d27 <syscall>
  802dac:	83 c4 18             	add    $0x18,%esp
}
  802daf:	c9                   	leave  
  802db0:	c3                   	ret    

00802db1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802db1:	55                   	push   %ebp
  802db2:	89 e5                	mov    %esp,%ebp
  802db4:	56                   	push   %esi
  802db5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802db6:	8b 75 18             	mov    0x18(%ebp),%esi
  802db9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802dbc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	56                   	push   %esi
  802dc6:	53                   	push   %ebx
  802dc7:	51                   	push   %ecx
  802dc8:	52                   	push   %edx
  802dc9:	50                   	push   %eax
  802dca:	6a 06                	push   $0x6
  802dcc:	e8 56 ff ff ff       	call   802d27 <syscall>
  802dd1:	83 c4 18             	add    $0x18,%esp
}
  802dd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802dd7:	5b                   	pop    %ebx
  802dd8:	5e                   	pop    %esi
  802dd9:	5d                   	pop    %ebp
  802dda:	c3                   	ret    

00802ddb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802ddb:	55                   	push   %ebp
  802ddc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802dde:	8b 55 0c             	mov    0xc(%ebp),%edx
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	6a 00                	push   $0x0
  802de6:	6a 00                	push   $0x0
  802de8:	6a 00                	push   $0x0
  802dea:	52                   	push   %edx
  802deb:	50                   	push   %eax
  802dec:	6a 07                	push   $0x7
  802dee:	e8 34 ff ff ff       	call   802d27 <syscall>
  802df3:	83 c4 18             	add    $0x18,%esp
}
  802df6:	c9                   	leave  
  802df7:	c3                   	ret    

00802df8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802df8:	55                   	push   %ebp
  802df9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802dfb:	6a 00                	push   $0x0
  802dfd:	6a 00                	push   $0x0
  802dff:	6a 00                	push   $0x0
  802e01:	ff 75 0c             	pushl  0xc(%ebp)
  802e04:	ff 75 08             	pushl  0x8(%ebp)
  802e07:	6a 08                	push   $0x8
  802e09:	e8 19 ff ff ff       	call   802d27 <syscall>
  802e0e:	83 c4 18             	add    $0x18,%esp
}
  802e11:	c9                   	leave  
  802e12:	c3                   	ret    

00802e13 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802e13:	55                   	push   %ebp
  802e14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802e16:	6a 00                	push   $0x0
  802e18:	6a 00                	push   $0x0
  802e1a:	6a 00                	push   $0x0
  802e1c:	6a 00                	push   $0x0
  802e1e:	6a 00                	push   $0x0
  802e20:	6a 09                	push   $0x9
  802e22:	e8 00 ff ff ff       	call   802d27 <syscall>
  802e27:	83 c4 18             	add    $0x18,%esp
}
  802e2a:	c9                   	leave  
  802e2b:	c3                   	ret    

00802e2c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802e2c:	55                   	push   %ebp
  802e2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802e2f:	6a 00                	push   $0x0
  802e31:	6a 00                	push   $0x0
  802e33:	6a 00                	push   $0x0
  802e35:	6a 00                	push   $0x0
  802e37:	6a 00                	push   $0x0
  802e39:	6a 0a                	push   $0xa
  802e3b:	e8 e7 fe ff ff       	call   802d27 <syscall>
  802e40:	83 c4 18             	add    $0x18,%esp
}
  802e43:	c9                   	leave  
  802e44:	c3                   	ret    

00802e45 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802e45:	55                   	push   %ebp
  802e46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802e48:	6a 00                	push   $0x0
  802e4a:	6a 00                	push   $0x0
  802e4c:	6a 00                	push   $0x0
  802e4e:	6a 00                	push   $0x0
  802e50:	6a 00                	push   $0x0
  802e52:	6a 0b                	push   $0xb
  802e54:	e8 ce fe ff ff       	call   802d27 <syscall>
  802e59:	83 c4 18             	add    $0x18,%esp
}
  802e5c:	c9                   	leave  
  802e5d:	c3                   	ret    

00802e5e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802e5e:	55                   	push   %ebp
  802e5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802e61:	6a 00                	push   $0x0
  802e63:	6a 00                	push   $0x0
  802e65:	6a 00                	push   $0x0
  802e67:	ff 75 0c             	pushl  0xc(%ebp)
  802e6a:	ff 75 08             	pushl  0x8(%ebp)
  802e6d:	6a 0f                	push   $0xf
  802e6f:	e8 b3 fe ff ff       	call   802d27 <syscall>
  802e74:	83 c4 18             	add    $0x18,%esp
	return;
  802e77:	90                   	nop
}
  802e78:	c9                   	leave  
  802e79:	c3                   	ret    

00802e7a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802e7a:	55                   	push   %ebp
  802e7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802e7d:	6a 00                	push   $0x0
  802e7f:	6a 00                	push   $0x0
  802e81:	6a 00                	push   $0x0
  802e83:	ff 75 0c             	pushl  0xc(%ebp)
  802e86:	ff 75 08             	pushl  0x8(%ebp)
  802e89:	6a 10                	push   $0x10
  802e8b:	e8 97 fe ff ff       	call   802d27 <syscall>
  802e90:	83 c4 18             	add    $0x18,%esp
	return ;
  802e93:	90                   	nop
}
  802e94:	c9                   	leave  
  802e95:	c3                   	ret    

00802e96 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802e96:	55                   	push   %ebp
  802e97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802e99:	6a 00                	push   $0x0
  802e9b:	6a 00                	push   $0x0
  802e9d:	ff 75 10             	pushl  0x10(%ebp)
  802ea0:	ff 75 0c             	pushl  0xc(%ebp)
  802ea3:	ff 75 08             	pushl  0x8(%ebp)
  802ea6:	6a 11                	push   $0x11
  802ea8:	e8 7a fe ff ff       	call   802d27 <syscall>
  802ead:	83 c4 18             	add    $0x18,%esp
	return ;
  802eb0:	90                   	nop
}
  802eb1:	c9                   	leave  
  802eb2:	c3                   	ret    

00802eb3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802eb3:	55                   	push   %ebp
  802eb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 00                	push   $0x0
  802eba:	6a 00                	push   $0x0
  802ebc:	6a 00                	push   $0x0
  802ebe:	6a 00                	push   $0x0
  802ec0:	6a 0c                	push   $0xc
  802ec2:	e8 60 fe ff ff       	call   802d27 <syscall>
  802ec7:	83 c4 18             	add    $0x18,%esp
}
  802eca:	c9                   	leave  
  802ecb:	c3                   	ret    

00802ecc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802ecc:	55                   	push   %ebp
  802ecd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802ecf:	6a 00                	push   $0x0
  802ed1:	6a 00                	push   $0x0
  802ed3:	6a 00                	push   $0x0
  802ed5:	6a 00                	push   $0x0
  802ed7:	ff 75 08             	pushl  0x8(%ebp)
  802eda:	6a 0d                	push   $0xd
  802edc:	e8 46 fe ff ff       	call   802d27 <syscall>
  802ee1:	83 c4 18             	add    $0x18,%esp
}
  802ee4:	c9                   	leave  
  802ee5:	c3                   	ret    

00802ee6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802ee6:	55                   	push   %ebp
  802ee7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802ee9:	6a 00                	push   $0x0
  802eeb:	6a 00                	push   $0x0
  802eed:	6a 00                	push   $0x0
  802eef:	6a 00                	push   $0x0
  802ef1:	6a 00                	push   $0x0
  802ef3:	6a 0e                	push   $0xe
  802ef5:	e8 2d fe ff ff       	call   802d27 <syscall>
  802efa:	83 c4 18             	add    $0x18,%esp
}
  802efd:	90                   	nop
  802efe:	c9                   	leave  
  802eff:	c3                   	ret    

00802f00 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802f00:	55                   	push   %ebp
  802f01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802f03:	6a 00                	push   $0x0
  802f05:	6a 00                	push   $0x0
  802f07:	6a 00                	push   $0x0
  802f09:	6a 00                	push   $0x0
  802f0b:	6a 00                	push   $0x0
  802f0d:	6a 13                	push   $0x13
  802f0f:	e8 13 fe ff ff       	call   802d27 <syscall>
  802f14:	83 c4 18             	add    $0x18,%esp
}
  802f17:	90                   	nop
  802f18:	c9                   	leave  
  802f19:	c3                   	ret    

00802f1a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802f1a:	55                   	push   %ebp
  802f1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802f1d:	6a 00                	push   $0x0
  802f1f:	6a 00                	push   $0x0
  802f21:	6a 00                	push   $0x0
  802f23:	6a 00                	push   $0x0
  802f25:	6a 00                	push   $0x0
  802f27:	6a 14                	push   $0x14
  802f29:	e8 f9 fd ff ff       	call   802d27 <syscall>
  802f2e:	83 c4 18             	add    $0x18,%esp
}
  802f31:	90                   	nop
  802f32:	c9                   	leave  
  802f33:	c3                   	ret    

00802f34 <sys_cputc>:


void
sys_cputc(const char c)
{
  802f34:	55                   	push   %ebp
  802f35:	89 e5                	mov    %esp,%ebp
  802f37:	83 ec 04             	sub    $0x4,%esp
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802f40:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f44:	6a 00                	push   $0x0
  802f46:	6a 00                	push   $0x0
  802f48:	6a 00                	push   $0x0
  802f4a:	6a 00                	push   $0x0
  802f4c:	50                   	push   %eax
  802f4d:	6a 15                	push   $0x15
  802f4f:	e8 d3 fd ff ff       	call   802d27 <syscall>
  802f54:	83 c4 18             	add    $0x18,%esp
}
  802f57:	90                   	nop
  802f58:	c9                   	leave  
  802f59:	c3                   	ret    

00802f5a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802f5a:	55                   	push   %ebp
  802f5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802f5d:	6a 00                	push   $0x0
  802f5f:	6a 00                	push   $0x0
  802f61:	6a 00                	push   $0x0
  802f63:	6a 00                	push   $0x0
  802f65:	6a 00                	push   $0x0
  802f67:	6a 16                	push   $0x16
  802f69:	e8 b9 fd ff ff       	call   802d27 <syscall>
  802f6e:	83 c4 18             	add    $0x18,%esp
}
  802f71:	90                   	nop
  802f72:	c9                   	leave  
  802f73:	c3                   	ret    

00802f74 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802f74:	55                   	push   %ebp
  802f75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	6a 00                	push   $0x0
  802f7c:	6a 00                	push   $0x0
  802f7e:	6a 00                	push   $0x0
  802f80:	ff 75 0c             	pushl  0xc(%ebp)
  802f83:	50                   	push   %eax
  802f84:	6a 17                	push   $0x17
  802f86:	e8 9c fd ff ff       	call   802d27 <syscall>
  802f8b:	83 c4 18             	add    $0x18,%esp
}
  802f8e:	c9                   	leave  
  802f8f:	c3                   	ret    

00802f90 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802f90:	55                   	push   %ebp
  802f91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802f93:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f96:	8b 45 08             	mov    0x8(%ebp),%eax
  802f99:	6a 00                	push   $0x0
  802f9b:	6a 00                	push   $0x0
  802f9d:	6a 00                	push   $0x0
  802f9f:	52                   	push   %edx
  802fa0:	50                   	push   %eax
  802fa1:	6a 1a                	push   $0x1a
  802fa3:	e8 7f fd ff ff       	call   802d27 <syscall>
  802fa8:	83 c4 18             	add    $0x18,%esp
}
  802fab:	c9                   	leave  
  802fac:	c3                   	ret    

00802fad <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802fad:	55                   	push   %ebp
  802fae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802fb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	6a 00                	push   $0x0
  802fb8:	6a 00                	push   $0x0
  802fba:	6a 00                	push   $0x0
  802fbc:	52                   	push   %edx
  802fbd:	50                   	push   %eax
  802fbe:	6a 18                	push   $0x18
  802fc0:	e8 62 fd ff ff       	call   802d27 <syscall>
  802fc5:	83 c4 18             	add    $0x18,%esp
}
  802fc8:	90                   	nop
  802fc9:	c9                   	leave  
  802fca:	c3                   	ret    

00802fcb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802fcb:	55                   	push   %ebp
  802fcc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802fce:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	6a 00                	push   $0x0
  802fd6:	6a 00                	push   $0x0
  802fd8:	6a 00                	push   $0x0
  802fda:	52                   	push   %edx
  802fdb:	50                   	push   %eax
  802fdc:	6a 19                	push   $0x19
  802fde:	e8 44 fd ff ff       	call   802d27 <syscall>
  802fe3:	83 c4 18             	add    $0x18,%esp
}
  802fe6:	90                   	nop
  802fe7:	c9                   	leave  
  802fe8:	c3                   	ret    

00802fe9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802fe9:	55                   	push   %ebp
  802fea:	89 e5                	mov    %esp,%ebp
  802fec:	83 ec 04             	sub    $0x4,%esp
  802fef:	8b 45 10             	mov    0x10(%ebp),%eax
  802ff2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802ff5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ff8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fff:	6a 00                	push   $0x0
  803001:	51                   	push   %ecx
  803002:	52                   	push   %edx
  803003:	ff 75 0c             	pushl  0xc(%ebp)
  803006:	50                   	push   %eax
  803007:	6a 1b                	push   $0x1b
  803009:	e8 19 fd ff ff       	call   802d27 <syscall>
  80300e:	83 c4 18             	add    $0x18,%esp
}
  803011:	c9                   	leave  
  803012:	c3                   	ret    

00803013 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  803013:	55                   	push   %ebp
  803014:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803016:	8b 55 0c             	mov    0xc(%ebp),%edx
  803019:	8b 45 08             	mov    0x8(%ebp),%eax
  80301c:	6a 00                	push   $0x0
  80301e:	6a 00                	push   $0x0
  803020:	6a 00                	push   $0x0
  803022:	52                   	push   %edx
  803023:	50                   	push   %eax
  803024:	6a 1c                	push   $0x1c
  803026:	e8 fc fc ff ff       	call   802d27 <syscall>
  80302b:	83 c4 18             	add    $0x18,%esp
}
  80302e:	c9                   	leave  
  80302f:	c3                   	ret    

00803030 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  803030:	55                   	push   %ebp
  803031:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803033:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803036:	8b 55 0c             	mov    0xc(%ebp),%edx
  803039:	8b 45 08             	mov    0x8(%ebp),%eax
  80303c:	6a 00                	push   $0x0
  80303e:	6a 00                	push   $0x0
  803040:	51                   	push   %ecx
  803041:	52                   	push   %edx
  803042:	50                   	push   %eax
  803043:	6a 1d                	push   $0x1d
  803045:	e8 dd fc ff ff       	call   802d27 <syscall>
  80304a:	83 c4 18             	add    $0x18,%esp
}
  80304d:	c9                   	leave  
  80304e:	c3                   	ret    

0080304f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80304f:	55                   	push   %ebp
  803050:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803052:	8b 55 0c             	mov    0xc(%ebp),%edx
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	6a 00                	push   $0x0
  80305a:	6a 00                	push   $0x0
  80305c:	6a 00                	push   $0x0
  80305e:	52                   	push   %edx
  80305f:	50                   	push   %eax
  803060:	6a 1e                	push   $0x1e
  803062:	e8 c0 fc ff ff       	call   802d27 <syscall>
  803067:	83 c4 18             	add    $0x18,%esp
}
  80306a:	c9                   	leave  
  80306b:	c3                   	ret    

0080306c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80306c:	55                   	push   %ebp
  80306d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80306f:	6a 00                	push   $0x0
  803071:	6a 00                	push   $0x0
  803073:	6a 00                	push   $0x0
  803075:	6a 00                	push   $0x0
  803077:	6a 00                	push   $0x0
  803079:	6a 1f                	push   $0x1f
  80307b:	e8 a7 fc ff ff       	call   802d27 <syscall>
  803080:	83 c4 18             	add    $0x18,%esp
}
  803083:	c9                   	leave  
  803084:	c3                   	ret    

00803085 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803085:	55                   	push   %ebp
  803086:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	6a 00                	push   $0x0
  80308d:	ff 75 14             	pushl  0x14(%ebp)
  803090:	ff 75 10             	pushl  0x10(%ebp)
  803093:	ff 75 0c             	pushl  0xc(%ebp)
  803096:	50                   	push   %eax
  803097:	6a 20                	push   $0x20
  803099:	e8 89 fc ff ff       	call   802d27 <syscall>
  80309e:	83 c4 18             	add    $0x18,%esp
}
  8030a1:	c9                   	leave  
  8030a2:	c3                   	ret    

008030a3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8030a3:	55                   	push   %ebp
  8030a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	6a 00                	push   $0x0
  8030ab:	6a 00                	push   $0x0
  8030ad:	6a 00                	push   $0x0
  8030af:	6a 00                	push   $0x0
  8030b1:	50                   	push   %eax
  8030b2:	6a 21                	push   $0x21
  8030b4:	e8 6e fc ff ff       	call   802d27 <syscall>
  8030b9:	83 c4 18             	add    $0x18,%esp
}
  8030bc:	90                   	nop
  8030bd:	c9                   	leave  
  8030be:	c3                   	ret    

008030bf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8030bf:	55                   	push   %ebp
  8030c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	6a 00                	push   $0x0
  8030c7:	6a 00                	push   $0x0
  8030c9:	6a 00                	push   $0x0
  8030cb:	6a 00                	push   $0x0
  8030cd:	50                   	push   %eax
  8030ce:	6a 22                	push   $0x22
  8030d0:	e8 52 fc ff ff       	call   802d27 <syscall>
  8030d5:	83 c4 18             	add    $0x18,%esp
}
  8030d8:	c9                   	leave  
  8030d9:	c3                   	ret    

008030da <sys_getenvid>:

int32 sys_getenvid(void)
{
  8030da:	55                   	push   %ebp
  8030db:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8030dd:	6a 00                	push   $0x0
  8030df:	6a 00                	push   $0x0
  8030e1:	6a 00                	push   $0x0
  8030e3:	6a 00                	push   $0x0
  8030e5:	6a 00                	push   $0x0
  8030e7:	6a 02                	push   $0x2
  8030e9:	e8 39 fc ff ff       	call   802d27 <syscall>
  8030ee:	83 c4 18             	add    $0x18,%esp
}
  8030f1:	c9                   	leave  
  8030f2:	c3                   	ret    

008030f3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8030f3:	55                   	push   %ebp
  8030f4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8030f6:	6a 00                	push   $0x0
  8030f8:	6a 00                	push   $0x0
  8030fa:	6a 00                	push   $0x0
  8030fc:	6a 00                	push   $0x0
  8030fe:	6a 00                	push   $0x0
  803100:	6a 03                	push   $0x3
  803102:	e8 20 fc ff ff       	call   802d27 <syscall>
  803107:	83 c4 18             	add    $0x18,%esp
}
  80310a:	c9                   	leave  
  80310b:	c3                   	ret    

0080310c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80310c:	55                   	push   %ebp
  80310d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80310f:	6a 00                	push   $0x0
  803111:	6a 00                	push   $0x0
  803113:	6a 00                	push   $0x0
  803115:	6a 00                	push   $0x0
  803117:	6a 00                	push   $0x0
  803119:	6a 04                	push   $0x4
  80311b:	e8 07 fc ff ff       	call   802d27 <syscall>
  803120:	83 c4 18             	add    $0x18,%esp
}
  803123:	c9                   	leave  
  803124:	c3                   	ret    

00803125 <sys_exit_env>:


void sys_exit_env(void)
{
  803125:	55                   	push   %ebp
  803126:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803128:	6a 00                	push   $0x0
  80312a:	6a 00                	push   $0x0
  80312c:	6a 00                	push   $0x0
  80312e:	6a 00                	push   $0x0
  803130:	6a 00                	push   $0x0
  803132:	6a 23                	push   $0x23
  803134:	e8 ee fb ff ff       	call   802d27 <syscall>
  803139:	83 c4 18             	add    $0x18,%esp
}
  80313c:	90                   	nop
  80313d:	c9                   	leave  
  80313e:	c3                   	ret    

0080313f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80313f:	55                   	push   %ebp
  803140:	89 e5                	mov    %esp,%ebp
  803142:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803145:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803148:	8d 50 04             	lea    0x4(%eax),%edx
  80314b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80314e:	6a 00                	push   $0x0
  803150:	6a 00                	push   $0x0
  803152:	6a 00                	push   $0x0
  803154:	52                   	push   %edx
  803155:	50                   	push   %eax
  803156:	6a 24                	push   $0x24
  803158:	e8 ca fb ff ff       	call   802d27 <syscall>
  80315d:	83 c4 18             	add    $0x18,%esp
	return result;
  803160:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803163:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803166:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803169:	89 01                	mov    %eax,(%ecx)
  80316b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80316e:	8b 45 08             	mov    0x8(%ebp),%eax
  803171:	c9                   	leave  
  803172:	c2 04 00             	ret    $0x4

00803175 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803175:	55                   	push   %ebp
  803176:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803178:	6a 00                	push   $0x0
  80317a:	6a 00                	push   $0x0
  80317c:	ff 75 10             	pushl  0x10(%ebp)
  80317f:	ff 75 0c             	pushl  0xc(%ebp)
  803182:	ff 75 08             	pushl  0x8(%ebp)
  803185:	6a 12                	push   $0x12
  803187:	e8 9b fb ff ff       	call   802d27 <syscall>
  80318c:	83 c4 18             	add    $0x18,%esp
	return ;
  80318f:	90                   	nop
}
  803190:	c9                   	leave  
  803191:	c3                   	ret    

00803192 <sys_rcr2>:
uint32 sys_rcr2()
{
  803192:	55                   	push   %ebp
  803193:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803195:	6a 00                	push   $0x0
  803197:	6a 00                	push   $0x0
  803199:	6a 00                	push   $0x0
  80319b:	6a 00                	push   $0x0
  80319d:	6a 00                	push   $0x0
  80319f:	6a 25                	push   $0x25
  8031a1:	e8 81 fb ff ff       	call   802d27 <syscall>
  8031a6:	83 c4 18             	add    $0x18,%esp
}
  8031a9:	c9                   	leave  
  8031aa:	c3                   	ret    

008031ab <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8031ab:	55                   	push   %ebp
  8031ac:	89 e5                	mov    %esp,%ebp
  8031ae:	83 ec 04             	sub    $0x4,%esp
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8031b7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8031bb:	6a 00                	push   $0x0
  8031bd:	6a 00                	push   $0x0
  8031bf:	6a 00                	push   $0x0
  8031c1:	6a 00                	push   $0x0
  8031c3:	50                   	push   %eax
  8031c4:	6a 26                	push   $0x26
  8031c6:	e8 5c fb ff ff       	call   802d27 <syscall>
  8031cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8031ce:	90                   	nop
}
  8031cf:	c9                   	leave  
  8031d0:	c3                   	ret    

008031d1 <rsttst>:
void rsttst()
{
  8031d1:	55                   	push   %ebp
  8031d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8031d4:	6a 00                	push   $0x0
  8031d6:	6a 00                	push   $0x0
  8031d8:	6a 00                	push   $0x0
  8031da:	6a 00                	push   $0x0
  8031dc:	6a 00                	push   $0x0
  8031de:	6a 28                	push   $0x28
  8031e0:	e8 42 fb ff ff       	call   802d27 <syscall>
  8031e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8031e8:	90                   	nop
}
  8031e9:	c9                   	leave  
  8031ea:	c3                   	ret    

008031eb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8031eb:	55                   	push   %ebp
  8031ec:	89 e5                	mov    %esp,%ebp
  8031ee:	83 ec 04             	sub    $0x4,%esp
  8031f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8031f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8031f7:	8b 55 18             	mov    0x18(%ebp),%edx
  8031fa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8031fe:	52                   	push   %edx
  8031ff:	50                   	push   %eax
  803200:	ff 75 10             	pushl  0x10(%ebp)
  803203:	ff 75 0c             	pushl  0xc(%ebp)
  803206:	ff 75 08             	pushl  0x8(%ebp)
  803209:	6a 27                	push   $0x27
  80320b:	e8 17 fb ff ff       	call   802d27 <syscall>
  803210:	83 c4 18             	add    $0x18,%esp
	return ;
  803213:	90                   	nop
}
  803214:	c9                   	leave  
  803215:	c3                   	ret    

00803216 <chktst>:
void chktst(uint32 n)
{
  803216:	55                   	push   %ebp
  803217:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803219:	6a 00                	push   $0x0
  80321b:	6a 00                	push   $0x0
  80321d:	6a 00                	push   $0x0
  80321f:	6a 00                	push   $0x0
  803221:	ff 75 08             	pushl  0x8(%ebp)
  803224:	6a 29                	push   $0x29
  803226:	e8 fc fa ff ff       	call   802d27 <syscall>
  80322b:	83 c4 18             	add    $0x18,%esp
	return ;
  80322e:	90                   	nop
}
  80322f:	c9                   	leave  
  803230:	c3                   	ret    

00803231 <inctst>:

void inctst()
{
  803231:	55                   	push   %ebp
  803232:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803234:	6a 00                	push   $0x0
  803236:	6a 00                	push   $0x0
  803238:	6a 00                	push   $0x0
  80323a:	6a 00                	push   $0x0
  80323c:	6a 00                	push   $0x0
  80323e:	6a 2a                	push   $0x2a
  803240:	e8 e2 fa ff ff       	call   802d27 <syscall>
  803245:	83 c4 18             	add    $0x18,%esp
	return ;
  803248:	90                   	nop
}
  803249:	c9                   	leave  
  80324a:	c3                   	ret    

0080324b <gettst>:
uint32 gettst()
{
  80324b:	55                   	push   %ebp
  80324c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80324e:	6a 00                	push   $0x0
  803250:	6a 00                	push   $0x0
  803252:	6a 00                	push   $0x0
  803254:	6a 00                	push   $0x0
  803256:	6a 00                	push   $0x0
  803258:	6a 2b                	push   $0x2b
  80325a:	e8 c8 fa ff ff       	call   802d27 <syscall>
  80325f:	83 c4 18             	add    $0x18,%esp
}
  803262:	c9                   	leave  
  803263:	c3                   	ret    

00803264 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  803264:	55                   	push   %ebp
  803265:	89 e5                	mov    %esp,%ebp
  803267:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80326a:	6a 00                	push   $0x0
  80326c:	6a 00                	push   $0x0
  80326e:	6a 00                	push   $0x0
  803270:	6a 00                	push   $0x0
  803272:	6a 00                	push   $0x0
  803274:	6a 2c                	push   $0x2c
  803276:	e8 ac fa ff ff       	call   802d27 <syscall>
  80327b:	83 c4 18             	add    $0x18,%esp
  80327e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  803281:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  803285:	75 07                	jne    80328e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  803287:	b8 01 00 00 00       	mov    $0x1,%eax
  80328c:	eb 05                	jmp    803293 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80328e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803293:	c9                   	leave  
  803294:	c3                   	ret    

00803295 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  803295:	55                   	push   %ebp
  803296:	89 e5                	mov    %esp,%ebp
  803298:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80329b:	6a 00                	push   $0x0
  80329d:	6a 00                	push   $0x0
  80329f:	6a 00                	push   $0x0
  8032a1:	6a 00                	push   $0x0
  8032a3:	6a 00                	push   $0x0
  8032a5:	6a 2c                	push   $0x2c
  8032a7:	e8 7b fa ff ff       	call   802d27 <syscall>
  8032ac:	83 c4 18             	add    $0x18,%esp
  8032af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8032b2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8032b6:	75 07                	jne    8032bf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8032b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8032bd:	eb 05                	jmp    8032c4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8032bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032c4:	c9                   	leave  
  8032c5:	c3                   	ret    

008032c6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8032c6:	55                   	push   %ebp
  8032c7:	89 e5                	mov    %esp,%ebp
  8032c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032cc:	6a 00                	push   $0x0
  8032ce:	6a 00                	push   $0x0
  8032d0:	6a 00                	push   $0x0
  8032d2:	6a 00                	push   $0x0
  8032d4:	6a 00                	push   $0x0
  8032d6:	6a 2c                	push   $0x2c
  8032d8:	e8 4a fa ff ff       	call   802d27 <syscall>
  8032dd:	83 c4 18             	add    $0x18,%esp
  8032e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8032e3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8032e7:	75 07                	jne    8032f0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8032e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8032ee:	eb 05                	jmp    8032f5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8032f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032f5:	c9                   	leave  
  8032f6:	c3                   	ret    

008032f7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8032f7:	55                   	push   %ebp
  8032f8:	89 e5                	mov    %esp,%ebp
  8032fa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032fd:	6a 00                	push   $0x0
  8032ff:	6a 00                	push   $0x0
  803301:	6a 00                	push   $0x0
  803303:	6a 00                	push   $0x0
  803305:	6a 00                	push   $0x0
  803307:	6a 2c                	push   $0x2c
  803309:	e8 19 fa ff ff       	call   802d27 <syscall>
  80330e:	83 c4 18             	add    $0x18,%esp
  803311:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  803314:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  803318:	75 07                	jne    803321 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80331a:	b8 01 00 00 00       	mov    $0x1,%eax
  80331f:	eb 05                	jmp    803326 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803321:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803326:	c9                   	leave  
  803327:	c3                   	ret    

00803328 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803328:	55                   	push   %ebp
  803329:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80332b:	6a 00                	push   $0x0
  80332d:	6a 00                	push   $0x0
  80332f:	6a 00                	push   $0x0
  803331:	6a 00                	push   $0x0
  803333:	ff 75 08             	pushl  0x8(%ebp)
  803336:	6a 2d                	push   $0x2d
  803338:	e8 ea f9 ff ff       	call   802d27 <syscall>
  80333d:	83 c4 18             	add    $0x18,%esp
	return ;
  803340:	90                   	nop
}
  803341:	c9                   	leave  
  803342:	c3                   	ret    

00803343 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803343:	55                   	push   %ebp
  803344:	89 e5                	mov    %esp,%ebp
  803346:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803347:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80334a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80334d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803350:	8b 45 08             	mov    0x8(%ebp),%eax
  803353:	6a 00                	push   $0x0
  803355:	53                   	push   %ebx
  803356:	51                   	push   %ecx
  803357:	52                   	push   %edx
  803358:	50                   	push   %eax
  803359:	6a 2e                	push   $0x2e
  80335b:	e8 c7 f9 ff ff       	call   802d27 <syscall>
  803360:	83 c4 18             	add    $0x18,%esp
}
  803363:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803366:	c9                   	leave  
  803367:	c3                   	ret    

00803368 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803368:	55                   	push   %ebp
  803369:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80336b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80336e:	8b 45 08             	mov    0x8(%ebp),%eax
  803371:	6a 00                	push   $0x0
  803373:	6a 00                	push   $0x0
  803375:	6a 00                	push   $0x0
  803377:	52                   	push   %edx
  803378:	50                   	push   %eax
  803379:	6a 2f                	push   $0x2f
  80337b:	e8 a7 f9 ff ff       	call   802d27 <syscall>
  803380:	83 c4 18             	add    $0x18,%esp
}
  803383:	c9                   	leave  
  803384:	c3                   	ret    

00803385 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  803385:	55                   	push   %ebp
  803386:	89 e5                	mov    %esp,%ebp
  803388:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80338b:	83 ec 0c             	sub    $0xc,%esp
  80338e:	68 64 55 80 00       	push   $0x805564
  803393:	e8 46 e8 ff ff       	call   801bde <cprintf>
  803398:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80339b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8033a2:	83 ec 0c             	sub    $0xc,%esp
  8033a5:	68 90 55 80 00       	push   $0x805590
  8033aa:	e8 2f e8 ff ff       	call   801bde <cprintf>
  8033af:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8033b2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8033b6:	a1 38 61 80 00       	mov    0x806138,%eax
  8033bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033be:	eb 56                	jmp    803416 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8033c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033c4:	74 1c                	je     8033e2 <print_mem_block_lists+0x5d>
  8033c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c9:	8b 50 08             	mov    0x8(%eax),%edx
  8033cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033cf:	8b 48 08             	mov    0x8(%eax),%ecx
  8033d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d8:	01 c8                	add    %ecx,%eax
  8033da:	39 c2                	cmp    %eax,%edx
  8033dc:	73 04                	jae    8033e2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8033de:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8033e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e5:	8b 50 08             	mov    0x8(%eax),%edx
  8033e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ee:	01 c2                	add    %eax,%edx
  8033f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f3:	8b 40 08             	mov    0x8(%eax),%eax
  8033f6:	83 ec 04             	sub    $0x4,%esp
  8033f9:	52                   	push   %edx
  8033fa:	50                   	push   %eax
  8033fb:	68 a5 55 80 00       	push   $0x8055a5
  803400:	e8 d9 e7 ff ff       	call   801bde <cprintf>
  803405:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80340e:	a1 40 61 80 00       	mov    0x806140,%eax
  803413:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803416:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80341a:	74 07                	je     803423 <print_mem_block_lists+0x9e>
  80341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341f:	8b 00                	mov    (%eax),%eax
  803421:	eb 05                	jmp    803428 <print_mem_block_lists+0xa3>
  803423:	b8 00 00 00 00       	mov    $0x0,%eax
  803428:	a3 40 61 80 00       	mov    %eax,0x806140
  80342d:	a1 40 61 80 00       	mov    0x806140,%eax
  803432:	85 c0                	test   %eax,%eax
  803434:	75 8a                	jne    8033c0 <print_mem_block_lists+0x3b>
  803436:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80343a:	75 84                	jne    8033c0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80343c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803440:	75 10                	jne    803452 <print_mem_block_lists+0xcd>
  803442:	83 ec 0c             	sub    $0xc,%esp
  803445:	68 b4 55 80 00       	push   $0x8055b4
  80344a:	e8 8f e7 ff ff       	call   801bde <cprintf>
  80344f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  803452:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  803459:	83 ec 0c             	sub    $0xc,%esp
  80345c:	68 d8 55 80 00       	push   $0x8055d8
  803461:	e8 78 e7 ff ff       	call   801bde <cprintf>
  803466:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  803469:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80346d:	a1 40 60 80 00       	mov    0x806040,%eax
  803472:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803475:	eb 56                	jmp    8034cd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803477:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80347b:	74 1c                	je     803499 <print_mem_block_lists+0x114>
  80347d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803480:	8b 50 08             	mov    0x8(%eax),%edx
  803483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803486:	8b 48 08             	mov    0x8(%eax),%ecx
  803489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348c:	8b 40 0c             	mov    0xc(%eax),%eax
  80348f:	01 c8                	add    %ecx,%eax
  803491:	39 c2                	cmp    %eax,%edx
  803493:	73 04                	jae    803499 <print_mem_block_lists+0x114>
			sorted = 0 ;
  803495:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349c:	8b 50 08             	mov    0x8(%eax),%edx
  80349f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a5:	01 c2                	add    %eax,%edx
  8034a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034aa:	8b 40 08             	mov    0x8(%eax),%eax
  8034ad:	83 ec 04             	sub    $0x4,%esp
  8034b0:	52                   	push   %edx
  8034b1:	50                   	push   %eax
  8034b2:	68 a5 55 80 00       	push   $0x8055a5
  8034b7:	e8 22 e7 ff ff       	call   801bde <cprintf>
  8034bc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8034bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8034c5:	a1 48 60 80 00       	mov    0x806048,%eax
  8034ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d1:	74 07                	je     8034da <print_mem_block_lists+0x155>
  8034d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d6:	8b 00                	mov    (%eax),%eax
  8034d8:	eb 05                	jmp    8034df <print_mem_block_lists+0x15a>
  8034da:	b8 00 00 00 00       	mov    $0x0,%eax
  8034df:	a3 48 60 80 00       	mov    %eax,0x806048
  8034e4:	a1 48 60 80 00       	mov    0x806048,%eax
  8034e9:	85 c0                	test   %eax,%eax
  8034eb:	75 8a                	jne    803477 <print_mem_block_lists+0xf2>
  8034ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034f1:	75 84                	jne    803477 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8034f3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8034f7:	75 10                	jne    803509 <print_mem_block_lists+0x184>
  8034f9:	83 ec 0c             	sub    $0xc,%esp
  8034fc:	68 f0 55 80 00       	push   $0x8055f0
  803501:	e8 d8 e6 ff ff       	call   801bde <cprintf>
  803506:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803509:	83 ec 0c             	sub    $0xc,%esp
  80350c:	68 64 55 80 00       	push   $0x805564
  803511:	e8 c8 e6 ff ff       	call   801bde <cprintf>
  803516:	83 c4 10             	add    $0x10,%esp

}
  803519:	90                   	nop
  80351a:	c9                   	leave  
  80351b:	c3                   	ret    

0080351c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80351c:	55                   	push   %ebp
  80351d:	89 e5                	mov    %esp,%ebp
  80351f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  803522:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  803529:	00 00 00 
  80352c:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  803533:	00 00 00 
  803536:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  80353d:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  803540:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803547:	e9 9e 00 00 00       	jmp    8035ea <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80354c:	a1 50 60 80 00       	mov    0x806050,%eax
  803551:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803554:	c1 e2 04             	shl    $0x4,%edx
  803557:	01 d0                	add    %edx,%eax
  803559:	85 c0                	test   %eax,%eax
  80355b:	75 14                	jne    803571 <initialize_MemBlocksList+0x55>
  80355d:	83 ec 04             	sub    $0x4,%esp
  803560:	68 18 56 80 00       	push   $0x805618
  803565:	6a 46                	push   $0x46
  803567:	68 3b 56 80 00       	push   $0x80563b
  80356c:	e8 b9 e3 ff ff       	call   80192a <_panic>
  803571:	a1 50 60 80 00       	mov    0x806050,%eax
  803576:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803579:	c1 e2 04             	shl    $0x4,%edx
  80357c:	01 d0                	add    %edx,%eax
  80357e:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803584:	89 10                	mov    %edx,(%eax)
  803586:	8b 00                	mov    (%eax),%eax
  803588:	85 c0                	test   %eax,%eax
  80358a:	74 18                	je     8035a4 <initialize_MemBlocksList+0x88>
  80358c:	a1 48 61 80 00       	mov    0x806148,%eax
  803591:	8b 15 50 60 80 00    	mov    0x806050,%edx
  803597:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80359a:	c1 e1 04             	shl    $0x4,%ecx
  80359d:	01 ca                	add    %ecx,%edx
  80359f:	89 50 04             	mov    %edx,0x4(%eax)
  8035a2:	eb 12                	jmp    8035b6 <initialize_MemBlocksList+0x9a>
  8035a4:	a1 50 60 80 00       	mov    0x806050,%eax
  8035a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ac:	c1 e2 04             	shl    $0x4,%edx
  8035af:	01 d0                	add    %edx,%eax
  8035b1:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8035b6:	a1 50 60 80 00       	mov    0x806050,%eax
  8035bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035be:	c1 e2 04             	shl    $0x4,%edx
  8035c1:	01 d0                	add    %edx,%eax
  8035c3:	a3 48 61 80 00       	mov    %eax,0x806148
  8035c8:	a1 50 60 80 00       	mov    0x806050,%eax
  8035cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035d0:	c1 e2 04             	shl    $0x4,%edx
  8035d3:	01 d0                	add    %edx,%eax
  8035d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035dc:	a1 54 61 80 00       	mov    0x806154,%eax
  8035e1:	40                   	inc    %eax
  8035e2:	a3 54 61 80 00       	mov    %eax,0x806154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8035e7:	ff 45 f4             	incl   -0xc(%ebp)
  8035ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035f0:	0f 82 56 ff ff ff    	jb     80354c <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8035f6:	90                   	nop
  8035f7:	c9                   	leave  
  8035f8:	c3                   	ret    

008035f9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8035f9:	55                   	push   %ebp
  8035fa:	89 e5                	mov    %esp,%ebp
  8035fc:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8035ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803602:	8b 00                	mov    (%eax),%eax
  803604:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803607:	eb 19                	jmp    803622 <find_block+0x29>
	{
		if(va==point->sva)
  803609:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80360c:	8b 40 08             	mov    0x8(%eax),%eax
  80360f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803612:	75 05                	jne    803619 <find_block+0x20>
		   return point;
  803614:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803617:	eb 36                	jmp    80364f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  803619:	8b 45 08             	mov    0x8(%ebp),%eax
  80361c:	8b 40 08             	mov    0x8(%eax),%eax
  80361f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803622:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803626:	74 07                	je     80362f <find_block+0x36>
  803628:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80362b:	8b 00                	mov    (%eax),%eax
  80362d:	eb 05                	jmp    803634 <find_block+0x3b>
  80362f:	b8 00 00 00 00       	mov    $0x0,%eax
  803634:	8b 55 08             	mov    0x8(%ebp),%edx
  803637:	89 42 08             	mov    %eax,0x8(%edx)
  80363a:	8b 45 08             	mov    0x8(%ebp),%eax
  80363d:	8b 40 08             	mov    0x8(%eax),%eax
  803640:	85 c0                	test   %eax,%eax
  803642:	75 c5                	jne    803609 <find_block+0x10>
  803644:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803648:	75 bf                	jne    803609 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80364a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80364f:	c9                   	leave  
  803650:	c3                   	ret    

00803651 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  803651:	55                   	push   %ebp
  803652:	89 e5                	mov    %esp,%ebp
  803654:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  803657:	a1 40 60 80 00       	mov    0x806040,%eax
  80365c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80365f:	a1 44 60 80 00       	mov    0x806044,%eax
  803664:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  803667:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80366a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80366d:	74 24                	je     803693 <insert_sorted_allocList+0x42>
  80366f:	8b 45 08             	mov    0x8(%ebp),%eax
  803672:	8b 50 08             	mov    0x8(%eax),%edx
  803675:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803678:	8b 40 08             	mov    0x8(%eax),%eax
  80367b:	39 c2                	cmp    %eax,%edx
  80367d:	76 14                	jbe    803693 <insert_sorted_allocList+0x42>
  80367f:	8b 45 08             	mov    0x8(%ebp),%eax
  803682:	8b 50 08             	mov    0x8(%eax),%edx
  803685:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803688:	8b 40 08             	mov    0x8(%eax),%eax
  80368b:	39 c2                	cmp    %eax,%edx
  80368d:	0f 82 60 01 00 00    	jb     8037f3 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  803693:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803697:	75 65                	jne    8036fe <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  803699:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80369d:	75 14                	jne    8036b3 <insert_sorted_allocList+0x62>
  80369f:	83 ec 04             	sub    $0x4,%esp
  8036a2:	68 18 56 80 00       	push   $0x805618
  8036a7:	6a 6b                	push   $0x6b
  8036a9:	68 3b 56 80 00       	push   $0x80563b
  8036ae:	e8 77 e2 ff ff       	call   80192a <_panic>
  8036b3:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8036b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bc:	89 10                	mov    %edx,(%eax)
  8036be:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c1:	8b 00                	mov    (%eax),%eax
  8036c3:	85 c0                	test   %eax,%eax
  8036c5:	74 0d                	je     8036d4 <insert_sorted_allocList+0x83>
  8036c7:	a1 40 60 80 00       	mov    0x806040,%eax
  8036cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8036cf:	89 50 04             	mov    %edx,0x4(%eax)
  8036d2:	eb 08                	jmp    8036dc <insert_sorted_allocList+0x8b>
  8036d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d7:	a3 44 60 80 00       	mov    %eax,0x806044
  8036dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036df:	a3 40 60 80 00       	mov    %eax,0x806040
  8036e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ee:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8036f3:	40                   	inc    %eax
  8036f4:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8036f9:	e9 dc 01 00 00       	jmp    8038da <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8036fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803701:	8b 50 08             	mov    0x8(%eax),%edx
  803704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803707:	8b 40 08             	mov    0x8(%eax),%eax
  80370a:	39 c2                	cmp    %eax,%edx
  80370c:	77 6c                	ja     80377a <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80370e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803712:	74 06                	je     80371a <insert_sorted_allocList+0xc9>
  803714:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803718:	75 14                	jne    80372e <insert_sorted_allocList+0xdd>
  80371a:	83 ec 04             	sub    $0x4,%esp
  80371d:	68 54 56 80 00       	push   $0x805654
  803722:	6a 6f                	push   $0x6f
  803724:	68 3b 56 80 00       	push   $0x80563b
  803729:	e8 fc e1 ff ff       	call   80192a <_panic>
  80372e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803731:	8b 50 04             	mov    0x4(%eax),%edx
  803734:	8b 45 08             	mov    0x8(%ebp),%eax
  803737:	89 50 04             	mov    %edx,0x4(%eax)
  80373a:	8b 45 08             	mov    0x8(%ebp),%eax
  80373d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803740:	89 10                	mov    %edx,(%eax)
  803742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803745:	8b 40 04             	mov    0x4(%eax),%eax
  803748:	85 c0                	test   %eax,%eax
  80374a:	74 0d                	je     803759 <insert_sorted_allocList+0x108>
  80374c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374f:	8b 40 04             	mov    0x4(%eax),%eax
  803752:	8b 55 08             	mov    0x8(%ebp),%edx
  803755:	89 10                	mov    %edx,(%eax)
  803757:	eb 08                	jmp    803761 <insert_sorted_allocList+0x110>
  803759:	8b 45 08             	mov    0x8(%ebp),%eax
  80375c:	a3 40 60 80 00       	mov    %eax,0x806040
  803761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803764:	8b 55 08             	mov    0x8(%ebp),%edx
  803767:	89 50 04             	mov    %edx,0x4(%eax)
  80376a:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80376f:	40                   	inc    %eax
  803770:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803775:	e9 60 01 00 00       	jmp    8038da <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	8b 50 08             	mov    0x8(%eax),%edx
  803780:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803783:	8b 40 08             	mov    0x8(%eax),%eax
  803786:	39 c2                	cmp    %eax,%edx
  803788:	0f 82 4c 01 00 00    	jb     8038da <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80378e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803792:	75 14                	jne    8037a8 <insert_sorted_allocList+0x157>
  803794:	83 ec 04             	sub    $0x4,%esp
  803797:	68 8c 56 80 00       	push   $0x80568c
  80379c:	6a 73                	push   $0x73
  80379e:	68 3b 56 80 00       	push   $0x80563b
  8037a3:	e8 82 e1 ff ff       	call   80192a <_panic>
  8037a8:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8037ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b1:	89 50 04             	mov    %edx,0x4(%eax)
  8037b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b7:	8b 40 04             	mov    0x4(%eax),%eax
  8037ba:	85 c0                	test   %eax,%eax
  8037bc:	74 0c                	je     8037ca <insert_sorted_allocList+0x179>
  8037be:	a1 44 60 80 00       	mov    0x806044,%eax
  8037c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8037c6:	89 10                	mov    %edx,(%eax)
  8037c8:	eb 08                	jmp    8037d2 <insert_sorted_allocList+0x181>
  8037ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cd:	a3 40 60 80 00       	mov    %eax,0x806040
  8037d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d5:	a3 44 60 80 00       	mov    %eax,0x806044
  8037da:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037e3:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8037e8:	40                   	inc    %eax
  8037e9:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8037ee:	e9 e7 00 00 00       	jmp    8038da <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8037f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8037f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  803800:	a1 40 60 80 00       	mov    0x806040,%eax
  803805:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803808:	e9 9d 00 00 00       	jmp    8038aa <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80380d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803810:	8b 00                	mov    (%eax),%eax
  803812:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  803815:	8b 45 08             	mov    0x8(%ebp),%eax
  803818:	8b 50 08             	mov    0x8(%eax),%edx
  80381b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381e:	8b 40 08             	mov    0x8(%eax),%eax
  803821:	39 c2                	cmp    %eax,%edx
  803823:	76 7d                	jbe    8038a2 <insert_sorted_allocList+0x251>
  803825:	8b 45 08             	mov    0x8(%ebp),%eax
  803828:	8b 50 08             	mov    0x8(%eax),%edx
  80382b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382e:	8b 40 08             	mov    0x8(%eax),%eax
  803831:	39 c2                	cmp    %eax,%edx
  803833:	73 6d                	jae    8038a2 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  803835:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803839:	74 06                	je     803841 <insert_sorted_allocList+0x1f0>
  80383b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80383f:	75 14                	jne    803855 <insert_sorted_allocList+0x204>
  803841:	83 ec 04             	sub    $0x4,%esp
  803844:	68 b0 56 80 00       	push   $0x8056b0
  803849:	6a 7f                	push   $0x7f
  80384b:	68 3b 56 80 00       	push   $0x80563b
  803850:	e8 d5 e0 ff ff       	call   80192a <_panic>
  803855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803858:	8b 10                	mov    (%eax),%edx
  80385a:	8b 45 08             	mov    0x8(%ebp),%eax
  80385d:	89 10                	mov    %edx,(%eax)
  80385f:	8b 45 08             	mov    0x8(%ebp),%eax
  803862:	8b 00                	mov    (%eax),%eax
  803864:	85 c0                	test   %eax,%eax
  803866:	74 0b                	je     803873 <insert_sorted_allocList+0x222>
  803868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386b:	8b 00                	mov    (%eax),%eax
  80386d:	8b 55 08             	mov    0x8(%ebp),%edx
  803870:	89 50 04             	mov    %edx,0x4(%eax)
  803873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803876:	8b 55 08             	mov    0x8(%ebp),%edx
  803879:	89 10                	mov    %edx,(%eax)
  80387b:	8b 45 08             	mov    0x8(%ebp),%eax
  80387e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803881:	89 50 04             	mov    %edx,0x4(%eax)
  803884:	8b 45 08             	mov    0x8(%ebp),%eax
  803887:	8b 00                	mov    (%eax),%eax
  803889:	85 c0                	test   %eax,%eax
  80388b:	75 08                	jne    803895 <insert_sorted_allocList+0x244>
  80388d:	8b 45 08             	mov    0x8(%ebp),%eax
  803890:	a3 44 60 80 00       	mov    %eax,0x806044
  803895:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80389a:	40                   	inc    %eax
  80389b:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  8038a0:	eb 39                	jmp    8038db <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8038a2:	a1 48 60 80 00       	mov    0x806048,%eax
  8038a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038ae:	74 07                	je     8038b7 <insert_sorted_allocList+0x266>
  8038b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b3:	8b 00                	mov    (%eax),%eax
  8038b5:	eb 05                	jmp    8038bc <insert_sorted_allocList+0x26b>
  8038b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038bc:	a3 48 60 80 00       	mov    %eax,0x806048
  8038c1:	a1 48 60 80 00       	mov    0x806048,%eax
  8038c6:	85 c0                	test   %eax,%eax
  8038c8:	0f 85 3f ff ff ff    	jne    80380d <insert_sorted_allocList+0x1bc>
  8038ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038d2:	0f 85 35 ff ff ff    	jne    80380d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8038d8:	eb 01                	jmp    8038db <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8038da:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8038db:	90                   	nop
  8038dc:	c9                   	leave  
  8038dd:	c3                   	ret    

008038de <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8038de:	55                   	push   %ebp
  8038df:	89 e5                	mov    %esp,%ebp
  8038e1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8038e4:	a1 38 61 80 00       	mov    0x806138,%eax
  8038e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038ec:	e9 85 01 00 00       	jmp    803a76 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8038f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8038f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038fa:	0f 82 6e 01 00 00    	jb     803a6e <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  803900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803903:	8b 40 0c             	mov    0xc(%eax),%eax
  803906:	3b 45 08             	cmp    0x8(%ebp),%eax
  803909:	0f 85 8a 00 00 00    	jne    803999 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80390f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803913:	75 17                	jne    80392c <alloc_block_FF+0x4e>
  803915:	83 ec 04             	sub    $0x4,%esp
  803918:	68 e4 56 80 00       	push   $0x8056e4
  80391d:	68 93 00 00 00       	push   $0x93
  803922:	68 3b 56 80 00       	push   $0x80563b
  803927:	e8 fe df ff ff       	call   80192a <_panic>
  80392c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392f:	8b 00                	mov    (%eax),%eax
  803931:	85 c0                	test   %eax,%eax
  803933:	74 10                	je     803945 <alloc_block_FF+0x67>
  803935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803938:	8b 00                	mov    (%eax),%eax
  80393a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80393d:	8b 52 04             	mov    0x4(%edx),%edx
  803940:	89 50 04             	mov    %edx,0x4(%eax)
  803943:	eb 0b                	jmp    803950 <alloc_block_FF+0x72>
  803945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803948:	8b 40 04             	mov    0x4(%eax),%eax
  80394b:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803953:	8b 40 04             	mov    0x4(%eax),%eax
  803956:	85 c0                	test   %eax,%eax
  803958:	74 0f                	je     803969 <alloc_block_FF+0x8b>
  80395a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395d:	8b 40 04             	mov    0x4(%eax),%eax
  803960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803963:	8b 12                	mov    (%edx),%edx
  803965:	89 10                	mov    %edx,(%eax)
  803967:	eb 0a                	jmp    803973 <alloc_block_FF+0x95>
  803969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396c:	8b 00                	mov    (%eax),%eax
  80396e:	a3 38 61 80 00       	mov    %eax,0x806138
  803973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803976:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80397c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803986:	a1 44 61 80 00       	mov    0x806144,%eax
  80398b:	48                   	dec    %eax
  80398c:	a3 44 61 80 00       	mov    %eax,0x806144
			   return  point;
  803991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803994:	e9 10 01 00 00       	jmp    803aa9 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  803999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399c:	8b 40 0c             	mov    0xc(%eax),%eax
  80399f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039a2:	0f 86 c6 00 00 00    	jbe    803a6e <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8039a8:	a1 48 61 80 00       	mov    0x806148,%eax
  8039ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8039b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b3:	8b 50 08             	mov    0x8(%eax),%edx
  8039b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b9:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8039bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8039c2:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8039c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039c9:	75 17                	jne    8039e2 <alloc_block_FF+0x104>
  8039cb:	83 ec 04             	sub    $0x4,%esp
  8039ce:	68 e4 56 80 00       	push   $0x8056e4
  8039d3:	68 9b 00 00 00       	push   $0x9b
  8039d8:	68 3b 56 80 00       	push   $0x80563b
  8039dd:	e8 48 df ff ff       	call   80192a <_panic>
  8039e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e5:	8b 00                	mov    (%eax),%eax
  8039e7:	85 c0                	test   %eax,%eax
  8039e9:	74 10                	je     8039fb <alloc_block_FF+0x11d>
  8039eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ee:	8b 00                	mov    (%eax),%eax
  8039f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039f3:	8b 52 04             	mov    0x4(%edx),%edx
  8039f6:	89 50 04             	mov    %edx,0x4(%eax)
  8039f9:	eb 0b                	jmp    803a06 <alloc_block_FF+0x128>
  8039fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039fe:	8b 40 04             	mov    0x4(%eax),%eax
  803a01:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a09:	8b 40 04             	mov    0x4(%eax),%eax
  803a0c:	85 c0                	test   %eax,%eax
  803a0e:	74 0f                	je     803a1f <alloc_block_FF+0x141>
  803a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a13:	8b 40 04             	mov    0x4(%eax),%eax
  803a16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a19:	8b 12                	mov    (%edx),%edx
  803a1b:	89 10                	mov    %edx,(%eax)
  803a1d:	eb 0a                	jmp    803a29 <alloc_block_FF+0x14b>
  803a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a22:	8b 00                	mov    (%eax),%eax
  803a24:	a3 48 61 80 00       	mov    %eax,0x806148
  803a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a3c:	a1 54 61 80 00       	mov    0x806154,%eax
  803a41:	48                   	dec    %eax
  803a42:	a3 54 61 80 00       	mov    %eax,0x806154
			   point->sva += size;
  803a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4a:	8b 50 08             	mov    0x8(%eax),%edx
  803a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a50:	01 c2                	add    %eax,%edx
  803a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a55:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  803a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5b:	8b 40 0c             	mov    0xc(%eax),%eax
  803a5e:	2b 45 08             	sub    0x8(%ebp),%eax
  803a61:	89 c2                	mov    %eax,%edx
  803a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a66:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  803a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6c:	eb 3b                	jmp    803aa9 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803a6e:	a1 40 61 80 00       	mov    0x806140,%eax
  803a73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a7a:	74 07                	je     803a83 <alloc_block_FF+0x1a5>
  803a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7f:	8b 00                	mov    (%eax),%eax
  803a81:	eb 05                	jmp    803a88 <alloc_block_FF+0x1aa>
  803a83:	b8 00 00 00 00       	mov    $0x0,%eax
  803a88:	a3 40 61 80 00       	mov    %eax,0x806140
  803a8d:	a1 40 61 80 00       	mov    0x806140,%eax
  803a92:	85 c0                	test   %eax,%eax
  803a94:	0f 85 57 fe ff ff    	jne    8038f1 <alloc_block_FF+0x13>
  803a9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a9e:	0f 85 4d fe ff ff    	jne    8038f1 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  803aa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803aa9:	c9                   	leave  
  803aaa:	c3                   	ret    

00803aab <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803aab:	55                   	push   %ebp
  803aac:	89 e5                	mov    %esp,%ebp
  803aae:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  803ab1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803ab8:	a1 38 61 80 00       	mov    0x806138,%eax
  803abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ac0:	e9 df 00 00 00       	jmp    803ba4 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  803ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac8:	8b 40 0c             	mov    0xc(%eax),%eax
  803acb:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ace:	0f 82 c8 00 00 00    	jb     803b9c <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  803ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad7:	8b 40 0c             	mov    0xc(%eax),%eax
  803ada:	3b 45 08             	cmp    0x8(%ebp),%eax
  803add:	0f 85 8a 00 00 00    	jne    803b6d <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  803ae3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ae7:	75 17                	jne    803b00 <alloc_block_BF+0x55>
  803ae9:	83 ec 04             	sub    $0x4,%esp
  803aec:	68 e4 56 80 00       	push   $0x8056e4
  803af1:	68 b7 00 00 00       	push   $0xb7
  803af6:	68 3b 56 80 00       	push   $0x80563b
  803afb:	e8 2a de ff ff       	call   80192a <_panic>
  803b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b03:	8b 00                	mov    (%eax),%eax
  803b05:	85 c0                	test   %eax,%eax
  803b07:	74 10                	je     803b19 <alloc_block_BF+0x6e>
  803b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0c:	8b 00                	mov    (%eax),%eax
  803b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b11:	8b 52 04             	mov    0x4(%edx),%edx
  803b14:	89 50 04             	mov    %edx,0x4(%eax)
  803b17:	eb 0b                	jmp    803b24 <alloc_block_BF+0x79>
  803b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1c:	8b 40 04             	mov    0x4(%eax),%eax
  803b1f:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b27:	8b 40 04             	mov    0x4(%eax),%eax
  803b2a:	85 c0                	test   %eax,%eax
  803b2c:	74 0f                	je     803b3d <alloc_block_BF+0x92>
  803b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b31:	8b 40 04             	mov    0x4(%eax),%eax
  803b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b37:	8b 12                	mov    (%edx),%edx
  803b39:	89 10                	mov    %edx,(%eax)
  803b3b:	eb 0a                	jmp    803b47 <alloc_block_BF+0x9c>
  803b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b40:	8b 00                	mov    (%eax),%eax
  803b42:	a3 38 61 80 00       	mov    %eax,0x806138
  803b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b5a:	a1 44 61 80 00       	mov    0x806144,%eax
  803b5f:	48                   	dec    %eax
  803b60:	a3 44 61 80 00       	mov    %eax,0x806144
			   return currentMemBlock;
  803b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b68:	e9 4d 01 00 00       	jmp    803cba <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  803b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b70:	8b 40 0c             	mov    0xc(%eax),%eax
  803b73:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b76:	76 24                	jbe    803b9c <alloc_block_BF+0xf1>
  803b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b7b:	8b 40 0c             	mov    0xc(%eax),%eax
  803b7e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803b81:	73 19                	jae    803b9c <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  803b83:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  803b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b8d:	8b 40 0c             	mov    0xc(%eax),%eax
  803b90:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  803b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b96:	8b 40 08             	mov    0x8(%eax),%eax
  803b99:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803b9c:	a1 40 61 80 00       	mov    0x806140,%eax
  803ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ba4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ba8:	74 07                	je     803bb1 <alloc_block_BF+0x106>
  803baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bad:	8b 00                	mov    (%eax),%eax
  803baf:	eb 05                	jmp    803bb6 <alloc_block_BF+0x10b>
  803bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb6:	a3 40 61 80 00       	mov    %eax,0x806140
  803bbb:	a1 40 61 80 00       	mov    0x806140,%eax
  803bc0:	85 c0                	test   %eax,%eax
  803bc2:	0f 85 fd fe ff ff    	jne    803ac5 <alloc_block_BF+0x1a>
  803bc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bcc:	0f 85 f3 fe ff ff    	jne    803ac5 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  803bd2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bd6:	0f 84 d9 00 00 00    	je     803cb5 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  803bdc:	a1 48 61 80 00       	mov    0x806148,%eax
  803be1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803be4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803be7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bea:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803bed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf0:	8b 55 08             	mov    0x8(%ebp),%edx
  803bf3:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803bf6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bfa:	75 17                	jne    803c13 <alloc_block_BF+0x168>
  803bfc:	83 ec 04             	sub    $0x4,%esp
  803bff:	68 e4 56 80 00       	push   $0x8056e4
  803c04:	68 c7 00 00 00       	push   $0xc7
  803c09:	68 3b 56 80 00       	push   $0x80563b
  803c0e:	e8 17 dd ff ff       	call   80192a <_panic>
  803c13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c16:	8b 00                	mov    (%eax),%eax
  803c18:	85 c0                	test   %eax,%eax
  803c1a:	74 10                	je     803c2c <alloc_block_BF+0x181>
  803c1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c1f:	8b 00                	mov    (%eax),%eax
  803c21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c24:	8b 52 04             	mov    0x4(%edx),%edx
  803c27:	89 50 04             	mov    %edx,0x4(%eax)
  803c2a:	eb 0b                	jmp    803c37 <alloc_block_BF+0x18c>
  803c2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2f:	8b 40 04             	mov    0x4(%eax),%eax
  803c32:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803c37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3a:	8b 40 04             	mov    0x4(%eax),%eax
  803c3d:	85 c0                	test   %eax,%eax
  803c3f:	74 0f                	je     803c50 <alloc_block_BF+0x1a5>
  803c41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c44:	8b 40 04             	mov    0x4(%eax),%eax
  803c47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c4a:	8b 12                	mov    (%edx),%edx
  803c4c:	89 10                	mov    %edx,(%eax)
  803c4e:	eb 0a                	jmp    803c5a <alloc_block_BF+0x1af>
  803c50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c53:	8b 00                	mov    (%eax),%eax
  803c55:	a3 48 61 80 00       	mov    %eax,0x806148
  803c5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c6d:	a1 54 61 80 00       	mov    0x806154,%eax
  803c72:	48                   	dec    %eax
  803c73:	a3 54 61 80 00       	mov    %eax,0x806154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803c78:	83 ec 08             	sub    $0x8,%esp
  803c7b:	ff 75 ec             	pushl  -0x14(%ebp)
  803c7e:	68 38 61 80 00       	push   $0x806138
  803c83:	e8 71 f9 ff ff       	call   8035f9 <find_block>
  803c88:	83 c4 10             	add    $0x10,%esp
  803c8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803c8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c91:	8b 50 08             	mov    0x8(%eax),%edx
  803c94:	8b 45 08             	mov    0x8(%ebp),%eax
  803c97:	01 c2                	add    %eax,%edx
  803c99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c9c:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803c9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ca2:	8b 40 0c             	mov    0xc(%eax),%eax
  803ca5:	2b 45 08             	sub    0x8(%ebp),%eax
  803ca8:	89 c2                	mov    %eax,%edx
  803caa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cad:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803cb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cb3:	eb 05                	jmp    803cba <alloc_block_BF+0x20f>
	}
	return NULL;
  803cb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cba:	c9                   	leave  
  803cbb:	c3                   	ret    

00803cbc <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803cbc:	55                   	push   %ebp
  803cbd:	89 e5                	mov    %esp,%ebp
  803cbf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803cc2:	a1 28 60 80 00       	mov    0x806028,%eax
  803cc7:	85 c0                	test   %eax,%eax
  803cc9:	0f 85 de 01 00 00    	jne    803ead <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803ccf:	a1 38 61 80 00       	mov    0x806138,%eax
  803cd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cd7:	e9 9e 01 00 00       	jmp    803e7a <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cdf:	8b 40 0c             	mov    0xc(%eax),%eax
  803ce2:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ce5:	0f 82 87 01 00 00    	jb     803e72 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cee:	8b 40 0c             	mov    0xc(%eax),%eax
  803cf1:	3b 45 08             	cmp    0x8(%ebp),%eax
  803cf4:	0f 85 95 00 00 00    	jne    803d8f <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803cfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cfe:	75 17                	jne    803d17 <alloc_block_NF+0x5b>
  803d00:	83 ec 04             	sub    $0x4,%esp
  803d03:	68 e4 56 80 00       	push   $0x8056e4
  803d08:	68 e0 00 00 00       	push   $0xe0
  803d0d:	68 3b 56 80 00       	push   $0x80563b
  803d12:	e8 13 dc ff ff       	call   80192a <_panic>
  803d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1a:	8b 00                	mov    (%eax),%eax
  803d1c:	85 c0                	test   %eax,%eax
  803d1e:	74 10                	je     803d30 <alloc_block_NF+0x74>
  803d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d23:	8b 00                	mov    (%eax),%eax
  803d25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d28:	8b 52 04             	mov    0x4(%edx),%edx
  803d2b:	89 50 04             	mov    %edx,0x4(%eax)
  803d2e:	eb 0b                	jmp    803d3b <alloc_block_NF+0x7f>
  803d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d33:	8b 40 04             	mov    0x4(%eax),%eax
  803d36:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3e:	8b 40 04             	mov    0x4(%eax),%eax
  803d41:	85 c0                	test   %eax,%eax
  803d43:	74 0f                	je     803d54 <alloc_block_NF+0x98>
  803d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d48:	8b 40 04             	mov    0x4(%eax),%eax
  803d4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d4e:	8b 12                	mov    (%edx),%edx
  803d50:	89 10                	mov    %edx,(%eax)
  803d52:	eb 0a                	jmp    803d5e <alloc_block_NF+0xa2>
  803d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d57:	8b 00                	mov    (%eax),%eax
  803d59:	a3 38 61 80 00       	mov    %eax,0x806138
  803d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d71:	a1 44 61 80 00       	mov    0x806144,%eax
  803d76:	48                   	dec    %eax
  803d77:	a3 44 61 80 00       	mov    %eax,0x806144
				   svaOfNF = point->sva;
  803d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d7f:	8b 40 08             	mov    0x8(%eax),%eax
  803d82:	a3 28 60 80 00       	mov    %eax,0x806028
				   return  point;
  803d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d8a:	e9 f8 04 00 00       	jmp    804287 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d92:	8b 40 0c             	mov    0xc(%eax),%eax
  803d95:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d98:	0f 86 d4 00 00 00    	jbe    803e72 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803d9e:	a1 48 61 80 00       	mov    0x806148,%eax
  803da3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da9:	8b 50 08             	mov    0x8(%eax),%edx
  803dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803daf:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db5:	8b 55 08             	mov    0x8(%ebp),%edx
  803db8:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803dbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803dbf:	75 17                	jne    803dd8 <alloc_block_NF+0x11c>
  803dc1:	83 ec 04             	sub    $0x4,%esp
  803dc4:	68 e4 56 80 00       	push   $0x8056e4
  803dc9:	68 e9 00 00 00       	push   $0xe9
  803dce:	68 3b 56 80 00       	push   $0x80563b
  803dd3:	e8 52 db ff ff       	call   80192a <_panic>
  803dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ddb:	8b 00                	mov    (%eax),%eax
  803ddd:	85 c0                	test   %eax,%eax
  803ddf:	74 10                	je     803df1 <alloc_block_NF+0x135>
  803de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de4:	8b 00                	mov    (%eax),%eax
  803de6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803de9:	8b 52 04             	mov    0x4(%edx),%edx
  803dec:	89 50 04             	mov    %edx,0x4(%eax)
  803def:	eb 0b                	jmp    803dfc <alloc_block_NF+0x140>
  803df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803df4:	8b 40 04             	mov    0x4(%eax),%eax
  803df7:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dff:	8b 40 04             	mov    0x4(%eax),%eax
  803e02:	85 c0                	test   %eax,%eax
  803e04:	74 0f                	je     803e15 <alloc_block_NF+0x159>
  803e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e09:	8b 40 04             	mov    0x4(%eax),%eax
  803e0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e0f:	8b 12                	mov    (%edx),%edx
  803e11:	89 10                	mov    %edx,(%eax)
  803e13:	eb 0a                	jmp    803e1f <alloc_block_NF+0x163>
  803e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e18:	8b 00                	mov    (%eax),%eax
  803e1a:	a3 48 61 80 00       	mov    %eax,0x806148
  803e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e32:	a1 54 61 80 00       	mov    0x806154,%eax
  803e37:	48                   	dec    %eax
  803e38:	a3 54 61 80 00       	mov    %eax,0x806154
				   svaOfNF = ReturnedBlock->sva;
  803e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e40:	8b 40 08             	mov    0x8(%eax),%eax
  803e43:	a3 28 60 80 00       	mov    %eax,0x806028
				   point->sva += size;
  803e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e4b:	8b 50 08             	mov    0x8(%eax),%edx
  803e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e51:	01 c2                	add    %eax,%edx
  803e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e56:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5c:	8b 40 0c             	mov    0xc(%eax),%eax
  803e5f:	2b 45 08             	sub    0x8(%ebp),%eax
  803e62:	89 c2                	mov    %eax,%edx
  803e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e67:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e6d:	e9 15 04 00 00       	jmp    804287 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803e72:	a1 40 61 80 00       	mov    0x806140,%eax
  803e77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e7e:	74 07                	je     803e87 <alloc_block_NF+0x1cb>
  803e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e83:	8b 00                	mov    (%eax),%eax
  803e85:	eb 05                	jmp    803e8c <alloc_block_NF+0x1d0>
  803e87:	b8 00 00 00 00       	mov    $0x0,%eax
  803e8c:	a3 40 61 80 00       	mov    %eax,0x806140
  803e91:	a1 40 61 80 00       	mov    0x806140,%eax
  803e96:	85 c0                	test   %eax,%eax
  803e98:	0f 85 3e fe ff ff    	jne    803cdc <alloc_block_NF+0x20>
  803e9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ea2:	0f 85 34 fe ff ff    	jne    803cdc <alloc_block_NF+0x20>
  803ea8:	e9 d5 03 00 00       	jmp    804282 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803ead:	a1 38 61 80 00       	mov    0x806138,%eax
  803eb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803eb5:	e9 b1 01 00 00       	jmp    80406b <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ebd:	8b 50 08             	mov    0x8(%eax),%edx
  803ec0:	a1 28 60 80 00       	mov    0x806028,%eax
  803ec5:	39 c2                	cmp    %eax,%edx
  803ec7:	0f 82 96 01 00 00    	jb     804063 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed0:	8b 40 0c             	mov    0xc(%eax),%eax
  803ed3:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ed6:	0f 82 87 01 00 00    	jb     804063 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803edf:	8b 40 0c             	mov    0xc(%eax),%eax
  803ee2:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ee5:	0f 85 95 00 00 00    	jne    803f80 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803eeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eef:	75 17                	jne    803f08 <alloc_block_NF+0x24c>
  803ef1:	83 ec 04             	sub    $0x4,%esp
  803ef4:	68 e4 56 80 00       	push   $0x8056e4
  803ef9:	68 fc 00 00 00       	push   $0xfc
  803efe:	68 3b 56 80 00       	push   $0x80563b
  803f03:	e8 22 da ff ff       	call   80192a <_panic>
  803f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f0b:	8b 00                	mov    (%eax),%eax
  803f0d:	85 c0                	test   %eax,%eax
  803f0f:	74 10                	je     803f21 <alloc_block_NF+0x265>
  803f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f14:	8b 00                	mov    (%eax),%eax
  803f16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f19:	8b 52 04             	mov    0x4(%edx),%edx
  803f1c:	89 50 04             	mov    %edx,0x4(%eax)
  803f1f:	eb 0b                	jmp    803f2c <alloc_block_NF+0x270>
  803f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f24:	8b 40 04             	mov    0x4(%eax),%eax
  803f27:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f2f:	8b 40 04             	mov    0x4(%eax),%eax
  803f32:	85 c0                	test   %eax,%eax
  803f34:	74 0f                	je     803f45 <alloc_block_NF+0x289>
  803f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f39:	8b 40 04             	mov    0x4(%eax),%eax
  803f3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f3f:	8b 12                	mov    (%edx),%edx
  803f41:	89 10                	mov    %edx,(%eax)
  803f43:	eb 0a                	jmp    803f4f <alloc_block_NF+0x293>
  803f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f48:	8b 00                	mov    (%eax),%eax
  803f4a:	a3 38 61 80 00       	mov    %eax,0x806138
  803f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f62:	a1 44 61 80 00       	mov    0x806144,%eax
  803f67:	48                   	dec    %eax
  803f68:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f70:	8b 40 08             	mov    0x8(%eax),%eax
  803f73:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7b:	e9 07 03 00 00       	jmp    804287 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f83:	8b 40 0c             	mov    0xc(%eax),%eax
  803f86:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f89:	0f 86 d4 00 00 00    	jbe    804063 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803f8f:	a1 48 61 80 00       	mov    0x806148,%eax
  803f94:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f9a:	8b 50 08             	mov    0x8(%eax),%edx
  803f9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fa0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803fa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  803fa9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803fac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803fb0:	75 17                	jne    803fc9 <alloc_block_NF+0x30d>
  803fb2:	83 ec 04             	sub    $0x4,%esp
  803fb5:	68 e4 56 80 00       	push   $0x8056e4
  803fba:	68 04 01 00 00       	push   $0x104
  803fbf:	68 3b 56 80 00       	push   $0x80563b
  803fc4:	e8 61 d9 ff ff       	call   80192a <_panic>
  803fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fcc:	8b 00                	mov    (%eax),%eax
  803fce:	85 c0                	test   %eax,%eax
  803fd0:	74 10                	je     803fe2 <alloc_block_NF+0x326>
  803fd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fd5:	8b 00                	mov    (%eax),%eax
  803fd7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fda:	8b 52 04             	mov    0x4(%edx),%edx
  803fdd:	89 50 04             	mov    %edx,0x4(%eax)
  803fe0:	eb 0b                	jmp    803fed <alloc_block_NF+0x331>
  803fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fe5:	8b 40 04             	mov    0x4(%eax),%eax
  803fe8:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ff0:	8b 40 04             	mov    0x4(%eax),%eax
  803ff3:	85 c0                	test   %eax,%eax
  803ff5:	74 0f                	je     804006 <alloc_block_NF+0x34a>
  803ff7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ffa:	8b 40 04             	mov    0x4(%eax),%eax
  803ffd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804000:	8b 12                	mov    (%edx),%edx
  804002:	89 10                	mov    %edx,(%eax)
  804004:	eb 0a                	jmp    804010 <alloc_block_NF+0x354>
  804006:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804009:	8b 00                	mov    (%eax),%eax
  80400b:	a3 48 61 80 00       	mov    %eax,0x806148
  804010:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804013:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804019:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80401c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804023:	a1 54 61 80 00       	mov    0x806154,%eax
  804028:	48                   	dec    %eax
  804029:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  80402e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804031:	8b 40 08             	mov    0x8(%eax),%eax
  804034:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  804039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80403c:	8b 50 08             	mov    0x8(%eax),%edx
  80403f:	8b 45 08             	mov    0x8(%ebp),%eax
  804042:	01 c2                	add    %eax,%edx
  804044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804047:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80404a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80404d:	8b 40 0c             	mov    0xc(%eax),%eax
  804050:	2b 45 08             	sub    0x8(%ebp),%eax
  804053:	89 c2                	mov    %eax,%edx
  804055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804058:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80405b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80405e:	e9 24 02 00 00       	jmp    804287 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  804063:	a1 40 61 80 00       	mov    0x806140,%eax
  804068:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80406b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80406f:	74 07                	je     804078 <alloc_block_NF+0x3bc>
  804071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804074:	8b 00                	mov    (%eax),%eax
  804076:	eb 05                	jmp    80407d <alloc_block_NF+0x3c1>
  804078:	b8 00 00 00 00       	mov    $0x0,%eax
  80407d:	a3 40 61 80 00       	mov    %eax,0x806140
  804082:	a1 40 61 80 00       	mov    0x806140,%eax
  804087:	85 c0                	test   %eax,%eax
  804089:	0f 85 2b fe ff ff    	jne    803eba <alloc_block_NF+0x1fe>
  80408f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804093:	0f 85 21 fe ff ff    	jne    803eba <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  804099:	a1 38 61 80 00       	mov    0x806138,%eax
  80409e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8040a1:	e9 ae 01 00 00       	jmp    804254 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8040a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040a9:	8b 50 08             	mov    0x8(%eax),%edx
  8040ac:	a1 28 60 80 00       	mov    0x806028,%eax
  8040b1:	39 c2                	cmp    %eax,%edx
  8040b3:	0f 83 93 01 00 00    	jae    80424c <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8040b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8040bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8040c2:	0f 82 84 01 00 00    	jb     80424c <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8040c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8040ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8040d1:	0f 85 95 00 00 00    	jne    80416c <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8040d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040db:	75 17                	jne    8040f4 <alloc_block_NF+0x438>
  8040dd:	83 ec 04             	sub    $0x4,%esp
  8040e0:	68 e4 56 80 00       	push   $0x8056e4
  8040e5:	68 14 01 00 00       	push   $0x114
  8040ea:	68 3b 56 80 00       	push   $0x80563b
  8040ef:	e8 36 d8 ff ff       	call   80192a <_panic>
  8040f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040f7:	8b 00                	mov    (%eax),%eax
  8040f9:	85 c0                	test   %eax,%eax
  8040fb:	74 10                	je     80410d <alloc_block_NF+0x451>
  8040fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804100:	8b 00                	mov    (%eax),%eax
  804102:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804105:	8b 52 04             	mov    0x4(%edx),%edx
  804108:	89 50 04             	mov    %edx,0x4(%eax)
  80410b:	eb 0b                	jmp    804118 <alloc_block_NF+0x45c>
  80410d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804110:	8b 40 04             	mov    0x4(%eax),%eax
  804113:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80411b:	8b 40 04             	mov    0x4(%eax),%eax
  80411e:	85 c0                	test   %eax,%eax
  804120:	74 0f                	je     804131 <alloc_block_NF+0x475>
  804122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804125:	8b 40 04             	mov    0x4(%eax),%eax
  804128:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80412b:	8b 12                	mov    (%edx),%edx
  80412d:	89 10                	mov    %edx,(%eax)
  80412f:	eb 0a                	jmp    80413b <alloc_block_NF+0x47f>
  804131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804134:	8b 00                	mov    (%eax),%eax
  804136:	a3 38 61 80 00       	mov    %eax,0x806138
  80413b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80413e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804147:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80414e:	a1 44 61 80 00       	mov    0x806144,%eax
  804153:	48                   	dec    %eax
  804154:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  804159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80415c:	8b 40 08             	mov    0x8(%eax),%eax
  80415f:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  804164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804167:	e9 1b 01 00 00       	jmp    804287 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80416c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80416f:	8b 40 0c             	mov    0xc(%eax),%eax
  804172:	3b 45 08             	cmp    0x8(%ebp),%eax
  804175:	0f 86 d1 00 00 00    	jbe    80424c <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80417b:	a1 48 61 80 00       	mov    0x806148,%eax
  804180:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  804183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804186:	8b 50 08             	mov    0x8(%eax),%edx
  804189:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80418c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80418f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804192:	8b 55 08             	mov    0x8(%ebp),%edx
  804195:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  804198:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80419c:	75 17                	jne    8041b5 <alloc_block_NF+0x4f9>
  80419e:	83 ec 04             	sub    $0x4,%esp
  8041a1:	68 e4 56 80 00       	push   $0x8056e4
  8041a6:	68 1c 01 00 00       	push   $0x11c
  8041ab:	68 3b 56 80 00       	push   $0x80563b
  8041b0:	e8 75 d7 ff ff       	call   80192a <_panic>
  8041b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041b8:	8b 00                	mov    (%eax),%eax
  8041ba:	85 c0                	test   %eax,%eax
  8041bc:	74 10                	je     8041ce <alloc_block_NF+0x512>
  8041be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041c1:	8b 00                	mov    (%eax),%eax
  8041c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8041c6:	8b 52 04             	mov    0x4(%edx),%edx
  8041c9:	89 50 04             	mov    %edx,0x4(%eax)
  8041cc:	eb 0b                	jmp    8041d9 <alloc_block_NF+0x51d>
  8041ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041d1:	8b 40 04             	mov    0x4(%eax),%eax
  8041d4:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8041d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041dc:	8b 40 04             	mov    0x4(%eax),%eax
  8041df:	85 c0                	test   %eax,%eax
  8041e1:	74 0f                	je     8041f2 <alloc_block_NF+0x536>
  8041e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041e6:	8b 40 04             	mov    0x4(%eax),%eax
  8041e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8041ec:	8b 12                	mov    (%edx),%edx
  8041ee:	89 10                	mov    %edx,(%eax)
  8041f0:	eb 0a                	jmp    8041fc <alloc_block_NF+0x540>
  8041f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041f5:	8b 00                	mov    (%eax),%eax
  8041f7:	a3 48 61 80 00       	mov    %eax,0x806148
  8041fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804205:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804208:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80420f:	a1 54 61 80 00       	mov    0x806154,%eax
  804214:	48                   	dec    %eax
  804215:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  80421a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80421d:	8b 40 08             	mov    0x8(%eax),%eax
  804220:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  804225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804228:	8b 50 08             	mov    0x8(%eax),%edx
  80422b:	8b 45 08             	mov    0x8(%ebp),%eax
  80422e:	01 c2                	add    %eax,%edx
  804230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804233:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  804236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804239:	8b 40 0c             	mov    0xc(%eax),%eax
  80423c:	2b 45 08             	sub    0x8(%ebp),%eax
  80423f:	89 c2                	mov    %eax,%edx
  804241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804244:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  804247:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80424a:	eb 3b                	jmp    804287 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80424c:	a1 40 61 80 00       	mov    0x806140,%eax
  804251:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804254:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804258:	74 07                	je     804261 <alloc_block_NF+0x5a5>
  80425a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80425d:	8b 00                	mov    (%eax),%eax
  80425f:	eb 05                	jmp    804266 <alloc_block_NF+0x5aa>
  804261:	b8 00 00 00 00       	mov    $0x0,%eax
  804266:	a3 40 61 80 00       	mov    %eax,0x806140
  80426b:	a1 40 61 80 00       	mov    0x806140,%eax
  804270:	85 c0                	test   %eax,%eax
  804272:	0f 85 2e fe ff ff    	jne    8040a6 <alloc_block_NF+0x3ea>
  804278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80427c:	0f 85 24 fe ff ff    	jne    8040a6 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  804282:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804287:	c9                   	leave  
  804288:	c3                   	ret    

00804289 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  804289:	55                   	push   %ebp
  80428a:	89 e5                	mov    %esp,%ebp
  80428c:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80428f:	a1 38 61 80 00       	mov    0x806138,%eax
  804294:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  804297:	a1 3c 61 80 00       	mov    0x80613c,%eax
  80429c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80429f:	a1 38 61 80 00       	mov    0x806138,%eax
  8042a4:	85 c0                	test   %eax,%eax
  8042a6:	74 14                	je     8042bc <insert_sorted_with_merge_freeList+0x33>
  8042a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8042ab:	8b 50 08             	mov    0x8(%eax),%edx
  8042ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042b1:	8b 40 08             	mov    0x8(%eax),%eax
  8042b4:	39 c2                	cmp    %eax,%edx
  8042b6:	0f 87 9b 01 00 00    	ja     804457 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8042bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042c0:	75 17                	jne    8042d9 <insert_sorted_with_merge_freeList+0x50>
  8042c2:	83 ec 04             	sub    $0x4,%esp
  8042c5:	68 18 56 80 00       	push   $0x805618
  8042ca:	68 38 01 00 00       	push   $0x138
  8042cf:	68 3b 56 80 00       	push   $0x80563b
  8042d4:	e8 51 d6 ff ff       	call   80192a <_panic>
  8042d9:	8b 15 38 61 80 00    	mov    0x806138,%edx
  8042df:	8b 45 08             	mov    0x8(%ebp),%eax
  8042e2:	89 10                	mov    %edx,(%eax)
  8042e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8042e7:	8b 00                	mov    (%eax),%eax
  8042e9:	85 c0                	test   %eax,%eax
  8042eb:	74 0d                	je     8042fa <insert_sorted_with_merge_freeList+0x71>
  8042ed:	a1 38 61 80 00       	mov    0x806138,%eax
  8042f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8042f5:	89 50 04             	mov    %edx,0x4(%eax)
  8042f8:	eb 08                	jmp    804302 <insert_sorted_with_merge_freeList+0x79>
  8042fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8042fd:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804302:	8b 45 08             	mov    0x8(%ebp),%eax
  804305:	a3 38 61 80 00       	mov    %eax,0x806138
  80430a:	8b 45 08             	mov    0x8(%ebp),%eax
  80430d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804314:	a1 44 61 80 00       	mov    0x806144,%eax
  804319:	40                   	inc    %eax
  80431a:	a3 44 61 80 00       	mov    %eax,0x806144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80431f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804323:	0f 84 a8 06 00 00    	je     8049d1 <insert_sorted_with_merge_freeList+0x748>
  804329:	8b 45 08             	mov    0x8(%ebp),%eax
  80432c:	8b 50 08             	mov    0x8(%eax),%edx
  80432f:	8b 45 08             	mov    0x8(%ebp),%eax
  804332:	8b 40 0c             	mov    0xc(%eax),%eax
  804335:	01 c2                	add    %eax,%edx
  804337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80433a:	8b 40 08             	mov    0x8(%eax),%eax
  80433d:	39 c2                	cmp    %eax,%edx
  80433f:	0f 85 8c 06 00 00    	jne    8049d1 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  804345:	8b 45 08             	mov    0x8(%ebp),%eax
  804348:	8b 50 0c             	mov    0xc(%eax),%edx
  80434b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80434e:	8b 40 0c             	mov    0xc(%eax),%eax
  804351:	01 c2                	add    %eax,%edx
  804353:	8b 45 08             	mov    0x8(%ebp),%eax
  804356:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  804359:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80435d:	75 17                	jne    804376 <insert_sorted_with_merge_freeList+0xed>
  80435f:	83 ec 04             	sub    $0x4,%esp
  804362:	68 e4 56 80 00       	push   $0x8056e4
  804367:	68 3c 01 00 00       	push   $0x13c
  80436c:	68 3b 56 80 00       	push   $0x80563b
  804371:	e8 b4 d5 ff ff       	call   80192a <_panic>
  804376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804379:	8b 00                	mov    (%eax),%eax
  80437b:	85 c0                	test   %eax,%eax
  80437d:	74 10                	je     80438f <insert_sorted_with_merge_freeList+0x106>
  80437f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804382:	8b 00                	mov    (%eax),%eax
  804384:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804387:	8b 52 04             	mov    0x4(%edx),%edx
  80438a:	89 50 04             	mov    %edx,0x4(%eax)
  80438d:	eb 0b                	jmp    80439a <insert_sorted_with_merge_freeList+0x111>
  80438f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804392:	8b 40 04             	mov    0x4(%eax),%eax
  804395:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80439a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80439d:	8b 40 04             	mov    0x4(%eax),%eax
  8043a0:	85 c0                	test   %eax,%eax
  8043a2:	74 0f                	je     8043b3 <insert_sorted_with_merge_freeList+0x12a>
  8043a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043a7:	8b 40 04             	mov    0x4(%eax),%eax
  8043aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043ad:	8b 12                	mov    (%edx),%edx
  8043af:	89 10                	mov    %edx,(%eax)
  8043b1:	eb 0a                	jmp    8043bd <insert_sorted_with_merge_freeList+0x134>
  8043b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043b6:	8b 00                	mov    (%eax),%eax
  8043b8:	a3 38 61 80 00       	mov    %eax,0x806138
  8043bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043d0:	a1 44 61 80 00       	mov    0x806144,%eax
  8043d5:	48                   	dec    %eax
  8043d6:	a3 44 61 80 00       	mov    %eax,0x806144
			head->size = 0;
  8043db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043de:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8043e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8043ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8043f3:	75 17                	jne    80440c <insert_sorted_with_merge_freeList+0x183>
  8043f5:	83 ec 04             	sub    $0x4,%esp
  8043f8:	68 18 56 80 00       	push   $0x805618
  8043fd:	68 3f 01 00 00       	push   $0x13f
  804402:	68 3b 56 80 00       	push   $0x80563b
  804407:	e8 1e d5 ff ff       	call   80192a <_panic>
  80440c:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804412:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804415:	89 10                	mov    %edx,(%eax)
  804417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80441a:	8b 00                	mov    (%eax),%eax
  80441c:	85 c0                	test   %eax,%eax
  80441e:	74 0d                	je     80442d <insert_sorted_with_merge_freeList+0x1a4>
  804420:	a1 48 61 80 00       	mov    0x806148,%eax
  804425:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804428:	89 50 04             	mov    %edx,0x4(%eax)
  80442b:	eb 08                	jmp    804435 <insert_sorted_with_merge_freeList+0x1ac>
  80442d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804430:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804438:	a3 48 61 80 00       	mov    %eax,0x806148
  80443d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804440:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804447:	a1 54 61 80 00       	mov    0x806154,%eax
  80444c:	40                   	inc    %eax
  80444d:	a3 54 61 80 00       	mov    %eax,0x806154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  804452:	e9 7a 05 00 00       	jmp    8049d1 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  804457:	8b 45 08             	mov    0x8(%ebp),%eax
  80445a:	8b 50 08             	mov    0x8(%eax),%edx
  80445d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804460:	8b 40 08             	mov    0x8(%eax),%eax
  804463:	39 c2                	cmp    %eax,%edx
  804465:	0f 82 14 01 00 00    	jb     80457f <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80446b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80446e:	8b 50 08             	mov    0x8(%eax),%edx
  804471:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804474:	8b 40 0c             	mov    0xc(%eax),%eax
  804477:	01 c2                	add    %eax,%edx
  804479:	8b 45 08             	mov    0x8(%ebp),%eax
  80447c:	8b 40 08             	mov    0x8(%eax),%eax
  80447f:	39 c2                	cmp    %eax,%edx
  804481:	0f 85 90 00 00 00    	jne    804517 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  804487:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80448a:	8b 50 0c             	mov    0xc(%eax),%edx
  80448d:	8b 45 08             	mov    0x8(%ebp),%eax
  804490:	8b 40 0c             	mov    0xc(%eax),%eax
  804493:	01 c2                	add    %eax,%edx
  804495:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804498:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80449b:	8b 45 08             	mov    0x8(%ebp),%eax
  80449e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8044a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8044a8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8044af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8044b3:	75 17                	jne    8044cc <insert_sorted_with_merge_freeList+0x243>
  8044b5:	83 ec 04             	sub    $0x4,%esp
  8044b8:	68 18 56 80 00       	push   $0x805618
  8044bd:	68 49 01 00 00       	push   $0x149
  8044c2:	68 3b 56 80 00       	push   $0x80563b
  8044c7:	e8 5e d4 ff ff       	call   80192a <_panic>
  8044cc:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8044d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8044d5:	89 10                	mov    %edx,(%eax)
  8044d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8044da:	8b 00                	mov    (%eax),%eax
  8044dc:	85 c0                	test   %eax,%eax
  8044de:	74 0d                	je     8044ed <insert_sorted_with_merge_freeList+0x264>
  8044e0:	a1 48 61 80 00       	mov    0x806148,%eax
  8044e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8044e8:	89 50 04             	mov    %edx,0x4(%eax)
  8044eb:	eb 08                	jmp    8044f5 <insert_sorted_with_merge_freeList+0x26c>
  8044ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8044f0:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8044f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8044f8:	a3 48 61 80 00       	mov    %eax,0x806148
  8044fd:	8b 45 08             	mov    0x8(%ebp),%eax
  804500:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804507:	a1 54 61 80 00       	mov    0x806154,%eax
  80450c:	40                   	inc    %eax
  80450d:	a3 54 61 80 00       	mov    %eax,0x806154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804512:	e9 bb 04 00 00       	jmp    8049d2 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  804517:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80451b:	75 17                	jne    804534 <insert_sorted_with_merge_freeList+0x2ab>
  80451d:	83 ec 04             	sub    $0x4,%esp
  804520:	68 8c 56 80 00       	push   $0x80568c
  804525:	68 4c 01 00 00       	push   $0x14c
  80452a:	68 3b 56 80 00       	push   $0x80563b
  80452f:	e8 f6 d3 ff ff       	call   80192a <_panic>
  804534:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  80453a:	8b 45 08             	mov    0x8(%ebp),%eax
  80453d:	89 50 04             	mov    %edx,0x4(%eax)
  804540:	8b 45 08             	mov    0x8(%ebp),%eax
  804543:	8b 40 04             	mov    0x4(%eax),%eax
  804546:	85 c0                	test   %eax,%eax
  804548:	74 0c                	je     804556 <insert_sorted_with_merge_freeList+0x2cd>
  80454a:	a1 3c 61 80 00       	mov    0x80613c,%eax
  80454f:	8b 55 08             	mov    0x8(%ebp),%edx
  804552:	89 10                	mov    %edx,(%eax)
  804554:	eb 08                	jmp    80455e <insert_sorted_with_merge_freeList+0x2d5>
  804556:	8b 45 08             	mov    0x8(%ebp),%eax
  804559:	a3 38 61 80 00       	mov    %eax,0x806138
  80455e:	8b 45 08             	mov    0x8(%ebp),%eax
  804561:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804566:	8b 45 08             	mov    0x8(%ebp),%eax
  804569:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80456f:	a1 44 61 80 00       	mov    0x806144,%eax
  804574:	40                   	inc    %eax
  804575:	a3 44 61 80 00       	mov    %eax,0x806144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80457a:	e9 53 04 00 00       	jmp    8049d2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80457f:	a1 38 61 80 00       	mov    0x806138,%eax
  804584:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804587:	e9 15 04 00 00       	jmp    8049a1 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80458c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80458f:	8b 00                	mov    (%eax),%eax
  804591:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  804594:	8b 45 08             	mov    0x8(%ebp),%eax
  804597:	8b 50 08             	mov    0x8(%eax),%edx
  80459a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80459d:	8b 40 08             	mov    0x8(%eax),%eax
  8045a0:	39 c2                	cmp    %eax,%edx
  8045a2:	0f 86 f1 03 00 00    	jbe    804999 <insert_sorted_with_merge_freeList+0x710>
  8045a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8045ab:	8b 50 08             	mov    0x8(%eax),%edx
  8045ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045b1:	8b 40 08             	mov    0x8(%eax),%eax
  8045b4:	39 c2                	cmp    %eax,%edx
  8045b6:	0f 83 dd 03 00 00    	jae    804999 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8045bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045bf:	8b 50 08             	mov    0x8(%eax),%edx
  8045c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8045c8:	01 c2                	add    %eax,%edx
  8045ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8045cd:	8b 40 08             	mov    0x8(%eax),%eax
  8045d0:	39 c2                	cmp    %eax,%edx
  8045d2:	0f 85 b9 01 00 00    	jne    804791 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8045d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8045db:	8b 50 08             	mov    0x8(%eax),%edx
  8045de:	8b 45 08             	mov    0x8(%ebp),%eax
  8045e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8045e4:	01 c2                	add    %eax,%edx
  8045e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045e9:	8b 40 08             	mov    0x8(%eax),%eax
  8045ec:	39 c2                	cmp    %eax,%edx
  8045ee:	0f 85 0d 01 00 00    	jne    804701 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8045f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045f7:	8b 50 0c             	mov    0xc(%eax),%edx
  8045fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045fd:	8b 40 0c             	mov    0xc(%eax),%eax
  804600:	01 c2                	add    %eax,%edx
  804602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804605:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  804608:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80460c:	75 17                	jne    804625 <insert_sorted_with_merge_freeList+0x39c>
  80460e:	83 ec 04             	sub    $0x4,%esp
  804611:	68 e4 56 80 00       	push   $0x8056e4
  804616:	68 5c 01 00 00       	push   $0x15c
  80461b:	68 3b 56 80 00       	push   $0x80563b
  804620:	e8 05 d3 ff ff       	call   80192a <_panic>
  804625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804628:	8b 00                	mov    (%eax),%eax
  80462a:	85 c0                	test   %eax,%eax
  80462c:	74 10                	je     80463e <insert_sorted_with_merge_freeList+0x3b5>
  80462e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804631:	8b 00                	mov    (%eax),%eax
  804633:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804636:	8b 52 04             	mov    0x4(%edx),%edx
  804639:	89 50 04             	mov    %edx,0x4(%eax)
  80463c:	eb 0b                	jmp    804649 <insert_sorted_with_merge_freeList+0x3c0>
  80463e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804641:	8b 40 04             	mov    0x4(%eax),%eax
  804644:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804649:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80464c:	8b 40 04             	mov    0x4(%eax),%eax
  80464f:	85 c0                	test   %eax,%eax
  804651:	74 0f                	je     804662 <insert_sorted_with_merge_freeList+0x3d9>
  804653:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804656:	8b 40 04             	mov    0x4(%eax),%eax
  804659:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80465c:	8b 12                	mov    (%edx),%edx
  80465e:	89 10                	mov    %edx,(%eax)
  804660:	eb 0a                	jmp    80466c <insert_sorted_with_merge_freeList+0x3e3>
  804662:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804665:	8b 00                	mov    (%eax),%eax
  804667:	a3 38 61 80 00       	mov    %eax,0x806138
  80466c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80466f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804675:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804678:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80467f:	a1 44 61 80 00       	mov    0x806144,%eax
  804684:	48                   	dec    %eax
  804685:	a3 44 61 80 00       	mov    %eax,0x806144
						nextBlock->sva = 0;
  80468a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80468d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  804694:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804697:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80469e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8046a2:	75 17                	jne    8046bb <insert_sorted_with_merge_freeList+0x432>
  8046a4:	83 ec 04             	sub    $0x4,%esp
  8046a7:	68 18 56 80 00       	push   $0x805618
  8046ac:	68 5f 01 00 00       	push   $0x15f
  8046b1:	68 3b 56 80 00       	push   $0x80563b
  8046b6:	e8 6f d2 ff ff       	call   80192a <_panic>
  8046bb:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8046c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046c4:	89 10                	mov    %edx,(%eax)
  8046c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046c9:	8b 00                	mov    (%eax),%eax
  8046cb:	85 c0                	test   %eax,%eax
  8046cd:	74 0d                	je     8046dc <insert_sorted_with_merge_freeList+0x453>
  8046cf:	a1 48 61 80 00       	mov    0x806148,%eax
  8046d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8046d7:	89 50 04             	mov    %edx,0x4(%eax)
  8046da:	eb 08                	jmp    8046e4 <insert_sorted_with_merge_freeList+0x45b>
  8046dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046df:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8046e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046e7:	a3 48 61 80 00       	mov    %eax,0x806148
  8046ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8046f6:	a1 54 61 80 00       	mov    0x806154,%eax
  8046fb:	40                   	inc    %eax
  8046fc:	a3 54 61 80 00       	mov    %eax,0x806154
					}
					currentBlock->size += blockToInsert->size;
  804701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804704:	8b 50 0c             	mov    0xc(%eax),%edx
  804707:	8b 45 08             	mov    0x8(%ebp),%eax
  80470a:	8b 40 0c             	mov    0xc(%eax),%eax
  80470d:	01 c2                	add    %eax,%edx
  80470f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804712:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  804715:	8b 45 08             	mov    0x8(%ebp),%eax
  804718:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80471f:	8b 45 08             	mov    0x8(%ebp),%eax
  804722:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  804729:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80472d:	75 17                	jne    804746 <insert_sorted_with_merge_freeList+0x4bd>
  80472f:	83 ec 04             	sub    $0x4,%esp
  804732:	68 18 56 80 00       	push   $0x805618
  804737:	68 64 01 00 00       	push   $0x164
  80473c:	68 3b 56 80 00       	push   $0x80563b
  804741:	e8 e4 d1 ff ff       	call   80192a <_panic>
  804746:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80474c:	8b 45 08             	mov    0x8(%ebp),%eax
  80474f:	89 10                	mov    %edx,(%eax)
  804751:	8b 45 08             	mov    0x8(%ebp),%eax
  804754:	8b 00                	mov    (%eax),%eax
  804756:	85 c0                	test   %eax,%eax
  804758:	74 0d                	je     804767 <insert_sorted_with_merge_freeList+0x4de>
  80475a:	a1 48 61 80 00       	mov    0x806148,%eax
  80475f:	8b 55 08             	mov    0x8(%ebp),%edx
  804762:	89 50 04             	mov    %edx,0x4(%eax)
  804765:	eb 08                	jmp    80476f <insert_sorted_with_merge_freeList+0x4e6>
  804767:	8b 45 08             	mov    0x8(%ebp),%eax
  80476a:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80476f:	8b 45 08             	mov    0x8(%ebp),%eax
  804772:	a3 48 61 80 00       	mov    %eax,0x806148
  804777:	8b 45 08             	mov    0x8(%ebp),%eax
  80477a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804781:	a1 54 61 80 00       	mov    0x806154,%eax
  804786:	40                   	inc    %eax
  804787:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  80478c:	e9 41 02 00 00       	jmp    8049d2 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  804791:	8b 45 08             	mov    0x8(%ebp),%eax
  804794:	8b 50 08             	mov    0x8(%eax),%edx
  804797:	8b 45 08             	mov    0x8(%ebp),%eax
  80479a:	8b 40 0c             	mov    0xc(%eax),%eax
  80479d:	01 c2                	add    %eax,%edx
  80479f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047a2:	8b 40 08             	mov    0x8(%eax),%eax
  8047a5:	39 c2                	cmp    %eax,%edx
  8047a7:	0f 85 7c 01 00 00    	jne    804929 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8047ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8047b1:	74 06                	je     8047b9 <insert_sorted_with_merge_freeList+0x530>
  8047b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8047b7:	75 17                	jne    8047d0 <insert_sorted_with_merge_freeList+0x547>
  8047b9:	83 ec 04             	sub    $0x4,%esp
  8047bc:	68 54 56 80 00       	push   $0x805654
  8047c1:	68 69 01 00 00       	push   $0x169
  8047c6:	68 3b 56 80 00       	push   $0x80563b
  8047cb:	e8 5a d1 ff ff       	call   80192a <_panic>
  8047d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047d3:	8b 50 04             	mov    0x4(%eax),%edx
  8047d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8047d9:	89 50 04             	mov    %edx,0x4(%eax)
  8047dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8047df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8047e2:	89 10                	mov    %edx,(%eax)
  8047e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047e7:	8b 40 04             	mov    0x4(%eax),%eax
  8047ea:	85 c0                	test   %eax,%eax
  8047ec:	74 0d                	je     8047fb <insert_sorted_with_merge_freeList+0x572>
  8047ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047f1:	8b 40 04             	mov    0x4(%eax),%eax
  8047f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8047f7:	89 10                	mov    %edx,(%eax)
  8047f9:	eb 08                	jmp    804803 <insert_sorted_with_merge_freeList+0x57a>
  8047fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8047fe:	a3 38 61 80 00       	mov    %eax,0x806138
  804803:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804806:	8b 55 08             	mov    0x8(%ebp),%edx
  804809:	89 50 04             	mov    %edx,0x4(%eax)
  80480c:	a1 44 61 80 00       	mov    0x806144,%eax
  804811:	40                   	inc    %eax
  804812:	a3 44 61 80 00       	mov    %eax,0x806144
					blockToInsert->size += nextBlock->size;
  804817:	8b 45 08             	mov    0x8(%ebp),%eax
  80481a:	8b 50 0c             	mov    0xc(%eax),%edx
  80481d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804820:	8b 40 0c             	mov    0xc(%eax),%eax
  804823:	01 c2                	add    %eax,%edx
  804825:	8b 45 08             	mov    0x8(%ebp),%eax
  804828:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80482b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80482f:	75 17                	jne    804848 <insert_sorted_with_merge_freeList+0x5bf>
  804831:	83 ec 04             	sub    $0x4,%esp
  804834:	68 e4 56 80 00       	push   $0x8056e4
  804839:	68 6b 01 00 00       	push   $0x16b
  80483e:	68 3b 56 80 00       	push   $0x80563b
  804843:	e8 e2 d0 ff ff       	call   80192a <_panic>
  804848:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80484b:	8b 00                	mov    (%eax),%eax
  80484d:	85 c0                	test   %eax,%eax
  80484f:	74 10                	je     804861 <insert_sorted_with_merge_freeList+0x5d8>
  804851:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804854:	8b 00                	mov    (%eax),%eax
  804856:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804859:	8b 52 04             	mov    0x4(%edx),%edx
  80485c:	89 50 04             	mov    %edx,0x4(%eax)
  80485f:	eb 0b                	jmp    80486c <insert_sorted_with_merge_freeList+0x5e3>
  804861:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804864:	8b 40 04             	mov    0x4(%eax),%eax
  804867:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80486c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80486f:	8b 40 04             	mov    0x4(%eax),%eax
  804872:	85 c0                	test   %eax,%eax
  804874:	74 0f                	je     804885 <insert_sorted_with_merge_freeList+0x5fc>
  804876:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804879:	8b 40 04             	mov    0x4(%eax),%eax
  80487c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80487f:	8b 12                	mov    (%edx),%edx
  804881:	89 10                	mov    %edx,(%eax)
  804883:	eb 0a                	jmp    80488f <insert_sorted_with_merge_freeList+0x606>
  804885:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804888:	8b 00                	mov    (%eax),%eax
  80488a:	a3 38 61 80 00       	mov    %eax,0x806138
  80488f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804892:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804898:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80489b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8048a2:	a1 44 61 80 00       	mov    0x806144,%eax
  8048a7:	48                   	dec    %eax
  8048a8:	a3 44 61 80 00       	mov    %eax,0x806144
					nextBlock->sva = 0;
  8048ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048b0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8048b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048ba:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8048c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8048c5:	75 17                	jne    8048de <insert_sorted_with_merge_freeList+0x655>
  8048c7:	83 ec 04             	sub    $0x4,%esp
  8048ca:	68 18 56 80 00       	push   $0x805618
  8048cf:	68 6e 01 00 00       	push   $0x16e
  8048d4:	68 3b 56 80 00       	push   $0x80563b
  8048d9:	e8 4c d0 ff ff       	call   80192a <_panic>
  8048de:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8048e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048e7:	89 10                	mov    %edx,(%eax)
  8048e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048ec:	8b 00                	mov    (%eax),%eax
  8048ee:	85 c0                	test   %eax,%eax
  8048f0:	74 0d                	je     8048ff <insert_sorted_with_merge_freeList+0x676>
  8048f2:	a1 48 61 80 00       	mov    0x806148,%eax
  8048f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8048fa:	89 50 04             	mov    %edx,0x4(%eax)
  8048fd:	eb 08                	jmp    804907 <insert_sorted_with_merge_freeList+0x67e>
  8048ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804902:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804907:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80490a:	a3 48 61 80 00       	mov    %eax,0x806148
  80490f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804912:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804919:	a1 54 61 80 00       	mov    0x806154,%eax
  80491e:	40                   	inc    %eax
  80491f:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  804924:	e9 a9 00 00 00       	jmp    8049d2 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  804929:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80492d:	74 06                	je     804935 <insert_sorted_with_merge_freeList+0x6ac>
  80492f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804933:	75 17                	jne    80494c <insert_sorted_with_merge_freeList+0x6c3>
  804935:	83 ec 04             	sub    $0x4,%esp
  804938:	68 b0 56 80 00       	push   $0x8056b0
  80493d:	68 73 01 00 00       	push   $0x173
  804942:	68 3b 56 80 00       	push   $0x80563b
  804947:	e8 de cf ff ff       	call   80192a <_panic>
  80494c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80494f:	8b 10                	mov    (%eax),%edx
  804951:	8b 45 08             	mov    0x8(%ebp),%eax
  804954:	89 10                	mov    %edx,(%eax)
  804956:	8b 45 08             	mov    0x8(%ebp),%eax
  804959:	8b 00                	mov    (%eax),%eax
  80495b:	85 c0                	test   %eax,%eax
  80495d:	74 0b                	je     80496a <insert_sorted_with_merge_freeList+0x6e1>
  80495f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804962:	8b 00                	mov    (%eax),%eax
  804964:	8b 55 08             	mov    0x8(%ebp),%edx
  804967:	89 50 04             	mov    %edx,0x4(%eax)
  80496a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80496d:	8b 55 08             	mov    0x8(%ebp),%edx
  804970:	89 10                	mov    %edx,(%eax)
  804972:	8b 45 08             	mov    0x8(%ebp),%eax
  804975:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804978:	89 50 04             	mov    %edx,0x4(%eax)
  80497b:	8b 45 08             	mov    0x8(%ebp),%eax
  80497e:	8b 00                	mov    (%eax),%eax
  804980:	85 c0                	test   %eax,%eax
  804982:	75 08                	jne    80498c <insert_sorted_with_merge_freeList+0x703>
  804984:	8b 45 08             	mov    0x8(%ebp),%eax
  804987:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80498c:	a1 44 61 80 00       	mov    0x806144,%eax
  804991:	40                   	inc    %eax
  804992:	a3 44 61 80 00       	mov    %eax,0x806144
					break;
  804997:	eb 39                	jmp    8049d2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  804999:	a1 40 61 80 00       	mov    0x806140,%eax
  80499e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8049a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8049a5:	74 07                	je     8049ae <insert_sorted_with_merge_freeList+0x725>
  8049a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8049aa:	8b 00                	mov    (%eax),%eax
  8049ac:	eb 05                	jmp    8049b3 <insert_sorted_with_merge_freeList+0x72a>
  8049ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8049b3:	a3 40 61 80 00       	mov    %eax,0x806140
  8049b8:	a1 40 61 80 00       	mov    0x806140,%eax
  8049bd:	85 c0                	test   %eax,%eax
  8049bf:	0f 85 c7 fb ff ff    	jne    80458c <insert_sorted_with_merge_freeList+0x303>
  8049c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8049c9:	0f 85 bd fb ff ff    	jne    80458c <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8049cf:	eb 01                	jmp    8049d2 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8049d1:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8049d2:	90                   	nop
  8049d3:	c9                   	leave  
  8049d4:	c3                   	ret    
  8049d5:	66 90                	xchg   %ax,%ax
  8049d7:	90                   	nop

008049d8 <__udivdi3>:
  8049d8:	55                   	push   %ebp
  8049d9:	57                   	push   %edi
  8049da:	56                   	push   %esi
  8049db:	53                   	push   %ebx
  8049dc:	83 ec 1c             	sub    $0x1c,%esp
  8049df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8049e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8049e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8049eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8049ef:	89 ca                	mov    %ecx,%edx
  8049f1:	89 f8                	mov    %edi,%eax
  8049f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8049f7:	85 f6                	test   %esi,%esi
  8049f9:	75 2d                	jne    804a28 <__udivdi3+0x50>
  8049fb:	39 cf                	cmp    %ecx,%edi
  8049fd:	77 65                	ja     804a64 <__udivdi3+0x8c>
  8049ff:	89 fd                	mov    %edi,%ebp
  804a01:	85 ff                	test   %edi,%edi
  804a03:	75 0b                	jne    804a10 <__udivdi3+0x38>
  804a05:	b8 01 00 00 00       	mov    $0x1,%eax
  804a0a:	31 d2                	xor    %edx,%edx
  804a0c:	f7 f7                	div    %edi
  804a0e:	89 c5                	mov    %eax,%ebp
  804a10:	31 d2                	xor    %edx,%edx
  804a12:	89 c8                	mov    %ecx,%eax
  804a14:	f7 f5                	div    %ebp
  804a16:	89 c1                	mov    %eax,%ecx
  804a18:	89 d8                	mov    %ebx,%eax
  804a1a:	f7 f5                	div    %ebp
  804a1c:	89 cf                	mov    %ecx,%edi
  804a1e:	89 fa                	mov    %edi,%edx
  804a20:	83 c4 1c             	add    $0x1c,%esp
  804a23:	5b                   	pop    %ebx
  804a24:	5e                   	pop    %esi
  804a25:	5f                   	pop    %edi
  804a26:	5d                   	pop    %ebp
  804a27:	c3                   	ret    
  804a28:	39 ce                	cmp    %ecx,%esi
  804a2a:	77 28                	ja     804a54 <__udivdi3+0x7c>
  804a2c:	0f bd fe             	bsr    %esi,%edi
  804a2f:	83 f7 1f             	xor    $0x1f,%edi
  804a32:	75 40                	jne    804a74 <__udivdi3+0x9c>
  804a34:	39 ce                	cmp    %ecx,%esi
  804a36:	72 0a                	jb     804a42 <__udivdi3+0x6a>
  804a38:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804a3c:	0f 87 9e 00 00 00    	ja     804ae0 <__udivdi3+0x108>
  804a42:	b8 01 00 00 00       	mov    $0x1,%eax
  804a47:	89 fa                	mov    %edi,%edx
  804a49:	83 c4 1c             	add    $0x1c,%esp
  804a4c:	5b                   	pop    %ebx
  804a4d:	5e                   	pop    %esi
  804a4e:	5f                   	pop    %edi
  804a4f:	5d                   	pop    %ebp
  804a50:	c3                   	ret    
  804a51:	8d 76 00             	lea    0x0(%esi),%esi
  804a54:	31 ff                	xor    %edi,%edi
  804a56:	31 c0                	xor    %eax,%eax
  804a58:	89 fa                	mov    %edi,%edx
  804a5a:	83 c4 1c             	add    $0x1c,%esp
  804a5d:	5b                   	pop    %ebx
  804a5e:	5e                   	pop    %esi
  804a5f:	5f                   	pop    %edi
  804a60:	5d                   	pop    %ebp
  804a61:	c3                   	ret    
  804a62:	66 90                	xchg   %ax,%ax
  804a64:	89 d8                	mov    %ebx,%eax
  804a66:	f7 f7                	div    %edi
  804a68:	31 ff                	xor    %edi,%edi
  804a6a:	89 fa                	mov    %edi,%edx
  804a6c:	83 c4 1c             	add    $0x1c,%esp
  804a6f:	5b                   	pop    %ebx
  804a70:	5e                   	pop    %esi
  804a71:	5f                   	pop    %edi
  804a72:	5d                   	pop    %ebp
  804a73:	c3                   	ret    
  804a74:	bd 20 00 00 00       	mov    $0x20,%ebp
  804a79:	89 eb                	mov    %ebp,%ebx
  804a7b:	29 fb                	sub    %edi,%ebx
  804a7d:	89 f9                	mov    %edi,%ecx
  804a7f:	d3 e6                	shl    %cl,%esi
  804a81:	89 c5                	mov    %eax,%ebp
  804a83:	88 d9                	mov    %bl,%cl
  804a85:	d3 ed                	shr    %cl,%ebp
  804a87:	89 e9                	mov    %ebp,%ecx
  804a89:	09 f1                	or     %esi,%ecx
  804a8b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804a8f:	89 f9                	mov    %edi,%ecx
  804a91:	d3 e0                	shl    %cl,%eax
  804a93:	89 c5                	mov    %eax,%ebp
  804a95:	89 d6                	mov    %edx,%esi
  804a97:	88 d9                	mov    %bl,%cl
  804a99:	d3 ee                	shr    %cl,%esi
  804a9b:	89 f9                	mov    %edi,%ecx
  804a9d:	d3 e2                	shl    %cl,%edx
  804a9f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804aa3:	88 d9                	mov    %bl,%cl
  804aa5:	d3 e8                	shr    %cl,%eax
  804aa7:	09 c2                	or     %eax,%edx
  804aa9:	89 d0                	mov    %edx,%eax
  804aab:	89 f2                	mov    %esi,%edx
  804aad:	f7 74 24 0c          	divl   0xc(%esp)
  804ab1:	89 d6                	mov    %edx,%esi
  804ab3:	89 c3                	mov    %eax,%ebx
  804ab5:	f7 e5                	mul    %ebp
  804ab7:	39 d6                	cmp    %edx,%esi
  804ab9:	72 19                	jb     804ad4 <__udivdi3+0xfc>
  804abb:	74 0b                	je     804ac8 <__udivdi3+0xf0>
  804abd:	89 d8                	mov    %ebx,%eax
  804abf:	31 ff                	xor    %edi,%edi
  804ac1:	e9 58 ff ff ff       	jmp    804a1e <__udivdi3+0x46>
  804ac6:	66 90                	xchg   %ax,%ax
  804ac8:	8b 54 24 08          	mov    0x8(%esp),%edx
  804acc:	89 f9                	mov    %edi,%ecx
  804ace:	d3 e2                	shl    %cl,%edx
  804ad0:	39 c2                	cmp    %eax,%edx
  804ad2:	73 e9                	jae    804abd <__udivdi3+0xe5>
  804ad4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804ad7:	31 ff                	xor    %edi,%edi
  804ad9:	e9 40 ff ff ff       	jmp    804a1e <__udivdi3+0x46>
  804ade:	66 90                	xchg   %ax,%ax
  804ae0:	31 c0                	xor    %eax,%eax
  804ae2:	e9 37 ff ff ff       	jmp    804a1e <__udivdi3+0x46>
  804ae7:	90                   	nop

00804ae8 <__umoddi3>:
  804ae8:	55                   	push   %ebp
  804ae9:	57                   	push   %edi
  804aea:	56                   	push   %esi
  804aeb:	53                   	push   %ebx
  804aec:	83 ec 1c             	sub    $0x1c,%esp
  804aef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804af3:	8b 74 24 34          	mov    0x34(%esp),%esi
  804af7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804afb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804aff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804b03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804b07:	89 f3                	mov    %esi,%ebx
  804b09:	89 fa                	mov    %edi,%edx
  804b0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804b0f:	89 34 24             	mov    %esi,(%esp)
  804b12:	85 c0                	test   %eax,%eax
  804b14:	75 1a                	jne    804b30 <__umoddi3+0x48>
  804b16:	39 f7                	cmp    %esi,%edi
  804b18:	0f 86 a2 00 00 00    	jbe    804bc0 <__umoddi3+0xd8>
  804b1e:	89 c8                	mov    %ecx,%eax
  804b20:	89 f2                	mov    %esi,%edx
  804b22:	f7 f7                	div    %edi
  804b24:	89 d0                	mov    %edx,%eax
  804b26:	31 d2                	xor    %edx,%edx
  804b28:	83 c4 1c             	add    $0x1c,%esp
  804b2b:	5b                   	pop    %ebx
  804b2c:	5e                   	pop    %esi
  804b2d:	5f                   	pop    %edi
  804b2e:	5d                   	pop    %ebp
  804b2f:	c3                   	ret    
  804b30:	39 f0                	cmp    %esi,%eax
  804b32:	0f 87 ac 00 00 00    	ja     804be4 <__umoddi3+0xfc>
  804b38:	0f bd e8             	bsr    %eax,%ebp
  804b3b:	83 f5 1f             	xor    $0x1f,%ebp
  804b3e:	0f 84 ac 00 00 00    	je     804bf0 <__umoddi3+0x108>
  804b44:	bf 20 00 00 00       	mov    $0x20,%edi
  804b49:	29 ef                	sub    %ebp,%edi
  804b4b:	89 fe                	mov    %edi,%esi
  804b4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804b51:	89 e9                	mov    %ebp,%ecx
  804b53:	d3 e0                	shl    %cl,%eax
  804b55:	89 d7                	mov    %edx,%edi
  804b57:	89 f1                	mov    %esi,%ecx
  804b59:	d3 ef                	shr    %cl,%edi
  804b5b:	09 c7                	or     %eax,%edi
  804b5d:	89 e9                	mov    %ebp,%ecx
  804b5f:	d3 e2                	shl    %cl,%edx
  804b61:	89 14 24             	mov    %edx,(%esp)
  804b64:	89 d8                	mov    %ebx,%eax
  804b66:	d3 e0                	shl    %cl,%eax
  804b68:	89 c2                	mov    %eax,%edx
  804b6a:	8b 44 24 08          	mov    0x8(%esp),%eax
  804b6e:	d3 e0                	shl    %cl,%eax
  804b70:	89 44 24 04          	mov    %eax,0x4(%esp)
  804b74:	8b 44 24 08          	mov    0x8(%esp),%eax
  804b78:	89 f1                	mov    %esi,%ecx
  804b7a:	d3 e8                	shr    %cl,%eax
  804b7c:	09 d0                	or     %edx,%eax
  804b7e:	d3 eb                	shr    %cl,%ebx
  804b80:	89 da                	mov    %ebx,%edx
  804b82:	f7 f7                	div    %edi
  804b84:	89 d3                	mov    %edx,%ebx
  804b86:	f7 24 24             	mull   (%esp)
  804b89:	89 c6                	mov    %eax,%esi
  804b8b:	89 d1                	mov    %edx,%ecx
  804b8d:	39 d3                	cmp    %edx,%ebx
  804b8f:	0f 82 87 00 00 00    	jb     804c1c <__umoddi3+0x134>
  804b95:	0f 84 91 00 00 00    	je     804c2c <__umoddi3+0x144>
  804b9b:	8b 54 24 04          	mov    0x4(%esp),%edx
  804b9f:	29 f2                	sub    %esi,%edx
  804ba1:	19 cb                	sbb    %ecx,%ebx
  804ba3:	89 d8                	mov    %ebx,%eax
  804ba5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804ba9:	d3 e0                	shl    %cl,%eax
  804bab:	89 e9                	mov    %ebp,%ecx
  804bad:	d3 ea                	shr    %cl,%edx
  804baf:	09 d0                	or     %edx,%eax
  804bb1:	89 e9                	mov    %ebp,%ecx
  804bb3:	d3 eb                	shr    %cl,%ebx
  804bb5:	89 da                	mov    %ebx,%edx
  804bb7:	83 c4 1c             	add    $0x1c,%esp
  804bba:	5b                   	pop    %ebx
  804bbb:	5e                   	pop    %esi
  804bbc:	5f                   	pop    %edi
  804bbd:	5d                   	pop    %ebp
  804bbe:	c3                   	ret    
  804bbf:	90                   	nop
  804bc0:	89 fd                	mov    %edi,%ebp
  804bc2:	85 ff                	test   %edi,%edi
  804bc4:	75 0b                	jne    804bd1 <__umoddi3+0xe9>
  804bc6:	b8 01 00 00 00       	mov    $0x1,%eax
  804bcb:	31 d2                	xor    %edx,%edx
  804bcd:	f7 f7                	div    %edi
  804bcf:	89 c5                	mov    %eax,%ebp
  804bd1:	89 f0                	mov    %esi,%eax
  804bd3:	31 d2                	xor    %edx,%edx
  804bd5:	f7 f5                	div    %ebp
  804bd7:	89 c8                	mov    %ecx,%eax
  804bd9:	f7 f5                	div    %ebp
  804bdb:	89 d0                	mov    %edx,%eax
  804bdd:	e9 44 ff ff ff       	jmp    804b26 <__umoddi3+0x3e>
  804be2:	66 90                	xchg   %ax,%ax
  804be4:	89 c8                	mov    %ecx,%eax
  804be6:	89 f2                	mov    %esi,%edx
  804be8:	83 c4 1c             	add    $0x1c,%esp
  804beb:	5b                   	pop    %ebx
  804bec:	5e                   	pop    %esi
  804bed:	5f                   	pop    %edi
  804bee:	5d                   	pop    %ebp
  804bef:	c3                   	ret    
  804bf0:	3b 04 24             	cmp    (%esp),%eax
  804bf3:	72 06                	jb     804bfb <__umoddi3+0x113>
  804bf5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804bf9:	77 0f                	ja     804c0a <__umoddi3+0x122>
  804bfb:	89 f2                	mov    %esi,%edx
  804bfd:	29 f9                	sub    %edi,%ecx
  804bff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804c03:	89 14 24             	mov    %edx,(%esp)
  804c06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804c0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  804c0e:	8b 14 24             	mov    (%esp),%edx
  804c11:	83 c4 1c             	add    $0x1c,%esp
  804c14:	5b                   	pop    %ebx
  804c15:	5e                   	pop    %esi
  804c16:	5f                   	pop    %edi
  804c17:	5d                   	pop    %ebp
  804c18:	c3                   	ret    
  804c19:	8d 76 00             	lea    0x0(%esi),%esi
  804c1c:	2b 04 24             	sub    (%esp),%eax
  804c1f:	19 fa                	sbb    %edi,%edx
  804c21:	89 d1                	mov    %edx,%ecx
  804c23:	89 c6                	mov    %eax,%esi
  804c25:	e9 71 ff ff ff       	jmp    804b9b <__umoddi3+0xb3>
  804c2a:	66 90                	xchg   %ax,%ax
  804c2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804c30:	72 ea                	jb     804c1c <__umoddi3+0x134>
  804c32:	89 d9                	mov    %ebx,%ecx
  804c34:	e9 62 ff ff ff       	jmp    804b9b <__umoddi3+0xb3>
