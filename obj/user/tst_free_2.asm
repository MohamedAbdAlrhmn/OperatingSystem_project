
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
  800090:	68 a0 3d 80 00       	push   $0x803da0
  800095:	6a 14                	push   $0x14
  800097:	68 bc 3d 80 00       	push   $0x803dbc
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
  8000b3:	e8 59 22 00 00       	call   802311 <sys_bypassPageFault>
  8000b8:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000bb:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  8000c9:	e8 ab 1e 00 00       	call   801f79 <sys_calculate_free_frames>
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
  8000f6:	e8 7e 1e 00 00       	call   801f79 <sys_calculate_free_frames>
  8000fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 16 1f 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
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
  800127:	68 d0 3d 80 00       	push   $0x803dd0
  80012c:	6a 2d                	push   $0x2d
  80012e:	68 bc 3d 80 00       	push   $0x803dbc
  800133:	e8 7d 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 dc 1e 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 38 3e 80 00       	push   $0x803e38
  80014a:	6a 2e                	push   $0x2e
  80014c:	68 bc 3d 80 00       	push   $0x803dbc
  800151:	e8 5f 09 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  800156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80015e:	48                   	dec    %eax
  80015f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800165:	e8 0f 1e 00 00       	call   801f79 <sys_calculate_free_frames>
  80016a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80016d:	e8 a7 1e 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
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
  8001a2:	68 d0 3d 80 00       	push   $0x803dd0
  8001a7:	6a 35                	push   $0x35
  8001a9:	68 bc 3d 80 00       	push   $0x803dbc
  8001ae:	e8 02 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001b3:	e8 61 1e 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  8001b8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001bb:	74 14                	je     8001d1 <_main+0x199>
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	68 38 3e 80 00       	push   $0x803e38
  8001c5:	6a 36                	push   $0x36
  8001c7:	68 bc 3d 80 00       	push   $0x803dbc
  8001cc:	e8 e4 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001d9:	48                   	dec    %eax
  8001da:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001e0:	e8 94 1d 00 00       	call   801f79 <sys_calculate_free_frames>
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001e8:	e8 2c 1e 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
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
  80021b:	68 d0 3d 80 00       	push   $0x803dd0
  800220:	6a 3d                	push   $0x3d
  800222:	68 bc 3d 80 00       	push   $0x803dbc
  800227:	e8 89 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80022c:	e8 e8 1d 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  800231:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 38 3e 80 00       	push   $0x803e38
  80023e:	6a 3e                	push   $0x3e
  800240:	68 bc 3d 80 00       	push   $0x803dbc
  800245:	e8 6b 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  80024a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024d:	01 c0                	add    %eax,%eax
  80024f:	48                   	dec    %eax
  800250:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800256:	e8 1e 1d 00 00       	call   801f79 <sys_calculate_free_frames>
  80025b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025e:	e8 b6 1d 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
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
  80029b:	68 d0 3d 80 00       	push   $0x803dd0
  8002a0:	6a 45                	push   $0x45
  8002a2:	68 bc 3d 80 00       	push   $0x803dbc
  8002a7:	e8 09 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002ac:	e8 68 1d 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  8002b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002b4:	74 14                	je     8002ca <_main+0x292>
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	68 38 3e 80 00       	push   $0x803e38
  8002be:	6a 46                	push   $0x46
  8002c0:	68 bc 3d 80 00       	push   $0x803dbc
  8002c5:	e8 eb 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  8002ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002cd:	01 c0                	add    %eax,%eax
  8002cf:	48                   	dec    %eax
  8002d0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002d6:	e8 9e 1c 00 00       	call   801f79 <sys_calculate_free_frames>
  8002db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002de:	e8 36 1d 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
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
  800323:	68 d0 3d 80 00       	push   $0x803dd0
  800328:	6a 4d                	push   $0x4d
  80032a:	68 bc 3d 80 00       	push   $0x803dbc
  80032f:	e8 81 07 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800334:	e8 e0 1c 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  800339:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 38 3e 80 00       	push   $0x803e38
  800346:	6a 4e                	push   $0x4e
  800348:	68 bc 3d 80 00       	push   $0x803dbc
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
  800366:	e8 0e 1c 00 00       	call   801f79 <sys_calculate_free_frames>
  80036b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80036e:	e8 a6 1c 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
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
  8003b2:	68 d0 3d 80 00       	push   $0x803dd0
  8003b7:	6a 55                	push   $0x55
  8003b9:	68 bc 3d 80 00       	push   $0x803dbc
  8003be:	e8 f2 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003c3:	e8 51 1c 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  8003c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003cb:	74 14                	je     8003e1 <_main+0x3a9>
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 38 3e 80 00       	push   $0x803e38
  8003d5:	6a 56                	push   $0x56
  8003d7:	68 bc 3d 80 00       	push   $0x803dbc
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
  8003f4:	e8 80 1b 00 00       	call   801f79 <sys_calculate_free_frames>
  8003f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003fc:	e8 18 1c 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
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
  800443:	68 d0 3d 80 00       	push   $0x803dd0
  800448:	6a 5d                	push   $0x5d
  80044a:	68 bc 3d 80 00       	push   $0x803dbc
  80044f:	e8 61 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800454:	e8 c0 1b 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  800459:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80045c:	74 14                	je     800472 <_main+0x43a>
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 38 3e 80 00       	push   $0x803e38
  800466:	6a 5e                	push   $0x5e
  800468:	68 bc 3d 80 00       	push   $0x803dbc
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
  800481:	e8 f3 1a 00 00       	call   801f79 <sys_calculate_free_frames>
  800486:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800489:	e8 8b 1b 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  80048e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800491:	8b 45 80             	mov    -0x80(%ebp),%eax
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	50                   	push   %eax
  800498:	e8 82 18 00 00       	call   801d1f <free>
  80049d:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8004a0:	e8 74 1b 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  8004a5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 68 3e 80 00       	push   $0x803e68
  8004b2:	6a 6b                	push   $0x6b
  8004b4:	68 bc 3d 80 00       	push   $0x803dbc
  8004b9:	e8 f7 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004be:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004ca:	e8 29 1e 00 00       	call   8022f8 <sys_rcr2>
  8004cf:	89 c2                	mov    %eax,%edx
  8004d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d4:	39 c2                	cmp    %eax,%edx
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 a4 3e 80 00       	push   $0x803ea4
  8004e0:	6a 6f                	push   $0x6f
  8004e2:	68 bc 3d 80 00       	push   $0x803dbc
  8004e7:	e8 c9 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[0]] = 10;
  8004ec:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004f2:	89 c2                	mov    %eax,%edx
  8004f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f7:	01 d0                	add    %edx,%eax
  8004f9:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004fc:	e8 f7 1d 00 00       	call   8022f8 <sys_rcr2>
  800501:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  800507:	89 d1                	mov    %edx,%ecx
  800509:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050c:	01 ca                	add    %ecx,%edx
  80050e:	39 d0                	cmp    %edx,%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 a4 3e 80 00       	push   $0x803ea4
  80051a:	6a 71                	push   $0x71
  80051c:	68 bc 3d 80 00       	push   $0x803dbc
  800521:	e8 8f 05 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800526:	e8 4e 1a 00 00       	call   801f79 <sys_calculate_free_frames>
  80052b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80052e:	e8 e6 1a 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  800533:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800536:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 dd 17 00 00       	call   801d1f <free>
  800542:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800545:	e8 cf 1a 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  80054a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80054d:	74 14                	je     800563 <_main+0x52b>
  80054f:	83 ec 04             	sub    $0x4,%esp
  800552:	68 68 3e 80 00       	push   $0x803e68
  800557:	6a 76                	push   $0x76
  800559:	68 bc 3d 80 00       	push   $0x803dbc
  80055e:	e8 52 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  800563:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800566:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800569:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056c:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80056f:	e8 84 1d 00 00       	call   8022f8 <sys_rcr2>
  800574:	89 c2                	mov    %eax,%edx
  800576:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	74 14                	je     800591 <_main+0x559>
  80057d:	83 ec 04             	sub    $0x4,%esp
  800580:	68 a4 3e 80 00       	push   $0x803ea4
  800585:	6a 7a                	push   $0x7a
  800587:	68 bc 3d 80 00       	push   $0x803dbc
  80058c:	e8 24 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[1]] = 10;
  800591:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800597:	89 c2                	mov    %eax,%edx
  800599:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005a1:	e8 52 1d 00 00       	call   8022f8 <sys_rcr2>
  8005a6:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  8005ac:	89 d1                	mov    %edx,%ecx
  8005ae:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005b1:	01 ca                	add    %ecx,%edx
  8005b3:	39 d0                	cmp    %edx,%eax
  8005b5:	74 14                	je     8005cb <_main+0x593>
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	68 a4 3e 80 00       	push   $0x803ea4
  8005bf:	6a 7c                	push   $0x7c
  8005c1:	68 bc 3d 80 00       	push   $0x803dbc
  8005c6:	e8 ea 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005cb:	e8 a9 19 00 00       	call   801f79 <sys_calculate_free_frames>
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005d3:	e8 41 1a 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  8005d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  8005db:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005de:	83 ec 0c             	sub    $0xc,%esp
  8005e1:	50                   	push   %eax
  8005e2:	e8 38 17 00 00       	call   801d1f <free>
  8005e7:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005ea:	e8 2a 1a 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  8005ef:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005f2:	74 17                	je     80060b <_main+0x5d3>
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 68 3e 80 00       	push   $0x803e68
  8005fc:	68 81 00 00 00       	push   $0x81
  800601:	68 bc 3d 80 00       	push   $0x803dbc
  800606:	e8 aa 04 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  80060b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800611:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800614:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800617:	e8 dc 1c 00 00       	call   8022f8 <sys_rcr2>
  80061c:	89 c2                	mov    %eax,%edx
  80061e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800621:	39 c2                	cmp    %eax,%edx
  800623:	74 17                	je     80063c <_main+0x604>
  800625:	83 ec 04             	sub    $0x4,%esp
  800628:	68 a4 3e 80 00       	push   $0x803ea4
  80062d:	68 85 00 00 00       	push   $0x85
  800632:	68 bc 3d 80 00       	push   $0x803dbc
  800637:	e8 79 04 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[2]] = 10;
  80063c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800642:	89 c2                	mov    %eax,%edx
  800644:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800647:	01 d0                	add    %edx,%eax
  800649:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80064c:	e8 a7 1c 00 00       	call   8022f8 <sys_rcr2>
  800651:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  800657:	89 d1                	mov    %edx,%ecx
  800659:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065c:	01 ca                	add    %ecx,%edx
  80065e:	39 d0                	cmp    %edx,%eax
  800660:	74 17                	je     800679 <_main+0x641>
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 a4 3e 80 00       	push   $0x803ea4
  80066a:	68 87 00 00 00       	push   $0x87
  80066f:	68 bc 3d 80 00       	push   $0x803dbc
  800674:	e8 3c 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800679:	e8 fb 18 00 00       	call   801f79 <sys_calculate_free_frames>
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800681:	e8 93 19 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  800686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800689:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	50                   	push   %eax
  800690:	e8 8a 16 00 00       	call   801d1f <free>
  800695:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800698:	e8 7c 19 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 68 3e 80 00       	push   $0x803e68
  8006aa:	68 8c 00 00 00       	push   $0x8c
  8006af:	68 bc 3d 80 00       	push   $0x803dbc
  8006b4:	e8 fc 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  8006b9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8006bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c2:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006c5:	e8 2e 1c 00 00       	call   8022f8 <sys_rcr2>
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006cf:	39 c2                	cmp    %eax,%edx
  8006d1:	74 17                	je     8006ea <_main+0x6b2>
  8006d3:	83 ec 04             	sub    $0x4,%esp
  8006d6:	68 a4 3e 80 00       	push   $0x803ea4
  8006db:	68 90 00 00 00       	push   $0x90
  8006e0:	68 bc 3d 80 00       	push   $0x803dbc
  8006e5:	e8 cb 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[3]] = 10;
  8006ea:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006fa:	e8 f9 1b 00 00       	call   8022f8 <sys_rcr2>
  8006ff:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800705:	89 d1                	mov    %edx,%ecx
  800707:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80070a:	01 ca                	add    %ecx,%edx
  80070c:	39 d0                	cmp    %edx,%eax
  80070e:	74 17                	je     800727 <_main+0x6ef>
  800710:	83 ec 04             	sub    $0x4,%esp
  800713:	68 a4 3e 80 00       	push   $0x803ea4
  800718:	68 92 00 00 00       	push   $0x92
  80071d:	68 bc 3d 80 00       	push   $0x803dbc
  800722:	e8 8e 03 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800727:	e8 4d 18 00 00       	call   801f79 <sys_calculate_free_frames>
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80072f:	e8 e5 18 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  800734:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  800737:	8b 45 90             	mov    -0x70(%ebp),%eax
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	50                   	push   %eax
  80073e:	e8 dc 15 00 00       	call   801d1f <free>
  800743:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800746:	e8 ce 18 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  80074b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80074e:	74 17                	je     800767 <_main+0x72f>
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	68 68 3e 80 00       	push   $0x803e68
  800758:	68 97 00 00 00       	push   $0x97
  80075d:	68 bc 3d 80 00       	push   $0x803dbc
  800762:	e8 4e 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  800767:	8b 45 90             	mov    -0x70(%ebp),%eax
  80076a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80076d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800770:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800773:	e8 80 1b 00 00       	call   8022f8 <sys_rcr2>
  800778:	89 c2                	mov    %eax,%edx
  80077a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	74 17                	je     800798 <_main+0x760>
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	68 a4 3e 80 00       	push   $0x803ea4
  800789:	68 9b 00 00 00       	push   $0x9b
  80078e:	68 bc 3d 80 00       	push   $0x803dbc
  800793:	e8 1d 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[4]] = 10;
  800798:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80079e:	89 c2                	mov    %eax,%edx
  8007a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a3:	01 d0                	add    %edx,%eax
  8007a5:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007a8:	e8 4b 1b 00 00       	call   8022f8 <sys_rcr2>
  8007ad:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  8007b3:	89 d1                	mov    %edx,%ecx
  8007b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007b8:	01 ca                	add    %ecx,%edx
  8007ba:	39 d0                	cmp    %edx,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 a4 3e 80 00       	push   $0x803ea4
  8007c6:	68 9d 00 00 00       	push   $0x9d
  8007cb:	68 bc 3d 80 00       	push   $0x803dbc
  8007d0:	e8 e0 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8007d5:	e8 9f 17 00 00       	call   801f79 <sys_calculate_free_frames>
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007dd:	e8 37 18 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  8007e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  8007e5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	50                   	push   %eax
  8007ec:	e8 2e 15 00 00       	call   801d1f <free>
  8007f1:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  8007f4:	e8 20 18 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  8007f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8007fc:	74 17                	je     800815 <_main+0x7dd>
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	68 68 3e 80 00       	push   $0x803e68
  800806:	68 a2 00 00 00       	push   $0xa2
  80080b:	68 bc 3d 80 00       	push   $0x803dbc
  800810:	e8 a0 02 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  800815:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800818:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80081b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80081e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800821:	e8 d2 1a 00 00       	call   8022f8 <sys_rcr2>
  800826:	89 c2                	mov    %eax,%edx
  800828:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80082b:	39 c2                	cmp    %eax,%edx
  80082d:	74 17                	je     800846 <_main+0x80e>
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 a4 3e 80 00       	push   $0x803ea4
  800837:	68 a6 00 00 00       	push   $0xa6
  80083c:	68 bc 3d 80 00       	push   $0x803dbc
  800841:	e8 6f 02 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[5]] = 10;
  800846:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800856:	e8 9d 1a 00 00       	call   8022f8 <sys_rcr2>
  80085b:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  800861:	89 d1                	mov    %edx,%ecx
  800863:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800866:	01 ca                	add    %ecx,%edx
  800868:	39 d0                	cmp    %edx,%eax
  80086a:	74 17                	je     800883 <_main+0x84b>
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	68 a4 3e 80 00       	push   $0x803ea4
  800874:	68 a8 00 00 00       	push   $0xa8
  800879:	68 bc 3d 80 00       	push   $0x803dbc
  80087e:	e8 32 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800883:	e8 f1 16 00 00       	call   801f79 <sys_calculate_free_frames>
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80088b:	e8 89 17 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  800890:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  800893:	8b 45 98             	mov    -0x68(%ebp),%eax
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	50                   	push   %eax
  80089a:	e8 80 14 00 00       	call   801d1f <free>
  80089f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8008a2:	e8 72 17 00 00       	call   802019 <sys_pf_calculate_allocated_pages>
  8008a7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8008aa:	74 17                	je     8008c3 <_main+0x88b>
  8008ac:	83 ec 04             	sub    $0x4,%esp
  8008af:	68 68 3e 80 00       	push   $0x803e68
  8008b4:	68 ad 00 00 00       	push   $0xad
  8008b9:	68 bc 3d 80 00       	push   $0x803dbc
  8008be:	e8 f2 01 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  8008c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8008c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008cc:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8008cf:	e8 24 1a 00 00       	call   8022f8 <sys_rcr2>
  8008d4:	89 c2                	mov    %eax,%edx
  8008d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008d9:	39 c2                	cmp    %eax,%edx
  8008db:	74 17                	je     8008f4 <_main+0x8bc>
  8008dd:	83 ec 04             	sub    $0x4,%esp
  8008e0:	68 a4 3e 80 00       	push   $0x803ea4
  8008e5:	68 b1 00 00 00       	push   $0xb1
  8008ea:	68 bc 3d 80 00       	push   $0x803dbc
  8008ef:	e8 c1 01 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[6]] = 10;
  8008f4:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8008fa:	89 c2                	mov    %eax,%edx
  8008fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008ff:	01 d0                	add    %edx,%eax
  800901:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800904:	e8 ef 19 00 00       	call   8022f8 <sys_rcr2>
  800909:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  80090f:	89 d1                	mov    %edx,%ecx
  800911:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800914:	01 ca                	add    %ecx,%edx
  800916:	39 d0                	cmp    %edx,%eax
  800918:	74 17                	je     800931 <_main+0x8f9>
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	68 a4 3e 80 00       	push   $0x803ea4
  800922:	68 b3 00 00 00       	push   $0xb3
  800927:	68 bc 3d 80 00       	push   $0x803dbc
  80092c:	e8 84 01 00 00       	call   800ab5 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames()) ) {panic("Wrong free: not all pages removed correctly at end");}
  800931:	e8 43 16 00 00       	call   801f79 <sys_calculate_free_frames>
  800936:	89 c2                	mov    %eax,%edx
  800938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80093b:	39 c2                	cmp    %eax,%edx
  80093d:	74 17                	je     800956 <_main+0x91e>
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	68 e8 3e 80 00       	push   $0x803ee8
  800947:	68 b5 00 00 00       	push   $0xb5
  80094c:	68 bc 3d 80 00       	push   $0x803dbc
  800951:	e8 5f 01 00 00       	call   800ab5 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  800956:	83 ec 0c             	sub    $0xc,%esp
  800959:	6a 00                	push   $0x0
  80095b:	e8 b1 19 00 00       	call   802311 <sys_bypassPageFault>
  800960:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  800963:	83 ec 0c             	sub    $0xc,%esp
  800966:	68 1c 3f 80 00       	push   $0x803f1c
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
  80097f:	e8 d5 18 00 00       	call   802259 <sys_getenvindex>
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
  8009ea:	e8 77 16 00 00       	call   802066 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009ef:	83 ec 0c             	sub    $0xc,%esp
  8009f2:	68 70 3f 80 00       	push   $0x803f70
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
  800a1a:	68 98 3f 80 00       	push   $0x803f98
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
  800a4b:	68 c0 3f 80 00       	push   $0x803fc0
  800a50:	e8 14 03 00 00       	call   800d69 <cprintf>
  800a55:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a58:	a1 20 50 80 00       	mov    0x805020,%eax
  800a5d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	50                   	push   %eax
  800a67:	68 18 40 80 00       	push   $0x804018
  800a6c:	e8 f8 02 00 00       	call   800d69 <cprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	68 70 3f 80 00       	push   $0x803f70
  800a7c:	e8 e8 02 00 00       	call   800d69 <cprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a84:	e8 f7 15 00 00       	call   802080 <sys_enable_interrupt>

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
  800a9c:	e8 84 17 00 00       	call   802225 <sys_destroy_env>
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
  800aad:	e8 d9 17 00 00       	call   80228b <sys_exit_env>
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
  800ad6:	68 2c 40 80 00       	push   $0x80402c
  800adb:	e8 89 02 00 00       	call   800d69 <cprintf>
  800ae0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ae3:	a1 00 50 80 00       	mov    0x805000,%eax
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	50                   	push   %eax
  800aef:	68 31 40 80 00       	push   $0x804031
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
  800b13:	68 4d 40 80 00       	push   $0x80404d
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
  800b3f:	68 50 40 80 00       	push   $0x804050
  800b44:	6a 26                	push   $0x26
  800b46:	68 9c 40 80 00       	push   $0x80409c
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
  800c11:	68 a8 40 80 00       	push   $0x8040a8
  800c16:	6a 3a                	push   $0x3a
  800c18:	68 9c 40 80 00       	push   $0x80409c
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
  800c81:	68 fc 40 80 00       	push   $0x8040fc
  800c86:	6a 44                	push   $0x44
  800c88:	68 9c 40 80 00       	push   $0x80409c
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
  800cdb:	e8 d8 11 00 00       	call   801eb8 <sys_cputs>
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
  800d52:	e8 61 11 00 00       	call   801eb8 <sys_cputs>
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
  800d9c:	e8 c5 12 00 00       	call   802066 <sys_disable_interrupt>
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
  800dbc:	e8 bf 12 00 00       	call   802080 <sys_enable_interrupt>
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
  800e06:	e8 31 2d 00 00       	call   803b3c <__udivdi3>
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
  800e56:	e8 f1 2d 00 00       	call   803c4c <__umoddi3>
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	05 74 43 80 00       	add    $0x804374,%eax
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
  800fb1:	8b 04 85 98 43 80 00 	mov    0x804398(,%eax,4),%eax
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
  801092:	8b 34 9d e0 41 80 00 	mov    0x8041e0(,%ebx,4),%esi
  801099:	85 f6                	test   %esi,%esi
  80109b:	75 19                	jne    8010b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80109d:	53                   	push   %ebx
  80109e:	68 85 43 80 00       	push   $0x804385
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
  8010b7:	68 8e 43 80 00       	push   $0x80438e
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
  8010e4:	be 91 43 80 00       	mov    $0x804391,%esi
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
  801b0a:	68 f0 44 80 00       	push   $0x8044f0
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
  801bda:	e8 1d 04 00 00       	call   801ffc <sys_allocate_chunk>
  801bdf:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801be2:	a1 20 51 80 00       	mov    0x805120,%eax
  801be7:	83 ec 0c             	sub    $0xc,%esp
  801bea:	50                   	push   %eax
  801beb:	e8 92 0a 00 00       	call   802682 <initialize_MemBlocksList>
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
  801c18:	68 15 45 80 00       	push   $0x804515
  801c1d:	6a 33                	push   $0x33
  801c1f:	68 33 45 80 00       	push   $0x804533
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
  801c97:	68 40 45 80 00       	push   $0x804540
  801c9c:	6a 34                	push   $0x34
  801c9e:	68 33 45 80 00       	push   $0x804533
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
  801cf4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cf7:	e8 f7 fd ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cfc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d00:	75 07                	jne    801d09 <malloc+0x18>
  801d02:	b8 00 00 00 00       	mov    $0x0,%eax
  801d07:	eb 14                	jmp    801d1d <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801d09:	83 ec 04             	sub    $0x4,%esp
  801d0c:	68 64 45 80 00       	push   $0x804564
  801d11:	6a 46                	push   $0x46
  801d13:	68 33 45 80 00       	push   $0x804533
  801d18:	e8 98 ed ff ff       	call   800ab5 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801d25:	83 ec 04             	sub    $0x4,%esp
  801d28:	68 8c 45 80 00       	push   $0x80458c
  801d2d:	6a 61                	push   $0x61
  801d2f:	68 33 45 80 00       	push   $0x804533
  801d34:	e8 7c ed ff ff       	call   800ab5 <_panic>

00801d39 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 38             	sub    $0x38,%esp
  801d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d42:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d45:	e8 a9 fd ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d4e:	75 07                	jne    801d57 <smalloc+0x1e>
  801d50:	b8 00 00 00 00       	mov    $0x0,%eax
  801d55:	eb 7c                	jmp    801dd3 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801d57:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d64:	01 d0                	add    %edx,%eax
  801d66:	48                   	dec    %eax
  801d67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d72:	f7 75 f0             	divl   -0x10(%ebp)
  801d75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d78:	29 d0                	sub    %edx,%eax
  801d7a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801d7d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801d84:	e8 41 06 00 00       	call   8023ca <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d89:	85 c0                	test   %eax,%eax
  801d8b:	74 11                	je     801d9e <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801d8d:	83 ec 0c             	sub    $0xc,%esp
  801d90:	ff 75 e8             	pushl  -0x18(%ebp)
  801d93:	e8 ac 0c 00 00       	call   802a44 <alloc_block_FF>
  801d98:	83 c4 10             	add    $0x10,%esp
  801d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801d9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da2:	74 2a                	je     801dce <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da7:	8b 40 08             	mov    0x8(%eax),%eax
  801daa:	89 c2                	mov    %eax,%edx
  801dac:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801db0:	52                   	push   %edx
  801db1:	50                   	push   %eax
  801db2:	ff 75 0c             	pushl  0xc(%ebp)
  801db5:	ff 75 08             	pushl  0x8(%ebp)
  801db8:	e8 92 03 00 00       	call   80214f <sys_createSharedObject>
  801dbd:	83 c4 10             	add    $0x10,%esp
  801dc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801dc3:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801dc7:	74 05                	je     801dce <smalloc+0x95>
			return (void*)virtual_address;
  801dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dcc:	eb 05                	jmp    801dd3 <smalloc+0x9a>
	}
	return NULL;
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ddb:	e8 13 fd ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801de0:	83 ec 04             	sub    $0x4,%esp
  801de3:	68 b0 45 80 00       	push   $0x8045b0
  801de8:	68 a2 00 00 00       	push   $0xa2
  801ded:	68 33 45 80 00       	push   $0x804533
  801df2:	e8 be ec ff ff       	call   800ab5 <_panic>

00801df7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dfd:	e8 f1 fc ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e02:	83 ec 04             	sub    $0x4,%esp
  801e05:	68 d4 45 80 00       	push   $0x8045d4
  801e0a:	68 e6 00 00 00       	push   $0xe6
  801e0f:	68 33 45 80 00       	push   $0x804533
  801e14:	e8 9c ec ff ff       	call   800ab5 <_panic>

00801e19 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e1f:	83 ec 04             	sub    $0x4,%esp
  801e22:	68 fc 45 80 00       	push   $0x8045fc
  801e27:	68 fa 00 00 00       	push   $0xfa
  801e2c:	68 33 45 80 00       	push   $0x804533
  801e31:	e8 7f ec ff ff       	call   800ab5 <_panic>

00801e36 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e3c:	83 ec 04             	sub    $0x4,%esp
  801e3f:	68 20 46 80 00       	push   $0x804620
  801e44:	68 05 01 00 00       	push   $0x105
  801e49:	68 33 45 80 00       	push   $0x804533
  801e4e:	e8 62 ec ff ff       	call   800ab5 <_panic>

00801e53 <shrink>:

}
void shrink(uint32 newSize)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e59:	83 ec 04             	sub    $0x4,%esp
  801e5c:	68 20 46 80 00       	push   $0x804620
  801e61:	68 0a 01 00 00       	push   $0x10a
  801e66:	68 33 45 80 00       	push   $0x804533
  801e6b:	e8 45 ec ff ff       	call   800ab5 <_panic>

00801e70 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e76:	83 ec 04             	sub    $0x4,%esp
  801e79:	68 20 46 80 00       	push   $0x804620
  801e7e:	68 0f 01 00 00       	push   $0x10f
  801e83:	68 33 45 80 00       	push   $0x804533
  801e88:	e8 28 ec ff ff       	call   800ab5 <_panic>

00801e8d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	57                   	push   %edi
  801e91:	56                   	push   %esi
  801e92:	53                   	push   %ebx
  801e93:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e96:	8b 45 08             	mov    0x8(%ebp),%eax
  801e99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e9f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ea2:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ea5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ea8:	cd 30                	int    $0x30
  801eaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801eb0:	83 c4 10             	add    $0x10,%esp
  801eb3:	5b                   	pop    %ebx
  801eb4:	5e                   	pop    %esi
  801eb5:	5f                   	pop    %edi
  801eb6:	5d                   	pop    %ebp
  801eb7:	c3                   	ret    

00801eb8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	83 ec 04             	sub    $0x4,%esp
  801ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ec4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	52                   	push   %edx
  801ed0:	ff 75 0c             	pushl  0xc(%ebp)
  801ed3:	50                   	push   %eax
  801ed4:	6a 00                	push   $0x0
  801ed6:	e8 b2 ff ff ff       	call   801e8d <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
}
  801ede:	90                   	nop
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 01                	push   $0x1
  801ef0:	e8 98 ff ff ff       	call   801e8d <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801efd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	52                   	push   %edx
  801f0a:	50                   	push   %eax
  801f0b:	6a 05                	push   $0x5
  801f0d:	e8 7b ff ff ff       	call   801e8d <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	56                   	push   %esi
  801f1b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f1c:	8b 75 18             	mov    0x18(%ebp),%esi
  801f1f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	56                   	push   %esi
  801f2c:	53                   	push   %ebx
  801f2d:	51                   	push   %ecx
  801f2e:	52                   	push   %edx
  801f2f:	50                   	push   %eax
  801f30:	6a 06                	push   $0x6
  801f32:	e8 56 ff ff ff       	call   801e8d <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f3d:	5b                   	pop    %ebx
  801f3e:	5e                   	pop    %esi
  801f3f:	5d                   	pop    %ebp
  801f40:	c3                   	ret    

00801f41 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	52                   	push   %edx
  801f51:	50                   	push   %eax
  801f52:	6a 07                	push   $0x7
  801f54:	e8 34 ff ff ff       	call   801e8d <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	ff 75 0c             	pushl  0xc(%ebp)
  801f6a:	ff 75 08             	pushl  0x8(%ebp)
  801f6d:	6a 08                	push   $0x8
  801f6f:	e8 19 ff ff ff       	call   801e8d <syscall>
  801f74:	83 c4 18             	add    $0x18,%esp
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 09                	push   $0x9
  801f88:	e8 00 ff ff ff       	call   801e8d <syscall>
  801f8d:	83 c4 18             	add    $0x18,%esp
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 0a                	push   $0xa
  801fa1:	e8 e7 fe ff ff       	call   801e8d <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 0b                	push   $0xb
  801fba:	e8 ce fe ff ff       	call   801e8d <syscall>
  801fbf:	83 c4 18             	add    $0x18,%esp
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	ff 75 0c             	pushl  0xc(%ebp)
  801fd0:	ff 75 08             	pushl  0x8(%ebp)
  801fd3:	6a 0f                	push   $0xf
  801fd5:	e8 b3 fe ff ff       	call   801e8d <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
	return;
  801fdd:	90                   	nop
}
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	ff 75 0c             	pushl  0xc(%ebp)
  801fec:	ff 75 08             	pushl  0x8(%ebp)
  801fef:	6a 10                	push   $0x10
  801ff1:	e8 97 fe ff ff       	call   801e8d <syscall>
  801ff6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff9:	90                   	nop
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	ff 75 10             	pushl  0x10(%ebp)
  802006:	ff 75 0c             	pushl  0xc(%ebp)
  802009:	ff 75 08             	pushl  0x8(%ebp)
  80200c:	6a 11                	push   $0x11
  80200e:	e8 7a fe ff ff       	call   801e8d <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
	return ;
  802016:	90                   	nop
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 0c                	push   $0xc
  802028:	e8 60 fe ff ff       	call   801e8d <syscall>
  80202d:	83 c4 18             	add    $0x18,%esp
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	ff 75 08             	pushl  0x8(%ebp)
  802040:	6a 0d                	push   $0xd
  802042:	e8 46 fe ff ff       	call   801e8d <syscall>
  802047:	83 c4 18             	add    $0x18,%esp
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 0e                	push   $0xe
  80205b:	e8 2d fe ff ff       	call   801e8d <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
}
  802063:	90                   	nop
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 13                	push   $0x13
  802075:	e8 13 fe ff ff       	call   801e8d <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
}
  80207d:	90                   	nop
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 14                	push   $0x14
  80208f:	e8 f9 fd ff ff       	call   801e8d <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
}
  802097:	90                   	nop
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sys_cputc>:


void
sys_cputc(const char c)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 04             	sub    $0x4,%esp
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020a6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	50                   	push   %eax
  8020b3:	6a 15                	push   $0x15
  8020b5:	e8 d3 fd ff ff       	call   801e8d <syscall>
  8020ba:	83 c4 18             	add    $0x18,%esp
}
  8020bd:	90                   	nop
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 16                	push   $0x16
  8020cf:	e8 b9 fd ff ff       	call   801e8d <syscall>
  8020d4:	83 c4 18             	add    $0x18,%esp
}
  8020d7:	90                   	nop
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	ff 75 0c             	pushl  0xc(%ebp)
  8020e9:	50                   	push   %eax
  8020ea:	6a 17                	push   $0x17
  8020ec:	e8 9c fd ff ff       	call   801e8d <syscall>
  8020f1:	83 c4 18             	add    $0x18,%esp
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	52                   	push   %edx
  802106:	50                   	push   %eax
  802107:	6a 1a                	push   $0x1a
  802109:	e8 7f fd ff ff       	call   801e8d <syscall>
  80210e:	83 c4 18             	add    $0x18,%esp
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802116:	8b 55 0c             	mov    0xc(%ebp),%edx
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	52                   	push   %edx
  802123:	50                   	push   %eax
  802124:	6a 18                	push   $0x18
  802126:	e8 62 fd ff ff       	call   801e8d <syscall>
  80212b:	83 c4 18             	add    $0x18,%esp
}
  80212e:	90                   	nop
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802134:	8b 55 0c             	mov    0xc(%ebp),%edx
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	52                   	push   %edx
  802141:	50                   	push   %eax
  802142:	6a 19                	push   $0x19
  802144:	e8 44 fd ff ff       	call   801e8d <syscall>
  802149:	83 c4 18             	add    $0x18,%esp
}
  80214c:	90                   	nop
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	83 ec 04             	sub    $0x4,%esp
  802155:	8b 45 10             	mov    0x10(%ebp),%eax
  802158:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80215b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80215e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	6a 00                	push   $0x0
  802167:	51                   	push   %ecx
  802168:	52                   	push   %edx
  802169:	ff 75 0c             	pushl  0xc(%ebp)
  80216c:	50                   	push   %eax
  80216d:	6a 1b                	push   $0x1b
  80216f:	e8 19 fd ff ff       	call   801e8d <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80217c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	52                   	push   %edx
  802189:	50                   	push   %eax
  80218a:	6a 1c                	push   $0x1c
  80218c:	e8 fc fc ff ff       	call   801e8d <syscall>
  802191:	83 c4 18             	add    $0x18,%esp
}
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802199:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80219c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	51                   	push   %ecx
  8021a7:	52                   	push   %edx
  8021a8:	50                   	push   %eax
  8021a9:	6a 1d                	push   $0x1d
  8021ab:	e8 dd fc ff ff       	call   801e8d <syscall>
  8021b0:	83 c4 18             	add    $0x18,%esp
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	52                   	push   %edx
  8021c5:	50                   	push   %eax
  8021c6:	6a 1e                	push   $0x1e
  8021c8:	e8 c0 fc ff ff       	call   801e8d <syscall>
  8021cd:	83 c4 18             	add    $0x18,%esp
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 1f                	push   $0x1f
  8021e1:	e8 a7 fc ff ff       	call   801e8d <syscall>
  8021e6:	83 c4 18             	add    $0x18,%esp
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	6a 00                	push   $0x0
  8021f3:	ff 75 14             	pushl  0x14(%ebp)
  8021f6:	ff 75 10             	pushl  0x10(%ebp)
  8021f9:	ff 75 0c             	pushl  0xc(%ebp)
  8021fc:	50                   	push   %eax
  8021fd:	6a 20                	push   $0x20
  8021ff:	e8 89 fc ff ff       	call   801e8d <syscall>
  802204:	83 c4 18             	add    $0x18,%esp
}
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	50                   	push   %eax
  802218:	6a 21                	push   $0x21
  80221a:	e8 6e fc ff ff       	call   801e8d <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
}
  802222:	90                   	nop
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	50                   	push   %eax
  802234:	6a 22                	push   $0x22
  802236:	e8 52 fc ff ff       	call   801e8d <syscall>
  80223b:	83 c4 18             	add    $0x18,%esp
}
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 02                	push   $0x2
  80224f:	e8 39 fc ff ff       	call   801e8d <syscall>
  802254:	83 c4 18             	add    $0x18,%esp
}
  802257:	c9                   	leave  
  802258:	c3                   	ret    

00802259 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 03                	push   $0x3
  802268:	e8 20 fc ff ff       	call   801e8d <syscall>
  80226d:	83 c4 18             	add    $0x18,%esp
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 04                	push   $0x4
  802281:	e8 07 fc ff ff       	call   801e8d <syscall>
  802286:	83 c4 18             	add    $0x18,%esp
}
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <sys_exit_env>:


void sys_exit_env(void)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 23                	push   $0x23
  80229a:	e8 ee fb ff ff       	call   801e8d <syscall>
  80229f:	83 c4 18             	add    $0x18,%esp
}
  8022a2:	90                   	nop
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022ab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022ae:	8d 50 04             	lea    0x4(%eax),%edx
  8022b1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	52                   	push   %edx
  8022bb:	50                   	push   %eax
  8022bc:	6a 24                	push   $0x24
  8022be:	e8 ca fb ff ff       	call   801e8d <syscall>
  8022c3:	83 c4 18             	add    $0x18,%esp
	return result;
  8022c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022cf:	89 01                	mov    %eax,(%ecx)
  8022d1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	c9                   	leave  
  8022d8:	c2 04 00             	ret    $0x4

008022db <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	ff 75 10             	pushl  0x10(%ebp)
  8022e5:	ff 75 0c             	pushl  0xc(%ebp)
  8022e8:	ff 75 08             	pushl  0x8(%ebp)
  8022eb:	6a 12                	push   $0x12
  8022ed:	e8 9b fb ff ff       	call   801e8d <syscall>
  8022f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f5:	90                   	nop
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 25                	push   $0x25
  802307:	e8 81 fb ff ff       	call   801e8d <syscall>
  80230c:	83 c4 18             	add    $0x18,%esp
}
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	83 ec 04             	sub    $0x4,%esp
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80231d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	50                   	push   %eax
  80232a:	6a 26                	push   $0x26
  80232c:	e8 5c fb ff ff       	call   801e8d <syscall>
  802331:	83 c4 18             	add    $0x18,%esp
	return ;
  802334:	90                   	nop
}
  802335:	c9                   	leave  
  802336:	c3                   	ret    

00802337 <rsttst>:
void rsttst()
{
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 28                	push   $0x28
  802346:	e8 42 fb ff ff       	call   801e8d <syscall>
  80234b:	83 c4 18             	add    $0x18,%esp
	return ;
  80234e:	90                   	nop
}
  80234f:	c9                   	leave  
  802350:	c3                   	ret    

00802351 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	83 ec 04             	sub    $0x4,%esp
  802357:	8b 45 14             	mov    0x14(%ebp),%eax
  80235a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80235d:	8b 55 18             	mov    0x18(%ebp),%edx
  802360:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802364:	52                   	push   %edx
  802365:	50                   	push   %eax
  802366:	ff 75 10             	pushl  0x10(%ebp)
  802369:	ff 75 0c             	pushl  0xc(%ebp)
  80236c:	ff 75 08             	pushl  0x8(%ebp)
  80236f:	6a 27                	push   $0x27
  802371:	e8 17 fb ff ff       	call   801e8d <syscall>
  802376:	83 c4 18             	add    $0x18,%esp
	return ;
  802379:	90                   	nop
}
  80237a:	c9                   	leave  
  80237b:	c3                   	ret    

0080237c <chktst>:
void chktst(uint32 n)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	ff 75 08             	pushl  0x8(%ebp)
  80238a:	6a 29                	push   $0x29
  80238c:	e8 fc fa ff ff       	call   801e8d <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
	return ;
  802394:	90                   	nop
}
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <inctst>:

void inctst()
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 2a                	push   $0x2a
  8023a6:	e8 e2 fa ff ff       	call   801e8d <syscall>
  8023ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ae:	90                   	nop
}
  8023af:	c9                   	leave  
  8023b0:	c3                   	ret    

008023b1 <gettst>:
uint32 gettst()
{
  8023b1:	55                   	push   %ebp
  8023b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 2b                	push   $0x2b
  8023c0:	e8 c8 fa ff ff       	call   801e8d <syscall>
  8023c5:	83 c4 18             	add    $0x18,%esp
}
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 2c                	push   $0x2c
  8023dc:	e8 ac fa ff ff       	call   801e8d <syscall>
  8023e1:	83 c4 18             	add    $0x18,%esp
  8023e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023e7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023eb:	75 07                	jne    8023f4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f2:	eb 05                	jmp    8023f9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 2c                	push   $0x2c
  80240d:	e8 7b fa ff ff       	call   801e8d <syscall>
  802412:	83 c4 18             	add    $0x18,%esp
  802415:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802418:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80241c:	75 07                	jne    802425 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80241e:	b8 01 00 00 00       	mov    $0x1,%eax
  802423:	eb 05                	jmp    80242a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802425:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
  80242f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 2c                	push   $0x2c
  80243e:	e8 4a fa ff ff       	call   801e8d <syscall>
  802443:	83 c4 18             	add    $0x18,%esp
  802446:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802449:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80244d:	75 07                	jne    802456 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80244f:	b8 01 00 00 00       	mov    $0x1,%eax
  802454:	eb 05                	jmp    80245b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802456:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    

0080245d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80245d:	55                   	push   %ebp
  80245e:	89 e5                	mov    %esp,%ebp
  802460:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 2c                	push   $0x2c
  80246f:	e8 19 fa ff ff       	call   801e8d <syscall>
  802474:	83 c4 18             	add    $0x18,%esp
  802477:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80247a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80247e:	75 07                	jne    802487 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802480:	b8 01 00 00 00       	mov    $0x1,%eax
  802485:	eb 05                	jmp    80248c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802487:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80248c:	c9                   	leave  
  80248d:	c3                   	ret    

0080248e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	ff 75 08             	pushl  0x8(%ebp)
  80249c:	6a 2d                	push   $0x2d
  80249e:	e8 ea f9 ff ff       	call   801e8d <syscall>
  8024a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a6:	90                   	nop
}
  8024a7:	c9                   	leave  
  8024a8:	c3                   	ret    

008024a9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024a9:	55                   	push   %ebp
  8024aa:	89 e5                	mov    %esp,%ebp
  8024ac:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	6a 00                	push   $0x0
  8024bb:	53                   	push   %ebx
  8024bc:	51                   	push   %ecx
  8024bd:	52                   	push   %edx
  8024be:	50                   	push   %eax
  8024bf:	6a 2e                	push   $0x2e
  8024c1:	e8 c7 f9 ff ff       	call   801e8d <syscall>
  8024c6:	83 c4 18             	add    $0x18,%esp
}
  8024c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

008024ce <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	52                   	push   %edx
  8024de:	50                   	push   %eax
  8024df:	6a 2f                	push   $0x2f
  8024e1:	e8 a7 f9 ff ff       	call   801e8d <syscall>
  8024e6:	83 c4 18             	add    $0x18,%esp
}
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024f1:	83 ec 0c             	sub    $0xc,%esp
  8024f4:	68 30 46 80 00       	push   $0x804630
  8024f9:	e8 6b e8 ff ff       	call   800d69 <cprintf>
  8024fe:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802501:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802508:	83 ec 0c             	sub    $0xc,%esp
  80250b:	68 5c 46 80 00       	push   $0x80465c
  802510:	e8 54 e8 ff ff       	call   800d69 <cprintf>
  802515:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802518:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80251c:	a1 38 51 80 00       	mov    0x805138,%eax
  802521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802524:	eb 56                	jmp    80257c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802526:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80252a:	74 1c                	je     802548 <print_mem_block_lists+0x5d>
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 50 08             	mov    0x8(%eax),%edx
  802532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802535:	8b 48 08             	mov    0x8(%eax),%ecx
  802538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253b:	8b 40 0c             	mov    0xc(%eax),%eax
  80253e:	01 c8                	add    %ecx,%eax
  802540:	39 c2                	cmp    %eax,%edx
  802542:	73 04                	jae    802548 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802544:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 50 08             	mov    0x8(%eax),%edx
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 40 0c             	mov    0xc(%eax),%eax
  802554:	01 c2                	add    %eax,%edx
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 40 08             	mov    0x8(%eax),%eax
  80255c:	83 ec 04             	sub    $0x4,%esp
  80255f:	52                   	push   %edx
  802560:	50                   	push   %eax
  802561:	68 71 46 80 00       	push   $0x804671
  802566:	e8 fe e7 ff ff       	call   800d69 <cprintf>
  80256b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802574:	a1 40 51 80 00       	mov    0x805140,%eax
  802579:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802580:	74 07                	je     802589 <print_mem_block_lists+0x9e>
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	eb 05                	jmp    80258e <print_mem_block_lists+0xa3>
  802589:	b8 00 00 00 00       	mov    $0x0,%eax
  80258e:	a3 40 51 80 00       	mov    %eax,0x805140
  802593:	a1 40 51 80 00       	mov    0x805140,%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	75 8a                	jne    802526 <print_mem_block_lists+0x3b>
  80259c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a0:	75 84                	jne    802526 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025a2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025a6:	75 10                	jne    8025b8 <print_mem_block_lists+0xcd>
  8025a8:	83 ec 0c             	sub    $0xc,%esp
  8025ab:	68 80 46 80 00       	push   $0x804680
  8025b0:	e8 b4 e7 ff ff       	call   800d69 <cprintf>
  8025b5:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025bf:	83 ec 0c             	sub    $0xc,%esp
  8025c2:	68 a4 46 80 00       	push   $0x8046a4
  8025c7:	e8 9d e7 ff ff       	call   800d69 <cprintf>
  8025cc:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025cf:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025d3:	a1 40 50 80 00       	mov    0x805040,%eax
  8025d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025db:	eb 56                	jmp    802633 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025e1:	74 1c                	je     8025ff <print_mem_block_lists+0x114>
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	8b 50 08             	mov    0x8(%eax),%edx
  8025e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ec:	8b 48 08             	mov    0x8(%eax),%ecx
  8025ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f5:	01 c8                	add    %ecx,%eax
  8025f7:	39 c2                	cmp    %eax,%edx
  8025f9:	73 04                	jae    8025ff <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025fb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 50 08             	mov    0x8(%eax),%edx
  802605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802608:	8b 40 0c             	mov    0xc(%eax),%eax
  80260b:	01 c2                	add    %eax,%edx
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 40 08             	mov    0x8(%eax),%eax
  802613:	83 ec 04             	sub    $0x4,%esp
  802616:	52                   	push   %edx
  802617:	50                   	push   %eax
  802618:	68 71 46 80 00       	push   $0x804671
  80261d:	e8 47 e7 ff ff       	call   800d69 <cprintf>
  802622:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80262b:	a1 48 50 80 00       	mov    0x805048,%eax
  802630:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802633:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802637:	74 07                	je     802640 <print_mem_block_lists+0x155>
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 00                	mov    (%eax),%eax
  80263e:	eb 05                	jmp    802645 <print_mem_block_lists+0x15a>
  802640:	b8 00 00 00 00       	mov    $0x0,%eax
  802645:	a3 48 50 80 00       	mov    %eax,0x805048
  80264a:	a1 48 50 80 00       	mov    0x805048,%eax
  80264f:	85 c0                	test   %eax,%eax
  802651:	75 8a                	jne    8025dd <print_mem_block_lists+0xf2>
  802653:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802657:	75 84                	jne    8025dd <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802659:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80265d:	75 10                	jne    80266f <print_mem_block_lists+0x184>
  80265f:	83 ec 0c             	sub    $0xc,%esp
  802662:	68 bc 46 80 00       	push   $0x8046bc
  802667:	e8 fd e6 ff ff       	call   800d69 <cprintf>
  80266c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80266f:	83 ec 0c             	sub    $0xc,%esp
  802672:	68 30 46 80 00       	push   $0x804630
  802677:	e8 ed e6 ff ff       	call   800d69 <cprintf>
  80267c:	83 c4 10             	add    $0x10,%esp

}
  80267f:	90                   	nop
  802680:	c9                   	leave  
  802681:	c3                   	ret    

00802682 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802682:	55                   	push   %ebp
  802683:	89 e5                	mov    %esp,%ebp
  802685:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802688:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80268f:	00 00 00 
  802692:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802699:	00 00 00 
  80269c:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026a3:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8026a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026ad:	e9 9e 00 00 00       	jmp    802750 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8026b2:	a1 50 50 80 00       	mov    0x805050,%eax
  8026b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ba:	c1 e2 04             	shl    $0x4,%edx
  8026bd:	01 d0                	add    %edx,%eax
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	75 14                	jne    8026d7 <initialize_MemBlocksList+0x55>
  8026c3:	83 ec 04             	sub    $0x4,%esp
  8026c6:	68 e4 46 80 00       	push   $0x8046e4
  8026cb:	6a 46                	push   $0x46
  8026cd:	68 07 47 80 00       	push   $0x804707
  8026d2:	e8 de e3 ff ff       	call   800ab5 <_panic>
  8026d7:	a1 50 50 80 00       	mov    0x805050,%eax
  8026dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026df:	c1 e2 04             	shl    $0x4,%edx
  8026e2:	01 d0                	add    %edx,%eax
  8026e4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026ea:	89 10                	mov    %edx,(%eax)
  8026ec:	8b 00                	mov    (%eax),%eax
  8026ee:	85 c0                	test   %eax,%eax
  8026f0:	74 18                	je     80270a <initialize_MemBlocksList+0x88>
  8026f2:	a1 48 51 80 00       	mov    0x805148,%eax
  8026f7:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026fd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802700:	c1 e1 04             	shl    $0x4,%ecx
  802703:	01 ca                	add    %ecx,%edx
  802705:	89 50 04             	mov    %edx,0x4(%eax)
  802708:	eb 12                	jmp    80271c <initialize_MemBlocksList+0x9a>
  80270a:	a1 50 50 80 00       	mov    0x805050,%eax
  80270f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802712:	c1 e2 04             	shl    $0x4,%edx
  802715:	01 d0                	add    %edx,%eax
  802717:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80271c:	a1 50 50 80 00       	mov    0x805050,%eax
  802721:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802724:	c1 e2 04             	shl    $0x4,%edx
  802727:	01 d0                	add    %edx,%eax
  802729:	a3 48 51 80 00       	mov    %eax,0x805148
  80272e:	a1 50 50 80 00       	mov    0x805050,%eax
  802733:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802736:	c1 e2 04             	shl    $0x4,%edx
  802739:	01 d0                	add    %edx,%eax
  80273b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802742:	a1 54 51 80 00       	mov    0x805154,%eax
  802747:	40                   	inc    %eax
  802748:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80274d:	ff 45 f4             	incl   -0xc(%ebp)
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	3b 45 08             	cmp    0x8(%ebp),%eax
  802756:	0f 82 56 ff ff ff    	jb     8026b2 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80275c:	90                   	nop
  80275d:	c9                   	leave  
  80275e:	c3                   	ret    

0080275f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80275f:	55                   	push   %ebp
  802760:	89 e5                	mov    %esp,%ebp
  802762:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802765:	8b 45 08             	mov    0x8(%ebp),%eax
  802768:	8b 00                	mov    (%eax),%eax
  80276a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80276d:	eb 19                	jmp    802788 <find_block+0x29>
	{
		if(va==point->sva)
  80276f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802772:	8b 40 08             	mov    0x8(%eax),%eax
  802775:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802778:	75 05                	jne    80277f <find_block+0x20>
		   return point;
  80277a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80277d:	eb 36                	jmp    8027b5 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80277f:	8b 45 08             	mov    0x8(%ebp),%eax
  802782:	8b 40 08             	mov    0x8(%eax),%eax
  802785:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802788:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80278c:	74 07                	je     802795 <find_block+0x36>
  80278e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802791:	8b 00                	mov    (%eax),%eax
  802793:	eb 05                	jmp    80279a <find_block+0x3b>
  802795:	b8 00 00 00 00       	mov    $0x0,%eax
  80279a:	8b 55 08             	mov    0x8(%ebp),%edx
  80279d:	89 42 08             	mov    %eax,0x8(%edx)
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a3:	8b 40 08             	mov    0x8(%eax),%eax
  8027a6:	85 c0                	test   %eax,%eax
  8027a8:	75 c5                	jne    80276f <find_block+0x10>
  8027aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027ae:	75 bf                	jne    80276f <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8027b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
  8027ba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8027bd:	a1 40 50 80 00       	mov    0x805040,%eax
  8027c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8027c5:	a1 44 50 80 00       	mov    0x805044,%eax
  8027ca:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8027cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027d3:	74 24                	je     8027f9 <insert_sorted_allocList+0x42>
  8027d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d8:	8b 50 08             	mov    0x8(%eax),%edx
  8027db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027de:	8b 40 08             	mov    0x8(%eax),%eax
  8027e1:	39 c2                	cmp    %eax,%edx
  8027e3:	76 14                	jbe    8027f9 <insert_sorted_allocList+0x42>
  8027e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e8:	8b 50 08             	mov    0x8(%eax),%edx
  8027eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ee:	8b 40 08             	mov    0x8(%eax),%eax
  8027f1:	39 c2                	cmp    %eax,%edx
  8027f3:	0f 82 60 01 00 00    	jb     802959 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8027f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027fd:	75 65                	jne    802864 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8027ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802803:	75 14                	jne    802819 <insert_sorted_allocList+0x62>
  802805:	83 ec 04             	sub    $0x4,%esp
  802808:	68 e4 46 80 00       	push   $0x8046e4
  80280d:	6a 6b                	push   $0x6b
  80280f:	68 07 47 80 00       	push   $0x804707
  802814:	e8 9c e2 ff ff       	call   800ab5 <_panic>
  802819:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80281f:	8b 45 08             	mov    0x8(%ebp),%eax
  802822:	89 10                	mov    %edx,(%eax)
  802824:	8b 45 08             	mov    0x8(%ebp),%eax
  802827:	8b 00                	mov    (%eax),%eax
  802829:	85 c0                	test   %eax,%eax
  80282b:	74 0d                	je     80283a <insert_sorted_allocList+0x83>
  80282d:	a1 40 50 80 00       	mov    0x805040,%eax
  802832:	8b 55 08             	mov    0x8(%ebp),%edx
  802835:	89 50 04             	mov    %edx,0x4(%eax)
  802838:	eb 08                	jmp    802842 <insert_sorted_allocList+0x8b>
  80283a:	8b 45 08             	mov    0x8(%ebp),%eax
  80283d:	a3 44 50 80 00       	mov    %eax,0x805044
  802842:	8b 45 08             	mov    0x8(%ebp),%eax
  802845:	a3 40 50 80 00       	mov    %eax,0x805040
  80284a:	8b 45 08             	mov    0x8(%ebp),%eax
  80284d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802854:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802859:	40                   	inc    %eax
  80285a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80285f:	e9 dc 01 00 00       	jmp    802a40 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	8b 50 08             	mov    0x8(%eax),%edx
  80286a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286d:	8b 40 08             	mov    0x8(%eax),%eax
  802870:	39 c2                	cmp    %eax,%edx
  802872:	77 6c                	ja     8028e0 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802874:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802878:	74 06                	je     802880 <insert_sorted_allocList+0xc9>
  80287a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80287e:	75 14                	jne    802894 <insert_sorted_allocList+0xdd>
  802880:	83 ec 04             	sub    $0x4,%esp
  802883:	68 20 47 80 00       	push   $0x804720
  802888:	6a 6f                	push   $0x6f
  80288a:	68 07 47 80 00       	push   $0x804707
  80288f:	e8 21 e2 ff ff       	call   800ab5 <_panic>
  802894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802897:	8b 50 04             	mov    0x4(%eax),%edx
  80289a:	8b 45 08             	mov    0x8(%ebp),%eax
  80289d:	89 50 04             	mov    %edx,0x4(%eax)
  8028a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a6:	89 10                	mov    %edx,(%eax)
  8028a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ab:	8b 40 04             	mov    0x4(%eax),%eax
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	74 0d                	je     8028bf <insert_sorted_allocList+0x108>
  8028b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b5:	8b 40 04             	mov    0x4(%eax),%eax
  8028b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028bb:	89 10                	mov    %edx,(%eax)
  8028bd:	eb 08                	jmp    8028c7 <insert_sorted_allocList+0x110>
  8028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c2:	a3 40 50 80 00       	mov    %eax,0x805040
  8028c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8028cd:	89 50 04             	mov    %edx,0x4(%eax)
  8028d0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028d5:	40                   	inc    %eax
  8028d6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028db:	e9 60 01 00 00       	jmp    802a40 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8028e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e3:	8b 50 08             	mov    0x8(%eax),%edx
  8028e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e9:	8b 40 08             	mov    0x8(%eax),%eax
  8028ec:	39 c2                	cmp    %eax,%edx
  8028ee:	0f 82 4c 01 00 00    	jb     802a40 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8028f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028f8:	75 14                	jne    80290e <insert_sorted_allocList+0x157>
  8028fa:	83 ec 04             	sub    $0x4,%esp
  8028fd:	68 58 47 80 00       	push   $0x804758
  802902:	6a 73                	push   $0x73
  802904:	68 07 47 80 00       	push   $0x804707
  802909:	e8 a7 e1 ff ff       	call   800ab5 <_panic>
  80290e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802914:	8b 45 08             	mov    0x8(%ebp),%eax
  802917:	89 50 04             	mov    %edx,0x4(%eax)
  80291a:	8b 45 08             	mov    0x8(%ebp),%eax
  80291d:	8b 40 04             	mov    0x4(%eax),%eax
  802920:	85 c0                	test   %eax,%eax
  802922:	74 0c                	je     802930 <insert_sorted_allocList+0x179>
  802924:	a1 44 50 80 00       	mov    0x805044,%eax
  802929:	8b 55 08             	mov    0x8(%ebp),%edx
  80292c:	89 10                	mov    %edx,(%eax)
  80292e:	eb 08                	jmp    802938 <insert_sorted_allocList+0x181>
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	a3 40 50 80 00       	mov    %eax,0x805040
  802938:	8b 45 08             	mov    0x8(%ebp),%eax
  80293b:	a3 44 50 80 00       	mov    %eax,0x805044
  802940:	8b 45 08             	mov    0x8(%ebp),%eax
  802943:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802949:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80294e:	40                   	inc    %eax
  80294f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802954:	e9 e7 00 00 00       	jmp    802a40 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80295f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802966:	a1 40 50 80 00       	mov    0x805040,%eax
  80296b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296e:	e9 9d 00 00 00       	jmp    802a10 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 00                	mov    (%eax),%eax
  802978:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	8b 50 08             	mov    0x8(%eax),%edx
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 40 08             	mov    0x8(%eax),%eax
  802987:	39 c2                	cmp    %eax,%edx
  802989:	76 7d                	jbe    802a08 <insert_sorted_allocList+0x251>
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	8b 50 08             	mov    0x8(%eax),%edx
  802991:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802994:	8b 40 08             	mov    0x8(%eax),%eax
  802997:	39 c2                	cmp    %eax,%edx
  802999:	73 6d                	jae    802a08 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80299b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299f:	74 06                	je     8029a7 <insert_sorted_allocList+0x1f0>
  8029a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029a5:	75 14                	jne    8029bb <insert_sorted_allocList+0x204>
  8029a7:	83 ec 04             	sub    $0x4,%esp
  8029aa:	68 7c 47 80 00       	push   $0x80477c
  8029af:	6a 7f                	push   $0x7f
  8029b1:	68 07 47 80 00       	push   $0x804707
  8029b6:	e8 fa e0 ff ff       	call   800ab5 <_panic>
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 10                	mov    (%eax),%edx
  8029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c3:	89 10                	mov    %edx,(%eax)
  8029c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c8:	8b 00                	mov    (%eax),%eax
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	74 0b                	je     8029d9 <insert_sorted_allocList+0x222>
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 00                	mov    (%eax),%eax
  8029d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d6:	89 50 04             	mov    %edx,0x4(%eax)
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8029df:	89 10                	mov    %edx,(%eax)
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ed:	8b 00                	mov    (%eax),%eax
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	75 08                	jne    8029fb <insert_sorted_allocList+0x244>
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	a3 44 50 80 00       	mov    %eax,0x805044
  8029fb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a00:	40                   	inc    %eax
  802a01:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a06:	eb 39                	jmp    802a41 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a08:	a1 48 50 80 00       	mov    0x805048,%eax
  802a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a14:	74 07                	je     802a1d <insert_sorted_allocList+0x266>
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	eb 05                	jmp    802a22 <insert_sorted_allocList+0x26b>
  802a1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a22:	a3 48 50 80 00       	mov    %eax,0x805048
  802a27:	a1 48 50 80 00       	mov    0x805048,%eax
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	0f 85 3f ff ff ff    	jne    802973 <insert_sorted_allocList+0x1bc>
  802a34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a38:	0f 85 35 ff ff ff    	jne    802973 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a3e:	eb 01                	jmp    802a41 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a40:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a41:	90                   	nop
  802a42:	c9                   	leave  
  802a43:	c3                   	ret    

00802a44 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a44:	55                   	push   %ebp
  802a45:	89 e5                	mov    %esp,%ebp
  802a47:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a4a:	a1 38 51 80 00       	mov    0x805138,%eax
  802a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a52:	e9 85 01 00 00       	jmp    802bdc <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a60:	0f 82 6e 01 00 00    	jb     802bd4 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a6f:	0f 85 8a 00 00 00    	jne    802aff <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802a75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a79:	75 17                	jne    802a92 <alloc_block_FF+0x4e>
  802a7b:	83 ec 04             	sub    $0x4,%esp
  802a7e:	68 b0 47 80 00       	push   $0x8047b0
  802a83:	68 93 00 00 00       	push   $0x93
  802a88:	68 07 47 80 00       	push   $0x804707
  802a8d:	e8 23 e0 ff ff       	call   800ab5 <_panic>
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	8b 00                	mov    (%eax),%eax
  802a97:	85 c0                	test   %eax,%eax
  802a99:	74 10                	je     802aab <alloc_block_FF+0x67>
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 00                	mov    (%eax),%eax
  802aa0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa3:	8b 52 04             	mov    0x4(%edx),%edx
  802aa6:	89 50 04             	mov    %edx,0x4(%eax)
  802aa9:	eb 0b                	jmp    802ab6 <alloc_block_FF+0x72>
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 40 04             	mov    0x4(%eax),%eax
  802ab1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	8b 40 04             	mov    0x4(%eax),%eax
  802abc:	85 c0                	test   %eax,%eax
  802abe:	74 0f                	je     802acf <alloc_block_FF+0x8b>
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 40 04             	mov    0x4(%eax),%eax
  802ac6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac9:	8b 12                	mov    (%edx),%edx
  802acb:	89 10                	mov    %edx,(%eax)
  802acd:	eb 0a                	jmp    802ad9 <alloc_block_FF+0x95>
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 00                	mov    (%eax),%eax
  802ad4:	a3 38 51 80 00       	mov    %eax,0x805138
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aec:	a1 44 51 80 00       	mov    0x805144,%eax
  802af1:	48                   	dec    %eax
  802af2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	e9 10 01 00 00       	jmp    802c0f <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 40 0c             	mov    0xc(%eax),%eax
  802b05:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b08:	0f 86 c6 00 00 00    	jbe    802bd4 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b0e:	a1 48 51 80 00       	mov    0x805148,%eax
  802b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	8b 50 08             	mov    0x8(%eax),%edx
  802b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1f:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b25:	8b 55 08             	mov    0x8(%ebp),%edx
  802b28:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b2f:	75 17                	jne    802b48 <alloc_block_FF+0x104>
  802b31:	83 ec 04             	sub    $0x4,%esp
  802b34:	68 b0 47 80 00       	push   $0x8047b0
  802b39:	68 9b 00 00 00       	push   $0x9b
  802b3e:	68 07 47 80 00       	push   $0x804707
  802b43:	e8 6d df ff ff       	call   800ab5 <_panic>
  802b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4b:	8b 00                	mov    (%eax),%eax
  802b4d:	85 c0                	test   %eax,%eax
  802b4f:	74 10                	je     802b61 <alloc_block_FF+0x11d>
  802b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b59:	8b 52 04             	mov    0x4(%edx),%edx
  802b5c:	89 50 04             	mov    %edx,0x4(%eax)
  802b5f:	eb 0b                	jmp    802b6c <alloc_block_FF+0x128>
  802b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b64:	8b 40 04             	mov    0x4(%eax),%eax
  802b67:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6f:	8b 40 04             	mov    0x4(%eax),%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	74 0f                	je     802b85 <alloc_block_FF+0x141>
  802b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b79:	8b 40 04             	mov    0x4(%eax),%eax
  802b7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7f:	8b 12                	mov    (%edx),%edx
  802b81:	89 10                	mov    %edx,(%eax)
  802b83:	eb 0a                	jmp    802b8f <alloc_block_FF+0x14b>
  802b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	a3 48 51 80 00       	mov    %eax,0x805148
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba2:	a1 54 51 80 00       	mov    0x805154,%eax
  802ba7:	48                   	dec    %eax
  802ba8:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	8b 50 08             	mov    0x8(%eax),%edx
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	01 c2                	add    %eax,%edx
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc4:	2b 45 08             	sub    0x8(%ebp),%eax
  802bc7:	89 c2                	mov    %eax,%edx
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd2:	eb 3b                	jmp    802c0f <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802bd4:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be0:	74 07                	je     802be9 <alloc_block_FF+0x1a5>
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 00                	mov    (%eax),%eax
  802be7:	eb 05                	jmp    802bee <alloc_block_FF+0x1aa>
  802be9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bee:	a3 40 51 80 00       	mov    %eax,0x805140
  802bf3:	a1 40 51 80 00       	mov    0x805140,%eax
  802bf8:	85 c0                	test   %eax,%eax
  802bfa:	0f 85 57 fe ff ff    	jne    802a57 <alloc_block_FF+0x13>
  802c00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c04:	0f 85 4d fe ff ff    	jne    802a57 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802c0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c0f:	c9                   	leave  
  802c10:	c3                   	ret    

00802c11 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c11:	55                   	push   %ebp
  802c12:	89 e5                	mov    %esp,%ebp
  802c14:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802c17:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c1e:	a1 38 51 80 00       	mov    0x805138,%eax
  802c23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c26:	e9 df 00 00 00       	jmp    802d0a <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c31:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c34:	0f 82 c8 00 00 00    	jb     802d02 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c40:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c43:	0f 85 8a 00 00 00    	jne    802cd3 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4d:	75 17                	jne    802c66 <alloc_block_BF+0x55>
  802c4f:	83 ec 04             	sub    $0x4,%esp
  802c52:	68 b0 47 80 00       	push   $0x8047b0
  802c57:	68 b7 00 00 00       	push   $0xb7
  802c5c:	68 07 47 80 00       	push   $0x804707
  802c61:	e8 4f de ff ff       	call   800ab5 <_panic>
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 00                	mov    (%eax),%eax
  802c6b:	85 c0                	test   %eax,%eax
  802c6d:	74 10                	je     802c7f <alloc_block_BF+0x6e>
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	8b 00                	mov    (%eax),%eax
  802c74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c77:	8b 52 04             	mov    0x4(%edx),%edx
  802c7a:	89 50 04             	mov    %edx,0x4(%eax)
  802c7d:	eb 0b                	jmp    802c8a <alloc_block_BF+0x79>
  802c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c82:	8b 40 04             	mov    0x4(%eax),%eax
  802c85:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 40 04             	mov    0x4(%eax),%eax
  802c90:	85 c0                	test   %eax,%eax
  802c92:	74 0f                	je     802ca3 <alloc_block_BF+0x92>
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 40 04             	mov    0x4(%eax),%eax
  802c9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c9d:	8b 12                	mov    (%edx),%edx
  802c9f:	89 10                	mov    %edx,(%eax)
  802ca1:	eb 0a                	jmp    802cad <alloc_block_BF+0x9c>
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 00                	mov    (%eax),%eax
  802ca8:	a3 38 51 80 00       	mov    %eax,0x805138
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc0:	a1 44 51 80 00       	mov    0x805144,%eax
  802cc5:	48                   	dec    %eax
  802cc6:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	e9 4d 01 00 00       	jmp    802e20 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cdc:	76 24                	jbe    802d02 <alloc_block_BF+0xf1>
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ce7:	73 19                	jae    802d02 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802ce9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 40 08             	mov    0x8(%eax),%eax
  802cff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802d02:	a1 40 51 80 00       	mov    0x805140,%eax
  802d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0e:	74 07                	je     802d17 <alloc_block_BF+0x106>
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 00                	mov    (%eax),%eax
  802d15:	eb 05                	jmp    802d1c <alloc_block_BF+0x10b>
  802d17:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1c:	a3 40 51 80 00       	mov    %eax,0x805140
  802d21:	a1 40 51 80 00       	mov    0x805140,%eax
  802d26:	85 c0                	test   %eax,%eax
  802d28:	0f 85 fd fe ff ff    	jne    802c2b <alloc_block_BF+0x1a>
  802d2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d32:	0f 85 f3 fe ff ff    	jne    802c2b <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802d38:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d3c:	0f 84 d9 00 00 00    	je     802e1b <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d42:	a1 48 51 80 00       	mov    0x805148,%eax
  802d47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d50:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802d53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d56:	8b 55 08             	mov    0x8(%ebp),%edx
  802d59:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802d5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d60:	75 17                	jne    802d79 <alloc_block_BF+0x168>
  802d62:	83 ec 04             	sub    $0x4,%esp
  802d65:	68 b0 47 80 00       	push   $0x8047b0
  802d6a:	68 c7 00 00 00       	push   $0xc7
  802d6f:	68 07 47 80 00       	push   $0x804707
  802d74:	e8 3c dd ff ff       	call   800ab5 <_panic>
  802d79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7c:	8b 00                	mov    (%eax),%eax
  802d7e:	85 c0                	test   %eax,%eax
  802d80:	74 10                	je     802d92 <alloc_block_BF+0x181>
  802d82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d85:	8b 00                	mov    (%eax),%eax
  802d87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d8a:	8b 52 04             	mov    0x4(%edx),%edx
  802d8d:	89 50 04             	mov    %edx,0x4(%eax)
  802d90:	eb 0b                	jmp    802d9d <alloc_block_BF+0x18c>
  802d92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d95:	8b 40 04             	mov    0x4(%eax),%eax
  802d98:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da0:	8b 40 04             	mov    0x4(%eax),%eax
  802da3:	85 c0                	test   %eax,%eax
  802da5:	74 0f                	je     802db6 <alloc_block_BF+0x1a5>
  802da7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802daa:	8b 40 04             	mov    0x4(%eax),%eax
  802dad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802db0:	8b 12                	mov    (%edx),%edx
  802db2:	89 10                	mov    %edx,(%eax)
  802db4:	eb 0a                	jmp    802dc0 <alloc_block_BF+0x1af>
  802db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	a3 48 51 80 00       	mov    %eax,0x805148
  802dc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd3:	a1 54 51 80 00       	mov    0x805154,%eax
  802dd8:	48                   	dec    %eax
  802dd9:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802dde:	83 ec 08             	sub    $0x8,%esp
  802de1:	ff 75 ec             	pushl  -0x14(%ebp)
  802de4:	68 38 51 80 00       	push   $0x805138
  802de9:	e8 71 f9 ff ff       	call   80275f <find_block>
  802dee:	83 c4 10             	add    $0x10,%esp
  802df1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802df4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df7:	8b 50 08             	mov    0x8(%eax),%edx
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	01 c2                	add    %eax,%edx
  802dff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e02:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802e05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e08:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0b:	2b 45 08             	sub    0x8(%ebp),%eax
  802e0e:	89 c2                	mov    %eax,%edx
  802e10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e13:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e19:	eb 05                	jmp    802e20 <alloc_block_BF+0x20f>
	}
	return NULL;
  802e1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e20:	c9                   	leave  
  802e21:	c3                   	ret    

00802e22 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e22:	55                   	push   %ebp
  802e23:	89 e5                	mov    %esp,%ebp
  802e25:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802e28:	a1 28 50 80 00       	mov    0x805028,%eax
  802e2d:	85 c0                	test   %eax,%eax
  802e2f:	0f 85 de 01 00 00    	jne    803013 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e35:	a1 38 51 80 00       	mov    0x805138,%eax
  802e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e3d:	e9 9e 01 00 00       	jmp    802fe0 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 40 0c             	mov    0xc(%eax),%eax
  802e48:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e4b:	0f 82 87 01 00 00    	jb     802fd8 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 40 0c             	mov    0xc(%eax),%eax
  802e57:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e5a:	0f 85 95 00 00 00    	jne    802ef5 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802e60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e64:	75 17                	jne    802e7d <alloc_block_NF+0x5b>
  802e66:	83 ec 04             	sub    $0x4,%esp
  802e69:	68 b0 47 80 00       	push   $0x8047b0
  802e6e:	68 e0 00 00 00       	push   $0xe0
  802e73:	68 07 47 80 00       	push   $0x804707
  802e78:	e8 38 dc ff ff       	call   800ab5 <_panic>
  802e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	85 c0                	test   %eax,%eax
  802e84:	74 10                	je     802e96 <alloc_block_NF+0x74>
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e8e:	8b 52 04             	mov    0x4(%edx),%edx
  802e91:	89 50 04             	mov    %edx,0x4(%eax)
  802e94:	eb 0b                	jmp    802ea1 <alloc_block_NF+0x7f>
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	8b 40 04             	mov    0x4(%eax),%eax
  802e9c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	8b 40 04             	mov    0x4(%eax),%eax
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	74 0f                	je     802eba <alloc_block_NF+0x98>
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	8b 40 04             	mov    0x4(%eax),%eax
  802eb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb4:	8b 12                	mov    (%edx),%edx
  802eb6:	89 10                	mov    %edx,(%eax)
  802eb8:	eb 0a                	jmp    802ec4 <alloc_block_NF+0xa2>
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	a3 38 51 80 00       	mov    %eax,0x805138
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed7:	a1 44 51 80 00       	mov    0x805144,%eax
  802edc:	48                   	dec    %eax
  802edd:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 40 08             	mov    0x8(%eax),%eax
  802ee8:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	e9 f8 04 00 00       	jmp    8033ed <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  802efb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802efe:	0f 86 d4 00 00 00    	jbe    802fd8 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f04:	a1 48 51 80 00       	mov    0x805148,%eax
  802f09:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	8b 50 08             	mov    0x8(%eax),%edx
  802f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f15:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1e:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f25:	75 17                	jne    802f3e <alloc_block_NF+0x11c>
  802f27:	83 ec 04             	sub    $0x4,%esp
  802f2a:	68 b0 47 80 00       	push   $0x8047b0
  802f2f:	68 e9 00 00 00       	push   $0xe9
  802f34:	68 07 47 80 00       	push   $0x804707
  802f39:	e8 77 db ff ff       	call   800ab5 <_panic>
  802f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 10                	je     802f57 <alloc_block_NF+0x135>
  802f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f4f:	8b 52 04             	mov    0x4(%edx),%edx
  802f52:	89 50 04             	mov    %edx,0x4(%eax)
  802f55:	eb 0b                	jmp    802f62 <alloc_block_NF+0x140>
  802f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5a:	8b 40 04             	mov    0x4(%eax),%eax
  802f5d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f65:	8b 40 04             	mov    0x4(%eax),%eax
  802f68:	85 c0                	test   %eax,%eax
  802f6a:	74 0f                	je     802f7b <alloc_block_NF+0x159>
  802f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6f:	8b 40 04             	mov    0x4(%eax),%eax
  802f72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f75:	8b 12                	mov    (%edx),%edx
  802f77:	89 10                	mov    %edx,(%eax)
  802f79:	eb 0a                	jmp    802f85 <alloc_block_NF+0x163>
  802f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7e:	8b 00                	mov    (%eax),%eax
  802f80:	a3 48 51 80 00       	mov    %eax,0x805148
  802f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f98:	a1 54 51 80 00       	mov    0x805154,%eax
  802f9d:	48                   	dec    %eax
  802f9e:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa6:	8b 40 08             	mov    0x8(%eax),%eax
  802fa9:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb1:	8b 50 08             	mov    0x8(%eax),%edx
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	01 c2                	add    %eax,%edx
  802fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbc:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc5:	2b 45 08             	sub    0x8(%ebp),%eax
  802fc8:	89 c2                	mov    %eax,%edx
  802fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcd:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd3:	e9 15 04 00 00       	jmp    8033ed <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802fd8:	a1 40 51 80 00       	mov    0x805140,%eax
  802fdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe4:	74 07                	je     802fed <alloc_block_NF+0x1cb>
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	8b 00                	mov    (%eax),%eax
  802feb:	eb 05                	jmp    802ff2 <alloc_block_NF+0x1d0>
  802fed:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff2:	a3 40 51 80 00       	mov    %eax,0x805140
  802ff7:	a1 40 51 80 00       	mov    0x805140,%eax
  802ffc:	85 c0                	test   %eax,%eax
  802ffe:	0f 85 3e fe ff ff    	jne    802e42 <alloc_block_NF+0x20>
  803004:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803008:	0f 85 34 fe ff ff    	jne    802e42 <alloc_block_NF+0x20>
  80300e:	e9 d5 03 00 00       	jmp    8033e8 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803013:	a1 38 51 80 00       	mov    0x805138,%eax
  803018:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80301b:	e9 b1 01 00 00       	jmp    8031d1 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803023:	8b 50 08             	mov    0x8(%eax),%edx
  803026:	a1 28 50 80 00       	mov    0x805028,%eax
  80302b:	39 c2                	cmp    %eax,%edx
  80302d:	0f 82 96 01 00 00    	jb     8031c9 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803036:	8b 40 0c             	mov    0xc(%eax),%eax
  803039:	3b 45 08             	cmp    0x8(%ebp),%eax
  80303c:	0f 82 87 01 00 00    	jb     8031c9 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	8b 40 0c             	mov    0xc(%eax),%eax
  803048:	3b 45 08             	cmp    0x8(%ebp),%eax
  80304b:	0f 85 95 00 00 00    	jne    8030e6 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803051:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803055:	75 17                	jne    80306e <alloc_block_NF+0x24c>
  803057:	83 ec 04             	sub    $0x4,%esp
  80305a:	68 b0 47 80 00       	push   $0x8047b0
  80305f:	68 fc 00 00 00       	push   $0xfc
  803064:	68 07 47 80 00       	push   $0x804707
  803069:	e8 47 da ff ff       	call   800ab5 <_panic>
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	8b 00                	mov    (%eax),%eax
  803073:	85 c0                	test   %eax,%eax
  803075:	74 10                	je     803087 <alloc_block_NF+0x265>
  803077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307a:	8b 00                	mov    (%eax),%eax
  80307c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80307f:	8b 52 04             	mov    0x4(%edx),%edx
  803082:	89 50 04             	mov    %edx,0x4(%eax)
  803085:	eb 0b                	jmp    803092 <alloc_block_NF+0x270>
  803087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308a:	8b 40 04             	mov    0x4(%eax),%eax
  80308d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	8b 40 04             	mov    0x4(%eax),%eax
  803098:	85 c0                	test   %eax,%eax
  80309a:	74 0f                	je     8030ab <alloc_block_NF+0x289>
  80309c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309f:	8b 40 04             	mov    0x4(%eax),%eax
  8030a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a5:	8b 12                	mov    (%edx),%edx
  8030a7:	89 10                	mov    %edx,(%eax)
  8030a9:	eb 0a                	jmp    8030b5 <alloc_block_NF+0x293>
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	8b 00                	mov    (%eax),%eax
  8030b0:	a3 38 51 80 00       	mov    %eax,0x805138
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c8:	a1 44 51 80 00       	mov    0x805144,%eax
  8030cd:	48                   	dec    %eax
  8030ce:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	8b 40 08             	mov    0x8(%eax),%eax
  8030d9:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	e9 07 03 00 00       	jmp    8033ed <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030ef:	0f 86 d4 00 00 00    	jbe    8031c9 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030f5:	a1 48 51 80 00       	mov    0x805148,%eax
  8030fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803100:	8b 50 08             	mov    0x8(%eax),%edx
  803103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803106:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803109:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310c:	8b 55 08             	mov    0x8(%ebp),%edx
  80310f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803112:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803116:	75 17                	jne    80312f <alloc_block_NF+0x30d>
  803118:	83 ec 04             	sub    $0x4,%esp
  80311b:	68 b0 47 80 00       	push   $0x8047b0
  803120:	68 04 01 00 00       	push   $0x104
  803125:	68 07 47 80 00       	push   $0x804707
  80312a:	e8 86 d9 ff ff       	call   800ab5 <_panic>
  80312f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803132:	8b 00                	mov    (%eax),%eax
  803134:	85 c0                	test   %eax,%eax
  803136:	74 10                	je     803148 <alloc_block_NF+0x326>
  803138:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313b:	8b 00                	mov    (%eax),%eax
  80313d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803140:	8b 52 04             	mov    0x4(%edx),%edx
  803143:	89 50 04             	mov    %edx,0x4(%eax)
  803146:	eb 0b                	jmp    803153 <alloc_block_NF+0x331>
  803148:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314b:	8b 40 04             	mov    0x4(%eax),%eax
  80314e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803153:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803156:	8b 40 04             	mov    0x4(%eax),%eax
  803159:	85 c0                	test   %eax,%eax
  80315b:	74 0f                	je     80316c <alloc_block_NF+0x34a>
  80315d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803160:	8b 40 04             	mov    0x4(%eax),%eax
  803163:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803166:	8b 12                	mov    (%edx),%edx
  803168:	89 10                	mov    %edx,(%eax)
  80316a:	eb 0a                	jmp    803176 <alloc_block_NF+0x354>
  80316c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316f:	8b 00                	mov    (%eax),%eax
  803171:	a3 48 51 80 00       	mov    %eax,0x805148
  803176:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803179:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80317f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803182:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803189:	a1 54 51 80 00       	mov    0x805154,%eax
  80318e:	48                   	dec    %eax
  80318f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803194:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803197:	8b 40 08             	mov    0x8(%eax),%eax
  80319a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80319f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a2:	8b 50 08             	mov    0x8(%eax),%edx
  8031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a8:	01 c2                	add    %eax,%edx
  8031aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ad:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8031b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b6:	2b 45 08             	sub    0x8(%ebp),%eax
  8031b9:	89 c2                	mov    %eax,%edx
  8031bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031be:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8031c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c4:	e9 24 02 00 00       	jmp    8033ed <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8031ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d5:	74 07                	je     8031de <alloc_block_NF+0x3bc>
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	8b 00                	mov    (%eax),%eax
  8031dc:	eb 05                	jmp    8031e3 <alloc_block_NF+0x3c1>
  8031de:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e3:	a3 40 51 80 00       	mov    %eax,0x805140
  8031e8:	a1 40 51 80 00       	mov    0x805140,%eax
  8031ed:	85 c0                	test   %eax,%eax
  8031ef:	0f 85 2b fe ff ff    	jne    803020 <alloc_block_NF+0x1fe>
  8031f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f9:	0f 85 21 fe ff ff    	jne    803020 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031ff:	a1 38 51 80 00       	mov    0x805138,%eax
  803204:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803207:	e9 ae 01 00 00       	jmp    8033ba <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80320c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320f:	8b 50 08             	mov    0x8(%eax),%edx
  803212:	a1 28 50 80 00       	mov    0x805028,%eax
  803217:	39 c2                	cmp    %eax,%edx
  803219:	0f 83 93 01 00 00    	jae    8033b2 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	8b 40 0c             	mov    0xc(%eax),%eax
  803225:	3b 45 08             	cmp    0x8(%ebp),%eax
  803228:	0f 82 84 01 00 00    	jb     8033b2 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80322e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803231:	8b 40 0c             	mov    0xc(%eax),%eax
  803234:	3b 45 08             	cmp    0x8(%ebp),%eax
  803237:	0f 85 95 00 00 00    	jne    8032d2 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80323d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803241:	75 17                	jne    80325a <alloc_block_NF+0x438>
  803243:	83 ec 04             	sub    $0x4,%esp
  803246:	68 b0 47 80 00       	push   $0x8047b0
  80324b:	68 14 01 00 00       	push   $0x114
  803250:	68 07 47 80 00       	push   $0x804707
  803255:	e8 5b d8 ff ff       	call   800ab5 <_panic>
  80325a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325d:	8b 00                	mov    (%eax),%eax
  80325f:	85 c0                	test   %eax,%eax
  803261:	74 10                	je     803273 <alloc_block_NF+0x451>
  803263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803266:	8b 00                	mov    (%eax),%eax
  803268:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80326b:	8b 52 04             	mov    0x4(%edx),%edx
  80326e:	89 50 04             	mov    %edx,0x4(%eax)
  803271:	eb 0b                	jmp    80327e <alloc_block_NF+0x45c>
  803273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803276:	8b 40 04             	mov    0x4(%eax),%eax
  803279:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	8b 40 04             	mov    0x4(%eax),%eax
  803284:	85 c0                	test   %eax,%eax
  803286:	74 0f                	je     803297 <alloc_block_NF+0x475>
  803288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328b:	8b 40 04             	mov    0x4(%eax),%eax
  80328e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803291:	8b 12                	mov    (%edx),%edx
  803293:	89 10                	mov    %edx,(%eax)
  803295:	eb 0a                	jmp    8032a1 <alloc_block_NF+0x47f>
  803297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329a:	8b 00                	mov    (%eax),%eax
  80329c:	a3 38 51 80 00       	mov    %eax,0x805138
  8032a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b4:	a1 44 51 80 00       	mov    0x805144,%eax
  8032b9:	48                   	dec    %eax
  8032ba:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c2:	8b 40 08             	mov    0x8(%eax),%eax
  8032c5:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8032ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cd:	e9 1b 01 00 00       	jmp    8033ed <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032db:	0f 86 d1 00 00 00    	jbe    8033b2 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8032e1:	a1 48 51 80 00       	mov    0x805148,%eax
  8032e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8032e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ec:	8b 50 08             	mov    0x8(%eax),%edx
  8032ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8032f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032fb:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803302:	75 17                	jne    80331b <alloc_block_NF+0x4f9>
  803304:	83 ec 04             	sub    $0x4,%esp
  803307:	68 b0 47 80 00       	push   $0x8047b0
  80330c:	68 1c 01 00 00       	push   $0x11c
  803311:	68 07 47 80 00       	push   $0x804707
  803316:	e8 9a d7 ff ff       	call   800ab5 <_panic>
  80331b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331e:	8b 00                	mov    (%eax),%eax
  803320:	85 c0                	test   %eax,%eax
  803322:	74 10                	je     803334 <alloc_block_NF+0x512>
  803324:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803327:	8b 00                	mov    (%eax),%eax
  803329:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80332c:	8b 52 04             	mov    0x4(%edx),%edx
  80332f:	89 50 04             	mov    %edx,0x4(%eax)
  803332:	eb 0b                	jmp    80333f <alloc_block_NF+0x51d>
  803334:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803337:	8b 40 04             	mov    0x4(%eax),%eax
  80333a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80333f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803342:	8b 40 04             	mov    0x4(%eax),%eax
  803345:	85 c0                	test   %eax,%eax
  803347:	74 0f                	je     803358 <alloc_block_NF+0x536>
  803349:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334c:	8b 40 04             	mov    0x4(%eax),%eax
  80334f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803352:	8b 12                	mov    (%edx),%edx
  803354:	89 10                	mov    %edx,(%eax)
  803356:	eb 0a                	jmp    803362 <alloc_block_NF+0x540>
  803358:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80335b:	8b 00                	mov    (%eax),%eax
  80335d:	a3 48 51 80 00       	mov    %eax,0x805148
  803362:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803365:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80336b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803375:	a1 54 51 80 00       	mov    0x805154,%eax
  80337a:	48                   	dec    %eax
  80337b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803380:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803383:	8b 40 08             	mov    0x8(%eax),%eax
  803386:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80338b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338e:	8b 50 08             	mov    0x8(%eax),%edx
  803391:	8b 45 08             	mov    0x8(%ebp),%eax
  803394:	01 c2                	add    %eax,%edx
  803396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803399:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80339c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339f:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a2:	2b 45 08             	sub    0x8(%ebp),%eax
  8033a5:	89 c2                	mov    %eax,%edx
  8033a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033aa:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b0:	eb 3b                	jmp    8033ed <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033b2:	a1 40 51 80 00       	mov    0x805140,%eax
  8033b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033be:	74 07                	je     8033c7 <alloc_block_NF+0x5a5>
  8033c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	eb 05                	jmp    8033cc <alloc_block_NF+0x5aa>
  8033c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8033cc:	a3 40 51 80 00       	mov    %eax,0x805140
  8033d1:	a1 40 51 80 00       	mov    0x805140,%eax
  8033d6:	85 c0                	test   %eax,%eax
  8033d8:	0f 85 2e fe ff ff    	jne    80320c <alloc_block_NF+0x3ea>
  8033de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e2:	0f 85 24 fe ff ff    	jne    80320c <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8033e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033ed:	c9                   	leave  
  8033ee:	c3                   	ret    

008033ef <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8033ef:	55                   	push   %ebp
  8033f0:	89 e5                	mov    %esp,%ebp
  8033f2:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8033f5:	a1 38 51 80 00       	mov    0x805138,%eax
  8033fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8033fd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803402:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803405:	a1 38 51 80 00       	mov    0x805138,%eax
  80340a:	85 c0                	test   %eax,%eax
  80340c:	74 14                	je     803422 <insert_sorted_with_merge_freeList+0x33>
  80340e:	8b 45 08             	mov    0x8(%ebp),%eax
  803411:	8b 50 08             	mov    0x8(%eax),%edx
  803414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803417:	8b 40 08             	mov    0x8(%eax),%eax
  80341a:	39 c2                	cmp    %eax,%edx
  80341c:	0f 87 9b 01 00 00    	ja     8035bd <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803422:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803426:	75 17                	jne    80343f <insert_sorted_with_merge_freeList+0x50>
  803428:	83 ec 04             	sub    $0x4,%esp
  80342b:	68 e4 46 80 00       	push   $0x8046e4
  803430:	68 38 01 00 00       	push   $0x138
  803435:	68 07 47 80 00       	push   $0x804707
  80343a:	e8 76 d6 ff ff       	call   800ab5 <_panic>
  80343f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803445:	8b 45 08             	mov    0x8(%ebp),%eax
  803448:	89 10                	mov    %edx,(%eax)
  80344a:	8b 45 08             	mov    0x8(%ebp),%eax
  80344d:	8b 00                	mov    (%eax),%eax
  80344f:	85 c0                	test   %eax,%eax
  803451:	74 0d                	je     803460 <insert_sorted_with_merge_freeList+0x71>
  803453:	a1 38 51 80 00       	mov    0x805138,%eax
  803458:	8b 55 08             	mov    0x8(%ebp),%edx
  80345b:	89 50 04             	mov    %edx,0x4(%eax)
  80345e:	eb 08                	jmp    803468 <insert_sorted_with_merge_freeList+0x79>
  803460:	8b 45 08             	mov    0x8(%ebp),%eax
  803463:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803468:	8b 45 08             	mov    0x8(%ebp),%eax
  80346b:	a3 38 51 80 00       	mov    %eax,0x805138
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80347a:	a1 44 51 80 00       	mov    0x805144,%eax
  80347f:	40                   	inc    %eax
  803480:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803485:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803489:	0f 84 a8 06 00 00    	je     803b37 <insert_sorted_with_merge_freeList+0x748>
  80348f:	8b 45 08             	mov    0x8(%ebp),%eax
  803492:	8b 50 08             	mov    0x8(%eax),%edx
  803495:	8b 45 08             	mov    0x8(%ebp),%eax
  803498:	8b 40 0c             	mov    0xc(%eax),%eax
  80349b:	01 c2                	add    %eax,%edx
  80349d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a0:	8b 40 08             	mov    0x8(%eax),%eax
  8034a3:	39 c2                	cmp    %eax,%edx
  8034a5:	0f 85 8c 06 00 00    	jne    803b37 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8034ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ae:	8b 50 0c             	mov    0xc(%eax),%edx
  8034b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b7:	01 c2                	add    %eax,%edx
  8034b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bc:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8034bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034c3:	75 17                	jne    8034dc <insert_sorted_with_merge_freeList+0xed>
  8034c5:	83 ec 04             	sub    $0x4,%esp
  8034c8:	68 b0 47 80 00       	push   $0x8047b0
  8034cd:	68 3c 01 00 00       	push   $0x13c
  8034d2:	68 07 47 80 00       	push   $0x804707
  8034d7:	e8 d9 d5 ff ff       	call   800ab5 <_panic>
  8034dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034df:	8b 00                	mov    (%eax),%eax
  8034e1:	85 c0                	test   %eax,%eax
  8034e3:	74 10                	je     8034f5 <insert_sorted_with_merge_freeList+0x106>
  8034e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e8:	8b 00                	mov    (%eax),%eax
  8034ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ed:	8b 52 04             	mov    0x4(%edx),%edx
  8034f0:	89 50 04             	mov    %edx,0x4(%eax)
  8034f3:	eb 0b                	jmp    803500 <insert_sorted_with_merge_freeList+0x111>
  8034f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f8:	8b 40 04             	mov    0x4(%eax),%eax
  8034fb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803503:	8b 40 04             	mov    0x4(%eax),%eax
  803506:	85 c0                	test   %eax,%eax
  803508:	74 0f                	je     803519 <insert_sorted_with_merge_freeList+0x12a>
  80350a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350d:	8b 40 04             	mov    0x4(%eax),%eax
  803510:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803513:	8b 12                	mov    (%edx),%edx
  803515:	89 10                	mov    %edx,(%eax)
  803517:	eb 0a                	jmp    803523 <insert_sorted_with_merge_freeList+0x134>
  803519:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80351c:	8b 00                	mov    (%eax),%eax
  80351e:	a3 38 51 80 00       	mov    %eax,0x805138
  803523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803526:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80352c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803536:	a1 44 51 80 00       	mov    0x805144,%eax
  80353b:	48                   	dec    %eax
  80353c:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803544:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80354b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80354e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803555:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803559:	75 17                	jne    803572 <insert_sorted_with_merge_freeList+0x183>
  80355b:	83 ec 04             	sub    $0x4,%esp
  80355e:	68 e4 46 80 00       	push   $0x8046e4
  803563:	68 3f 01 00 00       	push   $0x13f
  803568:	68 07 47 80 00       	push   $0x804707
  80356d:	e8 43 d5 ff ff       	call   800ab5 <_panic>
  803572:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357b:	89 10                	mov    %edx,(%eax)
  80357d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803580:	8b 00                	mov    (%eax),%eax
  803582:	85 c0                	test   %eax,%eax
  803584:	74 0d                	je     803593 <insert_sorted_with_merge_freeList+0x1a4>
  803586:	a1 48 51 80 00       	mov    0x805148,%eax
  80358b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80358e:	89 50 04             	mov    %edx,0x4(%eax)
  803591:	eb 08                	jmp    80359b <insert_sorted_with_merge_freeList+0x1ac>
  803593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803596:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80359b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80359e:	a3 48 51 80 00       	mov    %eax,0x805148
  8035a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ad:	a1 54 51 80 00       	mov    0x805154,%eax
  8035b2:	40                   	inc    %eax
  8035b3:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035b8:	e9 7a 05 00 00       	jmp    803b37 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	8b 50 08             	mov    0x8(%eax),%edx
  8035c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c6:	8b 40 08             	mov    0x8(%eax),%eax
  8035c9:	39 c2                	cmp    %eax,%edx
  8035cb:	0f 82 14 01 00 00    	jb     8036e5 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8035d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d4:	8b 50 08             	mov    0x8(%eax),%edx
  8035d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035da:	8b 40 0c             	mov    0xc(%eax),%eax
  8035dd:	01 c2                	add    %eax,%edx
  8035df:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e2:	8b 40 08             	mov    0x8(%eax),%eax
  8035e5:	39 c2                	cmp    %eax,%edx
  8035e7:	0f 85 90 00 00 00    	jne    80367d <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8035ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8035f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f9:	01 c2                	add    %eax,%edx
  8035fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fe:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803601:	8b 45 08             	mov    0x8(%ebp),%eax
  803604:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80360b:	8b 45 08             	mov    0x8(%ebp),%eax
  80360e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803615:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803619:	75 17                	jne    803632 <insert_sorted_with_merge_freeList+0x243>
  80361b:	83 ec 04             	sub    $0x4,%esp
  80361e:	68 e4 46 80 00       	push   $0x8046e4
  803623:	68 49 01 00 00       	push   $0x149
  803628:	68 07 47 80 00       	push   $0x804707
  80362d:	e8 83 d4 ff ff       	call   800ab5 <_panic>
  803632:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803638:	8b 45 08             	mov    0x8(%ebp),%eax
  80363b:	89 10                	mov    %edx,(%eax)
  80363d:	8b 45 08             	mov    0x8(%ebp),%eax
  803640:	8b 00                	mov    (%eax),%eax
  803642:	85 c0                	test   %eax,%eax
  803644:	74 0d                	je     803653 <insert_sorted_with_merge_freeList+0x264>
  803646:	a1 48 51 80 00       	mov    0x805148,%eax
  80364b:	8b 55 08             	mov    0x8(%ebp),%edx
  80364e:	89 50 04             	mov    %edx,0x4(%eax)
  803651:	eb 08                	jmp    80365b <insert_sorted_with_merge_freeList+0x26c>
  803653:	8b 45 08             	mov    0x8(%ebp),%eax
  803656:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80365b:	8b 45 08             	mov    0x8(%ebp),%eax
  80365e:	a3 48 51 80 00       	mov    %eax,0x805148
  803663:	8b 45 08             	mov    0x8(%ebp),%eax
  803666:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80366d:	a1 54 51 80 00       	mov    0x805154,%eax
  803672:	40                   	inc    %eax
  803673:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803678:	e9 bb 04 00 00       	jmp    803b38 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80367d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803681:	75 17                	jne    80369a <insert_sorted_with_merge_freeList+0x2ab>
  803683:	83 ec 04             	sub    $0x4,%esp
  803686:	68 58 47 80 00       	push   $0x804758
  80368b:	68 4c 01 00 00       	push   $0x14c
  803690:	68 07 47 80 00       	push   $0x804707
  803695:	e8 1b d4 ff ff       	call   800ab5 <_panic>
  80369a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a3:	89 50 04             	mov    %edx,0x4(%eax)
  8036a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a9:	8b 40 04             	mov    0x4(%eax),%eax
  8036ac:	85 c0                	test   %eax,%eax
  8036ae:	74 0c                	je     8036bc <insert_sorted_with_merge_freeList+0x2cd>
  8036b0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8036b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8036b8:	89 10                	mov    %edx,(%eax)
  8036ba:	eb 08                	jmp    8036c4 <insert_sorted_with_merge_freeList+0x2d5>
  8036bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bf:	a3 38 51 80 00       	mov    %eax,0x805138
  8036c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036d5:	a1 44 51 80 00       	mov    0x805144,%eax
  8036da:	40                   	inc    %eax
  8036db:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036e0:	e9 53 04 00 00       	jmp    803b38 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036e5:	a1 38 51 80 00       	mov    0x805138,%eax
  8036ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036ed:	e9 15 04 00 00       	jmp    803b07 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f5:	8b 00                	mov    (%eax),%eax
  8036f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8036fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fd:	8b 50 08             	mov    0x8(%eax),%edx
  803700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803703:	8b 40 08             	mov    0x8(%eax),%eax
  803706:	39 c2                	cmp    %eax,%edx
  803708:	0f 86 f1 03 00 00    	jbe    803aff <insert_sorted_with_merge_freeList+0x710>
  80370e:	8b 45 08             	mov    0x8(%ebp),%eax
  803711:	8b 50 08             	mov    0x8(%eax),%edx
  803714:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803717:	8b 40 08             	mov    0x8(%eax),%eax
  80371a:	39 c2                	cmp    %eax,%edx
  80371c:	0f 83 dd 03 00 00    	jae    803aff <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803725:	8b 50 08             	mov    0x8(%eax),%edx
  803728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372b:	8b 40 0c             	mov    0xc(%eax),%eax
  80372e:	01 c2                	add    %eax,%edx
  803730:	8b 45 08             	mov    0x8(%ebp),%eax
  803733:	8b 40 08             	mov    0x8(%eax),%eax
  803736:	39 c2                	cmp    %eax,%edx
  803738:	0f 85 b9 01 00 00    	jne    8038f7 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80373e:	8b 45 08             	mov    0x8(%ebp),%eax
  803741:	8b 50 08             	mov    0x8(%eax),%edx
  803744:	8b 45 08             	mov    0x8(%ebp),%eax
  803747:	8b 40 0c             	mov    0xc(%eax),%eax
  80374a:	01 c2                	add    %eax,%edx
  80374c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374f:	8b 40 08             	mov    0x8(%eax),%eax
  803752:	39 c2                	cmp    %eax,%edx
  803754:	0f 85 0d 01 00 00    	jne    803867 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80375a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375d:	8b 50 0c             	mov    0xc(%eax),%edx
  803760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803763:	8b 40 0c             	mov    0xc(%eax),%eax
  803766:	01 c2                	add    %eax,%edx
  803768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376b:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80376e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803772:	75 17                	jne    80378b <insert_sorted_with_merge_freeList+0x39c>
  803774:	83 ec 04             	sub    $0x4,%esp
  803777:	68 b0 47 80 00       	push   $0x8047b0
  80377c:	68 5c 01 00 00       	push   $0x15c
  803781:	68 07 47 80 00       	push   $0x804707
  803786:	e8 2a d3 ff ff       	call   800ab5 <_panic>
  80378b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378e:	8b 00                	mov    (%eax),%eax
  803790:	85 c0                	test   %eax,%eax
  803792:	74 10                	je     8037a4 <insert_sorted_with_merge_freeList+0x3b5>
  803794:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803797:	8b 00                	mov    (%eax),%eax
  803799:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80379c:	8b 52 04             	mov    0x4(%edx),%edx
  80379f:	89 50 04             	mov    %edx,0x4(%eax)
  8037a2:	eb 0b                	jmp    8037af <insert_sorted_with_merge_freeList+0x3c0>
  8037a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a7:	8b 40 04             	mov    0x4(%eax),%eax
  8037aa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b2:	8b 40 04             	mov    0x4(%eax),%eax
  8037b5:	85 c0                	test   %eax,%eax
  8037b7:	74 0f                	je     8037c8 <insert_sorted_with_merge_freeList+0x3d9>
  8037b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037bc:	8b 40 04             	mov    0x4(%eax),%eax
  8037bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037c2:	8b 12                	mov    (%edx),%edx
  8037c4:	89 10                	mov    %edx,(%eax)
  8037c6:	eb 0a                	jmp    8037d2 <insert_sorted_with_merge_freeList+0x3e3>
  8037c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037cb:	8b 00                	mov    (%eax),%eax
  8037cd:	a3 38 51 80 00       	mov    %eax,0x805138
  8037d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037e5:	a1 44 51 80 00       	mov    0x805144,%eax
  8037ea:	48                   	dec    %eax
  8037eb:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8037f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8037fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803804:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803808:	75 17                	jne    803821 <insert_sorted_with_merge_freeList+0x432>
  80380a:	83 ec 04             	sub    $0x4,%esp
  80380d:	68 e4 46 80 00       	push   $0x8046e4
  803812:	68 5f 01 00 00       	push   $0x15f
  803817:	68 07 47 80 00       	push   $0x804707
  80381c:	e8 94 d2 ff ff       	call   800ab5 <_panic>
  803821:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803827:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382a:	89 10                	mov    %edx,(%eax)
  80382c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80382f:	8b 00                	mov    (%eax),%eax
  803831:	85 c0                	test   %eax,%eax
  803833:	74 0d                	je     803842 <insert_sorted_with_merge_freeList+0x453>
  803835:	a1 48 51 80 00       	mov    0x805148,%eax
  80383a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80383d:	89 50 04             	mov    %edx,0x4(%eax)
  803840:	eb 08                	jmp    80384a <insert_sorted_with_merge_freeList+0x45b>
  803842:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803845:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80384a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384d:	a3 48 51 80 00       	mov    %eax,0x805148
  803852:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803855:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80385c:	a1 54 51 80 00       	mov    0x805154,%eax
  803861:	40                   	inc    %eax
  803862:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386a:	8b 50 0c             	mov    0xc(%eax),%edx
  80386d:	8b 45 08             	mov    0x8(%ebp),%eax
  803870:	8b 40 0c             	mov    0xc(%eax),%eax
  803873:	01 c2                	add    %eax,%edx
  803875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803878:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80387b:	8b 45 08             	mov    0x8(%ebp),%eax
  80387e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803885:	8b 45 08             	mov    0x8(%ebp),%eax
  803888:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80388f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803893:	75 17                	jne    8038ac <insert_sorted_with_merge_freeList+0x4bd>
  803895:	83 ec 04             	sub    $0x4,%esp
  803898:	68 e4 46 80 00       	push   $0x8046e4
  80389d:	68 64 01 00 00       	push   $0x164
  8038a2:	68 07 47 80 00       	push   $0x804707
  8038a7:	e8 09 d2 ff ff       	call   800ab5 <_panic>
  8038ac:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b5:	89 10                	mov    %edx,(%eax)
  8038b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ba:	8b 00                	mov    (%eax),%eax
  8038bc:	85 c0                	test   %eax,%eax
  8038be:	74 0d                	je     8038cd <insert_sorted_with_merge_freeList+0x4de>
  8038c0:	a1 48 51 80 00       	mov    0x805148,%eax
  8038c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8038c8:	89 50 04             	mov    %edx,0x4(%eax)
  8038cb:	eb 08                	jmp    8038d5 <insert_sorted_with_merge_freeList+0x4e6>
  8038cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d8:	a3 48 51 80 00       	mov    %eax,0x805148
  8038dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038e7:	a1 54 51 80 00       	mov    0x805154,%eax
  8038ec:	40                   	inc    %eax
  8038ed:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8038f2:	e9 41 02 00 00       	jmp    803b38 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8038f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fa:	8b 50 08             	mov    0x8(%eax),%edx
  8038fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803900:	8b 40 0c             	mov    0xc(%eax),%eax
  803903:	01 c2                	add    %eax,%edx
  803905:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803908:	8b 40 08             	mov    0x8(%eax),%eax
  80390b:	39 c2                	cmp    %eax,%edx
  80390d:	0f 85 7c 01 00 00    	jne    803a8f <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803913:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803917:	74 06                	je     80391f <insert_sorted_with_merge_freeList+0x530>
  803919:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80391d:	75 17                	jne    803936 <insert_sorted_with_merge_freeList+0x547>
  80391f:	83 ec 04             	sub    $0x4,%esp
  803922:	68 20 47 80 00       	push   $0x804720
  803927:	68 69 01 00 00       	push   $0x169
  80392c:	68 07 47 80 00       	push   $0x804707
  803931:	e8 7f d1 ff ff       	call   800ab5 <_panic>
  803936:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803939:	8b 50 04             	mov    0x4(%eax),%edx
  80393c:	8b 45 08             	mov    0x8(%ebp),%eax
  80393f:	89 50 04             	mov    %edx,0x4(%eax)
  803942:	8b 45 08             	mov    0x8(%ebp),%eax
  803945:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803948:	89 10                	mov    %edx,(%eax)
  80394a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80394d:	8b 40 04             	mov    0x4(%eax),%eax
  803950:	85 c0                	test   %eax,%eax
  803952:	74 0d                	je     803961 <insert_sorted_with_merge_freeList+0x572>
  803954:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803957:	8b 40 04             	mov    0x4(%eax),%eax
  80395a:	8b 55 08             	mov    0x8(%ebp),%edx
  80395d:	89 10                	mov    %edx,(%eax)
  80395f:	eb 08                	jmp    803969 <insert_sorted_with_merge_freeList+0x57a>
  803961:	8b 45 08             	mov    0x8(%ebp),%eax
  803964:	a3 38 51 80 00       	mov    %eax,0x805138
  803969:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396c:	8b 55 08             	mov    0x8(%ebp),%edx
  80396f:	89 50 04             	mov    %edx,0x4(%eax)
  803972:	a1 44 51 80 00       	mov    0x805144,%eax
  803977:	40                   	inc    %eax
  803978:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80397d:	8b 45 08             	mov    0x8(%ebp),%eax
  803980:	8b 50 0c             	mov    0xc(%eax),%edx
  803983:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803986:	8b 40 0c             	mov    0xc(%eax),%eax
  803989:	01 c2                	add    %eax,%edx
  80398b:	8b 45 08             	mov    0x8(%ebp),%eax
  80398e:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803991:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803995:	75 17                	jne    8039ae <insert_sorted_with_merge_freeList+0x5bf>
  803997:	83 ec 04             	sub    $0x4,%esp
  80399a:	68 b0 47 80 00       	push   $0x8047b0
  80399f:	68 6b 01 00 00       	push   $0x16b
  8039a4:	68 07 47 80 00       	push   $0x804707
  8039a9:	e8 07 d1 ff ff       	call   800ab5 <_panic>
  8039ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b1:	8b 00                	mov    (%eax),%eax
  8039b3:	85 c0                	test   %eax,%eax
  8039b5:	74 10                	je     8039c7 <insert_sorted_with_merge_freeList+0x5d8>
  8039b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ba:	8b 00                	mov    (%eax),%eax
  8039bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039bf:	8b 52 04             	mov    0x4(%edx),%edx
  8039c2:	89 50 04             	mov    %edx,0x4(%eax)
  8039c5:	eb 0b                	jmp    8039d2 <insert_sorted_with_merge_freeList+0x5e3>
  8039c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ca:	8b 40 04             	mov    0x4(%eax),%eax
  8039cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d5:	8b 40 04             	mov    0x4(%eax),%eax
  8039d8:	85 c0                	test   %eax,%eax
  8039da:	74 0f                	je     8039eb <insert_sorted_with_merge_freeList+0x5fc>
  8039dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039df:	8b 40 04             	mov    0x4(%eax),%eax
  8039e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039e5:	8b 12                	mov    (%edx),%edx
  8039e7:	89 10                	mov    %edx,(%eax)
  8039e9:	eb 0a                	jmp    8039f5 <insert_sorted_with_merge_freeList+0x606>
  8039eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ee:	8b 00                	mov    (%eax),%eax
  8039f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8039f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a08:	a1 44 51 80 00       	mov    0x805144,%eax
  803a0d:	48                   	dec    %eax
  803a0e:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803a1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a20:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a27:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a2b:	75 17                	jne    803a44 <insert_sorted_with_merge_freeList+0x655>
  803a2d:	83 ec 04             	sub    $0x4,%esp
  803a30:	68 e4 46 80 00       	push   $0x8046e4
  803a35:	68 6e 01 00 00       	push   $0x16e
  803a3a:	68 07 47 80 00       	push   $0x804707
  803a3f:	e8 71 d0 ff ff       	call   800ab5 <_panic>
  803a44:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a4d:	89 10                	mov    %edx,(%eax)
  803a4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a52:	8b 00                	mov    (%eax),%eax
  803a54:	85 c0                	test   %eax,%eax
  803a56:	74 0d                	je     803a65 <insert_sorted_with_merge_freeList+0x676>
  803a58:	a1 48 51 80 00       	mov    0x805148,%eax
  803a5d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a60:	89 50 04             	mov    %edx,0x4(%eax)
  803a63:	eb 08                	jmp    803a6d <insert_sorted_with_merge_freeList+0x67e>
  803a65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a68:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a70:	a3 48 51 80 00       	mov    %eax,0x805148
  803a75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a7f:	a1 54 51 80 00       	mov    0x805154,%eax
  803a84:	40                   	inc    %eax
  803a85:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a8a:	e9 a9 00 00 00       	jmp    803b38 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803a8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a93:	74 06                	je     803a9b <insert_sorted_with_merge_freeList+0x6ac>
  803a95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a99:	75 17                	jne    803ab2 <insert_sorted_with_merge_freeList+0x6c3>
  803a9b:	83 ec 04             	sub    $0x4,%esp
  803a9e:	68 7c 47 80 00       	push   $0x80477c
  803aa3:	68 73 01 00 00       	push   $0x173
  803aa8:	68 07 47 80 00       	push   $0x804707
  803aad:	e8 03 d0 ff ff       	call   800ab5 <_panic>
  803ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab5:	8b 10                	mov    (%eax),%edx
  803ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aba:	89 10                	mov    %edx,(%eax)
  803abc:	8b 45 08             	mov    0x8(%ebp),%eax
  803abf:	8b 00                	mov    (%eax),%eax
  803ac1:	85 c0                	test   %eax,%eax
  803ac3:	74 0b                	je     803ad0 <insert_sorted_with_merge_freeList+0x6e1>
  803ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac8:	8b 00                	mov    (%eax),%eax
  803aca:	8b 55 08             	mov    0x8(%ebp),%edx
  803acd:	89 50 04             	mov    %edx,0x4(%eax)
  803ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad3:	8b 55 08             	mov    0x8(%ebp),%edx
  803ad6:	89 10                	mov    %edx,(%eax)
  803ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  803adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ade:	89 50 04             	mov    %edx,0x4(%eax)
  803ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae4:	8b 00                	mov    (%eax),%eax
  803ae6:	85 c0                	test   %eax,%eax
  803ae8:	75 08                	jne    803af2 <insert_sorted_with_merge_freeList+0x703>
  803aea:	8b 45 08             	mov    0x8(%ebp),%eax
  803aed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803af2:	a1 44 51 80 00       	mov    0x805144,%eax
  803af7:	40                   	inc    %eax
  803af8:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803afd:	eb 39                	jmp    803b38 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803aff:	a1 40 51 80 00       	mov    0x805140,%eax
  803b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b0b:	74 07                	je     803b14 <insert_sorted_with_merge_freeList+0x725>
  803b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b10:	8b 00                	mov    (%eax),%eax
  803b12:	eb 05                	jmp    803b19 <insert_sorted_with_merge_freeList+0x72a>
  803b14:	b8 00 00 00 00       	mov    $0x0,%eax
  803b19:	a3 40 51 80 00       	mov    %eax,0x805140
  803b1e:	a1 40 51 80 00       	mov    0x805140,%eax
  803b23:	85 c0                	test   %eax,%eax
  803b25:	0f 85 c7 fb ff ff    	jne    8036f2 <insert_sorted_with_merge_freeList+0x303>
  803b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b2f:	0f 85 bd fb ff ff    	jne    8036f2 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b35:	eb 01                	jmp    803b38 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803b37:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b38:	90                   	nop
  803b39:	c9                   	leave  
  803b3a:	c3                   	ret    
  803b3b:	90                   	nop

00803b3c <__udivdi3>:
  803b3c:	55                   	push   %ebp
  803b3d:	57                   	push   %edi
  803b3e:	56                   	push   %esi
  803b3f:	53                   	push   %ebx
  803b40:	83 ec 1c             	sub    $0x1c,%esp
  803b43:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b47:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b4f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b53:	89 ca                	mov    %ecx,%edx
  803b55:	89 f8                	mov    %edi,%eax
  803b57:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b5b:	85 f6                	test   %esi,%esi
  803b5d:	75 2d                	jne    803b8c <__udivdi3+0x50>
  803b5f:	39 cf                	cmp    %ecx,%edi
  803b61:	77 65                	ja     803bc8 <__udivdi3+0x8c>
  803b63:	89 fd                	mov    %edi,%ebp
  803b65:	85 ff                	test   %edi,%edi
  803b67:	75 0b                	jne    803b74 <__udivdi3+0x38>
  803b69:	b8 01 00 00 00       	mov    $0x1,%eax
  803b6e:	31 d2                	xor    %edx,%edx
  803b70:	f7 f7                	div    %edi
  803b72:	89 c5                	mov    %eax,%ebp
  803b74:	31 d2                	xor    %edx,%edx
  803b76:	89 c8                	mov    %ecx,%eax
  803b78:	f7 f5                	div    %ebp
  803b7a:	89 c1                	mov    %eax,%ecx
  803b7c:	89 d8                	mov    %ebx,%eax
  803b7e:	f7 f5                	div    %ebp
  803b80:	89 cf                	mov    %ecx,%edi
  803b82:	89 fa                	mov    %edi,%edx
  803b84:	83 c4 1c             	add    $0x1c,%esp
  803b87:	5b                   	pop    %ebx
  803b88:	5e                   	pop    %esi
  803b89:	5f                   	pop    %edi
  803b8a:	5d                   	pop    %ebp
  803b8b:	c3                   	ret    
  803b8c:	39 ce                	cmp    %ecx,%esi
  803b8e:	77 28                	ja     803bb8 <__udivdi3+0x7c>
  803b90:	0f bd fe             	bsr    %esi,%edi
  803b93:	83 f7 1f             	xor    $0x1f,%edi
  803b96:	75 40                	jne    803bd8 <__udivdi3+0x9c>
  803b98:	39 ce                	cmp    %ecx,%esi
  803b9a:	72 0a                	jb     803ba6 <__udivdi3+0x6a>
  803b9c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ba0:	0f 87 9e 00 00 00    	ja     803c44 <__udivdi3+0x108>
  803ba6:	b8 01 00 00 00       	mov    $0x1,%eax
  803bab:	89 fa                	mov    %edi,%edx
  803bad:	83 c4 1c             	add    $0x1c,%esp
  803bb0:	5b                   	pop    %ebx
  803bb1:	5e                   	pop    %esi
  803bb2:	5f                   	pop    %edi
  803bb3:	5d                   	pop    %ebp
  803bb4:	c3                   	ret    
  803bb5:	8d 76 00             	lea    0x0(%esi),%esi
  803bb8:	31 ff                	xor    %edi,%edi
  803bba:	31 c0                	xor    %eax,%eax
  803bbc:	89 fa                	mov    %edi,%edx
  803bbe:	83 c4 1c             	add    $0x1c,%esp
  803bc1:	5b                   	pop    %ebx
  803bc2:	5e                   	pop    %esi
  803bc3:	5f                   	pop    %edi
  803bc4:	5d                   	pop    %ebp
  803bc5:	c3                   	ret    
  803bc6:	66 90                	xchg   %ax,%ax
  803bc8:	89 d8                	mov    %ebx,%eax
  803bca:	f7 f7                	div    %edi
  803bcc:	31 ff                	xor    %edi,%edi
  803bce:	89 fa                	mov    %edi,%edx
  803bd0:	83 c4 1c             	add    $0x1c,%esp
  803bd3:	5b                   	pop    %ebx
  803bd4:	5e                   	pop    %esi
  803bd5:	5f                   	pop    %edi
  803bd6:	5d                   	pop    %ebp
  803bd7:	c3                   	ret    
  803bd8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bdd:	89 eb                	mov    %ebp,%ebx
  803bdf:	29 fb                	sub    %edi,%ebx
  803be1:	89 f9                	mov    %edi,%ecx
  803be3:	d3 e6                	shl    %cl,%esi
  803be5:	89 c5                	mov    %eax,%ebp
  803be7:	88 d9                	mov    %bl,%cl
  803be9:	d3 ed                	shr    %cl,%ebp
  803beb:	89 e9                	mov    %ebp,%ecx
  803bed:	09 f1                	or     %esi,%ecx
  803bef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bf3:	89 f9                	mov    %edi,%ecx
  803bf5:	d3 e0                	shl    %cl,%eax
  803bf7:	89 c5                	mov    %eax,%ebp
  803bf9:	89 d6                	mov    %edx,%esi
  803bfb:	88 d9                	mov    %bl,%cl
  803bfd:	d3 ee                	shr    %cl,%esi
  803bff:	89 f9                	mov    %edi,%ecx
  803c01:	d3 e2                	shl    %cl,%edx
  803c03:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c07:	88 d9                	mov    %bl,%cl
  803c09:	d3 e8                	shr    %cl,%eax
  803c0b:	09 c2                	or     %eax,%edx
  803c0d:	89 d0                	mov    %edx,%eax
  803c0f:	89 f2                	mov    %esi,%edx
  803c11:	f7 74 24 0c          	divl   0xc(%esp)
  803c15:	89 d6                	mov    %edx,%esi
  803c17:	89 c3                	mov    %eax,%ebx
  803c19:	f7 e5                	mul    %ebp
  803c1b:	39 d6                	cmp    %edx,%esi
  803c1d:	72 19                	jb     803c38 <__udivdi3+0xfc>
  803c1f:	74 0b                	je     803c2c <__udivdi3+0xf0>
  803c21:	89 d8                	mov    %ebx,%eax
  803c23:	31 ff                	xor    %edi,%edi
  803c25:	e9 58 ff ff ff       	jmp    803b82 <__udivdi3+0x46>
  803c2a:	66 90                	xchg   %ax,%ax
  803c2c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c30:	89 f9                	mov    %edi,%ecx
  803c32:	d3 e2                	shl    %cl,%edx
  803c34:	39 c2                	cmp    %eax,%edx
  803c36:	73 e9                	jae    803c21 <__udivdi3+0xe5>
  803c38:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c3b:	31 ff                	xor    %edi,%edi
  803c3d:	e9 40 ff ff ff       	jmp    803b82 <__udivdi3+0x46>
  803c42:	66 90                	xchg   %ax,%ax
  803c44:	31 c0                	xor    %eax,%eax
  803c46:	e9 37 ff ff ff       	jmp    803b82 <__udivdi3+0x46>
  803c4b:	90                   	nop

00803c4c <__umoddi3>:
  803c4c:	55                   	push   %ebp
  803c4d:	57                   	push   %edi
  803c4e:	56                   	push   %esi
  803c4f:	53                   	push   %ebx
  803c50:	83 ec 1c             	sub    $0x1c,%esp
  803c53:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c57:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c5f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c6b:	89 f3                	mov    %esi,%ebx
  803c6d:	89 fa                	mov    %edi,%edx
  803c6f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c73:	89 34 24             	mov    %esi,(%esp)
  803c76:	85 c0                	test   %eax,%eax
  803c78:	75 1a                	jne    803c94 <__umoddi3+0x48>
  803c7a:	39 f7                	cmp    %esi,%edi
  803c7c:	0f 86 a2 00 00 00    	jbe    803d24 <__umoddi3+0xd8>
  803c82:	89 c8                	mov    %ecx,%eax
  803c84:	89 f2                	mov    %esi,%edx
  803c86:	f7 f7                	div    %edi
  803c88:	89 d0                	mov    %edx,%eax
  803c8a:	31 d2                	xor    %edx,%edx
  803c8c:	83 c4 1c             	add    $0x1c,%esp
  803c8f:	5b                   	pop    %ebx
  803c90:	5e                   	pop    %esi
  803c91:	5f                   	pop    %edi
  803c92:	5d                   	pop    %ebp
  803c93:	c3                   	ret    
  803c94:	39 f0                	cmp    %esi,%eax
  803c96:	0f 87 ac 00 00 00    	ja     803d48 <__umoddi3+0xfc>
  803c9c:	0f bd e8             	bsr    %eax,%ebp
  803c9f:	83 f5 1f             	xor    $0x1f,%ebp
  803ca2:	0f 84 ac 00 00 00    	je     803d54 <__umoddi3+0x108>
  803ca8:	bf 20 00 00 00       	mov    $0x20,%edi
  803cad:	29 ef                	sub    %ebp,%edi
  803caf:	89 fe                	mov    %edi,%esi
  803cb1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cb5:	89 e9                	mov    %ebp,%ecx
  803cb7:	d3 e0                	shl    %cl,%eax
  803cb9:	89 d7                	mov    %edx,%edi
  803cbb:	89 f1                	mov    %esi,%ecx
  803cbd:	d3 ef                	shr    %cl,%edi
  803cbf:	09 c7                	or     %eax,%edi
  803cc1:	89 e9                	mov    %ebp,%ecx
  803cc3:	d3 e2                	shl    %cl,%edx
  803cc5:	89 14 24             	mov    %edx,(%esp)
  803cc8:	89 d8                	mov    %ebx,%eax
  803cca:	d3 e0                	shl    %cl,%eax
  803ccc:	89 c2                	mov    %eax,%edx
  803cce:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cd2:	d3 e0                	shl    %cl,%eax
  803cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cd8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cdc:	89 f1                	mov    %esi,%ecx
  803cde:	d3 e8                	shr    %cl,%eax
  803ce0:	09 d0                	or     %edx,%eax
  803ce2:	d3 eb                	shr    %cl,%ebx
  803ce4:	89 da                	mov    %ebx,%edx
  803ce6:	f7 f7                	div    %edi
  803ce8:	89 d3                	mov    %edx,%ebx
  803cea:	f7 24 24             	mull   (%esp)
  803ced:	89 c6                	mov    %eax,%esi
  803cef:	89 d1                	mov    %edx,%ecx
  803cf1:	39 d3                	cmp    %edx,%ebx
  803cf3:	0f 82 87 00 00 00    	jb     803d80 <__umoddi3+0x134>
  803cf9:	0f 84 91 00 00 00    	je     803d90 <__umoddi3+0x144>
  803cff:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d03:	29 f2                	sub    %esi,%edx
  803d05:	19 cb                	sbb    %ecx,%ebx
  803d07:	89 d8                	mov    %ebx,%eax
  803d09:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d0d:	d3 e0                	shl    %cl,%eax
  803d0f:	89 e9                	mov    %ebp,%ecx
  803d11:	d3 ea                	shr    %cl,%edx
  803d13:	09 d0                	or     %edx,%eax
  803d15:	89 e9                	mov    %ebp,%ecx
  803d17:	d3 eb                	shr    %cl,%ebx
  803d19:	89 da                	mov    %ebx,%edx
  803d1b:	83 c4 1c             	add    $0x1c,%esp
  803d1e:	5b                   	pop    %ebx
  803d1f:	5e                   	pop    %esi
  803d20:	5f                   	pop    %edi
  803d21:	5d                   	pop    %ebp
  803d22:	c3                   	ret    
  803d23:	90                   	nop
  803d24:	89 fd                	mov    %edi,%ebp
  803d26:	85 ff                	test   %edi,%edi
  803d28:	75 0b                	jne    803d35 <__umoddi3+0xe9>
  803d2a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d2f:	31 d2                	xor    %edx,%edx
  803d31:	f7 f7                	div    %edi
  803d33:	89 c5                	mov    %eax,%ebp
  803d35:	89 f0                	mov    %esi,%eax
  803d37:	31 d2                	xor    %edx,%edx
  803d39:	f7 f5                	div    %ebp
  803d3b:	89 c8                	mov    %ecx,%eax
  803d3d:	f7 f5                	div    %ebp
  803d3f:	89 d0                	mov    %edx,%eax
  803d41:	e9 44 ff ff ff       	jmp    803c8a <__umoddi3+0x3e>
  803d46:	66 90                	xchg   %ax,%ax
  803d48:	89 c8                	mov    %ecx,%eax
  803d4a:	89 f2                	mov    %esi,%edx
  803d4c:	83 c4 1c             	add    $0x1c,%esp
  803d4f:	5b                   	pop    %ebx
  803d50:	5e                   	pop    %esi
  803d51:	5f                   	pop    %edi
  803d52:	5d                   	pop    %ebp
  803d53:	c3                   	ret    
  803d54:	3b 04 24             	cmp    (%esp),%eax
  803d57:	72 06                	jb     803d5f <__umoddi3+0x113>
  803d59:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d5d:	77 0f                	ja     803d6e <__umoddi3+0x122>
  803d5f:	89 f2                	mov    %esi,%edx
  803d61:	29 f9                	sub    %edi,%ecx
  803d63:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d67:	89 14 24             	mov    %edx,(%esp)
  803d6a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d6e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d72:	8b 14 24             	mov    (%esp),%edx
  803d75:	83 c4 1c             	add    $0x1c,%esp
  803d78:	5b                   	pop    %ebx
  803d79:	5e                   	pop    %esi
  803d7a:	5f                   	pop    %edi
  803d7b:	5d                   	pop    %ebp
  803d7c:	c3                   	ret    
  803d7d:	8d 76 00             	lea    0x0(%esi),%esi
  803d80:	2b 04 24             	sub    (%esp),%eax
  803d83:	19 fa                	sbb    %edi,%edx
  803d85:	89 d1                	mov    %edx,%ecx
  803d87:	89 c6                	mov    %eax,%esi
  803d89:	e9 71 ff ff ff       	jmp    803cff <__umoddi3+0xb3>
  803d8e:	66 90                	xchg   %ax,%ax
  803d90:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d94:	72 ea                	jb     803d80 <__umoddi3+0x134>
  803d96:	89 d9                	mov    %ebx,%ecx
  803d98:	e9 62 ff ff ff       	jmp    803cff <__umoddi3+0xb3>
