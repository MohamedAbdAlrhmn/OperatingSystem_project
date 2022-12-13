
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
  8000a3:	68 e0 48 80 00       	push   $0x8048e0
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 21 49 80 00       	push   $0x804921
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
  8000d9:	68 e0 48 80 00       	push   $0x8048e0
  8000de:	6a 21                	push   $0x21
  8000e0:	68 21 49 80 00       	push   $0x804921
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
  80010f:	68 e0 48 80 00       	push   $0x8048e0
  800114:	6a 22                	push   $0x22
  800116:	68 21 49 80 00       	push   $0x804921
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
  800145:	68 e0 48 80 00       	push   $0x8048e0
  80014a:	6a 23                	push   $0x23
  80014c:	68 21 49 80 00       	push   $0x804921
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
  80017b:	68 e0 48 80 00       	push   $0x8048e0
  800180:	6a 24                	push   $0x24
  800182:	68 21 49 80 00       	push   $0x804921
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
  8001b1:	68 e0 48 80 00       	push   $0x8048e0
  8001b6:	6a 25                	push   $0x25
  8001b8:	68 21 49 80 00       	push   $0x804921
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
  8001e9:	68 e0 48 80 00       	push   $0x8048e0
  8001ee:	6a 26                	push   $0x26
  8001f0:	68 21 49 80 00       	push   $0x804921
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
  800221:	68 e0 48 80 00       	push   $0x8048e0
  800226:	6a 27                	push   $0x27
  800228:	68 21 49 80 00       	push   $0x804921
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
  800259:	68 e0 48 80 00       	push   $0x8048e0
  80025e:	6a 28                	push   $0x28
  800260:	68 21 49 80 00       	push   $0x804921
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
  800291:	68 e0 48 80 00       	push   $0x8048e0
  800296:	6a 29                	push   $0x29
  800298:	68 21 49 80 00       	push   $0x804921
  80029d:	e8 ed 12 00 00       	call   80158f <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8002a7:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 34 49 80 00       	push   $0x804934
  8002b9:	6a 2a                	push   $0x2a
  8002bb:	68 21 49 80 00       	push   $0x804921
  8002c0:	e8 ca 12 00 00       	call   80158f <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 d6 27 00 00       	call   802aa0 <sys_calculate_free_frames>
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
  8002e1:	e8 5a 28 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  80031d:	68 7c 49 80 00       	push   $0x80497c
  800322:	6a 39                	push   $0x39
  800324:	68 21 49 80 00       	push   $0x804921
  800329:	e8 61 12 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032e:	e8 0d 28 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
  800333:	2b 45 90             	sub    -0x70(%ebp),%eax
  800336:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 e4 49 80 00       	push   $0x8049e4
  800345:	6a 3a                	push   $0x3a
  800347:	68 21 49 80 00       	push   $0x804921
  80034c:	e8 3e 12 00 00       	call   80158f <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 ea 27 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  8003a6:	68 7c 49 80 00       	push   $0x80497c
  8003ab:	6a 40                	push   $0x40
  8003ad:	68 21 49 80 00       	push   $0x804921
  8003b2:	e8 d8 11 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b7:	e8 84 27 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  8003dd:	68 e4 49 80 00       	push   $0x8049e4
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 21 49 80 00       	push   $0x804921
  8003e9:	e8 a1 11 00 00       	call   80158f <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ee:	e8 4d 27 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  80044a:	68 7c 49 80 00       	push   $0x80497c
  80044f:	6a 47                	push   $0x47
  800451:	68 21 49 80 00       	push   $0x804921
  800456:	e8 34 11 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045b:	e8 e0 26 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  80047e:	68 e4 49 80 00       	push   $0x8049e4
  800483:	6a 48                	push   $0x48
  800485:	68 21 49 80 00       	push   $0x804921
  80048a:	e8 00 11 00 00       	call   80158f <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 ac 26 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  8004fa:	68 7c 49 80 00       	push   $0x80497c
  8004ff:	6a 4e                	push   $0x4e
  800501:	68 21 49 80 00       	push   $0x804921
  800506:	e8 84 10 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050b:	e8 30 26 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  800535:	68 e4 49 80 00       	push   $0x8049e4
  80053a:	6a 4f                	push   $0x4f
  80053c:	68 21 49 80 00       	push   $0x804921
  800541:	e8 49 10 00 00       	call   80158f <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800546:	e8 55 25 00 00       	call   802aa0 <sys_calculate_free_frames>
  80054b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054e:	e8 66 25 00 00       	call   802ab9 <sys_calculate_modified_frames>
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
  80060f:	e8 8c 24 00 00       	call   802aa0 <sys_calculate_free_frames>
  800614:	89 c3                	mov    %eax,%ebx
  800616:	e8 9e 24 00 00       	call   802ab9 <sys_calculate_modified_frames>
  80061b:	01 d8                	add    %ebx,%eax
  80061d:	29 c6                	sub    %eax,%esi
  80061f:	89 f0                	mov    %esi,%eax
  800621:	83 f8 02             	cmp    $0x2,%eax
  800624:	74 14                	je     80063a <_main+0x602>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 14 4a 80 00       	push   $0x804a14
  80062e:	6a 67                	push   $0x67
  800630:	68 21 49 80 00       	push   $0x804921
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
  8006d1:	68 58 4a 80 00       	push   $0x804a58
  8006d6:	6a 73                	push   $0x73
  8006d8:	68 21 49 80 00       	push   $0x804921
  8006dd:	e8 ad 0e 00 00       	call   80158f <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e2:	e8 b9 23 00 00       	call   802aa0 <sys_calculate_free_frames>
  8006e7:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006ea:	e8 ca 23 00 00       	call   802ab9 <sys_calculate_modified_frames>
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
  8007eb:	e8 b0 22 00 00       	call   802aa0 <sys_calculate_free_frames>
  8007f0:	29 c3                	sub    %eax,%ebx
  8007f2:	89 d8                	mov    %ebx,%eax
  8007f4:	83 f8 04             	cmp    $0x4,%eax
  8007f7:	74 17                	je     800810 <_main+0x7d8>
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 14 4a 80 00       	push   $0x804a14
  800801:	68 8e 00 00 00       	push   $0x8e
  800806:	68 21 49 80 00       	push   $0x804921
  80080b:	e8 7f 0d 00 00       	call   80158f <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800810:	8b 5d 88             	mov    -0x78(%ebp),%ebx
  800813:	e8 a1 22 00 00       	call   802ab9 <sys_calculate_modified_frames>
  800818:	29 c3                	sub    %eax,%ebx
  80081a:	89 d8                	mov    %ebx,%eax
  80081c:	83 f8 fe             	cmp    $0xfffffffe,%eax
  80081f:	74 17                	je     800838 <_main+0x800>
  800821:	83 ec 04             	sub    $0x4,%esp
  800824:	68 14 4a 80 00       	push   $0x804a14
  800829:	68 8f 00 00 00       	push   $0x8f
  80082e:	68 21 49 80 00       	push   $0x804921
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
  8008d1:	68 58 4a 80 00       	push   $0x804a58
  8008d6:	68 9b 00 00 00       	push   $0x9b
  8008db:	68 21 49 80 00       	push   $0x804921
  8008e0:	e8 aa 0c 00 00       	call   80158f <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008e5:	e8 b6 21 00 00       	call   802aa0 <sys_calculate_free_frames>
  8008ea:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008ed:	e8 c7 21 00 00       	call   802ab9 <sys_calculate_modified_frames>
  8008f2:	89 45 88             	mov    %eax,-0x78(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008f5:	e8 46 22 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
  8008fa:	89 45 90             	mov    %eax,-0x70(%ebp)

		free(ptr_allocations[1]);
  8008fd:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800903:	83 ec 0c             	sub    $0xc,%esp
  800906:	50                   	push   %eax
  800907:	e8 3a 1f 00 00       	call   802846 <free>
  80090c:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80090f:	e8 2c 22 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  800937:	68 78 4a 80 00       	push   $0x804a78
  80093c:	68 a5 00 00 00       	push   $0xa5
  800941:	68 21 49 80 00       	push   $0x804921
  800946:	e8 44 0c 00 00       	call   80158f <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  80094b:	e8 50 21 00 00       	call   802aa0 <sys_calculate_free_frames>
  800950:	89 c2                	mov    %eax,%edx
  800952:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800955:	29 c2                	sub    %eax,%edx
  800957:	89 d0                	mov    %edx,%eax
  800959:	83 f8 07             	cmp    $0x7,%eax
  80095c:	74 17                	je     800975 <_main+0x93d>
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	68 b4 4a 80 00       	push   $0x804ab4
  800966:	68 a7 00 00 00       	push   $0xa7
  80096b:	68 21 49 80 00       	push   $0x804921
  800970:	e8 1a 0c 00 00       	call   80158f <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800975:	e8 3f 21 00 00       	call   802ab9 <sys_calculate_modified_frames>
  80097a:	89 c2                	mov    %eax,%edx
  80097c:	8b 45 88             	mov    -0x78(%ebp),%eax
  80097f:	29 c2                	sub    %eax,%edx
  800981:	89 d0                	mov    %edx,%eax
  800983:	83 f8 02             	cmp    $0x2,%eax
  800986:	74 17                	je     80099f <_main+0x967>
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 08 4b 80 00       	push   $0x804b08
  800990:	68 a8 00 00 00       	push   $0xa8
  800995:	68 21 49 80 00       	push   $0x804921
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
  800a0e:	68 40 4b 80 00       	push   $0x804b40
  800a13:	68 b0 00 00 00       	push   $0xb0
  800a18:	68 21 49 80 00       	push   $0x804921
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
  800a41:	e8 5a 20 00 00       	call   802aa0 <sys_calculate_free_frames>
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
  800a8e:	e8 0d 20 00 00       	call   802aa0 <sys_calculate_free_frames>
  800a93:	29 c3                	sub    %eax,%ebx
  800a95:	89 d8                	mov    %ebx,%eax
  800a97:	83 f8 02             	cmp    $0x2,%eax
  800a9a:	74 17                	je     800ab3 <_main+0xa7b>
  800a9c:	83 ec 04             	sub    $0x4,%esp
  800a9f:	68 14 4a 80 00       	push   $0x804a14
  800aa4:	68 bc 00 00 00       	push   $0xbc
  800aa9:	68 21 49 80 00       	push   $0x804921
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
  800b89:	68 58 4a 80 00       	push   $0x804a58
  800b8e:	68 c5 00 00 00       	push   $0xc5
  800b93:	68 21 49 80 00       	push   $0x804921
  800b98:	e8 f2 09 00 00       	call   80158f <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b9d:	e8 9e 1f 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  800bed:	68 7c 49 80 00       	push   $0x80497c
  800bf2:	68 ca 00 00 00       	push   $0xca
  800bf7:	68 21 49 80 00       	push   $0x804921
  800bfc:	e8 8e 09 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800c01:	e8 3a 1f 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
  800c06:	2b 45 90             	sub    -0x70(%ebp),%eax
  800c09:	83 f8 01             	cmp    $0x1,%eax
  800c0c:	74 17                	je     800c25 <_main+0xbed>
  800c0e:	83 ec 04             	sub    $0x4,%esp
  800c11:	68 e4 49 80 00       	push   $0x8049e4
  800c16:	68 cb 00 00 00       	push   $0xcb
  800c1b:	68 21 49 80 00       	push   $0x804921
  800c20:	e8 6a 09 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c25:	e8 76 1e 00 00       	call   802aa0 <sys_calculate_free_frames>
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
  800c70:	e8 2b 1e 00 00       	call   802aa0 <sys_calculate_free_frames>
  800c75:	29 c3                	sub    %eax,%ebx
  800c77:	89 d8                	mov    %ebx,%eax
  800c79:	83 f8 02             	cmp    $0x2,%eax
  800c7c:	74 17                	je     800c95 <_main+0xc5d>
  800c7e:	83 ec 04             	sub    $0x4,%esp
  800c81:	68 14 4a 80 00       	push   $0x804a14
  800c86:	68 d2 00 00 00       	push   $0xd2
  800c8b:	68 21 49 80 00       	push   $0x804921
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
  800d6e:	68 58 4a 80 00       	push   $0x804a58
  800d73:	68 db 00 00 00       	push   $0xdb
  800d78:	68 21 49 80 00       	push   $0x804921
  800d7d:	e8 0d 08 00 00       	call   80158f <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d82:	e8 19 1d 00 00       	call   802aa0 <sys_calculate_free_frames>
  800d87:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d8a:	e8 b1 1d 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  800dee:	68 7c 49 80 00       	push   $0x80497c
  800df3:	68 e1 00 00 00       	push   $0xe1
  800df8:	68 21 49 80 00       	push   $0x804921
  800dfd:	e8 8d 07 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800e02:	e8 39 1d 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
  800e07:	2b 45 90             	sub    -0x70(%ebp),%eax
  800e0a:	83 f8 01             	cmp    $0x1,%eax
  800e0d:	74 17                	je     800e26 <_main+0xdee>
  800e0f:	83 ec 04             	sub    $0x4,%esp
  800e12:	68 e4 49 80 00       	push   $0x8049e4
  800e17:	68 e2 00 00 00       	push   $0xe2
  800e1c:	68 21 49 80 00       	push   $0x804921
  800e21:	e8 69 07 00 00       	call   80158f <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e26:	e8 15 1d 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  800e92:	68 7c 49 80 00       	push   $0x80497c
  800e97:	68 e8 00 00 00       	push   $0xe8
  800e9c:	68 21 49 80 00       	push   $0x804921
  800ea1:	e8 e9 06 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800ea6:	e8 95 1c 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
  800eab:	2b 45 90             	sub    -0x70(%ebp),%eax
  800eae:	83 f8 02             	cmp    $0x2,%eax
  800eb1:	74 17                	je     800eca <_main+0xe92>
  800eb3:	83 ec 04             	sub    $0x4,%esp
  800eb6:	68 e4 49 80 00       	push   $0x8049e4
  800ebb:	68 e9 00 00 00       	push   $0xe9
  800ec0:	68 21 49 80 00       	push   $0x804921
  800ec5:	e8 c5 06 00 00       	call   80158f <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800eca:	e8 d1 1b 00 00       	call   802aa0 <sys_calculate_free_frames>
  800ecf:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800ed2:	e8 69 1c 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  800f3d:	68 7c 49 80 00       	push   $0x80497c
  800f42:	68 f0 00 00 00       	push   $0xf0
  800f47:	68 21 49 80 00       	push   $0x804921
  800f4c:	e8 3e 06 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f51:	e8 ea 1b 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  800f77:	68 e4 49 80 00       	push   $0x8049e4
  800f7c:	68 f1 00 00 00       	push   $0xf1
  800f81:	68 21 49 80 00       	push   $0x804921
  800f86:	e8 04 06 00 00       	call   80158f <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8b:	e8 b0 1b 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  801006:	68 7c 49 80 00       	push   $0x80497c
  80100b:	68 f7 00 00 00       	push   $0xf7
  801010:	68 21 49 80 00       	push   $0x804921
  801015:	e8 75 05 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  80101a:	e8 21 1b 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  801042:	68 e4 49 80 00       	push   $0x8049e4
  801047:	68 f8 00 00 00       	push   $0xf8
  80104c:	68 21 49 80 00       	push   $0x804921
  801051:	e8 39 05 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801056:	e8 45 1a 00 00       	call   802aa0 <sys_calculate_free_frames>
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
  8010c7:	e8 d4 19 00 00       	call   802aa0 <sys_calculate_free_frames>
  8010cc:	29 c3                	sub    %eax,%ebx
  8010ce:	89 d8                	mov    %ebx,%eax
  8010d0:	83 f8 05             	cmp    $0x5,%eax
  8010d3:	74 17                	je     8010ec <_main+0x10b4>
  8010d5:	83 ec 04             	sub    $0x4,%esp
  8010d8:	68 14 4a 80 00       	push   $0x804a14
  8010dd:	68 00 01 00 00       	push   $0x100
  8010e2:	68 21 49 80 00       	push   $0x804921
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
  80121d:	68 58 4a 80 00       	push   $0x804a58
  801222:	68 0b 01 00 00       	push   $0x10b
  801227:	68 21 49 80 00       	push   $0x804921
  80122c:	e8 5e 03 00 00       	call   80158f <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801231:	e8 0a 19 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
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
  8012af:	68 7c 49 80 00       	push   $0x80497c
  8012b4:	68 10 01 00 00       	push   $0x110
  8012b9:	68 21 49 80 00       	push   $0x804921
  8012be:	e8 cc 02 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012c3:	e8 78 18 00 00       	call   802b40 <sys_pf_calculate_allocated_pages>
  8012c8:	2b 45 90             	sub    -0x70(%ebp),%eax
  8012cb:	83 f8 04             	cmp    $0x4,%eax
  8012ce:	74 17                	je     8012e7 <_main+0x12af>
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	68 e4 49 80 00       	push   $0x8049e4
  8012d8:	68 11 01 00 00       	push   $0x111
  8012dd:	68 21 49 80 00       	push   $0x804921
  8012e2:	e8 a8 02 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8012e7:	e8 b4 17 00 00       	call   802aa0 <sys_calculate_free_frames>
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
  80133b:	e8 60 17 00 00       	call   802aa0 <sys_calculate_free_frames>
  801340:	29 c3                	sub    %eax,%ebx
  801342:	89 d8                	mov    %ebx,%eax
  801344:	83 f8 02             	cmp    $0x2,%eax
  801347:	74 17                	je     801360 <_main+0x1328>
  801349:	83 ec 04             	sub    $0x4,%esp
  80134c:	68 14 4a 80 00       	push   $0x804a14
  801351:	68 18 01 00 00       	push   $0x118
  801356:	68 21 49 80 00       	push   $0x804921
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
  801436:	68 58 4a 80 00       	push   $0x804a58
  80143b:	68 21 01 00 00       	push   $0x121
  801440:	68 21 49 80 00       	push   $0x804921
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
  801459:	e8 22 19 00 00       	call   802d80 <sys_getenvindex>
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
  8014c4:	e8 c4 16 00 00       	call   802b8d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8014c9:	83 ec 0c             	sub    $0xc,%esp
  8014cc:	68 7c 4b 80 00       	push   $0x804b7c
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
  8014f4:	68 a4 4b 80 00       	push   $0x804ba4
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
  801525:	68 cc 4b 80 00       	push   $0x804bcc
  80152a:	e8 14 03 00 00       	call   801843 <cprintf>
  80152f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801532:	a1 20 60 80 00       	mov    0x806020,%eax
  801537:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80153d:	83 ec 08             	sub    $0x8,%esp
  801540:	50                   	push   %eax
  801541:	68 24 4c 80 00       	push   $0x804c24
  801546:	e8 f8 02 00 00       	call   801843 <cprintf>
  80154b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80154e:	83 ec 0c             	sub    $0xc,%esp
  801551:	68 7c 4b 80 00       	push   $0x804b7c
  801556:	e8 e8 02 00 00       	call   801843 <cprintf>
  80155b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80155e:	e8 44 16 00 00       	call   802ba7 <sys_enable_interrupt>

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
  801576:	e8 d1 17 00 00       	call   802d4c <sys_destroy_env>
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
  801587:	e8 26 18 00 00       	call   802db2 <sys_exit_env>
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
  8015b0:	68 38 4c 80 00       	push   $0x804c38
  8015b5:	e8 89 02 00 00       	call   801843 <cprintf>
  8015ba:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8015bd:	a1 00 60 80 00       	mov    0x806000,%eax
  8015c2:	ff 75 0c             	pushl  0xc(%ebp)
  8015c5:	ff 75 08             	pushl  0x8(%ebp)
  8015c8:	50                   	push   %eax
  8015c9:	68 3d 4c 80 00       	push   $0x804c3d
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
  8015ed:	68 59 4c 80 00       	push   $0x804c59
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
  801619:	68 5c 4c 80 00       	push   $0x804c5c
  80161e:	6a 26                	push   $0x26
  801620:	68 a8 4c 80 00       	push   $0x804ca8
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
  8016eb:	68 b4 4c 80 00       	push   $0x804cb4
  8016f0:	6a 3a                	push   $0x3a
  8016f2:	68 a8 4c 80 00       	push   $0x804ca8
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
  80175b:	68 08 4d 80 00       	push   $0x804d08
  801760:	6a 44                	push   $0x44
  801762:	68 a8 4c 80 00       	push   $0x804ca8
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
  8017b5:	e8 25 12 00 00       	call   8029df <sys_cputs>
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
  80182c:	e8 ae 11 00 00       	call   8029df <sys_cputs>
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
  801876:	e8 12 13 00 00       	call   802b8d <sys_disable_interrupt>
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
  801896:	e8 0c 13 00 00       	call   802ba7 <sys_enable_interrupt>
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
  8018e0:	e8 7f 2d 00 00       	call   804664 <__udivdi3>
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
  801930:	e8 3f 2e 00 00       	call   804774 <__umoddi3>
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	05 74 4f 80 00       	add    $0x804f74,%eax
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
  801a8b:	8b 04 85 98 4f 80 00 	mov    0x804f98(,%eax,4),%eax
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
  801b6c:	8b 34 9d e0 4d 80 00 	mov    0x804de0(,%ebx,4),%esi
  801b73:	85 f6                	test   %esi,%esi
  801b75:	75 19                	jne    801b90 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801b77:	53                   	push   %ebx
  801b78:	68 85 4f 80 00       	push   $0x804f85
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
  801b91:	68 8e 4f 80 00       	push   $0x804f8e
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
  801bbe:	be 91 4f 80 00       	mov    $0x804f91,%esi
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
  8025e4:	68 f0 50 80 00       	push   $0x8050f0
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
  8026b4:	e8 6a 04 00 00       	call   802b23 <sys_allocate_chunk>
  8026b9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8026bc:	a1 20 61 80 00       	mov    0x806120,%eax
  8026c1:	83 ec 0c             	sub    $0xc,%esp
  8026c4:	50                   	push   %eax
  8026c5:	e8 df 0a 00 00       	call   8031a9 <initialize_MemBlocksList>
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
  8026f2:	68 15 51 80 00       	push   $0x805115
  8026f7:	6a 33                	push   $0x33
  8026f9:	68 33 51 80 00       	push   $0x805133
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
  802771:	68 40 51 80 00       	push   $0x805140
  802776:	6a 34                	push   $0x34
  802778:	68 33 51 80 00       	push   $0x805133
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
  802809:	e8 e3 06 00 00       	call   802ef1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80280e:	85 c0                	test   %eax,%eax
  802810:	74 11                	je     802823 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  802812:	83 ec 0c             	sub    $0xc,%esp
  802815:	ff 75 e8             	pushl  -0x18(%ebp)
  802818:	e8 4e 0d 00 00       	call   80356b <alloc_block_FF>
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
  80282f:	e8 aa 0a 00 00       	call   8032de <insert_sorted_allocList>
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
  80284f:	68 64 51 80 00       	push   $0x805164
  802854:	6a 6f                	push   $0x6f
  802856:	68 33 51 80 00       	push   $0x805133
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
  802875:	75 07                	jne    80287e <smalloc+0x1e>
  802877:	b8 00 00 00 00       	mov    $0x0,%eax
  80287c:	eb 7c                	jmp    8028fa <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80287e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802885:	8b 55 0c             	mov    0xc(%ebp),%edx
  802888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288b:	01 d0                	add    %edx,%eax
  80288d:	48                   	dec    %eax
  80288e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802894:	ba 00 00 00 00       	mov    $0x0,%edx
  802899:	f7 75 f0             	divl   -0x10(%ebp)
  80289c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289f:	29 d0                	sub    %edx,%eax
  8028a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8028a4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8028ab:	e8 41 06 00 00       	call   802ef1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	74 11                	je     8028c5 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8028b4:	83 ec 0c             	sub    $0xc,%esp
  8028b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8028ba:	e8 ac 0c 00 00       	call   80356b <alloc_block_FF>
  8028bf:	83 c4 10             	add    $0x10,%esp
  8028c2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8028c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c9:	74 2a                	je     8028f5 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	8b 40 08             	mov    0x8(%eax),%eax
  8028d1:	89 c2                	mov    %eax,%edx
  8028d3:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8028d7:	52                   	push   %edx
  8028d8:	50                   	push   %eax
  8028d9:	ff 75 0c             	pushl  0xc(%ebp)
  8028dc:	ff 75 08             	pushl  0x8(%ebp)
  8028df:	e8 92 03 00 00       	call   802c76 <sys_createSharedObject>
  8028e4:	83 c4 10             	add    $0x10,%esp
  8028e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8028ea:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8028ee:	74 05                	je     8028f5 <smalloc+0x95>
			return (void*)virtual_address;
  8028f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f3:	eb 05                	jmp    8028fa <smalloc+0x9a>
	}
	return NULL;
  8028f5:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8028fa:	c9                   	leave  
  8028fb:	c3                   	ret    

008028fc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8028fc:	55                   	push   %ebp
  8028fd:	89 e5                	mov    %esp,%ebp
  8028ff:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802902:	e8 c6 fc ff ff       	call   8025cd <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802907:	83 ec 04             	sub    $0x4,%esp
  80290a:	68 88 51 80 00       	push   $0x805188
  80290f:	68 b0 00 00 00       	push   $0xb0
  802914:	68 33 51 80 00       	push   $0x805133
  802919:	e8 71 ec ff ff       	call   80158f <_panic>

0080291e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80291e:	55                   	push   %ebp
  80291f:	89 e5                	mov    %esp,%ebp
  802921:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802924:	e8 a4 fc ff ff       	call   8025cd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802929:	83 ec 04             	sub    $0x4,%esp
  80292c:	68 ac 51 80 00       	push   $0x8051ac
  802931:	68 f4 00 00 00       	push   $0xf4
  802936:	68 33 51 80 00       	push   $0x805133
  80293b:	e8 4f ec ff ff       	call   80158f <_panic>

00802940 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
  802943:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802946:	83 ec 04             	sub    $0x4,%esp
  802949:	68 d4 51 80 00       	push   $0x8051d4
  80294e:	68 08 01 00 00       	push   $0x108
  802953:	68 33 51 80 00       	push   $0x805133
  802958:	e8 32 ec ff ff       	call   80158f <_panic>

0080295d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80295d:	55                   	push   %ebp
  80295e:	89 e5                	mov    %esp,%ebp
  802960:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802963:	83 ec 04             	sub    $0x4,%esp
  802966:	68 f8 51 80 00       	push   $0x8051f8
  80296b:	68 13 01 00 00       	push   $0x113
  802970:	68 33 51 80 00       	push   $0x805133
  802975:	e8 15 ec ff ff       	call   80158f <_panic>

0080297a <shrink>:

}
void shrink(uint32 newSize)
{
  80297a:	55                   	push   %ebp
  80297b:	89 e5                	mov    %esp,%ebp
  80297d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802980:	83 ec 04             	sub    $0x4,%esp
  802983:	68 f8 51 80 00       	push   $0x8051f8
  802988:	68 18 01 00 00       	push   $0x118
  80298d:	68 33 51 80 00       	push   $0x805133
  802992:	e8 f8 eb ff ff       	call   80158f <_panic>

00802997 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802997:	55                   	push   %ebp
  802998:	89 e5                	mov    %esp,%ebp
  80299a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80299d:	83 ec 04             	sub    $0x4,%esp
  8029a0:	68 f8 51 80 00       	push   $0x8051f8
  8029a5:	68 1d 01 00 00       	push   $0x11d
  8029aa:	68 33 51 80 00       	push   $0x805133
  8029af:	e8 db eb ff ff       	call   80158f <_panic>

008029b4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8029b4:	55                   	push   %ebp
  8029b5:	89 e5                	mov    %esp,%ebp
  8029b7:	57                   	push   %edi
  8029b8:	56                   	push   %esi
  8029b9:	53                   	push   %ebx
  8029ba:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029c6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8029c9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8029cc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8029cf:	cd 30                	int    $0x30
  8029d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8029d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8029d7:	83 c4 10             	add    $0x10,%esp
  8029da:	5b                   	pop    %ebx
  8029db:	5e                   	pop    %esi
  8029dc:	5f                   	pop    %edi
  8029dd:	5d                   	pop    %ebp
  8029de:	c3                   	ret    

008029df <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8029df:	55                   	push   %ebp
  8029e0:	89 e5                	mov    %esp,%ebp
  8029e2:	83 ec 04             	sub    $0x4,%esp
  8029e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8029e8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8029eb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 00                	push   $0x0
  8029f6:	52                   	push   %edx
  8029f7:	ff 75 0c             	pushl  0xc(%ebp)
  8029fa:	50                   	push   %eax
  8029fb:	6a 00                	push   $0x0
  8029fd:	e8 b2 ff ff ff       	call   8029b4 <syscall>
  802a02:	83 c4 18             	add    $0x18,%esp
}
  802a05:	90                   	nop
  802a06:	c9                   	leave  
  802a07:	c3                   	ret    

00802a08 <sys_cgetc>:

int
sys_cgetc(void)
{
  802a08:	55                   	push   %ebp
  802a09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802a0b:	6a 00                	push   $0x0
  802a0d:	6a 00                	push   $0x0
  802a0f:	6a 00                	push   $0x0
  802a11:	6a 00                	push   $0x0
  802a13:	6a 00                	push   $0x0
  802a15:	6a 01                	push   $0x1
  802a17:	e8 98 ff ff ff       	call   8029b4 <syscall>
  802a1c:	83 c4 18             	add    $0x18,%esp
}
  802a1f:	c9                   	leave  
  802a20:	c3                   	ret    

00802a21 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802a21:	55                   	push   %ebp
  802a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802a24:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	6a 00                	push   $0x0
  802a2c:	6a 00                	push   $0x0
  802a2e:	6a 00                	push   $0x0
  802a30:	52                   	push   %edx
  802a31:	50                   	push   %eax
  802a32:	6a 05                	push   $0x5
  802a34:	e8 7b ff ff ff       	call   8029b4 <syscall>
  802a39:	83 c4 18             	add    $0x18,%esp
}
  802a3c:	c9                   	leave  
  802a3d:	c3                   	ret    

00802a3e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802a3e:	55                   	push   %ebp
  802a3f:	89 e5                	mov    %esp,%ebp
  802a41:	56                   	push   %esi
  802a42:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802a43:	8b 75 18             	mov    0x18(%ebp),%esi
  802a46:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a49:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	56                   	push   %esi
  802a53:	53                   	push   %ebx
  802a54:	51                   	push   %ecx
  802a55:	52                   	push   %edx
  802a56:	50                   	push   %eax
  802a57:	6a 06                	push   $0x6
  802a59:	e8 56 ff ff ff       	call   8029b4 <syscall>
  802a5e:	83 c4 18             	add    $0x18,%esp
}
  802a61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a64:	5b                   	pop    %ebx
  802a65:	5e                   	pop    %esi
  802a66:	5d                   	pop    %ebp
  802a67:	c3                   	ret    

00802a68 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802a68:	55                   	push   %ebp
  802a69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a71:	6a 00                	push   $0x0
  802a73:	6a 00                	push   $0x0
  802a75:	6a 00                	push   $0x0
  802a77:	52                   	push   %edx
  802a78:	50                   	push   %eax
  802a79:	6a 07                	push   $0x7
  802a7b:	e8 34 ff ff ff       	call   8029b4 <syscall>
  802a80:	83 c4 18             	add    $0x18,%esp
}
  802a83:	c9                   	leave  
  802a84:	c3                   	ret    

00802a85 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802a85:	55                   	push   %ebp
  802a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802a88:	6a 00                	push   $0x0
  802a8a:	6a 00                	push   $0x0
  802a8c:	6a 00                	push   $0x0
  802a8e:	ff 75 0c             	pushl  0xc(%ebp)
  802a91:	ff 75 08             	pushl  0x8(%ebp)
  802a94:	6a 08                	push   $0x8
  802a96:	e8 19 ff ff ff       	call   8029b4 <syscall>
  802a9b:	83 c4 18             	add    $0x18,%esp
}
  802a9e:	c9                   	leave  
  802a9f:	c3                   	ret    

00802aa0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802aa0:	55                   	push   %ebp
  802aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802aa3:	6a 00                	push   $0x0
  802aa5:	6a 00                	push   $0x0
  802aa7:	6a 00                	push   $0x0
  802aa9:	6a 00                	push   $0x0
  802aab:	6a 00                	push   $0x0
  802aad:	6a 09                	push   $0x9
  802aaf:	e8 00 ff ff ff       	call   8029b4 <syscall>
  802ab4:	83 c4 18             	add    $0x18,%esp
}
  802ab7:	c9                   	leave  
  802ab8:	c3                   	ret    

00802ab9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802ab9:	55                   	push   %ebp
  802aba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802abc:	6a 00                	push   $0x0
  802abe:	6a 00                	push   $0x0
  802ac0:	6a 00                	push   $0x0
  802ac2:	6a 00                	push   $0x0
  802ac4:	6a 00                	push   $0x0
  802ac6:	6a 0a                	push   $0xa
  802ac8:	e8 e7 fe ff ff       	call   8029b4 <syscall>
  802acd:	83 c4 18             	add    $0x18,%esp
}
  802ad0:	c9                   	leave  
  802ad1:	c3                   	ret    

00802ad2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802ad2:	55                   	push   %ebp
  802ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802ad5:	6a 00                	push   $0x0
  802ad7:	6a 00                	push   $0x0
  802ad9:	6a 00                	push   $0x0
  802adb:	6a 00                	push   $0x0
  802add:	6a 00                	push   $0x0
  802adf:	6a 0b                	push   $0xb
  802ae1:	e8 ce fe ff ff       	call   8029b4 <syscall>
  802ae6:	83 c4 18             	add    $0x18,%esp
}
  802ae9:	c9                   	leave  
  802aea:	c3                   	ret    

00802aeb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802aeb:	55                   	push   %ebp
  802aec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802aee:	6a 00                	push   $0x0
  802af0:	6a 00                	push   $0x0
  802af2:	6a 00                	push   $0x0
  802af4:	ff 75 0c             	pushl  0xc(%ebp)
  802af7:	ff 75 08             	pushl  0x8(%ebp)
  802afa:	6a 0f                	push   $0xf
  802afc:	e8 b3 fe ff ff       	call   8029b4 <syscall>
  802b01:	83 c4 18             	add    $0x18,%esp
	return;
  802b04:	90                   	nop
}
  802b05:	c9                   	leave  
  802b06:	c3                   	ret    

00802b07 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802b07:	55                   	push   %ebp
  802b08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802b0a:	6a 00                	push   $0x0
  802b0c:	6a 00                	push   $0x0
  802b0e:	6a 00                	push   $0x0
  802b10:	ff 75 0c             	pushl  0xc(%ebp)
  802b13:	ff 75 08             	pushl  0x8(%ebp)
  802b16:	6a 10                	push   $0x10
  802b18:	e8 97 fe ff ff       	call   8029b4 <syscall>
  802b1d:	83 c4 18             	add    $0x18,%esp
	return ;
  802b20:	90                   	nop
}
  802b21:	c9                   	leave  
  802b22:	c3                   	ret    

00802b23 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b23:	55                   	push   %ebp
  802b24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b26:	6a 00                	push   $0x0
  802b28:	6a 00                	push   $0x0
  802b2a:	ff 75 10             	pushl  0x10(%ebp)
  802b2d:	ff 75 0c             	pushl  0xc(%ebp)
  802b30:	ff 75 08             	pushl  0x8(%ebp)
  802b33:	6a 11                	push   $0x11
  802b35:	e8 7a fe ff ff       	call   8029b4 <syscall>
  802b3a:	83 c4 18             	add    $0x18,%esp
	return ;
  802b3d:	90                   	nop
}
  802b3e:	c9                   	leave  
  802b3f:	c3                   	ret    

00802b40 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802b40:	55                   	push   %ebp
  802b41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802b43:	6a 00                	push   $0x0
  802b45:	6a 00                	push   $0x0
  802b47:	6a 00                	push   $0x0
  802b49:	6a 00                	push   $0x0
  802b4b:	6a 00                	push   $0x0
  802b4d:	6a 0c                	push   $0xc
  802b4f:	e8 60 fe ff ff       	call   8029b4 <syscall>
  802b54:	83 c4 18             	add    $0x18,%esp
}
  802b57:	c9                   	leave  
  802b58:	c3                   	ret    

00802b59 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802b59:	55                   	push   %ebp
  802b5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802b5c:	6a 00                	push   $0x0
  802b5e:	6a 00                	push   $0x0
  802b60:	6a 00                	push   $0x0
  802b62:	6a 00                	push   $0x0
  802b64:	ff 75 08             	pushl  0x8(%ebp)
  802b67:	6a 0d                	push   $0xd
  802b69:	e8 46 fe ff ff       	call   8029b4 <syscall>
  802b6e:	83 c4 18             	add    $0x18,%esp
}
  802b71:	c9                   	leave  
  802b72:	c3                   	ret    

00802b73 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802b73:	55                   	push   %ebp
  802b74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802b76:	6a 00                	push   $0x0
  802b78:	6a 00                	push   $0x0
  802b7a:	6a 00                	push   $0x0
  802b7c:	6a 00                	push   $0x0
  802b7e:	6a 00                	push   $0x0
  802b80:	6a 0e                	push   $0xe
  802b82:	e8 2d fe ff ff       	call   8029b4 <syscall>
  802b87:	83 c4 18             	add    $0x18,%esp
}
  802b8a:	90                   	nop
  802b8b:	c9                   	leave  
  802b8c:	c3                   	ret    

00802b8d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802b8d:	55                   	push   %ebp
  802b8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802b90:	6a 00                	push   $0x0
  802b92:	6a 00                	push   $0x0
  802b94:	6a 00                	push   $0x0
  802b96:	6a 00                	push   $0x0
  802b98:	6a 00                	push   $0x0
  802b9a:	6a 13                	push   $0x13
  802b9c:	e8 13 fe ff ff       	call   8029b4 <syscall>
  802ba1:	83 c4 18             	add    $0x18,%esp
}
  802ba4:	90                   	nop
  802ba5:	c9                   	leave  
  802ba6:	c3                   	ret    

00802ba7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802ba7:	55                   	push   %ebp
  802ba8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802baa:	6a 00                	push   $0x0
  802bac:	6a 00                	push   $0x0
  802bae:	6a 00                	push   $0x0
  802bb0:	6a 00                	push   $0x0
  802bb2:	6a 00                	push   $0x0
  802bb4:	6a 14                	push   $0x14
  802bb6:	e8 f9 fd ff ff       	call   8029b4 <syscall>
  802bbb:	83 c4 18             	add    $0x18,%esp
}
  802bbe:	90                   	nop
  802bbf:	c9                   	leave  
  802bc0:	c3                   	ret    

00802bc1 <sys_cputc>:


void
sys_cputc(const char c)
{
  802bc1:	55                   	push   %ebp
  802bc2:	89 e5                	mov    %esp,%ebp
  802bc4:	83 ec 04             	sub    $0x4,%esp
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802bcd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802bd1:	6a 00                	push   $0x0
  802bd3:	6a 00                	push   $0x0
  802bd5:	6a 00                	push   $0x0
  802bd7:	6a 00                	push   $0x0
  802bd9:	50                   	push   %eax
  802bda:	6a 15                	push   $0x15
  802bdc:	e8 d3 fd ff ff       	call   8029b4 <syscall>
  802be1:	83 c4 18             	add    $0x18,%esp
}
  802be4:	90                   	nop
  802be5:	c9                   	leave  
  802be6:	c3                   	ret    

00802be7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802be7:	55                   	push   %ebp
  802be8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802bea:	6a 00                	push   $0x0
  802bec:	6a 00                	push   $0x0
  802bee:	6a 00                	push   $0x0
  802bf0:	6a 00                	push   $0x0
  802bf2:	6a 00                	push   $0x0
  802bf4:	6a 16                	push   $0x16
  802bf6:	e8 b9 fd ff ff       	call   8029b4 <syscall>
  802bfb:	83 c4 18             	add    $0x18,%esp
}
  802bfe:	90                   	nop
  802bff:	c9                   	leave  
  802c00:	c3                   	ret    

00802c01 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802c01:	55                   	push   %ebp
  802c02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	6a 00                	push   $0x0
  802c09:	6a 00                	push   $0x0
  802c0b:	6a 00                	push   $0x0
  802c0d:	ff 75 0c             	pushl  0xc(%ebp)
  802c10:	50                   	push   %eax
  802c11:	6a 17                	push   $0x17
  802c13:	e8 9c fd ff ff       	call   8029b4 <syscall>
  802c18:	83 c4 18             	add    $0x18,%esp
}
  802c1b:	c9                   	leave  
  802c1c:	c3                   	ret    

00802c1d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802c1d:	55                   	push   %ebp
  802c1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	6a 00                	push   $0x0
  802c28:	6a 00                	push   $0x0
  802c2a:	6a 00                	push   $0x0
  802c2c:	52                   	push   %edx
  802c2d:	50                   	push   %eax
  802c2e:	6a 1a                	push   $0x1a
  802c30:	e8 7f fd ff ff       	call   8029b4 <syscall>
  802c35:	83 c4 18             	add    $0x18,%esp
}
  802c38:	c9                   	leave  
  802c39:	c3                   	ret    

00802c3a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802c3a:	55                   	push   %ebp
  802c3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	6a 00                	push   $0x0
  802c45:	6a 00                	push   $0x0
  802c47:	6a 00                	push   $0x0
  802c49:	52                   	push   %edx
  802c4a:	50                   	push   %eax
  802c4b:	6a 18                	push   $0x18
  802c4d:	e8 62 fd ff ff       	call   8029b4 <syscall>
  802c52:	83 c4 18             	add    $0x18,%esp
}
  802c55:	90                   	nop
  802c56:	c9                   	leave  
  802c57:	c3                   	ret    

00802c58 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802c58:	55                   	push   %ebp
  802c59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c61:	6a 00                	push   $0x0
  802c63:	6a 00                	push   $0x0
  802c65:	6a 00                	push   $0x0
  802c67:	52                   	push   %edx
  802c68:	50                   	push   %eax
  802c69:	6a 19                	push   $0x19
  802c6b:	e8 44 fd ff ff       	call   8029b4 <syscall>
  802c70:	83 c4 18             	add    $0x18,%esp
}
  802c73:	90                   	nop
  802c74:	c9                   	leave  
  802c75:	c3                   	ret    

00802c76 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802c76:	55                   	push   %ebp
  802c77:	89 e5                	mov    %esp,%ebp
  802c79:	83 ec 04             	sub    $0x4,%esp
  802c7c:	8b 45 10             	mov    0x10(%ebp),%eax
  802c7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802c82:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c85:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	6a 00                	push   $0x0
  802c8e:	51                   	push   %ecx
  802c8f:	52                   	push   %edx
  802c90:	ff 75 0c             	pushl  0xc(%ebp)
  802c93:	50                   	push   %eax
  802c94:	6a 1b                	push   $0x1b
  802c96:	e8 19 fd ff ff       	call   8029b4 <syscall>
  802c9b:	83 c4 18             	add    $0x18,%esp
}
  802c9e:	c9                   	leave  
  802c9f:	c3                   	ret    

00802ca0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802ca0:	55                   	push   %ebp
  802ca1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	6a 00                	push   $0x0
  802cab:	6a 00                	push   $0x0
  802cad:	6a 00                	push   $0x0
  802caf:	52                   	push   %edx
  802cb0:	50                   	push   %eax
  802cb1:	6a 1c                	push   $0x1c
  802cb3:	e8 fc fc ff ff       	call   8029b4 <syscall>
  802cb8:	83 c4 18             	add    $0x18,%esp
}
  802cbb:	c9                   	leave  
  802cbc:	c3                   	ret    

00802cbd <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802cbd:	55                   	push   %ebp
  802cbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802cc0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	6a 00                	push   $0x0
  802ccb:	6a 00                	push   $0x0
  802ccd:	51                   	push   %ecx
  802cce:	52                   	push   %edx
  802ccf:	50                   	push   %eax
  802cd0:	6a 1d                	push   $0x1d
  802cd2:	e8 dd fc ff ff       	call   8029b4 <syscall>
  802cd7:	83 c4 18             	add    $0x18,%esp
}
  802cda:	c9                   	leave  
  802cdb:	c3                   	ret    

00802cdc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802cdc:	55                   	push   %ebp
  802cdd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	6a 00                	push   $0x0
  802ce7:	6a 00                	push   $0x0
  802ce9:	6a 00                	push   $0x0
  802ceb:	52                   	push   %edx
  802cec:	50                   	push   %eax
  802ced:	6a 1e                	push   $0x1e
  802cef:	e8 c0 fc ff ff       	call   8029b4 <syscall>
  802cf4:	83 c4 18             	add    $0x18,%esp
}
  802cf7:	c9                   	leave  
  802cf8:	c3                   	ret    

00802cf9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802cf9:	55                   	push   %ebp
  802cfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802cfc:	6a 00                	push   $0x0
  802cfe:	6a 00                	push   $0x0
  802d00:	6a 00                	push   $0x0
  802d02:	6a 00                	push   $0x0
  802d04:	6a 00                	push   $0x0
  802d06:	6a 1f                	push   $0x1f
  802d08:	e8 a7 fc ff ff       	call   8029b4 <syscall>
  802d0d:	83 c4 18             	add    $0x18,%esp
}
  802d10:	c9                   	leave  
  802d11:	c3                   	ret    

00802d12 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802d12:	55                   	push   %ebp
  802d13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	6a 00                	push   $0x0
  802d1a:	ff 75 14             	pushl  0x14(%ebp)
  802d1d:	ff 75 10             	pushl  0x10(%ebp)
  802d20:	ff 75 0c             	pushl  0xc(%ebp)
  802d23:	50                   	push   %eax
  802d24:	6a 20                	push   $0x20
  802d26:	e8 89 fc ff ff       	call   8029b4 <syscall>
  802d2b:	83 c4 18             	add    $0x18,%esp
}
  802d2e:	c9                   	leave  
  802d2f:	c3                   	ret    

00802d30 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802d30:	55                   	push   %ebp
  802d31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802d33:	8b 45 08             	mov    0x8(%ebp),%eax
  802d36:	6a 00                	push   $0x0
  802d38:	6a 00                	push   $0x0
  802d3a:	6a 00                	push   $0x0
  802d3c:	6a 00                	push   $0x0
  802d3e:	50                   	push   %eax
  802d3f:	6a 21                	push   $0x21
  802d41:	e8 6e fc ff ff       	call   8029b4 <syscall>
  802d46:	83 c4 18             	add    $0x18,%esp
}
  802d49:	90                   	nop
  802d4a:	c9                   	leave  
  802d4b:	c3                   	ret    

00802d4c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802d4c:	55                   	push   %ebp
  802d4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	6a 00                	push   $0x0
  802d54:	6a 00                	push   $0x0
  802d56:	6a 00                	push   $0x0
  802d58:	6a 00                	push   $0x0
  802d5a:	50                   	push   %eax
  802d5b:	6a 22                	push   $0x22
  802d5d:	e8 52 fc ff ff       	call   8029b4 <syscall>
  802d62:	83 c4 18             	add    $0x18,%esp
}
  802d65:	c9                   	leave  
  802d66:	c3                   	ret    

00802d67 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802d67:	55                   	push   %ebp
  802d68:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802d6a:	6a 00                	push   $0x0
  802d6c:	6a 00                	push   $0x0
  802d6e:	6a 00                	push   $0x0
  802d70:	6a 00                	push   $0x0
  802d72:	6a 00                	push   $0x0
  802d74:	6a 02                	push   $0x2
  802d76:	e8 39 fc ff ff       	call   8029b4 <syscall>
  802d7b:	83 c4 18             	add    $0x18,%esp
}
  802d7e:	c9                   	leave  
  802d7f:	c3                   	ret    

00802d80 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802d80:	55                   	push   %ebp
  802d81:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802d83:	6a 00                	push   $0x0
  802d85:	6a 00                	push   $0x0
  802d87:	6a 00                	push   $0x0
  802d89:	6a 00                	push   $0x0
  802d8b:	6a 00                	push   $0x0
  802d8d:	6a 03                	push   $0x3
  802d8f:	e8 20 fc ff ff       	call   8029b4 <syscall>
  802d94:	83 c4 18             	add    $0x18,%esp
}
  802d97:	c9                   	leave  
  802d98:	c3                   	ret    

00802d99 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802d99:	55                   	push   %ebp
  802d9a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802d9c:	6a 00                	push   $0x0
  802d9e:	6a 00                	push   $0x0
  802da0:	6a 00                	push   $0x0
  802da2:	6a 00                	push   $0x0
  802da4:	6a 00                	push   $0x0
  802da6:	6a 04                	push   $0x4
  802da8:	e8 07 fc ff ff       	call   8029b4 <syscall>
  802dad:	83 c4 18             	add    $0x18,%esp
}
  802db0:	c9                   	leave  
  802db1:	c3                   	ret    

00802db2 <sys_exit_env>:


void sys_exit_env(void)
{
  802db2:	55                   	push   %ebp
  802db3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802db5:	6a 00                	push   $0x0
  802db7:	6a 00                	push   $0x0
  802db9:	6a 00                	push   $0x0
  802dbb:	6a 00                	push   $0x0
  802dbd:	6a 00                	push   $0x0
  802dbf:	6a 23                	push   $0x23
  802dc1:	e8 ee fb ff ff       	call   8029b4 <syscall>
  802dc6:	83 c4 18             	add    $0x18,%esp
}
  802dc9:	90                   	nop
  802dca:	c9                   	leave  
  802dcb:	c3                   	ret    

00802dcc <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802dcc:	55                   	push   %ebp
  802dcd:	89 e5                	mov    %esp,%ebp
  802dcf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802dd2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802dd5:	8d 50 04             	lea    0x4(%eax),%edx
  802dd8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802ddb:	6a 00                	push   $0x0
  802ddd:	6a 00                	push   $0x0
  802ddf:	6a 00                	push   $0x0
  802de1:	52                   	push   %edx
  802de2:	50                   	push   %eax
  802de3:	6a 24                	push   $0x24
  802de5:	e8 ca fb ff ff       	call   8029b4 <syscall>
  802dea:	83 c4 18             	add    $0x18,%esp
	return result;
  802ded:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802df0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802df3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802df6:	89 01                	mov    %eax,(%ecx)
  802df8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	c9                   	leave  
  802dff:	c2 04 00             	ret    $0x4

00802e02 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802e02:	55                   	push   %ebp
  802e03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802e05:	6a 00                	push   $0x0
  802e07:	6a 00                	push   $0x0
  802e09:	ff 75 10             	pushl  0x10(%ebp)
  802e0c:	ff 75 0c             	pushl  0xc(%ebp)
  802e0f:	ff 75 08             	pushl  0x8(%ebp)
  802e12:	6a 12                	push   $0x12
  802e14:	e8 9b fb ff ff       	call   8029b4 <syscall>
  802e19:	83 c4 18             	add    $0x18,%esp
	return ;
  802e1c:	90                   	nop
}
  802e1d:	c9                   	leave  
  802e1e:	c3                   	ret    

00802e1f <sys_rcr2>:
uint32 sys_rcr2()
{
  802e1f:	55                   	push   %ebp
  802e20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802e22:	6a 00                	push   $0x0
  802e24:	6a 00                	push   $0x0
  802e26:	6a 00                	push   $0x0
  802e28:	6a 00                	push   $0x0
  802e2a:	6a 00                	push   $0x0
  802e2c:	6a 25                	push   $0x25
  802e2e:	e8 81 fb ff ff       	call   8029b4 <syscall>
  802e33:	83 c4 18             	add    $0x18,%esp
}
  802e36:	c9                   	leave  
  802e37:	c3                   	ret    

00802e38 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802e38:	55                   	push   %ebp
  802e39:	89 e5                	mov    %esp,%ebp
  802e3b:	83 ec 04             	sub    $0x4,%esp
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802e44:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802e48:	6a 00                	push   $0x0
  802e4a:	6a 00                	push   $0x0
  802e4c:	6a 00                	push   $0x0
  802e4e:	6a 00                	push   $0x0
  802e50:	50                   	push   %eax
  802e51:	6a 26                	push   $0x26
  802e53:	e8 5c fb ff ff       	call   8029b4 <syscall>
  802e58:	83 c4 18             	add    $0x18,%esp
	return ;
  802e5b:	90                   	nop
}
  802e5c:	c9                   	leave  
  802e5d:	c3                   	ret    

00802e5e <rsttst>:
void rsttst()
{
  802e5e:	55                   	push   %ebp
  802e5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802e61:	6a 00                	push   $0x0
  802e63:	6a 00                	push   $0x0
  802e65:	6a 00                	push   $0x0
  802e67:	6a 00                	push   $0x0
  802e69:	6a 00                	push   $0x0
  802e6b:	6a 28                	push   $0x28
  802e6d:	e8 42 fb ff ff       	call   8029b4 <syscall>
  802e72:	83 c4 18             	add    $0x18,%esp
	return ;
  802e75:	90                   	nop
}
  802e76:	c9                   	leave  
  802e77:	c3                   	ret    

00802e78 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802e78:	55                   	push   %ebp
  802e79:	89 e5                	mov    %esp,%ebp
  802e7b:	83 ec 04             	sub    $0x4,%esp
  802e7e:	8b 45 14             	mov    0x14(%ebp),%eax
  802e81:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802e84:	8b 55 18             	mov    0x18(%ebp),%edx
  802e87:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802e8b:	52                   	push   %edx
  802e8c:	50                   	push   %eax
  802e8d:	ff 75 10             	pushl  0x10(%ebp)
  802e90:	ff 75 0c             	pushl  0xc(%ebp)
  802e93:	ff 75 08             	pushl  0x8(%ebp)
  802e96:	6a 27                	push   $0x27
  802e98:	e8 17 fb ff ff       	call   8029b4 <syscall>
  802e9d:	83 c4 18             	add    $0x18,%esp
	return ;
  802ea0:	90                   	nop
}
  802ea1:	c9                   	leave  
  802ea2:	c3                   	ret    

00802ea3 <chktst>:
void chktst(uint32 n)
{
  802ea3:	55                   	push   %ebp
  802ea4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802ea6:	6a 00                	push   $0x0
  802ea8:	6a 00                	push   $0x0
  802eaa:	6a 00                	push   $0x0
  802eac:	6a 00                	push   $0x0
  802eae:	ff 75 08             	pushl  0x8(%ebp)
  802eb1:	6a 29                	push   $0x29
  802eb3:	e8 fc fa ff ff       	call   8029b4 <syscall>
  802eb8:	83 c4 18             	add    $0x18,%esp
	return ;
  802ebb:	90                   	nop
}
  802ebc:	c9                   	leave  
  802ebd:	c3                   	ret    

00802ebe <inctst>:

void inctst()
{
  802ebe:	55                   	push   %ebp
  802ebf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802ec1:	6a 00                	push   $0x0
  802ec3:	6a 00                	push   $0x0
  802ec5:	6a 00                	push   $0x0
  802ec7:	6a 00                	push   $0x0
  802ec9:	6a 00                	push   $0x0
  802ecb:	6a 2a                	push   $0x2a
  802ecd:	e8 e2 fa ff ff       	call   8029b4 <syscall>
  802ed2:	83 c4 18             	add    $0x18,%esp
	return ;
  802ed5:	90                   	nop
}
  802ed6:	c9                   	leave  
  802ed7:	c3                   	ret    

00802ed8 <gettst>:
uint32 gettst()
{
  802ed8:	55                   	push   %ebp
  802ed9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802edb:	6a 00                	push   $0x0
  802edd:	6a 00                	push   $0x0
  802edf:	6a 00                	push   $0x0
  802ee1:	6a 00                	push   $0x0
  802ee3:	6a 00                	push   $0x0
  802ee5:	6a 2b                	push   $0x2b
  802ee7:	e8 c8 fa ff ff       	call   8029b4 <syscall>
  802eec:	83 c4 18             	add    $0x18,%esp
}
  802eef:	c9                   	leave  
  802ef0:	c3                   	ret    

00802ef1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802ef1:	55                   	push   %ebp
  802ef2:	89 e5                	mov    %esp,%ebp
  802ef4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ef7:	6a 00                	push   $0x0
  802ef9:	6a 00                	push   $0x0
  802efb:	6a 00                	push   $0x0
  802efd:	6a 00                	push   $0x0
  802eff:	6a 00                	push   $0x0
  802f01:	6a 2c                	push   $0x2c
  802f03:	e8 ac fa ff ff       	call   8029b4 <syscall>
  802f08:	83 c4 18             	add    $0x18,%esp
  802f0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802f0e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802f12:	75 07                	jne    802f1b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802f14:	b8 01 00 00 00       	mov    $0x1,%eax
  802f19:	eb 05                	jmp    802f20 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802f1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f20:	c9                   	leave  
  802f21:	c3                   	ret    

00802f22 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802f22:	55                   	push   %ebp
  802f23:	89 e5                	mov    %esp,%ebp
  802f25:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f28:	6a 00                	push   $0x0
  802f2a:	6a 00                	push   $0x0
  802f2c:	6a 00                	push   $0x0
  802f2e:	6a 00                	push   $0x0
  802f30:	6a 00                	push   $0x0
  802f32:	6a 2c                	push   $0x2c
  802f34:	e8 7b fa ff ff       	call   8029b4 <syscall>
  802f39:	83 c4 18             	add    $0x18,%esp
  802f3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802f3f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802f43:	75 07                	jne    802f4c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802f45:	b8 01 00 00 00       	mov    $0x1,%eax
  802f4a:	eb 05                	jmp    802f51 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802f4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f51:	c9                   	leave  
  802f52:	c3                   	ret    

00802f53 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802f53:	55                   	push   %ebp
  802f54:	89 e5                	mov    %esp,%ebp
  802f56:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f59:	6a 00                	push   $0x0
  802f5b:	6a 00                	push   $0x0
  802f5d:	6a 00                	push   $0x0
  802f5f:	6a 00                	push   $0x0
  802f61:	6a 00                	push   $0x0
  802f63:	6a 2c                	push   $0x2c
  802f65:	e8 4a fa ff ff       	call   8029b4 <syscall>
  802f6a:	83 c4 18             	add    $0x18,%esp
  802f6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802f70:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802f74:	75 07                	jne    802f7d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802f76:	b8 01 00 00 00       	mov    $0x1,%eax
  802f7b:	eb 05                	jmp    802f82 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f82:	c9                   	leave  
  802f83:	c3                   	ret    

00802f84 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802f84:	55                   	push   %ebp
  802f85:	89 e5                	mov    %esp,%ebp
  802f87:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f8a:	6a 00                	push   $0x0
  802f8c:	6a 00                	push   $0x0
  802f8e:	6a 00                	push   $0x0
  802f90:	6a 00                	push   $0x0
  802f92:	6a 00                	push   $0x0
  802f94:	6a 2c                	push   $0x2c
  802f96:	e8 19 fa ff ff       	call   8029b4 <syscall>
  802f9b:	83 c4 18             	add    $0x18,%esp
  802f9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802fa1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802fa5:	75 07                	jne    802fae <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802fa7:	b8 01 00 00 00       	mov    $0x1,%eax
  802fac:	eb 05                	jmp    802fb3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802fae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fb3:	c9                   	leave  
  802fb4:	c3                   	ret    

00802fb5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802fb5:	55                   	push   %ebp
  802fb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802fb8:	6a 00                	push   $0x0
  802fba:	6a 00                	push   $0x0
  802fbc:	6a 00                	push   $0x0
  802fbe:	6a 00                	push   $0x0
  802fc0:	ff 75 08             	pushl  0x8(%ebp)
  802fc3:	6a 2d                	push   $0x2d
  802fc5:	e8 ea f9 ff ff       	call   8029b4 <syscall>
  802fca:	83 c4 18             	add    $0x18,%esp
	return ;
  802fcd:	90                   	nop
}
  802fce:	c9                   	leave  
  802fcf:	c3                   	ret    

00802fd0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802fd0:	55                   	push   %ebp
  802fd1:	89 e5                	mov    %esp,%ebp
  802fd3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802fd4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fd7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	6a 00                	push   $0x0
  802fe2:	53                   	push   %ebx
  802fe3:	51                   	push   %ecx
  802fe4:	52                   	push   %edx
  802fe5:	50                   	push   %eax
  802fe6:	6a 2e                	push   $0x2e
  802fe8:	e8 c7 f9 ff ff       	call   8029b4 <syscall>
  802fed:	83 c4 18             	add    $0x18,%esp
}
  802ff0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ff3:	c9                   	leave  
  802ff4:	c3                   	ret    

00802ff5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802ff5:	55                   	push   %ebp
  802ff6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802ff8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	6a 00                	push   $0x0
  803000:	6a 00                	push   $0x0
  803002:	6a 00                	push   $0x0
  803004:	52                   	push   %edx
  803005:	50                   	push   %eax
  803006:	6a 2f                	push   $0x2f
  803008:	e8 a7 f9 ff ff       	call   8029b4 <syscall>
  80300d:	83 c4 18             	add    $0x18,%esp
}
  803010:	c9                   	leave  
  803011:	c3                   	ret    

00803012 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  803012:	55                   	push   %ebp
  803013:	89 e5                	mov    %esp,%ebp
  803015:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  803018:	83 ec 0c             	sub    $0xc,%esp
  80301b:	68 08 52 80 00       	push   $0x805208
  803020:	e8 1e e8 ff ff       	call   801843 <cprintf>
  803025:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  803028:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80302f:	83 ec 0c             	sub    $0xc,%esp
  803032:	68 34 52 80 00       	push   $0x805234
  803037:	e8 07 e8 ff ff       	call   801843 <cprintf>
  80303c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80303f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803043:	a1 38 61 80 00       	mov    0x806138,%eax
  803048:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80304b:	eb 56                	jmp    8030a3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80304d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803051:	74 1c                	je     80306f <print_mem_block_lists+0x5d>
  803053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803056:	8b 50 08             	mov    0x8(%eax),%edx
  803059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305c:	8b 48 08             	mov    0x8(%eax),%ecx
  80305f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803062:	8b 40 0c             	mov    0xc(%eax),%eax
  803065:	01 c8                	add    %ecx,%eax
  803067:	39 c2                	cmp    %eax,%edx
  803069:	73 04                	jae    80306f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80306b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	8b 50 08             	mov    0x8(%eax),%edx
  803075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803078:	8b 40 0c             	mov    0xc(%eax),%eax
  80307b:	01 c2                	add    %eax,%edx
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	8b 40 08             	mov    0x8(%eax),%eax
  803083:	83 ec 04             	sub    $0x4,%esp
  803086:	52                   	push   %edx
  803087:	50                   	push   %eax
  803088:	68 49 52 80 00       	push   $0x805249
  80308d:	e8 b1 e7 ff ff       	call   801843 <cprintf>
  803092:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803098:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80309b:	a1 40 61 80 00       	mov    0x806140,%eax
  8030a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a7:	74 07                	je     8030b0 <print_mem_block_lists+0x9e>
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	8b 00                	mov    (%eax),%eax
  8030ae:	eb 05                	jmp    8030b5 <print_mem_block_lists+0xa3>
  8030b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b5:	a3 40 61 80 00       	mov    %eax,0x806140
  8030ba:	a1 40 61 80 00       	mov    0x806140,%eax
  8030bf:	85 c0                	test   %eax,%eax
  8030c1:	75 8a                	jne    80304d <print_mem_block_lists+0x3b>
  8030c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c7:	75 84                	jne    80304d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8030c9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8030cd:	75 10                	jne    8030df <print_mem_block_lists+0xcd>
  8030cf:	83 ec 0c             	sub    $0xc,%esp
  8030d2:	68 58 52 80 00       	push   $0x805258
  8030d7:	e8 67 e7 ff ff       	call   801843 <cprintf>
  8030dc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8030df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8030e6:	83 ec 0c             	sub    $0xc,%esp
  8030e9:	68 7c 52 80 00       	push   $0x80527c
  8030ee:	e8 50 e7 ff ff       	call   801843 <cprintf>
  8030f3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8030f6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8030fa:	a1 40 60 80 00       	mov    0x806040,%eax
  8030ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803102:	eb 56                	jmp    80315a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803104:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803108:	74 1c                	je     803126 <print_mem_block_lists+0x114>
  80310a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310d:	8b 50 08             	mov    0x8(%eax),%edx
  803110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803113:	8b 48 08             	mov    0x8(%eax),%ecx
  803116:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803119:	8b 40 0c             	mov    0xc(%eax),%eax
  80311c:	01 c8                	add    %ecx,%eax
  80311e:	39 c2                	cmp    %eax,%edx
  803120:	73 04                	jae    803126 <print_mem_block_lists+0x114>
			sorted = 0 ;
  803122:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803129:	8b 50 08             	mov    0x8(%eax),%edx
  80312c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312f:	8b 40 0c             	mov    0xc(%eax),%eax
  803132:	01 c2                	add    %eax,%edx
  803134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803137:	8b 40 08             	mov    0x8(%eax),%eax
  80313a:	83 ec 04             	sub    $0x4,%esp
  80313d:	52                   	push   %edx
  80313e:	50                   	push   %eax
  80313f:	68 49 52 80 00       	push   $0x805249
  803144:	e8 fa e6 ff ff       	call   801843 <cprintf>
  803149:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803152:	a1 48 60 80 00       	mov    0x806048,%eax
  803157:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80315a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80315e:	74 07                	je     803167 <print_mem_block_lists+0x155>
  803160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803163:	8b 00                	mov    (%eax),%eax
  803165:	eb 05                	jmp    80316c <print_mem_block_lists+0x15a>
  803167:	b8 00 00 00 00       	mov    $0x0,%eax
  80316c:	a3 48 60 80 00       	mov    %eax,0x806048
  803171:	a1 48 60 80 00       	mov    0x806048,%eax
  803176:	85 c0                	test   %eax,%eax
  803178:	75 8a                	jne    803104 <print_mem_block_lists+0xf2>
  80317a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80317e:	75 84                	jne    803104 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  803180:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803184:	75 10                	jne    803196 <print_mem_block_lists+0x184>
  803186:	83 ec 0c             	sub    $0xc,%esp
  803189:	68 94 52 80 00       	push   $0x805294
  80318e:	e8 b0 e6 ff ff       	call   801843 <cprintf>
  803193:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803196:	83 ec 0c             	sub    $0xc,%esp
  803199:	68 08 52 80 00       	push   $0x805208
  80319e:	e8 a0 e6 ff ff       	call   801843 <cprintf>
  8031a3:	83 c4 10             	add    $0x10,%esp

}
  8031a6:	90                   	nop
  8031a7:	c9                   	leave  
  8031a8:	c3                   	ret    

008031a9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8031a9:	55                   	push   %ebp
  8031aa:	89 e5                	mov    %esp,%ebp
  8031ac:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8031af:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  8031b6:	00 00 00 
  8031b9:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  8031c0:	00 00 00 
  8031c3:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  8031ca:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8031cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8031d4:	e9 9e 00 00 00       	jmp    803277 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8031d9:	a1 50 60 80 00       	mov    0x806050,%eax
  8031de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031e1:	c1 e2 04             	shl    $0x4,%edx
  8031e4:	01 d0                	add    %edx,%eax
  8031e6:	85 c0                	test   %eax,%eax
  8031e8:	75 14                	jne    8031fe <initialize_MemBlocksList+0x55>
  8031ea:	83 ec 04             	sub    $0x4,%esp
  8031ed:	68 bc 52 80 00       	push   $0x8052bc
  8031f2:	6a 46                	push   $0x46
  8031f4:	68 df 52 80 00       	push   $0x8052df
  8031f9:	e8 91 e3 ff ff       	call   80158f <_panic>
  8031fe:	a1 50 60 80 00       	mov    0x806050,%eax
  803203:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803206:	c1 e2 04             	shl    $0x4,%edx
  803209:	01 d0                	add    %edx,%eax
  80320b:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803211:	89 10                	mov    %edx,(%eax)
  803213:	8b 00                	mov    (%eax),%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	74 18                	je     803231 <initialize_MemBlocksList+0x88>
  803219:	a1 48 61 80 00       	mov    0x806148,%eax
  80321e:	8b 15 50 60 80 00    	mov    0x806050,%edx
  803224:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803227:	c1 e1 04             	shl    $0x4,%ecx
  80322a:	01 ca                	add    %ecx,%edx
  80322c:	89 50 04             	mov    %edx,0x4(%eax)
  80322f:	eb 12                	jmp    803243 <initialize_MemBlocksList+0x9a>
  803231:	a1 50 60 80 00       	mov    0x806050,%eax
  803236:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803239:	c1 e2 04             	shl    $0x4,%edx
  80323c:	01 d0                	add    %edx,%eax
  80323e:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803243:	a1 50 60 80 00       	mov    0x806050,%eax
  803248:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80324b:	c1 e2 04             	shl    $0x4,%edx
  80324e:	01 d0                	add    %edx,%eax
  803250:	a3 48 61 80 00       	mov    %eax,0x806148
  803255:	a1 50 60 80 00       	mov    0x806050,%eax
  80325a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80325d:	c1 e2 04             	shl    $0x4,%edx
  803260:	01 d0                	add    %edx,%eax
  803262:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803269:	a1 54 61 80 00       	mov    0x806154,%eax
  80326e:	40                   	inc    %eax
  80326f:	a3 54 61 80 00       	mov    %eax,0x806154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  803274:	ff 45 f4             	incl   -0xc(%ebp)
  803277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80327d:	0f 82 56 ff ff ff    	jb     8031d9 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  803283:	90                   	nop
  803284:	c9                   	leave  
  803285:	c3                   	ret    

00803286 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  803286:	55                   	push   %ebp
  803287:	89 e5                	mov    %esp,%ebp
  803289:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	8b 00                	mov    (%eax),%eax
  803291:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803294:	eb 19                	jmp    8032af <find_block+0x29>
	{
		if(va==point->sva)
  803296:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803299:	8b 40 08             	mov    0x8(%eax),%eax
  80329c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80329f:	75 05                	jne    8032a6 <find_block+0x20>
		   return point;
  8032a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032a4:	eb 36                	jmp    8032dc <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	8b 40 08             	mov    0x8(%eax),%eax
  8032ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8032af:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8032b3:	74 07                	je     8032bc <find_block+0x36>
  8032b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032b8:	8b 00                	mov    (%eax),%eax
  8032ba:	eb 05                	jmp    8032c1 <find_block+0x3b>
  8032bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c4:	89 42 08             	mov    %eax,0x8(%edx)
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	8b 40 08             	mov    0x8(%eax),%eax
  8032cd:	85 c0                	test   %eax,%eax
  8032cf:	75 c5                	jne    803296 <find_block+0x10>
  8032d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8032d5:	75 bf                	jne    803296 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8032d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032dc:	c9                   	leave  
  8032dd:	c3                   	ret    

008032de <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8032de:	55                   	push   %ebp
  8032df:	89 e5                	mov    %esp,%ebp
  8032e1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8032e4:	a1 40 60 80 00       	mov    0x806040,%eax
  8032e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8032ec:	a1 44 60 80 00       	mov    0x806044,%eax
  8032f1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8032f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8032fa:	74 24                	je     803320 <insert_sorted_allocList+0x42>
  8032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ff:	8b 50 08             	mov    0x8(%eax),%edx
  803302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803305:	8b 40 08             	mov    0x8(%eax),%eax
  803308:	39 c2                	cmp    %eax,%edx
  80330a:	76 14                	jbe    803320 <insert_sorted_allocList+0x42>
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	8b 50 08             	mov    0x8(%eax),%edx
  803312:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803315:	8b 40 08             	mov    0x8(%eax),%eax
  803318:	39 c2                	cmp    %eax,%edx
  80331a:	0f 82 60 01 00 00    	jb     803480 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  803320:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803324:	75 65                	jne    80338b <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  803326:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80332a:	75 14                	jne    803340 <insert_sorted_allocList+0x62>
  80332c:	83 ec 04             	sub    $0x4,%esp
  80332f:	68 bc 52 80 00       	push   $0x8052bc
  803334:	6a 6b                	push   $0x6b
  803336:	68 df 52 80 00       	push   $0x8052df
  80333b:	e8 4f e2 ff ff       	call   80158f <_panic>
  803340:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803346:	8b 45 08             	mov    0x8(%ebp),%eax
  803349:	89 10                	mov    %edx,(%eax)
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	74 0d                	je     803361 <insert_sorted_allocList+0x83>
  803354:	a1 40 60 80 00       	mov    0x806040,%eax
  803359:	8b 55 08             	mov    0x8(%ebp),%edx
  80335c:	89 50 04             	mov    %edx,0x4(%eax)
  80335f:	eb 08                	jmp    803369 <insert_sorted_allocList+0x8b>
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	a3 44 60 80 00       	mov    %eax,0x806044
  803369:	8b 45 08             	mov    0x8(%ebp),%eax
  80336c:	a3 40 60 80 00       	mov    %eax,0x806040
  803371:	8b 45 08             	mov    0x8(%ebp),%eax
  803374:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80337b:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803380:	40                   	inc    %eax
  803381:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803386:	e9 dc 01 00 00       	jmp    803567 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80338b:	8b 45 08             	mov    0x8(%ebp),%eax
  80338e:	8b 50 08             	mov    0x8(%eax),%edx
  803391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803394:	8b 40 08             	mov    0x8(%eax),%eax
  803397:	39 c2                	cmp    %eax,%edx
  803399:	77 6c                	ja     803407 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80339b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80339f:	74 06                	je     8033a7 <insert_sorted_allocList+0xc9>
  8033a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a5:	75 14                	jne    8033bb <insert_sorted_allocList+0xdd>
  8033a7:	83 ec 04             	sub    $0x4,%esp
  8033aa:	68 f8 52 80 00       	push   $0x8052f8
  8033af:	6a 6f                	push   $0x6f
  8033b1:	68 df 52 80 00       	push   $0x8052df
  8033b6:	e8 d4 e1 ff ff       	call   80158f <_panic>
  8033bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033be:	8b 50 04             	mov    0x4(%eax),%edx
  8033c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c4:	89 50 04             	mov    %edx,0x4(%eax)
  8033c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033cd:	89 10                	mov    %edx,(%eax)
  8033cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d2:	8b 40 04             	mov    0x4(%eax),%eax
  8033d5:	85 c0                	test   %eax,%eax
  8033d7:	74 0d                	je     8033e6 <insert_sorted_allocList+0x108>
  8033d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033dc:	8b 40 04             	mov    0x4(%eax),%eax
  8033df:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e2:	89 10                	mov    %edx,(%eax)
  8033e4:	eb 08                	jmp    8033ee <insert_sorted_allocList+0x110>
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	a3 40 60 80 00       	mov    %eax,0x806040
  8033ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f4:	89 50 04             	mov    %edx,0x4(%eax)
  8033f7:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8033fc:	40                   	inc    %eax
  8033fd:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803402:	e9 60 01 00 00       	jmp    803567 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  803407:	8b 45 08             	mov    0x8(%ebp),%eax
  80340a:	8b 50 08             	mov    0x8(%eax),%edx
  80340d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803410:	8b 40 08             	mov    0x8(%eax),%eax
  803413:	39 c2                	cmp    %eax,%edx
  803415:	0f 82 4c 01 00 00    	jb     803567 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80341b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80341f:	75 14                	jne    803435 <insert_sorted_allocList+0x157>
  803421:	83 ec 04             	sub    $0x4,%esp
  803424:	68 30 53 80 00       	push   $0x805330
  803429:	6a 73                	push   $0x73
  80342b:	68 df 52 80 00       	push   $0x8052df
  803430:	e8 5a e1 ff ff       	call   80158f <_panic>
  803435:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80343b:	8b 45 08             	mov    0x8(%ebp),%eax
  80343e:	89 50 04             	mov    %edx,0x4(%eax)
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	8b 40 04             	mov    0x4(%eax),%eax
  803447:	85 c0                	test   %eax,%eax
  803449:	74 0c                	je     803457 <insert_sorted_allocList+0x179>
  80344b:	a1 44 60 80 00       	mov    0x806044,%eax
  803450:	8b 55 08             	mov    0x8(%ebp),%edx
  803453:	89 10                	mov    %edx,(%eax)
  803455:	eb 08                	jmp    80345f <insert_sorted_allocList+0x181>
  803457:	8b 45 08             	mov    0x8(%ebp),%eax
  80345a:	a3 40 60 80 00       	mov    %eax,0x806040
  80345f:	8b 45 08             	mov    0x8(%ebp),%eax
  803462:	a3 44 60 80 00       	mov    %eax,0x806044
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803470:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803475:	40                   	inc    %eax
  803476:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80347b:	e9 e7 00 00 00       	jmp    803567 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  803480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803483:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  803486:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80348d:	a1 40 60 80 00       	mov    0x806040,%eax
  803492:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803495:	e9 9d 00 00 00       	jmp    803537 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80349a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349d:	8b 00                	mov    (%eax),%eax
  80349f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8034a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a5:	8b 50 08             	mov    0x8(%eax),%edx
  8034a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ab:	8b 40 08             	mov    0x8(%eax),%eax
  8034ae:	39 c2                	cmp    %eax,%edx
  8034b0:	76 7d                	jbe    80352f <insert_sorted_allocList+0x251>
  8034b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b5:	8b 50 08             	mov    0x8(%eax),%edx
  8034b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bb:	8b 40 08             	mov    0x8(%eax),%eax
  8034be:	39 c2                	cmp    %eax,%edx
  8034c0:	73 6d                	jae    80352f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8034c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c6:	74 06                	je     8034ce <insert_sorted_allocList+0x1f0>
  8034c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034cc:	75 14                	jne    8034e2 <insert_sorted_allocList+0x204>
  8034ce:	83 ec 04             	sub    $0x4,%esp
  8034d1:	68 54 53 80 00       	push   $0x805354
  8034d6:	6a 7f                	push   $0x7f
  8034d8:	68 df 52 80 00       	push   $0x8052df
  8034dd:	e8 ad e0 ff ff       	call   80158f <_panic>
  8034e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e5:	8b 10                	mov    (%eax),%edx
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	89 10                	mov    %edx,(%eax)
  8034ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ef:	8b 00                	mov    (%eax),%eax
  8034f1:	85 c0                	test   %eax,%eax
  8034f3:	74 0b                	je     803500 <insert_sorted_allocList+0x222>
  8034f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f8:	8b 00                	mov    (%eax),%eax
  8034fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8034fd:	89 50 04             	mov    %edx,0x4(%eax)
  803500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803503:	8b 55 08             	mov    0x8(%ebp),%edx
  803506:	89 10                	mov    %edx,(%eax)
  803508:	8b 45 08             	mov    0x8(%ebp),%eax
  80350b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80350e:	89 50 04             	mov    %edx,0x4(%eax)
  803511:	8b 45 08             	mov    0x8(%ebp),%eax
  803514:	8b 00                	mov    (%eax),%eax
  803516:	85 c0                	test   %eax,%eax
  803518:	75 08                	jne    803522 <insert_sorted_allocList+0x244>
  80351a:	8b 45 08             	mov    0x8(%ebp),%eax
  80351d:	a3 44 60 80 00       	mov    %eax,0x806044
  803522:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803527:	40                   	inc    %eax
  803528:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  80352d:	eb 39                	jmp    803568 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80352f:	a1 48 60 80 00       	mov    0x806048,%eax
  803534:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80353b:	74 07                	je     803544 <insert_sorted_allocList+0x266>
  80353d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803540:	8b 00                	mov    (%eax),%eax
  803542:	eb 05                	jmp    803549 <insert_sorted_allocList+0x26b>
  803544:	b8 00 00 00 00       	mov    $0x0,%eax
  803549:	a3 48 60 80 00       	mov    %eax,0x806048
  80354e:	a1 48 60 80 00       	mov    0x806048,%eax
  803553:	85 c0                	test   %eax,%eax
  803555:	0f 85 3f ff ff ff    	jne    80349a <insert_sorted_allocList+0x1bc>
  80355b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80355f:	0f 85 35 ff ff ff    	jne    80349a <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  803565:	eb 01                	jmp    803568 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803567:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  803568:	90                   	nop
  803569:	c9                   	leave  
  80356a:	c3                   	ret    

0080356b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80356b:	55                   	push   %ebp
  80356c:	89 e5                	mov    %esp,%ebp
  80356e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803571:	a1 38 61 80 00       	mov    0x806138,%eax
  803576:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803579:	e9 85 01 00 00       	jmp    803703 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80357e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803581:	8b 40 0c             	mov    0xc(%eax),%eax
  803584:	3b 45 08             	cmp    0x8(%ebp),%eax
  803587:	0f 82 6e 01 00 00    	jb     8036fb <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80358d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803590:	8b 40 0c             	mov    0xc(%eax),%eax
  803593:	3b 45 08             	cmp    0x8(%ebp),%eax
  803596:	0f 85 8a 00 00 00    	jne    803626 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80359c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a0:	75 17                	jne    8035b9 <alloc_block_FF+0x4e>
  8035a2:	83 ec 04             	sub    $0x4,%esp
  8035a5:	68 88 53 80 00       	push   $0x805388
  8035aa:	68 93 00 00 00       	push   $0x93
  8035af:	68 df 52 80 00       	push   $0x8052df
  8035b4:	e8 d6 df ff ff       	call   80158f <_panic>
  8035b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bc:	8b 00                	mov    (%eax),%eax
  8035be:	85 c0                	test   %eax,%eax
  8035c0:	74 10                	je     8035d2 <alloc_block_FF+0x67>
  8035c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c5:	8b 00                	mov    (%eax),%eax
  8035c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ca:	8b 52 04             	mov    0x4(%edx),%edx
  8035cd:	89 50 04             	mov    %edx,0x4(%eax)
  8035d0:	eb 0b                	jmp    8035dd <alloc_block_FF+0x72>
  8035d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d5:	8b 40 04             	mov    0x4(%eax),%eax
  8035d8:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8035dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e0:	8b 40 04             	mov    0x4(%eax),%eax
  8035e3:	85 c0                	test   %eax,%eax
  8035e5:	74 0f                	je     8035f6 <alloc_block_FF+0x8b>
  8035e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ea:	8b 40 04             	mov    0x4(%eax),%eax
  8035ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035f0:	8b 12                	mov    (%edx),%edx
  8035f2:	89 10                	mov    %edx,(%eax)
  8035f4:	eb 0a                	jmp    803600 <alloc_block_FF+0x95>
  8035f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f9:	8b 00                	mov    (%eax),%eax
  8035fb:	a3 38 61 80 00       	mov    %eax,0x806138
  803600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803613:	a1 44 61 80 00       	mov    0x806144,%eax
  803618:	48                   	dec    %eax
  803619:	a3 44 61 80 00       	mov    %eax,0x806144
			   return  point;
  80361e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803621:	e9 10 01 00 00       	jmp    803736 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  803626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803629:	8b 40 0c             	mov    0xc(%eax),%eax
  80362c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80362f:	0f 86 c6 00 00 00    	jbe    8036fb <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803635:	a1 48 61 80 00       	mov    0x806148,%eax
  80363a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80363d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803640:	8b 50 08             	mov    0x8(%eax),%edx
  803643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803646:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  803649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80364c:	8b 55 08             	mov    0x8(%ebp),%edx
  80364f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803652:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803656:	75 17                	jne    80366f <alloc_block_FF+0x104>
  803658:	83 ec 04             	sub    $0x4,%esp
  80365b:	68 88 53 80 00       	push   $0x805388
  803660:	68 9b 00 00 00       	push   $0x9b
  803665:	68 df 52 80 00       	push   $0x8052df
  80366a:	e8 20 df ff ff       	call   80158f <_panic>
  80366f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803672:	8b 00                	mov    (%eax),%eax
  803674:	85 c0                	test   %eax,%eax
  803676:	74 10                	je     803688 <alloc_block_FF+0x11d>
  803678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80367b:	8b 00                	mov    (%eax),%eax
  80367d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803680:	8b 52 04             	mov    0x4(%edx),%edx
  803683:	89 50 04             	mov    %edx,0x4(%eax)
  803686:	eb 0b                	jmp    803693 <alloc_block_FF+0x128>
  803688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80368b:	8b 40 04             	mov    0x4(%eax),%eax
  80368e:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803696:	8b 40 04             	mov    0x4(%eax),%eax
  803699:	85 c0                	test   %eax,%eax
  80369b:	74 0f                	je     8036ac <alloc_block_FF+0x141>
  80369d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a0:	8b 40 04             	mov    0x4(%eax),%eax
  8036a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036a6:	8b 12                	mov    (%edx),%edx
  8036a8:	89 10                	mov    %edx,(%eax)
  8036aa:	eb 0a                	jmp    8036b6 <alloc_block_FF+0x14b>
  8036ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036af:	8b 00                	mov    (%eax),%eax
  8036b1:	a3 48 61 80 00       	mov    %eax,0x806148
  8036b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c9:	a1 54 61 80 00       	mov    0x806154,%eax
  8036ce:	48                   	dec    %eax
  8036cf:	a3 54 61 80 00       	mov    %eax,0x806154
			   point->sva += size;
  8036d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d7:	8b 50 08             	mov    0x8(%eax),%edx
  8036da:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dd:	01 c2                	add    %eax,%edx
  8036df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e2:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8036e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8036eb:	2b 45 08             	sub    0x8(%ebp),%eax
  8036ee:	89 c2                	mov    %eax,%edx
  8036f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f3:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8036f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f9:	eb 3b                	jmp    803736 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8036fb:	a1 40 61 80 00       	mov    0x806140,%eax
  803700:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803707:	74 07                	je     803710 <alloc_block_FF+0x1a5>
  803709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370c:	8b 00                	mov    (%eax),%eax
  80370e:	eb 05                	jmp    803715 <alloc_block_FF+0x1aa>
  803710:	b8 00 00 00 00       	mov    $0x0,%eax
  803715:	a3 40 61 80 00       	mov    %eax,0x806140
  80371a:	a1 40 61 80 00       	mov    0x806140,%eax
  80371f:	85 c0                	test   %eax,%eax
  803721:	0f 85 57 fe ff ff    	jne    80357e <alloc_block_FF+0x13>
  803727:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80372b:	0f 85 4d fe ff ff    	jne    80357e <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  803731:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803736:	c9                   	leave  
  803737:	c3                   	ret    

00803738 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803738:	55                   	push   %ebp
  803739:	89 e5                	mov    %esp,%ebp
  80373b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80373e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803745:	a1 38 61 80 00       	mov    0x806138,%eax
  80374a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80374d:	e9 df 00 00 00       	jmp    803831 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  803752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803755:	8b 40 0c             	mov    0xc(%eax),%eax
  803758:	3b 45 08             	cmp    0x8(%ebp),%eax
  80375b:	0f 82 c8 00 00 00    	jb     803829 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  803761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803764:	8b 40 0c             	mov    0xc(%eax),%eax
  803767:	3b 45 08             	cmp    0x8(%ebp),%eax
  80376a:	0f 85 8a 00 00 00    	jne    8037fa <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  803770:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803774:	75 17                	jne    80378d <alloc_block_BF+0x55>
  803776:	83 ec 04             	sub    $0x4,%esp
  803779:	68 88 53 80 00       	push   $0x805388
  80377e:	68 b7 00 00 00       	push   $0xb7
  803783:	68 df 52 80 00       	push   $0x8052df
  803788:	e8 02 de ff ff       	call   80158f <_panic>
  80378d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803790:	8b 00                	mov    (%eax),%eax
  803792:	85 c0                	test   %eax,%eax
  803794:	74 10                	je     8037a6 <alloc_block_BF+0x6e>
  803796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803799:	8b 00                	mov    (%eax),%eax
  80379b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80379e:	8b 52 04             	mov    0x4(%edx),%edx
  8037a1:	89 50 04             	mov    %edx,0x4(%eax)
  8037a4:	eb 0b                	jmp    8037b1 <alloc_block_BF+0x79>
  8037a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a9:	8b 40 04             	mov    0x4(%eax),%eax
  8037ac:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8037b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b4:	8b 40 04             	mov    0x4(%eax),%eax
  8037b7:	85 c0                	test   %eax,%eax
  8037b9:	74 0f                	je     8037ca <alloc_block_BF+0x92>
  8037bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037be:	8b 40 04             	mov    0x4(%eax),%eax
  8037c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037c4:	8b 12                	mov    (%edx),%edx
  8037c6:	89 10                	mov    %edx,(%eax)
  8037c8:	eb 0a                	jmp    8037d4 <alloc_block_BF+0x9c>
  8037ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cd:	8b 00                	mov    (%eax),%eax
  8037cf:	a3 38 61 80 00       	mov    %eax,0x806138
  8037d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037e7:	a1 44 61 80 00       	mov    0x806144,%eax
  8037ec:	48                   	dec    %eax
  8037ed:	a3 44 61 80 00       	mov    %eax,0x806144
			   return currentMemBlock;
  8037f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f5:	e9 4d 01 00 00       	jmp    803947 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8037fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803800:	3b 45 08             	cmp    0x8(%ebp),%eax
  803803:	76 24                	jbe    803829 <alloc_block_BF+0xf1>
  803805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803808:	8b 40 0c             	mov    0xc(%eax),%eax
  80380b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80380e:	73 19                	jae    803829 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  803810:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  803817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381a:	8b 40 0c             	mov    0xc(%eax),%eax
  80381d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  803820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803823:	8b 40 08             	mov    0x8(%eax),%eax
  803826:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803829:	a1 40 61 80 00       	mov    0x806140,%eax
  80382e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803835:	74 07                	je     80383e <alloc_block_BF+0x106>
  803837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383a:	8b 00                	mov    (%eax),%eax
  80383c:	eb 05                	jmp    803843 <alloc_block_BF+0x10b>
  80383e:	b8 00 00 00 00       	mov    $0x0,%eax
  803843:	a3 40 61 80 00       	mov    %eax,0x806140
  803848:	a1 40 61 80 00       	mov    0x806140,%eax
  80384d:	85 c0                	test   %eax,%eax
  80384f:	0f 85 fd fe ff ff    	jne    803752 <alloc_block_BF+0x1a>
  803855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803859:	0f 85 f3 fe ff ff    	jne    803752 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80385f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803863:	0f 84 d9 00 00 00    	je     803942 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  803869:	a1 48 61 80 00       	mov    0x806148,%eax
  80386e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803871:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803874:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803877:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80387a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387d:	8b 55 08             	mov    0x8(%ebp),%edx
  803880:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803883:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803887:	75 17                	jne    8038a0 <alloc_block_BF+0x168>
  803889:	83 ec 04             	sub    $0x4,%esp
  80388c:	68 88 53 80 00       	push   $0x805388
  803891:	68 c7 00 00 00       	push   $0xc7
  803896:	68 df 52 80 00       	push   $0x8052df
  80389b:	e8 ef dc ff ff       	call   80158f <_panic>
  8038a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a3:	8b 00                	mov    (%eax),%eax
  8038a5:	85 c0                	test   %eax,%eax
  8038a7:	74 10                	je     8038b9 <alloc_block_BF+0x181>
  8038a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ac:	8b 00                	mov    (%eax),%eax
  8038ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038b1:	8b 52 04             	mov    0x4(%edx),%edx
  8038b4:	89 50 04             	mov    %edx,0x4(%eax)
  8038b7:	eb 0b                	jmp    8038c4 <alloc_block_BF+0x18c>
  8038b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038bc:	8b 40 04             	mov    0x4(%eax),%eax
  8038bf:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8038c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c7:	8b 40 04             	mov    0x4(%eax),%eax
  8038ca:	85 c0                	test   %eax,%eax
  8038cc:	74 0f                	je     8038dd <alloc_block_BF+0x1a5>
  8038ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d1:	8b 40 04             	mov    0x4(%eax),%eax
  8038d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038d7:	8b 12                	mov    (%edx),%edx
  8038d9:	89 10                	mov    %edx,(%eax)
  8038db:	eb 0a                	jmp    8038e7 <alloc_block_BF+0x1af>
  8038dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e0:	8b 00                	mov    (%eax),%eax
  8038e2:	a3 48 61 80 00       	mov    %eax,0x806148
  8038e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038fa:	a1 54 61 80 00       	mov    0x806154,%eax
  8038ff:	48                   	dec    %eax
  803900:	a3 54 61 80 00       	mov    %eax,0x806154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803905:	83 ec 08             	sub    $0x8,%esp
  803908:	ff 75 ec             	pushl  -0x14(%ebp)
  80390b:	68 38 61 80 00       	push   $0x806138
  803910:	e8 71 f9 ff ff       	call   803286 <find_block>
  803915:	83 c4 10             	add    $0x10,%esp
  803918:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80391b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80391e:	8b 50 08             	mov    0x8(%eax),%edx
  803921:	8b 45 08             	mov    0x8(%ebp),%eax
  803924:	01 c2                	add    %eax,%edx
  803926:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803929:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80392c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80392f:	8b 40 0c             	mov    0xc(%eax),%eax
  803932:	2b 45 08             	sub    0x8(%ebp),%eax
  803935:	89 c2                	mov    %eax,%edx
  803937:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80393a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80393d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803940:	eb 05                	jmp    803947 <alloc_block_BF+0x20f>
	}
	return NULL;
  803942:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803947:	c9                   	leave  
  803948:	c3                   	ret    

00803949 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803949:	55                   	push   %ebp
  80394a:	89 e5                	mov    %esp,%ebp
  80394c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80394f:	a1 28 60 80 00       	mov    0x806028,%eax
  803954:	85 c0                	test   %eax,%eax
  803956:	0f 85 de 01 00 00    	jne    803b3a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80395c:	a1 38 61 80 00       	mov    0x806138,%eax
  803961:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803964:	e9 9e 01 00 00       	jmp    803b07 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396c:	8b 40 0c             	mov    0xc(%eax),%eax
  80396f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803972:	0f 82 87 01 00 00    	jb     803aff <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397b:	8b 40 0c             	mov    0xc(%eax),%eax
  80397e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803981:	0f 85 95 00 00 00    	jne    803a1c <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803987:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80398b:	75 17                	jne    8039a4 <alloc_block_NF+0x5b>
  80398d:	83 ec 04             	sub    $0x4,%esp
  803990:	68 88 53 80 00       	push   $0x805388
  803995:	68 e0 00 00 00       	push   $0xe0
  80399a:	68 df 52 80 00       	push   $0x8052df
  80399f:	e8 eb db ff ff       	call   80158f <_panic>
  8039a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a7:	8b 00                	mov    (%eax),%eax
  8039a9:	85 c0                	test   %eax,%eax
  8039ab:	74 10                	je     8039bd <alloc_block_NF+0x74>
  8039ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b0:	8b 00                	mov    (%eax),%eax
  8039b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039b5:	8b 52 04             	mov    0x4(%edx),%edx
  8039b8:	89 50 04             	mov    %edx,0x4(%eax)
  8039bb:	eb 0b                	jmp    8039c8 <alloc_block_NF+0x7f>
  8039bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c0:	8b 40 04             	mov    0x4(%eax),%eax
  8039c3:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8039c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cb:	8b 40 04             	mov    0x4(%eax),%eax
  8039ce:	85 c0                	test   %eax,%eax
  8039d0:	74 0f                	je     8039e1 <alloc_block_NF+0x98>
  8039d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d5:	8b 40 04             	mov    0x4(%eax),%eax
  8039d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039db:	8b 12                	mov    (%edx),%edx
  8039dd:	89 10                	mov    %edx,(%eax)
  8039df:	eb 0a                	jmp    8039eb <alloc_block_NF+0xa2>
  8039e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e4:	8b 00                	mov    (%eax),%eax
  8039e6:	a3 38 61 80 00       	mov    %eax,0x806138
  8039eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039fe:	a1 44 61 80 00       	mov    0x806144,%eax
  803a03:	48                   	dec    %eax
  803a04:	a3 44 61 80 00       	mov    %eax,0x806144
				   svaOfNF = point->sva;
  803a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0c:	8b 40 08             	mov    0x8(%eax),%eax
  803a0f:	a3 28 60 80 00       	mov    %eax,0x806028
				   return  point;
  803a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a17:	e9 f8 04 00 00       	jmp    803f14 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1f:	8b 40 0c             	mov    0xc(%eax),%eax
  803a22:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a25:	0f 86 d4 00 00 00    	jbe    803aff <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803a2b:	a1 48 61 80 00       	mov    0x806148,%eax
  803a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a36:	8b 50 08             	mov    0x8(%eax),%edx
  803a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a3c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a42:	8b 55 08             	mov    0x8(%ebp),%edx
  803a45:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803a48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a4c:	75 17                	jne    803a65 <alloc_block_NF+0x11c>
  803a4e:	83 ec 04             	sub    $0x4,%esp
  803a51:	68 88 53 80 00       	push   $0x805388
  803a56:	68 e9 00 00 00       	push   $0xe9
  803a5b:	68 df 52 80 00       	push   $0x8052df
  803a60:	e8 2a db ff ff       	call   80158f <_panic>
  803a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a68:	8b 00                	mov    (%eax),%eax
  803a6a:	85 c0                	test   %eax,%eax
  803a6c:	74 10                	je     803a7e <alloc_block_NF+0x135>
  803a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a71:	8b 00                	mov    (%eax),%eax
  803a73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a76:	8b 52 04             	mov    0x4(%edx),%edx
  803a79:	89 50 04             	mov    %edx,0x4(%eax)
  803a7c:	eb 0b                	jmp    803a89 <alloc_block_NF+0x140>
  803a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a81:	8b 40 04             	mov    0x4(%eax),%eax
  803a84:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a8c:	8b 40 04             	mov    0x4(%eax),%eax
  803a8f:	85 c0                	test   %eax,%eax
  803a91:	74 0f                	je     803aa2 <alloc_block_NF+0x159>
  803a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a96:	8b 40 04             	mov    0x4(%eax),%eax
  803a99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a9c:	8b 12                	mov    (%edx),%edx
  803a9e:	89 10                	mov    %edx,(%eax)
  803aa0:	eb 0a                	jmp    803aac <alloc_block_NF+0x163>
  803aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa5:	8b 00                	mov    (%eax),%eax
  803aa7:	a3 48 61 80 00       	mov    %eax,0x806148
  803aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803abf:	a1 54 61 80 00       	mov    0x806154,%eax
  803ac4:	48                   	dec    %eax
  803ac5:	a3 54 61 80 00       	mov    %eax,0x806154
				   svaOfNF = ReturnedBlock->sva;
  803aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803acd:	8b 40 08             	mov    0x8(%eax),%eax
  803ad0:	a3 28 60 80 00       	mov    %eax,0x806028
				   point->sva += size;
  803ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad8:	8b 50 08             	mov    0x8(%eax),%edx
  803adb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ade:	01 c2                	add    %eax,%edx
  803ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae3:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae9:	8b 40 0c             	mov    0xc(%eax),%eax
  803aec:	2b 45 08             	sub    0x8(%ebp),%eax
  803aef:	89 c2                	mov    %eax,%edx
  803af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af4:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803afa:	e9 15 04 00 00       	jmp    803f14 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803aff:	a1 40 61 80 00       	mov    0x806140,%eax
  803b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b0b:	74 07                	je     803b14 <alloc_block_NF+0x1cb>
  803b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b10:	8b 00                	mov    (%eax),%eax
  803b12:	eb 05                	jmp    803b19 <alloc_block_NF+0x1d0>
  803b14:	b8 00 00 00 00       	mov    $0x0,%eax
  803b19:	a3 40 61 80 00       	mov    %eax,0x806140
  803b1e:	a1 40 61 80 00       	mov    0x806140,%eax
  803b23:	85 c0                	test   %eax,%eax
  803b25:	0f 85 3e fe ff ff    	jne    803969 <alloc_block_NF+0x20>
  803b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b2f:	0f 85 34 fe ff ff    	jne    803969 <alloc_block_NF+0x20>
  803b35:	e9 d5 03 00 00       	jmp    803f0f <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803b3a:	a1 38 61 80 00       	mov    0x806138,%eax
  803b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b42:	e9 b1 01 00 00       	jmp    803cf8 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4a:	8b 50 08             	mov    0x8(%eax),%edx
  803b4d:	a1 28 60 80 00       	mov    0x806028,%eax
  803b52:	39 c2                	cmp    %eax,%edx
  803b54:	0f 82 96 01 00 00    	jb     803cf0 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5d:	8b 40 0c             	mov    0xc(%eax),%eax
  803b60:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b63:	0f 82 87 01 00 00    	jb     803cf0 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b6c:	8b 40 0c             	mov    0xc(%eax),%eax
  803b6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b72:	0f 85 95 00 00 00    	jne    803c0d <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803b78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b7c:	75 17                	jne    803b95 <alloc_block_NF+0x24c>
  803b7e:	83 ec 04             	sub    $0x4,%esp
  803b81:	68 88 53 80 00       	push   $0x805388
  803b86:	68 fc 00 00 00       	push   $0xfc
  803b8b:	68 df 52 80 00       	push   $0x8052df
  803b90:	e8 fa d9 ff ff       	call   80158f <_panic>
  803b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b98:	8b 00                	mov    (%eax),%eax
  803b9a:	85 c0                	test   %eax,%eax
  803b9c:	74 10                	je     803bae <alloc_block_NF+0x265>
  803b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba1:	8b 00                	mov    (%eax),%eax
  803ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ba6:	8b 52 04             	mov    0x4(%edx),%edx
  803ba9:	89 50 04             	mov    %edx,0x4(%eax)
  803bac:	eb 0b                	jmp    803bb9 <alloc_block_NF+0x270>
  803bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb1:	8b 40 04             	mov    0x4(%eax),%eax
  803bb4:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bbc:	8b 40 04             	mov    0x4(%eax),%eax
  803bbf:	85 c0                	test   %eax,%eax
  803bc1:	74 0f                	je     803bd2 <alloc_block_NF+0x289>
  803bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc6:	8b 40 04             	mov    0x4(%eax),%eax
  803bc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bcc:	8b 12                	mov    (%edx),%edx
  803bce:	89 10                	mov    %edx,(%eax)
  803bd0:	eb 0a                	jmp    803bdc <alloc_block_NF+0x293>
  803bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd5:	8b 00                	mov    (%eax),%eax
  803bd7:	a3 38 61 80 00       	mov    %eax,0x806138
  803bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bef:	a1 44 61 80 00       	mov    0x806144,%eax
  803bf4:	48                   	dec    %eax
  803bf5:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfd:	8b 40 08             	mov    0x8(%eax),%eax
  803c00:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c08:	e9 07 03 00 00       	jmp    803f14 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c10:	8b 40 0c             	mov    0xc(%eax),%eax
  803c13:	3b 45 08             	cmp    0x8(%ebp),%eax
  803c16:	0f 86 d4 00 00 00    	jbe    803cf0 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803c1c:	a1 48 61 80 00       	mov    0x806148,%eax
  803c21:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c27:	8b 50 08             	mov    0x8(%eax),%edx
  803c2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c2d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803c30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c33:	8b 55 08             	mov    0x8(%ebp),%edx
  803c36:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803c39:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c3d:	75 17                	jne    803c56 <alloc_block_NF+0x30d>
  803c3f:	83 ec 04             	sub    $0x4,%esp
  803c42:	68 88 53 80 00       	push   $0x805388
  803c47:	68 04 01 00 00       	push   $0x104
  803c4c:	68 df 52 80 00       	push   $0x8052df
  803c51:	e8 39 d9 ff ff       	call   80158f <_panic>
  803c56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c59:	8b 00                	mov    (%eax),%eax
  803c5b:	85 c0                	test   %eax,%eax
  803c5d:	74 10                	je     803c6f <alloc_block_NF+0x326>
  803c5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c62:	8b 00                	mov    (%eax),%eax
  803c64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c67:	8b 52 04             	mov    0x4(%edx),%edx
  803c6a:	89 50 04             	mov    %edx,0x4(%eax)
  803c6d:	eb 0b                	jmp    803c7a <alloc_block_NF+0x331>
  803c6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c72:	8b 40 04             	mov    0x4(%eax),%eax
  803c75:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803c7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c7d:	8b 40 04             	mov    0x4(%eax),%eax
  803c80:	85 c0                	test   %eax,%eax
  803c82:	74 0f                	je     803c93 <alloc_block_NF+0x34a>
  803c84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c87:	8b 40 04             	mov    0x4(%eax),%eax
  803c8a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c8d:	8b 12                	mov    (%edx),%edx
  803c8f:	89 10                	mov    %edx,(%eax)
  803c91:	eb 0a                	jmp    803c9d <alloc_block_NF+0x354>
  803c93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c96:	8b 00                	mov    (%eax),%eax
  803c98:	a3 48 61 80 00       	mov    %eax,0x806148
  803c9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ca6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cb0:	a1 54 61 80 00       	mov    0x806154,%eax
  803cb5:	48                   	dec    %eax
  803cb6:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803cbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cbe:	8b 40 08             	mov    0x8(%eax),%eax
  803cc1:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc9:	8b 50 08             	mov    0x8(%eax),%edx
  803ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  803ccf:	01 c2                	add    %eax,%edx
  803cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd4:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cda:	8b 40 0c             	mov    0xc(%eax),%eax
  803cdd:	2b 45 08             	sub    0x8(%ebp),%eax
  803ce0:	89 c2                	mov    %eax,%edx
  803ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803ce8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ceb:	e9 24 02 00 00       	jmp    803f14 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803cf0:	a1 40 61 80 00       	mov    0x806140,%eax
  803cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cfc:	74 07                	je     803d05 <alloc_block_NF+0x3bc>
  803cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d01:	8b 00                	mov    (%eax),%eax
  803d03:	eb 05                	jmp    803d0a <alloc_block_NF+0x3c1>
  803d05:	b8 00 00 00 00       	mov    $0x0,%eax
  803d0a:	a3 40 61 80 00       	mov    %eax,0x806140
  803d0f:	a1 40 61 80 00       	mov    0x806140,%eax
  803d14:	85 c0                	test   %eax,%eax
  803d16:	0f 85 2b fe ff ff    	jne    803b47 <alloc_block_NF+0x1fe>
  803d1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d20:	0f 85 21 fe ff ff    	jne    803b47 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803d26:	a1 38 61 80 00       	mov    0x806138,%eax
  803d2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d2e:	e9 ae 01 00 00       	jmp    803ee1 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d36:	8b 50 08             	mov    0x8(%eax),%edx
  803d39:	a1 28 60 80 00       	mov    0x806028,%eax
  803d3e:	39 c2                	cmp    %eax,%edx
  803d40:	0f 83 93 01 00 00    	jae    803ed9 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d49:	8b 40 0c             	mov    0xc(%eax),%eax
  803d4c:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d4f:	0f 82 84 01 00 00    	jb     803ed9 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d58:	8b 40 0c             	mov    0xc(%eax),%eax
  803d5b:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d5e:	0f 85 95 00 00 00    	jne    803df9 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803d64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d68:	75 17                	jne    803d81 <alloc_block_NF+0x438>
  803d6a:	83 ec 04             	sub    $0x4,%esp
  803d6d:	68 88 53 80 00       	push   $0x805388
  803d72:	68 14 01 00 00       	push   $0x114
  803d77:	68 df 52 80 00       	push   $0x8052df
  803d7c:	e8 0e d8 ff ff       	call   80158f <_panic>
  803d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d84:	8b 00                	mov    (%eax),%eax
  803d86:	85 c0                	test   %eax,%eax
  803d88:	74 10                	je     803d9a <alloc_block_NF+0x451>
  803d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d8d:	8b 00                	mov    (%eax),%eax
  803d8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d92:	8b 52 04             	mov    0x4(%edx),%edx
  803d95:	89 50 04             	mov    %edx,0x4(%eax)
  803d98:	eb 0b                	jmp    803da5 <alloc_block_NF+0x45c>
  803d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d9d:	8b 40 04             	mov    0x4(%eax),%eax
  803da0:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da8:	8b 40 04             	mov    0x4(%eax),%eax
  803dab:	85 c0                	test   %eax,%eax
  803dad:	74 0f                	je     803dbe <alloc_block_NF+0x475>
  803daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db2:	8b 40 04             	mov    0x4(%eax),%eax
  803db5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803db8:	8b 12                	mov    (%edx),%edx
  803dba:	89 10                	mov    %edx,(%eax)
  803dbc:	eb 0a                	jmp    803dc8 <alloc_block_NF+0x47f>
  803dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc1:	8b 00                	mov    (%eax),%eax
  803dc3:	a3 38 61 80 00       	mov    %eax,0x806138
  803dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ddb:	a1 44 61 80 00       	mov    0x806144,%eax
  803de0:	48                   	dec    %eax
  803de1:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de9:	8b 40 08             	mov    0x8(%eax),%eax
  803dec:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df4:	e9 1b 01 00 00       	jmp    803f14 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dfc:	8b 40 0c             	mov    0xc(%eax),%eax
  803dff:	3b 45 08             	cmp    0x8(%ebp),%eax
  803e02:	0f 86 d1 00 00 00    	jbe    803ed9 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803e08:	a1 48 61 80 00       	mov    0x806148,%eax
  803e0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e13:	8b 50 08             	mov    0x8(%eax),%edx
  803e16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e19:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803e1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e1f:	8b 55 08             	mov    0x8(%ebp),%edx
  803e22:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803e25:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e29:	75 17                	jne    803e42 <alloc_block_NF+0x4f9>
  803e2b:	83 ec 04             	sub    $0x4,%esp
  803e2e:	68 88 53 80 00       	push   $0x805388
  803e33:	68 1c 01 00 00       	push   $0x11c
  803e38:	68 df 52 80 00       	push   $0x8052df
  803e3d:	e8 4d d7 ff ff       	call   80158f <_panic>
  803e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e45:	8b 00                	mov    (%eax),%eax
  803e47:	85 c0                	test   %eax,%eax
  803e49:	74 10                	je     803e5b <alloc_block_NF+0x512>
  803e4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e4e:	8b 00                	mov    (%eax),%eax
  803e50:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e53:	8b 52 04             	mov    0x4(%edx),%edx
  803e56:	89 50 04             	mov    %edx,0x4(%eax)
  803e59:	eb 0b                	jmp    803e66 <alloc_block_NF+0x51d>
  803e5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e5e:	8b 40 04             	mov    0x4(%eax),%eax
  803e61:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803e66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e69:	8b 40 04             	mov    0x4(%eax),%eax
  803e6c:	85 c0                	test   %eax,%eax
  803e6e:	74 0f                	je     803e7f <alloc_block_NF+0x536>
  803e70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e73:	8b 40 04             	mov    0x4(%eax),%eax
  803e76:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e79:	8b 12                	mov    (%edx),%edx
  803e7b:	89 10                	mov    %edx,(%eax)
  803e7d:	eb 0a                	jmp    803e89 <alloc_block_NF+0x540>
  803e7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e82:	8b 00                	mov    (%eax),%eax
  803e84:	a3 48 61 80 00       	mov    %eax,0x806148
  803e89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e9c:	a1 54 61 80 00       	mov    0x806154,%eax
  803ea1:	48                   	dec    %eax
  803ea2:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eaa:	8b 40 08             	mov    0x8(%eax),%eax
  803ead:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb5:	8b 50 08             	mov    0x8(%eax),%edx
  803eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  803ebb:	01 c2                	add    %eax,%edx
  803ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec0:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec6:	8b 40 0c             	mov    0xc(%eax),%eax
  803ec9:	2b 45 08             	sub    0x8(%ebp),%eax
  803ecc:	89 c2                	mov    %eax,%edx
  803ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed1:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803ed4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ed7:	eb 3b                	jmp    803f14 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803ed9:	a1 40 61 80 00       	mov    0x806140,%eax
  803ede:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ee1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ee5:	74 07                	je     803eee <alloc_block_NF+0x5a5>
  803ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eea:	8b 00                	mov    (%eax),%eax
  803eec:	eb 05                	jmp    803ef3 <alloc_block_NF+0x5aa>
  803eee:	b8 00 00 00 00       	mov    $0x0,%eax
  803ef3:	a3 40 61 80 00       	mov    %eax,0x806140
  803ef8:	a1 40 61 80 00       	mov    0x806140,%eax
  803efd:	85 c0                	test   %eax,%eax
  803eff:	0f 85 2e fe ff ff    	jne    803d33 <alloc_block_NF+0x3ea>
  803f05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f09:	0f 85 24 fe ff ff    	jne    803d33 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803f0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f14:	c9                   	leave  
  803f15:	c3                   	ret    

00803f16 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803f16:	55                   	push   %ebp
  803f17:	89 e5                	mov    %esp,%ebp
  803f19:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803f1c:	a1 38 61 80 00       	mov    0x806138,%eax
  803f21:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803f24:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803f29:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803f2c:	a1 38 61 80 00       	mov    0x806138,%eax
  803f31:	85 c0                	test   %eax,%eax
  803f33:	74 14                	je     803f49 <insert_sorted_with_merge_freeList+0x33>
  803f35:	8b 45 08             	mov    0x8(%ebp),%eax
  803f38:	8b 50 08             	mov    0x8(%eax),%edx
  803f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f3e:	8b 40 08             	mov    0x8(%eax),%eax
  803f41:	39 c2                	cmp    %eax,%edx
  803f43:	0f 87 9b 01 00 00    	ja     8040e4 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803f49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f4d:	75 17                	jne    803f66 <insert_sorted_with_merge_freeList+0x50>
  803f4f:	83 ec 04             	sub    $0x4,%esp
  803f52:	68 bc 52 80 00       	push   $0x8052bc
  803f57:	68 38 01 00 00       	push   $0x138
  803f5c:	68 df 52 80 00       	push   $0x8052df
  803f61:	e8 29 d6 ff ff       	call   80158f <_panic>
  803f66:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f6f:	89 10                	mov    %edx,(%eax)
  803f71:	8b 45 08             	mov    0x8(%ebp),%eax
  803f74:	8b 00                	mov    (%eax),%eax
  803f76:	85 c0                	test   %eax,%eax
  803f78:	74 0d                	je     803f87 <insert_sorted_with_merge_freeList+0x71>
  803f7a:	a1 38 61 80 00       	mov    0x806138,%eax
  803f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  803f82:	89 50 04             	mov    %edx,0x4(%eax)
  803f85:	eb 08                	jmp    803f8f <insert_sorted_with_merge_freeList+0x79>
  803f87:	8b 45 08             	mov    0x8(%ebp),%eax
  803f8a:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f92:	a3 38 61 80 00       	mov    %eax,0x806138
  803f97:	8b 45 08             	mov    0x8(%ebp),%eax
  803f9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fa1:	a1 44 61 80 00       	mov    0x806144,%eax
  803fa6:	40                   	inc    %eax
  803fa7:	a3 44 61 80 00       	mov    %eax,0x806144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803fac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803fb0:	0f 84 a8 06 00 00    	je     80465e <insert_sorted_with_merge_freeList+0x748>
  803fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  803fb9:	8b 50 08             	mov    0x8(%eax),%edx
  803fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  803fbf:	8b 40 0c             	mov    0xc(%eax),%eax
  803fc2:	01 c2                	add    %eax,%edx
  803fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fc7:	8b 40 08             	mov    0x8(%eax),%eax
  803fca:	39 c2                	cmp    %eax,%edx
  803fcc:	0f 85 8c 06 00 00    	jne    80465e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  803fd5:	8b 50 0c             	mov    0xc(%eax),%edx
  803fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fdb:	8b 40 0c             	mov    0xc(%eax),%eax
  803fde:	01 c2                	add    %eax,%edx
  803fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe3:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803fe6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803fea:	75 17                	jne    804003 <insert_sorted_with_merge_freeList+0xed>
  803fec:	83 ec 04             	sub    $0x4,%esp
  803fef:	68 88 53 80 00       	push   $0x805388
  803ff4:	68 3c 01 00 00       	push   $0x13c
  803ff9:	68 df 52 80 00       	push   $0x8052df
  803ffe:	e8 8c d5 ff ff       	call   80158f <_panic>
  804003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804006:	8b 00                	mov    (%eax),%eax
  804008:	85 c0                	test   %eax,%eax
  80400a:	74 10                	je     80401c <insert_sorted_with_merge_freeList+0x106>
  80400c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80400f:	8b 00                	mov    (%eax),%eax
  804011:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804014:	8b 52 04             	mov    0x4(%edx),%edx
  804017:	89 50 04             	mov    %edx,0x4(%eax)
  80401a:	eb 0b                	jmp    804027 <insert_sorted_with_merge_freeList+0x111>
  80401c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80401f:	8b 40 04             	mov    0x4(%eax),%eax
  804022:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804027:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80402a:	8b 40 04             	mov    0x4(%eax),%eax
  80402d:	85 c0                	test   %eax,%eax
  80402f:	74 0f                	je     804040 <insert_sorted_with_merge_freeList+0x12a>
  804031:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804034:	8b 40 04             	mov    0x4(%eax),%eax
  804037:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80403a:	8b 12                	mov    (%edx),%edx
  80403c:	89 10                	mov    %edx,(%eax)
  80403e:	eb 0a                	jmp    80404a <insert_sorted_with_merge_freeList+0x134>
  804040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804043:	8b 00                	mov    (%eax),%eax
  804045:	a3 38 61 80 00       	mov    %eax,0x806138
  80404a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80404d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804053:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804056:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80405d:	a1 44 61 80 00       	mov    0x806144,%eax
  804062:	48                   	dec    %eax
  804063:	a3 44 61 80 00       	mov    %eax,0x806144
			head->size = 0;
  804068:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80406b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  804072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804075:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80407c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804080:	75 17                	jne    804099 <insert_sorted_with_merge_freeList+0x183>
  804082:	83 ec 04             	sub    $0x4,%esp
  804085:	68 bc 52 80 00       	push   $0x8052bc
  80408a:	68 3f 01 00 00       	push   $0x13f
  80408f:	68 df 52 80 00       	push   $0x8052df
  804094:	e8 f6 d4 ff ff       	call   80158f <_panic>
  804099:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80409f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040a2:	89 10                	mov    %edx,(%eax)
  8040a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040a7:	8b 00                	mov    (%eax),%eax
  8040a9:	85 c0                	test   %eax,%eax
  8040ab:	74 0d                	je     8040ba <insert_sorted_with_merge_freeList+0x1a4>
  8040ad:	a1 48 61 80 00       	mov    0x806148,%eax
  8040b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8040b5:	89 50 04             	mov    %edx,0x4(%eax)
  8040b8:	eb 08                	jmp    8040c2 <insert_sorted_with_merge_freeList+0x1ac>
  8040ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040bd:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8040c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040c5:	a3 48 61 80 00       	mov    %eax,0x806148
  8040ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040d4:	a1 54 61 80 00       	mov    0x806154,%eax
  8040d9:	40                   	inc    %eax
  8040da:	a3 54 61 80 00       	mov    %eax,0x806154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8040df:	e9 7a 05 00 00       	jmp    80465e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8040e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e7:	8b 50 08             	mov    0x8(%eax),%edx
  8040ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040ed:	8b 40 08             	mov    0x8(%eax),%eax
  8040f0:	39 c2                	cmp    %eax,%edx
  8040f2:	0f 82 14 01 00 00    	jb     80420c <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8040f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040fb:	8b 50 08             	mov    0x8(%eax),%edx
  8040fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804101:	8b 40 0c             	mov    0xc(%eax),%eax
  804104:	01 c2                	add    %eax,%edx
  804106:	8b 45 08             	mov    0x8(%ebp),%eax
  804109:	8b 40 08             	mov    0x8(%eax),%eax
  80410c:	39 c2                	cmp    %eax,%edx
  80410e:	0f 85 90 00 00 00    	jne    8041a4 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  804114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804117:	8b 50 0c             	mov    0xc(%eax),%edx
  80411a:	8b 45 08             	mov    0x8(%ebp),%eax
  80411d:	8b 40 0c             	mov    0xc(%eax),%eax
  804120:	01 c2                	add    %eax,%edx
  804122:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804125:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  804128:	8b 45 08             	mov    0x8(%ebp),%eax
  80412b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  804132:	8b 45 08             	mov    0x8(%ebp),%eax
  804135:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80413c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804140:	75 17                	jne    804159 <insert_sorted_with_merge_freeList+0x243>
  804142:	83 ec 04             	sub    $0x4,%esp
  804145:	68 bc 52 80 00       	push   $0x8052bc
  80414a:	68 49 01 00 00       	push   $0x149
  80414f:	68 df 52 80 00       	push   $0x8052df
  804154:	e8 36 d4 ff ff       	call   80158f <_panic>
  804159:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80415f:	8b 45 08             	mov    0x8(%ebp),%eax
  804162:	89 10                	mov    %edx,(%eax)
  804164:	8b 45 08             	mov    0x8(%ebp),%eax
  804167:	8b 00                	mov    (%eax),%eax
  804169:	85 c0                	test   %eax,%eax
  80416b:	74 0d                	je     80417a <insert_sorted_with_merge_freeList+0x264>
  80416d:	a1 48 61 80 00       	mov    0x806148,%eax
  804172:	8b 55 08             	mov    0x8(%ebp),%edx
  804175:	89 50 04             	mov    %edx,0x4(%eax)
  804178:	eb 08                	jmp    804182 <insert_sorted_with_merge_freeList+0x26c>
  80417a:	8b 45 08             	mov    0x8(%ebp),%eax
  80417d:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804182:	8b 45 08             	mov    0x8(%ebp),%eax
  804185:	a3 48 61 80 00       	mov    %eax,0x806148
  80418a:	8b 45 08             	mov    0x8(%ebp),%eax
  80418d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804194:	a1 54 61 80 00       	mov    0x806154,%eax
  804199:	40                   	inc    %eax
  80419a:	a3 54 61 80 00       	mov    %eax,0x806154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80419f:	e9 bb 04 00 00       	jmp    80465f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8041a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8041a8:	75 17                	jne    8041c1 <insert_sorted_with_merge_freeList+0x2ab>
  8041aa:	83 ec 04             	sub    $0x4,%esp
  8041ad:	68 30 53 80 00       	push   $0x805330
  8041b2:	68 4c 01 00 00       	push   $0x14c
  8041b7:	68 df 52 80 00       	push   $0x8052df
  8041bc:	e8 ce d3 ff ff       	call   80158f <_panic>
  8041c1:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  8041c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8041ca:	89 50 04             	mov    %edx,0x4(%eax)
  8041cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8041d0:	8b 40 04             	mov    0x4(%eax),%eax
  8041d3:	85 c0                	test   %eax,%eax
  8041d5:	74 0c                	je     8041e3 <insert_sorted_with_merge_freeList+0x2cd>
  8041d7:	a1 3c 61 80 00       	mov    0x80613c,%eax
  8041dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8041df:	89 10                	mov    %edx,(%eax)
  8041e1:	eb 08                	jmp    8041eb <insert_sorted_with_merge_freeList+0x2d5>
  8041e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8041e6:	a3 38 61 80 00       	mov    %eax,0x806138
  8041eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8041ee:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8041f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041fc:	a1 44 61 80 00       	mov    0x806144,%eax
  804201:	40                   	inc    %eax
  804202:	a3 44 61 80 00       	mov    %eax,0x806144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804207:	e9 53 04 00 00       	jmp    80465f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80420c:	a1 38 61 80 00       	mov    0x806138,%eax
  804211:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804214:	e9 15 04 00 00       	jmp    80462e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  804219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80421c:	8b 00                	mov    (%eax),%eax
  80421e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  804221:	8b 45 08             	mov    0x8(%ebp),%eax
  804224:	8b 50 08             	mov    0x8(%eax),%edx
  804227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80422a:	8b 40 08             	mov    0x8(%eax),%eax
  80422d:	39 c2                	cmp    %eax,%edx
  80422f:	0f 86 f1 03 00 00    	jbe    804626 <insert_sorted_with_merge_freeList+0x710>
  804235:	8b 45 08             	mov    0x8(%ebp),%eax
  804238:	8b 50 08             	mov    0x8(%eax),%edx
  80423b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80423e:	8b 40 08             	mov    0x8(%eax),%eax
  804241:	39 c2                	cmp    %eax,%edx
  804243:	0f 83 dd 03 00 00    	jae    804626 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  804249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80424c:	8b 50 08             	mov    0x8(%eax),%edx
  80424f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804252:	8b 40 0c             	mov    0xc(%eax),%eax
  804255:	01 c2                	add    %eax,%edx
  804257:	8b 45 08             	mov    0x8(%ebp),%eax
  80425a:	8b 40 08             	mov    0x8(%eax),%eax
  80425d:	39 c2                	cmp    %eax,%edx
  80425f:	0f 85 b9 01 00 00    	jne    80441e <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  804265:	8b 45 08             	mov    0x8(%ebp),%eax
  804268:	8b 50 08             	mov    0x8(%eax),%edx
  80426b:	8b 45 08             	mov    0x8(%ebp),%eax
  80426e:	8b 40 0c             	mov    0xc(%eax),%eax
  804271:	01 c2                	add    %eax,%edx
  804273:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804276:	8b 40 08             	mov    0x8(%eax),%eax
  804279:	39 c2                	cmp    %eax,%edx
  80427b:	0f 85 0d 01 00 00    	jne    80438e <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  804281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804284:	8b 50 0c             	mov    0xc(%eax),%edx
  804287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80428a:	8b 40 0c             	mov    0xc(%eax),%eax
  80428d:	01 c2                	add    %eax,%edx
  80428f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804292:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  804295:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804299:	75 17                	jne    8042b2 <insert_sorted_with_merge_freeList+0x39c>
  80429b:	83 ec 04             	sub    $0x4,%esp
  80429e:	68 88 53 80 00       	push   $0x805388
  8042a3:	68 5c 01 00 00       	push   $0x15c
  8042a8:	68 df 52 80 00       	push   $0x8052df
  8042ad:	e8 dd d2 ff ff       	call   80158f <_panic>
  8042b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042b5:	8b 00                	mov    (%eax),%eax
  8042b7:	85 c0                	test   %eax,%eax
  8042b9:	74 10                	je     8042cb <insert_sorted_with_merge_freeList+0x3b5>
  8042bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042be:	8b 00                	mov    (%eax),%eax
  8042c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042c3:	8b 52 04             	mov    0x4(%edx),%edx
  8042c6:	89 50 04             	mov    %edx,0x4(%eax)
  8042c9:	eb 0b                	jmp    8042d6 <insert_sorted_with_merge_freeList+0x3c0>
  8042cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042ce:	8b 40 04             	mov    0x4(%eax),%eax
  8042d1:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8042d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042d9:	8b 40 04             	mov    0x4(%eax),%eax
  8042dc:	85 c0                	test   %eax,%eax
  8042de:	74 0f                	je     8042ef <insert_sorted_with_merge_freeList+0x3d9>
  8042e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042e3:	8b 40 04             	mov    0x4(%eax),%eax
  8042e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8042e9:	8b 12                	mov    (%edx),%edx
  8042eb:	89 10                	mov    %edx,(%eax)
  8042ed:	eb 0a                	jmp    8042f9 <insert_sorted_with_merge_freeList+0x3e3>
  8042ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042f2:	8b 00                	mov    (%eax),%eax
  8042f4:	a3 38 61 80 00       	mov    %eax,0x806138
  8042f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804302:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804305:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80430c:	a1 44 61 80 00       	mov    0x806144,%eax
  804311:	48                   	dec    %eax
  804312:	a3 44 61 80 00       	mov    %eax,0x806144
						nextBlock->sva = 0;
  804317:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80431a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  804321:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804324:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80432b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80432f:	75 17                	jne    804348 <insert_sorted_with_merge_freeList+0x432>
  804331:	83 ec 04             	sub    $0x4,%esp
  804334:	68 bc 52 80 00       	push   $0x8052bc
  804339:	68 5f 01 00 00       	push   $0x15f
  80433e:	68 df 52 80 00       	push   $0x8052df
  804343:	e8 47 d2 ff ff       	call   80158f <_panic>
  804348:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80434e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804351:	89 10                	mov    %edx,(%eax)
  804353:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804356:	8b 00                	mov    (%eax),%eax
  804358:	85 c0                	test   %eax,%eax
  80435a:	74 0d                	je     804369 <insert_sorted_with_merge_freeList+0x453>
  80435c:	a1 48 61 80 00       	mov    0x806148,%eax
  804361:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804364:	89 50 04             	mov    %edx,0x4(%eax)
  804367:	eb 08                	jmp    804371 <insert_sorted_with_merge_freeList+0x45b>
  804369:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80436c:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804371:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804374:	a3 48 61 80 00       	mov    %eax,0x806148
  804379:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80437c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804383:	a1 54 61 80 00       	mov    0x806154,%eax
  804388:	40                   	inc    %eax
  804389:	a3 54 61 80 00       	mov    %eax,0x806154
					}
					currentBlock->size += blockToInsert->size;
  80438e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804391:	8b 50 0c             	mov    0xc(%eax),%edx
  804394:	8b 45 08             	mov    0x8(%ebp),%eax
  804397:	8b 40 0c             	mov    0xc(%eax),%eax
  80439a:	01 c2                	add    %eax,%edx
  80439c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80439f:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8043a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8043a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8043ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8043af:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8043b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8043ba:	75 17                	jne    8043d3 <insert_sorted_with_merge_freeList+0x4bd>
  8043bc:	83 ec 04             	sub    $0x4,%esp
  8043bf:	68 bc 52 80 00       	push   $0x8052bc
  8043c4:	68 64 01 00 00       	push   $0x164
  8043c9:	68 df 52 80 00       	push   $0x8052df
  8043ce:	e8 bc d1 ff ff       	call   80158f <_panic>
  8043d3:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8043d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8043dc:	89 10                	mov    %edx,(%eax)
  8043de:	8b 45 08             	mov    0x8(%ebp),%eax
  8043e1:	8b 00                	mov    (%eax),%eax
  8043e3:	85 c0                	test   %eax,%eax
  8043e5:	74 0d                	je     8043f4 <insert_sorted_with_merge_freeList+0x4de>
  8043e7:	a1 48 61 80 00       	mov    0x806148,%eax
  8043ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8043ef:	89 50 04             	mov    %edx,0x4(%eax)
  8043f2:	eb 08                	jmp    8043fc <insert_sorted_with_merge_freeList+0x4e6>
  8043f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8043f7:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8043fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8043ff:	a3 48 61 80 00       	mov    %eax,0x806148
  804404:	8b 45 08             	mov    0x8(%ebp),%eax
  804407:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80440e:	a1 54 61 80 00       	mov    0x806154,%eax
  804413:	40                   	inc    %eax
  804414:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  804419:	e9 41 02 00 00       	jmp    80465f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80441e:	8b 45 08             	mov    0x8(%ebp),%eax
  804421:	8b 50 08             	mov    0x8(%eax),%edx
  804424:	8b 45 08             	mov    0x8(%ebp),%eax
  804427:	8b 40 0c             	mov    0xc(%eax),%eax
  80442a:	01 c2                	add    %eax,%edx
  80442c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80442f:	8b 40 08             	mov    0x8(%eax),%eax
  804432:	39 c2                	cmp    %eax,%edx
  804434:	0f 85 7c 01 00 00    	jne    8045b6 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80443a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80443e:	74 06                	je     804446 <insert_sorted_with_merge_freeList+0x530>
  804440:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804444:	75 17                	jne    80445d <insert_sorted_with_merge_freeList+0x547>
  804446:	83 ec 04             	sub    $0x4,%esp
  804449:	68 f8 52 80 00       	push   $0x8052f8
  80444e:	68 69 01 00 00       	push   $0x169
  804453:	68 df 52 80 00       	push   $0x8052df
  804458:	e8 32 d1 ff ff       	call   80158f <_panic>
  80445d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804460:	8b 50 04             	mov    0x4(%eax),%edx
  804463:	8b 45 08             	mov    0x8(%ebp),%eax
  804466:	89 50 04             	mov    %edx,0x4(%eax)
  804469:	8b 45 08             	mov    0x8(%ebp),%eax
  80446c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80446f:	89 10                	mov    %edx,(%eax)
  804471:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804474:	8b 40 04             	mov    0x4(%eax),%eax
  804477:	85 c0                	test   %eax,%eax
  804479:	74 0d                	je     804488 <insert_sorted_with_merge_freeList+0x572>
  80447b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80447e:	8b 40 04             	mov    0x4(%eax),%eax
  804481:	8b 55 08             	mov    0x8(%ebp),%edx
  804484:	89 10                	mov    %edx,(%eax)
  804486:	eb 08                	jmp    804490 <insert_sorted_with_merge_freeList+0x57a>
  804488:	8b 45 08             	mov    0x8(%ebp),%eax
  80448b:	a3 38 61 80 00       	mov    %eax,0x806138
  804490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804493:	8b 55 08             	mov    0x8(%ebp),%edx
  804496:	89 50 04             	mov    %edx,0x4(%eax)
  804499:	a1 44 61 80 00       	mov    0x806144,%eax
  80449e:	40                   	inc    %eax
  80449f:	a3 44 61 80 00       	mov    %eax,0x806144
					blockToInsert->size += nextBlock->size;
  8044a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8044a7:	8b 50 0c             	mov    0xc(%eax),%edx
  8044aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8044b0:	01 c2                	add    %eax,%edx
  8044b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8044b5:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8044b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8044bc:	75 17                	jne    8044d5 <insert_sorted_with_merge_freeList+0x5bf>
  8044be:	83 ec 04             	sub    $0x4,%esp
  8044c1:	68 88 53 80 00       	push   $0x805388
  8044c6:	68 6b 01 00 00       	push   $0x16b
  8044cb:	68 df 52 80 00       	push   $0x8052df
  8044d0:	e8 ba d0 ff ff       	call   80158f <_panic>
  8044d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044d8:	8b 00                	mov    (%eax),%eax
  8044da:	85 c0                	test   %eax,%eax
  8044dc:	74 10                	je     8044ee <insert_sorted_with_merge_freeList+0x5d8>
  8044de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044e1:	8b 00                	mov    (%eax),%eax
  8044e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8044e6:	8b 52 04             	mov    0x4(%edx),%edx
  8044e9:	89 50 04             	mov    %edx,0x4(%eax)
  8044ec:	eb 0b                	jmp    8044f9 <insert_sorted_with_merge_freeList+0x5e3>
  8044ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044f1:	8b 40 04             	mov    0x4(%eax),%eax
  8044f4:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8044f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044fc:	8b 40 04             	mov    0x4(%eax),%eax
  8044ff:	85 c0                	test   %eax,%eax
  804501:	74 0f                	je     804512 <insert_sorted_with_merge_freeList+0x5fc>
  804503:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804506:	8b 40 04             	mov    0x4(%eax),%eax
  804509:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80450c:	8b 12                	mov    (%edx),%edx
  80450e:	89 10                	mov    %edx,(%eax)
  804510:	eb 0a                	jmp    80451c <insert_sorted_with_merge_freeList+0x606>
  804512:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804515:	8b 00                	mov    (%eax),%eax
  804517:	a3 38 61 80 00       	mov    %eax,0x806138
  80451c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80451f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804525:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804528:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80452f:	a1 44 61 80 00       	mov    0x806144,%eax
  804534:	48                   	dec    %eax
  804535:	a3 44 61 80 00       	mov    %eax,0x806144
					nextBlock->sva = 0;
  80453a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80453d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  804544:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804547:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80454e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804552:	75 17                	jne    80456b <insert_sorted_with_merge_freeList+0x655>
  804554:	83 ec 04             	sub    $0x4,%esp
  804557:	68 bc 52 80 00       	push   $0x8052bc
  80455c:	68 6e 01 00 00       	push   $0x16e
  804561:	68 df 52 80 00       	push   $0x8052df
  804566:	e8 24 d0 ff ff       	call   80158f <_panic>
  80456b:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804571:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804574:	89 10                	mov    %edx,(%eax)
  804576:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804579:	8b 00                	mov    (%eax),%eax
  80457b:	85 c0                	test   %eax,%eax
  80457d:	74 0d                	je     80458c <insert_sorted_with_merge_freeList+0x676>
  80457f:	a1 48 61 80 00       	mov    0x806148,%eax
  804584:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804587:	89 50 04             	mov    %edx,0x4(%eax)
  80458a:	eb 08                	jmp    804594 <insert_sorted_with_merge_freeList+0x67e>
  80458c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80458f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804594:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804597:	a3 48 61 80 00       	mov    %eax,0x806148
  80459c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80459f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045a6:	a1 54 61 80 00       	mov    0x806154,%eax
  8045ab:	40                   	inc    %eax
  8045ac:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  8045b1:	e9 a9 00 00 00       	jmp    80465f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8045b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8045ba:	74 06                	je     8045c2 <insert_sorted_with_merge_freeList+0x6ac>
  8045bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8045c0:	75 17                	jne    8045d9 <insert_sorted_with_merge_freeList+0x6c3>
  8045c2:	83 ec 04             	sub    $0x4,%esp
  8045c5:	68 54 53 80 00       	push   $0x805354
  8045ca:	68 73 01 00 00       	push   $0x173
  8045cf:	68 df 52 80 00       	push   $0x8052df
  8045d4:	e8 b6 cf ff ff       	call   80158f <_panic>
  8045d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045dc:	8b 10                	mov    (%eax),%edx
  8045de:	8b 45 08             	mov    0x8(%ebp),%eax
  8045e1:	89 10                	mov    %edx,(%eax)
  8045e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8045e6:	8b 00                	mov    (%eax),%eax
  8045e8:	85 c0                	test   %eax,%eax
  8045ea:	74 0b                	je     8045f7 <insert_sorted_with_merge_freeList+0x6e1>
  8045ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045ef:	8b 00                	mov    (%eax),%eax
  8045f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8045f4:	89 50 04             	mov    %edx,0x4(%eax)
  8045f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8045fd:	89 10                	mov    %edx,(%eax)
  8045ff:	8b 45 08             	mov    0x8(%ebp),%eax
  804602:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804605:	89 50 04             	mov    %edx,0x4(%eax)
  804608:	8b 45 08             	mov    0x8(%ebp),%eax
  80460b:	8b 00                	mov    (%eax),%eax
  80460d:	85 c0                	test   %eax,%eax
  80460f:	75 08                	jne    804619 <insert_sorted_with_merge_freeList+0x703>
  804611:	8b 45 08             	mov    0x8(%ebp),%eax
  804614:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804619:	a1 44 61 80 00       	mov    0x806144,%eax
  80461e:	40                   	inc    %eax
  80461f:	a3 44 61 80 00       	mov    %eax,0x806144
					break;
  804624:	eb 39                	jmp    80465f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  804626:	a1 40 61 80 00       	mov    0x806140,%eax
  80462b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80462e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804632:	74 07                	je     80463b <insert_sorted_with_merge_freeList+0x725>
  804634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804637:	8b 00                	mov    (%eax),%eax
  804639:	eb 05                	jmp    804640 <insert_sorted_with_merge_freeList+0x72a>
  80463b:	b8 00 00 00 00       	mov    $0x0,%eax
  804640:	a3 40 61 80 00       	mov    %eax,0x806140
  804645:	a1 40 61 80 00       	mov    0x806140,%eax
  80464a:	85 c0                	test   %eax,%eax
  80464c:	0f 85 c7 fb ff ff    	jne    804219 <insert_sorted_with_merge_freeList+0x303>
  804652:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804656:	0f 85 bd fb ff ff    	jne    804219 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80465c:	eb 01                	jmp    80465f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80465e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80465f:	90                   	nop
  804660:	c9                   	leave  
  804661:	c3                   	ret    
  804662:	66 90                	xchg   %ax,%ax

00804664 <__udivdi3>:
  804664:	55                   	push   %ebp
  804665:	57                   	push   %edi
  804666:	56                   	push   %esi
  804667:	53                   	push   %ebx
  804668:	83 ec 1c             	sub    $0x1c,%esp
  80466b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80466f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804673:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804677:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80467b:	89 ca                	mov    %ecx,%edx
  80467d:	89 f8                	mov    %edi,%eax
  80467f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804683:	85 f6                	test   %esi,%esi
  804685:	75 2d                	jne    8046b4 <__udivdi3+0x50>
  804687:	39 cf                	cmp    %ecx,%edi
  804689:	77 65                	ja     8046f0 <__udivdi3+0x8c>
  80468b:	89 fd                	mov    %edi,%ebp
  80468d:	85 ff                	test   %edi,%edi
  80468f:	75 0b                	jne    80469c <__udivdi3+0x38>
  804691:	b8 01 00 00 00       	mov    $0x1,%eax
  804696:	31 d2                	xor    %edx,%edx
  804698:	f7 f7                	div    %edi
  80469a:	89 c5                	mov    %eax,%ebp
  80469c:	31 d2                	xor    %edx,%edx
  80469e:	89 c8                	mov    %ecx,%eax
  8046a0:	f7 f5                	div    %ebp
  8046a2:	89 c1                	mov    %eax,%ecx
  8046a4:	89 d8                	mov    %ebx,%eax
  8046a6:	f7 f5                	div    %ebp
  8046a8:	89 cf                	mov    %ecx,%edi
  8046aa:	89 fa                	mov    %edi,%edx
  8046ac:	83 c4 1c             	add    $0x1c,%esp
  8046af:	5b                   	pop    %ebx
  8046b0:	5e                   	pop    %esi
  8046b1:	5f                   	pop    %edi
  8046b2:	5d                   	pop    %ebp
  8046b3:	c3                   	ret    
  8046b4:	39 ce                	cmp    %ecx,%esi
  8046b6:	77 28                	ja     8046e0 <__udivdi3+0x7c>
  8046b8:	0f bd fe             	bsr    %esi,%edi
  8046bb:	83 f7 1f             	xor    $0x1f,%edi
  8046be:	75 40                	jne    804700 <__udivdi3+0x9c>
  8046c0:	39 ce                	cmp    %ecx,%esi
  8046c2:	72 0a                	jb     8046ce <__udivdi3+0x6a>
  8046c4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8046c8:	0f 87 9e 00 00 00    	ja     80476c <__udivdi3+0x108>
  8046ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8046d3:	89 fa                	mov    %edi,%edx
  8046d5:	83 c4 1c             	add    $0x1c,%esp
  8046d8:	5b                   	pop    %ebx
  8046d9:	5e                   	pop    %esi
  8046da:	5f                   	pop    %edi
  8046db:	5d                   	pop    %ebp
  8046dc:	c3                   	ret    
  8046dd:	8d 76 00             	lea    0x0(%esi),%esi
  8046e0:	31 ff                	xor    %edi,%edi
  8046e2:	31 c0                	xor    %eax,%eax
  8046e4:	89 fa                	mov    %edi,%edx
  8046e6:	83 c4 1c             	add    $0x1c,%esp
  8046e9:	5b                   	pop    %ebx
  8046ea:	5e                   	pop    %esi
  8046eb:	5f                   	pop    %edi
  8046ec:	5d                   	pop    %ebp
  8046ed:	c3                   	ret    
  8046ee:	66 90                	xchg   %ax,%ax
  8046f0:	89 d8                	mov    %ebx,%eax
  8046f2:	f7 f7                	div    %edi
  8046f4:	31 ff                	xor    %edi,%edi
  8046f6:	89 fa                	mov    %edi,%edx
  8046f8:	83 c4 1c             	add    $0x1c,%esp
  8046fb:	5b                   	pop    %ebx
  8046fc:	5e                   	pop    %esi
  8046fd:	5f                   	pop    %edi
  8046fe:	5d                   	pop    %ebp
  8046ff:	c3                   	ret    
  804700:	bd 20 00 00 00       	mov    $0x20,%ebp
  804705:	89 eb                	mov    %ebp,%ebx
  804707:	29 fb                	sub    %edi,%ebx
  804709:	89 f9                	mov    %edi,%ecx
  80470b:	d3 e6                	shl    %cl,%esi
  80470d:	89 c5                	mov    %eax,%ebp
  80470f:	88 d9                	mov    %bl,%cl
  804711:	d3 ed                	shr    %cl,%ebp
  804713:	89 e9                	mov    %ebp,%ecx
  804715:	09 f1                	or     %esi,%ecx
  804717:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80471b:	89 f9                	mov    %edi,%ecx
  80471d:	d3 e0                	shl    %cl,%eax
  80471f:	89 c5                	mov    %eax,%ebp
  804721:	89 d6                	mov    %edx,%esi
  804723:	88 d9                	mov    %bl,%cl
  804725:	d3 ee                	shr    %cl,%esi
  804727:	89 f9                	mov    %edi,%ecx
  804729:	d3 e2                	shl    %cl,%edx
  80472b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80472f:	88 d9                	mov    %bl,%cl
  804731:	d3 e8                	shr    %cl,%eax
  804733:	09 c2                	or     %eax,%edx
  804735:	89 d0                	mov    %edx,%eax
  804737:	89 f2                	mov    %esi,%edx
  804739:	f7 74 24 0c          	divl   0xc(%esp)
  80473d:	89 d6                	mov    %edx,%esi
  80473f:	89 c3                	mov    %eax,%ebx
  804741:	f7 e5                	mul    %ebp
  804743:	39 d6                	cmp    %edx,%esi
  804745:	72 19                	jb     804760 <__udivdi3+0xfc>
  804747:	74 0b                	je     804754 <__udivdi3+0xf0>
  804749:	89 d8                	mov    %ebx,%eax
  80474b:	31 ff                	xor    %edi,%edi
  80474d:	e9 58 ff ff ff       	jmp    8046aa <__udivdi3+0x46>
  804752:	66 90                	xchg   %ax,%ax
  804754:	8b 54 24 08          	mov    0x8(%esp),%edx
  804758:	89 f9                	mov    %edi,%ecx
  80475a:	d3 e2                	shl    %cl,%edx
  80475c:	39 c2                	cmp    %eax,%edx
  80475e:	73 e9                	jae    804749 <__udivdi3+0xe5>
  804760:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804763:	31 ff                	xor    %edi,%edi
  804765:	e9 40 ff ff ff       	jmp    8046aa <__udivdi3+0x46>
  80476a:	66 90                	xchg   %ax,%ax
  80476c:	31 c0                	xor    %eax,%eax
  80476e:	e9 37 ff ff ff       	jmp    8046aa <__udivdi3+0x46>
  804773:	90                   	nop

00804774 <__umoddi3>:
  804774:	55                   	push   %ebp
  804775:	57                   	push   %edi
  804776:	56                   	push   %esi
  804777:	53                   	push   %ebx
  804778:	83 ec 1c             	sub    $0x1c,%esp
  80477b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80477f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804783:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804787:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80478b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80478f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804793:	89 f3                	mov    %esi,%ebx
  804795:	89 fa                	mov    %edi,%edx
  804797:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80479b:	89 34 24             	mov    %esi,(%esp)
  80479e:	85 c0                	test   %eax,%eax
  8047a0:	75 1a                	jne    8047bc <__umoddi3+0x48>
  8047a2:	39 f7                	cmp    %esi,%edi
  8047a4:	0f 86 a2 00 00 00    	jbe    80484c <__umoddi3+0xd8>
  8047aa:	89 c8                	mov    %ecx,%eax
  8047ac:	89 f2                	mov    %esi,%edx
  8047ae:	f7 f7                	div    %edi
  8047b0:	89 d0                	mov    %edx,%eax
  8047b2:	31 d2                	xor    %edx,%edx
  8047b4:	83 c4 1c             	add    $0x1c,%esp
  8047b7:	5b                   	pop    %ebx
  8047b8:	5e                   	pop    %esi
  8047b9:	5f                   	pop    %edi
  8047ba:	5d                   	pop    %ebp
  8047bb:	c3                   	ret    
  8047bc:	39 f0                	cmp    %esi,%eax
  8047be:	0f 87 ac 00 00 00    	ja     804870 <__umoddi3+0xfc>
  8047c4:	0f bd e8             	bsr    %eax,%ebp
  8047c7:	83 f5 1f             	xor    $0x1f,%ebp
  8047ca:	0f 84 ac 00 00 00    	je     80487c <__umoddi3+0x108>
  8047d0:	bf 20 00 00 00       	mov    $0x20,%edi
  8047d5:	29 ef                	sub    %ebp,%edi
  8047d7:	89 fe                	mov    %edi,%esi
  8047d9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8047dd:	89 e9                	mov    %ebp,%ecx
  8047df:	d3 e0                	shl    %cl,%eax
  8047e1:	89 d7                	mov    %edx,%edi
  8047e3:	89 f1                	mov    %esi,%ecx
  8047e5:	d3 ef                	shr    %cl,%edi
  8047e7:	09 c7                	or     %eax,%edi
  8047e9:	89 e9                	mov    %ebp,%ecx
  8047eb:	d3 e2                	shl    %cl,%edx
  8047ed:	89 14 24             	mov    %edx,(%esp)
  8047f0:	89 d8                	mov    %ebx,%eax
  8047f2:	d3 e0                	shl    %cl,%eax
  8047f4:	89 c2                	mov    %eax,%edx
  8047f6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047fa:	d3 e0                	shl    %cl,%eax
  8047fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  804800:	8b 44 24 08          	mov    0x8(%esp),%eax
  804804:	89 f1                	mov    %esi,%ecx
  804806:	d3 e8                	shr    %cl,%eax
  804808:	09 d0                	or     %edx,%eax
  80480a:	d3 eb                	shr    %cl,%ebx
  80480c:	89 da                	mov    %ebx,%edx
  80480e:	f7 f7                	div    %edi
  804810:	89 d3                	mov    %edx,%ebx
  804812:	f7 24 24             	mull   (%esp)
  804815:	89 c6                	mov    %eax,%esi
  804817:	89 d1                	mov    %edx,%ecx
  804819:	39 d3                	cmp    %edx,%ebx
  80481b:	0f 82 87 00 00 00    	jb     8048a8 <__umoddi3+0x134>
  804821:	0f 84 91 00 00 00    	je     8048b8 <__umoddi3+0x144>
  804827:	8b 54 24 04          	mov    0x4(%esp),%edx
  80482b:	29 f2                	sub    %esi,%edx
  80482d:	19 cb                	sbb    %ecx,%ebx
  80482f:	89 d8                	mov    %ebx,%eax
  804831:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804835:	d3 e0                	shl    %cl,%eax
  804837:	89 e9                	mov    %ebp,%ecx
  804839:	d3 ea                	shr    %cl,%edx
  80483b:	09 d0                	or     %edx,%eax
  80483d:	89 e9                	mov    %ebp,%ecx
  80483f:	d3 eb                	shr    %cl,%ebx
  804841:	89 da                	mov    %ebx,%edx
  804843:	83 c4 1c             	add    $0x1c,%esp
  804846:	5b                   	pop    %ebx
  804847:	5e                   	pop    %esi
  804848:	5f                   	pop    %edi
  804849:	5d                   	pop    %ebp
  80484a:	c3                   	ret    
  80484b:	90                   	nop
  80484c:	89 fd                	mov    %edi,%ebp
  80484e:	85 ff                	test   %edi,%edi
  804850:	75 0b                	jne    80485d <__umoddi3+0xe9>
  804852:	b8 01 00 00 00       	mov    $0x1,%eax
  804857:	31 d2                	xor    %edx,%edx
  804859:	f7 f7                	div    %edi
  80485b:	89 c5                	mov    %eax,%ebp
  80485d:	89 f0                	mov    %esi,%eax
  80485f:	31 d2                	xor    %edx,%edx
  804861:	f7 f5                	div    %ebp
  804863:	89 c8                	mov    %ecx,%eax
  804865:	f7 f5                	div    %ebp
  804867:	89 d0                	mov    %edx,%eax
  804869:	e9 44 ff ff ff       	jmp    8047b2 <__umoddi3+0x3e>
  80486e:	66 90                	xchg   %ax,%ax
  804870:	89 c8                	mov    %ecx,%eax
  804872:	89 f2                	mov    %esi,%edx
  804874:	83 c4 1c             	add    $0x1c,%esp
  804877:	5b                   	pop    %ebx
  804878:	5e                   	pop    %esi
  804879:	5f                   	pop    %edi
  80487a:	5d                   	pop    %ebp
  80487b:	c3                   	ret    
  80487c:	3b 04 24             	cmp    (%esp),%eax
  80487f:	72 06                	jb     804887 <__umoddi3+0x113>
  804881:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804885:	77 0f                	ja     804896 <__umoddi3+0x122>
  804887:	89 f2                	mov    %esi,%edx
  804889:	29 f9                	sub    %edi,%ecx
  80488b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80488f:	89 14 24             	mov    %edx,(%esp)
  804892:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804896:	8b 44 24 04          	mov    0x4(%esp),%eax
  80489a:	8b 14 24             	mov    (%esp),%edx
  80489d:	83 c4 1c             	add    $0x1c,%esp
  8048a0:	5b                   	pop    %ebx
  8048a1:	5e                   	pop    %esi
  8048a2:	5f                   	pop    %edi
  8048a3:	5d                   	pop    %ebp
  8048a4:	c3                   	ret    
  8048a5:	8d 76 00             	lea    0x0(%esi),%esi
  8048a8:	2b 04 24             	sub    (%esp),%eax
  8048ab:	19 fa                	sbb    %edi,%edx
  8048ad:	89 d1                	mov    %edx,%ecx
  8048af:	89 c6                	mov    %eax,%esi
  8048b1:	e9 71 ff ff ff       	jmp    804827 <__umoddi3+0xb3>
  8048b6:	66 90                	xchg   %ax,%ax
  8048b8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8048bc:	72 ea                	jb     8048a8 <__umoddi3+0x134>
  8048be:	89 d9                	mov    %ebx,%ecx
  8048c0:	e9 62 ff ff ff       	jmp    804827 <__umoddi3+0xb3>
