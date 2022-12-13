
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
  800044:	e8 5f 26 00 00       	call   8026a8 <sys_set_uheap_strategy>
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
  80009a:	68 c0 3f 80 00       	push   $0x803fc0
  80009f:	6a 15                	push   $0x15
  8000a1:	68 dc 3f 80 00       	push   $0x803fdc
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
  8000d7:	e8 b7 20 00 00       	call   802193 <sys_calculate_free_frames>
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000df:	e8 4f 21 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
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
  800109:	68 f4 3f 80 00       	push   $0x803ff4
  80010e:	6a 26                	push   $0x26
  800110:	68 dc 3f 80 00       	push   $0x803fdc
  800115:	e8 90 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80011a:	e8 14 21 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  80011f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 24 40 80 00       	push   $0x804024
  80012c:	6a 28                	push   $0x28
  80012e:	68 dc 3f 80 00       	push   $0x803fdc
  800133:	e8 72 0b 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800138:	e8 56 20 00 00       	call   802193 <sys_calculate_free_frames>
  80013d:	89 c2                	mov    %eax,%edx
  80013f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800142:	39 c2                	cmp    %eax,%edx
  800144:	74 14                	je     80015a <_main+0x122>
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	68 41 40 80 00       	push   $0x804041
  80014e:	6a 29                	push   $0x29
  800150:	68 dc 3f 80 00       	push   $0x803fdc
  800155:	e8 50 0b 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80015a:	e8 34 20 00 00       	call   802193 <sys_calculate_free_frames>
  80015f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800162:	e8 cc 20 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
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
  800193:	68 f4 3f 80 00       	push   $0x803ff4
  800198:	6a 2f                	push   $0x2f
  80019a:	68 dc 3f 80 00       	push   $0x803fdc
  80019f:	e8 06 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001a4:	e8 8a 20 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8001a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 24 40 80 00       	push   $0x804024
  8001b6:	6a 31                	push   $0x31
  8001b8:	68 dc 3f 80 00       	push   $0x803fdc
  8001bd:	e8 e8 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001c2:	e8 cc 1f 00 00       	call   802193 <sys_calculate_free_frames>
  8001c7:	89 c2                	mov    %eax,%edx
  8001c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 41 40 80 00       	push   $0x804041
  8001d8:	6a 32                	push   $0x32
  8001da:	68 dc 3f 80 00       	push   $0x803fdc
  8001df:	e8 c6 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001e4:	e8 aa 1f 00 00       	call   802193 <sys_calculate_free_frames>
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001ec:	e8 42 20 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
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
  80021f:	68 f4 3f 80 00       	push   $0x803ff4
  800224:	6a 38                	push   $0x38
  800226:	68 dc 3f 80 00       	push   $0x803fdc
  80022b:	e8 7a 0a 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800230:	e8 fe 1f 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800235:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800238:	74 14                	je     80024e <_main+0x216>
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	68 24 40 80 00       	push   $0x804024
  800242:	6a 3a                	push   $0x3a
  800244:	68 dc 3f 80 00       	push   $0x803fdc
  800249:	e8 5c 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80024e:	e8 40 1f 00 00       	call   802193 <sys_calculate_free_frames>
  800253:	89 c2                	mov    %eax,%edx
  800255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800258:	39 c2                	cmp    %eax,%edx
  80025a:	74 14                	je     800270 <_main+0x238>
  80025c:	83 ec 04             	sub    $0x4,%esp
  80025f:	68 41 40 80 00       	push   $0x804041
  800264:	6a 3b                	push   $0x3b
  800266:	68 dc 3f 80 00       	push   $0x803fdc
  80026b:	e8 3a 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800270:	e8 1e 1f 00 00       	call   802193 <sys_calculate_free_frames>
  800275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800278:	e8 b6 1f 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
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
  8002af:	68 f4 3f 80 00       	push   $0x803ff4
  8002b4:	6a 41                	push   $0x41
  8002b6:	68 dc 3f 80 00       	push   $0x803fdc
  8002bb:	e8 ea 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002c0:	e8 6e 1f 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8002c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c8:	74 14                	je     8002de <_main+0x2a6>
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	68 24 40 80 00       	push   $0x804024
  8002d2:	6a 43                	push   $0x43
  8002d4:	68 dc 3f 80 00       	push   $0x803fdc
  8002d9:	e8 cc 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002de:	e8 b0 1e 00 00       	call   802193 <sys_calculate_free_frames>
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e8:	39 c2                	cmp    %eax,%edx
  8002ea:	74 14                	je     800300 <_main+0x2c8>
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	68 41 40 80 00       	push   $0x804041
  8002f4:	6a 44                	push   $0x44
  8002f6:	68 dc 3f 80 00       	push   $0x803fdc
  8002fb:	e8 aa 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800300:	e8 8e 1e 00 00       	call   802193 <sys_calculate_free_frames>
  800305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800308:	e8 26 1f 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
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
  80033e:	68 f4 3f 80 00       	push   $0x803ff4
  800343:	6a 4a                	push   $0x4a
  800345:	68 dc 3f 80 00       	push   $0x803fdc
  80034a:	e8 5b 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80034f:	e8 df 1e 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800354:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800357:	74 14                	je     80036d <_main+0x335>
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	68 24 40 80 00       	push   $0x804024
  800361:	6a 4c                	push   $0x4c
  800363:	68 dc 3f 80 00       	push   $0x803fdc
  800368:	e8 3d 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80036d:	e8 21 1e 00 00       	call   802193 <sys_calculate_free_frames>
  800372:	89 c2                	mov    %eax,%edx
  800374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800377:	39 c2                	cmp    %eax,%edx
  800379:	74 14                	je     80038f <_main+0x357>
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	68 41 40 80 00       	push   $0x804041
  800383:	6a 4d                	push   $0x4d
  800385:	68 dc 3f 80 00       	push   $0x803fdc
  80038a:	e8 1b 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80038f:	e8 ff 1d 00 00       	call   802193 <sys_calculate_free_frames>
  800394:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800397:	e8 97 1e 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
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
  8003d2:	68 f4 3f 80 00       	push   $0x803ff4
  8003d7:	6a 53                	push   $0x53
  8003d9:	68 dc 3f 80 00       	push   $0x803fdc
  8003de:	e8 c7 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8003e3:	e8 4b 1e 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8003e8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 24 40 80 00       	push   $0x804024
  8003f5:	6a 55                	push   $0x55
  8003f7:	68 dc 3f 80 00       	push   $0x803fdc
  8003fc:	e8 a9 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800401:	e8 8d 1d 00 00       	call   802193 <sys_calculate_free_frames>
  800406:	89 c2                	mov    %eax,%edx
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	39 c2                	cmp    %eax,%edx
  80040d:	74 14                	je     800423 <_main+0x3eb>
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 41 40 80 00       	push   $0x804041
  800417:	6a 56                	push   $0x56
  800419:	68 dc 3f 80 00       	push   $0x803fdc
  80041e:	e8 87 08 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 6b 1d 00 00       	call   802193 <sys_calculate_free_frames>
  800428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 03 1e 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
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
  800465:	68 f4 3f 80 00       	push   $0x803ff4
  80046a:	6a 5c                	push   $0x5c
  80046c:	68 dc 3f 80 00       	push   $0x803fdc
  800471:	e8 34 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800476:	e8 b8 1d 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  80047b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 24 40 80 00       	push   $0x804024
  800488:	6a 5e                	push   $0x5e
  80048a:	68 dc 3f 80 00       	push   $0x803fdc
  80048f:	e8 16 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800494:	e8 fa 1c 00 00       	call   802193 <sys_calculate_free_frames>
  800499:	89 c2                	mov    %eax,%edx
  80049b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	74 14                	je     8004b6 <_main+0x47e>
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	68 41 40 80 00       	push   $0x804041
  8004aa:	6a 5f                	push   $0x5f
  8004ac:	68 dc 3f 80 00       	push   $0x803fdc
  8004b1:	e8 f4 07 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004b6:	e8 d8 1c 00 00       	call   802193 <sys_calculate_free_frames>
  8004bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004be:	e8 70 1d 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
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
  800500:	68 f4 3f 80 00       	push   $0x803ff4
  800505:	6a 65                	push   $0x65
  800507:	68 dc 3f 80 00       	push   $0x803fdc
  80050c:	e8 99 07 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800511:	e8 1d 1d 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800516:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800519:	74 14                	je     80052f <_main+0x4f7>
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	68 24 40 80 00       	push   $0x804024
  800523:	6a 67                	push   $0x67
  800525:	68 dc 3f 80 00       	push   $0x803fdc
  80052a:	e8 7b 07 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80052f:	e8 5f 1c 00 00       	call   802193 <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 41 40 80 00       	push   $0x804041
  800545:	6a 68                	push   $0x68
  800547:	68 dc 3f 80 00       	push   $0x803fdc
  80054c:	e8 59 07 00 00       	call   800caa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800551:	e8 3d 1c 00 00       	call   802193 <sys_calculate_free_frames>
  800556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800559:	e8 d5 1c 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  80055e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800561:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	50                   	push   %eax
  800568:	e8 a7 19 00 00       	call   801f14 <free>
  80056d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800570:	e8 be 1c 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800575:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800578:	74 14                	je     80058e <_main+0x556>
  80057a:	83 ec 04             	sub    $0x4,%esp
  80057d:	68 54 40 80 00       	push   $0x804054
  800582:	6a 72                	push   $0x72
  800584:	68 dc 3f 80 00       	push   $0x803fdc
  800589:	e8 1c 07 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80058e:	e8 00 1c 00 00       	call   802193 <sys_calculate_free_frames>
  800593:	89 c2                	mov    %eax,%edx
  800595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800598:	39 c2                	cmp    %eax,%edx
  80059a:	74 14                	je     8005b0 <_main+0x578>
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	68 6b 40 80 00       	push   $0x80406b
  8005a4:	6a 73                	push   $0x73
  8005a6:	68 dc 3f 80 00       	push   $0x803fdc
  8005ab:	e8 fa 06 00 00       	call   800caa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005b0:	e8 de 1b 00 00       	call   802193 <sys_calculate_free_frames>
  8005b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005b8:	e8 76 1c 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  8005c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	50                   	push   %eax
  8005c7:	e8 48 19 00 00       	call   801f14 <free>
  8005cc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005cf:	e8 5f 1c 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8005d4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005d7:	74 14                	je     8005ed <_main+0x5b5>
  8005d9:	83 ec 04             	sub    $0x4,%esp
  8005dc:	68 54 40 80 00       	push   $0x804054
  8005e1:	6a 7a                	push   $0x7a
  8005e3:	68 dc 3f 80 00       	push   $0x803fdc
  8005e8:	e8 bd 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ed:	e8 a1 1b 00 00       	call   802193 <sys_calculate_free_frames>
  8005f2:	89 c2                	mov    %eax,%edx
  8005f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f7:	39 c2                	cmp    %eax,%edx
  8005f9:	74 14                	je     80060f <_main+0x5d7>
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 6b 40 80 00       	push   $0x80406b
  800603:	6a 7b                	push   $0x7b
  800605:	68 dc 3f 80 00       	push   $0x803fdc
  80060a:	e8 9b 06 00 00       	call   800caa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80060f:	e8 7f 1b 00 00       	call   802193 <sys_calculate_free_frames>
  800614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800617:	e8 17 1c 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80061f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800622:	83 ec 0c             	sub    $0xc,%esp
  800625:	50                   	push   %eax
  800626:	e8 e9 18 00 00       	call   801f14 <free>
  80062b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80062e:	e8 00 1c 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800633:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800636:	74 17                	je     80064f <_main+0x617>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 54 40 80 00       	push   $0x804054
  800640:	68 82 00 00 00       	push   $0x82
  800645:	68 dc 3f 80 00       	push   $0x803fdc
  80064a:	e8 5b 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064f:	e8 3f 1b 00 00       	call   802193 <sys_calculate_free_frames>
  800654:	89 c2                	mov    %eax,%edx
  800656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800659:	39 c2                	cmp    %eax,%edx
  80065b:	74 17                	je     800674 <_main+0x63c>
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	68 6b 40 80 00       	push   $0x80406b
  800665:	68 83 00 00 00       	push   $0x83
  80066a:	68 dc 3f 80 00       	push   $0x803fdc
  80066f:	e8 36 06 00 00       	call   800caa <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800674:	e8 1a 1b 00 00       	call   802193 <sys_calculate_free_frames>
  800679:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80067c:	e8 b2 1b 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
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
  8006b1:	68 f4 3f 80 00       	push   $0x803ff4
  8006b6:	68 8c 00 00 00       	push   $0x8c
  8006bb:	68 dc 3f 80 00       	push   $0x803fdc
  8006c0:	e8 e5 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006c5:	e8 69 1b 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8006ca:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006cd:	74 17                	je     8006e6 <_main+0x6ae>
  8006cf:	83 ec 04             	sub    $0x4,%esp
  8006d2:	68 24 40 80 00       	push   $0x804024
  8006d7:	68 8e 00 00 00       	push   $0x8e
  8006dc:	68 dc 3f 80 00       	push   $0x803fdc
  8006e1:	e8 c4 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8006e6:	e8 a8 1a 00 00       	call   802193 <sys_calculate_free_frames>
  8006eb:	89 c2                	mov    %eax,%edx
  8006ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f0:	39 c2                	cmp    %eax,%edx
  8006f2:	74 17                	je     80070b <_main+0x6d3>
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	68 41 40 80 00       	push   $0x804041
  8006fc:	68 8f 00 00 00       	push   $0x8f
  800701:	68 dc 3f 80 00       	push   $0x803fdc
  800706:	e8 9f 05 00 00       	call   800caa <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80070b:	e8 83 1a 00 00       	call   802193 <sys_calculate_free_frames>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800713:	e8 1b 1b 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
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
  800747:	68 f4 3f 80 00       	push   $0x803ff4
  80074c:	68 95 00 00 00       	push   $0x95
  800751:	68 dc 3f 80 00       	push   $0x803fdc
  800756:	e8 4f 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80075b:	e8 d3 1a 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800760:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800763:	74 17                	je     80077c <_main+0x744>
  800765:	83 ec 04             	sub    $0x4,%esp
  800768:	68 24 40 80 00       	push   $0x804024
  80076d:	68 97 00 00 00       	push   $0x97
  800772:	68 dc 3f 80 00       	push   $0x803fdc
  800777:	e8 2e 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80077c:	e8 12 1a 00 00       	call   802193 <sys_calculate_free_frames>
  800781:	89 c2                	mov    %eax,%edx
  800783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800786:	39 c2                	cmp    %eax,%edx
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	68 41 40 80 00       	push   $0x804041
  800792:	68 98 00 00 00       	push   $0x98
  800797:	68 dc 3f 80 00       	push   $0x803fdc
  80079c:	e8 09 05 00 00       	call   800caa <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007a1:	e8 ed 19 00 00       	call   802193 <sys_calculate_free_frames>
  8007a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007a9:	e8 85 1a 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
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
  8007e8:	68 f4 3f 80 00       	push   $0x803ff4
  8007ed:	68 9e 00 00 00       	push   $0x9e
  8007f2:	68 dc 3f 80 00       	push   $0x803fdc
  8007f7:	e8 ae 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8007fc:	e8 32 1a 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800801:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800804:	74 17                	je     80081d <_main+0x7e5>
  800806:	83 ec 04             	sub    $0x4,%esp
  800809:	68 24 40 80 00       	push   $0x804024
  80080e:	68 a0 00 00 00       	push   $0xa0
  800813:	68 dc 3f 80 00       	push   $0x803fdc
  800818:	e8 8d 04 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80081d:	e8 71 19 00 00       	call   802193 <sys_calculate_free_frames>
  800822:	89 c2                	mov    %eax,%edx
  800824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800827:	39 c2                	cmp    %eax,%edx
  800829:	74 17                	je     800842 <_main+0x80a>
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	68 41 40 80 00       	push   $0x804041
  800833:	68 a1 00 00 00       	push   $0xa1
  800838:	68 dc 3f 80 00       	push   $0x803fdc
  80083d:	e8 68 04 00 00       	call   800caa <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800842:	e8 4c 19 00 00       	call   802193 <sys_calculate_free_frames>
  800847:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80084a:	e8 e4 19 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
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
  80087d:	68 f4 3f 80 00       	push   $0x803ff4
  800882:	68 a7 00 00 00       	push   $0xa7
  800887:	68 dc 3f 80 00       	push   $0x803fdc
  80088c:	e8 19 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800891:	e8 9d 19 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800896:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800899:	74 17                	je     8008b2 <_main+0x87a>
  80089b:	83 ec 04             	sub    $0x4,%esp
  80089e:	68 24 40 80 00       	push   $0x804024
  8008a3:	68 a9 00 00 00       	push   $0xa9
  8008a8:	68 dc 3f 80 00       	push   $0x803fdc
  8008ad:	e8 f8 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008b2:	e8 dc 18 00 00       	call   802193 <sys_calculate_free_frames>
  8008b7:	89 c2                	mov    %eax,%edx
  8008b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008bc:	39 c2                	cmp    %eax,%edx
  8008be:	74 17                	je     8008d7 <_main+0x89f>
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	68 41 40 80 00       	push   $0x804041
  8008c8:	68 aa 00 00 00       	push   $0xaa
  8008cd:	68 dc 3f 80 00       	push   $0x803fdc
  8008d2:	e8 d3 03 00 00       	call   800caa <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008d7:	e8 b7 18 00 00       	call   802193 <sys_calculate_free_frames>
  8008dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008df:	e8 4f 19 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
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
  80091f:	68 f4 3f 80 00       	push   $0x803ff4
  800924:	68 b0 00 00 00       	push   $0xb0
  800929:	68 dc 3f 80 00       	push   $0x803fdc
  80092e:	e8 77 03 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800933:	e8 fb 18 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800938:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80093b:	74 17                	je     800954 <_main+0x91c>
  80093d:	83 ec 04             	sub    $0x4,%esp
  800940:	68 24 40 80 00       	push   $0x804024
  800945:	68 b2 00 00 00       	push   $0xb2
  80094a:	68 dc 3f 80 00       	push   $0x803fdc
  80094f:	e8 56 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800954:	e8 3a 18 00 00       	call   802193 <sys_calculate_free_frames>
  800959:	89 c2                	mov    %eax,%edx
  80095b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80095e:	39 c2                	cmp    %eax,%edx
  800960:	74 17                	je     800979 <_main+0x941>
  800962:	83 ec 04             	sub    $0x4,%esp
  800965:	68 41 40 80 00       	push   $0x804041
  80096a:	68 b3 00 00 00       	push   $0xb3
  80096f:	68 dc 3f 80 00       	push   $0x803fdc
  800974:	e8 31 03 00 00       	call   800caa <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800979:	e8 15 18 00 00       	call   802193 <sys_calculate_free_frames>
  80097e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800981:	e8 ad 18 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800986:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  800989:	8b 45 98             	mov    -0x68(%ebp),%eax
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 7f 15 00 00       	call   801f14 <free>
  800995:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800998:	e8 96 18 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 54 40 80 00       	push   $0x804054
  8009aa:	68 bd 00 00 00       	push   $0xbd
  8009af:	68 dc 3f 80 00       	push   $0x803fdc
  8009b4:	e8 f1 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009b9:	e8 d5 17 00 00       	call   802193 <sys_calculate_free_frames>
  8009be:	89 c2                	mov    %eax,%edx
  8009c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c3:	39 c2                	cmp    %eax,%edx
  8009c5:	74 17                	je     8009de <_main+0x9a6>
  8009c7:	83 ec 04             	sub    $0x4,%esp
  8009ca:	68 6b 40 80 00       	push   $0x80406b
  8009cf:	68 be 00 00 00       	push   $0xbe
  8009d4:	68 dc 3f 80 00       	push   $0x803fdc
  8009d9:	e8 cc 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8009de:	e8 b0 17 00 00       	call   802193 <sys_calculate_free_frames>
  8009e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e6:	e8 48 18 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  8009eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[9]);
  8009ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8009f1:	83 ec 0c             	sub    $0xc,%esp
  8009f4:	50                   	push   %eax
  8009f5:	e8 1a 15 00 00       	call   801f14 <free>
  8009fa:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009fd:	e8 31 18 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800a02:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 54 40 80 00       	push   $0x804054
  800a0f:	68 c5 00 00 00       	push   $0xc5
  800a14:	68 dc 3f 80 00       	push   $0x803fdc
  800a19:	e8 8c 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a1e:	e8 70 17 00 00       	call   802193 <sys_calculate_free_frames>
  800a23:	89 c2                	mov    %eax,%edx
  800a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a28:	39 c2                	cmp    %eax,%edx
  800a2a:	74 17                	je     800a43 <_main+0xa0b>
  800a2c:	83 ec 04             	sub    $0x4,%esp
  800a2f:	68 6b 40 80 00       	push   $0x80406b
  800a34:	68 c6 00 00 00       	push   $0xc6
  800a39:	68 dc 3f 80 00       	push   $0x803fdc
  800a3e:	e8 67 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a43:	e8 4b 17 00 00       	call   802193 <sys_calculate_free_frames>
  800a48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a4b:	e8 e3 17 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800a53:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800a56:	83 ec 0c             	sub    $0xc,%esp
  800a59:	50                   	push   %eax
  800a5a:	e8 b5 14 00 00       	call   801f14 <free>
  800a5f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a62:	e8 cc 17 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800a67:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 54 40 80 00       	push   $0x804054
  800a74:	68 cd 00 00 00       	push   $0xcd
  800a79:	68 dc 3f 80 00       	push   $0x803fdc
  800a7e:	e8 27 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a83:	e8 0b 17 00 00       	call   802193 <sys_calculate_free_frames>
  800a88:	89 c2                	mov    %eax,%edx
  800a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a8d:	39 c2                	cmp    %eax,%edx
  800a8f:	74 17                	je     800aa8 <_main+0xa70>
  800a91:	83 ec 04             	sub    $0x4,%esp
  800a94:	68 6b 40 80 00       	push   $0x80406b
  800a99:	68 ce 00 00 00       	push   $0xce
  800a9e:	68 dc 3f 80 00       	push   $0x803fdc
  800aa3:	e8 02 02 00 00       	call   800caa <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800aa8:	e8 e6 16 00 00       	call   802193 <sys_calculate_free_frames>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ab0:	e8 7e 17 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
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
  800afe:	68 f4 3f 80 00       	push   $0x803ff4
  800b03:	68 d8 00 00 00       	push   $0xd8
  800b08:	68 dc 3f 80 00       	push   $0x803fdc
  800b0d:	e8 98 01 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b12:	e8 1c 17 00 00       	call   802233 <sys_pf_calculate_allocated_pages>
  800b17:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b1a:	74 17                	je     800b33 <_main+0xafb>
  800b1c:	83 ec 04             	sub    $0x4,%esp
  800b1f:	68 24 40 80 00       	push   $0x804024
  800b24:	68 da 00 00 00       	push   $0xda
  800b29:	68 dc 3f 80 00       	push   $0x803fdc
  800b2e:	e8 77 01 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b33:	e8 5b 16 00 00       	call   802193 <sys_calculate_free_frames>
  800b38:	89 c2                	mov    %eax,%edx
  800b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b3d:	39 c2                	cmp    %eax,%edx
  800b3f:	74 17                	je     800b58 <_main+0xb20>
  800b41:	83 ec 04             	sub    $0x4,%esp
  800b44:	68 41 40 80 00       	push   $0x804041
  800b49:	68 db 00 00 00       	push   $0xdb
  800b4e:	68 dc 3f 80 00       	push   $0x803fdc
  800b53:	e8 52 01 00 00       	call   800caa <_panic>
	}
	cprintf("Congratulations!! test FIRST FIT allocation (1) completed successfully.\n");
  800b58:	83 ec 0c             	sub    $0xc,%esp
  800b5b:	68 78 40 80 00       	push   $0x804078
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
  800b74:	e8 fa 18 00 00       	call   802473 <sys_getenvindex>
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
  800bdf:	e8 9c 16 00 00       	call   802280 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800be4:	83 ec 0c             	sub    $0xc,%esp
  800be7:	68 dc 40 80 00       	push   $0x8040dc
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
  800c0f:	68 04 41 80 00       	push   $0x804104
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
  800c40:	68 2c 41 80 00       	push   $0x80412c
  800c45:	e8 14 03 00 00       	call   800f5e <cprintf>
  800c4a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c4d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c52:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	50                   	push   %eax
  800c5c:	68 84 41 80 00       	push   $0x804184
  800c61:	e8 f8 02 00 00       	call   800f5e <cprintf>
  800c66:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	68 dc 40 80 00       	push   $0x8040dc
  800c71:	e8 e8 02 00 00       	call   800f5e <cprintf>
  800c76:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c79:	e8 1c 16 00 00       	call   80229a <sys_enable_interrupt>

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
  800c91:	e8 a9 17 00 00       	call   80243f <sys_destroy_env>
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
  800ca2:	e8 fe 17 00 00       	call   8024a5 <sys_exit_env>
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
  800ccb:	68 98 41 80 00       	push   $0x804198
  800cd0:	e8 89 02 00 00       	call   800f5e <cprintf>
  800cd5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cd8:	a1 00 50 80 00       	mov    0x805000,%eax
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	ff 75 08             	pushl  0x8(%ebp)
  800ce3:	50                   	push   %eax
  800ce4:	68 9d 41 80 00       	push   $0x80419d
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
  800d08:	68 b9 41 80 00       	push   $0x8041b9
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
  800d34:	68 bc 41 80 00       	push   $0x8041bc
  800d39:	6a 26                	push   $0x26
  800d3b:	68 08 42 80 00       	push   $0x804208
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
  800e06:	68 14 42 80 00       	push   $0x804214
  800e0b:	6a 3a                	push   $0x3a
  800e0d:	68 08 42 80 00       	push   $0x804208
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
  800e76:	68 68 42 80 00       	push   $0x804268
  800e7b:	6a 44                	push   $0x44
  800e7d:	68 08 42 80 00       	push   $0x804208
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
  800ed0:	e8 fd 11 00 00       	call   8020d2 <sys_cputs>
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
  800f47:	e8 86 11 00 00       	call   8020d2 <sys_cputs>
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
  800f91:	e8 ea 12 00 00       	call   802280 <sys_disable_interrupt>
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
  800fb1:	e8 e4 12 00 00       	call   80229a <sys_enable_interrupt>
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
  800ffb:	e8 58 2d 00 00       	call   803d58 <__udivdi3>
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
  80104b:	e8 18 2e 00 00       	call   803e68 <__umoddi3>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	05 d4 44 80 00       	add    $0x8044d4,%eax
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
  8011a6:	8b 04 85 f8 44 80 00 	mov    0x8044f8(,%eax,4),%eax
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
  801287:	8b 34 9d 40 43 80 00 	mov    0x804340(,%ebx,4),%esi
  80128e:	85 f6                	test   %esi,%esi
  801290:	75 19                	jne    8012ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801292:	53                   	push   %ebx
  801293:	68 e5 44 80 00       	push   $0x8044e5
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
  8012ac:	68 ee 44 80 00       	push   $0x8044ee
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
  8012d9:	be f1 44 80 00       	mov    $0x8044f1,%esi
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
  801cff:	68 50 46 80 00       	push   $0x804650
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
  801dcf:	e8 42 04 00 00       	call   802216 <sys_allocate_chunk>
  801dd4:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801dd7:	a1 20 51 80 00       	mov    0x805120,%eax
  801ddc:	83 ec 0c             	sub    $0xc,%esp
  801ddf:	50                   	push   %eax
  801de0:	e8 b7 0a 00 00       	call   80289c <initialize_MemBlocksList>
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
  801e0d:	68 75 46 80 00       	push   $0x804675
  801e12:	6a 33                	push   $0x33
  801e14:	68 93 46 80 00       	push   $0x804693
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
  801e8c:	68 a0 46 80 00       	push   $0x8046a0
  801e91:	6a 34                	push   $0x34
  801e93:	68 93 46 80 00       	push   $0x804693
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
  801f01:	68 c4 46 80 00       	push   $0x8046c4
  801f06:	6a 46                	push   $0x46
  801f08:	68 93 46 80 00       	push   $0x804693
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
  801f1d:	68 ec 46 80 00       	push   $0x8046ec
  801f22:	6a 61                	push   $0x61
  801f24:	68 93 46 80 00       	push   $0x804693
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
  801f43:	75 0a                	jne    801f4f <smalloc+0x21>
  801f45:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4a:	e9 9e 00 00 00       	jmp    801fed <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801f4f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5c:	01 d0                	add    %edx,%eax
  801f5e:	48                   	dec    %eax
  801f5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f65:	ba 00 00 00 00       	mov    $0x0,%edx
  801f6a:	f7 75 f0             	divl   -0x10(%ebp)
  801f6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f70:	29 d0                	sub    %edx,%eax
  801f72:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801f75:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801f7c:	e8 63 06 00 00       	call   8025e4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f81:	85 c0                	test   %eax,%eax
  801f83:	74 11                	je     801f96 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801f85:	83 ec 0c             	sub    $0xc,%esp
  801f88:	ff 75 e8             	pushl  -0x18(%ebp)
  801f8b:	e8 ce 0c 00 00       	call   802c5e <alloc_block_FF>
  801f90:	83 c4 10             	add    $0x10,%esp
  801f93:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801f96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9a:	74 4c                	je     801fe8 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9f:	8b 40 08             	mov    0x8(%eax),%eax
  801fa2:	89 c2                	mov    %eax,%edx
  801fa4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801fa8:	52                   	push   %edx
  801fa9:	50                   	push   %eax
  801faa:	ff 75 0c             	pushl  0xc(%ebp)
  801fad:	ff 75 08             	pushl  0x8(%ebp)
  801fb0:	e8 b4 03 00 00       	call   802369 <sys_createSharedObject>
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801fbb:	83 ec 08             	sub    $0x8,%esp
  801fbe:	ff 75 e0             	pushl  -0x20(%ebp)
  801fc1:	68 0f 47 80 00       	push   $0x80470f
  801fc6:	e8 93 ef ff ff       	call   800f5e <cprintf>
  801fcb:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801fce:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801fd2:	74 14                	je     801fe8 <smalloc+0xba>
  801fd4:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801fd8:	74 0e                	je     801fe8 <smalloc+0xba>
  801fda:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801fde:	74 08                	je     801fe8 <smalloc+0xba>
			return (void*) mem_block->sva;
  801fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe3:	8b 40 08             	mov    0x8(%eax),%eax
  801fe6:	eb 05                	jmp    801fed <smalloc+0xbf>
	}
	return NULL;
  801fe8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ff5:	e8 ee fc ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801ffa:	83 ec 04             	sub    $0x4,%esp
  801ffd:	68 24 47 80 00       	push   $0x804724
  802002:	68 ab 00 00 00       	push   $0xab
  802007:	68 93 46 80 00       	push   $0x804693
  80200c:	e8 99 ec ff ff       	call   800caa <_panic>

00802011 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802017:	e8 cc fc ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80201c:	83 ec 04             	sub    $0x4,%esp
  80201f:	68 48 47 80 00       	push   $0x804748
  802024:	68 ef 00 00 00       	push   $0xef
  802029:	68 93 46 80 00       	push   $0x804693
  80202e:	e8 77 ec ff ff       	call   800caa <_panic>

00802033 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802039:	83 ec 04             	sub    $0x4,%esp
  80203c:	68 70 47 80 00       	push   $0x804770
  802041:	68 03 01 00 00       	push   $0x103
  802046:	68 93 46 80 00       	push   $0x804693
  80204b:	e8 5a ec ff ff       	call   800caa <_panic>

00802050 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802056:	83 ec 04             	sub    $0x4,%esp
  802059:	68 94 47 80 00       	push   $0x804794
  80205e:	68 0e 01 00 00       	push   $0x10e
  802063:	68 93 46 80 00       	push   $0x804693
  802068:	e8 3d ec ff ff       	call   800caa <_panic>

0080206d <shrink>:

}
void shrink(uint32 newSize)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802073:	83 ec 04             	sub    $0x4,%esp
  802076:	68 94 47 80 00       	push   $0x804794
  80207b:	68 13 01 00 00       	push   $0x113
  802080:	68 93 46 80 00       	push   $0x804693
  802085:	e8 20 ec ff ff       	call   800caa <_panic>

0080208a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802090:	83 ec 04             	sub    $0x4,%esp
  802093:	68 94 47 80 00       	push   $0x804794
  802098:	68 18 01 00 00       	push   $0x118
  80209d:	68 93 46 80 00       	push   $0x804693
  8020a2:	e8 03 ec ff ff       	call   800caa <_panic>

008020a7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	57                   	push   %edi
  8020ab:	56                   	push   %esi
  8020ac:	53                   	push   %ebx
  8020ad:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020bc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020bf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020c2:	cd 30                	int    $0x30
  8020c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	5b                   	pop    %ebx
  8020ce:	5e                   	pop    %esi
  8020cf:	5f                   	pop    %edi
  8020d0:	5d                   	pop    %ebp
  8020d1:	c3                   	ret    

008020d2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 04             	sub    $0x4,%esp
  8020d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8020db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020de:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	52                   	push   %edx
  8020ea:	ff 75 0c             	pushl  0xc(%ebp)
  8020ed:	50                   	push   %eax
  8020ee:	6a 00                	push   $0x0
  8020f0:	e8 b2 ff ff ff       	call   8020a7 <syscall>
  8020f5:	83 c4 18             	add    $0x18,%esp
}
  8020f8:	90                   	nop
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <sys_cgetc>:

int
sys_cgetc(void)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 01                	push   $0x1
  80210a:	e8 98 ff ff ff       	call   8020a7 <syscall>
  80210f:	83 c4 18             	add    $0x18,%esp
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802117:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	52                   	push   %edx
  802124:	50                   	push   %eax
  802125:	6a 05                	push   $0x5
  802127:	e8 7b ff ff ff       	call   8020a7 <syscall>
  80212c:	83 c4 18             	add    $0x18,%esp
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	56                   	push   %esi
  802135:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802136:	8b 75 18             	mov    0x18(%ebp),%esi
  802139:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80213c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80213f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	56                   	push   %esi
  802146:	53                   	push   %ebx
  802147:	51                   	push   %ecx
  802148:	52                   	push   %edx
  802149:	50                   	push   %eax
  80214a:	6a 06                	push   $0x6
  80214c:	e8 56 ff ff ff       	call   8020a7 <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
}
  802154:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802157:	5b                   	pop    %ebx
  802158:	5e                   	pop    %esi
  802159:	5d                   	pop    %ebp
  80215a:	c3                   	ret    

0080215b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80215e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	52                   	push   %edx
  80216b:	50                   	push   %eax
  80216c:	6a 07                	push   $0x7
  80216e:	e8 34 ff ff ff       	call   8020a7 <syscall>
  802173:	83 c4 18             	add    $0x18,%esp
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	6a 08                	push   $0x8
  802189:	e8 19 ff ff ff       	call   8020a7 <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
}
  802191:	c9                   	leave  
  802192:	c3                   	ret    

00802193 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 09                	push   $0x9
  8021a2:	e8 00 ff ff ff       	call   8020a7 <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 0a                	push   $0xa
  8021bb:	e8 e7 fe ff ff       	call   8020a7 <syscall>
  8021c0:	83 c4 18             	add    $0x18,%esp
}
  8021c3:	c9                   	leave  
  8021c4:	c3                   	ret    

008021c5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 0b                	push   $0xb
  8021d4:	e8 ce fe ff ff       	call   8020a7 <syscall>
  8021d9:	83 c4 18             	add    $0x18,%esp
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ea:	ff 75 08             	pushl  0x8(%ebp)
  8021ed:	6a 0f                	push   $0xf
  8021ef:	e8 b3 fe ff ff       	call   8020a7 <syscall>
  8021f4:	83 c4 18             	add    $0x18,%esp
	return;
  8021f7:	90                   	nop
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	ff 75 0c             	pushl  0xc(%ebp)
  802206:	ff 75 08             	pushl  0x8(%ebp)
  802209:	6a 10                	push   $0x10
  80220b:	e8 97 fe ff ff       	call   8020a7 <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
	return ;
  802213:	90                   	nop
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	ff 75 10             	pushl  0x10(%ebp)
  802220:	ff 75 0c             	pushl  0xc(%ebp)
  802223:	ff 75 08             	pushl  0x8(%ebp)
  802226:	6a 11                	push   $0x11
  802228:	e8 7a fe ff ff       	call   8020a7 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
	return ;
  802230:	90                   	nop
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 0c                	push   $0xc
  802242:	e8 60 fe ff ff       	call   8020a7 <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	ff 75 08             	pushl  0x8(%ebp)
  80225a:	6a 0d                	push   $0xd
  80225c:	e8 46 fe ff ff       	call   8020a7 <syscall>
  802261:	83 c4 18             	add    $0x18,%esp
}
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 0e                	push   $0xe
  802275:	e8 2d fe ff ff       	call   8020a7 <syscall>
  80227a:	83 c4 18             	add    $0x18,%esp
}
  80227d:	90                   	nop
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 13                	push   $0x13
  80228f:	e8 13 fe ff ff       	call   8020a7 <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
}
  802297:	90                   	nop
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 14                	push   $0x14
  8022a9:	e8 f9 fd ff ff       	call   8020a7 <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
}
  8022b1:	90                   	nop
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
  8022b7:	83 ec 04             	sub    $0x4,%esp
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022c0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	50                   	push   %eax
  8022cd:	6a 15                	push   $0x15
  8022cf:	e8 d3 fd ff ff       	call   8020a7 <syscall>
  8022d4:	83 c4 18             	add    $0x18,%esp
}
  8022d7:	90                   	nop
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 16                	push   $0x16
  8022e9:	e8 b9 fd ff ff       	call   8020a7 <syscall>
  8022ee:	83 c4 18             	add    $0x18,%esp
}
  8022f1:	90                   	nop
  8022f2:	c9                   	leave  
  8022f3:	c3                   	ret    

008022f4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	ff 75 0c             	pushl  0xc(%ebp)
  802303:	50                   	push   %eax
  802304:	6a 17                	push   $0x17
  802306:	e8 9c fd ff ff       	call   8020a7 <syscall>
  80230b:	83 c4 18             	add    $0x18,%esp
}
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802313:	8b 55 0c             	mov    0xc(%ebp),%edx
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	52                   	push   %edx
  802320:	50                   	push   %eax
  802321:	6a 1a                	push   $0x1a
  802323:	e8 7f fd ff ff       	call   8020a7 <syscall>
  802328:	83 c4 18             	add    $0x18,%esp
}
  80232b:	c9                   	leave  
  80232c:	c3                   	ret    

0080232d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802330:	8b 55 0c             	mov    0xc(%ebp),%edx
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	52                   	push   %edx
  80233d:	50                   	push   %eax
  80233e:	6a 18                	push   $0x18
  802340:	e8 62 fd ff ff       	call   8020a7 <syscall>
  802345:	83 c4 18             	add    $0x18,%esp
}
  802348:	90                   	nop
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80234e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	52                   	push   %edx
  80235b:	50                   	push   %eax
  80235c:	6a 19                	push   $0x19
  80235e:	e8 44 fd ff ff       	call   8020a7 <syscall>
  802363:	83 c4 18             	add    $0x18,%esp
}
  802366:	90                   	nop
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
  80236c:	83 ec 04             	sub    $0x4,%esp
  80236f:	8b 45 10             	mov    0x10(%ebp),%eax
  802372:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802375:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802378:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	6a 00                	push   $0x0
  802381:	51                   	push   %ecx
  802382:	52                   	push   %edx
  802383:	ff 75 0c             	pushl  0xc(%ebp)
  802386:	50                   	push   %eax
  802387:	6a 1b                	push   $0x1b
  802389:	e8 19 fd ff ff       	call   8020a7 <syscall>
  80238e:	83 c4 18             	add    $0x18,%esp
}
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802396:	8b 55 0c             	mov    0xc(%ebp),%edx
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	52                   	push   %edx
  8023a3:	50                   	push   %eax
  8023a4:	6a 1c                	push   $0x1c
  8023a6:	e8 fc fc ff ff       	call   8020a7 <syscall>
  8023ab:	83 c4 18             	add    $0x18,%esp
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	51                   	push   %ecx
  8023c1:	52                   	push   %edx
  8023c2:	50                   	push   %eax
  8023c3:	6a 1d                	push   $0x1d
  8023c5:	e8 dd fc ff ff       	call   8020a7 <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	52                   	push   %edx
  8023df:	50                   	push   %eax
  8023e0:	6a 1e                	push   $0x1e
  8023e2:	e8 c0 fc ff ff       	call   8020a7 <syscall>
  8023e7:	83 c4 18             	add    $0x18,%esp
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 1f                	push   $0x1f
  8023fb:	e8 a7 fc ff ff       	call   8020a7 <syscall>
  802400:	83 c4 18             	add    $0x18,%esp
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	6a 00                	push   $0x0
  80240d:	ff 75 14             	pushl  0x14(%ebp)
  802410:	ff 75 10             	pushl  0x10(%ebp)
  802413:	ff 75 0c             	pushl  0xc(%ebp)
  802416:	50                   	push   %eax
  802417:	6a 20                	push   $0x20
  802419:	e8 89 fc ff ff       	call   8020a7 <syscall>
  80241e:	83 c4 18             	add    $0x18,%esp
}
  802421:	c9                   	leave  
  802422:	c3                   	ret    

00802423 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	50                   	push   %eax
  802432:	6a 21                	push   $0x21
  802434:	e8 6e fc ff ff       	call   8020a7 <syscall>
  802439:	83 c4 18             	add    $0x18,%esp
}
  80243c:	90                   	nop
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	50                   	push   %eax
  80244e:	6a 22                	push   $0x22
  802450:	e8 52 fc ff ff       	call   8020a7 <syscall>
  802455:	83 c4 18             	add    $0x18,%esp
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 02                	push   $0x2
  802469:	e8 39 fc ff ff       	call   8020a7 <syscall>
  80246e:	83 c4 18             	add    $0x18,%esp
}
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 03                	push   $0x3
  802482:	e8 20 fc ff ff       	call   8020a7 <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
}
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 04                	push   $0x4
  80249b:	e8 07 fc ff ff       	call   8020a7 <syscall>
  8024a0:	83 c4 18             	add    $0x18,%esp
}
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <sys_exit_env>:


void sys_exit_env(void)
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 23                	push   $0x23
  8024b4:	e8 ee fb ff ff       	call   8020a7 <syscall>
  8024b9:	83 c4 18             	add    $0x18,%esp
}
  8024bc:	90                   	nop
  8024bd:	c9                   	leave  
  8024be:	c3                   	ret    

008024bf <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
  8024c2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024c5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024c8:	8d 50 04             	lea    0x4(%eax),%edx
  8024cb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	52                   	push   %edx
  8024d5:	50                   	push   %eax
  8024d6:	6a 24                	push   $0x24
  8024d8:	e8 ca fb ff ff       	call   8020a7 <syscall>
  8024dd:	83 c4 18             	add    $0x18,%esp
	return result;
  8024e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024e9:	89 01                	mov    %eax,(%ecx)
  8024eb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	c9                   	leave  
  8024f2:	c2 04 00             	ret    $0x4

008024f5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	ff 75 10             	pushl  0x10(%ebp)
  8024ff:	ff 75 0c             	pushl  0xc(%ebp)
  802502:	ff 75 08             	pushl  0x8(%ebp)
  802505:	6a 12                	push   $0x12
  802507:	e8 9b fb ff ff       	call   8020a7 <syscall>
  80250c:	83 c4 18             	add    $0x18,%esp
	return ;
  80250f:	90                   	nop
}
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <sys_rcr2>:
uint32 sys_rcr2()
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 25                	push   $0x25
  802521:	e8 81 fb ff ff       	call   8020a7 <syscall>
  802526:	83 c4 18             	add    $0x18,%esp
}
  802529:	c9                   	leave  
  80252a:	c3                   	ret    

0080252b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
  80252e:	83 ec 04             	sub    $0x4,%esp
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802537:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	50                   	push   %eax
  802544:	6a 26                	push   $0x26
  802546:	e8 5c fb ff ff       	call   8020a7 <syscall>
  80254b:	83 c4 18             	add    $0x18,%esp
	return ;
  80254e:	90                   	nop
}
  80254f:	c9                   	leave  
  802550:	c3                   	ret    

00802551 <rsttst>:
void rsttst()
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	6a 28                	push   $0x28
  802560:	e8 42 fb ff ff       	call   8020a7 <syscall>
  802565:	83 c4 18             	add    $0x18,%esp
	return ;
  802568:	90                   	nop
}
  802569:	c9                   	leave  
  80256a:	c3                   	ret    

0080256b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
  80256e:	83 ec 04             	sub    $0x4,%esp
  802571:	8b 45 14             	mov    0x14(%ebp),%eax
  802574:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802577:	8b 55 18             	mov    0x18(%ebp),%edx
  80257a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80257e:	52                   	push   %edx
  80257f:	50                   	push   %eax
  802580:	ff 75 10             	pushl  0x10(%ebp)
  802583:	ff 75 0c             	pushl  0xc(%ebp)
  802586:	ff 75 08             	pushl  0x8(%ebp)
  802589:	6a 27                	push   $0x27
  80258b:	e8 17 fb ff ff       	call   8020a7 <syscall>
  802590:	83 c4 18             	add    $0x18,%esp
	return ;
  802593:	90                   	nop
}
  802594:	c9                   	leave  
  802595:	c3                   	ret    

00802596 <chktst>:
void chktst(uint32 n)
{
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	ff 75 08             	pushl  0x8(%ebp)
  8025a4:	6a 29                	push   $0x29
  8025a6:	e8 fc fa ff ff       	call   8020a7 <syscall>
  8025ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ae:	90                   	nop
}
  8025af:	c9                   	leave  
  8025b0:	c3                   	ret    

008025b1 <inctst>:

void inctst()
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 2a                	push   $0x2a
  8025c0:	e8 e2 fa ff ff       	call   8020a7 <syscall>
  8025c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c8:	90                   	nop
}
  8025c9:	c9                   	leave  
  8025ca:	c3                   	ret    

008025cb <gettst>:
uint32 gettst()
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 2b                	push   $0x2b
  8025da:	e8 c8 fa ff ff       	call   8020a7 <syscall>
  8025df:	83 c4 18             	add    $0x18,%esp
}
  8025e2:	c9                   	leave  
  8025e3:	c3                   	ret    

008025e4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025e4:	55                   	push   %ebp
  8025e5:	89 e5                	mov    %esp,%ebp
  8025e7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 2c                	push   $0x2c
  8025f6:	e8 ac fa ff ff       	call   8020a7 <syscall>
  8025fb:	83 c4 18             	add    $0x18,%esp
  8025fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802601:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802605:	75 07                	jne    80260e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802607:	b8 01 00 00 00       	mov    $0x1,%eax
  80260c:	eb 05                	jmp    802613 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80260e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802613:	c9                   	leave  
  802614:	c3                   	ret    

00802615 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802615:	55                   	push   %ebp
  802616:	89 e5                	mov    %esp,%ebp
  802618:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	6a 2c                	push   $0x2c
  802627:	e8 7b fa ff ff       	call   8020a7 <syscall>
  80262c:	83 c4 18             	add    $0x18,%esp
  80262f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802632:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802636:	75 07                	jne    80263f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802638:	b8 01 00 00 00       	mov    $0x1,%eax
  80263d:	eb 05                	jmp    802644 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80263f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802644:	c9                   	leave  
  802645:	c3                   	ret    

00802646 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802646:	55                   	push   %ebp
  802647:	89 e5                	mov    %esp,%ebp
  802649:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	6a 2c                	push   $0x2c
  802658:	e8 4a fa ff ff       	call   8020a7 <syscall>
  80265d:	83 c4 18             	add    $0x18,%esp
  802660:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802663:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802667:	75 07                	jne    802670 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802669:	b8 01 00 00 00       	mov    $0x1,%eax
  80266e:	eb 05                	jmp    802675 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802670:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802675:	c9                   	leave  
  802676:	c3                   	ret    

00802677 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802677:	55                   	push   %ebp
  802678:	89 e5                	mov    %esp,%ebp
  80267a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	6a 2c                	push   $0x2c
  802689:	e8 19 fa ff ff       	call   8020a7 <syscall>
  80268e:	83 c4 18             	add    $0x18,%esp
  802691:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802694:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802698:	75 07                	jne    8026a1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80269a:	b8 01 00 00 00       	mov    $0x1,%eax
  80269f:	eb 05                	jmp    8026a6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a6:	c9                   	leave  
  8026a7:	c3                   	ret    

008026a8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	ff 75 08             	pushl  0x8(%ebp)
  8026b6:	6a 2d                	push   $0x2d
  8026b8:	e8 ea f9 ff ff       	call   8020a7 <syscall>
  8026bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8026c0:	90                   	nop
}
  8026c1:	c9                   	leave  
  8026c2:	c3                   	ret    

008026c3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026c3:	55                   	push   %ebp
  8026c4:	89 e5                	mov    %esp,%ebp
  8026c6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d3:	6a 00                	push   $0x0
  8026d5:	53                   	push   %ebx
  8026d6:	51                   	push   %ecx
  8026d7:	52                   	push   %edx
  8026d8:	50                   	push   %eax
  8026d9:	6a 2e                	push   $0x2e
  8026db:	e8 c7 f9 ff ff       	call   8020a7 <syscall>
  8026e0:	83 c4 18             	add    $0x18,%esp
}
  8026e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f1:	6a 00                	push   $0x0
  8026f3:	6a 00                	push   $0x0
  8026f5:	6a 00                	push   $0x0
  8026f7:	52                   	push   %edx
  8026f8:	50                   	push   %eax
  8026f9:	6a 2f                	push   $0x2f
  8026fb:	e8 a7 f9 ff ff       	call   8020a7 <syscall>
  802700:	83 c4 18             	add    $0x18,%esp
}
  802703:	c9                   	leave  
  802704:	c3                   	ret    

00802705 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802705:	55                   	push   %ebp
  802706:	89 e5                	mov    %esp,%ebp
  802708:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80270b:	83 ec 0c             	sub    $0xc,%esp
  80270e:	68 a4 47 80 00       	push   $0x8047a4
  802713:	e8 46 e8 ff ff       	call   800f5e <cprintf>
  802718:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80271b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802722:	83 ec 0c             	sub    $0xc,%esp
  802725:	68 d0 47 80 00       	push   $0x8047d0
  80272a:	e8 2f e8 ff ff       	call   800f5e <cprintf>
  80272f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802732:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802736:	a1 38 51 80 00       	mov    0x805138,%eax
  80273b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273e:	eb 56                	jmp    802796 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802740:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802744:	74 1c                	je     802762 <print_mem_block_lists+0x5d>
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 50 08             	mov    0x8(%eax),%edx
  80274c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274f:	8b 48 08             	mov    0x8(%eax),%ecx
  802752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802755:	8b 40 0c             	mov    0xc(%eax),%eax
  802758:	01 c8                	add    %ecx,%eax
  80275a:	39 c2                	cmp    %eax,%edx
  80275c:	73 04                	jae    802762 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80275e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 50 08             	mov    0x8(%eax),%edx
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 0c             	mov    0xc(%eax),%eax
  80276e:	01 c2                	add    %eax,%edx
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 40 08             	mov    0x8(%eax),%eax
  802776:	83 ec 04             	sub    $0x4,%esp
  802779:	52                   	push   %edx
  80277a:	50                   	push   %eax
  80277b:	68 e5 47 80 00       	push   $0x8047e5
  802780:	e8 d9 e7 ff ff       	call   800f5e <cprintf>
  802785:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80278e:	a1 40 51 80 00       	mov    0x805140,%eax
  802793:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802796:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279a:	74 07                	je     8027a3 <print_mem_block_lists+0x9e>
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 00                	mov    (%eax),%eax
  8027a1:	eb 05                	jmp    8027a8 <print_mem_block_lists+0xa3>
  8027a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a8:	a3 40 51 80 00       	mov    %eax,0x805140
  8027ad:	a1 40 51 80 00       	mov    0x805140,%eax
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	75 8a                	jne    802740 <print_mem_block_lists+0x3b>
  8027b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ba:	75 84                	jne    802740 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8027bc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027c0:	75 10                	jne    8027d2 <print_mem_block_lists+0xcd>
  8027c2:	83 ec 0c             	sub    $0xc,%esp
  8027c5:	68 f4 47 80 00       	push   $0x8047f4
  8027ca:	e8 8f e7 ff ff       	call   800f5e <cprintf>
  8027cf:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8027d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8027d9:	83 ec 0c             	sub    $0xc,%esp
  8027dc:	68 18 48 80 00       	push   $0x804818
  8027e1:	e8 78 e7 ff ff       	call   800f5e <cprintf>
  8027e6:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8027e9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027ed:	a1 40 50 80 00       	mov    0x805040,%eax
  8027f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f5:	eb 56                	jmp    80284d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027fb:	74 1c                	je     802819 <print_mem_block_lists+0x114>
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 50 08             	mov    0x8(%eax),%edx
  802803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802806:	8b 48 08             	mov    0x8(%eax),%ecx
  802809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280c:	8b 40 0c             	mov    0xc(%eax),%eax
  80280f:	01 c8                	add    %ecx,%eax
  802811:	39 c2                	cmp    %eax,%edx
  802813:	73 04                	jae    802819 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802815:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	8b 50 08             	mov    0x8(%eax),%edx
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 40 0c             	mov    0xc(%eax),%eax
  802825:	01 c2                	add    %eax,%edx
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 40 08             	mov    0x8(%eax),%eax
  80282d:	83 ec 04             	sub    $0x4,%esp
  802830:	52                   	push   %edx
  802831:	50                   	push   %eax
  802832:	68 e5 47 80 00       	push   $0x8047e5
  802837:	e8 22 e7 ff ff       	call   800f5e <cprintf>
  80283c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802845:	a1 48 50 80 00       	mov    0x805048,%eax
  80284a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80284d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802851:	74 07                	je     80285a <print_mem_block_lists+0x155>
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 00                	mov    (%eax),%eax
  802858:	eb 05                	jmp    80285f <print_mem_block_lists+0x15a>
  80285a:	b8 00 00 00 00       	mov    $0x0,%eax
  80285f:	a3 48 50 80 00       	mov    %eax,0x805048
  802864:	a1 48 50 80 00       	mov    0x805048,%eax
  802869:	85 c0                	test   %eax,%eax
  80286b:	75 8a                	jne    8027f7 <print_mem_block_lists+0xf2>
  80286d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802871:	75 84                	jne    8027f7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802873:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802877:	75 10                	jne    802889 <print_mem_block_lists+0x184>
  802879:	83 ec 0c             	sub    $0xc,%esp
  80287c:	68 30 48 80 00       	push   $0x804830
  802881:	e8 d8 e6 ff ff       	call   800f5e <cprintf>
  802886:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802889:	83 ec 0c             	sub    $0xc,%esp
  80288c:	68 a4 47 80 00       	push   $0x8047a4
  802891:	e8 c8 e6 ff ff       	call   800f5e <cprintf>
  802896:	83 c4 10             	add    $0x10,%esp

}
  802899:	90                   	nop
  80289a:	c9                   	leave  
  80289b:	c3                   	ret    

0080289c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80289c:	55                   	push   %ebp
  80289d:	89 e5                	mov    %esp,%ebp
  80289f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8028a2:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8028a9:	00 00 00 
  8028ac:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8028b3:	00 00 00 
  8028b6:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8028bd:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8028c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028c7:	e9 9e 00 00 00       	jmp    80296a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8028cc:	a1 50 50 80 00       	mov    0x805050,%eax
  8028d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d4:	c1 e2 04             	shl    $0x4,%edx
  8028d7:	01 d0                	add    %edx,%eax
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	75 14                	jne    8028f1 <initialize_MemBlocksList+0x55>
  8028dd:	83 ec 04             	sub    $0x4,%esp
  8028e0:	68 58 48 80 00       	push   $0x804858
  8028e5:	6a 46                	push   $0x46
  8028e7:	68 7b 48 80 00       	push   $0x80487b
  8028ec:	e8 b9 e3 ff ff       	call   800caa <_panic>
  8028f1:	a1 50 50 80 00       	mov    0x805050,%eax
  8028f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f9:	c1 e2 04             	shl    $0x4,%edx
  8028fc:	01 d0                	add    %edx,%eax
  8028fe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802904:	89 10                	mov    %edx,(%eax)
  802906:	8b 00                	mov    (%eax),%eax
  802908:	85 c0                	test   %eax,%eax
  80290a:	74 18                	je     802924 <initialize_MemBlocksList+0x88>
  80290c:	a1 48 51 80 00       	mov    0x805148,%eax
  802911:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802917:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80291a:	c1 e1 04             	shl    $0x4,%ecx
  80291d:	01 ca                	add    %ecx,%edx
  80291f:	89 50 04             	mov    %edx,0x4(%eax)
  802922:	eb 12                	jmp    802936 <initialize_MemBlocksList+0x9a>
  802924:	a1 50 50 80 00       	mov    0x805050,%eax
  802929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292c:	c1 e2 04             	shl    $0x4,%edx
  80292f:	01 d0                	add    %edx,%eax
  802931:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802936:	a1 50 50 80 00       	mov    0x805050,%eax
  80293b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293e:	c1 e2 04             	shl    $0x4,%edx
  802941:	01 d0                	add    %edx,%eax
  802943:	a3 48 51 80 00       	mov    %eax,0x805148
  802948:	a1 50 50 80 00       	mov    0x805050,%eax
  80294d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802950:	c1 e2 04             	shl    $0x4,%edx
  802953:	01 d0                	add    %edx,%eax
  802955:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295c:	a1 54 51 80 00       	mov    0x805154,%eax
  802961:	40                   	inc    %eax
  802962:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802967:	ff 45 f4             	incl   -0xc(%ebp)
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802970:	0f 82 56 ff ff ff    	jb     8028cc <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802976:	90                   	nop
  802977:	c9                   	leave  
  802978:	c3                   	ret    

00802979 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802979:	55                   	push   %ebp
  80297a:	89 e5                	mov    %esp,%ebp
  80297c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	8b 00                	mov    (%eax),%eax
  802984:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802987:	eb 19                	jmp    8029a2 <find_block+0x29>
	{
		if(va==point->sva)
  802989:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80298c:	8b 40 08             	mov    0x8(%eax),%eax
  80298f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802992:	75 05                	jne    802999 <find_block+0x20>
		   return point;
  802994:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802997:	eb 36                	jmp    8029cf <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	8b 40 08             	mov    0x8(%eax),%eax
  80299f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8029a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029a6:	74 07                	je     8029af <find_block+0x36>
  8029a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029ab:	8b 00                	mov    (%eax),%eax
  8029ad:	eb 05                	jmp    8029b4 <find_block+0x3b>
  8029af:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b7:	89 42 08             	mov    %eax,0x8(%edx)
  8029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bd:	8b 40 08             	mov    0x8(%eax),%eax
  8029c0:	85 c0                	test   %eax,%eax
  8029c2:	75 c5                	jne    802989 <find_block+0x10>
  8029c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029c8:	75 bf                	jne    802989 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8029ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029cf:	c9                   	leave  
  8029d0:	c3                   	ret    

008029d1 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8029d1:	55                   	push   %ebp
  8029d2:	89 e5                	mov    %esp,%ebp
  8029d4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8029d7:	a1 40 50 80 00       	mov    0x805040,%eax
  8029dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8029df:	a1 44 50 80 00       	mov    0x805044,%eax
  8029e4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8029e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029ed:	74 24                	je     802a13 <insert_sorted_allocList+0x42>
  8029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f2:	8b 50 08             	mov    0x8(%eax),%edx
  8029f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f8:	8b 40 08             	mov    0x8(%eax),%eax
  8029fb:	39 c2                	cmp    %eax,%edx
  8029fd:	76 14                	jbe    802a13 <insert_sorted_allocList+0x42>
  8029ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802a02:	8b 50 08             	mov    0x8(%eax),%edx
  802a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a08:	8b 40 08             	mov    0x8(%eax),%eax
  802a0b:	39 c2                	cmp    %eax,%edx
  802a0d:	0f 82 60 01 00 00    	jb     802b73 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802a13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a17:	75 65                	jne    802a7e <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802a19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a1d:	75 14                	jne    802a33 <insert_sorted_allocList+0x62>
  802a1f:	83 ec 04             	sub    $0x4,%esp
  802a22:	68 58 48 80 00       	push   $0x804858
  802a27:	6a 6b                	push   $0x6b
  802a29:	68 7b 48 80 00       	push   $0x80487b
  802a2e:	e8 77 e2 ff ff       	call   800caa <_panic>
  802a33:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	89 10                	mov    %edx,(%eax)
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	8b 00                	mov    (%eax),%eax
  802a43:	85 c0                	test   %eax,%eax
  802a45:	74 0d                	je     802a54 <insert_sorted_allocList+0x83>
  802a47:	a1 40 50 80 00       	mov    0x805040,%eax
  802a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4f:	89 50 04             	mov    %edx,0x4(%eax)
  802a52:	eb 08                	jmp    802a5c <insert_sorted_allocList+0x8b>
  802a54:	8b 45 08             	mov    0x8(%ebp),%eax
  802a57:	a3 44 50 80 00       	mov    %eax,0x805044
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	a3 40 50 80 00       	mov    %eax,0x805040
  802a64:	8b 45 08             	mov    0x8(%ebp),%eax
  802a67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a6e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a73:	40                   	inc    %eax
  802a74:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a79:	e9 dc 01 00 00       	jmp    802c5a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a81:	8b 50 08             	mov    0x8(%eax),%edx
  802a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a87:	8b 40 08             	mov    0x8(%eax),%eax
  802a8a:	39 c2                	cmp    %eax,%edx
  802a8c:	77 6c                	ja     802afa <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802a8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a92:	74 06                	je     802a9a <insert_sorted_allocList+0xc9>
  802a94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a98:	75 14                	jne    802aae <insert_sorted_allocList+0xdd>
  802a9a:	83 ec 04             	sub    $0x4,%esp
  802a9d:	68 94 48 80 00       	push   $0x804894
  802aa2:	6a 6f                	push   $0x6f
  802aa4:	68 7b 48 80 00       	push   $0x80487b
  802aa9:	e8 fc e1 ff ff       	call   800caa <_panic>
  802aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab1:	8b 50 04             	mov    0x4(%eax),%edx
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	89 50 04             	mov    %edx,0x4(%eax)
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ac0:	89 10                	mov    %edx,(%eax)
  802ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac5:	8b 40 04             	mov    0x4(%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 0d                	je     802ad9 <insert_sorted_allocList+0x108>
  802acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acf:	8b 40 04             	mov    0x4(%eax),%eax
  802ad2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad5:	89 10                	mov    %edx,(%eax)
  802ad7:	eb 08                	jmp    802ae1 <insert_sorted_allocList+0x110>
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	a3 40 50 80 00       	mov    %eax,0x805040
  802ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae7:	89 50 04             	mov    %edx,0x4(%eax)
  802aea:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802aef:	40                   	inc    %eax
  802af0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802af5:	e9 60 01 00 00       	jmp    802c5a <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802afa:	8b 45 08             	mov    0x8(%ebp),%eax
  802afd:	8b 50 08             	mov    0x8(%eax),%edx
  802b00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b03:	8b 40 08             	mov    0x8(%eax),%eax
  802b06:	39 c2                	cmp    %eax,%edx
  802b08:	0f 82 4c 01 00 00    	jb     802c5a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802b0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b12:	75 14                	jne    802b28 <insert_sorted_allocList+0x157>
  802b14:	83 ec 04             	sub    $0x4,%esp
  802b17:	68 cc 48 80 00       	push   $0x8048cc
  802b1c:	6a 73                	push   $0x73
  802b1e:	68 7b 48 80 00       	push   $0x80487b
  802b23:	e8 82 e1 ff ff       	call   800caa <_panic>
  802b28:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b31:	89 50 04             	mov    %edx,0x4(%eax)
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	8b 40 04             	mov    0x4(%eax),%eax
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	74 0c                	je     802b4a <insert_sorted_allocList+0x179>
  802b3e:	a1 44 50 80 00       	mov    0x805044,%eax
  802b43:	8b 55 08             	mov    0x8(%ebp),%edx
  802b46:	89 10                	mov    %edx,(%eax)
  802b48:	eb 08                	jmp    802b52 <insert_sorted_allocList+0x181>
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	a3 40 50 80 00       	mov    %eax,0x805040
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	a3 44 50 80 00       	mov    %eax,0x805044
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b63:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b68:	40                   	inc    %eax
  802b69:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b6e:	e9 e7 00 00 00       	jmp    802c5a <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802b79:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b80:	a1 40 50 80 00       	mov    0x805040,%eax
  802b85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b88:	e9 9d 00 00 00       	jmp    802c2a <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802b95:	8b 45 08             	mov    0x8(%ebp),%eax
  802b98:	8b 50 08             	mov    0x8(%eax),%edx
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 40 08             	mov    0x8(%eax),%eax
  802ba1:	39 c2                	cmp    %eax,%edx
  802ba3:	76 7d                	jbe    802c22 <insert_sorted_allocList+0x251>
  802ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba8:	8b 50 08             	mov    0x8(%eax),%edx
  802bab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bae:	8b 40 08             	mov    0x8(%eax),%eax
  802bb1:	39 c2                	cmp    %eax,%edx
  802bb3:	73 6d                	jae    802c22 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802bb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb9:	74 06                	je     802bc1 <insert_sorted_allocList+0x1f0>
  802bbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bbf:	75 14                	jne    802bd5 <insert_sorted_allocList+0x204>
  802bc1:	83 ec 04             	sub    $0x4,%esp
  802bc4:	68 f0 48 80 00       	push   $0x8048f0
  802bc9:	6a 7f                	push   $0x7f
  802bcb:	68 7b 48 80 00       	push   $0x80487b
  802bd0:	e8 d5 e0 ff ff       	call   800caa <_panic>
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 10                	mov    (%eax),%edx
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	89 10                	mov    %edx,(%eax)
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	8b 00                	mov    (%eax),%eax
  802be4:	85 c0                	test   %eax,%eax
  802be6:	74 0b                	je     802bf3 <insert_sorted_allocList+0x222>
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 00                	mov    (%eax),%eax
  802bed:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf0:	89 50 04             	mov    %edx,0x4(%eax)
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf9:	89 10                	mov    %edx,(%eax)
  802bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c01:	89 50 04             	mov    %edx,0x4(%eax)
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	8b 00                	mov    (%eax),%eax
  802c09:	85 c0                	test   %eax,%eax
  802c0b:	75 08                	jne    802c15 <insert_sorted_allocList+0x244>
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	a3 44 50 80 00       	mov    %eax,0x805044
  802c15:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c1a:	40                   	inc    %eax
  802c1b:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802c20:	eb 39                	jmp    802c5b <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802c22:	a1 48 50 80 00       	mov    0x805048,%eax
  802c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2e:	74 07                	je     802c37 <insert_sorted_allocList+0x266>
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 00                	mov    (%eax),%eax
  802c35:	eb 05                	jmp    802c3c <insert_sorted_allocList+0x26b>
  802c37:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3c:	a3 48 50 80 00       	mov    %eax,0x805048
  802c41:	a1 48 50 80 00       	mov    0x805048,%eax
  802c46:	85 c0                	test   %eax,%eax
  802c48:	0f 85 3f ff ff ff    	jne    802b8d <insert_sorted_allocList+0x1bc>
  802c4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c52:	0f 85 35 ff ff ff    	jne    802b8d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c58:	eb 01                	jmp    802c5b <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c5a:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c5b:	90                   	nop
  802c5c:	c9                   	leave  
  802c5d:	c3                   	ret    

00802c5e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c5e:	55                   	push   %ebp
  802c5f:	89 e5                	mov    %esp,%ebp
  802c61:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c64:	a1 38 51 80 00       	mov    0x805138,%eax
  802c69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6c:	e9 85 01 00 00       	jmp    802df6 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	8b 40 0c             	mov    0xc(%eax),%eax
  802c77:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c7a:	0f 82 6e 01 00 00    	jb     802dee <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	8b 40 0c             	mov    0xc(%eax),%eax
  802c86:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c89:	0f 85 8a 00 00 00    	jne    802d19 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802c8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c93:	75 17                	jne    802cac <alloc_block_FF+0x4e>
  802c95:	83 ec 04             	sub    $0x4,%esp
  802c98:	68 24 49 80 00       	push   $0x804924
  802c9d:	68 93 00 00 00       	push   $0x93
  802ca2:	68 7b 48 80 00       	push   $0x80487b
  802ca7:	e8 fe df ff ff       	call   800caa <_panic>
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 00                	mov    (%eax),%eax
  802cb1:	85 c0                	test   %eax,%eax
  802cb3:	74 10                	je     802cc5 <alloc_block_FF+0x67>
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	8b 00                	mov    (%eax),%eax
  802cba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cbd:	8b 52 04             	mov    0x4(%edx),%edx
  802cc0:	89 50 04             	mov    %edx,0x4(%eax)
  802cc3:	eb 0b                	jmp    802cd0 <alloc_block_FF+0x72>
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 40 04             	mov    0x4(%eax),%eax
  802ccb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	8b 40 04             	mov    0x4(%eax),%eax
  802cd6:	85 c0                	test   %eax,%eax
  802cd8:	74 0f                	je     802ce9 <alloc_block_FF+0x8b>
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 40 04             	mov    0x4(%eax),%eax
  802ce0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce3:	8b 12                	mov    (%edx),%edx
  802ce5:	89 10                	mov    %edx,(%eax)
  802ce7:	eb 0a                	jmp    802cf3 <alloc_block_FF+0x95>
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 00                	mov    (%eax),%eax
  802cee:	a3 38 51 80 00       	mov    %eax,0x805138
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d06:	a1 44 51 80 00       	mov    0x805144,%eax
  802d0b:	48                   	dec    %eax
  802d0c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	e9 10 01 00 00       	jmp    802e29 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d22:	0f 86 c6 00 00 00    	jbe    802dee <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d28:	a1 48 51 80 00       	mov    0x805148,%eax
  802d2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	8b 50 08             	mov    0x8(%eax),%edx
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d39:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d42:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d49:	75 17                	jne    802d62 <alloc_block_FF+0x104>
  802d4b:	83 ec 04             	sub    $0x4,%esp
  802d4e:	68 24 49 80 00       	push   $0x804924
  802d53:	68 9b 00 00 00       	push   $0x9b
  802d58:	68 7b 48 80 00       	push   $0x80487b
  802d5d:	e8 48 df ff ff       	call   800caa <_panic>
  802d62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d65:	8b 00                	mov    (%eax),%eax
  802d67:	85 c0                	test   %eax,%eax
  802d69:	74 10                	je     802d7b <alloc_block_FF+0x11d>
  802d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6e:	8b 00                	mov    (%eax),%eax
  802d70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d73:	8b 52 04             	mov    0x4(%edx),%edx
  802d76:	89 50 04             	mov    %edx,0x4(%eax)
  802d79:	eb 0b                	jmp    802d86 <alloc_block_FF+0x128>
  802d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7e:	8b 40 04             	mov    0x4(%eax),%eax
  802d81:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d89:	8b 40 04             	mov    0x4(%eax),%eax
  802d8c:	85 c0                	test   %eax,%eax
  802d8e:	74 0f                	je     802d9f <alloc_block_FF+0x141>
  802d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d93:	8b 40 04             	mov    0x4(%eax),%eax
  802d96:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d99:	8b 12                	mov    (%edx),%edx
  802d9b:	89 10                	mov    %edx,(%eax)
  802d9d:	eb 0a                	jmp    802da9 <alloc_block_FF+0x14b>
  802d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da2:	8b 00                	mov    (%eax),%eax
  802da4:	a3 48 51 80 00       	mov    %eax,0x805148
  802da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbc:	a1 54 51 80 00       	mov    0x805154,%eax
  802dc1:	48                   	dec    %eax
  802dc2:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 50 08             	mov    0x8(%eax),%edx
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	01 c2                	add    %eax,%edx
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dde:	2b 45 08             	sub    0x8(%ebp),%eax
  802de1:	89 c2                	mov    %eax,%edx
  802de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de6:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dec:	eb 3b                	jmp    802e29 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802dee:	a1 40 51 80 00       	mov    0x805140,%eax
  802df3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfa:	74 07                	je     802e03 <alloc_block_FF+0x1a5>
  802dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dff:	8b 00                	mov    (%eax),%eax
  802e01:	eb 05                	jmp    802e08 <alloc_block_FF+0x1aa>
  802e03:	b8 00 00 00 00       	mov    $0x0,%eax
  802e08:	a3 40 51 80 00       	mov    %eax,0x805140
  802e0d:	a1 40 51 80 00       	mov    0x805140,%eax
  802e12:	85 c0                	test   %eax,%eax
  802e14:	0f 85 57 fe ff ff    	jne    802c71 <alloc_block_FF+0x13>
  802e1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e1e:	0f 85 4d fe ff ff    	jne    802c71 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802e24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e29:	c9                   	leave  
  802e2a:	c3                   	ret    

00802e2b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e2b:	55                   	push   %ebp
  802e2c:	89 e5                	mov    %esp,%ebp
  802e2e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802e31:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802e38:	a1 38 51 80 00       	mov    0x805138,%eax
  802e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e40:	e9 df 00 00 00       	jmp    802f24 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e4e:	0f 82 c8 00 00 00    	jb     802f1c <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e5d:	0f 85 8a 00 00 00    	jne    802eed <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802e63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e67:	75 17                	jne    802e80 <alloc_block_BF+0x55>
  802e69:	83 ec 04             	sub    $0x4,%esp
  802e6c:	68 24 49 80 00       	push   $0x804924
  802e71:	68 b7 00 00 00       	push   $0xb7
  802e76:	68 7b 48 80 00       	push   $0x80487b
  802e7b:	e8 2a de ff ff       	call   800caa <_panic>
  802e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e83:	8b 00                	mov    (%eax),%eax
  802e85:	85 c0                	test   %eax,%eax
  802e87:	74 10                	je     802e99 <alloc_block_BF+0x6e>
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	8b 00                	mov    (%eax),%eax
  802e8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e91:	8b 52 04             	mov    0x4(%edx),%edx
  802e94:	89 50 04             	mov    %edx,0x4(%eax)
  802e97:	eb 0b                	jmp    802ea4 <alloc_block_BF+0x79>
  802e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9c:	8b 40 04             	mov    0x4(%eax),%eax
  802e9f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	8b 40 04             	mov    0x4(%eax),%eax
  802eaa:	85 c0                	test   %eax,%eax
  802eac:	74 0f                	je     802ebd <alloc_block_BF+0x92>
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	8b 40 04             	mov    0x4(%eax),%eax
  802eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb7:	8b 12                	mov    (%edx),%edx
  802eb9:	89 10                	mov    %edx,(%eax)
  802ebb:	eb 0a                	jmp    802ec7 <alloc_block_BF+0x9c>
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	8b 00                	mov    (%eax),%eax
  802ec2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eda:	a1 44 51 80 00       	mov    0x805144,%eax
  802edf:	48                   	dec    %eax
  802ee0:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee8:	e9 4d 01 00 00       	jmp    80303a <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ef6:	76 24                	jbe    802f1c <alloc_block_BF+0xf1>
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 40 0c             	mov    0xc(%eax),%eax
  802efe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f01:	73 19                	jae    802f1c <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802f03:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f10:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f16:	8b 40 08             	mov    0x8(%eax),%eax
  802f19:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802f1c:	a1 40 51 80 00       	mov    0x805140,%eax
  802f21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f28:	74 07                	je     802f31 <alloc_block_BF+0x106>
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	eb 05                	jmp    802f36 <alloc_block_BF+0x10b>
  802f31:	b8 00 00 00 00       	mov    $0x0,%eax
  802f36:	a3 40 51 80 00       	mov    %eax,0x805140
  802f3b:	a1 40 51 80 00       	mov    0x805140,%eax
  802f40:	85 c0                	test   %eax,%eax
  802f42:	0f 85 fd fe ff ff    	jne    802e45 <alloc_block_BF+0x1a>
  802f48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4c:	0f 85 f3 fe ff ff    	jne    802e45 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802f52:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f56:	0f 84 d9 00 00 00    	je     803035 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f5c:	a1 48 51 80 00       	mov    0x805148,%eax
  802f61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f67:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f6a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802f6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f70:	8b 55 08             	mov    0x8(%ebp),%edx
  802f73:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802f76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f7a:	75 17                	jne    802f93 <alloc_block_BF+0x168>
  802f7c:	83 ec 04             	sub    $0x4,%esp
  802f7f:	68 24 49 80 00       	push   $0x804924
  802f84:	68 c7 00 00 00       	push   $0xc7
  802f89:	68 7b 48 80 00       	push   $0x80487b
  802f8e:	e8 17 dd ff ff       	call   800caa <_panic>
  802f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f96:	8b 00                	mov    (%eax),%eax
  802f98:	85 c0                	test   %eax,%eax
  802f9a:	74 10                	je     802fac <alloc_block_BF+0x181>
  802f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9f:	8b 00                	mov    (%eax),%eax
  802fa1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fa4:	8b 52 04             	mov    0x4(%edx),%edx
  802fa7:	89 50 04             	mov    %edx,0x4(%eax)
  802faa:	eb 0b                	jmp    802fb7 <alloc_block_BF+0x18c>
  802fac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802faf:	8b 40 04             	mov    0x4(%eax),%eax
  802fb2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fba:	8b 40 04             	mov    0x4(%eax),%eax
  802fbd:	85 c0                	test   %eax,%eax
  802fbf:	74 0f                	je     802fd0 <alloc_block_BF+0x1a5>
  802fc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc4:	8b 40 04             	mov    0x4(%eax),%eax
  802fc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fca:	8b 12                	mov    (%edx),%edx
  802fcc:	89 10                	mov    %edx,(%eax)
  802fce:	eb 0a                	jmp    802fda <alloc_block_BF+0x1af>
  802fd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd3:	8b 00                	mov    (%eax),%eax
  802fd5:	a3 48 51 80 00       	mov    %eax,0x805148
  802fda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fdd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fed:	a1 54 51 80 00       	mov    0x805154,%eax
  802ff2:	48                   	dec    %eax
  802ff3:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802ff8:	83 ec 08             	sub    $0x8,%esp
  802ffb:	ff 75 ec             	pushl  -0x14(%ebp)
  802ffe:	68 38 51 80 00       	push   $0x805138
  803003:	e8 71 f9 ff ff       	call   802979 <find_block>
  803008:	83 c4 10             	add    $0x10,%esp
  80300b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80300e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803011:	8b 50 08             	mov    0x8(%eax),%edx
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	01 c2                	add    %eax,%edx
  803019:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301c:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80301f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803022:	8b 40 0c             	mov    0xc(%eax),%eax
  803025:	2b 45 08             	sub    0x8(%ebp),%eax
  803028:	89 c2                	mov    %eax,%edx
  80302a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80302d:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803030:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803033:	eb 05                	jmp    80303a <alloc_block_BF+0x20f>
	}
	return NULL;
  803035:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80303a:	c9                   	leave  
  80303b:	c3                   	ret    

0080303c <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80303c:	55                   	push   %ebp
  80303d:	89 e5                	mov    %esp,%ebp
  80303f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803042:	a1 28 50 80 00       	mov    0x805028,%eax
  803047:	85 c0                	test   %eax,%eax
  803049:	0f 85 de 01 00 00    	jne    80322d <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80304f:	a1 38 51 80 00       	mov    0x805138,%eax
  803054:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803057:	e9 9e 01 00 00       	jmp    8031fa <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	8b 40 0c             	mov    0xc(%eax),%eax
  803062:	3b 45 08             	cmp    0x8(%ebp),%eax
  803065:	0f 82 87 01 00 00    	jb     8031f2 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80306b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306e:	8b 40 0c             	mov    0xc(%eax),%eax
  803071:	3b 45 08             	cmp    0x8(%ebp),%eax
  803074:	0f 85 95 00 00 00    	jne    80310f <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80307a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307e:	75 17                	jne    803097 <alloc_block_NF+0x5b>
  803080:	83 ec 04             	sub    $0x4,%esp
  803083:	68 24 49 80 00       	push   $0x804924
  803088:	68 e0 00 00 00       	push   $0xe0
  80308d:	68 7b 48 80 00       	push   $0x80487b
  803092:	e8 13 dc ff ff       	call   800caa <_panic>
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	8b 00                	mov    (%eax),%eax
  80309c:	85 c0                	test   %eax,%eax
  80309e:	74 10                	je     8030b0 <alloc_block_NF+0x74>
  8030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a8:	8b 52 04             	mov    0x4(%edx),%edx
  8030ab:	89 50 04             	mov    %edx,0x4(%eax)
  8030ae:	eb 0b                	jmp    8030bb <alloc_block_NF+0x7f>
  8030b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b3:	8b 40 04             	mov    0x4(%eax),%eax
  8030b6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030be:	8b 40 04             	mov    0x4(%eax),%eax
  8030c1:	85 c0                	test   %eax,%eax
  8030c3:	74 0f                	je     8030d4 <alloc_block_NF+0x98>
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	8b 40 04             	mov    0x4(%eax),%eax
  8030cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ce:	8b 12                	mov    (%edx),%edx
  8030d0:	89 10                	mov    %edx,(%eax)
  8030d2:	eb 0a                	jmp    8030de <alloc_block_NF+0xa2>
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	a3 38 51 80 00       	mov    %eax,0x805138
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f1:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f6:	48                   	dec    %eax
  8030f7:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	8b 40 08             	mov    0x8(%eax),%eax
  803102:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  803107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310a:	e9 f8 04 00 00       	jmp    803607 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	8b 40 0c             	mov    0xc(%eax),%eax
  803115:	3b 45 08             	cmp    0x8(%ebp),%eax
  803118:	0f 86 d4 00 00 00    	jbe    8031f2 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80311e:	a1 48 51 80 00       	mov    0x805148,%eax
  803123:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803129:	8b 50 08             	mov    0x8(%eax),%edx
  80312c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312f:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803132:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803135:	8b 55 08             	mov    0x8(%ebp),%edx
  803138:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80313b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80313f:	75 17                	jne    803158 <alloc_block_NF+0x11c>
  803141:	83 ec 04             	sub    $0x4,%esp
  803144:	68 24 49 80 00       	push   $0x804924
  803149:	68 e9 00 00 00       	push   $0xe9
  80314e:	68 7b 48 80 00       	push   $0x80487b
  803153:	e8 52 db ff ff       	call   800caa <_panic>
  803158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	74 10                	je     803171 <alloc_block_NF+0x135>
  803161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803164:	8b 00                	mov    (%eax),%eax
  803166:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803169:	8b 52 04             	mov    0x4(%edx),%edx
  80316c:	89 50 04             	mov    %edx,0x4(%eax)
  80316f:	eb 0b                	jmp    80317c <alloc_block_NF+0x140>
  803171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803174:	8b 40 04             	mov    0x4(%eax),%eax
  803177:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80317c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317f:	8b 40 04             	mov    0x4(%eax),%eax
  803182:	85 c0                	test   %eax,%eax
  803184:	74 0f                	je     803195 <alloc_block_NF+0x159>
  803186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803189:	8b 40 04             	mov    0x4(%eax),%eax
  80318c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80318f:	8b 12                	mov    (%edx),%edx
  803191:	89 10                	mov    %edx,(%eax)
  803193:	eb 0a                	jmp    80319f <alloc_block_NF+0x163>
  803195:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803198:	8b 00                	mov    (%eax),%eax
  80319a:	a3 48 51 80 00       	mov    %eax,0x805148
  80319f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b2:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b7:	48                   	dec    %eax
  8031b8:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8031bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c0:	8b 40 08             	mov    0x8(%eax),%eax
  8031c3:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cb:	8b 50 08             	mov    0x8(%eax),%edx
  8031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d1:	01 c2                	add    %eax,%edx
  8031d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d6:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8031d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031df:	2b 45 08             	sub    0x8(%ebp),%eax
  8031e2:	89 c2                	mov    %eax,%edx
  8031e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e7:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8031ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ed:	e9 15 04 00 00       	jmp    803607 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8031f2:	a1 40 51 80 00       	mov    0x805140,%eax
  8031f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031fe:	74 07                	je     803207 <alloc_block_NF+0x1cb>
  803200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803203:	8b 00                	mov    (%eax),%eax
  803205:	eb 05                	jmp    80320c <alloc_block_NF+0x1d0>
  803207:	b8 00 00 00 00       	mov    $0x0,%eax
  80320c:	a3 40 51 80 00       	mov    %eax,0x805140
  803211:	a1 40 51 80 00       	mov    0x805140,%eax
  803216:	85 c0                	test   %eax,%eax
  803218:	0f 85 3e fe ff ff    	jne    80305c <alloc_block_NF+0x20>
  80321e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803222:	0f 85 34 fe ff ff    	jne    80305c <alloc_block_NF+0x20>
  803228:	e9 d5 03 00 00       	jmp    803602 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80322d:	a1 38 51 80 00       	mov    0x805138,%eax
  803232:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803235:	e9 b1 01 00 00       	jmp    8033eb <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80323a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323d:	8b 50 08             	mov    0x8(%eax),%edx
  803240:	a1 28 50 80 00       	mov    0x805028,%eax
  803245:	39 c2                	cmp    %eax,%edx
  803247:	0f 82 96 01 00 00    	jb     8033e3 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	8b 40 0c             	mov    0xc(%eax),%eax
  803253:	3b 45 08             	cmp    0x8(%ebp),%eax
  803256:	0f 82 87 01 00 00    	jb     8033e3 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80325c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325f:	8b 40 0c             	mov    0xc(%eax),%eax
  803262:	3b 45 08             	cmp    0x8(%ebp),%eax
  803265:	0f 85 95 00 00 00    	jne    803300 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80326b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326f:	75 17                	jne    803288 <alloc_block_NF+0x24c>
  803271:	83 ec 04             	sub    $0x4,%esp
  803274:	68 24 49 80 00       	push   $0x804924
  803279:	68 fc 00 00 00       	push   $0xfc
  80327e:	68 7b 48 80 00       	push   $0x80487b
  803283:	e8 22 da ff ff       	call   800caa <_panic>
  803288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328b:	8b 00                	mov    (%eax),%eax
  80328d:	85 c0                	test   %eax,%eax
  80328f:	74 10                	je     8032a1 <alloc_block_NF+0x265>
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	8b 00                	mov    (%eax),%eax
  803296:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803299:	8b 52 04             	mov    0x4(%edx),%edx
  80329c:	89 50 04             	mov    %edx,0x4(%eax)
  80329f:	eb 0b                	jmp    8032ac <alloc_block_NF+0x270>
  8032a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a4:	8b 40 04             	mov    0x4(%eax),%eax
  8032a7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032af:	8b 40 04             	mov    0x4(%eax),%eax
  8032b2:	85 c0                	test   %eax,%eax
  8032b4:	74 0f                	je     8032c5 <alloc_block_NF+0x289>
  8032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b9:	8b 40 04             	mov    0x4(%eax),%eax
  8032bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032bf:	8b 12                	mov    (%edx),%edx
  8032c1:	89 10                	mov    %edx,(%eax)
  8032c3:	eb 0a                	jmp    8032cf <alloc_block_NF+0x293>
  8032c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c8:	8b 00                	mov    (%eax),%eax
  8032ca:	a3 38 51 80 00       	mov    %eax,0x805138
  8032cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e2:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e7:	48                   	dec    %eax
  8032e8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f0:	8b 40 08             	mov    0x8(%eax),%eax
  8032f3:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8032f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fb:	e9 07 03 00 00       	jmp    803607 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803303:	8b 40 0c             	mov    0xc(%eax),%eax
  803306:	3b 45 08             	cmp    0x8(%ebp),%eax
  803309:	0f 86 d4 00 00 00    	jbe    8033e3 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80330f:	a1 48 51 80 00       	mov    0x805148,%eax
  803314:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331a:	8b 50 08             	mov    0x8(%eax),%edx
  80331d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803320:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803326:	8b 55 08             	mov    0x8(%ebp),%edx
  803329:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80332c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803330:	75 17                	jne    803349 <alloc_block_NF+0x30d>
  803332:	83 ec 04             	sub    $0x4,%esp
  803335:	68 24 49 80 00       	push   $0x804924
  80333a:	68 04 01 00 00       	push   $0x104
  80333f:	68 7b 48 80 00       	push   $0x80487b
  803344:	e8 61 d9 ff ff       	call   800caa <_panic>
  803349:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334c:	8b 00                	mov    (%eax),%eax
  80334e:	85 c0                	test   %eax,%eax
  803350:	74 10                	je     803362 <alloc_block_NF+0x326>
  803352:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803355:	8b 00                	mov    (%eax),%eax
  803357:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80335a:	8b 52 04             	mov    0x4(%edx),%edx
  80335d:	89 50 04             	mov    %edx,0x4(%eax)
  803360:	eb 0b                	jmp    80336d <alloc_block_NF+0x331>
  803362:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803365:	8b 40 04             	mov    0x4(%eax),%eax
  803368:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80336d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803370:	8b 40 04             	mov    0x4(%eax),%eax
  803373:	85 c0                	test   %eax,%eax
  803375:	74 0f                	je     803386 <alloc_block_NF+0x34a>
  803377:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337a:	8b 40 04             	mov    0x4(%eax),%eax
  80337d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803380:	8b 12                	mov    (%edx),%edx
  803382:	89 10                	mov    %edx,(%eax)
  803384:	eb 0a                	jmp    803390 <alloc_block_NF+0x354>
  803386:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803389:	8b 00                	mov    (%eax),%eax
  80338b:	a3 48 51 80 00       	mov    %eax,0x805148
  803390:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803393:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803399:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a3:	a1 54 51 80 00       	mov    0x805154,%eax
  8033a8:	48                   	dec    %eax
  8033a9:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8033ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b1:	8b 40 08             	mov    0x8(%eax),%eax
  8033b4:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8033b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bc:	8b 50 08             	mov    0x8(%eax),%edx
  8033bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c2:	01 c2                	add    %eax,%edx
  8033c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8033ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d0:	2b 45 08             	sub    0x8(%ebp),%eax
  8033d3:	89 c2                	mov    %eax,%edx
  8033d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033de:	e9 24 02 00 00       	jmp    803607 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033e3:	a1 40 51 80 00       	mov    0x805140,%eax
  8033e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ef:	74 07                	je     8033f8 <alloc_block_NF+0x3bc>
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	8b 00                	mov    (%eax),%eax
  8033f6:	eb 05                	jmp    8033fd <alloc_block_NF+0x3c1>
  8033f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8033fd:	a3 40 51 80 00       	mov    %eax,0x805140
  803402:	a1 40 51 80 00       	mov    0x805140,%eax
  803407:	85 c0                	test   %eax,%eax
  803409:	0f 85 2b fe ff ff    	jne    80323a <alloc_block_NF+0x1fe>
  80340f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803413:	0f 85 21 fe ff ff    	jne    80323a <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803419:	a1 38 51 80 00       	mov    0x805138,%eax
  80341e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803421:	e9 ae 01 00 00       	jmp    8035d4 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803429:	8b 50 08             	mov    0x8(%eax),%edx
  80342c:	a1 28 50 80 00       	mov    0x805028,%eax
  803431:	39 c2                	cmp    %eax,%edx
  803433:	0f 83 93 01 00 00    	jae    8035cc <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343c:	8b 40 0c             	mov    0xc(%eax),%eax
  80343f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803442:	0f 82 84 01 00 00    	jb     8035cc <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344b:	8b 40 0c             	mov    0xc(%eax),%eax
  80344e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803451:	0f 85 95 00 00 00    	jne    8034ec <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803457:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80345b:	75 17                	jne    803474 <alloc_block_NF+0x438>
  80345d:	83 ec 04             	sub    $0x4,%esp
  803460:	68 24 49 80 00       	push   $0x804924
  803465:	68 14 01 00 00       	push   $0x114
  80346a:	68 7b 48 80 00       	push   $0x80487b
  80346f:	e8 36 d8 ff ff       	call   800caa <_panic>
  803474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803477:	8b 00                	mov    (%eax),%eax
  803479:	85 c0                	test   %eax,%eax
  80347b:	74 10                	je     80348d <alloc_block_NF+0x451>
  80347d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803480:	8b 00                	mov    (%eax),%eax
  803482:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803485:	8b 52 04             	mov    0x4(%edx),%edx
  803488:	89 50 04             	mov    %edx,0x4(%eax)
  80348b:	eb 0b                	jmp    803498 <alloc_block_NF+0x45c>
  80348d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803490:	8b 40 04             	mov    0x4(%eax),%eax
  803493:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349b:	8b 40 04             	mov    0x4(%eax),%eax
  80349e:	85 c0                	test   %eax,%eax
  8034a0:	74 0f                	je     8034b1 <alloc_block_NF+0x475>
  8034a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a5:	8b 40 04             	mov    0x4(%eax),%eax
  8034a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034ab:	8b 12                	mov    (%edx),%edx
  8034ad:	89 10                	mov    %edx,(%eax)
  8034af:	eb 0a                	jmp    8034bb <alloc_block_NF+0x47f>
  8034b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b4:	8b 00                	mov    (%eax),%eax
  8034b6:	a3 38 51 80 00       	mov    %eax,0x805138
  8034bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ce:	a1 44 51 80 00       	mov    0x805144,%eax
  8034d3:	48                   	dec    %eax
  8034d4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8034d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034dc:	8b 40 08             	mov    0x8(%eax),%eax
  8034df:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8034e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e7:	e9 1b 01 00 00       	jmp    803607 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8034ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034f5:	0f 86 d1 00 00 00    	jbe    8035cc <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8034fb:	a1 48 51 80 00       	mov    0x805148,%eax
  803500:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803506:	8b 50 08             	mov    0x8(%eax),%edx
  803509:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80350c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80350f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803512:	8b 55 08             	mov    0x8(%ebp),%edx
  803515:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803518:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80351c:	75 17                	jne    803535 <alloc_block_NF+0x4f9>
  80351e:	83 ec 04             	sub    $0x4,%esp
  803521:	68 24 49 80 00       	push   $0x804924
  803526:	68 1c 01 00 00       	push   $0x11c
  80352b:	68 7b 48 80 00       	push   $0x80487b
  803530:	e8 75 d7 ff ff       	call   800caa <_panic>
  803535:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803538:	8b 00                	mov    (%eax),%eax
  80353a:	85 c0                	test   %eax,%eax
  80353c:	74 10                	je     80354e <alloc_block_NF+0x512>
  80353e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803541:	8b 00                	mov    (%eax),%eax
  803543:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803546:	8b 52 04             	mov    0x4(%edx),%edx
  803549:	89 50 04             	mov    %edx,0x4(%eax)
  80354c:	eb 0b                	jmp    803559 <alloc_block_NF+0x51d>
  80354e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803551:	8b 40 04             	mov    0x4(%eax),%eax
  803554:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803559:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355c:	8b 40 04             	mov    0x4(%eax),%eax
  80355f:	85 c0                	test   %eax,%eax
  803561:	74 0f                	je     803572 <alloc_block_NF+0x536>
  803563:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803566:	8b 40 04             	mov    0x4(%eax),%eax
  803569:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80356c:	8b 12                	mov    (%edx),%edx
  80356e:	89 10                	mov    %edx,(%eax)
  803570:	eb 0a                	jmp    80357c <alloc_block_NF+0x540>
  803572:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803575:	8b 00                	mov    (%eax),%eax
  803577:	a3 48 51 80 00       	mov    %eax,0x805148
  80357c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80357f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803588:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358f:	a1 54 51 80 00       	mov    0x805154,%eax
  803594:	48                   	dec    %eax
  803595:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80359a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80359d:	8b 40 08             	mov    0x8(%eax),%eax
  8035a0:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8035a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a8:	8b 50 08             	mov    0x8(%eax),%edx
  8035ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ae:	01 c2                	add    %eax,%edx
  8035b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8035b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8035bf:	89 c2                	mov    %eax,%edx
  8035c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8035c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ca:	eb 3b                	jmp    803607 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8035cc:	a1 40 51 80 00       	mov    0x805140,%eax
  8035d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035d8:	74 07                	je     8035e1 <alloc_block_NF+0x5a5>
  8035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dd:	8b 00                	mov    (%eax),%eax
  8035df:	eb 05                	jmp    8035e6 <alloc_block_NF+0x5aa>
  8035e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e6:	a3 40 51 80 00       	mov    %eax,0x805140
  8035eb:	a1 40 51 80 00       	mov    0x805140,%eax
  8035f0:	85 c0                	test   %eax,%eax
  8035f2:	0f 85 2e fe ff ff    	jne    803426 <alloc_block_NF+0x3ea>
  8035f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035fc:	0f 85 24 fe ff ff    	jne    803426 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803602:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803607:	c9                   	leave  
  803608:	c3                   	ret    

00803609 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803609:	55                   	push   %ebp
  80360a:	89 e5                	mov    %esp,%ebp
  80360c:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80360f:	a1 38 51 80 00       	mov    0x805138,%eax
  803614:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803617:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80361c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80361f:	a1 38 51 80 00       	mov    0x805138,%eax
  803624:	85 c0                	test   %eax,%eax
  803626:	74 14                	je     80363c <insert_sorted_with_merge_freeList+0x33>
  803628:	8b 45 08             	mov    0x8(%ebp),%eax
  80362b:	8b 50 08             	mov    0x8(%eax),%edx
  80362e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803631:	8b 40 08             	mov    0x8(%eax),%eax
  803634:	39 c2                	cmp    %eax,%edx
  803636:	0f 87 9b 01 00 00    	ja     8037d7 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80363c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803640:	75 17                	jne    803659 <insert_sorted_with_merge_freeList+0x50>
  803642:	83 ec 04             	sub    $0x4,%esp
  803645:	68 58 48 80 00       	push   $0x804858
  80364a:	68 38 01 00 00       	push   $0x138
  80364f:	68 7b 48 80 00       	push   $0x80487b
  803654:	e8 51 d6 ff ff       	call   800caa <_panic>
  803659:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80365f:	8b 45 08             	mov    0x8(%ebp),%eax
  803662:	89 10                	mov    %edx,(%eax)
  803664:	8b 45 08             	mov    0x8(%ebp),%eax
  803667:	8b 00                	mov    (%eax),%eax
  803669:	85 c0                	test   %eax,%eax
  80366b:	74 0d                	je     80367a <insert_sorted_with_merge_freeList+0x71>
  80366d:	a1 38 51 80 00       	mov    0x805138,%eax
  803672:	8b 55 08             	mov    0x8(%ebp),%edx
  803675:	89 50 04             	mov    %edx,0x4(%eax)
  803678:	eb 08                	jmp    803682 <insert_sorted_with_merge_freeList+0x79>
  80367a:	8b 45 08             	mov    0x8(%ebp),%eax
  80367d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803682:	8b 45 08             	mov    0x8(%ebp),%eax
  803685:	a3 38 51 80 00       	mov    %eax,0x805138
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803694:	a1 44 51 80 00       	mov    0x805144,%eax
  803699:	40                   	inc    %eax
  80369a:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80369f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036a3:	0f 84 a8 06 00 00    	je     803d51 <insert_sorted_with_merge_freeList+0x748>
  8036a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ac:	8b 50 08             	mov    0x8(%eax),%edx
  8036af:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8036b5:	01 c2                	add    %eax,%edx
  8036b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ba:	8b 40 08             	mov    0x8(%eax),%eax
  8036bd:	39 c2                	cmp    %eax,%edx
  8036bf:	0f 85 8c 06 00 00    	jne    803d51 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8036c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c8:	8b 50 0c             	mov    0xc(%eax),%edx
  8036cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d1:	01 c2                	add    %eax,%edx
  8036d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d6:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8036d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036dd:	75 17                	jne    8036f6 <insert_sorted_with_merge_freeList+0xed>
  8036df:	83 ec 04             	sub    $0x4,%esp
  8036e2:	68 24 49 80 00       	push   $0x804924
  8036e7:	68 3c 01 00 00       	push   $0x13c
  8036ec:	68 7b 48 80 00       	push   $0x80487b
  8036f1:	e8 b4 d5 ff ff       	call   800caa <_panic>
  8036f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f9:	8b 00                	mov    (%eax),%eax
  8036fb:	85 c0                	test   %eax,%eax
  8036fd:	74 10                	je     80370f <insert_sorted_with_merge_freeList+0x106>
  8036ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803702:	8b 00                	mov    (%eax),%eax
  803704:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803707:	8b 52 04             	mov    0x4(%edx),%edx
  80370a:	89 50 04             	mov    %edx,0x4(%eax)
  80370d:	eb 0b                	jmp    80371a <insert_sorted_with_merge_freeList+0x111>
  80370f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803712:	8b 40 04             	mov    0x4(%eax),%eax
  803715:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80371a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80371d:	8b 40 04             	mov    0x4(%eax),%eax
  803720:	85 c0                	test   %eax,%eax
  803722:	74 0f                	je     803733 <insert_sorted_with_merge_freeList+0x12a>
  803724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803727:	8b 40 04             	mov    0x4(%eax),%eax
  80372a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80372d:	8b 12                	mov    (%edx),%edx
  80372f:	89 10                	mov    %edx,(%eax)
  803731:	eb 0a                	jmp    80373d <insert_sorted_with_merge_freeList+0x134>
  803733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803736:	8b 00                	mov    (%eax),%eax
  803738:	a3 38 51 80 00       	mov    %eax,0x805138
  80373d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803740:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803749:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803750:	a1 44 51 80 00       	mov    0x805144,%eax
  803755:	48                   	dec    %eax
  803756:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80375b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803768:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80376f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803773:	75 17                	jne    80378c <insert_sorted_with_merge_freeList+0x183>
  803775:	83 ec 04             	sub    $0x4,%esp
  803778:	68 58 48 80 00       	push   $0x804858
  80377d:	68 3f 01 00 00       	push   $0x13f
  803782:	68 7b 48 80 00       	push   $0x80487b
  803787:	e8 1e d5 ff ff       	call   800caa <_panic>
  80378c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803795:	89 10                	mov    %edx,(%eax)
  803797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379a:	8b 00                	mov    (%eax),%eax
  80379c:	85 c0                	test   %eax,%eax
  80379e:	74 0d                	je     8037ad <insert_sorted_with_merge_freeList+0x1a4>
  8037a0:	a1 48 51 80 00       	mov    0x805148,%eax
  8037a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037a8:	89 50 04             	mov    %edx,0x4(%eax)
  8037ab:	eb 08                	jmp    8037b5 <insert_sorted_with_merge_freeList+0x1ac>
  8037ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b8:	a3 48 51 80 00       	mov    %eax,0x805148
  8037bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c7:	a1 54 51 80 00       	mov    0x805154,%eax
  8037cc:	40                   	inc    %eax
  8037cd:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037d2:	e9 7a 05 00 00       	jmp    803d51 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8037d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037da:	8b 50 08             	mov    0x8(%eax),%edx
  8037dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037e0:	8b 40 08             	mov    0x8(%eax),%eax
  8037e3:	39 c2                	cmp    %eax,%edx
  8037e5:	0f 82 14 01 00 00    	jb     8038ff <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8037eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ee:	8b 50 08             	mov    0x8(%eax),%edx
  8037f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f7:	01 c2                	add    %eax,%edx
  8037f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fc:	8b 40 08             	mov    0x8(%eax),%eax
  8037ff:	39 c2                	cmp    %eax,%edx
  803801:	0f 85 90 00 00 00    	jne    803897 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803807:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80380a:	8b 50 0c             	mov    0xc(%eax),%edx
  80380d:	8b 45 08             	mov    0x8(%ebp),%eax
  803810:	8b 40 0c             	mov    0xc(%eax),%eax
  803813:	01 c2                	add    %eax,%edx
  803815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803818:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80381b:	8b 45 08             	mov    0x8(%ebp),%eax
  80381e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803825:	8b 45 08             	mov    0x8(%ebp),%eax
  803828:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80382f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803833:	75 17                	jne    80384c <insert_sorted_with_merge_freeList+0x243>
  803835:	83 ec 04             	sub    $0x4,%esp
  803838:	68 58 48 80 00       	push   $0x804858
  80383d:	68 49 01 00 00       	push   $0x149
  803842:	68 7b 48 80 00       	push   $0x80487b
  803847:	e8 5e d4 ff ff       	call   800caa <_panic>
  80384c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803852:	8b 45 08             	mov    0x8(%ebp),%eax
  803855:	89 10                	mov    %edx,(%eax)
  803857:	8b 45 08             	mov    0x8(%ebp),%eax
  80385a:	8b 00                	mov    (%eax),%eax
  80385c:	85 c0                	test   %eax,%eax
  80385e:	74 0d                	je     80386d <insert_sorted_with_merge_freeList+0x264>
  803860:	a1 48 51 80 00       	mov    0x805148,%eax
  803865:	8b 55 08             	mov    0x8(%ebp),%edx
  803868:	89 50 04             	mov    %edx,0x4(%eax)
  80386b:	eb 08                	jmp    803875 <insert_sorted_with_merge_freeList+0x26c>
  80386d:	8b 45 08             	mov    0x8(%ebp),%eax
  803870:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803875:	8b 45 08             	mov    0x8(%ebp),%eax
  803878:	a3 48 51 80 00       	mov    %eax,0x805148
  80387d:	8b 45 08             	mov    0x8(%ebp),%eax
  803880:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803887:	a1 54 51 80 00       	mov    0x805154,%eax
  80388c:	40                   	inc    %eax
  80388d:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803892:	e9 bb 04 00 00       	jmp    803d52 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803897:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80389b:	75 17                	jne    8038b4 <insert_sorted_with_merge_freeList+0x2ab>
  80389d:	83 ec 04             	sub    $0x4,%esp
  8038a0:	68 cc 48 80 00       	push   $0x8048cc
  8038a5:	68 4c 01 00 00       	push   $0x14c
  8038aa:	68 7b 48 80 00       	push   $0x80487b
  8038af:	e8 f6 d3 ff ff       	call   800caa <_panic>
  8038b4:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8038ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bd:	89 50 04             	mov    %edx,0x4(%eax)
  8038c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c3:	8b 40 04             	mov    0x4(%eax),%eax
  8038c6:	85 c0                	test   %eax,%eax
  8038c8:	74 0c                	je     8038d6 <insert_sorted_with_merge_freeList+0x2cd>
  8038ca:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8038cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8038d2:	89 10                	mov    %edx,(%eax)
  8038d4:	eb 08                	jmp    8038de <insert_sorted_with_merge_freeList+0x2d5>
  8038d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d9:	a3 38 51 80 00       	mov    %eax,0x805138
  8038de:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8038f4:	40                   	inc    %eax
  8038f5:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038fa:	e9 53 04 00 00       	jmp    803d52 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038ff:	a1 38 51 80 00       	mov    0x805138,%eax
  803904:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803907:	e9 15 04 00 00       	jmp    803d21 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80390c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390f:	8b 00                	mov    (%eax),%eax
  803911:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803914:	8b 45 08             	mov    0x8(%ebp),%eax
  803917:	8b 50 08             	mov    0x8(%eax),%edx
  80391a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391d:	8b 40 08             	mov    0x8(%eax),%eax
  803920:	39 c2                	cmp    %eax,%edx
  803922:	0f 86 f1 03 00 00    	jbe    803d19 <insert_sorted_with_merge_freeList+0x710>
  803928:	8b 45 08             	mov    0x8(%ebp),%eax
  80392b:	8b 50 08             	mov    0x8(%eax),%edx
  80392e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803931:	8b 40 08             	mov    0x8(%eax),%eax
  803934:	39 c2                	cmp    %eax,%edx
  803936:	0f 83 dd 03 00 00    	jae    803d19 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80393c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393f:	8b 50 08             	mov    0x8(%eax),%edx
  803942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803945:	8b 40 0c             	mov    0xc(%eax),%eax
  803948:	01 c2                	add    %eax,%edx
  80394a:	8b 45 08             	mov    0x8(%ebp),%eax
  80394d:	8b 40 08             	mov    0x8(%eax),%eax
  803950:	39 c2                	cmp    %eax,%edx
  803952:	0f 85 b9 01 00 00    	jne    803b11 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803958:	8b 45 08             	mov    0x8(%ebp),%eax
  80395b:	8b 50 08             	mov    0x8(%eax),%edx
  80395e:	8b 45 08             	mov    0x8(%ebp),%eax
  803961:	8b 40 0c             	mov    0xc(%eax),%eax
  803964:	01 c2                	add    %eax,%edx
  803966:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803969:	8b 40 08             	mov    0x8(%eax),%eax
  80396c:	39 c2                	cmp    %eax,%edx
  80396e:	0f 85 0d 01 00 00    	jne    803a81 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803977:	8b 50 0c             	mov    0xc(%eax),%edx
  80397a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397d:	8b 40 0c             	mov    0xc(%eax),%eax
  803980:	01 c2                	add    %eax,%edx
  803982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803985:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803988:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80398c:	75 17                	jne    8039a5 <insert_sorted_with_merge_freeList+0x39c>
  80398e:	83 ec 04             	sub    $0x4,%esp
  803991:	68 24 49 80 00       	push   $0x804924
  803996:	68 5c 01 00 00       	push   $0x15c
  80399b:	68 7b 48 80 00       	push   $0x80487b
  8039a0:	e8 05 d3 ff ff       	call   800caa <_panic>
  8039a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a8:	8b 00                	mov    (%eax),%eax
  8039aa:	85 c0                	test   %eax,%eax
  8039ac:	74 10                	je     8039be <insert_sorted_with_merge_freeList+0x3b5>
  8039ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b1:	8b 00                	mov    (%eax),%eax
  8039b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039b6:	8b 52 04             	mov    0x4(%edx),%edx
  8039b9:	89 50 04             	mov    %edx,0x4(%eax)
  8039bc:	eb 0b                	jmp    8039c9 <insert_sorted_with_merge_freeList+0x3c0>
  8039be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c1:	8b 40 04             	mov    0x4(%eax),%eax
  8039c4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039cc:	8b 40 04             	mov    0x4(%eax),%eax
  8039cf:	85 c0                	test   %eax,%eax
  8039d1:	74 0f                	je     8039e2 <insert_sorted_with_merge_freeList+0x3d9>
  8039d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d6:	8b 40 04             	mov    0x4(%eax),%eax
  8039d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039dc:	8b 12                	mov    (%edx),%edx
  8039de:	89 10                	mov    %edx,(%eax)
  8039e0:	eb 0a                	jmp    8039ec <insert_sorted_with_merge_freeList+0x3e3>
  8039e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e5:	8b 00                	mov    (%eax),%eax
  8039e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8039ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ff:	a1 44 51 80 00       	mov    0x805144,%eax
  803a04:	48                   	dec    %eax
  803a05:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803a0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803a14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a1e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a22:	75 17                	jne    803a3b <insert_sorted_with_merge_freeList+0x432>
  803a24:	83 ec 04             	sub    $0x4,%esp
  803a27:	68 58 48 80 00       	push   $0x804858
  803a2c:	68 5f 01 00 00       	push   $0x15f
  803a31:	68 7b 48 80 00       	push   $0x80487b
  803a36:	e8 6f d2 ff ff       	call   800caa <_panic>
  803a3b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a44:	89 10                	mov    %edx,(%eax)
  803a46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a49:	8b 00                	mov    (%eax),%eax
  803a4b:	85 c0                	test   %eax,%eax
  803a4d:	74 0d                	je     803a5c <insert_sorted_with_merge_freeList+0x453>
  803a4f:	a1 48 51 80 00       	mov    0x805148,%eax
  803a54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a57:	89 50 04             	mov    %edx,0x4(%eax)
  803a5a:	eb 08                	jmp    803a64 <insert_sorted_with_merge_freeList+0x45b>
  803a5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a5f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a67:	a3 48 51 80 00       	mov    %eax,0x805148
  803a6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a76:	a1 54 51 80 00       	mov    0x805154,%eax
  803a7b:	40                   	inc    %eax
  803a7c:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a84:	8b 50 0c             	mov    0xc(%eax),%edx
  803a87:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8a:	8b 40 0c             	mov    0xc(%eax),%eax
  803a8d:	01 c2                	add    %eax,%edx
  803a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a92:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803a95:	8b 45 08             	mov    0x8(%ebp),%eax
  803a98:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803aa9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803aad:	75 17                	jne    803ac6 <insert_sorted_with_merge_freeList+0x4bd>
  803aaf:	83 ec 04             	sub    $0x4,%esp
  803ab2:	68 58 48 80 00       	push   $0x804858
  803ab7:	68 64 01 00 00       	push   $0x164
  803abc:	68 7b 48 80 00       	push   $0x80487b
  803ac1:	e8 e4 d1 ff ff       	call   800caa <_panic>
  803ac6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803acc:	8b 45 08             	mov    0x8(%ebp),%eax
  803acf:	89 10                	mov    %edx,(%eax)
  803ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad4:	8b 00                	mov    (%eax),%eax
  803ad6:	85 c0                	test   %eax,%eax
  803ad8:	74 0d                	je     803ae7 <insert_sorted_with_merge_freeList+0x4de>
  803ada:	a1 48 51 80 00       	mov    0x805148,%eax
  803adf:	8b 55 08             	mov    0x8(%ebp),%edx
  803ae2:	89 50 04             	mov    %edx,0x4(%eax)
  803ae5:	eb 08                	jmp    803aef <insert_sorted_with_merge_freeList+0x4e6>
  803ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803aef:	8b 45 08             	mov    0x8(%ebp),%eax
  803af2:	a3 48 51 80 00       	mov    %eax,0x805148
  803af7:	8b 45 08             	mov    0x8(%ebp),%eax
  803afa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b01:	a1 54 51 80 00       	mov    0x805154,%eax
  803b06:	40                   	inc    %eax
  803b07:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803b0c:	e9 41 02 00 00       	jmp    803d52 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803b11:	8b 45 08             	mov    0x8(%ebp),%eax
  803b14:	8b 50 08             	mov    0x8(%eax),%edx
  803b17:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1a:	8b 40 0c             	mov    0xc(%eax),%eax
  803b1d:	01 c2                	add    %eax,%edx
  803b1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b22:	8b 40 08             	mov    0x8(%eax),%eax
  803b25:	39 c2                	cmp    %eax,%edx
  803b27:	0f 85 7c 01 00 00    	jne    803ca9 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803b2d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b31:	74 06                	je     803b39 <insert_sorted_with_merge_freeList+0x530>
  803b33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b37:	75 17                	jne    803b50 <insert_sorted_with_merge_freeList+0x547>
  803b39:	83 ec 04             	sub    $0x4,%esp
  803b3c:	68 94 48 80 00       	push   $0x804894
  803b41:	68 69 01 00 00       	push   $0x169
  803b46:	68 7b 48 80 00       	push   $0x80487b
  803b4b:	e8 5a d1 ff ff       	call   800caa <_panic>
  803b50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b53:	8b 50 04             	mov    0x4(%eax),%edx
  803b56:	8b 45 08             	mov    0x8(%ebp),%eax
  803b59:	89 50 04             	mov    %edx,0x4(%eax)
  803b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b62:	89 10                	mov    %edx,(%eax)
  803b64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b67:	8b 40 04             	mov    0x4(%eax),%eax
  803b6a:	85 c0                	test   %eax,%eax
  803b6c:	74 0d                	je     803b7b <insert_sorted_with_merge_freeList+0x572>
  803b6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b71:	8b 40 04             	mov    0x4(%eax),%eax
  803b74:	8b 55 08             	mov    0x8(%ebp),%edx
  803b77:	89 10                	mov    %edx,(%eax)
  803b79:	eb 08                	jmp    803b83 <insert_sorted_with_merge_freeList+0x57a>
  803b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7e:	a3 38 51 80 00       	mov    %eax,0x805138
  803b83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b86:	8b 55 08             	mov    0x8(%ebp),%edx
  803b89:	89 50 04             	mov    %edx,0x4(%eax)
  803b8c:	a1 44 51 80 00       	mov    0x805144,%eax
  803b91:	40                   	inc    %eax
  803b92:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803b97:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9a:	8b 50 0c             	mov    0xc(%eax),%edx
  803b9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba0:	8b 40 0c             	mov    0xc(%eax),%eax
  803ba3:	01 c2                	add    %eax,%edx
  803ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba8:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803bab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803baf:	75 17                	jne    803bc8 <insert_sorted_with_merge_freeList+0x5bf>
  803bb1:	83 ec 04             	sub    $0x4,%esp
  803bb4:	68 24 49 80 00       	push   $0x804924
  803bb9:	68 6b 01 00 00       	push   $0x16b
  803bbe:	68 7b 48 80 00       	push   $0x80487b
  803bc3:	e8 e2 d0 ff ff       	call   800caa <_panic>
  803bc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bcb:	8b 00                	mov    (%eax),%eax
  803bcd:	85 c0                	test   %eax,%eax
  803bcf:	74 10                	je     803be1 <insert_sorted_with_merge_freeList+0x5d8>
  803bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd4:	8b 00                	mov    (%eax),%eax
  803bd6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bd9:	8b 52 04             	mov    0x4(%edx),%edx
  803bdc:	89 50 04             	mov    %edx,0x4(%eax)
  803bdf:	eb 0b                	jmp    803bec <insert_sorted_with_merge_freeList+0x5e3>
  803be1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be4:	8b 40 04             	mov    0x4(%eax),%eax
  803be7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bef:	8b 40 04             	mov    0x4(%eax),%eax
  803bf2:	85 c0                	test   %eax,%eax
  803bf4:	74 0f                	je     803c05 <insert_sorted_with_merge_freeList+0x5fc>
  803bf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bf9:	8b 40 04             	mov    0x4(%eax),%eax
  803bfc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bff:	8b 12                	mov    (%edx),%edx
  803c01:	89 10                	mov    %edx,(%eax)
  803c03:	eb 0a                	jmp    803c0f <insert_sorted_with_merge_freeList+0x606>
  803c05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c08:	8b 00                	mov    (%eax),%eax
  803c0a:	a3 38 51 80 00       	mov    %eax,0x805138
  803c0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c22:	a1 44 51 80 00       	mov    0x805144,%eax
  803c27:	48                   	dec    %eax
  803c28:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803c2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c30:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803c37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c3a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803c41:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c45:	75 17                	jne    803c5e <insert_sorted_with_merge_freeList+0x655>
  803c47:	83 ec 04             	sub    $0x4,%esp
  803c4a:	68 58 48 80 00       	push   $0x804858
  803c4f:	68 6e 01 00 00       	push   $0x16e
  803c54:	68 7b 48 80 00       	push   $0x80487b
  803c59:	e8 4c d0 ff ff       	call   800caa <_panic>
  803c5e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c67:	89 10                	mov    %edx,(%eax)
  803c69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6c:	8b 00                	mov    (%eax),%eax
  803c6e:	85 c0                	test   %eax,%eax
  803c70:	74 0d                	je     803c7f <insert_sorted_with_merge_freeList+0x676>
  803c72:	a1 48 51 80 00       	mov    0x805148,%eax
  803c77:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c7a:	89 50 04             	mov    %edx,0x4(%eax)
  803c7d:	eb 08                	jmp    803c87 <insert_sorted_with_merge_freeList+0x67e>
  803c7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c82:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c8a:	a3 48 51 80 00       	mov    %eax,0x805148
  803c8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c99:	a1 54 51 80 00       	mov    0x805154,%eax
  803c9e:	40                   	inc    %eax
  803c9f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ca4:	e9 a9 00 00 00       	jmp    803d52 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803ca9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cad:	74 06                	je     803cb5 <insert_sorted_with_merge_freeList+0x6ac>
  803caf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cb3:	75 17                	jne    803ccc <insert_sorted_with_merge_freeList+0x6c3>
  803cb5:	83 ec 04             	sub    $0x4,%esp
  803cb8:	68 f0 48 80 00       	push   $0x8048f0
  803cbd:	68 73 01 00 00       	push   $0x173
  803cc2:	68 7b 48 80 00       	push   $0x80487b
  803cc7:	e8 de cf ff ff       	call   800caa <_panic>
  803ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ccf:	8b 10                	mov    (%eax),%edx
  803cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd4:	89 10                	mov    %edx,(%eax)
  803cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd9:	8b 00                	mov    (%eax),%eax
  803cdb:	85 c0                	test   %eax,%eax
  803cdd:	74 0b                	je     803cea <insert_sorted_with_merge_freeList+0x6e1>
  803cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce2:	8b 00                	mov    (%eax),%eax
  803ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  803ce7:	89 50 04             	mov    %edx,0x4(%eax)
  803cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ced:	8b 55 08             	mov    0x8(%ebp),%edx
  803cf0:	89 10                	mov    %edx,(%eax)
  803cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cf8:	89 50 04             	mov    %edx,0x4(%eax)
  803cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfe:	8b 00                	mov    (%eax),%eax
  803d00:	85 c0                	test   %eax,%eax
  803d02:	75 08                	jne    803d0c <insert_sorted_with_merge_freeList+0x703>
  803d04:	8b 45 08             	mov    0x8(%ebp),%eax
  803d07:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803d0c:	a1 44 51 80 00       	mov    0x805144,%eax
  803d11:	40                   	inc    %eax
  803d12:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803d17:	eb 39                	jmp    803d52 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803d19:	a1 40 51 80 00       	mov    0x805140,%eax
  803d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d25:	74 07                	je     803d2e <insert_sorted_with_merge_freeList+0x725>
  803d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2a:	8b 00                	mov    (%eax),%eax
  803d2c:	eb 05                	jmp    803d33 <insert_sorted_with_merge_freeList+0x72a>
  803d2e:	b8 00 00 00 00       	mov    $0x0,%eax
  803d33:	a3 40 51 80 00       	mov    %eax,0x805140
  803d38:	a1 40 51 80 00       	mov    0x805140,%eax
  803d3d:	85 c0                	test   %eax,%eax
  803d3f:	0f 85 c7 fb ff ff    	jne    80390c <insert_sorted_with_merge_freeList+0x303>
  803d45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d49:	0f 85 bd fb ff ff    	jne    80390c <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d4f:	eb 01                	jmp    803d52 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803d51:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d52:	90                   	nop
  803d53:	c9                   	leave  
  803d54:	c3                   	ret    
  803d55:	66 90                	xchg   %ax,%ax
  803d57:	90                   	nop

00803d58 <__udivdi3>:
  803d58:	55                   	push   %ebp
  803d59:	57                   	push   %edi
  803d5a:	56                   	push   %esi
  803d5b:	53                   	push   %ebx
  803d5c:	83 ec 1c             	sub    $0x1c,%esp
  803d5f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d63:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d6b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d6f:	89 ca                	mov    %ecx,%edx
  803d71:	89 f8                	mov    %edi,%eax
  803d73:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d77:	85 f6                	test   %esi,%esi
  803d79:	75 2d                	jne    803da8 <__udivdi3+0x50>
  803d7b:	39 cf                	cmp    %ecx,%edi
  803d7d:	77 65                	ja     803de4 <__udivdi3+0x8c>
  803d7f:	89 fd                	mov    %edi,%ebp
  803d81:	85 ff                	test   %edi,%edi
  803d83:	75 0b                	jne    803d90 <__udivdi3+0x38>
  803d85:	b8 01 00 00 00       	mov    $0x1,%eax
  803d8a:	31 d2                	xor    %edx,%edx
  803d8c:	f7 f7                	div    %edi
  803d8e:	89 c5                	mov    %eax,%ebp
  803d90:	31 d2                	xor    %edx,%edx
  803d92:	89 c8                	mov    %ecx,%eax
  803d94:	f7 f5                	div    %ebp
  803d96:	89 c1                	mov    %eax,%ecx
  803d98:	89 d8                	mov    %ebx,%eax
  803d9a:	f7 f5                	div    %ebp
  803d9c:	89 cf                	mov    %ecx,%edi
  803d9e:	89 fa                	mov    %edi,%edx
  803da0:	83 c4 1c             	add    $0x1c,%esp
  803da3:	5b                   	pop    %ebx
  803da4:	5e                   	pop    %esi
  803da5:	5f                   	pop    %edi
  803da6:	5d                   	pop    %ebp
  803da7:	c3                   	ret    
  803da8:	39 ce                	cmp    %ecx,%esi
  803daa:	77 28                	ja     803dd4 <__udivdi3+0x7c>
  803dac:	0f bd fe             	bsr    %esi,%edi
  803daf:	83 f7 1f             	xor    $0x1f,%edi
  803db2:	75 40                	jne    803df4 <__udivdi3+0x9c>
  803db4:	39 ce                	cmp    %ecx,%esi
  803db6:	72 0a                	jb     803dc2 <__udivdi3+0x6a>
  803db8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803dbc:	0f 87 9e 00 00 00    	ja     803e60 <__udivdi3+0x108>
  803dc2:	b8 01 00 00 00       	mov    $0x1,%eax
  803dc7:	89 fa                	mov    %edi,%edx
  803dc9:	83 c4 1c             	add    $0x1c,%esp
  803dcc:	5b                   	pop    %ebx
  803dcd:	5e                   	pop    %esi
  803dce:	5f                   	pop    %edi
  803dcf:	5d                   	pop    %ebp
  803dd0:	c3                   	ret    
  803dd1:	8d 76 00             	lea    0x0(%esi),%esi
  803dd4:	31 ff                	xor    %edi,%edi
  803dd6:	31 c0                	xor    %eax,%eax
  803dd8:	89 fa                	mov    %edi,%edx
  803dda:	83 c4 1c             	add    $0x1c,%esp
  803ddd:	5b                   	pop    %ebx
  803dde:	5e                   	pop    %esi
  803ddf:	5f                   	pop    %edi
  803de0:	5d                   	pop    %ebp
  803de1:	c3                   	ret    
  803de2:	66 90                	xchg   %ax,%ax
  803de4:	89 d8                	mov    %ebx,%eax
  803de6:	f7 f7                	div    %edi
  803de8:	31 ff                	xor    %edi,%edi
  803dea:	89 fa                	mov    %edi,%edx
  803dec:	83 c4 1c             	add    $0x1c,%esp
  803def:	5b                   	pop    %ebx
  803df0:	5e                   	pop    %esi
  803df1:	5f                   	pop    %edi
  803df2:	5d                   	pop    %ebp
  803df3:	c3                   	ret    
  803df4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803df9:	89 eb                	mov    %ebp,%ebx
  803dfb:	29 fb                	sub    %edi,%ebx
  803dfd:	89 f9                	mov    %edi,%ecx
  803dff:	d3 e6                	shl    %cl,%esi
  803e01:	89 c5                	mov    %eax,%ebp
  803e03:	88 d9                	mov    %bl,%cl
  803e05:	d3 ed                	shr    %cl,%ebp
  803e07:	89 e9                	mov    %ebp,%ecx
  803e09:	09 f1                	or     %esi,%ecx
  803e0b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e0f:	89 f9                	mov    %edi,%ecx
  803e11:	d3 e0                	shl    %cl,%eax
  803e13:	89 c5                	mov    %eax,%ebp
  803e15:	89 d6                	mov    %edx,%esi
  803e17:	88 d9                	mov    %bl,%cl
  803e19:	d3 ee                	shr    %cl,%esi
  803e1b:	89 f9                	mov    %edi,%ecx
  803e1d:	d3 e2                	shl    %cl,%edx
  803e1f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e23:	88 d9                	mov    %bl,%cl
  803e25:	d3 e8                	shr    %cl,%eax
  803e27:	09 c2                	or     %eax,%edx
  803e29:	89 d0                	mov    %edx,%eax
  803e2b:	89 f2                	mov    %esi,%edx
  803e2d:	f7 74 24 0c          	divl   0xc(%esp)
  803e31:	89 d6                	mov    %edx,%esi
  803e33:	89 c3                	mov    %eax,%ebx
  803e35:	f7 e5                	mul    %ebp
  803e37:	39 d6                	cmp    %edx,%esi
  803e39:	72 19                	jb     803e54 <__udivdi3+0xfc>
  803e3b:	74 0b                	je     803e48 <__udivdi3+0xf0>
  803e3d:	89 d8                	mov    %ebx,%eax
  803e3f:	31 ff                	xor    %edi,%edi
  803e41:	e9 58 ff ff ff       	jmp    803d9e <__udivdi3+0x46>
  803e46:	66 90                	xchg   %ax,%ax
  803e48:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e4c:	89 f9                	mov    %edi,%ecx
  803e4e:	d3 e2                	shl    %cl,%edx
  803e50:	39 c2                	cmp    %eax,%edx
  803e52:	73 e9                	jae    803e3d <__udivdi3+0xe5>
  803e54:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e57:	31 ff                	xor    %edi,%edi
  803e59:	e9 40 ff ff ff       	jmp    803d9e <__udivdi3+0x46>
  803e5e:	66 90                	xchg   %ax,%ax
  803e60:	31 c0                	xor    %eax,%eax
  803e62:	e9 37 ff ff ff       	jmp    803d9e <__udivdi3+0x46>
  803e67:	90                   	nop

00803e68 <__umoddi3>:
  803e68:	55                   	push   %ebp
  803e69:	57                   	push   %edi
  803e6a:	56                   	push   %esi
  803e6b:	53                   	push   %ebx
  803e6c:	83 ec 1c             	sub    $0x1c,%esp
  803e6f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e73:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e87:	89 f3                	mov    %esi,%ebx
  803e89:	89 fa                	mov    %edi,%edx
  803e8b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e8f:	89 34 24             	mov    %esi,(%esp)
  803e92:	85 c0                	test   %eax,%eax
  803e94:	75 1a                	jne    803eb0 <__umoddi3+0x48>
  803e96:	39 f7                	cmp    %esi,%edi
  803e98:	0f 86 a2 00 00 00    	jbe    803f40 <__umoddi3+0xd8>
  803e9e:	89 c8                	mov    %ecx,%eax
  803ea0:	89 f2                	mov    %esi,%edx
  803ea2:	f7 f7                	div    %edi
  803ea4:	89 d0                	mov    %edx,%eax
  803ea6:	31 d2                	xor    %edx,%edx
  803ea8:	83 c4 1c             	add    $0x1c,%esp
  803eab:	5b                   	pop    %ebx
  803eac:	5e                   	pop    %esi
  803ead:	5f                   	pop    %edi
  803eae:	5d                   	pop    %ebp
  803eaf:	c3                   	ret    
  803eb0:	39 f0                	cmp    %esi,%eax
  803eb2:	0f 87 ac 00 00 00    	ja     803f64 <__umoddi3+0xfc>
  803eb8:	0f bd e8             	bsr    %eax,%ebp
  803ebb:	83 f5 1f             	xor    $0x1f,%ebp
  803ebe:	0f 84 ac 00 00 00    	je     803f70 <__umoddi3+0x108>
  803ec4:	bf 20 00 00 00       	mov    $0x20,%edi
  803ec9:	29 ef                	sub    %ebp,%edi
  803ecb:	89 fe                	mov    %edi,%esi
  803ecd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ed1:	89 e9                	mov    %ebp,%ecx
  803ed3:	d3 e0                	shl    %cl,%eax
  803ed5:	89 d7                	mov    %edx,%edi
  803ed7:	89 f1                	mov    %esi,%ecx
  803ed9:	d3 ef                	shr    %cl,%edi
  803edb:	09 c7                	or     %eax,%edi
  803edd:	89 e9                	mov    %ebp,%ecx
  803edf:	d3 e2                	shl    %cl,%edx
  803ee1:	89 14 24             	mov    %edx,(%esp)
  803ee4:	89 d8                	mov    %ebx,%eax
  803ee6:	d3 e0                	shl    %cl,%eax
  803ee8:	89 c2                	mov    %eax,%edx
  803eea:	8b 44 24 08          	mov    0x8(%esp),%eax
  803eee:	d3 e0                	shl    %cl,%eax
  803ef0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ef4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ef8:	89 f1                	mov    %esi,%ecx
  803efa:	d3 e8                	shr    %cl,%eax
  803efc:	09 d0                	or     %edx,%eax
  803efe:	d3 eb                	shr    %cl,%ebx
  803f00:	89 da                	mov    %ebx,%edx
  803f02:	f7 f7                	div    %edi
  803f04:	89 d3                	mov    %edx,%ebx
  803f06:	f7 24 24             	mull   (%esp)
  803f09:	89 c6                	mov    %eax,%esi
  803f0b:	89 d1                	mov    %edx,%ecx
  803f0d:	39 d3                	cmp    %edx,%ebx
  803f0f:	0f 82 87 00 00 00    	jb     803f9c <__umoddi3+0x134>
  803f15:	0f 84 91 00 00 00    	je     803fac <__umoddi3+0x144>
  803f1b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f1f:	29 f2                	sub    %esi,%edx
  803f21:	19 cb                	sbb    %ecx,%ebx
  803f23:	89 d8                	mov    %ebx,%eax
  803f25:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f29:	d3 e0                	shl    %cl,%eax
  803f2b:	89 e9                	mov    %ebp,%ecx
  803f2d:	d3 ea                	shr    %cl,%edx
  803f2f:	09 d0                	or     %edx,%eax
  803f31:	89 e9                	mov    %ebp,%ecx
  803f33:	d3 eb                	shr    %cl,%ebx
  803f35:	89 da                	mov    %ebx,%edx
  803f37:	83 c4 1c             	add    $0x1c,%esp
  803f3a:	5b                   	pop    %ebx
  803f3b:	5e                   	pop    %esi
  803f3c:	5f                   	pop    %edi
  803f3d:	5d                   	pop    %ebp
  803f3e:	c3                   	ret    
  803f3f:	90                   	nop
  803f40:	89 fd                	mov    %edi,%ebp
  803f42:	85 ff                	test   %edi,%edi
  803f44:	75 0b                	jne    803f51 <__umoddi3+0xe9>
  803f46:	b8 01 00 00 00       	mov    $0x1,%eax
  803f4b:	31 d2                	xor    %edx,%edx
  803f4d:	f7 f7                	div    %edi
  803f4f:	89 c5                	mov    %eax,%ebp
  803f51:	89 f0                	mov    %esi,%eax
  803f53:	31 d2                	xor    %edx,%edx
  803f55:	f7 f5                	div    %ebp
  803f57:	89 c8                	mov    %ecx,%eax
  803f59:	f7 f5                	div    %ebp
  803f5b:	89 d0                	mov    %edx,%eax
  803f5d:	e9 44 ff ff ff       	jmp    803ea6 <__umoddi3+0x3e>
  803f62:	66 90                	xchg   %ax,%ax
  803f64:	89 c8                	mov    %ecx,%eax
  803f66:	89 f2                	mov    %esi,%edx
  803f68:	83 c4 1c             	add    $0x1c,%esp
  803f6b:	5b                   	pop    %ebx
  803f6c:	5e                   	pop    %esi
  803f6d:	5f                   	pop    %edi
  803f6e:	5d                   	pop    %ebp
  803f6f:	c3                   	ret    
  803f70:	3b 04 24             	cmp    (%esp),%eax
  803f73:	72 06                	jb     803f7b <__umoddi3+0x113>
  803f75:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f79:	77 0f                	ja     803f8a <__umoddi3+0x122>
  803f7b:	89 f2                	mov    %esi,%edx
  803f7d:	29 f9                	sub    %edi,%ecx
  803f7f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f83:	89 14 24             	mov    %edx,(%esp)
  803f86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f8a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f8e:	8b 14 24             	mov    (%esp),%edx
  803f91:	83 c4 1c             	add    $0x1c,%esp
  803f94:	5b                   	pop    %ebx
  803f95:	5e                   	pop    %esi
  803f96:	5f                   	pop    %edi
  803f97:	5d                   	pop    %ebp
  803f98:	c3                   	ret    
  803f99:	8d 76 00             	lea    0x0(%esi),%esi
  803f9c:	2b 04 24             	sub    (%esp),%eax
  803f9f:	19 fa                	sbb    %edi,%edx
  803fa1:	89 d1                	mov    %edx,%ecx
  803fa3:	89 c6                	mov    %eax,%esi
  803fa5:	e9 71 ff ff ff       	jmp    803f1b <__umoddi3+0xb3>
  803faa:	66 90                	xchg   %ax,%ax
  803fac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803fb0:	72 ea                	jb     803f9c <__umoddi3+0x134>
  803fb2:	89 d9                	mov    %ebx,%ecx
  803fb4:	e9 62 ff ff ff       	jmp    803f1b <__umoddi3+0xb3>
