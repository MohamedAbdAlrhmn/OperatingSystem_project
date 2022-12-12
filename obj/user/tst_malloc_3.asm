
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
  800091:	68 60 42 80 00       	push   $0x804260
  800096:	6a 1a                	push   $0x1a
  800098:	68 7c 42 80 00       	push   $0x80427c
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
  8000df:	e8 48 23 00 00       	call   80242c <sys_calculate_free_frames>
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
  8000fb:	e8 cc 23 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
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
  800137:	68 90 42 80 00       	push   $0x804290
  80013c:	6a 39                	push   $0x39
  80013e:	68 7c 42 80 00       	push   $0x80427c
  800143:	e8 20 0e 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 7f 23 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 f8 42 80 00       	push   $0x8042f8
  80015a:	6a 3a                	push   $0x3a
  80015c:	68 7c 42 80 00       	push   $0x80427c
  800161:	e8 02 0e 00 00       	call   800f68 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 c1 22 00 00       	call   80242c <sys_calculate_free_frames>
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
  80019b:	e8 8c 22 00 00       	call   80242c <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 28 43 80 00       	push   $0x804328
  8001b1:	6a 41                	push   $0x41
  8001b3:	68 7c 42 80 00       	push   $0x80427c
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
  80026e:	68 6c 43 80 00       	push   $0x80436c
  800273:	6a 4b                	push   $0x4b
  800275:	68 7c 42 80 00       	push   $0x80427c
  80027a:	e8 e9 0c 00 00       	call   800f68 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 48 22 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
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
  8002d0:	68 90 42 80 00       	push   $0x804290
  8002d5:	6a 50                	push   $0x50
  8002d7:	68 7c 42 80 00       	push   $0x80427c
  8002dc:	e8 87 0c 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 e6 21 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 f8 42 80 00       	push   $0x8042f8
  8002f3:	6a 51                	push   $0x51
  8002f5:	68 7c 42 80 00       	push   $0x80427c
  8002fa:	e8 69 0c 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 28 21 00 00       	call   80242c <sys_calculate_free_frames>
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
  80033d:	e8 ea 20 00 00       	call   80242c <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 28 43 80 00       	push   $0x804328
  800353:	6a 58                	push   $0x58
  800355:	68 7c 42 80 00       	push   $0x80427c
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
  800414:	68 6c 43 80 00       	push   $0x80436c
  800419:	6a 61                	push   $0x61
  80041b:	68 7c 42 80 00       	push   $0x80427c
  800420:	e8 43 0b 00 00       	call   800f68 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 a2 20 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
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
  800479:	68 90 42 80 00       	push   $0x804290
  80047e:	6a 66                	push   $0x66
  800480:	68 7c 42 80 00       	push   $0x80427c
  800485:	e8 de 0a 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80048a:	e8 3d 20 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
  80048f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800492:	74 14                	je     8004a8 <_main+0x470>
  800494:	83 ec 04             	sub    $0x4,%esp
  800497:	68 f8 42 80 00       	push   $0x8042f8
  80049c:	6a 67                	push   $0x67
  80049e:	68 7c 42 80 00       	push   $0x80427c
  8004a3:	e8 c0 0a 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a8:	e8 7f 1f 00 00       	call   80242c <sys_calculate_free_frames>
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
  8004e4:	e8 43 1f 00 00       	call   80242c <sys_calculate_free_frames>
  8004e9:	29 c3                	sub    %eax,%ebx
  8004eb:	89 d8                	mov    %ebx,%eax
  8004ed:	83 f8 02             	cmp    $0x2,%eax
  8004f0:	74 14                	je     800506 <_main+0x4ce>
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	68 28 43 80 00       	push   $0x804328
  8004fa:	6a 6e                	push   $0x6e
  8004fc:	68 7c 42 80 00       	push   $0x80427c
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
  8005c4:	68 6c 43 80 00       	push   $0x80436c
  8005c9:	6a 77                	push   $0x77
  8005cb:	68 7c 42 80 00       	push   $0x80427c
  8005d0:	e8 93 09 00 00       	call   800f68 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d5:	e8 52 1e 00 00       	call   80242c <sys_calculate_free_frames>
  8005da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005dd:	e8 ea 1e 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
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
  800645:	68 90 42 80 00       	push   $0x804290
  80064a:	6a 7d                	push   $0x7d
  80064c:	68 7c 42 80 00       	push   $0x80427c
  800651:	e8 12 09 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800656:	e8 71 1e 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
  80065b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80065e:	74 14                	je     800674 <_main+0x63c>
  800660:	83 ec 04             	sub    $0x4,%esp
  800663:	68 f8 42 80 00       	push   $0x8042f8
  800668:	6a 7e                	push   $0x7e
  80066a:	68 7c 42 80 00       	push   $0x80427c
  80066f:	e8 f4 08 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800674:	e8 53 1e 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
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
  8006e0:	68 90 42 80 00       	push   $0x804290
  8006e5:	68 84 00 00 00       	push   $0x84
  8006ea:	68 7c 42 80 00       	push   $0x80427c
  8006ef:	e8 74 08 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f4:	e8 d3 1d 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
  8006f9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8006fc:	74 17                	je     800715 <_main+0x6dd>
  8006fe:	83 ec 04             	sub    $0x4,%esp
  800701:	68 f8 42 80 00       	push   $0x8042f8
  800706:	68 85 00 00 00       	push   $0x85
  80070b:	68 7c 42 80 00       	push   $0x80427c
  800710:	e8 53 08 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800715:	e8 12 1d 00 00       	call   80242c <sys_calculate_free_frames>
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
  8007b9:	e8 6e 1c 00 00       	call   80242c <sys_calculate_free_frames>
  8007be:	29 c3                	sub    %eax,%ebx
  8007c0:	89 d8                	mov    %ebx,%eax
  8007c2:	83 f8 02             	cmp    $0x2,%eax
  8007c5:	74 17                	je     8007de <_main+0x7a6>
  8007c7:	83 ec 04             	sub    $0x4,%esp
  8007ca:	68 28 43 80 00       	push   $0x804328
  8007cf:	68 8c 00 00 00       	push   $0x8c
  8007d4:	68 7c 42 80 00       	push   $0x80427c
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
  8008b7:	68 6c 43 80 00       	push   $0x80436c
  8008bc:	68 95 00 00 00       	push   $0x95
  8008c1:	68 7c 42 80 00       	push   $0x80427c
  8008c6:	e8 9d 06 00 00       	call   800f68 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008cb:	e8 5c 1b 00 00       	call   80242c <sys_calculate_free_frames>
  8008d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d3:	e8 f4 1b 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
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
  80093e:	68 90 42 80 00       	push   $0x804290
  800943:	68 9b 00 00 00       	push   $0x9b
  800948:	68 7c 42 80 00       	push   $0x80427c
  80094d:	e8 16 06 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800952:	e8 75 1b 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
  800957:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 f8 42 80 00       	push   $0x8042f8
  800964:	68 9c 00 00 00       	push   $0x9c
  800969:	68 7c 42 80 00       	push   $0x80427c
  80096e:	e8 f5 05 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800973:	e8 54 1b 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
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
  8009ee:	68 90 42 80 00       	push   $0x804290
  8009f3:	68 a2 00 00 00       	push   $0xa2
  8009f8:	68 7c 42 80 00       	push   $0x80427c
  8009fd:	e8 66 05 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a02:	e8 c5 1a 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
  800a07:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a0a:	74 17                	je     800a23 <_main+0x9eb>
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	68 f8 42 80 00       	push   $0x8042f8
  800a14:	68 a3 00 00 00       	push   $0xa3
  800a19:	68 7c 42 80 00       	push   $0x80427c
  800a1e:	e8 45 05 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a23:	e8 04 1a 00 00       	call   80242c <sys_calculate_free_frames>
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
  800a94:	e8 93 19 00 00       	call   80242c <sys_calculate_free_frames>
  800a99:	29 c3                	sub    %eax,%ebx
  800a9b:	89 d8                	mov    %ebx,%eax
  800a9d:	83 f8 05             	cmp    $0x5,%eax
  800aa0:	74 17                	je     800ab9 <_main+0xa81>
  800aa2:	83 ec 04             	sub    $0x4,%esp
  800aa5:	68 28 43 80 00       	push   $0x804328
  800aaa:	68 ab 00 00 00       	push   $0xab
  800aaf:	68 7c 42 80 00       	push   $0x80427c
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
  800bea:	68 6c 43 80 00       	push   $0x80436c
  800bef:	68 b6 00 00 00       	push   $0xb6
  800bf4:	68 7c 42 80 00       	push   $0x80427c
  800bf9:	e8 6a 03 00 00       	call   800f68 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfe:	e8 c9 18 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
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
  800c7c:	68 90 42 80 00       	push   $0x804290
  800c81:	68 bb 00 00 00       	push   $0xbb
  800c86:	68 7c 42 80 00       	push   $0x80427c
  800c8b:	e8 d8 02 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c90:	e8 37 18 00 00       	call   8024cc <sys_pf_calculate_allocated_pages>
  800c95:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c98:	74 17                	je     800cb1 <_main+0xc79>
  800c9a:	83 ec 04             	sub    $0x4,%esp
  800c9d:	68 f8 42 80 00       	push   $0x8042f8
  800ca2:	68 bc 00 00 00       	push   $0xbc
  800ca7:	68 7c 42 80 00       	push   $0x80427c
  800cac:	e8 b7 02 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cb1:	e8 76 17 00 00       	call   80242c <sys_calculate_free_frames>
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
  800d05:	e8 22 17 00 00       	call   80242c <sys_calculate_free_frames>
  800d0a:	29 c3                	sub    %eax,%ebx
  800d0c:	89 d8                	mov    %ebx,%eax
  800d0e:	83 f8 02             	cmp    $0x2,%eax
  800d11:	74 17                	je     800d2a <_main+0xcf2>
  800d13:	83 ec 04             	sub    $0x4,%esp
  800d16:	68 28 43 80 00       	push   $0x804328
  800d1b:	68 c3 00 00 00       	push   $0xc3
  800d20:	68 7c 42 80 00       	push   $0x80427c
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
  800e00:	68 6c 43 80 00       	push   $0x80436c
  800e05:	68 cc 00 00 00       	push   $0xcc
  800e0a:	68 7c 42 80 00       	push   $0x80427c
  800e0f:	e8 54 01 00 00       	call   800f68 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	68 8c 43 80 00       	push   $0x80438c
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
  800e32:	e8 d5 18 00 00       	call   80270c <sys_getenvindex>
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
  800e9d:	e8 77 16 00 00       	call   802519 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	68 e0 43 80 00       	push   $0x8043e0
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
  800ecd:	68 08 44 80 00       	push   $0x804408
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
  800efe:	68 30 44 80 00       	push   $0x804430
  800f03:	e8 14 03 00 00       	call   80121c <cprintf>
  800f08:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f0b:	a1 20 50 80 00       	mov    0x805020,%eax
  800f10:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800f16:	83 ec 08             	sub    $0x8,%esp
  800f19:	50                   	push   %eax
  800f1a:	68 88 44 80 00       	push   $0x804488
  800f1f:	e8 f8 02 00 00       	call   80121c <cprintf>
  800f24:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800f27:	83 ec 0c             	sub    $0xc,%esp
  800f2a:	68 e0 43 80 00       	push   $0x8043e0
  800f2f:	e8 e8 02 00 00       	call   80121c <cprintf>
  800f34:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800f37:	e8 f7 15 00 00       	call   802533 <sys_enable_interrupt>

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
  800f4f:	e8 84 17 00 00       	call   8026d8 <sys_destroy_env>
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
  800f60:	e8 d9 17 00 00       	call   80273e <sys_exit_env>
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
  800f89:	68 9c 44 80 00       	push   $0x80449c
  800f8e:	e8 89 02 00 00       	call   80121c <cprintf>
  800f93:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800f96:	a1 00 50 80 00       	mov    0x805000,%eax
  800f9b:	ff 75 0c             	pushl  0xc(%ebp)
  800f9e:	ff 75 08             	pushl  0x8(%ebp)
  800fa1:	50                   	push   %eax
  800fa2:	68 a1 44 80 00       	push   $0x8044a1
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
  800fc6:	68 bd 44 80 00       	push   $0x8044bd
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
  800ff2:	68 c0 44 80 00       	push   $0x8044c0
  800ff7:	6a 26                	push   $0x26
  800ff9:	68 0c 45 80 00       	push   $0x80450c
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
  8010c4:	68 18 45 80 00       	push   $0x804518
  8010c9:	6a 3a                	push   $0x3a
  8010cb:	68 0c 45 80 00       	push   $0x80450c
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
  801134:	68 6c 45 80 00       	push   $0x80456c
  801139:	6a 44                	push   $0x44
  80113b:	68 0c 45 80 00       	push   $0x80450c
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
  80118e:	e8 d8 11 00 00       	call   80236b <sys_cputs>
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
  801205:	e8 61 11 00 00       	call   80236b <sys_cputs>
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
  80124f:	e8 c5 12 00 00       	call   802519 <sys_disable_interrupt>
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
  80126f:	e8 bf 12 00 00       	call   802533 <sys_enable_interrupt>
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
  8012b9:	e8 32 2d 00 00       	call   803ff0 <__udivdi3>
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
  801309:	e8 f2 2d 00 00       	call   804100 <__umoddi3>
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	05 d4 47 80 00       	add    $0x8047d4,%eax
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
  801464:	8b 04 85 f8 47 80 00 	mov    0x8047f8(,%eax,4),%eax
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
  801545:	8b 34 9d 40 46 80 00 	mov    0x804640(,%ebx,4),%esi
  80154c:	85 f6                	test   %esi,%esi
  80154e:	75 19                	jne    801569 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801550:	53                   	push   %ebx
  801551:	68 e5 47 80 00       	push   $0x8047e5
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
  80156a:	68 ee 47 80 00       	push   $0x8047ee
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
  801597:	be f1 47 80 00       	mov    $0x8047f1,%esi
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
  801fbd:	68 50 49 80 00       	push   $0x804950
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
  80208d:	e8 1d 04 00 00       	call   8024af <sys_allocate_chunk>
  802092:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802095:	a1 20 51 80 00       	mov    0x805120,%eax
  80209a:	83 ec 0c             	sub    $0xc,%esp
  80209d:	50                   	push   %eax
  80209e:	e8 92 0a 00 00       	call   802b35 <initialize_MemBlocksList>
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
  8020cb:	68 75 49 80 00       	push   $0x804975
  8020d0:	6a 33                	push   $0x33
  8020d2:	68 93 49 80 00       	push   $0x804993
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
  80214a:	68 a0 49 80 00       	push   $0x8049a0
  80214f:	6a 34                	push   $0x34
  802151:	68 93 49 80 00       	push   $0x804993
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
  8021bf:	68 c4 49 80 00       	push   $0x8049c4
  8021c4:	6a 46                	push   $0x46
  8021c6:	68 93 49 80 00       	push   $0x804993
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
  8021db:	68 ec 49 80 00       	push   $0x8049ec
  8021e0:	6a 61                	push   $0x61
  8021e2:	68 93 49 80 00       	push   $0x804993
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
  802201:	75 07                	jne    80220a <smalloc+0x1e>
  802203:	b8 00 00 00 00       	mov    $0x0,%eax
  802208:	eb 7c                	jmp    802286 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80220a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802211:	8b 55 0c             	mov    0xc(%ebp),%edx
  802214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802217:	01 d0                	add    %edx,%eax
  802219:	48                   	dec    %eax
  80221a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80221d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802220:	ba 00 00 00 00       	mov    $0x0,%edx
  802225:	f7 75 f0             	divl   -0x10(%ebp)
  802228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222b:	29 d0                	sub    %edx,%eax
  80222d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  802230:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802237:	e8 41 06 00 00       	call   80287d <sys_isUHeapPlacementStrategyFIRSTFIT>
  80223c:	85 c0                	test   %eax,%eax
  80223e:	74 11                	je     802251 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  802240:	83 ec 0c             	sub    $0xc,%esp
  802243:	ff 75 e8             	pushl  -0x18(%ebp)
  802246:	e8 ac 0c 00 00       	call   802ef7 <alloc_block_FF>
  80224b:	83 c4 10             	add    $0x10,%esp
  80224e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  802251:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802255:	74 2a                	je     802281 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  802257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225a:	8b 40 08             	mov    0x8(%eax),%eax
  80225d:	89 c2                	mov    %eax,%edx
  80225f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802263:	52                   	push   %edx
  802264:	50                   	push   %eax
  802265:	ff 75 0c             	pushl  0xc(%ebp)
  802268:	ff 75 08             	pushl  0x8(%ebp)
  80226b:	e8 92 03 00 00       	call   802602 <sys_createSharedObject>
  802270:	83 c4 10             	add    $0x10,%esp
  802273:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  802276:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80227a:	74 05                	je     802281 <smalloc+0x95>
			return (void*)virtual_address;
  80227c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80227f:	eb 05                	jmp    802286 <smalloc+0x9a>
	}
	return NULL;
  802281:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80228e:	e8 13 fd ff ff       	call   801fa6 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802293:	83 ec 04             	sub    $0x4,%esp
  802296:	68 10 4a 80 00       	push   $0x804a10
  80229b:	68 a2 00 00 00       	push   $0xa2
  8022a0:	68 93 49 80 00       	push   $0x804993
  8022a5:	e8 be ec ff ff       	call   800f68 <_panic>

008022aa <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022b0:	e8 f1 fc ff ff       	call   801fa6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8022b5:	83 ec 04             	sub    $0x4,%esp
  8022b8:	68 34 4a 80 00       	push   $0x804a34
  8022bd:	68 e6 00 00 00       	push   $0xe6
  8022c2:	68 93 49 80 00       	push   $0x804993
  8022c7:	e8 9c ec ff ff       	call   800f68 <_panic>

008022cc <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
  8022cf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8022d2:	83 ec 04             	sub    $0x4,%esp
  8022d5:	68 5c 4a 80 00       	push   $0x804a5c
  8022da:	68 fa 00 00 00       	push   $0xfa
  8022df:	68 93 49 80 00       	push   $0x804993
  8022e4:	e8 7f ec ff ff       	call   800f68 <_panic>

008022e9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
  8022ec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8022ef:	83 ec 04             	sub    $0x4,%esp
  8022f2:	68 80 4a 80 00       	push   $0x804a80
  8022f7:	68 05 01 00 00       	push   $0x105
  8022fc:	68 93 49 80 00       	push   $0x804993
  802301:	e8 62 ec ff ff       	call   800f68 <_panic>

00802306 <shrink>:

}
void shrink(uint32 newSize)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80230c:	83 ec 04             	sub    $0x4,%esp
  80230f:	68 80 4a 80 00       	push   $0x804a80
  802314:	68 0a 01 00 00       	push   $0x10a
  802319:	68 93 49 80 00       	push   $0x804993
  80231e:	e8 45 ec ff ff       	call   800f68 <_panic>

00802323 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
  802326:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802329:	83 ec 04             	sub    $0x4,%esp
  80232c:	68 80 4a 80 00       	push   $0x804a80
  802331:	68 0f 01 00 00       	push   $0x10f
  802336:	68 93 49 80 00       	push   $0x804993
  80233b:	e8 28 ec ff ff       	call   800f68 <_panic>

00802340 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	57                   	push   %edi
  802344:	56                   	push   %esi
  802345:	53                   	push   %ebx
  802346:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802352:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802355:	8b 7d 18             	mov    0x18(%ebp),%edi
  802358:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80235b:	cd 30                	int    $0x30
  80235d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802360:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802363:	83 c4 10             	add    $0x10,%esp
  802366:	5b                   	pop    %ebx
  802367:	5e                   	pop    %esi
  802368:	5f                   	pop    %edi
  802369:	5d                   	pop    %ebp
  80236a:	c3                   	ret    

0080236b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	83 ec 04             	sub    $0x4,%esp
  802371:	8b 45 10             	mov    0x10(%ebp),%eax
  802374:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802377:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	52                   	push   %edx
  802383:	ff 75 0c             	pushl  0xc(%ebp)
  802386:	50                   	push   %eax
  802387:	6a 00                	push   $0x0
  802389:	e8 b2 ff ff ff       	call   802340 <syscall>
  80238e:	83 c4 18             	add    $0x18,%esp
}
  802391:	90                   	nop
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <sys_cgetc>:

int
sys_cgetc(void)
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 01                	push   $0x1
  8023a3:	e8 98 ff ff ff       	call   802340 <syscall>
  8023a8:	83 c4 18             	add    $0x18,%esp
}
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    

008023ad <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8023b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	52                   	push   %edx
  8023bd:	50                   	push   %eax
  8023be:	6a 05                	push   $0x5
  8023c0:	e8 7b ff ff ff       	call   802340 <syscall>
  8023c5:	83 c4 18             	add    $0x18,%esp
}
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	56                   	push   %esi
  8023ce:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8023cf:	8b 75 18             	mov    0x18(%ebp),%esi
  8023d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	56                   	push   %esi
  8023df:	53                   	push   %ebx
  8023e0:	51                   	push   %ecx
  8023e1:	52                   	push   %edx
  8023e2:	50                   	push   %eax
  8023e3:	6a 06                	push   $0x6
  8023e5:	e8 56 ff ff ff       	call   802340 <syscall>
  8023ea:	83 c4 18             	add    $0x18,%esp
}
  8023ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023f0:	5b                   	pop    %ebx
  8023f1:	5e                   	pop    %esi
  8023f2:	5d                   	pop    %ebp
  8023f3:	c3                   	ret    

008023f4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8023f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	52                   	push   %edx
  802404:	50                   	push   %eax
  802405:	6a 07                	push   $0x7
  802407:	e8 34 ff ff ff       	call   802340 <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	ff 75 0c             	pushl  0xc(%ebp)
  80241d:	ff 75 08             	pushl  0x8(%ebp)
  802420:	6a 08                	push   $0x8
  802422:	e8 19 ff ff ff       	call   802340 <syscall>
  802427:	83 c4 18             	add    $0x18,%esp
}
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 09                	push   $0x9
  80243b:	e8 00 ff ff ff       	call   802340 <syscall>
  802440:	83 c4 18             	add    $0x18,%esp
}
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 0a                	push   $0xa
  802454:	e8 e7 fe ff ff       	call   802340 <syscall>
  802459:	83 c4 18             	add    $0x18,%esp
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 0b                	push   $0xb
  80246d:	e8 ce fe ff ff       	call   802340 <syscall>
  802472:	83 c4 18             	add    $0x18,%esp
}
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	ff 75 0c             	pushl  0xc(%ebp)
  802483:	ff 75 08             	pushl  0x8(%ebp)
  802486:	6a 0f                	push   $0xf
  802488:	e8 b3 fe ff ff       	call   802340 <syscall>
  80248d:	83 c4 18             	add    $0x18,%esp
	return;
  802490:	90                   	nop
}
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	ff 75 0c             	pushl  0xc(%ebp)
  80249f:	ff 75 08             	pushl  0x8(%ebp)
  8024a2:	6a 10                	push   $0x10
  8024a4:	e8 97 fe ff ff       	call   802340 <syscall>
  8024a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ac:	90                   	nop
}
  8024ad:	c9                   	leave  
  8024ae:	c3                   	ret    

008024af <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	ff 75 10             	pushl  0x10(%ebp)
  8024b9:	ff 75 0c             	pushl  0xc(%ebp)
  8024bc:	ff 75 08             	pushl  0x8(%ebp)
  8024bf:	6a 11                	push   $0x11
  8024c1:	e8 7a fe ff ff       	call   802340 <syscall>
  8024c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c9:	90                   	nop
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 0c                	push   $0xc
  8024db:	e8 60 fe ff ff       	call   802340 <syscall>
  8024e0:	83 c4 18             	add    $0x18,%esp
}
  8024e3:	c9                   	leave  
  8024e4:	c3                   	ret    

008024e5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	ff 75 08             	pushl  0x8(%ebp)
  8024f3:	6a 0d                	push   $0xd
  8024f5:	e8 46 fe ff ff       	call   802340 <syscall>
  8024fa:	83 c4 18             	add    $0x18,%esp
}
  8024fd:	c9                   	leave  
  8024fe:	c3                   	ret    

008024ff <sys_scarce_memory>:

void sys_scarce_memory()
{
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 0e                	push   $0xe
  80250e:	e8 2d fe ff ff       	call   802340 <syscall>
  802513:	83 c4 18             	add    $0x18,%esp
}
  802516:	90                   	nop
  802517:	c9                   	leave  
  802518:	c3                   	ret    

00802519 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 13                	push   $0x13
  802528:	e8 13 fe ff ff       	call   802340 <syscall>
  80252d:	83 c4 18             	add    $0x18,%esp
}
  802530:	90                   	nop
  802531:	c9                   	leave  
  802532:	c3                   	ret    

00802533 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	6a 14                	push   $0x14
  802542:	e8 f9 fd ff ff       	call   802340 <syscall>
  802547:	83 c4 18             	add    $0x18,%esp
}
  80254a:	90                   	nop
  80254b:	c9                   	leave  
  80254c:	c3                   	ret    

0080254d <sys_cputc>:


void
sys_cputc(const char c)
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
  802550:	83 ec 04             	sub    $0x4,%esp
  802553:	8b 45 08             	mov    0x8(%ebp),%eax
  802556:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802559:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	50                   	push   %eax
  802566:	6a 15                	push   $0x15
  802568:	e8 d3 fd ff ff       	call   802340 <syscall>
  80256d:	83 c4 18             	add    $0x18,%esp
}
  802570:	90                   	nop
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 16                	push   $0x16
  802582:	e8 b9 fd ff ff       	call   802340 <syscall>
  802587:	83 c4 18             	add    $0x18,%esp
}
  80258a:	90                   	nop
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802590:	8b 45 08             	mov    0x8(%ebp),%eax
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	ff 75 0c             	pushl  0xc(%ebp)
  80259c:	50                   	push   %eax
  80259d:	6a 17                	push   $0x17
  80259f:	e8 9c fd ff ff       	call   802340 <syscall>
  8025a4:	83 c4 18             	add    $0x18,%esp
}
  8025a7:	c9                   	leave  
  8025a8:	c3                   	ret    

008025a9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025af:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	52                   	push   %edx
  8025b9:	50                   	push   %eax
  8025ba:	6a 1a                	push   $0x1a
  8025bc:	e8 7f fd ff ff       	call   802340 <syscall>
  8025c1:	83 c4 18             	add    $0x18,%esp
}
  8025c4:	c9                   	leave  
  8025c5:	c3                   	ret    

008025c6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025c6:	55                   	push   %ebp
  8025c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	52                   	push   %edx
  8025d6:	50                   	push   %eax
  8025d7:	6a 18                	push   $0x18
  8025d9:	e8 62 fd ff ff       	call   802340 <syscall>
  8025de:	83 c4 18             	add    $0x18,%esp
}
  8025e1:	90                   	nop
  8025e2:	c9                   	leave  
  8025e3:	c3                   	ret    

008025e4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025e4:	55                   	push   %ebp
  8025e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	52                   	push   %edx
  8025f4:	50                   	push   %eax
  8025f5:	6a 19                	push   $0x19
  8025f7:	e8 44 fd ff ff       	call   802340 <syscall>
  8025fc:	83 c4 18             	add    $0x18,%esp
}
  8025ff:	90                   	nop
  802600:	c9                   	leave  
  802601:	c3                   	ret    

00802602 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
  802605:	83 ec 04             	sub    $0x4,%esp
  802608:	8b 45 10             	mov    0x10(%ebp),%eax
  80260b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80260e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802611:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802615:	8b 45 08             	mov    0x8(%ebp),%eax
  802618:	6a 00                	push   $0x0
  80261a:	51                   	push   %ecx
  80261b:	52                   	push   %edx
  80261c:	ff 75 0c             	pushl  0xc(%ebp)
  80261f:	50                   	push   %eax
  802620:	6a 1b                	push   $0x1b
  802622:	e8 19 fd ff ff       	call   802340 <syscall>
  802627:	83 c4 18             	add    $0x18,%esp
}
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80262f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802632:	8b 45 08             	mov    0x8(%ebp),%eax
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	52                   	push   %edx
  80263c:	50                   	push   %eax
  80263d:	6a 1c                	push   $0x1c
  80263f:	e8 fc fc ff ff       	call   802340 <syscall>
  802644:	83 c4 18             	add    $0x18,%esp
}
  802647:	c9                   	leave  
  802648:	c3                   	ret    

00802649 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802649:	55                   	push   %ebp
  80264a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80264c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80264f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802652:	8b 45 08             	mov    0x8(%ebp),%eax
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	51                   	push   %ecx
  80265a:	52                   	push   %edx
  80265b:	50                   	push   %eax
  80265c:	6a 1d                	push   $0x1d
  80265e:	e8 dd fc ff ff       	call   802340 <syscall>
  802663:	83 c4 18             	add    $0x18,%esp
}
  802666:	c9                   	leave  
  802667:	c3                   	ret    

00802668 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802668:	55                   	push   %ebp
  802669:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80266b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266e:	8b 45 08             	mov    0x8(%ebp),%eax
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	52                   	push   %edx
  802678:	50                   	push   %eax
  802679:	6a 1e                	push   $0x1e
  80267b:	e8 c0 fc ff ff       	call   802340 <syscall>
  802680:	83 c4 18             	add    $0x18,%esp
}
  802683:	c9                   	leave  
  802684:	c3                   	ret    

00802685 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802685:	55                   	push   %ebp
  802686:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	6a 1f                	push   $0x1f
  802694:	e8 a7 fc ff ff       	call   802340 <syscall>
  802699:	83 c4 18             	add    $0x18,%esp
}
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a4:	6a 00                	push   $0x0
  8026a6:	ff 75 14             	pushl  0x14(%ebp)
  8026a9:	ff 75 10             	pushl  0x10(%ebp)
  8026ac:	ff 75 0c             	pushl  0xc(%ebp)
  8026af:	50                   	push   %eax
  8026b0:	6a 20                	push   $0x20
  8026b2:	e8 89 fc ff ff       	call   802340 <syscall>
  8026b7:	83 c4 18             	add    $0x18,%esp
}
  8026ba:	c9                   	leave  
  8026bb:	c3                   	ret    

008026bc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8026bc:	55                   	push   %ebp
  8026bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	50                   	push   %eax
  8026cb:	6a 21                	push   $0x21
  8026cd:	e8 6e fc ff ff       	call   802340 <syscall>
  8026d2:	83 c4 18             	add    $0x18,%esp
}
  8026d5:	90                   	nop
  8026d6:	c9                   	leave  
  8026d7:	c3                   	ret    

008026d8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8026d8:	55                   	push   %ebp
  8026d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 00                	push   $0x0
  8026e6:	50                   	push   %eax
  8026e7:	6a 22                	push   $0x22
  8026e9:	e8 52 fc ff ff       	call   802340 <syscall>
  8026ee:	83 c4 18             	add    $0x18,%esp
}
  8026f1:	c9                   	leave  
  8026f2:	c3                   	ret    

008026f3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8026f3:	55                   	push   %ebp
  8026f4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8026f6:	6a 00                	push   $0x0
  8026f8:	6a 00                	push   $0x0
  8026fa:	6a 00                	push   $0x0
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 02                	push   $0x2
  802702:	e8 39 fc ff ff       	call   802340 <syscall>
  802707:	83 c4 18             	add    $0x18,%esp
}
  80270a:	c9                   	leave  
  80270b:	c3                   	ret    

0080270c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80270c:	55                   	push   %ebp
  80270d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	6a 00                	push   $0x0
  802715:	6a 00                	push   $0x0
  802717:	6a 00                	push   $0x0
  802719:	6a 03                	push   $0x3
  80271b:	e8 20 fc ff ff       	call   802340 <syscall>
  802720:	83 c4 18             	add    $0x18,%esp
}
  802723:	c9                   	leave  
  802724:	c3                   	ret    

00802725 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802725:	55                   	push   %ebp
  802726:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802728:	6a 00                	push   $0x0
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	6a 04                	push   $0x4
  802734:	e8 07 fc ff ff       	call   802340 <syscall>
  802739:	83 c4 18             	add    $0x18,%esp
}
  80273c:	c9                   	leave  
  80273d:	c3                   	ret    

0080273e <sys_exit_env>:


void sys_exit_env(void)
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	6a 00                	push   $0x0
  802747:	6a 00                	push   $0x0
  802749:	6a 00                	push   $0x0
  80274b:	6a 23                	push   $0x23
  80274d:	e8 ee fb ff ff       	call   802340 <syscall>
  802752:	83 c4 18             	add    $0x18,%esp
}
  802755:	90                   	nop
  802756:	c9                   	leave  
  802757:	c3                   	ret    

00802758 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802758:	55                   	push   %ebp
  802759:	89 e5                	mov    %esp,%ebp
  80275b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80275e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802761:	8d 50 04             	lea    0x4(%eax),%edx
  802764:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	52                   	push   %edx
  80276e:	50                   	push   %eax
  80276f:	6a 24                	push   $0x24
  802771:	e8 ca fb ff ff       	call   802340 <syscall>
  802776:	83 c4 18             	add    $0x18,%esp
	return result;
  802779:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80277c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80277f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802782:	89 01                	mov    %eax,(%ecx)
  802784:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802787:	8b 45 08             	mov    0x8(%ebp),%eax
  80278a:	c9                   	leave  
  80278b:	c2 04 00             	ret    $0x4

0080278e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80278e:	55                   	push   %ebp
  80278f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802791:	6a 00                	push   $0x0
  802793:	6a 00                	push   $0x0
  802795:	ff 75 10             	pushl  0x10(%ebp)
  802798:	ff 75 0c             	pushl  0xc(%ebp)
  80279b:	ff 75 08             	pushl  0x8(%ebp)
  80279e:	6a 12                	push   $0x12
  8027a0:	e8 9b fb ff ff       	call   802340 <syscall>
  8027a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8027a8:	90                   	nop
}
  8027a9:	c9                   	leave  
  8027aa:	c3                   	ret    

008027ab <sys_rcr2>:
uint32 sys_rcr2()
{
  8027ab:	55                   	push   %ebp
  8027ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8027ae:	6a 00                	push   $0x0
  8027b0:	6a 00                	push   $0x0
  8027b2:	6a 00                	push   $0x0
  8027b4:	6a 00                	push   $0x0
  8027b6:	6a 00                	push   $0x0
  8027b8:	6a 25                	push   $0x25
  8027ba:	e8 81 fb ff ff       	call   802340 <syscall>
  8027bf:	83 c4 18             	add    $0x18,%esp
}
  8027c2:	c9                   	leave  
  8027c3:	c3                   	ret    

008027c4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
  8027c7:	83 ec 04             	sub    $0x4,%esp
  8027ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027d0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027d4:	6a 00                	push   $0x0
  8027d6:	6a 00                	push   $0x0
  8027d8:	6a 00                	push   $0x0
  8027da:	6a 00                	push   $0x0
  8027dc:	50                   	push   %eax
  8027dd:	6a 26                	push   $0x26
  8027df:	e8 5c fb ff ff       	call   802340 <syscall>
  8027e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8027e7:	90                   	nop
}
  8027e8:	c9                   	leave  
  8027e9:	c3                   	ret    

008027ea <rsttst>:
void rsttst()
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 28                	push   $0x28
  8027f9:	e8 42 fb ff ff       	call   802340 <syscall>
  8027fe:	83 c4 18             	add    $0x18,%esp
	return ;
  802801:	90                   	nop
}
  802802:	c9                   	leave  
  802803:	c3                   	ret    

00802804 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802804:	55                   	push   %ebp
  802805:	89 e5                	mov    %esp,%ebp
  802807:	83 ec 04             	sub    $0x4,%esp
  80280a:	8b 45 14             	mov    0x14(%ebp),%eax
  80280d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802810:	8b 55 18             	mov    0x18(%ebp),%edx
  802813:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802817:	52                   	push   %edx
  802818:	50                   	push   %eax
  802819:	ff 75 10             	pushl  0x10(%ebp)
  80281c:	ff 75 0c             	pushl  0xc(%ebp)
  80281f:	ff 75 08             	pushl  0x8(%ebp)
  802822:	6a 27                	push   $0x27
  802824:	e8 17 fb ff ff       	call   802340 <syscall>
  802829:	83 c4 18             	add    $0x18,%esp
	return ;
  80282c:	90                   	nop
}
  80282d:	c9                   	leave  
  80282e:	c3                   	ret    

0080282f <chktst>:
void chktst(uint32 n)
{
  80282f:	55                   	push   %ebp
  802830:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802832:	6a 00                	push   $0x0
  802834:	6a 00                	push   $0x0
  802836:	6a 00                	push   $0x0
  802838:	6a 00                	push   $0x0
  80283a:	ff 75 08             	pushl  0x8(%ebp)
  80283d:	6a 29                	push   $0x29
  80283f:	e8 fc fa ff ff       	call   802340 <syscall>
  802844:	83 c4 18             	add    $0x18,%esp
	return ;
  802847:	90                   	nop
}
  802848:	c9                   	leave  
  802849:	c3                   	ret    

0080284a <inctst>:

void inctst()
{
  80284a:	55                   	push   %ebp
  80284b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	6a 00                	push   $0x0
  802857:	6a 2a                	push   $0x2a
  802859:	e8 e2 fa ff ff       	call   802340 <syscall>
  80285e:	83 c4 18             	add    $0x18,%esp
	return ;
  802861:	90                   	nop
}
  802862:	c9                   	leave  
  802863:	c3                   	ret    

00802864 <gettst>:
uint32 gettst()
{
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802867:	6a 00                	push   $0x0
  802869:	6a 00                	push   $0x0
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	6a 2b                	push   $0x2b
  802873:	e8 c8 fa ff ff       	call   802340 <syscall>
  802878:	83 c4 18             	add    $0x18,%esp
}
  80287b:	c9                   	leave  
  80287c:	c3                   	ret    

0080287d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80287d:	55                   	push   %ebp
  80287e:	89 e5                	mov    %esp,%ebp
  802880:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802883:	6a 00                	push   $0x0
  802885:	6a 00                	push   $0x0
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	6a 2c                	push   $0x2c
  80288f:	e8 ac fa ff ff       	call   802340 <syscall>
  802894:	83 c4 18             	add    $0x18,%esp
  802897:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80289a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80289e:	75 07                	jne    8028a7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8028a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8028a5:	eb 05                	jmp    8028ac <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8028a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ac:	c9                   	leave  
  8028ad:	c3                   	ret    

008028ae <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8028ae:	55                   	push   %ebp
  8028af:	89 e5                	mov    %esp,%ebp
  8028b1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028b4:	6a 00                	push   $0x0
  8028b6:	6a 00                	push   $0x0
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 2c                	push   $0x2c
  8028c0:	e8 7b fa ff ff       	call   802340 <syscall>
  8028c5:	83 c4 18             	add    $0x18,%esp
  8028c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8028cb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8028cf:	75 07                	jne    8028d8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8028d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d6:	eb 05                	jmp    8028dd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8028d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028dd:	c9                   	leave  
  8028de:	c3                   	ret    

008028df <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8028df:	55                   	push   %ebp
  8028e0:	89 e5                	mov    %esp,%ebp
  8028e2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 00                	push   $0x0
  8028e9:	6a 00                	push   $0x0
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 00                	push   $0x0
  8028ef:	6a 2c                	push   $0x2c
  8028f1:	e8 4a fa ff ff       	call   802340 <syscall>
  8028f6:	83 c4 18             	add    $0x18,%esp
  8028f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8028fc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802900:	75 07                	jne    802909 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802902:	b8 01 00 00 00       	mov    $0x1,%eax
  802907:	eb 05                	jmp    80290e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802909:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80290e:	c9                   	leave  
  80290f:	c3                   	ret    

00802910 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802910:	55                   	push   %ebp
  802911:	89 e5                	mov    %esp,%ebp
  802913:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802916:	6a 00                	push   $0x0
  802918:	6a 00                	push   $0x0
  80291a:	6a 00                	push   $0x0
  80291c:	6a 00                	push   $0x0
  80291e:	6a 00                	push   $0x0
  802920:	6a 2c                	push   $0x2c
  802922:	e8 19 fa ff ff       	call   802340 <syscall>
  802927:	83 c4 18             	add    $0x18,%esp
  80292a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80292d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802931:	75 07                	jne    80293a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802933:	b8 01 00 00 00       	mov    $0x1,%eax
  802938:	eb 05                	jmp    80293f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80293a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80293f:	c9                   	leave  
  802940:	c3                   	ret    

00802941 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802941:	55                   	push   %ebp
  802942:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802944:	6a 00                	push   $0x0
  802946:	6a 00                	push   $0x0
  802948:	6a 00                	push   $0x0
  80294a:	6a 00                	push   $0x0
  80294c:	ff 75 08             	pushl  0x8(%ebp)
  80294f:	6a 2d                	push   $0x2d
  802951:	e8 ea f9 ff ff       	call   802340 <syscall>
  802956:	83 c4 18             	add    $0x18,%esp
	return ;
  802959:	90                   	nop
}
  80295a:	c9                   	leave  
  80295b:	c3                   	ret    

0080295c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80295c:	55                   	push   %ebp
  80295d:	89 e5                	mov    %esp,%ebp
  80295f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802960:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802963:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802966:	8b 55 0c             	mov    0xc(%ebp),%edx
  802969:	8b 45 08             	mov    0x8(%ebp),%eax
  80296c:	6a 00                	push   $0x0
  80296e:	53                   	push   %ebx
  80296f:	51                   	push   %ecx
  802970:	52                   	push   %edx
  802971:	50                   	push   %eax
  802972:	6a 2e                	push   $0x2e
  802974:	e8 c7 f9 ff ff       	call   802340 <syscall>
  802979:	83 c4 18             	add    $0x18,%esp
}
  80297c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80297f:	c9                   	leave  
  802980:	c3                   	ret    

00802981 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802981:	55                   	push   %ebp
  802982:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802984:	8b 55 0c             	mov    0xc(%ebp),%edx
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	6a 00                	push   $0x0
  80298c:	6a 00                	push   $0x0
  80298e:	6a 00                	push   $0x0
  802990:	52                   	push   %edx
  802991:	50                   	push   %eax
  802992:	6a 2f                	push   $0x2f
  802994:	e8 a7 f9 ff ff       	call   802340 <syscall>
  802999:	83 c4 18             	add    $0x18,%esp
}
  80299c:	c9                   	leave  
  80299d:	c3                   	ret    

0080299e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80299e:	55                   	push   %ebp
  80299f:	89 e5                	mov    %esp,%ebp
  8029a1:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8029a4:	83 ec 0c             	sub    $0xc,%esp
  8029a7:	68 90 4a 80 00       	push   $0x804a90
  8029ac:	e8 6b e8 ff ff       	call   80121c <cprintf>
  8029b1:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8029b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8029bb:	83 ec 0c             	sub    $0xc,%esp
  8029be:	68 bc 4a 80 00       	push   $0x804abc
  8029c3:	e8 54 e8 ff ff       	call   80121c <cprintf>
  8029c8:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8029cb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029cf:	a1 38 51 80 00       	mov    0x805138,%eax
  8029d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d7:	eb 56                	jmp    802a2f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8029d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029dd:	74 1c                	je     8029fb <print_mem_block_lists+0x5d>
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 50 08             	mov    0x8(%eax),%edx
  8029e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e8:	8b 48 08             	mov    0x8(%eax),%ecx
  8029eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f1:	01 c8                	add    %ecx,%eax
  8029f3:	39 c2                	cmp    %eax,%edx
  8029f5:	73 04                	jae    8029fb <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8029f7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 50 08             	mov    0x8(%eax),%edx
  802a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a04:	8b 40 0c             	mov    0xc(%eax),%eax
  802a07:	01 c2                	add    %eax,%edx
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 40 08             	mov    0x8(%eax),%eax
  802a0f:	83 ec 04             	sub    $0x4,%esp
  802a12:	52                   	push   %edx
  802a13:	50                   	push   %eax
  802a14:	68 d1 4a 80 00       	push   $0x804ad1
  802a19:	e8 fe e7 ff ff       	call   80121c <cprintf>
  802a1e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a27:	a1 40 51 80 00       	mov    0x805140,%eax
  802a2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a33:	74 07                	je     802a3c <print_mem_block_lists+0x9e>
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 00                	mov    (%eax),%eax
  802a3a:	eb 05                	jmp    802a41 <print_mem_block_lists+0xa3>
  802a3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a41:	a3 40 51 80 00       	mov    %eax,0x805140
  802a46:	a1 40 51 80 00       	mov    0x805140,%eax
  802a4b:	85 c0                	test   %eax,%eax
  802a4d:	75 8a                	jne    8029d9 <print_mem_block_lists+0x3b>
  802a4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a53:	75 84                	jne    8029d9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802a55:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a59:	75 10                	jne    802a6b <print_mem_block_lists+0xcd>
  802a5b:	83 ec 0c             	sub    $0xc,%esp
  802a5e:	68 e0 4a 80 00       	push   $0x804ae0
  802a63:	e8 b4 e7 ff ff       	call   80121c <cprintf>
  802a68:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802a6b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802a72:	83 ec 0c             	sub    $0xc,%esp
  802a75:	68 04 4b 80 00       	push   $0x804b04
  802a7a:	e8 9d e7 ff ff       	call   80121c <cprintf>
  802a7f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802a82:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802a86:	a1 40 50 80 00       	mov    0x805040,%eax
  802a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8e:	eb 56                	jmp    802ae6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802a90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a94:	74 1c                	je     802ab2 <print_mem_block_lists+0x114>
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	8b 50 08             	mov    0x8(%eax),%edx
  802a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9f:	8b 48 08             	mov    0x8(%eax),%ecx
  802aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa5:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa8:	01 c8                	add    %ecx,%eax
  802aaa:	39 c2                	cmp    %eax,%edx
  802aac:	73 04                	jae    802ab2 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802aae:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 50 08             	mov    0x8(%eax),%edx
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 40 0c             	mov    0xc(%eax),%eax
  802abe:	01 c2                	add    %eax,%edx
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 40 08             	mov    0x8(%eax),%eax
  802ac6:	83 ec 04             	sub    $0x4,%esp
  802ac9:	52                   	push   %edx
  802aca:	50                   	push   %eax
  802acb:	68 d1 4a 80 00       	push   $0x804ad1
  802ad0:	e8 47 e7 ff ff       	call   80121c <cprintf>
  802ad5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802ade:	a1 48 50 80 00       	mov    0x805048,%eax
  802ae3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aea:	74 07                	je     802af3 <print_mem_block_lists+0x155>
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 00                	mov    (%eax),%eax
  802af1:	eb 05                	jmp    802af8 <print_mem_block_lists+0x15a>
  802af3:	b8 00 00 00 00       	mov    $0x0,%eax
  802af8:	a3 48 50 80 00       	mov    %eax,0x805048
  802afd:	a1 48 50 80 00       	mov    0x805048,%eax
  802b02:	85 c0                	test   %eax,%eax
  802b04:	75 8a                	jne    802a90 <print_mem_block_lists+0xf2>
  802b06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0a:	75 84                	jne    802a90 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802b0c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802b10:	75 10                	jne    802b22 <print_mem_block_lists+0x184>
  802b12:	83 ec 0c             	sub    $0xc,%esp
  802b15:	68 1c 4b 80 00       	push   $0x804b1c
  802b1a:	e8 fd e6 ff ff       	call   80121c <cprintf>
  802b1f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802b22:	83 ec 0c             	sub    $0xc,%esp
  802b25:	68 90 4a 80 00       	push   $0x804a90
  802b2a:	e8 ed e6 ff ff       	call   80121c <cprintf>
  802b2f:	83 c4 10             	add    $0x10,%esp

}
  802b32:	90                   	nop
  802b33:	c9                   	leave  
  802b34:	c3                   	ret    

00802b35 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802b35:	55                   	push   %ebp
  802b36:	89 e5                	mov    %esp,%ebp
  802b38:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802b3b:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802b42:	00 00 00 
  802b45:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802b4c:	00 00 00 
  802b4f:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802b56:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802b59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b60:	e9 9e 00 00 00       	jmp    802c03 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802b65:	a1 50 50 80 00       	mov    0x805050,%eax
  802b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b6d:	c1 e2 04             	shl    $0x4,%edx
  802b70:	01 d0                	add    %edx,%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	75 14                	jne    802b8a <initialize_MemBlocksList+0x55>
  802b76:	83 ec 04             	sub    $0x4,%esp
  802b79:	68 44 4b 80 00       	push   $0x804b44
  802b7e:	6a 46                	push   $0x46
  802b80:	68 67 4b 80 00       	push   $0x804b67
  802b85:	e8 de e3 ff ff       	call   800f68 <_panic>
  802b8a:	a1 50 50 80 00       	mov    0x805050,%eax
  802b8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b92:	c1 e2 04             	shl    $0x4,%edx
  802b95:	01 d0                	add    %edx,%eax
  802b97:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802b9d:	89 10                	mov    %edx,(%eax)
  802b9f:	8b 00                	mov    (%eax),%eax
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	74 18                	je     802bbd <initialize_MemBlocksList+0x88>
  802ba5:	a1 48 51 80 00       	mov    0x805148,%eax
  802baa:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802bb0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802bb3:	c1 e1 04             	shl    $0x4,%ecx
  802bb6:	01 ca                	add    %ecx,%edx
  802bb8:	89 50 04             	mov    %edx,0x4(%eax)
  802bbb:	eb 12                	jmp    802bcf <initialize_MemBlocksList+0x9a>
  802bbd:	a1 50 50 80 00       	mov    0x805050,%eax
  802bc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc5:	c1 e2 04             	shl    $0x4,%edx
  802bc8:	01 d0                	add    %edx,%eax
  802bca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bcf:	a1 50 50 80 00       	mov    0x805050,%eax
  802bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd7:	c1 e2 04             	shl    $0x4,%edx
  802bda:	01 d0                	add    %edx,%eax
  802bdc:	a3 48 51 80 00       	mov    %eax,0x805148
  802be1:	a1 50 50 80 00       	mov    0x805050,%eax
  802be6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be9:	c1 e2 04             	shl    $0x4,%edx
  802bec:	01 d0                	add    %edx,%eax
  802bee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf5:	a1 54 51 80 00       	mov    0x805154,%eax
  802bfa:	40                   	inc    %eax
  802bfb:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802c00:	ff 45 f4             	incl   -0xc(%ebp)
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c09:	0f 82 56 ff ff ff    	jb     802b65 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802c0f:	90                   	nop
  802c10:	c9                   	leave  
  802c11:	c3                   	ret    

00802c12 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802c12:	55                   	push   %ebp
  802c13:	89 e5                	mov    %esp,%ebp
  802c15:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	8b 00                	mov    (%eax),%eax
  802c1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c20:	eb 19                	jmp    802c3b <find_block+0x29>
	{
		if(va==point->sva)
  802c22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c25:	8b 40 08             	mov    0x8(%eax),%eax
  802c28:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c2b:	75 05                	jne    802c32 <find_block+0x20>
		   return point;
  802c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c30:	eb 36                	jmp    802c68 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	8b 40 08             	mov    0x8(%eax),%eax
  802c38:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c3f:	74 07                	je     802c48 <find_block+0x36>
  802c41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	eb 05                	jmp    802c4d <find_block+0x3b>
  802c48:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c50:	89 42 08             	mov    %eax,0x8(%edx)
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	8b 40 08             	mov    0x8(%eax),%eax
  802c59:	85 c0                	test   %eax,%eax
  802c5b:	75 c5                	jne    802c22 <find_block+0x10>
  802c5d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c61:	75 bf                	jne    802c22 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802c63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c68:	c9                   	leave  
  802c69:	c3                   	ret    

00802c6a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802c6a:	55                   	push   %ebp
  802c6b:	89 e5                	mov    %esp,%ebp
  802c6d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802c70:	a1 40 50 80 00       	mov    0x805040,%eax
  802c75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802c78:	a1 44 50 80 00       	mov    0x805044,%eax
  802c7d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c83:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802c86:	74 24                	je     802cac <insert_sorted_allocList+0x42>
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	8b 50 08             	mov    0x8(%eax),%edx
  802c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c91:	8b 40 08             	mov    0x8(%eax),%eax
  802c94:	39 c2                	cmp    %eax,%edx
  802c96:	76 14                	jbe    802cac <insert_sorted_allocList+0x42>
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	8b 50 08             	mov    0x8(%eax),%edx
  802c9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca1:	8b 40 08             	mov    0x8(%eax),%eax
  802ca4:	39 c2                	cmp    %eax,%edx
  802ca6:	0f 82 60 01 00 00    	jb     802e0c <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802cac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cb0:	75 65                	jne    802d17 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802cb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb6:	75 14                	jne    802ccc <insert_sorted_allocList+0x62>
  802cb8:	83 ec 04             	sub    $0x4,%esp
  802cbb:	68 44 4b 80 00       	push   $0x804b44
  802cc0:	6a 6b                	push   $0x6b
  802cc2:	68 67 4b 80 00       	push   $0x804b67
  802cc7:	e8 9c e2 ff ff       	call   800f68 <_panic>
  802ccc:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	89 10                	mov    %edx,(%eax)
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	85 c0                	test   %eax,%eax
  802cde:	74 0d                	je     802ced <insert_sorted_allocList+0x83>
  802ce0:	a1 40 50 80 00       	mov    0x805040,%eax
  802ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce8:	89 50 04             	mov    %edx,0x4(%eax)
  802ceb:	eb 08                	jmp    802cf5 <insert_sorted_allocList+0x8b>
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	a3 44 50 80 00       	mov    %eax,0x805044
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	a3 40 50 80 00       	mov    %eax,0x805040
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d07:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d0c:	40                   	inc    %eax
  802d0d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802d12:	e9 dc 01 00 00       	jmp    802ef3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	8b 50 08             	mov    0x8(%eax),%edx
  802d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d20:	8b 40 08             	mov    0x8(%eax),%eax
  802d23:	39 c2                	cmp    %eax,%edx
  802d25:	77 6c                	ja     802d93 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802d27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d2b:	74 06                	je     802d33 <insert_sorted_allocList+0xc9>
  802d2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d31:	75 14                	jne    802d47 <insert_sorted_allocList+0xdd>
  802d33:	83 ec 04             	sub    $0x4,%esp
  802d36:	68 80 4b 80 00       	push   $0x804b80
  802d3b:	6a 6f                	push   $0x6f
  802d3d:	68 67 4b 80 00       	push   $0x804b67
  802d42:	e8 21 e2 ff ff       	call   800f68 <_panic>
  802d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4a:	8b 50 04             	mov    0x4(%eax),%edx
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	89 50 04             	mov    %edx,0x4(%eax)
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d59:	89 10                	mov    %edx,(%eax)
  802d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5e:	8b 40 04             	mov    0x4(%eax),%eax
  802d61:	85 c0                	test   %eax,%eax
  802d63:	74 0d                	je     802d72 <insert_sorted_allocList+0x108>
  802d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d68:	8b 40 04             	mov    0x4(%eax),%eax
  802d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d6e:	89 10                	mov    %edx,(%eax)
  802d70:	eb 08                	jmp    802d7a <insert_sorted_allocList+0x110>
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	a3 40 50 80 00       	mov    %eax,0x805040
  802d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d80:	89 50 04             	mov    %edx,0x4(%eax)
  802d83:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d88:	40                   	inc    %eax
  802d89:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802d8e:	e9 60 01 00 00       	jmp    802ef3 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	8b 50 08             	mov    0x8(%eax),%edx
  802d99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9c:	8b 40 08             	mov    0x8(%eax),%eax
  802d9f:	39 c2                	cmp    %eax,%edx
  802da1:	0f 82 4c 01 00 00    	jb     802ef3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802da7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dab:	75 14                	jne    802dc1 <insert_sorted_allocList+0x157>
  802dad:	83 ec 04             	sub    $0x4,%esp
  802db0:	68 b8 4b 80 00       	push   $0x804bb8
  802db5:	6a 73                	push   $0x73
  802db7:	68 67 4b 80 00       	push   $0x804b67
  802dbc:	e8 a7 e1 ff ff       	call   800f68 <_panic>
  802dc1:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	89 50 04             	mov    %edx,0x4(%eax)
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	8b 40 04             	mov    0x4(%eax),%eax
  802dd3:	85 c0                	test   %eax,%eax
  802dd5:	74 0c                	je     802de3 <insert_sorted_allocList+0x179>
  802dd7:	a1 44 50 80 00       	mov    0x805044,%eax
  802ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ddf:	89 10                	mov    %edx,(%eax)
  802de1:	eb 08                	jmp    802deb <insert_sorted_allocList+0x181>
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	a3 40 50 80 00       	mov    %eax,0x805040
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	a3 44 50 80 00       	mov    %eax,0x805044
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dfc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e01:	40                   	inc    %eax
  802e02:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802e07:	e9 e7 00 00 00       	jmp    802ef3 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802e12:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802e19:	a1 40 50 80 00       	mov    0x805040,%eax
  802e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e21:	e9 9d 00 00 00       	jmp    802ec3 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 00                	mov    (%eax),%eax
  802e2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	8b 50 08             	mov    0x8(%eax),%edx
  802e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e37:	8b 40 08             	mov    0x8(%eax),%eax
  802e3a:	39 c2                	cmp    %eax,%edx
  802e3c:	76 7d                	jbe    802ebb <insert_sorted_allocList+0x251>
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	8b 50 08             	mov    0x8(%eax),%edx
  802e44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e47:	8b 40 08             	mov    0x8(%eax),%eax
  802e4a:	39 c2                	cmp    %eax,%edx
  802e4c:	73 6d                	jae    802ebb <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802e4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e52:	74 06                	je     802e5a <insert_sorted_allocList+0x1f0>
  802e54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e58:	75 14                	jne    802e6e <insert_sorted_allocList+0x204>
  802e5a:	83 ec 04             	sub    $0x4,%esp
  802e5d:	68 dc 4b 80 00       	push   $0x804bdc
  802e62:	6a 7f                	push   $0x7f
  802e64:	68 67 4b 80 00       	push   $0x804b67
  802e69:	e8 fa e0 ff ff       	call   800f68 <_panic>
  802e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e71:	8b 10                	mov    (%eax),%edx
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	89 10                	mov    %edx,(%eax)
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	8b 00                	mov    (%eax),%eax
  802e7d:	85 c0                	test   %eax,%eax
  802e7f:	74 0b                	je     802e8c <insert_sorted_allocList+0x222>
  802e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e84:	8b 00                	mov    (%eax),%eax
  802e86:	8b 55 08             	mov    0x8(%ebp),%edx
  802e89:	89 50 04             	mov    %edx,0x4(%eax)
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e92:	89 10                	mov    %edx,(%eax)
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e9a:	89 50 04             	mov    %edx,0x4(%eax)
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	85 c0                	test   %eax,%eax
  802ea4:	75 08                	jne    802eae <insert_sorted_allocList+0x244>
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	a3 44 50 80 00       	mov    %eax,0x805044
  802eae:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802eb3:	40                   	inc    %eax
  802eb4:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802eb9:	eb 39                	jmp    802ef4 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802ebb:	a1 48 50 80 00       	mov    0x805048,%eax
  802ec0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ec3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec7:	74 07                	je     802ed0 <insert_sorted_allocList+0x266>
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 00                	mov    (%eax),%eax
  802ece:	eb 05                	jmp    802ed5 <insert_sorted_allocList+0x26b>
  802ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed5:	a3 48 50 80 00       	mov    %eax,0x805048
  802eda:	a1 48 50 80 00       	mov    0x805048,%eax
  802edf:	85 c0                	test   %eax,%eax
  802ee1:	0f 85 3f ff ff ff    	jne    802e26 <insert_sorted_allocList+0x1bc>
  802ee7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eeb:	0f 85 35 ff ff ff    	jne    802e26 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802ef1:	eb 01                	jmp    802ef4 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ef3:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802ef4:	90                   	nop
  802ef5:	c9                   	leave  
  802ef6:	c3                   	ret    

00802ef7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802ef7:	55                   	push   %ebp
  802ef8:	89 e5                	mov    %esp,%ebp
  802efa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802efd:	a1 38 51 80 00       	mov    0x805138,%eax
  802f02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f05:	e9 85 01 00 00       	jmp    80308f <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f10:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f13:	0f 82 6e 01 00 00    	jb     803087 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f22:	0f 85 8a 00 00 00    	jne    802fb2 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802f28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f2c:	75 17                	jne    802f45 <alloc_block_FF+0x4e>
  802f2e:	83 ec 04             	sub    $0x4,%esp
  802f31:	68 10 4c 80 00       	push   $0x804c10
  802f36:	68 93 00 00 00       	push   $0x93
  802f3b:	68 67 4b 80 00       	push   $0x804b67
  802f40:	e8 23 e0 ff ff       	call   800f68 <_panic>
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	8b 00                	mov    (%eax),%eax
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	74 10                	je     802f5e <alloc_block_FF+0x67>
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	8b 00                	mov    (%eax),%eax
  802f53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f56:	8b 52 04             	mov    0x4(%edx),%edx
  802f59:	89 50 04             	mov    %edx,0x4(%eax)
  802f5c:	eb 0b                	jmp    802f69 <alloc_block_FF+0x72>
  802f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f61:	8b 40 04             	mov    0x4(%eax),%eax
  802f64:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	8b 40 04             	mov    0x4(%eax),%eax
  802f6f:	85 c0                	test   %eax,%eax
  802f71:	74 0f                	je     802f82 <alloc_block_FF+0x8b>
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	8b 40 04             	mov    0x4(%eax),%eax
  802f79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f7c:	8b 12                	mov    (%edx),%edx
  802f7e:	89 10                	mov    %edx,(%eax)
  802f80:	eb 0a                	jmp    802f8c <alloc_block_FF+0x95>
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	8b 00                	mov    (%eax),%eax
  802f87:	a3 38 51 80 00       	mov    %eax,0x805138
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9f:	a1 44 51 80 00       	mov    0x805144,%eax
  802fa4:	48                   	dec    %eax
  802fa5:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fad:	e9 10 01 00 00       	jmp    8030c2 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fbb:	0f 86 c6 00 00 00    	jbe    803087 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fc1:	a1 48 51 80 00       	mov    0x805148,%eax
  802fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcc:	8b 50 08             	mov    0x8(%eax),%edx
  802fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd2:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd8:	8b 55 08             	mov    0x8(%ebp),%edx
  802fdb:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802fde:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fe2:	75 17                	jne    802ffb <alloc_block_FF+0x104>
  802fe4:	83 ec 04             	sub    $0x4,%esp
  802fe7:	68 10 4c 80 00       	push   $0x804c10
  802fec:	68 9b 00 00 00       	push   $0x9b
  802ff1:	68 67 4b 80 00       	push   $0x804b67
  802ff6:	e8 6d df ff ff       	call   800f68 <_panic>
  802ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffe:	8b 00                	mov    (%eax),%eax
  803000:	85 c0                	test   %eax,%eax
  803002:	74 10                	je     803014 <alloc_block_FF+0x11d>
  803004:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803007:	8b 00                	mov    (%eax),%eax
  803009:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80300c:	8b 52 04             	mov    0x4(%edx),%edx
  80300f:	89 50 04             	mov    %edx,0x4(%eax)
  803012:	eb 0b                	jmp    80301f <alloc_block_FF+0x128>
  803014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803017:	8b 40 04             	mov    0x4(%eax),%eax
  80301a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80301f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803022:	8b 40 04             	mov    0x4(%eax),%eax
  803025:	85 c0                	test   %eax,%eax
  803027:	74 0f                	je     803038 <alloc_block_FF+0x141>
  803029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302c:	8b 40 04             	mov    0x4(%eax),%eax
  80302f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803032:	8b 12                	mov    (%edx),%edx
  803034:	89 10                	mov    %edx,(%eax)
  803036:	eb 0a                	jmp    803042 <alloc_block_FF+0x14b>
  803038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303b:	8b 00                	mov    (%eax),%eax
  80303d:	a3 48 51 80 00       	mov    %eax,0x805148
  803042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803045:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80304b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803055:	a1 54 51 80 00       	mov    0x805154,%eax
  80305a:	48                   	dec    %eax
  80305b:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	8b 50 08             	mov    0x8(%eax),%edx
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	01 c2                	add    %eax,%edx
  80306b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306e:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	8b 40 0c             	mov    0xc(%eax),%eax
  803077:	2b 45 08             	sub    0x8(%ebp),%eax
  80307a:	89 c2                	mov    %eax,%edx
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  803082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803085:	eb 3b                	jmp    8030c2 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803087:	a1 40 51 80 00       	mov    0x805140,%eax
  80308c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80308f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803093:	74 07                	je     80309c <alloc_block_FF+0x1a5>
  803095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803098:	8b 00                	mov    (%eax),%eax
  80309a:	eb 05                	jmp    8030a1 <alloc_block_FF+0x1aa>
  80309c:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a1:	a3 40 51 80 00       	mov    %eax,0x805140
  8030a6:	a1 40 51 80 00       	mov    0x805140,%eax
  8030ab:	85 c0                	test   %eax,%eax
  8030ad:	0f 85 57 fe ff ff    	jne    802f0a <alloc_block_FF+0x13>
  8030b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b7:	0f 85 4d fe ff ff    	jne    802f0a <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8030bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030c2:	c9                   	leave  
  8030c3:	c3                   	ret    

008030c4 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8030c4:	55                   	push   %ebp
  8030c5:	89 e5                	mov    %esp,%ebp
  8030c7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8030ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8030d1:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d9:	e9 df 00 00 00       	jmp    8031bd <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030e7:	0f 82 c8 00 00 00    	jb     8031b5 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8030ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f6:	0f 85 8a 00 00 00    	jne    803186 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8030fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803100:	75 17                	jne    803119 <alloc_block_BF+0x55>
  803102:	83 ec 04             	sub    $0x4,%esp
  803105:	68 10 4c 80 00       	push   $0x804c10
  80310a:	68 b7 00 00 00       	push   $0xb7
  80310f:	68 67 4b 80 00       	push   $0x804b67
  803114:	e8 4f de ff ff       	call   800f68 <_panic>
  803119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311c:	8b 00                	mov    (%eax),%eax
  80311e:	85 c0                	test   %eax,%eax
  803120:	74 10                	je     803132 <alloc_block_BF+0x6e>
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	8b 00                	mov    (%eax),%eax
  803127:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80312a:	8b 52 04             	mov    0x4(%edx),%edx
  80312d:	89 50 04             	mov    %edx,0x4(%eax)
  803130:	eb 0b                	jmp    80313d <alloc_block_BF+0x79>
  803132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803135:	8b 40 04             	mov    0x4(%eax),%eax
  803138:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	8b 40 04             	mov    0x4(%eax),%eax
  803143:	85 c0                	test   %eax,%eax
  803145:	74 0f                	je     803156 <alloc_block_BF+0x92>
  803147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314a:	8b 40 04             	mov    0x4(%eax),%eax
  80314d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803150:	8b 12                	mov    (%edx),%edx
  803152:	89 10                	mov    %edx,(%eax)
  803154:	eb 0a                	jmp    803160 <alloc_block_BF+0x9c>
  803156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803159:	8b 00                	mov    (%eax),%eax
  80315b:	a3 38 51 80 00       	mov    %eax,0x805138
  803160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803163:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803173:	a1 44 51 80 00       	mov    0x805144,%eax
  803178:	48                   	dec    %eax
  803179:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80317e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803181:	e9 4d 01 00 00       	jmp    8032d3 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  803186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803189:	8b 40 0c             	mov    0xc(%eax),%eax
  80318c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80318f:	76 24                	jbe    8031b5 <alloc_block_BF+0xf1>
  803191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803194:	8b 40 0c             	mov    0xc(%eax),%eax
  803197:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80319a:	73 19                	jae    8031b5 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80319c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8031ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031af:	8b 40 08             	mov    0x8(%eax),%eax
  8031b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8031b5:	a1 40 51 80 00       	mov    0x805140,%eax
  8031ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c1:	74 07                	je     8031ca <alloc_block_BF+0x106>
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	8b 00                	mov    (%eax),%eax
  8031c8:	eb 05                	jmp    8031cf <alloc_block_BF+0x10b>
  8031ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8031cf:	a3 40 51 80 00       	mov    %eax,0x805140
  8031d4:	a1 40 51 80 00       	mov    0x805140,%eax
  8031d9:	85 c0                	test   %eax,%eax
  8031db:	0f 85 fd fe ff ff    	jne    8030de <alloc_block_BF+0x1a>
  8031e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e5:	0f 85 f3 fe ff ff    	jne    8030de <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8031eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031ef:	0f 84 d9 00 00 00    	je     8032ce <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8031f5:	a1 48 51 80 00       	mov    0x805148,%eax
  8031fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8031fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803200:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803203:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803209:	8b 55 08             	mov    0x8(%ebp),%edx
  80320c:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80320f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803213:	75 17                	jne    80322c <alloc_block_BF+0x168>
  803215:	83 ec 04             	sub    $0x4,%esp
  803218:	68 10 4c 80 00       	push   $0x804c10
  80321d:	68 c7 00 00 00       	push   $0xc7
  803222:	68 67 4b 80 00       	push   $0x804b67
  803227:	e8 3c dd ff ff       	call   800f68 <_panic>
  80322c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80322f:	8b 00                	mov    (%eax),%eax
  803231:	85 c0                	test   %eax,%eax
  803233:	74 10                	je     803245 <alloc_block_BF+0x181>
  803235:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803238:	8b 00                	mov    (%eax),%eax
  80323a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80323d:	8b 52 04             	mov    0x4(%edx),%edx
  803240:	89 50 04             	mov    %edx,0x4(%eax)
  803243:	eb 0b                	jmp    803250 <alloc_block_BF+0x18c>
  803245:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803248:	8b 40 04             	mov    0x4(%eax),%eax
  80324b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803250:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803253:	8b 40 04             	mov    0x4(%eax),%eax
  803256:	85 c0                	test   %eax,%eax
  803258:	74 0f                	je     803269 <alloc_block_BF+0x1a5>
  80325a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80325d:	8b 40 04             	mov    0x4(%eax),%eax
  803260:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803263:	8b 12                	mov    (%edx),%edx
  803265:	89 10                	mov    %edx,(%eax)
  803267:	eb 0a                	jmp    803273 <alloc_block_BF+0x1af>
  803269:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80326c:	8b 00                	mov    (%eax),%eax
  80326e:	a3 48 51 80 00       	mov    %eax,0x805148
  803273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803276:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803286:	a1 54 51 80 00       	mov    0x805154,%eax
  80328b:	48                   	dec    %eax
  80328c:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803291:	83 ec 08             	sub    $0x8,%esp
  803294:	ff 75 ec             	pushl  -0x14(%ebp)
  803297:	68 38 51 80 00       	push   $0x805138
  80329c:	e8 71 f9 ff ff       	call   802c12 <find_block>
  8032a1:	83 c4 10             	add    $0x10,%esp
  8032a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8032a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032aa:	8b 50 08             	mov    0x8(%eax),%edx
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	01 c2                	add    %eax,%edx
  8032b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032b5:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8032b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8032be:	2b 45 08             	sub    0x8(%ebp),%eax
  8032c1:	89 c2                	mov    %eax,%edx
  8032c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c6:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8032c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032cc:	eb 05                	jmp    8032d3 <alloc_block_BF+0x20f>
	}
	return NULL;
  8032ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032d3:	c9                   	leave  
  8032d4:	c3                   	ret    

008032d5 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8032d5:	55                   	push   %ebp
  8032d6:	89 e5                	mov    %esp,%ebp
  8032d8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8032db:	a1 28 50 80 00       	mov    0x805028,%eax
  8032e0:	85 c0                	test   %eax,%eax
  8032e2:	0f 85 de 01 00 00    	jne    8034c6 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8032e8:	a1 38 51 80 00       	mov    0x805138,%eax
  8032ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032f0:	e9 9e 01 00 00       	jmp    803493 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8032f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032fe:	0f 82 87 01 00 00    	jb     80348b <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803307:	8b 40 0c             	mov    0xc(%eax),%eax
  80330a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80330d:	0f 85 95 00 00 00    	jne    8033a8 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803313:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803317:	75 17                	jne    803330 <alloc_block_NF+0x5b>
  803319:	83 ec 04             	sub    $0x4,%esp
  80331c:	68 10 4c 80 00       	push   $0x804c10
  803321:	68 e0 00 00 00       	push   $0xe0
  803326:	68 67 4b 80 00       	push   $0x804b67
  80332b:	e8 38 dc ff ff       	call   800f68 <_panic>
  803330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803333:	8b 00                	mov    (%eax),%eax
  803335:	85 c0                	test   %eax,%eax
  803337:	74 10                	je     803349 <alloc_block_NF+0x74>
  803339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333c:	8b 00                	mov    (%eax),%eax
  80333e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803341:	8b 52 04             	mov    0x4(%edx),%edx
  803344:	89 50 04             	mov    %edx,0x4(%eax)
  803347:	eb 0b                	jmp    803354 <alloc_block_NF+0x7f>
  803349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334c:	8b 40 04             	mov    0x4(%eax),%eax
  80334f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803357:	8b 40 04             	mov    0x4(%eax),%eax
  80335a:	85 c0                	test   %eax,%eax
  80335c:	74 0f                	je     80336d <alloc_block_NF+0x98>
  80335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803361:	8b 40 04             	mov    0x4(%eax),%eax
  803364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803367:	8b 12                	mov    (%edx),%edx
  803369:	89 10                	mov    %edx,(%eax)
  80336b:	eb 0a                	jmp    803377 <alloc_block_NF+0xa2>
  80336d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803370:	8b 00                	mov    (%eax),%eax
  803372:	a3 38 51 80 00       	mov    %eax,0x805138
  803377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803383:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80338a:	a1 44 51 80 00       	mov    0x805144,%eax
  80338f:	48                   	dec    %eax
  803390:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  803395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803398:	8b 40 08             	mov    0x8(%eax),%eax
  80339b:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8033a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a3:	e9 f8 04 00 00       	jmp    8038a0 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8033a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033b1:	0f 86 d4 00 00 00    	jbe    80348b <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8033b7:	a1 48 51 80 00       	mov    0x805148,%eax
  8033bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8033bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c2:	8b 50 08             	mov    0x8(%eax),%edx
  8033c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c8:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8033cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d1:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8033d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033d8:	75 17                	jne    8033f1 <alloc_block_NF+0x11c>
  8033da:	83 ec 04             	sub    $0x4,%esp
  8033dd:	68 10 4c 80 00       	push   $0x804c10
  8033e2:	68 e9 00 00 00       	push   $0xe9
  8033e7:	68 67 4b 80 00       	push   $0x804b67
  8033ec:	e8 77 db ff ff       	call   800f68 <_panic>
  8033f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f4:	8b 00                	mov    (%eax),%eax
  8033f6:	85 c0                	test   %eax,%eax
  8033f8:	74 10                	je     80340a <alloc_block_NF+0x135>
  8033fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fd:	8b 00                	mov    (%eax),%eax
  8033ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803402:	8b 52 04             	mov    0x4(%edx),%edx
  803405:	89 50 04             	mov    %edx,0x4(%eax)
  803408:	eb 0b                	jmp    803415 <alloc_block_NF+0x140>
  80340a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80340d:	8b 40 04             	mov    0x4(%eax),%eax
  803410:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803418:	8b 40 04             	mov    0x4(%eax),%eax
  80341b:	85 c0                	test   %eax,%eax
  80341d:	74 0f                	je     80342e <alloc_block_NF+0x159>
  80341f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803422:	8b 40 04             	mov    0x4(%eax),%eax
  803425:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803428:	8b 12                	mov    (%edx),%edx
  80342a:	89 10                	mov    %edx,(%eax)
  80342c:	eb 0a                	jmp    803438 <alloc_block_NF+0x163>
  80342e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803431:	8b 00                	mov    (%eax),%eax
  803433:	a3 48 51 80 00       	mov    %eax,0x805148
  803438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803444:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80344b:	a1 54 51 80 00       	mov    0x805154,%eax
  803450:	48                   	dec    %eax
  803451:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803459:	8b 40 08             	mov    0x8(%eax),%eax
  80345c:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  803461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803464:	8b 50 08             	mov    0x8(%eax),%edx
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	01 c2                	add    %eax,%edx
  80346c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346f:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803475:	8b 40 0c             	mov    0xc(%eax),%eax
  803478:	2b 45 08             	sub    0x8(%ebp),%eax
  80347b:	89 c2                	mov    %eax,%edx
  80347d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803480:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803486:	e9 15 04 00 00       	jmp    8038a0 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80348b:	a1 40 51 80 00       	mov    0x805140,%eax
  803490:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803497:	74 07                	je     8034a0 <alloc_block_NF+0x1cb>
  803499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349c:	8b 00                	mov    (%eax),%eax
  80349e:	eb 05                	jmp    8034a5 <alloc_block_NF+0x1d0>
  8034a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a5:	a3 40 51 80 00       	mov    %eax,0x805140
  8034aa:	a1 40 51 80 00       	mov    0x805140,%eax
  8034af:	85 c0                	test   %eax,%eax
  8034b1:	0f 85 3e fe ff ff    	jne    8032f5 <alloc_block_NF+0x20>
  8034b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034bb:	0f 85 34 fe ff ff    	jne    8032f5 <alloc_block_NF+0x20>
  8034c1:	e9 d5 03 00 00       	jmp    80389b <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8034c6:	a1 38 51 80 00       	mov    0x805138,%eax
  8034cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034ce:	e9 b1 01 00 00       	jmp    803684 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8034d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d6:	8b 50 08             	mov    0x8(%eax),%edx
  8034d9:	a1 28 50 80 00       	mov    0x805028,%eax
  8034de:	39 c2                	cmp    %eax,%edx
  8034e0:	0f 82 96 01 00 00    	jb     80367c <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8034e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034ef:	0f 82 87 01 00 00    	jb     80367c <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8034f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8034fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034fe:	0f 85 95 00 00 00    	jne    803599 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803504:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803508:	75 17                	jne    803521 <alloc_block_NF+0x24c>
  80350a:	83 ec 04             	sub    $0x4,%esp
  80350d:	68 10 4c 80 00       	push   $0x804c10
  803512:	68 fc 00 00 00       	push   $0xfc
  803517:	68 67 4b 80 00       	push   $0x804b67
  80351c:	e8 47 da ff ff       	call   800f68 <_panic>
  803521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803524:	8b 00                	mov    (%eax),%eax
  803526:	85 c0                	test   %eax,%eax
  803528:	74 10                	je     80353a <alloc_block_NF+0x265>
  80352a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352d:	8b 00                	mov    (%eax),%eax
  80352f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803532:	8b 52 04             	mov    0x4(%edx),%edx
  803535:	89 50 04             	mov    %edx,0x4(%eax)
  803538:	eb 0b                	jmp    803545 <alloc_block_NF+0x270>
  80353a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353d:	8b 40 04             	mov    0x4(%eax),%eax
  803540:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803548:	8b 40 04             	mov    0x4(%eax),%eax
  80354b:	85 c0                	test   %eax,%eax
  80354d:	74 0f                	je     80355e <alloc_block_NF+0x289>
  80354f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803552:	8b 40 04             	mov    0x4(%eax),%eax
  803555:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803558:	8b 12                	mov    (%edx),%edx
  80355a:	89 10                	mov    %edx,(%eax)
  80355c:	eb 0a                	jmp    803568 <alloc_block_NF+0x293>
  80355e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803561:	8b 00                	mov    (%eax),%eax
  803563:	a3 38 51 80 00       	mov    %eax,0x805138
  803568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803574:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80357b:	a1 44 51 80 00       	mov    0x805144,%eax
  803580:	48                   	dec    %eax
  803581:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803589:	8b 40 08             	mov    0x8(%eax),%eax
  80358c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803594:	e9 07 03 00 00       	jmp    8038a0 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359c:	8b 40 0c             	mov    0xc(%eax),%eax
  80359f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035a2:	0f 86 d4 00 00 00    	jbe    80367c <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8035a8:	a1 48 51 80 00       	mov    0x805148,%eax
  8035ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8035b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b3:	8b 50 08             	mov    0x8(%eax),%edx
  8035b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b9:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8035bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c2:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8035c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035c9:	75 17                	jne    8035e2 <alloc_block_NF+0x30d>
  8035cb:	83 ec 04             	sub    $0x4,%esp
  8035ce:	68 10 4c 80 00       	push   $0x804c10
  8035d3:	68 04 01 00 00       	push   $0x104
  8035d8:	68 67 4b 80 00       	push   $0x804b67
  8035dd:	e8 86 d9 ff ff       	call   800f68 <_panic>
  8035e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e5:	8b 00                	mov    (%eax),%eax
  8035e7:	85 c0                	test   %eax,%eax
  8035e9:	74 10                	je     8035fb <alloc_block_NF+0x326>
  8035eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ee:	8b 00                	mov    (%eax),%eax
  8035f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035f3:	8b 52 04             	mov    0x4(%edx),%edx
  8035f6:	89 50 04             	mov    %edx,0x4(%eax)
  8035f9:	eb 0b                	jmp    803606 <alloc_block_NF+0x331>
  8035fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035fe:	8b 40 04             	mov    0x4(%eax),%eax
  803601:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803606:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803609:	8b 40 04             	mov    0x4(%eax),%eax
  80360c:	85 c0                	test   %eax,%eax
  80360e:	74 0f                	je     80361f <alloc_block_NF+0x34a>
  803610:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803613:	8b 40 04             	mov    0x4(%eax),%eax
  803616:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803619:	8b 12                	mov    (%edx),%edx
  80361b:	89 10                	mov    %edx,(%eax)
  80361d:	eb 0a                	jmp    803629 <alloc_block_NF+0x354>
  80361f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803622:	8b 00                	mov    (%eax),%eax
  803624:	a3 48 51 80 00       	mov    %eax,0x805148
  803629:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803632:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803635:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363c:	a1 54 51 80 00       	mov    0x805154,%eax
  803641:	48                   	dec    %eax
  803642:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364a:	8b 40 08             	mov    0x8(%eax),%eax
  80364d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803655:	8b 50 08             	mov    0x8(%eax),%edx
  803658:	8b 45 08             	mov    0x8(%ebp),%eax
  80365b:	01 c2                	add    %eax,%edx
  80365d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803660:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803666:	8b 40 0c             	mov    0xc(%eax),%eax
  803669:	2b 45 08             	sub    0x8(%ebp),%eax
  80366c:	89 c2                	mov    %eax,%edx
  80366e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803671:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803674:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803677:	e9 24 02 00 00       	jmp    8038a0 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80367c:	a1 40 51 80 00       	mov    0x805140,%eax
  803681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803684:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803688:	74 07                	je     803691 <alloc_block_NF+0x3bc>
  80368a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368d:	8b 00                	mov    (%eax),%eax
  80368f:	eb 05                	jmp    803696 <alloc_block_NF+0x3c1>
  803691:	b8 00 00 00 00       	mov    $0x0,%eax
  803696:	a3 40 51 80 00       	mov    %eax,0x805140
  80369b:	a1 40 51 80 00       	mov    0x805140,%eax
  8036a0:	85 c0                	test   %eax,%eax
  8036a2:	0f 85 2b fe ff ff    	jne    8034d3 <alloc_block_NF+0x1fe>
  8036a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036ac:	0f 85 21 fe ff ff    	jne    8034d3 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8036b2:	a1 38 51 80 00       	mov    0x805138,%eax
  8036b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036ba:	e9 ae 01 00 00       	jmp    80386d <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8036bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c2:	8b 50 08             	mov    0x8(%eax),%edx
  8036c5:	a1 28 50 80 00       	mov    0x805028,%eax
  8036ca:	39 c2                	cmp    %eax,%edx
  8036cc:	0f 83 93 01 00 00    	jae    803865 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8036d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036db:	0f 82 84 01 00 00    	jb     803865 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8036e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8036e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036ea:	0f 85 95 00 00 00    	jne    803785 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8036f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036f4:	75 17                	jne    80370d <alloc_block_NF+0x438>
  8036f6:	83 ec 04             	sub    $0x4,%esp
  8036f9:	68 10 4c 80 00       	push   $0x804c10
  8036fe:	68 14 01 00 00       	push   $0x114
  803703:	68 67 4b 80 00       	push   $0x804b67
  803708:	e8 5b d8 ff ff       	call   800f68 <_panic>
  80370d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803710:	8b 00                	mov    (%eax),%eax
  803712:	85 c0                	test   %eax,%eax
  803714:	74 10                	je     803726 <alloc_block_NF+0x451>
  803716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803719:	8b 00                	mov    (%eax),%eax
  80371b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80371e:	8b 52 04             	mov    0x4(%edx),%edx
  803721:	89 50 04             	mov    %edx,0x4(%eax)
  803724:	eb 0b                	jmp    803731 <alloc_block_NF+0x45c>
  803726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803729:	8b 40 04             	mov    0x4(%eax),%eax
  80372c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803734:	8b 40 04             	mov    0x4(%eax),%eax
  803737:	85 c0                	test   %eax,%eax
  803739:	74 0f                	je     80374a <alloc_block_NF+0x475>
  80373b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373e:	8b 40 04             	mov    0x4(%eax),%eax
  803741:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803744:	8b 12                	mov    (%edx),%edx
  803746:	89 10                	mov    %edx,(%eax)
  803748:	eb 0a                	jmp    803754 <alloc_block_NF+0x47f>
  80374a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374d:	8b 00                	mov    (%eax),%eax
  80374f:	a3 38 51 80 00       	mov    %eax,0x805138
  803754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803757:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80375d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803760:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803767:	a1 44 51 80 00       	mov    0x805144,%eax
  80376c:	48                   	dec    %eax
  80376d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803775:	8b 40 08             	mov    0x8(%eax),%eax
  803778:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80377d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803780:	e9 1b 01 00 00       	jmp    8038a0 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803788:	8b 40 0c             	mov    0xc(%eax),%eax
  80378b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80378e:	0f 86 d1 00 00 00    	jbe    803865 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803794:	a1 48 51 80 00       	mov    0x805148,%eax
  803799:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80379c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379f:	8b 50 08             	mov    0x8(%eax),%edx
  8037a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8037a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8037ae:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8037b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037b5:	75 17                	jne    8037ce <alloc_block_NF+0x4f9>
  8037b7:	83 ec 04             	sub    $0x4,%esp
  8037ba:	68 10 4c 80 00       	push   $0x804c10
  8037bf:	68 1c 01 00 00       	push   $0x11c
  8037c4:	68 67 4b 80 00       	push   $0x804b67
  8037c9:	e8 9a d7 ff ff       	call   800f68 <_panic>
  8037ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d1:	8b 00                	mov    (%eax),%eax
  8037d3:	85 c0                	test   %eax,%eax
  8037d5:	74 10                	je     8037e7 <alloc_block_NF+0x512>
  8037d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037da:	8b 00                	mov    (%eax),%eax
  8037dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037df:	8b 52 04             	mov    0x4(%edx),%edx
  8037e2:	89 50 04             	mov    %edx,0x4(%eax)
  8037e5:	eb 0b                	jmp    8037f2 <alloc_block_NF+0x51d>
  8037e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ea:	8b 40 04             	mov    0x4(%eax),%eax
  8037ed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f5:	8b 40 04             	mov    0x4(%eax),%eax
  8037f8:	85 c0                	test   %eax,%eax
  8037fa:	74 0f                	je     80380b <alloc_block_NF+0x536>
  8037fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ff:	8b 40 04             	mov    0x4(%eax),%eax
  803802:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803805:	8b 12                	mov    (%edx),%edx
  803807:	89 10                	mov    %edx,(%eax)
  803809:	eb 0a                	jmp    803815 <alloc_block_NF+0x540>
  80380b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80380e:	8b 00                	mov    (%eax),%eax
  803810:	a3 48 51 80 00       	mov    %eax,0x805148
  803815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803818:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80381e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803821:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803828:	a1 54 51 80 00       	mov    0x805154,%eax
  80382d:	48                   	dec    %eax
  80382e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803836:	8b 40 08             	mov    0x8(%eax),%eax
  803839:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80383e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803841:	8b 50 08             	mov    0x8(%eax),%edx
  803844:	8b 45 08             	mov    0x8(%ebp),%eax
  803847:	01 c2                	add    %eax,%edx
  803849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80384f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803852:	8b 40 0c             	mov    0xc(%eax),%eax
  803855:	2b 45 08             	sub    0x8(%ebp),%eax
  803858:	89 c2                	mov    %eax,%edx
  80385a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803860:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803863:	eb 3b                	jmp    8038a0 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803865:	a1 40 51 80 00       	mov    0x805140,%eax
  80386a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80386d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803871:	74 07                	je     80387a <alloc_block_NF+0x5a5>
  803873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803876:	8b 00                	mov    (%eax),%eax
  803878:	eb 05                	jmp    80387f <alloc_block_NF+0x5aa>
  80387a:	b8 00 00 00 00       	mov    $0x0,%eax
  80387f:	a3 40 51 80 00       	mov    %eax,0x805140
  803884:	a1 40 51 80 00       	mov    0x805140,%eax
  803889:	85 c0                	test   %eax,%eax
  80388b:	0f 85 2e fe ff ff    	jne    8036bf <alloc_block_NF+0x3ea>
  803891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803895:	0f 85 24 fe ff ff    	jne    8036bf <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80389b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038a0:	c9                   	leave  
  8038a1:	c3                   	ret    

008038a2 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8038a2:	55                   	push   %ebp
  8038a3:	89 e5                	mov    %esp,%ebp
  8038a5:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8038a8:	a1 38 51 80 00       	mov    0x805138,%eax
  8038ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8038b0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8038b5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8038b8:	a1 38 51 80 00       	mov    0x805138,%eax
  8038bd:	85 c0                	test   %eax,%eax
  8038bf:	74 14                	je     8038d5 <insert_sorted_with_merge_freeList+0x33>
  8038c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c4:	8b 50 08             	mov    0x8(%eax),%edx
  8038c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ca:	8b 40 08             	mov    0x8(%eax),%eax
  8038cd:	39 c2                	cmp    %eax,%edx
  8038cf:	0f 87 9b 01 00 00    	ja     803a70 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8038d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038d9:	75 17                	jne    8038f2 <insert_sorted_with_merge_freeList+0x50>
  8038db:	83 ec 04             	sub    $0x4,%esp
  8038de:	68 44 4b 80 00       	push   $0x804b44
  8038e3:	68 38 01 00 00       	push   $0x138
  8038e8:	68 67 4b 80 00       	push   $0x804b67
  8038ed:	e8 76 d6 ff ff       	call   800f68 <_panic>
  8038f2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8038f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fb:	89 10                	mov    %edx,(%eax)
  8038fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803900:	8b 00                	mov    (%eax),%eax
  803902:	85 c0                	test   %eax,%eax
  803904:	74 0d                	je     803913 <insert_sorted_with_merge_freeList+0x71>
  803906:	a1 38 51 80 00       	mov    0x805138,%eax
  80390b:	8b 55 08             	mov    0x8(%ebp),%edx
  80390e:	89 50 04             	mov    %edx,0x4(%eax)
  803911:	eb 08                	jmp    80391b <insert_sorted_with_merge_freeList+0x79>
  803913:	8b 45 08             	mov    0x8(%ebp),%eax
  803916:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80391b:	8b 45 08             	mov    0x8(%ebp),%eax
  80391e:	a3 38 51 80 00       	mov    %eax,0x805138
  803923:	8b 45 08             	mov    0x8(%ebp),%eax
  803926:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80392d:	a1 44 51 80 00       	mov    0x805144,%eax
  803932:	40                   	inc    %eax
  803933:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803938:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80393c:	0f 84 a8 06 00 00    	je     803fea <insert_sorted_with_merge_freeList+0x748>
  803942:	8b 45 08             	mov    0x8(%ebp),%eax
  803945:	8b 50 08             	mov    0x8(%eax),%edx
  803948:	8b 45 08             	mov    0x8(%ebp),%eax
  80394b:	8b 40 0c             	mov    0xc(%eax),%eax
  80394e:	01 c2                	add    %eax,%edx
  803950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803953:	8b 40 08             	mov    0x8(%eax),%eax
  803956:	39 c2                	cmp    %eax,%edx
  803958:	0f 85 8c 06 00 00    	jne    803fea <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80395e:	8b 45 08             	mov    0x8(%ebp),%eax
  803961:	8b 50 0c             	mov    0xc(%eax),%edx
  803964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803967:	8b 40 0c             	mov    0xc(%eax),%eax
  80396a:	01 c2                	add    %eax,%edx
  80396c:	8b 45 08             	mov    0x8(%ebp),%eax
  80396f:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803972:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803976:	75 17                	jne    80398f <insert_sorted_with_merge_freeList+0xed>
  803978:	83 ec 04             	sub    $0x4,%esp
  80397b:	68 10 4c 80 00       	push   $0x804c10
  803980:	68 3c 01 00 00       	push   $0x13c
  803985:	68 67 4b 80 00       	push   $0x804b67
  80398a:	e8 d9 d5 ff ff       	call   800f68 <_panic>
  80398f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803992:	8b 00                	mov    (%eax),%eax
  803994:	85 c0                	test   %eax,%eax
  803996:	74 10                	je     8039a8 <insert_sorted_with_merge_freeList+0x106>
  803998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80399b:	8b 00                	mov    (%eax),%eax
  80399d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039a0:	8b 52 04             	mov    0x4(%edx),%edx
  8039a3:	89 50 04             	mov    %edx,0x4(%eax)
  8039a6:	eb 0b                	jmp    8039b3 <insert_sorted_with_merge_freeList+0x111>
  8039a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ab:	8b 40 04             	mov    0x4(%eax),%eax
  8039ae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b6:	8b 40 04             	mov    0x4(%eax),%eax
  8039b9:	85 c0                	test   %eax,%eax
  8039bb:	74 0f                	je     8039cc <insert_sorted_with_merge_freeList+0x12a>
  8039bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c0:	8b 40 04             	mov    0x4(%eax),%eax
  8039c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039c6:	8b 12                	mov    (%edx),%edx
  8039c8:	89 10                	mov    %edx,(%eax)
  8039ca:	eb 0a                	jmp    8039d6 <insert_sorted_with_merge_freeList+0x134>
  8039cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039cf:	8b 00                	mov    (%eax),%eax
  8039d1:	a3 38 51 80 00       	mov    %eax,0x805138
  8039d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039e9:	a1 44 51 80 00       	mov    0x805144,%eax
  8039ee:	48                   	dec    %eax
  8039ef:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8039f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8039fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a01:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803a08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a0c:	75 17                	jne    803a25 <insert_sorted_with_merge_freeList+0x183>
  803a0e:	83 ec 04             	sub    $0x4,%esp
  803a11:	68 44 4b 80 00       	push   $0x804b44
  803a16:	68 3f 01 00 00       	push   $0x13f
  803a1b:	68 67 4b 80 00       	push   $0x804b67
  803a20:	e8 43 d5 ff ff       	call   800f68 <_panic>
  803a25:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a2e:	89 10                	mov    %edx,(%eax)
  803a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a33:	8b 00                	mov    (%eax),%eax
  803a35:	85 c0                	test   %eax,%eax
  803a37:	74 0d                	je     803a46 <insert_sorted_with_merge_freeList+0x1a4>
  803a39:	a1 48 51 80 00       	mov    0x805148,%eax
  803a3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a41:	89 50 04             	mov    %edx,0x4(%eax)
  803a44:	eb 08                	jmp    803a4e <insert_sorted_with_merge_freeList+0x1ac>
  803a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a49:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a51:	a3 48 51 80 00       	mov    %eax,0x805148
  803a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a60:	a1 54 51 80 00       	mov    0x805154,%eax
  803a65:	40                   	inc    %eax
  803a66:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803a6b:	e9 7a 05 00 00       	jmp    803fea <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803a70:	8b 45 08             	mov    0x8(%ebp),%eax
  803a73:	8b 50 08             	mov    0x8(%eax),%edx
  803a76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a79:	8b 40 08             	mov    0x8(%eax),%eax
  803a7c:	39 c2                	cmp    %eax,%edx
  803a7e:	0f 82 14 01 00 00    	jb     803b98 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a87:	8b 50 08             	mov    0x8(%eax),%edx
  803a8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a8d:	8b 40 0c             	mov    0xc(%eax),%eax
  803a90:	01 c2                	add    %eax,%edx
  803a92:	8b 45 08             	mov    0x8(%ebp),%eax
  803a95:	8b 40 08             	mov    0x8(%eax),%eax
  803a98:	39 c2                	cmp    %eax,%edx
  803a9a:	0f 85 90 00 00 00    	jne    803b30 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803aa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aa3:	8b 50 0c             	mov    0xc(%eax),%edx
  803aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa9:	8b 40 0c             	mov    0xc(%eax),%eax
  803aac:	01 c2                	add    %eax,%edx
  803aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ab1:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803abe:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803ac8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803acc:	75 17                	jne    803ae5 <insert_sorted_with_merge_freeList+0x243>
  803ace:	83 ec 04             	sub    $0x4,%esp
  803ad1:	68 44 4b 80 00       	push   $0x804b44
  803ad6:	68 49 01 00 00       	push   $0x149
  803adb:	68 67 4b 80 00       	push   $0x804b67
  803ae0:	e8 83 d4 ff ff       	call   800f68 <_panic>
  803ae5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  803aee:	89 10                	mov    %edx,(%eax)
  803af0:	8b 45 08             	mov    0x8(%ebp),%eax
  803af3:	8b 00                	mov    (%eax),%eax
  803af5:	85 c0                	test   %eax,%eax
  803af7:	74 0d                	je     803b06 <insert_sorted_with_merge_freeList+0x264>
  803af9:	a1 48 51 80 00       	mov    0x805148,%eax
  803afe:	8b 55 08             	mov    0x8(%ebp),%edx
  803b01:	89 50 04             	mov    %edx,0x4(%eax)
  803b04:	eb 08                	jmp    803b0e <insert_sorted_with_merge_freeList+0x26c>
  803b06:	8b 45 08             	mov    0x8(%ebp),%eax
  803b09:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b11:	a3 48 51 80 00       	mov    %eax,0x805148
  803b16:	8b 45 08             	mov    0x8(%ebp),%eax
  803b19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b20:	a1 54 51 80 00       	mov    0x805154,%eax
  803b25:	40                   	inc    %eax
  803b26:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b2b:	e9 bb 04 00 00       	jmp    803feb <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803b30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b34:	75 17                	jne    803b4d <insert_sorted_with_merge_freeList+0x2ab>
  803b36:	83 ec 04             	sub    $0x4,%esp
  803b39:	68 b8 4b 80 00       	push   $0x804bb8
  803b3e:	68 4c 01 00 00       	push   $0x14c
  803b43:	68 67 4b 80 00       	push   $0x804b67
  803b48:	e8 1b d4 ff ff       	call   800f68 <_panic>
  803b4d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803b53:	8b 45 08             	mov    0x8(%ebp),%eax
  803b56:	89 50 04             	mov    %edx,0x4(%eax)
  803b59:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5c:	8b 40 04             	mov    0x4(%eax),%eax
  803b5f:	85 c0                	test   %eax,%eax
  803b61:	74 0c                	je     803b6f <insert_sorted_with_merge_freeList+0x2cd>
  803b63:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803b68:	8b 55 08             	mov    0x8(%ebp),%edx
  803b6b:	89 10                	mov    %edx,(%eax)
  803b6d:	eb 08                	jmp    803b77 <insert_sorted_with_merge_freeList+0x2d5>
  803b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b72:	a3 38 51 80 00       	mov    %eax,0x805138
  803b77:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b88:	a1 44 51 80 00       	mov    0x805144,%eax
  803b8d:	40                   	inc    %eax
  803b8e:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b93:	e9 53 04 00 00       	jmp    803feb <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803b98:	a1 38 51 80 00       	mov    0x805138,%eax
  803b9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ba0:	e9 15 04 00 00       	jmp    803fba <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba8:	8b 00                	mov    (%eax),%eax
  803baa:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803bad:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb0:	8b 50 08             	mov    0x8(%eax),%edx
  803bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb6:	8b 40 08             	mov    0x8(%eax),%eax
  803bb9:	39 c2                	cmp    %eax,%edx
  803bbb:	0f 86 f1 03 00 00    	jbe    803fb2 <insert_sorted_with_merge_freeList+0x710>
  803bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc4:	8b 50 08             	mov    0x8(%eax),%edx
  803bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bca:	8b 40 08             	mov    0x8(%eax),%eax
  803bcd:	39 c2                	cmp    %eax,%edx
  803bcf:	0f 83 dd 03 00 00    	jae    803fb2 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd8:	8b 50 08             	mov    0x8(%eax),%edx
  803bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bde:	8b 40 0c             	mov    0xc(%eax),%eax
  803be1:	01 c2                	add    %eax,%edx
  803be3:	8b 45 08             	mov    0x8(%ebp),%eax
  803be6:	8b 40 08             	mov    0x8(%eax),%eax
  803be9:	39 c2                	cmp    %eax,%edx
  803beb:	0f 85 b9 01 00 00    	jne    803daa <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf4:	8b 50 08             	mov    0x8(%eax),%edx
  803bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfa:	8b 40 0c             	mov    0xc(%eax),%eax
  803bfd:	01 c2                	add    %eax,%edx
  803bff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c02:	8b 40 08             	mov    0x8(%eax),%eax
  803c05:	39 c2                	cmp    %eax,%edx
  803c07:	0f 85 0d 01 00 00    	jne    803d1a <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c10:	8b 50 0c             	mov    0xc(%eax),%edx
  803c13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c16:	8b 40 0c             	mov    0xc(%eax),%eax
  803c19:	01 c2                	add    %eax,%edx
  803c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c1e:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803c21:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c25:	75 17                	jne    803c3e <insert_sorted_with_merge_freeList+0x39c>
  803c27:	83 ec 04             	sub    $0x4,%esp
  803c2a:	68 10 4c 80 00       	push   $0x804c10
  803c2f:	68 5c 01 00 00       	push   $0x15c
  803c34:	68 67 4b 80 00       	push   $0x804b67
  803c39:	e8 2a d3 ff ff       	call   800f68 <_panic>
  803c3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c41:	8b 00                	mov    (%eax),%eax
  803c43:	85 c0                	test   %eax,%eax
  803c45:	74 10                	je     803c57 <insert_sorted_with_merge_freeList+0x3b5>
  803c47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c4a:	8b 00                	mov    (%eax),%eax
  803c4c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c4f:	8b 52 04             	mov    0x4(%edx),%edx
  803c52:	89 50 04             	mov    %edx,0x4(%eax)
  803c55:	eb 0b                	jmp    803c62 <insert_sorted_with_merge_freeList+0x3c0>
  803c57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c5a:	8b 40 04             	mov    0x4(%eax),%eax
  803c5d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c65:	8b 40 04             	mov    0x4(%eax),%eax
  803c68:	85 c0                	test   %eax,%eax
  803c6a:	74 0f                	je     803c7b <insert_sorted_with_merge_freeList+0x3d9>
  803c6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6f:	8b 40 04             	mov    0x4(%eax),%eax
  803c72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c75:	8b 12                	mov    (%edx),%edx
  803c77:	89 10                	mov    %edx,(%eax)
  803c79:	eb 0a                	jmp    803c85 <insert_sorted_with_merge_freeList+0x3e3>
  803c7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c7e:	8b 00                	mov    (%eax),%eax
  803c80:	a3 38 51 80 00       	mov    %eax,0x805138
  803c85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c98:	a1 44 51 80 00       	mov    0x805144,%eax
  803c9d:	48                   	dec    %eax
  803c9e:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803ca3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803cad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cb0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803cb7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803cbb:	75 17                	jne    803cd4 <insert_sorted_with_merge_freeList+0x432>
  803cbd:	83 ec 04             	sub    $0x4,%esp
  803cc0:	68 44 4b 80 00       	push   $0x804b44
  803cc5:	68 5f 01 00 00       	push   $0x15f
  803cca:	68 67 4b 80 00       	push   $0x804b67
  803ccf:	e8 94 d2 ff ff       	call   800f68 <_panic>
  803cd4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803cda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cdd:	89 10                	mov    %edx,(%eax)
  803cdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ce2:	8b 00                	mov    (%eax),%eax
  803ce4:	85 c0                	test   %eax,%eax
  803ce6:	74 0d                	je     803cf5 <insert_sorted_with_merge_freeList+0x453>
  803ce8:	a1 48 51 80 00       	mov    0x805148,%eax
  803ced:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cf0:	89 50 04             	mov    %edx,0x4(%eax)
  803cf3:	eb 08                	jmp    803cfd <insert_sorted_with_merge_freeList+0x45b>
  803cf5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cf8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803cfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d00:	a3 48 51 80 00       	mov    %eax,0x805148
  803d05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d0f:	a1 54 51 80 00       	mov    0x805154,%eax
  803d14:	40                   	inc    %eax
  803d15:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1d:	8b 50 0c             	mov    0xc(%eax),%edx
  803d20:	8b 45 08             	mov    0x8(%ebp),%eax
  803d23:	8b 40 0c             	mov    0xc(%eax),%eax
  803d26:	01 c2                	add    %eax,%edx
  803d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2b:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803d38:	8b 45 08             	mov    0x8(%ebp),%eax
  803d3b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803d42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d46:	75 17                	jne    803d5f <insert_sorted_with_merge_freeList+0x4bd>
  803d48:	83 ec 04             	sub    $0x4,%esp
  803d4b:	68 44 4b 80 00       	push   $0x804b44
  803d50:	68 64 01 00 00       	push   $0x164
  803d55:	68 67 4b 80 00       	push   $0x804b67
  803d5a:	e8 09 d2 ff ff       	call   800f68 <_panic>
  803d5f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803d65:	8b 45 08             	mov    0x8(%ebp),%eax
  803d68:	89 10                	mov    %edx,(%eax)
  803d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6d:	8b 00                	mov    (%eax),%eax
  803d6f:	85 c0                	test   %eax,%eax
  803d71:	74 0d                	je     803d80 <insert_sorted_with_merge_freeList+0x4de>
  803d73:	a1 48 51 80 00       	mov    0x805148,%eax
  803d78:	8b 55 08             	mov    0x8(%ebp),%edx
  803d7b:	89 50 04             	mov    %edx,0x4(%eax)
  803d7e:	eb 08                	jmp    803d88 <insert_sorted_with_merge_freeList+0x4e6>
  803d80:	8b 45 08             	mov    0x8(%ebp),%eax
  803d83:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d88:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8b:	a3 48 51 80 00       	mov    %eax,0x805148
  803d90:	8b 45 08             	mov    0x8(%ebp),%eax
  803d93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d9a:	a1 54 51 80 00       	mov    0x805154,%eax
  803d9f:	40                   	inc    %eax
  803da0:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803da5:	e9 41 02 00 00       	jmp    803feb <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803daa:	8b 45 08             	mov    0x8(%ebp),%eax
  803dad:	8b 50 08             	mov    0x8(%eax),%edx
  803db0:	8b 45 08             	mov    0x8(%ebp),%eax
  803db3:	8b 40 0c             	mov    0xc(%eax),%eax
  803db6:	01 c2                	add    %eax,%edx
  803db8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dbb:	8b 40 08             	mov    0x8(%eax),%eax
  803dbe:	39 c2                	cmp    %eax,%edx
  803dc0:	0f 85 7c 01 00 00    	jne    803f42 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803dc6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803dca:	74 06                	je     803dd2 <insert_sorted_with_merge_freeList+0x530>
  803dcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803dd0:	75 17                	jne    803de9 <insert_sorted_with_merge_freeList+0x547>
  803dd2:	83 ec 04             	sub    $0x4,%esp
  803dd5:	68 80 4b 80 00       	push   $0x804b80
  803dda:	68 69 01 00 00       	push   $0x169
  803ddf:	68 67 4b 80 00       	push   $0x804b67
  803de4:	e8 7f d1 ff ff       	call   800f68 <_panic>
  803de9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dec:	8b 50 04             	mov    0x4(%eax),%edx
  803def:	8b 45 08             	mov    0x8(%ebp),%eax
  803df2:	89 50 04             	mov    %edx,0x4(%eax)
  803df5:	8b 45 08             	mov    0x8(%ebp),%eax
  803df8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803dfb:	89 10                	mov    %edx,(%eax)
  803dfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e00:	8b 40 04             	mov    0x4(%eax),%eax
  803e03:	85 c0                	test   %eax,%eax
  803e05:	74 0d                	je     803e14 <insert_sorted_with_merge_freeList+0x572>
  803e07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e0a:	8b 40 04             	mov    0x4(%eax),%eax
  803e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  803e10:	89 10                	mov    %edx,(%eax)
  803e12:	eb 08                	jmp    803e1c <insert_sorted_with_merge_freeList+0x57a>
  803e14:	8b 45 08             	mov    0x8(%ebp),%eax
  803e17:	a3 38 51 80 00       	mov    %eax,0x805138
  803e1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e1f:	8b 55 08             	mov    0x8(%ebp),%edx
  803e22:	89 50 04             	mov    %edx,0x4(%eax)
  803e25:	a1 44 51 80 00       	mov    0x805144,%eax
  803e2a:	40                   	inc    %eax
  803e2b:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803e30:	8b 45 08             	mov    0x8(%ebp),%eax
  803e33:	8b 50 0c             	mov    0xc(%eax),%edx
  803e36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e39:	8b 40 0c             	mov    0xc(%eax),%eax
  803e3c:	01 c2                	add    %eax,%edx
  803e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e41:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803e44:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803e48:	75 17                	jne    803e61 <insert_sorted_with_merge_freeList+0x5bf>
  803e4a:	83 ec 04             	sub    $0x4,%esp
  803e4d:	68 10 4c 80 00       	push   $0x804c10
  803e52:	68 6b 01 00 00       	push   $0x16b
  803e57:	68 67 4b 80 00       	push   $0x804b67
  803e5c:	e8 07 d1 ff ff       	call   800f68 <_panic>
  803e61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e64:	8b 00                	mov    (%eax),%eax
  803e66:	85 c0                	test   %eax,%eax
  803e68:	74 10                	je     803e7a <insert_sorted_with_merge_freeList+0x5d8>
  803e6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e6d:	8b 00                	mov    (%eax),%eax
  803e6f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e72:	8b 52 04             	mov    0x4(%edx),%edx
  803e75:	89 50 04             	mov    %edx,0x4(%eax)
  803e78:	eb 0b                	jmp    803e85 <insert_sorted_with_merge_freeList+0x5e3>
  803e7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e7d:	8b 40 04             	mov    0x4(%eax),%eax
  803e80:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803e85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e88:	8b 40 04             	mov    0x4(%eax),%eax
  803e8b:	85 c0                	test   %eax,%eax
  803e8d:	74 0f                	je     803e9e <insert_sorted_with_merge_freeList+0x5fc>
  803e8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e92:	8b 40 04             	mov    0x4(%eax),%eax
  803e95:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e98:	8b 12                	mov    (%edx),%edx
  803e9a:	89 10                	mov    %edx,(%eax)
  803e9c:	eb 0a                	jmp    803ea8 <insert_sorted_with_merge_freeList+0x606>
  803e9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ea1:	8b 00                	mov    (%eax),%eax
  803ea3:	a3 38 51 80 00       	mov    %eax,0x805138
  803ea8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ebb:	a1 44 51 80 00       	mov    0x805144,%eax
  803ec0:	48                   	dec    %eax
  803ec1:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803ec6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ec9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803ed0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ed3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803eda:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ede:	75 17                	jne    803ef7 <insert_sorted_with_merge_freeList+0x655>
  803ee0:	83 ec 04             	sub    $0x4,%esp
  803ee3:	68 44 4b 80 00       	push   $0x804b44
  803ee8:	68 6e 01 00 00       	push   $0x16e
  803eed:	68 67 4b 80 00       	push   $0x804b67
  803ef2:	e8 71 d0 ff ff       	call   800f68 <_panic>
  803ef7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803efd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f00:	89 10                	mov    %edx,(%eax)
  803f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f05:	8b 00                	mov    (%eax),%eax
  803f07:	85 c0                	test   %eax,%eax
  803f09:	74 0d                	je     803f18 <insert_sorted_with_merge_freeList+0x676>
  803f0b:	a1 48 51 80 00       	mov    0x805148,%eax
  803f10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f13:	89 50 04             	mov    %edx,0x4(%eax)
  803f16:	eb 08                	jmp    803f20 <insert_sorted_with_merge_freeList+0x67e>
  803f18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f1b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803f20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f23:	a3 48 51 80 00       	mov    %eax,0x805148
  803f28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f32:	a1 54 51 80 00       	mov    0x805154,%eax
  803f37:	40                   	inc    %eax
  803f38:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803f3d:	e9 a9 00 00 00       	jmp    803feb <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803f42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f46:	74 06                	je     803f4e <insert_sorted_with_merge_freeList+0x6ac>
  803f48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f4c:	75 17                	jne    803f65 <insert_sorted_with_merge_freeList+0x6c3>
  803f4e:	83 ec 04             	sub    $0x4,%esp
  803f51:	68 dc 4b 80 00       	push   $0x804bdc
  803f56:	68 73 01 00 00       	push   $0x173
  803f5b:	68 67 4b 80 00       	push   $0x804b67
  803f60:	e8 03 d0 ff ff       	call   800f68 <_panic>
  803f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f68:	8b 10                	mov    (%eax),%edx
  803f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f6d:	89 10                	mov    %edx,(%eax)
  803f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f72:	8b 00                	mov    (%eax),%eax
  803f74:	85 c0                	test   %eax,%eax
  803f76:	74 0b                	je     803f83 <insert_sorted_with_merge_freeList+0x6e1>
  803f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7b:	8b 00                	mov    (%eax),%eax
  803f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  803f80:	89 50 04             	mov    %edx,0x4(%eax)
  803f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f86:	8b 55 08             	mov    0x8(%ebp),%edx
  803f89:	89 10                	mov    %edx,(%eax)
  803f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f91:	89 50 04             	mov    %edx,0x4(%eax)
  803f94:	8b 45 08             	mov    0x8(%ebp),%eax
  803f97:	8b 00                	mov    (%eax),%eax
  803f99:	85 c0                	test   %eax,%eax
  803f9b:	75 08                	jne    803fa5 <insert_sorted_with_merge_freeList+0x703>
  803f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803fa5:	a1 44 51 80 00       	mov    0x805144,%eax
  803faa:	40                   	inc    %eax
  803fab:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803fb0:	eb 39                	jmp    803feb <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803fb2:	a1 40 51 80 00       	mov    0x805140,%eax
  803fb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fbe:	74 07                	je     803fc7 <insert_sorted_with_merge_freeList+0x725>
  803fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc3:	8b 00                	mov    (%eax),%eax
  803fc5:	eb 05                	jmp    803fcc <insert_sorted_with_merge_freeList+0x72a>
  803fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  803fcc:	a3 40 51 80 00       	mov    %eax,0x805140
  803fd1:	a1 40 51 80 00       	mov    0x805140,%eax
  803fd6:	85 c0                	test   %eax,%eax
  803fd8:	0f 85 c7 fb ff ff    	jne    803ba5 <insert_sorted_with_merge_freeList+0x303>
  803fde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fe2:	0f 85 bd fb ff ff    	jne    803ba5 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803fe8:	eb 01                	jmp    803feb <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803fea:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803feb:	90                   	nop
  803fec:	c9                   	leave  
  803fed:	c3                   	ret    
  803fee:	66 90                	xchg   %ax,%ax

00803ff0 <__udivdi3>:
  803ff0:	55                   	push   %ebp
  803ff1:	57                   	push   %edi
  803ff2:	56                   	push   %esi
  803ff3:	53                   	push   %ebx
  803ff4:	83 ec 1c             	sub    $0x1c,%esp
  803ff7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ffb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803fff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804003:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804007:	89 ca                	mov    %ecx,%edx
  804009:	89 f8                	mov    %edi,%eax
  80400b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80400f:	85 f6                	test   %esi,%esi
  804011:	75 2d                	jne    804040 <__udivdi3+0x50>
  804013:	39 cf                	cmp    %ecx,%edi
  804015:	77 65                	ja     80407c <__udivdi3+0x8c>
  804017:	89 fd                	mov    %edi,%ebp
  804019:	85 ff                	test   %edi,%edi
  80401b:	75 0b                	jne    804028 <__udivdi3+0x38>
  80401d:	b8 01 00 00 00       	mov    $0x1,%eax
  804022:	31 d2                	xor    %edx,%edx
  804024:	f7 f7                	div    %edi
  804026:	89 c5                	mov    %eax,%ebp
  804028:	31 d2                	xor    %edx,%edx
  80402a:	89 c8                	mov    %ecx,%eax
  80402c:	f7 f5                	div    %ebp
  80402e:	89 c1                	mov    %eax,%ecx
  804030:	89 d8                	mov    %ebx,%eax
  804032:	f7 f5                	div    %ebp
  804034:	89 cf                	mov    %ecx,%edi
  804036:	89 fa                	mov    %edi,%edx
  804038:	83 c4 1c             	add    $0x1c,%esp
  80403b:	5b                   	pop    %ebx
  80403c:	5e                   	pop    %esi
  80403d:	5f                   	pop    %edi
  80403e:	5d                   	pop    %ebp
  80403f:	c3                   	ret    
  804040:	39 ce                	cmp    %ecx,%esi
  804042:	77 28                	ja     80406c <__udivdi3+0x7c>
  804044:	0f bd fe             	bsr    %esi,%edi
  804047:	83 f7 1f             	xor    $0x1f,%edi
  80404a:	75 40                	jne    80408c <__udivdi3+0x9c>
  80404c:	39 ce                	cmp    %ecx,%esi
  80404e:	72 0a                	jb     80405a <__udivdi3+0x6a>
  804050:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804054:	0f 87 9e 00 00 00    	ja     8040f8 <__udivdi3+0x108>
  80405a:	b8 01 00 00 00       	mov    $0x1,%eax
  80405f:	89 fa                	mov    %edi,%edx
  804061:	83 c4 1c             	add    $0x1c,%esp
  804064:	5b                   	pop    %ebx
  804065:	5e                   	pop    %esi
  804066:	5f                   	pop    %edi
  804067:	5d                   	pop    %ebp
  804068:	c3                   	ret    
  804069:	8d 76 00             	lea    0x0(%esi),%esi
  80406c:	31 ff                	xor    %edi,%edi
  80406e:	31 c0                	xor    %eax,%eax
  804070:	89 fa                	mov    %edi,%edx
  804072:	83 c4 1c             	add    $0x1c,%esp
  804075:	5b                   	pop    %ebx
  804076:	5e                   	pop    %esi
  804077:	5f                   	pop    %edi
  804078:	5d                   	pop    %ebp
  804079:	c3                   	ret    
  80407a:	66 90                	xchg   %ax,%ax
  80407c:	89 d8                	mov    %ebx,%eax
  80407e:	f7 f7                	div    %edi
  804080:	31 ff                	xor    %edi,%edi
  804082:	89 fa                	mov    %edi,%edx
  804084:	83 c4 1c             	add    $0x1c,%esp
  804087:	5b                   	pop    %ebx
  804088:	5e                   	pop    %esi
  804089:	5f                   	pop    %edi
  80408a:	5d                   	pop    %ebp
  80408b:	c3                   	ret    
  80408c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804091:	89 eb                	mov    %ebp,%ebx
  804093:	29 fb                	sub    %edi,%ebx
  804095:	89 f9                	mov    %edi,%ecx
  804097:	d3 e6                	shl    %cl,%esi
  804099:	89 c5                	mov    %eax,%ebp
  80409b:	88 d9                	mov    %bl,%cl
  80409d:	d3 ed                	shr    %cl,%ebp
  80409f:	89 e9                	mov    %ebp,%ecx
  8040a1:	09 f1                	or     %esi,%ecx
  8040a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040a7:	89 f9                	mov    %edi,%ecx
  8040a9:	d3 e0                	shl    %cl,%eax
  8040ab:	89 c5                	mov    %eax,%ebp
  8040ad:	89 d6                	mov    %edx,%esi
  8040af:	88 d9                	mov    %bl,%cl
  8040b1:	d3 ee                	shr    %cl,%esi
  8040b3:	89 f9                	mov    %edi,%ecx
  8040b5:	d3 e2                	shl    %cl,%edx
  8040b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040bb:	88 d9                	mov    %bl,%cl
  8040bd:	d3 e8                	shr    %cl,%eax
  8040bf:	09 c2                	or     %eax,%edx
  8040c1:	89 d0                	mov    %edx,%eax
  8040c3:	89 f2                	mov    %esi,%edx
  8040c5:	f7 74 24 0c          	divl   0xc(%esp)
  8040c9:	89 d6                	mov    %edx,%esi
  8040cb:	89 c3                	mov    %eax,%ebx
  8040cd:	f7 e5                	mul    %ebp
  8040cf:	39 d6                	cmp    %edx,%esi
  8040d1:	72 19                	jb     8040ec <__udivdi3+0xfc>
  8040d3:	74 0b                	je     8040e0 <__udivdi3+0xf0>
  8040d5:	89 d8                	mov    %ebx,%eax
  8040d7:	31 ff                	xor    %edi,%edi
  8040d9:	e9 58 ff ff ff       	jmp    804036 <__udivdi3+0x46>
  8040de:	66 90                	xchg   %ax,%ax
  8040e0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8040e4:	89 f9                	mov    %edi,%ecx
  8040e6:	d3 e2                	shl    %cl,%edx
  8040e8:	39 c2                	cmp    %eax,%edx
  8040ea:	73 e9                	jae    8040d5 <__udivdi3+0xe5>
  8040ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8040ef:	31 ff                	xor    %edi,%edi
  8040f1:	e9 40 ff ff ff       	jmp    804036 <__udivdi3+0x46>
  8040f6:	66 90                	xchg   %ax,%ax
  8040f8:	31 c0                	xor    %eax,%eax
  8040fa:	e9 37 ff ff ff       	jmp    804036 <__udivdi3+0x46>
  8040ff:	90                   	nop

00804100 <__umoddi3>:
  804100:	55                   	push   %ebp
  804101:	57                   	push   %edi
  804102:	56                   	push   %esi
  804103:	53                   	push   %ebx
  804104:	83 ec 1c             	sub    $0x1c,%esp
  804107:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80410b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80410f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804113:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804117:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80411b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80411f:	89 f3                	mov    %esi,%ebx
  804121:	89 fa                	mov    %edi,%edx
  804123:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804127:	89 34 24             	mov    %esi,(%esp)
  80412a:	85 c0                	test   %eax,%eax
  80412c:	75 1a                	jne    804148 <__umoddi3+0x48>
  80412e:	39 f7                	cmp    %esi,%edi
  804130:	0f 86 a2 00 00 00    	jbe    8041d8 <__umoddi3+0xd8>
  804136:	89 c8                	mov    %ecx,%eax
  804138:	89 f2                	mov    %esi,%edx
  80413a:	f7 f7                	div    %edi
  80413c:	89 d0                	mov    %edx,%eax
  80413e:	31 d2                	xor    %edx,%edx
  804140:	83 c4 1c             	add    $0x1c,%esp
  804143:	5b                   	pop    %ebx
  804144:	5e                   	pop    %esi
  804145:	5f                   	pop    %edi
  804146:	5d                   	pop    %ebp
  804147:	c3                   	ret    
  804148:	39 f0                	cmp    %esi,%eax
  80414a:	0f 87 ac 00 00 00    	ja     8041fc <__umoddi3+0xfc>
  804150:	0f bd e8             	bsr    %eax,%ebp
  804153:	83 f5 1f             	xor    $0x1f,%ebp
  804156:	0f 84 ac 00 00 00    	je     804208 <__umoddi3+0x108>
  80415c:	bf 20 00 00 00       	mov    $0x20,%edi
  804161:	29 ef                	sub    %ebp,%edi
  804163:	89 fe                	mov    %edi,%esi
  804165:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804169:	89 e9                	mov    %ebp,%ecx
  80416b:	d3 e0                	shl    %cl,%eax
  80416d:	89 d7                	mov    %edx,%edi
  80416f:	89 f1                	mov    %esi,%ecx
  804171:	d3 ef                	shr    %cl,%edi
  804173:	09 c7                	or     %eax,%edi
  804175:	89 e9                	mov    %ebp,%ecx
  804177:	d3 e2                	shl    %cl,%edx
  804179:	89 14 24             	mov    %edx,(%esp)
  80417c:	89 d8                	mov    %ebx,%eax
  80417e:	d3 e0                	shl    %cl,%eax
  804180:	89 c2                	mov    %eax,%edx
  804182:	8b 44 24 08          	mov    0x8(%esp),%eax
  804186:	d3 e0                	shl    %cl,%eax
  804188:	89 44 24 04          	mov    %eax,0x4(%esp)
  80418c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804190:	89 f1                	mov    %esi,%ecx
  804192:	d3 e8                	shr    %cl,%eax
  804194:	09 d0                	or     %edx,%eax
  804196:	d3 eb                	shr    %cl,%ebx
  804198:	89 da                	mov    %ebx,%edx
  80419a:	f7 f7                	div    %edi
  80419c:	89 d3                	mov    %edx,%ebx
  80419e:	f7 24 24             	mull   (%esp)
  8041a1:	89 c6                	mov    %eax,%esi
  8041a3:	89 d1                	mov    %edx,%ecx
  8041a5:	39 d3                	cmp    %edx,%ebx
  8041a7:	0f 82 87 00 00 00    	jb     804234 <__umoddi3+0x134>
  8041ad:	0f 84 91 00 00 00    	je     804244 <__umoddi3+0x144>
  8041b3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041b7:	29 f2                	sub    %esi,%edx
  8041b9:	19 cb                	sbb    %ecx,%ebx
  8041bb:	89 d8                	mov    %ebx,%eax
  8041bd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041c1:	d3 e0                	shl    %cl,%eax
  8041c3:	89 e9                	mov    %ebp,%ecx
  8041c5:	d3 ea                	shr    %cl,%edx
  8041c7:	09 d0                	or     %edx,%eax
  8041c9:	89 e9                	mov    %ebp,%ecx
  8041cb:	d3 eb                	shr    %cl,%ebx
  8041cd:	89 da                	mov    %ebx,%edx
  8041cf:	83 c4 1c             	add    $0x1c,%esp
  8041d2:	5b                   	pop    %ebx
  8041d3:	5e                   	pop    %esi
  8041d4:	5f                   	pop    %edi
  8041d5:	5d                   	pop    %ebp
  8041d6:	c3                   	ret    
  8041d7:	90                   	nop
  8041d8:	89 fd                	mov    %edi,%ebp
  8041da:	85 ff                	test   %edi,%edi
  8041dc:	75 0b                	jne    8041e9 <__umoddi3+0xe9>
  8041de:	b8 01 00 00 00       	mov    $0x1,%eax
  8041e3:	31 d2                	xor    %edx,%edx
  8041e5:	f7 f7                	div    %edi
  8041e7:	89 c5                	mov    %eax,%ebp
  8041e9:	89 f0                	mov    %esi,%eax
  8041eb:	31 d2                	xor    %edx,%edx
  8041ed:	f7 f5                	div    %ebp
  8041ef:	89 c8                	mov    %ecx,%eax
  8041f1:	f7 f5                	div    %ebp
  8041f3:	89 d0                	mov    %edx,%eax
  8041f5:	e9 44 ff ff ff       	jmp    80413e <__umoddi3+0x3e>
  8041fa:	66 90                	xchg   %ax,%ax
  8041fc:	89 c8                	mov    %ecx,%eax
  8041fe:	89 f2                	mov    %esi,%edx
  804200:	83 c4 1c             	add    $0x1c,%esp
  804203:	5b                   	pop    %ebx
  804204:	5e                   	pop    %esi
  804205:	5f                   	pop    %edi
  804206:	5d                   	pop    %ebp
  804207:	c3                   	ret    
  804208:	3b 04 24             	cmp    (%esp),%eax
  80420b:	72 06                	jb     804213 <__umoddi3+0x113>
  80420d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804211:	77 0f                	ja     804222 <__umoddi3+0x122>
  804213:	89 f2                	mov    %esi,%edx
  804215:	29 f9                	sub    %edi,%ecx
  804217:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80421b:	89 14 24             	mov    %edx,(%esp)
  80421e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804222:	8b 44 24 04          	mov    0x4(%esp),%eax
  804226:	8b 14 24             	mov    (%esp),%edx
  804229:	83 c4 1c             	add    $0x1c,%esp
  80422c:	5b                   	pop    %ebx
  80422d:	5e                   	pop    %esi
  80422e:	5f                   	pop    %edi
  80422f:	5d                   	pop    %ebp
  804230:	c3                   	ret    
  804231:	8d 76 00             	lea    0x0(%esi),%esi
  804234:	2b 04 24             	sub    (%esp),%eax
  804237:	19 fa                	sbb    %edi,%edx
  804239:	89 d1                	mov    %edx,%ecx
  80423b:	89 c6                	mov    %eax,%esi
  80423d:	e9 71 ff ff ff       	jmp    8041b3 <__umoddi3+0xb3>
  804242:	66 90                	xchg   %ax,%ax
  804244:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804248:	72 ea                	jb     804234 <__umoddi3+0x134>
  80424a:	89 d9                	mov    %ebx,%ecx
  80424c:	e9 62 ff ff ff       	jmp    8041b3 <__umoddi3+0xb3>
