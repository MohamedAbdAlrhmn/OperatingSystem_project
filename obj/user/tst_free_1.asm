
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
  800091:	68 20 4c 80 00       	push   $0x804c20
  800096:	6a 1a                	push   $0x1a
  800098:	68 3c 4c 80 00       	push   $0x804c3c
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
  8000df:	e8 0a 2d 00 00       	call   802dee <sys_calculate_free_frames>
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
  8000fb:	e8 8e 2d 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
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
  800137:	68 50 4c 80 00       	push   $0x804c50
  80013c:	6a 3a                	push   $0x3a
  80013e:	68 3c 4c 80 00       	push   $0x804c3c
  800143:	e8 e2 17 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 41 2d 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 b8 4c 80 00       	push   $0x804cb8
  80015a:	6a 3b                	push   $0x3b
  80015c:	68 3c 4c 80 00       	push   $0x804c3c
  800161:	e8 c4 17 00 00       	call   80192a <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 83 2c 00 00       	call   802dee <sys_calculate_free_frames>
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
  80019b:	e8 4e 2c 00 00       	call   802dee <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 e8 4c 80 00       	push   $0x804ce8
  8001b1:	6a 42                	push   $0x42
  8001b3:	68 3c 4c 80 00       	push   $0x804c3c
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
  80026e:	68 2c 4d 80 00       	push   $0x804d2c
  800273:	6a 4c                	push   $0x4c
  800275:	68 3c 4c 80 00       	push   $0x804c3c
  80027a:	e8 ab 16 00 00       	call   80192a <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 0a 2c 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
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
  8002d0:	68 50 4c 80 00       	push   $0x804c50
  8002d5:	6a 51                	push   $0x51
  8002d7:	68 3c 4c 80 00       	push   $0x804c3c
  8002dc:	e8 49 16 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 a8 2b 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 b8 4c 80 00       	push   $0x804cb8
  8002f3:	6a 52                	push   $0x52
  8002f5:	68 3c 4c 80 00       	push   $0x804c3c
  8002fa:	e8 2b 16 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 ea 2a 00 00       	call   802dee <sys_calculate_free_frames>
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
  80033d:	e8 ac 2a 00 00       	call   802dee <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 e8 4c 80 00       	push   $0x804ce8
  800353:	6a 59                	push   $0x59
  800355:	68 3c 4c 80 00       	push   $0x804c3c
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
  800414:	68 2c 4d 80 00       	push   $0x804d2c
  800419:	6a 62                	push   $0x62
  80041b:	68 3c 4c 80 00       	push   $0x804c3c
  800420:	e8 05 15 00 00       	call   80192a <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 64 2a 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
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
  800475:	68 50 4c 80 00       	push   $0x804c50
  80047a:	6a 67                	push   $0x67
  80047c:	68 3c 4c 80 00       	push   $0x804c3c
  800481:	e8 a4 14 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800486:	e8 03 2a 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  80048b:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80048e:	74 14                	je     8004a4 <_main+0x46c>
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 b8 4c 80 00       	push   $0x804cb8
  800498:	6a 68                	push   $0x68
  80049a:	68 3c 4c 80 00       	push   $0x804c3c
  80049f:	e8 86 14 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a4:	e8 45 29 00 00       	call   802dee <sys_calculate_free_frames>
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
  8004e0:	e8 09 29 00 00       	call   802dee <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	83 f8 02             	cmp    $0x2,%eax
  8004ec:	74 14                	je     800502 <_main+0x4ca>
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	68 e8 4c 80 00       	push   $0x804ce8
  8004f6:	6a 6f                	push   $0x6f
  8004f8:	68 3c 4c 80 00       	push   $0x804c3c
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
  8005c6:	68 2c 4d 80 00       	push   $0x804d2c
  8005cb:	6a 78                	push   $0x78
  8005cd:	68 3c 4c 80 00       	push   $0x804c3c
  8005d2:	e8 53 13 00 00       	call   80192a <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d7:	e8 12 28 00 00       	call   802dee <sys_calculate_free_frames>
  8005dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005df:	e8 aa 28 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
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
  800643:	68 50 4c 80 00       	push   $0x804c50
  800648:	6a 7e                	push   $0x7e
  80064a:	68 3c 4c 80 00       	push   $0x804c3c
  80064f:	e8 d6 12 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800654:	e8 35 28 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  800659:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80065c:	74 14                	je     800672 <_main+0x63a>
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	68 b8 4c 80 00       	push   $0x804cb8
  800666:	6a 7f                	push   $0x7f
  800668:	68 3c 4c 80 00       	push   $0x804c3c
  80066d:	e8 b8 12 00 00       	call   80192a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800672:	e8 17 28 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
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
  8006de:	68 50 4c 80 00       	push   $0x804c50
  8006e3:	68 85 00 00 00       	push   $0x85
  8006e8:	68 3c 4c 80 00       	push   $0x804c3c
  8006ed:	e8 38 12 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f2:	e8 97 27 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  8006f7:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8006fa:	74 17                	je     800713 <_main+0x6db>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 b8 4c 80 00       	push   $0x804cb8
  800704:	68 86 00 00 00       	push   $0x86
  800709:	68 3c 4c 80 00       	push   $0x804c3c
  80070e:	e8 17 12 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800713:	e8 d6 26 00 00       	call   802dee <sys_calculate_free_frames>
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
  8007b7:	e8 32 26 00 00       	call   802dee <sys_calculate_free_frames>
  8007bc:	29 c3                	sub    %eax,%ebx
  8007be:	89 d8                	mov    %ebx,%eax
  8007c0:	83 f8 02             	cmp    $0x2,%eax
  8007c3:	74 17                	je     8007dc <_main+0x7a4>
  8007c5:	83 ec 04             	sub    $0x4,%esp
  8007c8:	68 e8 4c 80 00       	push   $0x804ce8
  8007cd:	68 8d 00 00 00       	push   $0x8d
  8007d2:	68 3c 4c 80 00       	push   $0x804c3c
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
  8008b5:	68 2c 4d 80 00       	push   $0x804d2c
  8008ba:	68 96 00 00 00       	push   $0x96
  8008bf:	68 3c 4c 80 00       	push   $0x804c3c
  8008c4:	e8 61 10 00 00       	call   80192a <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 20 25 00 00       	call   802dee <sys_calculate_free_frames>
  8008ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d1:	e8 b8 25 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
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
  80093c:	68 50 4c 80 00       	push   $0x804c50
  800941:	68 9c 00 00 00       	push   $0x9c
  800946:	68 3c 4c 80 00       	push   $0x804c3c
  80094b:	e8 da 0f 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800950:	e8 39 25 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  800955:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800958:	74 17                	je     800971 <_main+0x939>
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 b8 4c 80 00       	push   $0x804cb8
  800962:	68 9d 00 00 00       	push   $0x9d
  800967:	68 3c 4c 80 00       	push   $0x804c3c
  80096c:	e8 b9 0f 00 00       	call   80192a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800971:	e8 18 25 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
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
  8009ec:	68 50 4c 80 00       	push   $0x804c50
  8009f1:	68 a3 00 00 00       	push   $0xa3
  8009f6:	68 3c 4c 80 00       	push   $0x804c3c
  8009fb:	e8 2a 0f 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a00:	e8 89 24 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  800a05:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800a08:	74 17                	je     800a21 <_main+0x9e9>
  800a0a:	83 ec 04             	sub    $0x4,%esp
  800a0d:	68 b8 4c 80 00       	push   $0x804cb8
  800a12:	68 a4 00 00 00       	push   $0xa4
  800a17:	68 3c 4c 80 00       	push   $0x804c3c
  800a1c:	e8 09 0f 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a21:	e8 c8 23 00 00       	call   802dee <sys_calculate_free_frames>
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
  800a92:	e8 57 23 00 00       	call   802dee <sys_calculate_free_frames>
  800a97:	29 c3                	sub    %eax,%ebx
  800a99:	89 d8                	mov    %ebx,%eax
  800a9b:	83 f8 05             	cmp    $0x5,%eax
  800a9e:	74 17                	je     800ab7 <_main+0xa7f>
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 e8 4c 80 00       	push   $0x804ce8
  800aa8:	68 ac 00 00 00       	push   $0xac
  800aad:	68 3c 4c 80 00       	push   $0x804c3c
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
  800be8:	68 2c 4d 80 00       	push   $0x804d2c
  800bed:	68 b7 00 00 00       	push   $0xb7
  800bf2:	68 3c 4c 80 00       	push   $0x804c3c
  800bf7:	e8 2e 0d 00 00       	call   80192a <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfc:	e8 8d 22 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
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
  800c7a:	68 50 4c 80 00       	push   $0x804c50
  800c7f:	68 bc 00 00 00       	push   $0xbc
  800c84:	68 3c 4c 80 00       	push   $0x804c3c
  800c89:	e8 9c 0c 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c8e:	e8 fb 21 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  800c93:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800c96:	74 17                	je     800caf <_main+0xc77>
  800c98:	83 ec 04             	sub    $0x4,%esp
  800c9b:	68 b8 4c 80 00       	push   $0x804cb8
  800ca0:	68 bd 00 00 00       	push   $0xbd
  800ca5:	68 3c 4c 80 00       	push   $0x804c3c
  800caa:	e8 7b 0c 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800caf:	e8 3a 21 00 00       	call   802dee <sys_calculate_free_frames>
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
  800d03:	e8 e6 20 00 00       	call   802dee <sys_calculate_free_frames>
  800d08:	29 c3                	sub    %eax,%ebx
  800d0a:	89 d8                	mov    %ebx,%eax
  800d0c:	83 f8 02             	cmp    $0x2,%eax
  800d0f:	74 17                	je     800d28 <_main+0xcf0>
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	68 e8 4c 80 00       	push   $0x804ce8
  800d19:	68 c4 00 00 00       	push   $0xc4
  800d1e:	68 3c 4c 80 00       	push   $0x804c3c
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
  800dfe:	68 2c 4d 80 00       	push   $0x804d2c
  800e03:	68 cd 00 00 00       	push   $0xcd
  800e08:	68 3c 4c 80 00       	push   $0x804c3c
  800e0d:	e8 18 0b 00 00       	call   80192a <_panic>
	}

	{
		//Free 1st 2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800e12:	e8 d7 1f 00 00       	call   802dee <sys_calculate_free_frames>
  800e17:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e1d:	e8 6c 20 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  800e22:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[0]);
  800e28:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	e8 5d 1d 00 00       	call   802b94 <free>
  800e37:	83 c4 10             	add    $0x10,%esp

		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e3a:	e8 4f 20 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  800e3f:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800e45:	74 17                	je     800e5e <_main+0xe26>
  800e47:	83 ec 04             	sub    $0x4,%esp
  800e4a:	68 4c 4d 80 00       	push   $0x804d4c
  800e4f:	68 d6 00 00 00       	push   $0xd6
  800e54:	68 3c 4c 80 00       	push   $0x804c3c
  800e59:	e8 cc 0a 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800e5e:	e8 8b 1f 00 00       	call   802dee <sys_calculate_free_frames>
  800e63:	89 c2                	mov    %eax,%edx
  800e65:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800e6b:	29 c2                	sub    %eax,%edx
  800e6d:	89 d0                	mov    %edx,%eax
  800e6f:	83 f8 02             	cmp    $0x2,%eax
  800e72:	74 17                	je     800e8b <_main+0xe53>
  800e74:	83 ec 04             	sub    $0x4,%esp
  800e77:	68 88 4d 80 00       	push   $0x804d88
  800e7c:	68 d7 00 00 00       	push   $0xd7
  800e81:	68 3c 4c 80 00       	push   $0x804c3c
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
  800ee0:	68 d4 4d 80 00       	push   $0x804dd4
  800ee5:	68 dc 00 00 00       	push   $0xdc
  800eea:	68 3c 4c 80 00       	push   $0x804c3c
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
  800f42:	68 d4 4d 80 00       	push   $0x804dd4
  800f47:	68 de 00 00 00       	push   $0xde
  800f4c:	68 3c 4c 80 00       	push   $0x804c3c
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
  800f6c:	e8 7d 1e 00 00       	call   802dee <sys_calculate_free_frames>
  800f71:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f77:	e8 12 1f 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  800f7c:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[1]);
  800f82:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800f88:	83 ec 0c             	sub    $0xc,%esp
  800f8b:	50                   	push   %eax
  800f8c:	e8 03 1c 00 00       	call   802b94 <free>
  800f91:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f94:	e8 f5 1e 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  800f99:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800f9f:	74 17                	je     800fb8 <_main+0xf80>
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	68 4c 4d 80 00       	push   $0x804d4c
  800fa9:	68 e6 00 00 00       	push   $0xe6
  800fae:	68 3c 4c 80 00       	push   $0x804c3c
  800fb3:	e8 72 09 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fb8:	e8 31 1e 00 00       	call   802dee <sys_calculate_free_frames>
  800fbd:	89 c2                	mov    %eax,%edx
  800fbf:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800fc5:	29 c2                	sub    %eax,%edx
  800fc7:	89 d0                	mov    %edx,%eax
  800fc9:	83 f8 03             	cmp    $0x3,%eax
  800fcc:	74 17                	je     800fe5 <_main+0xfad>
  800fce:	83 ec 04             	sub    $0x4,%esp
  800fd1:	68 88 4d 80 00       	push   $0x804d88
  800fd6:	68 e7 00 00 00       	push   $0xe7
  800fdb:	68 3c 4c 80 00       	push   $0x804c3c
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
  80103a:	68 d4 4d 80 00       	push   $0x804dd4
  80103f:	68 eb 00 00 00       	push   $0xeb
  801044:	68 3c 4c 80 00       	push   $0x804c3c
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
  8010a0:	68 d4 4d 80 00       	push   $0x804dd4
  8010a5:	68 ed 00 00 00       	push   $0xed
  8010aa:	68 3c 4c 80 00       	push   $0x804c3c
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
  8010ca:	e8 1f 1d 00 00       	call   802dee <sys_calculate_free_frames>
  8010cf:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8010d5:	e8 b4 1d 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  8010da:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[6]);
  8010e0:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	50                   	push   %eax
  8010ea:	e8 a5 1a 00 00       	call   802b94 <free>
  8010ef:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8010f2:	e8 97 1d 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  8010f7:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8010fd:	74 17                	je     801116 <_main+0x10de>
  8010ff:	83 ec 04             	sub    $0x4,%esp
  801102:	68 4c 4d 80 00       	push   $0x804d4c
  801107:	68 f4 00 00 00       	push   $0xf4
  80110c:	68 3c 4c 80 00       	push   $0x804c3c
  801111:	e8 14 08 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801116:	e8 d3 1c 00 00       	call   802dee <sys_calculate_free_frames>
  80111b:	89 c2                	mov    %eax,%edx
  80111d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801123:	29 c2                	sub    %eax,%edx
  801125:	89 d0                	mov    %edx,%eax
  801127:	83 f8 04             	cmp    $0x4,%eax
  80112a:	74 17                	je     801143 <_main+0x110b>
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	68 88 4d 80 00       	push   $0x804d88
  801134:	68 f5 00 00 00       	push   $0xf5
  801139:	68 3c 4c 80 00       	push   $0x804c3c
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
  80119b:	68 d4 4d 80 00       	push   $0x804dd4
  8011a0:	68 f9 00 00 00       	push   $0xf9
  8011a5:	68 3c 4c 80 00       	push   $0x804c3c
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
  80120e:	68 d4 4d 80 00       	push   $0x804dd4
  801213:	68 fb 00 00 00       	push   $0xfb
  801218:	68 3c 4c 80 00       	push   $0x804c3c
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
  801276:	68 d4 4d 80 00       	push   $0x804dd4
  80127b:	68 fd 00 00 00       	push   $0xfd
  801280:	68 3c 4c 80 00       	push   $0x804c3c
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
  8012a0:	e8 49 1b 00 00       	call   802dee <sys_calculate_free_frames>
  8012a5:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012ab:	e8 de 1b 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  8012b0:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[4]);
  8012b6:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8012bc:	83 ec 0c             	sub    $0xc,%esp
  8012bf:	50                   	push   %eax
  8012c0:	e8 cf 18 00 00       	call   802b94 <free>
  8012c5:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8012c8:	e8 c1 1b 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  8012cd:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8012d3:	74 17                	je     8012ec <_main+0x12b4>
  8012d5:	83 ec 04             	sub    $0x4,%esp
  8012d8:	68 4c 4d 80 00       	push   $0x804d4c
  8012dd:	68 04 01 00 00       	push   $0x104
  8012e2:	68 3c 4c 80 00       	push   $0x804c3c
  8012e7:	e8 3e 06 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8012ec:	e8 fd 1a 00 00       	call   802dee <sys_calculate_free_frames>
  8012f1:	89 c2                	mov    %eax,%edx
  8012f3:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8012f9:	29 c2                	sub    %eax,%edx
  8012fb:	89 d0                	mov    %edx,%eax
  8012fd:	83 f8 02             	cmp    $0x2,%eax
  801300:	74 17                	je     801319 <_main+0x12e1>
  801302:	83 ec 04             	sub    $0x4,%esp
  801305:	68 88 4d 80 00       	push   $0x804d88
  80130a:	68 05 01 00 00       	push   $0x105
  80130f:	68 3c 4c 80 00       	push   $0x804c3c
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
  801371:	68 d4 4d 80 00       	push   $0x804dd4
  801376:	68 09 01 00 00       	push   $0x109
  80137b:	68 3c 4c 80 00       	push   $0x804c3c
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
  8013e0:	68 d4 4d 80 00       	push   $0x804dd4
  8013e5:	68 0b 01 00 00       	push   $0x10b
  8013ea:	68 3c 4c 80 00       	push   $0x804c3c
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
  80140a:	e8 df 19 00 00       	call   802dee <sys_calculate_free_frames>
  80140f:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801415:	e8 74 1a 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  80141a:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[5]);
  801420:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  801426:	83 ec 0c             	sub    $0xc,%esp
  801429:	50                   	push   %eax
  80142a:	e8 65 17 00 00       	call   802b94 <free>
  80142f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801432:	e8 57 1a 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  801437:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  80143d:	74 17                	je     801456 <_main+0x141e>
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	68 4c 4d 80 00       	push   $0x804d4c
  801447:	68 12 01 00 00       	push   $0x112
  80144c:	68 3c 4c 80 00       	push   $0x804c3c
  801451:	e8 d4 04 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801456:	e8 93 19 00 00       	call   802dee <sys_calculate_free_frames>
  80145b:	89 c2                	mov    %eax,%edx
  80145d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801463:	39 c2                	cmp    %eax,%edx
  801465:	74 17                	je     80147e <_main+0x1446>
  801467:	83 ec 04             	sub    $0x4,%esp
  80146a:	68 88 4d 80 00       	push   $0x804d88
  80146f:	68 13 01 00 00       	push   $0x113
  801474:	68 3c 4c 80 00       	push   $0x804c3c
  801479:	e8 ac 04 00 00       	call   80192a <_panic>

		//Free 1st 2 KB
		freeFrames = sys_calculate_free_frames() ;
  80147e:	e8 6b 19 00 00       	call   802dee <sys_calculate_free_frames>
  801483:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801489:	e8 00 1a 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  80148e:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[2]);
  801494:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80149a:	83 ec 0c             	sub    $0xc,%esp
  80149d:	50                   	push   %eax
  80149e:	e8 f1 16 00 00       	call   802b94 <free>
  8014a3:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8014a6:	e8 e3 19 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  8014ab:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8014b1:	74 17                	je     8014ca <_main+0x1492>
  8014b3:	83 ec 04             	sub    $0x4,%esp
  8014b6:	68 4c 4d 80 00       	push   $0x804d4c
  8014bb:	68 19 01 00 00       	push   $0x119
  8014c0:	68 3c 4c 80 00       	push   $0x804c3c
  8014c5:	e8 60 04 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8014ca:	e8 1f 19 00 00       	call   802dee <sys_calculate_free_frames>
  8014cf:	89 c2                	mov    %eax,%edx
  8014d1:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8014d7:	29 c2                	sub    %eax,%edx
  8014d9:	89 d0                	mov    %edx,%eax
  8014db:	83 f8 02             	cmp    $0x2,%eax
  8014de:	74 17                	je     8014f7 <_main+0x14bf>
  8014e0:	83 ec 04             	sub    $0x4,%esp
  8014e3:	68 88 4d 80 00       	push   $0x804d88
  8014e8:	68 1a 01 00 00       	push   $0x11a
  8014ed:	68 3c 4c 80 00       	push   $0x804c3c
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
  80154c:	68 d4 4d 80 00       	push   $0x804dd4
  801551:	68 1e 01 00 00       	push   $0x11e
  801556:	68 3c 4c 80 00       	push   $0x804c3c
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
  8015b5:	68 d4 4d 80 00       	push   $0x804dd4
  8015ba:	68 20 01 00 00       	push   $0x120
  8015bf:	68 3c 4c 80 00       	push   $0x804c3c
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
  8015df:	e8 0a 18 00 00       	call   802dee <sys_calculate_free_frames>
  8015e4:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8015ea:	e8 9f 18 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  8015ef:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[3]);
  8015f5:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  8015fb:	83 ec 0c             	sub    $0xc,%esp
  8015fe:	50                   	push   %eax
  8015ff:	e8 90 15 00 00       	call   802b94 <free>
  801604:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801607:	e8 82 18 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  80160c:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801612:	74 17                	je     80162b <_main+0x15f3>
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	68 4c 4d 80 00       	push   $0x804d4c
  80161c:	68 27 01 00 00       	push   $0x127
  801621:	68 3c 4c 80 00       	push   $0x804c3c
  801626:	e8 ff 02 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80162b:	e8 be 17 00 00       	call   802dee <sys_calculate_free_frames>
  801630:	89 c2                	mov    %eax,%edx
  801632:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801638:	39 c2                	cmp    %eax,%edx
  80163a:	74 17                	je     801653 <_main+0x161b>
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 88 4d 80 00       	push   $0x804d88
  801644:	68 28 01 00 00       	push   $0x128
  801649:	68 3c 4c 80 00       	push   $0x804c3c
  80164e:	e8 d7 02 00 00       	call   80192a <_panic>


		//Free last 14 KB
		freeFrames = sys_calculate_free_frames() ;
  801653:	e8 96 17 00 00       	call   802dee <sys_calculate_free_frames>
  801658:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80165e:	e8 2b 18 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  801663:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[7]);
  801669:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80166f:	83 ec 0c             	sub    $0xc,%esp
  801672:	50                   	push   %eax
  801673:	e8 1c 15 00 00       	call   802b94 <free>
  801678:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80167b:	e8 0e 18 00 00       	call   802e8e <sys_pf_calculate_allocated_pages>
  801680:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801686:	74 17                	je     80169f <_main+0x1667>
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	68 4c 4d 80 00       	push   $0x804d4c
  801690:	68 2f 01 00 00       	push   $0x12f
  801695:	68 3c 4c 80 00       	push   $0x804c3c
  80169a:	e8 8b 02 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80169f:	e8 4a 17 00 00       	call   802dee <sys_calculate_free_frames>
  8016a4:	89 c2                	mov    %eax,%edx
  8016a6:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8016ac:	29 c2                	sub    %eax,%edx
  8016ae:	89 d0                	mov    %edx,%eax
  8016b0:	83 f8 03             	cmp    $0x3,%eax
  8016b3:	74 17                	je     8016cc <_main+0x1694>
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 88 4d 80 00       	push   $0x804d88
  8016bd:	68 30 01 00 00       	push   $0x130
  8016c2:	68 3c 4c 80 00       	push   $0x804c3c
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
  801721:	68 d4 4d 80 00       	push   $0x804dd4
  801726:	68 34 01 00 00       	push   $0x134
  80172b:	68 3c 4c 80 00       	push   $0x804c3c
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
  801787:	68 d4 4d 80 00       	push   $0x804dd4
  80178c:	68 36 01 00 00       	push   $0x136
  801791:	68 3c 4c 80 00       	push   $0x804c3c
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
  8017b1:	e8 38 16 00 00       	call   802dee <sys_calculate_free_frames>
  8017b6:	89 c2                	mov    %eax,%edx
  8017b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017bb:	39 c2                	cmp    %eax,%edx
  8017bd:	74 17                	je     8017d6 <_main+0x179e>
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 f8 4d 80 00       	push   $0x804df8
  8017c7:	68 39 01 00 00       	push   $0x139
  8017cc:	68 3c 4c 80 00       	push   $0x804c3c
  8017d1:	e8 54 01 00 00       	call   80192a <_panic>
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	68 2c 4e 80 00       	push   $0x804e2c
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
  8017f4:	e8 d5 18 00 00       	call   8030ce <sys_getenvindex>
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
  80185f:	e8 77 16 00 00       	call   802edb <sys_disable_interrupt>
	cprintf("**************************************\n");
  801864:	83 ec 0c             	sub    $0xc,%esp
  801867:	68 80 4e 80 00       	push   $0x804e80
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
  80188f:	68 a8 4e 80 00       	push   $0x804ea8
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
  8018c0:	68 d0 4e 80 00       	push   $0x804ed0
  8018c5:	e8 14 03 00 00       	call   801bde <cprintf>
  8018ca:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8018cd:	a1 20 60 80 00       	mov    0x806020,%eax
  8018d2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8018d8:	83 ec 08             	sub    $0x8,%esp
  8018db:	50                   	push   %eax
  8018dc:	68 28 4f 80 00       	push   $0x804f28
  8018e1:	e8 f8 02 00 00       	call   801bde <cprintf>
  8018e6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8018e9:	83 ec 0c             	sub    $0xc,%esp
  8018ec:	68 80 4e 80 00       	push   $0x804e80
  8018f1:	e8 e8 02 00 00       	call   801bde <cprintf>
  8018f6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8018f9:	e8 f7 15 00 00       	call   802ef5 <sys_enable_interrupt>

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
  801911:	e8 84 17 00 00       	call   80309a <sys_destroy_env>
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
  801922:	e8 d9 17 00 00       	call   803100 <sys_exit_env>
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
  80194b:	68 3c 4f 80 00       	push   $0x804f3c
  801950:	e8 89 02 00 00       	call   801bde <cprintf>
  801955:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801958:	a1 00 60 80 00       	mov    0x806000,%eax
  80195d:	ff 75 0c             	pushl  0xc(%ebp)
  801960:	ff 75 08             	pushl  0x8(%ebp)
  801963:	50                   	push   %eax
  801964:	68 41 4f 80 00       	push   $0x804f41
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
  801988:	68 5d 4f 80 00       	push   $0x804f5d
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
  8019b4:	68 60 4f 80 00       	push   $0x804f60
  8019b9:	6a 26                	push   $0x26
  8019bb:	68 ac 4f 80 00       	push   $0x804fac
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
  801a86:	68 b8 4f 80 00       	push   $0x804fb8
  801a8b:	6a 3a                	push   $0x3a
  801a8d:	68 ac 4f 80 00       	push   $0x804fac
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
  801af6:	68 0c 50 80 00       	push   $0x80500c
  801afb:	6a 44                	push   $0x44
  801afd:	68 ac 4f 80 00       	push   $0x804fac
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
  801b50:	e8 d8 11 00 00       	call   802d2d <sys_cputs>
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
  801bc7:	e8 61 11 00 00       	call   802d2d <sys_cputs>
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
  801c11:	e8 c5 12 00 00       	call   802edb <sys_disable_interrupt>
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
  801c31:	e8 bf 12 00 00       	call   802ef5 <sys_enable_interrupt>
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
  801c7b:	e8 30 2d 00 00       	call   8049b0 <__udivdi3>
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
  801ccb:	e8 f0 2d 00 00       	call   804ac0 <__umoddi3>
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	05 74 52 80 00       	add    $0x805274,%eax
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
  801e26:	8b 04 85 98 52 80 00 	mov    0x805298(,%eax,4),%eax
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
  801f07:	8b 34 9d e0 50 80 00 	mov    0x8050e0(,%ebx,4),%esi
  801f0e:	85 f6                	test   %esi,%esi
  801f10:	75 19                	jne    801f2b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801f12:	53                   	push   %ebx
  801f13:	68 85 52 80 00       	push   $0x805285
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
  801f2c:	68 8e 52 80 00       	push   $0x80528e
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
  801f59:	be 91 52 80 00       	mov    $0x805291,%esi
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
  80297f:	68 f0 53 80 00       	push   $0x8053f0
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
  802a4f:	e8 1d 04 00 00       	call   802e71 <sys_allocate_chunk>
  802a54:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802a57:	a1 20 61 80 00       	mov    0x806120,%eax
  802a5c:	83 ec 0c             	sub    $0xc,%esp
  802a5f:	50                   	push   %eax
  802a60:	e8 92 0a 00 00       	call   8034f7 <initialize_MemBlocksList>
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
  802a8d:	68 15 54 80 00       	push   $0x805415
  802a92:	6a 33                	push   $0x33
  802a94:	68 33 54 80 00       	push   $0x805433
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
  802b0c:	68 40 54 80 00       	push   $0x805440
  802b11:	6a 34                	push   $0x34
  802b13:	68 33 54 80 00       	push   $0x805433
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
  802b81:	68 64 54 80 00       	push   $0x805464
  802b86:	6a 46                	push   $0x46
  802b88:	68 33 54 80 00       	push   $0x805433
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
  802b9d:	68 8c 54 80 00       	push   $0x80548c
  802ba2:	6a 61                	push   $0x61
  802ba4:	68 33 54 80 00       	push   $0x805433
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
  802bc3:	75 07                	jne    802bcc <smalloc+0x1e>
  802bc5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bca:	eb 7c                	jmp    802c48 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802bcc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd9:	01 d0                	add    %edx,%eax
  802bdb:	48                   	dec    %eax
  802bdc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802bdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be2:	ba 00 00 00 00       	mov    $0x0,%edx
  802be7:	f7 75 f0             	divl   -0x10(%ebp)
  802bea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bed:	29 d0                	sub    %edx,%eax
  802bef:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  802bf2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802bf9:	e8 41 06 00 00       	call   80323f <sys_isUHeapPlacementStrategyFIRSTFIT>
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	74 11                	je     802c13 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  802c02:	83 ec 0c             	sub    $0xc,%esp
  802c05:	ff 75 e8             	pushl  -0x18(%ebp)
  802c08:	e8 ac 0c 00 00       	call   8038b9 <alloc_block_FF>
  802c0d:	83 c4 10             	add    $0x10,%esp
  802c10:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  802c13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c17:	74 2a                	je     802c43 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 40 08             	mov    0x8(%eax),%eax
  802c1f:	89 c2                	mov    %eax,%edx
  802c21:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802c25:	52                   	push   %edx
  802c26:	50                   	push   %eax
  802c27:	ff 75 0c             	pushl  0xc(%ebp)
  802c2a:	ff 75 08             	pushl  0x8(%ebp)
  802c2d:	e8 92 03 00 00       	call   802fc4 <sys_createSharedObject>
  802c32:	83 c4 10             	add    $0x10,%esp
  802c35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  802c38:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802c3c:	74 05                	je     802c43 <smalloc+0x95>
			return (void*)virtual_address;
  802c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c41:	eb 05                	jmp    802c48 <smalloc+0x9a>
	}
	return NULL;
  802c43:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802c48:	c9                   	leave  
  802c49:	c3                   	ret    

00802c4a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802c4a:	55                   	push   %ebp
  802c4b:	89 e5                	mov    %esp,%ebp
  802c4d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802c50:	e8 13 fd ff ff       	call   802968 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802c55:	83 ec 04             	sub    $0x4,%esp
  802c58:	68 b0 54 80 00       	push   $0x8054b0
  802c5d:	68 a2 00 00 00       	push   $0xa2
  802c62:	68 33 54 80 00       	push   $0x805433
  802c67:	e8 be ec ff ff       	call   80192a <_panic>

00802c6c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802c6c:	55                   	push   %ebp
  802c6d:	89 e5                	mov    %esp,%ebp
  802c6f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802c72:	e8 f1 fc ff ff       	call   802968 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802c77:	83 ec 04             	sub    $0x4,%esp
  802c7a:	68 d4 54 80 00       	push   $0x8054d4
  802c7f:	68 e6 00 00 00       	push   $0xe6
  802c84:	68 33 54 80 00       	push   $0x805433
  802c89:	e8 9c ec ff ff       	call   80192a <_panic>

00802c8e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802c8e:	55                   	push   %ebp
  802c8f:	89 e5                	mov    %esp,%ebp
  802c91:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802c94:	83 ec 04             	sub    $0x4,%esp
  802c97:	68 fc 54 80 00       	push   $0x8054fc
  802c9c:	68 fa 00 00 00       	push   $0xfa
  802ca1:	68 33 54 80 00       	push   $0x805433
  802ca6:	e8 7f ec ff ff       	call   80192a <_panic>

00802cab <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802cab:	55                   	push   %ebp
  802cac:	89 e5                	mov    %esp,%ebp
  802cae:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802cb1:	83 ec 04             	sub    $0x4,%esp
  802cb4:	68 20 55 80 00       	push   $0x805520
  802cb9:	68 05 01 00 00       	push   $0x105
  802cbe:	68 33 54 80 00       	push   $0x805433
  802cc3:	e8 62 ec ff ff       	call   80192a <_panic>

00802cc8 <shrink>:

}
void shrink(uint32 newSize)
{
  802cc8:	55                   	push   %ebp
  802cc9:	89 e5                	mov    %esp,%ebp
  802ccb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802cce:	83 ec 04             	sub    $0x4,%esp
  802cd1:	68 20 55 80 00       	push   $0x805520
  802cd6:	68 0a 01 00 00       	push   $0x10a
  802cdb:	68 33 54 80 00       	push   $0x805433
  802ce0:	e8 45 ec ff ff       	call   80192a <_panic>

00802ce5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802ce5:	55                   	push   %ebp
  802ce6:	89 e5                	mov    %esp,%ebp
  802ce8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802ceb:	83 ec 04             	sub    $0x4,%esp
  802cee:	68 20 55 80 00       	push   $0x805520
  802cf3:	68 0f 01 00 00       	push   $0x10f
  802cf8:	68 33 54 80 00       	push   $0x805433
  802cfd:	e8 28 ec ff ff       	call   80192a <_panic>

00802d02 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802d02:	55                   	push   %ebp
  802d03:	89 e5                	mov    %esp,%ebp
  802d05:	57                   	push   %edi
  802d06:	56                   	push   %esi
  802d07:	53                   	push   %ebx
  802d08:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d11:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d14:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d17:	8b 7d 18             	mov    0x18(%ebp),%edi
  802d1a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802d1d:	cd 30                	int    $0x30
  802d1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802d25:	83 c4 10             	add    $0x10,%esp
  802d28:	5b                   	pop    %ebx
  802d29:	5e                   	pop    %esi
  802d2a:	5f                   	pop    %edi
  802d2b:	5d                   	pop    %ebp
  802d2c:	c3                   	ret    

00802d2d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802d2d:	55                   	push   %ebp
  802d2e:	89 e5                	mov    %esp,%ebp
  802d30:	83 ec 04             	sub    $0x4,%esp
  802d33:	8b 45 10             	mov    0x10(%ebp),%eax
  802d36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802d39:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d40:	6a 00                	push   $0x0
  802d42:	6a 00                	push   $0x0
  802d44:	52                   	push   %edx
  802d45:	ff 75 0c             	pushl  0xc(%ebp)
  802d48:	50                   	push   %eax
  802d49:	6a 00                	push   $0x0
  802d4b:	e8 b2 ff ff ff       	call   802d02 <syscall>
  802d50:	83 c4 18             	add    $0x18,%esp
}
  802d53:	90                   	nop
  802d54:	c9                   	leave  
  802d55:	c3                   	ret    

00802d56 <sys_cgetc>:

int
sys_cgetc(void)
{
  802d56:	55                   	push   %ebp
  802d57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802d59:	6a 00                	push   $0x0
  802d5b:	6a 00                	push   $0x0
  802d5d:	6a 00                	push   $0x0
  802d5f:	6a 00                	push   $0x0
  802d61:	6a 00                	push   $0x0
  802d63:	6a 01                	push   $0x1
  802d65:	e8 98 ff ff ff       	call   802d02 <syscall>
  802d6a:	83 c4 18             	add    $0x18,%esp
}
  802d6d:	c9                   	leave  
  802d6e:	c3                   	ret    

00802d6f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802d6f:	55                   	push   %ebp
  802d70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802d72:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	6a 00                	push   $0x0
  802d7a:	6a 00                	push   $0x0
  802d7c:	6a 00                	push   $0x0
  802d7e:	52                   	push   %edx
  802d7f:	50                   	push   %eax
  802d80:	6a 05                	push   $0x5
  802d82:	e8 7b ff ff ff       	call   802d02 <syscall>
  802d87:	83 c4 18             	add    $0x18,%esp
}
  802d8a:	c9                   	leave  
  802d8b:	c3                   	ret    

00802d8c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802d8c:	55                   	push   %ebp
  802d8d:	89 e5                	mov    %esp,%ebp
  802d8f:	56                   	push   %esi
  802d90:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802d91:	8b 75 18             	mov    0x18(%ebp),%esi
  802d94:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802d97:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802da0:	56                   	push   %esi
  802da1:	53                   	push   %ebx
  802da2:	51                   	push   %ecx
  802da3:	52                   	push   %edx
  802da4:	50                   	push   %eax
  802da5:	6a 06                	push   $0x6
  802da7:	e8 56 ff ff ff       	call   802d02 <syscall>
  802dac:	83 c4 18             	add    $0x18,%esp
}
  802daf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802db2:	5b                   	pop    %ebx
  802db3:	5e                   	pop    %esi
  802db4:	5d                   	pop    %ebp
  802db5:	c3                   	ret    

00802db6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802db6:	55                   	push   %ebp
  802db7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802db9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	6a 00                	push   $0x0
  802dc1:	6a 00                	push   $0x0
  802dc3:	6a 00                	push   $0x0
  802dc5:	52                   	push   %edx
  802dc6:	50                   	push   %eax
  802dc7:	6a 07                	push   $0x7
  802dc9:	e8 34 ff ff ff       	call   802d02 <syscall>
  802dce:	83 c4 18             	add    $0x18,%esp
}
  802dd1:	c9                   	leave  
  802dd2:	c3                   	ret    

00802dd3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802dd3:	55                   	push   %ebp
  802dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802dd6:	6a 00                	push   $0x0
  802dd8:	6a 00                	push   $0x0
  802dda:	6a 00                	push   $0x0
  802ddc:	ff 75 0c             	pushl  0xc(%ebp)
  802ddf:	ff 75 08             	pushl  0x8(%ebp)
  802de2:	6a 08                	push   $0x8
  802de4:	e8 19 ff ff ff       	call   802d02 <syscall>
  802de9:	83 c4 18             	add    $0x18,%esp
}
  802dec:	c9                   	leave  
  802ded:	c3                   	ret    

00802dee <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802dee:	55                   	push   %ebp
  802def:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802df1:	6a 00                	push   $0x0
  802df3:	6a 00                	push   $0x0
  802df5:	6a 00                	push   $0x0
  802df7:	6a 00                	push   $0x0
  802df9:	6a 00                	push   $0x0
  802dfb:	6a 09                	push   $0x9
  802dfd:	e8 00 ff ff ff       	call   802d02 <syscall>
  802e02:	83 c4 18             	add    $0x18,%esp
}
  802e05:	c9                   	leave  
  802e06:	c3                   	ret    

00802e07 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802e07:	55                   	push   %ebp
  802e08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802e0a:	6a 00                	push   $0x0
  802e0c:	6a 00                	push   $0x0
  802e0e:	6a 00                	push   $0x0
  802e10:	6a 00                	push   $0x0
  802e12:	6a 00                	push   $0x0
  802e14:	6a 0a                	push   $0xa
  802e16:	e8 e7 fe ff ff       	call   802d02 <syscall>
  802e1b:	83 c4 18             	add    $0x18,%esp
}
  802e1e:	c9                   	leave  
  802e1f:	c3                   	ret    

00802e20 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802e20:	55                   	push   %ebp
  802e21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802e23:	6a 00                	push   $0x0
  802e25:	6a 00                	push   $0x0
  802e27:	6a 00                	push   $0x0
  802e29:	6a 00                	push   $0x0
  802e2b:	6a 00                	push   $0x0
  802e2d:	6a 0b                	push   $0xb
  802e2f:	e8 ce fe ff ff       	call   802d02 <syscall>
  802e34:	83 c4 18             	add    $0x18,%esp
}
  802e37:	c9                   	leave  
  802e38:	c3                   	ret    

00802e39 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802e39:	55                   	push   %ebp
  802e3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802e3c:	6a 00                	push   $0x0
  802e3e:	6a 00                	push   $0x0
  802e40:	6a 00                	push   $0x0
  802e42:	ff 75 0c             	pushl  0xc(%ebp)
  802e45:	ff 75 08             	pushl  0x8(%ebp)
  802e48:	6a 0f                	push   $0xf
  802e4a:	e8 b3 fe ff ff       	call   802d02 <syscall>
  802e4f:	83 c4 18             	add    $0x18,%esp
	return;
  802e52:	90                   	nop
}
  802e53:	c9                   	leave  
  802e54:	c3                   	ret    

00802e55 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802e55:	55                   	push   %ebp
  802e56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802e58:	6a 00                	push   $0x0
  802e5a:	6a 00                	push   $0x0
  802e5c:	6a 00                	push   $0x0
  802e5e:	ff 75 0c             	pushl  0xc(%ebp)
  802e61:	ff 75 08             	pushl  0x8(%ebp)
  802e64:	6a 10                	push   $0x10
  802e66:	e8 97 fe ff ff       	call   802d02 <syscall>
  802e6b:	83 c4 18             	add    $0x18,%esp
	return ;
  802e6e:	90                   	nop
}
  802e6f:	c9                   	leave  
  802e70:	c3                   	ret    

00802e71 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802e71:	55                   	push   %ebp
  802e72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802e74:	6a 00                	push   $0x0
  802e76:	6a 00                	push   $0x0
  802e78:	ff 75 10             	pushl  0x10(%ebp)
  802e7b:	ff 75 0c             	pushl  0xc(%ebp)
  802e7e:	ff 75 08             	pushl  0x8(%ebp)
  802e81:	6a 11                	push   $0x11
  802e83:	e8 7a fe ff ff       	call   802d02 <syscall>
  802e88:	83 c4 18             	add    $0x18,%esp
	return ;
  802e8b:	90                   	nop
}
  802e8c:	c9                   	leave  
  802e8d:	c3                   	ret    

00802e8e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802e8e:	55                   	push   %ebp
  802e8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802e91:	6a 00                	push   $0x0
  802e93:	6a 00                	push   $0x0
  802e95:	6a 00                	push   $0x0
  802e97:	6a 00                	push   $0x0
  802e99:	6a 00                	push   $0x0
  802e9b:	6a 0c                	push   $0xc
  802e9d:	e8 60 fe ff ff       	call   802d02 <syscall>
  802ea2:	83 c4 18             	add    $0x18,%esp
}
  802ea5:	c9                   	leave  
  802ea6:	c3                   	ret    

00802ea7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802ea7:	55                   	push   %ebp
  802ea8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802eaa:	6a 00                	push   $0x0
  802eac:	6a 00                	push   $0x0
  802eae:	6a 00                	push   $0x0
  802eb0:	6a 00                	push   $0x0
  802eb2:	ff 75 08             	pushl  0x8(%ebp)
  802eb5:	6a 0d                	push   $0xd
  802eb7:	e8 46 fe ff ff       	call   802d02 <syscall>
  802ebc:	83 c4 18             	add    $0x18,%esp
}
  802ebf:	c9                   	leave  
  802ec0:	c3                   	ret    

00802ec1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802ec1:	55                   	push   %ebp
  802ec2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802ec4:	6a 00                	push   $0x0
  802ec6:	6a 00                	push   $0x0
  802ec8:	6a 00                	push   $0x0
  802eca:	6a 00                	push   $0x0
  802ecc:	6a 00                	push   $0x0
  802ece:	6a 0e                	push   $0xe
  802ed0:	e8 2d fe ff ff       	call   802d02 <syscall>
  802ed5:	83 c4 18             	add    $0x18,%esp
}
  802ed8:	90                   	nop
  802ed9:	c9                   	leave  
  802eda:	c3                   	ret    

00802edb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802edb:	55                   	push   %ebp
  802edc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802ede:	6a 00                	push   $0x0
  802ee0:	6a 00                	push   $0x0
  802ee2:	6a 00                	push   $0x0
  802ee4:	6a 00                	push   $0x0
  802ee6:	6a 00                	push   $0x0
  802ee8:	6a 13                	push   $0x13
  802eea:	e8 13 fe ff ff       	call   802d02 <syscall>
  802eef:	83 c4 18             	add    $0x18,%esp
}
  802ef2:	90                   	nop
  802ef3:	c9                   	leave  
  802ef4:	c3                   	ret    

00802ef5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802ef5:	55                   	push   %ebp
  802ef6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802ef8:	6a 00                	push   $0x0
  802efa:	6a 00                	push   $0x0
  802efc:	6a 00                	push   $0x0
  802efe:	6a 00                	push   $0x0
  802f00:	6a 00                	push   $0x0
  802f02:	6a 14                	push   $0x14
  802f04:	e8 f9 fd ff ff       	call   802d02 <syscall>
  802f09:	83 c4 18             	add    $0x18,%esp
}
  802f0c:	90                   	nop
  802f0d:	c9                   	leave  
  802f0e:	c3                   	ret    

00802f0f <sys_cputc>:


void
sys_cputc(const char c)
{
  802f0f:	55                   	push   %ebp
  802f10:	89 e5                	mov    %esp,%ebp
  802f12:	83 ec 04             	sub    $0x4,%esp
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802f1b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f1f:	6a 00                	push   $0x0
  802f21:	6a 00                	push   $0x0
  802f23:	6a 00                	push   $0x0
  802f25:	6a 00                	push   $0x0
  802f27:	50                   	push   %eax
  802f28:	6a 15                	push   $0x15
  802f2a:	e8 d3 fd ff ff       	call   802d02 <syscall>
  802f2f:	83 c4 18             	add    $0x18,%esp
}
  802f32:	90                   	nop
  802f33:	c9                   	leave  
  802f34:	c3                   	ret    

00802f35 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802f35:	55                   	push   %ebp
  802f36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802f38:	6a 00                	push   $0x0
  802f3a:	6a 00                	push   $0x0
  802f3c:	6a 00                	push   $0x0
  802f3e:	6a 00                	push   $0x0
  802f40:	6a 00                	push   $0x0
  802f42:	6a 16                	push   $0x16
  802f44:	e8 b9 fd ff ff       	call   802d02 <syscall>
  802f49:	83 c4 18             	add    $0x18,%esp
}
  802f4c:	90                   	nop
  802f4d:	c9                   	leave  
  802f4e:	c3                   	ret    

00802f4f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802f4f:	55                   	push   %ebp
  802f50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	6a 00                	push   $0x0
  802f57:	6a 00                	push   $0x0
  802f59:	6a 00                	push   $0x0
  802f5b:	ff 75 0c             	pushl  0xc(%ebp)
  802f5e:	50                   	push   %eax
  802f5f:	6a 17                	push   $0x17
  802f61:	e8 9c fd ff ff       	call   802d02 <syscall>
  802f66:	83 c4 18             	add    $0x18,%esp
}
  802f69:	c9                   	leave  
  802f6a:	c3                   	ret    

00802f6b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802f6b:	55                   	push   %ebp
  802f6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	6a 00                	push   $0x0
  802f76:	6a 00                	push   $0x0
  802f78:	6a 00                	push   $0x0
  802f7a:	52                   	push   %edx
  802f7b:	50                   	push   %eax
  802f7c:	6a 1a                	push   $0x1a
  802f7e:	e8 7f fd ff ff       	call   802d02 <syscall>
  802f83:	83 c4 18             	add    $0x18,%esp
}
  802f86:	c9                   	leave  
  802f87:	c3                   	ret    

00802f88 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802f88:	55                   	push   %ebp
  802f89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802f8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f91:	6a 00                	push   $0x0
  802f93:	6a 00                	push   $0x0
  802f95:	6a 00                	push   $0x0
  802f97:	52                   	push   %edx
  802f98:	50                   	push   %eax
  802f99:	6a 18                	push   $0x18
  802f9b:	e8 62 fd ff ff       	call   802d02 <syscall>
  802fa0:	83 c4 18             	add    $0x18,%esp
}
  802fa3:	90                   	nop
  802fa4:	c9                   	leave  
  802fa5:	c3                   	ret    

00802fa6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802fa6:	55                   	push   %ebp
  802fa7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	6a 00                	push   $0x0
  802fb1:	6a 00                	push   $0x0
  802fb3:	6a 00                	push   $0x0
  802fb5:	52                   	push   %edx
  802fb6:	50                   	push   %eax
  802fb7:	6a 19                	push   $0x19
  802fb9:	e8 44 fd ff ff       	call   802d02 <syscall>
  802fbe:	83 c4 18             	add    $0x18,%esp
}
  802fc1:	90                   	nop
  802fc2:	c9                   	leave  
  802fc3:	c3                   	ret    

00802fc4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802fc4:	55                   	push   %ebp
  802fc5:	89 e5                	mov    %esp,%ebp
  802fc7:	83 ec 04             	sub    $0x4,%esp
  802fca:	8b 45 10             	mov    0x10(%ebp),%eax
  802fcd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802fd0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802fd3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	6a 00                	push   $0x0
  802fdc:	51                   	push   %ecx
  802fdd:	52                   	push   %edx
  802fde:	ff 75 0c             	pushl  0xc(%ebp)
  802fe1:	50                   	push   %eax
  802fe2:	6a 1b                	push   $0x1b
  802fe4:	e8 19 fd ff ff       	call   802d02 <syscall>
  802fe9:	83 c4 18             	add    $0x18,%esp
}
  802fec:	c9                   	leave  
  802fed:	c3                   	ret    

00802fee <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802fee:	55                   	push   %ebp
  802fef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802ff1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff7:	6a 00                	push   $0x0
  802ff9:	6a 00                	push   $0x0
  802ffb:	6a 00                	push   $0x0
  802ffd:	52                   	push   %edx
  802ffe:	50                   	push   %eax
  802fff:	6a 1c                	push   $0x1c
  803001:	e8 fc fc ff ff       	call   802d02 <syscall>
  803006:	83 c4 18             	add    $0x18,%esp
}
  803009:	c9                   	leave  
  80300a:	c3                   	ret    

0080300b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80300b:	55                   	push   %ebp
  80300c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80300e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803011:	8b 55 0c             	mov    0xc(%ebp),%edx
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	6a 00                	push   $0x0
  803019:	6a 00                	push   $0x0
  80301b:	51                   	push   %ecx
  80301c:	52                   	push   %edx
  80301d:	50                   	push   %eax
  80301e:	6a 1d                	push   $0x1d
  803020:	e8 dd fc ff ff       	call   802d02 <syscall>
  803025:	83 c4 18             	add    $0x18,%esp
}
  803028:	c9                   	leave  
  803029:	c3                   	ret    

0080302a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80302a:	55                   	push   %ebp
  80302b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80302d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	6a 00                	push   $0x0
  803035:	6a 00                	push   $0x0
  803037:	6a 00                	push   $0x0
  803039:	52                   	push   %edx
  80303a:	50                   	push   %eax
  80303b:	6a 1e                	push   $0x1e
  80303d:	e8 c0 fc ff ff       	call   802d02 <syscall>
  803042:	83 c4 18             	add    $0x18,%esp
}
  803045:	c9                   	leave  
  803046:	c3                   	ret    

00803047 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  803047:	55                   	push   %ebp
  803048:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80304a:	6a 00                	push   $0x0
  80304c:	6a 00                	push   $0x0
  80304e:	6a 00                	push   $0x0
  803050:	6a 00                	push   $0x0
  803052:	6a 00                	push   $0x0
  803054:	6a 1f                	push   $0x1f
  803056:	e8 a7 fc ff ff       	call   802d02 <syscall>
  80305b:	83 c4 18             	add    $0x18,%esp
}
  80305e:	c9                   	leave  
  80305f:	c3                   	ret    

00803060 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803060:	55                   	push   %ebp
  803061:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803063:	8b 45 08             	mov    0x8(%ebp),%eax
  803066:	6a 00                	push   $0x0
  803068:	ff 75 14             	pushl  0x14(%ebp)
  80306b:	ff 75 10             	pushl  0x10(%ebp)
  80306e:	ff 75 0c             	pushl  0xc(%ebp)
  803071:	50                   	push   %eax
  803072:	6a 20                	push   $0x20
  803074:	e8 89 fc ff ff       	call   802d02 <syscall>
  803079:	83 c4 18             	add    $0x18,%esp
}
  80307c:	c9                   	leave  
  80307d:	c3                   	ret    

0080307e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80307e:	55                   	push   %ebp
  80307f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	6a 00                	push   $0x0
  803086:	6a 00                	push   $0x0
  803088:	6a 00                	push   $0x0
  80308a:	6a 00                	push   $0x0
  80308c:	50                   	push   %eax
  80308d:	6a 21                	push   $0x21
  80308f:	e8 6e fc ff ff       	call   802d02 <syscall>
  803094:	83 c4 18             	add    $0x18,%esp
}
  803097:	90                   	nop
  803098:	c9                   	leave  
  803099:	c3                   	ret    

0080309a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80309a:	55                   	push   %ebp
  80309b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	6a 00                	push   $0x0
  8030a2:	6a 00                	push   $0x0
  8030a4:	6a 00                	push   $0x0
  8030a6:	6a 00                	push   $0x0
  8030a8:	50                   	push   %eax
  8030a9:	6a 22                	push   $0x22
  8030ab:	e8 52 fc ff ff       	call   802d02 <syscall>
  8030b0:	83 c4 18             	add    $0x18,%esp
}
  8030b3:	c9                   	leave  
  8030b4:	c3                   	ret    

008030b5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8030b5:	55                   	push   %ebp
  8030b6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8030b8:	6a 00                	push   $0x0
  8030ba:	6a 00                	push   $0x0
  8030bc:	6a 00                	push   $0x0
  8030be:	6a 00                	push   $0x0
  8030c0:	6a 00                	push   $0x0
  8030c2:	6a 02                	push   $0x2
  8030c4:	e8 39 fc ff ff       	call   802d02 <syscall>
  8030c9:	83 c4 18             	add    $0x18,%esp
}
  8030cc:	c9                   	leave  
  8030cd:	c3                   	ret    

008030ce <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8030ce:	55                   	push   %ebp
  8030cf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8030d1:	6a 00                	push   $0x0
  8030d3:	6a 00                	push   $0x0
  8030d5:	6a 00                	push   $0x0
  8030d7:	6a 00                	push   $0x0
  8030d9:	6a 00                	push   $0x0
  8030db:	6a 03                	push   $0x3
  8030dd:	e8 20 fc ff ff       	call   802d02 <syscall>
  8030e2:	83 c4 18             	add    $0x18,%esp
}
  8030e5:	c9                   	leave  
  8030e6:	c3                   	ret    

008030e7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8030e7:	55                   	push   %ebp
  8030e8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8030ea:	6a 00                	push   $0x0
  8030ec:	6a 00                	push   $0x0
  8030ee:	6a 00                	push   $0x0
  8030f0:	6a 00                	push   $0x0
  8030f2:	6a 00                	push   $0x0
  8030f4:	6a 04                	push   $0x4
  8030f6:	e8 07 fc ff ff       	call   802d02 <syscall>
  8030fb:	83 c4 18             	add    $0x18,%esp
}
  8030fe:	c9                   	leave  
  8030ff:	c3                   	ret    

00803100 <sys_exit_env>:


void sys_exit_env(void)
{
  803100:	55                   	push   %ebp
  803101:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803103:	6a 00                	push   $0x0
  803105:	6a 00                	push   $0x0
  803107:	6a 00                	push   $0x0
  803109:	6a 00                	push   $0x0
  80310b:	6a 00                	push   $0x0
  80310d:	6a 23                	push   $0x23
  80310f:	e8 ee fb ff ff       	call   802d02 <syscall>
  803114:	83 c4 18             	add    $0x18,%esp
}
  803117:	90                   	nop
  803118:	c9                   	leave  
  803119:	c3                   	ret    

0080311a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80311a:	55                   	push   %ebp
  80311b:	89 e5                	mov    %esp,%ebp
  80311d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  803120:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803123:	8d 50 04             	lea    0x4(%eax),%edx
  803126:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803129:	6a 00                	push   $0x0
  80312b:	6a 00                	push   $0x0
  80312d:	6a 00                	push   $0x0
  80312f:	52                   	push   %edx
  803130:	50                   	push   %eax
  803131:	6a 24                	push   $0x24
  803133:	e8 ca fb ff ff       	call   802d02 <syscall>
  803138:	83 c4 18             	add    $0x18,%esp
	return result;
  80313b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80313e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803141:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803144:	89 01                	mov    %eax,(%ecx)
  803146:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	c9                   	leave  
  80314d:	c2 04 00             	ret    $0x4

00803150 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803150:	55                   	push   %ebp
  803151:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803153:	6a 00                	push   $0x0
  803155:	6a 00                	push   $0x0
  803157:	ff 75 10             	pushl  0x10(%ebp)
  80315a:	ff 75 0c             	pushl  0xc(%ebp)
  80315d:	ff 75 08             	pushl  0x8(%ebp)
  803160:	6a 12                	push   $0x12
  803162:	e8 9b fb ff ff       	call   802d02 <syscall>
  803167:	83 c4 18             	add    $0x18,%esp
	return ;
  80316a:	90                   	nop
}
  80316b:	c9                   	leave  
  80316c:	c3                   	ret    

0080316d <sys_rcr2>:
uint32 sys_rcr2()
{
  80316d:	55                   	push   %ebp
  80316e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803170:	6a 00                	push   $0x0
  803172:	6a 00                	push   $0x0
  803174:	6a 00                	push   $0x0
  803176:	6a 00                	push   $0x0
  803178:	6a 00                	push   $0x0
  80317a:	6a 25                	push   $0x25
  80317c:	e8 81 fb ff ff       	call   802d02 <syscall>
  803181:	83 c4 18             	add    $0x18,%esp
}
  803184:	c9                   	leave  
  803185:	c3                   	ret    

00803186 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  803186:	55                   	push   %ebp
  803187:	89 e5                	mov    %esp,%ebp
  803189:	83 ec 04             	sub    $0x4,%esp
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803192:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803196:	6a 00                	push   $0x0
  803198:	6a 00                	push   $0x0
  80319a:	6a 00                	push   $0x0
  80319c:	6a 00                	push   $0x0
  80319e:	50                   	push   %eax
  80319f:	6a 26                	push   $0x26
  8031a1:	e8 5c fb ff ff       	call   802d02 <syscall>
  8031a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8031a9:	90                   	nop
}
  8031aa:	c9                   	leave  
  8031ab:	c3                   	ret    

008031ac <rsttst>:
void rsttst()
{
  8031ac:	55                   	push   %ebp
  8031ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8031af:	6a 00                	push   $0x0
  8031b1:	6a 00                	push   $0x0
  8031b3:	6a 00                	push   $0x0
  8031b5:	6a 00                	push   $0x0
  8031b7:	6a 00                	push   $0x0
  8031b9:	6a 28                	push   $0x28
  8031bb:	e8 42 fb ff ff       	call   802d02 <syscall>
  8031c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8031c3:	90                   	nop
}
  8031c4:	c9                   	leave  
  8031c5:	c3                   	ret    

008031c6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8031c6:	55                   	push   %ebp
  8031c7:	89 e5                	mov    %esp,%ebp
  8031c9:	83 ec 04             	sub    $0x4,%esp
  8031cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8031cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8031d2:	8b 55 18             	mov    0x18(%ebp),%edx
  8031d5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8031d9:	52                   	push   %edx
  8031da:	50                   	push   %eax
  8031db:	ff 75 10             	pushl  0x10(%ebp)
  8031de:	ff 75 0c             	pushl  0xc(%ebp)
  8031e1:	ff 75 08             	pushl  0x8(%ebp)
  8031e4:	6a 27                	push   $0x27
  8031e6:	e8 17 fb ff ff       	call   802d02 <syscall>
  8031eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8031ee:	90                   	nop
}
  8031ef:	c9                   	leave  
  8031f0:	c3                   	ret    

008031f1 <chktst>:
void chktst(uint32 n)
{
  8031f1:	55                   	push   %ebp
  8031f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8031f4:	6a 00                	push   $0x0
  8031f6:	6a 00                	push   $0x0
  8031f8:	6a 00                	push   $0x0
  8031fa:	6a 00                	push   $0x0
  8031fc:	ff 75 08             	pushl  0x8(%ebp)
  8031ff:	6a 29                	push   $0x29
  803201:	e8 fc fa ff ff       	call   802d02 <syscall>
  803206:	83 c4 18             	add    $0x18,%esp
	return ;
  803209:	90                   	nop
}
  80320a:	c9                   	leave  
  80320b:	c3                   	ret    

0080320c <inctst>:

void inctst()
{
  80320c:	55                   	push   %ebp
  80320d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80320f:	6a 00                	push   $0x0
  803211:	6a 00                	push   $0x0
  803213:	6a 00                	push   $0x0
  803215:	6a 00                	push   $0x0
  803217:	6a 00                	push   $0x0
  803219:	6a 2a                	push   $0x2a
  80321b:	e8 e2 fa ff ff       	call   802d02 <syscall>
  803220:	83 c4 18             	add    $0x18,%esp
	return ;
  803223:	90                   	nop
}
  803224:	c9                   	leave  
  803225:	c3                   	ret    

00803226 <gettst>:
uint32 gettst()
{
  803226:	55                   	push   %ebp
  803227:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803229:	6a 00                	push   $0x0
  80322b:	6a 00                	push   $0x0
  80322d:	6a 00                	push   $0x0
  80322f:	6a 00                	push   $0x0
  803231:	6a 00                	push   $0x0
  803233:	6a 2b                	push   $0x2b
  803235:	e8 c8 fa ff ff       	call   802d02 <syscall>
  80323a:	83 c4 18             	add    $0x18,%esp
}
  80323d:	c9                   	leave  
  80323e:	c3                   	ret    

0080323f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80323f:	55                   	push   %ebp
  803240:	89 e5                	mov    %esp,%ebp
  803242:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803245:	6a 00                	push   $0x0
  803247:	6a 00                	push   $0x0
  803249:	6a 00                	push   $0x0
  80324b:	6a 00                	push   $0x0
  80324d:	6a 00                	push   $0x0
  80324f:	6a 2c                	push   $0x2c
  803251:	e8 ac fa ff ff       	call   802d02 <syscall>
  803256:	83 c4 18             	add    $0x18,%esp
  803259:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80325c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  803260:	75 07                	jne    803269 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  803262:	b8 01 00 00 00       	mov    $0x1,%eax
  803267:	eb 05                	jmp    80326e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  803269:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80326e:	c9                   	leave  
  80326f:	c3                   	ret    

00803270 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  803270:	55                   	push   %ebp
  803271:	89 e5                	mov    %esp,%ebp
  803273:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803276:	6a 00                	push   $0x0
  803278:	6a 00                	push   $0x0
  80327a:	6a 00                	push   $0x0
  80327c:	6a 00                	push   $0x0
  80327e:	6a 00                	push   $0x0
  803280:	6a 2c                	push   $0x2c
  803282:	e8 7b fa ff ff       	call   802d02 <syscall>
  803287:	83 c4 18             	add    $0x18,%esp
  80328a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80328d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  803291:	75 07                	jne    80329a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  803293:	b8 01 00 00 00       	mov    $0x1,%eax
  803298:	eb 05                	jmp    80329f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80329a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80329f:	c9                   	leave  
  8032a0:	c3                   	ret    

008032a1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8032a1:	55                   	push   %ebp
  8032a2:	89 e5                	mov    %esp,%ebp
  8032a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032a7:	6a 00                	push   $0x0
  8032a9:	6a 00                	push   $0x0
  8032ab:	6a 00                	push   $0x0
  8032ad:	6a 00                	push   $0x0
  8032af:	6a 00                	push   $0x0
  8032b1:	6a 2c                	push   $0x2c
  8032b3:	e8 4a fa ff ff       	call   802d02 <syscall>
  8032b8:	83 c4 18             	add    $0x18,%esp
  8032bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8032be:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8032c2:	75 07                	jne    8032cb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8032c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c9:	eb 05                	jmp    8032d0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8032cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032d0:	c9                   	leave  
  8032d1:	c3                   	ret    

008032d2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8032d2:	55                   	push   %ebp
  8032d3:	89 e5                	mov    %esp,%ebp
  8032d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8032d8:	6a 00                	push   $0x0
  8032da:	6a 00                	push   $0x0
  8032dc:	6a 00                	push   $0x0
  8032de:	6a 00                	push   $0x0
  8032e0:	6a 00                	push   $0x0
  8032e2:	6a 2c                	push   $0x2c
  8032e4:	e8 19 fa ff ff       	call   802d02 <syscall>
  8032e9:	83 c4 18             	add    $0x18,%esp
  8032ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8032ef:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8032f3:	75 07                	jne    8032fc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8032f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8032fa:	eb 05                	jmp    803301 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8032fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803301:	c9                   	leave  
  803302:	c3                   	ret    

00803303 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803303:	55                   	push   %ebp
  803304:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803306:	6a 00                	push   $0x0
  803308:	6a 00                	push   $0x0
  80330a:	6a 00                	push   $0x0
  80330c:	6a 00                	push   $0x0
  80330e:	ff 75 08             	pushl  0x8(%ebp)
  803311:	6a 2d                	push   $0x2d
  803313:	e8 ea f9 ff ff       	call   802d02 <syscall>
  803318:	83 c4 18             	add    $0x18,%esp
	return ;
  80331b:	90                   	nop
}
  80331c:	c9                   	leave  
  80331d:	c3                   	ret    

0080331e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80331e:	55                   	push   %ebp
  80331f:	89 e5                	mov    %esp,%ebp
  803321:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803322:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803325:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803328:	8b 55 0c             	mov    0xc(%ebp),%edx
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	6a 00                	push   $0x0
  803330:	53                   	push   %ebx
  803331:	51                   	push   %ecx
  803332:	52                   	push   %edx
  803333:	50                   	push   %eax
  803334:	6a 2e                	push   $0x2e
  803336:	e8 c7 f9 ff ff       	call   802d02 <syscall>
  80333b:	83 c4 18             	add    $0x18,%esp
}
  80333e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803341:	c9                   	leave  
  803342:	c3                   	ret    

00803343 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803343:	55                   	push   %ebp
  803344:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803346:	8b 55 0c             	mov    0xc(%ebp),%edx
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	6a 00                	push   $0x0
  80334e:	6a 00                	push   $0x0
  803350:	6a 00                	push   $0x0
  803352:	52                   	push   %edx
  803353:	50                   	push   %eax
  803354:	6a 2f                	push   $0x2f
  803356:	e8 a7 f9 ff ff       	call   802d02 <syscall>
  80335b:	83 c4 18             	add    $0x18,%esp
}
  80335e:	c9                   	leave  
  80335f:	c3                   	ret    

00803360 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  803360:	55                   	push   %ebp
  803361:	89 e5                	mov    %esp,%ebp
  803363:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  803366:	83 ec 0c             	sub    $0xc,%esp
  803369:	68 30 55 80 00       	push   $0x805530
  80336e:	e8 6b e8 ff ff       	call   801bde <cprintf>
  803373:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  803376:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80337d:	83 ec 0c             	sub    $0xc,%esp
  803380:	68 5c 55 80 00       	push   $0x80555c
  803385:	e8 54 e8 ff ff       	call   801bde <cprintf>
  80338a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80338d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803391:	a1 38 61 80 00       	mov    0x806138,%eax
  803396:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803399:	eb 56                	jmp    8033f1 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80339b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80339f:	74 1c                	je     8033bd <print_mem_block_lists+0x5d>
  8033a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a4:	8b 50 08             	mov    0x8(%eax),%edx
  8033a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033aa:	8b 48 08             	mov    0x8(%eax),%ecx
  8033ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b3:	01 c8                	add    %ecx,%eax
  8033b5:	39 c2                	cmp    %eax,%edx
  8033b7:	73 04                	jae    8033bd <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8033b9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8033bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c0:	8b 50 08             	mov    0x8(%eax),%edx
  8033c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c9:	01 c2                	add    %eax,%edx
  8033cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ce:	8b 40 08             	mov    0x8(%eax),%eax
  8033d1:	83 ec 04             	sub    $0x4,%esp
  8033d4:	52                   	push   %edx
  8033d5:	50                   	push   %eax
  8033d6:	68 71 55 80 00       	push   $0x805571
  8033db:	e8 fe e7 ff ff       	call   801bde <cprintf>
  8033e0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8033e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8033e9:	a1 40 61 80 00       	mov    0x806140,%eax
  8033ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f5:	74 07                	je     8033fe <print_mem_block_lists+0x9e>
  8033f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fa:	8b 00                	mov    (%eax),%eax
  8033fc:	eb 05                	jmp    803403 <print_mem_block_lists+0xa3>
  8033fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803403:	a3 40 61 80 00       	mov    %eax,0x806140
  803408:	a1 40 61 80 00       	mov    0x806140,%eax
  80340d:	85 c0                	test   %eax,%eax
  80340f:	75 8a                	jne    80339b <print_mem_block_lists+0x3b>
  803411:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803415:	75 84                	jne    80339b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  803417:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80341b:	75 10                	jne    80342d <print_mem_block_lists+0xcd>
  80341d:	83 ec 0c             	sub    $0xc,%esp
  803420:	68 80 55 80 00       	push   $0x805580
  803425:	e8 b4 e7 ff ff       	call   801bde <cprintf>
  80342a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80342d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  803434:	83 ec 0c             	sub    $0xc,%esp
  803437:	68 a4 55 80 00       	push   $0x8055a4
  80343c:	e8 9d e7 ff ff       	call   801bde <cprintf>
  803441:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  803444:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803448:	a1 40 60 80 00       	mov    0x806040,%eax
  80344d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803450:	eb 56                	jmp    8034a8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803452:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803456:	74 1c                	je     803474 <print_mem_block_lists+0x114>
  803458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345b:	8b 50 08             	mov    0x8(%eax),%edx
  80345e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803461:	8b 48 08             	mov    0x8(%eax),%ecx
  803464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803467:	8b 40 0c             	mov    0xc(%eax),%eax
  80346a:	01 c8                	add    %ecx,%eax
  80346c:	39 c2                	cmp    %eax,%edx
  80346e:	73 04                	jae    803474 <print_mem_block_lists+0x114>
			sorted = 0 ;
  803470:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803477:	8b 50 08             	mov    0x8(%eax),%edx
  80347a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347d:	8b 40 0c             	mov    0xc(%eax),%eax
  803480:	01 c2                	add    %eax,%edx
  803482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803485:	8b 40 08             	mov    0x8(%eax),%eax
  803488:	83 ec 04             	sub    $0x4,%esp
  80348b:	52                   	push   %edx
  80348c:	50                   	push   %eax
  80348d:	68 71 55 80 00       	push   $0x805571
  803492:	e8 47 e7 ff ff       	call   801bde <cprintf>
  803497:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80349a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8034a0:	a1 48 60 80 00       	mov    0x806048,%eax
  8034a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ac:	74 07                	je     8034b5 <print_mem_block_lists+0x155>
  8034ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b1:	8b 00                	mov    (%eax),%eax
  8034b3:	eb 05                	jmp    8034ba <print_mem_block_lists+0x15a>
  8034b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ba:	a3 48 60 80 00       	mov    %eax,0x806048
  8034bf:	a1 48 60 80 00       	mov    0x806048,%eax
  8034c4:	85 c0                	test   %eax,%eax
  8034c6:	75 8a                	jne    803452 <print_mem_block_lists+0xf2>
  8034c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034cc:	75 84                	jne    803452 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8034ce:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8034d2:	75 10                	jne    8034e4 <print_mem_block_lists+0x184>
  8034d4:	83 ec 0c             	sub    $0xc,%esp
  8034d7:	68 bc 55 80 00       	push   $0x8055bc
  8034dc:	e8 fd e6 ff ff       	call   801bde <cprintf>
  8034e1:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8034e4:	83 ec 0c             	sub    $0xc,%esp
  8034e7:	68 30 55 80 00       	push   $0x805530
  8034ec:	e8 ed e6 ff ff       	call   801bde <cprintf>
  8034f1:	83 c4 10             	add    $0x10,%esp

}
  8034f4:	90                   	nop
  8034f5:	c9                   	leave  
  8034f6:	c3                   	ret    

008034f7 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8034f7:	55                   	push   %ebp
  8034f8:	89 e5                	mov    %esp,%ebp
  8034fa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8034fd:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  803504:	00 00 00 
  803507:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  80350e:	00 00 00 
  803511:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  803518:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80351b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803522:	e9 9e 00 00 00       	jmp    8035c5 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  803527:	a1 50 60 80 00       	mov    0x806050,%eax
  80352c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80352f:	c1 e2 04             	shl    $0x4,%edx
  803532:	01 d0                	add    %edx,%eax
  803534:	85 c0                	test   %eax,%eax
  803536:	75 14                	jne    80354c <initialize_MemBlocksList+0x55>
  803538:	83 ec 04             	sub    $0x4,%esp
  80353b:	68 e4 55 80 00       	push   $0x8055e4
  803540:	6a 46                	push   $0x46
  803542:	68 07 56 80 00       	push   $0x805607
  803547:	e8 de e3 ff ff       	call   80192a <_panic>
  80354c:	a1 50 60 80 00       	mov    0x806050,%eax
  803551:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803554:	c1 e2 04             	shl    $0x4,%edx
  803557:	01 d0                	add    %edx,%eax
  803559:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80355f:	89 10                	mov    %edx,(%eax)
  803561:	8b 00                	mov    (%eax),%eax
  803563:	85 c0                	test   %eax,%eax
  803565:	74 18                	je     80357f <initialize_MemBlocksList+0x88>
  803567:	a1 48 61 80 00       	mov    0x806148,%eax
  80356c:	8b 15 50 60 80 00    	mov    0x806050,%edx
  803572:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803575:	c1 e1 04             	shl    $0x4,%ecx
  803578:	01 ca                	add    %ecx,%edx
  80357a:	89 50 04             	mov    %edx,0x4(%eax)
  80357d:	eb 12                	jmp    803591 <initialize_MemBlocksList+0x9a>
  80357f:	a1 50 60 80 00       	mov    0x806050,%eax
  803584:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803587:	c1 e2 04             	shl    $0x4,%edx
  80358a:	01 d0                	add    %edx,%eax
  80358c:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803591:	a1 50 60 80 00       	mov    0x806050,%eax
  803596:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803599:	c1 e2 04             	shl    $0x4,%edx
  80359c:	01 d0                	add    %edx,%eax
  80359e:	a3 48 61 80 00       	mov    %eax,0x806148
  8035a3:	a1 50 60 80 00       	mov    0x806050,%eax
  8035a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ab:	c1 e2 04             	shl    $0x4,%edx
  8035ae:	01 d0                	add    %edx,%eax
  8035b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b7:	a1 54 61 80 00       	mov    0x806154,%eax
  8035bc:	40                   	inc    %eax
  8035bd:	a3 54 61 80 00       	mov    %eax,0x806154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8035c2:	ff 45 f4             	incl   -0xc(%ebp)
  8035c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035cb:	0f 82 56 ff ff ff    	jb     803527 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8035d1:	90                   	nop
  8035d2:	c9                   	leave  
  8035d3:	c3                   	ret    

008035d4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8035d4:	55                   	push   %ebp
  8035d5:	89 e5                	mov    %esp,%ebp
  8035d7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8035da:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dd:	8b 00                	mov    (%eax),%eax
  8035df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8035e2:	eb 19                	jmp    8035fd <find_block+0x29>
	{
		if(va==point->sva)
  8035e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8035e7:	8b 40 08             	mov    0x8(%eax),%eax
  8035ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8035ed:	75 05                	jne    8035f4 <find_block+0x20>
		   return point;
  8035ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8035f2:	eb 36                	jmp    80362a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8035f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f7:	8b 40 08             	mov    0x8(%eax),%eax
  8035fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8035fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803601:	74 07                	je     80360a <find_block+0x36>
  803603:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803606:	8b 00                	mov    (%eax),%eax
  803608:	eb 05                	jmp    80360f <find_block+0x3b>
  80360a:	b8 00 00 00 00       	mov    $0x0,%eax
  80360f:	8b 55 08             	mov    0x8(%ebp),%edx
  803612:	89 42 08             	mov    %eax,0x8(%edx)
  803615:	8b 45 08             	mov    0x8(%ebp),%eax
  803618:	8b 40 08             	mov    0x8(%eax),%eax
  80361b:	85 c0                	test   %eax,%eax
  80361d:	75 c5                	jne    8035e4 <find_block+0x10>
  80361f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803623:	75 bf                	jne    8035e4 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  803625:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80362a:	c9                   	leave  
  80362b:	c3                   	ret    

0080362c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80362c:	55                   	push   %ebp
  80362d:	89 e5                	mov    %esp,%ebp
  80362f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  803632:	a1 40 60 80 00       	mov    0x806040,%eax
  803637:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80363a:	a1 44 60 80 00       	mov    0x806044,%eax
  80363f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  803642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803645:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803648:	74 24                	je     80366e <insert_sorted_allocList+0x42>
  80364a:	8b 45 08             	mov    0x8(%ebp),%eax
  80364d:	8b 50 08             	mov    0x8(%eax),%edx
  803650:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803653:	8b 40 08             	mov    0x8(%eax),%eax
  803656:	39 c2                	cmp    %eax,%edx
  803658:	76 14                	jbe    80366e <insert_sorted_allocList+0x42>
  80365a:	8b 45 08             	mov    0x8(%ebp),%eax
  80365d:	8b 50 08             	mov    0x8(%eax),%edx
  803660:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803663:	8b 40 08             	mov    0x8(%eax),%eax
  803666:	39 c2                	cmp    %eax,%edx
  803668:	0f 82 60 01 00 00    	jb     8037ce <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80366e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803672:	75 65                	jne    8036d9 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  803674:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803678:	75 14                	jne    80368e <insert_sorted_allocList+0x62>
  80367a:	83 ec 04             	sub    $0x4,%esp
  80367d:	68 e4 55 80 00       	push   $0x8055e4
  803682:	6a 6b                	push   $0x6b
  803684:	68 07 56 80 00       	push   $0x805607
  803689:	e8 9c e2 ff ff       	call   80192a <_panic>
  80368e:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803694:	8b 45 08             	mov    0x8(%ebp),%eax
  803697:	89 10                	mov    %edx,(%eax)
  803699:	8b 45 08             	mov    0x8(%ebp),%eax
  80369c:	8b 00                	mov    (%eax),%eax
  80369e:	85 c0                	test   %eax,%eax
  8036a0:	74 0d                	je     8036af <insert_sorted_allocList+0x83>
  8036a2:	a1 40 60 80 00       	mov    0x806040,%eax
  8036a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8036aa:	89 50 04             	mov    %edx,0x4(%eax)
  8036ad:	eb 08                	jmp    8036b7 <insert_sorted_allocList+0x8b>
  8036af:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b2:	a3 44 60 80 00       	mov    %eax,0x806044
  8036b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ba:	a3 40 60 80 00       	mov    %eax,0x806040
  8036bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c9:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8036ce:	40                   	inc    %eax
  8036cf:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8036d4:	e9 dc 01 00 00       	jmp    8038b5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8036d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dc:	8b 50 08             	mov    0x8(%eax),%edx
  8036df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e2:	8b 40 08             	mov    0x8(%eax),%eax
  8036e5:	39 c2                	cmp    %eax,%edx
  8036e7:	77 6c                	ja     803755 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8036e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036ed:	74 06                	je     8036f5 <insert_sorted_allocList+0xc9>
  8036ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f3:	75 14                	jne    803709 <insert_sorted_allocList+0xdd>
  8036f5:	83 ec 04             	sub    $0x4,%esp
  8036f8:	68 20 56 80 00       	push   $0x805620
  8036fd:	6a 6f                	push   $0x6f
  8036ff:	68 07 56 80 00       	push   $0x805607
  803704:	e8 21 e2 ff ff       	call   80192a <_panic>
  803709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80370c:	8b 50 04             	mov    0x4(%eax),%edx
  80370f:	8b 45 08             	mov    0x8(%ebp),%eax
  803712:	89 50 04             	mov    %edx,0x4(%eax)
  803715:	8b 45 08             	mov    0x8(%ebp),%eax
  803718:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80371b:	89 10                	mov    %edx,(%eax)
  80371d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803720:	8b 40 04             	mov    0x4(%eax),%eax
  803723:	85 c0                	test   %eax,%eax
  803725:	74 0d                	je     803734 <insert_sorted_allocList+0x108>
  803727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372a:	8b 40 04             	mov    0x4(%eax),%eax
  80372d:	8b 55 08             	mov    0x8(%ebp),%edx
  803730:	89 10                	mov    %edx,(%eax)
  803732:	eb 08                	jmp    80373c <insert_sorted_allocList+0x110>
  803734:	8b 45 08             	mov    0x8(%ebp),%eax
  803737:	a3 40 60 80 00       	mov    %eax,0x806040
  80373c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373f:	8b 55 08             	mov    0x8(%ebp),%edx
  803742:	89 50 04             	mov    %edx,0x4(%eax)
  803745:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80374a:	40                   	inc    %eax
  80374b:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803750:	e9 60 01 00 00       	jmp    8038b5 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  803755:	8b 45 08             	mov    0x8(%ebp),%eax
  803758:	8b 50 08             	mov    0x8(%eax),%edx
  80375b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80375e:	8b 40 08             	mov    0x8(%eax),%eax
  803761:	39 c2                	cmp    %eax,%edx
  803763:	0f 82 4c 01 00 00    	jb     8038b5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  803769:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80376d:	75 14                	jne    803783 <insert_sorted_allocList+0x157>
  80376f:	83 ec 04             	sub    $0x4,%esp
  803772:	68 58 56 80 00       	push   $0x805658
  803777:	6a 73                	push   $0x73
  803779:	68 07 56 80 00       	push   $0x805607
  80377e:	e8 a7 e1 ff ff       	call   80192a <_panic>
  803783:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803789:	8b 45 08             	mov    0x8(%ebp),%eax
  80378c:	89 50 04             	mov    %edx,0x4(%eax)
  80378f:	8b 45 08             	mov    0x8(%ebp),%eax
  803792:	8b 40 04             	mov    0x4(%eax),%eax
  803795:	85 c0                	test   %eax,%eax
  803797:	74 0c                	je     8037a5 <insert_sorted_allocList+0x179>
  803799:	a1 44 60 80 00       	mov    0x806044,%eax
  80379e:	8b 55 08             	mov    0x8(%ebp),%edx
  8037a1:	89 10                	mov    %edx,(%eax)
  8037a3:	eb 08                	jmp    8037ad <insert_sorted_allocList+0x181>
  8037a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a8:	a3 40 60 80 00       	mov    %eax,0x806040
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	a3 44 60 80 00       	mov    %eax,0x806044
  8037b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037be:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8037c3:	40                   	inc    %eax
  8037c4:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8037c9:	e9 e7 00 00 00       	jmp    8038b5 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8037ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8037d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8037db:	a1 40 60 80 00       	mov    0x806040,%eax
  8037e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037e3:	e9 9d 00 00 00       	jmp    803885 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8037e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037eb:	8b 00                	mov    (%eax),%eax
  8037ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8037f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f3:	8b 50 08             	mov    0x8(%eax),%edx
  8037f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f9:	8b 40 08             	mov    0x8(%eax),%eax
  8037fc:	39 c2                	cmp    %eax,%edx
  8037fe:	76 7d                	jbe    80387d <insert_sorted_allocList+0x251>
  803800:	8b 45 08             	mov    0x8(%ebp),%eax
  803803:	8b 50 08             	mov    0x8(%eax),%edx
  803806:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803809:	8b 40 08             	mov    0x8(%eax),%eax
  80380c:	39 c2                	cmp    %eax,%edx
  80380e:	73 6d                	jae    80387d <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  803810:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803814:	74 06                	je     80381c <insert_sorted_allocList+0x1f0>
  803816:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80381a:	75 14                	jne    803830 <insert_sorted_allocList+0x204>
  80381c:	83 ec 04             	sub    $0x4,%esp
  80381f:	68 7c 56 80 00       	push   $0x80567c
  803824:	6a 7f                	push   $0x7f
  803826:	68 07 56 80 00       	push   $0x805607
  80382b:	e8 fa e0 ff ff       	call   80192a <_panic>
  803830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803833:	8b 10                	mov    (%eax),%edx
  803835:	8b 45 08             	mov    0x8(%ebp),%eax
  803838:	89 10                	mov    %edx,(%eax)
  80383a:	8b 45 08             	mov    0x8(%ebp),%eax
  80383d:	8b 00                	mov    (%eax),%eax
  80383f:	85 c0                	test   %eax,%eax
  803841:	74 0b                	je     80384e <insert_sorted_allocList+0x222>
  803843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803846:	8b 00                	mov    (%eax),%eax
  803848:	8b 55 08             	mov    0x8(%ebp),%edx
  80384b:	89 50 04             	mov    %edx,0x4(%eax)
  80384e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803851:	8b 55 08             	mov    0x8(%ebp),%edx
  803854:	89 10                	mov    %edx,(%eax)
  803856:	8b 45 08             	mov    0x8(%ebp),%eax
  803859:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80385c:	89 50 04             	mov    %edx,0x4(%eax)
  80385f:	8b 45 08             	mov    0x8(%ebp),%eax
  803862:	8b 00                	mov    (%eax),%eax
  803864:	85 c0                	test   %eax,%eax
  803866:	75 08                	jne    803870 <insert_sorted_allocList+0x244>
  803868:	8b 45 08             	mov    0x8(%ebp),%eax
  80386b:	a3 44 60 80 00       	mov    %eax,0x806044
  803870:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803875:	40                   	inc    %eax
  803876:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  80387b:	eb 39                	jmp    8038b6 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80387d:	a1 48 60 80 00       	mov    0x806048,%eax
  803882:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803885:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803889:	74 07                	je     803892 <insert_sorted_allocList+0x266>
  80388b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388e:	8b 00                	mov    (%eax),%eax
  803890:	eb 05                	jmp    803897 <insert_sorted_allocList+0x26b>
  803892:	b8 00 00 00 00       	mov    $0x0,%eax
  803897:	a3 48 60 80 00       	mov    %eax,0x806048
  80389c:	a1 48 60 80 00       	mov    0x806048,%eax
  8038a1:	85 c0                	test   %eax,%eax
  8038a3:	0f 85 3f ff ff ff    	jne    8037e8 <insert_sorted_allocList+0x1bc>
  8038a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038ad:	0f 85 35 ff ff ff    	jne    8037e8 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8038b3:	eb 01                	jmp    8038b6 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8038b5:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8038b6:	90                   	nop
  8038b7:	c9                   	leave  
  8038b8:	c3                   	ret    

008038b9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8038b9:	55                   	push   %ebp
  8038ba:	89 e5                	mov    %esp,%ebp
  8038bc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8038bf:	a1 38 61 80 00       	mov    0x806138,%eax
  8038c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038c7:	e9 85 01 00 00       	jmp    803a51 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8038cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8038d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038d5:	0f 82 6e 01 00 00    	jb     803a49 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8038db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038de:	8b 40 0c             	mov    0xc(%eax),%eax
  8038e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038e4:	0f 85 8a 00 00 00    	jne    803974 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8038ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038ee:	75 17                	jne    803907 <alloc_block_FF+0x4e>
  8038f0:	83 ec 04             	sub    $0x4,%esp
  8038f3:	68 b0 56 80 00       	push   $0x8056b0
  8038f8:	68 93 00 00 00       	push   $0x93
  8038fd:	68 07 56 80 00       	push   $0x805607
  803902:	e8 23 e0 ff ff       	call   80192a <_panic>
  803907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390a:	8b 00                	mov    (%eax),%eax
  80390c:	85 c0                	test   %eax,%eax
  80390e:	74 10                	je     803920 <alloc_block_FF+0x67>
  803910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803913:	8b 00                	mov    (%eax),%eax
  803915:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803918:	8b 52 04             	mov    0x4(%edx),%edx
  80391b:	89 50 04             	mov    %edx,0x4(%eax)
  80391e:	eb 0b                	jmp    80392b <alloc_block_FF+0x72>
  803920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803923:	8b 40 04             	mov    0x4(%eax),%eax
  803926:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80392b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392e:	8b 40 04             	mov    0x4(%eax),%eax
  803931:	85 c0                	test   %eax,%eax
  803933:	74 0f                	je     803944 <alloc_block_FF+0x8b>
  803935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803938:	8b 40 04             	mov    0x4(%eax),%eax
  80393b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80393e:	8b 12                	mov    (%edx),%edx
  803940:	89 10                	mov    %edx,(%eax)
  803942:	eb 0a                	jmp    80394e <alloc_block_FF+0x95>
  803944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803947:	8b 00                	mov    (%eax),%eax
  803949:	a3 38 61 80 00       	mov    %eax,0x806138
  80394e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803951:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803961:	a1 44 61 80 00       	mov    0x806144,%eax
  803966:	48                   	dec    %eax
  803967:	a3 44 61 80 00       	mov    %eax,0x806144
			   return  point;
  80396c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396f:	e9 10 01 00 00       	jmp    803a84 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  803974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803977:	8b 40 0c             	mov    0xc(%eax),%eax
  80397a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80397d:	0f 86 c6 00 00 00    	jbe    803a49 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803983:	a1 48 61 80 00       	mov    0x806148,%eax
  803988:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80398b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398e:	8b 50 08             	mov    0x8(%eax),%edx
  803991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803994:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  803997:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80399a:	8b 55 08             	mov    0x8(%ebp),%edx
  80399d:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8039a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039a4:	75 17                	jne    8039bd <alloc_block_FF+0x104>
  8039a6:	83 ec 04             	sub    $0x4,%esp
  8039a9:	68 b0 56 80 00       	push   $0x8056b0
  8039ae:	68 9b 00 00 00       	push   $0x9b
  8039b3:	68 07 56 80 00       	push   $0x805607
  8039b8:	e8 6d df ff ff       	call   80192a <_panic>
  8039bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c0:	8b 00                	mov    (%eax),%eax
  8039c2:	85 c0                	test   %eax,%eax
  8039c4:	74 10                	je     8039d6 <alloc_block_FF+0x11d>
  8039c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c9:	8b 00                	mov    (%eax),%eax
  8039cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039ce:	8b 52 04             	mov    0x4(%edx),%edx
  8039d1:	89 50 04             	mov    %edx,0x4(%eax)
  8039d4:	eb 0b                	jmp    8039e1 <alloc_block_FF+0x128>
  8039d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d9:	8b 40 04             	mov    0x4(%eax),%eax
  8039dc:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8039e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e4:	8b 40 04             	mov    0x4(%eax),%eax
  8039e7:	85 c0                	test   %eax,%eax
  8039e9:	74 0f                	je     8039fa <alloc_block_FF+0x141>
  8039eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ee:	8b 40 04             	mov    0x4(%eax),%eax
  8039f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039f4:	8b 12                	mov    (%edx),%edx
  8039f6:	89 10                	mov    %edx,(%eax)
  8039f8:	eb 0a                	jmp    803a04 <alloc_block_FF+0x14b>
  8039fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039fd:	8b 00                	mov    (%eax),%eax
  8039ff:	a3 48 61 80 00       	mov    %eax,0x806148
  803a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a17:	a1 54 61 80 00       	mov    0x806154,%eax
  803a1c:	48                   	dec    %eax
  803a1d:	a3 54 61 80 00       	mov    %eax,0x806154
			   point->sva += size;
  803a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a25:	8b 50 08             	mov    0x8(%eax),%edx
  803a28:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2b:	01 c2                	add    %eax,%edx
  803a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a30:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  803a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a36:	8b 40 0c             	mov    0xc(%eax),%eax
  803a39:	2b 45 08             	sub    0x8(%ebp),%eax
  803a3c:	89 c2                	mov    %eax,%edx
  803a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a41:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  803a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a47:	eb 3b                	jmp    803a84 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803a49:	a1 40 61 80 00       	mov    0x806140,%eax
  803a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a55:	74 07                	je     803a5e <alloc_block_FF+0x1a5>
  803a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5a:	8b 00                	mov    (%eax),%eax
  803a5c:	eb 05                	jmp    803a63 <alloc_block_FF+0x1aa>
  803a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a63:	a3 40 61 80 00       	mov    %eax,0x806140
  803a68:	a1 40 61 80 00       	mov    0x806140,%eax
  803a6d:	85 c0                	test   %eax,%eax
  803a6f:	0f 85 57 fe ff ff    	jne    8038cc <alloc_block_FF+0x13>
  803a75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a79:	0f 85 4d fe ff ff    	jne    8038cc <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  803a7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a84:	c9                   	leave  
  803a85:	c3                   	ret    

00803a86 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803a86:	55                   	push   %ebp
  803a87:	89 e5                	mov    %esp,%ebp
  803a89:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  803a8c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803a93:	a1 38 61 80 00       	mov    0x806138,%eax
  803a98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a9b:	e9 df 00 00 00       	jmp    803b7f <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  803aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa3:	8b 40 0c             	mov    0xc(%eax),%eax
  803aa6:	3b 45 08             	cmp    0x8(%ebp),%eax
  803aa9:	0f 82 c8 00 00 00    	jb     803b77 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  803aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab2:	8b 40 0c             	mov    0xc(%eax),%eax
  803ab5:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ab8:	0f 85 8a 00 00 00    	jne    803b48 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  803abe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ac2:	75 17                	jne    803adb <alloc_block_BF+0x55>
  803ac4:	83 ec 04             	sub    $0x4,%esp
  803ac7:	68 b0 56 80 00       	push   $0x8056b0
  803acc:	68 b7 00 00 00       	push   $0xb7
  803ad1:	68 07 56 80 00       	push   $0x805607
  803ad6:	e8 4f de ff ff       	call   80192a <_panic>
  803adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ade:	8b 00                	mov    (%eax),%eax
  803ae0:	85 c0                	test   %eax,%eax
  803ae2:	74 10                	je     803af4 <alloc_block_BF+0x6e>
  803ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae7:	8b 00                	mov    (%eax),%eax
  803ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803aec:	8b 52 04             	mov    0x4(%edx),%edx
  803aef:	89 50 04             	mov    %edx,0x4(%eax)
  803af2:	eb 0b                	jmp    803aff <alloc_block_BF+0x79>
  803af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af7:	8b 40 04             	mov    0x4(%eax),%eax
  803afa:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b02:	8b 40 04             	mov    0x4(%eax),%eax
  803b05:	85 c0                	test   %eax,%eax
  803b07:	74 0f                	je     803b18 <alloc_block_BF+0x92>
  803b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0c:	8b 40 04             	mov    0x4(%eax),%eax
  803b0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b12:	8b 12                	mov    (%edx),%edx
  803b14:	89 10                	mov    %edx,(%eax)
  803b16:	eb 0a                	jmp    803b22 <alloc_block_BF+0x9c>
  803b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1b:	8b 00                	mov    (%eax),%eax
  803b1d:	a3 38 61 80 00       	mov    %eax,0x806138
  803b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b35:	a1 44 61 80 00       	mov    0x806144,%eax
  803b3a:	48                   	dec    %eax
  803b3b:	a3 44 61 80 00       	mov    %eax,0x806144
			   return currentMemBlock;
  803b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b43:	e9 4d 01 00 00       	jmp    803c95 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  803b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4b:	8b 40 0c             	mov    0xc(%eax),%eax
  803b4e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b51:	76 24                	jbe    803b77 <alloc_block_BF+0xf1>
  803b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b56:	8b 40 0c             	mov    0xc(%eax),%eax
  803b59:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803b5c:	73 19                	jae    803b77 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  803b5e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  803b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b68:	8b 40 0c             	mov    0xc(%eax),%eax
  803b6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  803b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b71:	8b 40 08             	mov    0x8(%eax),%eax
  803b74:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803b77:	a1 40 61 80 00       	mov    0x806140,%eax
  803b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b83:	74 07                	je     803b8c <alloc_block_BF+0x106>
  803b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b88:	8b 00                	mov    (%eax),%eax
  803b8a:	eb 05                	jmp    803b91 <alloc_block_BF+0x10b>
  803b8c:	b8 00 00 00 00       	mov    $0x0,%eax
  803b91:	a3 40 61 80 00       	mov    %eax,0x806140
  803b96:	a1 40 61 80 00       	mov    0x806140,%eax
  803b9b:	85 c0                	test   %eax,%eax
  803b9d:	0f 85 fd fe ff ff    	jne    803aa0 <alloc_block_BF+0x1a>
  803ba3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ba7:	0f 85 f3 fe ff ff    	jne    803aa0 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  803bad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bb1:	0f 84 d9 00 00 00    	je     803c90 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  803bb7:	a1 48 61 80 00       	mov    0x806148,%eax
  803bbc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803bbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803bc5:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803bc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bcb:	8b 55 08             	mov    0x8(%ebp),%edx
  803bce:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803bd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bd5:	75 17                	jne    803bee <alloc_block_BF+0x168>
  803bd7:	83 ec 04             	sub    $0x4,%esp
  803bda:	68 b0 56 80 00       	push   $0x8056b0
  803bdf:	68 c7 00 00 00       	push   $0xc7
  803be4:	68 07 56 80 00       	push   $0x805607
  803be9:	e8 3c dd ff ff       	call   80192a <_panic>
  803bee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf1:	8b 00                	mov    (%eax),%eax
  803bf3:	85 c0                	test   %eax,%eax
  803bf5:	74 10                	je     803c07 <alloc_block_BF+0x181>
  803bf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bfa:	8b 00                	mov    (%eax),%eax
  803bfc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bff:	8b 52 04             	mov    0x4(%edx),%edx
  803c02:	89 50 04             	mov    %edx,0x4(%eax)
  803c05:	eb 0b                	jmp    803c12 <alloc_block_BF+0x18c>
  803c07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c0a:	8b 40 04             	mov    0x4(%eax),%eax
  803c0d:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803c12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c15:	8b 40 04             	mov    0x4(%eax),%eax
  803c18:	85 c0                	test   %eax,%eax
  803c1a:	74 0f                	je     803c2b <alloc_block_BF+0x1a5>
  803c1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c1f:	8b 40 04             	mov    0x4(%eax),%eax
  803c22:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c25:	8b 12                	mov    (%edx),%edx
  803c27:	89 10                	mov    %edx,(%eax)
  803c29:	eb 0a                	jmp    803c35 <alloc_block_BF+0x1af>
  803c2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2e:	8b 00                	mov    (%eax),%eax
  803c30:	a3 48 61 80 00       	mov    %eax,0x806148
  803c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c48:	a1 54 61 80 00       	mov    0x806154,%eax
  803c4d:	48                   	dec    %eax
  803c4e:	a3 54 61 80 00       	mov    %eax,0x806154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803c53:	83 ec 08             	sub    $0x8,%esp
  803c56:	ff 75 ec             	pushl  -0x14(%ebp)
  803c59:	68 38 61 80 00       	push   $0x806138
  803c5e:	e8 71 f9 ff ff       	call   8035d4 <find_block>
  803c63:	83 c4 10             	add    $0x10,%esp
  803c66:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803c69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c6c:	8b 50 08             	mov    0x8(%eax),%edx
  803c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c72:	01 c2                	add    %eax,%edx
  803c74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c77:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803c7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c7d:	8b 40 0c             	mov    0xc(%eax),%eax
  803c80:	2b 45 08             	sub    0x8(%ebp),%eax
  803c83:	89 c2                	mov    %eax,%edx
  803c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c88:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803c8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c8e:	eb 05                	jmp    803c95 <alloc_block_BF+0x20f>
	}
	return NULL;
  803c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c95:	c9                   	leave  
  803c96:	c3                   	ret    

00803c97 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803c97:	55                   	push   %ebp
  803c98:	89 e5                	mov    %esp,%ebp
  803c9a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803c9d:	a1 28 60 80 00       	mov    0x806028,%eax
  803ca2:	85 c0                	test   %eax,%eax
  803ca4:	0f 85 de 01 00 00    	jne    803e88 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803caa:	a1 38 61 80 00       	mov    0x806138,%eax
  803caf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cb2:	e9 9e 01 00 00       	jmp    803e55 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cba:	8b 40 0c             	mov    0xc(%eax),%eax
  803cbd:	3b 45 08             	cmp    0x8(%ebp),%eax
  803cc0:	0f 82 87 01 00 00    	jb     803e4d <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc9:	8b 40 0c             	mov    0xc(%eax),%eax
  803ccc:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ccf:	0f 85 95 00 00 00    	jne    803d6a <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803cd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cd9:	75 17                	jne    803cf2 <alloc_block_NF+0x5b>
  803cdb:	83 ec 04             	sub    $0x4,%esp
  803cde:	68 b0 56 80 00       	push   $0x8056b0
  803ce3:	68 e0 00 00 00       	push   $0xe0
  803ce8:	68 07 56 80 00       	push   $0x805607
  803ced:	e8 38 dc ff ff       	call   80192a <_panic>
  803cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf5:	8b 00                	mov    (%eax),%eax
  803cf7:	85 c0                	test   %eax,%eax
  803cf9:	74 10                	je     803d0b <alloc_block_NF+0x74>
  803cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cfe:	8b 00                	mov    (%eax),%eax
  803d00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d03:	8b 52 04             	mov    0x4(%edx),%edx
  803d06:	89 50 04             	mov    %edx,0x4(%eax)
  803d09:	eb 0b                	jmp    803d16 <alloc_block_NF+0x7f>
  803d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0e:	8b 40 04             	mov    0x4(%eax),%eax
  803d11:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d19:	8b 40 04             	mov    0x4(%eax),%eax
  803d1c:	85 c0                	test   %eax,%eax
  803d1e:	74 0f                	je     803d2f <alloc_block_NF+0x98>
  803d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d23:	8b 40 04             	mov    0x4(%eax),%eax
  803d26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d29:	8b 12                	mov    (%edx),%edx
  803d2b:	89 10                	mov    %edx,(%eax)
  803d2d:	eb 0a                	jmp    803d39 <alloc_block_NF+0xa2>
  803d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d32:	8b 00                	mov    (%eax),%eax
  803d34:	a3 38 61 80 00       	mov    %eax,0x806138
  803d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d4c:	a1 44 61 80 00       	mov    0x806144,%eax
  803d51:	48                   	dec    %eax
  803d52:	a3 44 61 80 00       	mov    %eax,0x806144
				   svaOfNF = point->sva;
  803d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5a:	8b 40 08             	mov    0x8(%eax),%eax
  803d5d:	a3 28 60 80 00       	mov    %eax,0x806028
				   return  point;
  803d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d65:	e9 f8 04 00 00       	jmp    804262 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6d:	8b 40 0c             	mov    0xc(%eax),%eax
  803d70:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d73:	0f 86 d4 00 00 00    	jbe    803e4d <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803d79:	a1 48 61 80 00       	mov    0x806148,%eax
  803d7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d84:	8b 50 08             	mov    0x8(%eax),%edx
  803d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d8a:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d90:	8b 55 08             	mov    0x8(%ebp),%edx
  803d93:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803d96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d9a:	75 17                	jne    803db3 <alloc_block_NF+0x11c>
  803d9c:	83 ec 04             	sub    $0x4,%esp
  803d9f:	68 b0 56 80 00       	push   $0x8056b0
  803da4:	68 e9 00 00 00       	push   $0xe9
  803da9:	68 07 56 80 00       	push   $0x805607
  803dae:	e8 77 db ff ff       	call   80192a <_panic>
  803db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db6:	8b 00                	mov    (%eax),%eax
  803db8:	85 c0                	test   %eax,%eax
  803dba:	74 10                	je     803dcc <alloc_block_NF+0x135>
  803dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dbf:	8b 00                	mov    (%eax),%eax
  803dc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dc4:	8b 52 04             	mov    0x4(%edx),%edx
  803dc7:	89 50 04             	mov    %edx,0x4(%eax)
  803dca:	eb 0b                	jmp    803dd7 <alloc_block_NF+0x140>
  803dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dcf:	8b 40 04             	mov    0x4(%eax),%eax
  803dd2:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dda:	8b 40 04             	mov    0x4(%eax),%eax
  803ddd:	85 c0                	test   %eax,%eax
  803ddf:	74 0f                	je     803df0 <alloc_block_NF+0x159>
  803de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de4:	8b 40 04             	mov    0x4(%eax),%eax
  803de7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dea:	8b 12                	mov    (%edx),%edx
  803dec:	89 10                	mov    %edx,(%eax)
  803dee:	eb 0a                	jmp    803dfa <alloc_block_NF+0x163>
  803df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803df3:	8b 00                	mov    (%eax),%eax
  803df5:	a3 48 61 80 00       	mov    %eax,0x806148
  803dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e0d:	a1 54 61 80 00       	mov    0x806154,%eax
  803e12:	48                   	dec    %eax
  803e13:	a3 54 61 80 00       	mov    %eax,0x806154
				   svaOfNF = ReturnedBlock->sva;
  803e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e1b:	8b 40 08             	mov    0x8(%eax),%eax
  803e1e:	a3 28 60 80 00       	mov    %eax,0x806028
				   point->sva += size;
  803e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e26:	8b 50 08             	mov    0x8(%eax),%edx
  803e29:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2c:	01 c2                	add    %eax,%edx
  803e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e31:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e37:	8b 40 0c             	mov    0xc(%eax),%eax
  803e3a:	2b 45 08             	sub    0x8(%ebp),%eax
  803e3d:	89 c2                	mov    %eax,%edx
  803e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e42:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e48:	e9 15 04 00 00       	jmp    804262 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803e4d:	a1 40 61 80 00       	mov    0x806140,%eax
  803e52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e59:	74 07                	je     803e62 <alloc_block_NF+0x1cb>
  803e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5e:	8b 00                	mov    (%eax),%eax
  803e60:	eb 05                	jmp    803e67 <alloc_block_NF+0x1d0>
  803e62:	b8 00 00 00 00       	mov    $0x0,%eax
  803e67:	a3 40 61 80 00       	mov    %eax,0x806140
  803e6c:	a1 40 61 80 00       	mov    0x806140,%eax
  803e71:	85 c0                	test   %eax,%eax
  803e73:	0f 85 3e fe ff ff    	jne    803cb7 <alloc_block_NF+0x20>
  803e79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e7d:	0f 85 34 fe ff ff    	jne    803cb7 <alloc_block_NF+0x20>
  803e83:	e9 d5 03 00 00       	jmp    80425d <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803e88:	a1 38 61 80 00       	mov    0x806138,%eax
  803e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e90:	e9 b1 01 00 00       	jmp    804046 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e98:	8b 50 08             	mov    0x8(%eax),%edx
  803e9b:	a1 28 60 80 00       	mov    0x806028,%eax
  803ea0:	39 c2                	cmp    %eax,%edx
  803ea2:	0f 82 96 01 00 00    	jb     80403e <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eab:	8b 40 0c             	mov    0xc(%eax),%eax
  803eae:	3b 45 08             	cmp    0x8(%ebp),%eax
  803eb1:	0f 82 87 01 00 00    	jb     80403e <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eba:	8b 40 0c             	mov    0xc(%eax),%eax
  803ebd:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ec0:	0f 85 95 00 00 00    	jne    803f5b <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803ec6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eca:	75 17                	jne    803ee3 <alloc_block_NF+0x24c>
  803ecc:	83 ec 04             	sub    $0x4,%esp
  803ecf:	68 b0 56 80 00       	push   $0x8056b0
  803ed4:	68 fc 00 00 00       	push   $0xfc
  803ed9:	68 07 56 80 00       	push   $0x805607
  803ede:	e8 47 da ff ff       	call   80192a <_panic>
  803ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee6:	8b 00                	mov    (%eax),%eax
  803ee8:	85 c0                	test   %eax,%eax
  803eea:	74 10                	je     803efc <alloc_block_NF+0x265>
  803eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eef:	8b 00                	mov    (%eax),%eax
  803ef1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ef4:	8b 52 04             	mov    0x4(%edx),%edx
  803ef7:	89 50 04             	mov    %edx,0x4(%eax)
  803efa:	eb 0b                	jmp    803f07 <alloc_block_NF+0x270>
  803efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eff:	8b 40 04             	mov    0x4(%eax),%eax
  803f02:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f0a:	8b 40 04             	mov    0x4(%eax),%eax
  803f0d:	85 c0                	test   %eax,%eax
  803f0f:	74 0f                	je     803f20 <alloc_block_NF+0x289>
  803f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f14:	8b 40 04             	mov    0x4(%eax),%eax
  803f17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f1a:	8b 12                	mov    (%edx),%edx
  803f1c:	89 10                	mov    %edx,(%eax)
  803f1e:	eb 0a                	jmp    803f2a <alloc_block_NF+0x293>
  803f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f23:	8b 00                	mov    (%eax),%eax
  803f25:	a3 38 61 80 00       	mov    %eax,0x806138
  803f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f3d:	a1 44 61 80 00       	mov    0x806144,%eax
  803f42:	48                   	dec    %eax
  803f43:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f4b:	8b 40 08             	mov    0x8(%eax),%eax
  803f4e:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f56:	e9 07 03 00 00       	jmp    804262 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f5e:	8b 40 0c             	mov    0xc(%eax),%eax
  803f61:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f64:	0f 86 d4 00 00 00    	jbe    80403e <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803f6a:	a1 48 61 80 00       	mov    0x806148,%eax
  803f6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f75:	8b 50 08             	mov    0x8(%eax),%edx
  803f78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f7b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803f7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f81:	8b 55 08             	mov    0x8(%ebp),%edx
  803f84:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803f87:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803f8b:	75 17                	jne    803fa4 <alloc_block_NF+0x30d>
  803f8d:	83 ec 04             	sub    $0x4,%esp
  803f90:	68 b0 56 80 00       	push   $0x8056b0
  803f95:	68 04 01 00 00       	push   $0x104
  803f9a:	68 07 56 80 00       	push   $0x805607
  803f9f:	e8 86 d9 ff ff       	call   80192a <_panic>
  803fa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fa7:	8b 00                	mov    (%eax),%eax
  803fa9:	85 c0                	test   %eax,%eax
  803fab:	74 10                	je     803fbd <alloc_block_NF+0x326>
  803fad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fb0:	8b 00                	mov    (%eax),%eax
  803fb2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fb5:	8b 52 04             	mov    0x4(%edx),%edx
  803fb8:	89 50 04             	mov    %edx,0x4(%eax)
  803fbb:	eb 0b                	jmp    803fc8 <alloc_block_NF+0x331>
  803fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fc0:	8b 40 04             	mov    0x4(%eax),%eax
  803fc3:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fcb:	8b 40 04             	mov    0x4(%eax),%eax
  803fce:	85 c0                	test   %eax,%eax
  803fd0:	74 0f                	je     803fe1 <alloc_block_NF+0x34a>
  803fd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fd5:	8b 40 04             	mov    0x4(%eax),%eax
  803fd8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803fdb:	8b 12                	mov    (%edx),%edx
  803fdd:	89 10                	mov    %edx,(%eax)
  803fdf:	eb 0a                	jmp    803feb <alloc_block_NF+0x354>
  803fe1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fe4:	8b 00                	mov    (%eax),%eax
  803fe6:	a3 48 61 80 00       	mov    %eax,0x806148
  803feb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ff4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ff7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ffe:	a1 54 61 80 00       	mov    0x806154,%eax
  804003:	48                   	dec    %eax
  804004:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  804009:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80400c:	8b 40 08             	mov    0x8(%eax),%eax
  80400f:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  804014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804017:	8b 50 08             	mov    0x8(%eax),%edx
  80401a:	8b 45 08             	mov    0x8(%ebp),%eax
  80401d:	01 c2                	add    %eax,%edx
  80401f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804022:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  804025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804028:	8b 40 0c             	mov    0xc(%eax),%eax
  80402b:	2b 45 08             	sub    0x8(%ebp),%eax
  80402e:	89 c2                	mov    %eax,%edx
  804030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804033:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  804036:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804039:	e9 24 02 00 00       	jmp    804262 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80403e:	a1 40 61 80 00       	mov    0x806140,%eax
  804043:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804046:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80404a:	74 07                	je     804053 <alloc_block_NF+0x3bc>
  80404c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80404f:	8b 00                	mov    (%eax),%eax
  804051:	eb 05                	jmp    804058 <alloc_block_NF+0x3c1>
  804053:	b8 00 00 00 00       	mov    $0x0,%eax
  804058:	a3 40 61 80 00       	mov    %eax,0x806140
  80405d:	a1 40 61 80 00       	mov    0x806140,%eax
  804062:	85 c0                	test   %eax,%eax
  804064:	0f 85 2b fe ff ff    	jne    803e95 <alloc_block_NF+0x1fe>
  80406a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80406e:	0f 85 21 fe ff ff    	jne    803e95 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  804074:	a1 38 61 80 00       	mov    0x806138,%eax
  804079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80407c:	e9 ae 01 00 00       	jmp    80422f <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  804081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804084:	8b 50 08             	mov    0x8(%eax),%edx
  804087:	a1 28 60 80 00       	mov    0x806028,%eax
  80408c:	39 c2                	cmp    %eax,%edx
  80408e:	0f 83 93 01 00 00    	jae    804227 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  804094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804097:	8b 40 0c             	mov    0xc(%eax),%eax
  80409a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80409d:	0f 82 84 01 00 00    	jb     804227 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8040a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8040a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8040ac:	0f 85 95 00 00 00    	jne    804147 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8040b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040b6:	75 17                	jne    8040cf <alloc_block_NF+0x438>
  8040b8:	83 ec 04             	sub    $0x4,%esp
  8040bb:	68 b0 56 80 00       	push   $0x8056b0
  8040c0:	68 14 01 00 00       	push   $0x114
  8040c5:	68 07 56 80 00       	push   $0x805607
  8040ca:	e8 5b d8 ff ff       	call   80192a <_panic>
  8040cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040d2:	8b 00                	mov    (%eax),%eax
  8040d4:	85 c0                	test   %eax,%eax
  8040d6:	74 10                	je     8040e8 <alloc_block_NF+0x451>
  8040d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040db:	8b 00                	mov    (%eax),%eax
  8040dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040e0:	8b 52 04             	mov    0x4(%edx),%edx
  8040e3:	89 50 04             	mov    %edx,0x4(%eax)
  8040e6:	eb 0b                	jmp    8040f3 <alloc_block_NF+0x45c>
  8040e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040eb:	8b 40 04             	mov    0x4(%eax),%eax
  8040ee:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8040f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040f6:	8b 40 04             	mov    0x4(%eax),%eax
  8040f9:	85 c0                	test   %eax,%eax
  8040fb:	74 0f                	je     80410c <alloc_block_NF+0x475>
  8040fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804100:	8b 40 04             	mov    0x4(%eax),%eax
  804103:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804106:	8b 12                	mov    (%edx),%edx
  804108:	89 10                	mov    %edx,(%eax)
  80410a:	eb 0a                	jmp    804116 <alloc_block_NF+0x47f>
  80410c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80410f:	8b 00                	mov    (%eax),%eax
  804111:	a3 38 61 80 00       	mov    %eax,0x806138
  804116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804119:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80411f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804122:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804129:	a1 44 61 80 00       	mov    0x806144,%eax
  80412e:	48                   	dec    %eax
  80412f:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  804134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804137:	8b 40 08             	mov    0x8(%eax),%eax
  80413a:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  80413f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804142:	e9 1b 01 00 00       	jmp    804262 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  804147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80414a:	8b 40 0c             	mov    0xc(%eax),%eax
  80414d:	3b 45 08             	cmp    0x8(%ebp),%eax
  804150:	0f 86 d1 00 00 00    	jbe    804227 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  804156:	a1 48 61 80 00       	mov    0x806148,%eax
  80415b:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80415e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804161:	8b 50 08             	mov    0x8(%eax),%edx
  804164:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804167:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80416a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80416d:	8b 55 08             	mov    0x8(%ebp),%edx
  804170:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  804173:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804177:	75 17                	jne    804190 <alloc_block_NF+0x4f9>
  804179:	83 ec 04             	sub    $0x4,%esp
  80417c:	68 b0 56 80 00       	push   $0x8056b0
  804181:	68 1c 01 00 00       	push   $0x11c
  804186:	68 07 56 80 00       	push   $0x805607
  80418b:	e8 9a d7 ff ff       	call   80192a <_panic>
  804190:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804193:	8b 00                	mov    (%eax),%eax
  804195:	85 c0                	test   %eax,%eax
  804197:	74 10                	je     8041a9 <alloc_block_NF+0x512>
  804199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80419c:	8b 00                	mov    (%eax),%eax
  80419e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8041a1:	8b 52 04             	mov    0x4(%edx),%edx
  8041a4:	89 50 04             	mov    %edx,0x4(%eax)
  8041a7:	eb 0b                	jmp    8041b4 <alloc_block_NF+0x51d>
  8041a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041ac:	8b 40 04             	mov    0x4(%eax),%eax
  8041af:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8041b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041b7:	8b 40 04             	mov    0x4(%eax),%eax
  8041ba:	85 c0                	test   %eax,%eax
  8041bc:	74 0f                	je     8041cd <alloc_block_NF+0x536>
  8041be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041c1:	8b 40 04             	mov    0x4(%eax),%eax
  8041c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8041c7:	8b 12                	mov    (%edx),%edx
  8041c9:	89 10                	mov    %edx,(%eax)
  8041cb:	eb 0a                	jmp    8041d7 <alloc_block_NF+0x540>
  8041cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041d0:	8b 00                	mov    (%eax),%eax
  8041d2:	a3 48 61 80 00       	mov    %eax,0x806148
  8041d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041ea:	a1 54 61 80 00       	mov    0x806154,%eax
  8041ef:	48                   	dec    %eax
  8041f0:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  8041f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041f8:	8b 40 08             	mov    0x8(%eax),%eax
  8041fb:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  804200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804203:	8b 50 08             	mov    0x8(%eax),%edx
  804206:	8b 45 08             	mov    0x8(%ebp),%eax
  804209:	01 c2                	add    %eax,%edx
  80420b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80420e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  804211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804214:	8b 40 0c             	mov    0xc(%eax),%eax
  804217:	2b 45 08             	sub    0x8(%ebp),%eax
  80421a:	89 c2                	mov    %eax,%edx
  80421c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80421f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  804222:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804225:	eb 3b                	jmp    804262 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  804227:	a1 40 61 80 00       	mov    0x806140,%eax
  80422c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80422f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804233:	74 07                	je     80423c <alloc_block_NF+0x5a5>
  804235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804238:	8b 00                	mov    (%eax),%eax
  80423a:	eb 05                	jmp    804241 <alloc_block_NF+0x5aa>
  80423c:	b8 00 00 00 00       	mov    $0x0,%eax
  804241:	a3 40 61 80 00       	mov    %eax,0x806140
  804246:	a1 40 61 80 00       	mov    0x806140,%eax
  80424b:	85 c0                	test   %eax,%eax
  80424d:	0f 85 2e fe ff ff    	jne    804081 <alloc_block_NF+0x3ea>
  804253:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804257:	0f 85 24 fe ff ff    	jne    804081 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80425d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804262:	c9                   	leave  
  804263:	c3                   	ret    

00804264 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  804264:	55                   	push   %ebp
  804265:	89 e5                	mov    %esp,%ebp
  804267:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80426a:	a1 38 61 80 00       	mov    0x806138,%eax
  80426f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  804272:	a1 3c 61 80 00       	mov    0x80613c,%eax
  804277:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80427a:	a1 38 61 80 00       	mov    0x806138,%eax
  80427f:	85 c0                	test   %eax,%eax
  804281:	74 14                	je     804297 <insert_sorted_with_merge_freeList+0x33>
  804283:	8b 45 08             	mov    0x8(%ebp),%eax
  804286:	8b 50 08             	mov    0x8(%eax),%edx
  804289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80428c:	8b 40 08             	mov    0x8(%eax),%eax
  80428f:	39 c2                	cmp    %eax,%edx
  804291:	0f 87 9b 01 00 00    	ja     804432 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  804297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80429b:	75 17                	jne    8042b4 <insert_sorted_with_merge_freeList+0x50>
  80429d:	83 ec 04             	sub    $0x4,%esp
  8042a0:	68 e4 55 80 00       	push   $0x8055e4
  8042a5:	68 38 01 00 00       	push   $0x138
  8042aa:	68 07 56 80 00       	push   $0x805607
  8042af:	e8 76 d6 ff ff       	call   80192a <_panic>
  8042b4:	8b 15 38 61 80 00    	mov    0x806138,%edx
  8042ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8042bd:	89 10                	mov    %edx,(%eax)
  8042bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8042c2:	8b 00                	mov    (%eax),%eax
  8042c4:	85 c0                	test   %eax,%eax
  8042c6:	74 0d                	je     8042d5 <insert_sorted_with_merge_freeList+0x71>
  8042c8:	a1 38 61 80 00       	mov    0x806138,%eax
  8042cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8042d0:	89 50 04             	mov    %edx,0x4(%eax)
  8042d3:	eb 08                	jmp    8042dd <insert_sorted_with_merge_freeList+0x79>
  8042d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8042d8:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8042dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8042e0:	a3 38 61 80 00       	mov    %eax,0x806138
  8042e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8042e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042ef:	a1 44 61 80 00       	mov    0x806144,%eax
  8042f4:	40                   	inc    %eax
  8042f5:	a3 44 61 80 00       	mov    %eax,0x806144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8042fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8042fe:	0f 84 a8 06 00 00    	je     8049ac <insert_sorted_with_merge_freeList+0x748>
  804304:	8b 45 08             	mov    0x8(%ebp),%eax
  804307:	8b 50 08             	mov    0x8(%eax),%edx
  80430a:	8b 45 08             	mov    0x8(%ebp),%eax
  80430d:	8b 40 0c             	mov    0xc(%eax),%eax
  804310:	01 c2                	add    %eax,%edx
  804312:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804315:	8b 40 08             	mov    0x8(%eax),%eax
  804318:	39 c2                	cmp    %eax,%edx
  80431a:	0f 85 8c 06 00 00    	jne    8049ac <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  804320:	8b 45 08             	mov    0x8(%ebp),%eax
  804323:	8b 50 0c             	mov    0xc(%eax),%edx
  804326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804329:	8b 40 0c             	mov    0xc(%eax),%eax
  80432c:	01 c2                	add    %eax,%edx
  80432e:	8b 45 08             	mov    0x8(%ebp),%eax
  804331:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  804334:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804338:	75 17                	jne    804351 <insert_sorted_with_merge_freeList+0xed>
  80433a:	83 ec 04             	sub    $0x4,%esp
  80433d:	68 b0 56 80 00       	push   $0x8056b0
  804342:	68 3c 01 00 00       	push   $0x13c
  804347:	68 07 56 80 00       	push   $0x805607
  80434c:	e8 d9 d5 ff ff       	call   80192a <_panic>
  804351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804354:	8b 00                	mov    (%eax),%eax
  804356:	85 c0                	test   %eax,%eax
  804358:	74 10                	je     80436a <insert_sorted_with_merge_freeList+0x106>
  80435a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80435d:	8b 00                	mov    (%eax),%eax
  80435f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804362:	8b 52 04             	mov    0x4(%edx),%edx
  804365:	89 50 04             	mov    %edx,0x4(%eax)
  804368:	eb 0b                	jmp    804375 <insert_sorted_with_merge_freeList+0x111>
  80436a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80436d:	8b 40 04             	mov    0x4(%eax),%eax
  804370:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804378:	8b 40 04             	mov    0x4(%eax),%eax
  80437b:	85 c0                	test   %eax,%eax
  80437d:	74 0f                	je     80438e <insert_sorted_with_merge_freeList+0x12a>
  80437f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804382:	8b 40 04             	mov    0x4(%eax),%eax
  804385:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804388:	8b 12                	mov    (%edx),%edx
  80438a:	89 10                	mov    %edx,(%eax)
  80438c:	eb 0a                	jmp    804398 <insert_sorted_with_merge_freeList+0x134>
  80438e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804391:	8b 00                	mov    (%eax),%eax
  804393:	a3 38 61 80 00       	mov    %eax,0x806138
  804398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80439b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8043a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043ab:	a1 44 61 80 00       	mov    0x806144,%eax
  8043b0:	48                   	dec    %eax
  8043b1:	a3 44 61 80 00       	mov    %eax,0x806144
			head->size = 0;
  8043b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043b9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8043c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043c3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8043ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8043ce:	75 17                	jne    8043e7 <insert_sorted_with_merge_freeList+0x183>
  8043d0:	83 ec 04             	sub    $0x4,%esp
  8043d3:	68 e4 55 80 00       	push   $0x8055e4
  8043d8:	68 3f 01 00 00       	push   $0x13f
  8043dd:	68 07 56 80 00       	push   $0x805607
  8043e2:	e8 43 d5 ff ff       	call   80192a <_panic>
  8043e7:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8043ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043f0:	89 10                	mov    %edx,(%eax)
  8043f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8043f5:	8b 00                	mov    (%eax),%eax
  8043f7:	85 c0                	test   %eax,%eax
  8043f9:	74 0d                	je     804408 <insert_sorted_with_merge_freeList+0x1a4>
  8043fb:	a1 48 61 80 00       	mov    0x806148,%eax
  804400:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804403:	89 50 04             	mov    %edx,0x4(%eax)
  804406:	eb 08                	jmp    804410 <insert_sorted_with_merge_freeList+0x1ac>
  804408:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80440b:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804413:	a3 48 61 80 00       	mov    %eax,0x806148
  804418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80441b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804422:	a1 54 61 80 00       	mov    0x806154,%eax
  804427:	40                   	inc    %eax
  804428:	a3 54 61 80 00       	mov    %eax,0x806154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80442d:	e9 7a 05 00 00       	jmp    8049ac <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  804432:	8b 45 08             	mov    0x8(%ebp),%eax
  804435:	8b 50 08             	mov    0x8(%eax),%edx
  804438:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80443b:	8b 40 08             	mov    0x8(%eax),%eax
  80443e:	39 c2                	cmp    %eax,%edx
  804440:	0f 82 14 01 00 00    	jb     80455a <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  804446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804449:	8b 50 08             	mov    0x8(%eax),%edx
  80444c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80444f:	8b 40 0c             	mov    0xc(%eax),%eax
  804452:	01 c2                	add    %eax,%edx
  804454:	8b 45 08             	mov    0x8(%ebp),%eax
  804457:	8b 40 08             	mov    0x8(%eax),%eax
  80445a:	39 c2                	cmp    %eax,%edx
  80445c:	0f 85 90 00 00 00    	jne    8044f2 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  804462:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804465:	8b 50 0c             	mov    0xc(%eax),%edx
  804468:	8b 45 08             	mov    0x8(%ebp),%eax
  80446b:	8b 40 0c             	mov    0xc(%eax),%eax
  80446e:	01 c2                	add    %eax,%edx
  804470:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804473:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  804476:	8b 45 08             	mov    0x8(%ebp),%eax
  804479:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  804480:	8b 45 08             	mov    0x8(%ebp),%eax
  804483:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80448a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80448e:	75 17                	jne    8044a7 <insert_sorted_with_merge_freeList+0x243>
  804490:	83 ec 04             	sub    $0x4,%esp
  804493:	68 e4 55 80 00       	push   $0x8055e4
  804498:	68 49 01 00 00       	push   $0x149
  80449d:	68 07 56 80 00       	push   $0x805607
  8044a2:	e8 83 d4 ff ff       	call   80192a <_panic>
  8044a7:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8044ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8044b0:	89 10                	mov    %edx,(%eax)
  8044b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8044b5:	8b 00                	mov    (%eax),%eax
  8044b7:	85 c0                	test   %eax,%eax
  8044b9:	74 0d                	je     8044c8 <insert_sorted_with_merge_freeList+0x264>
  8044bb:	a1 48 61 80 00       	mov    0x806148,%eax
  8044c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8044c3:	89 50 04             	mov    %edx,0x4(%eax)
  8044c6:	eb 08                	jmp    8044d0 <insert_sorted_with_merge_freeList+0x26c>
  8044c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8044cb:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8044d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8044d3:	a3 48 61 80 00       	mov    %eax,0x806148
  8044d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8044db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8044e2:	a1 54 61 80 00       	mov    0x806154,%eax
  8044e7:	40                   	inc    %eax
  8044e8:	a3 54 61 80 00       	mov    %eax,0x806154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8044ed:	e9 bb 04 00 00       	jmp    8049ad <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8044f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8044f6:	75 17                	jne    80450f <insert_sorted_with_merge_freeList+0x2ab>
  8044f8:	83 ec 04             	sub    $0x4,%esp
  8044fb:	68 58 56 80 00       	push   $0x805658
  804500:	68 4c 01 00 00       	push   $0x14c
  804505:	68 07 56 80 00       	push   $0x805607
  80450a:	e8 1b d4 ff ff       	call   80192a <_panic>
  80450f:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  804515:	8b 45 08             	mov    0x8(%ebp),%eax
  804518:	89 50 04             	mov    %edx,0x4(%eax)
  80451b:	8b 45 08             	mov    0x8(%ebp),%eax
  80451e:	8b 40 04             	mov    0x4(%eax),%eax
  804521:	85 c0                	test   %eax,%eax
  804523:	74 0c                	je     804531 <insert_sorted_with_merge_freeList+0x2cd>
  804525:	a1 3c 61 80 00       	mov    0x80613c,%eax
  80452a:	8b 55 08             	mov    0x8(%ebp),%edx
  80452d:	89 10                	mov    %edx,(%eax)
  80452f:	eb 08                	jmp    804539 <insert_sorted_with_merge_freeList+0x2d5>
  804531:	8b 45 08             	mov    0x8(%ebp),%eax
  804534:	a3 38 61 80 00       	mov    %eax,0x806138
  804539:	8b 45 08             	mov    0x8(%ebp),%eax
  80453c:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804541:	8b 45 08             	mov    0x8(%ebp),%eax
  804544:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80454a:	a1 44 61 80 00       	mov    0x806144,%eax
  80454f:	40                   	inc    %eax
  804550:	a3 44 61 80 00       	mov    %eax,0x806144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804555:	e9 53 04 00 00       	jmp    8049ad <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80455a:	a1 38 61 80 00       	mov    0x806138,%eax
  80455f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804562:	e9 15 04 00 00       	jmp    80497c <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  804567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80456a:	8b 00                	mov    (%eax),%eax
  80456c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80456f:	8b 45 08             	mov    0x8(%ebp),%eax
  804572:	8b 50 08             	mov    0x8(%eax),%edx
  804575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804578:	8b 40 08             	mov    0x8(%eax),%eax
  80457b:	39 c2                	cmp    %eax,%edx
  80457d:	0f 86 f1 03 00 00    	jbe    804974 <insert_sorted_with_merge_freeList+0x710>
  804583:	8b 45 08             	mov    0x8(%ebp),%eax
  804586:	8b 50 08             	mov    0x8(%eax),%edx
  804589:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80458c:	8b 40 08             	mov    0x8(%eax),%eax
  80458f:	39 c2                	cmp    %eax,%edx
  804591:	0f 83 dd 03 00 00    	jae    804974 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  804597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80459a:	8b 50 08             	mov    0x8(%eax),%edx
  80459d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8045a3:	01 c2                	add    %eax,%edx
  8045a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8045a8:	8b 40 08             	mov    0x8(%eax),%eax
  8045ab:	39 c2                	cmp    %eax,%edx
  8045ad:	0f 85 b9 01 00 00    	jne    80476c <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8045b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8045b6:	8b 50 08             	mov    0x8(%eax),%edx
  8045b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8045bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8045bf:	01 c2                	add    %eax,%edx
  8045c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045c4:	8b 40 08             	mov    0x8(%eax),%eax
  8045c7:	39 c2                	cmp    %eax,%edx
  8045c9:	0f 85 0d 01 00 00    	jne    8046dc <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8045cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045d2:	8b 50 0c             	mov    0xc(%eax),%edx
  8045d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8045db:	01 c2                	add    %eax,%edx
  8045dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045e0:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8045e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8045e7:	75 17                	jne    804600 <insert_sorted_with_merge_freeList+0x39c>
  8045e9:	83 ec 04             	sub    $0x4,%esp
  8045ec:	68 b0 56 80 00       	push   $0x8056b0
  8045f1:	68 5c 01 00 00       	push   $0x15c
  8045f6:	68 07 56 80 00       	push   $0x805607
  8045fb:	e8 2a d3 ff ff       	call   80192a <_panic>
  804600:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804603:	8b 00                	mov    (%eax),%eax
  804605:	85 c0                	test   %eax,%eax
  804607:	74 10                	je     804619 <insert_sorted_with_merge_freeList+0x3b5>
  804609:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80460c:	8b 00                	mov    (%eax),%eax
  80460e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804611:	8b 52 04             	mov    0x4(%edx),%edx
  804614:	89 50 04             	mov    %edx,0x4(%eax)
  804617:	eb 0b                	jmp    804624 <insert_sorted_with_merge_freeList+0x3c0>
  804619:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80461c:	8b 40 04             	mov    0x4(%eax),%eax
  80461f:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804624:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804627:	8b 40 04             	mov    0x4(%eax),%eax
  80462a:	85 c0                	test   %eax,%eax
  80462c:	74 0f                	je     80463d <insert_sorted_with_merge_freeList+0x3d9>
  80462e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804631:	8b 40 04             	mov    0x4(%eax),%eax
  804634:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804637:	8b 12                	mov    (%edx),%edx
  804639:	89 10                	mov    %edx,(%eax)
  80463b:	eb 0a                	jmp    804647 <insert_sorted_with_merge_freeList+0x3e3>
  80463d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804640:	8b 00                	mov    (%eax),%eax
  804642:	a3 38 61 80 00       	mov    %eax,0x806138
  804647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80464a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804650:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804653:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80465a:	a1 44 61 80 00       	mov    0x806144,%eax
  80465f:	48                   	dec    %eax
  804660:	a3 44 61 80 00       	mov    %eax,0x806144
						nextBlock->sva = 0;
  804665:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804668:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80466f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804672:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  804679:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80467d:	75 17                	jne    804696 <insert_sorted_with_merge_freeList+0x432>
  80467f:	83 ec 04             	sub    $0x4,%esp
  804682:	68 e4 55 80 00       	push   $0x8055e4
  804687:	68 5f 01 00 00       	push   $0x15f
  80468c:	68 07 56 80 00       	push   $0x805607
  804691:	e8 94 d2 ff ff       	call   80192a <_panic>
  804696:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80469c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80469f:	89 10                	mov    %edx,(%eax)
  8046a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046a4:	8b 00                	mov    (%eax),%eax
  8046a6:	85 c0                	test   %eax,%eax
  8046a8:	74 0d                	je     8046b7 <insert_sorted_with_merge_freeList+0x453>
  8046aa:	a1 48 61 80 00       	mov    0x806148,%eax
  8046af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8046b2:	89 50 04             	mov    %edx,0x4(%eax)
  8046b5:	eb 08                	jmp    8046bf <insert_sorted_with_merge_freeList+0x45b>
  8046b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046ba:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8046bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046c2:	a3 48 61 80 00       	mov    %eax,0x806148
  8046c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8046ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8046d1:	a1 54 61 80 00       	mov    0x806154,%eax
  8046d6:	40                   	inc    %eax
  8046d7:	a3 54 61 80 00       	mov    %eax,0x806154
					}
					currentBlock->size += blockToInsert->size;
  8046dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046df:	8b 50 0c             	mov    0xc(%eax),%edx
  8046e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8046e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8046e8:	01 c2                	add    %eax,%edx
  8046ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046ed:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8046f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8046f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8046fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8046fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  804704:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804708:	75 17                	jne    804721 <insert_sorted_with_merge_freeList+0x4bd>
  80470a:	83 ec 04             	sub    $0x4,%esp
  80470d:	68 e4 55 80 00       	push   $0x8055e4
  804712:	68 64 01 00 00       	push   $0x164
  804717:	68 07 56 80 00       	push   $0x805607
  80471c:	e8 09 d2 ff ff       	call   80192a <_panic>
  804721:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804727:	8b 45 08             	mov    0x8(%ebp),%eax
  80472a:	89 10                	mov    %edx,(%eax)
  80472c:	8b 45 08             	mov    0x8(%ebp),%eax
  80472f:	8b 00                	mov    (%eax),%eax
  804731:	85 c0                	test   %eax,%eax
  804733:	74 0d                	je     804742 <insert_sorted_with_merge_freeList+0x4de>
  804735:	a1 48 61 80 00       	mov    0x806148,%eax
  80473a:	8b 55 08             	mov    0x8(%ebp),%edx
  80473d:	89 50 04             	mov    %edx,0x4(%eax)
  804740:	eb 08                	jmp    80474a <insert_sorted_with_merge_freeList+0x4e6>
  804742:	8b 45 08             	mov    0x8(%ebp),%eax
  804745:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80474a:	8b 45 08             	mov    0x8(%ebp),%eax
  80474d:	a3 48 61 80 00       	mov    %eax,0x806148
  804752:	8b 45 08             	mov    0x8(%ebp),%eax
  804755:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80475c:	a1 54 61 80 00       	mov    0x806154,%eax
  804761:	40                   	inc    %eax
  804762:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  804767:	e9 41 02 00 00       	jmp    8049ad <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80476c:	8b 45 08             	mov    0x8(%ebp),%eax
  80476f:	8b 50 08             	mov    0x8(%eax),%edx
  804772:	8b 45 08             	mov    0x8(%ebp),%eax
  804775:	8b 40 0c             	mov    0xc(%eax),%eax
  804778:	01 c2                	add    %eax,%edx
  80477a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80477d:	8b 40 08             	mov    0x8(%eax),%eax
  804780:	39 c2                	cmp    %eax,%edx
  804782:	0f 85 7c 01 00 00    	jne    804904 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  804788:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80478c:	74 06                	je     804794 <insert_sorted_with_merge_freeList+0x530>
  80478e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804792:	75 17                	jne    8047ab <insert_sorted_with_merge_freeList+0x547>
  804794:	83 ec 04             	sub    $0x4,%esp
  804797:	68 20 56 80 00       	push   $0x805620
  80479c:	68 69 01 00 00       	push   $0x169
  8047a1:	68 07 56 80 00       	push   $0x805607
  8047a6:	e8 7f d1 ff ff       	call   80192a <_panic>
  8047ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047ae:	8b 50 04             	mov    0x4(%eax),%edx
  8047b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8047b4:	89 50 04             	mov    %edx,0x4(%eax)
  8047b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8047ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8047bd:	89 10                	mov    %edx,(%eax)
  8047bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047c2:	8b 40 04             	mov    0x4(%eax),%eax
  8047c5:	85 c0                	test   %eax,%eax
  8047c7:	74 0d                	je     8047d6 <insert_sorted_with_merge_freeList+0x572>
  8047c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047cc:	8b 40 04             	mov    0x4(%eax),%eax
  8047cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8047d2:	89 10                	mov    %edx,(%eax)
  8047d4:	eb 08                	jmp    8047de <insert_sorted_with_merge_freeList+0x57a>
  8047d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8047d9:	a3 38 61 80 00       	mov    %eax,0x806138
  8047de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8047e4:	89 50 04             	mov    %edx,0x4(%eax)
  8047e7:	a1 44 61 80 00       	mov    0x806144,%eax
  8047ec:	40                   	inc    %eax
  8047ed:	a3 44 61 80 00       	mov    %eax,0x806144
					blockToInsert->size += nextBlock->size;
  8047f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8047f5:	8b 50 0c             	mov    0xc(%eax),%edx
  8047f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8047fe:	01 c2                	add    %eax,%edx
  804800:	8b 45 08             	mov    0x8(%ebp),%eax
  804803:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  804806:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80480a:	75 17                	jne    804823 <insert_sorted_with_merge_freeList+0x5bf>
  80480c:	83 ec 04             	sub    $0x4,%esp
  80480f:	68 b0 56 80 00       	push   $0x8056b0
  804814:	68 6b 01 00 00       	push   $0x16b
  804819:	68 07 56 80 00       	push   $0x805607
  80481e:	e8 07 d1 ff ff       	call   80192a <_panic>
  804823:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804826:	8b 00                	mov    (%eax),%eax
  804828:	85 c0                	test   %eax,%eax
  80482a:	74 10                	je     80483c <insert_sorted_with_merge_freeList+0x5d8>
  80482c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80482f:	8b 00                	mov    (%eax),%eax
  804831:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804834:	8b 52 04             	mov    0x4(%edx),%edx
  804837:	89 50 04             	mov    %edx,0x4(%eax)
  80483a:	eb 0b                	jmp    804847 <insert_sorted_with_merge_freeList+0x5e3>
  80483c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80483f:	8b 40 04             	mov    0x4(%eax),%eax
  804842:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804847:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80484a:	8b 40 04             	mov    0x4(%eax),%eax
  80484d:	85 c0                	test   %eax,%eax
  80484f:	74 0f                	je     804860 <insert_sorted_with_merge_freeList+0x5fc>
  804851:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804854:	8b 40 04             	mov    0x4(%eax),%eax
  804857:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80485a:	8b 12                	mov    (%edx),%edx
  80485c:	89 10                	mov    %edx,(%eax)
  80485e:	eb 0a                	jmp    80486a <insert_sorted_with_merge_freeList+0x606>
  804860:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804863:	8b 00                	mov    (%eax),%eax
  804865:	a3 38 61 80 00       	mov    %eax,0x806138
  80486a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80486d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804873:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804876:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80487d:	a1 44 61 80 00       	mov    0x806144,%eax
  804882:	48                   	dec    %eax
  804883:	a3 44 61 80 00       	mov    %eax,0x806144
					nextBlock->sva = 0;
  804888:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80488b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  804892:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804895:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80489c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8048a0:	75 17                	jne    8048b9 <insert_sorted_with_merge_freeList+0x655>
  8048a2:	83 ec 04             	sub    $0x4,%esp
  8048a5:	68 e4 55 80 00       	push   $0x8055e4
  8048aa:	68 6e 01 00 00       	push   $0x16e
  8048af:	68 07 56 80 00       	push   $0x805607
  8048b4:	e8 71 d0 ff ff       	call   80192a <_panic>
  8048b9:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8048bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048c2:	89 10                	mov    %edx,(%eax)
  8048c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048c7:	8b 00                	mov    (%eax),%eax
  8048c9:	85 c0                	test   %eax,%eax
  8048cb:	74 0d                	je     8048da <insert_sorted_with_merge_freeList+0x676>
  8048cd:	a1 48 61 80 00       	mov    0x806148,%eax
  8048d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8048d5:	89 50 04             	mov    %edx,0x4(%eax)
  8048d8:	eb 08                	jmp    8048e2 <insert_sorted_with_merge_freeList+0x67e>
  8048da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048dd:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8048e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048e5:	a3 48 61 80 00       	mov    %eax,0x806148
  8048ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8048f4:	a1 54 61 80 00       	mov    0x806154,%eax
  8048f9:	40                   	inc    %eax
  8048fa:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  8048ff:	e9 a9 00 00 00       	jmp    8049ad <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  804904:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804908:	74 06                	je     804910 <insert_sorted_with_merge_freeList+0x6ac>
  80490a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80490e:	75 17                	jne    804927 <insert_sorted_with_merge_freeList+0x6c3>
  804910:	83 ec 04             	sub    $0x4,%esp
  804913:	68 7c 56 80 00       	push   $0x80567c
  804918:	68 73 01 00 00       	push   $0x173
  80491d:	68 07 56 80 00       	push   $0x805607
  804922:	e8 03 d0 ff ff       	call   80192a <_panic>
  804927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80492a:	8b 10                	mov    (%eax),%edx
  80492c:	8b 45 08             	mov    0x8(%ebp),%eax
  80492f:	89 10                	mov    %edx,(%eax)
  804931:	8b 45 08             	mov    0x8(%ebp),%eax
  804934:	8b 00                	mov    (%eax),%eax
  804936:	85 c0                	test   %eax,%eax
  804938:	74 0b                	je     804945 <insert_sorted_with_merge_freeList+0x6e1>
  80493a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80493d:	8b 00                	mov    (%eax),%eax
  80493f:	8b 55 08             	mov    0x8(%ebp),%edx
  804942:	89 50 04             	mov    %edx,0x4(%eax)
  804945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804948:	8b 55 08             	mov    0x8(%ebp),%edx
  80494b:	89 10                	mov    %edx,(%eax)
  80494d:	8b 45 08             	mov    0x8(%ebp),%eax
  804950:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804953:	89 50 04             	mov    %edx,0x4(%eax)
  804956:	8b 45 08             	mov    0x8(%ebp),%eax
  804959:	8b 00                	mov    (%eax),%eax
  80495b:	85 c0                	test   %eax,%eax
  80495d:	75 08                	jne    804967 <insert_sorted_with_merge_freeList+0x703>
  80495f:	8b 45 08             	mov    0x8(%ebp),%eax
  804962:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804967:	a1 44 61 80 00       	mov    0x806144,%eax
  80496c:	40                   	inc    %eax
  80496d:	a3 44 61 80 00       	mov    %eax,0x806144
					break;
  804972:	eb 39                	jmp    8049ad <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  804974:	a1 40 61 80 00       	mov    0x806140,%eax
  804979:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80497c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804980:	74 07                	je     804989 <insert_sorted_with_merge_freeList+0x725>
  804982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804985:	8b 00                	mov    (%eax),%eax
  804987:	eb 05                	jmp    80498e <insert_sorted_with_merge_freeList+0x72a>
  804989:	b8 00 00 00 00       	mov    $0x0,%eax
  80498e:	a3 40 61 80 00       	mov    %eax,0x806140
  804993:	a1 40 61 80 00       	mov    0x806140,%eax
  804998:	85 c0                	test   %eax,%eax
  80499a:	0f 85 c7 fb ff ff    	jne    804567 <insert_sorted_with_merge_freeList+0x303>
  8049a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8049a4:	0f 85 bd fb ff ff    	jne    804567 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8049aa:	eb 01                	jmp    8049ad <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8049ac:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8049ad:	90                   	nop
  8049ae:	c9                   	leave  
  8049af:	c3                   	ret    

008049b0 <__udivdi3>:
  8049b0:	55                   	push   %ebp
  8049b1:	57                   	push   %edi
  8049b2:	56                   	push   %esi
  8049b3:	53                   	push   %ebx
  8049b4:	83 ec 1c             	sub    $0x1c,%esp
  8049b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8049bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8049bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8049c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8049c7:	89 ca                	mov    %ecx,%edx
  8049c9:	89 f8                	mov    %edi,%eax
  8049cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8049cf:	85 f6                	test   %esi,%esi
  8049d1:	75 2d                	jne    804a00 <__udivdi3+0x50>
  8049d3:	39 cf                	cmp    %ecx,%edi
  8049d5:	77 65                	ja     804a3c <__udivdi3+0x8c>
  8049d7:	89 fd                	mov    %edi,%ebp
  8049d9:	85 ff                	test   %edi,%edi
  8049db:	75 0b                	jne    8049e8 <__udivdi3+0x38>
  8049dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8049e2:	31 d2                	xor    %edx,%edx
  8049e4:	f7 f7                	div    %edi
  8049e6:	89 c5                	mov    %eax,%ebp
  8049e8:	31 d2                	xor    %edx,%edx
  8049ea:	89 c8                	mov    %ecx,%eax
  8049ec:	f7 f5                	div    %ebp
  8049ee:	89 c1                	mov    %eax,%ecx
  8049f0:	89 d8                	mov    %ebx,%eax
  8049f2:	f7 f5                	div    %ebp
  8049f4:	89 cf                	mov    %ecx,%edi
  8049f6:	89 fa                	mov    %edi,%edx
  8049f8:	83 c4 1c             	add    $0x1c,%esp
  8049fb:	5b                   	pop    %ebx
  8049fc:	5e                   	pop    %esi
  8049fd:	5f                   	pop    %edi
  8049fe:	5d                   	pop    %ebp
  8049ff:	c3                   	ret    
  804a00:	39 ce                	cmp    %ecx,%esi
  804a02:	77 28                	ja     804a2c <__udivdi3+0x7c>
  804a04:	0f bd fe             	bsr    %esi,%edi
  804a07:	83 f7 1f             	xor    $0x1f,%edi
  804a0a:	75 40                	jne    804a4c <__udivdi3+0x9c>
  804a0c:	39 ce                	cmp    %ecx,%esi
  804a0e:	72 0a                	jb     804a1a <__udivdi3+0x6a>
  804a10:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804a14:	0f 87 9e 00 00 00    	ja     804ab8 <__udivdi3+0x108>
  804a1a:	b8 01 00 00 00       	mov    $0x1,%eax
  804a1f:	89 fa                	mov    %edi,%edx
  804a21:	83 c4 1c             	add    $0x1c,%esp
  804a24:	5b                   	pop    %ebx
  804a25:	5e                   	pop    %esi
  804a26:	5f                   	pop    %edi
  804a27:	5d                   	pop    %ebp
  804a28:	c3                   	ret    
  804a29:	8d 76 00             	lea    0x0(%esi),%esi
  804a2c:	31 ff                	xor    %edi,%edi
  804a2e:	31 c0                	xor    %eax,%eax
  804a30:	89 fa                	mov    %edi,%edx
  804a32:	83 c4 1c             	add    $0x1c,%esp
  804a35:	5b                   	pop    %ebx
  804a36:	5e                   	pop    %esi
  804a37:	5f                   	pop    %edi
  804a38:	5d                   	pop    %ebp
  804a39:	c3                   	ret    
  804a3a:	66 90                	xchg   %ax,%ax
  804a3c:	89 d8                	mov    %ebx,%eax
  804a3e:	f7 f7                	div    %edi
  804a40:	31 ff                	xor    %edi,%edi
  804a42:	89 fa                	mov    %edi,%edx
  804a44:	83 c4 1c             	add    $0x1c,%esp
  804a47:	5b                   	pop    %ebx
  804a48:	5e                   	pop    %esi
  804a49:	5f                   	pop    %edi
  804a4a:	5d                   	pop    %ebp
  804a4b:	c3                   	ret    
  804a4c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804a51:	89 eb                	mov    %ebp,%ebx
  804a53:	29 fb                	sub    %edi,%ebx
  804a55:	89 f9                	mov    %edi,%ecx
  804a57:	d3 e6                	shl    %cl,%esi
  804a59:	89 c5                	mov    %eax,%ebp
  804a5b:	88 d9                	mov    %bl,%cl
  804a5d:	d3 ed                	shr    %cl,%ebp
  804a5f:	89 e9                	mov    %ebp,%ecx
  804a61:	09 f1                	or     %esi,%ecx
  804a63:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804a67:	89 f9                	mov    %edi,%ecx
  804a69:	d3 e0                	shl    %cl,%eax
  804a6b:	89 c5                	mov    %eax,%ebp
  804a6d:	89 d6                	mov    %edx,%esi
  804a6f:	88 d9                	mov    %bl,%cl
  804a71:	d3 ee                	shr    %cl,%esi
  804a73:	89 f9                	mov    %edi,%ecx
  804a75:	d3 e2                	shl    %cl,%edx
  804a77:	8b 44 24 08          	mov    0x8(%esp),%eax
  804a7b:	88 d9                	mov    %bl,%cl
  804a7d:	d3 e8                	shr    %cl,%eax
  804a7f:	09 c2                	or     %eax,%edx
  804a81:	89 d0                	mov    %edx,%eax
  804a83:	89 f2                	mov    %esi,%edx
  804a85:	f7 74 24 0c          	divl   0xc(%esp)
  804a89:	89 d6                	mov    %edx,%esi
  804a8b:	89 c3                	mov    %eax,%ebx
  804a8d:	f7 e5                	mul    %ebp
  804a8f:	39 d6                	cmp    %edx,%esi
  804a91:	72 19                	jb     804aac <__udivdi3+0xfc>
  804a93:	74 0b                	je     804aa0 <__udivdi3+0xf0>
  804a95:	89 d8                	mov    %ebx,%eax
  804a97:	31 ff                	xor    %edi,%edi
  804a99:	e9 58 ff ff ff       	jmp    8049f6 <__udivdi3+0x46>
  804a9e:	66 90                	xchg   %ax,%ax
  804aa0:	8b 54 24 08          	mov    0x8(%esp),%edx
  804aa4:	89 f9                	mov    %edi,%ecx
  804aa6:	d3 e2                	shl    %cl,%edx
  804aa8:	39 c2                	cmp    %eax,%edx
  804aaa:	73 e9                	jae    804a95 <__udivdi3+0xe5>
  804aac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804aaf:	31 ff                	xor    %edi,%edi
  804ab1:	e9 40 ff ff ff       	jmp    8049f6 <__udivdi3+0x46>
  804ab6:	66 90                	xchg   %ax,%ax
  804ab8:	31 c0                	xor    %eax,%eax
  804aba:	e9 37 ff ff ff       	jmp    8049f6 <__udivdi3+0x46>
  804abf:	90                   	nop

00804ac0 <__umoddi3>:
  804ac0:	55                   	push   %ebp
  804ac1:	57                   	push   %edi
  804ac2:	56                   	push   %esi
  804ac3:	53                   	push   %ebx
  804ac4:	83 ec 1c             	sub    $0x1c,%esp
  804ac7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804acb:	8b 74 24 34          	mov    0x34(%esp),%esi
  804acf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804ad3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804ad7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804adb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804adf:	89 f3                	mov    %esi,%ebx
  804ae1:	89 fa                	mov    %edi,%edx
  804ae3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804ae7:	89 34 24             	mov    %esi,(%esp)
  804aea:	85 c0                	test   %eax,%eax
  804aec:	75 1a                	jne    804b08 <__umoddi3+0x48>
  804aee:	39 f7                	cmp    %esi,%edi
  804af0:	0f 86 a2 00 00 00    	jbe    804b98 <__umoddi3+0xd8>
  804af6:	89 c8                	mov    %ecx,%eax
  804af8:	89 f2                	mov    %esi,%edx
  804afa:	f7 f7                	div    %edi
  804afc:	89 d0                	mov    %edx,%eax
  804afe:	31 d2                	xor    %edx,%edx
  804b00:	83 c4 1c             	add    $0x1c,%esp
  804b03:	5b                   	pop    %ebx
  804b04:	5e                   	pop    %esi
  804b05:	5f                   	pop    %edi
  804b06:	5d                   	pop    %ebp
  804b07:	c3                   	ret    
  804b08:	39 f0                	cmp    %esi,%eax
  804b0a:	0f 87 ac 00 00 00    	ja     804bbc <__umoddi3+0xfc>
  804b10:	0f bd e8             	bsr    %eax,%ebp
  804b13:	83 f5 1f             	xor    $0x1f,%ebp
  804b16:	0f 84 ac 00 00 00    	je     804bc8 <__umoddi3+0x108>
  804b1c:	bf 20 00 00 00       	mov    $0x20,%edi
  804b21:	29 ef                	sub    %ebp,%edi
  804b23:	89 fe                	mov    %edi,%esi
  804b25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804b29:	89 e9                	mov    %ebp,%ecx
  804b2b:	d3 e0                	shl    %cl,%eax
  804b2d:	89 d7                	mov    %edx,%edi
  804b2f:	89 f1                	mov    %esi,%ecx
  804b31:	d3 ef                	shr    %cl,%edi
  804b33:	09 c7                	or     %eax,%edi
  804b35:	89 e9                	mov    %ebp,%ecx
  804b37:	d3 e2                	shl    %cl,%edx
  804b39:	89 14 24             	mov    %edx,(%esp)
  804b3c:	89 d8                	mov    %ebx,%eax
  804b3e:	d3 e0                	shl    %cl,%eax
  804b40:	89 c2                	mov    %eax,%edx
  804b42:	8b 44 24 08          	mov    0x8(%esp),%eax
  804b46:	d3 e0                	shl    %cl,%eax
  804b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  804b4c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804b50:	89 f1                	mov    %esi,%ecx
  804b52:	d3 e8                	shr    %cl,%eax
  804b54:	09 d0                	or     %edx,%eax
  804b56:	d3 eb                	shr    %cl,%ebx
  804b58:	89 da                	mov    %ebx,%edx
  804b5a:	f7 f7                	div    %edi
  804b5c:	89 d3                	mov    %edx,%ebx
  804b5e:	f7 24 24             	mull   (%esp)
  804b61:	89 c6                	mov    %eax,%esi
  804b63:	89 d1                	mov    %edx,%ecx
  804b65:	39 d3                	cmp    %edx,%ebx
  804b67:	0f 82 87 00 00 00    	jb     804bf4 <__umoddi3+0x134>
  804b6d:	0f 84 91 00 00 00    	je     804c04 <__umoddi3+0x144>
  804b73:	8b 54 24 04          	mov    0x4(%esp),%edx
  804b77:	29 f2                	sub    %esi,%edx
  804b79:	19 cb                	sbb    %ecx,%ebx
  804b7b:	89 d8                	mov    %ebx,%eax
  804b7d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804b81:	d3 e0                	shl    %cl,%eax
  804b83:	89 e9                	mov    %ebp,%ecx
  804b85:	d3 ea                	shr    %cl,%edx
  804b87:	09 d0                	or     %edx,%eax
  804b89:	89 e9                	mov    %ebp,%ecx
  804b8b:	d3 eb                	shr    %cl,%ebx
  804b8d:	89 da                	mov    %ebx,%edx
  804b8f:	83 c4 1c             	add    $0x1c,%esp
  804b92:	5b                   	pop    %ebx
  804b93:	5e                   	pop    %esi
  804b94:	5f                   	pop    %edi
  804b95:	5d                   	pop    %ebp
  804b96:	c3                   	ret    
  804b97:	90                   	nop
  804b98:	89 fd                	mov    %edi,%ebp
  804b9a:	85 ff                	test   %edi,%edi
  804b9c:	75 0b                	jne    804ba9 <__umoddi3+0xe9>
  804b9e:	b8 01 00 00 00       	mov    $0x1,%eax
  804ba3:	31 d2                	xor    %edx,%edx
  804ba5:	f7 f7                	div    %edi
  804ba7:	89 c5                	mov    %eax,%ebp
  804ba9:	89 f0                	mov    %esi,%eax
  804bab:	31 d2                	xor    %edx,%edx
  804bad:	f7 f5                	div    %ebp
  804baf:	89 c8                	mov    %ecx,%eax
  804bb1:	f7 f5                	div    %ebp
  804bb3:	89 d0                	mov    %edx,%eax
  804bb5:	e9 44 ff ff ff       	jmp    804afe <__umoddi3+0x3e>
  804bba:	66 90                	xchg   %ax,%ax
  804bbc:	89 c8                	mov    %ecx,%eax
  804bbe:	89 f2                	mov    %esi,%edx
  804bc0:	83 c4 1c             	add    $0x1c,%esp
  804bc3:	5b                   	pop    %ebx
  804bc4:	5e                   	pop    %esi
  804bc5:	5f                   	pop    %edi
  804bc6:	5d                   	pop    %ebp
  804bc7:	c3                   	ret    
  804bc8:	3b 04 24             	cmp    (%esp),%eax
  804bcb:	72 06                	jb     804bd3 <__umoddi3+0x113>
  804bcd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804bd1:	77 0f                	ja     804be2 <__umoddi3+0x122>
  804bd3:	89 f2                	mov    %esi,%edx
  804bd5:	29 f9                	sub    %edi,%ecx
  804bd7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804bdb:	89 14 24             	mov    %edx,(%esp)
  804bde:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804be2:	8b 44 24 04          	mov    0x4(%esp),%eax
  804be6:	8b 14 24             	mov    (%esp),%edx
  804be9:	83 c4 1c             	add    $0x1c,%esp
  804bec:	5b                   	pop    %ebx
  804bed:	5e                   	pop    %esi
  804bee:	5f                   	pop    %edi
  804bef:	5d                   	pop    %ebp
  804bf0:	c3                   	ret    
  804bf1:	8d 76 00             	lea    0x0(%esi),%esi
  804bf4:	2b 04 24             	sub    (%esp),%eax
  804bf7:	19 fa                	sbb    %edi,%edx
  804bf9:	89 d1                	mov    %edx,%ecx
  804bfb:	89 c6                	mov    %eax,%esi
  804bfd:	e9 71 ff ff ff       	jmp    804b73 <__umoddi3+0xb3>
  804c02:	66 90                	xchg   %ax,%ax
  804c04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804c08:	72 ea                	jb     804bf4 <__umoddi3+0x134>
  804c0a:	89 d9                	mov    %ebx,%ecx
  804c0c:	e9 62 ff ff ff       	jmp    804b73 <__umoddi3+0xb3>
