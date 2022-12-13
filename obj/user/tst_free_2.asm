
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
  800090:	68 e0 3d 80 00       	push   $0x803de0
  800095:	6a 14                	push   $0x14
  800097:	68 fc 3d 80 00       	push   $0x803dfc
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
  8000b3:	e8 7e 22 00 00       	call   802336 <sys_bypassPageFault>
  8000b8:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000bb:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  8000c9:	e8 d0 1e 00 00       	call   801f9e <sys_calculate_free_frames>
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
  8000f6:	e8 a3 1e 00 00       	call   801f9e <sys_calculate_free_frames>
  8000fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 3b 1f 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
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
  800127:	68 10 3e 80 00       	push   $0x803e10
  80012c:	6a 2d                	push   $0x2d
  80012e:	68 fc 3d 80 00       	push   $0x803dfc
  800133:	e8 7d 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 01 1f 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 78 3e 80 00       	push   $0x803e78
  80014a:	6a 2e                	push   $0x2e
  80014c:	68 fc 3d 80 00       	push   $0x803dfc
  800151:	e8 5f 09 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  800156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80015e:	48                   	dec    %eax
  80015f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800165:	e8 34 1e 00 00       	call   801f9e <sys_calculate_free_frames>
  80016a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80016d:	e8 cc 1e 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
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
  8001a2:	68 10 3e 80 00       	push   $0x803e10
  8001a7:	6a 35                	push   $0x35
  8001a9:	68 fc 3d 80 00       	push   $0x803dfc
  8001ae:	e8 02 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001b3:	e8 86 1e 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  8001b8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001bb:	74 14                	je     8001d1 <_main+0x199>
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	68 78 3e 80 00       	push   $0x803e78
  8001c5:	6a 36                	push   $0x36
  8001c7:	68 fc 3d 80 00       	push   $0x803dfc
  8001cc:	e8 e4 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001d9:	48                   	dec    %eax
  8001da:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001e0:	e8 b9 1d 00 00       	call   801f9e <sys_calculate_free_frames>
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001e8:	e8 51 1e 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
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
  80021b:	68 10 3e 80 00       	push   $0x803e10
  800220:	6a 3d                	push   $0x3d
  800222:	68 fc 3d 80 00       	push   $0x803dfc
  800227:	e8 89 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80022c:	e8 0d 1e 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  800231:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 78 3e 80 00       	push   $0x803e78
  80023e:	6a 3e                	push   $0x3e
  800240:	68 fc 3d 80 00       	push   $0x803dfc
  800245:	e8 6b 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  80024a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024d:	01 c0                	add    %eax,%eax
  80024f:	48                   	dec    %eax
  800250:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800256:	e8 43 1d 00 00       	call   801f9e <sys_calculate_free_frames>
  80025b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025e:	e8 db 1d 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
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
  80029b:	68 10 3e 80 00       	push   $0x803e10
  8002a0:	6a 45                	push   $0x45
  8002a2:	68 fc 3d 80 00       	push   $0x803dfc
  8002a7:	e8 09 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002ac:	e8 8d 1d 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  8002b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002b4:	74 14                	je     8002ca <_main+0x292>
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	68 78 3e 80 00       	push   $0x803e78
  8002be:	6a 46                	push   $0x46
  8002c0:	68 fc 3d 80 00       	push   $0x803dfc
  8002c5:	e8 eb 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  8002ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002cd:	01 c0                	add    %eax,%eax
  8002cf:	48                   	dec    %eax
  8002d0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002d6:	e8 c3 1c 00 00       	call   801f9e <sys_calculate_free_frames>
  8002db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002de:	e8 5b 1d 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
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
  800323:	68 10 3e 80 00       	push   $0x803e10
  800328:	6a 4d                	push   $0x4d
  80032a:	68 fc 3d 80 00       	push   $0x803dfc
  80032f:	e8 81 07 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800334:	e8 05 1d 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  800339:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 78 3e 80 00       	push   $0x803e78
  800346:	6a 4e                	push   $0x4e
  800348:	68 fc 3d 80 00       	push   $0x803dfc
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
  800366:	e8 33 1c 00 00       	call   801f9e <sys_calculate_free_frames>
  80036b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80036e:	e8 cb 1c 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
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
  8003b2:	68 10 3e 80 00       	push   $0x803e10
  8003b7:	6a 55                	push   $0x55
  8003b9:	68 fc 3d 80 00       	push   $0x803dfc
  8003be:	e8 f2 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003c3:	e8 76 1c 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  8003c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003cb:	74 14                	je     8003e1 <_main+0x3a9>
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 78 3e 80 00       	push   $0x803e78
  8003d5:	6a 56                	push   $0x56
  8003d7:	68 fc 3d 80 00       	push   $0x803dfc
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
  8003f4:	e8 a5 1b 00 00       	call   801f9e <sys_calculate_free_frames>
  8003f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003fc:	e8 3d 1c 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
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
  800443:	68 10 3e 80 00       	push   $0x803e10
  800448:	6a 5d                	push   $0x5d
  80044a:	68 fc 3d 80 00       	push   $0x803dfc
  80044f:	e8 61 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800454:	e8 e5 1b 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  800459:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80045c:	74 14                	je     800472 <_main+0x43a>
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 78 3e 80 00       	push   $0x803e78
  800466:	6a 5e                	push   $0x5e
  800468:	68 fc 3d 80 00       	push   $0x803dfc
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
  800481:	e8 18 1b 00 00       	call   801f9e <sys_calculate_free_frames>
  800486:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800489:	e8 b0 1b 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  80048e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800491:	8b 45 80             	mov    -0x80(%ebp),%eax
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	50                   	push   %eax
  800498:	e8 82 18 00 00       	call   801d1f <free>
  80049d:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8004a0:	e8 99 1b 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  8004a5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 a8 3e 80 00       	push   $0x803ea8
  8004b2:	6a 6b                	push   $0x6b
  8004b4:	68 fc 3d 80 00       	push   $0x803dfc
  8004b9:	e8 f7 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004be:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004ca:	e8 4e 1e 00 00       	call   80231d <sys_rcr2>
  8004cf:	89 c2                	mov    %eax,%edx
  8004d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d4:	39 c2                	cmp    %eax,%edx
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 e4 3e 80 00       	push   $0x803ee4
  8004e0:	6a 6f                	push   $0x6f
  8004e2:	68 fc 3d 80 00       	push   $0x803dfc
  8004e7:	e8 c9 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[0]] = 10;
  8004ec:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004f2:	89 c2                	mov    %eax,%edx
  8004f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f7:	01 d0                	add    %edx,%eax
  8004f9:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004fc:	e8 1c 1e 00 00       	call   80231d <sys_rcr2>
  800501:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  800507:	89 d1                	mov    %edx,%ecx
  800509:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050c:	01 ca                	add    %ecx,%edx
  80050e:	39 d0                	cmp    %edx,%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 e4 3e 80 00       	push   $0x803ee4
  80051a:	6a 71                	push   $0x71
  80051c:	68 fc 3d 80 00       	push   $0x803dfc
  800521:	e8 8f 05 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800526:	e8 73 1a 00 00       	call   801f9e <sys_calculate_free_frames>
  80052b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80052e:	e8 0b 1b 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  800533:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800536:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 dd 17 00 00       	call   801d1f <free>
  800542:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800545:	e8 f4 1a 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  80054a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80054d:	74 14                	je     800563 <_main+0x52b>
  80054f:	83 ec 04             	sub    $0x4,%esp
  800552:	68 a8 3e 80 00       	push   $0x803ea8
  800557:	6a 76                	push   $0x76
  800559:	68 fc 3d 80 00       	push   $0x803dfc
  80055e:	e8 52 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  800563:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800566:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800569:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056c:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80056f:	e8 a9 1d 00 00       	call   80231d <sys_rcr2>
  800574:	89 c2                	mov    %eax,%edx
  800576:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	74 14                	je     800591 <_main+0x559>
  80057d:	83 ec 04             	sub    $0x4,%esp
  800580:	68 e4 3e 80 00       	push   $0x803ee4
  800585:	6a 7a                	push   $0x7a
  800587:	68 fc 3d 80 00       	push   $0x803dfc
  80058c:	e8 24 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[1]] = 10;
  800591:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800597:	89 c2                	mov    %eax,%edx
  800599:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005a1:	e8 77 1d 00 00       	call   80231d <sys_rcr2>
  8005a6:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  8005ac:	89 d1                	mov    %edx,%ecx
  8005ae:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005b1:	01 ca                	add    %ecx,%edx
  8005b3:	39 d0                	cmp    %edx,%eax
  8005b5:	74 14                	je     8005cb <_main+0x593>
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	68 e4 3e 80 00       	push   $0x803ee4
  8005bf:	6a 7c                	push   $0x7c
  8005c1:	68 fc 3d 80 00       	push   $0x803dfc
  8005c6:	e8 ea 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005cb:	e8 ce 19 00 00       	call   801f9e <sys_calculate_free_frames>
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005d3:	e8 66 1a 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  8005d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  8005db:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005de:	83 ec 0c             	sub    $0xc,%esp
  8005e1:	50                   	push   %eax
  8005e2:	e8 38 17 00 00       	call   801d1f <free>
  8005e7:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005ea:	e8 4f 1a 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  8005ef:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005f2:	74 17                	je     80060b <_main+0x5d3>
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 a8 3e 80 00       	push   $0x803ea8
  8005fc:	68 81 00 00 00       	push   $0x81
  800601:	68 fc 3d 80 00       	push   $0x803dfc
  800606:	e8 aa 04 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  80060b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800611:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800614:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800617:	e8 01 1d 00 00       	call   80231d <sys_rcr2>
  80061c:	89 c2                	mov    %eax,%edx
  80061e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800621:	39 c2                	cmp    %eax,%edx
  800623:	74 17                	je     80063c <_main+0x604>
  800625:	83 ec 04             	sub    $0x4,%esp
  800628:	68 e4 3e 80 00       	push   $0x803ee4
  80062d:	68 85 00 00 00       	push   $0x85
  800632:	68 fc 3d 80 00       	push   $0x803dfc
  800637:	e8 79 04 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[2]] = 10;
  80063c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800642:	89 c2                	mov    %eax,%edx
  800644:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800647:	01 d0                	add    %edx,%eax
  800649:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80064c:	e8 cc 1c 00 00       	call   80231d <sys_rcr2>
  800651:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  800657:	89 d1                	mov    %edx,%ecx
  800659:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065c:	01 ca                	add    %ecx,%edx
  80065e:	39 d0                	cmp    %edx,%eax
  800660:	74 17                	je     800679 <_main+0x641>
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 e4 3e 80 00       	push   $0x803ee4
  80066a:	68 87 00 00 00       	push   $0x87
  80066f:	68 fc 3d 80 00       	push   $0x803dfc
  800674:	e8 3c 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800679:	e8 20 19 00 00       	call   801f9e <sys_calculate_free_frames>
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800681:	e8 b8 19 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  800686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800689:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	50                   	push   %eax
  800690:	e8 8a 16 00 00       	call   801d1f <free>
  800695:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800698:	e8 a1 19 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 a8 3e 80 00       	push   $0x803ea8
  8006aa:	68 8c 00 00 00       	push   $0x8c
  8006af:	68 fc 3d 80 00       	push   $0x803dfc
  8006b4:	e8 fc 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  8006b9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8006bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c2:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006c5:	e8 53 1c 00 00       	call   80231d <sys_rcr2>
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006cf:	39 c2                	cmp    %eax,%edx
  8006d1:	74 17                	je     8006ea <_main+0x6b2>
  8006d3:	83 ec 04             	sub    $0x4,%esp
  8006d6:	68 e4 3e 80 00       	push   $0x803ee4
  8006db:	68 90 00 00 00       	push   $0x90
  8006e0:	68 fc 3d 80 00       	push   $0x803dfc
  8006e5:	e8 cb 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[3]] = 10;
  8006ea:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006fa:	e8 1e 1c 00 00       	call   80231d <sys_rcr2>
  8006ff:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800705:	89 d1                	mov    %edx,%ecx
  800707:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80070a:	01 ca                	add    %ecx,%edx
  80070c:	39 d0                	cmp    %edx,%eax
  80070e:	74 17                	je     800727 <_main+0x6ef>
  800710:	83 ec 04             	sub    $0x4,%esp
  800713:	68 e4 3e 80 00       	push   $0x803ee4
  800718:	68 92 00 00 00       	push   $0x92
  80071d:	68 fc 3d 80 00       	push   $0x803dfc
  800722:	e8 8e 03 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800727:	e8 72 18 00 00       	call   801f9e <sys_calculate_free_frames>
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80072f:	e8 0a 19 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  800734:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  800737:	8b 45 90             	mov    -0x70(%ebp),%eax
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	50                   	push   %eax
  80073e:	e8 dc 15 00 00       	call   801d1f <free>
  800743:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800746:	e8 f3 18 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  80074b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80074e:	74 17                	je     800767 <_main+0x72f>
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	68 a8 3e 80 00       	push   $0x803ea8
  800758:	68 97 00 00 00       	push   $0x97
  80075d:	68 fc 3d 80 00       	push   $0x803dfc
  800762:	e8 4e 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  800767:	8b 45 90             	mov    -0x70(%ebp),%eax
  80076a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80076d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800770:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800773:	e8 a5 1b 00 00       	call   80231d <sys_rcr2>
  800778:	89 c2                	mov    %eax,%edx
  80077a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	74 17                	je     800798 <_main+0x760>
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	68 e4 3e 80 00       	push   $0x803ee4
  800789:	68 9b 00 00 00       	push   $0x9b
  80078e:	68 fc 3d 80 00       	push   $0x803dfc
  800793:	e8 1d 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[4]] = 10;
  800798:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80079e:	89 c2                	mov    %eax,%edx
  8007a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a3:	01 d0                	add    %edx,%eax
  8007a5:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007a8:	e8 70 1b 00 00       	call   80231d <sys_rcr2>
  8007ad:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  8007b3:	89 d1                	mov    %edx,%ecx
  8007b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007b8:	01 ca                	add    %ecx,%edx
  8007ba:	39 d0                	cmp    %edx,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 e4 3e 80 00       	push   $0x803ee4
  8007c6:	68 9d 00 00 00       	push   $0x9d
  8007cb:	68 fc 3d 80 00       	push   $0x803dfc
  8007d0:	e8 e0 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8007d5:	e8 c4 17 00 00       	call   801f9e <sys_calculate_free_frames>
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007dd:	e8 5c 18 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  8007e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  8007e5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	50                   	push   %eax
  8007ec:	e8 2e 15 00 00       	call   801d1f <free>
  8007f1:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  8007f4:	e8 45 18 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  8007f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8007fc:	74 17                	je     800815 <_main+0x7dd>
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	68 a8 3e 80 00       	push   $0x803ea8
  800806:	68 a2 00 00 00       	push   $0xa2
  80080b:	68 fc 3d 80 00       	push   $0x803dfc
  800810:	e8 a0 02 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  800815:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800818:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80081b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80081e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800821:	e8 f7 1a 00 00       	call   80231d <sys_rcr2>
  800826:	89 c2                	mov    %eax,%edx
  800828:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80082b:	39 c2                	cmp    %eax,%edx
  80082d:	74 17                	je     800846 <_main+0x80e>
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 e4 3e 80 00       	push   $0x803ee4
  800837:	68 a6 00 00 00       	push   $0xa6
  80083c:	68 fc 3d 80 00       	push   $0x803dfc
  800841:	e8 6f 02 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[5]] = 10;
  800846:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800856:	e8 c2 1a 00 00       	call   80231d <sys_rcr2>
  80085b:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  800861:	89 d1                	mov    %edx,%ecx
  800863:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800866:	01 ca                	add    %ecx,%edx
  800868:	39 d0                	cmp    %edx,%eax
  80086a:	74 17                	je     800883 <_main+0x84b>
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	68 e4 3e 80 00       	push   $0x803ee4
  800874:	68 a8 00 00 00       	push   $0xa8
  800879:	68 fc 3d 80 00       	push   $0x803dfc
  80087e:	e8 32 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800883:	e8 16 17 00 00       	call   801f9e <sys_calculate_free_frames>
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80088b:	e8 ae 17 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  800890:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  800893:	8b 45 98             	mov    -0x68(%ebp),%eax
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	50                   	push   %eax
  80089a:	e8 80 14 00 00       	call   801d1f <free>
  80089f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8008a2:	e8 97 17 00 00       	call   80203e <sys_pf_calculate_allocated_pages>
  8008a7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8008aa:	74 17                	je     8008c3 <_main+0x88b>
  8008ac:	83 ec 04             	sub    $0x4,%esp
  8008af:	68 a8 3e 80 00       	push   $0x803ea8
  8008b4:	68 ad 00 00 00       	push   $0xad
  8008b9:	68 fc 3d 80 00       	push   $0x803dfc
  8008be:	e8 f2 01 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  8008c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8008c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008cc:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8008cf:	e8 49 1a 00 00       	call   80231d <sys_rcr2>
  8008d4:	89 c2                	mov    %eax,%edx
  8008d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008d9:	39 c2                	cmp    %eax,%edx
  8008db:	74 17                	je     8008f4 <_main+0x8bc>
  8008dd:	83 ec 04             	sub    $0x4,%esp
  8008e0:	68 e4 3e 80 00       	push   $0x803ee4
  8008e5:	68 b1 00 00 00       	push   $0xb1
  8008ea:	68 fc 3d 80 00       	push   $0x803dfc
  8008ef:	e8 c1 01 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[6]] = 10;
  8008f4:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8008fa:	89 c2                	mov    %eax,%edx
  8008fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008ff:	01 d0                	add    %edx,%eax
  800901:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800904:	e8 14 1a 00 00       	call   80231d <sys_rcr2>
  800909:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  80090f:	89 d1                	mov    %edx,%ecx
  800911:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800914:	01 ca                	add    %ecx,%edx
  800916:	39 d0                	cmp    %edx,%eax
  800918:	74 17                	je     800931 <_main+0x8f9>
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	68 e4 3e 80 00       	push   $0x803ee4
  800922:	68 b3 00 00 00       	push   $0xb3
  800927:	68 fc 3d 80 00       	push   $0x803dfc
  80092c:	e8 84 01 00 00       	call   800ab5 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames()) ) {panic("Wrong free: not all pages removed correctly at end");}
  800931:	e8 68 16 00 00       	call   801f9e <sys_calculate_free_frames>
  800936:	89 c2                	mov    %eax,%edx
  800938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80093b:	39 c2                	cmp    %eax,%edx
  80093d:	74 17                	je     800956 <_main+0x91e>
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	68 28 3f 80 00       	push   $0x803f28
  800947:	68 b5 00 00 00       	push   $0xb5
  80094c:	68 fc 3d 80 00       	push   $0x803dfc
  800951:	e8 5f 01 00 00       	call   800ab5 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  800956:	83 ec 0c             	sub    $0xc,%esp
  800959:	6a 00                	push   $0x0
  80095b:	e8 d6 19 00 00       	call   802336 <sys_bypassPageFault>
  800960:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  800963:	83 ec 0c             	sub    $0xc,%esp
  800966:	68 5c 3f 80 00       	push   $0x803f5c
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
  80097f:	e8 fa 18 00 00       	call   80227e <sys_getenvindex>
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
  8009ea:	e8 9c 16 00 00       	call   80208b <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009ef:	83 ec 0c             	sub    $0xc,%esp
  8009f2:	68 b0 3f 80 00       	push   $0x803fb0
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
  800a1a:	68 d8 3f 80 00       	push   $0x803fd8
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
  800a4b:	68 00 40 80 00       	push   $0x804000
  800a50:	e8 14 03 00 00       	call   800d69 <cprintf>
  800a55:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a58:	a1 20 50 80 00       	mov    0x805020,%eax
  800a5d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	50                   	push   %eax
  800a67:	68 58 40 80 00       	push   $0x804058
  800a6c:	e8 f8 02 00 00       	call   800d69 <cprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	68 b0 3f 80 00       	push   $0x803fb0
  800a7c:	e8 e8 02 00 00       	call   800d69 <cprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a84:	e8 1c 16 00 00       	call   8020a5 <sys_enable_interrupt>

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
  800a9c:	e8 a9 17 00 00       	call   80224a <sys_destroy_env>
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
  800aad:	e8 fe 17 00 00       	call   8022b0 <sys_exit_env>
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
  800ad6:	68 6c 40 80 00       	push   $0x80406c
  800adb:	e8 89 02 00 00       	call   800d69 <cprintf>
  800ae0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ae3:	a1 00 50 80 00       	mov    0x805000,%eax
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	50                   	push   %eax
  800aef:	68 71 40 80 00       	push   $0x804071
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
  800b13:	68 8d 40 80 00       	push   $0x80408d
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
  800b3f:	68 90 40 80 00       	push   $0x804090
  800b44:	6a 26                	push   $0x26
  800b46:	68 dc 40 80 00       	push   $0x8040dc
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
  800c11:	68 e8 40 80 00       	push   $0x8040e8
  800c16:	6a 3a                	push   $0x3a
  800c18:	68 dc 40 80 00       	push   $0x8040dc
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
  800c81:	68 3c 41 80 00       	push   $0x80413c
  800c86:	6a 44                	push   $0x44
  800c88:	68 dc 40 80 00       	push   $0x8040dc
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
  800cdb:	e8 fd 11 00 00       	call   801edd <sys_cputs>
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
  800d52:	e8 86 11 00 00       	call   801edd <sys_cputs>
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
  800d9c:	e8 ea 12 00 00       	call   80208b <sys_disable_interrupt>
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
  800dbc:	e8 e4 12 00 00       	call   8020a5 <sys_enable_interrupt>
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
  800e06:	e8 55 2d 00 00       	call   803b60 <__udivdi3>
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
  800e56:	e8 15 2e 00 00       	call   803c70 <__umoddi3>
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	05 b4 43 80 00       	add    $0x8043b4,%eax
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
  800fb1:	8b 04 85 d8 43 80 00 	mov    0x8043d8(,%eax,4),%eax
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
  801092:	8b 34 9d 20 42 80 00 	mov    0x804220(,%ebx,4),%esi
  801099:	85 f6                	test   %esi,%esi
  80109b:	75 19                	jne    8010b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80109d:	53                   	push   %ebx
  80109e:	68 c5 43 80 00       	push   $0x8043c5
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
  8010b7:	68 ce 43 80 00       	push   $0x8043ce
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
  8010e4:	be d1 43 80 00       	mov    $0x8043d1,%esi
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
  801b0a:	68 30 45 80 00       	push   $0x804530
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
  801bda:	e8 42 04 00 00       	call   802021 <sys_allocate_chunk>
  801bdf:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801be2:	a1 20 51 80 00       	mov    0x805120,%eax
  801be7:	83 ec 0c             	sub    $0xc,%esp
  801bea:	50                   	push   %eax
  801beb:	e8 b7 0a 00 00       	call   8026a7 <initialize_MemBlocksList>
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
  801c18:	68 55 45 80 00       	push   $0x804555
  801c1d:	6a 33                	push   $0x33
  801c1f:	68 73 45 80 00       	push   $0x804573
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
  801c97:	68 80 45 80 00       	push   $0x804580
  801c9c:	6a 34                	push   $0x34
  801c9e:	68 73 45 80 00       	push   $0x804573
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
  801d0c:	68 a4 45 80 00       	push   $0x8045a4
  801d11:	6a 46                	push   $0x46
  801d13:	68 73 45 80 00       	push   $0x804573
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
  801d28:	68 cc 45 80 00       	push   $0x8045cc
  801d2d:	6a 61                	push   $0x61
  801d2f:	68 73 45 80 00       	push   $0x804573
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
  801d4e:	75 0a                	jne    801d5a <smalloc+0x21>
  801d50:	b8 00 00 00 00       	mov    $0x0,%eax
  801d55:	e9 9e 00 00 00       	jmp    801df8 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801d5a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d67:	01 d0                	add    %edx,%eax
  801d69:	48                   	dec    %eax
  801d6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d70:	ba 00 00 00 00       	mov    $0x0,%edx
  801d75:	f7 75 f0             	divl   -0x10(%ebp)
  801d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7b:	29 d0                	sub    %edx,%eax
  801d7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801d80:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801d87:	e8 63 06 00 00       	call   8023ef <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d8c:	85 c0                	test   %eax,%eax
  801d8e:	74 11                	je     801da1 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801d90:	83 ec 0c             	sub    $0xc,%esp
  801d93:	ff 75 e8             	pushl  -0x18(%ebp)
  801d96:	e8 ce 0c 00 00       	call   802a69 <alloc_block_FF>
  801d9b:	83 c4 10             	add    $0x10,%esp
  801d9e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801da1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da5:	74 4c                	je     801df3 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daa:	8b 40 08             	mov    0x8(%eax),%eax
  801dad:	89 c2                	mov    %eax,%edx
  801daf:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801db3:	52                   	push   %edx
  801db4:	50                   	push   %eax
  801db5:	ff 75 0c             	pushl  0xc(%ebp)
  801db8:	ff 75 08             	pushl  0x8(%ebp)
  801dbb:	e8 b4 03 00 00       	call   802174 <sys_createSharedObject>
  801dc0:	83 c4 10             	add    $0x10,%esp
  801dc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801dc6:	83 ec 08             	sub    $0x8,%esp
  801dc9:	ff 75 e0             	pushl  -0x20(%ebp)
  801dcc:	68 ef 45 80 00       	push   $0x8045ef
  801dd1:	e8 93 ef ff ff       	call   800d69 <cprintf>
  801dd6:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801dd9:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801ddd:	74 14                	je     801df3 <smalloc+0xba>
  801ddf:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801de3:	74 0e                	je     801df3 <smalloc+0xba>
  801de5:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801de9:	74 08                	je     801df3 <smalloc+0xba>
			return (void*) mem_block->sva;
  801deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dee:	8b 40 08             	mov    0x8(%eax),%eax
  801df1:	eb 05                	jmp    801df8 <smalloc+0xbf>
	}
	return NULL;
  801df3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e00:	e8 ee fc ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801e05:	83 ec 04             	sub    $0x4,%esp
  801e08:	68 04 46 80 00       	push   $0x804604
  801e0d:	68 ab 00 00 00       	push   $0xab
  801e12:	68 73 45 80 00       	push   $0x804573
  801e17:	e8 99 ec ff ff       	call   800ab5 <_panic>

00801e1c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e22:	e8 cc fc ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e27:	83 ec 04             	sub    $0x4,%esp
  801e2a:	68 28 46 80 00       	push   $0x804628
  801e2f:	68 ef 00 00 00       	push   $0xef
  801e34:	68 73 45 80 00       	push   $0x804573
  801e39:	e8 77 ec ff ff       	call   800ab5 <_panic>

00801e3e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e44:	83 ec 04             	sub    $0x4,%esp
  801e47:	68 50 46 80 00       	push   $0x804650
  801e4c:	68 03 01 00 00       	push   $0x103
  801e51:	68 73 45 80 00       	push   $0x804573
  801e56:	e8 5a ec ff ff       	call   800ab5 <_panic>

00801e5b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e61:	83 ec 04             	sub    $0x4,%esp
  801e64:	68 74 46 80 00       	push   $0x804674
  801e69:	68 0e 01 00 00       	push   $0x10e
  801e6e:	68 73 45 80 00       	push   $0x804573
  801e73:	e8 3d ec ff ff       	call   800ab5 <_panic>

00801e78 <shrink>:

}
void shrink(uint32 newSize)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e7e:	83 ec 04             	sub    $0x4,%esp
  801e81:	68 74 46 80 00       	push   $0x804674
  801e86:	68 13 01 00 00       	push   $0x113
  801e8b:	68 73 45 80 00       	push   $0x804573
  801e90:	e8 20 ec ff ff       	call   800ab5 <_panic>

00801e95 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e9b:	83 ec 04             	sub    $0x4,%esp
  801e9e:	68 74 46 80 00       	push   $0x804674
  801ea3:	68 18 01 00 00       	push   $0x118
  801ea8:	68 73 45 80 00       	push   $0x804573
  801ead:	e8 03 ec ff ff       	call   800ab5 <_panic>

00801eb2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	57                   	push   %edi
  801eb6:	56                   	push   %esi
  801eb7:	53                   	push   %ebx
  801eb8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ec4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ec7:	8b 7d 18             	mov    0x18(%ebp),%edi
  801eca:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ecd:	cd 30                	int    $0x30
  801ecf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ed5:	83 c4 10             	add    $0x10,%esp
  801ed8:	5b                   	pop    %ebx
  801ed9:	5e                   	pop    %esi
  801eda:	5f                   	pop    %edi
  801edb:	5d                   	pop    %ebp
  801edc:	c3                   	ret    

00801edd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 04             	sub    $0x4,%esp
  801ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ee9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	52                   	push   %edx
  801ef5:	ff 75 0c             	pushl  0xc(%ebp)
  801ef8:	50                   	push   %eax
  801ef9:	6a 00                	push   $0x0
  801efb:	e8 b2 ff ff ff       	call   801eb2 <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
}
  801f03:	90                   	nop
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 01                	push   $0x1
  801f15:	e8 98 ff ff ff       	call   801eb2 <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	52                   	push   %edx
  801f2f:	50                   	push   %eax
  801f30:	6a 05                	push   $0x5
  801f32:	e8 7b ff ff ff       	call   801eb2 <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	56                   	push   %esi
  801f40:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f41:	8b 75 18             	mov    0x18(%ebp),%esi
  801f44:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f47:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	56                   	push   %esi
  801f51:	53                   	push   %ebx
  801f52:	51                   	push   %ecx
  801f53:	52                   	push   %edx
  801f54:	50                   	push   %eax
  801f55:	6a 06                	push   $0x6
  801f57:	e8 56 ff ff ff       	call   801eb2 <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
}
  801f5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f62:	5b                   	pop    %ebx
  801f63:	5e                   	pop    %esi
  801f64:	5d                   	pop    %ebp
  801f65:	c3                   	ret    

00801f66 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	52                   	push   %edx
  801f76:	50                   	push   %eax
  801f77:	6a 07                	push   $0x7
  801f79:	e8 34 ff ff ff       	call   801eb2 <syscall>
  801f7e:	83 c4 18             	add    $0x18,%esp
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	ff 75 0c             	pushl  0xc(%ebp)
  801f8f:	ff 75 08             	pushl  0x8(%ebp)
  801f92:	6a 08                	push   $0x8
  801f94:	e8 19 ff ff ff       	call   801eb2 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 09                	push   $0x9
  801fad:	e8 00 ff ff ff       	call   801eb2 <syscall>
  801fb2:	83 c4 18             	add    $0x18,%esp
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 0a                	push   $0xa
  801fc6:	e8 e7 fe ff ff       	call   801eb2 <syscall>
  801fcb:	83 c4 18             	add    $0x18,%esp
}
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 0b                	push   $0xb
  801fdf:	e8 ce fe ff ff       	call   801eb2 <syscall>
  801fe4:	83 c4 18             	add    $0x18,%esp
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	ff 75 0c             	pushl  0xc(%ebp)
  801ff5:	ff 75 08             	pushl  0x8(%ebp)
  801ff8:	6a 0f                	push   $0xf
  801ffa:	e8 b3 fe ff ff       	call   801eb2 <syscall>
  801fff:	83 c4 18             	add    $0x18,%esp
	return;
  802002:	90                   	nop
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	ff 75 0c             	pushl  0xc(%ebp)
  802011:	ff 75 08             	pushl  0x8(%ebp)
  802014:	6a 10                	push   $0x10
  802016:	e8 97 fe ff ff       	call   801eb2 <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
	return ;
  80201e:	90                   	nop
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	ff 75 10             	pushl  0x10(%ebp)
  80202b:	ff 75 0c             	pushl  0xc(%ebp)
  80202e:	ff 75 08             	pushl  0x8(%ebp)
  802031:	6a 11                	push   $0x11
  802033:	e8 7a fe ff ff       	call   801eb2 <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
	return ;
  80203b:	90                   	nop
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 0c                	push   $0xc
  80204d:	e8 60 fe ff ff       	call   801eb2 <syscall>
  802052:	83 c4 18             	add    $0x18,%esp
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	ff 75 08             	pushl  0x8(%ebp)
  802065:	6a 0d                	push   $0xd
  802067:	e8 46 fe ff ff       	call   801eb2 <syscall>
  80206c:	83 c4 18             	add    $0x18,%esp
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 0e                	push   $0xe
  802080:	e8 2d fe ff ff       	call   801eb2 <syscall>
  802085:	83 c4 18             	add    $0x18,%esp
}
  802088:	90                   	nop
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 13                	push   $0x13
  80209a:	e8 13 fe ff ff       	call   801eb2 <syscall>
  80209f:	83 c4 18             	add    $0x18,%esp
}
  8020a2:	90                   	nop
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 14                	push   $0x14
  8020b4:	e8 f9 fd ff ff       	call   801eb2 <syscall>
  8020b9:	83 c4 18             	add    $0x18,%esp
}
  8020bc:	90                   	nop
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <sys_cputc>:


void
sys_cputc(const char c)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 04             	sub    $0x4,%esp
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020cb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	50                   	push   %eax
  8020d8:	6a 15                	push   $0x15
  8020da:	e8 d3 fd ff ff       	call   801eb2 <syscall>
  8020df:	83 c4 18             	add    $0x18,%esp
}
  8020e2:	90                   	nop
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 16                	push   $0x16
  8020f4:	e8 b9 fd ff ff       	call   801eb2 <syscall>
  8020f9:	83 c4 18             	add    $0x18,%esp
}
  8020fc:	90                   	nop
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	ff 75 0c             	pushl  0xc(%ebp)
  80210e:	50                   	push   %eax
  80210f:	6a 17                	push   $0x17
  802111:	e8 9c fd ff ff       	call   801eb2 <syscall>
  802116:	83 c4 18             	add    $0x18,%esp
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80211e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	52                   	push   %edx
  80212b:	50                   	push   %eax
  80212c:	6a 1a                	push   $0x1a
  80212e:	e8 7f fd ff ff       	call   801eb2 <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80213b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	52                   	push   %edx
  802148:	50                   	push   %eax
  802149:	6a 18                	push   $0x18
  80214b:	e8 62 fd ff ff       	call   801eb2 <syscall>
  802150:	83 c4 18             	add    $0x18,%esp
}
  802153:	90                   	nop
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802159:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	52                   	push   %edx
  802166:	50                   	push   %eax
  802167:	6a 19                	push   $0x19
  802169:	e8 44 fd ff ff       	call   801eb2 <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
}
  802171:	90                   	nop
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	83 ec 04             	sub    $0x4,%esp
  80217a:	8b 45 10             	mov    0x10(%ebp),%eax
  80217d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802180:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802183:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	6a 00                	push   $0x0
  80218c:	51                   	push   %ecx
  80218d:	52                   	push   %edx
  80218e:	ff 75 0c             	pushl  0xc(%ebp)
  802191:	50                   	push   %eax
  802192:	6a 1b                	push   $0x1b
  802194:	e8 19 fd ff ff       	call   801eb2 <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	52                   	push   %edx
  8021ae:	50                   	push   %eax
  8021af:	6a 1c                	push   $0x1c
  8021b1:	e8 fc fc ff ff       	call   801eb2 <syscall>
  8021b6:	83 c4 18             	add    $0x18,%esp
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	51                   	push   %ecx
  8021cc:	52                   	push   %edx
  8021cd:	50                   	push   %eax
  8021ce:	6a 1d                	push   $0x1d
  8021d0:	e8 dd fc ff ff       	call   801eb2 <syscall>
  8021d5:	83 c4 18             	add    $0x18,%esp
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	52                   	push   %edx
  8021ea:	50                   	push   %eax
  8021eb:	6a 1e                	push   $0x1e
  8021ed:	e8 c0 fc ff ff       	call   801eb2 <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
}
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 1f                	push   $0x1f
  802206:	e8 a7 fc ff ff       	call   801eb2 <syscall>
  80220b:	83 c4 18             	add    $0x18,%esp
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	6a 00                	push   $0x0
  802218:	ff 75 14             	pushl  0x14(%ebp)
  80221b:	ff 75 10             	pushl  0x10(%ebp)
  80221e:	ff 75 0c             	pushl  0xc(%ebp)
  802221:	50                   	push   %eax
  802222:	6a 20                	push   $0x20
  802224:	e8 89 fc ff ff       	call   801eb2 <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	50                   	push   %eax
  80223d:	6a 21                	push   $0x21
  80223f:	e8 6e fc ff ff       	call   801eb2 <syscall>
  802244:	83 c4 18             	add    $0x18,%esp
}
  802247:	90                   	nop
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	50                   	push   %eax
  802259:	6a 22                	push   $0x22
  80225b:	e8 52 fc ff ff       	call   801eb2 <syscall>
  802260:	83 c4 18             	add    $0x18,%esp
}
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 02                	push   $0x2
  802274:	e8 39 fc ff ff       	call   801eb2 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 03                	push   $0x3
  80228d:	e8 20 fc ff ff       	call   801eb2 <syscall>
  802292:	83 c4 18             	add    $0x18,%esp
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 04                	push   $0x4
  8022a6:	e8 07 fc ff ff       	call   801eb2 <syscall>
  8022ab:	83 c4 18             	add    $0x18,%esp
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <sys_exit_env>:


void sys_exit_env(void)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 23                	push   $0x23
  8022bf:	e8 ee fb ff ff       	call   801eb2 <syscall>
  8022c4:	83 c4 18             	add    $0x18,%esp
}
  8022c7:	90                   	nop
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022d0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022d3:	8d 50 04             	lea    0x4(%eax),%edx
  8022d6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	52                   	push   %edx
  8022e0:	50                   	push   %eax
  8022e1:	6a 24                	push   $0x24
  8022e3:	e8 ca fb ff ff       	call   801eb2 <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
	return result;
  8022eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022f4:	89 01                	mov    %eax,(%ecx)
  8022f6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	c9                   	leave  
  8022fd:	c2 04 00             	ret    $0x4

00802300 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	ff 75 10             	pushl  0x10(%ebp)
  80230a:	ff 75 0c             	pushl  0xc(%ebp)
  80230d:	ff 75 08             	pushl  0x8(%ebp)
  802310:	6a 12                	push   $0x12
  802312:	e8 9b fb ff ff       	call   801eb2 <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
	return ;
  80231a:	90                   	nop
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <sys_rcr2>:
uint32 sys_rcr2()
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 25                	push   $0x25
  80232c:	e8 81 fb ff ff       	call   801eb2 <syscall>
  802331:	83 c4 18             	add    $0x18,%esp
}
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	83 ec 04             	sub    $0x4,%esp
  80233c:	8b 45 08             	mov    0x8(%ebp),%eax
  80233f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802342:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	50                   	push   %eax
  80234f:	6a 26                	push   $0x26
  802351:	e8 5c fb ff ff       	call   801eb2 <syscall>
  802356:	83 c4 18             	add    $0x18,%esp
	return ;
  802359:	90                   	nop
}
  80235a:	c9                   	leave  
  80235b:	c3                   	ret    

0080235c <rsttst>:
void rsttst()
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 28                	push   $0x28
  80236b:	e8 42 fb ff ff       	call   801eb2 <syscall>
  802370:	83 c4 18             	add    $0x18,%esp
	return ;
  802373:	90                   	nop
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	83 ec 04             	sub    $0x4,%esp
  80237c:	8b 45 14             	mov    0x14(%ebp),%eax
  80237f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802382:	8b 55 18             	mov    0x18(%ebp),%edx
  802385:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802389:	52                   	push   %edx
  80238a:	50                   	push   %eax
  80238b:	ff 75 10             	pushl  0x10(%ebp)
  80238e:	ff 75 0c             	pushl  0xc(%ebp)
  802391:	ff 75 08             	pushl  0x8(%ebp)
  802394:	6a 27                	push   $0x27
  802396:	e8 17 fb ff ff       	call   801eb2 <syscall>
  80239b:	83 c4 18             	add    $0x18,%esp
	return ;
  80239e:	90                   	nop
}
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

008023a1 <chktst>:
void chktst(uint32 n)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	ff 75 08             	pushl  0x8(%ebp)
  8023af:	6a 29                	push   $0x29
  8023b1:	e8 fc fa ff ff       	call   801eb2 <syscall>
  8023b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b9:	90                   	nop
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <inctst>:

void inctst()
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 2a                	push   $0x2a
  8023cb:	e8 e2 fa ff ff       	call   801eb2 <syscall>
  8023d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d3:	90                   	nop
}
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <gettst>:
uint32 gettst()
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 2b                	push   $0x2b
  8023e5:	e8 c8 fa ff ff       	call   801eb2 <syscall>
  8023ea:	83 c4 18             	add    $0x18,%esp
}
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 2c                	push   $0x2c
  802401:	e8 ac fa ff ff       	call   801eb2 <syscall>
  802406:	83 c4 18             	add    $0x18,%esp
  802409:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80240c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802410:	75 07                	jne    802419 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802412:	b8 01 00 00 00       	mov    $0x1,%eax
  802417:	eb 05                	jmp    80241e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802419:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 2c                	push   $0x2c
  802432:	e8 7b fa ff ff       	call   801eb2 <syscall>
  802437:	83 c4 18             	add    $0x18,%esp
  80243a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80243d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802441:	75 07                	jne    80244a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802443:	b8 01 00 00 00       	mov    $0x1,%eax
  802448:	eb 05                	jmp    80244f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80244a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244f:	c9                   	leave  
  802450:	c3                   	ret    

00802451 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
  802454:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 2c                	push   $0x2c
  802463:	e8 4a fa ff ff       	call   801eb2 <syscall>
  802468:	83 c4 18             	add    $0x18,%esp
  80246b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80246e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802472:	75 07                	jne    80247b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802474:	b8 01 00 00 00       	mov    $0x1,%eax
  802479:	eb 05                	jmp    802480 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80247b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 2c                	push   $0x2c
  802494:	e8 19 fa ff ff       	call   801eb2 <syscall>
  802499:	83 c4 18             	add    $0x18,%esp
  80249c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80249f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024a3:	75 07                	jne    8024ac <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8024aa:	eb 05                	jmp    8024b1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	ff 75 08             	pushl  0x8(%ebp)
  8024c1:	6a 2d                	push   $0x2d
  8024c3:	e8 ea f9 ff ff       	call   801eb2 <syscall>
  8024c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8024cb:	90                   	nop
}
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

008024ce <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024d2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	6a 00                	push   $0x0
  8024e0:	53                   	push   %ebx
  8024e1:	51                   	push   %ecx
  8024e2:	52                   	push   %edx
  8024e3:	50                   	push   %eax
  8024e4:	6a 2e                	push   $0x2e
  8024e6:	e8 c7 f9 ff ff       	call   801eb2 <syscall>
  8024eb:	83 c4 18             	add    $0x18,%esp
}
  8024ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024f1:	c9                   	leave  
  8024f2:	c3                   	ret    

008024f3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	52                   	push   %edx
  802503:	50                   	push   %eax
  802504:	6a 2f                	push   $0x2f
  802506:	e8 a7 f9 ff ff       	call   801eb2 <syscall>
  80250b:	83 c4 18             	add    $0x18,%esp
}
  80250e:	c9                   	leave  
  80250f:	c3                   	ret    

00802510 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802516:	83 ec 0c             	sub    $0xc,%esp
  802519:	68 84 46 80 00       	push   $0x804684
  80251e:	e8 46 e8 ff ff       	call   800d69 <cprintf>
  802523:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802526:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80252d:	83 ec 0c             	sub    $0xc,%esp
  802530:	68 b0 46 80 00       	push   $0x8046b0
  802535:	e8 2f e8 ff ff       	call   800d69 <cprintf>
  80253a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80253d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802541:	a1 38 51 80 00       	mov    0x805138,%eax
  802546:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802549:	eb 56                	jmp    8025a1 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80254b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80254f:	74 1c                	je     80256d <print_mem_block_lists+0x5d>
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 50 08             	mov    0x8(%eax),%edx
  802557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255a:	8b 48 08             	mov    0x8(%eax),%ecx
  80255d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802560:	8b 40 0c             	mov    0xc(%eax),%eax
  802563:	01 c8                	add    %ecx,%eax
  802565:	39 c2                	cmp    %eax,%edx
  802567:	73 04                	jae    80256d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802569:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	8b 50 08             	mov    0x8(%eax),%edx
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 40 0c             	mov    0xc(%eax),%eax
  802579:	01 c2                	add    %eax,%edx
  80257b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257e:	8b 40 08             	mov    0x8(%eax),%eax
  802581:	83 ec 04             	sub    $0x4,%esp
  802584:	52                   	push   %edx
  802585:	50                   	push   %eax
  802586:	68 c5 46 80 00       	push   $0x8046c5
  80258b:	e8 d9 e7 ff ff       	call   800d69 <cprintf>
  802590:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802599:	a1 40 51 80 00       	mov    0x805140,%eax
  80259e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a5:	74 07                	je     8025ae <print_mem_block_lists+0x9e>
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 00                	mov    (%eax),%eax
  8025ac:	eb 05                	jmp    8025b3 <print_mem_block_lists+0xa3>
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b3:	a3 40 51 80 00       	mov    %eax,0x805140
  8025b8:	a1 40 51 80 00       	mov    0x805140,%eax
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	75 8a                	jne    80254b <print_mem_block_lists+0x3b>
  8025c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c5:	75 84                	jne    80254b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025c7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025cb:	75 10                	jne    8025dd <print_mem_block_lists+0xcd>
  8025cd:	83 ec 0c             	sub    $0xc,%esp
  8025d0:	68 d4 46 80 00       	push   $0x8046d4
  8025d5:	e8 8f e7 ff ff       	call   800d69 <cprintf>
  8025da:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025e4:	83 ec 0c             	sub    $0xc,%esp
  8025e7:	68 f8 46 80 00       	push   $0x8046f8
  8025ec:	e8 78 e7 ff ff       	call   800d69 <cprintf>
  8025f1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025f4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025f8:	a1 40 50 80 00       	mov    0x805040,%eax
  8025fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802600:	eb 56                	jmp    802658 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802602:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802606:	74 1c                	je     802624 <print_mem_block_lists+0x114>
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 50 08             	mov    0x8(%eax),%edx
  80260e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802611:	8b 48 08             	mov    0x8(%eax),%ecx
  802614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802617:	8b 40 0c             	mov    0xc(%eax),%eax
  80261a:	01 c8                	add    %ecx,%eax
  80261c:	39 c2                	cmp    %eax,%edx
  80261e:	73 04                	jae    802624 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802620:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 50 08             	mov    0x8(%eax),%edx
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 40 0c             	mov    0xc(%eax),%eax
  802630:	01 c2                	add    %eax,%edx
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 40 08             	mov    0x8(%eax),%eax
  802638:	83 ec 04             	sub    $0x4,%esp
  80263b:	52                   	push   %edx
  80263c:	50                   	push   %eax
  80263d:	68 c5 46 80 00       	push   $0x8046c5
  802642:	e8 22 e7 ff ff       	call   800d69 <cprintf>
  802647:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802650:	a1 48 50 80 00       	mov    0x805048,%eax
  802655:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802658:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265c:	74 07                	je     802665 <print_mem_block_lists+0x155>
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 00                	mov    (%eax),%eax
  802663:	eb 05                	jmp    80266a <print_mem_block_lists+0x15a>
  802665:	b8 00 00 00 00       	mov    $0x0,%eax
  80266a:	a3 48 50 80 00       	mov    %eax,0x805048
  80266f:	a1 48 50 80 00       	mov    0x805048,%eax
  802674:	85 c0                	test   %eax,%eax
  802676:	75 8a                	jne    802602 <print_mem_block_lists+0xf2>
  802678:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267c:	75 84                	jne    802602 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80267e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802682:	75 10                	jne    802694 <print_mem_block_lists+0x184>
  802684:	83 ec 0c             	sub    $0xc,%esp
  802687:	68 10 47 80 00       	push   $0x804710
  80268c:	e8 d8 e6 ff ff       	call   800d69 <cprintf>
  802691:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802694:	83 ec 0c             	sub    $0xc,%esp
  802697:	68 84 46 80 00       	push   $0x804684
  80269c:	e8 c8 e6 ff ff       	call   800d69 <cprintf>
  8026a1:	83 c4 10             	add    $0x10,%esp

}
  8026a4:	90                   	nop
  8026a5:	c9                   	leave  
  8026a6:	c3                   	ret    

008026a7 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026a7:	55                   	push   %ebp
  8026a8:	89 e5                	mov    %esp,%ebp
  8026aa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8026ad:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026b4:	00 00 00 
  8026b7:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026be:	00 00 00 
  8026c1:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026c8:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8026cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026d2:	e9 9e 00 00 00       	jmp    802775 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8026d7:	a1 50 50 80 00       	mov    0x805050,%eax
  8026dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026df:	c1 e2 04             	shl    $0x4,%edx
  8026e2:	01 d0                	add    %edx,%eax
  8026e4:	85 c0                	test   %eax,%eax
  8026e6:	75 14                	jne    8026fc <initialize_MemBlocksList+0x55>
  8026e8:	83 ec 04             	sub    $0x4,%esp
  8026eb:	68 38 47 80 00       	push   $0x804738
  8026f0:	6a 46                	push   $0x46
  8026f2:	68 5b 47 80 00       	push   $0x80475b
  8026f7:	e8 b9 e3 ff ff       	call   800ab5 <_panic>
  8026fc:	a1 50 50 80 00       	mov    0x805050,%eax
  802701:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802704:	c1 e2 04             	shl    $0x4,%edx
  802707:	01 d0                	add    %edx,%eax
  802709:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80270f:	89 10                	mov    %edx,(%eax)
  802711:	8b 00                	mov    (%eax),%eax
  802713:	85 c0                	test   %eax,%eax
  802715:	74 18                	je     80272f <initialize_MemBlocksList+0x88>
  802717:	a1 48 51 80 00       	mov    0x805148,%eax
  80271c:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802722:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802725:	c1 e1 04             	shl    $0x4,%ecx
  802728:	01 ca                	add    %ecx,%edx
  80272a:	89 50 04             	mov    %edx,0x4(%eax)
  80272d:	eb 12                	jmp    802741 <initialize_MemBlocksList+0x9a>
  80272f:	a1 50 50 80 00       	mov    0x805050,%eax
  802734:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802737:	c1 e2 04             	shl    $0x4,%edx
  80273a:	01 d0                	add    %edx,%eax
  80273c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802741:	a1 50 50 80 00       	mov    0x805050,%eax
  802746:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802749:	c1 e2 04             	shl    $0x4,%edx
  80274c:	01 d0                	add    %edx,%eax
  80274e:	a3 48 51 80 00       	mov    %eax,0x805148
  802753:	a1 50 50 80 00       	mov    0x805050,%eax
  802758:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275b:	c1 e2 04             	shl    $0x4,%edx
  80275e:	01 d0                	add    %edx,%eax
  802760:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802767:	a1 54 51 80 00       	mov    0x805154,%eax
  80276c:	40                   	inc    %eax
  80276d:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802772:	ff 45 f4             	incl   -0xc(%ebp)
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	3b 45 08             	cmp    0x8(%ebp),%eax
  80277b:	0f 82 56 ff ff ff    	jb     8026d7 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802781:	90                   	nop
  802782:	c9                   	leave  
  802783:	c3                   	ret    

00802784 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802784:	55                   	push   %ebp
  802785:	89 e5                	mov    %esp,%ebp
  802787:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80278a:	8b 45 08             	mov    0x8(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802792:	eb 19                	jmp    8027ad <find_block+0x29>
	{
		if(va==point->sva)
  802794:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802797:	8b 40 08             	mov    0x8(%eax),%eax
  80279a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80279d:	75 05                	jne    8027a4 <find_block+0x20>
		   return point;
  80279f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027a2:	eb 36                	jmp    8027da <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8027a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a7:	8b 40 08             	mov    0x8(%eax),%eax
  8027aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027b1:	74 07                	je     8027ba <find_block+0x36>
  8027b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027b6:	8b 00                	mov    (%eax),%eax
  8027b8:	eb 05                	jmp    8027bf <find_block+0x3b>
  8027ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c2:	89 42 08             	mov    %eax,0x8(%edx)
  8027c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c8:	8b 40 08             	mov    0x8(%eax),%eax
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	75 c5                	jne    802794 <find_block+0x10>
  8027cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027d3:	75 bf                	jne    802794 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8027d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027da:	c9                   	leave  
  8027db:	c3                   	ret    

008027dc <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027dc:	55                   	push   %ebp
  8027dd:	89 e5                	mov    %esp,%ebp
  8027df:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8027e2:	a1 40 50 80 00       	mov    0x805040,%eax
  8027e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8027ea:	a1 44 50 80 00       	mov    0x805044,%eax
  8027ef:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8027f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027f8:	74 24                	je     80281e <insert_sorted_allocList+0x42>
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	8b 50 08             	mov    0x8(%eax),%edx
  802800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802803:	8b 40 08             	mov    0x8(%eax),%eax
  802806:	39 c2                	cmp    %eax,%edx
  802808:	76 14                	jbe    80281e <insert_sorted_allocList+0x42>
  80280a:	8b 45 08             	mov    0x8(%ebp),%eax
  80280d:	8b 50 08             	mov    0x8(%eax),%edx
  802810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802813:	8b 40 08             	mov    0x8(%eax),%eax
  802816:	39 c2                	cmp    %eax,%edx
  802818:	0f 82 60 01 00 00    	jb     80297e <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80281e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802822:	75 65                	jne    802889 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802824:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802828:	75 14                	jne    80283e <insert_sorted_allocList+0x62>
  80282a:	83 ec 04             	sub    $0x4,%esp
  80282d:	68 38 47 80 00       	push   $0x804738
  802832:	6a 6b                	push   $0x6b
  802834:	68 5b 47 80 00       	push   $0x80475b
  802839:	e8 77 e2 ff ff       	call   800ab5 <_panic>
  80283e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802844:	8b 45 08             	mov    0x8(%ebp),%eax
  802847:	89 10                	mov    %edx,(%eax)
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	8b 00                	mov    (%eax),%eax
  80284e:	85 c0                	test   %eax,%eax
  802850:	74 0d                	je     80285f <insert_sorted_allocList+0x83>
  802852:	a1 40 50 80 00       	mov    0x805040,%eax
  802857:	8b 55 08             	mov    0x8(%ebp),%edx
  80285a:	89 50 04             	mov    %edx,0x4(%eax)
  80285d:	eb 08                	jmp    802867 <insert_sorted_allocList+0x8b>
  80285f:	8b 45 08             	mov    0x8(%ebp),%eax
  802862:	a3 44 50 80 00       	mov    %eax,0x805044
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	a3 40 50 80 00       	mov    %eax,0x805040
  80286f:	8b 45 08             	mov    0x8(%ebp),%eax
  802872:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802879:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80287e:	40                   	inc    %eax
  80287f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802884:	e9 dc 01 00 00       	jmp    802a65 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	8b 50 08             	mov    0x8(%eax),%edx
  80288f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802892:	8b 40 08             	mov    0x8(%eax),%eax
  802895:	39 c2                	cmp    %eax,%edx
  802897:	77 6c                	ja     802905 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802899:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80289d:	74 06                	je     8028a5 <insert_sorted_allocList+0xc9>
  80289f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028a3:	75 14                	jne    8028b9 <insert_sorted_allocList+0xdd>
  8028a5:	83 ec 04             	sub    $0x4,%esp
  8028a8:	68 74 47 80 00       	push   $0x804774
  8028ad:	6a 6f                	push   $0x6f
  8028af:	68 5b 47 80 00       	push   $0x80475b
  8028b4:	e8 fc e1 ff ff       	call   800ab5 <_panic>
  8028b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bc:	8b 50 04             	mov    0x4(%eax),%edx
  8028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c2:	89 50 04             	mov    %edx,0x4(%eax)
  8028c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028cb:	89 10                	mov    %edx,(%eax)
  8028cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d0:	8b 40 04             	mov    0x4(%eax),%eax
  8028d3:	85 c0                	test   %eax,%eax
  8028d5:	74 0d                	je     8028e4 <insert_sorted_allocList+0x108>
  8028d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028da:	8b 40 04             	mov    0x4(%eax),%eax
  8028dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e0:	89 10                	mov    %edx,(%eax)
  8028e2:	eb 08                	jmp    8028ec <insert_sorted_allocList+0x110>
  8028e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e7:	a3 40 50 80 00       	mov    %eax,0x805040
  8028ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f2:	89 50 04             	mov    %edx,0x4(%eax)
  8028f5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028fa:	40                   	inc    %eax
  8028fb:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802900:	e9 60 01 00 00       	jmp    802a65 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802905:	8b 45 08             	mov    0x8(%ebp),%eax
  802908:	8b 50 08             	mov    0x8(%eax),%edx
  80290b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290e:	8b 40 08             	mov    0x8(%eax),%eax
  802911:	39 c2                	cmp    %eax,%edx
  802913:	0f 82 4c 01 00 00    	jb     802a65 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802919:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80291d:	75 14                	jne    802933 <insert_sorted_allocList+0x157>
  80291f:	83 ec 04             	sub    $0x4,%esp
  802922:	68 ac 47 80 00       	push   $0x8047ac
  802927:	6a 73                	push   $0x73
  802929:	68 5b 47 80 00       	push   $0x80475b
  80292e:	e8 82 e1 ff ff       	call   800ab5 <_panic>
  802933:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802939:	8b 45 08             	mov    0x8(%ebp),%eax
  80293c:	89 50 04             	mov    %edx,0x4(%eax)
  80293f:	8b 45 08             	mov    0x8(%ebp),%eax
  802942:	8b 40 04             	mov    0x4(%eax),%eax
  802945:	85 c0                	test   %eax,%eax
  802947:	74 0c                	je     802955 <insert_sorted_allocList+0x179>
  802949:	a1 44 50 80 00       	mov    0x805044,%eax
  80294e:	8b 55 08             	mov    0x8(%ebp),%edx
  802951:	89 10                	mov    %edx,(%eax)
  802953:	eb 08                	jmp    80295d <insert_sorted_allocList+0x181>
  802955:	8b 45 08             	mov    0x8(%ebp),%eax
  802958:	a3 40 50 80 00       	mov    %eax,0x805040
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	a3 44 50 80 00       	mov    %eax,0x805044
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802973:	40                   	inc    %eax
  802974:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802979:	e9 e7 00 00 00       	jmp    802a65 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80297e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802981:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802984:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80298b:	a1 40 50 80 00       	mov    0x805040,%eax
  802990:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802993:	e9 9d 00 00 00       	jmp    802a35 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 00                	mov    (%eax),%eax
  80299d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	8b 50 08             	mov    0x8(%eax),%edx
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	8b 40 08             	mov    0x8(%eax),%eax
  8029ac:	39 c2                	cmp    %eax,%edx
  8029ae:	76 7d                	jbe    802a2d <insert_sorted_allocList+0x251>
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	8b 50 08             	mov    0x8(%eax),%edx
  8029b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b9:	8b 40 08             	mov    0x8(%eax),%eax
  8029bc:	39 c2                	cmp    %eax,%edx
  8029be:	73 6d                	jae    802a2d <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8029c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c4:	74 06                	je     8029cc <insert_sorted_allocList+0x1f0>
  8029c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ca:	75 14                	jne    8029e0 <insert_sorted_allocList+0x204>
  8029cc:	83 ec 04             	sub    $0x4,%esp
  8029cf:	68 d0 47 80 00       	push   $0x8047d0
  8029d4:	6a 7f                	push   $0x7f
  8029d6:	68 5b 47 80 00       	push   $0x80475b
  8029db:	e8 d5 e0 ff ff       	call   800ab5 <_panic>
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 10                	mov    (%eax),%edx
  8029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e8:	89 10                	mov    %edx,(%eax)
  8029ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ed:	8b 00                	mov    (%eax),%eax
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	74 0b                	je     8029fe <insert_sorted_allocList+0x222>
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 00                	mov    (%eax),%eax
  8029f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029fb:	89 50 04             	mov    %edx,0x4(%eax)
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 55 08             	mov    0x8(%ebp),%edx
  802a04:	89 10                	mov    %edx,(%eax)
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0c:	89 50 04             	mov    %edx,0x4(%eax)
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	8b 00                	mov    (%eax),%eax
  802a14:	85 c0                	test   %eax,%eax
  802a16:	75 08                	jne    802a20 <insert_sorted_allocList+0x244>
  802a18:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1b:	a3 44 50 80 00       	mov    %eax,0x805044
  802a20:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a25:	40                   	inc    %eax
  802a26:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a2b:	eb 39                	jmp    802a66 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802a2d:	a1 48 50 80 00       	mov    0x805048,%eax
  802a32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a39:	74 07                	je     802a42 <insert_sorted_allocList+0x266>
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	8b 00                	mov    (%eax),%eax
  802a40:	eb 05                	jmp    802a47 <insert_sorted_allocList+0x26b>
  802a42:	b8 00 00 00 00       	mov    $0x0,%eax
  802a47:	a3 48 50 80 00       	mov    %eax,0x805048
  802a4c:	a1 48 50 80 00       	mov    0x805048,%eax
  802a51:	85 c0                	test   %eax,%eax
  802a53:	0f 85 3f ff ff ff    	jne    802998 <insert_sorted_allocList+0x1bc>
  802a59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5d:	0f 85 35 ff ff ff    	jne    802998 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a63:	eb 01                	jmp    802a66 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a65:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802a66:	90                   	nop
  802a67:	c9                   	leave  
  802a68:	c3                   	ret    

00802a69 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a69:	55                   	push   %ebp
  802a6a:	89 e5                	mov    %esp,%ebp
  802a6c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802a6f:	a1 38 51 80 00       	mov    0x805138,%eax
  802a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a77:	e9 85 01 00 00       	jmp    802c01 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a82:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a85:	0f 82 6e 01 00 00    	jb     802bf9 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a91:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a94:	0f 85 8a 00 00 00    	jne    802b24 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802a9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9e:	75 17                	jne    802ab7 <alloc_block_FF+0x4e>
  802aa0:	83 ec 04             	sub    $0x4,%esp
  802aa3:	68 04 48 80 00       	push   $0x804804
  802aa8:	68 93 00 00 00       	push   $0x93
  802aad:	68 5b 47 80 00       	push   $0x80475b
  802ab2:	e8 fe df ff ff       	call   800ab5 <_panic>
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	8b 00                	mov    (%eax),%eax
  802abc:	85 c0                	test   %eax,%eax
  802abe:	74 10                	je     802ad0 <alloc_block_FF+0x67>
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 00                	mov    (%eax),%eax
  802ac5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac8:	8b 52 04             	mov    0x4(%edx),%edx
  802acb:	89 50 04             	mov    %edx,0x4(%eax)
  802ace:	eb 0b                	jmp    802adb <alloc_block_FF+0x72>
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	8b 40 04             	mov    0x4(%eax),%eax
  802ad6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 40 04             	mov    0x4(%eax),%eax
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	74 0f                	je     802af4 <alloc_block_FF+0x8b>
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 40 04             	mov    0x4(%eax),%eax
  802aeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aee:	8b 12                	mov    (%edx),%edx
  802af0:	89 10                	mov    %edx,(%eax)
  802af2:	eb 0a                	jmp    802afe <alloc_block_FF+0x95>
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	a3 38 51 80 00       	mov    %eax,0x805138
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b11:	a1 44 51 80 00       	mov    0x805144,%eax
  802b16:	48                   	dec    %eax
  802b17:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	e9 10 01 00 00       	jmp    802c34 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b2d:	0f 86 c6 00 00 00    	jbe    802bf9 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b33:	a1 48 51 80 00       	mov    0x805148,%eax
  802b38:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	8b 50 08             	mov    0x8(%eax),%edx
  802b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b44:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4d:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b54:	75 17                	jne    802b6d <alloc_block_FF+0x104>
  802b56:	83 ec 04             	sub    $0x4,%esp
  802b59:	68 04 48 80 00       	push   $0x804804
  802b5e:	68 9b 00 00 00       	push   $0x9b
  802b63:	68 5b 47 80 00       	push   $0x80475b
  802b68:	e8 48 df ff ff       	call   800ab5 <_panic>
  802b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b70:	8b 00                	mov    (%eax),%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	74 10                	je     802b86 <alloc_block_FF+0x11d>
  802b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7e:	8b 52 04             	mov    0x4(%edx),%edx
  802b81:	89 50 04             	mov    %edx,0x4(%eax)
  802b84:	eb 0b                	jmp    802b91 <alloc_block_FF+0x128>
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	8b 40 04             	mov    0x4(%eax),%eax
  802b8c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b94:	8b 40 04             	mov    0x4(%eax),%eax
  802b97:	85 c0                	test   %eax,%eax
  802b99:	74 0f                	je     802baa <alloc_block_FF+0x141>
  802b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ba1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba4:	8b 12                	mov    (%edx),%edx
  802ba6:	89 10                	mov    %edx,(%eax)
  802ba8:	eb 0a                	jmp    802bb4 <alloc_block_FF+0x14b>
  802baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bad:	8b 00                	mov    (%eax),%eax
  802baf:	a3 48 51 80 00       	mov    %eax,0x805148
  802bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc7:	a1 54 51 80 00       	mov    0x805154,%eax
  802bcc:	48                   	dec    %eax
  802bcd:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 50 08             	mov    0x8(%eax),%edx
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	01 c2                	add    %eax,%edx
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	8b 40 0c             	mov    0xc(%eax),%eax
  802be9:	2b 45 08             	sub    0x8(%ebp),%eax
  802bec:	89 c2                	mov    %eax,%edx
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf7:	eb 3b                	jmp    802c34 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802bf9:	a1 40 51 80 00       	mov    0x805140,%eax
  802bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c05:	74 07                	je     802c0e <alloc_block_FF+0x1a5>
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	eb 05                	jmp    802c13 <alloc_block_FF+0x1aa>
  802c0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c13:	a3 40 51 80 00       	mov    %eax,0x805140
  802c18:	a1 40 51 80 00       	mov    0x805140,%eax
  802c1d:	85 c0                	test   %eax,%eax
  802c1f:	0f 85 57 fe ff ff    	jne    802a7c <alloc_block_FF+0x13>
  802c25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c29:	0f 85 4d fe ff ff    	jne    802a7c <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802c2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c34:	c9                   	leave  
  802c35:	c3                   	ret    

00802c36 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c36:	55                   	push   %ebp
  802c37:	89 e5                	mov    %esp,%ebp
  802c39:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802c3c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c43:	a1 38 51 80 00       	mov    0x805138,%eax
  802c48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c4b:	e9 df 00 00 00       	jmp    802d2f <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 40 0c             	mov    0xc(%eax),%eax
  802c56:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c59:	0f 82 c8 00 00 00    	jb     802d27 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 40 0c             	mov    0xc(%eax),%eax
  802c65:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c68:	0f 85 8a 00 00 00    	jne    802cf8 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802c6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c72:	75 17                	jne    802c8b <alloc_block_BF+0x55>
  802c74:	83 ec 04             	sub    $0x4,%esp
  802c77:	68 04 48 80 00       	push   $0x804804
  802c7c:	68 b7 00 00 00       	push   $0xb7
  802c81:	68 5b 47 80 00       	push   $0x80475b
  802c86:	e8 2a de ff ff       	call   800ab5 <_panic>
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 00                	mov    (%eax),%eax
  802c90:	85 c0                	test   %eax,%eax
  802c92:	74 10                	je     802ca4 <alloc_block_BF+0x6e>
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 00                	mov    (%eax),%eax
  802c99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c9c:	8b 52 04             	mov    0x4(%edx),%edx
  802c9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ca2:	eb 0b                	jmp    802caf <alloc_block_BF+0x79>
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	8b 40 04             	mov    0x4(%eax),%eax
  802caa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	8b 40 04             	mov    0x4(%eax),%eax
  802cb5:	85 c0                	test   %eax,%eax
  802cb7:	74 0f                	je     802cc8 <alloc_block_BF+0x92>
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	8b 40 04             	mov    0x4(%eax),%eax
  802cbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc2:	8b 12                	mov    (%edx),%edx
  802cc4:	89 10                	mov    %edx,(%eax)
  802cc6:	eb 0a                	jmp    802cd2 <alloc_block_BF+0x9c>
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 00                	mov    (%eax),%eax
  802ccd:	a3 38 51 80 00       	mov    %eax,0x805138
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce5:	a1 44 51 80 00       	mov    0x805144,%eax
  802cea:	48                   	dec    %eax
  802ceb:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	e9 4d 01 00 00       	jmp    802e45 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d01:	76 24                	jbe    802d27 <alloc_block_BF+0xf1>
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	8b 40 0c             	mov    0xc(%eax),%eax
  802d09:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d0c:	73 19                	jae    802d27 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802d0e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 40 08             	mov    0x8(%eax),%eax
  802d24:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802d27:	a1 40 51 80 00       	mov    0x805140,%eax
  802d2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d33:	74 07                	je     802d3c <alloc_block_BF+0x106>
  802d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	eb 05                	jmp    802d41 <alloc_block_BF+0x10b>
  802d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d41:	a3 40 51 80 00       	mov    %eax,0x805140
  802d46:	a1 40 51 80 00       	mov    0x805140,%eax
  802d4b:	85 c0                	test   %eax,%eax
  802d4d:	0f 85 fd fe ff ff    	jne    802c50 <alloc_block_BF+0x1a>
  802d53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d57:	0f 85 f3 fe ff ff    	jne    802c50 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802d5d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d61:	0f 84 d9 00 00 00    	je     802e40 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d67:	a1 48 51 80 00       	mov    0x805148,%eax
  802d6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802d6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d72:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d75:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d7e:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802d81:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d85:	75 17                	jne    802d9e <alloc_block_BF+0x168>
  802d87:	83 ec 04             	sub    $0x4,%esp
  802d8a:	68 04 48 80 00       	push   $0x804804
  802d8f:	68 c7 00 00 00       	push   $0xc7
  802d94:	68 5b 47 80 00       	push   $0x80475b
  802d99:	e8 17 dd ff ff       	call   800ab5 <_panic>
  802d9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da1:	8b 00                	mov    (%eax),%eax
  802da3:	85 c0                	test   %eax,%eax
  802da5:	74 10                	je     802db7 <alloc_block_BF+0x181>
  802da7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802daa:	8b 00                	mov    (%eax),%eax
  802dac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802daf:	8b 52 04             	mov    0x4(%edx),%edx
  802db2:	89 50 04             	mov    %edx,0x4(%eax)
  802db5:	eb 0b                	jmp    802dc2 <alloc_block_BF+0x18c>
  802db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dba:	8b 40 04             	mov    0x4(%eax),%eax
  802dbd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc5:	8b 40 04             	mov    0x4(%eax),%eax
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	74 0f                	je     802ddb <alloc_block_BF+0x1a5>
  802dcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dcf:	8b 40 04             	mov    0x4(%eax),%eax
  802dd2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dd5:	8b 12                	mov    (%edx),%edx
  802dd7:	89 10                	mov    %edx,(%eax)
  802dd9:	eb 0a                	jmp    802de5 <alloc_block_BF+0x1af>
  802ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dde:	8b 00                	mov    (%eax),%eax
  802de0:	a3 48 51 80 00       	mov    %eax,0x805148
  802de5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df8:	a1 54 51 80 00       	mov    0x805154,%eax
  802dfd:	48                   	dec    %eax
  802dfe:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802e03:	83 ec 08             	sub    $0x8,%esp
  802e06:	ff 75 ec             	pushl  -0x14(%ebp)
  802e09:	68 38 51 80 00       	push   $0x805138
  802e0e:	e8 71 f9 ff ff       	call   802784 <find_block>
  802e13:	83 c4 10             	add    $0x10,%esp
  802e16:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802e19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e1c:	8b 50 08             	mov    0x8(%eax),%edx
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	01 c2                	add    %eax,%edx
  802e24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e27:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802e2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e30:	2b 45 08             	sub    0x8(%ebp),%eax
  802e33:	89 c2                	mov    %eax,%edx
  802e35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e38:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802e3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3e:	eb 05                	jmp    802e45 <alloc_block_BF+0x20f>
	}
	return NULL;
  802e40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e45:	c9                   	leave  
  802e46:	c3                   	ret    

00802e47 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e47:	55                   	push   %ebp
  802e48:	89 e5                	mov    %esp,%ebp
  802e4a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802e4d:	a1 28 50 80 00       	mov    0x805028,%eax
  802e52:	85 c0                	test   %eax,%eax
  802e54:	0f 85 de 01 00 00    	jne    803038 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802e5a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e62:	e9 9e 01 00 00       	jmp    803005 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e70:	0f 82 87 01 00 00    	jb     802ffd <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e7f:	0f 85 95 00 00 00    	jne    802f1a <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802e85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e89:	75 17                	jne    802ea2 <alloc_block_NF+0x5b>
  802e8b:	83 ec 04             	sub    $0x4,%esp
  802e8e:	68 04 48 80 00       	push   $0x804804
  802e93:	68 e0 00 00 00       	push   $0xe0
  802e98:	68 5b 47 80 00       	push   $0x80475b
  802e9d:	e8 13 dc ff ff       	call   800ab5 <_panic>
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	8b 00                	mov    (%eax),%eax
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	74 10                	je     802ebb <alloc_block_NF+0x74>
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	8b 00                	mov    (%eax),%eax
  802eb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb3:	8b 52 04             	mov    0x4(%edx),%edx
  802eb6:	89 50 04             	mov    %edx,0x4(%eax)
  802eb9:	eb 0b                	jmp    802ec6 <alloc_block_NF+0x7f>
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	8b 40 04             	mov    0x4(%eax),%eax
  802ec1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	8b 40 04             	mov    0x4(%eax),%eax
  802ecc:	85 c0                	test   %eax,%eax
  802ece:	74 0f                	je     802edf <alloc_block_NF+0x98>
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 40 04             	mov    0x4(%eax),%eax
  802ed6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed9:	8b 12                	mov    (%edx),%edx
  802edb:	89 10                	mov    %edx,(%eax)
  802edd:	eb 0a                	jmp    802ee9 <alloc_block_NF+0xa2>
  802edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	a3 38 51 80 00       	mov    %eax,0x805138
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efc:	a1 44 51 80 00       	mov    0x805144,%eax
  802f01:	48                   	dec    %eax
  802f02:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 40 08             	mov    0x8(%eax),%eax
  802f0d:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	e9 f8 04 00 00       	jmp    803412 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f20:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f23:	0f 86 d4 00 00 00    	jbe    802ffd <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f29:	a1 48 51 80 00       	mov    0x805148,%eax
  802f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 50 08             	mov    0x8(%eax),%edx
  802f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3a:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f40:	8b 55 08             	mov    0x8(%ebp),%edx
  802f43:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f4a:	75 17                	jne    802f63 <alloc_block_NF+0x11c>
  802f4c:	83 ec 04             	sub    $0x4,%esp
  802f4f:	68 04 48 80 00       	push   $0x804804
  802f54:	68 e9 00 00 00       	push   $0xe9
  802f59:	68 5b 47 80 00       	push   $0x80475b
  802f5e:	e8 52 db ff ff       	call   800ab5 <_panic>
  802f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f66:	8b 00                	mov    (%eax),%eax
  802f68:	85 c0                	test   %eax,%eax
  802f6a:	74 10                	je     802f7c <alloc_block_NF+0x135>
  802f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6f:	8b 00                	mov    (%eax),%eax
  802f71:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f74:	8b 52 04             	mov    0x4(%edx),%edx
  802f77:	89 50 04             	mov    %edx,0x4(%eax)
  802f7a:	eb 0b                	jmp    802f87 <alloc_block_NF+0x140>
  802f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7f:	8b 40 04             	mov    0x4(%eax),%eax
  802f82:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8a:	8b 40 04             	mov    0x4(%eax),%eax
  802f8d:	85 c0                	test   %eax,%eax
  802f8f:	74 0f                	je     802fa0 <alloc_block_NF+0x159>
  802f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f94:	8b 40 04             	mov    0x4(%eax),%eax
  802f97:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f9a:	8b 12                	mov    (%edx),%edx
  802f9c:	89 10                	mov    %edx,(%eax)
  802f9e:	eb 0a                	jmp    802faa <alloc_block_NF+0x163>
  802fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa3:	8b 00                	mov    (%eax),%eax
  802fa5:	a3 48 51 80 00       	mov    %eax,0x805148
  802faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbd:	a1 54 51 80 00       	mov    0x805154,%eax
  802fc2:	48                   	dec    %eax
  802fc3:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcb:	8b 40 08             	mov    0x8(%eax),%eax
  802fce:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd6:	8b 50 08             	mov    0x8(%eax),%edx
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	01 c2                	add    %eax,%edx
  802fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe1:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fea:	2b 45 08             	sub    0x8(%ebp),%eax
  802fed:	89 c2                	mov    %eax,%edx
  802fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff2:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff8:	e9 15 04 00 00       	jmp    803412 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ffd:	a1 40 51 80 00       	mov    0x805140,%eax
  803002:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803005:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803009:	74 07                	je     803012 <alloc_block_NF+0x1cb>
  80300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300e:	8b 00                	mov    (%eax),%eax
  803010:	eb 05                	jmp    803017 <alloc_block_NF+0x1d0>
  803012:	b8 00 00 00 00       	mov    $0x0,%eax
  803017:	a3 40 51 80 00       	mov    %eax,0x805140
  80301c:	a1 40 51 80 00       	mov    0x805140,%eax
  803021:	85 c0                	test   %eax,%eax
  803023:	0f 85 3e fe ff ff    	jne    802e67 <alloc_block_NF+0x20>
  803029:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302d:	0f 85 34 fe ff ff    	jne    802e67 <alloc_block_NF+0x20>
  803033:	e9 d5 03 00 00       	jmp    80340d <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803038:	a1 38 51 80 00       	mov    0x805138,%eax
  80303d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803040:	e9 b1 01 00 00       	jmp    8031f6 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803048:	8b 50 08             	mov    0x8(%eax),%edx
  80304b:	a1 28 50 80 00       	mov    0x805028,%eax
  803050:	39 c2                	cmp    %eax,%edx
  803052:	0f 82 96 01 00 00    	jb     8031ee <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	8b 40 0c             	mov    0xc(%eax),%eax
  80305e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803061:	0f 82 87 01 00 00    	jb     8031ee <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306a:	8b 40 0c             	mov    0xc(%eax),%eax
  80306d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803070:	0f 85 95 00 00 00    	jne    80310b <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803076:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307a:	75 17                	jne    803093 <alloc_block_NF+0x24c>
  80307c:	83 ec 04             	sub    $0x4,%esp
  80307f:	68 04 48 80 00       	push   $0x804804
  803084:	68 fc 00 00 00       	push   $0xfc
  803089:	68 5b 47 80 00       	push   $0x80475b
  80308e:	e8 22 da ff ff       	call   800ab5 <_panic>
  803093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803096:	8b 00                	mov    (%eax),%eax
  803098:	85 c0                	test   %eax,%eax
  80309a:	74 10                	je     8030ac <alloc_block_NF+0x265>
  80309c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309f:	8b 00                	mov    (%eax),%eax
  8030a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a4:	8b 52 04             	mov    0x4(%edx),%edx
  8030a7:	89 50 04             	mov    %edx,0x4(%eax)
  8030aa:	eb 0b                	jmp    8030b7 <alloc_block_NF+0x270>
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	8b 40 04             	mov    0x4(%eax),%eax
  8030b2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	8b 40 04             	mov    0x4(%eax),%eax
  8030bd:	85 c0                	test   %eax,%eax
  8030bf:	74 0f                	je     8030d0 <alloc_block_NF+0x289>
  8030c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c4:	8b 40 04             	mov    0x4(%eax),%eax
  8030c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ca:	8b 12                	mov    (%edx),%edx
  8030cc:	89 10                	mov    %edx,(%eax)
  8030ce:	eb 0a                	jmp    8030da <alloc_block_NF+0x293>
  8030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d3:	8b 00                	mov    (%eax),%eax
  8030d5:	a3 38 51 80 00       	mov    %eax,0x805138
  8030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f2:	48                   	dec    %eax
  8030f3:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fb:	8b 40 08             	mov    0x8(%eax),%eax
  8030fe:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803106:	e9 07 03 00 00       	jmp    803412 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80310b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310e:	8b 40 0c             	mov    0xc(%eax),%eax
  803111:	3b 45 08             	cmp    0x8(%ebp),%eax
  803114:	0f 86 d4 00 00 00    	jbe    8031ee <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80311a:	a1 48 51 80 00       	mov    0x805148,%eax
  80311f:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	8b 50 08             	mov    0x8(%eax),%edx
  803128:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80312e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803131:	8b 55 08             	mov    0x8(%ebp),%edx
  803134:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803137:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80313b:	75 17                	jne    803154 <alloc_block_NF+0x30d>
  80313d:	83 ec 04             	sub    $0x4,%esp
  803140:	68 04 48 80 00       	push   $0x804804
  803145:	68 04 01 00 00       	push   $0x104
  80314a:	68 5b 47 80 00       	push   $0x80475b
  80314f:	e8 61 d9 ff ff       	call   800ab5 <_panic>
  803154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803157:	8b 00                	mov    (%eax),%eax
  803159:	85 c0                	test   %eax,%eax
  80315b:	74 10                	je     80316d <alloc_block_NF+0x326>
  80315d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803160:	8b 00                	mov    (%eax),%eax
  803162:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803165:	8b 52 04             	mov    0x4(%edx),%edx
  803168:	89 50 04             	mov    %edx,0x4(%eax)
  80316b:	eb 0b                	jmp    803178 <alloc_block_NF+0x331>
  80316d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803170:	8b 40 04             	mov    0x4(%eax),%eax
  803173:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317b:	8b 40 04             	mov    0x4(%eax),%eax
  80317e:	85 c0                	test   %eax,%eax
  803180:	74 0f                	je     803191 <alloc_block_NF+0x34a>
  803182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803185:	8b 40 04             	mov    0x4(%eax),%eax
  803188:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80318b:	8b 12                	mov    (%edx),%edx
  80318d:	89 10                	mov    %edx,(%eax)
  80318f:	eb 0a                	jmp    80319b <alloc_block_NF+0x354>
  803191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803194:	8b 00                	mov    (%eax),%eax
  803196:	a3 48 51 80 00       	mov    %eax,0x805148
  80319b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ae:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b3:	48                   	dec    %eax
  8031b4:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8031b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bc:	8b 40 08             	mov    0x8(%eax),%eax
  8031bf:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8031c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c7:	8b 50 08             	mov    0x8(%eax),%edx
  8031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cd:	01 c2                	add    %eax,%edx
  8031cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d2:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8031d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031db:	2b 45 08             	sub    0x8(%ebp),%eax
  8031de:	89 c2                	mov    %eax,%edx
  8031e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e3:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8031e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e9:	e9 24 02 00 00       	jmp    803412 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8031ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8031f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031fa:	74 07                	je     803203 <alloc_block_NF+0x3bc>
  8031fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ff:	8b 00                	mov    (%eax),%eax
  803201:	eb 05                	jmp    803208 <alloc_block_NF+0x3c1>
  803203:	b8 00 00 00 00       	mov    $0x0,%eax
  803208:	a3 40 51 80 00       	mov    %eax,0x805140
  80320d:	a1 40 51 80 00       	mov    0x805140,%eax
  803212:	85 c0                	test   %eax,%eax
  803214:	0f 85 2b fe ff ff    	jne    803045 <alloc_block_NF+0x1fe>
  80321a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80321e:	0f 85 21 fe ff ff    	jne    803045 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803224:	a1 38 51 80 00       	mov    0x805138,%eax
  803229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80322c:	e9 ae 01 00 00       	jmp    8033df <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803234:	8b 50 08             	mov    0x8(%eax),%edx
  803237:	a1 28 50 80 00       	mov    0x805028,%eax
  80323c:	39 c2                	cmp    %eax,%edx
  80323e:	0f 83 93 01 00 00    	jae    8033d7 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803247:	8b 40 0c             	mov    0xc(%eax),%eax
  80324a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80324d:	0f 82 84 01 00 00    	jb     8033d7 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803256:	8b 40 0c             	mov    0xc(%eax),%eax
  803259:	3b 45 08             	cmp    0x8(%ebp),%eax
  80325c:	0f 85 95 00 00 00    	jne    8032f7 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803262:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803266:	75 17                	jne    80327f <alloc_block_NF+0x438>
  803268:	83 ec 04             	sub    $0x4,%esp
  80326b:	68 04 48 80 00       	push   $0x804804
  803270:	68 14 01 00 00       	push   $0x114
  803275:	68 5b 47 80 00       	push   $0x80475b
  80327a:	e8 36 d8 ff ff       	call   800ab5 <_panic>
  80327f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803282:	8b 00                	mov    (%eax),%eax
  803284:	85 c0                	test   %eax,%eax
  803286:	74 10                	je     803298 <alloc_block_NF+0x451>
  803288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328b:	8b 00                	mov    (%eax),%eax
  80328d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803290:	8b 52 04             	mov    0x4(%edx),%edx
  803293:	89 50 04             	mov    %edx,0x4(%eax)
  803296:	eb 0b                	jmp    8032a3 <alloc_block_NF+0x45c>
  803298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329b:	8b 40 04             	mov    0x4(%eax),%eax
  80329e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a6:	8b 40 04             	mov    0x4(%eax),%eax
  8032a9:	85 c0                	test   %eax,%eax
  8032ab:	74 0f                	je     8032bc <alloc_block_NF+0x475>
  8032ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b0:	8b 40 04             	mov    0x4(%eax),%eax
  8032b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032b6:	8b 12                	mov    (%edx),%edx
  8032b8:	89 10                	mov    %edx,(%eax)
  8032ba:	eb 0a                	jmp    8032c6 <alloc_block_NF+0x47f>
  8032bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bf:	8b 00                	mov    (%eax),%eax
  8032c1:	a3 38 51 80 00       	mov    %eax,0x805138
  8032c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d9:	a1 44 51 80 00       	mov    0x805144,%eax
  8032de:	48                   	dec    %eax
  8032df:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e7:	8b 40 08             	mov    0x8(%eax),%eax
  8032ea:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8032ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f2:	e9 1b 01 00 00       	jmp    803412 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  803300:	0f 86 d1 00 00 00    	jbe    8033d7 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803306:	a1 48 51 80 00       	mov    0x805148,%eax
  80330b:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80330e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803311:	8b 50 08             	mov    0x8(%eax),%edx
  803314:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803317:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80331a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331d:	8b 55 08             	mov    0x8(%ebp),%edx
  803320:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803323:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803327:	75 17                	jne    803340 <alloc_block_NF+0x4f9>
  803329:	83 ec 04             	sub    $0x4,%esp
  80332c:	68 04 48 80 00       	push   $0x804804
  803331:	68 1c 01 00 00       	push   $0x11c
  803336:	68 5b 47 80 00       	push   $0x80475b
  80333b:	e8 75 d7 ff ff       	call   800ab5 <_panic>
  803340:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803343:	8b 00                	mov    (%eax),%eax
  803345:	85 c0                	test   %eax,%eax
  803347:	74 10                	je     803359 <alloc_block_NF+0x512>
  803349:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334c:	8b 00                	mov    (%eax),%eax
  80334e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803351:	8b 52 04             	mov    0x4(%edx),%edx
  803354:	89 50 04             	mov    %edx,0x4(%eax)
  803357:	eb 0b                	jmp    803364 <alloc_block_NF+0x51d>
  803359:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80335c:	8b 40 04             	mov    0x4(%eax),%eax
  80335f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803367:	8b 40 04             	mov    0x4(%eax),%eax
  80336a:	85 c0                	test   %eax,%eax
  80336c:	74 0f                	je     80337d <alloc_block_NF+0x536>
  80336e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803371:	8b 40 04             	mov    0x4(%eax),%eax
  803374:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803377:	8b 12                	mov    (%edx),%edx
  803379:	89 10                	mov    %edx,(%eax)
  80337b:	eb 0a                	jmp    803387 <alloc_block_NF+0x540>
  80337d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803380:	8b 00                	mov    (%eax),%eax
  803382:	a3 48 51 80 00       	mov    %eax,0x805148
  803387:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80338a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803390:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803393:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339a:	a1 54 51 80 00       	mov    0x805154,%eax
  80339f:	48                   	dec    %eax
  8033a0:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8033a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a8:	8b 40 08             	mov    0x8(%eax),%eax
  8033ab:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8033b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b3:	8b 50 08             	mov    0x8(%eax),%edx
  8033b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b9:	01 c2                	add    %eax,%edx
  8033bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033be:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8033c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c7:	2b 45 08             	sub    0x8(%ebp),%eax
  8033ca:	89 c2                	mov    %eax,%edx
  8033cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cf:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d5:	eb 3b                	jmp    803412 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033d7:	a1 40 51 80 00       	mov    0x805140,%eax
  8033dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e3:	74 07                	je     8033ec <alloc_block_NF+0x5a5>
  8033e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e8:	8b 00                	mov    (%eax),%eax
  8033ea:	eb 05                	jmp    8033f1 <alloc_block_NF+0x5aa>
  8033ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f1:	a3 40 51 80 00       	mov    %eax,0x805140
  8033f6:	a1 40 51 80 00       	mov    0x805140,%eax
  8033fb:	85 c0                	test   %eax,%eax
  8033fd:	0f 85 2e fe ff ff    	jne    803231 <alloc_block_NF+0x3ea>
  803403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803407:	0f 85 24 fe ff ff    	jne    803231 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80340d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803412:	c9                   	leave  
  803413:	c3                   	ret    

00803414 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803414:	55                   	push   %ebp
  803415:	89 e5                	mov    %esp,%ebp
  803417:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80341a:	a1 38 51 80 00       	mov    0x805138,%eax
  80341f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803422:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803427:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80342a:	a1 38 51 80 00       	mov    0x805138,%eax
  80342f:	85 c0                	test   %eax,%eax
  803431:	74 14                	je     803447 <insert_sorted_with_merge_freeList+0x33>
  803433:	8b 45 08             	mov    0x8(%ebp),%eax
  803436:	8b 50 08             	mov    0x8(%eax),%edx
  803439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80343c:	8b 40 08             	mov    0x8(%eax),%eax
  80343f:	39 c2                	cmp    %eax,%edx
  803441:	0f 87 9b 01 00 00    	ja     8035e2 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803447:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80344b:	75 17                	jne    803464 <insert_sorted_with_merge_freeList+0x50>
  80344d:	83 ec 04             	sub    $0x4,%esp
  803450:	68 38 47 80 00       	push   $0x804738
  803455:	68 38 01 00 00       	push   $0x138
  80345a:	68 5b 47 80 00       	push   $0x80475b
  80345f:	e8 51 d6 ff ff       	call   800ab5 <_panic>
  803464:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80346a:	8b 45 08             	mov    0x8(%ebp),%eax
  80346d:	89 10                	mov    %edx,(%eax)
  80346f:	8b 45 08             	mov    0x8(%ebp),%eax
  803472:	8b 00                	mov    (%eax),%eax
  803474:	85 c0                	test   %eax,%eax
  803476:	74 0d                	je     803485 <insert_sorted_with_merge_freeList+0x71>
  803478:	a1 38 51 80 00       	mov    0x805138,%eax
  80347d:	8b 55 08             	mov    0x8(%ebp),%edx
  803480:	89 50 04             	mov    %edx,0x4(%eax)
  803483:	eb 08                	jmp    80348d <insert_sorted_with_merge_freeList+0x79>
  803485:	8b 45 08             	mov    0x8(%ebp),%eax
  803488:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80348d:	8b 45 08             	mov    0x8(%ebp),%eax
  803490:	a3 38 51 80 00       	mov    %eax,0x805138
  803495:	8b 45 08             	mov    0x8(%ebp),%eax
  803498:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349f:	a1 44 51 80 00       	mov    0x805144,%eax
  8034a4:	40                   	inc    %eax
  8034a5:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034ae:	0f 84 a8 06 00 00    	je     803b5c <insert_sorted_with_merge_freeList+0x748>
  8034b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b7:	8b 50 08             	mov    0x8(%eax),%edx
  8034ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c0:	01 c2                	add    %eax,%edx
  8034c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c5:	8b 40 08             	mov    0x8(%eax),%eax
  8034c8:	39 c2                	cmp    %eax,%edx
  8034ca:	0f 85 8c 06 00 00    	jne    803b5c <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8034d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d3:	8b 50 0c             	mov    0xc(%eax),%edx
  8034d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8034dc:	01 c2                	add    %eax,%edx
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8034e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034e8:	75 17                	jne    803501 <insert_sorted_with_merge_freeList+0xed>
  8034ea:	83 ec 04             	sub    $0x4,%esp
  8034ed:	68 04 48 80 00       	push   $0x804804
  8034f2:	68 3c 01 00 00       	push   $0x13c
  8034f7:	68 5b 47 80 00       	push   $0x80475b
  8034fc:	e8 b4 d5 ff ff       	call   800ab5 <_panic>
  803501:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803504:	8b 00                	mov    (%eax),%eax
  803506:	85 c0                	test   %eax,%eax
  803508:	74 10                	je     80351a <insert_sorted_with_merge_freeList+0x106>
  80350a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350d:	8b 00                	mov    (%eax),%eax
  80350f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803512:	8b 52 04             	mov    0x4(%edx),%edx
  803515:	89 50 04             	mov    %edx,0x4(%eax)
  803518:	eb 0b                	jmp    803525 <insert_sorted_with_merge_freeList+0x111>
  80351a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80351d:	8b 40 04             	mov    0x4(%eax),%eax
  803520:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803528:	8b 40 04             	mov    0x4(%eax),%eax
  80352b:	85 c0                	test   %eax,%eax
  80352d:	74 0f                	je     80353e <insert_sorted_with_merge_freeList+0x12a>
  80352f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803532:	8b 40 04             	mov    0x4(%eax),%eax
  803535:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803538:	8b 12                	mov    (%edx),%edx
  80353a:	89 10                	mov    %edx,(%eax)
  80353c:	eb 0a                	jmp    803548 <insert_sorted_with_merge_freeList+0x134>
  80353e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803541:	8b 00                	mov    (%eax),%eax
  803543:	a3 38 51 80 00       	mov    %eax,0x805138
  803548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80354b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80355b:	a1 44 51 80 00       	mov    0x805144,%eax
  803560:	48                   	dec    %eax
  803561:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803569:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803573:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80357a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80357e:	75 17                	jne    803597 <insert_sorted_with_merge_freeList+0x183>
  803580:	83 ec 04             	sub    $0x4,%esp
  803583:	68 38 47 80 00       	push   $0x804738
  803588:	68 3f 01 00 00       	push   $0x13f
  80358d:	68 5b 47 80 00       	push   $0x80475b
  803592:	e8 1e d5 ff ff       	call   800ab5 <_panic>
  803597:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80359d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a0:	89 10                	mov    %edx,(%eax)
  8035a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a5:	8b 00                	mov    (%eax),%eax
  8035a7:	85 c0                	test   %eax,%eax
  8035a9:	74 0d                	je     8035b8 <insert_sorted_with_merge_freeList+0x1a4>
  8035ab:	a1 48 51 80 00       	mov    0x805148,%eax
  8035b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035b3:	89 50 04             	mov    %edx,0x4(%eax)
  8035b6:	eb 08                	jmp    8035c0 <insert_sorted_with_merge_freeList+0x1ac>
  8035b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035bb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c3:	a3 48 51 80 00       	mov    %eax,0x805148
  8035c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d2:	a1 54 51 80 00       	mov    0x805154,%eax
  8035d7:	40                   	inc    %eax
  8035d8:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035dd:	e9 7a 05 00 00       	jmp    803b5c <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8035e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e5:	8b 50 08             	mov    0x8(%eax),%edx
  8035e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035eb:	8b 40 08             	mov    0x8(%eax),%eax
  8035ee:	39 c2                	cmp    %eax,%edx
  8035f0:	0f 82 14 01 00 00    	jb     80370a <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8035f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f9:	8b 50 08             	mov    0x8(%eax),%edx
  8035fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803602:	01 c2                	add    %eax,%edx
  803604:	8b 45 08             	mov    0x8(%ebp),%eax
  803607:	8b 40 08             	mov    0x8(%eax),%eax
  80360a:	39 c2                	cmp    %eax,%edx
  80360c:	0f 85 90 00 00 00    	jne    8036a2 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803612:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803615:	8b 50 0c             	mov    0xc(%eax),%edx
  803618:	8b 45 08             	mov    0x8(%ebp),%eax
  80361b:	8b 40 0c             	mov    0xc(%eax),%eax
  80361e:	01 c2                	add    %eax,%edx
  803620:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803623:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803626:	8b 45 08             	mov    0x8(%ebp),%eax
  803629:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803630:	8b 45 08             	mov    0x8(%ebp),%eax
  803633:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80363a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80363e:	75 17                	jne    803657 <insert_sorted_with_merge_freeList+0x243>
  803640:	83 ec 04             	sub    $0x4,%esp
  803643:	68 38 47 80 00       	push   $0x804738
  803648:	68 49 01 00 00       	push   $0x149
  80364d:	68 5b 47 80 00       	push   $0x80475b
  803652:	e8 5e d4 ff ff       	call   800ab5 <_panic>
  803657:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80365d:	8b 45 08             	mov    0x8(%ebp),%eax
  803660:	89 10                	mov    %edx,(%eax)
  803662:	8b 45 08             	mov    0x8(%ebp),%eax
  803665:	8b 00                	mov    (%eax),%eax
  803667:	85 c0                	test   %eax,%eax
  803669:	74 0d                	je     803678 <insert_sorted_with_merge_freeList+0x264>
  80366b:	a1 48 51 80 00       	mov    0x805148,%eax
  803670:	8b 55 08             	mov    0x8(%ebp),%edx
  803673:	89 50 04             	mov    %edx,0x4(%eax)
  803676:	eb 08                	jmp    803680 <insert_sorted_with_merge_freeList+0x26c>
  803678:	8b 45 08             	mov    0x8(%ebp),%eax
  80367b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803680:	8b 45 08             	mov    0x8(%ebp),%eax
  803683:	a3 48 51 80 00       	mov    %eax,0x805148
  803688:	8b 45 08             	mov    0x8(%ebp),%eax
  80368b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803692:	a1 54 51 80 00       	mov    0x805154,%eax
  803697:	40                   	inc    %eax
  803698:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80369d:	e9 bb 04 00 00       	jmp    803b5d <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8036a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036a6:	75 17                	jne    8036bf <insert_sorted_with_merge_freeList+0x2ab>
  8036a8:	83 ec 04             	sub    $0x4,%esp
  8036ab:	68 ac 47 80 00       	push   $0x8047ac
  8036b0:	68 4c 01 00 00       	push   $0x14c
  8036b5:	68 5b 47 80 00       	push   $0x80475b
  8036ba:	e8 f6 d3 ff ff       	call   800ab5 <_panic>
  8036bf:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8036c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c8:	89 50 04             	mov    %edx,0x4(%eax)
  8036cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ce:	8b 40 04             	mov    0x4(%eax),%eax
  8036d1:	85 c0                	test   %eax,%eax
  8036d3:	74 0c                	je     8036e1 <insert_sorted_with_merge_freeList+0x2cd>
  8036d5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8036da:	8b 55 08             	mov    0x8(%ebp),%edx
  8036dd:	89 10                	mov    %edx,(%eax)
  8036df:	eb 08                	jmp    8036e9 <insert_sorted_with_merge_freeList+0x2d5>
  8036e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e4:	a3 38 51 80 00       	mov    %eax,0x805138
  8036e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036fa:	a1 44 51 80 00       	mov    0x805144,%eax
  8036ff:	40                   	inc    %eax
  803700:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803705:	e9 53 04 00 00       	jmp    803b5d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80370a:	a1 38 51 80 00       	mov    0x805138,%eax
  80370f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803712:	e9 15 04 00 00       	jmp    803b2c <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371a:	8b 00                	mov    (%eax),%eax
  80371c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80371f:	8b 45 08             	mov    0x8(%ebp),%eax
  803722:	8b 50 08             	mov    0x8(%eax),%edx
  803725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803728:	8b 40 08             	mov    0x8(%eax),%eax
  80372b:	39 c2                	cmp    %eax,%edx
  80372d:	0f 86 f1 03 00 00    	jbe    803b24 <insert_sorted_with_merge_freeList+0x710>
  803733:	8b 45 08             	mov    0x8(%ebp),%eax
  803736:	8b 50 08             	mov    0x8(%eax),%edx
  803739:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373c:	8b 40 08             	mov    0x8(%eax),%eax
  80373f:	39 c2                	cmp    %eax,%edx
  803741:	0f 83 dd 03 00 00    	jae    803b24 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374a:	8b 50 08             	mov    0x8(%eax),%edx
  80374d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803750:	8b 40 0c             	mov    0xc(%eax),%eax
  803753:	01 c2                	add    %eax,%edx
  803755:	8b 45 08             	mov    0x8(%ebp),%eax
  803758:	8b 40 08             	mov    0x8(%eax),%eax
  80375b:	39 c2                	cmp    %eax,%edx
  80375d:	0f 85 b9 01 00 00    	jne    80391c <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803763:	8b 45 08             	mov    0x8(%ebp),%eax
  803766:	8b 50 08             	mov    0x8(%eax),%edx
  803769:	8b 45 08             	mov    0x8(%ebp),%eax
  80376c:	8b 40 0c             	mov    0xc(%eax),%eax
  80376f:	01 c2                	add    %eax,%edx
  803771:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803774:	8b 40 08             	mov    0x8(%eax),%eax
  803777:	39 c2                	cmp    %eax,%edx
  803779:	0f 85 0d 01 00 00    	jne    80388c <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80377f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803782:	8b 50 0c             	mov    0xc(%eax),%edx
  803785:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803788:	8b 40 0c             	mov    0xc(%eax),%eax
  80378b:	01 c2                	add    %eax,%edx
  80378d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803790:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803793:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803797:	75 17                	jne    8037b0 <insert_sorted_with_merge_freeList+0x39c>
  803799:	83 ec 04             	sub    $0x4,%esp
  80379c:	68 04 48 80 00       	push   $0x804804
  8037a1:	68 5c 01 00 00       	push   $0x15c
  8037a6:	68 5b 47 80 00       	push   $0x80475b
  8037ab:	e8 05 d3 ff ff       	call   800ab5 <_panic>
  8037b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b3:	8b 00                	mov    (%eax),%eax
  8037b5:	85 c0                	test   %eax,%eax
  8037b7:	74 10                	je     8037c9 <insert_sorted_with_merge_freeList+0x3b5>
  8037b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037bc:	8b 00                	mov    (%eax),%eax
  8037be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037c1:	8b 52 04             	mov    0x4(%edx),%edx
  8037c4:	89 50 04             	mov    %edx,0x4(%eax)
  8037c7:	eb 0b                	jmp    8037d4 <insert_sorted_with_merge_freeList+0x3c0>
  8037c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037cc:	8b 40 04             	mov    0x4(%eax),%eax
  8037cf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d7:	8b 40 04             	mov    0x4(%eax),%eax
  8037da:	85 c0                	test   %eax,%eax
  8037dc:	74 0f                	je     8037ed <insert_sorted_with_merge_freeList+0x3d9>
  8037de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e1:	8b 40 04             	mov    0x4(%eax),%eax
  8037e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037e7:	8b 12                	mov    (%edx),%edx
  8037e9:	89 10                	mov    %edx,(%eax)
  8037eb:	eb 0a                	jmp    8037f7 <insert_sorted_with_merge_freeList+0x3e3>
  8037ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f0:	8b 00                	mov    (%eax),%eax
  8037f2:	a3 38 51 80 00       	mov    %eax,0x805138
  8037f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803803:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80380a:	a1 44 51 80 00       	mov    0x805144,%eax
  80380f:	48                   	dec    %eax
  803810:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803815:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803818:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80381f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803822:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803829:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80382d:	75 17                	jne    803846 <insert_sorted_with_merge_freeList+0x432>
  80382f:	83 ec 04             	sub    $0x4,%esp
  803832:	68 38 47 80 00       	push   $0x804738
  803837:	68 5f 01 00 00       	push   $0x15f
  80383c:	68 5b 47 80 00       	push   $0x80475b
  803841:	e8 6f d2 ff ff       	call   800ab5 <_panic>
  803846:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80384c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384f:	89 10                	mov    %edx,(%eax)
  803851:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803854:	8b 00                	mov    (%eax),%eax
  803856:	85 c0                	test   %eax,%eax
  803858:	74 0d                	je     803867 <insert_sorted_with_merge_freeList+0x453>
  80385a:	a1 48 51 80 00       	mov    0x805148,%eax
  80385f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803862:	89 50 04             	mov    %edx,0x4(%eax)
  803865:	eb 08                	jmp    80386f <insert_sorted_with_merge_freeList+0x45b>
  803867:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80386a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80386f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803872:	a3 48 51 80 00       	mov    %eax,0x805148
  803877:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803881:	a1 54 51 80 00       	mov    0x805154,%eax
  803886:	40                   	inc    %eax
  803887:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80388c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388f:	8b 50 0c             	mov    0xc(%eax),%edx
  803892:	8b 45 08             	mov    0x8(%ebp),%eax
  803895:	8b 40 0c             	mov    0xc(%eax),%eax
  803898:	01 c2                	add    %eax,%edx
  80389a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8038a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8038aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ad:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8038b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038b8:	75 17                	jne    8038d1 <insert_sorted_with_merge_freeList+0x4bd>
  8038ba:	83 ec 04             	sub    $0x4,%esp
  8038bd:	68 38 47 80 00       	push   $0x804738
  8038c2:	68 64 01 00 00       	push   $0x164
  8038c7:	68 5b 47 80 00       	push   $0x80475b
  8038cc:	e8 e4 d1 ff ff       	call   800ab5 <_panic>
  8038d1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038da:	89 10                	mov    %edx,(%eax)
  8038dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038df:	8b 00                	mov    (%eax),%eax
  8038e1:	85 c0                	test   %eax,%eax
  8038e3:	74 0d                	je     8038f2 <insert_sorted_with_merge_freeList+0x4de>
  8038e5:	a1 48 51 80 00       	mov    0x805148,%eax
  8038ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8038ed:	89 50 04             	mov    %edx,0x4(%eax)
  8038f0:	eb 08                	jmp    8038fa <insert_sorted_with_merge_freeList+0x4e6>
  8038f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fd:	a3 48 51 80 00       	mov    %eax,0x805148
  803902:	8b 45 08             	mov    0x8(%ebp),%eax
  803905:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80390c:	a1 54 51 80 00       	mov    0x805154,%eax
  803911:	40                   	inc    %eax
  803912:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803917:	e9 41 02 00 00       	jmp    803b5d <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80391c:	8b 45 08             	mov    0x8(%ebp),%eax
  80391f:	8b 50 08             	mov    0x8(%eax),%edx
  803922:	8b 45 08             	mov    0x8(%ebp),%eax
  803925:	8b 40 0c             	mov    0xc(%eax),%eax
  803928:	01 c2                	add    %eax,%edx
  80392a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80392d:	8b 40 08             	mov    0x8(%eax),%eax
  803930:	39 c2                	cmp    %eax,%edx
  803932:	0f 85 7c 01 00 00    	jne    803ab4 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803938:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80393c:	74 06                	je     803944 <insert_sorted_with_merge_freeList+0x530>
  80393e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803942:	75 17                	jne    80395b <insert_sorted_with_merge_freeList+0x547>
  803944:	83 ec 04             	sub    $0x4,%esp
  803947:	68 74 47 80 00       	push   $0x804774
  80394c:	68 69 01 00 00       	push   $0x169
  803951:	68 5b 47 80 00       	push   $0x80475b
  803956:	e8 5a d1 ff ff       	call   800ab5 <_panic>
  80395b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80395e:	8b 50 04             	mov    0x4(%eax),%edx
  803961:	8b 45 08             	mov    0x8(%ebp),%eax
  803964:	89 50 04             	mov    %edx,0x4(%eax)
  803967:	8b 45 08             	mov    0x8(%ebp),%eax
  80396a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80396d:	89 10                	mov    %edx,(%eax)
  80396f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803972:	8b 40 04             	mov    0x4(%eax),%eax
  803975:	85 c0                	test   %eax,%eax
  803977:	74 0d                	je     803986 <insert_sorted_with_merge_freeList+0x572>
  803979:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397c:	8b 40 04             	mov    0x4(%eax),%eax
  80397f:	8b 55 08             	mov    0x8(%ebp),%edx
  803982:	89 10                	mov    %edx,(%eax)
  803984:	eb 08                	jmp    80398e <insert_sorted_with_merge_freeList+0x57a>
  803986:	8b 45 08             	mov    0x8(%ebp),%eax
  803989:	a3 38 51 80 00       	mov    %eax,0x805138
  80398e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803991:	8b 55 08             	mov    0x8(%ebp),%edx
  803994:	89 50 04             	mov    %edx,0x4(%eax)
  803997:	a1 44 51 80 00       	mov    0x805144,%eax
  80399c:	40                   	inc    %eax
  80399d:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8039a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a5:	8b 50 0c             	mov    0xc(%eax),%edx
  8039a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8039ae:	01 c2                	add    %eax,%edx
  8039b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b3:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8039b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039ba:	75 17                	jne    8039d3 <insert_sorted_with_merge_freeList+0x5bf>
  8039bc:	83 ec 04             	sub    $0x4,%esp
  8039bf:	68 04 48 80 00       	push   $0x804804
  8039c4:	68 6b 01 00 00       	push   $0x16b
  8039c9:	68 5b 47 80 00       	push   $0x80475b
  8039ce:	e8 e2 d0 ff ff       	call   800ab5 <_panic>
  8039d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d6:	8b 00                	mov    (%eax),%eax
  8039d8:	85 c0                	test   %eax,%eax
  8039da:	74 10                	je     8039ec <insert_sorted_with_merge_freeList+0x5d8>
  8039dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039df:	8b 00                	mov    (%eax),%eax
  8039e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039e4:	8b 52 04             	mov    0x4(%edx),%edx
  8039e7:	89 50 04             	mov    %edx,0x4(%eax)
  8039ea:	eb 0b                	jmp    8039f7 <insert_sorted_with_merge_freeList+0x5e3>
  8039ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ef:	8b 40 04             	mov    0x4(%eax),%eax
  8039f2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039fa:	8b 40 04             	mov    0x4(%eax),%eax
  8039fd:	85 c0                	test   %eax,%eax
  8039ff:	74 0f                	je     803a10 <insert_sorted_with_merge_freeList+0x5fc>
  803a01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a04:	8b 40 04             	mov    0x4(%eax),%eax
  803a07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a0a:	8b 12                	mov    (%edx),%edx
  803a0c:	89 10                	mov    %edx,(%eax)
  803a0e:	eb 0a                	jmp    803a1a <insert_sorted_with_merge_freeList+0x606>
  803a10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a13:	8b 00                	mov    (%eax),%eax
  803a15:	a3 38 51 80 00       	mov    %eax,0x805138
  803a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a2d:	a1 44 51 80 00       	mov    0x805144,%eax
  803a32:	48                   	dec    %eax
  803a33:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803a38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803a42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a45:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a4c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a50:	75 17                	jne    803a69 <insert_sorted_with_merge_freeList+0x655>
  803a52:	83 ec 04             	sub    $0x4,%esp
  803a55:	68 38 47 80 00       	push   $0x804738
  803a5a:	68 6e 01 00 00       	push   $0x16e
  803a5f:	68 5b 47 80 00       	push   $0x80475b
  803a64:	e8 4c d0 ff ff       	call   800ab5 <_panic>
  803a69:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a72:	89 10                	mov    %edx,(%eax)
  803a74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a77:	8b 00                	mov    (%eax),%eax
  803a79:	85 c0                	test   %eax,%eax
  803a7b:	74 0d                	je     803a8a <insert_sorted_with_merge_freeList+0x676>
  803a7d:	a1 48 51 80 00       	mov    0x805148,%eax
  803a82:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a85:	89 50 04             	mov    %edx,0x4(%eax)
  803a88:	eb 08                	jmp    803a92 <insert_sorted_with_merge_freeList+0x67e>
  803a8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a8d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a95:	a3 48 51 80 00       	mov    %eax,0x805148
  803a9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aa4:	a1 54 51 80 00       	mov    0x805154,%eax
  803aa9:	40                   	inc    %eax
  803aaa:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803aaf:	e9 a9 00 00 00       	jmp    803b5d <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803ab4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ab8:	74 06                	je     803ac0 <insert_sorted_with_merge_freeList+0x6ac>
  803aba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803abe:	75 17                	jne    803ad7 <insert_sorted_with_merge_freeList+0x6c3>
  803ac0:	83 ec 04             	sub    $0x4,%esp
  803ac3:	68 d0 47 80 00       	push   $0x8047d0
  803ac8:	68 73 01 00 00       	push   $0x173
  803acd:	68 5b 47 80 00       	push   $0x80475b
  803ad2:	e8 de cf ff ff       	call   800ab5 <_panic>
  803ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ada:	8b 10                	mov    (%eax),%edx
  803adc:	8b 45 08             	mov    0x8(%ebp),%eax
  803adf:	89 10                	mov    %edx,(%eax)
  803ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae4:	8b 00                	mov    (%eax),%eax
  803ae6:	85 c0                	test   %eax,%eax
  803ae8:	74 0b                	je     803af5 <insert_sorted_with_merge_freeList+0x6e1>
  803aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aed:	8b 00                	mov    (%eax),%eax
  803aef:	8b 55 08             	mov    0x8(%ebp),%edx
  803af2:	89 50 04             	mov    %edx,0x4(%eax)
  803af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af8:	8b 55 08             	mov    0x8(%ebp),%edx
  803afb:	89 10                	mov    %edx,(%eax)
  803afd:	8b 45 08             	mov    0x8(%ebp),%eax
  803b00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b03:	89 50 04             	mov    %edx,0x4(%eax)
  803b06:	8b 45 08             	mov    0x8(%ebp),%eax
  803b09:	8b 00                	mov    (%eax),%eax
  803b0b:	85 c0                	test   %eax,%eax
  803b0d:	75 08                	jne    803b17 <insert_sorted_with_merge_freeList+0x703>
  803b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b12:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b17:	a1 44 51 80 00       	mov    0x805144,%eax
  803b1c:	40                   	inc    %eax
  803b1d:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803b22:	eb 39                	jmp    803b5d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803b24:	a1 40 51 80 00       	mov    0x805140,%eax
  803b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b30:	74 07                	je     803b39 <insert_sorted_with_merge_freeList+0x725>
  803b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b35:	8b 00                	mov    (%eax),%eax
  803b37:	eb 05                	jmp    803b3e <insert_sorted_with_merge_freeList+0x72a>
  803b39:	b8 00 00 00 00       	mov    $0x0,%eax
  803b3e:	a3 40 51 80 00       	mov    %eax,0x805140
  803b43:	a1 40 51 80 00       	mov    0x805140,%eax
  803b48:	85 c0                	test   %eax,%eax
  803b4a:	0f 85 c7 fb ff ff    	jne    803717 <insert_sorted_with_merge_freeList+0x303>
  803b50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b54:	0f 85 bd fb ff ff    	jne    803717 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b5a:	eb 01                	jmp    803b5d <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803b5c:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b5d:	90                   	nop
  803b5e:	c9                   	leave  
  803b5f:	c3                   	ret    

00803b60 <__udivdi3>:
  803b60:	55                   	push   %ebp
  803b61:	57                   	push   %edi
  803b62:	56                   	push   %esi
  803b63:	53                   	push   %ebx
  803b64:	83 ec 1c             	sub    $0x1c,%esp
  803b67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b77:	89 ca                	mov    %ecx,%edx
  803b79:	89 f8                	mov    %edi,%eax
  803b7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b7f:	85 f6                	test   %esi,%esi
  803b81:	75 2d                	jne    803bb0 <__udivdi3+0x50>
  803b83:	39 cf                	cmp    %ecx,%edi
  803b85:	77 65                	ja     803bec <__udivdi3+0x8c>
  803b87:	89 fd                	mov    %edi,%ebp
  803b89:	85 ff                	test   %edi,%edi
  803b8b:	75 0b                	jne    803b98 <__udivdi3+0x38>
  803b8d:	b8 01 00 00 00       	mov    $0x1,%eax
  803b92:	31 d2                	xor    %edx,%edx
  803b94:	f7 f7                	div    %edi
  803b96:	89 c5                	mov    %eax,%ebp
  803b98:	31 d2                	xor    %edx,%edx
  803b9a:	89 c8                	mov    %ecx,%eax
  803b9c:	f7 f5                	div    %ebp
  803b9e:	89 c1                	mov    %eax,%ecx
  803ba0:	89 d8                	mov    %ebx,%eax
  803ba2:	f7 f5                	div    %ebp
  803ba4:	89 cf                	mov    %ecx,%edi
  803ba6:	89 fa                	mov    %edi,%edx
  803ba8:	83 c4 1c             	add    $0x1c,%esp
  803bab:	5b                   	pop    %ebx
  803bac:	5e                   	pop    %esi
  803bad:	5f                   	pop    %edi
  803bae:	5d                   	pop    %ebp
  803baf:	c3                   	ret    
  803bb0:	39 ce                	cmp    %ecx,%esi
  803bb2:	77 28                	ja     803bdc <__udivdi3+0x7c>
  803bb4:	0f bd fe             	bsr    %esi,%edi
  803bb7:	83 f7 1f             	xor    $0x1f,%edi
  803bba:	75 40                	jne    803bfc <__udivdi3+0x9c>
  803bbc:	39 ce                	cmp    %ecx,%esi
  803bbe:	72 0a                	jb     803bca <__udivdi3+0x6a>
  803bc0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bc4:	0f 87 9e 00 00 00    	ja     803c68 <__udivdi3+0x108>
  803bca:	b8 01 00 00 00       	mov    $0x1,%eax
  803bcf:	89 fa                	mov    %edi,%edx
  803bd1:	83 c4 1c             	add    $0x1c,%esp
  803bd4:	5b                   	pop    %ebx
  803bd5:	5e                   	pop    %esi
  803bd6:	5f                   	pop    %edi
  803bd7:	5d                   	pop    %ebp
  803bd8:	c3                   	ret    
  803bd9:	8d 76 00             	lea    0x0(%esi),%esi
  803bdc:	31 ff                	xor    %edi,%edi
  803bde:	31 c0                	xor    %eax,%eax
  803be0:	89 fa                	mov    %edi,%edx
  803be2:	83 c4 1c             	add    $0x1c,%esp
  803be5:	5b                   	pop    %ebx
  803be6:	5e                   	pop    %esi
  803be7:	5f                   	pop    %edi
  803be8:	5d                   	pop    %ebp
  803be9:	c3                   	ret    
  803bea:	66 90                	xchg   %ax,%ax
  803bec:	89 d8                	mov    %ebx,%eax
  803bee:	f7 f7                	div    %edi
  803bf0:	31 ff                	xor    %edi,%edi
  803bf2:	89 fa                	mov    %edi,%edx
  803bf4:	83 c4 1c             	add    $0x1c,%esp
  803bf7:	5b                   	pop    %ebx
  803bf8:	5e                   	pop    %esi
  803bf9:	5f                   	pop    %edi
  803bfa:	5d                   	pop    %ebp
  803bfb:	c3                   	ret    
  803bfc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c01:	89 eb                	mov    %ebp,%ebx
  803c03:	29 fb                	sub    %edi,%ebx
  803c05:	89 f9                	mov    %edi,%ecx
  803c07:	d3 e6                	shl    %cl,%esi
  803c09:	89 c5                	mov    %eax,%ebp
  803c0b:	88 d9                	mov    %bl,%cl
  803c0d:	d3 ed                	shr    %cl,%ebp
  803c0f:	89 e9                	mov    %ebp,%ecx
  803c11:	09 f1                	or     %esi,%ecx
  803c13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c17:	89 f9                	mov    %edi,%ecx
  803c19:	d3 e0                	shl    %cl,%eax
  803c1b:	89 c5                	mov    %eax,%ebp
  803c1d:	89 d6                	mov    %edx,%esi
  803c1f:	88 d9                	mov    %bl,%cl
  803c21:	d3 ee                	shr    %cl,%esi
  803c23:	89 f9                	mov    %edi,%ecx
  803c25:	d3 e2                	shl    %cl,%edx
  803c27:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c2b:	88 d9                	mov    %bl,%cl
  803c2d:	d3 e8                	shr    %cl,%eax
  803c2f:	09 c2                	or     %eax,%edx
  803c31:	89 d0                	mov    %edx,%eax
  803c33:	89 f2                	mov    %esi,%edx
  803c35:	f7 74 24 0c          	divl   0xc(%esp)
  803c39:	89 d6                	mov    %edx,%esi
  803c3b:	89 c3                	mov    %eax,%ebx
  803c3d:	f7 e5                	mul    %ebp
  803c3f:	39 d6                	cmp    %edx,%esi
  803c41:	72 19                	jb     803c5c <__udivdi3+0xfc>
  803c43:	74 0b                	je     803c50 <__udivdi3+0xf0>
  803c45:	89 d8                	mov    %ebx,%eax
  803c47:	31 ff                	xor    %edi,%edi
  803c49:	e9 58 ff ff ff       	jmp    803ba6 <__udivdi3+0x46>
  803c4e:	66 90                	xchg   %ax,%ax
  803c50:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c54:	89 f9                	mov    %edi,%ecx
  803c56:	d3 e2                	shl    %cl,%edx
  803c58:	39 c2                	cmp    %eax,%edx
  803c5a:	73 e9                	jae    803c45 <__udivdi3+0xe5>
  803c5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c5f:	31 ff                	xor    %edi,%edi
  803c61:	e9 40 ff ff ff       	jmp    803ba6 <__udivdi3+0x46>
  803c66:	66 90                	xchg   %ax,%ax
  803c68:	31 c0                	xor    %eax,%eax
  803c6a:	e9 37 ff ff ff       	jmp    803ba6 <__udivdi3+0x46>
  803c6f:	90                   	nop

00803c70 <__umoddi3>:
  803c70:	55                   	push   %ebp
  803c71:	57                   	push   %edi
  803c72:	56                   	push   %esi
  803c73:	53                   	push   %ebx
  803c74:	83 ec 1c             	sub    $0x1c,%esp
  803c77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c8f:	89 f3                	mov    %esi,%ebx
  803c91:	89 fa                	mov    %edi,%edx
  803c93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c97:	89 34 24             	mov    %esi,(%esp)
  803c9a:	85 c0                	test   %eax,%eax
  803c9c:	75 1a                	jne    803cb8 <__umoddi3+0x48>
  803c9e:	39 f7                	cmp    %esi,%edi
  803ca0:	0f 86 a2 00 00 00    	jbe    803d48 <__umoddi3+0xd8>
  803ca6:	89 c8                	mov    %ecx,%eax
  803ca8:	89 f2                	mov    %esi,%edx
  803caa:	f7 f7                	div    %edi
  803cac:	89 d0                	mov    %edx,%eax
  803cae:	31 d2                	xor    %edx,%edx
  803cb0:	83 c4 1c             	add    $0x1c,%esp
  803cb3:	5b                   	pop    %ebx
  803cb4:	5e                   	pop    %esi
  803cb5:	5f                   	pop    %edi
  803cb6:	5d                   	pop    %ebp
  803cb7:	c3                   	ret    
  803cb8:	39 f0                	cmp    %esi,%eax
  803cba:	0f 87 ac 00 00 00    	ja     803d6c <__umoddi3+0xfc>
  803cc0:	0f bd e8             	bsr    %eax,%ebp
  803cc3:	83 f5 1f             	xor    $0x1f,%ebp
  803cc6:	0f 84 ac 00 00 00    	je     803d78 <__umoddi3+0x108>
  803ccc:	bf 20 00 00 00       	mov    $0x20,%edi
  803cd1:	29 ef                	sub    %ebp,%edi
  803cd3:	89 fe                	mov    %edi,%esi
  803cd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cd9:	89 e9                	mov    %ebp,%ecx
  803cdb:	d3 e0                	shl    %cl,%eax
  803cdd:	89 d7                	mov    %edx,%edi
  803cdf:	89 f1                	mov    %esi,%ecx
  803ce1:	d3 ef                	shr    %cl,%edi
  803ce3:	09 c7                	or     %eax,%edi
  803ce5:	89 e9                	mov    %ebp,%ecx
  803ce7:	d3 e2                	shl    %cl,%edx
  803ce9:	89 14 24             	mov    %edx,(%esp)
  803cec:	89 d8                	mov    %ebx,%eax
  803cee:	d3 e0                	shl    %cl,%eax
  803cf0:	89 c2                	mov    %eax,%edx
  803cf2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cf6:	d3 e0                	shl    %cl,%eax
  803cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cfc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d00:	89 f1                	mov    %esi,%ecx
  803d02:	d3 e8                	shr    %cl,%eax
  803d04:	09 d0                	or     %edx,%eax
  803d06:	d3 eb                	shr    %cl,%ebx
  803d08:	89 da                	mov    %ebx,%edx
  803d0a:	f7 f7                	div    %edi
  803d0c:	89 d3                	mov    %edx,%ebx
  803d0e:	f7 24 24             	mull   (%esp)
  803d11:	89 c6                	mov    %eax,%esi
  803d13:	89 d1                	mov    %edx,%ecx
  803d15:	39 d3                	cmp    %edx,%ebx
  803d17:	0f 82 87 00 00 00    	jb     803da4 <__umoddi3+0x134>
  803d1d:	0f 84 91 00 00 00    	je     803db4 <__umoddi3+0x144>
  803d23:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d27:	29 f2                	sub    %esi,%edx
  803d29:	19 cb                	sbb    %ecx,%ebx
  803d2b:	89 d8                	mov    %ebx,%eax
  803d2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d31:	d3 e0                	shl    %cl,%eax
  803d33:	89 e9                	mov    %ebp,%ecx
  803d35:	d3 ea                	shr    %cl,%edx
  803d37:	09 d0                	or     %edx,%eax
  803d39:	89 e9                	mov    %ebp,%ecx
  803d3b:	d3 eb                	shr    %cl,%ebx
  803d3d:	89 da                	mov    %ebx,%edx
  803d3f:	83 c4 1c             	add    $0x1c,%esp
  803d42:	5b                   	pop    %ebx
  803d43:	5e                   	pop    %esi
  803d44:	5f                   	pop    %edi
  803d45:	5d                   	pop    %ebp
  803d46:	c3                   	ret    
  803d47:	90                   	nop
  803d48:	89 fd                	mov    %edi,%ebp
  803d4a:	85 ff                	test   %edi,%edi
  803d4c:	75 0b                	jne    803d59 <__umoddi3+0xe9>
  803d4e:	b8 01 00 00 00       	mov    $0x1,%eax
  803d53:	31 d2                	xor    %edx,%edx
  803d55:	f7 f7                	div    %edi
  803d57:	89 c5                	mov    %eax,%ebp
  803d59:	89 f0                	mov    %esi,%eax
  803d5b:	31 d2                	xor    %edx,%edx
  803d5d:	f7 f5                	div    %ebp
  803d5f:	89 c8                	mov    %ecx,%eax
  803d61:	f7 f5                	div    %ebp
  803d63:	89 d0                	mov    %edx,%eax
  803d65:	e9 44 ff ff ff       	jmp    803cae <__umoddi3+0x3e>
  803d6a:	66 90                	xchg   %ax,%ax
  803d6c:	89 c8                	mov    %ecx,%eax
  803d6e:	89 f2                	mov    %esi,%edx
  803d70:	83 c4 1c             	add    $0x1c,%esp
  803d73:	5b                   	pop    %ebx
  803d74:	5e                   	pop    %esi
  803d75:	5f                   	pop    %edi
  803d76:	5d                   	pop    %ebp
  803d77:	c3                   	ret    
  803d78:	3b 04 24             	cmp    (%esp),%eax
  803d7b:	72 06                	jb     803d83 <__umoddi3+0x113>
  803d7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d81:	77 0f                	ja     803d92 <__umoddi3+0x122>
  803d83:	89 f2                	mov    %esi,%edx
  803d85:	29 f9                	sub    %edi,%ecx
  803d87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d8b:	89 14 24             	mov    %edx,(%esp)
  803d8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d92:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d96:	8b 14 24             	mov    (%esp),%edx
  803d99:	83 c4 1c             	add    $0x1c,%esp
  803d9c:	5b                   	pop    %ebx
  803d9d:	5e                   	pop    %esi
  803d9e:	5f                   	pop    %edi
  803d9f:	5d                   	pop    %ebp
  803da0:	c3                   	ret    
  803da1:	8d 76 00             	lea    0x0(%esi),%esi
  803da4:	2b 04 24             	sub    (%esp),%eax
  803da7:	19 fa                	sbb    %edi,%edx
  803da9:	89 d1                	mov    %edx,%ecx
  803dab:	89 c6                	mov    %eax,%esi
  803dad:	e9 71 ff ff ff       	jmp    803d23 <__umoddi3+0xb3>
  803db2:	66 90                	xchg   %ax,%ax
  803db4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803db8:	72 ea                	jb     803da4 <__umoddi3+0x134>
  803dba:	89 d9                	mov    %ebx,%ecx
  803dbc:	e9 62 ff ff ff       	jmp    803d23 <__umoddi3+0xb3>
