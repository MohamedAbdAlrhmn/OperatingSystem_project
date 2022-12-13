
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
  800044:	e8 19 27 00 00       	call   802762 <sys_set_uheap_strategy>
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
  80009a:	68 80 40 80 00       	push   $0x804080
  80009f:	6a 15                	push   $0x15
  8000a1:	68 9c 40 80 00       	push   $0x80409c
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
  8000d7:	e8 71 21 00 00       	call   80224d <sys_calculate_free_frames>
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000df:	e8 09 22 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
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
  800109:	68 b4 40 80 00       	push   $0x8040b4
  80010e:	6a 26                	push   $0x26
  800110:	68 9c 40 80 00       	push   $0x80409c
  800115:	e8 90 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80011a:	e8 ce 21 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  80011f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 e4 40 80 00       	push   $0x8040e4
  80012c:	6a 28                	push   $0x28
  80012e:	68 9c 40 80 00       	push   $0x80409c
  800133:	e8 72 0b 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800138:	e8 10 21 00 00       	call   80224d <sys_calculate_free_frames>
  80013d:	89 c2                	mov    %eax,%edx
  80013f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800142:	39 c2                	cmp    %eax,%edx
  800144:	74 14                	je     80015a <_main+0x122>
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	68 01 41 80 00       	push   $0x804101
  80014e:	6a 29                	push   $0x29
  800150:	68 9c 40 80 00       	push   $0x80409c
  800155:	e8 50 0b 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80015a:	e8 ee 20 00 00       	call   80224d <sys_calculate_free_frames>
  80015f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800162:	e8 86 21 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
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
  800193:	68 b4 40 80 00       	push   $0x8040b4
  800198:	6a 2f                	push   $0x2f
  80019a:	68 9c 40 80 00       	push   $0x80409c
  80019f:	e8 06 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001a4:	e8 44 21 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  8001a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 e4 40 80 00       	push   $0x8040e4
  8001b6:	6a 31                	push   $0x31
  8001b8:	68 9c 40 80 00       	push   $0x80409c
  8001bd:	e8 e8 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001c2:	e8 86 20 00 00       	call   80224d <sys_calculate_free_frames>
  8001c7:	89 c2                	mov    %eax,%edx
  8001c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 01 41 80 00       	push   $0x804101
  8001d8:	6a 32                	push   $0x32
  8001da:	68 9c 40 80 00       	push   $0x80409c
  8001df:	e8 c6 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001e4:	e8 64 20 00 00       	call   80224d <sys_calculate_free_frames>
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001ec:	e8 fc 20 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
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
  80021f:	68 b4 40 80 00       	push   $0x8040b4
  800224:	6a 38                	push   $0x38
  800226:	68 9c 40 80 00       	push   $0x80409c
  80022b:	e8 7a 0a 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800230:	e8 b8 20 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  800235:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800238:	74 14                	je     80024e <_main+0x216>
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	68 e4 40 80 00       	push   $0x8040e4
  800242:	6a 3a                	push   $0x3a
  800244:	68 9c 40 80 00       	push   $0x80409c
  800249:	e8 5c 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80024e:	e8 fa 1f 00 00       	call   80224d <sys_calculate_free_frames>
  800253:	89 c2                	mov    %eax,%edx
  800255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800258:	39 c2                	cmp    %eax,%edx
  80025a:	74 14                	je     800270 <_main+0x238>
  80025c:	83 ec 04             	sub    $0x4,%esp
  80025f:	68 01 41 80 00       	push   $0x804101
  800264:	6a 3b                	push   $0x3b
  800266:	68 9c 40 80 00       	push   $0x80409c
  80026b:	e8 3a 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800270:	e8 d8 1f 00 00       	call   80224d <sys_calculate_free_frames>
  800275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800278:	e8 70 20 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
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
  8002af:	68 b4 40 80 00       	push   $0x8040b4
  8002b4:	6a 41                	push   $0x41
  8002b6:	68 9c 40 80 00       	push   $0x80409c
  8002bb:	e8 ea 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002c0:	e8 28 20 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  8002c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c8:	74 14                	je     8002de <_main+0x2a6>
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	68 e4 40 80 00       	push   $0x8040e4
  8002d2:	6a 43                	push   $0x43
  8002d4:	68 9c 40 80 00       	push   $0x80409c
  8002d9:	e8 cc 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002de:	e8 6a 1f 00 00       	call   80224d <sys_calculate_free_frames>
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e8:	39 c2                	cmp    %eax,%edx
  8002ea:	74 14                	je     800300 <_main+0x2c8>
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	68 01 41 80 00       	push   $0x804101
  8002f4:	6a 44                	push   $0x44
  8002f6:	68 9c 40 80 00       	push   $0x80409c
  8002fb:	e8 aa 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800300:	e8 48 1f 00 00       	call   80224d <sys_calculate_free_frames>
  800305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800308:	e8 e0 1f 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
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
  80033e:	68 b4 40 80 00       	push   $0x8040b4
  800343:	6a 4a                	push   $0x4a
  800345:	68 9c 40 80 00       	push   $0x80409c
  80034a:	e8 5b 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80034f:	e8 99 1f 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  800354:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800357:	74 14                	je     80036d <_main+0x335>
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	68 e4 40 80 00       	push   $0x8040e4
  800361:	6a 4c                	push   $0x4c
  800363:	68 9c 40 80 00       	push   $0x80409c
  800368:	e8 3d 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80036d:	e8 db 1e 00 00       	call   80224d <sys_calculate_free_frames>
  800372:	89 c2                	mov    %eax,%edx
  800374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800377:	39 c2                	cmp    %eax,%edx
  800379:	74 14                	je     80038f <_main+0x357>
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	68 01 41 80 00       	push   $0x804101
  800383:	6a 4d                	push   $0x4d
  800385:	68 9c 40 80 00       	push   $0x80409c
  80038a:	e8 1b 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80038f:	e8 b9 1e 00 00       	call   80224d <sys_calculate_free_frames>
  800394:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800397:	e8 51 1f 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
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
  8003d2:	68 b4 40 80 00       	push   $0x8040b4
  8003d7:	6a 53                	push   $0x53
  8003d9:	68 9c 40 80 00       	push   $0x80409c
  8003de:	e8 c7 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8003e3:	e8 05 1f 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  8003e8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 e4 40 80 00       	push   $0x8040e4
  8003f5:	6a 55                	push   $0x55
  8003f7:	68 9c 40 80 00       	push   $0x80409c
  8003fc:	e8 a9 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800401:	e8 47 1e 00 00       	call   80224d <sys_calculate_free_frames>
  800406:	89 c2                	mov    %eax,%edx
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	39 c2                	cmp    %eax,%edx
  80040d:	74 14                	je     800423 <_main+0x3eb>
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 01 41 80 00       	push   $0x804101
  800417:	6a 56                	push   $0x56
  800419:	68 9c 40 80 00       	push   $0x80409c
  80041e:	e8 87 08 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 25 1e 00 00       	call   80224d <sys_calculate_free_frames>
  800428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 bd 1e 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
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
  800465:	68 b4 40 80 00       	push   $0x8040b4
  80046a:	6a 5c                	push   $0x5c
  80046c:	68 9c 40 80 00       	push   $0x80409c
  800471:	e8 34 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800476:	e8 72 1e 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  80047b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 e4 40 80 00       	push   $0x8040e4
  800488:	6a 5e                	push   $0x5e
  80048a:	68 9c 40 80 00       	push   $0x80409c
  80048f:	e8 16 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800494:	e8 b4 1d 00 00       	call   80224d <sys_calculate_free_frames>
  800499:	89 c2                	mov    %eax,%edx
  80049b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	74 14                	je     8004b6 <_main+0x47e>
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	68 01 41 80 00       	push   $0x804101
  8004aa:	6a 5f                	push   $0x5f
  8004ac:	68 9c 40 80 00       	push   $0x80409c
  8004b1:	e8 f4 07 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004b6:	e8 92 1d 00 00       	call   80224d <sys_calculate_free_frames>
  8004bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004be:	e8 2a 1e 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
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
  800500:	68 b4 40 80 00       	push   $0x8040b4
  800505:	6a 65                	push   $0x65
  800507:	68 9c 40 80 00       	push   $0x80409c
  80050c:	e8 99 07 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800511:	e8 d7 1d 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  800516:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800519:	74 14                	je     80052f <_main+0x4f7>
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	68 e4 40 80 00       	push   $0x8040e4
  800523:	6a 67                	push   $0x67
  800525:	68 9c 40 80 00       	push   $0x80409c
  80052a:	e8 7b 07 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80052f:	e8 19 1d 00 00       	call   80224d <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 01 41 80 00       	push   $0x804101
  800545:	6a 68                	push   $0x68
  800547:	68 9c 40 80 00       	push   $0x80409c
  80054c:	e8 59 07 00 00       	call   800caa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800551:	e8 f7 1c 00 00       	call   80224d <sys_calculate_free_frames>
  800556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800559:	e8 8f 1d 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  80055e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800561:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	50                   	push   %eax
  800568:	e8 f4 19 00 00       	call   801f61 <free>
  80056d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800570:	e8 78 1d 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  800575:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800578:	74 14                	je     80058e <_main+0x556>
  80057a:	83 ec 04             	sub    $0x4,%esp
  80057d:	68 14 41 80 00       	push   $0x804114
  800582:	6a 72                	push   $0x72
  800584:	68 9c 40 80 00       	push   $0x80409c
  800589:	e8 1c 07 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80058e:	e8 ba 1c 00 00       	call   80224d <sys_calculate_free_frames>
  800593:	89 c2                	mov    %eax,%edx
  800595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800598:	39 c2                	cmp    %eax,%edx
  80059a:	74 14                	je     8005b0 <_main+0x578>
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	68 2b 41 80 00       	push   $0x80412b
  8005a4:	6a 73                	push   $0x73
  8005a6:	68 9c 40 80 00       	push   $0x80409c
  8005ab:	e8 fa 06 00 00       	call   800caa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005b0:	e8 98 1c 00 00       	call   80224d <sys_calculate_free_frames>
  8005b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005b8:	e8 30 1d 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  8005c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	50                   	push   %eax
  8005c7:	e8 95 19 00 00       	call   801f61 <free>
  8005cc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005cf:	e8 19 1d 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  8005d4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005d7:	74 14                	je     8005ed <_main+0x5b5>
  8005d9:	83 ec 04             	sub    $0x4,%esp
  8005dc:	68 14 41 80 00       	push   $0x804114
  8005e1:	6a 7a                	push   $0x7a
  8005e3:	68 9c 40 80 00       	push   $0x80409c
  8005e8:	e8 bd 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ed:	e8 5b 1c 00 00       	call   80224d <sys_calculate_free_frames>
  8005f2:	89 c2                	mov    %eax,%edx
  8005f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f7:	39 c2                	cmp    %eax,%edx
  8005f9:	74 14                	je     80060f <_main+0x5d7>
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 2b 41 80 00       	push   $0x80412b
  800603:	6a 7b                	push   $0x7b
  800605:	68 9c 40 80 00       	push   $0x80409c
  80060a:	e8 9b 06 00 00       	call   800caa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80060f:	e8 39 1c 00 00       	call   80224d <sys_calculate_free_frames>
  800614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800617:	e8 d1 1c 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80061f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800622:	83 ec 0c             	sub    $0xc,%esp
  800625:	50                   	push   %eax
  800626:	e8 36 19 00 00       	call   801f61 <free>
  80062b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80062e:	e8 ba 1c 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  800633:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800636:	74 17                	je     80064f <_main+0x617>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 14 41 80 00       	push   $0x804114
  800640:	68 82 00 00 00       	push   $0x82
  800645:	68 9c 40 80 00       	push   $0x80409c
  80064a:	e8 5b 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064f:	e8 f9 1b 00 00       	call   80224d <sys_calculate_free_frames>
  800654:	89 c2                	mov    %eax,%edx
  800656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800659:	39 c2                	cmp    %eax,%edx
  80065b:	74 17                	je     800674 <_main+0x63c>
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	68 2b 41 80 00       	push   $0x80412b
  800665:	68 83 00 00 00       	push   $0x83
  80066a:	68 9c 40 80 00       	push   $0x80409c
  80066f:	e8 36 06 00 00       	call   800caa <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800674:	e8 d4 1b 00 00       	call   80224d <sys_calculate_free_frames>
  800679:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80067c:	e8 6c 1c 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
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
  8006b1:	68 b4 40 80 00       	push   $0x8040b4
  8006b6:	68 8c 00 00 00       	push   $0x8c
  8006bb:	68 9c 40 80 00       	push   $0x80409c
  8006c0:	e8 e5 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006c5:	e8 23 1c 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  8006ca:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006cd:	74 17                	je     8006e6 <_main+0x6ae>
  8006cf:	83 ec 04             	sub    $0x4,%esp
  8006d2:	68 e4 40 80 00       	push   $0x8040e4
  8006d7:	68 8e 00 00 00       	push   $0x8e
  8006dc:	68 9c 40 80 00       	push   $0x80409c
  8006e1:	e8 c4 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8006e6:	e8 62 1b 00 00       	call   80224d <sys_calculate_free_frames>
  8006eb:	89 c2                	mov    %eax,%edx
  8006ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f0:	39 c2                	cmp    %eax,%edx
  8006f2:	74 17                	je     80070b <_main+0x6d3>
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	68 01 41 80 00       	push   $0x804101
  8006fc:	68 8f 00 00 00       	push   $0x8f
  800701:	68 9c 40 80 00       	push   $0x80409c
  800706:	e8 9f 05 00 00       	call   800caa <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80070b:	e8 3d 1b 00 00       	call   80224d <sys_calculate_free_frames>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800713:	e8 d5 1b 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
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
  800747:	68 b4 40 80 00       	push   $0x8040b4
  80074c:	68 95 00 00 00       	push   $0x95
  800751:	68 9c 40 80 00       	push   $0x80409c
  800756:	e8 4f 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80075b:	e8 8d 1b 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  800760:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800763:	74 17                	je     80077c <_main+0x744>
  800765:	83 ec 04             	sub    $0x4,%esp
  800768:	68 e4 40 80 00       	push   $0x8040e4
  80076d:	68 97 00 00 00       	push   $0x97
  800772:	68 9c 40 80 00       	push   $0x80409c
  800777:	e8 2e 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80077c:	e8 cc 1a 00 00       	call   80224d <sys_calculate_free_frames>
  800781:	89 c2                	mov    %eax,%edx
  800783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800786:	39 c2                	cmp    %eax,%edx
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	68 01 41 80 00       	push   $0x804101
  800792:	68 98 00 00 00       	push   $0x98
  800797:	68 9c 40 80 00       	push   $0x80409c
  80079c:	e8 09 05 00 00       	call   800caa <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007a1:	e8 a7 1a 00 00       	call   80224d <sys_calculate_free_frames>
  8007a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007a9:	e8 3f 1b 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
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
  8007e8:	68 b4 40 80 00       	push   $0x8040b4
  8007ed:	68 9e 00 00 00       	push   $0x9e
  8007f2:	68 9c 40 80 00       	push   $0x80409c
  8007f7:	e8 ae 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8007fc:	e8 ec 1a 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  800801:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800804:	74 17                	je     80081d <_main+0x7e5>
  800806:	83 ec 04             	sub    $0x4,%esp
  800809:	68 e4 40 80 00       	push   $0x8040e4
  80080e:	68 a0 00 00 00       	push   $0xa0
  800813:	68 9c 40 80 00       	push   $0x80409c
  800818:	e8 8d 04 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80081d:	e8 2b 1a 00 00       	call   80224d <sys_calculate_free_frames>
  800822:	89 c2                	mov    %eax,%edx
  800824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800827:	39 c2                	cmp    %eax,%edx
  800829:	74 17                	je     800842 <_main+0x80a>
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	68 01 41 80 00       	push   $0x804101
  800833:	68 a1 00 00 00       	push   $0xa1
  800838:	68 9c 40 80 00       	push   $0x80409c
  80083d:	e8 68 04 00 00       	call   800caa <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800842:	e8 06 1a 00 00       	call   80224d <sys_calculate_free_frames>
  800847:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80084a:	e8 9e 1a 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
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
  80087d:	68 b4 40 80 00       	push   $0x8040b4
  800882:	68 a7 00 00 00       	push   $0xa7
  800887:	68 9c 40 80 00       	push   $0x80409c
  80088c:	e8 19 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800891:	e8 57 1a 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  800896:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800899:	74 17                	je     8008b2 <_main+0x87a>
  80089b:	83 ec 04             	sub    $0x4,%esp
  80089e:	68 e4 40 80 00       	push   $0x8040e4
  8008a3:	68 a9 00 00 00       	push   $0xa9
  8008a8:	68 9c 40 80 00       	push   $0x80409c
  8008ad:	e8 f8 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008b2:	e8 96 19 00 00       	call   80224d <sys_calculate_free_frames>
  8008b7:	89 c2                	mov    %eax,%edx
  8008b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008bc:	39 c2                	cmp    %eax,%edx
  8008be:	74 17                	je     8008d7 <_main+0x89f>
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	68 01 41 80 00       	push   $0x804101
  8008c8:	68 aa 00 00 00       	push   $0xaa
  8008cd:	68 9c 40 80 00       	push   $0x80409c
  8008d2:	e8 d3 03 00 00       	call   800caa <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008d7:	e8 71 19 00 00       	call   80224d <sys_calculate_free_frames>
  8008dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008df:	e8 09 1a 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
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
  80091f:	68 b4 40 80 00       	push   $0x8040b4
  800924:	68 b0 00 00 00       	push   $0xb0
  800929:	68 9c 40 80 00       	push   $0x80409c
  80092e:	e8 77 03 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800933:	e8 b5 19 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  800938:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80093b:	74 17                	je     800954 <_main+0x91c>
  80093d:	83 ec 04             	sub    $0x4,%esp
  800940:	68 e4 40 80 00       	push   $0x8040e4
  800945:	68 b2 00 00 00       	push   $0xb2
  80094a:	68 9c 40 80 00       	push   $0x80409c
  80094f:	e8 56 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800954:	e8 f4 18 00 00       	call   80224d <sys_calculate_free_frames>
  800959:	89 c2                	mov    %eax,%edx
  80095b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80095e:	39 c2                	cmp    %eax,%edx
  800960:	74 17                	je     800979 <_main+0x941>
  800962:	83 ec 04             	sub    $0x4,%esp
  800965:	68 01 41 80 00       	push   $0x804101
  80096a:	68 b3 00 00 00       	push   $0xb3
  80096f:	68 9c 40 80 00       	push   $0x80409c
  800974:	e8 31 03 00 00       	call   800caa <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800979:	e8 cf 18 00 00       	call   80224d <sys_calculate_free_frames>
  80097e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800981:	e8 67 19 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  800986:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  800989:	8b 45 98             	mov    -0x68(%ebp),%eax
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 cc 15 00 00       	call   801f61 <free>
  800995:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800998:	e8 50 19 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 14 41 80 00       	push   $0x804114
  8009aa:	68 bd 00 00 00       	push   $0xbd
  8009af:	68 9c 40 80 00       	push   $0x80409c
  8009b4:	e8 f1 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009b9:	e8 8f 18 00 00       	call   80224d <sys_calculate_free_frames>
  8009be:	89 c2                	mov    %eax,%edx
  8009c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c3:	39 c2                	cmp    %eax,%edx
  8009c5:	74 17                	je     8009de <_main+0x9a6>
  8009c7:	83 ec 04             	sub    $0x4,%esp
  8009ca:	68 2b 41 80 00       	push   $0x80412b
  8009cf:	68 be 00 00 00       	push   $0xbe
  8009d4:	68 9c 40 80 00       	push   $0x80409c
  8009d9:	e8 cc 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8009de:	e8 6a 18 00 00       	call   80224d <sys_calculate_free_frames>
  8009e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e6:	e8 02 19 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  8009eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[9]);
  8009ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8009f1:	83 ec 0c             	sub    $0xc,%esp
  8009f4:	50                   	push   %eax
  8009f5:	e8 67 15 00 00       	call   801f61 <free>
  8009fa:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009fd:	e8 eb 18 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  800a02:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 14 41 80 00       	push   $0x804114
  800a0f:	68 c5 00 00 00       	push   $0xc5
  800a14:	68 9c 40 80 00       	push   $0x80409c
  800a19:	e8 8c 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a1e:	e8 2a 18 00 00       	call   80224d <sys_calculate_free_frames>
  800a23:	89 c2                	mov    %eax,%edx
  800a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a28:	39 c2                	cmp    %eax,%edx
  800a2a:	74 17                	je     800a43 <_main+0xa0b>
  800a2c:	83 ec 04             	sub    $0x4,%esp
  800a2f:	68 2b 41 80 00       	push   $0x80412b
  800a34:	68 c6 00 00 00       	push   $0xc6
  800a39:	68 9c 40 80 00       	push   $0x80409c
  800a3e:	e8 67 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a43:	e8 05 18 00 00       	call   80224d <sys_calculate_free_frames>
  800a48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a4b:	e8 9d 18 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  800a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800a53:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800a56:	83 ec 0c             	sub    $0xc,%esp
  800a59:	50                   	push   %eax
  800a5a:	e8 02 15 00 00       	call   801f61 <free>
  800a5f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a62:	e8 86 18 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  800a67:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 14 41 80 00       	push   $0x804114
  800a74:	68 cd 00 00 00       	push   $0xcd
  800a79:	68 9c 40 80 00       	push   $0x80409c
  800a7e:	e8 27 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a83:	e8 c5 17 00 00       	call   80224d <sys_calculate_free_frames>
  800a88:	89 c2                	mov    %eax,%edx
  800a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a8d:	39 c2                	cmp    %eax,%edx
  800a8f:	74 17                	je     800aa8 <_main+0xa70>
  800a91:	83 ec 04             	sub    $0x4,%esp
  800a94:	68 2b 41 80 00       	push   $0x80412b
  800a99:	68 ce 00 00 00       	push   $0xce
  800a9e:	68 9c 40 80 00       	push   $0x80409c
  800aa3:	e8 02 02 00 00       	call   800caa <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800aa8:	e8 a0 17 00 00       	call   80224d <sys_calculate_free_frames>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ab0:	e8 38 18 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
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
  800afe:	68 b4 40 80 00       	push   $0x8040b4
  800b03:	68 d8 00 00 00       	push   $0xd8
  800b08:	68 9c 40 80 00       	push   $0x80409c
  800b0d:	e8 98 01 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b12:	e8 d6 17 00 00       	call   8022ed <sys_pf_calculate_allocated_pages>
  800b17:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b1a:	74 17                	je     800b33 <_main+0xafb>
  800b1c:	83 ec 04             	sub    $0x4,%esp
  800b1f:	68 e4 40 80 00       	push   $0x8040e4
  800b24:	68 da 00 00 00       	push   $0xda
  800b29:	68 9c 40 80 00       	push   $0x80409c
  800b2e:	e8 77 01 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b33:	e8 15 17 00 00       	call   80224d <sys_calculate_free_frames>
  800b38:	89 c2                	mov    %eax,%edx
  800b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b3d:	39 c2                	cmp    %eax,%edx
  800b3f:	74 17                	je     800b58 <_main+0xb20>
  800b41:	83 ec 04             	sub    $0x4,%esp
  800b44:	68 01 41 80 00       	push   $0x804101
  800b49:	68 db 00 00 00       	push   $0xdb
  800b4e:	68 9c 40 80 00       	push   $0x80409c
  800b53:	e8 52 01 00 00       	call   800caa <_panic>
	}
	cprintf("Congratulations!! test FIRST FIT allocation (1) completed successfully.\n");
  800b58:	83 ec 0c             	sub    $0xc,%esp
  800b5b:	68 38 41 80 00       	push   $0x804138
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
  800b74:	e8 b4 19 00 00       	call   80252d <sys_getenvindex>
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
  800bdf:	e8 56 17 00 00       	call   80233a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800be4:	83 ec 0c             	sub    $0xc,%esp
  800be7:	68 9c 41 80 00       	push   $0x80419c
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
  800c0f:	68 c4 41 80 00       	push   $0x8041c4
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
  800c40:	68 ec 41 80 00       	push   $0x8041ec
  800c45:	e8 14 03 00 00       	call   800f5e <cprintf>
  800c4a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c4d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c52:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	50                   	push   %eax
  800c5c:	68 44 42 80 00       	push   $0x804244
  800c61:	e8 f8 02 00 00       	call   800f5e <cprintf>
  800c66:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	68 9c 41 80 00       	push   $0x80419c
  800c71:	e8 e8 02 00 00       	call   800f5e <cprintf>
  800c76:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c79:	e8 d6 16 00 00       	call   802354 <sys_enable_interrupt>

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
  800c91:	e8 63 18 00 00       	call   8024f9 <sys_destroy_env>
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
  800ca2:	e8 b8 18 00 00       	call   80255f <sys_exit_env>
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
  800ccb:	68 58 42 80 00       	push   $0x804258
  800cd0:	e8 89 02 00 00       	call   800f5e <cprintf>
  800cd5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cd8:	a1 00 50 80 00       	mov    0x805000,%eax
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	ff 75 08             	pushl  0x8(%ebp)
  800ce3:	50                   	push   %eax
  800ce4:	68 5d 42 80 00       	push   $0x80425d
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
  800d08:	68 79 42 80 00       	push   $0x804279
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
  800d34:	68 7c 42 80 00       	push   $0x80427c
  800d39:	6a 26                	push   $0x26
  800d3b:	68 c8 42 80 00       	push   $0x8042c8
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
  800e06:	68 d4 42 80 00       	push   $0x8042d4
  800e0b:	6a 3a                	push   $0x3a
  800e0d:	68 c8 42 80 00       	push   $0x8042c8
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
  800e76:	68 28 43 80 00       	push   $0x804328
  800e7b:	6a 44                	push   $0x44
  800e7d:	68 c8 42 80 00       	push   $0x8042c8
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
  800ed0:	e8 b7 12 00 00       	call   80218c <sys_cputs>
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
  800f47:	e8 40 12 00 00       	call   80218c <sys_cputs>
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
  800f91:	e8 a4 13 00 00       	call   80233a <sys_disable_interrupt>
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
  800fb1:	e8 9e 13 00 00       	call   802354 <sys_enable_interrupt>
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
  800ffb:	e8 10 2e 00 00       	call   803e10 <__udivdi3>
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
  80104b:	e8 d0 2e 00 00       	call   803f20 <__umoddi3>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	05 94 45 80 00       	add    $0x804594,%eax
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
  8011a6:	8b 04 85 b8 45 80 00 	mov    0x8045b8(,%eax,4),%eax
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
  801287:	8b 34 9d 00 44 80 00 	mov    0x804400(,%ebx,4),%esi
  80128e:	85 f6                	test   %esi,%esi
  801290:	75 19                	jne    8012ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801292:	53                   	push   %ebx
  801293:	68 a5 45 80 00       	push   $0x8045a5
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
  8012ac:	68 ae 45 80 00       	push   $0x8045ae
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
  8012d9:	be b1 45 80 00       	mov    $0x8045b1,%esi
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
  801cff:	68 10 47 80 00       	push   $0x804710
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
  801dcf:	e8 fc 04 00 00       	call   8022d0 <sys_allocate_chunk>
  801dd4:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801dd7:	a1 20 51 80 00       	mov    0x805120,%eax
  801ddc:	83 ec 0c             	sub    $0xc,%esp
  801ddf:	50                   	push   %eax
  801de0:	e8 71 0b 00 00       	call   802956 <initialize_MemBlocksList>
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
  801e0d:	68 35 47 80 00       	push   $0x804735
  801e12:	6a 33                	push   $0x33
  801e14:	68 53 47 80 00       	push   $0x804753
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
  801e8c:	68 60 47 80 00       	push   $0x804760
  801e91:	6a 34                	push   $0x34
  801e93:	68 53 47 80 00       	push   $0x804753
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
  801ee9:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801eec:	e8 f7 fd ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ef1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ef5:	75 07                	jne    801efe <malloc+0x18>
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  801efc:	eb 61                	jmp    801f5f <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801efe:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f05:	8b 55 08             	mov    0x8(%ebp),%edx
  801f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0b:	01 d0                	add    %edx,%eax
  801f0d:	48                   	dec    %eax
  801f0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f14:	ba 00 00 00 00       	mov    $0x0,%edx
  801f19:	f7 75 f0             	divl   -0x10(%ebp)
  801f1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1f:	29 d0                	sub    %edx,%eax
  801f21:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f24:	e8 75 07 00 00       	call   80269e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	74 11                	je     801f3e <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801f2d:	83 ec 0c             	sub    $0xc,%esp
  801f30:	ff 75 e8             	pushl  -0x18(%ebp)
  801f33:	e8 e0 0d 00 00       	call   802d18 <alloc_block_FF>
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801f3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f42:	74 16                	je     801f5a <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801f44:	83 ec 0c             	sub    $0xc,%esp
  801f47:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4a:	e8 3c 0b 00 00       	call   802a8b <insert_sorted_allocList>
  801f4f:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	8b 40 08             	mov    0x8(%eax),%eax
  801f58:	eb 05                	jmp    801f5f <malloc+0x79>
	}

    return NULL;
  801f5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801f67:	83 ec 04             	sub    $0x4,%esp
  801f6a:	68 84 47 80 00       	push   $0x804784
  801f6f:	6a 6f                	push   $0x6f
  801f71:	68 53 47 80 00       	push   $0x804753
  801f76:	e8 2f ed ff ff       	call   800caa <_panic>

00801f7b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 38             	sub    $0x38,%esp
  801f81:	8b 45 10             	mov    0x10(%ebp),%eax
  801f84:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f87:	e8 5c fd ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f90:	75 0a                	jne    801f9c <smalloc+0x21>
  801f92:	b8 00 00 00 00       	mov    $0x0,%eax
  801f97:	e9 8b 00 00 00       	jmp    802027 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801f9c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801fa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa9:	01 d0                	add    %edx,%eax
  801fab:	48                   	dec    %eax
  801fac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801faf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb2:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb7:	f7 75 f0             	divl   -0x10(%ebp)
  801fba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fbd:	29 d0                	sub    %edx,%eax
  801fbf:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801fc2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801fc9:	e8 d0 06 00 00       	call   80269e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	74 11                	je     801fe3 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801fd2:	83 ec 0c             	sub    $0xc,%esp
  801fd5:	ff 75 e8             	pushl  -0x18(%ebp)
  801fd8:	e8 3b 0d 00 00       	call   802d18 <alloc_block_FF>
  801fdd:	83 c4 10             	add    $0x10,%esp
  801fe0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801fe3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe7:	74 39                	je     802022 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	8b 40 08             	mov    0x8(%eax),%eax
  801fef:	89 c2                	mov    %eax,%edx
  801ff1:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ff5:	52                   	push   %edx
  801ff6:	50                   	push   %eax
  801ff7:	ff 75 0c             	pushl  0xc(%ebp)
  801ffa:	ff 75 08             	pushl  0x8(%ebp)
  801ffd:	e8 21 04 00 00       	call   802423 <sys_createSharedObject>
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  802008:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80200c:	74 14                	je     802022 <smalloc+0xa7>
  80200e:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  802012:	74 0e                	je     802022 <smalloc+0xa7>
  802014:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  802018:	74 08                	je     802022 <smalloc+0xa7>
			return (void*) mem_block->sva;
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	8b 40 08             	mov    0x8(%eax),%eax
  802020:	eb 05                	jmp    802027 <smalloc+0xac>
	}
	return NULL;
  802022:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80202f:	e8 b4 fc ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802034:	83 ec 08             	sub    $0x8,%esp
  802037:	ff 75 0c             	pushl  0xc(%ebp)
  80203a:	ff 75 08             	pushl  0x8(%ebp)
  80203d:	e8 0b 04 00 00       	call   80244d <sys_getSizeOfSharedObject>
  802042:	83 c4 10             	add    $0x10,%esp
  802045:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  802048:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80204c:	74 76                	je     8020c4 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80204e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802055:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80205b:	01 d0                	add    %edx,%eax
  80205d:	48                   	dec    %eax
  80205e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802064:	ba 00 00 00 00       	mov    $0x0,%edx
  802069:	f7 75 ec             	divl   -0x14(%ebp)
  80206c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80206f:	29 d0                	sub    %edx,%eax
  802071:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  802074:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80207b:	e8 1e 06 00 00       	call   80269e <sys_isUHeapPlacementStrategyFIRSTFIT>
  802080:	85 c0                	test   %eax,%eax
  802082:	74 11                	je     802095 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  802084:	83 ec 0c             	sub    $0xc,%esp
  802087:	ff 75 e4             	pushl  -0x1c(%ebp)
  80208a:	e8 89 0c 00 00       	call   802d18 <alloc_block_FF>
  80208f:	83 c4 10             	add    $0x10,%esp
  802092:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  802095:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802099:	74 29                	je     8020c4 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80209b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209e:	8b 40 08             	mov    0x8(%eax),%eax
  8020a1:	83 ec 04             	sub    $0x4,%esp
  8020a4:	50                   	push   %eax
  8020a5:	ff 75 0c             	pushl  0xc(%ebp)
  8020a8:	ff 75 08             	pushl  0x8(%ebp)
  8020ab:	e8 ba 03 00 00       	call   80246a <sys_getSharedObject>
  8020b0:	83 c4 10             	add    $0x10,%esp
  8020b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8020b6:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8020ba:	74 08                	je     8020c4 <sget+0x9b>
				return (void *)mem_block->sva;
  8020bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bf:	8b 40 08             	mov    0x8(%eax),%eax
  8020c2:	eb 05                	jmp    8020c9 <sget+0xa0>
		}
	}
	return (void *)NULL;
  8020c4:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020d1:	e8 12 fc ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8020d6:	83 ec 04             	sub    $0x4,%esp
  8020d9:	68 a8 47 80 00       	push   $0x8047a8
  8020de:	68 f1 00 00 00       	push   $0xf1
  8020e3:	68 53 47 80 00       	push   $0x804753
  8020e8:	e8 bd eb ff ff       	call   800caa <_panic>

008020ed <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8020f3:	83 ec 04             	sub    $0x4,%esp
  8020f6:	68 d0 47 80 00       	push   $0x8047d0
  8020fb:	68 05 01 00 00       	push   $0x105
  802100:	68 53 47 80 00       	push   $0x804753
  802105:	e8 a0 eb ff ff       	call   800caa <_panic>

0080210a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802110:	83 ec 04             	sub    $0x4,%esp
  802113:	68 f4 47 80 00       	push   $0x8047f4
  802118:	68 10 01 00 00       	push   $0x110
  80211d:	68 53 47 80 00       	push   $0x804753
  802122:	e8 83 eb ff ff       	call   800caa <_panic>

00802127 <shrink>:

}
void shrink(uint32 newSize)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
  80212a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80212d:	83 ec 04             	sub    $0x4,%esp
  802130:	68 f4 47 80 00       	push   $0x8047f4
  802135:	68 15 01 00 00       	push   $0x115
  80213a:	68 53 47 80 00       	push   $0x804753
  80213f:	e8 66 eb ff ff       	call   800caa <_panic>

00802144 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80214a:	83 ec 04             	sub    $0x4,%esp
  80214d:	68 f4 47 80 00       	push   $0x8047f4
  802152:	68 1a 01 00 00       	push   $0x11a
  802157:	68 53 47 80 00       	push   $0x804753
  80215c:	e8 49 eb ff ff       	call   800caa <_panic>

00802161 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
  802164:	57                   	push   %edi
  802165:	56                   	push   %esi
  802166:	53                   	push   %ebx
  802167:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802170:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802173:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802176:	8b 7d 18             	mov    0x18(%ebp),%edi
  802179:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80217c:	cd 30                	int    $0x30
  80217e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802181:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802184:	83 c4 10             	add    $0x10,%esp
  802187:	5b                   	pop    %ebx
  802188:	5e                   	pop    %esi
  802189:	5f                   	pop    %edi
  80218a:	5d                   	pop    %ebp
  80218b:	c3                   	ret    

0080218c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 04             	sub    $0x4,%esp
  802192:	8b 45 10             	mov    0x10(%ebp),%eax
  802195:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802198:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	52                   	push   %edx
  8021a4:	ff 75 0c             	pushl  0xc(%ebp)
  8021a7:	50                   	push   %eax
  8021a8:	6a 00                	push   $0x0
  8021aa:	e8 b2 ff ff ff       	call   802161 <syscall>
  8021af:	83 c4 18             	add    $0x18,%esp
}
  8021b2:	90                   	nop
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 01                	push   $0x1
  8021c4:	e8 98 ff ff ff       	call   802161 <syscall>
  8021c9:	83 c4 18             	add    $0x18,%esp
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8021d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	52                   	push   %edx
  8021de:	50                   	push   %eax
  8021df:	6a 05                	push   $0x5
  8021e1:	e8 7b ff ff ff       	call   802161 <syscall>
  8021e6:	83 c4 18             	add    $0x18,%esp
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	56                   	push   %esi
  8021ef:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021f0:	8b 75 18             	mov    0x18(%ebp),%esi
  8021f3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	56                   	push   %esi
  802200:	53                   	push   %ebx
  802201:	51                   	push   %ecx
  802202:	52                   	push   %edx
  802203:	50                   	push   %eax
  802204:	6a 06                	push   $0x6
  802206:	e8 56 ff ff ff       	call   802161 <syscall>
  80220b:	83 c4 18             	add    $0x18,%esp
}
  80220e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802211:	5b                   	pop    %ebx
  802212:	5e                   	pop    %esi
  802213:	5d                   	pop    %ebp
  802214:	c3                   	ret    

00802215 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802218:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	52                   	push   %edx
  802225:	50                   	push   %eax
  802226:	6a 07                	push   $0x7
  802228:	e8 34 ff ff ff       	call   802161 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	ff 75 0c             	pushl  0xc(%ebp)
  80223e:	ff 75 08             	pushl  0x8(%ebp)
  802241:	6a 08                	push   $0x8
  802243:	e8 19 ff ff ff       	call   802161 <syscall>
  802248:	83 c4 18             	add    $0x18,%esp
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 09                	push   $0x9
  80225c:	e8 00 ff ff ff       	call   802161 <syscall>
  802261:	83 c4 18             	add    $0x18,%esp
}
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 0a                	push   $0xa
  802275:	e8 e7 fe ff ff       	call   802161 <syscall>
  80227a:	83 c4 18             	add    $0x18,%esp
}
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    

0080227f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 0b                	push   $0xb
  80228e:	e8 ce fe ff ff       	call   802161 <syscall>
  802293:	83 c4 18             	add    $0x18,%esp
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	ff 75 0c             	pushl  0xc(%ebp)
  8022a4:	ff 75 08             	pushl  0x8(%ebp)
  8022a7:	6a 0f                	push   $0xf
  8022a9:	e8 b3 fe ff ff       	call   802161 <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
	return;
  8022b1:	90                   	nop
}
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	ff 75 0c             	pushl  0xc(%ebp)
  8022c0:	ff 75 08             	pushl  0x8(%ebp)
  8022c3:	6a 10                	push   $0x10
  8022c5:	e8 97 fe ff ff       	call   802161 <syscall>
  8022ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8022cd:	90                   	nop
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	ff 75 10             	pushl  0x10(%ebp)
  8022da:	ff 75 0c             	pushl  0xc(%ebp)
  8022dd:	ff 75 08             	pushl  0x8(%ebp)
  8022e0:	6a 11                	push   $0x11
  8022e2:	e8 7a fe ff ff       	call   802161 <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ea:	90                   	nop
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 0c                	push   $0xc
  8022fc:	e8 60 fe ff ff       	call   802161 <syscall>
  802301:	83 c4 18             	add    $0x18,%esp
}
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	ff 75 08             	pushl  0x8(%ebp)
  802314:	6a 0d                	push   $0xd
  802316:	e8 46 fe ff ff       	call   802161 <syscall>
  80231b:	83 c4 18             	add    $0x18,%esp
}
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 0e                	push   $0xe
  80232f:	e8 2d fe ff ff       	call   802161 <syscall>
  802334:	83 c4 18             	add    $0x18,%esp
}
  802337:	90                   	nop
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 13                	push   $0x13
  802349:	e8 13 fe ff ff       	call   802161 <syscall>
  80234e:	83 c4 18             	add    $0x18,%esp
}
  802351:	90                   	nop
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 14                	push   $0x14
  802363:	e8 f9 fd ff ff       	call   802161 <syscall>
  802368:	83 c4 18             	add    $0x18,%esp
}
  80236b:	90                   	nop
  80236c:	c9                   	leave  
  80236d:	c3                   	ret    

0080236e <sys_cputc>:


void
sys_cputc(const char c)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	83 ec 04             	sub    $0x4,%esp
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80237a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	50                   	push   %eax
  802387:	6a 15                	push   $0x15
  802389:	e8 d3 fd ff ff       	call   802161 <syscall>
  80238e:	83 c4 18             	add    $0x18,%esp
}
  802391:	90                   	nop
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 16                	push   $0x16
  8023a3:	e8 b9 fd ff ff       	call   802161 <syscall>
  8023a8:	83 c4 18             	add    $0x18,%esp
}
  8023ab:	90                   	nop
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	ff 75 0c             	pushl  0xc(%ebp)
  8023bd:	50                   	push   %eax
  8023be:	6a 17                	push   $0x17
  8023c0:	e8 9c fd ff ff       	call   802161 <syscall>
  8023c5:	83 c4 18             	add    $0x18,%esp
}
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	52                   	push   %edx
  8023da:	50                   	push   %eax
  8023db:	6a 1a                	push   $0x1a
  8023dd:	e8 7f fd ff ff       	call   802161 <syscall>
  8023e2:	83 c4 18             	add    $0x18,%esp
}
  8023e5:	c9                   	leave  
  8023e6:	c3                   	ret    

008023e7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	52                   	push   %edx
  8023f7:	50                   	push   %eax
  8023f8:	6a 18                	push   $0x18
  8023fa:	e8 62 fd ff ff       	call   802161 <syscall>
  8023ff:	83 c4 18             	add    $0x18,%esp
}
  802402:	90                   	nop
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802408:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	52                   	push   %edx
  802415:	50                   	push   %eax
  802416:	6a 19                	push   $0x19
  802418:	e8 44 fd ff ff       	call   802161 <syscall>
  80241d:	83 c4 18             	add    $0x18,%esp
}
  802420:	90                   	nop
  802421:	c9                   	leave  
  802422:	c3                   	ret    

00802423 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
  802426:	83 ec 04             	sub    $0x4,%esp
  802429:	8b 45 10             	mov    0x10(%ebp),%eax
  80242c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80242f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802432:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802436:	8b 45 08             	mov    0x8(%ebp),%eax
  802439:	6a 00                	push   $0x0
  80243b:	51                   	push   %ecx
  80243c:	52                   	push   %edx
  80243d:	ff 75 0c             	pushl  0xc(%ebp)
  802440:	50                   	push   %eax
  802441:	6a 1b                	push   $0x1b
  802443:	e8 19 fd ff ff       	call   802161 <syscall>
  802448:	83 c4 18             	add    $0x18,%esp
}
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    

0080244d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802450:	8b 55 0c             	mov    0xc(%ebp),%edx
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	52                   	push   %edx
  80245d:	50                   	push   %eax
  80245e:	6a 1c                	push   $0x1c
  802460:	e8 fc fc ff ff       	call   802161 <syscall>
  802465:	83 c4 18             	add    $0x18,%esp
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80246d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802470:	8b 55 0c             	mov    0xc(%ebp),%edx
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	51                   	push   %ecx
  80247b:	52                   	push   %edx
  80247c:	50                   	push   %eax
  80247d:	6a 1d                	push   $0x1d
  80247f:	e8 dd fc ff ff       	call   802161 <syscall>
  802484:	83 c4 18             	add    $0x18,%esp
}
  802487:	c9                   	leave  
  802488:	c3                   	ret    

00802489 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80248c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	52                   	push   %edx
  802499:	50                   	push   %eax
  80249a:	6a 1e                	push   $0x1e
  80249c:	e8 c0 fc ff ff       	call   802161 <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
}
  8024a4:	c9                   	leave  
  8024a5:	c3                   	ret    

008024a6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 1f                	push   $0x1f
  8024b5:	e8 a7 fc ff ff       	call   802161 <syscall>
  8024ba:	83 c4 18             	add    $0x18,%esp
}
  8024bd:	c9                   	leave  
  8024be:	c3                   	ret    

008024bf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	6a 00                	push   $0x0
  8024c7:	ff 75 14             	pushl  0x14(%ebp)
  8024ca:	ff 75 10             	pushl  0x10(%ebp)
  8024cd:	ff 75 0c             	pushl  0xc(%ebp)
  8024d0:	50                   	push   %eax
  8024d1:	6a 20                	push   $0x20
  8024d3:	e8 89 fc ff ff       	call   802161 <syscall>
  8024d8:	83 c4 18             	add    $0x18,%esp
}
  8024db:	c9                   	leave  
  8024dc:	c3                   	ret    

008024dd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8024e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	50                   	push   %eax
  8024ec:	6a 21                	push   $0x21
  8024ee:	e8 6e fc ff ff       	call   802161 <syscall>
  8024f3:	83 c4 18             	add    $0x18,%esp
}
  8024f6:	90                   	nop
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	50                   	push   %eax
  802508:	6a 22                	push   $0x22
  80250a:	e8 52 fc ff ff       	call   802161 <syscall>
  80250f:	83 c4 18             	add    $0x18,%esp
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 02                	push   $0x2
  802523:	e8 39 fc ff ff       	call   802161 <syscall>
  802528:	83 c4 18             	add    $0x18,%esp
}
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 03                	push   $0x3
  80253c:	e8 20 fc ff ff       	call   802161 <syscall>
  802541:	83 c4 18             	add    $0x18,%esp
}
  802544:	c9                   	leave  
  802545:	c3                   	ret    

00802546 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 04                	push   $0x4
  802555:	e8 07 fc ff ff       	call   802161 <syscall>
  80255a:	83 c4 18             	add    $0x18,%esp
}
  80255d:	c9                   	leave  
  80255e:	c3                   	ret    

0080255f <sys_exit_env>:


void sys_exit_env(void)
{
  80255f:	55                   	push   %ebp
  802560:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 23                	push   $0x23
  80256e:	e8 ee fb ff ff       	call   802161 <syscall>
  802573:	83 c4 18             	add    $0x18,%esp
}
  802576:	90                   	nop
  802577:	c9                   	leave  
  802578:	c3                   	ret    

00802579 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
  80257c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80257f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802582:	8d 50 04             	lea    0x4(%eax),%edx
  802585:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	52                   	push   %edx
  80258f:	50                   	push   %eax
  802590:	6a 24                	push   $0x24
  802592:	e8 ca fb ff ff       	call   802161 <syscall>
  802597:	83 c4 18             	add    $0x18,%esp
	return result;
  80259a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80259d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025a3:	89 01                	mov    %eax,(%ecx)
  8025a5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8025a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ab:	c9                   	leave  
  8025ac:	c2 04 00             	ret    $0x4

008025af <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	ff 75 10             	pushl  0x10(%ebp)
  8025b9:	ff 75 0c             	pushl  0xc(%ebp)
  8025bc:	ff 75 08             	pushl  0x8(%ebp)
  8025bf:	6a 12                	push   $0x12
  8025c1:	e8 9b fb ff ff       	call   802161 <syscall>
  8025c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c9:	90                   	nop
}
  8025ca:	c9                   	leave  
  8025cb:	c3                   	ret    

008025cc <sys_rcr2>:
uint32 sys_rcr2()
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 25                	push   $0x25
  8025db:	e8 81 fb ff ff       	call   802161 <syscall>
  8025e0:	83 c4 18             	add    $0x18,%esp
}
  8025e3:	c9                   	leave  
  8025e4:	c3                   	ret    

008025e5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8025e5:	55                   	push   %ebp
  8025e6:	89 e5                	mov    %esp,%ebp
  8025e8:	83 ec 04             	sub    $0x4,%esp
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025f1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	50                   	push   %eax
  8025fe:	6a 26                	push   $0x26
  802600:	e8 5c fb ff ff       	call   802161 <syscall>
  802605:	83 c4 18             	add    $0x18,%esp
	return ;
  802608:	90                   	nop
}
  802609:	c9                   	leave  
  80260a:	c3                   	ret    

0080260b <rsttst>:
void rsttst()
{
  80260b:	55                   	push   %ebp
  80260c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 28                	push   $0x28
  80261a:	e8 42 fb ff ff       	call   802161 <syscall>
  80261f:	83 c4 18             	add    $0x18,%esp
	return ;
  802622:	90                   	nop
}
  802623:	c9                   	leave  
  802624:	c3                   	ret    

00802625 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802625:	55                   	push   %ebp
  802626:	89 e5                	mov    %esp,%ebp
  802628:	83 ec 04             	sub    $0x4,%esp
  80262b:	8b 45 14             	mov    0x14(%ebp),%eax
  80262e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802631:	8b 55 18             	mov    0x18(%ebp),%edx
  802634:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802638:	52                   	push   %edx
  802639:	50                   	push   %eax
  80263a:	ff 75 10             	pushl  0x10(%ebp)
  80263d:	ff 75 0c             	pushl  0xc(%ebp)
  802640:	ff 75 08             	pushl  0x8(%ebp)
  802643:	6a 27                	push   $0x27
  802645:	e8 17 fb ff ff       	call   802161 <syscall>
  80264a:	83 c4 18             	add    $0x18,%esp
	return ;
  80264d:	90                   	nop
}
  80264e:	c9                   	leave  
  80264f:	c3                   	ret    

00802650 <chktst>:
void chktst(uint32 n)
{
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	ff 75 08             	pushl  0x8(%ebp)
  80265e:	6a 29                	push   $0x29
  802660:	e8 fc fa ff ff       	call   802161 <syscall>
  802665:	83 c4 18             	add    $0x18,%esp
	return ;
  802668:	90                   	nop
}
  802669:	c9                   	leave  
  80266a:	c3                   	ret    

0080266b <inctst>:

void inctst()
{
  80266b:	55                   	push   %ebp
  80266c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80266e:	6a 00                	push   $0x0
  802670:	6a 00                	push   $0x0
  802672:	6a 00                	push   $0x0
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 2a                	push   $0x2a
  80267a:	e8 e2 fa ff ff       	call   802161 <syscall>
  80267f:	83 c4 18             	add    $0x18,%esp
	return ;
  802682:	90                   	nop
}
  802683:	c9                   	leave  
  802684:	c3                   	ret    

00802685 <gettst>:
uint32 gettst()
{
  802685:	55                   	push   %ebp
  802686:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	6a 2b                	push   $0x2b
  802694:	e8 c8 fa ff ff       	call   802161 <syscall>
  802699:	83 c4 18             	add    $0x18,%esp
}
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
  8026a1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026a4:	6a 00                	push   $0x0
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 2c                	push   $0x2c
  8026b0:	e8 ac fa ff ff       	call   802161 <syscall>
  8026b5:	83 c4 18             	add    $0x18,%esp
  8026b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8026bb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8026bf:	75 07                	jne    8026c8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8026c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8026c6:	eb 05                	jmp    8026cd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8026c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026cd:	c9                   	leave  
  8026ce:	c3                   	ret    

008026cf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
  8026d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 2c                	push   $0x2c
  8026e1:	e8 7b fa ff ff       	call   802161 <syscall>
  8026e6:	83 c4 18             	add    $0x18,%esp
  8026e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026ec:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026f0:	75 07                	jne    8026f9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f7:	eb 05                	jmp    8026fe <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026fe:	c9                   	leave  
  8026ff:	c3                   	ret    

00802700 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802700:	55                   	push   %ebp
  802701:	89 e5                	mov    %esp,%ebp
  802703:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802706:	6a 00                	push   $0x0
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	6a 00                	push   $0x0
  802710:	6a 2c                	push   $0x2c
  802712:	e8 4a fa ff ff       	call   802161 <syscall>
  802717:	83 c4 18             	add    $0x18,%esp
  80271a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80271d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802721:	75 07                	jne    80272a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802723:	b8 01 00 00 00       	mov    $0x1,%eax
  802728:	eb 05                	jmp    80272f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80272a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80272f:	c9                   	leave  
  802730:	c3                   	ret    

00802731 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
  802734:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 2c                	push   $0x2c
  802743:	e8 19 fa ff ff       	call   802161 <syscall>
  802748:	83 c4 18             	add    $0x18,%esp
  80274b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80274e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802752:	75 07                	jne    80275b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802754:	b8 01 00 00 00       	mov    $0x1,%eax
  802759:	eb 05                	jmp    802760 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80275b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802760:	c9                   	leave  
  802761:	c3                   	ret    

00802762 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802762:	55                   	push   %ebp
  802763:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	ff 75 08             	pushl  0x8(%ebp)
  802770:	6a 2d                	push   $0x2d
  802772:	e8 ea f9 ff ff       	call   802161 <syscall>
  802777:	83 c4 18             	add    $0x18,%esp
	return ;
  80277a:	90                   	nop
}
  80277b:	c9                   	leave  
  80277c:	c3                   	ret    

0080277d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80277d:	55                   	push   %ebp
  80277e:	89 e5                	mov    %esp,%ebp
  802780:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802781:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802784:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80278a:	8b 45 08             	mov    0x8(%ebp),%eax
  80278d:	6a 00                	push   $0x0
  80278f:	53                   	push   %ebx
  802790:	51                   	push   %ecx
  802791:	52                   	push   %edx
  802792:	50                   	push   %eax
  802793:	6a 2e                	push   $0x2e
  802795:	e8 c7 f9 ff ff       	call   802161 <syscall>
  80279a:	83 c4 18             	add    $0x18,%esp
}
  80279d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027a0:	c9                   	leave  
  8027a1:	c3                   	ret    

008027a2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8027a2:	55                   	push   %ebp
  8027a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8027a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ab:	6a 00                	push   $0x0
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 00                	push   $0x0
  8027b1:	52                   	push   %edx
  8027b2:	50                   	push   %eax
  8027b3:	6a 2f                	push   $0x2f
  8027b5:	e8 a7 f9 ff ff       	call   802161 <syscall>
  8027ba:	83 c4 18             	add    $0x18,%esp
}
  8027bd:	c9                   	leave  
  8027be:	c3                   	ret    

008027bf <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8027bf:	55                   	push   %ebp
  8027c0:	89 e5                	mov    %esp,%ebp
  8027c2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8027c5:	83 ec 0c             	sub    $0xc,%esp
  8027c8:	68 04 48 80 00       	push   $0x804804
  8027cd:	e8 8c e7 ff ff       	call   800f5e <cprintf>
  8027d2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8027d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8027dc:	83 ec 0c             	sub    $0xc,%esp
  8027df:	68 30 48 80 00       	push   $0x804830
  8027e4:	e8 75 e7 ff ff       	call   800f5e <cprintf>
  8027e9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8027ec:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027f0:	a1 38 51 80 00       	mov    0x805138,%eax
  8027f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f8:	eb 56                	jmp    802850 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027fe:	74 1c                	je     80281c <print_mem_block_lists+0x5d>
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	8b 50 08             	mov    0x8(%eax),%edx
  802806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802809:	8b 48 08             	mov    0x8(%eax),%ecx
  80280c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280f:	8b 40 0c             	mov    0xc(%eax),%eax
  802812:	01 c8                	add    %ecx,%eax
  802814:	39 c2                	cmp    %eax,%edx
  802816:	73 04                	jae    80281c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802818:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 50 08             	mov    0x8(%eax),%edx
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	8b 40 0c             	mov    0xc(%eax),%eax
  802828:	01 c2                	add    %eax,%edx
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	8b 40 08             	mov    0x8(%eax),%eax
  802830:	83 ec 04             	sub    $0x4,%esp
  802833:	52                   	push   %edx
  802834:	50                   	push   %eax
  802835:	68 45 48 80 00       	push   $0x804845
  80283a:	e8 1f e7 ff ff       	call   800f5e <cprintf>
  80283f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802848:	a1 40 51 80 00       	mov    0x805140,%eax
  80284d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802850:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802854:	74 07                	je     80285d <print_mem_block_lists+0x9e>
  802856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802859:	8b 00                	mov    (%eax),%eax
  80285b:	eb 05                	jmp    802862 <print_mem_block_lists+0xa3>
  80285d:	b8 00 00 00 00       	mov    $0x0,%eax
  802862:	a3 40 51 80 00       	mov    %eax,0x805140
  802867:	a1 40 51 80 00       	mov    0x805140,%eax
  80286c:	85 c0                	test   %eax,%eax
  80286e:	75 8a                	jne    8027fa <print_mem_block_lists+0x3b>
  802870:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802874:	75 84                	jne    8027fa <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802876:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80287a:	75 10                	jne    80288c <print_mem_block_lists+0xcd>
  80287c:	83 ec 0c             	sub    $0xc,%esp
  80287f:	68 54 48 80 00       	push   $0x804854
  802884:	e8 d5 e6 ff ff       	call   800f5e <cprintf>
  802889:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80288c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802893:	83 ec 0c             	sub    $0xc,%esp
  802896:	68 78 48 80 00       	push   $0x804878
  80289b:	e8 be e6 ff ff       	call   800f5e <cprintf>
  8028a0:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8028a3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028a7:	a1 40 50 80 00       	mov    0x805040,%eax
  8028ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028af:	eb 56                	jmp    802907 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8028b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b5:	74 1c                	je     8028d3 <print_mem_block_lists+0x114>
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 50 08             	mov    0x8(%eax),%edx
  8028bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c0:	8b 48 08             	mov    0x8(%eax),%ecx
  8028c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c9:	01 c8                	add    %ecx,%eax
  8028cb:	39 c2                	cmp    %eax,%edx
  8028cd:	73 04                	jae    8028d3 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8028cf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 50 08             	mov    0x8(%eax),%edx
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028df:	01 c2                	add    %eax,%edx
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	8b 40 08             	mov    0x8(%eax),%eax
  8028e7:	83 ec 04             	sub    $0x4,%esp
  8028ea:	52                   	push   %edx
  8028eb:	50                   	push   %eax
  8028ec:	68 45 48 80 00       	push   $0x804845
  8028f1:	e8 68 e6 ff ff       	call   800f5e <cprintf>
  8028f6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028ff:	a1 48 50 80 00       	mov    0x805048,%eax
  802904:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802907:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290b:	74 07                	je     802914 <print_mem_block_lists+0x155>
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 00                	mov    (%eax),%eax
  802912:	eb 05                	jmp    802919 <print_mem_block_lists+0x15a>
  802914:	b8 00 00 00 00       	mov    $0x0,%eax
  802919:	a3 48 50 80 00       	mov    %eax,0x805048
  80291e:	a1 48 50 80 00       	mov    0x805048,%eax
  802923:	85 c0                	test   %eax,%eax
  802925:	75 8a                	jne    8028b1 <print_mem_block_lists+0xf2>
  802927:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80292b:	75 84                	jne    8028b1 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80292d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802931:	75 10                	jne    802943 <print_mem_block_lists+0x184>
  802933:	83 ec 0c             	sub    $0xc,%esp
  802936:	68 90 48 80 00       	push   $0x804890
  80293b:	e8 1e e6 ff ff       	call   800f5e <cprintf>
  802940:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802943:	83 ec 0c             	sub    $0xc,%esp
  802946:	68 04 48 80 00       	push   $0x804804
  80294b:	e8 0e e6 ff ff       	call   800f5e <cprintf>
  802950:	83 c4 10             	add    $0x10,%esp

}
  802953:	90                   	nop
  802954:	c9                   	leave  
  802955:	c3                   	ret    

00802956 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802956:	55                   	push   %ebp
  802957:	89 e5                	mov    %esp,%ebp
  802959:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80295c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802963:	00 00 00 
  802966:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80296d:	00 00 00 
  802970:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802977:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80297a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802981:	e9 9e 00 00 00       	jmp    802a24 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802986:	a1 50 50 80 00       	mov    0x805050,%eax
  80298b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298e:	c1 e2 04             	shl    $0x4,%edx
  802991:	01 d0                	add    %edx,%eax
  802993:	85 c0                	test   %eax,%eax
  802995:	75 14                	jne    8029ab <initialize_MemBlocksList+0x55>
  802997:	83 ec 04             	sub    $0x4,%esp
  80299a:	68 b8 48 80 00       	push   $0x8048b8
  80299f:	6a 46                	push   $0x46
  8029a1:	68 db 48 80 00       	push   $0x8048db
  8029a6:	e8 ff e2 ff ff       	call   800caa <_panic>
  8029ab:	a1 50 50 80 00       	mov    0x805050,%eax
  8029b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b3:	c1 e2 04             	shl    $0x4,%edx
  8029b6:	01 d0                	add    %edx,%eax
  8029b8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8029be:	89 10                	mov    %edx,(%eax)
  8029c0:	8b 00                	mov    (%eax),%eax
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	74 18                	je     8029de <initialize_MemBlocksList+0x88>
  8029c6:	a1 48 51 80 00       	mov    0x805148,%eax
  8029cb:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8029d1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8029d4:	c1 e1 04             	shl    $0x4,%ecx
  8029d7:	01 ca                	add    %ecx,%edx
  8029d9:	89 50 04             	mov    %edx,0x4(%eax)
  8029dc:	eb 12                	jmp    8029f0 <initialize_MemBlocksList+0x9a>
  8029de:	a1 50 50 80 00       	mov    0x805050,%eax
  8029e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e6:	c1 e2 04             	shl    $0x4,%edx
  8029e9:	01 d0                	add    %edx,%eax
  8029eb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029f0:	a1 50 50 80 00       	mov    0x805050,%eax
  8029f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f8:	c1 e2 04             	shl    $0x4,%edx
  8029fb:	01 d0                	add    %edx,%eax
  8029fd:	a3 48 51 80 00       	mov    %eax,0x805148
  802a02:	a1 50 50 80 00       	mov    0x805050,%eax
  802a07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0a:	c1 e2 04             	shl    $0x4,%edx
  802a0d:	01 d0                	add    %edx,%eax
  802a0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a16:	a1 54 51 80 00       	mov    0x805154,%eax
  802a1b:	40                   	inc    %eax
  802a1c:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802a21:	ff 45 f4             	incl   -0xc(%ebp)
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a2a:	0f 82 56 ff ff ff    	jb     802986 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802a30:	90                   	nop
  802a31:	c9                   	leave  
  802a32:	c3                   	ret    

00802a33 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802a33:	55                   	push   %ebp
  802a34:	89 e5                	mov    %esp,%ebp
  802a36:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	8b 00                	mov    (%eax),%eax
  802a3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a41:	eb 19                	jmp    802a5c <find_block+0x29>
	{
		if(va==point->sva)
  802a43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a46:	8b 40 08             	mov    0x8(%eax),%eax
  802a49:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a4c:	75 05                	jne    802a53 <find_block+0x20>
		   return point;
  802a4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a51:	eb 36                	jmp    802a89 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	8b 40 08             	mov    0x8(%eax),%eax
  802a59:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a5c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a60:	74 07                	je     802a69 <find_block+0x36>
  802a62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a65:	8b 00                	mov    (%eax),%eax
  802a67:	eb 05                	jmp    802a6e <find_block+0x3b>
  802a69:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a71:	89 42 08             	mov    %eax,0x8(%edx)
  802a74:	8b 45 08             	mov    0x8(%ebp),%eax
  802a77:	8b 40 08             	mov    0x8(%eax),%eax
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	75 c5                	jne    802a43 <find_block+0x10>
  802a7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a82:	75 bf                	jne    802a43 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802a84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a89:	c9                   	leave  
  802a8a:	c3                   	ret    

00802a8b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802a8b:	55                   	push   %ebp
  802a8c:	89 e5                	mov    %esp,%ebp
  802a8e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802a91:	a1 40 50 80 00       	mov    0x805040,%eax
  802a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802a99:	a1 44 50 80 00       	mov    0x805044,%eax
  802a9e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802aa7:	74 24                	je     802acd <insert_sorted_allocList+0x42>
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	8b 50 08             	mov    0x8(%eax),%edx
  802aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab2:	8b 40 08             	mov    0x8(%eax),%eax
  802ab5:	39 c2                	cmp    %eax,%edx
  802ab7:	76 14                	jbe    802acd <insert_sorted_allocList+0x42>
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	8b 50 08             	mov    0x8(%eax),%edx
  802abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac2:	8b 40 08             	mov    0x8(%eax),%eax
  802ac5:	39 c2                	cmp    %eax,%edx
  802ac7:	0f 82 60 01 00 00    	jb     802c2d <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802acd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ad1:	75 65                	jne    802b38 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802ad3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad7:	75 14                	jne    802aed <insert_sorted_allocList+0x62>
  802ad9:	83 ec 04             	sub    $0x4,%esp
  802adc:	68 b8 48 80 00       	push   $0x8048b8
  802ae1:	6a 6b                	push   $0x6b
  802ae3:	68 db 48 80 00       	push   $0x8048db
  802ae8:	e8 bd e1 ff ff       	call   800caa <_panic>
  802aed:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	89 10                	mov    %edx,(%eax)
  802af8:	8b 45 08             	mov    0x8(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	85 c0                	test   %eax,%eax
  802aff:	74 0d                	je     802b0e <insert_sorted_allocList+0x83>
  802b01:	a1 40 50 80 00       	mov    0x805040,%eax
  802b06:	8b 55 08             	mov    0x8(%ebp),%edx
  802b09:	89 50 04             	mov    %edx,0x4(%eax)
  802b0c:	eb 08                	jmp    802b16 <insert_sorted_allocList+0x8b>
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	a3 44 50 80 00       	mov    %eax,0x805044
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	a3 40 50 80 00       	mov    %eax,0x805040
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b28:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b2d:	40                   	inc    %eax
  802b2e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b33:	e9 dc 01 00 00       	jmp    802d14 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	8b 50 08             	mov    0x8(%eax),%edx
  802b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b41:	8b 40 08             	mov    0x8(%eax),%eax
  802b44:	39 c2                	cmp    %eax,%edx
  802b46:	77 6c                	ja     802bb4 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802b48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b4c:	74 06                	je     802b54 <insert_sorted_allocList+0xc9>
  802b4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b52:	75 14                	jne    802b68 <insert_sorted_allocList+0xdd>
  802b54:	83 ec 04             	sub    $0x4,%esp
  802b57:	68 f4 48 80 00       	push   $0x8048f4
  802b5c:	6a 6f                	push   $0x6f
  802b5e:	68 db 48 80 00       	push   $0x8048db
  802b63:	e8 42 e1 ff ff       	call   800caa <_panic>
  802b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6b:	8b 50 04             	mov    0x4(%eax),%edx
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	89 50 04             	mov    %edx,0x4(%eax)
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7a:	89 10                	mov    %edx,(%eax)
  802b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7f:	8b 40 04             	mov    0x4(%eax),%eax
  802b82:	85 c0                	test   %eax,%eax
  802b84:	74 0d                	je     802b93 <insert_sorted_allocList+0x108>
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	8b 40 04             	mov    0x4(%eax),%eax
  802b8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8f:	89 10                	mov    %edx,(%eax)
  802b91:	eb 08                	jmp    802b9b <insert_sorted_allocList+0x110>
  802b93:	8b 45 08             	mov    0x8(%ebp),%eax
  802b96:	a3 40 50 80 00       	mov    %eax,0x805040
  802b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba1:	89 50 04             	mov    %edx,0x4(%eax)
  802ba4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ba9:	40                   	inc    %eax
  802baa:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802baf:	e9 60 01 00 00       	jmp    802d14 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	8b 50 08             	mov    0x8(%eax),%edx
  802bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbd:	8b 40 08             	mov    0x8(%eax),%eax
  802bc0:	39 c2                	cmp    %eax,%edx
  802bc2:	0f 82 4c 01 00 00    	jb     802d14 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802bc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bcc:	75 14                	jne    802be2 <insert_sorted_allocList+0x157>
  802bce:	83 ec 04             	sub    $0x4,%esp
  802bd1:	68 2c 49 80 00       	push   $0x80492c
  802bd6:	6a 73                	push   $0x73
  802bd8:	68 db 48 80 00       	push   $0x8048db
  802bdd:	e8 c8 e0 ff ff       	call   800caa <_panic>
  802be2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	89 50 04             	mov    %edx,0x4(%eax)
  802bee:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf1:	8b 40 04             	mov    0x4(%eax),%eax
  802bf4:	85 c0                	test   %eax,%eax
  802bf6:	74 0c                	je     802c04 <insert_sorted_allocList+0x179>
  802bf8:	a1 44 50 80 00       	mov    0x805044,%eax
  802bfd:	8b 55 08             	mov    0x8(%ebp),%edx
  802c00:	89 10                	mov    %edx,(%eax)
  802c02:	eb 08                	jmp    802c0c <insert_sorted_allocList+0x181>
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	a3 40 50 80 00       	mov    %eax,0x805040
  802c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0f:	a3 44 50 80 00       	mov    %eax,0x805044
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c22:	40                   	inc    %eax
  802c23:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c28:	e9 e7 00 00 00       	jmp    802d14 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802c33:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802c3a:	a1 40 50 80 00       	mov    0x805040,%eax
  802c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c42:	e9 9d 00 00 00       	jmp    802ce4 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	8b 00                	mov    (%eax),%eax
  802c4c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	8b 50 08             	mov    0x8(%eax),%edx
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	8b 40 08             	mov    0x8(%eax),%eax
  802c5b:	39 c2                	cmp    %eax,%edx
  802c5d:	76 7d                	jbe    802cdc <insert_sorted_allocList+0x251>
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	8b 50 08             	mov    0x8(%eax),%edx
  802c65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c68:	8b 40 08             	mov    0x8(%eax),%eax
  802c6b:	39 c2                	cmp    %eax,%edx
  802c6d:	73 6d                	jae    802cdc <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802c6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c73:	74 06                	je     802c7b <insert_sorted_allocList+0x1f0>
  802c75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c79:	75 14                	jne    802c8f <insert_sorted_allocList+0x204>
  802c7b:	83 ec 04             	sub    $0x4,%esp
  802c7e:	68 50 49 80 00       	push   $0x804950
  802c83:	6a 7f                	push   $0x7f
  802c85:	68 db 48 80 00       	push   $0x8048db
  802c8a:	e8 1b e0 ff ff       	call   800caa <_panic>
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	8b 10                	mov    (%eax),%edx
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	89 10                	mov    %edx,(%eax)
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	8b 00                	mov    (%eax),%eax
  802c9e:	85 c0                	test   %eax,%eax
  802ca0:	74 0b                	je     802cad <insert_sorted_allocList+0x222>
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 00                	mov    (%eax),%eax
  802ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  802caa:	89 50 04             	mov    %edx,0x4(%eax)
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb3:	89 10                	mov    %edx,(%eax)
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cbb:	89 50 04             	mov    %edx,0x4(%eax)
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	8b 00                	mov    (%eax),%eax
  802cc3:	85 c0                	test   %eax,%eax
  802cc5:	75 08                	jne    802ccf <insert_sorted_allocList+0x244>
  802cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cca:	a3 44 50 80 00       	mov    %eax,0x805044
  802ccf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cd4:	40                   	inc    %eax
  802cd5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802cda:	eb 39                	jmp    802d15 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802cdc:	a1 48 50 80 00       	mov    0x805048,%eax
  802ce1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce8:	74 07                	je     802cf1 <insert_sorted_allocList+0x266>
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	8b 00                	mov    (%eax),%eax
  802cef:	eb 05                	jmp    802cf6 <insert_sorted_allocList+0x26b>
  802cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf6:	a3 48 50 80 00       	mov    %eax,0x805048
  802cfb:	a1 48 50 80 00       	mov    0x805048,%eax
  802d00:	85 c0                	test   %eax,%eax
  802d02:	0f 85 3f ff ff ff    	jne    802c47 <insert_sorted_allocList+0x1bc>
  802d08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0c:	0f 85 35 ff ff ff    	jne    802c47 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802d12:	eb 01                	jmp    802d15 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802d14:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802d15:	90                   	nop
  802d16:	c9                   	leave  
  802d17:	c3                   	ret    

00802d18 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802d18:	55                   	push   %ebp
  802d19:	89 e5                	mov    %esp,%ebp
  802d1b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802d1e:	a1 38 51 80 00       	mov    0x805138,%eax
  802d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d26:	e9 85 01 00 00       	jmp    802eb0 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d31:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d34:	0f 82 6e 01 00 00    	jb     802ea8 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d40:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d43:	0f 85 8a 00 00 00    	jne    802dd3 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802d49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4d:	75 17                	jne    802d66 <alloc_block_FF+0x4e>
  802d4f:	83 ec 04             	sub    $0x4,%esp
  802d52:	68 84 49 80 00       	push   $0x804984
  802d57:	68 93 00 00 00       	push   $0x93
  802d5c:	68 db 48 80 00       	push   $0x8048db
  802d61:	e8 44 df ff ff       	call   800caa <_panic>
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 00                	mov    (%eax),%eax
  802d6b:	85 c0                	test   %eax,%eax
  802d6d:	74 10                	je     802d7f <alloc_block_FF+0x67>
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 00                	mov    (%eax),%eax
  802d74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d77:	8b 52 04             	mov    0x4(%edx),%edx
  802d7a:	89 50 04             	mov    %edx,0x4(%eax)
  802d7d:	eb 0b                	jmp    802d8a <alloc_block_FF+0x72>
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 40 04             	mov    0x4(%eax),%eax
  802d85:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	8b 40 04             	mov    0x4(%eax),%eax
  802d90:	85 c0                	test   %eax,%eax
  802d92:	74 0f                	je     802da3 <alloc_block_FF+0x8b>
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	8b 40 04             	mov    0x4(%eax),%eax
  802d9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d9d:	8b 12                	mov    (%edx),%edx
  802d9f:	89 10                	mov    %edx,(%eax)
  802da1:	eb 0a                	jmp    802dad <alloc_block_FF+0x95>
  802da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da6:	8b 00                	mov    (%eax),%eax
  802da8:	a3 38 51 80 00       	mov    %eax,0x805138
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc0:	a1 44 51 80 00       	mov    0x805144,%eax
  802dc5:	48                   	dec    %eax
  802dc6:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dce:	e9 10 01 00 00       	jmp    802ee3 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ddc:	0f 86 c6 00 00 00    	jbe    802ea8 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802de2:	a1 48 51 80 00       	mov    0x805148,%eax
  802de7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 50 08             	mov    0x8(%eax),%edx
  802df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df3:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfc:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802dff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e03:	75 17                	jne    802e1c <alloc_block_FF+0x104>
  802e05:	83 ec 04             	sub    $0x4,%esp
  802e08:	68 84 49 80 00       	push   $0x804984
  802e0d:	68 9b 00 00 00       	push   $0x9b
  802e12:	68 db 48 80 00       	push   $0x8048db
  802e17:	e8 8e de ff ff       	call   800caa <_panic>
  802e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1f:	8b 00                	mov    (%eax),%eax
  802e21:	85 c0                	test   %eax,%eax
  802e23:	74 10                	je     802e35 <alloc_block_FF+0x11d>
  802e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e28:	8b 00                	mov    (%eax),%eax
  802e2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e2d:	8b 52 04             	mov    0x4(%edx),%edx
  802e30:	89 50 04             	mov    %edx,0x4(%eax)
  802e33:	eb 0b                	jmp    802e40 <alloc_block_FF+0x128>
  802e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e38:	8b 40 04             	mov    0x4(%eax),%eax
  802e3b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e43:	8b 40 04             	mov    0x4(%eax),%eax
  802e46:	85 c0                	test   %eax,%eax
  802e48:	74 0f                	je     802e59 <alloc_block_FF+0x141>
  802e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4d:	8b 40 04             	mov    0x4(%eax),%eax
  802e50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e53:	8b 12                	mov    (%edx),%edx
  802e55:	89 10                	mov    %edx,(%eax)
  802e57:	eb 0a                	jmp    802e63 <alloc_block_FF+0x14b>
  802e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5c:	8b 00                	mov    (%eax),%eax
  802e5e:	a3 48 51 80 00       	mov    %eax,0x805148
  802e63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e76:	a1 54 51 80 00       	mov    0x805154,%eax
  802e7b:	48                   	dec    %eax
  802e7c:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e84:	8b 50 08             	mov    0x8(%eax),%edx
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	01 c2                	add    %eax,%edx
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8b 40 0c             	mov    0xc(%eax),%eax
  802e98:	2b 45 08             	sub    0x8(%ebp),%eax
  802e9b:	89 c2                	mov    %eax,%edx
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	eb 3b                	jmp    802ee3 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802ea8:	a1 40 51 80 00       	mov    0x805140,%eax
  802ead:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb4:	74 07                	je     802ebd <alloc_block_FF+0x1a5>
  802eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb9:	8b 00                	mov    (%eax),%eax
  802ebb:	eb 05                	jmp    802ec2 <alloc_block_FF+0x1aa>
  802ebd:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec2:	a3 40 51 80 00       	mov    %eax,0x805140
  802ec7:	a1 40 51 80 00       	mov    0x805140,%eax
  802ecc:	85 c0                	test   %eax,%eax
  802ece:	0f 85 57 fe ff ff    	jne    802d2b <alloc_block_FF+0x13>
  802ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed8:	0f 85 4d fe ff ff    	jne    802d2b <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802ede:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ee3:	c9                   	leave  
  802ee4:	c3                   	ret    

00802ee5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ee5:	55                   	push   %ebp
  802ee6:	89 e5                	mov    %esp,%ebp
  802ee8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802eeb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ef2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802efa:	e9 df 00 00 00       	jmp    802fde <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f02:	8b 40 0c             	mov    0xc(%eax),%eax
  802f05:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f08:	0f 82 c8 00 00 00    	jb     802fd6 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	8b 40 0c             	mov    0xc(%eax),%eax
  802f14:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f17:	0f 85 8a 00 00 00    	jne    802fa7 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802f1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f21:	75 17                	jne    802f3a <alloc_block_BF+0x55>
  802f23:	83 ec 04             	sub    $0x4,%esp
  802f26:	68 84 49 80 00       	push   $0x804984
  802f2b:	68 b7 00 00 00       	push   $0xb7
  802f30:	68 db 48 80 00       	push   $0x8048db
  802f35:	e8 70 dd ff ff       	call   800caa <_panic>
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	8b 00                	mov    (%eax),%eax
  802f3f:	85 c0                	test   %eax,%eax
  802f41:	74 10                	je     802f53 <alloc_block_BF+0x6e>
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 00                	mov    (%eax),%eax
  802f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4b:	8b 52 04             	mov    0x4(%edx),%edx
  802f4e:	89 50 04             	mov    %edx,0x4(%eax)
  802f51:	eb 0b                	jmp    802f5e <alloc_block_BF+0x79>
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	8b 40 04             	mov    0x4(%eax),%eax
  802f59:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f61:	8b 40 04             	mov    0x4(%eax),%eax
  802f64:	85 c0                	test   %eax,%eax
  802f66:	74 0f                	je     802f77 <alloc_block_BF+0x92>
  802f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6b:	8b 40 04             	mov    0x4(%eax),%eax
  802f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f71:	8b 12                	mov    (%edx),%edx
  802f73:	89 10                	mov    %edx,(%eax)
  802f75:	eb 0a                	jmp    802f81 <alloc_block_BF+0x9c>
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	8b 00                	mov    (%eax),%eax
  802f7c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f94:	a1 44 51 80 00       	mov    0x805144,%eax
  802f99:	48                   	dec    %eax
  802f9a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	e9 4d 01 00 00       	jmp    8030f4 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faa:	8b 40 0c             	mov    0xc(%eax),%eax
  802fad:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fb0:	76 24                	jbe    802fd6 <alloc_block_BF+0xf1>
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802fbb:	73 19                	jae    802fd6 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802fbd:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fca:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd0:	8b 40 08             	mov    0x8(%eax),%eax
  802fd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802fd6:	a1 40 51 80 00       	mov    0x805140,%eax
  802fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe2:	74 07                	je     802feb <alloc_block_BF+0x106>
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	8b 00                	mov    (%eax),%eax
  802fe9:	eb 05                	jmp    802ff0 <alloc_block_BF+0x10b>
  802feb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff0:	a3 40 51 80 00       	mov    %eax,0x805140
  802ff5:	a1 40 51 80 00       	mov    0x805140,%eax
  802ffa:	85 c0                	test   %eax,%eax
  802ffc:	0f 85 fd fe ff ff    	jne    802eff <alloc_block_BF+0x1a>
  803002:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803006:	0f 85 f3 fe ff ff    	jne    802eff <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80300c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803010:	0f 84 d9 00 00 00    	je     8030ef <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  803016:	a1 48 51 80 00       	mov    0x805148,%eax
  80301b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80301e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803021:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803024:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302a:	8b 55 08             	mov    0x8(%ebp),%edx
  80302d:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803030:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803034:	75 17                	jne    80304d <alloc_block_BF+0x168>
  803036:	83 ec 04             	sub    $0x4,%esp
  803039:	68 84 49 80 00       	push   $0x804984
  80303e:	68 c7 00 00 00       	push   $0xc7
  803043:	68 db 48 80 00       	push   $0x8048db
  803048:	e8 5d dc ff ff       	call   800caa <_panic>
  80304d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803050:	8b 00                	mov    (%eax),%eax
  803052:	85 c0                	test   %eax,%eax
  803054:	74 10                	je     803066 <alloc_block_BF+0x181>
  803056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803059:	8b 00                	mov    (%eax),%eax
  80305b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80305e:	8b 52 04             	mov    0x4(%edx),%edx
  803061:	89 50 04             	mov    %edx,0x4(%eax)
  803064:	eb 0b                	jmp    803071 <alloc_block_BF+0x18c>
  803066:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803069:	8b 40 04             	mov    0x4(%eax),%eax
  80306c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803074:	8b 40 04             	mov    0x4(%eax),%eax
  803077:	85 c0                	test   %eax,%eax
  803079:	74 0f                	je     80308a <alloc_block_BF+0x1a5>
  80307b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80307e:	8b 40 04             	mov    0x4(%eax),%eax
  803081:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803084:	8b 12                	mov    (%edx),%edx
  803086:	89 10                	mov    %edx,(%eax)
  803088:	eb 0a                	jmp    803094 <alloc_block_BF+0x1af>
  80308a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80308d:	8b 00                	mov    (%eax),%eax
  80308f:	a3 48 51 80 00       	mov    %eax,0x805148
  803094:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803097:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80309d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a7:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ac:	48                   	dec    %eax
  8030ad:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8030b2:	83 ec 08             	sub    $0x8,%esp
  8030b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8030b8:	68 38 51 80 00       	push   $0x805138
  8030bd:	e8 71 f9 ff ff       	call   802a33 <find_block>
  8030c2:	83 c4 10             	add    $0x10,%esp
  8030c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8030c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030cb:	8b 50 08             	mov    0x8(%eax),%edx
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	01 c2                	add    %eax,%edx
  8030d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d6:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8030d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030df:	2b 45 08             	sub    0x8(%ebp),%eax
  8030e2:	89 c2                	mov    %eax,%edx
  8030e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e7:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8030ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ed:	eb 05                	jmp    8030f4 <alloc_block_BF+0x20f>
	}
	return NULL;
  8030ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030f4:	c9                   	leave  
  8030f5:	c3                   	ret    

008030f6 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8030f6:	55                   	push   %ebp
  8030f7:	89 e5                	mov    %esp,%ebp
  8030f9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8030fc:	a1 28 50 80 00       	mov    0x805028,%eax
  803101:	85 c0                	test   %eax,%eax
  803103:	0f 85 de 01 00 00    	jne    8032e7 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803109:	a1 38 51 80 00       	mov    0x805138,%eax
  80310e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803111:	e9 9e 01 00 00       	jmp    8032b4 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803119:	8b 40 0c             	mov    0xc(%eax),%eax
  80311c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80311f:	0f 82 87 01 00 00    	jb     8032ac <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803128:	8b 40 0c             	mov    0xc(%eax),%eax
  80312b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80312e:	0f 85 95 00 00 00    	jne    8031c9 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803134:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803138:	75 17                	jne    803151 <alloc_block_NF+0x5b>
  80313a:	83 ec 04             	sub    $0x4,%esp
  80313d:	68 84 49 80 00       	push   $0x804984
  803142:	68 e0 00 00 00       	push   $0xe0
  803147:	68 db 48 80 00       	push   $0x8048db
  80314c:	e8 59 db ff ff       	call   800caa <_panic>
  803151:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803154:	8b 00                	mov    (%eax),%eax
  803156:	85 c0                	test   %eax,%eax
  803158:	74 10                	je     80316a <alloc_block_NF+0x74>
  80315a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315d:	8b 00                	mov    (%eax),%eax
  80315f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803162:	8b 52 04             	mov    0x4(%edx),%edx
  803165:	89 50 04             	mov    %edx,0x4(%eax)
  803168:	eb 0b                	jmp    803175 <alloc_block_NF+0x7f>
  80316a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316d:	8b 40 04             	mov    0x4(%eax),%eax
  803170:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803178:	8b 40 04             	mov    0x4(%eax),%eax
  80317b:	85 c0                	test   %eax,%eax
  80317d:	74 0f                	je     80318e <alloc_block_NF+0x98>
  80317f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803182:	8b 40 04             	mov    0x4(%eax),%eax
  803185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803188:	8b 12                	mov    (%edx),%edx
  80318a:	89 10                	mov    %edx,(%eax)
  80318c:	eb 0a                	jmp    803198 <alloc_block_NF+0xa2>
  80318e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803191:	8b 00                	mov    (%eax),%eax
  803193:	a3 38 51 80 00       	mov    %eax,0x805138
  803198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ab:	a1 44 51 80 00       	mov    0x805144,%eax
  8031b0:	48                   	dec    %eax
  8031b1:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	8b 40 08             	mov    0x8(%eax),%eax
  8031bc:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	e9 f8 04 00 00       	jmp    8036c1 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8031c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d2:	0f 86 d4 00 00 00    	jbe    8032ac <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8031d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8031dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8031e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e3:	8b 50 08             	mov    0x8(%eax),%edx
  8031e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e9:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8031ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f2:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8031f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031f9:	75 17                	jne    803212 <alloc_block_NF+0x11c>
  8031fb:	83 ec 04             	sub    $0x4,%esp
  8031fe:	68 84 49 80 00       	push   $0x804984
  803203:	68 e9 00 00 00       	push   $0xe9
  803208:	68 db 48 80 00       	push   $0x8048db
  80320d:	e8 98 da ff ff       	call   800caa <_panic>
  803212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803215:	8b 00                	mov    (%eax),%eax
  803217:	85 c0                	test   %eax,%eax
  803219:	74 10                	je     80322b <alloc_block_NF+0x135>
  80321b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321e:	8b 00                	mov    (%eax),%eax
  803220:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803223:	8b 52 04             	mov    0x4(%edx),%edx
  803226:	89 50 04             	mov    %edx,0x4(%eax)
  803229:	eb 0b                	jmp    803236 <alloc_block_NF+0x140>
  80322b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322e:	8b 40 04             	mov    0x4(%eax),%eax
  803231:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803239:	8b 40 04             	mov    0x4(%eax),%eax
  80323c:	85 c0                	test   %eax,%eax
  80323e:	74 0f                	je     80324f <alloc_block_NF+0x159>
  803240:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803243:	8b 40 04             	mov    0x4(%eax),%eax
  803246:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803249:	8b 12                	mov    (%edx),%edx
  80324b:	89 10                	mov    %edx,(%eax)
  80324d:	eb 0a                	jmp    803259 <alloc_block_NF+0x163>
  80324f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803252:	8b 00                	mov    (%eax),%eax
  803254:	a3 48 51 80 00       	mov    %eax,0x805148
  803259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803262:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803265:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326c:	a1 54 51 80 00       	mov    0x805154,%eax
  803271:	48                   	dec    %eax
  803272:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327a:	8b 40 08             	mov    0x8(%eax),%eax
  80327d:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  803282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803285:	8b 50 08             	mov    0x8(%eax),%edx
  803288:	8b 45 08             	mov    0x8(%ebp),%eax
  80328b:	01 c2                	add    %eax,%edx
  80328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803290:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803296:	8b 40 0c             	mov    0xc(%eax),%eax
  803299:	2b 45 08             	sub    0x8(%ebp),%eax
  80329c:	89 c2                	mov    %eax,%edx
  80329e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a1:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8032a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a7:	e9 15 04 00 00       	jmp    8036c1 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8032ac:	a1 40 51 80 00       	mov    0x805140,%eax
  8032b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b8:	74 07                	je     8032c1 <alloc_block_NF+0x1cb>
  8032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bd:	8b 00                	mov    (%eax),%eax
  8032bf:	eb 05                	jmp    8032c6 <alloc_block_NF+0x1d0>
  8032c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c6:	a3 40 51 80 00       	mov    %eax,0x805140
  8032cb:	a1 40 51 80 00       	mov    0x805140,%eax
  8032d0:	85 c0                	test   %eax,%eax
  8032d2:	0f 85 3e fe ff ff    	jne    803116 <alloc_block_NF+0x20>
  8032d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032dc:	0f 85 34 fe ff ff    	jne    803116 <alloc_block_NF+0x20>
  8032e2:	e9 d5 03 00 00       	jmp    8036bc <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8032e7:	a1 38 51 80 00       	mov    0x805138,%eax
  8032ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032ef:	e9 b1 01 00 00       	jmp    8034a5 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8032f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f7:	8b 50 08             	mov    0x8(%eax),%edx
  8032fa:	a1 28 50 80 00       	mov    0x805028,%eax
  8032ff:	39 c2                	cmp    %eax,%edx
  803301:	0f 82 96 01 00 00    	jb     80349d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330a:	8b 40 0c             	mov    0xc(%eax),%eax
  80330d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803310:	0f 82 87 01 00 00    	jb     80349d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803319:	8b 40 0c             	mov    0xc(%eax),%eax
  80331c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80331f:	0f 85 95 00 00 00    	jne    8033ba <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803325:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803329:	75 17                	jne    803342 <alloc_block_NF+0x24c>
  80332b:	83 ec 04             	sub    $0x4,%esp
  80332e:	68 84 49 80 00       	push   $0x804984
  803333:	68 fc 00 00 00       	push   $0xfc
  803338:	68 db 48 80 00       	push   $0x8048db
  80333d:	e8 68 d9 ff ff       	call   800caa <_panic>
  803342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803345:	8b 00                	mov    (%eax),%eax
  803347:	85 c0                	test   %eax,%eax
  803349:	74 10                	je     80335b <alloc_block_NF+0x265>
  80334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803353:	8b 52 04             	mov    0x4(%edx),%edx
  803356:	89 50 04             	mov    %edx,0x4(%eax)
  803359:	eb 0b                	jmp    803366 <alloc_block_NF+0x270>
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	8b 40 04             	mov    0x4(%eax),%eax
  803361:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803369:	8b 40 04             	mov    0x4(%eax),%eax
  80336c:	85 c0                	test   %eax,%eax
  80336e:	74 0f                	je     80337f <alloc_block_NF+0x289>
  803370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803373:	8b 40 04             	mov    0x4(%eax),%eax
  803376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803379:	8b 12                	mov    (%edx),%edx
  80337b:	89 10                	mov    %edx,(%eax)
  80337d:	eb 0a                	jmp    803389 <alloc_block_NF+0x293>
  80337f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803382:	8b 00                	mov    (%eax),%eax
  803384:	a3 38 51 80 00       	mov    %eax,0x805138
  803389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803395:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339c:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a1:	48                   	dec    %eax
  8033a2:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8033a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033aa:	8b 40 08             	mov    0x8(%eax),%eax
  8033ad:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8033b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b5:	e9 07 03 00 00       	jmp    8036c1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033c3:	0f 86 d4 00 00 00    	jbe    80349d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8033c9:	a1 48 51 80 00       	mov    0x805148,%eax
  8033ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8033d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d4:	8b 50 08             	mov    0x8(%eax),%edx
  8033d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033da:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8033dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8033e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033ea:	75 17                	jne    803403 <alloc_block_NF+0x30d>
  8033ec:	83 ec 04             	sub    $0x4,%esp
  8033ef:	68 84 49 80 00       	push   $0x804984
  8033f4:	68 04 01 00 00       	push   $0x104
  8033f9:	68 db 48 80 00       	push   $0x8048db
  8033fe:	e8 a7 d8 ff ff       	call   800caa <_panic>
  803403:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803406:	8b 00                	mov    (%eax),%eax
  803408:	85 c0                	test   %eax,%eax
  80340a:	74 10                	je     80341c <alloc_block_NF+0x326>
  80340c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340f:	8b 00                	mov    (%eax),%eax
  803411:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803414:	8b 52 04             	mov    0x4(%edx),%edx
  803417:	89 50 04             	mov    %edx,0x4(%eax)
  80341a:	eb 0b                	jmp    803427 <alloc_block_NF+0x331>
  80341c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341f:	8b 40 04             	mov    0x4(%eax),%eax
  803422:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803427:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342a:	8b 40 04             	mov    0x4(%eax),%eax
  80342d:	85 c0                	test   %eax,%eax
  80342f:	74 0f                	je     803440 <alloc_block_NF+0x34a>
  803431:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803434:	8b 40 04             	mov    0x4(%eax),%eax
  803437:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80343a:	8b 12                	mov    (%edx),%edx
  80343c:	89 10                	mov    %edx,(%eax)
  80343e:	eb 0a                	jmp    80344a <alloc_block_NF+0x354>
  803440:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803443:	8b 00                	mov    (%eax),%eax
  803445:	a3 48 51 80 00       	mov    %eax,0x805148
  80344a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803453:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803456:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345d:	a1 54 51 80 00       	mov    0x805154,%eax
  803462:	48                   	dec    %eax
  803463:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803468:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346b:	8b 40 08             	mov    0x8(%eax),%eax
  80346e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803476:	8b 50 08             	mov    0x8(%eax),%edx
  803479:	8b 45 08             	mov    0x8(%ebp),%eax
  80347c:	01 c2                	add    %eax,%edx
  80347e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803481:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803487:	8b 40 0c             	mov    0xc(%eax),%eax
  80348a:	2b 45 08             	sub    0x8(%ebp),%eax
  80348d:	89 c2                	mov    %eax,%edx
  80348f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803492:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803495:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803498:	e9 24 02 00 00       	jmp    8036c1 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80349d:	a1 40 51 80 00       	mov    0x805140,%eax
  8034a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a9:	74 07                	je     8034b2 <alloc_block_NF+0x3bc>
  8034ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ae:	8b 00                	mov    (%eax),%eax
  8034b0:	eb 05                	jmp    8034b7 <alloc_block_NF+0x3c1>
  8034b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b7:	a3 40 51 80 00       	mov    %eax,0x805140
  8034bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8034c1:	85 c0                	test   %eax,%eax
  8034c3:	0f 85 2b fe ff ff    	jne    8032f4 <alloc_block_NF+0x1fe>
  8034c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034cd:	0f 85 21 fe ff ff    	jne    8032f4 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8034d3:	a1 38 51 80 00       	mov    0x805138,%eax
  8034d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034db:	e9 ae 01 00 00       	jmp    80368e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8034e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e3:	8b 50 08             	mov    0x8(%eax),%edx
  8034e6:	a1 28 50 80 00       	mov    0x805028,%eax
  8034eb:	39 c2                	cmp    %eax,%edx
  8034ed:	0f 83 93 01 00 00    	jae    803686 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8034f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034fc:	0f 82 84 01 00 00    	jb     803686 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803505:	8b 40 0c             	mov    0xc(%eax),%eax
  803508:	3b 45 08             	cmp    0x8(%ebp),%eax
  80350b:	0f 85 95 00 00 00    	jne    8035a6 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803511:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803515:	75 17                	jne    80352e <alloc_block_NF+0x438>
  803517:	83 ec 04             	sub    $0x4,%esp
  80351a:	68 84 49 80 00       	push   $0x804984
  80351f:	68 14 01 00 00       	push   $0x114
  803524:	68 db 48 80 00       	push   $0x8048db
  803529:	e8 7c d7 ff ff       	call   800caa <_panic>
  80352e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803531:	8b 00                	mov    (%eax),%eax
  803533:	85 c0                	test   %eax,%eax
  803535:	74 10                	je     803547 <alloc_block_NF+0x451>
  803537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353a:	8b 00                	mov    (%eax),%eax
  80353c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80353f:	8b 52 04             	mov    0x4(%edx),%edx
  803542:	89 50 04             	mov    %edx,0x4(%eax)
  803545:	eb 0b                	jmp    803552 <alloc_block_NF+0x45c>
  803547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354a:	8b 40 04             	mov    0x4(%eax),%eax
  80354d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803555:	8b 40 04             	mov    0x4(%eax),%eax
  803558:	85 c0                	test   %eax,%eax
  80355a:	74 0f                	je     80356b <alloc_block_NF+0x475>
  80355c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355f:	8b 40 04             	mov    0x4(%eax),%eax
  803562:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803565:	8b 12                	mov    (%edx),%edx
  803567:	89 10                	mov    %edx,(%eax)
  803569:	eb 0a                	jmp    803575 <alloc_block_NF+0x47f>
  80356b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356e:	8b 00                	mov    (%eax),%eax
  803570:	a3 38 51 80 00       	mov    %eax,0x805138
  803575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803578:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80357e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803581:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803588:	a1 44 51 80 00       	mov    0x805144,%eax
  80358d:	48                   	dec    %eax
  80358e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803596:	8b 40 08             	mov    0x8(%eax),%eax
  803599:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80359e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a1:	e9 1b 01 00 00       	jmp    8036c1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8035a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035af:	0f 86 d1 00 00 00    	jbe    803686 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8035b5:	a1 48 51 80 00       	mov    0x805148,%eax
  8035ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8035bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c0:	8b 50 08             	mov    0x8(%eax),%edx
  8035c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c6:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8035c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8035cf:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8035d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035d6:	75 17                	jne    8035ef <alloc_block_NF+0x4f9>
  8035d8:	83 ec 04             	sub    $0x4,%esp
  8035db:	68 84 49 80 00       	push   $0x804984
  8035e0:	68 1c 01 00 00       	push   $0x11c
  8035e5:	68 db 48 80 00       	push   $0x8048db
  8035ea:	e8 bb d6 ff ff       	call   800caa <_panic>
  8035ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f2:	8b 00                	mov    (%eax),%eax
  8035f4:	85 c0                	test   %eax,%eax
  8035f6:	74 10                	je     803608 <alloc_block_NF+0x512>
  8035f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fb:	8b 00                	mov    (%eax),%eax
  8035fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803600:	8b 52 04             	mov    0x4(%edx),%edx
  803603:	89 50 04             	mov    %edx,0x4(%eax)
  803606:	eb 0b                	jmp    803613 <alloc_block_NF+0x51d>
  803608:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80360b:	8b 40 04             	mov    0x4(%eax),%eax
  80360e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803616:	8b 40 04             	mov    0x4(%eax),%eax
  803619:	85 c0                	test   %eax,%eax
  80361b:	74 0f                	je     80362c <alloc_block_NF+0x536>
  80361d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803620:	8b 40 04             	mov    0x4(%eax),%eax
  803623:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803626:	8b 12                	mov    (%edx),%edx
  803628:	89 10                	mov    %edx,(%eax)
  80362a:	eb 0a                	jmp    803636 <alloc_block_NF+0x540>
  80362c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80362f:	8b 00                	mov    (%eax),%eax
  803631:	a3 48 51 80 00       	mov    %eax,0x805148
  803636:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803639:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80363f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803642:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803649:	a1 54 51 80 00       	mov    0x805154,%eax
  80364e:	48                   	dec    %eax
  80364f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803654:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803657:	8b 40 08             	mov    0x8(%eax),%eax
  80365a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80365f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803662:	8b 50 08             	mov    0x8(%eax),%edx
  803665:	8b 45 08             	mov    0x8(%ebp),%eax
  803668:	01 c2                	add    %eax,%edx
  80366a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803673:	8b 40 0c             	mov    0xc(%eax),%eax
  803676:	2b 45 08             	sub    0x8(%ebp),%eax
  803679:	89 c2                	mov    %eax,%edx
  80367b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803684:	eb 3b                	jmp    8036c1 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803686:	a1 40 51 80 00       	mov    0x805140,%eax
  80368b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80368e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803692:	74 07                	je     80369b <alloc_block_NF+0x5a5>
  803694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803697:	8b 00                	mov    (%eax),%eax
  803699:	eb 05                	jmp    8036a0 <alloc_block_NF+0x5aa>
  80369b:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a0:	a3 40 51 80 00       	mov    %eax,0x805140
  8036a5:	a1 40 51 80 00       	mov    0x805140,%eax
  8036aa:	85 c0                	test   %eax,%eax
  8036ac:	0f 85 2e fe ff ff    	jne    8034e0 <alloc_block_NF+0x3ea>
  8036b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b6:	0f 85 24 fe ff ff    	jne    8034e0 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8036bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036c1:	c9                   	leave  
  8036c2:	c3                   	ret    

008036c3 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8036c3:	55                   	push   %ebp
  8036c4:	89 e5                	mov    %esp,%ebp
  8036c6:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8036c9:	a1 38 51 80 00       	mov    0x805138,%eax
  8036ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8036d1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8036d6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8036d9:	a1 38 51 80 00       	mov    0x805138,%eax
  8036de:	85 c0                	test   %eax,%eax
  8036e0:	74 14                	je     8036f6 <insert_sorted_with_merge_freeList+0x33>
  8036e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e5:	8b 50 08             	mov    0x8(%eax),%edx
  8036e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036eb:	8b 40 08             	mov    0x8(%eax),%eax
  8036ee:	39 c2                	cmp    %eax,%edx
  8036f0:	0f 87 9b 01 00 00    	ja     803891 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8036f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036fa:	75 17                	jne    803713 <insert_sorted_with_merge_freeList+0x50>
  8036fc:	83 ec 04             	sub    $0x4,%esp
  8036ff:	68 b8 48 80 00       	push   $0x8048b8
  803704:	68 38 01 00 00       	push   $0x138
  803709:	68 db 48 80 00       	push   $0x8048db
  80370e:	e8 97 d5 ff ff       	call   800caa <_panic>
  803713:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803719:	8b 45 08             	mov    0x8(%ebp),%eax
  80371c:	89 10                	mov    %edx,(%eax)
  80371e:	8b 45 08             	mov    0x8(%ebp),%eax
  803721:	8b 00                	mov    (%eax),%eax
  803723:	85 c0                	test   %eax,%eax
  803725:	74 0d                	je     803734 <insert_sorted_with_merge_freeList+0x71>
  803727:	a1 38 51 80 00       	mov    0x805138,%eax
  80372c:	8b 55 08             	mov    0x8(%ebp),%edx
  80372f:	89 50 04             	mov    %edx,0x4(%eax)
  803732:	eb 08                	jmp    80373c <insert_sorted_with_merge_freeList+0x79>
  803734:	8b 45 08             	mov    0x8(%ebp),%eax
  803737:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80373c:	8b 45 08             	mov    0x8(%ebp),%eax
  80373f:	a3 38 51 80 00       	mov    %eax,0x805138
  803744:	8b 45 08             	mov    0x8(%ebp),%eax
  803747:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80374e:	a1 44 51 80 00       	mov    0x805144,%eax
  803753:	40                   	inc    %eax
  803754:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803759:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80375d:	0f 84 a8 06 00 00    	je     803e0b <insert_sorted_with_merge_freeList+0x748>
  803763:	8b 45 08             	mov    0x8(%ebp),%eax
  803766:	8b 50 08             	mov    0x8(%eax),%edx
  803769:	8b 45 08             	mov    0x8(%ebp),%eax
  80376c:	8b 40 0c             	mov    0xc(%eax),%eax
  80376f:	01 c2                	add    %eax,%edx
  803771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803774:	8b 40 08             	mov    0x8(%eax),%eax
  803777:	39 c2                	cmp    %eax,%edx
  803779:	0f 85 8c 06 00 00    	jne    803e0b <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80377f:	8b 45 08             	mov    0x8(%ebp),%eax
  803782:	8b 50 0c             	mov    0xc(%eax),%edx
  803785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803788:	8b 40 0c             	mov    0xc(%eax),%eax
  80378b:	01 c2                	add    %eax,%edx
  80378d:	8b 45 08             	mov    0x8(%ebp),%eax
  803790:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803793:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803797:	75 17                	jne    8037b0 <insert_sorted_with_merge_freeList+0xed>
  803799:	83 ec 04             	sub    $0x4,%esp
  80379c:	68 84 49 80 00       	push   $0x804984
  8037a1:	68 3c 01 00 00       	push   $0x13c
  8037a6:	68 db 48 80 00       	push   $0x8048db
  8037ab:	e8 fa d4 ff ff       	call   800caa <_panic>
  8037b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b3:	8b 00                	mov    (%eax),%eax
  8037b5:	85 c0                	test   %eax,%eax
  8037b7:	74 10                	je     8037c9 <insert_sorted_with_merge_freeList+0x106>
  8037b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037bc:	8b 00                	mov    (%eax),%eax
  8037be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037c1:	8b 52 04             	mov    0x4(%edx),%edx
  8037c4:	89 50 04             	mov    %edx,0x4(%eax)
  8037c7:	eb 0b                	jmp    8037d4 <insert_sorted_with_merge_freeList+0x111>
  8037c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037cc:	8b 40 04             	mov    0x4(%eax),%eax
  8037cf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d7:	8b 40 04             	mov    0x4(%eax),%eax
  8037da:	85 c0                	test   %eax,%eax
  8037dc:	74 0f                	je     8037ed <insert_sorted_with_merge_freeList+0x12a>
  8037de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e1:	8b 40 04             	mov    0x4(%eax),%eax
  8037e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037e7:	8b 12                	mov    (%edx),%edx
  8037e9:	89 10                	mov    %edx,(%eax)
  8037eb:	eb 0a                	jmp    8037f7 <insert_sorted_with_merge_freeList+0x134>
  8037ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f0:	8b 00                	mov    (%eax),%eax
  8037f2:	a3 38 51 80 00       	mov    %eax,0x805138
  8037f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803803:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80380a:	a1 44 51 80 00       	mov    0x805144,%eax
  80380f:	48                   	dec    %eax
  803810:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803818:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80381f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803822:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803829:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80382d:	75 17                	jne    803846 <insert_sorted_with_merge_freeList+0x183>
  80382f:	83 ec 04             	sub    $0x4,%esp
  803832:	68 b8 48 80 00       	push   $0x8048b8
  803837:	68 3f 01 00 00       	push   $0x13f
  80383c:	68 db 48 80 00       	push   $0x8048db
  803841:	e8 64 d4 ff ff       	call   800caa <_panic>
  803846:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80384c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384f:	89 10                	mov    %edx,(%eax)
  803851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803854:	8b 00                	mov    (%eax),%eax
  803856:	85 c0                	test   %eax,%eax
  803858:	74 0d                	je     803867 <insert_sorted_with_merge_freeList+0x1a4>
  80385a:	a1 48 51 80 00       	mov    0x805148,%eax
  80385f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803862:	89 50 04             	mov    %edx,0x4(%eax)
  803865:	eb 08                	jmp    80386f <insert_sorted_with_merge_freeList+0x1ac>
  803867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80386f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803872:	a3 48 51 80 00       	mov    %eax,0x805148
  803877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80387a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803881:	a1 54 51 80 00       	mov    0x805154,%eax
  803886:	40                   	inc    %eax
  803887:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80388c:	e9 7a 05 00 00       	jmp    803e0b <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803891:	8b 45 08             	mov    0x8(%ebp),%eax
  803894:	8b 50 08             	mov    0x8(%eax),%edx
  803897:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80389a:	8b 40 08             	mov    0x8(%eax),%eax
  80389d:	39 c2                	cmp    %eax,%edx
  80389f:	0f 82 14 01 00 00    	jb     8039b9 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8038a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038a8:	8b 50 08             	mov    0x8(%eax),%edx
  8038ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8038b1:	01 c2                	add    %eax,%edx
  8038b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b6:	8b 40 08             	mov    0x8(%eax),%eax
  8038b9:	39 c2                	cmp    %eax,%edx
  8038bb:	0f 85 90 00 00 00    	jne    803951 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8038c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8038c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8038cd:	01 c2                	add    %eax,%edx
  8038cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038d2:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8038d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8038df:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8038e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038ed:	75 17                	jne    803906 <insert_sorted_with_merge_freeList+0x243>
  8038ef:	83 ec 04             	sub    $0x4,%esp
  8038f2:	68 b8 48 80 00       	push   $0x8048b8
  8038f7:	68 49 01 00 00       	push   $0x149
  8038fc:	68 db 48 80 00       	push   $0x8048db
  803901:	e8 a4 d3 ff ff       	call   800caa <_panic>
  803906:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80390c:	8b 45 08             	mov    0x8(%ebp),%eax
  80390f:	89 10                	mov    %edx,(%eax)
  803911:	8b 45 08             	mov    0x8(%ebp),%eax
  803914:	8b 00                	mov    (%eax),%eax
  803916:	85 c0                	test   %eax,%eax
  803918:	74 0d                	je     803927 <insert_sorted_with_merge_freeList+0x264>
  80391a:	a1 48 51 80 00       	mov    0x805148,%eax
  80391f:	8b 55 08             	mov    0x8(%ebp),%edx
  803922:	89 50 04             	mov    %edx,0x4(%eax)
  803925:	eb 08                	jmp    80392f <insert_sorted_with_merge_freeList+0x26c>
  803927:	8b 45 08             	mov    0x8(%ebp),%eax
  80392a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80392f:	8b 45 08             	mov    0x8(%ebp),%eax
  803932:	a3 48 51 80 00       	mov    %eax,0x805148
  803937:	8b 45 08             	mov    0x8(%ebp),%eax
  80393a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803941:	a1 54 51 80 00       	mov    0x805154,%eax
  803946:	40                   	inc    %eax
  803947:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80394c:	e9 bb 04 00 00       	jmp    803e0c <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803951:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803955:	75 17                	jne    80396e <insert_sorted_with_merge_freeList+0x2ab>
  803957:	83 ec 04             	sub    $0x4,%esp
  80395a:	68 2c 49 80 00       	push   $0x80492c
  80395f:	68 4c 01 00 00       	push   $0x14c
  803964:	68 db 48 80 00       	push   $0x8048db
  803969:	e8 3c d3 ff ff       	call   800caa <_panic>
  80396e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803974:	8b 45 08             	mov    0x8(%ebp),%eax
  803977:	89 50 04             	mov    %edx,0x4(%eax)
  80397a:	8b 45 08             	mov    0x8(%ebp),%eax
  80397d:	8b 40 04             	mov    0x4(%eax),%eax
  803980:	85 c0                	test   %eax,%eax
  803982:	74 0c                	je     803990 <insert_sorted_with_merge_freeList+0x2cd>
  803984:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803989:	8b 55 08             	mov    0x8(%ebp),%edx
  80398c:	89 10                	mov    %edx,(%eax)
  80398e:	eb 08                	jmp    803998 <insert_sorted_with_merge_freeList+0x2d5>
  803990:	8b 45 08             	mov    0x8(%ebp),%eax
  803993:	a3 38 51 80 00       	mov    %eax,0x805138
  803998:	8b 45 08             	mov    0x8(%ebp),%eax
  80399b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8039ae:	40                   	inc    %eax
  8039af:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039b4:	e9 53 04 00 00       	jmp    803e0c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8039b9:	a1 38 51 80 00       	mov    0x805138,%eax
  8039be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039c1:	e9 15 04 00 00       	jmp    803ddb <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8039c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c9:	8b 00                	mov    (%eax),%eax
  8039cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8039ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d1:	8b 50 08             	mov    0x8(%eax),%edx
  8039d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d7:	8b 40 08             	mov    0x8(%eax),%eax
  8039da:	39 c2                	cmp    %eax,%edx
  8039dc:	0f 86 f1 03 00 00    	jbe    803dd3 <insert_sorted_with_merge_freeList+0x710>
  8039e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e5:	8b 50 08             	mov    0x8(%eax),%edx
  8039e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039eb:	8b 40 08             	mov    0x8(%eax),%eax
  8039ee:	39 c2                	cmp    %eax,%edx
  8039f0:	0f 83 dd 03 00 00    	jae    803dd3 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8039f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f9:	8b 50 08             	mov    0x8(%eax),%edx
  8039fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803a02:	01 c2                	add    %eax,%edx
  803a04:	8b 45 08             	mov    0x8(%ebp),%eax
  803a07:	8b 40 08             	mov    0x8(%eax),%eax
  803a0a:	39 c2                	cmp    %eax,%edx
  803a0c:	0f 85 b9 01 00 00    	jne    803bcb <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803a12:	8b 45 08             	mov    0x8(%ebp),%eax
  803a15:	8b 50 08             	mov    0x8(%eax),%edx
  803a18:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1b:	8b 40 0c             	mov    0xc(%eax),%eax
  803a1e:	01 c2                	add    %eax,%edx
  803a20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a23:	8b 40 08             	mov    0x8(%eax),%eax
  803a26:	39 c2                	cmp    %eax,%edx
  803a28:	0f 85 0d 01 00 00    	jne    803b3b <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a31:	8b 50 0c             	mov    0xc(%eax),%edx
  803a34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a37:	8b 40 0c             	mov    0xc(%eax),%eax
  803a3a:	01 c2                	add    %eax,%edx
  803a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3f:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803a42:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a46:	75 17                	jne    803a5f <insert_sorted_with_merge_freeList+0x39c>
  803a48:	83 ec 04             	sub    $0x4,%esp
  803a4b:	68 84 49 80 00       	push   $0x804984
  803a50:	68 5c 01 00 00       	push   $0x15c
  803a55:	68 db 48 80 00       	push   $0x8048db
  803a5a:	e8 4b d2 ff ff       	call   800caa <_panic>
  803a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a62:	8b 00                	mov    (%eax),%eax
  803a64:	85 c0                	test   %eax,%eax
  803a66:	74 10                	je     803a78 <insert_sorted_with_merge_freeList+0x3b5>
  803a68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a6b:	8b 00                	mov    (%eax),%eax
  803a6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a70:	8b 52 04             	mov    0x4(%edx),%edx
  803a73:	89 50 04             	mov    %edx,0x4(%eax)
  803a76:	eb 0b                	jmp    803a83 <insert_sorted_with_merge_freeList+0x3c0>
  803a78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7b:	8b 40 04             	mov    0x4(%eax),%eax
  803a7e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a86:	8b 40 04             	mov    0x4(%eax),%eax
  803a89:	85 c0                	test   %eax,%eax
  803a8b:	74 0f                	je     803a9c <insert_sorted_with_merge_freeList+0x3d9>
  803a8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a90:	8b 40 04             	mov    0x4(%eax),%eax
  803a93:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a96:	8b 12                	mov    (%edx),%edx
  803a98:	89 10                	mov    %edx,(%eax)
  803a9a:	eb 0a                	jmp    803aa6 <insert_sorted_with_merge_freeList+0x3e3>
  803a9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a9f:	8b 00                	mov    (%eax),%eax
  803aa1:	a3 38 51 80 00       	mov    %eax,0x805138
  803aa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ab9:	a1 44 51 80 00       	mov    0x805144,%eax
  803abe:	48                   	dec    %eax
  803abf:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803ac4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803ace:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ad1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803ad8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803adc:	75 17                	jne    803af5 <insert_sorted_with_merge_freeList+0x432>
  803ade:	83 ec 04             	sub    $0x4,%esp
  803ae1:	68 b8 48 80 00       	push   $0x8048b8
  803ae6:	68 5f 01 00 00       	push   $0x15f
  803aeb:	68 db 48 80 00       	push   $0x8048db
  803af0:	e8 b5 d1 ff ff       	call   800caa <_panic>
  803af5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803afb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803afe:	89 10                	mov    %edx,(%eax)
  803b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b03:	8b 00                	mov    (%eax),%eax
  803b05:	85 c0                	test   %eax,%eax
  803b07:	74 0d                	je     803b16 <insert_sorted_with_merge_freeList+0x453>
  803b09:	a1 48 51 80 00       	mov    0x805148,%eax
  803b0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b11:	89 50 04             	mov    %edx,0x4(%eax)
  803b14:	eb 08                	jmp    803b1e <insert_sorted_with_merge_freeList+0x45b>
  803b16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b19:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b21:	a3 48 51 80 00       	mov    %eax,0x805148
  803b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b30:	a1 54 51 80 00       	mov    0x805154,%eax
  803b35:	40                   	inc    %eax
  803b36:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3e:	8b 50 0c             	mov    0xc(%eax),%edx
  803b41:	8b 45 08             	mov    0x8(%ebp),%eax
  803b44:	8b 40 0c             	mov    0xc(%eax),%eax
  803b47:	01 c2                	add    %eax,%edx
  803b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803b59:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803b63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b67:	75 17                	jne    803b80 <insert_sorted_with_merge_freeList+0x4bd>
  803b69:	83 ec 04             	sub    $0x4,%esp
  803b6c:	68 b8 48 80 00       	push   $0x8048b8
  803b71:	68 64 01 00 00       	push   $0x164
  803b76:	68 db 48 80 00       	push   $0x8048db
  803b7b:	e8 2a d1 ff ff       	call   800caa <_panic>
  803b80:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b86:	8b 45 08             	mov    0x8(%ebp),%eax
  803b89:	89 10                	mov    %edx,(%eax)
  803b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8e:	8b 00                	mov    (%eax),%eax
  803b90:	85 c0                	test   %eax,%eax
  803b92:	74 0d                	je     803ba1 <insert_sorted_with_merge_freeList+0x4de>
  803b94:	a1 48 51 80 00       	mov    0x805148,%eax
  803b99:	8b 55 08             	mov    0x8(%ebp),%edx
  803b9c:	89 50 04             	mov    %edx,0x4(%eax)
  803b9f:	eb 08                	jmp    803ba9 <insert_sorted_with_merge_freeList+0x4e6>
  803ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  803bac:	a3 48 51 80 00       	mov    %eax,0x805148
  803bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bbb:	a1 54 51 80 00       	mov    0x805154,%eax
  803bc0:	40                   	inc    %eax
  803bc1:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803bc6:	e9 41 02 00 00       	jmp    803e0c <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  803bce:	8b 50 08             	mov    0x8(%eax),%edx
  803bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd4:	8b 40 0c             	mov    0xc(%eax),%eax
  803bd7:	01 c2                	add    %eax,%edx
  803bd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bdc:	8b 40 08             	mov    0x8(%eax),%eax
  803bdf:	39 c2                	cmp    %eax,%edx
  803be1:	0f 85 7c 01 00 00    	jne    803d63 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803be7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803beb:	74 06                	je     803bf3 <insert_sorted_with_merge_freeList+0x530>
  803bed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bf1:	75 17                	jne    803c0a <insert_sorted_with_merge_freeList+0x547>
  803bf3:	83 ec 04             	sub    $0x4,%esp
  803bf6:	68 f4 48 80 00       	push   $0x8048f4
  803bfb:	68 69 01 00 00       	push   $0x169
  803c00:	68 db 48 80 00       	push   $0x8048db
  803c05:	e8 a0 d0 ff ff       	call   800caa <_panic>
  803c0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c0d:	8b 50 04             	mov    0x4(%eax),%edx
  803c10:	8b 45 08             	mov    0x8(%ebp),%eax
  803c13:	89 50 04             	mov    %edx,0x4(%eax)
  803c16:	8b 45 08             	mov    0x8(%ebp),%eax
  803c19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c1c:	89 10                	mov    %edx,(%eax)
  803c1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c21:	8b 40 04             	mov    0x4(%eax),%eax
  803c24:	85 c0                	test   %eax,%eax
  803c26:	74 0d                	je     803c35 <insert_sorted_with_merge_freeList+0x572>
  803c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c2b:	8b 40 04             	mov    0x4(%eax),%eax
  803c2e:	8b 55 08             	mov    0x8(%ebp),%edx
  803c31:	89 10                	mov    %edx,(%eax)
  803c33:	eb 08                	jmp    803c3d <insert_sorted_with_merge_freeList+0x57a>
  803c35:	8b 45 08             	mov    0x8(%ebp),%eax
  803c38:	a3 38 51 80 00       	mov    %eax,0x805138
  803c3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c40:	8b 55 08             	mov    0x8(%ebp),%edx
  803c43:	89 50 04             	mov    %edx,0x4(%eax)
  803c46:	a1 44 51 80 00       	mov    0x805144,%eax
  803c4b:	40                   	inc    %eax
  803c4c:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803c51:	8b 45 08             	mov    0x8(%ebp),%eax
  803c54:	8b 50 0c             	mov    0xc(%eax),%edx
  803c57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c5a:	8b 40 0c             	mov    0xc(%eax),%eax
  803c5d:	01 c2                	add    %eax,%edx
  803c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c62:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803c65:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c69:	75 17                	jne    803c82 <insert_sorted_with_merge_freeList+0x5bf>
  803c6b:	83 ec 04             	sub    $0x4,%esp
  803c6e:	68 84 49 80 00       	push   $0x804984
  803c73:	68 6b 01 00 00       	push   $0x16b
  803c78:	68 db 48 80 00       	push   $0x8048db
  803c7d:	e8 28 d0 ff ff       	call   800caa <_panic>
  803c82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c85:	8b 00                	mov    (%eax),%eax
  803c87:	85 c0                	test   %eax,%eax
  803c89:	74 10                	je     803c9b <insert_sorted_with_merge_freeList+0x5d8>
  803c8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c8e:	8b 00                	mov    (%eax),%eax
  803c90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c93:	8b 52 04             	mov    0x4(%edx),%edx
  803c96:	89 50 04             	mov    %edx,0x4(%eax)
  803c99:	eb 0b                	jmp    803ca6 <insert_sorted_with_merge_freeList+0x5e3>
  803c9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c9e:	8b 40 04             	mov    0x4(%eax),%eax
  803ca1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ca6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca9:	8b 40 04             	mov    0x4(%eax),%eax
  803cac:	85 c0                	test   %eax,%eax
  803cae:	74 0f                	je     803cbf <insert_sorted_with_merge_freeList+0x5fc>
  803cb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cb3:	8b 40 04             	mov    0x4(%eax),%eax
  803cb6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cb9:	8b 12                	mov    (%edx),%edx
  803cbb:	89 10                	mov    %edx,(%eax)
  803cbd:	eb 0a                	jmp    803cc9 <insert_sorted_with_merge_freeList+0x606>
  803cbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cc2:	8b 00                	mov    (%eax),%eax
  803cc4:	a3 38 51 80 00       	mov    %eax,0x805138
  803cc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ccc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cdc:	a1 44 51 80 00       	mov    0x805144,%eax
  803ce1:	48                   	dec    %eax
  803ce2:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803ce7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803cf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cf4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803cfb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803cff:	75 17                	jne    803d18 <insert_sorted_with_merge_freeList+0x655>
  803d01:	83 ec 04             	sub    $0x4,%esp
  803d04:	68 b8 48 80 00       	push   $0x8048b8
  803d09:	68 6e 01 00 00       	push   $0x16e
  803d0e:	68 db 48 80 00       	push   $0x8048db
  803d13:	e8 92 cf ff ff       	call   800caa <_panic>
  803d18:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803d1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d21:	89 10                	mov    %edx,(%eax)
  803d23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d26:	8b 00                	mov    (%eax),%eax
  803d28:	85 c0                	test   %eax,%eax
  803d2a:	74 0d                	je     803d39 <insert_sorted_with_merge_freeList+0x676>
  803d2c:	a1 48 51 80 00       	mov    0x805148,%eax
  803d31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d34:	89 50 04             	mov    %edx,0x4(%eax)
  803d37:	eb 08                	jmp    803d41 <insert_sorted_with_merge_freeList+0x67e>
  803d39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d3c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d44:	a3 48 51 80 00       	mov    %eax,0x805148
  803d49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d53:	a1 54 51 80 00       	mov    0x805154,%eax
  803d58:	40                   	inc    %eax
  803d59:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803d5e:	e9 a9 00 00 00       	jmp    803e0c <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803d63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d67:	74 06                	je     803d6f <insert_sorted_with_merge_freeList+0x6ac>
  803d69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d6d:	75 17                	jne    803d86 <insert_sorted_with_merge_freeList+0x6c3>
  803d6f:	83 ec 04             	sub    $0x4,%esp
  803d72:	68 50 49 80 00       	push   $0x804950
  803d77:	68 73 01 00 00       	push   $0x173
  803d7c:	68 db 48 80 00       	push   $0x8048db
  803d81:	e8 24 cf ff ff       	call   800caa <_panic>
  803d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d89:	8b 10                	mov    (%eax),%edx
  803d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8e:	89 10                	mov    %edx,(%eax)
  803d90:	8b 45 08             	mov    0x8(%ebp),%eax
  803d93:	8b 00                	mov    (%eax),%eax
  803d95:	85 c0                	test   %eax,%eax
  803d97:	74 0b                	je     803da4 <insert_sorted_with_merge_freeList+0x6e1>
  803d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d9c:	8b 00                	mov    (%eax),%eax
  803d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  803da1:	89 50 04             	mov    %edx,0x4(%eax)
  803da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da7:	8b 55 08             	mov    0x8(%ebp),%edx
  803daa:	89 10                	mov    %edx,(%eax)
  803dac:	8b 45 08             	mov    0x8(%ebp),%eax
  803daf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803db2:	89 50 04             	mov    %edx,0x4(%eax)
  803db5:	8b 45 08             	mov    0x8(%ebp),%eax
  803db8:	8b 00                	mov    (%eax),%eax
  803dba:	85 c0                	test   %eax,%eax
  803dbc:	75 08                	jne    803dc6 <insert_sorted_with_merge_freeList+0x703>
  803dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803dc6:	a1 44 51 80 00       	mov    0x805144,%eax
  803dcb:	40                   	inc    %eax
  803dcc:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803dd1:	eb 39                	jmp    803e0c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803dd3:	a1 40 51 80 00       	mov    0x805140,%eax
  803dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ddb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ddf:	74 07                	je     803de8 <insert_sorted_with_merge_freeList+0x725>
  803de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de4:	8b 00                	mov    (%eax),%eax
  803de6:	eb 05                	jmp    803ded <insert_sorted_with_merge_freeList+0x72a>
  803de8:	b8 00 00 00 00       	mov    $0x0,%eax
  803ded:	a3 40 51 80 00       	mov    %eax,0x805140
  803df2:	a1 40 51 80 00       	mov    0x805140,%eax
  803df7:	85 c0                	test   %eax,%eax
  803df9:	0f 85 c7 fb ff ff    	jne    8039c6 <insert_sorted_with_merge_freeList+0x303>
  803dff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e03:	0f 85 bd fb ff ff    	jne    8039c6 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803e09:	eb 01                	jmp    803e0c <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803e0b:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803e0c:	90                   	nop
  803e0d:	c9                   	leave  
  803e0e:	c3                   	ret    
  803e0f:	90                   	nop

00803e10 <__udivdi3>:
  803e10:	55                   	push   %ebp
  803e11:	57                   	push   %edi
  803e12:	56                   	push   %esi
  803e13:	53                   	push   %ebx
  803e14:	83 ec 1c             	sub    $0x1c,%esp
  803e17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e27:	89 ca                	mov    %ecx,%edx
  803e29:	89 f8                	mov    %edi,%eax
  803e2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e2f:	85 f6                	test   %esi,%esi
  803e31:	75 2d                	jne    803e60 <__udivdi3+0x50>
  803e33:	39 cf                	cmp    %ecx,%edi
  803e35:	77 65                	ja     803e9c <__udivdi3+0x8c>
  803e37:	89 fd                	mov    %edi,%ebp
  803e39:	85 ff                	test   %edi,%edi
  803e3b:	75 0b                	jne    803e48 <__udivdi3+0x38>
  803e3d:	b8 01 00 00 00       	mov    $0x1,%eax
  803e42:	31 d2                	xor    %edx,%edx
  803e44:	f7 f7                	div    %edi
  803e46:	89 c5                	mov    %eax,%ebp
  803e48:	31 d2                	xor    %edx,%edx
  803e4a:	89 c8                	mov    %ecx,%eax
  803e4c:	f7 f5                	div    %ebp
  803e4e:	89 c1                	mov    %eax,%ecx
  803e50:	89 d8                	mov    %ebx,%eax
  803e52:	f7 f5                	div    %ebp
  803e54:	89 cf                	mov    %ecx,%edi
  803e56:	89 fa                	mov    %edi,%edx
  803e58:	83 c4 1c             	add    $0x1c,%esp
  803e5b:	5b                   	pop    %ebx
  803e5c:	5e                   	pop    %esi
  803e5d:	5f                   	pop    %edi
  803e5e:	5d                   	pop    %ebp
  803e5f:	c3                   	ret    
  803e60:	39 ce                	cmp    %ecx,%esi
  803e62:	77 28                	ja     803e8c <__udivdi3+0x7c>
  803e64:	0f bd fe             	bsr    %esi,%edi
  803e67:	83 f7 1f             	xor    $0x1f,%edi
  803e6a:	75 40                	jne    803eac <__udivdi3+0x9c>
  803e6c:	39 ce                	cmp    %ecx,%esi
  803e6e:	72 0a                	jb     803e7a <__udivdi3+0x6a>
  803e70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e74:	0f 87 9e 00 00 00    	ja     803f18 <__udivdi3+0x108>
  803e7a:	b8 01 00 00 00       	mov    $0x1,%eax
  803e7f:	89 fa                	mov    %edi,%edx
  803e81:	83 c4 1c             	add    $0x1c,%esp
  803e84:	5b                   	pop    %ebx
  803e85:	5e                   	pop    %esi
  803e86:	5f                   	pop    %edi
  803e87:	5d                   	pop    %ebp
  803e88:	c3                   	ret    
  803e89:	8d 76 00             	lea    0x0(%esi),%esi
  803e8c:	31 ff                	xor    %edi,%edi
  803e8e:	31 c0                	xor    %eax,%eax
  803e90:	89 fa                	mov    %edi,%edx
  803e92:	83 c4 1c             	add    $0x1c,%esp
  803e95:	5b                   	pop    %ebx
  803e96:	5e                   	pop    %esi
  803e97:	5f                   	pop    %edi
  803e98:	5d                   	pop    %ebp
  803e99:	c3                   	ret    
  803e9a:	66 90                	xchg   %ax,%ax
  803e9c:	89 d8                	mov    %ebx,%eax
  803e9e:	f7 f7                	div    %edi
  803ea0:	31 ff                	xor    %edi,%edi
  803ea2:	89 fa                	mov    %edi,%edx
  803ea4:	83 c4 1c             	add    $0x1c,%esp
  803ea7:	5b                   	pop    %ebx
  803ea8:	5e                   	pop    %esi
  803ea9:	5f                   	pop    %edi
  803eaa:	5d                   	pop    %ebp
  803eab:	c3                   	ret    
  803eac:	bd 20 00 00 00       	mov    $0x20,%ebp
  803eb1:	89 eb                	mov    %ebp,%ebx
  803eb3:	29 fb                	sub    %edi,%ebx
  803eb5:	89 f9                	mov    %edi,%ecx
  803eb7:	d3 e6                	shl    %cl,%esi
  803eb9:	89 c5                	mov    %eax,%ebp
  803ebb:	88 d9                	mov    %bl,%cl
  803ebd:	d3 ed                	shr    %cl,%ebp
  803ebf:	89 e9                	mov    %ebp,%ecx
  803ec1:	09 f1                	or     %esi,%ecx
  803ec3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ec7:	89 f9                	mov    %edi,%ecx
  803ec9:	d3 e0                	shl    %cl,%eax
  803ecb:	89 c5                	mov    %eax,%ebp
  803ecd:	89 d6                	mov    %edx,%esi
  803ecf:	88 d9                	mov    %bl,%cl
  803ed1:	d3 ee                	shr    %cl,%esi
  803ed3:	89 f9                	mov    %edi,%ecx
  803ed5:	d3 e2                	shl    %cl,%edx
  803ed7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803edb:	88 d9                	mov    %bl,%cl
  803edd:	d3 e8                	shr    %cl,%eax
  803edf:	09 c2                	or     %eax,%edx
  803ee1:	89 d0                	mov    %edx,%eax
  803ee3:	89 f2                	mov    %esi,%edx
  803ee5:	f7 74 24 0c          	divl   0xc(%esp)
  803ee9:	89 d6                	mov    %edx,%esi
  803eeb:	89 c3                	mov    %eax,%ebx
  803eed:	f7 e5                	mul    %ebp
  803eef:	39 d6                	cmp    %edx,%esi
  803ef1:	72 19                	jb     803f0c <__udivdi3+0xfc>
  803ef3:	74 0b                	je     803f00 <__udivdi3+0xf0>
  803ef5:	89 d8                	mov    %ebx,%eax
  803ef7:	31 ff                	xor    %edi,%edi
  803ef9:	e9 58 ff ff ff       	jmp    803e56 <__udivdi3+0x46>
  803efe:	66 90                	xchg   %ax,%ax
  803f00:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f04:	89 f9                	mov    %edi,%ecx
  803f06:	d3 e2                	shl    %cl,%edx
  803f08:	39 c2                	cmp    %eax,%edx
  803f0a:	73 e9                	jae    803ef5 <__udivdi3+0xe5>
  803f0c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f0f:	31 ff                	xor    %edi,%edi
  803f11:	e9 40 ff ff ff       	jmp    803e56 <__udivdi3+0x46>
  803f16:	66 90                	xchg   %ax,%ax
  803f18:	31 c0                	xor    %eax,%eax
  803f1a:	e9 37 ff ff ff       	jmp    803e56 <__udivdi3+0x46>
  803f1f:	90                   	nop

00803f20 <__umoddi3>:
  803f20:	55                   	push   %ebp
  803f21:	57                   	push   %edi
  803f22:	56                   	push   %esi
  803f23:	53                   	push   %ebx
  803f24:	83 ec 1c             	sub    $0x1c,%esp
  803f27:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f2b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f33:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f3b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f3f:	89 f3                	mov    %esi,%ebx
  803f41:	89 fa                	mov    %edi,%edx
  803f43:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f47:	89 34 24             	mov    %esi,(%esp)
  803f4a:	85 c0                	test   %eax,%eax
  803f4c:	75 1a                	jne    803f68 <__umoddi3+0x48>
  803f4e:	39 f7                	cmp    %esi,%edi
  803f50:	0f 86 a2 00 00 00    	jbe    803ff8 <__umoddi3+0xd8>
  803f56:	89 c8                	mov    %ecx,%eax
  803f58:	89 f2                	mov    %esi,%edx
  803f5a:	f7 f7                	div    %edi
  803f5c:	89 d0                	mov    %edx,%eax
  803f5e:	31 d2                	xor    %edx,%edx
  803f60:	83 c4 1c             	add    $0x1c,%esp
  803f63:	5b                   	pop    %ebx
  803f64:	5e                   	pop    %esi
  803f65:	5f                   	pop    %edi
  803f66:	5d                   	pop    %ebp
  803f67:	c3                   	ret    
  803f68:	39 f0                	cmp    %esi,%eax
  803f6a:	0f 87 ac 00 00 00    	ja     80401c <__umoddi3+0xfc>
  803f70:	0f bd e8             	bsr    %eax,%ebp
  803f73:	83 f5 1f             	xor    $0x1f,%ebp
  803f76:	0f 84 ac 00 00 00    	je     804028 <__umoddi3+0x108>
  803f7c:	bf 20 00 00 00       	mov    $0x20,%edi
  803f81:	29 ef                	sub    %ebp,%edi
  803f83:	89 fe                	mov    %edi,%esi
  803f85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f89:	89 e9                	mov    %ebp,%ecx
  803f8b:	d3 e0                	shl    %cl,%eax
  803f8d:	89 d7                	mov    %edx,%edi
  803f8f:	89 f1                	mov    %esi,%ecx
  803f91:	d3 ef                	shr    %cl,%edi
  803f93:	09 c7                	or     %eax,%edi
  803f95:	89 e9                	mov    %ebp,%ecx
  803f97:	d3 e2                	shl    %cl,%edx
  803f99:	89 14 24             	mov    %edx,(%esp)
  803f9c:	89 d8                	mov    %ebx,%eax
  803f9e:	d3 e0                	shl    %cl,%eax
  803fa0:	89 c2                	mov    %eax,%edx
  803fa2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fa6:	d3 e0                	shl    %cl,%eax
  803fa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fac:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fb0:	89 f1                	mov    %esi,%ecx
  803fb2:	d3 e8                	shr    %cl,%eax
  803fb4:	09 d0                	or     %edx,%eax
  803fb6:	d3 eb                	shr    %cl,%ebx
  803fb8:	89 da                	mov    %ebx,%edx
  803fba:	f7 f7                	div    %edi
  803fbc:	89 d3                	mov    %edx,%ebx
  803fbe:	f7 24 24             	mull   (%esp)
  803fc1:	89 c6                	mov    %eax,%esi
  803fc3:	89 d1                	mov    %edx,%ecx
  803fc5:	39 d3                	cmp    %edx,%ebx
  803fc7:	0f 82 87 00 00 00    	jb     804054 <__umoddi3+0x134>
  803fcd:	0f 84 91 00 00 00    	je     804064 <__umoddi3+0x144>
  803fd3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803fd7:	29 f2                	sub    %esi,%edx
  803fd9:	19 cb                	sbb    %ecx,%ebx
  803fdb:	89 d8                	mov    %ebx,%eax
  803fdd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803fe1:	d3 e0                	shl    %cl,%eax
  803fe3:	89 e9                	mov    %ebp,%ecx
  803fe5:	d3 ea                	shr    %cl,%edx
  803fe7:	09 d0                	or     %edx,%eax
  803fe9:	89 e9                	mov    %ebp,%ecx
  803feb:	d3 eb                	shr    %cl,%ebx
  803fed:	89 da                	mov    %ebx,%edx
  803fef:	83 c4 1c             	add    $0x1c,%esp
  803ff2:	5b                   	pop    %ebx
  803ff3:	5e                   	pop    %esi
  803ff4:	5f                   	pop    %edi
  803ff5:	5d                   	pop    %ebp
  803ff6:	c3                   	ret    
  803ff7:	90                   	nop
  803ff8:	89 fd                	mov    %edi,%ebp
  803ffa:	85 ff                	test   %edi,%edi
  803ffc:	75 0b                	jne    804009 <__umoddi3+0xe9>
  803ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  804003:	31 d2                	xor    %edx,%edx
  804005:	f7 f7                	div    %edi
  804007:	89 c5                	mov    %eax,%ebp
  804009:	89 f0                	mov    %esi,%eax
  80400b:	31 d2                	xor    %edx,%edx
  80400d:	f7 f5                	div    %ebp
  80400f:	89 c8                	mov    %ecx,%eax
  804011:	f7 f5                	div    %ebp
  804013:	89 d0                	mov    %edx,%eax
  804015:	e9 44 ff ff ff       	jmp    803f5e <__umoddi3+0x3e>
  80401a:	66 90                	xchg   %ax,%ax
  80401c:	89 c8                	mov    %ecx,%eax
  80401e:	89 f2                	mov    %esi,%edx
  804020:	83 c4 1c             	add    $0x1c,%esp
  804023:	5b                   	pop    %ebx
  804024:	5e                   	pop    %esi
  804025:	5f                   	pop    %edi
  804026:	5d                   	pop    %ebp
  804027:	c3                   	ret    
  804028:	3b 04 24             	cmp    (%esp),%eax
  80402b:	72 06                	jb     804033 <__umoddi3+0x113>
  80402d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804031:	77 0f                	ja     804042 <__umoddi3+0x122>
  804033:	89 f2                	mov    %esi,%edx
  804035:	29 f9                	sub    %edi,%ecx
  804037:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80403b:	89 14 24             	mov    %edx,(%esp)
  80403e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804042:	8b 44 24 04          	mov    0x4(%esp),%eax
  804046:	8b 14 24             	mov    (%esp),%edx
  804049:	83 c4 1c             	add    $0x1c,%esp
  80404c:	5b                   	pop    %ebx
  80404d:	5e                   	pop    %esi
  80404e:	5f                   	pop    %edi
  80404f:	5d                   	pop    %ebp
  804050:	c3                   	ret    
  804051:	8d 76 00             	lea    0x0(%esi),%esi
  804054:	2b 04 24             	sub    (%esp),%eax
  804057:	19 fa                	sbb    %edi,%edx
  804059:	89 d1                	mov    %edx,%ecx
  80405b:	89 c6                	mov    %eax,%esi
  80405d:	e9 71 ff ff ff       	jmp    803fd3 <__umoddi3+0xb3>
  804062:	66 90                	xchg   %ax,%ax
  804064:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804068:	72 ea                	jb     804054 <__umoddi3+0x134>
  80406a:	89 d9                	mov    %ebx,%ecx
  80406c:	e9 62 ff ff ff       	jmp    803fd3 <__umoddi3+0xb3>
