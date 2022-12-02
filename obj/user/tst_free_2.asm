
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
  800090:	68 40 3d 80 00       	push   $0x803d40
  800095:	6a 14                	push   $0x14
  800097:	68 5c 3d 80 00       	push   $0x803d5c
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
  8000b3:	e8 f1 21 00 00       	call   8022a9 <sys_bypassPageFault>
  8000b8:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000bb:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  8000c9:	e8 43 1e 00 00       	call   801f11 <sys_calculate_free_frames>
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
  8000f6:	e8 16 1e 00 00       	call   801f11 <sys_calculate_free_frames>
  8000fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 ae 1e 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
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
  800127:	68 70 3d 80 00       	push   $0x803d70
  80012c:	6a 2d                	push   $0x2d
  80012e:	68 5c 3d 80 00       	push   $0x803d5c
  800133:	e8 7d 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 74 1e 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 d8 3d 80 00       	push   $0x803dd8
  80014a:	6a 2e                	push   $0x2e
  80014c:	68 5c 3d 80 00       	push   $0x803d5c
  800151:	e8 5f 09 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  800156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80015e:	48                   	dec    %eax
  80015f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800165:	e8 a7 1d 00 00       	call   801f11 <sys_calculate_free_frames>
  80016a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80016d:	e8 3f 1e 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
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
  8001a2:	68 70 3d 80 00       	push   $0x803d70
  8001a7:	6a 35                	push   $0x35
  8001a9:	68 5c 3d 80 00       	push   $0x803d5c
  8001ae:	e8 02 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001b3:	e8 f9 1d 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  8001b8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001bb:	74 14                	je     8001d1 <_main+0x199>
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	68 d8 3d 80 00       	push   $0x803dd8
  8001c5:	6a 36                	push   $0x36
  8001c7:	68 5c 3d 80 00       	push   $0x803d5c
  8001cc:	e8 e4 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001d9:	48                   	dec    %eax
  8001da:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001e0:	e8 2c 1d 00 00       	call   801f11 <sys_calculate_free_frames>
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001e8:	e8 c4 1d 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
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
  80021b:	68 70 3d 80 00       	push   $0x803d70
  800220:	6a 3d                	push   $0x3d
  800222:	68 5c 3d 80 00       	push   $0x803d5c
  800227:	e8 89 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80022c:	e8 80 1d 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  800231:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 d8 3d 80 00       	push   $0x803dd8
  80023e:	6a 3e                	push   $0x3e
  800240:	68 5c 3d 80 00       	push   $0x803d5c
  800245:	e8 6b 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  80024a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024d:	01 c0                	add    %eax,%eax
  80024f:	48                   	dec    %eax
  800250:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800256:	e8 b6 1c 00 00       	call   801f11 <sys_calculate_free_frames>
  80025b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025e:	e8 4e 1d 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
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
  80029b:	68 70 3d 80 00       	push   $0x803d70
  8002a0:	6a 45                	push   $0x45
  8002a2:	68 5c 3d 80 00       	push   $0x803d5c
  8002a7:	e8 09 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002ac:	e8 00 1d 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  8002b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002b4:	74 14                	je     8002ca <_main+0x292>
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	68 d8 3d 80 00       	push   $0x803dd8
  8002be:	6a 46                	push   $0x46
  8002c0:	68 5c 3d 80 00       	push   $0x803d5c
  8002c5:	e8 eb 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  8002ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002cd:	01 c0                	add    %eax,%eax
  8002cf:	48                   	dec    %eax
  8002d0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002d6:	e8 36 1c 00 00       	call   801f11 <sys_calculate_free_frames>
  8002db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002de:	e8 ce 1c 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
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
  800323:	68 70 3d 80 00       	push   $0x803d70
  800328:	6a 4d                	push   $0x4d
  80032a:	68 5c 3d 80 00       	push   $0x803d5c
  80032f:	e8 81 07 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800334:	e8 78 1c 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  800339:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 d8 3d 80 00       	push   $0x803dd8
  800346:	6a 4e                	push   $0x4e
  800348:	68 5c 3d 80 00       	push   $0x803d5c
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
  800366:	e8 a6 1b 00 00       	call   801f11 <sys_calculate_free_frames>
  80036b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80036e:	e8 3e 1c 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
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
  8003b2:	68 70 3d 80 00       	push   $0x803d70
  8003b7:	6a 55                	push   $0x55
  8003b9:	68 5c 3d 80 00       	push   $0x803d5c
  8003be:	e8 f2 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003c3:	e8 e9 1b 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  8003c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003cb:	74 14                	je     8003e1 <_main+0x3a9>
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 d8 3d 80 00       	push   $0x803dd8
  8003d5:	6a 56                	push   $0x56
  8003d7:	68 5c 3d 80 00       	push   $0x803d5c
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
  8003f4:	e8 18 1b 00 00       	call   801f11 <sys_calculate_free_frames>
  8003f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003fc:	e8 b0 1b 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
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
  800443:	68 70 3d 80 00       	push   $0x803d70
  800448:	6a 5d                	push   $0x5d
  80044a:	68 5c 3d 80 00       	push   $0x803d5c
  80044f:	e8 61 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800454:	e8 58 1b 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  800459:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80045c:	74 14                	je     800472 <_main+0x43a>
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 d8 3d 80 00       	push   $0x803dd8
  800466:	6a 5e                	push   $0x5e
  800468:	68 5c 3d 80 00       	push   $0x803d5c
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
  800481:	e8 8b 1a 00 00       	call   801f11 <sys_calculate_free_frames>
  800486:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800489:	e8 23 1b 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  80048e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800491:	8b 45 80             	mov    -0x80(%ebp),%eax
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	50                   	push   %eax
  800498:	e8 82 18 00 00       	call   801d1f <free>
  80049d:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8004a0:	e8 0c 1b 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  8004a5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 08 3e 80 00       	push   $0x803e08
  8004b2:	6a 6b                	push   $0x6b
  8004b4:	68 5c 3d 80 00       	push   $0x803d5c
  8004b9:	e8 f7 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004be:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004ca:	e8 c1 1d 00 00       	call   802290 <sys_rcr2>
  8004cf:	89 c2                	mov    %eax,%edx
  8004d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d4:	39 c2                	cmp    %eax,%edx
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 44 3e 80 00       	push   $0x803e44
  8004e0:	6a 6f                	push   $0x6f
  8004e2:	68 5c 3d 80 00       	push   $0x803d5c
  8004e7:	e8 c9 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[0]] = 10;
  8004ec:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004f2:	89 c2                	mov    %eax,%edx
  8004f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f7:	01 d0                	add    %edx,%eax
  8004f9:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004fc:	e8 8f 1d 00 00       	call   802290 <sys_rcr2>
  800501:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  800507:	89 d1                	mov    %edx,%ecx
  800509:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050c:	01 ca                	add    %ecx,%edx
  80050e:	39 d0                	cmp    %edx,%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 44 3e 80 00       	push   $0x803e44
  80051a:	6a 71                	push   $0x71
  80051c:	68 5c 3d 80 00       	push   $0x803d5c
  800521:	e8 8f 05 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800526:	e8 e6 19 00 00       	call   801f11 <sys_calculate_free_frames>
  80052b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80052e:	e8 7e 1a 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  800533:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800536:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 dd 17 00 00       	call   801d1f <free>
  800542:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800545:	e8 67 1a 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  80054a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80054d:	74 14                	je     800563 <_main+0x52b>
  80054f:	83 ec 04             	sub    $0x4,%esp
  800552:	68 08 3e 80 00       	push   $0x803e08
  800557:	6a 76                	push   $0x76
  800559:	68 5c 3d 80 00       	push   $0x803d5c
  80055e:	e8 52 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  800563:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800566:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800569:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056c:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80056f:	e8 1c 1d 00 00       	call   802290 <sys_rcr2>
  800574:	89 c2                	mov    %eax,%edx
  800576:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	74 14                	je     800591 <_main+0x559>
  80057d:	83 ec 04             	sub    $0x4,%esp
  800580:	68 44 3e 80 00       	push   $0x803e44
  800585:	6a 7a                	push   $0x7a
  800587:	68 5c 3d 80 00       	push   $0x803d5c
  80058c:	e8 24 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[1]] = 10;
  800591:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800597:	89 c2                	mov    %eax,%edx
  800599:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005a1:	e8 ea 1c 00 00       	call   802290 <sys_rcr2>
  8005a6:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  8005ac:	89 d1                	mov    %edx,%ecx
  8005ae:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005b1:	01 ca                	add    %ecx,%edx
  8005b3:	39 d0                	cmp    %edx,%eax
  8005b5:	74 14                	je     8005cb <_main+0x593>
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	68 44 3e 80 00       	push   $0x803e44
  8005bf:	6a 7c                	push   $0x7c
  8005c1:	68 5c 3d 80 00       	push   $0x803d5c
  8005c6:	e8 ea 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005cb:	e8 41 19 00 00       	call   801f11 <sys_calculate_free_frames>
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005d3:	e8 d9 19 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  8005d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  8005db:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005de:	83 ec 0c             	sub    $0xc,%esp
  8005e1:	50                   	push   %eax
  8005e2:	e8 38 17 00 00       	call   801d1f <free>
  8005e7:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005ea:	e8 c2 19 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  8005ef:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005f2:	74 17                	je     80060b <_main+0x5d3>
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 08 3e 80 00       	push   $0x803e08
  8005fc:	68 81 00 00 00       	push   $0x81
  800601:	68 5c 3d 80 00       	push   $0x803d5c
  800606:	e8 aa 04 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  80060b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800611:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800614:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800617:	e8 74 1c 00 00       	call   802290 <sys_rcr2>
  80061c:	89 c2                	mov    %eax,%edx
  80061e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800621:	39 c2                	cmp    %eax,%edx
  800623:	74 17                	je     80063c <_main+0x604>
  800625:	83 ec 04             	sub    $0x4,%esp
  800628:	68 44 3e 80 00       	push   $0x803e44
  80062d:	68 85 00 00 00       	push   $0x85
  800632:	68 5c 3d 80 00       	push   $0x803d5c
  800637:	e8 79 04 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[2]] = 10;
  80063c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800642:	89 c2                	mov    %eax,%edx
  800644:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800647:	01 d0                	add    %edx,%eax
  800649:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80064c:	e8 3f 1c 00 00       	call   802290 <sys_rcr2>
  800651:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  800657:	89 d1                	mov    %edx,%ecx
  800659:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065c:	01 ca                	add    %ecx,%edx
  80065e:	39 d0                	cmp    %edx,%eax
  800660:	74 17                	je     800679 <_main+0x641>
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 44 3e 80 00       	push   $0x803e44
  80066a:	68 87 00 00 00       	push   $0x87
  80066f:	68 5c 3d 80 00       	push   $0x803d5c
  800674:	e8 3c 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800679:	e8 93 18 00 00       	call   801f11 <sys_calculate_free_frames>
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800681:	e8 2b 19 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  800686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800689:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	50                   	push   %eax
  800690:	e8 8a 16 00 00       	call   801d1f <free>
  800695:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800698:	e8 14 19 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 08 3e 80 00       	push   $0x803e08
  8006aa:	68 8c 00 00 00       	push   $0x8c
  8006af:	68 5c 3d 80 00       	push   $0x803d5c
  8006b4:	e8 fc 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  8006b9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8006bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c2:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006c5:	e8 c6 1b 00 00       	call   802290 <sys_rcr2>
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006cf:	39 c2                	cmp    %eax,%edx
  8006d1:	74 17                	je     8006ea <_main+0x6b2>
  8006d3:	83 ec 04             	sub    $0x4,%esp
  8006d6:	68 44 3e 80 00       	push   $0x803e44
  8006db:	68 90 00 00 00       	push   $0x90
  8006e0:	68 5c 3d 80 00       	push   $0x803d5c
  8006e5:	e8 cb 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[3]] = 10;
  8006ea:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006fa:	e8 91 1b 00 00       	call   802290 <sys_rcr2>
  8006ff:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800705:	89 d1                	mov    %edx,%ecx
  800707:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80070a:	01 ca                	add    %ecx,%edx
  80070c:	39 d0                	cmp    %edx,%eax
  80070e:	74 17                	je     800727 <_main+0x6ef>
  800710:	83 ec 04             	sub    $0x4,%esp
  800713:	68 44 3e 80 00       	push   $0x803e44
  800718:	68 92 00 00 00       	push   $0x92
  80071d:	68 5c 3d 80 00       	push   $0x803d5c
  800722:	e8 8e 03 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800727:	e8 e5 17 00 00       	call   801f11 <sys_calculate_free_frames>
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80072f:	e8 7d 18 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  800734:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  800737:	8b 45 90             	mov    -0x70(%ebp),%eax
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	50                   	push   %eax
  80073e:	e8 dc 15 00 00       	call   801d1f <free>
  800743:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800746:	e8 66 18 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  80074b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80074e:	74 17                	je     800767 <_main+0x72f>
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	68 08 3e 80 00       	push   $0x803e08
  800758:	68 97 00 00 00       	push   $0x97
  80075d:	68 5c 3d 80 00       	push   $0x803d5c
  800762:	e8 4e 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  800767:	8b 45 90             	mov    -0x70(%ebp),%eax
  80076a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80076d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800770:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800773:	e8 18 1b 00 00       	call   802290 <sys_rcr2>
  800778:	89 c2                	mov    %eax,%edx
  80077a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	74 17                	je     800798 <_main+0x760>
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	68 44 3e 80 00       	push   $0x803e44
  800789:	68 9b 00 00 00       	push   $0x9b
  80078e:	68 5c 3d 80 00       	push   $0x803d5c
  800793:	e8 1d 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[4]] = 10;
  800798:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80079e:	89 c2                	mov    %eax,%edx
  8007a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a3:	01 d0                	add    %edx,%eax
  8007a5:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007a8:	e8 e3 1a 00 00       	call   802290 <sys_rcr2>
  8007ad:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  8007b3:	89 d1                	mov    %edx,%ecx
  8007b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007b8:	01 ca                	add    %ecx,%edx
  8007ba:	39 d0                	cmp    %edx,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 44 3e 80 00       	push   $0x803e44
  8007c6:	68 9d 00 00 00       	push   $0x9d
  8007cb:	68 5c 3d 80 00       	push   $0x803d5c
  8007d0:	e8 e0 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8007d5:	e8 37 17 00 00       	call   801f11 <sys_calculate_free_frames>
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007dd:	e8 cf 17 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  8007e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  8007e5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	50                   	push   %eax
  8007ec:	e8 2e 15 00 00       	call   801d1f <free>
  8007f1:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  8007f4:	e8 b8 17 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  8007f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8007fc:	74 17                	je     800815 <_main+0x7dd>
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	68 08 3e 80 00       	push   $0x803e08
  800806:	68 a2 00 00 00       	push   $0xa2
  80080b:	68 5c 3d 80 00       	push   $0x803d5c
  800810:	e8 a0 02 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  800815:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800818:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80081b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80081e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800821:	e8 6a 1a 00 00       	call   802290 <sys_rcr2>
  800826:	89 c2                	mov    %eax,%edx
  800828:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80082b:	39 c2                	cmp    %eax,%edx
  80082d:	74 17                	je     800846 <_main+0x80e>
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 44 3e 80 00       	push   $0x803e44
  800837:	68 a6 00 00 00       	push   $0xa6
  80083c:	68 5c 3d 80 00       	push   $0x803d5c
  800841:	e8 6f 02 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[5]] = 10;
  800846:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800856:	e8 35 1a 00 00       	call   802290 <sys_rcr2>
  80085b:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  800861:	89 d1                	mov    %edx,%ecx
  800863:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800866:	01 ca                	add    %ecx,%edx
  800868:	39 d0                	cmp    %edx,%eax
  80086a:	74 17                	je     800883 <_main+0x84b>
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	68 44 3e 80 00       	push   $0x803e44
  800874:	68 a8 00 00 00       	push   $0xa8
  800879:	68 5c 3d 80 00       	push   $0x803d5c
  80087e:	e8 32 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800883:	e8 89 16 00 00       	call   801f11 <sys_calculate_free_frames>
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80088b:	e8 21 17 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  800890:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  800893:	8b 45 98             	mov    -0x68(%ebp),%eax
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	50                   	push   %eax
  80089a:	e8 80 14 00 00       	call   801d1f <free>
  80089f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8008a2:	e8 0a 17 00 00       	call   801fb1 <sys_pf_calculate_allocated_pages>
  8008a7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8008aa:	74 17                	je     8008c3 <_main+0x88b>
  8008ac:	83 ec 04             	sub    $0x4,%esp
  8008af:	68 08 3e 80 00       	push   $0x803e08
  8008b4:	68 ad 00 00 00       	push   $0xad
  8008b9:	68 5c 3d 80 00       	push   $0x803d5c
  8008be:	e8 f2 01 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  8008c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8008c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008cc:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8008cf:	e8 bc 19 00 00       	call   802290 <sys_rcr2>
  8008d4:	89 c2                	mov    %eax,%edx
  8008d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008d9:	39 c2                	cmp    %eax,%edx
  8008db:	74 17                	je     8008f4 <_main+0x8bc>
  8008dd:	83 ec 04             	sub    $0x4,%esp
  8008e0:	68 44 3e 80 00       	push   $0x803e44
  8008e5:	68 b1 00 00 00       	push   $0xb1
  8008ea:	68 5c 3d 80 00       	push   $0x803d5c
  8008ef:	e8 c1 01 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[6]] = 10;
  8008f4:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8008fa:	89 c2                	mov    %eax,%edx
  8008fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008ff:	01 d0                	add    %edx,%eax
  800901:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800904:	e8 87 19 00 00       	call   802290 <sys_rcr2>
  800909:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  80090f:	89 d1                	mov    %edx,%ecx
  800911:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800914:	01 ca                	add    %ecx,%edx
  800916:	39 d0                	cmp    %edx,%eax
  800918:	74 17                	je     800931 <_main+0x8f9>
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	68 44 3e 80 00       	push   $0x803e44
  800922:	68 b3 00 00 00       	push   $0xb3
  800927:	68 5c 3d 80 00       	push   $0x803d5c
  80092c:	e8 84 01 00 00       	call   800ab5 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames()) ) {panic("Wrong free: not all pages removed correctly at end");}
  800931:	e8 db 15 00 00       	call   801f11 <sys_calculate_free_frames>
  800936:	89 c2                	mov    %eax,%edx
  800938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80093b:	39 c2                	cmp    %eax,%edx
  80093d:	74 17                	je     800956 <_main+0x91e>
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	68 88 3e 80 00       	push   $0x803e88
  800947:	68 b5 00 00 00       	push   $0xb5
  80094c:	68 5c 3d 80 00       	push   $0x803d5c
  800951:	e8 5f 01 00 00       	call   800ab5 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  800956:	83 ec 0c             	sub    $0xc,%esp
  800959:	6a 00                	push   $0x0
  80095b:	e8 49 19 00 00       	call   8022a9 <sys_bypassPageFault>
  800960:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  800963:	83 ec 0c             	sub    $0xc,%esp
  800966:	68 bc 3e 80 00       	push   $0x803ebc
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
  80097f:	e8 6d 18 00 00       	call   8021f1 <sys_getenvindex>
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
  8009ea:	e8 0f 16 00 00       	call   801ffe <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009ef:	83 ec 0c             	sub    $0xc,%esp
  8009f2:	68 10 3f 80 00       	push   $0x803f10
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
  800a1a:	68 38 3f 80 00       	push   $0x803f38
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
  800a4b:	68 60 3f 80 00       	push   $0x803f60
  800a50:	e8 14 03 00 00       	call   800d69 <cprintf>
  800a55:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a58:	a1 20 50 80 00       	mov    0x805020,%eax
  800a5d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	50                   	push   %eax
  800a67:	68 b8 3f 80 00       	push   $0x803fb8
  800a6c:	e8 f8 02 00 00       	call   800d69 <cprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	68 10 3f 80 00       	push   $0x803f10
  800a7c:	e8 e8 02 00 00       	call   800d69 <cprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a84:	e8 8f 15 00 00       	call   802018 <sys_enable_interrupt>

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
  800a9c:	e8 1c 17 00 00       	call   8021bd <sys_destroy_env>
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
  800aad:	e8 71 17 00 00       	call   802223 <sys_exit_env>
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
  800ad6:	68 cc 3f 80 00       	push   $0x803fcc
  800adb:	e8 89 02 00 00       	call   800d69 <cprintf>
  800ae0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ae3:	a1 00 50 80 00       	mov    0x805000,%eax
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	50                   	push   %eax
  800aef:	68 d1 3f 80 00       	push   $0x803fd1
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
  800b13:	68 ed 3f 80 00       	push   $0x803fed
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
  800b3f:	68 f0 3f 80 00       	push   $0x803ff0
  800b44:	6a 26                	push   $0x26
  800b46:	68 3c 40 80 00       	push   $0x80403c
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
  800c11:	68 48 40 80 00       	push   $0x804048
  800c16:	6a 3a                	push   $0x3a
  800c18:	68 3c 40 80 00       	push   $0x80403c
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
  800c81:	68 9c 40 80 00       	push   $0x80409c
  800c86:	6a 44                	push   $0x44
  800c88:	68 3c 40 80 00       	push   $0x80403c
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
  800cdb:	e8 70 11 00 00       	call   801e50 <sys_cputs>
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
  800d52:	e8 f9 10 00 00       	call   801e50 <sys_cputs>
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
  800d9c:	e8 5d 12 00 00       	call   801ffe <sys_disable_interrupt>
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
  800dbc:	e8 57 12 00 00       	call   802018 <sys_enable_interrupt>
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
  800e06:	e8 c9 2c 00 00       	call   803ad4 <__udivdi3>
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
  800e56:	e8 89 2d 00 00       	call   803be4 <__umoddi3>
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	05 14 43 80 00       	add    $0x804314,%eax
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
  800fb1:	8b 04 85 38 43 80 00 	mov    0x804338(,%eax,4),%eax
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
  801092:	8b 34 9d 80 41 80 00 	mov    0x804180(,%ebx,4),%esi
  801099:	85 f6                	test   %esi,%esi
  80109b:	75 19                	jne    8010b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80109d:	53                   	push   %ebx
  80109e:	68 25 43 80 00       	push   $0x804325
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
  8010b7:	68 2e 43 80 00       	push   $0x80432e
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
  8010e4:	be 31 43 80 00       	mov    $0x804331,%esi
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
  801b0a:	68 90 44 80 00       	push   $0x804490
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  801bbd:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801bc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bcc:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bd1:	83 ec 04             	sub    $0x4,%esp
  801bd4:	6a 03                	push   $0x3
  801bd6:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd9:	50                   	push   %eax
  801bda:	e8 b5 03 00 00       	call   801f94 <sys_allocate_chunk>
  801bdf:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801be2:	a1 20 51 80 00       	mov    0x805120,%eax
  801be7:	83 ec 0c             	sub    $0xc,%esp
  801bea:	50                   	push   %eax
  801beb:	e8 2a 0a 00 00       	call   80261a <initialize_MemBlocksList>
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
  801c18:	68 b5 44 80 00       	push   $0x8044b5
  801c1d:	6a 33                	push   $0x33
  801c1f:	68 d3 44 80 00       	push   $0x8044d3
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
  801c97:	68 e0 44 80 00       	push   $0x8044e0
  801c9c:	6a 34                	push   $0x34
  801c9e:	68 d3 44 80 00       	push   $0x8044d3
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
  801d0c:	68 04 45 80 00       	push   $0x804504
  801d11:	6a 46                	push   $0x46
  801d13:	68 d3 44 80 00       	push   $0x8044d3
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
  801d28:	68 2c 45 80 00       	push   $0x80452c
  801d2d:	6a 61                	push   $0x61
  801d2f:	68 d3 44 80 00       	push   $0x8044d3
  801d34:	e8 7c ed ff ff       	call   800ab5 <_panic>

00801d39 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 18             	sub    $0x18,%esp
  801d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d42:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d45:	e8 a9 fd ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d4e:	75 07                	jne    801d57 <smalloc+0x1e>
  801d50:	b8 00 00 00 00       	mov    $0x0,%eax
  801d55:	eb 14                	jmp    801d6b <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801d57:	83 ec 04             	sub    $0x4,%esp
  801d5a:	68 50 45 80 00       	push   $0x804550
  801d5f:	6a 76                	push   $0x76
  801d61:	68 d3 44 80 00       	push   $0x8044d3
  801d66:	e8 4a ed ff ff       	call   800ab5 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d73:	e8 7b fd ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801d78:	83 ec 04             	sub    $0x4,%esp
  801d7b:	68 78 45 80 00       	push   $0x804578
  801d80:	68 93 00 00 00       	push   $0x93
  801d85:	68 d3 44 80 00       	push   $0x8044d3
  801d8a:	e8 26 ed ff ff       	call   800ab5 <_panic>

00801d8f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d95:	e8 59 fd ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d9a:	83 ec 04             	sub    $0x4,%esp
  801d9d:	68 9c 45 80 00       	push   $0x80459c
  801da2:	68 c5 00 00 00       	push   $0xc5
  801da7:	68 d3 44 80 00       	push   $0x8044d3
  801dac:	e8 04 ed ff ff       	call   800ab5 <_panic>

00801db1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801db7:	83 ec 04             	sub    $0x4,%esp
  801dba:	68 c4 45 80 00       	push   $0x8045c4
  801dbf:	68 d9 00 00 00       	push   $0xd9
  801dc4:	68 d3 44 80 00       	push   $0x8044d3
  801dc9:	e8 e7 ec ff ff       	call   800ab5 <_panic>

00801dce <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dd4:	83 ec 04             	sub    $0x4,%esp
  801dd7:	68 e8 45 80 00       	push   $0x8045e8
  801ddc:	68 e4 00 00 00       	push   $0xe4
  801de1:	68 d3 44 80 00       	push   $0x8044d3
  801de6:	e8 ca ec ff ff       	call   800ab5 <_panic>

00801deb <shrink>:

}
void shrink(uint32 newSize)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801df1:	83 ec 04             	sub    $0x4,%esp
  801df4:	68 e8 45 80 00       	push   $0x8045e8
  801df9:	68 e9 00 00 00       	push   $0xe9
  801dfe:	68 d3 44 80 00       	push   $0x8044d3
  801e03:	e8 ad ec ff ff       	call   800ab5 <_panic>

00801e08 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e0e:	83 ec 04             	sub    $0x4,%esp
  801e11:	68 e8 45 80 00       	push   $0x8045e8
  801e16:	68 ee 00 00 00       	push   $0xee
  801e1b:	68 d3 44 80 00       	push   $0x8044d3
  801e20:	e8 90 ec ff ff       	call   800ab5 <_panic>

00801e25 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	57                   	push   %edi
  801e29:	56                   	push   %esi
  801e2a:	53                   	push   %ebx
  801e2b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e37:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e3a:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e3d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e40:	cd 30                	int    $0x30
  801e42:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e48:	83 c4 10             	add    $0x10,%esp
  801e4b:	5b                   	pop    %ebx
  801e4c:	5e                   	pop    %esi
  801e4d:	5f                   	pop    %edi
  801e4e:	5d                   	pop    %ebp
  801e4f:	c3                   	ret    

00801e50 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 04             	sub    $0x4,%esp
  801e56:	8b 45 10             	mov    0x10(%ebp),%eax
  801e59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e5c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	52                   	push   %edx
  801e68:	ff 75 0c             	pushl  0xc(%ebp)
  801e6b:	50                   	push   %eax
  801e6c:	6a 00                	push   $0x0
  801e6e:	e8 b2 ff ff ff       	call   801e25 <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
}
  801e76:	90                   	nop
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <sys_cgetc>:

int
sys_cgetc(void)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 01                	push   $0x1
  801e88:	e8 98 ff ff ff       	call   801e25 <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e98:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	52                   	push   %edx
  801ea2:	50                   	push   %eax
  801ea3:	6a 05                	push   $0x5
  801ea5:	e8 7b ff ff ff       	call   801e25 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	56                   	push   %esi
  801eb3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801eb4:	8b 75 18             	mov    0x18(%ebp),%esi
  801eb7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	56                   	push   %esi
  801ec4:	53                   	push   %ebx
  801ec5:	51                   	push   %ecx
  801ec6:	52                   	push   %edx
  801ec7:	50                   	push   %eax
  801ec8:	6a 06                	push   $0x6
  801eca:	e8 56 ff ff ff       	call   801e25 <syscall>
  801ecf:	83 c4 18             	add    $0x18,%esp
}
  801ed2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed5:	5b                   	pop    %ebx
  801ed6:	5e                   	pop    %esi
  801ed7:	5d                   	pop    %ebp
  801ed8:	c3                   	ret    

00801ed9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801edc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	52                   	push   %edx
  801ee9:	50                   	push   %eax
  801eea:	6a 07                	push   $0x7
  801eec:	e8 34 ff ff ff       	call   801e25 <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	ff 75 0c             	pushl  0xc(%ebp)
  801f02:	ff 75 08             	pushl  0x8(%ebp)
  801f05:	6a 08                	push   $0x8
  801f07:	e8 19 ff ff ff       	call   801e25 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 09                	push   $0x9
  801f20:	e8 00 ff ff ff       	call   801e25 <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 0a                	push   $0xa
  801f39:	e8 e7 fe ff ff       	call   801e25 <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 0b                	push   $0xb
  801f52:	e8 ce fe ff ff       	call   801e25 <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	ff 75 0c             	pushl  0xc(%ebp)
  801f68:	ff 75 08             	pushl  0x8(%ebp)
  801f6b:	6a 0f                	push   $0xf
  801f6d:	e8 b3 fe ff ff       	call   801e25 <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
	return;
  801f75:	90                   	nop
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	ff 75 0c             	pushl  0xc(%ebp)
  801f84:	ff 75 08             	pushl  0x8(%ebp)
  801f87:	6a 10                	push   $0x10
  801f89:	e8 97 fe ff ff       	call   801e25 <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f91:	90                   	nop
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	ff 75 10             	pushl  0x10(%ebp)
  801f9e:	ff 75 0c             	pushl  0xc(%ebp)
  801fa1:	ff 75 08             	pushl  0x8(%ebp)
  801fa4:	6a 11                	push   $0x11
  801fa6:	e8 7a fe ff ff       	call   801e25 <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
	return ;
  801fae:	90                   	nop
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 0c                	push   $0xc
  801fc0:	e8 60 fe ff ff       	call   801e25 <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	ff 75 08             	pushl  0x8(%ebp)
  801fd8:	6a 0d                	push   $0xd
  801fda:	e8 46 fe ff ff       	call   801e25 <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 0e                	push   $0xe
  801ff3:	e8 2d fe ff ff       	call   801e25 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	90                   	nop
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 13                	push   $0x13
  80200d:	e8 13 fe ff ff       	call   801e25 <syscall>
  802012:	83 c4 18             	add    $0x18,%esp
}
  802015:	90                   	nop
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 14                	push   $0x14
  802027:	e8 f9 fd ff ff       	call   801e25 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	90                   	nop
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <sys_cputc>:


void
sys_cputc(const char c)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	83 ec 04             	sub    $0x4,%esp
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80203e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	50                   	push   %eax
  80204b:	6a 15                	push   $0x15
  80204d:	e8 d3 fd ff ff       	call   801e25 <syscall>
  802052:	83 c4 18             	add    $0x18,%esp
}
  802055:	90                   	nop
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 16                	push   $0x16
  802067:	e8 b9 fd ff ff       	call   801e25 <syscall>
  80206c:	83 c4 18             	add    $0x18,%esp
}
  80206f:	90                   	nop
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	ff 75 0c             	pushl  0xc(%ebp)
  802081:	50                   	push   %eax
  802082:	6a 17                	push   $0x17
  802084:	e8 9c fd ff ff       	call   801e25 <syscall>
  802089:	83 c4 18             	add    $0x18,%esp
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802091:	8b 55 0c             	mov    0xc(%ebp),%edx
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	52                   	push   %edx
  80209e:	50                   	push   %eax
  80209f:	6a 1a                	push   $0x1a
  8020a1:	e8 7f fd ff ff       	call   801e25 <syscall>
  8020a6:	83 c4 18             	add    $0x18,%esp
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	52                   	push   %edx
  8020bb:	50                   	push   %eax
  8020bc:	6a 18                	push   $0x18
  8020be:	e8 62 fd ff ff       	call   801e25 <syscall>
  8020c3:	83 c4 18             	add    $0x18,%esp
}
  8020c6:	90                   	nop
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	52                   	push   %edx
  8020d9:	50                   	push   %eax
  8020da:	6a 19                	push   $0x19
  8020dc:	e8 44 fd ff ff       	call   801e25 <syscall>
  8020e1:	83 c4 18             	add    $0x18,%esp
}
  8020e4:	90                   	nop
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	83 ec 04             	sub    $0x4,%esp
  8020ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020f3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	6a 00                	push   $0x0
  8020ff:	51                   	push   %ecx
  802100:	52                   	push   %edx
  802101:	ff 75 0c             	pushl  0xc(%ebp)
  802104:	50                   	push   %eax
  802105:	6a 1b                	push   $0x1b
  802107:	e8 19 fd ff ff       	call   801e25 <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802114:	8b 55 0c             	mov    0xc(%ebp),%edx
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	52                   	push   %edx
  802121:	50                   	push   %eax
  802122:	6a 1c                	push   $0x1c
  802124:	e8 fc fc ff ff       	call   801e25 <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802131:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802134:	8b 55 0c             	mov    0xc(%ebp),%edx
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	6a 00                	push   $0x0
  80213c:	6a 00                	push   $0x0
  80213e:	51                   	push   %ecx
  80213f:	52                   	push   %edx
  802140:	50                   	push   %eax
  802141:	6a 1d                	push   $0x1d
  802143:	e8 dd fc ff ff       	call   801e25 <syscall>
  802148:	83 c4 18             	add    $0x18,%esp
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802150:	8b 55 0c             	mov    0xc(%ebp),%edx
  802153:	8b 45 08             	mov    0x8(%ebp),%eax
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	52                   	push   %edx
  80215d:	50                   	push   %eax
  80215e:	6a 1e                	push   $0x1e
  802160:	e8 c0 fc ff ff       	call   801e25 <syscall>
  802165:	83 c4 18             	add    $0x18,%esp
}
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 1f                	push   $0x1f
  802179:	e8 a7 fc ff ff       	call   801e25 <syscall>
  80217e:	83 c4 18             	add    $0x18,%esp
}
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	6a 00                	push   $0x0
  80218b:	ff 75 14             	pushl  0x14(%ebp)
  80218e:	ff 75 10             	pushl  0x10(%ebp)
  802191:	ff 75 0c             	pushl  0xc(%ebp)
  802194:	50                   	push   %eax
  802195:	6a 20                	push   $0x20
  802197:	e8 89 fc ff ff       	call   801e25 <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	50                   	push   %eax
  8021b0:	6a 21                	push   $0x21
  8021b2:	e8 6e fc ff ff       	call   801e25 <syscall>
  8021b7:	83 c4 18             	add    $0x18,%esp
}
  8021ba:	90                   	nop
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	50                   	push   %eax
  8021cc:	6a 22                	push   $0x22
  8021ce:	e8 52 fc ff ff       	call   801e25 <syscall>
  8021d3:	83 c4 18             	add    $0x18,%esp
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 02                	push   $0x2
  8021e7:	e8 39 fc ff ff       	call   801e25 <syscall>
  8021ec:	83 c4 18             	add    $0x18,%esp
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 03                	push   $0x3
  802200:	e8 20 fc ff ff       	call   801e25 <syscall>
  802205:	83 c4 18             	add    $0x18,%esp
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 04                	push   $0x4
  802219:	e8 07 fc ff ff       	call   801e25 <syscall>
  80221e:	83 c4 18             	add    $0x18,%esp
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <sys_exit_env>:


void sys_exit_env(void)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 23                	push   $0x23
  802232:	e8 ee fb ff ff       	call   801e25 <syscall>
  802237:	83 c4 18             	add    $0x18,%esp
}
  80223a:	90                   	nop
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802243:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802246:	8d 50 04             	lea    0x4(%eax),%edx
  802249:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	52                   	push   %edx
  802253:	50                   	push   %eax
  802254:	6a 24                	push   $0x24
  802256:	e8 ca fb ff ff       	call   801e25 <syscall>
  80225b:	83 c4 18             	add    $0x18,%esp
	return result;
  80225e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802261:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802264:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802267:	89 01                	mov    %eax,(%ecx)
  802269:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	c9                   	leave  
  802270:	c2 04 00             	ret    $0x4

00802273 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	ff 75 10             	pushl  0x10(%ebp)
  80227d:	ff 75 0c             	pushl  0xc(%ebp)
  802280:	ff 75 08             	pushl  0x8(%ebp)
  802283:	6a 12                	push   $0x12
  802285:	e8 9b fb ff ff       	call   801e25 <syscall>
  80228a:	83 c4 18             	add    $0x18,%esp
	return ;
  80228d:	90                   	nop
}
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_rcr2>:
uint32 sys_rcr2()
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 25                	push   $0x25
  80229f:	e8 81 fb ff ff       	call   801e25 <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	83 ec 04             	sub    $0x4,%esp
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022b5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	50                   	push   %eax
  8022c2:	6a 26                	push   $0x26
  8022c4:	e8 5c fb ff ff       	call   801e25 <syscall>
  8022c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8022cc:	90                   	nop
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <rsttst>:
void rsttst()
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 28                	push   $0x28
  8022de:	e8 42 fb ff ff       	call   801e25 <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e6:	90                   	nop
}
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
  8022ec:	83 ec 04             	sub    $0x4,%esp
  8022ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8022f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022f5:	8b 55 18             	mov    0x18(%ebp),%edx
  8022f8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022fc:	52                   	push   %edx
  8022fd:	50                   	push   %eax
  8022fe:	ff 75 10             	pushl  0x10(%ebp)
  802301:	ff 75 0c             	pushl  0xc(%ebp)
  802304:	ff 75 08             	pushl  0x8(%ebp)
  802307:	6a 27                	push   $0x27
  802309:	e8 17 fb ff ff       	call   801e25 <syscall>
  80230e:	83 c4 18             	add    $0x18,%esp
	return ;
  802311:	90                   	nop
}
  802312:	c9                   	leave  
  802313:	c3                   	ret    

00802314 <chktst>:
void chktst(uint32 n)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802317:	6a 00                	push   $0x0
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	ff 75 08             	pushl  0x8(%ebp)
  802322:	6a 29                	push   $0x29
  802324:	e8 fc fa ff ff       	call   801e25 <syscall>
  802329:	83 c4 18             	add    $0x18,%esp
	return ;
  80232c:	90                   	nop
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <inctst>:

void inctst()
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 2a                	push   $0x2a
  80233e:	e8 e2 fa ff ff       	call   801e25 <syscall>
  802343:	83 c4 18             	add    $0x18,%esp
	return ;
  802346:	90                   	nop
}
  802347:	c9                   	leave  
  802348:	c3                   	ret    

00802349 <gettst>:
uint32 gettst()
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 2b                	push   $0x2b
  802358:	e8 c8 fa ff ff       	call   801e25 <syscall>
  80235d:	83 c4 18             	add    $0x18,%esp
}
  802360:	c9                   	leave  
  802361:	c3                   	ret    

00802362 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 2c                	push   $0x2c
  802374:	e8 ac fa ff ff       	call   801e25 <syscall>
  802379:	83 c4 18             	add    $0x18,%esp
  80237c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80237f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802383:	75 07                	jne    80238c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802385:	b8 01 00 00 00       	mov    $0x1,%eax
  80238a:	eb 05                	jmp    802391 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80238c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
  802396:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 2c                	push   $0x2c
  8023a5:	e8 7b fa ff ff       	call   801e25 <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
  8023ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023b0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023b4:	75 07                	jne    8023bd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023bb:	eb 05                	jmp    8023c2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 2c                	push   $0x2c
  8023d6:	e8 4a fa ff ff       	call   801e25 <syscall>
  8023db:	83 c4 18             	add    $0x18,%esp
  8023de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023e1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023e5:	75 07                	jne    8023ee <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ec:	eb 05                	jmp    8023f3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
  8023f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 2c                	push   $0x2c
  802407:	e8 19 fa ff ff       	call   801e25 <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
  80240f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802412:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802416:	75 07                	jne    80241f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802418:	b8 01 00 00 00       	mov    $0x1,%eax
  80241d:	eb 05                	jmp    802424 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80241f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802424:	c9                   	leave  
  802425:	c3                   	ret    

00802426 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	ff 75 08             	pushl  0x8(%ebp)
  802434:	6a 2d                	push   $0x2d
  802436:	e8 ea f9 ff ff       	call   801e25 <syscall>
  80243b:	83 c4 18             	add    $0x18,%esp
	return ;
  80243e:	90                   	nop
}
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
  802444:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802445:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802448:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80244b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	6a 00                	push   $0x0
  802453:	53                   	push   %ebx
  802454:	51                   	push   %ecx
  802455:	52                   	push   %edx
  802456:	50                   	push   %eax
  802457:	6a 2e                	push   $0x2e
  802459:	e8 c7 f9 ff ff       	call   801e25 <syscall>
  80245e:	83 c4 18             	add    $0x18,%esp
}
  802461:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802464:	c9                   	leave  
  802465:	c3                   	ret    

00802466 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246c:	8b 45 08             	mov    0x8(%ebp),%eax
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	52                   	push   %edx
  802476:	50                   	push   %eax
  802477:	6a 2f                	push   $0x2f
  802479:	e8 a7 f9 ff ff       	call   801e25 <syscall>
  80247e:	83 c4 18             	add    $0x18,%esp
}
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
  802486:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802489:	83 ec 0c             	sub    $0xc,%esp
  80248c:	68 f8 45 80 00       	push   $0x8045f8
  802491:	e8 d3 e8 ff ff       	call   800d69 <cprintf>
  802496:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802499:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024a0:	83 ec 0c             	sub    $0xc,%esp
  8024a3:	68 24 46 80 00       	push   $0x804624
  8024a8:	e8 bc e8 ff ff       	call   800d69 <cprintf>
  8024ad:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024b0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024b4:	a1 38 51 80 00       	mov    0x805138,%eax
  8024b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bc:	eb 56                	jmp    802514 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024c2:	74 1c                	je     8024e0 <print_mem_block_lists+0x5d>
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 50 08             	mov    0x8(%eax),%edx
  8024ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cd:	8b 48 08             	mov    0x8(%eax),%ecx
  8024d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d6:	01 c8                	add    %ecx,%eax
  8024d8:	39 c2                	cmp    %eax,%edx
  8024da:	73 04                	jae    8024e0 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8024dc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	8b 50 08             	mov    0x8(%eax),%edx
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ec:	01 c2                	add    %eax,%edx
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	8b 40 08             	mov    0x8(%eax),%eax
  8024f4:	83 ec 04             	sub    $0x4,%esp
  8024f7:	52                   	push   %edx
  8024f8:	50                   	push   %eax
  8024f9:	68 39 46 80 00       	push   $0x804639
  8024fe:	e8 66 e8 ff ff       	call   800d69 <cprintf>
  802503:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80250c:	a1 40 51 80 00       	mov    0x805140,%eax
  802511:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802514:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802518:	74 07                	je     802521 <print_mem_block_lists+0x9e>
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 00                	mov    (%eax),%eax
  80251f:	eb 05                	jmp    802526 <print_mem_block_lists+0xa3>
  802521:	b8 00 00 00 00       	mov    $0x0,%eax
  802526:	a3 40 51 80 00       	mov    %eax,0x805140
  80252b:	a1 40 51 80 00       	mov    0x805140,%eax
  802530:	85 c0                	test   %eax,%eax
  802532:	75 8a                	jne    8024be <print_mem_block_lists+0x3b>
  802534:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802538:	75 84                	jne    8024be <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80253a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80253e:	75 10                	jne    802550 <print_mem_block_lists+0xcd>
  802540:	83 ec 0c             	sub    $0xc,%esp
  802543:	68 48 46 80 00       	push   $0x804648
  802548:	e8 1c e8 ff ff       	call   800d69 <cprintf>
  80254d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802550:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802557:	83 ec 0c             	sub    $0xc,%esp
  80255a:	68 6c 46 80 00       	push   $0x80466c
  80255f:	e8 05 e8 ff ff       	call   800d69 <cprintf>
  802564:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802567:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80256b:	a1 40 50 80 00       	mov    0x805040,%eax
  802570:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802573:	eb 56                	jmp    8025cb <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802575:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802579:	74 1c                	je     802597 <print_mem_block_lists+0x114>
  80257b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257e:	8b 50 08             	mov    0x8(%eax),%edx
  802581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802584:	8b 48 08             	mov    0x8(%eax),%ecx
  802587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258a:	8b 40 0c             	mov    0xc(%eax),%eax
  80258d:	01 c8                	add    %ecx,%eax
  80258f:	39 c2                	cmp    %eax,%edx
  802591:	73 04                	jae    802597 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802593:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 50 08             	mov    0x8(%eax),%edx
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a3:	01 c2                	add    %eax,%edx
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 40 08             	mov    0x8(%eax),%eax
  8025ab:	83 ec 04             	sub    $0x4,%esp
  8025ae:	52                   	push   %edx
  8025af:	50                   	push   %eax
  8025b0:	68 39 46 80 00       	push   $0x804639
  8025b5:	e8 af e7 ff ff       	call   800d69 <cprintf>
  8025ba:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025c3:	a1 48 50 80 00       	mov    0x805048,%eax
  8025c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cf:	74 07                	je     8025d8 <print_mem_block_lists+0x155>
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 00                	mov    (%eax),%eax
  8025d6:	eb 05                	jmp    8025dd <print_mem_block_lists+0x15a>
  8025d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025dd:	a3 48 50 80 00       	mov    %eax,0x805048
  8025e2:	a1 48 50 80 00       	mov    0x805048,%eax
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	75 8a                	jne    802575 <print_mem_block_lists+0xf2>
  8025eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ef:	75 84                	jne    802575 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8025f1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025f5:	75 10                	jne    802607 <print_mem_block_lists+0x184>
  8025f7:	83 ec 0c             	sub    $0xc,%esp
  8025fa:	68 84 46 80 00       	push   $0x804684
  8025ff:	e8 65 e7 ff ff       	call   800d69 <cprintf>
  802604:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802607:	83 ec 0c             	sub    $0xc,%esp
  80260a:	68 f8 45 80 00       	push   $0x8045f8
  80260f:	e8 55 e7 ff ff       	call   800d69 <cprintf>
  802614:	83 c4 10             	add    $0x10,%esp

}
  802617:	90                   	nop
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
  80261d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802620:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802627:	00 00 00 
  80262a:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802631:	00 00 00 
  802634:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80263b:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80263e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802645:	e9 9e 00 00 00       	jmp    8026e8 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80264a:	a1 50 50 80 00       	mov    0x805050,%eax
  80264f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802652:	c1 e2 04             	shl    $0x4,%edx
  802655:	01 d0                	add    %edx,%eax
  802657:	85 c0                	test   %eax,%eax
  802659:	75 14                	jne    80266f <initialize_MemBlocksList+0x55>
  80265b:	83 ec 04             	sub    $0x4,%esp
  80265e:	68 ac 46 80 00       	push   $0x8046ac
  802663:	6a 46                	push   $0x46
  802665:	68 cf 46 80 00       	push   $0x8046cf
  80266a:	e8 46 e4 ff ff       	call   800ab5 <_panic>
  80266f:	a1 50 50 80 00       	mov    0x805050,%eax
  802674:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802677:	c1 e2 04             	shl    $0x4,%edx
  80267a:	01 d0                	add    %edx,%eax
  80267c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802682:	89 10                	mov    %edx,(%eax)
  802684:	8b 00                	mov    (%eax),%eax
  802686:	85 c0                	test   %eax,%eax
  802688:	74 18                	je     8026a2 <initialize_MemBlocksList+0x88>
  80268a:	a1 48 51 80 00       	mov    0x805148,%eax
  80268f:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802695:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802698:	c1 e1 04             	shl    $0x4,%ecx
  80269b:	01 ca                	add    %ecx,%edx
  80269d:	89 50 04             	mov    %edx,0x4(%eax)
  8026a0:	eb 12                	jmp    8026b4 <initialize_MemBlocksList+0x9a>
  8026a2:	a1 50 50 80 00       	mov    0x805050,%eax
  8026a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026aa:	c1 e2 04             	shl    $0x4,%edx
  8026ad:	01 d0                	add    %edx,%eax
  8026af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026b4:	a1 50 50 80 00       	mov    0x805050,%eax
  8026b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bc:	c1 e2 04             	shl    $0x4,%edx
  8026bf:	01 d0                	add    %edx,%eax
  8026c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8026c6:	a1 50 50 80 00       	mov    0x805050,%eax
  8026cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ce:	c1 e2 04             	shl    $0x4,%edx
  8026d1:	01 d0                	add    %edx,%eax
  8026d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026da:	a1 54 51 80 00       	mov    0x805154,%eax
  8026df:	40                   	inc    %eax
  8026e0:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8026e5:	ff 45 f4             	incl   -0xc(%ebp)
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ee:	0f 82 56 ff ff ff    	jb     80264a <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8026f4:	90                   	nop
  8026f5:	c9                   	leave  
  8026f6:	c3                   	ret    

008026f7 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
  8026fa:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8026fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802700:	8b 00                	mov    (%eax),%eax
  802702:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802705:	eb 19                	jmp    802720 <find_block+0x29>
	{
		if(va==point->sva)
  802707:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80270a:	8b 40 08             	mov    0x8(%eax),%eax
  80270d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802710:	75 05                	jne    802717 <find_block+0x20>
		   return point;
  802712:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802715:	eb 36                	jmp    80274d <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802717:	8b 45 08             	mov    0x8(%ebp),%eax
  80271a:	8b 40 08             	mov    0x8(%eax),%eax
  80271d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802720:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802724:	74 07                	je     80272d <find_block+0x36>
  802726:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802729:	8b 00                	mov    (%eax),%eax
  80272b:	eb 05                	jmp    802732 <find_block+0x3b>
  80272d:	b8 00 00 00 00       	mov    $0x0,%eax
  802732:	8b 55 08             	mov    0x8(%ebp),%edx
  802735:	89 42 08             	mov    %eax,0x8(%edx)
  802738:	8b 45 08             	mov    0x8(%ebp),%eax
  80273b:	8b 40 08             	mov    0x8(%eax),%eax
  80273e:	85 c0                	test   %eax,%eax
  802740:	75 c5                	jne    802707 <find_block+0x10>
  802742:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802746:	75 bf                	jne    802707 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802748:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80274d:	c9                   	leave  
  80274e:	c3                   	ret    

0080274f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80274f:	55                   	push   %ebp
  802750:	89 e5                	mov    %esp,%ebp
  802752:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802755:	a1 40 50 80 00       	mov    0x805040,%eax
  80275a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80275d:	a1 44 50 80 00       	mov    0x805044,%eax
  802762:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802768:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80276b:	74 24                	je     802791 <insert_sorted_allocList+0x42>
  80276d:	8b 45 08             	mov    0x8(%ebp),%eax
  802770:	8b 50 08             	mov    0x8(%eax),%edx
  802773:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802776:	8b 40 08             	mov    0x8(%eax),%eax
  802779:	39 c2                	cmp    %eax,%edx
  80277b:	76 14                	jbe    802791 <insert_sorted_allocList+0x42>
  80277d:	8b 45 08             	mov    0x8(%ebp),%eax
  802780:	8b 50 08             	mov    0x8(%eax),%edx
  802783:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802786:	8b 40 08             	mov    0x8(%eax),%eax
  802789:	39 c2                	cmp    %eax,%edx
  80278b:	0f 82 60 01 00 00    	jb     8028f1 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802791:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802795:	75 65                	jne    8027fc <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802797:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80279b:	75 14                	jne    8027b1 <insert_sorted_allocList+0x62>
  80279d:	83 ec 04             	sub    $0x4,%esp
  8027a0:	68 ac 46 80 00       	push   $0x8046ac
  8027a5:	6a 6b                	push   $0x6b
  8027a7:	68 cf 46 80 00       	push   $0x8046cf
  8027ac:	e8 04 e3 ff ff       	call   800ab5 <_panic>
  8027b1:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	89 10                	mov    %edx,(%eax)
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	8b 00                	mov    (%eax),%eax
  8027c1:	85 c0                	test   %eax,%eax
  8027c3:	74 0d                	je     8027d2 <insert_sorted_allocList+0x83>
  8027c5:	a1 40 50 80 00       	mov    0x805040,%eax
  8027ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8027cd:	89 50 04             	mov    %edx,0x4(%eax)
  8027d0:	eb 08                	jmp    8027da <insert_sorted_allocList+0x8b>
  8027d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d5:	a3 44 50 80 00       	mov    %eax,0x805044
  8027da:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dd:	a3 40 50 80 00       	mov    %eax,0x805040
  8027e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ec:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027f1:	40                   	inc    %eax
  8027f2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027f7:	e9 dc 01 00 00       	jmp    8029d8 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8027fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ff:	8b 50 08             	mov    0x8(%eax),%edx
  802802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802805:	8b 40 08             	mov    0x8(%eax),%eax
  802808:	39 c2                	cmp    %eax,%edx
  80280a:	77 6c                	ja     802878 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80280c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802810:	74 06                	je     802818 <insert_sorted_allocList+0xc9>
  802812:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802816:	75 14                	jne    80282c <insert_sorted_allocList+0xdd>
  802818:	83 ec 04             	sub    $0x4,%esp
  80281b:	68 e8 46 80 00       	push   $0x8046e8
  802820:	6a 6f                	push   $0x6f
  802822:	68 cf 46 80 00       	push   $0x8046cf
  802827:	e8 89 e2 ff ff       	call   800ab5 <_panic>
  80282c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282f:	8b 50 04             	mov    0x4(%eax),%edx
  802832:	8b 45 08             	mov    0x8(%ebp),%eax
  802835:	89 50 04             	mov    %edx,0x4(%eax)
  802838:	8b 45 08             	mov    0x8(%ebp),%eax
  80283b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80283e:	89 10                	mov    %edx,(%eax)
  802840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802843:	8b 40 04             	mov    0x4(%eax),%eax
  802846:	85 c0                	test   %eax,%eax
  802848:	74 0d                	je     802857 <insert_sorted_allocList+0x108>
  80284a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284d:	8b 40 04             	mov    0x4(%eax),%eax
  802850:	8b 55 08             	mov    0x8(%ebp),%edx
  802853:	89 10                	mov    %edx,(%eax)
  802855:	eb 08                	jmp    80285f <insert_sorted_allocList+0x110>
  802857:	8b 45 08             	mov    0x8(%ebp),%eax
  80285a:	a3 40 50 80 00       	mov    %eax,0x805040
  80285f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802862:	8b 55 08             	mov    0x8(%ebp),%edx
  802865:	89 50 04             	mov    %edx,0x4(%eax)
  802868:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80286d:	40                   	inc    %eax
  80286e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802873:	e9 60 01 00 00       	jmp    8029d8 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802878:	8b 45 08             	mov    0x8(%ebp),%eax
  80287b:	8b 50 08             	mov    0x8(%eax),%edx
  80287e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802881:	8b 40 08             	mov    0x8(%eax),%eax
  802884:	39 c2                	cmp    %eax,%edx
  802886:	0f 82 4c 01 00 00    	jb     8029d8 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80288c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802890:	75 14                	jne    8028a6 <insert_sorted_allocList+0x157>
  802892:	83 ec 04             	sub    $0x4,%esp
  802895:	68 20 47 80 00       	push   $0x804720
  80289a:	6a 73                	push   $0x73
  80289c:	68 cf 46 80 00       	push   $0x8046cf
  8028a1:	e8 0f e2 ff ff       	call   800ab5 <_panic>
  8028a6:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	89 50 04             	mov    %edx,0x4(%eax)
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	8b 40 04             	mov    0x4(%eax),%eax
  8028b8:	85 c0                	test   %eax,%eax
  8028ba:	74 0c                	je     8028c8 <insert_sorted_allocList+0x179>
  8028bc:	a1 44 50 80 00       	mov    0x805044,%eax
  8028c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c4:	89 10                	mov    %edx,(%eax)
  8028c6:	eb 08                	jmp    8028d0 <insert_sorted_allocList+0x181>
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	a3 40 50 80 00       	mov    %eax,0x805040
  8028d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d3:	a3 44 50 80 00       	mov    %eax,0x805044
  8028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028e6:	40                   	inc    %eax
  8028e7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8028ec:	e9 e7 00 00 00       	jmp    8029d8 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8028f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8028f7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8028fe:	a1 40 50 80 00       	mov    0x805040,%eax
  802903:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802906:	e9 9d 00 00 00       	jmp    8029a8 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	8b 00                	mov    (%eax),%eax
  802910:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802913:	8b 45 08             	mov    0x8(%ebp),%eax
  802916:	8b 50 08             	mov    0x8(%eax),%edx
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	8b 40 08             	mov    0x8(%eax),%eax
  80291f:	39 c2                	cmp    %eax,%edx
  802921:	76 7d                	jbe    8029a0 <insert_sorted_allocList+0x251>
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	8b 50 08             	mov    0x8(%eax),%edx
  802929:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292c:	8b 40 08             	mov    0x8(%eax),%eax
  80292f:	39 c2                	cmp    %eax,%edx
  802931:	73 6d                	jae    8029a0 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802933:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802937:	74 06                	je     80293f <insert_sorted_allocList+0x1f0>
  802939:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80293d:	75 14                	jne    802953 <insert_sorted_allocList+0x204>
  80293f:	83 ec 04             	sub    $0x4,%esp
  802942:	68 44 47 80 00       	push   $0x804744
  802947:	6a 7f                	push   $0x7f
  802949:	68 cf 46 80 00       	push   $0x8046cf
  80294e:	e8 62 e1 ff ff       	call   800ab5 <_panic>
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	8b 10                	mov    (%eax),%edx
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	89 10                	mov    %edx,(%eax)
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	8b 00                	mov    (%eax),%eax
  802962:	85 c0                	test   %eax,%eax
  802964:	74 0b                	je     802971 <insert_sorted_allocList+0x222>
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	8b 00                	mov    (%eax),%eax
  80296b:	8b 55 08             	mov    0x8(%ebp),%edx
  80296e:	89 50 04             	mov    %edx,0x4(%eax)
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	8b 55 08             	mov    0x8(%ebp),%edx
  802977:	89 10                	mov    %edx,(%eax)
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80297f:	89 50 04             	mov    %edx,0x4(%eax)
  802982:	8b 45 08             	mov    0x8(%ebp),%eax
  802985:	8b 00                	mov    (%eax),%eax
  802987:	85 c0                	test   %eax,%eax
  802989:	75 08                	jne    802993 <insert_sorted_allocList+0x244>
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	a3 44 50 80 00       	mov    %eax,0x805044
  802993:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802998:	40                   	inc    %eax
  802999:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80299e:	eb 39                	jmp    8029d9 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8029a0:	a1 48 50 80 00       	mov    0x805048,%eax
  8029a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ac:	74 07                	je     8029b5 <insert_sorted_allocList+0x266>
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 00                	mov    (%eax),%eax
  8029b3:	eb 05                	jmp    8029ba <insert_sorted_allocList+0x26b>
  8029b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ba:	a3 48 50 80 00       	mov    %eax,0x805048
  8029bf:	a1 48 50 80 00       	mov    0x805048,%eax
  8029c4:	85 c0                	test   %eax,%eax
  8029c6:	0f 85 3f ff ff ff    	jne    80290b <insert_sorted_allocList+0x1bc>
  8029cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d0:	0f 85 35 ff ff ff    	jne    80290b <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8029d6:	eb 01                	jmp    8029d9 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8029d8:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8029d9:	90                   	nop
  8029da:	c9                   	leave  
  8029db:	c3                   	ret    

008029dc <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8029dc:	55                   	push   %ebp
  8029dd:	89 e5                	mov    %esp,%ebp
  8029df:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8029e2:	a1 38 51 80 00       	mov    0x805138,%eax
  8029e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ea:	e9 85 01 00 00       	jmp    802b74 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f8:	0f 82 6e 01 00 00    	jb     802b6c <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 40 0c             	mov    0xc(%eax),%eax
  802a04:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a07:	0f 85 8a 00 00 00    	jne    802a97 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802a0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a11:	75 17                	jne    802a2a <alloc_block_FF+0x4e>
  802a13:	83 ec 04             	sub    $0x4,%esp
  802a16:	68 78 47 80 00       	push   $0x804778
  802a1b:	68 93 00 00 00       	push   $0x93
  802a20:	68 cf 46 80 00       	push   $0x8046cf
  802a25:	e8 8b e0 ff ff       	call   800ab5 <_panic>
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	8b 00                	mov    (%eax),%eax
  802a2f:	85 c0                	test   %eax,%eax
  802a31:	74 10                	je     802a43 <alloc_block_FF+0x67>
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	8b 00                	mov    (%eax),%eax
  802a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a3b:	8b 52 04             	mov    0x4(%edx),%edx
  802a3e:	89 50 04             	mov    %edx,0x4(%eax)
  802a41:	eb 0b                	jmp    802a4e <alloc_block_FF+0x72>
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 40 04             	mov    0x4(%eax),%eax
  802a49:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	8b 40 04             	mov    0x4(%eax),%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	74 0f                	je     802a67 <alloc_block_FF+0x8b>
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	8b 40 04             	mov    0x4(%eax),%eax
  802a5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a61:	8b 12                	mov    (%edx),%edx
  802a63:	89 10                	mov    %edx,(%eax)
  802a65:	eb 0a                	jmp    802a71 <alloc_block_FF+0x95>
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	a3 38 51 80 00       	mov    %eax,0x805138
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a84:	a1 44 51 80 00       	mov    0x805144,%eax
  802a89:	48                   	dec    %eax
  802a8a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	e9 10 01 00 00       	jmp    802ba7 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa0:	0f 86 c6 00 00 00    	jbe    802b6c <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aa6:	a1 48 51 80 00       	mov    0x805148,%eax
  802aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	8b 50 08             	mov    0x8(%eax),%edx
  802ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab7:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac0:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ac3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac7:	75 17                	jne    802ae0 <alloc_block_FF+0x104>
  802ac9:	83 ec 04             	sub    $0x4,%esp
  802acc:	68 78 47 80 00       	push   $0x804778
  802ad1:	68 9b 00 00 00       	push   $0x9b
  802ad6:	68 cf 46 80 00       	push   $0x8046cf
  802adb:	e8 d5 df ff ff       	call   800ab5 <_panic>
  802ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae3:	8b 00                	mov    (%eax),%eax
  802ae5:	85 c0                	test   %eax,%eax
  802ae7:	74 10                	je     802af9 <alloc_block_FF+0x11d>
  802ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aec:	8b 00                	mov    (%eax),%eax
  802aee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af1:	8b 52 04             	mov    0x4(%edx),%edx
  802af4:	89 50 04             	mov    %edx,0x4(%eax)
  802af7:	eb 0b                	jmp    802b04 <alloc_block_FF+0x128>
  802af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afc:	8b 40 04             	mov    0x4(%eax),%eax
  802aff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b07:	8b 40 04             	mov    0x4(%eax),%eax
  802b0a:	85 c0                	test   %eax,%eax
  802b0c:	74 0f                	je     802b1d <alloc_block_FF+0x141>
  802b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b11:	8b 40 04             	mov    0x4(%eax),%eax
  802b14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b17:	8b 12                	mov    (%edx),%edx
  802b19:	89 10                	mov    %edx,(%eax)
  802b1b:	eb 0a                	jmp    802b27 <alloc_block_FF+0x14b>
  802b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	a3 48 51 80 00       	mov    %eax,0x805148
  802b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3a:	a1 54 51 80 00       	mov    0x805154,%eax
  802b3f:	48                   	dec    %eax
  802b40:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 50 08             	mov    0x8(%eax),%edx
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	01 c2                	add    %eax,%edx
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5c:	2b 45 08             	sub    0x8(%ebp),%eax
  802b5f:	89 c2                	mov    %eax,%edx
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6a:	eb 3b                	jmp    802ba7 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802b6c:	a1 40 51 80 00       	mov    0x805140,%eax
  802b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b78:	74 07                	je     802b81 <alloc_block_FF+0x1a5>
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	8b 00                	mov    (%eax),%eax
  802b7f:	eb 05                	jmp    802b86 <alloc_block_FF+0x1aa>
  802b81:	b8 00 00 00 00       	mov    $0x0,%eax
  802b86:	a3 40 51 80 00       	mov    %eax,0x805140
  802b8b:	a1 40 51 80 00       	mov    0x805140,%eax
  802b90:	85 c0                	test   %eax,%eax
  802b92:	0f 85 57 fe ff ff    	jne    8029ef <alloc_block_FF+0x13>
  802b98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9c:	0f 85 4d fe ff ff    	jne    8029ef <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802ba2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ba7:	c9                   	leave  
  802ba8:	c3                   	ret    

00802ba9 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ba9:	55                   	push   %ebp
  802baa:	89 e5                	mov    %esp,%ebp
  802bac:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802baf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802bb6:	a1 38 51 80 00       	mov    0x805138,%eax
  802bbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bbe:	e9 df 00 00 00       	jmp    802ca2 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bcc:	0f 82 c8 00 00 00    	jb     802c9a <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bdb:	0f 85 8a 00 00 00    	jne    802c6b <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802be1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be5:	75 17                	jne    802bfe <alloc_block_BF+0x55>
  802be7:	83 ec 04             	sub    $0x4,%esp
  802bea:	68 78 47 80 00       	push   $0x804778
  802bef:	68 b7 00 00 00       	push   $0xb7
  802bf4:	68 cf 46 80 00       	push   $0x8046cf
  802bf9:	e8 b7 de ff ff       	call   800ab5 <_panic>
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 00                	mov    (%eax),%eax
  802c03:	85 c0                	test   %eax,%eax
  802c05:	74 10                	je     802c17 <alloc_block_BF+0x6e>
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0f:	8b 52 04             	mov    0x4(%edx),%edx
  802c12:	89 50 04             	mov    %edx,0x4(%eax)
  802c15:	eb 0b                	jmp    802c22 <alloc_block_BF+0x79>
  802c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1a:	8b 40 04             	mov    0x4(%eax),%eax
  802c1d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	8b 40 04             	mov    0x4(%eax),%eax
  802c28:	85 c0                	test   %eax,%eax
  802c2a:	74 0f                	je     802c3b <alloc_block_BF+0x92>
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 40 04             	mov    0x4(%eax),%eax
  802c32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c35:	8b 12                	mov    (%edx),%edx
  802c37:	89 10                	mov    %edx,(%eax)
  802c39:	eb 0a                	jmp    802c45 <alloc_block_BF+0x9c>
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	8b 00                	mov    (%eax),%eax
  802c40:	a3 38 51 80 00       	mov    %eax,0x805138
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c58:	a1 44 51 80 00       	mov    0x805144,%eax
  802c5d:	48                   	dec    %eax
  802c5e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	e9 4d 01 00 00       	jmp    802db8 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c71:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c74:	76 24                	jbe    802c9a <alloc_block_BF+0xf1>
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c7f:	73 19                	jae    802c9a <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802c81:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 40 08             	mov    0x8(%eax),%eax
  802c97:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802c9a:	a1 40 51 80 00       	mov    0x805140,%eax
  802c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca6:	74 07                	je     802caf <alloc_block_BF+0x106>
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	8b 00                	mov    (%eax),%eax
  802cad:	eb 05                	jmp    802cb4 <alloc_block_BF+0x10b>
  802caf:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb4:	a3 40 51 80 00       	mov    %eax,0x805140
  802cb9:	a1 40 51 80 00       	mov    0x805140,%eax
  802cbe:	85 c0                	test   %eax,%eax
  802cc0:	0f 85 fd fe ff ff    	jne    802bc3 <alloc_block_BF+0x1a>
  802cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cca:	0f 85 f3 fe ff ff    	jne    802bc3 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802cd0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cd4:	0f 84 d9 00 00 00    	je     802db3 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cda:	a1 48 51 80 00       	mov    0x805148,%eax
  802cdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802ce2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce8:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802ceb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cee:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf1:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802cf4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cf8:	75 17                	jne    802d11 <alloc_block_BF+0x168>
  802cfa:	83 ec 04             	sub    $0x4,%esp
  802cfd:	68 78 47 80 00       	push   $0x804778
  802d02:	68 c7 00 00 00       	push   $0xc7
  802d07:	68 cf 46 80 00       	push   $0x8046cf
  802d0c:	e8 a4 dd ff ff       	call   800ab5 <_panic>
  802d11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d14:	8b 00                	mov    (%eax),%eax
  802d16:	85 c0                	test   %eax,%eax
  802d18:	74 10                	je     802d2a <alloc_block_BF+0x181>
  802d1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d22:	8b 52 04             	mov    0x4(%edx),%edx
  802d25:	89 50 04             	mov    %edx,0x4(%eax)
  802d28:	eb 0b                	jmp    802d35 <alloc_block_BF+0x18c>
  802d2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d2d:	8b 40 04             	mov    0x4(%eax),%eax
  802d30:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d38:	8b 40 04             	mov    0x4(%eax),%eax
  802d3b:	85 c0                	test   %eax,%eax
  802d3d:	74 0f                	je     802d4e <alloc_block_BF+0x1a5>
  802d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d42:	8b 40 04             	mov    0x4(%eax),%eax
  802d45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d48:	8b 12                	mov    (%edx),%edx
  802d4a:	89 10                	mov    %edx,(%eax)
  802d4c:	eb 0a                	jmp    802d58 <alloc_block_BF+0x1af>
  802d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d51:	8b 00                	mov    (%eax),%eax
  802d53:	a3 48 51 80 00       	mov    %eax,0x805148
  802d58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6b:	a1 54 51 80 00       	mov    0x805154,%eax
  802d70:	48                   	dec    %eax
  802d71:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802d76:	83 ec 08             	sub    $0x8,%esp
  802d79:	ff 75 ec             	pushl  -0x14(%ebp)
  802d7c:	68 38 51 80 00       	push   $0x805138
  802d81:	e8 71 f9 ff ff       	call   8026f7 <find_block>
  802d86:	83 c4 10             	add    $0x10,%esp
  802d89:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802d8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d8f:	8b 50 08             	mov    0x8(%eax),%edx
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	01 c2                	add    %eax,%edx
  802d97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d9a:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802d9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da0:	8b 40 0c             	mov    0xc(%eax),%eax
  802da3:	2b 45 08             	sub    0x8(%ebp),%eax
  802da6:	89 c2                	mov    %eax,%edx
  802da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dab:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db1:	eb 05                	jmp    802db8 <alloc_block_BF+0x20f>
	}
	return NULL;
  802db3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802db8:	c9                   	leave  
  802db9:	c3                   	ret    

00802dba <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802dba:	55                   	push   %ebp
  802dbb:	89 e5                	mov    %esp,%ebp
  802dbd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802dc0:	a1 28 50 80 00       	mov    0x805028,%eax
  802dc5:	85 c0                	test   %eax,%eax
  802dc7:	0f 85 de 01 00 00    	jne    802fab <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802dcd:	a1 38 51 80 00       	mov    0x805138,%eax
  802dd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dd5:	e9 9e 01 00 00       	jmp    802f78 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddd:	8b 40 0c             	mov    0xc(%eax),%eax
  802de0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802de3:	0f 82 87 01 00 00    	jb     802f70 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	8b 40 0c             	mov    0xc(%eax),%eax
  802def:	3b 45 08             	cmp    0x8(%ebp),%eax
  802df2:	0f 85 95 00 00 00    	jne    802e8d <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802df8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfc:	75 17                	jne    802e15 <alloc_block_NF+0x5b>
  802dfe:	83 ec 04             	sub    $0x4,%esp
  802e01:	68 78 47 80 00       	push   $0x804778
  802e06:	68 e0 00 00 00       	push   $0xe0
  802e0b:	68 cf 46 80 00       	push   $0x8046cf
  802e10:	e8 a0 dc ff ff       	call   800ab5 <_panic>
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	8b 00                	mov    (%eax),%eax
  802e1a:	85 c0                	test   %eax,%eax
  802e1c:	74 10                	je     802e2e <alloc_block_NF+0x74>
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e26:	8b 52 04             	mov    0x4(%edx),%edx
  802e29:	89 50 04             	mov    %edx,0x4(%eax)
  802e2c:	eb 0b                	jmp    802e39 <alloc_block_NF+0x7f>
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 40 04             	mov    0x4(%eax),%eax
  802e34:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	8b 40 04             	mov    0x4(%eax),%eax
  802e3f:	85 c0                	test   %eax,%eax
  802e41:	74 0f                	je     802e52 <alloc_block_NF+0x98>
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	8b 40 04             	mov    0x4(%eax),%eax
  802e49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4c:	8b 12                	mov    (%edx),%edx
  802e4e:	89 10                	mov    %edx,(%eax)
  802e50:	eb 0a                	jmp    802e5c <alloc_block_NF+0xa2>
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	a3 38 51 80 00       	mov    %eax,0x805138
  802e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6f:	a1 44 51 80 00       	mov    0x805144,%eax
  802e74:	48                   	dec    %eax
  802e75:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	8b 40 08             	mov    0x8(%eax),%eax
  802e80:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	e9 f8 04 00 00       	jmp    803385 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 40 0c             	mov    0xc(%eax),%eax
  802e93:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e96:	0f 86 d4 00 00 00    	jbe    802f70 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e9c:	a1 48 51 80 00       	mov    0x805148,%eax
  802ea1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	8b 50 08             	mov    0x8(%eax),%edx
  802eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ead:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb3:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb6:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802eb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ebd:	75 17                	jne    802ed6 <alloc_block_NF+0x11c>
  802ebf:	83 ec 04             	sub    $0x4,%esp
  802ec2:	68 78 47 80 00       	push   $0x804778
  802ec7:	68 e9 00 00 00       	push   $0xe9
  802ecc:	68 cf 46 80 00       	push   $0x8046cf
  802ed1:	e8 df db ff ff       	call   800ab5 <_panic>
  802ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed9:	8b 00                	mov    (%eax),%eax
  802edb:	85 c0                	test   %eax,%eax
  802edd:	74 10                	je     802eef <alloc_block_NF+0x135>
  802edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee7:	8b 52 04             	mov    0x4(%edx),%edx
  802eea:	89 50 04             	mov    %edx,0x4(%eax)
  802eed:	eb 0b                	jmp    802efa <alloc_block_NF+0x140>
  802eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef2:	8b 40 04             	mov    0x4(%eax),%eax
  802ef5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efd:	8b 40 04             	mov    0x4(%eax),%eax
  802f00:	85 c0                	test   %eax,%eax
  802f02:	74 0f                	je     802f13 <alloc_block_NF+0x159>
  802f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f07:	8b 40 04             	mov    0x4(%eax),%eax
  802f0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0d:	8b 12                	mov    (%edx),%edx
  802f0f:	89 10                	mov    %edx,(%eax)
  802f11:	eb 0a                	jmp    802f1d <alloc_block_NF+0x163>
  802f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f16:	8b 00                	mov    (%eax),%eax
  802f18:	a3 48 51 80 00       	mov    %eax,0x805148
  802f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f30:	a1 54 51 80 00       	mov    0x805154,%eax
  802f35:	48                   	dec    %eax
  802f36:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3e:	8b 40 08             	mov    0x8(%eax),%eax
  802f41:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f49:	8b 50 08             	mov    0x8(%eax),%edx
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	01 c2                	add    %eax,%edx
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5d:	2b 45 08             	sub    0x8(%ebp),%eax
  802f60:	89 c2                	mov    %eax,%edx
  802f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f65:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6b:	e9 15 04 00 00       	jmp    803385 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802f70:	a1 40 51 80 00       	mov    0x805140,%eax
  802f75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f7c:	74 07                	je     802f85 <alloc_block_NF+0x1cb>
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	8b 00                	mov    (%eax),%eax
  802f83:	eb 05                	jmp    802f8a <alloc_block_NF+0x1d0>
  802f85:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8a:	a3 40 51 80 00       	mov    %eax,0x805140
  802f8f:	a1 40 51 80 00       	mov    0x805140,%eax
  802f94:	85 c0                	test   %eax,%eax
  802f96:	0f 85 3e fe ff ff    	jne    802dda <alloc_block_NF+0x20>
  802f9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa0:	0f 85 34 fe ff ff    	jne    802dda <alloc_block_NF+0x20>
  802fa6:	e9 d5 03 00 00       	jmp    803380 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fab:	a1 38 51 80 00       	mov    0x805138,%eax
  802fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb3:	e9 b1 01 00 00       	jmp    803169 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbb:	8b 50 08             	mov    0x8(%eax),%edx
  802fbe:	a1 28 50 80 00       	mov    0x805028,%eax
  802fc3:	39 c2                	cmp    %eax,%edx
  802fc5:	0f 82 96 01 00 00    	jb     803161 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fd4:	0f 82 87 01 00 00    	jb     803161 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fe3:	0f 85 95 00 00 00    	jne    80307e <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fed:	75 17                	jne    803006 <alloc_block_NF+0x24c>
  802fef:	83 ec 04             	sub    $0x4,%esp
  802ff2:	68 78 47 80 00       	push   $0x804778
  802ff7:	68 fc 00 00 00       	push   $0xfc
  802ffc:	68 cf 46 80 00       	push   $0x8046cf
  803001:	e8 af da ff ff       	call   800ab5 <_panic>
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	8b 00                	mov    (%eax),%eax
  80300b:	85 c0                	test   %eax,%eax
  80300d:	74 10                	je     80301f <alloc_block_NF+0x265>
  80300f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803012:	8b 00                	mov    (%eax),%eax
  803014:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803017:	8b 52 04             	mov    0x4(%edx),%edx
  80301a:	89 50 04             	mov    %edx,0x4(%eax)
  80301d:	eb 0b                	jmp    80302a <alloc_block_NF+0x270>
  80301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803022:	8b 40 04             	mov    0x4(%eax),%eax
  803025:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80302a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302d:	8b 40 04             	mov    0x4(%eax),%eax
  803030:	85 c0                	test   %eax,%eax
  803032:	74 0f                	je     803043 <alloc_block_NF+0x289>
  803034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803037:	8b 40 04             	mov    0x4(%eax),%eax
  80303a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80303d:	8b 12                	mov    (%edx),%edx
  80303f:	89 10                	mov    %edx,(%eax)
  803041:	eb 0a                	jmp    80304d <alloc_block_NF+0x293>
  803043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803046:	8b 00                	mov    (%eax),%eax
  803048:	a3 38 51 80 00       	mov    %eax,0x805138
  80304d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803050:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803059:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803060:	a1 44 51 80 00       	mov    0x805144,%eax
  803065:	48                   	dec    %eax
  803066:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80306b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306e:	8b 40 08             	mov    0x8(%eax),%eax
  803071:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803079:	e9 07 03 00 00       	jmp    803385 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	8b 40 0c             	mov    0xc(%eax),%eax
  803084:	3b 45 08             	cmp    0x8(%ebp),%eax
  803087:	0f 86 d4 00 00 00    	jbe    803161 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80308d:	a1 48 51 80 00       	mov    0x805148,%eax
  803092:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803098:	8b 50 08             	mov    0x8(%eax),%edx
  80309b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a7:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030ae:	75 17                	jne    8030c7 <alloc_block_NF+0x30d>
  8030b0:	83 ec 04             	sub    $0x4,%esp
  8030b3:	68 78 47 80 00       	push   $0x804778
  8030b8:	68 04 01 00 00       	push   $0x104
  8030bd:	68 cf 46 80 00       	push   $0x8046cf
  8030c2:	e8 ee d9 ff ff       	call   800ab5 <_panic>
  8030c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ca:	8b 00                	mov    (%eax),%eax
  8030cc:	85 c0                	test   %eax,%eax
  8030ce:	74 10                	je     8030e0 <alloc_block_NF+0x326>
  8030d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d3:	8b 00                	mov    (%eax),%eax
  8030d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030d8:	8b 52 04             	mov    0x4(%edx),%edx
  8030db:	89 50 04             	mov    %edx,0x4(%eax)
  8030de:	eb 0b                	jmp    8030eb <alloc_block_NF+0x331>
  8030e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e3:	8b 40 04             	mov    0x4(%eax),%eax
  8030e6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ee:	8b 40 04             	mov    0x4(%eax),%eax
  8030f1:	85 c0                	test   %eax,%eax
  8030f3:	74 0f                	je     803104 <alloc_block_NF+0x34a>
  8030f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f8:	8b 40 04             	mov    0x4(%eax),%eax
  8030fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030fe:	8b 12                	mov    (%edx),%edx
  803100:	89 10                	mov    %edx,(%eax)
  803102:	eb 0a                	jmp    80310e <alloc_block_NF+0x354>
  803104:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803107:	8b 00                	mov    (%eax),%eax
  803109:	a3 48 51 80 00       	mov    %eax,0x805148
  80310e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803111:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803117:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803121:	a1 54 51 80 00       	mov    0x805154,%eax
  803126:	48                   	dec    %eax
  803127:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80312c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312f:	8b 40 08             	mov    0x8(%eax),%eax
  803132:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313a:	8b 50 08             	mov    0x8(%eax),%edx
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	01 c2                	add    %eax,%edx
  803142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803145:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314b:	8b 40 0c             	mov    0xc(%eax),%eax
  80314e:	2b 45 08             	sub    0x8(%ebp),%eax
  803151:	89 c2                	mov    %eax,%edx
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803159:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315c:	e9 24 02 00 00       	jmp    803385 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803161:	a1 40 51 80 00       	mov    0x805140,%eax
  803166:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803169:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80316d:	74 07                	je     803176 <alloc_block_NF+0x3bc>
  80316f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803172:	8b 00                	mov    (%eax),%eax
  803174:	eb 05                	jmp    80317b <alloc_block_NF+0x3c1>
  803176:	b8 00 00 00 00       	mov    $0x0,%eax
  80317b:	a3 40 51 80 00       	mov    %eax,0x805140
  803180:	a1 40 51 80 00       	mov    0x805140,%eax
  803185:	85 c0                	test   %eax,%eax
  803187:	0f 85 2b fe ff ff    	jne    802fb8 <alloc_block_NF+0x1fe>
  80318d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803191:	0f 85 21 fe ff ff    	jne    802fb8 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803197:	a1 38 51 80 00       	mov    0x805138,%eax
  80319c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80319f:	e9 ae 01 00 00       	jmp    803352 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8031a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a7:	8b 50 08             	mov    0x8(%eax),%edx
  8031aa:	a1 28 50 80 00       	mov    0x805028,%eax
  8031af:	39 c2                	cmp    %eax,%edx
  8031b1:	0f 83 93 01 00 00    	jae    80334a <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031c0:	0f 82 84 01 00 00    	jb     80334a <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8031c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031cf:	0f 85 95 00 00 00    	jne    80326a <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8031d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d9:	75 17                	jne    8031f2 <alloc_block_NF+0x438>
  8031db:	83 ec 04             	sub    $0x4,%esp
  8031de:	68 78 47 80 00       	push   $0x804778
  8031e3:	68 14 01 00 00       	push   $0x114
  8031e8:	68 cf 46 80 00       	push   $0x8046cf
  8031ed:	e8 c3 d8 ff ff       	call   800ab5 <_panic>
  8031f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f5:	8b 00                	mov    (%eax),%eax
  8031f7:	85 c0                	test   %eax,%eax
  8031f9:	74 10                	je     80320b <alloc_block_NF+0x451>
  8031fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fe:	8b 00                	mov    (%eax),%eax
  803200:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803203:	8b 52 04             	mov    0x4(%edx),%edx
  803206:	89 50 04             	mov    %edx,0x4(%eax)
  803209:	eb 0b                	jmp    803216 <alloc_block_NF+0x45c>
  80320b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320e:	8b 40 04             	mov    0x4(%eax),%eax
  803211:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803219:	8b 40 04             	mov    0x4(%eax),%eax
  80321c:	85 c0                	test   %eax,%eax
  80321e:	74 0f                	je     80322f <alloc_block_NF+0x475>
  803220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803223:	8b 40 04             	mov    0x4(%eax),%eax
  803226:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803229:	8b 12                	mov    (%edx),%edx
  80322b:	89 10                	mov    %edx,(%eax)
  80322d:	eb 0a                	jmp    803239 <alloc_block_NF+0x47f>
  80322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803232:	8b 00                	mov    (%eax),%eax
  803234:	a3 38 51 80 00       	mov    %eax,0x805138
  803239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803245:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324c:	a1 44 51 80 00       	mov    0x805144,%eax
  803251:	48                   	dec    %eax
  803252:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325a:	8b 40 08             	mov    0x8(%eax),%eax
  80325d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803265:	e9 1b 01 00 00       	jmp    803385 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326d:	8b 40 0c             	mov    0xc(%eax),%eax
  803270:	3b 45 08             	cmp    0x8(%ebp),%eax
  803273:	0f 86 d1 00 00 00    	jbe    80334a <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803279:	a1 48 51 80 00       	mov    0x805148,%eax
  80327e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803284:	8b 50 08             	mov    0x8(%eax),%edx
  803287:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80328d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803290:	8b 55 08             	mov    0x8(%ebp),%edx
  803293:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803296:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80329a:	75 17                	jne    8032b3 <alloc_block_NF+0x4f9>
  80329c:	83 ec 04             	sub    $0x4,%esp
  80329f:	68 78 47 80 00       	push   $0x804778
  8032a4:	68 1c 01 00 00       	push   $0x11c
  8032a9:	68 cf 46 80 00       	push   $0x8046cf
  8032ae:	e8 02 d8 ff ff       	call   800ab5 <_panic>
  8032b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b6:	8b 00                	mov    (%eax),%eax
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	74 10                	je     8032cc <alloc_block_NF+0x512>
  8032bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032bf:	8b 00                	mov    (%eax),%eax
  8032c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032c4:	8b 52 04             	mov    0x4(%edx),%edx
  8032c7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ca:	eb 0b                	jmp    8032d7 <alloc_block_NF+0x51d>
  8032cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032cf:	8b 40 04             	mov    0x4(%eax),%eax
  8032d2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032da:	8b 40 04             	mov    0x4(%eax),%eax
  8032dd:	85 c0                	test   %eax,%eax
  8032df:	74 0f                	je     8032f0 <alloc_block_NF+0x536>
  8032e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e4:	8b 40 04             	mov    0x4(%eax),%eax
  8032e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032ea:	8b 12                	mov    (%edx),%edx
  8032ec:	89 10                	mov    %edx,(%eax)
  8032ee:	eb 0a                	jmp    8032fa <alloc_block_NF+0x540>
  8032f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f3:	8b 00                	mov    (%eax),%eax
  8032f5:	a3 48 51 80 00       	mov    %eax,0x805148
  8032fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803303:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803306:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80330d:	a1 54 51 80 00       	mov    0x805154,%eax
  803312:	48                   	dec    %eax
  803313:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803318:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331b:	8b 40 08             	mov    0x8(%eax),%eax
  80331e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803326:	8b 50 08             	mov    0x8(%eax),%edx
  803329:	8b 45 08             	mov    0x8(%ebp),%eax
  80332c:	01 c2                	add    %eax,%edx
  80332e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803331:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803337:	8b 40 0c             	mov    0xc(%eax),%eax
  80333a:	2b 45 08             	sub    0x8(%ebp),%eax
  80333d:	89 c2                	mov    %eax,%edx
  80333f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803342:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803345:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803348:	eb 3b                	jmp    803385 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80334a:	a1 40 51 80 00       	mov    0x805140,%eax
  80334f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803352:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803356:	74 07                	je     80335f <alloc_block_NF+0x5a5>
  803358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335b:	8b 00                	mov    (%eax),%eax
  80335d:	eb 05                	jmp    803364 <alloc_block_NF+0x5aa>
  80335f:	b8 00 00 00 00       	mov    $0x0,%eax
  803364:	a3 40 51 80 00       	mov    %eax,0x805140
  803369:	a1 40 51 80 00       	mov    0x805140,%eax
  80336e:	85 c0                	test   %eax,%eax
  803370:	0f 85 2e fe ff ff    	jne    8031a4 <alloc_block_NF+0x3ea>
  803376:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80337a:	0f 85 24 fe ff ff    	jne    8031a4 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803380:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803385:	c9                   	leave  
  803386:	c3                   	ret    

00803387 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803387:	55                   	push   %ebp
  803388:	89 e5                	mov    %esp,%ebp
  80338a:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80338d:	a1 38 51 80 00       	mov    0x805138,%eax
  803392:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803395:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80339a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80339d:	a1 38 51 80 00       	mov    0x805138,%eax
  8033a2:	85 c0                	test   %eax,%eax
  8033a4:	74 14                	je     8033ba <insert_sorted_with_merge_freeList+0x33>
  8033a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a9:	8b 50 08             	mov    0x8(%eax),%edx
  8033ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033af:	8b 40 08             	mov    0x8(%eax),%eax
  8033b2:	39 c2                	cmp    %eax,%edx
  8033b4:	0f 87 9b 01 00 00    	ja     803555 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8033ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033be:	75 17                	jne    8033d7 <insert_sorted_with_merge_freeList+0x50>
  8033c0:	83 ec 04             	sub    $0x4,%esp
  8033c3:	68 ac 46 80 00       	push   $0x8046ac
  8033c8:	68 38 01 00 00       	push   $0x138
  8033cd:	68 cf 46 80 00       	push   $0x8046cf
  8033d2:	e8 de d6 ff ff       	call   800ab5 <_panic>
  8033d7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e0:	89 10                	mov    %edx,(%eax)
  8033e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e5:	8b 00                	mov    (%eax),%eax
  8033e7:	85 c0                	test   %eax,%eax
  8033e9:	74 0d                	je     8033f8 <insert_sorted_with_merge_freeList+0x71>
  8033eb:	a1 38 51 80 00       	mov    0x805138,%eax
  8033f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f3:	89 50 04             	mov    %edx,0x4(%eax)
  8033f6:	eb 08                	jmp    803400 <insert_sorted_with_merge_freeList+0x79>
  8033f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803400:	8b 45 08             	mov    0x8(%ebp),%eax
  803403:	a3 38 51 80 00       	mov    %eax,0x805138
  803408:	8b 45 08             	mov    0x8(%ebp),%eax
  80340b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803412:	a1 44 51 80 00       	mov    0x805144,%eax
  803417:	40                   	inc    %eax
  803418:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80341d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803421:	0f 84 a8 06 00 00    	je     803acf <insert_sorted_with_merge_freeList+0x748>
  803427:	8b 45 08             	mov    0x8(%ebp),%eax
  80342a:	8b 50 08             	mov    0x8(%eax),%edx
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	8b 40 0c             	mov    0xc(%eax),%eax
  803433:	01 c2                	add    %eax,%edx
  803435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803438:	8b 40 08             	mov    0x8(%eax),%eax
  80343b:	39 c2                	cmp    %eax,%edx
  80343d:	0f 85 8c 06 00 00    	jne    803acf <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803443:	8b 45 08             	mov    0x8(%ebp),%eax
  803446:	8b 50 0c             	mov    0xc(%eax),%edx
  803449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344c:	8b 40 0c             	mov    0xc(%eax),%eax
  80344f:	01 c2                	add    %eax,%edx
  803451:	8b 45 08             	mov    0x8(%ebp),%eax
  803454:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803457:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80345b:	75 17                	jne    803474 <insert_sorted_with_merge_freeList+0xed>
  80345d:	83 ec 04             	sub    $0x4,%esp
  803460:	68 78 47 80 00       	push   $0x804778
  803465:	68 3c 01 00 00       	push   $0x13c
  80346a:	68 cf 46 80 00       	push   $0x8046cf
  80346f:	e8 41 d6 ff ff       	call   800ab5 <_panic>
  803474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803477:	8b 00                	mov    (%eax),%eax
  803479:	85 c0                	test   %eax,%eax
  80347b:	74 10                	je     80348d <insert_sorted_with_merge_freeList+0x106>
  80347d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803480:	8b 00                	mov    (%eax),%eax
  803482:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803485:	8b 52 04             	mov    0x4(%edx),%edx
  803488:	89 50 04             	mov    %edx,0x4(%eax)
  80348b:	eb 0b                	jmp    803498 <insert_sorted_with_merge_freeList+0x111>
  80348d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803490:	8b 40 04             	mov    0x4(%eax),%eax
  803493:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80349b:	8b 40 04             	mov    0x4(%eax),%eax
  80349e:	85 c0                	test   %eax,%eax
  8034a0:	74 0f                	je     8034b1 <insert_sorted_with_merge_freeList+0x12a>
  8034a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a5:	8b 40 04             	mov    0x4(%eax),%eax
  8034a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ab:	8b 12                	mov    (%edx),%edx
  8034ad:	89 10                	mov    %edx,(%eax)
  8034af:	eb 0a                	jmp    8034bb <insert_sorted_with_merge_freeList+0x134>
  8034b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b4:	8b 00                	mov    (%eax),%eax
  8034b6:	a3 38 51 80 00       	mov    %eax,0x805138
  8034bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ce:	a1 44 51 80 00       	mov    0x805144,%eax
  8034d3:	48                   	dec    %eax
  8034d4:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8034d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8034e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8034ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034f1:	75 17                	jne    80350a <insert_sorted_with_merge_freeList+0x183>
  8034f3:	83 ec 04             	sub    $0x4,%esp
  8034f6:	68 ac 46 80 00       	push   $0x8046ac
  8034fb:	68 3f 01 00 00       	push   $0x13f
  803500:	68 cf 46 80 00       	push   $0x8046cf
  803505:	e8 ab d5 ff ff       	call   800ab5 <_panic>
  80350a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803510:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803513:	89 10                	mov    %edx,(%eax)
  803515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803518:	8b 00                	mov    (%eax),%eax
  80351a:	85 c0                	test   %eax,%eax
  80351c:	74 0d                	je     80352b <insert_sorted_with_merge_freeList+0x1a4>
  80351e:	a1 48 51 80 00       	mov    0x805148,%eax
  803523:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803526:	89 50 04             	mov    %edx,0x4(%eax)
  803529:	eb 08                	jmp    803533 <insert_sorted_with_merge_freeList+0x1ac>
  80352b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803536:	a3 48 51 80 00       	mov    %eax,0x805148
  80353b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803545:	a1 54 51 80 00       	mov    0x805154,%eax
  80354a:	40                   	inc    %eax
  80354b:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803550:	e9 7a 05 00 00       	jmp    803acf <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803555:	8b 45 08             	mov    0x8(%ebp),%eax
  803558:	8b 50 08             	mov    0x8(%eax),%edx
  80355b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355e:	8b 40 08             	mov    0x8(%eax),%eax
  803561:	39 c2                	cmp    %eax,%edx
  803563:	0f 82 14 01 00 00    	jb     80367d <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803569:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356c:	8b 50 08             	mov    0x8(%eax),%edx
  80356f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803572:	8b 40 0c             	mov    0xc(%eax),%eax
  803575:	01 c2                	add    %eax,%edx
  803577:	8b 45 08             	mov    0x8(%ebp),%eax
  80357a:	8b 40 08             	mov    0x8(%eax),%eax
  80357d:	39 c2                	cmp    %eax,%edx
  80357f:	0f 85 90 00 00 00    	jne    803615 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803588:	8b 50 0c             	mov    0xc(%eax),%edx
  80358b:	8b 45 08             	mov    0x8(%ebp),%eax
  80358e:	8b 40 0c             	mov    0xc(%eax),%eax
  803591:	01 c2                	add    %eax,%edx
  803593:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803596:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803599:	8b 45 08             	mov    0x8(%ebp),%eax
  80359c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8035ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035b1:	75 17                	jne    8035ca <insert_sorted_with_merge_freeList+0x243>
  8035b3:	83 ec 04             	sub    $0x4,%esp
  8035b6:	68 ac 46 80 00       	push   $0x8046ac
  8035bb:	68 49 01 00 00       	push   $0x149
  8035c0:	68 cf 46 80 00       	push   $0x8046cf
  8035c5:	e8 eb d4 ff ff       	call   800ab5 <_panic>
  8035ca:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d3:	89 10                	mov    %edx,(%eax)
  8035d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d8:	8b 00                	mov    (%eax),%eax
  8035da:	85 c0                	test   %eax,%eax
  8035dc:	74 0d                	je     8035eb <insert_sorted_with_merge_freeList+0x264>
  8035de:	a1 48 51 80 00       	mov    0x805148,%eax
  8035e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e6:	89 50 04             	mov    %edx,0x4(%eax)
  8035e9:	eb 08                	jmp    8035f3 <insert_sorted_with_merge_freeList+0x26c>
  8035eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8035fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803605:	a1 54 51 80 00       	mov    0x805154,%eax
  80360a:	40                   	inc    %eax
  80360b:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803610:	e9 bb 04 00 00       	jmp    803ad0 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803615:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803619:	75 17                	jne    803632 <insert_sorted_with_merge_freeList+0x2ab>
  80361b:	83 ec 04             	sub    $0x4,%esp
  80361e:	68 20 47 80 00       	push   $0x804720
  803623:	68 4c 01 00 00       	push   $0x14c
  803628:	68 cf 46 80 00       	push   $0x8046cf
  80362d:	e8 83 d4 ff ff       	call   800ab5 <_panic>
  803632:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803638:	8b 45 08             	mov    0x8(%ebp),%eax
  80363b:	89 50 04             	mov    %edx,0x4(%eax)
  80363e:	8b 45 08             	mov    0x8(%ebp),%eax
  803641:	8b 40 04             	mov    0x4(%eax),%eax
  803644:	85 c0                	test   %eax,%eax
  803646:	74 0c                	je     803654 <insert_sorted_with_merge_freeList+0x2cd>
  803648:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80364d:	8b 55 08             	mov    0x8(%ebp),%edx
  803650:	89 10                	mov    %edx,(%eax)
  803652:	eb 08                	jmp    80365c <insert_sorted_with_merge_freeList+0x2d5>
  803654:	8b 45 08             	mov    0x8(%ebp),%eax
  803657:	a3 38 51 80 00       	mov    %eax,0x805138
  80365c:	8b 45 08             	mov    0x8(%ebp),%eax
  80365f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803664:	8b 45 08             	mov    0x8(%ebp),%eax
  803667:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80366d:	a1 44 51 80 00       	mov    0x805144,%eax
  803672:	40                   	inc    %eax
  803673:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803678:	e9 53 04 00 00       	jmp    803ad0 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80367d:	a1 38 51 80 00       	mov    0x805138,%eax
  803682:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803685:	e9 15 04 00 00       	jmp    803a9f <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80368a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368d:	8b 00                	mov    (%eax),%eax
  80368f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803692:	8b 45 08             	mov    0x8(%ebp),%eax
  803695:	8b 50 08             	mov    0x8(%eax),%edx
  803698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369b:	8b 40 08             	mov    0x8(%eax),%eax
  80369e:	39 c2                	cmp    %eax,%edx
  8036a0:	0f 86 f1 03 00 00    	jbe    803a97 <insert_sorted_with_merge_freeList+0x710>
  8036a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a9:	8b 50 08             	mov    0x8(%eax),%edx
  8036ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036af:	8b 40 08             	mov    0x8(%eax),%eax
  8036b2:	39 c2                	cmp    %eax,%edx
  8036b4:	0f 83 dd 03 00 00    	jae    803a97 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8036ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bd:	8b 50 08             	mov    0x8(%eax),%edx
  8036c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c6:	01 c2                	add    %eax,%edx
  8036c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cb:	8b 40 08             	mov    0x8(%eax),%eax
  8036ce:	39 c2                	cmp    %eax,%edx
  8036d0:	0f 85 b9 01 00 00    	jne    80388f <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8036d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d9:	8b 50 08             	mov    0x8(%eax),%edx
  8036dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036df:	8b 40 0c             	mov    0xc(%eax),%eax
  8036e2:	01 c2                	add    %eax,%edx
  8036e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e7:	8b 40 08             	mov    0x8(%eax),%eax
  8036ea:	39 c2                	cmp    %eax,%edx
  8036ec:	0f 85 0d 01 00 00    	jne    8037ff <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f5:	8b 50 0c             	mov    0xc(%eax),%edx
  8036f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8036fe:	01 c2                	add    %eax,%edx
  803700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803703:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803706:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80370a:	75 17                	jne    803723 <insert_sorted_with_merge_freeList+0x39c>
  80370c:	83 ec 04             	sub    $0x4,%esp
  80370f:	68 78 47 80 00       	push   $0x804778
  803714:	68 5c 01 00 00       	push   $0x15c
  803719:	68 cf 46 80 00       	push   $0x8046cf
  80371e:	e8 92 d3 ff ff       	call   800ab5 <_panic>
  803723:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803726:	8b 00                	mov    (%eax),%eax
  803728:	85 c0                	test   %eax,%eax
  80372a:	74 10                	je     80373c <insert_sorted_with_merge_freeList+0x3b5>
  80372c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372f:	8b 00                	mov    (%eax),%eax
  803731:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803734:	8b 52 04             	mov    0x4(%edx),%edx
  803737:	89 50 04             	mov    %edx,0x4(%eax)
  80373a:	eb 0b                	jmp    803747 <insert_sorted_with_merge_freeList+0x3c0>
  80373c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373f:	8b 40 04             	mov    0x4(%eax),%eax
  803742:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803747:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374a:	8b 40 04             	mov    0x4(%eax),%eax
  80374d:	85 c0                	test   %eax,%eax
  80374f:	74 0f                	je     803760 <insert_sorted_with_merge_freeList+0x3d9>
  803751:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803754:	8b 40 04             	mov    0x4(%eax),%eax
  803757:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80375a:	8b 12                	mov    (%edx),%edx
  80375c:	89 10                	mov    %edx,(%eax)
  80375e:	eb 0a                	jmp    80376a <insert_sorted_with_merge_freeList+0x3e3>
  803760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803763:	8b 00                	mov    (%eax),%eax
  803765:	a3 38 51 80 00       	mov    %eax,0x805138
  80376a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803773:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803776:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80377d:	a1 44 51 80 00       	mov    0x805144,%eax
  803782:	48                   	dec    %eax
  803783:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803788:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803792:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803795:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80379c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037a0:	75 17                	jne    8037b9 <insert_sorted_with_merge_freeList+0x432>
  8037a2:	83 ec 04             	sub    $0x4,%esp
  8037a5:	68 ac 46 80 00       	push   $0x8046ac
  8037aa:	68 5f 01 00 00       	push   $0x15f
  8037af:	68 cf 46 80 00       	push   $0x8046cf
  8037b4:	e8 fc d2 ff ff       	call   800ab5 <_panic>
  8037b9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c2:	89 10                	mov    %edx,(%eax)
  8037c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c7:	8b 00                	mov    (%eax),%eax
  8037c9:	85 c0                	test   %eax,%eax
  8037cb:	74 0d                	je     8037da <insert_sorted_with_merge_freeList+0x453>
  8037cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8037d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037d5:	89 50 04             	mov    %edx,0x4(%eax)
  8037d8:	eb 08                	jmp    8037e2 <insert_sorted_with_merge_freeList+0x45b>
  8037da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e5:	a3 48 51 80 00       	mov    %eax,0x805148
  8037ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f4:	a1 54 51 80 00       	mov    0x805154,%eax
  8037f9:	40                   	inc    %eax
  8037fa:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8037ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803802:	8b 50 0c             	mov    0xc(%eax),%edx
  803805:	8b 45 08             	mov    0x8(%ebp),%eax
  803808:	8b 40 0c             	mov    0xc(%eax),%eax
  80380b:	01 c2                	add    %eax,%edx
  80380d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803810:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803813:	8b 45 08             	mov    0x8(%ebp),%eax
  803816:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80381d:	8b 45 08             	mov    0x8(%ebp),%eax
  803820:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803827:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80382b:	75 17                	jne    803844 <insert_sorted_with_merge_freeList+0x4bd>
  80382d:	83 ec 04             	sub    $0x4,%esp
  803830:	68 ac 46 80 00       	push   $0x8046ac
  803835:	68 64 01 00 00       	push   $0x164
  80383a:	68 cf 46 80 00       	push   $0x8046cf
  80383f:	e8 71 d2 ff ff       	call   800ab5 <_panic>
  803844:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80384a:	8b 45 08             	mov    0x8(%ebp),%eax
  80384d:	89 10                	mov    %edx,(%eax)
  80384f:	8b 45 08             	mov    0x8(%ebp),%eax
  803852:	8b 00                	mov    (%eax),%eax
  803854:	85 c0                	test   %eax,%eax
  803856:	74 0d                	je     803865 <insert_sorted_with_merge_freeList+0x4de>
  803858:	a1 48 51 80 00       	mov    0x805148,%eax
  80385d:	8b 55 08             	mov    0x8(%ebp),%edx
  803860:	89 50 04             	mov    %edx,0x4(%eax)
  803863:	eb 08                	jmp    80386d <insert_sorted_with_merge_freeList+0x4e6>
  803865:	8b 45 08             	mov    0x8(%ebp),%eax
  803868:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80386d:	8b 45 08             	mov    0x8(%ebp),%eax
  803870:	a3 48 51 80 00       	mov    %eax,0x805148
  803875:	8b 45 08             	mov    0x8(%ebp),%eax
  803878:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80387f:	a1 54 51 80 00       	mov    0x805154,%eax
  803884:	40                   	inc    %eax
  803885:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80388a:	e9 41 02 00 00       	jmp    803ad0 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80388f:	8b 45 08             	mov    0x8(%ebp),%eax
  803892:	8b 50 08             	mov    0x8(%eax),%edx
  803895:	8b 45 08             	mov    0x8(%ebp),%eax
  803898:	8b 40 0c             	mov    0xc(%eax),%eax
  80389b:	01 c2                	add    %eax,%edx
  80389d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a0:	8b 40 08             	mov    0x8(%eax),%eax
  8038a3:	39 c2                	cmp    %eax,%edx
  8038a5:	0f 85 7c 01 00 00    	jne    803a27 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8038ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038af:	74 06                	je     8038b7 <insert_sorted_with_merge_freeList+0x530>
  8038b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038b5:	75 17                	jne    8038ce <insert_sorted_with_merge_freeList+0x547>
  8038b7:	83 ec 04             	sub    $0x4,%esp
  8038ba:	68 e8 46 80 00       	push   $0x8046e8
  8038bf:	68 69 01 00 00       	push   $0x169
  8038c4:	68 cf 46 80 00       	push   $0x8046cf
  8038c9:	e8 e7 d1 ff ff       	call   800ab5 <_panic>
  8038ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038d1:	8b 50 04             	mov    0x4(%eax),%edx
  8038d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d7:	89 50 04             	mov    %edx,0x4(%eax)
  8038da:	8b 45 08             	mov    0x8(%ebp),%eax
  8038dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038e0:	89 10                	mov    %edx,(%eax)
  8038e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e5:	8b 40 04             	mov    0x4(%eax),%eax
  8038e8:	85 c0                	test   %eax,%eax
  8038ea:	74 0d                	je     8038f9 <insert_sorted_with_merge_freeList+0x572>
  8038ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ef:	8b 40 04             	mov    0x4(%eax),%eax
  8038f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8038f5:	89 10                	mov    %edx,(%eax)
  8038f7:	eb 08                	jmp    803901 <insert_sorted_with_merge_freeList+0x57a>
  8038f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fc:	a3 38 51 80 00       	mov    %eax,0x805138
  803901:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803904:	8b 55 08             	mov    0x8(%ebp),%edx
  803907:	89 50 04             	mov    %edx,0x4(%eax)
  80390a:	a1 44 51 80 00       	mov    0x805144,%eax
  80390f:	40                   	inc    %eax
  803910:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803915:	8b 45 08             	mov    0x8(%ebp),%eax
  803918:	8b 50 0c             	mov    0xc(%eax),%edx
  80391b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391e:	8b 40 0c             	mov    0xc(%eax),%eax
  803921:	01 c2                	add    %eax,%edx
  803923:	8b 45 08             	mov    0x8(%ebp),%eax
  803926:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803929:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80392d:	75 17                	jne    803946 <insert_sorted_with_merge_freeList+0x5bf>
  80392f:	83 ec 04             	sub    $0x4,%esp
  803932:	68 78 47 80 00       	push   $0x804778
  803937:	68 6b 01 00 00       	push   $0x16b
  80393c:	68 cf 46 80 00       	push   $0x8046cf
  803941:	e8 6f d1 ff ff       	call   800ab5 <_panic>
  803946:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803949:	8b 00                	mov    (%eax),%eax
  80394b:	85 c0                	test   %eax,%eax
  80394d:	74 10                	je     80395f <insert_sorted_with_merge_freeList+0x5d8>
  80394f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803952:	8b 00                	mov    (%eax),%eax
  803954:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803957:	8b 52 04             	mov    0x4(%edx),%edx
  80395a:	89 50 04             	mov    %edx,0x4(%eax)
  80395d:	eb 0b                	jmp    80396a <insert_sorted_with_merge_freeList+0x5e3>
  80395f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803962:	8b 40 04             	mov    0x4(%eax),%eax
  803965:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80396a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396d:	8b 40 04             	mov    0x4(%eax),%eax
  803970:	85 c0                	test   %eax,%eax
  803972:	74 0f                	je     803983 <insert_sorted_with_merge_freeList+0x5fc>
  803974:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803977:	8b 40 04             	mov    0x4(%eax),%eax
  80397a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80397d:	8b 12                	mov    (%edx),%edx
  80397f:	89 10                	mov    %edx,(%eax)
  803981:	eb 0a                	jmp    80398d <insert_sorted_with_merge_freeList+0x606>
  803983:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803986:	8b 00                	mov    (%eax),%eax
  803988:	a3 38 51 80 00       	mov    %eax,0x805138
  80398d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803990:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803996:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803999:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8039a5:	48                   	dec    %eax
  8039a6:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8039ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8039b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8039bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039c3:	75 17                	jne    8039dc <insert_sorted_with_merge_freeList+0x655>
  8039c5:	83 ec 04             	sub    $0x4,%esp
  8039c8:	68 ac 46 80 00       	push   $0x8046ac
  8039cd:	68 6e 01 00 00       	push   $0x16e
  8039d2:	68 cf 46 80 00       	push   $0x8046cf
  8039d7:	e8 d9 d0 ff ff       	call   800ab5 <_panic>
  8039dc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e5:	89 10                	mov    %edx,(%eax)
  8039e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ea:	8b 00                	mov    (%eax),%eax
  8039ec:	85 c0                	test   %eax,%eax
  8039ee:	74 0d                	je     8039fd <insert_sorted_with_merge_freeList+0x676>
  8039f0:	a1 48 51 80 00       	mov    0x805148,%eax
  8039f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039f8:	89 50 04             	mov    %edx,0x4(%eax)
  8039fb:	eb 08                	jmp    803a05 <insert_sorted_with_merge_freeList+0x67e>
  8039fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a00:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a08:	a3 48 51 80 00       	mov    %eax,0x805148
  803a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a17:	a1 54 51 80 00       	mov    0x805154,%eax
  803a1c:	40                   	inc    %eax
  803a1d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803a22:	e9 a9 00 00 00       	jmp    803ad0 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803a27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a2b:	74 06                	je     803a33 <insert_sorted_with_merge_freeList+0x6ac>
  803a2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a31:	75 17                	jne    803a4a <insert_sorted_with_merge_freeList+0x6c3>
  803a33:	83 ec 04             	sub    $0x4,%esp
  803a36:	68 44 47 80 00       	push   $0x804744
  803a3b:	68 73 01 00 00       	push   $0x173
  803a40:	68 cf 46 80 00       	push   $0x8046cf
  803a45:	e8 6b d0 ff ff       	call   800ab5 <_panic>
  803a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4d:	8b 10                	mov    (%eax),%edx
  803a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a52:	89 10                	mov    %edx,(%eax)
  803a54:	8b 45 08             	mov    0x8(%ebp),%eax
  803a57:	8b 00                	mov    (%eax),%eax
  803a59:	85 c0                	test   %eax,%eax
  803a5b:	74 0b                	je     803a68 <insert_sorted_with_merge_freeList+0x6e1>
  803a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a60:	8b 00                	mov    (%eax),%eax
  803a62:	8b 55 08             	mov    0x8(%ebp),%edx
  803a65:	89 50 04             	mov    %edx,0x4(%eax)
  803a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a6b:	8b 55 08             	mov    0x8(%ebp),%edx
  803a6e:	89 10                	mov    %edx,(%eax)
  803a70:	8b 45 08             	mov    0x8(%ebp),%eax
  803a73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a76:	89 50 04             	mov    %edx,0x4(%eax)
  803a79:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7c:	8b 00                	mov    (%eax),%eax
  803a7e:	85 c0                	test   %eax,%eax
  803a80:	75 08                	jne    803a8a <insert_sorted_with_merge_freeList+0x703>
  803a82:	8b 45 08             	mov    0x8(%ebp),%eax
  803a85:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a8a:	a1 44 51 80 00       	mov    0x805144,%eax
  803a8f:	40                   	inc    %eax
  803a90:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803a95:	eb 39                	jmp    803ad0 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803a97:	a1 40 51 80 00       	mov    0x805140,%eax
  803a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aa3:	74 07                	je     803aac <insert_sorted_with_merge_freeList+0x725>
  803aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa8:	8b 00                	mov    (%eax),%eax
  803aaa:	eb 05                	jmp    803ab1 <insert_sorted_with_merge_freeList+0x72a>
  803aac:	b8 00 00 00 00       	mov    $0x0,%eax
  803ab1:	a3 40 51 80 00       	mov    %eax,0x805140
  803ab6:	a1 40 51 80 00       	mov    0x805140,%eax
  803abb:	85 c0                	test   %eax,%eax
  803abd:	0f 85 c7 fb ff ff    	jne    80368a <insert_sorted_with_merge_freeList+0x303>
  803ac3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ac7:	0f 85 bd fb ff ff    	jne    80368a <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803acd:	eb 01                	jmp    803ad0 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803acf:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803ad0:	90                   	nop
  803ad1:	c9                   	leave  
  803ad2:	c3                   	ret    
  803ad3:	90                   	nop

00803ad4 <__udivdi3>:
  803ad4:	55                   	push   %ebp
  803ad5:	57                   	push   %edi
  803ad6:	56                   	push   %esi
  803ad7:	53                   	push   %ebx
  803ad8:	83 ec 1c             	sub    $0x1c,%esp
  803adb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803adf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ae3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ae7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803aeb:	89 ca                	mov    %ecx,%edx
  803aed:	89 f8                	mov    %edi,%eax
  803aef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803af3:	85 f6                	test   %esi,%esi
  803af5:	75 2d                	jne    803b24 <__udivdi3+0x50>
  803af7:	39 cf                	cmp    %ecx,%edi
  803af9:	77 65                	ja     803b60 <__udivdi3+0x8c>
  803afb:	89 fd                	mov    %edi,%ebp
  803afd:	85 ff                	test   %edi,%edi
  803aff:	75 0b                	jne    803b0c <__udivdi3+0x38>
  803b01:	b8 01 00 00 00       	mov    $0x1,%eax
  803b06:	31 d2                	xor    %edx,%edx
  803b08:	f7 f7                	div    %edi
  803b0a:	89 c5                	mov    %eax,%ebp
  803b0c:	31 d2                	xor    %edx,%edx
  803b0e:	89 c8                	mov    %ecx,%eax
  803b10:	f7 f5                	div    %ebp
  803b12:	89 c1                	mov    %eax,%ecx
  803b14:	89 d8                	mov    %ebx,%eax
  803b16:	f7 f5                	div    %ebp
  803b18:	89 cf                	mov    %ecx,%edi
  803b1a:	89 fa                	mov    %edi,%edx
  803b1c:	83 c4 1c             	add    $0x1c,%esp
  803b1f:	5b                   	pop    %ebx
  803b20:	5e                   	pop    %esi
  803b21:	5f                   	pop    %edi
  803b22:	5d                   	pop    %ebp
  803b23:	c3                   	ret    
  803b24:	39 ce                	cmp    %ecx,%esi
  803b26:	77 28                	ja     803b50 <__udivdi3+0x7c>
  803b28:	0f bd fe             	bsr    %esi,%edi
  803b2b:	83 f7 1f             	xor    $0x1f,%edi
  803b2e:	75 40                	jne    803b70 <__udivdi3+0x9c>
  803b30:	39 ce                	cmp    %ecx,%esi
  803b32:	72 0a                	jb     803b3e <__udivdi3+0x6a>
  803b34:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b38:	0f 87 9e 00 00 00    	ja     803bdc <__udivdi3+0x108>
  803b3e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b43:	89 fa                	mov    %edi,%edx
  803b45:	83 c4 1c             	add    $0x1c,%esp
  803b48:	5b                   	pop    %ebx
  803b49:	5e                   	pop    %esi
  803b4a:	5f                   	pop    %edi
  803b4b:	5d                   	pop    %ebp
  803b4c:	c3                   	ret    
  803b4d:	8d 76 00             	lea    0x0(%esi),%esi
  803b50:	31 ff                	xor    %edi,%edi
  803b52:	31 c0                	xor    %eax,%eax
  803b54:	89 fa                	mov    %edi,%edx
  803b56:	83 c4 1c             	add    $0x1c,%esp
  803b59:	5b                   	pop    %ebx
  803b5a:	5e                   	pop    %esi
  803b5b:	5f                   	pop    %edi
  803b5c:	5d                   	pop    %ebp
  803b5d:	c3                   	ret    
  803b5e:	66 90                	xchg   %ax,%ax
  803b60:	89 d8                	mov    %ebx,%eax
  803b62:	f7 f7                	div    %edi
  803b64:	31 ff                	xor    %edi,%edi
  803b66:	89 fa                	mov    %edi,%edx
  803b68:	83 c4 1c             	add    $0x1c,%esp
  803b6b:	5b                   	pop    %ebx
  803b6c:	5e                   	pop    %esi
  803b6d:	5f                   	pop    %edi
  803b6e:	5d                   	pop    %ebp
  803b6f:	c3                   	ret    
  803b70:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b75:	89 eb                	mov    %ebp,%ebx
  803b77:	29 fb                	sub    %edi,%ebx
  803b79:	89 f9                	mov    %edi,%ecx
  803b7b:	d3 e6                	shl    %cl,%esi
  803b7d:	89 c5                	mov    %eax,%ebp
  803b7f:	88 d9                	mov    %bl,%cl
  803b81:	d3 ed                	shr    %cl,%ebp
  803b83:	89 e9                	mov    %ebp,%ecx
  803b85:	09 f1                	or     %esi,%ecx
  803b87:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b8b:	89 f9                	mov    %edi,%ecx
  803b8d:	d3 e0                	shl    %cl,%eax
  803b8f:	89 c5                	mov    %eax,%ebp
  803b91:	89 d6                	mov    %edx,%esi
  803b93:	88 d9                	mov    %bl,%cl
  803b95:	d3 ee                	shr    %cl,%esi
  803b97:	89 f9                	mov    %edi,%ecx
  803b99:	d3 e2                	shl    %cl,%edx
  803b9b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b9f:	88 d9                	mov    %bl,%cl
  803ba1:	d3 e8                	shr    %cl,%eax
  803ba3:	09 c2                	or     %eax,%edx
  803ba5:	89 d0                	mov    %edx,%eax
  803ba7:	89 f2                	mov    %esi,%edx
  803ba9:	f7 74 24 0c          	divl   0xc(%esp)
  803bad:	89 d6                	mov    %edx,%esi
  803baf:	89 c3                	mov    %eax,%ebx
  803bb1:	f7 e5                	mul    %ebp
  803bb3:	39 d6                	cmp    %edx,%esi
  803bb5:	72 19                	jb     803bd0 <__udivdi3+0xfc>
  803bb7:	74 0b                	je     803bc4 <__udivdi3+0xf0>
  803bb9:	89 d8                	mov    %ebx,%eax
  803bbb:	31 ff                	xor    %edi,%edi
  803bbd:	e9 58 ff ff ff       	jmp    803b1a <__udivdi3+0x46>
  803bc2:	66 90                	xchg   %ax,%ax
  803bc4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bc8:	89 f9                	mov    %edi,%ecx
  803bca:	d3 e2                	shl    %cl,%edx
  803bcc:	39 c2                	cmp    %eax,%edx
  803bce:	73 e9                	jae    803bb9 <__udivdi3+0xe5>
  803bd0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bd3:	31 ff                	xor    %edi,%edi
  803bd5:	e9 40 ff ff ff       	jmp    803b1a <__udivdi3+0x46>
  803bda:	66 90                	xchg   %ax,%ax
  803bdc:	31 c0                	xor    %eax,%eax
  803bde:	e9 37 ff ff ff       	jmp    803b1a <__udivdi3+0x46>
  803be3:	90                   	nop

00803be4 <__umoddi3>:
  803be4:	55                   	push   %ebp
  803be5:	57                   	push   %edi
  803be6:	56                   	push   %esi
  803be7:	53                   	push   %ebx
  803be8:	83 ec 1c             	sub    $0x1c,%esp
  803beb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bef:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bf3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bf7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803bfb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c03:	89 f3                	mov    %esi,%ebx
  803c05:	89 fa                	mov    %edi,%edx
  803c07:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c0b:	89 34 24             	mov    %esi,(%esp)
  803c0e:	85 c0                	test   %eax,%eax
  803c10:	75 1a                	jne    803c2c <__umoddi3+0x48>
  803c12:	39 f7                	cmp    %esi,%edi
  803c14:	0f 86 a2 00 00 00    	jbe    803cbc <__umoddi3+0xd8>
  803c1a:	89 c8                	mov    %ecx,%eax
  803c1c:	89 f2                	mov    %esi,%edx
  803c1e:	f7 f7                	div    %edi
  803c20:	89 d0                	mov    %edx,%eax
  803c22:	31 d2                	xor    %edx,%edx
  803c24:	83 c4 1c             	add    $0x1c,%esp
  803c27:	5b                   	pop    %ebx
  803c28:	5e                   	pop    %esi
  803c29:	5f                   	pop    %edi
  803c2a:	5d                   	pop    %ebp
  803c2b:	c3                   	ret    
  803c2c:	39 f0                	cmp    %esi,%eax
  803c2e:	0f 87 ac 00 00 00    	ja     803ce0 <__umoddi3+0xfc>
  803c34:	0f bd e8             	bsr    %eax,%ebp
  803c37:	83 f5 1f             	xor    $0x1f,%ebp
  803c3a:	0f 84 ac 00 00 00    	je     803cec <__umoddi3+0x108>
  803c40:	bf 20 00 00 00       	mov    $0x20,%edi
  803c45:	29 ef                	sub    %ebp,%edi
  803c47:	89 fe                	mov    %edi,%esi
  803c49:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c4d:	89 e9                	mov    %ebp,%ecx
  803c4f:	d3 e0                	shl    %cl,%eax
  803c51:	89 d7                	mov    %edx,%edi
  803c53:	89 f1                	mov    %esi,%ecx
  803c55:	d3 ef                	shr    %cl,%edi
  803c57:	09 c7                	or     %eax,%edi
  803c59:	89 e9                	mov    %ebp,%ecx
  803c5b:	d3 e2                	shl    %cl,%edx
  803c5d:	89 14 24             	mov    %edx,(%esp)
  803c60:	89 d8                	mov    %ebx,%eax
  803c62:	d3 e0                	shl    %cl,%eax
  803c64:	89 c2                	mov    %eax,%edx
  803c66:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c6a:	d3 e0                	shl    %cl,%eax
  803c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c70:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c74:	89 f1                	mov    %esi,%ecx
  803c76:	d3 e8                	shr    %cl,%eax
  803c78:	09 d0                	or     %edx,%eax
  803c7a:	d3 eb                	shr    %cl,%ebx
  803c7c:	89 da                	mov    %ebx,%edx
  803c7e:	f7 f7                	div    %edi
  803c80:	89 d3                	mov    %edx,%ebx
  803c82:	f7 24 24             	mull   (%esp)
  803c85:	89 c6                	mov    %eax,%esi
  803c87:	89 d1                	mov    %edx,%ecx
  803c89:	39 d3                	cmp    %edx,%ebx
  803c8b:	0f 82 87 00 00 00    	jb     803d18 <__umoddi3+0x134>
  803c91:	0f 84 91 00 00 00    	je     803d28 <__umoddi3+0x144>
  803c97:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c9b:	29 f2                	sub    %esi,%edx
  803c9d:	19 cb                	sbb    %ecx,%ebx
  803c9f:	89 d8                	mov    %ebx,%eax
  803ca1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ca5:	d3 e0                	shl    %cl,%eax
  803ca7:	89 e9                	mov    %ebp,%ecx
  803ca9:	d3 ea                	shr    %cl,%edx
  803cab:	09 d0                	or     %edx,%eax
  803cad:	89 e9                	mov    %ebp,%ecx
  803caf:	d3 eb                	shr    %cl,%ebx
  803cb1:	89 da                	mov    %ebx,%edx
  803cb3:	83 c4 1c             	add    $0x1c,%esp
  803cb6:	5b                   	pop    %ebx
  803cb7:	5e                   	pop    %esi
  803cb8:	5f                   	pop    %edi
  803cb9:	5d                   	pop    %ebp
  803cba:	c3                   	ret    
  803cbb:	90                   	nop
  803cbc:	89 fd                	mov    %edi,%ebp
  803cbe:	85 ff                	test   %edi,%edi
  803cc0:	75 0b                	jne    803ccd <__umoddi3+0xe9>
  803cc2:	b8 01 00 00 00       	mov    $0x1,%eax
  803cc7:	31 d2                	xor    %edx,%edx
  803cc9:	f7 f7                	div    %edi
  803ccb:	89 c5                	mov    %eax,%ebp
  803ccd:	89 f0                	mov    %esi,%eax
  803ccf:	31 d2                	xor    %edx,%edx
  803cd1:	f7 f5                	div    %ebp
  803cd3:	89 c8                	mov    %ecx,%eax
  803cd5:	f7 f5                	div    %ebp
  803cd7:	89 d0                	mov    %edx,%eax
  803cd9:	e9 44 ff ff ff       	jmp    803c22 <__umoddi3+0x3e>
  803cde:	66 90                	xchg   %ax,%ax
  803ce0:	89 c8                	mov    %ecx,%eax
  803ce2:	89 f2                	mov    %esi,%edx
  803ce4:	83 c4 1c             	add    $0x1c,%esp
  803ce7:	5b                   	pop    %ebx
  803ce8:	5e                   	pop    %esi
  803ce9:	5f                   	pop    %edi
  803cea:	5d                   	pop    %ebp
  803ceb:	c3                   	ret    
  803cec:	3b 04 24             	cmp    (%esp),%eax
  803cef:	72 06                	jb     803cf7 <__umoddi3+0x113>
  803cf1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cf5:	77 0f                	ja     803d06 <__umoddi3+0x122>
  803cf7:	89 f2                	mov    %esi,%edx
  803cf9:	29 f9                	sub    %edi,%ecx
  803cfb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803cff:	89 14 24             	mov    %edx,(%esp)
  803d02:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d06:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d0a:	8b 14 24             	mov    (%esp),%edx
  803d0d:	83 c4 1c             	add    $0x1c,%esp
  803d10:	5b                   	pop    %ebx
  803d11:	5e                   	pop    %esi
  803d12:	5f                   	pop    %edi
  803d13:	5d                   	pop    %ebp
  803d14:	c3                   	ret    
  803d15:	8d 76 00             	lea    0x0(%esi),%esi
  803d18:	2b 04 24             	sub    (%esp),%eax
  803d1b:	19 fa                	sbb    %edi,%edx
  803d1d:	89 d1                	mov    %edx,%ecx
  803d1f:	89 c6                	mov    %eax,%esi
  803d21:	e9 71 ff ff ff       	jmp    803c97 <__umoddi3+0xb3>
  803d26:	66 90                	xchg   %ax,%ax
  803d28:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d2c:	72 ea                	jb     803d18 <__umoddi3+0x134>
  803d2e:	89 d9                	mov    %ebx,%ecx
  803d30:	e9 62 ff ff ff       	jmp    803c97 <__umoddi3+0xb3>
