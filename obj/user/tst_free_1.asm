
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
  800031:	e8 da 17 00 00       	call   801810 <libmain>
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
  800091:	68 e0 4d 80 00       	push   $0x804de0
  800096:	6a 1a                	push   $0x1a
  800098:	68 fc 4d 80 00       	push   $0x804dfc
  80009d:	e8 aa 18 00 00       	call   80194c <_panic>





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
  8000d7:	e8 ac 2a 00 00       	call   802b88 <malloc>
  8000dc:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 c1 2e 00 00       	call   802fa5 <sys_calculate_free_frames>
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
  8000fb:	e8 45 2f 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  800100:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 74 2a 00 00       	call   802b88 <malloc>
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
  800137:	68 10 4e 80 00       	push   $0x804e10
  80013c:	6a 3a                	push   $0x3a
  80013e:	68 fc 4d 80 00       	push   $0x804dfc
  800143:	e8 04 18 00 00       	call   80194c <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 f8 2e 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 78 4e 80 00       	push   $0x804e78
  80015a:	6a 3b                	push   $0x3b
  80015c:	68 fc 4d 80 00       	push   $0x804dfc
  800161:	e8 e6 17 00 00       	call   80194c <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 3a 2e 00 00       	call   802fa5 <sys_calculate_free_frames>
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
  80019b:	e8 05 2e 00 00       	call   802fa5 <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 a8 4e 80 00       	push   $0x804ea8
  8001b1:	6a 42                	push   $0x42
  8001b3:	68 fc 4d 80 00       	push   $0x804dfc
  8001b8:	e8 8f 17 00 00       	call   80194c <_panic>
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
  80026e:	68 ec 4e 80 00       	push   $0x804eec
  800273:	6a 4c                	push   $0x4c
  800275:	68 fc 4d 80 00       	push   $0x804dfc
  80027a:	e8 cd 16 00 00       	call   80194c <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 c1 2d 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  800284:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800287:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 f0 28 00 00       	call   802b88 <malloc>
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
  8002d0:	68 10 4e 80 00       	push   $0x804e10
  8002d5:	6a 51                	push   $0x51
  8002d7:	68 fc 4d 80 00       	push   $0x804dfc
  8002dc:	e8 6b 16 00 00       	call   80194c <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 5f 2d 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 78 4e 80 00       	push   $0x804e78
  8002f3:	6a 52                	push   $0x52
  8002f5:	68 fc 4d 80 00       	push   $0x804dfc
  8002fa:	e8 4d 16 00 00       	call   80194c <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 a1 2c 00 00       	call   802fa5 <sys_calculate_free_frames>
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
  80033d:	e8 63 2c 00 00       	call   802fa5 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 a8 4e 80 00       	push   $0x804ea8
  800353:	6a 59                	push   $0x59
  800355:	68 fc 4d 80 00       	push   $0x804dfc
  80035a:	e8 ed 15 00 00       	call   80194c <_panic>
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
  800414:	68 ec 4e 80 00       	push   $0x804eec
  800419:	6a 62                	push   $0x62
  80041b:	68 fc 4d 80 00       	push   $0x804dfc
  800420:	e8 27 15 00 00       	call   80194c <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 1b 2c 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  80042a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  80042d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800430:	01 c0                	add    %eax,%eax
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	50                   	push   %eax
  800436:	e8 4d 27 00 00       	call   802b88 <malloc>
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
  800475:	68 10 4e 80 00       	push   $0x804e10
  80047a:	6a 67                	push   $0x67
  80047c:	68 fc 4d 80 00       	push   $0x804dfc
  800481:	e8 c6 14 00 00       	call   80194c <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800486:	e8 ba 2b 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  80048b:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80048e:	74 14                	je     8004a4 <_main+0x46c>
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 78 4e 80 00       	push   $0x804e78
  800498:	6a 68                	push   $0x68
  80049a:	68 fc 4d 80 00       	push   $0x804dfc
  80049f:	e8 a8 14 00 00       	call   80194c <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a4:	e8 fc 2a 00 00       	call   802fa5 <sys_calculate_free_frames>
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
  8004e0:	e8 c0 2a 00 00       	call   802fa5 <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	83 f8 02             	cmp    $0x2,%eax
  8004ec:	74 14                	je     800502 <_main+0x4ca>
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	68 a8 4e 80 00       	push   $0x804ea8
  8004f6:	6a 6f                	push   $0x6f
  8004f8:	68 fc 4d 80 00       	push   $0x804dfc
  8004fd:	e8 4a 14 00 00       	call   80194c <_panic>
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
  8005c6:	68 ec 4e 80 00       	push   $0x804eec
  8005cb:	6a 78                	push   $0x78
  8005cd:	68 fc 4d 80 00       	push   $0x804dfc
  8005d2:	e8 75 13 00 00       	call   80194c <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d7:	e8 c9 29 00 00       	call   802fa5 <sys_calculate_free_frames>
  8005dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005df:	e8 61 2a 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  8005e4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8005e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ea:	01 c0                	add    %eax,%eax
  8005ec:	83 ec 0c             	sub    $0xc,%esp
  8005ef:	50                   	push   %eax
  8005f0:	e8 93 25 00 00       	call   802b88 <malloc>
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
  800643:	68 10 4e 80 00       	push   $0x804e10
  800648:	6a 7e                	push   $0x7e
  80064a:	68 fc 4d 80 00       	push   $0x804dfc
  80064f:	e8 f8 12 00 00       	call   80194c <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800654:	e8 ec 29 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  800659:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80065c:	74 14                	je     800672 <_main+0x63a>
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	68 78 4e 80 00       	push   $0x804e78
  800666:	6a 7f                	push   $0x7f
  800668:	68 fc 4d 80 00       	push   $0x804dfc
  80066d:	e8 da 12 00 00       	call   80194c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800672:	e8 ce 29 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
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
  80068b:	e8 f8 24 00 00       	call   802b88 <malloc>
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
  8006de:	68 10 4e 80 00       	push   $0x804e10
  8006e3:	68 85 00 00 00       	push   $0x85
  8006e8:	68 fc 4d 80 00       	push   $0x804dfc
  8006ed:	e8 5a 12 00 00       	call   80194c <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f2:	e8 4e 29 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  8006f7:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8006fa:	74 17                	je     800713 <_main+0x6db>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 78 4e 80 00       	push   $0x804e78
  800704:	68 86 00 00 00       	push   $0x86
  800709:	68 fc 4d 80 00       	push   $0x804dfc
  80070e:	e8 39 12 00 00       	call   80194c <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800713:	e8 8d 28 00 00       	call   802fa5 <sys_calculate_free_frames>
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
  8007b7:	e8 e9 27 00 00       	call   802fa5 <sys_calculate_free_frames>
  8007bc:	29 c3                	sub    %eax,%ebx
  8007be:	89 d8                	mov    %ebx,%eax
  8007c0:	83 f8 02             	cmp    $0x2,%eax
  8007c3:	74 17                	je     8007dc <_main+0x7a4>
  8007c5:	83 ec 04             	sub    $0x4,%esp
  8007c8:	68 a8 4e 80 00       	push   $0x804ea8
  8007cd:	68 8d 00 00 00       	push   $0x8d
  8007d2:	68 fc 4d 80 00       	push   $0x804dfc
  8007d7:	e8 70 11 00 00       	call   80194c <_panic>
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
  8008b5:	68 ec 4e 80 00       	push   $0x804eec
  8008ba:	68 96 00 00 00       	push   $0x96
  8008bf:	68 fc 4d 80 00       	push   $0x804dfc
  8008c4:	e8 83 10 00 00       	call   80194c <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 d7 26 00 00       	call   802fa5 <sys_calculate_free_frames>
  8008ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d1:	e8 6f 27 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  8008d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008dc:	89 c2                	mov    %eax,%edx
  8008de:	01 d2                	add    %edx,%edx
  8008e0:	01 d0                	add    %edx,%eax
  8008e2:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008e5:	83 ec 0c             	sub    $0xc,%esp
  8008e8:	50                   	push   %eax
  8008e9:	e8 9a 22 00 00       	call   802b88 <malloc>
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
  80093c:	68 10 4e 80 00       	push   $0x804e10
  800941:	68 9c 00 00 00       	push   $0x9c
  800946:	68 fc 4d 80 00       	push   $0x804dfc
  80094b:	e8 fc 0f 00 00       	call   80194c <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800950:	e8 f0 26 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  800955:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800958:	74 17                	je     800971 <_main+0x939>
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 78 4e 80 00       	push   $0x804e78
  800962:	68 9d 00 00 00       	push   $0x9d
  800967:	68 fc 4d 80 00       	push   $0x804dfc
  80096c:	e8 db 0f 00 00       	call   80194c <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800971:	e8 cf 26 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
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
  80098b:	e8 f8 21 00 00       	call   802b88 <malloc>
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
  8009ec:	68 10 4e 80 00       	push   $0x804e10
  8009f1:	68 a3 00 00 00       	push   $0xa3
  8009f6:	68 fc 4d 80 00       	push   $0x804dfc
  8009fb:	e8 4c 0f 00 00       	call   80194c <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a00:	e8 40 26 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  800a05:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800a08:	74 17                	je     800a21 <_main+0x9e9>
  800a0a:	83 ec 04             	sub    $0x4,%esp
  800a0d:	68 78 4e 80 00       	push   $0x804e78
  800a12:	68 a4 00 00 00       	push   $0xa4
  800a17:	68 fc 4d 80 00       	push   $0x804dfc
  800a1c:	e8 2b 0f 00 00       	call   80194c <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a21:	e8 7f 25 00 00       	call   802fa5 <sys_calculate_free_frames>
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
  800a92:	e8 0e 25 00 00       	call   802fa5 <sys_calculate_free_frames>
  800a97:	29 c3                	sub    %eax,%ebx
  800a99:	89 d8                	mov    %ebx,%eax
  800a9b:	83 f8 05             	cmp    $0x5,%eax
  800a9e:	74 17                	je     800ab7 <_main+0xa7f>
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 a8 4e 80 00       	push   $0x804ea8
  800aa8:	68 ac 00 00 00       	push   $0xac
  800aad:	68 fc 4d 80 00       	push   $0x804dfc
  800ab2:	e8 95 0e 00 00       	call   80194c <_panic>
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
  800be8:	68 ec 4e 80 00       	push   $0x804eec
  800bed:	68 b7 00 00 00       	push   $0xb7
  800bf2:	68 fc 4d 80 00       	push   $0x804dfc
  800bf7:	e8 50 0d 00 00       	call   80194c <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfc:	e8 44 24 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
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
  800c17:	e8 6c 1f 00 00       	call   802b88 <malloc>
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
  800c7a:	68 10 4e 80 00       	push   $0x804e10
  800c7f:	68 bc 00 00 00       	push   $0xbc
  800c84:	68 fc 4d 80 00       	push   $0x804dfc
  800c89:	e8 be 0c 00 00       	call   80194c <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c8e:	e8 b2 23 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  800c93:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800c96:	74 17                	je     800caf <_main+0xc77>
  800c98:	83 ec 04             	sub    $0x4,%esp
  800c9b:	68 78 4e 80 00       	push   $0x804e78
  800ca0:	68 bd 00 00 00       	push   $0xbd
  800ca5:	68 fc 4d 80 00       	push   $0x804dfc
  800caa:	e8 9d 0c 00 00       	call   80194c <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800caf:	e8 f1 22 00 00       	call   802fa5 <sys_calculate_free_frames>
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
  800d03:	e8 9d 22 00 00       	call   802fa5 <sys_calculate_free_frames>
  800d08:	29 c3                	sub    %eax,%ebx
  800d0a:	89 d8                	mov    %ebx,%eax
  800d0c:	83 f8 02             	cmp    $0x2,%eax
  800d0f:	74 17                	je     800d28 <_main+0xcf0>
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	68 a8 4e 80 00       	push   $0x804ea8
  800d19:	68 c4 00 00 00       	push   $0xc4
  800d1e:	68 fc 4d 80 00       	push   $0x804dfc
  800d23:	e8 24 0c 00 00       	call   80194c <_panic>
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
  800dfe:	68 ec 4e 80 00       	push   $0x804eec
  800e03:	68 cd 00 00 00       	push   $0xcd
  800e08:	68 fc 4d 80 00       	push   $0x804dfc
  800e0d:	e8 3a 0b 00 00       	call   80194c <_panic>
	}

	{
		//Free 1st 2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800e12:	e8 8e 21 00 00       	call   802fa5 <sys_calculate_free_frames>
  800e17:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e1d:	e8 23 22 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  800e22:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[0]);
  800e28:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	e8 cc 1d 00 00       	call   802c03 <free>
  800e37:	83 c4 10             	add    $0x10,%esp

		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e3a:	e8 06 22 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  800e3f:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800e45:	74 17                	je     800e5e <_main+0xe26>
  800e47:	83 ec 04             	sub    $0x4,%esp
  800e4a:	68 0c 4f 80 00       	push   $0x804f0c
  800e4f:	68 d6 00 00 00       	push   $0xd6
  800e54:	68 fc 4d 80 00       	push   $0x804dfc
  800e59:	e8 ee 0a 00 00       	call   80194c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800e5e:	e8 42 21 00 00       	call   802fa5 <sys_calculate_free_frames>
  800e63:	89 c2                	mov    %eax,%edx
  800e65:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800e6b:	29 c2                	sub    %eax,%edx
  800e6d:	89 d0                	mov    %edx,%eax
  800e6f:	83 f8 02             	cmp    $0x2,%eax
  800e72:	74 17                	je     800e8b <_main+0xe53>
  800e74:	83 ec 04             	sub    $0x4,%esp
  800e77:	68 48 4f 80 00       	push   $0x804f48
  800e7c:	68 d7 00 00 00       	push   $0xd7
  800e81:	68 fc 4d 80 00       	push   $0x804dfc
  800e86:	e8 c1 0a 00 00       	call   80194c <_panic>
		int var;
		//int count = 1;
		//cprintf("Env size: %d\n",myEnv->page_WS_max_size);
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800e8b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800e92:	e9 c2 00 00 00       	jmp    800f59 <_main+0xf21>
		{
			//cprintf("%d\n",count);
			//count++;
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
  800ee0:	68 94 4f 80 00       	push   $0x804f94
  800ee5:	68 e0 00 00 00       	push   $0xe0
  800eea:	68 fc 4d 80 00       	push   $0x804dfc
  800eef:	e8 58 0a 00 00       	call   80194c <_panic>
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
  800f42:	68 94 4f 80 00       	push   $0x804f94
  800f47:	68 e2 00 00 00       	push   $0xe2
  800f4c:	68 fc 4d 80 00       	push   $0x804dfc
  800f51:	e8 f6 09 00 00       	call   80194c <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		int var;
		//int count = 1;
		//cprintf("Env size: %d\n",myEnv->page_WS_max_size);
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800f56:	ff 45 e4             	incl   -0x1c(%ebp)
  800f59:	a1 20 60 80 00       	mov    0x806020,%eax
  800f5e:	8b 50 74             	mov    0x74(%eax),%edx
  800f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f64:	39 c2                	cmp    %eax,%edx
  800f66:	0f 87 2b ff ff ff    	ja     800e97 <_main+0xe5f>
				panic("free: page is not removed from WS");
		}
		//cprintf("Done first test case\n");

		//Free 2nd 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800f6c:	e8 34 20 00 00       	call   802fa5 <sys_calculate_free_frames>
  800f71:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f77:	e8 c9 20 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  800f7c:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[1]);
  800f82:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800f88:	83 ec 0c             	sub    $0xc,%esp
  800f8b:	50                   	push   %eax
  800f8c:	e8 72 1c 00 00       	call   802c03 <free>
  800f91:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f94:	e8 ac 20 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  800f99:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800f9f:	74 17                	je     800fb8 <_main+0xf80>
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	68 0c 4f 80 00       	push   $0x804f0c
  800fa9:	68 ea 00 00 00       	push   $0xea
  800fae:	68 fc 4d 80 00       	push   $0x804dfc
  800fb3:	e8 94 09 00 00       	call   80194c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1){
  800fb8:	e8 e8 1f 00 00       	call   802fa5 <sys_calculate_free_frames>
  800fbd:	89 c2                	mov    %eax,%edx
  800fbf:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800fc5:	29 c2                	sub    %eax,%edx
  800fc7:	89 d0                	mov    %edx,%eax
  800fc9:	83 f8 03             	cmp    $0x3,%eax
  800fcc:	74 39                	je     801007 <_main+0xfcf>
			cprintf("%d\n",(sys_calculate_free_frames() - freeFrames));
  800fce:	e8 d2 1f 00 00       	call   802fa5 <sys_calculate_free_frames>
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800fdb:	29 c2                	sub    %eax,%edx
  800fdd:	89 d0                	mov    %edx,%eax
  800fdf:	83 ec 08             	sub    $0x8,%esp
  800fe2:	50                   	push   %eax
  800fe3:	68 b6 4f 80 00       	push   $0x804fb6
  800fe8:	e8 13 0c 00 00       	call   801c00 <cprintf>
  800fed:	83 c4 10             	add    $0x10,%esp
			panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800ff0:	83 ec 04             	sub    $0x4,%esp
  800ff3:	68 48 4f 80 00       	push   $0x804f48
  800ff8:	68 ed 00 00 00       	push   $0xed
  800ffd:	68 fc 4d 80 00       	push   $0x804dfc
  801002:	e8 45 09 00 00       	call   80194c <_panic>
		}
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801007:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80100e:	e9 c6 00 00 00       	jmp    8010d9 <_main+0x10a1>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  801013:	a1 20 60 80 00       	mov    0x806020,%eax
  801018:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80101e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801021:	89 d0                	mov    %edx,%eax
  801023:	01 c0                	add    %eax,%eax
  801025:	01 d0                	add    %edx,%eax
  801027:	c1 e0 03             	shl    $0x3,%eax
  80102a:	01 c8                	add    %ecx,%eax
  80102c:	8b 00                	mov    (%eax),%eax
  80102e:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
  801034:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  80103a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80103f:	89 c2                	mov    %eax,%edx
  801041:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801044:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  80104a:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  801050:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801055:	39 c2                	cmp    %eax,%edx
  801057:	75 17                	jne    801070 <_main+0x1038>
				panic("free: page is not removed from WS");
  801059:	83 ec 04             	sub    $0x4,%esp
  80105c:	68 94 4f 80 00       	push   $0x804f94
  801061:	68 f2 00 00 00       	push   $0xf2
  801066:	68 fc 4d 80 00       	push   $0x804dfc
  80106b:	e8 dc 08 00 00       	call   80194c <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  801070:	a1 20 60 80 00       	mov    0x806020,%eax
  801075:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80107b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80107e:	89 d0                	mov    %edx,%eax
  801080:	01 c0                	add    %eax,%eax
  801082:	01 d0                	add    %edx,%eax
  801084:	c1 e0 03             	shl    $0x3,%eax
  801087:	01 c8                	add    %ecx,%eax
  801089:	8b 00                	mov    (%eax),%eax
  80108b:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  801091:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  801097:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80109c:	89 c2                	mov    %eax,%edx
  80109e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8010a1:	01 c0                	add    %eax,%eax
  8010a3:	89 c1                	mov    %eax,%ecx
  8010a5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8010a8:	01 c8                	add    %ecx,%eax
  8010aa:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  8010b0:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  8010b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010bb:	39 c2                	cmp    %eax,%edx
  8010bd:	75 17                	jne    8010d6 <_main+0x109e>
				panic("free: page is not removed from WS");
  8010bf:	83 ec 04             	sub    $0x4,%esp
  8010c2:	68 94 4f 80 00       	push   $0x804f94
  8010c7:	68 f4 00 00 00       	push   $0xf4
  8010cc:	68 fc 4d 80 00       	push   $0x804dfc
  8010d1:	e8 76 08 00 00       	call   80194c <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1){
			cprintf("%d\n",(sys_calculate_free_frames() - freeFrames));
			panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		}
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8010d6:	ff 45 e4             	incl   -0x1c(%ebp)
  8010d9:	a1 20 60 80 00       	mov    0x806020,%eax
  8010de:	8b 50 74             	mov    0x74(%eax),%edx
  8010e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010e4:	39 c2                	cmp    %eax,%edx
  8010e6:	0f 87 27 ff ff ff    	ja     801013 <_main+0xfdb>
				panic("free: page is not removed from WS");
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}
		//Free 6 MB
		freeFrames = sys_calculate_free_frames() ;
  8010ec:	e8 b4 1e 00 00       	call   802fa5 <sys_calculate_free_frames>
  8010f1:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8010f7:	e8 49 1f 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  8010fc:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[6]);
  801102:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  801108:	83 ec 0c             	sub    $0xc,%esp
  80110b:	50                   	push   %eax
  80110c:	e8 f2 1a 00 00       	call   802c03 <free>
  801111:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801114:	e8 2c 1f 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  801119:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  80111f:	74 17                	je     801138 <_main+0x1100>
  801121:	83 ec 04             	sub    $0x4,%esp
  801124:	68 0c 4f 80 00       	push   $0x804f0c
  801129:	68 fa 00 00 00       	push   $0xfa
  80112e:	68 fc 4d 80 00       	push   $0x804dfc
  801133:	e8 14 08 00 00       	call   80194c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801138:	e8 68 1e 00 00       	call   802fa5 <sys_calculate_free_frames>
  80113d:	89 c2                	mov    %eax,%edx
  80113f:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801145:	29 c2                	sub    %eax,%edx
  801147:	89 d0                	mov    %edx,%eax
  801149:	83 f8 04             	cmp    $0x4,%eax
  80114c:	74 17                	je     801165 <_main+0x112d>
  80114e:	83 ec 04             	sub    $0x4,%esp
  801151:	68 48 4f 80 00       	push   $0x804f48
  801156:	68 fb 00 00 00       	push   $0xfb
  80115b:	68 fc 4d 80 00       	push   $0x804dfc
  801160:	e8 e7 07 00 00       	call   80194c <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801165:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80116c:	e9 3e 01 00 00       	jmp    8012af <_main+0x1277>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  801171:	a1 20 60 80 00       	mov    0x806020,%eax
  801176:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80117c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80117f:	89 d0                	mov    %edx,%eax
  801181:	01 c0                	add    %eax,%eax
  801183:	01 d0                	add    %edx,%eax
  801185:	c1 e0 03             	shl    $0x3,%eax
  801188:	01 c8                	add    %ecx,%eax
  80118a:	8b 00                	mov    (%eax),%eax
  80118c:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  801192:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  801198:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80119d:	89 c2                	mov    %eax,%edx
  80119f:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8011a5:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
  8011ab:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  8011b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011b6:	39 c2                	cmp    %eax,%edx
  8011b8:	75 17                	jne    8011d1 <_main+0x1199>
				panic("free: page is not removed from WS");
  8011ba:	83 ec 04             	sub    $0x4,%esp
  8011bd:	68 94 4f 80 00       	push   $0x804f94
  8011c2:	68 ff 00 00 00       	push   $0xff
  8011c7:	68 fc 4d 80 00       	push   $0x804dfc
  8011cc:	e8 7b 07 00 00       	call   80194c <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  8011d1:	a1 20 60 80 00       	mov    0x806020,%eax
  8011d6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8011dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011df:	89 d0                	mov    %edx,%eax
  8011e1:	01 c0                	add    %eax,%eax
  8011e3:	01 d0                	add    %edx,%eax
  8011e5:	c1 e0 03             	shl    $0x3,%eax
  8011e8:	01 c8                	add    %ecx,%eax
  8011ea:	8b 00                	mov    (%eax),%eax
  8011ec:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  8011f2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011fd:	89 c2                	mov    %eax,%edx
  8011ff:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801205:	89 c1                	mov    %eax,%ecx
  801207:	c1 e9 1f             	shr    $0x1f,%ecx
  80120a:	01 c8                	add    %ecx,%eax
  80120c:	d1 f8                	sar    %eax
  80120e:	89 c1                	mov    %eax,%ecx
  801210:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801216:	01 c8                	add    %ecx,%eax
  801218:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  80121e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801224:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801229:	39 c2                	cmp    %eax,%edx
  80122b:	75 17                	jne    801244 <_main+0x120c>
				panic("free: page is not removed from WS");
  80122d:	83 ec 04             	sub    $0x4,%esp
  801230:	68 94 4f 80 00       	push   $0x804f94
  801235:	68 01 01 00 00       	push   $0x101
  80123a:	68 fc 4d 80 00       	push   $0x804dfc
  80123f:	e8 08 07 00 00       	call   80194c <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  801244:	a1 20 60 80 00       	mov    0x806020,%eax
  801249:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80124f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801252:	89 d0                	mov    %edx,%eax
  801254:	01 c0                	add    %eax,%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	c1 e0 03             	shl    $0x3,%eax
  80125b:	01 c8                	add    %ecx,%eax
  80125d:	8b 00                	mov    (%eax),%eax
  80125f:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  801265:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  80126b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801270:	89 c1                	mov    %eax,%ecx
  801272:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  801278:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80127e:	01 d0                	add    %edx,%eax
  801280:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
  801286:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  80128c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801291:	39 c1                	cmp    %eax,%ecx
  801293:	75 17                	jne    8012ac <_main+0x1274>
				panic("free: page is not removed from WS");
  801295:	83 ec 04             	sub    $0x4,%esp
  801298:	68 94 4f 80 00       	push   $0x804f94
  80129d:	68 03 01 00 00       	push   $0x103
  8012a2:	68 fc 4d 80 00       	push   $0x804dfc
  8012a7:	e8 a0 06 00 00       	call   80194c <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[6]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8012ac:	ff 45 e4             	incl   -0x1c(%ebp)
  8012af:	a1 20 60 80 00       	mov    0x806020,%eax
  8012b4:	8b 50 74             	mov    0x74(%eax),%edx
  8012b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012ba:	39 c2                	cmp    %eax,%edx
  8012bc:	0f 87 af fe ff ff    	ja     801171 <_main+0x1139>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 7 KB
		freeFrames = sys_calculate_free_frames() ;
  8012c2:	e8 de 1c 00 00       	call   802fa5 <sys_calculate_free_frames>
  8012c7:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012cd:	e8 73 1d 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  8012d2:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[4]);
  8012d8:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8012de:	83 ec 0c             	sub    $0xc,%esp
  8012e1:	50                   	push   %eax
  8012e2:	e8 1c 19 00 00       	call   802c03 <free>
  8012e7:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8012ea:	e8 56 1d 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  8012ef:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8012f5:	74 17                	je     80130e <_main+0x12d6>
  8012f7:	83 ec 04             	sub    $0x4,%esp
  8012fa:	68 0c 4f 80 00       	push   $0x804f0c
  8012ff:	68 0a 01 00 00       	push   $0x10a
  801304:	68 fc 4d 80 00       	push   $0x804dfc
  801309:	e8 3e 06 00 00       	call   80194c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80130e:	e8 92 1c 00 00       	call   802fa5 <sys_calculate_free_frames>
  801313:	89 c2                	mov    %eax,%edx
  801315:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80131b:	29 c2                	sub    %eax,%edx
  80131d:	89 d0                	mov    %edx,%eax
  80131f:	83 f8 02             	cmp    $0x2,%eax
  801322:	74 17                	je     80133b <_main+0x1303>
  801324:	83 ec 04             	sub    $0x4,%esp
  801327:	68 48 4f 80 00       	push   $0x804f48
  80132c:	68 0b 01 00 00       	push   $0x10b
  801331:	68 fc 4d 80 00       	push   $0x804dfc
  801336:	e8 11 06 00 00       	call   80194c <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80133b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801342:	e9 d2 00 00 00       	jmp    801419 <_main+0x13e1>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  801347:	a1 20 60 80 00       	mov    0x806020,%eax
  80134c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801352:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801355:	89 d0                	mov    %edx,%eax
  801357:	01 c0                	add    %eax,%eax
  801359:	01 d0                	add    %edx,%eax
  80135b:	c1 e0 03             	shl    $0x3,%eax
  80135e:	01 c8                	add    %ecx,%eax
  801360:	8b 00                	mov    (%eax),%eax
  801362:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  801368:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80136e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801373:	89 c2                	mov    %eax,%edx
  801375:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80137b:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
  801381:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  801387:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80138c:	39 c2                	cmp    %eax,%edx
  80138e:	75 17                	jne    8013a7 <_main+0x136f>
				panic("free: page is not removed from WS");
  801390:	83 ec 04             	sub    $0x4,%esp
  801393:	68 94 4f 80 00       	push   $0x804f94
  801398:	68 0f 01 00 00       	push   $0x10f
  80139d:	68 fc 4d 80 00       	push   $0x804dfc
  8013a2:	e8 a5 05 00 00       	call   80194c <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  8013a7:	a1 20 60 80 00       	mov    0x806020,%eax
  8013ac:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8013b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013b5:	89 d0                	mov    %edx,%eax
  8013b7:	01 c0                	add    %eax,%eax
  8013b9:	01 d0                	add    %edx,%eax
  8013bb:	c1 e0 03             	shl    $0x3,%eax
  8013be:	01 c8                	add    %ecx,%eax
  8013c0:	8b 00                	mov    (%eax),%eax
  8013c2:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
  8013c8:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  8013ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d3:	89 c2                	mov    %eax,%edx
  8013d5:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8013db:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8013e2:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8013e8:	01 c8                	add    %ecx,%eax
  8013ea:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  8013f0:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  8013f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013fb:	39 c2                	cmp    %eax,%edx
  8013fd:	75 17                	jne    801416 <_main+0x13de>
				panic("free: page is not removed from WS");
  8013ff:	83 ec 04             	sub    $0x4,%esp
  801402:	68 94 4f 80 00       	push   $0x804f94
  801407:	68 11 01 00 00       	push   $0x111
  80140c:	68 fc 4d 80 00       	push   $0x804dfc
  801411:	e8 36 05 00 00       	call   80194c <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[4]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801416:	ff 45 e4             	incl   -0x1c(%ebp)
  801419:	a1 20 60 80 00       	mov    0x806020,%eax
  80141e:	8b 50 74             	mov    0x74(%eax),%edx
  801421:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801424:	39 c2                	cmp    %eax,%edx
  801426:	0f 87 1b ff ff ff    	ja     801347 <_main+0x130f>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80142c:	e8 74 1b 00 00       	call   802fa5 <sys_calculate_free_frames>
  801431:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801437:	e8 09 1c 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  80143c:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[5]);
  801442:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  801448:	83 ec 0c             	sub    $0xc,%esp
  80144b:	50                   	push   %eax
  80144c:	e8 b2 17 00 00       	call   802c03 <free>
  801451:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801454:	e8 ec 1b 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  801459:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  80145f:	74 17                	je     801478 <_main+0x1440>
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	68 0c 4f 80 00       	push   $0x804f0c
  801469:	68 18 01 00 00       	push   $0x118
  80146e:	68 fc 4d 80 00       	push   $0x804dfc
  801473:	e8 d4 04 00 00       	call   80194c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801478:	e8 28 1b 00 00       	call   802fa5 <sys_calculate_free_frames>
  80147d:	89 c2                	mov    %eax,%edx
  80147f:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801485:	39 c2                	cmp    %eax,%edx
  801487:	74 17                	je     8014a0 <_main+0x1468>
  801489:	83 ec 04             	sub    $0x4,%esp
  80148c:	68 48 4f 80 00       	push   $0x804f48
  801491:	68 19 01 00 00       	push   $0x119
  801496:	68 fc 4d 80 00       	push   $0x804dfc
  80149b:	e8 ac 04 00 00       	call   80194c <_panic>

		//Free 1st 2 KB
		freeFrames = sys_calculate_free_frames() ;
  8014a0:	e8 00 1b 00 00       	call   802fa5 <sys_calculate_free_frames>
  8014a5:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8014ab:	e8 95 1b 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  8014b0:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[2]);
  8014b6:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  8014bc:	83 ec 0c             	sub    $0xc,%esp
  8014bf:	50                   	push   %eax
  8014c0:	e8 3e 17 00 00       	call   802c03 <free>
  8014c5:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8014c8:	e8 78 1b 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  8014cd:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8014d3:	74 17                	je     8014ec <_main+0x14b4>
  8014d5:	83 ec 04             	sub    $0x4,%esp
  8014d8:	68 0c 4f 80 00       	push   $0x804f0c
  8014dd:	68 1f 01 00 00       	push   $0x11f
  8014e2:	68 fc 4d 80 00       	push   $0x804dfc
  8014e7:	e8 60 04 00 00       	call   80194c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8014ec:	e8 b4 1a 00 00       	call   802fa5 <sys_calculate_free_frames>
  8014f1:	89 c2                	mov    %eax,%edx
  8014f3:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8014f9:	29 c2                	sub    %eax,%edx
  8014fb:	89 d0                	mov    %edx,%eax
  8014fd:	83 f8 02             	cmp    $0x2,%eax
  801500:	74 17                	je     801519 <_main+0x14e1>
  801502:	83 ec 04             	sub    $0x4,%esp
  801505:	68 48 4f 80 00       	push   $0x804f48
  80150a:	68 20 01 00 00       	push   $0x120
  80150f:	68 fc 4d 80 00       	push   $0x804dfc
  801514:	e8 33 04 00 00       	call   80194c <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801519:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801520:	e9 c9 00 00 00       	jmp    8015ee <_main+0x15b6>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  801525:	a1 20 60 80 00       	mov    0x806020,%eax
  80152a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801530:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801533:	89 d0                	mov    %edx,%eax
  801535:	01 c0                	add    %eax,%eax
  801537:	01 d0                	add    %edx,%eax
  801539:	c1 e0 03             	shl    $0x3,%eax
  80153c:	01 c8                	add    %ecx,%eax
  80153e:	8b 00                	mov    (%eax),%eax
  801540:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
  801546:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  80154c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801551:	89 c2                	mov    %eax,%edx
  801553:	8b 45 8c             	mov    -0x74(%ebp),%eax
  801556:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
  80155c:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  801562:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801567:	39 c2                	cmp    %eax,%edx
  801569:	75 17                	jne    801582 <_main+0x154a>
				panic("free: page is not removed from WS");
  80156b:	83 ec 04             	sub    $0x4,%esp
  80156e:	68 94 4f 80 00       	push   $0x804f94
  801573:	68 24 01 00 00       	push   $0x124
  801578:	68 fc 4d 80 00       	push   $0x804dfc
  80157d:	e8 ca 03 00 00       	call   80194c <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  801582:	a1 20 60 80 00       	mov    0x806020,%eax
  801587:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80158d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801590:	89 d0                	mov    %edx,%eax
  801592:	01 c0                	add    %eax,%eax
  801594:	01 d0                	add    %edx,%eax
  801596:	c1 e0 03             	shl    $0x3,%eax
  801599:	01 c8                	add    %ecx,%eax
  80159b:	8b 00                	mov    (%eax),%eax
  80159d:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
  8015a3:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  8015a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015ae:	89 c2                	mov    %eax,%edx
  8015b0:	8b 45 88             	mov    -0x78(%ebp),%eax
  8015b3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8015ba:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8015bd:	01 c8                	add    %ecx,%eax
  8015bf:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
  8015c5:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8015cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015d0:	39 c2                	cmp    %eax,%edx
  8015d2:	75 17                	jne    8015eb <_main+0x15b3>
				panic("free: page is not removed from WS");
  8015d4:	83 ec 04             	sub    $0x4,%esp
  8015d7:	68 94 4f 80 00       	push   $0x804f94
  8015dc:	68 26 01 00 00       	push   $0x126
  8015e1:	68 fc 4d 80 00       	push   $0x804dfc
  8015e6:	e8 61 03 00 00       	call   80194c <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[2]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8015eb:	ff 45 e4             	incl   -0x1c(%ebp)
  8015ee:	a1 20 60 80 00       	mov    0x806020,%eax
  8015f3:	8b 50 74             	mov    0x74(%eax),%edx
  8015f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015f9:	39 c2                	cmp    %eax,%edx
  8015fb:	0f 87 24 ff ff ff    	ja     801525 <_main+0x14ed>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 2nd 2 KB
		freeFrames = sys_calculate_free_frames() ;
  801601:	e8 9f 19 00 00       	call   802fa5 <sys_calculate_free_frames>
  801606:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80160c:	e8 34 1a 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  801611:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[3]);
  801617:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  80161d:	83 ec 0c             	sub    $0xc,%esp
  801620:	50                   	push   %eax
  801621:	e8 dd 15 00 00       	call   802c03 <free>
  801626:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801629:	e8 17 1a 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  80162e:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801634:	74 17                	je     80164d <_main+0x1615>
  801636:	83 ec 04             	sub    $0x4,%esp
  801639:	68 0c 4f 80 00       	push   $0x804f0c
  80163e:	68 2d 01 00 00       	push   $0x12d
  801643:	68 fc 4d 80 00       	push   $0x804dfc
  801648:	e8 ff 02 00 00       	call   80194c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80164d:	e8 53 19 00 00       	call   802fa5 <sys_calculate_free_frames>
  801652:	89 c2                	mov    %eax,%edx
  801654:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80165a:	39 c2                	cmp    %eax,%edx
  80165c:	74 17                	je     801675 <_main+0x163d>
  80165e:	83 ec 04             	sub    $0x4,%esp
  801661:	68 48 4f 80 00       	push   $0x804f48
  801666:	68 2e 01 00 00       	push   $0x12e
  80166b:	68 fc 4d 80 00       	push   $0x804dfc
  801670:	e8 d7 02 00 00       	call   80194c <_panic>


		//Free last 14 KB
		freeFrames = sys_calculate_free_frames() ;
  801675:	e8 2b 19 00 00       	call   802fa5 <sys_calculate_free_frames>
  80167a:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801680:	e8 c0 19 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  801685:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[7]);
  80168b:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  801691:	83 ec 0c             	sub    $0xc,%esp
  801694:	50                   	push   %eax
  801695:	e8 69 15 00 00       	call   802c03 <free>
  80169a:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80169d:	e8 a3 19 00 00       	call   803045 <sys_pf_calculate_allocated_pages>
  8016a2:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8016a8:	74 17                	je     8016c1 <_main+0x1689>
  8016aa:	83 ec 04             	sub    $0x4,%esp
  8016ad:	68 0c 4f 80 00       	push   $0x804f0c
  8016b2:	68 35 01 00 00       	push   $0x135
  8016b7:	68 fc 4d 80 00       	push   $0x804dfc
  8016bc:	e8 8b 02 00 00       	call   80194c <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8016c1:	e8 df 18 00 00       	call   802fa5 <sys_calculate_free_frames>
  8016c6:	89 c2                	mov    %eax,%edx
  8016c8:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8016ce:	29 c2                	sub    %eax,%edx
  8016d0:	89 d0                	mov    %edx,%eax
  8016d2:	83 f8 03             	cmp    $0x3,%eax
  8016d5:	74 17                	je     8016ee <_main+0x16b6>
  8016d7:	83 ec 04             	sub    $0x4,%esp
  8016da:	68 48 4f 80 00       	push   $0x804f48
  8016df:	68 36 01 00 00       	push   $0x136
  8016e4:	68 fc 4d 80 00       	push   $0x804dfc
  8016e9:	e8 5e 02 00 00       	call   80194c <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8016ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8016f5:	e9 c6 00 00 00       	jmp    8017c0 <_main+0x1788>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  8016fa:	a1 20 60 80 00       	mov    0x806020,%eax
  8016ff:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801705:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801708:	89 d0                	mov    %edx,%eax
  80170a:	01 c0                	add    %eax,%eax
  80170c:	01 d0                	add    %edx,%eax
  80170e:	c1 e0 03             	shl    $0x3,%eax
  801711:	01 c8                	add    %ecx,%eax
  801713:	8b 00                	mov    (%eax),%eax
  801715:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
  80171b:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  801721:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801726:	89 c2                	mov    %eax,%edx
  801728:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80172b:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
  801731:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  801737:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80173c:	39 c2                	cmp    %eax,%edx
  80173e:	75 17                	jne    801757 <_main+0x171f>
				panic("free: page is not removed from WS");
  801740:	83 ec 04             	sub    $0x4,%esp
  801743:	68 94 4f 80 00       	push   $0x804f94
  801748:	68 3a 01 00 00       	push   $0x13a
  80174d:	68 fc 4d 80 00       	push   $0x804dfc
  801752:	e8 f5 01 00 00       	call   80194c <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  801757:	a1 20 60 80 00       	mov    0x806020,%eax
  80175c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801762:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801765:	89 d0                	mov    %edx,%eax
  801767:	01 c0                	add    %eax,%eax
  801769:	01 d0                	add    %edx,%eax
  80176b:	c1 e0 03             	shl    $0x3,%eax
  80176e:	01 c8                	add    %ecx,%eax
  801770:	8b 00                	mov    (%eax),%eax
  801772:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
  801778:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  80177e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801783:	89 c2                	mov    %eax,%edx
  801785:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801788:	01 c0                	add    %eax,%eax
  80178a:	89 c1                	mov    %eax,%ecx
  80178c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80178f:	01 c8                	add    %ecx,%eax
  801791:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
  801797:	8b 85 b8 fe ff ff    	mov    -0x148(%ebp),%eax
  80179d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017a2:	39 c2                	cmp    %eax,%edx
  8017a4:	75 17                	jne    8017bd <_main+0x1785>
				panic("free: page is not removed from WS");
  8017a6:	83 ec 04             	sub    $0x4,%esp
  8017a9:	68 94 4f 80 00       	push   $0x804f94
  8017ae:	68 3c 01 00 00       	push   $0x13c
  8017b3:	68 fc 4d 80 00       	push   $0x804dfc
  8017b8:	e8 8f 01 00 00       	call   80194c <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[7]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8017bd:	ff 45 e4             	incl   -0x1c(%ebp)
  8017c0:	a1 20 60 80 00       	mov    0x806020,%eax
  8017c5:	8b 50 74             	mov    0x74(%eax),%edx
  8017c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017cb:	39 c2                	cmp    %eax,%edx
  8017cd:	0f 87 27 ff ff ff    	ja     8016fa <_main+0x16c2>
				panic("free: page is not removed from WS");
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		if(start_freeFrames != (sys_calculate_free_frames())) {panic("Wrong free: not all pages removed correctly at end");}
  8017d3:	e8 cd 17 00 00       	call   802fa5 <sys_calculate_free_frames>
  8017d8:	89 c2                	mov    %eax,%edx
  8017da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017dd:	39 c2                	cmp    %eax,%edx
  8017df:	74 17                	je     8017f8 <_main+0x17c0>
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	68 bc 4f 80 00       	push   $0x804fbc
  8017e9:	68 3f 01 00 00       	push   $0x13f
  8017ee:	68 fc 4d 80 00       	push   $0x804dfc
  8017f3:	e8 54 01 00 00       	call   80194c <_panic>
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
  8017f8:	83 ec 0c             	sub    $0xc,%esp
  8017fb:	68 f0 4f 80 00       	push   $0x804ff0
  801800:	e8 fb 03 00 00       	call   801c00 <cprintf>
  801805:	83 c4 10             	add    $0x10,%esp

	return;
  801808:	90                   	nop
}
  801809:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80180c:	5b                   	pop    %ebx
  80180d:	5f                   	pop    %edi
  80180e:	5d                   	pop    %ebp
  80180f:	c3                   	ret    

00801810 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801816:	e8 6a 1a 00 00       	call   803285 <sys_getenvindex>
  80181b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80181e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801821:	89 d0                	mov    %edx,%eax
  801823:	c1 e0 03             	shl    $0x3,%eax
  801826:	01 d0                	add    %edx,%eax
  801828:	01 c0                	add    %eax,%eax
  80182a:	01 d0                	add    %edx,%eax
  80182c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801833:	01 d0                	add    %edx,%eax
  801835:	c1 e0 04             	shl    $0x4,%eax
  801838:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80183d:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801842:	a1 20 60 80 00       	mov    0x806020,%eax
  801847:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80184d:	84 c0                	test   %al,%al
  80184f:	74 0f                	je     801860 <libmain+0x50>
		binaryname = myEnv->prog_name;
  801851:	a1 20 60 80 00       	mov    0x806020,%eax
  801856:	05 5c 05 00 00       	add    $0x55c,%eax
  80185b:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801860:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801864:	7e 0a                	jle    801870 <libmain+0x60>
		binaryname = argv[0];
  801866:	8b 45 0c             	mov    0xc(%ebp),%eax
  801869:	8b 00                	mov    (%eax),%eax
  80186b:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  801870:	83 ec 08             	sub    $0x8,%esp
  801873:	ff 75 0c             	pushl  0xc(%ebp)
  801876:	ff 75 08             	pushl  0x8(%ebp)
  801879:	e8 ba e7 ff ff       	call   800038 <_main>
  80187e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  801881:	e8 0c 18 00 00       	call   803092 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801886:	83 ec 0c             	sub    $0xc,%esp
  801889:	68 44 50 80 00       	push   $0x805044
  80188e:	e8 6d 03 00 00       	call   801c00 <cprintf>
  801893:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801896:	a1 20 60 80 00       	mov    0x806020,%eax
  80189b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8018a1:	a1 20 60 80 00       	mov    0x806020,%eax
  8018a6:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8018ac:	83 ec 04             	sub    $0x4,%esp
  8018af:	52                   	push   %edx
  8018b0:	50                   	push   %eax
  8018b1:	68 6c 50 80 00       	push   $0x80506c
  8018b6:	e8 45 03 00 00       	call   801c00 <cprintf>
  8018bb:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8018be:	a1 20 60 80 00       	mov    0x806020,%eax
  8018c3:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8018c9:	a1 20 60 80 00       	mov    0x806020,%eax
  8018ce:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8018d4:	a1 20 60 80 00       	mov    0x806020,%eax
  8018d9:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8018df:	51                   	push   %ecx
  8018e0:	52                   	push   %edx
  8018e1:	50                   	push   %eax
  8018e2:	68 94 50 80 00       	push   $0x805094
  8018e7:	e8 14 03 00 00       	call   801c00 <cprintf>
  8018ec:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8018ef:	a1 20 60 80 00       	mov    0x806020,%eax
  8018f4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8018fa:	83 ec 08             	sub    $0x8,%esp
  8018fd:	50                   	push   %eax
  8018fe:	68 ec 50 80 00       	push   $0x8050ec
  801903:	e8 f8 02 00 00       	call   801c00 <cprintf>
  801908:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80190b:	83 ec 0c             	sub    $0xc,%esp
  80190e:	68 44 50 80 00       	push   $0x805044
  801913:	e8 e8 02 00 00       	call   801c00 <cprintf>
  801918:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80191b:	e8 8c 17 00 00       	call   8030ac <sys_enable_interrupt>

	// exit gracefully
	exit();
  801920:	e8 19 00 00 00       	call   80193e <exit>
}
  801925:	90                   	nop
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80192e:	83 ec 0c             	sub    $0xc,%esp
  801931:	6a 00                	push   $0x0
  801933:	e8 19 19 00 00       	call   803251 <sys_destroy_env>
  801938:	83 c4 10             	add    $0x10,%esp
}
  80193b:	90                   	nop
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <exit>:

void
exit(void)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801944:	e8 6e 19 00 00       	call   8032b7 <sys_exit_env>
}
  801949:	90                   	nop
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801952:	8d 45 10             	lea    0x10(%ebp),%eax
  801955:	83 c0 04             	add    $0x4,%eax
  801958:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80195b:	a1 5c 61 80 00       	mov    0x80615c,%eax
  801960:	85 c0                	test   %eax,%eax
  801962:	74 16                	je     80197a <_panic+0x2e>
		cprintf("%s: ", argv0);
  801964:	a1 5c 61 80 00       	mov    0x80615c,%eax
  801969:	83 ec 08             	sub    $0x8,%esp
  80196c:	50                   	push   %eax
  80196d:	68 00 51 80 00       	push   $0x805100
  801972:	e8 89 02 00 00       	call   801c00 <cprintf>
  801977:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80197a:	a1 00 60 80 00       	mov    0x806000,%eax
  80197f:	ff 75 0c             	pushl  0xc(%ebp)
  801982:	ff 75 08             	pushl  0x8(%ebp)
  801985:	50                   	push   %eax
  801986:	68 05 51 80 00       	push   $0x805105
  80198b:	e8 70 02 00 00       	call   801c00 <cprintf>
  801990:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801993:	8b 45 10             	mov    0x10(%ebp),%eax
  801996:	83 ec 08             	sub    $0x8,%esp
  801999:	ff 75 f4             	pushl  -0xc(%ebp)
  80199c:	50                   	push   %eax
  80199d:	e8 f3 01 00 00       	call   801b95 <vcprintf>
  8019a2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8019a5:	83 ec 08             	sub    $0x8,%esp
  8019a8:	6a 00                	push   $0x0
  8019aa:	68 21 51 80 00       	push   $0x805121
  8019af:	e8 e1 01 00 00       	call   801b95 <vcprintf>
  8019b4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8019b7:	e8 82 ff ff ff       	call   80193e <exit>

	// should not return here
	while (1) ;
  8019bc:	eb fe                	jmp    8019bc <_panic+0x70>

008019be <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8019c4:	a1 20 60 80 00       	mov    0x806020,%eax
  8019c9:	8b 50 74             	mov    0x74(%eax),%edx
  8019cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cf:	39 c2                	cmp    %eax,%edx
  8019d1:	74 14                	je     8019e7 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	68 24 51 80 00       	push   $0x805124
  8019db:	6a 26                	push   $0x26
  8019dd:	68 70 51 80 00       	push   $0x805170
  8019e2:	e8 65 ff ff ff       	call   80194c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019f5:	e9 c2 00 00 00       	jmp    801abc <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8019fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	01 d0                	add    %edx,%eax
  801a09:	8b 00                	mov    (%eax),%eax
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	75 08                	jne    801a17 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801a0f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a12:	e9 a2 00 00 00       	jmp    801ab9 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801a17:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a1e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a25:	eb 69                	jmp    801a90 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a27:	a1 20 60 80 00       	mov    0x806020,%eax
  801a2c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801a32:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a35:	89 d0                	mov    %edx,%eax
  801a37:	01 c0                	add    %eax,%eax
  801a39:	01 d0                	add    %edx,%eax
  801a3b:	c1 e0 03             	shl    $0x3,%eax
  801a3e:	01 c8                	add    %ecx,%eax
  801a40:	8a 40 04             	mov    0x4(%eax),%al
  801a43:	84 c0                	test   %al,%al
  801a45:	75 46                	jne    801a8d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a47:	a1 20 60 80 00       	mov    0x806020,%eax
  801a4c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801a52:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a55:	89 d0                	mov    %edx,%eax
  801a57:	01 c0                	add    %eax,%eax
  801a59:	01 d0                	add    %edx,%eax
  801a5b:	c1 e0 03             	shl    $0x3,%eax
  801a5e:	01 c8                	add    %ecx,%eax
  801a60:	8b 00                	mov    (%eax),%eax
  801a62:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a6d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a72:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	01 c8                	add    %ecx,%eax
  801a7e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a80:	39 c2                	cmp    %eax,%edx
  801a82:	75 09                	jne    801a8d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801a84:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a8b:	eb 12                	jmp    801a9f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a8d:	ff 45 e8             	incl   -0x18(%ebp)
  801a90:	a1 20 60 80 00       	mov    0x806020,%eax
  801a95:	8b 50 74             	mov    0x74(%eax),%edx
  801a98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a9b:	39 c2                	cmp    %eax,%edx
  801a9d:	77 88                	ja     801a27 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801aa3:	75 14                	jne    801ab9 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801aa5:	83 ec 04             	sub    $0x4,%esp
  801aa8:	68 7c 51 80 00       	push   $0x80517c
  801aad:	6a 3a                	push   $0x3a
  801aaf:	68 70 51 80 00       	push   $0x805170
  801ab4:	e8 93 fe ff ff       	call   80194c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801ab9:	ff 45 f0             	incl   -0x10(%ebp)
  801abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ac2:	0f 8c 32 ff ff ff    	jl     8019fa <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801ac8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801acf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ad6:	eb 26                	jmp    801afe <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801ad8:	a1 20 60 80 00       	mov    0x806020,%eax
  801add:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801ae3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ae6:	89 d0                	mov    %edx,%eax
  801ae8:	01 c0                	add    %eax,%eax
  801aea:	01 d0                	add    %edx,%eax
  801aec:	c1 e0 03             	shl    $0x3,%eax
  801aef:	01 c8                	add    %ecx,%eax
  801af1:	8a 40 04             	mov    0x4(%eax),%al
  801af4:	3c 01                	cmp    $0x1,%al
  801af6:	75 03                	jne    801afb <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801af8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801afb:	ff 45 e0             	incl   -0x20(%ebp)
  801afe:	a1 20 60 80 00       	mov    0x806020,%eax
  801b03:	8b 50 74             	mov    0x74(%eax),%edx
  801b06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b09:	39 c2                	cmp    %eax,%edx
  801b0b:	77 cb                	ja     801ad8 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b10:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b13:	74 14                	je     801b29 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801b15:	83 ec 04             	sub    $0x4,%esp
  801b18:	68 d0 51 80 00       	push   $0x8051d0
  801b1d:	6a 44                	push   $0x44
  801b1f:	68 70 51 80 00       	push   $0x805170
  801b24:	e8 23 fe ff ff       	call   80194c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b29:	90                   	nop
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b35:	8b 00                	mov    (%eax),%eax
  801b37:	8d 48 01             	lea    0x1(%eax),%ecx
  801b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3d:	89 0a                	mov    %ecx,(%edx)
  801b3f:	8b 55 08             	mov    0x8(%ebp),%edx
  801b42:	88 d1                	mov    %dl,%cl
  801b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b47:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4e:	8b 00                	mov    (%eax),%eax
  801b50:	3d ff 00 00 00       	cmp    $0xff,%eax
  801b55:	75 2c                	jne    801b83 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801b57:	a0 24 60 80 00       	mov    0x806024,%al
  801b5c:	0f b6 c0             	movzbl %al,%eax
  801b5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b62:	8b 12                	mov    (%edx),%edx
  801b64:	89 d1                	mov    %edx,%ecx
  801b66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b69:	83 c2 08             	add    $0x8,%edx
  801b6c:	83 ec 04             	sub    $0x4,%esp
  801b6f:	50                   	push   %eax
  801b70:	51                   	push   %ecx
  801b71:	52                   	push   %edx
  801b72:	e8 6d 13 00 00       	call   802ee4 <sys_cputs>
  801b77:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801b83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b86:	8b 40 04             	mov    0x4(%eax),%eax
  801b89:	8d 50 01             	lea    0x1(%eax),%edx
  801b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8f:	89 50 04             	mov    %edx,0x4(%eax)
}
  801b92:	90                   	nop
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801b9e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801ba5:	00 00 00 
	b.cnt = 0;
  801ba8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801baf:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801bbe:	50                   	push   %eax
  801bbf:	68 2c 1b 80 00       	push   $0x801b2c
  801bc4:	e8 11 02 00 00       	call   801dda <vprintfmt>
  801bc9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801bcc:	a0 24 60 80 00       	mov    0x806024,%al
  801bd1:	0f b6 c0             	movzbl %al,%eax
  801bd4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801bda:	83 ec 04             	sub    $0x4,%esp
  801bdd:	50                   	push   %eax
  801bde:	52                   	push   %edx
  801bdf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801be5:	83 c0 08             	add    $0x8,%eax
  801be8:	50                   	push   %eax
  801be9:	e8 f6 12 00 00       	call   802ee4 <sys_cputs>
  801bee:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801bf1:	c6 05 24 60 80 00 00 	movb   $0x0,0x806024
	return b.cnt;
  801bf8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <cprintf>:

int cprintf(const char *fmt, ...) {
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801c06:	c6 05 24 60 80 00 01 	movb   $0x1,0x806024
	va_start(ap, fmt);
  801c0d:	8d 45 0c             	lea    0xc(%ebp),%eax
  801c10:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	83 ec 08             	sub    $0x8,%esp
  801c19:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1c:	50                   	push   %eax
  801c1d:	e8 73 ff ff ff       	call   801b95 <vcprintf>
  801c22:	83 c4 10             	add    $0x10,%esp
  801c25:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801c33:	e8 5a 14 00 00       	call   803092 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c38:	8d 45 0c             	lea    0xc(%ebp),%eax
  801c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	83 ec 08             	sub    $0x8,%esp
  801c44:	ff 75 f4             	pushl  -0xc(%ebp)
  801c47:	50                   	push   %eax
  801c48:	e8 48 ff ff ff       	call   801b95 <vcprintf>
  801c4d:	83 c4 10             	add    $0x10,%esp
  801c50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801c53:	e8 54 14 00 00       	call   8030ac <sys_enable_interrupt>
	return cnt;
  801c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	53                   	push   %ebx
  801c61:	83 ec 14             	sub    $0x14,%esp
  801c64:	8b 45 10             	mov    0x10(%ebp),%eax
  801c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801c70:	8b 45 18             	mov    0x18(%ebp),%eax
  801c73:	ba 00 00 00 00       	mov    $0x0,%edx
  801c78:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801c7b:	77 55                	ja     801cd2 <printnum+0x75>
  801c7d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801c80:	72 05                	jb     801c87 <printnum+0x2a>
  801c82:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c85:	77 4b                	ja     801cd2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801c87:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801c8a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801c8d:	8b 45 18             	mov    0x18(%ebp),%eax
  801c90:	ba 00 00 00 00       	mov    $0x0,%edx
  801c95:	52                   	push   %edx
  801c96:	50                   	push   %eax
  801c97:	ff 75 f4             	pushl  -0xc(%ebp)
  801c9a:	ff 75 f0             	pushl  -0x10(%ebp)
  801c9d:	e8 c6 2e 00 00       	call   804b68 <__udivdi3>
  801ca2:	83 c4 10             	add    $0x10,%esp
  801ca5:	83 ec 04             	sub    $0x4,%esp
  801ca8:	ff 75 20             	pushl  0x20(%ebp)
  801cab:	53                   	push   %ebx
  801cac:	ff 75 18             	pushl  0x18(%ebp)
  801caf:	52                   	push   %edx
  801cb0:	50                   	push   %eax
  801cb1:	ff 75 0c             	pushl  0xc(%ebp)
  801cb4:	ff 75 08             	pushl  0x8(%ebp)
  801cb7:	e8 a1 ff ff ff       	call   801c5d <printnum>
  801cbc:	83 c4 20             	add    $0x20,%esp
  801cbf:	eb 1a                	jmp    801cdb <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801cc1:	83 ec 08             	sub    $0x8,%esp
  801cc4:	ff 75 0c             	pushl  0xc(%ebp)
  801cc7:	ff 75 20             	pushl  0x20(%ebp)
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	ff d0                	call   *%eax
  801ccf:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801cd2:	ff 4d 1c             	decl   0x1c(%ebp)
  801cd5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801cd9:	7f e6                	jg     801cc1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801cdb:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801cde:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ce9:	53                   	push   %ebx
  801cea:	51                   	push   %ecx
  801ceb:	52                   	push   %edx
  801cec:	50                   	push   %eax
  801ced:	e8 86 2f 00 00       	call   804c78 <__umoddi3>
  801cf2:	83 c4 10             	add    $0x10,%esp
  801cf5:	05 34 54 80 00       	add    $0x805434,%eax
  801cfa:	8a 00                	mov    (%eax),%al
  801cfc:	0f be c0             	movsbl %al,%eax
  801cff:	83 ec 08             	sub    $0x8,%esp
  801d02:	ff 75 0c             	pushl  0xc(%ebp)
  801d05:	50                   	push   %eax
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	ff d0                	call   *%eax
  801d0b:	83 c4 10             	add    $0x10,%esp
}
  801d0e:	90                   	nop
  801d0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801d17:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801d1b:	7e 1c                	jle    801d39 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8b 00                	mov    (%eax),%eax
  801d22:	8d 50 08             	lea    0x8(%eax),%edx
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	89 10                	mov    %edx,(%eax)
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8b 00                	mov    (%eax),%eax
  801d2f:	83 e8 08             	sub    $0x8,%eax
  801d32:	8b 50 04             	mov    0x4(%eax),%edx
  801d35:	8b 00                	mov    (%eax),%eax
  801d37:	eb 40                	jmp    801d79 <getuint+0x65>
	else if (lflag)
  801d39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d3d:	74 1e                	je     801d5d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	8b 00                	mov    (%eax),%eax
  801d44:	8d 50 04             	lea    0x4(%eax),%edx
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	89 10                	mov    %edx,(%eax)
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	8b 00                	mov    (%eax),%eax
  801d51:	83 e8 04             	sub    $0x4,%eax
  801d54:	8b 00                	mov    (%eax),%eax
  801d56:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5b:	eb 1c                	jmp    801d79 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d60:	8b 00                	mov    (%eax),%eax
  801d62:	8d 50 04             	lea    0x4(%eax),%edx
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	89 10                	mov    %edx,(%eax)
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	8b 00                	mov    (%eax),%eax
  801d6f:	83 e8 04             	sub    $0x4,%eax
  801d72:	8b 00                	mov    (%eax),%eax
  801d74:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801d79:	5d                   	pop    %ebp
  801d7a:	c3                   	ret    

00801d7b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801d7e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801d82:	7e 1c                	jle    801da0 <getint+0x25>
		return va_arg(*ap, long long);
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	8b 00                	mov    (%eax),%eax
  801d89:	8d 50 08             	lea    0x8(%eax),%edx
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	89 10                	mov    %edx,(%eax)
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	8b 00                	mov    (%eax),%eax
  801d96:	83 e8 08             	sub    $0x8,%eax
  801d99:	8b 50 04             	mov    0x4(%eax),%edx
  801d9c:	8b 00                	mov    (%eax),%eax
  801d9e:	eb 38                	jmp    801dd8 <getint+0x5d>
	else if (lflag)
  801da0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801da4:	74 1a                	je     801dc0 <getint+0x45>
		return va_arg(*ap, long);
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	8b 00                	mov    (%eax),%eax
  801dab:	8d 50 04             	lea    0x4(%eax),%edx
  801dae:	8b 45 08             	mov    0x8(%ebp),%eax
  801db1:	89 10                	mov    %edx,(%eax)
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	8b 00                	mov    (%eax),%eax
  801db8:	83 e8 04             	sub    $0x4,%eax
  801dbb:	8b 00                	mov    (%eax),%eax
  801dbd:	99                   	cltd   
  801dbe:	eb 18                	jmp    801dd8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc3:	8b 00                	mov    (%eax),%eax
  801dc5:	8d 50 04             	lea    0x4(%eax),%edx
  801dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcb:	89 10                	mov    %edx,(%eax)
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	8b 00                	mov    (%eax),%eax
  801dd2:	83 e8 04             	sub    $0x4,%eax
  801dd5:	8b 00                	mov    (%eax),%eax
  801dd7:	99                   	cltd   
}
  801dd8:	5d                   	pop    %ebp
  801dd9:	c3                   	ret    

00801dda <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	56                   	push   %esi
  801dde:	53                   	push   %ebx
  801ddf:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801de2:	eb 17                	jmp    801dfb <vprintfmt+0x21>
			if (ch == '\0')
  801de4:	85 db                	test   %ebx,%ebx
  801de6:	0f 84 af 03 00 00    	je     80219b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801dec:	83 ec 08             	sub    $0x8,%esp
  801def:	ff 75 0c             	pushl  0xc(%ebp)
  801df2:	53                   	push   %ebx
  801df3:	8b 45 08             	mov    0x8(%ebp),%eax
  801df6:	ff d0                	call   *%eax
  801df8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801dfb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dfe:	8d 50 01             	lea    0x1(%eax),%edx
  801e01:	89 55 10             	mov    %edx,0x10(%ebp)
  801e04:	8a 00                	mov    (%eax),%al
  801e06:	0f b6 d8             	movzbl %al,%ebx
  801e09:	83 fb 25             	cmp    $0x25,%ebx
  801e0c:	75 d6                	jne    801de4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801e0e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801e12:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801e19:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801e20:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801e27:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e31:	8d 50 01             	lea    0x1(%eax),%edx
  801e34:	89 55 10             	mov    %edx,0x10(%ebp)
  801e37:	8a 00                	mov    (%eax),%al
  801e39:	0f b6 d8             	movzbl %al,%ebx
  801e3c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801e3f:	83 f8 55             	cmp    $0x55,%eax
  801e42:	0f 87 2b 03 00 00    	ja     802173 <vprintfmt+0x399>
  801e48:	8b 04 85 58 54 80 00 	mov    0x805458(,%eax,4),%eax
  801e4f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801e51:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801e55:	eb d7                	jmp    801e2e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801e57:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801e5b:	eb d1                	jmp    801e2e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801e5d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801e64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e67:	89 d0                	mov    %edx,%eax
  801e69:	c1 e0 02             	shl    $0x2,%eax
  801e6c:	01 d0                	add    %edx,%eax
  801e6e:	01 c0                	add    %eax,%eax
  801e70:	01 d8                	add    %ebx,%eax
  801e72:	83 e8 30             	sub    $0x30,%eax
  801e75:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801e78:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7b:	8a 00                	mov    (%eax),%al
  801e7d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801e80:	83 fb 2f             	cmp    $0x2f,%ebx
  801e83:	7e 3e                	jle    801ec3 <vprintfmt+0xe9>
  801e85:	83 fb 39             	cmp    $0x39,%ebx
  801e88:	7f 39                	jg     801ec3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801e8a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801e8d:	eb d5                	jmp    801e64 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e92:	83 c0 04             	add    $0x4,%eax
  801e95:	89 45 14             	mov    %eax,0x14(%ebp)
  801e98:	8b 45 14             	mov    0x14(%ebp),%eax
  801e9b:	83 e8 04             	sub    $0x4,%eax
  801e9e:	8b 00                	mov    (%eax),%eax
  801ea0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801ea3:	eb 1f                	jmp    801ec4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801ea5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ea9:	79 83                	jns    801e2e <vprintfmt+0x54>
				width = 0;
  801eab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801eb2:	e9 77 ff ff ff       	jmp    801e2e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801eb7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801ebe:	e9 6b ff ff ff       	jmp    801e2e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801ec3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801ec4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ec8:	0f 89 60 ff ff ff    	jns    801e2e <vprintfmt+0x54>
				width = precision, precision = -1;
  801ece:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ed1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ed4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801edb:	e9 4e ff ff ff       	jmp    801e2e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801ee0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801ee3:	e9 46 ff ff ff       	jmp    801e2e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801ee8:	8b 45 14             	mov    0x14(%ebp),%eax
  801eeb:	83 c0 04             	add    $0x4,%eax
  801eee:	89 45 14             	mov    %eax,0x14(%ebp)
  801ef1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef4:	83 e8 04             	sub    $0x4,%eax
  801ef7:	8b 00                	mov    (%eax),%eax
  801ef9:	83 ec 08             	sub    $0x8,%esp
  801efc:	ff 75 0c             	pushl  0xc(%ebp)
  801eff:	50                   	push   %eax
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	ff d0                	call   *%eax
  801f05:	83 c4 10             	add    $0x10,%esp
			break;
  801f08:	e9 89 02 00 00       	jmp    802196 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801f0d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f10:	83 c0 04             	add    $0x4,%eax
  801f13:	89 45 14             	mov    %eax,0x14(%ebp)
  801f16:	8b 45 14             	mov    0x14(%ebp),%eax
  801f19:	83 e8 04             	sub    $0x4,%eax
  801f1c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801f1e:	85 db                	test   %ebx,%ebx
  801f20:	79 02                	jns    801f24 <vprintfmt+0x14a>
				err = -err;
  801f22:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801f24:	83 fb 64             	cmp    $0x64,%ebx
  801f27:	7f 0b                	jg     801f34 <vprintfmt+0x15a>
  801f29:	8b 34 9d a0 52 80 00 	mov    0x8052a0(,%ebx,4),%esi
  801f30:	85 f6                	test   %esi,%esi
  801f32:	75 19                	jne    801f4d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801f34:	53                   	push   %ebx
  801f35:	68 45 54 80 00       	push   $0x805445
  801f3a:	ff 75 0c             	pushl  0xc(%ebp)
  801f3d:	ff 75 08             	pushl  0x8(%ebp)
  801f40:	e8 5e 02 00 00       	call   8021a3 <printfmt>
  801f45:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801f48:	e9 49 02 00 00       	jmp    802196 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801f4d:	56                   	push   %esi
  801f4e:	68 4e 54 80 00       	push   $0x80544e
  801f53:	ff 75 0c             	pushl  0xc(%ebp)
  801f56:	ff 75 08             	pushl  0x8(%ebp)
  801f59:	e8 45 02 00 00       	call   8021a3 <printfmt>
  801f5e:	83 c4 10             	add    $0x10,%esp
			break;
  801f61:	e9 30 02 00 00       	jmp    802196 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801f66:	8b 45 14             	mov    0x14(%ebp),%eax
  801f69:	83 c0 04             	add    $0x4,%eax
  801f6c:	89 45 14             	mov    %eax,0x14(%ebp)
  801f6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801f72:	83 e8 04             	sub    $0x4,%eax
  801f75:	8b 30                	mov    (%eax),%esi
  801f77:	85 f6                	test   %esi,%esi
  801f79:	75 05                	jne    801f80 <vprintfmt+0x1a6>
				p = "(null)";
  801f7b:	be 51 54 80 00       	mov    $0x805451,%esi
			if (width > 0 && padc != '-')
  801f80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f84:	7e 6d                	jle    801ff3 <vprintfmt+0x219>
  801f86:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801f8a:	74 67                	je     801ff3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801f8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f8f:	83 ec 08             	sub    $0x8,%esp
  801f92:	50                   	push   %eax
  801f93:	56                   	push   %esi
  801f94:	e8 0c 03 00 00       	call   8022a5 <strnlen>
  801f99:	83 c4 10             	add    $0x10,%esp
  801f9c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801f9f:	eb 16                	jmp    801fb7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801fa1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801fa5:	83 ec 08             	sub    $0x8,%esp
  801fa8:	ff 75 0c             	pushl  0xc(%ebp)
  801fab:	50                   	push   %eax
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	ff d0                	call   *%eax
  801fb1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801fb4:	ff 4d e4             	decl   -0x1c(%ebp)
  801fb7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801fbb:	7f e4                	jg     801fa1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801fbd:	eb 34                	jmp    801ff3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801fbf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801fc3:	74 1c                	je     801fe1 <vprintfmt+0x207>
  801fc5:	83 fb 1f             	cmp    $0x1f,%ebx
  801fc8:	7e 05                	jle    801fcf <vprintfmt+0x1f5>
  801fca:	83 fb 7e             	cmp    $0x7e,%ebx
  801fcd:	7e 12                	jle    801fe1 <vprintfmt+0x207>
					putch('?', putdat);
  801fcf:	83 ec 08             	sub    $0x8,%esp
  801fd2:	ff 75 0c             	pushl  0xc(%ebp)
  801fd5:	6a 3f                	push   $0x3f
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	ff d0                	call   *%eax
  801fdc:	83 c4 10             	add    $0x10,%esp
  801fdf:	eb 0f                	jmp    801ff0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801fe1:	83 ec 08             	sub    $0x8,%esp
  801fe4:	ff 75 0c             	pushl  0xc(%ebp)
  801fe7:	53                   	push   %ebx
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	ff d0                	call   *%eax
  801fed:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ff0:	ff 4d e4             	decl   -0x1c(%ebp)
  801ff3:	89 f0                	mov    %esi,%eax
  801ff5:	8d 70 01             	lea    0x1(%eax),%esi
  801ff8:	8a 00                	mov    (%eax),%al
  801ffa:	0f be d8             	movsbl %al,%ebx
  801ffd:	85 db                	test   %ebx,%ebx
  801fff:	74 24                	je     802025 <vprintfmt+0x24b>
  802001:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802005:	78 b8                	js     801fbf <vprintfmt+0x1e5>
  802007:	ff 4d e0             	decl   -0x20(%ebp)
  80200a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80200e:	79 af                	jns    801fbf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802010:	eb 13                	jmp    802025 <vprintfmt+0x24b>
				putch(' ', putdat);
  802012:	83 ec 08             	sub    $0x8,%esp
  802015:	ff 75 0c             	pushl  0xc(%ebp)
  802018:	6a 20                	push   $0x20
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	ff d0                	call   *%eax
  80201f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802022:	ff 4d e4             	decl   -0x1c(%ebp)
  802025:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802029:	7f e7                	jg     802012 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80202b:	e9 66 01 00 00       	jmp    802196 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  802030:	83 ec 08             	sub    $0x8,%esp
  802033:	ff 75 e8             	pushl  -0x18(%ebp)
  802036:	8d 45 14             	lea    0x14(%ebp),%eax
  802039:	50                   	push   %eax
  80203a:	e8 3c fd ff ff       	call   801d7b <getint>
  80203f:	83 c4 10             	add    $0x10,%esp
  802042:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802045:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  802048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204e:	85 d2                	test   %edx,%edx
  802050:	79 23                	jns    802075 <vprintfmt+0x29b>
				putch('-', putdat);
  802052:	83 ec 08             	sub    $0x8,%esp
  802055:	ff 75 0c             	pushl  0xc(%ebp)
  802058:	6a 2d                	push   $0x2d
  80205a:	8b 45 08             	mov    0x8(%ebp),%eax
  80205d:	ff d0                	call   *%eax
  80205f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  802062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802068:	f7 d8                	neg    %eax
  80206a:	83 d2 00             	adc    $0x0,%edx
  80206d:	f7 da                	neg    %edx
  80206f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802072:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  802075:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80207c:	e9 bc 00 00 00       	jmp    80213d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802081:	83 ec 08             	sub    $0x8,%esp
  802084:	ff 75 e8             	pushl  -0x18(%ebp)
  802087:	8d 45 14             	lea    0x14(%ebp),%eax
  80208a:	50                   	push   %eax
  80208b:	e8 84 fc ff ff       	call   801d14 <getuint>
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802096:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  802099:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8020a0:	e9 98 00 00 00       	jmp    80213d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8020a5:	83 ec 08             	sub    $0x8,%esp
  8020a8:	ff 75 0c             	pushl  0xc(%ebp)
  8020ab:	6a 58                	push   $0x58
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	ff d0                	call   *%eax
  8020b2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8020b5:	83 ec 08             	sub    $0x8,%esp
  8020b8:	ff 75 0c             	pushl  0xc(%ebp)
  8020bb:	6a 58                	push   $0x58
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	ff d0                	call   *%eax
  8020c2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8020c5:	83 ec 08             	sub    $0x8,%esp
  8020c8:	ff 75 0c             	pushl  0xc(%ebp)
  8020cb:	6a 58                	push   $0x58
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	ff d0                	call   *%eax
  8020d2:	83 c4 10             	add    $0x10,%esp
			break;
  8020d5:	e9 bc 00 00 00       	jmp    802196 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8020da:	83 ec 08             	sub    $0x8,%esp
  8020dd:	ff 75 0c             	pushl  0xc(%ebp)
  8020e0:	6a 30                	push   $0x30
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	ff d0                	call   *%eax
  8020e7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8020ea:	83 ec 08             	sub    $0x8,%esp
  8020ed:	ff 75 0c             	pushl  0xc(%ebp)
  8020f0:	6a 78                	push   $0x78
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	ff d0                	call   *%eax
  8020f7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8020fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8020fd:	83 c0 04             	add    $0x4,%eax
  802100:	89 45 14             	mov    %eax,0x14(%ebp)
  802103:	8b 45 14             	mov    0x14(%ebp),%eax
  802106:	83 e8 04             	sub    $0x4,%eax
  802109:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80210b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80210e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  802115:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80211c:	eb 1f                	jmp    80213d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80211e:	83 ec 08             	sub    $0x8,%esp
  802121:	ff 75 e8             	pushl  -0x18(%ebp)
  802124:	8d 45 14             	lea    0x14(%ebp),%eax
  802127:	50                   	push   %eax
  802128:	e8 e7 fb ff ff       	call   801d14 <getuint>
  80212d:	83 c4 10             	add    $0x10,%esp
  802130:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802133:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  802136:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80213d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  802141:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	52                   	push   %edx
  802148:	ff 75 e4             	pushl  -0x1c(%ebp)
  80214b:	50                   	push   %eax
  80214c:	ff 75 f4             	pushl  -0xc(%ebp)
  80214f:	ff 75 f0             	pushl  -0x10(%ebp)
  802152:	ff 75 0c             	pushl  0xc(%ebp)
  802155:	ff 75 08             	pushl  0x8(%ebp)
  802158:	e8 00 fb ff ff       	call   801c5d <printnum>
  80215d:	83 c4 20             	add    $0x20,%esp
			break;
  802160:	eb 34                	jmp    802196 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802162:	83 ec 08             	sub    $0x8,%esp
  802165:	ff 75 0c             	pushl  0xc(%ebp)
  802168:	53                   	push   %ebx
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	ff d0                	call   *%eax
  80216e:	83 c4 10             	add    $0x10,%esp
			break;
  802171:	eb 23                	jmp    802196 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802173:	83 ec 08             	sub    $0x8,%esp
  802176:	ff 75 0c             	pushl  0xc(%ebp)
  802179:	6a 25                	push   $0x25
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	ff d0                	call   *%eax
  802180:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  802183:	ff 4d 10             	decl   0x10(%ebp)
  802186:	eb 03                	jmp    80218b <vprintfmt+0x3b1>
  802188:	ff 4d 10             	decl   0x10(%ebp)
  80218b:	8b 45 10             	mov    0x10(%ebp),%eax
  80218e:	48                   	dec    %eax
  80218f:	8a 00                	mov    (%eax),%al
  802191:	3c 25                	cmp    $0x25,%al
  802193:	75 f3                	jne    802188 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  802195:	90                   	nop
		}
	}
  802196:	e9 47 fc ff ff       	jmp    801de2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80219b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80219c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80219f:	5b                   	pop    %ebx
  8021a0:	5e                   	pop    %esi
  8021a1:	5d                   	pop    %ebp
  8021a2:	c3                   	ret    

008021a3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8021a9:	8d 45 10             	lea    0x10(%ebp),%eax
  8021ac:	83 c0 04             	add    $0x4,%eax
  8021af:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8021b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8021b8:	50                   	push   %eax
  8021b9:	ff 75 0c             	pushl  0xc(%ebp)
  8021bc:	ff 75 08             	pushl  0x8(%ebp)
  8021bf:	e8 16 fc ff ff       	call   801dda <vprintfmt>
  8021c4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8021c7:	90                   	nop
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8021cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d0:	8b 40 08             	mov    0x8(%eax),%eax
  8021d3:	8d 50 01             	lea    0x1(%eax),%edx
  8021d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8021dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021df:	8b 10                	mov    (%eax),%edx
  8021e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e4:	8b 40 04             	mov    0x4(%eax),%eax
  8021e7:	39 c2                	cmp    %eax,%edx
  8021e9:	73 12                	jae    8021fd <sprintputch+0x33>
		*b->buf++ = ch;
  8021eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ee:	8b 00                	mov    (%eax),%eax
  8021f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8021f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f6:	89 0a                	mov    %ecx,(%edx)
  8021f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8021fb:	88 10                	mov    %dl,(%eax)
}
  8021fd:	90                   	nop
  8021fe:	5d                   	pop    %ebp
  8021ff:	c3                   	ret    

00802200 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80220c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	01 d0                	add    %edx,%eax
  802217:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80221a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  802221:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802225:	74 06                	je     80222d <vsnprintf+0x2d>
  802227:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80222b:	7f 07                	jg     802234 <vsnprintf+0x34>
		return -E_INVAL;
  80222d:	b8 03 00 00 00       	mov    $0x3,%eax
  802232:	eb 20                	jmp    802254 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802234:	ff 75 14             	pushl  0x14(%ebp)
  802237:	ff 75 10             	pushl  0x10(%ebp)
  80223a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80223d:	50                   	push   %eax
  80223e:	68 ca 21 80 00       	push   $0x8021ca
  802243:	e8 92 fb ff ff       	call   801dda <vprintfmt>
  802248:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80224b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802251:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80225c:	8d 45 10             	lea    0x10(%ebp),%eax
  80225f:	83 c0 04             	add    $0x4,%eax
  802262:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  802265:	8b 45 10             	mov    0x10(%ebp),%eax
  802268:	ff 75 f4             	pushl  -0xc(%ebp)
  80226b:	50                   	push   %eax
  80226c:	ff 75 0c             	pushl  0xc(%ebp)
  80226f:	ff 75 08             	pushl  0x8(%ebp)
  802272:	e8 89 ff ff ff       	call   802200 <vsnprintf>
  802277:	83 c4 10             	add    $0x10,%esp
  80227a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80227d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802288:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80228f:	eb 06                	jmp    802297 <strlen+0x15>
		n++;
  802291:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802294:	ff 45 08             	incl   0x8(%ebp)
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	8a 00                	mov    (%eax),%al
  80229c:	84 c0                	test   %al,%al
  80229e:	75 f1                	jne    802291 <strlen+0xf>
		n++;
	return n;
  8022a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8022ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8022b2:	eb 09                	jmp    8022bd <strnlen+0x18>
		n++;
  8022b4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8022b7:	ff 45 08             	incl   0x8(%ebp)
  8022ba:	ff 4d 0c             	decl   0xc(%ebp)
  8022bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022c1:	74 09                	je     8022cc <strnlen+0x27>
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	8a 00                	mov    (%eax),%al
  8022c8:	84 c0                	test   %al,%al
  8022ca:	75 e8                	jne    8022b4 <strnlen+0xf>
		n++;
	return n;
  8022cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    

008022d1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
  8022d4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8022dd:	90                   	nop
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	8d 50 01             	lea    0x1(%eax),%edx
  8022e4:	89 55 08             	mov    %edx,0x8(%ebp)
  8022e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022ed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8022f0:	8a 12                	mov    (%edx),%dl
  8022f2:	88 10                	mov    %dl,(%eax)
  8022f4:	8a 00                	mov    (%eax),%al
  8022f6:	84 c0                	test   %al,%al
  8022f8:	75 e4                	jne    8022de <strcpy+0xd>
		/* do nothing */;
	return ret;
  8022fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80230b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802312:	eb 1f                	jmp    802333 <strncpy+0x34>
		*dst++ = *src;
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	8d 50 01             	lea    0x1(%eax),%edx
  80231a:	89 55 08             	mov    %edx,0x8(%ebp)
  80231d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802320:	8a 12                	mov    (%edx),%dl
  802322:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802324:	8b 45 0c             	mov    0xc(%ebp),%eax
  802327:	8a 00                	mov    (%eax),%al
  802329:	84 c0                	test   %al,%al
  80232b:	74 03                	je     802330 <strncpy+0x31>
			src++;
  80232d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802330:	ff 45 fc             	incl   -0x4(%ebp)
  802333:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802336:	3b 45 10             	cmp    0x10(%ebp),%eax
  802339:	72 d9                	jb     802314 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80233b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80234c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802350:	74 30                	je     802382 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802352:	eb 16                	jmp    80236a <strlcpy+0x2a>
			*dst++ = *src++;
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	8d 50 01             	lea    0x1(%eax),%edx
  80235a:	89 55 08             	mov    %edx,0x8(%ebp)
  80235d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802360:	8d 4a 01             	lea    0x1(%edx),%ecx
  802363:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802366:	8a 12                	mov    (%edx),%dl
  802368:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80236a:	ff 4d 10             	decl   0x10(%ebp)
  80236d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802371:	74 09                	je     80237c <strlcpy+0x3c>
  802373:	8b 45 0c             	mov    0xc(%ebp),%eax
  802376:	8a 00                	mov    (%eax),%al
  802378:	84 c0                	test   %al,%al
  80237a:	75 d8                	jne    802354 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802382:	8b 55 08             	mov    0x8(%ebp),%edx
  802385:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802388:	29 c2                	sub    %eax,%edx
  80238a:	89 d0                	mov    %edx,%eax
}
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    

0080238e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802391:	eb 06                	jmp    802399 <strcmp+0xb>
		p++, q++;
  802393:	ff 45 08             	incl   0x8(%ebp)
  802396:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	8a 00                	mov    (%eax),%al
  80239e:	84 c0                	test   %al,%al
  8023a0:	74 0e                	je     8023b0 <strcmp+0x22>
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	8a 10                	mov    (%eax),%dl
  8023a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023aa:	8a 00                	mov    (%eax),%al
  8023ac:	38 c2                	cmp    %al,%dl
  8023ae:	74 e3                	je     802393 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	8a 00                	mov    (%eax),%al
  8023b5:	0f b6 d0             	movzbl %al,%edx
  8023b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023bb:	8a 00                	mov    (%eax),%al
  8023bd:	0f b6 c0             	movzbl %al,%eax
  8023c0:	29 c2                	sub    %eax,%edx
  8023c2:	89 d0                	mov    %edx,%eax
}
  8023c4:	5d                   	pop    %ebp
  8023c5:	c3                   	ret    

008023c6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8023c9:	eb 09                	jmp    8023d4 <strncmp+0xe>
		n--, p++, q++;
  8023cb:	ff 4d 10             	decl   0x10(%ebp)
  8023ce:	ff 45 08             	incl   0x8(%ebp)
  8023d1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8023d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023d8:	74 17                	je     8023f1 <strncmp+0x2b>
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	8a 00                	mov    (%eax),%al
  8023df:	84 c0                	test   %al,%al
  8023e1:	74 0e                	je     8023f1 <strncmp+0x2b>
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	8a 10                	mov    (%eax),%dl
  8023e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023eb:	8a 00                	mov    (%eax),%al
  8023ed:	38 c2                	cmp    %al,%dl
  8023ef:	74 da                	je     8023cb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8023f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023f5:	75 07                	jne    8023fe <strncmp+0x38>
		return 0;
  8023f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fc:	eb 14                	jmp    802412 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8023fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802401:	8a 00                	mov    (%eax),%al
  802403:	0f b6 d0             	movzbl %al,%edx
  802406:	8b 45 0c             	mov    0xc(%ebp),%eax
  802409:	8a 00                	mov    (%eax),%al
  80240b:	0f b6 c0             	movzbl %al,%eax
  80240e:	29 c2                	sub    %eax,%edx
  802410:	89 d0                	mov    %edx,%eax
}
  802412:	5d                   	pop    %ebp
  802413:	c3                   	ret    

00802414 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
  802417:	83 ec 04             	sub    $0x4,%esp
  80241a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802420:	eb 12                	jmp    802434 <strchr+0x20>
		if (*s == c)
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	8a 00                	mov    (%eax),%al
  802427:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80242a:	75 05                	jne    802431 <strchr+0x1d>
			return (char *) s;
  80242c:	8b 45 08             	mov    0x8(%ebp),%eax
  80242f:	eb 11                	jmp    802442 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802431:	ff 45 08             	incl   0x8(%ebp)
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	8a 00                	mov    (%eax),%al
  802439:	84 c0                	test   %al,%al
  80243b:	75 e5                	jne    802422 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80243d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802442:	c9                   	leave  
  802443:	c3                   	ret    

00802444 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
  802447:	83 ec 04             	sub    $0x4,%esp
  80244a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802450:	eb 0d                	jmp    80245f <strfind+0x1b>
		if (*s == c)
  802452:	8b 45 08             	mov    0x8(%ebp),%eax
  802455:	8a 00                	mov    (%eax),%al
  802457:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80245a:	74 0e                	je     80246a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80245c:	ff 45 08             	incl   0x8(%ebp)
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	8a 00                	mov    (%eax),%al
  802464:	84 c0                	test   %al,%al
  802466:	75 ea                	jne    802452 <strfind+0xe>
  802468:	eb 01                	jmp    80246b <strfind+0x27>
		if (*s == c)
			break;
  80246a:	90                   	nop
	return (char *) s;
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
  802473:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80247c:	8b 45 10             	mov    0x10(%ebp),%eax
  80247f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  802482:	eb 0e                	jmp    802492 <memset+0x22>
		*p++ = c;
  802484:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802487:	8d 50 01             	lea    0x1(%eax),%edx
  80248a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80248d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802490:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  802492:	ff 4d f8             	decl   -0x8(%ebp)
  802495:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802499:	79 e9                	jns    802484 <memset+0x14>
		*p++ = c;

	return v;
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80249e:	c9                   	leave  
  80249f:	c3                   	ret    

008024a0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
  8024a3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8024a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8024ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8024af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8024b2:	eb 16                	jmp    8024ca <memcpy+0x2a>
		*d++ = *s++;
  8024b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024b7:	8d 50 01             	lea    0x1(%eax),%edx
  8024ba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8024bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024c0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8024c3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8024c6:	8a 12                	mov    (%edx),%dl
  8024c8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8024ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8024cd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024d0:	89 55 10             	mov    %edx,0x10(%ebp)
  8024d3:	85 c0                	test   %eax,%eax
  8024d5:	75 dd                	jne    8024b4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8024d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8024da:	c9                   	leave  
  8024db:	c3                   	ret    

008024dc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
  8024df:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8024e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8024e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8024ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024f1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8024f4:	73 50                	jae    802546 <memmove+0x6a>
  8024f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8024fc:	01 d0                	add    %edx,%eax
  8024fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802501:	76 43                	jbe    802546 <memmove+0x6a>
		s += n;
  802503:	8b 45 10             	mov    0x10(%ebp),%eax
  802506:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802509:	8b 45 10             	mov    0x10(%ebp),%eax
  80250c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80250f:	eb 10                	jmp    802521 <memmove+0x45>
			*--d = *--s;
  802511:	ff 4d f8             	decl   -0x8(%ebp)
  802514:	ff 4d fc             	decl   -0x4(%ebp)
  802517:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80251a:	8a 10                	mov    (%eax),%dl
  80251c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80251f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802521:	8b 45 10             	mov    0x10(%ebp),%eax
  802524:	8d 50 ff             	lea    -0x1(%eax),%edx
  802527:	89 55 10             	mov    %edx,0x10(%ebp)
  80252a:	85 c0                	test   %eax,%eax
  80252c:	75 e3                	jne    802511 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80252e:	eb 23                	jmp    802553 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802530:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802533:	8d 50 01             	lea    0x1(%eax),%edx
  802536:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802539:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80253c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80253f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802542:	8a 12                	mov    (%edx),%dl
  802544:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802546:	8b 45 10             	mov    0x10(%ebp),%eax
  802549:	8d 50 ff             	lea    -0x1(%eax),%edx
  80254c:	89 55 10             	mov    %edx,0x10(%ebp)
  80254f:	85 c0                	test   %eax,%eax
  802551:	75 dd                	jne    802530 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802553:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80255e:	8b 45 08             	mov    0x8(%ebp),%eax
  802561:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802564:	8b 45 0c             	mov    0xc(%ebp),%eax
  802567:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80256a:	eb 2a                	jmp    802596 <memcmp+0x3e>
		if (*s1 != *s2)
  80256c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80256f:	8a 10                	mov    (%eax),%dl
  802571:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802574:	8a 00                	mov    (%eax),%al
  802576:	38 c2                	cmp    %al,%dl
  802578:	74 16                	je     802590 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80257a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80257d:	8a 00                	mov    (%eax),%al
  80257f:	0f b6 d0             	movzbl %al,%edx
  802582:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802585:	8a 00                	mov    (%eax),%al
  802587:	0f b6 c0             	movzbl %al,%eax
  80258a:	29 c2                	sub    %eax,%edx
  80258c:	89 d0                	mov    %edx,%eax
  80258e:	eb 18                	jmp    8025a8 <memcmp+0x50>
		s1++, s2++;
  802590:	ff 45 fc             	incl   -0x4(%ebp)
  802593:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802596:	8b 45 10             	mov    0x10(%ebp),%eax
  802599:	8d 50 ff             	lea    -0x1(%eax),%edx
  80259c:	89 55 10             	mov    %edx,0x10(%ebp)
  80259f:	85 c0                	test   %eax,%eax
  8025a1:	75 c9                	jne    80256c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8025a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    

008025aa <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
  8025ad:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8025b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8025b6:	01 d0                	add    %edx,%eax
  8025b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8025bb:	eb 15                	jmp    8025d2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8025bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c0:	8a 00                	mov    (%eax),%al
  8025c2:	0f b6 d0             	movzbl %al,%edx
  8025c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c8:	0f b6 c0             	movzbl %al,%eax
  8025cb:	39 c2                	cmp    %eax,%edx
  8025cd:	74 0d                	je     8025dc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8025cf:	ff 45 08             	incl   0x8(%ebp)
  8025d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8025d8:	72 e3                	jb     8025bd <memfind+0x13>
  8025da:	eb 01                	jmp    8025dd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8025dc:	90                   	nop
	return (void *) s;
  8025dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8025e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8025ef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025f6:	eb 03                	jmp    8025fb <strtol+0x19>
		s++;
  8025f8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	8a 00                	mov    (%eax),%al
  802600:	3c 20                	cmp    $0x20,%al
  802602:	74 f4                	je     8025f8 <strtol+0x16>
  802604:	8b 45 08             	mov    0x8(%ebp),%eax
  802607:	8a 00                	mov    (%eax),%al
  802609:	3c 09                	cmp    $0x9,%al
  80260b:	74 eb                	je     8025f8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	8a 00                	mov    (%eax),%al
  802612:	3c 2b                	cmp    $0x2b,%al
  802614:	75 05                	jne    80261b <strtol+0x39>
		s++;
  802616:	ff 45 08             	incl   0x8(%ebp)
  802619:	eb 13                	jmp    80262e <strtol+0x4c>
	else if (*s == '-')
  80261b:	8b 45 08             	mov    0x8(%ebp),%eax
  80261e:	8a 00                	mov    (%eax),%al
  802620:	3c 2d                	cmp    $0x2d,%al
  802622:	75 0a                	jne    80262e <strtol+0x4c>
		s++, neg = 1;
  802624:	ff 45 08             	incl   0x8(%ebp)
  802627:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80262e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802632:	74 06                	je     80263a <strtol+0x58>
  802634:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802638:	75 20                	jne    80265a <strtol+0x78>
  80263a:	8b 45 08             	mov    0x8(%ebp),%eax
  80263d:	8a 00                	mov    (%eax),%al
  80263f:	3c 30                	cmp    $0x30,%al
  802641:	75 17                	jne    80265a <strtol+0x78>
  802643:	8b 45 08             	mov    0x8(%ebp),%eax
  802646:	40                   	inc    %eax
  802647:	8a 00                	mov    (%eax),%al
  802649:	3c 78                	cmp    $0x78,%al
  80264b:	75 0d                	jne    80265a <strtol+0x78>
		s += 2, base = 16;
  80264d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802651:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802658:	eb 28                	jmp    802682 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80265a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80265e:	75 15                	jne    802675 <strtol+0x93>
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	8a 00                	mov    (%eax),%al
  802665:	3c 30                	cmp    $0x30,%al
  802667:	75 0c                	jne    802675 <strtol+0x93>
		s++, base = 8;
  802669:	ff 45 08             	incl   0x8(%ebp)
  80266c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802673:	eb 0d                	jmp    802682 <strtol+0xa0>
	else if (base == 0)
  802675:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802679:	75 07                	jne    802682 <strtol+0xa0>
		base = 10;
  80267b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	8a 00                	mov    (%eax),%al
  802687:	3c 2f                	cmp    $0x2f,%al
  802689:	7e 19                	jle    8026a4 <strtol+0xc2>
  80268b:	8b 45 08             	mov    0x8(%ebp),%eax
  80268e:	8a 00                	mov    (%eax),%al
  802690:	3c 39                	cmp    $0x39,%al
  802692:	7f 10                	jg     8026a4 <strtol+0xc2>
			dig = *s - '0';
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	8a 00                	mov    (%eax),%al
  802699:	0f be c0             	movsbl %al,%eax
  80269c:	83 e8 30             	sub    $0x30,%eax
  80269f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a2:	eb 42                	jmp    8026e6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	8a 00                	mov    (%eax),%al
  8026a9:	3c 60                	cmp    $0x60,%al
  8026ab:	7e 19                	jle    8026c6 <strtol+0xe4>
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	8a 00                	mov    (%eax),%al
  8026b2:	3c 7a                	cmp    $0x7a,%al
  8026b4:	7f 10                	jg     8026c6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8026b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b9:	8a 00                	mov    (%eax),%al
  8026bb:	0f be c0             	movsbl %al,%eax
  8026be:	83 e8 57             	sub    $0x57,%eax
  8026c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c4:	eb 20                	jmp    8026e6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	8a 00                	mov    (%eax),%al
  8026cb:	3c 40                	cmp    $0x40,%al
  8026cd:	7e 39                	jle    802708 <strtol+0x126>
  8026cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d2:	8a 00                	mov    (%eax),%al
  8026d4:	3c 5a                	cmp    $0x5a,%al
  8026d6:	7f 30                	jg     802708 <strtol+0x126>
			dig = *s - 'A' + 10;
  8026d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026db:	8a 00                	mov    (%eax),%al
  8026dd:	0f be c0             	movsbl %al,%eax
  8026e0:	83 e8 37             	sub    $0x37,%eax
  8026e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8026ec:	7d 19                	jge    802707 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8026ee:	ff 45 08             	incl   0x8(%ebp)
  8026f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026f4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8026f8:	89 c2                	mov    %eax,%edx
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	01 d0                	add    %edx,%eax
  8026ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802702:	e9 7b ff ff ff       	jmp    802682 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802707:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802708:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80270c:	74 08                	je     802716 <strtol+0x134>
		*endptr = (char *) s;
  80270e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802711:	8b 55 08             	mov    0x8(%ebp),%edx
  802714:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802716:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80271a:	74 07                	je     802723 <strtol+0x141>
  80271c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80271f:	f7 d8                	neg    %eax
  802721:	eb 03                	jmp    802726 <strtol+0x144>
  802723:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802726:	c9                   	leave  
  802727:	c3                   	ret    

00802728 <ltostr>:

void
ltostr(long value, char *str)
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
  80272b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80272e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802735:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80273c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802740:	79 13                	jns    802755 <ltostr+0x2d>
	{
		neg = 1;
  802742:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80274c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80274f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802752:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802755:	8b 45 08             	mov    0x8(%ebp),%eax
  802758:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80275d:	99                   	cltd   
  80275e:	f7 f9                	idiv   %ecx
  802760:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802763:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802766:	8d 50 01             	lea    0x1(%eax),%edx
  802769:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80276c:	89 c2                	mov    %eax,%edx
  80276e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802771:	01 d0                	add    %edx,%eax
  802773:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802776:	83 c2 30             	add    $0x30,%edx
  802779:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80277b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80277e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802783:	f7 e9                	imul   %ecx
  802785:	c1 fa 02             	sar    $0x2,%edx
  802788:	89 c8                	mov    %ecx,%eax
  80278a:	c1 f8 1f             	sar    $0x1f,%eax
  80278d:	29 c2                	sub    %eax,%edx
  80278f:	89 d0                	mov    %edx,%eax
  802791:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802794:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802797:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80279c:	f7 e9                	imul   %ecx
  80279e:	c1 fa 02             	sar    $0x2,%edx
  8027a1:	89 c8                	mov    %ecx,%eax
  8027a3:	c1 f8 1f             	sar    $0x1f,%eax
  8027a6:	29 c2                	sub    %eax,%edx
  8027a8:	89 d0                	mov    %edx,%eax
  8027aa:	c1 e0 02             	shl    $0x2,%eax
  8027ad:	01 d0                	add    %edx,%eax
  8027af:	01 c0                	add    %eax,%eax
  8027b1:	29 c1                	sub    %eax,%ecx
  8027b3:	89 ca                	mov    %ecx,%edx
  8027b5:	85 d2                	test   %edx,%edx
  8027b7:	75 9c                	jne    802755 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8027b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8027c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027c3:	48                   	dec    %eax
  8027c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8027c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027cb:	74 3d                	je     80280a <ltostr+0xe2>
		start = 1 ;
  8027cd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8027d4:	eb 34                	jmp    80280a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8027d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027dc:	01 d0                	add    %edx,%eax
  8027de:	8a 00                	mov    (%eax),%al
  8027e0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8027e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027e9:	01 c2                	add    %eax,%edx
  8027eb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8027ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f1:	01 c8                	add    %ecx,%eax
  8027f3:	8a 00                	mov    (%eax),%al
  8027f5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8027f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027fd:	01 c2                	add    %eax,%edx
  8027ff:	8a 45 eb             	mov    -0x15(%ebp),%al
  802802:	88 02                	mov    %al,(%edx)
		start++ ;
  802804:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802807:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802810:	7c c4                	jl     8027d6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802812:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802815:	8b 45 0c             	mov    0xc(%ebp),%eax
  802818:	01 d0                	add    %edx,%eax
  80281a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80281d:	90                   	nop
  80281e:	c9                   	leave  
  80281f:	c3                   	ret    

00802820 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802820:	55                   	push   %ebp
  802821:	89 e5                	mov    %esp,%ebp
  802823:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802826:	ff 75 08             	pushl  0x8(%ebp)
  802829:	e8 54 fa ff ff       	call   802282 <strlen>
  80282e:	83 c4 04             	add    $0x4,%esp
  802831:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802834:	ff 75 0c             	pushl  0xc(%ebp)
  802837:	e8 46 fa ff ff       	call   802282 <strlen>
  80283c:	83 c4 04             	add    $0x4,%esp
  80283f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802842:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802849:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802850:	eb 17                	jmp    802869 <strcconcat+0x49>
		final[s] = str1[s] ;
  802852:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802855:	8b 45 10             	mov    0x10(%ebp),%eax
  802858:	01 c2                	add    %eax,%edx
  80285a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	01 c8                	add    %ecx,%eax
  802862:	8a 00                	mov    (%eax),%al
  802864:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802866:	ff 45 fc             	incl   -0x4(%ebp)
  802869:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80286c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80286f:	7c e1                	jl     802852 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802871:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802878:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80287f:	eb 1f                	jmp    8028a0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  802881:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802884:	8d 50 01             	lea    0x1(%eax),%edx
  802887:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80288a:	89 c2                	mov    %eax,%edx
  80288c:	8b 45 10             	mov    0x10(%ebp),%eax
  80288f:	01 c2                	add    %eax,%edx
  802891:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802894:	8b 45 0c             	mov    0xc(%ebp),%eax
  802897:	01 c8                	add    %ecx,%eax
  802899:	8a 00                	mov    (%eax),%al
  80289b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80289d:	ff 45 f8             	incl   -0x8(%ebp)
  8028a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8028a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028a6:	7c d9                	jl     802881 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8028a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8028ae:	01 d0                	add    %edx,%eax
  8028b0:	c6 00 00             	movb   $0x0,(%eax)
}
  8028b3:	90                   	nop
  8028b4:	c9                   	leave  
  8028b5:	c3                   	ret    

008028b6 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8028b6:	55                   	push   %ebp
  8028b7:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8028b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8028bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8028c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8028d1:	01 d0                	add    %edx,%eax
  8028d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8028d9:	eb 0c                	jmp    8028e7 <strsplit+0x31>
			*string++ = 0;
  8028db:	8b 45 08             	mov    0x8(%ebp),%eax
  8028de:	8d 50 01             	lea    0x1(%eax),%edx
  8028e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8028e4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8028e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ea:	8a 00                	mov    (%eax),%al
  8028ec:	84 c0                	test   %al,%al
  8028ee:	74 18                	je     802908 <strsplit+0x52>
  8028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f3:	8a 00                	mov    (%eax),%al
  8028f5:	0f be c0             	movsbl %al,%eax
  8028f8:	50                   	push   %eax
  8028f9:	ff 75 0c             	pushl  0xc(%ebp)
  8028fc:	e8 13 fb ff ff       	call   802414 <strchr>
  802901:	83 c4 08             	add    $0x8,%esp
  802904:	85 c0                	test   %eax,%eax
  802906:	75 d3                	jne    8028db <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802908:	8b 45 08             	mov    0x8(%ebp),%eax
  80290b:	8a 00                	mov    (%eax),%al
  80290d:	84 c0                	test   %al,%al
  80290f:	74 5a                	je     80296b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802911:	8b 45 14             	mov    0x14(%ebp),%eax
  802914:	8b 00                	mov    (%eax),%eax
  802916:	83 f8 0f             	cmp    $0xf,%eax
  802919:	75 07                	jne    802922 <strsplit+0x6c>
		{
			return 0;
  80291b:	b8 00 00 00 00       	mov    $0x0,%eax
  802920:	eb 66                	jmp    802988 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802922:	8b 45 14             	mov    0x14(%ebp),%eax
  802925:	8b 00                	mov    (%eax),%eax
  802927:	8d 48 01             	lea    0x1(%eax),%ecx
  80292a:	8b 55 14             	mov    0x14(%ebp),%edx
  80292d:	89 0a                	mov    %ecx,(%edx)
  80292f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802936:	8b 45 10             	mov    0x10(%ebp),%eax
  802939:	01 c2                	add    %eax,%edx
  80293b:	8b 45 08             	mov    0x8(%ebp),%eax
  80293e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802940:	eb 03                	jmp    802945 <strsplit+0x8f>
			string++;
  802942:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802945:	8b 45 08             	mov    0x8(%ebp),%eax
  802948:	8a 00                	mov    (%eax),%al
  80294a:	84 c0                	test   %al,%al
  80294c:	74 8b                	je     8028d9 <strsplit+0x23>
  80294e:	8b 45 08             	mov    0x8(%ebp),%eax
  802951:	8a 00                	mov    (%eax),%al
  802953:	0f be c0             	movsbl %al,%eax
  802956:	50                   	push   %eax
  802957:	ff 75 0c             	pushl  0xc(%ebp)
  80295a:	e8 b5 fa ff ff       	call   802414 <strchr>
  80295f:	83 c4 08             	add    $0x8,%esp
  802962:	85 c0                	test   %eax,%eax
  802964:	74 dc                	je     802942 <strsplit+0x8c>
			string++;
	}
  802966:	e9 6e ff ff ff       	jmp    8028d9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80296b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80296c:	8b 45 14             	mov    0x14(%ebp),%eax
  80296f:	8b 00                	mov    (%eax),%eax
  802971:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802978:	8b 45 10             	mov    0x10(%ebp),%eax
  80297b:	01 d0                	add    %edx,%eax
  80297d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802983:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802988:	c9                   	leave  
  802989:	c3                   	ret    

0080298a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80298a:	55                   	push   %ebp
  80298b:	89 e5                	mov    %esp,%ebp
  80298d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  802990:	a1 04 60 80 00       	mov    0x806004,%eax
  802995:	85 c0                	test   %eax,%eax
  802997:	74 1f                	je     8029b8 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  802999:	e8 1d 00 00 00       	call   8029bb <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80299e:	83 ec 0c             	sub    $0xc,%esp
  8029a1:	68 b0 55 80 00       	push   $0x8055b0
  8029a6:	e8 55 f2 ff ff       	call   801c00 <cprintf>
  8029ab:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8029ae:	c7 05 04 60 80 00 00 	movl   $0x0,0x806004
  8029b5:	00 00 00 
	}
}
  8029b8:	90                   	nop
  8029b9:	c9                   	leave  
  8029ba:	c3                   	ret    

008029bb <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8029bb:	55                   	push   %ebp
  8029bc:	89 e5                	mov    %esp,%ebp
  8029be:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8029c1:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  8029c8:	00 00 00 
  8029cb:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  8029d2:	00 00 00 
  8029d5:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8029dc:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8029df:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  8029e6:	00 00 00 
  8029e9:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  8029f0:	00 00 00 
  8029f3:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  8029fa:	00 00 00 
	uint32 arr_size = 0;
  8029fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  802a04:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  802a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802a13:	2d 00 10 00 00       	sub    $0x1000,%eax
  802a18:	a3 50 60 80 00       	mov    %eax,0x806050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  802a1d:	c7 05 20 61 80 00 00 	movl   $0x20000,0x806120
  802a24:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  802a27:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a2e:	a1 20 61 80 00       	mov    0x806120,%eax
  802a33:	c1 e0 04             	shl    $0x4,%eax
  802a36:	89 c2                	mov    %eax,%edx
  802a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3b:	01 d0                	add    %edx,%eax
  802a3d:	48                   	dec    %eax
  802a3e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a44:	ba 00 00 00 00       	mov    $0x0,%edx
  802a49:	f7 75 ec             	divl   -0x14(%ebp)
  802a4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4f:	29 d0                	sub    %edx,%eax
  802a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  802a54:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  802a5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802a63:	2d 00 10 00 00       	sub    $0x1000,%eax
  802a68:	83 ec 04             	sub    $0x4,%esp
  802a6b:	6a 06                	push   $0x6
  802a6d:	ff 75 f4             	pushl  -0xc(%ebp)
  802a70:	50                   	push   %eax
  802a71:	e8 b2 05 00 00       	call   803028 <sys_allocate_chunk>
  802a76:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802a79:	a1 20 61 80 00       	mov    0x806120,%eax
  802a7e:	83 ec 0c             	sub    $0xc,%esp
  802a81:	50                   	push   %eax
  802a82:	e8 27 0c 00 00       	call   8036ae <initialize_MemBlocksList>
  802a87:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a8a:	a1 48 61 80 00       	mov    0x806148,%eax
  802a8f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  802a92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a95:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  802a9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a9f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  802aa6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802aaa:	75 14                	jne    802ac0 <initialize_dyn_block_system+0x105>
  802aac:	83 ec 04             	sub    $0x4,%esp
  802aaf:	68 d5 55 80 00       	push   $0x8055d5
  802ab4:	6a 33                	push   $0x33
  802ab6:	68 f3 55 80 00       	push   $0x8055f3
  802abb:	e8 8c ee ff ff       	call   80194c <_panic>
  802ac0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac3:	8b 00                	mov    (%eax),%eax
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	74 10                	je     802ad9 <initialize_dyn_block_system+0x11e>
  802ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802acc:	8b 00                	mov    (%eax),%eax
  802ace:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ad1:	8b 52 04             	mov    0x4(%edx),%edx
  802ad4:	89 50 04             	mov    %edx,0x4(%eax)
  802ad7:	eb 0b                	jmp    802ae4 <initialize_dyn_block_system+0x129>
  802ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802adc:	8b 40 04             	mov    0x4(%eax),%eax
  802adf:	a3 4c 61 80 00       	mov    %eax,0x80614c
  802ae4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae7:	8b 40 04             	mov    0x4(%eax),%eax
  802aea:	85 c0                	test   %eax,%eax
  802aec:	74 0f                	je     802afd <initialize_dyn_block_system+0x142>
  802aee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af1:	8b 40 04             	mov    0x4(%eax),%eax
  802af4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802af7:	8b 12                	mov    (%edx),%edx
  802af9:	89 10                	mov    %edx,(%eax)
  802afb:	eb 0a                	jmp    802b07 <initialize_dyn_block_system+0x14c>
  802afd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b00:	8b 00                	mov    (%eax),%eax
  802b02:	a3 48 61 80 00       	mov    %eax,0x806148
  802b07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1a:	a1 54 61 80 00       	mov    0x806154,%eax
  802b1f:	48                   	dec    %eax
  802b20:	a3 54 61 80 00       	mov    %eax,0x806154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  802b25:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b29:	75 14                	jne    802b3f <initialize_dyn_block_system+0x184>
  802b2b:	83 ec 04             	sub    $0x4,%esp
  802b2e:	68 00 56 80 00       	push   $0x805600
  802b33:	6a 34                	push   $0x34
  802b35:	68 f3 55 80 00       	push   $0x8055f3
  802b3a:	e8 0d ee ff ff       	call   80194c <_panic>
  802b3f:	8b 15 38 61 80 00    	mov    0x806138,%edx
  802b45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b48:	89 10                	mov    %edx,(%eax)
  802b4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b4d:	8b 00                	mov    (%eax),%eax
  802b4f:	85 c0                	test   %eax,%eax
  802b51:	74 0d                	je     802b60 <initialize_dyn_block_system+0x1a5>
  802b53:	a1 38 61 80 00       	mov    0x806138,%eax
  802b58:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b5b:	89 50 04             	mov    %edx,0x4(%eax)
  802b5e:	eb 08                	jmp    802b68 <initialize_dyn_block_system+0x1ad>
  802b60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b63:	a3 3c 61 80 00       	mov    %eax,0x80613c
  802b68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b6b:	a3 38 61 80 00       	mov    %eax,0x806138
  802b70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7a:	a1 44 61 80 00       	mov    0x806144,%eax
  802b7f:	40                   	inc    %eax
  802b80:	a3 44 61 80 00       	mov    %eax,0x806144
}
  802b85:	90                   	nop
  802b86:	c9                   	leave  
  802b87:	c3                   	ret    

00802b88 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802b88:	55                   	push   %ebp
  802b89:	89 e5                	mov    %esp,%ebp
  802b8b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802b8e:	e8 f7 fd ff ff       	call   80298a <InitializeUHeap>
	if (size == 0) return NULL ;
  802b93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b97:	75 07                	jne    802ba0 <malloc+0x18>
  802b99:	b8 00 00 00 00       	mov    $0x0,%eax
  802b9e:	eb 61                	jmp    802c01 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  802ba0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  802baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bad:	01 d0                	add    %edx,%eax
  802baf:	48                   	dec    %eax
  802bb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802bb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb6:	ba 00 00 00 00       	mov    $0x0,%edx
  802bbb:	f7 75 f0             	divl   -0x10(%ebp)
  802bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc1:	29 d0                	sub    %edx,%eax
  802bc3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802bc6:	e8 2b 08 00 00       	call   8033f6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	74 11                	je     802be0 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  802bcf:	83 ec 0c             	sub    $0xc,%esp
  802bd2:	ff 75 e8             	pushl  -0x18(%ebp)
  802bd5:	e8 96 0e 00 00       	call   803a70 <alloc_block_FF>
  802bda:	83 c4 10             	add    $0x10,%esp
  802bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  802be0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be4:	74 16                	je     802bfc <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  802be6:	83 ec 0c             	sub    $0xc,%esp
  802be9:	ff 75 f4             	pushl  -0xc(%ebp)
  802bec:	e8 f2 0b 00 00       	call   8037e3 <insert_sorted_allocList>
  802bf1:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	8b 40 08             	mov    0x8(%eax),%eax
  802bfa:	eb 05                	jmp    802c01 <malloc+0x79>
	}

    return NULL;
  802bfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c01:	c9                   	leave  
  802c02:	c3                   	ret    

00802c03 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802c03:	55                   	push   %ebp
  802c04:	89 e5                	mov    %esp,%ebp
  802c06:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  802c09:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0c:	83 ec 08             	sub    $0x8,%esp
  802c0f:	50                   	push   %eax
  802c10:	68 40 60 80 00       	push   $0x806040
  802c15:	e8 71 0b 00 00       	call   80378b <find_block>
  802c1a:	83 c4 10             	add    $0x10,%esp
  802c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  802c20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c24:	0f 84 a6 00 00 00    	je     802cd0 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	8b 50 0c             	mov    0xc(%eax),%edx
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 40 08             	mov    0x8(%eax),%eax
  802c36:	83 ec 08             	sub    $0x8,%esp
  802c39:	52                   	push   %edx
  802c3a:	50                   	push   %eax
  802c3b:	e8 b0 03 00 00       	call   802ff0 <sys_free_user_mem>
  802c40:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  802c43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c47:	75 14                	jne    802c5d <free+0x5a>
  802c49:	83 ec 04             	sub    $0x4,%esp
  802c4c:	68 d5 55 80 00       	push   $0x8055d5
  802c51:	6a 74                	push   $0x74
  802c53:	68 f3 55 80 00       	push   $0x8055f3
  802c58:	e8 ef ec ff ff       	call   80194c <_panic>
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 00                	mov    (%eax),%eax
  802c62:	85 c0                	test   %eax,%eax
  802c64:	74 10                	je     802c76 <free+0x73>
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 00                	mov    (%eax),%eax
  802c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c6e:	8b 52 04             	mov    0x4(%edx),%edx
  802c71:	89 50 04             	mov    %edx,0x4(%eax)
  802c74:	eb 0b                	jmp    802c81 <free+0x7e>
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	8b 40 04             	mov    0x4(%eax),%eax
  802c7c:	a3 44 60 80 00       	mov    %eax,0x806044
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 04             	mov    0x4(%eax),%eax
  802c87:	85 c0                	test   %eax,%eax
  802c89:	74 0f                	je     802c9a <free+0x97>
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 40 04             	mov    0x4(%eax),%eax
  802c91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c94:	8b 12                	mov    (%edx),%edx
  802c96:	89 10                	mov    %edx,(%eax)
  802c98:	eb 0a                	jmp    802ca4 <free+0xa1>
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 00                	mov    (%eax),%eax
  802c9f:	a3 40 60 80 00       	mov    %eax,0x806040
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb7:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802cbc:	48                   	dec    %eax
  802cbd:	a3 4c 60 80 00       	mov    %eax,0x80604c
		insert_sorted_with_merge_freeList(free_block);
  802cc2:	83 ec 0c             	sub    $0xc,%esp
  802cc5:	ff 75 f4             	pushl  -0xc(%ebp)
  802cc8:	e8 4e 17 00 00       	call   80441b <insert_sorted_with_merge_freeList>
  802ccd:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  802cd0:	90                   	nop
  802cd1:	c9                   	leave  
  802cd2:	c3                   	ret    

00802cd3 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802cd3:	55                   	push   %ebp
  802cd4:	89 e5                	mov    %esp,%ebp
  802cd6:	83 ec 38             	sub    $0x38,%esp
  802cd9:	8b 45 10             	mov    0x10(%ebp),%eax
  802cdc:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802cdf:	e8 a6 fc ff ff       	call   80298a <InitializeUHeap>
	if (size == 0) return NULL ;
  802ce4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ce8:	75 0a                	jne    802cf4 <smalloc+0x21>
  802cea:	b8 00 00 00 00       	mov    $0x0,%eax
  802cef:	e9 8b 00 00 00       	jmp    802d7f <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802cf4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	01 d0                	add    %edx,%eax
  802d03:	48                   	dec    %eax
  802d04:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0a:	ba 00 00 00 00       	mov    $0x0,%edx
  802d0f:	f7 75 f0             	divl   -0x10(%ebp)
  802d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d15:	29 d0                	sub    %edx,%eax
  802d17:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  802d1a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802d21:	e8 d0 06 00 00       	call   8033f6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802d26:	85 c0                	test   %eax,%eax
  802d28:	74 11                	je     802d3b <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  802d2a:	83 ec 0c             	sub    $0xc,%esp
  802d2d:	ff 75 e8             	pushl  -0x18(%ebp)
  802d30:	e8 3b 0d 00 00       	call   803a70 <alloc_block_FF>
  802d35:	83 c4 10             	add    $0x10,%esp
  802d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  802d3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3f:	74 39                	je     802d7a <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  802d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d44:	8b 40 08             	mov    0x8(%eax),%eax
  802d47:	89 c2                	mov    %eax,%edx
  802d49:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802d4d:	52                   	push   %edx
  802d4e:	50                   	push   %eax
  802d4f:	ff 75 0c             	pushl  0xc(%ebp)
  802d52:	ff 75 08             	pushl  0x8(%ebp)
  802d55:	e8 21 04 00 00       	call   80317b <sys_createSharedObject>
  802d5a:	83 c4 10             	add    $0x10,%esp
  802d5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  802d60:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802d64:	74 14                	je     802d7a <smalloc+0xa7>
  802d66:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  802d6a:	74 0e                	je     802d7a <smalloc+0xa7>
  802d6c:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  802d70:	74 08                	je     802d7a <smalloc+0xa7>
			return (void*) mem_block->sva;
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	8b 40 08             	mov    0x8(%eax),%eax
  802d78:	eb 05                	jmp    802d7f <smalloc+0xac>
	}
	return NULL;
  802d7a:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802d7f:	c9                   	leave  
  802d80:	c3                   	ret    

00802d81 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802d81:	55                   	push   %ebp
  802d82:	89 e5                	mov    %esp,%ebp
  802d84:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802d87:	e8 fe fb ff ff       	call   80298a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802d8c:	83 ec 08             	sub    $0x8,%esp
  802d8f:	ff 75 0c             	pushl  0xc(%ebp)
  802d92:	ff 75 08             	pushl  0x8(%ebp)
  802d95:	e8 0b 04 00 00       	call   8031a5 <sys_getSizeOfSharedObject>
  802d9a:	83 c4 10             	add    $0x10,%esp
  802d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  802da0:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  802da4:	74 76                	je     802e1c <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802da6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802dad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db3:	01 d0                	add    %edx,%eax
  802db5:	48                   	dec    %eax
  802db6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802db9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dbc:	ba 00 00 00 00       	mov    $0x0,%edx
  802dc1:	f7 75 ec             	divl   -0x14(%ebp)
  802dc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc7:	29 d0                	sub    %edx,%eax
  802dc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  802dcc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802dd3:	e8 1e 06 00 00       	call   8033f6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802dd8:	85 c0                	test   %eax,%eax
  802dda:	74 11                	je     802ded <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  802ddc:	83 ec 0c             	sub    $0xc,%esp
  802ddf:	ff 75 e4             	pushl  -0x1c(%ebp)
  802de2:	e8 89 0c 00 00       	call   803a70 <alloc_block_FF>
  802de7:	83 c4 10             	add    $0x10,%esp
  802dea:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  802ded:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df1:	74 29                	je     802e1c <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	8b 40 08             	mov    0x8(%eax),%eax
  802df9:	83 ec 04             	sub    $0x4,%esp
  802dfc:	50                   	push   %eax
  802dfd:	ff 75 0c             	pushl  0xc(%ebp)
  802e00:	ff 75 08             	pushl  0x8(%ebp)
  802e03:	e8 ba 03 00 00       	call   8031c2 <sys_getSharedObject>
  802e08:	83 c4 10             	add    $0x10,%esp
  802e0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  802e0e:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  802e12:	74 08                	je     802e1c <sget+0x9b>
				return (void *)mem_block->sva;
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	8b 40 08             	mov    0x8(%eax),%eax
  802e1a:	eb 05                	jmp    802e21 <sget+0xa0>
		}
	}
	return NULL;
  802e1c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802e21:	c9                   	leave  
  802e22:	c3                   	ret    

00802e23 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802e23:	55                   	push   %ebp
  802e24:	89 e5                	mov    %esp,%ebp
  802e26:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802e29:	e8 5c fb ff ff       	call   80298a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802e2e:	83 ec 04             	sub    $0x4,%esp
  802e31:	68 24 56 80 00       	push   $0x805624
  802e36:	68 f7 00 00 00       	push   $0xf7
  802e3b:	68 f3 55 80 00       	push   $0x8055f3
  802e40:	e8 07 eb ff ff       	call   80194c <_panic>

00802e45 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802e45:	55                   	push   %ebp
  802e46:	89 e5                	mov    %esp,%ebp
  802e48:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802e4b:	83 ec 04             	sub    $0x4,%esp
  802e4e:	68 4c 56 80 00       	push   $0x80564c
  802e53:	68 0c 01 00 00       	push   $0x10c
  802e58:	68 f3 55 80 00       	push   $0x8055f3
  802e5d:	e8 ea ea ff ff       	call   80194c <_panic>

00802e62 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802e62:	55                   	push   %ebp
  802e63:	89 e5                	mov    %esp,%ebp
  802e65:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e68:	83 ec 04             	sub    $0x4,%esp
  802e6b:	68 70 56 80 00       	push   $0x805670
  802e70:	68 44 01 00 00       	push   $0x144
  802e75:	68 f3 55 80 00       	push   $0x8055f3
  802e7a:	e8 cd ea ff ff       	call   80194c <_panic>

00802e7f <shrink>:

}
void shrink(uint32 newSize)
{
  802e7f:	55                   	push   %ebp
  802e80:	89 e5                	mov    %esp,%ebp
  802e82:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e85:	83 ec 04             	sub    $0x4,%esp
  802e88:	68 70 56 80 00       	push   $0x805670
  802e8d:	68 49 01 00 00       	push   $0x149
  802e92:	68 f3 55 80 00       	push   $0x8055f3
  802e97:	e8 b0 ea ff ff       	call   80194c <_panic>

00802e9c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802e9c:	55                   	push   %ebp
  802e9d:	89 e5                	mov    %esp,%ebp
  802e9f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802ea2:	83 ec 04             	sub    $0x4,%esp
  802ea5:	68 70 56 80 00       	push   $0x805670
  802eaa:	68 4e 01 00 00       	push   $0x14e
  802eaf:	68 f3 55 80 00       	push   $0x8055f3
  802eb4:	e8 93 ea ff ff       	call   80194c <_panic>

00802eb9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802eb9:	55                   	push   %ebp
  802eba:	89 e5                	mov    %esp,%ebp
  802ebc:	57                   	push   %edi
  802ebd:	56                   	push   %esi
  802ebe:	53                   	push   %ebx
  802ebf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ec8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ecb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ece:	8b 7d 18             	mov    0x18(%ebp),%edi
  802ed1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802ed4:	cd 30                	int    $0x30
  802ed6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802edc:	83 c4 10             	add    $0x10,%esp
  802edf:	5b                   	pop    %ebx
  802ee0:	5e                   	pop    %esi
  802ee1:	5f                   	pop    %edi
  802ee2:	5d                   	pop    %ebp
  802ee3:	c3                   	ret    

00802ee4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802ee4:	55                   	push   %ebp
  802ee5:	89 e5                	mov    %esp,%ebp
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	8b 45 10             	mov    0x10(%ebp),%eax
  802eed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802ef0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	6a 00                	push   $0x0
  802ef9:	6a 00                	push   $0x0
  802efb:	52                   	push   %edx
  802efc:	ff 75 0c             	pushl  0xc(%ebp)
  802eff:	50                   	push   %eax
  802f00:	6a 00                	push   $0x0
  802f02:	e8 b2 ff ff ff       	call   802eb9 <syscall>
  802f07:	83 c4 18             	add    $0x18,%esp
}
  802f0a:	90                   	nop
  802f0b:	c9                   	leave  
  802f0c:	c3                   	ret    

00802f0d <sys_cgetc>:

int
sys_cgetc(void)
{
  802f0d:	55                   	push   %ebp
  802f0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802f10:	6a 00                	push   $0x0
  802f12:	6a 00                	push   $0x0
  802f14:	6a 00                	push   $0x0
  802f16:	6a 00                	push   $0x0
  802f18:	6a 00                	push   $0x0
  802f1a:	6a 01                	push   $0x1
  802f1c:	e8 98 ff ff ff       	call   802eb9 <syscall>
  802f21:	83 c4 18             	add    $0x18,%esp
}
  802f24:	c9                   	leave  
  802f25:	c3                   	ret    

00802f26 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802f26:	55                   	push   %ebp
  802f27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2f:	6a 00                	push   $0x0
  802f31:	6a 00                	push   $0x0
  802f33:	6a 00                	push   $0x0
  802f35:	52                   	push   %edx
  802f36:	50                   	push   %eax
  802f37:	6a 05                	push   $0x5
  802f39:	e8 7b ff ff ff       	call   802eb9 <syscall>
  802f3e:	83 c4 18             	add    $0x18,%esp
}
  802f41:	c9                   	leave  
  802f42:	c3                   	ret    

00802f43 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f43:	55                   	push   %ebp
  802f44:	89 e5                	mov    %esp,%ebp
  802f46:	56                   	push   %esi
  802f47:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f48:	8b 75 18             	mov    0x18(%ebp),%esi
  802f4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f51:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f54:	8b 45 08             	mov    0x8(%ebp),%eax
  802f57:	56                   	push   %esi
  802f58:	53                   	push   %ebx
  802f59:	51                   	push   %ecx
  802f5a:	52                   	push   %edx
  802f5b:	50                   	push   %eax
  802f5c:	6a 06                	push   $0x6
  802f5e:	e8 56 ff ff ff       	call   802eb9 <syscall>
  802f63:	83 c4 18             	add    $0x18,%esp
}
  802f66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f69:	5b                   	pop    %ebx
  802f6a:	5e                   	pop    %esi
  802f6b:	5d                   	pop    %ebp
  802f6c:	c3                   	ret    

00802f6d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802f6d:	55                   	push   %ebp
  802f6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802f70:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	6a 00                	push   $0x0
  802f78:	6a 00                	push   $0x0
  802f7a:	6a 00                	push   $0x0
  802f7c:	52                   	push   %edx
  802f7d:	50                   	push   %eax
  802f7e:	6a 07                	push   $0x7
  802f80:	e8 34 ff ff ff       	call   802eb9 <syscall>
  802f85:	83 c4 18             	add    $0x18,%esp
}
  802f88:	c9                   	leave  
  802f89:	c3                   	ret    

00802f8a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f8a:	55                   	push   %ebp
  802f8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f8d:	6a 00                	push   $0x0
  802f8f:	6a 00                	push   $0x0
  802f91:	6a 00                	push   $0x0
  802f93:	ff 75 0c             	pushl  0xc(%ebp)
  802f96:	ff 75 08             	pushl  0x8(%ebp)
  802f99:	6a 08                	push   $0x8
  802f9b:	e8 19 ff ff ff       	call   802eb9 <syscall>
  802fa0:	83 c4 18             	add    $0x18,%esp
}
  802fa3:	c9                   	leave  
  802fa4:	c3                   	ret    

00802fa5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802fa5:	55                   	push   %ebp
  802fa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802fa8:	6a 00                	push   $0x0
  802faa:	6a 00                	push   $0x0
  802fac:	6a 00                	push   $0x0
  802fae:	6a 00                	push   $0x0
  802fb0:	6a 00                	push   $0x0
  802fb2:	6a 09                	push   $0x9
  802fb4:	e8 00 ff ff ff       	call   802eb9 <syscall>
  802fb9:	83 c4 18             	add    $0x18,%esp
}
  802fbc:	c9                   	leave  
  802fbd:	c3                   	ret    

00802fbe <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802fbe:	55                   	push   %ebp
  802fbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802fc1:	6a 00                	push   $0x0
  802fc3:	6a 00                	push   $0x0
  802fc5:	6a 00                	push   $0x0
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 00                	push   $0x0
  802fcb:	6a 0a                	push   $0xa
  802fcd:	e8 e7 fe ff ff       	call   802eb9 <syscall>
  802fd2:	83 c4 18             	add    $0x18,%esp
}
  802fd5:	c9                   	leave  
  802fd6:	c3                   	ret    

00802fd7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802fd7:	55                   	push   %ebp
  802fd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802fda:	6a 00                	push   $0x0
  802fdc:	6a 00                	push   $0x0
  802fde:	6a 00                	push   $0x0
  802fe0:	6a 00                	push   $0x0
  802fe2:	6a 00                	push   $0x0
  802fe4:	6a 0b                	push   $0xb
  802fe6:	e8 ce fe ff ff       	call   802eb9 <syscall>
  802feb:	83 c4 18             	add    $0x18,%esp
}
  802fee:	c9                   	leave  
  802fef:	c3                   	ret    

00802ff0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802ff0:	55                   	push   %ebp
  802ff1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802ff3:	6a 00                	push   $0x0
  802ff5:	6a 00                	push   $0x0
  802ff7:	6a 00                	push   $0x0
  802ff9:	ff 75 0c             	pushl  0xc(%ebp)
  802ffc:	ff 75 08             	pushl  0x8(%ebp)
  802fff:	6a 0f                	push   $0xf
  803001:	e8 b3 fe ff ff       	call   802eb9 <syscall>
  803006:	83 c4 18             	add    $0x18,%esp
	return;
  803009:	90                   	nop
}
  80300a:	c9                   	leave  
  80300b:	c3                   	ret    

0080300c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80300c:	55                   	push   %ebp
  80300d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80300f:	6a 00                	push   $0x0
  803011:	6a 00                	push   $0x0
  803013:	6a 00                	push   $0x0
  803015:	ff 75 0c             	pushl  0xc(%ebp)
  803018:	ff 75 08             	pushl  0x8(%ebp)
  80301b:	6a 10                	push   $0x10
  80301d:	e8 97 fe ff ff       	call   802eb9 <syscall>
  803022:	83 c4 18             	add    $0x18,%esp
	return ;
  803025:	90                   	nop
}
  803026:	c9                   	leave  
  803027:	c3                   	ret    

00803028 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803028:	55                   	push   %ebp
  803029:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80302b:	6a 00                	push   $0x0
  80302d:	6a 00                	push   $0x0
  80302f:	ff 75 10             	pushl  0x10(%ebp)
  803032:	ff 75 0c             	pushl  0xc(%ebp)
  803035:	ff 75 08             	pushl  0x8(%ebp)
  803038:	6a 11                	push   $0x11
  80303a:	e8 7a fe ff ff       	call   802eb9 <syscall>
  80303f:	83 c4 18             	add    $0x18,%esp
	return ;
  803042:	90                   	nop
}
  803043:	c9                   	leave  
  803044:	c3                   	ret    

00803045 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  803045:	55                   	push   %ebp
  803046:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  803048:	6a 00                	push   $0x0
  80304a:	6a 00                	push   $0x0
  80304c:	6a 00                	push   $0x0
  80304e:	6a 00                	push   $0x0
  803050:	6a 00                	push   $0x0
  803052:	6a 0c                	push   $0xc
  803054:	e8 60 fe ff ff       	call   802eb9 <syscall>
  803059:	83 c4 18             	add    $0x18,%esp
}
  80305c:	c9                   	leave  
  80305d:	c3                   	ret    

0080305e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80305e:	55                   	push   %ebp
  80305f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803061:	6a 00                	push   $0x0
  803063:	6a 00                	push   $0x0
  803065:	6a 00                	push   $0x0
  803067:	6a 00                	push   $0x0
  803069:	ff 75 08             	pushl  0x8(%ebp)
  80306c:	6a 0d                	push   $0xd
  80306e:	e8 46 fe ff ff       	call   802eb9 <syscall>
  803073:	83 c4 18             	add    $0x18,%esp
}
  803076:	c9                   	leave  
  803077:	c3                   	ret    

00803078 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803078:	55                   	push   %ebp
  803079:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80307b:	6a 00                	push   $0x0
  80307d:	6a 00                	push   $0x0
  80307f:	6a 00                	push   $0x0
  803081:	6a 00                	push   $0x0
  803083:	6a 00                	push   $0x0
  803085:	6a 0e                	push   $0xe
  803087:	e8 2d fe ff ff       	call   802eb9 <syscall>
  80308c:	83 c4 18             	add    $0x18,%esp
}
  80308f:	90                   	nop
  803090:	c9                   	leave  
  803091:	c3                   	ret    

00803092 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  803092:	55                   	push   %ebp
  803093:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  803095:	6a 00                	push   $0x0
  803097:	6a 00                	push   $0x0
  803099:	6a 00                	push   $0x0
  80309b:	6a 00                	push   $0x0
  80309d:	6a 00                	push   $0x0
  80309f:	6a 13                	push   $0x13
  8030a1:	e8 13 fe ff ff       	call   802eb9 <syscall>
  8030a6:	83 c4 18             	add    $0x18,%esp
}
  8030a9:	90                   	nop
  8030aa:	c9                   	leave  
  8030ab:	c3                   	ret    

008030ac <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8030ac:	55                   	push   %ebp
  8030ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8030af:	6a 00                	push   $0x0
  8030b1:	6a 00                	push   $0x0
  8030b3:	6a 00                	push   $0x0
  8030b5:	6a 00                	push   $0x0
  8030b7:	6a 00                	push   $0x0
  8030b9:	6a 14                	push   $0x14
  8030bb:	e8 f9 fd ff ff       	call   802eb9 <syscall>
  8030c0:	83 c4 18             	add    $0x18,%esp
}
  8030c3:	90                   	nop
  8030c4:	c9                   	leave  
  8030c5:	c3                   	ret    

008030c6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8030c6:	55                   	push   %ebp
  8030c7:	89 e5                	mov    %esp,%ebp
  8030c9:	83 ec 04             	sub    $0x4,%esp
  8030cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8030d2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8030d6:	6a 00                	push   $0x0
  8030d8:	6a 00                	push   $0x0
  8030da:	6a 00                	push   $0x0
  8030dc:	6a 00                	push   $0x0
  8030de:	50                   	push   %eax
  8030df:	6a 15                	push   $0x15
  8030e1:	e8 d3 fd ff ff       	call   802eb9 <syscall>
  8030e6:	83 c4 18             	add    $0x18,%esp
}
  8030e9:	90                   	nop
  8030ea:	c9                   	leave  
  8030eb:	c3                   	ret    

008030ec <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8030ec:	55                   	push   %ebp
  8030ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8030ef:	6a 00                	push   $0x0
  8030f1:	6a 00                	push   $0x0
  8030f3:	6a 00                	push   $0x0
  8030f5:	6a 00                	push   $0x0
  8030f7:	6a 00                	push   $0x0
  8030f9:	6a 16                	push   $0x16
  8030fb:	e8 b9 fd ff ff       	call   802eb9 <syscall>
  803100:	83 c4 18             	add    $0x18,%esp
}
  803103:	90                   	nop
  803104:	c9                   	leave  
  803105:	c3                   	ret    

00803106 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  803106:	55                   	push   %ebp
  803107:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	6a 00                	push   $0x0
  80310e:	6a 00                	push   $0x0
  803110:	6a 00                	push   $0x0
  803112:	ff 75 0c             	pushl  0xc(%ebp)
  803115:	50                   	push   %eax
  803116:	6a 17                	push   $0x17
  803118:	e8 9c fd ff ff       	call   802eb9 <syscall>
  80311d:	83 c4 18             	add    $0x18,%esp
}
  803120:	c9                   	leave  
  803121:	c3                   	ret    

00803122 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  803122:	55                   	push   %ebp
  803123:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  803125:	8b 55 0c             	mov    0xc(%ebp),%edx
  803128:	8b 45 08             	mov    0x8(%ebp),%eax
  80312b:	6a 00                	push   $0x0
  80312d:	6a 00                	push   $0x0
  80312f:	6a 00                	push   $0x0
  803131:	52                   	push   %edx
  803132:	50                   	push   %eax
  803133:	6a 1a                	push   $0x1a
  803135:	e8 7f fd ff ff       	call   802eb9 <syscall>
  80313a:	83 c4 18             	add    $0x18,%esp
}
  80313d:	c9                   	leave  
  80313e:	c3                   	ret    

0080313f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80313f:	55                   	push   %ebp
  803140:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  803142:	8b 55 0c             	mov    0xc(%ebp),%edx
  803145:	8b 45 08             	mov    0x8(%ebp),%eax
  803148:	6a 00                	push   $0x0
  80314a:	6a 00                	push   $0x0
  80314c:	6a 00                	push   $0x0
  80314e:	52                   	push   %edx
  80314f:	50                   	push   %eax
  803150:	6a 18                	push   $0x18
  803152:	e8 62 fd ff ff       	call   802eb9 <syscall>
  803157:	83 c4 18             	add    $0x18,%esp
}
  80315a:	90                   	nop
  80315b:	c9                   	leave  
  80315c:	c3                   	ret    

0080315d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80315d:	55                   	push   %ebp
  80315e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  803160:	8b 55 0c             	mov    0xc(%ebp),%edx
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	6a 00                	push   $0x0
  803168:	6a 00                	push   $0x0
  80316a:	6a 00                	push   $0x0
  80316c:	52                   	push   %edx
  80316d:	50                   	push   %eax
  80316e:	6a 19                	push   $0x19
  803170:	e8 44 fd ff ff       	call   802eb9 <syscall>
  803175:	83 c4 18             	add    $0x18,%esp
}
  803178:	90                   	nop
  803179:	c9                   	leave  
  80317a:	c3                   	ret    

0080317b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80317b:	55                   	push   %ebp
  80317c:	89 e5                	mov    %esp,%ebp
  80317e:	83 ec 04             	sub    $0x4,%esp
  803181:	8b 45 10             	mov    0x10(%ebp),%eax
  803184:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803187:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80318a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80318e:	8b 45 08             	mov    0x8(%ebp),%eax
  803191:	6a 00                	push   $0x0
  803193:	51                   	push   %ecx
  803194:	52                   	push   %edx
  803195:	ff 75 0c             	pushl  0xc(%ebp)
  803198:	50                   	push   %eax
  803199:	6a 1b                	push   $0x1b
  80319b:	e8 19 fd ff ff       	call   802eb9 <syscall>
  8031a0:	83 c4 18             	add    $0x18,%esp
}
  8031a3:	c9                   	leave  
  8031a4:	c3                   	ret    

008031a5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8031a5:	55                   	push   %ebp
  8031a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8031a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ae:	6a 00                	push   $0x0
  8031b0:	6a 00                	push   $0x0
  8031b2:	6a 00                	push   $0x0
  8031b4:	52                   	push   %edx
  8031b5:	50                   	push   %eax
  8031b6:	6a 1c                	push   $0x1c
  8031b8:	e8 fc fc ff ff       	call   802eb9 <syscall>
  8031bd:	83 c4 18             	add    $0x18,%esp
}
  8031c0:	c9                   	leave  
  8031c1:	c3                   	ret    

008031c2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8031c2:	55                   	push   %ebp
  8031c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8031c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	6a 00                	push   $0x0
  8031d0:	6a 00                	push   $0x0
  8031d2:	51                   	push   %ecx
  8031d3:	52                   	push   %edx
  8031d4:	50                   	push   %eax
  8031d5:	6a 1d                	push   $0x1d
  8031d7:	e8 dd fc ff ff       	call   802eb9 <syscall>
  8031dc:	83 c4 18             	add    $0x18,%esp
}
  8031df:	c9                   	leave  
  8031e0:	c3                   	ret    

008031e1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8031e1:	55                   	push   %ebp
  8031e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8031e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	6a 00                	push   $0x0
  8031ec:	6a 00                	push   $0x0
  8031ee:	6a 00                	push   $0x0
  8031f0:	52                   	push   %edx
  8031f1:	50                   	push   %eax
  8031f2:	6a 1e                	push   $0x1e
  8031f4:	e8 c0 fc ff ff       	call   802eb9 <syscall>
  8031f9:	83 c4 18             	add    $0x18,%esp
}
  8031fc:	c9                   	leave  
  8031fd:	c3                   	ret    

008031fe <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8031fe:	55                   	push   %ebp
  8031ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  803201:	6a 00                	push   $0x0
  803203:	6a 00                	push   $0x0
  803205:	6a 00                	push   $0x0
  803207:	6a 00                	push   $0x0
  803209:	6a 00                	push   $0x0
  80320b:	6a 1f                	push   $0x1f
  80320d:	e8 a7 fc ff ff       	call   802eb9 <syscall>
  803212:	83 c4 18             	add    $0x18,%esp
}
  803215:	c9                   	leave  
  803216:	c3                   	ret    

00803217 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  803217:	55                   	push   %ebp
  803218:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80321a:	8b 45 08             	mov    0x8(%ebp),%eax
  80321d:	6a 00                	push   $0x0
  80321f:	ff 75 14             	pushl  0x14(%ebp)
  803222:	ff 75 10             	pushl  0x10(%ebp)
  803225:	ff 75 0c             	pushl  0xc(%ebp)
  803228:	50                   	push   %eax
  803229:	6a 20                	push   $0x20
  80322b:	e8 89 fc ff ff       	call   802eb9 <syscall>
  803230:	83 c4 18             	add    $0x18,%esp
}
  803233:	c9                   	leave  
  803234:	c3                   	ret    

00803235 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  803235:	55                   	push   %ebp
  803236:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  803238:	8b 45 08             	mov    0x8(%ebp),%eax
  80323b:	6a 00                	push   $0x0
  80323d:	6a 00                	push   $0x0
  80323f:	6a 00                	push   $0x0
  803241:	6a 00                	push   $0x0
  803243:	50                   	push   %eax
  803244:	6a 21                	push   $0x21
  803246:	e8 6e fc ff ff       	call   802eb9 <syscall>
  80324b:	83 c4 18             	add    $0x18,%esp
}
  80324e:	90                   	nop
  80324f:	c9                   	leave  
  803250:	c3                   	ret    

00803251 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803251:	55                   	push   %ebp
  803252:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  803254:	8b 45 08             	mov    0x8(%ebp),%eax
  803257:	6a 00                	push   $0x0
  803259:	6a 00                	push   $0x0
  80325b:	6a 00                	push   $0x0
  80325d:	6a 00                	push   $0x0
  80325f:	50                   	push   %eax
  803260:	6a 22                	push   $0x22
  803262:	e8 52 fc ff ff       	call   802eb9 <syscall>
  803267:	83 c4 18             	add    $0x18,%esp
}
  80326a:	c9                   	leave  
  80326b:	c3                   	ret    

0080326c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80326c:	55                   	push   %ebp
  80326d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80326f:	6a 00                	push   $0x0
  803271:	6a 00                	push   $0x0
  803273:	6a 00                	push   $0x0
  803275:	6a 00                	push   $0x0
  803277:	6a 00                	push   $0x0
  803279:	6a 02                	push   $0x2
  80327b:	e8 39 fc ff ff       	call   802eb9 <syscall>
  803280:	83 c4 18             	add    $0x18,%esp
}
  803283:	c9                   	leave  
  803284:	c3                   	ret    

00803285 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  803285:	55                   	push   %ebp
  803286:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803288:	6a 00                	push   $0x0
  80328a:	6a 00                	push   $0x0
  80328c:	6a 00                	push   $0x0
  80328e:	6a 00                	push   $0x0
  803290:	6a 00                	push   $0x0
  803292:	6a 03                	push   $0x3
  803294:	e8 20 fc ff ff       	call   802eb9 <syscall>
  803299:	83 c4 18             	add    $0x18,%esp
}
  80329c:	c9                   	leave  
  80329d:	c3                   	ret    

0080329e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80329e:	55                   	push   %ebp
  80329f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8032a1:	6a 00                	push   $0x0
  8032a3:	6a 00                	push   $0x0
  8032a5:	6a 00                	push   $0x0
  8032a7:	6a 00                	push   $0x0
  8032a9:	6a 00                	push   $0x0
  8032ab:	6a 04                	push   $0x4
  8032ad:	e8 07 fc ff ff       	call   802eb9 <syscall>
  8032b2:	83 c4 18             	add    $0x18,%esp
}
  8032b5:	c9                   	leave  
  8032b6:	c3                   	ret    

008032b7 <sys_exit_env>:


void sys_exit_env(void)
{
  8032b7:	55                   	push   %ebp
  8032b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8032ba:	6a 00                	push   $0x0
  8032bc:	6a 00                	push   $0x0
  8032be:	6a 00                	push   $0x0
  8032c0:	6a 00                	push   $0x0
  8032c2:	6a 00                	push   $0x0
  8032c4:	6a 23                	push   $0x23
  8032c6:	e8 ee fb ff ff       	call   802eb9 <syscall>
  8032cb:	83 c4 18             	add    $0x18,%esp
}
  8032ce:	90                   	nop
  8032cf:	c9                   	leave  
  8032d0:	c3                   	ret    

008032d1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8032d1:	55                   	push   %ebp
  8032d2:	89 e5                	mov    %esp,%ebp
  8032d4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8032d7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032da:	8d 50 04             	lea    0x4(%eax),%edx
  8032dd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032e0:	6a 00                	push   $0x0
  8032e2:	6a 00                	push   $0x0
  8032e4:	6a 00                	push   $0x0
  8032e6:	52                   	push   %edx
  8032e7:	50                   	push   %eax
  8032e8:	6a 24                	push   $0x24
  8032ea:	e8 ca fb ff ff       	call   802eb9 <syscall>
  8032ef:	83 c4 18             	add    $0x18,%esp
	return result;
  8032f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8032f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8032f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032fb:	89 01                	mov    %eax,(%ecx)
  8032fd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803300:	8b 45 08             	mov    0x8(%ebp),%eax
  803303:	c9                   	leave  
  803304:	c2 04 00             	ret    $0x4

00803307 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  803307:	55                   	push   %ebp
  803308:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80330a:	6a 00                	push   $0x0
  80330c:	6a 00                	push   $0x0
  80330e:	ff 75 10             	pushl  0x10(%ebp)
  803311:	ff 75 0c             	pushl  0xc(%ebp)
  803314:	ff 75 08             	pushl  0x8(%ebp)
  803317:	6a 12                	push   $0x12
  803319:	e8 9b fb ff ff       	call   802eb9 <syscall>
  80331e:	83 c4 18             	add    $0x18,%esp
	return ;
  803321:	90                   	nop
}
  803322:	c9                   	leave  
  803323:	c3                   	ret    

00803324 <sys_rcr2>:
uint32 sys_rcr2()
{
  803324:	55                   	push   %ebp
  803325:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803327:	6a 00                	push   $0x0
  803329:	6a 00                	push   $0x0
  80332b:	6a 00                	push   $0x0
  80332d:	6a 00                	push   $0x0
  80332f:	6a 00                	push   $0x0
  803331:	6a 25                	push   $0x25
  803333:	e8 81 fb ff ff       	call   802eb9 <syscall>
  803338:	83 c4 18             	add    $0x18,%esp
}
  80333b:	c9                   	leave  
  80333c:	c3                   	ret    

0080333d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80333d:	55                   	push   %ebp
  80333e:	89 e5                	mov    %esp,%ebp
  803340:	83 ec 04             	sub    $0x4,%esp
  803343:	8b 45 08             	mov    0x8(%ebp),%eax
  803346:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803349:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80334d:	6a 00                	push   $0x0
  80334f:	6a 00                	push   $0x0
  803351:	6a 00                	push   $0x0
  803353:	6a 00                	push   $0x0
  803355:	50                   	push   %eax
  803356:	6a 26                	push   $0x26
  803358:	e8 5c fb ff ff       	call   802eb9 <syscall>
  80335d:	83 c4 18             	add    $0x18,%esp
	return ;
  803360:	90                   	nop
}
  803361:	c9                   	leave  
  803362:	c3                   	ret    

00803363 <rsttst>:
void rsttst()
{
  803363:	55                   	push   %ebp
  803364:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803366:	6a 00                	push   $0x0
  803368:	6a 00                	push   $0x0
  80336a:	6a 00                	push   $0x0
  80336c:	6a 00                	push   $0x0
  80336e:	6a 00                	push   $0x0
  803370:	6a 28                	push   $0x28
  803372:	e8 42 fb ff ff       	call   802eb9 <syscall>
  803377:	83 c4 18             	add    $0x18,%esp
	return ;
  80337a:	90                   	nop
}
  80337b:	c9                   	leave  
  80337c:	c3                   	ret    

0080337d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80337d:	55                   	push   %ebp
  80337e:	89 e5                	mov    %esp,%ebp
  803380:	83 ec 04             	sub    $0x4,%esp
  803383:	8b 45 14             	mov    0x14(%ebp),%eax
  803386:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803389:	8b 55 18             	mov    0x18(%ebp),%edx
  80338c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803390:	52                   	push   %edx
  803391:	50                   	push   %eax
  803392:	ff 75 10             	pushl  0x10(%ebp)
  803395:	ff 75 0c             	pushl  0xc(%ebp)
  803398:	ff 75 08             	pushl  0x8(%ebp)
  80339b:	6a 27                	push   $0x27
  80339d:	e8 17 fb ff ff       	call   802eb9 <syscall>
  8033a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8033a5:	90                   	nop
}
  8033a6:	c9                   	leave  
  8033a7:	c3                   	ret    

008033a8 <chktst>:
void chktst(uint32 n)
{
  8033a8:	55                   	push   %ebp
  8033a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8033ab:	6a 00                	push   $0x0
  8033ad:	6a 00                	push   $0x0
  8033af:	6a 00                	push   $0x0
  8033b1:	6a 00                	push   $0x0
  8033b3:	ff 75 08             	pushl  0x8(%ebp)
  8033b6:	6a 29                	push   $0x29
  8033b8:	e8 fc fa ff ff       	call   802eb9 <syscall>
  8033bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8033c0:	90                   	nop
}
  8033c1:	c9                   	leave  
  8033c2:	c3                   	ret    

008033c3 <inctst>:

void inctst()
{
  8033c3:	55                   	push   %ebp
  8033c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8033c6:	6a 00                	push   $0x0
  8033c8:	6a 00                	push   $0x0
  8033ca:	6a 00                	push   $0x0
  8033cc:	6a 00                	push   $0x0
  8033ce:	6a 00                	push   $0x0
  8033d0:	6a 2a                	push   $0x2a
  8033d2:	e8 e2 fa ff ff       	call   802eb9 <syscall>
  8033d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8033da:	90                   	nop
}
  8033db:	c9                   	leave  
  8033dc:	c3                   	ret    

008033dd <gettst>:
uint32 gettst()
{
  8033dd:	55                   	push   %ebp
  8033de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8033e0:	6a 00                	push   $0x0
  8033e2:	6a 00                	push   $0x0
  8033e4:	6a 00                	push   $0x0
  8033e6:	6a 00                	push   $0x0
  8033e8:	6a 00                	push   $0x0
  8033ea:	6a 2b                	push   $0x2b
  8033ec:	e8 c8 fa ff ff       	call   802eb9 <syscall>
  8033f1:	83 c4 18             	add    $0x18,%esp
}
  8033f4:	c9                   	leave  
  8033f5:	c3                   	ret    

008033f6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8033f6:	55                   	push   %ebp
  8033f7:	89 e5                	mov    %esp,%ebp
  8033f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8033fc:	6a 00                	push   $0x0
  8033fe:	6a 00                	push   $0x0
  803400:	6a 00                	push   $0x0
  803402:	6a 00                	push   $0x0
  803404:	6a 00                	push   $0x0
  803406:	6a 2c                	push   $0x2c
  803408:	e8 ac fa ff ff       	call   802eb9 <syscall>
  80340d:	83 c4 18             	add    $0x18,%esp
  803410:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  803413:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  803417:	75 07                	jne    803420 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  803419:	b8 01 00 00 00       	mov    $0x1,%eax
  80341e:	eb 05                	jmp    803425 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  803420:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803425:	c9                   	leave  
  803426:	c3                   	ret    

00803427 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  803427:	55                   	push   %ebp
  803428:	89 e5                	mov    %esp,%ebp
  80342a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80342d:	6a 00                	push   $0x0
  80342f:	6a 00                	push   $0x0
  803431:	6a 00                	push   $0x0
  803433:	6a 00                	push   $0x0
  803435:	6a 00                	push   $0x0
  803437:	6a 2c                	push   $0x2c
  803439:	e8 7b fa ff ff       	call   802eb9 <syscall>
  80343e:	83 c4 18             	add    $0x18,%esp
  803441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  803444:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  803448:	75 07                	jne    803451 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80344a:	b8 01 00 00 00       	mov    $0x1,%eax
  80344f:	eb 05                	jmp    803456 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  803451:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803456:	c9                   	leave  
  803457:	c3                   	ret    

00803458 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  803458:	55                   	push   %ebp
  803459:	89 e5                	mov    %esp,%ebp
  80345b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80345e:	6a 00                	push   $0x0
  803460:	6a 00                	push   $0x0
  803462:	6a 00                	push   $0x0
  803464:	6a 00                	push   $0x0
  803466:	6a 00                	push   $0x0
  803468:	6a 2c                	push   $0x2c
  80346a:	e8 4a fa ff ff       	call   802eb9 <syscall>
  80346f:	83 c4 18             	add    $0x18,%esp
  803472:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  803475:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  803479:	75 07                	jne    803482 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80347b:	b8 01 00 00 00       	mov    $0x1,%eax
  803480:	eb 05                	jmp    803487 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803487:	c9                   	leave  
  803488:	c3                   	ret    

00803489 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  803489:	55                   	push   %ebp
  80348a:	89 e5                	mov    %esp,%ebp
  80348c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80348f:	6a 00                	push   $0x0
  803491:	6a 00                	push   $0x0
  803493:	6a 00                	push   $0x0
  803495:	6a 00                	push   $0x0
  803497:	6a 00                	push   $0x0
  803499:	6a 2c                	push   $0x2c
  80349b:	e8 19 fa ff ff       	call   802eb9 <syscall>
  8034a0:	83 c4 18             	add    $0x18,%esp
  8034a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8034a6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8034aa:	75 07                	jne    8034b3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8034ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8034b1:	eb 05                	jmp    8034b8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8034b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034b8:	c9                   	leave  
  8034b9:	c3                   	ret    

008034ba <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8034ba:	55                   	push   %ebp
  8034bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8034bd:	6a 00                	push   $0x0
  8034bf:	6a 00                	push   $0x0
  8034c1:	6a 00                	push   $0x0
  8034c3:	6a 00                	push   $0x0
  8034c5:	ff 75 08             	pushl  0x8(%ebp)
  8034c8:	6a 2d                	push   $0x2d
  8034ca:	e8 ea f9 ff ff       	call   802eb9 <syscall>
  8034cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8034d2:	90                   	nop
}
  8034d3:	c9                   	leave  
  8034d4:	c3                   	ret    

008034d5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8034d5:	55                   	push   %ebp
  8034d6:	89 e5                	mov    %esp,%ebp
  8034d8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8034d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8034dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8034df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	6a 00                	push   $0x0
  8034e7:	53                   	push   %ebx
  8034e8:	51                   	push   %ecx
  8034e9:	52                   	push   %edx
  8034ea:	50                   	push   %eax
  8034eb:	6a 2e                	push   $0x2e
  8034ed:	e8 c7 f9 ff ff       	call   802eb9 <syscall>
  8034f2:	83 c4 18             	add    $0x18,%esp
}
  8034f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034f8:	c9                   	leave  
  8034f9:	c3                   	ret    

008034fa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8034fa:	55                   	push   %ebp
  8034fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8034fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  803500:	8b 45 08             	mov    0x8(%ebp),%eax
  803503:	6a 00                	push   $0x0
  803505:	6a 00                	push   $0x0
  803507:	6a 00                	push   $0x0
  803509:	52                   	push   %edx
  80350a:	50                   	push   %eax
  80350b:	6a 2f                	push   $0x2f
  80350d:	e8 a7 f9 ff ff       	call   802eb9 <syscall>
  803512:	83 c4 18             	add    $0x18,%esp
}
  803515:	c9                   	leave  
  803516:	c3                   	ret    

00803517 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  803517:	55                   	push   %ebp
  803518:	89 e5                	mov    %esp,%ebp
  80351a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80351d:	83 ec 0c             	sub    $0xc,%esp
  803520:	68 80 56 80 00       	push   $0x805680
  803525:	e8 d6 e6 ff ff       	call   801c00 <cprintf>
  80352a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80352d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  803534:	83 ec 0c             	sub    $0xc,%esp
  803537:	68 ac 56 80 00       	push   $0x8056ac
  80353c:	e8 bf e6 ff ff       	call   801c00 <cprintf>
  803541:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  803544:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803548:	a1 38 61 80 00       	mov    0x806138,%eax
  80354d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803550:	eb 56                	jmp    8035a8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803552:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803556:	74 1c                	je     803574 <print_mem_block_lists+0x5d>
  803558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355b:	8b 50 08             	mov    0x8(%eax),%edx
  80355e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803561:	8b 48 08             	mov    0x8(%eax),%ecx
  803564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803567:	8b 40 0c             	mov    0xc(%eax),%eax
  80356a:	01 c8                	add    %ecx,%eax
  80356c:	39 c2                	cmp    %eax,%edx
  80356e:	73 04                	jae    803574 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  803570:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803577:	8b 50 08             	mov    0x8(%eax),%edx
  80357a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357d:	8b 40 0c             	mov    0xc(%eax),%eax
  803580:	01 c2                	add    %eax,%edx
  803582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803585:	8b 40 08             	mov    0x8(%eax),%eax
  803588:	83 ec 04             	sub    $0x4,%esp
  80358b:	52                   	push   %edx
  80358c:	50                   	push   %eax
  80358d:	68 c1 56 80 00       	push   $0x8056c1
  803592:	e8 69 e6 ff ff       	call   801c00 <cprintf>
  803597:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80359a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8035a0:	a1 40 61 80 00       	mov    0x806140,%eax
  8035a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ac:	74 07                	je     8035b5 <print_mem_block_lists+0x9e>
  8035ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b1:	8b 00                	mov    (%eax),%eax
  8035b3:	eb 05                	jmp    8035ba <print_mem_block_lists+0xa3>
  8035b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ba:	a3 40 61 80 00       	mov    %eax,0x806140
  8035bf:	a1 40 61 80 00       	mov    0x806140,%eax
  8035c4:	85 c0                	test   %eax,%eax
  8035c6:	75 8a                	jne    803552 <print_mem_block_lists+0x3b>
  8035c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035cc:	75 84                	jne    803552 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8035ce:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8035d2:	75 10                	jne    8035e4 <print_mem_block_lists+0xcd>
  8035d4:	83 ec 0c             	sub    $0xc,%esp
  8035d7:	68 d0 56 80 00       	push   $0x8056d0
  8035dc:	e8 1f e6 ff ff       	call   801c00 <cprintf>
  8035e1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8035e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8035eb:	83 ec 0c             	sub    $0xc,%esp
  8035ee:	68 f4 56 80 00       	push   $0x8056f4
  8035f3:	e8 08 e6 ff ff       	call   801c00 <cprintf>
  8035f8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8035fb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8035ff:	a1 40 60 80 00       	mov    0x806040,%eax
  803604:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803607:	eb 56                	jmp    80365f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803609:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80360d:	74 1c                	je     80362b <print_mem_block_lists+0x114>
  80360f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803612:	8b 50 08             	mov    0x8(%eax),%edx
  803615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803618:	8b 48 08             	mov    0x8(%eax),%ecx
  80361b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361e:	8b 40 0c             	mov    0xc(%eax),%eax
  803621:	01 c8                	add    %ecx,%eax
  803623:	39 c2                	cmp    %eax,%edx
  803625:	73 04                	jae    80362b <print_mem_block_lists+0x114>
			sorted = 0 ;
  803627:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80362b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362e:	8b 50 08             	mov    0x8(%eax),%edx
  803631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803634:	8b 40 0c             	mov    0xc(%eax),%eax
  803637:	01 c2                	add    %eax,%edx
  803639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363c:	8b 40 08             	mov    0x8(%eax),%eax
  80363f:	83 ec 04             	sub    $0x4,%esp
  803642:	52                   	push   %edx
  803643:	50                   	push   %eax
  803644:	68 c1 56 80 00       	push   $0x8056c1
  803649:	e8 b2 e5 ff ff       	call   801c00 <cprintf>
  80364e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803654:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803657:	a1 48 60 80 00       	mov    0x806048,%eax
  80365c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80365f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803663:	74 07                	je     80366c <print_mem_block_lists+0x155>
  803665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803668:	8b 00                	mov    (%eax),%eax
  80366a:	eb 05                	jmp    803671 <print_mem_block_lists+0x15a>
  80366c:	b8 00 00 00 00       	mov    $0x0,%eax
  803671:	a3 48 60 80 00       	mov    %eax,0x806048
  803676:	a1 48 60 80 00       	mov    0x806048,%eax
  80367b:	85 c0                	test   %eax,%eax
  80367d:	75 8a                	jne    803609 <print_mem_block_lists+0xf2>
  80367f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803683:	75 84                	jne    803609 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  803685:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803689:	75 10                	jne    80369b <print_mem_block_lists+0x184>
  80368b:	83 ec 0c             	sub    $0xc,%esp
  80368e:	68 0c 57 80 00       	push   $0x80570c
  803693:	e8 68 e5 ff ff       	call   801c00 <cprintf>
  803698:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80369b:	83 ec 0c             	sub    $0xc,%esp
  80369e:	68 80 56 80 00       	push   $0x805680
  8036a3:	e8 58 e5 ff ff       	call   801c00 <cprintf>
  8036a8:	83 c4 10             	add    $0x10,%esp

}
  8036ab:	90                   	nop
  8036ac:	c9                   	leave  
  8036ad:	c3                   	ret    

008036ae <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8036ae:	55                   	push   %ebp
  8036af:	89 e5                	mov    %esp,%ebp
  8036b1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8036b4:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  8036bb:	00 00 00 
  8036be:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  8036c5:	00 00 00 
  8036c8:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  8036cf:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8036d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8036d9:	e9 9e 00 00 00       	jmp    80377c <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8036de:	a1 50 60 80 00       	mov    0x806050,%eax
  8036e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036e6:	c1 e2 04             	shl    $0x4,%edx
  8036e9:	01 d0                	add    %edx,%eax
  8036eb:	85 c0                	test   %eax,%eax
  8036ed:	75 14                	jne    803703 <initialize_MemBlocksList+0x55>
  8036ef:	83 ec 04             	sub    $0x4,%esp
  8036f2:	68 34 57 80 00       	push   $0x805734
  8036f7:	6a 46                	push   $0x46
  8036f9:	68 57 57 80 00       	push   $0x805757
  8036fe:	e8 49 e2 ff ff       	call   80194c <_panic>
  803703:	a1 50 60 80 00       	mov    0x806050,%eax
  803708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80370b:	c1 e2 04             	shl    $0x4,%edx
  80370e:	01 d0                	add    %edx,%eax
  803710:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803716:	89 10                	mov    %edx,(%eax)
  803718:	8b 00                	mov    (%eax),%eax
  80371a:	85 c0                	test   %eax,%eax
  80371c:	74 18                	je     803736 <initialize_MemBlocksList+0x88>
  80371e:	a1 48 61 80 00       	mov    0x806148,%eax
  803723:	8b 15 50 60 80 00    	mov    0x806050,%edx
  803729:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80372c:	c1 e1 04             	shl    $0x4,%ecx
  80372f:	01 ca                	add    %ecx,%edx
  803731:	89 50 04             	mov    %edx,0x4(%eax)
  803734:	eb 12                	jmp    803748 <initialize_MemBlocksList+0x9a>
  803736:	a1 50 60 80 00       	mov    0x806050,%eax
  80373b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80373e:	c1 e2 04             	shl    $0x4,%edx
  803741:	01 d0                	add    %edx,%eax
  803743:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803748:	a1 50 60 80 00       	mov    0x806050,%eax
  80374d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803750:	c1 e2 04             	shl    $0x4,%edx
  803753:	01 d0                	add    %edx,%eax
  803755:	a3 48 61 80 00       	mov    %eax,0x806148
  80375a:	a1 50 60 80 00       	mov    0x806050,%eax
  80375f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803762:	c1 e2 04             	shl    $0x4,%edx
  803765:	01 d0                	add    %edx,%eax
  803767:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80376e:	a1 54 61 80 00       	mov    0x806154,%eax
  803773:	40                   	inc    %eax
  803774:	a3 54 61 80 00       	mov    %eax,0x806154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  803779:	ff 45 f4             	incl   -0xc(%ebp)
  80377c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803782:	0f 82 56 ff ff ff    	jb     8036de <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  803788:	90                   	nop
  803789:	c9                   	leave  
  80378a:	c3                   	ret    

0080378b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80378b:	55                   	push   %ebp
  80378c:	89 e5                	mov    %esp,%ebp
  80378e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  803791:	8b 45 08             	mov    0x8(%ebp),%eax
  803794:	8b 00                	mov    (%eax),%eax
  803796:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803799:	eb 19                	jmp    8037b4 <find_block+0x29>
	{
		if(va==point->sva)
  80379b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80379e:	8b 40 08             	mov    0x8(%eax),%eax
  8037a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8037a4:	75 05                	jne    8037ab <find_block+0x20>
		   return point;
  8037a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037a9:	eb 36                	jmp    8037e1 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8037ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ae:	8b 40 08             	mov    0x8(%eax),%eax
  8037b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8037b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8037b8:	74 07                	je     8037c1 <find_block+0x36>
  8037ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037bd:	8b 00                	mov    (%eax),%eax
  8037bf:	eb 05                	jmp    8037c6 <find_block+0x3b>
  8037c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8037c9:	89 42 08             	mov    %eax,0x8(%edx)
  8037cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cf:	8b 40 08             	mov    0x8(%eax),%eax
  8037d2:	85 c0                	test   %eax,%eax
  8037d4:	75 c5                	jne    80379b <find_block+0x10>
  8037d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8037da:	75 bf                	jne    80379b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8037dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037e1:	c9                   	leave  
  8037e2:	c3                   	ret    

008037e3 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8037e3:	55                   	push   %ebp
  8037e4:	89 e5                	mov    %esp,%ebp
  8037e6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8037e9:	a1 40 60 80 00       	mov    0x806040,%eax
  8037ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8037f1:	a1 44 60 80 00       	mov    0x806044,%eax
  8037f6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8037f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8037ff:	74 24                	je     803825 <insert_sorted_allocList+0x42>
  803801:	8b 45 08             	mov    0x8(%ebp),%eax
  803804:	8b 50 08             	mov    0x8(%eax),%edx
  803807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80380a:	8b 40 08             	mov    0x8(%eax),%eax
  80380d:	39 c2                	cmp    %eax,%edx
  80380f:	76 14                	jbe    803825 <insert_sorted_allocList+0x42>
  803811:	8b 45 08             	mov    0x8(%ebp),%eax
  803814:	8b 50 08             	mov    0x8(%eax),%edx
  803817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80381a:	8b 40 08             	mov    0x8(%eax),%eax
  80381d:	39 c2                	cmp    %eax,%edx
  80381f:	0f 82 60 01 00 00    	jb     803985 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  803825:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803829:	75 65                	jne    803890 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80382b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80382f:	75 14                	jne    803845 <insert_sorted_allocList+0x62>
  803831:	83 ec 04             	sub    $0x4,%esp
  803834:	68 34 57 80 00       	push   $0x805734
  803839:	6a 6b                	push   $0x6b
  80383b:	68 57 57 80 00       	push   $0x805757
  803840:	e8 07 e1 ff ff       	call   80194c <_panic>
  803845:	8b 15 40 60 80 00    	mov    0x806040,%edx
  80384b:	8b 45 08             	mov    0x8(%ebp),%eax
  80384e:	89 10                	mov    %edx,(%eax)
  803850:	8b 45 08             	mov    0x8(%ebp),%eax
  803853:	8b 00                	mov    (%eax),%eax
  803855:	85 c0                	test   %eax,%eax
  803857:	74 0d                	je     803866 <insert_sorted_allocList+0x83>
  803859:	a1 40 60 80 00       	mov    0x806040,%eax
  80385e:	8b 55 08             	mov    0x8(%ebp),%edx
  803861:	89 50 04             	mov    %edx,0x4(%eax)
  803864:	eb 08                	jmp    80386e <insert_sorted_allocList+0x8b>
  803866:	8b 45 08             	mov    0x8(%ebp),%eax
  803869:	a3 44 60 80 00       	mov    %eax,0x806044
  80386e:	8b 45 08             	mov    0x8(%ebp),%eax
  803871:	a3 40 60 80 00       	mov    %eax,0x806040
  803876:	8b 45 08             	mov    0x8(%ebp),%eax
  803879:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803880:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803885:	40                   	inc    %eax
  803886:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80388b:	e9 dc 01 00 00       	jmp    803a6c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  803890:	8b 45 08             	mov    0x8(%ebp),%eax
  803893:	8b 50 08             	mov    0x8(%eax),%edx
  803896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803899:	8b 40 08             	mov    0x8(%eax),%eax
  80389c:	39 c2                	cmp    %eax,%edx
  80389e:	77 6c                	ja     80390c <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8038a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038a4:	74 06                	je     8038ac <insert_sorted_allocList+0xc9>
  8038a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038aa:	75 14                	jne    8038c0 <insert_sorted_allocList+0xdd>
  8038ac:	83 ec 04             	sub    $0x4,%esp
  8038af:	68 70 57 80 00       	push   $0x805770
  8038b4:	6a 6f                	push   $0x6f
  8038b6:	68 57 57 80 00       	push   $0x805757
  8038bb:	e8 8c e0 ff ff       	call   80194c <_panic>
  8038c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c3:	8b 50 04             	mov    0x4(%eax),%edx
  8038c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c9:	89 50 04             	mov    %edx,0x4(%eax)
  8038cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038d2:	89 10                	mov    %edx,(%eax)
  8038d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d7:	8b 40 04             	mov    0x4(%eax),%eax
  8038da:	85 c0                	test   %eax,%eax
  8038dc:	74 0d                	je     8038eb <insert_sorted_allocList+0x108>
  8038de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e1:	8b 40 04             	mov    0x4(%eax),%eax
  8038e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8038e7:	89 10                	mov    %edx,(%eax)
  8038e9:	eb 08                	jmp    8038f3 <insert_sorted_allocList+0x110>
  8038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ee:	a3 40 60 80 00       	mov    %eax,0x806040
  8038f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8038f9:	89 50 04             	mov    %edx,0x4(%eax)
  8038fc:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803901:	40                   	inc    %eax
  803902:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803907:	e9 60 01 00 00       	jmp    803a6c <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80390c:	8b 45 08             	mov    0x8(%ebp),%eax
  80390f:	8b 50 08             	mov    0x8(%eax),%edx
  803912:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803915:	8b 40 08             	mov    0x8(%eax),%eax
  803918:	39 c2                	cmp    %eax,%edx
  80391a:	0f 82 4c 01 00 00    	jb     803a6c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  803920:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803924:	75 14                	jne    80393a <insert_sorted_allocList+0x157>
  803926:	83 ec 04             	sub    $0x4,%esp
  803929:	68 a8 57 80 00       	push   $0x8057a8
  80392e:	6a 73                	push   $0x73
  803930:	68 57 57 80 00       	push   $0x805757
  803935:	e8 12 e0 ff ff       	call   80194c <_panic>
  80393a:	8b 15 44 60 80 00    	mov    0x806044,%edx
  803940:	8b 45 08             	mov    0x8(%ebp),%eax
  803943:	89 50 04             	mov    %edx,0x4(%eax)
  803946:	8b 45 08             	mov    0x8(%ebp),%eax
  803949:	8b 40 04             	mov    0x4(%eax),%eax
  80394c:	85 c0                	test   %eax,%eax
  80394e:	74 0c                	je     80395c <insert_sorted_allocList+0x179>
  803950:	a1 44 60 80 00       	mov    0x806044,%eax
  803955:	8b 55 08             	mov    0x8(%ebp),%edx
  803958:	89 10                	mov    %edx,(%eax)
  80395a:	eb 08                	jmp    803964 <insert_sorted_allocList+0x181>
  80395c:	8b 45 08             	mov    0x8(%ebp),%eax
  80395f:	a3 40 60 80 00       	mov    %eax,0x806040
  803964:	8b 45 08             	mov    0x8(%ebp),%eax
  803967:	a3 44 60 80 00       	mov    %eax,0x806044
  80396c:	8b 45 08             	mov    0x8(%ebp),%eax
  80396f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803975:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80397a:	40                   	inc    %eax
  80397b:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803980:	e9 e7 00 00 00       	jmp    803a6c <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  803985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803988:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80398b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  803992:	a1 40 60 80 00       	mov    0x806040,%eax
  803997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80399a:	e9 9d 00 00 00       	jmp    803a3c <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80399f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a2:	8b 00                	mov    (%eax),%eax
  8039a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8039a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039aa:	8b 50 08             	mov    0x8(%eax),%edx
  8039ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b0:	8b 40 08             	mov    0x8(%eax),%eax
  8039b3:	39 c2                	cmp    %eax,%edx
  8039b5:	76 7d                	jbe    803a34 <insert_sorted_allocList+0x251>
  8039b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ba:	8b 50 08             	mov    0x8(%eax),%edx
  8039bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c0:	8b 40 08             	mov    0x8(%eax),%eax
  8039c3:	39 c2                	cmp    %eax,%edx
  8039c5:	73 6d                	jae    803a34 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8039c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039cb:	74 06                	je     8039d3 <insert_sorted_allocList+0x1f0>
  8039cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039d1:	75 14                	jne    8039e7 <insert_sorted_allocList+0x204>
  8039d3:	83 ec 04             	sub    $0x4,%esp
  8039d6:	68 cc 57 80 00       	push   $0x8057cc
  8039db:	6a 7f                	push   $0x7f
  8039dd:	68 57 57 80 00       	push   $0x805757
  8039e2:	e8 65 df ff ff       	call   80194c <_panic>
  8039e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ea:	8b 10                	mov    (%eax),%edx
  8039ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ef:	89 10                	mov    %edx,(%eax)
  8039f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f4:	8b 00                	mov    (%eax),%eax
  8039f6:	85 c0                	test   %eax,%eax
  8039f8:	74 0b                	je     803a05 <insert_sorted_allocList+0x222>
  8039fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fd:	8b 00                	mov    (%eax),%eax
  8039ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803a02:	89 50 04             	mov    %edx,0x4(%eax)
  803a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a08:	8b 55 08             	mov    0x8(%ebp),%edx
  803a0b:	89 10                	mov    %edx,(%eax)
  803a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a13:	89 50 04             	mov    %edx,0x4(%eax)
  803a16:	8b 45 08             	mov    0x8(%ebp),%eax
  803a19:	8b 00                	mov    (%eax),%eax
  803a1b:	85 c0                	test   %eax,%eax
  803a1d:	75 08                	jne    803a27 <insert_sorted_allocList+0x244>
  803a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a22:	a3 44 60 80 00       	mov    %eax,0x806044
  803a27:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803a2c:	40                   	inc    %eax
  803a2d:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  803a32:	eb 39                	jmp    803a6d <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  803a34:	a1 48 60 80 00       	mov    0x806048,%eax
  803a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a40:	74 07                	je     803a49 <insert_sorted_allocList+0x266>
  803a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a45:	8b 00                	mov    (%eax),%eax
  803a47:	eb 05                	jmp    803a4e <insert_sorted_allocList+0x26b>
  803a49:	b8 00 00 00 00       	mov    $0x0,%eax
  803a4e:	a3 48 60 80 00       	mov    %eax,0x806048
  803a53:	a1 48 60 80 00       	mov    0x806048,%eax
  803a58:	85 c0                	test   %eax,%eax
  803a5a:	0f 85 3f ff ff ff    	jne    80399f <insert_sorted_allocList+0x1bc>
  803a60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a64:	0f 85 35 ff ff ff    	jne    80399f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  803a6a:	eb 01                	jmp    803a6d <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803a6c:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  803a6d:	90                   	nop
  803a6e:	c9                   	leave  
  803a6f:	c3                   	ret    

00803a70 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  803a70:	55                   	push   %ebp
  803a71:	89 e5                	mov    %esp,%ebp
  803a73:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803a76:	a1 38 61 80 00       	mov    0x806138,%eax
  803a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a7e:	e9 85 01 00 00       	jmp    803c08 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  803a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a86:	8b 40 0c             	mov    0xc(%eax),%eax
  803a89:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a8c:	0f 82 6e 01 00 00    	jb     803c00 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  803a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a95:	8b 40 0c             	mov    0xc(%eax),%eax
  803a98:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a9b:	0f 85 8a 00 00 00    	jne    803b2b <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  803aa1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aa5:	75 17                	jne    803abe <alloc_block_FF+0x4e>
  803aa7:	83 ec 04             	sub    $0x4,%esp
  803aaa:	68 00 58 80 00       	push   $0x805800
  803aaf:	68 93 00 00 00       	push   $0x93
  803ab4:	68 57 57 80 00       	push   $0x805757
  803ab9:	e8 8e de ff ff       	call   80194c <_panic>
  803abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac1:	8b 00                	mov    (%eax),%eax
  803ac3:	85 c0                	test   %eax,%eax
  803ac5:	74 10                	je     803ad7 <alloc_block_FF+0x67>
  803ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aca:	8b 00                	mov    (%eax),%eax
  803acc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803acf:	8b 52 04             	mov    0x4(%edx),%edx
  803ad2:	89 50 04             	mov    %edx,0x4(%eax)
  803ad5:	eb 0b                	jmp    803ae2 <alloc_block_FF+0x72>
  803ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ada:	8b 40 04             	mov    0x4(%eax),%eax
  803add:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae5:	8b 40 04             	mov    0x4(%eax),%eax
  803ae8:	85 c0                	test   %eax,%eax
  803aea:	74 0f                	je     803afb <alloc_block_FF+0x8b>
  803aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aef:	8b 40 04             	mov    0x4(%eax),%eax
  803af2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803af5:	8b 12                	mov    (%edx),%edx
  803af7:	89 10                	mov    %edx,(%eax)
  803af9:	eb 0a                	jmp    803b05 <alloc_block_FF+0x95>
  803afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afe:	8b 00                	mov    (%eax),%eax
  803b00:	a3 38 61 80 00       	mov    %eax,0x806138
  803b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b18:	a1 44 61 80 00       	mov    0x806144,%eax
  803b1d:	48                   	dec    %eax
  803b1e:	a3 44 61 80 00       	mov    %eax,0x806144
			   return  point;
  803b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b26:	e9 10 01 00 00       	jmp    803c3b <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  803b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2e:	8b 40 0c             	mov    0xc(%eax),%eax
  803b31:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b34:	0f 86 c6 00 00 00    	jbe    803c00 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803b3a:	a1 48 61 80 00       	mov    0x806148,%eax
  803b3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  803b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b45:	8b 50 08             	mov    0x8(%eax),%edx
  803b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b4b:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  803b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b51:	8b 55 08             	mov    0x8(%ebp),%edx
  803b54:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803b57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b5b:	75 17                	jne    803b74 <alloc_block_FF+0x104>
  803b5d:	83 ec 04             	sub    $0x4,%esp
  803b60:	68 00 58 80 00       	push   $0x805800
  803b65:	68 9b 00 00 00       	push   $0x9b
  803b6a:	68 57 57 80 00       	push   $0x805757
  803b6f:	e8 d8 dd ff ff       	call   80194c <_panic>
  803b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b77:	8b 00                	mov    (%eax),%eax
  803b79:	85 c0                	test   %eax,%eax
  803b7b:	74 10                	je     803b8d <alloc_block_FF+0x11d>
  803b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b80:	8b 00                	mov    (%eax),%eax
  803b82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b85:	8b 52 04             	mov    0x4(%edx),%edx
  803b88:	89 50 04             	mov    %edx,0x4(%eax)
  803b8b:	eb 0b                	jmp    803b98 <alloc_block_FF+0x128>
  803b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b90:	8b 40 04             	mov    0x4(%eax),%eax
  803b93:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b9b:	8b 40 04             	mov    0x4(%eax),%eax
  803b9e:	85 c0                	test   %eax,%eax
  803ba0:	74 0f                	je     803bb1 <alloc_block_FF+0x141>
  803ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ba5:	8b 40 04             	mov    0x4(%eax),%eax
  803ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bab:	8b 12                	mov    (%edx),%edx
  803bad:	89 10                	mov    %edx,(%eax)
  803baf:	eb 0a                	jmp    803bbb <alloc_block_FF+0x14b>
  803bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bb4:	8b 00                	mov    (%eax),%eax
  803bb6:	a3 48 61 80 00       	mov    %eax,0x806148
  803bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bce:	a1 54 61 80 00       	mov    0x806154,%eax
  803bd3:	48                   	dec    %eax
  803bd4:	a3 54 61 80 00       	mov    %eax,0x806154
			   point->sva += size;
  803bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdc:	8b 50 08             	mov    0x8(%eax),%edx
  803bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  803be2:	01 c2                	add    %eax,%edx
  803be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be7:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  803bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bed:	8b 40 0c             	mov    0xc(%eax),%eax
  803bf0:	2b 45 08             	sub    0x8(%ebp),%eax
  803bf3:	89 c2                	mov    %eax,%edx
  803bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf8:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  803bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bfe:	eb 3b                	jmp    803c3b <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803c00:	a1 40 61 80 00       	mov    0x806140,%eax
  803c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c0c:	74 07                	je     803c15 <alloc_block_FF+0x1a5>
  803c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c11:	8b 00                	mov    (%eax),%eax
  803c13:	eb 05                	jmp    803c1a <alloc_block_FF+0x1aa>
  803c15:	b8 00 00 00 00       	mov    $0x0,%eax
  803c1a:	a3 40 61 80 00       	mov    %eax,0x806140
  803c1f:	a1 40 61 80 00       	mov    0x806140,%eax
  803c24:	85 c0                	test   %eax,%eax
  803c26:	0f 85 57 fe ff ff    	jne    803a83 <alloc_block_FF+0x13>
  803c2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c30:	0f 85 4d fe ff ff    	jne    803a83 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  803c36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c3b:	c9                   	leave  
  803c3c:	c3                   	ret    

00803c3d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803c3d:	55                   	push   %ebp
  803c3e:	89 e5                	mov    %esp,%ebp
  803c40:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  803c43:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803c4a:	a1 38 61 80 00       	mov    0x806138,%eax
  803c4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c52:	e9 df 00 00 00       	jmp    803d36 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  803c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5a:	8b 40 0c             	mov    0xc(%eax),%eax
  803c5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c60:	0f 82 c8 00 00 00    	jb     803d2e <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  803c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c69:	8b 40 0c             	mov    0xc(%eax),%eax
  803c6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c6f:	0f 85 8a 00 00 00    	jne    803cff <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  803c75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c79:	75 17                	jne    803c92 <alloc_block_BF+0x55>
  803c7b:	83 ec 04             	sub    $0x4,%esp
  803c7e:	68 00 58 80 00       	push   $0x805800
  803c83:	68 b7 00 00 00       	push   $0xb7
  803c88:	68 57 57 80 00       	push   $0x805757
  803c8d:	e8 ba dc ff ff       	call   80194c <_panic>
  803c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c95:	8b 00                	mov    (%eax),%eax
  803c97:	85 c0                	test   %eax,%eax
  803c99:	74 10                	je     803cab <alloc_block_BF+0x6e>
  803c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9e:	8b 00                	mov    (%eax),%eax
  803ca0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ca3:	8b 52 04             	mov    0x4(%edx),%edx
  803ca6:	89 50 04             	mov    %edx,0x4(%eax)
  803ca9:	eb 0b                	jmp    803cb6 <alloc_block_BF+0x79>
  803cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cae:	8b 40 04             	mov    0x4(%eax),%eax
  803cb1:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb9:	8b 40 04             	mov    0x4(%eax),%eax
  803cbc:	85 c0                	test   %eax,%eax
  803cbe:	74 0f                	je     803ccf <alloc_block_BF+0x92>
  803cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc3:	8b 40 04             	mov    0x4(%eax),%eax
  803cc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cc9:	8b 12                	mov    (%edx),%edx
  803ccb:	89 10                	mov    %edx,(%eax)
  803ccd:	eb 0a                	jmp    803cd9 <alloc_block_BF+0x9c>
  803ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd2:	8b 00                	mov    (%eax),%eax
  803cd4:	a3 38 61 80 00       	mov    %eax,0x806138
  803cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cdc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cec:	a1 44 61 80 00       	mov    0x806144,%eax
  803cf1:	48                   	dec    %eax
  803cf2:	a3 44 61 80 00       	mov    %eax,0x806144
			   return currentMemBlock;
  803cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cfa:	e9 4d 01 00 00       	jmp    803e4c <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  803cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d02:	8b 40 0c             	mov    0xc(%eax),%eax
  803d05:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d08:	76 24                	jbe    803d2e <alloc_block_BF+0xf1>
  803d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  803d10:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803d13:	73 19                	jae    803d2e <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  803d15:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  803d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1f:	8b 40 0c             	mov    0xc(%eax),%eax
  803d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  803d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d28:	8b 40 08             	mov    0x8(%eax),%eax
  803d2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803d2e:	a1 40 61 80 00       	mov    0x806140,%eax
  803d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d3a:	74 07                	je     803d43 <alloc_block_BF+0x106>
  803d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3f:	8b 00                	mov    (%eax),%eax
  803d41:	eb 05                	jmp    803d48 <alloc_block_BF+0x10b>
  803d43:	b8 00 00 00 00       	mov    $0x0,%eax
  803d48:	a3 40 61 80 00       	mov    %eax,0x806140
  803d4d:	a1 40 61 80 00       	mov    0x806140,%eax
  803d52:	85 c0                	test   %eax,%eax
  803d54:	0f 85 fd fe ff ff    	jne    803c57 <alloc_block_BF+0x1a>
  803d5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d5e:	0f 85 f3 fe ff ff    	jne    803c57 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  803d64:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803d68:	0f 84 d9 00 00 00    	je     803e47 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  803d6e:	a1 48 61 80 00       	mov    0x806148,%eax
  803d73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d7c:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d82:	8b 55 08             	mov    0x8(%ebp),%edx
  803d85:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803d88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d8c:	75 17                	jne    803da5 <alloc_block_BF+0x168>
  803d8e:	83 ec 04             	sub    $0x4,%esp
  803d91:	68 00 58 80 00       	push   $0x805800
  803d96:	68 c7 00 00 00       	push   $0xc7
  803d9b:	68 57 57 80 00       	push   $0x805757
  803da0:	e8 a7 db ff ff       	call   80194c <_panic>
  803da5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da8:	8b 00                	mov    (%eax),%eax
  803daa:	85 c0                	test   %eax,%eax
  803dac:	74 10                	je     803dbe <alloc_block_BF+0x181>
  803dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db1:	8b 00                	mov    (%eax),%eax
  803db3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803db6:	8b 52 04             	mov    0x4(%edx),%edx
  803db9:	89 50 04             	mov    %edx,0x4(%eax)
  803dbc:	eb 0b                	jmp    803dc9 <alloc_block_BF+0x18c>
  803dbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc1:	8b 40 04             	mov    0x4(%eax),%eax
  803dc4:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dcc:	8b 40 04             	mov    0x4(%eax),%eax
  803dcf:	85 c0                	test   %eax,%eax
  803dd1:	74 0f                	je     803de2 <alloc_block_BF+0x1a5>
  803dd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd6:	8b 40 04             	mov    0x4(%eax),%eax
  803dd9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ddc:	8b 12                	mov    (%edx),%edx
  803dde:	89 10                	mov    %edx,(%eax)
  803de0:	eb 0a                	jmp    803dec <alloc_block_BF+0x1af>
  803de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de5:	8b 00                	mov    (%eax),%eax
  803de7:	a3 48 61 80 00       	mov    %eax,0x806148
  803dec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803def:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803df5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dff:	a1 54 61 80 00       	mov    0x806154,%eax
  803e04:	48                   	dec    %eax
  803e05:	a3 54 61 80 00       	mov    %eax,0x806154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803e0a:	83 ec 08             	sub    $0x8,%esp
  803e0d:	ff 75 ec             	pushl  -0x14(%ebp)
  803e10:	68 38 61 80 00       	push   $0x806138
  803e15:	e8 71 f9 ff ff       	call   80378b <find_block>
  803e1a:	83 c4 10             	add    $0x10,%esp
  803e1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803e20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e23:	8b 50 08             	mov    0x8(%eax),%edx
  803e26:	8b 45 08             	mov    0x8(%ebp),%eax
  803e29:	01 c2                	add    %eax,%edx
  803e2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e2e:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803e31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e34:	8b 40 0c             	mov    0xc(%eax),%eax
  803e37:	2b 45 08             	sub    0x8(%ebp),%eax
  803e3a:	89 c2                	mov    %eax,%edx
  803e3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e3f:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803e42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e45:	eb 05                	jmp    803e4c <alloc_block_BF+0x20f>
	}
	return NULL;
  803e47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e4c:	c9                   	leave  
  803e4d:	c3                   	ret    

00803e4e <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803e4e:	55                   	push   %ebp
  803e4f:	89 e5                	mov    %esp,%ebp
  803e51:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803e54:	a1 28 60 80 00       	mov    0x806028,%eax
  803e59:	85 c0                	test   %eax,%eax
  803e5b:	0f 85 de 01 00 00    	jne    80403f <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803e61:	a1 38 61 80 00       	mov    0x806138,%eax
  803e66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e69:	e9 9e 01 00 00       	jmp    80400c <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e71:	8b 40 0c             	mov    0xc(%eax),%eax
  803e74:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e77:	0f 82 87 01 00 00    	jb     804004 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e80:	8b 40 0c             	mov    0xc(%eax),%eax
  803e83:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e86:	0f 85 95 00 00 00    	jne    803f21 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803e8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e90:	75 17                	jne    803ea9 <alloc_block_NF+0x5b>
  803e92:	83 ec 04             	sub    $0x4,%esp
  803e95:	68 00 58 80 00       	push   $0x805800
  803e9a:	68 e0 00 00 00       	push   $0xe0
  803e9f:	68 57 57 80 00       	push   $0x805757
  803ea4:	e8 a3 da ff ff       	call   80194c <_panic>
  803ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eac:	8b 00                	mov    (%eax),%eax
  803eae:	85 c0                	test   %eax,%eax
  803eb0:	74 10                	je     803ec2 <alloc_block_NF+0x74>
  803eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb5:	8b 00                	mov    (%eax),%eax
  803eb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803eba:	8b 52 04             	mov    0x4(%edx),%edx
  803ebd:	89 50 04             	mov    %edx,0x4(%eax)
  803ec0:	eb 0b                	jmp    803ecd <alloc_block_NF+0x7f>
  803ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec5:	8b 40 04             	mov    0x4(%eax),%eax
  803ec8:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed0:	8b 40 04             	mov    0x4(%eax),%eax
  803ed3:	85 c0                	test   %eax,%eax
  803ed5:	74 0f                	je     803ee6 <alloc_block_NF+0x98>
  803ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eda:	8b 40 04             	mov    0x4(%eax),%eax
  803edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ee0:	8b 12                	mov    (%edx),%edx
  803ee2:	89 10                	mov    %edx,(%eax)
  803ee4:	eb 0a                	jmp    803ef0 <alloc_block_NF+0xa2>
  803ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee9:	8b 00                	mov    (%eax),%eax
  803eeb:	a3 38 61 80 00       	mov    %eax,0x806138
  803ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803efc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f03:	a1 44 61 80 00       	mov    0x806144,%eax
  803f08:	48                   	dec    %eax
  803f09:	a3 44 61 80 00       	mov    %eax,0x806144
				   svaOfNF = point->sva;
  803f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f11:	8b 40 08             	mov    0x8(%eax),%eax
  803f14:	a3 28 60 80 00       	mov    %eax,0x806028
				   return  point;
  803f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f1c:	e9 f8 04 00 00       	jmp    804419 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f24:	8b 40 0c             	mov    0xc(%eax),%eax
  803f27:	3b 45 08             	cmp    0x8(%ebp),%eax
  803f2a:	0f 86 d4 00 00 00    	jbe    804004 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803f30:	a1 48 61 80 00       	mov    0x806148,%eax
  803f35:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f3b:	8b 50 08             	mov    0x8(%eax),%edx
  803f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f41:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f47:	8b 55 08             	mov    0x8(%ebp),%edx
  803f4a:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803f4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f51:	75 17                	jne    803f6a <alloc_block_NF+0x11c>
  803f53:	83 ec 04             	sub    $0x4,%esp
  803f56:	68 00 58 80 00       	push   $0x805800
  803f5b:	68 e9 00 00 00       	push   $0xe9
  803f60:	68 57 57 80 00       	push   $0x805757
  803f65:	e8 e2 d9 ff ff       	call   80194c <_panic>
  803f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f6d:	8b 00                	mov    (%eax),%eax
  803f6f:	85 c0                	test   %eax,%eax
  803f71:	74 10                	je     803f83 <alloc_block_NF+0x135>
  803f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f76:	8b 00                	mov    (%eax),%eax
  803f78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f7b:	8b 52 04             	mov    0x4(%edx),%edx
  803f7e:	89 50 04             	mov    %edx,0x4(%eax)
  803f81:	eb 0b                	jmp    803f8e <alloc_block_NF+0x140>
  803f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f86:	8b 40 04             	mov    0x4(%eax),%eax
  803f89:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f91:	8b 40 04             	mov    0x4(%eax),%eax
  803f94:	85 c0                	test   %eax,%eax
  803f96:	74 0f                	je     803fa7 <alloc_block_NF+0x159>
  803f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f9b:	8b 40 04             	mov    0x4(%eax),%eax
  803f9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fa1:	8b 12                	mov    (%edx),%edx
  803fa3:	89 10                	mov    %edx,(%eax)
  803fa5:	eb 0a                	jmp    803fb1 <alloc_block_NF+0x163>
  803fa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803faa:	8b 00                	mov    (%eax),%eax
  803fac:	a3 48 61 80 00       	mov    %eax,0x806148
  803fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fc4:	a1 54 61 80 00       	mov    0x806154,%eax
  803fc9:	48                   	dec    %eax
  803fca:	a3 54 61 80 00       	mov    %eax,0x806154
				   svaOfNF = ReturnedBlock->sva;
  803fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fd2:	8b 40 08             	mov    0x8(%eax),%eax
  803fd5:	a3 28 60 80 00       	mov    %eax,0x806028
				   point->sva += size;
  803fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fdd:	8b 50 08             	mov    0x8(%eax),%edx
  803fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe3:	01 c2                	add    %eax,%edx
  803fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe8:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fee:	8b 40 0c             	mov    0xc(%eax),%eax
  803ff1:	2b 45 08             	sub    0x8(%ebp),%eax
  803ff4:	89 c2                	mov    %eax,%edx
  803ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ff9:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fff:	e9 15 04 00 00       	jmp    804419 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  804004:	a1 40 61 80 00       	mov    0x806140,%eax
  804009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80400c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804010:	74 07                	je     804019 <alloc_block_NF+0x1cb>
  804012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804015:	8b 00                	mov    (%eax),%eax
  804017:	eb 05                	jmp    80401e <alloc_block_NF+0x1d0>
  804019:	b8 00 00 00 00       	mov    $0x0,%eax
  80401e:	a3 40 61 80 00       	mov    %eax,0x806140
  804023:	a1 40 61 80 00       	mov    0x806140,%eax
  804028:	85 c0                	test   %eax,%eax
  80402a:	0f 85 3e fe ff ff    	jne    803e6e <alloc_block_NF+0x20>
  804030:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804034:	0f 85 34 fe ff ff    	jne    803e6e <alloc_block_NF+0x20>
  80403a:	e9 d5 03 00 00       	jmp    804414 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80403f:	a1 38 61 80 00       	mov    0x806138,%eax
  804044:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804047:	e9 b1 01 00 00       	jmp    8041fd <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80404c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80404f:	8b 50 08             	mov    0x8(%eax),%edx
  804052:	a1 28 60 80 00       	mov    0x806028,%eax
  804057:	39 c2                	cmp    %eax,%edx
  804059:	0f 82 96 01 00 00    	jb     8041f5 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80405f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804062:	8b 40 0c             	mov    0xc(%eax),%eax
  804065:	3b 45 08             	cmp    0x8(%ebp),%eax
  804068:	0f 82 87 01 00 00    	jb     8041f5 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80406e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804071:	8b 40 0c             	mov    0xc(%eax),%eax
  804074:	3b 45 08             	cmp    0x8(%ebp),%eax
  804077:	0f 85 95 00 00 00    	jne    804112 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80407d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804081:	75 17                	jne    80409a <alloc_block_NF+0x24c>
  804083:	83 ec 04             	sub    $0x4,%esp
  804086:	68 00 58 80 00       	push   $0x805800
  80408b:	68 fc 00 00 00       	push   $0xfc
  804090:	68 57 57 80 00       	push   $0x805757
  804095:	e8 b2 d8 ff ff       	call   80194c <_panic>
  80409a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80409d:	8b 00                	mov    (%eax),%eax
  80409f:	85 c0                	test   %eax,%eax
  8040a1:	74 10                	je     8040b3 <alloc_block_NF+0x265>
  8040a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040a6:	8b 00                	mov    (%eax),%eax
  8040a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040ab:	8b 52 04             	mov    0x4(%edx),%edx
  8040ae:	89 50 04             	mov    %edx,0x4(%eax)
  8040b1:	eb 0b                	jmp    8040be <alloc_block_NF+0x270>
  8040b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040b6:	8b 40 04             	mov    0x4(%eax),%eax
  8040b9:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8040be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040c1:	8b 40 04             	mov    0x4(%eax),%eax
  8040c4:	85 c0                	test   %eax,%eax
  8040c6:	74 0f                	je     8040d7 <alloc_block_NF+0x289>
  8040c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040cb:	8b 40 04             	mov    0x4(%eax),%eax
  8040ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040d1:	8b 12                	mov    (%edx),%edx
  8040d3:	89 10                	mov    %edx,(%eax)
  8040d5:	eb 0a                	jmp    8040e1 <alloc_block_NF+0x293>
  8040d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040da:	8b 00                	mov    (%eax),%eax
  8040dc:	a3 38 61 80 00       	mov    %eax,0x806138
  8040e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040f4:	a1 44 61 80 00       	mov    0x806144,%eax
  8040f9:	48                   	dec    %eax
  8040fa:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  8040ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804102:	8b 40 08             	mov    0x8(%eax),%eax
  804105:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  80410a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80410d:	e9 07 03 00 00       	jmp    804419 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  804112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804115:	8b 40 0c             	mov    0xc(%eax),%eax
  804118:	3b 45 08             	cmp    0x8(%ebp),%eax
  80411b:	0f 86 d4 00 00 00    	jbe    8041f5 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  804121:	a1 48 61 80 00       	mov    0x806148,%eax
  804126:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  804129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80412c:	8b 50 08             	mov    0x8(%eax),%edx
  80412f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804132:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  804135:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804138:	8b 55 08             	mov    0x8(%ebp),%edx
  80413b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80413e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804142:	75 17                	jne    80415b <alloc_block_NF+0x30d>
  804144:	83 ec 04             	sub    $0x4,%esp
  804147:	68 00 58 80 00       	push   $0x805800
  80414c:	68 04 01 00 00       	push   $0x104
  804151:	68 57 57 80 00       	push   $0x805757
  804156:	e8 f1 d7 ff ff       	call   80194c <_panic>
  80415b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80415e:	8b 00                	mov    (%eax),%eax
  804160:	85 c0                	test   %eax,%eax
  804162:	74 10                	je     804174 <alloc_block_NF+0x326>
  804164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804167:	8b 00                	mov    (%eax),%eax
  804169:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80416c:	8b 52 04             	mov    0x4(%edx),%edx
  80416f:	89 50 04             	mov    %edx,0x4(%eax)
  804172:	eb 0b                	jmp    80417f <alloc_block_NF+0x331>
  804174:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804177:	8b 40 04             	mov    0x4(%eax),%eax
  80417a:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80417f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804182:	8b 40 04             	mov    0x4(%eax),%eax
  804185:	85 c0                	test   %eax,%eax
  804187:	74 0f                	je     804198 <alloc_block_NF+0x34a>
  804189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80418c:	8b 40 04             	mov    0x4(%eax),%eax
  80418f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804192:	8b 12                	mov    (%edx),%edx
  804194:	89 10                	mov    %edx,(%eax)
  804196:	eb 0a                	jmp    8041a2 <alloc_block_NF+0x354>
  804198:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80419b:	8b 00                	mov    (%eax),%eax
  80419d:	a3 48 61 80 00       	mov    %eax,0x806148
  8041a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041b5:	a1 54 61 80 00       	mov    0x806154,%eax
  8041ba:	48                   	dec    %eax
  8041bb:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  8041c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041c3:	8b 40 08             	mov    0x8(%eax),%eax
  8041c6:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  8041cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041ce:	8b 50 08             	mov    0x8(%eax),%edx
  8041d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8041d4:	01 c2                	add    %eax,%edx
  8041d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041d9:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8041dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041df:	8b 40 0c             	mov    0xc(%eax),%eax
  8041e2:	2b 45 08             	sub    0x8(%ebp),%eax
  8041e5:	89 c2                	mov    %eax,%edx
  8041e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041ea:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8041ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041f0:	e9 24 02 00 00       	jmp    804419 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8041f5:	a1 40 61 80 00       	mov    0x806140,%eax
  8041fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8041fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804201:	74 07                	je     80420a <alloc_block_NF+0x3bc>
  804203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804206:	8b 00                	mov    (%eax),%eax
  804208:	eb 05                	jmp    80420f <alloc_block_NF+0x3c1>
  80420a:	b8 00 00 00 00       	mov    $0x0,%eax
  80420f:	a3 40 61 80 00       	mov    %eax,0x806140
  804214:	a1 40 61 80 00       	mov    0x806140,%eax
  804219:	85 c0                	test   %eax,%eax
  80421b:	0f 85 2b fe ff ff    	jne    80404c <alloc_block_NF+0x1fe>
  804221:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804225:	0f 85 21 fe ff ff    	jne    80404c <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80422b:	a1 38 61 80 00       	mov    0x806138,%eax
  804230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804233:	e9 ae 01 00 00       	jmp    8043e6 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  804238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80423b:	8b 50 08             	mov    0x8(%eax),%edx
  80423e:	a1 28 60 80 00       	mov    0x806028,%eax
  804243:	39 c2                	cmp    %eax,%edx
  804245:	0f 83 93 01 00 00    	jae    8043de <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80424b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80424e:	8b 40 0c             	mov    0xc(%eax),%eax
  804251:	3b 45 08             	cmp    0x8(%ebp),%eax
  804254:	0f 82 84 01 00 00    	jb     8043de <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80425a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80425d:	8b 40 0c             	mov    0xc(%eax),%eax
  804260:	3b 45 08             	cmp    0x8(%ebp),%eax
  804263:	0f 85 95 00 00 00    	jne    8042fe <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  804269:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80426d:	75 17                	jne    804286 <alloc_block_NF+0x438>
  80426f:	83 ec 04             	sub    $0x4,%esp
  804272:	68 00 58 80 00       	push   $0x805800
  804277:	68 14 01 00 00       	push   $0x114
  80427c:	68 57 57 80 00       	push   $0x805757
  804281:	e8 c6 d6 ff ff       	call   80194c <_panic>
  804286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804289:	8b 00                	mov    (%eax),%eax
  80428b:	85 c0                	test   %eax,%eax
  80428d:	74 10                	je     80429f <alloc_block_NF+0x451>
  80428f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804292:	8b 00                	mov    (%eax),%eax
  804294:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804297:	8b 52 04             	mov    0x4(%edx),%edx
  80429a:	89 50 04             	mov    %edx,0x4(%eax)
  80429d:	eb 0b                	jmp    8042aa <alloc_block_NF+0x45c>
  80429f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042a2:	8b 40 04             	mov    0x4(%eax),%eax
  8042a5:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8042aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042ad:	8b 40 04             	mov    0x4(%eax),%eax
  8042b0:	85 c0                	test   %eax,%eax
  8042b2:	74 0f                	je     8042c3 <alloc_block_NF+0x475>
  8042b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042b7:	8b 40 04             	mov    0x4(%eax),%eax
  8042ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8042bd:	8b 12                	mov    (%edx),%edx
  8042bf:	89 10                	mov    %edx,(%eax)
  8042c1:	eb 0a                	jmp    8042cd <alloc_block_NF+0x47f>
  8042c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042c6:	8b 00                	mov    (%eax),%eax
  8042c8:	a3 38 61 80 00       	mov    %eax,0x806138
  8042cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042e0:	a1 44 61 80 00       	mov    0x806144,%eax
  8042e5:	48                   	dec    %eax
  8042e6:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  8042eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042ee:	8b 40 08             	mov    0x8(%eax),%eax
  8042f1:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  8042f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042f9:	e9 1b 01 00 00       	jmp    804419 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8042fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804301:	8b 40 0c             	mov    0xc(%eax),%eax
  804304:	3b 45 08             	cmp    0x8(%ebp),%eax
  804307:	0f 86 d1 00 00 00    	jbe    8043de <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80430d:	a1 48 61 80 00       	mov    0x806148,%eax
  804312:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  804315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804318:	8b 50 08             	mov    0x8(%eax),%edx
  80431b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80431e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  804321:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804324:	8b 55 08             	mov    0x8(%ebp),%edx
  804327:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80432a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80432e:	75 17                	jne    804347 <alloc_block_NF+0x4f9>
  804330:	83 ec 04             	sub    $0x4,%esp
  804333:	68 00 58 80 00       	push   $0x805800
  804338:	68 1c 01 00 00       	push   $0x11c
  80433d:	68 57 57 80 00       	push   $0x805757
  804342:	e8 05 d6 ff ff       	call   80194c <_panic>
  804347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80434a:	8b 00                	mov    (%eax),%eax
  80434c:	85 c0                	test   %eax,%eax
  80434e:	74 10                	je     804360 <alloc_block_NF+0x512>
  804350:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804353:	8b 00                	mov    (%eax),%eax
  804355:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804358:	8b 52 04             	mov    0x4(%edx),%edx
  80435b:	89 50 04             	mov    %edx,0x4(%eax)
  80435e:	eb 0b                	jmp    80436b <alloc_block_NF+0x51d>
  804360:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804363:	8b 40 04             	mov    0x4(%eax),%eax
  804366:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80436b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80436e:	8b 40 04             	mov    0x4(%eax),%eax
  804371:	85 c0                	test   %eax,%eax
  804373:	74 0f                	je     804384 <alloc_block_NF+0x536>
  804375:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804378:	8b 40 04             	mov    0x4(%eax),%eax
  80437b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80437e:	8b 12                	mov    (%edx),%edx
  804380:	89 10                	mov    %edx,(%eax)
  804382:	eb 0a                	jmp    80438e <alloc_block_NF+0x540>
  804384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804387:	8b 00                	mov    (%eax),%eax
  804389:	a3 48 61 80 00       	mov    %eax,0x806148
  80438e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804391:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804397:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80439a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043a1:	a1 54 61 80 00       	mov    0x806154,%eax
  8043a6:	48                   	dec    %eax
  8043a7:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  8043ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043af:	8b 40 08             	mov    0x8(%eax),%eax
  8043b2:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  8043b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043ba:	8b 50 08             	mov    0x8(%eax),%edx
  8043bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8043c0:	01 c2                	add    %eax,%edx
  8043c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043c5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8043c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8043ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8043d1:	89 c2                	mov    %eax,%edx
  8043d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043d6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8043d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043dc:	eb 3b                	jmp    804419 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8043de:	a1 40 61 80 00       	mov    0x806140,%eax
  8043e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8043e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8043ea:	74 07                	je     8043f3 <alloc_block_NF+0x5a5>
  8043ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043ef:	8b 00                	mov    (%eax),%eax
  8043f1:	eb 05                	jmp    8043f8 <alloc_block_NF+0x5aa>
  8043f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8043f8:	a3 40 61 80 00       	mov    %eax,0x806140
  8043fd:	a1 40 61 80 00       	mov    0x806140,%eax
  804402:	85 c0                	test   %eax,%eax
  804404:	0f 85 2e fe ff ff    	jne    804238 <alloc_block_NF+0x3ea>
  80440a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80440e:	0f 85 24 fe ff ff    	jne    804238 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  804414:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804419:	c9                   	leave  
  80441a:	c3                   	ret    

0080441b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80441b:	55                   	push   %ebp
  80441c:	89 e5                	mov    %esp,%ebp
  80441e:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  804421:	a1 38 61 80 00       	mov    0x806138,%eax
  804426:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  804429:	a1 3c 61 80 00       	mov    0x80613c,%eax
  80442e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  804431:	a1 38 61 80 00       	mov    0x806138,%eax
  804436:	85 c0                	test   %eax,%eax
  804438:	74 14                	je     80444e <insert_sorted_with_merge_freeList+0x33>
  80443a:	8b 45 08             	mov    0x8(%ebp),%eax
  80443d:	8b 50 08             	mov    0x8(%eax),%edx
  804440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804443:	8b 40 08             	mov    0x8(%eax),%eax
  804446:	39 c2                	cmp    %eax,%edx
  804448:	0f 87 9b 01 00 00    	ja     8045e9 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80444e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804452:	75 17                	jne    80446b <insert_sorted_with_merge_freeList+0x50>
  804454:	83 ec 04             	sub    $0x4,%esp
  804457:	68 34 57 80 00       	push   $0x805734
  80445c:	68 38 01 00 00       	push   $0x138
  804461:	68 57 57 80 00       	push   $0x805757
  804466:	e8 e1 d4 ff ff       	call   80194c <_panic>
  80446b:	8b 15 38 61 80 00    	mov    0x806138,%edx
  804471:	8b 45 08             	mov    0x8(%ebp),%eax
  804474:	89 10                	mov    %edx,(%eax)
  804476:	8b 45 08             	mov    0x8(%ebp),%eax
  804479:	8b 00                	mov    (%eax),%eax
  80447b:	85 c0                	test   %eax,%eax
  80447d:	74 0d                	je     80448c <insert_sorted_with_merge_freeList+0x71>
  80447f:	a1 38 61 80 00       	mov    0x806138,%eax
  804484:	8b 55 08             	mov    0x8(%ebp),%edx
  804487:	89 50 04             	mov    %edx,0x4(%eax)
  80448a:	eb 08                	jmp    804494 <insert_sorted_with_merge_freeList+0x79>
  80448c:	8b 45 08             	mov    0x8(%ebp),%eax
  80448f:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804494:	8b 45 08             	mov    0x8(%ebp),%eax
  804497:	a3 38 61 80 00       	mov    %eax,0x806138
  80449c:	8b 45 08             	mov    0x8(%ebp),%eax
  80449f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8044a6:	a1 44 61 80 00       	mov    0x806144,%eax
  8044ab:	40                   	inc    %eax
  8044ac:	a3 44 61 80 00       	mov    %eax,0x806144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8044b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8044b5:	0f 84 a8 06 00 00    	je     804b63 <insert_sorted_with_merge_freeList+0x748>
  8044bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8044be:	8b 50 08             	mov    0x8(%eax),%edx
  8044c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8044c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8044c7:	01 c2                	add    %eax,%edx
  8044c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044cc:	8b 40 08             	mov    0x8(%eax),%eax
  8044cf:	39 c2                	cmp    %eax,%edx
  8044d1:	0f 85 8c 06 00 00    	jne    804b63 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8044d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8044da:	8b 50 0c             	mov    0xc(%eax),%edx
  8044dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8044e3:	01 c2                	add    %eax,%edx
  8044e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8044e8:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8044eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8044ef:	75 17                	jne    804508 <insert_sorted_with_merge_freeList+0xed>
  8044f1:	83 ec 04             	sub    $0x4,%esp
  8044f4:	68 00 58 80 00       	push   $0x805800
  8044f9:	68 3c 01 00 00       	push   $0x13c
  8044fe:	68 57 57 80 00       	push   $0x805757
  804503:	e8 44 d4 ff ff       	call   80194c <_panic>
  804508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80450b:	8b 00                	mov    (%eax),%eax
  80450d:	85 c0                	test   %eax,%eax
  80450f:	74 10                	je     804521 <insert_sorted_with_merge_freeList+0x106>
  804511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804514:	8b 00                	mov    (%eax),%eax
  804516:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804519:	8b 52 04             	mov    0x4(%edx),%edx
  80451c:	89 50 04             	mov    %edx,0x4(%eax)
  80451f:	eb 0b                	jmp    80452c <insert_sorted_with_merge_freeList+0x111>
  804521:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804524:	8b 40 04             	mov    0x4(%eax),%eax
  804527:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80452c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80452f:	8b 40 04             	mov    0x4(%eax),%eax
  804532:	85 c0                	test   %eax,%eax
  804534:	74 0f                	je     804545 <insert_sorted_with_merge_freeList+0x12a>
  804536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804539:	8b 40 04             	mov    0x4(%eax),%eax
  80453c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80453f:	8b 12                	mov    (%edx),%edx
  804541:	89 10                	mov    %edx,(%eax)
  804543:	eb 0a                	jmp    80454f <insert_sorted_with_merge_freeList+0x134>
  804545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804548:	8b 00                	mov    (%eax),%eax
  80454a:	a3 38 61 80 00       	mov    %eax,0x806138
  80454f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804552:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80455b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804562:	a1 44 61 80 00       	mov    0x806144,%eax
  804567:	48                   	dec    %eax
  804568:	a3 44 61 80 00       	mov    %eax,0x806144
			head->size = 0;
  80456d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804570:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  804577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80457a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  804581:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804585:	75 17                	jne    80459e <insert_sorted_with_merge_freeList+0x183>
  804587:	83 ec 04             	sub    $0x4,%esp
  80458a:	68 34 57 80 00       	push   $0x805734
  80458f:	68 3f 01 00 00       	push   $0x13f
  804594:	68 57 57 80 00       	push   $0x805757
  804599:	e8 ae d3 ff ff       	call   80194c <_panic>
  80459e:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8045a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045a7:	89 10                	mov    %edx,(%eax)
  8045a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045ac:	8b 00                	mov    (%eax),%eax
  8045ae:	85 c0                	test   %eax,%eax
  8045b0:	74 0d                	je     8045bf <insert_sorted_with_merge_freeList+0x1a4>
  8045b2:	a1 48 61 80 00       	mov    0x806148,%eax
  8045b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8045ba:	89 50 04             	mov    %edx,0x4(%eax)
  8045bd:	eb 08                	jmp    8045c7 <insert_sorted_with_merge_freeList+0x1ac>
  8045bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045c2:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8045c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045ca:	a3 48 61 80 00       	mov    %eax,0x806148
  8045cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045d9:	a1 54 61 80 00       	mov    0x806154,%eax
  8045de:	40                   	inc    %eax
  8045df:	a3 54 61 80 00       	mov    %eax,0x806154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8045e4:	e9 7a 05 00 00       	jmp    804b63 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8045e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8045ec:	8b 50 08             	mov    0x8(%eax),%edx
  8045ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045f2:	8b 40 08             	mov    0x8(%eax),%eax
  8045f5:	39 c2                	cmp    %eax,%edx
  8045f7:	0f 82 14 01 00 00    	jb     804711 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8045fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804600:	8b 50 08             	mov    0x8(%eax),%edx
  804603:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804606:	8b 40 0c             	mov    0xc(%eax),%eax
  804609:	01 c2                	add    %eax,%edx
  80460b:	8b 45 08             	mov    0x8(%ebp),%eax
  80460e:	8b 40 08             	mov    0x8(%eax),%eax
  804611:	39 c2                	cmp    %eax,%edx
  804613:	0f 85 90 00 00 00    	jne    8046a9 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  804619:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80461c:	8b 50 0c             	mov    0xc(%eax),%edx
  80461f:	8b 45 08             	mov    0x8(%ebp),%eax
  804622:	8b 40 0c             	mov    0xc(%eax),%eax
  804625:	01 c2                	add    %eax,%edx
  804627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80462a:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80462d:	8b 45 08             	mov    0x8(%ebp),%eax
  804630:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  804637:	8b 45 08             	mov    0x8(%ebp),%eax
  80463a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  804641:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804645:	75 17                	jne    80465e <insert_sorted_with_merge_freeList+0x243>
  804647:	83 ec 04             	sub    $0x4,%esp
  80464a:	68 34 57 80 00       	push   $0x805734
  80464f:	68 49 01 00 00       	push   $0x149
  804654:	68 57 57 80 00       	push   $0x805757
  804659:	e8 ee d2 ff ff       	call   80194c <_panic>
  80465e:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804664:	8b 45 08             	mov    0x8(%ebp),%eax
  804667:	89 10                	mov    %edx,(%eax)
  804669:	8b 45 08             	mov    0x8(%ebp),%eax
  80466c:	8b 00                	mov    (%eax),%eax
  80466e:	85 c0                	test   %eax,%eax
  804670:	74 0d                	je     80467f <insert_sorted_with_merge_freeList+0x264>
  804672:	a1 48 61 80 00       	mov    0x806148,%eax
  804677:	8b 55 08             	mov    0x8(%ebp),%edx
  80467a:	89 50 04             	mov    %edx,0x4(%eax)
  80467d:	eb 08                	jmp    804687 <insert_sorted_with_merge_freeList+0x26c>
  80467f:	8b 45 08             	mov    0x8(%ebp),%eax
  804682:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804687:	8b 45 08             	mov    0x8(%ebp),%eax
  80468a:	a3 48 61 80 00       	mov    %eax,0x806148
  80468f:	8b 45 08             	mov    0x8(%ebp),%eax
  804692:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804699:	a1 54 61 80 00       	mov    0x806154,%eax
  80469e:	40                   	inc    %eax
  80469f:	a3 54 61 80 00       	mov    %eax,0x806154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8046a4:	e9 bb 04 00 00       	jmp    804b64 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8046a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8046ad:	75 17                	jne    8046c6 <insert_sorted_with_merge_freeList+0x2ab>
  8046af:	83 ec 04             	sub    $0x4,%esp
  8046b2:	68 a8 57 80 00       	push   $0x8057a8
  8046b7:	68 4c 01 00 00       	push   $0x14c
  8046bc:	68 57 57 80 00       	push   $0x805757
  8046c1:	e8 86 d2 ff ff       	call   80194c <_panic>
  8046c6:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  8046cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8046cf:	89 50 04             	mov    %edx,0x4(%eax)
  8046d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8046d5:	8b 40 04             	mov    0x4(%eax),%eax
  8046d8:	85 c0                	test   %eax,%eax
  8046da:	74 0c                	je     8046e8 <insert_sorted_with_merge_freeList+0x2cd>
  8046dc:	a1 3c 61 80 00       	mov    0x80613c,%eax
  8046e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8046e4:	89 10                	mov    %edx,(%eax)
  8046e6:	eb 08                	jmp    8046f0 <insert_sorted_with_merge_freeList+0x2d5>
  8046e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8046eb:	a3 38 61 80 00       	mov    %eax,0x806138
  8046f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8046f3:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8046f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8046fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804701:	a1 44 61 80 00       	mov    0x806144,%eax
  804706:	40                   	inc    %eax
  804707:	a3 44 61 80 00       	mov    %eax,0x806144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80470c:	e9 53 04 00 00       	jmp    804b64 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  804711:	a1 38 61 80 00       	mov    0x806138,%eax
  804716:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804719:	e9 15 04 00 00       	jmp    804b33 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80471e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804721:	8b 00                	mov    (%eax),%eax
  804723:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  804726:	8b 45 08             	mov    0x8(%ebp),%eax
  804729:	8b 50 08             	mov    0x8(%eax),%edx
  80472c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80472f:	8b 40 08             	mov    0x8(%eax),%eax
  804732:	39 c2                	cmp    %eax,%edx
  804734:	0f 86 f1 03 00 00    	jbe    804b2b <insert_sorted_with_merge_freeList+0x710>
  80473a:	8b 45 08             	mov    0x8(%ebp),%eax
  80473d:	8b 50 08             	mov    0x8(%eax),%edx
  804740:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804743:	8b 40 08             	mov    0x8(%eax),%eax
  804746:	39 c2                	cmp    %eax,%edx
  804748:	0f 83 dd 03 00 00    	jae    804b2b <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80474e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804751:	8b 50 08             	mov    0x8(%eax),%edx
  804754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804757:	8b 40 0c             	mov    0xc(%eax),%eax
  80475a:	01 c2                	add    %eax,%edx
  80475c:	8b 45 08             	mov    0x8(%ebp),%eax
  80475f:	8b 40 08             	mov    0x8(%eax),%eax
  804762:	39 c2                	cmp    %eax,%edx
  804764:	0f 85 b9 01 00 00    	jne    804923 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80476a:	8b 45 08             	mov    0x8(%ebp),%eax
  80476d:	8b 50 08             	mov    0x8(%eax),%edx
  804770:	8b 45 08             	mov    0x8(%ebp),%eax
  804773:	8b 40 0c             	mov    0xc(%eax),%eax
  804776:	01 c2                	add    %eax,%edx
  804778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80477b:	8b 40 08             	mov    0x8(%eax),%eax
  80477e:	39 c2                	cmp    %eax,%edx
  804780:	0f 85 0d 01 00 00    	jne    804893 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  804786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804789:	8b 50 0c             	mov    0xc(%eax),%edx
  80478c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80478f:	8b 40 0c             	mov    0xc(%eax),%eax
  804792:	01 c2                	add    %eax,%edx
  804794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804797:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80479a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80479e:	75 17                	jne    8047b7 <insert_sorted_with_merge_freeList+0x39c>
  8047a0:	83 ec 04             	sub    $0x4,%esp
  8047a3:	68 00 58 80 00       	push   $0x805800
  8047a8:	68 5c 01 00 00       	push   $0x15c
  8047ad:	68 57 57 80 00       	push   $0x805757
  8047b2:	e8 95 d1 ff ff       	call   80194c <_panic>
  8047b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047ba:	8b 00                	mov    (%eax),%eax
  8047bc:	85 c0                	test   %eax,%eax
  8047be:	74 10                	je     8047d0 <insert_sorted_with_merge_freeList+0x3b5>
  8047c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047c3:	8b 00                	mov    (%eax),%eax
  8047c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8047c8:	8b 52 04             	mov    0x4(%edx),%edx
  8047cb:	89 50 04             	mov    %edx,0x4(%eax)
  8047ce:	eb 0b                	jmp    8047db <insert_sorted_with_merge_freeList+0x3c0>
  8047d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047d3:	8b 40 04             	mov    0x4(%eax),%eax
  8047d6:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8047db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047de:	8b 40 04             	mov    0x4(%eax),%eax
  8047e1:	85 c0                	test   %eax,%eax
  8047e3:	74 0f                	je     8047f4 <insert_sorted_with_merge_freeList+0x3d9>
  8047e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047e8:	8b 40 04             	mov    0x4(%eax),%eax
  8047eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8047ee:	8b 12                	mov    (%edx),%edx
  8047f0:	89 10                	mov    %edx,(%eax)
  8047f2:	eb 0a                	jmp    8047fe <insert_sorted_with_merge_freeList+0x3e3>
  8047f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047f7:	8b 00                	mov    (%eax),%eax
  8047f9:	a3 38 61 80 00       	mov    %eax,0x806138
  8047fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804801:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804807:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80480a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804811:	a1 44 61 80 00       	mov    0x806144,%eax
  804816:	48                   	dec    %eax
  804817:	a3 44 61 80 00       	mov    %eax,0x806144
						nextBlock->sva = 0;
  80481c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80481f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  804826:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804829:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  804830:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804834:	75 17                	jne    80484d <insert_sorted_with_merge_freeList+0x432>
  804836:	83 ec 04             	sub    $0x4,%esp
  804839:	68 34 57 80 00       	push   $0x805734
  80483e:	68 5f 01 00 00       	push   $0x15f
  804843:	68 57 57 80 00       	push   $0x805757
  804848:	e8 ff d0 ff ff       	call   80194c <_panic>
  80484d:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804853:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804856:	89 10                	mov    %edx,(%eax)
  804858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80485b:	8b 00                	mov    (%eax),%eax
  80485d:	85 c0                	test   %eax,%eax
  80485f:	74 0d                	je     80486e <insert_sorted_with_merge_freeList+0x453>
  804861:	a1 48 61 80 00       	mov    0x806148,%eax
  804866:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804869:	89 50 04             	mov    %edx,0x4(%eax)
  80486c:	eb 08                	jmp    804876 <insert_sorted_with_merge_freeList+0x45b>
  80486e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804871:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804876:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804879:	a3 48 61 80 00       	mov    %eax,0x806148
  80487e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804881:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804888:	a1 54 61 80 00       	mov    0x806154,%eax
  80488d:	40                   	inc    %eax
  80488e:	a3 54 61 80 00       	mov    %eax,0x806154
					}
					currentBlock->size += blockToInsert->size;
  804893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804896:	8b 50 0c             	mov    0xc(%eax),%edx
  804899:	8b 45 08             	mov    0x8(%ebp),%eax
  80489c:	8b 40 0c             	mov    0xc(%eax),%eax
  80489f:	01 c2                	add    %eax,%edx
  8048a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048a4:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8048a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8048aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8048b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8048b4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8048bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8048bf:	75 17                	jne    8048d8 <insert_sorted_with_merge_freeList+0x4bd>
  8048c1:	83 ec 04             	sub    $0x4,%esp
  8048c4:	68 34 57 80 00       	push   $0x805734
  8048c9:	68 64 01 00 00       	push   $0x164
  8048ce:	68 57 57 80 00       	push   $0x805757
  8048d3:	e8 74 d0 ff ff       	call   80194c <_panic>
  8048d8:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8048de:	8b 45 08             	mov    0x8(%ebp),%eax
  8048e1:	89 10                	mov    %edx,(%eax)
  8048e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8048e6:	8b 00                	mov    (%eax),%eax
  8048e8:	85 c0                	test   %eax,%eax
  8048ea:	74 0d                	je     8048f9 <insert_sorted_with_merge_freeList+0x4de>
  8048ec:	a1 48 61 80 00       	mov    0x806148,%eax
  8048f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8048f4:	89 50 04             	mov    %edx,0x4(%eax)
  8048f7:	eb 08                	jmp    804901 <insert_sorted_with_merge_freeList+0x4e6>
  8048f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8048fc:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804901:	8b 45 08             	mov    0x8(%ebp),%eax
  804904:	a3 48 61 80 00       	mov    %eax,0x806148
  804909:	8b 45 08             	mov    0x8(%ebp),%eax
  80490c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804913:	a1 54 61 80 00       	mov    0x806154,%eax
  804918:	40                   	inc    %eax
  804919:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  80491e:	e9 41 02 00 00       	jmp    804b64 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  804923:	8b 45 08             	mov    0x8(%ebp),%eax
  804926:	8b 50 08             	mov    0x8(%eax),%edx
  804929:	8b 45 08             	mov    0x8(%ebp),%eax
  80492c:	8b 40 0c             	mov    0xc(%eax),%eax
  80492f:	01 c2                	add    %eax,%edx
  804931:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804934:	8b 40 08             	mov    0x8(%eax),%eax
  804937:	39 c2                	cmp    %eax,%edx
  804939:	0f 85 7c 01 00 00    	jne    804abb <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80493f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804943:	74 06                	je     80494b <insert_sorted_with_merge_freeList+0x530>
  804945:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804949:	75 17                	jne    804962 <insert_sorted_with_merge_freeList+0x547>
  80494b:	83 ec 04             	sub    $0x4,%esp
  80494e:	68 70 57 80 00       	push   $0x805770
  804953:	68 69 01 00 00       	push   $0x169
  804958:	68 57 57 80 00       	push   $0x805757
  80495d:	e8 ea cf ff ff       	call   80194c <_panic>
  804962:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804965:	8b 50 04             	mov    0x4(%eax),%edx
  804968:	8b 45 08             	mov    0x8(%ebp),%eax
  80496b:	89 50 04             	mov    %edx,0x4(%eax)
  80496e:	8b 45 08             	mov    0x8(%ebp),%eax
  804971:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804974:	89 10                	mov    %edx,(%eax)
  804976:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804979:	8b 40 04             	mov    0x4(%eax),%eax
  80497c:	85 c0                	test   %eax,%eax
  80497e:	74 0d                	je     80498d <insert_sorted_with_merge_freeList+0x572>
  804980:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804983:	8b 40 04             	mov    0x4(%eax),%eax
  804986:	8b 55 08             	mov    0x8(%ebp),%edx
  804989:	89 10                	mov    %edx,(%eax)
  80498b:	eb 08                	jmp    804995 <insert_sorted_with_merge_freeList+0x57a>
  80498d:	8b 45 08             	mov    0x8(%ebp),%eax
  804990:	a3 38 61 80 00       	mov    %eax,0x806138
  804995:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804998:	8b 55 08             	mov    0x8(%ebp),%edx
  80499b:	89 50 04             	mov    %edx,0x4(%eax)
  80499e:	a1 44 61 80 00       	mov    0x806144,%eax
  8049a3:	40                   	inc    %eax
  8049a4:	a3 44 61 80 00       	mov    %eax,0x806144
					blockToInsert->size += nextBlock->size;
  8049a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8049ac:	8b 50 0c             	mov    0xc(%eax),%edx
  8049af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8049b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8049b5:	01 c2                	add    %eax,%edx
  8049b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8049ba:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8049bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8049c1:	75 17                	jne    8049da <insert_sorted_with_merge_freeList+0x5bf>
  8049c3:	83 ec 04             	sub    $0x4,%esp
  8049c6:	68 00 58 80 00       	push   $0x805800
  8049cb:	68 6b 01 00 00       	push   $0x16b
  8049d0:	68 57 57 80 00       	push   $0x805757
  8049d5:	e8 72 cf ff ff       	call   80194c <_panic>
  8049da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8049dd:	8b 00                	mov    (%eax),%eax
  8049df:	85 c0                	test   %eax,%eax
  8049e1:	74 10                	je     8049f3 <insert_sorted_with_merge_freeList+0x5d8>
  8049e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8049e6:	8b 00                	mov    (%eax),%eax
  8049e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8049eb:	8b 52 04             	mov    0x4(%edx),%edx
  8049ee:	89 50 04             	mov    %edx,0x4(%eax)
  8049f1:	eb 0b                	jmp    8049fe <insert_sorted_with_merge_freeList+0x5e3>
  8049f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8049f6:	8b 40 04             	mov    0x4(%eax),%eax
  8049f9:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8049fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a01:	8b 40 04             	mov    0x4(%eax),%eax
  804a04:	85 c0                	test   %eax,%eax
  804a06:	74 0f                	je     804a17 <insert_sorted_with_merge_freeList+0x5fc>
  804a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a0b:	8b 40 04             	mov    0x4(%eax),%eax
  804a0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804a11:	8b 12                	mov    (%edx),%edx
  804a13:	89 10                	mov    %edx,(%eax)
  804a15:	eb 0a                	jmp    804a21 <insert_sorted_with_merge_freeList+0x606>
  804a17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a1a:	8b 00                	mov    (%eax),%eax
  804a1c:	a3 38 61 80 00       	mov    %eax,0x806138
  804a21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804a34:	a1 44 61 80 00       	mov    0x806144,%eax
  804a39:	48                   	dec    %eax
  804a3a:	a3 44 61 80 00       	mov    %eax,0x806144
					nextBlock->sva = 0;
  804a3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  804a49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a4c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  804a53:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804a57:	75 17                	jne    804a70 <insert_sorted_with_merge_freeList+0x655>
  804a59:	83 ec 04             	sub    $0x4,%esp
  804a5c:	68 34 57 80 00       	push   $0x805734
  804a61:	68 6e 01 00 00       	push   $0x16e
  804a66:	68 57 57 80 00       	push   $0x805757
  804a6b:	e8 dc ce ff ff       	call   80194c <_panic>
  804a70:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804a76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a79:	89 10                	mov    %edx,(%eax)
  804a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a7e:	8b 00                	mov    (%eax),%eax
  804a80:	85 c0                	test   %eax,%eax
  804a82:	74 0d                	je     804a91 <insert_sorted_with_merge_freeList+0x676>
  804a84:	a1 48 61 80 00       	mov    0x806148,%eax
  804a89:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804a8c:	89 50 04             	mov    %edx,0x4(%eax)
  804a8f:	eb 08                	jmp    804a99 <insert_sorted_with_merge_freeList+0x67e>
  804a91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a94:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804a99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804a9c:	a3 48 61 80 00       	mov    %eax,0x806148
  804aa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804aa4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804aab:	a1 54 61 80 00       	mov    0x806154,%eax
  804ab0:	40                   	inc    %eax
  804ab1:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  804ab6:	e9 a9 00 00 00       	jmp    804b64 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  804abb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804abf:	74 06                	je     804ac7 <insert_sorted_with_merge_freeList+0x6ac>
  804ac1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804ac5:	75 17                	jne    804ade <insert_sorted_with_merge_freeList+0x6c3>
  804ac7:	83 ec 04             	sub    $0x4,%esp
  804aca:	68 cc 57 80 00       	push   $0x8057cc
  804acf:	68 73 01 00 00       	push   $0x173
  804ad4:	68 57 57 80 00       	push   $0x805757
  804ad9:	e8 6e ce ff ff       	call   80194c <_panic>
  804ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ae1:	8b 10                	mov    (%eax),%edx
  804ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  804ae6:	89 10                	mov    %edx,(%eax)
  804ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  804aeb:	8b 00                	mov    (%eax),%eax
  804aed:	85 c0                	test   %eax,%eax
  804aef:	74 0b                	je     804afc <insert_sorted_with_merge_freeList+0x6e1>
  804af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804af4:	8b 00                	mov    (%eax),%eax
  804af6:	8b 55 08             	mov    0x8(%ebp),%edx
  804af9:	89 50 04             	mov    %edx,0x4(%eax)
  804afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804aff:	8b 55 08             	mov    0x8(%ebp),%edx
  804b02:	89 10                	mov    %edx,(%eax)
  804b04:	8b 45 08             	mov    0x8(%ebp),%eax
  804b07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804b0a:	89 50 04             	mov    %edx,0x4(%eax)
  804b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  804b10:	8b 00                	mov    (%eax),%eax
  804b12:	85 c0                	test   %eax,%eax
  804b14:	75 08                	jne    804b1e <insert_sorted_with_merge_freeList+0x703>
  804b16:	8b 45 08             	mov    0x8(%ebp),%eax
  804b19:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804b1e:	a1 44 61 80 00       	mov    0x806144,%eax
  804b23:	40                   	inc    %eax
  804b24:	a3 44 61 80 00       	mov    %eax,0x806144
					break;
  804b29:	eb 39                	jmp    804b64 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  804b2b:	a1 40 61 80 00       	mov    0x806140,%eax
  804b30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804b33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804b37:	74 07                	je     804b40 <insert_sorted_with_merge_freeList+0x725>
  804b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804b3c:	8b 00                	mov    (%eax),%eax
  804b3e:	eb 05                	jmp    804b45 <insert_sorted_with_merge_freeList+0x72a>
  804b40:	b8 00 00 00 00       	mov    $0x0,%eax
  804b45:	a3 40 61 80 00       	mov    %eax,0x806140
  804b4a:	a1 40 61 80 00       	mov    0x806140,%eax
  804b4f:	85 c0                	test   %eax,%eax
  804b51:	0f 85 c7 fb ff ff    	jne    80471e <insert_sorted_with_merge_freeList+0x303>
  804b57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804b5b:	0f 85 bd fb ff ff    	jne    80471e <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804b61:	eb 01                	jmp    804b64 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  804b63:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804b64:	90                   	nop
  804b65:	c9                   	leave  
  804b66:	c3                   	ret    
  804b67:	90                   	nop

00804b68 <__udivdi3>:
  804b68:	55                   	push   %ebp
  804b69:	57                   	push   %edi
  804b6a:	56                   	push   %esi
  804b6b:	53                   	push   %ebx
  804b6c:	83 ec 1c             	sub    $0x1c,%esp
  804b6f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804b73:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804b77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804b7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804b7f:	89 ca                	mov    %ecx,%edx
  804b81:	89 f8                	mov    %edi,%eax
  804b83:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804b87:	85 f6                	test   %esi,%esi
  804b89:	75 2d                	jne    804bb8 <__udivdi3+0x50>
  804b8b:	39 cf                	cmp    %ecx,%edi
  804b8d:	77 65                	ja     804bf4 <__udivdi3+0x8c>
  804b8f:	89 fd                	mov    %edi,%ebp
  804b91:	85 ff                	test   %edi,%edi
  804b93:	75 0b                	jne    804ba0 <__udivdi3+0x38>
  804b95:	b8 01 00 00 00       	mov    $0x1,%eax
  804b9a:	31 d2                	xor    %edx,%edx
  804b9c:	f7 f7                	div    %edi
  804b9e:	89 c5                	mov    %eax,%ebp
  804ba0:	31 d2                	xor    %edx,%edx
  804ba2:	89 c8                	mov    %ecx,%eax
  804ba4:	f7 f5                	div    %ebp
  804ba6:	89 c1                	mov    %eax,%ecx
  804ba8:	89 d8                	mov    %ebx,%eax
  804baa:	f7 f5                	div    %ebp
  804bac:	89 cf                	mov    %ecx,%edi
  804bae:	89 fa                	mov    %edi,%edx
  804bb0:	83 c4 1c             	add    $0x1c,%esp
  804bb3:	5b                   	pop    %ebx
  804bb4:	5e                   	pop    %esi
  804bb5:	5f                   	pop    %edi
  804bb6:	5d                   	pop    %ebp
  804bb7:	c3                   	ret    
  804bb8:	39 ce                	cmp    %ecx,%esi
  804bba:	77 28                	ja     804be4 <__udivdi3+0x7c>
  804bbc:	0f bd fe             	bsr    %esi,%edi
  804bbf:	83 f7 1f             	xor    $0x1f,%edi
  804bc2:	75 40                	jne    804c04 <__udivdi3+0x9c>
  804bc4:	39 ce                	cmp    %ecx,%esi
  804bc6:	72 0a                	jb     804bd2 <__udivdi3+0x6a>
  804bc8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804bcc:	0f 87 9e 00 00 00    	ja     804c70 <__udivdi3+0x108>
  804bd2:	b8 01 00 00 00       	mov    $0x1,%eax
  804bd7:	89 fa                	mov    %edi,%edx
  804bd9:	83 c4 1c             	add    $0x1c,%esp
  804bdc:	5b                   	pop    %ebx
  804bdd:	5e                   	pop    %esi
  804bde:	5f                   	pop    %edi
  804bdf:	5d                   	pop    %ebp
  804be0:	c3                   	ret    
  804be1:	8d 76 00             	lea    0x0(%esi),%esi
  804be4:	31 ff                	xor    %edi,%edi
  804be6:	31 c0                	xor    %eax,%eax
  804be8:	89 fa                	mov    %edi,%edx
  804bea:	83 c4 1c             	add    $0x1c,%esp
  804bed:	5b                   	pop    %ebx
  804bee:	5e                   	pop    %esi
  804bef:	5f                   	pop    %edi
  804bf0:	5d                   	pop    %ebp
  804bf1:	c3                   	ret    
  804bf2:	66 90                	xchg   %ax,%ax
  804bf4:	89 d8                	mov    %ebx,%eax
  804bf6:	f7 f7                	div    %edi
  804bf8:	31 ff                	xor    %edi,%edi
  804bfa:	89 fa                	mov    %edi,%edx
  804bfc:	83 c4 1c             	add    $0x1c,%esp
  804bff:	5b                   	pop    %ebx
  804c00:	5e                   	pop    %esi
  804c01:	5f                   	pop    %edi
  804c02:	5d                   	pop    %ebp
  804c03:	c3                   	ret    
  804c04:	bd 20 00 00 00       	mov    $0x20,%ebp
  804c09:	89 eb                	mov    %ebp,%ebx
  804c0b:	29 fb                	sub    %edi,%ebx
  804c0d:	89 f9                	mov    %edi,%ecx
  804c0f:	d3 e6                	shl    %cl,%esi
  804c11:	89 c5                	mov    %eax,%ebp
  804c13:	88 d9                	mov    %bl,%cl
  804c15:	d3 ed                	shr    %cl,%ebp
  804c17:	89 e9                	mov    %ebp,%ecx
  804c19:	09 f1                	or     %esi,%ecx
  804c1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804c1f:	89 f9                	mov    %edi,%ecx
  804c21:	d3 e0                	shl    %cl,%eax
  804c23:	89 c5                	mov    %eax,%ebp
  804c25:	89 d6                	mov    %edx,%esi
  804c27:	88 d9                	mov    %bl,%cl
  804c29:	d3 ee                	shr    %cl,%esi
  804c2b:	89 f9                	mov    %edi,%ecx
  804c2d:	d3 e2                	shl    %cl,%edx
  804c2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804c33:	88 d9                	mov    %bl,%cl
  804c35:	d3 e8                	shr    %cl,%eax
  804c37:	09 c2                	or     %eax,%edx
  804c39:	89 d0                	mov    %edx,%eax
  804c3b:	89 f2                	mov    %esi,%edx
  804c3d:	f7 74 24 0c          	divl   0xc(%esp)
  804c41:	89 d6                	mov    %edx,%esi
  804c43:	89 c3                	mov    %eax,%ebx
  804c45:	f7 e5                	mul    %ebp
  804c47:	39 d6                	cmp    %edx,%esi
  804c49:	72 19                	jb     804c64 <__udivdi3+0xfc>
  804c4b:	74 0b                	je     804c58 <__udivdi3+0xf0>
  804c4d:	89 d8                	mov    %ebx,%eax
  804c4f:	31 ff                	xor    %edi,%edi
  804c51:	e9 58 ff ff ff       	jmp    804bae <__udivdi3+0x46>
  804c56:	66 90                	xchg   %ax,%ax
  804c58:	8b 54 24 08          	mov    0x8(%esp),%edx
  804c5c:	89 f9                	mov    %edi,%ecx
  804c5e:	d3 e2                	shl    %cl,%edx
  804c60:	39 c2                	cmp    %eax,%edx
  804c62:	73 e9                	jae    804c4d <__udivdi3+0xe5>
  804c64:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804c67:	31 ff                	xor    %edi,%edi
  804c69:	e9 40 ff ff ff       	jmp    804bae <__udivdi3+0x46>
  804c6e:	66 90                	xchg   %ax,%ax
  804c70:	31 c0                	xor    %eax,%eax
  804c72:	e9 37 ff ff ff       	jmp    804bae <__udivdi3+0x46>
  804c77:	90                   	nop

00804c78 <__umoddi3>:
  804c78:	55                   	push   %ebp
  804c79:	57                   	push   %edi
  804c7a:	56                   	push   %esi
  804c7b:	53                   	push   %ebx
  804c7c:	83 ec 1c             	sub    $0x1c,%esp
  804c7f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804c83:	8b 74 24 34          	mov    0x34(%esp),%esi
  804c87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804c8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804c8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804c93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804c97:	89 f3                	mov    %esi,%ebx
  804c99:	89 fa                	mov    %edi,%edx
  804c9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804c9f:	89 34 24             	mov    %esi,(%esp)
  804ca2:	85 c0                	test   %eax,%eax
  804ca4:	75 1a                	jne    804cc0 <__umoddi3+0x48>
  804ca6:	39 f7                	cmp    %esi,%edi
  804ca8:	0f 86 a2 00 00 00    	jbe    804d50 <__umoddi3+0xd8>
  804cae:	89 c8                	mov    %ecx,%eax
  804cb0:	89 f2                	mov    %esi,%edx
  804cb2:	f7 f7                	div    %edi
  804cb4:	89 d0                	mov    %edx,%eax
  804cb6:	31 d2                	xor    %edx,%edx
  804cb8:	83 c4 1c             	add    $0x1c,%esp
  804cbb:	5b                   	pop    %ebx
  804cbc:	5e                   	pop    %esi
  804cbd:	5f                   	pop    %edi
  804cbe:	5d                   	pop    %ebp
  804cbf:	c3                   	ret    
  804cc0:	39 f0                	cmp    %esi,%eax
  804cc2:	0f 87 ac 00 00 00    	ja     804d74 <__umoddi3+0xfc>
  804cc8:	0f bd e8             	bsr    %eax,%ebp
  804ccb:	83 f5 1f             	xor    $0x1f,%ebp
  804cce:	0f 84 ac 00 00 00    	je     804d80 <__umoddi3+0x108>
  804cd4:	bf 20 00 00 00       	mov    $0x20,%edi
  804cd9:	29 ef                	sub    %ebp,%edi
  804cdb:	89 fe                	mov    %edi,%esi
  804cdd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804ce1:	89 e9                	mov    %ebp,%ecx
  804ce3:	d3 e0                	shl    %cl,%eax
  804ce5:	89 d7                	mov    %edx,%edi
  804ce7:	89 f1                	mov    %esi,%ecx
  804ce9:	d3 ef                	shr    %cl,%edi
  804ceb:	09 c7                	or     %eax,%edi
  804ced:	89 e9                	mov    %ebp,%ecx
  804cef:	d3 e2                	shl    %cl,%edx
  804cf1:	89 14 24             	mov    %edx,(%esp)
  804cf4:	89 d8                	mov    %ebx,%eax
  804cf6:	d3 e0                	shl    %cl,%eax
  804cf8:	89 c2                	mov    %eax,%edx
  804cfa:	8b 44 24 08          	mov    0x8(%esp),%eax
  804cfe:	d3 e0                	shl    %cl,%eax
  804d00:	89 44 24 04          	mov    %eax,0x4(%esp)
  804d04:	8b 44 24 08          	mov    0x8(%esp),%eax
  804d08:	89 f1                	mov    %esi,%ecx
  804d0a:	d3 e8                	shr    %cl,%eax
  804d0c:	09 d0                	or     %edx,%eax
  804d0e:	d3 eb                	shr    %cl,%ebx
  804d10:	89 da                	mov    %ebx,%edx
  804d12:	f7 f7                	div    %edi
  804d14:	89 d3                	mov    %edx,%ebx
  804d16:	f7 24 24             	mull   (%esp)
  804d19:	89 c6                	mov    %eax,%esi
  804d1b:	89 d1                	mov    %edx,%ecx
  804d1d:	39 d3                	cmp    %edx,%ebx
  804d1f:	0f 82 87 00 00 00    	jb     804dac <__umoddi3+0x134>
  804d25:	0f 84 91 00 00 00    	je     804dbc <__umoddi3+0x144>
  804d2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  804d2f:	29 f2                	sub    %esi,%edx
  804d31:	19 cb                	sbb    %ecx,%ebx
  804d33:	89 d8                	mov    %ebx,%eax
  804d35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804d39:	d3 e0                	shl    %cl,%eax
  804d3b:	89 e9                	mov    %ebp,%ecx
  804d3d:	d3 ea                	shr    %cl,%edx
  804d3f:	09 d0                	or     %edx,%eax
  804d41:	89 e9                	mov    %ebp,%ecx
  804d43:	d3 eb                	shr    %cl,%ebx
  804d45:	89 da                	mov    %ebx,%edx
  804d47:	83 c4 1c             	add    $0x1c,%esp
  804d4a:	5b                   	pop    %ebx
  804d4b:	5e                   	pop    %esi
  804d4c:	5f                   	pop    %edi
  804d4d:	5d                   	pop    %ebp
  804d4e:	c3                   	ret    
  804d4f:	90                   	nop
  804d50:	89 fd                	mov    %edi,%ebp
  804d52:	85 ff                	test   %edi,%edi
  804d54:	75 0b                	jne    804d61 <__umoddi3+0xe9>
  804d56:	b8 01 00 00 00       	mov    $0x1,%eax
  804d5b:	31 d2                	xor    %edx,%edx
  804d5d:	f7 f7                	div    %edi
  804d5f:	89 c5                	mov    %eax,%ebp
  804d61:	89 f0                	mov    %esi,%eax
  804d63:	31 d2                	xor    %edx,%edx
  804d65:	f7 f5                	div    %ebp
  804d67:	89 c8                	mov    %ecx,%eax
  804d69:	f7 f5                	div    %ebp
  804d6b:	89 d0                	mov    %edx,%eax
  804d6d:	e9 44 ff ff ff       	jmp    804cb6 <__umoddi3+0x3e>
  804d72:	66 90                	xchg   %ax,%ax
  804d74:	89 c8                	mov    %ecx,%eax
  804d76:	89 f2                	mov    %esi,%edx
  804d78:	83 c4 1c             	add    $0x1c,%esp
  804d7b:	5b                   	pop    %ebx
  804d7c:	5e                   	pop    %esi
  804d7d:	5f                   	pop    %edi
  804d7e:	5d                   	pop    %ebp
  804d7f:	c3                   	ret    
  804d80:	3b 04 24             	cmp    (%esp),%eax
  804d83:	72 06                	jb     804d8b <__umoddi3+0x113>
  804d85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804d89:	77 0f                	ja     804d9a <__umoddi3+0x122>
  804d8b:	89 f2                	mov    %esi,%edx
  804d8d:	29 f9                	sub    %edi,%ecx
  804d8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804d93:	89 14 24             	mov    %edx,(%esp)
  804d96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804d9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  804d9e:	8b 14 24             	mov    (%esp),%edx
  804da1:	83 c4 1c             	add    $0x1c,%esp
  804da4:	5b                   	pop    %ebx
  804da5:	5e                   	pop    %esi
  804da6:	5f                   	pop    %edi
  804da7:	5d                   	pop    %ebp
  804da8:	c3                   	ret    
  804da9:	8d 76 00             	lea    0x0(%esi),%esi
  804dac:	2b 04 24             	sub    (%esp),%eax
  804daf:	19 fa                	sbb    %edi,%edx
  804db1:	89 d1                	mov    %edx,%ecx
  804db3:	89 c6                	mov    %eax,%esi
  804db5:	e9 71 ff ff ff       	jmp    804d2b <__umoddi3+0xb3>
  804dba:	66 90                	xchg   %ax,%ax
  804dbc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804dc0:	72 ea                	jb     804dac <__umoddi3+0x134>
  804dc2:	89 d9                	mov    %ebx,%ecx
  804dc4:	e9 62 ff ff ff       	jmp    804d2b <__umoddi3+0xb3>
