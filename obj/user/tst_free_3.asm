
obj/user/tst_free_3:     file format elf32-i386


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
  800031:	e8 1d 14 00 00       	call   801453 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

#define numOfAccessesFor3MB 7
#define numOfAccessesFor8MB 4
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 7c 01 00 00    	sub    $0x17c,%esp



	int Mega = 1024*1024;
  800044:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)
	int kilo = 1024;
  80004b:	c7 45 d0 00 04 00 00 	movl   $0x400,-0x30(%ebp)
	char minByte = 1<<7;
  800052:	c6 45 cf 80          	movb   $0x80,-0x31(%ebp)
	char maxByte = 0x7F;
  800056:	c6 45 ce 7f          	movb   $0x7f,-0x32(%ebp)
	short minShort = 1<<15 ;
  80005a:	66 c7 45 cc 00 80    	movw   $0x8000,-0x34(%ebp)
	short maxShort = 0x7FFF;
  800060:	66 c7 45 ca ff 7f    	movw   $0x7fff,-0x36(%ebp)
	int minInt = 1<<31 ;
  800066:	c7 45 c4 00 00 00 80 	movl   $0x80000000,-0x3c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006d:	c7 45 c0 ff ff ff 7f 	movl   $0x7fffffff,-0x40(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	6a 00                	push   $0x0
  800079:	e8 4d 27 00 00       	call   8027cb <malloc>
  80007e:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800081:	a1 20 60 80 00       	mov    0x806020,%eax
  800086:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80008c:	8b 00                	mov    (%eax),%eax
  80008e:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800091:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800099:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80009e:	74 14                	je     8000b4 <_main+0x7c>
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 60 49 80 00       	push   $0x804960
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 a1 49 80 00       	push   $0x8049a1
  8000af:	e8 db 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000b4:	a1 20 60 80 00       	mov    0x806020,%eax
  8000b9:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000bf:	83 c0 18             	add    $0x18,%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8000c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8000ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000cf:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 60 49 80 00       	push   $0x804960
  8000de:	6a 21                	push   $0x21
  8000e0:	68 a1 49 80 00       	push   $0x8049a1
  8000e5:	e8 a5 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ea:	a1 20 60 80 00       	mov    0x806020,%eax
  8000ef:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000f5:	83 c0 30             	add    $0x30,%eax
  8000f8:	8b 00                	mov    (%eax),%eax
  8000fa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8000fd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800100:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800105:	3d 00 20 20 00       	cmp    $0x202000,%eax
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 60 49 80 00       	push   $0x804960
  800114:	6a 22                	push   $0x22
  800116:	68 a1 49 80 00       	push   $0x8049a1
  80011b:	e8 6f 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800120:	a1 20 60 80 00       	mov    0x806020,%eax
  800125:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80012b:	83 c0 48             	add    $0x48,%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800133:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800136:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80013b:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 60 49 80 00       	push   $0x804960
  80014a:	6a 23                	push   $0x23
  80014c:	68 a1 49 80 00       	push   $0x8049a1
  800151:	e8 39 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800156:	a1 20 60 80 00       	mov    0x806020,%eax
  80015b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800161:	83 c0 60             	add    $0x60,%eax
  800164:	8b 00                	mov    (%eax),%eax
  800166:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800169:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80016c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800171:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800176:	74 14                	je     80018c <_main+0x154>
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	68 60 49 80 00       	push   $0x804960
  800180:	6a 24                	push   $0x24
  800182:	68 a1 49 80 00       	push   $0x8049a1
  800187:	e8 03 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80018c:	a1 20 60 80 00       	mov    0x806020,%eax
  800191:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800197:	83 c0 78             	add    $0x78,%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80019f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a7:	3d 00 50 20 00       	cmp    $0x205000,%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 60 49 80 00       	push   $0x804960
  8001b6:	6a 25                	push   $0x25
  8001b8:	68 a1 49 80 00       	push   $0x8049a1
  8001bd:	e8 cd 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001c2:	a1 20 60 80 00       	mov    0x806020,%eax
  8001c7:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001cd:	05 90 00 00 00       	add    $0x90,%eax
  8001d2:	8b 00                	mov    (%eax),%eax
  8001d4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8001d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8001da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001df:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001e4:	74 14                	je     8001fa <_main+0x1c2>
  8001e6:	83 ec 04             	sub    $0x4,%esp
  8001e9:	68 60 49 80 00       	push   $0x804960
  8001ee:	6a 26                	push   $0x26
  8001f0:	68 a1 49 80 00       	push   $0x8049a1
  8001f5:	e8 95 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001fa:	a1 20 60 80 00       	mov    0x806020,%eax
  8001ff:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800205:	05 a8 00 00 00       	add    $0xa8,%eax
  80020a:	8b 00                	mov    (%eax),%eax
  80020c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80020f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800212:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800217:	3d 00 10 80 00       	cmp    $0x801000,%eax
  80021c:	74 14                	je     800232 <_main+0x1fa>
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 60 49 80 00       	push   $0x804960
  800226:	6a 27                	push   $0x27
  800228:	68 a1 49 80 00       	push   $0x8049a1
  80022d:	e8 5d 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800232:	a1 20 60 80 00       	mov    0x806020,%eax
  800237:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80023d:	05 c0 00 00 00       	add    $0xc0,%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800247:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80024a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024f:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 60 49 80 00       	push   $0x804960
  80025e:	6a 28                	push   $0x28
  800260:	68 a1 49 80 00       	push   $0x8049a1
  800265:	e8 25 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80026a:	a1 20 60 80 00       	mov    0x806020,%eax
  80026f:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800275:	05 d8 00 00 00       	add    $0xd8,%eax
  80027a:	8b 00                	mov    (%eax),%eax
  80027c:	89 45 98             	mov    %eax,-0x68(%ebp)
  80027f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800282:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800287:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 60 49 80 00       	push   $0x804960
  800296:	6a 29                	push   $0x29
  800298:	68 a1 49 80 00       	push   $0x8049a1
  80029d:	e8 ed 12 00 00       	call   80158f <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8002a7:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 b4 49 80 00       	push   $0x8049b4
  8002b9:	6a 2a                	push   $0x2a
  8002bb:	68 a1 49 80 00       	push   $0x8049a1
  8002c0:	e8 ca 12 00 00       	call   80158f <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 68 28 00 00       	call   802b32 <sys_calculate_free_frames>
  8002ca:	89 45 94             	mov    %eax,-0x6c(%ebp)

	int indicesOf3MB[numOfAccessesFor3MB];
	int indicesOf8MB[numOfAccessesFor8MB];
	int var, i, j;

	void* ptr_allocations[20] = {0};
  8002cd:	8d 95 80 fe ff ff    	lea    -0x180(%ebp),%edx
  8002d3:	b9 14 00 00 00       	mov    $0x14,%ecx
  8002d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dd:	89 d7                	mov    %edx,%edi
  8002df:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		/*ALLOCATE 2 MB*/
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002e1:	e8 ec 28 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  8002e6:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8002e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ec:	01 c0                	add    %eax,%eax
  8002ee:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002f1:	83 ec 0c             	sub    $0xc,%esp
  8002f4:	50                   	push   %eax
  8002f5:	e8 d1 24 00 00       	call   8027cb <malloc>
  8002fa:	83 c4 10             	add    $0x10,%esp
  8002fd:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800303:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800309:	85 c0                	test   %eax,%eax
  80030b:	79 0d                	jns    80031a <_main+0x2e2>
  80030d:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800313:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800318:	76 14                	jbe    80032e <_main+0x2f6>
  80031a:	83 ec 04             	sub    $0x4,%esp
  80031d:	68 fc 49 80 00       	push   $0x8049fc
  800322:	6a 39                	push   $0x39
  800324:	68 a1 49 80 00       	push   $0x8049a1
  800329:	e8 61 12 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032e:	e8 9f 28 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  800333:	2b 45 90             	sub    -0x70(%ebp),%eax
  800336:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 64 4a 80 00       	push   $0x804a64
  800345:	6a 3a                	push   $0x3a
  800347:	68 a1 49 80 00       	push   $0x8049a1
  80034c:	e8 3e 12 00 00       	call   80158f <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 7c 28 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  800356:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800359:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035c:	89 c2                	mov    %eax,%edx
  80035e:	01 d2                	add    %edx,%edx
  800360:	01 d0                	add    %edx,%eax
  800362:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800365:	83 ec 0c             	sub    $0xc,%esp
  800368:	50                   	push   %eax
  800369:	e8 5d 24 00 00       	call   8027cb <malloc>
  80036e:	83 c4 10             	add    $0x10,%esp
  800371:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800377:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80037d:	89 c2                	mov    %eax,%edx
  80037f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	05 00 00 00 80       	add    $0x80000000,%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	72 16                	jb     8003a3 <_main+0x36b>
  80038d:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800393:	89 c2                	mov    %eax,%edx
  800395:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800398:	01 c0                	add    %eax,%eax
  80039a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80039f:	39 c2                	cmp    %eax,%edx
  8003a1:	76 14                	jbe    8003b7 <_main+0x37f>
  8003a3:	83 ec 04             	sub    $0x4,%esp
  8003a6:	68 fc 49 80 00       	push   $0x8049fc
  8003ab:	6a 40                	push   $0x40
  8003ad:	68 a1 49 80 00       	push   $0x8049a1
  8003b2:	e8 d8 11 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b7:	e8 16 28 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  8003bc:	2b 45 90             	sub    -0x70(%ebp),%eax
  8003bf:	89 c2                	mov    %eax,%edx
  8003c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c4:	89 c1                	mov    %eax,%ecx
  8003c6:	01 c9                	add    %ecx,%ecx
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	79 05                	jns    8003d3 <_main+0x39b>
  8003ce:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003d3:	c1 f8 0c             	sar    $0xc,%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 64 4a 80 00       	push   $0x804a64
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 a1 49 80 00       	push   $0x8049a1
  8003e9:	e8 a1 11 00 00       	call   80158f <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ee:	e8 df 27 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  8003f3:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(8*Mega-kilo);
  8003f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003f9:	c1 e0 03             	shl    $0x3,%eax
  8003fc:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8003ff:	83 ec 0c             	sub    $0xc,%esp
  800402:	50                   	push   %eax
  800403:	e8 c3 23 00 00       	call   8027cb <malloc>
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 5*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 5*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800411:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800417:	89 c1                	mov    %eax,%ecx
  800419:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	c1 e0 02             	shl    $0x2,%eax
  800421:	01 d0                	add    %edx,%eax
  800423:	05 00 00 00 80       	add    $0x80000000,%eax
  800428:	39 c1                	cmp    %eax,%ecx
  80042a:	72 1b                	jb     800447 <_main+0x40f>
  80042c:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800432:	89 c1                	mov    %eax,%ecx
  800434:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800437:	89 d0                	mov    %edx,%eax
  800439:	c1 e0 02             	shl    $0x2,%eax
  80043c:	01 d0                	add    %edx,%eax
  80043e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800443:	39 c1                	cmp    %eax,%ecx
  800445:	76 14                	jbe    80045b <_main+0x423>
  800447:	83 ec 04             	sub    $0x4,%esp
  80044a:	68 fc 49 80 00       	push   $0x8049fc
  80044f:	6a 47                	push   $0x47
  800451:	68 a1 49 80 00       	push   $0x8049a1
  800456:	e8 34 11 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045b:	e8 72 27 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  800460:	2b 45 90             	sub    -0x70(%ebp),%eax
  800463:	89 c2                	mov    %eax,%edx
  800465:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800468:	c1 e0 03             	shl    $0x3,%eax
  80046b:	85 c0                	test   %eax,%eax
  80046d:	79 05                	jns    800474 <_main+0x43c>
  80046f:	05 ff 0f 00 00       	add    $0xfff,%eax
  800474:	c1 f8 0c             	sar    $0xc,%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <_main+0x457>
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 64 4a 80 00       	push   $0x804a64
  800483:	6a 48                	push   $0x48
  800485:	68 a1 49 80 00       	push   $0x8049a1
  80048a:	e8 00 11 00 00       	call   80158f <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 3e 27 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  800494:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(7*Mega-kilo);
  800497:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80049a:	89 d0                	mov    %edx,%eax
  80049c:	01 c0                	add    %eax,%eax
  80049e:	01 d0                	add    %edx,%eax
  8004a0:	01 c0                	add    %eax,%eax
  8004a2:	01 d0                	add    %edx,%eax
  8004a4:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8004a7:	83 ec 0c             	sub    $0xc,%esp
  8004aa:	50                   	push   %eax
  8004ab:	e8 1b 23 00 00       	call   8027cb <malloc>
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 13*Mega) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 13*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8004b9:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8004bf:	89 c1                	mov    %eax,%ecx
  8004c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004c4:	89 d0                	mov    %edx,%eax
  8004c6:	01 c0                	add    %eax,%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	c1 e0 02             	shl    $0x2,%eax
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	05 00 00 00 80       	add    $0x80000000,%eax
  8004d4:	39 c1                	cmp    %eax,%ecx
  8004d6:	72 1f                	jb     8004f7 <_main+0x4bf>
  8004d8:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8004de:	89 c1                	mov    %eax,%ecx
  8004e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004e3:	89 d0                	mov    %edx,%eax
  8004e5:	01 c0                	add    %eax,%eax
  8004e7:	01 d0                	add    %edx,%eax
  8004e9:	c1 e0 02             	shl    $0x2,%eax
  8004ec:	01 d0                	add    %edx,%eax
  8004ee:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8004f3:	39 c1                	cmp    %eax,%ecx
  8004f5:	76 14                	jbe    80050b <_main+0x4d3>
  8004f7:	83 ec 04             	sub    $0x4,%esp
  8004fa:	68 fc 49 80 00       	push   $0x8049fc
  8004ff:	6a 4e                	push   $0x4e
  800501:	68 a1 49 80 00       	push   $0x8049a1
  800506:	e8 84 10 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050b:	e8 c2 26 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  800510:	2b 45 90             	sub    -0x70(%ebp),%eax
  800513:	89 c1                	mov    %eax,%ecx
  800515:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	01 c0                	add    %eax,%eax
  800520:	01 d0                	add    %edx,%eax
  800522:	85 c0                	test   %eax,%eax
  800524:	79 05                	jns    80052b <_main+0x4f3>
  800526:	05 ff 0f 00 00       	add    $0xfff,%eax
  80052b:	c1 f8 0c             	sar    $0xc,%eax
  80052e:	39 c1                	cmp    %eax,%ecx
  800530:	74 14                	je     800546 <_main+0x50e>
  800532:	83 ec 04             	sub    $0x4,%esp
  800535:	68 64 4a 80 00       	push   $0x804a64
  80053a:	6a 4f                	push   $0x4f
  80053c:	68 a1 49 80 00       	push   $0x8049a1
  800541:	e8 49 10 00 00       	call   80158f <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800546:	e8 e7 25 00 00       	call   802b32 <sys_calculate_free_frames>
  80054b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054e:	e8 f8 25 00 00       	call   802b4b <sys_calculate_modified_frames>
  800553:	89 45 88             	mov    %eax,-0x78(%ebp)
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
  800556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800559:	89 c2                	mov    %eax,%edx
  80055b:	01 d2                	add    %edx,%edx
  80055d:	01 d0                	add    %edx,%eax
  80055f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800562:	48                   	dec    %eax
  800563:	89 45 84             	mov    %eax,-0x7c(%ebp)
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
  800566:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800569:	bf 07 00 00 00       	mov    $0x7,%edi
  80056e:	99                   	cltd   
  80056f:	f7 ff                	idiv   %edi
  800571:	89 45 80             	mov    %eax,-0x80(%ebp)
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  800574:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80057b:	eb 16                	jmp    800593 <_main+0x55b>
		{
			indicesOf3MB[var] = var * inc ;
  80057d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800580:	0f af 45 80          	imul   -0x80(%ebp),%eax
  800584:	89 c2                	mov    %eax,%edx
  800586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800589:	89 94 85 e0 fe ff ff 	mov    %edx,-0x120(%ebp,%eax,4)
		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
		int modFrames = sys_calculate_modified_frames();
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  800590:	ff 45 e4             	incl   -0x1c(%ebp)
  800593:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800597:	7e e4                	jle    80057d <_main+0x545>
		{
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
  800599:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80059f:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		//3 reads
		int sum = 0;
  8005a5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005ac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005b3:	eb 1f                	jmp    8005d4 <_main+0x59c>
		{
			sum += byteArr[indicesOf3MB[var]] ;
  8005b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005b8:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8005bf:	89 c2                	mov    %eax,%edx
  8005c1:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005c7:	01 d0                	add    %edx,%eax
  8005c9:	8a 00                	mov    (%eax),%al
  8005cb:	0f be c0             	movsbl %al,%eax
  8005ce:	01 45 dc             	add    %eax,-0x24(%ebp)
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
		//3 reads
		int sum = 0;
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005d1:	ff 45 e4             	incl   -0x1c(%ebp)
  8005d4:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  8005d8:	7e db                	jle    8005b5 <_main+0x57d>
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  8005da:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  8005e1:	eb 1c                	jmp    8005ff <_main+0x5c7>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
  8005e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005e6:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8005ed:	89 c2                	mov    %eax,%edx
  8005ef:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f5:	01 c2                	add    %eax,%edx
  8005f7:	8a 45 ce             	mov    -0x32(%ebp),%al
  8005fa:	88 02                	mov    %al,(%edx)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  8005fc:	ff 45 e4             	incl   -0x1c(%ebp)
  8005ff:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800603:	7e de                	jle    8005e3 <_main+0x5ab>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800605:	8b 55 8c             	mov    -0x74(%ebp),%edx
  800608:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	89 c6                	mov    %eax,%esi
  80060f:	e8 1e 25 00 00       	call   802b32 <sys_calculate_free_frames>
  800614:	89 c3                	mov    %eax,%ebx
  800616:	e8 30 25 00 00       	call   802b4b <sys_calculate_modified_frames>
  80061b:	01 d8                	add    %ebx,%eax
  80061d:	29 c6                	sub    %eax,%esi
  80061f:	89 f0                	mov    %esi,%eax
  800621:	83 f8 02             	cmp    $0x2,%eax
  800624:	74 14                	je     80063a <_main+0x602>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 94 4a 80 00       	push   $0x804a94
  80062e:	6a 67                	push   $0x67
  800630:	68 a1 49 80 00       	push   $0x8049a1
  800635:	e8 55 0f 00 00       	call   80158f <_panic>
		int found = 0;
  80063a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  800641:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800648:	eb 78                	jmp    8006c2 <_main+0x68a>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80064a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800651:	eb 5d                	jmp    8006b0 <_main+0x678>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  800653:	a1 20 60 80 00       	mov    0x806020,%eax
  800658:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80065e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800661:	89 d0                	mov    %edx,%eax
  800663:	01 c0                	add    %eax,%eax
  800665:	01 d0                	add    %edx,%eax
  800667:	c1 e0 03             	shl    $0x3,%eax
  80066a:	01 c8                	add    %ecx,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800674:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80067a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80067f:	89 c2                	mov    %eax,%edx
  800681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800684:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  80068b:	89 c1                	mov    %eax,%ecx
  80068d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800693:	01 c8                	add    %ecx,%eax
  800695:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  80069b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	75 03                	jne    8006ad <_main+0x675>
				{
					found++;
  8006aa:	ff 45 d8             	incl   -0x28(%ebp)
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8006ad:	ff 45 e0             	incl   -0x20(%ebp)
  8006b0:	a1 20 60 80 00       	mov    0x806020,%eax
  8006b5:	8b 50 74             	mov    0x74(%eax),%edx
  8006b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006bb:	39 c2                	cmp    %eax,%edx
  8006bd:	77 94                	ja     800653 <_main+0x61b>
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  8006bf:	ff 45 e4             	incl   -0x1c(%ebp)
  8006c2:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8006c6:	7e 82                	jle    80064a <_main+0x612>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor3MB) panic("malloc: page is not added to WS");
  8006c8:	83 7d d8 07          	cmpl   $0x7,-0x28(%ebp)
  8006cc:	74 14                	je     8006e2 <_main+0x6aa>
  8006ce:	83 ec 04             	sub    $0x4,%esp
  8006d1:	68 d8 4a 80 00       	push   $0x804ad8
  8006d6:	6a 73                	push   $0x73
  8006d8:	68 a1 49 80 00       	push   $0x8049a1
  8006dd:	e8 ad 0e 00 00       	call   80158f <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e2:	e8 4b 24 00 00       	call   802b32 <sys_calculate_free_frames>
  8006e7:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006ea:	e8 5c 24 00 00       	call   802b4b <sys_calculate_modified_frames>
  8006ef:	89 45 88             	mov    %eax,-0x78(%ebp)
		lastIndexOfShort = (8*Mega-kilo)/sizeof(short) - 1;
  8006f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f5:	c1 e0 03             	shl    $0x3,%eax
  8006f8:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8006fb:	d1 e8                	shr    %eax
  8006fd:	48                   	dec    %eax
  8006fe:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		indicesOf8MB[0] = lastIndexOfShort * 1 / 2;
  800704:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80070a:	89 c2                	mov    %eax,%edx
  80070c:	c1 ea 1f             	shr    $0x1f,%edx
  80070f:	01 d0                	add    %edx,%eax
  800711:	d1 f8                	sar    %eax
  800713:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
		indicesOf8MB[1] = lastIndexOfShort * 2 / 3;
  800719:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80071f:	01 c0                	add    %eax,%eax
  800721:	89 c1                	mov    %eax,%ecx
  800723:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800728:	f7 e9                	imul   %ecx
  80072a:	c1 f9 1f             	sar    $0x1f,%ecx
  80072d:	89 d0                	mov    %edx,%eax
  80072f:	29 c8                	sub    %ecx,%eax
  800731:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
		indicesOf8MB[2] = lastIndexOfShort * 3 / 4;
  800737:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80073d:	89 c2                	mov    %eax,%edx
  80073f:	01 d2                	add    %edx,%edx
  800741:	01 d0                	add    %edx,%eax
  800743:	85 c0                	test   %eax,%eax
  800745:	79 03                	jns    80074a <_main+0x712>
  800747:	83 c0 03             	add    $0x3,%eax
  80074a:	c1 f8 02             	sar    $0x2,%eax
  80074d:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
		indicesOf8MB[3] = lastIndexOfShort ;
  800753:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800759:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)

		//use one of the read pages from 3 MB to avoid victimizing it
		sum += byteArr[indicesOf3MB[0]] ;
  80075f:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800765:	89 c2                	mov    %eax,%edx
  800767:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80076d:	01 d0                	add    %edx,%eax
  80076f:	8a 00                	mov    (%eax),%al
  800771:	0f be c0             	movsbl %al,%eax
  800774:	01 45 dc             	add    %eax,-0x24(%ebp)

		shortArr = (short *) ptr_allocations[2];
  800777:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  80077d:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		//2 reads
		sum = 0;
  800783:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  80078a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800791:	eb 20                	jmp    8007b3 <_main+0x77b>
		{
			sum += shortArr[indicesOf8MB[var]] ;
  800793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800796:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  80079d:	01 c0                	add    %eax,%eax
  80079f:	89 c2                	mov    %eax,%edx
  8007a1:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007a7:	01 d0                	add    %edx,%eax
  8007a9:	66 8b 00             	mov    (%eax),%ax
  8007ac:	98                   	cwtl   
  8007ad:	01 45 dc             	add    %eax,-0x24(%ebp)
		sum += byteArr[indicesOf3MB[0]] ;

		shortArr = (short *) ptr_allocations[2];
		//2 reads
		sum = 0;
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  8007b0:	ff 45 e4             	incl   -0x1c(%ebp)
  8007b3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8007b7:	7e da                	jle    800793 <_main+0x75b>
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007b9:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  8007c0:	eb 20                	jmp    8007e2 <_main+0x7aa>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
  8007c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007c5:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  8007cc:	01 c0                	add    %eax,%eax
  8007ce:	89 c2                	mov    %eax,%edx
  8007d0:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007d6:	01 c2                	add    %eax,%edx
  8007d8:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  8007dc:	66 89 02             	mov    %ax,(%edx)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007df:	ff 45 e4             	incl   -0x1c(%ebp)
  8007e2:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8007e6:	7e da                	jle    8007c2 <_main+0x78a>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007e8:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8007eb:	e8 42 23 00 00       	call   802b32 <sys_calculate_free_frames>
  8007f0:	29 c3                	sub    %eax,%ebx
  8007f2:	89 d8                	mov    %ebx,%eax
  8007f4:	83 f8 04             	cmp    $0x4,%eax
  8007f7:	74 17                	je     800810 <_main+0x7d8>
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 94 4a 80 00       	push   $0x804a94
  800801:	68 8e 00 00 00       	push   $0x8e
  800806:	68 a1 49 80 00       	push   $0x8049a1
  80080b:	e8 7f 0d 00 00       	call   80158f <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800810:	8b 5d 88             	mov    -0x78(%ebp),%ebx
  800813:	e8 33 23 00 00       	call   802b4b <sys_calculate_modified_frames>
  800818:	29 c3                	sub    %eax,%ebx
  80081a:	89 d8                	mov    %ebx,%eax
  80081c:	83 f8 fe             	cmp    $0xfffffffe,%eax
  80081f:	74 17                	je     800838 <_main+0x800>
  800821:	83 ec 04             	sub    $0x4,%esp
  800824:	68 94 4a 80 00       	push   $0x804a94
  800829:	68 8f 00 00 00       	push   $0x8f
  80082e:	68 a1 49 80 00       	push   $0x8049a1
  800833:	e8 57 0d 00 00       	call   80158f <_panic>
		found = 0;
  800838:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  80083f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800846:	eb 7a                	jmp    8008c2 <_main+0x88a>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  800848:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80084f:	eb 5f                	jmp    8008b0 <_main+0x878>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[indicesOf8MB[var]])), PAGE_SIZE))
  800851:	a1 20 60 80 00       	mov    0x806020,%eax
  800856:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80085c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80085f:	89 d0                	mov    %edx,%eax
  800861:	01 c0                	add    %eax,%eax
  800863:	01 d0                	add    %edx,%eax
  800865:	c1 e0 03             	shl    $0x3,%eax
  800868:	01 c8                	add    %ecx,%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800872:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800878:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087d:	89 c2                	mov    %eax,%edx
  80087f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800882:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  800889:	01 c0                	add    %eax,%eax
  80088b:	89 c1                	mov    %eax,%ecx
  80088d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800893:	01 c8                	add    %ecx,%eax
  800895:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80089b:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8008a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	75 03                	jne    8008ad <_main+0x875>
				{
					found++;
  8008aa:	ff 45 d8             	incl   -0x28(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8008ad:	ff 45 e0             	incl   -0x20(%ebp)
  8008b0:	a1 20 60 80 00       	mov    0x806020,%eax
  8008b5:	8b 50 74             	mov    0x74(%eax),%edx
  8008b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008bb:	39 c2                	cmp    %eax,%edx
  8008bd:	77 92                	ja     800851 <_main+0x819>
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  8008bf:	ff 45 e4             	incl   -0x1c(%ebp)
  8008c2:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8008c6:	7e 80                	jle    800848 <_main+0x810>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor8MB) panic("malloc: page is not added to WS");
  8008c8:	83 7d d8 04          	cmpl   $0x4,-0x28(%ebp)
  8008cc:	74 17                	je     8008e5 <_main+0x8ad>
  8008ce:	83 ec 04             	sub    $0x4,%esp
  8008d1:	68 d8 4a 80 00       	push   $0x804ad8
  8008d6:	68 9b 00 00 00       	push   $0x9b
  8008db:	68 a1 49 80 00       	push   $0x8049a1
  8008e0:	e8 aa 0c 00 00       	call   80158f <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008e5:	e8 48 22 00 00       	call   802b32 <sys_calculate_free_frames>
  8008ea:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008ed:	e8 59 22 00 00       	call   802b4b <sys_calculate_modified_frames>
  8008f2:	89 45 88             	mov    %eax,-0x78(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008f5:	e8 d8 22 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  8008fa:	89 45 90             	mov    %eax,-0x70(%ebp)

		free(ptr_allocations[1]);
  8008fd:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800903:	83 ec 0c             	sub    $0xc,%esp
  800906:	50                   	push   %eax
  800907:	e8 3a 1f 00 00       	call   802846 <free>
  80090c:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80090f:	e8 be 22 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  800914:	8b 55 90             	mov    -0x70(%ebp),%edx
  800917:	89 d1                	mov    %edx,%ecx
  800919:	29 c1                	sub    %eax,%ecx
  80091b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80091e:	89 c2                	mov    %eax,%edx
  800920:	01 d2                	add    %edx,%edx
  800922:	01 d0                	add    %edx,%eax
  800924:	85 c0                	test   %eax,%eax
  800926:	79 05                	jns    80092d <_main+0x8f5>
  800928:	05 ff 0f 00 00       	add    $0xfff,%eax
  80092d:	c1 f8 0c             	sar    $0xc,%eax
  800930:	39 c1                	cmp    %eax,%ecx
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 f8 4a 80 00       	push   $0x804af8
  80093c:	68 a5 00 00 00       	push   $0xa5
  800941:	68 a1 49 80 00       	push   $0x8049a1
  800946:	e8 44 0c 00 00       	call   80158f <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  80094b:	e8 e2 21 00 00       	call   802b32 <sys_calculate_free_frames>
  800950:	89 c2                	mov    %eax,%edx
  800952:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800955:	29 c2                	sub    %eax,%edx
  800957:	89 d0                	mov    %edx,%eax
  800959:	83 f8 07             	cmp    $0x7,%eax
  80095c:	74 17                	je     800975 <_main+0x93d>
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	68 34 4b 80 00       	push   $0x804b34
  800966:	68 a7 00 00 00       	push   $0xa7
  80096b:	68 a1 49 80 00       	push   $0x8049a1
  800970:	e8 1a 0c 00 00       	call   80158f <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800975:	e8 d1 21 00 00       	call   802b4b <sys_calculate_modified_frames>
  80097a:	89 c2                	mov    %eax,%edx
  80097c:	8b 45 88             	mov    -0x78(%ebp),%eax
  80097f:	29 c2                	sub    %eax,%edx
  800981:	89 d0                	mov    %edx,%eax
  800983:	83 f8 02             	cmp    $0x2,%eax
  800986:	74 17                	je     80099f <_main+0x967>
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 88 4b 80 00       	push   $0x804b88
  800990:	68 a8 00 00 00       	push   $0xa8
  800995:	68 a1 49 80 00       	push   $0x8049a1
  80099a:	e8 f0 0b 00 00       	call   80158f <_panic>
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  80099f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8009a6:	e9 8c 00 00 00       	jmp    800a37 <_main+0x9ff>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8009ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009b2:	eb 71                	jmp    800a25 <_main+0x9ed>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  8009b4:	a1 20 60 80 00       	mov    0x806020,%eax
  8009b9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c2:	89 d0                	mov    %edx,%eax
  8009c4:	01 c0                	add    %eax,%eax
  8009c6:	01 d0                	add    %edx,%eax
  8009c8:	c1 e0 03             	shl    $0x3,%eax
  8009cb:	01 c8                	add    %ecx,%eax
  8009cd:	8b 00                	mov    (%eax),%eax
  8009cf:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  8009d5:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8009db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009e0:	89 c2                	mov    %eax,%edx
  8009e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009e5:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8009ec:	89 c1                	mov    %eax,%ecx
  8009ee:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8009f4:	01 c8                	add    %ecx,%eax
  8009f6:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  8009fc:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a07:	39 c2                	cmp    %eax,%edx
  800a09:	75 17                	jne    800a22 <_main+0x9ea>
				{
					panic("free: page is not removed from WS");
  800a0b:	83 ec 04             	sub    $0x4,%esp
  800a0e:	68 c0 4b 80 00       	push   $0x804bc0
  800a13:	68 b0 00 00 00       	push   $0xb0
  800a18:	68 a1 49 80 00       	push   $0x8049a1
  800a1d:	e8 6d 0b 00 00       	call   80158f <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  800a22:	ff 45 e0             	incl   -0x20(%ebp)
  800a25:	a1 20 60 80 00       	mov    0x806020,%eax
  800a2a:	8b 50 74             	mov    0x74(%eax),%edx
  800a2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a30:	39 c2                	cmp    %eax,%edx
  800a32:	77 80                	ja     8009b4 <_main+0x97c>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  800a34:	ff 45 e4             	incl   -0x1c(%ebp)
  800a37:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800a3b:	0f 8e 6a ff ff ff    	jle    8009ab <_main+0x973>
			}
		}



		freeFrames = sys_calculate_free_frames() ;
  800a41:	e8 ec 20 00 00       	call   802b32 <sys_calculate_free_frames>
  800a46:	89 45 8c             	mov    %eax,-0x74(%ebp)
		shortArr = (short *) ptr_allocations[2];
  800a49:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800a4f:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800a55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a58:	01 c0                	add    %eax,%eax
  800a5a:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800a5d:	d1 e8                	shr    %eax
  800a5f:	48                   	dec    %eax
  800a60:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		shortArr[0] = minShort;
  800a66:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  800a6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a6f:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800a72:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800a78:	01 c0                	add    %eax,%eax
  800a7a:	89 c2                	mov    %eax,%edx
  800a7c:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a82:	01 c2                	add    %eax,%edx
  800a84:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  800a88:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a8b:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  800a8e:	e8 9f 20 00 00       	call   802b32 <sys_calculate_free_frames>
  800a93:	29 c3                	sub    %eax,%ebx
  800a95:	89 d8                	mov    %ebx,%eax
  800a97:	83 f8 02             	cmp    $0x2,%eax
  800a9a:	74 17                	je     800ab3 <_main+0xa7b>
  800a9c:	83 ec 04             	sub    $0x4,%esp
  800a9f:	68 94 4a 80 00       	push   $0x804a94
  800aa4:	68 bc 00 00 00       	push   $0xbc
  800aa9:	68 a1 49 80 00       	push   $0x8049a1
  800aae:	e8 dc 0a 00 00       	call   80158f <_panic>
		found = 0;
  800ab3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800aba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ac1:	e9 a7 00 00 00       	jmp    800b6d <_main+0xb35>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800ac6:	a1 20 60 80 00       	mov    0x806020,%eax
  800acb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ad4:	89 d0                	mov    %edx,%eax
  800ad6:	01 c0                	add    %eax,%eax
  800ad8:	01 d0                	add    %edx,%eax
  800ada:	c1 e0 03             	shl    $0x3,%eax
  800add:	01 c8                	add    %ecx,%eax
  800adf:	8b 00                	mov    (%eax),%eax
  800ae1:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800ae7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800aed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af2:	89 c2                	mov    %eax,%edx
  800af4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800afa:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b00:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	75 03                	jne    800b12 <_main+0xada>
				found++;
  800b0f:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  800b12:	a1 20 60 80 00       	mov    0x806020,%eax
  800b17:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b20:	89 d0                	mov    %edx,%eax
  800b22:	01 c0                	add    %eax,%eax
  800b24:	01 d0                	add    %edx,%eax
  800b26:	c1 e0 03             	shl    $0x3,%eax
  800b29:	01 c8                	add    %ecx,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b33:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b3e:	89 c2                	mov    %eax,%edx
  800b40:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800b46:	01 c0                	add    %eax,%eax
  800b48:	89 c1                	mov    %eax,%ecx
  800b4a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b50:	01 c8                	add    %ecx,%eax
  800b52:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b58:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b63:	39 c2                	cmp    %eax,%edx
  800b65:	75 03                	jne    800b6a <_main+0xb32>
				found++;
  800b67:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800b6a:	ff 45 e4             	incl   -0x1c(%ebp)
  800b6d:	a1 20 60 80 00       	mov    0x806020,%eax
  800b72:	8b 50 74             	mov    0x74(%eax),%edx
  800b75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b78:	39 c2                	cmp    %eax,%edx
  800b7a:	0f 87 46 ff ff ff    	ja     800ac6 <_main+0xa8e>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800b80:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800b84:	74 17                	je     800b9d <_main+0xb65>
  800b86:	83 ec 04             	sub    $0x4,%esp
  800b89:	68 d8 4a 80 00       	push   $0x804ad8
  800b8e:	68 c5 00 00 00       	push   $0xc5
  800b93:	68 a1 49 80 00       	push   $0x8049a1
  800b98:	e8 f2 09 00 00       	call   80158f <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b9d:	e8 30 20 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  800ba2:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800ba5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ba8:	01 c0                	add    %eax,%eax
  800baa:	83 ec 0c             	sub    $0xc,%esp
  800bad:	50                   	push   %eax
  800bae:	e8 18 1c 00 00       	call   8027cb <malloc>
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800bbc:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800bc2:	89 c2                	mov    %eax,%edx
  800bc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bc7:	c1 e0 02             	shl    $0x2,%eax
  800bca:	05 00 00 00 80       	add    $0x80000000,%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	72 17                	jb     800bea <_main+0xbb2>
  800bd3:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800bd9:	89 c2                	mov    %eax,%edx
  800bdb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bde:	c1 e0 02             	shl    $0x2,%eax
  800be1:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800be6:	39 c2                	cmp    %eax,%edx
  800be8:	76 17                	jbe    800c01 <_main+0xbc9>
  800bea:	83 ec 04             	sub    $0x4,%esp
  800bed:	68 fc 49 80 00       	push   $0x8049fc
  800bf2:	68 ca 00 00 00       	push   $0xca
  800bf7:	68 a1 49 80 00       	push   $0x8049a1
  800bfc:	e8 8e 09 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800c01:	e8 cc 1f 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  800c06:	2b 45 90             	sub    -0x70(%ebp),%eax
  800c09:	83 f8 01             	cmp    $0x1,%eax
  800c0c:	74 17                	je     800c25 <_main+0xbed>
  800c0e:	83 ec 04             	sub    $0x4,%esp
  800c11:	68 64 4a 80 00       	push   $0x804a64
  800c16:	68 cb 00 00 00       	push   $0xcb
  800c1b:	68 a1 49 80 00       	push   $0x8049a1
  800c20:	e8 6a 09 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c25:	e8 08 1f 00 00       	call   802b32 <sys_calculate_free_frames>
  800c2a:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr = (int *) ptr_allocations[2];
  800c2d:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800c33:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  800c39:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c3c:	01 c0                	add    %eax,%eax
  800c3e:	c1 e8 02             	shr    $0x2,%eax
  800c41:	48                   	dec    %eax
  800c42:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
		intArr[0] = minInt;
  800c48:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c4e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800c51:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  800c53:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800c59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c60:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c66:	01 c2                	add    %eax,%edx
  800c68:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6b:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800c6d:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  800c70:	e8 bd 1e 00 00       	call   802b32 <sys_calculate_free_frames>
  800c75:	29 c3                	sub    %eax,%ebx
  800c77:	89 d8                	mov    %ebx,%eax
  800c79:	83 f8 02             	cmp    $0x2,%eax
  800c7c:	74 17                	je     800c95 <_main+0xc5d>
  800c7e:	83 ec 04             	sub    $0x4,%esp
  800c81:	68 94 4a 80 00       	push   $0x804a94
  800c86:	68 d2 00 00 00       	push   $0xd2
  800c8b:	68 a1 49 80 00       	push   $0x8049a1
  800c90:	e8 fa 08 00 00       	call   80158f <_panic>
		found = 0;
  800c95:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800c9c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ca3:	e9 aa 00 00 00       	jmp    800d52 <_main+0xd1a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800ca8:	a1 20 60 80 00       	mov    0x806020,%eax
  800cad:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800cb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800cb6:	89 d0                	mov    %edx,%eax
  800cb8:	01 c0                	add    %eax,%eax
  800cba:	01 d0                	add    %edx,%eax
  800cbc:	c1 e0 03             	shl    $0x3,%eax
  800cbf:	01 c8                	add    %ecx,%eax
  800cc1:	8b 00                	mov    (%eax),%eax
  800cc3:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800cc9:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800ccf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800cd4:	89 c2                	mov    %eax,%edx
  800cd6:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800cdc:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800ce2:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800ce8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ced:	39 c2                	cmp    %eax,%edx
  800cef:	75 03                	jne    800cf4 <_main+0xcbc>
				found++;
  800cf1:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800cf4:	a1 20 60 80 00       	mov    0x806020,%eax
  800cf9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800cff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d02:	89 d0                	mov    %edx,%eax
  800d04:	01 c0                	add    %eax,%eax
  800d06:	01 d0                	add    %edx,%eax
  800d08:	c1 e0 03             	shl    $0x3,%eax
  800d0b:	01 c8                	add    %ecx,%eax
  800d0d:	8b 00                	mov    (%eax),%eax
  800d0f:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d15:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d20:	89 c2                	mov    %eax,%edx
  800d22:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800d28:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d2f:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800d35:	01 c8                	add    %ecx,%eax
  800d37:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d3d:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d48:	39 c2                	cmp    %eax,%edx
  800d4a:	75 03                	jne    800d4f <_main+0xd17>
				found++;
  800d4c:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d4f:	ff 45 e4             	incl   -0x1c(%ebp)
  800d52:	a1 20 60 80 00       	mov    0x806020,%eax
  800d57:	8b 50 74             	mov    0x74(%eax),%edx
  800d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d5d:	39 c2                	cmp    %eax,%edx
  800d5f:	0f 87 43 ff ff ff    	ja     800ca8 <_main+0xc70>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800d65:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800d69:	74 17                	je     800d82 <_main+0xd4a>
  800d6b:	83 ec 04             	sub    $0x4,%esp
  800d6e:	68 d8 4a 80 00       	push   $0x804ad8
  800d73:	68 db 00 00 00       	push   $0xdb
  800d78:	68 a1 49 80 00       	push   $0x8049a1
  800d7d:	e8 0d 08 00 00       	call   80158f <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d82:	e8 ab 1d 00 00       	call   802b32 <sys_calculate_free_frames>
  800d87:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d8a:	e8 43 1e 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  800d8f:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800d92:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d95:	01 c0                	add    %eax,%eax
  800d97:	83 ec 0c             	sub    $0xc,%esp
  800d9a:	50                   	push   %eax
  800d9b:	e8 2b 1a 00 00       	call   8027cb <malloc>
  800da0:	83 c4 10             	add    $0x10,%esp
  800da3:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800da9:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800daf:	89 c2                	mov    %eax,%edx
  800db1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800db4:	c1 e0 02             	shl    $0x2,%eax
  800db7:	89 c1                	mov    %eax,%ecx
  800db9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800dbc:	c1 e0 02             	shl    $0x2,%eax
  800dbf:	01 c8                	add    %ecx,%eax
  800dc1:	05 00 00 00 80       	add    $0x80000000,%eax
  800dc6:	39 c2                	cmp    %eax,%edx
  800dc8:	72 21                	jb     800deb <_main+0xdb3>
  800dca:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800dd0:	89 c2                	mov    %eax,%edx
  800dd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dd5:	c1 e0 02             	shl    $0x2,%eax
  800dd8:	89 c1                	mov    %eax,%ecx
  800dda:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ddd:	c1 e0 02             	shl    $0x2,%eax
  800de0:	01 c8                	add    %ecx,%eax
  800de2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800de7:	39 c2                	cmp    %eax,%edx
  800de9:	76 17                	jbe    800e02 <_main+0xdca>
  800deb:	83 ec 04             	sub    $0x4,%esp
  800dee:	68 fc 49 80 00       	push   $0x8049fc
  800df3:	68 e1 00 00 00       	push   $0xe1
  800df8:	68 a1 49 80 00       	push   $0x8049a1
  800dfd:	e8 8d 07 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800e02:	e8 cb 1d 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  800e07:	2b 45 90             	sub    -0x70(%ebp),%eax
  800e0a:	83 f8 01             	cmp    $0x1,%eax
  800e0d:	74 17                	je     800e26 <_main+0xdee>
  800e0f:	83 ec 04             	sub    $0x4,%esp
  800e12:	68 64 4a 80 00       	push   $0x804a64
  800e17:	68 e2 00 00 00       	push   $0xe2
  800e1c:	68 a1 49 80 00       	push   $0x8049a1
  800e21:	e8 69 07 00 00       	call   80158f <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e26:	e8 a7 1d 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  800e2b:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800e2e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	01 c0                	add    %eax,%eax
  800e35:	01 d0                	add    %edx,%eax
  800e37:	01 c0                	add    %eax,%eax
  800e39:	01 d0                	add    %edx,%eax
  800e3b:	83 ec 0c             	sub    $0xc,%esp
  800e3e:	50                   	push   %eax
  800e3f:	e8 87 19 00 00       	call   8027cb <malloc>
  800e44:	83 c4 10             	add    $0x10,%esp
  800e47:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800e4d:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800e53:	89 c2                	mov    %eax,%edx
  800e55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e58:	c1 e0 02             	shl    $0x2,%eax
  800e5b:	89 c1                	mov    %eax,%ecx
  800e5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e60:	c1 e0 03             	shl    $0x3,%eax
  800e63:	01 c8                	add    %ecx,%eax
  800e65:	05 00 00 00 80       	add    $0x80000000,%eax
  800e6a:	39 c2                	cmp    %eax,%edx
  800e6c:	72 21                	jb     800e8f <_main+0xe57>
  800e6e:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800e74:	89 c2                	mov    %eax,%edx
  800e76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e79:	c1 e0 02             	shl    $0x2,%eax
  800e7c:	89 c1                	mov    %eax,%ecx
  800e7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e81:	c1 e0 03             	shl    $0x3,%eax
  800e84:	01 c8                	add    %ecx,%eax
  800e86:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800e8b:	39 c2                	cmp    %eax,%edx
  800e8d:	76 17                	jbe    800ea6 <_main+0xe6e>
  800e8f:	83 ec 04             	sub    $0x4,%esp
  800e92:	68 fc 49 80 00       	push   $0x8049fc
  800e97:	68 e8 00 00 00       	push   $0xe8
  800e9c:	68 a1 49 80 00       	push   $0x8049a1
  800ea1:	e8 e9 06 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800ea6:	e8 27 1d 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  800eab:	2b 45 90             	sub    -0x70(%ebp),%eax
  800eae:	83 f8 02             	cmp    $0x2,%eax
  800eb1:	74 17                	je     800eca <_main+0xe92>
  800eb3:	83 ec 04             	sub    $0x4,%esp
  800eb6:	68 64 4a 80 00       	push   $0x804a64
  800ebb:	68 e9 00 00 00       	push   $0xe9
  800ec0:	68 a1 49 80 00       	push   $0x8049a1
  800ec5:	e8 c5 06 00 00       	call   80158f <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800eca:	e8 63 1c 00 00       	call   802b32 <sys_calculate_free_frames>
  800ecf:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800ed2:	e8 fb 1c 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  800ed7:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800eda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800edd:	89 c2                	mov    %eax,%edx
  800edf:	01 d2                	add    %edx,%edx
  800ee1:	01 d0                	add    %edx,%eax
  800ee3:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800ee6:	83 ec 0c             	sub    $0xc,%esp
  800ee9:	50                   	push   %eax
  800eea:	e8 dc 18 00 00       	call   8027cb <malloc>
  800eef:	83 c4 10             	add    $0x10,%esp
  800ef2:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800ef8:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  800efe:	89 c2                	mov    %eax,%edx
  800f00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f03:	c1 e0 02             	shl    $0x2,%eax
  800f06:	89 c1                	mov    %eax,%ecx
  800f08:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f0b:	c1 e0 04             	shl    $0x4,%eax
  800f0e:	01 c8                	add    %ecx,%eax
  800f10:	05 00 00 00 80       	add    $0x80000000,%eax
  800f15:	39 c2                	cmp    %eax,%edx
  800f17:	72 21                	jb     800f3a <_main+0xf02>
  800f19:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  800f1f:	89 c2                	mov    %eax,%edx
  800f21:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f24:	c1 e0 02             	shl    $0x2,%eax
  800f27:	89 c1                	mov    %eax,%ecx
  800f29:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f2c:	c1 e0 04             	shl    $0x4,%eax
  800f2f:	01 c8                	add    %ecx,%eax
  800f31:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800f36:	39 c2                	cmp    %eax,%edx
  800f38:	76 17                	jbe    800f51 <_main+0xf19>
  800f3a:	83 ec 04             	sub    $0x4,%esp
  800f3d:	68 fc 49 80 00       	push   $0x8049fc
  800f42:	68 f0 00 00 00       	push   $0xf0
  800f47:	68 a1 49 80 00       	push   $0x8049a1
  800f4c:	e8 3e 06 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f51:	e8 7c 1c 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  800f56:	2b 45 90             	sub    -0x70(%ebp),%eax
  800f59:	89 c2                	mov    %eax,%edx
  800f5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f5e:	89 c1                	mov    %eax,%ecx
  800f60:	01 c9                	add    %ecx,%ecx
  800f62:	01 c8                	add    %ecx,%eax
  800f64:	85 c0                	test   %eax,%eax
  800f66:	79 05                	jns    800f6d <_main+0xf35>
  800f68:	05 ff 0f 00 00       	add    $0xfff,%eax
  800f6d:	c1 f8 0c             	sar    $0xc,%eax
  800f70:	39 c2                	cmp    %eax,%edx
  800f72:	74 17                	je     800f8b <_main+0xf53>
  800f74:	83 ec 04             	sub    $0x4,%esp
  800f77:	68 64 4a 80 00       	push   $0x804a64
  800f7c:	68 f1 00 00 00       	push   $0xf1
  800f81:	68 a1 49 80 00       	push   $0x8049a1
  800f86:	e8 04 06 00 00       	call   80158f <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8b:	e8 42 1c 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  800f90:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  800f93:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f96:	89 d0                	mov    %edx,%eax
  800f98:	01 c0                	add    %eax,%eax
  800f9a:	01 d0                	add    %edx,%eax
  800f9c:	01 c0                	add    %eax,%eax
  800f9e:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800fa1:	83 ec 0c             	sub    $0xc,%esp
  800fa4:	50                   	push   %eax
  800fa5:	e8 21 18 00 00       	call   8027cb <malloc>
  800faa:	83 c4 10             	add    $0x10,%esp
  800fad:	89 85 98 fe ff ff    	mov    %eax,-0x168(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800fb3:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  800fb9:	89 c1                	mov    %eax,%ecx
  800fbb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fbe:	89 d0                	mov    %edx,%eax
  800fc0:	01 c0                	add    %eax,%eax
  800fc2:	01 d0                	add    %edx,%eax
  800fc4:	01 c0                	add    %eax,%eax
  800fc6:	01 d0                	add    %edx,%eax
  800fc8:	89 c2                	mov    %eax,%edx
  800fca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fcd:	c1 e0 04             	shl    $0x4,%eax
  800fd0:	01 d0                	add    %edx,%eax
  800fd2:	05 00 00 00 80       	add    $0x80000000,%eax
  800fd7:	39 c1                	cmp    %eax,%ecx
  800fd9:	72 28                	jb     801003 <_main+0xfcb>
  800fdb:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  800fe1:	89 c1                	mov    %eax,%ecx
  800fe3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fe6:	89 d0                	mov    %edx,%eax
  800fe8:	01 c0                	add    %eax,%eax
  800fea:	01 d0                	add    %edx,%eax
  800fec:	01 c0                	add    %eax,%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	89 c2                	mov    %eax,%edx
  800ff2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ff5:	c1 e0 04             	shl    $0x4,%eax
  800ff8:	01 d0                	add    %edx,%eax
  800ffa:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800fff:	39 c1                	cmp    %eax,%ecx
  801001:	76 17                	jbe    80101a <_main+0xfe2>
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	68 fc 49 80 00       	push   $0x8049fc
  80100b:	68 f7 00 00 00       	push   $0xf7
  801010:	68 a1 49 80 00       	push   $0x8049a1
  801015:	e8 75 05 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  80101a:	e8 b3 1b 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  80101f:	2b 45 90             	sub    -0x70(%ebp),%eax
  801022:	89 c1                	mov    %eax,%ecx
  801024:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801027:	89 d0                	mov    %edx,%eax
  801029:	01 c0                	add    %eax,%eax
  80102b:	01 d0                	add    %edx,%eax
  80102d:	01 c0                	add    %eax,%eax
  80102f:	85 c0                	test   %eax,%eax
  801031:	79 05                	jns    801038 <_main+0x1000>
  801033:	05 ff 0f 00 00       	add    $0xfff,%eax
  801038:	c1 f8 0c             	sar    $0xc,%eax
  80103b:	39 c1                	cmp    %eax,%ecx
  80103d:	74 17                	je     801056 <_main+0x101e>
  80103f:	83 ec 04             	sub    $0x4,%esp
  801042:	68 64 4a 80 00       	push   $0x804a64
  801047:	68 f8 00 00 00       	push   $0xf8
  80104c:	68 a1 49 80 00       	push   $0x8049a1
  801051:	e8 39 05 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801056:	e8 d7 1a 00 00       	call   802b32 <sys_calculate_free_frames>
  80105b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  80105e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801061:	89 d0                	mov    %edx,%eax
  801063:	01 c0                	add    %eax,%eax
  801065:	01 d0                	add    %edx,%eax
  801067:	01 c0                	add    %eax,%eax
  801069:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80106c:	48                   	dec    %eax
  80106d:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  801073:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  801079:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
		byteArr2[0] = minByte ;
  80107f:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  801085:	8a 55 cf             	mov    -0x31(%ebp),%dl
  801088:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  80108a:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  801090:	89 c2                	mov    %eax,%edx
  801092:	c1 ea 1f             	shr    $0x1f,%edx
  801095:	01 d0                	add    %edx,%eax
  801097:	d1 f8                	sar    %eax
  801099:	89 c2                	mov    %eax,%edx
  80109b:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010a1:	01 c2                	add    %eax,%edx
  8010a3:	8a 45 ce             	mov    -0x32(%ebp),%al
  8010a6:	88 c1                	mov    %al,%cl
  8010a8:	c0 e9 07             	shr    $0x7,%cl
  8010ab:	01 c8                	add    %ecx,%eax
  8010ad:	d0 f8                	sar    %al
  8010af:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  8010b1:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  8010b7:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010bd:	01 c2                	add    %eax,%edx
  8010bf:	8a 45 ce             	mov    -0x32(%ebp),%al
  8010c2:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8010c4:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8010c7:	e8 66 1a 00 00       	call   802b32 <sys_calculate_free_frames>
  8010cc:	29 c3                	sub    %eax,%ebx
  8010ce:	89 d8                	mov    %ebx,%eax
  8010d0:	83 f8 05             	cmp    $0x5,%eax
  8010d3:	74 17                	je     8010ec <_main+0x10b4>
  8010d5:	83 ec 04             	sub    $0x4,%esp
  8010d8:	68 94 4a 80 00       	push   $0x804a94
  8010dd:	68 00 01 00 00       	push   $0x100
  8010e2:	68 a1 49 80 00       	push   $0x8049a1
  8010e7:	e8 a3 04 00 00       	call   80158f <_panic>
		found = 0;
  8010ec:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8010f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8010fa:	e9 02 01 00 00       	jmp    801201 <_main+0x11c9>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  8010ff:	a1 20 60 80 00       	mov    0x806020,%eax
  801104:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80110a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80110d:	89 d0                	mov    %edx,%eax
  80110f:	01 c0                	add    %eax,%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	c1 e0 03             	shl    $0x3,%eax
  801116:	01 c8                	add    %ecx,%eax
  801118:	8b 00                	mov    (%eax),%eax
  80111a:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  801120:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  801126:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80112b:	89 c2                	mov    %eax,%edx
  80112d:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  801133:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  801139:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80113f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801144:	39 c2                	cmp    %eax,%edx
  801146:	75 03                	jne    80114b <_main+0x1113>
				found++;
  801148:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  80114b:	a1 20 60 80 00       	mov    0x806020,%eax
  801150:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801156:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801159:	89 d0                	mov    %edx,%eax
  80115b:	01 c0                	add    %eax,%eax
  80115d:	01 d0                	add    %edx,%eax
  80115f:	c1 e0 03             	shl    $0x3,%eax
  801162:	01 c8                	add    %ecx,%eax
  801164:	8b 00                	mov    (%eax),%eax
  801166:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  80116c:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  801172:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801177:	89 c2                	mov    %eax,%edx
  801179:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  80117f:	89 c1                	mov    %eax,%ecx
  801181:	c1 e9 1f             	shr    $0x1f,%ecx
  801184:	01 c8                	add    %ecx,%eax
  801186:	d1 f8                	sar    %eax
  801188:	89 c1                	mov    %eax,%ecx
  80118a:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  801190:	01 c8                	add    %ecx,%eax
  801192:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  801198:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  80119e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011a3:	39 c2                	cmp    %eax,%edx
  8011a5:	75 03                	jne    8011aa <_main+0x1172>
				found++;
  8011a7:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  8011aa:	a1 20 60 80 00       	mov    0x806020,%eax
  8011af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8011b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011b8:	89 d0                	mov    %edx,%eax
  8011ba:	01 c0                	add    %eax,%eax
  8011bc:	01 d0                	add    %edx,%eax
  8011be:	c1 e0 03             	shl    $0x3,%eax
  8011c1:	01 c8                	add    %ecx,%eax
  8011c3:	8b 00                	mov    (%eax),%eax
  8011c5:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  8011cb:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  8011d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011d6:	89 c1                	mov    %eax,%ecx
  8011d8:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  8011de:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  8011ec:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8011f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011f7:	39 c1                	cmp    %eax,%ecx
  8011f9:	75 03                	jne    8011fe <_main+0x11c6>
				found++;
  8011fb:	ff 45 d8             	incl   -0x28(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8011fe:	ff 45 e4             	incl   -0x1c(%ebp)
  801201:	a1 20 60 80 00       	mov    0x806020,%eax
  801206:	8b 50 74             	mov    0x74(%eax),%edx
  801209:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80120c:	39 c2                	cmp    %eax,%edx
  80120e:	0f 87 eb fe ff ff    	ja     8010ff <_main+0x10c7>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  801214:	83 7d d8 03          	cmpl   $0x3,-0x28(%ebp)
  801218:	74 17                	je     801231 <_main+0x11f9>
  80121a:	83 ec 04             	sub    $0x4,%esp
  80121d:	68 d8 4a 80 00       	push   $0x804ad8
  801222:	68 0b 01 00 00       	push   $0x10b
  801227:	68 a1 49 80 00       	push   $0x8049a1
  80122c:	e8 5e 03 00 00       	call   80158f <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801231:	e8 9c 19 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  801236:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  801239:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80123c:	89 d0                	mov    %edx,%eax
  80123e:	01 c0                	add    %eax,%eax
  801240:	01 d0                	add    %edx,%eax
  801242:	01 c0                	add    %eax,%eax
  801244:	01 d0                	add    %edx,%eax
  801246:	01 c0                	add    %eax,%eax
  801248:	83 ec 0c             	sub    $0xc,%esp
  80124b:	50                   	push   %eax
  80124c:	e8 7a 15 00 00       	call   8027cb <malloc>
  801251:	83 c4 10             	add    $0x10,%esp
  801254:	89 85 9c fe ff ff    	mov    %eax,-0x164(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80125a:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  801260:	89 c1                	mov    %eax,%ecx
  801262:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801265:	89 d0                	mov    %edx,%eax
  801267:	01 c0                	add    %eax,%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	c1 e0 02             	shl    $0x2,%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	89 c2                	mov    %eax,%edx
  801272:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801275:	c1 e0 04             	shl    $0x4,%eax
  801278:	01 d0                	add    %edx,%eax
  80127a:	05 00 00 00 80       	add    $0x80000000,%eax
  80127f:	39 c1                	cmp    %eax,%ecx
  801281:	72 29                	jb     8012ac <_main+0x1274>
  801283:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  801289:	89 c1                	mov    %eax,%ecx
  80128b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80128e:	89 d0                	mov    %edx,%eax
  801290:	01 c0                	add    %eax,%eax
  801292:	01 d0                	add    %edx,%eax
  801294:	c1 e0 02             	shl    $0x2,%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	89 c2                	mov    %eax,%edx
  80129b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80129e:	c1 e0 04             	shl    $0x4,%eax
  8012a1:	01 d0                	add    %edx,%eax
  8012a3:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8012a8:	39 c1                	cmp    %eax,%ecx
  8012aa:	76 17                	jbe    8012c3 <_main+0x128b>
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 fc 49 80 00       	push   $0x8049fc
  8012b4:	68 10 01 00 00       	push   $0x110
  8012b9:	68 a1 49 80 00       	push   $0x8049a1
  8012be:	e8 cc 02 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012c3:	e8 0a 19 00 00       	call   802bd2 <sys_pf_calculate_allocated_pages>
  8012c8:	2b 45 90             	sub    -0x70(%ebp),%eax
  8012cb:	83 f8 04             	cmp    $0x4,%eax
  8012ce:	74 17                	je     8012e7 <_main+0x12af>
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	68 64 4a 80 00       	push   $0x804a64
  8012d8:	68 11 01 00 00       	push   $0x111
  8012dd:	68 a1 49 80 00       	push   $0x8049a1
  8012e2:	e8 a8 02 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8012e7:	e8 46 18 00 00       	call   802b32 <sys_calculate_free_frames>
  8012ec:	89 45 8c             	mov    %eax,-0x74(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  8012ef:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  8012f5:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  8012fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	01 c0                	add    %eax,%eax
  801302:	01 d0                	add    %edx,%eax
  801304:	01 c0                	add    %eax,%eax
  801306:	01 d0                	add    %edx,%eax
  801308:	01 c0                	add    %eax,%eax
  80130a:	d1 e8                	shr    %eax
  80130c:	48                   	dec    %eax
  80130d:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		shortArr2[0] = minShort;
  801313:	8b 95 10 ff ff ff    	mov    -0xf0(%ebp),%edx
  801319:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80131c:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  80131f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801325:	01 c0                	add    %eax,%eax
  801327:	89 c2                	mov    %eax,%edx
  801329:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  80132f:	01 c2                	add    %eax,%edx
  801331:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  801335:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  801338:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  80133b:	e8 f2 17 00 00       	call   802b32 <sys_calculate_free_frames>
  801340:	29 c3                	sub    %eax,%ebx
  801342:	89 d8                	mov    %ebx,%eax
  801344:	83 f8 02             	cmp    $0x2,%eax
  801347:	74 17                	je     801360 <_main+0x1328>
  801349:	83 ec 04             	sub    $0x4,%esp
  80134c:	68 94 4a 80 00       	push   $0x804a94
  801351:	68 18 01 00 00       	push   $0x118
  801356:	68 a1 49 80 00       	push   $0x8049a1
  80135b:	e8 2f 02 00 00       	call   80158f <_panic>
		found = 0;
  801360:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801367:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80136e:	e9 a7 00 00 00       	jmp    80141a <_main+0x13e2>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  801373:	a1 20 60 80 00       	mov    0x806020,%eax
  801378:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80137e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801381:	89 d0                	mov    %edx,%eax
  801383:	01 c0                	add    %eax,%eax
  801385:	01 d0                	add    %edx,%eax
  801387:	c1 e0 03             	shl    $0x3,%eax
  80138a:	01 c8                	add    %ecx,%eax
  80138c:	8b 00                	mov    (%eax),%eax
  80138e:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  801394:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80139a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80139f:	89 c2                	mov    %eax,%edx
  8013a1:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8013a7:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  8013ad:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  8013b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b8:	39 c2                	cmp    %eax,%edx
  8013ba:	75 03                	jne    8013bf <_main+0x1387>
				found++;
  8013bc:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  8013bf:	a1 20 60 80 00       	mov    0x806020,%eax
  8013c4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8013ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013cd:	89 d0                	mov    %edx,%eax
  8013cf:	01 c0                	add    %eax,%eax
  8013d1:	01 d0                	add    %edx,%eax
  8013d3:	c1 e0 03             	shl    $0x3,%eax
  8013d6:	01 c8                	add    %ecx,%eax
  8013d8:	8b 00                	mov    (%eax),%eax
  8013da:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  8013e0:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  8013e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013eb:	89 c2                	mov    %eax,%edx
  8013ed:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  8013f3:	01 c0                	add    %eax,%eax
  8013f5:	89 c1                	mov    %eax,%ecx
  8013f7:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8013fd:	01 c8                	add    %ecx,%eax
  8013ff:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  801405:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  80140b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801410:	39 c2                	cmp    %eax,%edx
  801412:	75 03                	jne    801417 <_main+0x13df>
				found++;
  801414:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801417:	ff 45 e4             	incl   -0x1c(%ebp)
  80141a:	a1 20 60 80 00       	mov    0x806020,%eax
  80141f:	8b 50 74             	mov    0x74(%eax),%edx
  801422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801425:	39 c2                	cmp    %eax,%edx
  801427:	0f 87 46 ff ff ff    	ja     801373 <_main+0x133b>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80142d:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  801431:	74 17                	je     80144a <_main+0x1412>
  801433:	83 ec 04             	sub    $0x4,%esp
  801436:	68 d8 4a 80 00       	push   $0x804ad8
  80143b:	68 21 01 00 00       	push   $0x121
  801440:	68 a1 49 80 00       	push   $0x8049a1
  801445:	e8 45 01 00 00       	call   80158f <_panic>
		if(start_freeFrames != (sys_calculate_free_frames() + 4)) {panic("Wrong free: not all pages removed correctly at end");}
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
	 */
	return;
  80144a:	90                   	nop
}
  80144b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144e:	5b                   	pop    %ebx
  80144f:	5e                   	pop    %esi
  801450:	5f                   	pop    %edi
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    

00801453 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801459:	e8 b4 19 00 00       	call   802e12 <sys_getenvindex>
  80145e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  801461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801464:	89 d0                	mov    %edx,%eax
  801466:	c1 e0 03             	shl    $0x3,%eax
  801469:	01 d0                	add    %edx,%eax
  80146b:	01 c0                	add    %eax,%eax
  80146d:	01 d0                	add    %edx,%eax
  80146f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801476:	01 d0                	add    %edx,%eax
  801478:	c1 e0 04             	shl    $0x4,%eax
  80147b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801480:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801485:	a1 20 60 80 00       	mov    0x806020,%eax
  80148a:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  801490:	84 c0                	test   %al,%al
  801492:	74 0f                	je     8014a3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  801494:	a1 20 60 80 00       	mov    0x806020,%eax
  801499:	05 5c 05 00 00       	add    $0x55c,%eax
  80149e:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8014a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a7:	7e 0a                	jle    8014b3 <libmain+0x60>
		binaryname = argv[0];
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  8014b3:	83 ec 08             	sub    $0x8,%esp
  8014b6:	ff 75 0c             	pushl  0xc(%ebp)
  8014b9:	ff 75 08             	pushl  0x8(%ebp)
  8014bc:	e8 77 eb ff ff       	call   800038 <_main>
  8014c1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8014c4:	e8 56 17 00 00       	call   802c1f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8014c9:	83 ec 0c             	sub    $0xc,%esp
  8014cc:	68 fc 4b 80 00       	push   $0x804bfc
  8014d1:	e8 6d 03 00 00       	call   801843 <cprintf>
  8014d6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8014d9:	a1 20 60 80 00       	mov    0x806020,%eax
  8014de:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8014e4:	a1 20 60 80 00       	mov    0x806020,%eax
  8014e9:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	52                   	push   %edx
  8014f3:	50                   	push   %eax
  8014f4:	68 24 4c 80 00       	push   $0x804c24
  8014f9:	e8 45 03 00 00       	call   801843 <cprintf>
  8014fe:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801501:	a1 20 60 80 00       	mov    0x806020,%eax
  801506:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80150c:	a1 20 60 80 00       	mov    0x806020,%eax
  801511:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  801517:	a1 20 60 80 00       	mov    0x806020,%eax
  80151c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  801522:	51                   	push   %ecx
  801523:	52                   	push   %edx
  801524:	50                   	push   %eax
  801525:	68 4c 4c 80 00       	push   $0x804c4c
  80152a:	e8 14 03 00 00       	call   801843 <cprintf>
  80152f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801532:	a1 20 60 80 00       	mov    0x806020,%eax
  801537:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80153d:	83 ec 08             	sub    $0x8,%esp
  801540:	50                   	push   %eax
  801541:	68 a4 4c 80 00       	push   $0x804ca4
  801546:	e8 f8 02 00 00       	call   801843 <cprintf>
  80154b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80154e:	83 ec 0c             	sub    $0xc,%esp
  801551:	68 fc 4b 80 00       	push   $0x804bfc
  801556:	e8 e8 02 00 00       	call   801843 <cprintf>
  80155b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80155e:	e8 d6 16 00 00       	call   802c39 <sys_enable_interrupt>

	// exit gracefully
	exit();
  801563:	e8 19 00 00 00       	call   801581 <exit>
}
  801568:	90                   	nop
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801571:	83 ec 0c             	sub    $0xc,%esp
  801574:	6a 00                	push   $0x0
  801576:	e8 63 18 00 00       	call   802dde <sys_destroy_env>
  80157b:	83 c4 10             	add    $0x10,%esp
}
  80157e:	90                   	nop
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <exit>:

void
exit(void)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801587:	e8 b8 18 00 00       	call   802e44 <sys_exit_env>
}
  80158c:	90                   	nop
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801595:	8d 45 10             	lea    0x10(%ebp),%eax
  801598:	83 c0 04             	add    $0x4,%eax
  80159b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80159e:	a1 5c 61 80 00       	mov    0x80615c,%eax
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	74 16                	je     8015bd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8015a7:	a1 5c 61 80 00       	mov    0x80615c,%eax
  8015ac:	83 ec 08             	sub    $0x8,%esp
  8015af:	50                   	push   %eax
  8015b0:	68 b8 4c 80 00       	push   $0x804cb8
  8015b5:	e8 89 02 00 00       	call   801843 <cprintf>
  8015ba:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8015bd:	a1 00 60 80 00       	mov    0x806000,%eax
  8015c2:	ff 75 0c             	pushl  0xc(%ebp)
  8015c5:	ff 75 08             	pushl  0x8(%ebp)
  8015c8:	50                   	push   %eax
  8015c9:	68 bd 4c 80 00       	push   $0x804cbd
  8015ce:	e8 70 02 00 00       	call   801843 <cprintf>
  8015d3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8015d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d9:	83 ec 08             	sub    $0x8,%esp
  8015dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8015df:	50                   	push   %eax
  8015e0:	e8 f3 01 00 00       	call   8017d8 <vcprintf>
  8015e5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8015e8:	83 ec 08             	sub    $0x8,%esp
  8015eb:	6a 00                	push   $0x0
  8015ed:	68 d9 4c 80 00       	push   $0x804cd9
  8015f2:	e8 e1 01 00 00       	call   8017d8 <vcprintf>
  8015f7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8015fa:	e8 82 ff ff ff       	call   801581 <exit>

	// should not return here
	while (1) ;
  8015ff:	eb fe                	jmp    8015ff <_panic+0x70>

00801601 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801607:	a1 20 60 80 00       	mov    0x806020,%eax
  80160c:	8b 50 74             	mov    0x74(%eax),%edx
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	39 c2                	cmp    %eax,%edx
  801614:	74 14                	je     80162a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801616:	83 ec 04             	sub    $0x4,%esp
  801619:	68 dc 4c 80 00       	push   $0x804cdc
  80161e:	6a 26                	push   $0x26
  801620:	68 28 4d 80 00       	push   $0x804d28
  801625:	e8 65 ff ff ff       	call   80158f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80162a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801631:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801638:	e9 c2 00 00 00       	jmp    8016ff <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80163d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801640:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	01 d0                	add    %edx,%eax
  80164c:	8b 00                	mov    (%eax),%eax
  80164e:	85 c0                	test   %eax,%eax
  801650:	75 08                	jne    80165a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801652:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801655:	e9 a2 00 00 00       	jmp    8016fc <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80165a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801661:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801668:	eb 69                	jmp    8016d3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80166a:	a1 20 60 80 00       	mov    0x806020,%eax
  80166f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801675:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801678:	89 d0                	mov    %edx,%eax
  80167a:	01 c0                	add    %eax,%eax
  80167c:	01 d0                	add    %edx,%eax
  80167e:	c1 e0 03             	shl    $0x3,%eax
  801681:	01 c8                	add    %ecx,%eax
  801683:	8a 40 04             	mov    0x4(%eax),%al
  801686:	84 c0                	test   %al,%al
  801688:	75 46                	jne    8016d0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80168a:	a1 20 60 80 00       	mov    0x806020,%eax
  80168f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801695:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801698:	89 d0                	mov    %edx,%eax
  80169a:	01 c0                	add    %eax,%eax
  80169c:	01 d0                	add    %edx,%eax
  80169e:	c1 e0 03             	shl    $0x3,%eax
  8016a1:	01 c8                	add    %ecx,%eax
  8016a3:	8b 00                	mov    (%eax),%eax
  8016a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8016b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	01 c8                	add    %ecx,%eax
  8016c1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016c3:	39 c2                	cmp    %eax,%edx
  8016c5:	75 09                	jne    8016d0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8016c7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8016ce:	eb 12                	jmp    8016e2 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016d0:	ff 45 e8             	incl   -0x18(%ebp)
  8016d3:	a1 20 60 80 00       	mov    0x806020,%eax
  8016d8:	8b 50 74             	mov    0x74(%eax),%edx
  8016db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016de:	39 c2                	cmp    %eax,%edx
  8016e0:	77 88                	ja     80166a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8016e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016e6:	75 14                	jne    8016fc <CheckWSWithoutLastIndex+0xfb>
			panic(
  8016e8:	83 ec 04             	sub    $0x4,%esp
  8016eb:	68 34 4d 80 00       	push   $0x804d34
  8016f0:	6a 3a                	push   $0x3a
  8016f2:	68 28 4d 80 00       	push   $0x804d28
  8016f7:	e8 93 fe ff ff       	call   80158f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8016fc:	ff 45 f0             	incl   -0x10(%ebp)
  8016ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801702:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801705:	0f 8c 32 ff ff ff    	jl     80163d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80170b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801712:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801719:	eb 26                	jmp    801741 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80171b:	a1 20 60 80 00       	mov    0x806020,%eax
  801720:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801726:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801729:	89 d0                	mov    %edx,%eax
  80172b:	01 c0                	add    %eax,%eax
  80172d:	01 d0                	add    %edx,%eax
  80172f:	c1 e0 03             	shl    $0x3,%eax
  801732:	01 c8                	add    %ecx,%eax
  801734:	8a 40 04             	mov    0x4(%eax),%al
  801737:	3c 01                	cmp    $0x1,%al
  801739:	75 03                	jne    80173e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80173b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80173e:	ff 45 e0             	incl   -0x20(%ebp)
  801741:	a1 20 60 80 00       	mov    0x806020,%eax
  801746:	8b 50 74             	mov    0x74(%eax),%edx
  801749:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80174c:	39 c2                	cmp    %eax,%edx
  80174e:	77 cb                	ja     80171b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801753:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801756:	74 14                	je     80176c <CheckWSWithoutLastIndex+0x16b>
		panic(
  801758:	83 ec 04             	sub    $0x4,%esp
  80175b:	68 88 4d 80 00       	push   $0x804d88
  801760:	6a 44                	push   $0x44
  801762:	68 28 4d 80 00       	push   $0x804d28
  801767:	e8 23 fe ff ff       	call   80158f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80176c:	90                   	nop
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801775:	8b 45 0c             	mov    0xc(%ebp),%eax
  801778:	8b 00                	mov    (%eax),%eax
  80177a:	8d 48 01             	lea    0x1(%eax),%ecx
  80177d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801780:	89 0a                	mov    %ecx,(%edx)
  801782:	8b 55 08             	mov    0x8(%ebp),%edx
  801785:	88 d1                	mov    %dl,%cl
  801787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80178e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801791:	8b 00                	mov    (%eax),%eax
  801793:	3d ff 00 00 00       	cmp    $0xff,%eax
  801798:	75 2c                	jne    8017c6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80179a:	a0 24 60 80 00       	mov    0x806024,%al
  80179f:	0f b6 c0             	movzbl %al,%eax
  8017a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a5:	8b 12                	mov    (%edx),%edx
  8017a7:	89 d1                	mov    %edx,%ecx
  8017a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ac:	83 c2 08             	add    $0x8,%edx
  8017af:	83 ec 04             	sub    $0x4,%esp
  8017b2:	50                   	push   %eax
  8017b3:	51                   	push   %ecx
  8017b4:	52                   	push   %edx
  8017b5:	e8 b7 12 00 00       	call   802a71 <sys_cputs>
  8017ba:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8017bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	8b 40 04             	mov    0x4(%eax),%eax
  8017cc:	8d 50 01             	lea    0x1(%eax),%edx
  8017cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8017d5:	90                   	nop
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8017e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8017e8:	00 00 00 
	b.cnt = 0;
  8017eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8017f2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8017f5:	ff 75 0c             	pushl  0xc(%ebp)
  8017f8:	ff 75 08             	pushl  0x8(%ebp)
  8017fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801801:	50                   	push   %eax
  801802:	68 6f 17 80 00       	push   $0x80176f
  801807:	e8 11 02 00 00       	call   801a1d <vprintfmt>
  80180c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80180f:	a0 24 60 80 00       	mov    0x806024,%al
  801814:	0f b6 c0             	movzbl %al,%eax
  801817:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	50                   	push   %eax
  801821:	52                   	push   %edx
  801822:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801828:	83 c0 08             	add    $0x8,%eax
  80182b:	50                   	push   %eax
  80182c:	e8 40 12 00 00       	call   802a71 <sys_cputs>
  801831:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801834:	c6 05 24 60 80 00 00 	movb   $0x0,0x806024
	return b.cnt;
  80183b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <cprintf>:

int cprintf(const char *fmt, ...) {
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801849:	c6 05 24 60 80 00 01 	movb   $0x1,0x806024
	va_start(ap, fmt);
  801850:	8d 45 0c             	lea    0xc(%ebp),%eax
  801853:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	83 ec 08             	sub    $0x8,%esp
  80185c:	ff 75 f4             	pushl  -0xc(%ebp)
  80185f:	50                   	push   %eax
  801860:	e8 73 ff ff ff       	call   8017d8 <vcprintf>
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80186b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801876:	e8 a4 13 00 00       	call   802c1f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80187b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80187e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	83 ec 08             	sub    $0x8,%esp
  801887:	ff 75 f4             	pushl  -0xc(%ebp)
  80188a:	50                   	push   %eax
  80188b:	e8 48 ff ff ff       	call   8017d8 <vcprintf>
  801890:	83 c4 10             	add    $0x10,%esp
  801893:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801896:	e8 9e 13 00 00       	call   802c39 <sys_enable_interrupt>
	return cnt;
  80189b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 14             	sub    $0x14,%esp
  8018a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8018b3:	8b 45 18             	mov    0x18(%ebp),%eax
  8018b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018be:	77 55                	ja     801915 <printnum+0x75>
  8018c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018c3:	72 05                	jb     8018ca <printnum+0x2a>
  8018c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018c8:	77 4b                	ja     801915 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8018ca:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8018cd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8018d0:	8b 45 18             	mov    0x18(%ebp),%eax
  8018d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d8:	52                   	push   %edx
  8018d9:	50                   	push   %eax
  8018da:	ff 75 f4             	pushl  -0xc(%ebp)
  8018dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e0:	e8 0f 2e 00 00       	call   8046f4 <__udivdi3>
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	83 ec 04             	sub    $0x4,%esp
  8018eb:	ff 75 20             	pushl  0x20(%ebp)
  8018ee:	53                   	push   %ebx
  8018ef:	ff 75 18             	pushl  0x18(%ebp)
  8018f2:	52                   	push   %edx
  8018f3:	50                   	push   %eax
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	ff 75 08             	pushl  0x8(%ebp)
  8018fa:	e8 a1 ff ff ff       	call   8018a0 <printnum>
  8018ff:	83 c4 20             	add    $0x20,%esp
  801902:	eb 1a                	jmp    80191e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801904:	83 ec 08             	sub    $0x8,%esp
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	ff 75 20             	pushl  0x20(%ebp)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	ff d0                	call   *%eax
  801912:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801915:	ff 4d 1c             	decl   0x1c(%ebp)
  801918:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80191c:	7f e6                	jg     801904 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80191e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801921:	bb 00 00 00 00       	mov    $0x0,%ebx
  801926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80192c:	53                   	push   %ebx
  80192d:	51                   	push   %ecx
  80192e:	52                   	push   %edx
  80192f:	50                   	push   %eax
  801930:	e8 cf 2e 00 00       	call   804804 <__umoddi3>
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	05 f4 4f 80 00       	add    $0x804ff4,%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	0f be c0             	movsbl %al,%eax
  801942:	83 ec 08             	sub    $0x8,%esp
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	50                   	push   %eax
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	ff d0                	call   *%eax
  80194e:	83 c4 10             	add    $0x10,%esp
}
  801951:	90                   	nop
  801952:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80195a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80195e:	7e 1c                	jle    80197c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	8b 00                	mov    (%eax),%eax
  801965:	8d 50 08             	lea    0x8(%eax),%edx
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	89 10                	mov    %edx,(%eax)
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	83 e8 08             	sub    $0x8,%eax
  801975:	8b 50 04             	mov    0x4(%eax),%edx
  801978:	8b 00                	mov    (%eax),%eax
  80197a:	eb 40                	jmp    8019bc <getuint+0x65>
	else if (lflag)
  80197c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801980:	74 1e                	je     8019a0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	8b 00                	mov    (%eax),%eax
  801987:	8d 50 04             	lea    0x4(%eax),%edx
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	89 10                	mov    %edx,(%eax)
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	8b 00                	mov    (%eax),%eax
  801994:	83 e8 04             	sub    $0x4,%eax
  801997:	8b 00                	mov    (%eax),%eax
  801999:	ba 00 00 00 00       	mov    $0x0,%edx
  80199e:	eb 1c                	jmp    8019bc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	8b 00                	mov    (%eax),%eax
  8019a5:	8d 50 04             	lea    0x4(%eax),%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	89 10                	mov    %edx,(%eax)
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	8b 00                	mov    (%eax),%eax
  8019b2:	83 e8 04             	sub    $0x4,%eax
  8019b5:	8b 00                	mov    (%eax),%eax
  8019b7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019bc:	5d                   	pop    %ebp
  8019bd:	c3                   	ret    

008019be <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019c1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019c5:	7e 1c                	jle    8019e3 <getint+0x25>
		return va_arg(*ap, long long);
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8b 00                	mov    (%eax),%eax
  8019cc:	8d 50 08             	lea    0x8(%eax),%edx
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	89 10                	mov    %edx,(%eax)
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	8b 00                	mov    (%eax),%eax
  8019d9:	83 e8 08             	sub    $0x8,%eax
  8019dc:	8b 50 04             	mov    0x4(%eax),%edx
  8019df:	8b 00                	mov    (%eax),%eax
  8019e1:	eb 38                	jmp    801a1b <getint+0x5d>
	else if (lflag)
  8019e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019e7:	74 1a                	je     801a03 <getint+0x45>
		return va_arg(*ap, long);
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8b 00                	mov    (%eax),%eax
  8019ee:	8d 50 04             	lea    0x4(%eax),%edx
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	89 10                	mov    %edx,(%eax)
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8b 00                	mov    (%eax),%eax
  8019fb:	83 e8 04             	sub    $0x4,%eax
  8019fe:	8b 00                	mov    (%eax),%eax
  801a00:	99                   	cltd   
  801a01:	eb 18                	jmp    801a1b <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	8b 00                	mov    (%eax),%eax
  801a08:	8d 50 04             	lea    0x4(%eax),%edx
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	89 10                	mov    %edx,(%eax)
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	8b 00                	mov    (%eax),%eax
  801a15:	83 e8 04             	sub    $0x4,%eax
  801a18:	8b 00                	mov    (%eax),%eax
  801a1a:	99                   	cltd   
}
  801a1b:	5d                   	pop    %ebp
  801a1c:	c3                   	ret    

00801a1d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	56                   	push   %esi
  801a21:	53                   	push   %ebx
  801a22:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a25:	eb 17                	jmp    801a3e <vprintfmt+0x21>
			if (ch == '\0')
  801a27:	85 db                	test   %ebx,%ebx
  801a29:	0f 84 af 03 00 00    	je     801dde <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801a2f:	83 ec 08             	sub    $0x8,%esp
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	53                   	push   %ebx
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	ff d0                	call   *%eax
  801a3b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a41:	8d 50 01             	lea    0x1(%eax),%edx
  801a44:	89 55 10             	mov    %edx,0x10(%ebp)
  801a47:	8a 00                	mov    (%eax),%al
  801a49:	0f b6 d8             	movzbl %al,%ebx
  801a4c:	83 fb 25             	cmp    $0x25,%ebx
  801a4f:	75 d6                	jne    801a27 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801a51:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801a55:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801a5c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801a63:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801a6a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a71:	8b 45 10             	mov    0x10(%ebp),%eax
  801a74:	8d 50 01             	lea    0x1(%eax),%edx
  801a77:	89 55 10             	mov    %edx,0x10(%ebp)
  801a7a:	8a 00                	mov    (%eax),%al
  801a7c:	0f b6 d8             	movzbl %al,%ebx
  801a7f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801a82:	83 f8 55             	cmp    $0x55,%eax
  801a85:	0f 87 2b 03 00 00    	ja     801db6 <vprintfmt+0x399>
  801a8b:	8b 04 85 18 50 80 00 	mov    0x805018(,%eax,4),%eax
  801a92:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801a94:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801a98:	eb d7                	jmp    801a71 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801a9a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801a9e:	eb d1                	jmp    801a71 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801aa0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801aa7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801aaa:	89 d0                	mov    %edx,%eax
  801aac:	c1 e0 02             	shl    $0x2,%eax
  801aaf:	01 d0                	add    %edx,%eax
  801ab1:	01 c0                	add    %eax,%eax
  801ab3:	01 d8                	add    %ebx,%eax
  801ab5:	83 e8 30             	sub    $0x30,%eax
  801ab8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801abb:	8b 45 10             	mov    0x10(%ebp),%eax
  801abe:	8a 00                	mov    (%eax),%al
  801ac0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801ac3:	83 fb 2f             	cmp    $0x2f,%ebx
  801ac6:	7e 3e                	jle    801b06 <vprintfmt+0xe9>
  801ac8:	83 fb 39             	cmp    $0x39,%ebx
  801acb:	7f 39                	jg     801b06 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801acd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801ad0:	eb d5                	jmp    801aa7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801ad2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad5:	83 c0 04             	add    $0x4,%eax
  801ad8:	89 45 14             	mov    %eax,0x14(%ebp)
  801adb:	8b 45 14             	mov    0x14(%ebp),%eax
  801ade:	83 e8 04             	sub    $0x4,%eax
  801ae1:	8b 00                	mov    (%eax),%eax
  801ae3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801ae6:	eb 1f                	jmp    801b07 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801ae8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801aec:	79 83                	jns    801a71 <vprintfmt+0x54>
				width = 0;
  801aee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801af5:	e9 77 ff ff ff       	jmp    801a71 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801afa:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b01:	e9 6b ff ff ff       	jmp    801a71 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b06:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b0b:	0f 89 60 ff ff ff    	jns    801a71 <vprintfmt+0x54>
				width = precision, precision = -1;
  801b11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b17:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b1e:	e9 4e ff ff ff       	jmp    801a71 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b23:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b26:	e9 46 ff ff ff       	jmp    801a71 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2e:	83 c0 04             	add    $0x4,%eax
  801b31:	89 45 14             	mov    %eax,0x14(%ebp)
  801b34:	8b 45 14             	mov    0x14(%ebp),%eax
  801b37:	83 e8 04             	sub    $0x4,%eax
  801b3a:	8b 00                	mov    (%eax),%eax
  801b3c:	83 ec 08             	sub    $0x8,%esp
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	50                   	push   %eax
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	ff d0                	call   *%eax
  801b48:	83 c4 10             	add    $0x10,%esp
			break;
  801b4b:	e9 89 02 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b50:	8b 45 14             	mov    0x14(%ebp),%eax
  801b53:	83 c0 04             	add    $0x4,%eax
  801b56:	89 45 14             	mov    %eax,0x14(%ebp)
  801b59:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5c:	83 e8 04             	sub    $0x4,%eax
  801b5f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801b61:	85 db                	test   %ebx,%ebx
  801b63:	79 02                	jns    801b67 <vprintfmt+0x14a>
				err = -err;
  801b65:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801b67:	83 fb 64             	cmp    $0x64,%ebx
  801b6a:	7f 0b                	jg     801b77 <vprintfmt+0x15a>
  801b6c:	8b 34 9d 60 4e 80 00 	mov    0x804e60(,%ebx,4),%esi
  801b73:	85 f6                	test   %esi,%esi
  801b75:	75 19                	jne    801b90 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801b77:	53                   	push   %ebx
  801b78:	68 05 50 80 00       	push   $0x805005
  801b7d:	ff 75 0c             	pushl  0xc(%ebp)
  801b80:	ff 75 08             	pushl  0x8(%ebp)
  801b83:	e8 5e 02 00 00       	call   801de6 <printfmt>
  801b88:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801b8b:	e9 49 02 00 00       	jmp    801dd9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801b90:	56                   	push   %esi
  801b91:	68 0e 50 80 00       	push   $0x80500e
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	ff 75 08             	pushl  0x8(%ebp)
  801b9c:	e8 45 02 00 00       	call   801de6 <printfmt>
  801ba1:	83 c4 10             	add    $0x10,%esp
			break;
  801ba4:	e9 30 02 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801ba9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bac:	83 c0 04             	add    $0x4,%eax
  801baf:	89 45 14             	mov    %eax,0x14(%ebp)
  801bb2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb5:	83 e8 04             	sub    $0x4,%eax
  801bb8:	8b 30                	mov    (%eax),%esi
  801bba:	85 f6                	test   %esi,%esi
  801bbc:	75 05                	jne    801bc3 <vprintfmt+0x1a6>
				p = "(null)";
  801bbe:	be 11 50 80 00       	mov    $0x805011,%esi
			if (width > 0 && padc != '-')
  801bc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bc7:	7e 6d                	jle    801c36 <vprintfmt+0x219>
  801bc9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801bcd:	74 67                	je     801c36 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801bcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bd2:	83 ec 08             	sub    $0x8,%esp
  801bd5:	50                   	push   %eax
  801bd6:	56                   	push   %esi
  801bd7:	e8 0c 03 00 00       	call   801ee8 <strnlen>
  801bdc:	83 c4 10             	add    $0x10,%esp
  801bdf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801be2:	eb 16                	jmp    801bfa <vprintfmt+0x1dd>
					putch(padc, putdat);
  801be4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801be8:	83 ec 08             	sub    $0x8,%esp
  801beb:	ff 75 0c             	pushl  0xc(%ebp)
  801bee:	50                   	push   %eax
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	ff d0                	call   *%eax
  801bf4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801bf7:	ff 4d e4             	decl   -0x1c(%ebp)
  801bfa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bfe:	7f e4                	jg     801be4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c00:	eb 34                	jmp    801c36 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c02:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c06:	74 1c                	je     801c24 <vprintfmt+0x207>
  801c08:	83 fb 1f             	cmp    $0x1f,%ebx
  801c0b:	7e 05                	jle    801c12 <vprintfmt+0x1f5>
  801c0d:	83 fb 7e             	cmp    $0x7e,%ebx
  801c10:	7e 12                	jle    801c24 <vprintfmt+0x207>
					putch('?', putdat);
  801c12:	83 ec 08             	sub    $0x8,%esp
  801c15:	ff 75 0c             	pushl  0xc(%ebp)
  801c18:	6a 3f                	push   $0x3f
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	ff d0                	call   *%eax
  801c1f:	83 c4 10             	add    $0x10,%esp
  801c22:	eb 0f                	jmp    801c33 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c24:	83 ec 08             	sub    $0x8,%esp
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	53                   	push   %ebx
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	ff d0                	call   *%eax
  801c30:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c33:	ff 4d e4             	decl   -0x1c(%ebp)
  801c36:	89 f0                	mov    %esi,%eax
  801c38:	8d 70 01             	lea    0x1(%eax),%esi
  801c3b:	8a 00                	mov    (%eax),%al
  801c3d:	0f be d8             	movsbl %al,%ebx
  801c40:	85 db                	test   %ebx,%ebx
  801c42:	74 24                	je     801c68 <vprintfmt+0x24b>
  801c44:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c48:	78 b8                	js     801c02 <vprintfmt+0x1e5>
  801c4a:	ff 4d e0             	decl   -0x20(%ebp)
  801c4d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c51:	79 af                	jns    801c02 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c53:	eb 13                	jmp    801c68 <vprintfmt+0x24b>
				putch(' ', putdat);
  801c55:	83 ec 08             	sub    $0x8,%esp
  801c58:	ff 75 0c             	pushl  0xc(%ebp)
  801c5b:	6a 20                	push   $0x20
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	ff d0                	call   *%eax
  801c62:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c65:	ff 4d e4             	decl   -0x1c(%ebp)
  801c68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c6c:	7f e7                	jg     801c55 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801c6e:	e9 66 01 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801c73:	83 ec 08             	sub    $0x8,%esp
  801c76:	ff 75 e8             	pushl  -0x18(%ebp)
  801c79:	8d 45 14             	lea    0x14(%ebp),%eax
  801c7c:	50                   	push   %eax
  801c7d:	e8 3c fd ff ff       	call   8019be <getint>
  801c82:	83 c4 10             	add    $0x10,%esp
  801c85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c91:	85 d2                	test   %edx,%edx
  801c93:	79 23                	jns    801cb8 <vprintfmt+0x29b>
				putch('-', putdat);
  801c95:	83 ec 08             	sub    $0x8,%esp
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	6a 2d                	push   $0x2d
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	ff d0                	call   *%eax
  801ca2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cab:	f7 d8                	neg    %eax
  801cad:	83 d2 00             	adc    $0x0,%edx
  801cb0:	f7 da                	neg    %edx
  801cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801cb8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801cbf:	e9 bc 00 00 00       	jmp    801d80 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801cc4:	83 ec 08             	sub    $0x8,%esp
  801cc7:	ff 75 e8             	pushl  -0x18(%ebp)
  801cca:	8d 45 14             	lea    0x14(%ebp),%eax
  801ccd:	50                   	push   %eax
  801cce:	e8 84 fc ff ff       	call   801957 <getuint>
  801cd3:	83 c4 10             	add    $0x10,%esp
  801cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801cdc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801ce3:	e9 98 00 00 00       	jmp    801d80 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801ce8:	83 ec 08             	sub    $0x8,%esp
  801ceb:	ff 75 0c             	pushl  0xc(%ebp)
  801cee:	6a 58                	push   $0x58
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	ff d0                	call   *%eax
  801cf5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801cf8:	83 ec 08             	sub    $0x8,%esp
  801cfb:	ff 75 0c             	pushl  0xc(%ebp)
  801cfe:	6a 58                	push   $0x58
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	ff d0                	call   *%eax
  801d05:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d08:	83 ec 08             	sub    $0x8,%esp
  801d0b:	ff 75 0c             	pushl  0xc(%ebp)
  801d0e:	6a 58                	push   $0x58
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	ff d0                	call   *%eax
  801d15:	83 c4 10             	add    $0x10,%esp
			break;
  801d18:	e9 bc 00 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801d1d:	83 ec 08             	sub    $0x8,%esp
  801d20:	ff 75 0c             	pushl  0xc(%ebp)
  801d23:	6a 30                	push   $0x30
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	ff d0                	call   *%eax
  801d2a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801d2d:	83 ec 08             	sub    $0x8,%esp
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	6a 78                	push   $0x78
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	ff d0                	call   *%eax
  801d3a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801d3d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d40:	83 c0 04             	add    $0x4,%eax
  801d43:	89 45 14             	mov    %eax,0x14(%ebp)
  801d46:	8b 45 14             	mov    0x14(%ebp),%eax
  801d49:	83 e8 04             	sub    $0x4,%eax
  801d4c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801d58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801d5f:	eb 1f                	jmp    801d80 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d61:	83 ec 08             	sub    $0x8,%esp
  801d64:	ff 75 e8             	pushl  -0x18(%ebp)
  801d67:	8d 45 14             	lea    0x14(%ebp),%eax
  801d6a:	50                   	push   %eax
  801d6b:	e8 e7 fb ff ff       	call   801957 <getuint>
  801d70:	83 c4 10             	add    $0x10,%esp
  801d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d76:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801d79:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801d80:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801d84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d87:	83 ec 04             	sub    $0x4,%esp
  801d8a:	52                   	push   %edx
  801d8b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d8e:	50                   	push   %eax
  801d8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d92:	ff 75 f0             	pushl  -0x10(%ebp)
  801d95:	ff 75 0c             	pushl  0xc(%ebp)
  801d98:	ff 75 08             	pushl  0x8(%ebp)
  801d9b:	e8 00 fb ff ff       	call   8018a0 <printnum>
  801da0:	83 c4 20             	add    $0x20,%esp
			break;
  801da3:	eb 34                	jmp    801dd9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801da5:	83 ec 08             	sub    $0x8,%esp
  801da8:	ff 75 0c             	pushl  0xc(%ebp)
  801dab:	53                   	push   %ebx
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	ff d0                	call   *%eax
  801db1:	83 c4 10             	add    $0x10,%esp
			break;
  801db4:	eb 23                	jmp    801dd9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801db6:	83 ec 08             	sub    $0x8,%esp
  801db9:	ff 75 0c             	pushl  0xc(%ebp)
  801dbc:	6a 25                	push   $0x25
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	ff d0                	call   *%eax
  801dc3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801dc6:	ff 4d 10             	decl   0x10(%ebp)
  801dc9:	eb 03                	jmp    801dce <vprintfmt+0x3b1>
  801dcb:	ff 4d 10             	decl   0x10(%ebp)
  801dce:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd1:	48                   	dec    %eax
  801dd2:	8a 00                	mov    (%eax),%al
  801dd4:	3c 25                	cmp    $0x25,%al
  801dd6:	75 f3                	jne    801dcb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801dd8:	90                   	nop
		}
	}
  801dd9:	e9 47 fc ff ff       	jmp    801a25 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801dde:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801ddf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5e                   	pop    %esi
  801de4:	5d                   	pop    %ebp
  801de5:	c3                   	ret    

00801de6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801dec:	8d 45 10             	lea    0x10(%ebp),%eax
  801def:	83 c0 04             	add    $0x4,%eax
  801df2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801df5:	8b 45 10             	mov    0x10(%ebp),%eax
  801df8:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfb:	50                   	push   %eax
  801dfc:	ff 75 0c             	pushl  0xc(%ebp)
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	e8 16 fc ff ff       	call   801a1d <vprintfmt>
  801e07:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e0a:	90                   	nop
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e13:	8b 40 08             	mov    0x8(%eax),%eax
  801e16:	8d 50 01             	lea    0x1(%eax),%edx
  801e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e22:	8b 10                	mov    (%eax),%edx
  801e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e27:	8b 40 04             	mov    0x4(%eax),%eax
  801e2a:	39 c2                	cmp    %eax,%edx
  801e2c:	73 12                	jae    801e40 <sprintputch+0x33>
		*b->buf++ = ch;
  801e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e31:	8b 00                	mov    (%eax),%eax
  801e33:	8d 48 01             	lea    0x1(%eax),%ecx
  801e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e39:	89 0a                	mov    %ecx,(%edx)
  801e3b:	8b 55 08             	mov    0x8(%ebp),%edx
  801e3e:	88 10                	mov    %dl,(%eax)
}
  801e40:	90                   	nop
  801e41:	5d                   	pop    %ebp
  801e42:	c3                   	ret    

00801e43 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e52:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	01 d0                	add    %edx,%eax
  801e5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801e64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e68:	74 06                	je     801e70 <vsnprintf+0x2d>
  801e6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e6e:	7f 07                	jg     801e77 <vsnprintf+0x34>
		return -E_INVAL;
  801e70:	b8 03 00 00 00       	mov    $0x3,%eax
  801e75:	eb 20                	jmp    801e97 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801e77:	ff 75 14             	pushl  0x14(%ebp)
  801e7a:	ff 75 10             	pushl  0x10(%ebp)
  801e7d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e80:	50                   	push   %eax
  801e81:	68 0d 1e 80 00       	push   $0x801e0d
  801e86:	e8 92 fb ff ff       	call   801a1d <vprintfmt>
  801e8b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801e8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e91:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801e9f:	8d 45 10             	lea    0x10(%ebp),%eax
  801ea2:	83 c0 04             	add    $0x4,%eax
  801ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eab:	ff 75 f4             	pushl  -0xc(%ebp)
  801eae:	50                   	push   %eax
  801eaf:	ff 75 0c             	pushl  0xc(%ebp)
  801eb2:	ff 75 08             	pushl  0x8(%ebp)
  801eb5:	e8 89 ff ff ff       	call   801e43 <vsnprintf>
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801ecb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ed2:	eb 06                	jmp    801eda <strlen+0x15>
		n++;
  801ed4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ed7:	ff 45 08             	incl   0x8(%ebp)
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	8a 00                	mov    (%eax),%al
  801edf:	84 c0                	test   %al,%al
  801ee1:	75 f1                	jne    801ed4 <strlen+0xf>
		n++;
	return n;
  801ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801eee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ef5:	eb 09                	jmp    801f00 <strnlen+0x18>
		n++;
  801ef7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801efa:	ff 45 08             	incl   0x8(%ebp)
  801efd:	ff 4d 0c             	decl   0xc(%ebp)
  801f00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f04:	74 09                	je     801f0f <strnlen+0x27>
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	8a 00                	mov    (%eax),%al
  801f0b:	84 c0                	test   %al,%al
  801f0d:	75 e8                	jne    801ef7 <strnlen+0xf>
		n++;
	return n;
  801f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f20:	90                   	nop
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	8d 50 01             	lea    0x1(%eax),%edx
  801f27:	89 55 08             	mov    %edx,0x8(%ebp)
  801f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f30:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f33:	8a 12                	mov    (%edx),%dl
  801f35:	88 10                	mov    %dl,(%eax)
  801f37:	8a 00                	mov    (%eax),%al
  801f39:	84 c0                	test   %al,%al
  801f3b:	75 e4                	jne    801f21 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801f4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f55:	eb 1f                	jmp    801f76 <strncpy+0x34>
		*dst++ = *src;
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	8d 50 01             	lea    0x1(%eax),%edx
  801f5d:	89 55 08             	mov    %edx,0x8(%ebp)
  801f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f63:	8a 12                	mov    (%edx),%dl
  801f65:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6a:	8a 00                	mov    (%eax),%al
  801f6c:	84 c0                	test   %al,%al
  801f6e:	74 03                	je     801f73 <strncpy+0x31>
			src++;
  801f70:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f73:	ff 45 fc             	incl   -0x4(%ebp)
  801f76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f79:	3b 45 10             	cmp    0x10(%ebp),%eax
  801f7c:	72 d9                	jb     801f57 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801f8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f93:	74 30                	je     801fc5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801f95:	eb 16                	jmp    801fad <strlcpy+0x2a>
			*dst++ = *src++;
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	8d 50 01             	lea    0x1(%eax),%edx
  801f9d:	89 55 08             	mov    %edx,0x8(%ebp)
  801fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa3:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fa6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801fa9:	8a 12                	mov    (%edx),%dl
  801fab:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801fad:	ff 4d 10             	decl   0x10(%ebp)
  801fb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fb4:	74 09                	je     801fbf <strlcpy+0x3c>
  801fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb9:	8a 00                	mov    (%eax),%al
  801fbb:	84 c0                	test   %al,%al
  801fbd:	75 d8                	jne    801f97 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801fc5:	8b 55 08             	mov    0x8(%ebp),%edx
  801fc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fcb:	29 c2                	sub    %eax,%edx
  801fcd:	89 d0                	mov    %edx,%eax
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801fd4:	eb 06                	jmp    801fdc <strcmp+0xb>
		p++, q++;
  801fd6:	ff 45 08             	incl   0x8(%ebp)
  801fd9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	8a 00                	mov    (%eax),%al
  801fe1:	84 c0                	test   %al,%al
  801fe3:	74 0e                	je     801ff3 <strcmp+0x22>
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	8a 10                	mov    (%eax),%dl
  801fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fed:	8a 00                	mov    (%eax),%al
  801fef:	38 c2                	cmp    %al,%dl
  801ff1:	74 e3                	je     801fd6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	8a 00                	mov    (%eax),%al
  801ff8:	0f b6 d0             	movzbl %al,%edx
  801ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffe:	8a 00                	mov    (%eax),%al
  802000:	0f b6 c0             	movzbl %al,%eax
  802003:	29 c2                	sub    %eax,%edx
  802005:	89 d0                	mov    %edx,%eax
}
  802007:	5d                   	pop    %ebp
  802008:	c3                   	ret    

00802009 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80200c:	eb 09                	jmp    802017 <strncmp+0xe>
		n--, p++, q++;
  80200e:	ff 4d 10             	decl   0x10(%ebp)
  802011:	ff 45 08             	incl   0x8(%ebp)
  802014:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  802017:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80201b:	74 17                	je     802034 <strncmp+0x2b>
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	8a 00                	mov    (%eax),%al
  802022:	84 c0                	test   %al,%al
  802024:	74 0e                	je     802034 <strncmp+0x2b>
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	8a 10                	mov    (%eax),%dl
  80202b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202e:	8a 00                	mov    (%eax),%al
  802030:	38 c2                	cmp    %al,%dl
  802032:	74 da                	je     80200e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802034:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802038:	75 07                	jne    802041 <strncmp+0x38>
		return 0;
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	eb 14                	jmp    802055 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	8a 00                	mov    (%eax),%al
  802046:	0f b6 d0             	movzbl %al,%edx
  802049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204c:	8a 00                	mov    (%eax),%al
  80204e:	0f b6 c0             	movzbl %al,%eax
  802051:	29 c2                	sub    %eax,%edx
  802053:	89 d0                	mov    %edx,%eax
}
  802055:	5d                   	pop    %ebp
  802056:	c3                   	ret    

00802057 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 04             	sub    $0x4,%esp
  80205d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802060:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802063:	eb 12                	jmp    802077 <strchr+0x20>
		if (*s == c)
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	8a 00                	mov    (%eax),%al
  80206a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80206d:	75 05                	jne    802074 <strchr+0x1d>
			return (char *) s;
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	eb 11                	jmp    802085 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802074:	ff 45 08             	incl   0x8(%ebp)
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	8a 00                	mov    (%eax),%al
  80207c:	84 c0                	test   %al,%al
  80207e:	75 e5                	jne    802065 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802090:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802093:	eb 0d                	jmp    8020a2 <strfind+0x1b>
		if (*s == c)
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	8a 00                	mov    (%eax),%al
  80209a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80209d:	74 0e                	je     8020ad <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80209f:	ff 45 08             	incl   0x8(%ebp)
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	8a 00                	mov    (%eax),%al
  8020a7:	84 c0                	test   %al,%al
  8020a9:	75 ea                	jne    802095 <strfind+0xe>
  8020ab:	eb 01                	jmp    8020ae <strfind+0x27>
		if (*s == c)
			break;
  8020ad:	90                   	nop
	return (char *) s;
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8020bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8020c5:	eb 0e                	jmp    8020d5 <memset+0x22>
		*p++ = c;
  8020c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ca:	8d 50 01             	lea    0x1(%eax),%edx
  8020cd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8020d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8020d5:	ff 4d f8             	decl   -0x8(%ebp)
  8020d8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8020dc:	79 e9                	jns    8020c7 <memset+0x14>
		*p++ = c;

	return v;
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8020e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8020f5:	eb 16                	jmp    80210d <memcpy+0x2a>
		*d++ = *s++;
  8020f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020fa:	8d 50 01             	lea    0x1(%eax),%edx
  8020fd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802100:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802103:	8d 4a 01             	lea    0x1(%edx),%ecx
  802106:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802109:	8a 12                	mov    (%edx),%dl
  80210b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80210d:	8b 45 10             	mov    0x10(%ebp),%eax
  802110:	8d 50 ff             	lea    -0x1(%eax),%edx
  802113:	89 55 10             	mov    %edx,0x10(%ebp)
  802116:	85 c0                	test   %eax,%eax
  802118:	75 dd                	jne    8020f7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802125:	8b 45 0c             	mov    0xc(%ebp),%eax
  802128:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802131:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802134:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802137:	73 50                	jae    802189 <memmove+0x6a>
  802139:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80213c:	8b 45 10             	mov    0x10(%ebp),%eax
  80213f:	01 d0                	add    %edx,%eax
  802141:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802144:	76 43                	jbe    802189 <memmove+0x6a>
		s += n;
  802146:	8b 45 10             	mov    0x10(%ebp),%eax
  802149:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80214c:	8b 45 10             	mov    0x10(%ebp),%eax
  80214f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802152:	eb 10                	jmp    802164 <memmove+0x45>
			*--d = *--s;
  802154:	ff 4d f8             	decl   -0x8(%ebp)
  802157:	ff 4d fc             	decl   -0x4(%ebp)
  80215a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80215d:	8a 10                	mov    (%eax),%dl
  80215f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802162:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802164:	8b 45 10             	mov    0x10(%ebp),%eax
  802167:	8d 50 ff             	lea    -0x1(%eax),%edx
  80216a:	89 55 10             	mov    %edx,0x10(%ebp)
  80216d:	85 c0                	test   %eax,%eax
  80216f:	75 e3                	jne    802154 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802171:	eb 23                	jmp    802196 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802173:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802176:	8d 50 01             	lea    0x1(%eax),%edx
  802179:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80217c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80217f:	8d 4a 01             	lea    0x1(%edx),%ecx
  802182:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802185:	8a 12                	mov    (%edx),%dl
  802187:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802189:	8b 45 10             	mov    0x10(%ebp),%eax
  80218c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80218f:	89 55 10             	mov    %edx,0x10(%ebp)
  802192:	85 c0                	test   %eax,%eax
  802194:	75 dd                	jne    802173 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8021a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021aa:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8021ad:	eb 2a                	jmp    8021d9 <memcmp+0x3e>
		if (*s1 != *s2)
  8021af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b2:	8a 10                	mov    (%eax),%dl
  8021b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021b7:	8a 00                	mov    (%eax),%al
  8021b9:	38 c2                	cmp    %al,%dl
  8021bb:	74 16                	je     8021d3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8021bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c0:	8a 00                	mov    (%eax),%al
  8021c2:	0f b6 d0             	movzbl %al,%edx
  8021c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021c8:	8a 00                	mov    (%eax),%al
  8021ca:	0f b6 c0             	movzbl %al,%eax
  8021cd:	29 c2                	sub    %eax,%edx
  8021cf:	89 d0                	mov    %edx,%eax
  8021d1:	eb 18                	jmp    8021eb <memcmp+0x50>
		s1++, s2++;
  8021d3:	ff 45 fc             	incl   -0x4(%ebp)
  8021d6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8021d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8021dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021df:	89 55 10             	mov    %edx,0x10(%ebp)
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	75 c9                	jne    8021af <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8021e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8021f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f9:	01 d0                	add    %edx,%eax
  8021fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8021fe:	eb 15                	jmp    802215 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	8a 00                	mov    (%eax),%al
  802205:	0f b6 d0             	movzbl %al,%edx
  802208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220b:	0f b6 c0             	movzbl %al,%eax
  80220e:	39 c2                	cmp    %eax,%edx
  802210:	74 0d                	je     80221f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802212:	ff 45 08             	incl   0x8(%ebp)
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80221b:	72 e3                	jb     802200 <memfind+0x13>
  80221d:	eb 01                	jmp    802220 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80221f:	90                   	nop
	return (void *) s;
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80222b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802232:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802239:	eb 03                	jmp    80223e <strtol+0x19>
		s++;
  80223b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	8a 00                	mov    (%eax),%al
  802243:	3c 20                	cmp    $0x20,%al
  802245:	74 f4                	je     80223b <strtol+0x16>
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	8a 00                	mov    (%eax),%al
  80224c:	3c 09                	cmp    $0x9,%al
  80224e:	74 eb                	je     80223b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	8a 00                	mov    (%eax),%al
  802255:	3c 2b                	cmp    $0x2b,%al
  802257:	75 05                	jne    80225e <strtol+0x39>
		s++;
  802259:	ff 45 08             	incl   0x8(%ebp)
  80225c:	eb 13                	jmp    802271 <strtol+0x4c>
	else if (*s == '-')
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	8a 00                	mov    (%eax),%al
  802263:	3c 2d                	cmp    $0x2d,%al
  802265:	75 0a                	jne    802271 <strtol+0x4c>
		s++, neg = 1;
  802267:	ff 45 08             	incl   0x8(%ebp)
  80226a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802271:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802275:	74 06                	je     80227d <strtol+0x58>
  802277:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80227b:	75 20                	jne    80229d <strtol+0x78>
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	8a 00                	mov    (%eax),%al
  802282:	3c 30                	cmp    $0x30,%al
  802284:	75 17                	jne    80229d <strtol+0x78>
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	40                   	inc    %eax
  80228a:	8a 00                	mov    (%eax),%al
  80228c:	3c 78                	cmp    $0x78,%al
  80228e:	75 0d                	jne    80229d <strtol+0x78>
		s += 2, base = 16;
  802290:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802294:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80229b:	eb 28                	jmp    8022c5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80229d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022a1:	75 15                	jne    8022b8 <strtol+0x93>
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8a 00                	mov    (%eax),%al
  8022a8:	3c 30                	cmp    $0x30,%al
  8022aa:	75 0c                	jne    8022b8 <strtol+0x93>
		s++, base = 8;
  8022ac:	ff 45 08             	incl   0x8(%ebp)
  8022af:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8022b6:	eb 0d                	jmp    8022c5 <strtol+0xa0>
	else if (base == 0)
  8022b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022bc:	75 07                	jne    8022c5 <strtol+0xa0>
		base = 10;
  8022be:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	8a 00                	mov    (%eax),%al
  8022ca:	3c 2f                	cmp    $0x2f,%al
  8022cc:	7e 19                	jle    8022e7 <strtol+0xc2>
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	8a 00                	mov    (%eax),%al
  8022d3:	3c 39                	cmp    $0x39,%al
  8022d5:	7f 10                	jg     8022e7 <strtol+0xc2>
			dig = *s - '0';
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	8a 00                	mov    (%eax),%al
  8022dc:	0f be c0             	movsbl %al,%eax
  8022df:	83 e8 30             	sub    $0x30,%eax
  8022e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e5:	eb 42                	jmp    802329 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	8a 00                	mov    (%eax),%al
  8022ec:	3c 60                	cmp    $0x60,%al
  8022ee:	7e 19                	jle    802309 <strtol+0xe4>
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	8a 00                	mov    (%eax),%al
  8022f5:	3c 7a                	cmp    $0x7a,%al
  8022f7:	7f 10                	jg     802309 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	8a 00                	mov    (%eax),%al
  8022fe:	0f be c0             	movsbl %al,%eax
  802301:	83 e8 57             	sub    $0x57,%eax
  802304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802307:	eb 20                	jmp    802329 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	8a 00                	mov    (%eax),%al
  80230e:	3c 40                	cmp    $0x40,%al
  802310:	7e 39                	jle    80234b <strtol+0x126>
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	8a 00                	mov    (%eax),%al
  802317:	3c 5a                	cmp    $0x5a,%al
  802319:	7f 30                	jg     80234b <strtol+0x126>
			dig = *s - 'A' + 10;
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	8a 00                	mov    (%eax),%al
  802320:	0f be c0             	movsbl %al,%eax
  802323:	83 e8 37             	sub    $0x37,%eax
  802326:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80232f:	7d 19                	jge    80234a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802331:	ff 45 08             	incl   0x8(%ebp)
  802334:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802337:	0f af 45 10          	imul   0x10(%ebp),%eax
  80233b:	89 c2                	mov    %eax,%edx
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	01 d0                	add    %edx,%eax
  802342:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802345:	e9 7b ff ff ff       	jmp    8022c5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80234a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80234b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80234f:	74 08                	je     802359 <strtol+0x134>
		*endptr = (char *) s;
  802351:	8b 45 0c             	mov    0xc(%ebp),%eax
  802354:	8b 55 08             	mov    0x8(%ebp),%edx
  802357:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802359:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80235d:	74 07                	je     802366 <strtol+0x141>
  80235f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802362:	f7 d8                	neg    %eax
  802364:	eb 03                	jmp    802369 <strtol+0x144>
  802366:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <ltostr>:

void
ltostr(long value, char *str)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802371:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802378:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80237f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802383:	79 13                	jns    802398 <ltostr+0x2d>
	{
		neg = 1;
  802385:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80238c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802392:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802395:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8023a0:	99                   	cltd   
  8023a1:	f7 f9                	idiv   %ecx
  8023a3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8023a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023a9:	8d 50 01             	lea    0x1(%eax),%edx
  8023ac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8023af:	89 c2                	mov    %eax,%edx
  8023b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b4:	01 d0                	add    %edx,%eax
  8023b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023b9:	83 c2 30             	add    $0x30,%edx
  8023bc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8023be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023c1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8023c6:	f7 e9                	imul   %ecx
  8023c8:	c1 fa 02             	sar    $0x2,%edx
  8023cb:	89 c8                	mov    %ecx,%eax
  8023cd:	c1 f8 1f             	sar    $0x1f,%eax
  8023d0:	29 c2                	sub    %eax,%edx
  8023d2:	89 d0                	mov    %edx,%eax
  8023d4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8023d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023da:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8023df:	f7 e9                	imul   %ecx
  8023e1:	c1 fa 02             	sar    $0x2,%edx
  8023e4:	89 c8                	mov    %ecx,%eax
  8023e6:	c1 f8 1f             	sar    $0x1f,%eax
  8023e9:	29 c2                	sub    %eax,%edx
  8023eb:	89 d0                	mov    %edx,%eax
  8023ed:	c1 e0 02             	shl    $0x2,%eax
  8023f0:	01 d0                	add    %edx,%eax
  8023f2:	01 c0                	add    %eax,%eax
  8023f4:	29 c1                	sub    %eax,%ecx
  8023f6:	89 ca                	mov    %ecx,%edx
  8023f8:	85 d2                	test   %edx,%edx
  8023fa:	75 9c                	jne    802398 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8023fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802403:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802406:	48                   	dec    %eax
  802407:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80240a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80240e:	74 3d                	je     80244d <ltostr+0xe2>
		start = 1 ;
  802410:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802417:	eb 34                	jmp    80244d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802419:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241f:	01 d0                	add    %edx,%eax
  802421:	8a 00                	mov    (%eax),%al
  802423:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802426:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802429:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242c:	01 c2                	add    %eax,%edx
  80242e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802431:	8b 45 0c             	mov    0xc(%ebp),%eax
  802434:	01 c8                	add    %ecx,%eax
  802436:	8a 00                	mov    (%eax),%al
  802438:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80243a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80243d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802440:	01 c2                	add    %eax,%edx
  802442:	8a 45 eb             	mov    -0x15(%ebp),%al
  802445:	88 02                	mov    %al,(%edx)
		start++ ;
  802447:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80244a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802453:	7c c4                	jl     802419 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802455:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802458:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245b:	01 d0                	add    %edx,%eax
  80245d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802460:	90                   	nop
  802461:	c9                   	leave  
  802462:	c3                   	ret    

00802463 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
  802466:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802469:	ff 75 08             	pushl  0x8(%ebp)
  80246c:	e8 54 fa ff ff       	call   801ec5 <strlen>
  802471:	83 c4 04             	add    $0x4,%esp
  802474:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802477:	ff 75 0c             	pushl  0xc(%ebp)
  80247a:	e8 46 fa ff ff       	call   801ec5 <strlen>
  80247f:	83 c4 04             	add    $0x4,%esp
  802482:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802485:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80248c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802493:	eb 17                	jmp    8024ac <strcconcat+0x49>
		final[s] = str1[s] ;
  802495:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802498:	8b 45 10             	mov    0x10(%ebp),%eax
  80249b:	01 c2                	add    %eax,%edx
  80249d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	01 c8                	add    %ecx,%eax
  8024a5:	8a 00                	mov    (%eax),%al
  8024a7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8024a9:	ff 45 fc             	incl   -0x4(%ebp)
  8024ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024b2:	7c e1                	jl     802495 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8024b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8024bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8024c2:	eb 1f                	jmp    8024e3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8024c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c7:	8d 50 01             	lea    0x1(%eax),%edx
  8024ca:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8024cd:	89 c2                	mov    %eax,%edx
  8024cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d2:	01 c2                	add    %eax,%edx
  8024d4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8024d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024da:	01 c8                	add    %ecx,%eax
  8024dc:	8a 00                	mov    (%eax),%al
  8024de:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8024e0:	ff 45 f8             	incl   -0x8(%ebp)
  8024e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024e9:	7c d9                	jl     8024c4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8024eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f1:	01 d0                	add    %edx,%eax
  8024f3:	c6 00 00             	movb   $0x0,(%eax)
}
  8024f6:	90                   	nop
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8024fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802505:	8b 45 14             	mov    0x14(%ebp),%eax
  802508:	8b 00                	mov    (%eax),%eax
  80250a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802511:	8b 45 10             	mov    0x10(%ebp),%eax
  802514:	01 d0                	add    %edx,%eax
  802516:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80251c:	eb 0c                	jmp    80252a <strsplit+0x31>
			*string++ = 0;
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	8d 50 01             	lea    0x1(%eax),%edx
  802524:	89 55 08             	mov    %edx,0x8(%ebp)
  802527:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	8a 00                	mov    (%eax),%al
  80252f:	84 c0                	test   %al,%al
  802531:	74 18                	je     80254b <strsplit+0x52>
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	8a 00                	mov    (%eax),%al
  802538:	0f be c0             	movsbl %al,%eax
  80253b:	50                   	push   %eax
  80253c:	ff 75 0c             	pushl  0xc(%ebp)
  80253f:	e8 13 fb ff ff       	call   802057 <strchr>
  802544:	83 c4 08             	add    $0x8,%esp
  802547:	85 c0                	test   %eax,%eax
  802549:	75 d3                	jne    80251e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	8a 00                	mov    (%eax),%al
  802550:	84 c0                	test   %al,%al
  802552:	74 5a                	je     8025ae <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802554:	8b 45 14             	mov    0x14(%ebp),%eax
  802557:	8b 00                	mov    (%eax),%eax
  802559:	83 f8 0f             	cmp    $0xf,%eax
  80255c:	75 07                	jne    802565 <strsplit+0x6c>
		{
			return 0;
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
  802563:	eb 66                	jmp    8025cb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802565:	8b 45 14             	mov    0x14(%ebp),%eax
  802568:	8b 00                	mov    (%eax),%eax
  80256a:	8d 48 01             	lea    0x1(%eax),%ecx
  80256d:	8b 55 14             	mov    0x14(%ebp),%edx
  802570:	89 0a                	mov    %ecx,(%edx)
  802572:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802579:	8b 45 10             	mov    0x10(%ebp),%eax
  80257c:	01 c2                	add    %eax,%edx
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802583:	eb 03                	jmp    802588 <strsplit+0x8f>
			string++;
  802585:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	8a 00                	mov    (%eax),%al
  80258d:	84 c0                	test   %al,%al
  80258f:	74 8b                	je     80251c <strsplit+0x23>
  802591:	8b 45 08             	mov    0x8(%ebp),%eax
  802594:	8a 00                	mov    (%eax),%al
  802596:	0f be c0             	movsbl %al,%eax
  802599:	50                   	push   %eax
  80259a:	ff 75 0c             	pushl  0xc(%ebp)
  80259d:	e8 b5 fa ff ff       	call   802057 <strchr>
  8025a2:	83 c4 08             	add    $0x8,%esp
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	74 dc                	je     802585 <strsplit+0x8c>
			string++;
	}
  8025a9:	e9 6e ff ff ff       	jmp    80251c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8025ae:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8025af:	8b 45 14             	mov    0x14(%ebp),%eax
  8025b2:	8b 00                	mov    (%eax),%eax
  8025b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8025be:	01 d0                	add    %edx,%eax
  8025c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8025c6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    

008025cd <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8025cd:	55                   	push   %ebp
  8025ce:	89 e5                	mov    %esp,%ebp
  8025d0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8025d3:	a1 04 60 80 00       	mov    0x806004,%eax
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	74 1f                	je     8025fb <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8025dc:	e8 1d 00 00 00       	call   8025fe <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8025e1:	83 ec 0c             	sub    $0xc,%esp
  8025e4:	68 70 51 80 00       	push   $0x805170
  8025e9:	e8 55 f2 ff ff       	call   801843 <cprintf>
  8025ee:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8025f1:	c7 05 04 60 80 00 00 	movl   $0x0,0x806004
  8025f8:	00 00 00 
	}
}
  8025fb:	90                   	nop
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
  802601:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  802604:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  80260b:	00 00 00 
  80260e:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  802615:	00 00 00 
  802618:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  80261f:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  802622:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  802629:	00 00 00 
  80262c:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  802633:	00 00 00 
  802636:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  80263d:	00 00 00 
	uint32 arr_size = 0;
  802640:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  802647:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80264e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802651:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802656:	2d 00 10 00 00       	sub    $0x1000,%eax
  80265b:	a3 50 60 80 00       	mov    %eax,0x806050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  802660:	c7 05 20 61 80 00 00 	movl   $0x20000,0x806120
  802667:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  80266a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802671:	a1 20 61 80 00       	mov    0x806120,%eax
  802676:	c1 e0 04             	shl    $0x4,%eax
  802679:	89 c2                	mov    %eax,%edx
  80267b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267e:	01 d0                	add    %edx,%eax
  802680:	48                   	dec    %eax
  802681:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802684:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802687:	ba 00 00 00 00       	mov    $0x0,%edx
  80268c:	f7 75 ec             	divl   -0x14(%ebp)
  80268f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802692:	29 d0                	sub    %edx,%eax
  802694:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  802697:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80269e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8026a6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8026ab:	83 ec 04             	sub    $0x4,%esp
  8026ae:	6a 06                	push   $0x6
  8026b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8026b3:	50                   	push   %eax
  8026b4:	e8 fc 04 00 00       	call   802bb5 <sys_allocate_chunk>
  8026b9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8026bc:	a1 20 61 80 00       	mov    0x806120,%eax
  8026c1:	83 ec 0c             	sub    $0xc,%esp
  8026c4:	50                   	push   %eax
  8026c5:	e8 71 0b 00 00       	call   80323b <initialize_MemBlocksList>
  8026ca:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026cd:	a1 48 61 80 00       	mov    0x806148,%eax
  8026d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8026d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d8:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8026df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e2:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8026e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8026ed:	75 14                	jne    802703 <initialize_dyn_block_system+0x105>
  8026ef:	83 ec 04             	sub    $0x4,%esp
  8026f2:	68 95 51 80 00       	push   $0x805195
  8026f7:	6a 33                	push   $0x33
  8026f9:	68 b3 51 80 00       	push   $0x8051b3
  8026fe:	e8 8c ee ff ff       	call   80158f <_panic>
  802703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802706:	8b 00                	mov    (%eax),%eax
  802708:	85 c0                	test   %eax,%eax
  80270a:	74 10                	je     80271c <initialize_dyn_block_system+0x11e>
  80270c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802714:	8b 52 04             	mov    0x4(%edx),%edx
  802717:	89 50 04             	mov    %edx,0x4(%eax)
  80271a:	eb 0b                	jmp    802727 <initialize_dyn_block_system+0x129>
  80271c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80271f:	8b 40 04             	mov    0x4(%eax),%eax
  802722:	a3 4c 61 80 00       	mov    %eax,0x80614c
  802727:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80272a:	8b 40 04             	mov    0x4(%eax),%eax
  80272d:	85 c0                	test   %eax,%eax
  80272f:	74 0f                	je     802740 <initialize_dyn_block_system+0x142>
  802731:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802734:	8b 40 04             	mov    0x4(%eax),%eax
  802737:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80273a:	8b 12                	mov    (%edx),%edx
  80273c:	89 10                	mov    %edx,(%eax)
  80273e:	eb 0a                	jmp    80274a <initialize_dyn_block_system+0x14c>
  802740:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	a3 48 61 80 00       	mov    %eax,0x806148
  80274a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802753:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802756:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275d:	a1 54 61 80 00       	mov    0x806154,%eax
  802762:	48                   	dec    %eax
  802763:	a3 54 61 80 00       	mov    %eax,0x806154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  802768:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80276c:	75 14                	jne    802782 <initialize_dyn_block_system+0x184>
  80276e:	83 ec 04             	sub    $0x4,%esp
  802771:	68 c0 51 80 00       	push   $0x8051c0
  802776:	6a 34                	push   $0x34
  802778:	68 b3 51 80 00       	push   $0x8051b3
  80277d:	e8 0d ee ff ff       	call   80158f <_panic>
  802782:	8b 15 38 61 80 00    	mov    0x806138,%edx
  802788:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278b:	89 10                	mov    %edx,(%eax)
  80278d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802790:	8b 00                	mov    (%eax),%eax
  802792:	85 c0                	test   %eax,%eax
  802794:	74 0d                	je     8027a3 <initialize_dyn_block_system+0x1a5>
  802796:	a1 38 61 80 00       	mov    0x806138,%eax
  80279b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80279e:	89 50 04             	mov    %edx,0x4(%eax)
  8027a1:	eb 08                	jmp    8027ab <initialize_dyn_block_system+0x1ad>
  8027a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a6:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8027ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ae:	a3 38 61 80 00       	mov    %eax,0x806138
  8027b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027bd:	a1 44 61 80 00       	mov    0x806144,%eax
  8027c2:	40                   	inc    %eax
  8027c3:	a3 44 61 80 00       	mov    %eax,0x806144
}
  8027c8:	90                   	nop
  8027c9:	c9                   	leave  
  8027ca:	c3                   	ret    

008027cb <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8027cb:	55                   	push   %ebp
  8027cc:	89 e5                	mov    %esp,%ebp
  8027ce:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8027d1:	e8 f7 fd ff ff       	call   8025cd <InitializeUHeap>
	if (size == 0) return NULL ;
  8027d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027da:	75 07                	jne    8027e3 <malloc+0x18>
  8027dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e1:	eb 61                	jmp    802844 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8027e3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8027ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f0:	01 d0                	add    %edx,%eax
  8027f2:	48                   	dec    %eax
  8027f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8027fe:	f7 75 f0             	divl   -0x10(%ebp)
  802801:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802804:	29 d0                	sub    %edx,%eax
  802806:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802809:	e8 75 07 00 00       	call   802f83 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80280e:	85 c0                	test   %eax,%eax
  802810:	74 11                	je     802823 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  802812:	83 ec 0c             	sub    $0xc,%esp
  802815:	ff 75 e8             	pushl  -0x18(%ebp)
  802818:	e8 e0 0d 00 00       	call   8035fd <alloc_block_FF>
  80281d:	83 c4 10             	add    $0x10,%esp
  802820:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  802823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802827:	74 16                	je     80283f <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  802829:	83 ec 0c             	sub    $0xc,%esp
  80282c:	ff 75 f4             	pushl  -0xc(%ebp)
  80282f:	e8 3c 0b 00 00       	call   803370 <insert_sorted_allocList>
  802834:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 40 08             	mov    0x8(%eax),%eax
  80283d:	eb 05                	jmp    802844 <malloc+0x79>
	}

    return NULL;
  80283f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80284c:	83 ec 04             	sub    $0x4,%esp
  80284f:	68 e4 51 80 00       	push   $0x8051e4
  802854:	6a 6f                	push   $0x6f
  802856:	68 b3 51 80 00       	push   $0x8051b3
  80285b:	e8 2f ed ff ff       	call   80158f <_panic>

00802860 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
  802863:	83 ec 38             	sub    $0x38,%esp
  802866:	8b 45 10             	mov    0x10(%ebp),%eax
  802869:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80286c:	e8 5c fd ff ff       	call   8025cd <InitializeUHeap>
	if (size == 0) return NULL ;
  802871:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802875:	75 0a                	jne    802881 <smalloc+0x21>
  802877:	b8 00 00 00 00       	mov    $0x0,%eax
  80287c:	e9 8b 00 00 00       	jmp    80290c <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802881:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802888:	8b 55 0c             	mov    0xc(%ebp),%edx
  80288b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288e:	01 d0                	add    %edx,%eax
  802890:	48                   	dec    %eax
  802891:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802897:	ba 00 00 00 00       	mov    $0x0,%edx
  80289c:	f7 75 f0             	divl   -0x10(%ebp)
  80289f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a2:	29 d0                	sub    %edx,%eax
  8028a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8028a7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8028ae:	e8 d0 06 00 00       	call   802f83 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	74 11                	je     8028c8 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8028b7:	83 ec 0c             	sub    $0xc,%esp
  8028ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8028bd:	e8 3b 0d 00 00       	call   8035fd <alloc_block_FF>
  8028c2:	83 c4 10             	add    $0x10,%esp
  8028c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8028c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cc:	74 39                	je     802907 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 40 08             	mov    0x8(%eax),%eax
  8028d4:	89 c2                	mov    %eax,%edx
  8028d6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8028da:	52                   	push   %edx
  8028db:	50                   	push   %eax
  8028dc:	ff 75 0c             	pushl  0xc(%ebp)
  8028df:	ff 75 08             	pushl  0x8(%ebp)
  8028e2:	e8 21 04 00 00       	call   802d08 <sys_createSharedObject>
  8028e7:	83 c4 10             	add    $0x10,%esp
  8028ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8028ed:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8028f1:	74 14                	je     802907 <smalloc+0xa7>
  8028f3:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8028f7:	74 0e                	je     802907 <smalloc+0xa7>
  8028f9:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8028fd:	74 08                	je     802907 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	8b 40 08             	mov    0x8(%eax),%eax
  802905:	eb 05                	jmp    80290c <smalloc+0xac>
	}
	return NULL;
  802907:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80290c:	c9                   	leave  
  80290d:	c3                   	ret    

0080290e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80290e:	55                   	push   %ebp
  80290f:	89 e5                	mov    %esp,%ebp
  802911:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802914:	e8 b4 fc ff ff       	call   8025cd <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802919:	83 ec 08             	sub    $0x8,%esp
  80291c:	ff 75 0c             	pushl  0xc(%ebp)
  80291f:	ff 75 08             	pushl  0x8(%ebp)
  802922:	e8 0b 04 00 00       	call   802d32 <sys_getSizeOfSharedObject>
  802927:	83 c4 10             	add    $0x10,%esp
  80292a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80292d:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  802931:	74 76                	je     8029a9 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802933:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80293a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80293d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802940:	01 d0                	add    %edx,%eax
  802942:	48                   	dec    %eax
  802943:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802946:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802949:	ba 00 00 00 00       	mov    $0x0,%edx
  80294e:	f7 75 ec             	divl   -0x14(%ebp)
  802951:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802954:	29 d0                	sub    %edx,%eax
  802956:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  802959:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802960:	e8 1e 06 00 00       	call   802f83 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802965:	85 c0                	test   %eax,%eax
  802967:	74 11                	je     80297a <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  802969:	83 ec 0c             	sub    $0xc,%esp
  80296c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80296f:	e8 89 0c 00 00       	call   8035fd <alloc_block_FF>
  802974:	83 c4 10             	add    $0x10,%esp
  802977:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80297a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297e:	74 29                	je     8029a9 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 40 08             	mov    0x8(%eax),%eax
  802986:	83 ec 04             	sub    $0x4,%esp
  802989:	50                   	push   %eax
  80298a:	ff 75 0c             	pushl  0xc(%ebp)
  80298d:	ff 75 08             	pushl  0x8(%ebp)
  802990:	e8 ba 03 00 00       	call   802d4f <sys_getSharedObject>
  802995:	83 c4 10             	add    $0x10,%esp
  802998:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80299b:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80299f:	74 08                	je     8029a9 <sget+0x9b>
				return (void *)mem_block->sva;
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 40 08             	mov    0x8(%eax),%eax
  8029a7:	eb 05                	jmp    8029ae <sget+0xa0>
		}
	}
	return (void *)NULL;
  8029a9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8029ae:	c9                   	leave  
  8029af:	c3                   	ret    

008029b0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8029b0:	55                   	push   %ebp
  8029b1:	89 e5                	mov    %esp,%ebp
  8029b3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8029b6:	e8 12 fc ff ff       	call   8025cd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8029bb:	83 ec 04             	sub    $0x4,%esp
  8029be:	68 08 52 80 00       	push   $0x805208
  8029c3:	68 f1 00 00 00       	push   $0xf1
  8029c8:	68 b3 51 80 00       	push   $0x8051b3
  8029cd:	e8 bd eb ff ff       	call   80158f <_panic>

008029d2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8029d2:	55                   	push   %ebp
  8029d3:	89 e5                	mov    %esp,%ebp
  8029d5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8029d8:	83 ec 04             	sub    $0x4,%esp
  8029db:	68 30 52 80 00       	push   $0x805230
  8029e0:	68 05 01 00 00       	push   $0x105
  8029e5:	68 b3 51 80 00       	push   $0x8051b3
  8029ea:	e8 a0 eb ff ff       	call   80158f <_panic>

008029ef <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8029ef:	55                   	push   %ebp
  8029f0:	89 e5                	mov    %esp,%ebp
  8029f2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8029f5:	83 ec 04             	sub    $0x4,%esp
  8029f8:	68 54 52 80 00       	push   $0x805254
  8029fd:	68 10 01 00 00       	push   $0x110
  802a02:	68 b3 51 80 00       	push   $0x8051b3
  802a07:	e8 83 eb ff ff       	call   80158f <_panic>

00802a0c <shrink>:

}
void shrink(uint32 newSize)
{
  802a0c:	55                   	push   %ebp
  802a0d:	89 e5                	mov    %esp,%ebp
  802a0f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802a12:	83 ec 04             	sub    $0x4,%esp
  802a15:	68 54 52 80 00       	push   $0x805254
  802a1a:	68 15 01 00 00       	push   $0x115
  802a1f:	68 b3 51 80 00       	push   $0x8051b3
  802a24:	e8 66 eb ff ff       	call   80158f <_panic>

00802a29 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802a29:	55                   	push   %ebp
  802a2a:	89 e5                	mov    %esp,%ebp
  802a2c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802a2f:	83 ec 04             	sub    $0x4,%esp
  802a32:	68 54 52 80 00       	push   $0x805254
  802a37:	68 1a 01 00 00       	push   $0x11a
  802a3c:	68 b3 51 80 00       	push   $0x8051b3
  802a41:	e8 49 eb ff ff       	call   80158f <_panic>

00802a46 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802a46:	55                   	push   %ebp
  802a47:	89 e5                	mov    %esp,%ebp
  802a49:	57                   	push   %edi
  802a4a:	56                   	push   %esi
  802a4b:	53                   	push   %ebx
  802a4c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a55:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a58:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a5b:	8b 7d 18             	mov    0x18(%ebp),%edi
  802a5e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802a61:	cd 30                	int    $0x30
  802a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802a69:	83 c4 10             	add    $0x10,%esp
  802a6c:	5b                   	pop    %ebx
  802a6d:	5e                   	pop    %esi
  802a6e:	5f                   	pop    %edi
  802a6f:	5d                   	pop    %ebp
  802a70:	c3                   	ret    

00802a71 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802a71:	55                   	push   %ebp
  802a72:	89 e5                	mov    %esp,%ebp
  802a74:	83 ec 04             	sub    $0x4,%esp
  802a77:	8b 45 10             	mov    0x10(%ebp),%eax
  802a7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802a7d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	6a 00                	push   $0x0
  802a86:	6a 00                	push   $0x0
  802a88:	52                   	push   %edx
  802a89:	ff 75 0c             	pushl  0xc(%ebp)
  802a8c:	50                   	push   %eax
  802a8d:	6a 00                	push   $0x0
  802a8f:	e8 b2 ff ff ff       	call   802a46 <syscall>
  802a94:	83 c4 18             	add    $0x18,%esp
}
  802a97:	90                   	nop
  802a98:	c9                   	leave  
  802a99:	c3                   	ret    

00802a9a <sys_cgetc>:

int
sys_cgetc(void)
{
  802a9a:	55                   	push   %ebp
  802a9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802a9d:	6a 00                	push   $0x0
  802a9f:	6a 00                	push   $0x0
  802aa1:	6a 00                	push   $0x0
  802aa3:	6a 00                	push   $0x0
  802aa5:	6a 00                	push   $0x0
  802aa7:	6a 01                	push   $0x1
  802aa9:	e8 98 ff ff ff       	call   802a46 <syscall>
  802aae:	83 c4 18             	add    $0x18,%esp
}
  802ab1:	c9                   	leave  
  802ab2:	c3                   	ret    

00802ab3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802ab3:	55                   	push   %ebp
  802ab4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	6a 00                	push   $0x0
  802abe:	6a 00                	push   $0x0
  802ac0:	6a 00                	push   $0x0
  802ac2:	52                   	push   %edx
  802ac3:	50                   	push   %eax
  802ac4:	6a 05                	push   $0x5
  802ac6:	e8 7b ff ff ff       	call   802a46 <syscall>
  802acb:	83 c4 18             	add    $0x18,%esp
}
  802ace:	c9                   	leave  
  802acf:	c3                   	ret    

00802ad0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802ad0:	55                   	push   %ebp
  802ad1:	89 e5                	mov    %esp,%ebp
  802ad3:	56                   	push   %esi
  802ad4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802ad5:	8b 75 18             	mov    0x18(%ebp),%esi
  802ad8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802adb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ade:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	56                   	push   %esi
  802ae5:	53                   	push   %ebx
  802ae6:	51                   	push   %ecx
  802ae7:	52                   	push   %edx
  802ae8:	50                   	push   %eax
  802ae9:	6a 06                	push   $0x6
  802aeb:	e8 56 ff ff ff       	call   802a46 <syscall>
  802af0:	83 c4 18             	add    $0x18,%esp
}
  802af3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802af6:	5b                   	pop    %ebx
  802af7:	5e                   	pop    %esi
  802af8:	5d                   	pop    %ebp
  802af9:	c3                   	ret    

00802afa <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802afa:	55                   	push   %ebp
  802afb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b00:	8b 45 08             	mov    0x8(%ebp),%eax
  802b03:	6a 00                	push   $0x0
  802b05:	6a 00                	push   $0x0
  802b07:	6a 00                	push   $0x0
  802b09:	52                   	push   %edx
  802b0a:	50                   	push   %eax
  802b0b:	6a 07                	push   $0x7
  802b0d:	e8 34 ff ff ff       	call   802a46 <syscall>
  802b12:	83 c4 18             	add    $0x18,%esp
}
  802b15:	c9                   	leave  
  802b16:	c3                   	ret    

00802b17 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802b17:	55                   	push   %ebp
  802b18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802b1a:	6a 00                	push   $0x0
  802b1c:	6a 00                	push   $0x0
  802b1e:	6a 00                	push   $0x0
  802b20:	ff 75 0c             	pushl  0xc(%ebp)
  802b23:	ff 75 08             	pushl  0x8(%ebp)
  802b26:	6a 08                	push   $0x8
  802b28:	e8 19 ff ff ff       	call   802a46 <syscall>
  802b2d:	83 c4 18             	add    $0x18,%esp
}
  802b30:	c9                   	leave  
  802b31:	c3                   	ret    

00802b32 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802b32:	55                   	push   %ebp
  802b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802b35:	6a 00                	push   $0x0
  802b37:	6a 00                	push   $0x0
  802b39:	6a 00                	push   $0x0
  802b3b:	6a 00                	push   $0x0
  802b3d:	6a 00                	push   $0x0
  802b3f:	6a 09                	push   $0x9
  802b41:	e8 00 ff ff ff       	call   802a46 <syscall>
  802b46:	83 c4 18             	add    $0x18,%esp
}
  802b49:	c9                   	leave  
  802b4a:	c3                   	ret    

00802b4b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802b4b:	55                   	push   %ebp
  802b4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802b4e:	6a 00                	push   $0x0
  802b50:	6a 00                	push   $0x0
  802b52:	6a 00                	push   $0x0
  802b54:	6a 00                	push   $0x0
  802b56:	6a 00                	push   $0x0
  802b58:	6a 0a                	push   $0xa
  802b5a:	e8 e7 fe ff ff       	call   802a46 <syscall>
  802b5f:	83 c4 18             	add    $0x18,%esp
}
  802b62:	c9                   	leave  
  802b63:	c3                   	ret    

00802b64 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802b64:	55                   	push   %ebp
  802b65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802b67:	6a 00                	push   $0x0
  802b69:	6a 00                	push   $0x0
  802b6b:	6a 00                	push   $0x0
  802b6d:	6a 00                	push   $0x0
  802b6f:	6a 00                	push   $0x0
  802b71:	6a 0b                	push   $0xb
  802b73:	e8 ce fe ff ff       	call   802a46 <syscall>
  802b78:	83 c4 18             	add    $0x18,%esp
}
  802b7b:	c9                   	leave  
  802b7c:	c3                   	ret    

00802b7d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802b7d:	55                   	push   %ebp
  802b7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802b80:	6a 00                	push   $0x0
  802b82:	6a 00                	push   $0x0
  802b84:	6a 00                	push   $0x0
  802b86:	ff 75 0c             	pushl  0xc(%ebp)
  802b89:	ff 75 08             	pushl  0x8(%ebp)
  802b8c:	6a 0f                	push   $0xf
  802b8e:	e8 b3 fe ff ff       	call   802a46 <syscall>
  802b93:	83 c4 18             	add    $0x18,%esp
	return;
  802b96:	90                   	nop
}
  802b97:	c9                   	leave  
  802b98:	c3                   	ret    

00802b99 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802b99:	55                   	push   %ebp
  802b9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802b9c:	6a 00                	push   $0x0
  802b9e:	6a 00                	push   $0x0
  802ba0:	6a 00                	push   $0x0
  802ba2:	ff 75 0c             	pushl  0xc(%ebp)
  802ba5:	ff 75 08             	pushl  0x8(%ebp)
  802ba8:	6a 10                	push   $0x10
  802baa:	e8 97 fe ff ff       	call   802a46 <syscall>
  802baf:	83 c4 18             	add    $0x18,%esp
	return ;
  802bb2:	90                   	nop
}
  802bb3:	c9                   	leave  
  802bb4:	c3                   	ret    

00802bb5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802bb5:	55                   	push   %ebp
  802bb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802bb8:	6a 00                	push   $0x0
  802bba:	6a 00                	push   $0x0
  802bbc:	ff 75 10             	pushl  0x10(%ebp)
  802bbf:	ff 75 0c             	pushl  0xc(%ebp)
  802bc2:	ff 75 08             	pushl  0x8(%ebp)
  802bc5:	6a 11                	push   $0x11
  802bc7:	e8 7a fe ff ff       	call   802a46 <syscall>
  802bcc:	83 c4 18             	add    $0x18,%esp
	return ;
  802bcf:	90                   	nop
}
  802bd0:	c9                   	leave  
  802bd1:	c3                   	ret    

00802bd2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802bd2:	55                   	push   %ebp
  802bd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802bd5:	6a 00                	push   $0x0
  802bd7:	6a 00                	push   $0x0
  802bd9:	6a 00                	push   $0x0
  802bdb:	6a 00                	push   $0x0
  802bdd:	6a 00                	push   $0x0
  802bdf:	6a 0c                	push   $0xc
  802be1:	e8 60 fe ff ff       	call   802a46 <syscall>
  802be6:	83 c4 18             	add    $0x18,%esp
}
  802be9:	c9                   	leave  
  802bea:	c3                   	ret    

00802beb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802beb:	55                   	push   %ebp
  802bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802bee:	6a 00                	push   $0x0
  802bf0:	6a 00                	push   $0x0
  802bf2:	6a 00                	push   $0x0
  802bf4:	6a 00                	push   $0x0
  802bf6:	ff 75 08             	pushl  0x8(%ebp)
  802bf9:	6a 0d                	push   $0xd
  802bfb:	e8 46 fe ff ff       	call   802a46 <syscall>
  802c00:	83 c4 18             	add    $0x18,%esp
}
  802c03:	c9                   	leave  
  802c04:	c3                   	ret    

00802c05 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802c05:	55                   	push   %ebp
  802c06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802c08:	6a 00                	push   $0x0
  802c0a:	6a 00                	push   $0x0
  802c0c:	6a 00                	push   $0x0
  802c0e:	6a 00                	push   $0x0
  802c10:	6a 00                	push   $0x0
  802c12:	6a 0e                	push   $0xe
  802c14:	e8 2d fe ff ff       	call   802a46 <syscall>
  802c19:	83 c4 18             	add    $0x18,%esp
}
  802c1c:	90                   	nop
  802c1d:	c9                   	leave  
  802c1e:	c3                   	ret    

00802c1f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802c1f:	55                   	push   %ebp
  802c20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802c22:	6a 00                	push   $0x0
  802c24:	6a 00                	push   $0x0
  802c26:	6a 00                	push   $0x0
  802c28:	6a 00                	push   $0x0
  802c2a:	6a 00                	push   $0x0
  802c2c:	6a 13                	push   $0x13
  802c2e:	e8 13 fe ff ff       	call   802a46 <syscall>
  802c33:	83 c4 18             	add    $0x18,%esp
}
  802c36:	90                   	nop
  802c37:	c9                   	leave  
  802c38:	c3                   	ret    

00802c39 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802c39:	55                   	push   %ebp
  802c3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802c3c:	6a 00                	push   $0x0
  802c3e:	6a 00                	push   $0x0
  802c40:	6a 00                	push   $0x0
  802c42:	6a 00                	push   $0x0
  802c44:	6a 00                	push   $0x0
  802c46:	6a 14                	push   $0x14
  802c48:	e8 f9 fd ff ff       	call   802a46 <syscall>
  802c4d:	83 c4 18             	add    $0x18,%esp
}
  802c50:	90                   	nop
  802c51:	c9                   	leave  
  802c52:	c3                   	ret    

00802c53 <sys_cputc>:


void
sys_cputc(const char c)
{
  802c53:	55                   	push   %ebp
  802c54:	89 e5                	mov    %esp,%ebp
  802c56:	83 ec 04             	sub    $0x4,%esp
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802c5f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c63:	6a 00                	push   $0x0
  802c65:	6a 00                	push   $0x0
  802c67:	6a 00                	push   $0x0
  802c69:	6a 00                	push   $0x0
  802c6b:	50                   	push   %eax
  802c6c:	6a 15                	push   $0x15
  802c6e:	e8 d3 fd ff ff       	call   802a46 <syscall>
  802c73:	83 c4 18             	add    $0x18,%esp
}
  802c76:	90                   	nop
  802c77:	c9                   	leave  
  802c78:	c3                   	ret    

00802c79 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802c79:	55                   	push   %ebp
  802c7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802c7c:	6a 00                	push   $0x0
  802c7e:	6a 00                	push   $0x0
  802c80:	6a 00                	push   $0x0
  802c82:	6a 00                	push   $0x0
  802c84:	6a 00                	push   $0x0
  802c86:	6a 16                	push   $0x16
  802c88:	e8 b9 fd ff ff       	call   802a46 <syscall>
  802c8d:	83 c4 18             	add    $0x18,%esp
}
  802c90:	90                   	nop
  802c91:	c9                   	leave  
  802c92:	c3                   	ret    

00802c93 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802c93:	55                   	push   %ebp
  802c94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	6a 00                	push   $0x0
  802c9b:	6a 00                	push   $0x0
  802c9d:	6a 00                	push   $0x0
  802c9f:	ff 75 0c             	pushl  0xc(%ebp)
  802ca2:	50                   	push   %eax
  802ca3:	6a 17                	push   $0x17
  802ca5:	e8 9c fd ff ff       	call   802a46 <syscall>
  802caa:	83 c4 18             	add    $0x18,%esp
}
  802cad:	c9                   	leave  
  802cae:	c3                   	ret    

00802caf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802caf:	55                   	push   %ebp
  802cb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	6a 00                	push   $0x0
  802cba:	6a 00                	push   $0x0
  802cbc:	6a 00                	push   $0x0
  802cbe:	52                   	push   %edx
  802cbf:	50                   	push   %eax
  802cc0:	6a 1a                	push   $0x1a
  802cc2:	e8 7f fd ff ff       	call   802a46 <syscall>
  802cc7:	83 c4 18             	add    $0x18,%esp
}
  802cca:	c9                   	leave  
  802ccb:	c3                   	ret    

00802ccc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802ccc:	55                   	push   %ebp
  802ccd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	6a 00                	push   $0x0
  802cd7:	6a 00                	push   $0x0
  802cd9:	6a 00                	push   $0x0
  802cdb:	52                   	push   %edx
  802cdc:	50                   	push   %eax
  802cdd:	6a 18                	push   $0x18
  802cdf:	e8 62 fd ff ff       	call   802a46 <syscall>
  802ce4:	83 c4 18             	add    $0x18,%esp
}
  802ce7:	90                   	nop
  802ce8:	c9                   	leave  
  802ce9:	c3                   	ret    

00802cea <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802cea:	55                   	push   %ebp
  802ceb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802ced:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	6a 00                	push   $0x0
  802cf5:	6a 00                	push   $0x0
  802cf7:	6a 00                	push   $0x0
  802cf9:	52                   	push   %edx
  802cfa:	50                   	push   %eax
  802cfb:	6a 19                	push   $0x19
  802cfd:	e8 44 fd ff ff       	call   802a46 <syscall>
  802d02:	83 c4 18             	add    $0x18,%esp
}
  802d05:	90                   	nop
  802d06:	c9                   	leave  
  802d07:	c3                   	ret    

00802d08 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802d08:	55                   	push   %ebp
  802d09:	89 e5                	mov    %esp,%ebp
  802d0b:	83 ec 04             	sub    $0x4,%esp
  802d0e:	8b 45 10             	mov    0x10(%ebp),%eax
  802d11:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802d14:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d17:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	6a 00                	push   $0x0
  802d20:	51                   	push   %ecx
  802d21:	52                   	push   %edx
  802d22:	ff 75 0c             	pushl  0xc(%ebp)
  802d25:	50                   	push   %eax
  802d26:	6a 1b                	push   $0x1b
  802d28:	e8 19 fd ff ff       	call   802a46 <syscall>
  802d2d:	83 c4 18             	add    $0x18,%esp
}
  802d30:	c9                   	leave  
  802d31:	c3                   	ret    

00802d32 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802d32:	55                   	push   %ebp
  802d33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802d35:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d38:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3b:	6a 00                	push   $0x0
  802d3d:	6a 00                	push   $0x0
  802d3f:	6a 00                	push   $0x0
  802d41:	52                   	push   %edx
  802d42:	50                   	push   %eax
  802d43:	6a 1c                	push   $0x1c
  802d45:	e8 fc fc ff ff       	call   802a46 <syscall>
  802d4a:	83 c4 18             	add    $0x18,%esp
}
  802d4d:	c9                   	leave  
  802d4e:	c3                   	ret    

00802d4f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802d4f:	55                   	push   %ebp
  802d50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802d52:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d55:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	6a 00                	push   $0x0
  802d5d:	6a 00                	push   $0x0
  802d5f:	51                   	push   %ecx
  802d60:	52                   	push   %edx
  802d61:	50                   	push   %eax
  802d62:	6a 1d                	push   $0x1d
  802d64:	e8 dd fc ff ff       	call   802a46 <syscall>
  802d69:	83 c4 18             	add    $0x18,%esp
}
  802d6c:	c9                   	leave  
  802d6d:	c3                   	ret    

00802d6e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802d6e:	55                   	push   %ebp
  802d6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802d71:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	6a 00                	push   $0x0
  802d79:	6a 00                	push   $0x0
  802d7b:	6a 00                	push   $0x0
  802d7d:	52                   	push   %edx
  802d7e:	50                   	push   %eax
  802d7f:	6a 1e                	push   $0x1e
  802d81:	e8 c0 fc ff ff       	call   802a46 <syscall>
  802d86:	83 c4 18             	add    $0x18,%esp
}
  802d89:	c9                   	leave  
  802d8a:	c3                   	ret    

00802d8b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802d8b:	55                   	push   %ebp
  802d8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802d8e:	6a 00                	push   $0x0
  802d90:	6a 00                	push   $0x0
  802d92:	6a 00                	push   $0x0
  802d94:	6a 00                	push   $0x0
  802d96:	6a 00                	push   $0x0
  802d98:	6a 1f                	push   $0x1f
  802d9a:	e8 a7 fc ff ff       	call   802a46 <syscall>
  802d9f:	83 c4 18             	add    $0x18,%esp
}
  802da2:	c9                   	leave  
  802da3:	c3                   	ret    

00802da4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802da4:	55                   	push   %ebp
  802da5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	6a 00                	push   $0x0
  802dac:	ff 75 14             	pushl  0x14(%ebp)
  802daf:	ff 75 10             	pushl  0x10(%ebp)
  802db2:	ff 75 0c             	pushl  0xc(%ebp)
  802db5:	50                   	push   %eax
  802db6:	6a 20                	push   $0x20
  802db8:	e8 89 fc ff ff       	call   802a46 <syscall>
  802dbd:	83 c4 18             	add    $0x18,%esp
}
  802dc0:	c9                   	leave  
  802dc1:	c3                   	ret    

00802dc2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802dc2:	55                   	push   %ebp
  802dc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc8:	6a 00                	push   $0x0
  802dca:	6a 00                	push   $0x0
  802dcc:	6a 00                	push   $0x0
  802dce:	6a 00                	push   $0x0
  802dd0:	50                   	push   %eax
  802dd1:	6a 21                	push   $0x21
  802dd3:	e8 6e fc ff ff       	call   802a46 <syscall>
  802dd8:	83 c4 18             	add    $0x18,%esp
}
  802ddb:	90                   	nop
  802ddc:	c9                   	leave  
  802ddd:	c3                   	ret    

00802dde <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802dde:	55                   	push   %ebp
  802ddf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	6a 00                	push   $0x0
  802de6:	6a 00                	push   $0x0
  802de8:	6a 00                	push   $0x0
  802dea:	6a 00                	push   $0x0
  802dec:	50                   	push   %eax
  802ded:	6a 22                	push   $0x22
  802def:	e8 52 fc ff ff       	call   802a46 <syscall>
  802df4:	83 c4 18             	add    $0x18,%esp
}
  802df7:	c9                   	leave  
  802df8:	c3                   	ret    

00802df9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802df9:	55                   	push   %ebp
  802dfa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802dfc:	6a 00                	push   $0x0
  802dfe:	6a 00                	push   $0x0
  802e00:	6a 00                	push   $0x0
  802e02:	6a 00                	push   $0x0
  802e04:	6a 00                	push   $0x0
  802e06:	6a 02                	push   $0x2
  802e08:	e8 39 fc ff ff       	call   802a46 <syscall>
  802e0d:	83 c4 18             	add    $0x18,%esp
}
  802e10:	c9                   	leave  
  802e11:	c3                   	ret    

00802e12 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802e12:	55                   	push   %ebp
  802e13:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802e15:	6a 00                	push   $0x0
  802e17:	6a 00                	push   $0x0
  802e19:	6a 00                	push   $0x0
  802e1b:	6a 00                	push   $0x0
  802e1d:	6a 00                	push   $0x0
  802e1f:	6a 03                	push   $0x3
  802e21:	e8 20 fc ff ff       	call   802a46 <syscall>
  802e26:	83 c4 18             	add    $0x18,%esp
}
  802e29:	c9                   	leave  
  802e2a:	c3                   	ret    

00802e2b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802e2b:	55                   	push   %ebp
  802e2c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802e2e:	6a 00                	push   $0x0
  802e30:	6a 00                	push   $0x0
  802e32:	6a 00                	push   $0x0
  802e34:	6a 00                	push   $0x0
  802e36:	6a 00                	push   $0x0
  802e38:	6a 04                	push   $0x4
  802e3a:	e8 07 fc ff ff       	call   802a46 <syscall>
  802e3f:	83 c4 18             	add    $0x18,%esp
}
  802e42:	c9                   	leave  
  802e43:	c3                   	ret    

00802e44 <sys_exit_env>:


void sys_exit_env(void)
{
  802e44:	55                   	push   %ebp
  802e45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802e47:	6a 00                	push   $0x0
  802e49:	6a 00                	push   $0x0
  802e4b:	6a 00                	push   $0x0
  802e4d:	6a 00                	push   $0x0
  802e4f:	6a 00                	push   $0x0
  802e51:	6a 23                	push   $0x23
  802e53:	e8 ee fb ff ff       	call   802a46 <syscall>
  802e58:	83 c4 18             	add    $0x18,%esp
}
  802e5b:	90                   	nop
  802e5c:	c9                   	leave  
  802e5d:	c3                   	ret    

00802e5e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802e5e:	55                   	push   %ebp
  802e5f:	89 e5                	mov    %esp,%ebp
  802e61:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802e64:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e67:	8d 50 04             	lea    0x4(%eax),%edx
  802e6a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e6d:	6a 00                	push   $0x0
  802e6f:	6a 00                	push   $0x0
  802e71:	6a 00                	push   $0x0
  802e73:	52                   	push   %edx
  802e74:	50                   	push   %eax
  802e75:	6a 24                	push   $0x24
  802e77:	e8 ca fb ff ff       	call   802a46 <syscall>
  802e7c:	83 c4 18             	add    $0x18,%esp
	return result;
  802e7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802e85:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802e88:	89 01                	mov    %eax,(%ecx)
  802e8a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	c9                   	leave  
  802e91:	c2 04 00             	ret    $0x4

00802e94 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802e94:	55                   	push   %ebp
  802e95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802e97:	6a 00                	push   $0x0
  802e99:	6a 00                	push   $0x0
  802e9b:	ff 75 10             	pushl  0x10(%ebp)
  802e9e:	ff 75 0c             	pushl  0xc(%ebp)
  802ea1:	ff 75 08             	pushl  0x8(%ebp)
  802ea4:	6a 12                	push   $0x12
  802ea6:	e8 9b fb ff ff       	call   802a46 <syscall>
  802eab:	83 c4 18             	add    $0x18,%esp
	return ;
  802eae:	90                   	nop
}
  802eaf:	c9                   	leave  
  802eb0:	c3                   	ret    

00802eb1 <sys_rcr2>:
uint32 sys_rcr2()
{
  802eb1:	55                   	push   %ebp
  802eb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802eb4:	6a 00                	push   $0x0
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 00                	push   $0x0
  802eba:	6a 00                	push   $0x0
  802ebc:	6a 00                	push   $0x0
  802ebe:	6a 25                	push   $0x25
  802ec0:	e8 81 fb ff ff       	call   802a46 <syscall>
  802ec5:	83 c4 18             	add    $0x18,%esp
}
  802ec8:	c9                   	leave  
  802ec9:	c3                   	ret    

00802eca <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802eca:	55                   	push   %ebp
  802ecb:	89 e5                	mov    %esp,%ebp
  802ecd:	83 ec 04             	sub    $0x4,%esp
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ed6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802eda:	6a 00                	push   $0x0
  802edc:	6a 00                	push   $0x0
  802ede:	6a 00                	push   $0x0
  802ee0:	6a 00                	push   $0x0
  802ee2:	50                   	push   %eax
  802ee3:	6a 26                	push   $0x26
  802ee5:	e8 5c fb ff ff       	call   802a46 <syscall>
  802eea:	83 c4 18             	add    $0x18,%esp
	return ;
  802eed:	90                   	nop
}
  802eee:	c9                   	leave  
  802eef:	c3                   	ret    

00802ef0 <rsttst>:
void rsttst()
{
  802ef0:	55                   	push   %ebp
  802ef1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802ef3:	6a 00                	push   $0x0
  802ef5:	6a 00                	push   $0x0
  802ef7:	6a 00                	push   $0x0
  802ef9:	6a 00                	push   $0x0
  802efb:	6a 00                	push   $0x0
  802efd:	6a 28                	push   $0x28
  802eff:	e8 42 fb ff ff       	call   802a46 <syscall>
  802f04:	83 c4 18             	add    $0x18,%esp
	return ;
  802f07:	90                   	nop
}
  802f08:	c9                   	leave  
  802f09:	c3                   	ret    

00802f0a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802f0a:	55                   	push   %ebp
  802f0b:	89 e5                	mov    %esp,%ebp
  802f0d:	83 ec 04             	sub    $0x4,%esp
  802f10:	8b 45 14             	mov    0x14(%ebp),%eax
  802f13:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802f16:	8b 55 18             	mov    0x18(%ebp),%edx
  802f19:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f1d:	52                   	push   %edx
  802f1e:	50                   	push   %eax
  802f1f:	ff 75 10             	pushl  0x10(%ebp)
  802f22:	ff 75 0c             	pushl  0xc(%ebp)
  802f25:	ff 75 08             	pushl  0x8(%ebp)
  802f28:	6a 27                	push   $0x27
  802f2a:	e8 17 fb ff ff       	call   802a46 <syscall>
  802f2f:	83 c4 18             	add    $0x18,%esp
	return ;
  802f32:	90                   	nop
}
  802f33:	c9                   	leave  
  802f34:	c3                   	ret    

00802f35 <chktst>:
void chktst(uint32 n)
{
  802f35:	55                   	push   %ebp
  802f36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802f38:	6a 00                	push   $0x0
  802f3a:	6a 00                	push   $0x0
  802f3c:	6a 00                	push   $0x0
  802f3e:	6a 00                	push   $0x0
  802f40:	ff 75 08             	pushl  0x8(%ebp)
  802f43:	6a 29                	push   $0x29
  802f45:	e8 fc fa ff ff       	call   802a46 <syscall>
  802f4a:	83 c4 18             	add    $0x18,%esp
	return ;
  802f4d:	90                   	nop
}
  802f4e:	c9                   	leave  
  802f4f:	c3                   	ret    

00802f50 <inctst>:

void inctst()
{
  802f50:	55                   	push   %ebp
  802f51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802f53:	6a 00                	push   $0x0
  802f55:	6a 00                	push   $0x0
  802f57:	6a 00                	push   $0x0
  802f59:	6a 00                	push   $0x0
  802f5b:	6a 00                	push   $0x0
  802f5d:	6a 2a                	push   $0x2a
  802f5f:	e8 e2 fa ff ff       	call   802a46 <syscall>
  802f64:	83 c4 18             	add    $0x18,%esp
	return ;
  802f67:	90                   	nop
}
  802f68:	c9                   	leave  
  802f69:	c3                   	ret    

00802f6a <gettst>:
uint32 gettst()
{
  802f6a:	55                   	push   %ebp
  802f6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802f6d:	6a 00                	push   $0x0
  802f6f:	6a 00                	push   $0x0
  802f71:	6a 00                	push   $0x0
  802f73:	6a 00                	push   $0x0
  802f75:	6a 00                	push   $0x0
  802f77:	6a 2b                	push   $0x2b
  802f79:	e8 c8 fa ff ff       	call   802a46 <syscall>
  802f7e:	83 c4 18             	add    $0x18,%esp
}
  802f81:	c9                   	leave  
  802f82:	c3                   	ret    

00802f83 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802f83:	55                   	push   %ebp
  802f84:	89 e5                	mov    %esp,%ebp
  802f86:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f89:	6a 00                	push   $0x0
  802f8b:	6a 00                	push   $0x0
  802f8d:	6a 00                	push   $0x0
  802f8f:	6a 00                	push   $0x0
  802f91:	6a 00                	push   $0x0
  802f93:	6a 2c                	push   $0x2c
  802f95:	e8 ac fa ff ff       	call   802a46 <syscall>
  802f9a:	83 c4 18             	add    $0x18,%esp
  802f9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802fa0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802fa4:	75 07                	jne    802fad <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802fa6:	b8 01 00 00 00       	mov    $0x1,%eax
  802fab:	eb 05                	jmp    802fb2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802fad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fb2:	c9                   	leave  
  802fb3:	c3                   	ret    

00802fb4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802fb4:	55                   	push   %ebp
  802fb5:	89 e5                	mov    %esp,%ebp
  802fb7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802fba:	6a 00                	push   $0x0
  802fbc:	6a 00                	push   $0x0
  802fbe:	6a 00                	push   $0x0
  802fc0:	6a 00                	push   $0x0
  802fc2:	6a 00                	push   $0x0
  802fc4:	6a 2c                	push   $0x2c
  802fc6:	e8 7b fa ff ff       	call   802a46 <syscall>
  802fcb:	83 c4 18             	add    $0x18,%esp
  802fce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802fd1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802fd5:	75 07                	jne    802fde <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802fd7:	b8 01 00 00 00       	mov    $0x1,%eax
  802fdc:	eb 05                	jmp    802fe3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802fde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fe3:	c9                   	leave  
  802fe4:	c3                   	ret    

00802fe5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802fe5:	55                   	push   %ebp
  802fe6:	89 e5                	mov    %esp,%ebp
  802fe8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802feb:	6a 00                	push   $0x0
  802fed:	6a 00                	push   $0x0
  802fef:	6a 00                	push   $0x0
  802ff1:	6a 00                	push   $0x0
  802ff3:	6a 00                	push   $0x0
  802ff5:	6a 2c                	push   $0x2c
  802ff7:	e8 4a fa ff ff       	call   802a46 <syscall>
  802ffc:	83 c4 18             	add    $0x18,%esp
  802fff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  803002:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  803006:	75 07                	jne    80300f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  803008:	b8 01 00 00 00       	mov    $0x1,%eax
  80300d:	eb 05                	jmp    803014 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80300f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803014:	c9                   	leave  
  803015:	c3                   	ret    

00803016 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  803016:	55                   	push   %ebp
  803017:	89 e5                	mov    %esp,%ebp
  803019:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80301c:	6a 00                	push   $0x0
  80301e:	6a 00                	push   $0x0
  803020:	6a 00                	push   $0x0
  803022:	6a 00                	push   $0x0
  803024:	6a 00                	push   $0x0
  803026:	6a 2c                	push   $0x2c
  803028:	e8 19 fa ff ff       	call   802a46 <syscall>
  80302d:	83 c4 18             	add    $0x18,%esp
  803030:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  803033:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  803037:	75 07                	jne    803040 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  803039:	b8 01 00 00 00       	mov    $0x1,%eax
  80303e:	eb 05                	jmp    803045 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803040:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803045:	c9                   	leave  
  803046:	c3                   	ret    

00803047 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803047:	55                   	push   %ebp
  803048:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80304a:	6a 00                	push   $0x0
  80304c:	6a 00                	push   $0x0
  80304e:	6a 00                	push   $0x0
  803050:	6a 00                	push   $0x0
  803052:	ff 75 08             	pushl  0x8(%ebp)
  803055:	6a 2d                	push   $0x2d
  803057:	e8 ea f9 ff ff       	call   802a46 <syscall>
  80305c:	83 c4 18             	add    $0x18,%esp
	return ;
  80305f:	90                   	nop
}
  803060:	c9                   	leave  
  803061:	c3                   	ret    

00803062 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803062:	55                   	push   %ebp
  803063:	89 e5                	mov    %esp,%ebp
  803065:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803066:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803069:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80306c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	6a 00                	push   $0x0
  803074:	53                   	push   %ebx
  803075:	51                   	push   %ecx
  803076:	52                   	push   %edx
  803077:	50                   	push   %eax
  803078:	6a 2e                	push   $0x2e
  80307a:	e8 c7 f9 ff ff       	call   802a46 <syscall>
  80307f:	83 c4 18             	add    $0x18,%esp
}
  803082:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803085:	c9                   	leave  
  803086:	c3                   	ret    

00803087 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803087:	55                   	push   %ebp
  803088:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80308a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	6a 00                	push   $0x0
  803092:	6a 00                	push   $0x0
  803094:	6a 00                	push   $0x0
  803096:	52                   	push   %edx
  803097:	50                   	push   %eax
  803098:	6a 2f                	push   $0x2f
  80309a:	e8 a7 f9 ff ff       	call   802a46 <syscall>
  80309f:	83 c4 18             	add    $0x18,%esp
}
  8030a2:	c9                   	leave  
  8030a3:	c3                   	ret    

008030a4 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8030a4:	55                   	push   %ebp
  8030a5:	89 e5                	mov    %esp,%ebp
  8030a7:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8030aa:	83 ec 0c             	sub    $0xc,%esp
  8030ad:	68 64 52 80 00       	push   $0x805264
  8030b2:	e8 8c e7 ff ff       	call   801843 <cprintf>
  8030b7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8030ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8030c1:	83 ec 0c             	sub    $0xc,%esp
  8030c4:	68 90 52 80 00       	push   $0x805290
  8030c9:	e8 75 e7 ff ff       	call   801843 <cprintf>
  8030ce:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8030d1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8030d5:	a1 38 61 80 00       	mov    0x806138,%eax
  8030da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030dd:	eb 56                	jmp    803135 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8030df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030e3:	74 1c                	je     803101 <print_mem_block_lists+0x5d>
  8030e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e8:	8b 50 08             	mov    0x8(%eax),%edx
  8030eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ee:	8b 48 08             	mov    0x8(%eax),%ecx
  8030f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f7:	01 c8                	add    %ecx,%eax
  8030f9:	39 c2                	cmp    %eax,%edx
  8030fb:	73 04                	jae    803101 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8030fd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803104:	8b 50 08             	mov    0x8(%eax),%edx
  803107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310a:	8b 40 0c             	mov    0xc(%eax),%eax
  80310d:	01 c2                	add    %eax,%edx
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	8b 40 08             	mov    0x8(%eax),%eax
  803115:	83 ec 04             	sub    $0x4,%esp
  803118:	52                   	push   %edx
  803119:	50                   	push   %eax
  80311a:	68 a5 52 80 00       	push   $0x8052a5
  80311f:	e8 1f e7 ff ff       	call   801843 <cprintf>
  803124:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80312d:	a1 40 61 80 00       	mov    0x806140,%eax
  803132:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803135:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803139:	74 07                	je     803142 <print_mem_block_lists+0x9e>
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	8b 00                	mov    (%eax),%eax
  803140:	eb 05                	jmp    803147 <print_mem_block_lists+0xa3>
  803142:	b8 00 00 00 00       	mov    $0x0,%eax
  803147:	a3 40 61 80 00       	mov    %eax,0x806140
  80314c:	a1 40 61 80 00       	mov    0x806140,%eax
  803151:	85 c0                	test   %eax,%eax
  803153:	75 8a                	jne    8030df <print_mem_block_lists+0x3b>
  803155:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803159:	75 84                	jne    8030df <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80315b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80315f:	75 10                	jne    803171 <print_mem_block_lists+0xcd>
  803161:	83 ec 0c             	sub    $0xc,%esp
  803164:	68 b4 52 80 00       	push   $0x8052b4
  803169:	e8 d5 e6 ff ff       	call   801843 <cprintf>
  80316e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  803171:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  803178:	83 ec 0c             	sub    $0xc,%esp
  80317b:	68 d8 52 80 00       	push   $0x8052d8
  803180:	e8 be e6 ff ff       	call   801843 <cprintf>
  803185:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  803188:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80318c:	a1 40 60 80 00       	mov    0x806040,%eax
  803191:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803194:	eb 56                	jmp    8031ec <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803196:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80319a:	74 1c                	je     8031b8 <print_mem_block_lists+0x114>
  80319c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319f:	8b 50 08             	mov    0x8(%eax),%edx
  8031a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a5:	8b 48 08             	mov    0x8(%eax),%ecx
  8031a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ae:	01 c8                	add    %ecx,%eax
  8031b0:	39 c2                	cmp    %eax,%edx
  8031b2:	73 04                	jae    8031b8 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8031b4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8031b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bb:	8b 50 08             	mov    0x8(%eax),%edx
  8031be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c4:	01 c2                	add    %eax,%edx
  8031c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c9:	8b 40 08             	mov    0x8(%eax),%eax
  8031cc:	83 ec 04             	sub    $0x4,%esp
  8031cf:	52                   	push   %edx
  8031d0:	50                   	push   %eax
  8031d1:	68 a5 52 80 00       	push   $0x8052a5
  8031d6:	e8 68 e6 ff ff       	call   801843 <cprintf>
  8031db:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8031de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8031e4:	a1 48 60 80 00       	mov    0x806048,%eax
  8031e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f0:	74 07                	je     8031f9 <print_mem_block_lists+0x155>
  8031f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f5:	8b 00                	mov    (%eax),%eax
  8031f7:	eb 05                	jmp    8031fe <print_mem_block_lists+0x15a>
  8031f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8031fe:	a3 48 60 80 00       	mov    %eax,0x806048
  803203:	a1 48 60 80 00       	mov    0x806048,%eax
  803208:	85 c0                	test   %eax,%eax
  80320a:	75 8a                	jne    803196 <print_mem_block_lists+0xf2>
  80320c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803210:	75 84                	jne    803196 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  803212:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803216:	75 10                	jne    803228 <print_mem_block_lists+0x184>
  803218:	83 ec 0c             	sub    $0xc,%esp
  80321b:	68 f0 52 80 00       	push   $0x8052f0
  803220:	e8 1e e6 ff ff       	call   801843 <cprintf>
  803225:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803228:	83 ec 0c             	sub    $0xc,%esp
  80322b:	68 64 52 80 00       	push   $0x805264
  803230:	e8 0e e6 ff ff       	call   801843 <cprintf>
  803235:	83 c4 10             	add    $0x10,%esp

}
  803238:	90                   	nop
  803239:	c9                   	leave  
  80323a:	c3                   	ret    

0080323b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80323b:	55                   	push   %ebp
  80323c:	89 e5                	mov    %esp,%ebp
  80323e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  803241:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  803248:	00 00 00 
  80324b:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  803252:	00 00 00 
  803255:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  80325c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80325f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803266:	e9 9e 00 00 00       	jmp    803309 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80326b:	a1 50 60 80 00       	mov    0x806050,%eax
  803270:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803273:	c1 e2 04             	shl    $0x4,%edx
  803276:	01 d0                	add    %edx,%eax
  803278:	85 c0                	test   %eax,%eax
  80327a:	75 14                	jne    803290 <initialize_MemBlocksList+0x55>
  80327c:	83 ec 04             	sub    $0x4,%esp
  80327f:	68 18 53 80 00       	push   $0x805318
  803284:	6a 46                	push   $0x46
  803286:	68 3b 53 80 00       	push   $0x80533b
  80328b:	e8 ff e2 ff ff       	call   80158f <_panic>
  803290:	a1 50 60 80 00       	mov    0x806050,%eax
  803295:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803298:	c1 e2 04             	shl    $0x4,%edx
  80329b:	01 d0                	add    %edx,%eax
  80329d:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8032a3:	89 10                	mov    %edx,(%eax)
  8032a5:	8b 00                	mov    (%eax),%eax
  8032a7:	85 c0                	test   %eax,%eax
  8032a9:	74 18                	je     8032c3 <initialize_MemBlocksList+0x88>
  8032ab:	a1 48 61 80 00       	mov    0x806148,%eax
  8032b0:	8b 15 50 60 80 00    	mov    0x806050,%edx
  8032b6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8032b9:	c1 e1 04             	shl    $0x4,%ecx
  8032bc:	01 ca                	add    %ecx,%edx
  8032be:	89 50 04             	mov    %edx,0x4(%eax)
  8032c1:	eb 12                	jmp    8032d5 <initialize_MemBlocksList+0x9a>
  8032c3:	a1 50 60 80 00       	mov    0x806050,%eax
  8032c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032cb:	c1 e2 04             	shl    $0x4,%edx
  8032ce:	01 d0                	add    %edx,%eax
  8032d0:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8032d5:	a1 50 60 80 00       	mov    0x806050,%eax
  8032da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032dd:	c1 e2 04             	shl    $0x4,%edx
  8032e0:	01 d0                	add    %edx,%eax
  8032e2:	a3 48 61 80 00       	mov    %eax,0x806148
  8032e7:	a1 50 60 80 00       	mov    0x806050,%eax
  8032ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ef:	c1 e2 04             	shl    $0x4,%edx
  8032f2:	01 d0                	add    %edx,%eax
  8032f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032fb:	a1 54 61 80 00       	mov    0x806154,%eax
  803300:	40                   	inc    %eax
  803301:	a3 54 61 80 00       	mov    %eax,0x806154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  803306:	ff 45 f4             	incl   -0xc(%ebp)
  803309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80330f:	0f 82 56 ff ff ff    	jb     80326b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  803315:	90                   	nop
  803316:	c9                   	leave  
  803317:	c3                   	ret    

00803318 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  803318:	55                   	push   %ebp
  803319:	89 e5                	mov    %esp,%ebp
  80331b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	8b 00                	mov    (%eax),%eax
  803323:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803326:	eb 19                	jmp    803341 <find_block+0x29>
	{
		if(va==point->sva)
  803328:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80332b:	8b 40 08             	mov    0x8(%eax),%eax
  80332e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803331:	75 05                	jne    803338 <find_block+0x20>
		   return point;
  803333:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803336:	eb 36                	jmp    80336e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	8b 40 08             	mov    0x8(%eax),%eax
  80333e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803341:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803345:	74 07                	je     80334e <find_block+0x36>
  803347:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80334a:	8b 00                	mov    (%eax),%eax
  80334c:	eb 05                	jmp    803353 <find_block+0x3b>
  80334e:	b8 00 00 00 00       	mov    $0x0,%eax
  803353:	8b 55 08             	mov    0x8(%ebp),%edx
  803356:	89 42 08             	mov    %eax,0x8(%edx)
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	8b 40 08             	mov    0x8(%eax),%eax
  80335f:	85 c0                	test   %eax,%eax
  803361:	75 c5                	jne    803328 <find_block+0x10>
  803363:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803367:	75 bf                	jne    803328 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  803369:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80336e:	c9                   	leave  
  80336f:	c3                   	ret    

00803370 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  803370:	55                   	push   %ebp
  803371:	89 e5                	mov    %esp,%ebp
  803373:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  803376:	a1 40 60 80 00       	mov    0x806040,%eax
  80337b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80337e:	a1 44 60 80 00       	mov    0x806044,%eax
  803383:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  803386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803389:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80338c:	74 24                	je     8033b2 <insert_sorted_allocList+0x42>
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	8b 50 08             	mov    0x8(%eax),%edx
  803394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803397:	8b 40 08             	mov    0x8(%eax),%eax
  80339a:	39 c2                	cmp    %eax,%edx
  80339c:	76 14                	jbe    8033b2 <insert_sorted_allocList+0x42>
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	8b 50 08             	mov    0x8(%eax),%edx
  8033a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a7:	8b 40 08             	mov    0x8(%eax),%eax
  8033aa:	39 c2                	cmp    %eax,%edx
  8033ac:	0f 82 60 01 00 00    	jb     803512 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8033b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033b6:	75 65                	jne    80341d <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8033b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033bc:	75 14                	jne    8033d2 <insert_sorted_allocList+0x62>
  8033be:	83 ec 04             	sub    $0x4,%esp
  8033c1:	68 18 53 80 00       	push   $0x805318
  8033c6:	6a 6b                	push   $0x6b
  8033c8:	68 3b 53 80 00       	push   $0x80533b
  8033cd:	e8 bd e1 ff ff       	call   80158f <_panic>
  8033d2:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8033d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033db:	89 10                	mov    %edx,(%eax)
  8033dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e0:	8b 00                	mov    (%eax),%eax
  8033e2:	85 c0                	test   %eax,%eax
  8033e4:	74 0d                	je     8033f3 <insert_sorted_allocList+0x83>
  8033e6:	a1 40 60 80 00       	mov    0x806040,%eax
  8033eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ee:	89 50 04             	mov    %edx,0x4(%eax)
  8033f1:	eb 08                	jmp    8033fb <insert_sorted_allocList+0x8b>
  8033f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f6:	a3 44 60 80 00       	mov    %eax,0x806044
  8033fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fe:	a3 40 60 80 00       	mov    %eax,0x806040
  803403:	8b 45 08             	mov    0x8(%ebp),%eax
  803406:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80340d:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803412:	40                   	inc    %eax
  803413:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803418:	e9 dc 01 00 00       	jmp    8035f9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80341d:	8b 45 08             	mov    0x8(%ebp),%eax
  803420:	8b 50 08             	mov    0x8(%eax),%edx
  803423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803426:	8b 40 08             	mov    0x8(%eax),%eax
  803429:	39 c2                	cmp    %eax,%edx
  80342b:	77 6c                	ja     803499 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80342d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803431:	74 06                	je     803439 <insert_sorted_allocList+0xc9>
  803433:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803437:	75 14                	jne    80344d <insert_sorted_allocList+0xdd>
  803439:	83 ec 04             	sub    $0x4,%esp
  80343c:	68 54 53 80 00       	push   $0x805354
  803441:	6a 6f                	push   $0x6f
  803443:	68 3b 53 80 00       	push   $0x80533b
  803448:	e8 42 e1 ff ff       	call   80158f <_panic>
  80344d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803450:	8b 50 04             	mov    0x4(%eax),%edx
  803453:	8b 45 08             	mov    0x8(%ebp),%eax
  803456:	89 50 04             	mov    %edx,0x4(%eax)
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80345f:	89 10                	mov    %edx,(%eax)
  803461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803464:	8b 40 04             	mov    0x4(%eax),%eax
  803467:	85 c0                	test   %eax,%eax
  803469:	74 0d                	je     803478 <insert_sorted_allocList+0x108>
  80346b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80346e:	8b 40 04             	mov    0x4(%eax),%eax
  803471:	8b 55 08             	mov    0x8(%ebp),%edx
  803474:	89 10                	mov    %edx,(%eax)
  803476:	eb 08                	jmp    803480 <insert_sorted_allocList+0x110>
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	a3 40 60 80 00       	mov    %eax,0x806040
  803480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803483:	8b 55 08             	mov    0x8(%ebp),%edx
  803486:	89 50 04             	mov    %edx,0x4(%eax)
  803489:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80348e:	40                   	inc    %eax
  80348f:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803494:	e9 60 01 00 00       	jmp    8035f9 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	8b 50 08             	mov    0x8(%eax),%edx
  80349f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a2:	8b 40 08             	mov    0x8(%eax),%eax
  8034a5:	39 c2                	cmp    %eax,%edx
  8034a7:	0f 82 4c 01 00 00    	jb     8035f9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8034ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b1:	75 14                	jne    8034c7 <insert_sorted_allocList+0x157>
  8034b3:	83 ec 04             	sub    $0x4,%esp
  8034b6:	68 8c 53 80 00       	push   $0x80538c
  8034bb:	6a 73                	push   $0x73
  8034bd:	68 3b 53 80 00       	push   $0x80533b
  8034c2:	e8 c8 e0 ff ff       	call   80158f <_panic>
  8034c7:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8034cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d0:	89 50 04             	mov    %edx,0x4(%eax)
  8034d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d6:	8b 40 04             	mov    0x4(%eax),%eax
  8034d9:	85 c0                	test   %eax,%eax
  8034db:	74 0c                	je     8034e9 <insert_sorted_allocList+0x179>
  8034dd:	a1 44 60 80 00       	mov    0x806044,%eax
  8034e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e5:	89 10                	mov    %edx,(%eax)
  8034e7:	eb 08                	jmp    8034f1 <insert_sorted_allocList+0x181>
  8034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ec:	a3 40 60 80 00       	mov    %eax,0x806040
  8034f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f4:	a3 44 60 80 00       	mov    %eax,0x806044
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803502:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803507:	40                   	inc    %eax
  803508:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80350d:	e9 e7 00 00 00       	jmp    8035f9 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  803512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803515:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  803518:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80351f:	a1 40 60 80 00       	mov    0x806040,%eax
  803524:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803527:	e9 9d 00 00 00       	jmp    8035c9 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80352c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352f:	8b 00                	mov    (%eax),%eax
  803531:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  803534:	8b 45 08             	mov    0x8(%ebp),%eax
  803537:	8b 50 08             	mov    0x8(%eax),%edx
  80353a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353d:	8b 40 08             	mov    0x8(%eax),%eax
  803540:	39 c2                	cmp    %eax,%edx
  803542:	76 7d                	jbe    8035c1 <insert_sorted_allocList+0x251>
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	8b 50 08             	mov    0x8(%eax),%edx
  80354a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354d:	8b 40 08             	mov    0x8(%eax),%eax
  803550:	39 c2                	cmp    %eax,%edx
  803552:	73 6d                	jae    8035c1 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  803554:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803558:	74 06                	je     803560 <insert_sorted_allocList+0x1f0>
  80355a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80355e:	75 14                	jne    803574 <insert_sorted_allocList+0x204>
  803560:	83 ec 04             	sub    $0x4,%esp
  803563:	68 b0 53 80 00       	push   $0x8053b0
  803568:	6a 7f                	push   $0x7f
  80356a:	68 3b 53 80 00       	push   $0x80533b
  80356f:	e8 1b e0 ff ff       	call   80158f <_panic>
  803574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803577:	8b 10                	mov    (%eax),%edx
  803579:	8b 45 08             	mov    0x8(%ebp),%eax
  80357c:	89 10                	mov    %edx,(%eax)
  80357e:	8b 45 08             	mov    0x8(%ebp),%eax
  803581:	8b 00                	mov    (%eax),%eax
  803583:	85 c0                	test   %eax,%eax
  803585:	74 0b                	je     803592 <insert_sorted_allocList+0x222>
  803587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358a:	8b 00                	mov    (%eax),%eax
  80358c:	8b 55 08             	mov    0x8(%ebp),%edx
  80358f:	89 50 04             	mov    %edx,0x4(%eax)
  803592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803595:	8b 55 08             	mov    0x8(%ebp),%edx
  803598:	89 10                	mov    %edx,(%eax)
  80359a:	8b 45 08             	mov    0x8(%ebp),%eax
  80359d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a0:	89 50 04             	mov    %edx,0x4(%eax)
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	8b 00                	mov    (%eax),%eax
  8035a8:	85 c0                	test   %eax,%eax
  8035aa:	75 08                	jne    8035b4 <insert_sorted_allocList+0x244>
  8035ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8035af:	a3 44 60 80 00       	mov    %eax,0x806044
  8035b4:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8035b9:	40                   	inc    %eax
  8035ba:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  8035bf:	eb 39                	jmp    8035fa <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8035c1:	a1 48 60 80 00       	mov    0x806048,%eax
  8035c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035cd:	74 07                	je     8035d6 <insert_sorted_allocList+0x266>
  8035cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d2:	8b 00                	mov    (%eax),%eax
  8035d4:	eb 05                	jmp    8035db <insert_sorted_allocList+0x26b>
  8035d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035db:	a3 48 60 80 00       	mov    %eax,0x806048
  8035e0:	a1 48 60 80 00       	mov    0x806048,%eax
  8035e5:	85 c0                	test   %eax,%eax
  8035e7:	0f 85 3f ff ff ff    	jne    80352c <insert_sorted_allocList+0x1bc>
  8035ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f1:	0f 85 35 ff ff ff    	jne    80352c <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8035f7:	eb 01                	jmp    8035fa <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8035f9:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8035fa:	90                   	nop
  8035fb:	c9                   	leave  
  8035fc:	c3                   	ret    

008035fd <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8035fd:	55                   	push   %ebp
  8035fe:	89 e5                	mov    %esp,%ebp
  803600:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803603:	a1 38 61 80 00       	mov    0x806138,%eax
  803608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80360b:	e9 85 01 00 00       	jmp    803795 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  803610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803613:	8b 40 0c             	mov    0xc(%eax),%eax
  803616:	3b 45 08             	cmp    0x8(%ebp),%eax
  803619:	0f 82 6e 01 00 00    	jb     80378d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803622:	8b 40 0c             	mov    0xc(%eax),%eax
  803625:	3b 45 08             	cmp    0x8(%ebp),%eax
  803628:	0f 85 8a 00 00 00    	jne    8036b8 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80362e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803632:	75 17                	jne    80364b <alloc_block_FF+0x4e>
  803634:	83 ec 04             	sub    $0x4,%esp
  803637:	68 e4 53 80 00       	push   $0x8053e4
  80363c:	68 93 00 00 00       	push   $0x93
  803641:	68 3b 53 80 00       	push   $0x80533b
  803646:	e8 44 df ff ff       	call   80158f <_panic>
  80364b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364e:	8b 00                	mov    (%eax),%eax
  803650:	85 c0                	test   %eax,%eax
  803652:	74 10                	je     803664 <alloc_block_FF+0x67>
  803654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803657:	8b 00                	mov    (%eax),%eax
  803659:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80365c:	8b 52 04             	mov    0x4(%edx),%edx
  80365f:	89 50 04             	mov    %edx,0x4(%eax)
  803662:	eb 0b                	jmp    80366f <alloc_block_FF+0x72>
  803664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803667:	8b 40 04             	mov    0x4(%eax),%eax
  80366a:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80366f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803672:	8b 40 04             	mov    0x4(%eax),%eax
  803675:	85 c0                	test   %eax,%eax
  803677:	74 0f                	je     803688 <alloc_block_FF+0x8b>
  803679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367c:	8b 40 04             	mov    0x4(%eax),%eax
  80367f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803682:	8b 12                	mov    (%edx),%edx
  803684:	89 10                	mov    %edx,(%eax)
  803686:	eb 0a                	jmp    803692 <alloc_block_FF+0x95>
  803688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368b:	8b 00                	mov    (%eax),%eax
  80368d:	a3 38 61 80 00       	mov    %eax,0x806138
  803692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803695:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80369b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a5:	a1 44 61 80 00       	mov    0x806144,%eax
  8036aa:	48                   	dec    %eax
  8036ab:	a3 44 61 80 00       	mov    %eax,0x806144
			   return  point;
  8036b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b3:	e9 10 01 00 00       	jmp    8037c8 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8036b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8036be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036c1:	0f 86 c6 00 00 00    	jbe    80378d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8036c7:	a1 48 61 80 00       	mov    0x806148,%eax
  8036cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8036cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d2:	8b 50 08             	mov    0x8(%eax),%edx
  8036d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d8:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8036db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036de:	8b 55 08             	mov    0x8(%ebp),%edx
  8036e1:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8036e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036e8:	75 17                	jne    803701 <alloc_block_FF+0x104>
  8036ea:	83 ec 04             	sub    $0x4,%esp
  8036ed:	68 e4 53 80 00       	push   $0x8053e4
  8036f2:	68 9b 00 00 00       	push   $0x9b
  8036f7:	68 3b 53 80 00       	push   $0x80533b
  8036fc:	e8 8e de ff ff       	call   80158f <_panic>
  803701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803704:	8b 00                	mov    (%eax),%eax
  803706:	85 c0                	test   %eax,%eax
  803708:	74 10                	je     80371a <alloc_block_FF+0x11d>
  80370a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80370d:	8b 00                	mov    (%eax),%eax
  80370f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803712:	8b 52 04             	mov    0x4(%edx),%edx
  803715:	89 50 04             	mov    %edx,0x4(%eax)
  803718:	eb 0b                	jmp    803725 <alloc_block_FF+0x128>
  80371a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80371d:	8b 40 04             	mov    0x4(%eax),%eax
  803720:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803728:	8b 40 04             	mov    0x4(%eax),%eax
  80372b:	85 c0                	test   %eax,%eax
  80372d:	74 0f                	je     80373e <alloc_block_FF+0x141>
  80372f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803732:	8b 40 04             	mov    0x4(%eax),%eax
  803735:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803738:	8b 12                	mov    (%edx),%edx
  80373a:	89 10                	mov    %edx,(%eax)
  80373c:	eb 0a                	jmp    803748 <alloc_block_FF+0x14b>
  80373e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803741:	8b 00                	mov    (%eax),%eax
  803743:	a3 48 61 80 00       	mov    %eax,0x806148
  803748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803754:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375b:	a1 54 61 80 00       	mov    0x806154,%eax
  803760:	48                   	dec    %eax
  803761:	a3 54 61 80 00       	mov    %eax,0x806154
			   point->sva += size;
  803766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803769:	8b 50 08             	mov    0x8(%eax),%edx
  80376c:	8b 45 08             	mov    0x8(%ebp),%eax
  80376f:	01 c2                	add    %eax,%edx
  803771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803774:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  803777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377a:	8b 40 0c             	mov    0xc(%eax),%eax
  80377d:	2b 45 08             	sub    0x8(%ebp),%eax
  803780:	89 c2                	mov    %eax,%edx
  803782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803785:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  803788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378b:	eb 3b                	jmp    8037c8 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80378d:	a1 40 61 80 00       	mov    0x806140,%eax
  803792:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803795:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803799:	74 07                	je     8037a2 <alloc_block_FF+0x1a5>
  80379b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379e:	8b 00                	mov    (%eax),%eax
  8037a0:	eb 05                	jmp    8037a7 <alloc_block_FF+0x1aa>
  8037a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a7:	a3 40 61 80 00       	mov    %eax,0x806140
  8037ac:	a1 40 61 80 00       	mov    0x806140,%eax
  8037b1:	85 c0                	test   %eax,%eax
  8037b3:	0f 85 57 fe ff ff    	jne    803610 <alloc_block_FF+0x13>
  8037b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037bd:	0f 85 4d fe ff ff    	jne    803610 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8037c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037c8:	c9                   	leave  
  8037c9:	c3                   	ret    

008037ca <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8037ca:	55                   	push   %ebp
  8037cb:	89 e5                	mov    %esp,%ebp
  8037cd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8037d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8037d7:	a1 38 61 80 00       	mov    0x806138,%eax
  8037dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037df:	e9 df 00 00 00       	jmp    8038c3 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8037e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037ed:	0f 82 c8 00 00 00    	jb     8038bb <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8037f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037fc:	0f 85 8a 00 00 00    	jne    80388c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  803802:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803806:	75 17                	jne    80381f <alloc_block_BF+0x55>
  803808:	83 ec 04             	sub    $0x4,%esp
  80380b:	68 e4 53 80 00       	push   $0x8053e4
  803810:	68 b7 00 00 00       	push   $0xb7
  803815:	68 3b 53 80 00       	push   $0x80533b
  80381a:	e8 70 dd ff ff       	call   80158f <_panic>
  80381f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803822:	8b 00                	mov    (%eax),%eax
  803824:	85 c0                	test   %eax,%eax
  803826:	74 10                	je     803838 <alloc_block_BF+0x6e>
  803828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382b:	8b 00                	mov    (%eax),%eax
  80382d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803830:	8b 52 04             	mov    0x4(%edx),%edx
  803833:	89 50 04             	mov    %edx,0x4(%eax)
  803836:	eb 0b                	jmp    803843 <alloc_block_BF+0x79>
  803838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383b:	8b 40 04             	mov    0x4(%eax),%eax
  80383e:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803846:	8b 40 04             	mov    0x4(%eax),%eax
  803849:	85 c0                	test   %eax,%eax
  80384b:	74 0f                	je     80385c <alloc_block_BF+0x92>
  80384d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803850:	8b 40 04             	mov    0x4(%eax),%eax
  803853:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803856:	8b 12                	mov    (%edx),%edx
  803858:	89 10                	mov    %edx,(%eax)
  80385a:	eb 0a                	jmp    803866 <alloc_block_BF+0x9c>
  80385c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385f:	8b 00                	mov    (%eax),%eax
  803861:	a3 38 61 80 00       	mov    %eax,0x806138
  803866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803869:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80386f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803872:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803879:	a1 44 61 80 00       	mov    0x806144,%eax
  80387e:	48                   	dec    %eax
  80387f:	a3 44 61 80 00       	mov    %eax,0x806144
			   return currentMemBlock;
  803884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803887:	e9 4d 01 00 00       	jmp    8039d9 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80388c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388f:	8b 40 0c             	mov    0xc(%eax),%eax
  803892:	3b 45 08             	cmp    0x8(%ebp),%eax
  803895:	76 24                	jbe    8038bb <alloc_block_BF+0xf1>
  803897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389a:	8b 40 0c             	mov    0xc(%eax),%eax
  80389d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8038a0:	73 19                	jae    8038bb <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8038a2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8038a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8038af:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8038b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b5:	8b 40 08             	mov    0x8(%eax),%eax
  8038b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8038bb:	a1 40 61 80 00       	mov    0x806140,%eax
  8038c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038c7:	74 07                	je     8038d0 <alloc_block_BF+0x106>
  8038c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038cc:	8b 00                	mov    (%eax),%eax
  8038ce:	eb 05                	jmp    8038d5 <alloc_block_BF+0x10b>
  8038d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038d5:	a3 40 61 80 00       	mov    %eax,0x806140
  8038da:	a1 40 61 80 00       	mov    0x806140,%eax
  8038df:	85 c0                	test   %eax,%eax
  8038e1:	0f 85 fd fe ff ff    	jne    8037e4 <alloc_block_BF+0x1a>
  8038e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038eb:	0f 85 f3 fe ff ff    	jne    8037e4 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8038f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038f5:	0f 84 d9 00 00 00    	je     8039d4 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8038fb:	a1 48 61 80 00       	mov    0x806148,%eax
  803900:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803906:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803909:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80390c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390f:	8b 55 08             	mov    0x8(%ebp),%edx
  803912:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803919:	75 17                	jne    803932 <alloc_block_BF+0x168>
  80391b:	83 ec 04             	sub    $0x4,%esp
  80391e:	68 e4 53 80 00       	push   $0x8053e4
  803923:	68 c7 00 00 00       	push   $0xc7
  803928:	68 3b 53 80 00       	push   $0x80533b
  80392d:	e8 5d dc ff ff       	call   80158f <_panic>
  803932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803935:	8b 00                	mov    (%eax),%eax
  803937:	85 c0                	test   %eax,%eax
  803939:	74 10                	je     80394b <alloc_block_BF+0x181>
  80393b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393e:	8b 00                	mov    (%eax),%eax
  803940:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803943:	8b 52 04             	mov    0x4(%edx),%edx
  803946:	89 50 04             	mov    %edx,0x4(%eax)
  803949:	eb 0b                	jmp    803956 <alloc_block_BF+0x18c>
  80394b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394e:	8b 40 04             	mov    0x4(%eax),%eax
  803951:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803959:	8b 40 04             	mov    0x4(%eax),%eax
  80395c:	85 c0                	test   %eax,%eax
  80395e:	74 0f                	je     80396f <alloc_block_BF+0x1a5>
  803960:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803963:	8b 40 04             	mov    0x4(%eax),%eax
  803966:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803969:	8b 12                	mov    (%edx),%edx
  80396b:	89 10                	mov    %edx,(%eax)
  80396d:	eb 0a                	jmp    803979 <alloc_block_BF+0x1af>
  80396f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803972:	8b 00                	mov    (%eax),%eax
  803974:	a3 48 61 80 00       	mov    %eax,0x806148
  803979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803982:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803985:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80398c:	a1 54 61 80 00       	mov    0x806154,%eax
  803991:	48                   	dec    %eax
  803992:	a3 54 61 80 00       	mov    %eax,0x806154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803997:	83 ec 08             	sub    $0x8,%esp
  80399a:	ff 75 ec             	pushl  -0x14(%ebp)
  80399d:	68 38 61 80 00       	push   $0x806138
  8039a2:	e8 71 f9 ff ff       	call   803318 <find_block>
  8039a7:	83 c4 10             	add    $0x10,%esp
  8039aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8039ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039b0:	8b 50 08             	mov    0x8(%eax),%edx
  8039b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b6:	01 c2                	add    %eax,%edx
  8039b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039bb:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8039be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8039c4:	2b 45 08             	sub    0x8(%ebp),%eax
  8039c7:	89 c2                	mov    %eax,%edx
  8039c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039cc:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8039cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d2:	eb 05                	jmp    8039d9 <alloc_block_BF+0x20f>
	}
	return NULL;
  8039d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039d9:	c9                   	leave  
  8039da:	c3                   	ret    

008039db <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8039db:	55                   	push   %ebp
  8039dc:	89 e5                	mov    %esp,%ebp
  8039de:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8039e1:	a1 28 60 80 00       	mov    0x806028,%eax
  8039e6:	85 c0                	test   %eax,%eax
  8039e8:	0f 85 de 01 00 00    	jne    803bcc <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8039ee:	a1 38 61 80 00       	mov    0x806138,%eax
  8039f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039f6:	e9 9e 01 00 00       	jmp    803b99 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8039fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803a01:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a04:	0f 82 87 01 00 00    	jb     803b91 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0d:	8b 40 0c             	mov    0xc(%eax),%eax
  803a10:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a13:	0f 85 95 00 00 00    	jne    803aae <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803a19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a1d:	75 17                	jne    803a36 <alloc_block_NF+0x5b>
  803a1f:	83 ec 04             	sub    $0x4,%esp
  803a22:	68 e4 53 80 00       	push   $0x8053e4
  803a27:	68 e0 00 00 00       	push   $0xe0
  803a2c:	68 3b 53 80 00       	push   $0x80533b
  803a31:	e8 59 db ff ff       	call   80158f <_panic>
  803a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a39:	8b 00                	mov    (%eax),%eax
  803a3b:	85 c0                	test   %eax,%eax
  803a3d:	74 10                	je     803a4f <alloc_block_NF+0x74>
  803a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a42:	8b 00                	mov    (%eax),%eax
  803a44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a47:	8b 52 04             	mov    0x4(%edx),%edx
  803a4a:	89 50 04             	mov    %edx,0x4(%eax)
  803a4d:	eb 0b                	jmp    803a5a <alloc_block_NF+0x7f>
  803a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a52:	8b 40 04             	mov    0x4(%eax),%eax
  803a55:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5d:	8b 40 04             	mov    0x4(%eax),%eax
  803a60:	85 c0                	test   %eax,%eax
  803a62:	74 0f                	je     803a73 <alloc_block_NF+0x98>
  803a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a67:	8b 40 04             	mov    0x4(%eax),%eax
  803a6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a6d:	8b 12                	mov    (%edx),%edx
  803a6f:	89 10                	mov    %edx,(%eax)
  803a71:	eb 0a                	jmp    803a7d <alloc_block_NF+0xa2>
  803a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a76:	8b 00                	mov    (%eax),%eax
  803a78:	a3 38 61 80 00       	mov    %eax,0x806138
  803a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a90:	a1 44 61 80 00       	mov    0x806144,%eax
  803a95:	48                   	dec    %eax
  803a96:	a3 44 61 80 00       	mov    %eax,0x806144
				   svaOfNF = point->sva;
  803a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9e:	8b 40 08             	mov    0x8(%eax),%eax
  803aa1:	a3 28 60 80 00       	mov    %eax,0x806028
				   return  point;
  803aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa9:	e9 f8 04 00 00       	jmp    803fa6 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab1:	8b 40 0c             	mov    0xc(%eax),%eax
  803ab4:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ab7:	0f 86 d4 00 00 00    	jbe    803b91 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803abd:	a1 48 61 80 00       	mov    0x806148,%eax
  803ac2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac8:	8b 50 08             	mov    0x8(%eax),%edx
  803acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ace:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad4:	8b 55 08             	mov    0x8(%ebp),%edx
  803ad7:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803ada:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ade:	75 17                	jne    803af7 <alloc_block_NF+0x11c>
  803ae0:	83 ec 04             	sub    $0x4,%esp
  803ae3:	68 e4 53 80 00       	push   $0x8053e4
  803ae8:	68 e9 00 00 00       	push   $0xe9
  803aed:	68 3b 53 80 00       	push   $0x80533b
  803af2:	e8 98 da ff ff       	call   80158f <_panic>
  803af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803afa:	8b 00                	mov    (%eax),%eax
  803afc:	85 c0                	test   %eax,%eax
  803afe:	74 10                	je     803b10 <alloc_block_NF+0x135>
  803b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b03:	8b 00                	mov    (%eax),%eax
  803b05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b08:	8b 52 04             	mov    0x4(%edx),%edx
  803b0b:	89 50 04             	mov    %edx,0x4(%eax)
  803b0e:	eb 0b                	jmp    803b1b <alloc_block_NF+0x140>
  803b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b13:	8b 40 04             	mov    0x4(%eax),%eax
  803b16:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b1e:	8b 40 04             	mov    0x4(%eax),%eax
  803b21:	85 c0                	test   %eax,%eax
  803b23:	74 0f                	je     803b34 <alloc_block_NF+0x159>
  803b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b28:	8b 40 04             	mov    0x4(%eax),%eax
  803b2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b2e:	8b 12                	mov    (%edx),%edx
  803b30:	89 10                	mov    %edx,(%eax)
  803b32:	eb 0a                	jmp    803b3e <alloc_block_NF+0x163>
  803b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b37:	8b 00                	mov    (%eax),%eax
  803b39:	a3 48 61 80 00       	mov    %eax,0x806148
  803b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b51:	a1 54 61 80 00       	mov    0x806154,%eax
  803b56:	48                   	dec    %eax
  803b57:	a3 54 61 80 00       	mov    %eax,0x806154
				   svaOfNF = ReturnedBlock->sva;
  803b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b5f:	8b 40 08             	mov    0x8(%eax),%eax
  803b62:	a3 28 60 80 00       	mov    %eax,0x806028
				   point->sva += size;
  803b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b6a:	8b 50 08             	mov    0x8(%eax),%edx
  803b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b70:	01 c2                	add    %eax,%edx
  803b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b75:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b7b:	8b 40 0c             	mov    0xc(%eax),%eax
  803b7e:	2b 45 08             	sub    0x8(%ebp),%eax
  803b81:	89 c2                	mov    %eax,%edx
  803b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b86:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b8c:	e9 15 04 00 00       	jmp    803fa6 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803b91:	a1 40 61 80 00       	mov    0x806140,%eax
  803b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b9d:	74 07                	je     803ba6 <alloc_block_NF+0x1cb>
  803b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba2:	8b 00                	mov    (%eax),%eax
  803ba4:	eb 05                	jmp    803bab <alloc_block_NF+0x1d0>
  803ba6:	b8 00 00 00 00       	mov    $0x0,%eax
  803bab:	a3 40 61 80 00       	mov    %eax,0x806140
  803bb0:	a1 40 61 80 00       	mov    0x806140,%eax
  803bb5:	85 c0                	test   %eax,%eax
  803bb7:	0f 85 3e fe ff ff    	jne    8039fb <alloc_block_NF+0x20>
  803bbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bc1:	0f 85 34 fe ff ff    	jne    8039fb <alloc_block_NF+0x20>
  803bc7:	e9 d5 03 00 00       	jmp    803fa1 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803bcc:	a1 38 61 80 00       	mov    0x806138,%eax
  803bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bd4:	e9 b1 01 00 00       	jmp    803d8a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdc:	8b 50 08             	mov    0x8(%eax),%edx
  803bdf:	a1 28 60 80 00       	mov    0x806028,%eax
  803be4:	39 c2                	cmp    %eax,%edx
  803be6:	0f 82 96 01 00 00    	jb     803d82 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bef:	8b 40 0c             	mov    0xc(%eax),%eax
  803bf2:	3b 45 08             	cmp    0x8(%ebp),%eax
  803bf5:	0f 82 87 01 00 00    	jb     803d82 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfe:	8b 40 0c             	mov    0xc(%eax),%eax
  803c01:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c04:	0f 85 95 00 00 00    	jne    803c9f <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803c0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c0e:	75 17                	jne    803c27 <alloc_block_NF+0x24c>
  803c10:	83 ec 04             	sub    $0x4,%esp
  803c13:	68 e4 53 80 00       	push   $0x8053e4
  803c18:	68 fc 00 00 00       	push   $0xfc
  803c1d:	68 3b 53 80 00       	push   $0x80533b
  803c22:	e8 68 d9 ff ff       	call   80158f <_panic>
  803c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c2a:	8b 00                	mov    (%eax),%eax
  803c2c:	85 c0                	test   %eax,%eax
  803c2e:	74 10                	je     803c40 <alloc_block_NF+0x265>
  803c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c33:	8b 00                	mov    (%eax),%eax
  803c35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c38:	8b 52 04             	mov    0x4(%edx),%edx
  803c3b:	89 50 04             	mov    %edx,0x4(%eax)
  803c3e:	eb 0b                	jmp    803c4b <alloc_block_NF+0x270>
  803c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c43:	8b 40 04             	mov    0x4(%eax),%eax
  803c46:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c4e:	8b 40 04             	mov    0x4(%eax),%eax
  803c51:	85 c0                	test   %eax,%eax
  803c53:	74 0f                	je     803c64 <alloc_block_NF+0x289>
  803c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c58:	8b 40 04             	mov    0x4(%eax),%eax
  803c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c5e:	8b 12                	mov    (%edx),%edx
  803c60:	89 10                	mov    %edx,(%eax)
  803c62:	eb 0a                	jmp    803c6e <alloc_block_NF+0x293>
  803c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c67:	8b 00                	mov    (%eax),%eax
  803c69:	a3 38 61 80 00       	mov    %eax,0x806138
  803c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c81:	a1 44 61 80 00       	mov    0x806144,%eax
  803c86:	48                   	dec    %eax
  803c87:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c8f:	8b 40 08             	mov    0x8(%eax),%eax
  803c92:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9a:	e9 07 03 00 00       	jmp    803fa6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca2:	8b 40 0c             	mov    0xc(%eax),%eax
  803ca5:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ca8:	0f 86 d4 00 00 00    	jbe    803d82 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803cae:	a1 48 61 80 00       	mov    0x806148,%eax
  803cb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb9:	8b 50 08             	mov    0x8(%eax),%edx
  803cbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cbf:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803cc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  803cc8:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803ccb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ccf:	75 17                	jne    803ce8 <alloc_block_NF+0x30d>
  803cd1:	83 ec 04             	sub    $0x4,%esp
  803cd4:	68 e4 53 80 00       	push   $0x8053e4
  803cd9:	68 04 01 00 00       	push   $0x104
  803cde:	68 3b 53 80 00       	push   $0x80533b
  803ce3:	e8 a7 d8 ff ff       	call   80158f <_panic>
  803ce8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ceb:	8b 00                	mov    (%eax),%eax
  803ced:	85 c0                	test   %eax,%eax
  803cef:	74 10                	je     803d01 <alloc_block_NF+0x326>
  803cf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cf4:	8b 00                	mov    (%eax),%eax
  803cf6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cf9:	8b 52 04             	mov    0x4(%edx),%edx
  803cfc:	89 50 04             	mov    %edx,0x4(%eax)
  803cff:	eb 0b                	jmp    803d0c <alloc_block_NF+0x331>
  803d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d04:	8b 40 04             	mov    0x4(%eax),%eax
  803d07:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803d0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d0f:	8b 40 04             	mov    0x4(%eax),%eax
  803d12:	85 c0                	test   %eax,%eax
  803d14:	74 0f                	je     803d25 <alloc_block_NF+0x34a>
  803d16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d19:	8b 40 04             	mov    0x4(%eax),%eax
  803d1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d1f:	8b 12                	mov    (%edx),%edx
  803d21:	89 10                	mov    %edx,(%eax)
  803d23:	eb 0a                	jmp    803d2f <alloc_block_NF+0x354>
  803d25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d28:	8b 00                	mov    (%eax),%eax
  803d2a:	a3 48 61 80 00       	mov    %eax,0x806148
  803d2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d42:	a1 54 61 80 00       	mov    0x806154,%eax
  803d47:	48                   	dec    %eax
  803d48:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803d4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d50:	8b 40 08             	mov    0x8(%eax),%eax
  803d53:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5b:	8b 50 08             	mov    0x8(%eax),%edx
  803d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d61:	01 c2                	add    %eax,%edx
  803d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d66:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6c:	8b 40 0c             	mov    0xc(%eax),%eax
  803d6f:	2b 45 08             	sub    0x8(%ebp),%eax
  803d72:	89 c2                	mov    %eax,%edx
  803d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d77:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803d7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d7d:	e9 24 02 00 00       	jmp    803fa6 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803d82:	a1 40 61 80 00       	mov    0x806140,%eax
  803d87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d8e:	74 07                	je     803d97 <alloc_block_NF+0x3bc>
  803d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d93:	8b 00                	mov    (%eax),%eax
  803d95:	eb 05                	jmp    803d9c <alloc_block_NF+0x3c1>
  803d97:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9c:	a3 40 61 80 00       	mov    %eax,0x806140
  803da1:	a1 40 61 80 00       	mov    0x806140,%eax
  803da6:	85 c0                	test   %eax,%eax
  803da8:	0f 85 2b fe ff ff    	jne    803bd9 <alloc_block_NF+0x1fe>
  803dae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803db2:	0f 85 21 fe ff ff    	jne    803bd9 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803db8:	a1 38 61 80 00       	mov    0x806138,%eax
  803dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803dc0:	e9 ae 01 00 00       	jmp    803f73 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc8:	8b 50 08             	mov    0x8(%eax),%edx
  803dcb:	a1 28 60 80 00       	mov    0x806028,%eax
  803dd0:	39 c2                	cmp    %eax,%edx
  803dd2:	0f 83 93 01 00 00    	jae    803f6b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ddb:	8b 40 0c             	mov    0xc(%eax),%eax
  803dde:	3b 45 08             	cmp    0x8(%ebp),%eax
  803de1:	0f 82 84 01 00 00    	jb     803f6b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dea:	8b 40 0c             	mov    0xc(%eax),%eax
  803ded:	3b 45 08             	cmp    0x8(%ebp),%eax
  803df0:	0f 85 95 00 00 00    	jne    803e8b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803df6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dfa:	75 17                	jne    803e13 <alloc_block_NF+0x438>
  803dfc:	83 ec 04             	sub    $0x4,%esp
  803dff:	68 e4 53 80 00       	push   $0x8053e4
  803e04:	68 14 01 00 00       	push   $0x114
  803e09:	68 3b 53 80 00       	push   $0x80533b
  803e0e:	e8 7c d7 ff ff       	call   80158f <_panic>
  803e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e16:	8b 00                	mov    (%eax),%eax
  803e18:	85 c0                	test   %eax,%eax
  803e1a:	74 10                	je     803e2c <alloc_block_NF+0x451>
  803e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1f:	8b 00                	mov    (%eax),%eax
  803e21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e24:	8b 52 04             	mov    0x4(%edx),%edx
  803e27:	89 50 04             	mov    %edx,0x4(%eax)
  803e2a:	eb 0b                	jmp    803e37 <alloc_block_NF+0x45c>
  803e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2f:	8b 40 04             	mov    0x4(%eax),%eax
  803e32:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e3a:	8b 40 04             	mov    0x4(%eax),%eax
  803e3d:	85 c0                	test   %eax,%eax
  803e3f:	74 0f                	je     803e50 <alloc_block_NF+0x475>
  803e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e44:	8b 40 04             	mov    0x4(%eax),%eax
  803e47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e4a:	8b 12                	mov    (%edx),%edx
  803e4c:	89 10                	mov    %edx,(%eax)
  803e4e:	eb 0a                	jmp    803e5a <alloc_block_NF+0x47f>
  803e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e53:	8b 00                	mov    (%eax),%eax
  803e55:	a3 38 61 80 00       	mov    %eax,0x806138
  803e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e6d:	a1 44 61 80 00       	mov    0x806144,%eax
  803e72:	48                   	dec    %eax
  803e73:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e7b:	8b 40 08             	mov    0x8(%eax),%eax
  803e7e:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e86:	e9 1b 01 00 00       	jmp    803fa6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e8e:	8b 40 0c             	mov    0xc(%eax),%eax
  803e91:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e94:	0f 86 d1 00 00 00    	jbe    803f6b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803e9a:	a1 48 61 80 00       	mov    0x806148,%eax
  803e9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea5:	8b 50 08             	mov    0x8(%eax),%edx
  803ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eab:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eb1:	8b 55 08             	mov    0x8(%ebp),%edx
  803eb4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803eb7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ebb:	75 17                	jne    803ed4 <alloc_block_NF+0x4f9>
  803ebd:	83 ec 04             	sub    $0x4,%esp
  803ec0:	68 e4 53 80 00       	push   $0x8053e4
  803ec5:	68 1c 01 00 00       	push   $0x11c
  803eca:	68 3b 53 80 00       	push   $0x80533b
  803ecf:	e8 bb d6 ff ff       	call   80158f <_panic>
  803ed4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ed7:	8b 00                	mov    (%eax),%eax
  803ed9:	85 c0                	test   %eax,%eax
  803edb:	74 10                	je     803eed <alloc_block_NF+0x512>
  803edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ee0:	8b 00                	mov    (%eax),%eax
  803ee2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ee5:	8b 52 04             	mov    0x4(%edx),%edx
  803ee8:	89 50 04             	mov    %edx,0x4(%eax)
  803eeb:	eb 0b                	jmp    803ef8 <alloc_block_NF+0x51d>
  803eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ef0:	8b 40 04             	mov    0x4(%eax),%eax
  803ef3:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803efb:	8b 40 04             	mov    0x4(%eax),%eax
  803efe:	85 c0                	test   %eax,%eax
  803f00:	74 0f                	je     803f11 <alloc_block_NF+0x536>
  803f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f05:	8b 40 04             	mov    0x4(%eax),%eax
  803f08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f0b:	8b 12                	mov    (%edx),%edx
  803f0d:	89 10                	mov    %edx,(%eax)
  803f0f:	eb 0a                	jmp    803f1b <alloc_block_NF+0x540>
  803f11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f14:	8b 00                	mov    (%eax),%eax
  803f16:	a3 48 61 80 00       	mov    %eax,0x806148
  803f1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f2e:	a1 54 61 80 00       	mov    0x806154,%eax
  803f33:	48                   	dec    %eax
  803f34:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803f39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f3c:	8b 40 08             	mov    0x8(%eax),%eax
  803f3f:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f47:	8b 50 08             	mov    0x8(%eax),%edx
  803f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4d:	01 c2                	add    %eax,%edx
  803f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f52:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f58:	8b 40 0c             	mov    0xc(%eax),%eax
  803f5b:	2b 45 08             	sub    0x8(%ebp),%eax
  803f5e:	89 c2                	mov    %eax,%edx
  803f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f63:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f69:	eb 3b                	jmp    803fa6 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803f6b:	a1 40 61 80 00       	mov    0x806140,%eax
  803f70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f77:	74 07                	je     803f80 <alloc_block_NF+0x5a5>
  803f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7c:	8b 00                	mov    (%eax),%eax
  803f7e:	eb 05                	jmp    803f85 <alloc_block_NF+0x5aa>
  803f80:	b8 00 00 00 00       	mov    $0x0,%eax
  803f85:	a3 40 61 80 00       	mov    %eax,0x806140
  803f8a:	a1 40 61 80 00       	mov    0x806140,%eax
  803f8f:	85 c0                	test   %eax,%eax
  803f91:	0f 85 2e fe ff ff    	jne    803dc5 <alloc_block_NF+0x3ea>
  803f97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f9b:	0f 85 24 fe ff ff    	jne    803dc5 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803fa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803fa6:	c9                   	leave  
  803fa7:	c3                   	ret    

00803fa8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803fa8:	55                   	push   %ebp
  803fa9:	89 e5                	mov    %esp,%ebp
  803fab:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803fae:	a1 38 61 80 00       	mov    0x806138,%eax
  803fb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803fb6:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803fbb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803fbe:	a1 38 61 80 00       	mov    0x806138,%eax
  803fc3:	85 c0                	test   %eax,%eax
  803fc5:	74 14                	je     803fdb <insert_sorted_with_merge_freeList+0x33>
  803fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  803fca:	8b 50 08             	mov    0x8(%eax),%edx
  803fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fd0:	8b 40 08             	mov    0x8(%eax),%eax
  803fd3:	39 c2                	cmp    %eax,%edx
  803fd5:	0f 87 9b 01 00 00    	ja     804176 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803fdb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803fdf:	75 17                	jne    803ff8 <insert_sorted_with_merge_freeList+0x50>
  803fe1:	83 ec 04             	sub    $0x4,%esp
  803fe4:	68 18 53 80 00       	push   $0x805318
  803fe9:	68 38 01 00 00       	push   $0x138
  803fee:	68 3b 53 80 00       	push   $0x80533b
  803ff3:	e8 97 d5 ff ff       	call   80158f <_panic>
  803ff8:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  804001:	89 10                	mov    %edx,(%eax)
  804003:	8b 45 08             	mov    0x8(%ebp),%eax
  804006:	8b 00                	mov    (%eax),%eax
  804008:	85 c0                	test   %eax,%eax
  80400a:	74 0d                	je     804019 <insert_sorted_with_merge_freeList+0x71>
  80400c:	a1 38 61 80 00       	mov    0x806138,%eax
  804011:	8b 55 08             	mov    0x8(%ebp),%edx
  804014:	89 50 04             	mov    %edx,0x4(%eax)
  804017:	eb 08                	jmp    804021 <insert_sorted_with_merge_freeList+0x79>
  804019:	8b 45 08             	mov    0x8(%ebp),%eax
  80401c:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804021:	8b 45 08             	mov    0x8(%ebp),%eax
  804024:	a3 38 61 80 00       	mov    %eax,0x806138
  804029:	8b 45 08             	mov    0x8(%ebp),%eax
  80402c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804033:	a1 44 61 80 00       	mov    0x806144,%eax
  804038:	40                   	inc    %eax
  804039:	a3 44 61 80 00       	mov    %eax,0x806144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80403e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804042:	0f 84 a8 06 00 00    	je     8046f0 <insert_sorted_with_merge_freeList+0x748>
  804048:	8b 45 08             	mov    0x8(%ebp),%eax
  80404b:	8b 50 08             	mov    0x8(%eax),%edx
  80404e:	8b 45 08             	mov    0x8(%ebp),%eax
  804051:	8b 40 0c             	mov    0xc(%eax),%eax
  804054:	01 c2                	add    %eax,%edx
  804056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804059:	8b 40 08             	mov    0x8(%eax),%eax
  80405c:	39 c2                	cmp    %eax,%edx
  80405e:	0f 85 8c 06 00 00    	jne    8046f0 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  804064:	8b 45 08             	mov    0x8(%ebp),%eax
  804067:	8b 50 0c             	mov    0xc(%eax),%edx
  80406a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80406d:	8b 40 0c             	mov    0xc(%eax),%eax
  804070:	01 c2                	add    %eax,%edx
  804072:	8b 45 08             	mov    0x8(%ebp),%eax
  804075:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  804078:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80407c:	75 17                	jne    804095 <insert_sorted_with_merge_freeList+0xed>
  80407e:	83 ec 04             	sub    $0x4,%esp
  804081:	68 e4 53 80 00       	push   $0x8053e4
  804086:	68 3c 01 00 00       	push   $0x13c
  80408b:	68 3b 53 80 00       	push   $0x80533b
  804090:	e8 fa d4 ff ff       	call   80158f <_panic>
  804095:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804098:	8b 00                	mov    (%eax),%eax
  80409a:	85 c0                	test   %eax,%eax
  80409c:	74 10                	je     8040ae <insert_sorted_with_merge_freeList+0x106>
  80409e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040a1:	8b 00                	mov    (%eax),%eax
  8040a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040a6:	8b 52 04             	mov    0x4(%edx),%edx
  8040a9:	89 50 04             	mov    %edx,0x4(%eax)
  8040ac:	eb 0b                	jmp    8040b9 <insert_sorted_with_merge_freeList+0x111>
  8040ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040b1:	8b 40 04             	mov    0x4(%eax),%eax
  8040b4:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8040b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040bc:	8b 40 04             	mov    0x4(%eax),%eax
  8040bf:	85 c0                	test   %eax,%eax
  8040c1:	74 0f                	je     8040d2 <insert_sorted_with_merge_freeList+0x12a>
  8040c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040c6:	8b 40 04             	mov    0x4(%eax),%eax
  8040c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040cc:	8b 12                	mov    (%edx),%edx
  8040ce:	89 10                	mov    %edx,(%eax)
  8040d0:	eb 0a                	jmp    8040dc <insert_sorted_with_merge_freeList+0x134>
  8040d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040d5:	8b 00                	mov    (%eax),%eax
  8040d7:	a3 38 61 80 00       	mov    %eax,0x806138
  8040dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040ef:	a1 44 61 80 00       	mov    0x806144,%eax
  8040f4:	48                   	dec    %eax
  8040f5:	a3 44 61 80 00       	mov    %eax,0x806144
			head->size = 0;
  8040fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  804104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804107:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80410e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804112:	75 17                	jne    80412b <insert_sorted_with_merge_freeList+0x183>
  804114:	83 ec 04             	sub    $0x4,%esp
  804117:	68 18 53 80 00       	push   $0x805318
  80411c:	68 3f 01 00 00       	push   $0x13f
  804121:	68 3b 53 80 00       	push   $0x80533b
  804126:	e8 64 d4 ff ff       	call   80158f <_panic>
  80412b:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804134:	89 10                	mov    %edx,(%eax)
  804136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804139:	8b 00                	mov    (%eax),%eax
  80413b:	85 c0                	test   %eax,%eax
  80413d:	74 0d                	je     80414c <insert_sorted_with_merge_freeList+0x1a4>
  80413f:	a1 48 61 80 00       	mov    0x806148,%eax
  804144:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804147:	89 50 04             	mov    %edx,0x4(%eax)
  80414a:	eb 08                	jmp    804154 <insert_sorted_with_merge_freeList+0x1ac>
  80414c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80414f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804157:	a3 48 61 80 00       	mov    %eax,0x806148
  80415c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80415f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804166:	a1 54 61 80 00       	mov    0x806154,%eax
  80416b:	40                   	inc    %eax
  80416c:	a3 54 61 80 00       	mov    %eax,0x806154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  804171:	e9 7a 05 00 00       	jmp    8046f0 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  804176:	8b 45 08             	mov    0x8(%ebp),%eax
  804179:	8b 50 08             	mov    0x8(%eax),%edx
  80417c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80417f:	8b 40 08             	mov    0x8(%eax),%eax
  804182:	39 c2                	cmp    %eax,%edx
  804184:	0f 82 14 01 00 00    	jb     80429e <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80418a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80418d:	8b 50 08             	mov    0x8(%eax),%edx
  804190:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804193:	8b 40 0c             	mov    0xc(%eax),%eax
  804196:	01 c2                	add    %eax,%edx
  804198:	8b 45 08             	mov    0x8(%ebp),%eax
  80419b:	8b 40 08             	mov    0x8(%eax),%eax
  80419e:	39 c2                	cmp    %eax,%edx
  8041a0:	0f 85 90 00 00 00    	jne    804236 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8041a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041a9:	8b 50 0c             	mov    0xc(%eax),%edx
  8041ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8041af:	8b 40 0c             	mov    0xc(%eax),%eax
  8041b2:	01 c2                	add    %eax,%edx
  8041b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8041b7:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8041ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8041bd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8041c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8041c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8041ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8041d2:	75 17                	jne    8041eb <insert_sorted_with_merge_freeList+0x243>
  8041d4:	83 ec 04             	sub    $0x4,%esp
  8041d7:	68 18 53 80 00       	push   $0x805318
  8041dc:	68 49 01 00 00       	push   $0x149
  8041e1:	68 3b 53 80 00       	push   $0x80533b
  8041e6:	e8 a4 d3 ff ff       	call   80158f <_panic>
  8041eb:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8041f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f4:	89 10                	mov    %edx,(%eax)
  8041f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f9:	8b 00                	mov    (%eax),%eax
  8041fb:	85 c0                	test   %eax,%eax
  8041fd:	74 0d                	je     80420c <insert_sorted_with_merge_freeList+0x264>
  8041ff:	a1 48 61 80 00       	mov    0x806148,%eax
  804204:	8b 55 08             	mov    0x8(%ebp),%edx
  804207:	89 50 04             	mov    %edx,0x4(%eax)
  80420a:	eb 08                	jmp    804214 <insert_sorted_with_merge_freeList+0x26c>
  80420c:	8b 45 08             	mov    0x8(%ebp),%eax
  80420f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804214:	8b 45 08             	mov    0x8(%ebp),%eax
  804217:	a3 48 61 80 00       	mov    %eax,0x806148
  80421c:	8b 45 08             	mov    0x8(%ebp),%eax
  80421f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804226:	a1 54 61 80 00       	mov    0x806154,%eax
  80422b:	40                   	inc    %eax
  80422c:	a3 54 61 80 00       	mov    %eax,0x806154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804231:	e9 bb 04 00 00       	jmp    8046f1 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  804236:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80423a:	75 17                	jne    804253 <insert_sorted_with_merge_freeList+0x2ab>
  80423c:	83 ec 04             	sub    $0x4,%esp
  80423f:	68 8c 53 80 00       	push   $0x80538c
  804244:	68 4c 01 00 00       	push   $0x14c
  804249:	68 3b 53 80 00       	push   $0x80533b
  80424e:	e8 3c d3 ff ff       	call   80158f <_panic>
  804253:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  804259:	8b 45 08             	mov    0x8(%ebp),%eax
  80425c:	89 50 04             	mov    %edx,0x4(%eax)
  80425f:	8b 45 08             	mov    0x8(%ebp),%eax
  804262:	8b 40 04             	mov    0x4(%eax),%eax
  804265:	85 c0                	test   %eax,%eax
  804267:	74 0c                	je     804275 <insert_sorted_with_merge_freeList+0x2cd>
  804269:	a1 3c 61 80 00       	mov    0x80613c,%eax
  80426e:	8b 55 08             	mov    0x8(%ebp),%edx
  804271:	89 10                	mov    %edx,(%eax)
  804273:	eb 08                	jmp    80427d <insert_sorted_with_merge_freeList+0x2d5>
  804275:	8b 45 08             	mov    0x8(%ebp),%eax
  804278:	a3 38 61 80 00       	mov    %eax,0x806138
  80427d:	8b 45 08             	mov    0x8(%ebp),%eax
  804280:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804285:	8b 45 08             	mov    0x8(%ebp),%eax
  804288:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80428e:	a1 44 61 80 00       	mov    0x806144,%eax
  804293:	40                   	inc    %eax
  804294:	a3 44 61 80 00       	mov    %eax,0x806144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804299:	e9 53 04 00 00       	jmp    8046f1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80429e:	a1 38 61 80 00       	mov    0x806138,%eax
  8042a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8042a6:	e9 15 04 00 00       	jmp    8046c0 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8042ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042ae:	8b 00                	mov    (%eax),%eax
  8042b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8042b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8042b6:	8b 50 08             	mov    0x8(%eax),%edx
  8042b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042bc:	8b 40 08             	mov    0x8(%eax),%eax
  8042bf:	39 c2                	cmp    %eax,%edx
  8042c1:	0f 86 f1 03 00 00    	jbe    8046b8 <insert_sorted_with_merge_freeList+0x710>
  8042c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8042ca:	8b 50 08             	mov    0x8(%eax),%edx
  8042cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042d0:	8b 40 08             	mov    0x8(%eax),%eax
  8042d3:	39 c2                	cmp    %eax,%edx
  8042d5:	0f 83 dd 03 00 00    	jae    8046b8 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8042db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042de:	8b 50 08             	mov    0x8(%eax),%edx
  8042e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8042e7:	01 c2                	add    %eax,%edx
  8042e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8042ec:	8b 40 08             	mov    0x8(%eax),%eax
  8042ef:	39 c2                	cmp    %eax,%edx
  8042f1:	0f 85 b9 01 00 00    	jne    8044b0 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8042f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8042fa:	8b 50 08             	mov    0x8(%eax),%edx
  8042fd:	8b 45 08             	mov    0x8(%ebp),%eax
  804300:	8b 40 0c             	mov    0xc(%eax),%eax
  804303:	01 c2                	add    %eax,%edx
  804305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804308:	8b 40 08             	mov    0x8(%eax),%eax
  80430b:	39 c2                	cmp    %eax,%edx
  80430d:	0f 85 0d 01 00 00    	jne    804420 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  804313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804316:	8b 50 0c             	mov    0xc(%eax),%edx
  804319:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80431c:	8b 40 0c             	mov    0xc(%eax),%eax
  80431f:	01 c2                	add    %eax,%edx
  804321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804324:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  804327:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80432b:	75 17                	jne    804344 <insert_sorted_with_merge_freeList+0x39c>
  80432d:	83 ec 04             	sub    $0x4,%esp
  804330:	68 e4 53 80 00       	push   $0x8053e4
  804335:	68 5c 01 00 00       	push   $0x15c
  80433a:	68 3b 53 80 00       	push   $0x80533b
  80433f:	e8 4b d2 ff ff       	call   80158f <_panic>
  804344:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804347:	8b 00                	mov    (%eax),%eax
  804349:	85 c0                	test   %eax,%eax
  80434b:	74 10                	je     80435d <insert_sorted_with_merge_freeList+0x3b5>
  80434d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804350:	8b 00                	mov    (%eax),%eax
  804352:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804355:	8b 52 04             	mov    0x4(%edx),%edx
  804358:	89 50 04             	mov    %edx,0x4(%eax)
  80435b:	eb 0b                	jmp    804368 <insert_sorted_with_merge_freeList+0x3c0>
  80435d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804360:	8b 40 04             	mov    0x4(%eax),%eax
  804363:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804368:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80436b:	8b 40 04             	mov    0x4(%eax),%eax
  80436e:	85 c0                	test   %eax,%eax
  804370:	74 0f                	je     804381 <insert_sorted_with_merge_freeList+0x3d9>
  804372:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804375:	8b 40 04             	mov    0x4(%eax),%eax
  804378:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80437b:	8b 12                	mov    (%edx),%edx
  80437d:	89 10                	mov    %edx,(%eax)
  80437f:	eb 0a                	jmp    80438b <insert_sorted_with_merge_freeList+0x3e3>
  804381:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804384:	8b 00                	mov    (%eax),%eax
  804386:	a3 38 61 80 00       	mov    %eax,0x806138
  80438b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80438e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804394:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804397:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80439e:	a1 44 61 80 00       	mov    0x806144,%eax
  8043a3:	48                   	dec    %eax
  8043a4:	a3 44 61 80 00       	mov    %eax,0x806144
						nextBlock->sva = 0;
  8043a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8043b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8043bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8043c1:	75 17                	jne    8043da <insert_sorted_with_merge_freeList+0x432>
  8043c3:	83 ec 04             	sub    $0x4,%esp
  8043c6:	68 18 53 80 00       	push   $0x805318
  8043cb:	68 5f 01 00 00       	push   $0x15f
  8043d0:	68 3b 53 80 00       	push   $0x80533b
  8043d5:	e8 b5 d1 ff ff       	call   80158f <_panic>
  8043da:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8043e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043e3:	89 10                	mov    %edx,(%eax)
  8043e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043e8:	8b 00                	mov    (%eax),%eax
  8043ea:	85 c0                	test   %eax,%eax
  8043ec:	74 0d                	je     8043fb <insert_sorted_with_merge_freeList+0x453>
  8043ee:	a1 48 61 80 00       	mov    0x806148,%eax
  8043f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8043f6:	89 50 04             	mov    %edx,0x4(%eax)
  8043f9:	eb 08                	jmp    804403 <insert_sorted_with_merge_freeList+0x45b>
  8043fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043fe:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804403:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804406:	a3 48 61 80 00       	mov    %eax,0x806148
  80440b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80440e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804415:	a1 54 61 80 00       	mov    0x806154,%eax
  80441a:	40                   	inc    %eax
  80441b:	a3 54 61 80 00       	mov    %eax,0x806154
					}
					currentBlock->size += blockToInsert->size;
  804420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804423:	8b 50 0c             	mov    0xc(%eax),%edx
  804426:	8b 45 08             	mov    0x8(%ebp),%eax
  804429:	8b 40 0c             	mov    0xc(%eax),%eax
  80442c:	01 c2                	add    %eax,%edx
  80442e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804431:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  804434:	8b 45 08             	mov    0x8(%ebp),%eax
  804437:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80443e:	8b 45 08             	mov    0x8(%ebp),%eax
  804441:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  804448:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80444c:	75 17                	jne    804465 <insert_sorted_with_merge_freeList+0x4bd>
  80444e:	83 ec 04             	sub    $0x4,%esp
  804451:	68 18 53 80 00       	push   $0x805318
  804456:	68 64 01 00 00       	push   $0x164
  80445b:	68 3b 53 80 00       	push   $0x80533b
  804460:	e8 2a d1 ff ff       	call   80158f <_panic>
  804465:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80446b:	8b 45 08             	mov    0x8(%ebp),%eax
  80446e:	89 10                	mov    %edx,(%eax)
  804470:	8b 45 08             	mov    0x8(%ebp),%eax
  804473:	8b 00                	mov    (%eax),%eax
  804475:	85 c0                	test   %eax,%eax
  804477:	74 0d                	je     804486 <insert_sorted_with_merge_freeList+0x4de>
  804479:	a1 48 61 80 00       	mov    0x806148,%eax
  80447e:	8b 55 08             	mov    0x8(%ebp),%edx
  804481:	89 50 04             	mov    %edx,0x4(%eax)
  804484:	eb 08                	jmp    80448e <insert_sorted_with_merge_freeList+0x4e6>
  804486:	8b 45 08             	mov    0x8(%ebp),%eax
  804489:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80448e:	8b 45 08             	mov    0x8(%ebp),%eax
  804491:	a3 48 61 80 00       	mov    %eax,0x806148
  804496:	8b 45 08             	mov    0x8(%ebp),%eax
  804499:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8044a0:	a1 54 61 80 00       	mov    0x806154,%eax
  8044a5:	40                   	inc    %eax
  8044a6:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  8044ab:	e9 41 02 00 00       	jmp    8046f1 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8044b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8044b3:	8b 50 08             	mov    0x8(%eax),%edx
  8044b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8044b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8044bc:	01 c2                	add    %eax,%edx
  8044be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044c1:	8b 40 08             	mov    0x8(%eax),%eax
  8044c4:	39 c2                	cmp    %eax,%edx
  8044c6:	0f 85 7c 01 00 00    	jne    804648 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8044cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8044d0:	74 06                	je     8044d8 <insert_sorted_with_merge_freeList+0x530>
  8044d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8044d6:	75 17                	jne    8044ef <insert_sorted_with_merge_freeList+0x547>
  8044d8:	83 ec 04             	sub    $0x4,%esp
  8044db:	68 54 53 80 00       	push   $0x805354
  8044e0:	68 69 01 00 00       	push   $0x169
  8044e5:	68 3b 53 80 00       	push   $0x80533b
  8044ea:	e8 a0 d0 ff ff       	call   80158f <_panic>
  8044ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044f2:	8b 50 04             	mov    0x4(%eax),%edx
  8044f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8044f8:	89 50 04             	mov    %edx,0x4(%eax)
  8044fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8044fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804501:	89 10                	mov    %edx,(%eax)
  804503:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804506:	8b 40 04             	mov    0x4(%eax),%eax
  804509:	85 c0                	test   %eax,%eax
  80450b:	74 0d                	je     80451a <insert_sorted_with_merge_freeList+0x572>
  80450d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804510:	8b 40 04             	mov    0x4(%eax),%eax
  804513:	8b 55 08             	mov    0x8(%ebp),%edx
  804516:	89 10                	mov    %edx,(%eax)
  804518:	eb 08                	jmp    804522 <insert_sorted_with_merge_freeList+0x57a>
  80451a:	8b 45 08             	mov    0x8(%ebp),%eax
  80451d:	a3 38 61 80 00       	mov    %eax,0x806138
  804522:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804525:	8b 55 08             	mov    0x8(%ebp),%edx
  804528:	89 50 04             	mov    %edx,0x4(%eax)
  80452b:	a1 44 61 80 00       	mov    0x806144,%eax
  804530:	40                   	inc    %eax
  804531:	a3 44 61 80 00       	mov    %eax,0x806144
					blockToInsert->size += nextBlock->size;
  804536:	8b 45 08             	mov    0x8(%ebp),%eax
  804539:	8b 50 0c             	mov    0xc(%eax),%edx
  80453c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80453f:	8b 40 0c             	mov    0xc(%eax),%eax
  804542:	01 c2                	add    %eax,%edx
  804544:	8b 45 08             	mov    0x8(%ebp),%eax
  804547:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80454a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80454e:	75 17                	jne    804567 <insert_sorted_with_merge_freeList+0x5bf>
  804550:	83 ec 04             	sub    $0x4,%esp
  804553:	68 e4 53 80 00       	push   $0x8053e4
  804558:	68 6b 01 00 00       	push   $0x16b
  80455d:	68 3b 53 80 00       	push   $0x80533b
  804562:	e8 28 d0 ff ff       	call   80158f <_panic>
  804567:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80456a:	8b 00                	mov    (%eax),%eax
  80456c:	85 c0                	test   %eax,%eax
  80456e:	74 10                	je     804580 <insert_sorted_with_merge_freeList+0x5d8>
  804570:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804573:	8b 00                	mov    (%eax),%eax
  804575:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804578:	8b 52 04             	mov    0x4(%edx),%edx
  80457b:	89 50 04             	mov    %edx,0x4(%eax)
  80457e:	eb 0b                	jmp    80458b <insert_sorted_with_merge_freeList+0x5e3>
  804580:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804583:	8b 40 04             	mov    0x4(%eax),%eax
  804586:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80458b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80458e:	8b 40 04             	mov    0x4(%eax),%eax
  804591:	85 c0                	test   %eax,%eax
  804593:	74 0f                	je     8045a4 <insert_sorted_with_merge_freeList+0x5fc>
  804595:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804598:	8b 40 04             	mov    0x4(%eax),%eax
  80459b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80459e:	8b 12                	mov    (%edx),%edx
  8045a0:	89 10                	mov    %edx,(%eax)
  8045a2:	eb 0a                	jmp    8045ae <insert_sorted_with_merge_freeList+0x606>
  8045a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045a7:	8b 00                	mov    (%eax),%eax
  8045a9:	a3 38 61 80 00       	mov    %eax,0x806138
  8045ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8045b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045c1:	a1 44 61 80 00       	mov    0x806144,%eax
  8045c6:	48                   	dec    %eax
  8045c7:	a3 44 61 80 00       	mov    %eax,0x806144
					nextBlock->sva = 0;
  8045cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8045d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8045e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8045e4:	75 17                	jne    8045fd <insert_sorted_with_merge_freeList+0x655>
  8045e6:	83 ec 04             	sub    $0x4,%esp
  8045e9:	68 18 53 80 00       	push   $0x805318
  8045ee:	68 6e 01 00 00       	push   $0x16e
  8045f3:	68 3b 53 80 00       	push   $0x80533b
  8045f8:	e8 92 cf ff ff       	call   80158f <_panic>
  8045fd:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804603:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804606:	89 10                	mov    %edx,(%eax)
  804608:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80460b:	8b 00                	mov    (%eax),%eax
  80460d:	85 c0                	test   %eax,%eax
  80460f:	74 0d                	je     80461e <insert_sorted_with_merge_freeList+0x676>
  804611:	a1 48 61 80 00       	mov    0x806148,%eax
  804616:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804619:	89 50 04             	mov    %edx,0x4(%eax)
  80461c:	eb 08                	jmp    804626 <insert_sorted_with_merge_freeList+0x67e>
  80461e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804621:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804626:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804629:	a3 48 61 80 00       	mov    %eax,0x806148
  80462e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804631:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804638:	a1 54 61 80 00       	mov    0x806154,%eax
  80463d:	40                   	inc    %eax
  80463e:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  804643:	e9 a9 00 00 00       	jmp    8046f1 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  804648:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80464c:	74 06                	je     804654 <insert_sorted_with_merge_freeList+0x6ac>
  80464e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804652:	75 17                	jne    80466b <insert_sorted_with_merge_freeList+0x6c3>
  804654:	83 ec 04             	sub    $0x4,%esp
  804657:	68 b0 53 80 00       	push   $0x8053b0
  80465c:	68 73 01 00 00       	push   $0x173
  804661:	68 3b 53 80 00       	push   $0x80533b
  804666:	e8 24 cf ff ff       	call   80158f <_panic>
  80466b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80466e:	8b 10                	mov    (%eax),%edx
  804670:	8b 45 08             	mov    0x8(%ebp),%eax
  804673:	89 10                	mov    %edx,(%eax)
  804675:	8b 45 08             	mov    0x8(%ebp),%eax
  804678:	8b 00                	mov    (%eax),%eax
  80467a:	85 c0                	test   %eax,%eax
  80467c:	74 0b                	je     804689 <insert_sorted_with_merge_freeList+0x6e1>
  80467e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804681:	8b 00                	mov    (%eax),%eax
  804683:	8b 55 08             	mov    0x8(%ebp),%edx
  804686:	89 50 04             	mov    %edx,0x4(%eax)
  804689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80468c:	8b 55 08             	mov    0x8(%ebp),%edx
  80468f:	89 10                	mov    %edx,(%eax)
  804691:	8b 45 08             	mov    0x8(%ebp),%eax
  804694:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804697:	89 50 04             	mov    %edx,0x4(%eax)
  80469a:	8b 45 08             	mov    0x8(%ebp),%eax
  80469d:	8b 00                	mov    (%eax),%eax
  80469f:	85 c0                	test   %eax,%eax
  8046a1:	75 08                	jne    8046ab <insert_sorted_with_merge_freeList+0x703>
  8046a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8046a6:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8046ab:	a1 44 61 80 00       	mov    0x806144,%eax
  8046b0:	40                   	inc    %eax
  8046b1:	a3 44 61 80 00       	mov    %eax,0x806144
					break;
  8046b6:	eb 39                	jmp    8046f1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8046b8:	a1 40 61 80 00       	mov    0x806140,%eax
  8046bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8046c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8046c4:	74 07                	je     8046cd <insert_sorted_with_merge_freeList+0x725>
  8046c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046c9:	8b 00                	mov    (%eax),%eax
  8046cb:	eb 05                	jmp    8046d2 <insert_sorted_with_merge_freeList+0x72a>
  8046cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8046d2:	a3 40 61 80 00       	mov    %eax,0x806140
  8046d7:	a1 40 61 80 00       	mov    0x806140,%eax
  8046dc:	85 c0                	test   %eax,%eax
  8046de:	0f 85 c7 fb ff ff    	jne    8042ab <insert_sorted_with_merge_freeList+0x303>
  8046e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8046e8:	0f 85 bd fb ff ff    	jne    8042ab <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8046ee:	eb 01                	jmp    8046f1 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8046f0:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8046f1:	90                   	nop
  8046f2:	c9                   	leave  
  8046f3:	c3                   	ret    

008046f4 <__udivdi3>:
  8046f4:	55                   	push   %ebp
  8046f5:	57                   	push   %edi
  8046f6:	56                   	push   %esi
  8046f7:	53                   	push   %ebx
  8046f8:	83 ec 1c             	sub    $0x1c,%esp
  8046fb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8046ff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804703:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804707:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80470b:	89 ca                	mov    %ecx,%edx
  80470d:	89 f8                	mov    %edi,%eax
  80470f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804713:	85 f6                	test   %esi,%esi
  804715:	75 2d                	jne    804744 <__udivdi3+0x50>
  804717:	39 cf                	cmp    %ecx,%edi
  804719:	77 65                	ja     804780 <__udivdi3+0x8c>
  80471b:	89 fd                	mov    %edi,%ebp
  80471d:	85 ff                	test   %edi,%edi
  80471f:	75 0b                	jne    80472c <__udivdi3+0x38>
  804721:	b8 01 00 00 00       	mov    $0x1,%eax
  804726:	31 d2                	xor    %edx,%edx
  804728:	f7 f7                	div    %edi
  80472a:	89 c5                	mov    %eax,%ebp
  80472c:	31 d2                	xor    %edx,%edx
  80472e:	89 c8                	mov    %ecx,%eax
  804730:	f7 f5                	div    %ebp
  804732:	89 c1                	mov    %eax,%ecx
  804734:	89 d8                	mov    %ebx,%eax
  804736:	f7 f5                	div    %ebp
  804738:	89 cf                	mov    %ecx,%edi
  80473a:	89 fa                	mov    %edi,%edx
  80473c:	83 c4 1c             	add    $0x1c,%esp
  80473f:	5b                   	pop    %ebx
  804740:	5e                   	pop    %esi
  804741:	5f                   	pop    %edi
  804742:	5d                   	pop    %ebp
  804743:	c3                   	ret    
  804744:	39 ce                	cmp    %ecx,%esi
  804746:	77 28                	ja     804770 <__udivdi3+0x7c>
  804748:	0f bd fe             	bsr    %esi,%edi
  80474b:	83 f7 1f             	xor    $0x1f,%edi
  80474e:	75 40                	jne    804790 <__udivdi3+0x9c>
  804750:	39 ce                	cmp    %ecx,%esi
  804752:	72 0a                	jb     80475e <__udivdi3+0x6a>
  804754:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804758:	0f 87 9e 00 00 00    	ja     8047fc <__udivdi3+0x108>
  80475e:	b8 01 00 00 00       	mov    $0x1,%eax
  804763:	89 fa                	mov    %edi,%edx
  804765:	83 c4 1c             	add    $0x1c,%esp
  804768:	5b                   	pop    %ebx
  804769:	5e                   	pop    %esi
  80476a:	5f                   	pop    %edi
  80476b:	5d                   	pop    %ebp
  80476c:	c3                   	ret    
  80476d:	8d 76 00             	lea    0x0(%esi),%esi
  804770:	31 ff                	xor    %edi,%edi
  804772:	31 c0                	xor    %eax,%eax
  804774:	89 fa                	mov    %edi,%edx
  804776:	83 c4 1c             	add    $0x1c,%esp
  804779:	5b                   	pop    %ebx
  80477a:	5e                   	pop    %esi
  80477b:	5f                   	pop    %edi
  80477c:	5d                   	pop    %ebp
  80477d:	c3                   	ret    
  80477e:	66 90                	xchg   %ax,%ax
  804780:	89 d8                	mov    %ebx,%eax
  804782:	f7 f7                	div    %edi
  804784:	31 ff                	xor    %edi,%edi
  804786:	89 fa                	mov    %edi,%edx
  804788:	83 c4 1c             	add    $0x1c,%esp
  80478b:	5b                   	pop    %ebx
  80478c:	5e                   	pop    %esi
  80478d:	5f                   	pop    %edi
  80478e:	5d                   	pop    %ebp
  80478f:	c3                   	ret    
  804790:	bd 20 00 00 00       	mov    $0x20,%ebp
  804795:	89 eb                	mov    %ebp,%ebx
  804797:	29 fb                	sub    %edi,%ebx
  804799:	89 f9                	mov    %edi,%ecx
  80479b:	d3 e6                	shl    %cl,%esi
  80479d:	89 c5                	mov    %eax,%ebp
  80479f:	88 d9                	mov    %bl,%cl
  8047a1:	d3 ed                	shr    %cl,%ebp
  8047a3:	89 e9                	mov    %ebp,%ecx
  8047a5:	09 f1                	or     %esi,%ecx
  8047a7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8047ab:	89 f9                	mov    %edi,%ecx
  8047ad:	d3 e0                	shl    %cl,%eax
  8047af:	89 c5                	mov    %eax,%ebp
  8047b1:	89 d6                	mov    %edx,%esi
  8047b3:	88 d9                	mov    %bl,%cl
  8047b5:	d3 ee                	shr    %cl,%esi
  8047b7:	89 f9                	mov    %edi,%ecx
  8047b9:	d3 e2                	shl    %cl,%edx
  8047bb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047bf:	88 d9                	mov    %bl,%cl
  8047c1:	d3 e8                	shr    %cl,%eax
  8047c3:	09 c2                	or     %eax,%edx
  8047c5:	89 d0                	mov    %edx,%eax
  8047c7:	89 f2                	mov    %esi,%edx
  8047c9:	f7 74 24 0c          	divl   0xc(%esp)
  8047cd:	89 d6                	mov    %edx,%esi
  8047cf:	89 c3                	mov    %eax,%ebx
  8047d1:	f7 e5                	mul    %ebp
  8047d3:	39 d6                	cmp    %edx,%esi
  8047d5:	72 19                	jb     8047f0 <__udivdi3+0xfc>
  8047d7:	74 0b                	je     8047e4 <__udivdi3+0xf0>
  8047d9:	89 d8                	mov    %ebx,%eax
  8047db:	31 ff                	xor    %edi,%edi
  8047dd:	e9 58 ff ff ff       	jmp    80473a <__udivdi3+0x46>
  8047e2:	66 90                	xchg   %ax,%ax
  8047e4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8047e8:	89 f9                	mov    %edi,%ecx
  8047ea:	d3 e2                	shl    %cl,%edx
  8047ec:	39 c2                	cmp    %eax,%edx
  8047ee:	73 e9                	jae    8047d9 <__udivdi3+0xe5>
  8047f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8047f3:	31 ff                	xor    %edi,%edi
  8047f5:	e9 40 ff ff ff       	jmp    80473a <__udivdi3+0x46>
  8047fa:	66 90                	xchg   %ax,%ax
  8047fc:	31 c0                	xor    %eax,%eax
  8047fe:	e9 37 ff ff ff       	jmp    80473a <__udivdi3+0x46>
  804803:	90                   	nop

00804804 <__umoddi3>:
  804804:	55                   	push   %ebp
  804805:	57                   	push   %edi
  804806:	56                   	push   %esi
  804807:	53                   	push   %ebx
  804808:	83 ec 1c             	sub    $0x1c,%esp
  80480b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80480f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804813:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804817:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80481b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80481f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804823:	89 f3                	mov    %esi,%ebx
  804825:	89 fa                	mov    %edi,%edx
  804827:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80482b:	89 34 24             	mov    %esi,(%esp)
  80482e:	85 c0                	test   %eax,%eax
  804830:	75 1a                	jne    80484c <__umoddi3+0x48>
  804832:	39 f7                	cmp    %esi,%edi
  804834:	0f 86 a2 00 00 00    	jbe    8048dc <__umoddi3+0xd8>
  80483a:	89 c8                	mov    %ecx,%eax
  80483c:	89 f2                	mov    %esi,%edx
  80483e:	f7 f7                	div    %edi
  804840:	89 d0                	mov    %edx,%eax
  804842:	31 d2                	xor    %edx,%edx
  804844:	83 c4 1c             	add    $0x1c,%esp
  804847:	5b                   	pop    %ebx
  804848:	5e                   	pop    %esi
  804849:	5f                   	pop    %edi
  80484a:	5d                   	pop    %ebp
  80484b:	c3                   	ret    
  80484c:	39 f0                	cmp    %esi,%eax
  80484e:	0f 87 ac 00 00 00    	ja     804900 <__umoddi3+0xfc>
  804854:	0f bd e8             	bsr    %eax,%ebp
  804857:	83 f5 1f             	xor    $0x1f,%ebp
  80485a:	0f 84 ac 00 00 00    	je     80490c <__umoddi3+0x108>
  804860:	bf 20 00 00 00       	mov    $0x20,%edi
  804865:	29 ef                	sub    %ebp,%edi
  804867:	89 fe                	mov    %edi,%esi
  804869:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80486d:	89 e9                	mov    %ebp,%ecx
  80486f:	d3 e0                	shl    %cl,%eax
  804871:	89 d7                	mov    %edx,%edi
  804873:	89 f1                	mov    %esi,%ecx
  804875:	d3 ef                	shr    %cl,%edi
  804877:	09 c7                	or     %eax,%edi
  804879:	89 e9                	mov    %ebp,%ecx
  80487b:	d3 e2                	shl    %cl,%edx
  80487d:	89 14 24             	mov    %edx,(%esp)
  804880:	89 d8                	mov    %ebx,%eax
  804882:	d3 e0                	shl    %cl,%eax
  804884:	89 c2                	mov    %eax,%edx
  804886:	8b 44 24 08          	mov    0x8(%esp),%eax
  80488a:	d3 e0                	shl    %cl,%eax
  80488c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804890:	8b 44 24 08          	mov    0x8(%esp),%eax
  804894:	89 f1                	mov    %esi,%ecx
  804896:	d3 e8                	shr    %cl,%eax
  804898:	09 d0                	or     %edx,%eax
  80489a:	d3 eb                	shr    %cl,%ebx
  80489c:	89 da                	mov    %ebx,%edx
  80489e:	f7 f7                	div    %edi
  8048a0:	89 d3                	mov    %edx,%ebx
  8048a2:	f7 24 24             	mull   (%esp)
  8048a5:	89 c6                	mov    %eax,%esi
  8048a7:	89 d1                	mov    %edx,%ecx
  8048a9:	39 d3                	cmp    %edx,%ebx
  8048ab:	0f 82 87 00 00 00    	jb     804938 <__umoddi3+0x134>
  8048b1:	0f 84 91 00 00 00    	je     804948 <__umoddi3+0x144>
  8048b7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8048bb:	29 f2                	sub    %esi,%edx
  8048bd:	19 cb                	sbb    %ecx,%ebx
  8048bf:	89 d8                	mov    %ebx,%eax
  8048c1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8048c5:	d3 e0                	shl    %cl,%eax
  8048c7:	89 e9                	mov    %ebp,%ecx
  8048c9:	d3 ea                	shr    %cl,%edx
  8048cb:	09 d0                	or     %edx,%eax
  8048cd:	89 e9                	mov    %ebp,%ecx
  8048cf:	d3 eb                	shr    %cl,%ebx
  8048d1:	89 da                	mov    %ebx,%edx
  8048d3:	83 c4 1c             	add    $0x1c,%esp
  8048d6:	5b                   	pop    %ebx
  8048d7:	5e                   	pop    %esi
  8048d8:	5f                   	pop    %edi
  8048d9:	5d                   	pop    %ebp
  8048da:	c3                   	ret    
  8048db:	90                   	nop
  8048dc:	89 fd                	mov    %edi,%ebp
  8048de:	85 ff                	test   %edi,%edi
  8048e0:	75 0b                	jne    8048ed <__umoddi3+0xe9>
  8048e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8048e7:	31 d2                	xor    %edx,%edx
  8048e9:	f7 f7                	div    %edi
  8048eb:	89 c5                	mov    %eax,%ebp
  8048ed:	89 f0                	mov    %esi,%eax
  8048ef:	31 d2                	xor    %edx,%edx
  8048f1:	f7 f5                	div    %ebp
  8048f3:	89 c8                	mov    %ecx,%eax
  8048f5:	f7 f5                	div    %ebp
  8048f7:	89 d0                	mov    %edx,%eax
  8048f9:	e9 44 ff ff ff       	jmp    804842 <__umoddi3+0x3e>
  8048fe:	66 90                	xchg   %ax,%ax
  804900:	89 c8                	mov    %ecx,%eax
  804902:	89 f2                	mov    %esi,%edx
  804904:	83 c4 1c             	add    $0x1c,%esp
  804907:	5b                   	pop    %ebx
  804908:	5e                   	pop    %esi
  804909:	5f                   	pop    %edi
  80490a:	5d                   	pop    %ebp
  80490b:	c3                   	ret    
  80490c:	3b 04 24             	cmp    (%esp),%eax
  80490f:	72 06                	jb     804917 <__umoddi3+0x113>
  804911:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804915:	77 0f                	ja     804926 <__umoddi3+0x122>
  804917:	89 f2                	mov    %esi,%edx
  804919:	29 f9                	sub    %edi,%ecx
  80491b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80491f:	89 14 24             	mov    %edx,(%esp)
  804922:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804926:	8b 44 24 04          	mov    0x4(%esp),%eax
  80492a:	8b 14 24             	mov    (%esp),%edx
  80492d:	83 c4 1c             	add    $0x1c,%esp
  804930:	5b                   	pop    %ebx
  804931:	5e                   	pop    %esi
  804932:	5f                   	pop    %edi
  804933:	5d                   	pop    %ebp
  804934:	c3                   	ret    
  804935:	8d 76 00             	lea    0x0(%esi),%esi
  804938:	2b 04 24             	sub    (%esp),%eax
  80493b:	19 fa                	sbb    %edi,%edx
  80493d:	89 d1                	mov    %edx,%ecx
  80493f:	89 c6                	mov    %eax,%esi
  804941:	e9 71 ff ff ff       	jmp    8048b7 <__umoddi3+0xb3>
  804946:	66 90                	xchg   %ax,%ax
  804948:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80494c:	72 ea                	jb     804938 <__umoddi3+0x134>
  80494e:	89 d9                	mov    %ebx,%ecx
  804950:	e9 62 ff ff ff       	jmp    8048b7 <__umoddi3+0xb3>
