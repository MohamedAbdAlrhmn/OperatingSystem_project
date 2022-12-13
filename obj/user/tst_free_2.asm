
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
  800090:	68 00 3e 80 00       	push   $0x803e00
  800095:	6a 14                	push   $0x14
  800097:	68 1c 3e 80 00       	push   $0x803e1c
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
  8000b3:	e8 a6 22 00 00       	call   80235e <sys_bypassPageFault>
  8000b8:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000bb:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  8000c9:	e8 f8 1e 00 00       	call   801fc6 <sys_calculate_free_frames>
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
  8000f6:	e8 cb 1e 00 00       	call   801fc6 <sys_calculate_free_frames>
  8000fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 63 1f 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
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
  800127:	68 30 3e 80 00       	push   $0x803e30
  80012c:	6a 2d                	push   $0x2d
  80012e:	68 1c 3e 80 00       	push   $0x803e1c
  800133:	e8 7d 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 29 1f 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 98 3e 80 00       	push   $0x803e98
  80014a:	6a 2e                	push   $0x2e
  80014c:	68 1c 3e 80 00       	push   $0x803e1c
  800151:	e8 5f 09 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  800156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80015e:	48                   	dec    %eax
  80015f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800165:	e8 5c 1e 00 00       	call   801fc6 <sys_calculate_free_frames>
  80016a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80016d:	e8 f4 1e 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
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
  8001a2:	68 30 3e 80 00       	push   $0x803e30
  8001a7:	6a 35                	push   $0x35
  8001a9:	68 1c 3e 80 00       	push   $0x803e1c
  8001ae:	e8 02 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001b3:	e8 ae 1e 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  8001b8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001bb:	74 14                	je     8001d1 <_main+0x199>
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	68 98 3e 80 00       	push   $0x803e98
  8001c5:	6a 36                	push   $0x36
  8001c7:	68 1c 3e 80 00       	push   $0x803e1c
  8001cc:	e8 e4 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001d9:	48                   	dec    %eax
  8001da:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001e0:	e8 e1 1d 00 00       	call   801fc6 <sys_calculate_free_frames>
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001e8:	e8 79 1e 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
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
  80021b:	68 30 3e 80 00       	push   $0x803e30
  800220:	6a 3d                	push   $0x3d
  800222:	68 1c 3e 80 00       	push   $0x803e1c
  800227:	e8 89 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80022c:	e8 35 1e 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  800231:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 98 3e 80 00       	push   $0x803e98
  80023e:	6a 3e                	push   $0x3e
  800240:	68 1c 3e 80 00       	push   $0x803e1c
  800245:	e8 6b 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  80024a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024d:	01 c0                	add    %eax,%eax
  80024f:	48                   	dec    %eax
  800250:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800256:	e8 6b 1d 00 00       	call   801fc6 <sys_calculate_free_frames>
  80025b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025e:	e8 03 1e 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
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
  80029b:	68 30 3e 80 00       	push   $0x803e30
  8002a0:	6a 45                	push   $0x45
  8002a2:	68 1c 3e 80 00       	push   $0x803e1c
  8002a7:	e8 09 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002ac:	e8 b5 1d 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  8002b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002b4:	74 14                	je     8002ca <_main+0x292>
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	68 98 3e 80 00       	push   $0x803e98
  8002be:	6a 46                	push   $0x46
  8002c0:	68 1c 3e 80 00       	push   $0x803e1c
  8002c5:	e8 eb 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  8002ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002cd:	01 c0                	add    %eax,%eax
  8002cf:	48                   	dec    %eax
  8002d0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002d6:	e8 eb 1c 00 00       	call   801fc6 <sys_calculate_free_frames>
  8002db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002de:	e8 83 1d 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
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
  800323:	68 30 3e 80 00       	push   $0x803e30
  800328:	6a 4d                	push   $0x4d
  80032a:	68 1c 3e 80 00       	push   $0x803e1c
  80032f:	e8 81 07 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800334:	e8 2d 1d 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  800339:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 98 3e 80 00       	push   $0x803e98
  800346:	6a 4e                	push   $0x4e
  800348:	68 1c 3e 80 00       	push   $0x803e1c
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
  800366:	e8 5b 1c 00 00       	call   801fc6 <sys_calculate_free_frames>
  80036b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80036e:	e8 f3 1c 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
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
  8003b2:	68 30 3e 80 00       	push   $0x803e30
  8003b7:	6a 55                	push   $0x55
  8003b9:	68 1c 3e 80 00       	push   $0x803e1c
  8003be:	e8 f2 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003c3:	e8 9e 1c 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  8003c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003cb:	74 14                	je     8003e1 <_main+0x3a9>
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 98 3e 80 00       	push   $0x803e98
  8003d5:	6a 56                	push   $0x56
  8003d7:	68 1c 3e 80 00       	push   $0x803e1c
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
  8003f4:	e8 cd 1b 00 00       	call   801fc6 <sys_calculate_free_frames>
  8003f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003fc:	e8 65 1c 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
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
  800443:	68 30 3e 80 00       	push   $0x803e30
  800448:	6a 5d                	push   $0x5d
  80044a:	68 1c 3e 80 00       	push   $0x803e1c
  80044f:	e8 61 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800454:	e8 0d 1c 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  800459:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80045c:	74 14                	je     800472 <_main+0x43a>
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 98 3e 80 00       	push   $0x803e98
  800466:	6a 5e                	push   $0x5e
  800468:	68 1c 3e 80 00       	push   $0x803e1c
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
  800481:	e8 40 1b 00 00       	call   801fc6 <sys_calculate_free_frames>
  800486:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800489:	e8 d8 1b 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  80048e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800491:	8b 45 80             	mov    -0x80(%ebp),%eax
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	50                   	push   %eax
  800498:	e8 cf 18 00 00       	call   801d6c <free>
  80049d:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8004a0:	e8 c1 1b 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  8004a5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 c8 3e 80 00       	push   $0x803ec8
  8004b2:	6a 6b                	push   $0x6b
  8004b4:	68 1c 3e 80 00       	push   $0x803e1c
  8004b9:	e8 f7 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004be:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004ca:	e8 76 1e 00 00       	call   802345 <sys_rcr2>
  8004cf:	89 c2                	mov    %eax,%edx
  8004d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d4:	39 c2                	cmp    %eax,%edx
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 04 3f 80 00       	push   $0x803f04
  8004e0:	6a 6f                	push   $0x6f
  8004e2:	68 1c 3e 80 00       	push   $0x803e1c
  8004e7:	e8 c9 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[0]] = 10;
  8004ec:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004f2:	89 c2                	mov    %eax,%edx
  8004f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f7:	01 d0                	add    %edx,%eax
  8004f9:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004fc:	e8 44 1e 00 00       	call   802345 <sys_rcr2>
  800501:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  800507:	89 d1                	mov    %edx,%ecx
  800509:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050c:	01 ca                	add    %ecx,%edx
  80050e:	39 d0                	cmp    %edx,%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 04 3f 80 00       	push   $0x803f04
  80051a:	6a 71                	push   $0x71
  80051c:	68 1c 3e 80 00       	push   $0x803e1c
  800521:	e8 8f 05 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800526:	e8 9b 1a 00 00       	call   801fc6 <sys_calculate_free_frames>
  80052b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80052e:	e8 33 1b 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  800533:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800536:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 2a 18 00 00       	call   801d6c <free>
  800542:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800545:	e8 1c 1b 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  80054a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80054d:	74 14                	je     800563 <_main+0x52b>
  80054f:	83 ec 04             	sub    $0x4,%esp
  800552:	68 c8 3e 80 00       	push   $0x803ec8
  800557:	6a 76                	push   $0x76
  800559:	68 1c 3e 80 00       	push   $0x803e1c
  80055e:	e8 52 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  800563:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800566:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800569:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056c:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80056f:	e8 d1 1d 00 00       	call   802345 <sys_rcr2>
  800574:	89 c2                	mov    %eax,%edx
  800576:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	74 14                	je     800591 <_main+0x559>
  80057d:	83 ec 04             	sub    $0x4,%esp
  800580:	68 04 3f 80 00       	push   $0x803f04
  800585:	6a 7a                	push   $0x7a
  800587:	68 1c 3e 80 00       	push   $0x803e1c
  80058c:	e8 24 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[1]] = 10;
  800591:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800597:	89 c2                	mov    %eax,%edx
  800599:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005a1:	e8 9f 1d 00 00       	call   802345 <sys_rcr2>
  8005a6:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  8005ac:	89 d1                	mov    %edx,%ecx
  8005ae:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005b1:	01 ca                	add    %ecx,%edx
  8005b3:	39 d0                	cmp    %edx,%eax
  8005b5:	74 14                	je     8005cb <_main+0x593>
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	68 04 3f 80 00       	push   $0x803f04
  8005bf:	6a 7c                	push   $0x7c
  8005c1:	68 1c 3e 80 00       	push   $0x803e1c
  8005c6:	e8 ea 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005cb:	e8 f6 19 00 00       	call   801fc6 <sys_calculate_free_frames>
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005d3:	e8 8e 1a 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  8005d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  8005db:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005de:	83 ec 0c             	sub    $0xc,%esp
  8005e1:	50                   	push   %eax
  8005e2:	e8 85 17 00 00       	call   801d6c <free>
  8005e7:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005ea:	e8 77 1a 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  8005ef:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005f2:	74 17                	je     80060b <_main+0x5d3>
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 c8 3e 80 00       	push   $0x803ec8
  8005fc:	68 81 00 00 00       	push   $0x81
  800601:	68 1c 3e 80 00       	push   $0x803e1c
  800606:	e8 aa 04 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  80060b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800611:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800614:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800617:	e8 29 1d 00 00       	call   802345 <sys_rcr2>
  80061c:	89 c2                	mov    %eax,%edx
  80061e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800621:	39 c2                	cmp    %eax,%edx
  800623:	74 17                	je     80063c <_main+0x604>
  800625:	83 ec 04             	sub    $0x4,%esp
  800628:	68 04 3f 80 00       	push   $0x803f04
  80062d:	68 85 00 00 00       	push   $0x85
  800632:	68 1c 3e 80 00       	push   $0x803e1c
  800637:	e8 79 04 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[2]] = 10;
  80063c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800642:	89 c2                	mov    %eax,%edx
  800644:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800647:	01 d0                	add    %edx,%eax
  800649:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80064c:	e8 f4 1c 00 00       	call   802345 <sys_rcr2>
  800651:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  800657:	89 d1                	mov    %edx,%ecx
  800659:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065c:	01 ca                	add    %ecx,%edx
  80065e:	39 d0                	cmp    %edx,%eax
  800660:	74 17                	je     800679 <_main+0x641>
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 04 3f 80 00       	push   $0x803f04
  80066a:	68 87 00 00 00       	push   $0x87
  80066f:	68 1c 3e 80 00       	push   $0x803e1c
  800674:	e8 3c 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800679:	e8 48 19 00 00       	call   801fc6 <sys_calculate_free_frames>
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800681:	e8 e0 19 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  800686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800689:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	50                   	push   %eax
  800690:	e8 d7 16 00 00       	call   801d6c <free>
  800695:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800698:	e8 c9 19 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 c8 3e 80 00       	push   $0x803ec8
  8006aa:	68 8c 00 00 00       	push   $0x8c
  8006af:	68 1c 3e 80 00       	push   $0x803e1c
  8006b4:	e8 fc 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  8006b9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8006bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c2:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006c5:	e8 7b 1c 00 00       	call   802345 <sys_rcr2>
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006cf:	39 c2                	cmp    %eax,%edx
  8006d1:	74 17                	je     8006ea <_main+0x6b2>
  8006d3:	83 ec 04             	sub    $0x4,%esp
  8006d6:	68 04 3f 80 00       	push   $0x803f04
  8006db:	68 90 00 00 00       	push   $0x90
  8006e0:	68 1c 3e 80 00       	push   $0x803e1c
  8006e5:	e8 cb 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[3]] = 10;
  8006ea:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006fa:	e8 46 1c 00 00       	call   802345 <sys_rcr2>
  8006ff:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800705:	89 d1                	mov    %edx,%ecx
  800707:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80070a:	01 ca                	add    %ecx,%edx
  80070c:	39 d0                	cmp    %edx,%eax
  80070e:	74 17                	je     800727 <_main+0x6ef>
  800710:	83 ec 04             	sub    $0x4,%esp
  800713:	68 04 3f 80 00       	push   $0x803f04
  800718:	68 92 00 00 00       	push   $0x92
  80071d:	68 1c 3e 80 00       	push   $0x803e1c
  800722:	e8 8e 03 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800727:	e8 9a 18 00 00       	call   801fc6 <sys_calculate_free_frames>
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80072f:	e8 32 19 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  800734:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  800737:	8b 45 90             	mov    -0x70(%ebp),%eax
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	50                   	push   %eax
  80073e:	e8 29 16 00 00       	call   801d6c <free>
  800743:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800746:	e8 1b 19 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  80074b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80074e:	74 17                	je     800767 <_main+0x72f>
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	68 c8 3e 80 00       	push   $0x803ec8
  800758:	68 97 00 00 00       	push   $0x97
  80075d:	68 1c 3e 80 00       	push   $0x803e1c
  800762:	e8 4e 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  800767:	8b 45 90             	mov    -0x70(%ebp),%eax
  80076a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80076d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800770:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800773:	e8 cd 1b 00 00       	call   802345 <sys_rcr2>
  800778:	89 c2                	mov    %eax,%edx
  80077a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	74 17                	je     800798 <_main+0x760>
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	68 04 3f 80 00       	push   $0x803f04
  800789:	68 9b 00 00 00       	push   $0x9b
  80078e:	68 1c 3e 80 00       	push   $0x803e1c
  800793:	e8 1d 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[4]] = 10;
  800798:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80079e:	89 c2                	mov    %eax,%edx
  8007a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a3:	01 d0                	add    %edx,%eax
  8007a5:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007a8:	e8 98 1b 00 00       	call   802345 <sys_rcr2>
  8007ad:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  8007b3:	89 d1                	mov    %edx,%ecx
  8007b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007b8:	01 ca                	add    %ecx,%edx
  8007ba:	39 d0                	cmp    %edx,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 04 3f 80 00       	push   $0x803f04
  8007c6:	68 9d 00 00 00       	push   $0x9d
  8007cb:	68 1c 3e 80 00       	push   $0x803e1c
  8007d0:	e8 e0 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8007d5:	e8 ec 17 00 00       	call   801fc6 <sys_calculate_free_frames>
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007dd:	e8 84 18 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  8007e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  8007e5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	50                   	push   %eax
  8007ec:	e8 7b 15 00 00       	call   801d6c <free>
  8007f1:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  8007f4:	e8 6d 18 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  8007f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8007fc:	74 17                	je     800815 <_main+0x7dd>
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	68 c8 3e 80 00       	push   $0x803ec8
  800806:	68 a2 00 00 00       	push   $0xa2
  80080b:	68 1c 3e 80 00       	push   $0x803e1c
  800810:	e8 a0 02 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  800815:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800818:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80081b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80081e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800821:	e8 1f 1b 00 00       	call   802345 <sys_rcr2>
  800826:	89 c2                	mov    %eax,%edx
  800828:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80082b:	39 c2                	cmp    %eax,%edx
  80082d:	74 17                	je     800846 <_main+0x80e>
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 04 3f 80 00       	push   $0x803f04
  800837:	68 a6 00 00 00       	push   $0xa6
  80083c:	68 1c 3e 80 00       	push   $0x803e1c
  800841:	e8 6f 02 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[5]] = 10;
  800846:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800856:	e8 ea 1a 00 00       	call   802345 <sys_rcr2>
  80085b:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  800861:	89 d1                	mov    %edx,%ecx
  800863:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800866:	01 ca                	add    %ecx,%edx
  800868:	39 d0                	cmp    %edx,%eax
  80086a:	74 17                	je     800883 <_main+0x84b>
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	68 04 3f 80 00       	push   $0x803f04
  800874:	68 a8 00 00 00       	push   $0xa8
  800879:	68 1c 3e 80 00       	push   $0x803e1c
  80087e:	e8 32 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800883:	e8 3e 17 00 00       	call   801fc6 <sys_calculate_free_frames>
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80088b:	e8 d6 17 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  800890:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  800893:	8b 45 98             	mov    -0x68(%ebp),%eax
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	50                   	push   %eax
  80089a:	e8 cd 14 00 00       	call   801d6c <free>
  80089f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8008a2:	e8 bf 17 00 00       	call   802066 <sys_pf_calculate_allocated_pages>
  8008a7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8008aa:	74 17                	je     8008c3 <_main+0x88b>
  8008ac:	83 ec 04             	sub    $0x4,%esp
  8008af:	68 c8 3e 80 00       	push   $0x803ec8
  8008b4:	68 ad 00 00 00       	push   $0xad
  8008b9:	68 1c 3e 80 00       	push   $0x803e1c
  8008be:	e8 f2 01 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  8008c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8008c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008cc:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8008cf:	e8 71 1a 00 00       	call   802345 <sys_rcr2>
  8008d4:	89 c2                	mov    %eax,%edx
  8008d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008d9:	39 c2                	cmp    %eax,%edx
  8008db:	74 17                	je     8008f4 <_main+0x8bc>
  8008dd:	83 ec 04             	sub    $0x4,%esp
  8008e0:	68 04 3f 80 00       	push   $0x803f04
  8008e5:	68 b1 00 00 00       	push   $0xb1
  8008ea:	68 1c 3e 80 00       	push   $0x803e1c
  8008ef:	e8 c1 01 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[6]] = 10;
  8008f4:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8008fa:	89 c2                	mov    %eax,%edx
  8008fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008ff:	01 d0                	add    %edx,%eax
  800901:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800904:	e8 3c 1a 00 00       	call   802345 <sys_rcr2>
  800909:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  80090f:	89 d1                	mov    %edx,%ecx
  800911:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800914:	01 ca                	add    %ecx,%edx
  800916:	39 d0                	cmp    %edx,%eax
  800918:	74 17                	je     800931 <_main+0x8f9>
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	68 04 3f 80 00       	push   $0x803f04
  800922:	68 b3 00 00 00       	push   $0xb3
  800927:	68 1c 3e 80 00       	push   $0x803e1c
  80092c:	e8 84 01 00 00       	call   800ab5 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames()) ) {panic("Wrong free: not all pages removed correctly at end");}
  800931:	e8 90 16 00 00       	call   801fc6 <sys_calculate_free_frames>
  800936:	89 c2                	mov    %eax,%edx
  800938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80093b:	39 c2                	cmp    %eax,%edx
  80093d:	74 17                	je     800956 <_main+0x91e>
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	68 48 3f 80 00       	push   $0x803f48
  800947:	68 b5 00 00 00       	push   $0xb5
  80094c:	68 1c 3e 80 00       	push   $0x803e1c
  800951:	e8 5f 01 00 00       	call   800ab5 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  800956:	83 ec 0c             	sub    $0xc,%esp
  800959:	6a 00                	push   $0x0
  80095b:	e8 fe 19 00 00       	call   80235e <sys_bypassPageFault>
  800960:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  800963:	83 ec 0c             	sub    $0xc,%esp
  800966:	68 7c 3f 80 00       	push   $0x803f7c
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
  80097f:	e8 22 19 00 00       	call   8022a6 <sys_getenvindex>
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
  8009ea:	e8 c4 16 00 00       	call   8020b3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009ef:	83 ec 0c             	sub    $0xc,%esp
  8009f2:	68 d0 3f 80 00       	push   $0x803fd0
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
  800a1a:	68 f8 3f 80 00       	push   $0x803ff8
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
  800a4b:	68 20 40 80 00       	push   $0x804020
  800a50:	e8 14 03 00 00       	call   800d69 <cprintf>
  800a55:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a58:	a1 20 50 80 00       	mov    0x805020,%eax
  800a5d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	50                   	push   %eax
  800a67:	68 78 40 80 00       	push   $0x804078
  800a6c:	e8 f8 02 00 00       	call   800d69 <cprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	68 d0 3f 80 00       	push   $0x803fd0
  800a7c:	e8 e8 02 00 00       	call   800d69 <cprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a84:	e8 44 16 00 00       	call   8020cd <sys_enable_interrupt>

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
  800a9c:	e8 d1 17 00 00       	call   802272 <sys_destroy_env>
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
  800aad:	e8 26 18 00 00       	call   8022d8 <sys_exit_env>
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
  800ad6:	68 8c 40 80 00       	push   $0x80408c
  800adb:	e8 89 02 00 00       	call   800d69 <cprintf>
  800ae0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ae3:	a1 00 50 80 00       	mov    0x805000,%eax
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	50                   	push   %eax
  800aef:	68 91 40 80 00       	push   $0x804091
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
  800b13:	68 ad 40 80 00       	push   $0x8040ad
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
  800b3f:	68 b0 40 80 00       	push   $0x8040b0
  800b44:	6a 26                	push   $0x26
  800b46:	68 fc 40 80 00       	push   $0x8040fc
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
  800c11:	68 08 41 80 00       	push   $0x804108
  800c16:	6a 3a                	push   $0x3a
  800c18:	68 fc 40 80 00       	push   $0x8040fc
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
  800c81:	68 5c 41 80 00       	push   $0x80415c
  800c86:	6a 44                	push   $0x44
  800c88:	68 fc 40 80 00       	push   $0x8040fc
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
  800cdb:	e8 25 12 00 00       	call   801f05 <sys_cputs>
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
  800d52:	e8 ae 11 00 00       	call   801f05 <sys_cputs>
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
  800d9c:	e8 12 13 00 00       	call   8020b3 <sys_disable_interrupt>
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
  800dbc:	e8 0c 13 00 00       	call   8020cd <sys_enable_interrupt>
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
  800e06:	e8 7d 2d 00 00       	call   803b88 <__udivdi3>
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
  800e56:	e8 3d 2e 00 00       	call   803c98 <__umoddi3>
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	05 d4 43 80 00       	add    $0x8043d4,%eax
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
  800fb1:	8b 04 85 f8 43 80 00 	mov    0x8043f8(,%eax,4),%eax
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
  801092:	8b 34 9d 40 42 80 00 	mov    0x804240(,%ebx,4),%esi
  801099:	85 f6                	test   %esi,%esi
  80109b:	75 19                	jne    8010b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80109d:	53                   	push   %ebx
  80109e:	68 e5 43 80 00       	push   $0x8043e5
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
  8010b7:	68 ee 43 80 00       	push   $0x8043ee
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
  8010e4:	be f1 43 80 00       	mov    $0x8043f1,%esi
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
  801b0a:	68 50 45 80 00       	push   $0x804550
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
  801bda:	e8 6a 04 00 00       	call   802049 <sys_allocate_chunk>
  801bdf:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801be2:	a1 20 51 80 00       	mov    0x805120,%eax
  801be7:	83 ec 0c             	sub    $0xc,%esp
  801bea:	50                   	push   %eax
  801beb:	e8 df 0a 00 00       	call   8026cf <initialize_MemBlocksList>
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
  801c18:	68 75 45 80 00       	push   $0x804575
  801c1d:	6a 33                	push   $0x33
  801c1f:	68 93 45 80 00       	push   $0x804593
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
  801c97:	68 a0 45 80 00       	push   $0x8045a0
  801c9c:	6a 34                	push   $0x34
  801c9e:	68 93 45 80 00       	push   $0x804593
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
  801d2f:	e8 e3 06 00 00       	call   802417 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d34:	85 c0                	test   %eax,%eax
  801d36:	74 11                	je     801d49 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801d38:	83 ec 0c             	sub    $0xc,%esp
  801d3b:	ff 75 e8             	pushl  -0x18(%ebp)
  801d3e:	e8 4e 0d 00 00       	call   802a91 <alloc_block_FF>
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
  801d55:	e8 aa 0a 00 00       	call   802804 <insert_sorted_allocList>
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
  801d6f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801d72:	83 ec 04             	sub    $0x4,%esp
  801d75:	68 c4 45 80 00       	push   $0x8045c4
  801d7a:	6a 6f                	push   $0x6f
  801d7c:	68 93 45 80 00       	push   $0x804593
  801d81:	e8 2f ed ff ff       	call   800ab5 <_panic>

00801d86 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 38             	sub    $0x38,%esp
  801d8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d8f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d92:	e8 5c fd ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d9b:	75 07                	jne    801da4 <smalloc+0x1e>
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801da2:	eb 7c                	jmp    801e20 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801da4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801dab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db1:	01 d0                	add    %edx,%eax
  801db3:	48                   	dec    %eax
  801db4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dba:	ba 00 00 00 00       	mov    $0x0,%edx
  801dbf:	f7 75 f0             	divl   -0x10(%ebp)
  801dc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc5:	29 d0                	sub    %edx,%eax
  801dc7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801dca:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801dd1:	e8 41 06 00 00       	call   802417 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	74 11                	je     801deb <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801dda:	83 ec 0c             	sub    $0xc,%esp
  801ddd:	ff 75 e8             	pushl  -0x18(%ebp)
  801de0:	e8 ac 0c 00 00       	call   802a91 <alloc_block_FF>
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801deb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801def:	74 2a                	je     801e1b <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df4:	8b 40 08             	mov    0x8(%eax),%eax
  801df7:	89 c2                	mov    %eax,%edx
  801df9:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801dfd:	52                   	push   %edx
  801dfe:	50                   	push   %eax
  801dff:	ff 75 0c             	pushl  0xc(%ebp)
  801e02:	ff 75 08             	pushl  0x8(%ebp)
  801e05:	e8 92 03 00 00       	call   80219c <sys_createSharedObject>
  801e0a:	83 c4 10             	add    $0x10,%esp
  801e0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801e10:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801e14:	74 05                	je     801e1b <smalloc+0x95>
			return (void*)virtual_address;
  801e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e19:	eb 05                	jmp    801e20 <smalloc+0x9a>
	}
	return NULL;
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e28:	e8 c6 fc ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e2d:	83 ec 04             	sub    $0x4,%esp
  801e30:	68 e8 45 80 00       	push   $0x8045e8
  801e35:	68 b0 00 00 00       	push   $0xb0
  801e3a:	68 93 45 80 00       	push   $0x804593
  801e3f:	e8 71 ec ff ff       	call   800ab5 <_panic>

00801e44 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e4a:	e8 a4 fc ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e4f:	83 ec 04             	sub    $0x4,%esp
  801e52:	68 0c 46 80 00       	push   $0x80460c
  801e57:	68 f4 00 00 00       	push   $0xf4
  801e5c:	68 93 45 80 00       	push   $0x804593
  801e61:	e8 4f ec ff ff       	call   800ab5 <_panic>

00801e66 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e6c:	83 ec 04             	sub    $0x4,%esp
  801e6f:	68 34 46 80 00       	push   $0x804634
  801e74:	68 08 01 00 00       	push   $0x108
  801e79:	68 93 45 80 00       	push   $0x804593
  801e7e:	e8 32 ec ff ff       	call   800ab5 <_panic>

00801e83 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e89:	83 ec 04             	sub    $0x4,%esp
  801e8c:	68 58 46 80 00       	push   $0x804658
  801e91:	68 13 01 00 00       	push   $0x113
  801e96:	68 93 45 80 00       	push   $0x804593
  801e9b:	e8 15 ec ff ff       	call   800ab5 <_panic>

00801ea0 <shrink>:

}
void shrink(uint32 newSize)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ea6:	83 ec 04             	sub    $0x4,%esp
  801ea9:	68 58 46 80 00       	push   $0x804658
  801eae:	68 18 01 00 00       	push   $0x118
  801eb3:	68 93 45 80 00       	push   $0x804593
  801eb8:	e8 f8 eb ff ff       	call   800ab5 <_panic>

00801ebd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	68 58 46 80 00       	push   $0x804658
  801ecb:	68 1d 01 00 00       	push   $0x11d
  801ed0:	68 93 45 80 00       	push   $0x804593
  801ed5:	e8 db eb ff ff       	call   800ab5 <_panic>

00801eda <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	57                   	push   %edi
  801ede:	56                   	push   %esi
  801edf:	53                   	push   %ebx
  801ee0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eef:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ef2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ef5:	cd 30                	int    $0x30
  801ef7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801efd:	83 c4 10             	add    $0x10,%esp
  801f00:	5b                   	pop    %ebx
  801f01:	5e                   	pop    %esi
  801f02:	5f                   	pop    %edi
  801f03:	5d                   	pop    %ebp
  801f04:	c3                   	ret    

00801f05 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 04             	sub    $0x4,%esp
  801f0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f11:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	52                   	push   %edx
  801f1d:	ff 75 0c             	pushl  0xc(%ebp)
  801f20:	50                   	push   %eax
  801f21:	6a 00                	push   $0x0
  801f23:	e8 b2 ff ff ff       	call   801eda <syscall>
  801f28:	83 c4 18             	add    $0x18,%esp
}
  801f2b:	90                   	nop
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <sys_cgetc>:

int
sys_cgetc(void)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 01                	push   $0x1
  801f3d:	e8 98 ff ff ff       	call   801eda <syscall>
  801f42:	83 c4 18             	add    $0x18,%esp
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	52                   	push   %edx
  801f57:	50                   	push   %eax
  801f58:	6a 05                	push   $0x5
  801f5a:	e8 7b ff ff ff       	call   801eda <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	56                   	push   %esi
  801f68:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f69:	8b 75 18             	mov    0x18(%ebp),%esi
  801f6c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	56                   	push   %esi
  801f79:	53                   	push   %ebx
  801f7a:	51                   	push   %ecx
  801f7b:	52                   	push   %edx
  801f7c:	50                   	push   %eax
  801f7d:	6a 06                	push   $0x6
  801f7f:	e8 56 ff ff ff       	call   801eda <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
}
  801f87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f8a:	5b                   	pop    %ebx
  801f8b:	5e                   	pop    %esi
  801f8c:	5d                   	pop    %ebp
  801f8d:	c3                   	ret    

00801f8e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	52                   	push   %edx
  801f9e:	50                   	push   %eax
  801f9f:	6a 07                	push   $0x7
  801fa1:	e8 34 ff ff ff       	call   801eda <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	ff 75 0c             	pushl  0xc(%ebp)
  801fb7:	ff 75 08             	pushl  0x8(%ebp)
  801fba:	6a 08                	push   $0x8
  801fbc:	e8 19 ff ff ff       	call   801eda <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 09                	push   $0x9
  801fd5:	e8 00 ff ff ff       	call   801eda <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 0a                	push   $0xa
  801fee:	e8 e7 fe ff ff       	call   801eda <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 0b                	push   $0xb
  802007:	e8 ce fe ff ff       	call   801eda <syscall>
  80200c:	83 c4 18             	add    $0x18,%esp
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	ff 75 0c             	pushl  0xc(%ebp)
  80201d:	ff 75 08             	pushl  0x8(%ebp)
  802020:	6a 0f                	push   $0xf
  802022:	e8 b3 fe ff ff       	call   801eda <syscall>
  802027:	83 c4 18             	add    $0x18,%esp
	return;
  80202a:	90                   	nop
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	ff 75 0c             	pushl  0xc(%ebp)
  802039:	ff 75 08             	pushl  0x8(%ebp)
  80203c:	6a 10                	push   $0x10
  80203e:	e8 97 fe ff ff       	call   801eda <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
	return ;
  802046:	90                   	nop
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	ff 75 10             	pushl  0x10(%ebp)
  802053:	ff 75 0c             	pushl  0xc(%ebp)
  802056:	ff 75 08             	pushl  0x8(%ebp)
  802059:	6a 11                	push   $0x11
  80205b:	e8 7a fe ff ff       	call   801eda <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
	return ;
  802063:	90                   	nop
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 0c                	push   $0xc
  802075:	e8 60 fe ff ff       	call   801eda <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	ff 75 08             	pushl  0x8(%ebp)
  80208d:	6a 0d                	push   $0xd
  80208f:	e8 46 fe ff ff       	call   801eda <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 0e                	push   $0xe
  8020a8:	e8 2d fe ff ff       	call   801eda <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
}
  8020b0:	90                   	nop
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 13                	push   $0x13
  8020c2:	e8 13 fe ff ff       	call   801eda <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
}
  8020ca:	90                   	nop
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 14                	push   $0x14
  8020dc:	e8 f9 fd ff ff       	call   801eda <syscall>
  8020e1:	83 c4 18             	add    $0x18,%esp
}
  8020e4:	90                   	nop
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	83 ec 04             	sub    $0x4,%esp
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020f3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	50                   	push   %eax
  802100:	6a 15                	push   $0x15
  802102:	e8 d3 fd ff ff       	call   801eda <syscall>
  802107:	83 c4 18             	add    $0x18,%esp
}
  80210a:	90                   	nop
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 16                	push   $0x16
  80211c:	e8 b9 fd ff ff       	call   801eda <syscall>
  802121:	83 c4 18             	add    $0x18,%esp
}
  802124:	90                   	nop
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	ff 75 0c             	pushl  0xc(%ebp)
  802136:	50                   	push   %eax
  802137:	6a 17                	push   $0x17
  802139:	e8 9c fd ff ff       	call   801eda <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802146:	8b 55 0c             	mov    0xc(%ebp),%edx
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	52                   	push   %edx
  802153:	50                   	push   %eax
  802154:	6a 1a                	push   $0x1a
  802156:	e8 7f fd ff ff       	call   801eda <syscall>
  80215b:	83 c4 18             	add    $0x18,%esp
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802163:	8b 55 0c             	mov    0xc(%ebp),%edx
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	52                   	push   %edx
  802170:	50                   	push   %eax
  802171:	6a 18                	push   $0x18
  802173:	e8 62 fd ff ff       	call   801eda <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
}
  80217b:	90                   	nop
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802181:	8b 55 0c             	mov    0xc(%ebp),%edx
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	52                   	push   %edx
  80218e:	50                   	push   %eax
  80218f:	6a 19                	push   $0x19
  802191:	e8 44 fd ff ff       	call   801eda <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
}
  802199:	90                   	nop
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	83 ec 04             	sub    $0x4,%esp
  8021a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021a8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021ab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	6a 00                	push   $0x0
  8021b4:	51                   	push   %ecx
  8021b5:	52                   	push   %edx
  8021b6:	ff 75 0c             	pushl  0xc(%ebp)
  8021b9:	50                   	push   %eax
  8021ba:	6a 1b                	push   $0x1b
  8021bc:	e8 19 fd ff ff       	call   801eda <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	52                   	push   %edx
  8021d6:	50                   	push   %eax
  8021d7:	6a 1c                	push   $0x1c
  8021d9:	e8 fc fc ff ff       	call   801eda <syscall>
  8021de:	83 c4 18             	add    $0x18,%esp
}
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	51                   	push   %ecx
  8021f4:	52                   	push   %edx
  8021f5:	50                   	push   %eax
  8021f6:	6a 1d                	push   $0x1d
  8021f8:	e8 dd fc ff ff       	call   801eda <syscall>
  8021fd:	83 c4 18             	add    $0x18,%esp
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802205:	8b 55 0c             	mov    0xc(%ebp),%edx
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	52                   	push   %edx
  802212:	50                   	push   %eax
  802213:	6a 1e                	push   $0x1e
  802215:	e8 c0 fc ff ff       	call   801eda <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 1f                	push   $0x1f
  80222e:	e8 a7 fc ff ff       	call   801eda <syscall>
  802233:	83 c4 18             	add    $0x18,%esp
}
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	6a 00                	push   $0x0
  802240:	ff 75 14             	pushl  0x14(%ebp)
  802243:	ff 75 10             	pushl  0x10(%ebp)
  802246:	ff 75 0c             	pushl  0xc(%ebp)
  802249:	50                   	push   %eax
  80224a:	6a 20                	push   $0x20
  80224c:	e8 89 fc ff ff       	call   801eda <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	50                   	push   %eax
  802265:	6a 21                	push   $0x21
  802267:	e8 6e fc ff ff       	call   801eda <syscall>
  80226c:	83 c4 18             	add    $0x18,%esp
}
  80226f:	90                   	nop
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	50                   	push   %eax
  802281:	6a 22                	push   $0x22
  802283:	e8 52 fc ff ff       	call   801eda <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 02                	push   $0x2
  80229c:	e8 39 fc ff ff       	call   801eda <syscall>
  8022a1:	83 c4 18             	add    $0x18,%esp
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 03                	push   $0x3
  8022b5:	e8 20 fc ff ff       	call   801eda <syscall>
  8022ba:	83 c4 18             	add    $0x18,%esp
}
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 04                	push   $0x4
  8022ce:	e8 07 fc ff ff       	call   801eda <syscall>
  8022d3:	83 c4 18             	add    $0x18,%esp
}
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    

008022d8 <sys_exit_env>:


void sys_exit_env(void)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 23                	push   $0x23
  8022e7:	e8 ee fb ff ff       	call   801eda <syscall>
  8022ec:	83 c4 18             	add    $0x18,%esp
}
  8022ef:	90                   	nop
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    

008022f2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
  8022f5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022f8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022fb:	8d 50 04             	lea    0x4(%eax),%edx
  8022fe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	52                   	push   %edx
  802308:	50                   	push   %eax
  802309:	6a 24                	push   $0x24
  80230b:	e8 ca fb ff ff       	call   801eda <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
	return result;
  802313:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802316:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802319:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80231c:	89 01                	mov    %eax,(%ecx)
  80231e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	c9                   	leave  
  802325:	c2 04 00             	ret    $0x4

00802328 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	ff 75 10             	pushl  0x10(%ebp)
  802332:	ff 75 0c             	pushl  0xc(%ebp)
  802335:	ff 75 08             	pushl  0x8(%ebp)
  802338:	6a 12                	push   $0x12
  80233a:	e8 9b fb ff ff       	call   801eda <syscall>
  80233f:	83 c4 18             	add    $0x18,%esp
	return ;
  802342:	90                   	nop
}
  802343:	c9                   	leave  
  802344:	c3                   	ret    

00802345 <sys_rcr2>:
uint32 sys_rcr2()
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	6a 25                	push   $0x25
  802354:	e8 81 fb ff ff       	call   801eda <syscall>
  802359:	83 c4 18             	add    $0x18,%esp
}
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    

0080235e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
  802361:	83 ec 04             	sub    $0x4,%esp
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80236a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	50                   	push   %eax
  802377:	6a 26                	push   $0x26
  802379:	e8 5c fb ff ff       	call   801eda <syscall>
  80237e:	83 c4 18             	add    $0x18,%esp
	return ;
  802381:	90                   	nop
}
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <rsttst>:
void rsttst()
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 28                	push   $0x28
  802393:	e8 42 fb ff ff       	call   801eda <syscall>
  802398:	83 c4 18             	add    $0x18,%esp
	return ;
  80239b:	90                   	nop
}
  80239c:	c9                   	leave  
  80239d:	c3                   	ret    

0080239e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	83 ec 04             	sub    $0x4,%esp
  8023a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023aa:	8b 55 18             	mov    0x18(%ebp),%edx
  8023ad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023b1:	52                   	push   %edx
  8023b2:	50                   	push   %eax
  8023b3:	ff 75 10             	pushl  0x10(%ebp)
  8023b6:	ff 75 0c             	pushl  0xc(%ebp)
  8023b9:	ff 75 08             	pushl  0x8(%ebp)
  8023bc:	6a 27                	push   $0x27
  8023be:	e8 17 fb ff ff       	call   801eda <syscall>
  8023c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c6:	90                   	nop
}
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <chktst>:
void chktst(uint32 n)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	ff 75 08             	pushl  0x8(%ebp)
  8023d7:	6a 29                	push   $0x29
  8023d9:	e8 fc fa ff ff       	call   801eda <syscall>
  8023de:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e1:	90                   	nop
}
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    

008023e4 <inctst>:

void inctst()
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 2a                	push   $0x2a
  8023f3:	e8 e2 fa ff ff       	call   801eda <syscall>
  8023f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8023fb:	90                   	nop
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <gettst>:
uint32 gettst()
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 2b                	push   $0x2b
  80240d:	e8 c8 fa ff ff       	call   801eda <syscall>
  802412:	83 c4 18             	add    $0x18,%esp
}
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
  80241a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 2c                	push   $0x2c
  802429:	e8 ac fa ff ff       	call   801eda <syscall>
  80242e:	83 c4 18             	add    $0x18,%esp
  802431:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802434:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802438:	75 07                	jne    802441 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80243a:	b8 01 00 00 00       	mov    $0x1,%eax
  80243f:	eb 05                	jmp    802446 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802441:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802446:	c9                   	leave  
  802447:	c3                   	ret    

00802448 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802448:	55                   	push   %ebp
  802449:	89 e5                	mov    %esp,%ebp
  80244b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 2c                	push   $0x2c
  80245a:	e8 7b fa ff ff       	call   801eda <syscall>
  80245f:	83 c4 18             	add    $0x18,%esp
  802462:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802465:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802469:	75 07                	jne    802472 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80246b:	b8 01 00 00 00       	mov    $0x1,%eax
  802470:	eb 05                	jmp    802477 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802472:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802477:	c9                   	leave  
  802478:	c3                   	ret    

00802479 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802479:	55                   	push   %ebp
  80247a:	89 e5                	mov    %esp,%ebp
  80247c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 2c                	push   $0x2c
  80248b:	e8 4a fa ff ff       	call   801eda <syscall>
  802490:	83 c4 18             	add    $0x18,%esp
  802493:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802496:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80249a:	75 07                	jne    8024a3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80249c:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a1:	eb 05                	jmp    8024a8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a8:	c9                   	leave  
  8024a9:	c3                   	ret    

008024aa <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 2c                	push   $0x2c
  8024bc:	e8 19 fa ff ff       	call   801eda <syscall>
  8024c1:	83 c4 18             	add    $0x18,%esp
  8024c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024c7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024cb:	75 07                	jne    8024d4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d2:	eb 05                	jmp    8024d9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d9:	c9                   	leave  
  8024da:	c3                   	ret    

008024db <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	ff 75 08             	pushl  0x8(%ebp)
  8024e9:	6a 2d                	push   $0x2d
  8024eb:	e8 ea f9 ff ff       	call   801eda <syscall>
  8024f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f3:	90                   	nop
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
  8024f9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024fa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802500:	8b 55 0c             	mov    0xc(%ebp),%edx
  802503:	8b 45 08             	mov    0x8(%ebp),%eax
  802506:	6a 00                	push   $0x0
  802508:	53                   	push   %ebx
  802509:	51                   	push   %ecx
  80250a:	52                   	push   %edx
  80250b:	50                   	push   %eax
  80250c:	6a 2e                	push   $0x2e
  80250e:	e8 c7 f9 ff ff       	call   801eda <syscall>
  802513:	83 c4 18             	add    $0x18,%esp
}
  802516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80251e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802521:	8b 45 08             	mov    0x8(%ebp),%eax
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	52                   	push   %edx
  80252b:	50                   	push   %eax
  80252c:	6a 2f                	push   $0x2f
  80252e:	e8 a7 f9 ff ff       	call   801eda <syscall>
  802533:	83 c4 18             	add    $0x18,%esp
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80253e:	83 ec 0c             	sub    $0xc,%esp
  802541:	68 68 46 80 00       	push   $0x804668
  802546:	e8 1e e8 ff ff       	call   800d69 <cprintf>
  80254b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80254e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802555:	83 ec 0c             	sub    $0xc,%esp
  802558:	68 94 46 80 00       	push   $0x804694
  80255d:	e8 07 e8 ff ff       	call   800d69 <cprintf>
  802562:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802565:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802569:	a1 38 51 80 00       	mov    0x805138,%eax
  80256e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802571:	eb 56                	jmp    8025c9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802573:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802577:	74 1c                	je     802595 <print_mem_block_lists+0x5d>
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 50 08             	mov    0x8(%eax),%edx
  80257f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802582:	8b 48 08             	mov    0x8(%eax),%ecx
  802585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802588:	8b 40 0c             	mov    0xc(%eax),%eax
  80258b:	01 c8                	add    %ecx,%eax
  80258d:	39 c2                	cmp    %eax,%edx
  80258f:	73 04                	jae    802595 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802591:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 50 08             	mov    0x8(%eax),%edx
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a1:	01 c2                	add    %eax,%edx
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	8b 40 08             	mov    0x8(%eax),%eax
  8025a9:	83 ec 04             	sub    $0x4,%esp
  8025ac:	52                   	push   %edx
  8025ad:	50                   	push   %eax
  8025ae:	68 a9 46 80 00       	push   $0x8046a9
  8025b3:	e8 b1 e7 ff ff       	call   800d69 <cprintf>
  8025b8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025c1:	a1 40 51 80 00       	mov    0x805140,%eax
  8025c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cd:	74 07                	je     8025d6 <print_mem_block_lists+0x9e>
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	eb 05                	jmp    8025db <print_mem_block_lists+0xa3>
  8025d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025db:	a3 40 51 80 00       	mov    %eax,0x805140
  8025e0:	a1 40 51 80 00       	mov    0x805140,%eax
  8025e5:	85 c0                	test   %eax,%eax
  8025e7:	75 8a                	jne    802573 <print_mem_block_lists+0x3b>
  8025e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ed:	75 84                	jne    802573 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025ef:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025f3:	75 10                	jne    802605 <print_mem_block_lists+0xcd>
  8025f5:	83 ec 0c             	sub    $0xc,%esp
  8025f8:	68 b8 46 80 00       	push   $0x8046b8
  8025fd:	e8 67 e7 ff ff       	call   800d69 <cprintf>
  802602:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802605:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80260c:	83 ec 0c             	sub    $0xc,%esp
  80260f:	68 dc 46 80 00       	push   $0x8046dc
  802614:	e8 50 e7 ff ff       	call   800d69 <cprintf>
  802619:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80261c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802620:	a1 40 50 80 00       	mov    0x805040,%eax
  802625:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802628:	eb 56                	jmp    802680 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80262a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80262e:	74 1c                	je     80264c <print_mem_block_lists+0x114>
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 50 08             	mov    0x8(%eax),%edx
  802636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802639:	8b 48 08             	mov    0x8(%eax),%ecx
  80263c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263f:	8b 40 0c             	mov    0xc(%eax),%eax
  802642:	01 c8                	add    %ecx,%eax
  802644:	39 c2                	cmp    %eax,%edx
  802646:	73 04                	jae    80264c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802648:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 50 08             	mov    0x8(%eax),%edx
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 40 0c             	mov    0xc(%eax),%eax
  802658:	01 c2                	add    %eax,%edx
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 40 08             	mov    0x8(%eax),%eax
  802660:	83 ec 04             	sub    $0x4,%esp
  802663:	52                   	push   %edx
  802664:	50                   	push   %eax
  802665:	68 a9 46 80 00       	push   $0x8046a9
  80266a:	e8 fa e6 ff ff       	call   800d69 <cprintf>
  80266f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802678:	a1 48 50 80 00       	mov    0x805048,%eax
  80267d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802680:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802684:	74 07                	je     80268d <print_mem_block_lists+0x155>
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	eb 05                	jmp    802692 <print_mem_block_lists+0x15a>
  80268d:	b8 00 00 00 00       	mov    $0x0,%eax
  802692:	a3 48 50 80 00       	mov    %eax,0x805048
  802697:	a1 48 50 80 00       	mov    0x805048,%eax
  80269c:	85 c0                	test   %eax,%eax
  80269e:	75 8a                	jne    80262a <print_mem_block_lists+0xf2>
  8026a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a4:	75 84                	jne    80262a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026a6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026aa:	75 10                	jne    8026bc <print_mem_block_lists+0x184>
  8026ac:	83 ec 0c             	sub    $0xc,%esp
  8026af:	68 f4 46 80 00       	push   $0x8046f4
  8026b4:	e8 b0 e6 ff ff       	call   800d69 <cprintf>
  8026b9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026bc:	83 ec 0c             	sub    $0xc,%esp
  8026bf:	68 68 46 80 00       	push   $0x804668
  8026c4:	e8 a0 e6 ff ff       	call   800d69 <cprintf>
  8026c9:	83 c4 10             	add    $0x10,%esp

}
  8026cc:	90                   	nop
  8026cd:	c9                   	leave  
  8026ce:	c3                   	ret    

008026cf <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
  8026d2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8026d5:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026dc:	00 00 00 
  8026df:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026e6:	00 00 00 
  8026e9:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026f0:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8026f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026fa:	e9 9e 00 00 00       	jmp    80279d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8026ff:	a1 50 50 80 00       	mov    0x805050,%eax
  802704:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802707:	c1 e2 04             	shl    $0x4,%edx
  80270a:	01 d0                	add    %edx,%eax
  80270c:	85 c0                	test   %eax,%eax
  80270e:	75 14                	jne    802724 <initialize_MemBlocksList+0x55>
  802710:	83 ec 04             	sub    $0x4,%esp
  802713:	68 1c 47 80 00       	push   $0x80471c
  802718:	6a 46                	push   $0x46
  80271a:	68 3f 47 80 00       	push   $0x80473f
  80271f:	e8 91 e3 ff ff       	call   800ab5 <_panic>
  802724:	a1 50 50 80 00       	mov    0x805050,%eax
  802729:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272c:	c1 e2 04             	shl    $0x4,%edx
  80272f:	01 d0                	add    %edx,%eax
  802731:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802737:	89 10                	mov    %edx,(%eax)
  802739:	8b 00                	mov    (%eax),%eax
  80273b:	85 c0                	test   %eax,%eax
  80273d:	74 18                	je     802757 <initialize_MemBlocksList+0x88>
  80273f:	a1 48 51 80 00       	mov    0x805148,%eax
  802744:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80274a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80274d:	c1 e1 04             	shl    $0x4,%ecx
  802750:	01 ca                	add    %ecx,%edx
  802752:	89 50 04             	mov    %edx,0x4(%eax)
  802755:	eb 12                	jmp    802769 <initialize_MemBlocksList+0x9a>
  802757:	a1 50 50 80 00       	mov    0x805050,%eax
  80275c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275f:	c1 e2 04             	shl    $0x4,%edx
  802762:	01 d0                	add    %edx,%eax
  802764:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802769:	a1 50 50 80 00       	mov    0x805050,%eax
  80276e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802771:	c1 e2 04             	shl    $0x4,%edx
  802774:	01 d0                	add    %edx,%eax
  802776:	a3 48 51 80 00       	mov    %eax,0x805148
  80277b:	a1 50 50 80 00       	mov    0x805050,%eax
  802780:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802783:	c1 e2 04             	shl    $0x4,%edx
  802786:	01 d0                	add    %edx,%eax
  802788:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278f:	a1 54 51 80 00       	mov    0x805154,%eax
  802794:	40                   	inc    %eax
  802795:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80279a:	ff 45 f4             	incl   -0xc(%ebp)
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a3:	0f 82 56 ff ff ff    	jb     8026ff <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8027a9:	90                   	nop
  8027aa:	c9                   	leave  
  8027ab:	c3                   	ret    

008027ac <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027ac:	55                   	push   %ebp
  8027ad:	89 e5                	mov    %esp,%ebp
  8027af:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b5:	8b 00                	mov    (%eax),%eax
  8027b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027ba:	eb 19                	jmp    8027d5 <find_block+0x29>
	{
		if(va==point->sva)
  8027bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027bf:	8b 40 08             	mov    0x8(%eax),%eax
  8027c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027c5:	75 05                	jne    8027cc <find_block+0x20>
		   return point;
  8027c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027ca:	eb 36                	jmp    802802 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cf:	8b 40 08             	mov    0x8(%eax),%eax
  8027d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027d9:	74 07                	je     8027e2 <find_block+0x36>
  8027db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	eb 05                	jmp    8027e7 <find_block+0x3b>
  8027e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ea:	89 42 08             	mov    %eax,0x8(%edx)
  8027ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f0:	8b 40 08             	mov    0x8(%eax),%eax
  8027f3:	85 c0                	test   %eax,%eax
  8027f5:	75 c5                	jne    8027bc <find_block+0x10>
  8027f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027fb:	75 bf                	jne    8027bc <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8027fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802802:	c9                   	leave  
  802803:	c3                   	ret    

00802804 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802804:	55                   	push   %ebp
  802805:	89 e5                	mov    %esp,%ebp
  802807:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80280a:	a1 40 50 80 00       	mov    0x805040,%eax
  80280f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802812:	a1 44 50 80 00       	mov    0x805044,%eax
  802817:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80281a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802820:	74 24                	je     802846 <insert_sorted_allocList+0x42>
  802822:	8b 45 08             	mov    0x8(%ebp),%eax
  802825:	8b 50 08             	mov    0x8(%eax),%edx
  802828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282b:	8b 40 08             	mov    0x8(%eax),%eax
  80282e:	39 c2                	cmp    %eax,%edx
  802830:	76 14                	jbe    802846 <insert_sorted_allocList+0x42>
  802832:	8b 45 08             	mov    0x8(%ebp),%eax
  802835:	8b 50 08             	mov    0x8(%eax),%edx
  802838:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283b:	8b 40 08             	mov    0x8(%eax),%eax
  80283e:	39 c2                	cmp    %eax,%edx
  802840:	0f 82 60 01 00 00    	jb     8029a6 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802846:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80284a:	75 65                	jne    8028b1 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80284c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802850:	75 14                	jne    802866 <insert_sorted_allocList+0x62>
  802852:	83 ec 04             	sub    $0x4,%esp
  802855:	68 1c 47 80 00       	push   $0x80471c
  80285a:	6a 6b                	push   $0x6b
  80285c:	68 3f 47 80 00       	push   $0x80473f
  802861:	e8 4f e2 ff ff       	call   800ab5 <_panic>
  802866:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80286c:	8b 45 08             	mov    0x8(%ebp),%eax
  80286f:	89 10                	mov    %edx,(%eax)
  802871:	8b 45 08             	mov    0x8(%ebp),%eax
  802874:	8b 00                	mov    (%eax),%eax
  802876:	85 c0                	test   %eax,%eax
  802878:	74 0d                	je     802887 <insert_sorted_allocList+0x83>
  80287a:	a1 40 50 80 00       	mov    0x805040,%eax
  80287f:	8b 55 08             	mov    0x8(%ebp),%edx
  802882:	89 50 04             	mov    %edx,0x4(%eax)
  802885:	eb 08                	jmp    80288f <insert_sorted_allocList+0x8b>
  802887:	8b 45 08             	mov    0x8(%ebp),%eax
  80288a:	a3 44 50 80 00       	mov    %eax,0x805044
  80288f:	8b 45 08             	mov    0x8(%ebp),%eax
  802892:	a3 40 50 80 00       	mov    %eax,0x805040
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028a6:	40                   	inc    %eax
  8028a7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028ac:	e9 dc 01 00 00       	jmp    802a8d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b4:	8b 50 08             	mov    0x8(%eax),%edx
  8028b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ba:	8b 40 08             	mov    0x8(%eax),%eax
  8028bd:	39 c2                	cmp    %eax,%edx
  8028bf:	77 6c                	ja     80292d <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8028c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028c5:	74 06                	je     8028cd <insert_sorted_allocList+0xc9>
  8028c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028cb:	75 14                	jne    8028e1 <insert_sorted_allocList+0xdd>
  8028cd:	83 ec 04             	sub    $0x4,%esp
  8028d0:	68 58 47 80 00       	push   $0x804758
  8028d5:	6a 6f                	push   $0x6f
  8028d7:	68 3f 47 80 00       	push   $0x80473f
  8028dc:	e8 d4 e1 ff ff       	call   800ab5 <_panic>
  8028e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e4:	8b 50 04             	mov    0x4(%eax),%edx
  8028e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ea:	89 50 04             	mov    %edx,0x4(%eax)
  8028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f3:	89 10                	mov    %edx,(%eax)
  8028f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f8:	8b 40 04             	mov    0x4(%eax),%eax
  8028fb:	85 c0                	test   %eax,%eax
  8028fd:	74 0d                	je     80290c <insert_sorted_allocList+0x108>
  8028ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802902:	8b 40 04             	mov    0x4(%eax),%eax
  802905:	8b 55 08             	mov    0x8(%ebp),%edx
  802908:	89 10                	mov    %edx,(%eax)
  80290a:	eb 08                	jmp    802914 <insert_sorted_allocList+0x110>
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	a3 40 50 80 00       	mov    %eax,0x805040
  802914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802917:	8b 55 08             	mov    0x8(%ebp),%edx
  80291a:	89 50 04             	mov    %edx,0x4(%eax)
  80291d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802922:	40                   	inc    %eax
  802923:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802928:	e9 60 01 00 00       	jmp    802a8d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80292d:	8b 45 08             	mov    0x8(%ebp),%eax
  802930:	8b 50 08             	mov    0x8(%eax),%edx
  802933:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802936:	8b 40 08             	mov    0x8(%eax),%eax
  802939:	39 c2                	cmp    %eax,%edx
  80293b:	0f 82 4c 01 00 00    	jb     802a8d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802941:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802945:	75 14                	jne    80295b <insert_sorted_allocList+0x157>
  802947:	83 ec 04             	sub    $0x4,%esp
  80294a:	68 90 47 80 00       	push   $0x804790
  80294f:	6a 73                	push   $0x73
  802951:	68 3f 47 80 00       	push   $0x80473f
  802956:	e8 5a e1 ff ff       	call   800ab5 <_panic>
  80295b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	89 50 04             	mov    %edx,0x4(%eax)
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	8b 40 04             	mov    0x4(%eax),%eax
  80296d:	85 c0                	test   %eax,%eax
  80296f:	74 0c                	je     80297d <insert_sorted_allocList+0x179>
  802971:	a1 44 50 80 00       	mov    0x805044,%eax
  802976:	8b 55 08             	mov    0x8(%ebp),%edx
  802979:	89 10                	mov    %edx,(%eax)
  80297b:	eb 08                	jmp    802985 <insert_sorted_allocList+0x181>
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	a3 40 50 80 00       	mov    %eax,0x805040
  802985:	8b 45 08             	mov    0x8(%ebp),%eax
  802988:	a3 44 50 80 00       	mov    %eax,0x805044
  80298d:	8b 45 08             	mov    0x8(%ebp),%eax
  802990:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802996:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80299b:	40                   	inc    %eax
  80299c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029a1:	e9 e7 00 00 00       	jmp    802a8d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8029a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8029ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029b3:	a1 40 50 80 00       	mov    0x805040,%eax
  8029b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029bb:	e9 9d 00 00 00       	jmp    802a5d <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 00                	mov    (%eax),%eax
  8029c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	8b 50 08             	mov    0x8(%eax),%edx
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 40 08             	mov    0x8(%eax),%eax
  8029d4:	39 c2                	cmp    %eax,%edx
  8029d6:	76 7d                	jbe    802a55 <insert_sorted_allocList+0x251>
  8029d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029db:	8b 50 08             	mov    0x8(%eax),%edx
  8029de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e1:	8b 40 08             	mov    0x8(%eax),%eax
  8029e4:	39 c2                	cmp    %eax,%edx
  8029e6:	73 6d                	jae    802a55 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8029e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ec:	74 06                	je     8029f4 <insert_sorted_allocList+0x1f0>
  8029ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f2:	75 14                	jne    802a08 <insert_sorted_allocList+0x204>
  8029f4:	83 ec 04             	sub    $0x4,%esp
  8029f7:	68 b4 47 80 00       	push   $0x8047b4
  8029fc:	6a 7f                	push   $0x7f
  8029fe:	68 3f 47 80 00       	push   $0x80473f
  802a03:	e8 ad e0 ff ff       	call   800ab5 <_panic>
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	8b 10                	mov    (%eax),%edx
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	89 10                	mov    %edx,(%eax)
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	85 c0                	test   %eax,%eax
  802a19:	74 0b                	je     802a26 <insert_sorted_allocList+0x222>
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 00                	mov    (%eax),%eax
  802a20:	8b 55 08             	mov    0x8(%ebp),%edx
  802a23:	89 50 04             	mov    %edx,0x4(%eax)
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2c:	89 10                	mov    %edx,(%eax)
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a34:	89 50 04             	mov    %edx,0x4(%eax)
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	8b 00                	mov    (%eax),%eax
  802a3c:	85 c0                	test   %eax,%eax
  802a3e:	75 08                	jne    802a48 <insert_sorted_allocList+0x244>
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	a3 44 50 80 00       	mov    %eax,0x805044
  802a48:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a4d:	40                   	inc    %eax
  802a4e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a53:	eb 39                	jmp    802a8e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a55:	a1 48 50 80 00       	mov    0x805048,%eax
  802a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a61:	74 07                	je     802a6a <insert_sorted_allocList+0x266>
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	eb 05                	jmp    802a6f <insert_sorted_allocList+0x26b>
  802a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6f:	a3 48 50 80 00       	mov    %eax,0x805048
  802a74:	a1 48 50 80 00       	mov    0x805048,%eax
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	0f 85 3f ff ff ff    	jne    8029c0 <insert_sorted_allocList+0x1bc>
  802a81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a85:	0f 85 35 ff ff ff    	jne    8029c0 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a8b:	eb 01                	jmp    802a8e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a8d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a8e:	90                   	nop
  802a8f:	c9                   	leave  
  802a90:	c3                   	ret    

00802a91 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a91:	55                   	push   %ebp
  802a92:	89 e5                	mov    %esp,%ebp
  802a94:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a97:	a1 38 51 80 00       	mov    0x805138,%eax
  802a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a9f:	e9 85 01 00 00       	jmp    802c29 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aaa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aad:	0f 82 6e 01 00 00    	jb     802c21 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802abc:	0f 85 8a 00 00 00    	jne    802b4c <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac6:	75 17                	jne    802adf <alloc_block_FF+0x4e>
  802ac8:	83 ec 04             	sub    $0x4,%esp
  802acb:	68 e8 47 80 00       	push   $0x8047e8
  802ad0:	68 93 00 00 00       	push   $0x93
  802ad5:	68 3f 47 80 00       	push   $0x80473f
  802ada:	e8 d6 df ff ff       	call   800ab5 <_panic>
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 00                	mov    (%eax),%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	74 10                	je     802af8 <alloc_block_FF+0x67>
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af0:	8b 52 04             	mov    0x4(%edx),%edx
  802af3:	89 50 04             	mov    %edx,0x4(%eax)
  802af6:	eb 0b                	jmp    802b03 <alloc_block_FF+0x72>
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	8b 40 04             	mov    0x4(%eax),%eax
  802afe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	8b 40 04             	mov    0x4(%eax),%eax
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	74 0f                	je     802b1c <alloc_block_FF+0x8b>
  802b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b10:	8b 40 04             	mov    0x4(%eax),%eax
  802b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b16:	8b 12                	mov    (%edx),%edx
  802b18:	89 10                	mov    %edx,(%eax)
  802b1a:	eb 0a                	jmp    802b26 <alloc_block_FF+0x95>
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 00                	mov    (%eax),%eax
  802b21:	a3 38 51 80 00       	mov    %eax,0x805138
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b39:	a1 44 51 80 00       	mov    0x805144,%eax
  802b3e:	48                   	dec    %eax
  802b3f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	e9 10 01 00 00       	jmp    802c5c <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b52:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b55:	0f 86 c6 00 00 00    	jbe    802c21 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b5b:	a1 48 51 80 00       	mov    0x805148,%eax
  802b60:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 50 08             	mov    0x8(%eax),%edx
  802b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6c:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b72:	8b 55 08             	mov    0x8(%ebp),%edx
  802b75:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7c:	75 17                	jne    802b95 <alloc_block_FF+0x104>
  802b7e:	83 ec 04             	sub    $0x4,%esp
  802b81:	68 e8 47 80 00       	push   $0x8047e8
  802b86:	68 9b 00 00 00       	push   $0x9b
  802b8b:	68 3f 47 80 00       	push   $0x80473f
  802b90:	e8 20 df ff ff       	call   800ab5 <_panic>
  802b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b98:	8b 00                	mov    (%eax),%eax
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	74 10                	je     802bae <alloc_block_FF+0x11d>
  802b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba6:	8b 52 04             	mov    0x4(%edx),%edx
  802ba9:	89 50 04             	mov    %edx,0x4(%eax)
  802bac:	eb 0b                	jmp    802bb9 <alloc_block_FF+0x128>
  802bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb1:	8b 40 04             	mov    0x4(%eax),%eax
  802bb4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbc:	8b 40 04             	mov    0x4(%eax),%eax
  802bbf:	85 c0                	test   %eax,%eax
  802bc1:	74 0f                	je     802bd2 <alloc_block_FF+0x141>
  802bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc6:	8b 40 04             	mov    0x4(%eax),%eax
  802bc9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bcc:	8b 12                	mov    (%edx),%edx
  802bce:	89 10                	mov    %edx,(%eax)
  802bd0:	eb 0a                	jmp    802bdc <alloc_block_FF+0x14b>
  802bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	a3 48 51 80 00       	mov    %eax,0x805148
  802bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bef:	a1 54 51 80 00       	mov    0x805154,%eax
  802bf4:	48                   	dec    %eax
  802bf5:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 50 08             	mov    0x8(%eax),%edx
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	01 c2                	add    %eax,%edx
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c11:	2b 45 08             	sub    0x8(%ebp),%eax
  802c14:	89 c2                	mov    %eax,%edx
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1f:	eb 3b                	jmp    802c5c <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c21:	a1 40 51 80 00       	mov    0x805140,%eax
  802c26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2d:	74 07                	je     802c36 <alloc_block_FF+0x1a5>
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	eb 05                	jmp    802c3b <alloc_block_FF+0x1aa>
  802c36:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3b:	a3 40 51 80 00       	mov    %eax,0x805140
  802c40:	a1 40 51 80 00       	mov    0x805140,%eax
  802c45:	85 c0                	test   %eax,%eax
  802c47:	0f 85 57 fe ff ff    	jne    802aa4 <alloc_block_FF+0x13>
  802c4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c51:	0f 85 4d fe ff ff    	jne    802aa4 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802c57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c5c:	c9                   	leave  
  802c5d:	c3                   	ret    

00802c5e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c5e:	55                   	push   %ebp
  802c5f:	89 e5                	mov    %esp,%ebp
  802c61:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802c64:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c6b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c73:	e9 df 00 00 00       	jmp    802d57 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c81:	0f 82 c8 00 00 00    	jb     802d4f <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c90:	0f 85 8a 00 00 00    	jne    802d20 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9a:	75 17                	jne    802cb3 <alloc_block_BF+0x55>
  802c9c:	83 ec 04             	sub    $0x4,%esp
  802c9f:	68 e8 47 80 00       	push   $0x8047e8
  802ca4:	68 b7 00 00 00       	push   $0xb7
  802ca9:	68 3f 47 80 00       	push   $0x80473f
  802cae:	e8 02 de ff ff       	call   800ab5 <_panic>
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	74 10                	je     802ccc <alloc_block_BF+0x6e>
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 00                	mov    (%eax),%eax
  802cc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc4:	8b 52 04             	mov    0x4(%edx),%edx
  802cc7:	89 50 04             	mov    %edx,0x4(%eax)
  802cca:	eb 0b                	jmp    802cd7 <alloc_block_BF+0x79>
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 40 04             	mov    0x4(%eax),%eax
  802cdd:	85 c0                	test   %eax,%eax
  802cdf:	74 0f                	je     802cf0 <alloc_block_BF+0x92>
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 40 04             	mov    0x4(%eax),%eax
  802ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cea:	8b 12                	mov    (%edx),%edx
  802cec:	89 10                	mov    %edx,(%eax)
  802cee:	eb 0a                	jmp    802cfa <alloc_block_BF+0x9c>
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	8b 00                	mov    (%eax),%eax
  802cf5:	a3 38 51 80 00       	mov    %eax,0x805138
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0d:	a1 44 51 80 00       	mov    0x805144,%eax
  802d12:	48                   	dec    %eax
  802d13:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	e9 4d 01 00 00       	jmp    802e6d <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	8b 40 0c             	mov    0xc(%eax),%eax
  802d26:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d29:	76 24                	jbe    802d4f <alloc_block_BF+0xf1>
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d31:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d34:	73 19                	jae    802d4f <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802d36:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	8b 40 0c             	mov    0xc(%eax),%eax
  802d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d49:	8b 40 08             	mov    0x8(%eax),%eax
  802d4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802d4f:	a1 40 51 80 00       	mov    0x805140,%eax
  802d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5b:	74 07                	je     802d64 <alloc_block_BF+0x106>
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 00                	mov    (%eax),%eax
  802d62:	eb 05                	jmp    802d69 <alloc_block_BF+0x10b>
  802d64:	b8 00 00 00 00       	mov    $0x0,%eax
  802d69:	a3 40 51 80 00       	mov    %eax,0x805140
  802d6e:	a1 40 51 80 00       	mov    0x805140,%eax
  802d73:	85 c0                	test   %eax,%eax
  802d75:	0f 85 fd fe ff ff    	jne    802c78 <alloc_block_BF+0x1a>
  802d7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d7f:	0f 85 f3 fe ff ff    	jne    802c78 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802d85:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d89:	0f 84 d9 00 00 00    	je     802e68 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d8f:	a1 48 51 80 00       	mov    0x805148,%eax
  802d94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d9d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802da0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da3:	8b 55 08             	mov    0x8(%ebp),%edx
  802da6:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802da9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dad:	75 17                	jne    802dc6 <alloc_block_BF+0x168>
  802daf:	83 ec 04             	sub    $0x4,%esp
  802db2:	68 e8 47 80 00       	push   $0x8047e8
  802db7:	68 c7 00 00 00       	push   $0xc7
  802dbc:	68 3f 47 80 00       	push   $0x80473f
  802dc1:	e8 ef dc ff ff       	call   800ab5 <_panic>
  802dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc9:	8b 00                	mov    (%eax),%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	74 10                	je     802ddf <alloc_block_BF+0x181>
  802dcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd2:	8b 00                	mov    (%eax),%eax
  802dd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dd7:	8b 52 04             	mov    0x4(%edx),%edx
  802dda:	89 50 04             	mov    %edx,0x4(%eax)
  802ddd:	eb 0b                	jmp    802dea <alloc_block_BF+0x18c>
  802ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de2:	8b 40 04             	mov    0x4(%eax),%eax
  802de5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ded:	8b 40 04             	mov    0x4(%eax),%eax
  802df0:	85 c0                	test   %eax,%eax
  802df2:	74 0f                	je     802e03 <alloc_block_BF+0x1a5>
  802df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df7:	8b 40 04             	mov    0x4(%eax),%eax
  802dfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dfd:	8b 12                	mov    (%edx),%edx
  802dff:	89 10                	mov    %edx,(%eax)
  802e01:	eb 0a                	jmp    802e0d <alloc_block_BF+0x1af>
  802e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e06:	8b 00                	mov    (%eax),%eax
  802e08:	a3 48 51 80 00       	mov    %eax,0x805148
  802e0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e20:	a1 54 51 80 00       	mov    0x805154,%eax
  802e25:	48                   	dec    %eax
  802e26:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802e2b:	83 ec 08             	sub    $0x8,%esp
  802e2e:	ff 75 ec             	pushl  -0x14(%ebp)
  802e31:	68 38 51 80 00       	push   $0x805138
  802e36:	e8 71 f9 ff ff       	call   8027ac <find_block>
  802e3b:	83 c4 10             	add    $0x10,%esp
  802e3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802e41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e44:	8b 50 08             	mov    0x8(%eax),%edx
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	01 c2                	add    %eax,%edx
  802e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e4f:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802e52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e55:	8b 40 0c             	mov    0xc(%eax),%eax
  802e58:	2b 45 08             	sub    0x8(%ebp),%eax
  802e5b:	89 c2                	mov    %eax,%edx
  802e5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e60:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e66:	eb 05                	jmp    802e6d <alloc_block_BF+0x20f>
	}
	return NULL;
  802e68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e6d:	c9                   	leave  
  802e6e:	c3                   	ret    

00802e6f <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e6f:	55                   	push   %ebp
  802e70:	89 e5                	mov    %esp,%ebp
  802e72:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802e75:	a1 28 50 80 00       	mov    0x805028,%eax
  802e7a:	85 c0                	test   %eax,%eax
  802e7c:	0f 85 de 01 00 00    	jne    803060 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e82:	a1 38 51 80 00       	mov    0x805138,%eax
  802e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8a:	e9 9e 01 00 00       	jmp    80302d <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e92:	8b 40 0c             	mov    0xc(%eax),%eax
  802e95:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e98:	0f 82 87 01 00 00    	jb     803025 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ea7:	0f 85 95 00 00 00    	jne    802f42 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802ead:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb1:	75 17                	jne    802eca <alloc_block_NF+0x5b>
  802eb3:	83 ec 04             	sub    $0x4,%esp
  802eb6:	68 e8 47 80 00       	push   $0x8047e8
  802ebb:	68 e0 00 00 00       	push   $0xe0
  802ec0:	68 3f 47 80 00       	push   $0x80473f
  802ec5:	e8 eb db ff ff       	call   800ab5 <_panic>
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	8b 00                	mov    (%eax),%eax
  802ecf:	85 c0                	test   %eax,%eax
  802ed1:	74 10                	je     802ee3 <alloc_block_NF+0x74>
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802edb:	8b 52 04             	mov    0x4(%edx),%edx
  802ede:	89 50 04             	mov    %edx,0x4(%eax)
  802ee1:	eb 0b                	jmp    802eee <alloc_block_NF+0x7f>
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	8b 40 04             	mov    0x4(%eax),%eax
  802ee9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 40 04             	mov    0x4(%eax),%eax
  802ef4:	85 c0                	test   %eax,%eax
  802ef6:	74 0f                	je     802f07 <alloc_block_NF+0x98>
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 40 04             	mov    0x4(%eax),%eax
  802efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f01:	8b 12                	mov    (%edx),%edx
  802f03:	89 10                	mov    %edx,(%eax)
  802f05:	eb 0a                	jmp    802f11 <alloc_block_NF+0xa2>
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f24:	a1 44 51 80 00       	mov    0x805144,%eax
  802f29:	48                   	dec    %eax
  802f2a:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	8b 40 08             	mov    0x8(%eax),%eax
  802f35:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	e9 f8 04 00 00       	jmp    80343a <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	8b 40 0c             	mov    0xc(%eax),%eax
  802f48:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f4b:	0f 86 d4 00 00 00    	jbe    803025 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f51:	a1 48 51 80 00       	mov    0x805148,%eax
  802f56:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	8b 50 08             	mov    0x8(%eax),%edx
  802f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f62:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f68:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6b:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f72:	75 17                	jne    802f8b <alloc_block_NF+0x11c>
  802f74:	83 ec 04             	sub    $0x4,%esp
  802f77:	68 e8 47 80 00       	push   $0x8047e8
  802f7c:	68 e9 00 00 00       	push   $0xe9
  802f81:	68 3f 47 80 00       	push   $0x80473f
  802f86:	e8 2a db ff ff       	call   800ab5 <_panic>
  802f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8e:	8b 00                	mov    (%eax),%eax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	74 10                	je     802fa4 <alloc_block_NF+0x135>
  802f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f9c:	8b 52 04             	mov    0x4(%edx),%edx
  802f9f:	89 50 04             	mov    %edx,0x4(%eax)
  802fa2:	eb 0b                	jmp    802faf <alloc_block_NF+0x140>
  802fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa7:	8b 40 04             	mov    0x4(%eax),%eax
  802faa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb2:	8b 40 04             	mov    0x4(%eax),%eax
  802fb5:	85 c0                	test   %eax,%eax
  802fb7:	74 0f                	je     802fc8 <alloc_block_NF+0x159>
  802fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbc:	8b 40 04             	mov    0x4(%eax),%eax
  802fbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fc2:	8b 12                	mov    (%edx),%edx
  802fc4:	89 10                	mov    %edx,(%eax)
  802fc6:	eb 0a                	jmp    802fd2 <alloc_block_NF+0x163>
  802fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcb:	8b 00                	mov    (%eax),%eax
  802fcd:	a3 48 51 80 00       	mov    %eax,0x805148
  802fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe5:	a1 54 51 80 00       	mov    0x805154,%eax
  802fea:	48                   	dec    %eax
  802feb:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff3:	8b 40 08             	mov    0x8(%eax),%eax
  802ff6:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	8b 50 08             	mov    0x8(%eax),%edx
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	01 c2                	add    %eax,%edx
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	8b 40 0c             	mov    0xc(%eax),%eax
  803012:	2b 45 08             	sub    0x8(%ebp),%eax
  803015:	89 c2                	mov    %eax,%edx
  803017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301a:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80301d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803020:	e9 15 04 00 00       	jmp    80343a <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803025:	a1 40 51 80 00       	mov    0x805140,%eax
  80302a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80302d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803031:	74 07                	je     80303a <alloc_block_NF+0x1cb>
  803033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803036:	8b 00                	mov    (%eax),%eax
  803038:	eb 05                	jmp    80303f <alloc_block_NF+0x1d0>
  80303a:	b8 00 00 00 00       	mov    $0x0,%eax
  80303f:	a3 40 51 80 00       	mov    %eax,0x805140
  803044:	a1 40 51 80 00       	mov    0x805140,%eax
  803049:	85 c0                	test   %eax,%eax
  80304b:	0f 85 3e fe ff ff    	jne    802e8f <alloc_block_NF+0x20>
  803051:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803055:	0f 85 34 fe ff ff    	jne    802e8f <alloc_block_NF+0x20>
  80305b:	e9 d5 03 00 00       	jmp    803435 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803060:	a1 38 51 80 00       	mov    0x805138,%eax
  803065:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803068:	e9 b1 01 00 00       	jmp    80321e <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803070:	8b 50 08             	mov    0x8(%eax),%edx
  803073:	a1 28 50 80 00       	mov    0x805028,%eax
  803078:	39 c2                	cmp    %eax,%edx
  80307a:	0f 82 96 01 00 00    	jb     803216 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	8b 40 0c             	mov    0xc(%eax),%eax
  803086:	3b 45 08             	cmp    0x8(%ebp),%eax
  803089:	0f 82 87 01 00 00    	jb     803216 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 40 0c             	mov    0xc(%eax),%eax
  803095:	3b 45 08             	cmp    0x8(%ebp),%eax
  803098:	0f 85 95 00 00 00    	jne    803133 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80309e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a2:	75 17                	jne    8030bb <alloc_block_NF+0x24c>
  8030a4:	83 ec 04             	sub    $0x4,%esp
  8030a7:	68 e8 47 80 00       	push   $0x8047e8
  8030ac:	68 fc 00 00 00       	push   $0xfc
  8030b1:	68 3f 47 80 00       	push   $0x80473f
  8030b6:	e8 fa d9 ff ff       	call   800ab5 <_panic>
  8030bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030be:	8b 00                	mov    (%eax),%eax
  8030c0:	85 c0                	test   %eax,%eax
  8030c2:	74 10                	je     8030d4 <alloc_block_NF+0x265>
  8030c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c7:	8b 00                	mov    (%eax),%eax
  8030c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030cc:	8b 52 04             	mov    0x4(%edx),%edx
  8030cf:	89 50 04             	mov    %edx,0x4(%eax)
  8030d2:	eb 0b                	jmp    8030df <alloc_block_NF+0x270>
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	8b 40 04             	mov    0x4(%eax),%eax
  8030da:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e2:	8b 40 04             	mov    0x4(%eax),%eax
  8030e5:	85 c0                	test   %eax,%eax
  8030e7:	74 0f                	je     8030f8 <alloc_block_NF+0x289>
  8030e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ec:	8b 40 04             	mov    0x4(%eax),%eax
  8030ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f2:	8b 12                	mov    (%edx),%edx
  8030f4:	89 10                	mov    %edx,(%eax)
  8030f6:	eb 0a                	jmp    803102 <alloc_block_NF+0x293>
  8030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	a3 38 51 80 00       	mov    %eax,0x805138
  803102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803105:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80310b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803115:	a1 44 51 80 00       	mov    0x805144,%eax
  80311a:	48                   	dec    %eax
  80311b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803123:	8b 40 08             	mov    0x8(%eax),%eax
  803126:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80312b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312e:	e9 07 03 00 00       	jmp    80343a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	8b 40 0c             	mov    0xc(%eax),%eax
  803139:	3b 45 08             	cmp    0x8(%ebp),%eax
  80313c:	0f 86 d4 00 00 00    	jbe    803216 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803142:	a1 48 51 80 00       	mov    0x805148,%eax
  803147:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80314a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314d:	8b 50 08             	mov    0x8(%eax),%edx
  803150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803153:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803156:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803159:	8b 55 08             	mov    0x8(%ebp),%edx
  80315c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80315f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803163:	75 17                	jne    80317c <alloc_block_NF+0x30d>
  803165:	83 ec 04             	sub    $0x4,%esp
  803168:	68 e8 47 80 00       	push   $0x8047e8
  80316d:	68 04 01 00 00       	push   $0x104
  803172:	68 3f 47 80 00       	push   $0x80473f
  803177:	e8 39 d9 ff ff       	call   800ab5 <_panic>
  80317c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317f:	8b 00                	mov    (%eax),%eax
  803181:	85 c0                	test   %eax,%eax
  803183:	74 10                	je     803195 <alloc_block_NF+0x326>
  803185:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803188:	8b 00                	mov    (%eax),%eax
  80318a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80318d:	8b 52 04             	mov    0x4(%edx),%edx
  803190:	89 50 04             	mov    %edx,0x4(%eax)
  803193:	eb 0b                	jmp    8031a0 <alloc_block_NF+0x331>
  803195:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803198:	8b 40 04             	mov    0x4(%eax),%eax
  80319b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a3:	8b 40 04             	mov    0x4(%eax),%eax
  8031a6:	85 c0                	test   %eax,%eax
  8031a8:	74 0f                	je     8031b9 <alloc_block_NF+0x34a>
  8031aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ad:	8b 40 04             	mov    0x4(%eax),%eax
  8031b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b3:	8b 12                	mov    (%edx),%edx
  8031b5:	89 10                	mov    %edx,(%eax)
  8031b7:	eb 0a                	jmp    8031c3 <alloc_block_NF+0x354>
  8031b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bc:	8b 00                	mov    (%eax),%eax
  8031be:	a3 48 51 80 00       	mov    %eax,0x805148
  8031c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d6:	a1 54 51 80 00       	mov    0x805154,%eax
  8031db:	48                   	dec    %eax
  8031dc:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e4:	8b 40 08             	mov    0x8(%eax),%eax
  8031e7:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8031ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ef:	8b 50 08             	mov    0x8(%eax),%edx
  8031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f5:	01 c2                	add    %eax,%edx
  8031f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fa:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	8b 40 0c             	mov    0xc(%eax),%eax
  803203:	2b 45 08             	sub    0x8(%ebp),%eax
  803206:	89 c2                	mov    %eax,%edx
  803208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80320e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803211:	e9 24 02 00 00       	jmp    80343a <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803216:	a1 40 51 80 00       	mov    0x805140,%eax
  80321b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80321e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803222:	74 07                	je     80322b <alloc_block_NF+0x3bc>
  803224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803227:	8b 00                	mov    (%eax),%eax
  803229:	eb 05                	jmp    803230 <alloc_block_NF+0x3c1>
  80322b:	b8 00 00 00 00       	mov    $0x0,%eax
  803230:	a3 40 51 80 00       	mov    %eax,0x805140
  803235:	a1 40 51 80 00       	mov    0x805140,%eax
  80323a:	85 c0                	test   %eax,%eax
  80323c:	0f 85 2b fe ff ff    	jne    80306d <alloc_block_NF+0x1fe>
  803242:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803246:	0f 85 21 fe ff ff    	jne    80306d <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80324c:	a1 38 51 80 00       	mov    0x805138,%eax
  803251:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803254:	e9 ae 01 00 00       	jmp    803407 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	8b 50 08             	mov    0x8(%eax),%edx
  80325f:	a1 28 50 80 00       	mov    0x805028,%eax
  803264:	39 c2                	cmp    %eax,%edx
  803266:	0f 83 93 01 00 00    	jae    8033ff <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80326c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326f:	8b 40 0c             	mov    0xc(%eax),%eax
  803272:	3b 45 08             	cmp    0x8(%ebp),%eax
  803275:	0f 82 84 01 00 00    	jb     8033ff <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80327b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327e:	8b 40 0c             	mov    0xc(%eax),%eax
  803281:	3b 45 08             	cmp    0x8(%ebp),%eax
  803284:	0f 85 95 00 00 00    	jne    80331f <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80328a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80328e:	75 17                	jne    8032a7 <alloc_block_NF+0x438>
  803290:	83 ec 04             	sub    $0x4,%esp
  803293:	68 e8 47 80 00       	push   $0x8047e8
  803298:	68 14 01 00 00       	push   $0x114
  80329d:	68 3f 47 80 00       	push   $0x80473f
  8032a2:	e8 0e d8 ff ff       	call   800ab5 <_panic>
  8032a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032aa:	8b 00                	mov    (%eax),%eax
  8032ac:	85 c0                	test   %eax,%eax
  8032ae:	74 10                	je     8032c0 <alloc_block_NF+0x451>
  8032b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032b8:	8b 52 04             	mov    0x4(%edx),%edx
  8032bb:	89 50 04             	mov    %edx,0x4(%eax)
  8032be:	eb 0b                	jmp    8032cb <alloc_block_NF+0x45c>
  8032c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c3:	8b 40 04             	mov    0x4(%eax),%eax
  8032c6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ce:	8b 40 04             	mov    0x4(%eax),%eax
  8032d1:	85 c0                	test   %eax,%eax
  8032d3:	74 0f                	je     8032e4 <alloc_block_NF+0x475>
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	8b 40 04             	mov    0x4(%eax),%eax
  8032db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032de:	8b 12                	mov    (%edx),%edx
  8032e0:	89 10                	mov    %edx,(%eax)
  8032e2:	eb 0a                	jmp    8032ee <alloc_block_NF+0x47f>
  8032e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e7:	8b 00                	mov    (%eax),%eax
  8032e9:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803301:	a1 44 51 80 00       	mov    0x805144,%eax
  803306:	48                   	dec    %eax
  803307:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330f:	8b 40 08             	mov    0x8(%eax),%eax
  803312:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331a:	e9 1b 01 00 00       	jmp    80343a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80331f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803322:	8b 40 0c             	mov    0xc(%eax),%eax
  803325:	3b 45 08             	cmp    0x8(%ebp),%eax
  803328:	0f 86 d1 00 00 00    	jbe    8033ff <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80332e:	a1 48 51 80 00       	mov    0x805148,%eax
  803333:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803339:	8b 50 08             	mov    0x8(%eax),%edx
  80333c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803342:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803345:	8b 55 08             	mov    0x8(%ebp),%edx
  803348:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80334b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80334f:	75 17                	jne    803368 <alloc_block_NF+0x4f9>
  803351:	83 ec 04             	sub    $0x4,%esp
  803354:	68 e8 47 80 00       	push   $0x8047e8
  803359:	68 1c 01 00 00       	push   $0x11c
  80335e:	68 3f 47 80 00       	push   $0x80473f
  803363:	e8 4d d7 ff ff       	call   800ab5 <_panic>
  803368:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336b:	8b 00                	mov    (%eax),%eax
  80336d:	85 c0                	test   %eax,%eax
  80336f:	74 10                	je     803381 <alloc_block_NF+0x512>
  803371:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803374:	8b 00                	mov    (%eax),%eax
  803376:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803379:	8b 52 04             	mov    0x4(%edx),%edx
  80337c:	89 50 04             	mov    %edx,0x4(%eax)
  80337f:	eb 0b                	jmp    80338c <alloc_block_NF+0x51d>
  803381:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803384:	8b 40 04             	mov    0x4(%eax),%eax
  803387:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80338c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80338f:	8b 40 04             	mov    0x4(%eax),%eax
  803392:	85 c0                	test   %eax,%eax
  803394:	74 0f                	je     8033a5 <alloc_block_NF+0x536>
  803396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803399:	8b 40 04             	mov    0x4(%eax),%eax
  80339c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80339f:	8b 12                	mov    (%edx),%edx
  8033a1:	89 10                	mov    %edx,(%eax)
  8033a3:	eb 0a                	jmp    8033af <alloc_block_NF+0x540>
  8033a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a8:	8b 00                	mov    (%eax),%eax
  8033aa:	a3 48 51 80 00       	mov    %eax,0x805148
  8033af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c2:	a1 54 51 80 00       	mov    0x805154,%eax
  8033c7:	48                   	dec    %eax
  8033c8:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8033cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d0:	8b 40 08             	mov    0x8(%eax),%eax
  8033d3:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8033d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033db:	8b 50 08             	mov    0x8(%eax),%edx
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	01 c2                	add    %eax,%edx
  8033e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8033e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ef:	2b 45 08             	sub    0x8(%ebp),%eax
  8033f2:	89 c2                	mov    %eax,%edx
  8033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033fd:	eb 3b                	jmp    80343a <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033ff:	a1 40 51 80 00       	mov    0x805140,%eax
  803404:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803407:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340b:	74 07                	je     803414 <alloc_block_NF+0x5a5>
  80340d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803410:	8b 00                	mov    (%eax),%eax
  803412:	eb 05                	jmp    803419 <alloc_block_NF+0x5aa>
  803414:	b8 00 00 00 00       	mov    $0x0,%eax
  803419:	a3 40 51 80 00       	mov    %eax,0x805140
  80341e:	a1 40 51 80 00       	mov    0x805140,%eax
  803423:	85 c0                	test   %eax,%eax
  803425:	0f 85 2e fe ff ff    	jne    803259 <alloc_block_NF+0x3ea>
  80342b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80342f:	0f 85 24 fe ff ff    	jne    803259 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803435:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80343a:	c9                   	leave  
  80343b:	c3                   	ret    

0080343c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80343c:	55                   	push   %ebp
  80343d:	89 e5                	mov    %esp,%ebp
  80343f:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803442:	a1 38 51 80 00       	mov    0x805138,%eax
  803447:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80344a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80344f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803452:	a1 38 51 80 00       	mov    0x805138,%eax
  803457:	85 c0                	test   %eax,%eax
  803459:	74 14                	je     80346f <insert_sorted_with_merge_freeList+0x33>
  80345b:	8b 45 08             	mov    0x8(%ebp),%eax
  80345e:	8b 50 08             	mov    0x8(%eax),%edx
  803461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803464:	8b 40 08             	mov    0x8(%eax),%eax
  803467:	39 c2                	cmp    %eax,%edx
  803469:	0f 87 9b 01 00 00    	ja     80360a <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80346f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803473:	75 17                	jne    80348c <insert_sorted_with_merge_freeList+0x50>
  803475:	83 ec 04             	sub    $0x4,%esp
  803478:	68 1c 47 80 00       	push   $0x80471c
  80347d:	68 38 01 00 00       	push   $0x138
  803482:	68 3f 47 80 00       	push   $0x80473f
  803487:	e8 29 d6 ff ff       	call   800ab5 <_panic>
  80348c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	89 10                	mov    %edx,(%eax)
  803497:	8b 45 08             	mov    0x8(%ebp),%eax
  80349a:	8b 00                	mov    (%eax),%eax
  80349c:	85 c0                	test   %eax,%eax
  80349e:	74 0d                	je     8034ad <insert_sorted_with_merge_freeList+0x71>
  8034a0:	a1 38 51 80 00       	mov    0x805138,%eax
  8034a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a8:	89 50 04             	mov    %edx,0x4(%eax)
  8034ab:	eb 08                	jmp    8034b5 <insert_sorted_with_merge_freeList+0x79>
  8034ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b8:	a3 38 51 80 00       	mov    %eax,0x805138
  8034bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c7:	a1 44 51 80 00       	mov    0x805144,%eax
  8034cc:	40                   	inc    %eax
  8034cd:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034d6:	0f 84 a8 06 00 00    	je     803b84 <insert_sorted_with_merge_freeList+0x748>
  8034dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034df:	8b 50 08             	mov    0x8(%eax),%edx
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e8:	01 c2                	add    %eax,%edx
  8034ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ed:	8b 40 08             	mov    0x8(%eax),%eax
  8034f0:	39 c2                	cmp    %eax,%edx
  8034f2:	0f 85 8c 06 00 00    	jne    803b84 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fb:	8b 50 0c             	mov    0xc(%eax),%edx
  8034fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803501:	8b 40 0c             	mov    0xc(%eax),%eax
  803504:	01 c2                	add    %eax,%edx
  803506:	8b 45 08             	mov    0x8(%ebp),%eax
  803509:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80350c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803510:	75 17                	jne    803529 <insert_sorted_with_merge_freeList+0xed>
  803512:	83 ec 04             	sub    $0x4,%esp
  803515:	68 e8 47 80 00       	push   $0x8047e8
  80351a:	68 3c 01 00 00       	push   $0x13c
  80351f:	68 3f 47 80 00       	push   $0x80473f
  803524:	e8 8c d5 ff ff       	call   800ab5 <_panic>
  803529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352c:	8b 00                	mov    (%eax),%eax
  80352e:	85 c0                	test   %eax,%eax
  803530:	74 10                	je     803542 <insert_sorted_with_merge_freeList+0x106>
  803532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803535:	8b 00                	mov    (%eax),%eax
  803537:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80353a:	8b 52 04             	mov    0x4(%edx),%edx
  80353d:	89 50 04             	mov    %edx,0x4(%eax)
  803540:	eb 0b                	jmp    80354d <insert_sorted_with_merge_freeList+0x111>
  803542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803545:	8b 40 04             	mov    0x4(%eax),%eax
  803548:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80354d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803550:	8b 40 04             	mov    0x4(%eax),%eax
  803553:	85 c0                	test   %eax,%eax
  803555:	74 0f                	je     803566 <insert_sorted_with_merge_freeList+0x12a>
  803557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80355a:	8b 40 04             	mov    0x4(%eax),%eax
  80355d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803560:	8b 12                	mov    (%edx),%edx
  803562:	89 10                	mov    %edx,(%eax)
  803564:	eb 0a                	jmp    803570 <insert_sorted_with_merge_freeList+0x134>
  803566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803569:	8b 00                	mov    (%eax),%eax
  80356b:	a3 38 51 80 00       	mov    %eax,0x805138
  803570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803573:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803583:	a1 44 51 80 00       	mov    0x805144,%eax
  803588:	48                   	dec    %eax
  803589:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80358e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803591:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8035a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035a6:	75 17                	jne    8035bf <insert_sorted_with_merge_freeList+0x183>
  8035a8:	83 ec 04             	sub    $0x4,%esp
  8035ab:	68 1c 47 80 00       	push   $0x80471c
  8035b0:	68 3f 01 00 00       	push   $0x13f
  8035b5:	68 3f 47 80 00       	push   $0x80473f
  8035ba:	e8 f6 d4 ff ff       	call   800ab5 <_panic>
  8035bf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c8:	89 10                	mov    %edx,(%eax)
  8035ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035cd:	8b 00                	mov    (%eax),%eax
  8035cf:	85 c0                	test   %eax,%eax
  8035d1:	74 0d                	je     8035e0 <insert_sorted_with_merge_freeList+0x1a4>
  8035d3:	a1 48 51 80 00       	mov    0x805148,%eax
  8035d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035db:	89 50 04             	mov    %edx,0x4(%eax)
  8035de:	eb 08                	jmp    8035e8 <insert_sorted_with_merge_freeList+0x1ac>
  8035e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035eb:	a3 48 51 80 00       	mov    %eax,0x805148
  8035f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035fa:	a1 54 51 80 00       	mov    0x805154,%eax
  8035ff:	40                   	inc    %eax
  803600:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803605:	e9 7a 05 00 00       	jmp    803b84 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80360a:	8b 45 08             	mov    0x8(%ebp),%eax
  80360d:	8b 50 08             	mov    0x8(%eax),%edx
  803610:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803613:	8b 40 08             	mov    0x8(%eax),%eax
  803616:	39 c2                	cmp    %eax,%edx
  803618:	0f 82 14 01 00 00    	jb     803732 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80361e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803621:	8b 50 08             	mov    0x8(%eax),%edx
  803624:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803627:	8b 40 0c             	mov    0xc(%eax),%eax
  80362a:	01 c2                	add    %eax,%edx
  80362c:	8b 45 08             	mov    0x8(%ebp),%eax
  80362f:	8b 40 08             	mov    0x8(%eax),%eax
  803632:	39 c2                	cmp    %eax,%edx
  803634:	0f 85 90 00 00 00    	jne    8036ca <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80363a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80363d:	8b 50 0c             	mov    0xc(%eax),%edx
  803640:	8b 45 08             	mov    0x8(%ebp),%eax
  803643:	8b 40 0c             	mov    0xc(%eax),%eax
  803646:	01 c2                	add    %eax,%edx
  803648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80364b:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80364e:	8b 45 08             	mov    0x8(%ebp),%eax
  803651:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803658:	8b 45 08             	mov    0x8(%ebp),%eax
  80365b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803662:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803666:	75 17                	jne    80367f <insert_sorted_with_merge_freeList+0x243>
  803668:	83 ec 04             	sub    $0x4,%esp
  80366b:	68 1c 47 80 00       	push   $0x80471c
  803670:	68 49 01 00 00       	push   $0x149
  803675:	68 3f 47 80 00       	push   $0x80473f
  80367a:	e8 36 d4 ff ff       	call   800ab5 <_panic>
  80367f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803685:	8b 45 08             	mov    0x8(%ebp),%eax
  803688:	89 10                	mov    %edx,(%eax)
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	8b 00                	mov    (%eax),%eax
  80368f:	85 c0                	test   %eax,%eax
  803691:	74 0d                	je     8036a0 <insert_sorted_with_merge_freeList+0x264>
  803693:	a1 48 51 80 00       	mov    0x805148,%eax
  803698:	8b 55 08             	mov    0x8(%ebp),%edx
  80369b:	89 50 04             	mov    %edx,0x4(%eax)
  80369e:	eb 08                	jmp    8036a8 <insert_sorted_with_merge_freeList+0x26c>
  8036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ab:	a3 48 51 80 00       	mov    %eax,0x805148
  8036b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8036bf:	40                   	inc    %eax
  8036c0:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036c5:	e9 bb 04 00 00       	jmp    803b85 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8036ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036ce:	75 17                	jne    8036e7 <insert_sorted_with_merge_freeList+0x2ab>
  8036d0:	83 ec 04             	sub    $0x4,%esp
  8036d3:	68 90 47 80 00       	push   $0x804790
  8036d8:	68 4c 01 00 00       	push   $0x14c
  8036dd:	68 3f 47 80 00       	push   $0x80473f
  8036e2:	e8 ce d3 ff ff       	call   800ab5 <_panic>
  8036e7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8036ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f0:	89 50 04             	mov    %edx,0x4(%eax)
  8036f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f6:	8b 40 04             	mov    0x4(%eax),%eax
  8036f9:	85 c0                	test   %eax,%eax
  8036fb:	74 0c                	je     803709 <insert_sorted_with_merge_freeList+0x2cd>
  8036fd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803702:	8b 55 08             	mov    0x8(%ebp),%edx
  803705:	89 10                	mov    %edx,(%eax)
  803707:	eb 08                	jmp    803711 <insert_sorted_with_merge_freeList+0x2d5>
  803709:	8b 45 08             	mov    0x8(%ebp),%eax
  80370c:	a3 38 51 80 00       	mov    %eax,0x805138
  803711:	8b 45 08             	mov    0x8(%ebp),%eax
  803714:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803719:	8b 45 08             	mov    0x8(%ebp),%eax
  80371c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803722:	a1 44 51 80 00       	mov    0x805144,%eax
  803727:	40                   	inc    %eax
  803728:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80372d:	e9 53 04 00 00       	jmp    803b85 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803732:	a1 38 51 80 00       	mov    0x805138,%eax
  803737:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80373a:	e9 15 04 00 00       	jmp    803b54 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80373f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803742:	8b 00                	mov    (%eax),%eax
  803744:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803747:	8b 45 08             	mov    0x8(%ebp),%eax
  80374a:	8b 50 08             	mov    0x8(%eax),%edx
  80374d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803750:	8b 40 08             	mov    0x8(%eax),%eax
  803753:	39 c2                	cmp    %eax,%edx
  803755:	0f 86 f1 03 00 00    	jbe    803b4c <insert_sorted_with_merge_freeList+0x710>
  80375b:	8b 45 08             	mov    0x8(%ebp),%eax
  80375e:	8b 50 08             	mov    0x8(%eax),%edx
  803761:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803764:	8b 40 08             	mov    0x8(%eax),%eax
  803767:	39 c2                	cmp    %eax,%edx
  803769:	0f 83 dd 03 00 00    	jae    803b4c <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803772:	8b 50 08             	mov    0x8(%eax),%edx
  803775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803778:	8b 40 0c             	mov    0xc(%eax),%eax
  80377b:	01 c2                	add    %eax,%edx
  80377d:	8b 45 08             	mov    0x8(%ebp),%eax
  803780:	8b 40 08             	mov    0x8(%eax),%eax
  803783:	39 c2                	cmp    %eax,%edx
  803785:	0f 85 b9 01 00 00    	jne    803944 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80378b:	8b 45 08             	mov    0x8(%ebp),%eax
  80378e:	8b 50 08             	mov    0x8(%eax),%edx
  803791:	8b 45 08             	mov    0x8(%ebp),%eax
  803794:	8b 40 0c             	mov    0xc(%eax),%eax
  803797:	01 c2                	add    %eax,%edx
  803799:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379c:	8b 40 08             	mov    0x8(%eax),%eax
  80379f:	39 c2                	cmp    %eax,%edx
  8037a1:	0f 85 0d 01 00 00    	jne    8038b4 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8037a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037aa:	8b 50 0c             	mov    0xc(%eax),%edx
  8037ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8037b3:	01 c2                	add    %eax,%edx
  8037b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b8:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8037bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037bf:	75 17                	jne    8037d8 <insert_sorted_with_merge_freeList+0x39c>
  8037c1:	83 ec 04             	sub    $0x4,%esp
  8037c4:	68 e8 47 80 00       	push   $0x8047e8
  8037c9:	68 5c 01 00 00       	push   $0x15c
  8037ce:	68 3f 47 80 00       	push   $0x80473f
  8037d3:	e8 dd d2 ff ff       	call   800ab5 <_panic>
  8037d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037db:	8b 00                	mov    (%eax),%eax
  8037dd:	85 c0                	test   %eax,%eax
  8037df:	74 10                	je     8037f1 <insert_sorted_with_merge_freeList+0x3b5>
  8037e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e4:	8b 00                	mov    (%eax),%eax
  8037e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037e9:	8b 52 04             	mov    0x4(%edx),%edx
  8037ec:	89 50 04             	mov    %edx,0x4(%eax)
  8037ef:	eb 0b                	jmp    8037fc <insert_sorted_with_merge_freeList+0x3c0>
  8037f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f4:	8b 40 04             	mov    0x4(%eax),%eax
  8037f7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ff:	8b 40 04             	mov    0x4(%eax),%eax
  803802:	85 c0                	test   %eax,%eax
  803804:	74 0f                	je     803815 <insert_sorted_with_merge_freeList+0x3d9>
  803806:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803809:	8b 40 04             	mov    0x4(%eax),%eax
  80380c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80380f:	8b 12                	mov    (%edx),%edx
  803811:	89 10                	mov    %edx,(%eax)
  803813:	eb 0a                	jmp    80381f <insert_sorted_with_merge_freeList+0x3e3>
  803815:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803818:	8b 00                	mov    (%eax),%eax
  80381a:	a3 38 51 80 00       	mov    %eax,0x805138
  80381f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803822:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803828:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803832:	a1 44 51 80 00       	mov    0x805144,%eax
  803837:	48                   	dec    %eax
  803838:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80383d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803840:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803847:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803851:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803855:	75 17                	jne    80386e <insert_sorted_with_merge_freeList+0x432>
  803857:	83 ec 04             	sub    $0x4,%esp
  80385a:	68 1c 47 80 00       	push   $0x80471c
  80385f:	68 5f 01 00 00       	push   $0x15f
  803864:	68 3f 47 80 00       	push   $0x80473f
  803869:	e8 47 d2 ff ff       	call   800ab5 <_panic>
  80386e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803874:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803877:	89 10                	mov    %edx,(%eax)
  803879:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387c:	8b 00                	mov    (%eax),%eax
  80387e:	85 c0                	test   %eax,%eax
  803880:	74 0d                	je     80388f <insert_sorted_with_merge_freeList+0x453>
  803882:	a1 48 51 80 00       	mov    0x805148,%eax
  803887:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80388a:	89 50 04             	mov    %edx,0x4(%eax)
  80388d:	eb 08                	jmp    803897 <insert_sorted_with_merge_freeList+0x45b>
  80388f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803892:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803897:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389a:	a3 48 51 80 00       	mov    %eax,0x805148
  80389f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a9:	a1 54 51 80 00       	mov    0x805154,%eax
  8038ae:	40                   	inc    %eax
  8038af:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8038b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b7:	8b 50 0c             	mov    0xc(%eax),%edx
  8038ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8038c0:	01 c2                	add    %eax,%edx
  8038c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c5:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8038c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8038d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8038dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038e0:	75 17                	jne    8038f9 <insert_sorted_with_merge_freeList+0x4bd>
  8038e2:	83 ec 04             	sub    $0x4,%esp
  8038e5:	68 1c 47 80 00       	push   $0x80471c
  8038ea:	68 64 01 00 00       	push   $0x164
  8038ef:	68 3f 47 80 00       	push   $0x80473f
  8038f4:	e8 bc d1 ff ff       	call   800ab5 <_panic>
  8038f9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803902:	89 10                	mov    %edx,(%eax)
  803904:	8b 45 08             	mov    0x8(%ebp),%eax
  803907:	8b 00                	mov    (%eax),%eax
  803909:	85 c0                	test   %eax,%eax
  80390b:	74 0d                	je     80391a <insert_sorted_with_merge_freeList+0x4de>
  80390d:	a1 48 51 80 00       	mov    0x805148,%eax
  803912:	8b 55 08             	mov    0x8(%ebp),%edx
  803915:	89 50 04             	mov    %edx,0x4(%eax)
  803918:	eb 08                	jmp    803922 <insert_sorted_with_merge_freeList+0x4e6>
  80391a:	8b 45 08             	mov    0x8(%ebp),%eax
  80391d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803922:	8b 45 08             	mov    0x8(%ebp),%eax
  803925:	a3 48 51 80 00       	mov    %eax,0x805148
  80392a:	8b 45 08             	mov    0x8(%ebp),%eax
  80392d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803934:	a1 54 51 80 00       	mov    0x805154,%eax
  803939:	40                   	inc    %eax
  80393a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80393f:	e9 41 02 00 00       	jmp    803b85 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803944:	8b 45 08             	mov    0x8(%ebp),%eax
  803947:	8b 50 08             	mov    0x8(%eax),%edx
  80394a:	8b 45 08             	mov    0x8(%ebp),%eax
  80394d:	8b 40 0c             	mov    0xc(%eax),%eax
  803950:	01 c2                	add    %eax,%edx
  803952:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803955:	8b 40 08             	mov    0x8(%eax),%eax
  803958:	39 c2                	cmp    %eax,%edx
  80395a:	0f 85 7c 01 00 00    	jne    803adc <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803960:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803964:	74 06                	je     80396c <insert_sorted_with_merge_freeList+0x530>
  803966:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80396a:	75 17                	jne    803983 <insert_sorted_with_merge_freeList+0x547>
  80396c:	83 ec 04             	sub    $0x4,%esp
  80396f:	68 58 47 80 00       	push   $0x804758
  803974:	68 69 01 00 00       	push   $0x169
  803979:	68 3f 47 80 00       	push   $0x80473f
  80397e:	e8 32 d1 ff ff       	call   800ab5 <_panic>
  803983:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803986:	8b 50 04             	mov    0x4(%eax),%edx
  803989:	8b 45 08             	mov    0x8(%ebp),%eax
  80398c:	89 50 04             	mov    %edx,0x4(%eax)
  80398f:	8b 45 08             	mov    0x8(%ebp),%eax
  803992:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803995:	89 10                	mov    %edx,(%eax)
  803997:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399a:	8b 40 04             	mov    0x4(%eax),%eax
  80399d:	85 c0                	test   %eax,%eax
  80399f:	74 0d                	je     8039ae <insert_sorted_with_merge_freeList+0x572>
  8039a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a4:	8b 40 04             	mov    0x4(%eax),%eax
  8039a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8039aa:	89 10                	mov    %edx,(%eax)
  8039ac:	eb 08                	jmp    8039b6 <insert_sorted_with_merge_freeList+0x57a>
  8039ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8039b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8039bc:	89 50 04             	mov    %edx,0x4(%eax)
  8039bf:	a1 44 51 80 00       	mov    0x805144,%eax
  8039c4:	40                   	inc    %eax
  8039c5:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8039ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cd:	8b 50 0c             	mov    0xc(%eax),%edx
  8039d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8039d6:	01 c2                	add    %eax,%edx
  8039d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039db:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8039de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039e2:	75 17                	jne    8039fb <insert_sorted_with_merge_freeList+0x5bf>
  8039e4:	83 ec 04             	sub    $0x4,%esp
  8039e7:	68 e8 47 80 00       	push   $0x8047e8
  8039ec:	68 6b 01 00 00       	push   $0x16b
  8039f1:	68 3f 47 80 00       	push   $0x80473f
  8039f6:	e8 ba d0 ff ff       	call   800ab5 <_panic>
  8039fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039fe:	8b 00                	mov    (%eax),%eax
  803a00:	85 c0                	test   %eax,%eax
  803a02:	74 10                	je     803a14 <insert_sorted_with_merge_freeList+0x5d8>
  803a04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a07:	8b 00                	mov    (%eax),%eax
  803a09:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a0c:	8b 52 04             	mov    0x4(%edx),%edx
  803a0f:	89 50 04             	mov    %edx,0x4(%eax)
  803a12:	eb 0b                	jmp    803a1f <insert_sorted_with_merge_freeList+0x5e3>
  803a14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a17:	8b 40 04             	mov    0x4(%eax),%eax
  803a1a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a22:	8b 40 04             	mov    0x4(%eax),%eax
  803a25:	85 c0                	test   %eax,%eax
  803a27:	74 0f                	je     803a38 <insert_sorted_with_merge_freeList+0x5fc>
  803a29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a2c:	8b 40 04             	mov    0x4(%eax),%eax
  803a2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a32:	8b 12                	mov    (%edx),%edx
  803a34:	89 10                	mov    %edx,(%eax)
  803a36:	eb 0a                	jmp    803a42 <insert_sorted_with_merge_freeList+0x606>
  803a38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3b:	8b 00                	mov    (%eax),%eax
  803a3d:	a3 38 51 80 00       	mov    %eax,0x805138
  803a42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a55:	a1 44 51 80 00       	mov    0x805144,%eax
  803a5a:	48                   	dec    %eax
  803a5b:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a63:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a6d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a74:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a78:	75 17                	jne    803a91 <insert_sorted_with_merge_freeList+0x655>
  803a7a:	83 ec 04             	sub    $0x4,%esp
  803a7d:	68 1c 47 80 00       	push   $0x80471c
  803a82:	68 6e 01 00 00       	push   $0x16e
  803a87:	68 3f 47 80 00       	push   $0x80473f
  803a8c:	e8 24 d0 ff ff       	call   800ab5 <_panic>
  803a91:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a9a:	89 10                	mov    %edx,(%eax)
  803a9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a9f:	8b 00                	mov    (%eax),%eax
  803aa1:	85 c0                	test   %eax,%eax
  803aa3:	74 0d                	je     803ab2 <insert_sorted_with_merge_freeList+0x676>
  803aa5:	a1 48 51 80 00       	mov    0x805148,%eax
  803aaa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803aad:	89 50 04             	mov    %edx,0x4(%eax)
  803ab0:	eb 08                	jmp    803aba <insert_sorted_with_merge_freeList+0x67e>
  803ab2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803aba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803abd:	a3 48 51 80 00       	mov    %eax,0x805148
  803ac2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803acc:	a1 54 51 80 00       	mov    0x805154,%eax
  803ad1:	40                   	inc    %eax
  803ad2:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ad7:	e9 a9 00 00 00       	jmp    803b85 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803adc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ae0:	74 06                	je     803ae8 <insert_sorted_with_merge_freeList+0x6ac>
  803ae2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ae6:	75 17                	jne    803aff <insert_sorted_with_merge_freeList+0x6c3>
  803ae8:	83 ec 04             	sub    $0x4,%esp
  803aeb:	68 b4 47 80 00       	push   $0x8047b4
  803af0:	68 73 01 00 00       	push   $0x173
  803af5:	68 3f 47 80 00       	push   $0x80473f
  803afa:	e8 b6 cf ff ff       	call   800ab5 <_panic>
  803aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b02:	8b 10                	mov    (%eax),%edx
  803b04:	8b 45 08             	mov    0x8(%ebp),%eax
  803b07:	89 10                	mov    %edx,(%eax)
  803b09:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0c:	8b 00                	mov    (%eax),%eax
  803b0e:	85 c0                	test   %eax,%eax
  803b10:	74 0b                	je     803b1d <insert_sorted_with_merge_freeList+0x6e1>
  803b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b15:	8b 00                	mov    (%eax),%eax
  803b17:	8b 55 08             	mov    0x8(%ebp),%edx
  803b1a:	89 50 04             	mov    %edx,0x4(%eax)
  803b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b20:	8b 55 08             	mov    0x8(%ebp),%edx
  803b23:	89 10                	mov    %edx,(%eax)
  803b25:	8b 45 08             	mov    0x8(%ebp),%eax
  803b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b2b:	89 50 04             	mov    %edx,0x4(%eax)
  803b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b31:	8b 00                	mov    (%eax),%eax
  803b33:	85 c0                	test   %eax,%eax
  803b35:	75 08                	jne    803b3f <insert_sorted_with_merge_freeList+0x703>
  803b37:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b3f:	a1 44 51 80 00       	mov    0x805144,%eax
  803b44:	40                   	inc    %eax
  803b45:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803b4a:	eb 39                	jmp    803b85 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803b4c:	a1 40 51 80 00       	mov    0x805140,%eax
  803b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b58:	74 07                	je     803b61 <insert_sorted_with_merge_freeList+0x725>
  803b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5d:	8b 00                	mov    (%eax),%eax
  803b5f:	eb 05                	jmp    803b66 <insert_sorted_with_merge_freeList+0x72a>
  803b61:	b8 00 00 00 00       	mov    $0x0,%eax
  803b66:	a3 40 51 80 00       	mov    %eax,0x805140
  803b6b:	a1 40 51 80 00       	mov    0x805140,%eax
  803b70:	85 c0                	test   %eax,%eax
  803b72:	0f 85 c7 fb ff ff    	jne    80373f <insert_sorted_with_merge_freeList+0x303>
  803b78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b7c:	0f 85 bd fb ff ff    	jne    80373f <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b82:	eb 01                	jmp    803b85 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803b84:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b85:	90                   	nop
  803b86:	c9                   	leave  
  803b87:	c3                   	ret    

00803b88 <__udivdi3>:
  803b88:	55                   	push   %ebp
  803b89:	57                   	push   %edi
  803b8a:	56                   	push   %esi
  803b8b:	53                   	push   %ebx
  803b8c:	83 ec 1c             	sub    $0x1c,%esp
  803b8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b9f:	89 ca                	mov    %ecx,%edx
  803ba1:	89 f8                	mov    %edi,%eax
  803ba3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ba7:	85 f6                	test   %esi,%esi
  803ba9:	75 2d                	jne    803bd8 <__udivdi3+0x50>
  803bab:	39 cf                	cmp    %ecx,%edi
  803bad:	77 65                	ja     803c14 <__udivdi3+0x8c>
  803baf:	89 fd                	mov    %edi,%ebp
  803bb1:	85 ff                	test   %edi,%edi
  803bb3:	75 0b                	jne    803bc0 <__udivdi3+0x38>
  803bb5:	b8 01 00 00 00       	mov    $0x1,%eax
  803bba:	31 d2                	xor    %edx,%edx
  803bbc:	f7 f7                	div    %edi
  803bbe:	89 c5                	mov    %eax,%ebp
  803bc0:	31 d2                	xor    %edx,%edx
  803bc2:	89 c8                	mov    %ecx,%eax
  803bc4:	f7 f5                	div    %ebp
  803bc6:	89 c1                	mov    %eax,%ecx
  803bc8:	89 d8                	mov    %ebx,%eax
  803bca:	f7 f5                	div    %ebp
  803bcc:	89 cf                	mov    %ecx,%edi
  803bce:	89 fa                	mov    %edi,%edx
  803bd0:	83 c4 1c             	add    $0x1c,%esp
  803bd3:	5b                   	pop    %ebx
  803bd4:	5e                   	pop    %esi
  803bd5:	5f                   	pop    %edi
  803bd6:	5d                   	pop    %ebp
  803bd7:	c3                   	ret    
  803bd8:	39 ce                	cmp    %ecx,%esi
  803bda:	77 28                	ja     803c04 <__udivdi3+0x7c>
  803bdc:	0f bd fe             	bsr    %esi,%edi
  803bdf:	83 f7 1f             	xor    $0x1f,%edi
  803be2:	75 40                	jne    803c24 <__udivdi3+0x9c>
  803be4:	39 ce                	cmp    %ecx,%esi
  803be6:	72 0a                	jb     803bf2 <__udivdi3+0x6a>
  803be8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bec:	0f 87 9e 00 00 00    	ja     803c90 <__udivdi3+0x108>
  803bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  803bf7:	89 fa                	mov    %edi,%edx
  803bf9:	83 c4 1c             	add    $0x1c,%esp
  803bfc:	5b                   	pop    %ebx
  803bfd:	5e                   	pop    %esi
  803bfe:	5f                   	pop    %edi
  803bff:	5d                   	pop    %ebp
  803c00:	c3                   	ret    
  803c01:	8d 76 00             	lea    0x0(%esi),%esi
  803c04:	31 ff                	xor    %edi,%edi
  803c06:	31 c0                	xor    %eax,%eax
  803c08:	89 fa                	mov    %edi,%edx
  803c0a:	83 c4 1c             	add    $0x1c,%esp
  803c0d:	5b                   	pop    %ebx
  803c0e:	5e                   	pop    %esi
  803c0f:	5f                   	pop    %edi
  803c10:	5d                   	pop    %ebp
  803c11:	c3                   	ret    
  803c12:	66 90                	xchg   %ax,%ax
  803c14:	89 d8                	mov    %ebx,%eax
  803c16:	f7 f7                	div    %edi
  803c18:	31 ff                	xor    %edi,%edi
  803c1a:	89 fa                	mov    %edi,%edx
  803c1c:	83 c4 1c             	add    $0x1c,%esp
  803c1f:	5b                   	pop    %ebx
  803c20:	5e                   	pop    %esi
  803c21:	5f                   	pop    %edi
  803c22:	5d                   	pop    %ebp
  803c23:	c3                   	ret    
  803c24:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c29:	89 eb                	mov    %ebp,%ebx
  803c2b:	29 fb                	sub    %edi,%ebx
  803c2d:	89 f9                	mov    %edi,%ecx
  803c2f:	d3 e6                	shl    %cl,%esi
  803c31:	89 c5                	mov    %eax,%ebp
  803c33:	88 d9                	mov    %bl,%cl
  803c35:	d3 ed                	shr    %cl,%ebp
  803c37:	89 e9                	mov    %ebp,%ecx
  803c39:	09 f1                	or     %esi,%ecx
  803c3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c3f:	89 f9                	mov    %edi,%ecx
  803c41:	d3 e0                	shl    %cl,%eax
  803c43:	89 c5                	mov    %eax,%ebp
  803c45:	89 d6                	mov    %edx,%esi
  803c47:	88 d9                	mov    %bl,%cl
  803c49:	d3 ee                	shr    %cl,%esi
  803c4b:	89 f9                	mov    %edi,%ecx
  803c4d:	d3 e2                	shl    %cl,%edx
  803c4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c53:	88 d9                	mov    %bl,%cl
  803c55:	d3 e8                	shr    %cl,%eax
  803c57:	09 c2                	or     %eax,%edx
  803c59:	89 d0                	mov    %edx,%eax
  803c5b:	89 f2                	mov    %esi,%edx
  803c5d:	f7 74 24 0c          	divl   0xc(%esp)
  803c61:	89 d6                	mov    %edx,%esi
  803c63:	89 c3                	mov    %eax,%ebx
  803c65:	f7 e5                	mul    %ebp
  803c67:	39 d6                	cmp    %edx,%esi
  803c69:	72 19                	jb     803c84 <__udivdi3+0xfc>
  803c6b:	74 0b                	je     803c78 <__udivdi3+0xf0>
  803c6d:	89 d8                	mov    %ebx,%eax
  803c6f:	31 ff                	xor    %edi,%edi
  803c71:	e9 58 ff ff ff       	jmp    803bce <__udivdi3+0x46>
  803c76:	66 90                	xchg   %ax,%ax
  803c78:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c7c:	89 f9                	mov    %edi,%ecx
  803c7e:	d3 e2                	shl    %cl,%edx
  803c80:	39 c2                	cmp    %eax,%edx
  803c82:	73 e9                	jae    803c6d <__udivdi3+0xe5>
  803c84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c87:	31 ff                	xor    %edi,%edi
  803c89:	e9 40 ff ff ff       	jmp    803bce <__udivdi3+0x46>
  803c8e:	66 90                	xchg   %ax,%ax
  803c90:	31 c0                	xor    %eax,%eax
  803c92:	e9 37 ff ff ff       	jmp    803bce <__udivdi3+0x46>
  803c97:	90                   	nop

00803c98 <__umoddi3>:
  803c98:	55                   	push   %ebp
  803c99:	57                   	push   %edi
  803c9a:	56                   	push   %esi
  803c9b:	53                   	push   %ebx
  803c9c:	83 ec 1c             	sub    $0x1c,%esp
  803c9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ca3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ca7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803caf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cb7:	89 f3                	mov    %esi,%ebx
  803cb9:	89 fa                	mov    %edi,%edx
  803cbb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cbf:	89 34 24             	mov    %esi,(%esp)
  803cc2:	85 c0                	test   %eax,%eax
  803cc4:	75 1a                	jne    803ce0 <__umoddi3+0x48>
  803cc6:	39 f7                	cmp    %esi,%edi
  803cc8:	0f 86 a2 00 00 00    	jbe    803d70 <__umoddi3+0xd8>
  803cce:	89 c8                	mov    %ecx,%eax
  803cd0:	89 f2                	mov    %esi,%edx
  803cd2:	f7 f7                	div    %edi
  803cd4:	89 d0                	mov    %edx,%eax
  803cd6:	31 d2                	xor    %edx,%edx
  803cd8:	83 c4 1c             	add    $0x1c,%esp
  803cdb:	5b                   	pop    %ebx
  803cdc:	5e                   	pop    %esi
  803cdd:	5f                   	pop    %edi
  803cde:	5d                   	pop    %ebp
  803cdf:	c3                   	ret    
  803ce0:	39 f0                	cmp    %esi,%eax
  803ce2:	0f 87 ac 00 00 00    	ja     803d94 <__umoddi3+0xfc>
  803ce8:	0f bd e8             	bsr    %eax,%ebp
  803ceb:	83 f5 1f             	xor    $0x1f,%ebp
  803cee:	0f 84 ac 00 00 00    	je     803da0 <__umoddi3+0x108>
  803cf4:	bf 20 00 00 00       	mov    $0x20,%edi
  803cf9:	29 ef                	sub    %ebp,%edi
  803cfb:	89 fe                	mov    %edi,%esi
  803cfd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d01:	89 e9                	mov    %ebp,%ecx
  803d03:	d3 e0                	shl    %cl,%eax
  803d05:	89 d7                	mov    %edx,%edi
  803d07:	89 f1                	mov    %esi,%ecx
  803d09:	d3 ef                	shr    %cl,%edi
  803d0b:	09 c7                	or     %eax,%edi
  803d0d:	89 e9                	mov    %ebp,%ecx
  803d0f:	d3 e2                	shl    %cl,%edx
  803d11:	89 14 24             	mov    %edx,(%esp)
  803d14:	89 d8                	mov    %ebx,%eax
  803d16:	d3 e0                	shl    %cl,%eax
  803d18:	89 c2                	mov    %eax,%edx
  803d1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d1e:	d3 e0                	shl    %cl,%eax
  803d20:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d24:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d28:	89 f1                	mov    %esi,%ecx
  803d2a:	d3 e8                	shr    %cl,%eax
  803d2c:	09 d0                	or     %edx,%eax
  803d2e:	d3 eb                	shr    %cl,%ebx
  803d30:	89 da                	mov    %ebx,%edx
  803d32:	f7 f7                	div    %edi
  803d34:	89 d3                	mov    %edx,%ebx
  803d36:	f7 24 24             	mull   (%esp)
  803d39:	89 c6                	mov    %eax,%esi
  803d3b:	89 d1                	mov    %edx,%ecx
  803d3d:	39 d3                	cmp    %edx,%ebx
  803d3f:	0f 82 87 00 00 00    	jb     803dcc <__umoddi3+0x134>
  803d45:	0f 84 91 00 00 00    	je     803ddc <__umoddi3+0x144>
  803d4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d4f:	29 f2                	sub    %esi,%edx
  803d51:	19 cb                	sbb    %ecx,%ebx
  803d53:	89 d8                	mov    %ebx,%eax
  803d55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d59:	d3 e0                	shl    %cl,%eax
  803d5b:	89 e9                	mov    %ebp,%ecx
  803d5d:	d3 ea                	shr    %cl,%edx
  803d5f:	09 d0                	or     %edx,%eax
  803d61:	89 e9                	mov    %ebp,%ecx
  803d63:	d3 eb                	shr    %cl,%ebx
  803d65:	89 da                	mov    %ebx,%edx
  803d67:	83 c4 1c             	add    $0x1c,%esp
  803d6a:	5b                   	pop    %ebx
  803d6b:	5e                   	pop    %esi
  803d6c:	5f                   	pop    %edi
  803d6d:	5d                   	pop    %ebp
  803d6e:	c3                   	ret    
  803d6f:	90                   	nop
  803d70:	89 fd                	mov    %edi,%ebp
  803d72:	85 ff                	test   %edi,%edi
  803d74:	75 0b                	jne    803d81 <__umoddi3+0xe9>
  803d76:	b8 01 00 00 00       	mov    $0x1,%eax
  803d7b:	31 d2                	xor    %edx,%edx
  803d7d:	f7 f7                	div    %edi
  803d7f:	89 c5                	mov    %eax,%ebp
  803d81:	89 f0                	mov    %esi,%eax
  803d83:	31 d2                	xor    %edx,%edx
  803d85:	f7 f5                	div    %ebp
  803d87:	89 c8                	mov    %ecx,%eax
  803d89:	f7 f5                	div    %ebp
  803d8b:	89 d0                	mov    %edx,%eax
  803d8d:	e9 44 ff ff ff       	jmp    803cd6 <__umoddi3+0x3e>
  803d92:	66 90                	xchg   %ax,%ax
  803d94:	89 c8                	mov    %ecx,%eax
  803d96:	89 f2                	mov    %esi,%edx
  803d98:	83 c4 1c             	add    $0x1c,%esp
  803d9b:	5b                   	pop    %ebx
  803d9c:	5e                   	pop    %esi
  803d9d:	5f                   	pop    %edi
  803d9e:	5d                   	pop    %ebp
  803d9f:	c3                   	ret    
  803da0:	3b 04 24             	cmp    (%esp),%eax
  803da3:	72 06                	jb     803dab <__umoddi3+0x113>
  803da5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803da9:	77 0f                	ja     803dba <__umoddi3+0x122>
  803dab:	89 f2                	mov    %esi,%edx
  803dad:	29 f9                	sub    %edi,%ecx
  803daf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803db3:	89 14 24             	mov    %edx,(%esp)
  803db6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dba:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dbe:	8b 14 24             	mov    (%esp),%edx
  803dc1:	83 c4 1c             	add    $0x1c,%esp
  803dc4:	5b                   	pop    %ebx
  803dc5:	5e                   	pop    %esi
  803dc6:	5f                   	pop    %edi
  803dc7:	5d                   	pop    %ebp
  803dc8:	c3                   	ret    
  803dc9:	8d 76 00             	lea    0x0(%esi),%esi
  803dcc:	2b 04 24             	sub    (%esp),%eax
  803dcf:	19 fa                	sbb    %edi,%edx
  803dd1:	89 d1                	mov    %edx,%ecx
  803dd3:	89 c6                	mov    %eax,%esi
  803dd5:	e9 71 ff ff ff       	jmp    803d4b <__umoddi3+0xb3>
  803dda:	66 90                	xchg   %ax,%ax
  803ddc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803de0:	72 ea                	jb     803dcc <__umoddi3+0x134>
  803de2:	89 d9                	mov    %ebx,%ecx
  803de4:	e9 62 ff ff ff       	jmp    803d4b <__umoddi3+0xb3>
