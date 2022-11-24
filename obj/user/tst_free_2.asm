
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
  800031:	e8 c0 09 00 00       	call   8009f6 <libmain>
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
  80004f:	a1 20 30 80 00       	mov    0x803020,%eax
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
  800078:	a1 20 30 80 00       	mov    0x803020,%eax
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
  800090:	68 80 25 80 00       	push   $0x802580
  800095:	6a 14                	push   $0x14
  800097:	68 9c 25 80 00       	push   $0x80259c
  80009c:	e8 91 0a 00 00       	call   800b32 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 df 1a 00 00       	call   801b8a <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	6a 03                	push   $0x3
  8000b3:	e8 79 20 00 00       	call   802131 <sys_bypassPageFault>
  8000b8:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000bb:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  8000c9:	e8 cb 1c 00 00       	call   801d99 <sys_calculate_free_frames>
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
  8000f6:	e8 9e 1c 00 00       	call   801d99 <sys_calculate_free_frames>
  8000fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 36 1d 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  800103:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800109:	01 c0                	add    %eax,%eax
  80010b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	e8 73 1a 00 00       	call   801b8a <malloc>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800120:	85 c0                	test   %eax,%eax
  800122:	78 14                	js     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 b0 25 80 00       	push   $0x8025b0
  80012c:	6a 2d                	push   $0x2d
  80012e:	68 9c 25 80 00       	push   $0x80259c
  800133:	e8 fa 09 00 00       	call   800b32 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 fc 1c 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  80013d:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800140:	3d 00 02 00 00       	cmp    $0x200,%eax
  800145:	74 14                	je     80015b <_main+0x123>
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 18 26 80 00       	push   $0x802618
  80014f:	6a 2e                	push   $0x2e
  800151:	68 9c 25 80 00       	push   $0x80259c
  800156:	e8 d7 09 00 00       	call   800b32 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  80015b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80015e:	01 c0                	add    %eax,%eax
  800160:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800163:	48                   	dec    %eax
  800164:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  80016a:	e8 2a 1c 00 00       	call   801d99 <sys_calculate_free_frames>
  80016f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800172:	e8 c2 1c 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  800177:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80017a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017d:	01 c0                	add    %eax,%eax
  80017f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	e8 ff 19 00 00       	call   801b8a <malloc>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800191:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800194:	89 c2                	mov    %eax,%edx
  800196:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a0:	39 c2                	cmp    %eax,%edx
  8001a2:	73 14                	jae    8001b8 <_main+0x180>
  8001a4:	83 ec 04             	sub    $0x4,%esp
  8001a7:	68 b0 25 80 00       	push   $0x8025b0
  8001ac:	6a 35                	push   $0x35
  8001ae:	68 9c 25 80 00       	push   $0x80259c
  8001b3:	e8 7a 09 00 00       	call   800b32 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8001b8:	e8 7c 1c 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  8001bd:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8001c0:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c5:	74 14                	je     8001db <_main+0x1a3>
  8001c7:	83 ec 04             	sub    $0x4,%esp
  8001ca:	68 18 26 80 00       	push   $0x802618
  8001cf:	6a 36                	push   $0x36
  8001d1:	68 9c 25 80 00       	push   $0x80259c
  8001d6:	e8 57 09 00 00       	call   800b32 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001de:	01 c0                	add    %eax,%eax
  8001e0:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001e3:	48                   	dec    %eax
  8001e4:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001ea:	e8 aa 1b 00 00       	call   801d99 <sys_calculate_free_frames>
  8001ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f2:	e8 42 1c 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  8001f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001fd:	01 c0                	add    %eax,%eax
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	50                   	push   %eax
  800203:	e8 82 19 00 00       	call   801b8a <malloc>
  800208:	83 c4 10             	add    $0x10,%esp
  80020b:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80020e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800211:	89 c2                	mov    %eax,%edx
  800213:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800216:	c1 e0 02             	shl    $0x2,%eax
  800219:	05 00 00 00 80       	add    $0x80000000,%eax
  80021e:	39 c2                	cmp    %eax,%edx
  800220:	73 14                	jae    800236 <_main+0x1fe>
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	68 b0 25 80 00       	push   $0x8025b0
  80022a:	6a 3d                	push   $0x3d
  80022c:	68 9c 25 80 00       	push   $0x80259c
  800231:	e8 fc 08 00 00       	call   800b32 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800236:	e8 fe 1b 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  80023b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80023e:	83 f8 01             	cmp    $0x1,%eax
  800241:	74 14                	je     800257 <_main+0x21f>
  800243:	83 ec 04             	sub    $0x4,%esp
  800246:	68 18 26 80 00       	push   $0x802618
  80024b:	6a 3e                	push   $0x3e
  80024d:	68 9c 25 80 00       	push   $0x80259c
  800252:	e8 db 08 00 00       	call   800b32 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  800257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80025a:	01 c0                	add    %eax,%eax
  80025c:	48                   	dec    %eax
  80025d:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800263:	e8 31 1b 00 00       	call   801d99 <sys_calculate_free_frames>
  800268:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80026b:	e8 c9 1b 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  800270:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800273:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800276:	01 c0                	add    %eax,%eax
  800278:	83 ec 0c             	sub    $0xc,%esp
  80027b:	50                   	push   %eax
  80027c:	e8 09 19 00 00       	call   801b8a <malloc>
  800281:	83 c4 10             	add    $0x10,%esp
  800284:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800287:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80028a:	89 c2                	mov    %eax,%edx
  80028c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80028f:	c1 e0 02             	shl    $0x2,%eax
  800292:	89 c1                	mov    %eax,%ecx
  800294:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800297:	c1 e0 02             	shl    $0x2,%eax
  80029a:	01 c8                	add    %ecx,%eax
  80029c:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a1:	39 c2                	cmp    %eax,%edx
  8002a3:	73 14                	jae    8002b9 <_main+0x281>
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	68 b0 25 80 00       	push   $0x8025b0
  8002ad:	6a 45                	push   $0x45
  8002af:	68 9c 25 80 00       	push   $0x80259c
  8002b4:	e8 79 08 00 00       	call   800b32 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  8002b9:	e8 7b 1b 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  8002be:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002c1:	83 f8 01             	cmp    $0x1,%eax
  8002c4:	74 14                	je     8002da <_main+0x2a2>
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	68 18 26 80 00       	push   $0x802618
  8002ce:	6a 46                	push   $0x46
  8002d0:	68 9c 25 80 00       	push   $0x80259c
  8002d5:	e8 58 08 00 00       	call   800b32 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  8002da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002dd:	01 c0                	add    %eax,%eax
  8002df:	48                   	dec    %eax
  8002e0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002e6:	e8 ae 1a 00 00       	call   801d99 <sys_calculate_free_frames>
  8002eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002ee:	e8 46 1b 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  8002f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  8002f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002f9:	89 d0                	mov    %edx,%eax
  8002fb:	01 c0                	add    %eax,%eax
  8002fd:	01 d0                	add    %edx,%eax
  8002ff:	01 c0                	add    %eax,%eax
  800301:	01 d0                	add    %edx,%eax
  800303:	83 ec 0c             	sub    $0xc,%esp
  800306:	50                   	push   %eax
  800307:	e8 7e 18 00 00       	call   801b8a <malloc>
  80030c:	83 c4 10             	add    $0x10,%esp
  80030f:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800312:	8b 45 90             	mov    -0x70(%ebp),%eax
  800315:	89 c2                	mov    %eax,%edx
  800317:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80031a:	c1 e0 02             	shl    $0x2,%eax
  80031d:	89 c1                	mov    %eax,%ecx
  80031f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800322:	c1 e0 03             	shl    $0x3,%eax
  800325:	01 c8                	add    %ecx,%eax
  800327:	05 00 00 00 80       	add    $0x80000000,%eax
  80032c:	39 c2                	cmp    %eax,%edx
  80032e:	73 14                	jae    800344 <_main+0x30c>
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	68 b0 25 80 00       	push   $0x8025b0
  800338:	6a 4d                	push   $0x4d
  80033a:	68 9c 25 80 00       	push   $0x80259c
  80033f:	e8 ee 07 00 00       	call   800b32 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800344:	e8 f0 1a 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  800349:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80034c:	83 f8 02             	cmp    $0x2,%eax
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 18 26 80 00       	push   $0x802618
  800359:	6a 4e                	push   $0x4e
  80035b:	68 9c 25 80 00       	push   $0x80259c
  800360:	e8 cd 07 00 00       	call   800b32 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
  800365:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800368:	89 d0                	mov    %edx,%eax
  80036a:	01 c0                	add    %eax,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	01 c0                	add    %eax,%eax
  800370:	01 d0                	add    %edx,%eax
  800372:	48                   	dec    %eax
  800373:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800379:	e8 1b 1a 00 00       	call   801d99 <sys_calculate_free_frames>
  80037e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800381:	e8 b3 1a 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  800386:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800389:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80038c:	89 c2                	mov    %eax,%edx
  80038e:	01 d2                	add    %edx,%edx
  800390:	01 d0                	add    %edx,%eax
  800392:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800395:	83 ec 0c             	sub    $0xc,%esp
  800398:	50                   	push   %eax
  800399:	e8 ec 17 00 00       	call   801b8a <malloc>
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8003a4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003a7:	89 c2                	mov    %eax,%edx
  8003a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ac:	c1 e0 02             	shl    $0x2,%eax
  8003af:	89 c1                	mov    %eax,%ecx
  8003b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b4:	c1 e0 04             	shl    $0x4,%eax
  8003b7:	01 c8                	add    %ecx,%eax
  8003b9:	05 00 00 00 80       	add    $0x80000000,%eax
  8003be:	39 c2                	cmp    %eax,%edx
  8003c0:	73 14                	jae    8003d6 <_main+0x39e>
  8003c2:	83 ec 04             	sub    $0x4,%esp
  8003c5:	68 b0 25 80 00       	push   $0x8025b0
  8003ca:	6a 55                	push   $0x55
  8003cc:	68 9c 25 80 00       	push   $0x80259c
  8003d1:	e8 5c 07 00 00       	call   800b32 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  8003d6:	e8 5e 1a 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  8003db:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8003de:	89 c2                	mov    %eax,%edx
  8003e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e3:	89 c1                	mov    %eax,%ecx
  8003e5:	01 c9                	add    %ecx,%ecx
  8003e7:	01 c8                	add    %ecx,%eax
  8003e9:	85 c0                	test   %eax,%eax
  8003eb:	79 05                	jns    8003f2 <_main+0x3ba>
  8003ed:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003f2:	c1 f8 0c             	sar    $0xc,%eax
  8003f5:	39 c2                	cmp    %eax,%edx
  8003f7:	74 14                	je     80040d <_main+0x3d5>
  8003f9:	83 ec 04             	sub    $0x4,%esp
  8003fc:	68 18 26 80 00       	push   $0x802618
  800401:	6a 56                	push   $0x56
  800403:	68 9c 25 80 00       	push   $0x80259c
  800408:	e8 25 07 00 00       	call   800b32 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		lastIndices[5] = (3*Mega - kilo)/sizeof(char) - 1;
  80040d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800410:	89 c2                	mov    %eax,%edx
  800412:	01 d2                	add    %edx,%edx
  800414:	01 d0                	add    %edx,%eax
  800416:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800419:	48                   	dec    %eax
  80041a:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800420:	e8 74 19 00 00       	call   801d99 <sys_calculate_free_frames>
  800425:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800428:	e8 0c 1a 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  80042d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  800430:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800433:	01 c0                	add    %eax,%eax
  800435:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800438:	83 ec 0c             	sub    $0xc,%esp
  80043b:	50                   	push   %eax
  80043c:	e8 49 17 00 00       	call   801b8a <malloc>
  800441:	83 c4 10             	add    $0x10,%esp
  800444:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800447:	8b 45 98             	mov    -0x68(%ebp),%eax
  80044a:	89 c1                	mov    %eax,%ecx
  80044c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80044f:	89 d0                	mov    %edx,%eax
  800451:	01 c0                	add    %eax,%eax
  800453:	01 d0                	add    %edx,%eax
  800455:	01 c0                	add    %eax,%eax
  800457:	01 d0                	add    %edx,%eax
  800459:	89 c2                	mov    %eax,%edx
  80045b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045e:	c1 e0 04             	shl    $0x4,%eax
  800461:	01 d0                	add    %edx,%eax
  800463:	05 00 00 00 80       	add    $0x80000000,%eax
  800468:	39 c1                	cmp    %eax,%ecx
  80046a:	73 14                	jae    800480 <_main+0x448>
  80046c:	83 ec 04             	sub    $0x4,%esp
  80046f:	68 b0 25 80 00       	push   $0x8025b0
  800474:	6a 5d                	push   $0x5d
  800476:	68 9c 25 80 00       	push   $0x80259c
  80047b:	e8 b2 06 00 00       	call   800b32 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800480:	e8 b4 19 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  800485:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800488:	3d 00 02 00 00       	cmp    $0x200,%eax
  80048d:	74 14                	je     8004a3 <_main+0x46b>
  80048f:	83 ec 04             	sub    $0x4,%esp
  800492:	68 18 26 80 00       	push   $0x802618
  800497:	6a 5e                	push   $0x5e
  800499:	68 9c 25 80 00       	push   $0x80259c
  80049e:	e8 8f 06 00 00       	call   800b32 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[6] = (2*Mega - kilo)/sizeof(char) - 1;
  8004a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004a6:	01 c0                	add    %eax,%eax
  8004a8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004ab:	48                   	dec    %eax
  8004ac:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	char x ;
	int y;
	char *byteArr ;
	//FREE ALL
	{
		int freeFrames = sys_calculate_free_frames() ;
  8004b2:	e8 e2 18 00 00       	call   801d99 <sys_calculate_free_frames>
  8004b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004ba:	e8 7a 19 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  8004bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  8004c2:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	50                   	push   %eax
  8004c9:	e8 fd 16 00 00       	call   801bcb <free>
  8004ce:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  8004d1:	e8 63 19 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  8004d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004d9:	29 c2                	sub    %eax,%edx
  8004db:	89 d0                	mov    %edx,%eax
  8004dd:	3d 00 02 00 00       	cmp    $0x200,%eax
  8004e2:	74 14                	je     8004f8 <_main+0x4c0>
  8004e4:	83 ec 04             	sub    $0x4,%esp
  8004e7:	68 48 26 80 00       	push   $0x802648
  8004ec:	6a 6b                	push   $0x6b
  8004ee:	68 9c 25 80 00       	push   $0x80259c
  8004f3:	e8 3a 06 00 00       	call   800b32 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004f8:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800501:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800504:	e8 0f 1c 00 00       	call   802118 <sys_rcr2>
  800509:	89 c2                	mov    %eax,%edx
  80050b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80050e:	39 c2                	cmp    %eax,%edx
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 84 26 80 00       	push   $0x802684
  80051a:	6a 6f                	push   $0x6f
  80051c:	68 9c 25 80 00       	push   $0x80259c
  800521:	e8 0c 06 00 00       	call   800b32 <_panic>
		byteArr[lastIndices[0]] = 10;
  800526:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  80052c:	89 c2                	mov    %eax,%edx
  80052e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800531:	01 d0                	add    %edx,%eax
  800533:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800536:	e8 dd 1b 00 00       	call   802118 <sys_rcr2>
  80053b:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  800541:	89 d1                	mov    %edx,%ecx
  800543:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800546:	01 ca                	add    %ecx,%edx
  800548:	39 d0                	cmp    %edx,%eax
  80054a:	74 14                	je     800560 <_main+0x528>
  80054c:	83 ec 04             	sub    $0x4,%esp
  80054f:	68 84 26 80 00       	push   $0x802684
  800554:	6a 71                	push   $0x71
  800556:	68 9c 25 80 00       	push   $0x80259c
  80055b:	e8 d2 05 00 00       	call   800b32 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800560:	e8 34 18 00 00       	call   801d99 <sys_calculate_free_frames>
  800565:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800568:	e8 cc 18 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  80056d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800570:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800573:	83 ec 0c             	sub    $0xc,%esp
  800576:	50                   	push   %eax
  800577:	e8 4f 16 00 00       	call   801bcb <free>
  80057c:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80057f:	e8 b5 18 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  800584:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800587:	29 c2                	sub    %eax,%edx
  800589:	89 d0                	mov    %edx,%eax
  80058b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800590:	74 14                	je     8005a6 <_main+0x56e>
  800592:	83 ec 04             	sub    $0x4,%esp
  800595:	68 48 26 80 00       	push   $0x802648
  80059a:	6a 76                	push   $0x76
  80059c:	68 9c 25 80 00       	push   $0x80259c
  8005a1:	e8 8c 05 00 00       	call   800b32 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  8005a6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8005ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005af:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005b2:	e8 61 1b 00 00       	call   802118 <sys_rcr2>
  8005b7:	89 c2                	mov    %eax,%edx
  8005b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005bc:	39 c2                	cmp    %eax,%edx
  8005be:	74 14                	je     8005d4 <_main+0x59c>
  8005c0:	83 ec 04             	sub    $0x4,%esp
  8005c3:	68 84 26 80 00       	push   $0x802684
  8005c8:	6a 7a                	push   $0x7a
  8005ca:	68 9c 25 80 00       	push   $0x80259c
  8005cf:	e8 5e 05 00 00       	call   800b32 <_panic>
		byteArr[lastIndices[1]] = 10;
  8005d4:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  8005da:	89 c2                	mov    %eax,%edx
  8005dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005df:	01 d0                	add    %edx,%eax
  8005e1:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005e4:	e8 2f 1b 00 00       	call   802118 <sys_rcr2>
  8005e9:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  8005ef:	89 d1                	mov    %edx,%ecx
  8005f1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005f4:	01 ca                	add    %ecx,%edx
  8005f6:	39 d0                	cmp    %edx,%eax
  8005f8:	74 14                	je     80060e <_main+0x5d6>
  8005fa:	83 ec 04             	sub    $0x4,%esp
  8005fd:	68 84 26 80 00       	push   $0x802684
  800602:	6a 7c                	push   $0x7c
  800604:	68 9c 25 80 00       	push   $0x80259c
  800609:	e8 24 05 00 00       	call   800b32 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80060e:	e8 86 17 00 00       	call   801d99 <sys_calculate_free_frames>
  800613:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800616:	e8 1e 18 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  80061b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  80061e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	50                   	push   %eax
  800625:	e8 a1 15 00 00       	call   801bcb <free>
  80062a:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  80062d:	e8 07 18 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  800632:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800635:	29 c2                	sub    %eax,%edx
  800637:	89 d0                	mov    %edx,%eax
  800639:	83 f8 01             	cmp    $0x1,%eax
  80063c:	74 17                	je     800655 <_main+0x61d>
  80063e:	83 ec 04             	sub    $0x4,%esp
  800641:	68 48 26 80 00       	push   $0x802648
  800646:	68 81 00 00 00       	push   $0x81
  80064b:	68 9c 25 80 00       	push   $0x80259c
  800650:	e8 dd 04 00 00       	call   800b32 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  800655:	8b 45 88             	mov    -0x78(%ebp),%eax
  800658:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80065b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80065e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800661:	e8 b2 1a 00 00       	call   802118 <sys_rcr2>
  800666:	89 c2                	mov    %eax,%edx
  800668:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80066b:	39 c2                	cmp    %eax,%edx
  80066d:	74 17                	je     800686 <_main+0x64e>
  80066f:	83 ec 04             	sub    $0x4,%esp
  800672:	68 84 26 80 00       	push   $0x802684
  800677:	68 85 00 00 00       	push   $0x85
  80067c:	68 9c 25 80 00       	push   $0x80259c
  800681:	e8 ac 04 00 00       	call   800b32 <_panic>
		byteArr[lastIndices[2]] = 10;
  800686:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  80068c:	89 c2                	mov    %eax,%edx
  80068e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800691:	01 d0                	add    %edx,%eax
  800693:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800696:	e8 7d 1a 00 00       	call   802118 <sys_rcr2>
  80069b:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  8006a1:	89 d1                	mov    %edx,%ecx
  8006a3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006a6:	01 ca                	add    %ecx,%edx
  8006a8:	39 d0                	cmp    %edx,%eax
  8006aa:	74 17                	je     8006c3 <_main+0x68b>
  8006ac:	83 ec 04             	sub    $0x4,%esp
  8006af:	68 84 26 80 00       	push   $0x802684
  8006b4:	68 87 00 00 00       	push   $0x87
  8006b9:	68 9c 25 80 00       	push   $0x80259c
  8006be:	e8 6f 04 00 00       	call   800b32 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8006c3:	e8 d1 16 00 00       	call   801d99 <sys_calculate_free_frames>
  8006c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006cb:	e8 69 17 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  8006d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  8006d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006d6:	83 ec 0c             	sub    $0xc,%esp
  8006d9:	50                   	push   %eax
  8006da:	e8 ec 14 00 00       	call   801bcb <free>
  8006df:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006e2:	e8 52 17 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  8006e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006ea:	29 c2                	sub    %eax,%edx
  8006ec:	89 d0                	mov    %edx,%eax
  8006ee:	83 f8 01             	cmp    $0x1,%eax
  8006f1:	74 17                	je     80070a <_main+0x6d2>
  8006f3:	83 ec 04             	sub    $0x4,%esp
  8006f6:	68 48 26 80 00       	push   $0x802648
  8006fb:	68 8c 00 00 00       	push   $0x8c
  800700:	68 9c 25 80 00       	push   $0x80259c
  800705:	e8 28 04 00 00       	call   800b32 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  80070a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80070d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800710:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800713:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800716:	e8 fd 19 00 00       	call   802118 <sys_rcr2>
  80071b:	89 c2                	mov    %eax,%edx
  80071d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800720:	39 c2                	cmp    %eax,%edx
  800722:	74 17                	je     80073b <_main+0x703>
  800724:	83 ec 04             	sub    $0x4,%esp
  800727:	68 84 26 80 00       	push   $0x802684
  80072c:	68 90 00 00 00       	push   $0x90
  800731:	68 9c 25 80 00       	push   $0x80259c
  800736:	e8 f7 03 00 00       	call   800b32 <_panic>
		byteArr[lastIndices[3]] = 10;
  80073b:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800741:	89 c2                	mov    %eax,%edx
  800743:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800746:	01 d0                	add    %edx,%eax
  800748:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80074b:	e8 c8 19 00 00       	call   802118 <sys_rcr2>
  800750:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800756:	89 d1                	mov    %edx,%ecx
  800758:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80075b:	01 ca                	add    %ecx,%edx
  80075d:	39 d0                	cmp    %edx,%eax
  80075f:	74 17                	je     800778 <_main+0x740>
  800761:	83 ec 04             	sub    $0x4,%esp
  800764:	68 84 26 80 00       	push   $0x802684
  800769:	68 92 00 00 00       	push   $0x92
  80076e:	68 9c 25 80 00       	push   $0x80259c
  800773:	e8 ba 03 00 00       	call   800b32 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800778:	e8 1c 16 00 00       	call   801d99 <sys_calculate_free_frames>
  80077d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800780:	e8 b4 16 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  800785:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  800788:	8b 45 90             	mov    -0x70(%ebp),%eax
  80078b:	83 ec 0c             	sub    $0xc,%esp
  80078e:	50                   	push   %eax
  80078f:	e8 37 14 00 00       	call   801bcb <free>
  800794:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2) panic("Wrong free: Extra or less pages are removed from PageFile");
  800797:	e8 9d 16 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  80079c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80079f:	29 c2                	sub    %eax,%edx
  8007a1:	89 d0                	mov    %edx,%eax
  8007a3:	83 f8 02             	cmp    $0x2,%eax
  8007a6:	74 17                	je     8007bf <_main+0x787>
  8007a8:	83 ec 04             	sub    $0x4,%esp
  8007ab:	68 48 26 80 00       	push   $0x802648
  8007b0:	68 97 00 00 00       	push   $0x97
  8007b5:	68 9c 25 80 00       	push   $0x80259c
  8007ba:	e8 73 03 00 00       	call   800b32 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  8007bf:	8b 45 90             	mov    -0x70(%ebp),%eax
  8007c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8007c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007c8:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007cb:	e8 48 19 00 00       	call   802118 <sys_rcr2>
  8007d0:	89 c2                	mov    %eax,%edx
  8007d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007d5:	39 c2                	cmp    %eax,%edx
  8007d7:	74 17                	je     8007f0 <_main+0x7b8>
  8007d9:	83 ec 04             	sub    $0x4,%esp
  8007dc:	68 84 26 80 00       	push   $0x802684
  8007e1:	68 9b 00 00 00       	push   $0x9b
  8007e6:	68 9c 25 80 00       	push   $0x80259c
  8007eb:	e8 42 03 00 00       	call   800b32 <_panic>
		byteArr[lastIndices[4]] = 10;
  8007f0:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  8007f6:	89 c2                	mov    %eax,%edx
  8007f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007fb:	01 d0                	add    %edx,%eax
  8007fd:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800800:	e8 13 19 00 00       	call   802118 <sys_rcr2>
  800805:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  80080b:	89 d1                	mov    %edx,%ecx
  80080d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800810:	01 ca                	add    %ecx,%edx
  800812:	39 d0                	cmp    %edx,%eax
  800814:	74 17                	je     80082d <_main+0x7f5>
  800816:	83 ec 04             	sub    $0x4,%esp
  800819:	68 84 26 80 00       	push   $0x802684
  80081e:	68 9d 00 00 00       	push   $0x9d
  800823:	68 9c 25 80 00       	push   $0x80259c
  800828:	e8 05 03 00 00       	call   800b32 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80082d:	e8 67 15 00 00       	call   801d99 <sys_calculate_free_frames>
  800832:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800835:	e8 ff 15 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  80083a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  80083d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800840:	83 ec 0c             	sub    $0xc,%esp
  800843:	50                   	push   %eax
  800844:	e8 82 13 00 00       	call   801bcb <free>
  800849:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/4096 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  80084c:	e8 e8 15 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  800851:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800854:	89 d1                	mov    %edx,%ecx
  800856:	29 c1                	sub    %eax,%ecx
  800858:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80085b:	89 c2                	mov    %eax,%edx
  80085d:	01 d2                	add    %edx,%edx
  80085f:	01 d0                	add    %edx,%eax
  800861:	85 c0                	test   %eax,%eax
  800863:	79 05                	jns    80086a <_main+0x832>
  800865:	05 ff 0f 00 00       	add    $0xfff,%eax
  80086a:	c1 f8 0c             	sar    $0xc,%eax
  80086d:	39 c1                	cmp    %eax,%ecx
  80086f:	74 17                	je     800888 <_main+0x850>
  800871:	83 ec 04             	sub    $0x4,%esp
  800874:	68 48 26 80 00       	push   $0x802648
  800879:	68 a2 00 00 00       	push   $0xa2
  80087e:	68 9c 25 80 00       	push   $0x80259c
  800883:	e8 aa 02 00 00       	call   800b32 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  800888:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80088b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80088e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800891:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800894:	e8 7f 18 00 00       	call   802118 <sys_rcr2>
  800899:	89 c2                	mov    %eax,%edx
  80089b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80089e:	39 c2                	cmp    %eax,%edx
  8008a0:	74 17                	je     8008b9 <_main+0x881>
  8008a2:	83 ec 04             	sub    $0x4,%esp
  8008a5:	68 84 26 80 00       	push   $0x802684
  8008aa:	68 a6 00 00 00       	push   $0xa6
  8008af:	68 9c 25 80 00       	push   $0x80259c
  8008b4:	e8 79 02 00 00       	call   800b32 <_panic>
		byteArr[lastIndices[5]] = 10;
  8008b9:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  8008bf:	89 c2                	mov    %eax,%edx
  8008c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008c4:	01 d0                	add    %edx,%eax
  8008c6:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8008c9:	e8 4a 18 00 00       	call   802118 <sys_rcr2>
  8008ce:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  8008d4:	89 d1                	mov    %edx,%ecx
  8008d6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8008d9:	01 ca                	add    %ecx,%edx
  8008db:	39 d0                	cmp    %edx,%eax
  8008dd:	74 17                	je     8008f6 <_main+0x8be>
  8008df:	83 ec 04             	sub    $0x4,%esp
  8008e2:	68 84 26 80 00       	push   $0x802684
  8008e7:	68 a8 00 00 00       	push   $0xa8
  8008ec:	68 9c 25 80 00       	push   $0x80259c
  8008f1:	e8 3c 02 00 00       	call   800b32 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8008f6:	e8 9e 14 00 00       	call   801d99 <sys_calculate_free_frames>
  8008fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008fe:	e8 36 15 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  800903:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  800906:	8b 45 98             	mov    -0x68(%ebp),%eax
  800909:	83 ec 0c             	sub    $0xc,%esp
  80090c:	50                   	push   %eax
  80090d:	e8 b9 12 00 00       	call   801bcb <free>
  800912:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  800915:	e8 1f 15 00 00       	call   801e39 <sys_pf_calculate_allocated_pages>
  80091a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80091d:	29 c2                	sub    %eax,%edx
  80091f:	89 d0                	mov    %edx,%eax
  800921:	3d 00 02 00 00       	cmp    $0x200,%eax
  800926:	74 17                	je     80093f <_main+0x907>
  800928:	83 ec 04             	sub    $0x4,%esp
  80092b:	68 48 26 80 00       	push   $0x802648
  800930:	68 ad 00 00 00       	push   $0xad
  800935:	68 9c 25 80 00       	push   $0x80259c
  80093a:	e8 f3 01 00 00       	call   800b32 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  80093f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800942:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800945:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800948:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80094b:	e8 c8 17 00 00       	call   802118 <sys_rcr2>
  800950:	89 c2                	mov    %eax,%edx
  800952:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800955:	39 c2                	cmp    %eax,%edx
  800957:	74 17                	je     800970 <_main+0x938>
  800959:	83 ec 04             	sub    $0x4,%esp
  80095c:	68 84 26 80 00       	push   $0x802684
  800961:	68 b1 00 00 00       	push   $0xb1
  800966:	68 9c 25 80 00       	push   $0x80259c
  80096b:	e8 c2 01 00 00       	call   800b32 <_panic>
		byteArr[lastIndices[6]] = 10;
  800970:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800976:	89 c2                	mov    %eax,%edx
  800978:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80097b:	01 d0                	add    %edx,%eax
  80097d:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800980:	e8 93 17 00 00       	call   802118 <sys_rcr2>
  800985:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  80098b:	89 d1                	mov    %edx,%ecx
  80098d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800990:	01 ca                	add    %ecx,%edx
  800992:	39 d0                	cmp    %edx,%eax
  800994:	74 17                	je     8009ad <_main+0x975>
  800996:	83 ec 04             	sub    $0x4,%esp
  800999:	68 84 26 80 00       	push   $0x802684
  80099e:	68 b3 00 00 00       	push   $0xb3
  8009a3:	68 9c 25 80 00       	push   $0x80259c
  8009a8:	e8 85 01 00 00       	call   800b32 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames() + 3) ) {panic("Wrong free: not all pages removed correctly at end");}
  8009ad:	e8 e7 13 00 00       	call   801d99 <sys_calculate_free_frames>
  8009b2:	8d 50 03             	lea    0x3(%eax),%edx
  8009b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009b8:	39 c2                	cmp    %eax,%edx
  8009ba:	74 17                	je     8009d3 <_main+0x99b>
  8009bc:	83 ec 04             	sub    $0x4,%esp
  8009bf:	68 c8 26 80 00       	push   $0x8026c8
  8009c4:	68 b5 00 00 00       	push   $0xb5
  8009c9:	68 9c 25 80 00       	push   $0x80259c
  8009ce:	e8 5f 01 00 00       	call   800b32 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  8009d3:	83 ec 0c             	sub    $0xc,%esp
  8009d6:	6a 00                	push   $0x0
  8009d8:	e8 54 17 00 00       	call   802131 <sys_bypassPageFault>
  8009dd:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  8009e0:	83 ec 0c             	sub    $0xc,%esp
  8009e3:	68 fc 26 80 00       	push   $0x8026fc
  8009e8:	e8 f9 03 00 00       	call   800de6 <cprintf>
  8009ed:	83 c4 10             	add    $0x10,%esp

	return;
  8009f0:	90                   	nop
}
  8009f1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8009f4:	c9                   	leave  
  8009f5:	c3                   	ret    

008009f6 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8009fc:	e8 78 16 00 00       	call   802079 <sys_getenvindex>
  800a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a07:	89 d0                	mov    %edx,%eax
  800a09:	c1 e0 03             	shl    $0x3,%eax
  800a0c:	01 d0                	add    %edx,%eax
  800a0e:	01 c0                	add    %eax,%eax
  800a10:	01 d0                	add    %edx,%eax
  800a12:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a19:	01 d0                	add    %edx,%eax
  800a1b:	c1 e0 04             	shl    $0x4,%eax
  800a1e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a23:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800a28:	a1 20 30 80 00       	mov    0x803020,%eax
  800a2d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800a33:	84 c0                	test   %al,%al
  800a35:	74 0f                	je     800a46 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800a37:	a1 20 30 80 00       	mov    0x803020,%eax
  800a3c:	05 5c 05 00 00       	add    $0x55c,%eax
  800a41:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a4a:	7e 0a                	jle    800a56 <libmain+0x60>
		binaryname = argv[0];
  800a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4f:	8b 00                	mov    (%eax),%eax
  800a51:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	ff 75 08             	pushl  0x8(%ebp)
  800a5f:	e8 d4 f5 ff ff       	call   800038 <_main>
  800a64:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800a67:	e8 1a 14 00 00       	call   801e86 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800a6c:	83 ec 0c             	sub    $0xc,%esp
  800a6f:	68 50 27 80 00       	push   $0x802750
  800a74:	e8 6d 03 00 00       	call   800de6 <cprintf>
  800a79:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800a7c:	a1 20 30 80 00       	mov    0x803020,%eax
  800a81:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800a87:	a1 20 30 80 00       	mov    0x803020,%eax
  800a8c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800a92:	83 ec 04             	sub    $0x4,%esp
  800a95:	52                   	push   %edx
  800a96:	50                   	push   %eax
  800a97:	68 78 27 80 00       	push   $0x802778
  800a9c:	e8 45 03 00 00       	call   800de6 <cprintf>
  800aa1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800aa4:	a1 20 30 80 00       	mov    0x803020,%eax
  800aa9:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800aaf:	a1 20 30 80 00       	mov    0x803020,%eax
  800ab4:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800aba:	a1 20 30 80 00       	mov    0x803020,%eax
  800abf:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800ac5:	51                   	push   %ecx
  800ac6:	52                   	push   %edx
  800ac7:	50                   	push   %eax
  800ac8:	68 a0 27 80 00       	push   $0x8027a0
  800acd:	e8 14 03 00 00       	call   800de6 <cprintf>
  800ad2:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ad5:	a1 20 30 80 00       	mov    0x803020,%eax
  800ada:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	50                   	push   %eax
  800ae4:	68 f8 27 80 00       	push   $0x8027f8
  800ae9:	e8 f8 02 00 00       	call   800de6 <cprintf>
  800aee:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800af1:	83 ec 0c             	sub    $0xc,%esp
  800af4:	68 50 27 80 00       	push   $0x802750
  800af9:	e8 e8 02 00 00       	call   800de6 <cprintf>
  800afe:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800b01:	e8 9a 13 00 00       	call   801ea0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800b06:	e8 19 00 00 00       	call   800b24 <exit>
}
  800b0b:	90                   	nop
  800b0c:	c9                   	leave  
  800b0d:	c3                   	ret    

00800b0e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800b14:	83 ec 0c             	sub    $0xc,%esp
  800b17:	6a 00                	push   $0x0
  800b19:	e8 27 15 00 00       	call   802045 <sys_destroy_env>
  800b1e:	83 c4 10             	add    $0x10,%esp
}
  800b21:	90                   	nop
  800b22:	c9                   	leave  
  800b23:	c3                   	ret    

00800b24 <exit>:

void
exit(void)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800b2a:	e8 7c 15 00 00       	call   8020ab <sys_exit_env>
}
  800b2f:	90                   	nop
  800b30:	c9                   	leave  
  800b31:	c3                   	ret    

00800b32 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800b38:	8d 45 10             	lea    0x10(%ebp),%eax
  800b3b:	83 c0 04             	add    $0x4,%eax
  800b3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800b41:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800b46:	85 c0                	test   %eax,%eax
  800b48:	74 16                	je     800b60 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800b4a:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	50                   	push   %eax
  800b53:	68 0c 28 80 00       	push   $0x80280c
  800b58:	e8 89 02 00 00       	call   800de6 <cprintf>
  800b5d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800b60:	a1 00 30 80 00       	mov    0x803000,%eax
  800b65:	ff 75 0c             	pushl  0xc(%ebp)
  800b68:	ff 75 08             	pushl  0x8(%ebp)
  800b6b:	50                   	push   %eax
  800b6c:	68 11 28 80 00       	push   $0x802811
  800b71:	e8 70 02 00 00       	call   800de6 <cprintf>
  800b76:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800b79:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7c:	83 ec 08             	sub    $0x8,%esp
  800b7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b82:	50                   	push   %eax
  800b83:	e8 f3 01 00 00       	call   800d7b <vcprintf>
  800b88:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800b8b:	83 ec 08             	sub    $0x8,%esp
  800b8e:	6a 00                	push   $0x0
  800b90:	68 2d 28 80 00       	push   $0x80282d
  800b95:	e8 e1 01 00 00       	call   800d7b <vcprintf>
  800b9a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b9d:	e8 82 ff ff ff       	call   800b24 <exit>

	// should not return here
	while (1) ;
  800ba2:	eb fe                	jmp    800ba2 <_panic+0x70>

00800ba4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800baa:	a1 20 30 80 00       	mov    0x803020,%eax
  800baf:	8b 50 74             	mov    0x74(%eax),%edx
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	39 c2                	cmp    %eax,%edx
  800bb7:	74 14                	je     800bcd <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800bb9:	83 ec 04             	sub    $0x4,%esp
  800bbc:	68 30 28 80 00       	push   $0x802830
  800bc1:	6a 26                	push   $0x26
  800bc3:	68 7c 28 80 00       	push   $0x80287c
  800bc8:	e8 65 ff ff ff       	call   800b32 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800bcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800bd4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bdb:	e9 c2 00 00 00       	jmp    800ca2 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	01 d0                	add    %edx,%eax
  800bef:	8b 00                	mov    (%eax),%eax
  800bf1:	85 c0                	test   %eax,%eax
  800bf3:	75 08                	jne    800bfd <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800bf5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800bf8:	e9 a2 00 00 00       	jmp    800c9f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800bfd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c04:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800c0b:	eb 69                	jmp    800c76 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800c0d:	a1 20 30 80 00       	mov    0x803020,%eax
  800c12:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800c18:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c1b:	89 d0                	mov    %edx,%eax
  800c1d:	01 c0                	add    %eax,%eax
  800c1f:	01 d0                	add    %edx,%eax
  800c21:	c1 e0 03             	shl    $0x3,%eax
  800c24:	01 c8                	add    %ecx,%eax
  800c26:	8a 40 04             	mov    0x4(%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	75 46                	jne    800c73 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800c2d:	a1 20 30 80 00       	mov    0x803020,%eax
  800c32:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800c38:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c3b:	89 d0                	mov    %edx,%eax
  800c3d:	01 c0                	add    %eax,%eax
  800c3f:	01 d0                	add    %edx,%eax
  800c41:	c1 e0 03             	shl    $0x3,%eax
  800c44:	01 c8                	add    %ecx,%eax
  800c46:	8b 00                	mov    (%eax),%eax
  800c48:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800c4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c53:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c58:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	01 c8                	add    %ecx,%eax
  800c64:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800c66:	39 c2                	cmp    %eax,%edx
  800c68:	75 09                	jne    800c73 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800c6a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800c71:	eb 12                	jmp    800c85 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c73:	ff 45 e8             	incl   -0x18(%ebp)
  800c76:	a1 20 30 80 00       	mov    0x803020,%eax
  800c7b:	8b 50 74             	mov    0x74(%eax),%edx
  800c7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c81:	39 c2                	cmp    %eax,%edx
  800c83:	77 88                	ja     800c0d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800c85:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c89:	75 14                	jne    800c9f <CheckWSWithoutLastIndex+0xfb>
			panic(
  800c8b:	83 ec 04             	sub    $0x4,%esp
  800c8e:	68 88 28 80 00       	push   $0x802888
  800c93:	6a 3a                	push   $0x3a
  800c95:	68 7c 28 80 00       	push   $0x80287c
  800c9a:	e8 93 fe ff ff       	call   800b32 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c9f:	ff 45 f0             	incl   -0x10(%ebp)
  800ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800ca8:	0f 8c 32 ff ff ff    	jl     800be0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800cae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800cb5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800cbc:	eb 26                	jmp    800ce4 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800cbe:	a1 20 30 80 00       	mov    0x803020,%eax
  800cc3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800cc9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ccc:	89 d0                	mov    %edx,%eax
  800cce:	01 c0                	add    %eax,%eax
  800cd0:	01 d0                	add    %edx,%eax
  800cd2:	c1 e0 03             	shl    $0x3,%eax
  800cd5:	01 c8                	add    %ecx,%eax
  800cd7:	8a 40 04             	mov    0x4(%eax),%al
  800cda:	3c 01                	cmp    $0x1,%al
  800cdc:	75 03                	jne    800ce1 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800cde:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ce1:	ff 45 e0             	incl   -0x20(%ebp)
  800ce4:	a1 20 30 80 00       	mov    0x803020,%eax
  800ce9:	8b 50 74             	mov    0x74(%eax),%edx
  800cec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cef:	39 c2                	cmp    %eax,%edx
  800cf1:	77 cb                	ja     800cbe <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cf6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800cf9:	74 14                	je     800d0f <CheckWSWithoutLastIndex+0x16b>
		panic(
  800cfb:	83 ec 04             	sub    $0x4,%esp
  800cfe:	68 dc 28 80 00       	push   $0x8028dc
  800d03:	6a 44                	push   $0x44
  800d05:	68 7c 28 80 00       	push   $0x80287c
  800d0a:	e8 23 fe ff ff       	call   800b32 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800d0f:	90                   	nop
  800d10:	c9                   	leave  
  800d11:	c3                   	ret    

00800d12 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	8b 00                	mov    (%eax),%eax
  800d1d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d23:	89 0a                	mov    %ecx,(%edx)
  800d25:	8b 55 08             	mov    0x8(%ebp),%edx
  800d28:	88 d1                	mov    %dl,%cl
  800d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8b 00                	mov    (%eax),%eax
  800d36:	3d ff 00 00 00       	cmp    $0xff,%eax
  800d3b:	75 2c                	jne    800d69 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800d3d:	a0 24 30 80 00       	mov    0x803024,%al
  800d42:	0f b6 c0             	movzbl %al,%eax
  800d45:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d48:	8b 12                	mov    (%edx),%edx
  800d4a:	89 d1                	mov    %edx,%ecx
  800d4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4f:	83 c2 08             	add    $0x8,%edx
  800d52:	83 ec 04             	sub    $0x4,%esp
  800d55:	50                   	push   %eax
  800d56:	51                   	push   %ecx
  800d57:	52                   	push   %edx
  800d58:	e8 7b 0f 00 00       	call   801cd8 <sys_cputs>
  800d5d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6c:	8b 40 04             	mov    0x4(%eax),%eax
  800d6f:	8d 50 01             	lea    0x1(%eax),%edx
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	89 50 04             	mov    %edx,0x4(%eax)
}
  800d78:	90                   	nop
  800d79:	c9                   	leave  
  800d7a:	c3                   	ret    

00800d7b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d84:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d8b:	00 00 00 
	b.cnt = 0;
  800d8e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d95:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	ff 75 08             	pushl  0x8(%ebp)
  800d9e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800da4:	50                   	push   %eax
  800da5:	68 12 0d 80 00       	push   $0x800d12
  800daa:	e8 11 02 00 00       	call   800fc0 <vprintfmt>
  800daf:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800db2:	a0 24 30 80 00       	mov    0x803024,%al
  800db7:	0f b6 c0             	movzbl %al,%eax
  800dba:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800dc0:	83 ec 04             	sub    $0x4,%esp
  800dc3:	50                   	push   %eax
  800dc4:	52                   	push   %edx
  800dc5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800dcb:	83 c0 08             	add    $0x8,%eax
  800dce:	50                   	push   %eax
  800dcf:	e8 04 0f 00 00       	call   801cd8 <sys_cputs>
  800dd4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800dd7:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800dde:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800de4:	c9                   	leave  
  800de5:	c3                   	ret    

00800de6 <cprintf>:

int cprintf(const char *fmt, ...) {
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800dec:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800df3:	8d 45 0c             	lea    0xc(%ebp),%eax
  800df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	83 ec 08             	sub    $0x8,%esp
  800dff:	ff 75 f4             	pushl  -0xc(%ebp)
  800e02:	50                   	push   %eax
  800e03:	e8 73 ff ff ff       	call   800d7b <vcprintf>
  800e08:	83 c4 10             	add    $0x10,%esp
  800e0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e11:	c9                   	leave  
  800e12:	c3                   	ret    

00800e13 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800e19:	e8 68 10 00 00       	call   801e86 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800e1e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800e21:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	83 ec 08             	sub    $0x8,%esp
  800e2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2d:	50                   	push   %eax
  800e2e:	e8 48 ff ff ff       	call   800d7b <vcprintf>
  800e33:	83 c4 10             	add    $0x10,%esp
  800e36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800e39:	e8 62 10 00 00       	call   801ea0 <sys_enable_interrupt>
	return cnt;
  800e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e41:	c9                   	leave  
  800e42:	c3                   	ret    

00800e43 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	53                   	push   %ebx
  800e47:	83 ec 14             	sub    $0x14,%esp
  800e4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e50:	8b 45 14             	mov    0x14(%ebp),%eax
  800e53:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e56:	8b 45 18             	mov    0x18(%ebp),%eax
  800e59:	ba 00 00 00 00       	mov    $0x0,%edx
  800e5e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e61:	77 55                	ja     800eb8 <printnum+0x75>
  800e63:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800e66:	72 05                	jb     800e6d <printnum+0x2a>
  800e68:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6b:	77 4b                	ja     800eb8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e6d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800e70:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800e73:	8b 45 18             	mov    0x18(%ebp),%eax
  800e76:	ba 00 00 00 00       	mov    $0x0,%edx
  800e7b:	52                   	push   %edx
  800e7c:	50                   	push   %eax
  800e7d:	ff 75 f4             	pushl  -0xc(%ebp)
  800e80:	ff 75 f0             	pushl  -0x10(%ebp)
  800e83:	e8 84 14 00 00       	call   80230c <__udivdi3>
  800e88:	83 c4 10             	add    $0x10,%esp
  800e8b:	83 ec 04             	sub    $0x4,%esp
  800e8e:	ff 75 20             	pushl  0x20(%ebp)
  800e91:	53                   	push   %ebx
  800e92:	ff 75 18             	pushl  0x18(%ebp)
  800e95:	52                   	push   %edx
  800e96:	50                   	push   %eax
  800e97:	ff 75 0c             	pushl  0xc(%ebp)
  800e9a:	ff 75 08             	pushl  0x8(%ebp)
  800e9d:	e8 a1 ff ff ff       	call   800e43 <printnum>
  800ea2:	83 c4 20             	add    $0x20,%esp
  800ea5:	eb 1a                	jmp    800ec1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ea7:	83 ec 08             	sub    $0x8,%esp
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	ff 75 20             	pushl  0x20(%ebp)
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	ff d0                	call   *%eax
  800eb5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800eb8:	ff 4d 1c             	decl   0x1c(%ebp)
  800ebb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ebf:	7f e6                	jg     800ea7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ec1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ec4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ecf:	53                   	push   %ebx
  800ed0:	51                   	push   %ecx
  800ed1:	52                   	push   %edx
  800ed2:	50                   	push   %eax
  800ed3:	e8 44 15 00 00       	call   80241c <__umoddi3>
  800ed8:	83 c4 10             	add    $0x10,%esp
  800edb:	05 54 2b 80 00       	add    $0x802b54,%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	0f be c0             	movsbl %al,%eax
  800ee5:	83 ec 08             	sub    $0x8,%esp
  800ee8:	ff 75 0c             	pushl  0xc(%ebp)
  800eeb:	50                   	push   %eax
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	ff d0                	call   *%eax
  800ef1:	83 c4 10             	add    $0x10,%esp
}
  800ef4:	90                   	nop
  800ef5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800efd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f01:	7e 1c                	jle    800f1f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8b 00                	mov    (%eax),%eax
  800f08:	8d 50 08             	lea    0x8(%eax),%edx
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	89 10                	mov    %edx,(%eax)
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8b 00                	mov    (%eax),%eax
  800f15:	83 e8 08             	sub    $0x8,%eax
  800f18:	8b 50 04             	mov    0x4(%eax),%edx
  800f1b:	8b 00                	mov    (%eax),%eax
  800f1d:	eb 40                	jmp    800f5f <getuint+0x65>
	else if (lflag)
  800f1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f23:	74 1e                	je     800f43 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8b 00                	mov    (%eax),%eax
  800f2a:	8d 50 04             	lea    0x4(%eax),%edx
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	89 10                	mov    %edx,(%eax)
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8b 00                	mov    (%eax),%eax
  800f37:	83 e8 04             	sub    $0x4,%eax
  800f3a:	8b 00                	mov    (%eax),%eax
  800f3c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f41:	eb 1c                	jmp    800f5f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8b 00                	mov    (%eax),%eax
  800f48:	8d 50 04             	lea    0x4(%eax),%edx
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	89 10                	mov    %edx,(%eax)
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8b 00                	mov    (%eax),%eax
  800f55:	83 e8 04             	sub    $0x4,%eax
  800f58:	8b 00                	mov    (%eax),%eax
  800f5a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800f64:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f68:	7e 1c                	jle    800f86 <getint+0x25>
		return va_arg(*ap, long long);
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8b 00                	mov    (%eax),%eax
  800f6f:	8d 50 08             	lea    0x8(%eax),%edx
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	89 10                	mov    %edx,(%eax)
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8b 00                	mov    (%eax),%eax
  800f7c:	83 e8 08             	sub    $0x8,%eax
  800f7f:	8b 50 04             	mov    0x4(%eax),%edx
  800f82:	8b 00                	mov    (%eax),%eax
  800f84:	eb 38                	jmp    800fbe <getint+0x5d>
	else if (lflag)
  800f86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f8a:	74 1a                	je     800fa6 <getint+0x45>
		return va_arg(*ap, long);
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	8b 00                	mov    (%eax),%eax
  800f91:	8d 50 04             	lea    0x4(%eax),%edx
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	89 10                	mov    %edx,(%eax)
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8b 00                	mov    (%eax),%eax
  800f9e:	83 e8 04             	sub    $0x4,%eax
  800fa1:	8b 00                	mov    (%eax),%eax
  800fa3:	99                   	cltd   
  800fa4:	eb 18                	jmp    800fbe <getint+0x5d>
	else
		return va_arg(*ap, int);
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8b 00                	mov    (%eax),%eax
  800fab:	8d 50 04             	lea    0x4(%eax),%edx
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	89 10                	mov    %edx,(%eax)
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8b 00                	mov    (%eax),%eax
  800fb8:	83 e8 04             	sub    $0x4,%eax
  800fbb:	8b 00                	mov    (%eax),%eax
  800fbd:	99                   	cltd   
}
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	56                   	push   %esi
  800fc4:	53                   	push   %ebx
  800fc5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fc8:	eb 17                	jmp    800fe1 <vprintfmt+0x21>
			if (ch == '\0')
  800fca:	85 db                	test   %ebx,%ebx
  800fcc:	0f 84 af 03 00 00    	je     801381 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	53                   	push   %ebx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	ff d0                	call   *%eax
  800fde:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe4:	8d 50 01             	lea    0x1(%eax),%edx
  800fe7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	0f b6 d8             	movzbl %al,%ebx
  800fef:	83 fb 25             	cmp    $0x25,%ebx
  800ff2:	75 d6                	jne    800fca <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ff4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ff8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800fff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801006:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80100d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801014:	8b 45 10             	mov    0x10(%ebp),%eax
  801017:	8d 50 01             	lea    0x1(%eax),%edx
  80101a:	89 55 10             	mov    %edx,0x10(%ebp)
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	0f b6 d8             	movzbl %al,%ebx
  801022:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801025:	83 f8 55             	cmp    $0x55,%eax
  801028:	0f 87 2b 03 00 00    	ja     801359 <vprintfmt+0x399>
  80102e:	8b 04 85 78 2b 80 00 	mov    0x802b78(,%eax,4),%eax
  801035:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801037:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80103b:	eb d7                	jmp    801014 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80103d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801041:	eb d1                	jmp    801014 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801043:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80104a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80104d:	89 d0                	mov    %edx,%eax
  80104f:	c1 e0 02             	shl    $0x2,%eax
  801052:	01 d0                	add    %edx,%eax
  801054:	01 c0                	add    %eax,%eax
  801056:	01 d8                	add    %ebx,%eax
  801058:	83 e8 30             	sub    $0x30,%eax
  80105b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801066:	83 fb 2f             	cmp    $0x2f,%ebx
  801069:	7e 3e                	jle    8010a9 <vprintfmt+0xe9>
  80106b:	83 fb 39             	cmp    $0x39,%ebx
  80106e:	7f 39                	jg     8010a9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801070:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801073:	eb d5                	jmp    80104a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801075:	8b 45 14             	mov    0x14(%ebp),%eax
  801078:	83 c0 04             	add    $0x4,%eax
  80107b:	89 45 14             	mov    %eax,0x14(%ebp)
  80107e:	8b 45 14             	mov    0x14(%ebp),%eax
  801081:	83 e8 04             	sub    $0x4,%eax
  801084:	8b 00                	mov    (%eax),%eax
  801086:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801089:	eb 1f                	jmp    8010aa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80108b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80108f:	79 83                	jns    801014 <vprintfmt+0x54>
				width = 0;
  801091:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801098:	e9 77 ff ff ff       	jmp    801014 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80109d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8010a4:	e9 6b ff ff ff       	jmp    801014 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8010a9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8010aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010ae:	0f 89 60 ff ff ff    	jns    801014 <vprintfmt+0x54>
				width = precision, precision = -1;
  8010b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010ba:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8010c1:	e9 4e ff ff ff       	jmp    801014 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8010c6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8010c9:	e9 46 ff ff ff       	jmp    801014 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8010ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d1:	83 c0 04             	add    $0x4,%eax
  8010d4:	89 45 14             	mov    %eax,0x14(%ebp)
  8010d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010da:	83 e8 04             	sub    $0x4,%eax
  8010dd:	8b 00                	mov    (%eax),%eax
  8010df:	83 ec 08             	sub    $0x8,%esp
  8010e2:	ff 75 0c             	pushl  0xc(%ebp)
  8010e5:	50                   	push   %eax
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	ff d0                	call   *%eax
  8010eb:	83 c4 10             	add    $0x10,%esp
			break;
  8010ee:	e9 89 02 00 00       	jmp    80137c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8010f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f6:	83 c0 04             	add    $0x4,%eax
  8010f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8010fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ff:	83 e8 04             	sub    $0x4,%eax
  801102:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801104:	85 db                	test   %ebx,%ebx
  801106:	79 02                	jns    80110a <vprintfmt+0x14a>
				err = -err;
  801108:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80110a:	83 fb 64             	cmp    $0x64,%ebx
  80110d:	7f 0b                	jg     80111a <vprintfmt+0x15a>
  80110f:	8b 34 9d c0 29 80 00 	mov    0x8029c0(,%ebx,4),%esi
  801116:	85 f6                	test   %esi,%esi
  801118:	75 19                	jne    801133 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80111a:	53                   	push   %ebx
  80111b:	68 65 2b 80 00       	push   $0x802b65
  801120:	ff 75 0c             	pushl  0xc(%ebp)
  801123:	ff 75 08             	pushl  0x8(%ebp)
  801126:	e8 5e 02 00 00       	call   801389 <printfmt>
  80112b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80112e:	e9 49 02 00 00       	jmp    80137c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801133:	56                   	push   %esi
  801134:	68 6e 2b 80 00       	push   $0x802b6e
  801139:	ff 75 0c             	pushl  0xc(%ebp)
  80113c:	ff 75 08             	pushl  0x8(%ebp)
  80113f:	e8 45 02 00 00       	call   801389 <printfmt>
  801144:	83 c4 10             	add    $0x10,%esp
			break;
  801147:	e9 30 02 00 00       	jmp    80137c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80114c:	8b 45 14             	mov    0x14(%ebp),%eax
  80114f:	83 c0 04             	add    $0x4,%eax
  801152:	89 45 14             	mov    %eax,0x14(%ebp)
  801155:	8b 45 14             	mov    0x14(%ebp),%eax
  801158:	83 e8 04             	sub    $0x4,%eax
  80115b:	8b 30                	mov    (%eax),%esi
  80115d:	85 f6                	test   %esi,%esi
  80115f:	75 05                	jne    801166 <vprintfmt+0x1a6>
				p = "(null)";
  801161:	be 71 2b 80 00       	mov    $0x802b71,%esi
			if (width > 0 && padc != '-')
  801166:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80116a:	7e 6d                	jle    8011d9 <vprintfmt+0x219>
  80116c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801170:	74 67                	je     8011d9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801172:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801175:	83 ec 08             	sub    $0x8,%esp
  801178:	50                   	push   %eax
  801179:	56                   	push   %esi
  80117a:	e8 0c 03 00 00       	call   80148b <strnlen>
  80117f:	83 c4 10             	add    $0x10,%esp
  801182:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801185:	eb 16                	jmp    80119d <vprintfmt+0x1dd>
					putch(padc, putdat);
  801187:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80118b:	83 ec 08             	sub    $0x8,%esp
  80118e:	ff 75 0c             	pushl  0xc(%ebp)
  801191:	50                   	push   %eax
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	ff d0                	call   *%eax
  801197:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80119a:	ff 4d e4             	decl   -0x1c(%ebp)
  80119d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a1:	7f e4                	jg     801187 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011a3:	eb 34                	jmp    8011d9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8011a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8011a9:	74 1c                	je     8011c7 <vprintfmt+0x207>
  8011ab:	83 fb 1f             	cmp    $0x1f,%ebx
  8011ae:	7e 05                	jle    8011b5 <vprintfmt+0x1f5>
  8011b0:	83 fb 7e             	cmp    $0x7e,%ebx
  8011b3:	7e 12                	jle    8011c7 <vprintfmt+0x207>
					putch('?', putdat);
  8011b5:	83 ec 08             	sub    $0x8,%esp
  8011b8:	ff 75 0c             	pushl  0xc(%ebp)
  8011bb:	6a 3f                	push   $0x3f
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	ff d0                	call   *%eax
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	eb 0f                	jmp    8011d6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8011c7:	83 ec 08             	sub    $0x8,%esp
  8011ca:	ff 75 0c             	pushl  0xc(%ebp)
  8011cd:	53                   	push   %ebx
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	ff d0                	call   *%eax
  8011d3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8011d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8011d9:	89 f0                	mov    %esi,%eax
  8011db:	8d 70 01             	lea    0x1(%eax),%esi
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	0f be d8             	movsbl %al,%ebx
  8011e3:	85 db                	test   %ebx,%ebx
  8011e5:	74 24                	je     80120b <vprintfmt+0x24b>
  8011e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011eb:	78 b8                	js     8011a5 <vprintfmt+0x1e5>
  8011ed:	ff 4d e0             	decl   -0x20(%ebp)
  8011f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011f4:	79 af                	jns    8011a5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8011f6:	eb 13                	jmp    80120b <vprintfmt+0x24b>
				putch(' ', putdat);
  8011f8:	83 ec 08             	sub    $0x8,%esp
  8011fb:	ff 75 0c             	pushl  0xc(%ebp)
  8011fe:	6a 20                	push   $0x20
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	ff d0                	call   *%eax
  801205:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801208:	ff 4d e4             	decl   -0x1c(%ebp)
  80120b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80120f:	7f e7                	jg     8011f8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801211:	e9 66 01 00 00       	jmp    80137c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801216:	83 ec 08             	sub    $0x8,%esp
  801219:	ff 75 e8             	pushl  -0x18(%ebp)
  80121c:	8d 45 14             	lea    0x14(%ebp),%eax
  80121f:	50                   	push   %eax
  801220:	e8 3c fd ff ff       	call   800f61 <getint>
  801225:	83 c4 10             	add    $0x10,%esp
  801228:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80122b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80122e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801231:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801234:	85 d2                	test   %edx,%edx
  801236:	79 23                	jns    80125b <vprintfmt+0x29b>
				putch('-', putdat);
  801238:	83 ec 08             	sub    $0x8,%esp
  80123b:	ff 75 0c             	pushl  0xc(%ebp)
  80123e:	6a 2d                	push   $0x2d
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	ff d0                	call   *%eax
  801245:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801248:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124e:	f7 d8                	neg    %eax
  801250:	83 d2 00             	adc    $0x0,%edx
  801253:	f7 da                	neg    %edx
  801255:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801258:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80125b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801262:	e9 bc 00 00 00       	jmp    801323 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801267:	83 ec 08             	sub    $0x8,%esp
  80126a:	ff 75 e8             	pushl  -0x18(%ebp)
  80126d:	8d 45 14             	lea    0x14(%ebp),%eax
  801270:	50                   	push   %eax
  801271:	e8 84 fc ff ff       	call   800efa <getuint>
  801276:	83 c4 10             	add    $0x10,%esp
  801279:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80127c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80127f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801286:	e9 98 00 00 00       	jmp    801323 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80128b:	83 ec 08             	sub    $0x8,%esp
  80128e:	ff 75 0c             	pushl  0xc(%ebp)
  801291:	6a 58                	push   $0x58
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	ff d0                	call   *%eax
  801298:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80129b:	83 ec 08             	sub    $0x8,%esp
  80129e:	ff 75 0c             	pushl  0xc(%ebp)
  8012a1:	6a 58                	push   $0x58
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	ff d0                	call   *%eax
  8012a8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8012ab:	83 ec 08             	sub    $0x8,%esp
  8012ae:	ff 75 0c             	pushl  0xc(%ebp)
  8012b1:	6a 58                	push   $0x58
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	ff d0                	call   *%eax
  8012b8:	83 c4 10             	add    $0x10,%esp
			break;
  8012bb:	e9 bc 00 00 00       	jmp    80137c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8012c0:	83 ec 08             	sub    $0x8,%esp
  8012c3:	ff 75 0c             	pushl  0xc(%ebp)
  8012c6:	6a 30                	push   $0x30
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	ff d0                	call   *%eax
  8012cd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8012d0:	83 ec 08             	sub    $0x8,%esp
  8012d3:	ff 75 0c             	pushl  0xc(%ebp)
  8012d6:	6a 78                	push   $0x78
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	ff d0                	call   *%eax
  8012dd:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8012e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e3:	83 c0 04             	add    $0x4,%eax
  8012e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8012e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ec:	83 e8 04             	sub    $0x4,%eax
  8012ef:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8012f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8012fb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801302:	eb 1f                	jmp    801323 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801304:	83 ec 08             	sub    $0x8,%esp
  801307:	ff 75 e8             	pushl  -0x18(%ebp)
  80130a:	8d 45 14             	lea    0x14(%ebp),%eax
  80130d:	50                   	push   %eax
  80130e:	e8 e7 fb ff ff       	call   800efa <getuint>
  801313:	83 c4 10             	add    $0x10,%esp
  801316:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801319:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80131c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801323:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801327:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80132a:	83 ec 04             	sub    $0x4,%esp
  80132d:	52                   	push   %edx
  80132e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801331:	50                   	push   %eax
  801332:	ff 75 f4             	pushl  -0xc(%ebp)
  801335:	ff 75 f0             	pushl  -0x10(%ebp)
  801338:	ff 75 0c             	pushl  0xc(%ebp)
  80133b:	ff 75 08             	pushl  0x8(%ebp)
  80133e:	e8 00 fb ff ff       	call   800e43 <printnum>
  801343:	83 c4 20             	add    $0x20,%esp
			break;
  801346:	eb 34                	jmp    80137c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801348:	83 ec 08             	sub    $0x8,%esp
  80134b:	ff 75 0c             	pushl  0xc(%ebp)
  80134e:	53                   	push   %ebx
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
  801352:	ff d0                	call   *%eax
  801354:	83 c4 10             	add    $0x10,%esp
			break;
  801357:	eb 23                	jmp    80137c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801359:	83 ec 08             	sub    $0x8,%esp
  80135c:	ff 75 0c             	pushl  0xc(%ebp)
  80135f:	6a 25                	push   $0x25
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	ff d0                	call   *%eax
  801366:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801369:	ff 4d 10             	decl   0x10(%ebp)
  80136c:	eb 03                	jmp    801371 <vprintfmt+0x3b1>
  80136e:	ff 4d 10             	decl   0x10(%ebp)
  801371:	8b 45 10             	mov    0x10(%ebp),%eax
  801374:	48                   	dec    %eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	3c 25                	cmp    $0x25,%al
  801379:	75 f3                	jne    80136e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80137b:	90                   	nop
		}
	}
  80137c:	e9 47 fc ff ff       	jmp    800fc8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801381:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801382:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801385:	5b                   	pop    %ebx
  801386:	5e                   	pop    %esi
  801387:	5d                   	pop    %ebp
  801388:	c3                   	ret    

00801389 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80138f:	8d 45 10             	lea    0x10(%ebp),%eax
  801392:	83 c0 04             	add    $0x4,%eax
  801395:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801398:	8b 45 10             	mov    0x10(%ebp),%eax
  80139b:	ff 75 f4             	pushl  -0xc(%ebp)
  80139e:	50                   	push   %eax
  80139f:	ff 75 0c             	pushl  0xc(%ebp)
  8013a2:	ff 75 08             	pushl  0x8(%ebp)
  8013a5:	e8 16 fc ff ff       	call   800fc0 <vprintfmt>
  8013aa:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8013ad:	90                   	nop
  8013ae:	c9                   	leave  
  8013af:	c3                   	ret    

008013b0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8013b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b6:	8b 40 08             	mov    0x8(%eax),%eax
  8013b9:	8d 50 01             	lea    0x1(%eax),%edx
  8013bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bf:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8013c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c5:	8b 10                	mov    (%eax),%edx
  8013c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ca:	8b 40 04             	mov    0x4(%eax),%eax
  8013cd:	39 c2                	cmp    %eax,%edx
  8013cf:	73 12                	jae    8013e3 <sprintputch+0x33>
		*b->buf++ = ch;
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	8b 00                	mov    (%eax),%eax
  8013d6:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013dc:	89 0a                	mov    %ecx,(%edx)
  8013de:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e1:	88 10                	mov    %dl,(%eax)
}
  8013e3:	90                   	nop
  8013e4:	5d                   	pop    %ebp
  8013e5:	c3                   	ret    

008013e6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
  8013e9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	01 d0                	add    %edx,%eax
  8013fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801400:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801407:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80140b:	74 06                	je     801413 <vsnprintf+0x2d>
  80140d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801411:	7f 07                	jg     80141a <vsnprintf+0x34>
		return -E_INVAL;
  801413:	b8 03 00 00 00       	mov    $0x3,%eax
  801418:	eb 20                	jmp    80143a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80141a:	ff 75 14             	pushl  0x14(%ebp)
  80141d:	ff 75 10             	pushl  0x10(%ebp)
  801420:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801423:	50                   	push   %eax
  801424:	68 b0 13 80 00       	push   $0x8013b0
  801429:	e8 92 fb ff ff       	call   800fc0 <vprintfmt>
  80142e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801431:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801434:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801437:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801442:	8d 45 10             	lea    0x10(%ebp),%eax
  801445:	83 c0 04             	add    $0x4,%eax
  801448:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80144b:	8b 45 10             	mov    0x10(%ebp),%eax
  80144e:	ff 75 f4             	pushl  -0xc(%ebp)
  801451:	50                   	push   %eax
  801452:	ff 75 0c             	pushl  0xc(%ebp)
  801455:	ff 75 08             	pushl  0x8(%ebp)
  801458:	e8 89 ff ff ff       	call   8013e6 <vsnprintf>
  80145d:	83 c4 10             	add    $0x10,%esp
  801460:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801463:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80146e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801475:	eb 06                	jmp    80147d <strlen+0x15>
		n++;
  801477:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80147a:	ff 45 08             	incl   0x8(%ebp)
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	84 c0                	test   %al,%al
  801484:	75 f1                	jne    801477 <strlen+0xf>
		n++;
	return n;
  801486:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
  80148e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801498:	eb 09                	jmp    8014a3 <strnlen+0x18>
		n++;
  80149a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80149d:	ff 45 08             	incl   0x8(%ebp)
  8014a0:	ff 4d 0c             	decl   0xc(%ebp)
  8014a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a7:	74 09                	je     8014b2 <strnlen+0x27>
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	84 c0                	test   %al,%al
  8014b0:	75 e8                	jne    80149a <strnlen+0xf>
		n++;
	return n;
  8014b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8014c3:	90                   	nop
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8014cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014d3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014d6:	8a 12                	mov    (%edx),%dl
  8014d8:	88 10                	mov    %dl,(%eax)
  8014da:	8a 00                	mov    (%eax),%al
  8014dc:	84 c0                	test   %al,%al
  8014de:	75 e4                	jne    8014c4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8014e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014f8:	eb 1f                	jmp    801519 <strncpy+0x34>
		*dst++ = *src;
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	8d 50 01             	lea    0x1(%eax),%edx
  801500:	89 55 08             	mov    %edx,0x8(%ebp)
  801503:	8b 55 0c             	mov    0xc(%ebp),%edx
  801506:	8a 12                	mov    (%edx),%dl
  801508:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80150a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150d:	8a 00                	mov    (%eax),%al
  80150f:	84 c0                	test   %al,%al
  801511:	74 03                	je     801516 <strncpy+0x31>
			src++;
  801513:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801516:	ff 45 fc             	incl   -0x4(%ebp)
  801519:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80151c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80151f:	72 d9                	jb     8014fa <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801521:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801532:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801536:	74 30                	je     801568 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801538:	eb 16                	jmp    801550 <strlcpy+0x2a>
			*dst++ = *src++;
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8d 50 01             	lea    0x1(%eax),%edx
  801540:	89 55 08             	mov    %edx,0x8(%ebp)
  801543:	8b 55 0c             	mov    0xc(%ebp),%edx
  801546:	8d 4a 01             	lea    0x1(%edx),%ecx
  801549:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80154c:	8a 12                	mov    (%edx),%dl
  80154e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801550:	ff 4d 10             	decl   0x10(%ebp)
  801553:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801557:	74 09                	je     801562 <strlcpy+0x3c>
  801559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	84 c0                	test   %al,%al
  801560:	75 d8                	jne    80153a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801568:	8b 55 08             	mov    0x8(%ebp),%edx
  80156b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80156e:	29 c2                	sub    %eax,%edx
  801570:	89 d0                	mov    %edx,%eax
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801577:	eb 06                	jmp    80157f <strcmp+0xb>
		p++, q++;
  801579:	ff 45 08             	incl   0x8(%ebp)
  80157c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	8a 00                	mov    (%eax),%al
  801584:	84 c0                	test   %al,%al
  801586:	74 0e                	je     801596 <strcmp+0x22>
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	8a 10                	mov    (%eax),%dl
  80158d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801590:	8a 00                	mov    (%eax),%al
  801592:	38 c2                	cmp    %al,%dl
  801594:	74 e3                	je     801579 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	8a 00                	mov    (%eax),%al
  80159b:	0f b6 d0             	movzbl %al,%edx
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	8a 00                	mov    (%eax),%al
  8015a3:	0f b6 c0             	movzbl %al,%eax
  8015a6:	29 c2                	sub    %eax,%edx
  8015a8:	89 d0                	mov    %edx,%eax
}
  8015aa:	5d                   	pop    %ebp
  8015ab:	c3                   	ret    

008015ac <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8015af:	eb 09                	jmp    8015ba <strncmp+0xe>
		n--, p++, q++;
  8015b1:	ff 4d 10             	decl   0x10(%ebp)
  8015b4:	ff 45 08             	incl   0x8(%ebp)
  8015b7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8015ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015be:	74 17                	je     8015d7 <strncmp+0x2b>
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	8a 00                	mov    (%eax),%al
  8015c5:	84 c0                	test   %al,%al
  8015c7:	74 0e                	je     8015d7 <strncmp+0x2b>
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8a 10                	mov    (%eax),%dl
  8015ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d1:	8a 00                	mov    (%eax),%al
  8015d3:	38 c2                	cmp    %al,%dl
  8015d5:	74 da                	je     8015b1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8015d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015db:	75 07                	jne    8015e4 <strncmp+0x38>
		return 0;
  8015dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e2:	eb 14                	jmp    8015f8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	8a 00                	mov    (%eax),%al
  8015e9:	0f b6 d0             	movzbl %al,%edx
  8015ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ef:	8a 00                	mov    (%eax),%al
  8015f1:	0f b6 c0             	movzbl %al,%eax
  8015f4:	29 c2                	sub    %eax,%edx
  8015f6:	89 d0                	mov    %edx,%eax
}
  8015f8:	5d                   	pop    %ebp
  8015f9:	c3                   	ret    

008015fa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	83 ec 04             	sub    $0x4,%esp
  801600:	8b 45 0c             	mov    0xc(%ebp),%eax
  801603:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801606:	eb 12                	jmp    80161a <strchr+0x20>
		if (*s == c)
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801610:	75 05                	jne    801617 <strchr+0x1d>
			return (char *) s;
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	eb 11                	jmp    801628 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801617:	ff 45 08             	incl   0x8(%ebp)
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	84 c0                	test   %al,%al
  801621:	75 e5                	jne    801608 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801623:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 04             	sub    $0x4,%esp
  801630:	8b 45 0c             	mov    0xc(%ebp),%eax
  801633:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801636:	eb 0d                	jmp    801645 <strfind+0x1b>
		if (*s == c)
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	8a 00                	mov    (%eax),%al
  80163d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801640:	74 0e                	je     801650 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801642:	ff 45 08             	incl   0x8(%ebp)
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	8a 00                	mov    (%eax),%al
  80164a:	84 c0                	test   %al,%al
  80164c:	75 ea                	jne    801638 <strfind+0xe>
  80164e:	eb 01                	jmp    801651 <strfind+0x27>
		if (*s == c)
			break;
  801650:	90                   	nop
	return (char *) s;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801668:	eb 0e                	jmp    801678 <memset+0x22>
		*p++ = c;
  80166a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80166d:	8d 50 01             	lea    0x1(%eax),%edx
  801670:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801673:	8b 55 0c             	mov    0xc(%ebp),%edx
  801676:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801678:	ff 4d f8             	decl   -0x8(%ebp)
  80167b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80167f:	79 e9                	jns    80166a <memset+0x14>
		*p++ = c;

	return v;
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80168c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801698:	eb 16                	jmp    8016b0 <memcpy+0x2a>
		*d++ = *s++;
  80169a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169d:	8d 50 01             	lea    0x1(%eax),%edx
  8016a0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016a9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016ac:	8a 12                	mov    (%edx),%dl
  8016ae:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8016b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	75 dd                	jne    80169a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8016c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016da:	73 50                	jae    80172c <memmove+0x6a>
  8016dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016df:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e2:	01 d0                	add    %edx,%eax
  8016e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016e7:	76 43                	jbe    80172c <memmove+0x6a>
		s += n;
  8016e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ec:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016f5:	eb 10                	jmp    801707 <memmove+0x45>
			*--d = *--s;
  8016f7:	ff 4d f8             	decl   -0x8(%ebp)
  8016fa:	ff 4d fc             	decl   -0x4(%ebp)
  8016fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801700:	8a 10                	mov    (%eax),%dl
  801702:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801705:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801707:	8b 45 10             	mov    0x10(%ebp),%eax
  80170a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80170d:	89 55 10             	mov    %edx,0x10(%ebp)
  801710:	85 c0                	test   %eax,%eax
  801712:	75 e3                	jne    8016f7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801714:	eb 23                	jmp    801739 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801716:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801719:	8d 50 01             	lea    0x1(%eax),%edx
  80171c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80171f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801722:	8d 4a 01             	lea    0x1(%edx),%ecx
  801725:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801728:	8a 12                	mov    (%edx),%dl
  80172a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80172c:	8b 45 10             	mov    0x10(%ebp),%eax
  80172f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801732:	89 55 10             	mov    %edx,0x10(%ebp)
  801735:	85 c0                	test   %eax,%eax
  801737:	75 dd                	jne    801716 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80174a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801750:	eb 2a                	jmp    80177c <memcmp+0x3e>
		if (*s1 != *s2)
  801752:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801755:	8a 10                	mov    (%eax),%dl
  801757:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	38 c2                	cmp    %al,%dl
  80175e:	74 16                	je     801776 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801760:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801763:	8a 00                	mov    (%eax),%al
  801765:	0f b6 d0             	movzbl %al,%edx
  801768:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176b:	8a 00                	mov    (%eax),%al
  80176d:	0f b6 c0             	movzbl %al,%eax
  801770:	29 c2                	sub    %eax,%edx
  801772:	89 d0                	mov    %edx,%eax
  801774:	eb 18                	jmp    80178e <memcmp+0x50>
		s1++, s2++;
  801776:	ff 45 fc             	incl   -0x4(%ebp)
  801779:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80177c:	8b 45 10             	mov    0x10(%ebp),%eax
  80177f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801782:	89 55 10             	mov    %edx,0x10(%ebp)
  801785:	85 c0                	test   %eax,%eax
  801787:	75 c9                	jne    801752 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801789:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801796:	8b 55 08             	mov    0x8(%ebp),%edx
  801799:	8b 45 10             	mov    0x10(%ebp),%eax
  80179c:	01 d0                	add    %edx,%eax
  80179e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8017a1:	eb 15                	jmp    8017b8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	8a 00                	mov    (%eax),%al
  8017a8:	0f b6 d0             	movzbl %al,%edx
  8017ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ae:	0f b6 c0             	movzbl %al,%eax
  8017b1:	39 c2                	cmp    %eax,%edx
  8017b3:	74 0d                	je     8017c2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017b5:	ff 45 08             	incl   0x8(%ebp)
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8017be:	72 e3                	jb     8017a3 <memfind+0x13>
  8017c0:	eb 01                	jmp    8017c3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8017c2:	90                   	nop
	return (void *) s;
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017dc:	eb 03                	jmp    8017e1 <strtol+0x19>
		s++;
  8017de:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	8a 00                	mov    (%eax),%al
  8017e6:	3c 20                	cmp    $0x20,%al
  8017e8:	74 f4                	je     8017de <strtol+0x16>
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	8a 00                	mov    (%eax),%al
  8017ef:	3c 09                	cmp    $0x9,%al
  8017f1:	74 eb                	je     8017de <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	8a 00                	mov    (%eax),%al
  8017f8:	3c 2b                	cmp    $0x2b,%al
  8017fa:	75 05                	jne    801801 <strtol+0x39>
		s++;
  8017fc:	ff 45 08             	incl   0x8(%ebp)
  8017ff:	eb 13                	jmp    801814 <strtol+0x4c>
	else if (*s == '-')
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	8a 00                	mov    (%eax),%al
  801806:	3c 2d                	cmp    $0x2d,%al
  801808:	75 0a                	jne    801814 <strtol+0x4c>
		s++, neg = 1;
  80180a:	ff 45 08             	incl   0x8(%ebp)
  80180d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801814:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801818:	74 06                	je     801820 <strtol+0x58>
  80181a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80181e:	75 20                	jne    801840 <strtol+0x78>
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	8a 00                	mov    (%eax),%al
  801825:	3c 30                	cmp    $0x30,%al
  801827:	75 17                	jne    801840 <strtol+0x78>
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	40                   	inc    %eax
  80182d:	8a 00                	mov    (%eax),%al
  80182f:	3c 78                	cmp    $0x78,%al
  801831:	75 0d                	jne    801840 <strtol+0x78>
		s += 2, base = 16;
  801833:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801837:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80183e:	eb 28                	jmp    801868 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801840:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801844:	75 15                	jne    80185b <strtol+0x93>
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	3c 30                	cmp    $0x30,%al
  80184d:	75 0c                	jne    80185b <strtol+0x93>
		s++, base = 8;
  80184f:	ff 45 08             	incl   0x8(%ebp)
  801852:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801859:	eb 0d                	jmp    801868 <strtol+0xa0>
	else if (base == 0)
  80185b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80185f:	75 07                	jne    801868 <strtol+0xa0>
		base = 10;
  801861:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8a 00                	mov    (%eax),%al
  80186d:	3c 2f                	cmp    $0x2f,%al
  80186f:	7e 19                	jle    80188a <strtol+0xc2>
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	8a 00                	mov    (%eax),%al
  801876:	3c 39                	cmp    $0x39,%al
  801878:	7f 10                	jg     80188a <strtol+0xc2>
			dig = *s - '0';
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	8a 00                	mov    (%eax),%al
  80187f:	0f be c0             	movsbl %al,%eax
  801882:	83 e8 30             	sub    $0x30,%eax
  801885:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801888:	eb 42                	jmp    8018cc <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 00                	mov    (%eax),%al
  80188f:	3c 60                	cmp    $0x60,%al
  801891:	7e 19                	jle    8018ac <strtol+0xe4>
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	8a 00                	mov    (%eax),%al
  801898:	3c 7a                	cmp    $0x7a,%al
  80189a:	7f 10                	jg     8018ac <strtol+0xe4>
			dig = *s - 'a' + 10;
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	8a 00                	mov    (%eax),%al
  8018a1:	0f be c0             	movsbl %al,%eax
  8018a4:	83 e8 57             	sub    $0x57,%eax
  8018a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018aa:	eb 20                	jmp    8018cc <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	8a 00                	mov    (%eax),%al
  8018b1:	3c 40                	cmp    $0x40,%al
  8018b3:	7e 39                	jle    8018ee <strtol+0x126>
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	3c 5a                	cmp    $0x5a,%al
  8018bc:	7f 30                	jg     8018ee <strtol+0x126>
			dig = *s - 'A' + 10;
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	8a 00                	mov    (%eax),%al
  8018c3:	0f be c0             	movsbl %al,%eax
  8018c6:	83 e8 37             	sub    $0x37,%eax
  8018c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8018cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018d2:	7d 19                	jge    8018ed <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018d4:	ff 45 08             	incl   0x8(%ebp)
  8018d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018da:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018de:	89 c2                	mov    %eax,%edx
  8018e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e3:	01 d0                	add    %edx,%eax
  8018e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018e8:	e9 7b ff ff ff       	jmp    801868 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018ed:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018f2:	74 08                	je     8018fc <strtol+0x134>
		*endptr = (char *) s;
  8018f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8018fa:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801900:	74 07                	je     801909 <strtol+0x141>
  801902:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801905:	f7 d8                	neg    %eax
  801907:	eb 03                	jmp    80190c <strtol+0x144>
  801909:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <ltostr>:

void
ltostr(long value, char *str)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801914:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80191b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801922:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801926:	79 13                	jns    80193b <ltostr+0x2d>
	{
		neg = 1;
  801928:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80192f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801932:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801935:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801938:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801943:	99                   	cltd   
  801944:	f7 f9                	idiv   %ecx
  801946:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801949:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80194c:	8d 50 01             	lea    0x1(%eax),%edx
  80194f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801952:	89 c2                	mov    %eax,%edx
  801954:	8b 45 0c             	mov    0xc(%ebp),%eax
  801957:	01 d0                	add    %edx,%eax
  801959:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80195c:	83 c2 30             	add    $0x30,%edx
  80195f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801961:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801964:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801969:	f7 e9                	imul   %ecx
  80196b:	c1 fa 02             	sar    $0x2,%edx
  80196e:	89 c8                	mov    %ecx,%eax
  801970:	c1 f8 1f             	sar    $0x1f,%eax
  801973:	29 c2                	sub    %eax,%edx
  801975:	89 d0                	mov    %edx,%eax
  801977:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80197a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80197d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801982:	f7 e9                	imul   %ecx
  801984:	c1 fa 02             	sar    $0x2,%edx
  801987:	89 c8                	mov    %ecx,%eax
  801989:	c1 f8 1f             	sar    $0x1f,%eax
  80198c:	29 c2                	sub    %eax,%edx
  80198e:	89 d0                	mov    %edx,%eax
  801990:	c1 e0 02             	shl    $0x2,%eax
  801993:	01 d0                	add    %edx,%eax
  801995:	01 c0                	add    %eax,%eax
  801997:	29 c1                	sub    %eax,%ecx
  801999:	89 ca                	mov    %ecx,%edx
  80199b:	85 d2                	test   %edx,%edx
  80199d:	75 9c                	jne    80193b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80199f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8019a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019a9:	48                   	dec    %eax
  8019aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8019ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8019b1:	74 3d                	je     8019f0 <ltostr+0xe2>
		start = 1 ;
  8019b3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8019ba:	eb 34                	jmp    8019f0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8019bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c2:	01 d0                	add    %edx,%eax
  8019c4:	8a 00                	mov    (%eax),%al
  8019c6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8019c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cf:	01 c2                	add    %eax,%edx
  8019d1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d7:	01 c8                	add    %ecx,%eax
  8019d9:	8a 00                	mov    (%eax),%al
  8019db:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e3:	01 c2                	add    %eax,%edx
  8019e5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019e8:	88 02                	mov    %al,(%edx)
		start++ ;
  8019ea:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019ed:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019f6:	7c c4                	jl     8019bc <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019f8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fe:	01 d0                	add    %edx,%eax
  801a00:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a0c:	ff 75 08             	pushl  0x8(%ebp)
  801a0f:	e8 54 fa ff ff       	call   801468 <strlen>
  801a14:	83 c4 04             	add    $0x4,%esp
  801a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	e8 46 fa ff ff       	call   801468 <strlen>
  801a22:	83 c4 04             	add    $0x4,%esp
  801a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a28:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a36:	eb 17                	jmp    801a4f <strcconcat+0x49>
		final[s] = str1[s] ;
  801a38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a3b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3e:	01 c2                	add    %eax,%edx
  801a40:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	01 c8                	add    %ecx,%eax
  801a48:	8a 00                	mov    (%eax),%al
  801a4a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a4c:	ff 45 fc             	incl   -0x4(%ebp)
  801a4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a52:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a55:	7c e1                	jl     801a38 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a57:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a5e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a65:	eb 1f                	jmp    801a86 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a6a:	8d 50 01             	lea    0x1(%eax),%edx
  801a6d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a70:	89 c2                	mov    %eax,%edx
  801a72:	8b 45 10             	mov    0x10(%ebp),%eax
  801a75:	01 c2                	add    %eax,%edx
  801a77:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7d:	01 c8                	add    %ecx,%eax
  801a7f:	8a 00                	mov    (%eax),%al
  801a81:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a83:	ff 45 f8             	incl   -0x8(%ebp)
  801a86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a89:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a8c:	7c d9                	jl     801a67 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a91:	8b 45 10             	mov    0x10(%ebp),%eax
  801a94:	01 d0                	add    %edx,%eax
  801a96:	c6 00 00             	movb   $0x0,(%eax)
}
  801a99:	90                   	nop
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a9f:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801aa8:	8b 45 14             	mov    0x14(%ebp),%eax
  801aab:	8b 00                	mov    (%eax),%eax
  801aad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ab4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab7:	01 d0                	add    %edx,%eax
  801ab9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801abf:	eb 0c                	jmp    801acd <strsplit+0x31>
			*string++ = 0;
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	8d 50 01             	lea    0x1(%eax),%edx
  801ac7:	89 55 08             	mov    %edx,0x8(%ebp)
  801aca:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	8a 00                	mov    (%eax),%al
  801ad2:	84 c0                	test   %al,%al
  801ad4:	74 18                	je     801aee <strsplit+0x52>
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	8a 00                	mov    (%eax),%al
  801adb:	0f be c0             	movsbl %al,%eax
  801ade:	50                   	push   %eax
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	e8 13 fb ff ff       	call   8015fa <strchr>
  801ae7:	83 c4 08             	add    $0x8,%esp
  801aea:	85 c0                	test   %eax,%eax
  801aec:	75 d3                	jne    801ac1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	8a 00                	mov    (%eax),%al
  801af3:	84 c0                	test   %al,%al
  801af5:	74 5a                	je     801b51 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801af7:	8b 45 14             	mov    0x14(%ebp),%eax
  801afa:	8b 00                	mov    (%eax),%eax
  801afc:	83 f8 0f             	cmp    $0xf,%eax
  801aff:	75 07                	jne    801b08 <strsplit+0x6c>
		{
			return 0;
  801b01:	b8 00 00 00 00       	mov    $0x0,%eax
  801b06:	eb 66                	jmp    801b6e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b08:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0b:	8b 00                	mov    (%eax),%eax
  801b0d:	8d 48 01             	lea    0x1(%eax),%ecx
  801b10:	8b 55 14             	mov    0x14(%ebp),%edx
  801b13:	89 0a                	mov    %ecx,(%edx)
  801b15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1f:	01 c2                	add    %eax,%edx
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b26:	eb 03                	jmp    801b2b <strsplit+0x8f>
			string++;
  801b28:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	8a 00                	mov    (%eax),%al
  801b30:	84 c0                	test   %al,%al
  801b32:	74 8b                	je     801abf <strsplit+0x23>
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	8a 00                	mov    (%eax),%al
  801b39:	0f be c0             	movsbl %al,%eax
  801b3c:	50                   	push   %eax
  801b3d:	ff 75 0c             	pushl  0xc(%ebp)
  801b40:	e8 b5 fa ff ff       	call   8015fa <strchr>
  801b45:	83 c4 08             	add    $0x8,%esp
  801b48:	85 c0                	test   %eax,%eax
  801b4a:	74 dc                	je     801b28 <strsplit+0x8c>
			string++;
	}
  801b4c:	e9 6e ff ff ff       	jmp    801abf <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b51:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b52:	8b 45 14             	mov    0x14(%ebp),%eax
  801b55:	8b 00                	mov    (%eax),%eax
  801b57:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b5e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b61:	01 d0                	add    %edx,%eax
  801b63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b69:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  801b76:	83 ec 04             	sub    $0x4,%esp
  801b79:	68 d0 2c 80 00       	push   $0x802cd0
  801b7e:	6a 0e                	push   $0xe
  801b80:	68 0a 2d 80 00       	push   $0x802d0a
  801b85:	e8 a8 ef ff ff       	call   800b32 <_panic>

00801b8a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801b90:	a1 04 30 80 00       	mov    0x803004,%eax
  801b95:	85 c0                	test   %eax,%eax
  801b97:	74 0f                	je     801ba8 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801b99:	e8 d2 ff ff ff       	call   801b70 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b9e:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801ba5:	00 00 00 
	}
	if (size == 0) return NULL ;
  801ba8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bac:	75 07                	jne    801bb5 <malloc+0x2b>
  801bae:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb3:	eb 14                	jmp    801bc9 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801bb5:	83 ec 04             	sub    $0x4,%esp
  801bb8:	68 18 2d 80 00       	push   $0x802d18
  801bbd:	6a 2e                	push   $0x2e
  801bbf:	68 0a 2d 80 00       	push   $0x802d0a
  801bc4:	e8 69 ef ff ff       	call   800b32 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801bd1:	83 ec 04             	sub    $0x4,%esp
  801bd4:	68 40 2d 80 00       	push   $0x802d40
  801bd9:	6a 49                	push   $0x49
  801bdb:	68 0a 2d 80 00       	push   $0x802d0a
  801be0:	e8 4d ef ff ff       	call   800b32 <_panic>

00801be5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	83 ec 18             	sub    $0x18,%esp
  801beb:	8b 45 10             	mov    0x10(%ebp),%eax
  801bee:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801bf1:	83 ec 04             	sub    $0x4,%esp
  801bf4:	68 64 2d 80 00       	push   $0x802d64
  801bf9:	6a 57                	push   $0x57
  801bfb:	68 0a 2d 80 00       	push   $0x802d0a
  801c00:	e8 2d ef ff ff       	call   800b32 <_panic>

00801c05 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801c0b:	83 ec 04             	sub    $0x4,%esp
  801c0e:	68 8c 2d 80 00       	push   $0x802d8c
  801c13:	6a 60                	push   $0x60
  801c15:	68 0a 2d 80 00       	push   $0x802d0a
  801c1a:	e8 13 ef ff ff       	call   800b32 <_panic>

00801c1f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c25:	83 ec 04             	sub    $0x4,%esp
  801c28:	68 b0 2d 80 00       	push   $0x802db0
  801c2d:	6a 7c                	push   $0x7c
  801c2f:	68 0a 2d 80 00       	push   $0x802d0a
  801c34:	e8 f9 ee ff ff       	call   800b32 <_panic>

00801c39 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c3f:	83 ec 04             	sub    $0x4,%esp
  801c42:	68 d8 2d 80 00       	push   $0x802dd8
  801c47:	68 86 00 00 00       	push   $0x86
  801c4c:	68 0a 2d 80 00       	push   $0x802d0a
  801c51:	e8 dc ee ff ff       	call   800b32 <_panic>

00801c56 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	68 fc 2d 80 00       	push   $0x802dfc
  801c64:	68 91 00 00 00       	push   $0x91
  801c69:	68 0a 2d 80 00       	push   $0x802d0a
  801c6e:	e8 bf ee ff ff       	call   800b32 <_panic>

00801c73 <shrink>:

}
void shrink(uint32 newSize)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c79:	83 ec 04             	sub    $0x4,%esp
  801c7c:	68 fc 2d 80 00       	push   $0x802dfc
  801c81:	68 96 00 00 00       	push   $0x96
  801c86:	68 0a 2d 80 00       	push   $0x802d0a
  801c8b:	e8 a2 ee ff ff       	call   800b32 <_panic>

00801c90 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c96:	83 ec 04             	sub    $0x4,%esp
  801c99:	68 fc 2d 80 00       	push   $0x802dfc
  801c9e:	68 9b 00 00 00       	push   $0x9b
  801ca3:	68 0a 2d 80 00       	push   $0x802d0a
  801ca8:	e8 85 ee ff ff       	call   800b32 <_panic>

00801cad <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	57                   	push   %edi
  801cb1:	56                   	push   %esi
  801cb2:	53                   	push   %ebx
  801cb3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cbf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cc2:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cc5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cc8:	cd 30                	int    $0x30
  801cca:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	5b                   	pop    %ebx
  801cd4:	5e                   	pop    %esi
  801cd5:	5f                   	pop    %edi
  801cd6:	5d                   	pop    %ebp
  801cd7:	c3                   	ret    

00801cd8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	83 ec 04             	sub    $0x4,%esp
  801cde:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ce4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	52                   	push   %edx
  801cf0:	ff 75 0c             	pushl  0xc(%ebp)
  801cf3:	50                   	push   %eax
  801cf4:	6a 00                	push   $0x0
  801cf6:	e8 b2 ff ff ff       	call   801cad <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	90                   	nop
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 01                	push   $0x1
  801d10:	e8 98 ff ff ff       	call   801cad <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	52                   	push   %edx
  801d2a:	50                   	push   %eax
  801d2b:	6a 05                	push   $0x5
  801d2d:	e8 7b ff ff ff       	call   801cad <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	56                   	push   %esi
  801d3b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d3c:	8b 75 18             	mov    0x18(%ebp),%esi
  801d3f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	56                   	push   %esi
  801d4c:	53                   	push   %ebx
  801d4d:	51                   	push   %ecx
  801d4e:	52                   	push   %edx
  801d4f:	50                   	push   %eax
  801d50:	6a 06                	push   $0x6
  801d52:	e8 56 ff ff ff       	call   801cad <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
}
  801d5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d5d:	5b                   	pop    %ebx
  801d5e:	5e                   	pop    %esi
  801d5f:	5d                   	pop    %ebp
  801d60:	c3                   	ret    

00801d61 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	52                   	push   %edx
  801d71:	50                   	push   %eax
  801d72:	6a 07                	push   $0x7
  801d74:	e8 34 ff ff ff       	call   801cad <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	ff 75 0c             	pushl  0xc(%ebp)
  801d8a:	ff 75 08             	pushl  0x8(%ebp)
  801d8d:	6a 08                	push   $0x8
  801d8f:	e8 19 ff ff ff       	call   801cad <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 09                	push   $0x9
  801da8:	e8 00 ff ff ff       	call   801cad <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 0a                	push   $0xa
  801dc1:	e8 e7 fe ff ff       	call   801cad <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 0b                	push   $0xb
  801dda:	e8 ce fe ff ff       	call   801cad <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	ff 75 0c             	pushl  0xc(%ebp)
  801df0:	ff 75 08             	pushl  0x8(%ebp)
  801df3:	6a 0f                	push   $0xf
  801df5:	e8 b3 fe ff ff       	call   801cad <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
	return;
  801dfd:	90                   	nop
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	ff 75 0c             	pushl  0xc(%ebp)
  801e0c:	ff 75 08             	pushl  0x8(%ebp)
  801e0f:	6a 10                	push   $0x10
  801e11:	e8 97 fe ff ff       	call   801cad <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
	return ;
  801e19:	90                   	nop
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	ff 75 10             	pushl  0x10(%ebp)
  801e26:	ff 75 0c             	pushl  0xc(%ebp)
  801e29:	ff 75 08             	pushl  0x8(%ebp)
  801e2c:	6a 11                	push   $0x11
  801e2e:	e8 7a fe ff ff       	call   801cad <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
	return ;
  801e36:	90                   	nop
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 0c                	push   $0xc
  801e48:	e8 60 fe ff ff       	call   801cad <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	ff 75 08             	pushl  0x8(%ebp)
  801e60:	6a 0d                	push   $0xd
  801e62:	e8 46 fe ff ff       	call   801cad <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 0e                	push   $0xe
  801e7b:	e8 2d fe ff ff       	call   801cad <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
}
  801e83:	90                   	nop
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 13                	push   $0x13
  801e95:	e8 13 fe ff ff       	call   801cad <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
}
  801e9d:	90                   	nop
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 14                	push   $0x14
  801eaf:	e8 f9 fd ff ff       	call   801cad <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
}
  801eb7:	90                   	nop
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <sys_cputc>:


void
sys_cputc(const char c)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 04             	sub    $0x4,%esp
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ec6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	50                   	push   %eax
  801ed3:	6a 15                	push   $0x15
  801ed5:	e8 d3 fd ff ff       	call   801cad <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
}
  801edd:	90                   	nop
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 16                	push   $0x16
  801eef:	e8 b9 fd ff ff       	call   801cad <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	90                   	nop
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801efd:	8b 45 08             	mov    0x8(%ebp),%eax
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	ff 75 0c             	pushl  0xc(%ebp)
  801f09:	50                   	push   %eax
  801f0a:	6a 17                	push   $0x17
  801f0c:	e8 9c fd ff ff       	call   801cad <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	52                   	push   %edx
  801f26:	50                   	push   %eax
  801f27:	6a 1a                	push   $0x1a
  801f29:	e8 7f fd ff ff       	call   801cad <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f39:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	52                   	push   %edx
  801f43:	50                   	push   %eax
  801f44:	6a 18                	push   $0x18
  801f46:	e8 62 fd ff ff       	call   801cad <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
}
  801f4e:	90                   	nop
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	52                   	push   %edx
  801f61:	50                   	push   %eax
  801f62:	6a 19                	push   $0x19
  801f64:	e8 44 fd ff ff       	call   801cad <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
}
  801f6c:	90                   	nop
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 04             	sub    $0x4,%esp
  801f75:	8b 45 10             	mov    0x10(%ebp),%eax
  801f78:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f7b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f7e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	6a 00                	push   $0x0
  801f87:	51                   	push   %ecx
  801f88:	52                   	push   %edx
  801f89:	ff 75 0c             	pushl  0xc(%ebp)
  801f8c:	50                   	push   %eax
  801f8d:	6a 1b                	push   $0x1b
  801f8f:	e8 19 fd ff ff       	call   801cad <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	52                   	push   %edx
  801fa9:	50                   	push   %eax
  801faa:	6a 1c                	push   $0x1c
  801fac:	e8 fc fc ff ff       	call   801cad <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	51                   	push   %ecx
  801fc7:	52                   	push   %edx
  801fc8:	50                   	push   %eax
  801fc9:	6a 1d                	push   $0x1d
  801fcb:	e8 dd fc ff ff       	call   801cad <syscall>
  801fd0:	83 c4 18             	add    $0x18,%esp
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	52                   	push   %edx
  801fe5:	50                   	push   %eax
  801fe6:	6a 1e                	push   $0x1e
  801fe8:	e8 c0 fc ff ff       	call   801cad <syscall>
  801fed:	83 c4 18             	add    $0x18,%esp
}
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 1f                	push   $0x1f
  802001:	e8 a7 fc ff ff       	call   801cad <syscall>
  802006:	83 c4 18             	add    $0x18,%esp
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	6a 00                	push   $0x0
  802013:	ff 75 14             	pushl  0x14(%ebp)
  802016:	ff 75 10             	pushl  0x10(%ebp)
  802019:	ff 75 0c             	pushl  0xc(%ebp)
  80201c:	50                   	push   %eax
  80201d:	6a 20                	push   $0x20
  80201f:	e8 89 fc ff ff       	call   801cad <syscall>
  802024:	83 c4 18             	add    $0x18,%esp
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	50                   	push   %eax
  802038:	6a 21                	push   $0x21
  80203a:	e8 6e fc ff ff       	call   801cad <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
}
  802042:	90                   	nop
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	50                   	push   %eax
  802054:	6a 22                	push   $0x22
  802056:	e8 52 fc ff ff       	call   801cad <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 02                	push   $0x2
  80206f:	e8 39 fc ff ff       	call   801cad <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 03                	push   $0x3
  802088:	e8 20 fc ff ff       	call   801cad <syscall>
  80208d:	83 c4 18             	add    $0x18,%esp
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 04                	push   $0x4
  8020a1:	e8 07 fc ff ff       	call   801cad <syscall>
  8020a6:	83 c4 18             	add    $0x18,%esp
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <sys_exit_env>:


void sys_exit_env(void)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 23                	push   $0x23
  8020ba:	e8 ee fb ff ff       	call   801cad <syscall>
  8020bf:	83 c4 18             	add    $0x18,%esp
}
  8020c2:	90                   	nop
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020cb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020ce:	8d 50 04             	lea    0x4(%eax),%edx
  8020d1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	52                   	push   %edx
  8020db:	50                   	push   %eax
  8020dc:	6a 24                	push   $0x24
  8020de:	e8 ca fb ff ff       	call   801cad <syscall>
  8020e3:	83 c4 18             	add    $0x18,%esp
	return result;
  8020e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020ef:	89 01                	mov    %eax,(%ecx)
  8020f1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	c9                   	leave  
  8020f8:	c2 04 00             	ret    $0x4

008020fb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	ff 75 10             	pushl  0x10(%ebp)
  802105:	ff 75 0c             	pushl  0xc(%ebp)
  802108:	ff 75 08             	pushl  0x8(%ebp)
  80210b:	6a 12                	push   $0x12
  80210d:	e8 9b fb ff ff       	call   801cad <syscall>
  802112:	83 c4 18             	add    $0x18,%esp
	return ;
  802115:	90                   	nop
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <sys_rcr2>:
uint32 sys_rcr2()
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 25                	push   $0x25
  802127:	e8 81 fb ff ff       	call   801cad <syscall>
  80212c:	83 c4 18             	add    $0x18,%esp
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	83 ec 04             	sub    $0x4,%esp
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80213d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	50                   	push   %eax
  80214a:	6a 26                	push   $0x26
  80214c:	e8 5c fb ff ff       	call   801cad <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
	return ;
  802154:	90                   	nop
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <rsttst>:
void rsttst()
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 28                	push   $0x28
  802166:	e8 42 fb ff ff       	call   801cad <syscall>
  80216b:	83 c4 18             	add    $0x18,%esp
	return ;
  80216e:	90                   	nop
}
  80216f:	c9                   	leave  
  802170:	c3                   	ret    

00802171 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
  802174:	83 ec 04             	sub    $0x4,%esp
  802177:	8b 45 14             	mov    0x14(%ebp),%eax
  80217a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80217d:	8b 55 18             	mov    0x18(%ebp),%edx
  802180:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802184:	52                   	push   %edx
  802185:	50                   	push   %eax
  802186:	ff 75 10             	pushl  0x10(%ebp)
  802189:	ff 75 0c             	pushl  0xc(%ebp)
  80218c:	ff 75 08             	pushl  0x8(%ebp)
  80218f:	6a 27                	push   $0x27
  802191:	e8 17 fb ff ff       	call   801cad <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
	return ;
  802199:	90                   	nop
}
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <chktst>:
void chktst(uint32 n)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	ff 75 08             	pushl  0x8(%ebp)
  8021aa:	6a 29                	push   $0x29
  8021ac:	e8 fc fa ff ff       	call   801cad <syscall>
  8021b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b4:	90                   	nop
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <inctst>:

void inctst()
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 2a                	push   $0x2a
  8021c6:	e8 e2 fa ff ff       	call   801cad <syscall>
  8021cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ce:	90                   	nop
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <gettst>:
uint32 gettst()
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 2b                	push   $0x2b
  8021e0:	e8 c8 fa ff ff       	call   801cad <syscall>
  8021e5:	83 c4 18             	add    $0x18,%esp
}
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 2c                	push   $0x2c
  8021fc:	e8 ac fa ff ff       	call   801cad <syscall>
  802201:	83 c4 18             	add    $0x18,%esp
  802204:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802207:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80220b:	75 07                	jne    802214 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80220d:	b8 01 00 00 00       	mov    $0x1,%eax
  802212:	eb 05                	jmp    802219 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802214:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 2c                	push   $0x2c
  80222d:	e8 7b fa ff ff       	call   801cad <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
  802235:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802238:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80223c:	75 07                	jne    802245 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80223e:	b8 01 00 00 00       	mov    $0x1,%eax
  802243:	eb 05                	jmp    80224a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802245:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 2c                	push   $0x2c
  80225e:	e8 4a fa ff ff       	call   801cad <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
  802266:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802269:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80226d:	75 07                	jne    802276 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80226f:	b8 01 00 00 00       	mov    $0x1,%eax
  802274:	eb 05                	jmp    80227b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802276:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 2c                	push   $0x2c
  80228f:	e8 19 fa ff ff       	call   801cad <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
  802297:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80229a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80229e:	75 07                	jne    8022a7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a5:	eb 05                	jmp    8022ac <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	ff 75 08             	pushl  0x8(%ebp)
  8022bc:	6a 2d                	push   $0x2d
  8022be:	e8 ea f9 ff ff       	call   801cad <syscall>
  8022c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c6:	90                   	nop
}
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	6a 00                	push   $0x0
  8022db:	53                   	push   %ebx
  8022dc:	51                   	push   %ecx
  8022dd:	52                   	push   %edx
  8022de:	50                   	push   %eax
  8022df:	6a 2e                	push   $0x2e
  8022e1:	e8 c7 f9 ff ff       	call   801cad <syscall>
  8022e6:	83 c4 18             	add    $0x18,%esp
}
  8022e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	52                   	push   %edx
  8022fe:	50                   	push   %eax
  8022ff:	6a 2f                	push   $0x2f
  802301:	e8 a7 f9 ff ff       	call   801cad <syscall>
  802306:	83 c4 18             	add    $0x18,%esp
}
  802309:	c9                   	leave  
  80230a:	c3                   	ret    
  80230b:	90                   	nop

0080230c <__udivdi3>:
  80230c:	55                   	push   %ebp
  80230d:	57                   	push   %edi
  80230e:	56                   	push   %esi
  80230f:	53                   	push   %ebx
  802310:	83 ec 1c             	sub    $0x1c,%esp
  802313:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802317:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80231b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80231f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802323:	89 ca                	mov    %ecx,%edx
  802325:	89 f8                	mov    %edi,%eax
  802327:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80232b:	85 f6                	test   %esi,%esi
  80232d:	75 2d                	jne    80235c <__udivdi3+0x50>
  80232f:	39 cf                	cmp    %ecx,%edi
  802331:	77 65                	ja     802398 <__udivdi3+0x8c>
  802333:	89 fd                	mov    %edi,%ebp
  802335:	85 ff                	test   %edi,%edi
  802337:	75 0b                	jne    802344 <__udivdi3+0x38>
  802339:	b8 01 00 00 00       	mov    $0x1,%eax
  80233e:	31 d2                	xor    %edx,%edx
  802340:	f7 f7                	div    %edi
  802342:	89 c5                	mov    %eax,%ebp
  802344:	31 d2                	xor    %edx,%edx
  802346:	89 c8                	mov    %ecx,%eax
  802348:	f7 f5                	div    %ebp
  80234a:	89 c1                	mov    %eax,%ecx
  80234c:	89 d8                	mov    %ebx,%eax
  80234e:	f7 f5                	div    %ebp
  802350:	89 cf                	mov    %ecx,%edi
  802352:	89 fa                	mov    %edi,%edx
  802354:	83 c4 1c             	add    $0x1c,%esp
  802357:	5b                   	pop    %ebx
  802358:	5e                   	pop    %esi
  802359:	5f                   	pop    %edi
  80235a:	5d                   	pop    %ebp
  80235b:	c3                   	ret    
  80235c:	39 ce                	cmp    %ecx,%esi
  80235e:	77 28                	ja     802388 <__udivdi3+0x7c>
  802360:	0f bd fe             	bsr    %esi,%edi
  802363:	83 f7 1f             	xor    $0x1f,%edi
  802366:	75 40                	jne    8023a8 <__udivdi3+0x9c>
  802368:	39 ce                	cmp    %ecx,%esi
  80236a:	72 0a                	jb     802376 <__udivdi3+0x6a>
  80236c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802370:	0f 87 9e 00 00 00    	ja     802414 <__udivdi3+0x108>
  802376:	b8 01 00 00 00       	mov    $0x1,%eax
  80237b:	89 fa                	mov    %edi,%edx
  80237d:	83 c4 1c             	add    $0x1c,%esp
  802380:	5b                   	pop    %ebx
  802381:	5e                   	pop    %esi
  802382:	5f                   	pop    %edi
  802383:	5d                   	pop    %ebp
  802384:	c3                   	ret    
  802385:	8d 76 00             	lea    0x0(%esi),%esi
  802388:	31 ff                	xor    %edi,%edi
  80238a:	31 c0                	xor    %eax,%eax
  80238c:	89 fa                	mov    %edi,%edx
  80238e:	83 c4 1c             	add    $0x1c,%esp
  802391:	5b                   	pop    %ebx
  802392:	5e                   	pop    %esi
  802393:	5f                   	pop    %edi
  802394:	5d                   	pop    %ebp
  802395:	c3                   	ret    
  802396:	66 90                	xchg   %ax,%ax
  802398:	89 d8                	mov    %ebx,%eax
  80239a:	f7 f7                	div    %edi
  80239c:	31 ff                	xor    %edi,%edi
  80239e:	89 fa                	mov    %edi,%edx
  8023a0:	83 c4 1c             	add    $0x1c,%esp
  8023a3:	5b                   	pop    %ebx
  8023a4:	5e                   	pop    %esi
  8023a5:	5f                   	pop    %edi
  8023a6:	5d                   	pop    %ebp
  8023a7:	c3                   	ret    
  8023a8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8023ad:	89 eb                	mov    %ebp,%ebx
  8023af:	29 fb                	sub    %edi,%ebx
  8023b1:	89 f9                	mov    %edi,%ecx
  8023b3:	d3 e6                	shl    %cl,%esi
  8023b5:	89 c5                	mov    %eax,%ebp
  8023b7:	88 d9                	mov    %bl,%cl
  8023b9:	d3 ed                	shr    %cl,%ebp
  8023bb:	89 e9                	mov    %ebp,%ecx
  8023bd:	09 f1                	or     %esi,%ecx
  8023bf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8023c3:	89 f9                	mov    %edi,%ecx
  8023c5:	d3 e0                	shl    %cl,%eax
  8023c7:	89 c5                	mov    %eax,%ebp
  8023c9:	89 d6                	mov    %edx,%esi
  8023cb:	88 d9                	mov    %bl,%cl
  8023cd:	d3 ee                	shr    %cl,%esi
  8023cf:	89 f9                	mov    %edi,%ecx
  8023d1:	d3 e2                	shl    %cl,%edx
  8023d3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8023d7:	88 d9                	mov    %bl,%cl
  8023d9:	d3 e8                	shr    %cl,%eax
  8023db:	09 c2                	or     %eax,%edx
  8023dd:	89 d0                	mov    %edx,%eax
  8023df:	89 f2                	mov    %esi,%edx
  8023e1:	f7 74 24 0c          	divl   0xc(%esp)
  8023e5:	89 d6                	mov    %edx,%esi
  8023e7:	89 c3                	mov    %eax,%ebx
  8023e9:	f7 e5                	mul    %ebp
  8023eb:	39 d6                	cmp    %edx,%esi
  8023ed:	72 19                	jb     802408 <__udivdi3+0xfc>
  8023ef:	74 0b                	je     8023fc <__udivdi3+0xf0>
  8023f1:	89 d8                	mov    %ebx,%eax
  8023f3:	31 ff                	xor    %edi,%edi
  8023f5:	e9 58 ff ff ff       	jmp    802352 <__udivdi3+0x46>
  8023fa:	66 90                	xchg   %ax,%ax
  8023fc:	8b 54 24 08          	mov    0x8(%esp),%edx
  802400:	89 f9                	mov    %edi,%ecx
  802402:	d3 e2                	shl    %cl,%edx
  802404:	39 c2                	cmp    %eax,%edx
  802406:	73 e9                	jae    8023f1 <__udivdi3+0xe5>
  802408:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80240b:	31 ff                	xor    %edi,%edi
  80240d:	e9 40 ff ff ff       	jmp    802352 <__udivdi3+0x46>
  802412:	66 90                	xchg   %ax,%ax
  802414:	31 c0                	xor    %eax,%eax
  802416:	e9 37 ff ff ff       	jmp    802352 <__udivdi3+0x46>
  80241b:	90                   	nop

0080241c <__umoddi3>:
  80241c:	55                   	push   %ebp
  80241d:	57                   	push   %edi
  80241e:	56                   	push   %esi
  80241f:	53                   	push   %ebx
  802420:	83 ec 1c             	sub    $0x1c,%esp
  802423:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802427:	8b 74 24 34          	mov    0x34(%esp),%esi
  80242b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80242f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802433:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802437:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80243b:	89 f3                	mov    %esi,%ebx
  80243d:	89 fa                	mov    %edi,%edx
  80243f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802443:	89 34 24             	mov    %esi,(%esp)
  802446:	85 c0                	test   %eax,%eax
  802448:	75 1a                	jne    802464 <__umoddi3+0x48>
  80244a:	39 f7                	cmp    %esi,%edi
  80244c:	0f 86 a2 00 00 00    	jbe    8024f4 <__umoddi3+0xd8>
  802452:	89 c8                	mov    %ecx,%eax
  802454:	89 f2                	mov    %esi,%edx
  802456:	f7 f7                	div    %edi
  802458:	89 d0                	mov    %edx,%eax
  80245a:	31 d2                	xor    %edx,%edx
  80245c:	83 c4 1c             	add    $0x1c,%esp
  80245f:	5b                   	pop    %ebx
  802460:	5e                   	pop    %esi
  802461:	5f                   	pop    %edi
  802462:	5d                   	pop    %ebp
  802463:	c3                   	ret    
  802464:	39 f0                	cmp    %esi,%eax
  802466:	0f 87 ac 00 00 00    	ja     802518 <__umoddi3+0xfc>
  80246c:	0f bd e8             	bsr    %eax,%ebp
  80246f:	83 f5 1f             	xor    $0x1f,%ebp
  802472:	0f 84 ac 00 00 00    	je     802524 <__umoddi3+0x108>
  802478:	bf 20 00 00 00       	mov    $0x20,%edi
  80247d:	29 ef                	sub    %ebp,%edi
  80247f:	89 fe                	mov    %edi,%esi
  802481:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802485:	89 e9                	mov    %ebp,%ecx
  802487:	d3 e0                	shl    %cl,%eax
  802489:	89 d7                	mov    %edx,%edi
  80248b:	89 f1                	mov    %esi,%ecx
  80248d:	d3 ef                	shr    %cl,%edi
  80248f:	09 c7                	or     %eax,%edi
  802491:	89 e9                	mov    %ebp,%ecx
  802493:	d3 e2                	shl    %cl,%edx
  802495:	89 14 24             	mov    %edx,(%esp)
  802498:	89 d8                	mov    %ebx,%eax
  80249a:	d3 e0                	shl    %cl,%eax
  80249c:	89 c2                	mov    %eax,%edx
  80249e:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024a2:	d3 e0                	shl    %cl,%eax
  8024a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024ac:	89 f1                	mov    %esi,%ecx
  8024ae:	d3 e8                	shr    %cl,%eax
  8024b0:	09 d0                	or     %edx,%eax
  8024b2:	d3 eb                	shr    %cl,%ebx
  8024b4:	89 da                	mov    %ebx,%edx
  8024b6:	f7 f7                	div    %edi
  8024b8:	89 d3                	mov    %edx,%ebx
  8024ba:	f7 24 24             	mull   (%esp)
  8024bd:	89 c6                	mov    %eax,%esi
  8024bf:	89 d1                	mov    %edx,%ecx
  8024c1:	39 d3                	cmp    %edx,%ebx
  8024c3:	0f 82 87 00 00 00    	jb     802550 <__umoddi3+0x134>
  8024c9:	0f 84 91 00 00 00    	je     802560 <__umoddi3+0x144>
  8024cf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024d3:	29 f2                	sub    %esi,%edx
  8024d5:	19 cb                	sbb    %ecx,%ebx
  8024d7:	89 d8                	mov    %ebx,%eax
  8024d9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8024dd:	d3 e0                	shl    %cl,%eax
  8024df:	89 e9                	mov    %ebp,%ecx
  8024e1:	d3 ea                	shr    %cl,%edx
  8024e3:	09 d0                	or     %edx,%eax
  8024e5:	89 e9                	mov    %ebp,%ecx
  8024e7:	d3 eb                	shr    %cl,%ebx
  8024e9:	89 da                	mov    %ebx,%edx
  8024eb:	83 c4 1c             	add    $0x1c,%esp
  8024ee:	5b                   	pop    %ebx
  8024ef:	5e                   	pop    %esi
  8024f0:	5f                   	pop    %edi
  8024f1:	5d                   	pop    %ebp
  8024f2:	c3                   	ret    
  8024f3:	90                   	nop
  8024f4:	89 fd                	mov    %edi,%ebp
  8024f6:	85 ff                	test   %edi,%edi
  8024f8:	75 0b                	jne    802505 <__umoddi3+0xe9>
  8024fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ff:	31 d2                	xor    %edx,%edx
  802501:	f7 f7                	div    %edi
  802503:	89 c5                	mov    %eax,%ebp
  802505:	89 f0                	mov    %esi,%eax
  802507:	31 d2                	xor    %edx,%edx
  802509:	f7 f5                	div    %ebp
  80250b:	89 c8                	mov    %ecx,%eax
  80250d:	f7 f5                	div    %ebp
  80250f:	89 d0                	mov    %edx,%eax
  802511:	e9 44 ff ff ff       	jmp    80245a <__umoddi3+0x3e>
  802516:	66 90                	xchg   %ax,%ax
  802518:	89 c8                	mov    %ecx,%eax
  80251a:	89 f2                	mov    %esi,%edx
  80251c:	83 c4 1c             	add    $0x1c,%esp
  80251f:	5b                   	pop    %ebx
  802520:	5e                   	pop    %esi
  802521:	5f                   	pop    %edi
  802522:	5d                   	pop    %ebp
  802523:	c3                   	ret    
  802524:	3b 04 24             	cmp    (%esp),%eax
  802527:	72 06                	jb     80252f <__umoddi3+0x113>
  802529:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80252d:	77 0f                	ja     80253e <__umoddi3+0x122>
  80252f:	89 f2                	mov    %esi,%edx
  802531:	29 f9                	sub    %edi,%ecx
  802533:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802537:	89 14 24             	mov    %edx,(%esp)
  80253a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80253e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802542:	8b 14 24             	mov    (%esp),%edx
  802545:	83 c4 1c             	add    $0x1c,%esp
  802548:	5b                   	pop    %ebx
  802549:	5e                   	pop    %esi
  80254a:	5f                   	pop    %edi
  80254b:	5d                   	pop    %ebp
  80254c:	c3                   	ret    
  80254d:	8d 76 00             	lea    0x0(%esi),%esi
  802550:	2b 04 24             	sub    (%esp),%eax
  802553:	19 fa                	sbb    %edi,%edx
  802555:	89 d1                	mov    %edx,%ecx
  802557:	89 c6                	mov    %eax,%esi
  802559:	e9 71 ff ff ff       	jmp    8024cf <__umoddi3+0xb3>
  80255e:	66 90                	xchg   %ax,%ax
  802560:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802564:	72 ea                	jb     802550 <__umoddi3+0x134>
  802566:	89 d9                	mov    %ebx,%ecx
  802568:	e9 62 ff ff ff       	jmp    8024cf <__umoddi3+0xb3>
