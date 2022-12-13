
obj/user/tst_malloc_3:     file format elf32-i386


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
  800031:	e8 f6 0d 00 00       	call   800e2c <libmain>
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
  80003d:	81 ec 20 01 00 00    	sub    $0x120,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 29                	jmp    800079 <_main+0x41>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800079:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800091:	68 80 42 80 00       	push   $0x804280
  800096:	6a 1a                	push   $0x1a
  800098:	68 9c 42 80 00       	push   $0x80429c
  80009d:	e8 c6 0e 00 00       	call   800f68 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	6a 00                	push   $0x0
  8000a7:	e8 f8 20 00 00       	call   8021a4 <malloc>
  8000ac:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000af:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  8000b6:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	char minByte = 1<<7;
  8000bd:	c6 45 df 80          	movb   $0x80,-0x21(%ebp)
	char maxByte = 0x7F;
  8000c1:	c6 45 de 7f          	movb   $0x7f,-0x22(%ebp)
	short minShort = 1<<15 ;
  8000c5:	66 c7 45 dc 00 80    	movw   $0x8000,-0x24(%ebp)
	short maxShort = 0x7FFF;
  8000cb:	66 c7 45 da ff 7f    	movw   $0x7fff,-0x26(%ebp)
	int minInt = 1<<31 ;
  8000d1:	c7 45 d4 00 00 00 80 	movl   $0x80000000,-0x2c(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d8:	c7 45 d0 ff ff ff 7f 	movl   $0x7fffffff,-0x30(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 6d 23 00 00       	call   802451 <sys_calculate_free_frames>
  8000e4:	89 45 cc             	mov    %eax,-0x34(%ebp)

	void* ptr_allocations[20] = {0};
  8000e7:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  8000ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fb:	e8 f1 23 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  800100:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 90 20 00 00       	call   8021a4 <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0d                	jns    800134 <_main+0xfc>
  800127:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  80012d:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800132:	76 14                	jbe    800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 b0 42 80 00       	push   $0x8042b0
  80013c:	6a 39                	push   $0x39
  80013e:	68 9c 42 80 00       	push   $0x80429c
  800143:	e8 20 0e 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 a4 23 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 18 43 80 00       	push   $0x804318
  80015a:	6a 3a                	push   $0x3a
  80015c:	68 9c 42 80 00       	push   $0x80429c
  800161:	e8 02 0e 00 00       	call   800f68 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 e6 22 00 00       	call   802451 <sys_calculate_free_frames>
  80016b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80016e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800171:	01 c0                	add    %eax,%eax
  800173:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	89 45 c0             	mov    %eax,-0x40(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017a:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800180:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr[0] = minByte ;
  800183:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800186:	8a 55 df             	mov    -0x21(%ebp),%dl
  800189:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80018b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80018e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800191:	01 c2                	add    %eax,%edx
  800193:	8a 45 de             	mov    -0x22(%ebp),%al
  800196:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800198:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80019b:	e8 b1 22 00 00       	call   802451 <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 48 43 80 00       	push   $0x804348
  8001b1:	6a 41                	push   $0x41
  8001b3:	68 9c 42 80 00       	push   $0x80429c
  8001b8:	e8 ab 0d 00 00       	call   800f68 <_panic>
		int var;
		int found = 0;
  8001bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cb:	e9 82 00 00 00       	jmp    800252 <_main+0x21a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001de:	89 d0                	mov    %edx,%eax
  8001e0:	01 c0                	add    %eax,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	c1 e0 03             	shl    $0x3,%eax
  8001e7:	01 c8                	add    %ecx,%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001fb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001fe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800201:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800206:	39 c2                	cmp    %eax,%edx
  800208:	75 03                	jne    80020d <_main+0x1d5>
				found++;
  80020a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  80020d:	a1 20 50 80 00       	mov    0x805020,%eax
  800212:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800218:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80021b:	89 d0                	mov    %edx,%eax
  80021d:	01 c0                	add    %eax,%eax
  80021f:	01 d0                	add    %edx,%eax
  800221:	c1 e0 03             	shl    $0x3,%eax
  800224:	01 c8                	add    %ecx,%eax
  800226:	8b 00                	mov    (%eax),%eax
  800228:	89 45 b0             	mov    %eax,-0x50(%ebp)
  80022b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80022e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800233:	89 c1                	mov    %eax,%ecx
  800235:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800238:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80023b:	01 d0                	add    %edx,%eax
  80023d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800240:	8b 45 ac             	mov    -0x54(%ebp),%eax
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
  800252:	a1 20 50 80 00       	mov    0x805020,%eax
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
  80026e:	68 8c 43 80 00       	push   $0x80438c
  800273:	6a 4b                	push   $0x4b
  800275:	68 9c 42 80 00       	push   $0x80429c
  80027a:	e8 e9 0c 00 00       	call   800f68 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 6d 22 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  800284:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 0c 1f 00 00       	call   8021a4 <malloc>
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a1:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002a7:	89 c2                	mov    %eax,%edx
  8002a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ac:	01 c0                	add    %eax,%eax
  8002ae:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	72 16                	jb     8002cd <_main+0x295>
  8002b7:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002bd:	89 c2                	mov    %eax,%edx
  8002bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002c9:	39 c2                	cmp    %eax,%edx
  8002cb:	76 14                	jbe    8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 b0 42 80 00       	push   $0x8042b0
  8002d5:	6a 50                	push   $0x50
  8002d7:	68 9c 42 80 00       	push   $0x80429c
  8002dc:	e8 87 0c 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 0b 22 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 18 43 80 00       	push   $0x804318
  8002f3:	6a 51                	push   $0x51
  8002f5:	68 9c 42 80 00       	push   $0x80429c
  8002fa:	e8 69 0c 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 4d 21 00 00       	call   802451 <sys_calculate_free_frames>
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800307:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  80030d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800318:	d1 e8                	shr    %eax
  80031a:	48                   	dec    %eax
  80031b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		shortArr[0] = minShort;
  80031e:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800321:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800324:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800327:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80032a:	01 c0                	add    %eax,%eax
  80032c:	89 c2                	mov    %eax,%edx
  80032e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800331:	01 c2                	add    %eax,%edx
  800333:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800337:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80033a:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80033d:	e8 0f 21 00 00       	call   802451 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 48 43 80 00       	push   $0x804348
  800353:	6a 58                	push   $0x58
  800355:	68 9c 42 80 00       	push   $0x80429c
  80035a:	e8 09 0c 00 00       	call   800f68 <_panic>
		found = 0;
  80035f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800366:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80036d:	e9 86 00 00 00       	jmp    8003f8 <_main+0x3c0>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800372:	a1 20 50 80 00       	mov    0x805020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800390:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
  80039a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80039d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8003a0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a8:	39 c2                	cmp    %eax,%edx
  8003aa:	75 03                	jne    8003af <_main+0x377>
				found++;
  8003ac:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003af:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	01 c0                	add    %eax,%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 03             	shl    $0x3,%eax
  8003c6:	01 c8                	add    %ecx,%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003cd:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d5:	89 c2                	mov    %eax,%edx
  8003d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003da:	01 c0                	add    %eax,%eax
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e1:	01 c8                	add    %ecx,%eax
  8003e3:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003e6:	8b 45 94             	mov    -0x6c(%ebp),%eax
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
  8003f8:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800414:	68 8c 43 80 00       	push   $0x80438c
  800419:	6a 61                	push   $0x61
  80041b:	68 9c 42 80 00       	push   $0x80429c
  800420:	e8 43 0b 00 00       	call   800f68 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 c7 20 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  80042a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  80042d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800430:	89 c2                	mov    %eax,%edx
  800432:	01 d2                	add    %edx,%edx
  800434:	01 d0                	add    %edx,%eax
  800436:	83 ec 0c             	sub    $0xc,%esp
  800439:	50                   	push   %eax
  80043a:	e8 65 1d 00 00       	call   8021a4 <malloc>
  80043f:	83 c4 10             	add    $0x10,%esp
  800442:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800448:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80044e:	89 c2                	mov    %eax,%edx
  800450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800453:	c1 e0 02             	shl    $0x2,%eax
  800456:	05 00 00 00 80       	add    $0x80000000,%eax
  80045b:	39 c2                	cmp    %eax,%edx
  80045d:	72 17                	jb     800476 <_main+0x43e>
  80045f:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800465:	89 c2                	mov    %eax,%edx
  800467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046a:	c1 e0 02             	shl    $0x2,%eax
  80046d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	76 14                	jbe    80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 b0 42 80 00       	push   $0x8042b0
  80047e:	6a 66                	push   $0x66
  800480:	68 9c 42 80 00       	push   $0x80429c
  800485:	e8 de 0a 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80048a:	e8 62 20 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  80048f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800492:	74 14                	je     8004a8 <_main+0x470>
  800494:	83 ec 04             	sub    $0x4,%esp
  800497:	68 18 43 80 00       	push   $0x804318
  80049c:	6a 67                	push   $0x67
  80049e:	68 9c 42 80 00       	push   $0x80429c
  8004a3:	e8 c0 0a 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a8:	e8 a4 1f 00 00       	call   802451 <sys_calculate_free_frames>
  8004ad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004b0:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8004b6:	89 45 90             	mov    %eax,-0x70(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bc:	01 c0                	add    %eax,%eax
  8004be:	c1 e8 02             	shr    $0x2,%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr[0] = minInt;
  8004c5:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004cb:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004cd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d7:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004da:	01 c2                	add    %eax,%edx
  8004dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004df:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004e1:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8004e4:	e8 68 1f 00 00       	call   802451 <sys_calculate_free_frames>
  8004e9:	29 c3                	sub    %eax,%ebx
  8004eb:	89 d8                	mov    %ebx,%eax
  8004ed:	83 f8 02             	cmp    $0x2,%eax
  8004f0:	74 14                	je     800506 <_main+0x4ce>
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	68 48 43 80 00       	push   $0x804348
  8004fa:	6a 6e                	push   $0x6e
  8004fc:	68 9c 42 80 00       	push   $0x80429c
  800501:	e8 62 0a 00 00       	call   800f68 <_panic>
		found = 0;
  800506:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80050d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800514:	e9 8f 00 00 00       	jmp    8005a8 <_main+0x570>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800519:	a1 20 50 80 00       	mov    0x805020,%eax
  80051e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800524:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800527:	89 d0                	mov    %edx,%eax
  800529:	01 c0                	add    %eax,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 03             	shl    $0x3,%eax
  800530:	01 c8                	add    %ecx,%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	89 45 88             	mov    %eax,-0x78(%ebp)
  800537:	8b 45 88             	mov    -0x78(%ebp),%eax
  80053a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80053f:	89 c2                	mov    %eax,%edx
  800541:	8b 45 90             	mov    -0x70(%ebp),%eax
  800544:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800547:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80054a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054f:	39 c2                	cmp    %eax,%edx
  800551:	75 03                	jne    800556 <_main+0x51e>
				found++;
  800553:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800556:	a1 20 50 80 00       	mov    0x805020,%eax
  80055b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800561:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800564:	89 d0                	mov    %edx,%eax
  800566:	01 c0                	add    %eax,%eax
  800568:	01 d0                	add    %edx,%eax
  80056a:	c1 e0 03             	shl    $0x3,%eax
  80056d:	01 c8                	add    %ecx,%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	89 45 80             	mov    %eax,-0x80(%ebp)
  800574:	8b 45 80             	mov    -0x80(%ebp),%eax
  800577:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057c:	89 c2                	mov    %eax,%edx
  80057e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 90             	mov    -0x70(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800593:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800599:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80059e:	39 c2                	cmp    %eax,%edx
  8005a0:	75 03                	jne    8005a5 <_main+0x56d>
				found++;
  8005a2:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005a5:	ff 45 ec             	incl   -0x14(%ebp)
  8005a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ad:	8b 50 74             	mov    0x74(%eax),%edx
  8005b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005b3:	39 c2                	cmp    %eax,%edx
  8005b5:	0f 87 5e ff ff ff    	ja     800519 <_main+0x4e1>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005bb:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005bf:	74 14                	je     8005d5 <_main+0x59d>
  8005c1:	83 ec 04             	sub    $0x4,%esp
  8005c4:	68 8c 43 80 00       	push   $0x80438c
  8005c9:	6a 77                	push   $0x77
  8005cb:	68 9c 42 80 00       	push   $0x80429c
  8005d0:	e8 93 09 00 00       	call   800f68 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d5:	e8 77 1e 00 00       	call   802451 <sys_calculate_free_frames>
  8005da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005dd:	e8 0f 1f 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  8005e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8005e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e8:	89 c2                	mov    %eax,%edx
  8005ea:	01 d2                	add    %edx,%edx
  8005ec:	01 d0                	add    %edx,%eax
  8005ee:	83 ec 0c             	sub    $0xc,%esp
  8005f1:	50                   	push   %eax
  8005f2:	e8 ad 1b 00 00       	call   8021a4 <malloc>
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800600:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800606:	89 c2                	mov    %eax,%edx
  800608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80060b:	c1 e0 02             	shl    $0x2,%eax
  80060e:	89 c1                	mov    %eax,%ecx
  800610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800613:	c1 e0 02             	shl    $0x2,%eax
  800616:	01 c8                	add    %ecx,%eax
  800618:	05 00 00 00 80       	add    $0x80000000,%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	72 21                	jb     800642 <_main+0x60a>
  800621:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800627:	89 c2                	mov    %eax,%edx
  800629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80062c:	c1 e0 02             	shl    $0x2,%eax
  80062f:	89 c1                	mov    %eax,%ecx
  800631:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800634:	c1 e0 02             	shl    $0x2,%eax
  800637:	01 c8                	add    %ecx,%eax
  800639:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80063e:	39 c2                	cmp    %eax,%edx
  800640:	76 14                	jbe    800656 <_main+0x61e>
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	68 b0 42 80 00       	push   $0x8042b0
  80064a:	6a 7d                	push   $0x7d
  80064c:	68 9c 42 80 00       	push   $0x80429c
  800651:	e8 12 09 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800656:	e8 96 1e 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  80065b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80065e:	74 14                	je     800674 <_main+0x63c>
  800660:	83 ec 04             	sub    $0x4,%esp
  800663:	68 18 43 80 00       	push   $0x804318
  800668:	6a 7e                	push   $0x7e
  80066a:	68 9c 42 80 00       	push   $0x80429c
  80066f:	e8 f4 08 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800674:	e8 78 1e 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  800679:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80067c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80067f:	89 d0                	mov    %edx,%eax
  800681:	01 c0                	add    %eax,%eax
  800683:	01 d0                	add    %edx,%eax
  800685:	01 c0                	add    %eax,%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	83 ec 0c             	sub    $0xc,%esp
  80068c:	50                   	push   %eax
  80068d:	e8 12 1b 00 00       	call   8021a4 <malloc>
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80069b:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a6:	c1 e0 02             	shl    $0x2,%eax
  8006a9:	89 c1                	mov    %eax,%ecx
  8006ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ae:	c1 e0 03             	shl    $0x3,%eax
  8006b1:	01 c8                	add    %ecx,%eax
  8006b3:	05 00 00 00 80       	add    $0x80000000,%eax
  8006b8:	39 c2                	cmp    %eax,%edx
  8006ba:	72 21                	jb     8006dd <_main+0x6a5>
  8006bc:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006c2:	89 c2                	mov    %eax,%edx
  8006c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c7:	c1 e0 02             	shl    $0x2,%eax
  8006ca:	89 c1                	mov    %eax,%ecx
  8006cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cf:	c1 e0 03             	shl    $0x3,%eax
  8006d2:	01 c8                	add    %ecx,%eax
  8006d4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006d9:	39 c2                	cmp    %eax,%edx
  8006db:	76 17                	jbe    8006f4 <_main+0x6bc>
  8006dd:	83 ec 04             	sub    $0x4,%esp
  8006e0:	68 b0 42 80 00       	push   $0x8042b0
  8006e5:	68 84 00 00 00       	push   $0x84
  8006ea:	68 9c 42 80 00       	push   $0x80429c
  8006ef:	e8 74 08 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f4:	e8 f8 1d 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  8006f9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8006fc:	74 17                	je     800715 <_main+0x6dd>
  8006fe:	83 ec 04             	sub    $0x4,%esp
  800701:	68 18 43 80 00       	push   $0x804318
  800706:	68 85 00 00 00       	push   $0x85
  80070b:	68 9c 42 80 00       	push   $0x80429c
  800710:	e8 53 08 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800715:	e8 37 1d 00 00       	call   802451 <sys_calculate_free_frames>
  80071a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  80071d:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  800723:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800729:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80072c:	89 d0                	mov    %edx,%eax
  80072e:	01 c0                	add    %eax,%eax
  800730:	01 d0                	add    %edx,%eax
  800732:	01 c0                	add    %eax,%eax
  800734:	01 d0                	add    %edx,%eax
  800736:	c1 e8 03             	shr    $0x3,%eax
  800739:	48                   	dec    %eax
  80073a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800740:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800746:	8a 55 df             	mov    -0x21(%ebp),%dl
  800749:	88 10                	mov    %dl,(%eax)
  80074b:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800751:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800754:	66 89 42 02          	mov    %ax,0x2(%edx)
  800758:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80075e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800761:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800764:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80076a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800771:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800777:	01 c2                	add    %eax,%edx
  800779:	8a 45 de             	mov    -0x22(%ebp),%al
  80077c:	88 02                	mov    %al,(%edx)
  80077e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800784:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80078b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800791:	01 c2                	add    %eax,%edx
  800793:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800797:	66 89 42 02          	mov    %ax,0x2(%edx)
  80079b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007a1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007a8:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007ae:	01 c2                	add    %eax,%edx
  8007b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b3:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007b6:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8007b9:	e8 93 1c 00 00       	call   802451 <sys_calculate_free_frames>
  8007be:	29 c3                	sub    %eax,%ebx
  8007c0:	89 d8                	mov    %ebx,%eax
  8007c2:	83 f8 02             	cmp    $0x2,%eax
  8007c5:	74 17                	je     8007de <_main+0x7a6>
  8007c7:	83 ec 04             	sub    $0x4,%esp
  8007ca:	68 48 43 80 00       	push   $0x804348
  8007cf:	68 8c 00 00 00       	push   $0x8c
  8007d4:	68 9c 42 80 00       	push   $0x80429c
  8007d9:	e8 8a 07 00 00       	call   800f68 <_panic>
		found = 0;
  8007de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007ec:	e9 aa 00 00 00       	jmp    80089b <_main+0x863>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8007f6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007ff:	89 d0                	mov    %edx,%eax
  800801:	01 c0                	add    %eax,%eax
  800803:	01 d0                	add    %edx,%eax
  800805:	c1 e0 03             	shl    $0x3,%eax
  800808:	01 c8                	add    %ecx,%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800812:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800818:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80081d:	89 c2                	mov    %eax,%edx
  80081f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800825:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  80082b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800831:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800836:	39 c2                	cmp    %eax,%edx
  800838:	75 03                	jne    80083d <_main+0x805>
				found++;
  80083a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80083d:	a1 20 50 80 00       	mov    0x805020,%eax
  800842:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	01 c0                	add    %eax,%eax
  80084f:	01 d0                	add    %edx,%eax
  800851:	c1 e0 03             	shl    $0x3,%eax
  800854:	01 c8                	add    %ecx,%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  80085e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800864:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800869:	89 c2                	mov    %eax,%edx
  80086b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800871:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800878:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80087e:	01 c8                	add    %ecx,%eax
  800880:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800886:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80088c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800891:	39 c2                	cmp    %eax,%edx
  800893:	75 03                	jne    800898 <_main+0x860>
				found++;
  800895:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800898:	ff 45 ec             	incl   -0x14(%ebp)
  80089b:	a1 20 50 80 00       	mov    0x805020,%eax
  8008a0:	8b 50 74             	mov    0x74(%eax),%edx
  8008a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	0f 87 43 ff ff ff    	ja     8007f1 <_main+0x7b9>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008ae:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008b2:	74 17                	je     8008cb <_main+0x893>
  8008b4:	83 ec 04             	sub    $0x4,%esp
  8008b7:	68 8c 43 80 00       	push   $0x80438c
  8008bc:	68 95 00 00 00       	push   $0x95
  8008c1:	68 9c 42 80 00       	push   $0x80429c
  8008c6:	e8 9d 06 00 00       	call   800f68 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008cb:	e8 81 1b 00 00       	call   802451 <sys_calculate_free_frames>
  8008d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d3:	e8 19 1c 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  8008d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008de:	89 c2                	mov    %eax,%edx
  8008e0:	01 d2                	add    %edx,%edx
  8008e2:	01 d0                	add    %edx,%eax
  8008e4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008e7:	83 ec 0c             	sub    $0xc,%esp
  8008ea:	50                   	push   %eax
  8008eb:	e8 b4 18 00 00       	call   8021a4 <malloc>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8008f9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008ff:	89 c2                	mov    %eax,%edx
  800901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800904:	c1 e0 02             	shl    $0x2,%eax
  800907:	89 c1                	mov    %eax,%ecx
  800909:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090c:	c1 e0 04             	shl    $0x4,%eax
  80090f:	01 c8                	add    %ecx,%eax
  800911:	05 00 00 00 80       	add    $0x80000000,%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	72 21                	jb     80093b <_main+0x903>
  80091a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800920:	89 c2                	mov    %eax,%edx
  800922:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800925:	c1 e0 02             	shl    $0x2,%eax
  800928:	89 c1                	mov    %eax,%ecx
  80092a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092d:	c1 e0 04             	shl    $0x4,%eax
  800930:	01 c8                	add    %ecx,%eax
  800932:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800937:	39 c2                	cmp    %eax,%edx
  800939:	76 17                	jbe    800952 <_main+0x91a>
  80093b:	83 ec 04             	sub    $0x4,%esp
  80093e:	68 b0 42 80 00       	push   $0x8042b0
  800943:	68 9b 00 00 00       	push   $0x9b
  800948:	68 9c 42 80 00       	push   $0x80429c
  80094d:	e8 16 06 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800952:	e8 9a 1b 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  800957:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 18 43 80 00       	push   $0x804318
  800964:	68 9c 00 00 00       	push   $0x9c
  800969:	68 9c 42 80 00       	push   $0x80429c
  80096e:	e8 f5 05 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800973:	e8 79 1b 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  800978:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  80097b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80097e:	89 d0                	mov    %edx,%eax
  800980:	01 c0                	add    %eax,%eax
  800982:	01 d0                	add    %edx,%eax
  800984:	01 c0                	add    %eax,%eax
  800986:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800989:	83 ec 0c             	sub    $0xc,%esp
  80098c:	50                   	push   %eax
  80098d:	e8 12 18 00 00       	call   8021a4 <malloc>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80099b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009a1:	89 c1                	mov    %eax,%ecx
  8009a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	01 c0                	add    %eax,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	01 c0                	add    %eax,%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	89 c2                	mov    %eax,%edx
  8009b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b5:	c1 e0 04             	shl    $0x4,%eax
  8009b8:	01 d0                	add    %edx,%eax
  8009ba:	05 00 00 00 80       	add    $0x80000000,%eax
  8009bf:	39 c1                	cmp    %eax,%ecx
  8009c1:	72 28                	jb     8009eb <_main+0x9b3>
  8009c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009c9:	89 c1                	mov    %eax,%ecx
  8009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009ce:	89 d0                	mov    %edx,%eax
  8009d0:	01 c0                	add    %eax,%eax
  8009d2:	01 d0                	add    %edx,%eax
  8009d4:	01 c0                	add    %eax,%eax
  8009d6:	01 d0                	add    %edx,%eax
  8009d8:	89 c2                	mov    %eax,%edx
  8009da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009dd:	c1 e0 04             	shl    $0x4,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009e7:	39 c1                	cmp    %eax,%ecx
  8009e9:	76 17                	jbe    800a02 <_main+0x9ca>
  8009eb:	83 ec 04             	sub    $0x4,%esp
  8009ee:	68 b0 42 80 00       	push   $0x8042b0
  8009f3:	68 a2 00 00 00       	push   $0xa2
  8009f8:	68 9c 42 80 00       	push   $0x80429c
  8009fd:	e8 66 05 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a02:	e8 ea 1a 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  800a07:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a0a:	74 17                	je     800a23 <_main+0x9eb>
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	68 18 43 80 00       	push   $0x804318
  800a14:	68 a3 00 00 00       	push   $0xa3
  800a19:	68 9c 42 80 00       	push   $0x80429c
  800a1e:	e8 45 05 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a23:	e8 29 1a 00 00       	call   802451 <sys_calculate_free_frames>
  800a28:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	01 c0                	add    %eax,%eax
  800a32:	01 d0                	add    %edx,%eax
  800a34:	01 c0                	add    %eax,%eax
  800a36:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a39:	48                   	dec    %eax
  800a3a:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a40:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a46:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2[0] = minByte ;
  800a4c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a52:	8a 55 df             	mov    -0x21(%ebp),%dl
  800a55:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a57:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	c1 ea 1f             	shr    $0x1f,%edx
  800a62:	01 d0                	add    %edx,%eax
  800a64:	d1 f8                	sar    %eax
  800a66:	89 c2                	mov    %eax,%edx
  800a68:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a6e:	01 c2                	add    %eax,%edx
  800a70:	8a 45 de             	mov    -0x22(%ebp),%al
  800a73:	88 c1                	mov    %al,%cl
  800a75:	c0 e9 07             	shr    $0x7,%cl
  800a78:	01 c8                	add    %ecx,%eax
  800a7a:	d0 f8                	sar    %al
  800a7c:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a7e:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800a84:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a8a:	01 c2                	add    %eax,%edx
  800a8c:	8a 45 de             	mov    -0x22(%ebp),%al
  800a8f:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a91:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800a94:	e8 b8 19 00 00       	call   802451 <sys_calculate_free_frames>
  800a99:	29 c3                	sub    %eax,%ebx
  800a9b:	89 d8                	mov    %ebx,%eax
  800a9d:	83 f8 05             	cmp    $0x5,%eax
  800aa0:	74 17                	je     800ab9 <_main+0xa81>
  800aa2:	83 ec 04             	sub    $0x4,%esp
  800aa5:	68 48 43 80 00       	push   $0x804348
  800aaa:	68 ab 00 00 00       	push   $0xab
  800aaf:	68 9c 42 80 00       	push   $0x80429c
  800ab4:	e8 af 04 00 00       	call   800f68 <_panic>
		found = 0;
  800ab9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ac0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ac7:	e9 02 01 00 00       	jmp    800bce <_main+0xb96>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800acc:	a1 20 50 80 00       	mov    0x805020,%eax
  800ad1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ada:	89 d0                	mov    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	01 d0                	add    %edx,%eax
  800ae0:	c1 e0 03             	shl    $0x3,%eax
  800ae3:	01 c8                	add    %ecx,%eax
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800aed:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800af3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af8:	89 c2                	mov    %eax,%edx
  800afa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b00:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b06:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b11:	39 c2                	cmp    %eax,%edx
  800b13:	75 03                	jne    800b18 <_main+0xae0>
				found++;
  800b15:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b18:	a1 20 50 80 00       	mov    0x805020,%eax
  800b1d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b26:	89 d0                	mov    %edx,%eax
  800b28:	01 c0                	add    %eax,%eax
  800b2a:	01 d0                	add    %edx,%eax
  800b2c:	c1 e0 03             	shl    $0x3,%eax
  800b2f:	01 c8                	add    %ecx,%eax
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b39:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b44:	89 c2                	mov    %eax,%edx
  800b46:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b4c:	89 c1                	mov    %eax,%ecx
  800b4e:	c1 e9 1f             	shr    $0x1f,%ecx
  800b51:	01 c8                	add    %ecx,%eax
  800b53:	d1 f8                	sar    %eax
  800b55:	89 c1                	mov    %eax,%ecx
  800b57:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b5d:	01 c8                	add    %ecx,%eax
  800b5f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b65:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b70:	39 c2                	cmp    %eax,%edx
  800b72:	75 03                	jne    800b77 <_main+0xb3f>
				found++;
  800b74:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b77:	a1 20 50 80 00       	mov    0x805020,%eax
  800b7c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b85:	89 d0                	mov    %edx,%eax
  800b87:	01 c0                	add    %eax,%eax
  800b89:	01 d0                	add    %edx,%eax
  800b8b:	c1 e0 03             	shl    $0x3,%eax
  800b8e:	01 c8                	add    %ecx,%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b98:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b9e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba3:	89 c1                	mov    %eax,%ecx
  800ba5:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800bab:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800bb1:	01 d0                	add    %edx,%eax
  800bb3:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800bb9:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800bbf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc4:	39 c1                	cmp    %eax,%ecx
  800bc6:	75 03                	jne    800bcb <_main+0xb93>
				found++;
  800bc8:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bcb:	ff 45 ec             	incl   -0x14(%ebp)
  800bce:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd3:	8b 50 74             	mov    0x74(%eax),%edx
  800bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd9:	39 c2                	cmp    %eax,%edx
  800bdb:	0f 87 eb fe ff ff    	ja     800acc <_main+0xa94>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800be1:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800be5:	74 17                	je     800bfe <_main+0xbc6>
  800be7:	83 ec 04             	sub    $0x4,%esp
  800bea:	68 8c 43 80 00       	push   $0x80438c
  800bef:	68 b6 00 00 00       	push   $0xb6
  800bf4:	68 9c 42 80 00       	push   $0x80429c
  800bf9:	e8 6a 03 00 00       	call   800f68 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfe:	e8 ee 18 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  800c03:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c09:	89 d0                	mov    %edx,%eax
  800c0b:	01 c0                	add    %eax,%eax
  800c0d:	01 d0                	add    %edx,%eax
  800c0f:	01 c0                	add    %eax,%eax
  800c11:	01 d0                	add    %edx,%eax
  800c13:	01 c0                	add    %eax,%eax
  800c15:	83 ec 0c             	sub    $0xc,%esp
  800c18:	50                   	push   %eax
  800c19:	e8 86 15 00 00       	call   8021a4 <malloc>
  800c1e:	83 c4 10             	add    $0x10,%esp
  800c21:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c27:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c2d:	89 c1                	mov    %eax,%ecx
  800c2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c32:	89 d0                	mov    %edx,%eax
  800c34:	01 c0                	add    %eax,%eax
  800c36:	01 d0                	add    %edx,%eax
  800c38:	c1 e0 02             	shl    $0x2,%eax
  800c3b:	01 d0                	add    %edx,%eax
  800c3d:	89 c2                	mov    %eax,%edx
  800c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c42:	c1 e0 04             	shl    $0x4,%eax
  800c45:	01 d0                	add    %edx,%eax
  800c47:	05 00 00 00 80       	add    $0x80000000,%eax
  800c4c:	39 c1                	cmp    %eax,%ecx
  800c4e:	72 29                	jb     800c79 <_main+0xc41>
  800c50:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c56:	89 c1                	mov    %eax,%ecx
  800c58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c5b:	89 d0                	mov    %edx,%eax
  800c5d:	01 c0                	add    %eax,%eax
  800c5f:	01 d0                	add    %edx,%eax
  800c61:	c1 e0 02             	shl    $0x2,%eax
  800c64:	01 d0                	add    %edx,%eax
  800c66:	89 c2                	mov    %eax,%edx
  800c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c6b:	c1 e0 04             	shl    $0x4,%eax
  800c6e:	01 d0                	add    %edx,%eax
  800c70:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c75:	39 c1                	cmp    %eax,%ecx
  800c77:	76 17                	jbe    800c90 <_main+0xc58>
  800c79:	83 ec 04             	sub    $0x4,%esp
  800c7c:	68 b0 42 80 00       	push   $0x8042b0
  800c81:	68 bb 00 00 00       	push   $0xbb
  800c86:	68 9c 42 80 00       	push   $0x80429c
  800c8b:	e8 d8 02 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c90:	e8 5c 18 00 00       	call   8024f1 <sys_pf_calculate_allocated_pages>
  800c95:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c98:	74 17                	je     800cb1 <_main+0xc79>
  800c9a:	83 ec 04             	sub    $0x4,%esp
  800c9d:	68 18 43 80 00       	push   $0x804318
  800ca2:	68 bc 00 00 00       	push   $0xbc
  800ca7:	68 9c 42 80 00       	push   $0x80429c
  800cac:	e8 b7 02 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cb1:	e8 9b 17 00 00       	call   802451 <sys_calculate_free_frames>
  800cb6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800cb9:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800cbf:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cc5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cc8:	89 d0                	mov    %edx,%eax
  800cca:	01 c0                	add    %eax,%eax
  800ccc:	01 d0                	add    %edx,%eax
  800cce:	01 c0                	add    %eax,%eax
  800cd0:	01 d0                	add    %edx,%eax
  800cd2:	01 c0                	add    %eax,%eax
  800cd4:	d1 e8                	shr    %eax
  800cd6:	48                   	dec    %eax
  800cd7:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		shortArr2[0] = minShort;
  800cdd:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800ce3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ce6:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800ce9:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cef:	01 c0                	add    %eax,%eax
  800cf1:	89 c2                	mov    %eax,%edx
  800cf3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800cf9:	01 c2                	add    %eax,%edx
  800cfb:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800cff:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d02:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800d05:	e8 47 17 00 00       	call   802451 <sys_calculate_free_frames>
  800d0a:	29 c3                	sub    %eax,%ebx
  800d0c:	89 d8                	mov    %ebx,%eax
  800d0e:	83 f8 02             	cmp    $0x2,%eax
  800d11:	74 17                	je     800d2a <_main+0xcf2>
  800d13:	83 ec 04             	sub    $0x4,%esp
  800d16:	68 48 43 80 00       	push   $0x804348
  800d1b:	68 c3 00 00 00       	push   $0xc3
  800d20:	68 9c 42 80 00       	push   $0x80429c
  800d25:	e8 3e 02 00 00       	call   800f68 <_panic>
		found = 0;
  800d2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d31:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d38:	e9 a7 00 00 00       	jmp    800de4 <_main+0xdac>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800d42:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d48:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d4b:	89 d0                	mov    %edx,%eax
  800d4d:	01 c0                	add    %eax,%eax
  800d4f:	01 d0                	add    %edx,%eax
  800d51:	c1 e0 03             	shl    $0x3,%eax
  800d54:	01 c8                	add    %ecx,%eax
  800d56:	8b 00                	mov    (%eax),%eax
  800d58:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d5e:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d69:	89 c2                	mov    %eax,%edx
  800d6b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d71:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d77:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d82:	39 c2                	cmp    %eax,%edx
  800d84:	75 03                	jne    800d89 <_main+0xd51>
				found++;
  800d86:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d89:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d94:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d97:	89 d0                	mov    %edx,%eax
  800d99:	01 c0                	add    %eax,%eax
  800d9b:	01 d0                	add    %edx,%eax
  800d9d:	c1 e0 03             	shl    $0x3,%eax
  800da0:	01 c8                	add    %ecx,%eax
  800da2:	8b 00                	mov    (%eax),%eax
  800da4:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800daa:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800db0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db5:	89 c2                	mov    %eax,%edx
  800db7:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dbd:	01 c0                	add    %eax,%eax
  800dbf:	89 c1                	mov    %eax,%ecx
  800dc1:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800dc7:	01 c8                	add    %ecx,%eax
  800dc9:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800dcf:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800dd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dda:	39 c2                	cmp    %eax,%edx
  800ddc:	75 03                	jne    800de1 <_main+0xda9>
				found++;
  800dde:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800de1:	ff 45 ec             	incl   -0x14(%ebp)
  800de4:	a1 20 50 80 00       	mov    0x805020,%eax
  800de9:	8b 50 74             	mov    0x74(%eax),%edx
  800dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800def:	39 c2                	cmp    %eax,%edx
  800df1:	0f 87 46 ff ff ff    	ja     800d3d <_main+0xd05>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800df7:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800dfb:	74 17                	je     800e14 <_main+0xddc>
  800dfd:	83 ec 04             	sub    $0x4,%esp
  800e00:	68 8c 43 80 00       	push   $0x80438c
  800e05:	68 cc 00 00 00       	push   $0xcc
  800e0a:	68 9c 42 80 00       	push   $0x80429c
  800e0f:	e8 54 01 00 00       	call   800f68 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	68 ac 43 80 00       	push   $0x8043ac
  800e1c:	e8 fb 03 00 00       	call   80121c <cprintf>
  800e21:	83 c4 10             	add    $0x10,%esp

	return;
  800e24:	90                   	nop
}
  800e25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e28:	5b                   	pop    %ebx
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800e32:	e8 fa 18 00 00       	call   802731 <sys_getenvindex>
  800e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3d:	89 d0                	mov    %edx,%eax
  800e3f:	c1 e0 03             	shl    $0x3,%eax
  800e42:	01 d0                	add    %edx,%eax
  800e44:	01 c0                	add    %eax,%eax
  800e46:	01 d0                	add    %edx,%eax
  800e48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e4f:	01 d0                	add    %edx,%eax
  800e51:	c1 e0 04             	shl    $0x4,%eax
  800e54:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e59:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e5e:	a1 20 50 80 00       	mov    0x805020,%eax
  800e63:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800e69:	84 c0                	test   %al,%al
  800e6b:	74 0f                	je     800e7c <libmain+0x50>
		binaryname = myEnv->prog_name;
  800e6d:	a1 20 50 80 00       	mov    0x805020,%eax
  800e72:	05 5c 05 00 00       	add    $0x55c,%eax
  800e77:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800e7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e80:	7e 0a                	jle    800e8c <libmain+0x60>
		binaryname = argv[0];
  800e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e85:	8b 00                	mov    (%eax),%eax
  800e87:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800e8c:	83 ec 08             	sub    $0x8,%esp
  800e8f:	ff 75 0c             	pushl  0xc(%ebp)
  800e92:	ff 75 08             	pushl  0x8(%ebp)
  800e95:	e8 9e f1 ff ff       	call   800038 <_main>
  800e9a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800e9d:	e8 9c 16 00 00       	call   80253e <sys_disable_interrupt>
	cprintf("**************************************\n");
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	68 00 44 80 00       	push   $0x804400
  800eaa:	e8 6d 03 00 00       	call   80121c <cprintf>
  800eaf:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800eb2:	a1 20 50 80 00       	mov    0x805020,%eax
  800eb7:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800ebd:	a1 20 50 80 00       	mov    0x805020,%eax
  800ec2:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800ec8:	83 ec 04             	sub    $0x4,%esp
  800ecb:	52                   	push   %edx
  800ecc:	50                   	push   %eax
  800ecd:	68 28 44 80 00       	push   $0x804428
  800ed2:	e8 45 03 00 00       	call   80121c <cprintf>
  800ed7:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800eda:	a1 20 50 80 00       	mov    0x805020,%eax
  800edf:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800ee5:	a1 20 50 80 00       	mov    0x805020,%eax
  800eea:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800ef0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ef5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800efb:	51                   	push   %ecx
  800efc:	52                   	push   %edx
  800efd:	50                   	push   %eax
  800efe:	68 50 44 80 00       	push   $0x804450
  800f03:	e8 14 03 00 00       	call   80121c <cprintf>
  800f08:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f0b:	a1 20 50 80 00       	mov    0x805020,%eax
  800f10:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800f16:	83 ec 08             	sub    $0x8,%esp
  800f19:	50                   	push   %eax
  800f1a:	68 a8 44 80 00       	push   $0x8044a8
  800f1f:	e8 f8 02 00 00       	call   80121c <cprintf>
  800f24:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800f27:	83 ec 0c             	sub    $0xc,%esp
  800f2a:	68 00 44 80 00       	push   $0x804400
  800f2f:	e8 e8 02 00 00       	call   80121c <cprintf>
  800f34:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800f37:	e8 1c 16 00 00       	call   802558 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800f3c:	e8 19 00 00 00       	call   800f5a <exit>
}
  800f41:	90                   	nop
  800f42:	c9                   	leave  
  800f43:	c3                   	ret    

00800f44 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800f4a:	83 ec 0c             	sub    $0xc,%esp
  800f4d:	6a 00                	push   $0x0
  800f4f:	e8 a9 17 00 00       	call   8026fd <sys_destroy_env>
  800f54:	83 c4 10             	add    $0x10,%esp
}
  800f57:	90                   	nop
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    

00800f5a <exit>:

void
exit(void)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800f60:	e8 fe 17 00 00       	call   802763 <sys_exit_env>
}
  800f65:	90                   	nop
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f6e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f71:	83 c0 04             	add    $0x4,%eax
  800f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800f77:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	74 16                	je     800f96 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800f80:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800f85:	83 ec 08             	sub    $0x8,%esp
  800f88:	50                   	push   %eax
  800f89:	68 bc 44 80 00       	push   $0x8044bc
  800f8e:	e8 89 02 00 00       	call   80121c <cprintf>
  800f93:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800f96:	a1 00 50 80 00       	mov    0x805000,%eax
  800f9b:	ff 75 0c             	pushl  0xc(%ebp)
  800f9e:	ff 75 08             	pushl  0x8(%ebp)
  800fa1:	50                   	push   %eax
  800fa2:	68 c1 44 80 00       	push   $0x8044c1
  800fa7:	e8 70 02 00 00       	call   80121c <cprintf>
  800fac:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800faf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb2:	83 ec 08             	sub    $0x8,%esp
  800fb5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb8:	50                   	push   %eax
  800fb9:	e8 f3 01 00 00       	call   8011b1 <vcprintf>
  800fbe:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800fc1:	83 ec 08             	sub    $0x8,%esp
  800fc4:	6a 00                	push   $0x0
  800fc6:	68 dd 44 80 00       	push   $0x8044dd
  800fcb:	e8 e1 01 00 00       	call   8011b1 <vcprintf>
  800fd0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800fd3:	e8 82 ff ff ff       	call   800f5a <exit>

	// should not return here
	while (1) ;
  800fd8:	eb fe                	jmp    800fd8 <_panic+0x70>

00800fda <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800fe0:	a1 20 50 80 00       	mov    0x805020,%eax
  800fe5:	8b 50 74             	mov    0x74(%eax),%edx
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	39 c2                	cmp    %eax,%edx
  800fed:	74 14                	je     801003 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800fef:	83 ec 04             	sub    $0x4,%esp
  800ff2:	68 e0 44 80 00       	push   $0x8044e0
  800ff7:	6a 26                	push   $0x26
  800ff9:	68 2c 45 80 00       	push   $0x80452c
  800ffe:	e8 65 ff ff ff       	call   800f68 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801003:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80100a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801011:	e9 c2 00 00 00       	jmp    8010d8 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801019:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	01 d0                	add    %edx,%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	85 c0                	test   %eax,%eax
  801029:	75 08                	jne    801033 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80102b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80102e:	e9 a2 00 00 00       	jmp    8010d5 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801033:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80103a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801041:	eb 69                	jmp    8010ac <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801043:	a1 20 50 80 00       	mov    0x805020,%eax
  801048:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80104e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801051:	89 d0                	mov    %edx,%eax
  801053:	01 c0                	add    %eax,%eax
  801055:	01 d0                	add    %edx,%eax
  801057:	c1 e0 03             	shl    $0x3,%eax
  80105a:	01 c8                	add    %ecx,%eax
  80105c:	8a 40 04             	mov    0x4(%eax),%al
  80105f:	84 c0                	test   %al,%al
  801061:	75 46                	jne    8010a9 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801063:	a1 20 50 80 00       	mov    0x805020,%eax
  801068:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80106e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801071:	89 d0                	mov    %edx,%eax
  801073:	01 c0                	add    %eax,%eax
  801075:	01 d0                	add    %edx,%eax
  801077:	c1 e0 03             	shl    $0x3,%eax
  80107a:	01 c8                	add    %ecx,%eax
  80107c:	8b 00                	mov    (%eax),%eax
  80107e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801081:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801084:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801089:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80108b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	01 c8                	add    %ecx,%eax
  80109a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80109c:	39 c2                	cmp    %eax,%edx
  80109e:	75 09                	jne    8010a9 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8010a0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8010a7:	eb 12                	jmp    8010bb <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010a9:	ff 45 e8             	incl   -0x18(%ebp)
  8010ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8010b1:	8b 50 74             	mov    0x74(%eax),%edx
  8010b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b7:	39 c2                	cmp    %eax,%edx
  8010b9:	77 88                	ja     801043 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8010bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010bf:	75 14                	jne    8010d5 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	68 38 45 80 00       	push   $0x804538
  8010c9:	6a 3a                	push   $0x3a
  8010cb:	68 2c 45 80 00       	push   $0x80452c
  8010d0:	e8 93 fe ff ff       	call   800f68 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8010d5:	ff 45 f0             	incl   -0x10(%ebp)
  8010d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8010de:	0f 8c 32 ff ff ff    	jl     801016 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8010e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010eb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8010f2:	eb 26                	jmp    80111a <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8010f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8010f9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8010ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801102:	89 d0                	mov    %edx,%eax
  801104:	01 c0                	add    %eax,%eax
  801106:	01 d0                	add    %edx,%eax
  801108:	c1 e0 03             	shl    $0x3,%eax
  80110b:	01 c8                	add    %ecx,%eax
  80110d:	8a 40 04             	mov    0x4(%eax),%al
  801110:	3c 01                	cmp    $0x1,%al
  801112:	75 03                	jne    801117 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801114:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801117:	ff 45 e0             	incl   -0x20(%ebp)
  80111a:	a1 20 50 80 00       	mov    0x805020,%eax
  80111f:	8b 50 74             	mov    0x74(%eax),%edx
  801122:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801125:	39 c2                	cmp    %eax,%edx
  801127:	77 cb                	ja     8010f4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80112f:	74 14                	je     801145 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801131:	83 ec 04             	sub    $0x4,%esp
  801134:	68 8c 45 80 00       	push   $0x80458c
  801139:	6a 44                	push   $0x44
  80113b:	68 2c 45 80 00       	push   $0x80452c
  801140:	e8 23 fe ff ff       	call   800f68 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801145:	90                   	nop
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80114e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801151:	8b 00                	mov    (%eax),%eax
  801153:	8d 48 01             	lea    0x1(%eax),%ecx
  801156:	8b 55 0c             	mov    0xc(%ebp),%edx
  801159:	89 0a                	mov    %ecx,(%edx)
  80115b:	8b 55 08             	mov    0x8(%ebp),%edx
  80115e:	88 d1                	mov    %dl,%cl
  801160:	8b 55 0c             	mov    0xc(%ebp),%edx
  801163:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 00                	mov    (%eax),%eax
  80116c:	3d ff 00 00 00       	cmp    $0xff,%eax
  801171:	75 2c                	jne    80119f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801173:	a0 24 50 80 00       	mov    0x805024,%al
  801178:	0f b6 c0             	movzbl %al,%eax
  80117b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117e:	8b 12                	mov    (%edx),%edx
  801180:	89 d1                	mov    %edx,%ecx
  801182:	8b 55 0c             	mov    0xc(%ebp),%edx
  801185:	83 c2 08             	add    $0x8,%edx
  801188:	83 ec 04             	sub    $0x4,%esp
  80118b:	50                   	push   %eax
  80118c:	51                   	push   %ecx
  80118d:	52                   	push   %edx
  80118e:	e8 fd 11 00 00       	call   802390 <sys_cputs>
  801193:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80119f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a2:	8b 40 04             	mov    0x4(%eax),%eax
  8011a5:	8d 50 01             	lea    0x1(%eax),%edx
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	89 50 04             	mov    %edx,0x4(%eax)
}
  8011ae:	90                   	nop
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011ba:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011c1:	00 00 00 
	b.cnt = 0;
  8011c4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011cb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8011ce:	ff 75 0c             	pushl  0xc(%ebp)
  8011d1:	ff 75 08             	pushl  0x8(%ebp)
  8011d4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011da:	50                   	push   %eax
  8011db:	68 48 11 80 00       	push   $0x801148
  8011e0:	e8 11 02 00 00       	call   8013f6 <vprintfmt>
  8011e5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8011e8:	a0 24 50 80 00       	mov    0x805024,%al
  8011ed:	0f b6 c0             	movzbl %al,%eax
  8011f0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	50                   	push   %eax
  8011fa:	52                   	push   %edx
  8011fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801201:	83 c0 08             	add    $0x8,%eax
  801204:	50                   	push   %eax
  801205:	e8 86 11 00 00       	call   802390 <sys_cputs>
  80120a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80120d:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801214:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <cprintf>:

int cprintf(const char *fmt, ...) {
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801222:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801229:	8d 45 0c             	lea    0xc(%ebp),%eax
  80122c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	ff 75 f4             	pushl  -0xc(%ebp)
  801238:	50                   	push   %eax
  801239:	e8 73 ff ff ff       	call   8011b1 <vcprintf>
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801244:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80124f:	e8 ea 12 00 00       	call   80253e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801254:	8d 45 0c             	lea    0xc(%ebp),%eax
  801257:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	83 ec 08             	sub    $0x8,%esp
  801260:	ff 75 f4             	pushl  -0xc(%ebp)
  801263:	50                   	push   %eax
  801264:	e8 48 ff ff ff       	call   8011b1 <vcprintf>
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80126f:	e8 e4 12 00 00       	call   802558 <sys_enable_interrupt>
	return cnt;
  801274:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	53                   	push   %ebx
  80127d:	83 ec 14             	sub    $0x14,%esp
  801280:	8b 45 10             	mov    0x10(%ebp),%eax
  801283:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801286:	8b 45 14             	mov    0x14(%ebp),%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80128c:	8b 45 18             	mov    0x18(%ebp),%eax
  80128f:	ba 00 00 00 00       	mov    $0x0,%edx
  801294:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801297:	77 55                	ja     8012ee <printnum+0x75>
  801299:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80129c:	72 05                	jb     8012a3 <printnum+0x2a>
  80129e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a1:	77 4b                	ja     8012ee <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8012a3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8012a6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8012a9:	8b 45 18             	mov    0x18(%ebp),%eax
  8012ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b1:	52                   	push   %edx
  8012b2:	50                   	push   %eax
  8012b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8012b9:	e8 56 2d 00 00       	call   804014 <__udivdi3>
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	83 ec 04             	sub    $0x4,%esp
  8012c4:	ff 75 20             	pushl  0x20(%ebp)
  8012c7:	53                   	push   %ebx
  8012c8:	ff 75 18             	pushl  0x18(%ebp)
  8012cb:	52                   	push   %edx
  8012cc:	50                   	push   %eax
  8012cd:	ff 75 0c             	pushl  0xc(%ebp)
  8012d0:	ff 75 08             	pushl  0x8(%ebp)
  8012d3:	e8 a1 ff ff ff       	call   801279 <printnum>
  8012d8:	83 c4 20             	add    $0x20,%esp
  8012db:	eb 1a                	jmp    8012f7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8012dd:	83 ec 08             	sub    $0x8,%esp
  8012e0:	ff 75 0c             	pushl  0xc(%ebp)
  8012e3:	ff 75 20             	pushl  0x20(%ebp)
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	ff d0                	call   *%eax
  8012eb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8012ee:	ff 4d 1c             	decl   0x1c(%ebp)
  8012f1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8012f5:	7f e6                	jg     8012dd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012f7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8012fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801302:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801305:	53                   	push   %ebx
  801306:	51                   	push   %ecx
  801307:	52                   	push   %edx
  801308:	50                   	push   %eax
  801309:	e8 16 2e 00 00       	call   804124 <__umoddi3>
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	05 f4 47 80 00       	add    $0x8047f4,%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f be c0             	movsbl %al,%eax
  80131b:	83 ec 08             	sub    $0x8,%esp
  80131e:	ff 75 0c             	pushl  0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	ff d0                	call   *%eax
  801327:	83 c4 10             	add    $0x10,%esp
}
  80132a:	90                   	nop
  80132b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801333:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801337:	7e 1c                	jle    801355 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8b 00                	mov    (%eax),%eax
  80133e:	8d 50 08             	lea    0x8(%eax),%edx
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	89 10                	mov    %edx,(%eax)
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	83 e8 08             	sub    $0x8,%eax
  80134e:	8b 50 04             	mov    0x4(%eax),%edx
  801351:	8b 00                	mov    (%eax),%eax
  801353:	eb 40                	jmp    801395 <getuint+0x65>
	else if (lflag)
  801355:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801359:	74 1e                	je     801379 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	8b 00                	mov    (%eax),%eax
  801360:	8d 50 04             	lea    0x4(%eax),%edx
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	89 10                	mov    %edx,(%eax)
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8b 00                	mov    (%eax),%eax
  80136d:	83 e8 04             	sub    $0x4,%eax
  801370:	8b 00                	mov    (%eax),%eax
  801372:	ba 00 00 00 00       	mov    $0x0,%edx
  801377:	eb 1c                	jmp    801395 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8b 00                	mov    (%eax),%eax
  80137e:	8d 50 04             	lea    0x4(%eax),%edx
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	89 10                	mov    %edx,(%eax)
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	8b 00                	mov    (%eax),%eax
  80138b:	83 e8 04             	sub    $0x4,%eax
  80138e:	8b 00                	mov    (%eax),%eax
  801390:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    

00801397 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80139a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80139e:	7e 1c                	jle    8013bc <getint+0x25>
		return va_arg(*ap, long long);
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8b 00                	mov    (%eax),%eax
  8013a5:	8d 50 08             	lea    0x8(%eax),%edx
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	89 10                	mov    %edx,(%eax)
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8b 00                	mov    (%eax),%eax
  8013b2:	83 e8 08             	sub    $0x8,%eax
  8013b5:	8b 50 04             	mov    0x4(%eax),%edx
  8013b8:	8b 00                	mov    (%eax),%eax
  8013ba:	eb 38                	jmp    8013f4 <getint+0x5d>
	else if (lflag)
  8013bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013c0:	74 1a                	je     8013dc <getint+0x45>
		return va_arg(*ap, long);
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8b 00                	mov    (%eax),%eax
  8013c7:	8d 50 04             	lea    0x4(%eax),%edx
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	89 10                	mov    %edx,(%eax)
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	83 e8 04             	sub    $0x4,%eax
  8013d7:	8b 00                	mov    (%eax),%eax
  8013d9:	99                   	cltd   
  8013da:	eb 18                	jmp    8013f4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8b 00                	mov    (%eax),%eax
  8013e1:	8d 50 04             	lea    0x4(%eax),%edx
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	89 10                	mov    %edx,(%eax)
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	83 e8 04             	sub    $0x4,%eax
  8013f1:	8b 00                	mov    (%eax),%eax
  8013f3:	99                   	cltd   
}
  8013f4:	5d                   	pop    %ebp
  8013f5:	c3                   	ret    

008013f6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	56                   	push   %esi
  8013fa:	53                   	push   %ebx
  8013fb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013fe:	eb 17                	jmp    801417 <vprintfmt+0x21>
			if (ch == '\0')
  801400:	85 db                	test   %ebx,%ebx
  801402:	0f 84 af 03 00 00    	je     8017b7 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801408:	83 ec 08             	sub    $0x8,%esp
  80140b:	ff 75 0c             	pushl  0xc(%ebp)
  80140e:	53                   	push   %ebx
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	ff d0                	call   *%eax
  801414:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801417:	8b 45 10             	mov    0x10(%ebp),%eax
  80141a:	8d 50 01             	lea    0x1(%eax),%edx
  80141d:	89 55 10             	mov    %edx,0x10(%ebp)
  801420:	8a 00                	mov    (%eax),%al
  801422:	0f b6 d8             	movzbl %al,%ebx
  801425:	83 fb 25             	cmp    $0x25,%ebx
  801428:	75 d6                	jne    801400 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80142a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80142e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801435:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80143c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801443:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80144a:	8b 45 10             	mov    0x10(%ebp),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	89 55 10             	mov    %edx,0x10(%ebp)
  801453:	8a 00                	mov    (%eax),%al
  801455:	0f b6 d8             	movzbl %al,%ebx
  801458:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80145b:	83 f8 55             	cmp    $0x55,%eax
  80145e:	0f 87 2b 03 00 00    	ja     80178f <vprintfmt+0x399>
  801464:	8b 04 85 18 48 80 00 	mov    0x804818(,%eax,4),%eax
  80146b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80146d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801471:	eb d7                	jmp    80144a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801473:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801477:	eb d1                	jmp    80144a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801479:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801483:	89 d0                	mov    %edx,%eax
  801485:	c1 e0 02             	shl    $0x2,%eax
  801488:	01 d0                	add    %edx,%eax
  80148a:	01 c0                	add    %eax,%eax
  80148c:	01 d8                	add    %ebx,%eax
  80148e:	83 e8 30             	sub    $0x30,%eax
  801491:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801494:	8b 45 10             	mov    0x10(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80149c:	83 fb 2f             	cmp    $0x2f,%ebx
  80149f:	7e 3e                	jle    8014df <vprintfmt+0xe9>
  8014a1:	83 fb 39             	cmp    $0x39,%ebx
  8014a4:	7f 39                	jg     8014df <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014a6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8014a9:	eb d5                	jmp    801480 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8014ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ae:	83 c0 04             	add    $0x4,%eax
  8014b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8014b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b7:	83 e8 04             	sub    $0x4,%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8014bf:	eb 1f                	jmp    8014e0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8014c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014c5:	79 83                	jns    80144a <vprintfmt+0x54>
				width = 0;
  8014c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8014ce:	e9 77 ff ff ff       	jmp    80144a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8014d3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8014da:	e9 6b ff ff ff       	jmp    80144a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8014df:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8014e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014e4:	0f 89 60 ff ff ff    	jns    80144a <vprintfmt+0x54>
				width = precision, precision = -1;
  8014ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8014f7:	e9 4e ff ff ff       	jmp    80144a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8014fc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8014ff:	e9 46 ff ff ff       	jmp    80144a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801504:	8b 45 14             	mov    0x14(%ebp),%eax
  801507:	83 c0 04             	add    $0x4,%eax
  80150a:	89 45 14             	mov    %eax,0x14(%ebp)
  80150d:	8b 45 14             	mov    0x14(%ebp),%eax
  801510:	83 e8 04             	sub    $0x4,%eax
  801513:	8b 00                	mov    (%eax),%eax
  801515:	83 ec 08             	sub    $0x8,%esp
  801518:	ff 75 0c             	pushl  0xc(%ebp)
  80151b:	50                   	push   %eax
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	ff d0                	call   *%eax
  801521:	83 c4 10             	add    $0x10,%esp
			break;
  801524:	e9 89 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801529:	8b 45 14             	mov    0x14(%ebp),%eax
  80152c:	83 c0 04             	add    $0x4,%eax
  80152f:	89 45 14             	mov    %eax,0x14(%ebp)
  801532:	8b 45 14             	mov    0x14(%ebp),%eax
  801535:	83 e8 04             	sub    $0x4,%eax
  801538:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80153a:	85 db                	test   %ebx,%ebx
  80153c:	79 02                	jns    801540 <vprintfmt+0x14a>
				err = -err;
  80153e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801540:	83 fb 64             	cmp    $0x64,%ebx
  801543:	7f 0b                	jg     801550 <vprintfmt+0x15a>
  801545:	8b 34 9d 60 46 80 00 	mov    0x804660(,%ebx,4),%esi
  80154c:	85 f6                	test   %esi,%esi
  80154e:	75 19                	jne    801569 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801550:	53                   	push   %ebx
  801551:	68 05 48 80 00       	push   $0x804805
  801556:	ff 75 0c             	pushl  0xc(%ebp)
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	e8 5e 02 00 00       	call   8017bf <printfmt>
  801561:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801564:	e9 49 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801569:	56                   	push   %esi
  80156a:	68 0e 48 80 00       	push   $0x80480e
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	ff 75 08             	pushl  0x8(%ebp)
  801575:	e8 45 02 00 00       	call   8017bf <printfmt>
  80157a:	83 c4 10             	add    $0x10,%esp
			break;
  80157d:	e9 30 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801582:	8b 45 14             	mov    0x14(%ebp),%eax
  801585:	83 c0 04             	add    $0x4,%eax
  801588:	89 45 14             	mov    %eax,0x14(%ebp)
  80158b:	8b 45 14             	mov    0x14(%ebp),%eax
  80158e:	83 e8 04             	sub    $0x4,%eax
  801591:	8b 30                	mov    (%eax),%esi
  801593:	85 f6                	test   %esi,%esi
  801595:	75 05                	jne    80159c <vprintfmt+0x1a6>
				p = "(null)";
  801597:	be 11 48 80 00       	mov    $0x804811,%esi
			if (width > 0 && padc != '-')
  80159c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015a0:	7e 6d                	jle    80160f <vprintfmt+0x219>
  8015a2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8015a6:	74 67                	je     80160f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	50                   	push   %eax
  8015af:	56                   	push   %esi
  8015b0:	e8 0c 03 00 00       	call   8018c1 <strnlen>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8015bb:	eb 16                	jmp    8015d3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8015bd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8015c1:	83 ec 08             	sub    $0x8,%esp
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	50                   	push   %eax
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	ff d0                	call   *%eax
  8015cd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015d0:	ff 4d e4             	decl   -0x1c(%ebp)
  8015d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015d7:	7f e4                	jg     8015bd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015d9:	eb 34                	jmp    80160f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8015db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015df:	74 1c                	je     8015fd <vprintfmt+0x207>
  8015e1:	83 fb 1f             	cmp    $0x1f,%ebx
  8015e4:	7e 05                	jle    8015eb <vprintfmt+0x1f5>
  8015e6:	83 fb 7e             	cmp    $0x7e,%ebx
  8015e9:	7e 12                	jle    8015fd <vprintfmt+0x207>
					putch('?', putdat);
  8015eb:	83 ec 08             	sub    $0x8,%esp
  8015ee:	ff 75 0c             	pushl  0xc(%ebp)
  8015f1:	6a 3f                	push   $0x3f
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	ff d0                	call   *%eax
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	eb 0f                	jmp    80160c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	ff 75 0c             	pushl  0xc(%ebp)
  801603:	53                   	push   %ebx
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	ff d0                	call   *%eax
  801609:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80160c:	ff 4d e4             	decl   -0x1c(%ebp)
  80160f:	89 f0                	mov    %esi,%eax
  801611:	8d 70 01             	lea    0x1(%eax),%esi
  801614:	8a 00                	mov    (%eax),%al
  801616:	0f be d8             	movsbl %al,%ebx
  801619:	85 db                	test   %ebx,%ebx
  80161b:	74 24                	je     801641 <vprintfmt+0x24b>
  80161d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801621:	78 b8                	js     8015db <vprintfmt+0x1e5>
  801623:	ff 4d e0             	decl   -0x20(%ebp)
  801626:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80162a:	79 af                	jns    8015db <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80162c:	eb 13                	jmp    801641 <vprintfmt+0x24b>
				putch(' ', putdat);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	6a 20                	push   $0x20
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	ff d0                	call   *%eax
  80163b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80163e:	ff 4d e4             	decl   -0x1c(%ebp)
  801641:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801645:	7f e7                	jg     80162e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801647:	e9 66 01 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80164c:	83 ec 08             	sub    $0x8,%esp
  80164f:	ff 75 e8             	pushl  -0x18(%ebp)
  801652:	8d 45 14             	lea    0x14(%ebp),%eax
  801655:	50                   	push   %eax
  801656:	e8 3c fd ff ff       	call   801397 <getint>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801661:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166a:	85 d2                	test   %edx,%edx
  80166c:	79 23                	jns    801691 <vprintfmt+0x29b>
				putch('-', putdat);
  80166e:	83 ec 08             	sub    $0x8,%esp
  801671:	ff 75 0c             	pushl  0xc(%ebp)
  801674:	6a 2d                	push   $0x2d
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	ff d0                	call   *%eax
  80167b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80167e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801681:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801684:	f7 d8                	neg    %eax
  801686:	83 d2 00             	adc    $0x0,%edx
  801689:	f7 da                	neg    %edx
  80168b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80168e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801691:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801698:	e9 bc 00 00 00       	jmp    801759 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8016a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8016a6:	50                   	push   %eax
  8016a7:	e8 84 fc ff ff       	call   801330 <getuint>
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8016b5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016bc:	e9 98 00 00 00       	jmp    801759 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	6a 58                	push   $0x58
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	ff d0                	call   *%eax
  8016ce:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016d1:	83 ec 08             	sub    $0x8,%esp
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	6a 58                	push   $0x58
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	ff d0                	call   *%eax
  8016de:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016e1:	83 ec 08             	sub    $0x8,%esp
  8016e4:	ff 75 0c             	pushl  0xc(%ebp)
  8016e7:	6a 58                	push   $0x58
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	ff d0                	call   *%eax
  8016ee:	83 c4 10             	add    $0x10,%esp
			break;
  8016f1:	e9 bc 00 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	6a 30                	push   $0x30
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	ff d0                	call   *%eax
  801703:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801706:	83 ec 08             	sub    $0x8,%esp
  801709:	ff 75 0c             	pushl  0xc(%ebp)
  80170c:	6a 78                	push   $0x78
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	ff d0                	call   *%eax
  801713:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801716:	8b 45 14             	mov    0x14(%ebp),%eax
  801719:	83 c0 04             	add    $0x4,%eax
  80171c:	89 45 14             	mov    %eax,0x14(%ebp)
  80171f:	8b 45 14             	mov    0x14(%ebp),%eax
  801722:	83 e8 04             	sub    $0x4,%eax
  801725:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801727:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80172a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801731:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801738:	eb 1f                	jmp    801759 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80173a:	83 ec 08             	sub    $0x8,%esp
  80173d:	ff 75 e8             	pushl  -0x18(%ebp)
  801740:	8d 45 14             	lea    0x14(%ebp),%eax
  801743:	50                   	push   %eax
  801744:	e8 e7 fb ff ff       	call   801330 <getuint>
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80174f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801752:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801759:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80175d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	52                   	push   %edx
  801764:	ff 75 e4             	pushl  -0x1c(%ebp)
  801767:	50                   	push   %eax
  801768:	ff 75 f4             	pushl  -0xc(%ebp)
  80176b:	ff 75 f0             	pushl  -0x10(%ebp)
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	ff 75 08             	pushl  0x8(%ebp)
  801774:	e8 00 fb ff ff       	call   801279 <printnum>
  801779:	83 c4 20             	add    $0x20,%esp
			break;
  80177c:	eb 34                	jmp    8017b2 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	53                   	push   %ebx
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	ff d0                	call   *%eax
  80178a:	83 c4 10             	add    $0x10,%esp
			break;
  80178d:	eb 23                	jmp    8017b2 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80178f:	83 ec 08             	sub    $0x8,%esp
  801792:	ff 75 0c             	pushl  0xc(%ebp)
  801795:	6a 25                	push   $0x25
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	ff d0                	call   *%eax
  80179c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80179f:	ff 4d 10             	decl   0x10(%ebp)
  8017a2:	eb 03                	jmp    8017a7 <vprintfmt+0x3b1>
  8017a4:	ff 4d 10             	decl   0x10(%ebp)
  8017a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017aa:	48                   	dec    %eax
  8017ab:	8a 00                	mov    (%eax),%al
  8017ad:	3c 25                	cmp    $0x25,%al
  8017af:	75 f3                	jne    8017a4 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8017b1:	90                   	nop
		}
	}
  8017b2:	e9 47 fc ff ff       	jmp    8013fe <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8017b7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8017b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017bb:	5b                   	pop    %ebx
  8017bc:	5e                   	pop    %esi
  8017bd:	5d                   	pop    %ebp
  8017be:	c3                   	ret    

008017bf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8017c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8017c8:	83 c0 04             	add    $0x4,%eax
  8017cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8017ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d4:	50                   	push   %eax
  8017d5:	ff 75 0c             	pushl  0xc(%ebp)
  8017d8:	ff 75 08             	pushl  0x8(%ebp)
  8017db:	e8 16 fc ff ff       	call   8013f6 <vprintfmt>
  8017e0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8017e3:	90                   	nop
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	8b 40 08             	mov    0x8(%eax),%eax
  8017ef:	8d 50 01             	lea    0x1(%eax),%edx
  8017f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8017f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fb:	8b 10                	mov    (%eax),%edx
  8017fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801800:	8b 40 04             	mov    0x4(%eax),%eax
  801803:	39 c2                	cmp    %eax,%edx
  801805:	73 12                	jae    801819 <sprintputch+0x33>
		*b->buf++ = ch;
  801807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	8d 48 01             	lea    0x1(%eax),%ecx
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	89 0a                	mov    %ecx,(%edx)
  801814:	8b 55 08             	mov    0x8(%ebp),%edx
  801817:	88 10                	mov    %dl,(%eax)
}
  801819:	90                   	nop
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	01 d0                	add    %edx,%eax
  801833:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80183d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801841:	74 06                	je     801849 <vsnprintf+0x2d>
  801843:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801847:	7f 07                	jg     801850 <vsnprintf+0x34>
		return -E_INVAL;
  801849:	b8 03 00 00 00       	mov    $0x3,%eax
  80184e:	eb 20                	jmp    801870 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801850:	ff 75 14             	pushl  0x14(%ebp)
  801853:	ff 75 10             	pushl  0x10(%ebp)
  801856:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801859:	50                   	push   %eax
  80185a:	68 e6 17 80 00       	push   $0x8017e6
  80185f:	e8 92 fb ff ff       	call   8013f6 <vprintfmt>
  801864:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80186d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801878:	8d 45 10             	lea    0x10(%ebp),%eax
  80187b:	83 c0 04             	add    $0x4,%eax
  80187e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	ff 75 f4             	pushl  -0xc(%ebp)
  801887:	50                   	push   %eax
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	e8 89 ff ff ff       	call   80181c <vsnprintf>
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801899:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ab:	eb 06                	jmp    8018b3 <strlen+0x15>
		n++;
  8018ad:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018b0:	ff 45 08             	incl   0x8(%ebp)
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	8a 00                	mov    (%eax),%al
  8018b8:	84 c0                	test   %al,%al
  8018ba:	75 f1                	jne    8018ad <strlen+0xf>
		n++;
	return n;
  8018bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ce:	eb 09                	jmp    8018d9 <strnlen+0x18>
		n++;
  8018d0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018d3:	ff 45 08             	incl   0x8(%ebp)
  8018d6:	ff 4d 0c             	decl   0xc(%ebp)
  8018d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018dd:	74 09                	je     8018e8 <strnlen+0x27>
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	8a 00                	mov    (%eax),%al
  8018e4:	84 c0                	test   %al,%al
  8018e6:	75 e8                	jne    8018d0 <strnlen+0xf>
		n++;
	return n;
  8018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8018f9:	90                   	nop
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	8d 50 01             	lea    0x1(%eax),%edx
  801900:	89 55 08             	mov    %edx,0x8(%ebp)
  801903:	8b 55 0c             	mov    0xc(%ebp),%edx
  801906:	8d 4a 01             	lea    0x1(%edx),%ecx
  801909:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80190c:	8a 12                	mov    (%edx),%dl
  80190e:	88 10                	mov    %dl,(%eax)
  801910:	8a 00                	mov    (%eax),%al
  801912:	84 c0                	test   %al,%al
  801914:	75 e4                	jne    8018fa <strcpy+0xd>
		/* do nothing */;
	return ret;
  801916:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801927:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192e:	eb 1f                	jmp    80194f <strncpy+0x34>
		*dst++ = *src;
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	8d 50 01             	lea    0x1(%eax),%edx
  801936:	89 55 08             	mov    %edx,0x8(%ebp)
  801939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193c:	8a 12                	mov    (%edx),%dl
  80193e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	8a 00                	mov    (%eax),%al
  801945:	84 c0                	test   %al,%al
  801947:	74 03                	je     80194c <strncpy+0x31>
			src++;
  801949:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80194c:	ff 45 fc             	incl   -0x4(%ebp)
  80194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801952:	3b 45 10             	cmp    0x10(%ebp),%eax
  801955:	72 d9                	jb     801930 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801957:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801968:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196c:	74 30                	je     80199e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80196e:	eb 16                	jmp    801986 <strlcpy+0x2a>
			*dst++ = *src++;
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	8d 50 01             	lea    0x1(%eax),%edx
  801976:	89 55 08             	mov    %edx,0x8(%ebp)
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80197f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801982:	8a 12                	mov    (%edx),%dl
  801984:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801986:	ff 4d 10             	decl   0x10(%ebp)
  801989:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80198d:	74 09                	je     801998 <strlcpy+0x3c>
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	8a 00                	mov    (%eax),%al
  801994:	84 c0                	test   %al,%al
  801996:	75 d8                	jne    801970 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80199e:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a4:	29 c2                	sub    %eax,%edx
  8019a6:	89 d0                	mov    %edx,%eax
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8019ad:	eb 06                	jmp    8019b5 <strcmp+0xb>
		p++, q++;
  8019af:	ff 45 08             	incl   0x8(%ebp)
  8019b2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	8a 00                	mov    (%eax),%al
  8019ba:	84 c0                	test   %al,%al
  8019bc:	74 0e                	je     8019cc <strcmp+0x22>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 10                	mov    (%eax),%dl
  8019c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c6:	8a 00                	mov    (%eax),%al
  8019c8:	38 c2                	cmp    %al,%dl
  8019ca:	74 e3                	je     8019af <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	8a 00                	mov    (%eax),%al
  8019d1:	0f b6 d0             	movzbl %al,%edx
  8019d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d7:	8a 00                	mov    (%eax),%al
  8019d9:	0f b6 c0             	movzbl %al,%eax
  8019dc:	29 c2                	sub    %eax,%edx
  8019de:	89 d0                	mov    %edx,%eax
}
  8019e0:	5d                   	pop    %ebp
  8019e1:	c3                   	ret    

008019e2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8019e5:	eb 09                	jmp    8019f0 <strncmp+0xe>
		n--, p++, q++;
  8019e7:	ff 4d 10             	decl   0x10(%ebp)
  8019ea:	ff 45 08             	incl   0x8(%ebp)
  8019ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8019f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019f4:	74 17                	je     801a0d <strncmp+0x2b>
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8a 00                	mov    (%eax),%al
  8019fb:	84 c0                	test   %al,%al
  8019fd:	74 0e                	je     801a0d <strncmp+0x2b>
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8a 10                	mov    (%eax),%dl
  801a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a07:	8a 00                	mov    (%eax),%al
  801a09:	38 c2                	cmp    %al,%dl
  801a0b:	74 da                	je     8019e7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a11:	75 07                	jne    801a1a <strncmp+0x38>
		return 0;
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
  801a18:	eb 14                	jmp    801a2e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	8a 00                	mov    (%eax),%al
  801a1f:	0f b6 d0             	movzbl %al,%edx
  801a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a25:	8a 00                	mov    (%eax),%al
  801a27:	0f b6 c0             	movzbl %al,%eax
  801a2a:	29 c2                	sub    %eax,%edx
  801a2c:	89 d0                	mov    %edx,%eax
}
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 04             	sub    $0x4,%esp
  801a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a39:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a3c:	eb 12                	jmp    801a50 <strchr+0x20>
		if (*s == c)
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a46:	75 05                	jne    801a4d <strchr+0x1d>
			return (char *) s;
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	eb 11                	jmp    801a5e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a4d:	ff 45 08             	incl   0x8(%ebp)
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	75 e5                	jne    801a3e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a6c:	eb 0d                	jmp    801a7b <strfind+0x1b>
		if (*s == c)
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	8a 00                	mov    (%eax),%al
  801a73:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a76:	74 0e                	je     801a86 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801a78:	ff 45 08             	incl   0x8(%ebp)
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	8a 00                	mov    (%eax),%al
  801a80:	84 c0                	test   %al,%al
  801a82:	75 ea                	jne    801a6e <strfind+0xe>
  801a84:	eb 01                	jmp    801a87 <strfind+0x27>
		if (*s == c)
			break;
  801a86:	90                   	nop
	return (char *) s;
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801a98:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801a9e:	eb 0e                	jmp    801aae <memset+0x22>
		*p++ = c;
  801aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa3:	8d 50 01             	lea    0x1(%eax),%edx
  801aa6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aac:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801aae:	ff 4d f8             	decl   -0x8(%ebp)
  801ab1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ab5:	79 e9                	jns    801aa0 <memset+0x14>
		*p++ = c;

	return v;
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801ace:	eb 16                	jmp    801ae6 <memcpy+0x2a>
		*d++ = *s++;
  801ad0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad3:	8d 50 01             	lea    0x1(%eax),%edx
  801ad6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ad9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801adc:	8d 4a 01             	lea    0x1(%edx),%ecx
  801adf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ae2:	8a 12                	mov    (%edx),%dl
  801ae4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801ae6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801aec:	89 55 10             	mov    %edx,0x10(%ebp)
  801aef:	85 c0                	test   %eax,%eax
  801af1:	75 dd                	jne    801ad0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801b0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b10:	73 50                	jae    801b62 <memmove+0x6a>
  801b12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b15:	8b 45 10             	mov    0x10(%ebp),%eax
  801b18:	01 d0                	add    %edx,%eax
  801b1a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b1d:	76 43                	jbe    801b62 <memmove+0x6a>
		s += n;
  801b1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b22:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b25:	8b 45 10             	mov    0x10(%ebp),%eax
  801b28:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b2b:	eb 10                	jmp    801b3d <memmove+0x45>
			*--d = *--s;
  801b2d:	ff 4d f8             	decl   -0x8(%ebp)
  801b30:	ff 4d fc             	decl   -0x4(%ebp)
  801b33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b36:	8a 10                	mov    (%eax),%dl
  801b38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b3b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b40:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b43:	89 55 10             	mov    %edx,0x10(%ebp)
  801b46:	85 c0                	test   %eax,%eax
  801b48:	75 e3                	jne    801b2d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b4a:	eb 23                	jmp    801b6f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b4f:	8d 50 01             	lea    0x1(%eax),%edx
  801b52:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b58:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b5b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b5e:	8a 12                	mov    (%edx),%dl
  801b60:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b62:	8b 45 10             	mov    0x10(%ebp),%eax
  801b65:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b68:	89 55 10             	mov    %edx,0x10(%ebp)
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	75 dd                	jne    801b4c <memmove+0x54>
			*d++ = *s++;

	return dst;
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801b86:	eb 2a                	jmp    801bb2 <memcmp+0x3e>
		if (*s1 != *s2)
  801b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b8b:	8a 10                	mov    (%eax),%dl
  801b8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b90:	8a 00                	mov    (%eax),%al
  801b92:	38 c2                	cmp    %al,%dl
  801b94:	74 16                	je     801bac <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b99:	8a 00                	mov    (%eax),%al
  801b9b:	0f b6 d0             	movzbl %al,%edx
  801b9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba1:	8a 00                	mov    (%eax),%al
  801ba3:	0f b6 c0             	movzbl %al,%eax
  801ba6:	29 c2                	sub    %eax,%edx
  801ba8:	89 d0                	mov    %edx,%eax
  801baa:	eb 18                	jmp    801bc4 <memcmp+0x50>
		s1++, s2++;
  801bac:	ff 45 fc             	incl   -0x4(%ebp)
  801baf:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bb8:	89 55 10             	mov    %edx,0x10(%ebp)
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	75 c9                	jne    801b88 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  801bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd2:	01 d0                	add    %edx,%eax
  801bd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801bd7:	eb 15                	jmp    801bee <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	8a 00                	mov    (%eax),%al
  801bde:	0f b6 d0             	movzbl %al,%edx
  801be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be4:	0f b6 c0             	movzbl %al,%eax
  801be7:	39 c2                	cmp    %eax,%edx
  801be9:	74 0d                	je     801bf8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801beb:	ff 45 08             	incl   0x8(%ebp)
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bf4:	72 e3                	jb     801bd9 <memfind+0x13>
  801bf6:	eb 01                	jmp    801bf9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801bf8:	90                   	nop
	return (void *) s;
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801c04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801c0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c12:	eb 03                	jmp    801c17 <strtol+0x19>
		s++;
  801c14:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	8a 00                	mov    (%eax),%al
  801c1c:	3c 20                	cmp    $0x20,%al
  801c1e:	74 f4                	je     801c14 <strtol+0x16>
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	8a 00                	mov    (%eax),%al
  801c25:	3c 09                	cmp    $0x9,%al
  801c27:	74 eb                	je     801c14 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8a 00                	mov    (%eax),%al
  801c2e:	3c 2b                	cmp    $0x2b,%al
  801c30:	75 05                	jne    801c37 <strtol+0x39>
		s++;
  801c32:	ff 45 08             	incl   0x8(%ebp)
  801c35:	eb 13                	jmp    801c4a <strtol+0x4c>
	else if (*s == '-')
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	8a 00                	mov    (%eax),%al
  801c3c:	3c 2d                	cmp    $0x2d,%al
  801c3e:	75 0a                	jne    801c4a <strtol+0x4c>
		s++, neg = 1;
  801c40:	ff 45 08             	incl   0x8(%ebp)
  801c43:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c4e:	74 06                	je     801c56 <strtol+0x58>
  801c50:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c54:	75 20                	jne    801c76 <strtol+0x78>
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	8a 00                	mov    (%eax),%al
  801c5b:	3c 30                	cmp    $0x30,%al
  801c5d:	75 17                	jne    801c76 <strtol+0x78>
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	40                   	inc    %eax
  801c63:	8a 00                	mov    (%eax),%al
  801c65:	3c 78                	cmp    $0x78,%al
  801c67:	75 0d                	jne    801c76 <strtol+0x78>
		s += 2, base = 16;
  801c69:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801c6d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801c74:	eb 28                	jmp    801c9e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801c76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c7a:	75 15                	jne    801c91 <strtol+0x93>
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	8a 00                	mov    (%eax),%al
  801c81:	3c 30                	cmp    $0x30,%al
  801c83:	75 0c                	jne    801c91 <strtol+0x93>
		s++, base = 8;
  801c85:	ff 45 08             	incl   0x8(%ebp)
  801c88:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801c8f:	eb 0d                	jmp    801c9e <strtol+0xa0>
	else if (base == 0)
  801c91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c95:	75 07                	jne    801c9e <strtol+0xa0>
		base = 10;
  801c97:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	8a 00                	mov    (%eax),%al
  801ca3:	3c 2f                	cmp    $0x2f,%al
  801ca5:	7e 19                	jle    801cc0 <strtol+0xc2>
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	8a 00                	mov    (%eax),%al
  801cac:	3c 39                	cmp    $0x39,%al
  801cae:	7f 10                	jg     801cc0 <strtol+0xc2>
			dig = *s - '0';
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	8a 00                	mov    (%eax),%al
  801cb5:	0f be c0             	movsbl %al,%eax
  801cb8:	83 e8 30             	sub    $0x30,%eax
  801cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cbe:	eb 42                	jmp    801d02 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	8a 00                	mov    (%eax),%al
  801cc5:	3c 60                	cmp    $0x60,%al
  801cc7:	7e 19                	jle    801ce2 <strtol+0xe4>
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	8a 00                	mov    (%eax),%al
  801cce:	3c 7a                	cmp    $0x7a,%al
  801cd0:	7f 10                	jg     801ce2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	8a 00                	mov    (%eax),%al
  801cd7:	0f be c0             	movsbl %al,%eax
  801cda:	83 e8 57             	sub    $0x57,%eax
  801cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ce0:	eb 20                	jmp    801d02 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	8a 00                	mov    (%eax),%al
  801ce7:	3c 40                	cmp    $0x40,%al
  801ce9:	7e 39                	jle    801d24 <strtol+0x126>
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	8a 00                	mov    (%eax),%al
  801cf0:	3c 5a                	cmp    $0x5a,%al
  801cf2:	7f 30                	jg     801d24 <strtol+0x126>
			dig = *s - 'A' + 10;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	8a 00                	mov    (%eax),%al
  801cf9:	0f be c0             	movsbl %al,%eax
  801cfc:	83 e8 37             	sub    $0x37,%eax
  801cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d05:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d08:	7d 19                	jge    801d23 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801d0a:	ff 45 08             	incl   0x8(%ebp)
  801d0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d10:	0f af 45 10          	imul   0x10(%ebp),%eax
  801d14:	89 c2                	mov    %eax,%edx
  801d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d19:	01 d0                	add    %edx,%eax
  801d1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d1e:	e9 7b ff ff ff       	jmp    801c9e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d23:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d28:	74 08                	je     801d32 <strtol+0x134>
		*endptr = (char *) s;
  801d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d30:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d32:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d36:	74 07                	je     801d3f <strtol+0x141>
  801d38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d3b:	f7 d8                	neg    %eax
  801d3d:	eb 03                	jmp    801d42 <strtol+0x144>
  801d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <ltostr>:

void
ltostr(long value, char *str)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d51:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d5c:	79 13                	jns    801d71 <ltostr+0x2d>
	{
		neg = 1;
  801d5e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d68:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801d6b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801d6e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d79:	99                   	cltd   
  801d7a:	f7 f9                	idiv   %ecx
  801d7c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d82:	8d 50 01             	lea    0x1(%eax),%edx
  801d85:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d88:	89 c2                	mov    %eax,%edx
  801d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8d:	01 d0                	add    %edx,%eax
  801d8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d92:	83 c2 30             	add    $0x30,%edx
  801d95:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801d97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d9a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d9f:	f7 e9                	imul   %ecx
  801da1:	c1 fa 02             	sar    $0x2,%edx
  801da4:	89 c8                	mov    %ecx,%eax
  801da6:	c1 f8 1f             	sar    $0x1f,%eax
  801da9:	29 c2                	sub    %eax,%edx
  801dab:	89 d0                	mov    %edx,%eax
  801dad:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801db0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801db8:	f7 e9                	imul   %ecx
  801dba:	c1 fa 02             	sar    $0x2,%edx
  801dbd:	89 c8                	mov    %ecx,%eax
  801dbf:	c1 f8 1f             	sar    $0x1f,%eax
  801dc2:	29 c2                	sub    %eax,%edx
  801dc4:	89 d0                	mov    %edx,%eax
  801dc6:	c1 e0 02             	shl    $0x2,%eax
  801dc9:	01 d0                	add    %edx,%eax
  801dcb:	01 c0                	add    %eax,%eax
  801dcd:	29 c1                	sub    %eax,%ecx
  801dcf:	89 ca                	mov    %ecx,%edx
  801dd1:	85 d2                	test   %edx,%edx
  801dd3:	75 9c                	jne    801d71 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801dd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ddf:	48                   	dec    %eax
  801de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801de3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801de7:	74 3d                	je     801e26 <ltostr+0xe2>
		start = 1 ;
  801de9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801df0:	eb 34                	jmp    801e26 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	01 d0                	add    %edx,%eax
  801dfa:	8a 00                	mov    (%eax),%al
  801dfc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801dff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e05:	01 c2                	add    %eax,%edx
  801e07:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0d:	01 c8                	add    %ecx,%eax
  801e0f:	8a 00                	mov    (%eax),%al
  801e11:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801e13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e19:	01 c2                	add    %eax,%edx
  801e1b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e1e:	88 02                	mov    %al,(%edx)
		start++ ;
  801e20:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e23:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e2c:	7c c4                	jl     801df2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e2e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e34:	01 d0                	add    %edx,%eax
  801e36:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e39:	90                   	nop
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e42:	ff 75 08             	pushl  0x8(%ebp)
  801e45:	e8 54 fa ff ff       	call   80189e <strlen>
  801e4a:	83 c4 04             	add    $0x4,%esp
  801e4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	e8 46 fa ff ff       	call   80189e <strlen>
  801e58:	83 c4 04             	add    $0x4,%esp
  801e5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e6c:	eb 17                	jmp    801e85 <strcconcat+0x49>
		final[s] = str1[s] ;
  801e6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e71:	8b 45 10             	mov    0x10(%ebp),%eax
  801e74:	01 c2                	add    %eax,%edx
  801e76:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	01 c8                	add    %ecx,%eax
  801e7e:	8a 00                	mov    (%eax),%al
  801e80:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801e82:	ff 45 fc             	incl   -0x4(%ebp)
  801e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e88:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e8b:	7c e1                	jl     801e6e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801e8d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801e94:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801e9b:	eb 1f                	jmp    801ebc <strcconcat+0x80>
		final[s++] = str2[i] ;
  801e9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ea0:	8d 50 01             	lea    0x1(%eax),%edx
  801ea3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ea6:	89 c2                	mov    %eax,%edx
  801ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eab:	01 c2                	add    %eax,%edx
  801ead:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb3:	01 c8                	add    %ecx,%eax
  801eb5:	8a 00                	mov    (%eax),%al
  801eb7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801eb9:	ff 45 f8             	incl   -0x8(%ebp)
  801ebc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ebf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ec2:	7c d9                	jl     801e9d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ec4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eca:	01 d0                	add    %edx,%eax
  801ecc:	c6 00 00             	movb   $0x0,(%eax)
}
  801ecf:	90                   	nop
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ede:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee1:	8b 00                	mov    (%eax),%eax
  801ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eea:	8b 45 10             	mov    0x10(%ebp),%eax
  801eed:	01 d0                	add    %edx,%eax
  801eef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ef5:	eb 0c                	jmp    801f03 <strsplit+0x31>
			*string++ = 0;
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	8d 50 01             	lea    0x1(%eax),%edx
  801efd:	89 55 08             	mov    %edx,0x8(%ebp)
  801f00:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	8a 00                	mov    (%eax),%al
  801f08:	84 c0                	test   %al,%al
  801f0a:	74 18                	je     801f24 <strsplit+0x52>
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	8a 00                	mov    (%eax),%al
  801f11:	0f be c0             	movsbl %al,%eax
  801f14:	50                   	push   %eax
  801f15:	ff 75 0c             	pushl  0xc(%ebp)
  801f18:	e8 13 fb ff ff       	call   801a30 <strchr>
  801f1d:	83 c4 08             	add    $0x8,%esp
  801f20:	85 c0                	test   %eax,%eax
  801f22:	75 d3                	jne    801ef7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	8a 00                	mov    (%eax),%al
  801f29:	84 c0                	test   %al,%al
  801f2b:	74 5a                	je     801f87 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f30:	8b 00                	mov    (%eax),%eax
  801f32:	83 f8 0f             	cmp    $0xf,%eax
  801f35:	75 07                	jne    801f3e <strsplit+0x6c>
		{
			return 0;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3c:	eb 66                	jmp    801fa4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f41:	8b 00                	mov    (%eax),%eax
  801f43:	8d 48 01             	lea    0x1(%eax),%ecx
  801f46:	8b 55 14             	mov    0x14(%ebp),%edx
  801f49:	89 0a                	mov    %ecx,(%edx)
  801f4b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f52:	8b 45 10             	mov    0x10(%ebp),%eax
  801f55:	01 c2                	add    %eax,%edx
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f5c:	eb 03                	jmp    801f61 <strsplit+0x8f>
			string++;
  801f5e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	8a 00                	mov    (%eax),%al
  801f66:	84 c0                	test   %al,%al
  801f68:	74 8b                	je     801ef5 <strsplit+0x23>
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	8a 00                	mov    (%eax),%al
  801f6f:	0f be c0             	movsbl %al,%eax
  801f72:	50                   	push   %eax
  801f73:	ff 75 0c             	pushl  0xc(%ebp)
  801f76:	e8 b5 fa ff ff       	call   801a30 <strchr>
  801f7b:	83 c4 08             	add    $0x8,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	74 dc                	je     801f5e <strsplit+0x8c>
			string++;
	}
  801f82:	e9 6e ff ff ff       	jmp    801ef5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801f87:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801f88:	8b 45 14             	mov    0x14(%ebp),%eax
  801f8b:	8b 00                	mov    (%eax),%eax
  801f8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f94:	8b 45 10             	mov    0x10(%ebp),%eax
  801f97:	01 d0                	add    %edx,%eax
  801f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801f9f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801fac:	a1 04 50 80 00       	mov    0x805004,%eax
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	74 1f                	je     801fd4 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801fb5:	e8 1d 00 00 00       	call   801fd7 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	68 70 49 80 00       	push   $0x804970
  801fc2:	e8 55 f2 ff ff       	call   80121c <cprintf>
  801fc7:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801fca:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801fd1:	00 00 00 
	}
}
  801fd4:	90                   	nop
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801fdd:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801fe4:	00 00 00 
  801fe7:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801fee:	00 00 00 
  801ff1:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801ff8:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801ffb:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802002:	00 00 00 
  802005:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80200c:	00 00 00 
  80200f:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802016:	00 00 00 
	uint32 arr_size = 0;
  802019:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  802020:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  802027:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80202f:	2d 00 10 00 00       	sub    $0x1000,%eax
  802034:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  802039:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  802040:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  802043:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80204a:	a1 20 51 80 00       	mov    0x805120,%eax
  80204f:	c1 e0 04             	shl    $0x4,%eax
  802052:	89 c2                	mov    %eax,%edx
  802054:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802057:	01 d0                	add    %edx,%eax
  802059:	48                   	dec    %eax
  80205a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80205d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802060:	ba 00 00 00 00       	mov    $0x0,%edx
  802065:	f7 75 ec             	divl   -0x14(%ebp)
  802068:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80206b:	29 d0                	sub    %edx,%eax
  80206d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  802070:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  802077:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80207a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80207f:	2d 00 10 00 00       	sub    $0x1000,%eax
  802084:	83 ec 04             	sub    $0x4,%esp
  802087:	6a 06                	push   $0x6
  802089:	ff 75 f4             	pushl  -0xc(%ebp)
  80208c:	50                   	push   %eax
  80208d:	e8 42 04 00 00       	call   8024d4 <sys_allocate_chunk>
  802092:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802095:	a1 20 51 80 00       	mov    0x805120,%eax
  80209a:	83 ec 0c             	sub    $0xc,%esp
  80209d:	50                   	push   %eax
  80209e:	e8 b7 0a 00 00       	call   802b5a <initialize_MemBlocksList>
  8020a3:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8020a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8020ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8020ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020b1:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8020b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020bb:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8020c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020c6:	75 14                	jne    8020dc <initialize_dyn_block_system+0x105>
  8020c8:	83 ec 04             	sub    $0x4,%esp
  8020cb:	68 95 49 80 00       	push   $0x804995
  8020d0:	6a 33                	push   $0x33
  8020d2:	68 b3 49 80 00       	push   $0x8049b3
  8020d7:	e8 8c ee ff ff       	call   800f68 <_panic>
  8020dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020df:	8b 00                	mov    (%eax),%eax
  8020e1:	85 c0                	test   %eax,%eax
  8020e3:	74 10                	je     8020f5 <initialize_dyn_block_system+0x11e>
  8020e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020e8:	8b 00                	mov    (%eax),%eax
  8020ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020ed:	8b 52 04             	mov    0x4(%edx),%edx
  8020f0:	89 50 04             	mov    %edx,0x4(%eax)
  8020f3:	eb 0b                	jmp    802100 <initialize_dyn_block_system+0x129>
  8020f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020f8:	8b 40 04             	mov    0x4(%eax),%eax
  8020fb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802100:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802103:	8b 40 04             	mov    0x4(%eax),%eax
  802106:	85 c0                	test   %eax,%eax
  802108:	74 0f                	je     802119 <initialize_dyn_block_system+0x142>
  80210a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80210d:	8b 40 04             	mov    0x4(%eax),%eax
  802110:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802113:	8b 12                	mov    (%edx),%edx
  802115:	89 10                	mov    %edx,(%eax)
  802117:	eb 0a                	jmp    802123 <initialize_dyn_block_system+0x14c>
  802119:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80211c:	8b 00                	mov    (%eax),%eax
  80211e:	a3 48 51 80 00       	mov    %eax,0x805148
  802123:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802126:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80212c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80212f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802136:	a1 54 51 80 00       	mov    0x805154,%eax
  80213b:	48                   	dec    %eax
  80213c:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  802141:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802145:	75 14                	jne    80215b <initialize_dyn_block_system+0x184>
  802147:	83 ec 04             	sub    $0x4,%esp
  80214a:	68 c0 49 80 00       	push   $0x8049c0
  80214f:	6a 34                	push   $0x34
  802151:	68 b3 49 80 00       	push   $0x8049b3
  802156:	e8 0d ee ff ff       	call   800f68 <_panic>
  80215b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802161:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802164:	89 10                	mov    %edx,(%eax)
  802166:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802169:	8b 00                	mov    (%eax),%eax
  80216b:	85 c0                	test   %eax,%eax
  80216d:	74 0d                	je     80217c <initialize_dyn_block_system+0x1a5>
  80216f:	a1 38 51 80 00       	mov    0x805138,%eax
  802174:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802177:	89 50 04             	mov    %edx,0x4(%eax)
  80217a:	eb 08                	jmp    802184 <initialize_dyn_block_system+0x1ad>
  80217c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80217f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802187:	a3 38 51 80 00       	mov    %eax,0x805138
  80218c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80218f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802196:	a1 44 51 80 00       	mov    0x805144,%eax
  80219b:	40                   	inc    %eax
  80219c:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8021a1:	90                   	nop
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021aa:	e8 f7 fd ff ff       	call   801fa6 <InitializeUHeap>
	if (size == 0) return NULL ;
  8021af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b3:	75 07                	jne    8021bc <malloc+0x18>
  8021b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ba:	eb 14                	jmp    8021d0 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8021bc:	83 ec 04             	sub    $0x4,%esp
  8021bf:	68 e4 49 80 00       	push   $0x8049e4
  8021c4:	6a 46                	push   $0x46
  8021c6:	68 b3 49 80 00       	push   $0x8049b3
  8021cb:	e8 98 ed ff ff       	call   800f68 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8021d8:	83 ec 04             	sub    $0x4,%esp
  8021db:	68 0c 4a 80 00       	push   $0x804a0c
  8021e0:	6a 61                	push   $0x61
  8021e2:	68 b3 49 80 00       	push   $0x8049b3
  8021e7:	e8 7c ed ff ff       	call   800f68 <_panic>

008021ec <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 38             	sub    $0x38,%esp
  8021f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f5:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021f8:	e8 a9 fd ff ff       	call   801fa6 <InitializeUHeap>
	if (size == 0) return NULL ;
  8021fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802201:	75 0a                	jne    80220d <smalloc+0x21>
  802203:	b8 00 00 00 00       	mov    $0x0,%eax
  802208:	e9 9e 00 00 00       	jmp    8022ab <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80220d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802214:	8b 55 0c             	mov    0xc(%ebp),%edx
  802217:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221a:	01 d0                	add    %edx,%eax
  80221c:	48                   	dec    %eax
  80221d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802220:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802223:	ba 00 00 00 00       	mov    $0x0,%edx
  802228:	f7 75 f0             	divl   -0x10(%ebp)
  80222b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222e:	29 d0                	sub    %edx,%eax
  802230:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  802233:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80223a:	e8 63 06 00 00       	call   8028a2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80223f:	85 c0                	test   %eax,%eax
  802241:	74 11                	je     802254 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  802243:	83 ec 0c             	sub    $0xc,%esp
  802246:	ff 75 e8             	pushl  -0x18(%ebp)
  802249:	e8 ce 0c 00 00       	call   802f1c <alloc_block_FF>
  80224e:	83 c4 10             	add    $0x10,%esp
  802251:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  802254:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802258:	74 4c                	je     8022a6 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	8b 40 08             	mov    0x8(%eax),%eax
  802260:	89 c2                	mov    %eax,%edx
  802262:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802266:	52                   	push   %edx
  802267:	50                   	push   %eax
  802268:	ff 75 0c             	pushl  0xc(%ebp)
  80226b:	ff 75 08             	pushl  0x8(%ebp)
  80226e:	e8 b4 03 00 00       	call   802627 <sys_createSharedObject>
  802273:	83 c4 10             	add    $0x10,%esp
  802276:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  802279:	83 ec 08             	sub    $0x8,%esp
  80227c:	ff 75 e0             	pushl  -0x20(%ebp)
  80227f:	68 2f 4a 80 00       	push   $0x804a2f
  802284:	e8 93 ef ff ff       	call   80121c <cprintf>
  802289:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80228c:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802290:	74 14                	je     8022a6 <smalloc+0xba>
  802292:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  802296:	74 0e                	je     8022a6 <smalloc+0xba>
  802298:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80229c:	74 08                	je     8022a6 <smalloc+0xba>
			return (void*) mem_block->sva;
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	8b 40 08             	mov    0x8(%eax),%eax
  8022a4:	eb 05                	jmp    8022ab <smalloc+0xbf>
	}
	return NULL;
  8022a6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022b3:	e8 ee fc ff ff       	call   801fa6 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8022b8:	83 ec 04             	sub    $0x4,%esp
  8022bb:	68 44 4a 80 00       	push   $0x804a44
  8022c0:	68 ab 00 00 00       	push   $0xab
  8022c5:	68 b3 49 80 00       	push   $0x8049b3
  8022ca:	e8 99 ec ff ff       	call   800f68 <_panic>

008022cf <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
  8022d2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022d5:	e8 cc fc ff ff       	call   801fa6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8022da:	83 ec 04             	sub    $0x4,%esp
  8022dd:	68 68 4a 80 00       	push   $0x804a68
  8022e2:	68 ef 00 00 00       	push   $0xef
  8022e7:	68 b3 49 80 00       	push   $0x8049b3
  8022ec:	e8 77 ec ff ff       	call   800f68 <_panic>

008022f1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8022f7:	83 ec 04             	sub    $0x4,%esp
  8022fa:	68 90 4a 80 00       	push   $0x804a90
  8022ff:	68 03 01 00 00       	push   $0x103
  802304:	68 b3 49 80 00       	push   $0x8049b3
  802309:	e8 5a ec ff ff       	call   800f68 <_panic>

0080230e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802314:	83 ec 04             	sub    $0x4,%esp
  802317:	68 b4 4a 80 00       	push   $0x804ab4
  80231c:	68 0e 01 00 00       	push   $0x10e
  802321:	68 b3 49 80 00       	push   $0x8049b3
  802326:	e8 3d ec ff ff       	call   800f68 <_panic>

0080232b <shrink>:

}
void shrink(uint32 newSize)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802331:	83 ec 04             	sub    $0x4,%esp
  802334:	68 b4 4a 80 00       	push   $0x804ab4
  802339:	68 13 01 00 00       	push   $0x113
  80233e:	68 b3 49 80 00       	push   $0x8049b3
  802343:	e8 20 ec ff ff       	call   800f68 <_panic>

00802348 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80234e:	83 ec 04             	sub    $0x4,%esp
  802351:	68 b4 4a 80 00       	push   $0x804ab4
  802356:	68 18 01 00 00       	push   $0x118
  80235b:	68 b3 49 80 00       	push   $0x8049b3
  802360:	e8 03 ec ff ff       	call   800f68 <_panic>

00802365 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	57                   	push   %edi
  802369:	56                   	push   %esi
  80236a:	53                   	push   %ebx
  80236b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	8b 55 0c             	mov    0xc(%ebp),%edx
  802374:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802377:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80237a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80237d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802380:	cd 30                	int    $0x30
  802382:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802385:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802388:	83 c4 10             	add    $0x10,%esp
  80238b:	5b                   	pop    %ebx
  80238c:	5e                   	pop    %esi
  80238d:	5f                   	pop    %edi
  80238e:	5d                   	pop    %ebp
  80238f:	c3                   	ret    

00802390 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	83 ec 04             	sub    $0x4,%esp
  802396:	8b 45 10             	mov    0x10(%ebp),%eax
  802399:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80239c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	52                   	push   %edx
  8023a8:	ff 75 0c             	pushl  0xc(%ebp)
  8023ab:	50                   	push   %eax
  8023ac:	6a 00                	push   $0x0
  8023ae:	e8 b2 ff ff ff       	call   802365 <syscall>
  8023b3:	83 c4 18             	add    $0x18,%esp
}
  8023b6:	90                   	nop
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    

008023b9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 01                	push   $0x1
  8023c8:	e8 98 ff ff ff       	call   802365 <syscall>
  8023cd:	83 c4 18             	add    $0x18,%esp
}
  8023d0:	c9                   	leave  
  8023d1:	c3                   	ret    

008023d2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8023d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	52                   	push   %edx
  8023e2:	50                   	push   %eax
  8023e3:	6a 05                	push   $0x5
  8023e5:	e8 7b ff ff ff       	call   802365 <syscall>
  8023ea:	83 c4 18             	add    $0x18,%esp
}
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	56                   	push   %esi
  8023f3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8023f4:	8b 75 18             	mov    0x18(%ebp),%esi
  8023f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	56                   	push   %esi
  802404:	53                   	push   %ebx
  802405:	51                   	push   %ecx
  802406:	52                   	push   %edx
  802407:	50                   	push   %eax
  802408:	6a 06                	push   $0x6
  80240a:	e8 56 ff ff ff       	call   802365 <syscall>
  80240f:	83 c4 18             	add    $0x18,%esp
}
  802412:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802415:	5b                   	pop    %ebx
  802416:	5e                   	pop    %esi
  802417:	5d                   	pop    %ebp
  802418:	c3                   	ret    

00802419 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80241c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	52                   	push   %edx
  802429:	50                   	push   %eax
  80242a:	6a 07                	push   $0x7
  80242c:	e8 34 ff ff ff       	call   802365 <syscall>
  802431:	83 c4 18             	add    $0x18,%esp
}
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	ff 75 0c             	pushl  0xc(%ebp)
  802442:	ff 75 08             	pushl  0x8(%ebp)
  802445:	6a 08                	push   $0x8
  802447:	e8 19 ff ff ff       	call   802365 <syscall>
  80244c:	83 c4 18             	add    $0x18,%esp
}
  80244f:	c9                   	leave  
  802450:	c3                   	ret    

00802451 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 09                	push   $0x9
  802460:	e8 00 ff ff ff       	call   802365 <syscall>
  802465:	83 c4 18             	add    $0x18,%esp
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 0a                	push   $0xa
  802479:	e8 e7 fe ff ff       	call   802365 <syscall>
  80247e:	83 c4 18             	add    $0x18,%esp
}
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 0b                	push   $0xb
  802492:	e8 ce fe ff ff       	call   802365 <syscall>
  802497:	83 c4 18             	add    $0x18,%esp
}
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	ff 75 0c             	pushl  0xc(%ebp)
  8024a8:	ff 75 08             	pushl  0x8(%ebp)
  8024ab:	6a 0f                	push   $0xf
  8024ad:	e8 b3 fe ff ff       	call   802365 <syscall>
  8024b2:	83 c4 18             	add    $0x18,%esp
	return;
  8024b5:	90                   	nop
}
  8024b6:	c9                   	leave  
  8024b7:	c3                   	ret    

008024b8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024b8:	55                   	push   %ebp
  8024b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	ff 75 0c             	pushl  0xc(%ebp)
  8024c4:	ff 75 08             	pushl  0x8(%ebp)
  8024c7:	6a 10                	push   $0x10
  8024c9:	e8 97 fe ff ff       	call   802365 <syscall>
  8024ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d1:	90                   	nop
}
  8024d2:	c9                   	leave  
  8024d3:	c3                   	ret    

008024d4 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	ff 75 10             	pushl  0x10(%ebp)
  8024de:	ff 75 0c             	pushl  0xc(%ebp)
  8024e1:	ff 75 08             	pushl  0x8(%ebp)
  8024e4:	6a 11                	push   $0x11
  8024e6:	e8 7a fe ff ff       	call   802365 <syscall>
  8024eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ee:	90                   	nop
}
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 0c                	push   $0xc
  802500:	e8 60 fe ff ff       	call   802365 <syscall>
  802505:	83 c4 18             	add    $0x18,%esp
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	ff 75 08             	pushl  0x8(%ebp)
  802518:	6a 0d                	push   $0xd
  80251a:	e8 46 fe ff ff       	call   802365 <syscall>
  80251f:	83 c4 18             	add    $0x18,%esp
}
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 0e                	push   $0xe
  802533:	e8 2d fe ff ff       	call   802365 <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
}
  80253b:	90                   	nop
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 13                	push   $0x13
  80254d:	e8 13 fe ff ff       	call   802365 <syscall>
  802552:	83 c4 18             	add    $0x18,%esp
}
  802555:	90                   	nop
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 14                	push   $0x14
  802567:	e8 f9 fd ff ff       	call   802365 <syscall>
  80256c:	83 c4 18             	add    $0x18,%esp
}
  80256f:	90                   	nop
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <sys_cputc>:


void
sys_cputc(const char c)
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
  802575:	83 ec 04             	sub    $0x4,%esp
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80257e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	50                   	push   %eax
  80258b:	6a 15                	push   $0x15
  80258d:	e8 d3 fd ff ff       	call   802365 <syscall>
  802592:	83 c4 18             	add    $0x18,%esp
}
  802595:	90                   	nop
  802596:	c9                   	leave  
  802597:	c3                   	ret    

00802598 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 16                	push   $0x16
  8025a7:	e8 b9 fd ff ff       	call   802365 <syscall>
  8025ac:	83 c4 18             	add    $0x18,%esp
}
  8025af:	90                   	nop
  8025b0:	c9                   	leave  
  8025b1:	c3                   	ret    

008025b2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8025b2:	55                   	push   %ebp
  8025b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8025b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	ff 75 0c             	pushl  0xc(%ebp)
  8025c1:	50                   	push   %eax
  8025c2:	6a 17                	push   $0x17
  8025c4:	e8 9c fd ff ff       	call   802365 <syscall>
  8025c9:	83 c4 18             	add    $0x18,%esp
}
  8025cc:	c9                   	leave  
  8025cd:	c3                   	ret    

008025ce <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8025ce:	55                   	push   %ebp
  8025cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	52                   	push   %edx
  8025de:	50                   	push   %eax
  8025df:	6a 1a                	push   $0x1a
  8025e1:	e8 7f fd ff ff       	call   802365 <syscall>
  8025e6:	83 c4 18             	add    $0x18,%esp
}
  8025e9:	c9                   	leave  
  8025ea:	c3                   	ret    

008025eb <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	52                   	push   %edx
  8025fb:	50                   	push   %eax
  8025fc:	6a 18                	push   $0x18
  8025fe:	e8 62 fd ff ff       	call   802365 <syscall>
  802603:	83 c4 18             	add    $0x18,%esp
}
  802606:	90                   	nop
  802607:	c9                   	leave  
  802608:	c3                   	ret    

00802609 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802609:	55                   	push   %ebp
  80260a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80260c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80260f:	8b 45 08             	mov    0x8(%ebp),%eax
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	52                   	push   %edx
  802619:	50                   	push   %eax
  80261a:	6a 19                	push   $0x19
  80261c:	e8 44 fd ff ff       	call   802365 <syscall>
  802621:	83 c4 18             	add    $0x18,%esp
}
  802624:	90                   	nop
  802625:	c9                   	leave  
  802626:	c3                   	ret    

00802627 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802627:	55                   	push   %ebp
  802628:	89 e5                	mov    %esp,%ebp
  80262a:	83 ec 04             	sub    $0x4,%esp
  80262d:	8b 45 10             	mov    0x10(%ebp),%eax
  802630:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802633:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802636:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80263a:	8b 45 08             	mov    0x8(%ebp),%eax
  80263d:	6a 00                	push   $0x0
  80263f:	51                   	push   %ecx
  802640:	52                   	push   %edx
  802641:	ff 75 0c             	pushl  0xc(%ebp)
  802644:	50                   	push   %eax
  802645:	6a 1b                	push   $0x1b
  802647:	e8 19 fd ff ff       	call   802365 <syscall>
  80264c:	83 c4 18             	add    $0x18,%esp
}
  80264f:	c9                   	leave  
  802650:	c3                   	ret    

00802651 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802654:	8b 55 0c             	mov    0xc(%ebp),%edx
  802657:	8b 45 08             	mov    0x8(%ebp),%eax
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	52                   	push   %edx
  802661:	50                   	push   %eax
  802662:	6a 1c                	push   $0x1c
  802664:	e8 fc fc ff ff       	call   802365 <syscall>
  802669:	83 c4 18             	add    $0x18,%esp
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802671:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802674:	8b 55 0c             	mov    0xc(%ebp),%edx
  802677:	8b 45 08             	mov    0x8(%ebp),%eax
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	51                   	push   %ecx
  80267f:	52                   	push   %edx
  802680:	50                   	push   %eax
  802681:	6a 1d                	push   $0x1d
  802683:	e8 dd fc ff ff       	call   802365 <syscall>
  802688:	83 c4 18             	add    $0x18,%esp
}
  80268b:	c9                   	leave  
  80268c:	c3                   	ret    

0080268d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80268d:	55                   	push   %ebp
  80268e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802690:	8b 55 0c             	mov    0xc(%ebp),%edx
  802693:	8b 45 08             	mov    0x8(%ebp),%eax
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	52                   	push   %edx
  80269d:	50                   	push   %eax
  80269e:	6a 1e                	push   $0x1e
  8026a0:	e8 c0 fc ff ff       	call   802365 <syscall>
  8026a5:	83 c4 18             	add    $0x18,%esp
}
  8026a8:	c9                   	leave  
  8026a9:	c3                   	ret    

008026aa <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 1f                	push   $0x1f
  8026b9:	e8 a7 fc ff ff       	call   802365 <syscall>
  8026be:	83 c4 18             	add    $0x18,%esp
}
  8026c1:	c9                   	leave  
  8026c2:	c3                   	ret    

008026c3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	6a 00                	push   $0x0
  8026cb:	ff 75 14             	pushl  0x14(%ebp)
  8026ce:	ff 75 10             	pushl  0x10(%ebp)
  8026d1:	ff 75 0c             	pushl  0xc(%ebp)
  8026d4:	50                   	push   %eax
  8026d5:	6a 20                	push   $0x20
  8026d7:	e8 89 fc ff ff       	call   802365 <syscall>
  8026dc:	83 c4 18             	add    $0x18,%esp
}
  8026df:	c9                   	leave  
  8026e0:	c3                   	ret    

008026e1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e7:	6a 00                	push   $0x0
  8026e9:	6a 00                	push   $0x0
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	50                   	push   %eax
  8026f0:	6a 21                	push   $0x21
  8026f2:	e8 6e fc ff ff       	call   802365 <syscall>
  8026f7:	83 c4 18             	add    $0x18,%esp
}
  8026fa:	90                   	nop
  8026fb:	c9                   	leave  
  8026fc:	c3                   	ret    

008026fd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802700:	8b 45 08             	mov    0x8(%ebp),%eax
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	50                   	push   %eax
  80270c:	6a 22                	push   $0x22
  80270e:	e8 52 fc ff ff       	call   802365 <syscall>
  802713:	83 c4 18             	add    $0x18,%esp
}
  802716:	c9                   	leave  
  802717:	c3                   	ret    

00802718 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802718:	55                   	push   %ebp
  802719:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80271b:	6a 00                	push   $0x0
  80271d:	6a 00                	push   $0x0
  80271f:	6a 00                	push   $0x0
  802721:	6a 00                	push   $0x0
  802723:	6a 00                	push   $0x0
  802725:	6a 02                	push   $0x2
  802727:	e8 39 fc ff ff       	call   802365 <syscall>
  80272c:	83 c4 18             	add    $0x18,%esp
}
  80272f:	c9                   	leave  
  802730:	c3                   	ret    

00802731 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802734:	6a 00                	push   $0x0
  802736:	6a 00                	push   $0x0
  802738:	6a 00                	push   $0x0
  80273a:	6a 00                	push   $0x0
  80273c:	6a 00                	push   $0x0
  80273e:	6a 03                	push   $0x3
  802740:	e8 20 fc ff ff       	call   802365 <syscall>
  802745:	83 c4 18             	add    $0x18,%esp
}
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80274d:	6a 00                	push   $0x0
  80274f:	6a 00                	push   $0x0
  802751:	6a 00                	push   $0x0
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 04                	push   $0x4
  802759:	e8 07 fc ff ff       	call   802365 <syscall>
  80275e:	83 c4 18             	add    $0x18,%esp
}
  802761:	c9                   	leave  
  802762:	c3                   	ret    

00802763 <sys_exit_env>:


void sys_exit_env(void)
{
  802763:	55                   	push   %ebp
  802764:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802766:	6a 00                	push   $0x0
  802768:	6a 00                	push   $0x0
  80276a:	6a 00                	push   $0x0
  80276c:	6a 00                	push   $0x0
  80276e:	6a 00                	push   $0x0
  802770:	6a 23                	push   $0x23
  802772:	e8 ee fb ff ff       	call   802365 <syscall>
  802777:	83 c4 18             	add    $0x18,%esp
}
  80277a:	90                   	nop
  80277b:	c9                   	leave  
  80277c:	c3                   	ret    

0080277d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80277d:	55                   	push   %ebp
  80277e:	89 e5                	mov    %esp,%ebp
  802780:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802783:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802786:	8d 50 04             	lea    0x4(%eax),%edx
  802789:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	6a 00                	push   $0x0
  802792:	52                   	push   %edx
  802793:	50                   	push   %eax
  802794:	6a 24                	push   $0x24
  802796:	e8 ca fb ff ff       	call   802365 <syscall>
  80279b:	83 c4 18             	add    $0x18,%esp
	return result;
  80279e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027a7:	89 01                	mov    %eax,(%ecx)
  8027a9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8027ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8027af:	c9                   	leave  
  8027b0:	c2 04 00             	ret    $0x4

008027b3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8027b3:	55                   	push   %ebp
  8027b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8027b6:	6a 00                	push   $0x0
  8027b8:	6a 00                	push   $0x0
  8027ba:	ff 75 10             	pushl  0x10(%ebp)
  8027bd:	ff 75 0c             	pushl  0xc(%ebp)
  8027c0:	ff 75 08             	pushl  0x8(%ebp)
  8027c3:	6a 12                	push   $0x12
  8027c5:	e8 9b fb ff ff       	call   802365 <syscall>
  8027ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8027cd:	90                   	nop
}
  8027ce:	c9                   	leave  
  8027cf:	c3                   	ret    

008027d0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 00                	push   $0x0
  8027dd:	6a 25                	push   $0x25
  8027df:	e8 81 fb ff ff       	call   802365 <syscall>
  8027e4:	83 c4 18             	add    $0x18,%esp
}
  8027e7:	c9                   	leave  
  8027e8:	c3                   	ret    

008027e9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8027e9:	55                   	push   %ebp
  8027ea:	89 e5                	mov    %esp,%ebp
  8027ec:	83 ec 04             	sub    $0x4,%esp
  8027ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027f5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 00                	push   $0x0
  802801:	50                   	push   %eax
  802802:	6a 26                	push   $0x26
  802804:	e8 5c fb ff ff       	call   802365 <syscall>
  802809:	83 c4 18             	add    $0x18,%esp
	return ;
  80280c:	90                   	nop
}
  80280d:	c9                   	leave  
  80280e:	c3                   	ret    

0080280f <rsttst>:
void rsttst()
{
  80280f:	55                   	push   %ebp
  802810:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802812:	6a 00                	push   $0x0
  802814:	6a 00                	push   $0x0
  802816:	6a 00                	push   $0x0
  802818:	6a 00                	push   $0x0
  80281a:	6a 00                	push   $0x0
  80281c:	6a 28                	push   $0x28
  80281e:	e8 42 fb ff ff       	call   802365 <syscall>
  802823:	83 c4 18             	add    $0x18,%esp
	return ;
  802826:	90                   	nop
}
  802827:	c9                   	leave  
  802828:	c3                   	ret    

00802829 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802829:	55                   	push   %ebp
  80282a:	89 e5                	mov    %esp,%ebp
  80282c:	83 ec 04             	sub    $0x4,%esp
  80282f:	8b 45 14             	mov    0x14(%ebp),%eax
  802832:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802835:	8b 55 18             	mov    0x18(%ebp),%edx
  802838:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80283c:	52                   	push   %edx
  80283d:	50                   	push   %eax
  80283e:	ff 75 10             	pushl  0x10(%ebp)
  802841:	ff 75 0c             	pushl  0xc(%ebp)
  802844:	ff 75 08             	pushl  0x8(%ebp)
  802847:	6a 27                	push   $0x27
  802849:	e8 17 fb ff ff       	call   802365 <syscall>
  80284e:	83 c4 18             	add    $0x18,%esp
	return ;
  802851:	90                   	nop
}
  802852:	c9                   	leave  
  802853:	c3                   	ret    

00802854 <chktst>:
void chktst(uint32 n)
{
  802854:	55                   	push   %ebp
  802855:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802857:	6a 00                	push   $0x0
  802859:	6a 00                	push   $0x0
  80285b:	6a 00                	push   $0x0
  80285d:	6a 00                	push   $0x0
  80285f:	ff 75 08             	pushl  0x8(%ebp)
  802862:	6a 29                	push   $0x29
  802864:	e8 fc fa ff ff       	call   802365 <syscall>
  802869:	83 c4 18             	add    $0x18,%esp
	return ;
  80286c:	90                   	nop
}
  80286d:	c9                   	leave  
  80286e:	c3                   	ret    

0080286f <inctst>:

void inctst()
{
  80286f:	55                   	push   %ebp
  802870:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802872:	6a 00                	push   $0x0
  802874:	6a 00                	push   $0x0
  802876:	6a 00                	push   $0x0
  802878:	6a 00                	push   $0x0
  80287a:	6a 00                	push   $0x0
  80287c:	6a 2a                	push   $0x2a
  80287e:	e8 e2 fa ff ff       	call   802365 <syscall>
  802883:	83 c4 18             	add    $0x18,%esp
	return ;
  802886:	90                   	nop
}
  802887:	c9                   	leave  
  802888:	c3                   	ret    

00802889 <gettst>:
uint32 gettst()
{
  802889:	55                   	push   %ebp
  80288a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80288c:	6a 00                	push   $0x0
  80288e:	6a 00                	push   $0x0
  802890:	6a 00                	push   $0x0
  802892:	6a 00                	push   $0x0
  802894:	6a 00                	push   $0x0
  802896:	6a 2b                	push   $0x2b
  802898:	e8 c8 fa ff ff       	call   802365 <syscall>
  80289d:	83 c4 18             	add    $0x18,%esp
}
  8028a0:	c9                   	leave  
  8028a1:	c3                   	ret    

008028a2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8028a2:	55                   	push   %ebp
  8028a3:	89 e5                	mov    %esp,%ebp
  8028a5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028a8:	6a 00                	push   $0x0
  8028aa:	6a 00                	push   $0x0
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 00                	push   $0x0
  8028b2:	6a 2c                	push   $0x2c
  8028b4:	e8 ac fa ff ff       	call   802365 <syscall>
  8028b9:	83 c4 18             	add    $0x18,%esp
  8028bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8028bf:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8028c3:	75 07                	jne    8028cc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8028c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8028ca:	eb 05                	jmp    8028d1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8028cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028d1:	c9                   	leave  
  8028d2:	c3                   	ret    

008028d3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8028d3:	55                   	push   %ebp
  8028d4:	89 e5                	mov    %esp,%ebp
  8028d6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028d9:	6a 00                	push   $0x0
  8028db:	6a 00                	push   $0x0
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 00                	push   $0x0
  8028e1:	6a 00                	push   $0x0
  8028e3:	6a 2c                	push   $0x2c
  8028e5:	e8 7b fa ff ff       	call   802365 <syscall>
  8028ea:	83 c4 18             	add    $0x18,%esp
  8028ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8028f0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8028f4:	75 07                	jne    8028fd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8028f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028fb:	eb 05                	jmp    802902 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8028fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802902:	c9                   	leave  
  802903:	c3                   	ret    

00802904 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802904:	55                   	push   %ebp
  802905:	89 e5                	mov    %esp,%ebp
  802907:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80290a:	6a 00                	push   $0x0
  80290c:	6a 00                	push   $0x0
  80290e:	6a 00                	push   $0x0
  802910:	6a 00                	push   $0x0
  802912:	6a 00                	push   $0x0
  802914:	6a 2c                	push   $0x2c
  802916:	e8 4a fa ff ff       	call   802365 <syscall>
  80291b:	83 c4 18             	add    $0x18,%esp
  80291e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802921:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802925:	75 07                	jne    80292e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802927:	b8 01 00 00 00       	mov    $0x1,%eax
  80292c:	eb 05                	jmp    802933 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80292e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802933:	c9                   	leave  
  802934:	c3                   	ret    

00802935 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
  802938:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80293b:	6a 00                	push   $0x0
  80293d:	6a 00                	push   $0x0
  80293f:	6a 00                	push   $0x0
  802941:	6a 00                	push   $0x0
  802943:	6a 00                	push   $0x0
  802945:	6a 2c                	push   $0x2c
  802947:	e8 19 fa ff ff       	call   802365 <syscall>
  80294c:	83 c4 18             	add    $0x18,%esp
  80294f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802952:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802956:	75 07                	jne    80295f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802958:	b8 01 00 00 00       	mov    $0x1,%eax
  80295d:	eb 05                	jmp    802964 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80295f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802964:	c9                   	leave  
  802965:	c3                   	ret    

00802966 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802966:	55                   	push   %ebp
  802967:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802969:	6a 00                	push   $0x0
  80296b:	6a 00                	push   $0x0
  80296d:	6a 00                	push   $0x0
  80296f:	6a 00                	push   $0x0
  802971:	ff 75 08             	pushl  0x8(%ebp)
  802974:	6a 2d                	push   $0x2d
  802976:	e8 ea f9 ff ff       	call   802365 <syscall>
  80297b:	83 c4 18             	add    $0x18,%esp
	return ;
  80297e:	90                   	nop
}
  80297f:	c9                   	leave  
  802980:	c3                   	ret    

00802981 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802981:	55                   	push   %ebp
  802982:	89 e5                	mov    %esp,%ebp
  802984:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802985:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802988:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80298b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80298e:	8b 45 08             	mov    0x8(%ebp),%eax
  802991:	6a 00                	push   $0x0
  802993:	53                   	push   %ebx
  802994:	51                   	push   %ecx
  802995:	52                   	push   %edx
  802996:	50                   	push   %eax
  802997:	6a 2e                	push   $0x2e
  802999:	e8 c7 f9 ff ff       	call   802365 <syscall>
  80299e:	83 c4 18             	add    $0x18,%esp
}
  8029a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8029a4:	c9                   	leave  
  8029a5:	c3                   	ret    

008029a6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8029a6:	55                   	push   %ebp
  8029a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8029a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8029af:	6a 00                	push   $0x0
  8029b1:	6a 00                	push   $0x0
  8029b3:	6a 00                	push   $0x0
  8029b5:	52                   	push   %edx
  8029b6:	50                   	push   %eax
  8029b7:	6a 2f                	push   $0x2f
  8029b9:	e8 a7 f9 ff ff       	call   802365 <syscall>
  8029be:	83 c4 18             	add    $0x18,%esp
}
  8029c1:	c9                   	leave  
  8029c2:	c3                   	ret    

008029c3 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8029c3:	55                   	push   %ebp
  8029c4:	89 e5                	mov    %esp,%ebp
  8029c6:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8029c9:	83 ec 0c             	sub    $0xc,%esp
  8029cc:	68 c4 4a 80 00       	push   $0x804ac4
  8029d1:	e8 46 e8 ff ff       	call   80121c <cprintf>
  8029d6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8029d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8029e0:	83 ec 0c             	sub    $0xc,%esp
  8029e3:	68 f0 4a 80 00       	push   $0x804af0
  8029e8:	e8 2f e8 ff ff       	call   80121c <cprintf>
  8029ed:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8029f0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029f4:	a1 38 51 80 00       	mov    0x805138,%eax
  8029f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029fc:	eb 56                	jmp    802a54 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8029fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a02:	74 1c                	je     802a20 <print_mem_block_lists+0x5d>
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 50 08             	mov    0x8(%eax),%edx
  802a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0d:	8b 48 08             	mov    0x8(%eax),%ecx
  802a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a13:	8b 40 0c             	mov    0xc(%eax),%eax
  802a16:	01 c8                	add    %ecx,%eax
  802a18:	39 c2                	cmp    %eax,%edx
  802a1a:	73 04                	jae    802a20 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802a1c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 50 08             	mov    0x8(%eax),%edx
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2c:	01 c2                	add    %eax,%edx
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	8b 40 08             	mov    0x8(%eax),%eax
  802a34:	83 ec 04             	sub    $0x4,%esp
  802a37:	52                   	push   %edx
  802a38:	50                   	push   %eax
  802a39:	68 05 4b 80 00       	push   $0x804b05
  802a3e:	e8 d9 e7 ff ff       	call   80121c <cprintf>
  802a43:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a4c:	a1 40 51 80 00       	mov    0x805140,%eax
  802a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a58:	74 07                	je     802a61 <print_mem_block_lists+0x9e>
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 00                	mov    (%eax),%eax
  802a5f:	eb 05                	jmp    802a66 <print_mem_block_lists+0xa3>
  802a61:	b8 00 00 00 00       	mov    $0x0,%eax
  802a66:	a3 40 51 80 00       	mov    %eax,0x805140
  802a6b:	a1 40 51 80 00       	mov    0x805140,%eax
  802a70:	85 c0                	test   %eax,%eax
  802a72:	75 8a                	jne    8029fe <print_mem_block_lists+0x3b>
  802a74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a78:	75 84                	jne    8029fe <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802a7a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a7e:	75 10                	jne    802a90 <print_mem_block_lists+0xcd>
  802a80:	83 ec 0c             	sub    $0xc,%esp
  802a83:	68 14 4b 80 00       	push   $0x804b14
  802a88:	e8 8f e7 ff ff       	call   80121c <cprintf>
  802a8d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802a90:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802a97:	83 ec 0c             	sub    $0xc,%esp
  802a9a:	68 38 4b 80 00       	push   $0x804b38
  802a9f:	e8 78 e7 ff ff       	call   80121c <cprintf>
  802aa4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802aa7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802aab:	a1 40 50 80 00       	mov    0x805040,%eax
  802ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab3:	eb 56                	jmp    802b0b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802ab5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ab9:	74 1c                	je     802ad7 <print_mem_block_lists+0x114>
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	8b 50 08             	mov    0x8(%eax),%edx
  802ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac4:	8b 48 08             	mov    0x8(%eax),%ecx
  802ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aca:	8b 40 0c             	mov    0xc(%eax),%eax
  802acd:	01 c8                	add    %ecx,%eax
  802acf:	39 c2                	cmp    %eax,%edx
  802ad1:	73 04                	jae    802ad7 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802ad3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 50 08             	mov    0x8(%eax),%edx
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae3:	01 c2                	add    %eax,%edx
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 40 08             	mov    0x8(%eax),%eax
  802aeb:	83 ec 04             	sub    $0x4,%esp
  802aee:	52                   	push   %edx
  802aef:	50                   	push   %eax
  802af0:	68 05 4b 80 00       	push   $0x804b05
  802af5:	e8 22 e7 ff ff       	call   80121c <cprintf>
  802afa:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802b03:	a1 48 50 80 00       	mov    0x805048,%eax
  802b08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0f:	74 07                	je     802b18 <print_mem_block_lists+0x155>
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	eb 05                	jmp    802b1d <print_mem_block_lists+0x15a>
  802b18:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1d:	a3 48 50 80 00       	mov    %eax,0x805048
  802b22:	a1 48 50 80 00       	mov    0x805048,%eax
  802b27:	85 c0                	test   %eax,%eax
  802b29:	75 8a                	jne    802ab5 <print_mem_block_lists+0xf2>
  802b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2f:	75 84                	jne    802ab5 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802b31:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802b35:	75 10                	jne    802b47 <print_mem_block_lists+0x184>
  802b37:	83 ec 0c             	sub    $0xc,%esp
  802b3a:	68 50 4b 80 00       	push   $0x804b50
  802b3f:	e8 d8 e6 ff ff       	call   80121c <cprintf>
  802b44:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802b47:	83 ec 0c             	sub    $0xc,%esp
  802b4a:	68 c4 4a 80 00       	push   $0x804ac4
  802b4f:	e8 c8 e6 ff ff       	call   80121c <cprintf>
  802b54:	83 c4 10             	add    $0x10,%esp

}
  802b57:	90                   	nop
  802b58:	c9                   	leave  
  802b59:	c3                   	ret    

00802b5a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802b5a:	55                   	push   %ebp
  802b5b:	89 e5                	mov    %esp,%ebp
  802b5d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802b60:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802b67:	00 00 00 
  802b6a:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802b71:	00 00 00 
  802b74:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802b7b:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802b7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b85:	e9 9e 00 00 00       	jmp    802c28 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802b8a:	a1 50 50 80 00       	mov    0x805050,%eax
  802b8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b92:	c1 e2 04             	shl    $0x4,%edx
  802b95:	01 d0                	add    %edx,%eax
  802b97:	85 c0                	test   %eax,%eax
  802b99:	75 14                	jne    802baf <initialize_MemBlocksList+0x55>
  802b9b:	83 ec 04             	sub    $0x4,%esp
  802b9e:	68 78 4b 80 00       	push   $0x804b78
  802ba3:	6a 46                	push   $0x46
  802ba5:	68 9b 4b 80 00       	push   $0x804b9b
  802baa:	e8 b9 e3 ff ff       	call   800f68 <_panic>
  802baf:	a1 50 50 80 00       	mov    0x805050,%eax
  802bb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb7:	c1 e2 04             	shl    $0x4,%edx
  802bba:	01 d0                	add    %edx,%eax
  802bbc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802bc2:	89 10                	mov    %edx,(%eax)
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	85 c0                	test   %eax,%eax
  802bc8:	74 18                	je     802be2 <initialize_MemBlocksList+0x88>
  802bca:	a1 48 51 80 00       	mov    0x805148,%eax
  802bcf:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802bd5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802bd8:	c1 e1 04             	shl    $0x4,%ecx
  802bdb:	01 ca                	add    %ecx,%edx
  802bdd:	89 50 04             	mov    %edx,0x4(%eax)
  802be0:	eb 12                	jmp    802bf4 <initialize_MemBlocksList+0x9a>
  802be2:	a1 50 50 80 00       	mov    0x805050,%eax
  802be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bea:	c1 e2 04             	shl    $0x4,%edx
  802bed:	01 d0                	add    %edx,%eax
  802bef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bf4:	a1 50 50 80 00       	mov    0x805050,%eax
  802bf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfc:	c1 e2 04             	shl    $0x4,%edx
  802bff:	01 d0                	add    %edx,%eax
  802c01:	a3 48 51 80 00       	mov    %eax,0x805148
  802c06:	a1 50 50 80 00       	mov    0x805050,%eax
  802c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0e:	c1 e2 04             	shl    $0x4,%edx
  802c11:	01 d0                	add    %edx,%eax
  802c13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1a:	a1 54 51 80 00       	mov    0x805154,%eax
  802c1f:	40                   	inc    %eax
  802c20:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802c25:	ff 45 f4             	incl   -0xc(%ebp)
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c2e:	0f 82 56 ff ff ff    	jb     802b8a <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802c34:	90                   	nop
  802c35:	c9                   	leave  
  802c36:	c3                   	ret    

00802c37 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802c37:	55                   	push   %ebp
  802c38:	89 e5                	mov    %esp,%ebp
  802c3a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	8b 00                	mov    (%eax),%eax
  802c42:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c45:	eb 19                	jmp    802c60 <find_block+0x29>
	{
		if(va==point->sva)
  802c47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c4a:	8b 40 08             	mov    0x8(%eax),%eax
  802c4d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c50:	75 05                	jne    802c57 <find_block+0x20>
		   return point;
  802c52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c55:	eb 36                	jmp    802c8d <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	8b 40 08             	mov    0x8(%eax),%eax
  802c5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c60:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c64:	74 07                	je     802c6d <find_block+0x36>
  802c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c69:	8b 00                	mov    (%eax),%eax
  802c6b:	eb 05                	jmp    802c72 <find_block+0x3b>
  802c6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c72:	8b 55 08             	mov    0x8(%ebp),%edx
  802c75:	89 42 08             	mov    %eax,0x8(%edx)
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	8b 40 08             	mov    0x8(%eax),%eax
  802c7e:	85 c0                	test   %eax,%eax
  802c80:	75 c5                	jne    802c47 <find_block+0x10>
  802c82:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c86:	75 bf                	jne    802c47 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802c88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c8d:	c9                   	leave  
  802c8e:	c3                   	ret    

00802c8f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802c8f:	55                   	push   %ebp
  802c90:	89 e5                	mov    %esp,%ebp
  802c92:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802c95:	a1 40 50 80 00       	mov    0x805040,%eax
  802c9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802c9d:	a1 44 50 80 00       	mov    0x805044,%eax
  802ca2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802cab:	74 24                	je     802cd1 <insert_sorted_allocList+0x42>
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	8b 50 08             	mov    0x8(%eax),%edx
  802cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb6:	8b 40 08             	mov    0x8(%eax),%eax
  802cb9:	39 c2                	cmp    %eax,%edx
  802cbb:	76 14                	jbe    802cd1 <insert_sorted_allocList+0x42>
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	8b 50 08             	mov    0x8(%eax),%edx
  802cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc6:	8b 40 08             	mov    0x8(%eax),%eax
  802cc9:	39 c2                	cmp    %eax,%edx
  802ccb:	0f 82 60 01 00 00    	jb     802e31 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802cd1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cd5:	75 65                	jne    802d3c <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802cd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cdb:	75 14                	jne    802cf1 <insert_sorted_allocList+0x62>
  802cdd:	83 ec 04             	sub    $0x4,%esp
  802ce0:	68 78 4b 80 00       	push   $0x804b78
  802ce5:	6a 6b                	push   $0x6b
  802ce7:	68 9b 4b 80 00       	push   $0x804b9b
  802cec:	e8 77 e2 ff ff       	call   800f68 <_panic>
  802cf1:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfa:	89 10                	mov    %edx,(%eax)
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	8b 00                	mov    (%eax),%eax
  802d01:	85 c0                	test   %eax,%eax
  802d03:	74 0d                	je     802d12 <insert_sorted_allocList+0x83>
  802d05:	a1 40 50 80 00       	mov    0x805040,%eax
  802d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0d:	89 50 04             	mov    %edx,0x4(%eax)
  802d10:	eb 08                	jmp    802d1a <insert_sorted_allocList+0x8b>
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	a3 44 50 80 00       	mov    %eax,0x805044
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	a3 40 50 80 00       	mov    %eax,0x805040
  802d22:	8b 45 08             	mov    0x8(%ebp),%eax
  802d25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d31:	40                   	inc    %eax
  802d32:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802d37:	e9 dc 01 00 00       	jmp    802f18 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	8b 50 08             	mov    0x8(%eax),%edx
  802d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d45:	8b 40 08             	mov    0x8(%eax),%eax
  802d48:	39 c2                	cmp    %eax,%edx
  802d4a:	77 6c                	ja     802db8 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802d4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d50:	74 06                	je     802d58 <insert_sorted_allocList+0xc9>
  802d52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d56:	75 14                	jne    802d6c <insert_sorted_allocList+0xdd>
  802d58:	83 ec 04             	sub    $0x4,%esp
  802d5b:	68 b4 4b 80 00       	push   $0x804bb4
  802d60:	6a 6f                	push   $0x6f
  802d62:	68 9b 4b 80 00       	push   $0x804b9b
  802d67:	e8 fc e1 ff ff       	call   800f68 <_panic>
  802d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6f:	8b 50 04             	mov    0x4(%eax),%edx
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	89 50 04             	mov    %edx,0x4(%eax)
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d7e:	89 10                	mov    %edx,(%eax)
  802d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d83:	8b 40 04             	mov    0x4(%eax),%eax
  802d86:	85 c0                	test   %eax,%eax
  802d88:	74 0d                	je     802d97 <insert_sorted_allocList+0x108>
  802d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8d:	8b 40 04             	mov    0x4(%eax),%eax
  802d90:	8b 55 08             	mov    0x8(%ebp),%edx
  802d93:	89 10                	mov    %edx,(%eax)
  802d95:	eb 08                	jmp    802d9f <insert_sorted_allocList+0x110>
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	a3 40 50 80 00       	mov    %eax,0x805040
  802d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da2:	8b 55 08             	mov    0x8(%ebp),%edx
  802da5:	89 50 04             	mov    %edx,0x4(%eax)
  802da8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802dad:	40                   	inc    %eax
  802dae:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802db3:	e9 60 01 00 00       	jmp    802f18 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	8b 50 08             	mov    0x8(%eax),%edx
  802dbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc1:	8b 40 08             	mov    0x8(%eax),%eax
  802dc4:	39 c2                	cmp    %eax,%edx
  802dc6:	0f 82 4c 01 00 00    	jb     802f18 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802dcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd0:	75 14                	jne    802de6 <insert_sorted_allocList+0x157>
  802dd2:	83 ec 04             	sub    $0x4,%esp
  802dd5:	68 ec 4b 80 00       	push   $0x804bec
  802dda:	6a 73                	push   $0x73
  802ddc:	68 9b 4b 80 00       	push   $0x804b9b
  802de1:	e8 82 e1 ff ff       	call   800f68 <_panic>
  802de6:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	89 50 04             	mov    %edx,0x4(%eax)
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	8b 40 04             	mov    0x4(%eax),%eax
  802df8:	85 c0                	test   %eax,%eax
  802dfa:	74 0c                	je     802e08 <insert_sorted_allocList+0x179>
  802dfc:	a1 44 50 80 00       	mov    0x805044,%eax
  802e01:	8b 55 08             	mov    0x8(%ebp),%edx
  802e04:	89 10                	mov    %edx,(%eax)
  802e06:	eb 08                	jmp    802e10 <insert_sorted_allocList+0x181>
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	a3 40 50 80 00       	mov    %eax,0x805040
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	a3 44 50 80 00       	mov    %eax,0x805044
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e21:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e26:	40                   	inc    %eax
  802e27:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802e2c:	e9 e7 00 00 00       	jmp    802f18 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802e37:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802e3e:	a1 40 50 80 00       	mov    0x805040,%eax
  802e43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e46:	e9 9d 00 00 00       	jmp    802ee8 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 00                	mov    (%eax),%eax
  802e50:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802e53:	8b 45 08             	mov    0x8(%ebp),%eax
  802e56:	8b 50 08             	mov    0x8(%eax),%edx
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	8b 40 08             	mov    0x8(%eax),%eax
  802e5f:	39 c2                	cmp    %eax,%edx
  802e61:	76 7d                	jbe    802ee0 <insert_sorted_allocList+0x251>
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	8b 50 08             	mov    0x8(%eax),%edx
  802e69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e6c:	8b 40 08             	mov    0x8(%eax),%eax
  802e6f:	39 c2                	cmp    %eax,%edx
  802e71:	73 6d                	jae    802ee0 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802e73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e77:	74 06                	je     802e7f <insert_sorted_allocList+0x1f0>
  802e79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7d:	75 14                	jne    802e93 <insert_sorted_allocList+0x204>
  802e7f:	83 ec 04             	sub    $0x4,%esp
  802e82:	68 10 4c 80 00       	push   $0x804c10
  802e87:	6a 7f                	push   $0x7f
  802e89:	68 9b 4b 80 00       	push   $0x804b9b
  802e8e:	e8 d5 e0 ff ff       	call   800f68 <_panic>
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	8b 10                	mov    (%eax),%edx
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	89 10                	mov    %edx,(%eax)
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	85 c0                	test   %eax,%eax
  802ea4:	74 0b                	je     802eb1 <insert_sorted_allocList+0x222>
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	8b 55 08             	mov    0x8(%ebp),%edx
  802eae:	89 50 04             	mov    %edx,0x4(%eax)
  802eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb7:	89 10                	mov    %edx,(%eax)
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebf:	89 50 04             	mov    %edx,0x4(%eax)
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	8b 00                	mov    (%eax),%eax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	75 08                	jne    802ed3 <insert_sorted_allocList+0x244>
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	a3 44 50 80 00       	mov    %eax,0x805044
  802ed3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ed8:	40                   	inc    %eax
  802ed9:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802ede:	eb 39                	jmp    802f19 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802ee0:	a1 48 50 80 00       	mov    0x805048,%eax
  802ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ee8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eec:	74 07                	je     802ef5 <insert_sorted_allocList+0x266>
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 00                	mov    (%eax),%eax
  802ef3:	eb 05                	jmp    802efa <insert_sorted_allocList+0x26b>
  802ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  802efa:	a3 48 50 80 00       	mov    %eax,0x805048
  802eff:	a1 48 50 80 00       	mov    0x805048,%eax
  802f04:	85 c0                	test   %eax,%eax
  802f06:	0f 85 3f ff ff ff    	jne    802e4b <insert_sorted_allocList+0x1bc>
  802f0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f10:	0f 85 35 ff ff ff    	jne    802e4b <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802f16:	eb 01                	jmp    802f19 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802f18:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802f19:	90                   	nop
  802f1a:	c9                   	leave  
  802f1b:	c3                   	ret    

00802f1c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802f1c:	55                   	push   %ebp
  802f1d:	89 e5                	mov    %esp,%ebp
  802f1f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802f22:	a1 38 51 80 00       	mov    0x805138,%eax
  802f27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2a:	e9 85 01 00 00       	jmp    8030b4 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	8b 40 0c             	mov    0xc(%eax),%eax
  802f35:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f38:	0f 82 6e 01 00 00    	jb     8030ac <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	8b 40 0c             	mov    0xc(%eax),%eax
  802f44:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f47:	0f 85 8a 00 00 00    	jne    802fd7 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802f4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f51:	75 17                	jne    802f6a <alloc_block_FF+0x4e>
  802f53:	83 ec 04             	sub    $0x4,%esp
  802f56:	68 44 4c 80 00       	push   $0x804c44
  802f5b:	68 93 00 00 00       	push   $0x93
  802f60:	68 9b 4b 80 00       	push   $0x804b9b
  802f65:	e8 fe df ff ff       	call   800f68 <_panic>
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	8b 00                	mov    (%eax),%eax
  802f6f:	85 c0                	test   %eax,%eax
  802f71:	74 10                	je     802f83 <alloc_block_FF+0x67>
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	8b 00                	mov    (%eax),%eax
  802f78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f7b:	8b 52 04             	mov    0x4(%edx),%edx
  802f7e:	89 50 04             	mov    %edx,0x4(%eax)
  802f81:	eb 0b                	jmp    802f8e <alloc_block_FF+0x72>
  802f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f86:	8b 40 04             	mov    0x4(%eax),%eax
  802f89:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f91:	8b 40 04             	mov    0x4(%eax),%eax
  802f94:	85 c0                	test   %eax,%eax
  802f96:	74 0f                	je     802fa7 <alloc_block_FF+0x8b>
  802f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9b:	8b 40 04             	mov    0x4(%eax),%eax
  802f9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fa1:	8b 12                	mov    (%edx),%edx
  802fa3:	89 10                	mov    %edx,(%eax)
  802fa5:	eb 0a                	jmp    802fb1 <alloc_block_FF+0x95>
  802fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faa:	8b 00                	mov    (%eax),%eax
  802fac:	a3 38 51 80 00       	mov    %eax,0x805138
  802fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc4:	a1 44 51 80 00       	mov    0x805144,%eax
  802fc9:	48                   	dec    %eax
  802fca:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd2:	e9 10 01 00 00       	jmp    8030e7 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fda:	8b 40 0c             	mov    0xc(%eax),%eax
  802fdd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fe0:	0f 86 c6 00 00 00    	jbe    8030ac <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fe6:	a1 48 51 80 00       	mov    0x805148,%eax
  802feb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff1:	8b 50 08             	mov    0x8(%eax),%edx
  802ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff7:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffd:	8b 55 08             	mov    0x8(%ebp),%edx
  803000:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803003:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803007:	75 17                	jne    803020 <alloc_block_FF+0x104>
  803009:	83 ec 04             	sub    $0x4,%esp
  80300c:	68 44 4c 80 00       	push   $0x804c44
  803011:	68 9b 00 00 00       	push   $0x9b
  803016:	68 9b 4b 80 00       	push   $0x804b9b
  80301b:	e8 48 df ff ff       	call   800f68 <_panic>
  803020:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803023:	8b 00                	mov    (%eax),%eax
  803025:	85 c0                	test   %eax,%eax
  803027:	74 10                	je     803039 <alloc_block_FF+0x11d>
  803029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302c:	8b 00                	mov    (%eax),%eax
  80302e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803031:	8b 52 04             	mov    0x4(%edx),%edx
  803034:	89 50 04             	mov    %edx,0x4(%eax)
  803037:	eb 0b                	jmp    803044 <alloc_block_FF+0x128>
  803039:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303c:	8b 40 04             	mov    0x4(%eax),%eax
  80303f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803047:	8b 40 04             	mov    0x4(%eax),%eax
  80304a:	85 c0                	test   %eax,%eax
  80304c:	74 0f                	je     80305d <alloc_block_FF+0x141>
  80304e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803051:	8b 40 04             	mov    0x4(%eax),%eax
  803054:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803057:	8b 12                	mov    (%edx),%edx
  803059:	89 10                	mov    %edx,(%eax)
  80305b:	eb 0a                	jmp    803067 <alloc_block_FF+0x14b>
  80305d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803060:	8b 00                	mov    (%eax),%eax
  803062:	a3 48 51 80 00       	mov    %eax,0x805148
  803067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803070:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803073:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80307a:	a1 54 51 80 00       	mov    0x805154,%eax
  80307f:	48                   	dec    %eax
  803080:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  803085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803088:	8b 50 08             	mov    0x8(%eax),%edx
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	01 c2                	add    %eax,%edx
  803090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803093:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	8b 40 0c             	mov    0xc(%eax),%eax
  80309c:	2b 45 08             	sub    0x8(%ebp),%eax
  80309f:	89 c2                	mov    %eax,%edx
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8030a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030aa:	eb 3b                	jmp    8030e7 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8030ac:	a1 40 51 80 00       	mov    0x805140,%eax
  8030b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b8:	74 07                	je     8030c1 <alloc_block_FF+0x1a5>
  8030ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bd:	8b 00                	mov    (%eax),%eax
  8030bf:	eb 05                	jmp    8030c6 <alloc_block_FF+0x1aa>
  8030c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c6:	a3 40 51 80 00       	mov    %eax,0x805140
  8030cb:	a1 40 51 80 00       	mov    0x805140,%eax
  8030d0:	85 c0                	test   %eax,%eax
  8030d2:	0f 85 57 fe ff ff    	jne    802f2f <alloc_block_FF+0x13>
  8030d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030dc:	0f 85 4d fe ff ff    	jne    802f2f <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8030e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030e7:	c9                   	leave  
  8030e8:	c3                   	ret    

008030e9 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8030e9:	55                   	push   %ebp
  8030ea:	89 e5                	mov    %esp,%ebp
  8030ec:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8030ef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8030f6:	a1 38 51 80 00       	mov    0x805138,%eax
  8030fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030fe:	e9 df 00 00 00       	jmp    8031e2 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  803103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803106:	8b 40 0c             	mov    0xc(%eax),%eax
  803109:	3b 45 08             	cmp    0x8(%ebp),%eax
  80310c:	0f 82 c8 00 00 00    	jb     8031da <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  803112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803115:	8b 40 0c             	mov    0xc(%eax),%eax
  803118:	3b 45 08             	cmp    0x8(%ebp),%eax
  80311b:	0f 85 8a 00 00 00    	jne    8031ab <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  803121:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803125:	75 17                	jne    80313e <alloc_block_BF+0x55>
  803127:	83 ec 04             	sub    $0x4,%esp
  80312a:	68 44 4c 80 00       	push   $0x804c44
  80312f:	68 b7 00 00 00       	push   $0xb7
  803134:	68 9b 4b 80 00       	push   $0x804b9b
  803139:	e8 2a de ff ff       	call   800f68 <_panic>
  80313e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803141:	8b 00                	mov    (%eax),%eax
  803143:	85 c0                	test   %eax,%eax
  803145:	74 10                	je     803157 <alloc_block_BF+0x6e>
  803147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314a:	8b 00                	mov    (%eax),%eax
  80314c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80314f:	8b 52 04             	mov    0x4(%edx),%edx
  803152:	89 50 04             	mov    %edx,0x4(%eax)
  803155:	eb 0b                	jmp    803162 <alloc_block_BF+0x79>
  803157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315a:	8b 40 04             	mov    0x4(%eax),%eax
  80315d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803165:	8b 40 04             	mov    0x4(%eax),%eax
  803168:	85 c0                	test   %eax,%eax
  80316a:	74 0f                	je     80317b <alloc_block_BF+0x92>
  80316c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316f:	8b 40 04             	mov    0x4(%eax),%eax
  803172:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803175:	8b 12                	mov    (%edx),%edx
  803177:	89 10                	mov    %edx,(%eax)
  803179:	eb 0a                	jmp    803185 <alloc_block_BF+0x9c>
  80317b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317e:	8b 00                	mov    (%eax),%eax
  803180:	a3 38 51 80 00       	mov    %eax,0x805138
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803191:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803198:	a1 44 51 80 00       	mov    0x805144,%eax
  80319d:	48                   	dec    %eax
  80319e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	e9 4d 01 00 00       	jmp    8032f8 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8031ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031b4:	76 24                	jbe    8031da <alloc_block_BF+0xf1>
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031bf:	73 19                	jae    8031da <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8031c1:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8031d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d4:	8b 40 08             	mov    0x8(%eax),%eax
  8031d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8031da:	a1 40 51 80 00       	mov    0x805140,%eax
  8031df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e6:	74 07                	je     8031ef <alloc_block_BF+0x106>
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	8b 00                	mov    (%eax),%eax
  8031ed:	eb 05                	jmp    8031f4 <alloc_block_BF+0x10b>
  8031ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f4:	a3 40 51 80 00       	mov    %eax,0x805140
  8031f9:	a1 40 51 80 00       	mov    0x805140,%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	0f 85 fd fe ff ff    	jne    803103 <alloc_block_BF+0x1a>
  803206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80320a:	0f 85 f3 fe ff ff    	jne    803103 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  803210:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803214:	0f 84 d9 00 00 00    	je     8032f3 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80321a:	a1 48 51 80 00       	mov    0x805148,%eax
  80321f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803225:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803228:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80322b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80322e:	8b 55 08             	mov    0x8(%ebp),%edx
  803231:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803234:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803238:	75 17                	jne    803251 <alloc_block_BF+0x168>
  80323a:	83 ec 04             	sub    $0x4,%esp
  80323d:	68 44 4c 80 00       	push   $0x804c44
  803242:	68 c7 00 00 00       	push   $0xc7
  803247:	68 9b 4b 80 00       	push   $0x804b9b
  80324c:	e8 17 dd ff ff       	call   800f68 <_panic>
  803251:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803254:	8b 00                	mov    (%eax),%eax
  803256:	85 c0                	test   %eax,%eax
  803258:	74 10                	je     80326a <alloc_block_BF+0x181>
  80325a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80325d:	8b 00                	mov    (%eax),%eax
  80325f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803262:	8b 52 04             	mov    0x4(%edx),%edx
  803265:	89 50 04             	mov    %edx,0x4(%eax)
  803268:	eb 0b                	jmp    803275 <alloc_block_BF+0x18c>
  80326a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80326d:	8b 40 04             	mov    0x4(%eax),%eax
  803270:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803275:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803278:	8b 40 04             	mov    0x4(%eax),%eax
  80327b:	85 c0                	test   %eax,%eax
  80327d:	74 0f                	je     80328e <alloc_block_BF+0x1a5>
  80327f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803282:	8b 40 04             	mov    0x4(%eax),%eax
  803285:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803288:	8b 12                	mov    (%edx),%edx
  80328a:	89 10                	mov    %edx,(%eax)
  80328c:	eb 0a                	jmp    803298 <alloc_block_BF+0x1af>
  80328e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803291:	8b 00                	mov    (%eax),%eax
  803293:	a3 48 51 80 00       	mov    %eax,0x805148
  803298:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8032b0:	48                   	dec    %eax
  8032b1:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8032b6:	83 ec 08             	sub    $0x8,%esp
  8032b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8032bc:	68 38 51 80 00       	push   $0x805138
  8032c1:	e8 71 f9 ff ff       	call   802c37 <find_block>
  8032c6:	83 c4 10             	add    $0x10,%esp
  8032c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8032cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032cf:	8b 50 08             	mov    0x8(%eax),%edx
  8032d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d5:	01 c2                	add    %eax,%edx
  8032d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032da:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8032dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e3:	2b 45 08             	sub    0x8(%ebp),%eax
  8032e6:	89 c2                	mov    %eax,%edx
  8032e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032eb:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8032ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f1:	eb 05                	jmp    8032f8 <alloc_block_BF+0x20f>
	}
	return NULL;
  8032f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032f8:	c9                   	leave  
  8032f9:	c3                   	ret    

008032fa <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8032fa:	55                   	push   %ebp
  8032fb:	89 e5                	mov    %esp,%ebp
  8032fd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803300:	a1 28 50 80 00       	mov    0x805028,%eax
  803305:	85 c0                	test   %eax,%eax
  803307:	0f 85 de 01 00 00    	jne    8034eb <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80330d:	a1 38 51 80 00       	mov    0x805138,%eax
  803312:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803315:	e9 9e 01 00 00       	jmp    8034b8 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331d:	8b 40 0c             	mov    0xc(%eax),%eax
  803320:	3b 45 08             	cmp    0x8(%ebp),%eax
  803323:	0f 82 87 01 00 00    	jb     8034b0 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332c:	8b 40 0c             	mov    0xc(%eax),%eax
  80332f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803332:	0f 85 95 00 00 00    	jne    8033cd <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80333c:	75 17                	jne    803355 <alloc_block_NF+0x5b>
  80333e:	83 ec 04             	sub    $0x4,%esp
  803341:	68 44 4c 80 00       	push   $0x804c44
  803346:	68 e0 00 00 00       	push   $0xe0
  80334b:	68 9b 4b 80 00       	push   $0x804b9b
  803350:	e8 13 dc ff ff       	call   800f68 <_panic>
  803355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803358:	8b 00                	mov    (%eax),%eax
  80335a:	85 c0                	test   %eax,%eax
  80335c:	74 10                	je     80336e <alloc_block_NF+0x74>
  80335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803361:	8b 00                	mov    (%eax),%eax
  803363:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803366:	8b 52 04             	mov    0x4(%edx),%edx
  803369:	89 50 04             	mov    %edx,0x4(%eax)
  80336c:	eb 0b                	jmp    803379 <alloc_block_NF+0x7f>
  80336e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803371:	8b 40 04             	mov    0x4(%eax),%eax
  803374:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337c:	8b 40 04             	mov    0x4(%eax),%eax
  80337f:	85 c0                	test   %eax,%eax
  803381:	74 0f                	je     803392 <alloc_block_NF+0x98>
  803383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803386:	8b 40 04             	mov    0x4(%eax),%eax
  803389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80338c:	8b 12                	mov    (%edx),%edx
  80338e:	89 10                	mov    %edx,(%eax)
  803390:	eb 0a                	jmp    80339c <alloc_block_NF+0xa2>
  803392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803395:	8b 00                	mov    (%eax),%eax
  803397:	a3 38 51 80 00       	mov    %eax,0x805138
  80339c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033af:	a1 44 51 80 00       	mov    0x805144,%eax
  8033b4:	48                   	dec    %eax
  8033b5:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bd:	8b 40 08             	mov    0x8(%eax),%eax
  8033c0:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8033c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c8:	e9 f8 04 00 00       	jmp    8038c5 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8033cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033d6:	0f 86 d4 00 00 00    	jbe    8034b0 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8033dc:	a1 48 51 80 00       	mov    0x805148,%eax
  8033e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8033e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e7:	8b 50 08             	mov    0x8(%eax),%edx
  8033ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ed:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8033f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f6:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8033f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033fd:	75 17                	jne    803416 <alloc_block_NF+0x11c>
  8033ff:	83 ec 04             	sub    $0x4,%esp
  803402:	68 44 4c 80 00       	push   $0x804c44
  803407:	68 e9 00 00 00       	push   $0xe9
  80340c:	68 9b 4b 80 00       	push   $0x804b9b
  803411:	e8 52 db ff ff       	call   800f68 <_panic>
  803416:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	85 c0                	test   %eax,%eax
  80341d:	74 10                	je     80342f <alloc_block_NF+0x135>
  80341f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803422:	8b 00                	mov    (%eax),%eax
  803424:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803427:	8b 52 04             	mov    0x4(%edx),%edx
  80342a:	89 50 04             	mov    %edx,0x4(%eax)
  80342d:	eb 0b                	jmp    80343a <alloc_block_NF+0x140>
  80342f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803432:	8b 40 04             	mov    0x4(%eax),%eax
  803435:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80343a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343d:	8b 40 04             	mov    0x4(%eax),%eax
  803440:	85 c0                	test   %eax,%eax
  803442:	74 0f                	je     803453 <alloc_block_NF+0x159>
  803444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803447:	8b 40 04             	mov    0x4(%eax),%eax
  80344a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80344d:	8b 12                	mov    (%edx),%edx
  80344f:	89 10                	mov    %edx,(%eax)
  803451:	eb 0a                	jmp    80345d <alloc_block_NF+0x163>
  803453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803456:	8b 00                	mov    (%eax),%eax
  803458:	a3 48 51 80 00       	mov    %eax,0x805148
  80345d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803460:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803469:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803470:	a1 54 51 80 00       	mov    0x805154,%eax
  803475:	48                   	dec    %eax
  803476:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80347b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347e:	8b 40 08             	mov    0x8(%eax),%eax
  803481:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	8b 50 08             	mov    0x8(%eax),%edx
  80348c:	8b 45 08             	mov    0x8(%ebp),%eax
  80348f:	01 c2                	add    %eax,%edx
  803491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803494:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349a:	8b 40 0c             	mov    0xc(%eax),%eax
  80349d:	2b 45 08             	sub    0x8(%ebp),%eax
  8034a0:	89 c2                	mov    %eax,%edx
  8034a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a5:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8034a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ab:	e9 15 04 00 00       	jmp    8038c5 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8034b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8034b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034bc:	74 07                	je     8034c5 <alloc_block_NF+0x1cb>
  8034be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c1:	8b 00                	mov    (%eax),%eax
  8034c3:	eb 05                	jmp    8034ca <alloc_block_NF+0x1d0>
  8034c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ca:	a3 40 51 80 00       	mov    %eax,0x805140
  8034cf:	a1 40 51 80 00       	mov    0x805140,%eax
  8034d4:	85 c0                	test   %eax,%eax
  8034d6:	0f 85 3e fe ff ff    	jne    80331a <alloc_block_NF+0x20>
  8034dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e0:	0f 85 34 fe ff ff    	jne    80331a <alloc_block_NF+0x20>
  8034e6:	e9 d5 03 00 00       	jmp    8038c0 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8034eb:	a1 38 51 80 00       	mov    0x805138,%eax
  8034f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034f3:	e9 b1 01 00 00       	jmp    8036a9 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8034f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fb:	8b 50 08             	mov    0x8(%eax),%edx
  8034fe:	a1 28 50 80 00       	mov    0x805028,%eax
  803503:	39 c2                	cmp    %eax,%edx
  803505:	0f 82 96 01 00 00    	jb     8036a1 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80350b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350e:	8b 40 0c             	mov    0xc(%eax),%eax
  803511:	3b 45 08             	cmp    0x8(%ebp),%eax
  803514:	0f 82 87 01 00 00    	jb     8036a1 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80351a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351d:	8b 40 0c             	mov    0xc(%eax),%eax
  803520:	3b 45 08             	cmp    0x8(%ebp),%eax
  803523:	0f 85 95 00 00 00    	jne    8035be <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803529:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80352d:	75 17                	jne    803546 <alloc_block_NF+0x24c>
  80352f:	83 ec 04             	sub    $0x4,%esp
  803532:	68 44 4c 80 00       	push   $0x804c44
  803537:	68 fc 00 00 00       	push   $0xfc
  80353c:	68 9b 4b 80 00       	push   $0x804b9b
  803541:	e8 22 da ff ff       	call   800f68 <_panic>
  803546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803549:	8b 00                	mov    (%eax),%eax
  80354b:	85 c0                	test   %eax,%eax
  80354d:	74 10                	je     80355f <alloc_block_NF+0x265>
  80354f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803552:	8b 00                	mov    (%eax),%eax
  803554:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803557:	8b 52 04             	mov    0x4(%edx),%edx
  80355a:	89 50 04             	mov    %edx,0x4(%eax)
  80355d:	eb 0b                	jmp    80356a <alloc_block_NF+0x270>
  80355f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803562:	8b 40 04             	mov    0x4(%eax),%eax
  803565:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80356a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356d:	8b 40 04             	mov    0x4(%eax),%eax
  803570:	85 c0                	test   %eax,%eax
  803572:	74 0f                	je     803583 <alloc_block_NF+0x289>
  803574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803577:	8b 40 04             	mov    0x4(%eax),%eax
  80357a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80357d:	8b 12                	mov    (%edx),%edx
  80357f:	89 10                	mov    %edx,(%eax)
  803581:	eb 0a                	jmp    80358d <alloc_block_NF+0x293>
  803583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803586:	8b 00                	mov    (%eax),%eax
  803588:	a3 38 51 80 00       	mov    %eax,0x805138
  80358d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803590:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803599:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8035a5:	48                   	dec    %eax
  8035a6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8035ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ae:	8b 40 08             	mov    0x8(%eax),%eax
  8035b1:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8035b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b9:	e9 07 03 00 00       	jmp    8038c5 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035c7:	0f 86 d4 00 00 00    	jbe    8036a1 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8035cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8035d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8035d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d8:	8b 50 08             	mov    0x8(%eax),%edx
  8035db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035de:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8035e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e7:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8035ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035ee:	75 17                	jne    803607 <alloc_block_NF+0x30d>
  8035f0:	83 ec 04             	sub    $0x4,%esp
  8035f3:	68 44 4c 80 00       	push   $0x804c44
  8035f8:	68 04 01 00 00       	push   $0x104
  8035fd:	68 9b 4b 80 00       	push   $0x804b9b
  803602:	e8 61 d9 ff ff       	call   800f68 <_panic>
  803607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360a:	8b 00                	mov    (%eax),%eax
  80360c:	85 c0                	test   %eax,%eax
  80360e:	74 10                	je     803620 <alloc_block_NF+0x326>
  803610:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803613:	8b 00                	mov    (%eax),%eax
  803615:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803618:	8b 52 04             	mov    0x4(%edx),%edx
  80361b:	89 50 04             	mov    %edx,0x4(%eax)
  80361e:	eb 0b                	jmp    80362b <alloc_block_NF+0x331>
  803620:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803623:	8b 40 04             	mov    0x4(%eax),%eax
  803626:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80362b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362e:	8b 40 04             	mov    0x4(%eax),%eax
  803631:	85 c0                	test   %eax,%eax
  803633:	74 0f                	je     803644 <alloc_block_NF+0x34a>
  803635:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803638:	8b 40 04             	mov    0x4(%eax),%eax
  80363b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80363e:	8b 12                	mov    (%edx),%edx
  803640:	89 10                	mov    %edx,(%eax)
  803642:	eb 0a                	jmp    80364e <alloc_block_NF+0x354>
  803644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803647:	8b 00                	mov    (%eax),%eax
  803649:	a3 48 51 80 00       	mov    %eax,0x805148
  80364e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803657:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80365a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803661:	a1 54 51 80 00       	mov    0x805154,%eax
  803666:	48                   	dec    %eax
  803667:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80366c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366f:	8b 40 08             	mov    0x8(%eax),%eax
  803672:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367a:	8b 50 08             	mov    0x8(%eax),%edx
  80367d:	8b 45 08             	mov    0x8(%ebp),%eax
  803680:	01 c2                	add    %eax,%edx
  803682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803685:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368b:	8b 40 0c             	mov    0xc(%eax),%eax
  80368e:	2b 45 08             	sub    0x8(%ebp),%eax
  803691:	89 c2                	mov    %eax,%edx
  803693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803696:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803699:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369c:	e9 24 02 00 00       	jmp    8038c5 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8036a1:	a1 40 51 80 00       	mov    0x805140,%eax
  8036a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036ad:	74 07                	je     8036b6 <alloc_block_NF+0x3bc>
  8036af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b2:	8b 00                	mov    (%eax),%eax
  8036b4:	eb 05                	jmp    8036bb <alloc_block_NF+0x3c1>
  8036b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8036bb:	a3 40 51 80 00       	mov    %eax,0x805140
  8036c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8036c5:	85 c0                	test   %eax,%eax
  8036c7:	0f 85 2b fe ff ff    	jne    8034f8 <alloc_block_NF+0x1fe>
  8036cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d1:	0f 85 21 fe ff ff    	jne    8034f8 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8036d7:	a1 38 51 80 00       	mov    0x805138,%eax
  8036dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036df:	e9 ae 01 00 00       	jmp    803892 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8036e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e7:	8b 50 08             	mov    0x8(%eax),%edx
  8036ea:	a1 28 50 80 00       	mov    0x805028,%eax
  8036ef:	39 c2                	cmp    %eax,%edx
  8036f1:	0f 83 93 01 00 00    	jae    80388a <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8036f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8036fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  803700:	0f 82 84 01 00 00    	jb     80388a <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803709:	8b 40 0c             	mov    0xc(%eax),%eax
  80370c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80370f:	0f 85 95 00 00 00    	jne    8037aa <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803715:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803719:	75 17                	jne    803732 <alloc_block_NF+0x438>
  80371b:	83 ec 04             	sub    $0x4,%esp
  80371e:	68 44 4c 80 00       	push   $0x804c44
  803723:	68 14 01 00 00       	push   $0x114
  803728:	68 9b 4b 80 00       	push   $0x804b9b
  80372d:	e8 36 d8 ff ff       	call   800f68 <_panic>
  803732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803735:	8b 00                	mov    (%eax),%eax
  803737:	85 c0                	test   %eax,%eax
  803739:	74 10                	je     80374b <alloc_block_NF+0x451>
  80373b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373e:	8b 00                	mov    (%eax),%eax
  803740:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803743:	8b 52 04             	mov    0x4(%edx),%edx
  803746:	89 50 04             	mov    %edx,0x4(%eax)
  803749:	eb 0b                	jmp    803756 <alloc_block_NF+0x45c>
  80374b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374e:	8b 40 04             	mov    0x4(%eax),%eax
  803751:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803759:	8b 40 04             	mov    0x4(%eax),%eax
  80375c:	85 c0                	test   %eax,%eax
  80375e:	74 0f                	je     80376f <alloc_block_NF+0x475>
  803760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803763:	8b 40 04             	mov    0x4(%eax),%eax
  803766:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803769:	8b 12                	mov    (%edx),%edx
  80376b:	89 10                	mov    %edx,(%eax)
  80376d:	eb 0a                	jmp    803779 <alloc_block_NF+0x47f>
  80376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803772:	8b 00                	mov    (%eax),%eax
  803774:	a3 38 51 80 00       	mov    %eax,0x805138
  803779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803785:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80378c:	a1 44 51 80 00       	mov    0x805144,%eax
  803791:	48                   	dec    %eax
  803792:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379a:	8b 40 08             	mov    0x8(%eax),%eax
  80379d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8037a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a5:	e9 1b 01 00 00       	jmp    8038c5 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8037aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8037b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037b3:	0f 86 d1 00 00 00    	jbe    80388a <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8037b9:	a1 48 51 80 00       	mov    0x805148,%eax
  8037be:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8037c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c4:	8b 50 08             	mov    0x8(%eax),%edx
  8037c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ca:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8037cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8037d3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8037d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037da:	75 17                	jne    8037f3 <alloc_block_NF+0x4f9>
  8037dc:	83 ec 04             	sub    $0x4,%esp
  8037df:	68 44 4c 80 00       	push   $0x804c44
  8037e4:	68 1c 01 00 00       	push   $0x11c
  8037e9:	68 9b 4b 80 00       	push   $0x804b9b
  8037ee:	e8 75 d7 ff ff       	call   800f68 <_panic>
  8037f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f6:	8b 00                	mov    (%eax),%eax
  8037f8:	85 c0                	test   %eax,%eax
  8037fa:	74 10                	je     80380c <alloc_block_NF+0x512>
  8037fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ff:	8b 00                	mov    (%eax),%eax
  803801:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803804:	8b 52 04             	mov    0x4(%edx),%edx
  803807:	89 50 04             	mov    %edx,0x4(%eax)
  80380a:	eb 0b                	jmp    803817 <alloc_block_NF+0x51d>
  80380c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80380f:	8b 40 04             	mov    0x4(%eax),%eax
  803812:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80381a:	8b 40 04             	mov    0x4(%eax),%eax
  80381d:	85 c0                	test   %eax,%eax
  80381f:	74 0f                	je     803830 <alloc_block_NF+0x536>
  803821:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803824:	8b 40 04             	mov    0x4(%eax),%eax
  803827:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80382a:	8b 12                	mov    (%edx),%edx
  80382c:	89 10                	mov    %edx,(%eax)
  80382e:	eb 0a                	jmp    80383a <alloc_block_NF+0x540>
  803830:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803833:	8b 00                	mov    (%eax),%eax
  803835:	a3 48 51 80 00       	mov    %eax,0x805148
  80383a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80383d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803843:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803846:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80384d:	a1 54 51 80 00       	mov    0x805154,%eax
  803852:	48                   	dec    %eax
  803853:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803858:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385b:	8b 40 08             	mov    0x8(%eax),%eax
  80385e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803866:	8b 50 08             	mov    0x8(%eax),%edx
  803869:	8b 45 08             	mov    0x8(%ebp),%eax
  80386c:	01 c2                	add    %eax,%edx
  80386e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803871:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803877:	8b 40 0c             	mov    0xc(%eax),%eax
  80387a:	2b 45 08             	sub    0x8(%ebp),%eax
  80387d:	89 c2                	mov    %eax,%edx
  80387f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803882:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803885:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803888:	eb 3b                	jmp    8038c5 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80388a:	a1 40 51 80 00       	mov    0x805140,%eax
  80388f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803892:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803896:	74 07                	je     80389f <alloc_block_NF+0x5a5>
  803898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389b:	8b 00                	mov    (%eax),%eax
  80389d:	eb 05                	jmp    8038a4 <alloc_block_NF+0x5aa>
  80389f:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a4:	a3 40 51 80 00       	mov    %eax,0x805140
  8038a9:	a1 40 51 80 00       	mov    0x805140,%eax
  8038ae:	85 c0                	test   %eax,%eax
  8038b0:	0f 85 2e fe ff ff    	jne    8036e4 <alloc_block_NF+0x3ea>
  8038b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038ba:	0f 85 24 fe ff ff    	jne    8036e4 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8038c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038c5:	c9                   	leave  
  8038c6:	c3                   	ret    

008038c7 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8038c7:	55                   	push   %ebp
  8038c8:	89 e5                	mov    %esp,%ebp
  8038ca:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8038cd:	a1 38 51 80 00       	mov    0x805138,%eax
  8038d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8038d5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8038da:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8038dd:	a1 38 51 80 00       	mov    0x805138,%eax
  8038e2:	85 c0                	test   %eax,%eax
  8038e4:	74 14                	je     8038fa <insert_sorted_with_merge_freeList+0x33>
  8038e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e9:	8b 50 08             	mov    0x8(%eax),%edx
  8038ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ef:	8b 40 08             	mov    0x8(%eax),%eax
  8038f2:	39 c2                	cmp    %eax,%edx
  8038f4:	0f 87 9b 01 00 00    	ja     803a95 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8038fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038fe:	75 17                	jne    803917 <insert_sorted_with_merge_freeList+0x50>
  803900:	83 ec 04             	sub    $0x4,%esp
  803903:	68 78 4b 80 00       	push   $0x804b78
  803908:	68 38 01 00 00       	push   $0x138
  80390d:	68 9b 4b 80 00       	push   $0x804b9b
  803912:	e8 51 d6 ff ff       	call   800f68 <_panic>
  803917:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80391d:	8b 45 08             	mov    0x8(%ebp),%eax
  803920:	89 10                	mov    %edx,(%eax)
  803922:	8b 45 08             	mov    0x8(%ebp),%eax
  803925:	8b 00                	mov    (%eax),%eax
  803927:	85 c0                	test   %eax,%eax
  803929:	74 0d                	je     803938 <insert_sorted_with_merge_freeList+0x71>
  80392b:	a1 38 51 80 00       	mov    0x805138,%eax
  803930:	8b 55 08             	mov    0x8(%ebp),%edx
  803933:	89 50 04             	mov    %edx,0x4(%eax)
  803936:	eb 08                	jmp    803940 <insert_sorted_with_merge_freeList+0x79>
  803938:	8b 45 08             	mov    0x8(%ebp),%eax
  80393b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803940:	8b 45 08             	mov    0x8(%ebp),%eax
  803943:	a3 38 51 80 00       	mov    %eax,0x805138
  803948:	8b 45 08             	mov    0x8(%ebp),%eax
  80394b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803952:	a1 44 51 80 00       	mov    0x805144,%eax
  803957:	40                   	inc    %eax
  803958:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80395d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803961:	0f 84 a8 06 00 00    	je     80400f <insert_sorted_with_merge_freeList+0x748>
  803967:	8b 45 08             	mov    0x8(%ebp),%eax
  80396a:	8b 50 08             	mov    0x8(%eax),%edx
  80396d:	8b 45 08             	mov    0x8(%ebp),%eax
  803970:	8b 40 0c             	mov    0xc(%eax),%eax
  803973:	01 c2                	add    %eax,%edx
  803975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803978:	8b 40 08             	mov    0x8(%eax),%eax
  80397b:	39 c2                	cmp    %eax,%edx
  80397d:	0f 85 8c 06 00 00    	jne    80400f <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803983:	8b 45 08             	mov    0x8(%ebp),%eax
  803986:	8b 50 0c             	mov    0xc(%eax),%edx
  803989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80398c:	8b 40 0c             	mov    0xc(%eax),%eax
  80398f:	01 c2                	add    %eax,%edx
  803991:	8b 45 08             	mov    0x8(%ebp),%eax
  803994:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803997:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80399b:	75 17                	jne    8039b4 <insert_sorted_with_merge_freeList+0xed>
  80399d:	83 ec 04             	sub    $0x4,%esp
  8039a0:	68 44 4c 80 00       	push   $0x804c44
  8039a5:	68 3c 01 00 00       	push   $0x13c
  8039aa:	68 9b 4b 80 00       	push   $0x804b9b
  8039af:	e8 b4 d5 ff ff       	call   800f68 <_panic>
  8039b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b7:	8b 00                	mov    (%eax),%eax
  8039b9:	85 c0                	test   %eax,%eax
  8039bb:	74 10                	je     8039cd <insert_sorted_with_merge_freeList+0x106>
  8039bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c0:	8b 00                	mov    (%eax),%eax
  8039c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039c5:	8b 52 04             	mov    0x4(%edx),%edx
  8039c8:	89 50 04             	mov    %edx,0x4(%eax)
  8039cb:	eb 0b                	jmp    8039d8 <insert_sorted_with_merge_freeList+0x111>
  8039cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d0:	8b 40 04             	mov    0x4(%eax),%eax
  8039d3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039db:	8b 40 04             	mov    0x4(%eax),%eax
  8039de:	85 c0                	test   %eax,%eax
  8039e0:	74 0f                	je     8039f1 <insert_sorted_with_merge_freeList+0x12a>
  8039e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e5:	8b 40 04             	mov    0x4(%eax),%eax
  8039e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039eb:	8b 12                	mov    (%edx),%edx
  8039ed:	89 10                	mov    %edx,(%eax)
  8039ef:	eb 0a                	jmp    8039fb <insert_sorted_with_merge_freeList+0x134>
  8039f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f4:	8b 00                	mov    (%eax),%eax
  8039f6:	a3 38 51 80 00       	mov    %eax,0x805138
  8039fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a0e:	a1 44 51 80 00       	mov    0x805144,%eax
  803a13:	48                   	dec    %eax
  803a14:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a1c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a26:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803a2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a31:	75 17                	jne    803a4a <insert_sorted_with_merge_freeList+0x183>
  803a33:	83 ec 04             	sub    $0x4,%esp
  803a36:	68 78 4b 80 00       	push   $0x804b78
  803a3b:	68 3f 01 00 00       	push   $0x13f
  803a40:	68 9b 4b 80 00       	push   $0x804b9b
  803a45:	e8 1e d5 ff ff       	call   800f68 <_panic>
  803a4a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a53:	89 10                	mov    %edx,(%eax)
  803a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a58:	8b 00                	mov    (%eax),%eax
  803a5a:	85 c0                	test   %eax,%eax
  803a5c:	74 0d                	je     803a6b <insert_sorted_with_merge_freeList+0x1a4>
  803a5e:	a1 48 51 80 00       	mov    0x805148,%eax
  803a63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a66:	89 50 04             	mov    %edx,0x4(%eax)
  803a69:	eb 08                	jmp    803a73 <insert_sorted_with_merge_freeList+0x1ac>
  803a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a76:	a3 48 51 80 00       	mov    %eax,0x805148
  803a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a85:	a1 54 51 80 00       	mov    0x805154,%eax
  803a8a:	40                   	inc    %eax
  803a8b:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803a90:	e9 7a 05 00 00       	jmp    80400f <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803a95:	8b 45 08             	mov    0x8(%ebp),%eax
  803a98:	8b 50 08             	mov    0x8(%eax),%edx
  803a9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a9e:	8b 40 08             	mov    0x8(%eax),%eax
  803aa1:	39 c2                	cmp    %eax,%edx
  803aa3:	0f 82 14 01 00 00    	jb     803bbd <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aac:	8b 50 08             	mov    0x8(%eax),%edx
  803aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ab2:	8b 40 0c             	mov    0xc(%eax),%eax
  803ab5:	01 c2                	add    %eax,%edx
  803ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aba:	8b 40 08             	mov    0x8(%eax),%eax
  803abd:	39 c2                	cmp    %eax,%edx
  803abf:	0f 85 90 00 00 00    	jne    803b55 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ac8:	8b 50 0c             	mov    0xc(%eax),%edx
  803acb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ace:	8b 40 0c             	mov    0xc(%eax),%eax
  803ad1:	01 c2                	add    %eax,%edx
  803ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ad6:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  803adc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803aed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803af1:	75 17                	jne    803b0a <insert_sorted_with_merge_freeList+0x243>
  803af3:	83 ec 04             	sub    $0x4,%esp
  803af6:	68 78 4b 80 00       	push   $0x804b78
  803afb:	68 49 01 00 00       	push   $0x149
  803b00:	68 9b 4b 80 00       	push   $0x804b9b
  803b05:	e8 5e d4 ff ff       	call   800f68 <_panic>
  803b0a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b10:	8b 45 08             	mov    0x8(%ebp),%eax
  803b13:	89 10                	mov    %edx,(%eax)
  803b15:	8b 45 08             	mov    0x8(%ebp),%eax
  803b18:	8b 00                	mov    (%eax),%eax
  803b1a:	85 c0                	test   %eax,%eax
  803b1c:	74 0d                	je     803b2b <insert_sorted_with_merge_freeList+0x264>
  803b1e:	a1 48 51 80 00       	mov    0x805148,%eax
  803b23:	8b 55 08             	mov    0x8(%ebp),%edx
  803b26:	89 50 04             	mov    %edx,0x4(%eax)
  803b29:	eb 08                	jmp    803b33 <insert_sorted_with_merge_freeList+0x26c>
  803b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b33:	8b 45 08             	mov    0x8(%ebp),%eax
  803b36:	a3 48 51 80 00       	mov    %eax,0x805148
  803b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b45:	a1 54 51 80 00       	mov    0x805154,%eax
  803b4a:	40                   	inc    %eax
  803b4b:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b50:	e9 bb 04 00 00       	jmp    804010 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803b55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b59:	75 17                	jne    803b72 <insert_sorted_with_merge_freeList+0x2ab>
  803b5b:	83 ec 04             	sub    $0x4,%esp
  803b5e:	68 ec 4b 80 00       	push   $0x804bec
  803b63:	68 4c 01 00 00       	push   $0x14c
  803b68:	68 9b 4b 80 00       	push   $0x804b9b
  803b6d:	e8 f6 d3 ff ff       	call   800f68 <_panic>
  803b72:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803b78:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7b:	89 50 04             	mov    %edx,0x4(%eax)
  803b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b81:	8b 40 04             	mov    0x4(%eax),%eax
  803b84:	85 c0                	test   %eax,%eax
  803b86:	74 0c                	je     803b94 <insert_sorted_with_merge_freeList+0x2cd>
  803b88:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803b8d:	8b 55 08             	mov    0x8(%ebp),%edx
  803b90:	89 10                	mov    %edx,(%eax)
  803b92:	eb 08                	jmp    803b9c <insert_sorted_with_merge_freeList+0x2d5>
  803b94:	8b 45 08             	mov    0x8(%ebp),%eax
  803b97:	a3 38 51 80 00       	mov    %eax,0x805138
  803b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bad:	a1 44 51 80 00       	mov    0x805144,%eax
  803bb2:	40                   	inc    %eax
  803bb3:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803bb8:	e9 53 04 00 00       	jmp    804010 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803bbd:	a1 38 51 80 00       	mov    0x805138,%eax
  803bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bc5:	e9 15 04 00 00       	jmp    803fdf <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bcd:	8b 00                	mov    (%eax),%eax
  803bcf:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd5:	8b 50 08             	mov    0x8(%eax),%edx
  803bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdb:	8b 40 08             	mov    0x8(%eax),%eax
  803bde:	39 c2                	cmp    %eax,%edx
  803be0:	0f 86 f1 03 00 00    	jbe    803fd7 <insert_sorted_with_merge_freeList+0x710>
  803be6:	8b 45 08             	mov    0x8(%ebp),%eax
  803be9:	8b 50 08             	mov    0x8(%eax),%edx
  803bec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bef:	8b 40 08             	mov    0x8(%eax),%eax
  803bf2:	39 c2                	cmp    %eax,%edx
  803bf4:	0f 83 dd 03 00 00    	jae    803fd7 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfd:	8b 50 08             	mov    0x8(%eax),%edx
  803c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c03:	8b 40 0c             	mov    0xc(%eax),%eax
  803c06:	01 c2                	add    %eax,%edx
  803c08:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0b:	8b 40 08             	mov    0x8(%eax),%eax
  803c0e:	39 c2                	cmp    %eax,%edx
  803c10:	0f 85 b9 01 00 00    	jne    803dcf <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803c16:	8b 45 08             	mov    0x8(%ebp),%eax
  803c19:	8b 50 08             	mov    0x8(%eax),%edx
  803c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1f:	8b 40 0c             	mov    0xc(%eax),%eax
  803c22:	01 c2                	add    %eax,%edx
  803c24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c27:	8b 40 08             	mov    0x8(%eax),%eax
  803c2a:	39 c2                	cmp    %eax,%edx
  803c2c:	0f 85 0d 01 00 00    	jne    803d3f <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c35:	8b 50 0c             	mov    0xc(%eax),%edx
  803c38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c3b:	8b 40 0c             	mov    0xc(%eax),%eax
  803c3e:	01 c2                	add    %eax,%edx
  803c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c43:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803c46:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c4a:	75 17                	jne    803c63 <insert_sorted_with_merge_freeList+0x39c>
  803c4c:	83 ec 04             	sub    $0x4,%esp
  803c4f:	68 44 4c 80 00       	push   $0x804c44
  803c54:	68 5c 01 00 00       	push   $0x15c
  803c59:	68 9b 4b 80 00       	push   $0x804b9b
  803c5e:	e8 05 d3 ff ff       	call   800f68 <_panic>
  803c63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c66:	8b 00                	mov    (%eax),%eax
  803c68:	85 c0                	test   %eax,%eax
  803c6a:	74 10                	je     803c7c <insert_sorted_with_merge_freeList+0x3b5>
  803c6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6f:	8b 00                	mov    (%eax),%eax
  803c71:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c74:	8b 52 04             	mov    0x4(%edx),%edx
  803c77:	89 50 04             	mov    %edx,0x4(%eax)
  803c7a:	eb 0b                	jmp    803c87 <insert_sorted_with_merge_freeList+0x3c0>
  803c7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c7f:	8b 40 04             	mov    0x4(%eax),%eax
  803c82:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c8a:	8b 40 04             	mov    0x4(%eax),%eax
  803c8d:	85 c0                	test   %eax,%eax
  803c8f:	74 0f                	je     803ca0 <insert_sorted_with_merge_freeList+0x3d9>
  803c91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c94:	8b 40 04             	mov    0x4(%eax),%eax
  803c97:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c9a:	8b 12                	mov    (%edx),%edx
  803c9c:	89 10                	mov    %edx,(%eax)
  803c9e:	eb 0a                	jmp    803caa <insert_sorted_with_merge_freeList+0x3e3>
  803ca0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca3:	8b 00                	mov    (%eax),%eax
  803ca5:	a3 38 51 80 00       	mov    %eax,0x805138
  803caa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cbd:	a1 44 51 80 00       	mov    0x805144,%eax
  803cc2:	48                   	dec    %eax
  803cc3:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803cc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ccb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803cd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cd5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803cdc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ce0:	75 17                	jne    803cf9 <insert_sorted_with_merge_freeList+0x432>
  803ce2:	83 ec 04             	sub    $0x4,%esp
  803ce5:	68 78 4b 80 00       	push   $0x804b78
  803cea:	68 5f 01 00 00       	push   $0x15f
  803cef:	68 9b 4b 80 00       	push   $0x804b9b
  803cf4:	e8 6f d2 ff ff       	call   800f68 <_panic>
  803cf9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803cff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d02:	89 10                	mov    %edx,(%eax)
  803d04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d07:	8b 00                	mov    (%eax),%eax
  803d09:	85 c0                	test   %eax,%eax
  803d0b:	74 0d                	je     803d1a <insert_sorted_with_merge_freeList+0x453>
  803d0d:	a1 48 51 80 00       	mov    0x805148,%eax
  803d12:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d15:	89 50 04             	mov    %edx,0x4(%eax)
  803d18:	eb 08                	jmp    803d22 <insert_sorted_with_merge_freeList+0x45b>
  803d1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d1d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d25:	a3 48 51 80 00       	mov    %eax,0x805148
  803d2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d34:	a1 54 51 80 00       	mov    0x805154,%eax
  803d39:	40                   	inc    %eax
  803d3a:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d42:	8b 50 0c             	mov    0xc(%eax),%edx
  803d45:	8b 45 08             	mov    0x8(%ebp),%eax
  803d48:	8b 40 0c             	mov    0xc(%eax),%eax
  803d4b:	01 c2                	add    %eax,%edx
  803d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d50:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803d53:	8b 45 08             	mov    0x8(%ebp),%eax
  803d56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d60:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803d67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d6b:	75 17                	jne    803d84 <insert_sorted_with_merge_freeList+0x4bd>
  803d6d:	83 ec 04             	sub    $0x4,%esp
  803d70:	68 78 4b 80 00       	push   $0x804b78
  803d75:	68 64 01 00 00       	push   $0x164
  803d7a:	68 9b 4b 80 00       	push   $0x804b9b
  803d7f:	e8 e4 d1 ff ff       	call   800f68 <_panic>
  803d84:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8d:	89 10                	mov    %edx,(%eax)
  803d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d92:	8b 00                	mov    (%eax),%eax
  803d94:	85 c0                	test   %eax,%eax
  803d96:	74 0d                	je     803da5 <insert_sorted_with_merge_freeList+0x4de>
  803d98:	a1 48 51 80 00       	mov    0x805148,%eax
  803d9d:	8b 55 08             	mov    0x8(%ebp),%edx
  803da0:	89 50 04             	mov    %edx,0x4(%eax)
  803da3:	eb 08                	jmp    803dad <insert_sorted_with_merge_freeList+0x4e6>
  803da5:	8b 45 08             	mov    0x8(%ebp),%eax
  803da8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803dad:	8b 45 08             	mov    0x8(%ebp),%eax
  803db0:	a3 48 51 80 00       	mov    %eax,0x805148
  803db5:	8b 45 08             	mov    0x8(%ebp),%eax
  803db8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dbf:	a1 54 51 80 00       	mov    0x805154,%eax
  803dc4:	40                   	inc    %eax
  803dc5:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803dca:	e9 41 02 00 00       	jmp    804010 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd2:	8b 50 08             	mov    0x8(%eax),%edx
  803dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd8:	8b 40 0c             	mov    0xc(%eax),%eax
  803ddb:	01 c2                	add    %eax,%edx
  803ddd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803de0:	8b 40 08             	mov    0x8(%eax),%eax
  803de3:	39 c2                	cmp    %eax,%edx
  803de5:	0f 85 7c 01 00 00    	jne    803f67 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803deb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803def:	74 06                	je     803df7 <insert_sorted_with_merge_freeList+0x530>
  803df1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803df5:	75 17                	jne    803e0e <insert_sorted_with_merge_freeList+0x547>
  803df7:	83 ec 04             	sub    $0x4,%esp
  803dfa:	68 b4 4b 80 00       	push   $0x804bb4
  803dff:	68 69 01 00 00       	push   $0x169
  803e04:	68 9b 4b 80 00       	push   $0x804b9b
  803e09:	e8 5a d1 ff ff       	call   800f68 <_panic>
  803e0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e11:	8b 50 04             	mov    0x4(%eax),%edx
  803e14:	8b 45 08             	mov    0x8(%ebp),%eax
  803e17:	89 50 04             	mov    %edx,0x4(%eax)
  803e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e1d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e20:	89 10                	mov    %edx,(%eax)
  803e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e25:	8b 40 04             	mov    0x4(%eax),%eax
  803e28:	85 c0                	test   %eax,%eax
  803e2a:	74 0d                	je     803e39 <insert_sorted_with_merge_freeList+0x572>
  803e2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e2f:	8b 40 04             	mov    0x4(%eax),%eax
  803e32:	8b 55 08             	mov    0x8(%ebp),%edx
  803e35:	89 10                	mov    %edx,(%eax)
  803e37:	eb 08                	jmp    803e41 <insert_sorted_with_merge_freeList+0x57a>
  803e39:	8b 45 08             	mov    0x8(%ebp),%eax
  803e3c:	a3 38 51 80 00       	mov    %eax,0x805138
  803e41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e44:	8b 55 08             	mov    0x8(%ebp),%edx
  803e47:	89 50 04             	mov    %edx,0x4(%eax)
  803e4a:	a1 44 51 80 00       	mov    0x805144,%eax
  803e4f:	40                   	inc    %eax
  803e50:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803e55:	8b 45 08             	mov    0x8(%ebp),%eax
  803e58:	8b 50 0c             	mov    0xc(%eax),%edx
  803e5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e5e:	8b 40 0c             	mov    0xc(%eax),%eax
  803e61:	01 c2                	add    %eax,%edx
  803e63:	8b 45 08             	mov    0x8(%ebp),%eax
  803e66:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803e69:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803e6d:	75 17                	jne    803e86 <insert_sorted_with_merge_freeList+0x5bf>
  803e6f:	83 ec 04             	sub    $0x4,%esp
  803e72:	68 44 4c 80 00       	push   $0x804c44
  803e77:	68 6b 01 00 00       	push   $0x16b
  803e7c:	68 9b 4b 80 00       	push   $0x804b9b
  803e81:	e8 e2 d0 ff ff       	call   800f68 <_panic>
  803e86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e89:	8b 00                	mov    (%eax),%eax
  803e8b:	85 c0                	test   %eax,%eax
  803e8d:	74 10                	je     803e9f <insert_sorted_with_merge_freeList+0x5d8>
  803e8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e92:	8b 00                	mov    (%eax),%eax
  803e94:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e97:	8b 52 04             	mov    0x4(%edx),%edx
  803e9a:	89 50 04             	mov    %edx,0x4(%eax)
  803e9d:	eb 0b                	jmp    803eaa <insert_sorted_with_merge_freeList+0x5e3>
  803e9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ea2:	8b 40 04             	mov    0x4(%eax),%eax
  803ea5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803eaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ead:	8b 40 04             	mov    0x4(%eax),%eax
  803eb0:	85 c0                	test   %eax,%eax
  803eb2:	74 0f                	je     803ec3 <insert_sorted_with_merge_freeList+0x5fc>
  803eb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eb7:	8b 40 04             	mov    0x4(%eax),%eax
  803eba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ebd:	8b 12                	mov    (%edx),%edx
  803ebf:	89 10                	mov    %edx,(%eax)
  803ec1:	eb 0a                	jmp    803ecd <insert_sorted_with_merge_freeList+0x606>
  803ec3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ec6:	8b 00                	mov    (%eax),%eax
  803ec8:	a3 38 51 80 00       	mov    %eax,0x805138
  803ecd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ed0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ed6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ed9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ee0:	a1 44 51 80 00       	mov    0x805144,%eax
  803ee5:	48                   	dec    %eax
  803ee6:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803ef5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ef8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803eff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803f03:	75 17                	jne    803f1c <insert_sorted_with_merge_freeList+0x655>
  803f05:	83 ec 04             	sub    $0x4,%esp
  803f08:	68 78 4b 80 00       	push   $0x804b78
  803f0d:	68 6e 01 00 00       	push   $0x16e
  803f12:	68 9b 4b 80 00       	push   $0x804b9b
  803f17:	e8 4c d0 ff ff       	call   800f68 <_panic>
  803f1c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803f22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f25:	89 10                	mov    %edx,(%eax)
  803f27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f2a:	8b 00                	mov    (%eax),%eax
  803f2c:	85 c0                	test   %eax,%eax
  803f2e:	74 0d                	je     803f3d <insert_sorted_with_merge_freeList+0x676>
  803f30:	a1 48 51 80 00       	mov    0x805148,%eax
  803f35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f38:	89 50 04             	mov    %edx,0x4(%eax)
  803f3b:	eb 08                	jmp    803f45 <insert_sorted_with_merge_freeList+0x67e>
  803f3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f40:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803f45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f48:	a3 48 51 80 00       	mov    %eax,0x805148
  803f4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f57:	a1 54 51 80 00       	mov    0x805154,%eax
  803f5c:	40                   	inc    %eax
  803f5d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803f62:	e9 a9 00 00 00       	jmp    804010 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803f67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f6b:	74 06                	je     803f73 <insert_sorted_with_merge_freeList+0x6ac>
  803f6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f71:	75 17                	jne    803f8a <insert_sorted_with_merge_freeList+0x6c3>
  803f73:	83 ec 04             	sub    $0x4,%esp
  803f76:	68 10 4c 80 00       	push   $0x804c10
  803f7b:	68 73 01 00 00       	push   $0x173
  803f80:	68 9b 4b 80 00       	push   $0x804b9b
  803f85:	e8 de cf ff ff       	call   800f68 <_panic>
  803f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f8d:	8b 10                	mov    (%eax),%edx
  803f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f92:	89 10                	mov    %edx,(%eax)
  803f94:	8b 45 08             	mov    0x8(%ebp),%eax
  803f97:	8b 00                	mov    (%eax),%eax
  803f99:	85 c0                	test   %eax,%eax
  803f9b:	74 0b                	je     803fa8 <insert_sorted_with_merge_freeList+0x6e1>
  803f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa0:	8b 00                	mov    (%eax),%eax
  803fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  803fa5:	89 50 04             	mov    %edx,0x4(%eax)
  803fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fab:	8b 55 08             	mov    0x8(%ebp),%edx
  803fae:	89 10                	mov    %edx,(%eax)
  803fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  803fb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fb6:	89 50 04             	mov    %edx,0x4(%eax)
  803fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  803fbc:	8b 00                	mov    (%eax),%eax
  803fbe:	85 c0                	test   %eax,%eax
  803fc0:	75 08                	jne    803fca <insert_sorted_with_merge_freeList+0x703>
  803fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803fca:	a1 44 51 80 00       	mov    0x805144,%eax
  803fcf:	40                   	inc    %eax
  803fd0:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803fd5:	eb 39                	jmp    804010 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803fd7:	a1 40 51 80 00       	mov    0x805140,%eax
  803fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fe3:	74 07                	je     803fec <insert_sorted_with_merge_freeList+0x725>
  803fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe8:	8b 00                	mov    (%eax),%eax
  803fea:	eb 05                	jmp    803ff1 <insert_sorted_with_merge_freeList+0x72a>
  803fec:	b8 00 00 00 00       	mov    $0x0,%eax
  803ff1:	a3 40 51 80 00       	mov    %eax,0x805140
  803ff6:	a1 40 51 80 00       	mov    0x805140,%eax
  803ffb:	85 c0                	test   %eax,%eax
  803ffd:	0f 85 c7 fb ff ff    	jne    803bca <insert_sorted_with_merge_freeList+0x303>
  804003:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804007:	0f 85 bd fb ff ff    	jne    803bca <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80400d:	eb 01                	jmp    804010 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80400f:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804010:	90                   	nop
  804011:	c9                   	leave  
  804012:	c3                   	ret    
  804013:	90                   	nop

00804014 <__udivdi3>:
  804014:	55                   	push   %ebp
  804015:	57                   	push   %edi
  804016:	56                   	push   %esi
  804017:	53                   	push   %ebx
  804018:	83 ec 1c             	sub    $0x1c,%esp
  80401b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80401f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804023:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804027:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80402b:	89 ca                	mov    %ecx,%edx
  80402d:	89 f8                	mov    %edi,%eax
  80402f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804033:	85 f6                	test   %esi,%esi
  804035:	75 2d                	jne    804064 <__udivdi3+0x50>
  804037:	39 cf                	cmp    %ecx,%edi
  804039:	77 65                	ja     8040a0 <__udivdi3+0x8c>
  80403b:	89 fd                	mov    %edi,%ebp
  80403d:	85 ff                	test   %edi,%edi
  80403f:	75 0b                	jne    80404c <__udivdi3+0x38>
  804041:	b8 01 00 00 00       	mov    $0x1,%eax
  804046:	31 d2                	xor    %edx,%edx
  804048:	f7 f7                	div    %edi
  80404a:	89 c5                	mov    %eax,%ebp
  80404c:	31 d2                	xor    %edx,%edx
  80404e:	89 c8                	mov    %ecx,%eax
  804050:	f7 f5                	div    %ebp
  804052:	89 c1                	mov    %eax,%ecx
  804054:	89 d8                	mov    %ebx,%eax
  804056:	f7 f5                	div    %ebp
  804058:	89 cf                	mov    %ecx,%edi
  80405a:	89 fa                	mov    %edi,%edx
  80405c:	83 c4 1c             	add    $0x1c,%esp
  80405f:	5b                   	pop    %ebx
  804060:	5e                   	pop    %esi
  804061:	5f                   	pop    %edi
  804062:	5d                   	pop    %ebp
  804063:	c3                   	ret    
  804064:	39 ce                	cmp    %ecx,%esi
  804066:	77 28                	ja     804090 <__udivdi3+0x7c>
  804068:	0f bd fe             	bsr    %esi,%edi
  80406b:	83 f7 1f             	xor    $0x1f,%edi
  80406e:	75 40                	jne    8040b0 <__udivdi3+0x9c>
  804070:	39 ce                	cmp    %ecx,%esi
  804072:	72 0a                	jb     80407e <__udivdi3+0x6a>
  804074:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804078:	0f 87 9e 00 00 00    	ja     80411c <__udivdi3+0x108>
  80407e:	b8 01 00 00 00       	mov    $0x1,%eax
  804083:	89 fa                	mov    %edi,%edx
  804085:	83 c4 1c             	add    $0x1c,%esp
  804088:	5b                   	pop    %ebx
  804089:	5e                   	pop    %esi
  80408a:	5f                   	pop    %edi
  80408b:	5d                   	pop    %ebp
  80408c:	c3                   	ret    
  80408d:	8d 76 00             	lea    0x0(%esi),%esi
  804090:	31 ff                	xor    %edi,%edi
  804092:	31 c0                	xor    %eax,%eax
  804094:	89 fa                	mov    %edi,%edx
  804096:	83 c4 1c             	add    $0x1c,%esp
  804099:	5b                   	pop    %ebx
  80409a:	5e                   	pop    %esi
  80409b:	5f                   	pop    %edi
  80409c:	5d                   	pop    %ebp
  80409d:	c3                   	ret    
  80409e:	66 90                	xchg   %ax,%ax
  8040a0:	89 d8                	mov    %ebx,%eax
  8040a2:	f7 f7                	div    %edi
  8040a4:	31 ff                	xor    %edi,%edi
  8040a6:	89 fa                	mov    %edi,%edx
  8040a8:	83 c4 1c             	add    $0x1c,%esp
  8040ab:	5b                   	pop    %ebx
  8040ac:	5e                   	pop    %esi
  8040ad:	5f                   	pop    %edi
  8040ae:	5d                   	pop    %ebp
  8040af:	c3                   	ret    
  8040b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040b5:	89 eb                	mov    %ebp,%ebx
  8040b7:	29 fb                	sub    %edi,%ebx
  8040b9:	89 f9                	mov    %edi,%ecx
  8040bb:	d3 e6                	shl    %cl,%esi
  8040bd:	89 c5                	mov    %eax,%ebp
  8040bf:	88 d9                	mov    %bl,%cl
  8040c1:	d3 ed                	shr    %cl,%ebp
  8040c3:	89 e9                	mov    %ebp,%ecx
  8040c5:	09 f1                	or     %esi,%ecx
  8040c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040cb:	89 f9                	mov    %edi,%ecx
  8040cd:	d3 e0                	shl    %cl,%eax
  8040cf:	89 c5                	mov    %eax,%ebp
  8040d1:	89 d6                	mov    %edx,%esi
  8040d3:	88 d9                	mov    %bl,%cl
  8040d5:	d3 ee                	shr    %cl,%esi
  8040d7:	89 f9                	mov    %edi,%ecx
  8040d9:	d3 e2                	shl    %cl,%edx
  8040db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040df:	88 d9                	mov    %bl,%cl
  8040e1:	d3 e8                	shr    %cl,%eax
  8040e3:	09 c2                	or     %eax,%edx
  8040e5:	89 d0                	mov    %edx,%eax
  8040e7:	89 f2                	mov    %esi,%edx
  8040e9:	f7 74 24 0c          	divl   0xc(%esp)
  8040ed:	89 d6                	mov    %edx,%esi
  8040ef:	89 c3                	mov    %eax,%ebx
  8040f1:	f7 e5                	mul    %ebp
  8040f3:	39 d6                	cmp    %edx,%esi
  8040f5:	72 19                	jb     804110 <__udivdi3+0xfc>
  8040f7:	74 0b                	je     804104 <__udivdi3+0xf0>
  8040f9:	89 d8                	mov    %ebx,%eax
  8040fb:	31 ff                	xor    %edi,%edi
  8040fd:	e9 58 ff ff ff       	jmp    80405a <__udivdi3+0x46>
  804102:	66 90                	xchg   %ax,%ax
  804104:	8b 54 24 08          	mov    0x8(%esp),%edx
  804108:	89 f9                	mov    %edi,%ecx
  80410a:	d3 e2                	shl    %cl,%edx
  80410c:	39 c2                	cmp    %eax,%edx
  80410e:	73 e9                	jae    8040f9 <__udivdi3+0xe5>
  804110:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804113:	31 ff                	xor    %edi,%edi
  804115:	e9 40 ff ff ff       	jmp    80405a <__udivdi3+0x46>
  80411a:	66 90                	xchg   %ax,%ax
  80411c:	31 c0                	xor    %eax,%eax
  80411e:	e9 37 ff ff ff       	jmp    80405a <__udivdi3+0x46>
  804123:	90                   	nop

00804124 <__umoddi3>:
  804124:	55                   	push   %ebp
  804125:	57                   	push   %edi
  804126:	56                   	push   %esi
  804127:	53                   	push   %ebx
  804128:	83 ec 1c             	sub    $0x1c,%esp
  80412b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80412f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804133:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804137:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80413b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80413f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804143:	89 f3                	mov    %esi,%ebx
  804145:	89 fa                	mov    %edi,%edx
  804147:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80414b:	89 34 24             	mov    %esi,(%esp)
  80414e:	85 c0                	test   %eax,%eax
  804150:	75 1a                	jne    80416c <__umoddi3+0x48>
  804152:	39 f7                	cmp    %esi,%edi
  804154:	0f 86 a2 00 00 00    	jbe    8041fc <__umoddi3+0xd8>
  80415a:	89 c8                	mov    %ecx,%eax
  80415c:	89 f2                	mov    %esi,%edx
  80415e:	f7 f7                	div    %edi
  804160:	89 d0                	mov    %edx,%eax
  804162:	31 d2                	xor    %edx,%edx
  804164:	83 c4 1c             	add    $0x1c,%esp
  804167:	5b                   	pop    %ebx
  804168:	5e                   	pop    %esi
  804169:	5f                   	pop    %edi
  80416a:	5d                   	pop    %ebp
  80416b:	c3                   	ret    
  80416c:	39 f0                	cmp    %esi,%eax
  80416e:	0f 87 ac 00 00 00    	ja     804220 <__umoddi3+0xfc>
  804174:	0f bd e8             	bsr    %eax,%ebp
  804177:	83 f5 1f             	xor    $0x1f,%ebp
  80417a:	0f 84 ac 00 00 00    	je     80422c <__umoddi3+0x108>
  804180:	bf 20 00 00 00       	mov    $0x20,%edi
  804185:	29 ef                	sub    %ebp,%edi
  804187:	89 fe                	mov    %edi,%esi
  804189:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80418d:	89 e9                	mov    %ebp,%ecx
  80418f:	d3 e0                	shl    %cl,%eax
  804191:	89 d7                	mov    %edx,%edi
  804193:	89 f1                	mov    %esi,%ecx
  804195:	d3 ef                	shr    %cl,%edi
  804197:	09 c7                	or     %eax,%edi
  804199:	89 e9                	mov    %ebp,%ecx
  80419b:	d3 e2                	shl    %cl,%edx
  80419d:	89 14 24             	mov    %edx,(%esp)
  8041a0:	89 d8                	mov    %ebx,%eax
  8041a2:	d3 e0                	shl    %cl,%eax
  8041a4:	89 c2                	mov    %eax,%edx
  8041a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041aa:	d3 e0                	shl    %cl,%eax
  8041ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041b4:	89 f1                	mov    %esi,%ecx
  8041b6:	d3 e8                	shr    %cl,%eax
  8041b8:	09 d0                	or     %edx,%eax
  8041ba:	d3 eb                	shr    %cl,%ebx
  8041bc:	89 da                	mov    %ebx,%edx
  8041be:	f7 f7                	div    %edi
  8041c0:	89 d3                	mov    %edx,%ebx
  8041c2:	f7 24 24             	mull   (%esp)
  8041c5:	89 c6                	mov    %eax,%esi
  8041c7:	89 d1                	mov    %edx,%ecx
  8041c9:	39 d3                	cmp    %edx,%ebx
  8041cb:	0f 82 87 00 00 00    	jb     804258 <__umoddi3+0x134>
  8041d1:	0f 84 91 00 00 00    	je     804268 <__umoddi3+0x144>
  8041d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041db:	29 f2                	sub    %esi,%edx
  8041dd:	19 cb                	sbb    %ecx,%ebx
  8041df:	89 d8                	mov    %ebx,%eax
  8041e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041e5:	d3 e0                	shl    %cl,%eax
  8041e7:	89 e9                	mov    %ebp,%ecx
  8041e9:	d3 ea                	shr    %cl,%edx
  8041eb:	09 d0                	or     %edx,%eax
  8041ed:	89 e9                	mov    %ebp,%ecx
  8041ef:	d3 eb                	shr    %cl,%ebx
  8041f1:	89 da                	mov    %ebx,%edx
  8041f3:	83 c4 1c             	add    $0x1c,%esp
  8041f6:	5b                   	pop    %ebx
  8041f7:	5e                   	pop    %esi
  8041f8:	5f                   	pop    %edi
  8041f9:	5d                   	pop    %ebp
  8041fa:	c3                   	ret    
  8041fb:	90                   	nop
  8041fc:	89 fd                	mov    %edi,%ebp
  8041fe:	85 ff                	test   %edi,%edi
  804200:	75 0b                	jne    80420d <__umoddi3+0xe9>
  804202:	b8 01 00 00 00       	mov    $0x1,%eax
  804207:	31 d2                	xor    %edx,%edx
  804209:	f7 f7                	div    %edi
  80420b:	89 c5                	mov    %eax,%ebp
  80420d:	89 f0                	mov    %esi,%eax
  80420f:	31 d2                	xor    %edx,%edx
  804211:	f7 f5                	div    %ebp
  804213:	89 c8                	mov    %ecx,%eax
  804215:	f7 f5                	div    %ebp
  804217:	89 d0                	mov    %edx,%eax
  804219:	e9 44 ff ff ff       	jmp    804162 <__umoddi3+0x3e>
  80421e:	66 90                	xchg   %ax,%ax
  804220:	89 c8                	mov    %ecx,%eax
  804222:	89 f2                	mov    %esi,%edx
  804224:	83 c4 1c             	add    $0x1c,%esp
  804227:	5b                   	pop    %ebx
  804228:	5e                   	pop    %esi
  804229:	5f                   	pop    %edi
  80422a:	5d                   	pop    %ebp
  80422b:	c3                   	ret    
  80422c:	3b 04 24             	cmp    (%esp),%eax
  80422f:	72 06                	jb     804237 <__umoddi3+0x113>
  804231:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804235:	77 0f                	ja     804246 <__umoddi3+0x122>
  804237:	89 f2                	mov    %esi,%edx
  804239:	29 f9                	sub    %edi,%ecx
  80423b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80423f:	89 14 24             	mov    %edx,(%esp)
  804242:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804246:	8b 44 24 04          	mov    0x4(%esp),%eax
  80424a:	8b 14 24             	mov    (%esp),%edx
  80424d:	83 c4 1c             	add    $0x1c,%esp
  804250:	5b                   	pop    %ebx
  804251:	5e                   	pop    %esi
  804252:	5f                   	pop    %edi
  804253:	5d                   	pop    %ebp
  804254:	c3                   	ret    
  804255:	8d 76 00             	lea    0x0(%esi),%esi
  804258:	2b 04 24             	sub    (%esp),%eax
  80425b:	19 fa                	sbb    %edi,%edx
  80425d:	89 d1                	mov    %edx,%ecx
  80425f:	89 c6                	mov    %eax,%esi
  804261:	e9 71 ff ff ff       	jmp    8041d7 <__umoddi3+0xb3>
  804266:	66 90                	xchg   %ax,%ax
  804268:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80426c:	72 ea                	jb     804258 <__umoddi3+0x134>
  80426e:	89 d9                	mov    %ebx,%ecx
  804270:	e9 62 ff ff ff       	jmp    8041d7 <__umoddi3+0xb3>
