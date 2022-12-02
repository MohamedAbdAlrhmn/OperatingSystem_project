
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
  800044:	e8 d2 25 00 00       	call   80261b <sys_set_uheap_strategy>
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
  80009a:	68 40 3f 80 00       	push   $0x803f40
  80009f:	6a 15                	push   $0x15
  8000a1:	68 5c 3f 80 00       	push   $0x803f5c
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
  8000d7:	e8 2a 20 00 00       	call   802106 <sys_calculate_free_frames>
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000df:	e8 c2 20 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
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
  800109:	68 74 3f 80 00       	push   $0x803f74
  80010e:	6a 26                	push   $0x26
  800110:	68 5c 3f 80 00       	push   $0x803f5c
  800115:	e8 90 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80011a:	e8 87 20 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  80011f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 a4 3f 80 00       	push   $0x803fa4
  80012c:	6a 28                	push   $0x28
  80012e:	68 5c 3f 80 00       	push   $0x803f5c
  800133:	e8 72 0b 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800138:	e8 c9 1f 00 00       	call   802106 <sys_calculate_free_frames>
  80013d:	89 c2                	mov    %eax,%edx
  80013f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800142:	39 c2                	cmp    %eax,%edx
  800144:	74 14                	je     80015a <_main+0x122>
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	68 c1 3f 80 00       	push   $0x803fc1
  80014e:	6a 29                	push   $0x29
  800150:	68 5c 3f 80 00       	push   $0x803f5c
  800155:	e8 50 0b 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80015a:	e8 a7 1f 00 00       	call   802106 <sys_calculate_free_frames>
  80015f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800162:	e8 3f 20 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
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
  800193:	68 74 3f 80 00       	push   $0x803f74
  800198:	6a 2f                	push   $0x2f
  80019a:	68 5c 3f 80 00       	push   $0x803f5c
  80019f:	e8 06 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001a4:	e8 fd 1f 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  8001a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 a4 3f 80 00       	push   $0x803fa4
  8001b6:	6a 31                	push   $0x31
  8001b8:	68 5c 3f 80 00       	push   $0x803f5c
  8001bd:	e8 e8 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001c2:	e8 3f 1f 00 00       	call   802106 <sys_calculate_free_frames>
  8001c7:	89 c2                	mov    %eax,%edx
  8001c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 c1 3f 80 00       	push   $0x803fc1
  8001d8:	6a 32                	push   $0x32
  8001da:	68 5c 3f 80 00       	push   $0x803f5c
  8001df:	e8 c6 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001e4:	e8 1d 1f 00 00       	call   802106 <sys_calculate_free_frames>
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001ec:	e8 b5 1f 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
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
  80021f:	68 74 3f 80 00       	push   $0x803f74
  800224:	6a 38                	push   $0x38
  800226:	68 5c 3f 80 00       	push   $0x803f5c
  80022b:	e8 7a 0a 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800230:	e8 71 1f 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  800235:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800238:	74 14                	je     80024e <_main+0x216>
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	68 a4 3f 80 00       	push   $0x803fa4
  800242:	6a 3a                	push   $0x3a
  800244:	68 5c 3f 80 00       	push   $0x803f5c
  800249:	e8 5c 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80024e:	e8 b3 1e 00 00       	call   802106 <sys_calculate_free_frames>
  800253:	89 c2                	mov    %eax,%edx
  800255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800258:	39 c2                	cmp    %eax,%edx
  80025a:	74 14                	je     800270 <_main+0x238>
  80025c:	83 ec 04             	sub    $0x4,%esp
  80025f:	68 c1 3f 80 00       	push   $0x803fc1
  800264:	6a 3b                	push   $0x3b
  800266:	68 5c 3f 80 00       	push   $0x803f5c
  80026b:	e8 3a 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800270:	e8 91 1e 00 00       	call   802106 <sys_calculate_free_frames>
  800275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800278:	e8 29 1f 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
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
  8002af:	68 74 3f 80 00       	push   $0x803f74
  8002b4:	6a 41                	push   $0x41
  8002b6:	68 5c 3f 80 00       	push   $0x803f5c
  8002bb:	e8 ea 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002c0:	e8 e1 1e 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  8002c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c8:	74 14                	je     8002de <_main+0x2a6>
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	68 a4 3f 80 00       	push   $0x803fa4
  8002d2:	6a 43                	push   $0x43
  8002d4:	68 5c 3f 80 00       	push   $0x803f5c
  8002d9:	e8 cc 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002de:	e8 23 1e 00 00       	call   802106 <sys_calculate_free_frames>
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e8:	39 c2                	cmp    %eax,%edx
  8002ea:	74 14                	je     800300 <_main+0x2c8>
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	68 c1 3f 80 00       	push   $0x803fc1
  8002f4:	6a 44                	push   $0x44
  8002f6:	68 5c 3f 80 00       	push   $0x803f5c
  8002fb:	e8 aa 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800300:	e8 01 1e 00 00       	call   802106 <sys_calculate_free_frames>
  800305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800308:	e8 99 1e 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
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
  80033e:	68 74 3f 80 00       	push   $0x803f74
  800343:	6a 4a                	push   $0x4a
  800345:	68 5c 3f 80 00       	push   $0x803f5c
  80034a:	e8 5b 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80034f:	e8 52 1e 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  800354:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800357:	74 14                	je     80036d <_main+0x335>
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	68 a4 3f 80 00       	push   $0x803fa4
  800361:	6a 4c                	push   $0x4c
  800363:	68 5c 3f 80 00       	push   $0x803f5c
  800368:	e8 3d 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80036d:	e8 94 1d 00 00       	call   802106 <sys_calculate_free_frames>
  800372:	89 c2                	mov    %eax,%edx
  800374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800377:	39 c2                	cmp    %eax,%edx
  800379:	74 14                	je     80038f <_main+0x357>
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	68 c1 3f 80 00       	push   $0x803fc1
  800383:	6a 4d                	push   $0x4d
  800385:	68 5c 3f 80 00       	push   $0x803f5c
  80038a:	e8 1b 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80038f:	e8 72 1d 00 00       	call   802106 <sys_calculate_free_frames>
  800394:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800397:	e8 0a 1e 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
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
  8003d2:	68 74 3f 80 00       	push   $0x803f74
  8003d7:	6a 53                	push   $0x53
  8003d9:	68 5c 3f 80 00       	push   $0x803f5c
  8003de:	e8 c7 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8003e3:	e8 be 1d 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  8003e8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 a4 3f 80 00       	push   $0x803fa4
  8003f5:	6a 55                	push   $0x55
  8003f7:	68 5c 3f 80 00       	push   $0x803f5c
  8003fc:	e8 a9 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800401:	e8 00 1d 00 00       	call   802106 <sys_calculate_free_frames>
  800406:	89 c2                	mov    %eax,%edx
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	39 c2                	cmp    %eax,%edx
  80040d:	74 14                	je     800423 <_main+0x3eb>
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 c1 3f 80 00       	push   $0x803fc1
  800417:	6a 56                	push   $0x56
  800419:	68 5c 3f 80 00       	push   $0x803f5c
  80041e:	e8 87 08 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 de 1c 00 00       	call   802106 <sys_calculate_free_frames>
  800428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 76 1d 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
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
  800465:	68 74 3f 80 00       	push   $0x803f74
  80046a:	6a 5c                	push   $0x5c
  80046c:	68 5c 3f 80 00       	push   $0x803f5c
  800471:	e8 34 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800476:	e8 2b 1d 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  80047b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 a4 3f 80 00       	push   $0x803fa4
  800488:	6a 5e                	push   $0x5e
  80048a:	68 5c 3f 80 00       	push   $0x803f5c
  80048f:	e8 16 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800494:	e8 6d 1c 00 00       	call   802106 <sys_calculate_free_frames>
  800499:	89 c2                	mov    %eax,%edx
  80049b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	74 14                	je     8004b6 <_main+0x47e>
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	68 c1 3f 80 00       	push   $0x803fc1
  8004aa:	6a 5f                	push   $0x5f
  8004ac:	68 5c 3f 80 00       	push   $0x803f5c
  8004b1:	e8 f4 07 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004b6:	e8 4b 1c 00 00       	call   802106 <sys_calculate_free_frames>
  8004bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004be:	e8 e3 1c 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
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
  800500:	68 74 3f 80 00       	push   $0x803f74
  800505:	6a 65                	push   $0x65
  800507:	68 5c 3f 80 00       	push   $0x803f5c
  80050c:	e8 99 07 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800511:	e8 90 1c 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  800516:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800519:	74 14                	je     80052f <_main+0x4f7>
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	68 a4 3f 80 00       	push   $0x803fa4
  800523:	6a 67                	push   $0x67
  800525:	68 5c 3f 80 00       	push   $0x803f5c
  80052a:	e8 7b 07 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80052f:	e8 d2 1b 00 00       	call   802106 <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 c1 3f 80 00       	push   $0x803fc1
  800545:	6a 68                	push   $0x68
  800547:	68 5c 3f 80 00       	push   $0x803f5c
  80054c:	e8 59 07 00 00       	call   800caa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800551:	e8 b0 1b 00 00       	call   802106 <sys_calculate_free_frames>
  800556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800559:	e8 48 1c 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  80055e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800561:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	50                   	push   %eax
  800568:	e8 a7 19 00 00       	call   801f14 <free>
  80056d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800570:	e8 31 1c 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  800575:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800578:	74 14                	je     80058e <_main+0x556>
  80057a:	83 ec 04             	sub    $0x4,%esp
  80057d:	68 d4 3f 80 00       	push   $0x803fd4
  800582:	6a 72                	push   $0x72
  800584:	68 5c 3f 80 00       	push   $0x803f5c
  800589:	e8 1c 07 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80058e:	e8 73 1b 00 00       	call   802106 <sys_calculate_free_frames>
  800593:	89 c2                	mov    %eax,%edx
  800595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800598:	39 c2                	cmp    %eax,%edx
  80059a:	74 14                	je     8005b0 <_main+0x578>
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	68 eb 3f 80 00       	push   $0x803feb
  8005a4:	6a 73                	push   $0x73
  8005a6:	68 5c 3f 80 00       	push   $0x803f5c
  8005ab:	e8 fa 06 00 00       	call   800caa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005b0:	e8 51 1b 00 00       	call   802106 <sys_calculate_free_frames>
  8005b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005b8:	e8 e9 1b 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  8005c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	50                   	push   %eax
  8005c7:	e8 48 19 00 00       	call   801f14 <free>
  8005cc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005cf:	e8 d2 1b 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  8005d4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005d7:	74 14                	je     8005ed <_main+0x5b5>
  8005d9:	83 ec 04             	sub    $0x4,%esp
  8005dc:	68 d4 3f 80 00       	push   $0x803fd4
  8005e1:	6a 7a                	push   $0x7a
  8005e3:	68 5c 3f 80 00       	push   $0x803f5c
  8005e8:	e8 bd 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ed:	e8 14 1b 00 00       	call   802106 <sys_calculate_free_frames>
  8005f2:	89 c2                	mov    %eax,%edx
  8005f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f7:	39 c2                	cmp    %eax,%edx
  8005f9:	74 14                	je     80060f <_main+0x5d7>
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 eb 3f 80 00       	push   $0x803feb
  800603:	6a 7b                	push   $0x7b
  800605:	68 5c 3f 80 00       	push   $0x803f5c
  80060a:	e8 9b 06 00 00       	call   800caa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80060f:	e8 f2 1a 00 00       	call   802106 <sys_calculate_free_frames>
  800614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800617:	e8 8a 1b 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80061f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800622:	83 ec 0c             	sub    $0xc,%esp
  800625:	50                   	push   %eax
  800626:	e8 e9 18 00 00       	call   801f14 <free>
  80062b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80062e:	e8 73 1b 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  800633:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800636:	74 17                	je     80064f <_main+0x617>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 d4 3f 80 00       	push   $0x803fd4
  800640:	68 82 00 00 00       	push   $0x82
  800645:	68 5c 3f 80 00       	push   $0x803f5c
  80064a:	e8 5b 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064f:	e8 b2 1a 00 00       	call   802106 <sys_calculate_free_frames>
  800654:	89 c2                	mov    %eax,%edx
  800656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800659:	39 c2                	cmp    %eax,%edx
  80065b:	74 17                	je     800674 <_main+0x63c>
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	68 eb 3f 80 00       	push   $0x803feb
  800665:	68 83 00 00 00       	push   $0x83
  80066a:	68 5c 3f 80 00       	push   $0x803f5c
  80066f:	e8 36 06 00 00       	call   800caa <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800674:	e8 8d 1a 00 00       	call   802106 <sys_calculate_free_frames>
  800679:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80067c:	e8 25 1b 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
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
  8006b1:	68 74 3f 80 00       	push   $0x803f74
  8006b6:	68 8c 00 00 00       	push   $0x8c
  8006bb:	68 5c 3f 80 00       	push   $0x803f5c
  8006c0:	e8 e5 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006c5:	e8 dc 1a 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  8006ca:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006cd:	74 17                	je     8006e6 <_main+0x6ae>
  8006cf:	83 ec 04             	sub    $0x4,%esp
  8006d2:	68 a4 3f 80 00       	push   $0x803fa4
  8006d7:	68 8e 00 00 00       	push   $0x8e
  8006dc:	68 5c 3f 80 00       	push   $0x803f5c
  8006e1:	e8 c4 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8006e6:	e8 1b 1a 00 00       	call   802106 <sys_calculate_free_frames>
  8006eb:	89 c2                	mov    %eax,%edx
  8006ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f0:	39 c2                	cmp    %eax,%edx
  8006f2:	74 17                	je     80070b <_main+0x6d3>
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	68 c1 3f 80 00       	push   $0x803fc1
  8006fc:	68 8f 00 00 00       	push   $0x8f
  800701:	68 5c 3f 80 00       	push   $0x803f5c
  800706:	e8 9f 05 00 00       	call   800caa <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80070b:	e8 f6 19 00 00       	call   802106 <sys_calculate_free_frames>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800713:	e8 8e 1a 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
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
  800747:	68 74 3f 80 00       	push   $0x803f74
  80074c:	68 95 00 00 00       	push   $0x95
  800751:	68 5c 3f 80 00       	push   $0x803f5c
  800756:	e8 4f 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80075b:	e8 46 1a 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  800760:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800763:	74 17                	je     80077c <_main+0x744>
  800765:	83 ec 04             	sub    $0x4,%esp
  800768:	68 a4 3f 80 00       	push   $0x803fa4
  80076d:	68 97 00 00 00       	push   $0x97
  800772:	68 5c 3f 80 00       	push   $0x803f5c
  800777:	e8 2e 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80077c:	e8 85 19 00 00       	call   802106 <sys_calculate_free_frames>
  800781:	89 c2                	mov    %eax,%edx
  800783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800786:	39 c2                	cmp    %eax,%edx
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	68 c1 3f 80 00       	push   $0x803fc1
  800792:	68 98 00 00 00       	push   $0x98
  800797:	68 5c 3f 80 00       	push   $0x803f5c
  80079c:	e8 09 05 00 00       	call   800caa <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007a1:	e8 60 19 00 00       	call   802106 <sys_calculate_free_frames>
  8007a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007a9:	e8 f8 19 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
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
  8007e8:	68 74 3f 80 00       	push   $0x803f74
  8007ed:	68 9e 00 00 00       	push   $0x9e
  8007f2:	68 5c 3f 80 00       	push   $0x803f5c
  8007f7:	e8 ae 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8007fc:	e8 a5 19 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  800801:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800804:	74 17                	je     80081d <_main+0x7e5>
  800806:	83 ec 04             	sub    $0x4,%esp
  800809:	68 a4 3f 80 00       	push   $0x803fa4
  80080e:	68 a0 00 00 00       	push   $0xa0
  800813:	68 5c 3f 80 00       	push   $0x803f5c
  800818:	e8 8d 04 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80081d:	e8 e4 18 00 00       	call   802106 <sys_calculate_free_frames>
  800822:	89 c2                	mov    %eax,%edx
  800824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800827:	39 c2                	cmp    %eax,%edx
  800829:	74 17                	je     800842 <_main+0x80a>
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	68 c1 3f 80 00       	push   $0x803fc1
  800833:	68 a1 00 00 00       	push   $0xa1
  800838:	68 5c 3f 80 00       	push   $0x803f5c
  80083d:	e8 68 04 00 00       	call   800caa <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800842:	e8 bf 18 00 00       	call   802106 <sys_calculate_free_frames>
  800847:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80084a:	e8 57 19 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
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
  80087d:	68 74 3f 80 00       	push   $0x803f74
  800882:	68 a7 00 00 00       	push   $0xa7
  800887:	68 5c 3f 80 00       	push   $0x803f5c
  80088c:	e8 19 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800891:	e8 10 19 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  800896:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800899:	74 17                	je     8008b2 <_main+0x87a>
  80089b:	83 ec 04             	sub    $0x4,%esp
  80089e:	68 a4 3f 80 00       	push   $0x803fa4
  8008a3:	68 a9 00 00 00       	push   $0xa9
  8008a8:	68 5c 3f 80 00       	push   $0x803f5c
  8008ad:	e8 f8 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008b2:	e8 4f 18 00 00       	call   802106 <sys_calculate_free_frames>
  8008b7:	89 c2                	mov    %eax,%edx
  8008b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008bc:	39 c2                	cmp    %eax,%edx
  8008be:	74 17                	je     8008d7 <_main+0x89f>
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	68 c1 3f 80 00       	push   $0x803fc1
  8008c8:	68 aa 00 00 00       	push   $0xaa
  8008cd:	68 5c 3f 80 00       	push   $0x803f5c
  8008d2:	e8 d3 03 00 00       	call   800caa <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008d7:	e8 2a 18 00 00       	call   802106 <sys_calculate_free_frames>
  8008dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008df:	e8 c2 18 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
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
  80091f:	68 74 3f 80 00       	push   $0x803f74
  800924:	68 b0 00 00 00       	push   $0xb0
  800929:	68 5c 3f 80 00       	push   $0x803f5c
  80092e:	e8 77 03 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800933:	e8 6e 18 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  800938:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80093b:	74 17                	je     800954 <_main+0x91c>
  80093d:	83 ec 04             	sub    $0x4,%esp
  800940:	68 a4 3f 80 00       	push   $0x803fa4
  800945:	68 b2 00 00 00       	push   $0xb2
  80094a:	68 5c 3f 80 00       	push   $0x803f5c
  80094f:	e8 56 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800954:	e8 ad 17 00 00       	call   802106 <sys_calculate_free_frames>
  800959:	89 c2                	mov    %eax,%edx
  80095b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80095e:	39 c2                	cmp    %eax,%edx
  800960:	74 17                	je     800979 <_main+0x941>
  800962:	83 ec 04             	sub    $0x4,%esp
  800965:	68 c1 3f 80 00       	push   $0x803fc1
  80096a:	68 b3 00 00 00       	push   $0xb3
  80096f:	68 5c 3f 80 00       	push   $0x803f5c
  800974:	e8 31 03 00 00       	call   800caa <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800979:	e8 88 17 00 00       	call   802106 <sys_calculate_free_frames>
  80097e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800981:	e8 20 18 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  800986:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  800989:	8b 45 98             	mov    -0x68(%ebp),%eax
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 7f 15 00 00       	call   801f14 <free>
  800995:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800998:	e8 09 18 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 d4 3f 80 00       	push   $0x803fd4
  8009aa:	68 bd 00 00 00       	push   $0xbd
  8009af:	68 5c 3f 80 00       	push   $0x803f5c
  8009b4:	e8 f1 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009b9:	e8 48 17 00 00       	call   802106 <sys_calculate_free_frames>
  8009be:	89 c2                	mov    %eax,%edx
  8009c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c3:	39 c2                	cmp    %eax,%edx
  8009c5:	74 17                	je     8009de <_main+0x9a6>
  8009c7:	83 ec 04             	sub    $0x4,%esp
  8009ca:	68 eb 3f 80 00       	push   $0x803feb
  8009cf:	68 be 00 00 00       	push   $0xbe
  8009d4:	68 5c 3f 80 00       	push   $0x803f5c
  8009d9:	e8 cc 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8009de:	e8 23 17 00 00       	call   802106 <sys_calculate_free_frames>
  8009e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e6:	e8 bb 17 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  8009eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[9]);
  8009ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8009f1:	83 ec 0c             	sub    $0xc,%esp
  8009f4:	50                   	push   %eax
  8009f5:	e8 1a 15 00 00       	call   801f14 <free>
  8009fa:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009fd:	e8 a4 17 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  800a02:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 d4 3f 80 00       	push   $0x803fd4
  800a0f:	68 c5 00 00 00       	push   $0xc5
  800a14:	68 5c 3f 80 00       	push   $0x803f5c
  800a19:	e8 8c 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a1e:	e8 e3 16 00 00       	call   802106 <sys_calculate_free_frames>
  800a23:	89 c2                	mov    %eax,%edx
  800a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a28:	39 c2                	cmp    %eax,%edx
  800a2a:	74 17                	je     800a43 <_main+0xa0b>
  800a2c:	83 ec 04             	sub    $0x4,%esp
  800a2f:	68 eb 3f 80 00       	push   $0x803feb
  800a34:	68 c6 00 00 00       	push   $0xc6
  800a39:	68 5c 3f 80 00       	push   $0x803f5c
  800a3e:	e8 67 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a43:	e8 be 16 00 00       	call   802106 <sys_calculate_free_frames>
  800a48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a4b:	e8 56 17 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  800a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800a53:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800a56:	83 ec 0c             	sub    $0xc,%esp
  800a59:	50                   	push   %eax
  800a5a:	e8 b5 14 00 00       	call   801f14 <free>
  800a5f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a62:	e8 3f 17 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  800a67:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 d4 3f 80 00       	push   $0x803fd4
  800a74:	68 cd 00 00 00       	push   $0xcd
  800a79:	68 5c 3f 80 00       	push   $0x803f5c
  800a7e:	e8 27 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a83:	e8 7e 16 00 00       	call   802106 <sys_calculate_free_frames>
  800a88:	89 c2                	mov    %eax,%edx
  800a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a8d:	39 c2                	cmp    %eax,%edx
  800a8f:	74 17                	je     800aa8 <_main+0xa70>
  800a91:	83 ec 04             	sub    $0x4,%esp
  800a94:	68 eb 3f 80 00       	push   $0x803feb
  800a99:	68 ce 00 00 00       	push   $0xce
  800a9e:	68 5c 3f 80 00       	push   $0x803f5c
  800aa3:	e8 02 02 00 00       	call   800caa <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800aa8:	e8 59 16 00 00       	call   802106 <sys_calculate_free_frames>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ab0:	e8 f1 16 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
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
  800afe:	68 74 3f 80 00       	push   $0x803f74
  800b03:	68 d8 00 00 00       	push   $0xd8
  800b08:	68 5c 3f 80 00       	push   $0x803f5c
  800b0d:	e8 98 01 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b12:	e8 8f 16 00 00       	call   8021a6 <sys_pf_calculate_allocated_pages>
  800b17:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b1a:	74 17                	je     800b33 <_main+0xafb>
  800b1c:	83 ec 04             	sub    $0x4,%esp
  800b1f:	68 a4 3f 80 00       	push   $0x803fa4
  800b24:	68 da 00 00 00       	push   $0xda
  800b29:	68 5c 3f 80 00       	push   $0x803f5c
  800b2e:	e8 77 01 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b33:	e8 ce 15 00 00       	call   802106 <sys_calculate_free_frames>
  800b38:	89 c2                	mov    %eax,%edx
  800b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b3d:	39 c2                	cmp    %eax,%edx
  800b3f:	74 17                	je     800b58 <_main+0xb20>
  800b41:	83 ec 04             	sub    $0x4,%esp
  800b44:	68 c1 3f 80 00       	push   $0x803fc1
  800b49:	68 db 00 00 00       	push   $0xdb
  800b4e:	68 5c 3f 80 00       	push   $0x803f5c
  800b53:	e8 52 01 00 00       	call   800caa <_panic>
	}
	cprintf("Congratulations!! test FIRST FIT allocation (1) completed successfully.\n");
  800b58:	83 ec 0c             	sub    $0xc,%esp
  800b5b:	68 f8 3f 80 00       	push   $0x803ff8
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
  800b74:	e8 6d 18 00 00       	call   8023e6 <sys_getenvindex>
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
  800bdf:	e8 0f 16 00 00       	call   8021f3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800be4:	83 ec 0c             	sub    $0xc,%esp
  800be7:	68 5c 40 80 00       	push   $0x80405c
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
  800c0f:	68 84 40 80 00       	push   $0x804084
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
  800c40:	68 ac 40 80 00       	push   $0x8040ac
  800c45:	e8 14 03 00 00       	call   800f5e <cprintf>
  800c4a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c4d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c52:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	50                   	push   %eax
  800c5c:	68 04 41 80 00       	push   $0x804104
  800c61:	e8 f8 02 00 00       	call   800f5e <cprintf>
  800c66:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	68 5c 40 80 00       	push   $0x80405c
  800c71:	e8 e8 02 00 00       	call   800f5e <cprintf>
  800c76:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c79:	e8 8f 15 00 00       	call   80220d <sys_enable_interrupt>

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
  800c91:	e8 1c 17 00 00       	call   8023b2 <sys_destroy_env>
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
  800ca2:	e8 71 17 00 00       	call   802418 <sys_exit_env>
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
  800ccb:	68 18 41 80 00       	push   $0x804118
  800cd0:	e8 89 02 00 00       	call   800f5e <cprintf>
  800cd5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cd8:	a1 00 50 80 00       	mov    0x805000,%eax
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	ff 75 08             	pushl  0x8(%ebp)
  800ce3:	50                   	push   %eax
  800ce4:	68 1d 41 80 00       	push   $0x80411d
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
  800d08:	68 39 41 80 00       	push   $0x804139
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
  800d34:	68 3c 41 80 00       	push   $0x80413c
  800d39:	6a 26                	push   $0x26
  800d3b:	68 88 41 80 00       	push   $0x804188
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
  800e06:	68 94 41 80 00       	push   $0x804194
  800e0b:	6a 3a                	push   $0x3a
  800e0d:	68 88 41 80 00       	push   $0x804188
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
  800e76:	68 e8 41 80 00       	push   $0x8041e8
  800e7b:	6a 44                	push   $0x44
  800e7d:	68 88 41 80 00       	push   $0x804188
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
  800ed0:	e8 70 11 00 00       	call   802045 <sys_cputs>
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
  800f47:	e8 f9 10 00 00       	call   802045 <sys_cputs>
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
  800f91:	e8 5d 12 00 00       	call   8021f3 <sys_disable_interrupt>
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
  800fb1:	e8 57 12 00 00       	call   80220d <sys_enable_interrupt>
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
  800ffb:	e8 c8 2c 00 00       	call   803cc8 <__udivdi3>
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
  80104b:	e8 88 2d 00 00       	call   803dd8 <__umoddi3>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	05 54 44 80 00       	add    $0x804454,%eax
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
  8011a6:	8b 04 85 78 44 80 00 	mov    0x804478(,%eax,4),%eax
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
  801287:	8b 34 9d c0 42 80 00 	mov    0x8042c0(,%ebx,4),%esi
  80128e:	85 f6                	test   %esi,%esi
  801290:	75 19                	jne    8012ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801292:	53                   	push   %ebx
  801293:	68 65 44 80 00       	push   $0x804465
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
  8012ac:	68 6e 44 80 00       	push   $0x80446e
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
  8012d9:	be 71 44 80 00       	mov    $0x804471,%esi
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
  801cff:	68 d0 45 80 00       	push   $0x8045d0
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  801db2:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dbc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dc1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dc6:	83 ec 04             	sub    $0x4,%esp
  801dc9:	6a 03                	push   $0x3
  801dcb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dce:	50                   	push   %eax
  801dcf:	e8 b5 03 00 00       	call   802189 <sys_allocate_chunk>
  801dd4:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801dd7:	a1 20 51 80 00       	mov    0x805120,%eax
  801ddc:	83 ec 0c             	sub    $0xc,%esp
  801ddf:	50                   	push   %eax
  801de0:	e8 2a 0a 00 00       	call   80280f <initialize_MemBlocksList>
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
  801e0d:	68 f5 45 80 00       	push   $0x8045f5
  801e12:	6a 33                	push   $0x33
  801e14:	68 13 46 80 00       	push   $0x804613
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
  801e8c:	68 20 46 80 00       	push   $0x804620
  801e91:	6a 34                	push   $0x34
  801e93:	68 13 46 80 00       	push   $0x804613
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
  801f01:	68 44 46 80 00       	push   $0x804644
  801f06:	6a 46                	push   $0x46
  801f08:	68 13 46 80 00       	push   $0x804613
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
  801f1d:	68 6c 46 80 00       	push   $0x80466c
  801f22:	6a 61                	push   $0x61
  801f24:	68 13 46 80 00       	push   $0x804613
  801f29:	e8 7c ed ff ff       	call   800caa <_panic>

00801f2e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	83 ec 18             	sub    $0x18,%esp
  801f34:	8b 45 10             	mov    0x10(%ebp),%eax
  801f37:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f3a:	e8 a9 fd ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f43:	75 07                	jne    801f4c <smalloc+0x1e>
  801f45:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4a:	eb 14                	jmp    801f60 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801f4c:	83 ec 04             	sub    $0x4,%esp
  801f4f:	68 90 46 80 00       	push   $0x804690
  801f54:	6a 76                	push   $0x76
  801f56:	68 13 46 80 00       	push   $0x804613
  801f5b:	e8 4a ed ff ff       	call   800caa <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f68:	e8 7b fd ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801f6d:	83 ec 04             	sub    $0x4,%esp
  801f70:	68 b8 46 80 00       	push   $0x8046b8
  801f75:	68 93 00 00 00       	push   $0x93
  801f7a:	68 13 46 80 00       	push   $0x804613
  801f7f:	e8 26 ed ff ff       	call   800caa <_panic>

00801f84 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f8a:	e8 59 fd ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f8f:	83 ec 04             	sub    $0x4,%esp
  801f92:	68 dc 46 80 00       	push   $0x8046dc
  801f97:	68 c5 00 00 00       	push   $0xc5
  801f9c:	68 13 46 80 00       	push   $0x804613
  801fa1:	e8 04 ed ff ff       	call   800caa <_panic>

00801fa6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fac:	83 ec 04             	sub    $0x4,%esp
  801faf:	68 04 47 80 00       	push   $0x804704
  801fb4:	68 d9 00 00 00       	push   $0xd9
  801fb9:	68 13 46 80 00       	push   $0x804613
  801fbe:	e8 e7 ec ff ff       	call   800caa <_panic>

00801fc3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
  801fc6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fc9:	83 ec 04             	sub    $0x4,%esp
  801fcc:	68 28 47 80 00       	push   $0x804728
  801fd1:	68 e4 00 00 00       	push   $0xe4
  801fd6:	68 13 46 80 00       	push   $0x804613
  801fdb:	e8 ca ec ff ff       	call   800caa <_panic>

00801fe0 <shrink>:

}
void shrink(uint32 newSize)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fe6:	83 ec 04             	sub    $0x4,%esp
  801fe9:	68 28 47 80 00       	push   $0x804728
  801fee:	68 e9 00 00 00       	push   $0xe9
  801ff3:	68 13 46 80 00       	push   $0x804613
  801ff8:	e8 ad ec ff ff       	call   800caa <_panic>

00801ffd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802003:	83 ec 04             	sub    $0x4,%esp
  802006:	68 28 47 80 00       	push   $0x804728
  80200b:	68 ee 00 00 00       	push   $0xee
  802010:	68 13 46 80 00       	push   $0x804613
  802015:	e8 90 ec ff ff       	call   800caa <_panic>

0080201a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	57                   	push   %edi
  80201e:	56                   	push   %esi
  80201f:	53                   	push   %ebx
  802020:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	8b 55 0c             	mov    0xc(%ebp),%edx
  802029:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80202f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802032:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802035:	cd 30                	int    $0x30
  802037:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80203a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	5b                   	pop    %ebx
  802041:	5e                   	pop    %esi
  802042:	5f                   	pop    %edi
  802043:	5d                   	pop    %ebp
  802044:	c3                   	ret    

00802045 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 04             	sub    $0x4,%esp
  80204b:	8b 45 10             	mov    0x10(%ebp),%eax
  80204e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802051:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	52                   	push   %edx
  80205d:	ff 75 0c             	pushl  0xc(%ebp)
  802060:	50                   	push   %eax
  802061:	6a 00                	push   $0x0
  802063:	e8 b2 ff ff ff       	call   80201a <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
}
  80206b:	90                   	nop
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <sys_cgetc>:

int
sys_cgetc(void)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 01                	push   $0x1
  80207d:	e8 98 ff ff ff       	call   80201a <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80208a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	52                   	push   %edx
  802097:	50                   	push   %eax
  802098:	6a 05                	push   $0x5
  80209a:	e8 7b ff ff ff       	call   80201a <syscall>
  80209f:	83 c4 18             	add    $0x18,%esp
}
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	56                   	push   %esi
  8020a8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020a9:	8b 75 18             	mov    0x18(%ebp),%esi
  8020ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	56                   	push   %esi
  8020b9:	53                   	push   %ebx
  8020ba:	51                   	push   %ecx
  8020bb:	52                   	push   %edx
  8020bc:	50                   	push   %eax
  8020bd:	6a 06                	push   $0x6
  8020bf:	e8 56 ff ff ff       	call   80201a <syscall>
  8020c4:	83 c4 18             	add    $0x18,%esp
}
  8020c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ca:	5b                   	pop    %ebx
  8020cb:	5e                   	pop    %esi
  8020cc:	5d                   	pop    %ebp
  8020cd:	c3                   	ret    

008020ce <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	52                   	push   %edx
  8020de:	50                   	push   %eax
  8020df:	6a 07                	push   $0x7
  8020e1:	e8 34 ff ff ff       	call   80201a <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	ff 75 0c             	pushl  0xc(%ebp)
  8020f7:	ff 75 08             	pushl  0x8(%ebp)
  8020fa:	6a 08                	push   $0x8
  8020fc:	e8 19 ff ff ff       	call   80201a <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 09                	push   $0x9
  802115:	e8 00 ff ff ff       	call   80201a <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 0a                	push   $0xa
  80212e:	e8 e7 fe ff ff       	call   80201a <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 0b                	push   $0xb
  802147:	e8 ce fe ff ff       	call   80201a <syscall>
  80214c:	83 c4 18             	add    $0x18,%esp
}
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	ff 75 0c             	pushl  0xc(%ebp)
  80215d:	ff 75 08             	pushl  0x8(%ebp)
  802160:	6a 0f                	push   $0xf
  802162:	e8 b3 fe ff ff       	call   80201a <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
	return;
  80216a:	90                   	nop
}
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	ff 75 0c             	pushl  0xc(%ebp)
  802179:	ff 75 08             	pushl  0x8(%ebp)
  80217c:	6a 10                	push   $0x10
  80217e:	e8 97 fe ff ff       	call   80201a <syscall>
  802183:	83 c4 18             	add    $0x18,%esp
	return ;
  802186:	90                   	nop
}
  802187:	c9                   	leave  
  802188:	c3                   	ret    

00802189 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	ff 75 10             	pushl  0x10(%ebp)
  802193:	ff 75 0c             	pushl  0xc(%ebp)
  802196:	ff 75 08             	pushl  0x8(%ebp)
  802199:	6a 11                	push   $0x11
  80219b:	e8 7a fe ff ff       	call   80201a <syscall>
  8021a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a3:	90                   	nop
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 0c                	push   $0xc
  8021b5:	e8 60 fe ff ff       	call   80201a <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	ff 75 08             	pushl  0x8(%ebp)
  8021cd:	6a 0d                	push   $0xd
  8021cf:	e8 46 fe ff ff       	call   80201a <syscall>
  8021d4:	83 c4 18             	add    $0x18,%esp
}
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 0e                	push   $0xe
  8021e8:	e8 2d fe ff ff       	call   80201a <syscall>
  8021ed:	83 c4 18             	add    $0x18,%esp
}
  8021f0:	90                   	nop
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 13                	push   $0x13
  802202:	e8 13 fe ff ff       	call   80201a <syscall>
  802207:	83 c4 18             	add    $0x18,%esp
}
  80220a:	90                   	nop
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    

0080220d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 14                	push   $0x14
  80221c:	e8 f9 fd ff ff       	call   80201a <syscall>
  802221:	83 c4 18             	add    $0x18,%esp
}
  802224:	90                   	nop
  802225:	c9                   	leave  
  802226:	c3                   	ret    

00802227 <sys_cputc>:


void
sys_cputc(const char c)
{
  802227:	55                   	push   %ebp
  802228:	89 e5                	mov    %esp,%ebp
  80222a:	83 ec 04             	sub    $0x4,%esp
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802233:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	50                   	push   %eax
  802240:	6a 15                	push   $0x15
  802242:	e8 d3 fd ff ff       	call   80201a <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	90                   	nop
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 16                	push   $0x16
  80225c:	e8 b9 fd ff ff       	call   80201a <syscall>
  802261:	83 c4 18             	add    $0x18,%esp
}
  802264:	90                   	nop
  802265:	c9                   	leave  
  802266:	c3                   	ret    

00802267 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	ff 75 0c             	pushl  0xc(%ebp)
  802276:	50                   	push   %eax
  802277:	6a 17                	push   $0x17
  802279:	e8 9c fd ff ff       	call   80201a <syscall>
  80227e:	83 c4 18             	add    $0x18,%esp
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802286:	8b 55 0c             	mov    0xc(%ebp),%edx
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	52                   	push   %edx
  802293:	50                   	push   %eax
  802294:	6a 1a                	push   $0x1a
  802296:	e8 7f fd ff ff       	call   80201a <syscall>
  80229b:	83 c4 18             	add    $0x18,%esp
}
  80229e:	c9                   	leave  
  80229f:	c3                   	ret    

008022a0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	52                   	push   %edx
  8022b0:	50                   	push   %eax
  8022b1:	6a 18                	push   $0x18
  8022b3:	e8 62 fd ff ff       	call   80201a <syscall>
  8022b8:	83 c4 18             	add    $0x18,%esp
}
  8022bb:	90                   	nop
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

008022be <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	52                   	push   %edx
  8022ce:	50                   	push   %eax
  8022cf:	6a 19                	push   $0x19
  8022d1:	e8 44 fd ff ff       	call   80201a <syscall>
  8022d6:	83 c4 18             	add    $0x18,%esp
}
  8022d9:	90                   	nop
  8022da:	c9                   	leave  
  8022db:	c3                   	ret    

008022dc <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	83 ec 04             	sub    $0x4,%esp
  8022e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022e8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022eb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	6a 00                	push   $0x0
  8022f4:	51                   	push   %ecx
  8022f5:	52                   	push   %edx
  8022f6:	ff 75 0c             	pushl  0xc(%ebp)
  8022f9:	50                   	push   %eax
  8022fa:	6a 1b                	push   $0x1b
  8022fc:	e8 19 fd ff ff       	call   80201a <syscall>
  802301:	83 c4 18             	add    $0x18,%esp
}
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802309:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	52                   	push   %edx
  802316:	50                   	push   %eax
  802317:	6a 1c                	push   $0x1c
  802319:	e8 fc fc ff ff       	call   80201a <syscall>
  80231e:	83 c4 18             	add    $0x18,%esp
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802326:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802329:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	51                   	push   %ecx
  802334:	52                   	push   %edx
  802335:	50                   	push   %eax
  802336:	6a 1d                	push   $0x1d
  802338:	e8 dd fc ff ff       	call   80201a <syscall>
  80233d:	83 c4 18             	add    $0x18,%esp
}
  802340:	c9                   	leave  
  802341:	c3                   	ret    

00802342 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802345:	8b 55 0c             	mov    0xc(%ebp),%edx
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	52                   	push   %edx
  802352:	50                   	push   %eax
  802353:	6a 1e                	push   $0x1e
  802355:	e8 c0 fc ff ff       	call   80201a <syscall>
  80235a:	83 c4 18             	add    $0x18,%esp
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 1f                	push   $0x1f
  80236e:	e8 a7 fc ff ff       	call   80201a <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
}
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	6a 00                	push   $0x0
  802380:	ff 75 14             	pushl  0x14(%ebp)
  802383:	ff 75 10             	pushl  0x10(%ebp)
  802386:	ff 75 0c             	pushl  0xc(%ebp)
  802389:	50                   	push   %eax
  80238a:	6a 20                	push   $0x20
  80238c:	e8 89 fc ff ff       	call   80201a <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	50                   	push   %eax
  8023a5:	6a 21                	push   $0x21
  8023a7:	e8 6e fc ff ff       	call   80201a <syscall>
  8023ac:	83 c4 18             	add    $0x18,%esp
}
  8023af:	90                   	nop
  8023b0:	c9                   	leave  
  8023b1:	c3                   	ret    

008023b2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023b2:	55                   	push   %ebp
  8023b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	50                   	push   %eax
  8023c1:	6a 22                	push   $0x22
  8023c3:	e8 52 fc ff ff       	call   80201a <syscall>
  8023c8:	83 c4 18             	add    $0x18,%esp
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 02                	push   $0x2
  8023dc:	e8 39 fc ff ff       	call   80201a <syscall>
  8023e1:	83 c4 18             	add    $0x18,%esp
}
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 03                	push   $0x3
  8023f5:	e8 20 fc ff ff       	call   80201a <syscall>
  8023fa:	83 c4 18             	add    $0x18,%esp
}
  8023fd:	c9                   	leave  
  8023fe:	c3                   	ret    

008023ff <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 04                	push   $0x4
  80240e:	e8 07 fc ff ff       	call   80201a <syscall>
  802413:	83 c4 18             	add    $0x18,%esp
}
  802416:	c9                   	leave  
  802417:	c3                   	ret    

00802418 <sys_exit_env>:


void sys_exit_env(void)
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 23                	push   $0x23
  802427:	e8 ee fb ff ff       	call   80201a <syscall>
  80242c:	83 c4 18             	add    $0x18,%esp
}
  80242f:	90                   	nop
  802430:	c9                   	leave  
  802431:	c3                   	ret    

00802432 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
  802435:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802438:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80243b:	8d 50 04             	lea    0x4(%eax),%edx
  80243e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	52                   	push   %edx
  802448:	50                   	push   %eax
  802449:	6a 24                	push   $0x24
  80244b:	e8 ca fb ff ff       	call   80201a <syscall>
  802450:	83 c4 18             	add    $0x18,%esp
	return result;
  802453:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802456:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802459:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80245c:	89 01                	mov    %eax,(%ecx)
  80245e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	c9                   	leave  
  802465:	c2 04 00             	ret    $0x4

00802468 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	ff 75 10             	pushl  0x10(%ebp)
  802472:	ff 75 0c             	pushl  0xc(%ebp)
  802475:	ff 75 08             	pushl  0x8(%ebp)
  802478:	6a 12                	push   $0x12
  80247a:	e8 9b fb ff ff       	call   80201a <syscall>
  80247f:	83 c4 18             	add    $0x18,%esp
	return ;
  802482:	90                   	nop
}
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <sys_rcr2>:
uint32 sys_rcr2()
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 25                	push   $0x25
  802494:	e8 81 fb ff ff       	call   80201a <syscall>
  802499:	83 c4 18             	add    $0x18,%esp
}
  80249c:	c9                   	leave  
  80249d:	c3                   	ret    

0080249e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
  8024a1:	83 ec 04             	sub    $0x4,%esp
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024aa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	50                   	push   %eax
  8024b7:	6a 26                	push   $0x26
  8024b9:	e8 5c fb ff ff       	call   80201a <syscall>
  8024be:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c1:	90                   	nop
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <rsttst>:
void rsttst()
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 28                	push   $0x28
  8024d3:	e8 42 fb ff ff       	call   80201a <syscall>
  8024d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8024db:	90                   	nop
}
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
  8024e1:	83 ec 04             	sub    $0x4,%esp
  8024e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8024e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024ea:	8b 55 18             	mov    0x18(%ebp),%edx
  8024ed:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024f1:	52                   	push   %edx
  8024f2:	50                   	push   %eax
  8024f3:	ff 75 10             	pushl  0x10(%ebp)
  8024f6:	ff 75 0c             	pushl  0xc(%ebp)
  8024f9:	ff 75 08             	pushl  0x8(%ebp)
  8024fc:	6a 27                	push   $0x27
  8024fe:	e8 17 fb ff ff       	call   80201a <syscall>
  802503:	83 c4 18             	add    $0x18,%esp
	return ;
  802506:	90                   	nop
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <chktst>:
void chktst(uint32 n)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	ff 75 08             	pushl  0x8(%ebp)
  802517:	6a 29                	push   $0x29
  802519:	e8 fc fa ff ff       	call   80201a <syscall>
  80251e:	83 c4 18             	add    $0x18,%esp
	return ;
  802521:	90                   	nop
}
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <inctst>:

void inctst()
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 2a                	push   $0x2a
  802533:	e8 e2 fa ff ff       	call   80201a <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
	return ;
  80253b:	90                   	nop
}
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <gettst>:
uint32 gettst()
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 2b                	push   $0x2b
  80254d:	e8 c8 fa ff ff       	call   80201a <syscall>
  802552:	83 c4 18             	add    $0x18,%esp
}
  802555:	c9                   	leave  
  802556:	c3                   	ret    

00802557 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
  80255a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 2c                	push   $0x2c
  802569:	e8 ac fa ff ff       	call   80201a <syscall>
  80256e:	83 c4 18             	add    $0x18,%esp
  802571:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802574:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802578:	75 07                	jne    802581 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80257a:	b8 01 00 00 00       	mov    $0x1,%eax
  80257f:	eb 05                	jmp    802586 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802586:	c9                   	leave  
  802587:	c3                   	ret    

00802588 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802588:	55                   	push   %ebp
  802589:	89 e5                	mov    %esp,%ebp
  80258b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 2c                	push   $0x2c
  80259a:	e8 7b fa ff ff       	call   80201a <syscall>
  80259f:	83 c4 18             	add    $0x18,%esp
  8025a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025a5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025a9:	75 07                	jne    8025b2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b0:	eb 05                	jmp    8025b7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b7:	c9                   	leave  
  8025b8:	c3                   	ret    

008025b9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
  8025bc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 2c                	push   $0x2c
  8025cb:	e8 4a fa ff ff       	call   80201a <syscall>
  8025d0:	83 c4 18             	add    $0x18,%esp
  8025d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025d6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025da:	75 07                	jne    8025e3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e1:	eb 05                	jmp    8025e8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
  8025ed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 2c                	push   $0x2c
  8025fc:	e8 19 fa ff ff       	call   80201a <syscall>
  802601:	83 c4 18             	add    $0x18,%esp
  802604:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802607:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80260b:	75 07                	jne    802614 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80260d:	b8 01 00 00 00       	mov    $0x1,%eax
  802612:	eb 05                	jmp    802619 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802614:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802619:	c9                   	leave  
  80261a:	c3                   	ret    

0080261b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80261b:	55                   	push   %ebp
  80261c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	ff 75 08             	pushl  0x8(%ebp)
  802629:	6a 2d                	push   $0x2d
  80262b:	e8 ea f9 ff ff       	call   80201a <syscall>
  802630:	83 c4 18             	add    $0x18,%esp
	return ;
  802633:	90                   	nop
}
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
  802639:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80263a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80263d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802640:	8b 55 0c             	mov    0xc(%ebp),%edx
  802643:	8b 45 08             	mov    0x8(%ebp),%eax
  802646:	6a 00                	push   $0x0
  802648:	53                   	push   %ebx
  802649:	51                   	push   %ecx
  80264a:	52                   	push   %edx
  80264b:	50                   	push   %eax
  80264c:	6a 2e                	push   $0x2e
  80264e:	e8 c7 f9 ff ff       	call   80201a <syscall>
  802653:	83 c4 18             	add    $0x18,%esp
}
  802656:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80265e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802661:	8b 45 08             	mov    0x8(%ebp),%eax
  802664:	6a 00                	push   $0x0
  802666:	6a 00                	push   $0x0
  802668:	6a 00                	push   $0x0
  80266a:	52                   	push   %edx
  80266b:	50                   	push   %eax
  80266c:	6a 2f                	push   $0x2f
  80266e:	e8 a7 f9 ff ff       	call   80201a <syscall>
  802673:	83 c4 18             	add    $0x18,%esp
}
  802676:	c9                   	leave  
  802677:	c3                   	ret    

00802678 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
  80267b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80267e:	83 ec 0c             	sub    $0xc,%esp
  802681:	68 38 47 80 00       	push   $0x804738
  802686:	e8 d3 e8 ff ff       	call   800f5e <cprintf>
  80268b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80268e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802695:	83 ec 0c             	sub    $0xc,%esp
  802698:	68 64 47 80 00       	push   $0x804764
  80269d:	e8 bc e8 ff ff       	call   800f5e <cprintf>
  8026a2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026a5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026a9:	a1 38 51 80 00       	mov    0x805138,%eax
  8026ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b1:	eb 56                	jmp    802709 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026b7:	74 1c                	je     8026d5 <print_mem_block_lists+0x5d>
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 50 08             	mov    0x8(%eax),%edx
  8026bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c2:	8b 48 08             	mov    0x8(%eax),%ecx
  8026c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cb:	01 c8                	add    %ecx,%eax
  8026cd:	39 c2                	cmp    %eax,%edx
  8026cf:	73 04                	jae    8026d5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026d1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 50 08             	mov    0x8(%eax),%edx
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e1:	01 c2                	add    %eax,%edx
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 40 08             	mov    0x8(%eax),%eax
  8026e9:	83 ec 04             	sub    $0x4,%esp
  8026ec:	52                   	push   %edx
  8026ed:	50                   	push   %eax
  8026ee:	68 79 47 80 00       	push   $0x804779
  8026f3:	e8 66 e8 ff ff       	call   800f5e <cprintf>
  8026f8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802701:	a1 40 51 80 00       	mov    0x805140,%eax
  802706:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802709:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270d:	74 07                	je     802716 <print_mem_block_lists+0x9e>
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 00                	mov    (%eax),%eax
  802714:	eb 05                	jmp    80271b <print_mem_block_lists+0xa3>
  802716:	b8 00 00 00 00       	mov    $0x0,%eax
  80271b:	a3 40 51 80 00       	mov    %eax,0x805140
  802720:	a1 40 51 80 00       	mov    0x805140,%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	75 8a                	jne    8026b3 <print_mem_block_lists+0x3b>
  802729:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272d:	75 84                	jne    8026b3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80272f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802733:	75 10                	jne    802745 <print_mem_block_lists+0xcd>
  802735:	83 ec 0c             	sub    $0xc,%esp
  802738:	68 88 47 80 00       	push   $0x804788
  80273d:	e8 1c e8 ff ff       	call   800f5e <cprintf>
  802742:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802745:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80274c:	83 ec 0c             	sub    $0xc,%esp
  80274f:	68 ac 47 80 00       	push   $0x8047ac
  802754:	e8 05 e8 ff ff       	call   800f5e <cprintf>
  802759:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80275c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802760:	a1 40 50 80 00       	mov    0x805040,%eax
  802765:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802768:	eb 56                	jmp    8027c0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80276a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80276e:	74 1c                	je     80278c <print_mem_block_lists+0x114>
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 50 08             	mov    0x8(%eax),%edx
  802776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802779:	8b 48 08             	mov    0x8(%eax),%ecx
  80277c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277f:	8b 40 0c             	mov    0xc(%eax),%eax
  802782:	01 c8                	add    %ecx,%eax
  802784:	39 c2                	cmp    %eax,%edx
  802786:	73 04                	jae    80278c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802788:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 50 08             	mov    0x8(%eax),%edx
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 40 0c             	mov    0xc(%eax),%eax
  802798:	01 c2                	add    %eax,%edx
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 40 08             	mov    0x8(%eax),%eax
  8027a0:	83 ec 04             	sub    $0x4,%esp
  8027a3:	52                   	push   %edx
  8027a4:	50                   	push   %eax
  8027a5:	68 79 47 80 00       	push   $0x804779
  8027aa:	e8 af e7 ff ff       	call   800f5e <cprintf>
  8027af:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027b8:	a1 48 50 80 00       	mov    0x805048,%eax
  8027bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c4:	74 07                	je     8027cd <print_mem_block_lists+0x155>
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	8b 00                	mov    (%eax),%eax
  8027cb:	eb 05                	jmp    8027d2 <print_mem_block_lists+0x15a>
  8027cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d2:	a3 48 50 80 00       	mov    %eax,0x805048
  8027d7:	a1 48 50 80 00       	mov    0x805048,%eax
  8027dc:	85 c0                	test   %eax,%eax
  8027de:	75 8a                	jne    80276a <print_mem_block_lists+0xf2>
  8027e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e4:	75 84                	jne    80276a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8027e6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027ea:	75 10                	jne    8027fc <print_mem_block_lists+0x184>
  8027ec:	83 ec 0c             	sub    $0xc,%esp
  8027ef:	68 c4 47 80 00       	push   $0x8047c4
  8027f4:	e8 65 e7 ff ff       	call   800f5e <cprintf>
  8027f9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8027fc:	83 ec 0c             	sub    $0xc,%esp
  8027ff:	68 38 47 80 00       	push   $0x804738
  802804:	e8 55 e7 ff ff       	call   800f5e <cprintf>
  802809:	83 c4 10             	add    $0x10,%esp

}
  80280c:	90                   	nop
  80280d:	c9                   	leave  
  80280e:	c3                   	ret    

0080280f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80280f:	55                   	push   %ebp
  802810:	89 e5                	mov    %esp,%ebp
  802812:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802815:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80281c:	00 00 00 
  80281f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802826:	00 00 00 
  802829:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802830:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802833:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80283a:	e9 9e 00 00 00       	jmp    8028dd <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80283f:	a1 50 50 80 00       	mov    0x805050,%eax
  802844:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802847:	c1 e2 04             	shl    $0x4,%edx
  80284a:	01 d0                	add    %edx,%eax
  80284c:	85 c0                	test   %eax,%eax
  80284e:	75 14                	jne    802864 <initialize_MemBlocksList+0x55>
  802850:	83 ec 04             	sub    $0x4,%esp
  802853:	68 ec 47 80 00       	push   $0x8047ec
  802858:	6a 46                	push   $0x46
  80285a:	68 0f 48 80 00       	push   $0x80480f
  80285f:	e8 46 e4 ff ff       	call   800caa <_panic>
  802864:	a1 50 50 80 00       	mov    0x805050,%eax
  802869:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286c:	c1 e2 04             	shl    $0x4,%edx
  80286f:	01 d0                	add    %edx,%eax
  802871:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802877:	89 10                	mov    %edx,(%eax)
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	85 c0                	test   %eax,%eax
  80287d:	74 18                	je     802897 <initialize_MemBlocksList+0x88>
  80287f:	a1 48 51 80 00       	mov    0x805148,%eax
  802884:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80288a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80288d:	c1 e1 04             	shl    $0x4,%ecx
  802890:	01 ca                	add    %ecx,%edx
  802892:	89 50 04             	mov    %edx,0x4(%eax)
  802895:	eb 12                	jmp    8028a9 <initialize_MemBlocksList+0x9a>
  802897:	a1 50 50 80 00       	mov    0x805050,%eax
  80289c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289f:	c1 e2 04             	shl    $0x4,%edx
  8028a2:	01 d0                	add    %edx,%eax
  8028a4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028a9:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b1:	c1 e2 04             	shl    $0x4,%edx
  8028b4:	01 d0                	add    %edx,%eax
  8028b6:	a3 48 51 80 00       	mov    %eax,0x805148
  8028bb:	a1 50 50 80 00       	mov    0x805050,%eax
  8028c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c3:	c1 e2 04             	shl    $0x4,%edx
  8028c6:	01 d0                	add    %edx,%eax
  8028c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cf:	a1 54 51 80 00       	mov    0x805154,%eax
  8028d4:	40                   	inc    %eax
  8028d5:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8028da:	ff 45 f4             	incl   -0xc(%ebp)
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e3:	0f 82 56 ff ff ff    	jb     80283f <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8028e9:	90                   	nop
  8028ea:	c9                   	leave  
  8028eb:	c3                   	ret    

008028ec <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8028ec:	55                   	push   %ebp
  8028ed:	89 e5                	mov    %esp,%ebp
  8028ef:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8028f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f5:	8b 00                	mov    (%eax),%eax
  8028f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028fa:	eb 19                	jmp    802915 <find_block+0x29>
	{
		if(va==point->sva)
  8028fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028ff:	8b 40 08             	mov    0x8(%eax),%eax
  802902:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802905:	75 05                	jne    80290c <find_block+0x20>
		   return point;
  802907:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80290a:	eb 36                	jmp    802942 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	8b 40 08             	mov    0x8(%eax),%eax
  802912:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802915:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802919:	74 07                	je     802922 <find_block+0x36>
  80291b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80291e:	8b 00                	mov    (%eax),%eax
  802920:	eb 05                	jmp    802927 <find_block+0x3b>
  802922:	b8 00 00 00 00       	mov    $0x0,%eax
  802927:	8b 55 08             	mov    0x8(%ebp),%edx
  80292a:	89 42 08             	mov    %eax,0x8(%edx)
  80292d:	8b 45 08             	mov    0x8(%ebp),%eax
  802930:	8b 40 08             	mov    0x8(%eax),%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	75 c5                	jne    8028fc <find_block+0x10>
  802937:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80293b:	75 bf                	jne    8028fc <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80293d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802942:	c9                   	leave  
  802943:	c3                   	ret    

00802944 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802944:	55                   	push   %ebp
  802945:	89 e5                	mov    %esp,%ebp
  802947:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80294a:	a1 40 50 80 00       	mov    0x805040,%eax
  80294f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802952:	a1 44 50 80 00       	mov    0x805044,%eax
  802957:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80295a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802960:	74 24                	je     802986 <insert_sorted_allocList+0x42>
  802962:	8b 45 08             	mov    0x8(%ebp),%eax
  802965:	8b 50 08             	mov    0x8(%eax),%edx
  802968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296b:	8b 40 08             	mov    0x8(%eax),%eax
  80296e:	39 c2                	cmp    %eax,%edx
  802970:	76 14                	jbe    802986 <insert_sorted_allocList+0x42>
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	8b 50 08             	mov    0x8(%eax),%edx
  802978:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297b:	8b 40 08             	mov    0x8(%eax),%eax
  80297e:	39 c2                	cmp    %eax,%edx
  802980:	0f 82 60 01 00 00    	jb     802ae6 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802986:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80298a:	75 65                	jne    8029f1 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80298c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802990:	75 14                	jne    8029a6 <insert_sorted_allocList+0x62>
  802992:	83 ec 04             	sub    $0x4,%esp
  802995:	68 ec 47 80 00       	push   $0x8047ec
  80299a:	6a 6b                	push   $0x6b
  80299c:	68 0f 48 80 00       	push   $0x80480f
  8029a1:	e8 04 e3 ff ff       	call   800caa <_panic>
  8029a6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8029af:	89 10                	mov    %edx,(%eax)
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	8b 00                	mov    (%eax),%eax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	74 0d                	je     8029c7 <insert_sorted_allocList+0x83>
  8029ba:	a1 40 50 80 00       	mov    0x805040,%eax
  8029bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c2:	89 50 04             	mov    %edx,0x4(%eax)
  8029c5:	eb 08                	jmp    8029cf <insert_sorted_allocList+0x8b>
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	a3 44 50 80 00       	mov    %eax,0x805044
  8029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d2:	a3 40 50 80 00       	mov    %eax,0x805040
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029e6:	40                   	inc    %eax
  8029e7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029ec:	e9 dc 01 00 00       	jmp    802bcd <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	8b 50 08             	mov    0x8(%eax),%edx
  8029f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fa:	8b 40 08             	mov    0x8(%eax),%eax
  8029fd:	39 c2                	cmp    %eax,%edx
  8029ff:	77 6c                	ja     802a6d <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802a01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a05:	74 06                	je     802a0d <insert_sorted_allocList+0xc9>
  802a07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a0b:	75 14                	jne    802a21 <insert_sorted_allocList+0xdd>
  802a0d:	83 ec 04             	sub    $0x4,%esp
  802a10:	68 28 48 80 00       	push   $0x804828
  802a15:	6a 6f                	push   $0x6f
  802a17:	68 0f 48 80 00       	push   $0x80480f
  802a1c:	e8 89 e2 ff ff       	call   800caa <_panic>
  802a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a24:	8b 50 04             	mov    0x4(%eax),%edx
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	89 50 04             	mov    %edx,0x4(%eax)
  802a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a33:	89 10                	mov    %edx,(%eax)
  802a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a38:	8b 40 04             	mov    0x4(%eax),%eax
  802a3b:	85 c0                	test   %eax,%eax
  802a3d:	74 0d                	je     802a4c <insert_sorted_allocList+0x108>
  802a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a42:	8b 40 04             	mov    0x4(%eax),%eax
  802a45:	8b 55 08             	mov    0x8(%ebp),%edx
  802a48:	89 10                	mov    %edx,(%eax)
  802a4a:	eb 08                	jmp    802a54 <insert_sorted_allocList+0x110>
  802a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4f:	a3 40 50 80 00       	mov    %eax,0x805040
  802a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a57:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5a:	89 50 04             	mov    %edx,0x4(%eax)
  802a5d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a62:	40                   	inc    %eax
  802a63:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a68:	e9 60 01 00 00       	jmp    802bcd <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	8b 50 08             	mov    0x8(%eax),%edx
  802a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a76:	8b 40 08             	mov    0x8(%eax),%eax
  802a79:	39 c2                	cmp    %eax,%edx
  802a7b:	0f 82 4c 01 00 00    	jb     802bcd <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802a81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a85:	75 14                	jne    802a9b <insert_sorted_allocList+0x157>
  802a87:	83 ec 04             	sub    $0x4,%esp
  802a8a:	68 60 48 80 00       	push   $0x804860
  802a8f:	6a 73                	push   $0x73
  802a91:	68 0f 48 80 00       	push   $0x80480f
  802a96:	e8 0f e2 ff ff       	call   800caa <_panic>
  802a9b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa4:	89 50 04             	mov    %edx,0x4(%eax)
  802aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaa:	8b 40 04             	mov    0x4(%eax),%eax
  802aad:	85 c0                	test   %eax,%eax
  802aaf:	74 0c                	je     802abd <insert_sorted_allocList+0x179>
  802ab1:	a1 44 50 80 00       	mov    0x805044,%eax
  802ab6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab9:	89 10                	mov    %edx,(%eax)
  802abb:	eb 08                	jmp    802ac5 <insert_sorted_allocList+0x181>
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	a3 40 50 80 00       	mov    %eax,0x805040
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	a3 44 50 80 00       	mov    %eax,0x805044
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802adb:	40                   	inc    %eax
  802adc:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ae1:	e9 e7 00 00 00       	jmp    802bcd <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802aec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802af3:	a1 40 50 80 00       	mov    0x805040,%eax
  802af8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802afb:	e9 9d 00 00 00       	jmp    802b9d <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 00                	mov    (%eax),%eax
  802b05:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	8b 50 08             	mov    0x8(%eax),%edx
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 40 08             	mov    0x8(%eax),%eax
  802b14:	39 c2                	cmp    %eax,%edx
  802b16:	76 7d                	jbe    802b95 <insert_sorted_allocList+0x251>
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	8b 50 08             	mov    0x8(%eax),%edx
  802b1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b21:	8b 40 08             	mov    0x8(%eax),%eax
  802b24:	39 c2                	cmp    %eax,%edx
  802b26:	73 6d                	jae    802b95 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802b28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2c:	74 06                	je     802b34 <insert_sorted_allocList+0x1f0>
  802b2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b32:	75 14                	jne    802b48 <insert_sorted_allocList+0x204>
  802b34:	83 ec 04             	sub    $0x4,%esp
  802b37:	68 84 48 80 00       	push   $0x804884
  802b3c:	6a 7f                	push   $0x7f
  802b3e:	68 0f 48 80 00       	push   $0x80480f
  802b43:	e8 62 e1 ff ff       	call   800caa <_panic>
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 10                	mov    (%eax),%edx
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	89 10                	mov    %edx,(%eax)
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	8b 00                	mov    (%eax),%eax
  802b57:	85 c0                	test   %eax,%eax
  802b59:	74 0b                	je     802b66 <insert_sorted_allocList+0x222>
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	8b 00                	mov    (%eax),%eax
  802b60:	8b 55 08             	mov    0x8(%ebp),%edx
  802b63:	89 50 04             	mov    %edx,0x4(%eax)
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6c:	89 10                	mov    %edx,(%eax)
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b74:	89 50 04             	mov    %edx,0x4(%eax)
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	8b 00                	mov    (%eax),%eax
  802b7c:	85 c0                	test   %eax,%eax
  802b7e:	75 08                	jne    802b88 <insert_sorted_allocList+0x244>
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	a3 44 50 80 00       	mov    %eax,0x805044
  802b88:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b8d:	40                   	inc    %eax
  802b8e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802b93:	eb 39                	jmp    802bce <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b95:	a1 48 50 80 00       	mov    0x805048,%eax
  802b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba1:	74 07                	je     802baa <insert_sorted_allocList+0x266>
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 00                	mov    (%eax),%eax
  802ba8:	eb 05                	jmp    802baf <insert_sorted_allocList+0x26b>
  802baa:	b8 00 00 00 00       	mov    $0x0,%eax
  802baf:	a3 48 50 80 00       	mov    %eax,0x805048
  802bb4:	a1 48 50 80 00       	mov    0x805048,%eax
  802bb9:	85 c0                	test   %eax,%eax
  802bbb:	0f 85 3f ff ff ff    	jne    802b00 <insert_sorted_allocList+0x1bc>
  802bc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc5:	0f 85 35 ff ff ff    	jne    802b00 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802bcb:	eb 01                	jmp    802bce <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802bcd:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802bce:	90                   	nop
  802bcf:	c9                   	leave  
  802bd0:	c3                   	ret    

00802bd1 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802bd1:	55                   	push   %ebp
  802bd2:	89 e5                	mov    %esp,%ebp
  802bd4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802bd7:	a1 38 51 80 00       	mov    0x805138,%eax
  802bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bdf:	e9 85 01 00 00       	jmp    802d69 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bea:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bed:	0f 82 6e 01 00 00    	jb     802d61 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bfc:	0f 85 8a 00 00 00    	jne    802c8c <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802c02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c06:	75 17                	jne    802c1f <alloc_block_FF+0x4e>
  802c08:	83 ec 04             	sub    $0x4,%esp
  802c0b:	68 b8 48 80 00       	push   $0x8048b8
  802c10:	68 93 00 00 00       	push   $0x93
  802c15:	68 0f 48 80 00       	push   $0x80480f
  802c1a:	e8 8b e0 ff ff       	call   800caa <_panic>
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	85 c0                	test   %eax,%eax
  802c26:	74 10                	je     802c38 <alloc_block_FF+0x67>
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 00                	mov    (%eax),%eax
  802c2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c30:	8b 52 04             	mov    0x4(%edx),%edx
  802c33:	89 50 04             	mov    %edx,0x4(%eax)
  802c36:	eb 0b                	jmp    802c43 <alloc_block_FF+0x72>
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	8b 40 04             	mov    0x4(%eax),%eax
  802c3e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	8b 40 04             	mov    0x4(%eax),%eax
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	74 0f                	je     802c5c <alloc_block_FF+0x8b>
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 40 04             	mov    0x4(%eax),%eax
  802c53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c56:	8b 12                	mov    (%edx),%edx
  802c58:	89 10                	mov    %edx,(%eax)
  802c5a:	eb 0a                	jmp    802c66 <alloc_block_FF+0x95>
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 00                	mov    (%eax),%eax
  802c61:	a3 38 51 80 00       	mov    %eax,0x805138
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c79:	a1 44 51 80 00       	mov    0x805144,%eax
  802c7e:	48                   	dec    %eax
  802c7f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	e9 10 01 00 00       	jmp    802d9c <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c92:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c95:	0f 86 c6 00 00 00    	jbe    802d61 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c9b:	a1 48 51 80 00       	mov    0x805148,%eax
  802ca0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 50 08             	mov    0x8(%eax),%edx
  802ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cac:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb5:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cbc:	75 17                	jne    802cd5 <alloc_block_FF+0x104>
  802cbe:	83 ec 04             	sub    $0x4,%esp
  802cc1:	68 b8 48 80 00       	push   $0x8048b8
  802cc6:	68 9b 00 00 00       	push   $0x9b
  802ccb:	68 0f 48 80 00       	push   $0x80480f
  802cd0:	e8 d5 df ff ff       	call   800caa <_panic>
  802cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	85 c0                	test   %eax,%eax
  802cdc:	74 10                	je     802cee <alloc_block_FF+0x11d>
  802cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce1:	8b 00                	mov    (%eax),%eax
  802ce3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce6:	8b 52 04             	mov    0x4(%edx),%edx
  802ce9:	89 50 04             	mov    %edx,0x4(%eax)
  802cec:	eb 0b                	jmp    802cf9 <alloc_block_FF+0x128>
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	8b 40 04             	mov    0x4(%eax),%eax
  802cf4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfc:	8b 40 04             	mov    0x4(%eax),%eax
  802cff:	85 c0                	test   %eax,%eax
  802d01:	74 0f                	je     802d12 <alloc_block_FF+0x141>
  802d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d06:	8b 40 04             	mov    0x4(%eax),%eax
  802d09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d0c:	8b 12                	mov    (%edx),%edx
  802d0e:	89 10                	mov    %edx,(%eax)
  802d10:	eb 0a                	jmp    802d1c <alloc_block_FF+0x14b>
  802d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d15:	8b 00                	mov    (%eax),%eax
  802d17:	a3 48 51 80 00       	mov    %eax,0x805148
  802d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2f:	a1 54 51 80 00       	mov    0x805154,%eax
  802d34:	48                   	dec    %eax
  802d35:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 50 08             	mov    0x8(%eax),%edx
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	01 c2                	add    %eax,%edx
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d51:	2b 45 08             	sub    0x8(%ebp),%eax
  802d54:	89 c2                	mov    %eax,%edx
  802d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d59:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5f:	eb 3b                	jmp    802d9c <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802d61:	a1 40 51 80 00       	mov    0x805140,%eax
  802d66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6d:	74 07                	je     802d76 <alloc_block_FF+0x1a5>
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 00                	mov    (%eax),%eax
  802d74:	eb 05                	jmp    802d7b <alloc_block_FF+0x1aa>
  802d76:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7b:	a3 40 51 80 00       	mov    %eax,0x805140
  802d80:	a1 40 51 80 00       	mov    0x805140,%eax
  802d85:	85 c0                	test   %eax,%eax
  802d87:	0f 85 57 fe ff ff    	jne    802be4 <alloc_block_FF+0x13>
  802d8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d91:	0f 85 4d fe ff ff    	jne    802be4 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802d97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d9c:	c9                   	leave  
  802d9d:	c3                   	ret    

00802d9e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802d9e:	55                   	push   %ebp
  802d9f:	89 e5                	mov    %esp,%ebp
  802da1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802da4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802dab:	a1 38 51 80 00       	mov    0x805138,%eax
  802db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db3:	e9 df 00 00 00       	jmp    802e97 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dc1:	0f 82 c8 00 00 00    	jb     802e8f <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dd0:	0f 85 8a 00 00 00    	jne    802e60 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802dd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dda:	75 17                	jne    802df3 <alloc_block_BF+0x55>
  802ddc:	83 ec 04             	sub    $0x4,%esp
  802ddf:	68 b8 48 80 00       	push   $0x8048b8
  802de4:	68 b7 00 00 00       	push   $0xb7
  802de9:	68 0f 48 80 00       	push   $0x80480f
  802dee:	e8 b7 de ff ff       	call   800caa <_panic>
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	8b 00                	mov    (%eax),%eax
  802df8:	85 c0                	test   %eax,%eax
  802dfa:	74 10                	je     802e0c <alloc_block_BF+0x6e>
  802dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dff:	8b 00                	mov    (%eax),%eax
  802e01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e04:	8b 52 04             	mov    0x4(%edx),%edx
  802e07:	89 50 04             	mov    %edx,0x4(%eax)
  802e0a:	eb 0b                	jmp    802e17 <alloc_block_BF+0x79>
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 40 04             	mov    0x4(%eax),%eax
  802e12:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	8b 40 04             	mov    0x4(%eax),%eax
  802e1d:	85 c0                	test   %eax,%eax
  802e1f:	74 0f                	je     802e30 <alloc_block_BF+0x92>
  802e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e24:	8b 40 04             	mov    0x4(%eax),%eax
  802e27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2a:	8b 12                	mov    (%edx),%edx
  802e2c:	89 10                	mov    %edx,(%eax)
  802e2e:	eb 0a                	jmp    802e3a <alloc_block_BF+0x9c>
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	8b 00                	mov    (%eax),%eax
  802e35:	a3 38 51 80 00       	mov    %eax,0x805138
  802e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4d:	a1 44 51 80 00       	mov    0x805144,%eax
  802e52:	48                   	dec    %eax
  802e53:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5b:	e9 4d 01 00 00       	jmp    802fad <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	8b 40 0c             	mov    0xc(%eax),%eax
  802e66:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e69:	76 24                	jbe    802e8f <alloc_block_BF+0xf1>
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e71:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e74:	73 19                	jae    802e8f <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802e76:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e80:	8b 40 0c             	mov    0xc(%eax),%eax
  802e83:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 40 08             	mov    0x8(%eax),%eax
  802e8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802e8f:	a1 40 51 80 00       	mov    0x805140,%eax
  802e94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9b:	74 07                	je     802ea4 <alloc_block_BF+0x106>
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	eb 05                	jmp    802ea9 <alloc_block_BF+0x10b>
  802ea4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea9:	a3 40 51 80 00       	mov    %eax,0x805140
  802eae:	a1 40 51 80 00       	mov    0x805140,%eax
  802eb3:	85 c0                	test   %eax,%eax
  802eb5:	0f 85 fd fe ff ff    	jne    802db8 <alloc_block_BF+0x1a>
  802ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebf:	0f 85 f3 fe ff ff    	jne    802db8 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802ec5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ec9:	0f 84 d9 00 00 00    	je     802fa8 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ecf:	a1 48 51 80 00       	mov    0x805148,%eax
  802ed4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802ed7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eda:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802edd:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802ee0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee6:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802ee9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802eed:	75 17                	jne    802f06 <alloc_block_BF+0x168>
  802eef:	83 ec 04             	sub    $0x4,%esp
  802ef2:	68 b8 48 80 00       	push   $0x8048b8
  802ef7:	68 c7 00 00 00       	push   $0xc7
  802efc:	68 0f 48 80 00       	push   $0x80480f
  802f01:	e8 a4 dd ff ff       	call   800caa <_panic>
  802f06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	85 c0                	test   %eax,%eax
  802f0d:	74 10                	je     802f1f <alloc_block_BF+0x181>
  802f0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f12:	8b 00                	mov    (%eax),%eax
  802f14:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f17:	8b 52 04             	mov    0x4(%edx),%edx
  802f1a:	89 50 04             	mov    %edx,0x4(%eax)
  802f1d:	eb 0b                	jmp    802f2a <alloc_block_BF+0x18c>
  802f1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f22:	8b 40 04             	mov    0x4(%eax),%eax
  802f25:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f2d:	8b 40 04             	mov    0x4(%eax),%eax
  802f30:	85 c0                	test   %eax,%eax
  802f32:	74 0f                	je     802f43 <alloc_block_BF+0x1a5>
  802f34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f37:	8b 40 04             	mov    0x4(%eax),%eax
  802f3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f3d:	8b 12                	mov    (%edx),%edx
  802f3f:	89 10                	mov    %edx,(%eax)
  802f41:	eb 0a                	jmp    802f4d <alloc_block_BF+0x1af>
  802f43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f46:	8b 00                	mov    (%eax),%eax
  802f48:	a3 48 51 80 00       	mov    %eax,0x805148
  802f4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f60:	a1 54 51 80 00       	mov    0x805154,%eax
  802f65:	48                   	dec    %eax
  802f66:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802f6b:	83 ec 08             	sub    $0x8,%esp
  802f6e:	ff 75 ec             	pushl  -0x14(%ebp)
  802f71:	68 38 51 80 00       	push   $0x805138
  802f76:	e8 71 f9 ff ff       	call   8028ec <find_block>
  802f7b:	83 c4 10             	add    $0x10,%esp
  802f7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802f81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f84:	8b 50 08             	mov    0x8(%eax),%edx
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	01 c2                	add    %eax,%edx
  802f8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f8f:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802f92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f95:	8b 40 0c             	mov    0xc(%eax),%eax
  802f98:	2b 45 08             	sub    0x8(%ebp),%eax
  802f9b:	89 c2                	mov    %eax,%edx
  802f9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa0:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa6:	eb 05                	jmp    802fad <alloc_block_BF+0x20f>
	}
	return NULL;
  802fa8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fad:	c9                   	leave  
  802fae:	c3                   	ret    

00802faf <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802faf:	55                   	push   %ebp
  802fb0:	89 e5                	mov    %esp,%ebp
  802fb2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802fb5:	a1 28 50 80 00       	mov    0x805028,%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	0f 85 de 01 00 00    	jne    8031a0 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802fc2:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fca:	e9 9e 01 00 00       	jmp    80316d <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fd8:	0f 82 87 01 00 00    	jb     803165 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe1:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fe7:	0f 85 95 00 00 00    	jne    803082 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802fed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff1:	75 17                	jne    80300a <alloc_block_NF+0x5b>
  802ff3:	83 ec 04             	sub    $0x4,%esp
  802ff6:	68 b8 48 80 00       	push   $0x8048b8
  802ffb:	68 e0 00 00 00       	push   $0xe0
  803000:	68 0f 48 80 00       	push   $0x80480f
  803005:	e8 a0 dc ff ff       	call   800caa <_panic>
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	8b 00                	mov    (%eax),%eax
  80300f:	85 c0                	test   %eax,%eax
  803011:	74 10                	je     803023 <alloc_block_NF+0x74>
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	8b 00                	mov    (%eax),%eax
  803018:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80301b:	8b 52 04             	mov    0x4(%edx),%edx
  80301e:	89 50 04             	mov    %edx,0x4(%eax)
  803021:	eb 0b                	jmp    80302e <alloc_block_NF+0x7f>
  803023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803026:	8b 40 04             	mov    0x4(%eax),%eax
  803029:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803031:	8b 40 04             	mov    0x4(%eax),%eax
  803034:	85 c0                	test   %eax,%eax
  803036:	74 0f                	je     803047 <alloc_block_NF+0x98>
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 40 04             	mov    0x4(%eax),%eax
  80303e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803041:	8b 12                	mov    (%edx),%edx
  803043:	89 10                	mov    %edx,(%eax)
  803045:	eb 0a                	jmp    803051 <alloc_block_NF+0xa2>
  803047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304a:	8b 00                	mov    (%eax),%eax
  80304c:	a3 38 51 80 00       	mov    %eax,0x805138
  803051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803054:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80305a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803064:	a1 44 51 80 00       	mov    0x805144,%eax
  803069:	48                   	dec    %eax
  80306a:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	8b 40 08             	mov    0x8(%eax),%eax
  803075:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80307a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307d:	e9 f8 04 00 00       	jmp    80357a <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803085:	8b 40 0c             	mov    0xc(%eax),%eax
  803088:	3b 45 08             	cmp    0x8(%ebp),%eax
  80308b:	0f 86 d4 00 00 00    	jbe    803165 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803091:	a1 48 51 80 00       	mov    0x805148,%eax
  803096:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	8b 50 08             	mov    0x8(%eax),%edx
  80309f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a2:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8030a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ab:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030b2:	75 17                	jne    8030cb <alloc_block_NF+0x11c>
  8030b4:	83 ec 04             	sub    $0x4,%esp
  8030b7:	68 b8 48 80 00       	push   $0x8048b8
  8030bc:	68 e9 00 00 00       	push   $0xe9
  8030c1:	68 0f 48 80 00       	push   $0x80480f
  8030c6:	e8 df db ff ff       	call   800caa <_panic>
  8030cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ce:	8b 00                	mov    (%eax),%eax
  8030d0:	85 c0                	test   %eax,%eax
  8030d2:	74 10                	je     8030e4 <alloc_block_NF+0x135>
  8030d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030dc:	8b 52 04             	mov    0x4(%edx),%edx
  8030df:	89 50 04             	mov    %edx,0x4(%eax)
  8030e2:	eb 0b                	jmp    8030ef <alloc_block_NF+0x140>
  8030e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f2:	8b 40 04             	mov    0x4(%eax),%eax
  8030f5:	85 c0                	test   %eax,%eax
  8030f7:	74 0f                	je     803108 <alloc_block_NF+0x159>
  8030f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fc:	8b 40 04             	mov    0x4(%eax),%eax
  8030ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803102:	8b 12                	mov    (%edx),%edx
  803104:	89 10                	mov    %edx,(%eax)
  803106:	eb 0a                	jmp    803112 <alloc_block_NF+0x163>
  803108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310b:	8b 00                	mov    (%eax),%eax
  80310d:	a3 48 51 80 00       	mov    %eax,0x805148
  803112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803115:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803125:	a1 54 51 80 00       	mov    0x805154,%eax
  80312a:	48                   	dec    %eax
  80312b:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803133:	8b 40 08             	mov    0x8(%eax),%eax
  803136:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	8b 50 08             	mov    0x8(%eax),%edx
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	01 c2                	add    %eax,%edx
  803146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803149:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	8b 40 0c             	mov    0xc(%eax),%eax
  803152:	2b 45 08             	sub    0x8(%ebp),%eax
  803155:	89 c2                	mov    %eax,%edx
  803157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315a:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80315d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803160:	e9 15 04 00 00       	jmp    80357a <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803165:	a1 40 51 80 00       	mov    0x805140,%eax
  80316a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80316d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803171:	74 07                	je     80317a <alloc_block_NF+0x1cb>
  803173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803176:	8b 00                	mov    (%eax),%eax
  803178:	eb 05                	jmp    80317f <alloc_block_NF+0x1d0>
  80317a:	b8 00 00 00 00       	mov    $0x0,%eax
  80317f:	a3 40 51 80 00       	mov    %eax,0x805140
  803184:	a1 40 51 80 00       	mov    0x805140,%eax
  803189:	85 c0                	test   %eax,%eax
  80318b:	0f 85 3e fe ff ff    	jne    802fcf <alloc_block_NF+0x20>
  803191:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803195:	0f 85 34 fe ff ff    	jne    802fcf <alloc_block_NF+0x20>
  80319b:	e9 d5 03 00 00       	jmp    803575 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031a0:	a1 38 51 80 00       	mov    0x805138,%eax
  8031a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a8:	e9 b1 01 00 00       	jmp    80335e <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b0:	8b 50 08             	mov    0x8(%eax),%edx
  8031b3:	a1 28 50 80 00       	mov    0x805028,%eax
  8031b8:	39 c2                	cmp    %eax,%edx
  8031ba:	0f 82 96 01 00 00    	jb     803356 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8031c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031c9:	0f 82 87 01 00 00    	jb     803356 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8031cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d8:	0f 85 95 00 00 00    	jne    803273 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8031de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e2:	75 17                	jne    8031fb <alloc_block_NF+0x24c>
  8031e4:	83 ec 04             	sub    $0x4,%esp
  8031e7:	68 b8 48 80 00       	push   $0x8048b8
  8031ec:	68 fc 00 00 00       	push   $0xfc
  8031f1:	68 0f 48 80 00       	push   $0x80480f
  8031f6:	e8 af da ff ff       	call   800caa <_panic>
  8031fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fe:	8b 00                	mov    (%eax),%eax
  803200:	85 c0                	test   %eax,%eax
  803202:	74 10                	je     803214 <alloc_block_NF+0x265>
  803204:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803207:	8b 00                	mov    (%eax),%eax
  803209:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80320c:	8b 52 04             	mov    0x4(%edx),%edx
  80320f:	89 50 04             	mov    %edx,0x4(%eax)
  803212:	eb 0b                	jmp    80321f <alloc_block_NF+0x270>
  803214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803217:	8b 40 04             	mov    0x4(%eax),%eax
  80321a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	8b 40 04             	mov    0x4(%eax),%eax
  803225:	85 c0                	test   %eax,%eax
  803227:	74 0f                	je     803238 <alloc_block_NF+0x289>
  803229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322c:	8b 40 04             	mov    0x4(%eax),%eax
  80322f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803232:	8b 12                	mov    (%edx),%edx
  803234:	89 10                	mov    %edx,(%eax)
  803236:	eb 0a                	jmp    803242 <alloc_block_NF+0x293>
  803238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323b:	8b 00                	mov    (%eax),%eax
  80323d:	a3 38 51 80 00       	mov    %eax,0x805138
  803242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803245:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80324b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803255:	a1 44 51 80 00       	mov    0x805144,%eax
  80325a:	48                   	dec    %eax
  80325b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803263:	8b 40 08             	mov    0x8(%eax),%eax
  803266:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80326b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326e:	e9 07 03 00 00       	jmp    80357a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803276:	8b 40 0c             	mov    0xc(%eax),%eax
  803279:	3b 45 08             	cmp    0x8(%ebp),%eax
  80327c:	0f 86 d4 00 00 00    	jbe    803356 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803282:	a1 48 51 80 00       	mov    0x805148,%eax
  803287:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80328a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328d:	8b 50 08             	mov    0x8(%eax),%edx
  803290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803293:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803296:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803299:	8b 55 08             	mov    0x8(%ebp),%edx
  80329c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80329f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032a3:	75 17                	jne    8032bc <alloc_block_NF+0x30d>
  8032a5:	83 ec 04             	sub    $0x4,%esp
  8032a8:	68 b8 48 80 00       	push   $0x8048b8
  8032ad:	68 04 01 00 00       	push   $0x104
  8032b2:	68 0f 48 80 00       	push   $0x80480f
  8032b7:	e8 ee d9 ff ff       	call   800caa <_panic>
  8032bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bf:	8b 00                	mov    (%eax),%eax
  8032c1:	85 c0                	test   %eax,%eax
  8032c3:	74 10                	je     8032d5 <alloc_block_NF+0x326>
  8032c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c8:	8b 00                	mov    (%eax),%eax
  8032ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032cd:	8b 52 04             	mov    0x4(%edx),%edx
  8032d0:	89 50 04             	mov    %edx,0x4(%eax)
  8032d3:	eb 0b                	jmp    8032e0 <alloc_block_NF+0x331>
  8032d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d8:	8b 40 04             	mov    0x4(%eax),%eax
  8032db:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e3:	8b 40 04             	mov    0x4(%eax),%eax
  8032e6:	85 c0                	test   %eax,%eax
  8032e8:	74 0f                	je     8032f9 <alloc_block_NF+0x34a>
  8032ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ed:	8b 40 04             	mov    0x4(%eax),%eax
  8032f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f3:	8b 12                	mov    (%edx),%edx
  8032f5:	89 10                	mov    %edx,(%eax)
  8032f7:	eb 0a                	jmp    803303 <alloc_block_NF+0x354>
  8032f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fc:	8b 00                	mov    (%eax),%eax
  8032fe:	a3 48 51 80 00       	mov    %eax,0x805148
  803303:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803306:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80330c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803316:	a1 54 51 80 00       	mov    0x805154,%eax
  80331b:	48                   	dec    %eax
  80331c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803321:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803324:	8b 40 08             	mov    0x8(%eax),%eax
  803327:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80332c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332f:	8b 50 08             	mov    0x8(%eax),%edx
  803332:	8b 45 08             	mov    0x8(%ebp),%eax
  803335:	01 c2                	add    %eax,%edx
  803337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80333d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803340:	8b 40 0c             	mov    0xc(%eax),%eax
  803343:	2b 45 08             	sub    0x8(%ebp),%eax
  803346:	89 c2                	mov    %eax,%edx
  803348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80334e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803351:	e9 24 02 00 00       	jmp    80357a <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803356:	a1 40 51 80 00       	mov    0x805140,%eax
  80335b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80335e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803362:	74 07                	je     80336b <alloc_block_NF+0x3bc>
  803364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803367:	8b 00                	mov    (%eax),%eax
  803369:	eb 05                	jmp    803370 <alloc_block_NF+0x3c1>
  80336b:	b8 00 00 00 00       	mov    $0x0,%eax
  803370:	a3 40 51 80 00       	mov    %eax,0x805140
  803375:	a1 40 51 80 00       	mov    0x805140,%eax
  80337a:	85 c0                	test   %eax,%eax
  80337c:	0f 85 2b fe ff ff    	jne    8031ad <alloc_block_NF+0x1fe>
  803382:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803386:	0f 85 21 fe ff ff    	jne    8031ad <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80338c:	a1 38 51 80 00       	mov    0x805138,%eax
  803391:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803394:	e9 ae 01 00 00       	jmp    803547 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339c:	8b 50 08             	mov    0x8(%eax),%edx
  80339f:	a1 28 50 80 00       	mov    0x805028,%eax
  8033a4:	39 c2                	cmp    %eax,%edx
  8033a6:	0f 83 93 01 00 00    	jae    80353f <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8033ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033af:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033b5:	0f 82 84 01 00 00    	jb     80353f <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8033bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033be:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033c4:	0f 85 95 00 00 00    	jne    80345f <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8033ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ce:	75 17                	jne    8033e7 <alloc_block_NF+0x438>
  8033d0:	83 ec 04             	sub    $0x4,%esp
  8033d3:	68 b8 48 80 00       	push   $0x8048b8
  8033d8:	68 14 01 00 00       	push   $0x114
  8033dd:	68 0f 48 80 00       	push   $0x80480f
  8033e2:	e8 c3 d8 ff ff       	call   800caa <_panic>
  8033e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ea:	8b 00                	mov    (%eax),%eax
  8033ec:	85 c0                	test   %eax,%eax
  8033ee:	74 10                	je     803400 <alloc_block_NF+0x451>
  8033f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f3:	8b 00                	mov    (%eax),%eax
  8033f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033f8:	8b 52 04             	mov    0x4(%edx),%edx
  8033fb:	89 50 04             	mov    %edx,0x4(%eax)
  8033fe:	eb 0b                	jmp    80340b <alloc_block_NF+0x45c>
  803400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803403:	8b 40 04             	mov    0x4(%eax),%eax
  803406:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80340b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340e:	8b 40 04             	mov    0x4(%eax),%eax
  803411:	85 c0                	test   %eax,%eax
  803413:	74 0f                	je     803424 <alloc_block_NF+0x475>
  803415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803418:	8b 40 04             	mov    0x4(%eax),%eax
  80341b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80341e:	8b 12                	mov    (%edx),%edx
  803420:	89 10                	mov    %edx,(%eax)
  803422:	eb 0a                	jmp    80342e <alloc_block_NF+0x47f>
  803424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803427:	8b 00                	mov    (%eax),%eax
  803429:	a3 38 51 80 00       	mov    %eax,0x805138
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803441:	a1 44 51 80 00       	mov    0x805144,%eax
  803446:	48                   	dec    %eax
  803447:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80344c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344f:	8b 40 08             	mov    0x8(%eax),%eax
  803452:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345a:	e9 1b 01 00 00       	jmp    80357a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80345f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803462:	8b 40 0c             	mov    0xc(%eax),%eax
  803465:	3b 45 08             	cmp    0x8(%ebp),%eax
  803468:	0f 86 d1 00 00 00    	jbe    80353f <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80346e:	a1 48 51 80 00       	mov    0x805148,%eax
  803473:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803479:	8b 50 08             	mov    0x8(%eax),%edx
  80347c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80347f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803482:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803485:	8b 55 08             	mov    0x8(%ebp),%edx
  803488:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80348b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80348f:	75 17                	jne    8034a8 <alloc_block_NF+0x4f9>
  803491:	83 ec 04             	sub    $0x4,%esp
  803494:	68 b8 48 80 00       	push   $0x8048b8
  803499:	68 1c 01 00 00       	push   $0x11c
  80349e:	68 0f 48 80 00       	push   $0x80480f
  8034a3:	e8 02 d8 ff ff       	call   800caa <_panic>
  8034a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ab:	8b 00                	mov    (%eax),%eax
  8034ad:	85 c0                	test   %eax,%eax
  8034af:	74 10                	je     8034c1 <alloc_block_NF+0x512>
  8034b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b4:	8b 00                	mov    (%eax),%eax
  8034b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034b9:	8b 52 04             	mov    0x4(%edx),%edx
  8034bc:	89 50 04             	mov    %edx,0x4(%eax)
  8034bf:	eb 0b                	jmp    8034cc <alloc_block_NF+0x51d>
  8034c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c4:	8b 40 04             	mov    0x4(%eax),%eax
  8034c7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034cf:	8b 40 04             	mov    0x4(%eax),%eax
  8034d2:	85 c0                	test   %eax,%eax
  8034d4:	74 0f                	je     8034e5 <alloc_block_NF+0x536>
  8034d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d9:	8b 40 04             	mov    0x4(%eax),%eax
  8034dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034df:	8b 12                	mov    (%edx),%edx
  8034e1:	89 10                	mov    %edx,(%eax)
  8034e3:	eb 0a                	jmp    8034ef <alloc_block_NF+0x540>
  8034e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e8:	8b 00                	mov    (%eax),%eax
  8034ea:	a3 48 51 80 00       	mov    %eax,0x805148
  8034ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803502:	a1 54 51 80 00       	mov    0x805154,%eax
  803507:	48                   	dec    %eax
  803508:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80350d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803510:	8b 40 08             	mov    0x8(%eax),%eax
  803513:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351b:	8b 50 08             	mov    0x8(%eax),%edx
  80351e:	8b 45 08             	mov    0x8(%ebp),%eax
  803521:	01 c2                	add    %eax,%edx
  803523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803526:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352c:	8b 40 0c             	mov    0xc(%eax),%eax
  80352f:	2b 45 08             	sub    0x8(%ebp),%eax
  803532:	89 c2                	mov    %eax,%edx
  803534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803537:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80353a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80353d:	eb 3b                	jmp    80357a <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80353f:	a1 40 51 80 00       	mov    0x805140,%eax
  803544:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803547:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80354b:	74 07                	je     803554 <alloc_block_NF+0x5a5>
  80354d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803550:	8b 00                	mov    (%eax),%eax
  803552:	eb 05                	jmp    803559 <alloc_block_NF+0x5aa>
  803554:	b8 00 00 00 00       	mov    $0x0,%eax
  803559:	a3 40 51 80 00       	mov    %eax,0x805140
  80355e:	a1 40 51 80 00       	mov    0x805140,%eax
  803563:	85 c0                	test   %eax,%eax
  803565:	0f 85 2e fe ff ff    	jne    803399 <alloc_block_NF+0x3ea>
  80356b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80356f:	0f 85 24 fe ff ff    	jne    803399 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803575:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80357a:	c9                   	leave  
  80357b:	c3                   	ret    

0080357c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80357c:	55                   	push   %ebp
  80357d:	89 e5                	mov    %esp,%ebp
  80357f:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803582:	a1 38 51 80 00       	mov    0x805138,%eax
  803587:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80358a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80358f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803592:	a1 38 51 80 00       	mov    0x805138,%eax
  803597:	85 c0                	test   %eax,%eax
  803599:	74 14                	je     8035af <insert_sorted_with_merge_freeList+0x33>
  80359b:	8b 45 08             	mov    0x8(%ebp),%eax
  80359e:	8b 50 08             	mov    0x8(%eax),%edx
  8035a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a4:	8b 40 08             	mov    0x8(%eax),%eax
  8035a7:	39 c2                	cmp    %eax,%edx
  8035a9:	0f 87 9b 01 00 00    	ja     80374a <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8035af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035b3:	75 17                	jne    8035cc <insert_sorted_with_merge_freeList+0x50>
  8035b5:	83 ec 04             	sub    $0x4,%esp
  8035b8:	68 ec 47 80 00       	push   $0x8047ec
  8035bd:	68 38 01 00 00       	push   $0x138
  8035c2:	68 0f 48 80 00       	push   $0x80480f
  8035c7:	e8 de d6 ff ff       	call   800caa <_panic>
  8035cc:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8035d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d5:	89 10                	mov    %edx,(%eax)
  8035d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035da:	8b 00                	mov    (%eax),%eax
  8035dc:	85 c0                	test   %eax,%eax
  8035de:	74 0d                	je     8035ed <insert_sorted_with_merge_freeList+0x71>
  8035e0:	a1 38 51 80 00       	mov    0x805138,%eax
  8035e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e8:	89 50 04             	mov    %edx,0x4(%eax)
  8035eb:	eb 08                	jmp    8035f5 <insert_sorted_with_merge_freeList+0x79>
  8035ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f8:	a3 38 51 80 00       	mov    %eax,0x805138
  8035fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803600:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803607:	a1 44 51 80 00       	mov    0x805144,%eax
  80360c:	40                   	inc    %eax
  80360d:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803612:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803616:	0f 84 a8 06 00 00    	je     803cc4 <insert_sorted_with_merge_freeList+0x748>
  80361c:	8b 45 08             	mov    0x8(%ebp),%eax
  80361f:	8b 50 08             	mov    0x8(%eax),%edx
  803622:	8b 45 08             	mov    0x8(%ebp),%eax
  803625:	8b 40 0c             	mov    0xc(%eax),%eax
  803628:	01 c2                	add    %eax,%edx
  80362a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80362d:	8b 40 08             	mov    0x8(%eax),%eax
  803630:	39 c2                	cmp    %eax,%edx
  803632:	0f 85 8c 06 00 00    	jne    803cc4 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803638:	8b 45 08             	mov    0x8(%ebp),%eax
  80363b:	8b 50 0c             	mov    0xc(%eax),%edx
  80363e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803641:	8b 40 0c             	mov    0xc(%eax),%eax
  803644:	01 c2                	add    %eax,%edx
  803646:	8b 45 08             	mov    0x8(%ebp),%eax
  803649:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80364c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803650:	75 17                	jne    803669 <insert_sorted_with_merge_freeList+0xed>
  803652:	83 ec 04             	sub    $0x4,%esp
  803655:	68 b8 48 80 00       	push   $0x8048b8
  80365a:	68 3c 01 00 00       	push   $0x13c
  80365f:	68 0f 48 80 00       	push   $0x80480f
  803664:	e8 41 d6 ff ff       	call   800caa <_panic>
  803669:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80366c:	8b 00                	mov    (%eax),%eax
  80366e:	85 c0                	test   %eax,%eax
  803670:	74 10                	je     803682 <insert_sorted_with_merge_freeList+0x106>
  803672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803675:	8b 00                	mov    (%eax),%eax
  803677:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80367a:	8b 52 04             	mov    0x4(%edx),%edx
  80367d:	89 50 04             	mov    %edx,0x4(%eax)
  803680:	eb 0b                	jmp    80368d <insert_sorted_with_merge_freeList+0x111>
  803682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803685:	8b 40 04             	mov    0x4(%eax),%eax
  803688:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80368d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803690:	8b 40 04             	mov    0x4(%eax),%eax
  803693:	85 c0                	test   %eax,%eax
  803695:	74 0f                	je     8036a6 <insert_sorted_with_merge_freeList+0x12a>
  803697:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369a:	8b 40 04             	mov    0x4(%eax),%eax
  80369d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036a0:	8b 12                	mov    (%edx),%edx
  8036a2:	89 10                	mov    %edx,(%eax)
  8036a4:	eb 0a                	jmp    8036b0 <insert_sorted_with_merge_freeList+0x134>
  8036a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a9:	8b 00                	mov    (%eax),%eax
  8036ab:	a3 38 51 80 00       	mov    %eax,0x805138
  8036b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c3:	a1 44 51 80 00       	mov    0x805144,%eax
  8036c8:	48                   	dec    %eax
  8036c9:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8036ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8036d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036db:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8036e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036e6:	75 17                	jne    8036ff <insert_sorted_with_merge_freeList+0x183>
  8036e8:	83 ec 04             	sub    $0x4,%esp
  8036eb:	68 ec 47 80 00       	push   $0x8047ec
  8036f0:	68 3f 01 00 00       	push   $0x13f
  8036f5:	68 0f 48 80 00       	push   $0x80480f
  8036fa:	e8 ab d5 ff ff       	call   800caa <_panic>
  8036ff:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803708:	89 10                	mov    %edx,(%eax)
  80370a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80370d:	8b 00                	mov    (%eax),%eax
  80370f:	85 c0                	test   %eax,%eax
  803711:	74 0d                	je     803720 <insert_sorted_with_merge_freeList+0x1a4>
  803713:	a1 48 51 80 00       	mov    0x805148,%eax
  803718:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80371b:	89 50 04             	mov    %edx,0x4(%eax)
  80371e:	eb 08                	jmp    803728 <insert_sorted_with_merge_freeList+0x1ac>
  803720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803723:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803728:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372b:	a3 48 51 80 00       	mov    %eax,0x805148
  803730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803733:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373a:	a1 54 51 80 00       	mov    0x805154,%eax
  80373f:	40                   	inc    %eax
  803740:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803745:	e9 7a 05 00 00       	jmp    803cc4 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80374a:	8b 45 08             	mov    0x8(%ebp),%eax
  80374d:	8b 50 08             	mov    0x8(%eax),%edx
  803750:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803753:	8b 40 08             	mov    0x8(%eax),%eax
  803756:	39 c2                	cmp    %eax,%edx
  803758:	0f 82 14 01 00 00    	jb     803872 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80375e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803761:	8b 50 08             	mov    0x8(%eax),%edx
  803764:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803767:	8b 40 0c             	mov    0xc(%eax),%eax
  80376a:	01 c2                	add    %eax,%edx
  80376c:	8b 45 08             	mov    0x8(%ebp),%eax
  80376f:	8b 40 08             	mov    0x8(%eax),%eax
  803772:	39 c2                	cmp    %eax,%edx
  803774:	0f 85 90 00 00 00    	jne    80380a <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80377a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80377d:	8b 50 0c             	mov    0xc(%eax),%edx
  803780:	8b 45 08             	mov    0x8(%ebp),%eax
  803783:	8b 40 0c             	mov    0xc(%eax),%eax
  803786:	01 c2                	add    %eax,%edx
  803788:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80378b:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80378e:	8b 45 08             	mov    0x8(%ebp),%eax
  803791:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803798:	8b 45 08             	mov    0x8(%ebp),%eax
  80379b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037a6:	75 17                	jne    8037bf <insert_sorted_with_merge_freeList+0x243>
  8037a8:	83 ec 04             	sub    $0x4,%esp
  8037ab:	68 ec 47 80 00       	push   $0x8047ec
  8037b0:	68 49 01 00 00       	push   $0x149
  8037b5:	68 0f 48 80 00       	push   $0x80480f
  8037ba:	e8 eb d4 ff ff       	call   800caa <_panic>
  8037bf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c8:	89 10                	mov    %edx,(%eax)
  8037ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cd:	8b 00                	mov    (%eax),%eax
  8037cf:	85 c0                	test   %eax,%eax
  8037d1:	74 0d                	je     8037e0 <insert_sorted_with_merge_freeList+0x264>
  8037d3:	a1 48 51 80 00       	mov    0x805148,%eax
  8037d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8037db:	89 50 04             	mov    %edx,0x4(%eax)
  8037de:	eb 08                	jmp    8037e8 <insert_sorted_with_merge_freeList+0x26c>
  8037e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037eb:	a3 48 51 80 00       	mov    %eax,0x805148
  8037f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037fa:	a1 54 51 80 00       	mov    0x805154,%eax
  8037ff:	40                   	inc    %eax
  803800:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803805:	e9 bb 04 00 00       	jmp    803cc5 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80380a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80380e:	75 17                	jne    803827 <insert_sorted_with_merge_freeList+0x2ab>
  803810:	83 ec 04             	sub    $0x4,%esp
  803813:	68 60 48 80 00       	push   $0x804860
  803818:	68 4c 01 00 00       	push   $0x14c
  80381d:	68 0f 48 80 00       	push   $0x80480f
  803822:	e8 83 d4 ff ff       	call   800caa <_panic>
  803827:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80382d:	8b 45 08             	mov    0x8(%ebp),%eax
  803830:	89 50 04             	mov    %edx,0x4(%eax)
  803833:	8b 45 08             	mov    0x8(%ebp),%eax
  803836:	8b 40 04             	mov    0x4(%eax),%eax
  803839:	85 c0                	test   %eax,%eax
  80383b:	74 0c                	je     803849 <insert_sorted_with_merge_freeList+0x2cd>
  80383d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803842:	8b 55 08             	mov    0x8(%ebp),%edx
  803845:	89 10                	mov    %edx,(%eax)
  803847:	eb 08                	jmp    803851 <insert_sorted_with_merge_freeList+0x2d5>
  803849:	8b 45 08             	mov    0x8(%ebp),%eax
  80384c:	a3 38 51 80 00       	mov    %eax,0x805138
  803851:	8b 45 08             	mov    0x8(%ebp),%eax
  803854:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803859:	8b 45 08             	mov    0x8(%ebp),%eax
  80385c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803862:	a1 44 51 80 00       	mov    0x805144,%eax
  803867:	40                   	inc    %eax
  803868:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80386d:	e9 53 04 00 00       	jmp    803cc5 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803872:	a1 38 51 80 00       	mov    0x805138,%eax
  803877:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80387a:	e9 15 04 00 00       	jmp    803c94 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80387f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803882:	8b 00                	mov    (%eax),%eax
  803884:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803887:	8b 45 08             	mov    0x8(%ebp),%eax
  80388a:	8b 50 08             	mov    0x8(%eax),%edx
  80388d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803890:	8b 40 08             	mov    0x8(%eax),%eax
  803893:	39 c2                	cmp    %eax,%edx
  803895:	0f 86 f1 03 00 00    	jbe    803c8c <insert_sorted_with_merge_freeList+0x710>
  80389b:	8b 45 08             	mov    0x8(%ebp),%eax
  80389e:	8b 50 08             	mov    0x8(%eax),%edx
  8038a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a4:	8b 40 08             	mov    0x8(%eax),%eax
  8038a7:	39 c2                	cmp    %eax,%edx
  8038a9:	0f 83 dd 03 00 00    	jae    803c8c <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8038af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b2:	8b 50 08             	mov    0x8(%eax),%edx
  8038b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8038bb:	01 c2                	add    %eax,%edx
  8038bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c0:	8b 40 08             	mov    0x8(%eax),%eax
  8038c3:	39 c2                	cmp    %eax,%edx
  8038c5:	0f 85 b9 01 00 00    	jne    803a84 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8038cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ce:	8b 50 08             	mov    0x8(%eax),%edx
  8038d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8038d7:	01 c2                	add    %eax,%edx
  8038d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038dc:	8b 40 08             	mov    0x8(%eax),%eax
  8038df:	39 c2                	cmp    %eax,%edx
  8038e1:	0f 85 0d 01 00 00    	jne    8039f4 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8038e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ea:	8b 50 0c             	mov    0xc(%eax),%edx
  8038ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8038f3:	01 c2                	add    %eax,%edx
  8038f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f8:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8038fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038ff:	75 17                	jne    803918 <insert_sorted_with_merge_freeList+0x39c>
  803901:	83 ec 04             	sub    $0x4,%esp
  803904:	68 b8 48 80 00       	push   $0x8048b8
  803909:	68 5c 01 00 00       	push   $0x15c
  80390e:	68 0f 48 80 00       	push   $0x80480f
  803913:	e8 92 d3 ff ff       	call   800caa <_panic>
  803918:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391b:	8b 00                	mov    (%eax),%eax
  80391d:	85 c0                	test   %eax,%eax
  80391f:	74 10                	je     803931 <insert_sorted_with_merge_freeList+0x3b5>
  803921:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803924:	8b 00                	mov    (%eax),%eax
  803926:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803929:	8b 52 04             	mov    0x4(%edx),%edx
  80392c:	89 50 04             	mov    %edx,0x4(%eax)
  80392f:	eb 0b                	jmp    80393c <insert_sorted_with_merge_freeList+0x3c0>
  803931:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803934:	8b 40 04             	mov    0x4(%eax),%eax
  803937:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80393c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80393f:	8b 40 04             	mov    0x4(%eax),%eax
  803942:	85 c0                	test   %eax,%eax
  803944:	74 0f                	je     803955 <insert_sorted_with_merge_freeList+0x3d9>
  803946:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803949:	8b 40 04             	mov    0x4(%eax),%eax
  80394c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80394f:	8b 12                	mov    (%edx),%edx
  803951:	89 10                	mov    %edx,(%eax)
  803953:	eb 0a                	jmp    80395f <insert_sorted_with_merge_freeList+0x3e3>
  803955:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803958:	8b 00                	mov    (%eax),%eax
  80395a:	a3 38 51 80 00       	mov    %eax,0x805138
  80395f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803962:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803968:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803972:	a1 44 51 80 00       	mov    0x805144,%eax
  803977:	48                   	dec    %eax
  803978:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80397d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803980:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803987:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803991:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803995:	75 17                	jne    8039ae <insert_sorted_with_merge_freeList+0x432>
  803997:	83 ec 04             	sub    $0x4,%esp
  80399a:	68 ec 47 80 00       	push   $0x8047ec
  80399f:	68 5f 01 00 00       	push   $0x15f
  8039a4:	68 0f 48 80 00       	push   $0x80480f
  8039a9:	e8 fc d2 ff ff       	call   800caa <_panic>
  8039ae:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b7:	89 10                	mov    %edx,(%eax)
  8039b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039bc:	8b 00                	mov    (%eax),%eax
  8039be:	85 c0                	test   %eax,%eax
  8039c0:	74 0d                	je     8039cf <insert_sorted_with_merge_freeList+0x453>
  8039c2:	a1 48 51 80 00       	mov    0x805148,%eax
  8039c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039ca:	89 50 04             	mov    %edx,0x4(%eax)
  8039cd:	eb 08                	jmp    8039d7 <insert_sorted_with_merge_freeList+0x45b>
  8039cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039da:	a3 48 51 80 00       	mov    %eax,0x805148
  8039df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039e9:	a1 54 51 80 00       	mov    0x805154,%eax
  8039ee:	40                   	inc    %eax
  8039ef:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8039f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f7:	8b 50 0c             	mov    0xc(%eax),%edx
  8039fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803a00:	01 c2                	add    %eax,%edx
  803a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a05:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803a08:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803a12:	8b 45 08             	mov    0x8(%ebp),%eax
  803a15:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a20:	75 17                	jne    803a39 <insert_sorted_with_merge_freeList+0x4bd>
  803a22:	83 ec 04             	sub    $0x4,%esp
  803a25:	68 ec 47 80 00       	push   $0x8047ec
  803a2a:	68 64 01 00 00       	push   $0x164
  803a2f:	68 0f 48 80 00       	push   $0x80480f
  803a34:	e8 71 d2 ff ff       	call   800caa <_panic>
  803a39:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a42:	89 10                	mov    %edx,(%eax)
  803a44:	8b 45 08             	mov    0x8(%ebp),%eax
  803a47:	8b 00                	mov    (%eax),%eax
  803a49:	85 c0                	test   %eax,%eax
  803a4b:	74 0d                	je     803a5a <insert_sorted_with_merge_freeList+0x4de>
  803a4d:	a1 48 51 80 00       	mov    0x805148,%eax
  803a52:	8b 55 08             	mov    0x8(%ebp),%edx
  803a55:	89 50 04             	mov    %edx,0x4(%eax)
  803a58:	eb 08                	jmp    803a62 <insert_sorted_with_merge_freeList+0x4e6>
  803a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a62:	8b 45 08             	mov    0x8(%ebp),%eax
  803a65:	a3 48 51 80 00       	mov    %eax,0x805148
  803a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a74:	a1 54 51 80 00       	mov    0x805154,%eax
  803a79:	40                   	inc    %eax
  803a7a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a7f:	e9 41 02 00 00       	jmp    803cc5 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803a84:	8b 45 08             	mov    0x8(%ebp),%eax
  803a87:	8b 50 08             	mov    0x8(%eax),%edx
  803a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8d:	8b 40 0c             	mov    0xc(%eax),%eax
  803a90:	01 c2                	add    %eax,%edx
  803a92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a95:	8b 40 08             	mov    0x8(%eax),%eax
  803a98:	39 c2                	cmp    %eax,%edx
  803a9a:	0f 85 7c 01 00 00    	jne    803c1c <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803aa0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803aa4:	74 06                	je     803aac <insert_sorted_with_merge_freeList+0x530>
  803aa6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803aaa:	75 17                	jne    803ac3 <insert_sorted_with_merge_freeList+0x547>
  803aac:	83 ec 04             	sub    $0x4,%esp
  803aaf:	68 28 48 80 00       	push   $0x804828
  803ab4:	68 69 01 00 00       	push   $0x169
  803ab9:	68 0f 48 80 00       	push   $0x80480f
  803abe:	e8 e7 d1 ff ff       	call   800caa <_panic>
  803ac3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac6:	8b 50 04             	mov    0x4(%eax),%edx
  803ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  803acc:	89 50 04             	mov    %edx,0x4(%eax)
  803acf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ad5:	89 10                	mov    %edx,(%eax)
  803ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ada:	8b 40 04             	mov    0x4(%eax),%eax
  803add:	85 c0                	test   %eax,%eax
  803adf:	74 0d                	je     803aee <insert_sorted_with_merge_freeList+0x572>
  803ae1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae4:	8b 40 04             	mov    0x4(%eax),%eax
  803ae7:	8b 55 08             	mov    0x8(%ebp),%edx
  803aea:	89 10                	mov    %edx,(%eax)
  803aec:	eb 08                	jmp    803af6 <insert_sorted_with_merge_freeList+0x57a>
  803aee:	8b 45 08             	mov    0x8(%ebp),%eax
  803af1:	a3 38 51 80 00       	mov    %eax,0x805138
  803af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803af9:	8b 55 08             	mov    0x8(%ebp),%edx
  803afc:	89 50 04             	mov    %edx,0x4(%eax)
  803aff:	a1 44 51 80 00       	mov    0x805144,%eax
  803b04:	40                   	inc    %eax
  803b05:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0d:	8b 50 0c             	mov    0xc(%eax),%edx
  803b10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b13:	8b 40 0c             	mov    0xc(%eax),%eax
  803b16:	01 c2                	add    %eax,%edx
  803b18:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803b1e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b22:	75 17                	jne    803b3b <insert_sorted_with_merge_freeList+0x5bf>
  803b24:	83 ec 04             	sub    $0x4,%esp
  803b27:	68 b8 48 80 00       	push   $0x8048b8
  803b2c:	68 6b 01 00 00       	push   $0x16b
  803b31:	68 0f 48 80 00       	push   $0x80480f
  803b36:	e8 6f d1 ff ff       	call   800caa <_panic>
  803b3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b3e:	8b 00                	mov    (%eax),%eax
  803b40:	85 c0                	test   %eax,%eax
  803b42:	74 10                	je     803b54 <insert_sorted_with_merge_freeList+0x5d8>
  803b44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b47:	8b 00                	mov    (%eax),%eax
  803b49:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b4c:	8b 52 04             	mov    0x4(%edx),%edx
  803b4f:	89 50 04             	mov    %edx,0x4(%eax)
  803b52:	eb 0b                	jmp    803b5f <insert_sorted_with_merge_freeList+0x5e3>
  803b54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b57:	8b 40 04             	mov    0x4(%eax),%eax
  803b5a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b62:	8b 40 04             	mov    0x4(%eax),%eax
  803b65:	85 c0                	test   %eax,%eax
  803b67:	74 0f                	je     803b78 <insert_sorted_with_merge_freeList+0x5fc>
  803b69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b6c:	8b 40 04             	mov    0x4(%eax),%eax
  803b6f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b72:	8b 12                	mov    (%edx),%edx
  803b74:	89 10                	mov    %edx,(%eax)
  803b76:	eb 0a                	jmp    803b82 <insert_sorted_with_merge_freeList+0x606>
  803b78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b7b:	8b 00                	mov    (%eax),%eax
  803b7d:	a3 38 51 80 00       	mov    %eax,0x805138
  803b82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b95:	a1 44 51 80 00       	mov    0x805144,%eax
  803b9a:	48                   	dec    %eax
  803b9b:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803ba0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803baa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bad:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803bb4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bb8:	75 17                	jne    803bd1 <insert_sorted_with_merge_freeList+0x655>
  803bba:	83 ec 04             	sub    $0x4,%esp
  803bbd:	68 ec 47 80 00       	push   $0x8047ec
  803bc2:	68 6e 01 00 00       	push   $0x16e
  803bc7:	68 0f 48 80 00       	push   $0x80480f
  803bcc:	e8 d9 d0 ff ff       	call   800caa <_panic>
  803bd1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803bd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bda:	89 10                	mov    %edx,(%eax)
  803bdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bdf:	8b 00                	mov    (%eax),%eax
  803be1:	85 c0                	test   %eax,%eax
  803be3:	74 0d                	je     803bf2 <insert_sorted_with_merge_freeList+0x676>
  803be5:	a1 48 51 80 00       	mov    0x805148,%eax
  803bea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bed:	89 50 04             	mov    %edx,0x4(%eax)
  803bf0:	eb 08                	jmp    803bfa <insert_sorted_with_merge_freeList+0x67e>
  803bf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bf5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803bfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bfd:	a3 48 51 80 00       	mov    %eax,0x805148
  803c02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c0c:	a1 54 51 80 00       	mov    0x805154,%eax
  803c11:	40                   	inc    %eax
  803c12:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c17:	e9 a9 00 00 00       	jmp    803cc5 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803c1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c20:	74 06                	je     803c28 <insert_sorted_with_merge_freeList+0x6ac>
  803c22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c26:	75 17                	jne    803c3f <insert_sorted_with_merge_freeList+0x6c3>
  803c28:	83 ec 04             	sub    $0x4,%esp
  803c2b:	68 84 48 80 00       	push   $0x804884
  803c30:	68 73 01 00 00       	push   $0x173
  803c35:	68 0f 48 80 00       	push   $0x80480f
  803c3a:	e8 6b d0 ff ff       	call   800caa <_panic>
  803c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c42:	8b 10                	mov    (%eax),%edx
  803c44:	8b 45 08             	mov    0x8(%ebp),%eax
  803c47:	89 10                	mov    %edx,(%eax)
  803c49:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4c:	8b 00                	mov    (%eax),%eax
  803c4e:	85 c0                	test   %eax,%eax
  803c50:	74 0b                	je     803c5d <insert_sorted_with_merge_freeList+0x6e1>
  803c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c55:	8b 00                	mov    (%eax),%eax
  803c57:	8b 55 08             	mov    0x8(%ebp),%edx
  803c5a:	89 50 04             	mov    %edx,0x4(%eax)
  803c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c60:	8b 55 08             	mov    0x8(%ebp),%edx
  803c63:	89 10                	mov    %edx,(%eax)
  803c65:	8b 45 08             	mov    0x8(%ebp),%eax
  803c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c6b:	89 50 04             	mov    %edx,0x4(%eax)
  803c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c71:	8b 00                	mov    (%eax),%eax
  803c73:	85 c0                	test   %eax,%eax
  803c75:	75 08                	jne    803c7f <insert_sorted_with_merge_freeList+0x703>
  803c77:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c7f:	a1 44 51 80 00       	mov    0x805144,%eax
  803c84:	40                   	inc    %eax
  803c85:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803c8a:	eb 39                	jmp    803cc5 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803c8c:	a1 40 51 80 00       	mov    0x805140,%eax
  803c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c98:	74 07                	je     803ca1 <insert_sorted_with_merge_freeList+0x725>
  803c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9d:	8b 00                	mov    (%eax),%eax
  803c9f:	eb 05                	jmp    803ca6 <insert_sorted_with_merge_freeList+0x72a>
  803ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca6:	a3 40 51 80 00       	mov    %eax,0x805140
  803cab:	a1 40 51 80 00       	mov    0x805140,%eax
  803cb0:	85 c0                	test   %eax,%eax
  803cb2:	0f 85 c7 fb ff ff    	jne    80387f <insert_sorted_with_merge_freeList+0x303>
  803cb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cbc:	0f 85 bd fb ff ff    	jne    80387f <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803cc2:	eb 01                	jmp    803cc5 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803cc4:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803cc5:	90                   	nop
  803cc6:	c9                   	leave  
  803cc7:	c3                   	ret    

00803cc8 <__udivdi3>:
  803cc8:	55                   	push   %ebp
  803cc9:	57                   	push   %edi
  803cca:	56                   	push   %esi
  803ccb:	53                   	push   %ebx
  803ccc:	83 ec 1c             	sub    $0x1c,%esp
  803ccf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803cd3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803cd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cdb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803cdf:	89 ca                	mov    %ecx,%edx
  803ce1:	89 f8                	mov    %edi,%eax
  803ce3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ce7:	85 f6                	test   %esi,%esi
  803ce9:	75 2d                	jne    803d18 <__udivdi3+0x50>
  803ceb:	39 cf                	cmp    %ecx,%edi
  803ced:	77 65                	ja     803d54 <__udivdi3+0x8c>
  803cef:	89 fd                	mov    %edi,%ebp
  803cf1:	85 ff                	test   %edi,%edi
  803cf3:	75 0b                	jne    803d00 <__udivdi3+0x38>
  803cf5:	b8 01 00 00 00       	mov    $0x1,%eax
  803cfa:	31 d2                	xor    %edx,%edx
  803cfc:	f7 f7                	div    %edi
  803cfe:	89 c5                	mov    %eax,%ebp
  803d00:	31 d2                	xor    %edx,%edx
  803d02:	89 c8                	mov    %ecx,%eax
  803d04:	f7 f5                	div    %ebp
  803d06:	89 c1                	mov    %eax,%ecx
  803d08:	89 d8                	mov    %ebx,%eax
  803d0a:	f7 f5                	div    %ebp
  803d0c:	89 cf                	mov    %ecx,%edi
  803d0e:	89 fa                	mov    %edi,%edx
  803d10:	83 c4 1c             	add    $0x1c,%esp
  803d13:	5b                   	pop    %ebx
  803d14:	5e                   	pop    %esi
  803d15:	5f                   	pop    %edi
  803d16:	5d                   	pop    %ebp
  803d17:	c3                   	ret    
  803d18:	39 ce                	cmp    %ecx,%esi
  803d1a:	77 28                	ja     803d44 <__udivdi3+0x7c>
  803d1c:	0f bd fe             	bsr    %esi,%edi
  803d1f:	83 f7 1f             	xor    $0x1f,%edi
  803d22:	75 40                	jne    803d64 <__udivdi3+0x9c>
  803d24:	39 ce                	cmp    %ecx,%esi
  803d26:	72 0a                	jb     803d32 <__udivdi3+0x6a>
  803d28:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d2c:	0f 87 9e 00 00 00    	ja     803dd0 <__udivdi3+0x108>
  803d32:	b8 01 00 00 00       	mov    $0x1,%eax
  803d37:	89 fa                	mov    %edi,%edx
  803d39:	83 c4 1c             	add    $0x1c,%esp
  803d3c:	5b                   	pop    %ebx
  803d3d:	5e                   	pop    %esi
  803d3e:	5f                   	pop    %edi
  803d3f:	5d                   	pop    %ebp
  803d40:	c3                   	ret    
  803d41:	8d 76 00             	lea    0x0(%esi),%esi
  803d44:	31 ff                	xor    %edi,%edi
  803d46:	31 c0                	xor    %eax,%eax
  803d48:	89 fa                	mov    %edi,%edx
  803d4a:	83 c4 1c             	add    $0x1c,%esp
  803d4d:	5b                   	pop    %ebx
  803d4e:	5e                   	pop    %esi
  803d4f:	5f                   	pop    %edi
  803d50:	5d                   	pop    %ebp
  803d51:	c3                   	ret    
  803d52:	66 90                	xchg   %ax,%ax
  803d54:	89 d8                	mov    %ebx,%eax
  803d56:	f7 f7                	div    %edi
  803d58:	31 ff                	xor    %edi,%edi
  803d5a:	89 fa                	mov    %edi,%edx
  803d5c:	83 c4 1c             	add    $0x1c,%esp
  803d5f:	5b                   	pop    %ebx
  803d60:	5e                   	pop    %esi
  803d61:	5f                   	pop    %edi
  803d62:	5d                   	pop    %ebp
  803d63:	c3                   	ret    
  803d64:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d69:	89 eb                	mov    %ebp,%ebx
  803d6b:	29 fb                	sub    %edi,%ebx
  803d6d:	89 f9                	mov    %edi,%ecx
  803d6f:	d3 e6                	shl    %cl,%esi
  803d71:	89 c5                	mov    %eax,%ebp
  803d73:	88 d9                	mov    %bl,%cl
  803d75:	d3 ed                	shr    %cl,%ebp
  803d77:	89 e9                	mov    %ebp,%ecx
  803d79:	09 f1                	or     %esi,%ecx
  803d7b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d7f:	89 f9                	mov    %edi,%ecx
  803d81:	d3 e0                	shl    %cl,%eax
  803d83:	89 c5                	mov    %eax,%ebp
  803d85:	89 d6                	mov    %edx,%esi
  803d87:	88 d9                	mov    %bl,%cl
  803d89:	d3 ee                	shr    %cl,%esi
  803d8b:	89 f9                	mov    %edi,%ecx
  803d8d:	d3 e2                	shl    %cl,%edx
  803d8f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d93:	88 d9                	mov    %bl,%cl
  803d95:	d3 e8                	shr    %cl,%eax
  803d97:	09 c2                	or     %eax,%edx
  803d99:	89 d0                	mov    %edx,%eax
  803d9b:	89 f2                	mov    %esi,%edx
  803d9d:	f7 74 24 0c          	divl   0xc(%esp)
  803da1:	89 d6                	mov    %edx,%esi
  803da3:	89 c3                	mov    %eax,%ebx
  803da5:	f7 e5                	mul    %ebp
  803da7:	39 d6                	cmp    %edx,%esi
  803da9:	72 19                	jb     803dc4 <__udivdi3+0xfc>
  803dab:	74 0b                	je     803db8 <__udivdi3+0xf0>
  803dad:	89 d8                	mov    %ebx,%eax
  803daf:	31 ff                	xor    %edi,%edi
  803db1:	e9 58 ff ff ff       	jmp    803d0e <__udivdi3+0x46>
  803db6:	66 90                	xchg   %ax,%ax
  803db8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803dbc:	89 f9                	mov    %edi,%ecx
  803dbe:	d3 e2                	shl    %cl,%edx
  803dc0:	39 c2                	cmp    %eax,%edx
  803dc2:	73 e9                	jae    803dad <__udivdi3+0xe5>
  803dc4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803dc7:	31 ff                	xor    %edi,%edi
  803dc9:	e9 40 ff ff ff       	jmp    803d0e <__udivdi3+0x46>
  803dce:	66 90                	xchg   %ax,%ax
  803dd0:	31 c0                	xor    %eax,%eax
  803dd2:	e9 37 ff ff ff       	jmp    803d0e <__udivdi3+0x46>
  803dd7:	90                   	nop

00803dd8 <__umoddi3>:
  803dd8:	55                   	push   %ebp
  803dd9:	57                   	push   %edi
  803dda:	56                   	push   %esi
  803ddb:	53                   	push   %ebx
  803ddc:	83 ec 1c             	sub    $0x1c,%esp
  803ddf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803de3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803de7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803deb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803def:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803df3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803df7:	89 f3                	mov    %esi,%ebx
  803df9:	89 fa                	mov    %edi,%edx
  803dfb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dff:	89 34 24             	mov    %esi,(%esp)
  803e02:	85 c0                	test   %eax,%eax
  803e04:	75 1a                	jne    803e20 <__umoddi3+0x48>
  803e06:	39 f7                	cmp    %esi,%edi
  803e08:	0f 86 a2 00 00 00    	jbe    803eb0 <__umoddi3+0xd8>
  803e0e:	89 c8                	mov    %ecx,%eax
  803e10:	89 f2                	mov    %esi,%edx
  803e12:	f7 f7                	div    %edi
  803e14:	89 d0                	mov    %edx,%eax
  803e16:	31 d2                	xor    %edx,%edx
  803e18:	83 c4 1c             	add    $0x1c,%esp
  803e1b:	5b                   	pop    %ebx
  803e1c:	5e                   	pop    %esi
  803e1d:	5f                   	pop    %edi
  803e1e:	5d                   	pop    %ebp
  803e1f:	c3                   	ret    
  803e20:	39 f0                	cmp    %esi,%eax
  803e22:	0f 87 ac 00 00 00    	ja     803ed4 <__umoddi3+0xfc>
  803e28:	0f bd e8             	bsr    %eax,%ebp
  803e2b:	83 f5 1f             	xor    $0x1f,%ebp
  803e2e:	0f 84 ac 00 00 00    	je     803ee0 <__umoddi3+0x108>
  803e34:	bf 20 00 00 00       	mov    $0x20,%edi
  803e39:	29 ef                	sub    %ebp,%edi
  803e3b:	89 fe                	mov    %edi,%esi
  803e3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e41:	89 e9                	mov    %ebp,%ecx
  803e43:	d3 e0                	shl    %cl,%eax
  803e45:	89 d7                	mov    %edx,%edi
  803e47:	89 f1                	mov    %esi,%ecx
  803e49:	d3 ef                	shr    %cl,%edi
  803e4b:	09 c7                	or     %eax,%edi
  803e4d:	89 e9                	mov    %ebp,%ecx
  803e4f:	d3 e2                	shl    %cl,%edx
  803e51:	89 14 24             	mov    %edx,(%esp)
  803e54:	89 d8                	mov    %ebx,%eax
  803e56:	d3 e0                	shl    %cl,%eax
  803e58:	89 c2                	mov    %eax,%edx
  803e5a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e5e:	d3 e0                	shl    %cl,%eax
  803e60:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e64:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e68:	89 f1                	mov    %esi,%ecx
  803e6a:	d3 e8                	shr    %cl,%eax
  803e6c:	09 d0                	or     %edx,%eax
  803e6e:	d3 eb                	shr    %cl,%ebx
  803e70:	89 da                	mov    %ebx,%edx
  803e72:	f7 f7                	div    %edi
  803e74:	89 d3                	mov    %edx,%ebx
  803e76:	f7 24 24             	mull   (%esp)
  803e79:	89 c6                	mov    %eax,%esi
  803e7b:	89 d1                	mov    %edx,%ecx
  803e7d:	39 d3                	cmp    %edx,%ebx
  803e7f:	0f 82 87 00 00 00    	jb     803f0c <__umoddi3+0x134>
  803e85:	0f 84 91 00 00 00    	je     803f1c <__umoddi3+0x144>
  803e8b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e8f:	29 f2                	sub    %esi,%edx
  803e91:	19 cb                	sbb    %ecx,%ebx
  803e93:	89 d8                	mov    %ebx,%eax
  803e95:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e99:	d3 e0                	shl    %cl,%eax
  803e9b:	89 e9                	mov    %ebp,%ecx
  803e9d:	d3 ea                	shr    %cl,%edx
  803e9f:	09 d0                	or     %edx,%eax
  803ea1:	89 e9                	mov    %ebp,%ecx
  803ea3:	d3 eb                	shr    %cl,%ebx
  803ea5:	89 da                	mov    %ebx,%edx
  803ea7:	83 c4 1c             	add    $0x1c,%esp
  803eaa:	5b                   	pop    %ebx
  803eab:	5e                   	pop    %esi
  803eac:	5f                   	pop    %edi
  803ead:	5d                   	pop    %ebp
  803eae:	c3                   	ret    
  803eaf:	90                   	nop
  803eb0:	89 fd                	mov    %edi,%ebp
  803eb2:	85 ff                	test   %edi,%edi
  803eb4:	75 0b                	jne    803ec1 <__umoddi3+0xe9>
  803eb6:	b8 01 00 00 00       	mov    $0x1,%eax
  803ebb:	31 d2                	xor    %edx,%edx
  803ebd:	f7 f7                	div    %edi
  803ebf:	89 c5                	mov    %eax,%ebp
  803ec1:	89 f0                	mov    %esi,%eax
  803ec3:	31 d2                	xor    %edx,%edx
  803ec5:	f7 f5                	div    %ebp
  803ec7:	89 c8                	mov    %ecx,%eax
  803ec9:	f7 f5                	div    %ebp
  803ecb:	89 d0                	mov    %edx,%eax
  803ecd:	e9 44 ff ff ff       	jmp    803e16 <__umoddi3+0x3e>
  803ed2:	66 90                	xchg   %ax,%ax
  803ed4:	89 c8                	mov    %ecx,%eax
  803ed6:	89 f2                	mov    %esi,%edx
  803ed8:	83 c4 1c             	add    $0x1c,%esp
  803edb:	5b                   	pop    %ebx
  803edc:	5e                   	pop    %esi
  803edd:	5f                   	pop    %edi
  803ede:	5d                   	pop    %ebp
  803edf:	c3                   	ret    
  803ee0:	3b 04 24             	cmp    (%esp),%eax
  803ee3:	72 06                	jb     803eeb <__umoddi3+0x113>
  803ee5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ee9:	77 0f                	ja     803efa <__umoddi3+0x122>
  803eeb:	89 f2                	mov    %esi,%edx
  803eed:	29 f9                	sub    %edi,%ecx
  803eef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ef3:	89 14 24             	mov    %edx,(%esp)
  803ef6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803efa:	8b 44 24 04          	mov    0x4(%esp),%eax
  803efe:	8b 14 24             	mov    (%esp),%edx
  803f01:	83 c4 1c             	add    $0x1c,%esp
  803f04:	5b                   	pop    %ebx
  803f05:	5e                   	pop    %esi
  803f06:	5f                   	pop    %edi
  803f07:	5d                   	pop    %ebp
  803f08:	c3                   	ret    
  803f09:	8d 76 00             	lea    0x0(%esi),%esi
  803f0c:	2b 04 24             	sub    (%esp),%eax
  803f0f:	19 fa                	sbb    %edi,%edx
  803f11:	89 d1                	mov    %edx,%ecx
  803f13:	89 c6                	mov    %eax,%esi
  803f15:	e9 71 ff ff ff       	jmp    803e8b <__umoddi3+0xb3>
  803f1a:	66 90                	xchg   %ax,%ax
  803f1c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f20:	72 ea                	jb     803f0c <__umoddi3+0x134>
  803f22:	89 d9                	mov    %ebx,%ecx
  803f24:	e9 62 ff ff ff       	jmp    803e8b <__umoddi3+0xb3>
