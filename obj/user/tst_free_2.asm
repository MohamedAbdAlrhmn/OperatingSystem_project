
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
  800090:	68 80 3e 80 00       	push   $0x803e80
  800095:	6a 14                	push   $0x14
  800097:	68 9c 3e 80 00       	push   $0x803e9c
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
  8000b3:	e8 38 23 00 00       	call   8023f0 <sys_bypassPageFault>
  8000b8:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000bb:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  8000c9:	e8 8a 1f 00 00       	call   802058 <sys_calculate_free_frames>
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
  8000f6:	e8 5d 1f 00 00       	call   802058 <sys_calculate_free_frames>
  8000fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 f5 1f 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
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
  800127:	68 b0 3e 80 00       	push   $0x803eb0
  80012c:	6a 2d                	push   $0x2d
  80012e:	68 9c 3e 80 00       	push   $0x803e9c
  800133:	e8 7d 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 bb 1f 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 18 3f 80 00       	push   $0x803f18
  80014a:	6a 2e                	push   $0x2e
  80014c:	68 9c 3e 80 00       	push   $0x803e9c
  800151:	e8 5f 09 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  800156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80015e:	48                   	dec    %eax
  80015f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800165:	e8 ee 1e 00 00       	call   802058 <sys_calculate_free_frames>
  80016a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80016d:	e8 86 1f 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
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
  8001a2:	68 b0 3e 80 00       	push   $0x803eb0
  8001a7:	6a 35                	push   $0x35
  8001a9:	68 9c 3e 80 00       	push   $0x803e9c
  8001ae:	e8 02 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001b3:	e8 40 1f 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  8001b8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001bb:	74 14                	je     8001d1 <_main+0x199>
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	68 18 3f 80 00       	push   $0x803f18
  8001c5:	6a 36                	push   $0x36
  8001c7:	68 9c 3e 80 00       	push   $0x803e9c
  8001cc:	e8 e4 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001d9:	48                   	dec    %eax
  8001da:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001e0:	e8 73 1e 00 00       	call   802058 <sys_calculate_free_frames>
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001e8:	e8 0b 1f 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
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
  80021b:	68 b0 3e 80 00       	push   $0x803eb0
  800220:	6a 3d                	push   $0x3d
  800222:	68 9c 3e 80 00       	push   $0x803e9c
  800227:	e8 89 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80022c:	e8 c7 1e 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  800231:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 18 3f 80 00       	push   $0x803f18
  80023e:	6a 3e                	push   $0x3e
  800240:	68 9c 3e 80 00       	push   $0x803e9c
  800245:	e8 6b 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  80024a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024d:	01 c0                	add    %eax,%eax
  80024f:	48                   	dec    %eax
  800250:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800256:	e8 fd 1d 00 00       	call   802058 <sys_calculate_free_frames>
  80025b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025e:	e8 95 1e 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
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
  80029b:	68 b0 3e 80 00       	push   $0x803eb0
  8002a0:	6a 45                	push   $0x45
  8002a2:	68 9c 3e 80 00       	push   $0x803e9c
  8002a7:	e8 09 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002ac:	e8 47 1e 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  8002b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002b4:	74 14                	je     8002ca <_main+0x292>
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	68 18 3f 80 00       	push   $0x803f18
  8002be:	6a 46                	push   $0x46
  8002c0:	68 9c 3e 80 00       	push   $0x803e9c
  8002c5:	e8 eb 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  8002ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002cd:	01 c0                	add    %eax,%eax
  8002cf:	48                   	dec    %eax
  8002d0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002d6:	e8 7d 1d 00 00       	call   802058 <sys_calculate_free_frames>
  8002db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002de:	e8 15 1e 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
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
  800323:	68 b0 3e 80 00       	push   $0x803eb0
  800328:	6a 4d                	push   $0x4d
  80032a:	68 9c 3e 80 00       	push   $0x803e9c
  80032f:	e8 81 07 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800334:	e8 bf 1d 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  800339:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 18 3f 80 00       	push   $0x803f18
  800346:	6a 4e                	push   $0x4e
  800348:	68 9c 3e 80 00       	push   $0x803e9c
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
  800366:	e8 ed 1c 00 00       	call   802058 <sys_calculate_free_frames>
  80036b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80036e:	e8 85 1d 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
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
  8003b2:	68 b0 3e 80 00       	push   $0x803eb0
  8003b7:	6a 55                	push   $0x55
  8003b9:	68 9c 3e 80 00       	push   $0x803e9c
  8003be:	e8 f2 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003c3:	e8 30 1d 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  8003c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003cb:	74 14                	je     8003e1 <_main+0x3a9>
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 18 3f 80 00       	push   $0x803f18
  8003d5:	6a 56                	push   $0x56
  8003d7:	68 9c 3e 80 00       	push   $0x803e9c
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
  8003f4:	e8 5f 1c 00 00       	call   802058 <sys_calculate_free_frames>
  8003f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003fc:	e8 f7 1c 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
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
  800443:	68 b0 3e 80 00       	push   $0x803eb0
  800448:	6a 5d                	push   $0x5d
  80044a:	68 9c 3e 80 00       	push   $0x803e9c
  80044f:	e8 61 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800454:	e8 9f 1c 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  800459:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80045c:	74 14                	je     800472 <_main+0x43a>
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 18 3f 80 00       	push   $0x803f18
  800466:	6a 5e                	push   $0x5e
  800468:	68 9c 3e 80 00       	push   $0x803e9c
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
  800481:	e8 d2 1b 00 00       	call   802058 <sys_calculate_free_frames>
  800486:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800489:	e8 6a 1c 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  80048e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800491:	8b 45 80             	mov    -0x80(%ebp),%eax
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	50                   	push   %eax
  800498:	e8 cf 18 00 00       	call   801d6c <free>
  80049d:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8004a0:	e8 53 1c 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  8004a5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 48 3f 80 00       	push   $0x803f48
  8004b2:	6a 6b                	push   $0x6b
  8004b4:	68 9c 3e 80 00       	push   $0x803e9c
  8004b9:	e8 f7 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004be:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004ca:	e8 08 1f 00 00       	call   8023d7 <sys_rcr2>
  8004cf:	89 c2                	mov    %eax,%edx
  8004d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d4:	39 c2                	cmp    %eax,%edx
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 84 3f 80 00       	push   $0x803f84
  8004e0:	6a 6f                	push   $0x6f
  8004e2:	68 9c 3e 80 00       	push   $0x803e9c
  8004e7:	e8 c9 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[0]] = 10;
  8004ec:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004f2:	89 c2                	mov    %eax,%edx
  8004f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f7:	01 d0                	add    %edx,%eax
  8004f9:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004fc:	e8 d6 1e 00 00       	call   8023d7 <sys_rcr2>
  800501:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  800507:	89 d1                	mov    %edx,%ecx
  800509:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050c:	01 ca                	add    %ecx,%edx
  80050e:	39 d0                	cmp    %edx,%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 84 3f 80 00       	push   $0x803f84
  80051a:	6a 71                	push   $0x71
  80051c:	68 9c 3e 80 00       	push   $0x803e9c
  800521:	e8 8f 05 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800526:	e8 2d 1b 00 00       	call   802058 <sys_calculate_free_frames>
  80052b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80052e:	e8 c5 1b 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  800533:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800536:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 2a 18 00 00       	call   801d6c <free>
  800542:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800545:	e8 ae 1b 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  80054a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80054d:	74 14                	je     800563 <_main+0x52b>
  80054f:	83 ec 04             	sub    $0x4,%esp
  800552:	68 48 3f 80 00       	push   $0x803f48
  800557:	6a 76                	push   $0x76
  800559:	68 9c 3e 80 00       	push   $0x803e9c
  80055e:	e8 52 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  800563:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800566:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800569:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056c:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80056f:	e8 63 1e 00 00       	call   8023d7 <sys_rcr2>
  800574:	89 c2                	mov    %eax,%edx
  800576:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	74 14                	je     800591 <_main+0x559>
  80057d:	83 ec 04             	sub    $0x4,%esp
  800580:	68 84 3f 80 00       	push   $0x803f84
  800585:	6a 7a                	push   $0x7a
  800587:	68 9c 3e 80 00       	push   $0x803e9c
  80058c:	e8 24 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[1]] = 10;
  800591:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800597:	89 c2                	mov    %eax,%edx
  800599:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005a1:	e8 31 1e 00 00       	call   8023d7 <sys_rcr2>
  8005a6:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  8005ac:	89 d1                	mov    %edx,%ecx
  8005ae:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005b1:	01 ca                	add    %ecx,%edx
  8005b3:	39 d0                	cmp    %edx,%eax
  8005b5:	74 14                	je     8005cb <_main+0x593>
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	68 84 3f 80 00       	push   $0x803f84
  8005bf:	6a 7c                	push   $0x7c
  8005c1:	68 9c 3e 80 00       	push   $0x803e9c
  8005c6:	e8 ea 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005cb:	e8 88 1a 00 00       	call   802058 <sys_calculate_free_frames>
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005d3:	e8 20 1b 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  8005d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  8005db:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005de:	83 ec 0c             	sub    $0xc,%esp
  8005e1:	50                   	push   %eax
  8005e2:	e8 85 17 00 00       	call   801d6c <free>
  8005e7:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005ea:	e8 09 1b 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  8005ef:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005f2:	74 17                	je     80060b <_main+0x5d3>
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 48 3f 80 00       	push   $0x803f48
  8005fc:	68 81 00 00 00       	push   $0x81
  800601:	68 9c 3e 80 00       	push   $0x803e9c
  800606:	e8 aa 04 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  80060b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800611:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800614:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800617:	e8 bb 1d 00 00       	call   8023d7 <sys_rcr2>
  80061c:	89 c2                	mov    %eax,%edx
  80061e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800621:	39 c2                	cmp    %eax,%edx
  800623:	74 17                	je     80063c <_main+0x604>
  800625:	83 ec 04             	sub    $0x4,%esp
  800628:	68 84 3f 80 00       	push   $0x803f84
  80062d:	68 85 00 00 00       	push   $0x85
  800632:	68 9c 3e 80 00       	push   $0x803e9c
  800637:	e8 79 04 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[2]] = 10;
  80063c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800642:	89 c2                	mov    %eax,%edx
  800644:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800647:	01 d0                	add    %edx,%eax
  800649:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80064c:	e8 86 1d 00 00       	call   8023d7 <sys_rcr2>
  800651:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  800657:	89 d1                	mov    %edx,%ecx
  800659:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065c:	01 ca                	add    %ecx,%edx
  80065e:	39 d0                	cmp    %edx,%eax
  800660:	74 17                	je     800679 <_main+0x641>
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 84 3f 80 00       	push   $0x803f84
  80066a:	68 87 00 00 00       	push   $0x87
  80066f:	68 9c 3e 80 00       	push   $0x803e9c
  800674:	e8 3c 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800679:	e8 da 19 00 00       	call   802058 <sys_calculate_free_frames>
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800681:	e8 72 1a 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  800686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800689:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	50                   	push   %eax
  800690:	e8 d7 16 00 00       	call   801d6c <free>
  800695:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800698:	e8 5b 1a 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 48 3f 80 00       	push   $0x803f48
  8006aa:	68 8c 00 00 00       	push   $0x8c
  8006af:	68 9c 3e 80 00       	push   $0x803e9c
  8006b4:	e8 fc 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  8006b9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8006bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c2:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006c5:	e8 0d 1d 00 00       	call   8023d7 <sys_rcr2>
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006cf:	39 c2                	cmp    %eax,%edx
  8006d1:	74 17                	je     8006ea <_main+0x6b2>
  8006d3:	83 ec 04             	sub    $0x4,%esp
  8006d6:	68 84 3f 80 00       	push   $0x803f84
  8006db:	68 90 00 00 00       	push   $0x90
  8006e0:	68 9c 3e 80 00       	push   $0x803e9c
  8006e5:	e8 cb 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[3]] = 10;
  8006ea:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006fa:	e8 d8 1c 00 00       	call   8023d7 <sys_rcr2>
  8006ff:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800705:	89 d1                	mov    %edx,%ecx
  800707:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80070a:	01 ca                	add    %ecx,%edx
  80070c:	39 d0                	cmp    %edx,%eax
  80070e:	74 17                	je     800727 <_main+0x6ef>
  800710:	83 ec 04             	sub    $0x4,%esp
  800713:	68 84 3f 80 00       	push   $0x803f84
  800718:	68 92 00 00 00       	push   $0x92
  80071d:	68 9c 3e 80 00       	push   $0x803e9c
  800722:	e8 8e 03 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800727:	e8 2c 19 00 00       	call   802058 <sys_calculate_free_frames>
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80072f:	e8 c4 19 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  800734:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  800737:	8b 45 90             	mov    -0x70(%ebp),%eax
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	50                   	push   %eax
  80073e:	e8 29 16 00 00       	call   801d6c <free>
  800743:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800746:	e8 ad 19 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  80074b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80074e:	74 17                	je     800767 <_main+0x72f>
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	68 48 3f 80 00       	push   $0x803f48
  800758:	68 97 00 00 00       	push   $0x97
  80075d:	68 9c 3e 80 00       	push   $0x803e9c
  800762:	e8 4e 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  800767:	8b 45 90             	mov    -0x70(%ebp),%eax
  80076a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80076d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800770:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800773:	e8 5f 1c 00 00       	call   8023d7 <sys_rcr2>
  800778:	89 c2                	mov    %eax,%edx
  80077a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	74 17                	je     800798 <_main+0x760>
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	68 84 3f 80 00       	push   $0x803f84
  800789:	68 9b 00 00 00       	push   $0x9b
  80078e:	68 9c 3e 80 00       	push   $0x803e9c
  800793:	e8 1d 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[4]] = 10;
  800798:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80079e:	89 c2                	mov    %eax,%edx
  8007a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a3:	01 d0                	add    %edx,%eax
  8007a5:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007a8:	e8 2a 1c 00 00       	call   8023d7 <sys_rcr2>
  8007ad:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  8007b3:	89 d1                	mov    %edx,%ecx
  8007b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007b8:	01 ca                	add    %ecx,%edx
  8007ba:	39 d0                	cmp    %edx,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 84 3f 80 00       	push   $0x803f84
  8007c6:	68 9d 00 00 00       	push   $0x9d
  8007cb:	68 9c 3e 80 00       	push   $0x803e9c
  8007d0:	e8 e0 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8007d5:	e8 7e 18 00 00       	call   802058 <sys_calculate_free_frames>
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007dd:	e8 16 19 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  8007e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  8007e5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	50                   	push   %eax
  8007ec:	e8 7b 15 00 00       	call   801d6c <free>
  8007f1:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  8007f4:	e8 ff 18 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  8007f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8007fc:	74 17                	je     800815 <_main+0x7dd>
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	68 48 3f 80 00       	push   $0x803f48
  800806:	68 a2 00 00 00       	push   $0xa2
  80080b:	68 9c 3e 80 00       	push   $0x803e9c
  800810:	e8 a0 02 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  800815:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800818:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80081b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80081e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800821:	e8 b1 1b 00 00       	call   8023d7 <sys_rcr2>
  800826:	89 c2                	mov    %eax,%edx
  800828:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80082b:	39 c2                	cmp    %eax,%edx
  80082d:	74 17                	je     800846 <_main+0x80e>
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 84 3f 80 00       	push   $0x803f84
  800837:	68 a6 00 00 00       	push   $0xa6
  80083c:	68 9c 3e 80 00       	push   $0x803e9c
  800841:	e8 6f 02 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[5]] = 10;
  800846:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800856:	e8 7c 1b 00 00       	call   8023d7 <sys_rcr2>
  80085b:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  800861:	89 d1                	mov    %edx,%ecx
  800863:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800866:	01 ca                	add    %ecx,%edx
  800868:	39 d0                	cmp    %edx,%eax
  80086a:	74 17                	je     800883 <_main+0x84b>
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	68 84 3f 80 00       	push   $0x803f84
  800874:	68 a8 00 00 00       	push   $0xa8
  800879:	68 9c 3e 80 00       	push   $0x803e9c
  80087e:	e8 32 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800883:	e8 d0 17 00 00       	call   802058 <sys_calculate_free_frames>
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80088b:	e8 68 18 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  800890:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  800893:	8b 45 98             	mov    -0x68(%ebp),%eax
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	50                   	push   %eax
  80089a:	e8 cd 14 00 00       	call   801d6c <free>
  80089f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8008a2:	e8 51 18 00 00       	call   8020f8 <sys_pf_calculate_allocated_pages>
  8008a7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8008aa:	74 17                	je     8008c3 <_main+0x88b>
  8008ac:	83 ec 04             	sub    $0x4,%esp
  8008af:	68 48 3f 80 00       	push   $0x803f48
  8008b4:	68 ad 00 00 00       	push   $0xad
  8008b9:	68 9c 3e 80 00       	push   $0x803e9c
  8008be:	e8 f2 01 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  8008c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8008c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008cc:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8008cf:	e8 03 1b 00 00       	call   8023d7 <sys_rcr2>
  8008d4:	89 c2                	mov    %eax,%edx
  8008d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008d9:	39 c2                	cmp    %eax,%edx
  8008db:	74 17                	je     8008f4 <_main+0x8bc>
  8008dd:	83 ec 04             	sub    $0x4,%esp
  8008e0:	68 84 3f 80 00       	push   $0x803f84
  8008e5:	68 b1 00 00 00       	push   $0xb1
  8008ea:	68 9c 3e 80 00       	push   $0x803e9c
  8008ef:	e8 c1 01 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[6]] = 10;
  8008f4:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8008fa:	89 c2                	mov    %eax,%edx
  8008fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008ff:	01 d0                	add    %edx,%eax
  800901:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800904:	e8 ce 1a 00 00       	call   8023d7 <sys_rcr2>
  800909:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  80090f:	89 d1                	mov    %edx,%ecx
  800911:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800914:	01 ca                	add    %ecx,%edx
  800916:	39 d0                	cmp    %edx,%eax
  800918:	74 17                	je     800931 <_main+0x8f9>
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	68 84 3f 80 00       	push   $0x803f84
  800922:	68 b3 00 00 00       	push   $0xb3
  800927:	68 9c 3e 80 00       	push   $0x803e9c
  80092c:	e8 84 01 00 00       	call   800ab5 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames()) ) {panic("Wrong free: not all pages removed correctly at end");}
  800931:	e8 22 17 00 00       	call   802058 <sys_calculate_free_frames>
  800936:	89 c2                	mov    %eax,%edx
  800938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80093b:	39 c2                	cmp    %eax,%edx
  80093d:	74 17                	je     800956 <_main+0x91e>
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	68 c8 3f 80 00       	push   $0x803fc8
  800947:	68 b5 00 00 00       	push   $0xb5
  80094c:	68 9c 3e 80 00       	push   $0x803e9c
  800951:	e8 5f 01 00 00       	call   800ab5 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  800956:	83 ec 0c             	sub    $0xc,%esp
  800959:	6a 00                	push   $0x0
  80095b:	e8 90 1a 00 00       	call   8023f0 <sys_bypassPageFault>
  800960:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  800963:	83 ec 0c             	sub    $0xc,%esp
  800966:	68 fc 3f 80 00       	push   $0x803ffc
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
  80097f:	e8 b4 19 00 00       	call   802338 <sys_getenvindex>
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
  8009ea:	e8 56 17 00 00       	call   802145 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009ef:	83 ec 0c             	sub    $0xc,%esp
  8009f2:	68 50 40 80 00       	push   $0x804050
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
  800a1a:	68 78 40 80 00       	push   $0x804078
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
  800a4b:	68 a0 40 80 00       	push   $0x8040a0
  800a50:	e8 14 03 00 00       	call   800d69 <cprintf>
  800a55:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a58:	a1 20 50 80 00       	mov    0x805020,%eax
  800a5d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	50                   	push   %eax
  800a67:	68 f8 40 80 00       	push   $0x8040f8
  800a6c:	e8 f8 02 00 00       	call   800d69 <cprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	68 50 40 80 00       	push   $0x804050
  800a7c:	e8 e8 02 00 00       	call   800d69 <cprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a84:	e8 d6 16 00 00       	call   80215f <sys_enable_interrupt>

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
  800a9c:	e8 63 18 00 00       	call   802304 <sys_destroy_env>
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
  800aad:	e8 b8 18 00 00       	call   80236a <sys_exit_env>
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
  800ad6:	68 0c 41 80 00       	push   $0x80410c
  800adb:	e8 89 02 00 00       	call   800d69 <cprintf>
  800ae0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ae3:	a1 00 50 80 00       	mov    0x805000,%eax
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	50                   	push   %eax
  800aef:	68 11 41 80 00       	push   $0x804111
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
  800b13:	68 2d 41 80 00       	push   $0x80412d
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
  800b3f:	68 30 41 80 00       	push   $0x804130
  800b44:	6a 26                	push   $0x26
  800b46:	68 7c 41 80 00       	push   $0x80417c
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
  800c11:	68 88 41 80 00       	push   $0x804188
  800c16:	6a 3a                	push   $0x3a
  800c18:	68 7c 41 80 00       	push   $0x80417c
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
  800c81:	68 dc 41 80 00       	push   $0x8041dc
  800c86:	6a 44                	push   $0x44
  800c88:	68 7c 41 80 00       	push   $0x80417c
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
  800cdb:	e8 b7 12 00 00       	call   801f97 <sys_cputs>
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
  800d52:	e8 40 12 00 00       	call   801f97 <sys_cputs>
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
  800d9c:	e8 a4 13 00 00       	call   802145 <sys_disable_interrupt>
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
  800dbc:	e8 9e 13 00 00       	call   80215f <sys_enable_interrupt>
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
  800e06:	e8 11 2e 00 00       	call   803c1c <__udivdi3>
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
  800e56:	e8 d1 2e 00 00       	call   803d2c <__umoddi3>
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	05 54 44 80 00       	add    $0x804454,%eax
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
  800fb1:	8b 04 85 78 44 80 00 	mov    0x804478(,%eax,4),%eax
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
  801092:	8b 34 9d c0 42 80 00 	mov    0x8042c0(,%ebx,4),%esi
  801099:	85 f6                	test   %esi,%esi
  80109b:	75 19                	jne    8010b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80109d:	53                   	push   %ebx
  80109e:	68 65 44 80 00       	push   $0x804465
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
  8010b7:	68 6e 44 80 00       	push   $0x80446e
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
  8010e4:	be 71 44 80 00       	mov    $0x804471,%esi
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
  801b0a:	68 d0 45 80 00       	push   $0x8045d0
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
  801bda:	e8 fc 04 00 00       	call   8020db <sys_allocate_chunk>
  801bdf:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801be2:	a1 20 51 80 00       	mov    0x805120,%eax
  801be7:	83 ec 0c             	sub    $0xc,%esp
  801bea:	50                   	push   %eax
  801beb:	e8 71 0b 00 00       	call   802761 <initialize_MemBlocksList>
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
  801c18:	68 f5 45 80 00       	push   $0x8045f5
  801c1d:	6a 33                	push   $0x33
  801c1f:	68 13 46 80 00       	push   $0x804613
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
  801c97:	68 20 46 80 00       	push   $0x804620
  801c9c:	6a 34                	push   $0x34
  801c9e:	68 13 46 80 00       	push   $0x804613
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
  801d2f:	e8 75 07 00 00       	call   8024a9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d34:	85 c0                	test   %eax,%eax
  801d36:	74 11                	je     801d49 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801d38:	83 ec 0c             	sub    $0xc,%esp
  801d3b:	ff 75 e8             	pushl  -0x18(%ebp)
  801d3e:	e8 e0 0d 00 00       	call   802b23 <alloc_block_FF>
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
  801d55:	e8 3c 0b 00 00       	call   802896 <insert_sorted_allocList>
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
  801d75:	68 44 46 80 00       	push   $0x804644
  801d7a:	6a 6f                	push   $0x6f
  801d7c:	68 13 46 80 00       	push   $0x804613
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
  801d9b:	75 0a                	jne    801da7 <smalloc+0x21>
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801da2:	e9 8b 00 00 00       	jmp    801e32 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801da7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db4:	01 d0                	add    %edx,%eax
  801db6:	48                   	dec    %eax
  801db7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc2:	f7 75 f0             	divl   -0x10(%ebp)
  801dc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc8:	29 d0                	sub    %edx,%eax
  801dca:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801dcd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801dd4:	e8 d0 06 00 00       	call   8024a9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	74 11                	je     801dee <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801ddd:	83 ec 0c             	sub    $0xc,%esp
  801de0:	ff 75 e8             	pushl  -0x18(%ebp)
  801de3:	e8 3b 0d 00 00       	call   802b23 <alloc_block_FF>
  801de8:	83 c4 10             	add    $0x10,%esp
  801deb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801dee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df2:	74 39                	je     801e2d <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df7:	8b 40 08             	mov    0x8(%eax),%eax
  801dfa:	89 c2                	mov    %eax,%edx
  801dfc:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801e00:	52                   	push   %edx
  801e01:	50                   	push   %eax
  801e02:	ff 75 0c             	pushl  0xc(%ebp)
  801e05:	ff 75 08             	pushl  0x8(%ebp)
  801e08:	e8 21 04 00 00       	call   80222e <sys_createSharedObject>
  801e0d:	83 c4 10             	add    $0x10,%esp
  801e10:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801e13:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801e17:	74 14                	je     801e2d <smalloc+0xa7>
  801e19:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801e1d:	74 0e                	je     801e2d <smalloc+0xa7>
  801e1f:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801e23:	74 08                	je     801e2d <smalloc+0xa7>
			return (void*) mem_block->sva;
  801e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e28:	8b 40 08             	mov    0x8(%eax),%eax
  801e2b:	eb 05                	jmp    801e32 <smalloc+0xac>
	}
	return NULL;
  801e2d:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e3a:	e8 b4 fc ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e3f:	83 ec 08             	sub    $0x8,%esp
  801e42:	ff 75 0c             	pushl  0xc(%ebp)
  801e45:	ff 75 08             	pushl  0x8(%ebp)
  801e48:	e8 0b 04 00 00       	call   802258 <sys_getSizeOfSharedObject>
  801e4d:	83 c4 10             	add    $0x10,%esp
  801e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801e53:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801e57:	74 76                	je     801ecf <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801e59:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801e60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e66:	01 d0                	add    %edx,%eax
  801e68:	48                   	dec    %eax
  801e69:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e74:	f7 75 ec             	divl   -0x14(%ebp)
  801e77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e7a:	29 d0                	sub    %edx,%eax
  801e7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801e7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801e86:	e8 1e 06 00 00       	call   8024a9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	74 11                	je     801ea0 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801e8f:	83 ec 0c             	sub    $0xc,%esp
  801e92:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e95:	e8 89 0c 00 00       	call   802b23 <alloc_block_FF>
  801e9a:	83 c4 10             	add    $0x10,%esp
  801e9d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801ea0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea4:	74 29                	je     801ecf <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea9:	8b 40 08             	mov    0x8(%eax),%eax
  801eac:	83 ec 04             	sub    $0x4,%esp
  801eaf:	50                   	push   %eax
  801eb0:	ff 75 0c             	pushl  0xc(%ebp)
  801eb3:	ff 75 08             	pushl  0x8(%ebp)
  801eb6:	e8 ba 03 00 00       	call   802275 <sys_getSharedObject>
  801ebb:	83 c4 10             	add    $0x10,%esp
  801ebe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801ec1:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801ec5:	74 08                	je     801ecf <sget+0x9b>
				return (void *)mem_block->sva;
  801ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eca:	8b 40 08             	mov    0x8(%eax),%eax
  801ecd:	eb 05                	jmp    801ed4 <sget+0xa0>
		}
	}
	return NULL;
  801ecf:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801edc:	e8 12 fc ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ee1:	83 ec 04             	sub    $0x4,%esp
  801ee4:	68 68 46 80 00       	push   $0x804668
  801ee9:	68 f1 00 00 00       	push   $0xf1
  801eee:	68 13 46 80 00       	push   $0x804613
  801ef3:	e8 bd eb ff ff       	call   800ab5 <_panic>

00801ef8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801efe:	83 ec 04             	sub    $0x4,%esp
  801f01:	68 90 46 80 00       	push   $0x804690
  801f06:	68 05 01 00 00       	push   $0x105
  801f0b:	68 13 46 80 00       	push   $0x804613
  801f10:	e8 a0 eb ff ff       	call   800ab5 <_panic>

00801f15 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f1b:	83 ec 04             	sub    $0x4,%esp
  801f1e:	68 b4 46 80 00       	push   $0x8046b4
  801f23:	68 10 01 00 00       	push   $0x110
  801f28:	68 13 46 80 00       	push   $0x804613
  801f2d:	e8 83 eb ff ff       	call   800ab5 <_panic>

00801f32 <shrink>:

}
void shrink(uint32 newSize)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f38:	83 ec 04             	sub    $0x4,%esp
  801f3b:	68 b4 46 80 00       	push   $0x8046b4
  801f40:	68 15 01 00 00       	push   $0x115
  801f45:	68 13 46 80 00       	push   $0x804613
  801f4a:	e8 66 eb ff ff       	call   800ab5 <_panic>

00801f4f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f55:	83 ec 04             	sub    $0x4,%esp
  801f58:	68 b4 46 80 00       	push   $0x8046b4
  801f5d:	68 1a 01 00 00       	push   $0x11a
  801f62:	68 13 46 80 00       	push   $0x804613
  801f67:	e8 49 eb ff ff       	call   800ab5 <_panic>

00801f6c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	57                   	push   %edi
  801f70:	56                   	push   %esi
  801f71:	53                   	push   %ebx
  801f72:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f7e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f81:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f84:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f87:	cd 30                	int    $0x30
  801f89:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	5b                   	pop    %ebx
  801f93:	5e                   	pop    %esi
  801f94:	5f                   	pop    %edi
  801f95:	5d                   	pop    %ebp
  801f96:	c3                   	ret    

00801f97 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	83 ec 04             	sub    $0x4,%esp
  801f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801fa3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	52                   	push   %edx
  801faf:	ff 75 0c             	pushl  0xc(%ebp)
  801fb2:	50                   	push   %eax
  801fb3:	6a 00                	push   $0x0
  801fb5:	e8 b2 ff ff ff       	call   801f6c <syscall>
  801fba:	83 c4 18             	add    $0x18,%esp
}
  801fbd:	90                   	nop
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <sys_cgetc>:

int
sys_cgetc(void)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 01                	push   $0x1
  801fcf:	e8 98 ff ff ff       	call   801f6c <syscall>
  801fd4:	83 c4 18             	add    $0x18,%esp
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801fdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	52                   	push   %edx
  801fe9:	50                   	push   %eax
  801fea:	6a 05                	push   $0x5
  801fec:	e8 7b ff ff ff       	call   801f6c <syscall>
  801ff1:	83 c4 18             	add    $0x18,%esp
}
  801ff4:	c9                   	leave  
  801ff5:	c3                   	ret    

00801ff6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
  801ff9:	56                   	push   %esi
  801ffa:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ffb:	8b 75 18             	mov    0x18(%ebp),%esi
  801ffe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802001:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802004:	8b 55 0c             	mov    0xc(%ebp),%edx
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	56                   	push   %esi
  80200b:	53                   	push   %ebx
  80200c:	51                   	push   %ecx
  80200d:	52                   	push   %edx
  80200e:	50                   	push   %eax
  80200f:	6a 06                	push   $0x6
  802011:	e8 56 ff ff ff       	call   801f6c <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
}
  802019:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80201c:	5b                   	pop    %ebx
  80201d:	5e                   	pop    %esi
  80201e:	5d                   	pop    %ebp
  80201f:	c3                   	ret    

00802020 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802023:	8b 55 0c             	mov    0xc(%ebp),%edx
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	52                   	push   %edx
  802030:	50                   	push   %eax
  802031:	6a 07                	push   $0x7
  802033:	e8 34 ff ff ff       	call   801f6c <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	ff 75 0c             	pushl  0xc(%ebp)
  802049:	ff 75 08             	pushl  0x8(%ebp)
  80204c:	6a 08                	push   $0x8
  80204e:	e8 19 ff ff ff       	call   801f6c <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 09                	push   $0x9
  802067:	e8 00 ff ff ff       	call   801f6c <syscall>
  80206c:	83 c4 18             	add    $0x18,%esp
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 0a                	push   $0xa
  802080:	e8 e7 fe ff ff       	call   801f6c <syscall>
  802085:	83 c4 18             	add    $0x18,%esp
}
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 0b                	push   $0xb
  802099:	e8 ce fe ff ff       	call   801f6c <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	ff 75 0c             	pushl  0xc(%ebp)
  8020af:	ff 75 08             	pushl  0x8(%ebp)
  8020b2:	6a 0f                	push   $0xf
  8020b4:	e8 b3 fe ff ff       	call   801f6c <syscall>
  8020b9:	83 c4 18             	add    $0x18,%esp
	return;
  8020bc:	90                   	nop
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	ff 75 0c             	pushl  0xc(%ebp)
  8020cb:	ff 75 08             	pushl  0x8(%ebp)
  8020ce:	6a 10                	push   $0x10
  8020d0:	e8 97 fe ff ff       	call   801f6c <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d8:	90                   	nop
}
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	ff 75 10             	pushl  0x10(%ebp)
  8020e5:	ff 75 0c             	pushl  0xc(%ebp)
  8020e8:	ff 75 08             	pushl  0x8(%ebp)
  8020eb:	6a 11                	push   $0x11
  8020ed:	e8 7a fe ff ff       	call   801f6c <syscall>
  8020f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f5:	90                   	nop
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 0c                	push   $0xc
  802107:	e8 60 fe ff ff       	call   801f6c <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	ff 75 08             	pushl  0x8(%ebp)
  80211f:	6a 0d                	push   $0xd
  802121:	e8 46 fe ff ff       	call   801f6c <syscall>
  802126:	83 c4 18             	add    $0x18,%esp
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 0e                	push   $0xe
  80213a:	e8 2d fe ff ff       	call   801f6c <syscall>
  80213f:	83 c4 18             	add    $0x18,%esp
}
  802142:	90                   	nop
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 13                	push   $0x13
  802154:	e8 13 fe ff ff       	call   801f6c <syscall>
  802159:	83 c4 18             	add    $0x18,%esp
}
  80215c:	90                   	nop
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 14                	push   $0x14
  80216e:	e8 f9 fd ff ff       	call   801f6c <syscall>
  802173:	83 c4 18             	add    $0x18,%esp
}
  802176:	90                   	nop
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <sys_cputc>:


void
sys_cputc(const char c)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
  80217c:	83 ec 04             	sub    $0x4,%esp
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802185:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	50                   	push   %eax
  802192:	6a 15                	push   $0x15
  802194:	e8 d3 fd ff ff       	call   801f6c <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
}
  80219c:	90                   	nop
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 16                	push   $0x16
  8021ae:	e8 b9 fd ff ff       	call   801f6c <syscall>
  8021b3:	83 c4 18             	add    $0x18,%esp
}
  8021b6:	90                   	nop
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    

008021b9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	ff 75 0c             	pushl  0xc(%ebp)
  8021c8:	50                   	push   %eax
  8021c9:	6a 17                	push   $0x17
  8021cb:	e8 9c fd ff ff       	call   801f6c <syscall>
  8021d0:	83 c4 18             	add    $0x18,%esp
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	52                   	push   %edx
  8021e5:	50                   	push   %eax
  8021e6:	6a 1a                	push   $0x1a
  8021e8:	e8 7f fd ff ff       	call   801f6c <syscall>
  8021ed:	83 c4 18             	add    $0x18,%esp
}
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	52                   	push   %edx
  802202:	50                   	push   %eax
  802203:	6a 18                	push   $0x18
  802205:	e8 62 fd ff ff       	call   801f6c <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
}
  80220d:	90                   	nop
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802213:	8b 55 0c             	mov    0xc(%ebp),%edx
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	52                   	push   %edx
  802220:	50                   	push   %eax
  802221:	6a 19                	push   $0x19
  802223:	e8 44 fd ff ff       	call   801f6c <syscall>
  802228:	83 c4 18             	add    $0x18,%esp
}
  80222b:	90                   	nop
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	8b 45 10             	mov    0x10(%ebp),%eax
  802237:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80223a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80223d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	6a 00                	push   $0x0
  802246:	51                   	push   %ecx
  802247:	52                   	push   %edx
  802248:	ff 75 0c             	pushl  0xc(%ebp)
  80224b:	50                   	push   %eax
  80224c:	6a 1b                	push   $0x1b
  80224e:	e8 19 fd ff ff       	call   801f6c <syscall>
  802253:	83 c4 18             	add    $0x18,%esp
}
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80225b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	52                   	push   %edx
  802268:	50                   	push   %eax
  802269:	6a 1c                	push   $0x1c
  80226b:	e8 fc fc ff ff       	call   801f6c <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802278:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80227b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	51                   	push   %ecx
  802286:	52                   	push   %edx
  802287:	50                   	push   %eax
  802288:	6a 1d                	push   $0x1d
  80228a:	e8 dd fc ff ff       	call   801f6c <syscall>
  80228f:	83 c4 18             	add    $0x18,%esp
}
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802297:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	52                   	push   %edx
  8022a4:	50                   	push   %eax
  8022a5:	6a 1e                	push   $0x1e
  8022a7:	e8 c0 fc ff ff       	call   801f6c <syscall>
  8022ac:	83 c4 18             	add    $0x18,%esp
}
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 1f                	push   $0x1f
  8022c0:	e8 a7 fc ff ff       	call   801f6c <syscall>
  8022c5:	83 c4 18             	add    $0x18,%esp
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	6a 00                	push   $0x0
  8022d2:	ff 75 14             	pushl  0x14(%ebp)
  8022d5:	ff 75 10             	pushl  0x10(%ebp)
  8022d8:	ff 75 0c             	pushl  0xc(%ebp)
  8022db:	50                   	push   %eax
  8022dc:	6a 20                	push   $0x20
  8022de:	e8 89 fc ff ff       	call   801f6c <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	50                   	push   %eax
  8022f7:	6a 21                	push   $0x21
  8022f9:	e8 6e fc ff ff       	call   801f6c <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
}
  802301:	90                   	nop
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	50                   	push   %eax
  802313:	6a 22                	push   $0x22
  802315:	e8 52 fc ff ff       	call   801f6c <syscall>
  80231a:	83 c4 18             	add    $0x18,%esp
}
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    

0080231f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 02                	push   $0x2
  80232e:	e8 39 fc ff ff       	call   801f6c <syscall>
  802333:	83 c4 18             	add    $0x18,%esp
}
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 03                	push   $0x3
  802347:	e8 20 fc ff ff       	call   801f6c <syscall>
  80234c:	83 c4 18             	add    $0x18,%esp
}
  80234f:	c9                   	leave  
  802350:	c3                   	ret    

00802351 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 04                	push   $0x4
  802360:	e8 07 fc ff ff       	call   801f6c <syscall>
  802365:	83 c4 18             	add    $0x18,%esp
}
  802368:	c9                   	leave  
  802369:	c3                   	ret    

0080236a <sys_exit_env>:


void sys_exit_env(void)
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 23                	push   $0x23
  802379:	e8 ee fb ff ff       	call   801f6c <syscall>
  80237e:	83 c4 18             	add    $0x18,%esp
}
  802381:	90                   	nop
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80238a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80238d:	8d 50 04             	lea    0x4(%eax),%edx
  802390:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	52                   	push   %edx
  80239a:	50                   	push   %eax
  80239b:	6a 24                	push   $0x24
  80239d:	e8 ca fb ff ff       	call   801f6c <syscall>
  8023a2:	83 c4 18             	add    $0x18,%esp
	return result;
  8023a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023ae:	89 01                	mov    %eax,(%ecx)
  8023b0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	c9                   	leave  
  8023b7:	c2 04 00             	ret    $0x4

008023ba <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	ff 75 10             	pushl  0x10(%ebp)
  8023c4:	ff 75 0c             	pushl  0xc(%ebp)
  8023c7:	ff 75 08             	pushl  0x8(%ebp)
  8023ca:	6a 12                	push   $0x12
  8023cc:	e8 9b fb ff ff       	call   801f6c <syscall>
  8023d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d4:	90                   	nop
}
  8023d5:	c9                   	leave  
  8023d6:	c3                   	ret    

008023d7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8023d7:	55                   	push   %ebp
  8023d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 25                	push   $0x25
  8023e6:	e8 81 fb ff ff       	call   801f6c <syscall>
  8023eb:	83 c4 18             	add    $0x18,%esp
}
  8023ee:	c9                   	leave  
  8023ef:	c3                   	ret    

008023f0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
  8023f3:	83 ec 04             	sub    $0x4,%esp
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023fc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	50                   	push   %eax
  802409:	6a 26                	push   $0x26
  80240b:	e8 5c fb ff ff       	call   801f6c <syscall>
  802410:	83 c4 18             	add    $0x18,%esp
	return ;
  802413:	90                   	nop
}
  802414:	c9                   	leave  
  802415:	c3                   	ret    

00802416 <rsttst>:
void rsttst()
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 28                	push   $0x28
  802425:	e8 42 fb ff ff       	call   801f6c <syscall>
  80242a:	83 c4 18             	add    $0x18,%esp
	return ;
  80242d:	90                   	nop
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
  802433:	83 ec 04             	sub    $0x4,%esp
  802436:	8b 45 14             	mov    0x14(%ebp),%eax
  802439:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80243c:	8b 55 18             	mov    0x18(%ebp),%edx
  80243f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802443:	52                   	push   %edx
  802444:	50                   	push   %eax
  802445:	ff 75 10             	pushl  0x10(%ebp)
  802448:	ff 75 0c             	pushl  0xc(%ebp)
  80244b:	ff 75 08             	pushl  0x8(%ebp)
  80244e:	6a 27                	push   $0x27
  802450:	e8 17 fb ff ff       	call   801f6c <syscall>
  802455:	83 c4 18             	add    $0x18,%esp
	return ;
  802458:	90                   	nop
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <chktst>:
void chktst(uint32 n)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	ff 75 08             	pushl  0x8(%ebp)
  802469:	6a 29                	push   $0x29
  80246b:	e8 fc fa ff ff       	call   801f6c <syscall>
  802470:	83 c4 18             	add    $0x18,%esp
	return ;
  802473:	90                   	nop
}
  802474:	c9                   	leave  
  802475:	c3                   	ret    

00802476 <inctst>:

void inctst()
{
  802476:	55                   	push   %ebp
  802477:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 2a                	push   $0x2a
  802485:	e8 e2 fa ff ff       	call   801f6c <syscall>
  80248a:	83 c4 18             	add    $0x18,%esp
	return ;
  80248d:	90                   	nop
}
  80248e:	c9                   	leave  
  80248f:	c3                   	ret    

00802490 <gettst>:
uint32 gettst()
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 2b                	push   $0x2b
  80249f:	e8 c8 fa ff ff       	call   801f6c <syscall>
  8024a4:	83 c4 18             	add    $0x18,%esp
}
  8024a7:	c9                   	leave  
  8024a8:	c3                   	ret    

008024a9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8024a9:	55                   	push   %ebp
  8024aa:	89 e5                	mov    %esp,%ebp
  8024ac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 2c                	push   $0x2c
  8024bb:	e8 ac fa ff ff       	call   801f6c <syscall>
  8024c0:	83 c4 18             	add    $0x18,%esp
  8024c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024c6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024ca:	75 07                	jne    8024d3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d1:	eb 05                	jmp    8024d8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 2c                	push   $0x2c
  8024ec:	e8 7b fa ff ff       	call   801f6c <syscall>
  8024f1:	83 c4 18             	add    $0x18,%esp
  8024f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024f7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024fb:	75 07                	jne    802504 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802502:	eb 05                	jmp    802509 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802504:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802509:	c9                   	leave  
  80250a:	c3                   	ret    

0080250b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
  80250e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 2c                	push   $0x2c
  80251d:	e8 4a fa ff ff       	call   801f6c <syscall>
  802522:	83 c4 18             	add    $0x18,%esp
  802525:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802528:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80252c:	75 07                	jne    802535 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80252e:	b8 01 00 00 00       	mov    $0x1,%eax
  802533:	eb 05                	jmp    80253a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802535:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80253a:	c9                   	leave  
  80253b:	c3                   	ret    

0080253c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
  80253f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 2c                	push   $0x2c
  80254e:	e8 19 fa ff ff       	call   801f6c <syscall>
  802553:	83 c4 18             	add    $0x18,%esp
  802556:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802559:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80255d:	75 07                	jne    802566 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80255f:	b8 01 00 00 00       	mov    $0x1,%eax
  802564:	eb 05                	jmp    80256b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802566:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80256b:	c9                   	leave  
  80256c:	c3                   	ret    

0080256d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	ff 75 08             	pushl  0x8(%ebp)
  80257b:	6a 2d                	push   $0x2d
  80257d:	e8 ea f9 ff ff       	call   801f6c <syscall>
  802582:	83 c4 18             	add    $0x18,%esp
	return ;
  802585:	90                   	nop
}
  802586:	c9                   	leave  
  802587:	c3                   	ret    

00802588 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802588:	55                   	push   %ebp
  802589:	89 e5                	mov    %esp,%ebp
  80258b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80258c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80258f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802592:	8b 55 0c             	mov    0xc(%ebp),%edx
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	6a 00                	push   $0x0
  80259a:	53                   	push   %ebx
  80259b:	51                   	push   %ecx
  80259c:	52                   	push   %edx
  80259d:	50                   	push   %eax
  80259e:	6a 2e                	push   $0x2e
  8025a0:	e8 c7 f9 ff ff       	call   801f6c <syscall>
  8025a5:	83 c4 18             	add    $0x18,%esp
}
  8025a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    

008025ad <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8025b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	52                   	push   %edx
  8025bd:	50                   	push   %eax
  8025be:	6a 2f                	push   $0x2f
  8025c0:	e8 a7 f9 ff ff       	call   801f6c <syscall>
  8025c5:	83 c4 18             	add    $0x18,%esp
}
  8025c8:	c9                   	leave  
  8025c9:	c3                   	ret    

008025ca <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8025ca:	55                   	push   %ebp
  8025cb:	89 e5                	mov    %esp,%ebp
  8025cd:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8025d0:	83 ec 0c             	sub    $0xc,%esp
  8025d3:	68 c4 46 80 00       	push   $0x8046c4
  8025d8:	e8 8c e7 ff ff       	call   800d69 <cprintf>
  8025dd:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8025e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8025e7:	83 ec 0c             	sub    $0xc,%esp
  8025ea:	68 f0 46 80 00       	push   $0x8046f0
  8025ef:	e8 75 e7 ff ff       	call   800d69 <cprintf>
  8025f4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8025f7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025fb:	a1 38 51 80 00       	mov    0x805138,%eax
  802600:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802603:	eb 56                	jmp    80265b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802605:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802609:	74 1c                	je     802627 <print_mem_block_lists+0x5d>
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	8b 50 08             	mov    0x8(%eax),%edx
  802611:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802614:	8b 48 08             	mov    0x8(%eax),%ecx
  802617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261a:	8b 40 0c             	mov    0xc(%eax),%eax
  80261d:	01 c8                	add    %ecx,%eax
  80261f:	39 c2                	cmp    %eax,%edx
  802621:	73 04                	jae    802627 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802623:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262a:	8b 50 08             	mov    0x8(%eax),%edx
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	8b 40 0c             	mov    0xc(%eax),%eax
  802633:	01 c2                	add    %eax,%edx
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 40 08             	mov    0x8(%eax),%eax
  80263b:	83 ec 04             	sub    $0x4,%esp
  80263e:	52                   	push   %edx
  80263f:	50                   	push   %eax
  802640:	68 05 47 80 00       	push   $0x804705
  802645:	e8 1f e7 ff ff       	call   800d69 <cprintf>
  80264a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802653:	a1 40 51 80 00       	mov    0x805140,%eax
  802658:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265f:	74 07                	je     802668 <print_mem_block_lists+0x9e>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 00                	mov    (%eax),%eax
  802666:	eb 05                	jmp    80266d <print_mem_block_lists+0xa3>
  802668:	b8 00 00 00 00       	mov    $0x0,%eax
  80266d:	a3 40 51 80 00       	mov    %eax,0x805140
  802672:	a1 40 51 80 00       	mov    0x805140,%eax
  802677:	85 c0                	test   %eax,%eax
  802679:	75 8a                	jne    802605 <print_mem_block_lists+0x3b>
  80267b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267f:	75 84                	jne    802605 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802681:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802685:	75 10                	jne    802697 <print_mem_block_lists+0xcd>
  802687:	83 ec 0c             	sub    $0xc,%esp
  80268a:	68 14 47 80 00       	push   $0x804714
  80268f:	e8 d5 e6 ff ff       	call   800d69 <cprintf>
  802694:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802697:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80269e:	83 ec 0c             	sub    $0xc,%esp
  8026a1:	68 38 47 80 00       	push   $0x804738
  8026a6:	e8 be e6 ff ff       	call   800d69 <cprintf>
  8026ab:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8026ae:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026b2:	a1 40 50 80 00       	mov    0x805040,%eax
  8026b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ba:	eb 56                	jmp    802712 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026c0:	74 1c                	je     8026de <print_mem_block_lists+0x114>
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 50 08             	mov    0x8(%eax),%edx
  8026c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cb:	8b 48 08             	mov    0x8(%eax),%ecx
  8026ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d4:	01 c8                	add    %ecx,%eax
  8026d6:	39 c2                	cmp    %eax,%edx
  8026d8:	73 04                	jae    8026de <print_mem_block_lists+0x114>
			sorted = 0 ;
  8026da:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	8b 50 08             	mov    0x8(%eax),%edx
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ea:	01 c2                	add    %eax,%edx
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 40 08             	mov    0x8(%eax),%eax
  8026f2:	83 ec 04             	sub    $0x4,%esp
  8026f5:	52                   	push   %edx
  8026f6:	50                   	push   %eax
  8026f7:	68 05 47 80 00       	push   $0x804705
  8026fc:	e8 68 e6 ff ff       	call   800d69 <cprintf>
  802701:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80270a:	a1 48 50 80 00       	mov    0x805048,%eax
  80270f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802716:	74 07                	je     80271f <print_mem_block_lists+0x155>
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 00                	mov    (%eax),%eax
  80271d:	eb 05                	jmp    802724 <print_mem_block_lists+0x15a>
  80271f:	b8 00 00 00 00       	mov    $0x0,%eax
  802724:	a3 48 50 80 00       	mov    %eax,0x805048
  802729:	a1 48 50 80 00       	mov    0x805048,%eax
  80272e:	85 c0                	test   %eax,%eax
  802730:	75 8a                	jne    8026bc <print_mem_block_lists+0xf2>
  802732:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802736:	75 84                	jne    8026bc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802738:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80273c:	75 10                	jne    80274e <print_mem_block_lists+0x184>
  80273e:	83 ec 0c             	sub    $0xc,%esp
  802741:	68 50 47 80 00       	push   $0x804750
  802746:	e8 1e e6 ff ff       	call   800d69 <cprintf>
  80274b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80274e:	83 ec 0c             	sub    $0xc,%esp
  802751:	68 c4 46 80 00       	push   $0x8046c4
  802756:	e8 0e e6 ff ff       	call   800d69 <cprintf>
  80275b:	83 c4 10             	add    $0x10,%esp

}
  80275e:	90                   	nop
  80275f:	c9                   	leave  
  802760:	c3                   	ret    

00802761 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802761:	55                   	push   %ebp
  802762:	89 e5                	mov    %esp,%ebp
  802764:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802767:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80276e:	00 00 00 
  802771:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802778:	00 00 00 
  80277b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802782:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802785:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80278c:	e9 9e 00 00 00       	jmp    80282f <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802791:	a1 50 50 80 00       	mov    0x805050,%eax
  802796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802799:	c1 e2 04             	shl    $0x4,%edx
  80279c:	01 d0                	add    %edx,%eax
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	75 14                	jne    8027b6 <initialize_MemBlocksList+0x55>
  8027a2:	83 ec 04             	sub    $0x4,%esp
  8027a5:	68 78 47 80 00       	push   $0x804778
  8027aa:	6a 46                	push   $0x46
  8027ac:	68 9b 47 80 00       	push   $0x80479b
  8027b1:	e8 ff e2 ff ff       	call   800ab5 <_panic>
  8027b6:	a1 50 50 80 00       	mov    0x805050,%eax
  8027bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027be:	c1 e2 04             	shl    $0x4,%edx
  8027c1:	01 d0                	add    %edx,%eax
  8027c3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8027c9:	89 10                	mov    %edx,(%eax)
  8027cb:	8b 00                	mov    (%eax),%eax
  8027cd:	85 c0                	test   %eax,%eax
  8027cf:	74 18                	je     8027e9 <initialize_MemBlocksList+0x88>
  8027d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8027d6:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8027dc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8027df:	c1 e1 04             	shl    $0x4,%ecx
  8027e2:	01 ca                	add    %ecx,%edx
  8027e4:	89 50 04             	mov    %edx,0x4(%eax)
  8027e7:	eb 12                	jmp    8027fb <initialize_MemBlocksList+0x9a>
  8027e9:	a1 50 50 80 00       	mov    0x805050,%eax
  8027ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f1:	c1 e2 04             	shl    $0x4,%edx
  8027f4:	01 d0                	add    %edx,%eax
  8027f6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027fb:	a1 50 50 80 00       	mov    0x805050,%eax
  802800:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802803:	c1 e2 04             	shl    $0x4,%edx
  802806:	01 d0                	add    %edx,%eax
  802808:	a3 48 51 80 00       	mov    %eax,0x805148
  80280d:	a1 50 50 80 00       	mov    0x805050,%eax
  802812:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802815:	c1 e2 04             	shl    $0x4,%edx
  802818:	01 d0                	add    %edx,%eax
  80281a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802821:	a1 54 51 80 00       	mov    0x805154,%eax
  802826:	40                   	inc    %eax
  802827:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80282c:	ff 45 f4             	incl   -0xc(%ebp)
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	3b 45 08             	cmp    0x8(%ebp),%eax
  802835:	0f 82 56 ff ff ff    	jb     802791 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80283b:	90                   	nop
  80283c:	c9                   	leave  
  80283d:	c3                   	ret    

0080283e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80283e:	55                   	push   %ebp
  80283f:	89 e5                	mov    %esp,%ebp
  802841:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802844:	8b 45 08             	mov    0x8(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80284c:	eb 19                	jmp    802867 <find_block+0x29>
	{
		if(va==point->sva)
  80284e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802851:	8b 40 08             	mov    0x8(%eax),%eax
  802854:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802857:	75 05                	jne    80285e <find_block+0x20>
		   return point;
  802859:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80285c:	eb 36                	jmp    802894 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80285e:	8b 45 08             	mov    0x8(%ebp),%eax
  802861:	8b 40 08             	mov    0x8(%eax),%eax
  802864:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802867:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80286b:	74 07                	je     802874 <find_block+0x36>
  80286d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802870:	8b 00                	mov    (%eax),%eax
  802872:	eb 05                	jmp    802879 <find_block+0x3b>
  802874:	b8 00 00 00 00       	mov    $0x0,%eax
  802879:	8b 55 08             	mov    0x8(%ebp),%edx
  80287c:	89 42 08             	mov    %eax,0x8(%edx)
  80287f:	8b 45 08             	mov    0x8(%ebp),%eax
  802882:	8b 40 08             	mov    0x8(%eax),%eax
  802885:	85 c0                	test   %eax,%eax
  802887:	75 c5                	jne    80284e <find_block+0x10>
  802889:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80288d:	75 bf                	jne    80284e <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80288f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802894:	c9                   	leave  
  802895:	c3                   	ret    

00802896 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802896:	55                   	push   %ebp
  802897:	89 e5                	mov    %esp,%ebp
  802899:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80289c:	a1 40 50 80 00       	mov    0x805040,%eax
  8028a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8028a4:	a1 44 50 80 00       	mov    0x805044,%eax
  8028a9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8028ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028af:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8028b2:	74 24                	je     8028d8 <insert_sorted_allocList+0x42>
  8028b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b7:	8b 50 08             	mov    0x8(%eax),%edx
  8028ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bd:	8b 40 08             	mov    0x8(%eax),%eax
  8028c0:	39 c2                	cmp    %eax,%edx
  8028c2:	76 14                	jbe    8028d8 <insert_sorted_allocList+0x42>
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	8b 50 08             	mov    0x8(%eax),%edx
  8028ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cd:	8b 40 08             	mov    0x8(%eax),%eax
  8028d0:	39 c2                	cmp    %eax,%edx
  8028d2:	0f 82 60 01 00 00    	jb     802a38 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8028d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028dc:	75 65                	jne    802943 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8028de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028e2:	75 14                	jne    8028f8 <insert_sorted_allocList+0x62>
  8028e4:	83 ec 04             	sub    $0x4,%esp
  8028e7:	68 78 47 80 00       	push   $0x804778
  8028ec:	6a 6b                	push   $0x6b
  8028ee:	68 9b 47 80 00       	push   $0x80479b
  8028f3:	e8 bd e1 ff ff       	call   800ab5 <_panic>
  8028f8:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802901:	89 10                	mov    %edx,(%eax)
  802903:	8b 45 08             	mov    0x8(%ebp),%eax
  802906:	8b 00                	mov    (%eax),%eax
  802908:	85 c0                	test   %eax,%eax
  80290a:	74 0d                	je     802919 <insert_sorted_allocList+0x83>
  80290c:	a1 40 50 80 00       	mov    0x805040,%eax
  802911:	8b 55 08             	mov    0x8(%ebp),%edx
  802914:	89 50 04             	mov    %edx,0x4(%eax)
  802917:	eb 08                	jmp    802921 <insert_sorted_allocList+0x8b>
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	a3 44 50 80 00       	mov    %eax,0x805044
  802921:	8b 45 08             	mov    0x8(%ebp),%eax
  802924:	a3 40 50 80 00       	mov    %eax,0x805040
  802929:	8b 45 08             	mov    0x8(%ebp),%eax
  80292c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802933:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802938:	40                   	inc    %eax
  802939:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80293e:	e9 dc 01 00 00       	jmp    802b1f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802943:	8b 45 08             	mov    0x8(%ebp),%eax
  802946:	8b 50 08             	mov    0x8(%eax),%edx
  802949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294c:	8b 40 08             	mov    0x8(%eax),%eax
  80294f:	39 c2                	cmp    %eax,%edx
  802951:	77 6c                	ja     8029bf <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802953:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802957:	74 06                	je     80295f <insert_sorted_allocList+0xc9>
  802959:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80295d:	75 14                	jne    802973 <insert_sorted_allocList+0xdd>
  80295f:	83 ec 04             	sub    $0x4,%esp
  802962:	68 b4 47 80 00       	push   $0x8047b4
  802967:	6a 6f                	push   $0x6f
  802969:	68 9b 47 80 00       	push   $0x80479b
  80296e:	e8 42 e1 ff ff       	call   800ab5 <_panic>
  802973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802976:	8b 50 04             	mov    0x4(%eax),%edx
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	89 50 04             	mov    %edx,0x4(%eax)
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802985:	89 10                	mov    %edx,(%eax)
  802987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298a:	8b 40 04             	mov    0x4(%eax),%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	74 0d                	je     80299e <insert_sorted_allocList+0x108>
  802991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802994:	8b 40 04             	mov    0x4(%eax),%eax
  802997:	8b 55 08             	mov    0x8(%ebp),%edx
  80299a:	89 10                	mov    %edx,(%eax)
  80299c:	eb 08                	jmp    8029a6 <insert_sorted_allocList+0x110>
  80299e:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a1:	a3 40 50 80 00       	mov    %eax,0x805040
  8029a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ac:	89 50 04             	mov    %edx,0x4(%eax)
  8029af:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029b4:	40                   	inc    %eax
  8029b5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029ba:	e9 60 01 00 00       	jmp    802b1f <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8029bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c2:	8b 50 08             	mov    0x8(%eax),%edx
  8029c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c8:	8b 40 08             	mov    0x8(%eax),%eax
  8029cb:	39 c2                	cmp    %eax,%edx
  8029cd:	0f 82 4c 01 00 00    	jb     802b1f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8029d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d7:	75 14                	jne    8029ed <insert_sorted_allocList+0x157>
  8029d9:	83 ec 04             	sub    $0x4,%esp
  8029dc:	68 ec 47 80 00       	push   $0x8047ec
  8029e1:	6a 73                	push   $0x73
  8029e3:	68 9b 47 80 00       	push   $0x80479b
  8029e8:	e8 c8 e0 ff ff       	call   800ab5 <_panic>
  8029ed:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	89 50 04             	mov    %edx,0x4(%eax)
  8029f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fc:	8b 40 04             	mov    0x4(%eax),%eax
  8029ff:	85 c0                	test   %eax,%eax
  802a01:	74 0c                	je     802a0f <insert_sorted_allocList+0x179>
  802a03:	a1 44 50 80 00       	mov    0x805044,%eax
  802a08:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0b:	89 10                	mov    %edx,(%eax)
  802a0d:	eb 08                	jmp    802a17 <insert_sorted_allocList+0x181>
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	a3 40 50 80 00       	mov    %eax,0x805040
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	a3 44 50 80 00       	mov    %eax,0x805044
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a28:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a2d:	40                   	inc    %eax
  802a2e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a33:	e9 e7 00 00 00       	jmp    802b1f <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802a3e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a45:	a1 40 50 80 00       	mov    0x805040,%eax
  802a4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a4d:	e9 9d 00 00 00       	jmp    802aef <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	8b 00                	mov    (%eax),%eax
  802a57:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5d:	8b 50 08             	mov    0x8(%eax),%edx
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	8b 40 08             	mov    0x8(%eax),%eax
  802a66:	39 c2                	cmp    %eax,%edx
  802a68:	76 7d                	jbe    802ae7 <insert_sorted_allocList+0x251>
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	8b 50 08             	mov    0x8(%eax),%edx
  802a70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a73:	8b 40 08             	mov    0x8(%eax),%eax
  802a76:	39 c2                	cmp    %eax,%edx
  802a78:	73 6d                	jae    802ae7 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802a7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7e:	74 06                	je     802a86 <insert_sorted_allocList+0x1f0>
  802a80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a84:	75 14                	jne    802a9a <insert_sorted_allocList+0x204>
  802a86:	83 ec 04             	sub    $0x4,%esp
  802a89:	68 10 48 80 00       	push   $0x804810
  802a8e:	6a 7f                	push   $0x7f
  802a90:	68 9b 47 80 00       	push   $0x80479b
  802a95:	e8 1b e0 ff ff       	call   800ab5 <_panic>
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	8b 10                	mov    (%eax),%edx
  802a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa2:	89 10                	mov    %edx,(%eax)
  802aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa7:	8b 00                	mov    (%eax),%eax
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	74 0b                	je     802ab8 <insert_sorted_allocList+0x222>
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	8b 00                	mov    (%eax),%eax
  802ab2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab5:	89 50 04             	mov    %edx,0x4(%eax)
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 55 08             	mov    0x8(%ebp),%edx
  802abe:	89 10                	mov    %edx,(%eax)
  802ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac6:	89 50 04             	mov    %edx,0x4(%eax)
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	8b 00                	mov    (%eax),%eax
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	75 08                	jne    802ada <insert_sorted_allocList+0x244>
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	a3 44 50 80 00       	mov    %eax,0x805044
  802ada:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802adf:	40                   	inc    %eax
  802ae0:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802ae5:	eb 39                	jmp    802b20 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802ae7:	a1 48 50 80 00       	mov    0x805048,%eax
  802aec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af3:	74 07                	je     802afc <insert_sorted_allocList+0x266>
  802af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af8:	8b 00                	mov    (%eax),%eax
  802afa:	eb 05                	jmp    802b01 <insert_sorted_allocList+0x26b>
  802afc:	b8 00 00 00 00       	mov    $0x0,%eax
  802b01:	a3 48 50 80 00       	mov    %eax,0x805048
  802b06:	a1 48 50 80 00       	mov    0x805048,%eax
  802b0b:	85 c0                	test   %eax,%eax
  802b0d:	0f 85 3f ff ff ff    	jne    802a52 <insert_sorted_allocList+0x1bc>
  802b13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b17:	0f 85 35 ff ff ff    	jne    802a52 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802b1d:	eb 01                	jmp    802b20 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b1f:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802b20:	90                   	nop
  802b21:	c9                   	leave  
  802b22:	c3                   	ret    

00802b23 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b23:	55                   	push   %ebp
  802b24:	89 e5                	mov    %esp,%ebp
  802b26:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802b29:	a1 38 51 80 00       	mov    0x805138,%eax
  802b2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b31:	e9 85 01 00 00       	jmp    802cbb <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b39:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3f:	0f 82 6e 01 00 00    	jb     802cb3 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b4e:	0f 85 8a 00 00 00    	jne    802bde <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802b54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b58:	75 17                	jne    802b71 <alloc_block_FF+0x4e>
  802b5a:	83 ec 04             	sub    $0x4,%esp
  802b5d:	68 44 48 80 00       	push   $0x804844
  802b62:	68 93 00 00 00       	push   $0x93
  802b67:	68 9b 47 80 00       	push   $0x80479b
  802b6c:	e8 44 df ff ff       	call   800ab5 <_panic>
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	8b 00                	mov    (%eax),%eax
  802b76:	85 c0                	test   %eax,%eax
  802b78:	74 10                	je     802b8a <alloc_block_FF+0x67>
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	8b 00                	mov    (%eax),%eax
  802b7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b82:	8b 52 04             	mov    0x4(%edx),%edx
  802b85:	89 50 04             	mov    %edx,0x4(%eax)
  802b88:	eb 0b                	jmp    802b95 <alloc_block_FF+0x72>
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 40 04             	mov    0x4(%eax),%eax
  802b90:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 40 04             	mov    0x4(%eax),%eax
  802b9b:	85 c0                	test   %eax,%eax
  802b9d:	74 0f                	je     802bae <alloc_block_FF+0x8b>
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	8b 40 04             	mov    0x4(%eax),%eax
  802ba5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba8:	8b 12                	mov    (%edx),%edx
  802baa:	89 10                	mov    %edx,(%eax)
  802bac:	eb 0a                	jmp    802bb8 <alloc_block_FF+0x95>
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	8b 00                	mov    (%eax),%eax
  802bb3:	a3 38 51 80 00       	mov    %eax,0x805138
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcb:	a1 44 51 80 00       	mov    0x805144,%eax
  802bd0:	48                   	dec    %eax
  802bd1:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	e9 10 01 00 00       	jmp    802cee <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be1:	8b 40 0c             	mov    0xc(%eax),%eax
  802be4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be7:	0f 86 c6 00 00 00    	jbe    802cb3 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bed:	a1 48 51 80 00       	mov    0x805148,%eax
  802bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 50 08             	mov    0x8(%eax),%edx
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c04:	8b 55 08             	mov    0x8(%ebp),%edx
  802c07:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c0e:	75 17                	jne    802c27 <alloc_block_FF+0x104>
  802c10:	83 ec 04             	sub    $0x4,%esp
  802c13:	68 44 48 80 00       	push   $0x804844
  802c18:	68 9b 00 00 00       	push   $0x9b
  802c1d:	68 9b 47 80 00       	push   $0x80479b
  802c22:	e8 8e de ff ff       	call   800ab5 <_panic>
  802c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2a:	8b 00                	mov    (%eax),%eax
  802c2c:	85 c0                	test   %eax,%eax
  802c2e:	74 10                	je     802c40 <alloc_block_FF+0x11d>
  802c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c33:	8b 00                	mov    (%eax),%eax
  802c35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c38:	8b 52 04             	mov    0x4(%edx),%edx
  802c3b:	89 50 04             	mov    %edx,0x4(%eax)
  802c3e:	eb 0b                	jmp    802c4b <alloc_block_FF+0x128>
  802c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c43:	8b 40 04             	mov    0x4(%eax),%eax
  802c46:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4e:	8b 40 04             	mov    0x4(%eax),%eax
  802c51:	85 c0                	test   %eax,%eax
  802c53:	74 0f                	je     802c64 <alloc_block_FF+0x141>
  802c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c58:	8b 40 04             	mov    0x4(%eax),%eax
  802c5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c5e:	8b 12                	mov    (%edx),%edx
  802c60:	89 10                	mov    %edx,(%eax)
  802c62:	eb 0a                	jmp    802c6e <alloc_block_FF+0x14b>
  802c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c67:	8b 00                	mov    (%eax),%eax
  802c69:	a3 48 51 80 00       	mov    %eax,0x805148
  802c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c81:	a1 54 51 80 00       	mov    0x805154,%eax
  802c86:	48                   	dec    %eax
  802c87:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	8b 50 08             	mov    0x8(%eax),%edx
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	01 c2                	add    %eax,%edx
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca3:	2b 45 08             	sub    0x8(%ebp),%eax
  802ca6:	89 c2                	mov    %eax,%edx
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb1:	eb 3b                	jmp    802cee <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802cb3:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbf:	74 07                	je     802cc8 <alloc_block_FF+0x1a5>
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 00                	mov    (%eax),%eax
  802cc6:	eb 05                	jmp    802ccd <alloc_block_FF+0x1aa>
  802cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccd:	a3 40 51 80 00       	mov    %eax,0x805140
  802cd2:	a1 40 51 80 00       	mov    0x805140,%eax
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	0f 85 57 fe ff ff    	jne    802b36 <alloc_block_FF+0x13>
  802cdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce3:	0f 85 4d fe ff ff    	jne    802b36 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802ce9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cee:	c9                   	leave  
  802cef:	c3                   	ret    

00802cf0 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802cf0:	55                   	push   %ebp
  802cf1:	89 e5                	mov    %esp,%ebp
  802cf3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802cf6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802cfd:	a1 38 51 80 00       	mov    0x805138,%eax
  802d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d05:	e9 df 00 00 00       	jmp    802de9 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d10:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d13:	0f 82 c8 00 00 00    	jb     802de1 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d22:	0f 85 8a 00 00 00    	jne    802db2 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802d28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2c:	75 17                	jne    802d45 <alloc_block_BF+0x55>
  802d2e:	83 ec 04             	sub    $0x4,%esp
  802d31:	68 44 48 80 00       	push   $0x804844
  802d36:	68 b7 00 00 00       	push   $0xb7
  802d3b:	68 9b 47 80 00       	push   $0x80479b
  802d40:	e8 70 dd ff ff       	call   800ab5 <_panic>
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	85 c0                	test   %eax,%eax
  802d4c:	74 10                	je     802d5e <alloc_block_BF+0x6e>
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	8b 00                	mov    (%eax),%eax
  802d53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d56:	8b 52 04             	mov    0x4(%edx),%edx
  802d59:	89 50 04             	mov    %edx,0x4(%eax)
  802d5c:	eb 0b                	jmp    802d69 <alloc_block_BF+0x79>
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	8b 40 04             	mov    0x4(%eax),%eax
  802d6f:	85 c0                	test   %eax,%eax
  802d71:	74 0f                	je     802d82 <alloc_block_BF+0x92>
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	8b 40 04             	mov    0x4(%eax),%eax
  802d79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7c:	8b 12                	mov    (%edx),%edx
  802d7e:	89 10                	mov    %edx,(%eax)
  802d80:	eb 0a                	jmp    802d8c <alloc_block_BF+0x9c>
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 00                	mov    (%eax),%eax
  802d87:	a3 38 51 80 00       	mov    %eax,0x805138
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9f:	a1 44 51 80 00       	mov    0x805144,%eax
  802da4:	48                   	dec    %eax
  802da5:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	e9 4d 01 00 00       	jmp    802eff <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db5:	8b 40 0c             	mov    0xc(%eax),%eax
  802db8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dbb:	76 24                	jbe    802de1 <alloc_block_BF+0xf1>
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802dc6:	73 19                	jae    802de1 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802dc8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 40 08             	mov    0x8(%eax),%eax
  802dde:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802de1:	a1 40 51 80 00       	mov    0x805140,%eax
  802de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ded:	74 07                	je     802df6 <alloc_block_BF+0x106>
  802def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df2:	8b 00                	mov    (%eax),%eax
  802df4:	eb 05                	jmp    802dfb <alloc_block_BF+0x10b>
  802df6:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfb:	a3 40 51 80 00       	mov    %eax,0x805140
  802e00:	a1 40 51 80 00       	mov    0x805140,%eax
  802e05:	85 c0                	test   %eax,%eax
  802e07:	0f 85 fd fe ff ff    	jne    802d0a <alloc_block_BF+0x1a>
  802e0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e11:	0f 85 f3 fe ff ff    	jne    802d0a <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802e17:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e1b:	0f 84 d9 00 00 00    	je     802efa <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e21:	a1 48 51 80 00       	mov    0x805148,%eax
  802e26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802e29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e2f:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802e32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e35:	8b 55 08             	mov    0x8(%ebp),%edx
  802e38:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802e3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e3f:	75 17                	jne    802e58 <alloc_block_BF+0x168>
  802e41:	83 ec 04             	sub    $0x4,%esp
  802e44:	68 44 48 80 00       	push   $0x804844
  802e49:	68 c7 00 00 00       	push   $0xc7
  802e4e:	68 9b 47 80 00       	push   $0x80479b
  802e53:	e8 5d dc ff ff       	call   800ab5 <_panic>
  802e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5b:	8b 00                	mov    (%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 10                	je     802e71 <alloc_block_BF+0x181>
  802e61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e64:	8b 00                	mov    (%eax),%eax
  802e66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e69:	8b 52 04             	mov    0x4(%edx),%edx
  802e6c:	89 50 04             	mov    %edx,0x4(%eax)
  802e6f:	eb 0b                	jmp    802e7c <alloc_block_BF+0x18c>
  802e71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e74:	8b 40 04             	mov    0x4(%eax),%eax
  802e77:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7f:	8b 40 04             	mov    0x4(%eax),%eax
  802e82:	85 c0                	test   %eax,%eax
  802e84:	74 0f                	je     802e95 <alloc_block_BF+0x1a5>
  802e86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e89:	8b 40 04             	mov    0x4(%eax),%eax
  802e8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e8f:	8b 12                	mov    (%edx),%edx
  802e91:	89 10                	mov    %edx,(%eax)
  802e93:	eb 0a                	jmp    802e9f <alloc_block_BF+0x1af>
  802e95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e98:	8b 00                	mov    (%eax),%eax
  802e9a:	a3 48 51 80 00       	mov    %eax,0x805148
  802e9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb2:	a1 54 51 80 00       	mov    0x805154,%eax
  802eb7:	48                   	dec    %eax
  802eb8:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802ebd:	83 ec 08             	sub    $0x8,%esp
  802ec0:	ff 75 ec             	pushl  -0x14(%ebp)
  802ec3:	68 38 51 80 00       	push   $0x805138
  802ec8:	e8 71 f9 ff ff       	call   80283e <find_block>
  802ecd:	83 c4 10             	add    $0x10,%esp
  802ed0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802ed3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed6:	8b 50 08             	mov    0x8(%eax),%edx
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	01 c2                	add    %eax,%edx
  802ede:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee1:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802ee4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eea:	2b 45 08             	sub    0x8(%ebp),%eax
  802eed:	89 c2                	mov    %eax,%edx
  802eef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef2:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802ef5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef8:	eb 05                	jmp    802eff <alloc_block_BF+0x20f>
	}
	return NULL;
  802efa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eff:	c9                   	leave  
  802f00:	c3                   	ret    

00802f01 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802f01:	55                   	push   %ebp
  802f02:	89 e5                	mov    %esp,%ebp
  802f04:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802f07:	a1 28 50 80 00       	mov    0x805028,%eax
  802f0c:	85 c0                	test   %eax,%eax
  802f0e:	0f 85 de 01 00 00    	jne    8030f2 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802f14:	a1 38 51 80 00       	mov    0x805138,%eax
  802f19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f1c:	e9 9e 01 00 00       	jmp    8030bf <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	8b 40 0c             	mov    0xc(%eax),%eax
  802f27:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f2a:	0f 82 87 01 00 00    	jb     8030b7 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 40 0c             	mov    0xc(%eax),%eax
  802f36:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f39:	0f 85 95 00 00 00    	jne    802fd4 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802f3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f43:	75 17                	jne    802f5c <alloc_block_NF+0x5b>
  802f45:	83 ec 04             	sub    $0x4,%esp
  802f48:	68 44 48 80 00       	push   $0x804844
  802f4d:	68 e0 00 00 00       	push   $0xe0
  802f52:	68 9b 47 80 00       	push   $0x80479b
  802f57:	e8 59 db ff ff       	call   800ab5 <_panic>
  802f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5f:	8b 00                	mov    (%eax),%eax
  802f61:	85 c0                	test   %eax,%eax
  802f63:	74 10                	je     802f75 <alloc_block_NF+0x74>
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	8b 00                	mov    (%eax),%eax
  802f6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f6d:	8b 52 04             	mov    0x4(%edx),%edx
  802f70:	89 50 04             	mov    %edx,0x4(%eax)
  802f73:	eb 0b                	jmp    802f80 <alloc_block_NF+0x7f>
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	8b 40 04             	mov    0x4(%eax),%eax
  802f7b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	8b 40 04             	mov    0x4(%eax),%eax
  802f86:	85 c0                	test   %eax,%eax
  802f88:	74 0f                	je     802f99 <alloc_block_NF+0x98>
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	8b 40 04             	mov    0x4(%eax),%eax
  802f90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f93:	8b 12                	mov    (%edx),%edx
  802f95:	89 10                	mov    %edx,(%eax)
  802f97:	eb 0a                	jmp    802fa3 <alloc_block_NF+0xa2>
  802f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9c:	8b 00                	mov    (%eax),%eax
  802f9e:	a3 38 51 80 00       	mov    %eax,0x805138
  802fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb6:	a1 44 51 80 00       	mov    0x805144,%eax
  802fbb:	48                   	dec    %eax
  802fbc:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 40 08             	mov    0x8(%eax),%eax
  802fc7:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	e9 f8 04 00 00       	jmp    8034cc <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fda:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fdd:	0f 86 d4 00 00 00    	jbe    8030b7 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fe3:	a1 48 51 80 00       	mov    0x805148,%eax
  802fe8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	8b 50 08             	mov    0x8(%eax),%edx
  802ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff4:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  802ffd:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803000:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803004:	75 17                	jne    80301d <alloc_block_NF+0x11c>
  803006:	83 ec 04             	sub    $0x4,%esp
  803009:	68 44 48 80 00       	push   $0x804844
  80300e:	68 e9 00 00 00       	push   $0xe9
  803013:	68 9b 47 80 00       	push   $0x80479b
  803018:	e8 98 da ff ff       	call   800ab5 <_panic>
  80301d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803020:	8b 00                	mov    (%eax),%eax
  803022:	85 c0                	test   %eax,%eax
  803024:	74 10                	je     803036 <alloc_block_NF+0x135>
  803026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803029:	8b 00                	mov    (%eax),%eax
  80302b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80302e:	8b 52 04             	mov    0x4(%edx),%edx
  803031:	89 50 04             	mov    %edx,0x4(%eax)
  803034:	eb 0b                	jmp    803041 <alloc_block_NF+0x140>
  803036:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803039:	8b 40 04             	mov    0x4(%eax),%eax
  80303c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803044:	8b 40 04             	mov    0x4(%eax),%eax
  803047:	85 c0                	test   %eax,%eax
  803049:	74 0f                	je     80305a <alloc_block_NF+0x159>
  80304b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304e:	8b 40 04             	mov    0x4(%eax),%eax
  803051:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803054:	8b 12                	mov    (%edx),%edx
  803056:	89 10                	mov    %edx,(%eax)
  803058:	eb 0a                	jmp    803064 <alloc_block_NF+0x163>
  80305a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305d:	8b 00                	mov    (%eax),%eax
  80305f:	a3 48 51 80 00       	mov    %eax,0x805148
  803064:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803067:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803070:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803077:	a1 54 51 80 00       	mov    0x805154,%eax
  80307c:	48                   	dec    %eax
  80307d:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803085:	8b 40 08             	mov    0x8(%eax),%eax
  803088:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80308d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803090:	8b 50 08             	mov    0x8(%eax),%edx
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	01 c2                	add    %eax,%edx
  803098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309b:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80309e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a4:	2b 45 08             	sub    0x8(%ebp),%eax
  8030a7:	89 c2                	mov    %eax,%edx
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8030af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b2:	e9 15 04 00 00       	jmp    8034cc <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8030b7:	a1 40 51 80 00       	mov    0x805140,%eax
  8030bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c3:	74 07                	je     8030cc <alloc_block_NF+0x1cb>
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	8b 00                	mov    (%eax),%eax
  8030ca:	eb 05                	jmp    8030d1 <alloc_block_NF+0x1d0>
  8030cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8030d1:	a3 40 51 80 00       	mov    %eax,0x805140
  8030d6:	a1 40 51 80 00       	mov    0x805140,%eax
  8030db:	85 c0                	test   %eax,%eax
  8030dd:	0f 85 3e fe ff ff    	jne    802f21 <alloc_block_NF+0x20>
  8030e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e7:	0f 85 34 fe ff ff    	jne    802f21 <alloc_block_NF+0x20>
  8030ed:	e9 d5 03 00 00       	jmp    8034c7 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030f2:	a1 38 51 80 00       	mov    0x805138,%eax
  8030f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030fa:	e9 b1 01 00 00       	jmp    8032b0 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	8b 50 08             	mov    0x8(%eax),%edx
  803105:	a1 28 50 80 00       	mov    0x805028,%eax
  80310a:	39 c2                	cmp    %eax,%edx
  80310c:	0f 82 96 01 00 00    	jb     8032a8 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803115:	8b 40 0c             	mov    0xc(%eax),%eax
  803118:	3b 45 08             	cmp    0x8(%ebp),%eax
  80311b:	0f 82 87 01 00 00    	jb     8032a8 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	8b 40 0c             	mov    0xc(%eax),%eax
  803127:	3b 45 08             	cmp    0x8(%ebp),%eax
  80312a:	0f 85 95 00 00 00    	jne    8031c5 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803130:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803134:	75 17                	jne    80314d <alloc_block_NF+0x24c>
  803136:	83 ec 04             	sub    $0x4,%esp
  803139:	68 44 48 80 00       	push   $0x804844
  80313e:	68 fc 00 00 00       	push   $0xfc
  803143:	68 9b 47 80 00       	push   $0x80479b
  803148:	e8 68 d9 ff ff       	call   800ab5 <_panic>
  80314d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803150:	8b 00                	mov    (%eax),%eax
  803152:	85 c0                	test   %eax,%eax
  803154:	74 10                	je     803166 <alloc_block_NF+0x265>
  803156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803159:	8b 00                	mov    (%eax),%eax
  80315b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80315e:	8b 52 04             	mov    0x4(%edx),%edx
  803161:	89 50 04             	mov    %edx,0x4(%eax)
  803164:	eb 0b                	jmp    803171 <alloc_block_NF+0x270>
  803166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803169:	8b 40 04             	mov    0x4(%eax),%eax
  80316c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	8b 40 04             	mov    0x4(%eax),%eax
  803177:	85 c0                	test   %eax,%eax
  803179:	74 0f                	je     80318a <alloc_block_NF+0x289>
  80317b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317e:	8b 40 04             	mov    0x4(%eax),%eax
  803181:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803184:	8b 12                	mov    (%edx),%edx
  803186:	89 10                	mov    %edx,(%eax)
  803188:	eb 0a                	jmp    803194 <alloc_block_NF+0x293>
  80318a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318d:	8b 00                	mov    (%eax),%eax
  80318f:	a3 38 51 80 00       	mov    %eax,0x805138
  803194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803197:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80319d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a7:	a1 44 51 80 00       	mov    0x805144,%eax
  8031ac:	48                   	dec    %eax
  8031ad:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8031b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b5:	8b 40 08             	mov    0x8(%eax),%eax
  8031b8:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8031bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c0:	e9 07 03 00 00       	jmp    8034cc <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8031c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ce:	0f 86 d4 00 00 00    	jbe    8032a8 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8031d4:	a1 48 51 80 00       	mov    0x805148,%eax
  8031d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	8b 50 08             	mov    0x8(%eax),%edx
  8031e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8031e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ee:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8031f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031f5:	75 17                	jne    80320e <alloc_block_NF+0x30d>
  8031f7:	83 ec 04             	sub    $0x4,%esp
  8031fa:	68 44 48 80 00       	push   $0x804844
  8031ff:	68 04 01 00 00       	push   $0x104
  803204:	68 9b 47 80 00       	push   $0x80479b
  803209:	e8 a7 d8 ff ff       	call   800ab5 <_panic>
  80320e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803211:	8b 00                	mov    (%eax),%eax
  803213:	85 c0                	test   %eax,%eax
  803215:	74 10                	je     803227 <alloc_block_NF+0x326>
  803217:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321a:	8b 00                	mov    (%eax),%eax
  80321c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80321f:	8b 52 04             	mov    0x4(%edx),%edx
  803222:	89 50 04             	mov    %edx,0x4(%eax)
  803225:	eb 0b                	jmp    803232 <alloc_block_NF+0x331>
  803227:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322a:	8b 40 04             	mov    0x4(%eax),%eax
  80322d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803232:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803235:	8b 40 04             	mov    0x4(%eax),%eax
  803238:	85 c0                	test   %eax,%eax
  80323a:	74 0f                	je     80324b <alloc_block_NF+0x34a>
  80323c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323f:	8b 40 04             	mov    0x4(%eax),%eax
  803242:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803245:	8b 12                	mov    (%edx),%edx
  803247:	89 10                	mov    %edx,(%eax)
  803249:	eb 0a                	jmp    803255 <alloc_block_NF+0x354>
  80324b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324e:	8b 00                	mov    (%eax),%eax
  803250:	a3 48 51 80 00       	mov    %eax,0x805148
  803255:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80325e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803261:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803268:	a1 54 51 80 00       	mov    0x805154,%eax
  80326d:	48                   	dec    %eax
  80326e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803273:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803276:	8b 40 08             	mov    0x8(%eax),%eax
  803279:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	8b 50 08             	mov    0x8(%eax),%edx
  803284:	8b 45 08             	mov    0x8(%ebp),%eax
  803287:	01 c2                	add    %eax,%edx
  803289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80328f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803292:	8b 40 0c             	mov    0xc(%eax),%eax
  803295:	2b 45 08             	sub    0x8(%ebp),%eax
  803298:	89 c2                	mov    %eax,%edx
  80329a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8032a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a3:	e9 24 02 00 00       	jmp    8034cc <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8032a8:	a1 40 51 80 00       	mov    0x805140,%eax
  8032ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b4:	74 07                	je     8032bd <alloc_block_NF+0x3bc>
  8032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b9:	8b 00                	mov    (%eax),%eax
  8032bb:	eb 05                	jmp    8032c2 <alloc_block_NF+0x3c1>
  8032bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c2:	a3 40 51 80 00       	mov    %eax,0x805140
  8032c7:	a1 40 51 80 00       	mov    0x805140,%eax
  8032cc:	85 c0                	test   %eax,%eax
  8032ce:	0f 85 2b fe ff ff    	jne    8030ff <alloc_block_NF+0x1fe>
  8032d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d8:	0f 85 21 fe ff ff    	jne    8030ff <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8032de:	a1 38 51 80 00       	mov    0x805138,%eax
  8032e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032e6:	e9 ae 01 00 00       	jmp    803499 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8032eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ee:	8b 50 08             	mov    0x8(%eax),%edx
  8032f1:	a1 28 50 80 00       	mov    0x805028,%eax
  8032f6:	39 c2                	cmp    %eax,%edx
  8032f8:	0f 83 93 01 00 00    	jae    803491 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8032fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803301:	8b 40 0c             	mov    0xc(%eax),%eax
  803304:	3b 45 08             	cmp    0x8(%ebp),%eax
  803307:	0f 82 84 01 00 00    	jb     803491 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80330d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803310:	8b 40 0c             	mov    0xc(%eax),%eax
  803313:	3b 45 08             	cmp    0x8(%ebp),%eax
  803316:	0f 85 95 00 00 00    	jne    8033b1 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80331c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803320:	75 17                	jne    803339 <alloc_block_NF+0x438>
  803322:	83 ec 04             	sub    $0x4,%esp
  803325:	68 44 48 80 00       	push   $0x804844
  80332a:	68 14 01 00 00       	push   $0x114
  80332f:	68 9b 47 80 00       	push   $0x80479b
  803334:	e8 7c d7 ff ff       	call   800ab5 <_panic>
  803339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333c:	8b 00                	mov    (%eax),%eax
  80333e:	85 c0                	test   %eax,%eax
  803340:	74 10                	je     803352 <alloc_block_NF+0x451>
  803342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803345:	8b 00                	mov    (%eax),%eax
  803347:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80334a:	8b 52 04             	mov    0x4(%edx),%edx
  80334d:	89 50 04             	mov    %edx,0x4(%eax)
  803350:	eb 0b                	jmp    80335d <alloc_block_NF+0x45c>
  803352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803355:	8b 40 04             	mov    0x4(%eax),%eax
  803358:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80335d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803360:	8b 40 04             	mov    0x4(%eax),%eax
  803363:	85 c0                	test   %eax,%eax
  803365:	74 0f                	je     803376 <alloc_block_NF+0x475>
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	8b 40 04             	mov    0x4(%eax),%eax
  80336d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803370:	8b 12                	mov    (%edx),%edx
  803372:	89 10                	mov    %edx,(%eax)
  803374:	eb 0a                	jmp    803380 <alloc_block_NF+0x47f>
  803376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803379:	8b 00                	mov    (%eax),%eax
  80337b:	a3 38 51 80 00       	mov    %eax,0x805138
  803380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803383:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803393:	a1 44 51 80 00       	mov    0x805144,%eax
  803398:	48                   	dec    %eax
  803399:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80339e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a1:	8b 40 08             	mov    0x8(%eax),%eax
  8033a4:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8033a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ac:	e9 1b 01 00 00       	jmp    8034cc <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8033b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033ba:	0f 86 d1 00 00 00    	jbe    803491 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8033c0:	a1 48 51 80 00       	mov    0x805148,%eax
  8033c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8033c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cb:	8b 50 08             	mov    0x8(%eax),%edx
  8033ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d1:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8033d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033da:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8033dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033e1:	75 17                	jne    8033fa <alloc_block_NF+0x4f9>
  8033e3:	83 ec 04             	sub    $0x4,%esp
  8033e6:	68 44 48 80 00       	push   $0x804844
  8033eb:	68 1c 01 00 00       	push   $0x11c
  8033f0:	68 9b 47 80 00       	push   $0x80479b
  8033f5:	e8 bb d6 ff ff       	call   800ab5 <_panic>
  8033fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033fd:	8b 00                	mov    (%eax),%eax
  8033ff:	85 c0                	test   %eax,%eax
  803401:	74 10                	je     803413 <alloc_block_NF+0x512>
  803403:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803406:	8b 00                	mov    (%eax),%eax
  803408:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80340b:	8b 52 04             	mov    0x4(%edx),%edx
  80340e:	89 50 04             	mov    %edx,0x4(%eax)
  803411:	eb 0b                	jmp    80341e <alloc_block_NF+0x51d>
  803413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803416:	8b 40 04             	mov    0x4(%eax),%eax
  803419:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80341e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803421:	8b 40 04             	mov    0x4(%eax),%eax
  803424:	85 c0                	test   %eax,%eax
  803426:	74 0f                	je     803437 <alloc_block_NF+0x536>
  803428:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342b:	8b 40 04             	mov    0x4(%eax),%eax
  80342e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803431:	8b 12                	mov    (%edx),%edx
  803433:	89 10                	mov    %edx,(%eax)
  803435:	eb 0a                	jmp    803441 <alloc_block_NF+0x540>
  803437:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343a:	8b 00                	mov    (%eax),%eax
  80343c:	a3 48 51 80 00       	mov    %eax,0x805148
  803441:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803444:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80344a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80344d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803454:	a1 54 51 80 00       	mov    0x805154,%eax
  803459:	48                   	dec    %eax
  80345a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80345f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803462:	8b 40 08             	mov    0x8(%eax),%eax
  803465:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80346a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346d:	8b 50 08             	mov    0x8(%eax),%edx
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	01 c2                	add    %eax,%edx
  803475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803478:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80347b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347e:	8b 40 0c             	mov    0xc(%eax),%eax
  803481:	2b 45 08             	sub    0x8(%ebp),%eax
  803484:	89 c2                	mov    %eax,%edx
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80348c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80348f:	eb 3b                	jmp    8034cc <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803491:	a1 40 51 80 00       	mov    0x805140,%eax
  803496:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803499:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349d:	74 07                	je     8034a6 <alloc_block_NF+0x5a5>
  80349f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a2:	8b 00                	mov    (%eax),%eax
  8034a4:	eb 05                	jmp    8034ab <alloc_block_NF+0x5aa>
  8034a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ab:	a3 40 51 80 00       	mov    %eax,0x805140
  8034b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8034b5:	85 c0                	test   %eax,%eax
  8034b7:	0f 85 2e fe ff ff    	jne    8032eb <alloc_block_NF+0x3ea>
  8034bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c1:	0f 85 24 fe ff ff    	jne    8032eb <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8034c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034cc:	c9                   	leave  
  8034cd:	c3                   	ret    

008034ce <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8034ce:	55                   	push   %ebp
  8034cf:	89 e5                	mov    %esp,%ebp
  8034d1:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8034d4:	a1 38 51 80 00       	mov    0x805138,%eax
  8034d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8034dc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034e1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8034e4:	a1 38 51 80 00       	mov    0x805138,%eax
  8034e9:	85 c0                	test   %eax,%eax
  8034eb:	74 14                	je     803501 <insert_sorted_with_merge_freeList+0x33>
  8034ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f0:	8b 50 08             	mov    0x8(%eax),%edx
  8034f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f6:	8b 40 08             	mov    0x8(%eax),%eax
  8034f9:	39 c2                	cmp    %eax,%edx
  8034fb:	0f 87 9b 01 00 00    	ja     80369c <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803501:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803505:	75 17                	jne    80351e <insert_sorted_with_merge_freeList+0x50>
  803507:	83 ec 04             	sub    $0x4,%esp
  80350a:	68 78 47 80 00       	push   $0x804778
  80350f:	68 38 01 00 00       	push   $0x138
  803514:	68 9b 47 80 00       	push   $0x80479b
  803519:	e8 97 d5 ff ff       	call   800ab5 <_panic>
  80351e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803524:	8b 45 08             	mov    0x8(%ebp),%eax
  803527:	89 10                	mov    %edx,(%eax)
  803529:	8b 45 08             	mov    0x8(%ebp),%eax
  80352c:	8b 00                	mov    (%eax),%eax
  80352e:	85 c0                	test   %eax,%eax
  803530:	74 0d                	je     80353f <insert_sorted_with_merge_freeList+0x71>
  803532:	a1 38 51 80 00       	mov    0x805138,%eax
  803537:	8b 55 08             	mov    0x8(%ebp),%edx
  80353a:	89 50 04             	mov    %edx,0x4(%eax)
  80353d:	eb 08                	jmp    803547 <insert_sorted_with_merge_freeList+0x79>
  80353f:	8b 45 08             	mov    0x8(%ebp),%eax
  803542:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803547:	8b 45 08             	mov    0x8(%ebp),%eax
  80354a:	a3 38 51 80 00       	mov    %eax,0x805138
  80354f:	8b 45 08             	mov    0x8(%ebp),%eax
  803552:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803559:	a1 44 51 80 00       	mov    0x805144,%eax
  80355e:	40                   	inc    %eax
  80355f:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803564:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803568:	0f 84 a8 06 00 00    	je     803c16 <insert_sorted_with_merge_freeList+0x748>
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	8b 50 08             	mov    0x8(%eax),%edx
  803574:	8b 45 08             	mov    0x8(%ebp),%eax
  803577:	8b 40 0c             	mov    0xc(%eax),%eax
  80357a:	01 c2                	add    %eax,%edx
  80357c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357f:	8b 40 08             	mov    0x8(%eax),%eax
  803582:	39 c2                	cmp    %eax,%edx
  803584:	0f 85 8c 06 00 00    	jne    803c16 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80358a:	8b 45 08             	mov    0x8(%ebp),%eax
  80358d:	8b 50 0c             	mov    0xc(%eax),%edx
  803590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803593:	8b 40 0c             	mov    0xc(%eax),%eax
  803596:	01 c2                	add    %eax,%edx
  803598:	8b 45 08             	mov    0x8(%ebp),%eax
  80359b:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80359e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035a2:	75 17                	jne    8035bb <insert_sorted_with_merge_freeList+0xed>
  8035a4:	83 ec 04             	sub    $0x4,%esp
  8035a7:	68 44 48 80 00       	push   $0x804844
  8035ac:	68 3c 01 00 00       	push   $0x13c
  8035b1:	68 9b 47 80 00       	push   $0x80479b
  8035b6:	e8 fa d4 ff ff       	call   800ab5 <_panic>
  8035bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035be:	8b 00                	mov    (%eax),%eax
  8035c0:	85 c0                	test   %eax,%eax
  8035c2:	74 10                	je     8035d4 <insert_sorted_with_merge_freeList+0x106>
  8035c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c7:	8b 00                	mov    (%eax),%eax
  8035c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035cc:	8b 52 04             	mov    0x4(%edx),%edx
  8035cf:	89 50 04             	mov    %edx,0x4(%eax)
  8035d2:	eb 0b                	jmp    8035df <insert_sorted_with_merge_freeList+0x111>
  8035d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d7:	8b 40 04             	mov    0x4(%eax),%eax
  8035da:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e2:	8b 40 04             	mov    0x4(%eax),%eax
  8035e5:	85 c0                	test   %eax,%eax
  8035e7:	74 0f                	je     8035f8 <insert_sorted_with_merge_freeList+0x12a>
  8035e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ec:	8b 40 04             	mov    0x4(%eax),%eax
  8035ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035f2:	8b 12                	mov    (%edx),%edx
  8035f4:	89 10                	mov    %edx,(%eax)
  8035f6:	eb 0a                	jmp    803602 <insert_sorted_with_merge_freeList+0x134>
  8035f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035fb:	8b 00                	mov    (%eax),%eax
  8035fd:	a3 38 51 80 00       	mov    %eax,0x805138
  803602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803605:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80360b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80360e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803615:	a1 44 51 80 00       	mov    0x805144,%eax
  80361a:	48                   	dec    %eax
  80361b:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803623:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80362a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80362d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803634:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803638:	75 17                	jne    803651 <insert_sorted_with_merge_freeList+0x183>
  80363a:	83 ec 04             	sub    $0x4,%esp
  80363d:	68 78 47 80 00       	push   $0x804778
  803642:	68 3f 01 00 00       	push   $0x13f
  803647:	68 9b 47 80 00       	push   $0x80479b
  80364c:	e8 64 d4 ff ff       	call   800ab5 <_panic>
  803651:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80365a:	89 10                	mov    %edx,(%eax)
  80365c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80365f:	8b 00                	mov    (%eax),%eax
  803661:	85 c0                	test   %eax,%eax
  803663:	74 0d                	je     803672 <insert_sorted_with_merge_freeList+0x1a4>
  803665:	a1 48 51 80 00       	mov    0x805148,%eax
  80366a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80366d:	89 50 04             	mov    %edx,0x4(%eax)
  803670:	eb 08                	jmp    80367a <insert_sorted_with_merge_freeList+0x1ac>
  803672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803675:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80367a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80367d:	a3 48 51 80 00       	mov    %eax,0x805148
  803682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803685:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80368c:	a1 54 51 80 00       	mov    0x805154,%eax
  803691:	40                   	inc    %eax
  803692:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803697:	e9 7a 05 00 00       	jmp    803c16 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80369c:	8b 45 08             	mov    0x8(%ebp),%eax
  80369f:	8b 50 08             	mov    0x8(%eax),%edx
  8036a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a5:	8b 40 08             	mov    0x8(%eax),%eax
  8036a8:	39 c2                	cmp    %eax,%edx
  8036aa:	0f 82 14 01 00 00    	jb     8037c4 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8036b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b3:	8b 50 08             	mov    0x8(%eax),%edx
  8036b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8036bc:	01 c2                	add    %eax,%edx
  8036be:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c1:	8b 40 08             	mov    0x8(%eax),%eax
  8036c4:	39 c2                	cmp    %eax,%edx
  8036c6:	0f 85 90 00 00 00    	jne    80375c <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8036cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036cf:	8b 50 0c             	mov    0xc(%eax),%edx
  8036d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d8:	01 c2                	add    %eax,%edx
  8036da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036dd:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8036e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8036ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8036f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f8:	75 17                	jne    803711 <insert_sorted_with_merge_freeList+0x243>
  8036fa:	83 ec 04             	sub    $0x4,%esp
  8036fd:	68 78 47 80 00       	push   $0x804778
  803702:	68 49 01 00 00       	push   $0x149
  803707:	68 9b 47 80 00       	push   $0x80479b
  80370c:	e8 a4 d3 ff ff       	call   800ab5 <_panic>
  803711:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803717:	8b 45 08             	mov    0x8(%ebp),%eax
  80371a:	89 10                	mov    %edx,(%eax)
  80371c:	8b 45 08             	mov    0x8(%ebp),%eax
  80371f:	8b 00                	mov    (%eax),%eax
  803721:	85 c0                	test   %eax,%eax
  803723:	74 0d                	je     803732 <insert_sorted_with_merge_freeList+0x264>
  803725:	a1 48 51 80 00       	mov    0x805148,%eax
  80372a:	8b 55 08             	mov    0x8(%ebp),%edx
  80372d:	89 50 04             	mov    %edx,0x4(%eax)
  803730:	eb 08                	jmp    80373a <insert_sorted_with_merge_freeList+0x26c>
  803732:	8b 45 08             	mov    0x8(%ebp),%eax
  803735:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80373a:	8b 45 08             	mov    0x8(%ebp),%eax
  80373d:	a3 48 51 80 00       	mov    %eax,0x805148
  803742:	8b 45 08             	mov    0x8(%ebp),%eax
  803745:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80374c:	a1 54 51 80 00       	mov    0x805154,%eax
  803751:	40                   	inc    %eax
  803752:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803757:	e9 bb 04 00 00       	jmp    803c17 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80375c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803760:	75 17                	jne    803779 <insert_sorted_with_merge_freeList+0x2ab>
  803762:	83 ec 04             	sub    $0x4,%esp
  803765:	68 ec 47 80 00       	push   $0x8047ec
  80376a:	68 4c 01 00 00       	push   $0x14c
  80376f:	68 9b 47 80 00       	push   $0x80479b
  803774:	e8 3c d3 ff ff       	call   800ab5 <_panic>
  803779:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80377f:	8b 45 08             	mov    0x8(%ebp),%eax
  803782:	89 50 04             	mov    %edx,0x4(%eax)
  803785:	8b 45 08             	mov    0x8(%ebp),%eax
  803788:	8b 40 04             	mov    0x4(%eax),%eax
  80378b:	85 c0                	test   %eax,%eax
  80378d:	74 0c                	je     80379b <insert_sorted_with_merge_freeList+0x2cd>
  80378f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803794:	8b 55 08             	mov    0x8(%ebp),%edx
  803797:	89 10                	mov    %edx,(%eax)
  803799:	eb 08                	jmp    8037a3 <insert_sorted_with_merge_freeList+0x2d5>
  80379b:	8b 45 08             	mov    0x8(%ebp),%eax
  80379e:	a3 38 51 80 00       	mov    %eax,0x805138
  8037a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037b4:	a1 44 51 80 00       	mov    0x805144,%eax
  8037b9:	40                   	inc    %eax
  8037ba:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037bf:	e9 53 04 00 00       	jmp    803c17 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8037c4:	a1 38 51 80 00       	mov    0x805138,%eax
  8037c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037cc:	e9 15 04 00 00       	jmp    803be6 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8037d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d4:	8b 00                	mov    (%eax),%eax
  8037d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8037d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dc:	8b 50 08             	mov    0x8(%eax),%edx
  8037df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e2:	8b 40 08             	mov    0x8(%eax),%eax
  8037e5:	39 c2                	cmp    %eax,%edx
  8037e7:	0f 86 f1 03 00 00    	jbe    803bde <insert_sorted_with_merge_freeList+0x710>
  8037ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f0:	8b 50 08             	mov    0x8(%eax),%edx
  8037f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f6:	8b 40 08             	mov    0x8(%eax),%eax
  8037f9:	39 c2                	cmp    %eax,%edx
  8037fb:	0f 83 dd 03 00 00    	jae    803bde <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803804:	8b 50 08             	mov    0x8(%eax),%edx
  803807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380a:	8b 40 0c             	mov    0xc(%eax),%eax
  80380d:	01 c2                	add    %eax,%edx
  80380f:	8b 45 08             	mov    0x8(%ebp),%eax
  803812:	8b 40 08             	mov    0x8(%eax),%eax
  803815:	39 c2                	cmp    %eax,%edx
  803817:	0f 85 b9 01 00 00    	jne    8039d6 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80381d:	8b 45 08             	mov    0x8(%ebp),%eax
  803820:	8b 50 08             	mov    0x8(%eax),%edx
  803823:	8b 45 08             	mov    0x8(%ebp),%eax
  803826:	8b 40 0c             	mov    0xc(%eax),%eax
  803829:	01 c2                	add    %eax,%edx
  80382b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382e:	8b 40 08             	mov    0x8(%eax),%eax
  803831:	39 c2                	cmp    %eax,%edx
  803833:	0f 85 0d 01 00 00    	jne    803946 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383c:	8b 50 0c             	mov    0xc(%eax),%edx
  80383f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803842:	8b 40 0c             	mov    0xc(%eax),%eax
  803845:	01 c2                	add    %eax,%edx
  803847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384a:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80384d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803851:	75 17                	jne    80386a <insert_sorted_with_merge_freeList+0x39c>
  803853:	83 ec 04             	sub    $0x4,%esp
  803856:	68 44 48 80 00       	push   $0x804844
  80385b:	68 5c 01 00 00       	push   $0x15c
  803860:	68 9b 47 80 00       	push   $0x80479b
  803865:	e8 4b d2 ff ff       	call   800ab5 <_panic>
  80386a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386d:	8b 00                	mov    (%eax),%eax
  80386f:	85 c0                	test   %eax,%eax
  803871:	74 10                	je     803883 <insert_sorted_with_merge_freeList+0x3b5>
  803873:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803876:	8b 00                	mov    (%eax),%eax
  803878:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80387b:	8b 52 04             	mov    0x4(%edx),%edx
  80387e:	89 50 04             	mov    %edx,0x4(%eax)
  803881:	eb 0b                	jmp    80388e <insert_sorted_with_merge_freeList+0x3c0>
  803883:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803886:	8b 40 04             	mov    0x4(%eax),%eax
  803889:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80388e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803891:	8b 40 04             	mov    0x4(%eax),%eax
  803894:	85 c0                	test   %eax,%eax
  803896:	74 0f                	je     8038a7 <insert_sorted_with_merge_freeList+0x3d9>
  803898:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80389b:	8b 40 04             	mov    0x4(%eax),%eax
  80389e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038a1:	8b 12                	mov    (%edx),%edx
  8038a3:	89 10                	mov    %edx,(%eax)
  8038a5:	eb 0a                	jmp    8038b1 <insert_sorted_with_merge_freeList+0x3e3>
  8038a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038aa:	8b 00                	mov    (%eax),%eax
  8038ac:	a3 38 51 80 00       	mov    %eax,0x805138
  8038b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038c4:	a1 44 51 80 00       	mov    0x805144,%eax
  8038c9:	48                   	dec    %eax
  8038ca:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8038cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8038d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8038e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038e7:	75 17                	jne    803900 <insert_sorted_with_merge_freeList+0x432>
  8038e9:	83 ec 04             	sub    $0x4,%esp
  8038ec:	68 78 47 80 00       	push   $0x804778
  8038f1:	68 5f 01 00 00       	push   $0x15f
  8038f6:	68 9b 47 80 00       	push   $0x80479b
  8038fb:	e8 b5 d1 ff ff       	call   800ab5 <_panic>
  803900:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803906:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803909:	89 10                	mov    %edx,(%eax)
  80390b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390e:	8b 00                	mov    (%eax),%eax
  803910:	85 c0                	test   %eax,%eax
  803912:	74 0d                	je     803921 <insert_sorted_with_merge_freeList+0x453>
  803914:	a1 48 51 80 00       	mov    0x805148,%eax
  803919:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80391c:	89 50 04             	mov    %edx,0x4(%eax)
  80391f:	eb 08                	jmp    803929 <insert_sorted_with_merge_freeList+0x45b>
  803921:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803924:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803929:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392c:	a3 48 51 80 00       	mov    %eax,0x805148
  803931:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803934:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80393b:	a1 54 51 80 00       	mov    0x805154,%eax
  803940:	40                   	inc    %eax
  803941:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803949:	8b 50 0c             	mov    0xc(%eax),%edx
  80394c:	8b 45 08             	mov    0x8(%ebp),%eax
  80394f:	8b 40 0c             	mov    0xc(%eax),%eax
  803952:	01 c2                	add    %eax,%edx
  803954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803957:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80395a:	8b 45 08             	mov    0x8(%ebp),%eax
  80395d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803964:	8b 45 08             	mov    0x8(%ebp),%eax
  803967:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80396e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803972:	75 17                	jne    80398b <insert_sorted_with_merge_freeList+0x4bd>
  803974:	83 ec 04             	sub    $0x4,%esp
  803977:	68 78 47 80 00       	push   $0x804778
  80397c:	68 64 01 00 00       	push   $0x164
  803981:	68 9b 47 80 00       	push   $0x80479b
  803986:	e8 2a d1 ff ff       	call   800ab5 <_panic>
  80398b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803991:	8b 45 08             	mov    0x8(%ebp),%eax
  803994:	89 10                	mov    %edx,(%eax)
  803996:	8b 45 08             	mov    0x8(%ebp),%eax
  803999:	8b 00                	mov    (%eax),%eax
  80399b:	85 c0                	test   %eax,%eax
  80399d:	74 0d                	je     8039ac <insert_sorted_with_merge_freeList+0x4de>
  80399f:	a1 48 51 80 00       	mov    0x805148,%eax
  8039a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8039a7:	89 50 04             	mov    %edx,0x4(%eax)
  8039aa:	eb 08                	jmp    8039b4 <insert_sorted_with_merge_freeList+0x4e6>
  8039ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8039af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b7:	a3 48 51 80 00       	mov    %eax,0x805148
  8039bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039c6:	a1 54 51 80 00       	mov    0x805154,%eax
  8039cb:	40                   	inc    %eax
  8039cc:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8039d1:	e9 41 02 00 00       	jmp    803c17 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8039d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d9:	8b 50 08             	mov    0x8(%eax),%edx
  8039dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039df:	8b 40 0c             	mov    0xc(%eax),%eax
  8039e2:	01 c2                	add    %eax,%edx
  8039e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e7:	8b 40 08             	mov    0x8(%eax),%eax
  8039ea:	39 c2                	cmp    %eax,%edx
  8039ec:	0f 85 7c 01 00 00    	jne    803b6e <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8039f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039f6:	74 06                	je     8039fe <insert_sorted_with_merge_freeList+0x530>
  8039f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039fc:	75 17                	jne    803a15 <insert_sorted_with_merge_freeList+0x547>
  8039fe:	83 ec 04             	sub    $0x4,%esp
  803a01:	68 b4 47 80 00       	push   $0x8047b4
  803a06:	68 69 01 00 00       	push   $0x169
  803a0b:	68 9b 47 80 00       	push   $0x80479b
  803a10:	e8 a0 d0 ff ff       	call   800ab5 <_panic>
  803a15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a18:	8b 50 04             	mov    0x4(%eax),%edx
  803a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1e:	89 50 04             	mov    %edx,0x4(%eax)
  803a21:	8b 45 08             	mov    0x8(%ebp),%eax
  803a24:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a27:	89 10                	mov    %edx,(%eax)
  803a29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a2c:	8b 40 04             	mov    0x4(%eax),%eax
  803a2f:	85 c0                	test   %eax,%eax
  803a31:	74 0d                	je     803a40 <insert_sorted_with_merge_freeList+0x572>
  803a33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a36:	8b 40 04             	mov    0x4(%eax),%eax
  803a39:	8b 55 08             	mov    0x8(%ebp),%edx
  803a3c:	89 10                	mov    %edx,(%eax)
  803a3e:	eb 08                	jmp    803a48 <insert_sorted_with_merge_freeList+0x57a>
  803a40:	8b 45 08             	mov    0x8(%ebp),%eax
  803a43:	a3 38 51 80 00       	mov    %eax,0x805138
  803a48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a4b:	8b 55 08             	mov    0x8(%ebp),%edx
  803a4e:	89 50 04             	mov    %edx,0x4(%eax)
  803a51:	a1 44 51 80 00       	mov    0x805144,%eax
  803a56:	40                   	inc    %eax
  803a57:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5f:	8b 50 0c             	mov    0xc(%eax),%edx
  803a62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a65:	8b 40 0c             	mov    0xc(%eax),%eax
  803a68:	01 c2                	add    %eax,%edx
  803a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803a70:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a74:	75 17                	jne    803a8d <insert_sorted_with_merge_freeList+0x5bf>
  803a76:	83 ec 04             	sub    $0x4,%esp
  803a79:	68 44 48 80 00       	push   $0x804844
  803a7e:	68 6b 01 00 00       	push   $0x16b
  803a83:	68 9b 47 80 00       	push   $0x80479b
  803a88:	e8 28 d0 ff ff       	call   800ab5 <_panic>
  803a8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a90:	8b 00                	mov    (%eax),%eax
  803a92:	85 c0                	test   %eax,%eax
  803a94:	74 10                	je     803aa6 <insert_sorted_with_merge_freeList+0x5d8>
  803a96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a99:	8b 00                	mov    (%eax),%eax
  803a9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a9e:	8b 52 04             	mov    0x4(%edx),%edx
  803aa1:	89 50 04             	mov    %edx,0x4(%eax)
  803aa4:	eb 0b                	jmp    803ab1 <insert_sorted_with_merge_freeList+0x5e3>
  803aa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa9:	8b 40 04             	mov    0x4(%eax),%eax
  803aac:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ab1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab4:	8b 40 04             	mov    0x4(%eax),%eax
  803ab7:	85 c0                	test   %eax,%eax
  803ab9:	74 0f                	je     803aca <insert_sorted_with_merge_freeList+0x5fc>
  803abb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803abe:	8b 40 04             	mov    0x4(%eax),%eax
  803ac1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ac4:	8b 12                	mov    (%edx),%edx
  803ac6:	89 10                	mov    %edx,(%eax)
  803ac8:	eb 0a                	jmp    803ad4 <insert_sorted_with_merge_freeList+0x606>
  803aca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803acd:	8b 00                	mov    (%eax),%eax
  803acf:	a3 38 51 80 00       	mov    %eax,0x805138
  803ad4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ad7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803add:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ae7:	a1 44 51 80 00       	mov    0x805144,%eax
  803aec:	48                   	dec    %eax
  803aed:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803af2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803af5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803afc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803b06:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b0a:	75 17                	jne    803b23 <insert_sorted_with_merge_freeList+0x655>
  803b0c:	83 ec 04             	sub    $0x4,%esp
  803b0f:	68 78 47 80 00       	push   $0x804778
  803b14:	68 6e 01 00 00       	push   $0x16e
  803b19:	68 9b 47 80 00       	push   $0x80479b
  803b1e:	e8 92 cf ff ff       	call   800ab5 <_panic>
  803b23:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b2c:	89 10                	mov    %edx,(%eax)
  803b2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b31:	8b 00                	mov    (%eax),%eax
  803b33:	85 c0                	test   %eax,%eax
  803b35:	74 0d                	je     803b44 <insert_sorted_with_merge_freeList+0x676>
  803b37:	a1 48 51 80 00       	mov    0x805148,%eax
  803b3c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b3f:	89 50 04             	mov    %edx,0x4(%eax)
  803b42:	eb 08                	jmp    803b4c <insert_sorted_with_merge_freeList+0x67e>
  803b44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b47:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b4f:	a3 48 51 80 00       	mov    %eax,0x805148
  803b54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b5e:	a1 54 51 80 00       	mov    0x805154,%eax
  803b63:	40                   	inc    %eax
  803b64:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803b69:	e9 a9 00 00 00       	jmp    803c17 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803b6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b72:	74 06                	je     803b7a <insert_sorted_with_merge_freeList+0x6ac>
  803b74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b78:	75 17                	jne    803b91 <insert_sorted_with_merge_freeList+0x6c3>
  803b7a:	83 ec 04             	sub    $0x4,%esp
  803b7d:	68 10 48 80 00       	push   $0x804810
  803b82:	68 73 01 00 00       	push   $0x173
  803b87:	68 9b 47 80 00       	push   $0x80479b
  803b8c:	e8 24 cf ff ff       	call   800ab5 <_panic>
  803b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b94:	8b 10                	mov    (%eax),%edx
  803b96:	8b 45 08             	mov    0x8(%ebp),%eax
  803b99:	89 10                	mov    %edx,(%eax)
  803b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9e:	8b 00                	mov    (%eax),%eax
  803ba0:	85 c0                	test   %eax,%eax
  803ba2:	74 0b                	je     803baf <insert_sorted_with_merge_freeList+0x6e1>
  803ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba7:	8b 00                	mov    (%eax),%eax
  803ba9:	8b 55 08             	mov    0x8(%ebp),%edx
  803bac:	89 50 04             	mov    %edx,0x4(%eax)
  803baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb2:	8b 55 08             	mov    0x8(%ebp),%edx
  803bb5:	89 10                	mov    %edx,(%eax)
  803bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  803bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bbd:	89 50 04             	mov    %edx,0x4(%eax)
  803bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc3:	8b 00                	mov    (%eax),%eax
  803bc5:	85 c0                	test   %eax,%eax
  803bc7:	75 08                	jne    803bd1 <insert_sorted_with_merge_freeList+0x703>
  803bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  803bcc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bd1:	a1 44 51 80 00       	mov    0x805144,%eax
  803bd6:	40                   	inc    %eax
  803bd7:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803bdc:	eb 39                	jmp    803c17 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803bde:	a1 40 51 80 00       	mov    0x805140,%eax
  803be3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803be6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bea:	74 07                	je     803bf3 <insert_sorted_with_merge_freeList+0x725>
  803bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bef:	8b 00                	mov    (%eax),%eax
  803bf1:	eb 05                	jmp    803bf8 <insert_sorted_with_merge_freeList+0x72a>
  803bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  803bf8:	a3 40 51 80 00       	mov    %eax,0x805140
  803bfd:	a1 40 51 80 00       	mov    0x805140,%eax
  803c02:	85 c0                	test   %eax,%eax
  803c04:	0f 85 c7 fb ff ff    	jne    8037d1 <insert_sorted_with_merge_freeList+0x303>
  803c0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c0e:	0f 85 bd fb ff ff    	jne    8037d1 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803c14:	eb 01                	jmp    803c17 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803c16:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803c17:	90                   	nop
  803c18:	c9                   	leave  
  803c19:	c3                   	ret    
  803c1a:	66 90                	xchg   %ax,%ax

00803c1c <__udivdi3>:
  803c1c:	55                   	push   %ebp
  803c1d:	57                   	push   %edi
  803c1e:	56                   	push   %esi
  803c1f:	53                   	push   %ebx
  803c20:	83 ec 1c             	sub    $0x1c,%esp
  803c23:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c27:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c33:	89 ca                	mov    %ecx,%edx
  803c35:	89 f8                	mov    %edi,%eax
  803c37:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c3b:	85 f6                	test   %esi,%esi
  803c3d:	75 2d                	jne    803c6c <__udivdi3+0x50>
  803c3f:	39 cf                	cmp    %ecx,%edi
  803c41:	77 65                	ja     803ca8 <__udivdi3+0x8c>
  803c43:	89 fd                	mov    %edi,%ebp
  803c45:	85 ff                	test   %edi,%edi
  803c47:	75 0b                	jne    803c54 <__udivdi3+0x38>
  803c49:	b8 01 00 00 00       	mov    $0x1,%eax
  803c4e:	31 d2                	xor    %edx,%edx
  803c50:	f7 f7                	div    %edi
  803c52:	89 c5                	mov    %eax,%ebp
  803c54:	31 d2                	xor    %edx,%edx
  803c56:	89 c8                	mov    %ecx,%eax
  803c58:	f7 f5                	div    %ebp
  803c5a:	89 c1                	mov    %eax,%ecx
  803c5c:	89 d8                	mov    %ebx,%eax
  803c5e:	f7 f5                	div    %ebp
  803c60:	89 cf                	mov    %ecx,%edi
  803c62:	89 fa                	mov    %edi,%edx
  803c64:	83 c4 1c             	add    $0x1c,%esp
  803c67:	5b                   	pop    %ebx
  803c68:	5e                   	pop    %esi
  803c69:	5f                   	pop    %edi
  803c6a:	5d                   	pop    %ebp
  803c6b:	c3                   	ret    
  803c6c:	39 ce                	cmp    %ecx,%esi
  803c6e:	77 28                	ja     803c98 <__udivdi3+0x7c>
  803c70:	0f bd fe             	bsr    %esi,%edi
  803c73:	83 f7 1f             	xor    $0x1f,%edi
  803c76:	75 40                	jne    803cb8 <__udivdi3+0x9c>
  803c78:	39 ce                	cmp    %ecx,%esi
  803c7a:	72 0a                	jb     803c86 <__udivdi3+0x6a>
  803c7c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c80:	0f 87 9e 00 00 00    	ja     803d24 <__udivdi3+0x108>
  803c86:	b8 01 00 00 00       	mov    $0x1,%eax
  803c8b:	89 fa                	mov    %edi,%edx
  803c8d:	83 c4 1c             	add    $0x1c,%esp
  803c90:	5b                   	pop    %ebx
  803c91:	5e                   	pop    %esi
  803c92:	5f                   	pop    %edi
  803c93:	5d                   	pop    %ebp
  803c94:	c3                   	ret    
  803c95:	8d 76 00             	lea    0x0(%esi),%esi
  803c98:	31 ff                	xor    %edi,%edi
  803c9a:	31 c0                	xor    %eax,%eax
  803c9c:	89 fa                	mov    %edi,%edx
  803c9e:	83 c4 1c             	add    $0x1c,%esp
  803ca1:	5b                   	pop    %ebx
  803ca2:	5e                   	pop    %esi
  803ca3:	5f                   	pop    %edi
  803ca4:	5d                   	pop    %ebp
  803ca5:	c3                   	ret    
  803ca6:	66 90                	xchg   %ax,%ax
  803ca8:	89 d8                	mov    %ebx,%eax
  803caa:	f7 f7                	div    %edi
  803cac:	31 ff                	xor    %edi,%edi
  803cae:	89 fa                	mov    %edi,%edx
  803cb0:	83 c4 1c             	add    $0x1c,%esp
  803cb3:	5b                   	pop    %ebx
  803cb4:	5e                   	pop    %esi
  803cb5:	5f                   	pop    %edi
  803cb6:	5d                   	pop    %ebp
  803cb7:	c3                   	ret    
  803cb8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803cbd:	89 eb                	mov    %ebp,%ebx
  803cbf:	29 fb                	sub    %edi,%ebx
  803cc1:	89 f9                	mov    %edi,%ecx
  803cc3:	d3 e6                	shl    %cl,%esi
  803cc5:	89 c5                	mov    %eax,%ebp
  803cc7:	88 d9                	mov    %bl,%cl
  803cc9:	d3 ed                	shr    %cl,%ebp
  803ccb:	89 e9                	mov    %ebp,%ecx
  803ccd:	09 f1                	or     %esi,%ecx
  803ccf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803cd3:	89 f9                	mov    %edi,%ecx
  803cd5:	d3 e0                	shl    %cl,%eax
  803cd7:	89 c5                	mov    %eax,%ebp
  803cd9:	89 d6                	mov    %edx,%esi
  803cdb:	88 d9                	mov    %bl,%cl
  803cdd:	d3 ee                	shr    %cl,%esi
  803cdf:	89 f9                	mov    %edi,%ecx
  803ce1:	d3 e2                	shl    %cl,%edx
  803ce3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ce7:	88 d9                	mov    %bl,%cl
  803ce9:	d3 e8                	shr    %cl,%eax
  803ceb:	09 c2                	or     %eax,%edx
  803ced:	89 d0                	mov    %edx,%eax
  803cef:	89 f2                	mov    %esi,%edx
  803cf1:	f7 74 24 0c          	divl   0xc(%esp)
  803cf5:	89 d6                	mov    %edx,%esi
  803cf7:	89 c3                	mov    %eax,%ebx
  803cf9:	f7 e5                	mul    %ebp
  803cfb:	39 d6                	cmp    %edx,%esi
  803cfd:	72 19                	jb     803d18 <__udivdi3+0xfc>
  803cff:	74 0b                	je     803d0c <__udivdi3+0xf0>
  803d01:	89 d8                	mov    %ebx,%eax
  803d03:	31 ff                	xor    %edi,%edi
  803d05:	e9 58 ff ff ff       	jmp    803c62 <__udivdi3+0x46>
  803d0a:	66 90                	xchg   %ax,%ax
  803d0c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d10:	89 f9                	mov    %edi,%ecx
  803d12:	d3 e2                	shl    %cl,%edx
  803d14:	39 c2                	cmp    %eax,%edx
  803d16:	73 e9                	jae    803d01 <__udivdi3+0xe5>
  803d18:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d1b:	31 ff                	xor    %edi,%edi
  803d1d:	e9 40 ff ff ff       	jmp    803c62 <__udivdi3+0x46>
  803d22:	66 90                	xchg   %ax,%ax
  803d24:	31 c0                	xor    %eax,%eax
  803d26:	e9 37 ff ff ff       	jmp    803c62 <__udivdi3+0x46>
  803d2b:	90                   	nop

00803d2c <__umoddi3>:
  803d2c:	55                   	push   %ebp
  803d2d:	57                   	push   %edi
  803d2e:	56                   	push   %esi
  803d2f:	53                   	push   %ebx
  803d30:	83 ec 1c             	sub    $0x1c,%esp
  803d33:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d37:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d3f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d4b:	89 f3                	mov    %esi,%ebx
  803d4d:	89 fa                	mov    %edi,%edx
  803d4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d53:	89 34 24             	mov    %esi,(%esp)
  803d56:	85 c0                	test   %eax,%eax
  803d58:	75 1a                	jne    803d74 <__umoddi3+0x48>
  803d5a:	39 f7                	cmp    %esi,%edi
  803d5c:	0f 86 a2 00 00 00    	jbe    803e04 <__umoddi3+0xd8>
  803d62:	89 c8                	mov    %ecx,%eax
  803d64:	89 f2                	mov    %esi,%edx
  803d66:	f7 f7                	div    %edi
  803d68:	89 d0                	mov    %edx,%eax
  803d6a:	31 d2                	xor    %edx,%edx
  803d6c:	83 c4 1c             	add    $0x1c,%esp
  803d6f:	5b                   	pop    %ebx
  803d70:	5e                   	pop    %esi
  803d71:	5f                   	pop    %edi
  803d72:	5d                   	pop    %ebp
  803d73:	c3                   	ret    
  803d74:	39 f0                	cmp    %esi,%eax
  803d76:	0f 87 ac 00 00 00    	ja     803e28 <__umoddi3+0xfc>
  803d7c:	0f bd e8             	bsr    %eax,%ebp
  803d7f:	83 f5 1f             	xor    $0x1f,%ebp
  803d82:	0f 84 ac 00 00 00    	je     803e34 <__umoddi3+0x108>
  803d88:	bf 20 00 00 00       	mov    $0x20,%edi
  803d8d:	29 ef                	sub    %ebp,%edi
  803d8f:	89 fe                	mov    %edi,%esi
  803d91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d95:	89 e9                	mov    %ebp,%ecx
  803d97:	d3 e0                	shl    %cl,%eax
  803d99:	89 d7                	mov    %edx,%edi
  803d9b:	89 f1                	mov    %esi,%ecx
  803d9d:	d3 ef                	shr    %cl,%edi
  803d9f:	09 c7                	or     %eax,%edi
  803da1:	89 e9                	mov    %ebp,%ecx
  803da3:	d3 e2                	shl    %cl,%edx
  803da5:	89 14 24             	mov    %edx,(%esp)
  803da8:	89 d8                	mov    %ebx,%eax
  803daa:	d3 e0                	shl    %cl,%eax
  803dac:	89 c2                	mov    %eax,%edx
  803dae:	8b 44 24 08          	mov    0x8(%esp),%eax
  803db2:	d3 e0                	shl    %cl,%eax
  803db4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803db8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dbc:	89 f1                	mov    %esi,%ecx
  803dbe:	d3 e8                	shr    %cl,%eax
  803dc0:	09 d0                	or     %edx,%eax
  803dc2:	d3 eb                	shr    %cl,%ebx
  803dc4:	89 da                	mov    %ebx,%edx
  803dc6:	f7 f7                	div    %edi
  803dc8:	89 d3                	mov    %edx,%ebx
  803dca:	f7 24 24             	mull   (%esp)
  803dcd:	89 c6                	mov    %eax,%esi
  803dcf:	89 d1                	mov    %edx,%ecx
  803dd1:	39 d3                	cmp    %edx,%ebx
  803dd3:	0f 82 87 00 00 00    	jb     803e60 <__umoddi3+0x134>
  803dd9:	0f 84 91 00 00 00    	je     803e70 <__umoddi3+0x144>
  803ddf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803de3:	29 f2                	sub    %esi,%edx
  803de5:	19 cb                	sbb    %ecx,%ebx
  803de7:	89 d8                	mov    %ebx,%eax
  803de9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ded:	d3 e0                	shl    %cl,%eax
  803def:	89 e9                	mov    %ebp,%ecx
  803df1:	d3 ea                	shr    %cl,%edx
  803df3:	09 d0                	or     %edx,%eax
  803df5:	89 e9                	mov    %ebp,%ecx
  803df7:	d3 eb                	shr    %cl,%ebx
  803df9:	89 da                	mov    %ebx,%edx
  803dfb:	83 c4 1c             	add    $0x1c,%esp
  803dfe:	5b                   	pop    %ebx
  803dff:	5e                   	pop    %esi
  803e00:	5f                   	pop    %edi
  803e01:	5d                   	pop    %ebp
  803e02:	c3                   	ret    
  803e03:	90                   	nop
  803e04:	89 fd                	mov    %edi,%ebp
  803e06:	85 ff                	test   %edi,%edi
  803e08:	75 0b                	jne    803e15 <__umoddi3+0xe9>
  803e0a:	b8 01 00 00 00       	mov    $0x1,%eax
  803e0f:	31 d2                	xor    %edx,%edx
  803e11:	f7 f7                	div    %edi
  803e13:	89 c5                	mov    %eax,%ebp
  803e15:	89 f0                	mov    %esi,%eax
  803e17:	31 d2                	xor    %edx,%edx
  803e19:	f7 f5                	div    %ebp
  803e1b:	89 c8                	mov    %ecx,%eax
  803e1d:	f7 f5                	div    %ebp
  803e1f:	89 d0                	mov    %edx,%eax
  803e21:	e9 44 ff ff ff       	jmp    803d6a <__umoddi3+0x3e>
  803e26:	66 90                	xchg   %ax,%ax
  803e28:	89 c8                	mov    %ecx,%eax
  803e2a:	89 f2                	mov    %esi,%edx
  803e2c:	83 c4 1c             	add    $0x1c,%esp
  803e2f:	5b                   	pop    %ebx
  803e30:	5e                   	pop    %esi
  803e31:	5f                   	pop    %edi
  803e32:	5d                   	pop    %ebp
  803e33:	c3                   	ret    
  803e34:	3b 04 24             	cmp    (%esp),%eax
  803e37:	72 06                	jb     803e3f <__umoddi3+0x113>
  803e39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e3d:	77 0f                	ja     803e4e <__umoddi3+0x122>
  803e3f:	89 f2                	mov    %esi,%edx
  803e41:	29 f9                	sub    %edi,%ecx
  803e43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e47:	89 14 24             	mov    %edx,(%esp)
  803e4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e52:	8b 14 24             	mov    (%esp),%edx
  803e55:	83 c4 1c             	add    $0x1c,%esp
  803e58:	5b                   	pop    %ebx
  803e59:	5e                   	pop    %esi
  803e5a:	5f                   	pop    %edi
  803e5b:	5d                   	pop    %ebp
  803e5c:	c3                   	ret    
  803e5d:	8d 76 00             	lea    0x0(%esi),%esi
  803e60:	2b 04 24             	sub    (%esp),%eax
  803e63:	19 fa                	sbb    %edi,%edx
  803e65:	89 d1                	mov    %edx,%ecx
  803e67:	89 c6                	mov    %eax,%esi
  803e69:	e9 71 ff ff ff       	jmp    803ddf <__umoddi3+0xb3>
  803e6e:	66 90                	xchg   %ax,%ax
  803e70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e74:	72 ea                	jb     803e60 <__umoddi3+0x134>
  803e76:	89 d9                	mov    %ebx,%ecx
  803e78:	e9 62 ff ff ff       	jmp    803ddf <__umoddi3+0xb3>
