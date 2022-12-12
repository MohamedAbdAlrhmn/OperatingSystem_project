
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
  8000a3:	68 80 48 80 00       	push   $0x804880
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 c1 48 80 00       	push   $0x8048c1
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
  8000d9:	68 80 48 80 00       	push   $0x804880
  8000de:	6a 21                	push   $0x21
  8000e0:	68 c1 48 80 00       	push   $0x8048c1
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
  80010f:	68 80 48 80 00       	push   $0x804880
  800114:	6a 22                	push   $0x22
  800116:	68 c1 48 80 00       	push   $0x8048c1
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
  800145:	68 80 48 80 00       	push   $0x804880
  80014a:	6a 23                	push   $0x23
  80014c:	68 c1 48 80 00       	push   $0x8048c1
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
  80017b:	68 80 48 80 00       	push   $0x804880
  800180:	6a 24                	push   $0x24
  800182:	68 c1 48 80 00       	push   $0x8048c1
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
  8001b1:	68 80 48 80 00       	push   $0x804880
  8001b6:	6a 25                	push   $0x25
  8001b8:	68 c1 48 80 00       	push   $0x8048c1
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
  8001e9:	68 80 48 80 00       	push   $0x804880
  8001ee:	6a 26                	push   $0x26
  8001f0:	68 c1 48 80 00       	push   $0x8048c1
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
  800221:	68 80 48 80 00       	push   $0x804880
  800226:	6a 27                	push   $0x27
  800228:	68 c1 48 80 00       	push   $0x8048c1
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
  800259:	68 80 48 80 00       	push   $0x804880
  80025e:	6a 28                	push   $0x28
  800260:	68 c1 48 80 00       	push   $0x8048c1
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
  800291:	68 80 48 80 00       	push   $0x804880
  800296:	6a 29                	push   $0x29
  800298:	68 c1 48 80 00       	push   $0x8048c1
  80029d:	e8 ed 12 00 00       	call   80158f <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8002a7:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 d4 48 80 00       	push   $0x8048d4
  8002b9:	6a 2a                	push   $0x2a
  8002bb:	68 c1 48 80 00       	push   $0x8048c1
  8002c0:	e8 ca 12 00 00       	call   80158f <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 89 27 00 00       	call   802a53 <sys_calculate_free_frames>
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
  8002e1:	e8 0d 28 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  80031d:	68 1c 49 80 00       	push   $0x80491c
  800322:	6a 39                	push   $0x39
  800324:	68 c1 48 80 00       	push   $0x8048c1
  800329:	e8 61 12 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032e:	e8 c0 27 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
  800333:	2b 45 90             	sub    -0x70(%ebp),%eax
  800336:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 84 49 80 00       	push   $0x804984
  800345:	6a 3a                	push   $0x3a
  800347:	68 c1 48 80 00       	push   $0x8048c1
  80034c:	e8 3e 12 00 00       	call   80158f <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 9d 27 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  8003a6:	68 1c 49 80 00       	push   $0x80491c
  8003ab:	6a 40                	push   $0x40
  8003ad:	68 c1 48 80 00       	push   $0x8048c1
  8003b2:	e8 d8 11 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b7:	e8 37 27 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  8003dd:	68 84 49 80 00       	push   $0x804984
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 c1 48 80 00       	push   $0x8048c1
  8003e9:	e8 a1 11 00 00       	call   80158f <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ee:	e8 00 27 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  80044a:	68 1c 49 80 00       	push   $0x80491c
  80044f:	6a 47                	push   $0x47
  800451:	68 c1 48 80 00       	push   $0x8048c1
  800456:	e8 34 11 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045b:	e8 93 26 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  80047e:	68 84 49 80 00       	push   $0x804984
  800483:	6a 48                	push   $0x48
  800485:	68 c1 48 80 00       	push   $0x8048c1
  80048a:	e8 00 11 00 00       	call   80158f <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 5f 26 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  8004fa:	68 1c 49 80 00       	push   $0x80491c
  8004ff:	6a 4e                	push   $0x4e
  800501:	68 c1 48 80 00       	push   $0x8048c1
  800506:	e8 84 10 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050b:	e8 e3 25 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  800535:	68 84 49 80 00       	push   $0x804984
  80053a:	6a 4f                	push   $0x4f
  80053c:	68 c1 48 80 00       	push   $0x8048c1
  800541:	e8 49 10 00 00       	call   80158f <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800546:	e8 08 25 00 00       	call   802a53 <sys_calculate_free_frames>
  80054b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054e:	e8 19 25 00 00       	call   802a6c <sys_calculate_modified_frames>
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
  80060f:	e8 3f 24 00 00       	call   802a53 <sys_calculate_free_frames>
  800614:	89 c3                	mov    %eax,%ebx
  800616:	e8 51 24 00 00       	call   802a6c <sys_calculate_modified_frames>
  80061b:	01 d8                	add    %ebx,%eax
  80061d:	29 c6                	sub    %eax,%esi
  80061f:	89 f0                	mov    %esi,%eax
  800621:	83 f8 02             	cmp    $0x2,%eax
  800624:	74 14                	je     80063a <_main+0x602>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 b4 49 80 00       	push   $0x8049b4
  80062e:	6a 67                	push   $0x67
  800630:	68 c1 48 80 00       	push   $0x8048c1
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
  8006d1:	68 f8 49 80 00       	push   $0x8049f8
  8006d6:	6a 73                	push   $0x73
  8006d8:	68 c1 48 80 00       	push   $0x8048c1
  8006dd:	e8 ad 0e 00 00       	call   80158f <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e2:	e8 6c 23 00 00       	call   802a53 <sys_calculate_free_frames>
  8006e7:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006ea:	e8 7d 23 00 00       	call   802a6c <sys_calculate_modified_frames>
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
  8007eb:	e8 63 22 00 00       	call   802a53 <sys_calculate_free_frames>
  8007f0:	29 c3                	sub    %eax,%ebx
  8007f2:	89 d8                	mov    %ebx,%eax
  8007f4:	83 f8 04             	cmp    $0x4,%eax
  8007f7:	74 17                	je     800810 <_main+0x7d8>
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 b4 49 80 00       	push   $0x8049b4
  800801:	68 8e 00 00 00       	push   $0x8e
  800806:	68 c1 48 80 00       	push   $0x8048c1
  80080b:	e8 7f 0d 00 00       	call   80158f <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800810:	8b 5d 88             	mov    -0x78(%ebp),%ebx
  800813:	e8 54 22 00 00       	call   802a6c <sys_calculate_modified_frames>
  800818:	29 c3                	sub    %eax,%ebx
  80081a:	89 d8                	mov    %ebx,%eax
  80081c:	83 f8 fe             	cmp    $0xfffffffe,%eax
  80081f:	74 17                	je     800838 <_main+0x800>
  800821:	83 ec 04             	sub    $0x4,%esp
  800824:	68 b4 49 80 00       	push   $0x8049b4
  800829:	68 8f 00 00 00       	push   $0x8f
  80082e:	68 c1 48 80 00       	push   $0x8048c1
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
  8008d1:	68 f8 49 80 00       	push   $0x8049f8
  8008d6:	68 9b 00 00 00       	push   $0x9b
  8008db:	68 c1 48 80 00       	push   $0x8048c1
  8008e0:	e8 aa 0c 00 00       	call   80158f <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008e5:	e8 69 21 00 00       	call   802a53 <sys_calculate_free_frames>
  8008ea:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008ed:	e8 7a 21 00 00       	call   802a6c <sys_calculate_modified_frames>
  8008f2:	89 45 88             	mov    %eax,-0x78(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008f5:	e8 f9 21 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
  8008fa:	89 45 90             	mov    %eax,-0x70(%ebp)

		free(ptr_allocations[1]);
  8008fd:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800903:	83 ec 0c             	sub    $0xc,%esp
  800906:	50                   	push   %eax
  800907:	e8 ed 1e 00 00       	call   8027f9 <free>
  80090c:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80090f:	e8 df 21 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  800937:	68 18 4a 80 00       	push   $0x804a18
  80093c:	68 a5 00 00 00       	push   $0xa5
  800941:	68 c1 48 80 00       	push   $0x8048c1
  800946:	e8 44 0c 00 00       	call   80158f <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  80094b:	e8 03 21 00 00       	call   802a53 <sys_calculate_free_frames>
  800950:	89 c2                	mov    %eax,%edx
  800952:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800955:	29 c2                	sub    %eax,%edx
  800957:	89 d0                	mov    %edx,%eax
  800959:	83 f8 07             	cmp    $0x7,%eax
  80095c:	74 17                	je     800975 <_main+0x93d>
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	68 54 4a 80 00       	push   $0x804a54
  800966:	68 a7 00 00 00       	push   $0xa7
  80096b:	68 c1 48 80 00       	push   $0x8048c1
  800970:	e8 1a 0c 00 00       	call   80158f <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800975:	e8 f2 20 00 00       	call   802a6c <sys_calculate_modified_frames>
  80097a:	89 c2                	mov    %eax,%edx
  80097c:	8b 45 88             	mov    -0x78(%ebp),%eax
  80097f:	29 c2                	sub    %eax,%edx
  800981:	89 d0                	mov    %edx,%eax
  800983:	83 f8 02             	cmp    $0x2,%eax
  800986:	74 17                	je     80099f <_main+0x967>
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 a8 4a 80 00       	push   $0x804aa8
  800990:	68 a8 00 00 00       	push   $0xa8
  800995:	68 c1 48 80 00       	push   $0x8048c1
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
  800a0e:	68 e0 4a 80 00       	push   $0x804ae0
  800a13:	68 b0 00 00 00       	push   $0xb0
  800a18:	68 c1 48 80 00       	push   $0x8048c1
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
  800a41:	e8 0d 20 00 00       	call   802a53 <sys_calculate_free_frames>
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
  800a8e:	e8 c0 1f 00 00       	call   802a53 <sys_calculate_free_frames>
  800a93:	29 c3                	sub    %eax,%ebx
  800a95:	89 d8                	mov    %ebx,%eax
  800a97:	83 f8 02             	cmp    $0x2,%eax
  800a9a:	74 17                	je     800ab3 <_main+0xa7b>
  800a9c:	83 ec 04             	sub    $0x4,%esp
  800a9f:	68 b4 49 80 00       	push   $0x8049b4
  800aa4:	68 bc 00 00 00       	push   $0xbc
  800aa9:	68 c1 48 80 00       	push   $0x8048c1
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
  800b89:	68 f8 49 80 00       	push   $0x8049f8
  800b8e:	68 c5 00 00 00       	push   $0xc5
  800b93:	68 c1 48 80 00       	push   $0x8048c1
  800b98:	e8 f2 09 00 00       	call   80158f <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b9d:	e8 51 1f 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  800bed:	68 1c 49 80 00       	push   $0x80491c
  800bf2:	68 ca 00 00 00       	push   $0xca
  800bf7:	68 c1 48 80 00       	push   $0x8048c1
  800bfc:	e8 8e 09 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800c01:	e8 ed 1e 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
  800c06:	2b 45 90             	sub    -0x70(%ebp),%eax
  800c09:	83 f8 01             	cmp    $0x1,%eax
  800c0c:	74 17                	je     800c25 <_main+0xbed>
  800c0e:	83 ec 04             	sub    $0x4,%esp
  800c11:	68 84 49 80 00       	push   $0x804984
  800c16:	68 cb 00 00 00       	push   $0xcb
  800c1b:	68 c1 48 80 00       	push   $0x8048c1
  800c20:	e8 6a 09 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c25:	e8 29 1e 00 00       	call   802a53 <sys_calculate_free_frames>
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
  800c70:	e8 de 1d 00 00       	call   802a53 <sys_calculate_free_frames>
  800c75:	29 c3                	sub    %eax,%ebx
  800c77:	89 d8                	mov    %ebx,%eax
  800c79:	83 f8 02             	cmp    $0x2,%eax
  800c7c:	74 17                	je     800c95 <_main+0xc5d>
  800c7e:	83 ec 04             	sub    $0x4,%esp
  800c81:	68 b4 49 80 00       	push   $0x8049b4
  800c86:	68 d2 00 00 00       	push   $0xd2
  800c8b:	68 c1 48 80 00       	push   $0x8048c1
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
  800d6e:	68 f8 49 80 00       	push   $0x8049f8
  800d73:	68 db 00 00 00       	push   $0xdb
  800d78:	68 c1 48 80 00       	push   $0x8048c1
  800d7d:	e8 0d 08 00 00       	call   80158f <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d82:	e8 cc 1c 00 00       	call   802a53 <sys_calculate_free_frames>
  800d87:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d8a:	e8 64 1d 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  800dee:	68 1c 49 80 00       	push   $0x80491c
  800df3:	68 e1 00 00 00       	push   $0xe1
  800df8:	68 c1 48 80 00       	push   $0x8048c1
  800dfd:	e8 8d 07 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800e02:	e8 ec 1c 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
  800e07:	2b 45 90             	sub    -0x70(%ebp),%eax
  800e0a:	83 f8 01             	cmp    $0x1,%eax
  800e0d:	74 17                	je     800e26 <_main+0xdee>
  800e0f:	83 ec 04             	sub    $0x4,%esp
  800e12:	68 84 49 80 00       	push   $0x804984
  800e17:	68 e2 00 00 00       	push   $0xe2
  800e1c:	68 c1 48 80 00       	push   $0x8048c1
  800e21:	e8 69 07 00 00       	call   80158f <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e26:	e8 c8 1c 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  800e92:	68 1c 49 80 00       	push   $0x80491c
  800e97:	68 e8 00 00 00       	push   $0xe8
  800e9c:	68 c1 48 80 00       	push   $0x8048c1
  800ea1:	e8 e9 06 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800ea6:	e8 48 1c 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
  800eab:	2b 45 90             	sub    -0x70(%ebp),%eax
  800eae:	83 f8 02             	cmp    $0x2,%eax
  800eb1:	74 17                	je     800eca <_main+0xe92>
  800eb3:	83 ec 04             	sub    $0x4,%esp
  800eb6:	68 84 49 80 00       	push   $0x804984
  800ebb:	68 e9 00 00 00       	push   $0xe9
  800ec0:	68 c1 48 80 00       	push   $0x8048c1
  800ec5:	e8 c5 06 00 00       	call   80158f <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800eca:	e8 84 1b 00 00       	call   802a53 <sys_calculate_free_frames>
  800ecf:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800ed2:	e8 1c 1c 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  800f3d:	68 1c 49 80 00       	push   $0x80491c
  800f42:	68 f0 00 00 00       	push   $0xf0
  800f47:	68 c1 48 80 00       	push   $0x8048c1
  800f4c:	e8 3e 06 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f51:	e8 9d 1b 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  800f77:	68 84 49 80 00       	push   $0x804984
  800f7c:	68 f1 00 00 00       	push   $0xf1
  800f81:	68 c1 48 80 00       	push   $0x8048c1
  800f86:	e8 04 06 00 00       	call   80158f <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8b:	e8 63 1b 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  801006:	68 1c 49 80 00       	push   $0x80491c
  80100b:	68 f7 00 00 00       	push   $0xf7
  801010:	68 c1 48 80 00       	push   $0x8048c1
  801015:	e8 75 05 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  80101a:	e8 d4 1a 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  801042:	68 84 49 80 00       	push   $0x804984
  801047:	68 f8 00 00 00       	push   $0xf8
  80104c:	68 c1 48 80 00       	push   $0x8048c1
  801051:	e8 39 05 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801056:	e8 f8 19 00 00       	call   802a53 <sys_calculate_free_frames>
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
  8010c7:	e8 87 19 00 00       	call   802a53 <sys_calculate_free_frames>
  8010cc:	29 c3                	sub    %eax,%ebx
  8010ce:	89 d8                	mov    %ebx,%eax
  8010d0:	83 f8 05             	cmp    $0x5,%eax
  8010d3:	74 17                	je     8010ec <_main+0x10b4>
  8010d5:	83 ec 04             	sub    $0x4,%esp
  8010d8:	68 b4 49 80 00       	push   $0x8049b4
  8010dd:	68 00 01 00 00       	push   $0x100
  8010e2:	68 c1 48 80 00       	push   $0x8048c1
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
  80121d:	68 f8 49 80 00       	push   $0x8049f8
  801222:	68 0b 01 00 00       	push   $0x10b
  801227:	68 c1 48 80 00       	push   $0x8048c1
  80122c:	e8 5e 03 00 00       	call   80158f <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801231:	e8 bd 18 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
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
  8012af:	68 1c 49 80 00       	push   $0x80491c
  8012b4:	68 10 01 00 00       	push   $0x110
  8012b9:	68 c1 48 80 00       	push   $0x8048c1
  8012be:	e8 cc 02 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012c3:	e8 2b 18 00 00       	call   802af3 <sys_pf_calculate_allocated_pages>
  8012c8:	2b 45 90             	sub    -0x70(%ebp),%eax
  8012cb:	83 f8 04             	cmp    $0x4,%eax
  8012ce:	74 17                	je     8012e7 <_main+0x12af>
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	68 84 49 80 00       	push   $0x804984
  8012d8:	68 11 01 00 00       	push   $0x111
  8012dd:	68 c1 48 80 00       	push   $0x8048c1
  8012e2:	e8 a8 02 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8012e7:	e8 67 17 00 00       	call   802a53 <sys_calculate_free_frames>
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
  80133b:	e8 13 17 00 00       	call   802a53 <sys_calculate_free_frames>
  801340:	29 c3                	sub    %eax,%ebx
  801342:	89 d8                	mov    %ebx,%eax
  801344:	83 f8 02             	cmp    $0x2,%eax
  801347:	74 17                	je     801360 <_main+0x1328>
  801349:	83 ec 04             	sub    $0x4,%esp
  80134c:	68 b4 49 80 00       	push   $0x8049b4
  801351:	68 18 01 00 00       	push   $0x118
  801356:	68 c1 48 80 00       	push   $0x8048c1
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
  801436:	68 f8 49 80 00       	push   $0x8049f8
  80143b:	68 21 01 00 00       	push   $0x121
  801440:	68 c1 48 80 00       	push   $0x8048c1
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
  801459:	e8 d5 18 00 00       	call   802d33 <sys_getenvindex>
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
  8014c4:	e8 77 16 00 00       	call   802b40 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8014c9:	83 ec 0c             	sub    $0xc,%esp
  8014cc:	68 1c 4b 80 00       	push   $0x804b1c
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
  8014f4:	68 44 4b 80 00       	push   $0x804b44
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
  801525:	68 6c 4b 80 00       	push   $0x804b6c
  80152a:	e8 14 03 00 00       	call   801843 <cprintf>
  80152f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801532:	a1 20 60 80 00       	mov    0x806020,%eax
  801537:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80153d:	83 ec 08             	sub    $0x8,%esp
  801540:	50                   	push   %eax
  801541:	68 c4 4b 80 00       	push   $0x804bc4
  801546:	e8 f8 02 00 00       	call   801843 <cprintf>
  80154b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80154e:	83 ec 0c             	sub    $0xc,%esp
  801551:	68 1c 4b 80 00       	push   $0x804b1c
  801556:	e8 e8 02 00 00       	call   801843 <cprintf>
  80155b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80155e:	e8 f7 15 00 00       	call   802b5a <sys_enable_interrupt>

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
  801576:	e8 84 17 00 00       	call   802cff <sys_destroy_env>
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
  801587:	e8 d9 17 00 00       	call   802d65 <sys_exit_env>
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
  8015b0:	68 d8 4b 80 00       	push   $0x804bd8
  8015b5:	e8 89 02 00 00       	call   801843 <cprintf>
  8015ba:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8015bd:	a1 00 60 80 00       	mov    0x806000,%eax
  8015c2:	ff 75 0c             	pushl  0xc(%ebp)
  8015c5:	ff 75 08             	pushl  0x8(%ebp)
  8015c8:	50                   	push   %eax
  8015c9:	68 dd 4b 80 00       	push   $0x804bdd
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
  8015ed:	68 f9 4b 80 00       	push   $0x804bf9
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
  801619:	68 fc 4b 80 00       	push   $0x804bfc
  80161e:	6a 26                	push   $0x26
  801620:	68 48 4c 80 00       	push   $0x804c48
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
  8016eb:	68 54 4c 80 00       	push   $0x804c54
  8016f0:	6a 3a                	push   $0x3a
  8016f2:	68 48 4c 80 00       	push   $0x804c48
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
  80175b:	68 a8 4c 80 00       	push   $0x804ca8
  801760:	6a 44                	push   $0x44
  801762:	68 48 4c 80 00       	push   $0x804c48
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
  8017b5:	e8 d8 11 00 00       	call   802992 <sys_cputs>
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
  80182c:	e8 61 11 00 00       	call   802992 <sys_cputs>
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
  801876:	e8 c5 12 00 00       	call   802b40 <sys_disable_interrupt>
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
  801896:	e8 bf 12 00 00       	call   802b5a <sys_enable_interrupt>
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
  8018e0:	e8 33 2d 00 00       	call   804618 <__udivdi3>
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
  801930:	e8 f3 2d 00 00       	call   804728 <__umoddi3>
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	05 14 4f 80 00       	add    $0x804f14,%eax
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
  801a8b:	8b 04 85 38 4f 80 00 	mov    0x804f38(,%eax,4),%eax
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
  801b6c:	8b 34 9d 80 4d 80 00 	mov    0x804d80(,%ebx,4),%esi
  801b73:	85 f6                	test   %esi,%esi
  801b75:	75 19                	jne    801b90 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801b77:	53                   	push   %ebx
  801b78:	68 25 4f 80 00       	push   $0x804f25
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
  801b91:	68 2e 4f 80 00       	push   $0x804f2e
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
  801bbe:	be 31 4f 80 00       	mov    $0x804f31,%esi
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
  8025e4:	68 90 50 80 00       	push   $0x805090
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
  8026b4:	e8 1d 04 00 00       	call   802ad6 <sys_allocate_chunk>
  8026b9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8026bc:	a1 20 61 80 00       	mov    0x806120,%eax
  8026c1:	83 ec 0c             	sub    $0xc,%esp
  8026c4:	50                   	push   %eax
  8026c5:	e8 92 0a 00 00       	call   80315c <initialize_MemBlocksList>
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
  8026f2:	68 b5 50 80 00       	push   $0x8050b5
  8026f7:	6a 33                	push   $0x33
  8026f9:	68 d3 50 80 00       	push   $0x8050d3
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
  802771:	68 e0 50 80 00       	push   $0x8050e0
  802776:	6a 34                	push   $0x34
  802778:	68 d3 50 80 00       	push   $0x8050d3
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
  8027ce:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8027d1:	e8 f7 fd ff ff       	call   8025cd <InitializeUHeap>
	if (size == 0) return NULL ;
  8027d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027da:	75 07                	jne    8027e3 <malloc+0x18>
  8027dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e1:	eb 14                	jmp    8027f7 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8027e3:	83 ec 04             	sub    $0x4,%esp
  8027e6:	68 04 51 80 00       	push   $0x805104
  8027eb:	6a 46                	push   $0x46
  8027ed:	68 d3 50 80 00       	push   $0x8050d3
  8027f2:	e8 98 ed ff ff       	call   80158f <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8027f7:	c9                   	leave  
  8027f8:	c3                   	ret    

008027f9 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8027f9:	55                   	push   %ebp
  8027fa:	89 e5                	mov    %esp,%ebp
  8027fc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8027ff:	83 ec 04             	sub    $0x4,%esp
  802802:	68 2c 51 80 00       	push   $0x80512c
  802807:	6a 61                	push   $0x61
  802809:	68 d3 50 80 00       	push   $0x8050d3
  80280e:	e8 7c ed ff ff       	call   80158f <_panic>

00802813 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802813:	55                   	push   %ebp
  802814:	89 e5                	mov    %esp,%ebp
  802816:	83 ec 38             	sub    $0x38,%esp
  802819:	8b 45 10             	mov    0x10(%ebp),%eax
  80281c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80281f:	e8 a9 fd ff ff       	call   8025cd <InitializeUHeap>
	if (size == 0) return NULL ;
  802824:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802828:	75 07                	jne    802831 <smalloc+0x1e>
  80282a:	b8 00 00 00 00       	mov    $0x0,%eax
  80282f:	eb 7c                	jmp    8028ad <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802831:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802838:	8b 55 0c             	mov    0xc(%ebp),%edx
  80283b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283e:	01 d0                	add    %edx,%eax
  802840:	48                   	dec    %eax
  802841:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802847:	ba 00 00 00 00       	mov    $0x0,%edx
  80284c:	f7 75 f0             	divl   -0x10(%ebp)
  80284f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802852:	29 d0                	sub    %edx,%eax
  802854:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  802857:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80285e:	e8 41 06 00 00       	call   802ea4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802863:	85 c0                	test   %eax,%eax
  802865:	74 11                	je     802878 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  802867:	83 ec 0c             	sub    $0xc,%esp
  80286a:	ff 75 e8             	pushl  -0x18(%ebp)
  80286d:	e8 ac 0c 00 00       	call   80351e <alloc_block_FF>
  802872:	83 c4 10             	add    $0x10,%esp
  802875:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  802878:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287c:	74 2a                	je     8028a8 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 40 08             	mov    0x8(%eax),%eax
  802884:	89 c2                	mov    %eax,%edx
  802886:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80288a:	52                   	push   %edx
  80288b:	50                   	push   %eax
  80288c:	ff 75 0c             	pushl  0xc(%ebp)
  80288f:	ff 75 08             	pushl  0x8(%ebp)
  802892:	e8 92 03 00 00       	call   802c29 <sys_createSharedObject>
  802897:	83 c4 10             	add    $0x10,%esp
  80289a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  80289d:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8028a1:	74 05                	je     8028a8 <smalloc+0x95>
			return (void*)virtual_address;
  8028a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a6:	eb 05                	jmp    8028ad <smalloc+0x9a>
	}
	return NULL;
  8028a8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8028ad:	c9                   	leave  
  8028ae:	c3                   	ret    

008028af <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8028af:	55                   	push   %ebp
  8028b0:	89 e5                	mov    %esp,%ebp
  8028b2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8028b5:	e8 13 fd ff ff       	call   8025cd <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8028ba:	83 ec 04             	sub    $0x4,%esp
  8028bd:	68 50 51 80 00       	push   $0x805150
  8028c2:	68 a2 00 00 00       	push   $0xa2
  8028c7:	68 d3 50 80 00       	push   $0x8050d3
  8028cc:	e8 be ec ff ff       	call   80158f <_panic>

008028d1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8028d1:	55                   	push   %ebp
  8028d2:	89 e5                	mov    %esp,%ebp
  8028d4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8028d7:	e8 f1 fc ff ff       	call   8025cd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8028dc:	83 ec 04             	sub    $0x4,%esp
  8028df:	68 74 51 80 00       	push   $0x805174
  8028e4:	68 e6 00 00 00       	push   $0xe6
  8028e9:	68 d3 50 80 00       	push   $0x8050d3
  8028ee:	e8 9c ec ff ff       	call   80158f <_panic>

008028f3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8028f3:	55                   	push   %ebp
  8028f4:	89 e5                	mov    %esp,%ebp
  8028f6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8028f9:	83 ec 04             	sub    $0x4,%esp
  8028fc:	68 9c 51 80 00       	push   $0x80519c
  802901:	68 fa 00 00 00       	push   $0xfa
  802906:	68 d3 50 80 00       	push   $0x8050d3
  80290b:	e8 7f ec ff ff       	call   80158f <_panic>

00802910 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802910:	55                   	push   %ebp
  802911:	89 e5                	mov    %esp,%ebp
  802913:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802916:	83 ec 04             	sub    $0x4,%esp
  802919:	68 c0 51 80 00       	push   $0x8051c0
  80291e:	68 05 01 00 00       	push   $0x105
  802923:	68 d3 50 80 00       	push   $0x8050d3
  802928:	e8 62 ec ff ff       	call   80158f <_panic>

0080292d <shrink>:

}
void shrink(uint32 newSize)
{
  80292d:	55                   	push   %ebp
  80292e:	89 e5                	mov    %esp,%ebp
  802930:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802933:	83 ec 04             	sub    $0x4,%esp
  802936:	68 c0 51 80 00       	push   $0x8051c0
  80293b:	68 0a 01 00 00       	push   $0x10a
  802940:	68 d3 50 80 00       	push   $0x8050d3
  802945:	e8 45 ec ff ff       	call   80158f <_panic>

0080294a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80294a:	55                   	push   %ebp
  80294b:	89 e5                	mov    %esp,%ebp
  80294d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802950:	83 ec 04             	sub    $0x4,%esp
  802953:	68 c0 51 80 00       	push   $0x8051c0
  802958:	68 0f 01 00 00       	push   $0x10f
  80295d:	68 d3 50 80 00       	push   $0x8050d3
  802962:	e8 28 ec ff ff       	call   80158f <_panic>

00802967 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802967:	55                   	push   %ebp
  802968:	89 e5                	mov    %esp,%ebp
  80296a:	57                   	push   %edi
  80296b:	56                   	push   %esi
  80296c:	53                   	push   %ebx
  80296d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	8b 55 0c             	mov    0xc(%ebp),%edx
  802976:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802979:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80297c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80297f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802982:	cd 30                	int    $0x30
  802984:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802987:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80298a:	83 c4 10             	add    $0x10,%esp
  80298d:	5b                   	pop    %ebx
  80298e:	5e                   	pop    %esi
  80298f:	5f                   	pop    %edi
  802990:	5d                   	pop    %ebp
  802991:	c3                   	ret    

00802992 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802992:	55                   	push   %ebp
  802993:	89 e5                	mov    %esp,%ebp
  802995:	83 ec 04             	sub    $0x4,%esp
  802998:	8b 45 10             	mov    0x10(%ebp),%eax
  80299b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80299e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	6a 00                	push   $0x0
  8029a7:	6a 00                	push   $0x0
  8029a9:	52                   	push   %edx
  8029aa:	ff 75 0c             	pushl  0xc(%ebp)
  8029ad:	50                   	push   %eax
  8029ae:	6a 00                	push   $0x0
  8029b0:	e8 b2 ff ff ff       	call   802967 <syscall>
  8029b5:	83 c4 18             	add    $0x18,%esp
}
  8029b8:	90                   	nop
  8029b9:	c9                   	leave  
  8029ba:	c3                   	ret    

008029bb <sys_cgetc>:

int
sys_cgetc(void)
{
  8029bb:	55                   	push   %ebp
  8029bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8029be:	6a 00                	push   $0x0
  8029c0:	6a 00                	push   $0x0
  8029c2:	6a 00                	push   $0x0
  8029c4:	6a 00                	push   $0x0
  8029c6:	6a 00                	push   $0x0
  8029c8:	6a 01                	push   $0x1
  8029ca:	e8 98 ff ff ff       	call   802967 <syscall>
  8029cf:	83 c4 18             	add    $0x18,%esp
}
  8029d2:	c9                   	leave  
  8029d3:	c3                   	ret    

008029d4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8029d4:	55                   	push   %ebp
  8029d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8029d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	6a 00                	push   $0x0
  8029df:	6a 00                	push   $0x0
  8029e1:	6a 00                	push   $0x0
  8029e3:	52                   	push   %edx
  8029e4:	50                   	push   %eax
  8029e5:	6a 05                	push   $0x5
  8029e7:	e8 7b ff ff ff       	call   802967 <syscall>
  8029ec:	83 c4 18             	add    $0x18,%esp
}
  8029ef:	c9                   	leave  
  8029f0:	c3                   	ret    

008029f1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8029f1:	55                   	push   %ebp
  8029f2:	89 e5                	mov    %esp,%ebp
  8029f4:	56                   	push   %esi
  8029f5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8029f6:	8b 75 18             	mov    0x18(%ebp),%esi
  8029f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8029fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	56                   	push   %esi
  802a06:	53                   	push   %ebx
  802a07:	51                   	push   %ecx
  802a08:	52                   	push   %edx
  802a09:	50                   	push   %eax
  802a0a:	6a 06                	push   $0x6
  802a0c:	e8 56 ff ff ff       	call   802967 <syscall>
  802a11:	83 c4 18             	add    $0x18,%esp
}
  802a14:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a17:	5b                   	pop    %ebx
  802a18:	5e                   	pop    %esi
  802a19:	5d                   	pop    %ebp
  802a1a:	c3                   	ret    

00802a1b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802a1b:	55                   	push   %ebp
  802a1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	6a 00                	push   $0x0
  802a26:	6a 00                	push   $0x0
  802a28:	6a 00                	push   $0x0
  802a2a:	52                   	push   %edx
  802a2b:	50                   	push   %eax
  802a2c:	6a 07                	push   $0x7
  802a2e:	e8 34 ff ff ff       	call   802967 <syscall>
  802a33:	83 c4 18             	add    $0x18,%esp
}
  802a36:	c9                   	leave  
  802a37:	c3                   	ret    

00802a38 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802a38:	55                   	push   %ebp
  802a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802a3b:	6a 00                	push   $0x0
  802a3d:	6a 00                	push   $0x0
  802a3f:	6a 00                	push   $0x0
  802a41:	ff 75 0c             	pushl  0xc(%ebp)
  802a44:	ff 75 08             	pushl  0x8(%ebp)
  802a47:	6a 08                	push   $0x8
  802a49:	e8 19 ff ff ff       	call   802967 <syscall>
  802a4e:	83 c4 18             	add    $0x18,%esp
}
  802a51:	c9                   	leave  
  802a52:	c3                   	ret    

00802a53 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802a53:	55                   	push   %ebp
  802a54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802a56:	6a 00                	push   $0x0
  802a58:	6a 00                	push   $0x0
  802a5a:	6a 00                	push   $0x0
  802a5c:	6a 00                	push   $0x0
  802a5e:	6a 00                	push   $0x0
  802a60:	6a 09                	push   $0x9
  802a62:	e8 00 ff ff ff       	call   802967 <syscall>
  802a67:	83 c4 18             	add    $0x18,%esp
}
  802a6a:	c9                   	leave  
  802a6b:	c3                   	ret    

00802a6c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802a6c:	55                   	push   %ebp
  802a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802a6f:	6a 00                	push   $0x0
  802a71:	6a 00                	push   $0x0
  802a73:	6a 00                	push   $0x0
  802a75:	6a 00                	push   $0x0
  802a77:	6a 00                	push   $0x0
  802a79:	6a 0a                	push   $0xa
  802a7b:	e8 e7 fe ff ff       	call   802967 <syscall>
  802a80:	83 c4 18             	add    $0x18,%esp
}
  802a83:	c9                   	leave  
  802a84:	c3                   	ret    

00802a85 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802a85:	55                   	push   %ebp
  802a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802a88:	6a 00                	push   $0x0
  802a8a:	6a 00                	push   $0x0
  802a8c:	6a 00                	push   $0x0
  802a8e:	6a 00                	push   $0x0
  802a90:	6a 00                	push   $0x0
  802a92:	6a 0b                	push   $0xb
  802a94:	e8 ce fe ff ff       	call   802967 <syscall>
  802a99:	83 c4 18             	add    $0x18,%esp
}
  802a9c:	c9                   	leave  
  802a9d:	c3                   	ret    

00802a9e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802a9e:	55                   	push   %ebp
  802a9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802aa1:	6a 00                	push   $0x0
  802aa3:	6a 00                	push   $0x0
  802aa5:	6a 00                	push   $0x0
  802aa7:	ff 75 0c             	pushl  0xc(%ebp)
  802aaa:	ff 75 08             	pushl  0x8(%ebp)
  802aad:	6a 0f                	push   $0xf
  802aaf:	e8 b3 fe ff ff       	call   802967 <syscall>
  802ab4:	83 c4 18             	add    $0x18,%esp
	return;
  802ab7:	90                   	nop
}
  802ab8:	c9                   	leave  
  802ab9:	c3                   	ret    

00802aba <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802aba:	55                   	push   %ebp
  802abb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802abd:	6a 00                	push   $0x0
  802abf:	6a 00                	push   $0x0
  802ac1:	6a 00                	push   $0x0
  802ac3:	ff 75 0c             	pushl  0xc(%ebp)
  802ac6:	ff 75 08             	pushl  0x8(%ebp)
  802ac9:	6a 10                	push   $0x10
  802acb:	e8 97 fe ff ff       	call   802967 <syscall>
  802ad0:	83 c4 18             	add    $0x18,%esp
	return ;
  802ad3:	90                   	nop
}
  802ad4:	c9                   	leave  
  802ad5:	c3                   	ret    

00802ad6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802ad6:	55                   	push   %ebp
  802ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802ad9:	6a 00                	push   $0x0
  802adb:	6a 00                	push   $0x0
  802add:	ff 75 10             	pushl  0x10(%ebp)
  802ae0:	ff 75 0c             	pushl  0xc(%ebp)
  802ae3:	ff 75 08             	pushl  0x8(%ebp)
  802ae6:	6a 11                	push   $0x11
  802ae8:	e8 7a fe ff ff       	call   802967 <syscall>
  802aed:	83 c4 18             	add    $0x18,%esp
	return ;
  802af0:	90                   	nop
}
  802af1:	c9                   	leave  
  802af2:	c3                   	ret    

00802af3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802af3:	55                   	push   %ebp
  802af4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802af6:	6a 00                	push   $0x0
  802af8:	6a 00                	push   $0x0
  802afa:	6a 00                	push   $0x0
  802afc:	6a 00                	push   $0x0
  802afe:	6a 00                	push   $0x0
  802b00:	6a 0c                	push   $0xc
  802b02:	e8 60 fe ff ff       	call   802967 <syscall>
  802b07:	83 c4 18             	add    $0x18,%esp
}
  802b0a:	c9                   	leave  
  802b0b:	c3                   	ret    

00802b0c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802b0c:	55                   	push   %ebp
  802b0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802b0f:	6a 00                	push   $0x0
  802b11:	6a 00                	push   $0x0
  802b13:	6a 00                	push   $0x0
  802b15:	6a 00                	push   $0x0
  802b17:	ff 75 08             	pushl  0x8(%ebp)
  802b1a:	6a 0d                	push   $0xd
  802b1c:	e8 46 fe ff ff       	call   802967 <syscall>
  802b21:	83 c4 18             	add    $0x18,%esp
}
  802b24:	c9                   	leave  
  802b25:	c3                   	ret    

00802b26 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802b26:	55                   	push   %ebp
  802b27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802b29:	6a 00                	push   $0x0
  802b2b:	6a 00                	push   $0x0
  802b2d:	6a 00                	push   $0x0
  802b2f:	6a 00                	push   $0x0
  802b31:	6a 00                	push   $0x0
  802b33:	6a 0e                	push   $0xe
  802b35:	e8 2d fe ff ff       	call   802967 <syscall>
  802b3a:	83 c4 18             	add    $0x18,%esp
}
  802b3d:	90                   	nop
  802b3e:	c9                   	leave  
  802b3f:	c3                   	ret    

00802b40 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802b40:	55                   	push   %ebp
  802b41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802b43:	6a 00                	push   $0x0
  802b45:	6a 00                	push   $0x0
  802b47:	6a 00                	push   $0x0
  802b49:	6a 00                	push   $0x0
  802b4b:	6a 00                	push   $0x0
  802b4d:	6a 13                	push   $0x13
  802b4f:	e8 13 fe ff ff       	call   802967 <syscall>
  802b54:	83 c4 18             	add    $0x18,%esp
}
  802b57:	90                   	nop
  802b58:	c9                   	leave  
  802b59:	c3                   	ret    

00802b5a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802b5a:	55                   	push   %ebp
  802b5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 00                	push   $0x0
  802b61:	6a 00                	push   $0x0
  802b63:	6a 00                	push   $0x0
  802b65:	6a 00                	push   $0x0
  802b67:	6a 14                	push   $0x14
  802b69:	e8 f9 fd ff ff       	call   802967 <syscall>
  802b6e:	83 c4 18             	add    $0x18,%esp
}
  802b71:	90                   	nop
  802b72:	c9                   	leave  
  802b73:	c3                   	ret    

00802b74 <sys_cputc>:


void
sys_cputc(const char c)
{
  802b74:	55                   	push   %ebp
  802b75:	89 e5                	mov    %esp,%ebp
  802b77:	83 ec 04             	sub    $0x4,%esp
  802b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802b80:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b84:	6a 00                	push   $0x0
  802b86:	6a 00                	push   $0x0
  802b88:	6a 00                	push   $0x0
  802b8a:	6a 00                	push   $0x0
  802b8c:	50                   	push   %eax
  802b8d:	6a 15                	push   $0x15
  802b8f:	e8 d3 fd ff ff       	call   802967 <syscall>
  802b94:	83 c4 18             	add    $0x18,%esp
}
  802b97:	90                   	nop
  802b98:	c9                   	leave  
  802b99:	c3                   	ret    

00802b9a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802b9a:	55                   	push   %ebp
  802b9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802b9d:	6a 00                	push   $0x0
  802b9f:	6a 00                	push   $0x0
  802ba1:	6a 00                	push   $0x0
  802ba3:	6a 00                	push   $0x0
  802ba5:	6a 00                	push   $0x0
  802ba7:	6a 16                	push   $0x16
  802ba9:	e8 b9 fd ff ff       	call   802967 <syscall>
  802bae:	83 c4 18             	add    $0x18,%esp
}
  802bb1:	90                   	nop
  802bb2:	c9                   	leave  
  802bb3:	c3                   	ret    

00802bb4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802bb4:	55                   	push   %ebp
  802bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bba:	6a 00                	push   $0x0
  802bbc:	6a 00                	push   $0x0
  802bbe:	6a 00                	push   $0x0
  802bc0:	ff 75 0c             	pushl  0xc(%ebp)
  802bc3:	50                   	push   %eax
  802bc4:	6a 17                	push   $0x17
  802bc6:	e8 9c fd ff ff       	call   802967 <syscall>
  802bcb:	83 c4 18             	add    $0x18,%esp
}
  802bce:	c9                   	leave  
  802bcf:	c3                   	ret    

00802bd0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802bd0:	55                   	push   %ebp
  802bd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	6a 00                	push   $0x0
  802bdb:	6a 00                	push   $0x0
  802bdd:	6a 00                	push   $0x0
  802bdf:	52                   	push   %edx
  802be0:	50                   	push   %eax
  802be1:	6a 1a                	push   $0x1a
  802be3:	e8 7f fd ff ff       	call   802967 <syscall>
  802be8:	83 c4 18             	add    $0x18,%esp
}
  802beb:	c9                   	leave  
  802bec:	c3                   	ret    

00802bed <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802bed:	55                   	push   %ebp
  802bee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802bf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	6a 00                	push   $0x0
  802bf8:	6a 00                	push   $0x0
  802bfa:	6a 00                	push   $0x0
  802bfc:	52                   	push   %edx
  802bfd:	50                   	push   %eax
  802bfe:	6a 18                	push   $0x18
  802c00:	e8 62 fd ff ff       	call   802967 <syscall>
  802c05:	83 c4 18             	add    $0x18,%esp
}
  802c08:	90                   	nop
  802c09:	c9                   	leave  
  802c0a:	c3                   	ret    

00802c0b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802c0b:	55                   	push   %ebp
  802c0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	6a 00                	push   $0x0
  802c16:	6a 00                	push   $0x0
  802c18:	6a 00                	push   $0x0
  802c1a:	52                   	push   %edx
  802c1b:	50                   	push   %eax
  802c1c:	6a 19                	push   $0x19
  802c1e:	e8 44 fd ff ff       	call   802967 <syscall>
  802c23:	83 c4 18             	add    $0x18,%esp
}
  802c26:	90                   	nop
  802c27:	c9                   	leave  
  802c28:	c3                   	ret    

00802c29 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802c29:	55                   	push   %ebp
  802c2a:	89 e5                	mov    %esp,%ebp
  802c2c:	83 ec 04             	sub    $0x4,%esp
  802c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  802c32:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802c35:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c38:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	6a 00                	push   $0x0
  802c41:	51                   	push   %ecx
  802c42:	52                   	push   %edx
  802c43:	ff 75 0c             	pushl  0xc(%ebp)
  802c46:	50                   	push   %eax
  802c47:	6a 1b                	push   $0x1b
  802c49:	e8 19 fd ff ff       	call   802967 <syscall>
  802c4e:	83 c4 18             	add    $0x18,%esp
}
  802c51:	c9                   	leave  
  802c52:	c3                   	ret    

00802c53 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802c53:	55                   	push   %ebp
  802c54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802c56:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	6a 00                	push   $0x0
  802c5e:	6a 00                	push   $0x0
  802c60:	6a 00                	push   $0x0
  802c62:	52                   	push   %edx
  802c63:	50                   	push   %eax
  802c64:	6a 1c                	push   $0x1c
  802c66:	e8 fc fc ff ff       	call   802967 <syscall>
  802c6b:	83 c4 18             	add    $0x18,%esp
}
  802c6e:	c9                   	leave  
  802c6f:	c3                   	ret    

00802c70 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802c70:	55                   	push   %ebp
  802c71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802c73:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	6a 00                	push   $0x0
  802c7e:	6a 00                	push   $0x0
  802c80:	51                   	push   %ecx
  802c81:	52                   	push   %edx
  802c82:	50                   	push   %eax
  802c83:	6a 1d                	push   $0x1d
  802c85:	e8 dd fc ff ff       	call   802967 <syscall>
  802c8a:	83 c4 18             	add    $0x18,%esp
}
  802c8d:	c9                   	leave  
  802c8e:	c3                   	ret    

00802c8f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802c8f:	55                   	push   %ebp
  802c90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802c92:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c95:	8b 45 08             	mov    0x8(%ebp),%eax
  802c98:	6a 00                	push   $0x0
  802c9a:	6a 00                	push   $0x0
  802c9c:	6a 00                	push   $0x0
  802c9e:	52                   	push   %edx
  802c9f:	50                   	push   %eax
  802ca0:	6a 1e                	push   $0x1e
  802ca2:	e8 c0 fc ff ff       	call   802967 <syscall>
  802ca7:	83 c4 18             	add    $0x18,%esp
}
  802caa:	c9                   	leave  
  802cab:	c3                   	ret    

00802cac <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802cac:	55                   	push   %ebp
  802cad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802caf:	6a 00                	push   $0x0
  802cb1:	6a 00                	push   $0x0
  802cb3:	6a 00                	push   $0x0
  802cb5:	6a 00                	push   $0x0
  802cb7:	6a 00                	push   $0x0
  802cb9:	6a 1f                	push   $0x1f
  802cbb:	e8 a7 fc ff ff       	call   802967 <syscall>
  802cc0:	83 c4 18             	add    $0x18,%esp
}
  802cc3:	c9                   	leave  
  802cc4:	c3                   	ret    

00802cc5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802cc5:	55                   	push   %ebp
  802cc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccb:	6a 00                	push   $0x0
  802ccd:	ff 75 14             	pushl  0x14(%ebp)
  802cd0:	ff 75 10             	pushl  0x10(%ebp)
  802cd3:	ff 75 0c             	pushl  0xc(%ebp)
  802cd6:	50                   	push   %eax
  802cd7:	6a 20                	push   $0x20
  802cd9:	e8 89 fc ff ff       	call   802967 <syscall>
  802cde:	83 c4 18             	add    $0x18,%esp
}
  802ce1:	c9                   	leave  
  802ce2:	c3                   	ret    

00802ce3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802ce3:	55                   	push   %ebp
  802ce4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce9:	6a 00                	push   $0x0
  802ceb:	6a 00                	push   $0x0
  802ced:	6a 00                	push   $0x0
  802cef:	6a 00                	push   $0x0
  802cf1:	50                   	push   %eax
  802cf2:	6a 21                	push   $0x21
  802cf4:	e8 6e fc ff ff       	call   802967 <syscall>
  802cf9:	83 c4 18             	add    $0x18,%esp
}
  802cfc:	90                   	nop
  802cfd:	c9                   	leave  
  802cfe:	c3                   	ret    

00802cff <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802cff:	55                   	push   %ebp
  802d00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	6a 00                	push   $0x0
  802d07:	6a 00                	push   $0x0
  802d09:	6a 00                	push   $0x0
  802d0b:	6a 00                	push   $0x0
  802d0d:	50                   	push   %eax
  802d0e:	6a 22                	push   $0x22
  802d10:	e8 52 fc ff ff       	call   802967 <syscall>
  802d15:	83 c4 18             	add    $0x18,%esp
}
  802d18:	c9                   	leave  
  802d19:	c3                   	ret    

00802d1a <sys_getenvid>:

int32 sys_getenvid(void)
{
  802d1a:	55                   	push   %ebp
  802d1b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802d1d:	6a 00                	push   $0x0
  802d1f:	6a 00                	push   $0x0
  802d21:	6a 00                	push   $0x0
  802d23:	6a 00                	push   $0x0
  802d25:	6a 00                	push   $0x0
  802d27:	6a 02                	push   $0x2
  802d29:	e8 39 fc ff ff       	call   802967 <syscall>
  802d2e:	83 c4 18             	add    $0x18,%esp
}
  802d31:	c9                   	leave  
  802d32:	c3                   	ret    

00802d33 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802d33:	55                   	push   %ebp
  802d34:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802d36:	6a 00                	push   $0x0
  802d38:	6a 00                	push   $0x0
  802d3a:	6a 00                	push   $0x0
  802d3c:	6a 00                	push   $0x0
  802d3e:	6a 00                	push   $0x0
  802d40:	6a 03                	push   $0x3
  802d42:	e8 20 fc ff ff       	call   802967 <syscall>
  802d47:	83 c4 18             	add    $0x18,%esp
}
  802d4a:	c9                   	leave  
  802d4b:	c3                   	ret    

00802d4c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802d4c:	55                   	push   %ebp
  802d4d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802d4f:	6a 00                	push   $0x0
  802d51:	6a 00                	push   $0x0
  802d53:	6a 00                	push   $0x0
  802d55:	6a 00                	push   $0x0
  802d57:	6a 00                	push   $0x0
  802d59:	6a 04                	push   $0x4
  802d5b:	e8 07 fc ff ff       	call   802967 <syscall>
  802d60:	83 c4 18             	add    $0x18,%esp
}
  802d63:	c9                   	leave  
  802d64:	c3                   	ret    

00802d65 <sys_exit_env>:


void sys_exit_env(void)
{
  802d65:	55                   	push   %ebp
  802d66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802d68:	6a 00                	push   $0x0
  802d6a:	6a 00                	push   $0x0
  802d6c:	6a 00                	push   $0x0
  802d6e:	6a 00                	push   $0x0
  802d70:	6a 00                	push   $0x0
  802d72:	6a 23                	push   $0x23
  802d74:	e8 ee fb ff ff       	call   802967 <syscall>
  802d79:	83 c4 18             	add    $0x18,%esp
}
  802d7c:	90                   	nop
  802d7d:	c9                   	leave  
  802d7e:	c3                   	ret    

00802d7f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802d7f:	55                   	push   %ebp
  802d80:	89 e5                	mov    %esp,%ebp
  802d82:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802d85:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802d88:	8d 50 04             	lea    0x4(%eax),%edx
  802d8b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802d8e:	6a 00                	push   $0x0
  802d90:	6a 00                	push   $0x0
  802d92:	6a 00                	push   $0x0
  802d94:	52                   	push   %edx
  802d95:	50                   	push   %eax
  802d96:	6a 24                	push   $0x24
  802d98:	e8 ca fb ff ff       	call   802967 <syscall>
  802d9d:	83 c4 18             	add    $0x18,%esp
	return result;
  802da0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802da3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802da6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802da9:	89 01                	mov    %eax,(%ecx)
  802dab:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	c9                   	leave  
  802db2:	c2 04 00             	ret    $0x4

00802db5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802db5:	55                   	push   %ebp
  802db6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802db8:	6a 00                	push   $0x0
  802dba:	6a 00                	push   $0x0
  802dbc:	ff 75 10             	pushl  0x10(%ebp)
  802dbf:	ff 75 0c             	pushl  0xc(%ebp)
  802dc2:	ff 75 08             	pushl  0x8(%ebp)
  802dc5:	6a 12                	push   $0x12
  802dc7:	e8 9b fb ff ff       	call   802967 <syscall>
  802dcc:	83 c4 18             	add    $0x18,%esp
	return ;
  802dcf:	90                   	nop
}
  802dd0:	c9                   	leave  
  802dd1:	c3                   	ret    

00802dd2 <sys_rcr2>:
uint32 sys_rcr2()
{
  802dd2:	55                   	push   %ebp
  802dd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802dd5:	6a 00                	push   $0x0
  802dd7:	6a 00                	push   $0x0
  802dd9:	6a 00                	push   $0x0
  802ddb:	6a 00                	push   $0x0
  802ddd:	6a 00                	push   $0x0
  802ddf:	6a 25                	push   $0x25
  802de1:	e8 81 fb ff ff       	call   802967 <syscall>
  802de6:	83 c4 18             	add    $0x18,%esp
}
  802de9:	c9                   	leave  
  802dea:	c3                   	ret    

00802deb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802deb:	55                   	push   %ebp
  802dec:	89 e5                	mov    %esp,%ebp
  802dee:	83 ec 04             	sub    $0x4,%esp
  802df1:	8b 45 08             	mov    0x8(%ebp),%eax
  802df4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802df7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802dfb:	6a 00                	push   $0x0
  802dfd:	6a 00                	push   $0x0
  802dff:	6a 00                	push   $0x0
  802e01:	6a 00                	push   $0x0
  802e03:	50                   	push   %eax
  802e04:	6a 26                	push   $0x26
  802e06:	e8 5c fb ff ff       	call   802967 <syscall>
  802e0b:	83 c4 18             	add    $0x18,%esp
	return ;
  802e0e:	90                   	nop
}
  802e0f:	c9                   	leave  
  802e10:	c3                   	ret    

00802e11 <rsttst>:
void rsttst()
{
  802e11:	55                   	push   %ebp
  802e12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802e14:	6a 00                	push   $0x0
  802e16:	6a 00                	push   $0x0
  802e18:	6a 00                	push   $0x0
  802e1a:	6a 00                	push   $0x0
  802e1c:	6a 00                	push   $0x0
  802e1e:	6a 28                	push   $0x28
  802e20:	e8 42 fb ff ff       	call   802967 <syscall>
  802e25:	83 c4 18             	add    $0x18,%esp
	return ;
  802e28:	90                   	nop
}
  802e29:	c9                   	leave  
  802e2a:	c3                   	ret    

00802e2b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802e2b:	55                   	push   %ebp
  802e2c:	89 e5                	mov    %esp,%ebp
  802e2e:	83 ec 04             	sub    $0x4,%esp
  802e31:	8b 45 14             	mov    0x14(%ebp),%eax
  802e34:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802e37:	8b 55 18             	mov    0x18(%ebp),%edx
  802e3a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802e3e:	52                   	push   %edx
  802e3f:	50                   	push   %eax
  802e40:	ff 75 10             	pushl  0x10(%ebp)
  802e43:	ff 75 0c             	pushl  0xc(%ebp)
  802e46:	ff 75 08             	pushl  0x8(%ebp)
  802e49:	6a 27                	push   $0x27
  802e4b:	e8 17 fb ff ff       	call   802967 <syscall>
  802e50:	83 c4 18             	add    $0x18,%esp
	return ;
  802e53:	90                   	nop
}
  802e54:	c9                   	leave  
  802e55:	c3                   	ret    

00802e56 <chktst>:
void chktst(uint32 n)
{
  802e56:	55                   	push   %ebp
  802e57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802e59:	6a 00                	push   $0x0
  802e5b:	6a 00                	push   $0x0
  802e5d:	6a 00                	push   $0x0
  802e5f:	6a 00                	push   $0x0
  802e61:	ff 75 08             	pushl  0x8(%ebp)
  802e64:	6a 29                	push   $0x29
  802e66:	e8 fc fa ff ff       	call   802967 <syscall>
  802e6b:	83 c4 18             	add    $0x18,%esp
	return ;
  802e6e:	90                   	nop
}
  802e6f:	c9                   	leave  
  802e70:	c3                   	ret    

00802e71 <inctst>:

void inctst()
{
  802e71:	55                   	push   %ebp
  802e72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802e74:	6a 00                	push   $0x0
  802e76:	6a 00                	push   $0x0
  802e78:	6a 00                	push   $0x0
  802e7a:	6a 00                	push   $0x0
  802e7c:	6a 00                	push   $0x0
  802e7e:	6a 2a                	push   $0x2a
  802e80:	e8 e2 fa ff ff       	call   802967 <syscall>
  802e85:	83 c4 18             	add    $0x18,%esp
	return ;
  802e88:	90                   	nop
}
  802e89:	c9                   	leave  
  802e8a:	c3                   	ret    

00802e8b <gettst>:
uint32 gettst()
{
  802e8b:	55                   	push   %ebp
  802e8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802e8e:	6a 00                	push   $0x0
  802e90:	6a 00                	push   $0x0
  802e92:	6a 00                	push   $0x0
  802e94:	6a 00                	push   $0x0
  802e96:	6a 00                	push   $0x0
  802e98:	6a 2b                	push   $0x2b
  802e9a:	e8 c8 fa ff ff       	call   802967 <syscall>
  802e9f:	83 c4 18             	add    $0x18,%esp
}
  802ea2:	c9                   	leave  
  802ea3:	c3                   	ret    

00802ea4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802ea4:	55                   	push   %ebp
  802ea5:	89 e5                	mov    %esp,%ebp
  802ea7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802eaa:	6a 00                	push   $0x0
  802eac:	6a 00                	push   $0x0
  802eae:	6a 00                	push   $0x0
  802eb0:	6a 00                	push   $0x0
  802eb2:	6a 00                	push   $0x0
  802eb4:	6a 2c                	push   $0x2c
  802eb6:	e8 ac fa ff ff       	call   802967 <syscall>
  802ebb:	83 c4 18             	add    $0x18,%esp
  802ebe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802ec1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802ec5:	75 07                	jne    802ece <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802ec7:	b8 01 00 00 00       	mov    $0x1,%eax
  802ecc:	eb 05                	jmp    802ed3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802ece:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ed3:	c9                   	leave  
  802ed4:	c3                   	ret    

00802ed5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802ed5:	55                   	push   %ebp
  802ed6:	89 e5                	mov    %esp,%ebp
  802ed8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802edb:	6a 00                	push   $0x0
  802edd:	6a 00                	push   $0x0
  802edf:	6a 00                	push   $0x0
  802ee1:	6a 00                	push   $0x0
  802ee3:	6a 00                	push   $0x0
  802ee5:	6a 2c                	push   $0x2c
  802ee7:	e8 7b fa ff ff       	call   802967 <syscall>
  802eec:	83 c4 18             	add    $0x18,%esp
  802eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802ef2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802ef6:	75 07                	jne    802eff <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802ef8:	b8 01 00 00 00       	mov    $0x1,%eax
  802efd:	eb 05                	jmp    802f04 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802eff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f04:	c9                   	leave  
  802f05:	c3                   	ret    

00802f06 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802f06:	55                   	push   %ebp
  802f07:	89 e5                	mov    %esp,%ebp
  802f09:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f0c:	6a 00                	push   $0x0
  802f0e:	6a 00                	push   $0x0
  802f10:	6a 00                	push   $0x0
  802f12:	6a 00                	push   $0x0
  802f14:	6a 00                	push   $0x0
  802f16:	6a 2c                	push   $0x2c
  802f18:	e8 4a fa ff ff       	call   802967 <syscall>
  802f1d:	83 c4 18             	add    $0x18,%esp
  802f20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802f23:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802f27:	75 07                	jne    802f30 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802f29:	b8 01 00 00 00       	mov    $0x1,%eax
  802f2e:	eb 05                	jmp    802f35 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802f30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f35:	c9                   	leave  
  802f36:	c3                   	ret    

00802f37 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802f37:	55                   	push   %ebp
  802f38:	89 e5                	mov    %esp,%ebp
  802f3a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f3d:	6a 00                	push   $0x0
  802f3f:	6a 00                	push   $0x0
  802f41:	6a 00                	push   $0x0
  802f43:	6a 00                	push   $0x0
  802f45:	6a 00                	push   $0x0
  802f47:	6a 2c                	push   $0x2c
  802f49:	e8 19 fa ff ff       	call   802967 <syscall>
  802f4e:	83 c4 18             	add    $0x18,%esp
  802f51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802f54:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802f58:	75 07                	jne    802f61 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802f5a:	b8 01 00 00 00       	mov    $0x1,%eax
  802f5f:	eb 05                	jmp    802f66 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802f61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f66:	c9                   	leave  
  802f67:	c3                   	ret    

00802f68 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802f68:	55                   	push   %ebp
  802f69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802f6b:	6a 00                	push   $0x0
  802f6d:	6a 00                	push   $0x0
  802f6f:	6a 00                	push   $0x0
  802f71:	6a 00                	push   $0x0
  802f73:	ff 75 08             	pushl  0x8(%ebp)
  802f76:	6a 2d                	push   $0x2d
  802f78:	e8 ea f9 ff ff       	call   802967 <syscall>
  802f7d:	83 c4 18             	add    $0x18,%esp
	return ;
  802f80:	90                   	nop
}
  802f81:	c9                   	leave  
  802f82:	c3                   	ret    

00802f83 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802f83:	55                   	push   %ebp
  802f84:	89 e5                	mov    %esp,%ebp
  802f86:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802f87:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	6a 00                	push   $0x0
  802f95:	53                   	push   %ebx
  802f96:	51                   	push   %ecx
  802f97:	52                   	push   %edx
  802f98:	50                   	push   %eax
  802f99:	6a 2e                	push   $0x2e
  802f9b:	e8 c7 f9 ff ff       	call   802967 <syscall>
  802fa0:	83 c4 18             	add    $0x18,%esp
}
  802fa3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fa6:	c9                   	leave  
  802fa7:	c3                   	ret    

00802fa8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802fa8:	55                   	push   %ebp
  802fa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802fab:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fae:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb1:	6a 00                	push   $0x0
  802fb3:	6a 00                	push   $0x0
  802fb5:	6a 00                	push   $0x0
  802fb7:	52                   	push   %edx
  802fb8:	50                   	push   %eax
  802fb9:	6a 2f                	push   $0x2f
  802fbb:	e8 a7 f9 ff ff       	call   802967 <syscall>
  802fc0:	83 c4 18             	add    $0x18,%esp
}
  802fc3:	c9                   	leave  
  802fc4:	c3                   	ret    

00802fc5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802fc5:	55                   	push   %ebp
  802fc6:	89 e5                	mov    %esp,%ebp
  802fc8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802fcb:	83 ec 0c             	sub    $0xc,%esp
  802fce:	68 d0 51 80 00       	push   $0x8051d0
  802fd3:	e8 6b e8 ff ff       	call   801843 <cprintf>
  802fd8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802fdb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802fe2:	83 ec 0c             	sub    $0xc,%esp
  802fe5:	68 fc 51 80 00       	push   $0x8051fc
  802fea:	e8 54 e8 ff ff       	call   801843 <cprintf>
  802fef:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802ff2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ff6:	a1 38 61 80 00       	mov    0x806138,%eax
  802ffb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ffe:	eb 56                	jmp    803056 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803000:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803004:	74 1c                	je     803022 <print_mem_block_lists+0x5d>
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	8b 50 08             	mov    0x8(%eax),%edx
  80300c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300f:	8b 48 08             	mov    0x8(%eax),%ecx
  803012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803015:	8b 40 0c             	mov    0xc(%eax),%eax
  803018:	01 c8                	add    %ecx,%eax
  80301a:	39 c2                	cmp    %eax,%edx
  80301c:	73 04                	jae    803022 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80301e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803025:	8b 50 08             	mov    0x8(%eax),%edx
  803028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302b:	8b 40 0c             	mov    0xc(%eax),%eax
  80302e:	01 c2                	add    %eax,%edx
  803030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803033:	8b 40 08             	mov    0x8(%eax),%eax
  803036:	83 ec 04             	sub    $0x4,%esp
  803039:	52                   	push   %edx
  80303a:	50                   	push   %eax
  80303b:	68 11 52 80 00       	push   $0x805211
  803040:	e8 fe e7 ff ff       	call   801843 <cprintf>
  803045:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80304e:	a1 40 61 80 00       	mov    0x806140,%eax
  803053:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803056:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305a:	74 07                	je     803063 <print_mem_block_lists+0x9e>
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	8b 00                	mov    (%eax),%eax
  803061:	eb 05                	jmp    803068 <print_mem_block_lists+0xa3>
  803063:	b8 00 00 00 00       	mov    $0x0,%eax
  803068:	a3 40 61 80 00       	mov    %eax,0x806140
  80306d:	a1 40 61 80 00       	mov    0x806140,%eax
  803072:	85 c0                	test   %eax,%eax
  803074:	75 8a                	jne    803000 <print_mem_block_lists+0x3b>
  803076:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307a:	75 84                	jne    803000 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80307c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803080:	75 10                	jne    803092 <print_mem_block_lists+0xcd>
  803082:	83 ec 0c             	sub    $0xc,%esp
  803085:	68 20 52 80 00       	push   $0x805220
  80308a:	e8 b4 e7 ff ff       	call   801843 <cprintf>
  80308f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  803092:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  803099:	83 ec 0c             	sub    $0xc,%esp
  80309c:	68 44 52 80 00       	push   $0x805244
  8030a1:	e8 9d e7 ff ff       	call   801843 <cprintf>
  8030a6:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8030a9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8030ad:	a1 40 60 80 00       	mov    0x806040,%eax
  8030b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030b5:	eb 56                	jmp    80310d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8030b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030bb:	74 1c                	je     8030d9 <print_mem_block_lists+0x114>
  8030bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c0:	8b 50 08             	mov    0x8(%eax),%edx
  8030c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c6:	8b 48 08             	mov    0x8(%eax),%ecx
  8030c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cf:	01 c8                	add    %ecx,%eax
  8030d1:	39 c2                	cmp    %eax,%edx
  8030d3:	73 04                	jae    8030d9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8030d5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	8b 50 08             	mov    0x8(%eax),%edx
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e5:	01 c2                	add    %eax,%edx
  8030e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ea:	8b 40 08             	mov    0x8(%eax),%eax
  8030ed:	83 ec 04             	sub    $0x4,%esp
  8030f0:	52                   	push   %edx
  8030f1:	50                   	push   %eax
  8030f2:	68 11 52 80 00       	push   $0x805211
  8030f7:	e8 47 e7 ff ff       	call   801843 <cprintf>
  8030fc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803105:	a1 48 60 80 00       	mov    0x806048,%eax
  80310a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80310d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803111:	74 07                	je     80311a <print_mem_block_lists+0x155>
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	8b 00                	mov    (%eax),%eax
  803118:	eb 05                	jmp    80311f <print_mem_block_lists+0x15a>
  80311a:	b8 00 00 00 00       	mov    $0x0,%eax
  80311f:	a3 48 60 80 00       	mov    %eax,0x806048
  803124:	a1 48 60 80 00       	mov    0x806048,%eax
  803129:	85 c0                	test   %eax,%eax
  80312b:	75 8a                	jne    8030b7 <print_mem_block_lists+0xf2>
  80312d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803131:	75 84                	jne    8030b7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  803133:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803137:	75 10                	jne    803149 <print_mem_block_lists+0x184>
  803139:	83 ec 0c             	sub    $0xc,%esp
  80313c:	68 5c 52 80 00       	push   $0x80525c
  803141:	e8 fd e6 ff ff       	call   801843 <cprintf>
  803146:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803149:	83 ec 0c             	sub    $0xc,%esp
  80314c:	68 d0 51 80 00       	push   $0x8051d0
  803151:	e8 ed e6 ff ff       	call   801843 <cprintf>
  803156:	83 c4 10             	add    $0x10,%esp

}
  803159:	90                   	nop
  80315a:	c9                   	leave  
  80315b:	c3                   	ret    

0080315c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80315c:	55                   	push   %ebp
  80315d:	89 e5                	mov    %esp,%ebp
  80315f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  803162:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  803169:	00 00 00 
  80316c:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  803173:	00 00 00 
  803176:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  80317d:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  803180:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803187:	e9 9e 00 00 00       	jmp    80322a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80318c:	a1 50 60 80 00       	mov    0x806050,%eax
  803191:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803194:	c1 e2 04             	shl    $0x4,%edx
  803197:	01 d0                	add    %edx,%eax
  803199:	85 c0                	test   %eax,%eax
  80319b:	75 14                	jne    8031b1 <initialize_MemBlocksList+0x55>
  80319d:	83 ec 04             	sub    $0x4,%esp
  8031a0:	68 84 52 80 00       	push   $0x805284
  8031a5:	6a 46                	push   $0x46
  8031a7:	68 a7 52 80 00       	push   $0x8052a7
  8031ac:	e8 de e3 ff ff       	call   80158f <_panic>
  8031b1:	a1 50 60 80 00       	mov    0x806050,%eax
  8031b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031b9:	c1 e2 04             	shl    $0x4,%edx
  8031bc:	01 d0                	add    %edx,%eax
  8031be:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8031c4:	89 10                	mov    %edx,(%eax)
  8031c6:	8b 00                	mov    (%eax),%eax
  8031c8:	85 c0                	test   %eax,%eax
  8031ca:	74 18                	je     8031e4 <initialize_MemBlocksList+0x88>
  8031cc:	a1 48 61 80 00       	mov    0x806148,%eax
  8031d1:	8b 15 50 60 80 00    	mov    0x806050,%edx
  8031d7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8031da:	c1 e1 04             	shl    $0x4,%ecx
  8031dd:	01 ca                	add    %ecx,%edx
  8031df:	89 50 04             	mov    %edx,0x4(%eax)
  8031e2:	eb 12                	jmp    8031f6 <initialize_MemBlocksList+0x9a>
  8031e4:	a1 50 60 80 00       	mov    0x806050,%eax
  8031e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031ec:	c1 e2 04             	shl    $0x4,%edx
  8031ef:	01 d0                	add    %edx,%eax
  8031f1:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8031f6:	a1 50 60 80 00       	mov    0x806050,%eax
  8031fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031fe:	c1 e2 04             	shl    $0x4,%edx
  803201:	01 d0                	add    %edx,%eax
  803203:	a3 48 61 80 00       	mov    %eax,0x806148
  803208:	a1 50 60 80 00       	mov    0x806050,%eax
  80320d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803210:	c1 e2 04             	shl    $0x4,%edx
  803213:	01 d0                	add    %edx,%eax
  803215:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321c:	a1 54 61 80 00       	mov    0x806154,%eax
  803221:	40                   	inc    %eax
  803222:	a3 54 61 80 00       	mov    %eax,0x806154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  803227:	ff 45 f4             	incl   -0xc(%ebp)
  80322a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803230:	0f 82 56 ff ff ff    	jb     80318c <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  803236:	90                   	nop
  803237:	c9                   	leave  
  803238:	c3                   	ret    

00803239 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  803239:	55                   	push   %ebp
  80323a:	89 e5                	mov    %esp,%ebp
  80323c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	8b 00                	mov    (%eax),%eax
  803244:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803247:	eb 19                	jmp    803262 <find_block+0x29>
	{
		if(va==point->sva)
  803249:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80324c:	8b 40 08             	mov    0x8(%eax),%eax
  80324f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803252:	75 05                	jne    803259 <find_block+0x20>
		   return point;
  803254:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803257:	eb 36                	jmp    80328f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	8b 40 08             	mov    0x8(%eax),%eax
  80325f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803262:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803266:	74 07                	je     80326f <find_block+0x36>
  803268:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80326b:	8b 00                	mov    (%eax),%eax
  80326d:	eb 05                	jmp    803274 <find_block+0x3b>
  80326f:	b8 00 00 00 00       	mov    $0x0,%eax
  803274:	8b 55 08             	mov    0x8(%ebp),%edx
  803277:	89 42 08             	mov    %eax,0x8(%edx)
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	8b 40 08             	mov    0x8(%eax),%eax
  803280:	85 c0                	test   %eax,%eax
  803282:	75 c5                	jne    803249 <find_block+0x10>
  803284:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803288:	75 bf                	jne    803249 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80328a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80328f:	c9                   	leave  
  803290:	c3                   	ret    

00803291 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  803291:	55                   	push   %ebp
  803292:	89 e5                	mov    %esp,%ebp
  803294:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  803297:	a1 40 60 80 00       	mov    0x806040,%eax
  80329c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80329f:	a1 44 60 80 00       	mov    0x806044,%eax
  8032a4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8032a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8032ad:	74 24                	je     8032d3 <insert_sorted_allocList+0x42>
  8032af:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b2:	8b 50 08             	mov    0x8(%eax),%edx
  8032b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b8:	8b 40 08             	mov    0x8(%eax),%eax
  8032bb:	39 c2                	cmp    %eax,%edx
  8032bd:	76 14                	jbe    8032d3 <insert_sorted_allocList+0x42>
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	8b 50 08             	mov    0x8(%eax),%edx
  8032c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c8:	8b 40 08             	mov    0x8(%eax),%eax
  8032cb:	39 c2                	cmp    %eax,%edx
  8032cd:	0f 82 60 01 00 00    	jb     803433 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8032d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032d7:	75 65                	jne    80333e <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8032d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032dd:	75 14                	jne    8032f3 <insert_sorted_allocList+0x62>
  8032df:	83 ec 04             	sub    $0x4,%esp
  8032e2:	68 84 52 80 00       	push   $0x805284
  8032e7:	6a 6b                	push   $0x6b
  8032e9:	68 a7 52 80 00       	push   $0x8052a7
  8032ee:	e8 9c e2 ff ff       	call   80158f <_panic>
  8032f3:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	89 10                	mov    %edx,(%eax)
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	8b 00                	mov    (%eax),%eax
  803303:	85 c0                	test   %eax,%eax
  803305:	74 0d                	je     803314 <insert_sorted_allocList+0x83>
  803307:	a1 40 60 80 00       	mov    0x806040,%eax
  80330c:	8b 55 08             	mov    0x8(%ebp),%edx
  80330f:	89 50 04             	mov    %edx,0x4(%eax)
  803312:	eb 08                	jmp    80331c <insert_sorted_allocList+0x8b>
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	a3 44 60 80 00       	mov    %eax,0x806044
  80331c:	8b 45 08             	mov    0x8(%ebp),%eax
  80331f:	a3 40 60 80 00       	mov    %eax,0x806040
  803324:	8b 45 08             	mov    0x8(%ebp),%eax
  803327:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80332e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803333:	40                   	inc    %eax
  803334:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  803339:	e9 dc 01 00 00       	jmp    80351a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80333e:	8b 45 08             	mov    0x8(%ebp),%eax
  803341:	8b 50 08             	mov    0x8(%eax),%edx
  803344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803347:	8b 40 08             	mov    0x8(%eax),%eax
  80334a:	39 c2                	cmp    %eax,%edx
  80334c:	77 6c                	ja     8033ba <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80334e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803352:	74 06                	je     80335a <insert_sorted_allocList+0xc9>
  803354:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803358:	75 14                	jne    80336e <insert_sorted_allocList+0xdd>
  80335a:	83 ec 04             	sub    $0x4,%esp
  80335d:	68 c0 52 80 00       	push   $0x8052c0
  803362:	6a 6f                	push   $0x6f
  803364:	68 a7 52 80 00       	push   $0x8052a7
  803369:	e8 21 e2 ff ff       	call   80158f <_panic>
  80336e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803371:	8b 50 04             	mov    0x4(%eax),%edx
  803374:	8b 45 08             	mov    0x8(%ebp),%eax
  803377:	89 50 04             	mov    %edx,0x4(%eax)
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803380:	89 10                	mov    %edx,(%eax)
  803382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803385:	8b 40 04             	mov    0x4(%eax),%eax
  803388:	85 c0                	test   %eax,%eax
  80338a:	74 0d                	je     803399 <insert_sorted_allocList+0x108>
  80338c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338f:	8b 40 04             	mov    0x4(%eax),%eax
  803392:	8b 55 08             	mov    0x8(%ebp),%edx
  803395:	89 10                	mov    %edx,(%eax)
  803397:	eb 08                	jmp    8033a1 <insert_sorted_allocList+0x110>
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	a3 40 60 80 00       	mov    %eax,0x806040
  8033a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a7:	89 50 04             	mov    %edx,0x4(%eax)
  8033aa:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8033af:	40                   	inc    %eax
  8033b0:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8033b5:	e9 60 01 00 00       	jmp    80351a <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bd:	8b 50 08             	mov    0x8(%eax),%edx
  8033c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c3:	8b 40 08             	mov    0x8(%eax),%eax
  8033c6:	39 c2                	cmp    %eax,%edx
  8033c8:	0f 82 4c 01 00 00    	jb     80351a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8033ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d2:	75 14                	jne    8033e8 <insert_sorted_allocList+0x157>
  8033d4:	83 ec 04             	sub    $0x4,%esp
  8033d7:	68 f8 52 80 00       	push   $0x8052f8
  8033dc:	6a 73                	push   $0x73
  8033de:	68 a7 52 80 00       	push   $0x8052a7
  8033e3:	e8 a7 e1 ff ff       	call   80158f <_panic>
  8033e8:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8033ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f1:	89 50 04             	mov    %edx,0x4(%eax)
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	8b 40 04             	mov    0x4(%eax),%eax
  8033fa:	85 c0                	test   %eax,%eax
  8033fc:	74 0c                	je     80340a <insert_sorted_allocList+0x179>
  8033fe:	a1 44 60 80 00       	mov    0x806044,%eax
  803403:	8b 55 08             	mov    0x8(%ebp),%edx
  803406:	89 10                	mov    %edx,(%eax)
  803408:	eb 08                	jmp    803412 <insert_sorted_allocList+0x181>
  80340a:	8b 45 08             	mov    0x8(%ebp),%eax
  80340d:	a3 40 60 80 00       	mov    %eax,0x806040
  803412:	8b 45 08             	mov    0x8(%ebp),%eax
  803415:	a3 44 60 80 00       	mov    %eax,0x806044
  80341a:	8b 45 08             	mov    0x8(%ebp),%eax
  80341d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803423:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803428:	40                   	inc    %eax
  803429:	a3 4c 60 80 00       	mov    %eax,0x80604c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80342e:	e9 e7 00 00 00       	jmp    80351a <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  803433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803436:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  803439:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  803440:	a1 40 60 80 00       	mov    0x806040,%eax
  803445:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803448:	e9 9d 00 00 00       	jmp    8034ea <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80344d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803450:	8b 00                	mov    (%eax),%eax
  803452:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  803455:	8b 45 08             	mov    0x8(%ebp),%eax
  803458:	8b 50 08             	mov    0x8(%eax),%edx
  80345b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345e:	8b 40 08             	mov    0x8(%eax),%eax
  803461:	39 c2                	cmp    %eax,%edx
  803463:	76 7d                	jbe    8034e2 <insert_sorted_allocList+0x251>
  803465:	8b 45 08             	mov    0x8(%ebp),%eax
  803468:	8b 50 08             	mov    0x8(%eax),%edx
  80346b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346e:	8b 40 08             	mov    0x8(%eax),%eax
  803471:	39 c2                	cmp    %eax,%edx
  803473:	73 6d                	jae    8034e2 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  803475:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803479:	74 06                	je     803481 <insert_sorted_allocList+0x1f0>
  80347b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80347f:	75 14                	jne    803495 <insert_sorted_allocList+0x204>
  803481:	83 ec 04             	sub    $0x4,%esp
  803484:	68 1c 53 80 00       	push   $0x80531c
  803489:	6a 7f                	push   $0x7f
  80348b:	68 a7 52 80 00       	push   $0x8052a7
  803490:	e8 fa e0 ff ff       	call   80158f <_panic>
  803495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803498:	8b 10                	mov    (%eax),%edx
  80349a:	8b 45 08             	mov    0x8(%ebp),%eax
  80349d:	89 10                	mov    %edx,(%eax)
  80349f:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a2:	8b 00                	mov    (%eax),%eax
  8034a4:	85 c0                	test   %eax,%eax
  8034a6:	74 0b                	je     8034b3 <insert_sorted_allocList+0x222>
  8034a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ab:	8b 00                	mov    (%eax),%eax
  8034ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b0:	89 50 04             	mov    %edx,0x4(%eax)
  8034b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b9:	89 10                	mov    %edx,(%eax)
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034c1:	89 50 04             	mov    %edx,0x4(%eax)
  8034c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c7:	8b 00                	mov    (%eax),%eax
  8034c9:	85 c0                	test   %eax,%eax
  8034cb:	75 08                	jne    8034d5 <insert_sorted_allocList+0x244>
  8034cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d0:	a3 44 60 80 00       	mov    %eax,0x806044
  8034d5:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8034da:	40                   	inc    %eax
  8034db:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  8034e0:	eb 39                	jmp    80351b <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8034e2:	a1 48 60 80 00       	mov    0x806048,%eax
  8034e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ee:	74 07                	je     8034f7 <insert_sorted_allocList+0x266>
  8034f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f3:	8b 00                	mov    (%eax),%eax
  8034f5:	eb 05                	jmp    8034fc <insert_sorted_allocList+0x26b>
  8034f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034fc:	a3 48 60 80 00       	mov    %eax,0x806048
  803501:	a1 48 60 80 00       	mov    0x806048,%eax
  803506:	85 c0                	test   %eax,%eax
  803508:	0f 85 3f ff ff ff    	jne    80344d <insert_sorted_allocList+0x1bc>
  80350e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803512:	0f 85 35 ff ff ff    	jne    80344d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  803518:	eb 01                	jmp    80351b <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80351a:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80351b:	90                   	nop
  80351c:	c9                   	leave  
  80351d:	c3                   	ret    

0080351e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80351e:	55                   	push   %ebp
  80351f:	89 e5                	mov    %esp,%ebp
  803521:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  803524:	a1 38 61 80 00       	mov    0x806138,%eax
  803529:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80352c:	e9 85 01 00 00       	jmp    8036b6 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  803531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803534:	8b 40 0c             	mov    0xc(%eax),%eax
  803537:	3b 45 08             	cmp    0x8(%ebp),%eax
  80353a:	0f 82 6e 01 00 00    	jb     8036ae <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  803540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803543:	8b 40 0c             	mov    0xc(%eax),%eax
  803546:	3b 45 08             	cmp    0x8(%ebp),%eax
  803549:	0f 85 8a 00 00 00    	jne    8035d9 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80354f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803553:	75 17                	jne    80356c <alloc_block_FF+0x4e>
  803555:	83 ec 04             	sub    $0x4,%esp
  803558:	68 50 53 80 00       	push   $0x805350
  80355d:	68 93 00 00 00       	push   $0x93
  803562:	68 a7 52 80 00       	push   $0x8052a7
  803567:	e8 23 e0 ff ff       	call   80158f <_panic>
  80356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356f:	8b 00                	mov    (%eax),%eax
  803571:	85 c0                	test   %eax,%eax
  803573:	74 10                	je     803585 <alloc_block_FF+0x67>
  803575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803578:	8b 00                	mov    (%eax),%eax
  80357a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80357d:	8b 52 04             	mov    0x4(%edx),%edx
  803580:	89 50 04             	mov    %edx,0x4(%eax)
  803583:	eb 0b                	jmp    803590 <alloc_block_FF+0x72>
  803585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803588:	8b 40 04             	mov    0x4(%eax),%eax
  80358b:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803593:	8b 40 04             	mov    0x4(%eax),%eax
  803596:	85 c0                	test   %eax,%eax
  803598:	74 0f                	je     8035a9 <alloc_block_FF+0x8b>
  80359a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359d:	8b 40 04             	mov    0x4(%eax),%eax
  8035a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a3:	8b 12                	mov    (%edx),%edx
  8035a5:	89 10                	mov    %edx,(%eax)
  8035a7:	eb 0a                	jmp    8035b3 <alloc_block_FF+0x95>
  8035a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ac:	8b 00                	mov    (%eax),%eax
  8035ae:	a3 38 61 80 00       	mov    %eax,0x806138
  8035b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c6:	a1 44 61 80 00       	mov    0x806144,%eax
  8035cb:	48                   	dec    %eax
  8035cc:	a3 44 61 80 00       	mov    %eax,0x806144
			   return  point;
  8035d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d4:	e9 10 01 00 00       	jmp    8036e9 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8035d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8035df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035e2:	0f 86 c6 00 00 00    	jbe    8036ae <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8035e8:	a1 48 61 80 00       	mov    0x806148,%eax
  8035ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8035f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f3:	8b 50 08             	mov    0x8(%eax),%edx
  8035f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f9:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8035fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803602:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803605:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803609:	75 17                	jne    803622 <alloc_block_FF+0x104>
  80360b:	83 ec 04             	sub    $0x4,%esp
  80360e:	68 50 53 80 00       	push   $0x805350
  803613:	68 9b 00 00 00       	push   $0x9b
  803618:	68 a7 52 80 00       	push   $0x8052a7
  80361d:	e8 6d df ff ff       	call   80158f <_panic>
  803622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803625:	8b 00                	mov    (%eax),%eax
  803627:	85 c0                	test   %eax,%eax
  803629:	74 10                	je     80363b <alloc_block_FF+0x11d>
  80362b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80362e:	8b 00                	mov    (%eax),%eax
  803630:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803633:	8b 52 04             	mov    0x4(%edx),%edx
  803636:	89 50 04             	mov    %edx,0x4(%eax)
  803639:	eb 0b                	jmp    803646 <alloc_block_FF+0x128>
  80363b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80363e:	8b 40 04             	mov    0x4(%eax),%eax
  803641:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803649:	8b 40 04             	mov    0x4(%eax),%eax
  80364c:	85 c0                	test   %eax,%eax
  80364e:	74 0f                	je     80365f <alloc_block_FF+0x141>
  803650:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803653:	8b 40 04             	mov    0x4(%eax),%eax
  803656:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803659:	8b 12                	mov    (%edx),%edx
  80365b:	89 10                	mov    %edx,(%eax)
  80365d:	eb 0a                	jmp    803669 <alloc_block_FF+0x14b>
  80365f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803662:	8b 00                	mov    (%eax),%eax
  803664:	a3 48 61 80 00       	mov    %eax,0x806148
  803669:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80366c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803675:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80367c:	a1 54 61 80 00       	mov    0x806154,%eax
  803681:	48                   	dec    %eax
  803682:	a3 54 61 80 00       	mov    %eax,0x806154
			   point->sva += size;
  803687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368a:	8b 50 08             	mov    0x8(%eax),%edx
  80368d:	8b 45 08             	mov    0x8(%ebp),%eax
  803690:	01 c2                	add    %eax,%edx
  803692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803695:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  803698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369b:	8b 40 0c             	mov    0xc(%eax),%eax
  80369e:	2b 45 08             	sub    0x8(%ebp),%eax
  8036a1:	89 c2                	mov    %eax,%edx
  8036a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a6:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8036a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ac:	eb 3b                	jmp    8036e9 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8036ae:	a1 40 61 80 00       	mov    0x806140,%eax
  8036b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036ba:	74 07                	je     8036c3 <alloc_block_FF+0x1a5>
  8036bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bf:	8b 00                	mov    (%eax),%eax
  8036c1:	eb 05                	jmp    8036c8 <alloc_block_FF+0x1aa>
  8036c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c8:	a3 40 61 80 00       	mov    %eax,0x806140
  8036cd:	a1 40 61 80 00       	mov    0x806140,%eax
  8036d2:	85 c0                	test   %eax,%eax
  8036d4:	0f 85 57 fe ff ff    	jne    803531 <alloc_block_FF+0x13>
  8036da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036de:	0f 85 4d fe ff ff    	jne    803531 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8036e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036e9:	c9                   	leave  
  8036ea:	c3                   	ret    

008036eb <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8036eb:	55                   	push   %ebp
  8036ec:	89 e5                	mov    %esp,%ebp
  8036ee:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8036f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8036f8:	a1 38 61 80 00       	mov    0x806138,%eax
  8036fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803700:	e9 df 00 00 00       	jmp    8037e4 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  803705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803708:	8b 40 0c             	mov    0xc(%eax),%eax
  80370b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80370e:	0f 82 c8 00 00 00    	jb     8037dc <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  803714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803717:	8b 40 0c             	mov    0xc(%eax),%eax
  80371a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80371d:	0f 85 8a 00 00 00    	jne    8037ad <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  803723:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803727:	75 17                	jne    803740 <alloc_block_BF+0x55>
  803729:	83 ec 04             	sub    $0x4,%esp
  80372c:	68 50 53 80 00       	push   $0x805350
  803731:	68 b7 00 00 00       	push   $0xb7
  803736:	68 a7 52 80 00       	push   $0x8052a7
  80373b:	e8 4f de ff ff       	call   80158f <_panic>
  803740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803743:	8b 00                	mov    (%eax),%eax
  803745:	85 c0                	test   %eax,%eax
  803747:	74 10                	je     803759 <alloc_block_BF+0x6e>
  803749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374c:	8b 00                	mov    (%eax),%eax
  80374e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803751:	8b 52 04             	mov    0x4(%edx),%edx
  803754:	89 50 04             	mov    %edx,0x4(%eax)
  803757:	eb 0b                	jmp    803764 <alloc_block_BF+0x79>
  803759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375c:	8b 40 04             	mov    0x4(%eax),%eax
  80375f:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803767:	8b 40 04             	mov    0x4(%eax),%eax
  80376a:	85 c0                	test   %eax,%eax
  80376c:	74 0f                	je     80377d <alloc_block_BF+0x92>
  80376e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803771:	8b 40 04             	mov    0x4(%eax),%eax
  803774:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803777:	8b 12                	mov    (%edx),%edx
  803779:	89 10                	mov    %edx,(%eax)
  80377b:	eb 0a                	jmp    803787 <alloc_block_BF+0x9c>
  80377d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803780:	8b 00                	mov    (%eax),%eax
  803782:	a3 38 61 80 00       	mov    %eax,0x806138
  803787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803793:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80379a:	a1 44 61 80 00       	mov    0x806144,%eax
  80379f:	48                   	dec    %eax
  8037a0:	a3 44 61 80 00       	mov    %eax,0x806144
			   return currentMemBlock;
  8037a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a8:	e9 4d 01 00 00       	jmp    8038fa <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8037ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8037b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037b6:	76 24                	jbe    8037dc <alloc_block_BF+0xf1>
  8037b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8037be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8037c1:	73 19                	jae    8037dc <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8037c3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8037ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8037d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8037d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d6:	8b 40 08             	mov    0x8(%eax),%eax
  8037d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8037dc:	a1 40 61 80 00       	mov    0x806140,%eax
  8037e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e8:	74 07                	je     8037f1 <alloc_block_BF+0x106>
  8037ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ed:	8b 00                	mov    (%eax),%eax
  8037ef:	eb 05                	jmp    8037f6 <alloc_block_BF+0x10b>
  8037f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f6:	a3 40 61 80 00       	mov    %eax,0x806140
  8037fb:	a1 40 61 80 00       	mov    0x806140,%eax
  803800:	85 c0                	test   %eax,%eax
  803802:	0f 85 fd fe ff ff    	jne    803705 <alloc_block_BF+0x1a>
  803808:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80380c:	0f 85 f3 fe ff ff    	jne    803705 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  803812:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803816:	0f 84 d9 00 00 00    	je     8038f5 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80381c:	a1 48 61 80 00       	mov    0x806148,%eax
  803821:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803827:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80382a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80382d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803830:	8b 55 08             	mov    0x8(%ebp),%edx
  803833:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803836:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80383a:	75 17                	jne    803853 <alloc_block_BF+0x168>
  80383c:	83 ec 04             	sub    $0x4,%esp
  80383f:	68 50 53 80 00       	push   $0x805350
  803844:	68 c7 00 00 00       	push   $0xc7
  803849:	68 a7 52 80 00       	push   $0x8052a7
  80384e:	e8 3c dd ff ff       	call   80158f <_panic>
  803853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803856:	8b 00                	mov    (%eax),%eax
  803858:	85 c0                	test   %eax,%eax
  80385a:	74 10                	je     80386c <alloc_block_BF+0x181>
  80385c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385f:	8b 00                	mov    (%eax),%eax
  803861:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803864:	8b 52 04             	mov    0x4(%edx),%edx
  803867:	89 50 04             	mov    %edx,0x4(%eax)
  80386a:	eb 0b                	jmp    803877 <alloc_block_BF+0x18c>
  80386c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386f:	8b 40 04             	mov    0x4(%eax),%eax
  803872:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387a:	8b 40 04             	mov    0x4(%eax),%eax
  80387d:	85 c0                	test   %eax,%eax
  80387f:	74 0f                	je     803890 <alloc_block_BF+0x1a5>
  803881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803884:	8b 40 04             	mov    0x4(%eax),%eax
  803887:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80388a:	8b 12                	mov    (%edx),%edx
  80388c:	89 10                	mov    %edx,(%eax)
  80388e:	eb 0a                	jmp    80389a <alloc_block_BF+0x1af>
  803890:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803893:	8b 00                	mov    (%eax),%eax
  803895:	a3 48 61 80 00       	mov    %eax,0x806148
  80389a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ad:	a1 54 61 80 00       	mov    0x806154,%eax
  8038b2:	48                   	dec    %eax
  8038b3:	a3 54 61 80 00       	mov    %eax,0x806154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8038b8:	83 ec 08             	sub    $0x8,%esp
  8038bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8038be:	68 38 61 80 00       	push   $0x806138
  8038c3:	e8 71 f9 ff ff       	call   803239 <find_block>
  8038c8:	83 c4 10             	add    $0x10,%esp
  8038cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8038ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038d1:	8b 50 08             	mov    0x8(%eax),%edx
  8038d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d7:	01 c2                	add    %eax,%edx
  8038d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038dc:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8038df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8038e5:	2b 45 08             	sub    0x8(%ebp),%eax
  8038e8:	89 c2                	mov    %eax,%edx
  8038ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038ed:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8038f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f3:	eb 05                	jmp    8038fa <alloc_block_BF+0x20f>
	}
	return NULL;
  8038f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038fa:	c9                   	leave  
  8038fb:	c3                   	ret    

008038fc <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8038fc:	55                   	push   %ebp
  8038fd:	89 e5                	mov    %esp,%ebp
  8038ff:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803902:	a1 28 60 80 00       	mov    0x806028,%eax
  803907:	85 c0                	test   %eax,%eax
  803909:	0f 85 de 01 00 00    	jne    803aed <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80390f:	a1 38 61 80 00       	mov    0x806138,%eax
  803914:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803917:	e9 9e 01 00 00       	jmp    803aba <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80391c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391f:	8b 40 0c             	mov    0xc(%eax),%eax
  803922:	3b 45 08             	cmp    0x8(%ebp),%eax
  803925:	0f 82 87 01 00 00    	jb     803ab2 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80392b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392e:	8b 40 0c             	mov    0xc(%eax),%eax
  803931:	3b 45 08             	cmp    0x8(%ebp),%eax
  803934:	0f 85 95 00 00 00    	jne    8039cf <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80393a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80393e:	75 17                	jne    803957 <alloc_block_NF+0x5b>
  803940:	83 ec 04             	sub    $0x4,%esp
  803943:	68 50 53 80 00       	push   $0x805350
  803948:	68 e0 00 00 00       	push   $0xe0
  80394d:	68 a7 52 80 00       	push   $0x8052a7
  803952:	e8 38 dc ff ff       	call   80158f <_panic>
  803957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395a:	8b 00                	mov    (%eax),%eax
  80395c:	85 c0                	test   %eax,%eax
  80395e:	74 10                	je     803970 <alloc_block_NF+0x74>
  803960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803963:	8b 00                	mov    (%eax),%eax
  803965:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803968:	8b 52 04             	mov    0x4(%edx),%edx
  80396b:	89 50 04             	mov    %edx,0x4(%eax)
  80396e:	eb 0b                	jmp    80397b <alloc_block_NF+0x7f>
  803970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803973:	8b 40 04             	mov    0x4(%eax),%eax
  803976:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80397b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397e:	8b 40 04             	mov    0x4(%eax),%eax
  803981:	85 c0                	test   %eax,%eax
  803983:	74 0f                	je     803994 <alloc_block_NF+0x98>
  803985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803988:	8b 40 04             	mov    0x4(%eax),%eax
  80398b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80398e:	8b 12                	mov    (%edx),%edx
  803990:	89 10                	mov    %edx,(%eax)
  803992:	eb 0a                	jmp    80399e <alloc_block_NF+0xa2>
  803994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803997:	8b 00                	mov    (%eax),%eax
  803999:	a3 38 61 80 00       	mov    %eax,0x806138
  80399e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b1:	a1 44 61 80 00       	mov    0x806144,%eax
  8039b6:	48                   	dec    %eax
  8039b7:	a3 44 61 80 00       	mov    %eax,0x806144
				   svaOfNF = point->sva;
  8039bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bf:	8b 40 08             	mov    0x8(%eax),%eax
  8039c2:	a3 28 60 80 00       	mov    %eax,0x806028
				   return  point;
  8039c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ca:	e9 f8 04 00 00       	jmp    803ec7 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8039d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039d8:	0f 86 d4 00 00 00    	jbe    803ab2 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8039de:	a1 48 61 80 00       	mov    0x806148,%eax
  8039e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8039e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e9:	8b 50 08             	mov    0x8(%eax),%edx
  8039ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ef:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8039f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8039f8:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8039fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039ff:	75 17                	jne    803a18 <alloc_block_NF+0x11c>
  803a01:	83 ec 04             	sub    $0x4,%esp
  803a04:	68 50 53 80 00       	push   $0x805350
  803a09:	68 e9 00 00 00       	push   $0xe9
  803a0e:	68 a7 52 80 00       	push   $0x8052a7
  803a13:	e8 77 db ff ff       	call   80158f <_panic>
  803a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a1b:	8b 00                	mov    (%eax),%eax
  803a1d:	85 c0                	test   %eax,%eax
  803a1f:	74 10                	je     803a31 <alloc_block_NF+0x135>
  803a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a24:	8b 00                	mov    (%eax),%eax
  803a26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a29:	8b 52 04             	mov    0x4(%edx),%edx
  803a2c:	89 50 04             	mov    %edx,0x4(%eax)
  803a2f:	eb 0b                	jmp    803a3c <alloc_block_NF+0x140>
  803a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a34:	8b 40 04             	mov    0x4(%eax),%eax
  803a37:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a3f:	8b 40 04             	mov    0x4(%eax),%eax
  803a42:	85 c0                	test   %eax,%eax
  803a44:	74 0f                	je     803a55 <alloc_block_NF+0x159>
  803a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a49:	8b 40 04             	mov    0x4(%eax),%eax
  803a4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a4f:	8b 12                	mov    (%edx),%edx
  803a51:	89 10                	mov    %edx,(%eax)
  803a53:	eb 0a                	jmp    803a5f <alloc_block_NF+0x163>
  803a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a58:	8b 00                	mov    (%eax),%eax
  803a5a:	a3 48 61 80 00       	mov    %eax,0x806148
  803a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a72:	a1 54 61 80 00       	mov    0x806154,%eax
  803a77:	48                   	dec    %eax
  803a78:	a3 54 61 80 00       	mov    %eax,0x806154
				   svaOfNF = ReturnedBlock->sva;
  803a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a80:	8b 40 08             	mov    0x8(%eax),%eax
  803a83:	a3 28 60 80 00       	mov    %eax,0x806028
				   point->sva += size;
  803a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8b:	8b 50 08             	mov    0x8(%eax),%edx
  803a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a91:	01 c2                	add    %eax,%edx
  803a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a96:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9c:	8b 40 0c             	mov    0xc(%eax),%eax
  803a9f:	2b 45 08             	sub    0x8(%ebp),%eax
  803aa2:	89 c2                	mov    %eax,%edx
  803aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa7:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aad:	e9 15 04 00 00       	jmp    803ec7 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803ab2:	a1 40 61 80 00       	mov    0x806140,%eax
  803ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803aba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803abe:	74 07                	je     803ac7 <alloc_block_NF+0x1cb>
  803ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac3:	8b 00                	mov    (%eax),%eax
  803ac5:	eb 05                	jmp    803acc <alloc_block_NF+0x1d0>
  803ac7:	b8 00 00 00 00       	mov    $0x0,%eax
  803acc:	a3 40 61 80 00       	mov    %eax,0x806140
  803ad1:	a1 40 61 80 00       	mov    0x806140,%eax
  803ad6:	85 c0                	test   %eax,%eax
  803ad8:	0f 85 3e fe ff ff    	jne    80391c <alloc_block_NF+0x20>
  803ade:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ae2:	0f 85 34 fe ff ff    	jne    80391c <alloc_block_NF+0x20>
  803ae8:	e9 d5 03 00 00       	jmp    803ec2 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803aed:	a1 38 61 80 00       	mov    0x806138,%eax
  803af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803af5:	e9 b1 01 00 00       	jmp    803cab <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afd:	8b 50 08             	mov    0x8(%eax),%edx
  803b00:	a1 28 60 80 00       	mov    0x806028,%eax
  803b05:	39 c2                	cmp    %eax,%edx
  803b07:	0f 82 96 01 00 00    	jb     803ca3 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b10:	8b 40 0c             	mov    0xc(%eax),%eax
  803b13:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b16:	0f 82 87 01 00 00    	jb     803ca3 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1f:	8b 40 0c             	mov    0xc(%eax),%eax
  803b22:	3b 45 08             	cmp    0x8(%ebp),%eax
  803b25:	0f 85 95 00 00 00    	jne    803bc0 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b2f:	75 17                	jne    803b48 <alloc_block_NF+0x24c>
  803b31:	83 ec 04             	sub    $0x4,%esp
  803b34:	68 50 53 80 00       	push   $0x805350
  803b39:	68 fc 00 00 00       	push   $0xfc
  803b3e:	68 a7 52 80 00       	push   $0x8052a7
  803b43:	e8 47 da ff ff       	call   80158f <_panic>
  803b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4b:	8b 00                	mov    (%eax),%eax
  803b4d:	85 c0                	test   %eax,%eax
  803b4f:	74 10                	je     803b61 <alloc_block_NF+0x265>
  803b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b54:	8b 00                	mov    (%eax),%eax
  803b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b59:	8b 52 04             	mov    0x4(%edx),%edx
  803b5c:	89 50 04             	mov    %edx,0x4(%eax)
  803b5f:	eb 0b                	jmp    803b6c <alloc_block_NF+0x270>
  803b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b64:	8b 40 04             	mov    0x4(%eax),%eax
  803b67:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b6f:	8b 40 04             	mov    0x4(%eax),%eax
  803b72:	85 c0                	test   %eax,%eax
  803b74:	74 0f                	je     803b85 <alloc_block_NF+0x289>
  803b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b79:	8b 40 04             	mov    0x4(%eax),%eax
  803b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b7f:	8b 12                	mov    (%edx),%edx
  803b81:	89 10                	mov    %edx,(%eax)
  803b83:	eb 0a                	jmp    803b8f <alloc_block_NF+0x293>
  803b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b88:	8b 00                	mov    (%eax),%eax
  803b8a:	a3 38 61 80 00       	mov    %eax,0x806138
  803b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ba2:	a1 44 61 80 00       	mov    0x806144,%eax
  803ba7:	48                   	dec    %eax
  803ba8:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb0:	8b 40 08             	mov    0x8(%eax),%eax
  803bb3:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bbb:	e9 07 03 00 00       	jmp    803ec7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc3:	8b 40 0c             	mov    0xc(%eax),%eax
  803bc6:	3b 45 08             	cmp    0x8(%ebp),%eax
  803bc9:	0f 86 d4 00 00 00    	jbe    803ca3 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803bcf:	a1 48 61 80 00       	mov    0x806148,%eax
  803bd4:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bda:	8b 50 08             	mov    0x8(%eax),%edx
  803bdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803be3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be6:	8b 55 08             	mov    0x8(%ebp),%edx
  803be9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803bec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bf0:	75 17                	jne    803c09 <alloc_block_NF+0x30d>
  803bf2:	83 ec 04             	sub    $0x4,%esp
  803bf5:	68 50 53 80 00       	push   $0x805350
  803bfa:	68 04 01 00 00       	push   $0x104
  803bff:	68 a7 52 80 00       	push   $0x8052a7
  803c04:	e8 86 d9 ff ff       	call   80158f <_panic>
  803c09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c0c:	8b 00                	mov    (%eax),%eax
  803c0e:	85 c0                	test   %eax,%eax
  803c10:	74 10                	je     803c22 <alloc_block_NF+0x326>
  803c12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c15:	8b 00                	mov    (%eax),%eax
  803c17:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c1a:	8b 52 04             	mov    0x4(%edx),%edx
  803c1d:	89 50 04             	mov    %edx,0x4(%eax)
  803c20:	eb 0b                	jmp    803c2d <alloc_block_NF+0x331>
  803c22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c25:	8b 40 04             	mov    0x4(%eax),%eax
  803c28:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803c2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c30:	8b 40 04             	mov    0x4(%eax),%eax
  803c33:	85 c0                	test   %eax,%eax
  803c35:	74 0f                	je     803c46 <alloc_block_NF+0x34a>
  803c37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c3a:	8b 40 04             	mov    0x4(%eax),%eax
  803c3d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c40:	8b 12                	mov    (%edx),%edx
  803c42:	89 10                	mov    %edx,(%eax)
  803c44:	eb 0a                	jmp    803c50 <alloc_block_NF+0x354>
  803c46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c49:	8b 00                	mov    (%eax),%eax
  803c4b:	a3 48 61 80 00       	mov    %eax,0x806148
  803c50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c63:	a1 54 61 80 00       	mov    0x806154,%eax
  803c68:	48                   	dec    %eax
  803c69:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803c6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c71:	8b 40 08             	mov    0x8(%eax),%eax
  803c74:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7c:	8b 50 08             	mov    0x8(%eax),%edx
  803c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c82:	01 c2                	add    %eax,%edx
  803c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c87:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c8d:	8b 40 0c             	mov    0xc(%eax),%eax
  803c90:	2b 45 08             	sub    0x8(%ebp),%eax
  803c93:	89 c2                	mov    %eax,%edx
  803c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c98:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803c9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c9e:	e9 24 02 00 00       	jmp    803ec7 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803ca3:	a1 40 61 80 00       	mov    0x806140,%eax
  803ca8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803caf:	74 07                	je     803cb8 <alloc_block_NF+0x3bc>
  803cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb4:	8b 00                	mov    (%eax),%eax
  803cb6:	eb 05                	jmp    803cbd <alloc_block_NF+0x3c1>
  803cb8:	b8 00 00 00 00       	mov    $0x0,%eax
  803cbd:	a3 40 61 80 00       	mov    %eax,0x806140
  803cc2:	a1 40 61 80 00       	mov    0x806140,%eax
  803cc7:	85 c0                	test   %eax,%eax
  803cc9:	0f 85 2b fe ff ff    	jne    803afa <alloc_block_NF+0x1fe>
  803ccf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cd3:	0f 85 21 fe ff ff    	jne    803afa <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803cd9:	a1 38 61 80 00       	mov    0x806138,%eax
  803cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ce1:	e9 ae 01 00 00       	jmp    803e94 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce9:	8b 50 08             	mov    0x8(%eax),%edx
  803cec:	a1 28 60 80 00       	mov    0x806028,%eax
  803cf1:	39 c2                	cmp    %eax,%edx
  803cf3:	0f 83 93 01 00 00    	jae    803e8c <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cfc:	8b 40 0c             	mov    0xc(%eax),%eax
  803cff:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d02:	0f 82 84 01 00 00    	jb     803e8c <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0b:	8b 40 0c             	mov    0xc(%eax),%eax
  803d0e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803d11:	0f 85 95 00 00 00    	jne    803dac <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803d17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d1b:	75 17                	jne    803d34 <alloc_block_NF+0x438>
  803d1d:	83 ec 04             	sub    $0x4,%esp
  803d20:	68 50 53 80 00       	push   $0x805350
  803d25:	68 14 01 00 00       	push   $0x114
  803d2a:	68 a7 52 80 00       	push   $0x8052a7
  803d2f:	e8 5b d8 ff ff       	call   80158f <_panic>
  803d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d37:	8b 00                	mov    (%eax),%eax
  803d39:	85 c0                	test   %eax,%eax
  803d3b:	74 10                	je     803d4d <alloc_block_NF+0x451>
  803d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d40:	8b 00                	mov    (%eax),%eax
  803d42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d45:	8b 52 04             	mov    0x4(%edx),%edx
  803d48:	89 50 04             	mov    %edx,0x4(%eax)
  803d4b:	eb 0b                	jmp    803d58 <alloc_block_NF+0x45c>
  803d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d50:	8b 40 04             	mov    0x4(%eax),%eax
  803d53:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5b:	8b 40 04             	mov    0x4(%eax),%eax
  803d5e:	85 c0                	test   %eax,%eax
  803d60:	74 0f                	je     803d71 <alloc_block_NF+0x475>
  803d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d65:	8b 40 04             	mov    0x4(%eax),%eax
  803d68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d6b:	8b 12                	mov    (%edx),%edx
  803d6d:	89 10                	mov    %edx,(%eax)
  803d6f:	eb 0a                	jmp    803d7b <alloc_block_NF+0x47f>
  803d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d74:	8b 00                	mov    (%eax),%eax
  803d76:	a3 38 61 80 00       	mov    %eax,0x806138
  803d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d8e:	a1 44 61 80 00       	mov    0x806144,%eax
  803d93:	48                   	dec    %eax
  803d94:	a3 44 61 80 00       	mov    %eax,0x806144
					   svaOfNF = point->sva;
  803d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d9c:	8b 40 08             	mov    0x8(%eax),%eax
  803d9f:	a3 28 60 80 00       	mov    %eax,0x806028
					   return  point;
  803da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da7:	e9 1b 01 00 00       	jmp    803ec7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803daf:	8b 40 0c             	mov    0xc(%eax),%eax
  803db2:	3b 45 08             	cmp    0x8(%ebp),%eax
  803db5:	0f 86 d1 00 00 00    	jbe    803e8c <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803dbb:	a1 48 61 80 00       	mov    0x806148,%eax
  803dc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc6:	8b 50 08             	mov    0x8(%eax),%edx
  803dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dcc:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803dcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dd2:	8b 55 08             	mov    0x8(%ebp),%edx
  803dd5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803dd8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ddc:	75 17                	jne    803df5 <alloc_block_NF+0x4f9>
  803dde:	83 ec 04             	sub    $0x4,%esp
  803de1:	68 50 53 80 00       	push   $0x805350
  803de6:	68 1c 01 00 00       	push   $0x11c
  803deb:	68 a7 52 80 00       	push   $0x8052a7
  803df0:	e8 9a d7 ff ff       	call   80158f <_panic>
  803df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803df8:	8b 00                	mov    (%eax),%eax
  803dfa:	85 c0                	test   %eax,%eax
  803dfc:	74 10                	je     803e0e <alloc_block_NF+0x512>
  803dfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e01:	8b 00                	mov    (%eax),%eax
  803e03:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e06:	8b 52 04             	mov    0x4(%edx),%edx
  803e09:	89 50 04             	mov    %edx,0x4(%eax)
  803e0c:	eb 0b                	jmp    803e19 <alloc_block_NF+0x51d>
  803e0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e11:	8b 40 04             	mov    0x4(%eax),%eax
  803e14:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e1c:	8b 40 04             	mov    0x4(%eax),%eax
  803e1f:	85 c0                	test   %eax,%eax
  803e21:	74 0f                	je     803e32 <alloc_block_NF+0x536>
  803e23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e26:	8b 40 04             	mov    0x4(%eax),%eax
  803e29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e2c:	8b 12                	mov    (%edx),%edx
  803e2e:	89 10                	mov    %edx,(%eax)
  803e30:	eb 0a                	jmp    803e3c <alloc_block_NF+0x540>
  803e32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e35:	8b 00                	mov    (%eax),%eax
  803e37:	a3 48 61 80 00       	mov    %eax,0x806148
  803e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e4f:	a1 54 61 80 00       	mov    0x806154,%eax
  803e54:	48                   	dec    %eax
  803e55:	a3 54 61 80 00       	mov    %eax,0x806154
					   svaOfNF = ReturnedBlock->sva;
  803e5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e5d:	8b 40 08             	mov    0x8(%eax),%eax
  803e60:	a3 28 60 80 00       	mov    %eax,0x806028
					   point->sva += size;
  803e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e68:	8b 50 08             	mov    0x8(%eax),%edx
  803e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e6e:	01 c2                	add    %eax,%edx
  803e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e73:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e79:	8b 40 0c             	mov    0xc(%eax),%eax
  803e7c:	2b 45 08             	sub    0x8(%ebp),%eax
  803e7f:	89 c2                	mov    %eax,%edx
  803e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e84:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803e87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e8a:	eb 3b                	jmp    803ec7 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803e8c:	a1 40 61 80 00       	mov    0x806140,%eax
  803e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e98:	74 07                	je     803ea1 <alloc_block_NF+0x5a5>
  803e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e9d:	8b 00                	mov    (%eax),%eax
  803e9f:	eb 05                	jmp    803ea6 <alloc_block_NF+0x5aa>
  803ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  803ea6:	a3 40 61 80 00       	mov    %eax,0x806140
  803eab:	a1 40 61 80 00       	mov    0x806140,%eax
  803eb0:	85 c0                	test   %eax,%eax
  803eb2:	0f 85 2e fe ff ff    	jne    803ce6 <alloc_block_NF+0x3ea>
  803eb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ebc:	0f 85 24 fe ff ff    	jne    803ce6 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803ec2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ec7:	c9                   	leave  
  803ec8:	c3                   	ret    

00803ec9 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803ec9:	55                   	push   %ebp
  803eca:	89 e5                	mov    %esp,%ebp
  803ecc:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803ecf:	a1 38 61 80 00       	mov    0x806138,%eax
  803ed4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803ed7:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803edc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803edf:	a1 38 61 80 00       	mov    0x806138,%eax
  803ee4:	85 c0                	test   %eax,%eax
  803ee6:	74 14                	je     803efc <insert_sorted_with_merge_freeList+0x33>
  803ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  803eeb:	8b 50 08             	mov    0x8(%eax),%edx
  803eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ef1:	8b 40 08             	mov    0x8(%eax),%eax
  803ef4:	39 c2                	cmp    %eax,%edx
  803ef6:	0f 87 9b 01 00 00    	ja     804097 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803efc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f00:	75 17                	jne    803f19 <insert_sorted_with_merge_freeList+0x50>
  803f02:	83 ec 04             	sub    $0x4,%esp
  803f05:	68 84 52 80 00       	push   $0x805284
  803f0a:	68 38 01 00 00       	push   $0x138
  803f0f:	68 a7 52 80 00       	push   $0x8052a7
  803f14:	e8 76 d6 ff ff       	call   80158f <_panic>
  803f19:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f22:	89 10                	mov    %edx,(%eax)
  803f24:	8b 45 08             	mov    0x8(%ebp),%eax
  803f27:	8b 00                	mov    (%eax),%eax
  803f29:	85 c0                	test   %eax,%eax
  803f2b:	74 0d                	je     803f3a <insert_sorted_with_merge_freeList+0x71>
  803f2d:	a1 38 61 80 00       	mov    0x806138,%eax
  803f32:	8b 55 08             	mov    0x8(%ebp),%edx
  803f35:	89 50 04             	mov    %edx,0x4(%eax)
  803f38:	eb 08                	jmp    803f42 <insert_sorted_with_merge_freeList+0x79>
  803f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f3d:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803f42:	8b 45 08             	mov    0x8(%ebp),%eax
  803f45:	a3 38 61 80 00       	mov    %eax,0x806138
  803f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f54:	a1 44 61 80 00       	mov    0x806144,%eax
  803f59:	40                   	inc    %eax
  803f5a:	a3 44 61 80 00       	mov    %eax,0x806144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803f5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f63:	0f 84 a8 06 00 00    	je     804611 <insert_sorted_with_merge_freeList+0x748>
  803f69:	8b 45 08             	mov    0x8(%ebp),%eax
  803f6c:	8b 50 08             	mov    0x8(%eax),%edx
  803f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f72:	8b 40 0c             	mov    0xc(%eax),%eax
  803f75:	01 c2                	add    %eax,%edx
  803f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f7a:	8b 40 08             	mov    0x8(%eax),%eax
  803f7d:	39 c2                	cmp    %eax,%edx
  803f7f:	0f 85 8c 06 00 00    	jne    804611 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803f85:	8b 45 08             	mov    0x8(%ebp),%eax
  803f88:	8b 50 0c             	mov    0xc(%eax),%edx
  803f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f8e:	8b 40 0c             	mov    0xc(%eax),%eax
  803f91:	01 c2                	add    %eax,%edx
  803f93:	8b 45 08             	mov    0x8(%ebp),%eax
  803f96:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803f99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f9d:	75 17                	jne    803fb6 <insert_sorted_with_merge_freeList+0xed>
  803f9f:	83 ec 04             	sub    $0x4,%esp
  803fa2:	68 50 53 80 00       	push   $0x805350
  803fa7:	68 3c 01 00 00       	push   $0x13c
  803fac:	68 a7 52 80 00       	push   $0x8052a7
  803fb1:	e8 d9 d5 ff ff       	call   80158f <_panic>
  803fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fb9:	8b 00                	mov    (%eax),%eax
  803fbb:	85 c0                	test   %eax,%eax
  803fbd:	74 10                	je     803fcf <insert_sorted_with_merge_freeList+0x106>
  803fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fc2:	8b 00                	mov    (%eax),%eax
  803fc4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fc7:	8b 52 04             	mov    0x4(%edx),%edx
  803fca:	89 50 04             	mov    %edx,0x4(%eax)
  803fcd:	eb 0b                	jmp    803fda <insert_sorted_with_merge_freeList+0x111>
  803fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fd2:	8b 40 04             	mov    0x4(%eax),%eax
  803fd5:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fdd:	8b 40 04             	mov    0x4(%eax),%eax
  803fe0:	85 c0                	test   %eax,%eax
  803fe2:	74 0f                	je     803ff3 <insert_sorted_with_merge_freeList+0x12a>
  803fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fe7:	8b 40 04             	mov    0x4(%eax),%eax
  803fea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fed:	8b 12                	mov    (%edx),%edx
  803fef:	89 10                	mov    %edx,(%eax)
  803ff1:	eb 0a                	jmp    803ffd <insert_sorted_with_merge_freeList+0x134>
  803ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ff6:	8b 00                	mov    (%eax),%eax
  803ff8:	a3 38 61 80 00       	mov    %eax,0x806138
  803ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804000:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804006:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804009:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804010:	a1 44 61 80 00       	mov    0x806144,%eax
  804015:	48                   	dec    %eax
  804016:	a3 44 61 80 00       	mov    %eax,0x806144
			head->size = 0;
  80401b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80401e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  804025:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804028:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80402f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804033:	75 17                	jne    80404c <insert_sorted_with_merge_freeList+0x183>
  804035:	83 ec 04             	sub    $0x4,%esp
  804038:	68 84 52 80 00       	push   $0x805284
  80403d:	68 3f 01 00 00       	push   $0x13f
  804042:	68 a7 52 80 00       	push   $0x8052a7
  804047:	e8 43 d5 ff ff       	call   80158f <_panic>
  80404c:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804052:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804055:	89 10                	mov    %edx,(%eax)
  804057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80405a:	8b 00                	mov    (%eax),%eax
  80405c:	85 c0                	test   %eax,%eax
  80405e:	74 0d                	je     80406d <insert_sorted_with_merge_freeList+0x1a4>
  804060:	a1 48 61 80 00       	mov    0x806148,%eax
  804065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804068:	89 50 04             	mov    %edx,0x4(%eax)
  80406b:	eb 08                	jmp    804075 <insert_sorted_with_merge_freeList+0x1ac>
  80406d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804070:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804075:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804078:	a3 48 61 80 00       	mov    %eax,0x806148
  80407d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804080:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804087:	a1 54 61 80 00       	mov    0x806154,%eax
  80408c:	40                   	inc    %eax
  80408d:	a3 54 61 80 00       	mov    %eax,0x806154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  804092:	e9 7a 05 00 00       	jmp    804611 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  804097:	8b 45 08             	mov    0x8(%ebp),%eax
  80409a:	8b 50 08             	mov    0x8(%eax),%edx
  80409d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040a0:	8b 40 08             	mov    0x8(%eax),%eax
  8040a3:	39 c2                	cmp    %eax,%edx
  8040a5:	0f 82 14 01 00 00    	jb     8041bf <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8040ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040ae:	8b 50 08             	mov    0x8(%eax),%edx
  8040b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8040b7:	01 c2                	add    %eax,%edx
  8040b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8040bc:	8b 40 08             	mov    0x8(%eax),%eax
  8040bf:	39 c2                	cmp    %eax,%edx
  8040c1:	0f 85 90 00 00 00    	jne    804157 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8040c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040ca:	8b 50 0c             	mov    0xc(%eax),%edx
  8040cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8040d3:	01 c2                	add    %eax,%edx
  8040d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040d8:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8040db:	8b 45 08             	mov    0x8(%ebp),%eax
  8040de:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8040e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8040ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8040f3:	75 17                	jne    80410c <insert_sorted_with_merge_freeList+0x243>
  8040f5:	83 ec 04             	sub    $0x4,%esp
  8040f8:	68 84 52 80 00       	push   $0x805284
  8040fd:	68 49 01 00 00       	push   $0x149
  804102:	68 a7 52 80 00       	push   $0x8052a7
  804107:	e8 83 d4 ff ff       	call   80158f <_panic>
  80410c:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804112:	8b 45 08             	mov    0x8(%ebp),%eax
  804115:	89 10                	mov    %edx,(%eax)
  804117:	8b 45 08             	mov    0x8(%ebp),%eax
  80411a:	8b 00                	mov    (%eax),%eax
  80411c:	85 c0                	test   %eax,%eax
  80411e:	74 0d                	je     80412d <insert_sorted_with_merge_freeList+0x264>
  804120:	a1 48 61 80 00       	mov    0x806148,%eax
  804125:	8b 55 08             	mov    0x8(%ebp),%edx
  804128:	89 50 04             	mov    %edx,0x4(%eax)
  80412b:	eb 08                	jmp    804135 <insert_sorted_with_merge_freeList+0x26c>
  80412d:	8b 45 08             	mov    0x8(%ebp),%eax
  804130:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804135:	8b 45 08             	mov    0x8(%ebp),%eax
  804138:	a3 48 61 80 00       	mov    %eax,0x806148
  80413d:	8b 45 08             	mov    0x8(%ebp),%eax
  804140:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804147:	a1 54 61 80 00       	mov    0x806154,%eax
  80414c:	40                   	inc    %eax
  80414d:	a3 54 61 80 00       	mov    %eax,0x806154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804152:	e9 bb 04 00 00       	jmp    804612 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  804157:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80415b:	75 17                	jne    804174 <insert_sorted_with_merge_freeList+0x2ab>
  80415d:	83 ec 04             	sub    $0x4,%esp
  804160:	68 f8 52 80 00       	push   $0x8052f8
  804165:	68 4c 01 00 00       	push   $0x14c
  80416a:	68 a7 52 80 00       	push   $0x8052a7
  80416f:	e8 1b d4 ff ff       	call   80158f <_panic>
  804174:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  80417a:	8b 45 08             	mov    0x8(%ebp),%eax
  80417d:	89 50 04             	mov    %edx,0x4(%eax)
  804180:	8b 45 08             	mov    0x8(%ebp),%eax
  804183:	8b 40 04             	mov    0x4(%eax),%eax
  804186:	85 c0                	test   %eax,%eax
  804188:	74 0c                	je     804196 <insert_sorted_with_merge_freeList+0x2cd>
  80418a:	a1 3c 61 80 00       	mov    0x80613c,%eax
  80418f:	8b 55 08             	mov    0x8(%ebp),%edx
  804192:	89 10                	mov    %edx,(%eax)
  804194:	eb 08                	jmp    80419e <insert_sorted_with_merge_freeList+0x2d5>
  804196:	8b 45 08             	mov    0x8(%ebp),%eax
  804199:	a3 38 61 80 00       	mov    %eax,0x806138
  80419e:	8b 45 08             	mov    0x8(%ebp),%eax
  8041a1:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8041a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8041a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041af:	a1 44 61 80 00       	mov    0x806144,%eax
  8041b4:	40                   	inc    %eax
  8041b5:	a3 44 61 80 00       	mov    %eax,0x806144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8041ba:	e9 53 04 00 00       	jmp    804612 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8041bf:	a1 38 61 80 00       	mov    0x806138,%eax
  8041c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8041c7:	e9 15 04 00 00       	jmp    8045e1 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8041cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041cf:	8b 00                	mov    (%eax),%eax
  8041d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8041d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8041d7:	8b 50 08             	mov    0x8(%eax),%edx
  8041da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041dd:	8b 40 08             	mov    0x8(%eax),%eax
  8041e0:	39 c2                	cmp    %eax,%edx
  8041e2:	0f 86 f1 03 00 00    	jbe    8045d9 <insert_sorted_with_merge_freeList+0x710>
  8041e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8041eb:	8b 50 08             	mov    0x8(%eax),%edx
  8041ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041f1:	8b 40 08             	mov    0x8(%eax),%eax
  8041f4:	39 c2                	cmp    %eax,%edx
  8041f6:	0f 83 dd 03 00 00    	jae    8045d9 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8041fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041ff:	8b 50 08             	mov    0x8(%eax),%edx
  804202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804205:	8b 40 0c             	mov    0xc(%eax),%eax
  804208:	01 c2                	add    %eax,%edx
  80420a:	8b 45 08             	mov    0x8(%ebp),%eax
  80420d:	8b 40 08             	mov    0x8(%eax),%eax
  804210:	39 c2                	cmp    %eax,%edx
  804212:	0f 85 b9 01 00 00    	jne    8043d1 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  804218:	8b 45 08             	mov    0x8(%ebp),%eax
  80421b:	8b 50 08             	mov    0x8(%eax),%edx
  80421e:	8b 45 08             	mov    0x8(%ebp),%eax
  804221:	8b 40 0c             	mov    0xc(%eax),%eax
  804224:	01 c2                	add    %eax,%edx
  804226:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804229:	8b 40 08             	mov    0x8(%eax),%eax
  80422c:	39 c2                	cmp    %eax,%edx
  80422e:	0f 85 0d 01 00 00    	jne    804341 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  804234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804237:	8b 50 0c             	mov    0xc(%eax),%edx
  80423a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80423d:	8b 40 0c             	mov    0xc(%eax),%eax
  804240:	01 c2                	add    %eax,%edx
  804242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804245:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  804248:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80424c:	75 17                	jne    804265 <insert_sorted_with_merge_freeList+0x39c>
  80424e:	83 ec 04             	sub    $0x4,%esp
  804251:	68 50 53 80 00       	push   $0x805350
  804256:	68 5c 01 00 00       	push   $0x15c
  80425b:	68 a7 52 80 00       	push   $0x8052a7
  804260:	e8 2a d3 ff ff       	call   80158f <_panic>
  804265:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804268:	8b 00                	mov    (%eax),%eax
  80426a:	85 c0                	test   %eax,%eax
  80426c:	74 10                	je     80427e <insert_sorted_with_merge_freeList+0x3b5>
  80426e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804271:	8b 00                	mov    (%eax),%eax
  804273:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804276:	8b 52 04             	mov    0x4(%edx),%edx
  804279:	89 50 04             	mov    %edx,0x4(%eax)
  80427c:	eb 0b                	jmp    804289 <insert_sorted_with_merge_freeList+0x3c0>
  80427e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804281:	8b 40 04             	mov    0x4(%eax),%eax
  804284:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80428c:	8b 40 04             	mov    0x4(%eax),%eax
  80428f:	85 c0                	test   %eax,%eax
  804291:	74 0f                	je     8042a2 <insert_sorted_with_merge_freeList+0x3d9>
  804293:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804296:	8b 40 04             	mov    0x4(%eax),%eax
  804299:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80429c:	8b 12                	mov    (%edx),%edx
  80429e:	89 10                	mov    %edx,(%eax)
  8042a0:	eb 0a                	jmp    8042ac <insert_sorted_with_merge_freeList+0x3e3>
  8042a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042a5:	8b 00                	mov    (%eax),%eax
  8042a7:	a3 38 61 80 00       	mov    %eax,0x806138
  8042ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042bf:	a1 44 61 80 00       	mov    0x806144,%eax
  8042c4:	48                   	dec    %eax
  8042c5:	a3 44 61 80 00       	mov    %eax,0x806144
						nextBlock->sva = 0;
  8042ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042cd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8042d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8042d7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8042de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8042e2:	75 17                	jne    8042fb <insert_sorted_with_merge_freeList+0x432>
  8042e4:	83 ec 04             	sub    $0x4,%esp
  8042e7:	68 84 52 80 00       	push   $0x805284
  8042ec:	68 5f 01 00 00       	push   $0x15f
  8042f1:	68 a7 52 80 00       	push   $0x8052a7
  8042f6:	e8 94 d2 ff ff       	call   80158f <_panic>
  8042fb:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804304:	89 10                	mov    %edx,(%eax)
  804306:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804309:	8b 00                	mov    (%eax),%eax
  80430b:	85 c0                	test   %eax,%eax
  80430d:	74 0d                	je     80431c <insert_sorted_with_merge_freeList+0x453>
  80430f:	a1 48 61 80 00       	mov    0x806148,%eax
  804314:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804317:	89 50 04             	mov    %edx,0x4(%eax)
  80431a:	eb 08                	jmp    804324 <insert_sorted_with_merge_freeList+0x45b>
  80431c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80431f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804324:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804327:	a3 48 61 80 00       	mov    %eax,0x806148
  80432c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80432f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804336:	a1 54 61 80 00       	mov    0x806154,%eax
  80433b:	40                   	inc    %eax
  80433c:	a3 54 61 80 00       	mov    %eax,0x806154
					}
					currentBlock->size += blockToInsert->size;
  804341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804344:	8b 50 0c             	mov    0xc(%eax),%edx
  804347:	8b 45 08             	mov    0x8(%ebp),%eax
  80434a:	8b 40 0c             	mov    0xc(%eax),%eax
  80434d:	01 c2                	add    %eax,%edx
  80434f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804352:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  804355:	8b 45 08             	mov    0x8(%ebp),%eax
  804358:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80435f:	8b 45 08             	mov    0x8(%ebp),%eax
  804362:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  804369:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80436d:	75 17                	jne    804386 <insert_sorted_with_merge_freeList+0x4bd>
  80436f:	83 ec 04             	sub    $0x4,%esp
  804372:	68 84 52 80 00       	push   $0x805284
  804377:	68 64 01 00 00       	push   $0x164
  80437c:	68 a7 52 80 00       	push   $0x8052a7
  804381:	e8 09 d2 ff ff       	call   80158f <_panic>
  804386:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80438c:	8b 45 08             	mov    0x8(%ebp),%eax
  80438f:	89 10                	mov    %edx,(%eax)
  804391:	8b 45 08             	mov    0x8(%ebp),%eax
  804394:	8b 00                	mov    (%eax),%eax
  804396:	85 c0                	test   %eax,%eax
  804398:	74 0d                	je     8043a7 <insert_sorted_with_merge_freeList+0x4de>
  80439a:	a1 48 61 80 00       	mov    0x806148,%eax
  80439f:	8b 55 08             	mov    0x8(%ebp),%edx
  8043a2:	89 50 04             	mov    %edx,0x4(%eax)
  8043a5:	eb 08                	jmp    8043af <insert_sorted_with_merge_freeList+0x4e6>
  8043a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8043aa:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8043af:	8b 45 08             	mov    0x8(%ebp),%eax
  8043b2:	a3 48 61 80 00       	mov    %eax,0x806148
  8043b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8043ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043c1:	a1 54 61 80 00       	mov    0x806154,%eax
  8043c6:	40                   	inc    %eax
  8043c7:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  8043cc:	e9 41 02 00 00       	jmp    804612 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8043d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8043d4:	8b 50 08             	mov    0x8(%eax),%edx
  8043d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8043da:	8b 40 0c             	mov    0xc(%eax),%eax
  8043dd:	01 c2                	add    %eax,%edx
  8043df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8043e2:	8b 40 08             	mov    0x8(%eax),%eax
  8043e5:	39 c2                	cmp    %eax,%edx
  8043e7:	0f 85 7c 01 00 00    	jne    804569 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8043ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8043f1:	74 06                	je     8043f9 <insert_sorted_with_merge_freeList+0x530>
  8043f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8043f7:	75 17                	jne    804410 <insert_sorted_with_merge_freeList+0x547>
  8043f9:	83 ec 04             	sub    $0x4,%esp
  8043fc:	68 c0 52 80 00       	push   $0x8052c0
  804401:	68 69 01 00 00       	push   $0x169
  804406:	68 a7 52 80 00       	push   $0x8052a7
  80440b:	e8 7f d1 ff ff       	call   80158f <_panic>
  804410:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804413:	8b 50 04             	mov    0x4(%eax),%edx
  804416:	8b 45 08             	mov    0x8(%ebp),%eax
  804419:	89 50 04             	mov    %edx,0x4(%eax)
  80441c:	8b 45 08             	mov    0x8(%ebp),%eax
  80441f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804422:	89 10                	mov    %edx,(%eax)
  804424:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804427:	8b 40 04             	mov    0x4(%eax),%eax
  80442a:	85 c0                	test   %eax,%eax
  80442c:	74 0d                	je     80443b <insert_sorted_with_merge_freeList+0x572>
  80442e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804431:	8b 40 04             	mov    0x4(%eax),%eax
  804434:	8b 55 08             	mov    0x8(%ebp),%edx
  804437:	89 10                	mov    %edx,(%eax)
  804439:	eb 08                	jmp    804443 <insert_sorted_with_merge_freeList+0x57a>
  80443b:	8b 45 08             	mov    0x8(%ebp),%eax
  80443e:	a3 38 61 80 00       	mov    %eax,0x806138
  804443:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804446:	8b 55 08             	mov    0x8(%ebp),%edx
  804449:	89 50 04             	mov    %edx,0x4(%eax)
  80444c:	a1 44 61 80 00       	mov    0x806144,%eax
  804451:	40                   	inc    %eax
  804452:	a3 44 61 80 00       	mov    %eax,0x806144
					blockToInsert->size += nextBlock->size;
  804457:	8b 45 08             	mov    0x8(%ebp),%eax
  80445a:	8b 50 0c             	mov    0xc(%eax),%edx
  80445d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804460:	8b 40 0c             	mov    0xc(%eax),%eax
  804463:	01 c2                	add    %eax,%edx
  804465:	8b 45 08             	mov    0x8(%ebp),%eax
  804468:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80446b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80446f:	75 17                	jne    804488 <insert_sorted_with_merge_freeList+0x5bf>
  804471:	83 ec 04             	sub    $0x4,%esp
  804474:	68 50 53 80 00       	push   $0x805350
  804479:	68 6b 01 00 00       	push   $0x16b
  80447e:	68 a7 52 80 00       	push   $0x8052a7
  804483:	e8 07 d1 ff ff       	call   80158f <_panic>
  804488:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80448b:	8b 00                	mov    (%eax),%eax
  80448d:	85 c0                	test   %eax,%eax
  80448f:	74 10                	je     8044a1 <insert_sorted_with_merge_freeList+0x5d8>
  804491:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804494:	8b 00                	mov    (%eax),%eax
  804496:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804499:	8b 52 04             	mov    0x4(%edx),%edx
  80449c:	89 50 04             	mov    %edx,0x4(%eax)
  80449f:	eb 0b                	jmp    8044ac <insert_sorted_with_merge_freeList+0x5e3>
  8044a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044a4:	8b 40 04             	mov    0x4(%eax),%eax
  8044a7:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8044ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044af:	8b 40 04             	mov    0x4(%eax),%eax
  8044b2:	85 c0                	test   %eax,%eax
  8044b4:	74 0f                	je     8044c5 <insert_sorted_with_merge_freeList+0x5fc>
  8044b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044b9:	8b 40 04             	mov    0x4(%eax),%eax
  8044bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8044bf:	8b 12                	mov    (%edx),%edx
  8044c1:	89 10                	mov    %edx,(%eax)
  8044c3:	eb 0a                	jmp    8044cf <insert_sorted_with_merge_freeList+0x606>
  8044c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044c8:	8b 00                	mov    (%eax),%eax
  8044ca:	a3 38 61 80 00       	mov    %eax,0x806138
  8044cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8044e2:	a1 44 61 80 00       	mov    0x806144,%eax
  8044e7:	48                   	dec    %eax
  8044e8:	a3 44 61 80 00       	mov    %eax,0x806144
					nextBlock->sva = 0;
  8044ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8044f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8044fa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  804501:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  804505:	75 17                	jne    80451e <insert_sorted_with_merge_freeList+0x655>
  804507:	83 ec 04             	sub    $0x4,%esp
  80450a:	68 84 52 80 00       	push   $0x805284
  80450f:	68 6e 01 00 00       	push   $0x16e
  804514:	68 a7 52 80 00       	push   $0x8052a7
  804519:	e8 71 d0 ff ff       	call   80158f <_panic>
  80451e:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804524:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804527:	89 10                	mov    %edx,(%eax)
  804529:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80452c:	8b 00                	mov    (%eax),%eax
  80452e:	85 c0                	test   %eax,%eax
  804530:	74 0d                	je     80453f <insert_sorted_with_merge_freeList+0x676>
  804532:	a1 48 61 80 00       	mov    0x806148,%eax
  804537:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80453a:	89 50 04             	mov    %edx,0x4(%eax)
  80453d:	eb 08                	jmp    804547 <insert_sorted_with_merge_freeList+0x67e>
  80453f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804542:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804547:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80454a:	a3 48 61 80 00       	mov    %eax,0x806148
  80454f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804552:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804559:	a1 54 61 80 00       	mov    0x806154,%eax
  80455e:	40                   	inc    %eax
  80455f:	a3 54 61 80 00       	mov    %eax,0x806154
					break;
  804564:	e9 a9 00 00 00       	jmp    804612 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  804569:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80456d:	74 06                	je     804575 <insert_sorted_with_merge_freeList+0x6ac>
  80456f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804573:	75 17                	jne    80458c <insert_sorted_with_merge_freeList+0x6c3>
  804575:	83 ec 04             	sub    $0x4,%esp
  804578:	68 1c 53 80 00       	push   $0x80531c
  80457d:	68 73 01 00 00       	push   $0x173
  804582:	68 a7 52 80 00       	push   $0x8052a7
  804587:	e8 03 d0 ff ff       	call   80158f <_panic>
  80458c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80458f:	8b 10                	mov    (%eax),%edx
  804591:	8b 45 08             	mov    0x8(%ebp),%eax
  804594:	89 10                	mov    %edx,(%eax)
  804596:	8b 45 08             	mov    0x8(%ebp),%eax
  804599:	8b 00                	mov    (%eax),%eax
  80459b:	85 c0                	test   %eax,%eax
  80459d:	74 0b                	je     8045aa <insert_sorted_with_merge_freeList+0x6e1>
  80459f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045a2:	8b 00                	mov    (%eax),%eax
  8045a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8045a7:	89 50 04             	mov    %edx,0x4(%eax)
  8045aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8045b0:	89 10                	mov    %edx,(%eax)
  8045b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8045b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8045b8:	89 50 04             	mov    %edx,0x4(%eax)
  8045bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8045be:	8b 00                	mov    (%eax),%eax
  8045c0:	85 c0                	test   %eax,%eax
  8045c2:	75 08                	jne    8045cc <insert_sorted_with_merge_freeList+0x703>
  8045c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8045c7:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8045cc:	a1 44 61 80 00       	mov    0x806144,%eax
  8045d1:	40                   	inc    %eax
  8045d2:	a3 44 61 80 00       	mov    %eax,0x806144
					break;
  8045d7:	eb 39                	jmp    804612 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8045d9:	a1 40 61 80 00       	mov    0x806140,%eax
  8045de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8045e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8045e5:	74 07                	je     8045ee <insert_sorted_with_merge_freeList+0x725>
  8045e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045ea:	8b 00                	mov    (%eax),%eax
  8045ec:	eb 05                	jmp    8045f3 <insert_sorted_with_merge_freeList+0x72a>
  8045ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8045f3:	a3 40 61 80 00       	mov    %eax,0x806140
  8045f8:	a1 40 61 80 00       	mov    0x806140,%eax
  8045fd:	85 c0                	test   %eax,%eax
  8045ff:	0f 85 c7 fb ff ff    	jne    8041cc <insert_sorted_with_merge_freeList+0x303>
  804605:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804609:	0f 85 bd fb ff ff    	jne    8041cc <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80460f:	eb 01                	jmp    804612 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  804611:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804612:	90                   	nop
  804613:	c9                   	leave  
  804614:	c3                   	ret    
  804615:	66 90                	xchg   %ax,%ax
  804617:	90                   	nop

00804618 <__udivdi3>:
  804618:	55                   	push   %ebp
  804619:	57                   	push   %edi
  80461a:	56                   	push   %esi
  80461b:	53                   	push   %ebx
  80461c:	83 ec 1c             	sub    $0x1c,%esp
  80461f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804623:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804627:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80462b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80462f:	89 ca                	mov    %ecx,%edx
  804631:	89 f8                	mov    %edi,%eax
  804633:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804637:	85 f6                	test   %esi,%esi
  804639:	75 2d                	jne    804668 <__udivdi3+0x50>
  80463b:	39 cf                	cmp    %ecx,%edi
  80463d:	77 65                	ja     8046a4 <__udivdi3+0x8c>
  80463f:	89 fd                	mov    %edi,%ebp
  804641:	85 ff                	test   %edi,%edi
  804643:	75 0b                	jne    804650 <__udivdi3+0x38>
  804645:	b8 01 00 00 00       	mov    $0x1,%eax
  80464a:	31 d2                	xor    %edx,%edx
  80464c:	f7 f7                	div    %edi
  80464e:	89 c5                	mov    %eax,%ebp
  804650:	31 d2                	xor    %edx,%edx
  804652:	89 c8                	mov    %ecx,%eax
  804654:	f7 f5                	div    %ebp
  804656:	89 c1                	mov    %eax,%ecx
  804658:	89 d8                	mov    %ebx,%eax
  80465a:	f7 f5                	div    %ebp
  80465c:	89 cf                	mov    %ecx,%edi
  80465e:	89 fa                	mov    %edi,%edx
  804660:	83 c4 1c             	add    $0x1c,%esp
  804663:	5b                   	pop    %ebx
  804664:	5e                   	pop    %esi
  804665:	5f                   	pop    %edi
  804666:	5d                   	pop    %ebp
  804667:	c3                   	ret    
  804668:	39 ce                	cmp    %ecx,%esi
  80466a:	77 28                	ja     804694 <__udivdi3+0x7c>
  80466c:	0f bd fe             	bsr    %esi,%edi
  80466f:	83 f7 1f             	xor    $0x1f,%edi
  804672:	75 40                	jne    8046b4 <__udivdi3+0x9c>
  804674:	39 ce                	cmp    %ecx,%esi
  804676:	72 0a                	jb     804682 <__udivdi3+0x6a>
  804678:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80467c:	0f 87 9e 00 00 00    	ja     804720 <__udivdi3+0x108>
  804682:	b8 01 00 00 00       	mov    $0x1,%eax
  804687:	89 fa                	mov    %edi,%edx
  804689:	83 c4 1c             	add    $0x1c,%esp
  80468c:	5b                   	pop    %ebx
  80468d:	5e                   	pop    %esi
  80468e:	5f                   	pop    %edi
  80468f:	5d                   	pop    %ebp
  804690:	c3                   	ret    
  804691:	8d 76 00             	lea    0x0(%esi),%esi
  804694:	31 ff                	xor    %edi,%edi
  804696:	31 c0                	xor    %eax,%eax
  804698:	89 fa                	mov    %edi,%edx
  80469a:	83 c4 1c             	add    $0x1c,%esp
  80469d:	5b                   	pop    %ebx
  80469e:	5e                   	pop    %esi
  80469f:	5f                   	pop    %edi
  8046a0:	5d                   	pop    %ebp
  8046a1:	c3                   	ret    
  8046a2:	66 90                	xchg   %ax,%ax
  8046a4:	89 d8                	mov    %ebx,%eax
  8046a6:	f7 f7                	div    %edi
  8046a8:	31 ff                	xor    %edi,%edi
  8046aa:	89 fa                	mov    %edi,%edx
  8046ac:	83 c4 1c             	add    $0x1c,%esp
  8046af:	5b                   	pop    %ebx
  8046b0:	5e                   	pop    %esi
  8046b1:	5f                   	pop    %edi
  8046b2:	5d                   	pop    %ebp
  8046b3:	c3                   	ret    
  8046b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8046b9:	89 eb                	mov    %ebp,%ebx
  8046bb:	29 fb                	sub    %edi,%ebx
  8046bd:	89 f9                	mov    %edi,%ecx
  8046bf:	d3 e6                	shl    %cl,%esi
  8046c1:	89 c5                	mov    %eax,%ebp
  8046c3:	88 d9                	mov    %bl,%cl
  8046c5:	d3 ed                	shr    %cl,%ebp
  8046c7:	89 e9                	mov    %ebp,%ecx
  8046c9:	09 f1                	or     %esi,%ecx
  8046cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8046cf:	89 f9                	mov    %edi,%ecx
  8046d1:	d3 e0                	shl    %cl,%eax
  8046d3:	89 c5                	mov    %eax,%ebp
  8046d5:	89 d6                	mov    %edx,%esi
  8046d7:	88 d9                	mov    %bl,%cl
  8046d9:	d3 ee                	shr    %cl,%esi
  8046db:	89 f9                	mov    %edi,%ecx
  8046dd:	d3 e2                	shl    %cl,%edx
  8046df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046e3:	88 d9                	mov    %bl,%cl
  8046e5:	d3 e8                	shr    %cl,%eax
  8046e7:	09 c2                	or     %eax,%edx
  8046e9:	89 d0                	mov    %edx,%eax
  8046eb:	89 f2                	mov    %esi,%edx
  8046ed:	f7 74 24 0c          	divl   0xc(%esp)
  8046f1:	89 d6                	mov    %edx,%esi
  8046f3:	89 c3                	mov    %eax,%ebx
  8046f5:	f7 e5                	mul    %ebp
  8046f7:	39 d6                	cmp    %edx,%esi
  8046f9:	72 19                	jb     804714 <__udivdi3+0xfc>
  8046fb:	74 0b                	je     804708 <__udivdi3+0xf0>
  8046fd:	89 d8                	mov    %ebx,%eax
  8046ff:	31 ff                	xor    %edi,%edi
  804701:	e9 58 ff ff ff       	jmp    80465e <__udivdi3+0x46>
  804706:	66 90                	xchg   %ax,%ax
  804708:	8b 54 24 08          	mov    0x8(%esp),%edx
  80470c:	89 f9                	mov    %edi,%ecx
  80470e:	d3 e2                	shl    %cl,%edx
  804710:	39 c2                	cmp    %eax,%edx
  804712:	73 e9                	jae    8046fd <__udivdi3+0xe5>
  804714:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804717:	31 ff                	xor    %edi,%edi
  804719:	e9 40 ff ff ff       	jmp    80465e <__udivdi3+0x46>
  80471e:	66 90                	xchg   %ax,%ax
  804720:	31 c0                	xor    %eax,%eax
  804722:	e9 37 ff ff ff       	jmp    80465e <__udivdi3+0x46>
  804727:	90                   	nop

00804728 <__umoddi3>:
  804728:	55                   	push   %ebp
  804729:	57                   	push   %edi
  80472a:	56                   	push   %esi
  80472b:	53                   	push   %ebx
  80472c:	83 ec 1c             	sub    $0x1c,%esp
  80472f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804733:	8b 74 24 34          	mov    0x34(%esp),%esi
  804737:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80473b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80473f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804743:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804747:	89 f3                	mov    %esi,%ebx
  804749:	89 fa                	mov    %edi,%edx
  80474b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80474f:	89 34 24             	mov    %esi,(%esp)
  804752:	85 c0                	test   %eax,%eax
  804754:	75 1a                	jne    804770 <__umoddi3+0x48>
  804756:	39 f7                	cmp    %esi,%edi
  804758:	0f 86 a2 00 00 00    	jbe    804800 <__umoddi3+0xd8>
  80475e:	89 c8                	mov    %ecx,%eax
  804760:	89 f2                	mov    %esi,%edx
  804762:	f7 f7                	div    %edi
  804764:	89 d0                	mov    %edx,%eax
  804766:	31 d2                	xor    %edx,%edx
  804768:	83 c4 1c             	add    $0x1c,%esp
  80476b:	5b                   	pop    %ebx
  80476c:	5e                   	pop    %esi
  80476d:	5f                   	pop    %edi
  80476e:	5d                   	pop    %ebp
  80476f:	c3                   	ret    
  804770:	39 f0                	cmp    %esi,%eax
  804772:	0f 87 ac 00 00 00    	ja     804824 <__umoddi3+0xfc>
  804778:	0f bd e8             	bsr    %eax,%ebp
  80477b:	83 f5 1f             	xor    $0x1f,%ebp
  80477e:	0f 84 ac 00 00 00    	je     804830 <__umoddi3+0x108>
  804784:	bf 20 00 00 00       	mov    $0x20,%edi
  804789:	29 ef                	sub    %ebp,%edi
  80478b:	89 fe                	mov    %edi,%esi
  80478d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804791:	89 e9                	mov    %ebp,%ecx
  804793:	d3 e0                	shl    %cl,%eax
  804795:	89 d7                	mov    %edx,%edi
  804797:	89 f1                	mov    %esi,%ecx
  804799:	d3 ef                	shr    %cl,%edi
  80479b:	09 c7                	or     %eax,%edi
  80479d:	89 e9                	mov    %ebp,%ecx
  80479f:	d3 e2                	shl    %cl,%edx
  8047a1:	89 14 24             	mov    %edx,(%esp)
  8047a4:	89 d8                	mov    %ebx,%eax
  8047a6:	d3 e0                	shl    %cl,%eax
  8047a8:	89 c2                	mov    %eax,%edx
  8047aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047ae:	d3 e0                	shl    %cl,%eax
  8047b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8047b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8047b8:	89 f1                	mov    %esi,%ecx
  8047ba:	d3 e8                	shr    %cl,%eax
  8047bc:	09 d0                	or     %edx,%eax
  8047be:	d3 eb                	shr    %cl,%ebx
  8047c0:	89 da                	mov    %ebx,%edx
  8047c2:	f7 f7                	div    %edi
  8047c4:	89 d3                	mov    %edx,%ebx
  8047c6:	f7 24 24             	mull   (%esp)
  8047c9:	89 c6                	mov    %eax,%esi
  8047cb:	89 d1                	mov    %edx,%ecx
  8047cd:	39 d3                	cmp    %edx,%ebx
  8047cf:	0f 82 87 00 00 00    	jb     80485c <__umoddi3+0x134>
  8047d5:	0f 84 91 00 00 00    	je     80486c <__umoddi3+0x144>
  8047db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8047df:	29 f2                	sub    %esi,%edx
  8047e1:	19 cb                	sbb    %ecx,%ebx
  8047e3:	89 d8                	mov    %ebx,%eax
  8047e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8047e9:	d3 e0                	shl    %cl,%eax
  8047eb:	89 e9                	mov    %ebp,%ecx
  8047ed:	d3 ea                	shr    %cl,%edx
  8047ef:	09 d0                	or     %edx,%eax
  8047f1:	89 e9                	mov    %ebp,%ecx
  8047f3:	d3 eb                	shr    %cl,%ebx
  8047f5:	89 da                	mov    %ebx,%edx
  8047f7:	83 c4 1c             	add    $0x1c,%esp
  8047fa:	5b                   	pop    %ebx
  8047fb:	5e                   	pop    %esi
  8047fc:	5f                   	pop    %edi
  8047fd:	5d                   	pop    %ebp
  8047fe:	c3                   	ret    
  8047ff:	90                   	nop
  804800:	89 fd                	mov    %edi,%ebp
  804802:	85 ff                	test   %edi,%edi
  804804:	75 0b                	jne    804811 <__umoddi3+0xe9>
  804806:	b8 01 00 00 00       	mov    $0x1,%eax
  80480b:	31 d2                	xor    %edx,%edx
  80480d:	f7 f7                	div    %edi
  80480f:	89 c5                	mov    %eax,%ebp
  804811:	89 f0                	mov    %esi,%eax
  804813:	31 d2                	xor    %edx,%edx
  804815:	f7 f5                	div    %ebp
  804817:	89 c8                	mov    %ecx,%eax
  804819:	f7 f5                	div    %ebp
  80481b:	89 d0                	mov    %edx,%eax
  80481d:	e9 44 ff ff ff       	jmp    804766 <__umoddi3+0x3e>
  804822:	66 90                	xchg   %ax,%ax
  804824:	89 c8                	mov    %ecx,%eax
  804826:	89 f2                	mov    %esi,%edx
  804828:	83 c4 1c             	add    $0x1c,%esp
  80482b:	5b                   	pop    %ebx
  80482c:	5e                   	pop    %esi
  80482d:	5f                   	pop    %edi
  80482e:	5d                   	pop    %ebp
  80482f:	c3                   	ret    
  804830:	3b 04 24             	cmp    (%esp),%eax
  804833:	72 06                	jb     80483b <__umoddi3+0x113>
  804835:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804839:	77 0f                	ja     80484a <__umoddi3+0x122>
  80483b:	89 f2                	mov    %esi,%edx
  80483d:	29 f9                	sub    %edi,%ecx
  80483f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804843:	89 14 24             	mov    %edx,(%esp)
  804846:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80484a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80484e:	8b 14 24             	mov    (%esp),%edx
  804851:	83 c4 1c             	add    $0x1c,%esp
  804854:	5b                   	pop    %ebx
  804855:	5e                   	pop    %esi
  804856:	5f                   	pop    %edi
  804857:	5d                   	pop    %ebp
  804858:	c3                   	ret    
  804859:	8d 76 00             	lea    0x0(%esi),%esi
  80485c:	2b 04 24             	sub    (%esp),%eax
  80485f:	19 fa                	sbb    %edi,%edx
  804861:	89 d1                	mov    %edx,%ecx
  804863:	89 c6                	mov    %eax,%esi
  804865:	e9 71 ff ff ff       	jmp    8047db <__umoddi3+0xb3>
  80486a:	66 90                	xchg   %ax,%ax
  80486c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804870:	72 ea                	jb     80485c <__umoddi3+0x134>
  804872:	89 d9                	mov    %ebx,%ecx
  804874:	e9 62 ff ff ff       	jmp    8047db <__umoddi3+0xb3>
