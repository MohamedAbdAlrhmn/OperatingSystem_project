
obj/user/tst_free_2:     file format elf32-i386


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
  800031:	e8 43 09 00 00       	call   800979 <libmain>
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
  80003c:	81 ec d4 00 00 00    	sub    $0xd4,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 50 80 00       	mov    0x805020,%eax
  800054:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
{

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 50 80 00       	mov    0x805020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 40 3f 80 00       	push   $0x803f40
  800095:	6a 14                	push   $0x14
  800097:	68 5c 3f 80 00       	push   $0x803f5c
  80009c:	e8 14 0a 00 00       	call   800ab5 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 46 1c 00 00       	call   801cf1 <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	6a 03                	push   $0x3
  8000b3:	e8 ee 23 00 00       	call   8024a6 <sys_bypassPageFault>
  8000b8:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000bb:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  8000c9:	e8 40 20 00 00       	call   80210e <sys_calculate_free_frames>
  8000ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//ALLOCATE ALL
	void* ptr_allocations[20] = {0};
  8000d1:	8d 55 80             	lea    -0x80(%ebp),%edx
  8000d4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000de:	89 d7                	mov    %edx,%edi
  8000e0:	f3 ab                	rep stos %eax,%es:(%edi)
	int lastIndices[20] = {0};
  8000e2:	8d 95 30 ff ff ff    	lea    -0xd0(%ebp),%edx
  8000e8:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f2:	89 d7                	mov    %edx,%edi
  8000f4:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000f6:	e8 13 20 00 00       	call   80210e <sys_calculate_free_frames>
  8000fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 ab 20 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  800103:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800109:	01 c0                	add    %eax,%eax
  80010b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	e8 da 1b 00 00       	call   801cf1 <malloc>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800120:	85 c0                	test   %eax,%eax
  800122:	78 14                	js     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 70 3f 80 00       	push   $0x803f70
  80012c:	6a 2d                	push   $0x2d
  80012e:	68 5c 3f 80 00       	push   $0x803f5c
  800133:	e8 7d 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 71 20 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 d8 3f 80 00       	push   $0x803fd8
  80014a:	6a 2e                	push   $0x2e
  80014c:	68 5c 3f 80 00       	push   $0x803f5c
  800151:	e8 5f 09 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  800156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80015e:	48                   	dec    %eax
  80015f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800165:	e8 a4 1f 00 00       	call   80210e <sys_calculate_free_frames>
  80016a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80016d:	e8 3c 20 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  800172:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800178:	01 c0                	add    %eax,%eax
  80017a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	50                   	push   %eax
  800181:	e8 6b 1b 00 00       	call   801cf1 <malloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80018c:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80018f:	89 c2                	mov    %eax,%edx
  800191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800194:	01 c0                	add    %eax,%eax
  800196:	05 00 00 00 80       	add    $0x80000000,%eax
  80019b:	39 c2                	cmp    %eax,%edx
  80019d:	73 14                	jae    8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 70 3f 80 00       	push   $0x803f70
  8001a7:	6a 35                	push   $0x35
  8001a9:	68 5c 3f 80 00       	push   $0x803f5c
  8001ae:	e8 02 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001b3:	e8 f6 1f 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  8001b8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001bb:	74 14                	je     8001d1 <_main+0x199>
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	68 d8 3f 80 00       	push   $0x803fd8
  8001c5:	6a 36                	push   $0x36
  8001c7:	68 5c 3f 80 00       	push   $0x803f5c
  8001cc:	e8 e4 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001d9:	48                   	dec    %eax
  8001da:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001e0:	e8 29 1f 00 00       	call   80210e <sys_calculate_free_frames>
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001e8:	e8 c1 1f 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  8001ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f3:	01 c0                	add    %eax,%eax
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	e8 f3 1a 00 00       	call   801cf1 <malloc>
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800204:	8b 45 88             	mov    -0x78(%ebp),%eax
  800207:	89 c2                	mov    %eax,%edx
  800209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020c:	c1 e0 02             	shl    $0x2,%eax
  80020f:	05 00 00 00 80       	add    $0x80000000,%eax
  800214:	39 c2                	cmp    %eax,%edx
  800216:	73 14                	jae    80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 70 3f 80 00       	push   $0x803f70
  800220:	6a 3d                	push   $0x3d
  800222:	68 5c 3f 80 00       	push   $0x803f5c
  800227:	e8 89 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80022c:	e8 7d 1f 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  800231:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 d8 3f 80 00       	push   $0x803fd8
  80023e:	6a 3e                	push   $0x3e
  800240:	68 5c 3f 80 00       	push   $0x803f5c
  800245:	e8 6b 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  80024a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024d:	01 c0                	add    %eax,%eax
  80024f:	48                   	dec    %eax
  800250:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800256:	e8 b3 1e 00 00       	call   80210e <sys_calculate_free_frames>
  80025b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025e:	e8 4b 1f 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  800263:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800266:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800269:	01 c0                	add    %eax,%eax
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	50                   	push   %eax
  80026f:	e8 7d 1a 00 00       	call   801cf1 <malloc>
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80027a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800282:	c1 e0 02             	shl    $0x2,%eax
  800285:	89 c1                	mov    %eax,%ecx
  800287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028a:	c1 e0 02             	shl    $0x2,%eax
  80028d:	01 c8                	add    %ecx,%eax
  80028f:	05 00 00 00 80       	add    $0x80000000,%eax
  800294:	39 c2                	cmp    %eax,%edx
  800296:	73 14                	jae    8002ac <_main+0x274>
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	68 70 3f 80 00       	push   $0x803f70
  8002a0:	6a 45                	push   $0x45
  8002a2:	68 5c 3f 80 00       	push   $0x803f5c
  8002a7:	e8 09 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002ac:	e8 fd 1e 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  8002b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002b4:	74 14                	je     8002ca <_main+0x292>
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	68 d8 3f 80 00       	push   $0x803fd8
  8002be:	6a 46                	push   $0x46
  8002c0:	68 5c 3f 80 00       	push   $0x803f5c
  8002c5:	e8 eb 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  8002ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002cd:	01 c0                	add    %eax,%eax
  8002cf:	48                   	dec    %eax
  8002d0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002d6:	e8 33 1e 00 00       	call   80210e <sys_calculate_free_frames>
  8002db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002de:	e8 cb 1e 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  8002e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  8002e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002e9:	89 d0                	mov    %edx,%eax
  8002eb:	01 c0                	add    %eax,%eax
  8002ed:	01 d0                	add    %edx,%eax
  8002ef:	01 c0                	add    %eax,%eax
  8002f1:	01 d0                	add    %edx,%eax
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	50                   	push   %eax
  8002f7:	e8 f5 19 00 00       	call   801cf1 <malloc>
  8002fc:	83 c4 10             	add    $0x10,%esp
  8002ff:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800302:	8b 45 90             	mov    -0x70(%ebp),%eax
  800305:	89 c2                	mov    %eax,%edx
  800307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80030a:	c1 e0 02             	shl    $0x2,%eax
  80030d:	89 c1                	mov    %eax,%ecx
  80030f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800312:	c1 e0 03             	shl    $0x3,%eax
  800315:	01 c8                	add    %ecx,%eax
  800317:	05 00 00 00 80       	add    $0x80000000,%eax
  80031c:	39 c2                	cmp    %eax,%edx
  80031e:	73 14                	jae    800334 <_main+0x2fc>
  800320:	83 ec 04             	sub    $0x4,%esp
  800323:	68 70 3f 80 00       	push   $0x803f70
  800328:	6a 4d                	push   $0x4d
  80032a:	68 5c 3f 80 00       	push   $0x803f5c
  80032f:	e8 81 07 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800334:	e8 75 1e 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  800339:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 d8 3f 80 00       	push   $0x803fd8
  800346:	6a 4e                	push   $0x4e
  800348:	68 5c 3f 80 00       	push   $0x803f5c
  80034d:	e8 63 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
  800352:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800355:	89 d0                	mov    %edx,%eax
  800357:	01 c0                	add    %eax,%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	01 c0                	add    %eax,%eax
  80035d:	01 d0                	add    %edx,%eax
  80035f:	48                   	dec    %eax
  800360:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800366:	e8 a3 1d 00 00       	call   80210e <sys_calculate_free_frames>
  80036b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80036e:	e8 3b 1e 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  800373:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800376:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800379:	89 c2                	mov    %eax,%edx
  80037b:	01 d2                	add    %edx,%edx
  80037d:	01 d0                	add    %edx,%eax
  80037f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	50                   	push   %eax
  800386:	e8 66 19 00 00       	call   801cf1 <malloc>
  80038b:	83 c4 10             	add    $0x10,%esp
  80038e:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800391:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800399:	c1 e0 02             	shl    $0x2,%eax
  80039c:	89 c1                	mov    %eax,%ecx
  80039e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a1:	c1 e0 04             	shl    $0x4,%eax
  8003a4:	01 c8                	add    %ecx,%eax
  8003a6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	73 14                	jae    8003c3 <_main+0x38b>
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	68 70 3f 80 00       	push   $0x803f70
  8003b7:	6a 55                	push   $0x55
  8003b9:	68 5c 3f 80 00       	push   $0x803f5c
  8003be:	e8 f2 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003c3:	e8 e6 1d 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  8003c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003cb:	74 14                	je     8003e1 <_main+0x3a9>
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 d8 3f 80 00       	push   $0x803fd8
  8003d5:	6a 56                	push   $0x56
  8003d7:	68 5c 3f 80 00       	push   $0x803f5c
  8003dc:	e8 d4 06 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		lastIndices[5] = (3*Mega - kilo)/sizeof(char) - 1;
  8003e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	01 d2                	add    %edx,%edx
  8003e8:	01 d0                	add    %edx,%eax
  8003ea:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003ed:	48                   	dec    %eax
  8003ee:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8003f4:	e8 15 1d 00 00       	call   80210e <sys_calculate_free_frames>
  8003f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003fc:	e8 ad 1d 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  800401:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  800404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800407:	01 c0                	add    %eax,%eax
  800409:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80040c:	83 ec 0c             	sub    $0xc,%esp
  80040f:	50                   	push   %eax
  800410:	e8 dc 18 00 00       	call   801cf1 <malloc>
  800415:	83 c4 10             	add    $0x10,%esp
  800418:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80041b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80041e:	89 c1                	mov    %eax,%ecx
  800420:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	01 c0                	add    %eax,%eax
  800427:	01 d0                	add    %edx,%eax
  800429:	01 c0                	add    %eax,%eax
  80042b:	01 d0                	add    %edx,%eax
  80042d:	89 c2                	mov    %eax,%edx
  80042f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800432:	c1 e0 04             	shl    $0x4,%eax
  800435:	01 d0                	add    %edx,%eax
  800437:	05 00 00 00 80       	add    $0x80000000,%eax
  80043c:	39 c1                	cmp    %eax,%ecx
  80043e:	73 14                	jae    800454 <_main+0x41c>
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 70 3f 80 00       	push   $0x803f70
  800448:	6a 5d                	push   $0x5d
  80044a:	68 5c 3f 80 00       	push   $0x803f5c
  80044f:	e8 61 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800454:	e8 55 1d 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  800459:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80045c:	74 14                	je     800472 <_main+0x43a>
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 d8 3f 80 00       	push   $0x803fd8
  800466:	6a 5e                	push   $0x5e
  800468:	68 5c 3f 80 00       	push   $0x803f5c
  80046d:	e8 43 06 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[6] = (2*Mega - kilo)/sizeof(char) - 1;
  800472:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800475:	01 c0                	add    %eax,%eax
  800477:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047a:	48                   	dec    %eax
  80047b:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	char x ;
	int y;
	char *byteArr ;
	//FREE ALL
	{
		int freeFrames = sys_calculate_free_frames() ;
  800481:	e8 88 1c 00 00       	call   80210e <sys_calculate_free_frames>
  800486:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800489:	e8 20 1d 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  80048e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800491:	8b 45 80             	mov    -0x80(%ebp),%eax
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	50                   	push   %eax
  800498:	e8 cf 18 00 00       	call   801d6c <free>
  80049d:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8004a0:	e8 09 1d 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  8004a5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 08 40 80 00       	push   $0x804008
  8004b2:	6a 6b                	push   $0x6b
  8004b4:	68 5c 3f 80 00       	push   $0x803f5c
  8004b9:	e8 f7 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004be:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004ca:	e8 be 1f 00 00       	call   80248d <sys_rcr2>
  8004cf:	89 c2                	mov    %eax,%edx
  8004d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d4:	39 c2                	cmp    %eax,%edx
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 44 40 80 00       	push   $0x804044
  8004e0:	6a 6f                	push   $0x6f
  8004e2:	68 5c 3f 80 00       	push   $0x803f5c
  8004e7:	e8 c9 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[0]] = 10;
  8004ec:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004f2:	89 c2                	mov    %eax,%edx
  8004f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f7:	01 d0                	add    %edx,%eax
  8004f9:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004fc:	e8 8c 1f 00 00       	call   80248d <sys_rcr2>
  800501:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  800507:	89 d1                	mov    %edx,%ecx
  800509:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050c:	01 ca                	add    %ecx,%edx
  80050e:	39 d0                	cmp    %edx,%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 44 40 80 00       	push   $0x804044
  80051a:	6a 71                	push   $0x71
  80051c:	68 5c 3f 80 00       	push   $0x803f5c
  800521:	e8 8f 05 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800526:	e8 e3 1b 00 00       	call   80210e <sys_calculate_free_frames>
  80052b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80052e:	e8 7b 1c 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  800533:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800536:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 2a 18 00 00       	call   801d6c <free>
  800542:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800545:	e8 64 1c 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  80054a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80054d:	74 14                	je     800563 <_main+0x52b>
  80054f:	83 ec 04             	sub    $0x4,%esp
  800552:	68 08 40 80 00       	push   $0x804008
  800557:	6a 76                	push   $0x76
  800559:	68 5c 3f 80 00       	push   $0x803f5c
  80055e:	e8 52 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  800563:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800566:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800569:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056c:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80056f:	e8 19 1f 00 00       	call   80248d <sys_rcr2>
  800574:	89 c2                	mov    %eax,%edx
  800576:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	74 14                	je     800591 <_main+0x559>
  80057d:	83 ec 04             	sub    $0x4,%esp
  800580:	68 44 40 80 00       	push   $0x804044
  800585:	6a 7a                	push   $0x7a
  800587:	68 5c 3f 80 00       	push   $0x803f5c
  80058c:	e8 24 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[1]] = 10;
  800591:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800597:	89 c2                	mov    %eax,%edx
  800599:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005a1:	e8 e7 1e 00 00       	call   80248d <sys_rcr2>
  8005a6:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  8005ac:	89 d1                	mov    %edx,%ecx
  8005ae:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005b1:	01 ca                	add    %ecx,%edx
  8005b3:	39 d0                	cmp    %edx,%eax
  8005b5:	74 14                	je     8005cb <_main+0x593>
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	68 44 40 80 00       	push   $0x804044
  8005bf:	6a 7c                	push   $0x7c
  8005c1:	68 5c 3f 80 00       	push   $0x803f5c
  8005c6:	e8 ea 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005cb:	e8 3e 1b 00 00       	call   80210e <sys_calculate_free_frames>
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005d3:	e8 d6 1b 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  8005d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  8005db:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005de:	83 ec 0c             	sub    $0xc,%esp
  8005e1:	50                   	push   %eax
  8005e2:	e8 85 17 00 00       	call   801d6c <free>
  8005e7:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005ea:	e8 bf 1b 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  8005ef:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005f2:	74 17                	je     80060b <_main+0x5d3>
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 08 40 80 00       	push   $0x804008
  8005fc:	68 81 00 00 00       	push   $0x81
  800601:	68 5c 3f 80 00       	push   $0x803f5c
  800606:	e8 aa 04 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  80060b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800611:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800614:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800617:	e8 71 1e 00 00       	call   80248d <sys_rcr2>
  80061c:	89 c2                	mov    %eax,%edx
  80061e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800621:	39 c2                	cmp    %eax,%edx
  800623:	74 17                	je     80063c <_main+0x604>
  800625:	83 ec 04             	sub    $0x4,%esp
  800628:	68 44 40 80 00       	push   $0x804044
  80062d:	68 85 00 00 00       	push   $0x85
  800632:	68 5c 3f 80 00       	push   $0x803f5c
  800637:	e8 79 04 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[2]] = 10;
  80063c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800642:	89 c2                	mov    %eax,%edx
  800644:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800647:	01 d0                	add    %edx,%eax
  800649:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80064c:	e8 3c 1e 00 00       	call   80248d <sys_rcr2>
  800651:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  800657:	89 d1                	mov    %edx,%ecx
  800659:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065c:	01 ca                	add    %ecx,%edx
  80065e:	39 d0                	cmp    %edx,%eax
  800660:	74 17                	je     800679 <_main+0x641>
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 44 40 80 00       	push   $0x804044
  80066a:	68 87 00 00 00       	push   $0x87
  80066f:	68 5c 3f 80 00       	push   $0x803f5c
  800674:	e8 3c 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800679:	e8 90 1a 00 00       	call   80210e <sys_calculate_free_frames>
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800681:	e8 28 1b 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  800686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800689:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	50                   	push   %eax
  800690:	e8 d7 16 00 00       	call   801d6c <free>
  800695:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800698:	e8 11 1b 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 08 40 80 00       	push   $0x804008
  8006aa:	68 8c 00 00 00       	push   $0x8c
  8006af:	68 5c 3f 80 00       	push   $0x803f5c
  8006b4:	e8 fc 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  8006b9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8006bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c2:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006c5:	e8 c3 1d 00 00       	call   80248d <sys_rcr2>
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006cf:	39 c2                	cmp    %eax,%edx
  8006d1:	74 17                	je     8006ea <_main+0x6b2>
  8006d3:	83 ec 04             	sub    $0x4,%esp
  8006d6:	68 44 40 80 00       	push   $0x804044
  8006db:	68 90 00 00 00       	push   $0x90
  8006e0:	68 5c 3f 80 00       	push   $0x803f5c
  8006e5:	e8 cb 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[3]] = 10;
  8006ea:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006fa:	e8 8e 1d 00 00       	call   80248d <sys_rcr2>
  8006ff:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800705:	89 d1                	mov    %edx,%ecx
  800707:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80070a:	01 ca                	add    %ecx,%edx
  80070c:	39 d0                	cmp    %edx,%eax
  80070e:	74 17                	je     800727 <_main+0x6ef>
  800710:	83 ec 04             	sub    $0x4,%esp
  800713:	68 44 40 80 00       	push   $0x804044
  800718:	68 92 00 00 00       	push   $0x92
  80071d:	68 5c 3f 80 00       	push   $0x803f5c
  800722:	e8 8e 03 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800727:	e8 e2 19 00 00       	call   80210e <sys_calculate_free_frames>
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80072f:	e8 7a 1a 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  800734:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  800737:	8b 45 90             	mov    -0x70(%ebp),%eax
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	50                   	push   %eax
  80073e:	e8 29 16 00 00       	call   801d6c <free>
  800743:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800746:	e8 63 1a 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  80074b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80074e:	74 17                	je     800767 <_main+0x72f>
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	68 08 40 80 00       	push   $0x804008
  800758:	68 97 00 00 00       	push   $0x97
  80075d:	68 5c 3f 80 00       	push   $0x803f5c
  800762:	e8 4e 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  800767:	8b 45 90             	mov    -0x70(%ebp),%eax
  80076a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80076d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800770:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800773:	e8 15 1d 00 00       	call   80248d <sys_rcr2>
  800778:	89 c2                	mov    %eax,%edx
  80077a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	74 17                	je     800798 <_main+0x760>
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	68 44 40 80 00       	push   $0x804044
  800789:	68 9b 00 00 00       	push   $0x9b
  80078e:	68 5c 3f 80 00       	push   $0x803f5c
  800793:	e8 1d 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[4]] = 10;
  800798:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80079e:	89 c2                	mov    %eax,%edx
  8007a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a3:	01 d0                	add    %edx,%eax
  8007a5:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007a8:	e8 e0 1c 00 00       	call   80248d <sys_rcr2>
  8007ad:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  8007b3:	89 d1                	mov    %edx,%ecx
  8007b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007b8:	01 ca                	add    %ecx,%edx
  8007ba:	39 d0                	cmp    %edx,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 44 40 80 00       	push   $0x804044
  8007c6:	68 9d 00 00 00       	push   $0x9d
  8007cb:	68 5c 3f 80 00       	push   $0x803f5c
  8007d0:	e8 e0 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8007d5:	e8 34 19 00 00       	call   80210e <sys_calculate_free_frames>
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007dd:	e8 cc 19 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  8007e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  8007e5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	50                   	push   %eax
  8007ec:	e8 7b 15 00 00       	call   801d6c <free>
  8007f1:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  8007f4:	e8 b5 19 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  8007f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8007fc:	74 17                	je     800815 <_main+0x7dd>
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	68 08 40 80 00       	push   $0x804008
  800806:	68 a2 00 00 00       	push   $0xa2
  80080b:	68 5c 3f 80 00       	push   $0x803f5c
  800810:	e8 a0 02 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  800815:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800818:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80081b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80081e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800821:	e8 67 1c 00 00       	call   80248d <sys_rcr2>
  800826:	89 c2                	mov    %eax,%edx
  800828:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80082b:	39 c2                	cmp    %eax,%edx
  80082d:	74 17                	je     800846 <_main+0x80e>
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 44 40 80 00       	push   $0x804044
  800837:	68 a6 00 00 00       	push   $0xa6
  80083c:	68 5c 3f 80 00       	push   $0x803f5c
  800841:	e8 6f 02 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[5]] = 10;
  800846:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800856:	e8 32 1c 00 00       	call   80248d <sys_rcr2>
  80085b:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  800861:	89 d1                	mov    %edx,%ecx
  800863:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800866:	01 ca                	add    %ecx,%edx
  800868:	39 d0                	cmp    %edx,%eax
  80086a:	74 17                	je     800883 <_main+0x84b>
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	68 44 40 80 00       	push   $0x804044
  800874:	68 a8 00 00 00       	push   $0xa8
  800879:	68 5c 3f 80 00       	push   $0x803f5c
  80087e:	e8 32 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800883:	e8 86 18 00 00       	call   80210e <sys_calculate_free_frames>
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80088b:	e8 1e 19 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  800890:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  800893:	8b 45 98             	mov    -0x68(%ebp),%eax
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	50                   	push   %eax
  80089a:	e8 cd 14 00 00       	call   801d6c <free>
  80089f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8008a2:	e8 07 19 00 00       	call   8021ae <sys_pf_calculate_allocated_pages>
  8008a7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8008aa:	74 17                	je     8008c3 <_main+0x88b>
  8008ac:	83 ec 04             	sub    $0x4,%esp
  8008af:	68 08 40 80 00       	push   $0x804008
  8008b4:	68 ad 00 00 00       	push   $0xad
  8008b9:	68 5c 3f 80 00       	push   $0x803f5c
  8008be:	e8 f2 01 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  8008c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8008c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008cc:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8008cf:	e8 b9 1b 00 00       	call   80248d <sys_rcr2>
  8008d4:	89 c2                	mov    %eax,%edx
  8008d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008d9:	39 c2                	cmp    %eax,%edx
  8008db:	74 17                	je     8008f4 <_main+0x8bc>
  8008dd:	83 ec 04             	sub    $0x4,%esp
  8008e0:	68 44 40 80 00       	push   $0x804044
  8008e5:	68 b1 00 00 00       	push   $0xb1
  8008ea:	68 5c 3f 80 00       	push   $0x803f5c
  8008ef:	e8 c1 01 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[6]] = 10;
  8008f4:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8008fa:	89 c2                	mov    %eax,%edx
  8008fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008ff:	01 d0                	add    %edx,%eax
  800901:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800904:	e8 84 1b 00 00       	call   80248d <sys_rcr2>
  800909:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  80090f:	89 d1                	mov    %edx,%ecx
  800911:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800914:	01 ca                	add    %ecx,%edx
  800916:	39 d0                	cmp    %edx,%eax
  800918:	74 17                	je     800931 <_main+0x8f9>
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	68 44 40 80 00       	push   $0x804044
  800922:	68 b3 00 00 00       	push   $0xb3
  800927:	68 5c 3f 80 00       	push   $0x803f5c
  80092c:	e8 84 01 00 00       	call   800ab5 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames()) ) {panic("Wrong free: not all pages removed correctly at end");}
  800931:	e8 d8 17 00 00       	call   80210e <sys_calculate_free_frames>
  800936:	89 c2                	mov    %eax,%edx
  800938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80093b:	39 c2                	cmp    %eax,%edx
  80093d:	74 17                	je     800956 <_main+0x91e>
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	68 88 40 80 00       	push   $0x804088
  800947:	68 b5 00 00 00       	push   $0xb5
  80094c:	68 5c 3f 80 00       	push   $0x803f5c
  800951:	e8 5f 01 00 00       	call   800ab5 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  800956:	83 ec 0c             	sub    $0xc,%esp
  800959:	6a 00                	push   $0x0
  80095b:	e8 46 1b 00 00       	call   8024a6 <sys_bypassPageFault>
  800960:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  800963:	83 ec 0c             	sub    $0xc,%esp
  800966:	68 bc 40 80 00       	push   $0x8040bc
  80096b:	e8 f9 03 00 00       	call   800d69 <cprintf>
  800970:	83 c4 10             	add    $0x10,%esp

	return;
  800973:	90                   	nop
}
  800974:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800977:	c9                   	leave  
  800978:	c3                   	ret    

00800979 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80097f:	e8 6a 1a 00 00       	call   8023ee <sys_getenvindex>
  800984:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800987:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098a:	89 d0                	mov    %edx,%eax
  80098c:	c1 e0 03             	shl    $0x3,%eax
  80098f:	01 d0                	add    %edx,%eax
  800991:	01 c0                	add    %eax,%eax
  800993:	01 d0                	add    %edx,%eax
  800995:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80099c:	01 d0                	add    %edx,%eax
  80099e:	c1 e0 04             	shl    $0x4,%eax
  8009a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8009a6:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8009ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b0:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8009b6:	84 c0                	test   %al,%al
  8009b8:	74 0f                	je     8009c9 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8009ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8009bf:	05 5c 05 00 00       	add    $0x55c,%eax
  8009c4:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009cd:	7e 0a                	jle    8009d9 <libmain+0x60>
		binaryname = argv[0];
  8009cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	ff 75 08             	pushl  0x8(%ebp)
  8009e2:	e8 51 f6 ff ff       	call   800038 <_main>
  8009e7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8009ea:	e8 0c 18 00 00       	call   8021fb <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009ef:	83 ec 0c             	sub    $0xc,%esp
  8009f2:	68 10 41 80 00       	push   $0x804110
  8009f7:	e8 6d 03 00 00       	call   800d69 <cprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800a04:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800a0a:	a1 20 50 80 00       	mov    0x805020,%eax
  800a0f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	52                   	push   %edx
  800a19:	50                   	push   %eax
  800a1a:	68 38 41 80 00       	push   $0x804138
  800a1f:	e8 45 03 00 00       	call   800d69 <cprintf>
  800a24:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800a27:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800a32:	a1 20 50 80 00       	mov    0x805020,%eax
  800a37:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800a3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800a42:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800a48:	51                   	push   %ecx
  800a49:	52                   	push   %edx
  800a4a:	50                   	push   %eax
  800a4b:	68 60 41 80 00       	push   $0x804160
  800a50:	e8 14 03 00 00       	call   800d69 <cprintf>
  800a55:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a58:	a1 20 50 80 00       	mov    0x805020,%eax
  800a5d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	50                   	push   %eax
  800a67:	68 b8 41 80 00       	push   $0x8041b8
  800a6c:	e8 f8 02 00 00       	call   800d69 <cprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	68 10 41 80 00       	push   $0x804110
  800a7c:	e8 e8 02 00 00       	call   800d69 <cprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a84:	e8 8c 17 00 00       	call   802215 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a89:	e8 19 00 00 00       	call   800aa7 <exit>
}
  800a8e:	90                   	nop
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a97:	83 ec 0c             	sub    $0xc,%esp
  800a9a:	6a 00                	push   $0x0
  800a9c:	e8 19 19 00 00       	call   8023ba <sys_destroy_env>
  800aa1:	83 c4 10             	add    $0x10,%esp
}
  800aa4:	90                   	nop
  800aa5:	c9                   	leave  
  800aa6:	c3                   	ret    

00800aa7 <exit>:

void
exit(void)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800aad:	e8 6e 19 00 00       	call   802420 <sys_exit_env>
}
  800ab2:	90                   	nop
  800ab3:	c9                   	leave  
  800ab4:	c3                   	ret    

00800ab5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800abb:	8d 45 10             	lea    0x10(%ebp),%eax
  800abe:	83 c0 04             	add    $0x4,%eax
  800ac1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ac4:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ac9:	85 c0                	test   %eax,%eax
  800acb:	74 16                	je     800ae3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800acd:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	50                   	push   %eax
  800ad6:	68 cc 41 80 00       	push   $0x8041cc
  800adb:	e8 89 02 00 00       	call   800d69 <cprintf>
  800ae0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ae3:	a1 00 50 80 00       	mov    0x805000,%eax
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	50                   	push   %eax
  800aef:	68 d1 41 80 00       	push   $0x8041d1
  800af4:	e8 70 02 00 00       	call   800d69 <cprintf>
  800af9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 f4             	pushl  -0xc(%ebp)
  800b05:	50                   	push   %eax
  800b06:	e8 f3 01 00 00       	call   800cfe <vcprintf>
  800b0b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	6a 00                	push   $0x0
  800b13:	68 ed 41 80 00       	push   $0x8041ed
  800b18:	e8 e1 01 00 00       	call   800cfe <vcprintf>
  800b1d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b20:	e8 82 ff ff ff       	call   800aa7 <exit>

	// should not return here
	while (1) ;
  800b25:	eb fe                	jmp    800b25 <_panic+0x70>

00800b27 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b2d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b32:	8b 50 74             	mov    0x74(%eax),%edx
  800b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b38:	39 c2                	cmp    %eax,%edx
  800b3a:	74 14                	je     800b50 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b3c:	83 ec 04             	sub    $0x4,%esp
  800b3f:	68 f0 41 80 00       	push   $0x8041f0
  800b44:	6a 26                	push   $0x26
  800b46:	68 3c 42 80 00       	push   $0x80423c
  800b4b:	e8 65 ff ff ff       	call   800ab5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b5e:	e9 c2 00 00 00       	jmp    800c25 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	01 d0                	add    %edx,%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	85 c0                	test   %eax,%eax
  800b76:	75 08                	jne    800b80 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800b78:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b7b:	e9 a2 00 00 00       	jmp    800c22 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800b80:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b8e:	eb 69                	jmp    800bf9 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b90:	a1 20 50 80 00       	mov    0x805020,%eax
  800b95:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b9e:	89 d0                	mov    %edx,%eax
  800ba0:	01 c0                	add    %eax,%eax
  800ba2:	01 d0                	add    %edx,%eax
  800ba4:	c1 e0 03             	shl    $0x3,%eax
  800ba7:	01 c8                	add    %ecx,%eax
  800ba9:	8a 40 04             	mov    0x4(%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	75 46                	jne    800bf6 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bb0:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bbb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bbe:	89 d0                	mov    %edx,%eax
  800bc0:	01 c0                	add    %eax,%eax
  800bc2:	01 d0                	add    %edx,%eax
  800bc4:	c1 e0 03             	shl    $0x3,%eax
  800bc7:	01 c8                	add    %ecx,%eax
  800bc9:	8b 00                	mov    (%eax),%eax
  800bcb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800bd1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bd6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	01 c8                	add    %ecx,%eax
  800be7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800be9:	39 c2                	cmp    %eax,%edx
  800beb:	75 09                	jne    800bf6 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800bed:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800bf4:	eb 12                	jmp    800c08 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bf6:	ff 45 e8             	incl   -0x18(%ebp)
  800bf9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bfe:	8b 50 74             	mov    0x74(%eax),%edx
  800c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c04:	39 c2                	cmp    %eax,%edx
  800c06:	77 88                	ja     800b90 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800c08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c0c:	75 14                	jne    800c22 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800c0e:	83 ec 04             	sub    $0x4,%esp
  800c11:	68 48 42 80 00       	push   $0x804248
  800c16:	6a 3a                	push   $0x3a
  800c18:	68 3c 42 80 00       	push   $0x80423c
  800c1d:	e8 93 fe ff ff       	call   800ab5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c22:	ff 45 f0             	incl   -0x10(%ebp)
  800c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c28:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c2b:	0f 8c 32 ff ff ff    	jl     800b63 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c3f:	eb 26                	jmp    800c67 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c41:	a1 20 50 80 00       	mov    0x805020,%eax
  800c46:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800c4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c4f:	89 d0                	mov    %edx,%eax
  800c51:	01 c0                	add    %eax,%eax
  800c53:	01 d0                	add    %edx,%eax
  800c55:	c1 e0 03             	shl    $0x3,%eax
  800c58:	01 c8                	add    %ecx,%eax
  800c5a:	8a 40 04             	mov    0x4(%eax),%al
  800c5d:	3c 01                	cmp    $0x1,%al
  800c5f:	75 03                	jne    800c64 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800c61:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c64:	ff 45 e0             	incl   -0x20(%ebp)
  800c67:	a1 20 50 80 00       	mov    0x805020,%eax
  800c6c:	8b 50 74             	mov    0x74(%eax),%edx
  800c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c72:	39 c2                	cmp    %eax,%edx
  800c74:	77 cb                	ja     800c41 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c79:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c7c:	74 14                	je     800c92 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800c7e:	83 ec 04             	sub    $0x4,%esp
  800c81:	68 9c 42 80 00       	push   $0x80429c
  800c86:	6a 44                	push   $0x44
  800c88:	68 3c 42 80 00       	push   $0x80423c
  800c8d:	e8 23 fe ff ff       	call   800ab5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c92:	90                   	nop
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	89 0a                	mov    %ecx,(%edx)
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	88 d1                	mov    %dl,%cl
  800cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8b 00                	mov    (%eax),%eax
  800cb9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800cbe:	75 2c                	jne    800cec <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800cc0:	a0 24 50 80 00       	mov    0x805024,%al
  800cc5:	0f b6 c0             	movzbl %al,%eax
  800cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccb:	8b 12                	mov    (%edx),%edx
  800ccd:	89 d1                	mov    %edx,%ecx
  800ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd2:	83 c2 08             	add    $0x8,%edx
  800cd5:	83 ec 04             	sub    $0x4,%esp
  800cd8:	50                   	push   %eax
  800cd9:	51                   	push   %ecx
  800cda:	52                   	push   %edx
  800cdb:	e8 6d 13 00 00       	call   80204d <sys_cputs>
  800ce0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	8b 40 04             	mov    0x4(%eax),%eax
  800cf2:	8d 50 01             	lea    0x1(%eax),%edx
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	89 50 04             	mov    %edx,0x4(%eax)
}
  800cfb:	90                   	nop
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d07:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d0e:	00 00 00 
	b.cnt = 0;
  800d11:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d18:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	ff 75 08             	pushl  0x8(%ebp)
  800d21:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d27:	50                   	push   %eax
  800d28:	68 95 0c 80 00       	push   $0x800c95
  800d2d:	e8 11 02 00 00       	call   800f43 <vprintfmt>
  800d32:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800d35:	a0 24 50 80 00       	mov    0x805024,%al
  800d3a:	0f b6 c0             	movzbl %al,%eax
  800d3d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800d43:	83 ec 04             	sub    $0x4,%esp
  800d46:	50                   	push   %eax
  800d47:	52                   	push   %edx
  800d48:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d4e:	83 c0 08             	add    $0x8,%eax
  800d51:	50                   	push   %eax
  800d52:	e8 f6 12 00 00       	call   80204d <sys_cputs>
  800d57:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d5a:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800d61:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <cprintf>:

int cprintf(const char *fmt, ...) {
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d6f:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800d76:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 f4             	pushl  -0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	e8 73 ff ff ff       	call   800cfe <vcprintf>
  800d8b:	83 c4 10             	add    $0x10,%esp
  800d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d9c:	e8 5a 14 00 00       	call   8021fb <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800da1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 f4             	pushl  -0xc(%ebp)
  800db0:	50                   	push   %eax
  800db1:	e8 48 ff ff ff       	call   800cfe <vcprintf>
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800dbc:	e8 54 14 00 00       	call   802215 <sys_enable_interrupt>
	return cnt;
  800dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	53                   	push   %ebx
  800dca:	83 ec 14             	sub    $0x14,%esp
  800dcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800dd9:	8b 45 18             	mov    0x18(%ebp),%eax
  800ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  800de1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800de4:	77 55                	ja     800e3b <printnum+0x75>
  800de6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800de9:	72 05                	jb     800df0 <printnum+0x2a>
  800deb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800dee:	77 4b                	ja     800e3b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800df0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800df3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800df6:	8b 45 18             	mov    0x18(%ebp),%eax
  800df9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dfe:	52                   	push   %edx
  800dff:	50                   	push   %eax
  800e00:	ff 75 f4             	pushl  -0xc(%ebp)
  800e03:	ff 75 f0             	pushl  -0x10(%ebp)
  800e06:	e8 c5 2e 00 00       	call   803cd0 <__udivdi3>
  800e0b:	83 c4 10             	add    $0x10,%esp
  800e0e:	83 ec 04             	sub    $0x4,%esp
  800e11:	ff 75 20             	pushl  0x20(%ebp)
  800e14:	53                   	push   %ebx
  800e15:	ff 75 18             	pushl  0x18(%ebp)
  800e18:	52                   	push   %edx
  800e19:	50                   	push   %eax
  800e1a:	ff 75 0c             	pushl  0xc(%ebp)
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	e8 a1 ff ff ff       	call   800dc6 <printnum>
  800e25:	83 c4 20             	add    $0x20,%esp
  800e28:	eb 1a                	jmp    800e44 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e2a:	83 ec 08             	sub    $0x8,%esp
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	ff 75 20             	pushl  0x20(%ebp)
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	ff d0                	call   *%eax
  800e38:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e3b:	ff 4d 1c             	decl   0x1c(%ebp)
  800e3e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e42:	7f e6                	jg     800e2a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e44:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	53                   	push   %ebx
  800e53:	51                   	push   %ecx
  800e54:	52                   	push   %edx
  800e55:	50                   	push   %eax
  800e56:	e8 85 2f 00 00       	call   803de0 <__umoddi3>
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	05 14 45 80 00       	add    $0x804514,%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f be c0             	movsbl %al,%eax
  800e68:	83 ec 08             	sub    $0x8,%esp
  800e6b:	ff 75 0c             	pushl  0xc(%ebp)
  800e6e:	50                   	push   %eax
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	ff d0                	call   *%eax
  800e74:	83 c4 10             	add    $0x10,%esp
}
  800e77:	90                   	nop
  800e78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e80:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e84:	7e 1c                	jle    800ea2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	8b 00                	mov    (%eax),%eax
  800e8b:	8d 50 08             	lea    0x8(%eax),%edx
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	89 10                	mov    %edx,(%eax)
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	83 e8 08             	sub    $0x8,%eax
  800e9b:	8b 50 04             	mov    0x4(%eax),%edx
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	eb 40                	jmp    800ee2 <getuint+0x65>
	else if (lflag)
  800ea2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea6:	74 1e                	je     800ec6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	8d 50 04             	lea    0x4(%eax),%edx
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	89 10                	mov    %edx,(%eax)
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	8b 00                	mov    (%eax),%eax
  800eba:	83 e8 04             	sub    $0x4,%eax
  800ebd:	8b 00                	mov    (%eax),%eax
  800ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec4:	eb 1c                	jmp    800ee2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8b 00                	mov    (%eax),%eax
  800ecb:	8d 50 04             	lea    0x4(%eax),%edx
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 10                	mov    %edx,(%eax)
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8b 00                	mov    (%eax),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax
  800edd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ee7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800eeb:	7e 1c                	jle    800f09 <getint+0x25>
		return va_arg(*ap, long long);
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8b 00                	mov    (%eax),%eax
  800ef2:	8d 50 08             	lea    0x8(%eax),%edx
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	89 10                	mov    %edx,(%eax)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8b 00                	mov    (%eax),%eax
  800eff:	83 e8 08             	sub    $0x8,%eax
  800f02:	8b 50 04             	mov    0x4(%eax),%edx
  800f05:	8b 00                	mov    (%eax),%eax
  800f07:	eb 38                	jmp    800f41 <getint+0x5d>
	else if (lflag)
  800f09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0d:	74 1a                	je     800f29 <getint+0x45>
		return va_arg(*ap, long);
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8b 00                	mov    (%eax),%eax
  800f14:	8d 50 04             	lea    0x4(%eax),%edx
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	89 10                	mov    %edx,(%eax)
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8b 00                	mov    (%eax),%eax
  800f21:	83 e8 04             	sub    $0x4,%eax
  800f24:	8b 00                	mov    (%eax),%eax
  800f26:	99                   	cltd   
  800f27:	eb 18                	jmp    800f41 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8b 00                	mov    (%eax),%eax
  800f2e:	8d 50 04             	lea    0x4(%eax),%edx
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	89 10                	mov    %edx,(%eax)
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	83 e8 04             	sub    $0x4,%eax
  800f3e:	8b 00                	mov    (%eax),%eax
  800f40:	99                   	cltd   
}
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	56                   	push   %esi
  800f47:	53                   	push   %ebx
  800f48:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f4b:	eb 17                	jmp    800f64 <vprintfmt+0x21>
			if (ch == '\0')
  800f4d:	85 db                	test   %ebx,%ebx
  800f4f:	0f 84 af 03 00 00    	je     801304 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800f55:	83 ec 08             	sub    $0x8,%esp
  800f58:	ff 75 0c             	pushl  0xc(%ebp)
  800f5b:	53                   	push   %ebx
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	ff d0                	call   *%eax
  800f61:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 01             	lea    0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	0f b6 d8             	movzbl %al,%ebx
  800f72:	83 fb 25             	cmp    $0x25,%ebx
  800f75:	75 d6                	jne    800f4d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f77:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f7b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f82:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f89:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f90:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	8d 50 01             	lea    0x1(%eax),%edx
  800f9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	0f b6 d8             	movzbl %al,%ebx
  800fa5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800fa8:	83 f8 55             	cmp    $0x55,%eax
  800fab:	0f 87 2b 03 00 00    	ja     8012dc <vprintfmt+0x399>
  800fb1:	8b 04 85 38 45 80 00 	mov    0x804538(,%eax,4),%eax
  800fb8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800fba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800fbe:	eb d7                	jmp    800f97 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fc0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800fc4:	eb d1                	jmp    800f97 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fc6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800fcd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	c1 e0 02             	shl    $0x2,%eax
  800fd5:	01 d0                	add    %edx,%eax
  800fd7:	01 c0                	add    %eax,%eax
  800fd9:	01 d8                	add    %ebx,%eax
  800fdb:	83 e8 30             	sub    $0x30,%eax
  800fde:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fe9:	83 fb 2f             	cmp    $0x2f,%ebx
  800fec:	7e 3e                	jle    80102c <vprintfmt+0xe9>
  800fee:	83 fb 39             	cmp    $0x39,%ebx
  800ff1:	7f 39                	jg     80102c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ff3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ff6:	eb d5                	jmp    800fcd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ff8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffb:	83 c0 04             	add    $0x4,%eax
  800ffe:	89 45 14             	mov    %eax,0x14(%ebp)
  801001:	8b 45 14             	mov    0x14(%ebp),%eax
  801004:	83 e8 04             	sub    $0x4,%eax
  801007:	8b 00                	mov    (%eax),%eax
  801009:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80100c:	eb 1f                	jmp    80102d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80100e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801012:	79 83                	jns    800f97 <vprintfmt+0x54>
				width = 0;
  801014:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80101b:	e9 77 ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801020:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801027:	e9 6b ff ff ff       	jmp    800f97 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80102c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80102d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801031:	0f 89 60 ff ff ff    	jns    800f97 <vprintfmt+0x54>
				width = precision, precision = -1;
  801037:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80103a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80103d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801044:	e9 4e ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801049:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80104c:	e9 46 ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801051:	8b 45 14             	mov    0x14(%ebp),%eax
  801054:	83 c0 04             	add    $0x4,%eax
  801057:	89 45 14             	mov    %eax,0x14(%ebp)
  80105a:	8b 45 14             	mov    0x14(%ebp),%eax
  80105d:	83 e8 04             	sub    $0x4,%eax
  801060:	8b 00                	mov    (%eax),%eax
  801062:	83 ec 08             	sub    $0x8,%esp
  801065:	ff 75 0c             	pushl  0xc(%ebp)
  801068:	50                   	push   %eax
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	ff d0                	call   *%eax
  80106e:	83 c4 10             	add    $0x10,%esp
			break;
  801071:	e9 89 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801076:	8b 45 14             	mov    0x14(%ebp),%eax
  801079:	83 c0 04             	add    $0x4,%eax
  80107c:	89 45 14             	mov    %eax,0x14(%ebp)
  80107f:	8b 45 14             	mov    0x14(%ebp),%eax
  801082:	83 e8 04             	sub    $0x4,%eax
  801085:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801087:	85 db                	test   %ebx,%ebx
  801089:	79 02                	jns    80108d <vprintfmt+0x14a>
				err = -err;
  80108b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80108d:	83 fb 64             	cmp    $0x64,%ebx
  801090:	7f 0b                	jg     80109d <vprintfmt+0x15a>
  801092:	8b 34 9d 80 43 80 00 	mov    0x804380(,%ebx,4),%esi
  801099:	85 f6                	test   %esi,%esi
  80109b:	75 19                	jne    8010b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80109d:	53                   	push   %ebx
  80109e:	68 25 45 80 00       	push   $0x804525
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	ff 75 08             	pushl  0x8(%ebp)
  8010a9:	e8 5e 02 00 00       	call   80130c <printfmt>
  8010ae:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010b1:	e9 49 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8010b6:	56                   	push   %esi
  8010b7:	68 2e 45 80 00       	push   $0x80452e
  8010bc:	ff 75 0c             	pushl  0xc(%ebp)
  8010bf:	ff 75 08             	pushl  0x8(%ebp)
  8010c2:	e8 45 02 00 00       	call   80130c <printfmt>
  8010c7:	83 c4 10             	add    $0x10,%esp
			break;
  8010ca:	e9 30 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8010cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d2:	83 c0 04             	add    $0x4,%eax
  8010d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010db:	83 e8 04             	sub    $0x4,%eax
  8010de:	8b 30                	mov    (%eax),%esi
  8010e0:	85 f6                	test   %esi,%esi
  8010e2:	75 05                	jne    8010e9 <vprintfmt+0x1a6>
				p = "(null)";
  8010e4:	be 31 45 80 00       	mov    $0x804531,%esi
			if (width > 0 && padc != '-')
  8010e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010ed:	7e 6d                	jle    80115c <vprintfmt+0x219>
  8010ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8010f3:	74 67                	je     80115c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8010f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010f8:	83 ec 08             	sub    $0x8,%esp
  8010fb:	50                   	push   %eax
  8010fc:	56                   	push   %esi
  8010fd:	e8 0c 03 00 00       	call   80140e <strnlen>
  801102:	83 c4 10             	add    $0x10,%esp
  801105:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801108:	eb 16                	jmp    801120 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80110a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	50                   	push   %eax
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	ff d0                	call   *%eax
  80111a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80111d:	ff 4d e4             	decl   -0x1c(%ebp)
  801120:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801124:	7f e4                	jg     80110a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801126:	eb 34                	jmp    80115c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801128:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80112c:	74 1c                	je     80114a <vprintfmt+0x207>
  80112e:	83 fb 1f             	cmp    $0x1f,%ebx
  801131:	7e 05                	jle    801138 <vprintfmt+0x1f5>
  801133:	83 fb 7e             	cmp    $0x7e,%ebx
  801136:	7e 12                	jle    80114a <vprintfmt+0x207>
					putch('?', putdat);
  801138:	83 ec 08             	sub    $0x8,%esp
  80113b:	ff 75 0c             	pushl  0xc(%ebp)
  80113e:	6a 3f                	push   $0x3f
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	ff d0                	call   *%eax
  801145:	83 c4 10             	add    $0x10,%esp
  801148:	eb 0f                	jmp    801159 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	53                   	push   %ebx
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	ff d0                	call   *%eax
  801156:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801159:	ff 4d e4             	decl   -0x1c(%ebp)
  80115c:	89 f0                	mov    %esi,%eax
  80115e:	8d 70 01             	lea    0x1(%eax),%esi
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be d8             	movsbl %al,%ebx
  801166:	85 db                	test   %ebx,%ebx
  801168:	74 24                	je     80118e <vprintfmt+0x24b>
  80116a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80116e:	78 b8                	js     801128 <vprintfmt+0x1e5>
  801170:	ff 4d e0             	decl   -0x20(%ebp)
  801173:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801177:	79 af                	jns    801128 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801179:	eb 13                	jmp    80118e <vprintfmt+0x24b>
				putch(' ', putdat);
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	ff 75 0c             	pushl  0xc(%ebp)
  801181:	6a 20                	push   $0x20
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	ff d0                	call   *%eax
  801188:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80118b:	ff 4d e4             	decl   -0x1c(%ebp)
  80118e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801192:	7f e7                	jg     80117b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801194:	e9 66 01 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801199:	83 ec 08             	sub    $0x8,%esp
  80119c:	ff 75 e8             	pushl  -0x18(%ebp)
  80119f:	8d 45 14             	lea    0x14(%ebp),%eax
  8011a2:	50                   	push   %eax
  8011a3:	e8 3c fd ff ff       	call   800ee4 <getint>
  8011a8:	83 c4 10             	add    $0x10,%esp
  8011ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8011b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b7:	85 d2                	test   %edx,%edx
  8011b9:	79 23                	jns    8011de <vprintfmt+0x29b>
				putch('-', putdat);
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	ff 75 0c             	pushl  0xc(%ebp)
  8011c1:	6a 2d                	push   $0x2d
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	ff d0                	call   *%eax
  8011c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8011cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d1:	f7 d8                	neg    %eax
  8011d3:	83 d2 00             	adc    $0x0,%edx
  8011d6:	f7 da                	neg    %edx
  8011d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8011de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011e5:	e9 bc 00 00 00       	jmp    8012a6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8011ea:	83 ec 08             	sub    $0x8,%esp
  8011ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8011f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8011f3:	50                   	push   %eax
  8011f4:	e8 84 fc ff ff       	call   800e7d <getuint>
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801202:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801209:	e9 98 00 00 00       	jmp    8012a6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80120e:	83 ec 08             	sub    $0x8,%esp
  801211:	ff 75 0c             	pushl  0xc(%ebp)
  801214:	6a 58                	push   $0x58
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	ff d0                	call   *%eax
  80121b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80121e:	83 ec 08             	sub    $0x8,%esp
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	6a 58                	push   $0x58
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	ff d0                	call   *%eax
  80122b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80122e:	83 ec 08             	sub    $0x8,%esp
  801231:	ff 75 0c             	pushl  0xc(%ebp)
  801234:	6a 58                	push   $0x58
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	ff d0                	call   *%eax
  80123b:	83 c4 10             	add    $0x10,%esp
			break;
  80123e:	e9 bc 00 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	ff 75 0c             	pushl  0xc(%ebp)
  801249:	6a 30                	push   $0x30
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	ff d0                	call   *%eax
  801250:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801253:	83 ec 08             	sub    $0x8,%esp
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	6a 78                	push   $0x78
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	ff d0                	call   *%eax
  801260:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801263:	8b 45 14             	mov    0x14(%ebp),%eax
  801266:	83 c0 04             	add    $0x4,%eax
  801269:	89 45 14             	mov    %eax,0x14(%ebp)
  80126c:	8b 45 14             	mov    0x14(%ebp),%eax
  80126f:	83 e8 04             	sub    $0x4,%eax
  801272:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801277:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80127e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801285:	eb 1f                	jmp    8012a6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	ff 75 e8             	pushl  -0x18(%ebp)
  80128d:	8d 45 14             	lea    0x14(%ebp),%eax
  801290:	50                   	push   %eax
  801291:	e8 e7 fb ff ff       	call   800e7d <getuint>
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80129c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80129f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8012a6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8012aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	52                   	push   %edx
  8012b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012b4:	50                   	push   %eax
  8012b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8012bb:	ff 75 0c             	pushl  0xc(%ebp)
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	e8 00 fb ff ff       	call   800dc6 <printnum>
  8012c6:	83 c4 20             	add    $0x20,%esp
			break;
  8012c9:	eb 34                	jmp    8012ff <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8012cb:	83 ec 08             	sub    $0x8,%esp
  8012ce:	ff 75 0c             	pushl  0xc(%ebp)
  8012d1:	53                   	push   %ebx
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	ff d0                	call   *%eax
  8012d7:	83 c4 10             	add    $0x10,%esp
			break;
  8012da:	eb 23                	jmp    8012ff <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012dc:	83 ec 08             	sub    $0x8,%esp
  8012df:	ff 75 0c             	pushl  0xc(%ebp)
  8012e2:	6a 25                	push   $0x25
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	ff d0                	call   *%eax
  8012e9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012ec:	ff 4d 10             	decl   0x10(%ebp)
  8012ef:	eb 03                	jmp    8012f4 <vprintfmt+0x3b1>
  8012f1:	ff 4d 10             	decl   0x10(%ebp)
  8012f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f7:	48                   	dec    %eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	3c 25                	cmp    $0x25,%al
  8012fc:	75 f3                	jne    8012f1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8012fe:	90                   	nop
		}
	}
  8012ff:	e9 47 fc ff ff       	jmp    800f4b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801304:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801305:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801308:	5b                   	pop    %ebx
  801309:	5e                   	pop    %esi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801312:	8d 45 10             	lea    0x10(%ebp),%eax
  801315:	83 c0 04             	add    $0x4,%eax
  801318:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80131b:	8b 45 10             	mov    0x10(%ebp),%eax
  80131e:	ff 75 f4             	pushl  -0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	ff 75 0c             	pushl  0xc(%ebp)
  801325:	ff 75 08             	pushl  0x8(%ebp)
  801328:	e8 16 fc ff ff       	call   800f43 <vprintfmt>
  80132d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801330:	90                   	nop
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	8b 40 08             	mov    0x8(%eax),%eax
  80133c:	8d 50 01             	lea    0x1(%eax),%edx
  80133f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801342:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801345:	8b 45 0c             	mov    0xc(%ebp),%eax
  801348:	8b 10                	mov    (%eax),%edx
  80134a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134d:	8b 40 04             	mov    0x4(%eax),%eax
  801350:	39 c2                	cmp    %eax,%edx
  801352:	73 12                	jae    801366 <sprintputch+0x33>
		*b->buf++ = ch;
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	8b 00                	mov    (%eax),%eax
  801359:	8d 48 01             	lea    0x1(%eax),%ecx
  80135c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135f:	89 0a                	mov    %ecx,(%edx)
  801361:	8b 55 08             	mov    0x8(%ebp),%edx
  801364:	88 10                	mov    %dl,(%eax)
}
  801366:	90                   	nop
  801367:	5d                   	pop    %ebp
  801368:	c3                   	ret    

00801369 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	8d 50 ff             	lea    -0x1(%eax),%edx
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	01 d0                	add    %edx,%eax
  801380:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80138a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138e:	74 06                	je     801396 <vsnprintf+0x2d>
  801390:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801394:	7f 07                	jg     80139d <vsnprintf+0x34>
		return -E_INVAL;
  801396:	b8 03 00 00 00       	mov    $0x3,%eax
  80139b:	eb 20                	jmp    8013bd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80139d:	ff 75 14             	pushl  0x14(%ebp)
  8013a0:	ff 75 10             	pushl  0x10(%ebp)
  8013a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8013a6:	50                   	push   %eax
  8013a7:	68 33 13 80 00       	push   $0x801333
  8013ac:	e8 92 fb ff ff       	call   800f43 <vprintfmt>
  8013b1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8013b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8013ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8013c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8013c8:	83 c0 04             	add    $0x4,%eax
  8013cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8013ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8013d4:	50                   	push   %eax
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	ff 75 08             	pushl  0x8(%ebp)
  8013db:	e8 89 ff ff ff       	call   801369 <vsnprintf>
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8013e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f8:	eb 06                	jmp    801400 <strlen+0x15>
		n++;
  8013fa:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013fd:	ff 45 08             	incl   0x8(%ebp)
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	84 c0                	test   %al,%al
  801407:	75 f1                	jne    8013fa <strlen+0xf>
		n++;
	return n;
  801409:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141b:	eb 09                	jmp    801426 <strnlen+0x18>
		n++;
  80141d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801420:	ff 45 08             	incl   0x8(%ebp)
  801423:	ff 4d 0c             	decl   0xc(%ebp)
  801426:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80142a:	74 09                	je     801435 <strnlen+0x27>
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	84 c0                	test   %al,%al
  801433:	75 e8                	jne    80141d <strnlen+0xf>
		n++;
	return n;
  801435:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801446:	90                   	nop
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8d 50 01             	lea    0x1(%eax),%edx
  80144d:	89 55 08             	mov    %edx,0x8(%ebp)
  801450:	8b 55 0c             	mov    0xc(%ebp),%edx
  801453:	8d 4a 01             	lea    0x1(%edx),%ecx
  801456:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801459:	8a 12                	mov    (%edx),%dl
  80145b:	88 10                	mov    %dl,(%eax)
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	84 c0                	test   %al,%al
  801461:	75 e4                	jne    801447 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801463:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801474:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80147b:	eb 1f                	jmp    80149c <strncpy+0x34>
		*dst++ = *src;
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8d 50 01             	lea    0x1(%eax),%edx
  801483:	89 55 08             	mov    %edx,0x8(%ebp)
  801486:	8b 55 0c             	mov    0xc(%ebp),%edx
  801489:	8a 12                	mov    (%edx),%dl
  80148b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80148d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 03                	je     801499 <strncpy+0x31>
			src++;
  801496:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801499:	ff 45 fc             	incl   -0x4(%ebp)
  80149c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014a2:	72 d9                	jb     80147d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b9:	74 30                	je     8014eb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014bb:	eb 16                	jmp    8014d3 <strlcpy+0x2a>
			*dst++ = *src++;
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8d 50 01             	lea    0x1(%eax),%edx
  8014c3:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014cf:	8a 12                	mov    (%edx),%dl
  8014d1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014d3:	ff 4d 10             	decl   0x10(%ebp)
  8014d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014da:	74 09                	je     8014e5 <strlcpy+0x3c>
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	84 c0                	test   %al,%al
  8014e3:	75 d8                	jne    8014bd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	29 c2                	sub    %eax,%edx
  8014f3:	89 d0                	mov    %edx,%eax
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014fa:	eb 06                	jmp    801502 <strcmp+0xb>
		p++, q++;
  8014fc:	ff 45 08             	incl   0x8(%ebp)
  8014ff:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	84 c0                	test   %al,%al
  801509:	74 0e                	je     801519 <strcmp+0x22>
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	8a 10                	mov    (%eax),%dl
  801510:	8b 45 0c             	mov    0xc(%ebp),%eax
  801513:	8a 00                	mov    (%eax),%al
  801515:	38 c2                	cmp    %al,%dl
  801517:	74 e3                	je     8014fc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8a 00                	mov    (%eax),%al
  80151e:	0f b6 d0             	movzbl %al,%edx
  801521:	8b 45 0c             	mov    0xc(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	0f b6 c0             	movzbl %al,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
}
  80152d:	5d                   	pop    %ebp
  80152e:	c3                   	ret    

0080152f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801532:	eb 09                	jmp    80153d <strncmp+0xe>
		n--, p++, q++;
  801534:	ff 4d 10             	decl   0x10(%ebp)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80153d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801541:	74 17                	je     80155a <strncmp+0x2b>
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 0e                	je     80155a <strncmp+0x2b>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 10                	mov    (%eax),%dl
  801551:	8b 45 0c             	mov    0xc(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	38 c2                	cmp    %al,%dl
  801558:	74 da                	je     801534 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80155a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80155e:	75 07                	jne    801567 <strncmp+0x38>
		return 0;
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	eb 14                	jmp    80157b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	8a 00                	mov    (%eax),%al
  80156c:	0f b6 d0             	movzbl %al,%edx
  80156f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801572:	8a 00                	mov    (%eax),%al
  801574:	0f b6 c0             	movzbl %al,%eax
  801577:	29 c2                	sub    %eax,%edx
  801579:	89 d0                	mov    %edx,%eax
}
  80157b:	5d                   	pop    %ebp
  80157c:	c3                   	ret    

0080157d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801589:	eb 12                	jmp    80159d <strchr+0x20>
		if (*s == c)
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801593:	75 05                	jne    80159a <strchr+0x1d>
			return (char *) s;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	eb 11                	jmp    8015ab <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80159a:	ff 45 08             	incl   0x8(%ebp)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	84 c0                	test   %al,%al
  8015a4:	75 e5                	jne    80158b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 04             	sub    $0x4,%esp
  8015b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b9:	eb 0d                	jmp    8015c8 <strfind+0x1b>
		if (*s == c)
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015c3:	74 0e                	je     8015d3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015c5:	ff 45 08             	incl   0x8(%ebp)
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	8a 00                	mov    (%eax),%al
  8015cd:	84 c0                	test   %al,%al
  8015cf:	75 ea                	jne    8015bb <strfind+0xe>
  8015d1:	eb 01                	jmp    8015d4 <strfind+0x27>
		if (*s == c)
			break;
  8015d3:	90                   	nop
	return (char *) s;
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015eb:	eb 0e                	jmp    8015fb <memset+0x22>
		*p++ = c;
  8015ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f0:	8d 50 01             	lea    0x1(%eax),%edx
  8015f3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015fb:	ff 4d f8             	decl   -0x8(%ebp)
  8015fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801602:	79 e9                	jns    8015ed <memset+0x14>
		*p++ = c;

	return v;
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80161b:	eb 16                	jmp    801633 <memcpy+0x2a>
		*d++ = *s++;
  80161d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801620:	8d 50 01             	lea    0x1(%eax),%edx
  801623:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801626:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801629:	8d 4a 01             	lea    0x1(%edx),%ecx
  80162c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80162f:	8a 12                	mov    (%edx),%dl
  801631:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
  801636:	8d 50 ff             	lea    -0x1(%eax),%edx
  801639:	89 55 10             	mov    %edx,0x10(%ebp)
  80163c:	85 c0                	test   %eax,%eax
  80163e:	75 dd                	jne    80161d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80164b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801657:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80165a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80165d:	73 50                	jae    8016af <memmove+0x6a>
  80165f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 d0                	add    %edx,%eax
  801667:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80166a:	76 43                	jbe    8016af <memmove+0x6a>
		s += n;
  80166c:	8b 45 10             	mov    0x10(%ebp),%eax
  80166f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801672:	8b 45 10             	mov    0x10(%ebp),%eax
  801675:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801678:	eb 10                	jmp    80168a <memmove+0x45>
			*--d = *--s;
  80167a:	ff 4d f8             	decl   -0x8(%ebp)
  80167d:	ff 4d fc             	decl   -0x4(%ebp)
  801680:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801683:	8a 10                	mov    (%eax),%dl
  801685:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801688:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801690:	89 55 10             	mov    %edx,0x10(%ebp)
  801693:	85 c0                	test   %eax,%eax
  801695:	75 e3                	jne    80167a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801697:	eb 23                	jmp    8016bc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801699:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169c:	8d 50 01             	lea    0x1(%eax),%edx
  80169f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016a8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016ab:	8a 12                	mov    (%edx),%dl
  8016ad:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	75 dd                	jne    801699 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016d3:	eb 2a                	jmp    8016ff <memcmp+0x3e>
		if (*s1 != *s2)
  8016d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d8:	8a 10                	mov    (%eax),%dl
  8016da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	38 c2                	cmp    %al,%dl
  8016e1:	74 16                	je     8016f9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f b6 d0             	movzbl %al,%edx
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f b6 c0             	movzbl %al,%eax
  8016f3:	29 c2                	sub    %eax,%edx
  8016f5:	89 d0                	mov    %edx,%eax
  8016f7:	eb 18                	jmp    801711 <memcmp+0x50>
		s1++, s2++;
  8016f9:	ff 45 fc             	incl   -0x4(%ebp)
  8016fc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801702:	8d 50 ff             	lea    -0x1(%eax),%edx
  801705:	89 55 10             	mov    %edx,0x10(%ebp)
  801708:	85 c0                	test   %eax,%eax
  80170a:	75 c9                	jne    8016d5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801719:	8b 55 08             	mov    0x8(%ebp),%edx
  80171c:	8b 45 10             	mov    0x10(%ebp),%eax
  80171f:	01 d0                	add    %edx,%eax
  801721:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801724:	eb 15                	jmp    80173b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8a 00                	mov    (%eax),%al
  80172b:	0f b6 d0             	movzbl %al,%edx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	0f b6 c0             	movzbl %al,%eax
  801734:	39 c2                	cmp    %eax,%edx
  801736:	74 0d                	je     801745 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801738:	ff 45 08             	incl   0x8(%ebp)
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801741:	72 e3                	jb     801726 <memfind+0x13>
  801743:	eb 01                	jmp    801746 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801745:	90                   	nop
	return (void *) s;
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801751:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801758:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80175f:	eb 03                	jmp    801764 <strtol+0x19>
		s++;
  801761:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 20                	cmp    $0x20,%al
  80176b:	74 f4                	je     801761 <strtol+0x16>
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8a 00                	mov    (%eax),%al
  801772:	3c 09                	cmp    $0x9,%al
  801774:	74 eb                	je     801761 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	8a 00                	mov    (%eax),%al
  80177b:	3c 2b                	cmp    $0x2b,%al
  80177d:	75 05                	jne    801784 <strtol+0x39>
		s++;
  80177f:	ff 45 08             	incl   0x8(%ebp)
  801782:	eb 13                	jmp    801797 <strtol+0x4c>
	else if (*s == '-')
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8a 00                	mov    (%eax),%al
  801789:	3c 2d                	cmp    $0x2d,%al
  80178b:	75 0a                	jne    801797 <strtol+0x4c>
		s++, neg = 1;
  80178d:	ff 45 08             	incl   0x8(%ebp)
  801790:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801797:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80179b:	74 06                	je     8017a3 <strtol+0x58>
  80179d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017a1:	75 20                	jne    8017c3 <strtol+0x78>
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	8a 00                	mov    (%eax),%al
  8017a8:	3c 30                	cmp    $0x30,%al
  8017aa:	75 17                	jne    8017c3 <strtol+0x78>
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	40                   	inc    %eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 78                	cmp    $0x78,%al
  8017b4:	75 0d                	jne    8017c3 <strtol+0x78>
		s += 2, base = 16;
  8017b6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017ba:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017c1:	eb 28                	jmp    8017eb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c7:	75 15                	jne    8017de <strtol+0x93>
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	3c 30                	cmp    $0x30,%al
  8017d0:	75 0c                	jne    8017de <strtol+0x93>
		s++, base = 8;
  8017d2:	ff 45 08             	incl   0x8(%ebp)
  8017d5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017dc:	eb 0d                	jmp    8017eb <strtol+0xa0>
	else if (base == 0)
  8017de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e2:	75 07                	jne    8017eb <strtol+0xa0>
		base = 10;
  8017e4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	3c 2f                	cmp    $0x2f,%al
  8017f2:	7e 19                	jle    80180d <strtol+0xc2>
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	8a 00                	mov    (%eax),%al
  8017f9:	3c 39                	cmp    $0x39,%al
  8017fb:	7f 10                	jg     80180d <strtol+0xc2>
			dig = *s - '0';
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8a 00                	mov    (%eax),%al
  801802:	0f be c0             	movsbl %al,%eax
  801805:	83 e8 30             	sub    $0x30,%eax
  801808:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80180b:	eb 42                	jmp    80184f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	3c 60                	cmp    $0x60,%al
  801814:	7e 19                	jle    80182f <strtol+0xe4>
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	8a 00                	mov    (%eax),%al
  80181b:	3c 7a                	cmp    $0x7a,%al
  80181d:	7f 10                	jg     80182f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	0f be c0             	movsbl %al,%eax
  801827:	83 e8 57             	sub    $0x57,%eax
  80182a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182d:	eb 20                	jmp    80184f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	3c 40                	cmp    $0x40,%al
  801836:	7e 39                	jle    801871 <strtol+0x126>
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8a 00                	mov    (%eax),%al
  80183d:	3c 5a                	cmp    $0x5a,%al
  80183f:	7f 30                	jg     801871 <strtol+0x126>
			dig = *s - 'A' + 10;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8a 00                	mov    (%eax),%al
  801846:	0f be c0             	movsbl %al,%eax
  801849:	83 e8 37             	sub    $0x37,%eax
  80184c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80184f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801852:	3b 45 10             	cmp    0x10(%ebp),%eax
  801855:	7d 19                	jge    801870 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801857:	ff 45 08             	incl   0x8(%ebp)
  80185a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801861:	89 c2                	mov    %eax,%edx
  801863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801866:	01 d0                	add    %edx,%eax
  801868:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80186b:	e9 7b ff ff ff       	jmp    8017eb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801870:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801871:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801875:	74 08                	je     80187f <strtol+0x134>
		*endptr = (char *) s;
  801877:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187a:	8b 55 08             	mov    0x8(%ebp),%edx
  80187d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80187f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801883:	74 07                	je     80188c <strtol+0x141>
  801885:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801888:	f7 d8                	neg    %eax
  80188a:	eb 03                	jmp    80188f <strtol+0x144>
  80188c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <ltostr>:

void
ltostr(long value, char *str)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801897:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80189e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018a9:	79 13                	jns    8018be <ltostr+0x2d>
	{
		neg = 1;
  8018ab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018b8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018bb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018c6:	99                   	cltd   
  8018c7:	f7 f9                	idiv   %ecx
  8018c9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018cf:	8d 50 01             	lea    0x1(%eax),%edx
  8018d2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018da:	01 d0                	add    %edx,%eax
  8018dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018df:	83 c2 30             	add    $0x30,%edx
  8018e2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018ec:	f7 e9                	imul   %ecx
  8018ee:	c1 fa 02             	sar    $0x2,%edx
  8018f1:	89 c8                	mov    %ecx,%eax
  8018f3:	c1 f8 1f             	sar    $0x1f,%eax
  8018f6:	29 c2                	sub    %eax,%edx
  8018f8:	89 d0                	mov    %edx,%eax
  8018fa:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801900:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801905:	f7 e9                	imul   %ecx
  801907:	c1 fa 02             	sar    $0x2,%edx
  80190a:	89 c8                	mov    %ecx,%eax
  80190c:	c1 f8 1f             	sar    $0x1f,%eax
  80190f:	29 c2                	sub    %eax,%edx
  801911:	89 d0                	mov    %edx,%eax
  801913:	c1 e0 02             	shl    $0x2,%eax
  801916:	01 d0                	add    %edx,%eax
  801918:	01 c0                	add    %eax,%eax
  80191a:	29 c1                	sub    %eax,%ecx
  80191c:	89 ca                	mov    %ecx,%edx
  80191e:	85 d2                	test   %edx,%edx
  801920:	75 9c                	jne    8018be <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801929:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192c:	48                   	dec    %eax
  80192d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801930:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801934:	74 3d                	je     801973 <ltostr+0xe2>
		start = 1 ;
  801936:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80193d:	eb 34                	jmp    801973 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80193f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801942:	8b 45 0c             	mov    0xc(%ebp),%eax
  801945:	01 d0                	add    %edx,%eax
  801947:	8a 00                	mov    (%eax),%al
  801949:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80194c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80194f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801952:	01 c2                	add    %eax,%edx
  801954:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195a:	01 c8                	add    %ecx,%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801960:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801963:	8b 45 0c             	mov    0xc(%ebp),%eax
  801966:	01 c2                	add    %eax,%edx
  801968:	8a 45 eb             	mov    -0x15(%ebp),%al
  80196b:	88 02                	mov    %al,(%edx)
		start++ ;
  80196d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801970:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801976:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801979:	7c c4                	jl     80193f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80197b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80197e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801981:	01 d0                	add    %edx,%eax
  801983:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801986:	90                   	nop
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80198f:	ff 75 08             	pushl  0x8(%ebp)
  801992:	e8 54 fa ff ff       	call   8013eb <strlen>
  801997:	83 c4 04             	add    $0x4,%esp
  80199a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	e8 46 fa ff ff       	call   8013eb <strlen>
  8019a5:	83 c4 04             	add    $0x4,%esp
  8019a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019b9:	eb 17                	jmp    8019d2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019be:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c1:	01 c2                	add    %eax,%edx
  8019c3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	01 c8                	add    %ecx,%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019cf:	ff 45 fc             	incl   -0x4(%ebp)
  8019d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019d8:	7c e1                	jl     8019bb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019e8:	eb 1f                	jmp    801a09 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ed:	8d 50 01             	lea    0x1(%eax),%edx
  8019f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019f3:	89 c2                	mov    %eax,%edx
  8019f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f8:	01 c2                	add    %eax,%edx
  8019fa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a00:	01 c8                	add    %ecx,%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a06:	ff 45 f8             	incl   -0x8(%ebp)
  801a09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a0f:	7c d9                	jl     8019ea <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a14:	8b 45 10             	mov    0x10(%ebp),%eax
  801a17:	01 d0                	add    %edx,%eax
  801a19:	c6 00 00             	movb   $0x0,(%eax)
}
  801a1c:	90                   	nop
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a22:	8b 45 14             	mov    0x14(%ebp),%eax
  801a25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2e:	8b 00                	mov    (%eax),%eax
  801a30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a37:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3a:	01 d0                	add    %edx,%eax
  801a3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a42:	eb 0c                	jmp    801a50 <strsplit+0x31>
			*string++ = 0;
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8d 50 01             	lea    0x1(%eax),%edx
  801a4a:	89 55 08             	mov    %edx,0x8(%ebp)
  801a4d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	74 18                	je     801a71 <strsplit+0x52>
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	8a 00                	mov    (%eax),%al
  801a5e:	0f be c0             	movsbl %al,%eax
  801a61:	50                   	push   %eax
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	e8 13 fb ff ff       	call   80157d <strchr>
  801a6a:	83 c4 08             	add    $0x8,%esp
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	75 d3                	jne    801a44 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8a 00                	mov    (%eax),%al
  801a76:	84 c0                	test   %al,%al
  801a78:	74 5a                	je     801ad4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7d:	8b 00                	mov    (%eax),%eax
  801a7f:	83 f8 0f             	cmp    $0xf,%eax
  801a82:	75 07                	jne    801a8b <strsplit+0x6c>
		{
			return 0;
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax
  801a89:	eb 66                	jmp    801af1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8e:	8b 00                	mov    (%eax),%eax
  801a90:	8d 48 01             	lea    0x1(%eax),%ecx
  801a93:	8b 55 14             	mov    0x14(%ebp),%edx
  801a96:	89 0a                	mov    %ecx,(%edx)
  801a98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa2:	01 c2                	add    %eax,%edx
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aa9:	eb 03                	jmp    801aae <strsplit+0x8f>
			string++;
  801aab:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	8a 00                	mov    (%eax),%al
  801ab3:	84 c0                	test   %al,%al
  801ab5:	74 8b                	je     801a42 <strsplit+0x23>
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	8a 00                	mov    (%eax),%al
  801abc:	0f be c0             	movsbl %al,%eax
  801abf:	50                   	push   %eax
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	e8 b5 fa ff ff       	call   80157d <strchr>
  801ac8:	83 c4 08             	add    $0x8,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	74 dc                	je     801aab <strsplit+0x8c>
			string++;
	}
  801acf:	e9 6e ff ff ff       	jmp    801a42 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ad4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad8:	8b 00                	mov    (%eax),%eax
  801ada:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae4:	01 d0                	add    %edx,%eax
  801ae6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801aec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801af9:	a1 04 50 80 00       	mov    0x805004,%eax
  801afe:	85 c0                	test   %eax,%eax
  801b00:	74 1f                	je     801b21 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b02:	e8 1d 00 00 00       	call   801b24 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b07:	83 ec 0c             	sub    $0xc,%esp
  801b0a:	68 90 46 80 00       	push   $0x804690
  801b0f:	e8 55 f2 ff ff       	call   800d69 <cprintf>
  801b14:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b17:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b1e:	00 00 00 
	}
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801b2a:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b31:	00 00 00 
  801b34:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b3b:	00 00 00 
  801b3e:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b45:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801b48:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b4f:	00 00 00 
  801b52:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b59:	00 00 00 
  801b5c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b63:	00 00 00 
	uint32 arr_size = 0;
  801b66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801b6d:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b77:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b7c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b81:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801b86:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b8d:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801b90:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b97:	a1 20 51 80 00       	mov    0x805120,%eax
  801b9c:	c1 e0 04             	shl    $0x4,%eax
  801b9f:	89 c2                	mov    %eax,%edx
  801ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba4:	01 d0                	add    %edx,%eax
  801ba6:	48                   	dec    %eax
  801ba7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801baa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bad:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb2:	f7 75 ec             	divl   -0x14(%ebp)
  801bb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bb8:	29 d0                	sub    %edx,%eax
  801bba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801bbd:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801bc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bcc:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bd1:	83 ec 04             	sub    $0x4,%esp
  801bd4:	6a 06                	push   $0x6
  801bd6:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd9:	50                   	push   %eax
  801bda:	e8 b2 05 00 00       	call   802191 <sys_allocate_chunk>
  801bdf:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801be2:	a1 20 51 80 00       	mov    0x805120,%eax
  801be7:	83 ec 0c             	sub    $0xc,%esp
  801bea:	50                   	push   %eax
  801beb:	e8 27 0c 00 00       	call   802817 <initialize_MemBlocksList>
  801bf0:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801bf3:	a1 48 51 80 00       	mov    0x805148,%eax
  801bf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801bfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bfe:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801c05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c08:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801c0f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c13:	75 14                	jne    801c29 <initialize_dyn_block_system+0x105>
  801c15:	83 ec 04             	sub    $0x4,%esp
  801c18:	68 b5 46 80 00       	push   $0x8046b5
  801c1d:	6a 33                	push   $0x33
  801c1f:	68 d3 46 80 00       	push   $0x8046d3
  801c24:	e8 8c ee ff ff       	call   800ab5 <_panic>
  801c29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c2c:	8b 00                	mov    (%eax),%eax
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	74 10                	je     801c42 <initialize_dyn_block_system+0x11e>
  801c32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c35:	8b 00                	mov    (%eax),%eax
  801c37:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c3a:	8b 52 04             	mov    0x4(%edx),%edx
  801c3d:	89 50 04             	mov    %edx,0x4(%eax)
  801c40:	eb 0b                	jmp    801c4d <initialize_dyn_block_system+0x129>
  801c42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c45:	8b 40 04             	mov    0x4(%eax),%eax
  801c48:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c50:	8b 40 04             	mov    0x4(%eax),%eax
  801c53:	85 c0                	test   %eax,%eax
  801c55:	74 0f                	je     801c66 <initialize_dyn_block_system+0x142>
  801c57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c5a:	8b 40 04             	mov    0x4(%eax),%eax
  801c5d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c60:	8b 12                	mov    (%edx),%edx
  801c62:	89 10                	mov    %edx,(%eax)
  801c64:	eb 0a                	jmp    801c70 <initialize_dyn_block_system+0x14c>
  801c66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c69:	8b 00                	mov    (%eax),%eax
  801c6b:	a3 48 51 80 00       	mov    %eax,0x805148
  801c70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c83:	a1 54 51 80 00       	mov    0x805154,%eax
  801c88:	48                   	dec    %eax
  801c89:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801c8e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c92:	75 14                	jne    801ca8 <initialize_dyn_block_system+0x184>
  801c94:	83 ec 04             	sub    $0x4,%esp
  801c97:	68 e0 46 80 00       	push   $0x8046e0
  801c9c:	6a 34                	push   $0x34
  801c9e:	68 d3 46 80 00       	push   $0x8046d3
  801ca3:	e8 0d ee ff ff       	call   800ab5 <_panic>
  801ca8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801cae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cb1:	89 10                	mov    %edx,(%eax)
  801cb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cb6:	8b 00                	mov    (%eax),%eax
  801cb8:	85 c0                	test   %eax,%eax
  801cba:	74 0d                	je     801cc9 <initialize_dyn_block_system+0x1a5>
  801cbc:	a1 38 51 80 00       	mov    0x805138,%eax
  801cc1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cc4:	89 50 04             	mov    %edx,0x4(%eax)
  801cc7:	eb 08                	jmp    801cd1 <initialize_dyn_block_system+0x1ad>
  801cc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ccc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801cd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cd4:	a3 38 51 80 00       	mov    %eax,0x805138
  801cd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cdc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ce3:	a1 44 51 80 00       	mov    0x805144,%eax
  801ce8:	40                   	inc    %eax
  801ce9:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801cee:	90                   	nop
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cf7:	e8 f7 fd ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cfc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d00:	75 07                	jne    801d09 <malloc+0x18>
  801d02:	b8 00 00 00 00       	mov    $0x0,%eax
  801d07:	eb 61                	jmp    801d6a <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801d09:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d10:	8b 55 08             	mov    0x8(%ebp),%edx
  801d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d16:	01 d0                	add    %edx,%eax
  801d18:	48                   	dec    %eax
  801d19:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d24:	f7 75 f0             	divl   -0x10(%ebp)
  801d27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2a:	29 d0                	sub    %edx,%eax
  801d2c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d2f:	e8 2b 08 00 00       	call   80255f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d34:	85 c0                	test   %eax,%eax
  801d36:	74 11                	je     801d49 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801d38:	83 ec 0c             	sub    $0xc,%esp
  801d3b:	ff 75 e8             	pushl  -0x18(%ebp)
  801d3e:	e8 96 0e 00 00       	call   802bd9 <alloc_block_FF>
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801d49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d4d:	74 16                	je     801d65 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801d4f:	83 ec 0c             	sub    $0xc,%esp
  801d52:	ff 75 f4             	pushl  -0xc(%ebp)
  801d55:	e8 f2 0b 00 00       	call   80294c <insert_sorted_allocList>
  801d5a:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d60:	8b 40 08             	mov    0x8(%eax),%eax
  801d63:	eb 05                	jmp    801d6a <malloc+0x79>
	}

    return NULL;
  801d65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	83 ec 08             	sub    $0x8,%esp
  801d78:	50                   	push   %eax
  801d79:	68 40 50 80 00       	push   $0x805040
  801d7e:	e8 71 0b 00 00       	call   8028f4 <find_block>
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801d89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d8d:	0f 84 a6 00 00 00    	je     801e39 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d96:	8b 50 0c             	mov    0xc(%eax),%edx
  801d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9c:	8b 40 08             	mov    0x8(%eax),%eax
  801d9f:	83 ec 08             	sub    $0x8,%esp
  801da2:	52                   	push   %edx
  801da3:	50                   	push   %eax
  801da4:	e8 b0 03 00 00       	call   802159 <sys_free_user_mem>
  801da9:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801dac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db0:	75 14                	jne    801dc6 <free+0x5a>
  801db2:	83 ec 04             	sub    $0x4,%esp
  801db5:	68 b5 46 80 00       	push   $0x8046b5
  801dba:	6a 74                	push   $0x74
  801dbc:	68 d3 46 80 00       	push   $0x8046d3
  801dc1:	e8 ef ec ff ff       	call   800ab5 <_panic>
  801dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc9:	8b 00                	mov    (%eax),%eax
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	74 10                	je     801ddf <free+0x73>
  801dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd2:	8b 00                	mov    (%eax),%eax
  801dd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd7:	8b 52 04             	mov    0x4(%edx),%edx
  801dda:	89 50 04             	mov    %edx,0x4(%eax)
  801ddd:	eb 0b                	jmp    801dea <free+0x7e>
  801ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de2:	8b 40 04             	mov    0x4(%eax),%eax
  801de5:	a3 44 50 80 00       	mov    %eax,0x805044
  801dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ded:	8b 40 04             	mov    0x4(%eax),%eax
  801df0:	85 c0                	test   %eax,%eax
  801df2:	74 0f                	je     801e03 <free+0x97>
  801df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df7:	8b 40 04             	mov    0x4(%eax),%eax
  801dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dfd:	8b 12                	mov    (%edx),%edx
  801dff:	89 10                	mov    %edx,(%eax)
  801e01:	eb 0a                	jmp    801e0d <free+0xa1>
  801e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e06:	8b 00                	mov    (%eax),%eax
  801e08:	a3 40 50 80 00       	mov    %eax,0x805040
  801e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e20:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e25:	48                   	dec    %eax
  801e26:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801e2b:	83 ec 0c             	sub    $0xc,%esp
  801e2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e31:	e8 4e 17 00 00       	call   803584 <insert_sorted_with_merge_freeList>
  801e36:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801e39:	90                   	nop
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 38             	sub    $0x38,%esp
  801e42:	8b 45 10             	mov    0x10(%ebp),%eax
  801e45:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e48:	e8 a6 fc ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e51:	75 0a                	jne    801e5d <smalloc+0x21>
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
  801e58:	e9 8b 00 00 00       	jmp    801ee8 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801e5d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6a:	01 d0                	add    %edx,%eax
  801e6c:	48                   	dec    %eax
  801e6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e73:	ba 00 00 00 00       	mov    $0x0,%edx
  801e78:	f7 75 f0             	divl   -0x10(%ebp)
  801e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e7e:	29 d0                	sub    %edx,%eax
  801e80:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801e83:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801e8a:	e8 d0 06 00 00       	call   80255f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e8f:	85 c0                	test   %eax,%eax
  801e91:	74 11                	je     801ea4 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801e93:	83 ec 0c             	sub    $0xc,%esp
  801e96:	ff 75 e8             	pushl  -0x18(%ebp)
  801e99:	e8 3b 0d 00 00       	call   802bd9 <alloc_block_FF>
  801e9e:	83 c4 10             	add    $0x10,%esp
  801ea1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801ea4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea8:	74 39                	je     801ee3 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ead:	8b 40 08             	mov    0x8(%eax),%eax
  801eb0:	89 c2                	mov    %eax,%edx
  801eb2:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801eb6:	52                   	push   %edx
  801eb7:	50                   	push   %eax
  801eb8:	ff 75 0c             	pushl  0xc(%ebp)
  801ebb:	ff 75 08             	pushl  0x8(%ebp)
  801ebe:	e8 21 04 00 00       	call   8022e4 <sys_createSharedObject>
  801ec3:	83 c4 10             	add    $0x10,%esp
  801ec6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801ec9:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801ecd:	74 14                	je     801ee3 <smalloc+0xa7>
  801ecf:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801ed3:	74 0e                	je     801ee3 <smalloc+0xa7>
  801ed5:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801ed9:	74 08                	je     801ee3 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ede:	8b 40 08             	mov    0x8(%eax),%eax
  801ee1:	eb 05                	jmp    801ee8 <smalloc+0xac>
	}
	return NULL;
  801ee3:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ef0:	e8 fe fb ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ef5:	83 ec 08             	sub    $0x8,%esp
  801ef8:	ff 75 0c             	pushl  0xc(%ebp)
  801efb:	ff 75 08             	pushl  0x8(%ebp)
  801efe:	e8 0b 04 00 00       	call   80230e <sys_getSizeOfSharedObject>
  801f03:	83 c4 10             	add    $0x10,%esp
  801f06:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801f09:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801f0d:	74 76                	je     801f85 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801f0f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1c:	01 d0                	add    %edx,%eax
  801f1e:	48                   	dec    %eax
  801f1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f25:	ba 00 00 00 00       	mov    $0x0,%edx
  801f2a:	f7 75 ec             	divl   -0x14(%ebp)
  801f2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f30:	29 d0                	sub    %edx,%eax
  801f32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801f35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801f3c:	e8 1e 06 00 00       	call   80255f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f41:	85 c0                	test   %eax,%eax
  801f43:	74 11                	je     801f56 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801f45:	83 ec 0c             	sub    $0xc,%esp
  801f48:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f4b:	e8 89 0c 00 00       	call   802bd9 <alloc_block_FF>
  801f50:	83 c4 10             	add    $0x10,%esp
  801f53:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801f56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f5a:	74 29                	je     801f85 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5f:	8b 40 08             	mov    0x8(%eax),%eax
  801f62:	83 ec 04             	sub    $0x4,%esp
  801f65:	50                   	push   %eax
  801f66:	ff 75 0c             	pushl  0xc(%ebp)
  801f69:	ff 75 08             	pushl  0x8(%ebp)
  801f6c:	e8 ba 03 00 00       	call   80232b <sys_getSharedObject>
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801f77:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801f7b:	74 08                	je     801f85 <sget+0x9b>
				return (void *)mem_block->sva;
  801f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f80:	8b 40 08             	mov    0x8(%eax),%eax
  801f83:	eb 05                	jmp    801f8a <sget+0xa0>
		}
	}
	return NULL;
  801f85:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f92:	e8 5c fb ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f97:	83 ec 04             	sub    $0x4,%esp
  801f9a:	68 04 47 80 00       	push   $0x804704
  801f9f:	68 f7 00 00 00       	push   $0xf7
  801fa4:	68 d3 46 80 00       	push   $0x8046d3
  801fa9:	e8 07 eb ff ff       	call   800ab5 <_panic>

00801fae <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fb4:	83 ec 04             	sub    $0x4,%esp
  801fb7:	68 2c 47 80 00       	push   $0x80472c
  801fbc:	68 0c 01 00 00       	push   $0x10c
  801fc1:	68 d3 46 80 00       	push   $0x8046d3
  801fc6:	e8 ea ea ff ff       	call   800ab5 <_panic>

00801fcb <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fd1:	83 ec 04             	sub    $0x4,%esp
  801fd4:	68 50 47 80 00       	push   $0x804750
  801fd9:	68 44 01 00 00       	push   $0x144
  801fde:	68 d3 46 80 00       	push   $0x8046d3
  801fe3:	e8 cd ea ff ff       	call   800ab5 <_panic>

00801fe8 <shrink>:

}
void shrink(uint32 newSize)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
  801feb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fee:	83 ec 04             	sub    $0x4,%esp
  801ff1:	68 50 47 80 00       	push   $0x804750
  801ff6:	68 49 01 00 00       	push   $0x149
  801ffb:	68 d3 46 80 00       	push   $0x8046d3
  802000:	e8 b0 ea ff ff       	call   800ab5 <_panic>

00802005 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80200b:	83 ec 04             	sub    $0x4,%esp
  80200e:	68 50 47 80 00       	push   $0x804750
  802013:	68 4e 01 00 00       	push   $0x14e
  802018:	68 d3 46 80 00       	push   $0x8046d3
  80201d:	e8 93 ea ff ff       	call   800ab5 <_panic>

00802022 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	57                   	push   %edi
  802026:	56                   	push   %esi
  802027:	53                   	push   %ebx
  802028:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802031:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802034:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802037:	8b 7d 18             	mov    0x18(%ebp),%edi
  80203a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80203d:	cd 30                	int    $0x30
  80203f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802042:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802045:	83 c4 10             	add    $0x10,%esp
  802048:	5b                   	pop    %ebx
  802049:	5e                   	pop    %esi
  80204a:	5f                   	pop    %edi
  80204b:	5d                   	pop    %ebp
  80204c:	c3                   	ret    

0080204d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 04             	sub    $0x4,%esp
  802053:	8b 45 10             	mov    0x10(%ebp),%eax
  802056:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802059:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	52                   	push   %edx
  802065:	ff 75 0c             	pushl  0xc(%ebp)
  802068:	50                   	push   %eax
  802069:	6a 00                	push   $0x0
  80206b:	e8 b2 ff ff ff       	call   802022 <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
}
  802073:	90                   	nop
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <sys_cgetc>:

int
sys_cgetc(void)
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 01                	push   $0x1
  802085:	e8 98 ff ff ff       	call   802022 <syscall>
  80208a:	83 c4 18             	add    $0x18,%esp
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802092:	8b 55 0c             	mov    0xc(%ebp),%edx
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	52                   	push   %edx
  80209f:	50                   	push   %eax
  8020a0:	6a 05                	push   $0x5
  8020a2:	e8 7b ff ff ff       	call   802022 <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
}
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
  8020af:	56                   	push   %esi
  8020b0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020b1:	8b 75 18             	mov    0x18(%ebp),%esi
  8020b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	56                   	push   %esi
  8020c1:	53                   	push   %ebx
  8020c2:	51                   	push   %ecx
  8020c3:	52                   	push   %edx
  8020c4:	50                   	push   %eax
  8020c5:	6a 06                	push   $0x6
  8020c7:	e8 56 ff ff ff       	call   802022 <syscall>
  8020cc:	83 c4 18             	add    $0x18,%esp
}
  8020cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d2:	5b                   	pop    %ebx
  8020d3:	5e                   	pop    %esi
  8020d4:	5d                   	pop    %ebp
  8020d5:	c3                   	ret    

008020d6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	52                   	push   %edx
  8020e6:	50                   	push   %eax
  8020e7:	6a 07                	push   $0x7
  8020e9:	e8 34 ff ff ff       	call   802022 <syscall>
  8020ee:	83 c4 18             	add    $0x18,%esp
}
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	ff 75 0c             	pushl  0xc(%ebp)
  8020ff:	ff 75 08             	pushl  0x8(%ebp)
  802102:	6a 08                	push   $0x8
  802104:	e8 19 ff ff ff       	call   802022 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 09                	push   $0x9
  80211d:	e8 00 ff ff ff       	call   802022 <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 0a                	push   $0xa
  802136:	e8 e7 fe ff ff       	call   802022 <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 0b                	push   $0xb
  80214f:	e8 ce fe ff ff       	call   802022 <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	ff 75 0c             	pushl  0xc(%ebp)
  802165:	ff 75 08             	pushl  0x8(%ebp)
  802168:	6a 0f                	push   $0xf
  80216a:	e8 b3 fe ff ff       	call   802022 <syscall>
  80216f:	83 c4 18             	add    $0x18,%esp
	return;
  802172:	90                   	nop
}
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	ff 75 0c             	pushl  0xc(%ebp)
  802181:	ff 75 08             	pushl  0x8(%ebp)
  802184:	6a 10                	push   $0x10
  802186:	e8 97 fe ff ff       	call   802022 <syscall>
  80218b:	83 c4 18             	add    $0x18,%esp
	return ;
  80218e:	90                   	nop
}
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	ff 75 10             	pushl  0x10(%ebp)
  80219b:	ff 75 0c             	pushl  0xc(%ebp)
  80219e:	ff 75 08             	pushl  0x8(%ebp)
  8021a1:	6a 11                	push   $0x11
  8021a3:	e8 7a fe ff ff       	call   802022 <syscall>
  8021a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ab:	90                   	nop
}
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    

008021ae <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 0c                	push   $0xc
  8021bd:	e8 60 fe ff ff       	call   802022 <syscall>
  8021c2:	83 c4 18             	add    $0x18,%esp
}
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    

008021c7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	ff 75 08             	pushl  0x8(%ebp)
  8021d5:	6a 0d                	push   $0xd
  8021d7:	e8 46 fe ff ff       	call   802022 <syscall>
  8021dc:	83 c4 18             	add    $0x18,%esp
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 0e                	push   $0xe
  8021f0:	e8 2d fe ff ff       	call   802022 <syscall>
  8021f5:	83 c4 18             	add    $0x18,%esp
}
  8021f8:	90                   	nop
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 13                	push   $0x13
  80220a:	e8 13 fe ff ff       	call   802022 <syscall>
  80220f:	83 c4 18             	add    $0x18,%esp
}
  802212:	90                   	nop
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 14                	push   $0x14
  802224:	e8 f9 fd ff ff       	call   802022 <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
}
  80222c:	90                   	nop
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <sys_cputc>:


void
sys_cputc(const char c)
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
  802232:	83 ec 04             	sub    $0x4,%esp
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80223b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	50                   	push   %eax
  802248:	6a 15                	push   $0x15
  80224a:	e8 d3 fd ff ff       	call   802022 <syscall>
  80224f:	83 c4 18             	add    $0x18,%esp
}
  802252:	90                   	nop
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 16                	push   $0x16
  802264:	e8 b9 fd ff ff       	call   802022 <syscall>
  802269:	83 c4 18             	add    $0x18,%esp
}
  80226c:	90                   	nop
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	ff 75 0c             	pushl  0xc(%ebp)
  80227e:	50                   	push   %eax
  80227f:	6a 17                	push   $0x17
  802281:	e8 9c fd ff ff       	call   802022 <syscall>
  802286:	83 c4 18             	add    $0x18,%esp
}
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80228e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	52                   	push   %edx
  80229b:	50                   	push   %eax
  80229c:	6a 1a                	push   $0x1a
  80229e:	e8 7f fd ff ff       	call   802022 <syscall>
  8022a3:	83 c4 18             	add    $0x18,%esp
}
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	52                   	push   %edx
  8022b8:	50                   	push   %eax
  8022b9:	6a 18                	push   $0x18
  8022bb:	e8 62 fd ff ff       	call   802022 <syscall>
  8022c0:	83 c4 18             	add    $0x18,%esp
}
  8022c3:	90                   	nop
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	52                   	push   %edx
  8022d6:	50                   	push   %eax
  8022d7:	6a 19                	push   $0x19
  8022d9:	e8 44 fd ff ff       	call   802022 <syscall>
  8022de:	83 c4 18             	add    $0x18,%esp
}
  8022e1:	90                   	nop
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	83 ec 04             	sub    $0x4,%esp
  8022ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022f0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022f3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	6a 00                	push   $0x0
  8022fc:	51                   	push   %ecx
  8022fd:	52                   	push   %edx
  8022fe:	ff 75 0c             	pushl  0xc(%ebp)
  802301:	50                   	push   %eax
  802302:	6a 1b                	push   $0x1b
  802304:	e8 19 fd ff ff       	call   802022 <syscall>
  802309:	83 c4 18             	add    $0x18,%esp
}
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802311:	8b 55 0c             	mov    0xc(%ebp),%edx
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	52                   	push   %edx
  80231e:	50                   	push   %eax
  80231f:	6a 1c                	push   $0x1c
  802321:	e8 fc fc ff ff       	call   802022 <syscall>
  802326:	83 c4 18             	add    $0x18,%esp
}
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80232e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802331:	8b 55 0c             	mov    0xc(%ebp),%edx
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	51                   	push   %ecx
  80233c:	52                   	push   %edx
  80233d:	50                   	push   %eax
  80233e:	6a 1d                	push   $0x1d
  802340:	e8 dd fc ff ff       	call   802022 <syscall>
  802345:	83 c4 18             	add    $0x18,%esp
}
  802348:	c9                   	leave  
  802349:	c3                   	ret    

0080234a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80234d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	52                   	push   %edx
  80235a:	50                   	push   %eax
  80235b:	6a 1e                	push   $0x1e
  80235d:	e8 c0 fc ff ff       	call   802022 <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 1f                	push   $0x1f
  802376:	e8 a7 fc ff ff       	call   802022 <syscall>
  80237b:	83 c4 18             	add    $0x18,%esp
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	6a 00                	push   $0x0
  802388:	ff 75 14             	pushl  0x14(%ebp)
  80238b:	ff 75 10             	pushl  0x10(%ebp)
  80238e:	ff 75 0c             	pushl  0xc(%ebp)
  802391:	50                   	push   %eax
  802392:	6a 20                	push   $0x20
  802394:	e8 89 fc ff ff       	call   802022 <syscall>
  802399:	83 c4 18             	add    $0x18,%esp
}
  80239c:	c9                   	leave  
  80239d:	c3                   	ret    

0080239e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	50                   	push   %eax
  8023ad:	6a 21                	push   $0x21
  8023af:	e8 6e fc ff ff       	call   802022 <syscall>
  8023b4:	83 c4 18             	add    $0x18,%esp
}
  8023b7:	90                   	nop
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	50                   	push   %eax
  8023c9:	6a 22                	push   $0x22
  8023cb:	e8 52 fc ff ff       	call   802022 <syscall>
  8023d0:	83 c4 18             	add    $0x18,%esp
}
  8023d3:	c9                   	leave  
  8023d4:	c3                   	ret    

008023d5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023d5:	55                   	push   %ebp
  8023d6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 02                	push   $0x2
  8023e4:	e8 39 fc ff ff       	call   802022 <syscall>
  8023e9:	83 c4 18             	add    $0x18,%esp
}
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 03                	push   $0x3
  8023fd:	e8 20 fc ff ff       	call   802022 <syscall>
  802402:	83 c4 18             	add    $0x18,%esp
}
  802405:	c9                   	leave  
  802406:	c3                   	ret    

00802407 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 04                	push   $0x4
  802416:	e8 07 fc ff ff       	call   802022 <syscall>
  80241b:	83 c4 18             	add    $0x18,%esp
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <sys_exit_env>:


void sys_exit_env(void)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 23                	push   $0x23
  80242f:	e8 ee fb ff ff       	call   802022 <syscall>
  802434:	83 c4 18             	add    $0x18,%esp
}
  802437:	90                   	nop
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
  80243d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802440:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802443:	8d 50 04             	lea    0x4(%eax),%edx
  802446:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	52                   	push   %edx
  802450:	50                   	push   %eax
  802451:	6a 24                	push   $0x24
  802453:	e8 ca fb ff ff       	call   802022 <syscall>
  802458:	83 c4 18             	add    $0x18,%esp
	return result;
  80245b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80245e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802461:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802464:	89 01                	mov    %eax,(%ecx)
  802466:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	c9                   	leave  
  80246d:	c2 04 00             	ret    $0x4

00802470 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	ff 75 10             	pushl  0x10(%ebp)
  80247a:	ff 75 0c             	pushl  0xc(%ebp)
  80247d:	ff 75 08             	pushl  0x8(%ebp)
  802480:	6a 12                	push   $0x12
  802482:	e8 9b fb ff ff       	call   802022 <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
	return ;
  80248a:	90                   	nop
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <sys_rcr2>:
uint32 sys_rcr2()
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 25                	push   $0x25
  80249c:	e8 81 fb ff ff       	call   802022 <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
}
  8024a4:	c9                   	leave  
  8024a5:	c3                   	ret    

008024a6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
  8024a9:	83 ec 04             	sub    $0x4,%esp
  8024ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8024af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024b2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	50                   	push   %eax
  8024bf:	6a 26                	push   $0x26
  8024c1:	e8 5c fb ff ff       	call   802022 <syscall>
  8024c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c9:	90                   	nop
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <rsttst>:
void rsttst()
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 28                	push   $0x28
  8024db:	e8 42 fb ff ff       	call   802022 <syscall>
  8024e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e3:	90                   	nop
}
  8024e4:	c9                   	leave  
  8024e5:	c3                   	ret    

008024e6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
  8024e9:	83 ec 04             	sub    $0x4,%esp
  8024ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024f2:	8b 55 18             	mov    0x18(%ebp),%edx
  8024f5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024f9:	52                   	push   %edx
  8024fa:	50                   	push   %eax
  8024fb:	ff 75 10             	pushl  0x10(%ebp)
  8024fe:	ff 75 0c             	pushl  0xc(%ebp)
  802501:	ff 75 08             	pushl  0x8(%ebp)
  802504:	6a 27                	push   $0x27
  802506:	e8 17 fb ff ff       	call   802022 <syscall>
  80250b:	83 c4 18             	add    $0x18,%esp
	return ;
  80250e:	90                   	nop
}
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <chktst>:
void chktst(uint32 n)
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	ff 75 08             	pushl  0x8(%ebp)
  80251f:	6a 29                	push   $0x29
  802521:	e8 fc fa ff ff       	call   802022 <syscall>
  802526:	83 c4 18             	add    $0x18,%esp
	return ;
  802529:	90                   	nop
}
  80252a:	c9                   	leave  
  80252b:	c3                   	ret    

0080252c <inctst>:

void inctst()
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 2a                	push   $0x2a
  80253b:	e8 e2 fa ff ff       	call   802022 <syscall>
  802540:	83 c4 18             	add    $0x18,%esp
	return ;
  802543:	90                   	nop
}
  802544:	c9                   	leave  
  802545:	c3                   	ret    

00802546 <gettst>:
uint32 gettst()
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 2b                	push   $0x2b
  802555:	e8 c8 fa ff ff       	call   802022 <syscall>
  80255a:	83 c4 18             	add    $0x18,%esp
}
  80255d:	c9                   	leave  
  80255e:	c3                   	ret    

0080255f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80255f:	55                   	push   %ebp
  802560:	89 e5                	mov    %esp,%ebp
  802562:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 00                	push   $0x0
  80256f:	6a 2c                	push   $0x2c
  802571:	e8 ac fa ff ff       	call   802022 <syscall>
  802576:	83 c4 18             	add    $0x18,%esp
  802579:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80257c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802580:	75 07                	jne    802589 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802582:	b8 01 00 00 00       	mov    $0x1,%eax
  802587:	eb 05                	jmp    80258e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802589:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80258e:	c9                   	leave  
  80258f:	c3                   	ret    

00802590 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 2c                	push   $0x2c
  8025a2:	e8 7b fa ff ff       	call   802022 <syscall>
  8025a7:	83 c4 18             	add    $0x18,%esp
  8025aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025ad:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025b1:	75 07                	jne    8025ba <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b8:	eb 05                	jmp    8025bf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    

008025c1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025c1:	55                   	push   %ebp
  8025c2:	89 e5                	mov    %esp,%ebp
  8025c4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 2c                	push   $0x2c
  8025d3:	e8 4a fa ff ff       	call   802022 <syscall>
  8025d8:	83 c4 18             	add    $0x18,%esp
  8025db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025de:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025e2:	75 07                	jne    8025eb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e9:	eb 05                	jmp    8025f0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f0:	c9                   	leave  
  8025f1:	c3                   	ret    

008025f2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025f2:	55                   	push   %ebp
  8025f3:	89 e5                	mov    %esp,%ebp
  8025f5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	6a 2c                	push   $0x2c
  802604:	e8 19 fa ff ff       	call   802022 <syscall>
  802609:	83 c4 18             	add    $0x18,%esp
  80260c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80260f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802613:	75 07                	jne    80261c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802615:	b8 01 00 00 00       	mov    $0x1,%eax
  80261a:	eb 05                	jmp    802621 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80261c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802621:	c9                   	leave  
  802622:	c3                   	ret    

00802623 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802623:	55                   	push   %ebp
  802624:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	ff 75 08             	pushl  0x8(%ebp)
  802631:	6a 2d                	push   $0x2d
  802633:	e8 ea f9 ff ff       	call   802022 <syscall>
  802638:	83 c4 18             	add    $0x18,%esp
	return ;
  80263b:	90                   	nop
}
  80263c:	c9                   	leave  
  80263d:	c3                   	ret    

0080263e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80263e:	55                   	push   %ebp
  80263f:	89 e5                	mov    %esp,%ebp
  802641:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802642:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802645:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	6a 00                	push   $0x0
  802650:	53                   	push   %ebx
  802651:	51                   	push   %ecx
  802652:	52                   	push   %edx
  802653:	50                   	push   %eax
  802654:	6a 2e                	push   $0x2e
  802656:	e8 c7 f9 ff ff       	call   802022 <syscall>
  80265b:	83 c4 18             	add    $0x18,%esp
}
  80265e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802661:	c9                   	leave  
  802662:	c3                   	ret    

00802663 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802666:	8b 55 0c             	mov    0xc(%ebp),%edx
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	6a 00                	push   $0x0
  80266e:	6a 00                	push   $0x0
  802670:	6a 00                	push   $0x0
  802672:	52                   	push   %edx
  802673:	50                   	push   %eax
  802674:	6a 2f                	push   $0x2f
  802676:	e8 a7 f9 ff ff       	call   802022 <syscall>
  80267b:	83 c4 18             	add    $0x18,%esp
}
  80267e:	c9                   	leave  
  80267f:	c3                   	ret    

00802680 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802686:	83 ec 0c             	sub    $0xc,%esp
  802689:	68 60 47 80 00       	push   $0x804760
  80268e:	e8 d6 e6 ff ff       	call   800d69 <cprintf>
  802693:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802696:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80269d:	83 ec 0c             	sub    $0xc,%esp
  8026a0:	68 8c 47 80 00       	push   $0x80478c
  8026a5:	e8 bf e6 ff ff       	call   800d69 <cprintf>
  8026aa:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026ad:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026b1:	a1 38 51 80 00       	mov    0x805138,%eax
  8026b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b9:	eb 56                	jmp    802711 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026bf:	74 1c                	je     8026dd <print_mem_block_lists+0x5d>
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	8b 50 08             	mov    0x8(%eax),%edx
  8026c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ca:	8b 48 08             	mov    0x8(%eax),%ecx
  8026cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d3:	01 c8                	add    %ecx,%eax
  8026d5:	39 c2                	cmp    %eax,%edx
  8026d7:	73 04                	jae    8026dd <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026d9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 50 08             	mov    0x8(%eax),%edx
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e9:	01 c2                	add    %eax,%edx
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 40 08             	mov    0x8(%eax),%eax
  8026f1:	83 ec 04             	sub    $0x4,%esp
  8026f4:	52                   	push   %edx
  8026f5:	50                   	push   %eax
  8026f6:	68 a1 47 80 00       	push   $0x8047a1
  8026fb:	e8 69 e6 ff ff       	call   800d69 <cprintf>
  802700:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802709:	a1 40 51 80 00       	mov    0x805140,%eax
  80270e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802711:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802715:	74 07                	je     80271e <print_mem_block_lists+0x9e>
  802717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271a:	8b 00                	mov    (%eax),%eax
  80271c:	eb 05                	jmp    802723 <print_mem_block_lists+0xa3>
  80271e:	b8 00 00 00 00       	mov    $0x0,%eax
  802723:	a3 40 51 80 00       	mov    %eax,0x805140
  802728:	a1 40 51 80 00       	mov    0x805140,%eax
  80272d:	85 c0                	test   %eax,%eax
  80272f:	75 8a                	jne    8026bb <print_mem_block_lists+0x3b>
  802731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802735:	75 84                	jne    8026bb <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802737:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80273b:	75 10                	jne    80274d <print_mem_block_lists+0xcd>
  80273d:	83 ec 0c             	sub    $0xc,%esp
  802740:	68 b0 47 80 00       	push   $0x8047b0
  802745:	e8 1f e6 ff ff       	call   800d69 <cprintf>
  80274a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80274d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802754:	83 ec 0c             	sub    $0xc,%esp
  802757:	68 d4 47 80 00       	push   $0x8047d4
  80275c:	e8 08 e6 ff ff       	call   800d69 <cprintf>
  802761:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802764:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802768:	a1 40 50 80 00       	mov    0x805040,%eax
  80276d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802770:	eb 56                	jmp    8027c8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802772:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802776:	74 1c                	je     802794 <print_mem_block_lists+0x114>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 50 08             	mov    0x8(%eax),%edx
  80277e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802781:	8b 48 08             	mov    0x8(%eax),%ecx
  802784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802787:	8b 40 0c             	mov    0xc(%eax),%eax
  80278a:	01 c8                	add    %ecx,%eax
  80278c:	39 c2                	cmp    %eax,%edx
  80278e:	73 04                	jae    802794 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802790:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 50 08             	mov    0x8(%eax),%edx
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a0:	01 c2                	add    %eax,%edx
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 40 08             	mov    0x8(%eax),%eax
  8027a8:	83 ec 04             	sub    $0x4,%esp
  8027ab:	52                   	push   %edx
  8027ac:	50                   	push   %eax
  8027ad:	68 a1 47 80 00       	push   $0x8047a1
  8027b2:	e8 b2 e5 ff ff       	call   800d69 <cprintf>
  8027b7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027c0:	a1 48 50 80 00       	mov    0x805048,%eax
  8027c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027cc:	74 07                	je     8027d5 <print_mem_block_lists+0x155>
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	8b 00                	mov    (%eax),%eax
  8027d3:	eb 05                	jmp    8027da <print_mem_block_lists+0x15a>
  8027d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027da:	a3 48 50 80 00       	mov    %eax,0x805048
  8027df:	a1 48 50 80 00       	mov    0x805048,%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	75 8a                	jne    802772 <print_mem_block_lists+0xf2>
  8027e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ec:	75 84                	jne    802772 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8027ee:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027f2:	75 10                	jne    802804 <print_mem_block_lists+0x184>
  8027f4:	83 ec 0c             	sub    $0xc,%esp
  8027f7:	68 ec 47 80 00       	push   $0x8047ec
  8027fc:	e8 68 e5 ff ff       	call   800d69 <cprintf>
  802801:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802804:	83 ec 0c             	sub    $0xc,%esp
  802807:	68 60 47 80 00       	push   $0x804760
  80280c:	e8 58 e5 ff ff       	call   800d69 <cprintf>
  802811:	83 c4 10             	add    $0x10,%esp

}
  802814:	90                   	nop
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
  80281a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80281d:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802824:	00 00 00 
  802827:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80282e:	00 00 00 
  802831:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802838:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80283b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802842:	e9 9e 00 00 00       	jmp    8028e5 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802847:	a1 50 50 80 00       	mov    0x805050,%eax
  80284c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284f:	c1 e2 04             	shl    $0x4,%edx
  802852:	01 d0                	add    %edx,%eax
  802854:	85 c0                	test   %eax,%eax
  802856:	75 14                	jne    80286c <initialize_MemBlocksList+0x55>
  802858:	83 ec 04             	sub    $0x4,%esp
  80285b:	68 14 48 80 00       	push   $0x804814
  802860:	6a 46                	push   $0x46
  802862:	68 37 48 80 00       	push   $0x804837
  802867:	e8 49 e2 ff ff       	call   800ab5 <_panic>
  80286c:	a1 50 50 80 00       	mov    0x805050,%eax
  802871:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802874:	c1 e2 04             	shl    $0x4,%edx
  802877:	01 d0                	add    %edx,%eax
  802879:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80287f:	89 10                	mov    %edx,(%eax)
  802881:	8b 00                	mov    (%eax),%eax
  802883:	85 c0                	test   %eax,%eax
  802885:	74 18                	je     80289f <initialize_MemBlocksList+0x88>
  802887:	a1 48 51 80 00       	mov    0x805148,%eax
  80288c:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802892:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802895:	c1 e1 04             	shl    $0x4,%ecx
  802898:	01 ca                	add    %ecx,%edx
  80289a:	89 50 04             	mov    %edx,0x4(%eax)
  80289d:	eb 12                	jmp    8028b1 <initialize_MemBlocksList+0x9a>
  80289f:	a1 50 50 80 00       	mov    0x805050,%eax
  8028a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a7:	c1 e2 04             	shl    $0x4,%edx
  8028aa:	01 d0                	add    %edx,%eax
  8028ac:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028b1:	a1 50 50 80 00       	mov    0x805050,%eax
  8028b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b9:	c1 e2 04             	shl    $0x4,%edx
  8028bc:	01 d0                	add    %edx,%eax
  8028be:	a3 48 51 80 00       	mov    %eax,0x805148
  8028c3:	a1 50 50 80 00       	mov    0x805050,%eax
  8028c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cb:	c1 e2 04             	shl    $0x4,%edx
  8028ce:	01 d0                	add    %edx,%eax
  8028d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d7:	a1 54 51 80 00       	mov    0x805154,%eax
  8028dc:	40                   	inc    %eax
  8028dd:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8028e2:	ff 45 f4             	incl   -0xc(%ebp)
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028eb:	0f 82 56 ff ff ff    	jb     802847 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8028f1:	90                   	nop
  8028f2:	c9                   	leave  
  8028f3:	c3                   	ret    

008028f4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8028f4:	55                   	push   %ebp
  8028f5:	89 e5                	mov    %esp,%ebp
  8028f7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	8b 00                	mov    (%eax),%eax
  8028ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802902:	eb 19                	jmp    80291d <find_block+0x29>
	{
		if(va==point->sva)
  802904:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802907:	8b 40 08             	mov    0x8(%eax),%eax
  80290a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80290d:	75 05                	jne    802914 <find_block+0x20>
		   return point;
  80290f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802912:	eb 36                	jmp    80294a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802914:	8b 45 08             	mov    0x8(%ebp),%eax
  802917:	8b 40 08             	mov    0x8(%eax),%eax
  80291a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80291d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802921:	74 07                	je     80292a <find_block+0x36>
  802923:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	eb 05                	jmp    80292f <find_block+0x3b>
  80292a:	b8 00 00 00 00       	mov    $0x0,%eax
  80292f:	8b 55 08             	mov    0x8(%ebp),%edx
  802932:	89 42 08             	mov    %eax,0x8(%edx)
  802935:	8b 45 08             	mov    0x8(%ebp),%eax
  802938:	8b 40 08             	mov    0x8(%eax),%eax
  80293b:	85 c0                	test   %eax,%eax
  80293d:	75 c5                	jne    802904 <find_block+0x10>
  80293f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802943:	75 bf                	jne    802904 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802945:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80294a:	c9                   	leave  
  80294b:	c3                   	ret    

0080294c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80294c:	55                   	push   %ebp
  80294d:	89 e5                	mov    %esp,%ebp
  80294f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802952:	a1 40 50 80 00       	mov    0x805040,%eax
  802957:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80295a:	a1 44 50 80 00       	mov    0x805044,%eax
  80295f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802965:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802968:	74 24                	je     80298e <insert_sorted_allocList+0x42>
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	8b 50 08             	mov    0x8(%eax),%edx
  802970:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802973:	8b 40 08             	mov    0x8(%eax),%eax
  802976:	39 c2                	cmp    %eax,%edx
  802978:	76 14                	jbe    80298e <insert_sorted_allocList+0x42>
  80297a:	8b 45 08             	mov    0x8(%ebp),%eax
  80297d:	8b 50 08             	mov    0x8(%eax),%edx
  802980:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802983:	8b 40 08             	mov    0x8(%eax),%eax
  802986:	39 c2                	cmp    %eax,%edx
  802988:	0f 82 60 01 00 00    	jb     802aee <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80298e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802992:	75 65                	jne    8029f9 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802994:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802998:	75 14                	jne    8029ae <insert_sorted_allocList+0x62>
  80299a:	83 ec 04             	sub    $0x4,%esp
  80299d:	68 14 48 80 00       	push   $0x804814
  8029a2:	6a 6b                	push   $0x6b
  8029a4:	68 37 48 80 00       	push   $0x804837
  8029a9:	e8 07 e1 ff ff       	call   800ab5 <_panic>
  8029ae:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	89 10                	mov    %edx,(%eax)
  8029b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bc:	8b 00                	mov    (%eax),%eax
  8029be:	85 c0                	test   %eax,%eax
  8029c0:	74 0d                	je     8029cf <insert_sorted_allocList+0x83>
  8029c2:	a1 40 50 80 00       	mov    0x805040,%eax
  8029c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ca:	89 50 04             	mov    %edx,0x4(%eax)
  8029cd:	eb 08                	jmp    8029d7 <insert_sorted_allocList+0x8b>
  8029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d2:	a3 44 50 80 00       	mov    %eax,0x805044
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	a3 40 50 80 00       	mov    %eax,0x805040
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029ee:	40                   	inc    %eax
  8029ef:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029f4:	e9 dc 01 00 00       	jmp    802bd5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8029f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fc:	8b 50 08             	mov    0x8(%eax),%edx
  8029ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a02:	8b 40 08             	mov    0x8(%eax),%eax
  802a05:	39 c2                	cmp    %eax,%edx
  802a07:	77 6c                	ja     802a75 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802a09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a0d:	74 06                	je     802a15 <insert_sorted_allocList+0xc9>
  802a0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a13:	75 14                	jne    802a29 <insert_sorted_allocList+0xdd>
  802a15:	83 ec 04             	sub    $0x4,%esp
  802a18:	68 50 48 80 00       	push   $0x804850
  802a1d:	6a 6f                	push   $0x6f
  802a1f:	68 37 48 80 00       	push   $0x804837
  802a24:	e8 8c e0 ff ff       	call   800ab5 <_panic>
  802a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2c:	8b 50 04             	mov    0x4(%eax),%edx
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	89 50 04             	mov    %edx,0x4(%eax)
  802a35:	8b 45 08             	mov    0x8(%ebp),%eax
  802a38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a3b:	89 10                	mov    %edx,(%eax)
  802a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a40:	8b 40 04             	mov    0x4(%eax),%eax
  802a43:	85 c0                	test   %eax,%eax
  802a45:	74 0d                	je     802a54 <insert_sorted_allocList+0x108>
  802a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4a:	8b 40 04             	mov    0x4(%eax),%eax
  802a4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a50:	89 10                	mov    %edx,(%eax)
  802a52:	eb 08                	jmp    802a5c <insert_sorted_allocList+0x110>
  802a54:	8b 45 08             	mov    0x8(%ebp),%eax
  802a57:	a3 40 50 80 00       	mov    %eax,0x805040
  802a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a62:	89 50 04             	mov    %edx,0x4(%eax)
  802a65:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a6a:	40                   	inc    %eax
  802a6b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a70:	e9 60 01 00 00       	jmp    802bd5 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802a75:	8b 45 08             	mov    0x8(%ebp),%eax
  802a78:	8b 50 08             	mov    0x8(%eax),%edx
  802a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7e:	8b 40 08             	mov    0x8(%eax),%eax
  802a81:	39 c2                	cmp    %eax,%edx
  802a83:	0f 82 4c 01 00 00    	jb     802bd5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802a89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a8d:	75 14                	jne    802aa3 <insert_sorted_allocList+0x157>
  802a8f:	83 ec 04             	sub    $0x4,%esp
  802a92:	68 88 48 80 00       	push   $0x804888
  802a97:	6a 73                	push   $0x73
  802a99:	68 37 48 80 00       	push   $0x804837
  802a9e:	e8 12 e0 ff ff       	call   800ab5 <_panic>
  802aa3:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	89 50 04             	mov    %edx,0x4(%eax)
  802aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab2:	8b 40 04             	mov    0x4(%eax),%eax
  802ab5:	85 c0                	test   %eax,%eax
  802ab7:	74 0c                	je     802ac5 <insert_sorted_allocList+0x179>
  802ab9:	a1 44 50 80 00       	mov    0x805044,%eax
  802abe:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac1:	89 10                	mov    %edx,(%eax)
  802ac3:	eb 08                	jmp    802acd <insert_sorted_allocList+0x181>
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	a3 40 50 80 00       	mov    %eax,0x805040
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	a3 44 50 80 00       	mov    %eax,0x805044
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ade:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ae3:	40                   	inc    %eax
  802ae4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ae9:	e9 e7 00 00 00       	jmp    802bd5 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802af4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802afb:	a1 40 50 80 00       	mov    0x805040,%eax
  802b00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b03:	e9 9d 00 00 00       	jmp    802ba5 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	8b 00                	mov    (%eax),%eax
  802b0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802b10:	8b 45 08             	mov    0x8(%ebp),%eax
  802b13:	8b 50 08             	mov    0x8(%eax),%edx
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	8b 40 08             	mov    0x8(%eax),%eax
  802b1c:	39 c2                	cmp    %eax,%edx
  802b1e:	76 7d                	jbe    802b9d <insert_sorted_allocList+0x251>
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	8b 50 08             	mov    0x8(%eax),%edx
  802b26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b29:	8b 40 08             	mov    0x8(%eax),%eax
  802b2c:	39 c2                	cmp    %eax,%edx
  802b2e:	73 6d                	jae    802b9d <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802b30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b34:	74 06                	je     802b3c <insert_sorted_allocList+0x1f0>
  802b36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b3a:	75 14                	jne    802b50 <insert_sorted_allocList+0x204>
  802b3c:	83 ec 04             	sub    $0x4,%esp
  802b3f:	68 ac 48 80 00       	push   $0x8048ac
  802b44:	6a 7f                	push   $0x7f
  802b46:	68 37 48 80 00       	push   $0x804837
  802b4b:	e8 65 df ff ff       	call   800ab5 <_panic>
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	8b 10                	mov    (%eax),%edx
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	89 10                	mov    %edx,(%eax)
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	8b 00                	mov    (%eax),%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	74 0b                	je     802b6e <insert_sorted_allocList+0x222>
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 00                	mov    (%eax),%eax
  802b68:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6b:	89 50 04             	mov    %edx,0x4(%eax)
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 55 08             	mov    0x8(%ebp),%edx
  802b74:	89 10                	mov    %edx,(%eax)
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7c:	89 50 04             	mov    %edx,0x4(%eax)
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	8b 00                	mov    (%eax),%eax
  802b84:	85 c0                	test   %eax,%eax
  802b86:	75 08                	jne    802b90 <insert_sorted_allocList+0x244>
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	a3 44 50 80 00       	mov    %eax,0x805044
  802b90:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b95:	40                   	inc    %eax
  802b96:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802b9b:	eb 39                	jmp    802bd6 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b9d:	a1 48 50 80 00       	mov    0x805048,%eax
  802ba2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba9:	74 07                	je     802bb2 <insert_sorted_allocList+0x266>
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 00                	mov    (%eax),%eax
  802bb0:	eb 05                	jmp    802bb7 <insert_sorted_allocList+0x26b>
  802bb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb7:	a3 48 50 80 00       	mov    %eax,0x805048
  802bbc:	a1 48 50 80 00       	mov    0x805048,%eax
  802bc1:	85 c0                	test   %eax,%eax
  802bc3:	0f 85 3f ff ff ff    	jne    802b08 <insert_sorted_allocList+0x1bc>
  802bc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bcd:	0f 85 35 ff ff ff    	jne    802b08 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802bd3:	eb 01                	jmp    802bd6 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802bd5:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802bd6:	90                   	nop
  802bd7:	c9                   	leave  
  802bd8:	c3                   	ret    

00802bd9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802bd9:	55                   	push   %ebp
  802bda:	89 e5                	mov    %esp,%ebp
  802bdc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802bdf:	a1 38 51 80 00       	mov    0x805138,%eax
  802be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be7:	e9 85 01 00 00       	jmp    802d71 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf5:	0f 82 6e 01 00 00    	jb     802d69 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802c01:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c04:	0f 85 8a 00 00 00    	jne    802c94 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802c0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0e:	75 17                	jne    802c27 <alloc_block_FF+0x4e>
  802c10:	83 ec 04             	sub    $0x4,%esp
  802c13:	68 e0 48 80 00       	push   $0x8048e0
  802c18:	68 93 00 00 00       	push   $0x93
  802c1d:	68 37 48 80 00       	push   $0x804837
  802c22:	e8 8e de ff ff       	call   800ab5 <_panic>
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	8b 00                	mov    (%eax),%eax
  802c2c:	85 c0                	test   %eax,%eax
  802c2e:	74 10                	je     802c40 <alloc_block_FF+0x67>
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 00                	mov    (%eax),%eax
  802c35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c38:	8b 52 04             	mov    0x4(%edx),%edx
  802c3b:	89 50 04             	mov    %edx,0x4(%eax)
  802c3e:	eb 0b                	jmp    802c4b <alloc_block_FF+0x72>
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 40 04             	mov    0x4(%eax),%eax
  802c46:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 40 04             	mov    0x4(%eax),%eax
  802c51:	85 c0                	test   %eax,%eax
  802c53:	74 0f                	je     802c64 <alloc_block_FF+0x8b>
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	8b 40 04             	mov    0x4(%eax),%eax
  802c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5e:	8b 12                	mov    (%edx),%edx
  802c60:	89 10                	mov    %edx,(%eax)
  802c62:	eb 0a                	jmp    802c6e <alloc_block_FF+0x95>
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	8b 00                	mov    (%eax),%eax
  802c69:	a3 38 51 80 00       	mov    %eax,0x805138
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c81:	a1 44 51 80 00       	mov    0x805144,%eax
  802c86:	48                   	dec    %eax
  802c87:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	e9 10 01 00 00       	jmp    802da4 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c9d:	0f 86 c6 00 00 00    	jbe    802d69 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ca3:	a1 48 51 80 00       	mov    0x805148,%eax
  802ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	8b 50 08             	mov    0x8(%eax),%edx
  802cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb4:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cba:	8b 55 08             	mov    0x8(%ebp),%edx
  802cbd:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cc4:	75 17                	jne    802cdd <alloc_block_FF+0x104>
  802cc6:	83 ec 04             	sub    $0x4,%esp
  802cc9:	68 e0 48 80 00       	push   $0x8048e0
  802cce:	68 9b 00 00 00       	push   $0x9b
  802cd3:	68 37 48 80 00       	push   $0x804837
  802cd8:	e8 d8 dd ff ff       	call   800ab5 <_panic>
  802cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce0:	8b 00                	mov    (%eax),%eax
  802ce2:	85 c0                	test   %eax,%eax
  802ce4:	74 10                	je     802cf6 <alloc_block_FF+0x11d>
  802ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce9:	8b 00                	mov    (%eax),%eax
  802ceb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cee:	8b 52 04             	mov    0x4(%edx),%edx
  802cf1:	89 50 04             	mov    %edx,0x4(%eax)
  802cf4:	eb 0b                	jmp    802d01 <alloc_block_FF+0x128>
  802cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf9:	8b 40 04             	mov    0x4(%eax),%eax
  802cfc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d04:	8b 40 04             	mov    0x4(%eax),%eax
  802d07:	85 c0                	test   %eax,%eax
  802d09:	74 0f                	je     802d1a <alloc_block_FF+0x141>
  802d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0e:	8b 40 04             	mov    0x4(%eax),%eax
  802d11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d14:	8b 12                	mov    (%edx),%edx
  802d16:	89 10                	mov    %edx,(%eax)
  802d18:	eb 0a                	jmp    802d24 <alloc_block_FF+0x14b>
  802d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	a3 48 51 80 00       	mov    %eax,0x805148
  802d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d37:	a1 54 51 80 00       	mov    0x805154,%eax
  802d3c:	48                   	dec    %eax
  802d3d:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 50 08             	mov    0x8(%eax),%edx
  802d48:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4b:	01 c2                	add    %eax,%edx
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d56:	8b 40 0c             	mov    0xc(%eax),%eax
  802d59:	2b 45 08             	sub    0x8(%ebp),%eax
  802d5c:	89 c2                	mov    %eax,%edx
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d67:	eb 3b                	jmp    802da4 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802d69:	a1 40 51 80 00       	mov    0x805140,%eax
  802d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d75:	74 07                	je     802d7e <alloc_block_FF+0x1a5>
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	8b 00                	mov    (%eax),%eax
  802d7c:	eb 05                	jmp    802d83 <alloc_block_FF+0x1aa>
  802d7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d83:	a3 40 51 80 00       	mov    %eax,0x805140
  802d88:	a1 40 51 80 00       	mov    0x805140,%eax
  802d8d:	85 c0                	test   %eax,%eax
  802d8f:	0f 85 57 fe ff ff    	jne    802bec <alloc_block_FF+0x13>
  802d95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d99:	0f 85 4d fe ff ff    	jne    802bec <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802d9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802da4:	c9                   	leave  
  802da5:	c3                   	ret    

00802da6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802da6:	55                   	push   %ebp
  802da7:	89 e5                	mov    %esp,%ebp
  802da9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802dac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802db3:	a1 38 51 80 00       	mov    0x805138,%eax
  802db8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dbb:	e9 df 00 00 00       	jmp    802e9f <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dc9:	0f 82 c8 00 00 00    	jb     802e97 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dd8:	0f 85 8a 00 00 00    	jne    802e68 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802dde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de2:	75 17                	jne    802dfb <alloc_block_BF+0x55>
  802de4:	83 ec 04             	sub    $0x4,%esp
  802de7:	68 e0 48 80 00       	push   $0x8048e0
  802dec:	68 b7 00 00 00       	push   $0xb7
  802df1:	68 37 48 80 00       	push   $0x804837
  802df6:	e8 ba dc ff ff       	call   800ab5 <_panic>
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	8b 00                	mov    (%eax),%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	74 10                	je     802e14 <alloc_block_BF+0x6e>
  802e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e07:	8b 00                	mov    (%eax),%eax
  802e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e0c:	8b 52 04             	mov    0x4(%edx),%edx
  802e0f:	89 50 04             	mov    %edx,0x4(%eax)
  802e12:	eb 0b                	jmp    802e1f <alloc_block_BF+0x79>
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	8b 40 04             	mov    0x4(%eax),%eax
  802e1a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e22:	8b 40 04             	mov    0x4(%eax),%eax
  802e25:	85 c0                	test   %eax,%eax
  802e27:	74 0f                	je     802e38 <alloc_block_BF+0x92>
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	8b 40 04             	mov    0x4(%eax),%eax
  802e2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e32:	8b 12                	mov    (%edx),%edx
  802e34:	89 10                	mov    %edx,(%eax)
  802e36:	eb 0a                	jmp    802e42 <alloc_block_BF+0x9c>
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 00                	mov    (%eax),%eax
  802e3d:	a3 38 51 80 00       	mov    %eax,0x805138
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e55:	a1 44 51 80 00       	mov    0x805144,%eax
  802e5a:	48                   	dec    %eax
  802e5b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	e9 4d 01 00 00       	jmp    802fb5 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e71:	76 24                	jbe    802e97 <alloc_block_BF+0xf1>
  802e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e76:	8b 40 0c             	mov    0xc(%eax),%eax
  802e79:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e7c:	73 19                	jae    802e97 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802e7e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e91:	8b 40 08             	mov    0x8(%eax),%eax
  802e94:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802e97:	a1 40 51 80 00       	mov    0x805140,%eax
  802e9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea3:	74 07                	je     802eac <alloc_block_BF+0x106>
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 00                	mov    (%eax),%eax
  802eaa:	eb 05                	jmp    802eb1 <alloc_block_BF+0x10b>
  802eac:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb1:	a3 40 51 80 00       	mov    %eax,0x805140
  802eb6:	a1 40 51 80 00       	mov    0x805140,%eax
  802ebb:	85 c0                	test   %eax,%eax
  802ebd:	0f 85 fd fe ff ff    	jne    802dc0 <alloc_block_BF+0x1a>
  802ec3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec7:	0f 85 f3 fe ff ff    	jne    802dc0 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802ecd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ed1:	0f 84 d9 00 00 00    	je     802fb0 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ed7:	a1 48 51 80 00       	mov    0x805148,%eax
  802edc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802edf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ee5:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eeb:	8b 55 08             	mov    0x8(%ebp),%edx
  802eee:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802ef1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ef5:	75 17                	jne    802f0e <alloc_block_BF+0x168>
  802ef7:	83 ec 04             	sub    $0x4,%esp
  802efa:	68 e0 48 80 00       	push   $0x8048e0
  802eff:	68 c7 00 00 00       	push   $0xc7
  802f04:	68 37 48 80 00       	push   $0x804837
  802f09:	e8 a7 db ff ff       	call   800ab5 <_panic>
  802f0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f11:	8b 00                	mov    (%eax),%eax
  802f13:	85 c0                	test   %eax,%eax
  802f15:	74 10                	je     802f27 <alloc_block_BF+0x181>
  802f17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f1a:	8b 00                	mov    (%eax),%eax
  802f1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f1f:	8b 52 04             	mov    0x4(%edx),%edx
  802f22:	89 50 04             	mov    %edx,0x4(%eax)
  802f25:	eb 0b                	jmp    802f32 <alloc_block_BF+0x18c>
  802f27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f2a:	8b 40 04             	mov    0x4(%eax),%eax
  802f2d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f35:	8b 40 04             	mov    0x4(%eax),%eax
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	74 0f                	je     802f4b <alloc_block_BF+0x1a5>
  802f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f3f:	8b 40 04             	mov    0x4(%eax),%eax
  802f42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f45:	8b 12                	mov    (%edx),%edx
  802f47:	89 10                	mov    %edx,(%eax)
  802f49:	eb 0a                	jmp    802f55 <alloc_block_BF+0x1af>
  802f4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	a3 48 51 80 00       	mov    %eax,0x805148
  802f55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f68:	a1 54 51 80 00       	mov    0x805154,%eax
  802f6d:	48                   	dec    %eax
  802f6e:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802f73:	83 ec 08             	sub    $0x8,%esp
  802f76:	ff 75 ec             	pushl  -0x14(%ebp)
  802f79:	68 38 51 80 00       	push   $0x805138
  802f7e:	e8 71 f9 ff ff       	call   8028f4 <find_block>
  802f83:	83 c4 10             	add    $0x10,%esp
  802f86:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802f89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f8c:	8b 50 08             	mov    0x8(%eax),%edx
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	01 c2                	add    %eax,%edx
  802f94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f97:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802f9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa0:	2b 45 08             	sub    0x8(%ebp),%eax
  802fa3:	89 c2                	mov    %eax,%edx
  802fa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa8:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802fab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fae:	eb 05                	jmp    802fb5 <alloc_block_BF+0x20f>
	}
	return NULL;
  802fb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fb5:	c9                   	leave  
  802fb6:	c3                   	ret    

00802fb7 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802fb7:	55                   	push   %ebp
  802fb8:	89 e5                	mov    %esp,%ebp
  802fba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802fbd:	a1 28 50 80 00       	mov    0x805028,%eax
  802fc2:	85 c0                	test   %eax,%eax
  802fc4:	0f 85 de 01 00 00    	jne    8031a8 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802fca:	a1 38 51 80 00       	mov    0x805138,%eax
  802fcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fd2:	e9 9e 01 00 00       	jmp    803175 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fda:	8b 40 0c             	mov    0xc(%eax),%eax
  802fdd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fe0:	0f 82 87 01 00 00    	jb     80316d <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fef:	0f 85 95 00 00 00    	jne    80308a <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802ff5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff9:	75 17                	jne    803012 <alloc_block_NF+0x5b>
  802ffb:	83 ec 04             	sub    $0x4,%esp
  802ffe:	68 e0 48 80 00       	push   $0x8048e0
  803003:	68 e0 00 00 00       	push   $0xe0
  803008:	68 37 48 80 00       	push   $0x804837
  80300d:	e8 a3 da ff ff       	call   800ab5 <_panic>
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	8b 00                	mov    (%eax),%eax
  803017:	85 c0                	test   %eax,%eax
  803019:	74 10                	je     80302b <alloc_block_NF+0x74>
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 00                	mov    (%eax),%eax
  803020:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803023:	8b 52 04             	mov    0x4(%edx),%edx
  803026:	89 50 04             	mov    %edx,0x4(%eax)
  803029:	eb 0b                	jmp    803036 <alloc_block_NF+0x7f>
  80302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302e:	8b 40 04             	mov    0x4(%eax),%eax
  803031:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	8b 40 04             	mov    0x4(%eax),%eax
  80303c:	85 c0                	test   %eax,%eax
  80303e:	74 0f                	je     80304f <alloc_block_NF+0x98>
  803040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803043:	8b 40 04             	mov    0x4(%eax),%eax
  803046:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803049:	8b 12                	mov    (%edx),%edx
  80304b:	89 10                	mov    %edx,(%eax)
  80304d:	eb 0a                	jmp    803059 <alloc_block_NF+0xa2>
  80304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803052:	8b 00                	mov    (%eax),%eax
  803054:	a3 38 51 80 00       	mov    %eax,0x805138
  803059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803065:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306c:	a1 44 51 80 00       	mov    0x805144,%eax
  803071:	48                   	dec    %eax
  803072:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  803077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307a:	8b 40 08             	mov    0x8(%eax),%eax
  80307d:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  803082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803085:	e9 f8 04 00 00       	jmp    803582 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	8b 40 0c             	mov    0xc(%eax),%eax
  803090:	3b 45 08             	cmp    0x8(%ebp),%eax
  803093:	0f 86 d4 00 00 00    	jbe    80316d <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803099:	a1 48 51 80 00       	mov    0x805148,%eax
  80309e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 50 08             	mov    0x8(%eax),%edx
  8030a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030aa:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8030ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b3:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030ba:	75 17                	jne    8030d3 <alloc_block_NF+0x11c>
  8030bc:	83 ec 04             	sub    $0x4,%esp
  8030bf:	68 e0 48 80 00       	push   $0x8048e0
  8030c4:	68 e9 00 00 00       	push   $0xe9
  8030c9:	68 37 48 80 00       	push   $0x804837
  8030ce:	e8 e2 d9 ff ff       	call   800ab5 <_panic>
  8030d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d6:	8b 00                	mov    (%eax),%eax
  8030d8:	85 c0                	test   %eax,%eax
  8030da:	74 10                	je     8030ec <alloc_block_NF+0x135>
  8030dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030df:	8b 00                	mov    (%eax),%eax
  8030e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030e4:	8b 52 04             	mov    0x4(%edx),%edx
  8030e7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ea:	eb 0b                	jmp    8030f7 <alloc_block_NF+0x140>
  8030ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ef:	8b 40 04             	mov    0x4(%eax),%eax
  8030f2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fa:	8b 40 04             	mov    0x4(%eax),%eax
  8030fd:	85 c0                	test   %eax,%eax
  8030ff:	74 0f                	je     803110 <alloc_block_NF+0x159>
  803101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803104:	8b 40 04             	mov    0x4(%eax),%eax
  803107:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80310a:	8b 12                	mov    (%edx),%edx
  80310c:	89 10                	mov    %edx,(%eax)
  80310e:	eb 0a                	jmp    80311a <alloc_block_NF+0x163>
  803110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803113:	8b 00                	mov    (%eax),%eax
  803115:	a3 48 51 80 00       	mov    %eax,0x805148
  80311a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803126:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80312d:	a1 54 51 80 00       	mov    0x805154,%eax
  803132:	48                   	dec    %eax
  803133:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313b:	8b 40 08             	mov    0x8(%eax),%eax
  80313e:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  803143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803146:	8b 50 08             	mov    0x8(%eax),%edx
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	01 c2                	add    %eax,%edx
  80314e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803151:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803157:	8b 40 0c             	mov    0xc(%eax),%eax
  80315a:	2b 45 08             	sub    0x8(%ebp),%eax
  80315d:	89 c2                	mov    %eax,%edx
  80315f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803162:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803165:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803168:	e9 15 04 00 00       	jmp    803582 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80316d:	a1 40 51 80 00       	mov    0x805140,%eax
  803172:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803175:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803179:	74 07                	je     803182 <alloc_block_NF+0x1cb>
  80317b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317e:	8b 00                	mov    (%eax),%eax
  803180:	eb 05                	jmp    803187 <alloc_block_NF+0x1d0>
  803182:	b8 00 00 00 00       	mov    $0x0,%eax
  803187:	a3 40 51 80 00       	mov    %eax,0x805140
  80318c:	a1 40 51 80 00       	mov    0x805140,%eax
  803191:	85 c0                	test   %eax,%eax
  803193:	0f 85 3e fe ff ff    	jne    802fd7 <alloc_block_NF+0x20>
  803199:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80319d:	0f 85 34 fe ff ff    	jne    802fd7 <alloc_block_NF+0x20>
  8031a3:	e9 d5 03 00 00       	jmp    80357d <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031a8:	a1 38 51 80 00       	mov    0x805138,%eax
  8031ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031b0:	e9 b1 01 00 00       	jmp    803366 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8031b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b8:	8b 50 08             	mov    0x8(%eax),%edx
  8031bb:	a1 28 50 80 00       	mov    0x805028,%eax
  8031c0:	39 c2                	cmp    %eax,%edx
  8031c2:	0f 82 96 01 00 00    	jb     80335e <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d1:	0f 82 87 01 00 00    	jb     80335e <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	8b 40 0c             	mov    0xc(%eax),%eax
  8031dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e0:	0f 85 95 00 00 00    	jne    80327b <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8031e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ea:	75 17                	jne    803203 <alloc_block_NF+0x24c>
  8031ec:	83 ec 04             	sub    $0x4,%esp
  8031ef:	68 e0 48 80 00       	push   $0x8048e0
  8031f4:	68 fc 00 00 00       	push   $0xfc
  8031f9:	68 37 48 80 00       	push   $0x804837
  8031fe:	e8 b2 d8 ff ff       	call   800ab5 <_panic>
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	85 c0                	test   %eax,%eax
  80320a:	74 10                	je     80321c <alloc_block_NF+0x265>
  80320c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320f:	8b 00                	mov    (%eax),%eax
  803211:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803214:	8b 52 04             	mov    0x4(%edx),%edx
  803217:	89 50 04             	mov    %edx,0x4(%eax)
  80321a:	eb 0b                	jmp    803227 <alloc_block_NF+0x270>
  80321c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321f:	8b 40 04             	mov    0x4(%eax),%eax
  803222:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322a:	8b 40 04             	mov    0x4(%eax),%eax
  80322d:	85 c0                	test   %eax,%eax
  80322f:	74 0f                	je     803240 <alloc_block_NF+0x289>
  803231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803234:	8b 40 04             	mov    0x4(%eax),%eax
  803237:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323a:	8b 12                	mov    (%edx),%edx
  80323c:	89 10                	mov    %edx,(%eax)
  80323e:	eb 0a                	jmp    80324a <alloc_block_NF+0x293>
  803240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803243:	8b 00                	mov    (%eax),%eax
  803245:	a3 38 51 80 00       	mov    %eax,0x805138
  80324a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803256:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325d:	a1 44 51 80 00       	mov    0x805144,%eax
  803262:	48                   	dec    %eax
  803263:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326b:	8b 40 08             	mov    0x8(%eax),%eax
  80326e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803276:	e9 07 03 00 00       	jmp    803582 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80327b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327e:	8b 40 0c             	mov    0xc(%eax),%eax
  803281:	3b 45 08             	cmp    0x8(%ebp),%eax
  803284:	0f 86 d4 00 00 00    	jbe    80335e <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80328a:	a1 48 51 80 00       	mov    0x805148,%eax
  80328f:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	8b 50 08             	mov    0x8(%eax),%edx
  803298:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80329e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ab:	75 17                	jne    8032c4 <alloc_block_NF+0x30d>
  8032ad:	83 ec 04             	sub    $0x4,%esp
  8032b0:	68 e0 48 80 00       	push   $0x8048e0
  8032b5:	68 04 01 00 00       	push   $0x104
  8032ba:	68 37 48 80 00       	push   $0x804837
  8032bf:	e8 f1 d7 ff ff       	call   800ab5 <_panic>
  8032c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c7:	8b 00                	mov    (%eax),%eax
  8032c9:	85 c0                	test   %eax,%eax
  8032cb:	74 10                	je     8032dd <alloc_block_NF+0x326>
  8032cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d0:	8b 00                	mov    (%eax),%eax
  8032d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032d5:	8b 52 04             	mov    0x4(%edx),%edx
  8032d8:	89 50 04             	mov    %edx,0x4(%eax)
  8032db:	eb 0b                	jmp    8032e8 <alloc_block_NF+0x331>
  8032dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e0:	8b 40 04             	mov    0x4(%eax),%eax
  8032e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032eb:	8b 40 04             	mov    0x4(%eax),%eax
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	74 0f                	je     803301 <alloc_block_NF+0x34a>
  8032f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f5:	8b 40 04             	mov    0x4(%eax),%eax
  8032f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032fb:	8b 12                	mov    (%edx),%edx
  8032fd:	89 10                	mov    %edx,(%eax)
  8032ff:	eb 0a                	jmp    80330b <alloc_block_NF+0x354>
  803301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803304:	8b 00                	mov    (%eax),%eax
  803306:	a3 48 51 80 00       	mov    %eax,0x805148
  80330b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803314:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803317:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80331e:	a1 54 51 80 00       	mov    0x805154,%eax
  803323:	48                   	dec    %eax
  803324:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803329:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332c:	8b 40 08             	mov    0x8(%eax),%eax
  80332f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803337:	8b 50 08             	mov    0x8(%eax),%edx
  80333a:	8b 45 08             	mov    0x8(%ebp),%eax
  80333d:	01 c2                	add    %eax,%edx
  80333f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803342:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803348:	8b 40 0c             	mov    0xc(%eax),%eax
  80334b:	2b 45 08             	sub    0x8(%ebp),%eax
  80334e:	89 c2                	mov    %eax,%edx
  803350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803353:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803356:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803359:	e9 24 02 00 00       	jmp    803582 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80335e:	a1 40 51 80 00       	mov    0x805140,%eax
  803363:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336a:	74 07                	je     803373 <alloc_block_NF+0x3bc>
  80336c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336f:	8b 00                	mov    (%eax),%eax
  803371:	eb 05                	jmp    803378 <alloc_block_NF+0x3c1>
  803373:	b8 00 00 00 00       	mov    $0x0,%eax
  803378:	a3 40 51 80 00       	mov    %eax,0x805140
  80337d:	a1 40 51 80 00       	mov    0x805140,%eax
  803382:	85 c0                	test   %eax,%eax
  803384:	0f 85 2b fe ff ff    	jne    8031b5 <alloc_block_NF+0x1fe>
  80338a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338e:	0f 85 21 fe ff ff    	jne    8031b5 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803394:	a1 38 51 80 00       	mov    0x805138,%eax
  803399:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80339c:	e9 ae 01 00 00       	jmp    80354f <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8033a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a4:	8b 50 08             	mov    0x8(%eax),%edx
  8033a7:	a1 28 50 80 00       	mov    0x805028,%eax
  8033ac:	39 c2                	cmp    %eax,%edx
  8033ae:	0f 83 93 01 00 00    	jae    803547 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8033b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033bd:	0f 82 84 01 00 00    	jb     803547 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8033c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033cc:	0f 85 95 00 00 00    	jne    803467 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8033d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d6:	75 17                	jne    8033ef <alloc_block_NF+0x438>
  8033d8:	83 ec 04             	sub    $0x4,%esp
  8033db:	68 e0 48 80 00       	push   $0x8048e0
  8033e0:	68 14 01 00 00       	push   $0x114
  8033e5:	68 37 48 80 00       	push   $0x804837
  8033ea:	e8 c6 d6 ff ff       	call   800ab5 <_panic>
  8033ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f2:	8b 00                	mov    (%eax),%eax
  8033f4:	85 c0                	test   %eax,%eax
  8033f6:	74 10                	je     803408 <alloc_block_NF+0x451>
  8033f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fb:	8b 00                	mov    (%eax),%eax
  8033fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803400:	8b 52 04             	mov    0x4(%edx),%edx
  803403:	89 50 04             	mov    %edx,0x4(%eax)
  803406:	eb 0b                	jmp    803413 <alloc_block_NF+0x45c>
  803408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340b:	8b 40 04             	mov    0x4(%eax),%eax
  80340e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803416:	8b 40 04             	mov    0x4(%eax),%eax
  803419:	85 c0                	test   %eax,%eax
  80341b:	74 0f                	je     80342c <alloc_block_NF+0x475>
  80341d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803420:	8b 40 04             	mov    0x4(%eax),%eax
  803423:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803426:	8b 12                	mov    (%edx),%edx
  803428:	89 10                	mov    %edx,(%eax)
  80342a:	eb 0a                	jmp    803436 <alloc_block_NF+0x47f>
  80342c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342f:	8b 00                	mov    (%eax),%eax
  803431:	a3 38 51 80 00       	mov    %eax,0x805138
  803436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803439:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80343f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803442:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803449:	a1 44 51 80 00       	mov    0x805144,%eax
  80344e:	48                   	dec    %eax
  80344f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803457:	8b 40 08             	mov    0x8(%eax),%eax
  80345a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80345f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803462:	e9 1b 01 00 00       	jmp    803582 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346a:	8b 40 0c             	mov    0xc(%eax),%eax
  80346d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803470:	0f 86 d1 00 00 00    	jbe    803547 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803476:	a1 48 51 80 00       	mov    0x805148,%eax
  80347b:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80347e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803481:	8b 50 08             	mov    0x8(%eax),%edx
  803484:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803487:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80348a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80348d:	8b 55 08             	mov    0x8(%ebp),%edx
  803490:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803493:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803497:	75 17                	jne    8034b0 <alloc_block_NF+0x4f9>
  803499:	83 ec 04             	sub    $0x4,%esp
  80349c:	68 e0 48 80 00       	push   $0x8048e0
  8034a1:	68 1c 01 00 00       	push   $0x11c
  8034a6:	68 37 48 80 00       	push   $0x804837
  8034ab:	e8 05 d6 ff ff       	call   800ab5 <_panic>
  8034b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b3:	8b 00                	mov    (%eax),%eax
  8034b5:	85 c0                	test   %eax,%eax
  8034b7:	74 10                	je     8034c9 <alloc_block_NF+0x512>
  8034b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034bc:	8b 00                	mov    (%eax),%eax
  8034be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034c1:	8b 52 04             	mov    0x4(%edx),%edx
  8034c4:	89 50 04             	mov    %edx,0x4(%eax)
  8034c7:	eb 0b                	jmp    8034d4 <alloc_block_NF+0x51d>
  8034c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034cc:	8b 40 04             	mov    0x4(%eax),%eax
  8034cf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d7:	8b 40 04             	mov    0x4(%eax),%eax
  8034da:	85 c0                	test   %eax,%eax
  8034dc:	74 0f                	je     8034ed <alloc_block_NF+0x536>
  8034de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e1:	8b 40 04             	mov    0x4(%eax),%eax
  8034e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034e7:	8b 12                	mov    (%edx),%edx
  8034e9:	89 10                	mov    %edx,(%eax)
  8034eb:	eb 0a                	jmp    8034f7 <alloc_block_NF+0x540>
  8034ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f0:	8b 00                	mov    (%eax),%eax
  8034f2:	a3 48 51 80 00       	mov    %eax,0x805148
  8034f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803500:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803503:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80350a:	a1 54 51 80 00       	mov    0x805154,%eax
  80350f:	48                   	dec    %eax
  803510:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803518:	8b 40 08             	mov    0x8(%eax),%eax
  80351b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803523:	8b 50 08             	mov    0x8(%eax),%edx
  803526:	8b 45 08             	mov    0x8(%ebp),%eax
  803529:	01 c2                	add    %eax,%edx
  80352b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803534:	8b 40 0c             	mov    0xc(%eax),%eax
  803537:	2b 45 08             	sub    0x8(%ebp),%eax
  80353a:	89 c2                	mov    %eax,%edx
  80353c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803542:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803545:	eb 3b                	jmp    803582 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803547:	a1 40 51 80 00       	mov    0x805140,%eax
  80354c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80354f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803553:	74 07                	je     80355c <alloc_block_NF+0x5a5>
  803555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803558:	8b 00                	mov    (%eax),%eax
  80355a:	eb 05                	jmp    803561 <alloc_block_NF+0x5aa>
  80355c:	b8 00 00 00 00       	mov    $0x0,%eax
  803561:	a3 40 51 80 00       	mov    %eax,0x805140
  803566:	a1 40 51 80 00       	mov    0x805140,%eax
  80356b:	85 c0                	test   %eax,%eax
  80356d:	0f 85 2e fe ff ff    	jne    8033a1 <alloc_block_NF+0x3ea>
  803573:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803577:	0f 85 24 fe ff ff    	jne    8033a1 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80357d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803582:	c9                   	leave  
  803583:	c3                   	ret    

00803584 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803584:	55                   	push   %ebp
  803585:	89 e5                	mov    %esp,%ebp
  803587:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80358a:	a1 38 51 80 00       	mov    0x805138,%eax
  80358f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803592:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803597:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80359a:	a1 38 51 80 00       	mov    0x805138,%eax
  80359f:	85 c0                	test   %eax,%eax
  8035a1:	74 14                	je     8035b7 <insert_sorted_with_merge_freeList+0x33>
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	8b 50 08             	mov    0x8(%eax),%edx
  8035a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ac:	8b 40 08             	mov    0x8(%eax),%eax
  8035af:	39 c2                	cmp    %eax,%edx
  8035b1:	0f 87 9b 01 00 00    	ja     803752 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8035b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035bb:	75 17                	jne    8035d4 <insert_sorted_with_merge_freeList+0x50>
  8035bd:	83 ec 04             	sub    $0x4,%esp
  8035c0:	68 14 48 80 00       	push   $0x804814
  8035c5:	68 38 01 00 00       	push   $0x138
  8035ca:	68 37 48 80 00       	push   $0x804837
  8035cf:	e8 e1 d4 ff ff       	call   800ab5 <_panic>
  8035d4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8035da:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dd:	89 10                	mov    %edx,(%eax)
  8035df:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e2:	8b 00                	mov    (%eax),%eax
  8035e4:	85 c0                	test   %eax,%eax
  8035e6:	74 0d                	je     8035f5 <insert_sorted_with_merge_freeList+0x71>
  8035e8:	a1 38 51 80 00       	mov    0x805138,%eax
  8035ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8035f0:	89 50 04             	mov    %edx,0x4(%eax)
  8035f3:	eb 08                	jmp    8035fd <insert_sorted_with_merge_freeList+0x79>
  8035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803600:	a3 38 51 80 00       	mov    %eax,0x805138
  803605:	8b 45 08             	mov    0x8(%ebp),%eax
  803608:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80360f:	a1 44 51 80 00       	mov    0x805144,%eax
  803614:	40                   	inc    %eax
  803615:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80361a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80361e:	0f 84 a8 06 00 00    	je     803ccc <insert_sorted_with_merge_freeList+0x748>
  803624:	8b 45 08             	mov    0x8(%ebp),%eax
  803627:	8b 50 08             	mov    0x8(%eax),%edx
  80362a:	8b 45 08             	mov    0x8(%ebp),%eax
  80362d:	8b 40 0c             	mov    0xc(%eax),%eax
  803630:	01 c2                	add    %eax,%edx
  803632:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803635:	8b 40 08             	mov    0x8(%eax),%eax
  803638:	39 c2                	cmp    %eax,%edx
  80363a:	0f 85 8c 06 00 00    	jne    803ccc <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803640:	8b 45 08             	mov    0x8(%ebp),%eax
  803643:	8b 50 0c             	mov    0xc(%eax),%edx
  803646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803649:	8b 40 0c             	mov    0xc(%eax),%eax
  80364c:	01 c2                	add    %eax,%edx
  80364e:	8b 45 08             	mov    0x8(%ebp),%eax
  803651:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803654:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803658:	75 17                	jne    803671 <insert_sorted_with_merge_freeList+0xed>
  80365a:	83 ec 04             	sub    $0x4,%esp
  80365d:	68 e0 48 80 00       	push   $0x8048e0
  803662:	68 3c 01 00 00       	push   $0x13c
  803667:	68 37 48 80 00       	push   $0x804837
  80366c:	e8 44 d4 ff ff       	call   800ab5 <_panic>
  803671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803674:	8b 00                	mov    (%eax),%eax
  803676:	85 c0                	test   %eax,%eax
  803678:	74 10                	je     80368a <insert_sorted_with_merge_freeList+0x106>
  80367a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80367d:	8b 00                	mov    (%eax),%eax
  80367f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803682:	8b 52 04             	mov    0x4(%edx),%edx
  803685:	89 50 04             	mov    %edx,0x4(%eax)
  803688:	eb 0b                	jmp    803695 <insert_sorted_with_merge_freeList+0x111>
  80368a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80368d:	8b 40 04             	mov    0x4(%eax),%eax
  803690:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803695:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803698:	8b 40 04             	mov    0x4(%eax),%eax
  80369b:	85 c0                	test   %eax,%eax
  80369d:	74 0f                	je     8036ae <insert_sorted_with_merge_freeList+0x12a>
  80369f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a2:	8b 40 04             	mov    0x4(%eax),%eax
  8036a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036a8:	8b 12                	mov    (%edx),%edx
  8036aa:	89 10                	mov    %edx,(%eax)
  8036ac:	eb 0a                	jmp    8036b8 <insert_sorted_with_merge_freeList+0x134>
  8036ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b1:	8b 00                	mov    (%eax),%eax
  8036b3:	a3 38 51 80 00       	mov    %eax,0x805138
  8036b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036cb:	a1 44 51 80 00       	mov    0x805144,%eax
  8036d0:	48                   	dec    %eax
  8036d1:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8036d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8036e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8036ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036ee:	75 17                	jne    803707 <insert_sorted_with_merge_freeList+0x183>
  8036f0:	83 ec 04             	sub    $0x4,%esp
  8036f3:	68 14 48 80 00       	push   $0x804814
  8036f8:	68 3f 01 00 00       	push   $0x13f
  8036fd:	68 37 48 80 00       	push   $0x804837
  803702:	e8 ae d3 ff ff       	call   800ab5 <_panic>
  803707:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80370d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803710:	89 10                	mov    %edx,(%eax)
  803712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803715:	8b 00                	mov    (%eax),%eax
  803717:	85 c0                	test   %eax,%eax
  803719:	74 0d                	je     803728 <insert_sorted_with_merge_freeList+0x1a4>
  80371b:	a1 48 51 80 00       	mov    0x805148,%eax
  803720:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803723:	89 50 04             	mov    %edx,0x4(%eax)
  803726:	eb 08                	jmp    803730 <insert_sorted_with_merge_freeList+0x1ac>
  803728:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803733:	a3 48 51 80 00       	mov    %eax,0x805148
  803738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803742:	a1 54 51 80 00       	mov    0x805154,%eax
  803747:	40                   	inc    %eax
  803748:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80374d:	e9 7a 05 00 00       	jmp    803ccc <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803752:	8b 45 08             	mov    0x8(%ebp),%eax
  803755:	8b 50 08             	mov    0x8(%eax),%edx
  803758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80375b:	8b 40 08             	mov    0x8(%eax),%eax
  80375e:	39 c2                	cmp    %eax,%edx
  803760:	0f 82 14 01 00 00    	jb     80387a <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803769:	8b 50 08             	mov    0x8(%eax),%edx
  80376c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80376f:	8b 40 0c             	mov    0xc(%eax),%eax
  803772:	01 c2                	add    %eax,%edx
  803774:	8b 45 08             	mov    0x8(%ebp),%eax
  803777:	8b 40 08             	mov    0x8(%eax),%eax
  80377a:	39 c2                	cmp    %eax,%edx
  80377c:	0f 85 90 00 00 00    	jne    803812 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803782:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803785:	8b 50 0c             	mov    0xc(%eax),%edx
  803788:	8b 45 08             	mov    0x8(%ebp),%eax
  80378b:	8b 40 0c             	mov    0xc(%eax),%eax
  80378e:	01 c2                	add    %eax,%edx
  803790:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803793:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803796:	8b 45 08             	mov    0x8(%ebp),%eax
  803799:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8037a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8037aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037ae:	75 17                	jne    8037c7 <insert_sorted_with_merge_freeList+0x243>
  8037b0:	83 ec 04             	sub    $0x4,%esp
  8037b3:	68 14 48 80 00       	push   $0x804814
  8037b8:	68 49 01 00 00       	push   $0x149
  8037bd:	68 37 48 80 00       	push   $0x804837
  8037c2:	e8 ee d2 ff ff       	call   800ab5 <_panic>
  8037c7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d0:	89 10                	mov    %edx,(%eax)
  8037d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d5:	8b 00                	mov    (%eax),%eax
  8037d7:	85 c0                	test   %eax,%eax
  8037d9:	74 0d                	je     8037e8 <insert_sorted_with_merge_freeList+0x264>
  8037db:	a1 48 51 80 00       	mov    0x805148,%eax
  8037e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8037e3:	89 50 04             	mov    %edx,0x4(%eax)
  8037e6:	eb 08                	jmp    8037f0 <insert_sorted_with_merge_freeList+0x26c>
  8037e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037eb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f3:	a3 48 51 80 00       	mov    %eax,0x805148
  8037f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803802:	a1 54 51 80 00       	mov    0x805154,%eax
  803807:	40                   	inc    %eax
  803808:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80380d:	e9 bb 04 00 00       	jmp    803ccd <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803812:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803816:	75 17                	jne    80382f <insert_sorted_with_merge_freeList+0x2ab>
  803818:	83 ec 04             	sub    $0x4,%esp
  80381b:	68 88 48 80 00       	push   $0x804888
  803820:	68 4c 01 00 00       	push   $0x14c
  803825:	68 37 48 80 00       	push   $0x804837
  80382a:	e8 86 d2 ff ff       	call   800ab5 <_panic>
  80382f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803835:	8b 45 08             	mov    0x8(%ebp),%eax
  803838:	89 50 04             	mov    %edx,0x4(%eax)
  80383b:	8b 45 08             	mov    0x8(%ebp),%eax
  80383e:	8b 40 04             	mov    0x4(%eax),%eax
  803841:	85 c0                	test   %eax,%eax
  803843:	74 0c                	je     803851 <insert_sorted_with_merge_freeList+0x2cd>
  803845:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80384a:	8b 55 08             	mov    0x8(%ebp),%edx
  80384d:	89 10                	mov    %edx,(%eax)
  80384f:	eb 08                	jmp    803859 <insert_sorted_with_merge_freeList+0x2d5>
  803851:	8b 45 08             	mov    0x8(%ebp),%eax
  803854:	a3 38 51 80 00       	mov    %eax,0x805138
  803859:	8b 45 08             	mov    0x8(%ebp),%eax
  80385c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803861:	8b 45 08             	mov    0x8(%ebp),%eax
  803864:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80386a:	a1 44 51 80 00       	mov    0x805144,%eax
  80386f:	40                   	inc    %eax
  803870:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803875:	e9 53 04 00 00       	jmp    803ccd <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80387a:	a1 38 51 80 00       	mov    0x805138,%eax
  80387f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803882:	e9 15 04 00 00       	jmp    803c9c <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388a:	8b 00                	mov    (%eax),%eax
  80388c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80388f:	8b 45 08             	mov    0x8(%ebp),%eax
  803892:	8b 50 08             	mov    0x8(%eax),%edx
  803895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803898:	8b 40 08             	mov    0x8(%eax),%eax
  80389b:	39 c2                	cmp    %eax,%edx
  80389d:	0f 86 f1 03 00 00    	jbe    803c94 <insert_sorted_with_merge_freeList+0x710>
  8038a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a6:	8b 50 08             	mov    0x8(%eax),%edx
  8038a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ac:	8b 40 08             	mov    0x8(%eax),%eax
  8038af:	39 c2                	cmp    %eax,%edx
  8038b1:	0f 83 dd 03 00 00    	jae    803c94 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8038b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ba:	8b 50 08             	mov    0x8(%eax),%edx
  8038bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8038c3:	01 c2                	add    %eax,%edx
  8038c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c8:	8b 40 08             	mov    0x8(%eax),%eax
  8038cb:	39 c2                	cmp    %eax,%edx
  8038cd:	0f 85 b9 01 00 00    	jne    803a8c <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8038d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d6:	8b 50 08             	mov    0x8(%eax),%edx
  8038d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8038df:	01 c2                	add    %eax,%edx
  8038e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e4:	8b 40 08             	mov    0x8(%eax),%eax
  8038e7:	39 c2                	cmp    %eax,%edx
  8038e9:	0f 85 0d 01 00 00    	jne    8039fc <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8038ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f2:	8b 50 0c             	mov    0xc(%eax),%edx
  8038f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8038fb:	01 c2                	add    %eax,%edx
  8038fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803900:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803903:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803907:	75 17                	jne    803920 <insert_sorted_with_merge_freeList+0x39c>
  803909:	83 ec 04             	sub    $0x4,%esp
  80390c:	68 e0 48 80 00       	push   $0x8048e0
  803911:	68 5c 01 00 00       	push   $0x15c
  803916:	68 37 48 80 00       	push   $0x804837
  80391b:	e8 95 d1 ff ff       	call   800ab5 <_panic>
  803920:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803923:	8b 00                	mov    (%eax),%eax
  803925:	85 c0                	test   %eax,%eax
  803927:	74 10                	je     803939 <insert_sorted_with_merge_freeList+0x3b5>
  803929:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392c:	8b 00                	mov    (%eax),%eax
  80392e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803931:	8b 52 04             	mov    0x4(%edx),%edx
  803934:	89 50 04             	mov    %edx,0x4(%eax)
  803937:	eb 0b                	jmp    803944 <insert_sorted_with_merge_freeList+0x3c0>
  803939:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80393c:	8b 40 04             	mov    0x4(%eax),%eax
  80393f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803944:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803947:	8b 40 04             	mov    0x4(%eax),%eax
  80394a:	85 c0                	test   %eax,%eax
  80394c:	74 0f                	je     80395d <insert_sorted_with_merge_freeList+0x3d9>
  80394e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803951:	8b 40 04             	mov    0x4(%eax),%eax
  803954:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803957:	8b 12                	mov    (%edx),%edx
  803959:	89 10                	mov    %edx,(%eax)
  80395b:	eb 0a                	jmp    803967 <insert_sorted_with_merge_freeList+0x3e3>
  80395d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803960:	8b 00                	mov    (%eax),%eax
  803962:	a3 38 51 80 00       	mov    %eax,0x805138
  803967:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803970:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803973:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80397a:	a1 44 51 80 00       	mov    0x805144,%eax
  80397f:	48                   	dec    %eax
  803980:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803985:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803988:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80398f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803992:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803999:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80399d:	75 17                	jne    8039b6 <insert_sorted_with_merge_freeList+0x432>
  80399f:	83 ec 04             	sub    $0x4,%esp
  8039a2:	68 14 48 80 00       	push   $0x804814
  8039a7:	68 5f 01 00 00       	push   $0x15f
  8039ac:	68 37 48 80 00       	push   $0x804837
  8039b1:	e8 ff d0 ff ff       	call   800ab5 <_panic>
  8039b6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039bf:	89 10                	mov    %edx,(%eax)
  8039c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c4:	8b 00                	mov    (%eax),%eax
  8039c6:	85 c0                	test   %eax,%eax
  8039c8:	74 0d                	je     8039d7 <insert_sorted_with_merge_freeList+0x453>
  8039ca:	a1 48 51 80 00       	mov    0x805148,%eax
  8039cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039d2:	89 50 04             	mov    %edx,0x4(%eax)
  8039d5:	eb 08                	jmp    8039df <insert_sorted_with_merge_freeList+0x45b>
  8039d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039da:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e2:	a3 48 51 80 00       	mov    %eax,0x805148
  8039e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039f1:	a1 54 51 80 00       	mov    0x805154,%eax
  8039f6:	40                   	inc    %eax
  8039f7:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8039fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ff:	8b 50 0c             	mov    0xc(%eax),%edx
  803a02:	8b 45 08             	mov    0x8(%ebp),%eax
  803a05:	8b 40 0c             	mov    0xc(%eax),%eax
  803a08:	01 c2                	add    %eax,%edx
  803a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803a10:	8b 45 08             	mov    0x8(%ebp),%eax
  803a13:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a28:	75 17                	jne    803a41 <insert_sorted_with_merge_freeList+0x4bd>
  803a2a:	83 ec 04             	sub    $0x4,%esp
  803a2d:	68 14 48 80 00       	push   $0x804814
  803a32:	68 64 01 00 00       	push   $0x164
  803a37:	68 37 48 80 00       	push   $0x804837
  803a3c:	e8 74 d0 ff ff       	call   800ab5 <_panic>
  803a41:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a47:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4a:	89 10                	mov    %edx,(%eax)
  803a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4f:	8b 00                	mov    (%eax),%eax
  803a51:	85 c0                	test   %eax,%eax
  803a53:	74 0d                	je     803a62 <insert_sorted_with_merge_freeList+0x4de>
  803a55:	a1 48 51 80 00       	mov    0x805148,%eax
  803a5a:	8b 55 08             	mov    0x8(%ebp),%edx
  803a5d:	89 50 04             	mov    %edx,0x4(%eax)
  803a60:	eb 08                	jmp    803a6a <insert_sorted_with_merge_freeList+0x4e6>
  803a62:	8b 45 08             	mov    0x8(%ebp),%eax
  803a65:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6d:	a3 48 51 80 00       	mov    %eax,0x805148
  803a72:	8b 45 08             	mov    0x8(%ebp),%eax
  803a75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a7c:	a1 54 51 80 00       	mov    0x805154,%eax
  803a81:	40                   	inc    %eax
  803a82:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a87:	e9 41 02 00 00       	jmp    803ccd <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a8f:	8b 50 08             	mov    0x8(%eax),%edx
  803a92:	8b 45 08             	mov    0x8(%ebp),%eax
  803a95:	8b 40 0c             	mov    0xc(%eax),%eax
  803a98:	01 c2                	add    %eax,%edx
  803a9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a9d:	8b 40 08             	mov    0x8(%eax),%eax
  803aa0:	39 c2                	cmp    %eax,%edx
  803aa2:	0f 85 7c 01 00 00    	jne    803c24 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803aa8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803aac:	74 06                	je     803ab4 <insert_sorted_with_merge_freeList+0x530>
  803aae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ab2:	75 17                	jne    803acb <insert_sorted_with_merge_freeList+0x547>
  803ab4:	83 ec 04             	sub    $0x4,%esp
  803ab7:	68 50 48 80 00       	push   $0x804850
  803abc:	68 69 01 00 00       	push   $0x169
  803ac1:	68 37 48 80 00       	push   $0x804837
  803ac6:	e8 ea cf ff ff       	call   800ab5 <_panic>
  803acb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ace:	8b 50 04             	mov    0x4(%eax),%edx
  803ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad4:	89 50 04             	mov    %edx,0x4(%eax)
  803ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  803ada:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803add:	89 10                	mov    %edx,(%eax)
  803adf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae2:	8b 40 04             	mov    0x4(%eax),%eax
  803ae5:	85 c0                	test   %eax,%eax
  803ae7:	74 0d                	je     803af6 <insert_sorted_with_merge_freeList+0x572>
  803ae9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aec:	8b 40 04             	mov    0x4(%eax),%eax
  803aef:	8b 55 08             	mov    0x8(%ebp),%edx
  803af2:	89 10                	mov    %edx,(%eax)
  803af4:	eb 08                	jmp    803afe <insert_sorted_with_merge_freeList+0x57a>
  803af6:	8b 45 08             	mov    0x8(%ebp),%eax
  803af9:	a3 38 51 80 00       	mov    %eax,0x805138
  803afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b01:	8b 55 08             	mov    0x8(%ebp),%edx
  803b04:	89 50 04             	mov    %edx,0x4(%eax)
  803b07:	a1 44 51 80 00       	mov    0x805144,%eax
  803b0c:	40                   	inc    %eax
  803b0d:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803b12:	8b 45 08             	mov    0x8(%ebp),%eax
  803b15:	8b 50 0c             	mov    0xc(%eax),%edx
  803b18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b1b:	8b 40 0c             	mov    0xc(%eax),%eax
  803b1e:	01 c2                	add    %eax,%edx
  803b20:	8b 45 08             	mov    0x8(%ebp),%eax
  803b23:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803b26:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b2a:	75 17                	jne    803b43 <insert_sorted_with_merge_freeList+0x5bf>
  803b2c:	83 ec 04             	sub    $0x4,%esp
  803b2f:	68 e0 48 80 00       	push   $0x8048e0
  803b34:	68 6b 01 00 00       	push   $0x16b
  803b39:	68 37 48 80 00       	push   $0x804837
  803b3e:	e8 72 cf ff ff       	call   800ab5 <_panic>
  803b43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b46:	8b 00                	mov    (%eax),%eax
  803b48:	85 c0                	test   %eax,%eax
  803b4a:	74 10                	je     803b5c <insert_sorted_with_merge_freeList+0x5d8>
  803b4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b4f:	8b 00                	mov    (%eax),%eax
  803b51:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b54:	8b 52 04             	mov    0x4(%edx),%edx
  803b57:	89 50 04             	mov    %edx,0x4(%eax)
  803b5a:	eb 0b                	jmp    803b67 <insert_sorted_with_merge_freeList+0x5e3>
  803b5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b5f:	8b 40 04             	mov    0x4(%eax),%eax
  803b62:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b6a:	8b 40 04             	mov    0x4(%eax),%eax
  803b6d:	85 c0                	test   %eax,%eax
  803b6f:	74 0f                	je     803b80 <insert_sorted_with_merge_freeList+0x5fc>
  803b71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b74:	8b 40 04             	mov    0x4(%eax),%eax
  803b77:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b7a:	8b 12                	mov    (%edx),%edx
  803b7c:	89 10                	mov    %edx,(%eax)
  803b7e:	eb 0a                	jmp    803b8a <insert_sorted_with_merge_freeList+0x606>
  803b80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b83:	8b 00                	mov    (%eax),%eax
  803b85:	a3 38 51 80 00       	mov    %eax,0x805138
  803b8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b9d:	a1 44 51 80 00       	mov    0x805144,%eax
  803ba2:	48                   	dec    %eax
  803ba3:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803ba8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803bb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803bbc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bc0:	75 17                	jne    803bd9 <insert_sorted_with_merge_freeList+0x655>
  803bc2:	83 ec 04             	sub    $0x4,%esp
  803bc5:	68 14 48 80 00       	push   $0x804814
  803bca:	68 6e 01 00 00       	push   $0x16e
  803bcf:	68 37 48 80 00       	push   $0x804837
  803bd4:	e8 dc ce ff ff       	call   800ab5 <_panic>
  803bd9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803bdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be2:	89 10                	mov    %edx,(%eax)
  803be4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be7:	8b 00                	mov    (%eax),%eax
  803be9:	85 c0                	test   %eax,%eax
  803beb:	74 0d                	je     803bfa <insert_sorted_with_merge_freeList+0x676>
  803bed:	a1 48 51 80 00       	mov    0x805148,%eax
  803bf2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bf5:	89 50 04             	mov    %edx,0x4(%eax)
  803bf8:	eb 08                	jmp    803c02 <insert_sorted_with_merge_freeList+0x67e>
  803bfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bfd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c05:	a3 48 51 80 00       	mov    %eax,0x805148
  803c0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c14:	a1 54 51 80 00       	mov    0x805154,%eax
  803c19:	40                   	inc    %eax
  803c1a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c1f:	e9 a9 00 00 00       	jmp    803ccd <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803c24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c28:	74 06                	je     803c30 <insert_sorted_with_merge_freeList+0x6ac>
  803c2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c2e:	75 17                	jne    803c47 <insert_sorted_with_merge_freeList+0x6c3>
  803c30:	83 ec 04             	sub    $0x4,%esp
  803c33:	68 ac 48 80 00       	push   $0x8048ac
  803c38:	68 73 01 00 00       	push   $0x173
  803c3d:	68 37 48 80 00       	push   $0x804837
  803c42:	e8 6e ce ff ff       	call   800ab5 <_panic>
  803c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c4a:	8b 10                	mov    (%eax),%edx
  803c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4f:	89 10                	mov    %edx,(%eax)
  803c51:	8b 45 08             	mov    0x8(%ebp),%eax
  803c54:	8b 00                	mov    (%eax),%eax
  803c56:	85 c0                	test   %eax,%eax
  803c58:	74 0b                	je     803c65 <insert_sorted_with_merge_freeList+0x6e1>
  803c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5d:	8b 00                	mov    (%eax),%eax
  803c5f:	8b 55 08             	mov    0x8(%ebp),%edx
  803c62:	89 50 04             	mov    %edx,0x4(%eax)
  803c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c68:	8b 55 08             	mov    0x8(%ebp),%edx
  803c6b:	89 10                	mov    %edx,(%eax)
  803c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c73:	89 50 04             	mov    %edx,0x4(%eax)
  803c76:	8b 45 08             	mov    0x8(%ebp),%eax
  803c79:	8b 00                	mov    (%eax),%eax
  803c7b:	85 c0                	test   %eax,%eax
  803c7d:	75 08                	jne    803c87 <insert_sorted_with_merge_freeList+0x703>
  803c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c82:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c87:	a1 44 51 80 00       	mov    0x805144,%eax
  803c8c:	40                   	inc    %eax
  803c8d:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803c92:	eb 39                	jmp    803ccd <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803c94:	a1 40 51 80 00       	mov    0x805140,%eax
  803c99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ca0:	74 07                	je     803ca9 <insert_sorted_with_merge_freeList+0x725>
  803ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca5:	8b 00                	mov    (%eax),%eax
  803ca7:	eb 05                	jmp    803cae <insert_sorted_with_merge_freeList+0x72a>
  803ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  803cae:	a3 40 51 80 00       	mov    %eax,0x805140
  803cb3:	a1 40 51 80 00       	mov    0x805140,%eax
  803cb8:	85 c0                	test   %eax,%eax
  803cba:	0f 85 c7 fb ff ff    	jne    803887 <insert_sorted_with_merge_freeList+0x303>
  803cc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cc4:	0f 85 bd fb ff ff    	jne    803887 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803cca:	eb 01                	jmp    803ccd <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803ccc:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803ccd:	90                   	nop
  803cce:	c9                   	leave  
  803ccf:	c3                   	ret    

00803cd0 <__udivdi3>:
  803cd0:	55                   	push   %ebp
  803cd1:	57                   	push   %edi
  803cd2:	56                   	push   %esi
  803cd3:	53                   	push   %ebx
  803cd4:	83 ec 1c             	sub    $0x1c,%esp
  803cd7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803cdb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803cdf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ce3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ce7:	89 ca                	mov    %ecx,%edx
  803ce9:	89 f8                	mov    %edi,%eax
  803ceb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803cef:	85 f6                	test   %esi,%esi
  803cf1:	75 2d                	jne    803d20 <__udivdi3+0x50>
  803cf3:	39 cf                	cmp    %ecx,%edi
  803cf5:	77 65                	ja     803d5c <__udivdi3+0x8c>
  803cf7:	89 fd                	mov    %edi,%ebp
  803cf9:	85 ff                	test   %edi,%edi
  803cfb:	75 0b                	jne    803d08 <__udivdi3+0x38>
  803cfd:	b8 01 00 00 00       	mov    $0x1,%eax
  803d02:	31 d2                	xor    %edx,%edx
  803d04:	f7 f7                	div    %edi
  803d06:	89 c5                	mov    %eax,%ebp
  803d08:	31 d2                	xor    %edx,%edx
  803d0a:	89 c8                	mov    %ecx,%eax
  803d0c:	f7 f5                	div    %ebp
  803d0e:	89 c1                	mov    %eax,%ecx
  803d10:	89 d8                	mov    %ebx,%eax
  803d12:	f7 f5                	div    %ebp
  803d14:	89 cf                	mov    %ecx,%edi
  803d16:	89 fa                	mov    %edi,%edx
  803d18:	83 c4 1c             	add    $0x1c,%esp
  803d1b:	5b                   	pop    %ebx
  803d1c:	5e                   	pop    %esi
  803d1d:	5f                   	pop    %edi
  803d1e:	5d                   	pop    %ebp
  803d1f:	c3                   	ret    
  803d20:	39 ce                	cmp    %ecx,%esi
  803d22:	77 28                	ja     803d4c <__udivdi3+0x7c>
  803d24:	0f bd fe             	bsr    %esi,%edi
  803d27:	83 f7 1f             	xor    $0x1f,%edi
  803d2a:	75 40                	jne    803d6c <__udivdi3+0x9c>
  803d2c:	39 ce                	cmp    %ecx,%esi
  803d2e:	72 0a                	jb     803d3a <__udivdi3+0x6a>
  803d30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803d34:	0f 87 9e 00 00 00    	ja     803dd8 <__udivdi3+0x108>
  803d3a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d3f:	89 fa                	mov    %edi,%edx
  803d41:	83 c4 1c             	add    $0x1c,%esp
  803d44:	5b                   	pop    %ebx
  803d45:	5e                   	pop    %esi
  803d46:	5f                   	pop    %edi
  803d47:	5d                   	pop    %ebp
  803d48:	c3                   	ret    
  803d49:	8d 76 00             	lea    0x0(%esi),%esi
  803d4c:	31 ff                	xor    %edi,%edi
  803d4e:	31 c0                	xor    %eax,%eax
  803d50:	89 fa                	mov    %edi,%edx
  803d52:	83 c4 1c             	add    $0x1c,%esp
  803d55:	5b                   	pop    %ebx
  803d56:	5e                   	pop    %esi
  803d57:	5f                   	pop    %edi
  803d58:	5d                   	pop    %ebp
  803d59:	c3                   	ret    
  803d5a:	66 90                	xchg   %ax,%ax
  803d5c:	89 d8                	mov    %ebx,%eax
  803d5e:	f7 f7                	div    %edi
  803d60:	31 ff                	xor    %edi,%edi
  803d62:	89 fa                	mov    %edi,%edx
  803d64:	83 c4 1c             	add    $0x1c,%esp
  803d67:	5b                   	pop    %ebx
  803d68:	5e                   	pop    %esi
  803d69:	5f                   	pop    %edi
  803d6a:	5d                   	pop    %ebp
  803d6b:	c3                   	ret    
  803d6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d71:	89 eb                	mov    %ebp,%ebx
  803d73:	29 fb                	sub    %edi,%ebx
  803d75:	89 f9                	mov    %edi,%ecx
  803d77:	d3 e6                	shl    %cl,%esi
  803d79:	89 c5                	mov    %eax,%ebp
  803d7b:	88 d9                	mov    %bl,%cl
  803d7d:	d3 ed                	shr    %cl,%ebp
  803d7f:	89 e9                	mov    %ebp,%ecx
  803d81:	09 f1                	or     %esi,%ecx
  803d83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d87:	89 f9                	mov    %edi,%ecx
  803d89:	d3 e0                	shl    %cl,%eax
  803d8b:	89 c5                	mov    %eax,%ebp
  803d8d:	89 d6                	mov    %edx,%esi
  803d8f:	88 d9                	mov    %bl,%cl
  803d91:	d3 ee                	shr    %cl,%esi
  803d93:	89 f9                	mov    %edi,%ecx
  803d95:	d3 e2                	shl    %cl,%edx
  803d97:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d9b:	88 d9                	mov    %bl,%cl
  803d9d:	d3 e8                	shr    %cl,%eax
  803d9f:	09 c2                	or     %eax,%edx
  803da1:	89 d0                	mov    %edx,%eax
  803da3:	89 f2                	mov    %esi,%edx
  803da5:	f7 74 24 0c          	divl   0xc(%esp)
  803da9:	89 d6                	mov    %edx,%esi
  803dab:	89 c3                	mov    %eax,%ebx
  803dad:	f7 e5                	mul    %ebp
  803daf:	39 d6                	cmp    %edx,%esi
  803db1:	72 19                	jb     803dcc <__udivdi3+0xfc>
  803db3:	74 0b                	je     803dc0 <__udivdi3+0xf0>
  803db5:	89 d8                	mov    %ebx,%eax
  803db7:	31 ff                	xor    %edi,%edi
  803db9:	e9 58 ff ff ff       	jmp    803d16 <__udivdi3+0x46>
  803dbe:	66 90                	xchg   %ax,%ax
  803dc0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803dc4:	89 f9                	mov    %edi,%ecx
  803dc6:	d3 e2                	shl    %cl,%edx
  803dc8:	39 c2                	cmp    %eax,%edx
  803dca:	73 e9                	jae    803db5 <__udivdi3+0xe5>
  803dcc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803dcf:	31 ff                	xor    %edi,%edi
  803dd1:	e9 40 ff ff ff       	jmp    803d16 <__udivdi3+0x46>
  803dd6:	66 90                	xchg   %ax,%ax
  803dd8:	31 c0                	xor    %eax,%eax
  803dda:	e9 37 ff ff ff       	jmp    803d16 <__udivdi3+0x46>
  803ddf:	90                   	nop

00803de0 <__umoddi3>:
  803de0:	55                   	push   %ebp
  803de1:	57                   	push   %edi
  803de2:	56                   	push   %esi
  803de3:	53                   	push   %ebx
  803de4:	83 ec 1c             	sub    $0x1c,%esp
  803de7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803deb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803def:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803df3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803df7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803dfb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803dff:	89 f3                	mov    %esi,%ebx
  803e01:	89 fa                	mov    %edi,%edx
  803e03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e07:	89 34 24             	mov    %esi,(%esp)
  803e0a:	85 c0                	test   %eax,%eax
  803e0c:	75 1a                	jne    803e28 <__umoddi3+0x48>
  803e0e:	39 f7                	cmp    %esi,%edi
  803e10:	0f 86 a2 00 00 00    	jbe    803eb8 <__umoddi3+0xd8>
  803e16:	89 c8                	mov    %ecx,%eax
  803e18:	89 f2                	mov    %esi,%edx
  803e1a:	f7 f7                	div    %edi
  803e1c:	89 d0                	mov    %edx,%eax
  803e1e:	31 d2                	xor    %edx,%edx
  803e20:	83 c4 1c             	add    $0x1c,%esp
  803e23:	5b                   	pop    %ebx
  803e24:	5e                   	pop    %esi
  803e25:	5f                   	pop    %edi
  803e26:	5d                   	pop    %ebp
  803e27:	c3                   	ret    
  803e28:	39 f0                	cmp    %esi,%eax
  803e2a:	0f 87 ac 00 00 00    	ja     803edc <__umoddi3+0xfc>
  803e30:	0f bd e8             	bsr    %eax,%ebp
  803e33:	83 f5 1f             	xor    $0x1f,%ebp
  803e36:	0f 84 ac 00 00 00    	je     803ee8 <__umoddi3+0x108>
  803e3c:	bf 20 00 00 00       	mov    $0x20,%edi
  803e41:	29 ef                	sub    %ebp,%edi
  803e43:	89 fe                	mov    %edi,%esi
  803e45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803e49:	89 e9                	mov    %ebp,%ecx
  803e4b:	d3 e0                	shl    %cl,%eax
  803e4d:	89 d7                	mov    %edx,%edi
  803e4f:	89 f1                	mov    %esi,%ecx
  803e51:	d3 ef                	shr    %cl,%edi
  803e53:	09 c7                	or     %eax,%edi
  803e55:	89 e9                	mov    %ebp,%ecx
  803e57:	d3 e2                	shl    %cl,%edx
  803e59:	89 14 24             	mov    %edx,(%esp)
  803e5c:	89 d8                	mov    %ebx,%eax
  803e5e:	d3 e0                	shl    %cl,%eax
  803e60:	89 c2                	mov    %eax,%edx
  803e62:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e66:	d3 e0                	shl    %cl,%eax
  803e68:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e70:	89 f1                	mov    %esi,%ecx
  803e72:	d3 e8                	shr    %cl,%eax
  803e74:	09 d0                	or     %edx,%eax
  803e76:	d3 eb                	shr    %cl,%ebx
  803e78:	89 da                	mov    %ebx,%edx
  803e7a:	f7 f7                	div    %edi
  803e7c:	89 d3                	mov    %edx,%ebx
  803e7e:	f7 24 24             	mull   (%esp)
  803e81:	89 c6                	mov    %eax,%esi
  803e83:	89 d1                	mov    %edx,%ecx
  803e85:	39 d3                	cmp    %edx,%ebx
  803e87:	0f 82 87 00 00 00    	jb     803f14 <__umoddi3+0x134>
  803e8d:	0f 84 91 00 00 00    	je     803f24 <__umoddi3+0x144>
  803e93:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e97:	29 f2                	sub    %esi,%edx
  803e99:	19 cb                	sbb    %ecx,%ebx
  803e9b:	89 d8                	mov    %ebx,%eax
  803e9d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ea1:	d3 e0                	shl    %cl,%eax
  803ea3:	89 e9                	mov    %ebp,%ecx
  803ea5:	d3 ea                	shr    %cl,%edx
  803ea7:	09 d0                	or     %edx,%eax
  803ea9:	89 e9                	mov    %ebp,%ecx
  803eab:	d3 eb                	shr    %cl,%ebx
  803ead:	89 da                	mov    %ebx,%edx
  803eaf:	83 c4 1c             	add    $0x1c,%esp
  803eb2:	5b                   	pop    %ebx
  803eb3:	5e                   	pop    %esi
  803eb4:	5f                   	pop    %edi
  803eb5:	5d                   	pop    %ebp
  803eb6:	c3                   	ret    
  803eb7:	90                   	nop
  803eb8:	89 fd                	mov    %edi,%ebp
  803eba:	85 ff                	test   %edi,%edi
  803ebc:	75 0b                	jne    803ec9 <__umoddi3+0xe9>
  803ebe:	b8 01 00 00 00       	mov    $0x1,%eax
  803ec3:	31 d2                	xor    %edx,%edx
  803ec5:	f7 f7                	div    %edi
  803ec7:	89 c5                	mov    %eax,%ebp
  803ec9:	89 f0                	mov    %esi,%eax
  803ecb:	31 d2                	xor    %edx,%edx
  803ecd:	f7 f5                	div    %ebp
  803ecf:	89 c8                	mov    %ecx,%eax
  803ed1:	f7 f5                	div    %ebp
  803ed3:	89 d0                	mov    %edx,%eax
  803ed5:	e9 44 ff ff ff       	jmp    803e1e <__umoddi3+0x3e>
  803eda:	66 90                	xchg   %ax,%ax
  803edc:	89 c8                	mov    %ecx,%eax
  803ede:	89 f2                	mov    %esi,%edx
  803ee0:	83 c4 1c             	add    $0x1c,%esp
  803ee3:	5b                   	pop    %ebx
  803ee4:	5e                   	pop    %esi
  803ee5:	5f                   	pop    %edi
  803ee6:	5d                   	pop    %ebp
  803ee7:	c3                   	ret    
  803ee8:	3b 04 24             	cmp    (%esp),%eax
  803eeb:	72 06                	jb     803ef3 <__umoddi3+0x113>
  803eed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ef1:	77 0f                	ja     803f02 <__umoddi3+0x122>
  803ef3:	89 f2                	mov    %esi,%edx
  803ef5:	29 f9                	sub    %edi,%ecx
  803ef7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803efb:	89 14 24             	mov    %edx,(%esp)
  803efe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f02:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f06:	8b 14 24             	mov    (%esp),%edx
  803f09:	83 c4 1c             	add    $0x1c,%esp
  803f0c:	5b                   	pop    %ebx
  803f0d:	5e                   	pop    %esi
  803f0e:	5f                   	pop    %edi
  803f0f:	5d                   	pop    %ebp
  803f10:	c3                   	ret    
  803f11:	8d 76 00             	lea    0x0(%esi),%esi
  803f14:	2b 04 24             	sub    (%esp),%eax
  803f17:	19 fa                	sbb    %edi,%edx
  803f19:	89 d1                	mov    %edx,%ecx
  803f1b:	89 c6                	mov    %eax,%esi
  803f1d:	e9 71 ff ff ff       	jmp    803e93 <__umoddi3+0xb3>
  803f22:	66 90                	xchg   %ax,%ax
  803f24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803f28:	72 ea                	jb     803f14 <__umoddi3+0x134>
  803f2a:	89 d9                	mov    %ebx,%ecx
  803f2c:	e9 62 ff ff ff       	jmp    803e93 <__umoddi3+0xb3>
