
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
  800031:	e8 69 18 00 00       	call   80189f <libmain>
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
  800050:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800079:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800091:	68 20 34 80 00       	push   $0x803420
  800096:	6a 1a                	push   $0x1a
  800098:	68 3c 34 80 00       	push   $0x80343c
  80009d:	e8 39 19 00 00       	call   8019db <_panic>





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
  8000d7:	e8 57 29 00 00       	call   802a33 <malloc>
  8000dc:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 5e 2b 00 00       	call   802c42 <sys_calculate_free_frames>
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
  8000fb:	e8 e2 2b 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  800100:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 1f 29 00 00       	call   802a33 <malloc>
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
  800137:	68 50 34 80 00       	push   $0x803450
  80013c:	6a 3a                	push   $0x3a
  80013e:	68 3c 34 80 00       	push   $0x80343c
  800143:	e8 93 18 00 00       	call   8019db <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 95 2b 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  80014d:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800150:	3d 00 02 00 00       	cmp    $0x200,%eax
  800155:	74 14                	je     80016b <_main+0x133>
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	68 b8 34 80 00       	push   $0x8034b8
  80015f:	6a 3b                	push   $0x3b
  800161:	68 3c 34 80 00       	push   $0x80343c
  800166:	e8 70 18 00 00       	call   8019db <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  80016b:	e8 d2 2a 00 00       	call   802c42 <sys_calculate_free_frames>
  800170:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800173:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800176:	01 c0                	add    %eax,%eax
  800178:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017b:	48                   	dec    %eax
  80017c:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017f:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800185:	89 45 b8             	mov    %eax,-0x48(%ebp)
		byteArr[0] = minByte ;
  800188:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80018b:	8a 55 db             	mov    -0x25(%ebp),%dl
  80018e:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800190:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800193:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800196:	01 c2                	add    %eax,%edx
  800198:	8a 45 da             	mov    -0x26(%ebp),%al
  80019b:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80019d:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8001a0:	e8 9d 2a 00 00       	call   802c42 <sys_calculate_free_frames>
  8001a5:	29 c3                	sub    %eax,%ebx
  8001a7:	89 d8                	mov    %ebx,%eax
  8001a9:	83 f8 03             	cmp    $0x3,%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 e8 34 80 00       	push   $0x8034e8
  8001b6:	6a 42                	push   $0x42
  8001b8:	68 3c 34 80 00       	push   $0x80343c
  8001bd:	e8 19 18 00 00       	call   8019db <_panic>
		int var;
		int found = 0;
  8001c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001d0:	e9 82 00 00 00       	jmp    800257 <_main+0x21f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001da:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001e3:	89 d0                	mov    %edx,%eax
  8001e5:	01 c0                	add    %eax,%eax
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	c1 e0 03             	shl    $0x3,%eax
  8001ec:	01 c8                	add    %ecx,%eax
  8001ee:	8b 00                	mov    (%eax),%eax
  8001f0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001f3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001fb:	89 c2                	mov    %eax,%edx
  8001fd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800200:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800203:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800206:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020b:	39 c2                	cmp    %eax,%edx
  80020d:	75 03                	jne    800212 <_main+0x1da>
				found++;
  80020f:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  800212:	a1 20 40 80 00       	mov    0x804020,%eax
  800217:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80021d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800220:	89 d0                	mov    %edx,%eax
  800222:	01 c0                	add    %eax,%eax
  800224:	01 d0                	add    %edx,%eax
  800226:	c1 e0 03             	shl    $0x3,%eax
  800229:	01 c8                	add    %ecx,%eax
  80022b:	8b 00                	mov    (%eax),%eax
  80022d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800230:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800233:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800238:	89 c1                	mov    %eax,%ecx
  80023a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80023d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800240:	01 d0                	add    %edx,%eax
  800242:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800245:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800248:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024d:	39 c1                	cmp    %eax,%ecx
  80024f:	75 03                	jne    800254 <_main+0x21c>
				found++;
  800251:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr[0] = minByte ;
		byteArr[lastIndexOfByte] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int var;
		int found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800254:	ff 45 ec             	incl   -0x14(%ebp)
  800257:	a1 20 40 80 00       	mov    0x804020,%eax
  80025c:	8b 50 74             	mov    0x74(%eax),%edx
  80025f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800262:	39 c2                	cmp    %eax,%edx
  800264:	0f 87 6b ff ff ff    	ja     8001d5 <_main+0x19d>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80026a:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  80026e:	74 14                	je     800284 <_main+0x24c>
  800270:	83 ec 04             	sub    $0x4,%esp
  800273:	68 2c 35 80 00       	push   $0x80352c
  800278:	6a 4c                	push   $0x4c
  80027a:	68 3c 34 80 00       	push   $0x80343c
  80027f:	e8 57 17 00 00       	call   8019db <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800284:	e8 59 2a 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  800289:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80028c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028f:	01 c0                	add    %eax,%eax
  800291:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	50                   	push   %eax
  800298:	e8 96 27 00 00       	call   802a33 <malloc>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 85 6c fe ff ff    	mov    %eax,-0x194(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a6:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  8002ac:	89 c2                	mov    %eax,%edx
  8002ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b1:	01 c0                	add    %eax,%eax
  8002b3:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b8:	39 c2                	cmp    %eax,%edx
  8002ba:	72 16                	jb     8002d2 <_main+0x29a>
  8002bc:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  8002c2:	89 c2                	mov    %eax,%edx
  8002c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c7:	01 c0                	add    %eax,%eax
  8002c9:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002ce:	39 c2                	cmp    %eax,%edx
  8002d0:	76 14                	jbe    8002e6 <_main+0x2ae>
  8002d2:	83 ec 04             	sub    $0x4,%esp
  8002d5:	68 50 34 80 00       	push   $0x803450
  8002da:	6a 51                	push   $0x51
  8002dc:	68 3c 34 80 00       	push   $0x80343c
  8002e1:	e8 f5 16 00 00       	call   8019db <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8002e6:	e8 f7 29 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  8002eb:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8002ee:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002f3:	74 14                	je     800309 <_main+0x2d1>
  8002f5:	83 ec 04             	sub    $0x4,%esp
  8002f8:	68 b8 34 80 00       	push   $0x8034b8
  8002fd:	6a 52                	push   $0x52
  8002ff:	68 3c 34 80 00       	push   $0x80343c
  800304:	e8 d2 16 00 00       	call   8019db <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800309:	e8 34 29 00 00       	call   802c42 <sys_calculate_free_frames>
  80030e:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800311:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800317:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  80031a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80031d:	01 c0                	add    %eax,%eax
  80031f:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800322:	d1 e8                	shr    %eax
  800324:	48                   	dec    %eax
  800325:	89 45 a0             	mov    %eax,-0x60(%ebp)
		shortArr[0] = minShort;
  800328:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  80032b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80032e:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800331:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800334:	01 c0                	add    %eax,%eax
  800336:	89 c2                	mov    %eax,%edx
  800338:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80033b:	01 c2                	add    %eax,%edx
  80033d:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800341:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800344:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800347:	e8 f6 28 00 00       	call   802c42 <sys_calculate_free_frames>
  80034c:	29 c3                	sub    %eax,%ebx
  80034e:	89 d8                	mov    %ebx,%eax
  800350:	83 f8 02             	cmp    $0x2,%eax
  800353:	74 14                	je     800369 <_main+0x331>
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	68 e8 34 80 00       	push   $0x8034e8
  80035d:	6a 59                	push   $0x59
  80035f:	68 3c 34 80 00       	push   $0x80343c
  800364:	e8 72 16 00 00       	call   8019db <_panic>
		found = 0;
  800369:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800370:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800377:	e9 86 00 00 00       	jmp    800402 <_main+0x3ca>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  80037c:	a1 20 40 80 00       	mov    0x804020,%eax
  800381:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800387:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80038a:	89 d0                	mov    %edx,%eax
  80038c:	01 c0                	add    %eax,%eax
  80038e:	01 d0                	add    %edx,%eax
  800390:	c1 e0 03             	shl    $0x3,%eax
  800393:	01 c8                	add    %ecx,%eax
  800395:	8b 00                	mov    (%eax),%eax
  800397:	89 45 9c             	mov    %eax,-0x64(%ebp)
  80039a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80039d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a2:	89 c2                	mov    %eax,%edx
  8003a4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003a7:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003aa:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b2:	39 c2                	cmp    %eax,%edx
  8003b4:	75 03                	jne    8003b9 <_main+0x381>
				found++;
  8003b6:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003b9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003be:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003c7:	89 d0                	mov    %edx,%eax
  8003c9:	01 c0                	add    %eax,%eax
  8003cb:	01 d0                	add    %edx,%eax
  8003cd:	c1 e0 03             	shl    $0x3,%eax
  8003d0:	01 c8                	add    %ecx,%eax
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003d7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003e4:	01 c0                	add    %eax,%eax
  8003e6:	89 c1                	mov    %eax,%ecx
  8003e8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003eb:	01 c8                	add    %ecx,%eax
  8003ed:	89 45 90             	mov    %eax,-0x70(%ebp)
  8003f0:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003f8:	39 c2                	cmp    %eax,%edx
  8003fa:	75 03                	jne    8003ff <_main+0x3c7>
				found++;
  8003fc:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8003ff:	ff 45 ec             	incl   -0x14(%ebp)
  800402:	a1 20 40 80 00       	mov    0x804020,%eax
  800407:	8b 50 74             	mov    0x74(%eax),%edx
  80040a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80040d:	39 c2                	cmp    %eax,%edx
  80040f:	0f 87 67 ff ff ff    	ja     80037c <_main+0x344>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800415:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800419:	74 14                	je     80042f <_main+0x3f7>
  80041b:	83 ec 04             	sub    $0x4,%esp
  80041e:	68 2c 35 80 00       	push   $0x80352c
  800423:	6a 62                	push   $0x62
  800425:	68 3c 34 80 00       	push   $0x80343c
  80042a:	e8 ac 15 00 00       	call   8019db <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042f:	e8 ae 28 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  800434:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800437:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80043a:	01 c0                	add    %eax,%eax
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	50                   	push   %eax
  800440:	e8 ee 25 00 00       	call   802a33 <malloc>
  800445:	83 c4 10             	add    $0x10,%esp
  800448:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80044e:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  800454:	89 c2                	mov    %eax,%edx
  800456:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800459:	c1 e0 02             	shl    $0x2,%eax
  80045c:	05 00 00 00 80       	add    $0x80000000,%eax
  800461:	39 c2                	cmp    %eax,%edx
  800463:	72 17                	jb     80047c <_main+0x444>
  800465:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80046b:	89 c2                	mov    %eax,%edx
  80046d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800470:	c1 e0 02             	shl    $0x2,%eax
  800473:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800478:	39 c2                	cmp    %eax,%edx
  80047a:	76 14                	jbe    800490 <_main+0x458>
  80047c:	83 ec 04             	sub    $0x4,%esp
  80047f:	68 50 34 80 00       	push   $0x803450
  800484:	6a 67                	push   $0x67
  800486:	68 3c 34 80 00       	push   $0x80343c
  80048b:	e8 4b 15 00 00       	call   8019db <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800490:	e8 4d 28 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  800495:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800498:	83 f8 01             	cmp    $0x1,%eax
  80049b:	74 14                	je     8004b1 <_main+0x479>
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	68 b8 34 80 00       	push   $0x8034b8
  8004a5:	6a 68                	push   $0x68
  8004a7:	68 3c 34 80 00       	push   $0x80343c
  8004ac:	e8 2a 15 00 00       	call   8019db <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004b1:	e8 8c 27 00 00       	call   802c42 <sys_calculate_free_frames>
  8004b6:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004b9:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  8004bf:	89 45 8c             	mov    %eax,-0x74(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c5:	01 c0                	add    %eax,%eax
  8004c7:	c1 e8 02             	shr    $0x2,%eax
  8004ca:	48                   	dec    %eax
  8004cb:	89 45 88             	mov    %eax,-0x78(%ebp)
		intArr[0] = minInt;
  8004ce:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004d4:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004d6:	8b 45 88             	mov    -0x78(%ebp),%eax
  8004d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004e0:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004e3:	01 c2                	add    %eax,%edx
  8004e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004e8:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004ea:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004ed:	e8 50 27 00 00       	call   802c42 <sys_calculate_free_frames>
  8004f2:	29 c3                	sub    %eax,%ebx
  8004f4:	89 d8                	mov    %ebx,%eax
  8004f6:	83 f8 02             	cmp    $0x2,%eax
  8004f9:	74 14                	je     80050f <_main+0x4d7>
  8004fb:	83 ec 04             	sub    $0x4,%esp
  8004fe:	68 e8 34 80 00       	push   $0x8034e8
  800503:	6a 6f                	push   $0x6f
  800505:	68 3c 34 80 00       	push   $0x80343c
  80050a:	e8 cc 14 00 00       	call   8019db <_panic>
		found = 0;
  80050f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800516:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80051d:	e9 95 00 00 00       	jmp    8005b7 <_main+0x57f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800522:	a1 20 40 80 00       	mov    0x804020,%eax
  800527:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80052d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800530:	89 d0                	mov    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	c1 e0 03             	shl    $0x3,%eax
  800539:	01 c8                	add    %ecx,%eax
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800540:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800543:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800548:	89 c2                	mov    %eax,%edx
  80054a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80054d:	89 45 80             	mov    %eax,-0x80(%ebp)
  800550:	8b 45 80             	mov    -0x80(%ebp),%eax
  800553:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800558:	39 c2                	cmp    %eax,%edx
  80055a:	75 03                	jne    80055f <_main+0x527>
				found++;
  80055c:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  80055f:	a1 20 40 80 00       	mov    0x804020,%eax
  800564:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80056a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80056d:	89 d0                	mov    %edx,%eax
  80056f:	01 c0                	add    %eax,%eax
  800571:	01 d0                	add    %edx,%eax
  800573:	c1 e0 03             	shl    $0x3,%eax
  800576:	01 c8                	add    %ecx,%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800580:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800586:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80058b:	89 c2                	mov    %eax,%edx
  80058d:	8b 45 88             	mov    -0x78(%ebp),%eax
  800590:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800597:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80059a:	01 c8                	add    %ecx,%eax
  80059c:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  8005a2:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8005a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ad:	39 c2                	cmp    %eax,%edx
  8005af:	75 03                	jne    8005b4 <_main+0x57c>
				found++;
  8005b1:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005b4:	ff 45 ec             	incl   -0x14(%ebp)
  8005b7:	a1 20 40 80 00       	mov    0x804020,%eax
  8005bc:	8b 50 74             	mov    0x74(%eax),%edx
  8005bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005c2:	39 c2                	cmp    %eax,%edx
  8005c4:	0f 87 58 ff ff ff    	ja     800522 <_main+0x4ea>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005ca:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005ce:	74 14                	je     8005e4 <_main+0x5ac>
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	68 2c 35 80 00       	push   $0x80352c
  8005d8:	6a 78                	push   $0x78
  8005da:	68 3c 34 80 00       	push   $0x80343c
  8005df:	e8 f7 13 00 00       	call   8019db <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8005e4:	e8 59 26 00 00       	call   802c42 <sys_calculate_free_frames>
  8005e9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005ec:	e8 f1 26 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  8005f1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8005f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005f7:	01 c0                	add    %eax,%eax
  8005f9:	83 ec 0c             	sub    $0xc,%esp
  8005fc:	50                   	push   %eax
  8005fd:	e8 31 24 00 00       	call   802a33 <malloc>
  800602:	83 c4 10             	add    $0x10,%esp
  800605:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80060b:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  800611:	89 c2                	mov    %eax,%edx
  800613:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800616:	c1 e0 02             	shl    $0x2,%eax
  800619:	89 c1                	mov    %eax,%ecx
  80061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80061e:	c1 e0 02             	shl    $0x2,%eax
  800621:	01 c8                	add    %ecx,%eax
  800623:	05 00 00 00 80       	add    $0x80000000,%eax
  800628:	39 c2                	cmp    %eax,%edx
  80062a:	72 21                	jb     80064d <_main+0x615>
  80062c:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  800632:	89 c2                	mov    %eax,%edx
  800634:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800637:	c1 e0 02             	shl    $0x2,%eax
  80063a:	89 c1                	mov    %eax,%ecx
  80063c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80063f:	c1 e0 02             	shl    $0x2,%eax
  800642:	01 c8                	add    %ecx,%eax
  800644:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800649:	39 c2                	cmp    %eax,%edx
  80064b:	76 14                	jbe    800661 <_main+0x629>
  80064d:	83 ec 04             	sub    $0x4,%esp
  800650:	68 50 34 80 00       	push   $0x803450
  800655:	6a 7e                	push   $0x7e
  800657:	68 3c 34 80 00       	push   $0x80343c
  80065c:	e8 7a 13 00 00       	call   8019db <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800661:	e8 7c 26 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  800666:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800669:	83 f8 01             	cmp    $0x1,%eax
  80066c:	74 14                	je     800682 <_main+0x64a>
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	68 b8 34 80 00       	push   $0x8034b8
  800676:	6a 7f                	push   $0x7f
  800678:	68 3c 34 80 00       	push   $0x80343c
  80067d:	e8 59 13 00 00       	call   8019db <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800682:	e8 5b 26 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  800687:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80068a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80068d:	89 d0                	mov    %edx,%eax
  80068f:	01 c0                	add    %eax,%eax
  800691:	01 d0                	add    %edx,%eax
  800693:	01 c0                	add    %eax,%eax
  800695:	01 d0                	add    %edx,%eax
  800697:	83 ec 0c             	sub    $0xc,%esp
  80069a:	50                   	push   %eax
  80069b:	e8 93 23 00 00       	call   802a33 <malloc>
  8006a0:	83 c4 10             	add    $0x10,%esp
  8006a3:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8006a9:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8006af:	89 c2                	mov    %eax,%edx
  8006b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b4:	c1 e0 02             	shl    $0x2,%eax
  8006b7:	89 c1                	mov    %eax,%ecx
  8006b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006bc:	c1 e0 03             	shl    $0x3,%eax
  8006bf:	01 c8                	add    %ecx,%eax
  8006c1:	05 00 00 00 80       	add    $0x80000000,%eax
  8006c6:	39 c2                	cmp    %eax,%edx
  8006c8:	72 21                	jb     8006eb <_main+0x6b3>
  8006ca:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8006d0:	89 c2                	mov    %eax,%edx
  8006d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d5:	c1 e0 02             	shl    $0x2,%eax
  8006d8:	89 c1                	mov    %eax,%ecx
  8006da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006dd:	c1 e0 03             	shl    $0x3,%eax
  8006e0:	01 c8                	add    %ecx,%eax
  8006e2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006e7:	39 c2                	cmp    %eax,%edx
  8006e9:	76 17                	jbe    800702 <_main+0x6ca>
  8006eb:	83 ec 04             	sub    $0x4,%esp
  8006ee:	68 50 34 80 00       	push   $0x803450
  8006f3:	68 85 00 00 00       	push   $0x85
  8006f8:	68 3c 34 80 00       	push   $0x80343c
  8006fd:	e8 d9 12 00 00       	call   8019db <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800702:	e8 db 25 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  800707:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80070a:	83 f8 02             	cmp    $0x2,%eax
  80070d:	74 17                	je     800726 <_main+0x6ee>
  80070f:	83 ec 04             	sub    $0x4,%esp
  800712:	68 b8 34 80 00       	push   $0x8034b8
  800717:	68 86 00 00 00       	push   $0x86
  80071c:	68 3c 34 80 00       	push   $0x80343c
  800721:	e8 b5 12 00 00       	call   8019db <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800726:	e8 17 25 00 00       	call   802c42 <sys_calculate_free_frames>
  80072b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  80072e:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  800734:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  80073a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80073d:	89 d0                	mov    %edx,%eax
  80073f:	01 c0                	add    %eax,%eax
  800741:	01 d0                	add    %edx,%eax
  800743:	01 c0                	add    %eax,%eax
  800745:	01 d0                	add    %edx,%eax
  800747:	c1 e8 03             	shr    $0x3,%eax
  80074a:	48                   	dec    %eax
  80074b:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800751:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800757:	8a 55 db             	mov    -0x25(%ebp),%dl
  80075a:	88 10                	mov    %dl,(%eax)
  80075c:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  800762:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800765:	66 89 42 02          	mov    %ax,0x2(%edx)
  800769:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80076f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800772:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800775:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80077b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800782:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800788:	01 c2                	add    %eax,%edx
  80078a:	8a 45 da             	mov    -0x26(%ebp),%al
  80078d:	88 02                	mov    %al,(%edx)
  80078f:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800795:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80079c:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007a2:	01 c2                	add    %eax,%edx
  8007a4:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  8007a8:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007ac:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8007b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007b9:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007bf:	01 c2                	add    %eax,%edx
  8007c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007c4:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007c7:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8007ca:	e8 73 24 00 00       	call   802c42 <sys_calculate_free_frames>
  8007cf:	29 c3                	sub    %eax,%ebx
  8007d1:	89 d8                	mov    %ebx,%eax
  8007d3:	83 f8 02             	cmp    $0x2,%eax
  8007d6:	74 17                	je     8007ef <_main+0x7b7>
  8007d8:	83 ec 04             	sub    $0x4,%esp
  8007db:	68 e8 34 80 00       	push   $0x8034e8
  8007e0:	68 8d 00 00 00       	push   $0x8d
  8007e5:	68 3c 34 80 00       	push   $0x80343c
  8007ea:	e8 ec 11 00 00       	call   8019db <_panic>
		found = 0;
  8007ef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007fd:	e9 aa 00 00 00       	jmp    8008ac <_main+0x874>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  800802:	a1 20 40 80 00       	mov    0x804020,%eax
  800807:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80080d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800810:	89 d0                	mov    %edx,%eax
  800812:	01 c0                	add    %eax,%eax
  800814:	01 d0                	add    %edx,%eax
  800816:	c1 e0 03             	shl    $0x3,%eax
  800819:	01 c8                	add    %ecx,%eax
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800823:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800829:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80082e:	89 c2                	mov    %eax,%edx
  800830:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800836:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  80083c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800842:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800847:	39 c2                	cmp    %eax,%edx
  800849:	75 03                	jne    80084e <_main+0x816>
				found++;
  80084b:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80084e:	a1 20 40 80 00       	mov    0x804020,%eax
  800853:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800859:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80085c:	89 d0                	mov    %edx,%eax
  80085e:	01 c0                	add    %eax,%eax
  800860:	01 d0                	add    %edx,%eax
  800862:	c1 e0 03             	shl    $0x3,%eax
  800865:	01 c8                	add    %ecx,%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80086f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800875:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800882:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800889:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80088f:	01 c8                	add    %ecx,%eax
  800891:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800897:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80089d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a2:	39 c2                	cmp    %eax,%edx
  8008a4:	75 03                	jne    8008a9 <_main+0x871>
				found++;
  8008a6:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8008a9:	ff 45 ec             	incl   -0x14(%ebp)
  8008ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8008b1:	8b 50 74             	mov    0x74(%eax),%edx
  8008b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b7:	39 c2                	cmp    %eax,%edx
  8008b9:	0f 87 43 ff ff ff    	ja     800802 <_main+0x7ca>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008bf:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008c3:	74 17                	je     8008dc <_main+0x8a4>
  8008c5:	83 ec 04             	sub    $0x4,%esp
  8008c8:	68 2c 35 80 00       	push   $0x80352c
  8008cd:	68 96 00 00 00       	push   $0x96
  8008d2:	68 3c 34 80 00       	push   $0x80343c
  8008d7:	e8 ff 10 00 00       	call   8019db <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008dc:	e8 61 23 00 00       	call   802c42 <sys_calculate_free_frames>
  8008e1:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008e4:	e8 f9 23 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  8008e9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ef:	89 c2                	mov    %eax,%edx
  8008f1:	01 d2                	add    %edx,%edx
  8008f3:	01 d0                	add    %edx,%eax
  8008f5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008f8:	83 ec 0c             	sub    $0xc,%esp
  8008fb:	50                   	push   %eax
  8008fc:	e8 32 21 00 00       	call   802a33 <malloc>
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80090a:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  800910:	89 c2                	mov    %eax,%edx
  800912:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800915:	c1 e0 02             	shl    $0x2,%eax
  800918:	89 c1                	mov    %eax,%ecx
  80091a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80091d:	c1 e0 04             	shl    $0x4,%eax
  800920:	01 c8                	add    %ecx,%eax
  800922:	05 00 00 00 80       	add    $0x80000000,%eax
  800927:	39 c2                	cmp    %eax,%edx
  800929:	72 21                	jb     80094c <_main+0x914>
  80092b:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  800931:	89 c2                	mov    %eax,%edx
  800933:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800936:	c1 e0 02             	shl    $0x2,%eax
  800939:	89 c1                	mov    %eax,%ecx
  80093b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80093e:	c1 e0 04             	shl    $0x4,%eax
  800941:	01 c8                	add    %ecx,%eax
  800943:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800948:	39 c2                	cmp    %eax,%edx
  80094a:	76 17                	jbe    800963 <_main+0x92b>
  80094c:	83 ec 04             	sub    $0x4,%esp
  80094f:	68 50 34 80 00       	push   $0x803450
  800954:	68 9c 00 00 00       	push   $0x9c
  800959:	68 3c 34 80 00       	push   $0x80343c
  80095e:	e8 78 10 00 00       	call   8019db <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800963:	e8 7a 23 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  800968:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80096b:	89 c2                	mov    %eax,%edx
  80096d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800970:	89 c1                	mov    %eax,%ecx
  800972:	01 c9                	add    %ecx,%ecx
  800974:	01 c8                	add    %ecx,%eax
  800976:	85 c0                	test   %eax,%eax
  800978:	79 05                	jns    80097f <_main+0x947>
  80097a:	05 ff 0f 00 00       	add    $0xfff,%eax
  80097f:	c1 f8 0c             	sar    $0xc,%eax
  800982:	39 c2                	cmp    %eax,%edx
  800984:	74 17                	je     80099d <_main+0x965>
  800986:	83 ec 04             	sub    $0x4,%esp
  800989:	68 b8 34 80 00       	push   $0x8034b8
  80098e:	68 9d 00 00 00       	push   $0x9d
  800993:	68 3c 34 80 00       	push   $0x80343c
  800998:	e8 3e 10 00 00       	call   8019db <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80099d:	e8 40 23 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  8009a2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  8009a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a8:	89 d0                	mov    %edx,%eax
  8009aa:	01 c0                	add    %eax,%eax
  8009ac:	01 d0                	add    %edx,%eax
  8009ae:	01 c0                	add    %eax,%eax
  8009b0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8009b3:	83 ec 0c             	sub    $0xc,%esp
  8009b6:	50                   	push   %eax
  8009b7:	e8 77 20 00 00       	call   802a33 <malloc>
  8009bc:	83 c4 10             	add    $0x10,%esp
  8009bf:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8009c5:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8009cb:	89 c1                	mov    %eax,%ecx
  8009cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d0:	89 d0                	mov    %edx,%eax
  8009d2:	01 c0                	add    %eax,%eax
  8009d4:	01 d0                	add    %edx,%eax
  8009d6:	01 c0                	add    %eax,%eax
  8009d8:	01 d0                	add    %edx,%eax
  8009da:	89 c2                	mov    %eax,%edx
  8009dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009df:	c1 e0 04             	shl    $0x4,%eax
  8009e2:	01 d0                	add    %edx,%eax
  8009e4:	05 00 00 00 80       	add    $0x80000000,%eax
  8009e9:	39 c1                	cmp    %eax,%ecx
  8009eb:	72 28                	jb     800a15 <_main+0x9dd>
  8009ed:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8009f3:	89 c1                	mov    %eax,%ecx
  8009f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f8:	89 d0                	mov    %edx,%eax
  8009fa:	01 c0                	add    %eax,%eax
  8009fc:	01 d0                	add    %edx,%eax
  8009fe:	01 c0                	add    %eax,%eax
  800a00:	01 d0                	add    %edx,%eax
  800a02:	89 c2                	mov    %eax,%edx
  800a04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a07:	c1 e0 04             	shl    $0x4,%eax
  800a0a:	01 d0                	add    %edx,%eax
  800a0c:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800a11:	39 c1                	cmp    %eax,%ecx
  800a13:	76 17                	jbe    800a2c <_main+0x9f4>
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	68 50 34 80 00       	push   $0x803450
  800a1d:	68 a3 00 00 00       	push   $0xa3
  800a22:	68 3c 34 80 00       	push   $0x80343c
  800a27:	e8 af 0f 00 00       	call   8019db <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800a2c:	e8 b1 22 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  800a31:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800a34:	89 c1                	mov    %eax,%ecx
  800a36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a39:	89 d0                	mov    %edx,%eax
  800a3b:	01 c0                	add    %eax,%eax
  800a3d:	01 d0                	add    %edx,%eax
  800a3f:	01 c0                	add    %eax,%eax
  800a41:	85 c0                	test   %eax,%eax
  800a43:	79 05                	jns    800a4a <_main+0xa12>
  800a45:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a4a:	c1 f8 0c             	sar    $0xc,%eax
  800a4d:	39 c1                	cmp    %eax,%ecx
  800a4f:	74 17                	je     800a68 <_main+0xa30>
  800a51:	83 ec 04             	sub    $0x4,%esp
  800a54:	68 b8 34 80 00       	push   $0x8034b8
  800a59:	68 a4 00 00 00       	push   $0xa4
  800a5e:	68 3c 34 80 00       	push   $0x80343c
  800a63:	e8 73 0f 00 00       	call   8019db <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a68:	e8 d5 21 00 00       	call   802c42 <sys_calculate_free_frames>
  800a6d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a70:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a73:	89 d0                	mov    %edx,%eax
  800a75:	01 c0                	add    %eax,%eax
  800a77:	01 d0                	add    %edx,%eax
  800a79:	01 c0                	add    %eax,%eax
  800a7b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800a7e:	48                   	dec    %eax
  800a7f:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a85:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800a8b:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		byteArr2[0] = minByte ;
  800a91:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a97:	8a 55 db             	mov    -0x25(%ebp),%dl
  800a9a:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a9c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800aa2:	89 c2                	mov    %eax,%edx
  800aa4:	c1 ea 1f             	shr    $0x1f,%edx
  800aa7:	01 d0                	add    %edx,%eax
  800aa9:	d1 f8                	sar    %eax
  800aab:	89 c2                	mov    %eax,%edx
  800aad:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800ab3:	01 c2                	add    %eax,%edx
  800ab5:	8a 45 da             	mov    -0x26(%ebp),%al
  800ab8:	88 c1                	mov    %al,%cl
  800aba:	c0 e9 07             	shr    $0x7,%cl
  800abd:	01 c8                	add    %ecx,%eax
  800abf:	d0 f8                	sar    %al
  800ac1:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800ac3:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800ac9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800acf:	01 c2                	add    %eax,%edx
  800ad1:	8a 45 da             	mov    -0x26(%ebp),%al
  800ad4:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800ad6:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800ad9:	e8 64 21 00 00       	call   802c42 <sys_calculate_free_frames>
  800ade:	29 c3                	sub    %eax,%ebx
  800ae0:	89 d8                	mov    %ebx,%eax
  800ae2:	83 f8 05             	cmp    $0x5,%eax
  800ae5:	74 17                	je     800afe <_main+0xac6>
  800ae7:	83 ec 04             	sub    $0x4,%esp
  800aea:	68 e8 34 80 00       	push   $0x8034e8
  800aef:	68 ac 00 00 00       	push   $0xac
  800af4:	68 3c 34 80 00       	push   $0x80343c
  800af9:	e8 dd 0e 00 00       	call   8019db <_panic>
		found = 0;
  800afe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800b05:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800b0c:	e9 02 01 00 00       	jmp    800c13 <_main+0xbdb>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800b11:	a1 20 40 80 00       	mov    0x804020,%eax
  800b16:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b1f:	89 d0                	mov    %edx,%eax
  800b21:	01 c0                	add    %eax,%eax
  800b23:	01 d0                	add    %edx,%eax
  800b25:	c1 e0 03             	shl    $0x3,%eax
  800b28:	01 c8                	add    %ecx,%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b32:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b3d:	89 c2                	mov    %eax,%edx
  800b3f:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b45:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b4b:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b51:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b56:	39 c2                	cmp    %eax,%edx
  800b58:	75 03                	jne    800b5d <_main+0xb25>
				found++;
  800b5a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b5d:	a1 20 40 80 00       	mov    0x804020,%eax
  800b62:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b68:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b6b:	89 d0                	mov    %edx,%eax
  800b6d:	01 c0                	add    %eax,%eax
  800b6f:	01 d0                	add    %edx,%eax
  800b71:	c1 e0 03             	shl    $0x3,%eax
  800b74:	01 c8                	add    %ecx,%eax
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b7e:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b84:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b89:	89 c2                	mov    %eax,%edx
  800b8b:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b91:	89 c1                	mov    %eax,%ecx
  800b93:	c1 e9 1f             	shr    $0x1f,%ecx
  800b96:	01 c8                	add    %ecx,%eax
  800b98:	d1 f8                	sar    %eax
  800b9a:	89 c1                	mov    %eax,%ecx
  800b9c:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800ba2:	01 c8                	add    %ecx,%eax
  800ba4:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800baa:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800bb0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bb5:	39 c2                	cmp    %eax,%edx
  800bb7:	75 03                	jne    800bbc <_main+0xb84>
				found++;
  800bb9:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800bbc:	a1 20 40 80 00       	mov    0x804020,%eax
  800bc1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bc7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bca:	89 d0                	mov    %edx,%eax
  800bcc:	01 c0                	add    %eax,%eax
  800bce:	01 d0                	add    %edx,%eax
  800bd0:	c1 e0 03             	shl    $0x3,%eax
  800bd3:	01 c8                	add    %ecx,%eax
  800bd5:	8b 00                	mov    (%eax),%eax
  800bd7:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800bdd:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800be3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800be8:	89 c1                	mov    %eax,%ecx
  800bea:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800bf0:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800bf6:	01 d0                	add    %edx,%eax
  800bf8:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800bfe:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800c04:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c09:	39 c1                	cmp    %eax,%ecx
  800c0b:	75 03                	jne    800c10 <_main+0xbd8>
				found++;
  800c0d:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800c10:	ff 45 ec             	incl   -0x14(%ebp)
  800c13:	a1 20 40 80 00       	mov    0x804020,%eax
  800c18:	8b 50 74             	mov    0x74(%eax),%edx
  800c1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c1e:	39 c2                	cmp    %eax,%edx
  800c20:	0f 87 eb fe ff ff    	ja     800b11 <_main+0xad9>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800c26:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800c2a:	74 17                	je     800c43 <_main+0xc0b>
  800c2c:	83 ec 04             	sub    $0x4,%esp
  800c2f:	68 2c 35 80 00       	push   $0x80352c
  800c34:	68 b7 00 00 00       	push   $0xb7
  800c39:	68 3c 34 80 00       	push   $0x80343c
  800c3e:	e8 98 0d 00 00       	call   8019db <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c43:	e8 9a 20 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  800c48:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c4b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c4e:	89 d0                	mov    %edx,%eax
  800c50:	01 c0                	add    %eax,%eax
  800c52:	01 d0                	add    %edx,%eax
  800c54:	01 c0                	add    %eax,%eax
  800c56:	01 d0                	add    %edx,%eax
  800c58:	01 c0                	add    %eax,%eax
  800c5a:	83 ec 0c             	sub    $0xc,%esp
  800c5d:	50                   	push   %eax
  800c5e:	e8 d0 1d 00 00       	call   802a33 <malloc>
  800c63:	83 c4 10             	add    $0x10,%esp
  800c66:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c6c:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c72:	89 c1                	mov    %eax,%ecx
  800c74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c77:	89 d0                	mov    %edx,%eax
  800c79:	01 c0                	add    %eax,%eax
  800c7b:	01 d0                	add    %edx,%eax
  800c7d:	c1 e0 02             	shl    $0x2,%eax
  800c80:	01 d0                	add    %edx,%eax
  800c82:	89 c2                	mov    %eax,%edx
  800c84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c87:	c1 e0 04             	shl    $0x4,%eax
  800c8a:	01 d0                	add    %edx,%eax
  800c8c:	05 00 00 00 80       	add    $0x80000000,%eax
  800c91:	39 c1                	cmp    %eax,%ecx
  800c93:	72 29                	jb     800cbe <_main+0xc86>
  800c95:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c9b:	89 c1                	mov    %eax,%ecx
  800c9d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ca0:	89 d0                	mov    %edx,%eax
  800ca2:	01 c0                	add    %eax,%eax
  800ca4:	01 d0                	add    %edx,%eax
  800ca6:	c1 e0 02             	shl    $0x2,%eax
  800ca9:	01 d0                	add    %edx,%eax
  800cab:	89 c2                	mov    %eax,%edx
  800cad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800cb0:	c1 e0 04             	shl    $0x4,%eax
  800cb3:	01 d0                	add    %edx,%eax
  800cb5:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800cba:	39 c1                	cmp    %eax,%ecx
  800cbc:	76 17                	jbe    800cd5 <_main+0xc9d>
  800cbe:	83 ec 04             	sub    $0x4,%esp
  800cc1:	68 50 34 80 00       	push   $0x803450
  800cc6:	68 bc 00 00 00       	push   $0xbc
  800ccb:	68 3c 34 80 00       	push   $0x80343c
  800cd0:	e8 06 0d 00 00       	call   8019db <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  800cd5:	e8 08 20 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  800cda:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800cdd:	83 f8 04             	cmp    $0x4,%eax
  800ce0:	74 17                	je     800cf9 <_main+0xcc1>
  800ce2:	83 ec 04             	sub    $0x4,%esp
  800ce5:	68 b8 34 80 00       	push   $0x8034b8
  800cea:	68 bd 00 00 00       	push   $0xbd
  800cef:	68 3c 34 80 00       	push   $0x80343c
  800cf4:	e8 e2 0c 00 00       	call   8019db <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cf9:	e8 44 1f 00 00       	call   802c42 <sys_calculate_free_frames>
  800cfe:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800d01:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800d07:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800d0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800d10:	89 d0                	mov    %edx,%eax
  800d12:	01 c0                	add    %eax,%eax
  800d14:	01 d0                	add    %edx,%eax
  800d16:	01 c0                	add    %eax,%eax
  800d18:	01 d0                	add    %edx,%eax
  800d1a:	01 c0                	add    %eax,%eax
  800d1c:	d1 e8                	shr    %eax
  800d1e:	48                   	dec    %eax
  800d1f:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
		shortArr2[0] = minShort;
  800d25:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800d2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d2e:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800d31:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d37:	01 c0                	add    %eax,%eax
  800d39:	89 c2                	mov    %eax,%edx
  800d3b:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d41:	01 c2                	add    %eax,%edx
  800d43:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800d47:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d4a:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800d4d:	e8 f0 1e 00 00       	call   802c42 <sys_calculate_free_frames>
  800d52:	29 c3                	sub    %eax,%ebx
  800d54:	89 d8                	mov    %ebx,%eax
  800d56:	83 f8 02             	cmp    $0x2,%eax
  800d59:	74 17                	je     800d72 <_main+0xd3a>
  800d5b:	83 ec 04             	sub    $0x4,%esp
  800d5e:	68 e8 34 80 00       	push   $0x8034e8
  800d63:	68 c4 00 00 00       	push   $0xc4
  800d68:	68 3c 34 80 00       	push   $0x80343c
  800d6d:	e8 69 0c 00 00       	call   8019db <_panic>
		found = 0;
  800d72:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d79:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d80:	e9 a7 00 00 00       	jmp    800e2c <_main+0xdf4>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d85:	a1 20 40 80 00       	mov    0x804020,%eax
  800d8a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d90:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d93:	89 d0                	mov    %edx,%eax
  800d95:	01 c0                	add    %eax,%eax
  800d97:	01 d0                	add    %edx,%eax
  800d99:	c1 e0 03             	shl    $0x3,%eax
  800d9c:	01 c8                	add    %ecx,%eax
  800d9e:	8b 00                	mov    (%eax),%eax
  800da0:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800da6:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800dac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db1:	89 c2                	mov    %eax,%edx
  800db3:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800db9:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800dbf:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800dc5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dca:	39 c2                	cmp    %eax,%edx
  800dcc:	75 03                	jne    800dd1 <_main+0xd99>
				found++;
  800dce:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800dd1:	a1 20 40 80 00       	mov    0x804020,%eax
  800dd6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ddc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ddf:	89 d0                	mov    %edx,%eax
  800de1:	01 c0                	add    %eax,%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	c1 e0 03             	shl    $0x3,%eax
  800de8:	01 c8                	add    %ecx,%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800df2:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800df8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dfd:	89 c2                	mov    %eax,%edx
  800dff:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800e05:	01 c0                	add    %eax,%eax
  800e07:	89 c1                	mov    %eax,%ecx
  800e09:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800e0f:	01 c8                	add    %ecx,%eax
  800e11:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  800e17:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800e1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e22:	39 c2                	cmp    %eax,%edx
  800e24:	75 03                	jne    800e29 <_main+0xdf1>
				found++;
  800e26:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800e29:	ff 45 ec             	incl   -0x14(%ebp)
  800e2c:	a1 20 40 80 00       	mov    0x804020,%eax
  800e31:	8b 50 74             	mov    0x74(%eax),%edx
  800e34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e37:	39 c2                	cmp    %eax,%edx
  800e39:	0f 87 46 ff ff ff    	ja     800d85 <_main+0xd4d>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800e3f:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800e43:	74 17                	je     800e5c <_main+0xe24>
  800e45:	83 ec 04             	sub    $0x4,%esp
  800e48:	68 2c 35 80 00       	push   $0x80352c
  800e4d:	68 cd 00 00 00       	push   $0xcd
  800e52:	68 3c 34 80 00       	push   $0x80343c
  800e57:	e8 7f 0b 00 00       	call   8019db <_panic>
	}

	{
		//Free 1st 2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800e5c:	e8 e1 1d 00 00       	call   802c42 <sys_calculate_free_frames>
  800e61:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e67:	e8 76 1e 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  800e6c:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[0]);
  800e72:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800e78:	83 ec 0c             	sub    $0xc,%esp
  800e7b:	50                   	push   %eax
  800e7c:	e8 f3 1b 00 00       	call   802a74 <free>
  800e81:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e84:	e8 59 1e 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  800e89:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  800e8f:	29 c2                	sub    %eax,%edx
  800e91:	89 d0                	mov    %edx,%eax
  800e93:	3d 00 02 00 00       	cmp    $0x200,%eax
  800e98:	74 17                	je     800eb1 <_main+0xe79>
  800e9a:	83 ec 04             	sub    $0x4,%esp
  800e9d:	68 4c 35 80 00       	push   $0x80354c
  800ea2:	68 d5 00 00 00       	push   $0xd5
  800ea7:	68 3c 34 80 00       	push   $0x80343c
  800eac:	e8 2a 0b 00 00       	call   8019db <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800eb1:	e8 8c 1d 00 00       	call   802c42 <sys_calculate_free_frames>
  800eb6:	89 c2                	mov    %eax,%edx
  800eb8:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800ebe:	29 c2                	sub    %eax,%edx
  800ec0:	89 d0                	mov    %edx,%eax
  800ec2:	83 f8 02             	cmp    $0x2,%eax
  800ec5:	74 17                	je     800ede <_main+0xea6>
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	68 88 35 80 00       	push   $0x803588
  800ecf:	68 d6 00 00 00       	push   $0xd6
  800ed4:	68 3c 34 80 00       	push   $0x80343c
  800ed9:	e8 fd 0a 00 00       	call   8019db <_panic>
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ede:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ee5:	e9 c2 00 00 00       	jmp    800fac <_main+0xf74>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  800eea:	a1 20 40 80 00       	mov    0x804020,%eax
  800eef:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ef5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ef8:	89 d0                	mov    %edx,%eax
  800efa:	01 c0                	add    %eax,%eax
  800efc:	01 d0                	add    %edx,%eax
  800efe:	c1 e0 03             	shl    $0x3,%eax
  800f01:	01 c8                	add    %ecx,%eax
  800f03:	8b 00                	mov    (%eax),%eax
  800f05:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  800f0b:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800f11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f16:	89 c2                	mov    %eax,%edx
  800f18:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800f1b:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  800f21:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800f27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f2c:	39 c2                	cmp    %eax,%edx
  800f2e:	75 17                	jne    800f47 <_main+0xf0f>
				panic("free: page is not removed from WS");
  800f30:	83 ec 04             	sub    $0x4,%esp
  800f33:	68 d4 35 80 00       	push   $0x8035d4
  800f38:	68 db 00 00 00       	push   $0xdb
  800f3d:	68 3c 34 80 00       	push   $0x80343c
  800f42:	e8 94 0a 00 00       	call   8019db <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  800f47:	a1 20 40 80 00       	mov    0x804020,%eax
  800f4c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800f52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f55:	89 d0                	mov    %edx,%eax
  800f57:	01 c0                	add    %eax,%eax
  800f59:	01 d0                	add    %edx,%eax
  800f5b:	c1 e0 03             	shl    $0x3,%eax
  800f5e:	01 c8                	add    %ecx,%eax
  800f60:	8b 00                	mov    (%eax),%eax
  800f62:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  800f68:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800f6e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f73:	89 c1                	mov    %eax,%ecx
  800f75:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800f78:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800f7b:	01 d0                	add    %edx,%eax
  800f7d:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
  800f83:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800f89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f8e:	39 c1                	cmp    %eax,%ecx
  800f90:	75 17                	jne    800fa9 <_main+0xf71>
				panic("free: page is not removed from WS");
  800f92:	83 ec 04             	sub    $0x4,%esp
  800f95:	68 d4 35 80 00       	push   $0x8035d4
  800f9a:	68 dd 00 00 00       	push   $0xdd
  800f9f:	68 3c 34 80 00       	push   $0x80343c
  800fa4:	e8 32 0a 00 00       	call   8019db <_panic>
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[0]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800fa9:	ff 45 e4             	incl   -0x1c(%ebp)
  800fac:	a1 20 40 80 00       	mov    0x804020,%eax
  800fb1:	8b 50 74             	mov    0x74(%eax),%edx
  800fb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fb7:	39 c2                	cmp    %eax,%edx
  800fb9:	0f 87 2b ff ff ff    	ja     800eea <_main+0xeb2>
				panic("free: page is not removed from WS");
		}


		//Free 2nd 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800fbf:	e8 7e 1c 00 00       	call   802c42 <sys_calculate_free_frames>
  800fc4:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800fca:	e8 13 1d 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  800fcf:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[1]);
  800fd5:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800fdb:	83 ec 0c             	sub    $0xc,%esp
  800fde:	50                   	push   %eax
  800fdf:	e8 90 1a 00 00       	call   802a74 <free>
  800fe4:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  800fe7:	e8 f6 1c 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  800fec:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  800ff2:	29 c2                	sub    %eax,%edx
  800ff4:	89 d0                	mov    %edx,%eax
  800ff6:	3d 00 02 00 00       	cmp    $0x200,%eax
  800ffb:	74 17                	je     801014 <_main+0xfdc>
  800ffd:	83 ec 04             	sub    $0x4,%esp
  801000:	68 4c 35 80 00       	push   $0x80354c
  801005:	68 e5 00 00 00       	push   $0xe5
  80100a:	68 3c 34 80 00       	push   $0x80343c
  80100f:	e8 c7 09 00 00       	call   8019db <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801014:	e8 29 1c 00 00       	call   802c42 <sys_calculate_free_frames>
  801019:	89 c2                	mov    %eax,%edx
  80101b:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801021:	29 c2                	sub    %eax,%edx
  801023:	89 d0                	mov    %edx,%eax
  801025:	83 f8 03             	cmp    $0x3,%eax
  801028:	74 17                	je     801041 <_main+0x1009>
  80102a:	83 ec 04             	sub    $0x4,%esp
  80102d:	68 88 35 80 00       	push   $0x803588
  801032:	68 e6 00 00 00       	push   $0xe6
  801037:	68 3c 34 80 00       	push   $0x80343c
  80103c:	e8 9a 09 00 00       	call   8019db <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801041:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801048:	e9 c6 00 00 00       	jmp    801113 <_main+0x10db>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  80104d:	a1 20 40 80 00       	mov    0x804020,%eax
  801052:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801058:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80105b:	89 d0                	mov    %edx,%eax
  80105d:	01 c0                	add    %eax,%eax
  80105f:	01 d0                	add    %edx,%eax
  801061:	c1 e0 03             	shl    $0x3,%eax
  801064:	01 c8                	add    %ecx,%eax
  801066:	8b 00                	mov    (%eax),%eax
  801068:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
  80106e:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801074:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801079:	89 c2                	mov    %eax,%edx
  80107b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80107e:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  801084:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80108a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80108f:	39 c2                	cmp    %eax,%edx
  801091:	75 17                	jne    8010aa <_main+0x1072>
				panic("free: page is not removed from WS");
  801093:	83 ec 04             	sub    $0x4,%esp
  801096:	68 d4 35 80 00       	push   $0x8035d4
  80109b:	68 ea 00 00 00       	push   $0xea
  8010a0:	68 3c 34 80 00       	push   $0x80343c
  8010a5:	e8 31 09 00 00       	call   8019db <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8010aa:	a1 20 40 80 00       	mov    0x804020,%eax
  8010af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8010b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010b8:	89 d0                	mov    %edx,%eax
  8010ba:	01 c0                	add    %eax,%eax
  8010bc:	01 d0                	add    %edx,%eax
  8010be:	c1 e0 03             	shl    $0x3,%eax
  8010c1:	01 c8                	add    %ecx,%eax
  8010c3:	8b 00                	mov    (%eax),%eax
  8010c5:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  8010cb:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  8010d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010d6:	89 c2                	mov    %eax,%edx
  8010d8:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8010db:	01 c0                	add    %eax,%eax
  8010dd:	89 c1                	mov    %eax,%ecx
  8010df:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8010e2:	01 c8                	add    %ecx,%eax
  8010e4:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  8010ea:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  8010f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010f5:	39 c2                	cmp    %eax,%edx
  8010f7:	75 17                	jne    801110 <_main+0x10d8>
				panic("free: page is not removed from WS");
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	68 d4 35 80 00       	push   $0x8035d4
  801101:	68 ec 00 00 00       	push   $0xec
  801106:	68 3c 34 80 00       	push   $0x80343c
  80110b:	e8 cb 08 00 00       	call   8019db <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[1]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801110:	ff 45 e4             	incl   -0x1c(%ebp)
  801113:	a1 20 40 80 00       	mov    0x804020,%eax
  801118:	8b 50 74             	mov    0x74(%eax),%edx
  80111b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80111e:	39 c2                	cmp    %eax,%edx
  801120:	0f 87 27 ff ff ff    	ja     80104d <_main+0x1015>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 6 MB
		freeFrames = sys_calculate_free_frames() ;
  801126:	e8 17 1b 00 00       	call   802c42 <sys_calculate_free_frames>
  80112b:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801131:	e8 ac 1b 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  801136:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[6]);
  80113c:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	50                   	push   %eax
  801146:	e8 29 19 00 00       	call   802a74 <free>
  80114b:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 6*Mega/4096) panic("Wrong free: Extra or less pages are removed from PageFile");
  80114e:	e8 8f 1b 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  801153:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  801159:	89 d1                	mov    %edx,%ecx
  80115b:	29 c1                	sub    %eax,%ecx
  80115d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801160:	89 d0                	mov    %edx,%eax
  801162:	01 c0                	add    %eax,%eax
  801164:	01 d0                	add    %edx,%eax
  801166:	01 c0                	add    %eax,%eax
  801168:	85 c0                	test   %eax,%eax
  80116a:	79 05                	jns    801171 <_main+0x1139>
  80116c:	05 ff 0f 00 00       	add    $0xfff,%eax
  801171:	c1 f8 0c             	sar    $0xc,%eax
  801174:	39 c1                	cmp    %eax,%ecx
  801176:	74 17                	je     80118f <_main+0x1157>
  801178:	83 ec 04             	sub    $0x4,%esp
  80117b:	68 4c 35 80 00       	push   $0x80354c
  801180:	68 f3 00 00 00       	push   $0xf3
  801185:	68 3c 34 80 00       	push   $0x80343c
  80118a:	e8 4c 08 00 00       	call   8019db <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80118f:	e8 ae 1a 00 00       	call   802c42 <sys_calculate_free_frames>
  801194:	89 c2                	mov    %eax,%edx
  801196:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80119c:	29 c2                	sub    %eax,%edx
  80119e:	89 d0                	mov    %edx,%eax
  8011a0:	83 f8 04             	cmp    $0x4,%eax
  8011a3:	74 17                	je     8011bc <_main+0x1184>
  8011a5:	83 ec 04             	sub    $0x4,%esp
  8011a8:	68 88 35 80 00       	push   $0x803588
  8011ad:	68 f4 00 00 00       	push   $0xf4
  8011b2:	68 3c 34 80 00       	push   $0x80343c
  8011b7:	e8 1f 08 00 00       	call   8019db <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8011bc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8011c3:	e9 3e 01 00 00       	jmp    801306 <_main+0x12ce>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  8011c8:	a1 20 40 80 00       	mov    0x804020,%eax
  8011cd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8011d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011d6:	89 d0                	mov    %edx,%eax
  8011d8:	01 c0                	add    %eax,%eax
  8011da:	01 d0                	add    %edx,%eax
  8011dc:	c1 e0 03             	shl    $0x3,%eax
  8011df:	01 c8                	add    %ecx,%eax
  8011e1:	8b 00                	mov    (%eax),%eax
  8011e3:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  8011e9:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  8011ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011f4:	89 c2                	mov    %eax,%edx
  8011f6:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8011fc:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
  801202:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  801208:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80120d:	39 c2                	cmp    %eax,%edx
  80120f:	75 17                	jne    801228 <_main+0x11f0>
				panic("free: page is not removed from WS");
  801211:	83 ec 04             	sub    $0x4,%esp
  801214:	68 d4 35 80 00       	push   $0x8035d4
  801219:	68 f8 00 00 00       	push   $0xf8
  80121e:	68 3c 34 80 00       	push   $0x80343c
  801223:	e8 b3 07 00 00       	call   8019db <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  801228:	a1 20 40 80 00       	mov    0x804020,%eax
  80122d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801233:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801236:	89 d0                	mov    %edx,%eax
  801238:	01 c0                	add    %eax,%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	c1 e0 03             	shl    $0x3,%eax
  80123f:	01 c8                	add    %ecx,%eax
  801241:	8b 00                	mov    (%eax),%eax
  801243:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  801249:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80124f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801254:	89 c2                	mov    %eax,%edx
  801256:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80125c:	89 c1                	mov    %eax,%ecx
  80125e:	c1 e9 1f             	shr    $0x1f,%ecx
  801261:	01 c8                	add    %ecx,%eax
  801263:	d1 f8                	sar    %eax
  801265:	89 c1                	mov    %eax,%ecx
  801267:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80126d:	01 c8                	add    %ecx,%eax
  80126f:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  801275:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80127b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801280:	39 c2                	cmp    %eax,%edx
  801282:	75 17                	jne    80129b <_main+0x1263>
				panic("free: page is not removed from WS");
  801284:	83 ec 04             	sub    $0x4,%esp
  801287:	68 d4 35 80 00       	push   $0x8035d4
  80128c:	68 fa 00 00 00       	push   $0xfa
  801291:	68 3c 34 80 00       	push   $0x80343c
  801296:	e8 40 07 00 00       	call   8019db <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  80129b:	a1 20 40 80 00       	mov    0x804020,%eax
  8012a0:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8012a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012a9:	89 d0                	mov    %edx,%eax
  8012ab:	01 c0                	add    %eax,%eax
  8012ad:	01 d0                	add    %edx,%eax
  8012af:	c1 e0 03             	shl    $0x3,%eax
  8012b2:	01 c8                	add    %ecx,%eax
  8012b4:	8b 00                	mov    (%eax),%eax
  8012b6:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  8012bc:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8012c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012c7:	89 c1                	mov    %eax,%ecx
  8012c9:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  8012cf:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8012d5:	01 d0                	add    %edx,%eax
  8012d7:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
  8012dd:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  8012e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012e8:	39 c1                	cmp    %eax,%ecx
  8012ea:	75 17                	jne    801303 <_main+0x12cb>
				panic("free: page is not removed from WS");
  8012ec:	83 ec 04             	sub    $0x4,%esp
  8012ef:	68 d4 35 80 00       	push   $0x8035d4
  8012f4:	68 fc 00 00 00       	push   $0xfc
  8012f9:	68 3c 34 80 00       	push   $0x80343c
  8012fe:	e8 d8 06 00 00       	call   8019db <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[6]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 6*Mega/4096) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801303:	ff 45 e4             	incl   -0x1c(%ebp)
  801306:	a1 20 40 80 00       	mov    0x804020,%eax
  80130b:	8b 50 74             	mov    0x74(%eax),%edx
  80130e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801311:	39 c2                	cmp    %eax,%edx
  801313:	0f 87 af fe ff ff    	ja     8011c8 <_main+0x1190>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 7 KB
		freeFrames = sys_calculate_free_frames() ;
  801319:	e8 24 19 00 00       	call   802c42 <sys_calculate_free_frames>
  80131e:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801324:	e8 b9 19 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  801329:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[4]);
  80132f:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  801335:	83 ec 0c             	sub    $0xc,%esp
  801338:	50                   	push   %eax
  801339:	e8 36 17 00 00       	call   802a74 <free>
  80133e:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2) panic("Wrong free: Extra or less pages are removed from PageFile");
  801341:	e8 9c 19 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  801346:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  80134c:	29 c2                	sub    %eax,%edx
  80134e:	89 d0                	mov    %edx,%eax
  801350:	83 f8 02             	cmp    $0x2,%eax
  801353:	74 17                	je     80136c <_main+0x1334>
  801355:	83 ec 04             	sub    $0x4,%esp
  801358:	68 4c 35 80 00       	push   $0x80354c
  80135d:	68 03 01 00 00       	push   $0x103
  801362:	68 3c 34 80 00       	push   $0x80343c
  801367:	e8 6f 06 00 00       	call   8019db <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80136c:	e8 d1 18 00 00       	call   802c42 <sys_calculate_free_frames>
  801371:	89 c2                	mov    %eax,%edx
  801373:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801379:	29 c2                	sub    %eax,%edx
  80137b:	89 d0                	mov    %edx,%eax
  80137d:	83 f8 02             	cmp    $0x2,%eax
  801380:	74 17                	je     801399 <_main+0x1361>
  801382:	83 ec 04             	sub    $0x4,%esp
  801385:	68 88 35 80 00       	push   $0x803588
  80138a:	68 04 01 00 00       	push   $0x104
  80138f:	68 3c 34 80 00       	push   $0x80343c
  801394:	e8 42 06 00 00       	call   8019db <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801399:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8013a0:	e9 d2 00 00 00       	jmp    801477 <_main+0x143f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8013a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8013aa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8013b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013b3:	89 d0                	mov    %edx,%eax
  8013b5:	01 c0                	add    %eax,%eax
  8013b7:	01 d0                	add    %edx,%eax
  8013b9:	c1 e0 03             	shl    $0x3,%eax
  8013bc:	01 c8                	add    %ecx,%eax
  8013be:	8b 00                	mov    (%eax),%eax
  8013c0:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  8013c6:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8013cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d1:	89 c2                	mov    %eax,%edx
  8013d3:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8013d9:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
  8013df:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8013e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ea:	39 c2                	cmp    %eax,%edx
  8013ec:	75 17                	jne    801405 <_main+0x13cd>
				panic("free: page is not removed from WS");
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	68 d4 35 80 00       	push   $0x8035d4
  8013f6:	68 08 01 00 00       	push   $0x108
  8013fb:	68 3c 34 80 00       	push   $0x80343c
  801400:	e8 d6 05 00 00       	call   8019db <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  801405:	a1 20 40 80 00       	mov    0x804020,%eax
  80140a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801410:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801413:	89 d0                	mov    %edx,%eax
  801415:	01 c0                	add    %eax,%eax
  801417:	01 d0                	add    %edx,%eax
  801419:	c1 e0 03             	shl    $0x3,%eax
  80141c:	01 c8                	add    %ecx,%eax
  80141e:	8b 00                	mov    (%eax),%eax
  801420:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
  801426:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  80142c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801431:	89 c2                	mov    %eax,%edx
  801433:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  801439:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  801440:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801446:	01 c8                	add    %ecx,%eax
  801448:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  80144e:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  801454:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801459:	39 c2                	cmp    %eax,%edx
  80145b:	75 17                	jne    801474 <_main+0x143c>
				panic("free: page is not removed from WS");
  80145d:	83 ec 04             	sub    $0x4,%esp
  801460:	68 d4 35 80 00       	push   $0x8035d4
  801465:	68 0a 01 00 00       	push   $0x10a
  80146a:	68 3c 34 80 00       	push   $0x80343c
  80146f:	e8 67 05 00 00       	call   8019db <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[4]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801474:	ff 45 e4             	incl   -0x1c(%ebp)
  801477:	a1 20 40 80 00       	mov    0x804020,%eax
  80147c:	8b 50 74             	mov    0x74(%eax),%edx
  80147f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801482:	39 c2                	cmp    %eax,%edx
  801484:	0f 87 1b ff ff ff    	ja     8013a5 <_main+0x136d>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80148a:	e8 b3 17 00 00       	call   802c42 <sys_calculate_free_frames>
  80148f:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801495:	e8 48 18 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  80149a:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[5]);
  8014a0:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  8014a6:	83 ec 0c             	sub    $0xc,%esp
  8014a9:	50                   	push   %eax
  8014aa:	e8 c5 15 00 00       	call   802a74 <free>
  8014af:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/4096) panic("Wrong free: Extra or less pages are removed from PageFile");
  8014b2:	e8 2b 18 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  8014b7:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  8014bd:	89 d1                	mov    %edx,%ecx
  8014bf:	29 c1                	sub    %eax,%ecx
  8014c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c4:	89 c2                	mov    %eax,%edx
  8014c6:	01 d2                	add    %edx,%edx
  8014c8:	01 d0                	add    %edx,%eax
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	79 05                	jns    8014d3 <_main+0x149b>
  8014ce:	05 ff 0f 00 00       	add    $0xfff,%eax
  8014d3:	c1 f8 0c             	sar    $0xc,%eax
  8014d6:	39 c1                	cmp    %eax,%ecx
  8014d8:	74 17                	je     8014f1 <_main+0x14b9>
  8014da:	83 ec 04             	sub    $0x4,%esp
  8014dd:	68 4c 35 80 00       	push   $0x80354c
  8014e2:	68 11 01 00 00       	push   $0x111
  8014e7:	68 3c 34 80 00       	push   $0x80343c
  8014ec:	e8 ea 04 00 00       	call   8019db <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8014f1:	e8 4c 17 00 00       	call   802c42 <sys_calculate_free_frames>
  8014f6:	89 c2                	mov    %eax,%edx
  8014f8:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8014fe:	39 c2                	cmp    %eax,%edx
  801500:	74 17                	je     801519 <_main+0x14e1>
  801502:	83 ec 04             	sub    $0x4,%esp
  801505:	68 88 35 80 00       	push   $0x803588
  80150a:	68 12 01 00 00       	push   $0x112
  80150f:	68 3c 34 80 00       	push   $0x80343c
  801514:	e8 c2 04 00 00       	call   8019db <_panic>

		//Free 1st 2 KB
		freeFrames = sys_calculate_free_frames() ;
  801519:	e8 24 17 00 00       	call   802c42 <sys_calculate_free_frames>
  80151e:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801524:	e8 b9 17 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  801529:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[2]);
  80152f:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  801535:	83 ec 0c             	sub    $0xc,%esp
  801538:	50                   	push   %eax
  801539:	e8 36 15 00 00       	call   802a74 <free>
  80153e:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  801541:	e8 9c 17 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  801546:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  80154c:	29 c2                	sub    %eax,%edx
  80154e:	89 d0                	mov    %edx,%eax
  801550:	83 f8 01             	cmp    $0x1,%eax
  801553:	74 17                	je     80156c <_main+0x1534>
  801555:	83 ec 04             	sub    $0x4,%esp
  801558:	68 4c 35 80 00       	push   $0x80354c
  80155d:	68 18 01 00 00       	push   $0x118
  801562:	68 3c 34 80 00       	push   $0x80343c
  801567:	e8 6f 04 00 00       	call   8019db <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80156c:	e8 d1 16 00 00       	call   802c42 <sys_calculate_free_frames>
  801571:	89 c2                	mov    %eax,%edx
  801573:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801579:	29 c2                	sub    %eax,%edx
  80157b:	89 d0                	mov    %edx,%eax
  80157d:	83 f8 02             	cmp    $0x2,%eax
  801580:	74 17                	je     801599 <_main+0x1561>
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	68 88 35 80 00       	push   $0x803588
  80158a:	68 19 01 00 00       	push   $0x119
  80158f:	68 3c 34 80 00       	push   $0x80343c
  801594:	e8 42 04 00 00       	call   8019db <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801599:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8015a0:	e9 c9 00 00 00       	jmp    80166e <_main+0x1636>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  8015a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8015aa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8015b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015b3:	89 d0                	mov    %edx,%eax
  8015b5:	01 c0                	add    %eax,%eax
  8015b7:	01 d0                	add    %edx,%eax
  8015b9:	c1 e0 03             	shl    $0x3,%eax
  8015bc:	01 c8                	add    %ecx,%eax
  8015be:	8b 00                	mov    (%eax),%eax
  8015c0:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
  8015c6:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  8015cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015d1:	89 c2                	mov    %eax,%edx
  8015d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8015d6:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
  8015dc:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  8015e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015e7:	39 c2                	cmp    %eax,%edx
  8015e9:	75 17                	jne    801602 <_main+0x15ca>
				panic("free: page is not removed from WS");
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	68 d4 35 80 00       	push   $0x8035d4
  8015f3:	68 1d 01 00 00       	push   $0x11d
  8015f8:	68 3c 34 80 00       	push   $0x80343c
  8015fd:	e8 d9 03 00 00       	call   8019db <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  801602:	a1 20 40 80 00       	mov    0x804020,%eax
  801607:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80160d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801610:	89 d0                	mov    %edx,%eax
  801612:	01 c0                	add    %eax,%eax
  801614:	01 d0                	add    %edx,%eax
  801616:	c1 e0 03             	shl    $0x3,%eax
  801619:	01 c8                	add    %ecx,%eax
  80161b:	8b 00                	mov    (%eax),%eax
  80161d:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
  801623:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801629:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80162e:	89 c2                	mov    %eax,%edx
  801630:	8b 45 88             	mov    -0x78(%ebp),%eax
  801633:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80163a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80163d:	01 c8                	add    %ecx,%eax
  80163f:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
  801645:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  80164b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801650:	39 c2                	cmp    %eax,%edx
  801652:	75 17                	jne    80166b <_main+0x1633>
				panic("free: page is not removed from WS");
  801654:	83 ec 04             	sub    $0x4,%esp
  801657:	68 d4 35 80 00       	push   $0x8035d4
  80165c:	68 1f 01 00 00       	push   $0x11f
  801661:	68 3c 34 80 00       	push   $0x80343c
  801666:	e8 70 03 00 00       	call   8019db <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[2]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80166b:	ff 45 e4             	incl   -0x1c(%ebp)
  80166e:	a1 20 40 80 00       	mov    0x804020,%eax
  801673:	8b 50 74             	mov    0x74(%eax),%edx
  801676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801679:	39 c2                	cmp    %eax,%edx
  80167b:	0f 87 24 ff ff ff    	ja     8015a5 <_main+0x156d>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 2nd 2 KB
		freeFrames = sys_calculate_free_frames() ;
  801681:	e8 bc 15 00 00       	call   802c42 <sys_calculate_free_frames>
  801686:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80168c:	e8 51 16 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  801691:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[3]);
  801697:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  80169d:	83 ec 0c             	sub    $0xc,%esp
  8016a0:	50                   	push   %eax
  8016a1:	e8 ce 13 00 00       	call   802a74 <free>
  8016a6:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  8016a9:	e8 34 16 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  8016ae:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  8016b4:	29 c2                	sub    %eax,%edx
  8016b6:	89 d0                	mov    %edx,%eax
  8016b8:	83 f8 01             	cmp    $0x1,%eax
  8016bb:	74 17                	je     8016d4 <_main+0x169c>
  8016bd:	83 ec 04             	sub    $0x4,%esp
  8016c0:	68 4c 35 80 00       	push   $0x80354c
  8016c5:	68 26 01 00 00       	push   $0x126
  8016ca:	68 3c 34 80 00       	push   $0x80343c
  8016cf:	e8 07 03 00 00       	call   8019db <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8016d4:	e8 69 15 00 00       	call   802c42 <sys_calculate_free_frames>
  8016d9:	89 c2                	mov    %eax,%edx
  8016db:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8016e1:	39 c2                	cmp    %eax,%edx
  8016e3:	74 17                	je     8016fc <_main+0x16c4>
  8016e5:	83 ec 04             	sub    $0x4,%esp
  8016e8:	68 88 35 80 00       	push   $0x803588
  8016ed:	68 27 01 00 00       	push   $0x127
  8016f2:	68 3c 34 80 00       	push   $0x80343c
  8016f7:	e8 df 02 00 00       	call   8019db <_panic>


		//Free last 14 KB
		freeFrames = sys_calculate_free_frames() ;
  8016fc:	e8 41 15 00 00       	call   802c42 <sys_calculate_free_frames>
  801701:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801707:	e8 d6 15 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  80170c:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[7]);
  801712:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  801718:	83 ec 0c             	sub    $0xc,%esp
  80171b:	50                   	push   %eax
  80171c:	e8 53 13 00 00       	call   802a74 <free>
  801721:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 4) panic("Wrong free: Extra or less pages are removed from PageFile");
  801724:	e8 b9 15 00 00       	call   802ce2 <sys_pf_calculate_allocated_pages>
  801729:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
  80172f:	29 c2                	sub    %eax,%edx
  801731:	89 d0                	mov    %edx,%eax
  801733:	83 f8 04             	cmp    $0x4,%eax
  801736:	74 17                	je     80174f <_main+0x1717>
  801738:	83 ec 04             	sub    $0x4,%esp
  80173b:	68 4c 35 80 00       	push   $0x80354c
  801740:	68 2e 01 00 00       	push   $0x12e
  801745:	68 3c 34 80 00       	push   $0x80343c
  80174a:	e8 8c 02 00 00       	call   8019db <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80174f:	e8 ee 14 00 00       	call   802c42 <sys_calculate_free_frames>
  801754:	89 c2                	mov    %eax,%edx
  801756:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80175c:	29 c2                	sub    %eax,%edx
  80175e:	89 d0                	mov    %edx,%eax
  801760:	83 f8 03             	cmp    $0x3,%eax
  801763:	74 17                	je     80177c <_main+0x1744>
  801765:	83 ec 04             	sub    $0x4,%esp
  801768:	68 88 35 80 00       	push   $0x803588
  80176d:	68 2f 01 00 00       	push   $0x12f
  801772:	68 3c 34 80 00       	push   $0x80343c
  801777:	e8 5f 02 00 00       	call   8019db <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80177c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801783:	e9 c6 00 00 00       	jmp    80184e <_main+0x1816>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  801788:	a1 20 40 80 00       	mov    0x804020,%eax
  80178d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801793:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801796:	89 d0                	mov    %edx,%eax
  801798:	01 c0                	add    %eax,%eax
  80179a:	01 d0                	add    %edx,%eax
  80179c:	c1 e0 03             	shl    $0x3,%eax
  80179f:	01 c8                	add    %ecx,%eax
  8017a1:	8b 00                	mov    (%eax),%eax
  8017a3:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
  8017a9:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  8017af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017b4:	89 c2                	mov    %eax,%edx
  8017b6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8017b9:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
  8017bf:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  8017c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017ca:	39 c2                	cmp    %eax,%edx
  8017cc:	75 17                	jne    8017e5 <_main+0x17ad>
				panic("free: page is not removed from WS");
  8017ce:	83 ec 04             	sub    $0x4,%esp
  8017d1:	68 d4 35 80 00       	push   $0x8035d4
  8017d6:	68 33 01 00 00       	push   $0x133
  8017db:	68 3c 34 80 00       	push   $0x80343c
  8017e0:	e8 f6 01 00 00       	call   8019db <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8017e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8017ea:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8017f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017f3:	89 d0                	mov    %edx,%eax
  8017f5:	01 c0                	add    %eax,%eax
  8017f7:	01 d0                	add    %edx,%eax
  8017f9:	c1 e0 03             	shl    $0x3,%eax
  8017fc:	01 c8                	add    %ecx,%eax
  8017fe:	8b 00                	mov    (%eax),%eax
  801800:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
  801806:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  80180c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801811:	89 c2                	mov    %eax,%edx
  801813:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801816:	01 c0                	add    %eax,%eax
  801818:	89 c1                	mov    %eax,%ecx
  80181a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80181d:	01 c8                	add    %ecx,%eax
  80181f:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
  801825:	8b 85 b8 fe ff ff    	mov    -0x148(%ebp),%eax
  80182b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801830:	39 c2                	cmp    %eax,%edx
  801832:	75 17                	jne    80184b <_main+0x1813>
				panic("free: page is not removed from WS");
  801834:	83 ec 04             	sub    $0x4,%esp
  801837:	68 d4 35 80 00       	push   $0x8035d4
  80183c:	68 35 01 00 00       	push   $0x135
  801841:	68 3c 34 80 00       	push   $0x80343c
  801846:	e8 90 01 00 00       	call   8019db <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[7]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 4) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80184b:	ff 45 e4             	incl   -0x1c(%ebp)
  80184e:	a1 20 40 80 00       	mov    0x804020,%eax
  801853:	8b 50 74             	mov    0x74(%eax),%edx
  801856:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801859:	39 c2                	cmp    %eax,%edx
  80185b:	0f 87 27 ff ff ff    	ja     801788 <_main+0x1750>
				panic("free: page is not removed from WS");
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		if(start_freeFrames != (sys_calculate_free_frames() + 4)) {panic("Wrong free: not all pages removed correctly at end");}
  801861:	e8 dc 13 00 00       	call   802c42 <sys_calculate_free_frames>
  801866:	8d 50 04             	lea    0x4(%eax),%edx
  801869:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80186c:	39 c2                	cmp    %eax,%edx
  80186e:	74 17                	je     801887 <_main+0x184f>
  801870:	83 ec 04             	sub    $0x4,%esp
  801873:	68 f8 35 80 00       	push   $0x8035f8
  801878:	68 38 01 00 00       	push   $0x138
  80187d:	68 3c 34 80 00       	push   $0x80343c
  801882:	e8 54 01 00 00       	call   8019db <_panic>
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
  801887:	83 ec 0c             	sub    $0xc,%esp
  80188a:	68 2c 36 80 00       	push   $0x80362c
  80188f:	e8 fb 03 00 00       	call   801c8f <cprintf>
  801894:	83 c4 10             	add    $0x10,%esp

	return;
  801897:	90                   	nop
}
  801898:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189b:	5b                   	pop    %ebx
  80189c:	5f                   	pop    %edi
  80189d:	5d                   	pop    %ebp
  80189e:	c3                   	ret    

0080189f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8018a5:	e8 78 16 00 00       	call   802f22 <sys_getenvindex>
  8018aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8018ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b0:	89 d0                	mov    %edx,%eax
  8018b2:	c1 e0 03             	shl    $0x3,%eax
  8018b5:	01 d0                	add    %edx,%eax
  8018b7:	01 c0                	add    %eax,%eax
  8018b9:	01 d0                	add    %edx,%eax
  8018bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018c2:	01 d0                	add    %edx,%eax
  8018c4:	c1 e0 04             	shl    $0x4,%eax
  8018c7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8018cc:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8018d1:	a1 20 40 80 00       	mov    0x804020,%eax
  8018d6:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8018dc:	84 c0                	test   %al,%al
  8018de:	74 0f                	je     8018ef <libmain+0x50>
		binaryname = myEnv->prog_name;
  8018e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8018e5:	05 5c 05 00 00       	add    $0x55c,%eax
  8018ea:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8018ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018f3:	7e 0a                	jle    8018ff <libmain+0x60>
		binaryname = argv[0];
  8018f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f8:	8b 00                	mov    (%eax),%eax
  8018fa:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8018ff:	83 ec 08             	sub    $0x8,%esp
  801902:	ff 75 0c             	pushl  0xc(%ebp)
  801905:	ff 75 08             	pushl  0x8(%ebp)
  801908:	e8 2b e7 ff ff       	call   800038 <_main>
  80190d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  801910:	e8 1a 14 00 00       	call   802d2f <sys_disable_interrupt>
	cprintf("**************************************\n");
  801915:	83 ec 0c             	sub    $0xc,%esp
  801918:	68 80 36 80 00       	push   $0x803680
  80191d:	e8 6d 03 00 00       	call   801c8f <cprintf>
  801922:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801925:	a1 20 40 80 00       	mov    0x804020,%eax
  80192a:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  801930:	a1 20 40 80 00       	mov    0x804020,%eax
  801935:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80193b:	83 ec 04             	sub    $0x4,%esp
  80193e:	52                   	push   %edx
  80193f:	50                   	push   %eax
  801940:	68 a8 36 80 00       	push   $0x8036a8
  801945:	e8 45 03 00 00       	call   801c8f <cprintf>
  80194a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80194d:	a1 20 40 80 00       	mov    0x804020,%eax
  801952:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  801958:	a1 20 40 80 00       	mov    0x804020,%eax
  80195d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  801963:	a1 20 40 80 00       	mov    0x804020,%eax
  801968:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80196e:	51                   	push   %ecx
  80196f:	52                   	push   %edx
  801970:	50                   	push   %eax
  801971:	68 d0 36 80 00       	push   $0x8036d0
  801976:	e8 14 03 00 00       	call   801c8f <cprintf>
  80197b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80197e:	a1 20 40 80 00       	mov    0x804020,%eax
  801983:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  801989:	83 ec 08             	sub    $0x8,%esp
  80198c:	50                   	push   %eax
  80198d:	68 28 37 80 00       	push   $0x803728
  801992:	e8 f8 02 00 00       	call   801c8f <cprintf>
  801997:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80199a:	83 ec 0c             	sub    $0xc,%esp
  80199d:	68 80 36 80 00       	push   $0x803680
  8019a2:	e8 e8 02 00 00       	call   801c8f <cprintf>
  8019a7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8019aa:	e8 9a 13 00 00       	call   802d49 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8019af:	e8 19 00 00 00       	call   8019cd <exit>
}
  8019b4:	90                   	nop
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8019bd:	83 ec 0c             	sub    $0xc,%esp
  8019c0:	6a 00                	push   $0x0
  8019c2:	e8 27 15 00 00       	call   802eee <sys_destroy_env>
  8019c7:	83 c4 10             	add    $0x10,%esp
}
  8019ca:	90                   	nop
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <exit>:

void
exit(void)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8019d3:	e8 7c 15 00 00       	call   802f54 <sys_exit_env>
}
  8019d8:	90                   	nop
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8019e1:	8d 45 10             	lea    0x10(%ebp),%eax
  8019e4:	83 c0 04             	add    $0x4,%eax
  8019e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8019ea:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	74 16                	je     801a09 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8019f3:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8019f8:	83 ec 08             	sub    $0x8,%esp
  8019fb:	50                   	push   %eax
  8019fc:	68 3c 37 80 00       	push   $0x80373c
  801a01:	e8 89 02 00 00       	call   801c8f <cprintf>
  801a06:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801a09:	a1 00 40 80 00       	mov    0x804000,%eax
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	50                   	push   %eax
  801a15:	68 41 37 80 00       	push   $0x803741
  801a1a:	e8 70 02 00 00       	call   801c8f <cprintf>
  801a1f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801a22:	8b 45 10             	mov    0x10(%ebp),%eax
  801a25:	83 ec 08             	sub    $0x8,%esp
  801a28:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2b:	50                   	push   %eax
  801a2c:	e8 f3 01 00 00       	call   801c24 <vcprintf>
  801a31:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801a34:	83 ec 08             	sub    $0x8,%esp
  801a37:	6a 00                	push   $0x0
  801a39:	68 5d 37 80 00       	push   $0x80375d
  801a3e:	e8 e1 01 00 00       	call   801c24 <vcprintf>
  801a43:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801a46:	e8 82 ff ff ff       	call   8019cd <exit>

	// should not return here
	while (1) ;
  801a4b:	eb fe                	jmp    801a4b <_panic+0x70>

00801a4d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801a53:	a1 20 40 80 00       	mov    0x804020,%eax
  801a58:	8b 50 74             	mov    0x74(%eax),%edx
  801a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5e:	39 c2                	cmp    %eax,%edx
  801a60:	74 14                	je     801a76 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801a62:	83 ec 04             	sub    $0x4,%esp
  801a65:	68 60 37 80 00       	push   $0x803760
  801a6a:	6a 26                	push   $0x26
  801a6c:	68 ac 37 80 00       	push   $0x8037ac
  801a71:	e8 65 ff ff ff       	call   8019db <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801a76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a7d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a84:	e9 c2 00 00 00       	jmp    801b4b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	01 d0                	add    %edx,%eax
  801a98:	8b 00                	mov    (%eax),%eax
  801a9a:	85 c0                	test   %eax,%eax
  801a9c:	75 08                	jne    801aa6 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801a9e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801aa1:	e9 a2 00 00 00       	jmp    801b48 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801aa6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aad:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ab4:	eb 69                	jmp    801b1f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801ab6:	a1 20 40 80 00       	mov    0x804020,%eax
  801abb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801ac1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ac4:	89 d0                	mov    %edx,%eax
  801ac6:	01 c0                	add    %eax,%eax
  801ac8:	01 d0                	add    %edx,%eax
  801aca:	c1 e0 03             	shl    $0x3,%eax
  801acd:	01 c8                	add    %ecx,%eax
  801acf:	8a 40 04             	mov    0x4(%eax),%al
  801ad2:	84 c0                	test   %al,%al
  801ad4:	75 46                	jne    801b1c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ad6:	a1 20 40 80 00       	mov    0x804020,%eax
  801adb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801ae1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ae4:	89 d0                	mov    %edx,%eax
  801ae6:	01 c0                	add    %eax,%eax
  801ae8:	01 d0                	add    %edx,%eax
  801aea:	c1 e0 03             	shl    $0x3,%eax
  801aed:	01 c8                	add    %ecx,%eax
  801aef:	8b 00                	mov    (%eax),%eax
  801af1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801af4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801af7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801afc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b01:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	01 c8                	add    %ecx,%eax
  801b0d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b0f:	39 c2                	cmp    %eax,%edx
  801b11:	75 09                	jne    801b1c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801b13:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801b1a:	eb 12                	jmp    801b2e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b1c:	ff 45 e8             	incl   -0x18(%ebp)
  801b1f:	a1 20 40 80 00       	mov    0x804020,%eax
  801b24:	8b 50 74             	mov    0x74(%eax),%edx
  801b27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b2a:	39 c2                	cmp    %eax,%edx
  801b2c:	77 88                	ja     801ab6 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801b2e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b32:	75 14                	jne    801b48 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801b34:	83 ec 04             	sub    $0x4,%esp
  801b37:	68 b8 37 80 00       	push   $0x8037b8
  801b3c:	6a 3a                	push   $0x3a
  801b3e:	68 ac 37 80 00       	push   $0x8037ac
  801b43:	e8 93 fe ff ff       	call   8019db <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801b48:	ff 45 f0             	incl   -0x10(%ebp)
  801b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801b51:	0f 8c 32 ff ff ff    	jl     801a89 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801b57:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b5e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b65:	eb 26                	jmp    801b8d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801b67:	a1 20 40 80 00       	mov    0x804020,%eax
  801b6c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801b72:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b75:	89 d0                	mov    %edx,%eax
  801b77:	01 c0                	add    %eax,%eax
  801b79:	01 d0                	add    %edx,%eax
  801b7b:	c1 e0 03             	shl    $0x3,%eax
  801b7e:	01 c8                	add    %ecx,%eax
  801b80:	8a 40 04             	mov    0x4(%eax),%al
  801b83:	3c 01                	cmp    $0x1,%al
  801b85:	75 03                	jne    801b8a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801b87:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b8a:	ff 45 e0             	incl   -0x20(%ebp)
  801b8d:	a1 20 40 80 00       	mov    0x804020,%eax
  801b92:	8b 50 74             	mov    0x74(%eax),%edx
  801b95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b98:	39 c2                	cmp    %eax,%edx
  801b9a:	77 cb                	ja     801b67 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801ba2:	74 14                	je     801bb8 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801ba4:	83 ec 04             	sub    $0x4,%esp
  801ba7:	68 0c 38 80 00       	push   $0x80380c
  801bac:	6a 44                	push   $0x44
  801bae:	68 ac 37 80 00       	push   $0x8037ac
  801bb3:	e8 23 fe ff ff       	call   8019db <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801bb8:	90                   	nop
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc4:	8b 00                	mov    (%eax),%eax
  801bc6:	8d 48 01             	lea    0x1(%eax),%ecx
  801bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcc:	89 0a                	mov    %ecx,(%edx)
  801bce:	8b 55 08             	mov    0x8(%ebp),%edx
  801bd1:	88 d1                	mov    %dl,%cl
  801bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bdd:	8b 00                	mov    (%eax),%eax
  801bdf:	3d ff 00 00 00       	cmp    $0xff,%eax
  801be4:	75 2c                	jne    801c12 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801be6:	a0 24 40 80 00       	mov    0x804024,%al
  801beb:	0f b6 c0             	movzbl %al,%eax
  801bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf1:	8b 12                	mov    (%edx),%edx
  801bf3:	89 d1                	mov    %edx,%ecx
  801bf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf8:	83 c2 08             	add    $0x8,%edx
  801bfb:	83 ec 04             	sub    $0x4,%esp
  801bfe:	50                   	push   %eax
  801bff:	51                   	push   %ecx
  801c00:	52                   	push   %edx
  801c01:	e8 7b 0f 00 00       	call   802b81 <sys_cputs>
  801c06:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c15:	8b 40 04             	mov    0x4(%eax),%eax
  801c18:	8d 50 01             	lea    0x1(%eax),%edx
  801c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1e:	89 50 04             	mov    %edx,0x4(%eax)
}
  801c21:	90                   	nop
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801c2d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801c34:	00 00 00 
	b.cnt = 0;
  801c37:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801c3e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801c41:	ff 75 0c             	pushl  0xc(%ebp)
  801c44:	ff 75 08             	pushl  0x8(%ebp)
  801c47:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801c4d:	50                   	push   %eax
  801c4e:	68 bb 1b 80 00       	push   $0x801bbb
  801c53:	e8 11 02 00 00       	call   801e69 <vprintfmt>
  801c58:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801c5b:	a0 24 40 80 00       	mov    0x804024,%al
  801c60:	0f b6 c0             	movzbl %al,%eax
  801c63:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801c69:	83 ec 04             	sub    $0x4,%esp
  801c6c:	50                   	push   %eax
  801c6d:	52                   	push   %edx
  801c6e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801c74:	83 c0 08             	add    $0x8,%eax
  801c77:	50                   	push   %eax
  801c78:	e8 04 0f 00 00       	call   802b81 <sys_cputs>
  801c7d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801c80:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  801c87:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <cprintf>:

int cprintf(const char *fmt, ...) {
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801c95:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  801c9c:	8d 45 0c             	lea    0xc(%ebp),%eax
  801c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	83 ec 08             	sub    $0x8,%esp
  801ca8:	ff 75 f4             	pushl  -0xc(%ebp)
  801cab:	50                   	push   %eax
  801cac:	e8 73 ff ff ff       	call   801c24 <vcprintf>
  801cb1:	83 c4 10             	add    $0x10,%esp
  801cb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801cc2:	e8 68 10 00 00       	call   802d2f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801cc7:	8d 45 0c             	lea    0xc(%ebp),%eax
  801cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	83 ec 08             	sub    $0x8,%esp
  801cd3:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd6:	50                   	push   %eax
  801cd7:	e8 48 ff ff ff       	call   801c24 <vcprintf>
  801cdc:	83 c4 10             	add    $0x10,%esp
  801cdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801ce2:	e8 62 10 00 00       	call   802d49 <sys_enable_interrupt>
	return cnt;
  801ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	53                   	push   %ebx
  801cf0:	83 ec 14             	sub    $0x14,%esp
  801cf3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cf9:	8b 45 14             	mov    0x14(%ebp),%eax
  801cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801cff:	8b 45 18             	mov    0x18(%ebp),%eax
  801d02:	ba 00 00 00 00       	mov    $0x0,%edx
  801d07:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801d0a:	77 55                	ja     801d61 <printnum+0x75>
  801d0c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801d0f:	72 05                	jb     801d16 <printnum+0x2a>
  801d11:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d14:	77 4b                	ja     801d61 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801d16:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801d19:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801d1c:	8b 45 18             	mov    0x18(%ebp),%eax
  801d1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d24:	52                   	push   %edx
  801d25:	50                   	push   %eax
  801d26:	ff 75 f4             	pushl  -0xc(%ebp)
  801d29:	ff 75 f0             	pushl  -0x10(%ebp)
  801d2c:	e8 83 14 00 00       	call   8031b4 <__udivdi3>
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	83 ec 04             	sub    $0x4,%esp
  801d37:	ff 75 20             	pushl  0x20(%ebp)
  801d3a:	53                   	push   %ebx
  801d3b:	ff 75 18             	pushl  0x18(%ebp)
  801d3e:	52                   	push   %edx
  801d3f:	50                   	push   %eax
  801d40:	ff 75 0c             	pushl  0xc(%ebp)
  801d43:	ff 75 08             	pushl  0x8(%ebp)
  801d46:	e8 a1 ff ff ff       	call   801cec <printnum>
  801d4b:	83 c4 20             	add    $0x20,%esp
  801d4e:	eb 1a                	jmp    801d6a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801d50:	83 ec 08             	sub    $0x8,%esp
  801d53:	ff 75 0c             	pushl  0xc(%ebp)
  801d56:	ff 75 20             	pushl  0x20(%ebp)
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	ff d0                	call   *%eax
  801d5e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801d61:	ff 4d 1c             	decl   0x1c(%ebp)
  801d64:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801d68:	7f e6                	jg     801d50 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801d6a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801d6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d78:	53                   	push   %ebx
  801d79:	51                   	push   %ecx
  801d7a:	52                   	push   %edx
  801d7b:	50                   	push   %eax
  801d7c:	e8 43 15 00 00       	call   8032c4 <__umoddi3>
  801d81:	83 c4 10             	add    $0x10,%esp
  801d84:	05 74 3a 80 00       	add    $0x803a74,%eax
  801d89:	8a 00                	mov    (%eax),%al
  801d8b:	0f be c0             	movsbl %al,%eax
  801d8e:	83 ec 08             	sub    $0x8,%esp
  801d91:	ff 75 0c             	pushl  0xc(%ebp)
  801d94:	50                   	push   %eax
  801d95:	8b 45 08             	mov    0x8(%ebp),%eax
  801d98:	ff d0                	call   *%eax
  801d9a:	83 c4 10             	add    $0x10,%esp
}
  801d9d:	90                   	nop
  801d9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801da6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801daa:	7e 1c                	jle    801dc8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	8b 00                	mov    (%eax),%eax
  801db1:	8d 50 08             	lea    0x8(%eax),%edx
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	89 10                	mov    %edx,(%eax)
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	8b 00                	mov    (%eax),%eax
  801dbe:	83 e8 08             	sub    $0x8,%eax
  801dc1:	8b 50 04             	mov    0x4(%eax),%edx
  801dc4:	8b 00                	mov    (%eax),%eax
  801dc6:	eb 40                	jmp    801e08 <getuint+0x65>
	else if (lflag)
  801dc8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801dcc:	74 1e                	je     801dec <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	8b 00                	mov    (%eax),%eax
  801dd3:	8d 50 04             	lea    0x4(%eax),%edx
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	89 10                	mov    %edx,(%eax)
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	8b 00                	mov    (%eax),%eax
  801de0:	83 e8 04             	sub    $0x4,%eax
  801de3:	8b 00                	mov    (%eax),%eax
  801de5:	ba 00 00 00 00       	mov    $0x0,%edx
  801dea:	eb 1c                	jmp    801e08 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	8b 00                	mov    (%eax),%eax
  801df1:	8d 50 04             	lea    0x4(%eax),%edx
  801df4:	8b 45 08             	mov    0x8(%ebp),%eax
  801df7:	89 10                	mov    %edx,(%eax)
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	8b 00                	mov    (%eax),%eax
  801dfe:	83 e8 04             	sub    $0x4,%eax
  801e01:	8b 00                	mov    (%eax),%eax
  801e03:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801e08:	5d                   	pop    %ebp
  801e09:	c3                   	ret    

00801e0a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801e0d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801e11:	7e 1c                	jle    801e2f <getint+0x25>
		return va_arg(*ap, long long);
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	8b 00                	mov    (%eax),%eax
  801e18:	8d 50 08             	lea    0x8(%eax),%edx
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	89 10                	mov    %edx,(%eax)
  801e20:	8b 45 08             	mov    0x8(%ebp),%eax
  801e23:	8b 00                	mov    (%eax),%eax
  801e25:	83 e8 08             	sub    $0x8,%eax
  801e28:	8b 50 04             	mov    0x4(%eax),%edx
  801e2b:	8b 00                	mov    (%eax),%eax
  801e2d:	eb 38                	jmp    801e67 <getint+0x5d>
	else if (lflag)
  801e2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e33:	74 1a                	je     801e4f <getint+0x45>
		return va_arg(*ap, long);
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	8b 00                	mov    (%eax),%eax
  801e3a:	8d 50 04             	lea    0x4(%eax),%edx
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	89 10                	mov    %edx,(%eax)
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	8b 00                	mov    (%eax),%eax
  801e47:	83 e8 04             	sub    $0x4,%eax
  801e4a:	8b 00                	mov    (%eax),%eax
  801e4c:	99                   	cltd   
  801e4d:	eb 18                	jmp    801e67 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e52:	8b 00                	mov    (%eax),%eax
  801e54:	8d 50 04             	lea    0x4(%eax),%edx
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	89 10                	mov    %edx,(%eax)
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	8b 00                	mov    (%eax),%eax
  801e61:	83 e8 04             	sub    $0x4,%eax
  801e64:	8b 00                	mov    (%eax),%eax
  801e66:	99                   	cltd   
}
  801e67:	5d                   	pop    %ebp
  801e68:	c3                   	ret    

00801e69 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	56                   	push   %esi
  801e6d:	53                   	push   %ebx
  801e6e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801e71:	eb 17                	jmp    801e8a <vprintfmt+0x21>
			if (ch == '\0')
  801e73:	85 db                	test   %ebx,%ebx
  801e75:	0f 84 af 03 00 00    	je     80222a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801e7b:	83 ec 08             	sub    $0x8,%esp
  801e7e:	ff 75 0c             	pushl  0xc(%ebp)
  801e81:	53                   	push   %ebx
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	ff d0                	call   *%eax
  801e87:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8d:	8d 50 01             	lea    0x1(%eax),%edx
  801e90:	89 55 10             	mov    %edx,0x10(%ebp)
  801e93:	8a 00                	mov    (%eax),%al
  801e95:	0f b6 d8             	movzbl %al,%ebx
  801e98:	83 fb 25             	cmp    $0x25,%ebx
  801e9b:	75 d6                	jne    801e73 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801e9d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801ea1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801ea8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801eaf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801eb6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec0:	8d 50 01             	lea    0x1(%eax),%edx
  801ec3:	89 55 10             	mov    %edx,0x10(%ebp)
  801ec6:	8a 00                	mov    (%eax),%al
  801ec8:	0f b6 d8             	movzbl %al,%ebx
  801ecb:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801ece:	83 f8 55             	cmp    $0x55,%eax
  801ed1:	0f 87 2b 03 00 00    	ja     802202 <vprintfmt+0x399>
  801ed7:	8b 04 85 98 3a 80 00 	mov    0x803a98(,%eax,4),%eax
  801ede:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801ee0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801ee4:	eb d7                	jmp    801ebd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801ee6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801eea:	eb d1                	jmp    801ebd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801eec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801ef3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ef6:	89 d0                	mov    %edx,%eax
  801ef8:	c1 e0 02             	shl    $0x2,%eax
  801efb:	01 d0                	add    %edx,%eax
  801efd:	01 c0                	add    %eax,%eax
  801eff:	01 d8                	add    %ebx,%eax
  801f01:	83 e8 30             	sub    $0x30,%eax
  801f04:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801f07:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0a:	8a 00                	mov    (%eax),%al
  801f0c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801f0f:	83 fb 2f             	cmp    $0x2f,%ebx
  801f12:	7e 3e                	jle    801f52 <vprintfmt+0xe9>
  801f14:	83 fb 39             	cmp    $0x39,%ebx
  801f17:	7f 39                	jg     801f52 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801f19:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801f1c:	eb d5                	jmp    801ef3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801f1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f21:	83 c0 04             	add    $0x4,%eax
  801f24:	89 45 14             	mov    %eax,0x14(%ebp)
  801f27:	8b 45 14             	mov    0x14(%ebp),%eax
  801f2a:	83 e8 04             	sub    $0x4,%eax
  801f2d:	8b 00                	mov    (%eax),%eax
  801f2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801f32:	eb 1f                	jmp    801f53 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801f34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f38:	79 83                	jns    801ebd <vprintfmt+0x54>
				width = 0;
  801f3a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801f41:	e9 77 ff ff ff       	jmp    801ebd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801f46:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801f4d:	e9 6b ff ff ff       	jmp    801ebd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801f52:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801f53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f57:	0f 89 60 ff ff ff    	jns    801ebd <vprintfmt+0x54>
				width = precision, precision = -1;
  801f5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f63:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801f6a:	e9 4e ff ff ff       	jmp    801ebd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801f6f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801f72:	e9 46 ff ff ff       	jmp    801ebd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801f77:	8b 45 14             	mov    0x14(%ebp),%eax
  801f7a:	83 c0 04             	add    $0x4,%eax
  801f7d:	89 45 14             	mov    %eax,0x14(%ebp)
  801f80:	8b 45 14             	mov    0x14(%ebp),%eax
  801f83:	83 e8 04             	sub    $0x4,%eax
  801f86:	8b 00                	mov    (%eax),%eax
  801f88:	83 ec 08             	sub    $0x8,%esp
  801f8b:	ff 75 0c             	pushl  0xc(%ebp)
  801f8e:	50                   	push   %eax
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	ff d0                	call   *%eax
  801f94:	83 c4 10             	add    $0x10,%esp
			break;
  801f97:	e9 89 02 00 00       	jmp    802225 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801f9c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f9f:	83 c0 04             	add    $0x4,%eax
  801fa2:	89 45 14             	mov    %eax,0x14(%ebp)
  801fa5:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa8:	83 e8 04             	sub    $0x4,%eax
  801fab:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801fad:	85 db                	test   %ebx,%ebx
  801faf:	79 02                	jns    801fb3 <vprintfmt+0x14a>
				err = -err;
  801fb1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801fb3:	83 fb 64             	cmp    $0x64,%ebx
  801fb6:	7f 0b                	jg     801fc3 <vprintfmt+0x15a>
  801fb8:	8b 34 9d e0 38 80 00 	mov    0x8038e0(,%ebx,4),%esi
  801fbf:	85 f6                	test   %esi,%esi
  801fc1:	75 19                	jne    801fdc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801fc3:	53                   	push   %ebx
  801fc4:	68 85 3a 80 00       	push   $0x803a85
  801fc9:	ff 75 0c             	pushl  0xc(%ebp)
  801fcc:	ff 75 08             	pushl  0x8(%ebp)
  801fcf:	e8 5e 02 00 00       	call   802232 <printfmt>
  801fd4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801fd7:	e9 49 02 00 00       	jmp    802225 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801fdc:	56                   	push   %esi
  801fdd:	68 8e 3a 80 00       	push   $0x803a8e
  801fe2:	ff 75 0c             	pushl  0xc(%ebp)
  801fe5:	ff 75 08             	pushl  0x8(%ebp)
  801fe8:	e8 45 02 00 00       	call   802232 <printfmt>
  801fed:	83 c4 10             	add    $0x10,%esp
			break;
  801ff0:	e9 30 02 00 00       	jmp    802225 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801ff5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ff8:	83 c0 04             	add    $0x4,%eax
  801ffb:	89 45 14             	mov    %eax,0x14(%ebp)
  801ffe:	8b 45 14             	mov    0x14(%ebp),%eax
  802001:	83 e8 04             	sub    $0x4,%eax
  802004:	8b 30                	mov    (%eax),%esi
  802006:	85 f6                	test   %esi,%esi
  802008:	75 05                	jne    80200f <vprintfmt+0x1a6>
				p = "(null)";
  80200a:	be 91 3a 80 00       	mov    $0x803a91,%esi
			if (width > 0 && padc != '-')
  80200f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802013:	7e 6d                	jle    802082 <vprintfmt+0x219>
  802015:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  802019:	74 67                	je     802082 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80201b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80201e:	83 ec 08             	sub    $0x8,%esp
  802021:	50                   	push   %eax
  802022:	56                   	push   %esi
  802023:	e8 0c 03 00 00       	call   802334 <strnlen>
  802028:	83 c4 10             	add    $0x10,%esp
  80202b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80202e:	eb 16                	jmp    802046 <vprintfmt+0x1dd>
					putch(padc, putdat);
  802030:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  802034:	83 ec 08             	sub    $0x8,%esp
  802037:	ff 75 0c             	pushl  0xc(%ebp)
  80203a:	50                   	push   %eax
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	ff d0                	call   *%eax
  802040:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802043:	ff 4d e4             	decl   -0x1c(%ebp)
  802046:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80204a:	7f e4                	jg     802030 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80204c:	eb 34                	jmp    802082 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80204e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802052:	74 1c                	je     802070 <vprintfmt+0x207>
  802054:	83 fb 1f             	cmp    $0x1f,%ebx
  802057:	7e 05                	jle    80205e <vprintfmt+0x1f5>
  802059:	83 fb 7e             	cmp    $0x7e,%ebx
  80205c:	7e 12                	jle    802070 <vprintfmt+0x207>
					putch('?', putdat);
  80205e:	83 ec 08             	sub    $0x8,%esp
  802061:	ff 75 0c             	pushl  0xc(%ebp)
  802064:	6a 3f                	push   $0x3f
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	ff d0                	call   *%eax
  80206b:	83 c4 10             	add    $0x10,%esp
  80206e:	eb 0f                	jmp    80207f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  802070:	83 ec 08             	sub    $0x8,%esp
  802073:	ff 75 0c             	pushl  0xc(%ebp)
  802076:	53                   	push   %ebx
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	ff d0                	call   *%eax
  80207c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80207f:	ff 4d e4             	decl   -0x1c(%ebp)
  802082:	89 f0                	mov    %esi,%eax
  802084:	8d 70 01             	lea    0x1(%eax),%esi
  802087:	8a 00                	mov    (%eax),%al
  802089:	0f be d8             	movsbl %al,%ebx
  80208c:	85 db                	test   %ebx,%ebx
  80208e:	74 24                	je     8020b4 <vprintfmt+0x24b>
  802090:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802094:	78 b8                	js     80204e <vprintfmt+0x1e5>
  802096:	ff 4d e0             	decl   -0x20(%ebp)
  802099:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80209d:	79 af                	jns    80204e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80209f:	eb 13                	jmp    8020b4 <vprintfmt+0x24b>
				putch(' ', putdat);
  8020a1:	83 ec 08             	sub    $0x8,%esp
  8020a4:	ff 75 0c             	pushl  0xc(%ebp)
  8020a7:	6a 20                	push   $0x20
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	ff d0                	call   *%eax
  8020ae:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8020b1:	ff 4d e4             	decl   -0x1c(%ebp)
  8020b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8020b8:	7f e7                	jg     8020a1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8020ba:	e9 66 01 00 00       	jmp    802225 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8020bf:	83 ec 08             	sub    $0x8,%esp
  8020c2:	ff 75 e8             	pushl  -0x18(%ebp)
  8020c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8020c8:	50                   	push   %eax
  8020c9:	e8 3c fd ff ff       	call   801e0a <getint>
  8020ce:	83 c4 10             	add    $0x10,%esp
  8020d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8020d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020dd:	85 d2                	test   %edx,%edx
  8020df:	79 23                	jns    802104 <vprintfmt+0x29b>
				putch('-', putdat);
  8020e1:	83 ec 08             	sub    $0x8,%esp
  8020e4:	ff 75 0c             	pushl  0xc(%ebp)
  8020e7:	6a 2d                	push   $0x2d
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	ff d0                	call   *%eax
  8020ee:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8020f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f7:	f7 d8                	neg    %eax
  8020f9:	83 d2 00             	adc    $0x0,%edx
  8020fc:	f7 da                	neg    %edx
  8020fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802101:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  802104:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80210b:	e9 bc 00 00 00       	jmp    8021cc <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802110:	83 ec 08             	sub    $0x8,%esp
  802113:	ff 75 e8             	pushl  -0x18(%ebp)
  802116:	8d 45 14             	lea    0x14(%ebp),%eax
  802119:	50                   	push   %eax
  80211a:	e8 84 fc ff ff       	call   801da3 <getuint>
  80211f:	83 c4 10             	add    $0x10,%esp
  802122:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802125:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  802128:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80212f:	e9 98 00 00 00       	jmp    8021cc <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802134:	83 ec 08             	sub    $0x8,%esp
  802137:	ff 75 0c             	pushl  0xc(%ebp)
  80213a:	6a 58                	push   $0x58
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	ff d0                	call   *%eax
  802141:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  802144:	83 ec 08             	sub    $0x8,%esp
  802147:	ff 75 0c             	pushl  0xc(%ebp)
  80214a:	6a 58                	push   $0x58
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	ff d0                	call   *%eax
  802151:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  802154:	83 ec 08             	sub    $0x8,%esp
  802157:	ff 75 0c             	pushl  0xc(%ebp)
  80215a:	6a 58                	push   $0x58
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	ff d0                	call   *%eax
  802161:	83 c4 10             	add    $0x10,%esp
			break;
  802164:	e9 bc 00 00 00       	jmp    802225 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  802169:	83 ec 08             	sub    $0x8,%esp
  80216c:	ff 75 0c             	pushl  0xc(%ebp)
  80216f:	6a 30                	push   $0x30
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	ff d0                	call   *%eax
  802176:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  802179:	83 ec 08             	sub    $0x8,%esp
  80217c:	ff 75 0c             	pushl  0xc(%ebp)
  80217f:	6a 78                	push   $0x78
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	ff d0                	call   *%eax
  802186:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  802189:	8b 45 14             	mov    0x14(%ebp),%eax
  80218c:	83 c0 04             	add    $0x4,%eax
  80218f:	89 45 14             	mov    %eax,0x14(%ebp)
  802192:	8b 45 14             	mov    0x14(%ebp),%eax
  802195:	83 e8 04             	sub    $0x4,%eax
  802198:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80219a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80219d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8021a4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8021ab:	eb 1f                	jmp    8021cc <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8021ad:	83 ec 08             	sub    $0x8,%esp
  8021b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8021b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8021b6:	50                   	push   %eax
  8021b7:	e8 e7 fb ff ff       	call   801da3 <getuint>
  8021bc:	83 c4 10             	add    $0x10,%esp
  8021bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8021c5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8021cc:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8021d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d3:	83 ec 04             	sub    $0x4,%esp
  8021d6:	52                   	push   %edx
  8021d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021da:	50                   	push   %eax
  8021db:	ff 75 f4             	pushl  -0xc(%ebp)
  8021de:	ff 75 f0             	pushl  -0x10(%ebp)
  8021e1:	ff 75 0c             	pushl  0xc(%ebp)
  8021e4:	ff 75 08             	pushl  0x8(%ebp)
  8021e7:	e8 00 fb ff ff       	call   801cec <printnum>
  8021ec:	83 c4 20             	add    $0x20,%esp
			break;
  8021ef:	eb 34                	jmp    802225 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8021f1:	83 ec 08             	sub    $0x8,%esp
  8021f4:	ff 75 0c             	pushl  0xc(%ebp)
  8021f7:	53                   	push   %ebx
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	ff d0                	call   *%eax
  8021fd:	83 c4 10             	add    $0x10,%esp
			break;
  802200:	eb 23                	jmp    802225 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802202:	83 ec 08             	sub    $0x8,%esp
  802205:	ff 75 0c             	pushl  0xc(%ebp)
  802208:	6a 25                	push   $0x25
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	ff d0                	call   *%eax
  80220f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  802212:	ff 4d 10             	decl   0x10(%ebp)
  802215:	eb 03                	jmp    80221a <vprintfmt+0x3b1>
  802217:	ff 4d 10             	decl   0x10(%ebp)
  80221a:	8b 45 10             	mov    0x10(%ebp),%eax
  80221d:	48                   	dec    %eax
  80221e:	8a 00                	mov    (%eax),%al
  802220:	3c 25                	cmp    $0x25,%al
  802222:	75 f3                	jne    802217 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  802224:	90                   	nop
		}
	}
  802225:	e9 47 fc ff ff       	jmp    801e71 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80222a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80222b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80222e:	5b                   	pop    %ebx
  80222f:	5e                   	pop    %esi
  802230:	5d                   	pop    %ebp
  802231:	c3                   	ret    

00802232 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802238:	8d 45 10             	lea    0x10(%ebp),%eax
  80223b:	83 c0 04             	add    $0x4,%eax
  80223e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  802241:	8b 45 10             	mov    0x10(%ebp),%eax
  802244:	ff 75 f4             	pushl  -0xc(%ebp)
  802247:	50                   	push   %eax
  802248:	ff 75 0c             	pushl  0xc(%ebp)
  80224b:	ff 75 08             	pushl  0x8(%ebp)
  80224e:	e8 16 fc ff ff       	call   801e69 <vprintfmt>
  802253:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  802256:	90                   	nop
  802257:	c9                   	leave  
  802258:	c3                   	ret    

00802259 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80225c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225f:	8b 40 08             	mov    0x8(%eax),%eax
  802262:	8d 50 01             	lea    0x1(%eax),%edx
  802265:	8b 45 0c             	mov    0xc(%ebp),%eax
  802268:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80226b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226e:	8b 10                	mov    (%eax),%edx
  802270:	8b 45 0c             	mov    0xc(%ebp),%eax
  802273:	8b 40 04             	mov    0x4(%eax),%eax
  802276:	39 c2                	cmp    %eax,%edx
  802278:	73 12                	jae    80228c <sprintputch+0x33>
		*b->buf++ = ch;
  80227a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227d:	8b 00                	mov    (%eax),%eax
  80227f:	8d 48 01             	lea    0x1(%eax),%ecx
  802282:	8b 55 0c             	mov    0xc(%ebp),%edx
  802285:	89 0a                	mov    %ecx,(%edx)
  802287:	8b 55 08             	mov    0x8(%ebp),%edx
  80228a:	88 10                	mov    %dl,(%eax)
}
  80228c:	90                   	nop
  80228d:	5d                   	pop    %ebp
  80228e:	c3                   	ret    

0080228f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80229b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229e:	8d 50 ff             	lea    -0x1(%eax),%edx
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	01 d0                	add    %edx,%eax
  8022a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8022a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8022b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b4:	74 06                	je     8022bc <vsnprintf+0x2d>
  8022b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022ba:	7f 07                	jg     8022c3 <vsnprintf+0x34>
		return -E_INVAL;
  8022bc:	b8 03 00 00 00       	mov    $0x3,%eax
  8022c1:	eb 20                	jmp    8022e3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8022c3:	ff 75 14             	pushl  0x14(%ebp)
  8022c6:	ff 75 10             	pushl  0x10(%ebp)
  8022c9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8022cc:	50                   	push   %eax
  8022cd:	68 59 22 80 00       	push   $0x802259
  8022d2:	e8 92 fb ff ff       	call   801e69 <vprintfmt>
  8022d7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8022da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022dd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8022e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8022eb:	8d 45 10             	lea    0x10(%ebp),%eax
  8022ee:	83 c0 04             	add    $0x4,%eax
  8022f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8022f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8022fa:	50                   	push   %eax
  8022fb:	ff 75 0c             	pushl  0xc(%ebp)
  8022fe:	ff 75 08             	pushl  0x8(%ebp)
  802301:	e8 89 ff ff ff       	call   80228f <vsnprintf>
  802306:	83 c4 10             	add    $0x10,%esp
  802309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80230c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802317:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80231e:	eb 06                	jmp    802326 <strlen+0x15>
		n++;
  802320:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802323:	ff 45 08             	incl   0x8(%ebp)
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	8a 00                	mov    (%eax),%al
  80232b:	84 c0                	test   %al,%al
  80232d:	75 f1                	jne    802320 <strlen+0xf>
		n++;
	return n;
  80232f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802332:	c9                   	leave  
  802333:	c3                   	ret    

00802334 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
  802337:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80233a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802341:	eb 09                	jmp    80234c <strnlen+0x18>
		n++;
  802343:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802346:	ff 45 08             	incl   0x8(%ebp)
  802349:	ff 4d 0c             	decl   0xc(%ebp)
  80234c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802350:	74 09                	je     80235b <strnlen+0x27>
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	8a 00                	mov    (%eax),%al
  802357:	84 c0                	test   %al,%al
  802359:	75 e8                	jne    802343 <strnlen+0xf>
		n++;
	return n;
  80235b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80236c:	90                   	nop
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	8d 50 01             	lea    0x1(%eax),%edx
  802373:	89 55 08             	mov    %edx,0x8(%ebp)
  802376:	8b 55 0c             	mov    0xc(%ebp),%edx
  802379:	8d 4a 01             	lea    0x1(%edx),%ecx
  80237c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80237f:	8a 12                	mov    (%edx),%dl
  802381:	88 10                	mov    %dl,(%eax)
  802383:	8a 00                	mov    (%eax),%al
  802385:	84 c0                	test   %al,%al
  802387:	75 e4                	jne    80236d <strcpy+0xd>
		/* do nothing */;
	return ret;
  802389:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    

0080238e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
  802391:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80239a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8023a1:	eb 1f                	jmp    8023c2 <strncpy+0x34>
		*dst++ = *src;
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	8d 50 01             	lea    0x1(%eax),%edx
  8023a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8023ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023af:	8a 12                	mov    (%edx),%dl
  8023b1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8023b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b6:	8a 00                	mov    (%eax),%al
  8023b8:	84 c0                	test   %al,%al
  8023ba:	74 03                	je     8023bf <strncpy+0x31>
			src++;
  8023bc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8023bf:	ff 45 fc             	incl   -0x4(%ebp)
  8023c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023c5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8023c8:	72 d9                	jb     8023a3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8023ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
  8023d2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8023db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023df:	74 30                	je     802411 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8023e1:	eb 16                	jmp    8023f9 <strlcpy+0x2a>
			*dst++ = *src++;
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	8d 50 01             	lea    0x1(%eax),%edx
  8023e9:	89 55 08             	mov    %edx,0x8(%ebp)
  8023ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ef:	8d 4a 01             	lea    0x1(%edx),%ecx
  8023f2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8023f5:	8a 12                	mov    (%edx),%dl
  8023f7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8023f9:	ff 4d 10             	decl   0x10(%ebp)
  8023fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802400:	74 09                	je     80240b <strlcpy+0x3c>
  802402:	8b 45 0c             	mov    0xc(%ebp),%eax
  802405:	8a 00                	mov    (%eax),%al
  802407:	84 c0                	test   %al,%al
  802409:	75 d8                	jne    8023e3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802411:	8b 55 08             	mov    0x8(%ebp),%edx
  802414:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802417:	29 c2                	sub    %eax,%edx
  802419:	89 d0                	mov    %edx,%eax
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802420:	eb 06                	jmp    802428 <strcmp+0xb>
		p++, q++;
  802422:	ff 45 08             	incl   0x8(%ebp)
  802425:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802428:	8b 45 08             	mov    0x8(%ebp),%eax
  80242b:	8a 00                	mov    (%eax),%al
  80242d:	84 c0                	test   %al,%al
  80242f:	74 0e                	je     80243f <strcmp+0x22>
  802431:	8b 45 08             	mov    0x8(%ebp),%eax
  802434:	8a 10                	mov    (%eax),%dl
  802436:	8b 45 0c             	mov    0xc(%ebp),%eax
  802439:	8a 00                	mov    (%eax),%al
  80243b:	38 c2                	cmp    %al,%dl
  80243d:	74 e3                	je     802422 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	8a 00                	mov    (%eax),%al
  802444:	0f b6 d0             	movzbl %al,%edx
  802447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244a:	8a 00                	mov    (%eax),%al
  80244c:	0f b6 c0             	movzbl %al,%eax
  80244f:	29 c2                	sub    %eax,%edx
  802451:	89 d0                	mov    %edx,%eax
}
  802453:	5d                   	pop    %ebp
  802454:	c3                   	ret    

00802455 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802455:	55                   	push   %ebp
  802456:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802458:	eb 09                	jmp    802463 <strncmp+0xe>
		n--, p++, q++;
  80245a:	ff 4d 10             	decl   0x10(%ebp)
  80245d:	ff 45 08             	incl   0x8(%ebp)
  802460:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  802463:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802467:	74 17                	je     802480 <strncmp+0x2b>
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	8a 00                	mov    (%eax),%al
  80246e:	84 c0                	test   %al,%al
  802470:	74 0e                	je     802480 <strncmp+0x2b>
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	8a 10                	mov    (%eax),%dl
  802477:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247a:	8a 00                	mov    (%eax),%al
  80247c:	38 c2                	cmp    %al,%dl
  80247e:	74 da                	je     80245a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802480:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802484:	75 07                	jne    80248d <strncmp+0x38>
		return 0;
  802486:	b8 00 00 00 00       	mov    $0x0,%eax
  80248b:	eb 14                	jmp    8024a1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80248d:	8b 45 08             	mov    0x8(%ebp),%eax
  802490:	8a 00                	mov    (%eax),%al
  802492:	0f b6 d0             	movzbl %al,%edx
  802495:	8b 45 0c             	mov    0xc(%ebp),%eax
  802498:	8a 00                	mov    (%eax),%al
  80249a:	0f b6 c0             	movzbl %al,%eax
  80249d:	29 c2                	sub    %eax,%edx
  80249f:	89 d0                	mov    %edx,%eax
}
  8024a1:	5d                   	pop    %ebp
  8024a2:	c3                   	ret    

008024a3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
  8024a6:	83 ec 04             	sub    $0x4,%esp
  8024a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8024af:	eb 12                	jmp    8024c3 <strchr+0x20>
		if (*s == c)
  8024b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b4:	8a 00                	mov    (%eax),%al
  8024b6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8024b9:	75 05                	jne    8024c0 <strchr+0x1d>
			return (char *) s;
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	eb 11                	jmp    8024d1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8024c0:	ff 45 08             	incl   0x8(%ebp)
  8024c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c6:	8a 00                	mov    (%eax),%al
  8024c8:	84 c0                	test   %al,%al
  8024ca:	75 e5                	jne    8024b1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8024cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d1:	c9                   	leave  
  8024d2:	c3                   	ret    

008024d3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
  8024d6:	83 ec 04             	sub    $0x4,%esp
  8024d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8024df:	eb 0d                	jmp    8024ee <strfind+0x1b>
		if (*s == c)
  8024e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e4:	8a 00                	mov    (%eax),%al
  8024e6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8024e9:	74 0e                	je     8024f9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8024eb:	ff 45 08             	incl   0x8(%ebp)
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	8a 00                	mov    (%eax),%al
  8024f3:	84 c0                	test   %al,%al
  8024f5:	75 ea                	jne    8024e1 <strfind+0xe>
  8024f7:	eb 01                	jmp    8024fa <strfind+0x27>
		if (*s == c)
			break;
  8024f9:	90                   	nop
	return (char *) s;
  8024fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8024fd:	c9                   	leave  
  8024fe:	c3                   	ret    

008024ff <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
  802502:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  802505:	8b 45 08             	mov    0x8(%ebp),%eax
  802508:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80250b:	8b 45 10             	mov    0x10(%ebp),%eax
  80250e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  802511:	eb 0e                	jmp    802521 <memset+0x22>
		*p++ = c;
  802513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802516:	8d 50 01             	lea    0x1(%eax),%edx
  802519:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80251c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80251f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  802521:	ff 4d f8             	decl   -0x8(%ebp)
  802524:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802528:	79 e9                	jns    802513 <memset+0x14>
		*p++ = c;

	return v;
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
  802532:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802535:	8b 45 0c             	mov    0xc(%ebp),%eax
  802538:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  802541:	eb 16                	jmp    802559 <memcpy+0x2a>
		*d++ = *s++;
  802543:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802546:	8d 50 01             	lea    0x1(%eax),%edx
  802549:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80254c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80254f:	8d 4a 01             	lea    0x1(%edx),%ecx
  802552:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802555:	8a 12                	mov    (%edx),%dl
  802557:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  802559:	8b 45 10             	mov    0x10(%ebp),%eax
  80255c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80255f:	89 55 10             	mov    %edx,0x10(%ebp)
  802562:	85 c0                	test   %eax,%eax
  802564:	75 dd                	jne    802543 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  802566:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802569:	c9                   	leave  
  80256a:	c3                   	ret    

0080256b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
  80256e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802571:	8b 45 0c             	mov    0xc(%ebp),%eax
  802574:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802577:	8b 45 08             	mov    0x8(%ebp),%eax
  80257a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80257d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802580:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802583:	73 50                	jae    8025d5 <memmove+0x6a>
  802585:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802588:	8b 45 10             	mov    0x10(%ebp),%eax
  80258b:	01 d0                	add    %edx,%eax
  80258d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802590:	76 43                	jbe    8025d5 <memmove+0x6a>
		s += n;
  802592:	8b 45 10             	mov    0x10(%ebp),%eax
  802595:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802598:	8b 45 10             	mov    0x10(%ebp),%eax
  80259b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80259e:	eb 10                	jmp    8025b0 <memmove+0x45>
			*--d = *--s;
  8025a0:	ff 4d f8             	decl   -0x8(%ebp)
  8025a3:	ff 4d fc             	decl   -0x4(%ebp)
  8025a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a9:	8a 10                	mov    (%eax),%dl
  8025ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025ae:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8025b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8025b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8025b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8025b9:	85 c0                	test   %eax,%eax
  8025bb:	75 e3                	jne    8025a0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8025bd:	eb 23                	jmp    8025e2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8025bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025c2:	8d 50 01             	lea    0x1(%eax),%edx
  8025c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8025c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025cb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8025ce:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8025d1:	8a 12                	mov    (%edx),%dl
  8025d3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8025d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8025d8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8025db:	89 55 10             	mov    %edx,0x10(%ebp)
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	75 dd                	jne    8025bf <memmove+0x54>
			*d++ = *s++;

	return dst;
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8025e5:	c9                   	leave  
  8025e6:	c3                   	ret    

008025e7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
  8025ea:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8025ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8025f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8025f9:	eb 2a                	jmp    802625 <memcmp+0x3e>
		if (*s1 != *s2)
  8025fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025fe:	8a 10                	mov    (%eax),%dl
  802600:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802603:	8a 00                	mov    (%eax),%al
  802605:	38 c2                	cmp    %al,%dl
  802607:	74 16                	je     80261f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802609:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80260c:	8a 00                	mov    (%eax),%al
  80260e:	0f b6 d0             	movzbl %al,%edx
  802611:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802614:	8a 00                	mov    (%eax),%al
  802616:	0f b6 c0             	movzbl %al,%eax
  802619:	29 c2                	sub    %eax,%edx
  80261b:	89 d0                	mov    %edx,%eax
  80261d:	eb 18                	jmp    802637 <memcmp+0x50>
		s1++, s2++;
  80261f:	ff 45 fc             	incl   -0x4(%ebp)
  802622:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802625:	8b 45 10             	mov    0x10(%ebp),%eax
  802628:	8d 50 ff             	lea    -0x1(%eax),%edx
  80262b:	89 55 10             	mov    %edx,0x10(%ebp)
  80262e:	85 c0                	test   %eax,%eax
  802630:	75 c9                	jne    8025fb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802632:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802637:	c9                   	leave  
  802638:	c3                   	ret    

00802639 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802639:	55                   	push   %ebp
  80263a:	89 e5                	mov    %esp,%ebp
  80263c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80263f:	8b 55 08             	mov    0x8(%ebp),%edx
  802642:	8b 45 10             	mov    0x10(%ebp),%eax
  802645:	01 d0                	add    %edx,%eax
  802647:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80264a:	eb 15                	jmp    802661 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80264c:	8b 45 08             	mov    0x8(%ebp),%eax
  80264f:	8a 00                	mov    (%eax),%al
  802651:	0f b6 d0             	movzbl %al,%edx
  802654:	8b 45 0c             	mov    0xc(%ebp),%eax
  802657:	0f b6 c0             	movzbl %al,%eax
  80265a:	39 c2                	cmp    %eax,%edx
  80265c:	74 0d                	je     80266b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80265e:	ff 45 08             	incl   0x8(%ebp)
  802661:	8b 45 08             	mov    0x8(%ebp),%eax
  802664:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802667:	72 e3                	jb     80264c <memfind+0x13>
  802669:	eb 01                	jmp    80266c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80266b:	90                   	nop
	return (void *) s;
  80266c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80266f:	c9                   	leave  
  802670:	c3                   	ret    

00802671 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
  802674:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802677:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80267e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802685:	eb 03                	jmp    80268a <strtol+0x19>
		s++;
  802687:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80268a:	8b 45 08             	mov    0x8(%ebp),%eax
  80268d:	8a 00                	mov    (%eax),%al
  80268f:	3c 20                	cmp    $0x20,%al
  802691:	74 f4                	je     802687 <strtol+0x16>
  802693:	8b 45 08             	mov    0x8(%ebp),%eax
  802696:	8a 00                	mov    (%eax),%al
  802698:	3c 09                	cmp    $0x9,%al
  80269a:	74 eb                	je     802687 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80269c:	8b 45 08             	mov    0x8(%ebp),%eax
  80269f:	8a 00                	mov    (%eax),%al
  8026a1:	3c 2b                	cmp    $0x2b,%al
  8026a3:	75 05                	jne    8026aa <strtol+0x39>
		s++;
  8026a5:	ff 45 08             	incl   0x8(%ebp)
  8026a8:	eb 13                	jmp    8026bd <strtol+0x4c>
	else if (*s == '-')
  8026aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ad:	8a 00                	mov    (%eax),%al
  8026af:	3c 2d                	cmp    $0x2d,%al
  8026b1:	75 0a                	jne    8026bd <strtol+0x4c>
		s++, neg = 1;
  8026b3:	ff 45 08             	incl   0x8(%ebp)
  8026b6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8026bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026c1:	74 06                	je     8026c9 <strtol+0x58>
  8026c3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8026c7:	75 20                	jne    8026e9 <strtol+0x78>
  8026c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cc:	8a 00                	mov    (%eax),%al
  8026ce:	3c 30                	cmp    $0x30,%al
  8026d0:	75 17                	jne    8026e9 <strtol+0x78>
  8026d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d5:	40                   	inc    %eax
  8026d6:	8a 00                	mov    (%eax),%al
  8026d8:	3c 78                	cmp    $0x78,%al
  8026da:	75 0d                	jne    8026e9 <strtol+0x78>
		s += 2, base = 16;
  8026dc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8026e0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8026e7:	eb 28                	jmp    802711 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8026e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026ed:	75 15                	jne    802704 <strtol+0x93>
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	8a 00                	mov    (%eax),%al
  8026f4:	3c 30                	cmp    $0x30,%al
  8026f6:	75 0c                	jne    802704 <strtol+0x93>
		s++, base = 8;
  8026f8:	ff 45 08             	incl   0x8(%ebp)
  8026fb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802702:	eb 0d                	jmp    802711 <strtol+0xa0>
	else if (base == 0)
  802704:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802708:	75 07                	jne    802711 <strtol+0xa0>
		base = 10;
  80270a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802711:	8b 45 08             	mov    0x8(%ebp),%eax
  802714:	8a 00                	mov    (%eax),%al
  802716:	3c 2f                	cmp    $0x2f,%al
  802718:	7e 19                	jle    802733 <strtol+0xc2>
  80271a:	8b 45 08             	mov    0x8(%ebp),%eax
  80271d:	8a 00                	mov    (%eax),%al
  80271f:	3c 39                	cmp    $0x39,%al
  802721:	7f 10                	jg     802733 <strtol+0xc2>
			dig = *s - '0';
  802723:	8b 45 08             	mov    0x8(%ebp),%eax
  802726:	8a 00                	mov    (%eax),%al
  802728:	0f be c0             	movsbl %al,%eax
  80272b:	83 e8 30             	sub    $0x30,%eax
  80272e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802731:	eb 42                	jmp    802775 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802733:	8b 45 08             	mov    0x8(%ebp),%eax
  802736:	8a 00                	mov    (%eax),%al
  802738:	3c 60                	cmp    $0x60,%al
  80273a:	7e 19                	jle    802755 <strtol+0xe4>
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	8a 00                	mov    (%eax),%al
  802741:	3c 7a                	cmp    $0x7a,%al
  802743:	7f 10                	jg     802755 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802745:	8b 45 08             	mov    0x8(%ebp),%eax
  802748:	8a 00                	mov    (%eax),%al
  80274a:	0f be c0             	movsbl %al,%eax
  80274d:	83 e8 57             	sub    $0x57,%eax
  802750:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802753:	eb 20                	jmp    802775 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802755:	8b 45 08             	mov    0x8(%ebp),%eax
  802758:	8a 00                	mov    (%eax),%al
  80275a:	3c 40                	cmp    $0x40,%al
  80275c:	7e 39                	jle    802797 <strtol+0x126>
  80275e:	8b 45 08             	mov    0x8(%ebp),%eax
  802761:	8a 00                	mov    (%eax),%al
  802763:	3c 5a                	cmp    $0x5a,%al
  802765:	7f 30                	jg     802797 <strtol+0x126>
			dig = *s - 'A' + 10;
  802767:	8b 45 08             	mov    0x8(%ebp),%eax
  80276a:	8a 00                	mov    (%eax),%al
  80276c:	0f be c0             	movsbl %al,%eax
  80276f:	83 e8 37             	sub    $0x37,%eax
  802772:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	3b 45 10             	cmp    0x10(%ebp),%eax
  80277b:	7d 19                	jge    802796 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80277d:	ff 45 08             	incl   0x8(%ebp)
  802780:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802783:	0f af 45 10          	imul   0x10(%ebp),%eax
  802787:	89 c2                	mov    %eax,%edx
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	01 d0                	add    %edx,%eax
  80278e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802791:	e9 7b ff ff ff       	jmp    802711 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802796:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802797:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80279b:	74 08                	je     8027a5 <strtol+0x134>
		*endptr = (char *) s;
  80279d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8027a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027a9:	74 07                	je     8027b2 <strtol+0x141>
  8027ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027ae:	f7 d8                	neg    %eax
  8027b0:	eb 03                	jmp    8027b5 <strtol+0x144>
  8027b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <ltostr>:

void
ltostr(long value, char *str)
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
  8027ba:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8027bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8027c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8027cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027cf:	79 13                	jns    8027e4 <ltostr+0x2d>
	{
		neg = 1;
  8027d1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8027d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027db:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8027de:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8027e1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8027e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8027ec:	99                   	cltd   
  8027ed:	f7 f9                	idiv   %ecx
  8027ef:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8027f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027f5:	8d 50 01             	lea    0x1(%eax),%edx
  8027f8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8027fb:	89 c2                	mov    %eax,%edx
  8027fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802800:	01 d0                	add    %edx,%eax
  802802:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802805:	83 c2 30             	add    $0x30,%edx
  802808:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80280a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80280d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802812:	f7 e9                	imul   %ecx
  802814:	c1 fa 02             	sar    $0x2,%edx
  802817:	89 c8                	mov    %ecx,%eax
  802819:	c1 f8 1f             	sar    $0x1f,%eax
  80281c:	29 c2                	sub    %eax,%edx
  80281e:	89 d0                	mov    %edx,%eax
  802820:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802823:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802826:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80282b:	f7 e9                	imul   %ecx
  80282d:	c1 fa 02             	sar    $0x2,%edx
  802830:	89 c8                	mov    %ecx,%eax
  802832:	c1 f8 1f             	sar    $0x1f,%eax
  802835:	29 c2                	sub    %eax,%edx
  802837:	89 d0                	mov    %edx,%eax
  802839:	c1 e0 02             	shl    $0x2,%eax
  80283c:	01 d0                	add    %edx,%eax
  80283e:	01 c0                	add    %eax,%eax
  802840:	29 c1                	sub    %eax,%ecx
  802842:	89 ca                	mov    %ecx,%edx
  802844:	85 d2                	test   %edx,%edx
  802846:	75 9c                	jne    8027e4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802848:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80284f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802852:	48                   	dec    %eax
  802853:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802856:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80285a:	74 3d                	je     802899 <ltostr+0xe2>
		start = 1 ;
  80285c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802863:	eb 34                	jmp    802899 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802865:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80286b:	01 d0                	add    %edx,%eax
  80286d:	8a 00                	mov    (%eax),%al
  80286f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802875:	8b 45 0c             	mov    0xc(%ebp),%eax
  802878:	01 c2                	add    %eax,%edx
  80287a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80287d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802880:	01 c8                	add    %ecx,%eax
  802882:	8a 00                	mov    (%eax),%al
  802884:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802886:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802889:	8b 45 0c             	mov    0xc(%ebp),%eax
  80288c:	01 c2                	add    %eax,%edx
  80288e:	8a 45 eb             	mov    -0x15(%ebp),%al
  802891:	88 02                	mov    %al,(%edx)
		start++ ;
  802893:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802896:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80289f:	7c c4                	jl     802865 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8028a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8028a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028a7:	01 d0                	add    %edx,%eax
  8028a9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8028ac:	90                   	nop
  8028ad:	c9                   	leave  
  8028ae:	c3                   	ret    

008028af <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8028af:	55                   	push   %ebp
  8028b0:	89 e5                	mov    %esp,%ebp
  8028b2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8028b5:	ff 75 08             	pushl  0x8(%ebp)
  8028b8:	e8 54 fa ff ff       	call   802311 <strlen>
  8028bd:	83 c4 04             	add    $0x4,%esp
  8028c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8028c3:	ff 75 0c             	pushl  0xc(%ebp)
  8028c6:	e8 46 fa ff ff       	call   802311 <strlen>
  8028cb:	83 c4 04             	add    $0x4,%esp
  8028ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8028d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8028d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8028df:	eb 17                	jmp    8028f8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8028e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8028e7:	01 c2                	add    %eax,%edx
  8028e9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	01 c8                	add    %ecx,%eax
  8028f1:	8a 00                	mov    (%eax),%al
  8028f3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8028f5:	ff 45 fc             	incl   -0x4(%ebp)
  8028f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8028fe:	7c e1                	jl     8028e1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802900:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802907:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80290e:	eb 1f                	jmp    80292f <strcconcat+0x80>
		final[s++] = str2[i] ;
  802910:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802913:	8d 50 01             	lea    0x1(%eax),%edx
  802916:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802919:	89 c2                	mov    %eax,%edx
  80291b:	8b 45 10             	mov    0x10(%ebp),%eax
  80291e:	01 c2                	add    %eax,%edx
  802920:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802923:	8b 45 0c             	mov    0xc(%ebp),%eax
  802926:	01 c8                	add    %ecx,%eax
  802928:	8a 00                	mov    (%eax),%al
  80292a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80292c:	ff 45 f8             	incl   -0x8(%ebp)
  80292f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802932:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802935:	7c d9                	jl     802910 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802937:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80293a:	8b 45 10             	mov    0x10(%ebp),%eax
  80293d:	01 d0                	add    %edx,%eax
  80293f:	c6 00 00             	movb   $0x0,(%eax)
}
  802942:	90                   	nop
  802943:	c9                   	leave  
  802944:	c3                   	ret    

00802945 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802945:	55                   	push   %ebp
  802946:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802948:	8b 45 14             	mov    0x14(%ebp),%eax
  80294b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802951:	8b 45 14             	mov    0x14(%ebp),%eax
  802954:	8b 00                	mov    (%eax),%eax
  802956:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80295d:	8b 45 10             	mov    0x10(%ebp),%eax
  802960:	01 d0                	add    %edx,%eax
  802962:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802968:	eb 0c                	jmp    802976 <strsplit+0x31>
			*string++ = 0;
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	8d 50 01             	lea    0x1(%eax),%edx
  802970:	89 55 08             	mov    %edx,0x8(%ebp)
  802973:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	8a 00                	mov    (%eax),%al
  80297b:	84 c0                	test   %al,%al
  80297d:	74 18                	je     802997 <strsplit+0x52>
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	8a 00                	mov    (%eax),%al
  802984:	0f be c0             	movsbl %al,%eax
  802987:	50                   	push   %eax
  802988:	ff 75 0c             	pushl  0xc(%ebp)
  80298b:	e8 13 fb ff ff       	call   8024a3 <strchr>
  802990:	83 c4 08             	add    $0x8,%esp
  802993:	85 c0                	test   %eax,%eax
  802995:	75 d3                	jne    80296a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802997:	8b 45 08             	mov    0x8(%ebp),%eax
  80299a:	8a 00                	mov    (%eax),%al
  80299c:	84 c0                	test   %al,%al
  80299e:	74 5a                	je     8029fa <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8029a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8029a3:	8b 00                	mov    (%eax),%eax
  8029a5:	83 f8 0f             	cmp    $0xf,%eax
  8029a8:	75 07                	jne    8029b1 <strsplit+0x6c>
		{
			return 0;
  8029aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8029af:	eb 66                	jmp    802a17 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8029b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8029b4:	8b 00                	mov    (%eax),%eax
  8029b6:	8d 48 01             	lea    0x1(%eax),%ecx
  8029b9:	8b 55 14             	mov    0x14(%ebp),%edx
  8029bc:	89 0a                	mov    %ecx,(%edx)
  8029be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8029c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8029c8:	01 c2                	add    %eax,%edx
  8029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cd:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8029cf:	eb 03                	jmp    8029d4 <strsplit+0x8f>
			string++;
  8029d1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d7:	8a 00                	mov    (%eax),%al
  8029d9:	84 c0                	test   %al,%al
  8029db:	74 8b                	je     802968 <strsplit+0x23>
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	8a 00                	mov    (%eax),%al
  8029e2:	0f be c0             	movsbl %al,%eax
  8029e5:	50                   	push   %eax
  8029e6:	ff 75 0c             	pushl  0xc(%ebp)
  8029e9:	e8 b5 fa ff ff       	call   8024a3 <strchr>
  8029ee:	83 c4 08             	add    $0x8,%esp
  8029f1:	85 c0                	test   %eax,%eax
  8029f3:	74 dc                	je     8029d1 <strsplit+0x8c>
			string++;
	}
  8029f5:	e9 6e ff ff ff       	jmp    802968 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8029fa:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8029fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802a07:	8b 45 10             	mov    0x10(%ebp),%eax
  802a0a:	01 d0                	add    %edx,%eax
  802a0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802a12:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802a17:	c9                   	leave  
  802a18:	c3                   	ret    

00802a19 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802a19:	55                   	push   %ebp
  802a1a:	89 e5                	mov    %esp,%ebp
  802a1c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  802a1f:	83 ec 04             	sub    $0x4,%esp
  802a22:	68 f0 3b 80 00       	push   $0x803bf0
  802a27:	6a 0e                	push   $0xe
  802a29:	68 2a 3c 80 00       	push   $0x803c2a
  802a2e:	e8 a8 ef ff ff       	call   8019db <_panic>

00802a33 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  802a33:	55                   	push   %ebp
  802a34:	89 e5                	mov    %esp,%ebp
  802a36:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  802a39:	a1 04 40 80 00       	mov    0x804004,%eax
  802a3e:	85 c0                	test   %eax,%eax
  802a40:	74 0f                	je     802a51 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  802a42:	e8 d2 ff ff ff       	call   802a19 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  802a47:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  802a4e:	00 00 00 
	}
	if (size == 0) return NULL ;
  802a51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a55:	75 07                	jne    802a5e <malloc+0x2b>
  802a57:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5c:	eb 14                	jmp    802a72 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  802a5e:	83 ec 04             	sub    $0x4,%esp
  802a61:	68 38 3c 80 00       	push   $0x803c38
  802a66:	6a 2e                	push   $0x2e
  802a68:	68 2a 3c 80 00       	push   $0x803c2a
  802a6d:	e8 69 ef ff ff       	call   8019db <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  802a72:	c9                   	leave  
  802a73:	c3                   	ret    

00802a74 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802a74:	55                   	push   %ebp
  802a75:	89 e5                	mov    %esp,%ebp
  802a77:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  802a7a:	83 ec 04             	sub    $0x4,%esp
  802a7d:	68 60 3c 80 00       	push   $0x803c60
  802a82:	6a 49                	push   $0x49
  802a84:	68 2a 3c 80 00       	push   $0x803c2a
  802a89:	e8 4d ef ff ff       	call   8019db <_panic>

00802a8e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802a8e:	55                   	push   %ebp
  802a8f:	89 e5                	mov    %esp,%ebp
  802a91:	83 ec 18             	sub    $0x18,%esp
  802a94:	8b 45 10             	mov    0x10(%ebp),%eax
  802a97:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  802a9a:	83 ec 04             	sub    $0x4,%esp
  802a9d:	68 84 3c 80 00       	push   $0x803c84
  802aa2:	6a 57                	push   $0x57
  802aa4:	68 2a 3c 80 00       	push   $0x803c2a
  802aa9:	e8 2d ef ff ff       	call   8019db <_panic>

00802aae <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802aae:	55                   	push   %ebp
  802aaf:	89 e5                	mov    %esp,%ebp
  802ab1:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802ab4:	83 ec 04             	sub    $0x4,%esp
  802ab7:	68 ac 3c 80 00       	push   $0x803cac
  802abc:	6a 60                	push   $0x60
  802abe:	68 2a 3c 80 00       	push   $0x803c2a
  802ac3:	e8 13 ef ff ff       	call   8019db <_panic>

00802ac8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802ac8:	55                   	push   %ebp
  802ac9:	89 e5                	mov    %esp,%ebp
  802acb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802ace:	83 ec 04             	sub    $0x4,%esp
  802ad1:	68 d0 3c 80 00       	push   $0x803cd0
  802ad6:	6a 7c                	push   $0x7c
  802ad8:	68 2a 3c 80 00       	push   $0x803c2a
  802add:	e8 f9 ee ff ff       	call   8019db <_panic>

00802ae2 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  802ae2:	55                   	push   %ebp
  802ae3:	89 e5                	mov    %esp,%ebp
  802ae5:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802ae8:	83 ec 04             	sub    $0x4,%esp
  802aeb:	68 f8 3c 80 00       	push   $0x803cf8
  802af0:	68 86 00 00 00       	push   $0x86
  802af5:	68 2a 3c 80 00       	push   $0x803c2a
  802afa:	e8 dc ee ff ff       	call   8019db <_panic>

00802aff <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802aff:	55                   	push   %ebp
  802b00:	89 e5                	mov    %esp,%ebp
  802b02:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802b05:	83 ec 04             	sub    $0x4,%esp
  802b08:	68 1c 3d 80 00       	push   $0x803d1c
  802b0d:	68 91 00 00 00       	push   $0x91
  802b12:	68 2a 3c 80 00       	push   $0x803c2a
  802b17:	e8 bf ee ff ff       	call   8019db <_panic>

00802b1c <shrink>:

}
void shrink(uint32 newSize)
{
  802b1c:	55                   	push   %ebp
  802b1d:	89 e5                	mov    %esp,%ebp
  802b1f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802b22:	83 ec 04             	sub    $0x4,%esp
  802b25:	68 1c 3d 80 00       	push   $0x803d1c
  802b2a:	68 96 00 00 00       	push   $0x96
  802b2f:	68 2a 3c 80 00       	push   $0x803c2a
  802b34:	e8 a2 ee ff ff       	call   8019db <_panic>

00802b39 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802b39:	55                   	push   %ebp
  802b3a:	89 e5                	mov    %esp,%ebp
  802b3c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802b3f:	83 ec 04             	sub    $0x4,%esp
  802b42:	68 1c 3d 80 00       	push   $0x803d1c
  802b47:	68 9b 00 00 00       	push   $0x9b
  802b4c:	68 2a 3c 80 00       	push   $0x803c2a
  802b51:	e8 85 ee ff ff       	call   8019db <_panic>

00802b56 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802b56:	55                   	push   %ebp
  802b57:	89 e5                	mov    %esp,%ebp
  802b59:	57                   	push   %edi
  802b5a:	56                   	push   %esi
  802b5b:	53                   	push   %ebx
  802b5c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b65:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b68:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b6b:	8b 7d 18             	mov    0x18(%ebp),%edi
  802b6e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802b71:	cd 30                	int    $0x30
  802b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802b79:	83 c4 10             	add    $0x10,%esp
  802b7c:	5b                   	pop    %ebx
  802b7d:	5e                   	pop    %esi
  802b7e:	5f                   	pop    %edi
  802b7f:	5d                   	pop    %ebp
  802b80:	c3                   	ret    

00802b81 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802b81:	55                   	push   %ebp
  802b82:	89 e5                	mov    %esp,%ebp
  802b84:	83 ec 04             	sub    $0x4,%esp
  802b87:	8b 45 10             	mov    0x10(%ebp),%eax
  802b8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802b8d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	6a 00                	push   $0x0
  802b96:	6a 00                	push   $0x0
  802b98:	52                   	push   %edx
  802b99:	ff 75 0c             	pushl  0xc(%ebp)
  802b9c:	50                   	push   %eax
  802b9d:	6a 00                	push   $0x0
  802b9f:	e8 b2 ff ff ff       	call   802b56 <syscall>
  802ba4:	83 c4 18             	add    $0x18,%esp
}
  802ba7:	90                   	nop
  802ba8:	c9                   	leave  
  802ba9:	c3                   	ret    

00802baa <sys_cgetc>:

int
sys_cgetc(void)
{
  802baa:	55                   	push   %ebp
  802bab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802bad:	6a 00                	push   $0x0
  802baf:	6a 00                	push   $0x0
  802bb1:	6a 00                	push   $0x0
  802bb3:	6a 00                	push   $0x0
  802bb5:	6a 00                	push   $0x0
  802bb7:	6a 01                	push   $0x1
  802bb9:	e8 98 ff ff ff       	call   802b56 <syscall>
  802bbe:	83 c4 18             	add    $0x18,%esp
}
  802bc1:	c9                   	leave  
  802bc2:	c3                   	ret    

00802bc3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802bc3:	55                   	push   %ebp
  802bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	6a 00                	push   $0x0
  802bce:	6a 00                	push   $0x0
  802bd0:	6a 00                	push   $0x0
  802bd2:	52                   	push   %edx
  802bd3:	50                   	push   %eax
  802bd4:	6a 05                	push   $0x5
  802bd6:	e8 7b ff ff ff       	call   802b56 <syscall>
  802bdb:	83 c4 18             	add    $0x18,%esp
}
  802bde:	c9                   	leave  
  802bdf:	c3                   	ret    

00802be0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802be0:	55                   	push   %ebp
  802be1:	89 e5                	mov    %esp,%ebp
  802be3:	56                   	push   %esi
  802be4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802be5:	8b 75 18             	mov    0x18(%ebp),%esi
  802be8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802beb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	56                   	push   %esi
  802bf5:	53                   	push   %ebx
  802bf6:	51                   	push   %ecx
  802bf7:	52                   	push   %edx
  802bf8:	50                   	push   %eax
  802bf9:	6a 06                	push   $0x6
  802bfb:	e8 56 ff ff ff       	call   802b56 <syscall>
  802c00:	83 c4 18             	add    $0x18,%esp
}
  802c03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c06:	5b                   	pop    %ebx
  802c07:	5e                   	pop    %esi
  802c08:	5d                   	pop    %ebp
  802c09:	c3                   	ret    

00802c0a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802c0a:	55                   	push   %ebp
  802c0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	6a 00                	push   $0x0
  802c15:	6a 00                	push   $0x0
  802c17:	6a 00                	push   $0x0
  802c19:	52                   	push   %edx
  802c1a:	50                   	push   %eax
  802c1b:	6a 07                	push   $0x7
  802c1d:	e8 34 ff ff ff       	call   802b56 <syscall>
  802c22:	83 c4 18             	add    $0x18,%esp
}
  802c25:	c9                   	leave  
  802c26:	c3                   	ret    

00802c27 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802c27:	55                   	push   %ebp
  802c28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802c2a:	6a 00                	push   $0x0
  802c2c:	6a 00                	push   $0x0
  802c2e:	6a 00                	push   $0x0
  802c30:	ff 75 0c             	pushl  0xc(%ebp)
  802c33:	ff 75 08             	pushl  0x8(%ebp)
  802c36:	6a 08                	push   $0x8
  802c38:	e8 19 ff ff ff       	call   802b56 <syscall>
  802c3d:	83 c4 18             	add    $0x18,%esp
}
  802c40:	c9                   	leave  
  802c41:	c3                   	ret    

00802c42 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802c42:	55                   	push   %ebp
  802c43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802c45:	6a 00                	push   $0x0
  802c47:	6a 00                	push   $0x0
  802c49:	6a 00                	push   $0x0
  802c4b:	6a 00                	push   $0x0
  802c4d:	6a 00                	push   $0x0
  802c4f:	6a 09                	push   $0x9
  802c51:	e8 00 ff ff ff       	call   802b56 <syscall>
  802c56:	83 c4 18             	add    $0x18,%esp
}
  802c59:	c9                   	leave  
  802c5a:	c3                   	ret    

00802c5b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802c5b:	55                   	push   %ebp
  802c5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802c5e:	6a 00                	push   $0x0
  802c60:	6a 00                	push   $0x0
  802c62:	6a 00                	push   $0x0
  802c64:	6a 00                	push   $0x0
  802c66:	6a 00                	push   $0x0
  802c68:	6a 0a                	push   $0xa
  802c6a:	e8 e7 fe ff ff       	call   802b56 <syscall>
  802c6f:	83 c4 18             	add    $0x18,%esp
}
  802c72:	c9                   	leave  
  802c73:	c3                   	ret    

00802c74 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802c74:	55                   	push   %ebp
  802c75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802c77:	6a 00                	push   $0x0
  802c79:	6a 00                	push   $0x0
  802c7b:	6a 00                	push   $0x0
  802c7d:	6a 00                	push   $0x0
  802c7f:	6a 00                	push   $0x0
  802c81:	6a 0b                	push   $0xb
  802c83:	e8 ce fe ff ff       	call   802b56 <syscall>
  802c88:	83 c4 18             	add    $0x18,%esp
}
  802c8b:	c9                   	leave  
  802c8c:	c3                   	ret    

00802c8d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802c8d:	55                   	push   %ebp
  802c8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802c90:	6a 00                	push   $0x0
  802c92:	6a 00                	push   $0x0
  802c94:	6a 00                	push   $0x0
  802c96:	ff 75 0c             	pushl  0xc(%ebp)
  802c99:	ff 75 08             	pushl  0x8(%ebp)
  802c9c:	6a 0f                	push   $0xf
  802c9e:	e8 b3 fe ff ff       	call   802b56 <syscall>
  802ca3:	83 c4 18             	add    $0x18,%esp
	return;
  802ca6:	90                   	nop
}
  802ca7:	c9                   	leave  
  802ca8:	c3                   	ret    

00802ca9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802ca9:	55                   	push   %ebp
  802caa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802cac:	6a 00                	push   $0x0
  802cae:	6a 00                	push   $0x0
  802cb0:	6a 00                	push   $0x0
  802cb2:	ff 75 0c             	pushl  0xc(%ebp)
  802cb5:	ff 75 08             	pushl  0x8(%ebp)
  802cb8:	6a 10                	push   $0x10
  802cba:	e8 97 fe ff ff       	call   802b56 <syscall>
  802cbf:	83 c4 18             	add    $0x18,%esp
	return ;
  802cc2:	90                   	nop
}
  802cc3:	c9                   	leave  
  802cc4:	c3                   	ret    

00802cc5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802cc5:	55                   	push   %ebp
  802cc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802cc8:	6a 00                	push   $0x0
  802cca:	6a 00                	push   $0x0
  802ccc:	ff 75 10             	pushl  0x10(%ebp)
  802ccf:	ff 75 0c             	pushl  0xc(%ebp)
  802cd2:	ff 75 08             	pushl  0x8(%ebp)
  802cd5:	6a 11                	push   $0x11
  802cd7:	e8 7a fe ff ff       	call   802b56 <syscall>
  802cdc:	83 c4 18             	add    $0x18,%esp
	return ;
  802cdf:	90                   	nop
}
  802ce0:	c9                   	leave  
  802ce1:	c3                   	ret    

00802ce2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802ce2:	55                   	push   %ebp
  802ce3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802ce5:	6a 00                	push   $0x0
  802ce7:	6a 00                	push   $0x0
  802ce9:	6a 00                	push   $0x0
  802ceb:	6a 00                	push   $0x0
  802ced:	6a 00                	push   $0x0
  802cef:	6a 0c                	push   $0xc
  802cf1:	e8 60 fe ff ff       	call   802b56 <syscall>
  802cf6:	83 c4 18             	add    $0x18,%esp
}
  802cf9:	c9                   	leave  
  802cfa:	c3                   	ret    

00802cfb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802cfb:	55                   	push   %ebp
  802cfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802cfe:	6a 00                	push   $0x0
  802d00:	6a 00                	push   $0x0
  802d02:	6a 00                	push   $0x0
  802d04:	6a 00                	push   $0x0
  802d06:	ff 75 08             	pushl  0x8(%ebp)
  802d09:	6a 0d                	push   $0xd
  802d0b:	e8 46 fe ff ff       	call   802b56 <syscall>
  802d10:	83 c4 18             	add    $0x18,%esp
}
  802d13:	c9                   	leave  
  802d14:	c3                   	ret    

00802d15 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802d15:	55                   	push   %ebp
  802d16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802d18:	6a 00                	push   $0x0
  802d1a:	6a 00                	push   $0x0
  802d1c:	6a 00                	push   $0x0
  802d1e:	6a 00                	push   $0x0
  802d20:	6a 00                	push   $0x0
  802d22:	6a 0e                	push   $0xe
  802d24:	e8 2d fe ff ff       	call   802b56 <syscall>
  802d29:	83 c4 18             	add    $0x18,%esp
}
  802d2c:	90                   	nop
  802d2d:	c9                   	leave  
  802d2e:	c3                   	ret    

00802d2f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802d2f:	55                   	push   %ebp
  802d30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802d32:	6a 00                	push   $0x0
  802d34:	6a 00                	push   $0x0
  802d36:	6a 00                	push   $0x0
  802d38:	6a 00                	push   $0x0
  802d3a:	6a 00                	push   $0x0
  802d3c:	6a 13                	push   $0x13
  802d3e:	e8 13 fe ff ff       	call   802b56 <syscall>
  802d43:	83 c4 18             	add    $0x18,%esp
}
  802d46:	90                   	nop
  802d47:	c9                   	leave  
  802d48:	c3                   	ret    

00802d49 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802d49:	55                   	push   %ebp
  802d4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802d4c:	6a 00                	push   $0x0
  802d4e:	6a 00                	push   $0x0
  802d50:	6a 00                	push   $0x0
  802d52:	6a 00                	push   $0x0
  802d54:	6a 00                	push   $0x0
  802d56:	6a 14                	push   $0x14
  802d58:	e8 f9 fd ff ff       	call   802b56 <syscall>
  802d5d:	83 c4 18             	add    $0x18,%esp
}
  802d60:	90                   	nop
  802d61:	c9                   	leave  
  802d62:	c3                   	ret    

00802d63 <sys_cputc>:


void
sys_cputc(const char c)
{
  802d63:	55                   	push   %ebp
  802d64:	89 e5                	mov    %esp,%ebp
  802d66:	83 ec 04             	sub    $0x4,%esp
  802d69:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802d6f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802d73:	6a 00                	push   $0x0
  802d75:	6a 00                	push   $0x0
  802d77:	6a 00                	push   $0x0
  802d79:	6a 00                	push   $0x0
  802d7b:	50                   	push   %eax
  802d7c:	6a 15                	push   $0x15
  802d7e:	e8 d3 fd ff ff       	call   802b56 <syscall>
  802d83:	83 c4 18             	add    $0x18,%esp
}
  802d86:	90                   	nop
  802d87:	c9                   	leave  
  802d88:	c3                   	ret    

00802d89 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802d89:	55                   	push   %ebp
  802d8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802d8c:	6a 00                	push   $0x0
  802d8e:	6a 00                	push   $0x0
  802d90:	6a 00                	push   $0x0
  802d92:	6a 00                	push   $0x0
  802d94:	6a 00                	push   $0x0
  802d96:	6a 16                	push   $0x16
  802d98:	e8 b9 fd ff ff       	call   802b56 <syscall>
  802d9d:	83 c4 18             	add    $0x18,%esp
}
  802da0:	90                   	nop
  802da1:	c9                   	leave  
  802da2:	c3                   	ret    

00802da3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802da3:	55                   	push   %ebp
  802da4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	6a 00                	push   $0x0
  802dab:	6a 00                	push   $0x0
  802dad:	6a 00                	push   $0x0
  802daf:	ff 75 0c             	pushl  0xc(%ebp)
  802db2:	50                   	push   %eax
  802db3:	6a 17                	push   $0x17
  802db5:	e8 9c fd ff ff       	call   802b56 <syscall>
  802dba:	83 c4 18             	add    $0x18,%esp
}
  802dbd:	c9                   	leave  
  802dbe:	c3                   	ret    

00802dbf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802dbf:	55                   	push   %ebp
  802dc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802dc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc8:	6a 00                	push   $0x0
  802dca:	6a 00                	push   $0x0
  802dcc:	6a 00                	push   $0x0
  802dce:	52                   	push   %edx
  802dcf:	50                   	push   %eax
  802dd0:	6a 1a                	push   $0x1a
  802dd2:	e8 7f fd ff ff       	call   802b56 <syscall>
  802dd7:	83 c4 18             	add    $0x18,%esp
}
  802dda:	c9                   	leave  
  802ddb:	c3                   	ret    

00802ddc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802ddc:	55                   	push   %ebp
  802ddd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802ddf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	6a 00                	push   $0x0
  802de7:	6a 00                	push   $0x0
  802de9:	6a 00                	push   $0x0
  802deb:	52                   	push   %edx
  802dec:	50                   	push   %eax
  802ded:	6a 18                	push   $0x18
  802def:	e8 62 fd ff ff       	call   802b56 <syscall>
  802df4:	83 c4 18             	add    $0x18,%esp
}
  802df7:	90                   	nop
  802df8:	c9                   	leave  
  802df9:	c3                   	ret    

00802dfa <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802dfa:	55                   	push   %ebp
  802dfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	6a 00                	push   $0x0
  802e05:	6a 00                	push   $0x0
  802e07:	6a 00                	push   $0x0
  802e09:	52                   	push   %edx
  802e0a:	50                   	push   %eax
  802e0b:	6a 19                	push   $0x19
  802e0d:	e8 44 fd ff ff       	call   802b56 <syscall>
  802e12:	83 c4 18             	add    $0x18,%esp
}
  802e15:	90                   	nop
  802e16:	c9                   	leave  
  802e17:	c3                   	ret    

00802e18 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802e18:	55                   	push   %ebp
  802e19:	89 e5                	mov    %esp,%ebp
  802e1b:	83 ec 04             	sub    $0x4,%esp
  802e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  802e21:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802e24:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e27:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	6a 00                	push   $0x0
  802e30:	51                   	push   %ecx
  802e31:	52                   	push   %edx
  802e32:	ff 75 0c             	pushl  0xc(%ebp)
  802e35:	50                   	push   %eax
  802e36:	6a 1b                	push   $0x1b
  802e38:	e8 19 fd ff ff       	call   802b56 <syscall>
  802e3d:	83 c4 18             	add    $0x18,%esp
}
  802e40:	c9                   	leave  
  802e41:	c3                   	ret    

00802e42 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802e42:	55                   	push   %ebp
  802e43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802e45:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	6a 00                	push   $0x0
  802e4d:	6a 00                	push   $0x0
  802e4f:	6a 00                	push   $0x0
  802e51:	52                   	push   %edx
  802e52:	50                   	push   %eax
  802e53:	6a 1c                	push   $0x1c
  802e55:	e8 fc fc ff ff       	call   802b56 <syscall>
  802e5a:	83 c4 18             	add    $0x18,%esp
}
  802e5d:	c9                   	leave  
  802e5e:	c3                   	ret    

00802e5f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802e5f:	55                   	push   %ebp
  802e60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802e62:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	6a 00                	push   $0x0
  802e6d:	6a 00                	push   $0x0
  802e6f:	51                   	push   %ecx
  802e70:	52                   	push   %edx
  802e71:	50                   	push   %eax
  802e72:	6a 1d                	push   $0x1d
  802e74:	e8 dd fc ff ff       	call   802b56 <syscall>
  802e79:	83 c4 18             	add    $0x18,%esp
}
  802e7c:	c9                   	leave  
  802e7d:	c3                   	ret    

00802e7e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802e7e:	55                   	push   %ebp
  802e7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802e81:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e84:	8b 45 08             	mov    0x8(%ebp),%eax
  802e87:	6a 00                	push   $0x0
  802e89:	6a 00                	push   $0x0
  802e8b:	6a 00                	push   $0x0
  802e8d:	52                   	push   %edx
  802e8e:	50                   	push   %eax
  802e8f:	6a 1e                	push   $0x1e
  802e91:	e8 c0 fc ff ff       	call   802b56 <syscall>
  802e96:	83 c4 18             	add    $0x18,%esp
}
  802e99:	c9                   	leave  
  802e9a:	c3                   	ret    

00802e9b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802e9b:	55                   	push   %ebp
  802e9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802e9e:	6a 00                	push   $0x0
  802ea0:	6a 00                	push   $0x0
  802ea2:	6a 00                	push   $0x0
  802ea4:	6a 00                	push   $0x0
  802ea6:	6a 00                	push   $0x0
  802ea8:	6a 1f                	push   $0x1f
  802eaa:	e8 a7 fc ff ff       	call   802b56 <syscall>
  802eaf:	83 c4 18             	add    $0x18,%esp
}
  802eb2:	c9                   	leave  
  802eb3:	c3                   	ret    

00802eb4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802eb4:	55                   	push   %ebp
  802eb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	6a 00                	push   $0x0
  802ebc:	ff 75 14             	pushl  0x14(%ebp)
  802ebf:	ff 75 10             	pushl  0x10(%ebp)
  802ec2:	ff 75 0c             	pushl  0xc(%ebp)
  802ec5:	50                   	push   %eax
  802ec6:	6a 20                	push   $0x20
  802ec8:	e8 89 fc ff ff       	call   802b56 <syscall>
  802ecd:	83 c4 18             	add    $0x18,%esp
}
  802ed0:	c9                   	leave  
  802ed1:	c3                   	ret    

00802ed2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802ed2:	55                   	push   %ebp
  802ed3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	6a 00                	push   $0x0
  802eda:	6a 00                	push   $0x0
  802edc:	6a 00                	push   $0x0
  802ede:	6a 00                	push   $0x0
  802ee0:	50                   	push   %eax
  802ee1:	6a 21                	push   $0x21
  802ee3:	e8 6e fc ff ff       	call   802b56 <syscall>
  802ee8:	83 c4 18             	add    $0x18,%esp
}
  802eeb:	90                   	nop
  802eec:	c9                   	leave  
  802eed:	c3                   	ret    

00802eee <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802eee:	55                   	push   %ebp
  802eef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	6a 00                	push   $0x0
  802ef6:	6a 00                	push   $0x0
  802ef8:	6a 00                	push   $0x0
  802efa:	6a 00                	push   $0x0
  802efc:	50                   	push   %eax
  802efd:	6a 22                	push   $0x22
  802eff:	e8 52 fc ff ff       	call   802b56 <syscall>
  802f04:	83 c4 18             	add    $0x18,%esp
}
  802f07:	c9                   	leave  
  802f08:	c3                   	ret    

00802f09 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802f09:	55                   	push   %ebp
  802f0a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802f0c:	6a 00                	push   $0x0
  802f0e:	6a 00                	push   $0x0
  802f10:	6a 00                	push   $0x0
  802f12:	6a 00                	push   $0x0
  802f14:	6a 00                	push   $0x0
  802f16:	6a 02                	push   $0x2
  802f18:	e8 39 fc ff ff       	call   802b56 <syscall>
  802f1d:	83 c4 18             	add    $0x18,%esp
}
  802f20:	c9                   	leave  
  802f21:	c3                   	ret    

00802f22 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802f22:	55                   	push   %ebp
  802f23:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802f25:	6a 00                	push   $0x0
  802f27:	6a 00                	push   $0x0
  802f29:	6a 00                	push   $0x0
  802f2b:	6a 00                	push   $0x0
  802f2d:	6a 00                	push   $0x0
  802f2f:	6a 03                	push   $0x3
  802f31:	e8 20 fc ff ff       	call   802b56 <syscall>
  802f36:	83 c4 18             	add    $0x18,%esp
}
  802f39:	c9                   	leave  
  802f3a:	c3                   	ret    

00802f3b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802f3b:	55                   	push   %ebp
  802f3c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802f3e:	6a 00                	push   $0x0
  802f40:	6a 00                	push   $0x0
  802f42:	6a 00                	push   $0x0
  802f44:	6a 00                	push   $0x0
  802f46:	6a 00                	push   $0x0
  802f48:	6a 04                	push   $0x4
  802f4a:	e8 07 fc ff ff       	call   802b56 <syscall>
  802f4f:	83 c4 18             	add    $0x18,%esp
}
  802f52:	c9                   	leave  
  802f53:	c3                   	ret    

00802f54 <sys_exit_env>:


void sys_exit_env(void)
{
  802f54:	55                   	push   %ebp
  802f55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802f57:	6a 00                	push   $0x0
  802f59:	6a 00                	push   $0x0
  802f5b:	6a 00                	push   $0x0
  802f5d:	6a 00                	push   $0x0
  802f5f:	6a 00                	push   $0x0
  802f61:	6a 23                	push   $0x23
  802f63:	e8 ee fb ff ff       	call   802b56 <syscall>
  802f68:	83 c4 18             	add    $0x18,%esp
}
  802f6b:	90                   	nop
  802f6c:	c9                   	leave  
  802f6d:	c3                   	ret    

00802f6e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802f6e:	55                   	push   %ebp
  802f6f:	89 e5                	mov    %esp,%ebp
  802f71:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802f74:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802f77:	8d 50 04             	lea    0x4(%eax),%edx
  802f7a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802f7d:	6a 00                	push   $0x0
  802f7f:	6a 00                	push   $0x0
  802f81:	6a 00                	push   $0x0
  802f83:	52                   	push   %edx
  802f84:	50                   	push   %eax
  802f85:	6a 24                	push   $0x24
  802f87:	e8 ca fb ff ff       	call   802b56 <syscall>
  802f8c:	83 c4 18             	add    $0x18,%esp
	return result;
  802f8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802f95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f98:	89 01                	mov    %eax,(%ecx)
  802f9a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa0:	c9                   	leave  
  802fa1:	c2 04 00             	ret    $0x4

00802fa4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802fa4:	55                   	push   %ebp
  802fa5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802fa7:	6a 00                	push   $0x0
  802fa9:	6a 00                	push   $0x0
  802fab:	ff 75 10             	pushl  0x10(%ebp)
  802fae:	ff 75 0c             	pushl  0xc(%ebp)
  802fb1:	ff 75 08             	pushl  0x8(%ebp)
  802fb4:	6a 12                	push   $0x12
  802fb6:	e8 9b fb ff ff       	call   802b56 <syscall>
  802fbb:	83 c4 18             	add    $0x18,%esp
	return ;
  802fbe:	90                   	nop
}
  802fbf:	c9                   	leave  
  802fc0:	c3                   	ret    

00802fc1 <sys_rcr2>:
uint32 sys_rcr2()
{
  802fc1:	55                   	push   %ebp
  802fc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802fc4:	6a 00                	push   $0x0
  802fc6:	6a 00                	push   $0x0
  802fc8:	6a 00                	push   $0x0
  802fca:	6a 00                	push   $0x0
  802fcc:	6a 00                	push   $0x0
  802fce:	6a 25                	push   $0x25
  802fd0:	e8 81 fb ff ff       	call   802b56 <syscall>
  802fd5:	83 c4 18             	add    $0x18,%esp
}
  802fd8:	c9                   	leave  
  802fd9:	c3                   	ret    

00802fda <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802fda:	55                   	push   %ebp
  802fdb:	89 e5                	mov    %esp,%ebp
  802fdd:	83 ec 04             	sub    $0x4,%esp
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802fe6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802fea:	6a 00                	push   $0x0
  802fec:	6a 00                	push   $0x0
  802fee:	6a 00                	push   $0x0
  802ff0:	6a 00                	push   $0x0
  802ff2:	50                   	push   %eax
  802ff3:	6a 26                	push   $0x26
  802ff5:	e8 5c fb ff ff       	call   802b56 <syscall>
  802ffa:	83 c4 18             	add    $0x18,%esp
	return ;
  802ffd:	90                   	nop
}
  802ffe:	c9                   	leave  
  802fff:	c3                   	ret    

00803000 <rsttst>:
void rsttst()
{
  803000:	55                   	push   %ebp
  803001:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803003:	6a 00                	push   $0x0
  803005:	6a 00                	push   $0x0
  803007:	6a 00                	push   $0x0
  803009:	6a 00                	push   $0x0
  80300b:	6a 00                	push   $0x0
  80300d:	6a 28                	push   $0x28
  80300f:	e8 42 fb ff ff       	call   802b56 <syscall>
  803014:	83 c4 18             	add    $0x18,%esp
	return ;
  803017:	90                   	nop
}
  803018:	c9                   	leave  
  803019:	c3                   	ret    

0080301a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80301a:	55                   	push   %ebp
  80301b:	89 e5                	mov    %esp,%ebp
  80301d:	83 ec 04             	sub    $0x4,%esp
  803020:	8b 45 14             	mov    0x14(%ebp),%eax
  803023:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803026:	8b 55 18             	mov    0x18(%ebp),%edx
  803029:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80302d:	52                   	push   %edx
  80302e:	50                   	push   %eax
  80302f:	ff 75 10             	pushl  0x10(%ebp)
  803032:	ff 75 0c             	pushl  0xc(%ebp)
  803035:	ff 75 08             	pushl  0x8(%ebp)
  803038:	6a 27                	push   $0x27
  80303a:	e8 17 fb ff ff       	call   802b56 <syscall>
  80303f:	83 c4 18             	add    $0x18,%esp
	return ;
  803042:	90                   	nop
}
  803043:	c9                   	leave  
  803044:	c3                   	ret    

00803045 <chktst>:
void chktst(uint32 n)
{
  803045:	55                   	push   %ebp
  803046:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803048:	6a 00                	push   $0x0
  80304a:	6a 00                	push   $0x0
  80304c:	6a 00                	push   $0x0
  80304e:	6a 00                	push   $0x0
  803050:	ff 75 08             	pushl  0x8(%ebp)
  803053:	6a 29                	push   $0x29
  803055:	e8 fc fa ff ff       	call   802b56 <syscall>
  80305a:	83 c4 18             	add    $0x18,%esp
	return ;
  80305d:	90                   	nop
}
  80305e:	c9                   	leave  
  80305f:	c3                   	ret    

00803060 <inctst>:

void inctst()
{
  803060:	55                   	push   %ebp
  803061:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803063:	6a 00                	push   $0x0
  803065:	6a 00                	push   $0x0
  803067:	6a 00                	push   $0x0
  803069:	6a 00                	push   $0x0
  80306b:	6a 00                	push   $0x0
  80306d:	6a 2a                	push   $0x2a
  80306f:	e8 e2 fa ff ff       	call   802b56 <syscall>
  803074:	83 c4 18             	add    $0x18,%esp
	return ;
  803077:	90                   	nop
}
  803078:	c9                   	leave  
  803079:	c3                   	ret    

0080307a <gettst>:
uint32 gettst()
{
  80307a:	55                   	push   %ebp
  80307b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80307d:	6a 00                	push   $0x0
  80307f:	6a 00                	push   $0x0
  803081:	6a 00                	push   $0x0
  803083:	6a 00                	push   $0x0
  803085:	6a 00                	push   $0x0
  803087:	6a 2b                	push   $0x2b
  803089:	e8 c8 fa ff ff       	call   802b56 <syscall>
  80308e:	83 c4 18             	add    $0x18,%esp
}
  803091:	c9                   	leave  
  803092:	c3                   	ret    

00803093 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  803093:	55                   	push   %ebp
  803094:	89 e5                	mov    %esp,%ebp
  803096:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803099:	6a 00                	push   $0x0
  80309b:	6a 00                	push   $0x0
  80309d:	6a 00                	push   $0x0
  80309f:	6a 00                	push   $0x0
  8030a1:	6a 00                	push   $0x0
  8030a3:	6a 2c                	push   $0x2c
  8030a5:	e8 ac fa ff ff       	call   802b56 <syscall>
  8030aa:	83 c4 18             	add    $0x18,%esp
  8030ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8030b0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8030b4:	75 07                	jne    8030bd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8030b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8030bb:	eb 05                	jmp    8030c2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8030bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030c2:	c9                   	leave  
  8030c3:	c3                   	ret    

008030c4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8030c4:	55                   	push   %ebp
  8030c5:	89 e5                	mov    %esp,%ebp
  8030c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8030ca:	6a 00                	push   $0x0
  8030cc:	6a 00                	push   $0x0
  8030ce:	6a 00                	push   $0x0
  8030d0:	6a 00                	push   $0x0
  8030d2:	6a 00                	push   $0x0
  8030d4:	6a 2c                	push   $0x2c
  8030d6:	e8 7b fa ff ff       	call   802b56 <syscall>
  8030db:	83 c4 18             	add    $0x18,%esp
  8030de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8030e1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8030e5:	75 07                	jne    8030ee <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8030e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ec:	eb 05                	jmp    8030f3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8030ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030f3:	c9                   	leave  
  8030f4:	c3                   	ret    

008030f5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8030f5:	55                   	push   %ebp
  8030f6:	89 e5                	mov    %esp,%ebp
  8030f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8030fb:	6a 00                	push   $0x0
  8030fd:	6a 00                	push   $0x0
  8030ff:	6a 00                	push   $0x0
  803101:	6a 00                	push   $0x0
  803103:	6a 00                	push   $0x0
  803105:	6a 2c                	push   $0x2c
  803107:	e8 4a fa ff ff       	call   802b56 <syscall>
  80310c:	83 c4 18             	add    $0x18,%esp
  80310f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  803112:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  803116:	75 07                	jne    80311f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  803118:	b8 01 00 00 00       	mov    $0x1,%eax
  80311d:	eb 05                	jmp    803124 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80311f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803124:	c9                   	leave  
  803125:	c3                   	ret    

00803126 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  803126:	55                   	push   %ebp
  803127:	89 e5                	mov    %esp,%ebp
  803129:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80312c:	6a 00                	push   $0x0
  80312e:	6a 00                	push   $0x0
  803130:	6a 00                	push   $0x0
  803132:	6a 00                	push   $0x0
  803134:	6a 00                	push   $0x0
  803136:	6a 2c                	push   $0x2c
  803138:	e8 19 fa ff ff       	call   802b56 <syscall>
  80313d:	83 c4 18             	add    $0x18,%esp
  803140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  803143:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  803147:	75 07                	jne    803150 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  803149:	b8 01 00 00 00       	mov    $0x1,%eax
  80314e:	eb 05                	jmp    803155 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803150:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803155:	c9                   	leave  
  803156:	c3                   	ret    

00803157 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803157:	55                   	push   %ebp
  803158:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80315a:	6a 00                	push   $0x0
  80315c:	6a 00                	push   $0x0
  80315e:	6a 00                	push   $0x0
  803160:	6a 00                	push   $0x0
  803162:	ff 75 08             	pushl  0x8(%ebp)
  803165:	6a 2d                	push   $0x2d
  803167:	e8 ea f9 ff ff       	call   802b56 <syscall>
  80316c:	83 c4 18             	add    $0x18,%esp
	return ;
  80316f:	90                   	nop
}
  803170:	c9                   	leave  
  803171:	c3                   	ret    

00803172 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803172:	55                   	push   %ebp
  803173:	89 e5                	mov    %esp,%ebp
  803175:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803176:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803179:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80317c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	6a 00                	push   $0x0
  803184:	53                   	push   %ebx
  803185:	51                   	push   %ecx
  803186:	52                   	push   %edx
  803187:	50                   	push   %eax
  803188:	6a 2e                	push   $0x2e
  80318a:	e8 c7 f9 ff ff       	call   802b56 <syscall>
  80318f:	83 c4 18             	add    $0x18,%esp
}
  803192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803195:	c9                   	leave  
  803196:	c3                   	ret    

00803197 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803197:	55                   	push   %ebp
  803198:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80319a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80319d:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a0:	6a 00                	push   $0x0
  8031a2:	6a 00                	push   $0x0
  8031a4:	6a 00                	push   $0x0
  8031a6:	52                   	push   %edx
  8031a7:	50                   	push   %eax
  8031a8:	6a 2f                	push   $0x2f
  8031aa:	e8 a7 f9 ff ff       	call   802b56 <syscall>
  8031af:	83 c4 18             	add    $0x18,%esp
}
  8031b2:	c9                   	leave  
  8031b3:	c3                   	ret    

008031b4 <__udivdi3>:
  8031b4:	55                   	push   %ebp
  8031b5:	57                   	push   %edi
  8031b6:	56                   	push   %esi
  8031b7:	53                   	push   %ebx
  8031b8:	83 ec 1c             	sub    $0x1c,%esp
  8031bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031cb:	89 ca                	mov    %ecx,%edx
  8031cd:	89 f8                	mov    %edi,%eax
  8031cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031d3:	85 f6                	test   %esi,%esi
  8031d5:	75 2d                	jne    803204 <__udivdi3+0x50>
  8031d7:	39 cf                	cmp    %ecx,%edi
  8031d9:	77 65                	ja     803240 <__udivdi3+0x8c>
  8031db:	89 fd                	mov    %edi,%ebp
  8031dd:	85 ff                	test   %edi,%edi
  8031df:	75 0b                	jne    8031ec <__udivdi3+0x38>
  8031e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8031e6:	31 d2                	xor    %edx,%edx
  8031e8:	f7 f7                	div    %edi
  8031ea:	89 c5                	mov    %eax,%ebp
  8031ec:	31 d2                	xor    %edx,%edx
  8031ee:	89 c8                	mov    %ecx,%eax
  8031f0:	f7 f5                	div    %ebp
  8031f2:	89 c1                	mov    %eax,%ecx
  8031f4:	89 d8                	mov    %ebx,%eax
  8031f6:	f7 f5                	div    %ebp
  8031f8:	89 cf                	mov    %ecx,%edi
  8031fa:	89 fa                	mov    %edi,%edx
  8031fc:	83 c4 1c             	add    $0x1c,%esp
  8031ff:	5b                   	pop    %ebx
  803200:	5e                   	pop    %esi
  803201:	5f                   	pop    %edi
  803202:	5d                   	pop    %ebp
  803203:	c3                   	ret    
  803204:	39 ce                	cmp    %ecx,%esi
  803206:	77 28                	ja     803230 <__udivdi3+0x7c>
  803208:	0f bd fe             	bsr    %esi,%edi
  80320b:	83 f7 1f             	xor    $0x1f,%edi
  80320e:	75 40                	jne    803250 <__udivdi3+0x9c>
  803210:	39 ce                	cmp    %ecx,%esi
  803212:	72 0a                	jb     80321e <__udivdi3+0x6a>
  803214:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803218:	0f 87 9e 00 00 00    	ja     8032bc <__udivdi3+0x108>
  80321e:	b8 01 00 00 00       	mov    $0x1,%eax
  803223:	89 fa                	mov    %edi,%edx
  803225:	83 c4 1c             	add    $0x1c,%esp
  803228:	5b                   	pop    %ebx
  803229:	5e                   	pop    %esi
  80322a:	5f                   	pop    %edi
  80322b:	5d                   	pop    %ebp
  80322c:	c3                   	ret    
  80322d:	8d 76 00             	lea    0x0(%esi),%esi
  803230:	31 ff                	xor    %edi,%edi
  803232:	31 c0                	xor    %eax,%eax
  803234:	89 fa                	mov    %edi,%edx
  803236:	83 c4 1c             	add    $0x1c,%esp
  803239:	5b                   	pop    %ebx
  80323a:	5e                   	pop    %esi
  80323b:	5f                   	pop    %edi
  80323c:	5d                   	pop    %ebp
  80323d:	c3                   	ret    
  80323e:	66 90                	xchg   %ax,%ax
  803240:	89 d8                	mov    %ebx,%eax
  803242:	f7 f7                	div    %edi
  803244:	31 ff                	xor    %edi,%edi
  803246:	89 fa                	mov    %edi,%edx
  803248:	83 c4 1c             	add    $0x1c,%esp
  80324b:	5b                   	pop    %ebx
  80324c:	5e                   	pop    %esi
  80324d:	5f                   	pop    %edi
  80324e:	5d                   	pop    %ebp
  80324f:	c3                   	ret    
  803250:	bd 20 00 00 00       	mov    $0x20,%ebp
  803255:	89 eb                	mov    %ebp,%ebx
  803257:	29 fb                	sub    %edi,%ebx
  803259:	89 f9                	mov    %edi,%ecx
  80325b:	d3 e6                	shl    %cl,%esi
  80325d:	89 c5                	mov    %eax,%ebp
  80325f:	88 d9                	mov    %bl,%cl
  803261:	d3 ed                	shr    %cl,%ebp
  803263:	89 e9                	mov    %ebp,%ecx
  803265:	09 f1                	or     %esi,%ecx
  803267:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80326b:	89 f9                	mov    %edi,%ecx
  80326d:	d3 e0                	shl    %cl,%eax
  80326f:	89 c5                	mov    %eax,%ebp
  803271:	89 d6                	mov    %edx,%esi
  803273:	88 d9                	mov    %bl,%cl
  803275:	d3 ee                	shr    %cl,%esi
  803277:	89 f9                	mov    %edi,%ecx
  803279:	d3 e2                	shl    %cl,%edx
  80327b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80327f:	88 d9                	mov    %bl,%cl
  803281:	d3 e8                	shr    %cl,%eax
  803283:	09 c2                	or     %eax,%edx
  803285:	89 d0                	mov    %edx,%eax
  803287:	89 f2                	mov    %esi,%edx
  803289:	f7 74 24 0c          	divl   0xc(%esp)
  80328d:	89 d6                	mov    %edx,%esi
  80328f:	89 c3                	mov    %eax,%ebx
  803291:	f7 e5                	mul    %ebp
  803293:	39 d6                	cmp    %edx,%esi
  803295:	72 19                	jb     8032b0 <__udivdi3+0xfc>
  803297:	74 0b                	je     8032a4 <__udivdi3+0xf0>
  803299:	89 d8                	mov    %ebx,%eax
  80329b:	31 ff                	xor    %edi,%edi
  80329d:	e9 58 ff ff ff       	jmp    8031fa <__udivdi3+0x46>
  8032a2:	66 90                	xchg   %ax,%ax
  8032a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032a8:	89 f9                	mov    %edi,%ecx
  8032aa:	d3 e2                	shl    %cl,%edx
  8032ac:	39 c2                	cmp    %eax,%edx
  8032ae:	73 e9                	jae    803299 <__udivdi3+0xe5>
  8032b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032b3:	31 ff                	xor    %edi,%edi
  8032b5:	e9 40 ff ff ff       	jmp    8031fa <__udivdi3+0x46>
  8032ba:	66 90                	xchg   %ax,%ax
  8032bc:	31 c0                	xor    %eax,%eax
  8032be:	e9 37 ff ff ff       	jmp    8031fa <__udivdi3+0x46>
  8032c3:	90                   	nop

008032c4 <__umoddi3>:
  8032c4:	55                   	push   %ebp
  8032c5:	57                   	push   %edi
  8032c6:	56                   	push   %esi
  8032c7:	53                   	push   %ebx
  8032c8:	83 ec 1c             	sub    $0x1c,%esp
  8032cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032e3:	89 f3                	mov    %esi,%ebx
  8032e5:	89 fa                	mov    %edi,%edx
  8032e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032eb:	89 34 24             	mov    %esi,(%esp)
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	75 1a                	jne    80330c <__umoddi3+0x48>
  8032f2:	39 f7                	cmp    %esi,%edi
  8032f4:	0f 86 a2 00 00 00    	jbe    80339c <__umoddi3+0xd8>
  8032fa:	89 c8                	mov    %ecx,%eax
  8032fc:	89 f2                	mov    %esi,%edx
  8032fe:	f7 f7                	div    %edi
  803300:	89 d0                	mov    %edx,%eax
  803302:	31 d2                	xor    %edx,%edx
  803304:	83 c4 1c             	add    $0x1c,%esp
  803307:	5b                   	pop    %ebx
  803308:	5e                   	pop    %esi
  803309:	5f                   	pop    %edi
  80330a:	5d                   	pop    %ebp
  80330b:	c3                   	ret    
  80330c:	39 f0                	cmp    %esi,%eax
  80330e:	0f 87 ac 00 00 00    	ja     8033c0 <__umoddi3+0xfc>
  803314:	0f bd e8             	bsr    %eax,%ebp
  803317:	83 f5 1f             	xor    $0x1f,%ebp
  80331a:	0f 84 ac 00 00 00    	je     8033cc <__umoddi3+0x108>
  803320:	bf 20 00 00 00       	mov    $0x20,%edi
  803325:	29 ef                	sub    %ebp,%edi
  803327:	89 fe                	mov    %edi,%esi
  803329:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80332d:	89 e9                	mov    %ebp,%ecx
  80332f:	d3 e0                	shl    %cl,%eax
  803331:	89 d7                	mov    %edx,%edi
  803333:	89 f1                	mov    %esi,%ecx
  803335:	d3 ef                	shr    %cl,%edi
  803337:	09 c7                	or     %eax,%edi
  803339:	89 e9                	mov    %ebp,%ecx
  80333b:	d3 e2                	shl    %cl,%edx
  80333d:	89 14 24             	mov    %edx,(%esp)
  803340:	89 d8                	mov    %ebx,%eax
  803342:	d3 e0                	shl    %cl,%eax
  803344:	89 c2                	mov    %eax,%edx
  803346:	8b 44 24 08          	mov    0x8(%esp),%eax
  80334a:	d3 e0                	shl    %cl,%eax
  80334c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803350:	8b 44 24 08          	mov    0x8(%esp),%eax
  803354:	89 f1                	mov    %esi,%ecx
  803356:	d3 e8                	shr    %cl,%eax
  803358:	09 d0                	or     %edx,%eax
  80335a:	d3 eb                	shr    %cl,%ebx
  80335c:	89 da                	mov    %ebx,%edx
  80335e:	f7 f7                	div    %edi
  803360:	89 d3                	mov    %edx,%ebx
  803362:	f7 24 24             	mull   (%esp)
  803365:	89 c6                	mov    %eax,%esi
  803367:	89 d1                	mov    %edx,%ecx
  803369:	39 d3                	cmp    %edx,%ebx
  80336b:	0f 82 87 00 00 00    	jb     8033f8 <__umoddi3+0x134>
  803371:	0f 84 91 00 00 00    	je     803408 <__umoddi3+0x144>
  803377:	8b 54 24 04          	mov    0x4(%esp),%edx
  80337b:	29 f2                	sub    %esi,%edx
  80337d:	19 cb                	sbb    %ecx,%ebx
  80337f:	89 d8                	mov    %ebx,%eax
  803381:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803385:	d3 e0                	shl    %cl,%eax
  803387:	89 e9                	mov    %ebp,%ecx
  803389:	d3 ea                	shr    %cl,%edx
  80338b:	09 d0                	or     %edx,%eax
  80338d:	89 e9                	mov    %ebp,%ecx
  80338f:	d3 eb                	shr    %cl,%ebx
  803391:	89 da                	mov    %ebx,%edx
  803393:	83 c4 1c             	add    $0x1c,%esp
  803396:	5b                   	pop    %ebx
  803397:	5e                   	pop    %esi
  803398:	5f                   	pop    %edi
  803399:	5d                   	pop    %ebp
  80339a:	c3                   	ret    
  80339b:	90                   	nop
  80339c:	89 fd                	mov    %edi,%ebp
  80339e:	85 ff                	test   %edi,%edi
  8033a0:	75 0b                	jne    8033ad <__umoddi3+0xe9>
  8033a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8033a7:	31 d2                	xor    %edx,%edx
  8033a9:	f7 f7                	div    %edi
  8033ab:	89 c5                	mov    %eax,%ebp
  8033ad:	89 f0                	mov    %esi,%eax
  8033af:	31 d2                	xor    %edx,%edx
  8033b1:	f7 f5                	div    %ebp
  8033b3:	89 c8                	mov    %ecx,%eax
  8033b5:	f7 f5                	div    %ebp
  8033b7:	89 d0                	mov    %edx,%eax
  8033b9:	e9 44 ff ff ff       	jmp    803302 <__umoddi3+0x3e>
  8033be:	66 90                	xchg   %ax,%ax
  8033c0:	89 c8                	mov    %ecx,%eax
  8033c2:	89 f2                	mov    %esi,%edx
  8033c4:	83 c4 1c             	add    $0x1c,%esp
  8033c7:	5b                   	pop    %ebx
  8033c8:	5e                   	pop    %esi
  8033c9:	5f                   	pop    %edi
  8033ca:	5d                   	pop    %ebp
  8033cb:	c3                   	ret    
  8033cc:	3b 04 24             	cmp    (%esp),%eax
  8033cf:	72 06                	jb     8033d7 <__umoddi3+0x113>
  8033d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033d5:	77 0f                	ja     8033e6 <__umoddi3+0x122>
  8033d7:	89 f2                	mov    %esi,%edx
  8033d9:	29 f9                	sub    %edi,%ecx
  8033db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033df:	89 14 24             	mov    %edx,(%esp)
  8033e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033ea:	8b 14 24             	mov    (%esp),%edx
  8033ed:	83 c4 1c             	add    $0x1c,%esp
  8033f0:	5b                   	pop    %ebx
  8033f1:	5e                   	pop    %esi
  8033f2:	5f                   	pop    %edi
  8033f3:	5d                   	pop    %ebp
  8033f4:	c3                   	ret    
  8033f5:	8d 76 00             	lea    0x0(%esi),%esi
  8033f8:	2b 04 24             	sub    (%esp),%eax
  8033fb:	19 fa                	sbb    %edi,%edx
  8033fd:	89 d1                	mov    %edx,%ecx
  8033ff:	89 c6                	mov    %eax,%esi
  803401:	e9 71 ff ff ff       	jmp    803377 <__umoddi3+0xb3>
  803406:	66 90                	xchg   %ax,%ax
  803408:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80340c:	72 ea                	jb     8033f8 <__umoddi3+0x134>
  80340e:	89 d9                	mov    %ebx,%ecx
  803410:	e9 62 ff ff ff       	jmp    803377 <__umoddi3+0xb3>
