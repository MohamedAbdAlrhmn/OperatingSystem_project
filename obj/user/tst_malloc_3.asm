
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
  800031:	e8 40 0e 00 00       	call   800e76 <libmain>
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
  800091:	68 00 2a 80 00       	push   $0x802a00
  800096:	6a 1a                	push   $0x1a
  800098:	68 1c 2a 80 00       	push   $0x802a1c
  80009d:	e8 10 0f 00 00       	call   800fb2 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	6a 00                	push   $0x0
  8000a7:	e8 5e 1f 00 00       	call   80200a <malloc>
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
  8000df:	e8 35 21 00 00       	call   802219 <sys_calculate_free_frames>
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
  8000fb:	e8 b9 21 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  800100:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 f6 1e 00 00       	call   80200a <malloc>
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
  800137:	68 30 2a 80 00       	push   $0x802a30
  80013c:	6a 39                	push   $0x39
  80013e:	68 1c 2a 80 00       	push   $0x802a1c
  800143:	e8 6a 0e 00 00       	call   800fb2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 6c 21 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  80014d:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800150:	3d 00 02 00 00       	cmp    $0x200,%eax
  800155:	74 14                	je     80016b <_main+0x133>
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	68 98 2a 80 00       	push   $0x802a98
  80015f:	6a 3a                	push   $0x3a
  800161:	68 1c 2a 80 00       	push   $0x802a1c
  800166:	e8 47 0e 00 00       	call   800fb2 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  80016b:	e8 a9 20 00 00       	call   802219 <sys_calculate_free_frames>
  800170:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800176:	01 c0                	add    %eax,%eax
  800178:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80017b:	48                   	dec    %eax
  80017c:	89 45 c0             	mov    %eax,-0x40(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017f:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800185:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr[0] = minByte ;
  800188:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80018b:	8a 55 df             	mov    -0x21(%ebp),%dl
  80018e:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800190:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800193:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800196:	01 c2                	add    %eax,%edx
  800198:	8a 45 de             	mov    -0x22(%ebp),%al
  80019b:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80019d:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8001a0:	e8 74 20 00 00       	call   802219 <sys_calculate_free_frames>
  8001a5:	29 c3                	sub    %eax,%ebx
  8001a7:	89 d8                	mov    %ebx,%eax
  8001a9:	83 f8 03             	cmp    $0x3,%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 c8 2a 80 00       	push   $0x802ac8
  8001b6:	6a 41                	push   $0x41
  8001b8:	68 1c 2a 80 00       	push   $0x802a1c
  8001bd:	e8 f0 0d 00 00       	call   800fb2 <_panic>
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
  8001f0:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001f3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001fb:	89 c2                	mov    %eax,%edx
  8001fd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800200:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800203:	8b 45 b4             	mov    -0x4c(%ebp),%eax
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
  80022d:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800230:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800233:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800238:	89 c1                	mov    %eax,%ecx
  80023a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80023d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800240:	01 d0                	add    %edx,%eax
  800242:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800245:	8b 45 ac             	mov    -0x54(%ebp),%eax
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
  800273:	68 0c 2b 80 00       	push   $0x802b0c
  800278:	6a 4b                	push   $0x4b
  80027a:	68 1c 2a 80 00       	push   $0x802a1c
  80027f:	e8 2e 0d 00 00       	call   800fb2 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800284:	e8 30 20 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  800289:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80028c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028f:	01 c0                	add    %eax,%eax
  800291:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	50                   	push   %eax
  800298:	e8 6d 1d 00 00       	call   80200a <malloc>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a6:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002ac:	89 c2                	mov    %eax,%edx
  8002ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b1:	01 c0                	add    %eax,%eax
  8002b3:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b8:	39 c2                	cmp    %eax,%edx
  8002ba:	72 16                	jb     8002d2 <_main+0x29a>
  8002bc:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002c2:	89 c2                	mov    %eax,%edx
  8002c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002c7:	01 c0                	add    %eax,%eax
  8002c9:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002ce:	39 c2                	cmp    %eax,%edx
  8002d0:	76 14                	jbe    8002e6 <_main+0x2ae>
  8002d2:	83 ec 04             	sub    $0x4,%esp
  8002d5:	68 30 2a 80 00       	push   $0x802a30
  8002da:	6a 50                	push   $0x50
  8002dc:	68 1c 2a 80 00       	push   $0x802a1c
  8002e1:	e8 cc 0c 00 00       	call   800fb2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8002e6:	e8 ce 1f 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  8002eb:	2b 45 c8             	sub    -0x38(%ebp),%eax
  8002ee:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002f3:	74 14                	je     800309 <_main+0x2d1>
  8002f5:	83 ec 04             	sub    $0x4,%esp
  8002f8:	68 98 2a 80 00       	push   $0x802a98
  8002fd:	6a 51                	push   $0x51
  8002ff:	68 1c 2a 80 00       	push   $0x802a1c
  800304:	e8 a9 0c 00 00       	call   800fb2 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800309:	e8 0b 1f 00 00       	call   802219 <sys_calculate_free_frames>
  80030e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800311:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800317:	89 45 a8             	mov    %eax,-0x58(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	01 c0                	add    %eax,%eax
  80031f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800322:	d1 e8                	shr    %eax
  800324:	48                   	dec    %eax
  800325:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		shortArr[0] = minShort;
  800328:	8b 55 a8             	mov    -0x58(%ebp),%edx
  80032b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80032e:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800331:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800334:	01 c0                	add    %eax,%eax
  800336:	89 c2                	mov    %eax,%edx
  800338:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80033b:	01 c2                	add    %eax,%edx
  80033d:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800341:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800344:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800347:	e8 cd 1e 00 00       	call   802219 <sys_calculate_free_frames>
  80034c:	29 c3                	sub    %eax,%ebx
  80034e:	89 d8                	mov    %ebx,%eax
  800350:	83 f8 02             	cmp    $0x2,%eax
  800353:	74 14                	je     800369 <_main+0x331>
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	68 c8 2a 80 00       	push   $0x802ac8
  80035d:	6a 58                	push   $0x58
  80035f:	68 1c 2a 80 00       	push   $0x802a1c
  800364:	e8 49 0c 00 00       	call   800fb2 <_panic>
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
  800397:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80039a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80039d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a2:	89 c2                	mov    %eax,%edx
  8003a4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003a7:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8003aa:	8b 45 9c             	mov    -0x64(%ebp),%eax
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
  8003d4:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003d7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003e4:	01 c0                	add    %eax,%eax
  8003e6:	89 c1                	mov    %eax,%ecx
  8003e8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003eb:	01 c8                	add    %ecx,%eax
  8003ed:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003f0:	8b 45 94             	mov    -0x6c(%ebp),%eax
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
  80041e:	68 0c 2b 80 00       	push   $0x802b0c
  800423:	6a 61                	push   $0x61
  800425:	68 1c 2a 80 00       	push   $0x802a1c
  80042a:	e8 83 0b 00 00       	call   800fb2 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042f:	e8 85 1e 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  800434:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800437:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043a:	89 c2                	mov    %eax,%edx
  80043c:	01 d2                	add    %edx,%edx
  80043e:	01 d0                	add    %edx,%eax
  800440:	83 ec 0c             	sub    $0xc,%esp
  800443:	50                   	push   %eax
  800444:	e8 c1 1b 00 00       	call   80200a <malloc>
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800452:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800458:	89 c2                	mov    %eax,%edx
  80045a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80045d:	c1 e0 02             	shl    $0x2,%eax
  800460:	05 00 00 00 80       	add    $0x80000000,%eax
  800465:	39 c2                	cmp    %eax,%edx
  800467:	72 17                	jb     800480 <_main+0x448>
  800469:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80046f:	89 c2                	mov    %eax,%edx
  800471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800474:	c1 e0 02             	shl    $0x2,%eax
  800477:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80047c:	39 c2                	cmp    %eax,%edx
  80047e:	76 14                	jbe    800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 30 2a 80 00       	push   $0x802a30
  800488:	6a 66                	push   $0x66
  80048a:	68 1c 2a 80 00       	push   $0x802a1c
  80048f:	e8 1e 0b 00 00       	call   800fb2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800494:	e8 20 1e 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  800499:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80049c:	83 f8 01             	cmp    $0x1,%eax
  80049f:	74 14                	je     8004b5 <_main+0x47d>
  8004a1:	83 ec 04             	sub    $0x4,%esp
  8004a4:	68 98 2a 80 00       	push   $0x802a98
  8004a9:	6a 67                	push   $0x67
  8004ab:	68 1c 2a 80 00       	push   $0x802a1c
  8004b0:	e8 fd 0a 00 00       	call   800fb2 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004b5:	e8 5f 1d 00 00       	call   802219 <sys_calculate_free_frames>
  8004ba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004bd:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8004c3:	89 45 90             	mov    %eax,-0x70(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c9:	01 c0                	add    %eax,%eax
  8004cb:	c1 e8 02             	shr    $0x2,%eax
  8004ce:	48                   	dec    %eax
  8004cf:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr[0] = minInt;
  8004d2:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004d8:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004da:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004e4:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004e7:	01 c2                	add    %eax,%edx
  8004e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004ec:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004ee:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8004f1:	e8 23 1d 00 00       	call   802219 <sys_calculate_free_frames>
  8004f6:	29 c3                	sub    %eax,%ebx
  8004f8:	89 d8                	mov    %ebx,%eax
  8004fa:	83 f8 02             	cmp    $0x2,%eax
  8004fd:	74 14                	je     800513 <_main+0x4db>
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	68 c8 2a 80 00       	push   $0x802ac8
  800507:	6a 6e                	push   $0x6e
  800509:	68 1c 2a 80 00       	push   $0x802a1c
  80050e:	e8 9f 0a 00 00       	call   800fb2 <_panic>
		found = 0;
  800513:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80051a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800521:	e9 8f 00 00 00       	jmp    8005b5 <_main+0x57d>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800526:	a1 20 40 80 00       	mov    0x804020,%eax
  80052b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800531:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800534:	89 d0                	mov    %edx,%eax
  800536:	01 c0                	add    %eax,%eax
  800538:	01 d0                	add    %edx,%eax
  80053a:	c1 e0 03             	shl    $0x3,%eax
  80053d:	01 c8                	add    %ecx,%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	89 45 88             	mov    %eax,-0x78(%ebp)
  800544:	8b 45 88             	mov    -0x78(%ebp),%eax
  800547:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054c:	89 c2                	mov    %eax,%edx
  80054e:	8b 45 90             	mov    -0x70(%ebp),%eax
  800551:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800554:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800557:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80055c:	39 c2                	cmp    %eax,%edx
  80055e:	75 03                	jne    800563 <_main+0x52b>
				found++;
  800560:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800563:	a1 20 40 80 00       	mov    0x804020,%eax
  800568:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80056e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800571:	89 d0                	mov    %edx,%eax
  800573:	01 c0                	add    %eax,%eax
  800575:	01 d0                	add    %edx,%eax
  800577:	c1 e0 03             	shl    $0x3,%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	8b 00                	mov    (%eax),%eax
  80057e:	89 45 80             	mov    %eax,-0x80(%ebp)
  800581:	8b 45 80             	mov    -0x80(%ebp),%eax
  800584:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800589:	89 c2                	mov    %eax,%edx
  80058b:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80058e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800595:	8b 45 90             	mov    -0x70(%ebp),%eax
  800598:	01 c8                	add    %ecx,%eax
  80059a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  8005a0:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ab:	39 c2                	cmp    %eax,%edx
  8005ad:	75 03                	jne    8005b2 <_main+0x57a>
				found++;
  8005af:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005b2:	ff 45 ec             	incl   -0x14(%ebp)
  8005b5:	a1 20 40 80 00       	mov    0x804020,%eax
  8005ba:	8b 50 74             	mov    0x74(%eax),%edx
  8005bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005c0:	39 c2                	cmp    %eax,%edx
  8005c2:	0f 87 5e ff ff ff    	ja     800526 <_main+0x4ee>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005c8:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005cc:	74 14                	je     8005e2 <_main+0x5aa>
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	68 0c 2b 80 00       	push   $0x802b0c
  8005d6:	6a 77                	push   $0x77
  8005d8:	68 1c 2a 80 00       	push   $0x802a1c
  8005dd:	e8 d0 09 00 00       	call   800fb2 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005e2:	e8 32 1c 00 00       	call   802219 <sys_calculate_free_frames>
  8005e7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005ea:	e8 ca 1c 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  8005ef:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8005f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f5:	89 c2                	mov    %eax,%edx
  8005f7:	01 d2                	add    %edx,%edx
  8005f9:	01 d0                	add    %edx,%eax
  8005fb:	83 ec 0c             	sub    $0xc,%esp
  8005fe:	50                   	push   %eax
  8005ff:	e8 06 1a 00 00       	call   80200a <malloc>
  800604:	83 c4 10             	add    $0x10,%esp
  800607:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80060d:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800613:	89 c2                	mov    %eax,%edx
  800615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800618:	c1 e0 02             	shl    $0x2,%eax
  80061b:	89 c1                	mov    %eax,%ecx
  80061d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800620:	c1 e0 02             	shl    $0x2,%eax
  800623:	01 c8                	add    %ecx,%eax
  800625:	05 00 00 00 80       	add    $0x80000000,%eax
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	72 21                	jb     80064f <_main+0x617>
  80062e:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800634:	89 c2                	mov    %eax,%edx
  800636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800639:	c1 e0 02             	shl    $0x2,%eax
  80063c:	89 c1                	mov    %eax,%ecx
  80063e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800641:	c1 e0 02             	shl    $0x2,%eax
  800644:	01 c8                	add    %ecx,%eax
  800646:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80064b:	39 c2                	cmp    %eax,%edx
  80064d:	76 14                	jbe    800663 <_main+0x62b>
  80064f:	83 ec 04             	sub    $0x4,%esp
  800652:	68 30 2a 80 00       	push   $0x802a30
  800657:	6a 7d                	push   $0x7d
  800659:	68 1c 2a 80 00       	push   $0x802a1c
  80065e:	e8 4f 09 00 00       	call   800fb2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800663:	e8 51 1c 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  800668:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80066b:	83 f8 01             	cmp    $0x1,%eax
  80066e:	74 14                	je     800684 <_main+0x64c>
  800670:	83 ec 04             	sub    $0x4,%esp
  800673:	68 98 2a 80 00       	push   $0x802a98
  800678:	6a 7e                	push   $0x7e
  80067a:	68 1c 2a 80 00       	push   $0x802a1c
  80067f:	e8 2e 09 00 00       	call   800fb2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800684:	e8 30 1c 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  800689:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80068c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068f:	89 d0                	mov    %edx,%eax
  800691:	01 c0                	add    %eax,%eax
  800693:	01 d0                	add    %edx,%eax
  800695:	01 c0                	add    %eax,%eax
  800697:	01 d0                	add    %edx,%eax
  800699:	83 ec 0c             	sub    $0xc,%esp
  80069c:	50                   	push   %eax
  80069d:	e8 68 19 00 00       	call   80200a <malloc>
  8006a2:	83 c4 10             	add    $0x10,%esp
  8006a5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8006ab:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006b1:	89 c2                	mov    %eax,%edx
  8006b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006b6:	c1 e0 02             	shl    $0x2,%eax
  8006b9:	89 c1                	mov    %eax,%ecx
  8006bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006be:	c1 e0 03             	shl    $0x3,%eax
  8006c1:	01 c8                	add    %ecx,%eax
  8006c3:	05 00 00 00 80       	add    $0x80000000,%eax
  8006c8:	39 c2                	cmp    %eax,%edx
  8006ca:	72 21                	jb     8006ed <_main+0x6b5>
  8006cc:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006d2:	89 c2                	mov    %eax,%edx
  8006d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d7:	c1 e0 02             	shl    $0x2,%eax
  8006da:	89 c1                	mov    %eax,%ecx
  8006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006df:	c1 e0 03             	shl    $0x3,%eax
  8006e2:	01 c8                	add    %ecx,%eax
  8006e4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006e9:	39 c2                	cmp    %eax,%edx
  8006eb:	76 17                	jbe    800704 <_main+0x6cc>
  8006ed:	83 ec 04             	sub    $0x4,%esp
  8006f0:	68 30 2a 80 00       	push   $0x802a30
  8006f5:	68 84 00 00 00       	push   $0x84
  8006fa:	68 1c 2a 80 00       	push   $0x802a1c
  8006ff:	e8 ae 08 00 00       	call   800fb2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800704:	e8 b0 1b 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  800709:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80070c:	83 f8 02             	cmp    $0x2,%eax
  80070f:	74 17                	je     800728 <_main+0x6f0>
  800711:	83 ec 04             	sub    $0x4,%esp
  800714:	68 98 2a 80 00       	push   $0x802a98
  800719:	68 85 00 00 00       	push   $0x85
  80071e:	68 1c 2a 80 00       	push   $0x802a1c
  800723:	e8 8a 08 00 00       	call   800fb2 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800728:	e8 ec 1a 00 00       	call   802219 <sys_calculate_free_frames>
  80072d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  800730:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  800736:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  80073c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80073f:	89 d0                	mov    %edx,%eax
  800741:	01 c0                	add    %eax,%eax
  800743:	01 d0                	add    %edx,%eax
  800745:	01 c0                	add    %eax,%eax
  800747:	01 d0                	add    %edx,%eax
  800749:	c1 e8 03             	shr    $0x3,%eax
  80074c:	48                   	dec    %eax
  80074d:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800753:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800759:	8a 55 df             	mov    -0x21(%ebp),%dl
  80075c:	88 10                	mov    %dl,(%eax)
  80075e:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800764:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800767:	66 89 42 02          	mov    %ax,0x2(%edx)
  80076b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800771:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800774:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800777:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80077d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800784:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80078a:	01 c2                	add    %eax,%edx
  80078c:	8a 45 de             	mov    -0x22(%ebp),%al
  80078f:	88 02                	mov    %al,(%edx)
  800791:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800797:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80079e:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007a4:	01 c2                	add    %eax,%edx
  8007a6:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  8007aa:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007ae:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007b4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007bb:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007c1:	01 c2                	add    %eax,%edx
  8007c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007c6:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007c9:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8007cc:	e8 48 1a 00 00       	call   802219 <sys_calculate_free_frames>
  8007d1:	29 c3                	sub    %eax,%ebx
  8007d3:	89 d8                	mov    %ebx,%eax
  8007d5:	83 f8 02             	cmp    $0x2,%eax
  8007d8:	74 17                	je     8007f1 <_main+0x7b9>
  8007da:	83 ec 04             	sub    $0x4,%esp
  8007dd:	68 c8 2a 80 00       	push   $0x802ac8
  8007e2:	68 8c 00 00 00       	push   $0x8c
  8007e7:	68 1c 2a 80 00       	push   $0x802a1c
  8007ec:	e8 c1 07 00 00       	call   800fb2 <_panic>
		found = 0;
  8007f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007ff:	e9 aa 00 00 00       	jmp    8008ae <_main+0x876>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  800804:	a1 20 40 80 00       	mov    0x804020,%eax
  800809:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80080f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800812:	89 d0                	mov    %edx,%eax
  800814:	01 c0                	add    %eax,%eax
  800816:	01 d0                	add    %edx,%eax
  800818:	c1 e0 03             	shl    $0x3,%eax
  80081b:	01 c8                	add    %ecx,%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800825:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80082b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800830:	89 c2                	mov    %eax,%edx
  800832:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800838:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  80083e:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800844:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800849:	39 c2                	cmp    %eax,%edx
  80084b:	75 03                	jne    800850 <_main+0x818>
				found++;
  80084d:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  800850:	a1 20 40 80 00       	mov    0x804020,%eax
  800855:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80085b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80085e:	89 d0                	mov    %edx,%eax
  800860:	01 c0                	add    %eax,%eax
  800862:	01 d0                	add    %edx,%eax
  800864:	c1 e0 03             	shl    $0x3,%eax
  800867:	01 c8                	add    %ecx,%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800871:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800877:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087c:	89 c2                	mov    %eax,%edx
  80087e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800884:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80088b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800891:	01 c8                	add    %ecx,%eax
  800893:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800899:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80089f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	75 03                	jne    8008ab <_main+0x873>
				found++;
  8008a8:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8008ab:	ff 45 ec             	incl   -0x14(%ebp)
  8008ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8008b3:	8b 50 74             	mov    0x74(%eax),%edx
  8008b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b9:	39 c2                	cmp    %eax,%edx
  8008bb:	0f 87 43 ff ff ff    	ja     800804 <_main+0x7cc>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008c1:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008c5:	74 17                	je     8008de <_main+0x8a6>
  8008c7:	83 ec 04             	sub    $0x4,%esp
  8008ca:	68 0c 2b 80 00       	push   $0x802b0c
  8008cf:	68 95 00 00 00       	push   $0x95
  8008d4:	68 1c 2a 80 00       	push   $0x802a1c
  8008d9:	e8 d4 06 00 00       	call   800fb2 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008de:	e8 36 19 00 00       	call   802219 <sys_calculate_free_frames>
  8008e3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008e6:	e8 ce 19 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  8008eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008f1:	89 c2                	mov    %eax,%edx
  8008f3:	01 d2                	add    %edx,%edx
  8008f5:	01 d0                	add    %edx,%eax
  8008f7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008fa:	83 ec 0c             	sub    $0xc,%esp
  8008fd:	50                   	push   %eax
  8008fe:	e8 07 17 00 00       	call   80200a <malloc>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80090c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800912:	89 c2                	mov    %eax,%edx
  800914:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800917:	c1 e0 02             	shl    $0x2,%eax
  80091a:	89 c1                	mov    %eax,%ecx
  80091c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80091f:	c1 e0 04             	shl    $0x4,%eax
  800922:	01 c8                	add    %ecx,%eax
  800924:	05 00 00 00 80       	add    $0x80000000,%eax
  800929:	39 c2                	cmp    %eax,%edx
  80092b:	72 21                	jb     80094e <_main+0x916>
  80092d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800933:	89 c2                	mov    %eax,%edx
  800935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800938:	c1 e0 02             	shl    $0x2,%eax
  80093b:	89 c1                	mov    %eax,%ecx
  80093d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800940:	c1 e0 04             	shl    $0x4,%eax
  800943:	01 c8                	add    %ecx,%eax
  800945:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80094a:	39 c2                	cmp    %eax,%edx
  80094c:	76 17                	jbe    800965 <_main+0x92d>
  80094e:	83 ec 04             	sub    $0x4,%esp
  800951:	68 30 2a 80 00       	push   $0x802a30
  800956:	68 9b 00 00 00       	push   $0x9b
  80095b:	68 1c 2a 80 00       	push   $0x802a1c
  800960:	e8 4d 06 00 00       	call   800fb2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800965:	e8 4f 19 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  80096a:	2b 45 c8             	sub    -0x38(%ebp),%eax
  80096d:	89 c2                	mov    %eax,%edx
  80096f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800972:	89 c1                	mov    %eax,%ecx
  800974:	01 c9                	add    %ecx,%ecx
  800976:	01 c8                	add    %ecx,%eax
  800978:	85 c0                	test   %eax,%eax
  80097a:	79 05                	jns    800981 <_main+0x949>
  80097c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800981:	c1 f8 0c             	sar    $0xc,%eax
  800984:	39 c2                	cmp    %eax,%edx
  800986:	74 17                	je     80099f <_main+0x967>
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 98 2a 80 00       	push   $0x802a98
  800990:	68 9c 00 00 00       	push   $0x9c
  800995:	68 1c 2a 80 00       	push   $0x802a1c
  80099a:	e8 13 06 00 00       	call   800fb2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80099f:	e8 15 19 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  8009a4:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  8009a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009aa:	89 d0                	mov    %edx,%eax
  8009ac:	01 c0                	add    %eax,%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	01 c0                	add    %eax,%eax
  8009b2:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8009b5:	83 ec 0c             	sub    $0xc,%esp
  8009b8:	50                   	push   %eax
  8009b9:	e8 4c 16 00 00       	call   80200a <malloc>
  8009be:	83 c4 10             	add    $0x10,%esp
  8009c1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8009c7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009cd:	89 c1                	mov    %eax,%ecx
  8009cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009d2:	89 d0                	mov    %edx,%eax
  8009d4:	01 c0                	add    %eax,%eax
  8009d6:	01 d0                	add    %edx,%eax
  8009d8:	01 c0                	add    %eax,%eax
  8009da:	01 d0                	add    %edx,%eax
  8009dc:	89 c2                	mov    %eax,%edx
  8009de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e1:	c1 e0 04             	shl    $0x4,%eax
  8009e4:	01 d0                	add    %edx,%eax
  8009e6:	05 00 00 00 80       	add    $0x80000000,%eax
  8009eb:	39 c1                	cmp    %eax,%ecx
  8009ed:	72 28                	jb     800a17 <_main+0x9df>
  8009ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009f5:	89 c1                	mov    %eax,%ecx
  8009f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009fa:	89 d0                	mov    %edx,%eax
  8009fc:	01 c0                	add    %eax,%eax
  8009fe:	01 d0                	add    %edx,%eax
  800a00:	01 c0                	add    %eax,%eax
  800a02:	01 d0                	add    %edx,%eax
  800a04:	89 c2                	mov    %eax,%edx
  800a06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a09:	c1 e0 04             	shl    $0x4,%eax
  800a0c:	01 d0                	add    %edx,%eax
  800a0e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800a13:	39 c1                	cmp    %eax,%ecx
  800a15:	76 17                	jbe    800a2e <_main+0x9f6>
  800a17:	83 ec 04             	sub    $0x4,%esp
  800a1a:	68 30 2a 80 00       	push   $0x802a30
  800a1f:	68 a2 00 00 00       	push   $0xa2
  800a24:	68 1c 2a 80 00       	push   $0x802a1c
  800a29:	e8 84 05 00 00       	call   800fb2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800a2e:	e8 86 18 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  800a33:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800a36:	89 c1                	mov    %eax,%ecx
  800a38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a3b:	89 d0                	mov    %edx,%eax
  800a3d:	01 c0                	add    %eax,%eax
  800a3f:	01 d0                	add    %edx,%eax
  800a41:	01 c0                	add    %eax,%eax
  800a43:	85 c0                	test   %eax,%eax
  800a45:	79 05                	jns    800a4c <_main+0xa14>
  800a47:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a4c:	c1 f8 0c             	sar    $0xc,%eax
  800a4f:	39 c1                	cmp    %eax,%ecx
  800a51:	74 17                	je     800a6a <_main+0xa32>
  800a53:	83 ec 04             	sub    $0x4,%esp
  800a56:	68 98 2a 80 00       	push   $0x802a98
  800a5b:	68 a3 00 00 00       	push   $0xa3
  800a60:	68 1c 2a 80 00       	push   $0x802a1c
  800a65:	e8 48 05 00 00       	call   800fb2 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a6a:	e8 aa 17 00 00       	call   802219 <sys_calculate_free_frames>
  800a6f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a75:	89 d0                	mov    %edx,%eax
  800a77:	01 c0                	add    %eax,%eax
  800a79:	01 d0                	add    %edx,%eax
  800a7b:	01 c0                	add    %eax,%eax
  800a7d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a80:	48                   	dec    %eax
  800a81:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a87:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a8d:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2[0] = minByte ;
  800a93:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a99:	8a 55 df             	mov    -0x21(%ebp),%dl
  800a9c:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a9e:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800aa4:	89 c2                	mov    %eax,%edx
  800aa6:	c1 ea 1f             	shr    $0x1f,%edx
  800aa9:	01 d0                	add    %edx,%eax
  800aab:	d1 f8                	sar    %eax
  800aad:	89 c2                	mov    %eax,%edx
  800aaf:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800ab5:	01 c2                	add    %eax,%edx
  800ab7:	8a 45 de             	mov    -0x22(%ebp),%al
  800aba:	88 c1                	mov    %al,%cl
  800abc:	c0 e9 07             	shr    $0x7,%cl
  800abf:	01 c8                	add    %ecx,%eax
  800ac1:	d0 f8                	sar    %al
  800ac3:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800ac5:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800acb:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800ad1:	01 c2                	add    %eax,%edx
  800ad3:	8a 45 de             	mov    -0x22(%ebp),%al
  800ad6:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800ad8:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800adb:	e8 39 17 00 00       	call   802219 <sys_calculate_free_frames>
  800ae0:	29 c3                	sub    %eax,%ebx
  800ae2:	89 d8                	mov    %ebx,%eax
  800ae4:	83 f8 05             	cmp    $0x5,%eax
  800ae7:	74 17                	je     800b00 <_main+0xac8>
  800ae9:	83 ec 04             	sub    $0x4,%esp
  800aec:	68 c8 2a 80 00       	push   $0x802ac8
  800af1:	68 ab 00 00 00       	push   $0xab
  800af6:	68 1c 2a 80 00       	push   $0x802a1c
  800afb:	e8 b2 04 00 00       	call   800fb2 <_panic>
		found = 0;
  800b00:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800b07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800b0e:	e9 02 01 00 00       	jmp    800c15 <_main+0xbdd>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800b13:	a1 20 40 80 00       	mov    0x804020,%eax
  800b18:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b21:	89 d0                	mov    %edx,%eax
  800b23:	01 c0                	add    %eax,%eax
  800b25:	01 d0                	add    %edx,%eax
  800b27:	c1 e0 03             	shl    $0x3,%eax
  800b2a:	01 c8                	add    %ecx,%eax
  800b2c:	8b 00                	mov    (%eax),%eax
  800b2e:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800b34:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b3f:	89 c2                	mov    %eax,%edx
  800b41:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b47:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b4d:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b58:	39 c2                	cmp    %eax,%edx
  800b5a:	75 03                	jne    800b5f <_main+0xb27>
				found++;
  800b5c:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b5f:	a1 20 40 80 00       	mov    0x804020,%eax
  800b64:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b6d:	89 d0                	mov    %edx,%eax
  800b6f:	01 c0                	add    %eax,%eax
  800b71:	01 d0                	add    %edx,%eax
  800b73:	c1 e0 03             	shl    $0x3,%eax
  800b76:	01 c8                	add    %ecx,%eax
  800b78:	8b 00                	mov    (%eax),%eax
  800b7a:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b80:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b8b:	89 c2                	mov    %eax,%edx
  800b8d:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b93:	89 c1                	mov    %eax,%ecx
  800b95:	c1 e9 1f             	shr    $0x1f,%ecx
  800b98:	01 c8                	add    %ecx,%eax
  800b9a:	d1 f8                	sar    %eax
  800b9c:	89 c1                	mov    %eax,%ecx
  800b9e:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800ba4:	01 c8                	add    %ecx,%eax
  800ba6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800bac:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800bb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bb7:	39 c2                	cmp    %eax,%edx
  800bb9:	75 03                	jne    800bbe <_main+0xb86>
				found++;
  800bbb:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800bbe:	a1 20 40 80 00       	mov    0x804020,%eax
  800bc3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bcc:	89 d0                	mov    %edx,%eax
  800bce:	01 c0                	add    %eax,%eax
  800bd0:	01 d0                	add    %edx,%eax
  800bd2:	c1 e0 03             	shl    $0x3,%eax
  800bd5:	01 c8                	add    %ecx,%eax
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800bdf:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800be5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bea:	89 c1                	mov    %eax,%ecx
  800bec:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800bf2:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800bf8:	01 d0                	add    %edx,%eax
  800bfa:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800c00:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800c06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c0b:	39 c1                	cmp    %eax,%ecx
  800c0d:	75 03                	jne    800c12 <_main+0xbda>
				found++;
  800c0f:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800c12:	ff 45 ec             	incl   -0x14(%ebp)
  800c15:	a1 20 40 80 00       	mov    0x804020,%eax
  800c1a:	8b 50 74             	mov    0x74(%eax),%edx
  800c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c20:	39 c2                	cmp    %eax,%edx
  800c22:	0f 87 eb fe ff ff    	ja     800b13 <_main+0xadb>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800c28:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800c2c:	74 17                	je     800c45 <_main+0xc0d>
  800c2e:	83 ec 04             	sub    $0x4,%esp
  800c31:	68 0c 2b 80 00       	push   $0x802b0c
  800c36:	68 b6 00 00 00       	push   $0xb6
  800c3b:	68 1c 2a 80 00       	push   $0x802a1c
  800c40:	e8 6d 03 00 00       	call   800fb2 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c45:	e8 6f 16 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  800c4a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c50:	89 d0                	mov    %edx,%eax
  800c52:	01 c0                	add    %eax,%eax
  800c54:	01 d0                	add    %edx,%eax
  800c56:	01 c0                	add    %eax,%eax
  800c58:	01 d0                	add    %edx,%eax
  800c5a:	01 c0                	add    %eax,%eax
  800c5c:	83 ec 0c             	sub    $0xc,%esp
  800c5f:	50                   	push   %eax
  800c60:	e8 a5 13 00 00       	call   80200a <malloc>
  800c65:	83 c4 10             	add    $0x10,%esp
  800c68:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c6e:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c74:	89 c1                	mov    %eax,%ecx
  800c76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c79:	89 d0                	mov    %edx,%eax
  800c7b:	01 c0                	add    %eax,%eax
  800c7d:	01 d0                	add    %edx,%eax
  800c7f:	c1 e0 02             	shl    $0x2,%eax
  800c82:	01 d0                	add    %edx,%eax
  800c84:	89 c2                	mov    %eax,%edx
  800c86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c89:	c1 e0 04             	shl    $0x4,%eax
  800c8c:	01 d0                	add    %edx,%eax
  800c8e:	05 00 00 00 80       	add    $0x80000000,%eax
  800c93:	39 c1                	cmp    %eax,%ecx
  800c95:	72 29                	jb     800cc0 <_main+0xc88>
  800c97:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c9d:	89 c1                	mov    %eax,%ecx
  800c9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ca2:	89 d0                	mov    %edx,%eax
  800ca4:	01 c0                	add    %eax,%eax
  800ca6:	01 d0                	add    %edx,%eax
  800ca8:	c1 e0 02             	shl    $0x2,%eax
  800cab:	01 d0                	add    %edx,%eax
  800cad:	89 c2                	mov    %eax,%edx
  800caf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cb2:	c1 e0 04             	shl    $0x4,%eax
  800cb5:	01 d0                	add    %edx,%eax
  800cb7:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800cbc:	39 c1                	cmp    %eax,%ecx
  800cbe:	76 17                	jbe    800cd7 <_main+0xc9f>
  800cc0:	83 ec 04             	sub    $0x4,%esp
  800cc3:	68 30 2a 80 00       	push   $0x802a30
  800cc8:	68 bb 00 00 00       	push   $0xbb
  800ccd:	68 1c 2a 80 00       	push   $0x802a1c
  800cd2:	e8 db 02 00 00       	call   800fb2 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  800cd7:	e8 dd 15 00 00       	call   8022b9 <sys_pf_calculate_allocated_pages>
  800cdc:	2b 45 c8             	sub    -0x38(%ebp),%eax
  800cdf:	83 f8 04             	cmp    $0x4,%eax
  800ce2:	74 17                	je     800cfb <_main+0xcc3>
  800ce4:	83 ec 04             	sub    $0x4,%esp
  800ce7:	68 98 2a 80 00       	push   $0x802a98
  800cec:	68 bc 00 00 00       	push   $0xbc
  800cf1:	68 1c 2a 80 00       	push   $0x802a1c
  800cf6:	e8 b7 02 00 00       	call   800fb2 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cfb:	e8 19 15 00 00       	call   802219 <sys_calculate_free_frames>
  800d00:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800d03:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800d09:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800d0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d12:	89 d0                	mov    %edx,%eax
  800d14:	01 c0                	add    %eax,%eax
  800d16:	01 d0                	add    %edx,%eax
  800d18:	01 c0                	add    %eax,%eax
  800d1a:	01 d0                	add    %edx,%eax
  800d1c:	01 c0                	add    %eax,%eax
  800d1e:	d1 e8                	shr    %eax
  800d20:	48                   	dec    %eax
  800d21:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		shortArr2[0] = minShort;
  800d27:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800d2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d30:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800d33:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d39:	01 c0                	add    %eax,%eax
  800d3b:	89 c2                	mov    %eax,%edx
  800d3d:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d43:	01 c2                	add    %eax,%edx
  800d45:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800d49:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d4c:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800d4f:	e8 c5 14 00 00       	call   802219 <sys_calculate_free_frames>
  800d54:	29 c3                	sub    %eax,%ebx
  800d56:	89 d8                	mov    %ebx,%eax
  800d58:	83 f8 02             	cmp    $0x2,%eax
  800d5b:	74 17                	je     800d74 <_main+0xd3c>
  800d5d:	83 ec 04             	sub    $0x4,%esp
  800d60:	68 c8 2a 80 00       	push   $0x802ac8
  800d65:	68 c3 00 00 00       	push   $0xc3
  800d6a:	68 1c 2a 80 00       	push   $0x802a1c
  800d6f:	e8 3e 02 00 00       	call   800fb2 <_panic>
		found = 0;
  800d74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d7b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d82:	e9 a7 00 00 00       	jmp    800e2e <_main+0xdf6>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d87:	a1 20 40 80 00       	mov    0x804020,%eax
  800d8c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d95:	89 d0                	mov    %edx,%eax
  800d97:	01 c0                	add    %eax,%eax
  800d99:	01 d0                	add    %edx,%eax
  800d9b:	c1 e0 03             	shl    $0x3,%eax
  800d9e:	01 c8                	add    %ecx,%eax
  800da0:	8b 00                	mov    (%eax),%eax
  800da2:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800da8:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800dae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db3:	89 c2                	mov    %eax,%edx
  800db5:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800dbb:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800dc1:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800dc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dcc:	39 c2                	cmp    %eax,%edx
  800dce:	75 03                	jne    800dd3 <_main+0xd9b>
				found++;
  800dd0:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800dd3:	a1 20 40 80 00       	mov    0x804020,%eax
  800dd8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800dde:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800de1:	89 d0                	mov    %edx,%eax
  800de3:	01 c0                	add    %eax,%eax
  800de5:	01 d0                	add    %edx,%eax
  800de7:	c1 e0 03             	shl    $0x3,%eax
  800dea:	01 c8                	add    %ecx,%eax
  800dec:	8b 00                	mov    (%eax),%eax
  800dee:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800df4:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800dfa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dff:	89 c2                	mov    %eax,%edx
  800e01:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800e07:	01 c0                	add    %eax,%eax
  800e09:	89 c1                	mov    %eax,%ecx
  800e0b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800e11:	01 c8                	add    %ecx,%eax
  800e13:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800e19:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800e1f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e24:	39 c2                	cmp    %eax,%edx
  800e26:	75 03                	jne    800e2b <_main+0xdf3>
				found++;
  800e28:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800e2b:	ff 45 ec             	incl   -0x14(%ebp)
  800e2e:	a1 20 40 80 00       	mov    0x804020,%eax
  800e33:	8b 50 74             	mov    0x74(%eax),%edx
  800e36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e39:	39 c2                	cmp    %eax,%edx
  800e3b:	0f 87 46 ff ff ff    	ja     800d87 <_main+0xd4f>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800e41:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800e45:	74 17                	je     800e5e <_main+0xe26>
  800e47:	83 ec 04             	sub    $0x4,%esp
  800e4a:	68 0c 2b 80 00       	push   $0x802b0c
  800e4f:	68 cc 00 00 00       	push   $0xcc
  800e54:	68 1c 2a 80 00       	push   $0x802a1c
  800e59:	e8 54 01 00 00       	call   800fb2 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e5e:	83 ec 0c             	sub    $0xc,%esp
  800e61:	68 2c 2b 80 00       	push   $0x802b2c
  800e66:	e8 fb 03 00 00       	call   801266 <cprintf>
  800e6b:	83 c4 10             	add    $0x10,%esp

	return;
  800e6e:	90                   	nop
}
  800e6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e72:	5b                   	pop    %ebx
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800e7c:	e8 78 16 00 00       	call   8024f9 <sys_getenvindex>
  800e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e87:	89 d0                	mov    %edx,%eax
  800e89:	c1 e0 03             	shl    $0x3,%eax
  800e8c:	01 d0                	add    %edx,%eax
  800e8e:	01 c0                	add    %eax,%eax
  800e90:	01 d0                	add    %edx,%eax
  800e92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e99:	01 d0                	add    %edx,%eax
  800e9b:	c1 e0 04             	shl    $0x4,%eax
  800e9e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ea3:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ea8:	a1 20 40 80 00       	mov    0x804020,%eax
  800ead:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800eb3:	84 c0                	test   %al,%al
  800eb5:	74 0f                	je     800ec6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800eb7:	a1 20 40 80 00       	mov    0x804020,%eax
  800ebc:	05 5c 05 00 00       	add    $0x55c,%eax
  800ec1:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800ec6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800eca:	7e 0a                	jle    800ed6 <libmain+0x60>
		binaryname = argv[0];
  800ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecf:	8b 00                	mov    (%eax),%eax
  800ed1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800ed6:	83 ec 08             	sub    $0x8,%esp
  800ed9:	ff 75 0c             	pushl  0xc(%ebp)
  800edc:	ff 75 08             	pushl  0x8(%ebp)
  800edf:	e8 54 f1 ff ff       	call   800038 <_main>
  800ee4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800ee7:	e8 1a 14 00 00       	call   802306 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800eec:	83 ec 0c             	sub    $0xc,%esp
  800eef:	68 80 2b 80 00       	push   $0x802b80
  800ef4:	e8 6d 03 00 00       	call   801266 <cprintf>
  800ef9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800efc:	a1 20 40 80 00       	mov    0x804020,%eax
  800f01:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800f07:	a1 20 40 80 00       	mov    0x804020,%eax
  800f0c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800f12:	83 ec 04             	sub    $0x4,%esp
  800f15:	52                   	push   %edx
  800f16:	50                   	push   %eax
  800f17:	68 a8 2b 80 00       	push   $0x802ba8
  800f1c:	e8 45 03 00 00       	call   801266 <cprintf>
  800f21:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800f24:	a1 20 40 80 00       	mov    0x804020,%eax
  800f29:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800f2f:	a1 20 40 80 00       	mov    0x804020,%eax
  800f34:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800f3a:	a1 20 40 80 00       	mov    0x804020,%eax
  800f3f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800f45:	51                   	push   %ecx
  800f46:	52                   	push   %edx
  800f47:	50                   	push   %eax
  800f48:	68 d0 2b 80 00       	push   $0x802bd0
  800f4d:	e8 14 03 00 00       	call   801266 <cprintf>
  800f52:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f55:	a1 20 40 80 00       	mov    0x804020,%eax
  800f5a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800f60:	83 ec 08             	sub    $0x8,%esp
  800f63:	50                   	push   %eax
  800f64:	68 28 2c 80 00       	push   $0x802c28
  800f69:	e8 f8 02 00 00       	call   801266 <cprintf>
  800f6e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800f71:	83 ec 0c             	sub    $0xc,%esp
  800f74:	68 80 2b 80 00       	push   $0x802b80
  800f79:	e8 e8 02 00 00       	call   801266 <cprintf>
  800f7e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800f81:	e8 9a 13 00 00       	call   802320 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800f86:	e8 19 00 00 00       	call   800fa4 <exit>
}
  800f8b:	90                   	nop
  800f8c:	c9                   	leave  
  800f8d:	c3                   	ret    

00800f8e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800f94:	83 ec 0c             	sub    $0xc,%esp
  800f97:	6a 00                	push   $0x0
  800f99:	e8 27 15 00 00       	call   8024c5 <sys_destroy_env>
  800f9e:	83 c4 10             	add    $0x10,%esp
}
  800fa1:	90                   	nop
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <exit>:

void
exit(void)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800faa:	e8 7c 15 00 00       	call   80252b <sys_exit_env>
}
  800faf:	90                   	nop
  800fb0:	c9                   	leave  
  800fb1:	c3                   	ret    

00800fb2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800fb8:	8d 45 10             	lea    0x10(%ebp),%eax
  800fbb:	83 c0 04             	add    $0x4,%eax
  800fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800fc1:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	74 16                	je     800fe0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800fca:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800fcf:	83 ec 08             	sub    $0x8,%esp
  800fd2:	50                   	push   %eax
  800fd3:	68 3c 2c 80 00       	push   $0x802c3c
  800fd8:	e8 89 02 00 00       	call   801266 <cprintf>
  800fdd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800fe0:	a1 00 40 80 00       	mov    0x804000,%eax
  800fe5:	ff 75 0c             	pushl  0xc(%ebp)
  800fe8:	ff 75 08             	pushl  0x8(%ebp)
  800feb:	50                   	push   %eax
  800fec:	68 41 2c 80 00       	push   $0x802c41
  800ff1:	e8 70 02 00 00       	call   801266 <cprintf>
  800ff6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800ff9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffc:	83 ec 08             	sub    $0x8,%esp
  800fff:	ff 75 f4             	pushl  -0xc(%ebp)
  801002:	50                   	push   %eax
  801003:	e8 f3 01 00 00       	call   8011fb <vcprintf>
  801008:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80100b:	83 ec 08             	sub    $0x8,%esp
  80100e:	6a 00                	push   $0x0
  801010:	68 5d 2c 80 00       	push   $0x802c5d
  801015:	e8 e1 01 00 00       	call   8011fb <vcprintf>
  80101a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80101d:	e8 82 ff ff ff       	call   800fa4 <exit>

	// should not return here
	while (1) ;
  801022:	eb fe                	jmp    801022 <_panic+0x70>

00801024 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80102a:	a1 20 40 80 00       	mov    0x804020,%eax
  80102f:	8b 50 74             	mov    0x74(%eax),%edx
  801032:	8b 45 0c             	mov    0xc(%ebp),%eax
  801035:	39 c2                	cmp    %eax,%edx
  801037:	74 14                	je     80104d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801039:	83 ec 04             	sub    $0x4,%esp
  80103c:	68 60 2c 80 00       	push   $0x802c60
  801041:	6a 26                	push   $0x26
  801043:	68 ac 2c 80 00       	push   $0x802cac
  801048:	e8 65 ff ff ff       	call   800fb2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80104d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801054:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80105b:	e9 c2 00 00 00       	jmp    801122 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801063:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	01 d0                	add    %edx,%eax
  80106f:	8b 00                	mov    (%eax),%eax
  801071:	85 c0                	test   %eax,%eax
  801073:	75 08                	jne    80107d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801075:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801078:	e9 a2 00 00 00       	jmp    80111f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80107d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801084:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80108b:	eb 69                	jmp    8010f6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80108d:	a1 20 40 80 00       	mov    0x804020,%eax
  801092:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801098:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80109b:	89 d0                	mov    %edx,%eax
  80109d:	01 c0                	add    %eax,%eax
  80109f:	01 d0                	add    %edx,%eax
  8010a1:	c1 e0 03             	shl    $0x3,%eax
  8010a4:	01 c8                	add    %ecx,%eax
  8010a6:	8a 40 04             	mov    0x4(%eax),%al
  8010a9:	84 c0                	test   %al,%al
  8010ab:	75 46                	jne    8010f3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8010ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8010b2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8010b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8010bb:	89 d0                	mov    %edx,%eax
  8010bd:	01 c0                	add    %eax,%eax
  8010bf:	01 d0                	add    %edx,%eax
  8010c1:	c1 e0 03             	shl    $0x3,%eax
  8010c4:	01 c8                	add    %ecx,%eax
  8010c6:	8b 00                	mov    (%eax),%eax
  8010c8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8010cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8010ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010d3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8010d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010d8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	01 c8                	add    %ecx,%eax
  8010e4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8010e6:	39 c2                	cmp    %eax,%edx
  8010e8:	75 09                	jne    8010f3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8010ea:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8010f1:	eb 12                	jmp    801105 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010f3:	ff 45 e8             	incl   -0x18(%ebp)
  8010f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8010fb:	8b 50 74             	mov    0x74(%eax),%edx
  8010fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801101:	39 c2                	cmp    %eax,%edx
  801103:	77 88                	ja     80108d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801105:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801109:	75 14                	jne    80111f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80110b:	83 ec 04             	sub    $0x4,%esp
  80110e:	68 b8 2c 80 00       	push   $0x802cb8
  801113:	6a 3a                	push   $0x3a
  801115:	68 ac 2c 80 00       	push   $0x802cac
  80111a:	e8 93 fe ff ff       	call   800fb2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80111f:	ff 45 f0             	incl   -0x10(%ebp)
  801122:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801125:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801128:	0f 8c 32 ff ff ff    	jl     801060 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80112e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801135:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80113c:	eb 26                	jmp    801164 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80113e:	a1 20 40 80 00       	mov    0x804020,%eax
  801143:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801149:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80114c:	89 d0                	mov    %edx,%eax
  80114e:	01 c0                	add    %eax,%eax
  801150:	01 d0                	add    %edx,%eax
  801152:	c1 e0 03             	shl    $0x3,%eax
  801155:	01 c8                	add    %ecx,%eax
  801157:	8a 40 04             	mov    0x4(%eax),%al
  80115a:	3c 01                	cmp    $0x1,%al
  80115c:	75 03                	jne    801161 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80115e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801161:	ff 45 e0             	incl   -0x20(%ebp)
  801164:	a1 20 40 80 00       	mov    0x804020,%eax
  801169:	8b 50 74             	mov    0x74(%eax),%edx
  80116c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80116f:	39 c2                	cmp    %eax,%edx
  801171:	77 cb                	ja     80113e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801176:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801179:	74 14                	je     80118f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80117b:	83 ec 04             	sub    $0x4,%esp
  80117e:	68 0c 2d 80 00       	push   $0x802d0c
  801183:	6a 44                	push   $0x44
  801185:	68 ac 2c 80 00       	push   $0x802cac
  80118a:	e8 23 fe ff ff       	call   800fb2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80118f:	90                   	nop
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119b:	8b 00                	mov    (%eax),%eax
  80119d:	8d 48 01             	lea    0x1(%eax),%ecx
  8011a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a3:	89 0a                	mov    %ecx,(%edx)
  8011a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a8:	88 d1                	mov    %dl,%cl
  8011aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ad:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	8b 00                	mov    (%eax),%eax
  8011b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8011bb:	75 2c                	jne    8011e9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8011bd:	a0 24 40 80 00       	mov    0x804024,%al
  8011c2:	0f b6 c0             	movzbl %al,%eax
  8011c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c8:	8b 12                	mov    (%edx),%edx
  8011ca:	89 d1                	mov    %edx,%ecx
  8011cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011cf:	83 c2 08             	add    $0x8,%edx
  8011d2:	83 ec 04             	sub    $0x4,%esp
  8011d5:	50                   	push   %eax
  8011d6:	51                   	push   %ecx
  8011d7:	52                   	push   %edx
  8011d8:	e8 7b 0f 00 00       	call   802158 <sys_cputs>
  8011dd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8011e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8011e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ec:	8b 40 04             	mov    0x4(%eax),%eax
  8011ef:	8d 50 01             	lea    0x1(%eax),%edx
  8011f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8011f8:	90                   	nop
  8011f9:	c9                   	leave  
  8011fa:	c3                   	ret    

008011fb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801204:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80120b:	00 00 00 
	b.cnt = 0;
  80120e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801215:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801218:	ff 75 0c             	pushl  0xc(%ebp)
  80121b:	ff 75 08             	pushl  0x8(%ebp)
  80121e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801224:	50                   	push   %eax
  801225:	68 92 11 80 00       	push   $0x801192
  80122a:	e8 11 02 00 00       	call   801440 <vprintfmt>
  80122f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801232:	a0 24 40 80 00       	mov    0x804024,%al
  801237:	0f b6 c0             	movzbl %al,%eax
  80123a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801240:	83 ec 04             	sub    $0x4,%esp
  801243:	50                   	push   %eax
  801244:	52                   	push   %edx
  801245:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80124b:	83 c0 08             	add    $0x8,%eax
  80124e:	50                   	push   %eax
  80124f:	e8 04 0f 00 00       	call   802158 <sys_cputs>
  801254:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801257:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80125e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801264:	c9                   	leave  
  801265:	c3                   	ret    

00801266 <cprintf>:

int cprintf(const char *fmt, ...) {
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80126c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  801273:	8d 45 0c             	lea    0xc(%ebp),%eax
  801276:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	83 ec 08             	sub    $0x8,%esp
  80127f:	ff 75 f4             	pushl  -0xc(%ebp)
  801282:	50                   	push   %eax
  801283:	e8 73 ff ff ff       	call   8011fb <vcprintf>
  801288:	83 c4 10             	add    $0x10,%esp
  80128b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80128e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    

00801293 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801299:	e8 68 10 00 00       	call   802306 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80129e:	8d 45 0c             	lea    0xc(%ebp),%eax
  8012a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	83 ec 08             	sub    $0x8,%esp
  8012aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8012ad:	50                   	push   %eax
  8012ae:	e8 48 ff ff ff       	call   8011fb <vcprintf>
  8012b3:	83 c4 10             	add    $0x10,%esp
  8012b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8012b9:	e8 62 10 00 00       	call   802320 <sys_enable_interrupt>
	return cnt;
  8012be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012c1:	c9                   	leave  
  8012c2:	c3                   	ret    

008012c3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	53                   	push   %ebx
  8012c7:	83 ec 14             	sub    $0x14,%esp
  8012ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8012d6:	8b 45 18             	mov    0x18(%ebp),%eax
  8012d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8012de:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012e1:	77 55                	ja     801338 <printnum+0x75>
  8012e3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8012e6:	72 05                	jb     8012ed <printnum+0x2a>
  8012e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012eb:	77 4b                	ja     801338 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8012ed:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8012f0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8012f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8012f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8012fb:	52                   	push   %edx
  8012fc:	50                   	push   %eax
  8012fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801300:	ff 75 f0             	pushl  -0x10(%ebp)
  801303:	e8 84 14 00 00       	call   80278c <__udivdi3>
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	83 ec 04             	sub    $0x4,%esp
  80130e:	ff 75 20             	pushl  0x20(%ebp)
  801311:	53                   	push   %ebx
  801312:	ff 75 18             	pushl  0x18(%ebp)
  801315:	52                   	push   %edx
  801316:	50                   	push   %eax
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	ff 75 08             	pushl  0x8(%ebp)
  80131d:	e8 a1 ff ff ff       	call   8012c3 <printnum>
  801322:	83 c4 20             	add    $0x20,%esp
  801325:	eb 1a                	jmp    801341 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801327:	83 ec 08             	sub    $0x8,%esp
  80132a:	ff 75 0c             	pushl  0xc(%ebp)
  80132d:	ff 75 20             	pushl  0x20(%ebp)
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	ff d0                	call   *%eax
  801335:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801338:	ff 4d 1c             	decl   0x1c(%ebp)
  80133b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80133f:	7f e6                	jg     801327 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801341:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801344:	bb 00 00 00 00       	mov    $0x0,%ebx
  801349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80134f:	53                   	push   %ebx
  801350:	51                   	push   %ecx
  801351:	52                   	push   %edx
  801352:	50                   	push   %eax
  801353:	e8 44 15 00 00       	call   80289c <__umoddi3>
  801358:	83 c4 10             	add    $0x10,%esp
  80135b:	05 74 2f 80 00       	add    $0x802f74,%eax
  801360:	8a 00                	mov    (%eax),%al
  801362:	0f be c0             	movsbl %al,%eax
  801365:	83 ec 08             	sub    $0x8,%esp
  801368:	ff 75 0c             	pushl  0xc(%ebp)
  80136b:	50                   	push   %eax
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	ff d0                	call   *%eax
  801371:	83 c4 10             	add    $0x10,%esp
}
  801374:	90                   	nop
  801375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80137d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801381:	7e 1c                	jle    80139f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8b 00                	mov    (%eax),%eax
  801388:	8d 50 08             	lea    0x8(%eax),%edx
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	89 10                	mov    %edx,(%eax)
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8b 00                	mov    (%eax),%eax
  801395:	83 e8 08             	sub    $0x8,%eax
  801398:	8b 50 04             	mov    0x4(%eax),%edx
  80139b:	8b 00                	mov    (%eax),%eax
  80139d:	eb 40                	jmp    8013df <getuint+0x65>
	else if (lflag)
  80139f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013a3:	74 1e                	je     8013c3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8b 00                	mov    (%eax),%eax
  8013aa:	8d 50 04             	lea    0x4(%eax),%edx
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	89 10                	mov    %edx,(%eax)
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	8b 00                	mov    (%eax),%eax
  8013b7:	83 e8 04             	sub    $0x4,%eax
  8013ba:	8b 00                	mov    (%eax),%eax
  8013bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c1:	eb 1c                	jmp    8013df <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8b 00                	mov    (%eax),%eax
  8013c8:	8d 50 04             	lea    0x4(%eax),%edx
  8013cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ce:	89 10                	mov    %edx,(%eax)
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	8b 00                	mov    (%eax),%eax
  8013d5:	83 e8 04             	sub    $0x4,%eax
  8013d8:	8b 00                	mov    (%eax),%eax
  8013da:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8013df:	5d                   	pop    %ebp
  8013e0:	c3                   	ret    

008013e1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8013e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8013e8:	7e 1c                	jle    801406 <getint+0x25>
		return va_arg(*ap, long long);
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8b 00                	mov    (%eax),%eax
  8013ef:	8d 50 08             	lea    0x8(%eax),%edx
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	89 10                	mov    %edx,(%eax)
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	8b 00                	mov    (%eax),%eax
  8013fc:	83 e8 08             	sub    $0x8,%eax
  8013ff:	8b 50 04             	mov    0x4(%eax),%edx
  801402:	8b 00                	mov    (%eax),%eax
  801404:	eb 38                	jmp    80143e <getint+0x5d>
	else if (lflag)
  801406:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80140a:	74 1a                	je     801426 <getint+0x45>
		return va_arg(*ap, long);
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8b 00                	mov    (%eax),%eax
  801411:	8d 50 04             	lea    0x4(%eax),%edx
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	89 10                	mov    %edx,(%eax)
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	8b 00                	mov    (%eax),%eax
  80141e:	83 e8 04             	sub    $0x4,%eax
  801421:	8b 00                	mov    (%eax),%eax
  801423:	99                   	cltd   
  801424:	eb 18                	jmp    80143e <getint+0x5d>
	else
		return va_arg(*ap, int);
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	8b 00                	mov    (%eax),%eax
  80142b:	8d 50 04             	lea    0x4(%eax),%edx
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	89 10                	mov    %edx,(%eax)
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	8b 00                	mov    (%eax),%eax
  801438:	83 e8 04             	sub    $0x4,%eax
  80143b:	8b 00                	mov    (%eax),%eax
  80143d:	99                   	cltd   
}
  80143e:	5d                   	pop    %ebp
  80143f:	c3                   	ret    

00801440 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	56                   	push   %esi
  801444:	53                   	push   %ebx
  801445:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801448:	eb 17                	jmp    801461 <vprintfmt+0x21>
			if (ch == '\0')
  80144a:	85 db                	test   %ebx,%ebx
  80144c:	0f 84 af 03 00 00    	je     801801 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801452:	83 ec 08             	sub    $0x8,%esp
  801455:	ff 75 0c             	pushl  0xc(%ebp)
  801458:	53                   	push   %ebx
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	ff d0                	call   *%eax
  80145e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801461:	8b 45 10             	mov    0x10(%ebp),%eax
  801464:	8d 50 01             	lea    0x1(%eax),%edx
  801467:	89 55 10             	mov    %edx,0x10(%ebp)
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	0f b6 d8             	movzbl %al,%ebx
  80146f:	83 fb 25             	cmp    $0x25,%ebx
  801472:	75 d6                	jne    80144a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801474:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801478:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80147f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801486:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80148d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801494:	8b 45 10             	mov    0x10(%ebp),%eax
  801497:	8d 50 01             	lea    0x1(%eax),%edx
  80149a:	89 55 10             	mov    %edx,0x10(%ebp)
  80149d:	8a 00                	mov    (%eax),%al
  80149f:	0f b6 d8             	movzbl %al,%ebx
  8014a2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8014a5:	83 f8 55             	cmp    $0x55,%eax
  8014a8:	0f 87 2b 03 00 00    	ja     8017d9 <vprintfmt+0x399>
  8014ae:	8b 04 85 98 2f 80 00 	mov    0x802f98(,%eax,4),%eax
  8014b5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8014b7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8014bb:	eb d7                	jmp    801494 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8014bd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8014c1:	eb d1                	jmp    801494 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8014ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014cd:	89 d0                	mov    %edx,%eax
  8014cf:	c1 e0 02             	shl    $0x2,%eax
  8014d2:	01 d0                	add    %edx,%eax
  8014d4:	01 c0                	add    %eax,%eax
  8014d6:	01 d8                	add    %ebx,%eax
  8014d8:	83 e8 30             	sub    $0x30,%eax
  8014db:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8014de:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8014e6:	83 fb 2f             	cmp    $0x2f,%ebx
  8014e9:	7e 3e                	jle    801529 <vprintfmt+0xe9>
  8014eb:	83 fb 39             	cmp    $0x39,%ebx
  8014ee:	7f 39                	jg     801529 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014f0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8014f3:	eb d5                	jmp    8014ca <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8014f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f8:	83 c0 04             	add    $0x4,%eax
  8014fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8014fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801501:	83 e8 04             	sub    $0x4,%eax
  801504:	8b 00                	mov    (%eax),%eax
  801506:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801509:	eb 1f                	jmp    80152a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80150b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80150f:	79 83                	jns    801494 <vprintfmt+0x54>
				width = 0;
  801511:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801518:	e9 77 ff ff ff       	jmp    801494 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80151d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801524:	e9 6b ff ff ff       	jmp    801494 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801529:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80152a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80152e:	0f 89 60 ff ff ff    	jns    801494 <vprintfmt+0x54>
				width = precision, precision = -1;
  801534:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801537:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80153a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801541:	e9 4e ff ff ff       	jmp    801494 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801546:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801549:	e9 46 ff ff ff       	jmp    801494 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80154e:	8b 45 14             	mov    0x14(%ebp),%eax
  801551:	83 c0 04             	add    $0x4,%eax
  801554:	89 45 14             	mov    %eax,0x14(%ebp)
  801557:	8b 45 14             	mov    0x14(%ebp),%eax
  80155a:	83 e8 04             	sub    $0x4,%eax
  80155d:	8b 00                	mov    (%eax),%eax
  80155f:	83 ec 08             	sub    $0x8,%esp
  801562:	ff 75 0c             	pushl  0xc(%ebp)
  801565:	50                   	push   %eax
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	ff d0                	call   *%eax
  80156b:	83 c4 10             	add    $0x10,%esp
			break;
  80156e:	e9 89 02 00 00       	jmp    8017fc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801573:	8b 45 14             	mov    0x14(%ebp),%eax
  801576:	83 c0 04             	add    $0x4,%eax
  801579:	89 45 14             	mov    %eax,0x14(%ebp)
  80157c:	8b 45 14             	mov    0x14(%ebp),%eax
  80157f:	83 e8 04             	sub    $0x4,%eax
  801582:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801584:	85 db                	test   %ebx,%ebx
  801586:	79 02                	jns    80158a <vprintfmt+0x14a>
				err = -err;
  801588:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80158a:	83 fb 64             	cmp    $0x64,%ebx
  80158d:	7f 0b                	jg     80159a <vprintfmt+0x15a>
  80158f:	8b 34 9d e0 2d 80 00 	mov    0x802de0(,%ebx,4),%esi
  801596:	85 f6                	test   %esi,%esi
  801598:	75 19                	jne    8015b3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80159a:	53                   	push   %ebx
  80159b:	68 85 2f 80 00       	push   $0x802f85
  8015a0:	ff 75 0c             	pushl  0xc(%ebp)
  8015a3:	ff 75 08             	pushl  0x8(%ebp)
  8015a6:	e8 5e 02 00 00       	call   801809 <printfmt>
  8015ab:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8015ae:	e9 49 02 00 00       	jmp    8017fc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8015b3:	56                   	push   %esi
  8015b4:	68 8e 2f 80 00       	push   $0x802f8e
  8015b9:	ff 75 0c             	pushl  0xc(%ebp)
  8015bc:	ff 75 08             	pushl  0x8(%ebp)
  8015bf:	e8 45 02 00 00       	call   801809 <printfmt>
  8015c4:	83 c4 10             	add    $0x10,%esp
			break;
  8015c7:	e9 30 02 00 00       	jmp    8017fc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8015cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8015cf:	83 c0 04             	add    $0x4,%eax
  8015d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8015d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d8:	83 e8 04             	sub    $0x4,%eax
  8015db:	8b 30                	mov    (%eax),%esi
  8015dd:	85 f6                	test   %esi,%esi
  8015df:	75 05                	jne    8015e6 <vprintfmt+0x1a6>
				p = "(null)";
  8015e1:	be 91 2f 80 00       	mov    $0x802f91,%esi
			if (width > 0 && padc != '-')
  8015e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015ea:	7e 6d                	jle    801659 <vprintfmt+0x219>
  8015ec:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8015f0:	74 67                	je     801659 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015f5:	83 ec 08             	sub    $0x8,%esp
  8015f8:	50                   	push   %eax
  8015f9:	56                   	push   %esi
  8015fa:	e8 0c 03 00 00       	call   80190b <strnlen>
  8015ff:	83 c4 10             	add    $0x10,%esp
  801602:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801605:	eb 16                	jmp    80161d <vprintfmt+0x1dd>
					putch(padc, putdat);
  801607:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80160b:	83 ec 08             	sub    $0x8,%esp
  80160e:	ff 75 0c             	pushl  0xc(%ebp)
  801611:	50                   	push   %eax
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	ff d0                	call   *%eax
  801617:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80161a:	ff 4d e4             	decl   -0x1c(%ebp)
  80161d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801621:	7f e4                	jg     801607 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801623:	eb 34                	jmp    801659 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801625:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801629:	74 1c                	je     801647 <vprintfmt+0x207>
  80162b:	83 fb 1f             	cmp    $0x1f,%ebx
  80162e:	7e 05                	jle    801635 <vprintfmt+0x1f5>
  801630:	83 fb 7e             	cmp    $0x7e,%ebx
  801633:	7e 12                	jle    801647 <vprintfmt+0x207>
					putch('?', putdat);
  801635:	83 ec 08             	sub    $0x8,%esp
  801638:	ff 75 0c             	pushl  0xc(%ebp)
  80163b:	6a 3f                	push   $0x3f
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	ff d0                	call   *%eax
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	eb 0f                	jmp    801656 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801647:	83 ec 08             	sub    $0x8,%esp
  80164a:	ff 75 0c             	pushl  0xc(%ebp)
  80164d:	53                   	push   %ebx
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	ff d0                	call   *%eax
  801653:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801656:	ff 4d e4             	decl   -0x1c(%ebp)
  801659:	89 f0                	mov    %esi,%eax
  80165b:	8d 70 01             	lea    0x1(%eax),%esi
  80165e:	8a 00                	mov    (%eax),%al
  801660:	0f be d8             	movsbl %al,%ebx
  801663:	85 db                	test   %ebx,%ebx
  801665:	74 24                	je     80168b <vprintfmt+0x24b>
  801667:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80166b:	78 b8                	js     801625 <vprintfmt+0x1e5>
  80166d:	ff 4d e0             	decl   -0x20(%ebp)
  801670:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801674:	79 af                	jns    801625 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801676:	eb 13                	jmp    80168b <vprintfmt+0x24b>
				putch(' ', putdat);
  801678:	83 ec 08             	sub    $0x8,%esp
  80167b:	ff 75 0c             	pushl  0xc(%ebp)
  80167e:	6a 20                	push   $0x20
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	ff d0                	call   *%eax
  801685:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801688:	ff 4d e4             	decl   -0x1c(%ebp)
  80168b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80168f:	7f e7                	jg     801678 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801691:	e9 66 01 00 00       	jmp    8017fc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801696:	83 ec 08             	sub    $0x8,%esp
  801699:	ff 75 e8             	pushl  -0x18(%ebp)
  80169c:	8d 45 14             	lea    0x14(%ebp),%eax
  80169f:	50                   	push   %eax
  8016a0:	e8 3c fd ff ff       	call   8013e1 <getint>
  8016a5:	83 c4 10             	add    $0x10,%esp
  8016a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8016ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b4:	85 d2                	test   %edx,%edx
  8016b6:	79 23                	jns    8016db <vprintfmt+0x29b>
				putch('-', putdat);
  8016b8:	83 ec 08             	sub    $0x8,%esp
  8016bb:	ff 75 0c             	pushl  0xc(%ebp)
  8016be:	6a 2d                	push   $0x2d
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	ff d0                	call   *%eax
  8016c5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8016c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ce:	f7 d8                	neg    %eax
  8016d0:	83 d2 00             	adc    $0x0,%edx
  8016d3:	f7 da                	neg    %edx
  8016d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8016db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016e2:	e9 bc 00 00 00       	jmp    8017a3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8016e7:	83 ec 08             	sub    $0x8,%esp
  8016ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8016ed:	8d 45 14             	lea    0x14(%ebp),%eax
  8016f0:	50                   	push   %eax
  8016f1:	e8 84 fc ff ff       	call   80137a <getuint>
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8016ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801706:	e9 98 00 00 00       	jmp    8017a3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80170b:	83 ec 08             	sub    $0x8,%esp
  80170e:	ff 75 0c             	pushl  0xc(%ebp)
  801711:	6a 58                	push   $0x58
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	ff d0                	call   *%eax
  801718:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80171b:	83 ec 08             	sub    $0x8,%esp
  80171e:	ff 75 0c             	pushl  0xc(%ebp)
  801721:	6a 58                	push   $0x58
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	ff d0                	call   *%eax
  801728:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80172b:	83 ec 08             	sub    $0x8,%esp
  80172e:	ff 75 0c             	pushl  0xc(%ebp)
  801731:	6a 58                	push   $0x58
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	ff d0                	call   *%eax
  801738:	83 c4 10             	add    $0x10,%esp
			break;
  80173b:	e9 bc 00 00 00       	jmp    8017fc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801740:	83 ec 08             	sub    $0x8,%esp
  801743:	ff 75 0c             	pushl  0xc(%ebp)
  801746:	6a 30                	push   $0x30
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	ff d0                	call   *%eax
  80174d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801750:	83 ec 08             	sub    $0x8,%esp
  801753:	ff 75 0c             	pushl  0xc(%ebp)
  801756:	6a 78                	push   $0x78
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	ff d0                	call   *%eax
  80175d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801760:	8b 45 14             	mov    0x14(%ebp),%eax
  801763:	83 c0 04             	add    $0x4,%eax
  801766:	89 45 14             	mov    %eax,0x14(%ebp)
  801769:	8b 45 14             	mov    0x14(%ebp),%eax
  80176c:	83 e8 04             	sub    $0x4,%eax
  80176f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801771:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801774:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80177b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801782:	eb 1f                	jmp    8017a3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801784:	83 ec 08             	sub    $0x8,%esp
  801787:	ff 75 e8             	pushl  -0x18(%ebp)
  80178a:	8d 45 14             	lea    0x14(%ebp),%eax
  80178d:	50                   	push   %eax
  80178e:	e8 e7 fb ff ff       	call   80137a <getuint>
  801793:	83 c4 10             	add    $0x10,%esp
  801796:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801799:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80179c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8017a3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8017a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017aa:	83 ec 04             	sub    $0x4,%esp
  8017ad:	52                   	push   %edx
  8017ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017b1:	50                   	push   %eax
  8017b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8017b8:	ff 75 0c             	pushl  0xc(%ebp)
  8017bb:	ff 75 08             	pushl  0x8(%ebp)
  8017be:	e8 00 fb ff ff       	call   8012c3 <printnum>
  8017c3:	83 c4 20             	add    $0x20,%esp
			break;
  8017c6:	eb 34                	jmp    8017fc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017c8:	83 ec 08             	sub    $0x8,%esp
  8017cb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ce:	53                   	push   %ebx
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	ff d0                	call   *%eax
  8017d4:	83 c4 10             	add    $0x10,%esp
			break;
  8017d7:	eb 23                	jmp    8017fc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017d9:	83 ec 08             	sub    $0x8,%esp
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	6a 25                	push   $0x25
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	ff d0                	call   *%eax
  8017e6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8017e9:	ff 4d 10             	decl   0x10(%ebp)
  8017ec:	eb 03                	jmp    8017f1 <vprintfmt+0x3b1>
  8017ee:	ff 4d 10             	decl   0x10(%ebp)
  8017f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f4:	48                   	dec    %eax
  8017f5:	8a 00                	mov    (%eax),%al
  8017f7:	3c 25                	cmp    $0x25,%al
  8017f9:	75 f3                	jne    8017ee <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8017fb:	90                   	nop
		}
	}
  8017fc:	e9 47 fc ff ff       	jmp    801448 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801801:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801802:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801805:	5b                   	pop    %ebx
  801806:	5e                   	pop    %esi
  801807:	5d                   	pop    %ebp
  801808:	c3                   	ret    

00801809 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80180f:	8d 45 10             	lea    0x10(%ebp),%eax
  801812:	83 c0 04             	add    $0x4,%eax
  801815:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801818:	8b 45 10             	mov    0x10(%ebp),%eax
  80181b:	ff 75 f4             	pushl  -0xc(%ebp)
  80181e:	50                   	push   %eax
  80181f:	ff 75 0c             	pushl  0xc(%ebp)
  801822:	ff 75 08             	pushl  0x8(%ebp)
  801825:	e8 16 fc ff ff       	call   801440 <vprintfmt>
  80182a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80182d:	90                   	nop
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801833:	8b 45 0c             	mov    0xc(%ebp),%eax
  801836:	8b 40 08             	mov    0x8(%eax),%eax
  801839:	8d 50 01             	lea    0x1(%eax),%edx
  80183c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801842:	8b 45 0c             	mov    0xc(%ebp),%eax
  801845:	8b 10                	mov    (%eax),%edx
  801847:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184a:	8b 40 04             	mov    0x4(%eax),%eax
  80184d:	39 c2                	cmp    %eax,%edx
  80184f:	73 12                	jae    801863 <sprintputch+0x33>
		*b->buf++ = ch;
  801851:	8b 45 0c             	mov    0xc(%ebp),%eax
  801854:	8b 00                	mov    (%eax),%eax
  801856:	8d 48 01             	lea    0x1(%eax),%ecx
  801859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185c:	89 0a                	mov    %ecx,(%edx)
  80185e:	8b 55 08             	mov    0x8(%ebp),%edx
  801861:	88 10                	mov    %dl,(%eax)
}
  801863:	90                   	nop
  801864:	5d                   	pop    %ebp
  801865:	c3                   	ret    

00801866 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801872:	8b 45 0c             	mov    0xc(%ebp),%eax
  801875:	8d 50 ff             	lea    -0x1(%eax),%edx
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	01 d0                	add    %edx,%eax
  80187d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801880:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801887:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80188b:	74 06                	je     801893 <vsnprintf+0x2d>
  80188d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801891:	7f 07                	jg     80189a <vsnprintf+0x34>
		return -E_INVAL;
  801893:	b8 03 00 00 00       	mov    $0x3,%eax
  801898:	eb 20                	jmp    8018ba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80189a:	ff 75 14             	pushl  0x14(%ebp)
  80189d:	ff 75 10             	pushl  0x10(%ebp)
  8018a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8018a3:	50                   	push   %eax
  8018a4:	68 30 18 80 00       	push   $0x801830
  8018a9:	e8 92 fb ff ff       	call   801440 <vprintfmt>
  8018ae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8018b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8018b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8018c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8018c5:	83 c0 04             	add    $0x4,%eax
  8018c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8018cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d1:	50                   	push   %eax
  8018d2:	ff 75 0c             	pushl  0xc(%ebp)
  8018d5:	ff 75 08             	pushl  0x8(%ebp)
  8018d8:	e8 89 ff ff ff       	call   801866 <vsnprintf>
  8018dd:	83 c4 10             	add    $0x10,%esp
  8018e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8018e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018f5:	eb 06                	jmp    8018fd <strlen+0x15>
		n++;
  8018f7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018fa:	ff 45 08             	incl   0x8(%ebp)
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	8a 00                	mov    (%eax),%al
  801902:	84 c0                	test   %al,%al
  801904:	75 f1                	jne    8018f7 <strlen+0xf>
		n++;
	return n;
  801906:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801911:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801918:	eb 09                	jmp    801923 <strnlen+0x18>
		n++;
  80191a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80191d:	ff 45 08             	incl   0x8(%ebp)
  801920:	ff 4d 0c             	decl   0xc(%ebp)
  801923:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801927:	74 09                	je     801932 <strnlen+0x27>
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	8a 00                	mov    (%eax),%al
  80192e:	84 c0                	test   %al,%al
  801930:	75 e8                	jne    80191a <strnlen+0xf>
		n++;
	return n;
  801932:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801943:	90                   	nop
  801944:	8b 45 08             	mov    0x8(%ebp),%eax
  801947:	8d 50 01             	lea    0x1(%eax),%edx
  80194a:	89 55 08             	mov    %edx,0x8(%ebp)
  80194d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801950:	8d 4a 01             	lea    0x1(%edx),%ecx
  801953:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801956:	8a 12                	mov    (%edx),%dl
  801958:	88 10                	mov    %dl,(%eax)
  80195a:	8a 00                	mov    (%eax),%al
  80195c:	84 c0                	test   %al,%al
  80195e:	75 e4                	jne    801944 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801960:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801971:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801978:	eb 1f                	jmp    801999 <strncpy+0x34>
		*dst++ = *src;
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	8d 50 01             	lea    0x1(%eax),%edx
  801980:	89 55 08             	mov    %edx,0x8(%ebp)
  801983:	8b 55 0c             	mov    0xc(%ebp),%edx
  801986:	8a 12                	mov    (%edx),%dl
  801988:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80198a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198d:	8a 00                	mov    (%eax),%al
  80198f:	84 c0                	test   %al,%al
  801991:	74 03                	je     801996 <strncpy+0x31>
			src++;
  801993:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801996:	ff 45 fc             	incl   -0x4(%ebp)
  801999:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80199c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80199f:	72 d9                	jb     80197a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8019a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8019b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019b6:	74 30                	je     8019e8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8019b8:	eb 16                	jmp    8019d0 <strlcpy+0x2a>
			*dst++ = *src++;
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	8d 50 01             	lea    0x1(%eax),%edx
  8019c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8019c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8019cc:	8a 12                	mov    (%edx),%dl
  8019ce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019d0:	ff 4d 10             	decl   0x10(%ebp)
  8019d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019d7:	74 09                	je     8019e2 <strlcpy+0x3c>
  8019d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019dc:	8a 00                	mov    (%eax),%al
  8019de:	84 c0                	test   %al,%al
  8019e0:	75 d8                	jne    8019ba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8019eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ee:	29 c2                	sub    %eax,%edx
  8019f0:	89 d0                	mov    %edx,%eax
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8019f7:	eb 06                	jmp    8019ff <strcmp+0xb>
		p++, q++;
  8019f9:	ff 45 08             	incl   0x8(%ebp)
  8019fc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	84 c0                	test   %al,%al
  801a06:	74 0e                	je     801a16 <strcmp+0x22>
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	8a 10                	mov    (%eax),%dl
  801a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a10:	8a 00                	mov    (%eax),%al
  801a12:	38 c2                	cmp    %al,%dl
  801a14:	74 e3                	je     8019f9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8a 00                	mov    (%eax),%al
  801a1b:	0f b6 d0             	movzbl %al,%edx
  801a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a21:	8a 00                	mov    (%eax),%al
  801a23:	0f b6 c0             	movzbl %al,%eax
  801a26:	29 c2                	sub    %eax,%edx
  801a28:	89 d0                	mov    %edx,%eax
}
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    

00801a2c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801a2f:	eb 09                	jmp    801a3a <strncmp+0xe>
		n--, p++, q++;
  801a31:	ff 4d 10             	decl   0x10(%ebp)
  801a34:	ff 45 08             	incl   0x8(%ebp)
  801a37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801a3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a3e:	74 17                	je     801a57 <strncmp+0x2b>
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	8a 00                	mov    (%eax),%al
  801a45:	84 c0                	test   %al,%al
  801a47:	74 0e                	je     801a57 <strncmp+0x2b>
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	8a 10                	mov    (%eax),%dl
  801a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a51:	8a 00                	mov    (%eax),%al
  801a53:	38 c2                	cmp    %al,%dl
  801a55:	74 da                	je     801a31 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a5b:	75 07                	jne    801a64 <strncmp+0x38>
		return 0;
  801a5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a62:	eb 14                	jmp    801a78 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	8a 00                	mov    (%eax),%al
  801a69:	0f b6 d0             	movzbl %al,%edx
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	8a 00                	mov    (%eax),%al
  801a71:	0f b6 c0             	movzbl %al,%eax
  801a74:	29 c2                	sub    %eax,%edx
  801a76:	89 d0                	mov    %edx,%eax
}
  801a78:	5d                   	pop    %ebp
  801a79:	c3                   	ret    

00801a7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	83 ec 04             	sub    $0x4,%esp
  801a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a86:	eb 12                	jmp    801a9a <strchr+0x20>
		if (*s == c)
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	8a 00                	mov    (%eax),%al
  801a8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a90:	75 05                	jne    801a97 <strchr+0x1d>
			return (char *) s;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	eb 11                	jmp    801aa8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a97:	ff 45 08             	incl   0x8(%ebp)
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	8a 00                	mov    (%eax),%al
  801a9f:	84 c0                	test   %al,%al
  801aa1:	75 e5                	jne    801a88 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801aa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 04             	sub    $0x4,%esp
  801ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801ab6:	eb 0d                	jmp    801ac5 <strfind+0x1b>
		if (*s == c)
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	8a 00                	mov    (%eax),%al
  801abd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801ac0:	74 0e                	je     801ad0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801ac2:	ff 45 08             	incl   0x8(%ebp)
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	8a 00                	mov    (%eax),%al
  801aca:	84 c0                	test   %al,%al
  801acc:	75 ea                	jne    801ab8 <strfind+0xe>
  801ace:	eb 01                	jmp    801ad1 <strfind+0x27>
		if (*s == c)
			break;
  801ad0:	90                   	nop
	return (char *) s;
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801ae8:	eb 0e                	jmp    801af8 <memset+0x22>
		*p++ = c;
  801aea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aed:	8d 50 01             	lea    0x1(%eax),%edx
  801af0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801af8:	ff 4d f8             	decl   -0x8(%ebp)
  801afb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801aff:	79 e9                	jns    801aea <memset+0x14>
		*p++ = c;

	return v;
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801b18:	eb 16                	jmp    801b30 <memcpy+0x2a>
		*d++ = *s++;
  801b1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b1d:	8d 50 01             	lea    0x1(%eax),%edx
  801b20:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b26:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b29:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b2c:	8a 12                	mov    (%edx),%dl
  801b2e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801b30:	8b 45 10             	mov    0x10(%ebp),%eax
  801b33:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b36:	89 55 10             	mov    %edx,0x10(%ebp)
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	75 dd                	jne    801b1a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b57:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b5a:	73 50                	jae    801bac <memmove+0x6a>
  801b5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b62:	01 d0                	add    %edx,%eax
  801b64:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b67:	76 43                	jbe    801bac <memmove+0x6a>
		s += n;
  801b69:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b72:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b75:	eb 10                	jmp    801b87 <memmove+0x45>
			*--d = *--s;
  801b77:	ff 4d f8             	decl   -0x8(%ebp)
  801b7a:	ff 4d fc             	decl   -0x4(%ebp)
  801b7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b80:	8a 10                	mov    (%eax),%dl
  801b82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b85:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b87:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b8d:	89 55 10             	mov    %edx,0x10(%ebp)
  801b90:	85 c0                	test   %eax,%eax
  801b92:	75 e3                	jne    801b77 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b94:	eb 23                	jmp    801bb9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b99:	8d 50 01             	lea    0x1(%eax),%edx
  801b9c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba2:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ba5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ba8:	8a 12                	mov    (%edx),%dl
  801baa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801bac:	8b 45 10             	mov    0x10(%ebp),%eax
  801baf:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bb2:	89 55 10             	mov    %edx,0x10(%ebp)
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	75 dd                	jne    801b96 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801bd0:	eb 2a                	jmp    801bfc <memcmp+0x3e>
		if (*s1 != *s2)
  801bd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bd5:	8a 10                	mov    (%eax),%dl
  801bd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bda:	8a 00                	mov    (%eax),%al
  801bdc:	38 c2                	cmp    %al,%dl
  801bde:	74 16                	je     801bf6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801be0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be3:	8a 00                	mov    (%eax),%al
  801be5:	0f b6 d0             	movzbl %al,%edx
  801be8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801beb:	8a 00                	mov    (%eax),%al
  801bed:	0f b6 c0             	movzbl %al,%eax
  801bf0:	29 c2                	sub    %eax,%edx
  801bf2:	89 d0                	mov    %edx,%eax
  801bf4:	eb 18                	jmp    801c0e <memcmp+0x50>
		s1++, s2++;
  801bf6:	ff 45 fc             	incl   -0x4(%ebp)
  801bf9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801bfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801bff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c02:	89 55 10             	mov    %edx,0x10(%ebp)
  801c05:	85 c0                	test   %eax,%eax
  801c07:	75 c9                	jne    801bd2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801c16:	8b 55 08             	mov    0x8(%ebp),%edx
  801c19:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1c:	01 d0                	add    %edx,%eax
  801c1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801c21:	eb 15                	jmp    801c38 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	8a 00                	mov    (%eax),%al
  801c28:	0f b6 d0             	movzbl %al,%edx
  801c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2e:	0f b6 c0             	movzbl %al,%eax
  801c31:	39 c2                	cmp    %eax,%edx
  801c33:	74 0d                	je     801c42 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c35:	ff 45 08             	incl   0x8(%ebp)
  801c38:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801c3e:	72 e3                	jb     801c23 <memfind+0x13>
  801c40:	eb 01                	jmp    801c43 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801c42:	90                   	nop
	return (void *) s;
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801c4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801c55:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c5c:	eb 03                	jmp    801c61 <strtol+0x19>
		s++;
  801c5e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	8a 00                	mov    (%eax),%al
  801c66:	3c 20                	cmp    $0x20,%al
  801c68:	74 f4                	je     801c5e <strtol+0x16>
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	8a 00                	mov    (%eax),%al
  801c6f:	3c 09                	cmp    $0x9,%al
  801c71:	74 eb                	je     801c5e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	8a 00                	mov    (%eax),%al
  801c78:	3c 2b                	cmp    $0x2b,%al
  801c7a:	75 05                	jne    801c81 <strtol+0x39>
		s++;
  801c7c:	ff 45 08             	incl   0x8(%ebp)
  801c7f:	eb 13                	jmp    801c94 <strtol+0x4c>
	else if (*s == '-')
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	8a 00                	mov    (%eax),%al
  801c86:	3c 2d                	cmp    $0x2d,%al
  801c88:	75 0a                	jne    801c94 <strtol+0x4c>
		s++, neg = 1;
  801c8a:	ff 45 08             	incl   0x8(%ebp)
  801c8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c98:	74 06                	je     801ca0 <strtol+0x58>
  801c9a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c9e:	75 20                	jne    801cc0 <strtol+0x78>
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	8a 00                	mov    (%eax),%al
  801ca5:	3c 30                	cmp    $0x30,%al
  801ca7:	75 17                	jne    801cc0 <strtol+0x78>
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	40                   	inc    %eax
  801cad:	8a 00                	mov    (%eax),%al
  801caf:	3c 78                	cmp    $0x78,%al
  801cb1:	75 0d                	jne    801cc0 <strtol+0x78>
		s += 2, base = 16;
  801cb3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801cb7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801cbe:	eb 28                	jmp    801ce8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801cc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cc4:	75 15                	jne    801cdb <strtol+0x93>
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	8a 00                	mov    (%eax),%al
  801ccb:	3c 30                	cmp    $0x30,%al
  801ccd:	75 0c                	jne    801cdb <strtol+0x93>
		s++, base = 8;
  801ccf:	ff 45 08             	incl   0x8(%ebp)
  801cd2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801cd9:	eb 0d                	jmp    801ce8 <strtol+0xa0>
	else if (base == 0)
  801cdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cdf:	75 07                	jne    801ce8 <strtol+0xa0>
		base = 10;
  801ce1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	8a 00                	mov    (%eax),%al
  801ced:	3c 2f                	cmp    $0x2f,%al
  801cef:	7e 19                	jle    801d0a <strtol+0xc2>
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	8a 00                	mov    (%eax),%al
  801cf6:	3c 39                	cmp    $0x39,%al
  801cf8:	7f 10                	jg     801d0a <strtol+0xc2>
			dig = *s - '0';
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	8a 00                	mov    (%eax),%al
  801cff:	0f be c0             	movsbl %al,%eax
  801d02:	83 e8 30             	sub    $0x30,%eax
  801d05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d08:	eb 42                	jmp    801d4c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	8a 00                	mov    (%eax),%al
  801d0f:	3c 60                	cmp    $0x60,%al
  801d11:	7e 19                	jle    801d2c <strtol+0xe4>
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	8a 00                	mov    (%eax),%al
  801d18:	3c 7a                	cmp    $0x7a,%al
  801d1a:	7f 10                	jg     801d2c <strtol+0xe4>
			dig = *s - 'a' + 10;
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	8a 00                	mov    (%eax),%al
  801d21:	0f be c0             	movsbl %al,%eax
  801d24:	83 e8 57             	sub    $0x57,%eax
  801d27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d2a:	eb 20                	jmp    801d4c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	8a 00                	mov    (%eax),%al
  801d31:	3c 40                	cmp    $0x40,%al
  801d33:	7e 39                	jle    801d6e <strtol+0x126>
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	8a 00                	mov    (%eax),%al
  801d3a:	3c 5a                	cmp    $0x5a,%al
  801d3c:	7f 30                	jg     801d6e <strtol+0x126>
			dig = *s - 'A' + 10;
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	8a 00                	mov    (%eax),%al
  801d43:	0f be c0             	movsbl %al,%eax
  801d46:	83 e8 37             	sub    $0x37,%eax
  801d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d52:	7d 19                	jge    801d6d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801d54:	ff 45 08             	incl   0x8(%ebp)
  801d57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d5a:	0f af 45 10          	imul   0x10(%ebp),%eax
  801d5e:	89 c2                	mov    %eax,%edx
  801d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d63:	01 d0                	add    %edx,%eax
  801d65:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d68:	e9 7b ff ff ff       	jmp    801ce8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d6d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d72:	74 08                	je     801d7c <strtol+0x134>
		*endptr = (char *) s;
  801d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d77:	8b 55 08             	mov    0x8(%ebp),%edx
  801d7a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d80:	74 07                	je     801d89 <strtol+0x141>
  801d82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d85:	f7 d8                	neg    %eax
  801d87:	eb 03                	jmp    801d8c <strtol+0x144>
  801d89:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <ltostr>:

void
ltostr(long value, char *str)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d9b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801da2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801da6:	79 13                	jns    801dbb <ltostr+0x2d>
	{
		neg = 1;
  801da8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801db5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801db8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801dc3:	99                   	cltd   
  801dc4:	f7 f9                	idiv   %ecx
  801dc6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801dc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dcc:	8d 50 01             	lea    0x1(%eax),%edx
  801dcf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801dd2:	89 c2                	mov    %eax,%edx
  801dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd7:	01 d0                	add    %edx,%eax
  801dd9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ddc:	83 c2 30             	add    $0x30,%edx
  801ddf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801de1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801de9:	f7 e9                	imul   %ecx
  801deb:	c1 fa 02             	sar    $0x2,%edx
  801dee:	89 c8                	mov    %ecx,%eax
  801df0:	c1 f8 1f             	sar    $0x1f,%eax
  801df3:	29 c2                	sub    %eax,%edx
  801df5:	89 d0                	mov    %edx,%eax
  801df7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801dfa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dfd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801e02:	f7 e9                	imul   %ecx
  801e04:	c1 fa 02             	sar    $0x2,%edx
  801e07:	89 c8                	mov    %ecx,%eax
  801e09:	c1 f8 1f             	sar    $0x1f,%eax
  801e0c:	29 c2                	sub    %eax,%edx
  801e0e:	89 d0                	mov    %edx,%eax
  801e10:	c1 e0 02             	shl    $0x2,%eax
  801e13:	01 d0                	add    %edx,%eax
  801e15:	01 c0                	add    %eax,%eax
  801e17:	29 c1                	sub    %eax,%ecx
  801e19:	89 ca                	mov    %ecx,%edx
  801e1b:	85 d2                	test   %edx,%edx
  801e1d:	75 9c                	jne    801dbb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801e1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801e26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e29:	48                   	dec    %eax
  801e2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801e2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e31:	74 3d                	je     801e70 <ltostr+0xe2>
		start = 1 ;
  801e33:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801e3a:	eb 34                	jmp    801e70 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801e3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e42:	01 d0                	add    %edx,%eax
  801e44:	8a 00                	mov    (%eax),%al
  801e46:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801e49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4f:	01 c2                	add    %eax,%edx
  801e51:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e57:	01 c8                	add    %ecx,%eax
  801e59:	8a 00                	mov    (%eax),%al
  801e5b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801e5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e63:	01 c2                	add    %eax,%edx
  801e65:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e68:	88 02                	mov    %al,(%edx)
		start++ ;
  801e6a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e6d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e73:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e76:	7c c4                	jl     801e3c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e78:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7e:	01 d0                	add    %edx,%eax
  801e80:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e83:	90                   	nop
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e8c:	ff 75 08             	pushl  0x8(%ebp)
  801e8f:	e8 54 fa ff ff       	call   8018e8 <strlen>
  801e94:	83 c4 04             	add    $0x4,%esp
  801e97:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e9a:	ff 75 0c             	pushl  0xc(%ebp)
  801e9d:	e8 46 fa ff ff       	call   8018e8 <strlen>
  801ea2:	83 c4 04             	add    $0x4,%esp
  801ea5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ea8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801eaf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801eb6:	eb 17                	jmp    801ecf <strcconcat+0x49>
		final[s] = str1[s] ;
  801eb8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebe:	01 c2                	add    %eax,%edx
  801ec0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	01 c8                	add    %ecx,%eax
  801ec8:	8a 00                	mov    (%eax),%al
  801eca:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ecc:	ff 45 fc             	incl   -0x4(%ebp)
  801ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ed2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ed5:	7c e1                	jl     801eb8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801ed7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ede:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801ee5:	eb 1f                	jmp    801f06 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801ee7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eea:	8d 50 01             	lea    0x1(%eax),%edx
  801eed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ef0:	89 c2                	mov    %eax,%edx
  801ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef5:	01 c2                	add    %eax,%edx
  801ef7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efd:	01 c8                	add    %ecx,%eax
  801eff:	8a 00                	mov    (%eax),%al
  801f01:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801f03:	ff 45 f8             	incl   -0x8(%ebp)
  801f06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f09:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f0c:	7c d9                	jl     801ee7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801f0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f11:	8b 45 10             	mov    0x10(%ebp),%eax
  801f14:	01 d0                	add    %edx,%eax
  801f16:	c6 00 00             	movb   $0x0,(%eax)
}
  801f19:	90                   	nop
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801f1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801f22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801f28:	8b 45 14             	mov    0x14(%ebp),%eax
  801f2b:	8b 00                	mov    (%eax),%eax
  801f2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f34:	8b 45 10             	mov    0x10(%ebp),%eax
  801f37:	01 d0                	add    %edx,%eax
  801f39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f3f:	eb 0c                	jmp    801f4d <strsplit+0x31>
			*string++ = 0;
  801f41:	8b 45 08             	mov    0x8(%ebp),%eax
  801f44:	8d 50 01             	lea    0x1(%eax),%edx
  801f47:	89 55 08             	mov    %edx,0x8(%ebp)
  801f4a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	8a 00                	mov    (%eax),%al
  801f52:	84 c0                	test   %al,%al
  801f54:	74 18                	je     801f6e <strsplit+0x52>
  801f56:	8b 45 08             	mov    0x8(%ebp),%eax
  801f59:	8a 00                	mov    (%eax),%al
  801f5b:	0f be c0             	movsbl %al,%eax
  801f5e:	50                   	push   %eax
  801f5f:	ff 75 0c             	pushl  0xc(%ebp)
  801f62:	e8 13 fb ff ff       	call   801a7a <strchr>
  801f67:	83 c4 08             	add    $0x8,%esp
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	75 d3                	jne    801f41 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	8a 00                	mov    (%eax),%al
  801f73:	84 c0                	test   %al,%al
  801f75:	74 5a                	je     801fd1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f77:	8b 45 14             	mov    0x14(%ebp),%eax
  801f7a:	8b 00                	mov    (%eax),%eax
  801f7c:	83 f8 0f             	cmp    $0xf,%eax
  801f7f:	75 07                	jne    801f88 <strsplit+0x6c>
		{
			return 0;
  801f81:	b8 00 00 00 00       	mov    $0x0,%eax
  801f86:	eb 66                	jmp    801fee <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f88:	8b 45 14             	mov    0x14(%ebp),%eax
  801f8b:	8b 00                	mov    (%eax),%eax
  801f8d:	8d 48 01             	lea    0x1(%eax),%ecx
  801f90:	8b 55 14             	mov    0x14(%ebp),%edx
  801f93:	89 0a                	mov    %ecx,(%edx)
  801f95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9f:	01 c2                	add    %eax,%edx
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801fa6:	eb 03                	jmp    801fab <strsplit+0x8f>
			string++;
  801fa8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	8a 00                	mov    (%eax),%al
  801fb0:	84 c0                	test   %al,%al
  801fb2:	74 8b                	je     801f3f <strsplit+0x23>
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	8a 00                	mov    (%eax),%al
  801fb9:	0f be c0             	movsbl %al,%eax
  801fbc:	50                   	push   %eax
  801fbd:	ff 75 0c             	pushl  0xc(%ebp)
  801fc0:	e8 b5 fa ff ff       	call   801a7a <strchr>
  801fc5:	83 c4 08             	add    $0x8,%esp
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	74 dc                	je     801fa8 <strsplit+0x8c>
			string++;
	}
  801fcc:	e9 6e ff ff ff       	jmp    801f3f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801fd1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801fd2:	8b 45 14             	mov    0x14(%ebp),%eax
  801fd5:	8b 00                	mov    (%eax),%eax
  801fd7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fde:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe1:	01 d0                	add    %edx,%eax
  801fe3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801fe9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801ff6:	83 ec 04             	sub    $0x4,%esp
  801ff9:	68 f0 30 80 00       	push   $0x8030f0
  801ffe:	6a 0e                	push   $0xe
  802000:	68 2a 31 80 00       	push   $0x80312a
  802005:	e8 a8 ef ff ff       	call   800fb2 <_panic>

0080200a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  802010:	a1 04 40 80 00       	mov    0x804004,%eax
  802015:	85 c0                	test   %eax,%eax
  802017:	74 0f                	je     802028 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  802019:	e8 d2 ff ff ff       	call   801ff0 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80201e:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  802025:	00 00 00 
	}
	if (size == 0) return NULL ;
  802028:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80202c:	75 07                	jne    802035 <malloc+0x2b>
  80202e:	b8 00 00 00 00       	mov    $0x0,%eax
  802033:	eb 14                	jmp    802049 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  802035:	83 ec 04             	sub    $0x4,%esp
  802038:	68 38 31 80 00       	push   $0x803138
  80203d:	6a 2e                	push   $0x2e
  80203f:	68 2a 31 80 00       	push   $0x80312a
  802044:	e8 69 ef ff ff       	call   800fb2 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  802051:	83 ec 04             	sub    $0x4,%esp
  802054:	68 60 31 80 00       	push   $0x803160
  802059:	6a 49                	push   $0x49
  80205b:	68 2a 31 80 00       	push   $0x80312a
  802060:	e8 4d ef ff ff       	call   800fb2 <_panic>

00802065 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 18             	sub    $0x18,%esp
  80206b:	8b 45 10             	mov    0x10(%ebp),%eax
  80206e:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  802071:	83 ec 04             	sub    $0x4,%esp
  802074:	68 84 31 80 00       	push   $0x803184
  802079:	6a 57                	push   $0x57
  80207b:	68 2a 31 80 00       	push   $0x80312a
  802080:	e8 2d ef ff ff       	call   800fb2 <_panic>

00802085 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80208b:	83 ec 04             	sub    $0x4,%esp
  80208e:	68 ac 31 80 00       	push   $0x8031ac
  802093:	6a 60                	push   $0x60
  802095:	68 2a 31 80 00       	push   $0x80312a
  80209a:	e8 13 ef ff ff       	call   800fb2 <_panic>

0080209f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8020a5:	83 ec 04             	sub    $0x4,%esp
  8020a8:	68 d0 31 80 00       	push   $0x8031d0
  8020ad:	6a 7c                	push   $0x7c
  8020af:	68 2a 31 80 00       	push   $0x80312a
  8020b4:	e8 f9 ee ff ff       	call   800fb2 <_panic>

008020b9 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8020bf:	83 ec 04             	sub    $0x4,%esp
  8020c2:	68 f8 31 80 00       	push   $0x8031f8
  8020c7:	68 86 00 00 00       	push   $0x86
  8020cc:	68 2a 31 80 00       	push   $0x80312a
  8020d1:	e8 dc ee ff ff       	call   800fb2 <_panic>

008020d6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020dc:	83 ec 04             	sub    $0x4,%esp
  8020df:	68 1c 32 80 00       	push   $0x80321c
  8020e4:	68 91 00 00 00       	push   $0x91
  8020e9:	68 2a 31 80 00       	push   $0x80312a
  8020ee:	e8 bf ee ff ff       	call   800fb2 <_panic>

008020f3 <shrink>:

}
void shrink(uint32 newSize)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020f9:	83 ec 04             	sub    $0x4,%esp
  8020fc:	68 1c 32 80 00       	push   $0x80321c
  802101:	68 96 00 00 00       	push   $0x96
  802106:	68 2a 31 80 00       	push   $0x80312a
  80210b:	e8 a2 ee ff ff       	call   800fb2 <_panic>

00802110 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802116:	83 ec 04             	sub    $0x4,%esp
  802119:	68 1c 32 80 00       	push   $0x80321c
  80211e:	68 9b 00 00 00       	push   $0x9b
  802123:	68 2a 31 80 00       	push   $0x80312a
  802128:	e8 85 ee ff ff       	call   800fb2 <_panic>

0080212d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	57                   	push   %edi
  802131:	56                   	push   %esi
  802132:	53                   	push   %ebx
  802133:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802136:	8b 45 08             	mov    0x8(%ebp),%eax
  802139:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80213f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802142:	8b 7d 18             	mov    0x18(%ebp),%edi
  802145:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802148:	cd 30                	int    $0x30
  80214a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80214d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802150:	83 c4 10             	add    $0x10,%esp
  802153:	5b                   	pop    %ebx
  802154:	5e                   	pop    %esi
  802155:	5f                   	pop    %edi
  802156:	5d                   	pop    %ebp
  802157:	c3                   	ret    

00802158 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 04             	sub    $0x4,%esp
  80215e:	8b 45 10             	mov    0x10(%ebp),%eax
  802161:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802164:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	52                   	push   %edx
  802170:	ff 75 0c             	pushl  0xc(%ebp)
  802173:	50                   	push   %eax
  802174:	6a 00                	push   $0x0
  802176:	e8 b2 ff ff ff       	call   80212d <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
}
  80217e:	90                   	nop
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <sys_cgetc>:

int
sys_cgetc(void)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 01                	push   $0x1
  802190:	e8 98 ff ff ff       	call   80212d <syscall>
  802195:	83 c4 18             	add    $0x18,%esp
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80219d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	52                   	push   %edx
  8021aa:	50                   	push   %eax
  8021ab:	6a 05                	push   $0x5
  8021ad:	e8 7b ff ff ff       	call   80212d <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	56                   	push   %esi
  8021bb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021bc:	8b 75 18             	mov    0x18(%ebp),%esi
  8021bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	56                   	push   %esi
  8021cc:	53                   	push   %ebx
  8021cd:	51                   	push   %ecx
  8021ce:	52                   	push   %edx
  8021cf:	50                   	push   %eax
  8021d0:	6a 06                	push   $0x6
  8021d2:	e8 56 ff ff ff       	call   80212d <syscall>
  8021d7:	83 c4 18             	add    $0x18,%esp
}
  8021da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021dd:	5b                   	pop    %ebx
  8021de:	5e                   	pop    %esi
  8021df:	5d                   	pop    %ebp
  8021e0:	c3                   	ret    

008021e1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	52                   	push   %edx
  8021f1:	50                   	push   %eax
  8021f2:	6a 07                	push   $0x7
  8021f4:	e8 34 ff ff ff       	call   80212d <syscall>
  8021f9:	83 c4 18             	add    $0x18,%esp
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	ff 75 0c             	pushl  0xc(%ebp)
  80220a:	ff 75 08             	pushl  0x8(%ebp)
  80220d:	6a 08                	push   $0x8
  80220f:	e8 19 ff ff ff       	call   80212d <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 09                	push   $0x9
  802228:	e8 00 ff ff ff       	call   80212d <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 0a                	push   $0xa
  802241:	e8 e7 fe ff ff       	call   80212d <syscall>
  802246:	83 c4 18             	add    $0x18,%esp
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 0b                	push   $0xb
  80225a:	e8 ce fe ff ff       	call   80212d <syscall>
  80225f:	83 c4 18             	add    $0x18,%esp
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	ff 75 0c             	pushl  0xc(%ebp)
  802270:	ff 75 08             	pushl  0x8(%ebp)
  802273:	6a 0f                	push   $0xf
  802275:	e8 b3 fe ff ff       	call   80212d <syscall>
  80227a:	83 c4 18             	add    $0x18,%esp
	return;
  80227d:	90                   	nop
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	ff 75 0c             	pushl  0xc(%ebp)
  80228c:	ff 75 08             	pushl  0x8(%ebp)
  80228f:	6a 10                	push   $0x10
  802291:	e8 97 fe ff ff       	call   80212d <syscall>
  802296:	83 c4 18             	add    $0x18,%esp
	return ;
  802299:	90                   	nop
}
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	ff 75 10             	pushl  0x10(%ebp)
  8022a6:	ff 75 0c             	pushl  0xc(%ebp)
  8022a9:	ff 75 08             	pushl  0x8(%ebp)
  8022ac:	6a 11                	push   $0x11
  8022ae:	e8 7a fe ff ff       	call   80212d <syscall>
  8022b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b6:	90                   	nop
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 0c                	push   $0xc
  8022c8:	e8 60 fe ff ff       	call   80212d <syscall>
  8022cd:	83 c4 18             	add    $0x18,%esp
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	ff 75 08             	pushl  0x8(%ebp)
  8022e0:	6a 0d                	push   $0xd
  8022e2:	e8 46 fe ff ff       	call   80212d <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
}
  8022ea:	c9                   	leave  
  8022eb:	c3                   	ret    

008022ec <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 0e                	push   $0xe
  8022fb:	e8 2d fe ff ff       	call   80212d <syscall>
  802300:	83 c4 18             	add    $0x18,%esp
}
  802303:	90                   	nop
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 13                	push   $0x13
  802315:	e8 13 fe ff ff       	call   80212d <syscall>
  80231a:	83 c4 18             	add    $0x18,%esp
}
  80231d:	90                   	nop
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 14                	push   $0x14
  80232f:	e8 f9 fd ff ff       	call   80212d <syscall>
  802334:	83 c4 18             	add    $0x18,%esp
}
  802337:	90                   	nop
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <sys_cputc>:


void
sys_cputc(const char c)
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
  80233d:	83 ec 04             	sub    $0x4,%esp
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802346:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	50                   	push   %eax
  802353:	6a 15                	push   $0x15
  802355:	e8 d3 fd ff ff       	call   80212d <syscall>
  80235a:	83 c4 18             	add    $0x18,%esp
}
  80235d:	90                   	nop
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 16                	push   $0x16
  80236f:	e8 b9 fd ff ff       	call   80212d <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
}
  802377:	90                   	nop
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	ff 75 0c             	pushl  0xc(%ebp)
  802389:	50                   	push   %eax
  80238a:	6a 17                	push   $0x17
  80238c:	e8 9c fd ff ff       	call   80212d <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802399:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	52                   	push   %edx
  8023a6:	50                   	push   %eax
  8023a7:	6a 1a                	push   $0x1a
  8023a9:	e8 7f fd ff ff       	call   80212d <syscall>
  8023ae:	83 c4 18             	add    $0x18,%esp
}
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	52                   	push   %edx
  8023c3:	50                   	push   %eax
  8023c4:	6a 18                	push   $0x18
  8023c6:	e8 62 fd ff ff       	call   80212d <syscall>
  8023cb:	83 c4 18             	add    $0x18,%esp
}
  8023ce:	90                   	nop
  8023cf:	c9                   	leave  
  8023d0:	c3                   	ret    

008023d1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023d1:	55                   	push   %ebp
  8023d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	52                   	push   %edx
  8023e1:	50                   	push   %eax
  8023e2:	6a 19                	push   $0x19
  8023e4:	e8 44 fd ff ff       	call   80212d <syscall>
  8023e9:	83 c4 18             	add    $0x18,%esp
}
  8023ec:	90                   	nop
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	83 ec 04             	sub    $0x4,%esp
  8023f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8023f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023fb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023fe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	6a 00                	push   $0x0
  802407:	51                   	push   %ecx
  802408:	52                   	push   %edx
  802409:	ff 75 0c             	pushl  0xc(%ebp)
  80240c:	50                   	push   %eax
  80240d:	6a 1b                	push   $0x1b
  80240f:	e8 19 fd ff ff       	call   80212d <syscall>
  802414:	83 c4 18             	add    $0x18,%esp
}
  802417:	c9                   	leave  
  802418:	c3                   	ret    

00802419 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80241c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241f:	8b 45 08             	mov    0x8(%ebp),%eax
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	52                   	push   %edx
  802429:	50                   	push   %eax
  80242a:	6a 1c                	push   $0x1c
  80242c:	e8 fc fc ff ff       	call   80212d <syscall>
  802431:	83 c4 18             	add    $0x18,%esp
}
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802439:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80243c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	51                   	push   %ecx
  802447:	52                   	push   %edx
  802448:	50                   	push   %eax
  802449:	6a 1d                	push   $0x1d
  80244b:	e8 dd fc ff ff       	call   80212d <syscall>
  802450:	83 c4 18             	add    $0x18,%esp
}
  802453:	c9                   	leave  
  802454:	c3                   	ret    

00802455 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802455:	55                   	push   %ebp
  802456:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802458:	8b 55 0c             	mov    0xc(%ebp),%edx
  80245b:	8b 45 08             	mov    0x8(%ebp),%eax
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	52                   	push   %edx
  802465:	50                   	push   %eax
  802466:	6a 1e                	push   $0x1e
  802468:	e8 c0 fc ff ff       	call   80212d <syscall>
  80246d:	83 c4 18             	add    $0x18,%esp
}
  802470:	c9                   	leave  
  802471:	c3                   	ret    

00802472 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 1f                	push   $0x1f
  802481:	e8 a7 fc ff ff       	call   80212d <syscall>
  802486:	83 c4 18             	add    $0x18,%esp
}
  802489:	c9                   	leave  
  80248a:	c3                   	ret    

0080248b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	6a 00                	push   $0x0
  802493:	ff 75 14             	pushl  0x14(%ebp)
  802496:	ff 75 10             	pushl  0x10(%ebp)
  802499:	ff 75 0c             	pushl  0xc(%ebp)
  80249c:	50                   	push   %eax
  80249d:	6a 20                	push   $0x20
  80249f:	e8 89 fc ff ff       	call   80212d <syscall>
  8024a4:	83 c4 18             	add    $0x18,%esp
}
  8024a7:	c9                   	leave  
  8024a8:	c3                   	ret    

008024a9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8024a9:	55                   	push   %ebp
  8024aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8024ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	50                   	push   %eax
  8024b8:	6a 21                	push   $0x21
  8024ba:	e8 6e fc ff ff       	call   80212d <syscall>
  8024bf:	83 c4 18             	add    $0x18,%esp
}
  8024c2:	90                   	nop
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    

008024c5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	50                   	push   %eax
  8024d4:	6a 22                	push   $0x22
  8024d6:	e8 52 fc ff ff       	call   80212d <syscall>
  8024db:	83 c4 18             	add    $0x18,%esp
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 02                	push   $0x2
  8024ef:	e8 39 fc ff ff       	call   80212d <syscall>
  8024f4:	83 c4 18             	add    $0x18,%esp
}
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	6a 03                	push   $0x3
  802508:	e8 20 fc ff ff       	call   80212d <syscall>
  80250d:	83 c4 18             	add    $0x18,%esp
}
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 04                	push   $0x4
  802521:	e8 07 fc ff ff       	call   80212d <syscall>
  802526:	83 c4 18             	add    $0x18,%esp
}
  802529:	c9                   	leave  
  80252a:	c3                   	ret    

0080252b <sys_exit_env>:


void sys_exit_env(void)
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 23                	push   $0x23
  80253a:	e8 ee fb ff ff       	call   80212d <syscall>
  80253f:	83 c4 18             	add    $0x18,%esp
}
  802542:	90                   	nop
  802543:	c9                   	leave  
  802544:	c3                   	ret    

00802545 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802545:	55                   	push   %ebp
  802546:	89 e5                	mov    %esp,%ebp
  802548:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80254b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80254e:	8d 50 04             	lea    0x4(%eax),%edx
  802551:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	52                   	push   %edx
  80255b:	50                   	push   %eax
  80255c:	6a 24                	push   $0x24
  80255e:	e8 ca fb ff ff       	call   80212d <syscall>
  802563:	83 c4 18             	add    $0x18,%esp
	return result;
  802566:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802569:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80256c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80256f:	89 01                	mov    %eax,(%ecx)
  802571:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802574:	8b 45 08             	mov    0x8(%ebp),%eax
  802577:	c9                   	leave  
  802578:	c2 04 00             	ret    $0x4

0080257b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	ff 75 10             	pushl  0x10(%ebp)
  802585:	ff 75 0c             	pushl  0xc(%ebp)
  802588:	ff 75 08             	pushl  0x8(%ebp)
  80258b:	6a 12                	push   $0x12
  80258d:	e8 9b fb ff ff       	call   80212d <syscall>
  802592:	83 c4 18             	add    $0x18,%esp
	return ;
  802595:	90                   	nop
}
  802596:	c9                   	leave  
  802597:	c3                   	ret    

00802598 <sys_rcr2>:
uint32 sys_rcr2()
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 25                	push   $0x25
  8025a7:	e8 81 fb ff ff       	call   80212d <syscall>
  8025ac:	83 c4 18             	add    $0x18,%esp
}
  8025af:	c9                   	leave  
  8025b0:	c3                   	ret    

008025b1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
  8025b4:	83 ec 04             	sub    $0x4,%esp
  8025b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025bd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	50                   	push   %eax
  8025ca:	6a 26                	push   $0x26
  8025cc:	e8 5c fb ff ff       	call   80212d <syscall>
  8025d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8025d4:	90                   	nop
}
  8025d5:	c9                   	leave  
  8025d6:	c3                   	ret    

008025d7 <rsttst>:
void rsttst()
{
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 28                	push   $0x28
  8025e6:	e8 42 fb ff ff       	call   80212d <syscall>
  8025eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ee:	90                   	nop
}
  8025ef:	c9                   	leave  
  8025f0:	c3                   	ret    

008025f1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025f1:	55                   	push   %ebp
  8025f2:	89 e5                	mov    %esp,%ebp
  8025f4:	83 ec 04             	sub    $0x4,%esp
  8025f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8025fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025fd:	8b 55 18             	mov    0x18(%ebp),%edx
  802600:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802604:	52                   	push   %edx
  802605:	50                   	push   %eax
  802606:	ff 75 10             	pushl  0x10(%ebp)
  802609:	ff 75 0c             	pushl  0xc(%ebp)
  80260c:	ff 75 08             	pushl  0x8(%ebp)
  80260f:	6a 27                	push   $0x27
  802611:	e8 17 fb ff ff       	call   80212d <syscall>
  802616:	83 c4 18             	add    $0x18,%esp
	return ;
  802619:	90                   	nop
}
  80261a:	c9                   	leave  
  80261b:	c3                   	ret    

0080261c <chktst>:
void chktst(uint32 n)
{
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	6a 00                	push   $0x0
  802627:	ff 75 08             	pushl  0x8(%ebp)
  80262a:	6a 29                	push   $0x29
  80262c:	e8 fc fa ff ff       	call   80212d <syscall>
  802631:	83 c4 18             	add    $0x18,%esp
	return ;
  802634:	90                   	nop
}
  802635:	c9                   	leave  
  802636:	c3                   	ret    

00802637 <inctst>:

void inctst()
{
  802637:	55                   	push   %ebp
  802638:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80263a:	6a 00                	push   $0x0
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	6a 2a                	push   $0x2a
  802646:	e8 e2 fa ff ff       	call   80212d <syscall>
  80264b:	83 c4 18             	add    $0x18,%esp
	return ;
  80264e:	90                   	nop
}
  80264f:	c9                   	leave  
  802650:	c3                   	ret    

00802651 <gettst>:
uint32 gettst()
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802654:	6a 00                	push   $0x0
  802656:	6a 00                	push   $0x0
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 2b                	push   $0x2b
  802660:	e8 c8 fa ff ff       	call   80212d <syscall>
  802665:	83 c4 18             	add    $0x18,%esp
}
  802668:	c9                   	leave  
  802669:	c3                   	ret    

0080266a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
  80266d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802670:	6a 00                	push   $0x0
  802672:	6a 00                	push   $0x0
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 2c                	push   $0x2c
  80267c:	e8 ac fa ff ff       	call   80212d <syscall>
  802681:	83 c4 18             	add    $0x18,%esp
  802684:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802687:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80268b:	75 07                	jne    802694 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80268d:	b8 01 00 00 00       	mov    $0x1,%eax
  802692:	eb 05                	jmp    802699 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802694:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802699:	c9                   	leave  
  80269a:	c3                   	ret    

0080269b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
  80269e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 2c                	push   $0x2c
  8026ad:	e8 7b fa ff ff       	call   80212d <syscall>
  8026b2:	83 c4 18             	add    $0x18,%esp
  8026b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026b8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026bc:	75 07                	jne    8026c5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026be:	b8 01 00 00 00       	mov    $0x1,%eax
  8026c3:	eb 05                	jmp    8026ca <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ca:	c9                   	leave  
  8026cb:	c3                   	ret    

008026cc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026cc:	55                   	push   %ebp
  8026cd:	89 e5                	mov    %esp,%ebp
  8026cf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 2c                	push   $0x2c
  8026de:	e8 4a fa ff ff       	call   80212d <syscall>
  8026e3:	83 c4 18             	add    $0x18,%esp
  8026e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026e9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026ed:	75 07                	jne    8026f6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f4:	eb 05                	jmp    8026fb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026fb:	c9                   	leave  
  8026fc:	c3                   	ret    

008026fd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
  802700:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	6a 2c                	push   $0x2c
  80270f:	e8 19 fa ff ff       	call   80212d <syscall>
  802714:	83 c4 18             	add    $0x18,%esp
  802717:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80271a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80271e:	75 07                	jne    802727 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802720:	b8 01 00 00 00       	mov    $0x1,%eax
  802725:	eb 05                	jmp    80272c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802727:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80272c:	c9                   	leave  
  80272d:	c3                   	ret    

0080272e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802731:	6a 00                	push   $0x0
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	ff 75 08             	pushl  0x8(%ebp)
  80273c:	6a 2d                	push   $0x2d
  80273e:	e8 ea f9 ff ff       	call   80212d <syscall>
  802743:	83 c4 18             	add    $0x18,%esp
	return ;
  802746:	90                   	nop
}
  802747:	c9                   	leave  
  802748:	c3                   	ret    

00802749 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
  80274c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80274d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802750:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802753:	8b 55 0c             	mov    0xc(%ebp),%edx
  802756:	8b 45 08             	mov    0x8(%ebp),%eax
  802759:	6a 00                	push   $0x0
  80275b:	53                   	push   %ebx
  80275c:	51                   	push   %ecx
  80275d:	52                   	push   %edx
  80275e:	50                   	push   %eax
  80275f:	6a 2e                	push   $0x2e
  802761:	e8 c7 f9 ff ff       	call   80212d <syscall>
  802766:	83 c4 18             	add    $0x18,%esp
}
  802769:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80276c:	c9                   	leave  
  80276d:	c3                   	ret    

0080276e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802771:	8b 55 0c             	mov    0xc(%ebp),%edx
  802774:	8b 45 08             	mov    0x8(%ebp),%eax
  802777:	6a 00                	push   $0x0
  802779:	6a 00                	push   $0x0
  80277b:	6a 00                	push   $0x0
  80277d:	52                   	push   %edx
  80277e:	50                   	push   %eax
  80277f:	6a 2f                	push   $0x2f
  802781:	e8 a7 f9 ff ff       	call   80212d <syscall>
  802786:	83 c4 18             	add    $0x18,%esp
}
  802789:	c9                   	leave  
  80278a:	c3                   	ret    
  80278b:	90                   	nop

0080278c <__udivdi3>:
  80278c:	55                   	push   %ebp
  80278d:	57                   	push   %edi
  80278e:	56                   	push   %esi
  80278f:	53                   	push   %ebx
  802790:	83 ec 1c             	sub    $0x1c,%esp
  802793:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802797:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80279b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80279f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027a3:	89 ca                	mov    %ecx,%edx
  8027a5:	89 f8                	mov    %edi,%eax
  8027a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8027ab:	85 f6                	test   %esi,%esi
  8027ad:	75 2d                	jne    8027dc <__udivdi3+0x50>
  8027af:	39 cf                	cmp    %ecx,%edi
  8027b1:	77 65                	ja     802818 <__udivdi3+0x8c>
  8027b3:	89 fd                	mov    %edi,%ebp
  8027b5:	85 ff                	test   %edi,%edi
  8027b7:	75 0b                	jne    8027c4 <__udivdi3+0x38>
  8027b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8027be:	31 d2                	xor    %edx,%edx
  8027c0:	f7 f7                	div    %edi
  8027c2:	89 c5                	mov    %eax,%ebp
  8027c4:	31 d2                	xor    %edx,%edx
  8027c6:	89 c8                	mov    %ecx,%eax
  8027c8:	f7 f5                	div    %ebp
  8027ca:	89 c1                	mov    %eax,%ecx
  8027cc:	89 d8                	mov    %ebx,%eax
  8027ce:	f7 f5                	div    %ebp
  8027d0:	89 cf                	mov    %ecx,%edi
  8027d2:	89 fa                	mov    %edi,%edx
  8027d4:	83 c4 1c             	add    $0x1c,%esp
  8027d7:	5b                   	pop    %ebx
  8027d8:	5e                   	pop    %esi
  8027d9:	5f                   	pop    %edi
  8027da:	5d                   	pop    %ebp
  8027db:	c3                   	ret    
  8027dc:	39 ce                	cmp    %ecx,%esi
  8027de:	77 28                	ja     802808 <__udivdi3+0x7c>
  8027e0:	0f bd fe             	bsr    %esi,%edi
  8027e3:	83 f7 1f             	xor    $0x1f,%edi
  8027e6:	75 40                	jne    802828 <__udivdi3+0x9c>
  8027e8:	39 ce                	cmp    %ecx,%esi
  8027ea:	72 0a                	jb     8027f6 <__udivdi3+0x6a>
  8027ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8027f0:	0f 87 9e 00 00 00    	ja     802894 <__udivdi3+0x108>
  8027f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027fb:	89 fa                	mov    %edi,%edx
  8027fd:	83 c4 1c             	add    $0x1c,%esp
  802800:	5b                   	pop    %ebx
  802801:	5e                   	pop    %esi
  802802:	5f                   	pop    %edi
  802803:	5d                   	pop    %ebp
  802804:	c3                   	ret    
  802805:	8d 76 00             	lea    0x0(%esi),%esi
  802808:	31 ff                	xor    %edi,%edi
  80280a:	31 c0                	xor    %eax,%eax
  80280c:	89 fa                	mov    %edi,%edx
  80280e:	83 c4 1c             	add    $0x1c,%esp
  802811:	5b                   	pop    %ebx
  802812:	5e                   	pop    %esi
  802813:	5f                   	pop    %edi
  802814:	5d                   	pop    %ebp
  802815:	c3                   	ret    
  802816:	66 90                	xchg   %ax,%ax
  802818:	89 d8                	mov    %ebx,%eax
  80281a:	f7 f7                	div    %edi
  80281c:	31 ff                	xor    %edi,%edi
  80281e:	89 fa                	mov    %edi,%edx
  802820:	83 c4 1c             	add    $0x1c,%esp
  802823:	5b                   	pop    %ebx
  802824:	5e                   	pop    %esi
  802825:	5f                   	pop    %edi
  802826:	5d                   	pop    %ebp
  802827:	c3                   	ret    
  802828:	bd 20 00 00 00       	mov    $0x20,%ebp
  80282d:	89 eb                	mov    %ebp,%ebx
  80282f:	29 fb                	sub    %edi,%ebx
  802831:	89 f9                	mov    %edi,%ecx
  802833:	d3 e6                	shl    %cl,%esi
  802835:	89 c5                	mov    %eax,%ebp
  802837:	88 d9                	mov    %bl,%cl
  802839:	d3 ed                	shr    %cl,%ebp
  80283b:	89 e9                	mov    %ebp,%ecx
  80283d:	09 f1                	or     %esi,%ecx
  80283f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802843:	89 f9                	mov    %edi,%ecx
  802845:	d3 e0                	shl    %cl,%eax
  802847:	89 c5                	mov    %eax,%ebp
  802849:	89 d6                	mov    %edx,%esi
  80284b:	88 d9                	mov    %bl,%cl
  80284d:	d3 ee                	shr    %cl,%esi
  80284f:	89 f9                	mov    %edi,%ecx
  802851:	d3 e2                	shl    %cl,%edx
  802853:	8b 44 24 08          	mov    0x8(%esp),%eax
  802857:	88 d9                	mov    %bl,%cl
  802859:	d3 e8                	shr    %cl,%eax
  80285b:	09 c2                	or     %eax,%edx
  80285d:	89 d0                	mov    %edx,%eax
  80285f:	89 f2                	mov    %esi,%edx
  802861:	f7 74 24 0c          	divl   0xc(%esp)
  802865:	89 d6                	mov    %edx,%esi
  802867:	89 c3                	mov    %eax,%ebx
  802869:	f7 e5                	mul    %ebp
  80286b:	39 d6                	cmp    %edx,%esi
  80286d:	72 19                	jb     802888 <__udivdi3+0xfc>
  80286f:	74 0b                	je     80287c <__udivdi3+0xf0>
  802871:	89 d8                	mov    %ebx,%eax
  802873:	31 ff                	xor    %edi,%edi
  802875:	e9 58 ff ff ff       	jmp    8027d2 <__udivdi3+0x46>
  80287a:	66 90                	xchg   %ax,%ax
  80287c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802880:	89 f9                	mov    %edi,%ecx
  802882:	d3 e2                	shl    %cl,%edx
  802884:	39 c2                	cmp    %eax,%edx
  802886:	73 e9                	jae    802871 <__udivdi3+0xe5>
  802888:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80288b:	31 ff                	xor    %edi,%edi
  80288d:	e9 40 ff ff ff       	jmp    8027d2 <__udivdi3+0x46>
  802892:	66 90                	xchg   %ax,%ax
  802894:	31 c0                	xor    %eax,%eax
  802896:	e9 37 ff ff ff       	jmp    8027d2 <__udivdi3+0x46>
  80289b:	90                   	nop

0080289c <__umoddi3>:
  80289c:	55                   	push   %ebp
  80289d:	57                   	push   %edi
  80289e:	56                   	push   %esi
  80289f:	53                   	push   %ebx
  8028a0:	83 ec 1c             	sub    $0x1c,%esp
  8028a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8028a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8028b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028bb:	89 f3                	mov    %esi,%ebx
  8028bd:	89 fa                	mov    %edi,%edx
  8028bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028c3:	89 34 24             	mov    %esi,(%esp)
  8028c6:	85 c0                	test   %eax,%eax
  8028c8:	75 1a                	jne    8028e4 <__umoddi3+0x48>
  8028ca:	39 f7                	cmp    %esi,%edi
  8028cc:	0f 86 a2 00 00 00    	jbe    802974 <__umoddi3+0xd8>
  8028d2:	89 c8                	mov    %ecx,%eax
  8028d4:	89 f2                	mov    %esi,%edx
  8028d6:	f7 f7                	div    %edi
  8028d8:	89 d0                	mov    %edx,%eax
  8028da:	31 d2                	xor    %edx,%edx
  8028dc:	83 c4 1c             	add    $0x1c,%esp
  8028df:	5b                   	pop    %ebx
  8028e0:	5e                   	pop    %esi
  8028e1:	5f                   	pop    %edi
  8028e2:	5d                   	pop    %ebp
  8028e3:	c3                   	ret    
  8028e4:	39 f0                	cmp    %esi,%eax
  8028e6:	0f 87 ac 00 00 00    	ja     802998 <__umoddi3+0xfc>
  8028ec:	0f bd e8             	bsr    %eax,%ebp
  8028ef:	83 f5 1f             	xor    $0x1f,%ebp
  8028f2:	0f 84 ac 00 00 00    	je     8029a4 <__umoddi3+0x108>
  8028f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8028fd:	29 ef                	sub    %ebp,%edi
  8028ff:	89 fe                	mov    %edi,%esi
  802901:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802905:	89 e9                	mov    %ebp,%ecx
  802907:	d3 e0                	shl    %cl,%eax
  802909:	89 d7                	mov    %edx,%edi
  80290b:	89 f1                	mov    %esi,%ecx
  80290d:	d3 ef                	shr    %cl,%edi
  80290f:	09 c7                	or     %eax,%edi
  802911:	89 e9                	mov    %ebp,%ecx
  802913:	d3 e2                	shl    %cl,%edx
  802915:	89 14 24             	mov    %edx,(%esp)
  802918:	89 d8                	mov    %ebx,%eax
  80291a:	d3 e0                	shl    %cl,%eax
  80291c:	89 c2                	mov    %eax,%edx
  80291e:	8b 44 24 08          	mov    0x8(%esp),%eax
  802922:	d3 e0                	shl    %cl,%eax
  802924:	89 44 24 04          	mov    %eax,0x4(%esp)
  802928:	8b 44 24 08          	mov    0x8(%esp),%eax
  80292c:	89 f1                	mov    %esi,%ecx
  80292e:	d3 e8                	shr    %cl,%eax
  802930:	09 d0                	or     %edx,%eax
  802932:	d3 eb                	shr    %cl,%ebx
  802934:	89 da                	mov    %ebx,%edx
  802936:	f7 f7                	div    %edi
  802938:	89 d3                	mov    %edx,%ebx
  80293a:	f7 24 24             	mull   (%esp)
  80293d:	89 c6                	mov    %eax,%esi
  80293f:	89 d1                	mov    %edx,%ecx
  802941:	39 d3                	cmp    %edx,%ebx
  802943:	0f 82 87 00 00 00    	jb     8029d0 <__umoddi3+0x134>
  802949:	0f 84 91 00 00 00    	je     8029e0 <__umoddi3+0x144>
  80294f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802953:	29 f2                	sub    %esi,%edx
  802955:	19 cb                	sbb    %ecx,%ebx
  802957:	89 d8                	mov    %ebx,%eax
  802959:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80295d:	d3 e0                	shl    %cl,%eax
  80295f:	89 e9                	mov    %ebp,%ecx
  802961:	d3 ea                	shr    %cl,%edx
  802963:	09 d0                	or     %edx,%eax
  802965:	89 e9                	mov    %ebp,%ecx
  802967:	d3 eb                	shr    %cl,%ebx
  802969:	89 da                	mov    %ebx,%edx
  80296b:	83 c4 1c             	add    $0x1c,%esp
  80296e:	5b                   	pop    %ebx
  80296f:	5e                   	pop    %esi
  802970:	5f                   	pop    %edi
  802971:	5d                   	pop    %ebp
  802972:	c3                   	ret    
  802973:	90                   	nop
  802974:	89 fd                	mov    %edi,%ebp
  802976:	85 ff                	test   %edi,%edi
  802978:	75 0b                	jne    802985 <__umoddi3+0xe9>
  80297a:	b8 01 00 00 00       	mov    $0x1,%eax
  80297f:	31 d2                	xor    %edx,%edx
  802981:	f7 f7                	div    %edi
  802983:	89 c5                	mov    %eax,%ebp
  802985:	89 f0                	mov    %esi,%eax
  802987:	31 d2                	xor    %edx,%edx
  802989:	f7 f5                	div    %ebp
  80298b:	89 c8                	mov    %ecx,%eax
  80298d:	f7 f5                	div    %ebp
  80298f:	89 d0                	mov    %edx,%eax
  802991:	e9 44 ff ff ff       	jmp    8028da <__umoddi3+0x3e>
  802996:	66 90                	xchg   %ax,%ax
  802998:	89 c8                	mov    %ecx,%eax
  80299a:	89 f2                	mov    %esi,%edx
  80299c:	83 c4 1c             	add    $0x1c,%esp
  80299f:	5b                   	pop    %ebx
  8029a0:	5e                   	pop    %esi
  8029a1:	5f                   	pop    %edi
  8029a2:	5d                   	pop    %ebp
  8029a3:	c3                   	ret    
  8029a4:	3b 04 24             	cmp    (%esp),%eax
  8029a7:	72 06                	jb     8029af <__umoddi3+0x113>
  8029a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8029ad:	77 0f                	ja     8029be <__umoddi3+0x122>
  8029af:	89 f2                	mov    %esi,%edx
  8029b1:	29 f9                	sub    %edi,%ecx
  8029b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8029b7:	89 14 24             	mov    %edx,(%esp)
  8029ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8029c2:	8b 14 24             	mov    (%esp),%edx
  8029c5:	83 c4 1c             	add    $0x1c,%esp
  8029c8:	5b                   	pop    %ebx
  8029c9:	5e                   	pop    %esi
  8029ca:	5f                   	pop    %edi
  8029cb:	5d                   	pop    %ebp
  8029cc:	c3                   	ret    
  8029cd:	8d 76 00             	lea    0x0(%esi),%esi
  8029d0:	2b 04 24             	sub    (%esp),%eax
  8029d3:	19 fa                	sbb    %edi,%edx
  8029d5:	89 d1                	mov    %edx,%ecx
  8029d7:	89 c6                	mov    %eax,%esi
  8029d9:	e9 71 ff ff ff       	jmp    80294f <__umoddi3+0xb3>
  8029de:	66 90                	xchg   %ax,%ax
  8029e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8029e4:	72 ea                	jb     8029d0 <__umoddi3+0x134>
  8029e6:	89 d9                	mov    %ebx,%ecx
  8029e8:	e9 62 ff ff ff       	jmp    80294f <__umoddi3+0xb3>
