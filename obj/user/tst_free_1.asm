
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
  800091:	68 c0 4b 80 00       	push   $0x804bc0
  800096:	6a 1a                	push   $0x1a
  800098:	68 dc 4b 80 00       	push   $0x804bdc
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
  8000df:	e8 a2 2c 00 00       	call   802d86 <sys_calculate_free_frames>
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
  8000fb:	e8 26 2d 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
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
  800137:	68 f0 4b 80 00       	push   $0x804bf0
  80013c:	6a 3a                	push   $0x3a
  80013e:	68 dc 4b 80 00       	push   $0x804bdc
  800143:	e8 e2 17 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 d9 2c 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 58 4c 80 00       	push   $0x804c58
  80015a:	6a 3b                	push   $0x3b
  80015c:	68 dc 4b 80 00       	push   $0x804bdc
  800161:	e8 c4 17 00 00       	call   80192a <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 1b 2c 00 00       	call   802d86 <sys_calculate_free_frames>
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
  80019b:	e8 e6 2b 00 00       	call   802d86 <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 88 4c 80 00       	push   $0x804c88
  8001b1:	6a 42                	push   $0x42
  8001b3:	68 dc 4b 80 00       	push   $0x804bdc
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
  80026e:	68 cc 4c 80 00       	push   $0x804ccc
  800273:	6a 4c                	push   $0x4c
  800275:	68 dc 4b 80 00       	push   $0x804bdc
  80027a:	e8 ab 16 00 00       	call   80192a <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 a2 2b 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
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
  8002d0:	68 f0 4b 80 00       	push   $0x804bf0
  8002d5:	6a 51                	push   $0x51
  8002d7:	68 dc 4b 80 00       	push   $0x804bdc
  8002dc:	e8 49 16 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 40 2b 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 58 4c 80 00       	push   $0x804c58
  8002f3:	6a 52                	push   $0x52
  8002f5:	68 dc 4b 80 00       	push   $0x804bdc
  8002fa:	e8 2b 16 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 82 2a 00 00       	call   802d86 <sys_calculate_free_frames>
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
  80033d:	e8 44 2a 00 00       	call   802d86 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 88 4c 80 00       	push   $0x804c88
  800353:	6a 59                	push   $0x59
  800355:	68 dc 4b 80 00       	push   $0x804bdc
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
  800414:	68 cc 4c 80 00       	push   $0x804ccc
  800419:	6a 62                	push   $0x62
  80041b:	68 dc 4b 80 00       	push   $0x804bdc
  800420:	e8 05 15 00 00       	call   80192a <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 fc 29 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
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
  800475:	68 f0 4b 80 00       	push   $0x804bf0
  80047a:	6a 67                	push   $0x67
  80047c:	68 dc 4b 80 00       	push   $0x804bdc
  800481:	e8 a4 14 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800486:	e8 9b 29 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  80048b:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80048e:	74 14                	je     8004a4 <_main+0x46c>
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 58 4c 80 00       	push   $0x804c58
  800498:	6a 68                	push   $0x68
  80049a:	68 dc 4b 80 00       	push   $0x804bdc
  80049f:	e8 86 14 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a4:	e8 dd 28 00 00       	call   802d86 <sys_calculate_free_frames>
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
  8004e0:	e8 a1 28 00 00       	call   802d86 <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	83 f8 02             	cmp    $0x2,%eax
  8004ec:	74 14                	je     800502 <_main+0x4ca>
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	68 88 4c 80 00       	push   $0x804c88
  8004f6:	6a 6f                	push   $0x6f
  8004f8:	68 dc 4b 80 00       	push   $0x804bdc
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
  8005c6:	68 cc 4c 80 00       	push   $0x804ccc
  8005cb:	6a 78                	push   $0x78
  8005cd:	68 dc 4b 80 00       	push   $0x804bdc
  8005d2:	e8 53 13 00 00       	call   80192a <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d7:	e8 aa 27 00 00       	call   802d86 <sys_calculate_free_frames>
  8005dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005df:	e8 42 28 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
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
  800643:	68 f0 4b 80 00       	push   $0x804bf0
  800648:	6a 7e                	push   $0x7e
  80064a:	68 dc 4b 80 00       	push   $0x804bdc
  80064f:	e8 d6 12 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800654:	e8 cd 27 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  800659:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80065c:	74 14                	je     800672 <_main+0x63a>
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	68 58 4c 80 00       	push   $0x804c58
  800666:	6a 7f                	push   $0x7f
  800668:	68 dc 4b 80 00       	push   $0x804bdc
  80066d:	e8 b8 12 00 00       	call   80192a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800672:	e8 af 27 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
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
  8006de:	68 f0 4b 80 00       	push   $0x804bf0
  8006e3:	68 85 00 00 00       	push   $0x85
  8006e8:	68 dc 4b 80 00       	push   $0x804bdc
  8006ed:	e8 38 12 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f2:	e8 2f 27 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  8006f7:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8006fa:	74 17                	je     800713 <_main+0x6db>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 58 4c 80 00       	push   $0x804c58
  800704:	68 86 00 00 00       	push   $0x86
  800709:	68 dc 4b 80 00       	push   $0x804bdc
  80070e:	e8 17 12 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800713:	e8 6e 26 00 00       	call   802d86 <sys_calculate_free_frames>
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
  8007b7:	e8 ca 25 00 00       	call   802d86 <sys_calculate_free_frames>
  8007bc:	29 c3                	sub    %eax,%ebx
  8007be:	89 d8                	mov    %ebx,%eax
  8007c0:	83 f8 02             	cmp    $0x2,%eax
  8007c3:	74 17                	je     8007dc <_main+0x7a4>
  8007c5:	83 ec 04             	sub    $0x4,%esp
  8007c8:	68 88 4c 80 00       	push   $0x804c88
  8007cd:	68 8d 00 00 00       	push   $0x8d
  8007d2:	68 dc 4b 80 00       	push   $0x804bdc
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
  8008b5:	68 cc 4c 80 00       	push   $0x804ccc
  8008ba:	68 96 00 00 00       	push   $0x96
  8008bf:	68 dc 4b 80 00       	push   $0x804bdc
  8008c4:	e8 61 10 00 00       	call   80192a <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 b8 24 00 00       	call   802d86 <sys_calculate_free_frames>
  8008ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d1:	e8 50 25 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
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
  80093c:	68 f0 4b 80 00       	push   $0x804bf0
  800941:	68 9c 00 00 00       	push   $0x9c
  800946:	68 dc 4b 80 00       	push   $0x804bdc
  80094b:	e8 da 0f 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800950:	e8 d1 24 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  800955:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800958:	74 17                	je     800971 <_main+0x939>
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 58 4c 80 00       	push   $0x804c58
  800962:	68 9d 00 00 00       	push   $0x9d
  800967:	68 dc 4b 80 00       	push   $0x804bdc
  80096c:	e8 b9 0f 00 00       	call   80192a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800971:	e8 b0 24 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
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
  8009ec:	68 f0 4b 80 00       	push   $0x804bf0
  8009f1:	68 a3 00 00 00       	push   $0xa3
  8009f6:	68 dc 4b 80 00       	push   $0x804bdc
  8009fb:	e8 2a 0f 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a00:	e8 21 24 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  800a05:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800a08:	74 17                	je     800a21 <_main+0x9e9>
  800a0a:	83 ec 04             	sub    $0x4,%esp
  800a0d:	68 58 4c 80 00       	push   $0x804c58
  800a12:	68 a4 00 00 00       	push   $0xa4
  800a17:	68 dc 4b 80 00       	push   $0x804bdc
  800a1c:	e8 09 0f 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a21:	e8 60 23 00 00       	call   802d86 <sys_calculate_free_frames>
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
  800a92:	e8 ef 22 00 00       	call   802d86 <sys_calculate_free_frames>
  800a97:	29 c3                	sub    %eax,%ebx
  800a99:	89 d8                	mov    %ebx,%eax
  800a9b:	83 f8 05             	cmp    $0x5,%eax
  800a9e:	74 17                	je     800ab7 <_main+0xa7f>
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 88 4c 80 00       	push   $0x804c88
  800aa8:	68 ac 00 00 00       	push   $0xac
  800aad:	68 dc 4b 80 00       	push   $0x804bdc
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
  800be8:	68 cc 4c 80 00       	push   $0x804ccc
  800bed:	68 b7 00 00 00       	push   $0xb7
  800bf2:	68 dc 4b 80 00       	push   $0x804bdc
  800bf7:	e8 2e 0d 00 00       	call   80192a <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfc:	e8 25 22 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
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
  800c7a:	68 f0 4b 80 00       	push   $0x804bf0
  800c7f:	68 bc 00 00 00       	push   $0xbc
  800c84:	68 dc 4b 80 00       	push   $0x804bdc
  800c89:	e8 9c 0c 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c8e:	e8 93 21 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  800c93:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800c96:	74 17                	je     800caf <_main+0xc77>
  800c98:	83 ec 04             	sub    $0x4,%esp
  800c9b:	68 58 4c 80 00       	push   $0x804c58
  800ca0:	68 bd 00 00 00       	push   $0xbd
  800ca5:	68 dc 4b 80 00       	push   $0x804bdc
  800caa:	e8 7b 0c 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800caf:	e8 d2 20 00 00       	call   802d86 <sys_calculate_free_frames>
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
  800d03:	e8 7e 20 00 00       	call   802d86 <sys_calculate_free_frames>
  800d08:	29 c3                	sub    %eax,%ebx
  800d0a:	89 d8                	mov    %ebx,%eax
  800d0c:	83 f8 02             	cmp    $0x2,%eax
  800d0f:	74 17                	je     800d28 <_main+0xcf0>
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	68 88 4c 80 00       	push   $0x804c88
  800d19:	68 c4 00 00 00       	push   $0xc4
  800d1e:	68 dc 4b 80 00       	push   $0x804bdc
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
  800dfe:	68 cc 4c 80 00       	push   $0x804ccc
  800e03:	68 cd 00 00 00       	push   $0xcd
  800e08:	68 dc 4b 80 00       	push   $0x804bdc
  800e0d:	e8 18 0b 00 00       	call   80192a <_panic>
	}

	{
		//Free 1st 2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800e12:	e8 6f 1f 00 00       	call   802d86 <sys_calculate_free_frames>
  800e17:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e1d:	e8 04 20 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  800e22:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[0]);
  800e28:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	e8 5d 1d 00 00       	call   802b94 <free>
  800e37:	83 c4 10             	add    $0x10,%esp

		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e3a:	e8 e7 1f 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  800e3f:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800e45:	74 17                	je     800e5e <_main+0xe26>
  800e47:	83 ec 04             	sub    $0x4,%esp
  800e4a:	68 ec 4c 80 00       	push   $0x804cec
  800e4f:	68 d6 00 00 00       	push   $0xd6
  800e54:	68 dc 4b 80 00       	push   $0x804bdc
  800e59:	e8 cc 0a 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800e5e:	e8 23 1f 00 00       	call   802d86 <sys_calculate_free_frames>
  800e63:	89 c2                	mov    %eax,%edx
  800e65:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800e6b:	29 c2                	sub    %eax,%edx
  800e6d:	89 d0                	mov    %edx,%eax
  800e6f:	83 f8 02             	cmp    $0x2,%eax
  800e72:	74 17                	je     800e8b <_main+0xe53>
  800e74:	83 ec 04             	sub    $0x4,%esp
  800e77:	68 28 4d 80 00       	push   $0x804d28
  800e7c:	68 d7 00 00 00       	push   $0xd7
  800e81:	68 dc 4b 80 00       	push   $0x804bdc
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
  800ee0:	68 74 4d 80 00       	push   $0x804d74
  800ee5:	68 dc 00 00 00       	push   $0xdc
  800eea:	68 dc 4b 80 00       	push   $0x804bdc
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
  800f42:	68 74 4d 80 00       	push   $0x804d74
  800f47:	68 de 00 00 00       	push   $0xde
  800f4c:	68 dc 4b 80 00       	push   $0x804bdc
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
  800f6c:	e8 15 1e 00 00       	call   802d86 <sys_calculate_free_frames>
  800f71:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f77:	e8 aa 1e 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  800f7c:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[1]);
  800f82:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800f88:	83 ec 0c             	sub    $0xc,%esp
  800f8b:	50                   	push   %eax
  800f8c:	e8 03 1c 00 00       	call   802b94 <free>
  800f91:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f94:	e8 8d 1e 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  800f99:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800f9f:	74 17                	je     800fb8 <_main+0xf80>
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	68 ec 4c 80 00       	push   $0x804cec
  800fa9:	68 e6 00 00 00       	push   $0xe6
  800fae:	68 dc 4b 80 00       	push   $0x804bdc
  800fb3:	e8 72 09 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fb8:	e8 c9 1d 00 00       	call   802d86 <sys_calculate_free_frames>
  800fbd:	89 c2                	mov    %eax,%edx
  800fbf:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800fc5:	29 c2                	sub    %eax,%edx
  800fc7:	89 d0                	mov    %edx,%eax
  800fc9:	83 f8 03             	cmp    $0x3,%eax
  800fcc:	74 17                	je     800fe5 <_main+0xfad>
  800fce:	83 ec 04             	sub    $0x4,%esp
  800fd1:	68 28 4d 80 00       	push   $0x804d28
  800fd6:	68 e7 00 00 00       	push   $0xe7
  800fdb:	68 dc 4b 80 00       	push   $0x804bdc
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
  80103a:	68 74 4d 80 00       	push   $0x804d74
  80103f:	68 eb 00 00 00       	push   $0xeb
  801044:	68 dc 4b 80 00       	push   $0x804bdc
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
  8010a0:	68 74 4d 80 00       	push   $0x804d74
  8010a5:	68 ed 00 00 00       	push   $0xed
  8010aa:	68 dc 4b 80 00       	push   $0x804bdc
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
  8010ca:	e8 b7 1c 00 00       	call   802d86 <sys_calculate_free_frames>
  8010cf:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8010d5:	e8 4c 1d 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  8010da:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[6]);
  8010e0:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	50                   	push   %eax
  8010ea:	e8 a5 1a 00 00       	call   802b94 <free>
  8010ef:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8010f2:	e8 2f 1d 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  8010f7:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8010fd:	74 17                	je     801116 <_main+0x10de>
  8010ff:	83 ec 04             	sub    $0x4,%esp
  801102:	68 ec 4c 80 00       	push   $0x804cec
  801107:	68 f4 00 00 00       	push   $0xf4
  80110c:	68 dc 4b 80 00       	push   $0x804bdc
  801111:	e8 14 08 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801116:	e8 6b 1c 00 00       	call   802d86 <sys_calculate_free_frames>
  80111b:	89 c2                	mov    %eax,%edx
  80111d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801123:	29 c2                	sub    %eax,%edx
  801125:	89 d0                	mov    %edx,%eax
  801127:	83 f8 04             	cmp    $0x4,%eax
  80112a:	74 17                	je     801143 <_main+0x110b>
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	68 28 4d 80 00       	push   $0x804d28
  801134:	68 f5 00 00 00       	push   $0xf5
  801139:	68 dc 4b 80 00       	push   $0x804bdc
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
  80119b:	68 74 4d 80 00       	push   $0x804d74
  8011a0:	68 f9 00 00 00       	push   $0xf9
  8011a5:	68 dc 4b 80 00       	push   $0x804bdc
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
  80120e:	68 74 4d 80 00       	push   $0x804d74
  801213:	68 fb 00 00 00       	push   $0xfb
  801218:	68 dc 4b 80 00       	push   $0x804bdc
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
  801276:	68 74 4d 80 00       	push   $0x804d74
  80127b:	68 fd 00 00 00       	push   $0xfd
  801280:	68 dc 4b 80 00       	push   $0x804bdc
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
  8012a0:	e8 e1 1a 00 00       	call   802d86 <sys_calculate_free_frames>
  8012a5:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012ab:	e8 76 1b 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  8012b0:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[4]);
  8012b6:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8012bc:	83 ec 0c             	sub    $0xc,%esp
  8012bf:	50                   	push   %eax
  8012c0:	e8 cf 18 00 00       	call   802b94 <free>
  8012c5:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8012c8:	e8 59 1b 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  8012cd:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8012d3:	74 17                	je     8012ec <_main+0x12b4>
  8012d5:	83 ec 04             	sub    $0x4,%esp
  8012d8:	68 ec 4c 80 00       	push   $0x804cec
  8012dd:	68 04 01 00 00       	push   $0x104
  8012e2:	68 dc 4b 80 00       	push   $0x804bdc
  8012e7:	e8 3e 06 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8012ec:	e8 95 1a 00 00       	call   802d86 <sys_calculate_free_frames>
  8012f1:	89 c2                	mov    %eax,%edx
  8012f3:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8012f9:	29 c2                	sub    %eax,%edx
  8012fb:	89 d0                	mov    %edx,%eax
  8012fd:	83 f8 02             	cmp    $0x2,%eax
  801300:	74 17                	je     801319 <_main+0x12e1>
  801302:	83 ec 04             	sub    $0x4,%esp
  801305:	68 28 4d 80 00       	push   $0x804d28
  80130a:	68 05 01 00 00       	push   $0x105
  80130f:	68 dc 4b 80 00       	push   $0x804bdc
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
  801371:	68 74 4d 80 00       	push   $0x804d74
  801376:	68 09 01 00 00       	push   $0x109
  80137b:	68 dc 4b 80 00       	push   $0x804bdc
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
  8013e0:	68 74 4d 80 00       	push   $0x804d74
  8013e5:	68 0b 01 00 00       	push   $0x10b
  8013ea:	68 dc 4b 80 00       	push   $0x804bdc
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
  80140a:	e8 77 19 00 00       	call   802d86 <sys_calculate_free_frames>
  80140f:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801415:	e8 0c 1a 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  80141a:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[5]);
  801420:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  801426:	83 ec 0c             	sub    $0xc,%esp
  801429:	50                   	push   %eax
  80142a:	e8 65 17 00 00       	call   802b94 <free>
  80142f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801432:	e8 ef 19 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  801437:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  80143d:	74 17                	je     801456 <_main+0x141e>
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	68 ec 4c 80 00       	push   $0x804cec
  801447:	68 12 01 00 00       	push   $0x112
  80144c:	68 dc 4b 80 00       	push   $0x804bdc
  801451:	e8 d4 04 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801456:	e8 2b 19 00 00       	call   802d86 <sys_calculate_free_frames>
  80145b:	89 c2                	mov    %eax,%edx
  80145d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801463:	39 c2                	cmp    %eax,%edx
  801465:	74 17                	je     80147e <_main+0x1446>
  801467:	83 ec 04             	sub    $0x4,%esp
  80146a:	68 28 4d 80 00       	push   $0x804d28
  80146f:	68 13 01 00 00       	push   $0x113
  801474:	68 dc 4b 80 00       	push   $0x804bdc
  801479:	e8 ac 04 00 00       	call   80192a <_panic>

		//Free 1st 2 KB
		freeFrames = sys_calculate_free_frames() ;
  80147e:	e8 03 19 00 00       	call   802d86 <sys_calculate_free_frames>
  801483:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801489:	e8 98 19 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  80148e:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[2]);
  801494:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80149a:	83 ec 0c             	sub    $0xc,%esp
  80149d:	50                   	push   %eax
  80149e:	e8 f1 16 00 00       	call   802b94 <free>
  8014a3:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8014a6:	e8 7b 19 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  8014ab:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8014b1:	74 17                	je     8014ca <_main+0x1492>
  8014b3:	83 ec 04             	sub    $0x4,%esp
  8014b6:	68 ec 4c 80 00       	push   $0x804cec
  8014bb:	68 19 01 00 00       	push   $0x119
  8014c0:	68 dc 4b 80 00       	push   $0x804bdc
  8014c5:	e8 60 04 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8014ca:	e8 b7 18 00 00       	call   802d86 <sys_calculate_free_frames>
  8014cf:	89 c2                	mov    %eax,%edx
  8014d1:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8014d7:	29 c2                	sub    %eax,%edx
  8014d9:	89 d0                	mov    %edx,%eax
  8014db:	83 f8 02             	cmp    $0x2,%eax
  8014de:	74 17                	je     8014f7 <_main+0x14bf>
  8014e0:	83 ec 04             	sub    $0x4,%esp
  8014e3:	68 28 4d 80 00       	push   $0x804d28
  8014e8:	68 1a 01 00 00       	push   $0x11a
  8014ed:	68 dc 4b 80 00       	push   $0x804bdc
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
  80154c:	68 74 4d 80 00       	push   $0x804d74
  801551:	68 1e 01 00 00       	push   $0x11e
  801556:	68 dc 4b 80 00       	push   $0x804bdc
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
  8015b5:	68 74 4d 80 00       	push   $0x804d74
  8015ba:	68 20 01 00 00       	push   $0x120
  8015bf:	68 dc 4b 80 00       	push   $0x804bdc
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
  8015df:	e8 a2 17 00 00       	call   802d86 <sys_calculate_free_frames>
  8015e4:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8015ea:	e8 37 18 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  8015ef:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[3]);
  8015f5:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  8015fb:	83 ec 0c             	sub    $0xc,%esp
  8015fe:	50                   	push   %eax
  8015ff:	e8 90 15 00 00       	call   802b94 <free>
  801604:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801607:	e8 1a 18 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  80160c:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801612:	74 17                	je     80162b <_main+0x15f3>
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	68 ec 4c 80 00       	push   $0x804cec
  80161c:	68 27 01 00 00       	push   $0x127
  801621:	68 dc 4b 80 00       	push   $0x804bdc
  801626:	e8 ff 02 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80162b:	e8 56 17 00 00       	call   802d86 <sys_calculate_free_frames>
  801630:	89 c2                	mov    %eax,%edx
  801632:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801638:	39 c2                	cmp    %eax,%edx
  80163a:	74 17                	je     801653 <_main+0x161b>
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 28 4d 80 00       	push   $0x804d28
  801644:	68 28 01 00 00       	push   $0x128
  801649:	68 dc 4b 80 00       	push   $0x804bdc
  80164e:	e8 d7 02 00 00       	call   80192a <_panic>


		//Free last 14 KB
		freeFrames = sys_calculate_free_frames() ;
  801653:	e8 2e 17 00 00       	call   802d86 <sys_calculate_free_frames>
  801658:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80165e:	e8 c3 17 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  801663:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[7]);
  801669:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80166f:	83 ec 0c             	sub    $0xc,%esp
  801672:	50                   	push   %eax
  801673:	e8 1c 15 00 00       	call   802b94 <free>
  801678:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80167b:	e8 a6 17 00 00       	call   802e26 <sys_pf_calculate_allocated_pages>
  801680:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801686:	74 17                	je     80169f <_main+0x1667>
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	68 ec 4c 80 00       	push   $0x804cec
  801690:	68 2f 01 00 00       	push   $0x12f
  801695:	68 dc 4b 80 00       	push   $0x804bdc
  80169a:	e8 8b 02 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80169f:	e8 e2 16 00 00       	call   802d86 <sys_calculate_free_frames>
  8016a4:	89 c2                	mov    %eax,%edx
  8016a6:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8016ac:	29 c2                	sub    %eax,%edx
  8016ae:	89 d0                	mov    %edx,%eax
  8016b0:	83 f8 03             	cmp    $0x3,%eax
  8016b3:	74 17                	je     8016cc <_main+0x1694>
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 28 4d 80 00       	push   $0x804d28
  8016bd:	68 30 01 00 00       	push   $0x130
  8016c2:	68 dc 4b 80 00       	push   $0x804bdc
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
  801721:	68 74 4d 80 00       	push   $0x804d74
  801726:	68 34 01 00 00       	push   $0x134
  80172b:	68 dc 4b 80 00       	push   $0x804bdc
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
  801787:	68 74 4d 80 00       	push   $0x804d74
  80178c:	68 36 01 00 00       	push   $0x136
  801791:	68 dc 4b 80 00       	push   $0x804bdc
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
  8017b1:	e8 d0 15 00 00       	call   802d86 <sys_calculate_free_frames>
  8017b6:	89 c2                	mov    %eax,%edx
  8017b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017bb:	39 c2                	cmp    %eax,%edx
  8017bd:	74 17                	je     8017d6 <_main+0x179e>
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 98 4d 80 00       	push   $0x804d98
  8017c7:	68 39 01 00 00       	push   $0x139
  8017cc:	68 dc 4b 80 00       	push   $0x804bdc
  8017d1:	e8 54 01 00 00       	call   80192a <_panic>
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	68 cc 4d 80 00       	push   $0x804dcc
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
  8017f4:	e8 6d 18 00 00       	call   803066 <sys_getenvindex>
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
  80185f:	e8 0f 16 00 00       	call   802e73 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801864:	83 ec 0c             	sub    $0xc,%esp
  801867:	68 20 4e 80 00       	push   $0x804e20
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
  80188f:	68 48 4e 80 00       	push   $0x804e48
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
  8018c0:	68 70 4e 80 00       	push   $0x804e70
  8018c5:	e8 14 03 00 00       	call   801bde <cprintf>
  8018ca:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8018cd:	a1 20 60 80 00       	mov    0x806020,%eax
  8018d2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8018d8:	83 ec 08             	sub    $0x8,%esp
  8018db:	50                   	push   %eax
  8018dc:	68 c8 4e 80 00       	push   $0x804ec8
  8018e1:	e8 f8 02 00 00       	call   801bde <cprintf>
  8018e6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8018e9:	83 ec 0c             	sub    $0xc,%esp
  8018ec:	68 20 4e 80 00       	push   $0x804e20
  8018f1:	e8 e8 02 00 00       	call   801bde <cprintf>
  8018f6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8018f9:	e8 8f 15 00 00       	call   802e8d <sys_enable_interrupt>

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
  801911:	e8 1c 17 00 00       	call   803032 <sys_destroy_env>
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
  801922:	e8 71 17 00 00       	call   803098 <sys_exit_env>
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
  80194b:	68 dc 4e 80 00       	push   $0x804edc
  801950:	e8 89 02 00 00       	call   801bde <cprintf>
  801955:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801958:	a1 00 60 80 00       	mov    0x806000,%eax
  80195d:	ff 75 0c             	pushl  0xc(%ebp)
  801960:	ff 75 08             	pushl  0x8(%ebp)
  801963:	50                   	push   %eax
  801964:	68 e1 4e 80 00       	push   $0x804ee1
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
  801988:	68 fd 4e 80 00       	push   $0x804efd
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
  8019b4:	68 00 4f 80 00       	push   $0x804f00
  8019b9:	6a 26                	push   $0x26
  8019bb:	68 4c 4f 80 00       	push   $0x804f4c
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
  801a86:	68 58 4f 80 00       	push   $0x804f58
  801a8b:	6a 3a                	push   $0x3a
  801a8d:	68 4c 4f 80 00       	push   $0x804f4c
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
  801af6:	68 ac 4f 80 00       	push   $0x804fac
  801afb:	6a 44                	push   $0x44
  801afd:	68 4c 4f 80 00       	push   $0x804f4c
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
  801b50:	e8 70 11 00 00       	call   802cc5 <sys_cputs>
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
  801bc7:	e8 f9 10 00 00       	call   802cc5 <sys_cputs>
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
  801c11:	e8 5d 12 00 00       	call   802e73 <sys_disable_interrupt>
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
  801c31:	e8 57 12 00 00       	call   802e8d <sys_enable_interrupt>
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
  801c7b:	e8 c8 2c 00 00       	call   804948 <__udivdi3>
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
  801ccb:	e8 88 2d 00 00       	call   804a58 <__umoddi3>
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	05 14 52 80 00       	add    $0x805214,%eax
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
  801e26:	8b 04 85 38 52 80 00 	mov    0x805238(,%eax,4),%eax
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
  801f07:	8b 34 9d 80 50 80 00 	mov    0x805080(,%ebx,4),%esi
  801f0e:	85 f6                	test   %esi,%esi
  801f10:	75 19                	jne    801f2b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801f12:	53                   	push   %ebx
  801f13:	68 25 52 80 00       	push   $0x805225
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
  801f2c:	68 2e 52 80 00       	push   $0x80522e
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
  801f59:	be 31 52 80 00       	mov    $0x805231,%esi
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
  80297f:	68 90 53 80 00       	push   $0x805390
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
  802a4f:	e8 b5 03 00 00       	call   802e09 <sys_allocate_chunk>
  802a54:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802a57:	a1 20 61 80 00       	mov    0x806120,%eax
  802a5c:	83 ec 0c             	sub    $0xc,%esp
  802a5f:	50                   	push   %eax
  802a60:	e8 2a 0a 00 00       	call   80348f <initialize_MemBlocksList>
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
  802a8d:	68 b5 53 80 00       	push   $0x8053b5
  802a92:	6a 33                	push   $0x33
  802a94:	68 d3 53 80 00       	push   $0x8053d3
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
  802b0c:	68 e0 53 80 00       	push   $0x8053e0
  802b11:	6a 34                	push   $0x34
  802b13:	68 d3 53 80 00       	push   $0x8053d3
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
  802b81:	68 04 54 80 00       	push   $0x805404
  802b86:	6a 46                	push   $0x46
  802b88:	68 d3 53 80 00       	push   $0x8053d3
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
  802b9d:	68 2c 54 80 00       	push   $0x80542c
  802ba2:	6a 61                	push   $0x61
  802ba4:	68 d3 53 80 00       	push   $0x8053d3
  802ba9:	e8 7c ed ff ff       	call   80192a <_panic>

00802bae <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802bae:	55                   	push   %ebp
  802baf:	89 e5                	mov    %esp,%ebp
  802bb1:	83 ec 18             	sub    $0x18,%esp
  802bb4:	8b 45 10             	mov    0x10(%ebp),%eax
  802bb7:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802bba:	e8 a9 fd ff ff       	call   802968 <InitializeUHeap>
	if (size == 0) return NULL ;
  802bbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bc3:	75 07                	jne    802bcc <smalloc+0x1e>
  802bc5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bca:	eb 14                	jmp    802be0 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  802bcc:	83 ec 04             	sub    $0x4,%esp
  802bcf:	68 50 54 80 00       	push   $0x805450
  802bd4:	6a 76                	push   $0x76
  802bd6:	68 d3 53 80 00       	push   $0x8053d3
  802bdb:	e8 4a ed ff ff       	call   80192a <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802be0:	c9                   	leave  
  802be1:	c3                   	ret    

00802be2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802be2:	55                   	push   %ebp
  802be3:	89 e5                	mov    %esp,%ebp
  802be5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802be8:	e8 7b fd ff ff       	call   802968 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802bed:	83 ec 04             	sub    $0x4,%esp
  802bf0:	68 78 54 80 00       	push   $0x805478
  802bf5:	68 93 00 00 00       	push   $0x93
  802bfa:	68 d3 53 80 00       	push   $0x8053d3
  802bff:	e8 26 ed ff ff       	call   80192a <_panic>

00802c04 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802c04:	55                   	push   %ebp
  802c05:	89 e5                	mov    %esp,%ebp
  802c07:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802c0a:	e8 59 fd ff ff       	call   802968 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802c0f:	83 ec 04             	sub    $0x4,%esp
  802c12:	68 9c 54 80 00       	push   $0x80549c
  802c17:	68 c5 00 00 00       	push   $0xc5
  802c1c:	68 d3 53 80 00       	push   $0x8053d3
  802c21:	e8 04 ed ff ff       	call   80192a <_panic>

00802c26 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802c26:	55                   	push   %ebp
  802c27:	89 e5                	mov    %esp,%ebp
  802c29:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802c2c:	83 ec 04             	sub    $0x4,%esp
  802c2f:	68 c4 54 80 00       	push   $0x8054c4
  802c34:	68 d9 00 00 00       	push   $0xd9
  802c39:	68 d3 53 80 00       	push   $0x8053d3
  802c3e:	e8 e7 ec ff ff       	call   80192a <_panic>

00802c43 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802c43:	55                   	push   %ebp
  802c44:	89 e5                	mov    %esp,%ebp
  802c46:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802c49:	83 ec 04             	sub    $0x4,%esp
  802c4c:	68 e8 54 80 00       	push   $0x8054e8
  802c51:	68 e4 00 00 00       	push   $0xe4
  802c56:	68 d3 53 80 00       	push   $0x8053d3
  802c5b:	e8 ca ec ff ff       	call   80192a <_panic>

00802c60 <shrink>:

}
void shrink(uint32 newSize)
{
  802c60:	55                   	push   %ebp
  802c61:	89 e5                	mov    %esp,%ebp
  802c63:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802c66:	83 ec 04             	sub    $0x4,%esp
  802c69:	68 e8 54 80 00       	push   $0x8054e8
  802c6e:	68 e9 00 00 00       	push   $0xe9
  802c73:	68 d3 53 80 00       	push   $0x8053d3
  802c78:	e8 ad ec ff ff       	call   80192a <_panic>

00802c7d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802c7d:	55                   	push   %ebp
  802c7e:	89 e5                	mov    %esp,%ebp
  802c80:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802c83:	83 ec 04             	sub    $0x4,%esp
  802c86:	68 e8 54 80 00       	push   $0x8054e8
  802c8b:	68 ee 00 00 00       	push   $0xee
  802c90:	68 d3 53 80 00       	push   $0x8053d3
  802c95:	e8 90 ec ff ff       	call   80192a <_panic>

00802c9a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802c9a:	55                   	push   %ebp
  802c9b:	89 e5                	mov    %esp,%ebp
  802c9d:	57                   	push   %edi
  802c9e:	56                   	push   %esi
  802c9f:	53                   	push   %ebx
  802ca0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ca9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802cac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802caf:	8b 7d 18             	mov    0x18(%ebp),%edi
  802cb2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802cb5:	cd 30                	int    $0x30
  802cb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802cbd:	83 c4 10             	add    $0x10,%esp
  802cc0:	5b                   	pop    %ebx
  802cc1:	5e                   	pop    %esi
  802cc2:	5f                   	pop    %edi
  802cc3:	5d                   	pop    %ebp
  802cc4:	c3                   	ret    

00802cc5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802cc5:	55                   	push   %ebp
  802cc6:	89 e5                	mov    %esp,%ebp
  802cc8:	83 ec 04             	sub    $0x4,%esp
  802ccb:	8b 45 10             	mov    0x10(%ebp),%eax
  802cce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802cd1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd8:	6a 00                	push   $0x0
  802cda:	6a 00                	push   $0x0
  802cdc:	52                   	push   %edx
  802cdd:	ff 75 0c             	pushl  0xc(%ebp)
  802ce0:	50                   	push   %eax
  802ce1:	6a 00                	push   $0x0
  802ce3:	e8 b2 ff ff ff       	call   802c9a <syscall>
  802ce8:	83 c4 18             	add    $0x18,%esp
}
  802ceb:	90                   	nop
  802cec:	c9                   	leave  
  802ced:	c3                   	ret    

00802cee <sys_cgetc>:

int
sys_cgetc(void)
{
  802cee:	55                   	push   %ebp
  802cef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802cf1:	6a 00                	push   $0x0
  802cf3:	6a 00                	push   $0x0
  802cf5:	6a 00                	push   $0x0
  802cf7:	6a 00                	push   $0x0
  802cf9:	6a 00                	push   $0x0
  802cfb:	6a 01                	push   $0x1
  802cfd:	e8 98 ff ff ff       	call   802c9a <syscall>
  802d02:	83 c4 18             	add    $0x18,%esp
}
  802d05:	c9                   	leave  
  802d06:	c3                   	ret    

00802d07 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802d07:	55                   	push   %ebp
  802d08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802d0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d10:	6a 00                	push   $0x0
  802d12:	6a 00                	push   $0x0
  802d14:	6a 00                	push   $0x0
  802d16:	52                   	push   %edx
  802d17:	50                   	push   %eax
  802d18:	6a 05                	push   $0x5
  802d1a:	e8 7b ff ff ff       	call   802c9a <syscall>
  802d1f:	83 c4 18             	add    $0x18,%esp
}
  802d22:	c9                   	leave  
  802d23:	c3                   	ret    

00802d24 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802d24:	55                   	push   %ebp
  802d25:	89 e5                	mov    %esp,%ebp
  802d27:	56                   	push   %esi
  802d28:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802d29:	8b 75 18             	mov    0x18(%ebp),%esi
  802d2c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	56                   	push   %esi
  802d39:	53                   	push   %ebx
  802d3a:	51                   	push   %ecx
  802d3b:	52                   	push   %edx
  802d3c:	50                   	push   %eax
  802d3d:	6a 06                	push   $0x6
  802d3f:	e8 56 ff ff ff       	call   802c9a <syscall>
  802d44:	83 c4 18             	add    $0x18,%esp
}
  802d47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d4a:	5b                   	pop    %ebx
  802d4b:	5e                   	pop    %esi
  802d4c:	5d                   	pop    %ebp
  802d4d:	c3                   	ret    

00802d4e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802d4e:	55                   	push   %ebp
  802d4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802d51:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	6a 00                	push   $0x0
  802d59:	6a 00                	push   $0x0
  802d5b:	6a 00                	push   $0x0
  802d5d:	52                   	push   %edx
  802d5e:	50                   	push   %eax
  802d5f:	6a 07                	push   $0x7
  802d61:	e8 34 ff ff ff       	call   802c9a <syscall>
  802d66:	83 c4 18             	add    $0x18,%esp
}
  802d69:	c9                   	leave  
  802d6a:	c3                   	ret    

00802d6b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802d6b:	55                   	push   %ebp
  802d6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802d6e:	6a 00                	push   $0x0
  802d70:	6a 00                	push   $0x0
  802d72:	6a 00                	push   $0x0
  802d74:	ff 75 0c             	pushl  0xc(%ebp)
  802d77:	ff 75 08             	pushl  0x8(%ebp)
  802d7a:	6a 08                	push   $0x8
  802d7c:	e8 19 ff ff ff       	call   802c9a <syscall>
  802d81:	83 c4 18             	add    $0x18,%esp
}
  802d84:	c9                   	leave  
  802d85:	c3                   	ret    

00802d86 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802d86:	55                   	push   %ebp
  802d87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802d89:	6a 00                	push   $0x0
  802d8b:	6a 00                	push   $0x0
  802d8d:	6a 00                	push   $0x0
  802d8f:	6a 00                	push   $0x0
  802d91:	6a 00                	push   $0x0
  802d93:	6a 09                	push   $0x9
  802d95:	e8 00 ff ff ff       	call   802c9a <syscall>
  802d9a:	83 c4 18             	add    $0x18,%esp
}
  802d9d:	c9                   	leave  
  802d9e:	c3                   	ret    

00802d9f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802d9f:	55                   	push   %ebp
  802da0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802da2:	6a 00                	push   $0x0
  802da4:	6a 00                	push   $0x0
  802da6:	6a 00                	push   $0x0
  802da8:	6a 00                	push   $0x0
  802daa:	6a 00                	push   $0x0
  802dac:	6a 0a                	push   $0xa
  802dae:	e8 e7 fe ff ff       	call   802c9a <syscall>
  802db3:	83 c4 18             	add    $0x18,%esp
}
  802db6:	c9                   	leave  
  802db7:	c3                   	ret    

00802db8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802db8:	55                   	push   %ebp
  802db9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802dbb:	6a 00                	push   $0x0
  802dbd:	6a 00                	push   $0x0
  802dbf:	6a 00                	push   $0x0
  802dc1:	6a 00                	push   $0x0
  802dc3:	6a 00                	push   $0x0
  802dc5:	6a 0b                	push   $0xb
  802dc7:	e8 ce fe ff ff       	call   802c9a <syscall>
  802dcc:	83 c4 18             	add    $0x18,%esp
}
  802dcf:	c9                   	leave  
  802dd0:	c3                   	ret    

00802dd1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802dd1:	55                   	push   %ebp
  802dd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802dd4:	6a 00                	push   $0x0
  802dd6:	6a 00                	push   $0x0
  802dd8:	6a 00                	push   $0x0
  802dda:	ff 75 0c             	pushl  0xc(%ebp)
  802ddd:	ff 75 08             	pushl  0x8(%ebp)
  802de0:	6a 0f                	push   $0xf
  802de2:	e8 b3 fe ff ff       	call   802c9a <syscall>
  802de7:	83 c4 18             	add    $0x18,%esp
	return;
  802dea:	90                   	nop
}
  802deb:	c9                   	leave  
  802dec:	c3                   	ret    

00802ded <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802ded:	55                   	push   %ebp
  802dee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802df0:	6a 00                	push   $0x0
  802df2:	6a 00                	push   $0x0
  802df4:	6a 00                	push   $0x0
  802df6:	ff 75 0c             	pushl  0xc(%ebp)
  802df9:	ff 75 08             	pushl  0x8(%ebp)
  802dfc:	6a 10                	push   $0x10
  802dfe:	e8 97 fe ff ff       	call   802c9a <syscall>
  802e03:	83 c4 18             	add    $0x18,%esp
	return ;
  802e06:	90                   	nop
}
  802e07:	c9                   	leave  
  802e08:	c3                   	ret    

00802e09 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802e09:	55                   	push   %ebp
  802e0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802e0c:	6a 00                	push   $0x0
  802e0e:	6a 00                	push   $0x0
  802e10:	ff 75 10             	pushl  0x10(%ebp)
  802e13:	ff 75 0c             	pushl  0xc(%ebp)
  802e16:	ff 75 08             	pushl  0x8(%ebp)
  802e19:	6a 11                	push   $0x11
  802e1b:	e8 7a fe ff ff       	call   802c9a <syscall>
  802e20:	83 c4 18             	add    $0x18,%esp
	return ;
  802e23:	90                   	nop
}
  802e24:	c9                   	leave  
  802e25:	c3                   	ret    

00802e26 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802e26:	55                   	push   %ebp
  802e27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802e29:	6a 00                	push   $0x0
  802e2b:	6a 00                	push   $0x0
  802e2d:	6a 00                	push   $0x0
  802e2f:	6a 00                	push   $0x0
  802e31:	6a 00                	push   $0x0
  802e33:	6a 0c                	push   $0xc
  802e35:	e8 60 fe ff ff       	call   802c9a <syscall>
  802e3a:	83 c4 18             	add    $0x18,%esp
}
  802e3d:	c9                   	leave  
  802e3e:	c3                   	ret    

00802e3f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802e3f:	55                   	push   %ebp
  802e40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802e42:	6a 00                	push   $0x0
  802e44:	6a 00                	push   $0x0
  802e46:	6a 00                	push   $0x0
  802e48:	6a 00                	push   $0x0
  802e4a:	ff 75 08             	pushl  0x8(%ebp)
  802e4d:	6a 0d                	push   $0xd
  802e4f:	e8 46 fe ff ff       	call   802c9a <syscall>
  802e54:	83 c4 18             	add    $0x18,%esp
}
  802e57:	c9                   	leave  
  802e58:	c3                   	ret    

00802e59 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802e59:	55                   	push   %ebp
  802e5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802e5c:	6a 00                	push   $0x0
  802e5e:	6a 00                	push   $0x0
  802e60:	6a 00                	push   $0x0
  802e62:	6a 00                	push   $0x0
  802e64:	6a 00                	push   $0x0
  802e66:	6a 0e                	push   $0xe
  802e68:	e8 2d fe ff ff       	call   802c9a <syscall>
  802e6d:	83 c4 18             	add    $0x18,%esp
}
  802e70:	90                   	nop
  802e71:	c9                   	leave  
  802e72:	c3                   	ret    

00802e73 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802e73:	55                   	push   %ebp
  802e74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802e76:	6a 00                	push   $0x0
  802e78:	6a 00                	push   $0x0
  802e7a:	6a 00                	push   $0x0
  802e7c:	6a 00                	push   $0x0
  802e7e:	6a 00                	push   $0x0
  802e80:	6a 13                	push   $0x13
  802e82:	e8 13 fe ff ff       	call   802c9a <syscall>
  802e87:	83 c4 18             	add    $0x18,%esp
}
  802e8a:	90                   	nop
  802e8b:	c9                   	leave  
  802e8c:	c3                   	ret    

00802e8d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802e8d:	55                   	push   %ebp
  802e8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802e90:	6a 00                	push   $0x0
  802e92:	6a 00                	push   $0x0
  802e94:	6a 00                	push   $0x0
  802e96:	6a 00                	push   $0x0
  802e98:	6a 00                	push   $0x0
  802e9a:	6a 14                	push   $0x14
  802e9c:	e8 f9 fd ff ff       	call   802c9a <syscall>
  802ea1:	83 c4 18             	add    $0x18,%esp
}
  802ea4:	90                   	nop
  802ea5:	c9                   	leave  
  802ea6:	c3                   	ret    

00802ea7 <sys_cputc>:


void
sys_cputc(const char c)
{
  802ea7:	55                   	push   %ebp
  802ea8:	89 e5                	mov    %esp,%ebp
  802eaa:	83 ec 04             	sub    $0x4,%esp
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802eb3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802eb7:	6a 00                	push   $0x0
  802eb9:	6a 00                	push   $0x0
  802ebb:	6a 00                	push   $0x0
  802ebd:	6a 00                	push   $0x0
  802ebf:	50                   	push   %eax
  802ec0:	6a 15                	push   $0x15
  802ec2:	e8 d3 fd ff ff       	call   802c9a <syscall>
  802ec7:	83 c4 18             	add    $0x18,%esp
}
  802eca:	90                   	nop
  802ecb:	c9                   	leave  
  802ecc:	c3                   	ret    

00802ecd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802ecd:	55                   	push   %ebp
  802ece:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802ed0:	6a 00                	push   $0x0
  802ed2:	6a 00                	push   $0x0
  802ed4:	6a 00                	push   $0x0
  802ed6:	6a 00                	push   $0x0
  802ed8:	6a 00                	push   $0x0
  802eda:	6a 16                	push   $0x16
  802edc:	e8 b9 fd ff ff       	call   802c9a <syscall>
  802ee1:	83 c4 18             	add    $0x18,%esp
}
  802ee4:	90                   	nop
  802ee5:	c9                   	leave  
  802ee6:	c3                   	ret    

00802ee7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802ee7:	55                   	push   %ebp
  802ee8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	6a 00                	push   $0x0
  802eef:	6a 00                	push   $0x0
  802ef1:	6a 00                	push   $0x0
  802ef3:	ff 75 0c             	pushl  0xc(%ebp)
  802ef6:	50                   	push   %eax
  802ef7:	6a 17                	push   $0x17
  802ef9:	e8 9c fd ff ff       	call   802c9a <syscall>
  802efe:	83 c4 18             	add    $0x18,%esp
}
  802f01:	c9                   	leave  
  802f02:	c3                   	ret    

00802f03 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802f03:	55                   	push   %ebp
  802f04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802f06:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	6a 00                	push   $0x0
  802f0e:	6a 00                	push   $0x0
  802f10:	6a 00                	push   $0x0
  802f12:	52                   	push   %edx
  802f13:	50                   	push   %eax
  802f14:	6a 1a                	push   $0x1a
  802f16:	e8 7f fd ff ff       	call   802c9a <syscall>
  802f1b:	83 c4 18             	add    $0x18,%esp
}
  802f1e:	c9                   	leave  
  802f1f:	c3                   	ret    

00802f20 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802f20:	55                   	push   %ebp
  802f21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802f23:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	6a 00                	push   $0x0
  802f2b:	6a 00                	push   $0x0
  802f2d:	6a 00                	push   $0x0
  802f2f:	52                   	push   %edx
  802f30:	50                   	push   %eax
  802f31:	6a 18                	push   $0x18
  802f33:	e8 62 fd ff ff       	call   802c9a <syscall>
  802f38:	83 c4 18             	add    $0x18,%esp
}
  802f3b:	90                   	nop
  802f3c:	c9                   	leave  
  802f3d:	c3                   	ret    

00802f3e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802f3e:	55                   	push   %ebp
  802f3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802f41:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	6a 00                	push   $0x0
  802f49:	6a 00                	push   $0x0
  802f4b:	6a 00                	push   $0x0
  802f4d:	52                   	push   %edx
  802f4e:	50                   	push   %eax
  802f4f:	6a 19                	push   $0x19
  802f51:	e8 44 fd ff ff       	call   802c9a <syscall>
  802f56:	83 c4 18             	add    $0x18,%esp
}
  802f59:	90                   	nop
  802f5a:	c9                   	leave  
  802f5b:	c3                   	ret    

00802f5c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802f5c:	55                   	push   %ebp
  802f5d:	89 e5                	mov    %esp,%ebp
  802f5f:	83 ec 04             	sub    $0x4,%esp
  802f62:	8b 45 10             	mov    0x10(%ebp),%eax
  802f65:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802f68:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802f6b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	6a 00                	push   $0x0
  802f74:	51                   	push   %ecx
  802f75:	52                   	push   %edx
  802f76:	ff 75 0c             	pushl  0xc(%ebp)
  802f79:	50                   	push   %eax
  802f7a:	6a 1b                	push   $0x1b
  802f7c:	e8 19 fd ff ff       	call   802c9a <syscall>
  802f81:	83 c4 18             	add    $0x18,%esp
}
  802f84:	c9                   	leave  
  802f85:	c3                   	ret    

00802f86 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802f86:	55                   	push   %ebp
  802f87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802f89:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8f:	6a 00                	push   $0x0
  802f91:	6a 00                	push   $0x0
  802f93:	6a 00                	push   $0x0
  802f95:	52                   	push   %edx
  802f96:	50                   	push   %eax
  802f97:	6a 1c                	push   $0x1c
  802f99:	e8 fc fc ff ff       	call   802c9a <syscall>
  802f9e:	83 c4 18             	add    $0x18,%esp
}
  802fa1:	c9                   	leave  
  802fa2:	c3                   	ret    

00802fa3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802fa3:	55                   	push   %ebp
  802fa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802fa6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	6a 00                	push   $0x0
  802fb1:	6a 00                	push   $0x0
  802fb3:	51                   	push   %ecx
  802fb4:	52                   	push   %edx
  802fb5:	50                   	push   %eax
  802fb6:	6a 1d                	push   $0x1d
  802fb8:	e8 dd fc ff ff       	call   802c9a <syscall>
  802fbd:	83 c4 18             	add    $0x18,%esp
}
  802fc0:	c9                   	leave  
  802fc1:	c3                   	ret    

00802fc2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802fc2:	55                   	push   %ebp
  802fc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	6a 00                	push   $0x0
  802fcd:	6a 00                	push   $0x0
  802fcf:	6a 00                	push   $0x0
  802fd1:	52                   	push   %edx
  802fd2:	50                   	push   %eax
  802fd3:	6a 1e                	push   $0x1e
  802fd5:	e8 c0 fc ff ff       	call   802c9a <syscall>
  802fda:	83 c4 18             	add    $0x18,%esp
}
  802fdd:	c9                   	leave  
  802fde:	c3                   	ret    

00802fdf <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802fdf:	55                   	push   %ebp
  802fe0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802fe2:	6a 00                	push   $0x0
  802fe4:	6a 00                	push   $0x0
  802fe6:	6a 00                	push   $0x0
  802fe8:	6a 00                	push   $0x0
  802fea:	6a 00                	push   $0x0
  802fec:	6a 1f                	push   $0x1f
  802fee:	e8 a7 fc ff ff       	call   802c9a <syscall>
  802ff3:	83 c4 18             	add    $0x18,%esp
}
  802ff6:	c9                   	leave  
  802ff7:	c3                   	ret    

00802ff8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802ff8:	55                   	push   %ebp
  802ff9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	6a 00                	push   $0x0
  803000:	ff 75 14             	pushl  0x14(%ebp)
  803003:	ff 75 10             	pushl  0x10(%ebp)
  803006:	ff 75 0c             	pushl  0xc(%ebp)
  803009:	50                   	push   %eax
  80300a:	6a 20                	push   $0x20
  80300c:	e8 89 fc ff ff       	call   802c9a <syscall>
  803011:	83 c4 18             	add    $0x18,%esp
}
  803014:	c9                   	leave  
  803015:	c3                   	ret    

00803016 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  803016:	55                   	push   %ebp
  803017:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803019:	8b 45 08             	mov    0x8(%ebp),%eax
  80301c:	6a 00                	push   $0x0
  80301e:	6a 00                	push   $0x0
  803020:	6a 00                	push   $0x0
  803022:	6a 00                	push   $0x0
  803024:	50                   	push   %eax
  803025:	6a 21                	push   $0x21
  803027:	e8 6e fc ff ff       	call   802c9a <syscall>
  80302c:	83 c4 18             	add    $0x18,%esp
}
  80302f:	90                   	nop
  803030:	c9                   	leave  
  803031:	c3                   	ret    

00803032 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803032:	55                   	push   %ebp
  803033:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803035:	8b 45 08             	mov    0x8(%ebp),%eax
  803038:	6a 00                	push   $0x0
  80303a:	6a 00                	push   $0x0
  80303c:	6a 00                	push   $0x0
  80303e:	6a 00                	push   $0x0
  803040:	50                   	push   %eax
  803041:	6a 22                	push   $0x22
  803043:	e8 52 fc ff ff       	call   802c9a <syscall>
  803048:	83 c4 18             	add    $0x18,%esp
}
  80304b:	c9                   	leave  
  80304c:	c3                   	ret    

0080304d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80304d:	55                   	push   %ebp
  80304e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803050:	6a 00                	push   $0x0
  803052:	6a 00                	push   $0x0
  803054:	6a 00                	push   $0x0
  803056:	6a 00                	push   $0x0
  803058:	6a 00                	push   $0x0
  80305a:	6a 02                	push   $0x2
  80305c:	e8 39 fc ff ff       	call   802c9a <syscall>
  803061:	83 c4 18             	add    $0x18,%esp
}
  803064:	c9                   	leave  
  803065:	c3                   	ret    

00803066 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803066:	55                   	push   %ebp
  803067:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803069:	6a 00                	push   $0x0
  80306b:	6a 00                	push   $0x0
  80306d:	6a 00                	push   $0x0
  80306f:	6a 00                	push   $0x0
  803071:	6a 00                	push   $0x0
  803073:	6a 03                	push   $0x3
  803075:	e8 20 fc ff ff       	call   802c9a <syscall>
  80307a:	83 c4 18             	add    $0x18,%esp
}
  80307d:	c9                   	leave  
  80307e:	c3                   	ret    

0080307f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80307f:	55                   	push   %ebp
  803080:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803082:	6a 00                	push   $0x0
  803084:	6a 00                	push   $0x0
  803086:	6a 00                	push   $0x0
  803088:	6a 00                	push   $0x0
  80308a:	6a 00                	push   $0x0
  80308c:	6a 04                	push   $0x4
  80308e:	e8 07 fc ff ff       	call   802c9a <syscall>
  803093:	83 c4 18             	add    $0x18,%esp
}
  803096:	c9                   	leave  
  803097:	c3                   	ret    

00803098 <sys_exit_env>:


void sys_exit_env(void)
{
  803098:	55                   	push   %ebp
  803099:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80309b:	6a 00                	push   $0x0
  80309d:	6a 00                	push   $0x0
  80309f:	6a 00                	push   $0x0
  8030a1:	6a 00                	push   $0x0
  8030a3:	6a 00                	push   $0x0
  8030a5:	6a 23                	push   $0x23
  8030a7:	e8 ee fb ff ff       	call   802c9a <syscall>
  8030ac:	83 c4 18             	add    $0x18,%esp
}
  8030af:	90                   	nop
  8030b0:	c9                   	leave  
  8030b1:	c3                   	ret    

008030b2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8030b2:	55                   	push   %ebp
  8030b3:	89 e5                	mov    %esp,%ebp
  8030b5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8030b8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8030bb:	8d 50 04             	lea    0x4(%eax),%edx
  8030be:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8030c1:	6a 00                	push   $0x0
  8030c3:	6a 00                	push   $0x0
  8030c5:	6a 00                	push   $0x0
  8030c7:	52                   	push   %edx
  8030c8:	50                   	push   %eax
  8030c9:	6a 24                	push   $0x24
  8030cb:	e8 ca fb ff ff       	call   802c9a <syscall>
  8030d0:	83 c4 18             	add    $0x18,%esp
	return result;
  8030d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8030d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8030d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030dc:	89 01                	mov    %eax,(%ecx)
  8030de:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8030e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e4:	c9                   	leave  
  8030e5:	c2 04 00             	ret    $0x4

008030e8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8030e8:	55                   	push   %ebp
  8030e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8030eb:	6a 00                	push   $0x0
  8030ed:	6a 00                	push   $0x0
  8030ef:	ff 75 10             	pushl  0x10(%ebp)
  8030f2:	ff 75 0c             	pushl  0xc(%ebp)
  8030f5:	ff 75 08             	pushl  0x8(%ebp)
  8030f8:	6a 12                	push   $0x12
  8030fa:	e8 9b fb ff ff       	call   802c9a <syscall>
  8030ff:	83 c4 18             	add    $0x18,%esp
	return ;
  803102:	90                   	nop
}
  803103:	c9                   	leave  
  803104:	c3                   	ret    

00803105 <sys_rcr2>:
uint32 sys_rcr2()
{
  803105:	55                   	push   %ebp
  803106:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803108:	6a 00                	push   $0x0
  80310a:	6a 00                	push   $0x0
  80310c:	6a 00                	push   $0x0
  80310e:	6a 00                	push   $0x0
  803110:	6a 00                	push   $0x0
  803112:	6a 25                	push   $0x25
  803114:	e8 81 fb ff ff       	call   802c9a <syscall>
  803119:	83 c4 18             	add    $0x18,%esp
}
  80311c:	c9                   	leave  
  80311d:	c3                   	ret    

0080311e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80311e:	55                   	push   %ebp
  80311f:	89 e5                	mov    %esp,%ebp
  803121:	83 ec 04             	sub    $0x4,%esp
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80312a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80312e:	6a 00                	push   $0x0
  803130:	6a 00                	push   $0x0
  803132:	6a 00                	push   $0x0
  803134:	6a 00                	push   $0x0
  803136:	50                   	push   %eax
  803137:	6a 26                	push   $0x26
  803139:	e8 5c fb ff ff       	call   802c9a <syscall>
  80313e:	83 c4 18             	add    $0x18,%esp
	return ;
  803141:	90                   	nop
}
  803142:	c9                   	leave  
  803143:	c3                   	ret    

00803144 <rsttst>:
void rsttst()
{
  803144:	55                   	push   %ebp
  803145:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803147:	6a 00                	push   $0x0
  803149:	6a 00                	push   $0x0
  80314b:	6a 00                	push   $0x0
  80314d:	6a 00                	push   $0x0
  80314f:	6a 00                	push   $0x0
  803151:	6a 28                	push   $0x28
  803153:	e8 42 fb ff ff       	call   802c9a <syscall>
  803158:	83 c4 18             	add    $0x18,%esp
	return ;
  80315b:	90                   	nop
}
  80315c:	c9                   	leave  
  80315d:	c3                   	ret    

0080315e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80315e:	55                   	push   %ebp
  80315f:	89 e5                	mov    %esp,%ebp
  803161:	83 ec 04             	sub    $0x4,%esp
  803164:	8b 45 14             	mov    0x14(%ebp),%eax
  803167:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80316a:	8b 55 18             	mov    0x18(%ebp),%edx
  80316d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803171:	52                   	push   %edx
  803172:	50                   	push   %eax
  803173:	ff 75 10             	pushl  0x10(%ebp)
  803176:	ff 75 0c             	pushl  0xc(%ebp)
  803179:	ff 75 08             	pushl  0x8(%ebp)
  80317c:	6a 27                	push   $0x27
  80317e:	e8 17 fb ff ff       	call   802c9a <syscall>
  803183:	83 c4 18             	add    $0x18,%esp
	return ;
  803186:	90                   	nop
}
  803187:	c9                   	leave  
  803188:	c3                   	ret    

00803189 <chktst>:
void chktst(uint32 n)
{
  803189:	55                   	push   %ebp
  80318a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80318c:	6a 00                	push   $0x0
  80318e:	6a 00                	push   $0x0
  803190:	6a 00                	push   $0x0
  803192:	6a 00                	push   $0x0
  803194:	ff 75 08             	pushl  0x8(%ebp)
  803197:	6a 29                	push   $0x29
  803199:	e8 fc fa ff ff       	call   802c9a <syscall>
  80319e:	83 c4 18             	add    $0x18,%esp
	return ;
  8031a1:	90                   	nop
}
  8031a2:	c9                   	leave  
  8031a3:	c3                   	ret    

008031a4 <inctst>:

void inctst()
{
  8031a4:	55                   	push   %ebp
  8031a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8031a7:	6a 00                	push   $0x0
  8031a9:	6a 00                	push   $0x0
  8031ab:	6a 00                	push   $0x0
  8031ad:	6a 00                	push   $0x0
  8031af:	6a 00                	push   $0x0
  8031b1:	6a 2a                	push   $0x2a
  8031b3:	e8 e2 fa ff ff       	call   802c9a <syscall>
  8031b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8031bb:	90                   	nop
}
  8031bc:	c9                   	leave  
  8031bd:	c3                   	ret    

008031be <gettst>:
uint32 gettst()
{
  8031be:	55                   	push   %ebp
  8031bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8031c1:	6a 00                	push   $0x0
  8031c3:	6a 00                	push   $0x0
  8031c5:	6a 00                	push   $0x0
  8031c7:	6a 00                	push   $0x0
  8031c9:	6a 00                	push   $0x0
  8031cb:	6a 2b                	push   $0x2b
  8031cd:	e8 c8 fa ff ff       	call   802c9a <syscall>
  8031d2:	83 c4 18             	add    $0x18,%esp
}
  8031d5:	c9                   	leave  
  8031d6:	c3                   	ret    

008031d7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8031d7:	55                   	push   %ebp
  8031d8:	89 e5                	mov    %esp,%ebp
  8031da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8031dd:	6a 00                	push   $0x0
  8031df:	6a 00                	push   $0x0
  8031e1:	6a 00                	push   $0x0
  8031e3:	6a 00                	push   $0x0
  8031e5:	6a 00                	push   $0x0
  8031e7:	6a 2c                	push   $0x2c
  8031e9:	e8 ac fa ff ff       	call   802c9a <syscall>
  8031ee:	83 c4 18             	add    $0x18,%esp
  8031f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8031f4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8031f8:	75 07                	jne    803201 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8031fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8031ff:	eb 05                	jmp    803206 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  803201:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803206:	c9                   	leave  
  803207:	c3                   	ret    

00803208 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  803208:	55                   	push   %ebp
  803209:	89 e5                	mov    %esp,%ebp
  80320b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80320e:	6a 00                	push   $0x0
  803210:	6a 00                	push   $0x0
  803212:	6a 00                	push   $0x0
  803214:	6a 00                	push   $0x0
  803216:	6a 00                	push   $0x0
  803218:	6a 2c                	push   $0x2c
  80321a:	e8 7b fa ff ff       	call   802c9a <syscall>
  80321f:	83 c4 18             	add    $0x18,%esp
  803222:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  803225:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  803229:	75 07                	jne    803232 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80322b:	b8 01 00 00 00       	mov    $0x1,%eax
  803230:	eb 05                	jmp    803237 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  803232:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803237:	c9                   	leave  
  803238:	c3                   	ret    

00803239 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  803239:	55                   	push   %ebp
  80323a:	89 e5                	mov    %esp,%ebp
  80323c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80323f:	6a 00                	push   $0x0
  803241:	6a 00                	push   $0x0
  803243:	6a 00                	push   $0x0
  803245:	6a 00                	push   $0x0
  803247:	6a 00                	push   $0x0
  803249:	6a 2c                	push   $0x2c
  80324b:	e8 4a fa ff ff       	call   802c9a <syscall>
  803250:	83 c4 18             	add    $0x18,%esp
  803253:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  803256:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80325a:	75 07                	jne    803263 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80325c:	b8 01 00 00 00       	mov    $0x1,%eax
  803261:	eb 05                	jmp    803268 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803263:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803268:	c9                   	leave  
  803269:	c3                   	ret    

0080326a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80326a:	55                   	push   %ebp
  80326b:	89 e5                	mov    %esp,%ebp
  80326d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803270:	6a 00                	push   $0x0
  803272:	6a 00                	push   $0x0
  803274:	6a 00                	push   $0x0
  803276:	6a 00                	push   $0x0
  803278:	6a 00                	push   $0x0
  80327a:	6a 2c                	push   $0x2c
  80327c:	e8 19 fa ff ff       	call   802c9a <syscall>
  803281:	83 c4 18             	add    $0x18,%esp
  803284:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  803287:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80328b:	75 07                	jne    803294 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80328d:	b8 01 00 00 00       	mov    $0x1,%eax
  803292:	eb 05                	jmp    803299 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803294:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803299:	c9                   	leave  
  80329a:	c3                   	ret    

0080329b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80329b:	55                   	push   %ebp
  80329c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80329e:	6a 00                	push   $0x0
  8032a0:	6a 00                	push   $0x0
  8032a2:	6a 00                	push   $0x0
  8032a4:	6a 00                	push   $0x0
  8032a6:	ff 75 08             	pushl  0x8(%ebp)
  8032a9:	6a 2d                	push   $0x2d
  8032ab:	e8 ea f9 ff ff       	call   802c9a <syscall>
  8032b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8032b3:	90                   	nop
}
  8032b4:	c9                   	leave  
  8032b5:	c3                   	ret    

008032b6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8032b6:	55                   	push   %ebp
  8032b7:	89 e5                	mov    %esp,%ebp
  8032b9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8032ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8032bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8032c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c6:	6a 00                	push   $0x0
  8032c8:	53                   	push   %ebx
  8032c9:	51                   	push   %ecx
  8032ca:	52                   	push   %edx
  8032cb:	50                   	push   %eax
  8032cc:	6a 2e                	push   $0x2e
  8032ce:	e8 c7 f9 ff ff       	call   802c9a <syscall>
  8032d3:	83 c4 18             	add    $0x18,%esp
}
  8032d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032d9:	c9                   	leave  
  8032da:	c3                   	ret    

008032db <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8032db:	55                   	push   %ebp
  8032dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8032de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e4:	6a 00                	push   $0x0
  8032e6:	6a 00                	push   $0x0
  8032e8:	6a 00                	push   $0x0
  8032ea:	52                   	push   %edx
  8032eb:	50                   	push   %eax
  8032ec:	6a 2f                	push   $0x2f
  8032ee:	e8 a7 f9 ff ff       	call   802c9a <syscall>
  8032f3:	83 c4 18             	add    $0x18,%esp
}
  8032f6:	c9                   	leave  
  8032f7:	c3                   	ret    

008032f8 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8032f8:	55                   	push   %ebp
  8032f9:	89 e5                	mov    %esp,%ebp
  8032fb:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8032fe:	83 ec 0c             	sub    $0xc,%esp
  803301:	68 f8 54 80 00       	push   $0x8054f8
  803306:	e8 d3 e8 ff ff       	call   801bde <cprintf>
  80330b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80330e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  803315:	83 ec 0c             	sub    $0xc,%esp
  803318:	68 24 55 80 00       	push   $0x805524
  80331d:	e8 bc e8 ff ff       	call   801bde <cprintf>
  803322:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  803325:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803329:	a1 38 61 80 00       	mov    0x806138,%eax
  80332e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803331:	eb 56                	jmp    803389 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803333:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803337:	74 1c                	je     803355 <print_mem_block_lists+0x5d>
  803339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333c:	8b 50 08             	mov    0x8(%eax),%edx
  80333f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803342:	8b 48 08             	mov    0x8(%eax),%ecx
  803345:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803348:	8b 40 0c             	mov    0xc(%eax),%eax
  80334b:	01 c8                	add    %ecx,%eax
  80334d:	39 c2                	cmp    %eax,%edx
  80334f:	73 04                	jae    803355 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  803351:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803358:	8b 50 08             	mov    0x8(%eax),%edx
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	8b 40 0c             	mov    0xc(%eax),%eax
  803361:	01 c2                	add    %eax,%edx
  803363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803366:	8b 40 08             	mov    0x8(%eax),%eax
  803369:	83 ec 04             	sub    $0x4,%esp
  80336c:	52                   	push   %edx
  80336d:	50                   	push   %eax
  80336e:	68 39 55 80 00       	push   $0x805539
  803373:	e8 66 e8 ff ff       	call   801bde <cprintf>
  803378:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80337b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803381:	a1 40 61 80 00       	mov    0x806140,%eax
  803386:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338d:	74 07                	je     803396 <print_mem_block_lists+0x9e>
  80338f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803392:	8b 00                	mov    (%eax),%eax
  803394:	eb 05                	jmp    80339b <print_mem_block_lists+0xa3>
  803396:	b8 00 00 00 00       	mov    $0x0,%eax
  80339b:	a3 40 61 80 00       	mov    %eax,0x806140
  8033a0:	a1 40 61 80 00       	mov    0x806140,%eax
  8033a5:	85 c0                	test   %eax,%eax
  8033a7:	75 8a                	jne    803333 <print_mem_block_lists+0x3b>
  8033a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ad:	75 84                	jne    803333 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8033af:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8033b3:	75 10                	jne    8033c5 <print_mem_block_lists+0xcd>
  8033b5:	83 ec 0c             	sub    $0xc,%esp
  8033b8:	68 48 55 80 00       	push   $0x805548
  8033bd:	e8 1c e8 ff ff       	call   801bde <cprintf>
  8033c2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8033c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8033cc:	83 ec 0c             	sub    $0xc,%esp
  8033cf:	68 6c 55 80 00       	push   $0x80556c
  8033d4:	e8 05 e8 ff ff       	call   801bde <cprintf>
  8033d9:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8033dc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8033e0:	a1 40 60 80 00       	mov    0x806040,%eax
  8033e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e8:	eb 56                	jmp    803440 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8033ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033ee:	74 1c                	je     80340c <print_mem_block_lists+0x114>
  8033f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f3:	8b 50 08             	mov    0x8(%eax),%edx
  8033f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f9:	8b 48 08             	mov    0x8(%eax),%ecx
  8033fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803402:	01 c8                	add    %ecx,%eax
  803404:	39 c2                	cmp    %eax,%edx
  803406:	73 04                	jae    80340c <print_mem_block_lists+0x114>
			sorted = 0 ;
  803408:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80340c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340f:	8b 50 08             	mov    0x8(%eax),%edx
  803412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803415:	8b 40 0c             	mov    0xc(%eax),%eax
  803418:	01 c2                	add    %eax,%edx
  80341a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341d:	8b 40 08             	mov    0x8(%eax),%eax
  803420:	83 ec 04             	sub    $0x4,%esp
  803423:	52                   	push   %edx
  803424:	50                   	push   %eax
  803425:	68 39 55 80 00       	push   $0x805539
  80342a:	e8 af e7 ff ff       	call   801bde <cprintf>
  80342f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803435:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803438:	a1 48 60 80 00       	mov    0x806048,%eax
  80343d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803440:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803444:	74 07                	je     80344d <print_mem_block_lists+0x155>
  803446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803449:	8b 00                	mov    (%eax),%eax
  80344b:	eb 05                	jmp    803452 <print_mem_block_lists+0x15a>
  80344d:	b8 00 00 00 00       	mov    $0x0,%eax
  803452:	a3 48 60 80 00       	mov    %eax,0x806048
  803457:	a1 48 60 80 00       	mov    0x806048,%eax
  80345c:	85 c0                	test   %eax,%eax
  80345e:	75 8a                	jne    8033ea <print_mem_block_lists+0xf2>
  803460:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803464:	75 84                	jne    8033ea <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  803466:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80346a:	75 10                	jne    80347c <print_mem_block_lists+0x184>
  80346c:	83 ec 0c             	sub    $0xc,%esp
  80346f:	68 84 55 80 00       	push   $0x805584
  803474:	e8 65 e7 ff ff       	call   801bde <cprintf>
  803479:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80347c:	83 ec 0c             	sub    $0xc,%esp
  80347f:	68 f8 54 80 00       	push   $0x8054f8
  803484:	e8 55 e7 ff ff       	call   801bde <cprintf>
  803489:	83 c4 10             	add    $0x10,%esp

}
  80348c:	90                   	nop
  80348d:	c9                   	leave  
  80348e:	c3                   	ret    

0080348f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80348f:	55                   	push   %ebp
  803490:	89 e5                	mov    %esp,%ebp
  803492:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  803495:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  80349c:	00 00 00 
  80349f:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  8034a6:	00 00 00 
  8034a9:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  8034b0:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8034b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8034ba:	e9 9e 00 00 00       	jmp    80355d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8034bf:	a1 50 60 80 00       	mov    0x806050,%eax
  8034c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034c7:	c1 e2 04             	shl    $0x4,%edx
  8034ca:	01 d0                	add    %edx,%eax
  8034cc:	85 c0                	test   %eax,%eax
  8034ce:	75 14                	jne    8034e4 <initialize_MemBlocksList+0x55>
  8034d0:	83 ec 04             	sub    $0x4,%esp
  8034d3:	68 ac 55 80 00       	push   $0x8055ac
  8034d8:	6a 46                	push   $0x46
  8034da:	68 cf 55 80 00       	push   $0x8055cf
  8034df:	e8 46 e4 ff ff       	call   80192a <_panic>
  8034e4:	a1 50 60 80 00       	mov    0x806050,%eax
  8034e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034ec:	c1 e2 04             	shl    $0x4,%edx
  8034ef:	01 d0                	add    %edx,%eax
  8034f1:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8034f7:	89 10                	mov    %edx,(%eax)
  8034f9:	8b 00                	mov    (%eax),%eax
  8034fb:	85 c0                	test   %eax,%eax
  8034fd:	74 18                	je     803517 <initialize_MemBlocksList+0x88>
  8034ff:	a1 48 61 80 00       	mov    0x806148,%eax
  803504:	8b 15 50 60 80 00    	mov    0x806050,%edx
  80350a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80350d:	c1 e1 04             	shl    $0x4,%ecx
  803510:	01 ca                	add    %ecx,%edx
  803512:	89 50 04             	mov    %edx,0x4(%eax)
  803515:	eb 12                	jmp    803529 <initialize_MemBlocksList+0x9a>
  803517:	a1 50 60 80 00       	mov    0x806050,%eax
  80351c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80351f:	c1 e2 04             	shl    $0x4,%edx
  803522:	01 d0                	add    %edx,%eax
  803524:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803529:	a1 50 60 80 00       	mov    0x806050,%eax
  80352e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803531:	c1 e2 04             	shl    $0x4,%edx
  803534:	01 d0                	add    %edx,%eax
  803536:	a3 48 61 80 00       	mov    %eax,0x806148
  80353b:	a1 50 60 80 00       	mov    0x806050,%eax
  803540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803543:	c1 e2 04             	shl    $0x4,%edx
  803546:	01 d0                	add    %edx,%eax
  803548:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80354f:	a1 54 61 80 00       	mov    0x806154,%eax
  803554:	40                   	inc    %eax
  803555:	a3 54 61 80 00       	mov    %eax,0x806154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80355a:	ff 45 f4             	incl   -0xc(%ebp)
  80355d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803560:	3b 45 08             	cmp    0x8(%ebp),%eax
  803563:	0f 82 56 ff ff ff    	jb     8034bf <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  803569:	90                   	nop
  80356a:	c9                   	leave  
  80356b:	c3                   	ret    

0080356c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80356c:	55                   	push   %ebp
  80356d:	89 e5                	mov    %esp,%ebp
  80356f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  803572:	8b 45 08             	mov    0x8(%ebp),%eax
  803575:	8b 00                	mov    (%eax),%eax
  803577:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80357a:	eb 19                	jmp    803595 <find_block+0x29>
	{
		if(va==point->sva)
  80357c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80357f:	8b 40 08             	mov    0x8(%eax),%eax
  803582:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803585:	75 05                	jne    80358c <find_block+0x20>
		   return point;
  803587:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80358a:	eb 36                	jmp    8035c2 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80358c:	8b 45 08             	mov    0x8(%ebp),%eax
  80358f:	8b 40 08             	mov    0x8(%eax),%eax
  803592:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803595:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803599:	74 07                	je     8035a2 <find_block+0x36>
  80359b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80359e:	8b 00                	mov    (%eax),%eax
  8035a0:	eb 05                	jmp    8035a7 <find_block+0x3b>
  8035a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8035a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8035aa:	89 42 08             	mov    %eax,0x8(%edx)
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	8b 40 08             	mov    0x8(%eax),%eax
  8035b3:	85 c0                	test   %eax,%eax
  8035b5:	75 c5                	jne    80357c <find_block+0x10>
  8035b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8035bb:	75 bf                	jne    80357c <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8035bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035c2:	c9                   	leave  
  8035c3:	c3                   	ret    

008035c4 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8035c4:	55                   	push   %ebp
  8035c5:	89 e5                	mov    %esp,%ebp
  8035c7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8035ca:	a1 40 60 80 00       	mov    0x806040,%eax
  8035cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8035d2:	a1 44 60 80 00       	mov    0x806044,%eax
  8035d7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8035da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035dd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8035e0:	74 24                	je     803606 <insert_sorted_allocList+0x42>
  8035e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e5:	8b 50 08             	mov    0x8(%eax),%edx
  8035e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035eb:	8b 40 08             	mov    0x8(%eax),%eax
  8035ee:	39 c2                	cmp    %eax,%edx
  8035f0:	76 14                	jbe    803606 <insert_sorted_allocList+0x42>
  8035f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f5:	8b 50 08             	mov    0x8(%eax),%edx
  8035f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fb:	8b 40 08             	mov    0x8(%eax),%eax
  8035fe:	39 c2                	cmp    %eax,%edx
  803600:	0f 82 60 01 00 00    	jb     803766 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  803606:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80360a:	75 65                	jne    803671 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80360c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803610:	75 14                	jne    803626 <insert_sorted_allocList+0x62>
  803612:	83 ec 04             	sub    $0x4,%esp
  803615:	68 ac 55 80 00       	push   $0x8055ac
  80361a:	6a 6b                	push   $0x6b
  80361c:	68 cf 55 80 00       	push   $0x8055cf
  803621:	e8 04 e3 ff ff       	call   80192a <_panic>
  803626:	8b 15 40 60 80 00    	mov    0x806040,%edx
  80362c:	8b 45 08             	mov    0x8(%ebp),%eax
  80362f:	89 10                	mov    %edx,(%eax)
  803631:	8b 45 08             	mov    0x8(%ebp),%eax
  803634:	8b 00                	mov    (%eax),%eax
  803636:	85 c0                	test   %eax,%eax
  803638:	74 0d                	je     803647 <insert_sorted_allocList+0x83>
  80363a:	a1 40 60 80 00       	mov    0x806040,%eax
  80363f:	8b 55 08             	mov    0x8(%ebp),%edx
  803642:	89 50 04             	mov    %edx,0x4(%eax)
  803645:	eb 08                	jmp    80364f <insert_sorted_allocList+0x8b>
  803647:	8b 45 08             	mov    0x8(%ebp),%eax
  80364a:	a3 44 60 80 00       	mov    %eax,0x806044
  80364f:	8b 45 08             	mov    0x8(%ebp),%eax
  803652:	a3 40 60 80 00       	mov    %eax,0x806040
  803657:	8b 45 08             	mov    0x8(%ebp),%eax
  80365a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803661:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803666:	40                   	inc    %eax
  803667:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80366c:	e9 dc 01 00 00       	jmp    80384d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  803671:	8b 45 08             	mov    0x8(%ebp),%eax
  803674:	8b 50 08             	mov    0x8(%eax),%edx
  803677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80367a:	8b 40 08             	mov    0x8(%eax),%eax
  80367d:	39 c2                	cmp    %eax,%edx
  80367f:	77 6c                	ja     8036ed <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  803681:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803685:	74 06                	je     80368d <insert_sorted_allocList+0xc9>
  803687:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80368b:	75 14                	jne    8036a1 <insert_sorted_allocList+0xdd>
  80368d:	83 ec 04             	sub    $0x4,%esp
  803690:	68 e8 55 80 00       	push   $0x8055e8
  803695:	6a 6f                	push   $0x6f
  803697:	68 cf 55 80 00       	push   $0x8055cf
  80369c:	e8 89 e2 ff ff       	call   80192a <_panic>
  8036a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a4:	8b 50 04             	mov    0x4(%eax),%edx
  8036a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036aa:	89 50 04             	mov    %edx,0x4(%eax)
  8036ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036b3:	89 10                	mov    %edx,(%eax)
  8036b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b8:	8b 40 04             	mov    0x4(%eax),%eax
  8036bb:	85 c0                	test   %eax,%eax
  8036bd:	74 0d                	je     8036cc <insert_sorted_allocList+0x108>
  8036bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036c2:	8b 40 04             	mov    0x4(%eax),%eax
  8036c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8036c8:	89 10                	mov    %edx,(%eax)
  8036ca:	eb 08                	jmp    8036d4 <insert_sorted_allocList+0x110>
  8036cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cf:	a3 40 60 80 00       	mov    %eax,0x806040
  8036d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8036da:	89 50 04             	mov    %edx,0x4(%eax)
  8036dd:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8036e2:	40                   	inc    %eax
  8036e3:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8036e8:	e9 60 01 00 00       	jmp    80384d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8036ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f0:	8b 50 08             	mov    0x8(%eax),%edx
  8036f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f6:	8b 40 08             	mov    0x8(%eax),%eax
  8036f9:	39 c2                	cmp    %eax,%edx
  8036fb:	0f 82 4c 01 00 00    	jb     80384d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  803701:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803705:	75 14                	jne    80371b <insert_sorted_allocList+0x157>
  803707:	83 ec 04             	sub    $0x4,%esp
  80370a:	68 20 56 80 00       	push   $0x805620
  80370f:	6a 73                	push   $0x73
  803711:	68 cf 55 80 00       	push   $0x8055cf
  803716:	e8 0f e2 ff ff       	call   80192a <_panic>
  80371b:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803721:	8b 45 08             	mov    0x8(%ebp),%eax
  803724:	89 50 04             	mov    %edx,0x4(%eax)
  803727:	8b 45 08             	mov    0x8(%ebp),%eax
  80372a:	8b 40 04             	mov    0x4(%eax),%eax
  80372d:	85 c0                	test   %eax,%eax
  80372f:	74 0c                	je     80373d <insert_sorted_allocList+0x179>
  803731:	a1 44 60 80 00       	mov    0x806044,%eax
  803736:	8b 55 08             	mov    0x8(%ebp),%edx
  803739:	89 10                	mov    %edx,(%eax)
  80373b:	eb 08                	jmp    803745 <insert_sorted_allocList+0x181>
  80373d:	8b 45 08             	mov    0x8(%ebp),%eax
  803740:	a3 40 60 80 00       	mov    %eax,0x806040
  803745:	8b 45 08             	mov    0x8(%ebp),%eax
  803748:	a3 44 60 80 00       	mov    %eax,0x806044
  80374d:	8b 45 08             	mov    0x8(%ebp),%eax
  803750:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803756:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80375b:	40                   	inc    %eax
  80375c:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803761:	e9 e7 00 00 00       	jmp    80384d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  803766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803769:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80376c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  803773:	a1 40 60 80 00       	mov    0x806040,%eax
  803778:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80377b:	e9 9d 00 00 00       	jmp    80381d <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  803780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803783:	8b 00                	mov    (%eax),%eax
  803785:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  803788:	8b 45 08             	mov    0x8(%ebp),%eax
  80378b:	8b 50 08             	mov    0x8(%eax),%edx
  80378e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803791:	8b 40 08             	mov    0x8(%eax),%eax
  803794:	39 c2                	cmp    %eax,%edx
  803796:	76 7d                	jbe    803815 <insert_sorted_allocList+0x251>
  803798:	8b 45 08             	mov    0x8(%ebp),%eax
  80379b:	8b 50 08             	mov    0x8(%eax),%edx
  80379e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a1:	8b 40 08             	mov    0x8(%eax),%eax
  8037a4:	39 c2                	cmp    %eax,%edx
  8037a6:	73 6d                	jae    803815 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8037a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ac:	74 06                	je     8037b4 <insert_sorted_allocList+0x1f0>
  8037ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037b2:	75 14                	jne    8037c8 <insert_sorted_allocList+0x204>
  8037b4:	83 ec 04             	sub    $0x4,%esp
  8037b7:	68 44 56 80 00       	push   $0x805644
  8037bc:	6a 7f                	push   $0x7f
  8037be:	68 cf 55 80 00       	push   $0x8055cf
  8037c3:	e8 62 e1 ff ff       	call   80192a <_panic>
  8037c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cb:	8b 10                	mov    (%eax),%edx
  8037cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d0:	89 10                	mov    %edx,(%eax)
  8037d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d5:	8b 00                	mov    (%eax),%eax
  8037d7:	85 c0                	test   %eax,%eax
  8037d9:	74 0b                	je     8037e6 <insert_sorted_allocList+0x222>
  8037db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037de:	8b 00                	mov    (%eax),%eax
  8037e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8037e3:	89 50 04             	mov    %edx,0x4(%eax)
  8037e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8037ec:	89 10                	mov    %edx,(%eax)
  8037ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037f4:	89 50 04             	mov    %edx,0x4(%eax)
  8037f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fa:	8b 00                	mov    (%eax),%eax
  8037fc:	85 c0                	test   %eax,%eax
  8037fe:	75 08                	jne    803808 <insert_sorted_allocList+0x244>
  803800:	8b 45 08             	mov    0x8(%ebp),%eax
  803803:	a3 44 60 80 00       	mov    %eax,0x806044
  803808:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80380d:	40                   	inc    %eax
  80380e:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  803813:	eb 39                	jmp    80384e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  803815:	a1 48 60 80 00       	mov    0x806048,%eax
  80381a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80381d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803821:	74 07                	je     80382a <insert_sorted_allocList+0x266>
  803823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803826:	8b 00                	mov    (%eax),%eax
  803828:	eb 05                	jmp    80382f <insert_sorted_allocList+0x26b>
  80382a:	b8 00 00 00 00       	mov    $0x0,%eax
  80382f:	a3 48 60 80 00       	mov    %eax,0x806048
  803834:	a1 48 60 80 00       	mov    0x806048,%eax
  803839:	85 c0                	test   %eax,%eax
  80383b:	0f 85 3f ff ff ff    	jne    803780 <insert_sorted_allocList+0x1bc>
  803841:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803845:	0f 85 35 ff ff ff    	jne    803780 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80384b:	eb 01                	jmp    80384e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80384d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80384e:	90                   	nop
  80384f:	c9                   	leave  
  803850:	c3                   	ret    

00803851 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  803851:	55                   	push   %ebp
  803852:	89 e5                	mov    %esp,%ebp
  803854:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803857:	a1 38 61 80 00       	mov    0x806138,%eax
  80385c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80385f:	e9 85 01 00 00       	jmp    8039e9 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  803864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803867:	8b 40 0c             	mov    0xc(%eax),%eax
  80386a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80386d:	0f 82 6e 01 00 00    	jb     8039e1 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  803873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803876:	8b 40 0c             	mov    0xc(%eax),%eax
  803879:	3b 45 08             	cmp    0x8(%ebp),%eax
  80387c:	0f 85 8a 00 00 00    	jne    80390c <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  803882:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803886:	75 17                	jne    80389f <alloc_block_FF+0x4e>
  803888:	83 ec 04             	sub    $0x4,%esp
  80388b:	68 78 56 80 00       	push   $0x805678
  803890:	68 93 00 00 00       	push   $0x93
  803895:	68 cf 55 80 00       	push   $0x8055cf
  80389a:	e8 8b e0 ff ff       	call   80192a <_panic>
  80389f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a2:	8b 00                	mov    (%eax),%eax
  8038a4:	85 c0                	test   %eax,%eax
  8038a6:	74 10                	je     8038b8 <alloc_block_FF+0x67>
  8038a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ab:	8b 00                	mov    (%eax),%eax
  8038ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038b0:	8b 52 04             	mov    0x4(%edx),%edx
  8038b3:	89 50 04             	mov    %edx,0x4(%eax)
  8038b6:	eb 0b                	jmp    8038c3 <alloc_block_FF+0x72>
  8038b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bb:	8b 40 04             	mov    0x4(%eax),%eax
  8038be:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8038c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c6:	8b 40 04             	mov    0x4(%eax),%eax
  8038c9:	85 c0                	test   %eax,%eax
  8038cb:	74 0f                	je     8038dc <alloc_block_FF+0x8b>
  8038cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d0:	8b 40 04             	mov    0x4(%eax),%eax
  8038d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038d6:	8b 12                	mov    (%edx),%edx
  8038d8:	89 10                	mov    %edx,(%eax)
  8038da:	eb 0a                	jmp    8038e6 <alloc_block_FF+0x95>
  8038dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038df:	8b 00                	mov    (%eax),%eax
  8038e1:	a3 38 61 80 00       	mov    %eax,0x806138
  8038e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038f9:	a1 44 61 80 00       	mov    0x806144,%eax
  8038fe:	48                   	dec    %eax
  8038ff:	a3 44 61 80 00       	mov    %eax,0x806144
			   return  point;
  803904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803907:	e9 10 01 00 00       	jmp    803a1c <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80390c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390f:	8b 40 0c             	mov    0xc(%eax),%eax
  803912:	3b 45 08             	cmp    0x8(%ebp),%eax
  803915:	0f 86 c6 00 00 00    	jbe    8039e1 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80391b:	a1 48 61 80 00       	mov    0x806148,%eax
  803920:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  803923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803926:	8b 50 08             	mov    0x8(%eax),%edx
  803929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80392c:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80392f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803932:	8b 55 08             	mov    0x8(%ebp),%edx
  803935:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803938:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80393c:	75 17                	jne    803955 <alloc_block_FF+0x104>
  80393e:	83 ec 04             	sub    $0x4,%esp
  803941:	68 78 56 80 00       	push   $0x805678
  803946:	68 9b 00 00 00       	push   $0x9b
  80394b:	68 cf 55 80 00       	push   $0x8055cf
  803950:	e8 d5 df ff ff       	call   80192a <_panic>
  803955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803958:	8b 00                	mov    (%eax),%eax
  80395a:	85 c0                	test   %eax,%eax
  80395c:	74 10                	je     80396e <alloc_block_FF+0x11d>
  80395e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803961:	8b 00                	mov    (%eax),%eax
  803963:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803966:	8b 52 04             	mov    0x4(%edx),%edx
  803969:	89 50 04             	mov    %edx,0x4(%eax)
  80396c:	eb 0b                	jmp    803979 <alloc_block_FF+0x128>
  80396e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803971:	8b 40 04             	mov    0x4(%eax),%eax
  803974:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803979:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80397c:	8b 40 04             	mov    0x4(%eax),%eax
  80397f:	85 c0                	test   %eax,%eax
  803981:	74 0f                	je     803992 <alloc_block_FF+0x141>
  803983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803986:	8b 40 04             	mov    0x4(%eax),%eax
  803989:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80398c:	8b 12                	mov    (%edx),%edx
  80398e:	89 10                	mov    %edx,(%eax)
  803990:	eb 0a                	jmp    80399c <alloc_block_FF+0x14b>
  803992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803995:	8b 00                	mov    (%eax),%eax
  803997:	a3 48 61 80 00       	mov    %eax,0x806148
  80399c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80399f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039af:	a1 54 61 80 00       	mov    0x806154,%eax
  8039b4:	48                   	dec    %eax
  8039b5:	a3 54 61 80 00       	mov    %eax,0x806154
			   point->sva += size;
  8039ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bd:	8b 50 08             	mov    0x8(%eax),%edx
  8039c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c3:	01 c2                	add    %eax,%edx
  8039c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c8:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8039cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8039d1:	2b 45 08             	sub    0x8(%ebp),%eax
  8039d4:	89 c2                	mov    %eax,%edx
  8039d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d9:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8039dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039df:	eb 3b                	jmp    803a1c <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8039e1:	a1 40 61 80 00       	mov    0x806140,%eax
  8039e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ed:	74 07                	je     8039f6 <alloc_block_FF+0x1a5>
  8039ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f2:	8b 00                	mov    (%eax),%eax
  8039f4:	eb 05                	jmp    8039fb <alloc_block_FF+0x1aa>
  8039f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8039fb:	a3 40 61 80 00       	mov    %eax,0x806140
  803a00:	a1 40 61 80 00       	mov    0x806140,%eax
  803a05:	85 c0                	test   %eax,%eax
  803a07:	0f 85 57 fe ff ff    	jne    803864 <alloc_block_FF+0x13>
  803a0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a11:	0f 85 4d fe ff ff    	jne    803864 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  803a17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a1c:	c9                   	leave  
  803a1d:	c3                   	ret    

00803a1e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803a1e:	55                   	push   %ebp
  803a1f:	89 e5                	mov    %esp,%ebp
  803a21:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  803a24:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803a2b:	a1 38 61 80 00       	mov    0x806138,%eax
  803a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a33:	e9 df 00 00 00       	jmp    803b17 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  803a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3b:	8b 40 0c             	mov    0xc(%eax),%eax
  803a3e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a41:	0f 82 c8 00 00 00    	jb     803b0f <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  803a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4a:	8b 40 0c             	mov    0xc(%eax),%eax
  803a4d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a50:	0f 85 8a 00 00 00    	jne    803ae0 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  803a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a5a:	75 17                	jne    803a73 <alloc_block_BF+0x55>
  803a5c:	83 ec 04             	sub    $0x4,%esp
  803a5f:	68 78 56 80 00       	push   $0x805678
  803a64:	68 b7 00 00 00       	push   $0xb7
  803a69:	68 cf 55 80 00       	push   $0x8055cf
  803a6e:	e8 b7 de ff ff       	call   80192a <_panic>
  803a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a76:	8b 00                	mov    (%eax),%eax
  803a78:	85 c0                	test   %eax,%eax
  803a7a:	74 10                	je     803a8c <alloc_block_BF+0x6e>
  803a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7f:	8b 00                	mov    (%eax),%eax
  803a81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a84:	8b 52 04             	mov    0x4(%edx),%edx
  803a87:	89 50 04             	mov    %edx,0x4(%eax)
  803a8a:	eb 0b                	jmp    803a97 <alloc_block_BF+0x79>
  803a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8f:	8b 40 04             	mov    0x4(%eax),%eax
  803a92:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9a:	8b 40 04             	mov    0x4(%eax),%eax
  803a9d:	85 c0                	test   %eax,%eax
  803a9f:	74 0f                	je     803ab0 <alloc_block_BF+0x92>
  803aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa4:	8b 40 04             	mov    0x4(%eax),%eax
  803aa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803aaa:	8b 12                	mov    (%edx),%edx
  803aac:	89 10                	mov    %edx,(%eax)
  803aae:	eb 0a                	jmp    803aba <alloc_block_BF+0x9c>
  803ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab3:	8b 00                	mov    (%eax),%eax
  803ab5:	a3 38 61 80 00       	mov    %eax,0x806138
  803aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803acd:	a1 44 61 80 00       	mov    0x806144,%eax
  803ad2:	48                   	dec    %eax
  803ad3:	a3 44 61 80 00       	mov    %eax,0x806144
			   return currentMemBlock;
  803ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803adb:	e9 4d 01 00 00       	jmp    803c2d <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  803ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae3:	8b 40 0c             	mov    0xc(%eax),%eax
  803ae6:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ae9:	76 24                	jbe    803b0f <alloc_block_BF+0xf1>
  803aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aee:	8b 40 0c             	mov    0xc(%eax),%eax
  803af1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803af4:	73 19                	jae    803b0f <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  803af6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  803afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b00:	8b 40 0c             	mov    0xc(%eax),%eax
  803b03:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  803b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b09:	8b 40 08             	mov    0x8(%eax),%eax
  803b0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803b0f:	a1 40 61 80 00       	mov    0x806140,%eax
  803b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b1b:	74 07                	je     803b24 <alloc_block_BF+0x106>
  803b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b20:	8b 00                	mov    (%eax),%eax
  803b22:	eb 05                	jmp    803b29 <alloc_block_BF+0x10b>
  803b24:	b8 00 00 00 00       	mov    $0x0,%eax
  803b29:	a3 40 61 80 00       	mov    %eax,0x806140
  803b2e:	a1 40 61 80 00       	mov    0x806140,%eax
  803b33:	85 c0                	test   %eax,%eax
  803b35:	0f 85 fd fe ff ff    	jne    803a38 <alloc_block_BF+0x1a>
  803b3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b3f:	0f 85 f3 fe ff ff    	jne    803a38 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  803b45:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b49:	0f 84 d9 00 00 00    	je     803c28 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  803b4f:	a1 48 61 80 00       	mov    0x806148,%eax
  803b54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803b57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b5a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b5d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803b60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b63:	8b 55 08             	mov    0x8(%ebp),%edx
  803b66:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803b69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b6d:	75 17                	jne    803b86 <alloc_block_BF+0x168>
  803b6f:	83 ec 04             	sub    $0x4,%esp
  803b72:	68 78 56 80 00       	push   $0x805678
  803b77:	68 c7 00 00 00       	push   $0xc7
  803b7c:	68 cf 55 80 00       	push   $0x8055cf
  803b81:	e8 a4 dd ff ff       	call   80192a <_panic>
  803b86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b89:	8b 00                	mov    (%eax),%eax
  803b8b:	85 c0                	test   %eax,%eax
  803b8d:	74 10                	je     803b9f <alloc_block_BF+0x181>
  803b8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b92:	8b 00                	mov    (%eax),%eax
  803b94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b97:	8b 52 04             	mov    0x4(%edx),%edx
  803b9a:	89 50 04             	mov    %edx,0x4(%eax)
  803b9d:	eb 0b                	jmp    803baa <alloc_block_BF+0x18c>
  803b9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba2:	8b 40 04             	mov    0x4(%eax),%eax
  803ba5:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803baa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bad:	8b 40 04             	mov    0x4(%eax),%eax
  803bb0:	85 c0                	test   %eax,%eax
  803bb2:	74 0f                	je     803bc3 <alloc_block_BF+0x1a5>
  803bb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb7:	8b 40 04             	mov    0x4(%eax),%eax
  803bba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bbd:	8b 12                	mov    (%edx),%edx
  803bbf:	89 10                	mov    %edx,(%eax)
  803bc1:	eb 0a                	jmp    803bcd <alloc_block_BF+0x1af>
  803bc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc6:	8b 00                	mov    (%eax),%eax
  803bc8:	a3 48 61 80 00       	mov    %eax,0x806148
  803bcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803be0:	a1 54 61 80 00       	mov    0x806154,%eax
  803be5:	48                   	dec    %eax
  803be6:	a3 54 61 80 00       	mov    %eax,0x806154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803beb:	83 ec 08             	sub    $0x8,%esp
  803bee:	ff 75 ec             	pushl  -0x14(%ebp)
  803bf1:	68 38 61 80 00       	push   $0x806138
  803bf6:	e8 71 f9 ff ff       	call   80356c <find_block>
  803bfb:	83 c4 10             	add    $0x10,%esp
  803bfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803c01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c04:	8b 50 08             	mov    0x8(%eax),%edx
  803c07:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0a:	01 c2                	add    %eax,%edx
  803c0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c0f:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803c12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c15:	8b 40 0c             	mov    0xc(%eax),%eax
  803c18:	2b 45 08             	sub    0x8(%ebp),%eax
  803c1b:	89 c2                	mov    %eax,%edx
  803c1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c20:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803c23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c26:	eb 05                	jmp    803c2d <alloc_block_BF+0x20f>
	}
	return NULL;
  803c28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c2d:	c9                   	leave  
  803c2e:	c3                   	ret    

00803c2f <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803c2f:	55                   	push   %ebp
  803c30:	89 e5                	mov    %esp,%ebp
  803c32:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803c35:	a1 28 60 80 00       	mov    0x806028,%eax
  803c3a:	85 c0                	test   %eax,%eax
  803c3c:	0f 85 de 01 00 00    	jne    803e20 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803c42:	a1 38 61 80 00       	mov    0x806138,%eax
  803c47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c4a:	e9 9e 01 00 00       	jmp    803ded <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c52:	8b 40 0c             	mov    0xc(%eax),%eax
  803c55:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c58:	0f 82 87 01 00 00    	jb     803de5 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c61:	8b 40 0c             	mov    0xc(%eax),%eax
  803c64:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c67:	0f 85 95 00 00 00    	jne    803d02 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803c6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c71:	75 17                	jne    803c8a <alloc_block_NF+0x5b>
  803c73:	83 ec 04             	sub    $0x4,%esp
  803c76:	68 78 56 80 00       	push   $0x805678
  803c7b:	68 e0 00 00 00       	push   $0xe0
  803c80:	68 cf 55 80 00       	push   $0x8055cf
  803c85:	e8 a0 dc ff ff       	call   80192a <_panic>
  803c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c8d:	8b 00                	mov    (%eax),%eax
  803c8f:	85 c0                	test   %eax,%eax
  803c91:	74 10                	je     803ca3 <alloc_block_NF+0x74>
  803c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c96:	8b 00                	mov    (%eax),%eax
  803c98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c9b:	8b 52 04             	mov    0x4(%edx),%edx
  803c9e:	89 50 04             	mov    %edx,0x4(%eax)
  803ca1:	eb 0b                	jmp    803cae <alloc_block_NF+0x7f>
  803ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca6:	8b 40 04             	mov    0x4(%eax),%eax
  803ca9:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb1:	8b 40 04             	mov    0x4(%eax),%eax
  803cb4:	85 c0                	test   %eax,%eax
  803cb6:	74 0f                	je     803cc7 <alloc_block_NF+0x98>
  803cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbb:	8b 40 04             	mov    0x4(%eax),%eax
  803cbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cc1:	8b 12                	mov    (%edx),%edx
  803cc3:	89 10                	mov    %edx,(%eax)
  803cc5:	eb 0a                	jmp    803cd1 <alloc_block_NF+0xa2>
  803cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cca:	8b 00                	mov    (%eax),%eax
  803ccc:	a3 38 61 80 00       	mov    %eax,0x806138
  803cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cdd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ce4:	a1 44 61 80 00       	mov    0x806144,%eax
  803ce9:	48                   	dec    %eax
  803cea:	a3 44 61 80 00       	mov    %eax,0x806144
				   svaOfNF = point->sva;
  803cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf2:	8b 40 08             	mov    0x8(%eax),%eax
  803cf5:	a3 28 60 80 00       	mov    %eax,0x806028
				   return  point;
  803cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cfd:	e9 f8 04 00 00       	jmp    8041fa <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d05:	8b 40 0c             	mov    0xc(%eax),%eax
  803d08:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d0b:	0f 86 d4 00 00 00    	jbe    803de5 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803d11:	a1 48 61 80 00       	mov    0x806148,%eax
  803d16:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1c:	8b 50 08             	mov    0x8(%eax),%edx
  803d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d22:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d28:	8b 55 08             	mov    0x8(%ebp),%edx
  803d2b:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803d2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d32:	75 17                	jne    803d4b <alloc_block_NF+0x11c>
  803d34:	83 ec 04             	sub    $0x4,%esp
  803d37:	68 78 56 80 00       	push   $0x805678
  803d3c:	68 e9 00 00 00       	push   $0xe9
  803d41:	68 cf 55 80 00       	push   $0x8055cf
  803d46:	e8 df db ff ff       	call   80192a <_panic>
  803d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d4e:	8b 00                	mov    (%eax),%eax
  803d50:	85 c0                	test   %eax,%eax
  803d52:	74 10                	je     803d64 <alloc_block_NF+0x135>
  803d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d57:	8b 00                	mov    (%eax),%eax
  803d59:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d5c:	8b 52 04             	mov    0x4(%edx),%edx
  803d5f:	89 50 04             	mov    %edx,0x4(%eax)
  803d62:	eb 0b                	jmp    803d6f <alloc_block_NF+0x140>
  803d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d67:	8b 40 04             	mov    0x4(%eax),%eax
  803d6a:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d72:	8b 40 04             	mov    0x4(%eax),%eax
  803d75:	85 c0                	test   %eax,%eax
  803d77:	74 0f                	je     803d88 <alloc_block_NF+0x159>
  803d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d7c:	8b 40 04             	mov    0x4(%eax),%eax
  803d7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d82:	8b 12                	mov    (%edx),%edx
  803d84:	89 10                	mov    %edx,(%eax)
  803d86:	eb 0a                	jmp    803d92 <alloc_block_NF+0x163>
  803d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d8b:	8b 00                	mov    (%eax),%eax
  803d8d:	a3 48 61 80 00       	mov    %eax,0x806148
  803d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803da5:	a1 54 61 80 00       	mov    0x806154,%eax
  803daa:	48                   	dec    %eax
  803dab:	a3 54 61 80 00       	mov    %eax,0x806154
				   svaOfNF = ReturnedBlock->sva;
  803db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db3:	8b 40 08             	mov    0x8(%eax),%eax
  803db6:	a3 28 60 80 00       	mov    %eax,0x806028
				   point->sva += size;
  803dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbe:	8b 50 08             	mov    0x8(%eax),%edx
  803dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc4:	01 c2                	add    %eax,%edx
  803dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc9:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dcf:	8b 40 0c             	mov    0xc(%eax),%eax
  803dd2:	2b 45 08             	sub    0x8(%ebp),%eax
  803dd5:	89 c2                	mov    %eax,%edx
  803dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dda:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de0:	e9 15 04 00 00       	jmp    8041fa <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803de5:	a1 40 61 80 00       	mov    0x806140,%eax
  803dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ded:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803df1:	74 07                	je     803dfa <alloc_block_NF+0x1cb>
  803df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df6:	8b 00                	mov    (%eax),%eax
  803df8:	eb 05                	jmp    803dff <alloc_block_NF+0x1d0>
  803dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  803dff:	a3 40 61 80 00       	mov    %eax,0x806140
  803e04:	a1 40 61 80 00       	mov    0x806140,%eax
  803e09:	85 c0                	test   %eax,%eax
  803e0b:	0f 85 3e fe ff ff    	jne    803c4f <alloc_block_NF+0x20>
  803e11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e15:	0f 85 34 fe ff ff    	jne    803c4f <alloc_block_NF+0x20>
  803e1b:	e9 d5 03 00 00       	jmp    8041f5 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803e20:	a1 38 61 80 00       	mov    0x806138,%eax
  803e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e28:	e9 b1 01 00 00       	jmp    803fde <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e30:	8b 50 08             	mov    0x8(%eax),%edx
  803e33:	a1 28 60 80 00       	mov    0x806028,%eax
  803e38:	39 c2                	cmp    %eax,%edx
  803e3a:	0f 82 96 01 00 00    	jb     803fd6 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e43:	8b 40 0c             	mov    0xc(%eax),%eax
  803e46:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e49:	0f 82 87 01 00 00    	jb     803fd6 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e52:	8b 40 0c             	mov    0xc(%eax),%eax
  803e55:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e58:	0f 85 95 00 00 00    	jne    803ef3 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803e5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e62:	75 17                	jne    803e7b <alloc_block_NF+0x24c>
  803e64:	83 ec 04             	sub    $0x4,%esp
  803e67:	68 78 56 80 00       	push   $0x805678
  803e6c:	68 fc 00 00 00       	push   $0xfc
  803e71:	68 cf 55 80 00       	push   $0x8055cf
  803e76:	e8 af da ff ff       	call   80192a <_panic>
  803e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e7e:	8b 00                	mov    (%eax),%eax
  803e80:	85 c0                	test   %eax,%eax
  803e82:	74 10                	je     803e94 <alloc_block_NF+0x265>
  803e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e87:	8b 00                	mov    (%eax),%eax
  803e89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e8c:	8b 52 04             	mov    0x4(%edx),%edx
  803e8f:	89 50 04             	mov    %edx,0x4(%eax)
  803e92:	eb 0b                	jmp    803e9f <alloc_block_NF+0x270>
  803e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e97:	8b 40 04             	mov    0x4(%eax),%eax
  803e9a:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea2:	8b 40 04             	mov    0x4(%eax),%eax
  803ea5:	85 c0                	test   %eax,%eax
  803ea7:	74 0f                	je     803eb8 <alloc_block_NF+0x289>
  803ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eac:	8b 40 04             	mov    0x4(%eax),%eax
  803eaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803eb2:	8b 12                	mov    (%edx),%edx
  803eb4:	89 10                	mov    %edx,(%eax)
  803eb6:	eb 0a                	jmp    803ec2 <alloc_block_NF+0x293>
  803eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ebb:	8b 00                	mov    (%eax),%eax
  803ebd:	a3 38 61 80 00       	mov    %eax,0x806138
  803ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ece:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ed5:	a1 44 61 80 00       	mov    0x806144,%eax
  803eda:	48                   	dec    %eax
  803edb:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee3:	8b 40 08             	mov    0x8(%eax),%eax
  803ee6:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eee:	e9 07 03 00 00       	jmp    8041fa <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef6:	8b 40 0c             	mov    0xc(%eax),%eax
  803ef9:	3b 45 08             	cmp    0x8(%ebp),%eax
  803efc:	0f 86 d4 00 00 00    	jbe    803fd6 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803f02:	a1 48 61 80 00       	mov    0x806148,%eax
  803f07:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f0d:	8b 50 08             	mov    0x8(%eax),%edx
  803f10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f13:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803f16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f19:	8b 55 08             	mov    0x8(%ebp),%edx
  803f1c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803f1f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803f23:	75 17                	jne    803f3c <alloc_block_NF+0x30d>
  803f25:	83 ec 04             	sub    $0x4,%esp
  803f28:	68 78 56 80 00       	push   $0x805678
  803f2d:	68 04 01 00 00       	push   $0x104
  803f32:	68 cf 55 80 00       	push   $0x8055cf
  803f37:	e8 ee d9 ff ff       	call   80192a <_panic>
  803f3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f3f:	8b 00                	mov    (%eax),%eax
  803f41:	85 c0                	test   %eax,%eax
  803f43:	74 10                	je     803f55 <alloc_block_NF+0x326>
  803f45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f48:	8b 00                	mov    (%eax),%eax
  803f4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f4d:	8b 52 04             	mov    0x4(%edx),%edx
  803f50:	89 50 04             	mov    %edx,0x4(%eax)
  803f53:	eb 0b                	jmp    803f60 <alloc_block_NF+0x331>
  803f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f58:	8b 40 04             	mov    0x4(%eax),%eax
  803f5b:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803f60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f63:	8b 40 04             	mov    0x4(%eax),%eax
  803f66:	85 c0                	test   %eax,%eax
  803f68:	74 0f                	je     803f79 <alloc_block_NF+0x34a>
  803f6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f6d:	8b 40 04             	mov    0x4(%eax),%eax
  803f70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f73:	8b 12                	mov    (%edx),%edx
  803f75:	89 10                	mov    %edx,(%eax)
  803f77:	eb 0a                	jmp    803f83 <alloc_block_NF+0x354>
  803f79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f7c:	8b 00                	mov    (%eax),%eax
  803f7e:	a3 48 61 80 00       	mov    %eax,0x806148
  803f83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f96:	a1 54 61 80 00       	mov    0x806154,%eax
  803f9b:	48                   	dec    %eax
  803f9c:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803fa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fa4:	8b 40 08             	mov    0x8(%eax),%eax
  803fa7:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803faf:	8b 50 08             	mov    0x8(%eax),%edx
  803fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  803fb5:	01 c2                	add    %eax,%edx
  803fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fba:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc0:	8b 40 0c             	mov    0xc(%eax),%eax
  803fc3:	2b 45 08             	sub    0x8(%ebp),%eax
  803fc6:	89 c2                	mov    %eax,%edx
  803fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fcb:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803fce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fd1:	e9 24 02 00 00       	jmp    8041fa <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803fd6:	a1 40 61 80 00       	mov    0x806140,%eax
  803fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fe2:	74 07                	je     803feb <alloc_block_NF+0x3bc>
  803fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe7:	8b 00                	mov    (%eax),%eax
  803fe9:	eb 05                	jmp    803ff0 <alloc_block_NF+0x3c1>
  803feb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ff0:	a3 40 61 80 00       	mov    %eax,0x806140
  803ff5:	a1 40 61 80 00       	mov    0x806140,%eax
  803ffa:	85 c0                	test   %eax,%eax
  803ffc:	0f 85 2b fe ff ff    	jne    803e2d <alloc_block_NF+0x1fe>
  804002:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804006:	0f 85 21 fe ff ff    	jne    803e2d <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80400c:	a1 38 61 80 00       	mov    0x806138,%eax
  804011:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804014:	e9 ae 01 00 00       	jmp    8041c7 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  804019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80401c:	8b 50 08             	mov    0x8(%eax),%edx
  80401f:	a1 28 60 80 00       	mov    0x806028,%eax
  804024:	39 c2                	cmp    %eax,%edx
  804026:	0f 83 93 01 00 00    	jae    8041bf <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80402c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80402f:	8b 40 0c             	mov    0xc(%eax),%eax
  804032:	3b 45 08             	cmp    0x8(%ebp),%eax
  804035:	0f 82 84 01 00 00    	jb     8041bf <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80403b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80403e:	8b 40 0c             	mov    0xc(%eax),%eax
  804041:	3b 45 08             	cmp    0x8(%ebp),%eax
  804044:	0f 85 95 00 00 00    	jne    8040df <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80404a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80404e:	75 17                	jne    804067 <alloc_block_NF+0x438>
  804050:	83 ec 04             	sub    $0x4,%esp
  804053:	68 78 56 80 00       	push   $0x805678
  804058:	68 14 01 00 00       	push   $0x114
  80405d:	68 cf 55 80 00       	push   $0x8055cf
  804062:	e8 c3 d8 ff ff       	call   80192a <_panic>
  804067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80406a:	8b 00                	mov    (%eax),%eax
  80406c:	85 c0                	test   %eax,%eax
  80406e:	74 10                	je     804080 <alloc_block_NF+0x451>
  804070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804073:	8b 00                	mov    (%eax),%eax
  804075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804078:	8b 52 04             	mov    0x4(%edx),%edx
  80407b:	89 50 04             	mov    %edx,0x4(%eax)
  80407e:	eb 0b                	jmp    80408b <alloc_block_NF+0x45c>
  804080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804083:	8b 40 04             	mov    0x4(%eax),%eax
  804086:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80408b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80408e:	8b 40 04             	mov    0x4(%eax),%eax
  804091:	85 c0                	test   %eax,%eax
  804093:	74 0f                	je     8040a4 <alloc_block_NF+0x475>
  804095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804098:	8b 40 04             	mov    0x4(%eax),%eax
  80409b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80409e:	8b 12                	mov    (%edx),%edx
  8040a0:	89 10                	mov    %edx,(%eax)
  8040a2:	eb 0a                	jmp    8040ae <alloc_block_NF+0x47f>
  8040a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040a7:	8b 00                	mov    (%eax),%eax
  8040a9:	a3 38 61 80 00       	mov    %eax,0x806138
  8040ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040c1:	a1 44 61 80 00       	mov    0x806144,%eax
  8040c6:	48                   	dec    %eax
  8040c7:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  8040cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040cf:	8b 40 08             	mov    0x8(%eax),%eax
  8040d2:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  8040d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040da:	e9 1b 01 00 00       	jmp    8041fa <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8040df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8040e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8040e8:	0f 86 d1 00 00 00    	jbe    8041bf <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8040ee:	a1 48 61 80 00       	mov    0x806148,%eax
  8040f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8040f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040f9:	8b 50 08             	mov    0x8(%eax),%edx
  8040fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040ff:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  804102:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804105:	8b 55 08             	mov    0x8(%ebp),%edx
  804108:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80410b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80410f:	75 17                	jne    804128 <alloc_block_NF+0x4f9>
  804111:	83 ec 04             	sub    $0x4,%esp
  804114:	68 78 56 80 00       	push   $0x805678
  804119:	68 1c 01 00 00       	push   $0x11c
  80411e:	68 cf 55 80 00       	push   $0x8055cf
  804123:	e8 02 d8 ff ff       	call   80192a <_panic>
  804128:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80412b:	8b 00                	mov    (%eax),%eax
  80412d:	85 c0                	test   %eax,%eax
  80412f:	74 10                	je     804141 <alloc_block_NF+0x512>
  804131:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804134:	8b 00                	mov    (%eax),%eax
  804136:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804139:	8b 52 04             	mov    0x4(%edx),%edx
  80413c:	89 50 04             	mov    %edx,0x4(%eax)
  80413f:	eb 0b                	jmp    80414c <alloc_block_NF+0x51d>
  804141:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804144:	8b 40 04             	mov    0x4(%eax),%eax
  804147:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80414c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80414f:	8b 40 04             	mov    0x4(%eax),%eax
  804152:	85 c0                	test   %eax,%eax
  804154:	74 0f                	je     804165 <alloc_block_NF+0x536>
  804156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804159:	8b 40 04             	mov    0x4(%eax),%eax
  80415c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80415f:	8b 12                	mov    (%edx),%edx
  804161:	89 10                	mov    %edx,(%eax)
  804163:	eb 0a                	jmp    80416f <alloc_block_NF+0x540>
  804165:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804168:	8b 00                	mov    (%eax),%eax
  80416a:	a3 48 61 80 00       	mov    %eax,0x806148
  80416f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804172:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804178:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80417b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804182:	a1 54 61 80 00       	mov    0x806154,%eax
  804187:	48                   	dec    %eax
  804188:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  80418d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804190:	8b 40 08             	mov    0x8(%eax),%eax
  804193:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  804198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80419b:	8b 50 08             	mov    0x8(%eax),%edx
  80419e:	8b 45 08             	mov    0x8(%ebp),%eax
  8041a1:	01 c2                	add    %eax,%edx
  8041a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041a6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8041a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8041af:	2b 45 08             	sub    0x8(%ebp),%eax
  8041b2:	89 c2                	mov    %eax,%edx
  8041b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041b7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8041ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041bd:	eb 3b                	jmp    8041fa <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8041bf:	a1 40 61 80 00       	mov    0x806140,%eax
  8041c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8041c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8041cb:	74 07                	je     8041d4 <alloc_block_NF+0x5a5>
  8041cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041d0:	8b 00                	mov    (%eax),%eax
  8041d2:	eb 05                	jmp    8041d9 <alloc_block_NF+0x5aa>
  8041d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8041d9:	a3 40 61 80 00       	mov    %eax,0x806140
  8041de:	a1 40 61 80 00       	mov    0x806140,%eax
  8041e3:	85 c0                	test   %eax,%eax
  8041e5:	0f 85 2e fe ff ff    	jne    804019 <alloc_block_NF+0x3ea>
  8041eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8041ef:	0f 85 24 fe ff ff    	jne    804019 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8041f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041fa:	c9                   	leave  
  8041fb:	c3                   	ret    

008041fc <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8041fc:	55                   	push   %ebp
  8041fd:	89 e5                	mov    %esp,%ebp
  8041ff:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  804202:	a1 38 61 80 00       	mov    0x806138,%eax
  804207:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80420a:	a1 3c 61 80 00       	mov    0x80613c,%eax
  80420f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  804212:	a1 38 61 80 00       	mov    0x806138,%eax
  804217:	85 c0                	test   %eax,%eax
  804219:	74 14                	je     80422f <insert_sorted_with_merge_freeList+0x33>
  80421b:	8b 45 08             	mov    0x8(%ebp),%eax
  80421e:	8b 50 08             	mov    0x8(%eax),%edx
  804221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804224:	8b 40 08             	mov    0x8(%eax),%eax
  804227:	39 c2                	cmp    %eax,%edx
  804229:	0f 87 9b 01 00 00    	ja     8043ca <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80422f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804233:	75 17                	jne    80424c <insert_sorted_with_merge_freeList+0x50>
  804235:	83 ec 04             	sub    $0x4,%esp
  804238:	68 ac 55 80 00       	push   $0x8055ac
  80423d:	68 38 01 00 00       	push   $0x138
  804242:	68 cf 55 80 00       	push   $0x8055cf
  804247:	e8 de d6 ff ff       	call   80192a <_panic>
  80424c:	8b 15 38 61 80 00    	mov    0x806138,%edx
  804252:	8b 45 08             	mov    0x8(%ebp),%eax
  804255:	89 10                	mov    %edx,(%eax)
  804257:	8b 45 08             	mov    0x8(%ebp),%eax
  80425a:	8b 00                	mov    (%eax),%eax
  80425c:	85 c0                	test   %eax,%eax
  80425e:	74 0d                	je     80426d <insert_sorted_with_merge_freeList+0x71>
  804260:	a1 38 61 80 00       	mov    0x806138,%eax
  804265:	8b 55 08             	mov    0x8(%ebp),%edx
  804268:	89 50 04             	mov    %edx,0x4(%eax)
  80426b:	eb 08                	jmp    804275 <insert_sorted_with_merge_freeList+0x79>
  80426d:	8b 45 08             	mov    0x8(%ebp),%eax
  804270:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804275:	8b 45 08             	mov    0x8(%ebp),%eax
  804278:	a3 38 61 80 00       	mov    %eax,0x806138
  80427d:	8b 45 08             	mov    0x8(%ebp),%eax
  804280:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804287:	a1 44 61 80 00       	mov    0x806144,%eax
  80428c:	40                   	inc    %eax
  80428d:	a3 44 61 80 00       	mov    %eax,0x806144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  804292:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804296:	0f 84 a8 06 00 00    	je     804944 <insert_sorted_with_merge_freeList+0x748>
  80429c:	8b 45 08             	mov    0x8(%ebp),%eax
  80429f:	8b 50 08             	mov    0x8(%eax),%edx
  8042a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8042a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8042a8:	01 c2                	add    %eax,%edx
  8042aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042ad:	8b 40 08             	mov    0x8(%eax),%eax
  8042b0:	39 c2                	cmp    %eax,%edx
  8042b2:	0f 85 8c 06 00 00    	jne    804944 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8042b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8042bb:	8b 50 0c             	mov    0xc(%eax),%edx
  8042be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8042c4:	01 c2                	add    %eax,%edx
  8042c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8042c9:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8042cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8042d0:	75 17                	jne    8042e9 <insert_sorted_with_merge_freeList+0xed>
  8042d2:	83 ec 04             	sub    $0x4,%esp
  8042d5:	68 78 56 80 00       	push   $0x805678
  8042da:	68 3c 01 00 00       	push   $0x13c
  8042df:	68 cf 55 80 00       	push   $0x8055cf
  8042e4:	e8 41 d6 ff ff       	call   80192a <_panic>
  8042e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042ec:	8b 00                	mov    (%eax),%eax
  8042ee:	85 c0                	test   %eax,%eax
  8042f0:	74 10                	je     804302 <insert_sorted_with_merge_freeList+0x106>
  8042f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042f5:	8b 00                	mov    (%eax),%eax
  8042f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8042fa:	8b 52 04             	mov    0x4(%edx),%edx
  8042fd:	89 50 04             	mov    %edx,0x4(%eax)
  804300:	eb 0b                	jmp    80430d <insert_sorted_with_merge_freeList+0x111>
  804302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804305:	8b 40 04             	mov    0x4(%eax),%eax
  804308:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80430d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804310:	8b 40 04             	mov    0x4(%eax),%eax
  804313:	85 c0                	test   %eax,%eax
  804315:	74 0f                	je     804326 <insert_sorted_with_merge_freeList+0x12a>
  804317:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80431a:	8b 40 04             	mov    0x4(%eax),%eax
  80431d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804320:	8b 12                	mov    (%edx),%edx
  804322:	89 10                	mov    %edx,(%eax)
  804324:	eb 0a                	jmp    804330 <insert_sorted_with_merge_freeList+0x134>
  804326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804329:	8b 00                	mov    (%eax),%eax
  80432b:	a3 38 61 80 00       	mov    %eax,0x806138
  804330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804333:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80433c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804343:	a1 44 61 80 00       	mov    0x806144,%eax
  804348:	48                   	dec    %eax
  804349:	a3 44 61 80 00       	mov    %eax,0x806144
			head->size = 0;
  80434e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804351:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  804358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80435b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  804362:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804366:	75 17                	jne    80437f <insert_sorted_with_merge_freeList+0x183>
  804368:	83 ec 04             	sub    $0x4,%esp
  80436b:	68 ac 55 80 00       	push   $0x8055ac
  804370:	68 3f 01 00 00       	push   $0x13f
  804375:	68 cf 55 80 00       	push   $0x8055cf
  80437a:	e8 ab d5 ff ff       	call   80192a <_panic>
  80437f:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804388:	89 10                	mov    %edx,(%eax)
  80438a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80438d:	8b 00                	mov    (%eax),%eax
  80438f:	85 c0                	test   %eax,%eax
  804391:	74 0d                	je     8043a0 <insert_sorted_with_merge_freeList+0x1a4>
  804393:	a1 48 61 80 00       	mov    0x806148,%eax
  804398:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80439b:	89 50 04             	mov    %edx,0x4(%eax)
  80439e:	eb 08                	jmp    8043a8 <insert_sorted_with_merge_freeList+0x1ac>
  8043a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043a3:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8043a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043ab:	a3 48 61 80 00       	mov    %eax,0x806148
  8043b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043ba:	a1 54 61 80 00       	mov    0x806154,%eax
  8043bf:	40                   	inc    %eax
  8043c0:	a3 54 61 80 00       	mov    %eax,0x806154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8043c5:	e9 7a 05 00 00       	jmp    804944 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8043ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8043cd:	8b 50 08             	mov    0x8(%eax),%edx
  8043d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043d3:	8b 40 08             	mov    0x8(%eax),%eax
  8043d6:	39 c2                	cmp    %eax,%edx
  8043d8:	0f 82 14 01 00 00    	jb     8044f2 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8043de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043e1:	8b 50 08             	mov    0x8(%eax),%edx
  8043e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8043ea:	01 c2                	add    %eax,%edx
  8043ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8043ef:	8b 40 08             	mov    0x8(%eax),%eax
  8043f2:	39 c2                	cmp    %eax,%edx
  8043f4:	0f 85 90 00 00 00    	jne    80448a <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8043fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043fd:	8b 50 0c             	mov    0xc(%eax),%edx
  804400:	8b 45 08             	mov    0x8(%ebp),%eax
  804403:	8b 40 0c             	mov    0xc(%eax),%eax
  804406:	01 c2                	add    %eax,%edx
  804408:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80440b:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80440e:	8b 45 08             	mov    0x8(%ebp),%eax
  804411:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  804418:	8b 45 08             	mov    0x8(%ebp),%eax
  80441b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  804422:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804426:	75 17                	jne    80443f <insert_sorted_with_merge_freeList+0x243>
  804428:	83 ec 04             	sub    $0x4,%esp
  80442b:	68 ac 55 80 00       	push   $0x8055ac
  804430:	68 49 01 00 00       	push   $0x149
  804435:	68 cf 55 80 00       	push   $0x8055cf
  80443a:	e8 eb d4 ff ff       	call   80192a <_panic>
  80443f:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804445:	8b 45 08             	mov    0x8(%ebp),%eax
  804448:	89 10                	mov    %edx,(%eax)
  80444a:	8b 45 08             	mov    0x8(%ebp),%eax
  80444d:	8b 00                	mov    (%eax),%eax
  80444f:	85 c0                	test   %eax,%eax
  804451:	74 0d                	je     804460 <insert_sorted_with_merge_freeList+0x264>
  804453:	a1 48 61 80 00       	mov    0x806148,%eax
  804458:	8b 55 08             	mov    0x8(%ebp),%edx
  80445b:	89 50 04             	mov    %edx,0x4(%eax)
  80445e:	eb 08                	jmp    804468 <insert_sorted_with_merge_freeList+0x26c>
  804460:	8b 45 08             	mov    0x8(%ebp),%eax
  804463:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804468:	8b 45 08             	mov    0x8(%ebp),%eax
  80446b:	a3 48 61 80 00       	mov    %eax,0x806148
  804470:	8b 45 08             	mov    0x8(%ebp),%eax
  804473:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80447a:	a1 54 61 80 00       	mov    0x806154,%eax
  80447f:	40                   	inc    %eax
  804480:	a3 54 61 80 00       	mov    %eax,0x806154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804485:	e9 bb 04 00 00       	jmp    804945 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80448a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80448e:	75 17                	jne    8044a7 <insert_sorted_with_merge_freeList+0x2ab>
  804490:	83 ec 04             	sub    $0x4,%esp
  804493:	68 20 56 80 00       	push   $0x805620
  804498:	68 4c 01 00 00       	push   $0x14c
  80449d:	68 cf 55 80 00       	push   $0x8055cf
  8044a2:	e8 83 d4 ff ff       	call   80192a <_panic>
  8044a7:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  8044ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8044b0:	89 50 04             	mov    %edx,0x4(%eax)
  8044b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8044b6:	8b 40 04             	mov    0x4(%eax),%eax
  8044b9:	85 c0                	test   %eax,%eax
  8044bb:	74 0c                	je     8044c9 <insert_sorted_with_merge_freeList+0x2cd>
  8044bd:	a1 3c 61 80 00       	mov    0x80613c,%eax
  8044c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8044c5:	89 10                	mov    %edx,(%eax)
  8044c7:	eb 08                	jmp    8044d1 <insert_sorted_with_merge_freeList+0x2d5>
  8044c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8044cc:	a3 38 61 80 00       	mov    %eax,0x806138
  8044d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8044d4:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8044d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8044dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044e2:	a1 44 61 80 00       	mov    0x806144,%eax
  8044e7:	40                   	inc    %eax
  8044e8:	a3 44 61 80 00       	mov    %eax,0x806144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8044ed:	e9 53 04 00 00       	jmp    804945 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8044f2:	a1 38 61 80 00       	mov    0x806138,%eax
  8044f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8044fa:	e9 15 04 00 00       	jmp    804914 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8044ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804502:	8b 00                	mov    (%eax),%eax
  804504:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  804507:	8b 45 08             	mov    0x8(%ebp),%eax
  80450a:	8b 50 08             	mov    0x8(%eax),%edx
  80450d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804510:	8b 40 08             	mov    0x8(%eax),%eax
  804513:	39 c2                	cmp    %eax,%edx
  804515:	0f 86 f1 03 00 00    	jbe    80490c <insert_sorted_with_merge_freeList+0x710>
  80451b:	8b 45 08             	mov    0x8(%ebp),%eax
  80451e:	8b 50 08             	mov    0x8(%eax),%edx
  804521:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804524:	8b 40 08             	mov    0x8(%eax),%eax
  804527:	39 c2                	cmp    %eax,%edx
  804529:	0f 83 dd 03 00 00    	jae    80490c <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80452f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804532:	8b 50 08             	mov    0x8(%eax),%edx
  804535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804538:	8b 40 0c             	mov    0xc(%eax),%eax
  80453b:	01 c2                	add    %eax,%edx
  80453d:	8b 45 08             	mov    0x8(%ebp),%eax
  804540:	8b 40 08             	mov    0x8(%eax),%eax
  804543:	39 c2                	cmp    %eax,%edx
  804545:	0f 85 b9 01 00 00    	jne    804704 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80454b:	8b 45 08             	mov    0x8(%ebp),%eax
  80454e:	8b 50 08             	mov    0x8(%eax),%edx
  804551:	8b 45 08             	mov    0x8(%ebp),%eax
  804554:	8b 40 0c             	mov    0xc(%eax),%eax
  804557:	01 c2                	add    %eax,%edx
  804559:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80455c:	8b 40 08             	mov    0x8(%eax),%eax
  80455f:	39 c2                	cmp    %eax,%edx
  804561:	0f 85 0d 01 00 00    	jne    804674 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  804567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80456a:	8b 50 0c             	mov    0xc(%eax),%edx
  80456d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804570:	8b 40 0c             	mov    0xc(%eax),%eax
  804573:	01 c2                	add    %eax,%edx
  804575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804578:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80457b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80457f:	75 17                	jne    804598 <insert_sorted_with_merge_freeList+0x39c>
  804581:	83 ec 04             	sub    $0x4,%esp
  804584:	68 78 56 80 00       	push   $0x805678
  804589:	68 5c 01 00 00       	push   $0x15c
  80458e:	68 cf 55 80 00       	push   $0x8055cf
  804593:	e8 92 d3 ff ff       	call   80192a <_panic>
  804598:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80459b:	8b 00                	mov    (%eax),%eax
  80459d:	85 c0                	test   %eax,%eax
  80459f:	74 10                	je     8045b1 <insert_sorted_with_merge_freeList+0x3b5>
  8045a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045a4:	8b 00                	mov    (%eax),%eax
  8045a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8045a9:	8b 52 04             	mov    0x4(%edx),%edx
  8045ac:	89 50 04             	mov    %edx,0x4(%eax)
  8045af:	eb 0b                	jmp    8045bc <insert_sorted_with_merge_freeList+0x3c0>
  8045b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045b4:	8b 40 04             	mov    0x4(%eax),%eax
  8045b7:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8045bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045bf:	8b 40 04             	mov    0x4(%eax),%eax
  8045c2:	85 c0                	test   %eax,%eax
  8045c4:	74 0f                	je     8045d5 <insert_sorted_with_merge_freeList+0x3d9>
  8045c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045c9:	8b 40 04             	mov    0x4(%eax),%eax
  8045cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8045cf:	8b 12                	mov    (%edx),%edx
  8045d1:	89 10                	mov    %edx,(%eax)
  8045d3:	eb 0a                	jmp    8045df <insert_sorted_with_merge_freeList+0x3e3>
  8045d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045d8:	8b 00                	mov    (%eax),%eax
  8045da:	a3 38 61 80 00       	mov    %eax,0x806138
  8045df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8045e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045f2:	a1 44 61 80 00       	mov    0x806144,%eax
  8045f7:	48                   	dec    %eax
  8045f8:	a3 44 61 80 00       	mov    %eax,0x806144
						nextBlock->sva = 0;
  8045fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804600:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  804607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80460a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  804611:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804615:	75 17                	jne    80462e <insert_sorted_with_merge_freeList+0x432>
  804617:	83 ec 04             	sub    $0x4,%esp
  80461a:	68 ac 55 80 00       	push   $0x8055ac
  80461f:	68 5f 01 00 00       	push   $0x15f
  804624:	68 cf 55 80 00       	push   $0x8055cf
  804629:	e8 fc d2 ff ff       	call   80192a <_panic>
  80462e:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804634:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804637:	89 10                	mov    %edx,(%eax)
  804639:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80463c:	8b 00                	mov    (%eax),%eax
  80463e:	85 c0                	test   %eax,%eax
  804640:	74 0d                	je     80464f <insert_sorted_with_merge_freeList+0x453>
  804642:	a1 48 61 80 00       	mov    0x806148,%eax
  804647:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80464a:	89 50 04             	mov    %edx,0x4(%eax)
  80464d:	eb 08                	jmp    804657 <insert_sorted_with_merge_freeList+0x45b>
  80464f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804652:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804657:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80465a:	a3 48 61 80 00       	mov    %eax,0x806148
  80465f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804662:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804669:	a1 54 61 80 00       	mov    0x806154,%eax
  80466e:	40                   	inc    %eax
  80466f:	a3 54 61 80 00       	mov    %eax,0x806154
					}
					currentBlock->size += blockToInsert->size;
  804674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804677:	8b 50 0c             	mov    0xc(%eax),%edx
  80467a:	8b 45 08             	mov    0x8(%ebp),%eax
  80467d:	8b 40 0c             	mov    0xc(%eax),%eax
  804680:	01 c2                	add    %eax,%edx
  804682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804685:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  804688:	8b 45 08             	mov    0x8(%ebp),%eax
  80468b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  804692:	8b 45 08             	mov    0x8(%ebp),%eax
  804695:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80469c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8046a0:	75 17                	jne    8046b9 <insert_sorted_with_merge_freeList+0x4bd>
  8046a2:	83 ec 04             	sub    $0x4,%esp
  8046a5:	68 ac 55 80 00       	push   $0x8055ac
  8046aa:	68 64 01 00 00       	push   $0x164
  8046af:	68 cf 55 80 00       	push   $0x8055cf
  8046b4:	e8 71 d2 ff ff       	call   80192a <_panic>
  8046b9:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8046bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8046c2:	89 10                	mov    %edx,(%eax)
  8046c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8046c7:	8b 00                	mov    (%eax),%eax
  8046c9:	85 c0                	test   %eax,%eax
  8046cb:	74 0d                	je     8046da <insert_sorted_with_merge_freeList+0x4de>
  8046cd:	a1 48 61 80 00       	mov    0x806148,%eax
  8046d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8046d5:	89 50 04             	mov    %edx,0x4(%eax)
  8046d8:	eb 08                	jmp    8046e2 <insert_sorted_with_merge_freeList+0x4e6>
  8046da:	8b 45 08             	mov    0x8(%ebp),%eax
  8046dd:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8046e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8046e5:	a3 48 61 80 00       	mov    %eax,0x806148
  8046ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8046ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8046f4:	a1 54 61 80 00       	mov    0x806154,%eax
  8046f9:	40                   	inc    %eax
  8046fa:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  8046ff:	e9 41 02 00 00       	jmp    804945 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  804704:	8b 45 08             	mov    0x8(%ebp),%eax
  804707:	8b 50 08             	mov    0x8(%eax),%edx
  80470a:	8b 45 08             	mov    0x8(%ebp),%eax
  80470d:	8b 40 0c             	mov    0xc(%eax),%eax
  804710:	01 c2                	add    %eax,%edx
  804712:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804715:	8b 40 08             	mov    0x8(%eax),%eax
  804718:	39 c2                	cmp    %eax,%edx
  80471a:	0f 85 7c 01 00 00    	jne    80489c <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  804720:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804724:	74 06                	je     80472c <insert_sorted_with_merge_freeList+0x530>
  804726:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80472a:	75 17                	jne    804743 <insert_sorted_with_merge_freeList+0x547>
  80472c:	83 ec 04             	sub    $0x4,%esp
  80472f:	68 e8 55 80 00       	push   $0x8055e8
  804734:	68 69 01 00 00       	push   $0x169
  804739:	68 cf 55 80 00       	push   $0x8055cf
  80473e:	e8 e7 d1 ff ff       	call   80192a <_panic>
  804743:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804746:	8b 50 04             	mov    0x4(%eax),%edx
  804749:	8b 45 08             	mov    0x8(%ebp),%eax
  80474c:	89 50 04             	mov    %edx,0x4(%eax)
  80474f:	8b 45 08             	mov    0x8(%ebp),%eax
  804752:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804755:	89 10                	mov    %edx,(%eax)
  804757:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80475a:	8b 40 04             	mov    0x4(%eax),%eax
  80475d:	85 c0                	test   %eax,%eax
  80475f:	74 0d                	je     80476e <insert_sorted_with_merge_freeList+0x572>
  804761:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804764:	8b 40 04             	mov    0x4(%eax),%eax
  804767:	8b 55 08             	mov    0x8(%ebp),%edx
  80476a:	89 10                	mov    %edx,(%eax)
  80476c:	eb 08                	jmp    804776 <insert_sorted_with_merge_freeList+0x57a>
  80476e:	8b 45 08             	mov    0x8(%ebp),%eax
  804771:	a3 38 61 80 00       	mov    %eax,0x806138
  804776:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804779:	8b 55 08             	mov    0x8(%ebp),%edx
  80477c:	89 50 04             	mov    %edx,0x4(%eax)
  80477f:	a1 44 61 80 00       	mov    0x806144,%eax
  804784:	40                   	inc    %eax
  804785:	a3 44 61 80 00       	mov    %eax,0x806144
					blockToInsert->size += nextBlock->size;
  80478a:	8b 45 08             	mov    0x8(%ebp),%eax
  80478d:	8b 50 0c             	mov    0xc(%eax),%edx
  804790:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804793:	8b 40 0c             	mov    0xc(%eax),%eax
  804796:	01 c2                	add    %eax,%edx
  804798:	8b 45 08             	mov    0x8(%ebp),%eax
  80479b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80479e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8047a2:	75 17                	jne    8047bb <insert_sorted_with_merge_freeList+0x5bf>
  8047a4:	83 ec 04             	sub    $0x4,%esp
  8047a7:	68 78 56 80 00       	push   $0x805678
  8047ac:	68 6b 01 00 00       	push   $0x16b
  8047b1:	68 cf 55 80 00       	push   $0x8055cf
  8047b6:	e8 6f d1 ff ff       	call   80192a <_panic>
  8047bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047be:	8b 00                	mov    (%eax),%eax
  8047c0:	85 c0                	test   %eax,%eax
  8047c2:	74 10                	je     8047d4 <insert_sorted_with_merge_freeList+0x5d8>
  8047c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047c7:	8b 00                	mov    (%eax),%eax
  8047c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8047cc:	8b 52 04             	mov    0x4(%edx),%edx
  8047cf:	89 50 04             	mov    %edx,0x4(%eax)
  8047d2:	eb 0b                	jmp    8047df <insert_sorted_with_merge_freeList+0x5e3>
  8047d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047d7:	8b 40 04             	mov    0x4(%eax),%eax
  8047da:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8047df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047e2:	8b 40 04             	mov    0x4(%eax),%eax
  8047e5:	85 c0                	test   %eax,%eax
  8047e7:	74 0f                	je     8047f8 <insert_sorted_with_merge_freeList+0x5fc>
  8047e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047ec:	8b 40 04             	mov    0x4(%eax),%eax
  8047ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8047f2:	8b 12                	mov    (%edx),%edx
  8047f4:	89 10                	mov    %edx,(%eax)
  8047f6:	eb 0a                	jmp    804802 <insert_sorted_with_merge_freeList+0x606>
  8047f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047fb:	8b 00                	mov    (%eax),%eax
  8047fd:	a3 38 61 80 00       	mov    %eax,0x806138
  804802:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804805:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80480b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80480e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804815:	a1 44 61 80 00       	mov    0x806144,%eax
  80481a:	48                   	dec    %eax
  80481b:	a3 44 61 80 00       	mov    %eax,0x806144
					nextBlock->sva = 0;
  804820:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804823:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80482a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80482d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  804834:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804838:	75 17                	jne    804851 <insert_sorted_with_merge_freeList+0x655>
  80483a:	83 ec 04             	sub    $0x4,%esp
  80483d:	68 ac 55 80 00       	push   $0x8055ac
  804842:	68 6e 01 00 00       	push   $0x16e
  804847:	68 cf 55 80 00       	push   $0x8055cf
  80484c:	e8 d9 d0 ff ff       	call   80192a <_panic>
  804851:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804857:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80485a:	89 10                	mov    %edx,(%eax)
  80485c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80485f:	8b 00                	mov    (%eax),%eax
  804861:	85 c0                	test   %eax,%eax
  804863:	74 0d                	je     804872 <insert_sorted_with_merge_freeList+0x676>
  804865:	a1 48 61 80 00       	mov    0x806148,%eax
  80486a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80486d:	89 50 04             	mov    %edx,0x4(%eax)
  804870:	eb 08                	jmp    80487a <insert_sorted_with_merge_freeList+0x67e>
  804872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804875:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80487a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80487d:	a3 48 61 80 00       	mov    %eax,0x806148
  804882:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804885:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80488c:	a1 54 61 80 00       	mov    0x806154,%eax
  804891:	40                   	inc    %eax
  804892:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  804897:	e9 a9 00 00 00       	jmp    804945 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80489c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8048a0:	74 06                	je     8048a8 <insert_sorted_with_merge_freeList+0x6ac>
  8048a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8048a6:	75 17                	jne    8048bf <insert_sorted_with_merge_freeList+0x6c3>
  8048a8:	83 ec 04             	sub    $0x4,%esp
  8048ab:	68 44 56 80 00       	push   $0x805644
  8048b0:	68 73 01 00 00       	push   $0x173
  8048b5:	68 cf 55 80 00       	push   $0x8055cf
  8048ba:	e8 6b d0 ff ff       	call   80192a <_panic>
  8048bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048c2:	8b 10                	mov    (%eax),%edx
  8048c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8048c7:	89 10                	mov    %edx,(%eax)
  8048c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8048cc:	8b 00                	mov    (%eax),%eax
  8048ce:	85 c0                	test   %eax,%eax
  8048d0:	74 0b                	je     8048dd <insert_sorted_with_merge_freeList+0x6e1>
  8048d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048d5:	8b 00                	mov    (%eax),%eax
  8048d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8048da:	89 50 04             	mov    %edx,0x4(%eax)
  8048dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8048e3:	89 10                	mov    %edx,(%eax)
  8048e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8048e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8048eb:	89 50 04             	mov    %edx,0x4(%eax)
  8048ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8048f1:	8b 00                	mov    (%eax),%eax
  8048f3:	85 c0                	test   %eax,%eax
  8048f5:	75 08                	jne    8048ff <insert_sorted_with_merge_freeList+0x703>
  8048f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8048fa:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8048ff:	a1 44 61 80 00       	mov    0x806144,%eax
  804904:	40                   	inc    %eax
  804905:	a3 44 61 80 00       	mov    %eax,0x806144
					break;
  80490a:	eb 39                	jmp    804945 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80490c:	a1 40 61 80 00       	mov    0x806140,%eax
  804911:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804914:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804918:	74 07                	je     804921 <insert_sorted_with_merge_freeList+0x725>
  80491a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80491d:	8b 00                	mov    (%eax),%eax
  80491f:	eb 05                	jmp    804926 <insert_sorted_with_merge_freeList+0x72a>
  804921:	b8 00 00 00 00       	mov    $0x0,%eax
  804926:	a3 40 61 80 00       	mov    %eax,0x806140
  80492b:	a1 40 61 80 00       	mov    0x806140,%eax
  804930:	85 c0                	test   %eax,%eax
  804932:	0f 85 c7 fb ff ff    	jne    8044ff <insert_sorted_with_merge_freeList+0x303>
  804938:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80493c:	0f 85 bd fb ff ff    	jne    8044ff <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804942:	eb 01                	jmp    804945 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  804944:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804945:	90                   	nop
  804946:	c9                   	leave  
  804947:	c3                   	ret    

00804948 <__udivdi3>:
  804948:	55                   	push   %ebp
  804949:	57                   	push   %edi
  80494a:	56                   	push   %esi
  80494b:	53                   	push   %ebx
  80494c:	83 ec 1c             	sub    $0x1c,%esp
  80494f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804953:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804957:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80495b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80495f:	89 ca                	mov    %ecx,%edx
  804961:	89 f8                	mov    %edi,%eax
  804963:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804967:	85 f6                	test   %esi,%esi
  804969:	75 2d                	jne    804998 <__udivdi3+0x50>
  80496b:	39 cf                	cmp    %ecx,%edi
  80496d:	77 65                	ja     8049d4 <__udivdi3+0x8c>
  80496f:	89 fd                	mov    %edi,%ebp
  804971:	85 ff                	test   %edi,%edi
  804973:	75 0b                	jne    804980 <__udivdi3+0x38>
  804975:	b8 01 00 00 00       	mov    $0x1,%eax
  80497a:	31 d2                	xor    %edx,%edx
  80497c:	f7 f7                	div    %edi
  80497e:	89 c5                	mov    %eax,%ebp
  804980:	31 d2                	xor    %edx,%edx
  804982:	89 c8                	mov    %ecx,%eax
  804984:	f7 f5                	div    %ebp
  804986:	89 c1                	mov    %eax,%ecx
  804988:	89 d8                	mov    %ebx,%eax
  80498a:	f7 f5                	div    %ebp
  80498c:	89 cf                	mov    %ecx,%edi
  80498e:	89 fa                	mov    %edi,%edx
  804990:	83 c4 1c             	add    $0x1c,%esp
  804993:	5b                   	pop    %ebx
  804994:	5e                   	pop    %esi
  804995:	5f                   	pop    %edi
  804996:	5d                   	pop    %ebp
  804997:	c3                   	ret    
  804998:	39 ce                	cmp    %ecx,%esi
  80499a:	77 28                	ja     8049c4 <__udivdi3+0x7c>
  80499c:	0f bd fe             	bsr    %esi,%edi
  80499f:	83 f7 1f             	xor    $0x1f,%edi
  8049a2:	75 40                	jne    8049e4 <__udivdi3+0x9c>
  8049a4:	39 ce                	cmp    %ecx,%esi
  8049a6:	72 0a                	jb     8049b2 <__udivdi3+0x6a>
  8049a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8049ac:	0f 87 9e 00 00 00    	ja     804a50 <__udivdi3+0x108>
  8049b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8049b7:	89 fa                	mov    %edi,%edx
  8049b9:	83 c4 1c             	add    $0x1c,%esp
  8049bc:	5b                   	pop    %ebx
  8049bd:	5e                   	pop    %esi
  8049be:	5f                   	pop    %edi
  8049bf:	5d                   	pop    %ebp
  8049c0:	c3                   	ret    
  8049c1:	8d 76 00             	lea    0x0(%esi),%esi
  8049c4:	31 ff                	xor    %edi,%edi
  8049c6:	31 c0                	xor    %eax,%eax
  8049c8:	89 fa                	mov    %edi,%edx
  8049ca:	83 c4 1c             	add    $0x1c,%esp
  8049cd:	5b                   	pop    %ebx
  8049ce:	5e                   	pop    %esi
  8049cf:	5f                   	pop    %edi
  8049d0:	5d                   	pop    %ebp
  8049d1:	c3                   	ret    
  8049d2:	66 90                	xchg   %ax,%ax
  8049d4:	89 d8                	mov    %ebx,%eax
  8049d6:	f7 f7                	div    %edi
  8049d8:	31 ff                	xor    %edi,%edi
  8049da:	89 fa                	mov    %edi,%edx
  8049dc:	83 c4 1c             	add    $0x1c,%esp
  8049df:	5b                   	pop    %ebx
  8049e0:	5e                   	pop    %esi
  8049e1:	5f                   	pop    %edi
  8049e2:	5d                   	pop    %ebp
  8049e3:	c3                   	ret    
  8049e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8049e9:	89 eb                	mov    %ebp,%ebx
  8049eb:	29 fb                	sub    %edi,%ebx
  8049ed:	89 f9                	mov    %edi,%ecx
  8049ef:	d3 e6                	shl    %cl,%esi
  8049f1:	89 c5                	mov    %eax,%ebp
  8049f3:	88 d9                	mov    %bl,%cl
  8049f5:	d3 ed                	shr    %cl,%ebp
  8049f7:	89 e9                	mov    %ebp,%ecx
  8049f9:	09 f1                	or     %esi,%ecx
  8049fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8049ff:	89 f9                	mov    %edi,%ecx
  804a01:	d3 e0                	shl    %cl,%eax
  804a03:	89 c5                	mov    %eax,%ebp
  804a05:	89 d6                	mov    %edx,%esi
  804a07:	88 d9                	mov    %bl,%cl
  804a09:	d3 ee                	shr    %cl,%esi
  804a0b:	89 f9                	mov    %edi,%ecx
  804a0d:	d3 e2                	shl    %cl,%edx
  804a0f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804a13:	88 d9                	mov    %bl,%cl
  804a15:	d3 e8                	shr    %cl,%eax
  804a17:	09 c2                	or     %eax,%edx
  804a19:	89 d0                	mov    %edx,%eax
  804a1b:	89 f2                	mov    %esi,%edx
  804a1d:	f7 74 24 0c          	divl   0xc(%esp)
  804a21:	89 d6                	mov    %edx,%esi
  804a23:	89 c3                	mov    %eax,%ebx
  804a25:	f7 e5                	mul    %ebp
  804a27:	39 d6                	cmp    %edx,%esi
  804a29:	72 19                	jb     804a44 <__udivdi3+0xfc>
  804a2b:	74 0b                	je     804a38 <__udivdi3+0xf0>
  804a2d:	89 d8                	mov    %ebx,%eax
  804a2f:	31 ff                	xor    %edi,%edi
  804a31:	e9 58 ff ff ff       	jmp    80498e <__udivdi3+0x46>
  804a36:	66 90                	xchg   %ax,%ax
  804a38:	8b 54 24 08          	mov    0x8(%esp),%edx
  804a3c:	89 f9                	mov    %edi,%ecx
  804a3e:	d3 e2                	shl    %cl,%edx
  804a40:	39 c2                	cmp    %eax,%edx
  804a42:	73 e9                	jae    804a2d <__udivdi3+0xe5>
  804a44:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804a47:	31 ff                	xor    %edi,%edi
  804a49:	e9 40 ff ff ff       	jmp    80498e <__udivdi3+0x46>
  804a4e:	66 90                	xchg   %ax,%ax
  804a50:	31 c0                	xor    %eax,%eax
  804a52:	e9 37 ff ff ff       	jmp    80498e <__udivdi3+0x46>
  804a57:	90                   	nop

00804a58 <__umoddi3>:
  804a58:	55                   	push   %ebp
  804a59:	57                   	push   %edi
  804a5a:	56                   	push   %esi
  804a5b:	53                   	push   %ebx
  804a5c:	83 ec 1c             	sub    $0x1c,%esp
  804a5f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804a63:	8b 74 24 34          	mov    0x34(%esp),%esi
  804a67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804a6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804a6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804a73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804a77:	89 f3                	mov    %esi,%ebx
  804a79:	89 fa                	mov    %edi,%edx
  804a7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804a7f:	89 34 24             	mov    %esi,(%esp)
  804a82:	85 c0                	test   %eax,%eax
  804a84:	75 1a                	jne    804aa0 <__umoddi3+0x48>
  804a86:	39 f7                	cmp    %esi,%edi
  804a88:	0f 86 a2 00 00 00    	jbe    804b30 <__umoddi3+0xd8>
  804a8e:	89 c8                	mov    %ecx,%eax
  804a90:	89 f2                	mov    %esi,%edx
  804a92:	f7 f7                	div    %edi
  804a94:	89 d0                	mov    %edx,%eax
  804a96:	31 d2                	xor    %edx,%edx
  804a98:	83 c4 1c             	add    $0x1c,%esp
  804a9b:	5b                   	pop    %ebx
  804a9c:	5e                   	pop    %esi
  804a9d:	5f                   	pop    %edi
  804a9e:	5d                   	pop    %ebp
  804a9f:	c3                   	ret    
  804aa0:	39 f0                	cmp    %esi,%eax
  804aa2:	0f 87 ac 00 00 00    	ja     804b54 <__umoddi3+0xfc>
  804aa8:	0f bd e8             	bsr    %eax,%ebp
  804aab:	83 f5 1f             	xor    $0x1f,%ebp
  804aae:	0f 84 ac 00 00 00    	je     804b60 <__umoddi3+0x108>
  804ab4:	bf 20 00 00 00       	mov    $0x20,%edi
  804ab9:	29 ef                	sub    %ebp,%edi
  804abb:	89 fe                	mov    %edi,%esi
  804abd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804ac1:	89 e9                	mov    %ebp,%ecx
  804ac3:	d3 e0                	shl    %cl,%eax
  804ac5:	89 d7                	mov    %edx,%edi
  804ac7:	89 f1                	mov    %esi,%ecx
  804ac9:	d3 ef                	shr    %cl,%edi
  804acb:	09 c7                	or     %eax,%edi
  804acd:	89 e9                	mov    %ebp,%ecx
  804acf:	d3 e2                	shl    %cl,%edx
  804ad1:	89 14 24             	mov    %edx,(%esp)
  804ad4:	89 d8                	mov    %ebx,%eax
  804ad6:	d3 e0                	shl    %cl,%eax
  804ad8:	89 c2                	mov    %eax,%edx
  804ada:	8b 44 24 08          	mov    0x8(%esp),%eax
  804ade:	d3 e0                	shl    %cl,%eax
  804ae0:	89 44 24 04          	mov    %eax,0x4(%esp)
  804ae4:	8b 44 24 08          	mov    0x8(%esp),%eax
  804ae8:	89 f1                	mov    %esi,%ecx
  804aea:	d3 e8                	shr    %cl,%eax
  804aec:	09 d0                	or     %edx,%eax
  804aee:	d3 eb                	shr    %cl,%ebx
  804af0:	89 da                	mov    %ebx,%edx
  804af2:	f7 f7                	div    %edi
  804af4:	89 d3                	mov    %edx,%ebx
  804af6:	f7 24 24             	mull   (%esp)
  804af9:	89 c6                	mov    %eax,%esi
  804afb:	89 d1                	mov    %edx,%ecx
  804afd:	39 d3                	cmp    %edx,%ebx
  804aff:	0f 82 87 00 00 00    	jb     804b8c <__umoddi3+0x134>
  804b05:	0f 84 91 00 00 00    	je     804b9c <__umoddi3+0x144>
  804b0b:	8b 54 24 04          	mov    0x4(%esp),%edx
  804b0f:	29 f2                	sub    %esi,%edx
  804b11:	19 cb                	sbb    %ecx,%ebx
  804b13:	89 d8                	mov    %ebx,%eax
  804b15:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804b19:	d3 e0                	shl    %cl,%eax
  804b1b:	89 e9                	mov    %ebp,%ecx
  804b1d:	d3 ea                	shr    %cl,%edx
  804b1f:	09 d0                	or     %edx,%eax
  804b21:	89 e9                	mov    %ebp,%ecx
  804b23:	d3 eb                	shr    %cl,%ebx
  804b25:	89 da                	mov    %ebx,%edx
  804b27:	83 c4 1c             	add    $0x1c,%esp
  804b2a:	5b                   	pop    %ebx
  804b2b:	5e                   	pop    %esi
  804b2c:	5f                   	pop    %edi
  804b2d:	5d                   	pop    %ebp
  804b2e:	c3                   	ret    
  804b2f:	90                   	nop
  804b30:	89 fd                	mov    %edi,%ebp
  804b32:	85 ff                	test   %edi,%edi
  804b34:	75 0b                	jne    804b41 <__umoddi3+0xe9>
  804b36:	b8 01 00 00 00       	mov    $0x1,%eax
  804b3b:	31 d2                	xor    %edx,%edx
  804b3d:	f7 f7                	div    %edi
  804b3f:	89 c5                	mov    %eax,%ebp
  804b41:	89 f0                	mov    %esi,%eax
  804b43:	31 d2                	xor    %edx,%edx
  804b45:	f7 f5                	div    %ebp
  804b47:	89 c8                	mov    %ecx,%eax
  804b49:	f7 f5                	div    %ebp
  804b4b:	89 d0                	mov    %edx,%eax
  804b4d:	e9 44 ff ff ff       	jmp    804a96 <__umoddi3+0x3e>
  804b52:	66 90                	xchg   %ax,%ax
  804b54:	89 c8                	mov    %ecx,%eax
  804b56:	89 f2                	mov    %esi,%edx
  804b58:	83 c4 1c             	add    $0x1c,%esp
  804b5b:	5b                   	pop    %ebx
  804b5c:	5e                   	pop    %esi
  804b5d:	5f                   	pop    %edi
  804b5e:	5d                   	pop    %ebp
  804b5f:	c3                   	ret    
  804b60:	3b 04 24             	cmp    (%esp),%eax
  804b63:	72 06                	jb     804b6b <__umoddi3+0x113>
  804b65:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804b69:	77 0f                	ja     804b7a <__umoddi3+0x122>
  804b6b:	89 f2                	mov    %esi,%edx
  804b6d:	29 f9                	sub    %edi,%ecx
  804b6f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804b73:	89 14 24             	mov    %edx,(%esp)
  804b76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804b7a:	8b 44 24 04          	mov    0x4(%esp),%eax
  804b7e:	8b 14 24             	mov    (%esp),%edx
  804b81:	83 c4 1c             	add    $0x1c,%esp
  804b84:	5b                   	pop    %ebx
  804b85:	5e                   	pop    %esi
  804b86:	5f                   	pop    %edi
  804b87:	5d                   	pop    %ebp
  804b88:	c3                   	ret    
  804b89:	8d 76 00             	lea    0x0(%esi),%esi
  804b8c:	2b 04 24             	sub    (%esp),%eax
  804b8f:	19 fa                	sbb    %edi,%edx
  804b91:	89 d1                	mov    %edx,%ecx
  804b93:	89 c6                	mov    %eax,%esi
  804b95:	e9 71 ff ff ff       	jmp    804b0b <__umoddi3+0xb3>
  804b9a:	66 90                	xchg   %ax,%ax
  804b9c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804ba0:	72 ea                	jb     804b8c <__umoddi3+0x134>
  804ba2:	89 d9                	mov    %ebx,%ecx
  804ba4:	e9 62 ff ff ff       	jmp    804b0b <__umoddi3+0xb3>
