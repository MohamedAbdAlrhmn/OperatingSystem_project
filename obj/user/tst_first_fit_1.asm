
obj/user/tst_first_fit_1:     file format elf32-i386


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
  800031:	e8 38 0b 00 00       	call   800b6e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	83 ec 74             	sub    $0x74,%esp
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  80003f:	83 ec 0c             	sub    $0xc,%esp
  800042:	6a 01                	push   $0x1
  800044:	e8 3a 26 00 00       	call   802683 <sys_set_uheap_strategy>
  800049:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004c:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800050:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800057:	eb 29                	jmp    800082 <_main+0x4a>
		{
			if (myEnv->__uptr_pws[i].empty)
  800059:	a1 20 50 80 00       	mov    0x805020,%eax
  80005e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800064:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800067:	89 d0                	mov    %edx,%eax
  800069:	01 c0                	add    %eax,%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c1 e0 03             	shl    $0x3,%eax
  800070:	01 c8                	add    %ecx,%eax
  800072:	8a 40 04             	mov    0x4(%eax),%al
  800075:	84 c0                	test   %al,%al
  800077:	74 06                	je     80007f <_main+0x47>
			{
				fullWS = 0;
  800079:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007d:	eb 12                	jmp    800091 <_main+0x59>
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80007f:	ff 45 f0             	incl   -0x10(%ebp)
  800082:	a1 20 50 80 00       	mov    0x805020,%eax
  800087:	8b 50 74             	mov    0x74(%eax),%edx
  80008a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008d:	39 c2                	cmp    %eax,%edx
  80008f:	77 c8                	ja     800059 <_main+0x21>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800091:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800095:	74 14                	je     8000ab <_main+0x73>
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 a0 3f 80 00       	push   $0x803fa0
  80009f:	6a 15                	push   $0x15
  8000a1:	68 bc 3f 80 00       	push   $0x803fbc
  8000a6:	e8 ff 0b 00 00       	call   800caa <_panic>
	}

	int Mega = 1024*1024;
  8000ab:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	6a 00                	push   $0x0
  8000be:	e8 23 1e 00 00       	call   801ee6 <malloc>
  8000c3:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	void* ptr_allocations[20] = {0};
  8000c6:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000c9:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	89 d7                	mov    %edx,%edi
  8000d5:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d7:	e8 92 20 00 00       	call   80216e <sys_calculate_free_frames>
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000df:	e8 2a 21 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  8000e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ea:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	50                   	push   %eax
  8000f1:	e8 f0 1d 00 00       	call   801ee6 <malloc>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8000fc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ff:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800104:	74 14                	je     80011a <_main+0xe2>
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	68 d4 3f 80 00       	push   $0x803fd4
  80010e:	6a 26                	push   $0x26
  800110:	68 bc 3f 80 00       	push   $0x803fbc
  800115:	e8 90 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80011a:	e8 ef 20 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  80011f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 04 40 80 00       	push   $0x804004
  80012c:	6a 28                	push   $0x28
  80012e:	68 bc 3f 80 00       	push   $0x803fbc
  800133:	e8 72 0b 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800138:	e8 31 20 00 00       	call   80216e <sys_calculate_free_frames>
  80013d:	89 c2                	mov    %eax,%edx
  80013f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800142:	39 c2                	cmp    %eax,%edx
  800144:	74 14                	je     80015a <_main+0x122>
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	68 21 40 80 00       	push   $0x804021
  80014e:	6a 29                	push   $0x29
  800150:	68 bc 3f 80 00       	push   $0x803fbc
  800155:	e8 50 0b 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80015a:	e8 0f 20 00 00       	call   80216e <sys_calculate_free_frames>
  80015f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800162:	e8 a7 20 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80016a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	50                   	push   %eax
  800174:	e8 6d 1d 00 00       	call   801ee6 <malloc>
  800179:	83 c4 10             	add    $0x10,%esp
  80017c:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80017f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800182:	89 c2                	mov    %eax,%edx
  800184:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800187:	05 00 00 00 80       	add    $0x80000000,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	74 14                	je     8001a4 <_main+0x16c>
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	68 d4 3f 80 00       	push   $0x803fd4
  800198:	6a 2f                	push   $0x2f
  80019a:	68 bc 3f 80 00       	push   $0x803fbc
  80019f:	e8 06 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001a4:	e8 65 20 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  8001a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 04 40 80 00       	push   $0x804004
  8001b6:	6a 31                	push   $0x31
  8001b8:	68 bc 3f 80 00       	push   $0x803fbc
  8001bd:	e8 e8 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001c2:	e8 a7 1f 00 00       	call   80216e <sys_calculate_free_frames>
  8001c7:	89 c2                	mov    %eax,%edx
  8001c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 21 40 80 00       	push   $0x804021
  8001d8:	6a 32                	push   $0x32
  8001da:	68 bc 3f 80 00       	push   $0x803fbc
  8001df:	e8 c6 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001e4:	e8 85 1f 00 00       	call   80216e <sys_calculate_free_frames>
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001ec:	e8 1d 20 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  8001f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	50                   	push   %eax
  8001fe:	e8 e3 1c 00 00       	call   801ee6 <malloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800209:	8b 45 98             	mov    -0x68(%ebp),%eax
  80020c:	89 c2                	mov    %eax,%edx
  80020e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	05 00 00 00 80       	add    $0x80000000,%eax
  800218:	39 c2                	cmp    %eax,%edx
  80021a:	74 14                	je     800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 d4 3f 80 00       	push   $0x803fd4
  800224:	6a 38                	push   $0x38
  800226:	68 bc 3f 80 00       	push   $0x803fbc
  80022b:	e8 7a 0a 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800230:	e8 d9 1f 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800235:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800238:	74 14                	je     80024e <_main+0x216>
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	68 04 40 80 00       	push   $0x804004
  800242:	6a 3a                	push   $0x3a
  800244:	68 bc 3f 80 00       	push   $0x803fbc
  800249:	e8 5c 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80024e:	e8 1b 1f 00 00       	call   80216e <sys_calculate_free_frames>
  800253:	89 c2                	mov    %eax,%edx
  800255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800258:	39 c2                	cmp    %eax,%edx
  80025a:	74 14                	je     800270 <_main+0x238>
  80025c:	83 ec 04             	sub    $0x4,%esp
  80025f:	68 21 40 80 00       	push   $0x804021
  800264:	6a 3b                	push   $0x3b
  800266:	68 bc 3f 80 00       	push   $0x803fbc
  80026b:	e8 3a 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800270:	e8 f9 1e 00 00       	call   80216e <sys_calculate_free_frames>
  800275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800278:	e8 91 1f 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  80027d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800280:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800283:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 57 1c 00 00       	call   801ee6 <malloc>
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  800295:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800298:	89 c1                	mov    %eax,%ecx
  80029a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80029d:	89 c2                	mov    %eax,%edx
  80029f:	01 d2                	add    %edx,%edx
  8002a1:	01 d0                	add    %edx,%eax
  8002a3:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a8:	39 c1                	cmp    %eax,%ecx
  8002aa:	74 14                	je     8002c0 <_main+0x288>
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 d4 3f 80 00       	push   $0x803fd4
  8002b4:	6a 41                	push   $0x41
  8002b6:	68 bc 3f 80 00       	push   $0x803fbc
  8002bb:	e8 ea 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002c0:	e8 49 1f 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  8002c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c8:	74 14                	je     8002de <_main+0x2a6>
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	68 04 40 80 00       	push   $0x804004
  8002d2:	6a 43                	push   $0x43
  8002d4:	68 bc 3f 80 00       	push   $0x803fbc
  8002d9:	e8 cc 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002de:	e8 8b 1e 00 00       	call   80216e <sys_calculate_free_frames>
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e8:	39 c2                	cmp    %eax,%edx
  8002ea:	74 14                	je     800300 <_main+0x2c8>
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	68 21 40 80 00       	push   $0x804021
  8002f4:	6a 44                	push   $0x44
  8002f6:	68 bc 3f 80 00       	push   $0x803fbc
  8002fb:	e8 aa 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800300:	e8 69 1e 00 00       	call   80216e <sys_calculate_free_frames>
  800305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800308:	e8 01 1f 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  80030d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	50                   	push   %eax
  80031c:	e8 c5 1b 00 00       	call   801ee6 <malloc>
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800327:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032a:	89 c2                	mov    %eax,%edx
  80032c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032f:	c1 e0 02             	shl    $0x2,%eax
  800332:	05 00 00 00 80       	add    $0x80000000,%eax
  800337:	39 c2                	cmp    %eax,%edx
  800339:	74 14                	je     80034f <_main+0x317>
  80033b:	83 ec 04             	sub    $0x4,%esp
  80033e:	68 d4 3f 80 00       	push   $0x803fd4
  800343:	6a 4a                	push   $0x4a
  800345:	68 bc 3f 80 00       	push   $0x803fbc
  80034a:	e8 5b 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80034f:	e8 ba 1e 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800354:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800357:	74 14                	je     80036d <_main+0x335>
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	68 04 40 80 00       	push   $0x804004
  800361:	6a 4c                	push   $0x4c
  800363:	68 bc 3f 80 00       	push   $0x803fbc
  800368:	e8 3d 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80036d:	e8 fc 1d 00 00       	call   80216e <sys_calculate_free_frames>
  800372:	89 c2                	mov    %eax,%edx
  800374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800377:	39 c2                	cmp    %eax,%edx
  800379:	74 14                	je     80038f <_main+0x357>
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	68 21 40 80 00       	push   $0x804021
  800383:	6a 4d                	push   $0x4d
  800385:	68 bc 3f 80 00       	push   $0x803fbc
  80038a:	e8 1b 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80038f:	e8 da 1d 00 00       	call   80216e <sys_calculate_free_frames>
  800394:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800397:	e8 72 1e 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  80039c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  80039f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	50                   	push   %eax
  8003ab:	e8 36 1b 00 00       	call   801ee6 <malloc>
  8003b0:	83 c4 10             	add    $0x10,%esp
  8003b3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  8003b6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003b9:	89 c1                	mov    %eax,%ecx
  8003bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003be:	89 d0                	mov    %edx,%eax
  8003c0:	01 c0                	add    %eax,%eax
  8003c2:	01 d0                	add    %edx,%eax
  8003c4:	01 c0                	add    %eax,%eax
  8003c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003cb:	39 c1                	cmp    %eax,%ecx
  8003cd:	74 14                	je     8003e3 <_main+0x3ab>
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 d4 3f 80 00       	push   $0x803fd4
  8003d7:	6a 53                	push   $0x53
  8003d9:	68 bc 3f 80 00       	push   $0x803fbc
  8003de:	e8 c7 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8003e3:	e8 26 1e 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  8003e8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 04 40 80 00       	push   $0x804004
  8003f5:	6a 55                	push   $0x55
  8003f7:	68 bc 3f 80 00       	push   $0x803fbc
  8003fc:	e8 a9 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800401:	e8 68 1d 00 00       	call   80216e <sys_calculate_free_frames>
  800406:	89 c2                	mov    %eax,%edx
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	39 c2                	cmp    %eax,%edx
  80040d:	74 14                	je     800423 <_main+0x3eb>
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 21 40 80 00       	push   $0x804021
  800417:	6a 56                	push   $0x56
  800419:	68 bc 3f 80 00       	push   $0x803fbc
  80041e:	e8 87 08 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 46 1d 00 00       	call   80216e <sys_calculate_free_frames>
  800428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 de 1d 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800430:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800436:	89 c2                	mov    %eax,%edx
  800438:	01 d2                	add    %edx,%edx
  80043a:	01 d0                	add    %edx,%eax
  80043c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	50                   	push   %eax
  800443:	e8 9e 1a 00 00       	call   801ee6 <malloc>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80044e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800451:	89 c2                	mov    %eax,%edx
  800453:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800456:	c1 e0 03             	shl    $0x3,%eax
  800459:	05 00 00 00 80       	add    $0x80000000,%eax
  80045e:	39 c2                	cmp    %eax,%edx
  800460:	74 14                	je     800476 <_main+0x43e>
  800462:	83 ec 04             	sub    $0x4,%esp
  800465:	68 d4 3f 80 00       	push   $0x803fd4
  80046a:	6a 5c                	push   $0x5c
  80046c:	68 bc 3f 80 00       	push   $0x803fbc
  800471:	e8 34 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800476:	e8 93 1d 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  80047b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 04 40 80 00       	push   $0x804004
  800488:	6a 5e                	push   $0x5e
  80048a:	68 bc 3f 80 00       	push   $0x803fbc
  80048f:	e8 16 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800494:	e8 d5 1c 00 00       	call   80216e <sys_calculate_free_frames>
  800499:	89 c2                	mov    %eax,%edx
  80049b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	74 14                	je     8004b6 <_main+0x47e>
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	68 21 40 80 00       	push   $0x804021
  8004aa:	6a 5f                	push   $0x5f
  8004ac:	68 bc 3f 80 00       	push   $0x803fbc
  8004b1:	e8 f4 07 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004b6:	e8 b3 1c 00 00       	call   80216e <sys_calculate_free_frames>
  8004bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004be:	e8 4b 1d 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  8004c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8004c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004c9:	89 c2                	mov    %eax,%edx
  8004cb:	01 d2                	add    %edx,%edx
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004d2:	83 ec 0c             	sub    $0xc,%esp
  8004d5:	50                   	push   %eax
  8004d6:	e8 0b 1a 00 00       	call   801ee6 <malloc>
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004e1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8004e4:	89 c1                	mov    %eax,%ecx
  8004e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004e9:	89 d0                	mov    %edx,%eax
  8004eb:	c1 e0 02             	shl    $0x2,%eax
  8004ee:	01 d0                	add    %edx,%eax
  8004f0:	01 c0                	add    %eax,%eax
  8004f2:	01 d0                	add    %edx,%eax
  8004f4:	05 00 00 00 80       	add    $0x80000000,%eax
  8004f9:	39 c1                	cmp    %eax,%ecx
  8004fb:	74 14                	je     800511 <_main+0x4d9>
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	68 d4 3f 80 00       	push   $0x803fd4
  800505:	6a 65                	push   $0x65
  800507:	68 bc 3f 80 00       	push   $0x803fbc
  80050c:	e8 99 07 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800511:	e8 f8 1c 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800516:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800519:	74 14                	je     80052f <_main+0x4f7>
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	68 04 40 80 00       	push   $0x804004
  800523:	6a 67                	push   $0x67
  800525:	68 bc 3f 80 00       	push   $0x803fbc
  80052a:	e8 7b 07 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80052f:	e8 3a 1c 00 00       	call   80216e <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 21 40 80 00       	push   $0x804021
  800545:	6a 68                	push   $0x68
  800547:	68 bc 3f 80 00       	push   $0x803fbc
  80054c:	e8 59 07 00 00       	call   800caa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800551:	e8 18 1c 00 00       	call   80216e <sys_calculate_free_frames>
  800556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800559:	e8 b0 1c 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  80055e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800561:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	50                   	push   %eax
  800568:	e8 a7 19 00 00       	call   801f14 <free>
  80056d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800570:	e8 99 1c 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800575:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800578:	74 14                	je     80058e <_main+0x556>
  80057a:	83 ec 04             	sub    $0x4,%esp
  80057d:	68 34 40 80 00       	push   $0x804034
  800582:	6a 72                	push   $0x72
  800584:	68 bc 3f 80 00       	push   $0x803fbc
  800589:	e8 1c 07 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80058e:	e8 db 1b 00 00       	call   80216e <sys_calculate_free_frames>
  800593:	89 c2                	mov    %eax,%edx
  800595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800598:	39 c2                	cmp    %eax,%edx
  80059a:	74 14                	je     8005b0 <_main+0x578>
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	68 4b 40 80 00       	push   $0x80404b
  8005a4:	6a 73                	push   $0x73
  8005a6:	68 bc 3f 80 00       	push   $0x803fbc
  8005ab:	e8 fa 06 00 00       	call   800caa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005b0:	e8 b9 1b 00 00       	call   80216e <sys_calculate_free_frames>
  8005b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005b8:	e8 51 1c 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  8005c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	50                   	push   %eax
  8005c7:	e8 48 19 00 00       	call   801f14 <free>
  8005cc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005cf:	e8 3a 1c 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  8005d4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005d7:	74 14                	je     8005ed <_main+0x5b5>
  8005d9:	83 ec 04             	sub    $0x4,%esp
  8005dc:	68 34 40 80 00       	push   $0x804034
  8005e1:	6a 7a                	push   $0x7a
  8005e3:	68 bc 3f 80 00       	push   $0x803fbc
  8005e8:	e8 bd 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ed:	e8 7c 1b 00 00       	call   80216e <sys_calculate_free_frames>
  8005f2:	89 c2                	mov    %eax,%edx
  8005f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f7:	39 c2                	cmp    %eax,%edx
  8005f9:	74 14                	je     80060f <_main+0x5d7>
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 4b 40 80 00       	push   $0x80404b
  800603:	6a 7b                	push   $0x7b
  800605:	68 bc 3f 80 00       	push   $0x803fbc
  80060a:	e8 9b 06 00 00       	call   800caa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80060f:	e8 5a 1b 00 00       	call   80216e <sys_calculate_free_frames>
  800614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800617:	e8 f2 1b 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80061f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800622:	83 ec 0c             	sub    $0xc,%esp
  800625:	50                   	push   %eax
  800626:	e8 e9 18 00 00       	call   801f14 <free>
  80062b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80062e:	e8 db 1b 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800633:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800636:	74 17                	je     80064f <_main+0x617>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 34 40 80 00       	push   $0x804034
  800640:	68 82 00 00 00       	push   $0x82
  800645:	68 bc 3f 80 00       	push   $0x803fbc
  80064a:	e8 5b 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064f:	e8 1a 1b 00 00       	call   80216e <sys_calculate_free_frames>
  800654:	89 c2                	mov    %eax,%edx
  800656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800659:	39 c2                	cmp    %eax,%edx
  80065b:	74 17                	je     800674 <_main+0x63c>
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	68 4b 40 80 00       	push   $0x80404b
  800665:	68 83 00 00 00       	push   $0x83
  80066a:	68 bc 3f 80 00       	push   $0x803fbc
  80066f:	e8 36 06 00 00       	call   800caa <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800674:	e8 f5 1a 00 00       	call   80216e <sys_calculate_free_frames>
  800679:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80067c:	e8 8d 1b 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800681:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  800684:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800687:	89 d0                	mov    %edx,%eax
  800689:	c1 e0 09             	shl    $0x9,%eax
  80068c:	29 d0                	sub    %edx,%eax
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	50                   	push   %eax
  800692:	e8 4f 18 00 00       	call   801ee6 <malloc>
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80069d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006a0:	89 c2                	mov    %eax,%edx
  8006a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006a5:	05 00 00 00 80       	add    $0x80000000,%eax
  8006aa:	39 c2                	cmp    %eax,%edx
  8006ac:	74 17                	je     8006c5 <_main+0x68d>
  8006ae:	83 ec 04             	sub    $0x4,%esp
  8006b1:	68 d4 3f 80 00       	push   $0x803fd4
  8006b6:	68 8c 00 00 00       	push   $0x8c
  8006bb:	68 bc 3f 80 00       	push   $0x803fbc
  8006c0:	e8 e5 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006c5:	e8 44 1b 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  8006ca:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006cd:	74 17                	je     8006e6 <_main+0x6ae>
  8006cf:	83 ec 04             	sub    $0x4,%esp
  8006d2:	68 04 40 80 00       	push   $0x804004
  8006d7:	68 8e 00 00 00       	push   $0x8e
  8006dc:	68 bc 3f 80 00       	push   $0x803fbc
  8006e1:	e8 c4 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8006e6:	e8 83 1a 00 00       	call   80216e <sys_calculate_free_frames>
  8006eb:	89 c2                	mov    %eax,%edx
  8006ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f0:	39 c2                	cmp    %eax,%edx
  8006f2:	74 17                	je     80070b <_main+0x6d3>
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	68 21 40 80 00       	push   $0x804021
  8006fc:	68 8f 00 00 00       	push   $0x8f
  800701:	68 bc 3f 80 00       	push   $0x803fbc
  800706:	e8 9f 05 00 00       	call   800caa <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80070b:	e8 5e 1a 00 00       	call   80216e <sys_calculate_free_frames>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800713:	e8 f6 1a 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800718:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80071b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80071e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800721:	83 ec 0c             	sub    $0xc,%esp
  800724:	50                   	push   %eax
  800725:	e8 bc 17 00 00       	call   801ee6 <malloc>
  80072a:	83 c4 10             	add    $0x10,%esp
  80072d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800730:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800733:	89 c2                	mov    %eax,%edx
  800735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800738:	c1 e0 02             	shl    $0x2,%eax
  80073b:	05 00 00 00 80       	add    $0x80000000,%eax
  800740:	39 c2                	cmp    %eax,%edx
  800742:	74 17                	je     80075b <_main+0x723>
  800744:	83 ec 04             	sub    $0x4,%esp
  800747:	68 d4 3f 80 00       	push   $0x803fd4
  80074c:	68 95 00 00 00       	push   $0x95
  800751:	68 bc 3f 80 00       	push   $0x803fbc
  800756:	e8 4f 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80075b:	e8 ae 1a 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800760:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800763:	74 17                	je     80077c <_main+0x744>
  800765:	83 ec 04             	sub    $0x4,%esp
  800768:	68 04 40 80 00       	push   $0x804004
  80076d:	68 97 00 00 00       	push   $0x97
  800772:	68 bc 3f 80 00       	push   $0x803fbc
  800777:	e8 2e 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80077c:	e8 ed 19 00 00       	call   80216e <sys_calculate_free_frames>
  800781:	89 c2                	mov    %eax,%edx
  800783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800786:	39 c2                	cmp    %eax,%edx
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	68 21 40 80 00       	push   $0x804021
  800792:	68 98 00 00 00       	push   $0x98
  800797:	68 bc 3f 80 00       	push   $0x803fbc
  80079c:	e8 09 05 00 00       	call   800caa <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007a1:	e8 c8 19 00 00       	call   80216e <sys_calculate_free_frames>
  8007a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007a9:	e8 60 1a 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  8007ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  8007b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007b4:	89 d0                	mov    %edx,%eax
  8007b6:	c1 e0 08             	shl    $0x8,%eax
  8007b9:	29 d0                	sub    %edx,%eax
  8007bb:	83 ec 0c             	sub    $0xc,%esp
  8007be:	50                   	push   %eax
  8007bf:	e8 22 17 00 00       	call   801ee6 <malloc>
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  8007ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007cd:	89 c2                	mov    %eax,%edx
  8007cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007d2:	c1 e0 09             	shl    $0x9,%eax
  8007d5:	89 c1                	mov    %eax,%ecx
  8007d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007da:	01 c8                	add    %ecx,%eax
  8007dc:	05 00 00 00 80       	add    $0x80000000,%eax
  8007e1:	39 c2                	cmp    %eax,%edx
  8007e3:	74 17                	je     8007fc <_main+0x7c4>
  8007e5:	83 ec 04             	sub    $0x4,%esp
  8007e8:	68 d4 3f 80 00       	push   $0x803fd4
  8007ed:	68 9e 00 00 00       	push   $0x9e
  8007f2:	68 bc 3f 80 00       	push   $0x803fbc
  8007f7:	e8 ae 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8007fc:	e8 0d 1a 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800801:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800804:	74 17                	je     80081d <_main+0x7e5>
  800806:	83 ec 04             	sub    $0x4,%esp
  800809:	68 04 40 80 00       	push   $0x804004
  80080e:	68 a0 00 00 00       	push   $0xa0
  800813:	68 bc 3f 80 00       	push   $0x803fbc
  800818:	e8 8d 04 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80081d:	e8 4c 19 00 00       	call   80216e <sys_calculate_free_frames>
  800822:	89 c2                	mov    %eax,%edx
  800824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800827:	39 c2                	cmp    %eax,%edx
  800829:	74 17                	je     800842 <_main+0x80a>
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	68 21 40 80 00       	push   $0x804021
  800833:	68 a1 00 00 00       	push   $0xa1
  800838:	68 bc 3f 80 00       	push   $0x803fbc
  80083d:	e8 68 04 00 00       	call   800caa <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800842:	e8 27 19 00 00       	call   80216e <sys_calculate_free_frames>
  800847:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80084a:	e8 bf 19 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800855:	01 c0                	add    %eax,%eax
  800857:	83 ec 0c             	sub    $0xc,%esp
  80085a:	50                   	push   %eax
  80085b:	e8 86 16 00 00       	call   801ee6 <malloc>
  800860:	83 c4 10             	add    $0x10,%esp
  800863:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800866:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800869:	89 c2                	mov    %eax,%edx
  80086b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086e:	c1 e0 03             	shl    $0x3,%eax
  800871:	05 00 00 00 80       	add    $0x80000000,%eax
  800876:	39 c2                	cmp    %eax,%edx
  800878:	74 17                	je     800891 <_main+0x859>
  80087a:	83 ec 04             	sub    $0x4,%esp
  80087d:	68 d4 3f 80 00       	push   $0x803fd4
  800882:	68 a7 00 00 00       	push   $0xa7
  800887:	68 bc 3f 80 00       	push   $0x803fbc
  80088c:	e8 19 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800891:	e8 78 19 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800896:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800899:	74 17                	je     8008b2 <_main+0x87a>
  80089b:	83 ec 04             	sub    $0x4,%esp
  80089e:	68 04 40 80 00       	push   $0x804004
  8008a3:	68 a9 00 00 00       	push   $0xa9
  8008a8:	68 bc 3f 80 00       	push   $0x803fbc
  8008ad:	e8 f8 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008b2:	e8 b7 18 00 00       	call   80216e <sys_calculate_free_frames>
  8008b7:	89 c2                	mov    %eax,%edx
  8008b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008bc:	39 c2                	cmp    %eax,%edx
  8008be:	74 17                	je     8008d7 <_main+0x89f>
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	68 21 40 80 00       	push   $0x804021
  8008c8:	68 aa 00 00 00       	push   $0xaa
  8008cd:	68 bc 3f 80 00       	push   $0x803fbc
  8008d2:	e8 d3 03 00 00       	call   800caa <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008d7:	e8 92 18 00 00       	call   80216e <sys_calculate_free_frames>
  8008dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008df:	e8 2a 19 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  8008e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ea:	c1 e0 02             	shl    $0x2,%eax
  8008ed:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008f0:	83 ec 0c             	sub    $0xc,%esp
  8008f3:	50                   	push   %eax
  8008f4:	e8 ed 15 00 00       	call   801ee6 <malloc>
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  8008ff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800902:	89 c1                	mov    %eax,%ecx
  800904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800907:	89 d0                	mov    %edx,%eax
  800909:	01 c0                	add    %eax,%eax
  80090b:	01 d0                	add    %edx,%eax
  80090d:	01 c0                	add    %eax,%eax
  80090f:	01 d0                	add    %edx,%eax
  800911:	01 c0                	add    %eax,%eax
  800913:	05 00 00 00 80       	add    $0x80000000,%eax
  800918:	39 c1                	cmp    %eax,%ecx
  80091a:	74 17                	je     800933 <_main+0x8fb>
  80091c:	83 ec 04             	sub    $0x4,%esp
  80091f:	68 d4 3f 80 00       	push   $0x803fd4
  800924:	68 b0 00 00 00       	push   $0xb0
  800929:	68 bc 3f 80 00       	push   $0x803fbc
  80092e:	e8 77 03 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800933:	e8 d6 18 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800938:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80093b:	74 17                	je     800954 <_main+0x91c>
  80093d:	83 ec 04             	sub    $0x4,%esp
  800940:	68 04 40 80 00       	push   $0x804004
  800945:	68 b2 00 00 00       	push   $0xb2
  80094a:	68 bc 3f 80 00       	push   $0x803fbc
  80094f:	e8 56 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800954:	e8 15 18 00 00       	call   80216e <sys_calculate_free_frames>
  800959:	89 c2                	mov    %eax,%edx
  80095b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80095e:	39 c2                	cmp    %eax,%edx
  800960:	74 17                	je     800979 <_main+0x941>
  800962:	83 ec 04             	sub    $0x4,%esp
  800965:	68 21 40 80 00       	push   $0x804021
  80096a:	68 b3 00 00 00       	push   $0xb3
  80096f:	68 bc 3f 80 00       	push   $0x803fbc
  800974:	e8 31 03 00 00       	call   800caa <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800979:	e8 f0 17 00 00       	call   80216e <sys_calculate_free_frames>
  80097e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800981:	e8 88 18 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800986:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  800989:	8b 45 98             	mov    -0x68(%ebp),%eax
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 7f 15 00 00       	call   801f14 <free>
  800995:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800998:	e8 71 18 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 34 40 80 00       	push   $0x804034
  8009aa:	68 bd 00 00 00       	push   $0xbd
  8009af:	68 bc 3f 80 00       	push   $0x803fbc
  8009b4:	e8 f1 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009b9:	e8 b0 17 00 00       	call   80216e <sys_calculate_free_frames>
  8009be:	89 c2                	mov    %eax,%edx
  8009c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c3:	39 c2                	cmp    %eax,%edx
  8009c5:	74 17                	je     8009de <_main+0x9a6>
  8009c7:	83 ec 04             	sub    $0x4,%esp
  8009ca:	68 4b 40 80 00       	push   $0x80404b
  8009cf:	68 be 00 00 00       	push   $0xbe
  8009d4:	68 bc 3f 80 00       	push   $0x803fbc
  8009d9:	e8 cc 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8009de:	e8 8b 17 00 00       	call   80216e <sys_calculate_free_frames>
  8009e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e6:	e8 23 18 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  8009eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[9]);
  8009ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8009f1:	83 ec 0c             	sub    $0xc,%esp
  8009f4:	50                   	push   %eax
  8009f5:	e8 1a 15 00 00       	call   801f14 <free>
  8009fa:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009fd:	e8 0c 18 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800a02:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 34 40 80 00       	push   $0x804034
  800a0f:	68 c5 00 00 00       	push   $0xc5
  800a14:	68 bc 3f 80 00       	push   $0x803fbc
  800a19:	e8 8c 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a1e:	e8 4b 17 00 00       	call   80216e <sys_calculate_free_frames>
  800a23:	89 c2                	mov    %eax,%edx
  800a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a28:	39 c2                	cmp    %eax,%edx
  800a2a:	74 17                	je     800a43 <_main+0xa0b>
  800a2c:	83 ec 04             	sub    $0x4,%esp
  800a2f:	68 4b 40 80 00       	push   $0x80404b
  800a34:	68 c6 00 00 00       	push   $0xc6
  800a39:	68 bc 3f 80 00       	push   $0x803fbc
  800a3e:	e8 67 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a43:	e8 26 17 00 00       	call   80216e <sys_calculate_free_frames>
  800a48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a4b:	e8 be 17 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800a53:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800a56:	83 ec 0c             	sub    $0xc,%esp
  800a59:	50                   	push   %eax
  800a5a:	e8 b5 14 00 00       	call   801f14 <free>
  800a5f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a62:	e8 a7 17 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800a67:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 34 40 80 00       	push   $0x804034
  800a74:	68 cd 00 00 00       	push   $0xcd
  800a79:	68 bc 3f 80 00       	push   $0x803fbc
  800a7e:	e8 27 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a83:	e8 e6 16 00 00       	call   80216e <sys_calculate_free_frames>
  800a88:	89 c2                	mov    %eax,%edx
  800a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a8d:	39 c2                	cmp    %eax,%edx
  800a8f:	74 17                	je     800aa8 <_main+0xa70>
  800a91:	83 ec 04             	sub    $0x4,%esp
  800a94:	68 4b 40 80 00       	push   $0x80404b
  800a99:	68 ce 00 00 00       	push   $0xce
  800a9e:	68 bc 3f 80 00       	push   $0x803fbc
  800aa3:	e8 02 02 00 00       	call   800caa <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800aa8:	e8 c1 16 00 00       	call   80216e <sys_calculate_free_frames>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ab0:	e8 59 17 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800ab5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[13] = malloc(4*Mega + 256*kilo - kilo);
  800ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800abb:	c1 e0 06             	shl    $0x6,%eax
  800abe:	89 c2                	mov    %eax,%edx
  800ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac3:	01 d0                	add    %edx,%eax
  800ac5:	c1 e0 02             	shl    $0x2,%eax
  800ac8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800acb:	83 ec 0c             	sub    $0xc,%esp
  800ace:	50                   	push   %eax
  800acf:	e8 12 14 00 00       	call   801ee6 <malloc>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800ada:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800add:	89 c1                	mov    %eax,%ecx
  800adf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ae2:	89 d0                	mov    %edx,%eax
  800ae4:	01 c0                	add    %eax,%eax
  800ae6:	01 d0                	add    %edx,%eax
  800ae8:	c1 e0 08             	shl    $0x8,%eax
  800aeb:	89 c2                	mov    %eax,%edx
  800aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af0:	01 d0                	add    %edx,%eax
  800af2:	05 00 00 00 80       	add    $0x80000000,%eax
  800af7:	39 c1                	cmp    %eax,%ecx
  800af9:	74 17                	je     800b12 <_main+0xada>
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	68 d4 3f 80 00       	push   $0x803fd4
  800b03:	68 d8 00 00 00       	push   $0xd8
  800b08:	68 bc 3f 80 00       	push   $0x803fbc
  800b0d:	e8 98 01 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b12:	e8 f7 16 00 00       	call   80220e <sys_pf_calculate_allocated_pages>
  800b17:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b1a:	74 17                	je     800b33 <_main+0xafb>
  800b1c:	83 ec 04             	sub    $0x4,%esp
  800b1f:	68 04 40 80 00       	push   $0x804004
  800b24:	68 da 00 00 00       	push   $0xda
  800b29:	68 bc 3f 80 00       	push   $0x803fbc
  800b2e:	e8 77 01 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b33:	e8 36 16 00 00       	call   80216e <sys_calculate_free_frames>
  800b38:	89 c2                	mov    %eax,%edx
  800b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b3d:	39 c2                	cmp    %eax,%edx
  800b3f:	74 17                	je     800b58 <_main+0xb20>
  800b41:	83 ec 04             	sub    $0x4,%esp
  800b44:	68 21 40 80 00       	push   $0x804021
  800b49:	68 db 00 00 00       	push   $0xdb
  800b4e:	68 bc 3f 80 00       	push   $0x803fbc
  800b53:	e8 52 01 00 00       	call   800caa <_panic>
	}
	cprintf("Congratulations!! test FIRST FIT allocation (1) completed successfully.\n");
  800b58:	83 ec 0c             	sub    $0xc,%esp
  800b5b:	68 58 40 80 00       	push   $0x804058
  800b60:	e8 f9 03 00 00       	call   800f5e <cprintf>
  800b65:	83 c4 10             	add    $0x10,%esp

	return;
  800b68:	90                   	nop
}
  800b69:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b74:	e8 d5 18 00 00       	call   80244e <sys_getenvindex>
  800b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b7f:	89 d0                	mov    %edx,%eax
  800b81:	c1 e0 03             	shl    $0x3,%eax
  800b84:	01 d0                	add    %edx,%eax
  800b86:	01 c0                	add    %eax,%eax
  800b88:	01 d0                	add    %edx,%eax
  800b8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b91:	01 d0                	add    %edx,%eax
  800b93:	c1 e0 04             	shl    $0x4,%eax
  800b96:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b9b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ba0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ba5:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	74 0f                	je     800bbe <libmain+0x50>
		binaryname = myEnv->prog_name;
  800baf:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb4:	05 5c 05 00 00       	add    $0x55c,%eax
  800bb9:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc2:	7e 0a                	jle    800bce <libmain+0x60>
		binaryname = argv[0];
  800bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc7:	8b 00                	mov    (%eax),%eax
  800bc9:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	ff 75 08             	pushl  0x8(%ebp)
  800bd7:	e8 5c f4 ff ff       	call   800038 <_main>
  800bdc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bdf:	e8 77 16 00 00       	call   80225b <sys_disable_interrupt>
	cprintf("**************************************\n");
  800be4:	83 ec 0c             	sub    $0xc,%esp
  800be7:	68 bc 40 80 00       	push   $0x8040bc
  800bec:	e8 6d 03 00 00       	call   800f5e <cprintf>
  800bf1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bf4:	a1 20 50 80 00       	mov    0x805020,%eax
  800bf9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800bff:	a1 20 50 80 00       	mov    0x805020,%eax
  800c04:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800c0a:	83 ec 04             	sub    $0x4,%esp
  800c0d:	52                   	push   %edx
  800c0e:	50                   	push   %eax
  800c0f:	68 e4 40 80 00       	push   $0x8040e4
  800c14:	e8 45 03 00 00       	call   800f5e <cprintf>
  800c19:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c1c:	a1 20 50 80 00       	mov    0x805020,%eax
  800c21:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800c27:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2c:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800c32:	a1 20 50 80 00       	mov    0x805020,%eax
  800c37:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800c3d:	51                   	push   %ecx
  800c3e:	52                   	push   %edx
  800c3f:	50                   	push   %eax
  800c40:	68 0c 41 80 00       	push   $0x80410c
  800c45:	e8 14 03 00 00       	call   800f5e <cprintf>
  800c4a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c4d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c52:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	50                   	push   %eax
  800c5c:	68 64 41 80 00       	push   $0x804164
  800c61:	e8 f8 02 00 00       	call   800f5e <cprintf>
  800c66:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	68 bc 40 80 00       	push   $0x8040bc
  800c71:	e8 e8 02 00 00       	call   800f5e <cprintf>
  800c76:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c79:	e8 f7 15 00 00       	call   802275 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c7e:	e8 19 00 00 00       	call   800c9c <exit>
}
  800c83:	90                   	nop
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c8c:	83 ec 0c             	sub    $0xc,%esp
  800c8f:	6a 00                	push   $0x0
  800c91:	e8 84 17 00 00       	call   80241a <sys_destroy_env>
  800c96:	83 c4 10             	add    $0x10,%esp
}
  800c99:	90                   	nop
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <exit>:

void
exit(void)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800ca2:	e8 d9 17 00 00       	call   802480 <sys_exit_env>
}
  800ca7:	90                   	nop
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800cb0:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb3:	83 c0 04             	add    $0x4,%eax
  800cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800cb9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	74 16                	je     800cd8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800cc2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800cc7:	83 ec 08             	sub    $0x8,%esp
  800cca:	50                   	push   %eax
  800ccb:	68 78 41 80 00       	push   $0x804178
  800cd0:	e8 89 02 00 00       	call   800f5e <cprintf>
  800cd5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cd8:	a1 00 50 80 00       	mov    0x805000,%eax
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	ff 75 08             	pushl  0x8(%ebp)
  800ce3:	50                   	push   %eax
  800ce4:	68 7d 41 80 00       	push   $0x80417d
  800ce9:	e8 70 02 00 00       	call   800f5e <cprintf>
  800cee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	83 ec 08             	sub    $0x8,%esp
  800cf7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfa:	50                   	push   %eax
  800cfb:	e8 f3 01 00 00       	call   800ef3 <vcprintf>
  800d00:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d03:	83 ec 08             	sub    $0x8,%esp
  800d06:	6a 00                	push   $0x0
  800d08:	68 99 41 80 00       	push   $0x804199
  800d0d:	e8 e1 01 00 00       	call   800ef3 <vcprintf>
  800d12:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d15:	e8 82 ff ff ff       	call   800c9c <exit>

	// should not return here
	while (1) ;
  800d1a:	eb fe                	jmp    800d1a <_panic+0x70>

00800d1c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800d22:	a1 20 50 80 00       	mov    0x805020,%eax
  800d27:	8b 50 74             	mov    0x74(%eax),%edx
  800d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2d:	39 c2                	cmp    %eax,%edx
  800d2f:	74 14                	je     800d45 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d31:	83 ec 04             	sub    $0x4,%esp
  800d34:	68 9c 41 80 00       	push   $0x80419c
  800d39:	6a 26                	push   $0x26
  800d3b:	68 e8 41 80 00       	push   $0x8041e8
  800d40:	e8 65 ff ff ff       	call   800caa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d53:	e9 c2 00 00 00       	jmp    800e1a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	75 08                	jne    800d75 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d6d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d70:	e9 a2 00 00 00       	jmp    800e17 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d75:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d7c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d83:	eb 69                	jmp    800dee <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d85:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d93:	89 d0                	mov    %edx,%eax
  800d95:	01 c0                	add    %eax,%eax
  800d97:	01 d0                	add    %edx,%eax
  800d99:	c1 e0 03             	shl    $0x3,%eax
  800d9c:	01 c8                	add    %ecx,%eax
  800d9e:	8a 40 04             	mov    0x4(%eax),%al
  800da1:	84 c0                	test   %al,%al
  800da3:	75 46                	jne    800deb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800da5:	a1 20 50 80 00       	mov    0x805020,%eax
  800daa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800db0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800db3:	89 d0                	mov    %edx,%eax
  800db5:	01 c0                	add    %eax,%eax
  800db7:	01 d0                	add    %edx,%eax
  800db9:	c1 e0 03             	shl    $0x3,%eax
  800dbc:	01 c8                	add    %ecx,%eax
  800dbe:	8b 00                	mov    (%eax),%eax
  800dc0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800dc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800dc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dcb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	01 c8                	add    %ecx,%eax
  800ddc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dde:	39 c2                	cmp    %eax,%edx
  800de0:	75 09                	jne    800deb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800de2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800de9:	eb 12                	jmp    800dfd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800deb:	ff 45 e8             	incl   -0x18(%ebp)
  800dee:	a1 20 50 80 00       	mov    0x805020,%eax
  800df3:	8b 50 74             	mov    0x74(%eax),%edx
  800df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800df9:	39 c2                	cmp    %eax,%edx
  800dfb:	77 88                	ja     800d85 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dfd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e01:	75 14                	jne    800e17 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e03:	83 ec 04             	sub    $0x4,%esp
  800e06:	68 f4 41 80 00       	push   $0x8041f4
  800e0b:	6a 3a                	push   $0x3a
  800e0d:	68 e8 41 80 00       	push   $0x8041e8
  800e12:	e8 93 fe ff ff       	call   800caa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e17:	ff 45 f0             	incl   -0x10(%ebp)
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e20:	0f 8c 32 ff ff ff    	jl     800d58 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e2d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e34:	eb 26                	jmp    800e5c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e36:	a1 20 50 80 00       	mov    0x805020,%eax
  800e3b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e44:	89 d0                	mov    %edx,%eax
  800e46:	01 c0                	add    %eax,%eax
  800e48:	01 d0                	add    %edx,%eax
  800e4a:	c1 e0 03             	shl    $0x3,%eax
  800e4d:	01 c8                	add    %ecx,%eax
  800e4f:	8a 40 04             	mov    0x4(%eax),%al
  800e52:	3c 01                	cmp    $0x1,%al
  800e54:	75 03                	jne    800e59 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800e56:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e59:	ff 45 e0             	incl   -0x20(%ebp)
  800e5c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e61:	8b 50 74             	mov    0x74(%eax),%edx
  800e64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e67:	39 c2                	cmp    %eax,%edx
  800e69:	77 cb                	ja     800e36 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e71:	74 14                	je     800e87 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e73:	83 ec 04             	sub    $0x4,%esp
  800e76:	68 48 42 80 00       	push   $0x804248
  800e7b:	6a 44                	push   $0x44
  800e7d:	68 e8 41 80 00       	push   $0x8041e8
  800e82:	e8 23 fe ff ff       	call   800caa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e87:	90                   	nop
  800e88:	c9                   	leave  
  800e89:	c3                   	ret    

00800e8a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8b 00                	mov    (%eax),%eax
  800e95:	8d 48 01             	lea    0x1(%eax),%ecx
  800e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9b:	89 0a                	mov    %ecx,(%edx)
  800e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea0:	88 d1                	mov    %dl,%cl
  800ea2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	3d ff 00 00 00       	cmp    $0xff,%eax
  800eb3:	75 2c                	jne    800ee1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800eb5:	a0 24 50 80 00       	mov    0x805024,%al
  800eba:	0f b6 c0             	movzbl %al,%eax
  800ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec0:	8b 12                	mov    (%edx),%edx
  800ec2:	89 d1                	mov    %edx,%ecx
  800ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec7:	83 c2 08             	add    $0x8,%edx
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	50                   	push   %eax
  800ece:	51                   	push   %ecx
  800ecf:	52                   	push   %edx
  800ed0:	e8 d8 11 00 00       	call   8020ad <sys_cputs>
  800ed5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	8b 40 04             	mov    0x4(%eax),%eax
  800ee7:	8d 50 01             	lea    0x1(%eax),%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ef0:	90                   	nop
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800efc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f03:	00 00 00 
	b.cnt = 0;
  800f06:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f0d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f10:	ff 75 0c             	pushl  0xc(%ebp)
  800f13:	ff 75 08             	pushl  0x8(%ebp)
  800f16:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f1c:	50                   	push   %eax
  800f1d:	68 8a 0e 80 00       	push   $0x800e8a
  800f22:	e8 11 02 00 00       	call   801138 <vprintfmt>
  800f27:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f2a:	a0 24 50 80 00       	mov    0x805024,%al
  800f2f:	0f b6 c0             	movzbl %al,%eax
  800f32:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f38:	83 ec 04             	sub    $0x4,%esp
  800f3b:	50                   	push   %eax
  800f3c:	52                   	push   %edx
  800f3d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f43:	83 c0 08             	add    $0x8,%eax
  800f46:	50                   	push   %eax
  800f47:	e8 61 11 00 00       	call   8020ad <sys_cputs>
  800f4c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f4f:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800f56:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <cprintf>:

int cprintf(const char *fmt, ...) {
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f64:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f6b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	ff 75 f4             	pushl  -0xc(%ebp)
  800f7a:	50                   	push   %eax
  800f7b:	e8 73 ff ff ff       	call   800ef3 <vcprintf>
  800f80:	83 c4 10             	add    $0x10,%esp
  800f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f91:	e8 c5 12 00 00       	call   80225b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f96:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	83 ec 08             	sub    $0x8,%esp
  800fa2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa5:	50                   	push   %eax
  800fa6:	e8 48 ff ff ff       	call   800ef3 <vcprintf>
  800fab:	83 c4 10             	add    $0x10,%esp
  800fae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800fb1:	e8 bf 12 00 00       	call   802275 <sys_enable_interrupt>
	return cnt;
  800fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fb9:	c9                   	leave  
  800fba:	c3                   	ret    

00800fbb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 14             	sub    $0x14,%esp
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fce:	8b 45 18             	mov    0x18(%ebp),%eax
  800fd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fd9:	77 55                	ja     801030 <printnum+0x75>
  800fdb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fde:	72 05                	jb     800fe5 <printnum+0x2a>
  800fe0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe3:	77 4b                	ja     801030 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fe5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fe8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800feb:	8b 45 18             	mov    0x18(%ebp),%eax
  800fee:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff3:	52                   	push   %edx
  800ff4:	50                   	push   %eax
  800ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff8:	ff 75 f0             	pushl  -0x10(%ebp)
  800ffb:	e8 30 2d 00 00       	call   803d30 <__udivdi3>
  801000:	83 c4 10             	add    $0x10,%esp
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	ff 75 20             	pushl  0x20(%ebp)
  801009:	53                   	push   %ebx
  80100a:	ff 75 18             	pushl  0x18(%ebp)
  80100d:	52                   	push   %edx
  80100e:	50                   	push   %eax
  80100f:	ff 75 0c             	pushl  0xc(%ebp)
  801012:	ff 75 08             	pushl  0x8(%ebp)
  801015:	e8 a1 ff ff ff       	call   800fbb <printnum>
  80101a:	83 c4 20             	add    $0x20,%esp
  80101d:	eb 1a                	jmp    801039 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80101f:	83 ec 08             	sub    $0x8,%esp
  801022:	ff 75 0c             	pushl  0xc(%ebp)
  801025:	ff 75 20             	pushl  0x20(%ebp)
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	ff d0                	call   *%eax
  80102d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801030:	ff 4d 1c             	decl   0x1c(%ebp)
  801033:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801037:	7f e6                	jg     80101f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801039:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80103c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801047:	53                   	push   %ebx
  801048:	51                   	push   %ecx
  801049:	52                   	push   %edx
  80104a:	50                   	push   %eax
  80104b:	e8 f0 2d 00 00       	call   803e40 <__umoddi3>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	05 b4 44 80 00       	add    $0x8044b4,%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	0f be c0             	movsbl %al,%eax
  80105d:	83 ec 08             	sub    $0x8,%esp
  801060:	ff 75 0c             	pushl  0xc(%ebp)
  801063:	50                   	push   %eax
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
}
  80106c:	90                   	nop
  80106d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801075:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801079:	7e 1c                	jle    801097 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8b 00                	mov    (%eax),%eax
  801080:	8d 50 08             	lea    0x8(%eax),%edx
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 10                	mov    %edx,(%eax)
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8b 00                	mov    (%eax),%eax
  80108d:	83 e8 08             	sub    $0x8,%eax
  801090:	8b 50 04             	mov    0x4(%eax),%edx
  801093:	8b 00                	mov    (%eax),%eax
  801095:	eb 40                	jmp    8010d7 <getuint+0x65>
	else if (lflag)
  801097:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109b:	74 1e                	je     8010bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 50 04             	lea    0x4(%eax),%edx
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	89 10                	mov    %edx,(%eax)
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	83 e8 04             	sub    $0x4,%eax
  8010b2:	8b 00                	mov    (%eax),%eax
  8010b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b9:	eb 1c                	jmp    8010d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8b 00                	mov    (%eax),%eax
  8010c0:	8d 50 04             	lea    0x4(%eax),%edx
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	89 10                	mov    %edx,(%eax)
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8b 00                	mov    (%eax),%eax
  8010cd:	83 e8 04             	sub    $0x4,%eax
  8010d0:	8b 00                	mov    (%eax),%eax
  8010d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010e0:	7e 1c                	jle    8010fe <getint+0x25>
		return va_arg(*ap, long long);
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8b 00                	mov    (%eax),%eax
  8010e7:	8d 50 08             	lea    0x8(%eax),%edx
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	89 10                	mov    %edx,(%eax)
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8b 00                	mov    (%eax),%eax
  8010f4:	83 e8 08             	sub    $0x8,%eax
  8010f7:	8b 50 04             	mov    0x4(%eax),%edx
  8010fa:	8b 00                	mov    (%eax),%eax
  8010fc:	eb 38                	jmp    801136 <getint+0x5d>
	else if (lflag)
  8010fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801102:	74 1a                	je     80111e <getint+0x45>
		return va_arg(*ap, long);
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8b 00                	mov    (%eax),%eax
  801109:	8d 50 04             	lea    0x4(%eax),%edx
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	89 10                	mov    %edx,(%eax)
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8b 00                	mov    (%eax),%eax
  801116:	83 e8 04             	sub    $0x4,%eax
  801119:	8b 00                	mov    (%eax),%eax
  80111b:	99                   	cltd   
  80111c:	eb 18                	jmp    801136 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8b 00                	mov    (%eax),%eax
  801123:	8d 50 04             	lea    0x4(%eax),%edx
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 10                	mov    %edx,(%eax)
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8b 00                	mov    (%eax),%eax
  801130:	83 e8 04             	sub    $0x4,%eax
  801133:	8b 00                	mov    (%eax),%eax
  801135:	99                   	cltd   
}
  801136:	5d                   	pop    %ebp
  801137:	c3                   	ret    

00801138 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
  80113d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801140:	eb 17                	jmp    801159 <vprintfmt+0x21>
			if (ch == '\0')
  801142:	85 db                	test   %ebx,%ebx
  801144:	0f 84 af 03 00 00    	je     8014f9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	53                   	push   %ebx
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	ff d0                	call   *%eax
  801156:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	8d 50 01             	lea    0x1(%eax),%edx
  80115f:	89 55 10             	mov    %edx,0x10(%ebp)
  801162:	8a 00                	mov    (%eax),%al
  801164:	0f b6 d8             	movzbl %al,%ebx
  801167:	83 fb 25             	cmp    $0x25,%ebx
  80116a:	75 d6                	jne    801142 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80116c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801170:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801177:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80117e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801185:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	8d 50 01             	lea    0x1(%eax),%edx
  801192:	89 55 10             	mov    %edx,0x10(%ebp)
  801195:	8a 00                	mov    (%eax),%al
  801197:	0f b6 d8             	movzbl %al,%ebx
  80119a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80119d:	83 f8 55             	cmp    $0x55,%eax
  8011a0:	0f 87 2b 03 00 00    	ja     8014d1 <vprintfmt+0x399>
  8011a6:	8b 04 85 d8 44 80 00 	mov    0x8044d8(,%eax,4),%eax
  8011ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8011af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8011b3:	eb d7                	jmp    80118c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8011b9:	eb d1                	jmp    80118c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8011c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011c5:	89 d0                	mov    %edx,%eax
  8011c7:	c1 e0 02             	shl    $0x2,%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	01 c0                	add    %eax,%eax
  8011ce:	01 d8                	add    %ebx,%eax
  8011d0:	83 e8 30             	sub    $0x30,%eax
  8011d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011de:	83 fb 2f             	cmp    $0x2f,%ebx
  8011e1:	7e 3e                	jle    801221 <vprintfmt+0xe9>
  8011e3:	83 fb 39             	cmp    $0x39,%ebx
  8011e6:	7f 39                	jg     801221 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011eb:	eb d5                	jmp    8011c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	83 c0 04             	add    $0x4,%eax
  8011f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8011f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f9:	83 e8 04             	sub    $0x4,%eax
  8011fc:	8b 00                	mov    (%eax),%eax
  8011fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801201:	eb 1f                	jmp    801222 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801203:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801207:	79 83                	jns    80118c <vprintfmt+0x54>
				width = 0;
  801209:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801210:	e9 77 ff ff ff       	jmp    80118c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801215:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80121c:	e9 6b ff ff ff       	jmp    80118c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801221:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801222:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801226:	0f 89 60 ff ff ff    	jns    80118c <vprintfmt+0x54>
				width = precision, precision = -1;
  80122c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80122f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801232:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801239:	e9 4e ff ff ff       	jmp    80118c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80123e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801241:	e9 46 ff ff ff       	jmp    80118c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801246:	8b 45 14             	mov    0x14(%ebp),%eax
  801249:	83 c0 04             	add    $0x4,%eax
  80124c:	89 45 14             	mov    %eax,0x14(%ebp)
  80124f:	8b 45 14             	mov    0x14(%ebp),%eax
  801252:	83 e8 04             	sub    $0x4,%eax
  801255:	8b 00                	mov    (%eax),%eax
  801257:	83 ec 08             	sub    $0x8,%esp
  80125a:	ff 75 0c             	pushl  0xc(%ebp)
  80125d:	50                   	push   %eax
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	ff d0                	call   *%eax
  801263:	83 c4 10             	add    $0x10,%esp
			break;
  801266:	e9 89 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	83 c0 04             	add    $0x4,%eax
  801271:	89 45 14             	mov    %eax,0x14(%ebp)
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	83 e8 04             	sub    $0x4,%eax
  80127a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80127c:	85 db                	test   %ebx,%ebx
  80127e:	79 02                	jns    801282 <vprintfmt+0x14a>
				err = -err;
  801280:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801282:	83 fb 64             	cmp    $0x64,%ebx
  801285:	7f 0b                	jg     801292 <vprintfmt+0x15a>
  801287:	8b 34 9d 20 43 80 00 	mov    0x804320(,%ebx,4),%esi
  80128e:	85 f6                	test   %esi,%esi
  801290:	75 19                	jne    8012ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801292:	53                   	push   %ebx
  801293:	68 c5 44 80 00       	push   $0x8044c5
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	ff 75 08             	pushl  0x8(%ebp)
  80129e:	e8 5e 02 00 00       	call   801501 <printfmt>
  8012a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8012a6:	e9 49 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8012ab:	56                   	push   %esi
  8012ac:	68 ce 44 80 00       	push   $0x8044ce
  8012b1:	ff 75 0c             	pushl  0xc(%ebp)
  8012b4:	ff 75 08             	pushl  0x8(%ebp)
  8012b7:	e8 45 02 00 00       	call   801501 <printfmt>
  8012bc:	83 c4 10             	add    $0x10,%esp
			break;
  8012bf:	e9 30 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	83 c0 04             	add    $0x4,%eax
  8012ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	83 e8 04             	sub    $0x4,%eax
  8012d3:	8b 30                	mov    (%eax),%esi
  8012d5:	85 f6                	test   %esi,%esi
  8012d7:	75 05                	jne    8012de <vprintfmt+0x1a6>
				p = "(null)";
  8012d9:	be d1 44 80 00       	mov    $0x8044d1,%esi
			if (width > 0 && padc != '-')
  8012de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012e2:	7e 6d                	jle    801351 <vprintfmt+0x219>
  8012e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012e8:	74 67                	je     801351 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ed:	83 ec 08             	sub    $0x8,%esp
  8012f0:	50                   	push   %eax
  8012f1:	56                   	push   %esi
  8012f2:	e8 0c 03 00 00       	call   801603 <strnlen>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012fd:	eb 16                	jmp    801315 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	ff 75 0c             	pushl  0xc(%ebp)
  801309:	50                   	push   %eax
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	ff d0                	call   *%eax
  80130f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801312:	ff 4d e4             	decl   -0x1c(%ebp)
  801315:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801319:	7f e4                	jg     8012ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80131b:	eb 34                	jmp    801351 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80131d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801321:	74 1c                	je     80133f <vprintfmt+0x207>
  801323:	83 fb 1f             	cmp    $0x1f,%ebx
  801326:	7e 05                	jle    80132d <vprintfmt+0x1f5>
  801328:	83 fb 7e             	cmp    $0x7e,%ebx
  80132b:	7e 12                	jle    80133f <vprintfmt+0x207>
					putch('?', putdat);
  80132d:	83 ec 08             	sub    $0x8,%esp
  801330:	ff 75 0c             	pushl  0xc(%ebp)
  801333:	6a 3f                	push   $0x3f
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	ff d0                	call   *%eax
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	eb 0f                	jmp    80134e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80133f:	83 ec 08             	sub    $0x8,%esp
  801342:	ff 75 0c             	pushl  0xc(%ebp)
  801345:	53                   	push   %ebx
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	ff d0                	call   *%eax
  80134b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80134e:	ff 4d e4             	decl   -0x1c(%ebp)
  801351:	89 f0                	mov    %esi,%eax
  801353:	8d 70 01             	lea    0x1(%eax),%esi
  801356:	8a 00                	mov    (%eax),%al
  801358:	0f be d8             	movsbl %al,%ebx
  80135b:	85 db                	test   %ebx,%ebx
  80135d:	74 24                	je     801383 <vprintfmt+0x24b>
  80135f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801363:	78 b8                	js     80131d <vprintfmt+0x1e5>
  801365:	ff 4d e0             	decl   -0x20(%ebp)
  801368:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80136c:	79 af                	jns    80131d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80136e:	eb 13                	jmp    801383 <vprintfmt+0x24b>
				putch(' ', putdat);
  801370:	83 ec 08             	sub    $0x8,%esp
  801373:	ff 75 0c             	pushl  0xc(%ebp)
  801376:	6a 20                	push   $0x20
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	ff d0                	call   *%eax
  80137d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801380:	ff 4d e4             	decl   -0x1c(%ebp)
  801383:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801387:	7f e7                	jg     801370 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801389:	e9 66 01 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80138e:	83 ec 08             	sub    $0x8,%esp
  801391:	ff 75 e8             	pushl  -0x18(%ebp)
  801394:	8d 45 14             	lea    0x14(%ebp),%eax
  801397:	50                   	push   %eax
  801398:	e8 3c fd ff ff       	call   8010d9 <getint>
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8013a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ac:	85 d2                	test   %edx,%edx
  8013ae:	79 23                	jns    8013d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8013b0:	83 ec 08             	sub    $0x8,%esp
  8013b3:	ff 75 0c             	pushl  0xc(%ebp)
  8013b6:	6a 2d                	push   $0x2d
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	ff d0                	call   *%eax
  8013bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8013c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c6:	f7 d8                	neg    %eax
  8013c8:	83 d2 00             	adc    $0x0,%edx
  8013cb:	f7 da                	neg    %edx
  8013cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013da:	e9 bc 00 00 00       	jmp    80149b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8013e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8013e8:	50                   	push   %eax
  8013e9:	e8 84 fc ff ff       	call   801072 <getuint>
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013fe:	e9 98 00 00 00       	jmp    80149b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801403:	83 ec 08             	sub    $0x8,%esp
  801406:	ff 75 0c             	pushl  0xc(%ebp)
  801409:	6a 58                	push   $0x58
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	ff d0                	call   *%eax
  801410:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801413:	83 ec 08             	sub    $0x8,%esp
  801416:	ff 75 0c             	pushl  0xc(%ebp)
  801419:	6a 58                	push   $0x58
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	ff d0                	call   *%eax
  801420:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801423:	83 ec 08             	sub    $0x8,%esp
  801426:	ff 75 0c             	pushl  0xc(%ebp)
  801429:	6a 58                	push   $0x58
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	ff d0                	call   *%eax
  801430:	83 c4 10             	add    $0x10,%esp
			break;
  801433:	e9 bc 00 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801438:	83 ec 08             	sub    $0x8,%esp
  80143b:	ff 75 0c             	pushl  0xc(%ebp)
  80143e:	6a 30                	push   $0x30
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	ff d0                	call   *%eax
  801445:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	6a 78                	push   $0x78
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	ff d0                	call   *%eax
  801455:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801458:	8b 45 14             	mov    0x14(%ebp),%eax
  80145b:	83 c0 04             	add    $0x4,%eax
  80145e:	89 45 14             	mov    %eax,0x14(%ebp)
  801461:	8b 45 14             	mov    0x14(%ebp),%eax
  801464:	83 e8 04             	sub    $0x4,%eax
  801467:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801469:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801473:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80147a:	eb 1f                	jmp    80149b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80147c:	83 ec 08             	sub    $0x8,%esp
  80147f:	ff 75 e8             	pushl  -0x18(%ebp)
  801482:	8d 45 14             	lea    0x14(%ebp),%eax
  801485:	50                   	push   %eax
  801486:	e8 e7 fb ff ff       	call   801072 <getuint>
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801491:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801494:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80149b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80149f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014a2:	83 ec 04             	sub    $0x4,%esp
  8014a5:	52                   	push   %edx
  8014a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a9:	50                   	push   %eax
  8014aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8014ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 00 fb ff ff       	call   800fbb <printnum>
  8014bb:	83 c4 20             	add    $0x20,%esp
			break;
  8014be:	eb 34                	jmp    8014f4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8014c0:	83 ec 08             	sub    $0x8,%esp
  8014c3:	ff 75 0c             	pushl  0xc(%ebp)
  8014c6:	53                   	push   %ebx
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	ff d0                	call   *%eax
  8014cc:	83 c4 10             	add    $0x10,%esp
			break;
  8014cf:	eb 23                	jmp    8014f4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014d1:	83 ec 08             	sub    $0x8,%esp
  8014d4:	ff 75 0c             	pushl  0xc(%ebp)
  8014d7:	6a 25                	push   $0x25
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	ff d0                	call   *%eax
  8014de:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014e1:	ff 4d 10             	decl   0x10(%ebp)
  8014e4:	eb 03                	jmp    8014e9 <vprintfmt+0x3b1>
  8014e6:	ff 4d 10             	decl   0x10(%ebp)
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	48                   	dec    %eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	3c 25                	cmp    $0x25,%al
  8014f1:	75 f3                	jne    8014e6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014f3:	90                   	nop
		}
	}
  8014f4:	e9 47 fc ff ff       	jmp    801140 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014f9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014fd:	5b                   	pop    %ebx
  8014fe:	5e                   	pop    %esi
  8014ff:	5d                   	pop    %ebp
  801500:	c3                   	ret    

00801501 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801507:	8d 45 10             	lea    0x10(%ebp),%eax
  80150a:	83 c0 04             	add    $0x4,%eax
  80150d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	ff 75 f4             	pushl  -0xc(%ebp)
  801516:	50                   	push   %eax
  801517:	ff 75 0c             	pushl  0xc(%ebp)
  80151a:	ff 75 08             	pushl  0x8(%ebp)
  80151d:	e8 16 fc ff ff       	call   801138 <vprintfmt>
  801522:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801525:	90                   	nop
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80152b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152e:	8b 40 08             	mov    0x8(%eax),%eax
  801531:	8d 50 01             	lea    0x1(%eax),%edx
  801534:	8b 45 0c             	mov    0xc(%ebp),%eax
  801537:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80153a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153d:	8b 10                	mov    (%eax),%edx
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	8b 40 04             	mov    0x4(%eax),%eax
  801545:	39 c2                	cmp    %eax,%edx
  801547:	73 12                	jae    80155b <sprintputch+0x33>
		*b->buf++ = ch;
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8b 00                	mov    (%eax),%eax
  80154e:	8d 48 01             	lea    0x1(%eax),%ecx
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	89 0a                	mov    %ecx,(%edx)
  801556:	8b 55 08             	mov    0x8(%ebp),%edx
  801559:	88 10                	mov    %dl,(%eax)
}
  80155b:	90                   	nop
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    

0080155e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	01 d0                	add    %edx,%eax
  801575:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801578:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80157f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801583:	74 06                	je     80158b <vsnprintf+0x2d>
  801585:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801589:	7f 07                	jg     801592 <vsnprintf+0x34>
		return -E_INVAL;
  80158b:	b8 03 00 00 00       	mov    $0x3,%eax
  801590:	eb 20                	jmp    8015b2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801592:	ff 75 14             	pushl  0x14(%ebp)
  801595:	ff 75 10             	pushl  0x10(%ebp)
  801598:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80159b:	50                   	push   %eax
  80159c:	68 28 15 80 00       	push   $0x801528
  8015a1:	e8 92 fb ff ff       	call   801138 <vprintfmt>
  8015a6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8015a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015ba:	8d 45 10             	lea    0x10(%ebp),%eax
  8015bd:	83 c0 04             	add    $0x4,%eax
  8015c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c9:	50                   	push   %eax
  8015ca:	ff 75 0c             	pushl  0xc(%ebp)
  8015cd:	ff 75 08             	pushl  0x8(%ebp)
  8015d0:	e8 89 ff ff ff       	call   80155e <vsnprintf>
  8015d5:	83 c4 10             	add    $0x10,%esp
  8015d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ed:	eb 06                	jmp    8015f5 <strlen+0x15>
		n++;
  8015ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015f2:	ff 45 08             	incl   0x8(%ebp)
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	75 f1                	jne    8015ef <strlen+0xf>
		n++;
	return n;
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801609:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801610:	eb 09                	jmp    80161b <strnlen+0x18>
		n++;
  801612:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801615:	ff 45 08             	incl   0x8(%ebp)
  801618:	ff 4d 0c             	decl   0xc(%ebp)
  80161b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80161f:	74 09                	je     80162a <strnlen+0x27>
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	8a 00                	mov    (%eax),%al
  801626:	84 c0                	test   %al,%al
  801628:	75 e8                	jne    801612 <strnlen+0xf>
		n++;
	return n;
  80162a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80163b:	90                   	nop
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	8d 50 01             	lea    0x1(%eax),%edx
  801642:	89 55 08             	mov    %edx,0x8(%ebp)
  801645:	8b 55 0c             	mov    0xc(%ebp),%edx
  801648:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80164e:	8a 12                	mov    (%edx),%dl
  801650:	88 10                	mov    %dl,(%eax)
  801652:	8a 00                	mov    (%eax),%al
  801654:	84 c0                	test   %al,%al
  801656:	75 e4                	jne    80163c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801658:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801669:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801670:	eb 1f                	jmp    801691 <strncpy+0x34>
		*dst++ = *src;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	8d 50 01             	lea    0x1(%eax),%edx
  801678:	89 55 08             	mov    %edx,0x8(%ebp)
  80167b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167e:	8a 12                	mov    (%edx),%dl
  801680:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801682:	8b 45 0c             	mov    0xc(%ebp),%eax
  801685:	8a 00                	mov    (%eax),%al
  801687:	84 c0                	test   %al,%al
  801689:	74 03                	je     80168e <strncpy+0x31>
			src++;
  80168b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80168e:	ff 45 fc             	incl   -0x4(%ebp)
  801691:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801694:	3b 45 10             	cmp    0x10(%ebp),%eax
  801697:	72 d9                	jb     801672 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801699:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8016aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ae:	74 30                	je     8016e0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8016b0:	eb 16                	jmp    8016c8 <strlcpy+0x2a>
			*dst++ = *src++;
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8d 50 01             	lea    0x1(%eax),%edx
  8016b8:	89 55 08             	mov    %edx,0x8(%ebp)
  8016bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016c4:	8a 12                	mov    (%edx),%dl
  8016c6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016c8:	ff 4d 10             	decl   0x10(%ebp)
  8016cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016cf:	74 09                	je     8016da <strlcpy+0x3c>
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	84 c0                	test   %al,%al
  8016d8:	75 d8                	jne    8016b2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	29 c2                	sub    %eax,%edx
  8016e8:	89 d0                	mov    %edx,%eax
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016ef:	eb 06                	jmp    8016f7 <strcmp+0xb>
		p++, q++;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	8a 00                	mov    (%eax),%al
  8016fc:	84 c0                	test   %al,%al
  8016fe:	74 0e                	je     80170e <strcmp+0x22>
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 10                	mov    (%eax),%dl
  801705:	8b 45 0c             	mov    0xc(%ebp),%eax
  801708:	8a 00                	mov    (%eax),%al
  80170a:	38 c2                	cmp    %al,%dl
  80170c:	74 e3                	je     8016f1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	0f b6 d0             	movzbl %al,%edx
  801716:	8b 45 0c             	mov    0xc(%ebp),%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	0f b6 c0             	movzbl %al,%eax
  80171e:	29 c2                	sub    %eax,%edx
  801720:	89 d0                	mov    %edx,%eax
}
  801722:	5d                   	pop    %ebp
  801723:	c3                   	ret    

00801724 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801727:	eb 09                	jmp    801732 <strncmp+0xe>
		n--, p++, q++;
  801729:	ff 4d 10             	decl   0x10(%ebp)
  80172c:	ff 45 08             	incl   0x8(%ebp)
  80172f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801732:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801736:	74 17                	je     80174f <strncmp+0x2b>
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	84 c0                	test   %al,%al
  80173f:	74 0e                	je     80174f <strncmp+0x2b>
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8a 10                	mov    (%eax),%dl
  801746:	8b 45 0c             	mov    0xc(%ebp),%eax
  801749:	8a 00                	mov    (%eax),%al
  80174b:	38 c2                	cmp    %al,%dl
  80174d:	74 da                	je     801729 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80174f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801753:	75 07                	jne    80175c <strncmp+0x38>
		return 0;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
  80175a:	eb 14                	jmp    801770 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8a 00                	mov    (%eax),%al
  801761:	0f b6 d0             	movzbl %al,%edx
  801764:	8b 45 0c             	mov    0xc(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	0f b6 c0             	movzbl %al,%eax
  80176c:	29 c2                	sub    %eax,%edx
  80176e:	89 d0                	mov    %edx,%eax
}
  801770:	5d                   	pop    %ebp
  801771:	c3                   	ret    

00801772 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80177e:	eb 12                	jmp    801792 <strchr+0x20>
		if (*s == c)
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	8a 00                	mov    (%eax),%al
  801785:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801788:	75 05                	jne    80178f <strchr+0x1d>
			return (char *) s;
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	eb 11                	jmp    8017a0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80178f:	ff 45 08             	incl   0x8(%ebp)
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8a 00                	mov    (%eax),%al
  801797:	84 c0                	test   %al,%al
  801799:	75 e5                	jne    801780 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80179b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 04             	sub    $0x4,%esp
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017ae:	eb 0d                	jmp    8017bd <strfind+0x1b>
		if (*s == c)
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8017b8:	74 0e                	je     8017c8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017ba:	ff 45 08             	incl   0x8(%ebp)
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	8a 00                	mov    (%eax),%al
  8017c2:	84 c0                	test   %al,%al
  8017c4:	75 ea                	jne    8017b0 <strfind+0xe>
  8017c6:	eb 01                	jmp    8017c9 <strfind+0x27>
		if (*s == c)
			break;
  8017c8:	90                   	nop
	return (char *) s;
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017da:	8b 45 10             	mov    0x10(%ebp),%eax
  8017dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017e0:	eb 0e                	jmp    8017f0 <memset+0x22>
		*p++ = c;
  8017e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e5:	8d 50 01             	lea    0x1(%eax),%edx
  8017e8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017f0:	ff 4d f8             	decl   -0x8(%ebp)
  8017f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017f7:	79 e9                	jns    8017e2 <memset+0x14>
		*p++ = c;

	return v;
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801804:	8b 45 0c             	mov    0xc(%ebp),%eax
  801807:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801810:	eb 16                	jmp    801828 <memcpy+0x2a>
		*d++ = *s++;
  801812:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801815:	8d 50 01             	lea    0x1(%eax),%edx
  801818:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80181b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801821:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801824:	8a 12                	mov    (%edx),%dl
  801826:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801828:	8b 45 10             	mov    0x10(%ebp),%eax
  80182b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182e:	89 55 10             	mov    %edx,0x10(%ebp)
  801831:	85 c0                	test   %eax,%eax
  801833:	75 dd                	jne    801812 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801840:	8b 45 0c             	mov    0xc(%ebp),%eax
  801843:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80184c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801852:	73 50                	jae    8018a4 <memmove+0x6a>
  801854:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801857:	8b 45 10             	mov    0x10(%ebp),%eax
  80185a:	01 d0                	add    %edx,%eax
  80185c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80185f:	76 43                	jbe    8018a4 <memmove+0x6a>
		s += n;
  801861:	8b 45 10             	mov    0x10(%ebp),%eax
  801864:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801867:	8b 45 10             	mov    0x10(%ebp),%eax
  80186a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80186d:	eb 10                	jmp    80187f <memmove+0x45>
			*--d = *--s;
  80186f:	ff 4d f8             	decl   -0x8(%ebp)
  801872:	ff 4d fc             	decl   -0x4(%ebp)
  801875:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801878:	8a 10                	mov    (%eax),%dl
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	8d 50 ff             	lea    -0x1(%eax),%edx
  801885:	89 55 10             	mov    %edx,0x10(%ebp)
  801888:	85 c0                	test   %eax,%eax
  80188a:	75 e3                	jne    80186f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80188c:	eb 23                	jmp    8018b1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80188e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801891:	8d 50 01             	lea    0x1(%eax),%edx
  801894:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801897:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a0:	8a 12                	mov    (%edx),%dl
  8018a2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	75 dd                	jne    80188e <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8018c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018c8:	eb 2a                	jmp    8018f4 <memcmp+0x3e>
		if (*s1 != *s2)
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cd:	8a 10                	mov    (%eax),%dl
  8018cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d2:	8a 00                	mov    (%eax),%al
  8018d4:	38 c2                	cmp    %al,%dl
  8018d6:	74 16                	je     8018ee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018db:	8a 00                	mov    (%eax),%al
  8018dd:	0f b6 d0             	movzbl %al,%edx
  8018e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e3:	8a 00                	mov    (%eax),%al
  8018e5:	0f b6 c0             	movzbl %al,%eax
  8018e8:	29 c2                	sub    %eax,%edx
  8018ea:	89 d0                	mov    %edx,%eax
  8018ec:	eb 18                	jmp    801906 <memcmp+0x50>
		s1++, s2++;
  8018ee:	ff 45 fc             	incl   -0x4(%ebp)
  8018f1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	75 c9                	jne    8018ca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801901:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80190e:	8b 55 08             	mov    0x8(%ebp),%edx
  801911:	8b 45 10             	mov    0x10(%ebp),%eax
  801914:	01 d0                	add    %edx,%eax
  801916:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801919:	eb 15                	jmp    801930 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	8a 00                	mov    (%eax),%al
  801920:	0f b6 d0             	movzbl %al,%edx
  801923:	8b 45 0c             	mov    0xc(%ebp),%eax
  801926:	0f b6 c0             	movzbl %al,%eax
  801929:	39 c2                	cmp    %eax,%edx
  80192b:	74 0d                	je     80193a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80192d:	ff 45 08             	incl   0x8(%ebp)
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801936:	72 e3                	jb     80191b <memfind+0x13>
  801938:	eb 01                	jmp    80193b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80193a:	90                   	nop
	return (void *) s;
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801946:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80194d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801954:	eb 03                	jmp    801959 <strtol+0x19>
		s++;
  801956:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	3c 20                	cmp    $0x20,%al
  801960:	74 f4                	je     801956 <strtol+0x16>
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	8a 00                	mov    (%eax),%al
  801967:	3c 09                	cmp    $0x9,%al
  801969:	74 eb                	je     801956 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	8a 00                	mov    (%eax),%al
  801970:	3c 2b                	cmp    $0x2b,%al
  801972:	75 05                	jne    801979 <strtol+0x39>
		s++;
  801974:	ff 45 08             	incl   0x8(%ebp)
  801977:	eb 13                	jmp    80198c <strtol+0x4c>
	else if (*s == '-')
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	3c 2d                	cmp    $0x2d,%al
  801980:	75 0a                	jne    80198c <strtol+0x4c>
		s++, neg = 1;
  801982:	ff 45 08             	incl   0x8(%ebp)
  801985:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80198c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801990:	74 06                	je     801998 <strtol+0x58>
  801992:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801996:	75 20                	jne    8019b8 <strtol+0x78>
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	3c 30                	cmp    $0x30,%al
  80199f:	75 17                	jne    8019b8 <strtol+0x78>
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	40                   	inc    %eax
  8019a5:	8a 00                	mov    (%eax),%al
  8019a7:	3c 78                	cmp    $0x78,%al
  8019a9:	75 0d                	jne    8019b8 <strtol+0x78>
		s += 2, base = 16;
  8019ab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019af:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019b6:	eb 28                	jmp    8019e0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8019b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019bc:	75 15                	jne    8019d3 <strtol+0x93>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 30                	cmp    $0x30,%al
  8019c5:	75 0c                	jne    8019d3 <strtol+0x93>
		s++, base = 8;
  8019c7:	ff 45 08             	incl   0x8(%ebp)
  8019ca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019d1:	eb 0d                	jmp    8019e0 <strtol+0xa0>
	else if (base == 0)
  8019d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019d7:	75 07                	jne    8019e0 <strtol+0xa0>
		base = 10;
  8019d9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	3c 2f                	cmp    $0x2f,%al
  8019e7:	7e 19                	jle    801a02 <strtol+0xc2>
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	3c 39                	cmp    $0x39,%al
  8019f0:	7f 10                	jg     801a02 <strtol+0xc2>
			dig = *s - '0';
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	8a 00                	mov    (%eax),%al
  8019f7:	0f be c0             	movsbl %al,%eax
  8019fa:	83 e8 30             	sub    $0x30,%eax
  8019fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a00:	eb 42                	jmp    801a44 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	8a 00                	mov    (%eax),%al
  801a07:	3c 60                	cmp    $0x60,%al
  801a09:	7e 19                	jle    801a24 <strtol+0xe4>
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	8a 00                	mov    (%eax),%al
  801a10:	3c 7a                	cmp    $0x7a,%al
  801a12:	7f 10                	jg     801a24 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	8a 00                	mov    (%eax),%al
  801a19:	0f be c0             	movsbl %al,%eax
  801a1c:	83 e8 57             	sub    $0x57,%eax
  801a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a22:	eb 20                	jmp    801a44 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	8a 00                	mov    (%eax),%al
  801a29:	3c 40                	cmp    $0x40,%al
  801a2b:	7e 39                	jle    801a66 <strtol+0x126>
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	8a 00                	mov    (%eax),%al
  801a32:	3c 5a                	cmp    $0x5a,%al
  801a34:	7f 30                	jg     801a66 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	8a 00                	mov    (%eax),%al
  801a3b:	0f be c0             	movsbl %al,%eax
  801a3e:	83 e8 37             	sub    $0x37,%eax
  801a41:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a47:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a4a:	7d 19                	jge    801a65 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a4c:	ff 45 08             	incl   0x8(%ebp)
  801a4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a52:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a56:	89 c2                	mov    %eax,%edx
  801a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5b:	01 d0                	add    %edx,%eax
  801a5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a60:	e9 7b ff ff ff       	jmp    8019e0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a65:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a6a:	74 08                	je     801a74 <strtol+0x134>
		*endptr = (char *) s;
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a72:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a74:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a78:	74 07                	je     801a81 <strtol+0x141>
  801a7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a7d:	f7 d8                	neg    %eax
  801a7f:	eb 03                	jmp    801a84 <strtol+0x144>
  801a81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <ltostr>:

void
ltostr(long value, char *str)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a93:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a9e:	79 13                	jns    801ab3 <ltostr+0x2d>
	{
		neg = 1;
  801aa0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801aad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801ab0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801abb:	99                   	cltd   
  801abc:	f7 f9                	idiv   %ecx
  801abe:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801ac1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac4:	8d 50 01             	lea    0x1(%eax),%edx
  801ac7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aca:	89 c2                	mov    %eax,%edx
  801acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acf:	01 d0                	add    %edx,%eax
  801ad1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ad4:	83 c2 30             	add    $0x30,%edx
  801ad7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ad9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801adc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ae1:	f7 e9                	imul   %ecx
  801ae3:	c1 fa 02             	sar    $0x2,%edx
  801ae6:	89 c8                	mov    %ecx,%eax
  801ae8:	c1 f8 1f             	sar    $0x1f,%eax
  801aeb:	29 c2                	sub    %eax,%edx
  801aed:	89 d0                	mov    %edx,%eax
  801aef:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801af2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801afa:	f7 e9                	imul   %ecx
  801afc:	c1 fa 02             	sar    $0x2,%edx
  801aff:	89 c8                	mov    %ecx,%eax
  801b01:	c1 f8 1f             	sar    $0x1f,%eax
  801b04:	29 c2                	sub    %eax,%edx
  801b06:	89 d0                	mov    %edx,%eax
  801b08:	c1 e0 02             	shl    $0x2,%eax
  801b0b:	01 d0                	add    %edx,%eax
  801b0d:	01 c0                	add    %eax,%eax
  801b0f:	29 c1                	sub    %eax,%ecx
  801b11:	89 ca                	mov    %ecx,%edx
  801b13:	85 d2                	test   %edx,%edx
  801b15:	75 9c                	jne    801ab3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b21:	48                   	dec    %eax
  801b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b25:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b29:	74 3d                	je     801b68 <ltostr+0xe2>
		start = 1 ;
  801b2b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b32:	eb 34                	jmp    801b68 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3a:	01 d0                	add    %edx,%eax
  801b3c:	8a 00                	mov    (%eax),%al
  801b3e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b47:	01 c2                	add    %eax,%edx
  801b49:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4f:	01 c8                	add    %ecx,%eax
  801b51:	8a 00                	mov    (%eax),%al
  801b53:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	01 c2                	add    %eax,%edx
  801b5d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b60:	88 02                	mov    %al,(%edx)
		start++ ;
  801b62:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b65:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b6e:	7c c4                	jl     801b34 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b70:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b76:	01 d0                	add    %edx,%eax
  801b78:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b7b:	90                   	nop
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	e8 54 fa ff ff       	call   8015e0 <strlen>
  801b8c:	83 c4 04             	add    $0x4,%esp
  801b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	e8 46 fa ff ff       	call   8015e0 <strlen>
  801b9a:	83 c4 04             	add    $0x4,%esp
  801b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ba0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801ba7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bae:	eb 17                	jmp    801bc7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801bb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb6:	01 c2                	add    %eax,%edx
  801bb8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	01 c8                	add    %ecx,%eax
  801bc0:	8a 00                	mov    (%eax),%al
  801bc2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801bc4:	ff 45 fc             	incl   -0x4(%ebp)
  801bc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bcd:	7c e1                	jl     801bb0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bcf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bd6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bdd:	eb 1f                	jmp    801bfe <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be2:	8d 50 01             	lea    0x1(%eax),%edx
  801be5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801be8:	89 c2                	mov    %eax,%edx
  801bea:	8b 45 10             	mov    0x10(%ebp),%eax
  801bed:	01 c2                	add    %eax,%edx
  801bef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf5:	01 c8                	add    %ecx,%eax
  801bf7:	8a 00                	mov    (%eax),%al
  801bf9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bfb:	ff 45 f8             	incl   -0x8(%ebp)
  801bfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c01:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c04:	7c d9                	jl     801bdf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c6 00 00             	movb   $0x0,(%eax)
}
  801c11:	90                   	nop
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c17:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c20:	8b 45 14             	mov    0x14(%ebp),%eax
  801c23:	8b 00                	mov    (%eax),%eax
  801c25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2f:	01 d0                	add    %edx,%eax
  801c31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c37:	eb 0c                	jmp    801c45 <strsplit+0x31>
			*string++ = 0;
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	8d 50 01             	lea    0x1(%eax),%edx
  801c3f:	89 55 08             	mov    %edx,0x8(%ebp)
  801c42:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8a 00                	mov    (%eax),%al
  801c4a:	84 c0                	test   %al,%al
  801c4c:	74 18                	je     801c66 <strsplit+0x52>
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8a 00                	mov    (%eax),%al
  801c53:	0f be c0             	movsbl %al,%eax
  801c56:	50                   	push   %eax
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	e8 13 fb ff ff       	call   801772 <strchr>
  801c5f:	83 c4 08             	add    $0x8,%esp
  801c62:	85 c0                	test   %eax,%eax
  801c64:	75 d3                	jne    801c39 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	8a 00                	mov    (%eax),%al
  801c6b:	84 c0                	test   %al,%al
  801c6d:	74 5a                	je     801cc9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c72:	8b 00                	mov    (%eax),%eax
  801c74:	83 f8 0f             	cmp    $0xf,%eax
  801c77:	75 07                	jne    801c80 <strsplit+0x6c>
		{
			return 0;
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7e:	eb 66                	jmp    801ce6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c80:	8b 45 14             	mov    0x14(%ebp),%eax
  801c83:	8b 00                	mov    (%eax),%eax
  801c85:	8d 48 01             	lea    0x1(%eax),%ecx
  801c88:	8b 55 14             	mov    0x14(%ebp),%edx
  801c8b:	89 0a                	mov    %ecx,(%edx)
  801c8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c94:	8b 45 10             	mov    0x10(%ebp),%eax
  801c97:	01 c2                	add    %eax,%edx
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c9e:	eb 03                	jmp    801ca3 <strsplit+0x8f>
			string++;
  801ca0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	8a 00                	mov    (%eax),%al
  801ca8:	84 c0                	test   %al,%al
  801caa:	74 8b                	je     801c37 <strsplit+0x23>
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	8a 00                	mov    (%eax),%al
  801cb1:	0f be c0             	movsbl %al,%eax
  801cb4:	50                   	push   %eax
  801cb5:	ff 75 0c             	pushl  0xc(%ebp)
  801cb8:	e8 b5 fa ff ff       	call   801772 <strchr>
  801cbd:	83 c4 08             	add    $0x8,%esp
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	74 dc                	je     801ca0 <strsplit+0x8c>
			string++;
	}
  801cc4:	e9 6e ff ff ff       	jmp    801c37 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cc9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cca:	8b 45 14             	mov    0x14(%ebp),%eax
  801ccd:	8b 00                	mov    (%eax),%eax
  801ccf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd9:	01 d0                	add    %edx,%eax
  801cdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ce1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801cee:	a1 04 50 80 00       	mov    0x805004,%eax
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	74 1f                	je     801d16 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801cf7:	e8 1d 00 00 00       	call   801d19 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801cfc:	83 ec 0c             	sub    $0xc,%esp
  801cff:	68 30 46 80 00       	push   $0x804630
  801d04:	e8 55 f2 ff ff       	call   800f5e <cprintf>
  801d09:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d0c:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801d13:	00 00 00 
	}
}
  801d16:	90                   	nop
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801d1f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801d26:	00 00 00 
  801d29:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801d30:	00 00 00 
  801d33:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801d3a:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801d3d:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801d44:	00 00 00 
  801d47:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801d4e:	00 00 00 
  801d51:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801d58:	00 00 00 
	uint32 arr_size = 0;
  801d5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801d62:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d71:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d76:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801d7b:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801d82:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801d85:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801d8c:	a1 20 51 80 00       	mov    0x805120,%eax
  801d91:	c1 e0 04             	shl    $0x4,%eax
  801d94:	89 c2                	mov    %eax,%edx
  801d96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d99:	01 d0                	add    %edx,%eax
  801d9b:	48                   	dec    %eax
  801d9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801da2:	ba 00 00 00 00       	mov    $0x0,%edx
  801da7:	f7 75 ec             	divl   -0x14(%ebp)
  801daa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dad:	29 d0                	sub    %edx,%eax
  801daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801db2:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dbc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dc1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dc6:	83 ec 04             	sub    $0x4,%esp
  801dc9:	6a 06                	push   $0x6
  801dcb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dce:	50                   	push   %eax
  801dcf:	e8 1d 04 00 00       	call   8021f1 <sys_allocate_chunk>
  801dd4:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801dd7:	a1 20 51 80 00       	mov    0x805120,%eax
  801ddc:	83 ec 0c             	sub    $0xc,%esp
  801ddf:	50                   	push   %eax
  801de0:	e8 92 0a 00 00       	call   802877 <initialize_MemBlocksList>
  801de5:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801de8:	a1 48 51 80 00       	mov    0x805148,%eax
  801ded:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801df0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801df3:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801dfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dfd:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801e04:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e08:	75 14                	jne    801e1e <initialize_dyn_block_system+0x105>
  801e0a:	83 ec 04             	sub    $0x4,%esp
  801e0d:	68 55 46 80 00       	push   $0x804655
  801e12:	6a 33                	push   $0x33
  801e14:	68 73 46 80 00       	push   $0x804673
  801e19:	e8 8c ee ff ff       	call   800caa <_panic>
  801e1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e21:	8b 00                	mov    (%eax),%eax
  801e23:	85 c0                	test   %eax,%eax
  801e25:	74 10                	je     801e37 <initialize_dyn_block_system+0x11e>
  801e27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e2a:	8b 00                	mov    (%eax),%eax
  801e2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e2f:	8b 52 04             	mov    0x4(%edx),%edx
  801e32:	89 50 04             	mov    %edx,0x4(%eax)
  801e35:	eb 0b                	jmp    801e42 <initialize_dyn_block_system+0x129>
  801e37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e3a:	8b 40 04             	mov    0x4(%eax),%eax
  801e3d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801e42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e45:	8b 40 04             	mov    0x4(%eax),%eax
  801e48:	85 c0                	test   %eax,%eax
  801e4a:	74 0f                	je     801e5b <initialize_dyn_block_system+0x142>
  801e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e4f:	8b 40 04             	mov    0x4(%eax),%eax
  801e52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e55:	8b 12                	mov    (%edx),%edx
  801e57:	89 10                	mov    %edx,(%eax)
  801e59:	eb 0a                	jmp    801e65 <initialize_dyn_block_system+0x14c>
  801e5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e5e:	8b 00                	mov    (%eax),%eax
  801e60:	a3 48 51 80 00       	mov    %eax,0x805148
  801e65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e78:	a1 54 51 80 00       	mov    0x805154,%eax
  801e7d:	48                   	dec    %eax
  801e7e:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801e83:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e87:	75 14                	jne    801e9d <initialize_dyn_block_system+0x184>
  801e89:	83 ec 04             	sub    $0x4,%esp
  801e8c:	68 80 46 80 00       	push   $0x804680
  801e91:	6a 34                	push   $0x34
  801e93:	68 73 46 80 00       	push   $0x804673
  801e98:	e8 0d ee ff ff       	call   800caa <_panic>
  801e9d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801ea3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea6:	89 10                	mov    %edx,(%eax)
  801ea8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eab:	8b 00                	mov    (%eax),%eax
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	74 0d                	je     801ebe <initialize_dyn_block_system+0x1a5>
  801eb1:	a1 38 51 80 00       	mov    0x805138,%eax
  801eb6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801eb9:	89 50 04             	mov    %edx,0x4(%eax)
  801ebc:	eb 08                	jmp    801ec6 <initialize_dyn_block_system+0x1ad>
  801ebe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ec1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801ec6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ec9:	a3 38 51 80 00       	mov    %eax,0x805138
  801ece:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ed1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ed8:	a1 44 51 80 00       	mov    0x805144,%eax
  801edd:	40                   	inc    %eax
  801ede:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801ee3:	90                   	nop
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801eec:	e8 f7 fd ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ef1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ef5:	75 07                	jne    801efe <malloc+0x18>
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  801efc:	eb 14                	jmp    801f12 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801efe:	83 ec 04             	sub    $0x4,%esp
  801f01:	68 a4 46 80 00       	push   $0x8046a4
  801f06:	6a 46                	push   $0x46
  801f08:	68 73 46 80 00       	push   $0x804673
  801f0d:	e8 98 ed ff ff       	call   800caa <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801f1a:	83 ec 04             	sub    $0x4,%esp
  801f1d:	68 cc 46 80 00       	push   $0x8046cc
  801f22:	6a 61                	push   $0x61
  801f24:	68 73 46 80 00       	push   $0x804673
  801f29:	e8 7c ed ff ff       	call   800caa <_panic>

00801f2e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	83 ec 38             	sub    $0x38,%esp
  801f34:	8b 45 10             	mov    0x10(%ebp),%eax
  801f37:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f3a:	e8 a9 fd ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f43:	75 07                	jne    801f4c <smalloc+0x1e>
  801f45:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4a:	eb 7c                	jmp    801fc8 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801f4c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f59:	01 d0                	add    %edx,%eax
  801f5b:	48                   	dec    %eax
  801f5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f62:	ba 00 00 00 00       	mov    $0x0,%edx
  801f67:	f7 75 f0             	divl   -0x10(%ebp)
  801f6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f6d:	29 d0                	sub    %edx,%eax
  801f6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801f72:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801f79:	e8 41 06 00 00       	call   8025bf <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	74 11                	je     801f93 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801f82:	83 ec 0c             	sub    $0xc,%esp
  801f85:	ff 75 e8             	pushl  -0x18(%ebp)
  801f88:	e8 ac 0c 00 00       	call   802c39 <alloc_block_FF>
  801f8d:	83 c4 10             	add    $0x10,%esp
  801f90:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801f93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f97:	74 2a                	je     801fc3 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	8b 40 08             	mov    0x8(%eax),%eax
  801f9f:	89 c2                	mov    %eax,%edx
  801fa1:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801fa5:	52                   	push   %edx
  801fa6:	50                   	push   %eax
  801fa7:	ff 75 0c             	pushl  0xc(%ebp)
  801faa:	ff 75 08             	pushl  0x8(%ebp)
  801fad:	e8 92 03 00 00       	call   802344 <sys_createSharedObject>
  801fb2:	83 c4 10             	add    $0x10,%esp
  801fb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801fb8:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801fbc:	74 05                	je     801fc3 <smalloc+0x95>
			return (void*)virtual_address;
  801fbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fc1:	eb 05                	jmp    801fc8 <smalloc+0x9a>
	}
	return NULL;
  801fc3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fd0:	e8 13 fd ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801fd5:	83 ec 04             	sub    $0x4,%esp
  801fd8:	68 f0 46 80 00       	push   $0x8046f0
  801fdd:	68 a2 00 00 00       	push   $0xa2
  801fe2:	68 73 46 80 00       	push   $0x804673
  801fe7:	e8 be ec ff ff       	call   800caa <_panic>

00801fec <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ff2:	e8 f1 fc ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ff7:	83 ec 04             	sub    $0x4,%esp
  801ffa:	68 14 47 80 00       	push   $0x804714
  801fff:	68 e6 00 00 00       	push   $0xe6
  802004:	68 73 46 80 00       	push   $0x804673
  802009:	e8 9c ec ff ff       	call   800caa <_panic>

0080200e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802014:	83 ec 04             	sub    $0x4,%esp
  802017:	68 3c 47 80 00       	push   $0x80473c
  80201c:	68 fa 00 00 00       	push   $0xfa
  802021:	68 73 46 80 00       	push   $0x804673
  802026:	e8 7f ec ff ff       	call   800caa <_panic>

0080202b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802031:	83 ec 04             	sub    $0x4,%esp
  802034:	68 60 47 80 00       	push   $0x804760
  802039:	68 05 01 00 00       	push   $0x105
  80203e:	68 73 46 80 00       	push   $0x804673
  802043:	e8 62 ec ff ff       	call   800caa <_panic>

00802048 <shrink>:

}
void shrink(uint32 newSize)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80204e:	83 ec 04             	sub    $0x4,%esp
  802051:	68 60 47 80 00       	push   $0x804760
  802056:	68 0a 01 00 00       	push   $0x10a
  80205b:	68 73 46 80 00       	push   $0x804673
  802060:	e8 45 ec ff ff       	call   800caa <_panic>

00802065 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80206b:	83 ec 04             	sub    $0x4,%esp
  80206e:	68 60 47 80 00       	push   $0x804760
  802073:	68 0f 01 00 00       	push   $0x10f
  802078:	68 73 46 80 00       	push   $0x804673
  80207d:	e8 28 ec ff ff       	call   800caa <_panic>

00802082 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	57                   	push   %edi
  802086:	56                   	push   %esi
  802087:	53                   	push   %ebx
  802088:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802091:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802094:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802097:	8b 7d 18             	mov    0x18(%ebp),%edi
  80209a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80209d:	cd 30                	int    $0x30
  80209f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020a5:	83 c4 10             	add    $0x10,%esp
  8020a8:	5b                   	pop    %ebx
  8020a9:	5e                   	pop    %esi
  8020aa:	5f                   	pop    %edi
  8020ab:	5d                   	pop    %ebp
  8020ac:	c3                   	ret    

008020ad <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 04             	sub    $0x4,%esp
  8020b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020b9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	52                   	push   %edx
  8020c5:	ff 75 0c             	pushl  0xc(%ebp)
  8020c8:	50                   	push   %eax
  8020c9:	6a 00                	push   $0x0
  8020cb:	e8 b2 ff ff ff       	call   802082 <syscall>
  8020d0:	83 c4 18             	add    $0x18,%esp
}
  8020d3:	90                   	nop
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 01                	push   $0x1
  8020e5:	e8 98 ff ff ff       	call   802082 <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	52                   	push   %edx
  8020ff:	50                   	push   %eax
  802100:	6a 05                	push   $0x5
  802102:	e8 7b ff ff ff       	call   802082 <syscall>
  802107:	83 c4 18             	add    $0x18,%esp
}
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	56                   	push   %esi
  802110:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802111:	8b 75 18             	mov    0x18(%ebp),%esi
  802114:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802117:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80211a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	56                   	push   %esi
  802121:	53                   	push   %ebx
  802122:	51                   	push   %ecx
  802123:	52                   	push   %edx
  802124:	50                   	push   %eax
  802125:	6a 06                	push   $0x6
  802127:	e8 56 ff ff ff       	call   802082 <syscall>
  80212c:	83 c4 18             	add    $0x18,%esp
}
  80212f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802132:	5b                   	pop    %ebx
  802133:	5e                   	pop    %esi
  802134:	5d                   	pop    %ebp
  802135:	c3                   	ret    

00802136 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802139:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	52                   	push   %edx
  802146:	50                   	push   %eax
  802147:	6a 07                	push   $0x7
  802149:	e8 34 ff ff ff       	call   802082 <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	ff 75 0c             	pushl  0xc(%ebp)
  80215f:	ff 75 08             	pushl  0x8(%ebp)
  802162:	6a 08                	push   $0x8
  802164:	e8 19 ff ff ff       	call   802082 <syscall>
  802169:	83 c4 18             	add    $0x18,%esp
}
  80216c:	c9                   	leave  
  80216d:	c3                   	ret    

0080216e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 09                	push   $0x9
  80217d:	e8 00 ff ff ff       	call   802082 <syscall>
  802182:	83 c4 18             	add    $0x18,%esp
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 0a                	push   $0xa
  802196:	e8 e7 fe ff ff       	call   802082 <syscall>
  80219b:	83 c4 18             	add    $0x18,%esp
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 0b                	push   $0xb
  8021af:	e8 ce fe ff ff       	call   802082 <syscall>
  8021b4:	83 c4 18             	add    $0x18,%esp
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	ff 75 0c             	pushl  0xc(%ebp)
  8021c5:	ff 75 08             	pushl  0x8(%ebp)
  8021c8:	6a 0f                	push   $0xf
  8021ca:	e8 b3 fe ff ff       	call   802082 <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
	return;
  8021d2:	90                   	nop
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	ff 75 0c             	pushl  0xc(%ebp)
  8021e1:	ff 75 08             	pushl  0x8(%ebp)
  8021e4:	6a 10                	push   $0x10
  8021e6:	e8 97 fe ff ff       	call   802082 <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ee:	90                   	nop
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	ff 75 10             	pushl  0x10(%ebp)
  8021fb:	ff 75 0c             	pushl  0xc(%ebp)
  8021fe:	ff 75 08             	pushl  0x8(%ebp)
  802201:	6a 11                	push   $0x11
  802203:	e8 7a fe ff ff       	call   802082 <syscall>
  802208:	83 c4 18             	add    $0x18,%esp
	return ;
  80220b:	90                   	nop
}
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 0c                	push   $0xc
  80221d:	e8 60 fe ff ff       	call   802082 <syscall>
  802222:	83 c4 18             	add    $0x18,%esp
}
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	ff 75 08             	pushl  0x8(%ebp)
  802235:	6a 0d                	push   $0xd
  802237:	e8 46 fe ff ff       	call   802082 <syscall>
  80223c:	83 c4 18             	add    $0x18,%esp
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 0e                	push   $0xe
  802250:	e8 2d fe ff ff       	call   802082 <syscall>
  802255:	83 c4 18             	add    $0x18,%esp
}
  802258:	90                   	nop
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 13                	push   $0x13
  80226a:	e8 13 fe ff ff       	call   802082 <syscall>
  80226f:	83 c4 18             	add    $0x18,%esp
}
  802272:	90                   	nop
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 14                	push   $0x14
  802284:	e8 f9 fd ff ff       	call   802082 <syscall>
  802289:	83 c4 18             	add    $0x18,%esp
}
  80228c:	90                   	nop
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <sys_cputc>:


void
sys_cputc(const char c)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	83 ec 04             	sub    $0x4,%esp
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80229b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	50                   	push   %eax
  8022a8:	6a 15                	push   $0x15
  8022aa:	e8 d3 fd ff ff       	call   802082 <syscall>
  8022af:	83 c4 18             	add    $0x18,%esp
}
  8022b2:	90                   	nop
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 16                	push   $0x16
  8022c4:	e8 b9 fd ff ff       	call   802082 <syscall>
  8022c9:	83 c4 18             	add    $0x18,%esp
}
  8022cc:	90                   	nop
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	ff 75 0c             	pushl  0xc(%ebp)
  8022de:	50                   	push   %eax
  8022df:	6a 17                	push   $0x17
  8022e1:	e8 9c fd ff ff       	call   802082 <syscall>
  8022e6:	83 c4 18             	add    $0x18,%esp
}
  8022e9:	c9                   	leave  
  8022ea:	c3                   	ret    

008022eb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	52                   	push   %edx
  8022fb:	50                   	push   %eax
  8022fc:	6a 1a                	push   $0x1a
  8022fe:	e8 7f fd ff ff       	call   802082 <syscall>
  802303:	83 c4 18             	add    $0x18,%esp
}
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80230b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230e:	8b 45 08             	mov    0x8(%ebp),%eax
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	52                   	push   %edx
  802318:	50                   	push   %eax
  802319:	6a 18                	push   $0x18
  80231b:	e8 62 fd ff ff       	call   802082 <syscall>
  802320:	83 c4 18             	add    $0x18,%esp
}
  802323:	90                   	nop
  802324:	c9                   	leave  
  802325:	c3                   	ret    

00802326 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802329:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	52                   	push   %edx
  802336:	50                   	push   %eax
  802337:	6a 19                	push   $0x19
  802339:	e8 44 fd ff ff       	call   802082 <syscall>
  80233e:	83 c4 18             	add    $0x18,%esp
}
  802341:	90                   	nop
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	83 ec 04             	sub    $0x4,%esp
  80234a:	8b 45 10             	mov    0x10(%ebp),%eax
  80234d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802350:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802353:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	6a 00                	push   $0x0
  80235c:	51                   	push   %ecx
  80235d:	52                   	push   %edx
  80235e:	ff 75 0c             	pushl  0xc(%ebp)
  802361:	50                   	push   %eax
  802362:	6a 1b                	push   $0x1b
  802364:	e8 19 fd ff ff       	call   802082 <syscall>
  802369:	83 c4 18             	add    $0x18,%esp
}
  80236c:	c9                   	leave  
  80236d:	c3                   	ret    

0080236e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802371:	8b 55 0c             	mov    0xc(%ebp),%edx
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	52                   	push   %edx
  80237e:	50                   	push   %eax
  80237f:	6a 1c                	push   $0x1c
  802381:	e8 fc fc ff ff       	call   802082 <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80238e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802391:	8b 55 0c             	mov    0xc(%ebp),%edx
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	51                   	push   %ecx
  80239c:	52                   	push   %edx
  80239d:	50                   	push   %eax
  80239e:	6a 1d                	push   $0x1d
  8023a0:	e8 dd fc ff ff       	call   802082 <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	52                   	push   %edx
  8023ba:	50                   	push   %eax
  8023bb:	6a 1e                	push   $0x1e
  8023bd:	e8 c0 fc ff ff       	call   802082 <syscall>
  8023c2:	83 c4 18             	add    $0x18,%esp
}
  8023c5:	c9                   	leave  
  8023c6:	c3                   	ret    

008023c7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 1f                	push   $0x1f
  8023d6:	e8 a7 fc ff ff       	call   802082 <syscall>
  8023db:	83 c4 18             	add    $0x18,%esp
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	6a 00                	push   $0x0
  8023e8:	ff 75 14             	pushl  0x14(%ebp)
  8023eb:	ff 75 10             	pushl  0x10(%ebp)
  8023ee:	ff 75 0c             	pushl  0xc(%ebp)
  8023f1:	50                   	push   %eax
  8023f2:	6a 20                	push   $0x20
  8023f4:	e8 89 fc ff ff       	call   802082 <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	50                   	push   %eax
  80240d:	6a 21                	push   $0x21
  80240f:	e8 6e fc ff ff       	call   802082 <syscall>
  802414:	83 c4 18             	add    $0x18,%esp
}
  802417:	90                   	nop
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	50                   	push   %eax
  802429:	6a 22                	push   $0x22
  80242b:	e8 52 fc ff ff       	call   802082 <syscall>
  802430:	83 c4 18             	add    $0x18,%esp
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 02                	push   $0x2
  802444:	e8 39 fc ff ff       	call   802082 <syscall>
  802449:	83 c4 18             	add    $0x18,%esp
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 03                	push   $0x3
  80245d:	e8 20 fc ff ff       	call   802082 <syscall>
  802462:	83 c4 18             	add    $0x18,%esp
}
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 04                	push   $0x4
  802476:	e8 07 fc ff ff       	call   802082 <syscall>
  80247b:	83 c4 18             	add    $0x18,%esp
}
  80247e:	c9                   	leave  
  80247f:	c3                   	ret    

00802480 <sys_exit_env>:


void sys_exit_env(void)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 23                	push   $0x23
  80248f:	e8 ee fb ff ff       	call   802082 <syscall>
  802494:	83 c4 18             	add    $0x18,%esp
}
  802497:	90                   	nop
  802498:	c9                   	leave  
  802499:	c3                   	ret    

0080249a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
  80249d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024a0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024a3:	8d 50 04             	lea    0x4(%eax),%edx
  8024a6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	52                   	push   %edx
  8024b0:	50                   	push   %eax
  8024b1:	6a 24                	push   $0x24
  8024b3:	e8 ca fb ff ff       	call   802082 <syscall>
  8024b8:	83 c4 18             	add    $0x18,%esp
	return result;
  8024bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024c4:	89 01                	mov    %eax,(%ecx)
  8024c6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	c9                   	leave  
  8024cd:	c2 04 00             	ret    $0x4

008024d0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	ff 75 10             	pushl  0x10(%ebp)
  8024da:	ff 75 0c             	pushl  0xc(%ebp)
  8024dd:	ff 75 08             	pushl  0x8(%ebp)
  8024e0:	6a 12                	push   $0x12
  8024e2:	e8 9b fb ff ff       	call   802082 <syscall>
  8024e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ea:	90                   	nop
}
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <sys_rcr2>:
uint32 sys_rcr2()
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 25                	push   $0x25
  8024fc:	e8 81 fb ff ff       	call   802082 <syscall>
  802501:	83 c4 18             	add    $0x18,%esp
}
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	83 ec 04             	sub    $0x4,%esp
  80250c:	8b 45 08             	mov    0x8(%ebp),%eax
  80250f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802512:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	50                   	push   %eax
  80251f:	6a 26                	push   $0x26
  802521:	e8 5c fb ff ff       	call   802082 <syscall>
  802526:	83 c4 18             	add    $0x18,%esp
	return ;
  802529:	90                   	nop
}
  80252a:	c9                   	leave  
  80252b:	c3                   	ret    

0080252c <rsttst>:
void rsttst()
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 28                	push   $0x28
  80253b:	e8 42 fb ff ff       	call   802082 <syscall>
  802540:	83 c4 18             	add    $0x18,%esp
	return ;
  802543:	90                   	nop
}
  802544:	c9                   	leave  
  802545:	c3                   	ret    

00802546 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
  802549:	83 ec 04             	sub    $0x4,%esp
  80254c:	8b 45 14             	mov    0x14(%ebp),%eax
  80254f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802552:	8b 55 18             	mov    0x18(%ebp),%edx
  802555:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802559:	52                   	push   %edx
  80255a:	50                   	push   %eax
  80255b:	ff 75 10             	pushl  0x10(%ebp)
  80255e:	ff 75 0c             	pushl  0xc(%ebp)
  802561:	ff 75 08             	pushl  0x8(%ebp)
  802564:	6a 27                	push   $0x27
  802566:	e8 17 fb ff ff       	call   802082 <syscall>
  80256b:	83 c4 18             	add    $0x18,%esp
	return ;
  80256e:	90                   	nop
}
  80256f:	c9                   	leave  
  802570:	c3                   	ret    

00802571 <chktst>:
void chktst(uint32 n)
{
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	ff 75 08             	pushl  0x8(%ebp)
  80257f:	6a 29                	push   $0x29
  802581:	e8 fc fa ff ff       	call   802082 <syscall>
  802586:	83 c4 18             	add    $0x18,%esp
	return ;
  802589:	90                   	nop
}
  80258a:	c9                   	leave  
  80258b:	c3                   	ret    

0080258c <inctst>:

void inctst()
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 2a                	push   $0x2a
  80259b:	e8 e2 fa ff ff       	call   802082 <syscall>
  8025a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a3:	90                   	nop
}
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <gettst>:
uint32 gettst()
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 2b                	push   $0x2b
  8025b5:	e8 c8 fa ff ff       	call   802082 <syscall>
  8025ba:	83 c4 18             	add    $0x18,%esp
}
  8025bd:	c9                   	leave  
  8025be:	c3                   	ret    

008025bf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025bf:	55                   	push   %ebp
  8025c0:	89 e5                	mov    %esp,%ebp
  8025c2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 2c                	push   $0x2c
  8025d1:	e8 ac fa ff ff       	call   802082 <syscall>
  8025d6:	83 c4 18             	add    $0x18,%esp
  8025d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025dc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025e0:	75 07                	jne    8025e9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e7:	eb 05                	jmp    8025ee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ee:	c9                   	leave  
  8025ef:	c3                   	ret    

008025f0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
  8025f3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 2c                	push   $0x2c
  802602:	e8 7b fa ff ff       	call   802082 <syscall>
  802607:	83 c4 18             	add    $0x18,%esp
  80260a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80260d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802611:	75 07                	jne    80261a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802613:	b8 01 00 00 00       	mov    $0x1,%eax
  802618:	eb 05                	jmp    80261f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80261a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261f:	c9                   	leave  
  802620:	c3                   	ret    

00802621 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802621:	55                   	push   %ebp
  802622:	89 e5                	mov    %esp,%ebp
  802624:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	6a 2c                	push   $0x2c
  802633:	e8 4a fa ff ff       	call   802082 <syscall>
  802638:	83 c4 18             	add    $0x18,%esp
  80263b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80263e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802642:	75 07                	jne    80264b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802644:	b8 01 00 00 00       	mov    $0x1,%eax
  802649:	eb 05                	jmp    802650 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80264b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802650:	c9                   	leave  
  802651:	c3                   	ret    

00802652 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802652:	55                   	push   %ebp
  802653:	89 e5                	mov    %esp,%ebp
  802655:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 2c                	push   $0x2c
  802664:	e8 19 fa ff ff       	call   802082 <syscall>
  802669:	83 c4 18             	add    $0x18,%esp
  80266c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80266f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802673:	75 07                	jne    80267c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802675:	b8 01 00 00 00       	mov    $0x1,%eax
  80267a:	eb 05                	jmp    802681 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80267c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802681:	c9                   	leave  
  802682:	c3                   	ret    

00802683 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802683:	55                   	push   %ebp
  802684:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	ff 75 08             	pushl  0x8(%ebp)
  802691:	6a 2d                	push   $0x2d
  802693:	e8 ea f9 ff ff       	call   802082 <syscall>
  802698:	83 c4 18             	add    $0x18,%esp
	return ;
  80269b:	90                   	nop
}
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
  8026a1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ae:	6a 00                	push   $0x0
  8026b0:	53                   	push   %ebx
  8026b1:	51                   	push   %ecx
  8026b2:	52                   	push   %edx
  8026b3:	50                   	push   %eax
  8026b4:	6a 2e                	push   $0x2e
  8026b6:	e8 c7 f9 ff ff       	call   802082 <syscall>
  8026bb:	83 c4 18             	add    $0x18,%esp
}
  8026be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026c1:	c9                   	leave  
  8026c2:	c3                   	ret    

008026c3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cc:	6a 00                	push   $0x0
  8026ce:	6a 00                	push   $0x0
  8026d0:	6a 00                	push   $0x0
  8026d2:	52                   	push   %edx
  8026d3:	50                   	push   %eax
  8026d4:	6a 2f                	push   $0x2f
  8026d6:	e8 a7 f9 ff ff       	call   802082 <syscall>
  8026db:	83 c4 18             	add    $0x18,%esp
}
  8026de:	c9                   	leave  
  8026df:	c3                   	ret    

008026e0 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8026e0:	55                   	push   %ebp
  8026e1:	89 e5                	mov    %esp,%ebp
  8026e3:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026e6:	83 ec 0c             	sub    $0xc,%esp
  8026e9:	68 70 47 80 00       	push   $0x804770
  8026ee:	e8 6b e8 ff ff       	call   800f5e <cprintf>
  8026f3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026fd:	83 ec 0c             	sub    $0xc,%esp
  802700:	68 9c 47 80 00       	push   $0x80479c
  802705:	e8 54 e8 ff ff       	call   800f5e <cprintf>
  80270a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80270d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802711:	a1 38 51 80 00       	mov    0x805138,%eax
  802716:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802719:	eb 56                	jmp    802771 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80271b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80271f:	74 1c                	je     80273d <print_mem_block_lists+0x5d>
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 50 08             	mov    0x8(%eax),%edx
  802727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272a:	8b 48 08             	mov    0x8(%eax),%ecx
  80272d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802730:	8b 40 0c             	mov    0xc(%eax),%eax
  802733:	01 c8                	add    %ecx,%eax
  802735:	39 c2                	cmp    %eax,%edx
  802737:	73 04                	jae    80273d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802739:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 50 08             	mov    0x8(%eax),%edx
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 40 0c             	mov    0xc(%eax),%eax
  802749:	01 c2                	add    %eax,%edx
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	8b 40 08             	mov    0x8(%eax),%eax
  802751:	83 ec 04             	sub    $0x4,%esp
  802754:	52                   	push   %edx
  802755:	50                   	push   %eax
  802756:	68 b1 47 80 00       	push   $0x8047b1
  80275b:	e8 fe e7 ff ff       	call   800f5e <cprintf>
  802760:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802769:	a1 40 51 80 00       	mov    0x805140,%eax
  80276e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802771:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802775:	74 07                	je     80277e <print_mem_block_lists+0x9e>
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	8b 00                	mov    (%eax),%eax
  80277c:	eb 05                	jmp    802783 <print_mem_block_lists+0xa3>
  80277e:	b8 00 00 00 00       	mov    $0x0,%eax
  802783:	a3 40 51 80 00       	mov    %eax,0x805140
  802788:	a1 40 51 80 00       	mov    0x805140,%eax
  80278d:	85 c0                	test   %eax,%eax
  80278f:	75 8a                	jne    80271b <print_mem_block_lists+0x3b>
  802791:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802795:	75 84                	jne    80271b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802797:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80279b:	75 10                	jne    8027ad <print_mem_block_lists+0xcd>
  80279d:	83 ec 0c             	sub    $0xc,%esp
  8027a0:	68 c0 47 80 00       	push   $0x8047c0
  8027a5:	e8 b4 e7 ff ff       	call   800f5e <cprintf>
  8027aa:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8027ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8027b4:	83 ec 0c             	sub    $0xc,%esp
  8027b7:	68 e4 47 80 00       	push   $0x8047e4
  8027bc:	e8 9d e7 ff ff       	call   800f5e <cprintf>
  8027c1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8027c4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027c8:	a1 40 50 80 00       	mov    0x805040,%eax
  8027cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d0:	eb 56                	jmp    802828 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027d6:	74 1c                	je     8027f4 <print_mem_block_lists+0x114>
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 50 08             	mov    0x8(%eax),%edx
  8027de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e1:	8b 48 08             	mov    0x8(%eax),%ecx
  8027e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ea:	01 c8                	add    %ecx,%eax
  8027ec:	39 c2                	cmp    %eax,%edx
  8027ee:	73 04                	jae    8027f4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027f0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	8b 50 08             	mov    0x8(%eax),%edx
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802800:	01 c2                	add    %eax,%edx
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 40 08             	mov    0x8(%eax),%eax
  802808:	83 ec 04             	sub    $0x4,%esp
  80280b:	52                   	push   %edx
  80280c:	50                   	push   %eax
  80280d:	68 b1 47 80 00       	push   $0x8047b1
  802812:	e8 47 e7 ff ff       	call   800f5e <cprintf>
  802817:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802820:	a1 48 50 80 00       	mov    0x805048,%eax
  802825:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802828:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282c:	74 07                	je     802835 <print_mem_block_lists+0x155>
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 00                	mov    (%eax),%eax
  802833:	eb 05                	jmp    80283a <print_mem_block_lists+0x15a>
  802835:	b8 00 00 00 00       	mov    $0x0,%eax
  80283a:	a3 48 50 80 00       	mov    %eax,0x805048
  80283f:	a1 48 50 80 00       	mov    0x805048,%eax
  802844:	85 c0                	test   %eax,%eax
  802846:	75 8a                	jne    8027d2 <print_mem_block_lists+0xf2>
  802848:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284c:	75 84                	jne    8027d2 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80284e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802852:	75 10                	jne    802864 <print_mem_block_lists+0x184>
  802854:	83 ec 0c             	sub    $0xc,%esp
  802857:	68 fc 47 80 00       	push   $0x8047fc
  80285c:	e8 fd e6 ff ff       	call   800f5e <cprintf>
  802861:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802864:	83 ec 0c             	sub    $0xc,%esp
  802867:	68 70 47 80 00       	push   $0x804770
  80286c:	e8 ed e6 ff ff       	call   800f5e <cprintf>
  802871:	83 c4 10             	add    $0x10,%esp

}
  802874:	90                   	nop
  802875:	c9                   	leave  
  802876:	c3                   	ret    

00802877 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802877:	55                   	push   %ebp
  802878:	89 e5                	mov    %esp,%ebp
  80287a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80287d:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802884:	00 00 00 
  802887:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80288e:	00 00 00 
  802891:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802898:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80289b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028a2:	e9 9e 00 00 00       	jmp    802945 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8028a7:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028af:	c1 e2 04             	shl    $0x4,%edx
  8028b2:	01 d0                	add    %edx,%eax
  8028b4:	85 c0                	test   %eax,%eax
  8028b6:	75 14                	jne    8028cc <initialize_MemBlocksList+0x55>
  8028b8:	83 ec 04             	sub    $0x4,%esp
  8028bb:	68 24 48 80 00       	push   $0x804824
  8028c0:	6a 46                	push   $0x46
  8028c2:	68 47 48 80 00       	push   $0x804847
  8028c7:	e8 de e3 ff ff       	call   800caa <_panic>
  8028cc:	a1 50 50 80 00       	mov    0x805050,%eax
  8028d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d4:	c1 e2 04             	shl    $0x4,%edx
  8028d7:	01 d0                	add    %edx,%eax
  8028d9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8028df:	89 10                	mov    %edx,(%eax)
  8028e1:	8b 00                	mov    (%eax),%eax
  8028e3:	85 c0                	test   %eax,%eax
  8028e5:	74 18                	je     8028ff <initialize_MemBlocksList+0x88>
  8028e7:	a1 48 51 80 00       	mov    0x805148,%eax
  8028ec:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028f2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028f5:	c1 e1 04             	shl    $0x4,%ecx
  8028f8:	01 ca                	add    %ecx,%edx
  8028fa:	89 50 04             	mov    %edx,0x4(%eax)
  8028fd:	eb 12                	jmp    802911 <initialize_MemBlocksList+0x9a>
  8028ff:	a1 50 50 80 00       	mov    0x805050,%eax
  802904:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802907:	c1 e2 04             	shl    $0x4,%edx
  80290a:	01 d0                	add    %edx,%eax
  80290c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802911:	a1 50 50 80 00       	mov    0x805050,%eax
  802916:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802919:	c1 e2 04             	shl    $0x4,%edx
  80291c:	01 d0                	add    %edx,%eax
  80291e:	a3 48 51 80 00       	mov    %eax,0x805148
  802923:	a1 50 50 80 00       	mov    0x805050,%eax
  802928:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292b:	c1 e2 04             	shl    $0x4,%edx
  80292e:	01 d0                	add    %edx,%eax
  802930:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802937:	a1 54 51 80 00       	mov    0x805154,%eax
  80293c:	40                   	inc    %eax
  80293d:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802942:	ff 45 f4             	incl   -0xc(%ebp)
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	3b 45 08             	cmp    0x8(%ebp),%eax
  80294b:	0f 82 56 ff ff ff    	jb     8028a7 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802951:	90                   	nop
  802952:	c9                   	leave  
  802953:	c3                   	ret    

00802954 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802954:	55                   	push   %ebp
  802955:	89 e5                	mov    %esp,%ebp
  802957:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80295a:	8b 45 08             	mov    0x8(%ebp),%eax
  80295d:	8b 00                	mov    (%eax),%eax
  80295f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802962:	eb 19                	jmp    80297d <find_block+0x29>
	{
		if(va==point->sva)
  802964:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802967:	8b 40 08             	mov    0x8(%eax),%eax
  80296a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80296d:	75 05                	jne    802974 <find_block+0x20>
		   return point;
  80296f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802972:	eb 36                	jmp    8029aa <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802974:	8b 45 08             	mov    0x8(%ebp),%eax
  802977:	8b 40 08             	mov    0x8(%eax),%eax
  80297a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80297d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802981:	74 07                	je     80298a <find_block+0x36>
  802983:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	eb 05                	jmp    80298f <find_block+0x3b>
  80298a:	b8 00 00 00 00       	mov    $0x0,%eax
  80298f:	8b 55 08             	mov    0x8(%ebp),%edx
  802992:	89 42 08             	mov    %eax,0x8(%edx)
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	8b 40 08             	mov    0x8(%eax),%eax
  80299b:	85 c0                	test   %eax,%eax
  80299d:	75 c5                	jne    802964 <find_block+0x10>
  80299f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029a3:	75 bf                	jne    802964 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8029a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029aa:	c9                   	leave  
  8029ab:	c3                   	ret    

008029ac <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8029ac:	55                   	push   %ebp
  8029ad:	89 e5                	mov    %esp,%ebp
  8029af:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8029b2:	a1 40 50 80 00       	mov    0x805040,%eax
  8029b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8029ba:	a1 44 50 80 00       	mov    0x805044,%eax
  8029bf:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8029c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029c8:	74 24                	je     8029ee <insert_sorted_allocList+0x42>
  8029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cd:	8b 50 08             	mov    0x8(%eax),%edx
  8029d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d3:	8b 40 08             	mov    0x8(%eax),%eax
  8029d6:	39 c2                	cmp    %eax,%edx
  8029d8:	76 14                	jbe    8029ee <insert_sorted_allocList+0x42>
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	8b 50 08             	mov    0x8(%eax),%edx
  8029e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e3:	8b 40 08             	mov    0x8(%eax),%eax
  8029e6:	39 c2                	cmp    %eax,%edx
  8029e8:	0f 82 60 01 00 00    	jb     802b4e <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8029ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f2:	75 65                	jne    802a59 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8029f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f8:	75 14                	jne    802a0e <insert_sorted_allocList+0x62>
  8029fa:	83 ec 04             	sub    $0x4,%esp
  8029fd:	68 24 48 80 00       	push   $0x804824
  802a02:	6a 6b                	push   $0x6b
  802a04:	68 47 48 80 00       	push   $0x804847
  802a09:	e8 9c e2 ff ff       	call   800caa <_panic>
  802a0e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	89 10                	mov    %edx,(%eax)
  802a19:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1c:	8b 00                	mov    (%eax),%eax
  802a1e:	85 c0                	test   %eax,%eax
  802a20:	74 0d                	je     802a2f <insert_sorted_allocList+0x83>
  802a22:	a1 40 50 80 00       	mov    0x805040,%eax
  802a27:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2a:	89 50 04             	mov    %edx,0x4(%eax)
  802a2d:	eb 08                	jmp    802a37 <insert_sorted_allocList+0x8b>
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	a3 44 50 80 00       	mov    %eax,0x805044
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	a3 40 50 80 00       	mov    %eax,0x805040
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a49:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a4e:	40                   	inc    %eax
  802a4f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a54:	e9 dc 01 00 00       	jmp    802c35 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802a59:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5c:	8b 50 08             	mov    0x8(%eax),%edx
  802a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a62:	8b 40 08             	mov    0x8(%eax),%eax
  802a65:	39 c2                	cmp    %eax,%edx
  802a67:	77 6c                	ja     802ad5 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802a69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a6d:	74 06                	je     802a75 <insert_sorted_allocList+0xc9>
  802a6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a73:	75 14                	jne    802a89 <insert_sorted_allocList+0xdd>
  802a75:	83 ec 04             	sub    $0x4,%esp
  802a78:	68 60 48 80 00       	push   $0x804860
  802a7d:	6a 6f                	push   $0x6f
  802a7f:	68 47 48 80 00       	push   $0x804847
  802a84:	e8 21 e2 ff ff       	call   800caa <_panic>
  802a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8c:	8b 50 04             	mov    0x4(%eax),%edx
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	89 50 04             	mov    %edx,0x4(%eax)
  802a95:	8b 45 08             	mov    0x8(%ebp),%eax
  802a98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a9b:	89 10                	mov    %edx,(%eax)
  802a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa0:	8b 40 04             	mov    0x4(%eax),%eax
  802aa3:	85 c0                	test   %eax,%eax
  802aa5:	74 0d                	je     802ab4 <insert_sorted_allocList+0x108>
  802aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aaa:	8b 40 04             	mov    0x4(%eax),%eax
  802aad:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab0:	89 10                	mov    %edx,(%eax)
  802ab2:	eb 08                	jmp    802abc <insert_sorted_allocList+0x110>
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	a3 40 50 80 00       	mov    %eax,0x805040
  802abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac2:	89 50 04             	mov    %edx,0x4(%eax)
  802ac5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802aca:	40                   	inc    %eax
  802acb:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ad0:	e9 60 01 00 00       	jmp    802c35 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	8b 50 08             	mov    0x8(%eax),%edx
  802adb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ade:	8b 40 08             	mov    0x8(%eax),%eax
  802ae1:	39 c2                	cmp    %eax,%edx
  802ae3:	0f 82 4c 01 00 00    	jb     802c35 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802ae9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aed:	75 14                	jne    802b03 <insert_sorted_allocList+0x157>
  802aef:	83 ec 04             	sub    $0x4,%esp
  802af2:	68 98 48 80 00       	push   $0x804898
  802af7:	6a 73                	push   $0x73
  802af9:	68 47 48 80 00       	push   $0x804847
  802afe:	e8 a7 e1 ff ff       	call   800caa <_panic>
  802b03:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	89 50 04             	mov    %edx,0x4(%eax)
  802b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b12:	8b 40 04             	mov    0x4(%eax),%eax
  802b15:	85 c0                	test   %eax,%eax
  802b17:	74 0c                	je     802b25 <insert_sorted_allocList+0x179>
  802b19:	a1 44 50 80 00       	mov    0x805044,%eax
  802b1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b21:	89 10                	mov    %edx,(%eax)
  802b23:	eb 08                	jmp    802b2d <insert_sorted_allocList+0x181>
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	a3 40 50 80 00       	mov    %eax,0x805040
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	a3 44 50 80 00       	mov    %eax,0x805044
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b43:	40                   	inc    %eax
  802b44:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b49:	e9 e7 00 00 00       	jmp    802c35 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802b54:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b5b:	a1 40 50 80 00       	mov    0x805040,%eax
  802b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b63:	e9 9d 00 00 00       	jmp    802c05 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 00                	mov    (%eax),%eax
  802b6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	8b 50 08             	mov    0x8(%eax),%edx
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 40 08             	mov    0x8(%eax),%eax
  802b7c:	39 c2                	cmp    %eax,%edx
  802b7e:	76 7d                	jbe    802bfd <insert_sorted_allocList+0x251>
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	8b 50 08             	mov    0x8(%eax),%edx
  802b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b89:	8b 40 08             	mov    0x8(%eax),%eax
  802b8c:	39 c2                	cmp    %eax,%edx
  802b8e:	73 6d                	jae    802bfd <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802b90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b94:	74 06                	je     802b9c <insert_sorted_allocList+0x1f0>
  802b96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b9a:	75 14                	jne    802bb0 <insert_sorted_allocList+0x204>
  802b9c:	83 ec 04             	sub    $0x4,%esp
  802b9f:	68 bc 48 80 00       	push   $0x8048bc
  802ba4:	6a 7f                	push   $0x7f
  802ba6:	68 47 48 80 00       	push   $0x804847
  802bab:	e8 fa e0 ff ff       	call   800caa <_panic>
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 10                	mov    (%eax),%edx
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	89 10                	mov    %edx,(%eax)
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	8b 00                	mov    (%eax),%eax
  802bbf:	85 c0                	test   %eax,%eax
  802bc1:	74 0b                	je     802bce <insert_sorted_allocList+0x222>
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	8b 00                	mov    (%eax),%eax
  802bc8:	8b 55 08             	mov    0x8(%ebp),%edx
  802bcb:	89 50 04             	mov    %edx,0x4(%eax)
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd4:	89 10                	mov    %edx,(%eax)
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bdc:	89 50 04             	mov    %edx,0x4(%eax)
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	8b 00                	mov    (%eax),%eax
  802be4:	85 c0                	test   %eax,%eax
  802be6:	75 08                	jne    802bf0 <insert_sorted_allocList+0x244>
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	a3 44 50 80 00       	mov    %eax,0x805044
  802bf0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bf5:	40                   	inc    %eax
  802bf6:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802bfb:	eb 39                	jmp    802c36 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802bfd:	a1 48 50 80 00       	mov    0x805048,%eax
  802c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c09:	74 07                	je     802c12 <insert_sorted_allocList+0x266>
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	eb 05                	jmp    802c17 <insert_sorted_allocList+0x26b>
  802c12:	b8 00 00 00 00       	mov    $0x0,%eax
  802c17:	a3 48 50 80 00       	mov    %eax,0x805048
  802c1c:	a1 48 50 80 00       	mov    0x805048,%eax
  802c21:	85 c0                	test   %eax,%eax
  802c23:	0f 85 3f ff ff ff    	jne    802b68 <insert_sorted_allocList+0x1bc>
  802c29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2d:	0f 85 35 ff ff ff    	jne    802b68 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c33:	eb 01                	jmp    802c36 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c35:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c36:	90                   	nop
  802c37:	c9                   	leave  
  802c38:	c3                   	ret    

00802c39 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c39:	55                   	push   %ebp
  802c3a:	89 e5                	mov    %esp,%ebp
  802c3c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c3f:	a1 38 51 80 00       	mov    0x805138,%eax
  802c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c47:	e9 85 01 00 00       	jmp    802dd1 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c52:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c55:	0f 82 6e 01 00 00    	jb     802dc9 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c61:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c64:	0f 85 8a 00 00 00    	jne    802cf4 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802c6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6e:	75 17                	jne    802c87 <alloc_block_FF+0x4e>
  802c70:	83 ec 04             	sub    $0x4,%esp
  802c73:	68 f0 48 80 00       	push   $0x8048f0
  802c78:	68 93 00 00 00       	push   $0x93
  802c7d:	68 47 48 80 00       	push   $0x804847
  802c82:	e8 23 e0 ff ff       	call   800caa <_panic>
  802c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8a:	8b 00                	mov    (%eax),%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	74 10                	je     802ca0 <alloc_block_FF+0x67>
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c98:	8b 52 04             	mov    0x4(%edx),%edx
  802c9b:	89 50 04             	mov    %edx,0x4(%eax)
  802c9e:	eb 0b                	jmp    802cab <alloc_block_FF+0x72>
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 40 04             	mov    0x4(%eax),%eax
  802ca6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	8b 40 04             	mov    0x4(%eax),%eax
  802cb1:	85 c0                	test   %eax,%eax
  802cb3:	74 0f                	je     802cc4 <alloc_block_FF+0x8b>
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	8b 40 04             	mov    0x4(%eax),%eax
  802cbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cbe:	8b 12                	mov    (%edx),%edx
  802cc0:	89 10                	mov    %edx,(%eax)
  802cc2:	eb 0a                	jmp    802cce <alloc_block_FF+0x95>
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	8b 00                	mov    (%eax),%eax
  802cc9:	a3 38 51 80 00       	mov    %eax,0x805138
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce1:	a1 44 51 80 00       	mov    0x805144,%eax
  802ce6:	48                   	dec    %eax
  802ce7:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	e9 10 01 00 00       	jmp    802e04 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cfd:	0f 86 c6 00 00 00    	jbe    802dc9 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d03:	a1 48 51 80 00       	mov    0x805148,%eax
  802d08:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	8b 50 08             	mov    0x8(%eax),%edx
  802d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d14:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d1d:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d24:	75 17                	jne    802d3d <alloc_block_FF+0x104>
  802d26:	83 ec 04             	sub    $0x4,%esp
  802d29:	68 f0 48 80 00       	push   $0x8048f0
  802d2e:	68 9b 00 00 00       	push   $0x9b
  802d33:	68 47 48 80 00       	push   $0x804847
  802d38:	e8 6d df ff ff       	call   800caa <_panic>
  802d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d40:	8b 00                	mov    (%eax),%eax
  802d42:	85 c0                	test   %eax,%eax
  802d44:	74 10                	je     802d56 <alloc_block_FF+0x11d>
  802d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d49:	8b 00                	mov    (%eax),%eax
  802d4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4e:	8b 52 04             	mov    0x4(%edx),%edx
  802d51:	89 50 04             	mov    %edx,0x4(%eax)
  802d54:	eb 0b                	jmp    802d61 <alloc_block_FF+0x128>
  802d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d59:	8b 40 04             	mov    0x4(%eax),%eax
  802d5c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d64:	8b 40 04             	mov    0x4(%eax),%eax
  802d67:	85 c0                	test   %eax,%eax
  802d69:	74 0f                	je     802d7a <alloc_block_FF+0x141>
  802d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6e:	8b 40 04             	mov    0x4(%eax),%eax
  802d71:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d74:	8b 12                	mov    (%edx),%edx
  802d76:	89 10                	mov    %edx,(%eax)
  802d78:	eb 0a                	jmp    802d84 <alloc_block_FF+0x14b>
  802d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7d:	8b 00                	mov    (%eax),%eax
  802d7f:	a3 48 51 80 00       	mov    %eax,0x805148
  802d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d97:	a1 54 51 80 00       	mov    0x805154,%eax
  802d9c:	48                   	dec    %eax
  802d9d:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 50 08             	mov    0x8(%eax),%edx
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	01 c2                	add    %eax,%edx
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 40 0c             	mov    0xc(%eax),%eax
  802db9:	2b 45 08             	sub    0x8(%ebp),%eax
  802dbc:	89 c2                	mov    %eax,%edx
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc7:	eb 3b                	jmp    802e04 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802dc9:	a1 40 51 80 00       	mov    0x805140,%eax
  802dce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd5:	74 07                	je     802dde <alloc_block_FF+0x1a5>
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 00                	mov    (%eax),%eax
  802ddc:	eb 05                	jmp    802de3 <alloc_block_FF+0x1aa>
  802dde:	b8 00 00 00 00       	mov    $0x0,%eax
  802de3:	a3 40 51 80 00       	mov    %eax,0x805140
  802de8:	a1 40 51 80 00       	mov    0x805140,%eax
  802ded:	85 c0                	test   %eax,%eax
  802def:	0f 85 57 fe ff ff    	jne    802c4c <alloc_block_FF+0x13>
  802df5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df9:	0f 85 4d fe ff ff    	jne    802c4c <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802dff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e04:	c9                   	leave  
  802e05:	c3                   	ret    

00802e06 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e06:	55                   	push   %ebp
  802e07:	89 e5                	mov    %esp,%ebp
  802e09:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802e0c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802e13:	a1 38 51 80 00       	mov    0x805138,%eax
  802e18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e1b:	e9 df 00 00 00       	jmp    802eff <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 40 0c             	mov    0xc(%eax),%eax
  802e26:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e29:	0f 82 c8 00 00 00    	jb     802ef7 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	8b 40 0c             	mov    0xc(%eax),%eax
  802e35:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e38:	0f 85 8a 00 00 00    	jne    802ec8 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802e3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e42:	75 17                	jne    802e5b <alloc_block_BF+0x55>
  802e44:	83 ec 04             	sub    $0x4,%esp
  802e47:	68 f0 48 80 00       	push   $0x8048f0
  802e4c:	68 b7 00 00 00       	push   $0xb7
  802e51:	68 47 48 80 00       	push   $0x804847
  802e56:	e8 4f de ff ff       	call   800caa <_panic>
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	8b 00                	mov    (%eax),%eax
  802e60:	85 c0                	test   %eax,%eax
  802e62:	74 10                	je     802e74 <alloc_block_BF+0x6e>
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	8b 00                	mov    (%eax),%eax
  802e69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e6c:	8b 52 04             	mov    0x4(%edx),%edx
  802e6f:	89 50 04             	mov    %edx,0x4(%eax)
  802e72:	eb 0b                	jmp    802e7f <alloc_block_BF+0x79>
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	8b 40 04             	mov    0x4(%eax),%eax
  802e7a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 40 04             	mov    0x4(%eax),%eax
  802e85:	85 c0                	test   %eax,%eax
  802e87:	74 0f                	je     802e98 <alloc_block_BF+0x92>
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	8b 40 04             	mov    0x4(%eax),%eax
  802e8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e92:	8b 12                	mov    (%edx),%edx
  802e94:	89 10                	mov    %edx,(%eax)
  802e96:	eb 0a                	jmp    802ea2 <alloc_block_BF+0x9c>
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	a3 38 51 80 00       	mov    %eax,0x805138
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb5:	a1 44 51 80 00       	mov    0x805144,%eax
  802eba:	48                   	dec    %eax
  802ebb:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	e9 4d 01 00 00       	jmp    803015 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ece:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed1:	76 24                	jbe    802ef7 <alloc_block_BF+0xf1>
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802edc:	73 19                	jae    802ef7 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802ede:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 40 08             	mov    0x8(%eax),%eax
  802ef4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ef7:	a1 40 51 80 00       	mov    0x805140,%eax
  802efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f03:	74 07                	je     802f0c <alloc_block_BF+0x106>
  802f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f08:	8b 00                	mov    (%eax),%eax
  802f0a:	eb 05                	jmp    802f11 <alloc_block_BF+0x10b>
  802f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f11:	a3 40 51 80 00       	mov    %eax,0x805140
  802f16:	a1 40 51 80 00       	mov    0x805140,%eax
  802f1b:	85 c0                	test   %eax,%eax
  802f1d:	0f 85 fd fe ff ff    	jne    802e20 <alloc_block_BF+0x1a>
  802f23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f27:	0f 85 f3 fe ff ff    	jne    802e20 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802f2d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f31:	0f 84 d9 00 00 00    	je     803010 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f37:	a1 48 51 80 00       	mov    0x805148,%eax
  802f3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802f3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f42:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f45:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802f48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4e:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802f51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f55:	75 17                	jne    802f6e <alloc_block_BF+0x168>
  802f57:	83 ec 04             	sub    $0x4,%esp
  802f5a:	68 f0 48 80 00       	push   $0x8048f0
  802f5f:	68 c7 00 00 00       	push   $0xc7
  802f64:	68 47 48 80 00       	push   $0x804847
  802f69:	e8 3c dd ff ff       	call   800caa <_panic>
  802f6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f71:	8b 00                	mov    (%eax),%eax
  802f73:	85 c0                	test   %eax,%eax
  802f75:	74 10                	je     802f87 <alloc_block_BF+0x181>
  802f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7a:	8b 00                	mov    (%eax),%eax
  802f7c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f7f:	8b 52 04             	mov    0x4(%edx),%edx
  802f82:	89 50 04             	mov    %edx,0x4(%eax)
  802f85:	eb 0b                	jmp    802f92 <alloc_block_BF+0x18c>
  802f87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f8a:	8b 40 04             	mov    0x4(%eax),%eax
  802f8d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f95:	8b 40 04             	mov    0x4(%eax),%eax
  802f98:	85 c0                	test   %eax,%eax
  802f9a:	74 0f                	je     802fab <alloc_block_BF+0x1a5>
  802f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9f:	8b 40 04             	mov    0x4(%eax),%eax
  802fa2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fa5:	8b 12                	mov    (%edx),%edx
  802fa7:	89 10                	mov    %edx,(%eax)
  802fa9:	eb 0a                	jmp    802fb5 <alloc_block_BF+0x1af>
  802fab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fae:	8b 00                	mov    (%eax),%eax
  802fb0:	a3 48 51 80 00       	mov    %eax,0x805148
  802fb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc8:	a1 54 51 80 00       	mov    0x805154,%eax
  802fcd:	48                   	dec    %eax
  802fce:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802fd3:	83 ec 08             	sub    $0x8,%esp
  802fd6:	ff 75 ec             	pushl  -0x14(%ebp)
  802fd9:	68 38 51 80 00       	push   $0x805138
  802fde:	e8 71 f9 ff ff       	call   802954 <find_block>
  802fe3:	83 c4 10             	add    $0x10,%esp
  802fe6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802fe9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fec:	8b 50 08             	mov    0x8(%eax),%edx
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	01 c2                	add    %eax,%edx
  802ff4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff7:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802ffa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ffd:	8b 40 0c             	mov    0xc(%eax),%eax
  803000:	2b 45 08             	sub    0x8(%ebp),%eax
  803003:	89 c2                	mov    %eax,%edx
  803005:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803008:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80300b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80300e:	eb 05                	jmp    803015 <alloc_block_BF+0x20f>
	}
	return NULL;
  803010:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803015:	c9                   	leave  
  803016:	c3                   	ret    

00803017 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803017:	55                   	push   %ebp
  803018:	89 e5                	mov    %esp,%ebp
  80301a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80301d:	a1 28 50 80 00       	mov    0x805028,%eax
  803022:	85 c0                	test   %eax,%eax
  803024:	0f 85 de 01 00 00    	jne    803208 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80302a:	a1 38 51 80 00       	mov    0x805138,%eax
  80302f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803032:	e9 9e 01 00 00       	jmp    8031d5 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	8b 40 0c             	mov    0xc(%eax),%eax
  80303d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803040:	0f 82 87 01 00 00    	jb     8031cd <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803049:	8b 40 0c             	mov    0xc(%eax),%eax
  80304c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80304f:	0f 85 95 00 00 00    	jne    8030ea <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803055:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803059:	75 17                	jne    803072 <alloc_block_NF+0x5b>
  80305b:	83 ec 04             	sub    $0x4,%esp
  80305e:	68 f0 48 80 00       	push   $0x8048f0
  803063:	68 e0 00 00 00       	push   $0xe0
  803068:	68 47 48 80 00       	push   $0x804847
  80306d:	e8 38 dc ff ff       	call   800caa <_panic>
  803072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803075:	8b 00                	mov    (%eax),%eax
  803077:	85 c0                	test   %eax,%eax
  803079:	74 10                	je     80308b <alloc_block_NF+0x74>
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	8b 00                	mov    (%eax),%eax
  803080:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803083:	8b 52 04             	mov    0x4(%edx),%edx
  803086:	89 50 04             	mov    %edx,0x4(%eax)
  803089:	eb 0b                	jmp    803096 <alloc_block_NF+0x7f>
  80308b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308e:	8b 40 04             	mov    0x4(%eax),%eax
  803091:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	8b 40 04             	mov    0x4(%eax),%eax
  80309c:	85 c0                	test   %eax,%eax
  80309e:	74 0f                	je     8030af <alloc_block_NF+0x98>
  8030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a3:	8b 40 04             	mov    0x4(%eax),%eax
  8030a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a9:	8b 12                	mov    (%edx),%edx
  8030ab:	89 10                	mov    %edx,(%eax)
  8030ad:	eb 0a                	jmp    8030b9 <alloc_block_NF+0xa2>
  8030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b2:	8b 00                	mov    (%eax),%eax
  8030b4:	a3 38 51 80 00       	mov    %eax,0x805138
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030cc:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d1:	48                   	dec    %eax
  8030d2:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8030d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030da:	8b 40 08             	mov    0x8(%eax),%eax
  8030dd:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8030e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e5:	e9 f8 04 00 00       	jmp    8035e2 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f3:	0f 86 d4 00 00 00    	jbe    8031cd <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030f9:	a1 48 51 80 00       	mov    0x805148,%eax
  8030fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803104:	8b 50 08             	mov    0x8(%eax),%edx
  803107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310a:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80310d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803110:	8b 55 08             	mov    0x8(%ebp),%edx
  803113:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803116:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80311a:	75 17                	jne    803133 <alloc_block_NF+0x11c>
  80311c:	83 ec 04             	sub    $0x4,%esp
  80311f:	68 f0 48 80 00       	push   $0x8048f0
  803124:	68 e9 00 00 00       	push   $0xe9
  803129:	68 47 48 80 00       	push   $0x804847
  80312e:	e8 77 db ff ff       	call   800caa <_panic>
  803133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803136:	8b 00                	mov    (%eax),%eax
  803138:	85 c0                	test   %eax,%eax
  80313a:	74 10                	je     80314c <alloc_block_NF+0x135>
  80313c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803144:	8b 52 04             	mov    0x4(%edx),%edx
  803147:	89 50 04             	mov    %edx,0x4(%eax)
  80314a:	eb 0b                	jmp    803157 <alloc_block_NF+0x140>
  80314c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314f:	8b 40 04             	mov    0x4(%eax),%eax
  803152:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315a:	8b 40 04             	mov    0x4(%eax),%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	74 0f                	je     803170 <alloc_block_NF+0x159>
  803161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803164:	8b 40 04             	mov    0x4(%eax),%eax
  803167:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80316a:	8b 12                	mov    (%edx),%edx
  80316c:	89 10                	mov    %edx,(%eax)
  80316e:	eb 0a                	jmp    80317a <alloc_block_NF+0x163>
  803170:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803173:	8b 00                	mov    (%eax),%eax
  803175:	a3 48 51 80 00       	mov    %eax,0x805148
  80317a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803186:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318d:	a1 54 51 80 00       	mov    0x805154,%eax
  803192:	48                   	dec    %eax
  803193:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319b:	8b 40 08             	mov    0x8(%eax),%eax
  80319e:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	8b 50 08             	mov    0x8(%eax),%edx
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	01 c2                	add    %eax,%edx
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8031b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ba:	2b 45 08             	sub    0x8(%ebp),%eax
  8031bd:	89 c2                	mov    %eax,%edx
  8031bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c2:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8031c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c8:	e9 15 04 00 00       	jmp    8035e2 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8031cd:	a1 40 51 80 00       	mov    0x805140,%eax
  8031d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d9:	74 07                	je     8031e2 <alloc_block_NF+0x1cb>
  8031db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031de:	8b 00                	mov    (%eax),%eax
  8031e0:	eb 05                	jmp    8031e7 <alloc_block_NF+0x1d0>
  8031e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e7:	a3 40 51 80 00       	mov    %eax,0x805140
  8031ec:	a1 40 51 80 00       	mov    0x805140,%eax
  8031f1:	85 c0                	test   %eax,%eax
  8031f3:	0f 85 3e fe ff ff    	jne    803037 <alloc_block_NF+0x20>
  8031f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031fd:	0f 85 34 fe ff ff    	jne    803037 <alloc_block_NF+0x20>
  803203:	e9 d5 03 00 00       	jmp    8035dd <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803208:	a1 38 51 80 00       	mov    0x805138,%eax
  80320d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803210:	e9 b1 01 00 00       	jmp    8033c6 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803218:	8b 50 08             	mov    0x8(%eax),%edx
  80321b:	a1 28 50 80 00       	mov    0x805028,%eax
  803220:	39 c2                	cmp    %eax,%edx
  803222:	0f 82 96 01 00 00    	jb     8033be <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322b:	8b 40 0c             	mov    0xc(%eax),%eax
  80322e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803231:	0f 82 87 01 00 00    	jb     8033be <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323a:	8b 40 0c             	mov    0xc(%eax),%eax
  80323d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803240:	0f 85 95 00 00 00    	jne    8032db <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803246:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324a:	75 17                	jne    803263 <alloc_block_NF+0x24c>
  80324c:	83 ec 04             	sub    $0x4,%esp
  80324f:	68 f0 48 80 00       	push   $0x8048f0
  803254:	68 fc 00 00 00       	push   $0xfc
  803259:	68 47 48 80 00       	push   $0x804847
  80325e:	e8 47 da ff ff       	call   800caa <_panic>
  803263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803266:	8b 00                	mov    (%eax),%eax
  803268:	85 c0                	test   %eax,%eax
  80326a:	74 10                	je     80327c <alloc_block_NF+0x265>
  80326c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326f:	8b 00                	mov    (%eax),%eax
  803271:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803274:	8b 52 04             	mov    0x4(%edx),%edx
  803277:	89 50 04             	mov    %edx,0x4(%eax)
  80327a:	eb 0b                	jmp    803287 <alloc_block_NF+0x270>
  80327c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327f:	8b 40 04             	mov    0x4(%eax),%eax
  803282:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328a:	8b 40 04             	mov    0x4(%eax),%eax
  80328d:	85 c0                	test   %eax,%eax
  80328f:	74 0f                	je     8032a0 <alloc_block_NF+0x289>
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	8b 40 04             	mov    0x4(%eax),%eax
  803297:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80329a:	8b 12                	mov    (%edx),%edx
  80329c:	89 10                	mov    %edx,(%eax)
  80329e:	eb 0a                	jmp    8032aa <alloc_block_NF+0x293>
  8032a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a3:	8b 00                	mov    (%eax),%eax
  8032a5:	a3 38 51 80 00       	mov    %eax,0x805138
  8032aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032bd:	a1 44 51 80 00       	mov    0x805144,%eax
  8032c2:	48                   	dec    %eax
  8032c3:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cb:	8b 40 08             	mov    0x8(%eax),%eax
  8032ce:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8032d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d6:	e9 07 03 00 00       	jmp    8035e2 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032de:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032e4:	0f 86 d4 00 00 00    	jbe    8033be <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032ea:	a1 48 51 80 00       	mov    0x805148,%eax
  8032ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f5:	8b 50 08             	mov    0x8(%eax),%edx
  8032f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803301:	8b 55 08             	mov    0x8(%ebp),%edx
  803304:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803307:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80330b:	75 17                	jne    803324 <alloc_block_NF+0x30d>
  80330d:	83 ec 04             	sub    $0x4,%esp
  803310:	68 f0 48 80 00       	push   $0x8048f0
  803315:	68 04 01 00 00       	push   $0x104
  80331a:	68 47 48 80 00       	push   $0x804847
  80331f:	e8 86 d9 ff ff       	call   800caa <_panic>
  803324:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803327:	8b 00                	mov    (%eax),%eax
  803329:	85 c0                	test   %eax,%eax
  80332b:	74 10                	je     80333d <alloc_block_NF+0x326>
  80332d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803330:	8b 00                	mov    (%eax),%eax
  803332:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803335:	8b 52 04             	mov    0x4(%edx),%edx
  803338:	89 50 04             	mov    %edx,0x4(%eax)
  80333b:	eb 0b                	jmp    803348 <alloc_block_NF+0x331>
  80333d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803340:	8b 40 04             	mov    0x4(%eax),%eax
  803343:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803348:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334b:	8b 40 04             	mov    0x4(%eax),%eax
  80334e:	85 c0                	test   %eax,%eax
  803350:	74 0f                	je     803361 <alloc_block_NF+0x34a>
  803352:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803355:	8b 40 04             	mov    0x4(%eax),%eax
  803358:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80335b:	8b 12                	mov    (%edx),%edx
  80335d:	89 10                	mov    %edx,(%eax)
  80335f:	eb 0a                	jmp    80336b <alloc_block_NF+0x354>
  803361:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803364:	8b 00                	mov    (%eax),%eax
  803366:	a3 48 51 80 00       	mov    %eax,0x805148
  80336b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803374:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803377:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80337e:	a1 54 51 80 00       	mov    0x805154,%eax
  803383:	48                   	dec    %eax
  803384:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338c:	8b 40 08             	mov    0x8(%eax),%eax
  80338f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803397:	8b 50 08             	mov    0x8(%eax),%edx
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	01 c2                	add    %eax,%edx
  80339f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a2:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8033a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ab:	2b 45 08             	sub    0x8(%ebp),%eax
  8033ae:	89 c2                	mov    %eax,%edx
  8033b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b3:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b9:	e9 24 02 00 00       	jmp    8035e2 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033be:	a1 40 51 80 00       	mov    0x805140,%eax
  8033c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ca:	74 07                	je     8033d3 <alloc_block_NF+0x3bc>
  8033cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cf:	8b 00                	mov    (%eax),%eax
  8033d1:	eb 05                	jmp    8033d8 <alloc_block_NF+0x3c1>
  8033d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d8:	a3 40 51 80 00       	mov    %eax,0x805140
  8033dd:	a1 40 51 80 00       	mov    0x805140,%eax
  8033e2:	85 c0                	test   %eax,%eax
  8033e4:	0f 85 2b fe ff ff    	jne    803215 <alloc_block_NF+0x1fe>
  8033ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ee:	0f 85 21 fe ff ff    	jne    803215 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033f4:	a1 38 51 80 00       	mov    0x805138,%eax
  8033f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033fc:	e9 ae 01 00 00       	jmp    8035af <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803404:	8b 50 08             	mov    0x8(%eax),%edx
  803407:	a1 28 50 80 00       	mov    0x805028,%eax
  80340c:	39 c2                	cmp    %eax,%edx
  80340e:	0f 83 93 01 00 00    	jae    8035a7 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803417:	8b 40 0c             	mov    0xc(%eax),%eax
  80341a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80341d:	0f 82 84 01 00 00    	jb     8035a7 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803426:	8b 40 0c             	mov    0xc(%eax),%eax
  803429:	3b 45 08             	cmp    0x8(%ebp),%eax
  80342c:	0f 85 95 00 00 00    	jne    8034c7 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803432:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803436:	75 17                	jne    80344f <alloc_block_NF+0x438>
  803438:	83 ec 04             	sub    $0x4,%esp
  80343b:	68 f0 48 80 00       	push   $0x8048f0
  803440:	68 14 01 00 00       	push   $0x114
  803445:	68 47 48 80 00       	push   $0x804847
  80344a:	e8 5b d8 ff ff       	call   800caa <_panic>
  80344f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803452:	8b 00                	mov    (%eax),%eax
  803454:	85 c0                	test   %eax,%eax
  803456:	74 10                	je     803468 <alloc_block_NF+0x451>
  803458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345b:	8b 00                	mov    (%eax),%eax
  80345d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803460:	8b 52 04             	mov    0x4(%edx),%edx
  803463:	89 50 04             	mov    %edx,0x4(%eax)
  803466:	eb 0b                	jmp    803473 <alloc_block_NF+0x45c>
  803468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346b:	8b 40 04             	mov    0x4(%eax),%eax
  80346e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803476:	8b 40 04             	mov    0x4(%eax),%eax
  803479:	85 c0                	test   %eax,%eax
  80347b:	74 0f                	je     80348c <alloc_block_NF+0x475>
  80347d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803480:	8b 40 04             	mov    0x4(%eax),%eax
  803483:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803486:	8b 12                	mov    (%edx),%edx
  803488:	89 10                	mov    %edx,(%eax)
  80348a:	eb 0a                	jmp    803496 <alloc_block_NF+0x47f>
  80348c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348f:	8b 00                	mov    (%eax),%eax
  803491:	a3 38 51 80 00       	mov    %eax,0x805138
  803496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80349f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8034ae:	48                   	dec    %eax
  8034af:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8034b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b7:	8b 40 08             	mov    0x8(%eax),%eax
  8034ba:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8034bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c2:	e9 1b 01 00 00       	jmp    8035e2 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8034c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8034cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034d0:	0f 86 d1 00 00 00    	jbe    8035a7 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8034d6:	a1 48 51 80 00       	mov    0x805148,%eax
  8034db:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8034de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e1:	8b 50 08             	mov    0x8(%eax),%edx
  8034e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8034ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8034f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034f7:	75 17                	jne    803510 <alloc_block_NF+0x4f9>
  8034f9:	83 ec 04             	sub    $0x4,%esp
  8034fc:	68 f0 48 80 00       	push   $0x8048f0
  803501:	68 1c 01 00 00       	push   $0x11c
  803506:	68 47 48 80 00       	push   $0x804847
  80350b:	e8 9a d7 ff ff       	call   800caa <_panic>
  803510:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803513:	8b 00                	mov    (%eax),%eax
  803515:	85 c0                	test   %eax,%eax
  803517:	74 10                	je     803529 <alloc_block_NF+0x512>
  803519:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351c:	8b 00                	mov    (%eax),%eax
  80351e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803521:	8b 52 04             	mov    0x4(%edx),%edx
  803524:	89 50 04             	mov    %edx,0x4(%eax)
  803527:	eb 0b                	jmp    803534 <alloc_block_NF+0x51d>
  803529:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352c:	8b 40 04             	mov    0x4(%eax),%eax
  80352f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803537:	8b 40 04             	mov    0x4(%eax),%eax
  80353a:	85 c0                	test   %eax,%eax
  80353c:	74 0f                	je     80354d <alloc_block_NF+0x536>
  80353e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803541:	8b 40 04             	mov    0x4(%eax),%eax
  803544:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803547:	8b 12                	mov    (%edx),%edx
  803549:	89 10                	mov    %edx,(%eax)
  80354b:	eb 0a                	jmp    803557 <alloc_block_NF+0x540>
  80354d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803550:	8b 00                	mov    (%eax),%eax
  803552:	a3 48 51 80 00       	mov    %eax,0x805148
  803557:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803560:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803563:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80356a:	a1 54 51 80 00       	mov    0x805154,%eax
  80356f:	48                   	dec    %eax
  803570:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803575:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803578:	8b 40 08             	mov    0x8(%eax),%eax
  80357b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803583:	8b 50 08             	mov    0x8(%eax),%edx
  803586:	8b 45 08             	mov    0x8(%ebp),%eax
  803589:	01 c2                	add    %eax,%edx
  80358b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803594:	8b 40 0c             	mov    0xc(%eax),%eax
  803597:	2b 45 08             	sub    0x8(%ebp),%eax
  80359a:	89 c2                	mov    %eax,%edx
  80359c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8035a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a5:	eb 3b                	jmp    8035e2 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8035a7:	a1 40 51 80 00       	mov    0x805140,%eax
  8035ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b3:	74 07                	je     8035bc <alloc_block_NF+0x5a5>
  8035b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b8:	8b 00                	mov    (%eax),%eax
  8035ba:	eb 05                	jmp    8035c1 <alloc_block_NF+0x5aa>
  8035bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c1:	a3 40 51 80 00       	mov    %eax,0x805140
  8035c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8035cb:	85 c0                	test   %eax,%eax
  8035cd:	0f 85 2e fe ff ff    	jne    803401 <alloc_block_NF+0x3ea>
  8035d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035d7:	0f 85 24 fe ff ff    	jne    803401 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8035dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035e2:	c9                   	leave  
  8035e3:	c3                   	ret    

008035e4 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8035e4:	55                   	push   %ebp
  8035e5:	89 e5                	mov    %esp,%ebp
  8035e7:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8035ea:	a1 38 51 80 00       	mov    0x805138,%eax
  8035ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8035f2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8035f7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8035fa:	a1 38 51 80 00       	mov    0x805138,%eax
  8035ff:	85 c0                	test   %eax,%eax
  803601:	74 14                	je     803617 <insert_sorted_with_merge_freeList+0x33>
  803603:	8b 45 08             	mov    0x8(%ebp),%eax
  803606:	8b 50 08             	mov    0x8(%eax),%edx
  803609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360c:	8b 40 08             	mov    0x8(%eax),%eax
  80360f:	39 c2                	cmp    %eax,%edx
  803611:	0f 87 9b 01 00 00    	ja     8037b2 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803617:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80361b:	75 17                	jne    803634 <insert_sorted_with_merge_freeList+0x50>
  80361d:	83 ec 04             	sub    $0x4,%esp
  803620:	68 24 48 80 00       	push   $0x804824
  803625:	68 38 01 00 00       	push   $0x138
  80362a:	68 47 48 80 00       	push   $0x804847
  80362f:	e8 76 d6 ff ff       	call   800caa <_panic>
  803634:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80363a:	8b 45 08             	mov    0x8(%ebp),%eax
  80363d:	89 10                	mov    %edx,(%eax)
  80363f:	8b 45 08             	mov    0x8(%ebp),%eax
  803642:	8b 00                	mov    (%eax),%eax
  803644:	85 c0                	test   %eax,%eax
  803646:	74 0d                	je     803655 <insert_sorted_with_merge_freeList+0x71>
  803648:	a1 38 51 80 00       	mov    0x805138,%eax
  80364d:	8b 55 08             	mov    0x8(%ebp),%edx
  803650:	89 50 04             	mov    %edx,0x4(%eax)
  803653:	eb 08                	jmp    80365d <insert_sorted_with_merge_freeList+0x79>
  803655:	8b 45 08             	mov    0x8(%ebp),%eax
  803658:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80365d:	8b 45 08             	mov    0x8(%ebp),%eax
  803660:	a3 38 51 80 00       	mov    %eax,0x805138
  803665:	8b 45 08             	mov    0x8(%ebp),%eax
  803668:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80366f:	a1 44 51 80 00       	mov    0x805144,%eax
  803674:	40                   	inc    %eax
  803675:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80367a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80367e:	0f 84 a8 06 00 00    	je     803d2c <insert_sorted_with_merge_freeList+0x748>
  803684:	8b 45 08             	mov    0x8(%ebp),%eax
  803687:	8b 50 08             	mov    0x8(%eax),%edx
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	8b 40 0c             	mov    0xc(%eax),%eax
  803690:	01 c2                	add    %eax,%edx
  803692:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803695:	8b 40 08             	mov    0x8(%eax),%eax
  803698:	39 c2                	cmp    %eax,%edx
  80369a:	0f 85 8c 06 00 00    	jne    803d2c <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a3:	8b 50 0c             	mov    0xc(%eax),%edx
  8036a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ac:	01 c2                	add    %eax,%edx
  8036ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b1:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8036b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036b8:	75 17                	jne    8036d1 <insert_sorted_with_merge_freeList+0xed>
  8036ba:	83 ec 04             	sub    $0x4,%esp
  8036bd:	68 f0 48 80 00       	push   $0x8048f0
  8036c2:	68 3c 01 00 00       	push   $0x13c
  8036c7:	68 47 48 80 00       	push   $0x804847
  8036cc:	e8 d9 d5 ff ff       	call   800caa <_panic>
  8036d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d4:	8b 00                	mov    (%eax),%eax
  8036d6:	85 c0                	test   %eax,%eax
  8036d8:	74 10                	je     8036ea <insert_sorted_with_merge_freeList+0x106>
  8036da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036dd:	8b 00                	mov    (%eax),%eax
  8036df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036e2:	8b 52 04             	mov    0x4(%edx),%edx
  8036e5:	89 50 04             	mov    %edx,0x4(%eax)
  8036e8:	eb 0b                	jmp    8036f5 <insert_sorted_with_merge_freeList+0x111>
  8036ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ed:	8b 40 04             	mov    0x4(%eax),%eax
  8036f0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f8:	8b 40 04             	mov    0x4(%eax),%eax
  8036fb:	85 c0                	test   %eax,%eax
  8036fd:	74 0f                	je     80370e <insert_sorted_with_merge_freeList+0x12a>
  8036ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803702:	8b 40 04             	mov    0x4(%eax),%eax
  803705:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803708:	8b 12                	mov    (%edx),%edx
  80370a:	89 10                	mov    %edx,(%eax)
  80370c:	eb 0a                	jmp    803718 <insert_sorted_with_merge_freeList+0x134>
  80370e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803711:	8b 00                	mov    (%eax),%eax
  803713:	a3 38 51 80 00       	mov    %eax,0x805138
  803718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80371b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803724:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80372b:	a1 44 51 80 00       	mov    0x805144,%eax
  803730:	48                   	dec    %eax
  803731:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803739:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803740:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803743:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80374a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80374e:	75 17                	jne    803767 <insert_sorted_with_merge_freeList+0x183>
  803750:	83 ec 04             	sub    $0x4,%esp
  803753:	68 24 48 80 00       	push   $0x804824
  803758:	68 3f 01 00 00       	push   $0x13f
  80375d:	68 47 48 80 00       	push   $0x804847
  803762:	e8 43 d5 ff ff       	call   800caa <_panic>
  803767:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80376d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803770:	89 10                	mov    %edx,(%eax)
  803772:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803775:	8b 00                	mov    (%eax),%eax
  803777:	85 c0                	test   %eax,%eax
  803779:	74 0d                	je     803788 <insert_sorted_with_merge_freeList+0x1a4>
  80377b:	a1 48 51 80 00       	mov    0x805148,%eax
  803780:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803783:	89 50 04             	mov    %edx,0x4(%eax)
  803786:	eb 08                	jmp    803790 <insert_sorted_with_merge_freeList+0x1ac>
  803788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803793:	a3 48 51 80 00       	mov    %eax,0x805148
  803798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a2:	a1 54 51 80 00       	mov    0x805154,%eax
  8037a7:	40                   	inc    %eax
  8037a8:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037ad:	e9 7a 05 00 00       	jmp    803d2c <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8037b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b5:	8b 50 08             	mov    0x8(%eax),%edx
  8037b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037bb:	8b 40 08             	mov    0x8(%eax),%eax
  8037be:	39 c2                	cmp    %eax,%edx
  8037c0:	0f 82 14 01 00 00    	jb     8038da <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8037c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c9:	8b 50 08             	mov    0x8(%eax),%edx
  8037cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8037d2:	01 c2                	add    %eax,%edx
  8037d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d7:	8b 40 08             	mov    0x8(%eax),%eax
  8037da:	39 c2                	cmp    %eax,%edx
  8037dc:	0f 85 90 00 00 00    	jne    803872 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8037e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037e5:	8b 50 0c             	mov    0xc(%eax),%edx
  8037e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ee:	01 c2                	add    %eax,%edx
  8037f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f3:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8037f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803800:	8b 45 08             	mov    0x8(%ebp),%eax
  803803:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80380a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80380e:	75 17                	jne    803827 <insert_sorted_with_merge_freeList+0x243>
  803810:	83 ec 04             	sub    $0x4,%esp
  803813:	68 24 48 80 00       	push   $0x804824
  803818:	68 49 01 00 00       	push   $0x149
  80381d:	68 47 48 80 00       	push   $0x804847
  803822:	e8 83 d4 ff ff       	call   800caa <_panic>
  803827:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80382d:	8b 45 08             	mov    0x8(%ebp),%eax
  803830:	89 10                	mov    %edx,(%eax)
  803832:	8b 45 08             	mov    0x8(%ebp),%eax
  803835:	8b 00                	mov    (%eax),%eax
  803837:	85 c0                	test   %eax,%eax
  803839:	74 0d                	je     803848 <insert_sorted_with_merge_freeList+0x264>
  80383b:	a1 48 51 80 00       	mov    0x805148,%eax
  803840:	8b 55 08             	mov    0x8(%ebp),%edx
  803843:	89 50 04             	mov    %edx,0x4(%eax)
  803846:	eb 08                	jmp    803850 <insert_sorted_with_merge_freeList+0x26c>
  803848:	8b 45 08             	mov    0x8(%ebp),%eax
  80384b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803850:	8b 45 08             	mov    0x8(%ebp),%eax
  803853:	a3 48 51 80 00       	mov    %eax,0x805148
  803858:	8b 45 08             	mov    0x8(%ebp),%eax
  80385b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803862:	a1 54 51 80 00       	mov    0x805154,%eax
  803867:	40                   	inc    %eax
  803868:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80386d:	e9 bb 04 00 00       	jmp    803d2d <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803872:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803876:	75 17                	jne    80388f <insert_sorted_with_merge_freeList+0x2ab>
  803878:	83 ec 04             	sub    $0x4,%esp
  80387b:	68 98 48 80 00       	push   $0x804898
  803880:	68 4c 01 00 00       	push   $0x14c
  803885:	68 47 48 80 00       	push   $0x804847
  80388a:	e8 1b d4 ff ff       	call   800caa <_panic>
  80388f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803895:	8b 45 08             	mov    0x8(%ebp),%eax
  803898:	89 50 04             	mov    %edx,0x4(%eax)
  80389b:	8b 45 08             	mov    0x8(%ebp),%eax
  80389e:	8b 40 04             	mov    0x4(%eax),%eax
  8038a1:	85 c0                	test   %eax,%eax
  8038a3:	74 0c                	je     8038b1 <insert_sorted_with_merge_freeList+0x2cd>
  8038a5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8038aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8038ad:	89 10                	mov    %edx,(%eax)
  8038af:	eb 08                	jmp    8038b9 <insert_sorted_with_merge_freeList+0x2d5>
  8038b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b4:	a3 38 51 80 00       	mov    %eax,0x805138
  8038b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ca:	a1 44 51 80 00       	mov    0x805144,%eax
  8038cf:	40                   	inc    %eax
  8038d0:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038d5:	e9 53 04 00 00       	jmp    803d2d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038da:	a1 38 51 80 00       	mov    0x805138,%eax
  8038df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038e2:	e9 15 04 00 00       	jmp    803cfc <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8038e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ea:	8b 00                	mov    (%eax),%eax
  8038ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8038ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f2:	8b 50 08             	mov    0x8(%eax),%edx
  8038f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f8:	8b 40 08             	mov    0x8(%eax),%eax
  8038fb:	39 c2                	cmp    %eax,%edx
  8038fd:	0f 86 f1 03 00 00    	jbe    803cf4 <insert_sorted_with_merge_freeList+0x710>
  803903:	8b 45 08             	mov    0x8(%ebp),%eax
  803906:	8b 50 08             	mov    0x8(%eax),%edx
  803909:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390c:	8b 40 08             	mov    0x8(%eax),%eax
  80390f:	39 c2                	cmp    %eax,%edx
  803911:	0f 83 dd 03 00 00    	jae    803cf4 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391a:	8b 50 08             	mov    0x8(%eax),%edx
  80391d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803920:	8b 40 0c             	mov    0xc(%eax),%eax
  803923:	01 c2                	add    %eax,%edx
  803925:	8b 45 08             	mov    0x8(%ebp),%eax
  803928:	8b 40 08             	mov    0x8(%eax),%eax
  80392b:	39 c2                	cmp    %eax,%edx
  80392d:	0f 85 b9 01 00 00    	jne    803aec <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803933:	8b 45 08             	mov    0x8(%ebp),%eax
  803936:	8b 50 08             	mov    0x8(%eax),%edx
  803939:	8b 45 08             	mov    0x8(%ebp),%eax
  80393c:	8b 40 0c             	mov    0xc(%eax),%eax
  80393f:	01 c2                	add    %eax,%edx
  803941:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803944:	8b 40 08             	mov    0x8(%eax),%eax
  803947:	39 c2                	cmp    %eax,%edx
  803949:	0f 85 0d 01 00 00    	jne    803a5c <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80394f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803952:	8b 50 0c             	mov    0xc(%eax),%edx
  803955:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803958:	8b 40 0c             	mov    0xc(%eax),%eax
  80395b:	01 c2                	add    %eax,%edx
  80395d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803960:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803963:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803967:	75 17                	jne    803980 <insert_sorted_with_merge_freeList+0x39c>
  803969:	83 ec 04             	sub    $0x4,%esp
  80396c:	68 f0 48 80 00       	push   $0x8048f0
  803971:	68 5c 01 00 00       	push   $0x15c
  803976:	68 47 48 80 00       	push   $0x804847
  80397b:	e8 2a d3 ff ff       	call   800caa <_panic>
  803980:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803983:	8b 00                	mov    (%eax),%eax
  803985:	85 c0                	test   %eax,%eax
  803987:	74 10                	je     803999 <insert_sorted_with_merge_freeList+0x3b5>
  803989:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398c:	8b 00                	mov    (%eax),%eax
  80398e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803991:	8b 52 04             	mov    0x4(%edx),%edx
  803994:	89 50 04             	mov    %edx,0x4(%eax)
  803997:	eb 0b                	jmp    8039a4 <insert_sorted_with_merge_freeList+0x3c0>
  803999:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399c:	8b 40 04             	mov    0x4(%eax),%eax
  80399f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a7:	8b 40 04             	mov    0x4(%eax),%eax
  8039aa:	85 c0                	test   %eax,%eax
  8039ac:	74 0f                	je     8039bd <insert_sorted_with_merge_freeList+0x3d9>
  8039ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b1:	8b 40 04             	mov    0x4(%eax),%eax
  8039b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039b7:	8b 12                	mov    (%edx),%edx
  8039b9:	89 10                	mov    %edx,(%eax)
  8039bb:	eb 0a                	jmp    8039c7 <insert_sorted_with_merge_freeList+0x3e3>
  8039bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c0:	8b 00                	mov    (%eax),%eax
  8039c2:	a3 38 51 80 00       	mov    %eax,0x805138
  8039c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039da:	a1 44 51 80 00       	mov    0x805144,%eax
  8039df:	48                   	dec    %eax
  8039e0:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8039e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8039ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8039f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039fd:	75 17                	jne    803a16 <insert_sorted_with_merge_freeList+0x432>
  8039ff:	83 ec 04             	sub    $0x4,%esp
  803a02:	68 24 48 80 00       	push   $0x804824
  803a07:	68 5f 01 00 00       	push   $0x15f
  803a0c:	68 47 48 80 00       	push   $0x804847
  803a11:	e8 94 d2 ff ff       	call   800caa <_panic>
  803a16:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a1f:	89 10                	mov    %edx,(%eax)
  803a21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a24:	8b 00                	mov    (%eax),%eax
  803a26:	85 c0                	test   %eax,%eax
  803a28:	74 0d                	je     803a37 <insert_sorted_with_merge_freeList+0x453>
  803a2a:	a1 48 51 80 00       	mov    0x805148,%eax
  803a2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a32:	89 50 04             	mov    %edx,0x4(%eax)
  803a35:	eb 08                	jmp    803a3f <insert_sorted_with_merge_freeList+0x45b>
  803a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a42:	a3 48 51 80 00       	mov    %eax,0x805148
  803a47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a51:	a1 54 51 80 00       	mov    0x805154,%eax
  803a56:	40                   	inc    %eax
  803a57:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5f:	8b 50 0c             	mov    0xc(%eax),%edx
  803a62:	8b 45 08             	mov    0x8(%ebp),%eax
  803a65:	8b 40 0c             	mov    0xc(%eax),%eax
  803a68:	01 c2                	add    %eax,%edx
  803a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a6d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803a70:	8b 45 08             	mov    0x8(%ebp),%eax
  803a73:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a88:	75 17                	jne    803aa1 <insert_sorted_with_merge_freeList+0x4bd>
  803a8a:	83 ec 04             	sub    $0x4,%esp
  803a8d:	68 24 48 80 00       	push   $0x804824
  803a92:	68 64 01 00 00       	push   $0x164
  803a97:	68 47 48 80 00       	push   $0x804847
  803a9c:	e8 09 d2 ff ff       	call   800caa <_panic>
  803aa1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aaa:	89 10                	mov    %edx,(%eax)
  803aac:	8b 45 08             	mov    0x8(%ebp),%eax
  803aaf:	8b 00                	mov    (%eax),%eax
  803ab1:	85 c0                	test   %eax,%eax
  803ab3:	74 0d                	je     803ac2 <insert_sorted_with_merge_freeList+0x4de>
  803ab5:	a1 48 51 80 00       	mov    0x805148,%eax
  803aba:	8b 55 08             	mov    0x8(%ebp),%edx
  803abd:	89 50 04             	mov    %edx,0x4(%eax)
  803ac0:	eb 08                	jmp    803aca <insert_sorted_with_merge_freeList+0x4e6>
  803ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803aca:	8b 45 08             	mov    0x8(%ebp),%eax
  803acd:	a3 48 51 80 00       	mov    %eax,0x805148
  803ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803adc:	a1 54 51 80 00       	mov    0x805154,%eax
  803ae1:	40                   	inc    %eax
  803ae2:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ae7:	e9 41 02 00 00       	jmp    803d2d <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803aec:	8b 45 08             	mov    0x8(%ebp),%eax
  803aef:	8b 50 08             	mov    0x8(%eax),%edx
  803af2:	8b 45 08             	mov    0x8(%ebp),%eax
  803af5:	8b 40 0c             	mov    0xc(%eax),%eax
  803af8:	01 c2                	add    %eax,%edx
  803afa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803afd:	8b 40 08             	mov    0x8(%eax),%eax
  803b00:	39 c2                	cmp    %eax,%edx
  803b02:	0f 85 7c 01 00 00    	jne    803c84 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803b08:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b0c:	74 06                	je     803b14 <insert_sorted_with_merge_freeList+0x530>
  803b0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b12:	75 17                	jne    803b2b <insert_sorted_with_merge_freeList+0x547>
  803b14:	83 ec 04             	sub    $0x4,%esp
  803b17:	68 60 48 80 00       	push   $0x804860
  803b1c:	68 69 01 00 00       	push   $0x169
  803b21:	68 47 48 80 00       	push   $0x804847
  803b26:	e8 7f d1 ff ff       	call   800caa <_panic>
  803b2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b2e:	8b 50 04             	mov    0x4(%eax),%edx
  803b31:	8b 45 08             	mov    0x8(%ebp),%eax
  803b34:	89 50 04             	mov    %edx,0x4(%eax)
  803b37:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b3d:	89 10                	mov    %edx,(%eax)
  803b3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b42:	8b 40 04             	mov    0x4(%eax),%eax
  803b45:	85 c0                	test   %eax,%eax
  803b47:	74 0d                	je     803b56 <insert_sorted_with_merge_freeList+0x572>
  803b49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b4c:	8b 40 04             	mov    0x4(%eax),%eax
  803b4f:	8b 55 08             	mov    0x8(%ebp),%edx
  803b52:	89 10                	mov    %edx,(%eax)
  803b54:	eb 08                	jmp    803b5e <insert_sorted_with_merge_freeList+0x57a>
  803b56:	8b 45 08             	mov    0x8(%ebp),%eax
  803b59:	a3 38 51 80 00       	mov    %eax,0x805138
  803b5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b61:	8b 55 08             	mov    0x8(%ebp),%edx
  803b64:	89 50 04             	mov    %edx,0x4(%eax)
  803b67:	a1 44 51 80 00       	mov    0x805144,%eax
  803b6c:	40                   	inc    %eax
  803b6d:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803b72:	8b 45 08             	mov    0x8(%ebp),%eax
  803b75:	8b 50 0c             	mov    0xc(%eax),%edx
  803b78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b7b:	8b 40 0c             	mov    0xc(%eax),%eax
  803b7e:	01 c2                	add    %eax,%edx
  803b80:	8b 45 08             	mov    0x8(%ebp),%eax
  803b83:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803b86:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b8a:	75 17                	jne    803ba3 <insert_sorted_with_merge_freeList+0x5bf>
  803b8c:	83 ec 04             	sub    $0x4,%esp
  803b8f:	68 f0 48 80 00       	push   $0x8048f0
  803b94:	68 6b 01 00 00       	push   $0x16b
  803b99:	68 47 48 80 00       	push   $0x804847
  803b9e:	e8 07 d1 ff ff       	call   800caa <_panic>
  803ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba6:	8b 00                	mov    (%eax),%eax
  803ba8:	85 c0                	test   %eax,%eax
  803baa:	74 10                	je     803bbc <insert_sorted_with_merge_freeList+0x5d8>
  803bac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803baf:	8b 00                	mov    (%eax),%eax
  803bb1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bb4:	8b 52 04             	mov    0x4(%edx),%edx
  803bb7:	89 50 04             	mov    %edx,0x4(%eax)
  803bba:	eb 0b                	jmp    803bc7 <insert_sorted_with_merge_freeList+0x5e3>
  803bbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bbf:	8b 40 04             	mov    0x4(%eax),%eax
  803bc2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bca:	8b 40 04             	mov    0x4(%eax),%eax
  803bcd:	85 c0                	test   %eax,%eax
  803bcf:	74 0f                	je     803be0 <insert_sorted_with_merge_freeList+0x5fc>
  803bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd4:	8b 40 04             	mov    0x4(%eax),%eax
  803bd7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bda:	8b 12                	mov    (%edx),%edx
  803bdc:	89 10                	mov    %edx,(%eax)
  803bde:	eb 0a                	jmp    803bea <insert_sorted_with_merge_freeList+0x606>
  803be0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be3:	8b 00                	mov    (%eax),%eax
  803be5:	a3 38 51 80 00       	mov    %eax,0x805138
  803bea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bf6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bfd:	a1 44 51 80 00       	mov    0x805144,%eax
  803c02:	48                   	dec    %eax
  803c03:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803c08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c0b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803c12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c15:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803c1c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c20:	75 17                	jne    803c39 <insert_sorted_with_merge_freeList+0x655>
  803c22:	83 ec 04             	sub    $0x4,%esp
  803c25:	68 24 48 80 00       	push   $0x804824
  803c2a:	68 6e 01 00 00       	push   $0x16e
  803c2f:	68 47 48 80 00       	push   $0x804847
  803c34:	e8 71 d0 ff ff       	call   800caa <_panic>
  803c39:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c42:	89 10                	mov    %edx,(%eax)
  803c44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c47:	8b 00                	mov    (%eax),%eax
  803c49:	85 c0                	test   %eax,%eax
  803c4b:	74 0d                	je     803c5a <insert_sorted_with_merge_freeList+0x676>
  803c4d:	a1 48 51 80 00       	mov    0x805148,%eax
  803c52:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c55:	89 50 04             	mov    %edx,0x4(%eax)
  803c58:	eb 08                	jmp    803c62 <insert_sorted_with_merge_freeList+0x67e>
  803c5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c5d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c65:	a3 48 51 80 00       	mov    %eax,0x805148
  803c6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c74:	a1 54 51 80 00       	mov    0x805154,%eax
  803c79:	40                   	inc    %eax
  803c7a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c7f:	e9 a9 00 00 00       	jmp    803d2d <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803c84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c88:	74 06                	je     803c90 <insert_sorted_with_merge_freeList+0x6ac>
  803c8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c8e:	75 17                	jne    803ca7 <insert_sorted_with_merge_freeList+0x6c3>
  803c90:	83 ec 04             	sub    $0x4,%esp
  803c93:	68 bc 48 80 00       	push   $0x8048bc
  803c98:	68 73 01 00 00       	push   $0x173
  803c9d:	68 47 48 80 00       	push   $0x804847
  803ca2:	e8 03 d0 ff ff       	call   800caa <_panic>
  803ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803caa:	8b 10                	mov    (%eax),%edx
  803cac:	8b 45 08             	mov    0x8(%ebp),%eax
  803caf:	89 10                	mov    %edx,(%eax)
  803cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb4:	8b 00                	mov    (%eax),%eax
  803cb6:	85 c0                	test   %eax,%eax
  803cb8:	74 0b                	je     803cc5 <insert_sorted_with_merge_freeList+0x6e1>
  803cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbd:	8b 00                	mov    (%eax),%eax
  803cbf:	8b 55 08             	mov    0x8(%ebp),%edx
  803cc2:	89 50 04             	mov    %edx,0x4(%eax)
  803cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc8:	8b 55 08             	mov    0x8(%ebp),%edx
  803ccb:	89 10                	mov    %edx,(%eax)
  803ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cd3:	89 50 04             	mov    %edx,0x4(%eax)
  803cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd9:	8b 00                	mov    (%eax),%eax
  803cdb:	85 c0                	test   %eax,%eax
  803cdd:	75 08                	jne    803ce7 <insert_sorted_with_merge_freeList+0x703>
  803cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ce7:	a1 44 51 80 00       	mov    0x805144,%eax
  803cec:	40                   	inc    %eax
  803ced:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803cf2:	eb 39                	jmp    803d2d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803cf4:	a1 40 51 80 00       	mov    0x805140,%eax
  803cf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d00:	74 07                	je     803d09 <insert_sorted_with_merge_freeList+0x725>
  803d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d05:	8b 00                	mov    (%eax),%eax
  803d07:	eb 05                	jmp    803d0e <insert_sorted_with_merge_freeList+0x72a>
  803d09:	b8 00 00 00 00       	mov    $0x0,%eax
  803d0e:	a3 40 51 80 00       	mov    %eax,0x805140
  803d13:	a1 40 51 80 00       	mov    0x805140,%eax
  803d18:	85 c0                	test   %eax,%eax
  803d1a:	0f 85 c7 fb ff ff    	jne    8038e7 <insert_sorted_with_merge_freeList+0x303>
  803d20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d24:	0f 85 bd fb ff ff    	jne    8038e7 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d2a:	eb 01                	jmp    803d2d <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803d2c:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d2d:	90                   	nop
  803d2e:	c9                   	leave  
  803d2f:	c3                   	ret    

00803d30 <__udivdi3>:
  803d30:	55                   	push   %ebp
  803d31:	57                   	push   %edi
  803d32:	56                   	push   %esi
  803d33:	53                   	push   %ebx
  803d34:	83 ec 1c             	sub    $0x1c,%esp
  803d37:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d3b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d43:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d47:	89 ca                	mov    %ecx,%edx
  803d49:	89 f8                	mov    %edi,%eax
  803d4b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d4f:	85 f6                	test   %esi,%esi
  803d51:	75 2d                	jne    803d80 <__udivdi3+0x50>
  803d53:	39 cf                	cmp    %ecx,%edi
  803d55:	77 65                	ja     803dbc <__udivdi3+0x8c>
  803d57:	89 fd                	mov    %edi,%ebp
  803d59:	85 ff                	test   %edi,%edi
  803d5b:	75 0b                	jne    803d68 <__udivdi3+0x38>
  803d5d:	b8 01 00 00 00       	mov    $0x1,%eax
  803d62:	31 d2                	xor    %edx,%edx
  803d64:	f7 f7                	div    %edi
  803d66:	89 c5                	mov    %eax,%ebp
  803d68:	31 d2                	xor    %edx,%edx
  803d6a:	89 c8                	mov    %ecx,%eax
  803d6c:	f7 f5                	div    %ebp
  803d6e:	89 c1                	mov    %eax,%ecx
  803d70:	89 d8                	mov    %ebx,%eax
  803d72:	f7 f5                	div    %ebp
  803d74:	89 cf                	mov    %ecx,%edi
  803d76:	89 fa                	mov    %edi,%edx
  803d78:	83 c4 1c             	add    $0x1c,%esp
  803d7b:	5b                   	pop    %ebx
  803d7c:	5e                   	pop    %esi
  803d7d:	5f                   	pop    %edi
  803d7e:	5d                   	pop    %ebp
  803d7f:	c3                   	ret    
  803d80:	39 ce                	cmp    %ecx,%esi
  803d82:	77 28                	ja     803dac <__udivdi3+0x7c>
  803d84:	0f bd fe             	bsr    %esi,%edi
  803d87:	83 f7 1f             	xor    $0x1f,%edi
  803d8a:	75 40                	jne    803dcc <__udivdi3+0x9c>
  803d8c:	39 ce                	cmp    %ecx,%esi
  803d8e:	72 0a                	jb     803d9a <__udivdi3+0x6a>
  803d90:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d94:	0f 87 9e 00 00 00    	ja     803e38 <__udivdi3+0x108>
  803d9a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d9f:	89 fa                	mov    %edi,%edx
  803da1:	83 c4 1c             	add    $0x1c,%esp
  803da4:	5b                   	pop    %ebx
  803da5:	5e                   	pop    %esi
  803da6:	5f                   	pop    %edi
  803da7:	5d                   	pop    %ebp
  803da8:	c3                   	ret    
  803da9:	8d 76 00             	lea    0x0(%esi),%esi
  803dac:	31 ff                	xor    %edi,%edi
  803dae:	31 c0                	xor    %eax,%eax
  803db0:	89 fa                	mov    %edi,%edx
  803db2:	83 c4 1c             	add    $0x1c,%esp
  803db5:	5b                   	pop    %ebx
  803db6:	5e                   	pop    %esi
  803db7:	5f                   	pop    %edi
  803db8:	5d                   	pop    %ebp
  803db9:	c3                   	ret    
  803dba:	66 90                	xchg   %ax,%ax
  803dbc:	89 d8                	mov    %ebx,%eax
  803dbe:	f7 f7                	div    %edi
  803dc0:	31 ff                	xor    %edi,%edi
  803dc2:	89 fa                	mov    %edi,%edx
  803dc4:	83 c4 1c             	add    $0x1c,%esp
  803dc7:	5b                   	pop    %ebx
  803dc8:	5e                   	pop    %esi
  803dc9:	5f                   	pop    %edi
  803dca:	5d                   	pop    %ebp
  803dcb:	c3                   	ret    
  803dcc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803dd1:	89 eb                	mov    %ebp,%ebx
  803dd3:	29 fb                	sub    %edi,%ebx
  803dd5:	89 f9                	mov    %edi,%ecx
  803dd7:	d3 e6                	shl    %cl,%esi
  803dd9:	89 c5                	mov    %eax,%ebp
  803ddb:	88 d9                	mov    %bl,%cl
  803ddd:	d3 ed                	shr    %cl,%ebp
  803ddf:	89 e9                	mov    %ebp,%ecx
  803de1:	09 f1                	or     %esi,%ecx
  803de3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803de7:	89 f9                	mov    %edi,%ecx
  803de9:	d3 e0                	shl    %cl,%eax
  803deb:	89 c5                	mov    %eax,%ebp
  803ded:	89 d6                	mov    %edx,%esi
  803def:	88 d9                	mov    %bl,%cl
  803df1:	d3 ee                	shr    %cl,%esi
  803df3:	89 f9                	mov    %edi,%ecx
  803df5:	d3 e2                	shl    %cl,%edx
  803df7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dfb:	88 d9                	mov    %bl,%cl
  803dfd:	d3 e8                	shr    %cl,%eax
  803dff:	09 c2                	or     %eax,%edx
  803e01:	89 d0                	mov    %edx,%eax
  803e03:	89 f2                	mov    %esi,%edx
  803e05:	f7 74 24 0c          	divl   0xc(%esp)
  803e09:	89 d6                	mov    %edx,%esi
  803e0b:	89 c3                	mov    %eax,%ebx
  803e0d:	f7 e5                	mul    %ebp
  803e0f:	39 d6                	cmp    %edx,%esi
  803e11:	72 19                	jb     803e2c <__udivdi3+0xfc>
  803e13:	74 0b                	je     803e20 <__udivdi3+0xf0>
  803e15:	89 d8                	mov    %ebx,%eax
  803e17:	31 ff                	xor    %edi,%edi
  803e19:	e9 58 ff ff ff       	jmp    803d76 <__udivdi3+0x46>
  803e1e:	66 90                	xchg   %ax,%ax
  803e20:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e24:	89 f9                	mov    %edi,%ecx
  803e26:	d3 e2                	shl    %cl,%edx
  803e28:	39 c2                	cmp    %eax,%edx
  803e2a:	73 e9                	jae    803e15 <__udivdi3+0xe5>
  803e2c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e2f:	31 ff                	xor    %edi,%edi
  803e31:	e9 40 ff ff ff       	jmp    803d76 <__udivdi3+0x46>
  803e36:	66 90                	xchg   %ax,%ax
  803e38:	31 c0                	xor    %eax,%eax
  803e3a:	e9 37 ff ff ff       	jmp    803d76 <__udivdi3+0x46>
  803e3f:	90                   	nop

00803e40 <__umoddi3>:
  803e40:	55                   	push   %ebp
  803e41:	57                   	push   %edi
  803e42:	56                   	push   %esi
  803e43:	53                   	push   %ebx
  803e44:	83 ec 1c             	sub    $0x1c,%esp
  803e47:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e4b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e53:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e5b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e5f:	89 f3                	mov    %esi,%ebx
  803e61:	89 fa                	mov    %edi,%edx
  803e63:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e67:	89 34 24             	mov    %esi,(%esp)
  803e6a:	85 c0                	test   %eax,%eax
  803e6c:	75 1a                	jne    803e88 <__umoddi3+0x48>
  803e6e:	39 f7                	cmp    %esi,%edi
  803e70:	0f 86 a2 00 00 00    	jbe    803f18 <__umoddi3+0xd8>
  803e76:	89 c8                	mov    %ecx,%eax
  803e78:	89 f2                	mov    %esi,%edx
  803e7a:	f7 f7                	div    %edi
  803e7c:	89 d0                	mov    %edx,%eax
  803e7e:	31 d2                	xor    %edx,%edx
  803e80:	83 c4 1c             	add    $0x1c,%esp
  803e83:	5b                   	pop    %ebx
  803e84:	5e                   	pop    %esi
  803e85:	5f                   	pop    %edi
  803e86:	5d                   	pop    %ebp
  803e87:	c3                   	ret    
  803e88:	39 f0                	cmp    %esi,%eax
  803e8a:	0f 87 ac 00 00 00    	ja     803f3c <__umoddi3+0xfc>
  803e90:	0f bd e8             	bsr    %eax,%ebp
  803e93:	83 f5 1f             	xor    $0x1f,%ebp
  803e96:	0f 84 ac 00 00 00    	je     803f48 <__umoddi3+0x108>
  803e9c:	bf 20 00 00 00       	mov    $0x20,%edi
  803ea1:	29 ef                	sub    %ebp,%edi
  803ea3:	89 fe                	mov    %edi,%esi
  803ea5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ea9:	89 e9                	mov    %ebp,%ecx
  803eab:	d3 e0                	shl    %cl,%eax
  803ead:	89 d7                	mov    %edx,%edi
  803eaf:	89 f1                	mov    %esi,%ecx
  803eb1:	d3 ef                	shr    %cl,%edi
  803eb3:	09 c7                	or     %eax,%edi
  803eb5:	89 e9                	mov    %ebp,%ecx
  803eb7:	d3 e2                	shl    %cl,%edx
  803eb9:	89 14 24             	mov    %edx,(%esp)
  803ebc:	89 d8                	mov    %ebx,%eax
  803ebe:	d3 e0                	shl    %cl,%eax
  803ec0:	89 c2                	mov    %eax,%edx
  803ec2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ec6:	d3 e0                	shl    %cl,%eax
  803ec8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ecc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ed0:	89 f1                	mov    %esi,%ecx
  803ed2:	d3 e8                	shr    %cl,%eax
  803ed4:	09 d0                	or     %edx,%eax
  803ed6:	d3 eb                	shr    %cl,%ebx
  803ed8:	89 da                	mov    %ebx,%edx
  803eda:	f7 f7                	div    %edi
  803edc:	89 d3                	mov    %edx,%ebx
  803ede:	f7 24 24             	mull   (%esp)
  803ee1:	89 c6                	mov    %eax,%esi
  803ee3:	89 d1                	mov    %edx,%ecx
  803ee5:	39 d3                	cmp    %edx,%ebx
  803ee7:	0f 82 87 00 00 00    	jb     803f74 <__umoddi3+0x134>
  803eed:	0f 84 91 00 00 00    	je     803f84 <__umoddi3+0x144>
  803ef3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ef7:	29 f2                	sub    %esi,%edx
  803ef9:	19 cb                	sbb    %ecx,%ebx
  803efb:	89 d8                	mov    %ebx,%eax
  803efd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f01:	d3 e0                	shl    %cl,%eax
  803f03:	89 e9                	mov    %ebp,%ecx
  803f05:	d3 ea                	shr    %cl,%edx
  803f07:	09 d0                	or     %edx,%eax
  803f09:	89 e9                	mov    %ebp,%ecx
  803f0b:	d3 eb                	shr    %cl,%ebx
  803f0d:	89 da                	mov    %ebx,%edx
  803f0f:	83 c4 1c             	add    $0x1c,%esp
  803f12:	5b                   	pop    %ebx
  803f13:	5e                   	pop    %esi
  803f14:	5f                   	pop    %edi
  803f15:	5d                   	pop    %ebp
  803f16:	c3                   	ret    
  803f17:	90                   	nop
  803f18:	89 fd                	mov    %edi,%ebp
  803f1a:	85 ff                	test   %edi,%edi
  803f1c:	75 0b                	jne    803f29 <__umoddi3+0xe9>
  803f1e:	b8 01 00 00 00       	mov    $0x1,%eax
  803f23:	31 d2                	xor    %edx,%edx
  803f25:	f7 f7                	div    %edi
  803f27:	89 c5                	mov    %eax,%ebp
  803f29:	89 f0                	mov    %esi,%eax
  803f2b:	31 d2                	xor    %edx,%edx
  803f2d:	f7 f5                	div    %ebp
  803f2f:	89 c8                	mov    %ecx,%eax
  803f31:	f7 f5                	div    %ebp
  803f33:	89 d0                	mov    %edx,%eax
  803f35:	e9 44 ff ff ff       	jmp    803e7e <__umoddi3+0x3e>
  803f3a:	66 90                	xchg   %ax,%ax
  803f3c:	89 c8                	mov    %ecx,%eax
  803f3e:	89 f2                	mov    %esi,%edx
  803f40:	83 c4 1c             	add    $0x1c,%esp
  803f43:	5b                   	pop    %ebx
  803f44:	5e                   	pop    %esi
  803f45:	5f                   	pop    %edi
  803f46:	5d                   	pop    %ebp
  803f47:	c3                   	ret    
  803f48:	3b 04 24             	cmp    (%esp),%eax
  803f4b:	72 06                	jb     803f53 <__umoddi3+0x113>
  803f4d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f51:	77 0f                	ja     803f62 <__umoddi3+0x122>
  803f53:	89 f2                	mov    %esi,%edx
  803f55:	29 f9                	sub    %edi,%ecx
  803f57:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f5b:	89 14 24             	mov    %edx,(%esp)
  803f5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f62:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f66:	8b 14 24             	mov    (%esp),%edx
  803f69:	83 c4 1c             	add    $0x1c,%esp
  803f6c:	5b                   	pop    %ebx
  803f6d:	5e                   	pop    %esi
  803f6e:	5f                   	pop    %edi
  803f6f:	5d                   	pop    %ebp
  803f70:	c3                   	ret    
  803f71:	8d 76 00             	lea    0x0(%esi),%esi
  803f74:	2b 04 24             	sub    (%esp),%eax
  803f77:	19 fa                	sbb    %edi,%edx
  803f79:	89 d1                	mov    %edx,%ecx
  803f7b:	89 c6                	mov    %eax,%esi
  803f7d:	e9 71 ff ff ff       	jmp    803ef3 <__umoddi3+0xb3>
  803f82:	66 90                	xchg   %ax,%ax
  803f84:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f88:	72 ea                	jb     803f74 <__umoddi3+0x134>
  803f8a:	89 d9                	mov    %ebx,%ecx
  803f8c:	e9 62 ff ff ff       	jmp    803ef3 <__umoddi3+0xb3>
